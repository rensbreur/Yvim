import Foundation

extension LineMotions {
    struct LineEnd: LineMotion {
        func move(_ position: inout TextPosition) {
            position.moveToEndOfLine()
        }
    }
}
