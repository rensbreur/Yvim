import Foundation

enum Mode {
    case command
    case insert
    case visual

    var description: String {
        switch self {
        case .command:
            return "command"
        case .insert:
            return "insert"
        case .visual:
            return "visual"
        }
    }
}
