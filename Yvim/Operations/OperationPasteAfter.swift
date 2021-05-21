import Foundation

extension Operations {
    struct PasteAfter: Operation {
        let value: RegisterValue

        func perform(_ editor: BufferEditor) {
            value.pasteAfter(editor: editor)
        }
    }
}
