import Foundation

extension Operations {
    struct DeleteLine: Operation {
        let register: Register
        let textObject: TextObject

        func perform(_ editor: BufferEditor) {
            editor.expandTextRange(textObject)
            editor.perform {
                register.register = LineRegisterValue(text: $0.selectedText as String)
                $0.selectedText = ""
            }
        }
    }
}
