//
//  AXBufferEditor.swift
//  Yvim
//
//  Created by Admin on 04.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

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
