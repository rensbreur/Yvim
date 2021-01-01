//
//  AccessibilityService.swift
//  Yvim
//
//  Created by Rens Breur on 01.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Cocoa

private func Handle_AppswitchCallback(observer: AXObserver, element: AXUIElement, string: CFString, context: UnsafeMutableRawPointer!) {
    Unmanaged<AccessibilityService>.fromOpaque(context).takeUnretainedValue().applicationSwitched()
}

class AccessibilityService {
    var _observers: [pid_t: AXObserver] = [:]
    var _currentPid: pid_t?

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
            self.registerForAppSwitchNotification(for: application)
        }

        self.applicationSwitched()
    }

    func applicationSwitched() {
        let application = NSWorkspace.shared.menuBarOwningApplication!
        let switchedPid: pid_t = application.processIdentifier

        guard (switchedPid != _currentPid && switchedPid != getpid()) else {
            return
        }

        let applicationName = application.localizedName!

        print("Switched to \(applicationName)")

        _currentPid = switchedPid;
    }

    @objc func applicationLaunched(_ notification: NSNotification) {
        let application = notification.userInfo![NSWorkspace.applicationUserInfoKey] as! NSRunningApplication
        self.registerForAppSwitchNotification(for: application)
        self.applicationSwitched()
    }


    @objc func applicationTerminated(_ notification: NSNotification) {
        let application = notification.userInfo![NSWorkspace.applicationUserInfoKey] as! NSRunningApplication
        let pid = application.processIdentifier

        guard let observer = _observers[pid] else {
            print("Application that we didn't know about quit!")
            return
        }

        CFRunLoopRemoveSource(CFRunLoopGetCurrent(),
                              AXObserverGetRunLoopSource(observer),
                              CFRunLoopMode.defaultMode)
        _observers[pid] = nil
    }

    func registerForAppSwitchNotification(for application: NSRunningApplication) {
        let pid: pid_t = application.processIdentifier

        // Do not observe self
        guard (pid != getpid()) else {
            return
        }

        let applicationName: String = application.localizedName!

        // Do not observe the same app twice
        guard (_observers[pid] == nil) else {
            print("Attempted to observe application \"\(applicationName)\" twice.")
            return
        }

        /* Create an Accessibility observer for the application */
        var observer: AXObserver!
        guard AXObserverCreate(pid, Handle_AppswitchCallback, &observer) == AXError.success else {
            print("Failed to create observer for application \"\(applicationName)\".")
            return
        }

        CFRunLoopAddSource(CFRunLoopGetCurrent(),
                           AXObserverGetRunLoopSource(observer),
                           CFRunLoopMode.defaultMode);

        let element = AXUIElementCreateApplication(pid)
        guard AXObserverAddNotification(observer, element, kAXApplicationActivatedNotification as CFString, Unmanaged<AccessibilityService>.passUnretained(self).toOpaque()) == AXError.success else {
            print("Failed to create observer for application \"\(applicationName)\".")
            return
        }

        _observers[pid] = observer
    }
}
