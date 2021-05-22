import Foundation

extension Operations {
    struct Yank: Operation {
        let register: Register
        let textObject: TextObject

        func perform(_ editor: BufferEditor) {
            editor.perform {
                var range = $0.textRange
                textObject.expand(&range)
                register.register = range.asRegisterValue
            }
        }
    }
}
