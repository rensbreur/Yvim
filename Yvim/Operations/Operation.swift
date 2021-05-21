import Foundation

/// Operations represent a change to the text that is repeatable
protocol Operation {
    func perform(_ editor: BufferEditor)
}

/// Namespace for operations
enum Operations {}

extension BufferEditor {
    func expandTextRange(_ textObject: TextObject) {
        perform {
            let newRange = textObject.range(from: $0.cursorPosition, in: $0.text)
            $0.selectedTextRange = newRange
        }
    }
}
