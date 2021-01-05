//
//  YvimKeyHandler.swift
//  Yvim
//
//  Created by Rens Breur on 31.12.20.
//  Copyright © 2020 Rens Breur. All rights reserved.
//

import Carbon.HIToolbox

class YvimKeyHandler: KeyHandler {
    let editor: VimEditor

    @Published private(set) var mode: Mode = .command
    var active: Bool = true

    private let movementHandler: ParserKeyHandler<(Int, VimMovement)> = .movementWithMultiplierHandler

    init(editor: VimEditor) {
        self.editor = editor
    }

    func handleKeyEvent(_ keyEvent: KeyEvent, simulateKeyPress: SimulateKeyPress) -> Bool {
        if !self.active {
            return false
        }

        if keyEvent.modifierKeys.contains(.maskCommand) {
            return false
        }

        switch mode {
        case .command:
            return handleCommandModeKey(keyEvent, simulateKeyPress: simulateKeyPress)

        case .transparent:
            if keyEvent.keycode == kVK_Escape && keyEvent.event == .down {
                mode = .command
                return true
            }
            return false

        case .visual:
            return handleVisualModeKey(keyEvent, simulateKeyPress: simulateKeyPress)
        }
    }

    private func handleCommandModeKey(_ keyEvent: KeyEvent, simulateKeyPress: SimulateKeyPress) -> Bool {
        // Move
        let r = self.movementHandler.feed(keyEvent) { (arg0) in
            let (multiplier, movement) = arg0
            editor.move(movement, multiplier: multiplier, simulateKeyPress: simulateKeyPress)
        }
        if r { return true }

        switch (keyEvent.char, keyEvent.event) {

        // Insert
        case ("i", .up):
            mode = .transparent

        // Add
        case ("a", .down):
            simulateKeyPress(CGKeyCode(kVK_RightArrow), [])
        case ("a", .up):
            mode = .transparent

        // New line
        case ("o", .down):
            simulateKeyPress(keycodeForString("e"), [.maskControl])
            simulateKeyPress(CGKeyCode(kVK_ANSI_KeypadEnter), [])
        case ("o", .up):
            self.mode = .transparent

        // Enter visual mode
        case ("v", .up):
            self.mode = .visual

        // Paste
        case ("p", .down):
            editor.paste()

        default:
            break
        }

        return true
    }

    private func handleVisualModeKey(_ keyEvent: KeyEvent, simulateKeyPress: SimulateKeyPress) -> Bool {
        // Enter command mode
        if keyEvent.keycode == kVK_Escape && keyEvent.event == .up {
            mode = .command
            return true
        }

        // Change selection
        let r = self.movementHandler.feed(keyEvent) { (arg0) in
            let (multiplier, movement) = arg0
            editor.changeSelection(movement, multiplier: multiplier, simulateKeyPress: simulateKeyPress)
        }
        if r { return true }

        // Deletion
        if keyEvent.char == "d" && keyEvent.event == .down {
            editor.delete()
            mode = .command
        }

        // Yank
        if keyEvent.char == "y" && keyEvent.event == .down {
            editor.yank()
            mode = .command
        }

        return true
    }

}
