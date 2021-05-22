import Foundation

extension LineMotions {
    struct Forward: LineMotion {
        func move(_ position: inout TextPosition) {
            position.moveForwardInLine()
        }
    }
}
