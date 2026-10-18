import SwiftUI

struct OptionCard: View {
    let topic: SpeakingTopic

    var body: some View {
        TopicCard(topic: topic)
    }
}
