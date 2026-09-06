import Foundation
import Observation

@Observable
final class HomeViewModel {
    var profile: UserProfile
    var topics: [SpeakingTopic]
    var newTopicTitle = ""

    let heroTitle: String
    let heroSubtitle: String

    init(
        profile: UserProfile = UserProfile(displayName: "Rahman"),
        topics: [SpeakingTopic] = TopicPreset.allCases.map(\.topic),
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
            SpeakingTopic(
                title: trimmedTopicTitle,
                subtitle: "Custom speaking practice topic",
                symbolName: "sparkles",
                imageName: "Monyet2",
                accentColorName: "mint",
                questions: ["Tell me more about \(trimmedTopicTitle)."]
            )
        )
        newTopicTitle = ""
    }

    func deleteTopic(_ topic: SpeakingTopic) {
        topics.removeAll { $0.id == topic.id }
    }

    private var trimmedTopicTitle: String {
        newTopicTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
