import Foundation

protocol AudioPlaybackService {
    func playRecording(from url: URL) async throws
    func stopPlayback() async
}
