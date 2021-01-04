//
//  NSString+unichar.swift
//  Yvim
//
//  Created by Admin on 04.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

extension NSString {
    func safeCharacter(at index: Int) -> unichar? {
        guard index > 0 else { return nil }
        guard index < length else { return nil }
        return character(at: index)
    }
}
