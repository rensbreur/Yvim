import Foundation

protocol Command {
    func perform(_ editor: BufferEditor)
}

enum Commands {
    struct Delete: Command {
        let register: Register
        let textObject: TextObject

        func perform(_ editor: BufferEditor) {
            editor.expandTextRange(textObject)
            editor.perform {
                register.register = $0.selectedText as String
                $0.selectedText = ""
            }
        }
    }

    struct Yank: Command {
        let register: Register
        let textObject: TextObject

        func perform(_ editor: BufferEditor) {
            editor.expandTextRange(textObject)
            editor.perform {
                register.register = $0.selectedText as String
            }
        }
    }

    struct Paste: Command {
        let register: Register
        let textObject: TextObject

        func perform(_ editor: BufferEditor) {
            editor.expandTextRange(textObject)
            editor.perform {
                $0.selectedText = register.register as NSString
            }
        }
    }

    struct PasteBefore: Command {
        let register: Register

        func perform(_ editor: BufferEditor) {
            editor.perform {
                $0.selectedText = register.register as NSString
            }
        }
    }

    struct PasteAfter: Command {
        let register: Register

        func perform(_ editor: BufferEditor) {
            editor.perform {
                $0.selectedTextRange = CFRangeMake($0.selectedTextRange.location + 1, 0)
            }
            editor.perform {
                $0.selectedText = register.register as NSString
            }
        }
    }

    struct Move: Command {
        let motion: LineMotion

        func perform(_ editor: BufferEditor) {
            editor.perform {
                $0.cursorPosition = motion.index(from: $0.cursorPosition, in: $0.text)
            }
        }
    }

    struct Insert: Command {
        let text: String

        func perform(_ editor: BufferEditor) {
            editor.perform {
                $0.selectedText = text as NSString
            }
        }
    }

    struct Add: Command {
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

    struct Change: Command {
        let register: Register
        let text: String
        let textObject: TextObject

        func perform(_ editor: BufferEditor) {
            editor.expandTextRange(textObject)
            editor.perform {
                register.register = $0.selectedText as String
                $0.selectedText = text as NSString
            }
        }
    }

    struct ChangeSelection: Command {
        let motion: LineMotion

        func perform(_ editor: BufferEditor) {
            editor.perform {
                let motionEndIndex = motion.index(from: $0.selectedTextRange.location + $0.selectedTextRange.length - 1, in: $0.text)
                $0.selectedTextRange = CFRangeMake($0.cursorPosition, motionEndIndex - $0.cursorPosition + 1)
            }
        }
    }

    struct ChangeSelectionWithTextObject: Command {
        let textObject: TextObject

        func perform(_ editor: BufferEditor) {
            editor.perform {
                let newRange = textObject.range(from: $0.cursorPosition, in: $0.text)
                $0.selectedTextRange = newRange
            }
        }
    }

    struct Composite: Command {
        let commands: [Command]

        func perform(_ editor: BufferEditor) {
            for command in commands {
                command.perform(editor)
            }
        }
    }
}

extension BufferEditor {
    func expandTextRange(_ textObject: TextObject) {
        perform {
            let newRange = textObject.range(from: $0.cursorPosition, in: $0.text)
            $0.selectedTextRange = newRange
        }
    }
}
