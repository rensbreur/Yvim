import Foundation

class CommandModeChange: ParametrizedEditorCommand {
    let register: Register
    let commandMemory: CommandMemory
    let editor: BufferEditor
    weak var modeSwitcher: EditorModeSwitcher?

    init(register: Register, commandMemory: CommandMemory, editor: BufferEditor, modeSwitcher: EditorModeSwitcher?) {
        self.register = register
        self.commandMemory = commandMemory
        self.editor = editor
        self.modeSwitcher = modeSwitcher
    }

    func handle(textObject: TextObject) {
        let command = FreeTextCommands.Change(register: self.register, textObject: textObject)
        command.performFirstTime(editor)
        modeSwitcher?.switchToInsertMode(freeTextCommand: command)
    }

    func handleAsLine(textObject: TextObject) {
        let command = FreeTextCommands.Change(register: self.register, textObject: textObject)
        command.performFirstTime(editor)
        modeSwitcher?.switchToInsertMode(freeTextCommand: command)
    }
}
