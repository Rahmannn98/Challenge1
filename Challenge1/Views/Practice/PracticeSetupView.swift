import SwiftUI

struct PracticeSetupView: View {
    @State private var viewModel: PracticeSetupViewModel
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    init(topic: SpeakingTopic) {
        _viewModel = State(initialValue: PracticeSetupViewModel(topic: topic))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.card + 6) {
                hero
                topicIntro
                durationCard
                questions
            }
            .padding(.horizontal, AppSpacing.screen)
            .padding(.bottom, AppSpacing.card)
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            startPracticeSection
        }
        .appScreenBackground()
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .tint(Color.appPrimary)
        .font(.jakarta(15, relativeTo: .body))
    }

    private var startPracticeSection: some View {
        startPracticeButton
            .padding(.horizontal, AppSpacing.screen)
            .padding(.vertical, 12)
            .background(
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea(edges: .bottom)
            )
    }

    private var startPracticeButton: some View {
        NavigationLink {
            PracticeSessionView(
                viewModel: PracticeSessionViewModel(
                    topicTitle: viewModel.topic.title,
                    branch: .generalPractice,
                    question: viewModel.currentQuestion,
                    totalDuration: viewModel.totalDuration
                )
            )
        } label: {
            Label("Start Practice", systemImage: "arrow.right")
                .font(.jakarta(16, relativeTo: .headline, weight: .bold))
                .foregroundStyle(Color.white)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 17)
        }
        .practicePrimaryAction()
        .accessibilityHint("Begins a timed practice session with the selected question.")
    }

    private var hero: some View {
        ZStack {
            LinearGradient(
                colors: [
                    viewModel.topic.accentColor.background,
                    Color.brandLavender.opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Image(viewModel.topic.imageName)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: heroImageHeight)
                .padding(.vertical, 14)
                .accessibilityHidden(true)
        }
        .frame(height: heroHeight)
        .clipShape(.rect(cornerRadius: AppRadius.extraLarge))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.extraLarge, style: .continuous)
                .strokeBorder(Color.white.opacity(0.6), lineWidth: 1)
        )
    }

    private var topicIntro: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(viewModel.topic.title)
                .font(.jakarta(30, relativeTo: .largeTitle, weight: .bold))
                .foregroundStyle(Color.appTextPrimary)
                .accessibilityAddTraits(.isHeader)

            Text("Share your thoughts, experiences, and opinions about \(viewModel.topic.title.lowercased()).")
                .font(.jakarta(15, relativeTo: .subheadline, weight: .medium))
                .foregroundStyle(Color.appTextSecondary)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)

            ViewThatFits(in: .horizontal) {
                HStack(spacing: 8) {
                    metadataBadges
                }
                VStack(alignment: .leading, spacing: 8) {
                    metadataBadges
                }
            }
            .padding(.top, 4)
        }
        .padding(.vertical, 2)
    }

    @ViewBuilder
    private var metadataBadges: some View {
        infoChip(
            symbolName: "chart.bar.fill",
            title: "Beginner",
            iconColor: Color.appSuccess,
            backgroundColor: Color.brandLavender.opacity(0.22)
        )
        infoChip(
            symbolName: "folder.fill",
            title: "5+ topics",
            iconColor: Color(red: 0.38, green: 0.42, blue: 0.72),
            backgroundColor: Color.brandLavender.opacity(0.22)
        )
        infoChip(
            symbolName: "flame.fill",
            title: "Popular",
            iconColor: Color(red: 0.78, green: 0.35, blue: 0.45),
            backgroundColor: Color.brandLavender.opacity(0.22)
        )
    }

    private var durationCard: some View {
        OrbitalDurationPicker(
            selectedMinutes: $viewModel.selectedMinutes,
            selectedSeconds: $viewModel.selectedSeconds,
            formattedDuration: viewModel.formattedDuration,
            onReset: {
                viewModel.generateQuestion()
            }
        )
    }

    private var questions: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Sample Questions")
                .font(.jakarta(17, relativeTo: .headline, weight: .bold))
                .foregroundStyle(Color.appTextPrimary)
                .accessibilityAddTraits(.isHeader)

            ForEach(viewModel.topic.questions, id: \.self) { question in
                let isSelected = question == viewModel.currentQuestion

                Button {
                    viewModel.currentQuestion = question
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                            .font(.headline)
                            .foregroundStyle(
                                isSelected
                                    ? Color.brandPlum
                                    : Color.appTextSecondary.opacity(0.4)
                            )
                            .accessibilityHidden(true)

                        Text(question)
                            .font(.jakarta(15, relativeTo: .body, weight: isSelected ? .bold : .semibold))
                            .foregroundStyle(Color.appTextPrimary)
                            .multilineTextAlignment(.leading)

                        Spacer(minLength: 0)
                    }
                    .padding(15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        isSelected ? Color.appSurfaceSecondary : Color.white.opacity(0.95),
                        in: .rect(cornerRadius: AppRadius.medium)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: AppRadius.medium, style: .continuous)
                            .strokeBorder(
                                isSelected ? Color.brandPlum.opacity(0.35) : Color.brandLavender.opacity(0.2),
                                lineWidth: isSelected ? 1.5 : 1
                            )
                    )
                    .shadow(
                        color: Color.brandPlum.opacity(isSelected ? 0.06 : 0.03),
                        radius: 8,
                        y: 4
                    )
                }
                .buttonStyle(.plain)
                .accessibilityLabel(question)
                .accessibilityValue(isSelected ? "Selected" : "Not selected")
                .accessibilityHint("Uses this question when practice starts.")
                .accessibilityAddTraits(isSelected ? .isSelected : [])
            }
        }
    }

    private var heroHeight: CGFloat {
        if dynamicTypeSize.isAccessibilitySize {
            return 164
        }
        return verticalSizeClass == .compact ? 176 : 250
    }

    private var heroImageHeight: CGFloat {
        if dynamicTypeSize.isAccessibilitySize {
            return 112
        }
        return verticalSizeClass == .compact ? 128 : 185
    }

    private func infoChip(
        symbolName: String,
        title: String,
        iconColor: Color,
        backgroundColor: Color
    ) -> some View {
        HStack(spacing: 6) {
            Image(systemName: symbolName)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(iconColor)

            Text(title)
                .font(.jakarta(12, relativeTo: .caption, weight: .bold))
                .foregroundStyle(Color.appTextPrimary)
        }
        .padding(.horizontal, 11)
        .padding(.vertical, 7)
        .background(backgroundColor, in: Capsule())
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NavigationStack {
        PracticeSetupView(topic: TopicPreset.education.topic)
    }
}
