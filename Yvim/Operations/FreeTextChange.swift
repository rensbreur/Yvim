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
            Operations.Change(register: register, text: "", textObject: textObject).perform(editor)
        }

        func createOperation(string: String) -> Operation {
            Operations.Change(register: register, text: string, textObject: textObject)
        }
    }
}
