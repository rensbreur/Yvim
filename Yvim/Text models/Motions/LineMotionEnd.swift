import Foundation

extension LineMotions {
    struct End: LineMotion {
        func move(_ position: inout TextPosition) {
            position.moveToEndOfWord()
        }
    }
}
