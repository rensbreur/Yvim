//
//  BufferEditorOperation.swift
//  Yvim
//
//  Created by Admin on 04.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

class BufferEditorOperation {
    let editor: BufferEditor

    init (editor: BufferEditor) {
        self.editor = editor
    }

    private lazy var _text: NSString = editor.getText()
    private lazy var _selectedText: NSString = editor.getSelectedText()
    private lazy var _selectedTextRange: CFRange = editor.getSelectedTextRange()

    private var _newText: NSString?
    private var _newSelectedText: NSString?
    private var _newSelectedTextRange: CFRange?

    var text: NSString {
        get { _newText ?? _text }
        set { _newText = newValue } }
    var selectedText: NSString {
        get { _newSelectedText ?? _selectedText }
        set { _newSelectedText = newValue } }
    var selectedTextRange: CFRange {
        get { _newSelectedTextRange ?? _selectedTextRange }
        set { _newSelectedTextRange = newValue } }

    func commit() {
        if let selectedText = _newSelectedText {
            self.editor.setSelectedText(selectedText)
        }
        if let selectedTextRange = _newSelectedTextRange {
            self.editor.setSelectedTextRange(selectedTextRange)
        }
    }

}

extension BufferEditorOperation {
    var cursorPosition: Int {
        get { selectedTextRange.location }
        set { selectedTextRange = CFRangeMake(newValue, 0) }
    }
}
