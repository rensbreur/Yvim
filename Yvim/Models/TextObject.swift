import Foundation

protocol TextObject {
    func expand(_ range: inout TextRange)
}

extension TextObject {
    func range(from index: Int, in text: NSString) -> CFRange {
        var range = TextRange(text: text, start: index, end: index)
        expand(&range)
        return CFRangeMake(range.start, range.end + 1 - range.start)
    }
}

enum TextObjects {
    struct InnerWord: TextObject {
        func expand(_ range: inout TextRange) {
            range.expandToBeginningOfWord()
            range.expandToEndOfWord()
        }
    }

    struct Line: TextObject {
        func expand(_ range: inout TextRange) {
            range.expandToBeginningOfLine()
            range.expandToNewline()
        }
    }

    struct Empty: TextObject {
        func expand(_ range: inout TextRange) {
            // do nothing
        }
    }

    struct FromMotion: TextObject {
        let motion: LineMotion

        func expand(_ range: inout TextRange) {
            let a = range.start
            let b = motion.index(from: a, in: range.text)
            range.start = min(a, b)
            range.end = max(a, b)
        }
    }
}
