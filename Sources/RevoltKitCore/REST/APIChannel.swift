//
//  APIChannel.swift
//
//
//  Created by gulje on 20.06.2023.
//

import Foundation

func buildQueryFromCodable<S: Codable>(_ s: S) throws -> [URLQueryItem] {
  let jsonData = try RevoltREST.encoder.encode(s)
  let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]

  return json.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
}

extension RevoltREST {
  // CHANNEL INFORMATION

  /// Fetch Channel
  ///
  /// Fetch channel by its ID.
  ///
  /// `GET /channels/{target}`
  ///
  /// - Parameter target: ID of the channel
  public func fetchChannel(_ target: String) async throws -> Channel {
    return try await getReq(
      path: "channels/\(target)"
    )
  }

  /// Close Channel
  ///
  /// Deletes a server channel, leaves a group or closes a group.
  ///
  /// `DELETE /channels/{target}`
  ///
  /// - Parameters:
  ///   - target: ID of the channel
  ///   - leave_silently: Whether to not send a leave message
  public func closeChannel(_ target: String, leave_silently: Bool = false) async throws {
    return try await deleteReq(
      path: "channels/\(target)",
      query: leave_silently ? [URLQueryItem(name: "leave_silently", value: "true")] : []
    )
  }

  /// Edit Channel
  ///
  /// Edit a channel by its ID.
  ///
  /// `PATCH /channels/{target}`
  public func editChannel<B: Encodable>(_ target: String, _ body: B) async throws -> Channel {
    return try await patchReq(
      path: "channels/\(target)",
      body: body
    )
  }

  /// Edit Channel
  ///
  /// Edit a channel by its ID.
  ///
  /// `PATCH /channels/{target}`
  public func editChannel(
    _ target: String,
    name: String? = nil,
    description: String? = nil,
    owner: String? = nil,
    icon: String? = nil,
    nsfw: Bool? = nil,
    archived: Bool? = nil,
    remove: [EditChannelRemove]? = []
  ) async throws -> Channel {
    return try await editChannel(
      target,
      EditChannelPayload(
        name: name,
        description: description,
        owner: owner,
        icon: icon,
        nsfw: nsfw,
        archived: archived,
        remove: remove
      )
    )
  }

  // CHANNEL INVITES

  // TODO: Implement creating invite
  /// Create Invite
  ///
  /// Creates an invite to this channel.
  /// Channel must be a `TextChannel`.
  ///
  /// `POST /channels/{target}/invites`
  public func createInvite() async throws {
    throw RevoltKitErrors.notImplemented("Not implemented yet")
  }

  // CHANNEL PERMISSIONS

  // TODO: Implement permissions
  /// Set Role Permission
  ///
  /// Sets permissions for the specified role in this channel.
  /// Channel must be a `TextChannel` or `VoiceChannel`.
  ///
  /// `PUT /channels/{target}/permissions/{role_id}`
  public func setRolePermission() async throws {
    throw RevoltKitErrors.notImplemented("Not implemented yet")
  }

  // TODO: Implement permissions
  /// Set Default Permission
  ///
  /// Sets permissions for the default role in this channel.
  /// Channel must be a `Group`, `TextChannel` or `VoiceChannel`.
  ///
  /// `PUT /channels/{target}/permissions/default`
  public func setDefaultPermission() async throws {
    throw RevoltKitErrors.notImplemented("Not implemented yet")
  }

  // MESSAGING

  /// Acknowledge Message
  ///
  /// Lets the server and all other clients know that we've seen this message id in this channel.
  ///
  /// `PUT /channels/{target}/ack/{message}`
  ///
  /// - Parameters:
  ///   - target: Target channel's ID
  ///   - message: Message ID
  public func acknowledgeMessage(_ target: String, _ message: String) async throws {
    try await putReq(
      path: "channels/\(target)/ack/\(message)"
    )
  }

  /// Fetch Messages
  ///
  /// Fetch multiple messages.
  ///
  /// `GET /channels/{target}/messages`
  ///
  /// - Parameters:
  ///   - target: Channel ID
  ///   - body: The options for fetching action
  public func fetchMessages<B: Codable>(_ target: String, _ body: B) async throws -> [Message] {
    var query = try buildQueryFromCodable(body)

    if (query.map { $0.name }).contains("include_users") {
      query.append(URLQueryItem(name: "include_users", value: "false"))
    }

    return try await getReq(
      path: "channels/\(target)/messages",
      query: query
    )
  }

