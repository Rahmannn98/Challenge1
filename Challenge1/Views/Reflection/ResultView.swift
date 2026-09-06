import SwiftUI

struct Result: View {
    let viewModel: ResultViewModel
    let onRestart: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var showsSuccess = false

    init(topicTitle: String, branch: PracticeBranch, question: String, totalDuration: Int, onRestart: @escaping () -> Void) {
        self.viewModel = ResultViewModel(
            topicTitle: topicTitle,
            branch: branch,
            question: question,
            totalDuration: totalDuration
        )
        self.onRestart = onRestart
    }

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    topBar
                    recordingCard
                    feedbackSection
                    actions
                }
                .padding(.horizontal, AppSpacing.screen)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .appScreenBackground()
        }
        .font(.jakarta(15))
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(isPresented: $showsSuccess) {
            SuccessView(onDone: returnToHome)
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.jakarta(15, weight: .bold))
                    .foregroundStyle(Color.themePrimary)
                    .frame(width: 36, height: 36)
            }

            Spacer()

            Text("Your Recording")
                .font(.jakarta(15, weight: .bold))
                .foregroundStyle(Color.themePrimary)

            Spacer()

            Color.clear.frame(width: 36, height: 36)
        }
    }

    private var recordingCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.question)
                        .font(.jakarta(19, weight: .bold))
                        .foregroundStyle(Color.themePrimary)
                        .lineSpacing(2)

                    Text("23 Feb 2024 · \(viewModel.formattedDuration)")
                        .font(.jakarta(12, weight: .medium))
                        .foregroundStyle(Color.themeSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.jakarta(14, weight: .bold))
                    .foregroundStyle(Color.themeMint)
            }

            HStack(spacing: 12) {
                Image(systemName: "play.fill")
                    .font(.jakarta(16, weight: .bold))
                    .foregroundStyle(Color.white)
                    .frame(width: 42, height: 42)
                    .background(Color.themePrimary)
                    .clipShape(Circle())

                waveform

                Text(viewModel.formattedDuration)
                    .font(.jakarta(11, weight: .medium))
                    .foregroundStyle(Color.themeSecondary)
            }
        }
        .padding(18)
        .background(
            LinearGradient(
                colors: [Color.themeSky.opacity(0.72), Color.themeQuaternary.opacity(0.46)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous))
    }

    private var feedbackSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("AI Feedback")
                .font(.jakarta(17, weight: .bold))
                .foregroundStyle(Color.themePrimary)

            feedbackCard(
                symbolName: "briefcase.fill",
                title: "Structure (PREP)",
                subtitle: "Good use of structure!",
                score: "85%",
                color: .themePeach
            )

            feedbackCard(
                symbolName: "heart.text.square.fill",
                title: "Clarity",
                subtitle: "Your ideas are clear and easy to follow.",
                score: "78%",
                color: .themeRose
            )

            feedbackCard(
                symbolName: "trophy.fill",
                title: "Fluency",
                subtitle: "Keep going! Try to reduce long pauses.",
                score: "72%",
                color: .themePeach
            )
        }
    }

    private var waveform: some View {
        HStack(spacing: 3) {
            ForEach(0..<22, id: \.self) { index in
                Capsule(style: .continuous)
                    .fill(index.isMultiple(of: 3) ? Color.themeMint : Color.themeMint.opacity(0.36))
                    .frame(width: 3, height: CGFloat((index % 6) + 2) * 4)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var actions: some View {
        VStack(spacing: 14) {
            Button {
                showsSuccess = true
            } label: {
                Text("Practice Again")
                    .font(.jakarta(16, weight: .bold))
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
            }
            .practicePrimaryAction()

            Button {
                dismiss()
                onRestart()
            } label: {
                Text("Try Another Topic")
                    .font(.jakarta(15, weight: .bold))
                    .foregroundStyle(Color.themePrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .practiceSecondaryAction()
        }
    }

    private func feedbackCard(symbolName: String, title: String, subtitle: String, score: String, color: Color) -> some View {
        HStack(spacing: 14) {
            Image(systemName: symbolName)
                .font(.jakarta(18, weight: .bold))
                .foregroundStyle(Color(red: 1.0, green: 0.43, blue: 0.28))
                .frame(width: 46, height: 46)
                .background(color.opacity(0.72))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.jakarta(14, weight: .bold))
                    .foregroundStyle(Color.themePrimary)

                Text(subtitle)
                    .font(.jakarta(12, weight: .medium))
                    .foregroundStyle(Color.themeSecondary)
                    .lineLimit(2)
            }

            Spacer()

            Text(score)
                .font(.jakarta(20, weight: .bold))
                .foregroundStyle(Color.themePrimary)
        }
        .padding(16)
        .background(Color.white.opacity(0.95))
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous))
        .shadow(color: Color.themePrimary.opacity(0.05), radius: 12, y: 6)
    }

    private func returnToHome() {
        NotificationCenter.default.post(name: .returnToHome, object: nil)
    }
}

#Preview {
    NavigationStack {
        Result(
            topicTitle: "Education",
            branch: .generalPractice,
            question: "How has your education shaped who you are today?",
            totalDuration: 88,
            onRestart: {}
        )
    }
}
