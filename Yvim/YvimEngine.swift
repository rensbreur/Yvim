//
//  YvimEngine.swift
//  Yvim
//
//  Created by Rens Breur on 31.12.20.
//  Copyright © 2020 Rens Breur. All rights reserved.
//

import Carbon.HIToolbox

class YvimEngine: EventHandler {
    var active: Bool = true // is Xcode active

    var bufferEditor: BufferEditor!

    @Published
    private(set) var mode: Mode = .command

    init() {}

    // Delete/yank/paste register
    private var register: String = ""

    // Parser state
    private var function: String? = nil
    private var multiplier: Int?

    func handleEvent(_ event: CGEvent, simulateEvent se: (CGEvent) -> Void) -> Bool {
        guard self.active else {
            return false
        }

        let keycode = event.keyboardEventKeycode
        let keyDown = event.keyDown
        let char = stringForKeycode(keycode)

        let currentMultiplierValue = self.multiplier ?? 1
        func withMultiplier(_ block: () -> Void) {
            print("Multiplying: \(currentMultiplierValue)")
            for _ in 0..<currentMultiplierValue {
                block()
            }
        }

        func simulateEvent(_ keyCode: CGKeyCode, modifierKeys: CGEventFlags = []) -> Void {
            se(.keyboardEvent(keyCode: keyCode, keyDown: true, modifierKeys: modifierKeys))
            se(.keyboardEvent(keyCode: keyCode, keyDown: false, modifierKeys: modifierKeys))
        }

        let editor: BufferEditorOperation = BufferEditorOperation(editor: bufferEditor)
        defer { editor.commit() }

        switch mode {
        case .command:

            // [Multi-char] Lookahead
            if self.function == "f", event.unicodeString.count > 0 {
                if keyDown {
                    let char = event.unicodeString
                    editor.seekForward(char: char.utf16.first!)
                }
                else {
                    self.function = nil
                }
                return true
            }

            // Set multiplier
            if let digit = Int(event.unicodeString), !(self.multiplier == nil && digit == 0) {
                if keyDown {
                    self.multiplier = (self.multiplier ?? 0) * 10 + digit
                }
                return true
            }

            self.multiplier = nil

            // Multi-char
            if char == "f" && !keyDown {
                self.function = "f"
            }

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

            // Cursor navigation
            if (char == "h" || keycode == CGKeyCodeConstants.left) && keyDown {
                withMultiplier { editor.moveBackward() }
            }
            if (char == "l" || keycode == CGKeyCodeConstants.right) && keyDown {
                withMultiplier { editor.moveForward() }
            }
            if (char == "k" || keycode == CGKeyCodeConstants.up) && keyDown {
                withMultiplier { simulateEvent(CGKeyCodeConstants.up) }
            }
            if (char == "j" || keycode == CGKeyCodeConstants.down) && keyDown {
                withMultiplier { simulateEvent(CGKeyCodeConstants.down) }
            }

            // Word navigation
            if (char == "w" || char == "e") && keyDown {
                withMultiplier { simulateEvent(CGKeyCodeConstants.right, modifierKeys: [.maskControl]) }
            }
            if char == "b" && keyDown {
                withMultiplier { simulateEvent(CGKeyCodeConstants.left, modifierKeys: [.maskControl]) }
            }

            // Line navigation
            if char == "0" && keyDown {
                editor.moveToBeginningOfLine()
            }
            if event.unicodeString == "$" && keyDown {
                editor.moveToEndOfLine()
            }
            if event.unicodeString == "^" && keyDown {
                editor.moveToFirstCharacterInLine()
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
                editor.selectedText = register as NSString
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

            // Cursor navigation
            if (char == "h" || keycode == CGKeyCodeConstants.left) && keyDown {
                withMultiplier { simulateEvent(CGKeyCodeConstants.left, modifierKeys: [.maskShift]) }
            }
            if (char == "l" || keycode == CGKeyCodeConstants.right) && keyDown {
                withMultiplier { simulateEvent(CGKeyCodeConstants.right, modifierKeys: [.maskShift]) }
            }
            if (char == "k" || keycode == CGKeyCodeConstants.up) && keyDown {
                withMultiplier { simulateEvent(CGKeyCodeConstants.up, modifierKeys: [.maskShift]) }
            }
            if (char == "j" || keycode == CGKeyCodeConstants.down) && keyDown {
                withMultiplier { simulateEvent(CGKeyCodeConstants.down, modifierKeys: [.maskShift]) }
            }

            // Word navigation
            if (char == "w" || char == "e") && keyDown {
                withMultiplier { simulateEvent(CGKeyCodeConstants.right, modifierKeys: [.maskControl, .maskShift]) }
            }
            if char == "b" && keyDown {
                withMultiplier { simulateEvent(CGKeyCodeConstants.left, modifierKeys: [.maskControl, .maskShift]) }
            }

            // Line navigation
            if char == "0" && keyDown {
                simulateEvent(keycodeForString("a"), modifierKeys: [.maskControl, .maskShift])
            }
            if event.unicodeString == "$" && keyDown {
                simulateEvent(keycodeForString("e"), modifierKeys: [.maskControl, .maskShift])
            }

            // Deletion
            if char == "d" && keyDown {
                self.register = editor.selectedText as String
                editor.selectedText = ""
                mode = .command
            }

            // Yank
            if char == "y" && keyDown {
                self.register = editor.selectedText as String
                mode = .command
            }

            return true
        }
    }

}
