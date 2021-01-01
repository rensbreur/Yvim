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
        case .command: return "-- COMMAND --"
        case .transparent: return "-- INSERT --"
        case .visual: return "-- VISUAL --"
        }
    }
}

class YvimEngine: EventHandler {
    @Published var mode: Mode = .command

    init() {
    }

    func handleEvent(_ event: CGEvent, simulateEvent: (Int, Bool) -> Void) -> Bool {
        let keycode = event.keyboardEventKeycode
        let keyDown = event.keyDown
        let char = stringForKeycode(keycode)
        print("Key \(event.unicodeString)")
        switch mode {
        case .command:
            if (char == "a" || char == "i") && keyDown {
                mode = .transparent
            }
            if (char == "h" && keyDown) {
                simulateEvent(kVK_LeftArrow, false)
            }
            if (char == "l" && keyDown) {
                simulateEvent(kVK_RightArrow, false)
            }
            if (char == "o" && keyDown) {
                simulateEvent(Int(keycodeForString("e")!), true)
                simulateEvent(kVK_ANSI_KeypadEnter, false)
                self.mode = .transparent
            }
            if (char == "k" && keyDown) {
                simulateEvent(kVK_UpArrow, false)
            }
            if (char == "j" && keyDown) {
                simulateEvent(kVK_DownArrow, false)
            }
            return true;
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
