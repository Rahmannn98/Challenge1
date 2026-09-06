import Foundation
import Observation

@Observable
final class PracticeSessionViewModel {
    let topicTitle: String
    let branch: PracticeBranch
    let question: String
    let totalDuration: Int
    let prepStages = PREPStage.allCases

    var elapsedSeconds = 0
    var timerSessionID = UUID()
    var isPaused = false
    var showsResult = false

    init(topicTitle: String, branch: PracticeBranch, question: String, totalDuration: Int) {
        self.topicTitle = topicTitle
        self.branch = branch
        self.question = question
        self.totalDuration = max(totalDuration, 1)
    }

    var branchTitle: String {
        branch.title
    }

    var progressValue: Double {
        Double(elapsedSeconds) / Double(totalDuration)
    }

    var timeString: String {
        TimeFormatter.practiceTime(elapsedSeconds)
    }

    var remainingTime: Int {
        max(totalDuration - elapsedSeconds, 0)
    }

    var remainingTimeString: String {
        TimeFormatter.practiceTime(remainingTime)
    }

    var statusText: String {
        if elapsedSeconds >= totalDuration {
            return "Time is up"
        }

        if isPaused {
            return "Paused"
        }

        return "Keep speaking"
    }

    var activeTickCount: Int {
        Int((progressValue * 40).rounded(.up))
    }

    var isFinished: Bool {
        elapsedSeconds >= totalDuration
    }

    func restartSession() {
        elapsedSeconds = 0
        timerSessionID = UUID()
        showsResult = false
        isPaused = false
    }

    func togglePause() {
        guard !isFinished else { return }
        isPaused.toggle()
    }

    func finishSession() {
        showsResult = true
    }

    func runTimer() async {
        while !Task.isCancelled {
            guard !isFinished else { return }

            try? await Task.sleep(for: .seconds(1))

            guard !Task.isCancelled else { return }
            guard !isPaused else { continue }
            elapsedSeconds += 1
        }
    }
}
