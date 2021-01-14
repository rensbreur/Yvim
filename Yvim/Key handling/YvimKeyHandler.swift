//
//  YvimKeyHandler.swift
//  Yvim
//
//  Created by Rens Breur on 31.12.20.
//  Copyright © 2020 Rens Breur. All rights reserved.
//

import Carbon.HIToolbox

class YvimKeyHandler: KeyHandler {
    let editor: VimEditor

    @Published private(set) var mode: Mode = .command
    var active: Bool = false

    private let movementHandler: ParserKeyHandler<(Int, VimMovement)> = .movementWithMultiplierHandler

    init(editor: VimEditor) {
        self.editor = editor
    }

    func handleKeyEvent(_ keyEvent: KeyEvent, simulateKeyPress: SimulateKeyPress) -> Bool {
        if !self.active {
            return false
        }

        if keyEvent.modifierKeys.contains(.maskCommand) {
            return false
        }

        switch mode {
        case .command:
            return handleCommandModeKey(keyEvent, simulateKeyPress: simulateKeyPress)

        case .insert:
            if keyEvent.keycode == kVK_Escape && keyEvent.event == .down {
                mode = .command
                return true
            }
            return false

        case .visual:
            return handleVisualModeKey(keyEvent, simulateKeyPress: simulateKeyPress)
        }
    }

    private func handleCommandModeKey(_ keyEvent: KeyEvent, simulateKeyPress: SimulateKeyPress) -> Bool {
        switch (keyEvent.char, keyEvent.event) {

        case (KeyConstants.Motion.up, .down):
            simulateKeyPress(CGKeyCode(kVK_UpArrow), [])

        case (KeyConstants.Motion.down, .down):
            simulateKeyPress(CGKeyCode(kVK_DownArrow), [])

        case _ where self.movementHandler.feed(keyEvent, {
            editor.move($0.1, multiplier: $0.0, simulateKeyPress: simulateKeyPress)
        }):
            return true

        case (KeyConstants.insert, .up):
            mode = .insert

        case (KeyConstants.add, .down):
            simulateKeyPress(CGKeyCode(kVK_RightArrow), [])
        case (KeyConstants.add, .up):
            mode = .insert

        case (KeyConstants.newLine, .down):
            simulateKeyPress(keycodeForString("e"), [.maskControl])
            simulateKeyPress(CGKeyCode(kVK_ANSI_KeypadEnter), [])
        case (KeyConstants.newLine, .up):
            self.mode = .insert

        case (KeyConstants.visual, .up):
            self.mode = .visual

        case (KeyConstants.paste, .down):
            editor.paste()

        default:
            break

        }

        return true
    }

    private func handleVisualModeKey(_ keyEvent: KeyEvent, simulateKeyPress: SimulateKeyPress) -> Bool {
        switch (keyEvent.char, keyEvent.event) {

        case (_, .up) where keyEvent.keycode == kVK_Escape:
            mode = .command
            return true

        case (KeyConstants.Motion.up, .down):
            simulateKeyPress(CGKeyCode(kVK_UpArrow), [.maskShift])

        case (KeyConstants.Motion.down, .down):
            simulateKeyPress(CGKeyCode(kVK_DownArrow), [.maskShift])

        case _ where self.movementHandler.feed(keyEvent, {
            editor.changeSelection($0.1, multiplier: $0.0, simulateKeyPress: simulateKeyPress)
        }):
            return true

        case (KeyConstants.delete, .down):
            editor.delete()
            mode = .command

        case (KeyConstants.yank, .down):
            editor.yank()
            mode = .command

        default:
            break

        }

        return true
    }

}
