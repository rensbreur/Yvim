import Foundation

extension Operations {
    struct ChangeSelectionWithTextObject: Operation {
        let textObject: TextObject

        func perform(_ editor: BufferEditor) {
            editor.perform {
                let newRange = textObject.range(from: $0.cursorPosition, in: $0.text)
                $0.selectedTextRange = newRange
            }
        }
    }
}
