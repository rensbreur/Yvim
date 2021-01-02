//
//  ProgramAccessibilityService.swift
//  Yvim
//
//  Created by Rens Breur on 01.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

class ProgramAccessibilityService {
    let pid: pid_t
    let element: AXUIElement

    init(pid: pid_t) {
        self.pid = pid
        element = AXUIElementCreateApplication(pid)
    }

    @Published var active: Bool = true

    var sourcecodeEditorContents: String {
        var attrVal: AnyObject?
        AXUIElementCopyAttributeValue(element, kAXFocusedUIElementAttribute as CFString, &attrVal)
        let focusedElement = attrVal as! AXUIElement
        var valuePtr: AnyObject?

        AXUIElementCopyAttributeValue(focusedElement, kAXValueAttribute as CFString, &valuePtr)
        return (valuePtr as! CFString) as String
    }

    private var observer: AXObserver!

    func start() {
        guard AXObserverCreate(pid, Handle_AppswitchCallback, &observer) == AXError.success else {
            print("Failed to create observer for application.")
            return
        }

        CFRunLoopAddSource(CFRunLoopGetCurrent(),
                           AXObserverGetRunLoopSource(observer),
                           CFRunLoopMode.defaultMode)
        
        addApplicationActiveNotifications()
    }

    func addApplicationActiveNotifications() {
        guard AXObserverAddNotification(observer, element, kAXApplicationActivatedNotification as CFString, Unmanaged<ProgramAccessibilityService>.passUnretained(self).toOpaque()) == AXError.success else {
            print("Failed to create notification for application.")
            return
        }
        guard AXObserverAddNotification(observer, element, kAXApplicationDeactivatedNotification as CFString, Unmanaged<ProgramAccessibilityService>.passUnretained(self).toOpaque()) == AXError.success else {
            print("Failed to create notification for application.")
            return
        }
    }

    func stop() {
        CFRunLoopRemoveSource(CFRunLoopGetCurrent(),
                              AXObserverGetRunLoopSource(observer),
                              CFRunLoopMode.defaultMode)
    }

    func applicationSwitched() {
        self.active = true
    }

    func applicationSwitchedAway() {
        self.active = false
    }

}

private func Handle_AppswitchCallback(observer: AXObserver, element: AXUIElement, notification: CFString, context: UnsafeMutableRawPointer!) {
    let srv = Unmanaged<ProgramAccessibilityService>.fromOpaque(context).takeUnretainedValue()
    switch notification as String {
    case kAXApplicationActivatedNotification:
        srv.applicationSwitched()
    case kAXApplicationDeactivatedNotification:
        srv.applicationSwitchedAway()
    default:
        break
    }
}
