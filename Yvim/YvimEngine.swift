//
//  YvimEngine.swift
//  Yvim
//
//  Created by Rens Breur on 31.12.20.
//  Copyright © 2020 Rens Breur. All rights reserved.
//

import Carbon.HIToolbox

class YvimEngine: EventHandler {
    let editor: VimEditor

    var active: Bool = true

    @Published private(set) var mode: Mode = .command

    init(editor: VimEditor) {
        self.editor = editor
    }

    // Parser state
    private var movementHandler: ParserKeyHandler<(Int, VimMovement)> = .movementWithMultiplierHandler

    func handleEvent(_ event: CGEvent, simulateEvent se: (CGEvent) -> Void) -> Bool {
        guard self.active else {
            return false
        }

        let keycode = event.keyboardEventKeycode
        let keyDown = event.keyDown
        let char = stringForKeycode(keycode)

        func simulateEvent(_ keyCode: CGKeyCode, modifierKeys: CGEventFlags = []) -> Void {
            se(.keyboardEvent(keyCode: keyCode, keyDown: true, modifierKeys: modifierKeys))
            se(.keyboardEvent(keyCode: keyCode, keyDown: false, modifierKeys: modifierKeys))
        }

        switch mode {
        case .command:
            let r = self.movementHandler.feed(KeyEvent(event: keyDown ? .down : .up, keycode: keycode, char: event.unicodeString.first!)) { (arg0) in
                let (multiplier, movement) = arg0

                editor.move(movement, multiplier: multiplier, simulateKeyPress: simulateEvent(_:modifierKeys:))
            }

            if r { return true }

            // Insert
            if char == "i" && !keyDown {
                mode = .transparent
            }

            // Add
            if char == "a" && keyDown {
                simulateEvent(CGKeyCode(kVK_RightArrow))
            }
            if char == "a" && !keyDown {
                mode = .transparent
            }

            // New line
            if char == "o" && keyDown {
                simulateEvent(keycodeForString("e"), modifierKeys: [.maskControl])
                simulateEvent(CGKeyCode(kVK_ANSI_KeypadEnter))
            }
            if char == "o" && !keyDown {
                self.mode = .transparent
            }

            // Enter visual mode
            if char == "v" && !keyDown {
                self.mode = .visual
            }

            // Paste
            if char == "p" && keyDown {
                editor.paste()
            }

            return true
        case .transparent:

            // Enter command mode
            if keycode == kVK_Escape && keyDown {
                mode = .command
                return true
            }

            return false
        case .visual:

            // Enter command mode
            if keycode == kVK_Escape && !keyDown {
                mode = .command
                return true
            }

            let r = self.movementHandler.feed(KeyEvent(event: keyDown ? .down : .up, keycode: keycode, char: event.unicodeString.first!)) { (arg0) in
                let (multiplier, movement) = arg0
                editor.changeSelection(movement, multiplier: multiplier, simulateKeyPress: simulateEvent)
            }

            if r { return true }

            // Deletion
            if char == "d" && keyDown {
                editor.delete()
                mode = .command
            }

            // Yank
            if char == "y" && keyDown {
                editor.yank()
                mode = .command
            }

            return true
        }
    }

}
