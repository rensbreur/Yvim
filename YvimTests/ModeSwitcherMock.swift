import Foundation
@testable import Yvim

class ModeSwitcherMock: EditorModeSwitcher {
    enum Mode {
        case command
        case insert(FreeTextOperation)
        case visual(VimSelection?)
    }

    var inCommandMode: Bool {
        if case .command = self.currentMode { return true }
        return false
    }

    var currentMode: Mode?

    private var _onKeyUp: (() -> Void)?

    func simulateKeyUp() {
        _onKeyUp?()
        _onKeyUp = nil
    }

    func switchToCommandMode() {
        currentMode = .command
    }

    func switchToInsertMode(freeTextCommand: FreeTextOperation) {
        currentMode = .insert(freeTextCommand)
    }

    func switchToVisualMode(selection: VimSelection?) {
        currentMode = .visual(selection)
    }

    func onKeyUp(_ block: @escaping () -> Void) {
        self._onKeyUp = block
    }


}
