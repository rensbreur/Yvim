//
//  ProcessObservationService.swift
//  Yvim
//
//  Created by Rens Breur on 01.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Cocoa

protocol ProcessObserver: AnyObject {
    /// It is the responsibility of the implementation to check if this method is called twice
    func applicationLaunched(_ application: NSRunningApplication)
    func applicationTerminated(_ application: NSRunningApplication)
}

class ProcessObservationService {
    let managedApplicationId: String // eu.rensbr.App

    weak var observer: ProcessObserver?

    init(bundleIdentifier: String) {
        self.managedApplicationId = bundleIdentifier
    }

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

    @objc func applicationLaunched(_ notification: NSNotification) {
        let application = notification.userInfo![NSWorkspace.applicationUserInfoKey] as! NSRunningApplication
        self.managedApplicationLaunched(application)
    }

    @objc func applicationTerminated(_ notification: NSNotification) {
        let application = notification.userInfo![NSWorkspace.applicationUserInfoKey] as! NSRunningApplication
        if application.bundleIdentifier == self.managedApplicationId {
            self.observer?.applicationTerminated(application)
        }
    }

    func managedApplicationLaunched(_ application: NSRunningApplication) {
        if application.bundleIdentifier == self.managedApplicationId {
            self.observer?.applicationLaunched(application)
        }
    }
}
