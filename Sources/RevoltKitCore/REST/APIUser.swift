//
//  APIUser.swift
//  
//
//  Created by gulje on 19.06.2023.
//

import Foundation

public struct GetUserFlagsResponse: Codable {
    public let flags: Int32
}

public struct GetMutualWithResponse: Codable {
    public let users: [String]
    public let servers: [String]
}

public extension RevoltREST {
    /// Get Current User
    ///
    /// `GET /users/@me`
    func getCurrentUser() async throws -> User {
        return try await getReq(path: "users/@me")
    }
    
    /// Get User
    ///
    /// `GET /users/{user.id}`
    ///
    /// - Parameter user: ID of user
    func getUser(user: String) async throws -> User {
        return try await getReq(path: "users/\(user)")
    }
    
    /// Get User Flags
    ///
    /// `GET /users/{user.id}/flags`
    ///
    /// - Parameter user: ID of user
    func getUserFlags(user: String) async throws -> Int32 {
        let response: GetUserFlagsResponse = try await getReq(path: "users/\(user)/flags")
        
        return response.flags
    }
    
    /// Fetch Mutual Friends and Servers
    /// Retrieve a list of mutual friends and servers with another user.
    /// Does not work with bot account.
    ///
    /// `GET /users/{user.id}/mutual`
    func getMutualWith(user: String) async throws -> GetMutualWithResponse {
        return try await getReq(path: "users/\(user)/mutual")
    }
}
