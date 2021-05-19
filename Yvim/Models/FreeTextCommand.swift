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
        let selection: Command?

        init(register: Register, selection: Command? = nil) {
            self.register = register
            self.selection = selection
        }

        func performFirstTime(_ editor: BufferEditor) {
            selection?.perform(editor)
            Commands.Delete(register: register).perform(editor)
        }

        func repeatableCommand(string: String) -> Command {
            let change = Commands.Change(register: register, text: string)
            return Commands.Composite(commands: [selection, change].compactMap { $0 })
        }
    }
}
