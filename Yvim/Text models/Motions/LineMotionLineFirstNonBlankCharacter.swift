import Foundation

extension LineMotions {
    struct LineFirstNonBlankCharacter: LineMotion {
        func move(_ position: inout TextPosition) {
            position.moveToBeginningOfLine()
            position.moveForward(ensuring: { $0 == " " })
            position.moveForward()
        }
    }
}
