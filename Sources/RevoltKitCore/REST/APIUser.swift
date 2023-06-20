//
//  APIUser.swift
//  
//
//  Created by gulje on 19.06.2023.
//

import Foundation

public extension RevoltREST {
    // USER INFORMATION
    
    /// Fetch Self
    ///
    /// `GET /users/@me`
    func getCurrentUser() async throws -> User {
        return try await getReq(path: "users/@me")
    }
    
    /// Get User
    ///
    /// `GET /users/{target}`
    ///
    /// - Parameter target: ID of user
    func getUser(_ target: String) async throws -> User {
        return try await getReq(path: "users/\(target)")
    }
    
    /// Edit (Currently Authenticated) User
    ///
    /// `PATCH /users/{target}`
    ///
    /// - Parameter target: ID of user
    func editUser<B: Encodable>(_ target: String, _ body: B) async throws -> User {
        return try await patchReq(
            path: "users/\(target)",
            body: body
        )
    }
    
    /// Edit (Currently Authenticated) User
    ///
    /// `PATCH /users/{target}`
    func editUser(
        target: String,
        display_name: String?,
        avatar: String?,
        status: Status?,
        profile: Profile?,
        badges: Int32?,
        flags: Int32?,
        remove: [RemovePayload]?
    ) async throws -> User {
        return try await editUser(
            target,
            EditUserPayload(
                display_name: display_name,
                avatar: avatar,
                status: status,
                profile: profile,
                badges: badges,
                flags: flags,
                remove: remove
            )
        )
    }
    
    /// Get User Flags
    ///
    /// `GET /users/{target}/flags`
    ///
    /// - Parameter target: ID of user
    func getUserFlags(_ target: String) async throws -> Int32 {
        let response: GetUserFlagsResponse = try await getReq(path: "users/\(target)/flags")
        
        return response.flags
    }
    
    /// Change Username
    ///
    /// `PATCH /users/@me/username`
    ///
    /// - Parameter body: The data
    func changeUsername<B: Encodable>(_ body: B) async throws -> User {
        return try await patchReq(
            path: "users/@me/username",
            body: body
        )
    }
    
    /// Change Username
    ///
    /// `PATCH /users/@me/username`
    ///
    /// - Parameter newUsername: New username
    /// - Parameter password: Password
    func changeUsername(_ newUsername: String, _ password: String) async throws -> User {
        return try await changeUsername(
            ChangeUsernamePayload(
                username: newUsername,
                password: password
            )
        )
    }
    
    /// Fetch User Profile
    ///
    /// Will fail if you do not have permission to access the other user's profile.
    ///
    /// `GET /users/{target}/profile`
    ///
    /// - Parameter target: ID of user
    func fetchProfile(_ target: String) async throws -> Profile {
        return try await getReq(
            path: "users/\(target)/profile"
        )
    }
    
    // DIRECT MESSAGING
    
    /// Fetch Direct Message Channels
    ///
    /// This fetches your direct messages, including any DM and group DM conversations.
    ///
    /// `GET /users/dms`
    func getDirectMessages() async throws -> [Channel] {
        return try await getReq(
            path: "users/dms"
        )
    }
    
    /// Open Direct Message
    ///
    /// Open a DM with another user.
    /// If the target is oneself, a saved messages channel is returned.
    ///
    /// `GET /users/{target}/dm`
    func openDirectMessage(_ target: String) async throws -> Channel {
        return try await getReq(
            path: "users/\(target)/dm"
        )
    }
    
    // RELATIONSHIPS
    
    /// Fetch Mutual Friends and Servers
    ///
    /// Retrieve a list of mutual friends and servers with another user.
    /// Does not work with bot account.
    ///
    /// `GET /users/{target}/mutual`
    ///
    /// - Parameter target: ID of user
    func getMutualWith(_ target: String) async throws -> GetMutualWithResponse {
        return try await getReq(path: "users/\(target)/mutual")
    }
    
    /// Accept Friend Request
    ///
    /// Accept another user's friend request.
    ///
    /// `PUT /users/{target}/friend`
    ///
    /// - Parameter target: ID of user
    func acceptFriendRequest(_ target: String) async throws -> User {
        return try await putReq(
            path: "users/\(target)/friend"
        )
    }
    
    /// Deny Friend Request / Remove Friend
    ///
    /// Denies another user's friend request or removes an existing friend.
    ///
    /// `DELETE /users/{target}/friend`
    ///
    /// - Parameter target: ID of user
    func denyFriendRequestOrRemoveFriend(_ target: String) async throws {
        try await deleteReq(
            path: "users/\(target)/friend"
        )
    }
    
    /// Block User
    ///
    /// Block another user by their id.
    ///
    /// `PUT /users/{target}/block`
    ///
    /// - Parameter target: ID of user
    func blockUser(_ target: String) async throws -> User {
        return try await putReq(
            path: "users/\(target)/block"
        )
    }
    
    /// Unblock User
    ///
    /// Unblock another user by their id.
    ///
    /// `DELETE /users/{target}/block`
    ///
    /// - Parameter target: ID of user
    func unblockUser(_ target: String) async throws {
        try await deleteReq(
            path: "users/\(target)/block"
        )
    }
    
    /// Send Friend Request
    ///
    /// Send a friend request to another user.
    ///
    /// `DELETE /users/{target}/block`
    ///
    /// - Parameter target: Username and discriminator combo separated by #
    func sendFriendRequest(_ target: String) async throws -> User {
        return try await postReq(
            path: "users/friend",
            body: SendFriendRequestPayload(username: target)
        )
    }
}

public struct GetUserFlagsResponse: Codable {
    public let flags: Int32
}

public struct GetMutualWithResponse: Codable {
    public let users: [String]
    public let servers: [String]
}

public enum RemovePayload: String, Codable {
    case Avatar
    case StatusText
    case StatusPresence
    case ProfileContent
    case ProfileBackground
    case DisplayName
}

public struct EditUserPayload: Codable {
    public let display_name: String?
    public let avatar: String?
    public let status: Status?
    public let profile: Profile?
    public let badges: Int32?
    public let flags: Int32?
    public let remove: [RemovePayload]?
}

public struct ChangeUsernamePayload: Codable {
    public let username: String
    public let password: String
}

public struct SendFriendRequestPayload: Codable {
    public let username: String
}
