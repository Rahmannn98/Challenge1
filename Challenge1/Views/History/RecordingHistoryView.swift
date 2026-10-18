import SwiftUI

struct RecordingHistoryView: View {
    @Environment(PracticeSessionStore.self) private var store

    var body: some View {
        Group {
            if store.sessions.isEmpty {
                ContentUnavailableView(
                    "No practice yet",
                    systemImage: "waveform",
                    description: Text("Complete a recording to see it here.")
                )
            } else {
                List(store.sessions) { session in
                    NavigationLink {
                        Result(session: session)
                    } label: {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(session.topicTitle)
                                .font(.jakarta(16, relativeTo: .headline, weight: .bold))
                                .foregroundStyle(Color.appTextPrimary)

                            Text(session.question)
                                .font(.jakarta(13, relativeTo: .subheadline, weight: .regular))
                                .lineLimit(1)
                                .foregroundStyle(Color.appTextSecondary)

                            Text(session.startedAt, format: .dateTime.day().month().year().hour().minute())
                                .font(.jakarta(11, relativeTo: .caption, weight: .medium))
                                .foregroundStyle(Color.appTextSecondary.opacity(0.8))
                        }
                        .padding(.vertical, 4)
                    }
                }
                .scrollContentBackground(.hidden)
            }
        }
        .appScreenBackground()
        .navigationTitle("Practice history")
        .tint(Color.appPrimary)
    }
}
