//
//  EventTap.swift
//  Yvim
//
//  Created by Rens Breur on 30.12.20.
//  Copyright © 2020 Rens Breur. All rights reserved.
//

import ApplicationServices.HIServices

protocol EventHandler {
    func handleEvent(_ event: CGEvent, simulateEvent: (CGEvent) -> Void) -> Bool
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
}

private func Handle_EventCallback(proxy: OpaquePointer, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer!) -> Unmanaged<CGEvent>?
{
    let eventTap: EventTap = Unmanaged<EventTap>.fromOpaque(refcon!).takeUnretainedValue()

    if let delegate = eventTap.eventHandler, delegate.handleEvent(event, simulateEvent: { (event) in
        event.tapPostEvent(proxy)
    }) {
        return nil
    }

    return Unmanaged.passUnretained(event)
}
