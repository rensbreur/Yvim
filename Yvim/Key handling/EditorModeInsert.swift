import Carbon.HIToolbox
import Foundation

class EditorModeInsert: EditorMode {
    let mode: Mode = .insert

    unowned var context: EditorModeSwitcher
    let commandMemory: CommandMemory

    let currentFreeTextCommand: FreeTextCommand

    /// Text is recorded to create a repeatable command
    var recordedText: String = ""

    init(context: EditorModeSwitcher, freeTextCommand: FreeTextCommand, commandMemory: CommandMemory) {
        self.context = context
        self.currentFreeTextCommand = freeTextCommand
        self.commandMemory = commandMemory
    }
    
    func handleKeyEvent(_ keyEvent: KeyEvent, simulateKeyPress: SimulateKeyPress) -> Bool {
        guard keyEvent.event == .down else {
            return false
        }

        if keyEvent.key.keycode == kVK_Escape {
            commandMemory.mostRecentCommand = currentFreeTextCommand.repeatableCommand(string: recordedText)
            context.switchToCommandMode()
            return true
        }

        recordedText.append(String(keyEvent.key.char))

        return false
    }
}
