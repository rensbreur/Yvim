import Foundation

class CommandModeDelete: ParametrizedEditorCommand {
    let register: Register
    let operationMemory: OperationMemory
    let editor: BufferEditor
    weak var modeSwitcher: EditorModeSwitcher?

    init(register: Register, operationMemory: OperationMemory, editor: BufferEditor, modeSwitcher: EditorModeSwitcher?) {
        self.register = register
        self.operationMemory = operationMemory
        self.editor = editor
        self.modeSwitcher = modeSwitcher
    }

    func handle(textObject: TextObject) {
        let command = Operations.Delete(register: self.register, textObject: textObject)
        command.perform(editor)
        operationMemory.mostRecentCommand = command
        modeSwitcher?.switchToCommandMode()
    }

    func handleAsLine(textObject: TextObject) {
        let textObject = TextObjects.Line()
        let command = Operations.DeleteLine(register: self.register, textObject: textObject)
        command.perform(editor)
        operationMemory.mostRecentCommand = command
        modeSwitcher?.switchToCommandMode()
    }
}
