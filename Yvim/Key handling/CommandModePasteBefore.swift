import Foundation

class CommandModePasteBefore: EditorCommand {
    let editor: BufferEditor
    let register: Register
    let commandMemory: CommandMemory
    weak var modeSwitcher: EditorModeSwitcher?

    init(editor: BufferEditor, register: Register, commandMemory: CommandMemory, modeSwitcher: EditorModeSwitcher?) {
        self.editor = editor
        self.register = register
        self.commandMemory = commandMemory
        self.modeSwitcher = modeSwitcher
    }

    let reader: Reader = SimpleReader(character: KeyConstants.pasteBefore)

    func handleEvent() {
        if let registerValue = register.register {
            let paste = Commands.PasteBefore(value: registerValue)
            paste.perform(editor)
            commandMemory.mostRecentCommand = paste
        }
        modeSwitcher?.switchToCommandMode()
    }
}
