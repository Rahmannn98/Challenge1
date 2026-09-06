import SwiftUI

struct PracticeSetupView: View {
    @State private var viewModel: PracticeSetupViewModel
    @Environment(\.dismiss) private var dismiss

    init(topic: SpeakingTopic) {
        _viewModel = State(initialValue: PracticeSetupViewModel(topic: topic))
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    hero
                    topicIntro
                    durationCard
                    questions
                }
                .padding(.horizontal, AppSpacing.screen)
                .padding(.bottom, 104)
            }
            .appScreenBackground()

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
                    .font(.jakarta(16, weight: .bold))
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
            }
            .practicePrimaryAction()
            .padding(.horizontal, AppSpacing.screen)
            .padding(.bottom, 18)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .font(.jakarta(15))
    }

    private var hero: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 0)
                .fill(
                    LinearGradient(
                        colors: [viewModel.topic.accentColor.background, Color.themeTertiary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Image(viewModel.topic.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 185)
                .padding(.top, 28)

            HStack {
                iconButton("chevron.left") {
                    dismiss()
                }

                Spacer()

                iconButton("heart.fill") {}
            }
            .padding(.top, 20)
            .padding(.horizontal, 2)
        }
        .frame(height: 250)
        .padding(.horizontal, -AppSpacing.screen)
    }

    private var topicIntro: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(viewModel.topic.title)
                .font(.jakarta(28, weight: .bold))
                .foregroundStyle(Color.themePrimary)

            Text("Share your thoughts, experiences, and opinions about \(viewModel.topic.title.lowercased()).")
                .font(.jakarta(14, weight: .medium))
                .foregroundStyle(Color.themeSecondary)
                .lineSpacing(3)

            HStack(spacing: 10) {
                infoChip("chart.bar.fill", "Beginner", .themeQuaternary)
                infoChip("folder.fill", "5+ topics", .themeSky)
                infoChip("flame.fill", "Popular", .themePeach)
            }
        }
    }

    private var durationCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Practice Duration")
                    .font(.jakarta(17, weight: .bold))
                    .foregroundStyle(Color.themePrimary)

                Spacer()

                Button {
                    viewModel.generateQuestion()
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.jakarta(14, weight: .bold))
                        .foregroundStyle(Color.themePrimary)
                        .frame(width: 36, height: 36)
                        .background(Color.themeTertiary)
                        .clipShape(Circle())
                }
            }

            HStack(spacing: 12) {
                durationPicker(title: "Min", selection: $viewModel.selectedMinutes, range: 0...59)
                durationPicker(title: "Sec", selection: $viewModel.selectedSeconds, range: 0...59)
            }

            Text("Practice time: \(viewModel.formattedDuration)")
                .font(.jakarta(13, weight: .bold))
                .foregroundStyle(Color.themePrimary)
        }
        .padding(18)
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous))
        .shadow(color: Color.themePrimary.opacity(0.06), radius: 16, y: 8)
    }

    private var questions: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Sample Questions")
                    .font(.jakarta(17, weight: .bold))
                    .foregroundStyle(Color.themePrimary)

                Spacer()

                Button("See All") {}
                    .font(.jakarta(13, weight: .bold))
                    .foregroundStyle(Color(red: 0.54, green: 0.35, blue: 0.82))
            }

            ForEach(viewModel.topic.questions, id: \.self) { question in
                Button {
                    viewModel.currentQuestion = question
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: question == viewModel.currentQuestion ? "checkmark.circle.fill" : "circle")
                            .font(.jakarta(14, weight: .bold))
                            .foregroundStyle(question == viewModel.currentQuestion ? Color.themeMint : Color.themeSecondary.opacity(0.6))

                        Text(question)
                            .font(.jakarta(13, weight: .semibold))
                            .foregroundStyle(Color.themePrimary)
                            .multilineTextAlignment(.leading)

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.jakarta(12, weight: .bold))
                            .foregroundStyle(Color.themeSecondary)
                    }
                    .padding(15)
                    .background(Color.white.opacity(0.95))
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.medium, style: .continuous))
                    .shadow(color: Color.themePrimary.opacity(0.05), radius: 10, y: 5)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func iconButton(_ symbolName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbolName)
                .font(.jakarta(15, weight: .bold))
                .foregroundStyle(symbolName == "heart.fill" ? Color(red: 0.92, green: 0.25, blue: 0.32) : Color.themePrimary)
                .frame(width: 42, height: 42)
                .background(Color.white.opacity(0.88))
                .clipShape(Circle())
        }
    }

    private func infoChip(_ symbolName: String, _ title: String, _ color: Color) -> some View {
        Label(title, systemImage: symbolName)
            .font(.jakarta(12, weight: .bold))
            .foregroundStyle(Color.themePrimary)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(color.opacity(0.78))
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.medium, style: .continuous))
    }

    private func durationPicker(title: String, selection: Binding<Int>, range: ClosedRange<Int>) -> some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.jakarta(12, weight: .bold))
                .foregroundStyle(Color.themeSecondary)

            Picker(title, selection: selection) {
                ForEach(Array(range), id: \.self) { value in
                    Text(String(format: "%02d", value))
                        .font(.jakarta(16, weight: .bold))
                        .tag(value)
                }
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: .infinity)
            .frame(height: 92)
            .background(Color.themeTertiary)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.medium, style: .continuous))
        }
    }
}

#Preview {
    NavigationStack {
        PracticeSetupView(topic: TopicPreset.education.topic)
    }
}
