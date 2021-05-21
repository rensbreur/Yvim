import Foundation

extension Operations {
    struct Composite: Operation {
        let operations: [Operation]

        func perform(_ editor: BufferEditor) {
            for operation in operations {
                operation.perform(editor)
            }
        }
    }
}
