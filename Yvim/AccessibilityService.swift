//
//  AccessibilityService.swift
//  Yvim
//
//  Created by Rens Breur on 01.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Cocoa

class AccessibilityService {
    let managedApplicationId = "com.apple.dt.Xcode"

    var pid: pid_t?

    var observer: AXObserver?
    var observerAway: AXObserver?

    @Published var active: Bool = false

    init() {}

    func start() {
        let workspace = NSWorkspace.shared

        workspace.notificationCenter.addObserver(self,
                                                 selector: #selector(applicationLaunched(_:)),
                                                 name: NSWorkspace.didLaunchApplicationNotification,
                                                 object: workspace)
        workspace.notificationCenter.addObserver(self,
                                                 selector: #selector(applicationTerminated(_:)),
                                                 name: NSWorkspace.didTerminateApplicationNotification,
                                                 object: workspace)

        for application in workspace.runningApplications {
            self.managedApplicationLaunched(application)
        }
    }

    func applicationSwitched() {
        self.active = true
    }

    func applicationSwitchedAway() {
        self.active = false
    }

    @objc func applicationLaunched(_ notification: NSNotification) {
        let application = notification.userInfo![NSWorkspace.applicationUserInfoKey] as! NSRunningApplication
        self.managedApplicationLaunched(application)
    }

    @objc func applicationTerminated(_ notification: NSNotification) {
        let application = notification.userInfo![NSWorkspace.applicationUserInfoKey] as! NSRunningApplication
        let pid = application.processIdentifier

        guard pid == self.pid, let observer = self.observer, let observerAway = self.observerAway else {
            return
        }

        CFRunLoopRemoveSource(CFRunLoopGetCurrent(),
                              AXObserverGetRunLoopSource(observer),
                              CFRunLoopMode.defaultMode)
        CFRunLoopRemoveSource(CFRunLoopGetCurrent(), AXObserverGetRunLoopSource(observerAway), .defaultMode)
        self.pid = nil
    }

    func managedApplicationLaunched(_ application: NSRunningApplication) {
        if application.bundleIdentifier == self.managedApplicationId {
            guard (self.pid == nil && observer == nil && observerAway == nil) else {
                print("Attempted to observe application twice.")
                return
            }

            let pid: pid_t = application.processIdentifier
            self.pid = pid

            let element = AXUIElementCreateApplication(pid)

            var observer: AXObserver!
            guard AXObserverCreate(pid, Handle_AppswitchCallback, &observer) == AXError.success else {
                print("Failed to create observer for application.")
                return
            }

            CFRunLoopAddSource(CFRunLoopGetCurrent(),
                               AXObserverGetRunLoopSource(observer),
                               CFRunLoopMode.defaultMode);

            guard AXObserverAddNotification(observer, element, kAXApplicationActivatedNotification as CFString, Unmanaged<AccessibilityService>.passUnretained(self).toOpaque()) == AXError.success else {
                print("Failed to create observer for application.")
                return
            }

            self.observer = observer

            var observerAway: AXObserver!
            guard AXObserverCreate(pid, Handle_AppswitchAwayCallback, &observerAway) == AXError.success else {
                print("Failed to create observer for application.")
                return
            }

            CFRunLoopAddSource(CFRunLoopGetCurrent(),
                               AXObserverGetRunLoopSource(observerAway),
                               CFRunLoopMode.defaultMode);

            guard AXObserverAddNotification(observerAway, element, kAXApplicationDeactivatedNotification as CFString, Unmanaged<AccessibilityService>.passUnretained(self).toOpaque()) == AXError.success else {
                print("Failed to create observer for application.")
                return
            }

            self.observerAway = observerAway
        }
    }
}

private func Handle_AppswitchCallback(observer: AXObserver, element: AXUIElement, string: CFString, context: UnsafeMutableRawPointer!) {
    Unmanaged<AccessibilityService>.fromOpaque(context).takeUnretainedValue().applicationSwitched()
}

private func Handle_AppswitchAwayCallback(observer: AXObserver, element: AXUIElement, string: CFString, context: UnsafeMutableRawPointer!) {
    Unmanaged<AccessibilityService>.fromOpaque(context).takeUnretainedValue().applicationSwitchedAway()
}
