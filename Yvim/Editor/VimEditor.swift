//
//  VimEditor.swift
//  Yvim
//
//  Created by Admin on 05.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

class VimEditor {
    var bufferEditor: BufferEditor!

    // Delete/yank/paste register
    private var register: String = ""

    func move(_ movement: VimMovement, multiplier: Int = 1, simulateKeyPress: SimulateKeyPress) {
        let editor: BufferEditorOperation = BufferEditorOperation(editor: bufferEditor)
        defer { editor.commit() }

        for _ in 0..<multiplier {
            switch movement {
            case .forward:
                editor.moveForward()
            case .backward:
                editor.moveBackward()
            case .up:
                simulateKeyPress(CGKeyCodeConstants.up, [])
            case .down:
                simulateKeyPress(CGKeyCodeConstants.down, [])
            case .nextWord:
                simulateKeyPress(CGKeyCodeConstants.right, [.maskControl])
            case .wordBegin:
                simulateKeyPress(CGKeyCodeConstants.left, [.maskControl])
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

    func changeSelection(_ movement: VimMovement, multiplier: Int = 1, simulateKeyPress: SimulateKeyPress) {
        let editor: BufferEditorOperation = BufferEditorOperation(editor: bufferEditor)
        defer { editor.commit() }

        for _ in 0..<multiplier {
            switch movement {
            case .forward:
                simulateKeyPress(CGKeyCodeConstants.left, [.maskShift])
            case .backward:
                simulateKeyPress(CGKeyCodeConstants.right, [.maskShift])
            case .up:
                simulateKeyPress(CGKeyCodeConstants.up, [.maskShift])
            case .down:
                simulateKeyPress(CGKeyCodeConstants.down, [.maskShift])
            case .nextWord:
                simulateKeyPress(CGKeyCodeConstants.right, [.maskControl, .maskShift])
            case .wordBegin:
                simulateKeyPress(CGKeyCodeConstants.left, [.maskControl, .maskShift])
            case .lineStart:
                simulateKeyPress(keycodeForString("a"), [.maskControl, .maskShift])
            case .lineEnd:
                simulateKeyPress(keycodeForString("e"), [.maskControl, .maskShift])
            default:
                break
            }
        }
    }

    func paste() {
        let editor: BufferEditorOperation = BufferEditorOperation(editor: bufferEditor)
        defer { editor.commit() }
        editor.selectedText = register as NSString
    }

    func delete() {
        let editor: BufferEditorOperation = BufferEditorOperation(editor: bufferEditor)
        defer { editor.commit() }
        self.register = editor.selectedText as String
        editor.selectedText = ""
    }

    func yank() {
        let editor: BufferEditorOperation = BufferEditorOperation(editor: bufferEditor)
        defer { editor.commit() }
        self.register = editor.selectedText as String
    }
}
