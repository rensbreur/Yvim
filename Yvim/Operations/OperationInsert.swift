//
//  OperationInsert.swift
//  Yvim
//
//  Created by Admin on 21.05.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

extension Operations {
    struct Insert: Operation {
        let text: String

        func perform(_ editor: BufferEditor) {
            editor.perform {
                $0.selectedText = text as NSString
            }
        }
    }
}
