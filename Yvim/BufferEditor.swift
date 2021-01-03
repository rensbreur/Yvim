//
//  BufferEditor.swift
//  Yvim
//
//  Created by Admin on 02.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

protocol BufferEditor: AnyObject {
    var selectedText: String { get set }
    var cursorPosition: Int { get set }
    var text: NSString { get }
}

extension BufferEditor {
    func lookForward(_ character: unichar) -> Int? {
        let text = self.text
        var offset = 0
        for i in self.cursorPosition..<text.length {
            if text.character(at: i) == character {
                return offset
            }
            offset += 1
        }
        return nil
    }
    
    func moveForward() {
        let text = self.text
        let pos = self.cursorPosition + 1
        guard pos < text.length else {
            return
        }
        if text.character(at: pos) != "\n".utf16.first! {
            self.cursorPosition = pos
        }
    }
    
    func moveBackward() {
        let text = self.text
        let pos = self.cursorPosition - 1
        guard pos >= 0 else {
            return
        }
        if text.character(at: pos) != "\n".utf16.first! {
            self.cursorPosition = pos
        }
    }

}

class AXBufferEditor: BufferEditor {
    let accessibilitySvc: AccessibilityService
    
    init(accessibilitySvc: AccessibilityService) {
        self.accessibilitySvc = accessibilitySvc
    }
    
    var selectedText: String {
        get {
            accessibilitySvc.processController!.svc.element.focusedUIElement.selectedText
        }
        set {
            accessibilitySvc.processController!.svc.element.focusedUIElement.setSelectedText(newValue)
        }
    }
    
    var cursorPosition: Int {
        get {
            accessibilitySvc.processController!.svc.element.focusedUIElement.selection.location
        }
        set {
            var range = accessibilitySvc.processController!.svc.element.focusedUIElement.selection
            range.location = newValue
            accessibilitySvc.processController!.svc.element.focusedUIElement.setSelection(range)
        }
    }
    
    var text: NSString {
        accessibilitySvc.processController!.svc.element.focusedUIElement.text
    }
}

