import SwiftUI

struct Result: View {
    let session: PracticeSessionRecord
    @Environment(\.dismiss) private var dismiss
    @State private var player = AudioPlaybackService()

    var body: some View {
        ScrollView { VStack(alignment: .leading, spacing: 20) {
            Text("Your practice").font(.jakarta(30, weight: .bold)).foregroundStyle(Color.themePrimary)
            Text(session.question).font(.jakarta(17, weight: .bold))
            Text(session.startedAt, format: .dateTime.day().month().year().hour().minute()).foregroundStyle(Color.themeSecondary)
            recording
            transcript
            feedback
            Button("Choose another topic") { dismiss() }.practicePrimaryAction()
        }.padding(AppSpacing.screen) }.appScreenBackground().navigationBarBackButtonHidden().toolbar(.hidden, for: .navigationBar)
    }

    private var recording: some View {
        HStack { Button { if let name = session.audioFileName { try? player.play(url: PracticeSessionStore.recordingsDirectory.appending(path: name)) } } label: { Image(systemName: "play.fill").foregroundStyle(.white).padding().background(Color.themePrimary, in: Circle()) }.accessibilityLabel("Play recording").disabled(session.audioFileName == nil); Text(TimeFormatter.practiceTime(Int(session.duration))).font(.jakarta(16, weight: .bold)); Spacer() }
            .padding().background(Color.themeSky.opacity(0.45), in: RoundedRectangle(cornerRadius: AppRadius.large))
    }

    private var transcript: some View { VStack(alignment: .leading, spacing: 8) { Text("Transcript").font(.jakarta(17, weight: .bold)); Text(session.transcript.isEmpty ? "No speech was recognised. Your recording is still saved." : session.transcript).foregroundStyle(Color.themeSecondary) }.padding().background(Color.white, in: RoundedRectangle(cornerRadius: AppRadius.large)) }

    private var feedback: some View { VStack(alignment: .leading, spacing: 12) { Text("Practice feedback").font(.jakarta(17, weight: .bold)); if let feedback = session.feedback { score("PREP structure", feedback.prepScore); score("Clarity", feedback.clarityScore); score("Fluency (speaking rate)", feedback.fluencyScore); Text(feedback.summary); Text(feedback.limitations).font(.footnote).foregroundStyle(Color.themeSecondary) } else { Text("Feedback is unavailable because no spoken words were recognised.").foregroundStyle(Color.themeSecondary) } }.padding().background(Color.white, in: RoundedRectangle(cornerRadius: AppRadius.large)) }
    private func score(_ title: String, _ value: Int?) -> some View { HStack { Text(title); Spacer(); Text(value.map { "\($0)%" } ?? "Unavailable").fontWeight(.bold) } }
}
