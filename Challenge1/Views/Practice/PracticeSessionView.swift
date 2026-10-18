import SwiftUI

struct PracticeSessionView: View {
    @State private var viewModel: PracticeSessionViewModel
    @Environment(PracticeSessionStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    init(viewModel: PracticeSessionViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 22) {
            HStack {
                Button {
                    viewModel.cancel()
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
                .accessibilityLabel("Cancel practice")

                Spacer()
                Text("Practice")
                    .font(.jakarta(16, relativeTo: .headline, weight: .bold))
                Spacer()

                Button(action: viewModel.togglePause) {
                    Image(systemName: viewModel.isPaused ? "play.fill" : "pause.fill")
                }
                .disabled(!viewModel.isRecording)
                .accessibilityLabel(viewModel.isPaused ? "Resume recording" : "Pause recording")
            }
            .foregroundStyle(Color.appPrimary)
            .font(.title3.weight(.bold))

            VStack(spacing: 8) {
                Text("\(activeStagePosition) / \(viewModel.prepStages.count)")
                    .font(.jakarta(13, relativeTo: .caption, weight: .semibold))
                    .foregroundStyle(Color.appSecondary)

                Text(viewModel.activeStage.title)
                    .font(.jakarta(30, relativeTo: .largeTitle, weight: .bold))
                    .foregroundStyle(Color.appPrimary)

                Text(viewModel.question)
                    .font(.jakarta(15, relativeTo: .subheadline, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.appSecondary)
            }

            ZStack {
                Circle()
                    .stroke(Color.brandLavender.opacity(0.35), lineWidth: 18)

                Circle()
                    .trim(from: 0, to: viewModel.progressValue)
                    .stroke(
                        Color.brandPlum,
                        style: StrokeStyle(lineWidth: 18, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))

                VStack {
                    Text(viewModel.remainingTimeString)
                        .font(.jakarta(34, relativeTo: .title, weight: .bold))
                        .foregroundStyle(Color.appPrimary)

                    Text(viewModel.isPaused ? "Paused" : "Recording")
                        .font(.jakarta(13, relativeTo: .caption, weight: .medium))
                        .foregroundStyle(Color.appSecondary)
                }
            }
            .frame(width: 220, height: 220)

            WaveformView(level: viewModel.audioLevel, isRecording: viewModel.isRecording)

            PREPStageProgressView(stages: viewModel.prepStages, activeStage: viewModel.activeStage)

            transcriptCard

            Spacer(minLength: 0)

            Button {
                Task { await viewModel.finish() }
            } label: {
                Label("Stop & review", systemImage: "stop.fill")
                    .font(.jakarta(16, relativeTo: .headline, weight: .bold))
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
            }
            .practicePrimaryAction()
            .disabled(!viewModel.isRecording)
        }
        .padding(AppSpacing.screen)
        .appScreenBackground()
        .font(.jakarta(15, relativeTo: .body))
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
        .task { await viewModel.begin() }
        .onDisappear {
            if !viewModel.showsResult { viewModel.cancel() }
        }
        .onChange(of: viewModel.showsResult) { _, visible in
            if visible, let session = viewModel.completedSession {
                store.save(session)
            }
        }
        .alert("Practice unavailable", item: $viewModel.alert) { _ in
            Button("OK", role: .cancel) {}
        } message: { alert in
            Text(alert.message)
        }
        .navigationDestination(isPresented: $viewModel.showsResult) {
            if let session = viewModel.completedSession {
                Result(session: session)
            }
        }
    }

    private var activeStagePosition: Int {
        guard let index = viewModel.prepStages.firstIndex(of: viewModel.activeStage) else {
            return 1
        }
        return index + 1
    }

    private var transcriptCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Live transcript")
                .font(.jakarta(14, relativeTo: .subheadline, weight: .bold))
                .foregroundStyle(Color.appPrimary)

            Text(viewModel.transcript.isEmpty ? "Your spoken words will appear here." : viewModel.transcript)
                .font(.jakarta(13, relativeTo: .footnote, weight: .regular))
                .foregroundStyle(viewModel.transcript.isEmpty ? Color.appSecondary : Color.appPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.white.opacity(0.94), in: RoundedRectangle(cornerRadius: AppRadius.large))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous)
                .strokeBorder(Color.brandLavender.opacity(0.25), lineWidth: 1)
        )
    }
}

private struct WaveformView: View {
    let level: Float
    let isRecording: Bool

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<24, id: \.self) { index in
                Capsule()
                    .fill(isRecording ? Color.brandDeepLavender : Color.brandLavender.opacity(0.35))
                    .frame(width: 4, height: max(8, CGFloat(level) * CGFloat(20 + (index % 5) * 12)))
            }
        }
        .frame(height: 60)
        .accessibilityLabel(isRecording ? "Recording in progress" : "Not recording")
    }
}
