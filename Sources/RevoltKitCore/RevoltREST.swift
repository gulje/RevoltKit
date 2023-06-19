//
//  RevoltREST.swift
//  
//
//  Created by gulje on 19.06.2023.
//

import Foundation
import Logging

public class RevoltREST {
    static let log = Logger(label: "RevoltREST")
    
    static let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        
        return URLSession(configuration: configuration)
    }()
    
    internal var token: String?
    
    public init() {}
    
    public func setToken(token: String?) {
        self.token = token
    }
}
