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

    func move(_ motion: VimMotion, multiplier: Int = 1, simulateKeyPress: SimulateKeyPress) {
        let editor: BufferEditorOperation = BufferEditorOperation(editor: bufferEditor)
        for _ in 0 ..< multiplier {
            editor.cursorPosition = motion.index(from: editor.cursorPosition, in: editor.text)
        }
        editor.commit()
    }

    func changeSelection(_ motion: VimMotion, multiplier: Int = 1, simulateKeyPress: SimulateKeyPress) {
        let editor: BufferEditorOperation = BufferEditorOperation(editor: bufferEditor)
        for _ in 0 ..< multiplier {
            let motionEndIndex = motion.index(from: editor.selectedTextRange.location + editor.selectedTextRange.length - 1, in: editor.text)
            editor.selectedTextRange = CFRangeMake(editor.cursorPosition, motionEndIndex - editor.cursorPosition + 1)
        }
        editor.commit()
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
