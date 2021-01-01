//
//  AppDelegate.swift
//  Yvim
//
//  Created by Rens Breur on 31.12.20.
//  Copyright © 2020 Rens Breur. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var keyboardEventTap: EventTap!
    var engine: YvimEngine!
    var statusItemController: StatusItemController!

    func applicationDidFinishLaunching(_ notification: Notification) {
        self.keyboardEventTap = EventTap()
        self.engine = YvimEngine()
        self.keyboardEventTap.eventHandler = engine
        self.keyboardEventTap.startListening()
        self.statusItemController = StatusItemController()
        self.statusItemController.mode = self.engine.$mode.eraseToAnyPublisher()
        self.statusItemController.start()
    }
}