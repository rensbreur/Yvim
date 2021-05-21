import Foundation

extension FreeTextOperations {
    struct Insert: FreeTextOperation {
        func performFirstTime(_ editor: BufferEditor) {
            // do nothing
        }

        func createOperation(string: String) -> Operation {
            return Operations.Insert(text: string)
        }
    }
}
