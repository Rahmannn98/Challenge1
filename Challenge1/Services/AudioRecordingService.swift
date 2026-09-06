import Foundation

protocol AudioRecordingService {
    func startRecording() async throws
    func stopRecording() async throws -> URL?
}
