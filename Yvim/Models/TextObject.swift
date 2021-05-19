import Foundation

protocol TextObject {
    func expand(_ range: inout TextRange)
}

extension TextObject {
    func range(from index: Int, in text: NSString) -> CFRange {
        var range = TextRange(text: text, start: index, end: index + 1)
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
}
