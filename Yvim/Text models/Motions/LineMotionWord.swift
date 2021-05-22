import Foundation

extension LineMotions {
    struct Word: LineMotion {
        func move(_ position: inout TextPosition) {
            position.moveToNextWord()
        }
    }
}
