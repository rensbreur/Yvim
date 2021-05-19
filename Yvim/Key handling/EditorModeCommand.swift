import Carbon.HIToolbox
import Foundation

class EditorModeCommand: EditorMode {
    let mode: Mode = .command

    weak var modeSwitcher: EditorModeSwitcher?
    let register: Register
    let editor: BufferEditor
    let commandMemory: CommandMemory

    let multiplierReader = MultiplierReader()
    let motionReader = MotionReader()
    lazy var selectionCommandReader = SelectionCommandReader(commandFactory: CommandFactory(register: register))

    init(modeSwitcher: EditorModeSwitcher, register: Register, editor: BufferEditor, commandMemory: CommandMemory) {
        self.modeSwitcher = modeSwitcher
        self.register = register
        self.editor = editor
        self.commandMemory = commandMemory
    }

    func handleKeyEvent(_ keyEvent: KeyEvent, simulateKeyPress: SimulateKeyPress) -> Bool {
        guard keyEvent.event == .down else {
            return true
        }

        if keyEvent.key.keycode == kVK_Escape && keyEvent.event == .down {
            modeSwitcher?.switchToCommandMode()
            return true
        }

        if multiplierReader.feed(character: keyEvent.key.char) {
            return true
        }

        if motionReader.feed(character: keyEvent.key.char) {
            if let motion = motionReader.motion {
                let motion = Commands.Move(motion: motion.multiplied(multiplierReader.multiplier ?? 1))
                motion.perform(editor)
                modeSwitcher?.switchToCommandMode()
            }
            return true
        }

        if selectionCommandReader.feed(character: keyEvent.key.char) {
            if let command = selectionCommandReader.command {
                modeSwitcher?.switchToCommandParameterMode() {
                    let composite = Commands.Composite(commands: [$0, command])
                    self.commandMemory.mostRecentCommand = composite
                    composite.perform(self.editor)
                    self.modeSwitcher?.switchToCommandMode()
                }
            }
            return true
        }

        if keyEvent.key.char == KeyConstants.insert {
            let insert = FreeTextCommands.Insert()
            insert.performFirstTime(editor)
            modeSwitcher?.onKeyUp { [weak self] in self?.modeSwitcher?.switchToInsertMode(freeTextCommand: insert) }
            return true
        }

        if keyEvent.key.char == KeyConstants.add {
            let add = FreeTextCommands.Add()
            add.performFirstTime(editor)
            modeSwitcher?.onKeyUp { [weak self] in self?.modeSwitcher?.switchToInsertMode(freeTextCommand: add) }
            return true
        }

        if keyEvent.key.char == KeyConstants.change {
            modeSwitcher?.switchToCommandParameterMode() { selection in
                let change = FreeTextCommands.Change(register: self.register, selection: selection)
                change.performFirstTime(self.editor)
                self.modeSwitcher?.onKeyUp { self.modeSwitcher?.switchToInsertMode(freeTextCommand: change) }
            }
            return true
        }

        if keyEvent.key.char == KeyConstants.visual {
            modeSwitcher?.onKeyUp { [weak self] in self?.modeSwitcher?.switchToVisualMode(selection: nil) }
            return true
        }

        if keyEvent.key.char == KeyConstants.VerticalMotion.up {
            simulateKeyPress(CGKeyCode(kVK_UpArrow), [])
            modeSwitcher?.switchToCommandMode()
            return true
        }

        if keyEvent.key.char == KeyConstants.VerticalMotion.down {
            simulateKeyPress(CGKeyCode(kVK_DownArrow), [])
            modeSwitcher?.switchToCommandMode()
            return true
        }

        if keyEvent.key.char == KeyConstants.undo {
            simulateKeyPress(keycodeForString("z"), [.maskCommand])
            modeSwitcher?.switchToCommandMode()
            return true
        }

        if keyEvent.key.char == KeyConstants.again {
            commandMemory.mostRecentCommand?.perform(editor)
            modeSwitcher?.switchToCommandMode()
            return true
        }

        modeSwitcher?.switchToCommandMode()
        return true
    }
}
