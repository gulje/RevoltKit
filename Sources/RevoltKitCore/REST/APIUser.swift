//
//  APIUser.swift
//  
//
//  Created by gulje on 19.06.2023.
//

import Foundation

public extension RevoltREST {
    func getCurrentUser() async throws -> User {
        return try await getReq(path: "users/@me")
    }
}
