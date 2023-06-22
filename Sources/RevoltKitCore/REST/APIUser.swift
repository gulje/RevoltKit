//
//  APIUser.swift
//
//
//  Created by gulje on 19.06.2023.
//

import Foundation

extension RevoltREST {
  // USER INFORMATION

  /// Fetch Self
  ///
  /// `GET /users/@me`
  ///
  /// - Returns: Current user
  public func getCurrentUser() async throws -> User {
    return try await getReq(path: "users/@me")
  }

  /// Get User
  ///
  /// `GET /users/{target}`
  ///
  /// - Parameters:
  ///   - target: ID of user
  ///
  /// - Returns: Fetched user
  public func getUser(_ target: String) async throws -> User {
    return try await getReq(path: "users/\(target)")
  }

  /// Edit (Currently Authenticated) User
  ///
  /// `PATCH /users/{user}`
  ///
  /// - Parameters:
  ///   - user: The identifier of the user to be edited.
  ///   - displayName: The new display name for the user. Optional.
  ///   - avatar: The new avatar URL for the user. Optional.
  ///   - status: The new status for the user. Optional.
  ///   - profile: The new profile information for the user. Optional.
  ///   - badges: The new badge count for the user. Optional.
  ///   - flags: The new flag count for the user. Optional.
  ///   - remove: An array of items to be removed from the user's profile. Optional.
  ///
  /// - Returns: A `User` object representing the updated user profile.
  public func editUser(
    _ user: String,
    displayName: String? = nil,
    avatar: String? = nil,
    status: Status? = nil,
    profile: Profile? = nil,
    badges: Int32? = nil,
    flags: Int32? = nil,
    remove: [RemovePayload]? = nil
  ) async throws -> User {
    return try await patchReq(
      path: "users/\(user)",
      body: EditUserPayload(
        displayName: displayName,
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
  /// - Parameters:
  ///   - target: ID of user
  public func getUserFlags(_ target: String) async throws -> Int32 {
    let response: GetUserFlagsResponse = try await getReq(path: "users/\(target)/flags")

    return response.flags
  }

  /// Change Username
  ///
  /// `PATCH /users/@me/username`
  ///
  /// - Parameters:
  ///   - newUsername: New username
  ///   - password: Password
  public func changeUsername(_ newUsername: String, _ password: String) async throws -> User {
    return try await patchReq(
      path: "users/@me/username",
      body: ChangeUsernamePayload(username: newUsername, password: password)
    )
  }

  /// Fetch User Profile
  ///
  /// Will fail if you do not have permission to access the other user's profile.
  ///
  /// `GET /users/{target}/profile`
  ///
  /// - Parameters:
  ///   - target: ID of user
  public func fetchProfile(_ target: String) async throws -> Profile {
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
  public func getDirectMessages() async throws -> [Channel] {
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
  public func openDirectMessage(_ target: String) async throws -> Channel {
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
  /// - Parameters:
  ///   - target: ID of user
  public func getMutualWith(_ target: String) async throws -> GetMutualWithResponse {
    return try await getReq(path: "users/\(target)/mutual")
  }

  /// Accept Friend Request
  ///
  /// Accept another user's friend request.
  ///
  /// `PUT /users/{target}/friend`
  ///
  /// - Parameters:
  ///   - target: ID of user
  public func acceptFriendRequest(_ target: String) async throws -> User {
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
  /// - Parameters:
  ///   - target: ID of user
  public func denyFriendRequestOrRemoveFriend(_ target: String) async throws {
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
  /// - Parameters:
  ///   - target: ID of user
  public func blockUser(_ target: String) async throws -> User {
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
  /// - Parameters:
  ///   - target: ID of user
  public func unblockUser(_ target: String) async throws {
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
  /// - Parameters:
  ///   - target: Username and discriminator combo separated by #
  public func sendFriendRequest(_ target: String) async throws -> User {
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
  case avatar = "Avatar"
  case statusText = "StatusText"
  case statusPresence = "StatusPresence"
  case profileContent = "ProfileContent"
  case profileBackground = "ProfileBackground"
  case displayName = "DisplayName"
}

struct EditUserPayload: Codable {
  public let displayName: String?
  public let avatar: String?
  public let status: Status?
  public let profile: Profile?
  public let badges: Int32?
  public let flags: Int32?
  public let remove: [RemovePayload]?

  private enum CodingKeys: String, CodingKey {
    case displayName = "display_name"
    case avatar
    case status
    case profile
    case badges
    case flags
    case remove
  }
}

public struct ChangeUsernamePayload: Codable {
  public let username: String
  public let password: String
}

public struct SendFriendRequestPayload: Codable {
  public let username: String
}
