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

    var active: Bool = true

    @Published private(set) var mode: Mode = .command

    init(editor: VimEditor) {
        self.editor = editor
    }

    // Parser state
    private var movementHandler: ParserKeyHandler<(Int, VimMovement)> = .movementWithMultiplierHandler

    func handleKeyEvent(_ keyEvent: KeyEvent, simulateKeyPress: (CGKeyCode, CGEventFlags) -> Void) -> Bool {
        guard self.active else {
            return false
        }

        switch mode {
        case .command:
            let r = self.movementHandler.feed(keyEvent) { (arg0) in
                let (multiplier, movement) = arg0
                editor.move(movement, multiplier: multiplier, simulateKeyPress: simulateKeyPress)
            }
            if r { return true }

            // Insert
            if keyEvent.char == "i" && keyEvent.event == .up {
                mode = .transparent
            }

            // Add
            if keyEvent.char == "a" && keyEvent.event == .down {
                simulateKeyPress(CGKeyCode(kVK_RightArrow), [])
            }
            if keyEvent.char == "a" && keyEvent.event == .up {
                mode = .transparent
            }

            // New line
            if keyEvent.char == "o" && keyEvent.event == .down {
                simulateKeyPress(keycodeForString("e"), [.maskControl])
                simulateKeyPress(CGKeyCode(kVK_ANSI_KeypadEnter), [])
            }
            if keyEvent.char == "o" && keyEvent.event == .up {
                self.mode = .transparent
            }

            // Enter visual mode
            if keyEvent.char == "v" && keyEvent.event == .up {
                self.mode = .visual
            }

            // Paste
            if keyEvent.char == "p" && keyEvent.event == .down {
                editor.paste()
            }

            return true
        case .transparent:

            // Enter command mode
            if keyEvent.keycode == kVK_Escape && keyEvent.event == .down {
                mode = .command
                return true
            }

            return false
        case .visual:

            // Enter command mode
            if keyEvent.keycode == kVK_Escape && keyEvent.event == .up {
                mode = .command
                return true
            }

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

}
