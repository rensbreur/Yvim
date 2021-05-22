import Foundation

extension Operations {
    struct Move: Operation {
        let motion: LineMotion

        func perform(_ editor: BufferEditor) {
            editor.perform {
                $0.cursorPosition = motion.index(from: $0.cursorPosition, in: $0.text)
            }
        }
    }
}
