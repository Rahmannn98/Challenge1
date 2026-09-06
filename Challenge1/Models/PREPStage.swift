import Foundation

enum PREPStage: String, CaseIterable, Identifiable {
    case point
    case reason
    case example
    case closingPoint

    var id: Self { self }

    var title: String {
        switch self {
        case .point:
            return "Point"
        case .reason:
            return "Reason"
        case .example:
            return "Example"
        case .closingPoint:
            return "Point"
        }
    }

    var shortTitle: String {
        switch self {
        case .point:
            return "P"
        case .reason:
            return "R"
        case .example:
            return "E"
        case .closingPoint:
            return "P"
        }
    }
}
