import Foundation

extension Operations {
    struct Add: Operation {
        let text: String

        func perform(_ editor: BufferEditor) {
            editor.perform {
                $0.selectedTextRange = CFRangeMake($0.selectedTextRange.location + 1, 0)
            }
            editor.perform {
                $0.selectedText = text as NSString
            }
        }
    }
}
