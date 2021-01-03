//
//  BufferEditor.swift
//  Yvim
//
//  Created by Admin on 02.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

protocol BufferEditor: AnyObject {
    func getText() -> NSString
    func getSelectedTextRange() -> CFRange
    func setSelectedTextRange(_ range: CFRange)
    func getSelectedText() -> NSString
    func setSelectedText(_ text: NSString)
}

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
        set { selectedTextRange.location = newValue }
    }

    func character(at index: Int) -> unichar? {
        guard index > 0 else { return nil }
        guard index < text.length else { return nil }
        return text.character(at: index)
    }

    func moveForward(while condition: (unichar) -> Bool) {
        var pos = cursorPosition
        while let char = character(at: pos), condition(char) {
            pos += 1
        }
        cursorPosition = pos
    }

    func moveBackward(while condition: (unichar) -> Bool) {
        var pos = cursorPosition
        while let char = character(at: pos), condition(char) {
            pos -= 1
        }
        cursorPosition = pos
    }

    func seekForward(char: unichar) {
        moveForward()
        moveForward(while: { $0 != char })
    }

    func moveToBeginningOfLine() {
        moveBackward(while: { $0 != "\n" })
        moveForward()
    }

    func moveToEndOfLine() {
        moveForward(while: { $0 != "\n" })
        moveBackward()
    }

    func moveToFirstCharacterInLine() {
        moveToBeginningOfLine()
        moveForward(while: { $0 == " " })
    }

    func moveForward() {
        let pos = cursorPosition + 1
        if let char = character(at: pos), char != "\n" {
            cursorPosition = pos
        }
    }

    func moveBackward() {
        guard cursorPosition > 0 else { return }
        if text.character(at: cursorPosition-1) != "\n" {
            cursorPosition -= 1
        }
    }

}

extension unichar: ExpressibleByUnicodeScalarLiteral {
    public init(unicodeScalarLiteral value: Character) {
        self = value.utf16.first!
    }
}

class AXBufferEditor: BufferEditor {
    let accessibilitySvc: AccessibilityService
    
    init(accessibilitySvc: AccessibilityService) {
        self.accessibilitySvc = accessibilitySvc
    }

    func getSelectedText() -> NSString {
        accessibilitySvc.processController?.svc.element.focusedUIElement.selectedText as NSString?  ?? ("" as NSString)
    }

    func setSelectedText(_ newValue: NSString) {
        accessibilitySvc.processController?.svc.element.focusedUIElement.setSelectedText(newValue)
    }

    func getSelectedTextRange() -> CFRange {
        accessibilitySvc.processController?.svc.element.focusedUIElement.selection ?? CFRangeMake(0, 0)
    }

    func setSelectedTextRange(_ range: CFRange) {
        accessibilitySvc.processController?.svc.element.focusedUIElement.setSelection(range)
    }

    func getText() -> NSString {
        accessibilitySvc.processController?.svc.element.focusedUIElement.text ?? ""
    }
}

