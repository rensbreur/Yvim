import Foundation

extension Operations {
    struct Insert: Operation {
        let text: String

        func perform(_ editor: BufferEditor) {
            editor.perform {
                $0.selectedText = text as NSString
            }
        }
    }
}
