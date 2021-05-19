import Carbon.HIToolbox
import Foundation

class EditorModeCommand: EditorMode {
    let mode: Mode = .command

    unowned var context: YvimKeyHandler

    let multiplierReader = MultiplierReader()
    let motionReader = MotionReader()
    lazy var selectionCommandReader = SelectionCommandReader(commandFactory: CommandFactory(register: context.register))

    private var onKeyUp: (() -> Void)?

    init(context: YvimKeyHandler) {
        self.context = context
    }

    func handleKeyEvent(_ keyEvent: KeyEvent, simulateKeyPress: SimulateKeyPress) -> Bool {
        if keyEvent.event == .up {
            self.onKeyUp?()
            return true
        }

        if keyEvent.key.keycode == kVK_Escape && keyEvent.event == .down {
            context.switchToCommandMode()
            return true
        }

        if multiplierReader.feed(character: keyEvent.key.char) {
            return true
        }

        if motionReader.feed(character: keyEvent.key.char) {
            if let motion = motionReader.motion {
                let motion = Commands.Move(motion: motion.multiplied(multiplierReader.multiplier ?? 1))
                motion.perform(context.editor)
                context.switchToCommandMode()
            }
            return true
        }

        if selectionCommandReader.feed(character: keyEvent.key.char) {
            if let command = selectionCommandReader.command {
                context.switchToCommandParameterMode(command: command, multiplier: multiplierReader.multiplier ?? 1)
            }
            return true
        }

        if keyEvent.key.char == KeyConstants.insert {
            let insert = FreeTextCommands.Insert()
            insert.performFirstTime(context.editor)
            onKeyUp = { [weak self] in self?.context.switchToInsertMode(freeTextCommand: insert) }
            return true
        }

        if keyEvent.key.char == KeyConstants.add {
            let add = FreeTextCommands.Add()
            add.performFirstTime(context.editor)
            onKeyUp = { [weak self] in self?.context.switchToInsertMode(freeTextCommand: add) }
            return true
        }

        if keyEvent.key.char == KeyConstants.visual {
            onKeyUp = { [weak self] in self?.context.switchToVisualMode() }
            return true
        }

        if keyEvent.key.char == KeyConstants.VerticalMotion.up {
            simulateKeyPress(CGKeyCode(kVK_UpArrow), [])
            context.switchToCommandMode()
            return true
        }

        if keyEvent.key.char == KeyConstants.VerticalMotion.down {
            simulateKeyPress(CGKeyCode(kVK_DownArrow), [])
            context.switchToCommandMode()
            return true
        }

        if keyEvent.key.char == KeyConstants.undo {
            simulateKeyPress(keycodeForString("z"), [.maskCommand])
            context.switchToCommandMode()
            return true
        }

        if keyEvent.key.char == KeyConstants.again {
            context.mostRecentCommand?.perform(context.editor)
            context.switchToCommandMode()
            return true
        }

        context.switchToCommandMode()
        return true
    }
}
