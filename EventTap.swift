//
//  EventTap.swift
//  Yvim
//
//  Created by Rens Breur on 30.12.20.
//  Copyright © 2020 Rens Breur. All rights reserved.
//

import Cocoa
import ApplicationServices

protocol EventHandler {
    func handleEvent(_ event: CGEvent, simulateEvent: (Int, Bool) -> Void) -> Bool
}

class EventTap {
    var eventHandler: EventHandler?

    func startListening() {
        let eventMask = (1 << CGEventType.keyDown.rawValue) | CGEventMask(1 << CGEventType.keyUp.rawValue)
        let r = CGEvent.tapCreate(tap: .cghidEventTap, place: .headInsertEventTap, options: .defaultTap, eventsOfInterest: eventMask, callback: Handle_EventCallback, userInfo: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
        guard let eventTap = r else {
            fatalError("Could not tap keyboard events")
        }
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, CFRunLoopMode.commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
    }

    func keyboardEvent(keyCode: Int, keyDown: Bool, ctrl: Bool = false) -> CGEvent {
        let event = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(keyCode), keyDown: keyDown)!
        event.flags = (ctrl ? CGEventFlags.maskControl : [])
        return event
    }
}

private func Handle_EventCallback(proxy: OpaquePointer, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer!) -> Unmanaged<CGEvent>?
{
    let eventTap: EventTap = Unmanaged<EventTap>.fromOpaque(refcon!).takeUnretainedValue()

    if let delegate = eventTap.eventHandler, delegate.handleEvent(event, simulateEvent: { (keycode, ctrl) in
        eventTap.keyboardEvent(keyCode: keycode, keyDown: true, ctrl: ctrl).tapPostEvent(proxy)
        eventTap.keyboardEvent(keyCode: keycode, keyDown: false, ctrl: ctrl).tapPostEvent(proxy)
    }) {
        return nil
    }

    return Unmanaged.passUnretained(event)
}

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
}
