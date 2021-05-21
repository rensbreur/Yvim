//
//  OperationMove.swift
//  Yvim
//
//  Created by Admin on 21.05.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

extension Operations {
    struct Move: Operation {
        let motion: LineMotion

        func perform(_ editor: BufferEditor) {
            editor.perform {
                $0.cursorPosition = motion.index(from: $0.cursorPosition, in: $0.text)
            }
        }
    }
}
