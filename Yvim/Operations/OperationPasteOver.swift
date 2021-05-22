import Foundation

extension Operations {
    struct PasteOver: Operation {
        let value: RegisterValue

        func perform(_ editor: BufferEditor) {
            value.pasteOver(editor: editor)
        }
    }
}
