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

enum Mode {
    case command
    case transparent // insert, send through all keys
    case visual

    var description: String {
        switch self {
        case .command:
            return "command"
        case .transparent:
            return "insert"
        case .visual:
            return "visual"
        }
    }
}

class YvimEngine: EventHandler {
    @Published var mode: Mode = .command

    init() {}

    func handleEvent(_ event: CGEvent, simulateEvent: (Int, Bool) -> Void) -> Bool {
        let keycode = event.keyboardEventKeycode
        let keyDown = event.keyDown
        let char = stringForKeycode(keycode)
        switch mode {
        case .command:

            // INSERT
            if char == "i" && !keyDown {
                mode = .transparent
            }

            // ADD
            if char == "a" && keyDown {
                simulateEvent(kVK_RightArrow, false)
            }
            if char == "a" && !keyDown {
                mode = .transparent
            }

            // CURSOR NAVIGATION
            if char == "h" && keyDown {
                simulateEvent(kVK_LeftArrow, false)
            }
            if char == "l" && keyDown {
                simulateEvent(kVK_RightArrow, false)
            }
            if char == "k" && keyDown {
                simulateEvent(kVK_UpArrow, false)
            }
            if char == "j" && keyDown {
                simulateEvent(kVK_DownArrow, false)
            }
            if keycode == kVK_LeftArrow || keycode == kVK_RightArrow
                    || keycode == kVK_UpArrow || keycode == kVK_DownArrow {
                return false
            }

            // WORD NAVIGATION
            if (char == "w" || char == "e") && keyDown {
                simulateEvent(kVK_RightArrow, true)
            }
            if char == "b" && keyDown {
                simulateEvent(kVK_LeftArrow, true)
            }

            // LINE NAVIGATION
            if char == "0" && keyDown {
                simulateEvent(Int(keycodeForString("a")), true)
            }

            // NEW LINE
            if char == "o" && keyDown {
                simulateEvent(Int(keycodeForString("e")!), true)
                simulateEvent(kVK_ANSI_KeypadEnter, false)
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
