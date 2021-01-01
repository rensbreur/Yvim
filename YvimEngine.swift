//
//  YvimEngine.swift
//  Yvim
//
//  Created by Rens Breur on 31.12.20.
//  Copyright © 2020 Rens Breur. All rights reserved.
//

import Foundation
import Carbon.HIToolbox
import Carbon

class YvimEngine: EventHandler {
    @Published var mode: Mode = .command

    init() {}

    func handleEvent(_ event: CGEvent, simulateEvent se: (CGEvent) -> Void) -> Bool {
        let keycode = event.keyboardEventKeycode
        let keyDown = event.keyDown
        let char = stringForKeycode(keycode)

        func simulateEvent(_ keyCode: CGKeyCode, _ ctrl: Bool) -> Void {
            se(.keyboardEvent(keyCode: keyCode, keyDown: true, ctrl: ctrl))
            se(.keyboardEvent(keyCode: keyCode, keyDown: false, ctrl: ctrl))
        }
        
        switch mode {
        case .command:

            // INSERT
            if char == "i" && !keyDown {
                mode = .transparent
            }

            // ADD
            if char == "a" && keyDown {
                simulateEvent(CGKeyCode(kVK_RightArrow), false)
            }
            if char == "a" && !keyDown {
                mode = .transparent
            }

            // CURSOR NAVIGATION
            if char == "h" && keyDown {
                simulateEvent(CGKeyCode(kVK_LeftArrow), false)
            }
            if char == "l" && keyDown {
                simulateEvent(CGKeyCode(kVK_RightArrow), false)
            }
            if char == "k" && keyDown {
                simulateEvent(CGKeyCode(kVK_UpArrow), false)
            }
            if char == "j" && keyDown {
                simulateEvent(CGKeyCode(kVK_DownArrow), false)
            }
            if keycode == kVK_LeftArrow || keycode == kVK_RightArrow
                    || keycode == kVK_UpArrow || keycode == kVK_DownArrow {
                return false
            }

            // WORD NAVIGATION
            if (char == "w" || char == "e") && keyDown {
                simulateEvent(CGKeyCode(kVK_RightArrow), true)
            }
            if char == "b" && keyDown {
                simulateEvent(CGKeyCode(kVK_LeftArrow), true)
            }

            // LINE NAVIGATION
            if char == "0" && keyDown {
                simulateEvent(keycodeForString("a"), true)
            }
            if event.unicodeString == "$" && keyDown {
                simulateEvent(keycodeForString("e"), true)
            }

            // NEW LINE
            if char == "o" && keyDown {
                simulateEvent(keycodeForString("e"), true)
                simulateEvent(CGKeyCode(kVK_ANSI_KeypadEnter), false)
            }
            if char == "o" && !keyDown {
                self.mode = .transparent
            }

            return true
        case .transparent:
            if keycode == kVK_Escape && keyDown {
            mode = .command
            return true
            }
            return false
        case .visual:
            return false
        }
    }

}
