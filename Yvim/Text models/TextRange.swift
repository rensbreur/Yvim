import Foundation

struct TextRange {
    let text: NSString
    var start: Int
    var end: Int

    init (text: NSString, start: Int, end: Int) {
        self.text = text
        self.start = start
        self.end = max(start, end)
    }

    init(text: NSString, start: Int) {
        self.init(text: text, start: start, end: start)
    }
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

    var textInRange: NSString {
        self.text.substring(with: NSMakeRange(start, length)) as NSString
    }

    var startsAtBeginningOfLine: Bool {
        start == 0 || precedingCharacter == "\n"
    }

    var endsAtEndOfLine: Bool {
        end == text.length - 1 || endCharacter == "\n"
    }

    var coversFullLines: Bool {
        startsAtBeginningOfLine && endsAtEndOfLine
    }

    var length: Int {
        return end + 1 - start
    }

    var cfRange: CFRange {
        CFRangeMake(start, length)
    }

    var nsRange: NSRange {
        NSMakeRange(start, length)
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
        let pos = start - 1
        if pos >= 0 {
            start = pos
        }
    }

    mutating func shrinkBackward() {
        let pos = end - 1
        if pos >= start {
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
        guard endCharacter != "\n" else { return }
        expandForward(ensuring: { $0 != "\n" })
        expandForward()
    }

}

extension TextRange: Equatable {}
