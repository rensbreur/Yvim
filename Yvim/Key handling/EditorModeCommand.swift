import Carbon.HIToolbox
import Foundation

class EditorModeCommand: EditorMode {
    let mode: Mode = .command

    weak var modeSwitcher: EditorModeSwitcher?
    let register: Register
    let editor: BufferEditor
    let commandMemory: CommandMemory

    lazy var reader = CompositeReader(readers: [CommandModeMove(editor: editor, modeSwitcher: modeSwitcher),
                                                CommandModeDelete(register: register, commandMemory: commandMemory, editor: editor, modeSwitcher: modeSwitcher)])

    init(modeSwitcher: EditorModeSwitcher, register: Register, editor: BufferEditor, commandMemory: CommandMemory) {
        self.modeSwitcher = modeSwitcher
        self.register = register
        self.editor = editor
        self.commandMemory = commandMemory
    }

    func handleKeyEvent(_ keyEvent: KeyEvent, simulateKeyPress: SimulateKeyPress) -> Bool {
        guard keyEvent.event == .down else {
            return true
        }

        if keyEvent.key.keycode == kVK_Escape && keyEvent.event == .down {
            modeSwitcher?.switchToCommandMode()
            return true
        }

        if reader.feed(character: keyEvent.key.char) {
            return true
        }

        modeSwitcher?.switchToCommandMode()
        return true
    }
}
