import Carbon.HIToolbox
import Combine

class YvimKeyHandler: KeyHandler {
    let editor: VimEditor

    @Published private(set) var mode: Mode = .command
    var active: Bool = false

    @Published private var state: EditorMode!

    private var subscriptions: Set<AnyCancellable> = []

    init(editor: VimEditor) {
        self.editor = editor
        self.mode = .command
        self.state = EditorModeCommand(context: self)
        $state
            .compactMap { $0?.mode }
            .sink { [weak self] in self?.mode = $0 }
            .store(in: &subscriptions)
    }

    func switchToCommandMode() {
        self.state = EditorModeCommand(context: self)
    }

    func switchToInsertMode() {
        self.state = EditorModeInsert(context: self)
    }

    func switchToVisualMode() {
        self.state = EditorModeVisual(context: self)
    }

    func handleKeyEvent(_ keyEvent: KeyEvent, simulateKeyPress: SimulateKeyPress) -> Bool {
        if !self.active {
            return false
        }

        if keyEvent.key.modifierKeys.contains(.maskCommand) {
            return false
        }

        if keyEvent.key.keycode == kVK_Escape && keyEvent.event == .down {
            switchToCommandMode()
            return true
        }

        return self.state.handleKeyEvent(keyEvent, simulateKeyPress: simulateKeyPress)
    }
}
