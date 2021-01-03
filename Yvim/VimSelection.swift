//
//  VimSelection.swift
//  Yvim
//
//  Created by Admin on 03.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

/// A range with direction, so that it is clear which end to modify
struct VimSelection {
    private(set) var start: Int
    private(set) var length: Int // can be negative

    /// Move right, keeping a minimum length of 1
    mutating func moveRight() {
        if length == -1 {
            //  <-*
            //  *-->
            start -= 1
            length = 2
            return
        }

        length += 1
    }

    /// Move left, keeping a minimum length of 1
    mutating func moveLeft() {
        if length == 1 {
            //   *->
            //  <--*
            start += 1
            length = -2
            return
        }
        length -= 1
    }

    var cfRange: CFRange {
        if length < 0 { return CFRangeMake(start + length, -length) }
        return CFRangeMake(start, length)
    }
}
