import Foundation
import Observation

@Observable
@MainActor
final class PracticeSessionStore {
    private enum Key { static let snapshot = "practice-session-store-v1" }

    private struct Snapshot: Codable {
        var profile: UserProfile
        var sessions: [PracticeSessionRecord]
    }

    private(set) var profile: UserProfile
    private(set) var sessions: [PracticeSessionRecord]

    init(defaults: UserDefaults = .standard) {
        if let data = defaults.data(forKey: Key.snapshot),
           let snapshot = try? JSONDecoder().decode(Snapshot.self, from: data) {
            profile = snapshot.profile
            sessions = snapshot.sessions.sorted { $0.startedAt > $1.startedAt }
        } else {
            profile = UserProfile(displayName: "Learner")
            sessions = []
        }
    }

    func updateProfile(name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        profile.displayName = trimmed
        persist()
    }

    func save(_ session: PracticeSessionRecord) {
        guard !sessions.contains(where: { $0.id == session.id }) else { return }
        sessions.insert(session, at: 0)
        persist()
    }

    func audioURL(for session: PracticeSessionRecord) -> URL? {
        guard let name = session.audioFileName else { return nil }
        return Self.recordingsDirectory.appending(path: name)
    }

    static var recordingsDirectory: URL {
        let url = URL.documentsDirectory.appending(path: "Recordings", directoryHint: .isDirectory)
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }

    private func persist() {
        let snapshot = Snapshot(profile: profile, sessions: sessions)
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        UserDefaults.standard.set(data, forKey: Key.snapshot)
    }
}
