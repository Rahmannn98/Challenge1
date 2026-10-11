import AVFAudio
import Foundation

@MainActor
final class AudioPlaybackService {

    private var player: AVAudioPlayer?

    var isPlaying: Bool {
        player?.isPlaying ?? false
    }

    func play(url: URL) throws {
        guard FileManager.default.fileExists(atPath: url.path) else { throw AudioPlaybackError.fileNotFound }
        player = try AVAudioPlayer(contentsOf: url)

        player?.prepareToPlay()
        player?.play()
    }

    func stop() {

        player?.stop()
        player = nil
    }

    func pause() {

        player?.pause()
    }

    func resume() {

        player?.play()
    }
}

enum AudioPlaybackError: LocalizedError {

    case fileNotFound

    var errorDescription: String? {

        switch self {

        case .fileNotFound:
            return "Audio file could not be found."
        }
    }
}
