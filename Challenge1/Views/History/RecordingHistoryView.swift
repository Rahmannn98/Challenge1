import SwiftUI

struct RecordingHistoryView: View {
    @Environment(PracticeSessionStore.self) private var store

    var body: some View {
        Group {
            if store.sessions.isEmpty {
                ContentUnavailableView("No practice yet", systemImage: "waveform", description: Text("Complete a recording to see it here."))
            } else {
                List(store.sessions) { session in
                    NavigationLink { Result(session: session) } label: {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(session.topicTitle).font(.headline)
                            Text(session.question).lineLimit(1).foregroundStyle(.secondary)
                            Text(session.startedAt, format: .dateTime.day().month().year().hour().minute()).font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Practice history")
    }
}
