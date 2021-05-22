import Foundation

extension TextObjects {
    struct InnerWord: TextObject {
        func expand(_ range: inout TextRange) {
            range.expandToBeginningOfWord()
            range.expandToEndOfWord()
        }
    }
}
