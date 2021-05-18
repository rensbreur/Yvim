import Carbon.HIToolbox
import Foundation

class EditorModeVisual: EditorMode {
    let mode: Mode = .visual

    unowned var context: YvimKeyHandler

    let multiplierReader = MultiplierReader()
    let motionReader = MotionReader()

    private var onKeyUp: (() -> Void)?

    init(context: YvimKeyHandler) {
        self.context = context
    }
    
    func handleKeyEvent(_ keyEvent: KeyEvent, simulateKeyPress: SimulateKeyPress) -> Bool {
        if keyEvent.event == .up {
            self.onKeyUp?()
            return true
        }

        if multiplierReader.feed(character: keyEvent.key.char) {
            return true
        }

        if motionReader.feed(character: keyEvent.key.char) {
            if let motion = motionReader.motion {
                context.editor.changeSelection(motion, multiplier: multiplierReader.multiplier ?? 1, simulateKeyPress: simulateKeyPress)
                context.switchToVisualMode()
            }
            return true
        }

        if keyEvent.key.char == KeyConstants.delete {
            context.editor.delete()
            context.switchToCommandMode()
            return true
        }

        if keyEvent.key.char == KeyConstants.yank {
            context.editor.yank()
            context.switchToCommandMode()
            return true
        }

        context.switchToCommandMode()
        return true
    }
}
