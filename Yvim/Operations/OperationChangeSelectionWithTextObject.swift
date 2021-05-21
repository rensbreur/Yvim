import Foundation

extension Operations {
    struct ChangeSelectionWithTextObject: Operation {
        let textObject: TextObject

        func perform(_ editor: BufferEditor) {
            editor.perform {
                var range = TextRange(text: $0.text, start: $0.cursorPosition)
                textObject.expand(&range)
                $0.selectedTextRange = range.cfRange
            }
        }
    }
}
