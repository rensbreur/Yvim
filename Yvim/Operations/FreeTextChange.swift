import Foundation

extension FreeTextOperations {
    struct Change: FreeTextOperation {
        let register: Register
        let textObject: TextObject

        init(register: Register, textObject: TextObject) {
            self.register = register
            self.textObject = textObject
        }

        func performFirstTime(_ editor: BufferEditor) {
            editor.perform {
                var range = TextRange(text: $0.text, start: $0.cursorPosition)
                textObject.expand(&range)
                register.register = range.asRegisterValue
                if range.coversFullLines { range.shrinkBackward() }
                $0.selectedTextRange = range.cfRange
            }
            editor.perform {
                $0.selectedText = "" as NSString
            }
        }

        func createOperation(string: String) -> Operation {
            Operations.Change(register: register, text: string, textObject: textObject)
        }
    }
}
