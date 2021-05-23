@testable import Yvim
import Foundation

extension TextPosition {
    /// Alows initialization like
    /// ```
    /// let pos = TextPosition("    func abcd123(_ parameter: parameter) {",
    ///                        "                 ^                        ")
    /// ```
    init(_ text: String, _ cursor: String) {
        let position = text.distance(from: text.startIndex, to: cursor.firstIndex(of: "^")!)
        self.init(text: text as NSString, position: position)
    }
}
