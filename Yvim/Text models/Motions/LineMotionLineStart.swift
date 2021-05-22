import Foundation

extension LineMotions {
    struct LineStart: LineMotion {
        func move(_ position: inout TextPosition) {
            position.moveToBeginningOfLine()
        }
    }
}
