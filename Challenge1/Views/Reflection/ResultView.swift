import SwiftUI

struct Result: View {
    let session: PracticeSessionRecord
    @Environment(\.dismiss) private var dismiss
    @State private var player = AudioPlaybackService()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Your practice")
                    .font(.jakarta(30, relativeTo: .largeTitle, weight: .bold))
                    .foregroundStyle(Color.appTextPrimary)

                Text(session.question)
                    .font(.jakarta(17, relativeTo: .headline, weight: .bold))
                    .foregroundStyle(Color.appTextPrimary)

                Text(session.startedAt, format: .dateTime.day().month().year().hour().minute())
                    .font(.jakarta(13, relativeTo: .caption, weight: .medium))
                    .foregroundStyle(Color.appTextSecondary)

                recording
                transcript
                feedback

                Button("Choose another topic") {
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 17)
                .font(.jakarta(16, relativeTo: .headline, weight: .bold))
                .foregroundStyle(Color.white)
                .practicePrimaryAction()
            }
            .padding(AppSpacing.screen)
        }
        .appScreenBackground()
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
    }

    private var recording: some View {
        HStack(spacing: 14) {
            Button {
                if let name = session.audioFileName {
                    try? player.play(url: PracticeSessionStore.recordingsDirectory.appending(path: name))
                }
            } label: {
                Image(systemName: "play.fill")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(Color.appPrimary, in: Circle())
                    .shadow(color: Color.brandPlum.opacity(0.2), radius: 6, y: 3)
            }
            .accessibilityLabel("Play recording")
            .disabled(session.audioFileName == nil)

            VStack(alignment: .leading, spacing: 2) {
                Text("Audio recording")
                    .font(.jakarta(12, relativeTo: .caption, weight: .medium))
                    .foregroundStyle(Color.appTextSecondary)

                Text(TimeFormatter.practiceTime(Int(session.duration)))
                    .font(.jakarta(18, relativeTo: .headline, weight: .bold))
                    .foregroundStyle(Color.appTextPrimary)
            }

            Spacer()
        }
        .padding(16)
        .background(Color.appSurfaceSecondary, in: RoundedRectangle(cornerRadius: AppRadius.large))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous)
                .strokeBorder(Color.brandLavender.opacity(0.3), lineWidth: 1)
        )
    }

    private var transcript: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Transcript")
                .font(.jakarta(17, relativeTo: .headline, weight: .bold))
                .foregroundStyle(Color.appTextPrimary)

            Text(session.transcript.isEmpty ? "No speech was recognised. Your recording is still saved." : session.transcript)
                .font(.jakarta(14, relativeTo: .body, weight: .regular))
                .foregroundStyle(session.transcript.isEmpty ? Color.appTextSecondary : Color.appTextPrimary)
                .lineSpacing(3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color.white.opacity(0.95), in: RoundedRectangle(cornerRadius: AppRadius.large))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous)
                .strokeBorder(Color.brandLavender.opacity(0.25), lineWidth: 1)
        )
        .shadow(color: Color.brandPlum.opacity(0.04), radius: 10, y: 5)
    }

    private var feedback: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Practice feedback")
                .font(.jakarta(17, relativeTo: .headline, weight: .bold))
                .foregroundStyle(Color.appTextPrimary)

            if let feedback = session.feedback {
                score("PREP structure", feedback.prepScore)
                score("Clarity", feedback.clarityScore)
                score("Fluency (speaking rate)", feedback.fluencyScore)

                Divider()
                    .overlay(Color.brandLavender.opacity(0.25))

                Text(feedback.summary)
                    .font(.jakarta(14, relativeTo: .body, weight: .medium))
                    .foregroundStyle(Color.appTextPrimary)
                    .lineSpacing(2)

                Text(feedback.limitations)
                    .font(.jakarta(12, relativeTo: .footnote, weight: .regular))
                    .foregroundStyle(Color.appTextSecondary)
            } else {
                Text("Feedback is unavailable because no spoken words were recognised.")
                    .font(.jakarta(14, relativeTo: .body, weight: .medium))
                    .foregroundStyle(Color.appTextSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color.white.opacity(0.95), in: RoundedRectangle(cornerRadius: AppRadius.large))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous)
                .strokeBorder(Color.brandLavender.opacity(0.25), lineWidth: 1)
        )
        .shadow(color: Color.brandPlum.opacity(0.04), radius: 10, y: 5)
    }

    private func score(_ title: String, _ value: Int?) -> some View {
        HStack {
            Text(title)
                .font(.jakarta(14, relativeTo: .body, weight: .medium))
                .foregroundStyle(Color.appTextPrimary)
            Spacer()
            Text(value.map { "\($0)%" } ?? "Unavailable")
                .font(.jakarta(14, relativeTo: .body, weight: .bold))
                .foregroundStyle(Color.brandDeepLavender)
        }
    }
}
