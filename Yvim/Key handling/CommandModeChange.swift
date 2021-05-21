import Foundation

class CommandModeChange: ParametrizedEditorCommand {
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
        let command = FreeTextOperations.Change(register: self.register, textObject: textObject)
        command.performFirstTime(editor)
        modeSwitcher?.switchToInsertMode(freeTextCommand: command)
    }

    func handleAsLine(textObject: TextObject) {
        let command = FreeTextOperations.Change(register: self.register, textObject: textObject)
        command.performFirstTime(editor)
        modeSwitcher?.switchToInsertMode(freeTextCommand: command)
    }
}
