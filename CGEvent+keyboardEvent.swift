//
//  CGEvent+keyboardEvent.swift
//  Yvim
//
//  Created by Rens Breur on 01.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

extension CGEvent {
    var keyboardEventKeycode: CGKeyCode {
        CGKeyCode(getIntegerValueField(.keyboardEventKeycode))
    }

    var keyDown: Bool {
        type == CGEventType.keyDown
    }

    var unicodeString: String {
        var length: Int = 0
        var str: [UniChar] = [0,0,0,0]
        keyboardGetUnicodeString(maxStringLength: 1, actualStringLength: &length, unicodeString: &str)
        return CFStringCreateWithCharacters(kCFAllocatorDefault, str, 1) as String
    }

    static func keyboardEvent(keyCode: CGKeyCode, keyDown: Bool, ctrl: Bool = false) -> CGEvent {
        let event = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: keyDown)!
        event.flags = (ctrl ? CGEventFlags.maskControl : [])
        return event
    }
}