  /// Fetch Messages
  ///
  /// Fetch multiple messages.
  ///
  /// `GET /channels/{target}/messages`
  ///
  /// - Parameters:
  ///   - target: Channel ID
  ///   - body: The options for fetching action
  public func fetchMessages(
    _ target: String,
    limit: Int64? = nil,
    before: String? = nil,
    after: String? = nil,
    sort: MessageSortDirection? = nil,
    nearby: String? = nil
  ) async throws -> [Message] {
    return try await fetchMessages(
      target,
      FetchMessagesPayload(
        limit: limit,
        before: before,
        after: after,
        sort: sort,
        nearby: nearby,
        includeUsers: false
      )
    )
  }

  /// Fetch Messages
  ///
  /// Fetch multiple messages.
  ///
  /// `GET /channels/{target}/messages`
  ///
  /// - Parameters:
  ///   - target: Channel ID
  ///   - body: The options for fetching action
  public func fetchMessagesWithUsers<B: Codable>(_ target: String, _ body: B) async throws {
    throw RevoltKitErrors.notImplemented("Not implemented yet")
  }

  // TODO: Implement messages
  /// Send Message
  ///
  /// Sends a message to the given channel.
  ///
  /// `POST /channels/{target}/messages`
  public func sendMessage() async throws {
    throw RevoltKitErrors.notImplemented("Not implemented yet")
  }

  // TODO: Implement messages
  /// Search for Messages
  ///
  /// This route searches for messages within the given parameters.
  ///
  /// `POST /channels/{target}/search`
  public func searchMessages() async throws {
    throw RevoltKitErrors.notImplemented("Not implemented yet")
  }

  /// Fetch Message
  ///
  /// Retrieves a message by its ID.
  ///
  /// `GET /channels/{target}/messages/{message_id}`
  ///
  /// - Parameters:
  ///   - target: Channel ID
  ///   - message: Message ID
  public func fetchMessage(_ target: String, _ message: String) async throws -> Message {
    return try await getReq(
      path: "channels/\(target)/messages/\(message)"
    )
  }

  // TODO: Implement messages
  /// Delete Message
  ///
  /// Delete a message you've sent or one you have permission to delete.
  ///
  /// `DELETE /channels/{target}/messages/{message_id}`
  public func deleteMessage() async throws {
    throw RevoltKitErrors.notImplemented("Not implemented yet")
  }

  // TODO: Implement messages
  /// Edit Message
  ///
  /// Edits a message that you've previously sent.
  ///
  /// `PATCH /channels/{target}/messages/{message_id}`
  public func editMessage() async throws {
    throw RevoltKitErrors.notImplemented("Not implemented yet")
  }

  // TODO: Implement messages
  /// Bulk Delete Messages
  ///
  /// Delete multiple messages you've sent or one you have permission to delete.
  /// This will always require `ManageMessages` permission regardless of whether you own the message or not.
  /// Messages must have been sent within the past 1 week.
  ///
  /// `DELETE /channels/{target}/messages/bulk`
  public func bulkDeleteMessages() async throws {
    throw RevoltKitErrors.notImplemented("Not implemented yet")
  }

  // INTERACTIONS

  /// Add Reaction to Message
  ///
  /// React to a given message.
  ///
  /// `PUT /channels/{target}/messages/{message_id}/reactions/{emoji}`
  ///
  /// - Parameters:
  ///   - target: Channel ID
  ///   - message: Message ID
  ///   - emoji: Emoji ID
  public func addReaction(_ target: String, _ message: String, _ emoji: String) async throws {
    return try await putReq(
      path: "channels/\(target)/messages/\(message)/reactions/\(emoji)"
    )
  }

  /// Remove Reaction(s) from Message
  ///
  /// Remove your own, someone else's or all of a given reaction.
  /// Requires `ManageMessages` if changing others' reactions.
  ///
  /// `DELETE /channels/{target}/messages/{message_id}/reactions/{emoji}`
  ///
  /// - Parameters:
  ///   - target: Channel ID
  ///   - message: Message ID
  ///   - emoji: Emoji ID
  ///   - user_id: Remove a specific user's reaction
  ///   - remove_all: Remove all reactions
  public func removeReaction(
    _ target: String,
    _ message: String,
    _ emoji: String,
    user_id: String? = nil,
    remove_all: Bool? = nil
  ) async throws {
    var query: [URLQueryItem] = []

    if user_id != nil {
      query.append(URLQueryItem(name: "user_id", value: user_id))
    }

    if remove_all != nil {
      query.append(URLQueryItem(name: "remove_all", value: "true"))
    }

    return try await deleteReq(
      path: "channels/\(target)/messages/\(message)/reactions/\(emoji)",
      query: query
    )
  }

