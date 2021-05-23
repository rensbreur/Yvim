import XCTest
@testable import Yvim

class BufferEditorMock: BufferEditor, Equatable {
    static func == (lhs: BufferEditorMock, rhs: BufferEditorMock) -> Bool {
        return lhs.text == rhs.text && lhs.selectedTextRange == rhs.selectedTextRange
    }

    var text: NSString
    var selectedTextRange: NSRange

    init(text: NSString, selectedTextRange: NSRange) {
        self.text = text
        self.selectedTextRange = selectedTextRange
    }

    convenience init(_ range: Yvim.TextRange) {
        self.init(text: range.text, selectedTextRange: range.nsRange)
    }

    convenience init(_ position: TextPosition) {
        self.init(text: position.text, selectedTextRange: NSMakeRange(position.position, 0))
    }

    var range: Yvim.TextRange {
        Yvim.TextRange(text: text, start: selectedTextRange.location, end: selectedTextRange.location + selectedTextRange.length - 1)
    }

    var position: TextPosition {
        XCTAssertEqual(selectedTextRange.length, 0)
        return TextPosition(text: text, position: selectedTextRange.location)
    }

    func getText() -> NSString {
        return text
    }

    func getSelectedTextRange() -> CFRange {
        return CFRangeMake(selectedTextRange.location, selectedTextRange.length)
    }

    func setSelectedTextRange(_ range: CFRange) {
        self.selectedTextRange = NSMakeRange(range.location, range.length)
    }

    func getSelectedText() -> NSString {
        text.substring(with: selectedTextRange) as NSString
    }

    func setSelectedText(_ text: NSString) {
        self.text = "\(self.text.substring(to: selectedTextRange.location))\(text as String)\(self.text.substring(from: selectedTextRange.location + selectedTextRange.length))" as NSString
        self.selectedTextRange = NSMakeRange(self.selectedTextRange.location + text.length, 0)
    }

}
