//
//  AppDelegate.swift
//  Yvim
//
//  Created by Rens Breur on 31.12.20.
//  Copyright © 2020 Rens Breur. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var keyboardEventTap: KeyboardEventTap!
    var engine: YvimEngine!
    var statusItemController: StatusItemController!

    func applicationDidFinishLaunching(_ notification: Notification) {
        self.keyboardEventTap = KeyboardEventTap()
        self.engine = YvimEngine(kc: keyboardEventTap)
        self.keyboardEventTap.keyboardEventHandler = engine
        self.keyboardEventTap.startListening()
        self.statusItemController = StatusItemController()
        self.statusItemController.mode = self.engine.$mode.eraseToAnyPublisher()
        self.statusItemController.start()
    }
}
