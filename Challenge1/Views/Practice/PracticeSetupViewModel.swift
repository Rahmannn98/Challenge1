import Foundation
import Observation

@Observable
final class PracticeSetupViewModel {
    let topic: SpeakingTopic
    var selectedMinutes = 1
    var selectedSeconds = 0
    var currentQuestion: String

    init(topic: SpeakingTopic) {
        self.topic = topic
        self.currentQuestion = topic.starterQuestion
    }

    var totalDuration: Int {
        max(1, (selectedMinutes * 60) + selectedSeconds)
    }

    var formattedDuration: String {
        TimeFormatter.practiceTime(totalDuration)
    }

    func generateQuestion() {
        let availableQuestions = topic.questions.filter { $0 != currentQuestion }
        currentQuestion = availableQuestions.randomElement() ?? topic.starterQuestion
    }
}
