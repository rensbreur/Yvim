import Foundation

extension TextObjects {
    struct Empty: TextObject {
        func expand(_ range: inout TextRange) {}
    }
}
