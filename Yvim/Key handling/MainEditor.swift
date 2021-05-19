import Carbon.HIToolbox
import Combine

protocol MainEditorProtocol: AnyObject {
    var register: Register { get }
    var editor: BufferEditor { get }
    var mostRecentCommand: Command? { get set }
    func onKeyUp(_ block: @escaping () -> Void)
    func switchToCommandMode()
    func switchToCommandParameterMode(completion: @escaping (Command) -> Void)
    func switchToInsertMode(freeTextCommand: FreeTextCommand)
    func switchToVisualMode(selection: VimSelection?)
}

class MainEditor: KeyHandler, MainEditorProtocol {
    let editor: BufferEditor

    let register = Register()

    @Published private(set) var mode: Mode = .command
    var active: Bool = false

    @Published private var state: EditorMode!

    private var subscriptions: Set<AnyCancellable> = []

    var mostRecentCommand: Command?

    private var _onKeyUp: (() -> Void)?

    func onKeyUp(_ block: @escaping () -> Void) {
        self._onKeyUp = block
    }

    init(editor: BufferEditor) {
        self.editor = editor
        self.mode = .command
        self.state = EditorModeCommand(mainEditor: self)
        $state
            .compactMap { $0?.mode }
            .sink { [weak self] in self?.mode = $0 }
            .store(in: &subscriptions)
    }

    func switchToCommandMode() {
        self.state = EditorModeCommand(mainEditor: self)
    }

    func switchToCommandParameterMode(completion: @escaping (Command) -> Void) {
        self.state = EditorModeCommandParameter(context: self, completion: completion)
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

        if let onKeyUp = self._onKeyUp {
            onKeyUp()
            self._onKeyUp = nil
        }

        return self.state.handleKeyEvent(keyEvent, simulateKeyPress: simulateKeyPress)
    }
}
