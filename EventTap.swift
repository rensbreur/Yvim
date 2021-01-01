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
    func handleEvent(keycode: Int64, keyDown: Bool, simulateEvent: (Int, Bool) -> Void) -> Bool
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
    let kc: EventTap = Unmanaged<EventTap>.fromOpaque(refcon!).takeUnretainedValue()

    let keycode = event.getIntegerValueField(.keyboardEventKeycode)
    let keyDown = type == CGEventType.keyDown

    if let delegate = kc.eventHandler, delegate.handleEvent(keycode: keycode, keyDown: keyDown, simulateEvent: { (keycode, ctrl) in
        kc.keyboardEvent(keyCode: keycode, keyDown: true, ctrl: ctrl).tapPostEvent(proxy)
        kc.keyboardEvent(keyCode: keycode, keyDown: false, ctrl: ctrl).tapPostEvent(proxy)
    }) {
        return nil
    }

    return Unmanaged.passUnretained(event)
}
