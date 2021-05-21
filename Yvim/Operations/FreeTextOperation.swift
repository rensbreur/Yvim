import Foundation

/// An operation that can be repeated with text entered in insert mode
protocol FreeTextOperation {
    func performFirstTime(_ editor: BufferEditor)
    func createOperation(string: String) -> Operation
}

/// Namespace for free text operations
enum FreeTextOperations {}
