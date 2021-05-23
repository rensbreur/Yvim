import Foundation

class Register {
    // Delete/yank/paste register
    var register: RegisterValue?
}

protocol RegisterValue {
    func pasteBefore(editor: BufferEditor)
    func pasteAfter(editor: BufferEditor)
    func pasteOver(editor: BufferEditor)
}

extension TextRange {
    var asRegisterValue: RegisterValue {
        if coversFullLines {
            return LineRegisterValue(text: textInRange as String)
        }
        return TextRegisterValue(text: textInRange as String)
    }
}

struct TextRegisterValue: RegisterValue, Equatable {
    let text: String

    func pasteBefore(editor: BufferEditor) {
        editor.perform {
            $0.selectedText = text as NSString
        }
    }

    func pasteOver(editor: BufferEditor) {
        editor.perform {
            $0.selectedText = text as NSString
        }
    }

    func pasteAfter(editor: BufferEditor) {
        editor.perform {
            $0.cursorPosition += 1
        }
        editor.perform {
            $0.selectedText = text as NSString
        }
    }
}

struct LineRegisterValue: RegisterValue, Equatable {
    let text: String

    var line: String {
        if text.last != "\n" { return text + "\n" }
        return text
    }

    func pasteBefore(editor: BufferEditor) {
        Operations.Move(motion: LineMotions.LineStart()).perform(editor)
        editor.perform {
            $0.selectedText = text as NSString
        }
    }

    func pasteOver(editor: BufferEditor) {
        editor.perform {
            $0.selectedText = "\n" + text as NSString
        }
    }

    func pasteAfter(editor: BufferEditor) {
        Operations.Move(motion: LineMotions.LineEnd()).perform(editor)
        editor.perform {
            var position = $0.textPosition
            position.moveToEndOfLine()
            position.moveForward()
            position.moveForward()
            $0.cursorPosition = position.position
        }
        editor.perform {
            $0.selectedText = text as NSString
        }
    }
}
