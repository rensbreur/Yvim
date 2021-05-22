import Foundation

extension LineMotions {
    struct Backward: LineMotion {
        func move(_ position: inout TextPosition) {
            position.moveBackwardInLine()
        }
    }
}
