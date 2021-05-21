import Foundation

/// Delays and combines actual calls to the buffer editor to increase performance.
class BufferEditorOperation {
    let editor: BufferEditor

    init (editor: BufferEditor) {
        self.editor = editor
    }

    private lazy var _text: NSString = editor.getText()
    private lazy var _selectedText: NSString = editor.getSelectedText()
    private lazy var _selectedTextRange: CFRange = editor.getSelectedTextRange()

    private var _newText: NSString?
    private var _newSelectedText: NSString?
    private var _newSelectedTextRange: CFRange?

    var text: NSString {
        get { _newText ?? _text }
        set { _newText = newValue } }
    var selectedText: NSString {
        get { _newSelectedText ?? _selectedText }
        set { _newSelectedText = newValue } }
    var selectedTextRange: CFRange {
        get { _newSelectedTextRange ?? _selectedTextRange }
        set { _newSelectedTextRange = newValue } }

    func commit() {
        if let selectedText = _newSelectedText {
            self.editor.setSelectedText(selectedText)
        }
        if let selectedTextRange = _newSelectedTextRange {
            self.editor.setSelectedTextRange(selectedTextRange)
        }
    }

}

extension BufferEditor {
    func operation() -> BufferEditorOperation {
        BufferEditorOperation(editor: self)
    }

    func perform(_ block: (BufferEditorOperation) -> Void) {
        let operation = self.operation()
        block(operation)
        operation.commit()
    }
}

extension BufferEditorOperation {
    var cursorPosition: Int {
        get { selectedTextRange.location }
        set { selectedTextRange = CFRangeMake(newValue, 0) }
    }

    var textPosition: TextPosition {
        TextPosition(text: text, position: cursorPosition)
    }

    var textRange: TextRange {
        TextRange(text: text, start: selectedTextRange.location, end: selectedTextRange.location + selectedTextRange.length - 1)
    }
}
