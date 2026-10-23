import Foundation
import Observation

@Observable
@MainActor
final class PracticeSessionViewModel {
    let topicTitle: String
    let branch: PracticeBranch
    let question: String
    let totalDuration: Int
    let prepStages = PREPStage.allCases
    let sessionID = UUID()
    private let recorder = AudioRecordingService()
    private let transcriber = SpeechTranscriptionService()
    private var timerTask: Task<Void, Never>?
    private var sessionStartedAt: Date?
    var elapsedSeconds = 0
    var isPaused = false
    var isRecording = false
    var transcript = ""
    var alert: PracticeSessionAlert?
    var showsResult = false
    var completedSession: PracticeSessionRecord?

    init(topicTitle: String, branch: PracticeBranch, question: String, totalDuration: Int) {
        self.topicTitle = topicTitle; self.branch = branch; self.question = question; self.totalDuration = max(totalDuration, 1)
        transcriber.onTranscriptUpdate = { [weak self] text in self?.transcript = text }
        recorder.onAudioBuffer = { [weak transcriber] buffer in transcriber?.append(buffer) }
    }

    var progressValue: Double { min(Double(elapsedSeconds) / Double(totalDuration), 1) }
    var remainingTime: Int { max(totalDuration - elapsedSeconds, 0) }
    var remainingTimeString: String { TimeFormatter.practiceTime(remainingTime) }
    var audioLevel: Float { recorder.audioLevel }
    var activeStage: PREPStage { prepStages[min(3, Int(progressValue * 4))] }

    func begin() async {
        guard !isRecording, completedSession == nil else { return }
        do {
            try await transcriber.start(); try await recorder.startRecording()
            sessionStartedAt = .now; isRecording = true; startTimer()
        } catch { transcriber.stop(); alert = PracticeSessionAlert(message: error.localizedDescription) }
    }

    func togglePause() {
        guard isRecording else { return }
        do { if isPaused { try recorder.resumeRecording() } else { recorder.pauseRecording() }; isPaused.toggle() }
        catch { alert = PracticeSessionAlert(message: error.localizedDescription) }
    }

    func finish() async {
        guard completedSession == nil else { return }
        timerTask?.cancel()
        let recordedDuration = await recorder.stopRecording()
        transcriber.stop(); isRecording = false
        let duration = recordedDuration > 0 ? recordedDuration : Date.now.timeIntervalSince(sessionStartedAt ?? .now)
        let cleanTranscript = (transcript.isEmpty ? transcriber.transcript : transcript)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        completedSession = PracticeSessionRecord(topicTitle: topicTitle, question: question, duration: duration, transcript: cleanTranscript, audioFileName: recorder.recordingURL?.lastPathComponent, feedback: PracticeEvaluationService().evaluate(transcript: cleanTranscript, duration: duration))
        showsResult = true
    }

    func cancel() { timerTask?.cancel(); recorder.cancelRecording(); transcriber.stop(); isRecording = false }

    private func startTimer() {
        timerTask?.cancel()
        timerTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                guard let self, !Task.isCancelled else { return }
                guard !self.isPaused else { continue }
                self.elapsedSeconds += 1
                if self.elapsedSeconds >= self.totalDuration { await self.finish(); return }
            }
        }
    }
}

struct PracticeSessionAlert: Identifiable {
    let id = UUID()
    let message: String
}
