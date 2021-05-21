import Foundation

class CommandModeDelete: ParametrizedEditorCommand {
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
        let command = Commands.Delete(register: self.register, textObject: textObject)
        command.perform(editor)
        commandMemory.mostRecentCommand = command
        modeSwitcher?.switchToCommandMode()
    }

    func handleAsLine(textObject: TextObject) {
        let textObject = TextObjects.Line()
        let command = Commands.DeleteLine(register: self.register, textObject: textObject)
        command.perform(editor)
        commandMemory.mostRecentCommand = command
        modeSwitcher?.switchToCommandMode()
    }
}
