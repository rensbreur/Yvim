import Foundation

class CommandModeYank: ParametrizedEditorCommand {
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
        let command = Operations.Yank(register: self.register, textObject: textObject)
        command.perform(editor)
        modeSwitcher?.switchToCommandMode()
    }

}
