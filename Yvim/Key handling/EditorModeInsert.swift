import Carbon.HIToolbox
import Foundation

class EditorModeInsert: EditorMode {
    let mode: Mode = .insert

    unowned var context: YvimKeyHandler

    init(context: YvimKeyHandler) {
        self.context = context
    }
    
    func handleKeyEvent(_ keyEvent: KeyEvent, simulateKeyPress: SimulateKeyPress) -> Bool {
        if keyEvent.keycode == kVK_Escape && keyEvent.event == .down {
            context.switchToCommandMode()
            return true
        }
        return false
    }
}
