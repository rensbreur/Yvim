//
//  Mode.swift
//  Yvim
//
//  Created by Rens Breur on 01.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

enum Mode {
    case command
    case transparent // insert, send through all keys
    case visual

    var description: String {
        switch self {
        case .command:
            return "command"
        case .transparent:
            return "insert"
        case .visual:
            return "visual"
        }
    }
}
