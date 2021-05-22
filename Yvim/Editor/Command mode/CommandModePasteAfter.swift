import Foundation

class CommandModePasteAfter: EditorCommand {
    let editor: BufferEditor
    let register: Register
    let operationMemory: OperationMemory
    weak var modeSwitcher: EditorModeSwitcher?

    init(editor: BufferEditor, register: Register, operationMemory: OperationMemory, modeSwitcher: EditorModeSwitcher?) {
        self.editor = editor
        self.register = register
        self.operationMemory = operationMemory
        self.modeSwitcher = modeSwitcher
    }

    let reader: Reader = SimpleReader(character: KeyConstants.pasteBefore)

    func handleEvent() {
        if let registerValue = register.register {
            let paste = Operations.PasteAfter(value: registerValue)
            paste.perform(editor)
            operationMemory.mostRecentCommand = paste
        }
        modeSwitcher?.switchToCommandMode()
    }
}
