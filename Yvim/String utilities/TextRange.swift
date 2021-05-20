import Foundation

struct TextRange {
    let text: NSString
    var start: Int
    var end: Int
}

extension TextRange {
    var startCharacter: unichar? {
        text.safeCharacter(at: start)
    }

    var endCharacter: unichar? {
        text.safeCharacter(at: end)
    }

    var precedingCharacter: unichar? {
        text.safeCharacter(at: start - 1)
    }

    var proceedingCharacter: unichar? {
        text.safeCharacter(at: end + 1)
    }

    mutating func expandForward(ensuring condition: (unichar) -> Bool) {
        while let char = proceedingCharacter, condition(char) {
            end += 1
        }
    }

    mutating func expandBackward(ensuring condition: (unichar) -> Bool) {
        while let char = precedingCharacter, condition(char) {
            start -= 1
        }
    }

    mutating func expandForwardInLine() {
        if let char = proceedingCharacter, char != "\n" {
            end += 1
        }
    }

    mutating func expandBackwardInLine() {
        if let char = precedingCharacter, char != "\n" {
            start -= 1
        }
    }

    mutating func expandForward() {
        let pos = end + 1
        if pos < text.length {
            end = pos
        }
    }

    mutating func expandBackward() {
        let pos = end - 1
        if pos >= 0 {
            end = pos
        }
    }

    mutating func expandToEndOfWord() {
        if let current = endCharacter, current.isAlphanumeric {
            expandForward(ensuring: \.isAlphanumeric)
        }
    }

    mutating func expandToBeginningOfWord() {
        if let current = startCharacter, current.isAlphanumeric {
            expandBackward(ensuring: \.isAlphanumeric)
        }
    }

    mutating func expandToBeginningOfLine() {
        expandBackward(ensuring: { $0 != "\n" })
    }

    mutating func expandToNewline() {
        expandForward(ensuring: { $0 != "\n" })
        expandForward()
    }

}

extension TextRange: Equatable {}
