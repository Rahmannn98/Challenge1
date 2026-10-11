import SwiftUI

struct PracticeSessionView: View {
    @State private var viewModel: PracticeSessionViewModel
    @Environment(PracticeSessionStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    init(viewModel: PracticeSessionViewModel) { _viewModel = State(initialValue: viewModel) }

    var body: some View {
        VStack(spacing: 22) {
            HStack {
                Button { viewModel.cancel(); dismiss() } label: { Image(systemName: "xmark") }
                    .accessibilityLabel("Cancel practice")
                Spacer(); Text("Practice").font(.jakarta(16, weight: .bold)); Spacer()
                Button(action: viewModel.togglePause) { Image(systemName: viewModel.isPaused ? "play.fill" : "pause.fill") }
                    .disabled(!viewModel.isRecording).accessibilityLabel(viewModel.isPaused ? "Resume recording" : "Pause recording")
            }.foregroundStyle(Color.themePrimary).font(.title3.weight(.bold))

            VStack(spacing: 8) {
                Text("\(viewModel.prepStages.firstIndex(of: viewModel.activeStage)! + 1) / 4").foregroundStyle(Color.themeSecondary)
                Text(viewModel.activeStage.title).font(.jakarta(30, weight: .bold)).foregroundStyle(Color.themePrimary)
                Text(viewModel.question).multilineTextAlignment(.center).foregroundStyle(Color.themeSecondary)
            }

            ZStack {
                Circle().stroke(Color.themeQuaternary, lineWidth: 18)
                Circle().trim(from: 0, to: viewModel.progressValue).stroke(Color.themeMint, style: StrokeStyle(lineWidth: 18, lineCap: .round)).rotationEffect(.degrees(-90))
                VStack { Text(viewModel.remainingTimeString).font(.jakarta(34, weight: .bold)); Text(viewModel.isPaused ? "Paused" : "Recording") .foregroundStyle(Color.themeSecondary) }
            }.frame(width: 220, height: 220).foregroundStyle(Color.themePrimary)

            WaveformView(level: viewModel.audioLevel, isRecording: viewModel.isRecording)
            PREPStageProgressView(stages: viewModel.prepStages, activeStage: viewModel.activeStage)
            transcriptCard
            Spacer(minLength: 0)
            Button { viewModel.finish() } label: { Label("Stop & review", systemImage: "stop.fill").frame(maxWidth: .infinity).padding(.vertical, 17) }
                .practicePrimaryAction().disabled(!viewModel.isRecording)
        }
        .padding(AppSpacing.screen).appScreenBackground().font(.jakarta(15))
        .navigationBarBackButtonHidden().toolbar(.hidden, for: .navigationBar)
        .task { await viewModel.begin() }
        .onDisappear { if !viewModel.showsResult { viewModel.cancel() } }
        .onChange(of: viewModel.showsResult) { _, visible in if visible, let session = viewModel.completedSession { store.save(session) } }
        .alert("Practice unavailable", isPresented: Binding(get: { viewModel.errorMessage != nil }, set: { if !$0 { viewModel.errorMessage = nil } })) { Button("OK", role: .cancel) {} } message: { Text(viewModel.errorMessage ?? "") }
        .navigationDestination(isPresented: $viewModel.showsResult) { if let session = viewModel.completedSession { Result(session: session) } }
    }

    private var transcriptCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Live transcript").font(.jakarta(14, weight: .bold))
            Text(viewModel.transcript.isEmpty ? "Your spoken words will appear here." : viewModel.transcript).foregroundStyle(viewModel.transcript.isEmpty ? Color.themeSecondary : Color.themePrimary).fixedSize(horizontal: false, vertical: true)
        }.frame(maxWidth: .infinity, alignment: .leading).padding(16).background(Color.white, in: RoundedRectangle(cornerRadius: AppRadius.large))
    }
}

private struct WaveformView: View {
    let level: Float; let isRecording: Bool
    var body: some View {
        HStack(spacing: 4) { ForEach(0..<24, id: \.self) { index in Capsule().fill(isRecording ? Color.themeMint : Color.themeSecondary.opacity(0.3)).frame(width: 4, height: max(8, CGFloat(level) * CGFloat(20 + (index % 5) * 12))) } }.frame(height: 60)
            .accessibilityLabel(isRecording ? "Recording in progress" : "Not recording")
    }
}
