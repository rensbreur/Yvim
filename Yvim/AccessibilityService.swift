//
//  AccessibilityService.swift
//  Yvim
//
//  Created by Rens Breur on 01.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Cocoa
import Combine

class AccessibilityService: ProcessObserver {
    let processObservationService = ProcessObservationService(bundleIdentifier: "com.apple.dt.Xcode")

    var processControllers: (pid: pid_t, svc: ProgramAccessibilityService)?

    @Published var active: Bool = true

    var reassignActiveCancellable: AnyCancellable?

    func applicationLaunched(_ application: NSRunningApplication) {
        let pid = application.processIdentifier
        guard processControllers?.pid != pid else {
            return
        }
        if let svc = processControllers?.svc {
            svc.stop()
        }
        let svc = ProgramAccessibilityService(pid: pid)
        svc.start()
        reassignActiveCancellable = svc.$active.assign(to: \.active, on: self)
        processControllers = (pid, svc)
    }

    func applicationTerminated(_ application: NSRunningApplication) {
        let pid = application.processIdentifier
        if pid == processControllers?.pid {
            reassignActiveCancellable?.cancel()
            processControllers?.svc.stop()
            processControllers = nil
            self.active = false
        }
    }

    func start() {
        processObservationService.observer = self
        processObservationService.start()
    }

}
