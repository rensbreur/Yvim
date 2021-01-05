//
//  AppDelegate.swift
//  Yvim
//
//  Created by Rens Breur on 31.12.20.
//  Copyright © 2020 Rens Breur. All rights reserved.
//

import Cocoa
import Combine

class AppDelegate: NSObject, NSApplicationDelegate {
    var keyboardEventTap: EventTap!
    var accessibilityService: AccessibilityService!
    var engine: YvimEngine!
    var statusItemController: StatusItemController!
    var bufferEditor: AXBufferEditor!

    var activeCancellable: AnyCancellable?

    func applicationDidFinishLaunching(_ notification: Notification) {
        self.checkPermissions()
        self.keyboardEventTap = EventTap()
        self.accessibilityService = AccessibilityService()
        self.accessibilityService.start()
        self.engine = YvimEngine()
        self.keyboardEventTap.eventHandler = engine
        self.keyboardEventTap.startListening()
        self.statusItemController = StatusItemController()
        self.statusItemController.mode = self.engine.$mode.eraseToAnyPublisher()
        self.statusItemController.active = self.accessibilityService.$active.eraseToAnyPublisher()
        self.statusItemController.start()
        self.activeCancellable = self.accessibilityService.$active.assign(to: \YvimEngine.active, on: self.engine)
        self.bufferEditor = AXBufferEditor(accessibilitySvc: self.accessibilityService)
        self.engine.bufferEditor = self.bufferEditor
    }

    func checkPermissions() {
        let trustedCheckOptions = [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true]
        let hasPermissions = AXIsProcessTrustedWithOptions(trustedCheckOptions as CFDictionary)
        if !hasPermissions {
            let alert = NSAlert()
            alert.messageText = "Restart Yvim after granting access."
            alert.runModal()
            exit(EXIT_FAILURE)
        }
    }
}
