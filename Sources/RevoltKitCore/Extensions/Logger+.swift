//
//  Logger+.swift
//  
//
//  Created by gulje on 20.06.2023.
//

import Foundation
import Logging

public extension Logger {
    init(label: String, level: Level?) {
        self.init(label: label)
        
        if let level = level {
            logLevel = level
        } else {
            #if DEBUG
            logLevel = .trace
            #endif
        }
    }
}
