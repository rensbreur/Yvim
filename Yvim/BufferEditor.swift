//
//  BufferEditor.swift
//  Yvim
//
//  Created by Admin on 02.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

protocol BufferEditor {
    var selectedText: String { get set }
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
}

