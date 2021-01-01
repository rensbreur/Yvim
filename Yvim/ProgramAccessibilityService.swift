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

    private var observer: AXObserver?
    private var observerAway: AXObserver?

    func start() {
        addApplicationActivatedObserver()
        addApplicationDeactivatedObserver()
    }

    func addApplicationActivatedObserver() {
        var observer: AXObserver!
        guard AXObserverCreate(pid, Handle_AppswitchCallback, &observer) == AXError.success else {
            print("Failed to create observer for application.")
            return
        }

        CFRunLoopAddSource(CFRunLoopGetCurrent(),
                           AXObserverGetRunLoopSource(observer),
                           CFRunLoopMode.defaultMode);

        guard AXObserverAddNotification(observer, element, kAXApplicationActivatedNotification as CFString, Unmanaged<ProgramAccessibilityService>.passUnretained(self).toOpaque()) == AXError.success else {
            print("Failed to create notification for application.")
            return
        }

        self.observer = observer
    }

    func addApplicationDeactivatedObserver() {
        var observerAway: AXObserver!
        guard AXObserverCreate(pid, Handle_AppswitchAwayCallback, &observerAway) == AXError.success else {
            print("Failed to create observer for application.")
            return
        }

        CFRunLoopAddSource(CFRunLoopGetCurrent(),
                           AXObserverGetRunLoopSource(observerAway),
                           CFRunLoopMode.defaultMode);

        guard AXObserverAddNotification(observerAway, element, kAXApplicationDeactivatedNotification as CFString, Unmanaged<ProgramAccessibilityService>.passUnretained(self).toOpaque()) == AXError.success else {
            print("Failed to create notification for application.")
            return
        }

        self.observerAway = observerAway
    }

    func stop() {
        guard pid == self.pid, let observer = self.observer, let observerAway = self.observerAway else {
            return
        }

        CFRunLoopRemoveSource(CFRunLoopGetCurrent(),
                              AXObserverGetRunLoopSource(observer),
                              CFRunLoopMode.defaultMode)
        CFRunLoopRemoveSource(CFRunLoopGetCurrent(),
                              AXObserverGetRunLoopSource(observerAway),
                              .defaultMode)
    }

    func applicationSwitched() {
        self.active = true
    }

    func applicationSwitchedAway() {
        self.active = false
    }

}

private func Handle_AppswitchCallback(observer: AXObserver, element: AXUIElement, string: CFString, context: UnsafeMutableRawPointer!) {
    Unmanaged<ProgramAccessibilityService>.fromOpaque(context).takeUnretainedValue().applicationSwitched()
}

private func Handle_AppswitchAwayCallback(observer: AXObserver, element: AXUIElement, string: CFString, context: UnsafeMutableRawPointer!) {
    Unmanaged<ProgramAccessibilityService>.fromOpaque(context).takeUnretainedValue().applicationSwitchedAway()
}
