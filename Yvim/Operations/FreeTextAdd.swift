import Foundation

extension FreeTextOperations {
    struct Add: FreeTextOperation {
        func performFirstTime(_ editor: BufferEditor) {
            editor.perform {
                $0.selectedTextRange = CFRangeMake($0.selectedTextRange.location + 1, 0)
            }
        }

        func createOperation(string: String) -> Operation {
            return Operations.Add(text: string)
        }
    }
}
