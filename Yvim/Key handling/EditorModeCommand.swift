import Carbon.HIToolbox
import Foundation

class EditorModeCommand: EditorMode {
    let mode: Mode = .command

    unowned var mainEditor: EditorModeSwitcher
    let register: Register
    let editor: BufferEditor
    let commandMemory: CommandMemory

    let multiplierReader = MultiplierReader()
    let motionReader = MotionReader()
    lazy var selectionCommandReader = SelectionCommandReader(commandFactory: CommandFactory(register: register))

    init(mainEditor: EditorModeSwitcher, register: Register, editor: BufferEditor, commandMemory: CommandMemory) {
        self.mainEditor = mainEditor
        self.register = register
        self.editor = editor
        self.commandMemory = commandMemory
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
                motion.perform(editor)
                mainEditor.switchToCommandMode()
            }
            return true
        }

        if selectionCommandReader.feed(character: keyEvent.key.char) {
            if let command = selectionCommandReader.command {
                mainEditor.switchToCommandParameterMode() {
                    let composite = Commands.Composite(commands: [$0, command])
                    self.commandMemory.mostRecentCommand = composite
                    composite.perform(self.editor)
                    self.mainEditor.switchToCommandMode()
                }
            }
            return true
        }

        if keyEvent.key.char == KeyConstants.insert {
            let insert = FreeTextCommands.Insert()
            insert.performFirstTime(editor)
            mainEditor.onKeyUp { [weak self] in self?.mainEditor.switchToInsertMode(freeTextCommand: insert) }
            return true
        }

        if keyEvent.key.char == KeyConstants.add {
            let add = FreeTextCommands.Add()
            add.performFirstTime(editor)
            mainEditor.onKeyUp { [weak self] in self?.mainEditor.switchToInsertMode(freeTextCommand: add) }
            return true
        }

        if keyEvent.key.char == KeyConstants.change {
            mainEditor.switchToCommandParameterMode() { selection in
                let change = FreeTextCommands.Change(register: self.register, selection: selection)
                change.performFirstTime(self.editor)
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
            commandMemory.mostRecentCommand?.perform(editor)
            mainEditor.switchToCommandMode()
            return true
        }

        mainEditor.switchToCommandMode()
        return true
    }
}
