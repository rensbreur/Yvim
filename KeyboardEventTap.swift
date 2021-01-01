//
//  KeyboardEventTap.swift
//  Yvim
//
//  Created by Rens Breur on 30.12.20.
//  Copyright © 2020 Rens Breur. All rights reserved.
//

import Cocoa
import ApplicationServices

protocol KeyboardEventHandler {
    func handleKeyboardEvent(keycode: Int64, keyDown: Bool) -> Bool
}

protocol KeyboardEventSimulator {
    func sendKey(keyCode: Int, ctrl: Bool)
}

extension KeyboardEventSimulator {
    func sendKey(keyCode: Int) {
        self.sendKey(keyCode: keyCode, ctrl: false)
    }
}

class KeyboardEventTap: KeyboardEventSimulator {
    var keyboardEventHandler: KeyboardEventHandler?

    // used to prevent forwarding keys from the `sendKey` function to the handler
    fileprivate var sentKeys: [Int] = []

    func startListening() {
        let eventMask = (1 << CGEventType.keyDown.rawValue) | CGEventMask(1 << CGEventType.keyUp.rawValue)
        let r = CGEvent.tapCreate(tap: .cgSessionEventTap, place: .headInsertEventTap, options: .defaultTap, eventsOfInterest: eventMask, callback: Handle_EventCallback, userInfo: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
        guard let eventTap = r else {
            fatalError("Could not tap keyboard events")
        }
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, CFRunLoopMode.commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
    }

    func sendKey(keyCode: Int, ctrl: Bool) {
        sentKeys.append(keyCode)
        keyboardEvent(keyCode: keyCode, keyDown: true, ctrl: ctrl).post(tap: .cghidEventTap)
        keyboardEvent(keyCode: keyCode, keyDown: false, ctrl: ctrl).post(tap: .cghidEventTap)
    }

    func keyboardEvent(keyCode: Int, keyDown: Bool, ctrl: Bool = false) -> CGEvent {
        let event = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(keyCode), keyDown: keyDown)!
        event.flags = (ctrl ? CGEventFlags.maskControl : [])
        return event
    }
}

private func Handle_EventCallback(proxy: OpaquePointer, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer!) -> Unmanaged<CGEvent>?
{
    let kc: KeyboardEventTap = Unmanaged<KeyboardEventTap>.fromOpaque(refcon!).takeUnretainedValue()

    let keycode = event.getIntegerValueField(.keyboardEventKeycode)
    let keyDown = type == CGEventType.keyDown

    if let fst = kc.sentKeys.first, fst == keycode {
        if !keyDown {
            kc.sentKeys.removeFirst()
        }
        return Unmanaged.passUnretained(event) // retain only newly created events, see docs
    }

    if let delegate = kc.keyboardEventHandler, delegate.handleKeyboardEvent(keycode: keycode, keyDown: keyDown) {
        return nil
    }

    return Unmanaged.passUnretained(event)
}
