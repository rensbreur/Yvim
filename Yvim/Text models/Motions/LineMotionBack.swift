import Foundation

extension LineMotions {
    struct Back: LineMotion {
        func move(_ position: inout TextPosition) {
            position.moveToBeginningOfWord()
        }
    }
}
