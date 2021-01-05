//
//  YvimEngine.swift
//  Yvim
//
//  Created by Rens Breur on 31.12.20.
//  Copyright © 2020 Rens Breur. All rights reserved.
//

import Carbon.HIToolbox

class YvimEngine: EventHandler {
    var active: Bool = true // is Xcode active

    var bufferEditor: BufferEditor!

    @Published
    private(set) var mode: Mode = .command

    init() {}

    // Delete/yank/paste register
    private var register: String = ""

    // Parser state
    private var movementHandler: ParserKeyHandler<(Int, VimMovement)> = .movementWithMultiplierHandler

    func handleEvent(_ event: CGEvent, simulateEvent se: (CGEvent) -> Void) -> Bool {
        guard self.active else {
            return false
        }

        let keycode = event.keyboardEventKeycode
        let keyDown = event.keyDown
        let char = stringForKeycode(keycode)

        func simulateEvent(_ keyCode: CGKeyCode, modifierKeys: CGEventFlags = []) -> Void {
            se(.keyboardEvent(keyCode: keyCode, keyDown: true, modifierKeys: modifierKeys))
            se(.keyboardEvent(keyCode: keyCode, keyDown: false, modifierKeys: modifierKeys))
        }

        let editor: BufferEditorOperation = BufferEditorOperation(editor: bufferEditor)
        defer { editor.commit() }

        switch mode {
        case .command:
            let r = self.movementHandler.feed(KeyEvent(event: keyDown ? .down : .up, keycode: keycode, char: event.unicodeString.first!)) { (arg0) in
                let (multiplier, movement) = arg0

                for _ in 0..<multiplier {
                    switch movement {
                    case .forward:
                        editor.moveForward()
                    case .backward:
                        editor.moveBackward()
                    case .up:
                        simulateEvent(CGKeyCodeConstants.up)
                    case .down:
                        simulateEvent(CGKeyCodeConstants.down)
                    case .nextWord:
                        simulateEvent(CGKeyCodeConstants.right, modifierKeys: [.maskControl])
                    case .wordBegin:
                        simulateEvent(CGKeyCodeConstants.left, modifierKeys: [.maskControl])
                    case .lineStart:
                        editor.moveToBeginningOfLine()
                    case .lineEnd:
                        editor.moveToEndOfLine()
                    case .lineFirstNonBlankCharacter:
                        editor.moveToFirstCharacterInLine()
                    case .find(char: let char):
                        editor.seekForward(char: char.utf16.first!)
                    default:
                        break
                    }
                }
            }

            if r { return true }

            // Insert
            if char == "i" && !keyDown {
                mode = .transparent
            }

            // Add
            if char == "a" && keyDown {
                simulateEvent(CGKeyCode(kVK_RightArrow))
            }
            if char == "a" && !keyDown {
                mode = .transparent
            }

            // New line
            if char == "o" && keyDown {
                simulateEvent(keycodeForString("e"), modifierKeys: [.maskControl])
                simulateEvent(CGKeyCode(kVK_ANSI_KeypadEnter))
            }
            if char == "o" && !keyDown {
                self.mode = .transparent
            }

            // Enter visual mode
            if char == "v" && !keyDown {
                self.mode = .visual
            }

            // Paste
            if char == "p" && keyDown {
                editor.selectedText = register as NSString
            }

            return true
        case .transparent:

            // Enter command mode
            if keycode == kVK_Escape && keyDown {
                mode = .command
                return true
            }

            return false
        case .visual:

            // Enter command mode
            if keycode == kVK_Escape && !keyDown {
                mode = .command
                return true
            }

            let r = self.movementHandler.feed(KeyEvent(event: keyDown ? .down : .up, keycode: keycode, char: event.unicodeString.first!)) { (arg0) in
                let (multiplier, movement) = arg0

                for _ in 0..<multiplier {
                    switch movement {
                    case .forward:
                        simulateEvent(CGKeyCodeConstants.left, modifierKeys: [.maskShift])
                    case .backward:
                        simulateEvent(CGKeyCodeConstants.right, modifierKeys: [.maskShift])
                    case .up:
                        simulateEvent(CGKeyCodeConstants.up, modifierKeys: [.maskShift])
                    case .down:
                        simulateEvent(CGKeyCodeConstants.down, modifierKeys: [.maskShift])
                    case .nextWord:
                        simulateEvent(CGKeyCodeConstants.right, modifierKeys: [.maskControl, .maskShift])
                    case .wordBegin:
                        simulateEvent(CGKeyCodeConstants.left, modifierKeys: [.maskControl, .maskShift])
                    case .lineStart:
                        simulateEvent(keycodeForString("a"), modifierKeys: [.maskControl, .maskShift])
                    case .lineEnd:
                        simulateEvent(keycodeForString("e"), modifierKeys: [.maskControl, .maskShift])
                    default:
                        break
                    }
                }
            }

            if r { return true }

            // Deletion
            if char == "d" && keyDown {
                self.register = editor.selectedText as String
                editor.selectedText = ""
                mode = .command
            }

            // Yank
            if char == "y" && keyDown {
                self.register = editor.selectedText as String
                mode = .command
            }

            return true
        }
    }

}
