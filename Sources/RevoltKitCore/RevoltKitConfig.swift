//
//  RevoltKitConfig.swift
//  
//
//  Created by gulje on 19.06.2023.
//

import Foundation

public struct RevoltKitConfig {
    public let baseURL: URL
    
    public let cdnURL: String
    
    public let restBase: URL
    
    public var version: Int = 1
    
    public var gateway: String {
        "wss://ws.revolt.chat?version=\(version)&format=json"
    }
    
    public init(
        baseURL: String = "revolt.chat",
        _version: Int = 1
    ) {
        self.cdnURL = "https://autumn.revolt.chat/"
        self.baseURL = URL(string: "https://\(baseURL)/")!
        self.version = 1
        
        self.restBase = self.baseURL.appendingPathComponent("api")
        
    }
    
    public static var `default` = Self()
}
