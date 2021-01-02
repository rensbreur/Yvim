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

    var processController: (pid: pid_t, svc: ProgramAccessibilityService)?

    @Published var active: Bool = true

    var reassignActiveCancellable: AnyCancellable?

    func applicationLaunched(_ application: NSRunningApplication) {
        let pid = application.processIdentifier
        guard processController?.pid != pid else {
            return
        }
        if let svc = processController?.svc {
            svc.stop()
        }
        let svc = ProgramAccessibilityService(pid: pid)
        svc.start()
        reassignActiveCancellable = svc.$active.assign(to: \.active, on: self)
        processController = (pid, svc)
    }

    func applicationTerminated(_ application: NSRunningApplication) {
        let pid = application.processIdentifier
        if pid == processController?.pid {
            reassignActiveCancellable?.cancel()
            processController?.svc.stop()
            processController = nil
            self.active = false
        }
    }

    func start() {
        processObservationService.observer = self
        processObservationService.start()
    }

}
