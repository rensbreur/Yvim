//
//  unichar+unicodeScalar.swift
//  Yvim
//
//  Created by Admin on 04.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

extension unichar: ExpressibleByUnicodeScalarLiteral {
    public init(unicodeScalarLiteral value: Character) {
        self = value.utf16.first!
    }
}
