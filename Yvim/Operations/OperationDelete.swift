import Foundation

extension Operations {
    struct Delete: Operation {
        let register: Register
        let textObject: TextObject

        func perform(_ editor: BufferEditor) {
            editor.expandTextRange(textObject)
            editor.perform {
                register.register = $0.textRange.asRegisterValue
                $0.selectedText = ""
            }
        }
    }
}
