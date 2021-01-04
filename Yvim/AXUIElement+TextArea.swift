//
//  AXUIElement+TextArea.swift
//  Yvim
//
//  Created by Admin on 04.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

extension AXUIElement {
    var focusedUIElement: AXUIElement {
        var attrVal: AnyObject!
        AXUIElementCopyAttributeValue(self, kAXFocusedUIElementAttribute as CFString, &attrVal)
        return attrVal as! AXUIElement
    }

    var value: CFString {
        var attrVal: AnyObject?
        AXUIElementCopyAttributeValue(self, kAXValueAttribute as CFString, &attrVal)
        return (attrVal as! CFString)
    }

    var selectedText: CFString {
        var attrVal: AnyObject?
        AXUIElementCopyAttributeValue(self, kAXSelectedTextAttribute as CFString, &attrVal)
        return (attrVal as! CFString)
    }

    func setSelectedText(_ text: CFString) {
        AXUIElementSetAttributeValue(self, kAXSelectedTextAttribute as CFString, text as CFString)
    }

    var selection: CFRange {
        var attrVal: AnyObject?
        AXUIElementCopyAttributeValue(self, kAXSelectedTextRangeAttribute as CFString, &attrVal)
        var range: CFRange = CFRangeMake(0,0)
        print(AXValueGetType((attrVal as! AXValue)).rawValue == kAXValueCFRangeType)
        AXValueGetValue((attrVal as! AXValue), AXValueType(rawValue: kAXValueCFRangeType)!, &range)
        return range
    }

    func setSelection(_ range: CFRange) {
        var range = range
        let attrVal = AXValueCreate(AXValueType(rawValue: kAXValueCFRangeType)!, &range)
        AXUIElementSetAttributeValue(self, kAXSelectedTextRangeAttribute as CFString, attrVal!)
    }

    /// Using NSString's reference semantics to increase performance
    var text: NSString {
        var attrVal: AnyObject?
        AXUIElementCopyAttributeValue(self, kAXValueAttribute as CFString, &attrVal)
        return (attrVal as! CFString)
    }
}
