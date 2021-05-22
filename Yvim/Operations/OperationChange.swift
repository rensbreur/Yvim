import Foundation

extension Operations {
    struct Change: Operation {
        let register: Register
        let text: String
        let textObject: TextObject

        func perform(_ editor: BufferEditor) {
            editor.expandTextRange(textObject)
            editor.perform {
                register.register = $0.textRange.asRegisterValue
                $0.selectedText = text as NSString
            }
        }
    }
}
