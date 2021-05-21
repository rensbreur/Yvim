import Carbon.HIToolbox
import Foundation

class EditorModeInsert: EditorMode {
    let mode: Mode = .insert

    weak var modeSwitcher: EditorModeSwitcher?
    let operationMemory: OperationMemory

    let currentFreeTextCommand: FreeTextOperation

    /// Text is recorded to create a repeatable command
    var recordedText: String = ""

    init(modeSwitcher: EditorModeSwitcher, freeTextCommand: FreeTextOperation, operationMemory: OperationMemory) {
        self.modeSwitcher = modeSwitcher
        self.currentFreeTextCommand = freeTextCommand
        self.operationMemory = operationMemory
    }
    
    func handleKeyEvent(_ keyEvent: KeyEvent, simulateKeyPress: SimulateKeyPress) -> Bool {
        guard keyEvent.event == .down else {
            return false
        }

        if keyEvent.key.keycode == kVK_Escape {
            operationMemory.mostRecentCommand = currentFreeTextCommand.createOperation(string: recordedText)
            modeSwitcher?.switchToCommandMode()
            return true
        }

        recordedText.append(String(keyEvent.key.char))

        return false
    }
}
