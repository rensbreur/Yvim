//
//  StatusItemController.swift
//  Yvim
//
//  Created by Rens Breur on 01.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Cocoa
import Combine

class StatusItemController {
    private(set) var menuItem: NSStatusItem!
    var active: AnyPublisher<Bool, Never>!
    var mode: AnyPublisher<Mode, Never>!

    private var modeCancellable: AnyCancellable?

    init() {
        self.menuItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.menuItem.menu = NSMenu()
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "")
        quitItem.target = self
        self.menuItem.menu?.addItem(quitItem)
    }

    @objc func quit() {
        exit(0)
    }

    func start() {
        self.modeCancellable = active.removeDuplicates().combineLatest(mode)
            .map(text)
            .sink { str in
                self.menuItem.button!.title = str
            }
    }

    func text(state: (Bool, Mode)) -> String {
        let (active, mode) = state
        if !active { return "" }
        else { return "-- \(mode.description.uppercased()) --" }
    }
}
