import Foundation

extension Operations {
    struct PasteBefore: Operation {
        let value: RegisterValue

        func perform(_ editor: BufferEditor) {
            value.pasteBefore(editor: editor)
        }
    }
}
