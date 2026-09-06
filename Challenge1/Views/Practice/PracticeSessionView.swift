import SwiftUI

struct PracticeSessionView: View {
    @State private var viewModel: PracticeSessionViewModel
    @State private var isPulsing = false
    @State private var rippleScale: CGFloat = 0.86
    @State private var rippleOpacity = 0.0

    @Environment(\.dismiss) private var dismiss

    init(viewModel: PracticeSessionViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 24) {
                topBar
                stageHeader
                timerRing
                waveform
                PREPStageProgressView(stages: viewModel.prepStages, activeStage: .point)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, AppSpacing.screen)
            .padding(.top, 16)
            .padding(.bottom, 106)
            .appScreenBackground()

            Button {
                viewModel.finishSession()
            } label: {
                Label("Stop Recording", systemImage: "stop.fill")
                    .font(.jakarta(16, weight: .bold))
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
            }
            .background(
                LinearGradient(
                    colors: [Color(red: 1.0, green: 0.37, blue: 0.32), Color(red: 1.0, green: 0.46, blue: 0.36)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous))
            .padding(.horizontal, AppSpacing.screen)
            .padding(.bottom, 20)
        }
        .font(.jakarta(15))
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(isPresented: $viewModel.showsResult) {
            Result(
                topicTitle: viewModel.topicTitle,
                branch: viewModel.branch,
                question: viewModel.question,
                totalDuration: viewModel.elapsedSeconds,
                onRestart: viewModel.restartSession
            )
        }
        .onAppear {
            startPulseAnimation()
            triggerRipple()
        }
        .onChange(of: viewModel.elapsedSeconds) { _, newValue in
            startPulseAnimation()
            triggerRipple()

            if newValue >= viewModel.totalDuration {
                viewModel.showsResult = true
            }
        }
        .onChange(of: viewModel.isPaused) { _, _ in
            startPulseAnimation()
        }
        .task(id: viewModel.timerSessionID) {
            await viewModel.runTimer()
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.jakarta(14, weight: .bold))
                    .foregroundStyle(Color.themePrimary)
                    .frame(width: 42, height: 42)
                    .background(Color.white.opacity(0.92))
                    .clipShape(Circle())
            }

            Spacer()

            Text("Practice")
                .font(.jakarta(15, weight: .bold))
                .foregroundStyle(Color.themePrimary)

            Spacer()

            Button {
                viewModel.togglePause()
            } label: {
                Image(systemName: viewModel.isPaused ? "play.fill" : "ellipsis")
                    .font(.jakarta(15, weight: .bold))
                    .foregroundStyle(Color.themePrimary)
                    .frame(width: 42, height: 42)
                    .background(Color.white.opacity(0.92))
                    .clipShape(Circle())
            }
        }
    }

    private var stageHeader: some View {
        VStack(spacing: 10) {
            Text("1 / 4")
                .font(.jakarta(13, weight: .bold))
                .foregroundStyle(Color.themeSecondary)

            Text("Point")
                .font(.jakarta(30, weight: .bold))
                .foregroundStyle(Color.themePrimary)

            Text("Give your main idea or answer.")
                .font(.jakarta(14, weight: .medium))
                .foregroundStyle(Color.themeSecondary)
                .multilineTextAlignment(.center)

            Text(viewModel.question)
                .font(.jakarta(13, weight: .semibold))
                .foregroundStyle(Color.themeInkMuted)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.top, 4)
        }
        .padding(.top, 18)
    }

    private var timerRing: some View {
        ZStack {
            Circle()
                .stroke(Color.themeQuaternary.opacity(0.78), lineWidth: 18)
                .frame(width: 224, height: 224)
                .scaleEffect(rippleScale)
                .opacity(rippleOpacity)

            Circle()
                .stroke(Color.themeQuaternary.opacity(0.72), lineWidth: 18)
                .frame(width: 214, height: 214)

            Circle()
                .trim(from: 0, to: CGFloat(viewModel.progressValue))
                .stroke(
                    Color.themeMint,
                    style: StrokeStyle(lineWidth: 18, lineCap: .round)
                )
                .frame(width: 214, height: 214)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.35), value: viewModel.elapsedSeconds)

            VStack(spacing: 4) {
                Text(viewModel.remainingTimeString)
                    .font(.jakarta(34, weight: .bold))
                    .foregroundStyle(Color.themePrimary)

                Text(viewModel.isPaused ? "Paused" : "Speak now...")
                    .font(.jakarta(13, weight: .medium))
                    .foregroundStyle(Color.themeSecondary)
            }
        }
        .frame(height: 246)
        .scaleEffect(isPulsing ? 1.02 : 1)
    }

    private var waveform: some View {
        HStack(spacing: 4) {
            ForEach(0..<29, id: \.self) { index in
                Capsule(style: .continuous)
                    .fill(Color.themeMint.opacity(index.isMultiple(of: 4) ? 1 : 0.72))
                    .frame(width: 4, height: CGFloat((index % 7) + 2) * 6)
            }
        }
        .frame(height: 58)
    }

    private func startPulseAnimation() {
        guard !viewModel.isPaused, !viewModel.isFinished else {
            withAnimation(.easeOut(duration: 0.2)) {
                isPulsing = false
            }
            return
        }

        withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
            isPulsing = true
        }
    }

    private func triggerRipple() {
        guard !viewModel.isPaused, !viewModel.isFinished else {
            rippleOpacity = 0
            return
        }

        rippleScale = 0.86
        rippleOpacity = 0.36

        withAnimation(.easeOut(duration: 0.9)) {
            rippleScale = 1.1
            rippleOpacity = 0
        }
    }
}

#Preview {
    NavigationStack {
        PracticeSessionView(
            viewModel: PracticeSessionViewModel(
                topicTitle: "Education",
                branch: .generalPractice,
                question: "How has your education shaped who you are today?",
                totalDuration: 30
            )
        )
    }
}
