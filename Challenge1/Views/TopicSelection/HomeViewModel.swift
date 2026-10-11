import Foundation
import Observation

@Observable
final class HomeViewModel {
    var topics: [SpeakingTopic]

    let heroTitle: String
    let heroSubtitle: String

    init(
        topics: [SpeakingTopic] = TopicPreset.allCases.map(\.topic),
        heroTitle: String = "Practice English",
        heroSubtitle: String = "Pick a topic, prepare a question, and start speaking."
    ) {
        self.topics = topics
        self.heroTitle = heroTitle
        self.heroSubtitle = heroSubtitle
    }

    func deleteTopic(_ topic: SpeakingTopic) {
        topics.removeAll { $0.id == topic.id }
    }
}
