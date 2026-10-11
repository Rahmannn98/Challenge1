import AVFAudio
import Foundation
import Speech

final class SpeechTranscriptionService {
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private(set) var transcript = ""
    var onTranscriptUpdate: (@MainActor (String) -> Void)?

    func requestAuthorization() async -> Bool {
        switch SFSpeechRecognizer.authorizationStatus() {
        case .authorized: return true
        case .denied, .restricted: return false
        case .notDetermined:
            return await withCheckedContinuation { continuation in
                SFSpeechRecognizer.requestAuthorization { continuation.resume(returning: $0 == .authorized) }
            }
        @unknown default: return false
        }
    }

    func start() async throws {
        guard await requestAuthorization() else { throw SpeechTranscriptionError.permissionDenied }
        guard let recognizer, recognizer.isAvailable else { throw SpeechTranscriptionError.recognizerUnavailable }
        stop()
        transcript = ""
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        self.request = request
        task = recognizer.recognitionTask(with: request) { [weak self] result, error in
            guard let self else { return }
            if let result {
                let text = result.bestTranscription.formattedString
                self.transcript = text
                Task { @MainActor in self.onTranscriptUpdate?(text) }
            }
            if error != nil || result?.isFinal == true { self.task = nil }
        }
    }

    func append(_ buffer: AVAudioPCMBuffer) { request?.append(buffer) }

    func stop() {
        request?.endAudio()
        task?.finish()
        request = nil
        task = nil
    }
}

enum SpeechTranscriptionError: LocalizedError {
    case permissionDenied, recognizerUnavailable
    var errorDescription: String? {
        switch self {
        case .permissionDenied: "Speech recognition permission was denied."
        case .recognizerUnavailable: "English speech recognition is currently unavailable."
        }
    }
}
