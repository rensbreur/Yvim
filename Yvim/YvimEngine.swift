//
//  YvimEngine.swift
//  Yvim
//
//  Created by Rens Breur on 31.12.20.
//  Copyright © 2020 Rens Breur. All rights reserved.
//

import Carbon.HIToolbox

class YvimEngine: EventHandler {
    var active: Bool = true // false when Xcode is not active

    @Published
    private(set) var mode: Mode = .command

    init() {}

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
            if char == "h" && keyDown {
                simulateEvent(CGKeyCodeConstants.left)
            }
            if char == "l" && keyDown {
                simulateEvent(CGKeyCodeConstants.right)
            }
            if char == "k" && keyDown {
                simulateEvent(CGKeyCodeConstants.up)
            }
            if char == "j" && keyDown {
                simulateEvent(CGKeyCodeConstants.down)
            }
            if keycode == kVK_LeftArrow || keycode == kVK_RightArrow
                    || keycode == kVK_UpArrow || keycode == kVK_DownArrow {
                return false
            }

            // Word navigation
            if (char == "w" || char == "e") && keyDown {
                simulateEvent(CGKeyCodeConstants.right, modifierKeys: [.maskControl])
            }
            if char == "b" && keyDown {
                simulateEvent(CGKeyCodeConstants.left, modifierKeys: [.maskControl])
            }

            // Line navigation
            if char == "0" && keyDown {
                simulateEvent(keycodeForString("a"), modifierKeys: [.maskControl])
            }
            if event.unicodeString == "$" && keyDown {
                simulateEvent(keycodeForString("e"), modifierKeys: [.maskControl])
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
                simulateEvent(CGKeyCodeConstants.left, modifierKeys: [.maskShift])
            }
            if (char == "l" || keycode == CGKeyCodeConstants.right) && keyDown {
                simulateEvent(CGKeyCodeConstants.right, modifierKeys: [.maskShift])
            }
            if (char == "k" || keycode == CGKeyCodeConstants.up) && keyDown {
                simulateEvent(CGKeyCodeConstants.up, modifierKeys: [.maskShift])
            }
            if (char == "j" || keycode == CGKeyCodeConstants.down) && keyDown {
                simulateEvent(CGKeyCodeConstants.down, modifierKeys: [.maskShift])
            }

            // Word navigation
            if (char == "w" || char == "e") && keyDown {
                simulateEvent(CGKeyCodeConstants.right, modifierKeys: [.maskControl, .maskShift])
            }
            if char == "b" && keyDown {
                simulateEvent(CGKeyCodeConstants.left, modifierKeys: [.maskControl, .maskShift])
            }

            // Line navigation
            if char == "0" && keyDown {
                simulateEvent(keycodeForString("a"), modifierKeys: [.maskControl, .maskShift])
            }
            if event.unicodeString == "$" && keyDown {
                simulateEvent(keycodeForString("e"), modifierKeys: [.maskControl, .maskShift])
            }

            return true
        }
    }

}
