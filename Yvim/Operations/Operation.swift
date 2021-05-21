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
            var range = TextRange(text: $0.text, start: $0.cursorPosition)
            textObject.expand(&range)
            $0.selectedTextRange = range.cfRange
        }
    }
}
