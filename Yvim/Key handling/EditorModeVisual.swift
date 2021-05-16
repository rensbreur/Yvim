import Carbon.HIToolbox
import Foundation

class EditorModeVisual: EditorMode {
    let mode: Mode = .visual

    unowned var context: YvimKeyHandler

    let motionHandler: ParserKeyHandler<(Int, VimMotion)> = .motionWithMultiplierHandler

    init(context: YvimKeyHandler) {
        self.context = context
    }
    
    func handleKeyEvent(_ keyEvent: KeyEvent, simulateKeyPress: SimulateKeyPress) -> Bool {
        switch (keyEvent.char, keyEvent.event) {

        case (_, .up) where keyEvent.keycode == kVK_Escape:
            context.switchToCommandMode()
            return true

        case (KeyConstants.Motion.up, .down):
            simulateKeyPress(CGKeyCode(kVK_UpArrow), [.maskShift])

        case (KeyConstants.Motion.down, .down):
            simulateKeyPress(CGKeyCode(kVK_DownArrow), [.maskShift])

        case _ where motionHandler.feed(keyEvent, {
            context.editor.changeSelection($0.1, multiplier: $0.0, simulateKeyPress: simulateKeyPress)
        }):
            return true

        case (KeyConstants.delete, .down):
            context.editor.delete()
            context.switchToCommandMode()

        case (KeyConstants.yank, .down):
            context.editor.yank()
            context.switchToCommandMode()

        default:
            break

        }

        return true
    }
}
