import Carbon.HIToolbox
import Foundation

class EditorModeCommand: EditorMode {
    let mode: Mode = .command

    unowned var mainEditor: MainEditorProtocol

    let multiplierReader = MultiplierReader()
    let motionReader = MotionReader()
    lazy var selectionCommandReader = SelectionCommandReader(commandFactory: CommandFactory(register: mainEditor.register))

    init(mainEditor: MainEditorProtocol) {
        self.mainEditor = mainEditor
    }

    func handleKeyEvent(_ keyEvent: KeyEvent, simulateKeyPress: SimulateKeyPress) -> Bool {
        guard keyEvent.event == .down else {
            return true
        }

        if keyEvent.key.keycode == kVK_Escape && keyEvent.event == .down {
            mainEditor.switchToCommandMode()
            return true
        }

        if multiplierReader.feed(character: keyEvent.key.char) {
            return true
        }

        if motionReader.feed(character: keyEvent.key.char) {
            if let motion = motionReader.motion {
                let motion = Commands.Move(motion: motion.multiplied(multiplierReader.multiplier ?? 1))
                motion.perform(mainEditor.editor)
                mainEditor.switchToCommandMode()
            }
            return true
        }

        if selectionCommandReader.feed(character: keyEvent.key.char) {
            if let command = selectionCommandReader.command {
                mainEditor.switchToCommandParameterMode() {
                    let composite = Commands.Composite(commands: [$0, command])
                    self.mainEditor.mostRecentCommand = composite
                    composite.perform(self.mainEditor.editor)
                    self.mainEditor.switchToCommandMode()
                }
            }
            return true
        }

        if keyEvent.key.char == KeyConstants.insert {
            let insert = FreeTextCommands.Insert()
            insert.performFirstTime(mainEditor.editor)
            mainEditor.onKeyUp { [weak self] in self?.mainEditor.switchToInsertMode(freeTextCommand: insert) }
            return true
        }

        if keyEvent.key.char == KeyConstants.add {
            let add = FreeTextCommands.Add()
            add.performFirstTime(mainEditor.editor)
            mainEditor.onKeyUp { [weak self] in self?.mainEditor.switchToInsertMode(freeTextCommand: add) }
            return true
        }

        if keyEvent.key.char == KeyConstants.change {
            mainEditor.switchToCommandParameterMode() { selection in
                let change = FreeTextCommands.Change(register: self.mainEditor.register, selection: selection)
                change.performFirstTime(self.mainEditor.editor)
                self.mainEditor.onKeyUp { self.mainEditor.switchToInsertMode(freeTextCommand: change) }
            }
            return true
        }

        if keyEvent.key.char == KeyConstants.visual {
            mainEditor.onKeyUp { [weak self] in self?.mainEditor.switchToVisualMode(selection: nil) }
            return true
        }

        if keyEvent.key.char == KeyConstants.VerticalMotion.up {
            simulateKeyPress(CGKeyCode(kVK_UpArrow), [])
            mainEditor.switchToCommandMode()
            return true
        }

        if keyEvent.key.char == KeyConstants.VerticalMotion.down {
            simulateKeyPress(CGKeyCode(kVK_DownArrow), [])
            mainEditor.switchToCommandMode()
            return true
        }

        if keyEvent.key.char == KeyConstants.undo {
            simulateKeyPress(keycodeForString("z"), [.maskCommand])
            mainEditor.switchToCommandMode()
            return true
        }

        if keyEvent.key.char == KeyConstants.again {
            mainEditor.mostRecentCommand?.perform(mainEditor.editor)
            mainEditor.switchToCommandMode()
            return true
        }

        mainEditor.switchToCommandMode()
        return true
    }
}
