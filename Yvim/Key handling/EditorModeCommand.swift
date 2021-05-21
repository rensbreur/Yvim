import Carbon.HIToolbox
import Foundation

class EditorModeCommand: EditorMode, KeyPressSimulator {
    let mode: Mode = .command

    weak var modeSwitcher: EditorModeSwitcher?
    let register: Register
    let editor: BufferEditor
    let commandMemory: CommandMemory

    lazy var reader = CompositeReader(createCommands())

    private var _pressKeys: [(CGKeyCode, CGEventFlags)] = []

    func simulateKeyPress(_ keyCode: CGKeyCode, _ flags: CGEventFlags) {
        _pressKeys.append((keyCode, flags))
    }

    func createCommands() -> [Reader] {[
        MotionCommandHandler(command: CommandModeMove(editor: editor, keySimulator: self, modeSwitcher: modeSwitcher)),
        ParametrizedCommandHandler("d", command: CommandModeDelete(register: register, commandMemory: commandMemory, editor: editor, modeSwitcher: modeSwitcher)),
        ParametrizedCommandHandler("c", command: CommandModeChange(register: register, commandMemory: commandMemory, editor: editor, modeSwitcher: modeSwitcher)),
        CommandHandler("i", command: CommandModeInsert(editor: editor, modeSwitcher: modeSwitcher)),
        CommandHandler("v", command: CommandModeVisual(modeSwitcher: modeSwitcher)),
       CommandHandler("P", command: CommandModePasteBefore(editor: editor, register: register, commandMemory: commandMemory, modeSwitcher: modeSwitcher))
    ]}

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

        if reader.feed(character: keyEvent.key.char) {
            for key in _pressKeys { simulateKeyPress(key.0, key.1) }
            _pressKeys = []
            return true
        }

        modeSwitcher?.switchToCommandMode()
        return true
    }
}

protocol KeyPressSimulator: AnyObject {
    func simulateKeyPress(_ keyCode: CGKeyCode, _ flags: CGEventFlags) -> Void
}
