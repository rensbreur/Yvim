//
//  ProgramAccessibilityService.swift
//  Yvim
//
//  Created by Rens Breur on 01.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

extension AXUIElement {
    var focusedUIElement: AXUIElement {
        var attrVal: AnyObject!
        AXUIElementCopyAttributeValue(self, kAXFocusedUIElementAttribute as CFString, &attrVal)
        return attrVal as! AXUIElement
    }
    
    var value: String {
        var attrVal: AnyObject?
        AXUIElementCopyAttributeValue(self, kAXValueAttribute as CFString, &attrVal)
        return (attrVal as! CFString) as String
    }
    
    var selectedText: String {
        var attrVal: AnyObject?
        AXUIElementCopyAttributeValue(self, kAXSelectedTextAttribute as CFString, &attrVal)
        return (attrVal as! CFString) as String
    }
    
    func setSelectedText(_ text: String) {
        AXUIElementSetAttributeValue(self, kAXSelectedTextAttribute as CFString, text as CFString)
    }
    
    var selection: CFRange {
        var attrVal: AnyObject?
        AXUIElementCopyAttributeValue(self, kAXSelectedTextRangeAttribute as CFString, &attrVal)
        var range: CFRange = CFRangeMake(0,0)
        print(AXValueGetType((attrVal as! AXValue)).rawValue == kAXValueCFRangeType)
        AXValueGetValue((attrVal as! AXValue), AXValueType(rawValue: kAXValueCFRangeType)!, &range)
        return range
    }
    
    func setSelection(_ range: CFRange) {
        var range = range
        var attrVal = AXValueCreate(AXValueType(rawValue: kAXValueCFRangeType)!, &range)
        AXUIElementSetAttributeValue(self, kAXSelectedTextRangeAttribute as CFString, attrVal!)
    }
    
    /// Using NSString's reference semantics to increase performance
    var text: NSString {
        var attrVal: AnyObject?
        AXUIElementCopyAttributeValue(self, kAXValueAttribute as CFString, &attrVal)
        return (attrVal as! CFString)
    }
}

class ProgramAccessibilityService {
    let pid: pid_t
    let element: AXUIElement

    init(pid: pid_t) {
        self.pid = pid
        element = AXUIElementCreateApplication(pid)
    }

    @Published var active: Bool = true

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
