import Carbon.HIToolbox
import Combine

class MainEditor: KeyHandler, EditorModeSwitcher {
    @Published private(set) var mode: Mode = .command
    var active: Bool = false

    let editor: BufferEditor
    let register = Register()
    let operationMemory: OperationMemory

    @Published private var state: EditorMode!

    private var subscriptions: Set<AnyCancellable> = []

    private var _onKeyUp: (() -> Void)?

    init(editor: BufferEditor) {
        self.editor = editor
        self.mode = .command
        self.operationMemory = OperationMemory()
        self.state = EditorModeCommand(modeSwitcher: self, register: register, editor: editor, operationMemory: operationMemory)
        $state
            .compactMap { $0?.mode }
            .sink { [weak self] in self?.mode = $0 }
            .store(in: &subscriptions)
    }

    func handleKeyEvent(_ keyEvent: KeyEvent, simulateKeyPress: SimulateKeyPress) -> Bool {
        if !self.active {
            return false
        }

        if keyEvent.key.modifierKeys.contains(.maskCommand) {
            return false
        }

        if let onKeyUp = self._onKeyUp {
            onKeyUp()
            self._onKeyUp = nil
        }

        return self.state.handleKeyEvent(keyEvent, simulateKeyPress: simulateKeyPress)
    }

    func switchToCommandMode() {
        self.state = EditorModeCommand(modeSwitcher: self, register: register, editor: editor, operationMemory: operationMemory)
    }

    func switchToInsertMode(freeTextCommand: FreeTextOperation) {
        self.state = EditorModeInsert(modeSwitcher: self, freeTextCommand: freeTextCommand, operationMemory: operationMemory)
    }

    func switchToVisualMode(selection: VimSelection? = nil) {
        self.state = EditorModeVisual(modeSwitcher: self, selection: selection, register: register, editor: editor, operationMemory: operationMemory)
    }

    func onKeyUp(_ block: @escaping () -> Void) {
        self._onKeyUp = block
    }

}
