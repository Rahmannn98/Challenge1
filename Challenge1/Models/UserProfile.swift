import Foundation

struct UserProfile: Codable, Equatable {
    var displayName: String

    var initials: String {
        let parts = displayName.split(whereSeparator: \.isWhitespace)
        let value = parts.prefix(2).compactMap { $0.first }.map(String.init).joined()
        return value.isEmpty ? "L" : value.uppercased()
    }
}
