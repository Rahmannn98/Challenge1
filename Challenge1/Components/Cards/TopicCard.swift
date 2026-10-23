
import SwiftUI

struct TopicCard: View {
    let topic: SpeakingTopic

    var body: some View {
        let style = TopicCardStyle.style(for: topic)

        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 8) {
                Spacer(minLength: 0)

                Image(systemName: topic.symbolName)
                    .font(.system(size: 76, weight: .regular))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(style.iconForeground)
                    .frame(maxWidth: .infinity)
                    .frame(height: 150)
                    .accessibilityHidden(true)

                Spacer(minLength: 0)
            }
            .overlay(alignment: .topTrailing) {
                Image(systemName: "chevron.right")
                    .font(
                        .jakarta(
                            14,
                            relativeTo: .caption,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(style.iconForeground.opacity(0.8))
                    .padding(.top, 4)
                    .accessibilityHidden(true)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(topic.title)
                    .font(
                        .jakarta(
                            20,
                            relativeTo: .title3,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(style.titleColor)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Text(topic.subtitle)
                    .font(
                        .jakarta(
                            13,
                            relativeTo: .subheadline,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(style.subtitleColor)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(20)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .background(style.background)
        .clipShape(
            RoundedRectangle(
                cornerRadius: AppRadius.large,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: AppRadius.large,
                style: .continuous
            )
            .strokeBorder(
                Color.white.opacity(0.65),
                lineWidth: 1
            )
        }
        .shadow(
            color: Color.brandPlum.opacity(0.04),
            radius: 10,
            y: 5
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(topic.title), \(topic.subtitle)")
        .accessibilityHint(
            "Opens practice setup for \(topic.title)."
        )
    }
}

#Preview {
    HStack(spacing: 12) {
        TopicCard(topic: TopicPreset.education.topic)
            .frame(width: 280, height: 290)

        TopicCard(topic: TopicPreset.career.topic)
            .frame(width: 280, height: 290)
    }
    .padding()
    .background(Color.appBackground)
}
