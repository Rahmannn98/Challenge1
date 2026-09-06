import Foundation
import Observation

@Observable
final class HomeViewModel {
    var profile: UserProfile
    var topics: [Topic]
    var newTopicTitle = ""

    let heroTitle: String
    let heroSubtitle: String

    init(
        profile: UserProfile = UserProfile(displayName: "Rahman"),
        topics: [Topic] = TopicPreset.allCases.map(\.topic),
        heroTitle: String = "Practice English",
        heroSubtitle: String = "Pick a topic, prepare a question, and start speaking."
    ) {
        self.profile = profile
        self.topics = topics
        self.heroTitle = heroTitle
        self.heroSubtitle = heroSubtitle
    }

    var greetingText: String {
        "Hai, \(profile.displayName)!"
    }

    var canAddTopic: Bool {
        !trimmedTopicTitle.isEmpty
    }

    func updateDisplayName(_ displayName: String) {
        let trimmedDisplayName = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedDisplayName.isEmpty else { return }
        profile.displayName = trimmedDisplayName
    }

    func addTopic() {
        guard canAddTopic else { return }

        topics.append(
            Topic(
                title: trimmedTopicTitle,
                imageName: "Monyet2",
                questions: ["Tell me more about \(trimmedTopicTitle)."]
            )
        )
        newTopicTitle = ""
    }

    func deleteTopic(_ topic: Topic) {
        topics.removeAll { $0.id == topic.id }
    }

    private var trimmedTopicTitle: String {
        newTopicTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
