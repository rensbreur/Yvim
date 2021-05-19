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
    var yvimKeyHandler: YvimKeyHandler!

    var keyboardEventTap: EventTap!
    var accessibilityService: AccessibilityService!
    var statusItemController: StatusItemController!
    var bufferEditor: AXBufferEditor!

    var activeCancellable: AnyCancellable?

    func applicationDidFinishLaunching(_ notification: Notification) {

        self.checkPermissions()
        self.accessibilityService = AccessibilityService()
        self.accessibilityService.start()
        self.bufferEditor = AXBufferEditor(accessibilitySvc: self.accessibilityService)
        self.yvimKeyHandler = YvimKeyHandler(editor: bufferEditor)
        self.statusItemController = StatusItemController()
        self.statusItemController.mode = self.yvimKeyHandler.$mode.eraseToAnyPublisher()
        self.statusItemController.active = self.accessibilityService.$active.eraseToAnyPublisher()
        self.statusItemController.start()
        self.activeCancellable = self.accessibilityService.$active.assign(to: \YvimKeyHandler.active, on: self.yvimKeyHandler)
        self.keyboardEventTap = EventTap()
        self.keyboardEventTap.eventHandler = KeyEventHandler(keyHandler: yvimKeyHandler)
        self.keyboardEventTap.startListening()
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
