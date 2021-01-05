//
//  KeyHandler.swift
//  Yvim
//
//  Created by Admin on 05.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

protocol KeyHandler {
    func handleKeyEvent(_ keyEvent: KeyEvent, simulateKeyPress: (CGKeyCode, CGEventFlags) -> Void) -> Bool
}

class KeyEventHandler: EventHandler {
    func handleEvent(_ event: CGEvent, simulateEvent: (CGEvent) -> Void) -> Bool {
        let keycode = event.keyboardEventKeycode
        let keyDown = event.keyDown
        let event = KeyEvent(event: keyDown ? .down : .up, keycode: keycode, char: event.unicodeString.first!)

        func simulateKeyPress(_ keyCode: CGKeyCode, modifierKeys: CGEventFlags = []) -> Void {
            simulateEvent(.keyboardEvent(keyCode: keyCode, keyDown: true, modifierKeys: modifierKeys))
            simulateEvent(.keyboardEvent(keyCode: keyCode, keyDown: false, modifierKeys: modifierKeys))
        }

        return self.keyHandler.handleKeyEvent(event, simulateKeyPress: simulateKeyPress)
    }

    let keyHandler: KeyHandler

    init(keyHandler: KeyHandler) {
        self.keyHandler = keyHandler
    }


}
