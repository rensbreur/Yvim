import Carbon.HIToolbox
import Foundation

class EditorModeCommand: EditorMode, KeyPressSimulator {
    let mode: Mode = .command

    weak var modeSwitcher: EditorModeSwitcher?
    let register: Register
    let editor: BufferEditor
    let operationMemory: OperationMemory

    lazy var reader = CompositeReader(createCommands())

    private var _pressKeys: [(CGKeyCode, CGEventFlags)] = []

    func simulateKeyPress(_ keyCode: CGKeyCode, _ flags: CGEventFlags) {
        _pressKeys.append((keyCode, flags))
    }

    func createCommands() -> [Reader] {[
        MotionCommandHandler(
            command: CommandModeMove(editor: editor, keySimulator: self, modeSwitcher: modeSwitcher)
        ),
        ParametrizedCommandHandler(
            KeyConstants.delete,
            command: CommandModeDelete(register: register, operationMemory: operationMemory, editor: editor, modeSwitcher: modeSwitcher)
        ),
        ParametrizedCommandHandler(
            KeyConstants.yank,
            command: CommandModeYank(register: register, operationMemory: operationMemory, editor: editor, modeSwitcher: modeSwitcher)
        ),
        ParametrizedCommandHandler(
            KeyConstants.change,
            command: CommandModeChange(register: register, operationMemory: operationMemory, editor: editor, modeSwitcher: modeSwitcher)
        ),
        CommandHandler(
            KeyConstants.insert,
            command: CommandModeInsert(editor: editor, modeSwitcher: modeSwitcher)
        ),
        CommandHandler(
            KeyConstants.undo,
            command: CommandModeUndo(keySimulator: self, modeSwitcher: modeSwitcher)
        ),
        CommandHandler(
            KeyConstants.again,
            command: CommandModeRepeat(editor: editor, operationMemory: operationMemory, modeSwitcher: modeSwitcher)
        ),
        CommandHandler(
            KeyConstants.visual, command: CommandModeVisual(modeSwitcher: modeSwitcher)
        ),
        CommandHandler(
            KeyConstants.pasteBefore,
            command: CommandModePasteBefore(editor: editor, register: register, operationMemory: operationMemory, modeSwitcher: modeSwitcher)
        ),
        CommandHandler(
            KeyConstants.pasteAfter,
            command: CommandModePasteAfter(editor: editor, register: register, operationMemory: operationMemory, modeSwitcher: modeSwitcher)
        )
    ]}

    init(modeSwitcher: EditorModeSwitcher, register: Register, editor: BufferEditor, operationMemory: OperationMemory) {
        self.modeSwitcher = modeSwitcher
        self.register = register
        self.editor = editor
        self.operationMemory = operationMemory
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