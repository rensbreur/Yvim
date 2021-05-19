import Carbon.HIToolbox
import Combine

class YvimKeyHandler: KeyHandler {
    let editor: BufferEditor

    let register = Register()

    @Published private(set) var mode: Mode = .command
    var active: Bool = false

    @Published private var state: EditorMode!

    private var subscriptions: Set<AnyCancellable> = []

    var mostRecentCommand: Command?

    init(editor: BufferEditor) {
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

    func switchToCommandParameterMode(command: Command, multiplier: Int) {
        self.state = EditorModeCommandParameter(context: self, command: command, multiplier: multiplier)
    }

    func switchToInsertMode(freeTextCommand: FreeTextCommand) {
        self.state = EditorModeInsert(context: self, freeTextCommand: freeTextCommand)
    }

    func switchToVisualMode(selection: VimSelection? = nil) {
        self.state = EditorModeVisual(context: self, selection: selection)
    }

    func handleKeyEvent(_ keyEvent: KeyEvent, simulateKeyPress: SimulateKeyPress) -> Bool {
        if !self.active {
            return false
        }

        if keyEvent.key.modifierKeys.contains(.maskCommand) {
            return false
        }

        return self.state.handleKeyEvent(keyEvent, simulateKeyPress: simulateKeyPress)
    }
}
