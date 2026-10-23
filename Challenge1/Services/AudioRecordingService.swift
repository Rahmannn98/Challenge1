import AVFAudio
import Foundation
import Observation

@Observable
@MainActor
final class AudioRecordingService {
    private let audioEngine = AVAudioEngine()
    private var startedAt: Date?
    private var pausedAt: Date?
    private var pausedDuration: TimeInterval = 0
    private var audioBufferContinuation: AsyncStream<AVAudioPCMBuffer>.Continuation?
    private var bufferProcessingTask: Task<Void, Never>?
    private var lastAudioLevelUpdate = Date.distantPast
    private(set) var isRecording = false
    private(set) var isPaused = false
    private(set) var audioLevel: Float = 0
    private(set) var recordingURL: URL?
    var onAudioBuffer: ((AVAudioPCMBuffer) -> Void)?

    func requestPermission() async -> Bool {
        switch AVAudioApplication.shared.recordPermission {
        case .granted: return true
        case .denied: return false
        case .undetermined:
            return await withCheckedContinuation { continuation in
                AVAudioApplication.requestRecordPermission { continuation.resume(returning: $0) }
            }
        @unknown default: return false
        }
    }

    func startRecording() async throws {
        guard !isRecording else { return }
        guard await requestPermission() else { throw AudioRecordingError.permissionDenied }

        let session = AVAudioSession.sharedInstance()
        try session.setCategory(
            .playAndRecord,
            mode: .measurement,
            options: [.defaultToSpeaker, .allowBluetoothHFP]
        )
        try session.setActive(true)

        let input = audioEngine.inputNode
        let format = input.outputFormat(forBus: 0)
        guard format.sampleRate > 0, format.channelCount > 0 else {
            throw AudioRecordingError.inputUnavailable
        }

        let url = PracticeSessionStore.recordingsDirectory
            .appending(path: "practice-\(UUID().uuidString).caf")
        let audioFile = try AVAudioFile(
            forWriting: url,
            settings: format.settings,
            commonFormat: .pcmFormatFloat32,
            interleaved: false
        )
        let fileWriter = AudioFileWriter(audioFile: audioFile)
        let stream = AsyncStream<AVAudioPCMBuffer>(
            bufferingPolicy: .unbounded
        ) { continuation in
            audioBufferContinuation = continuation
        }

        bufferProcessingTask = Task { [weak self, fileWriter] in
            for await buffer in stream {
                guard !Task.isCancelled else { return }

                try? await fileWriter.write(buffer)

                guard let self else { return }
                self.onAudioBuffer?(buffer)
                self.updateAudioLevel(with: Self.rms(of: buffer))
            }
        }

        recordingURL = url
        input.removeTap(onBus: 0)
        input.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            guard let copy = buffer.copy() as? AVAudioPCMBuffer else { return }
            self?.audioBufferContinuation?.yield(copy)
        }

        audioEngine.prepare()
        try audioEngine.start()
        startedAt = .now
        pausedDuration = 0
        isRecording = true
        isPaused = false
    }

    func pauseRecording() {
        guard isRecording, !isPaused else { return }
        audioEngine.pause()
        pausedAt = .now
        isPaused = true
    }

    func resumeRecording() throws {
        guard isRecording, isPaused else { return }
        if let pausedAt {
            pausedDuration += Date.now.timeIntervalSince(pausedAt)
        }
        self.pausedAt = nil
        try audioEngine.start()
        isPaused = false
    }

    func stopRecording() async -> TimeInterval {
        guard isRecording else { return 0 }

        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        audioBufferContinuation?.finish()
        audioBufferContinuation = nil
        await bufferProcessingTask?.value
        bufferProcessingTask = nil

        let finalPause = pausedAt.map { Date.now.timeIntervalSince($0) } ?? 0
        let duration = max(
            0,
            Date.now.timeIntervalSince(startedAt ?? .now) - pausedDuration - finalPause
        )
        startedAt = nil
        pausedAt = nil
        pausedDuration = 0
        isRecording = false
        isPaused = false
        audioLevel = 0
        try? AVAudioSession.sharedInstance().setActive(
            false,
            options: .notifyOthersOnDeactivation
        )
        return duration
    }

    func cancelRecording() {
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        audioBufferContinuation?.finish()
        audioBufferContinuation = nil
        bufferProcessingTask?.cancel()
        bufferProcessingTask = nil

        startedAt = nil
        pausedAt = nil
        pausedDuration = 0
        isRecording = false
        isPaused = false
        audioLevel = 0

        if let recordingURL {
            try? FileManager.default.removeItem(at: recordingURL)
        }
        recordingURL = nil
        try? AVAudioSession.sharedInstance().setActive(
            false,
            options: .notifyOthersOnDeactivation
        )
    }

    private func updateAudioLevel(with level: Float) {
        guard Date.now.timeIntervalSince(lastAudioLevelUpdate) >= (1.0 / 30.0) else {
            return
        }

        lastAudioLevelUpdate = .now
        audioLevel = level
    }

    private static func rms(of buffer: AVAudioPCMBuffer) -> Float {
        guard let samples = buffer.floatChannelData?[0], buffer.frameLength > 0 else {
            return 0
        }

        let squares = (0..<Int(buffer.frameLength)).reduce(Float.zero) {
            $0 + samples[$1] * samples[$1]
        }
        return min(max(sqrt(squares / Float(buffer.frameLength)) * 8, 0), 1)
    }
}

private actor AudioFileWriter {
    private let audioFile: AVAudioFile

    init(audioFile: AVAudioFile) {
        self.audioFile = audioFile
    }

    func write(_ buffer: AVAudioPCMBuffer) throws {
        try audioFile.write(from: buffer)
    }
}

enum AudioRecordingError: LocalizedError {
    case permissionDenied
    case inputUnavailable

    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            "Microphone permission was denied."
        case .inputUnavailable:
            "A microphone input is not available."
        }
    }
}
