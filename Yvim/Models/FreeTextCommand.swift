import Foundation

protocol FreeTextCommand {
    func performFirstTime(_ editor: BufferEditor)
    func repeatableCommand(string: String) -> Command
}

enum FreeTextCommands {
    struct Insert: FreeTextCommand {
        func performFirstTime(_ editor: BufferEditor) {
            // do nothing
        }

        func repeatableCommand(string: String) -> Command {
            return Commands.Insert(text: string)
        }
    }

    struct Add: FreeTextCommand {
        func performFirstTime(_ editor: BufferEditor) {
            editor.perform {
                $0.selectedTextRange = CFRangeMake($0.selectedTextRange.location + 1, 0)
            }
        }

        func repeatableCommand(string: String) -> Command {
            return Commands.Add(text: string)
        }
    }

    struct Change: FreeTextCommand {
        let register: Register
        let textObject: TextObject

        init(register: Register, textObject: TextObject) {
            self.register = register
            self.textObject = textObject
        }

        func performFirstTime(_ editor: BufferEditor) {
            Commands.Change(register: register, text: "", textObject: textObject).perform(editor)
        }

        func repeatableCommand(string: String) -> Command {
            Commands.Change(register: register, text: string, textObject: textObject)
        }
    }
}