  /// Remove All Reactions from Message
  ///
  /// Remove your own, someone else's or all of a given reaction.
  /// Requires `ManageMessages` permission.
  ///
  /// `DELETE /channels/{target}/messages/{message_id}/reactions`
  ///
  /// - Parameters:
  ///   - target: Channel ID
  ///   - message: Message ID
  public func removeAllReactions(_ target: String, _ message: String) async throws {
    try await deleteReq(
      path: "channels/\(target)/messages/\(message)/reactions"
    )
  }

  // GROUPS

  /// Fetch Group Members
  ///
  /// Retrieves all users who are part of this group.
  ///
  /// `GET /channels/{target}/members`
  ///
  /// - Parameters:
  ///   - target: Group ID
  public func fetchGroupMembers(_ target: String) async throws -> [User] {
    return try await getReq(
      path: "channels/\(target)/members"
    )
  }

  /// Create Group
  ///
  /// Create a new group channel.
  ///
  /// `POST /channels/create`
  public func createGroup<B: Encodable>(_ body: B) async throws -> Channel {
    return try await postReq(
      path: "channels/create",
      body: body
    )
  }

  /// Create Group
  ///
  /// Create a new group channel.
  ///
  /// `POST /channels/create`
  public func createGroup(
    _ name: String,
    _ description: String? = nil,
    _ users: [String],
    _ nsfw: Bool? = nil
  ) async throws -> Channel {
    return try await createGroup(
      CreateGroupPayload(
        name: name,
        description: description,
        users: users,
        nsfw: nsfw
      )
    )
  }

  /// Add Member to Group
  ///
  /// Adds another user to the group.
  ///
  /// `PUT /channels/{target}/recipients/{member}`
  ///
  /// - Parameters:
  ///   - target: Group ID
  ///   - member: User ID
  public func adddMemberToGroup(_ target: String, _ member: String) async throws {
    try await putReq(
      path: "channels/\(target)/recipients/\(member)"
    )
  }

  /// Remove Member from Group
  ///
  /// Removes a user from the group.
  ///
  /// `DELETE /channels/{target}/recipients/{member}`
  ///
  /// - Parameters:
  ///   - target: Group ID
  ///   - member: User ID
  public func removeMemberFromGroup(_ target: String, _ member: String) async throws {
    try await deleteReq(
      path: "channels/\(target)/recipients/\(member)"
    )
  }
}

public enum EditChannelRemove: String, Codable {
  case Description
  case Icon
  case DefaultPermissions
}

public struct EditChannelPayload: Codable {
  /// Channel name
  public let name: String?

  /// Channel description
  public let description: String?

  /// Group owner
  public let owner: String?

  /// Icon, provide an Autumn attachment ID
  public let icon: String?

  /// Whether this channel is age-restricted
  public let nsfw: Bool?

  /// Whether this channel is archived
  public let archived: Bool?

  public let remove: [EditChannelRemove]?
}

public struct CreateGroupPayload: Codable {
  /// Group name
  public let name: String

  /// Group description
  public let description: String?

  /// Array of user IDs to add to the group.
  /// Must be friends with these users.
  public let users: [String]

  /// Whether this group is age-restricted
  public let nsfw: Bool?
}

public struct FetchMessagesPayload: Codable {
  private enum CodingKeys: String, CodingKey {
    case limit
    case before
    case after
    case sort
    case nearby
    case includeUsers = "include_users"
  }

  /// Maximum numbers of messages to fetch/
  /// For fetching nearby messages, this is `(limit + 1)`.
  public let limit: Int64?

  /// Message ID before which messages should be fetched.
  public let before: String?

  /// Message ID after which messages should be fetched.
  public let after: String?

  /// Message sort direction.
  public let sort: MessageSortDirection?

  /// Message ID to search around.
  ///
  /// Specifying `nearby` ignores `before`, `after` and `sort`. It will also take half of limit rounded as the limits to each side. It also fetches the message ID specified.
  public let nearby: String?

  /// Indicates whether to include user (and member, if server channel) objects.
  public let includeUsers: Bool?
}

public enum MessageSortDirection: String, Codable {
  case Relevance
  case Latest
  case Oldest
}
