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
