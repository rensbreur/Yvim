import Carbon.HIToolbox
import Foundation

class EditorModeCommand: EditorMode {
    let mode: Mode = .command

    unowned var context: YvimKeyHandler

    let motionHandler: ParserKeyHandler<(Int, VimMotion)> = .motionWithMultiplierHandler

    init(context: YvimKeyHandler) {
        self.context = context
    }

    func handleKeyEvent(_ keyEvent: KeyEvent, simulateKeyPress: SimulateKeyPress) -> Bool {
        switch (keyEvent.char, keyEvent.event) {

        case (KeyConstants.Motion.up, .down):
            simulateKeyPress(CGKeyCode(kVK_UpArrow), [])

        case (KeyConstants.Motion.down, .down):
            simulateKeyPress(CGKeyCode(kVK_DownArrow), [])

        case _ where motionHandler.feed(keyEvent, {
            context.editor.move($0.1, multiplier: $0.0, simulateKeyPress: simulateKeyPress)
        }):
            return true

        case (KeyConstants.insert, .up):
            context.switchToInsertMode()

        case (KeyConstants.add, .down):
            simulateKeyPress(CGKeyCode(kVK_RightArrow), [])
        case (KeyConstants.add, .up):
            context.switchToInsertMode()

        case (KeyConstants.newLine, .down):
            simulateKeyPress(keycodeForString("e"), [.maskControl])
            simulateKeyPress(CGKeyCode(kVK_ANSI_KeypadEnter), [])
        case (KeyConstants.newLine, .up):
            context.switchToInsertMode()

        case (KeyConstants.visual, .up):
            context.switchToVisualMode()

        case (KeyConstants.paste, .down):
            context.editor.paste()

        default:
            break

        }

        return true
    }
}
