import Foundation

extension Operations {
    struct ChangeSelection: Operation {
        let motion: LineMotion

        func perform(_ editor: BufferEditor) {
            editor.perform {
                let motionEndIndex = motion.index(from: $0.selectedTextRange.location + $0.selectedTextRange.length - 1, in: $0.text)
                $0.selectedTextRange = CFRangeMake($0.cursorPosition, motionEndIndex - $0.cursorPosition + 1)
            }
        }
    }
}
