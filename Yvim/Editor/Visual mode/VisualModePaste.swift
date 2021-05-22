import Foundation

class VisualModePaste: EditorCommand {
    let register: Register
    let editor: BufferEditor
    let operationMemory: OperationMemory
    weak var modeSwitcher: EditorModeSwitcher?

    init(register: Register, operationMemory: OperationMemory, editor: BufferEditor, modeSwitcher: EditorModeSwitcher?) {
        self.register = register
        self.operationMemory = operationMemory
        self.editor = editor
        self.modeSwitcher = modeSwitcher
    }

    func handleEvent() {
        if let value = register.register {
            let operation = Operations.PasteOver(value: value)
            operation.perform(editor)
            operationMemory.mostRecentCommand = operation
        }
        modeSwitcher?.switchToCommandMode()
    }

}
