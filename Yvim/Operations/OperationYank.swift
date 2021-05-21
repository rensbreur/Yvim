import Foundation

extension Operations {
    struct Yank: Operation {
        let register: Register
        let textObject: TextObject

        func perform(_ editor: BufferEditor) {
            editor.expandTextRange(textObject)
            editor.perform {
                register.register = TextRegisterValue(text: $0.selectedText as String)
            }
        }
    }
}
