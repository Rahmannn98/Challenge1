import Foundation
import Observation

@Observable
final class HomeViewModel {
    var topics: [SpeakingTopic]
    var selectedIndex: Int = 0

    let heroTitle: String
    let heroSubtitle: String

    var selectedTopic: SpeakingTopic? {
        guard !topics.isEmpty else { return nil }
        let clamped = min(max(selectedIndex, 0), topics.count - 1)
        return topics[clamped]
    }

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
        if let idx = topics.firstIndex(where: { $0.id == topic.id }) {
            topics.remove(at: idx)
            if selectedIndex >= topics.count {
                selectedIndex = max(0, topics.count - 1)
            }
        }
    }
}
