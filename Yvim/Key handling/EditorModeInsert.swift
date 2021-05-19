import Carbon.HIToolbox
import Foundation

class EditorModeInsert: EditorMode {
    let mode: Mode = .insert

    unowned var context: YvimKeyHandler

    let currentFreeTextCommand: FreeTextCommand

    /// Text is recorded to create a repeatable command
    var recordedText: String = ""

    init(context: YvimKeyHandler, freeTextCommand: FreeTextCommand) {
        self.context = context
        self.currentFreeTextCommand = freeTextCommand
    }
    
    func handleKeyEvent(_ keyEvent: KeyEvent, simulateKeyPress: SimulateKeyPress) -> Bool {
        guard keyEvent.event == .down else {
            return false
        }

        if keyEvent.key.keycode == kVK_Escape {
            context.mostRecentCommand = currentFreeTextCommand.repeatableCommand(string: recordedText)
            context.switchToCommandMode()
            return true
        }

        recordedText.append(String(keyEvent.key.char))

        return false
    }
}
