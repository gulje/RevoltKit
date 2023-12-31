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
  public func closeChannel(_ target: String, leaveSilently: Bool = false) async throws {
    return try await deleteReq(
      path: "channels/\(target)",
      query: leaveSilently ? [URLQueryItem(name: "leave_silently", value: "true")] : []
    )
  }

  /// Edit Channel
  ///
  /// Edit a channel by its ID.
  ///
  /// `PATCH /channels/{channel}`
  public func editChannel(
    _ channel: String,
    name: String? = nil,
    description: String? = nil,
    owner: String? = nil,
    icon: String? = nil,
    nsfw: Bool? = nil,
    archived: Bool? = nil,
    remove: [EditChannelRemove]? = []
  ) async throws -> Channel {
    return try await patchReq(
      path: "channels/\(channel)",
      body: EditChannelPayload(
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

  /// Create Invite
  ///
  /// Creates an invite to this channel.
  /// Channel must be a `TextChannel`.
  ///
  /// `POST /channels/{target}/invites`
  ///
  /// - Parameters:
  ///   - target: Channel or group ID
  public func createInvite(_ target: String) async throws -> Invite {
    return try await postReq(
      path: "channels/\(target)/invites"
    )
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

  /// Fetches multiple messages from a channel.
  ///
  /// Fetches multiple messages from the specified channel ID.
  ///
  /// - Parameters:
  ///   - target: The ID of the channel to fetch messages from.
  ///   - limit: The maximum number of messages to fetch. (Optional)
  ///   - before: Fetch messages created before this message. (Optional)
  ///   - after: Fetch messages created after this message. (Optional)
  ///   - sort: The sorting direction for the fetched messages. (Optional)
  ///   - nearby: Fetch messages near the specified message ID. (Optional)
  ///   - includeUsers: Determines whether to include user information in the response. (Default: `false`)
  /// - Returns: A `FetchMessagesResponse` enum value representing the result of the API request.
  public func fetchMessages(
    _ target: String,
    limit: Int64? = nil,
    before: String? = nil,
    after: String? = nil,
    sort: MessageSortDirection? = nil,
    nearby: String? = nil,
    includeUsers: Bool = false
  ) async throws -> FetchMessagesResponse {
    var query = try buildQueryFromCodable(
      FetchMessagesPayload(
        limit: limit,
        before: before,
        after: after,
        sort: sort,
        nearby: nearby,
        includeUsers: nil
      )
    )

    if includeUsers {
      query.append(URLQueryItem(name: "include_users", value: "true"))

      let response: FetchMessagesWithUsers = try await getReq(
        path: "channels/\(target)/messages",
        query: query
      )

      return .withUsers(response)
    } else {
      let response: [Message] = try await getReq(
        path: "channels/\(target)/messages",
        query: query
      )

      return .onlyMessages(response)
    }
  }

  /// Send Message
  ///
  /// Sends a message to the given channel.
  ///
  /// `POST /channels/{target}/messages`
  ///
  /// - Parameters:
  ///   - target: The target channel to send the message to.
  ///   - nonce: An optional nonce value for message identification.
  ///   - content: The content of the message as a string.
  ///   - attachments: An optional array of attachment URLs to include in the message.
  ///   - replies: An optional array of reply objects to associate with the message.
  ///   - embeds: An optional array of embed objects to include in the message.
  ///   - masquerade: An optional masquerade object to send the message on behalf of another user.
  ///   - interactions: An optional interactions object to specify interaction options for the message.
  public func sendMessage(
    _ target: String,
    nonce: String? = nil,
    content: String? = nil,
    attachments: [String]? = nil,
    replies: [Reply]? = nil,
    embeds: [Embed]? = nil,
    masquerade: Masquerade? = nil,
    interactions: Interactions? = nil
  ) async throws -> Message {
    return try await postReq(
      path: "channels/\(target)/messages",
      body: SendMessagePayload(
        nonce: nonce,
        content: content,
        attachments: attachments,
        replies: replies,
        embeds: embeds,
        masquerade: masquerade,
        interactions: interactions
      )
    )
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

  /// Delete Message
  ///
  /// Delete a message you've sent or one you have permission to delete.
  ///
  /// `DELETE /channels/{target}/messages/{message_id}`
  ///
  /// - Parameters:
  ///   - target: Channel ID
  ///   - message: Message ID
  public func deleteMessage(_ target: String, _ message: String) async throws {
    try await deleteReq(
      path: "channels/\(target)/messages/\(message)"
    )
  }

  /// Edit Message
  ///
  /// Edits a message that you've previously sent.
  ///
  /// `PATCH /channels/{target}/messages/{message_id}`
  ///
  /// - Parameters:
  ///   - target: Channel ID
  ///   - message: Message ID
  ///   - content: New message content
  ///   - embeds: Embeds to include in the message
  public func editMessage(
    _ target: String,
    _ message: String,
    content: String? = nil,
    embeds: [SendableEmbed]
  ) async throws -> Message {
    return try await patchReq(
      path: "channels/\(target)/messages/\(message)",
      body: EditMessagePayload(
        content: content, embeds: embeds
      )
    )
  }

  /// Bulk Delete Messages
  ///
  /// Delete multiple messages you've sent or one you have permission to delete.
  /// This will always require `ManageMessages` permission regardless of whether you own the message or not.
  /// Messages must have been sent within the past 1 week.
  ///
  /// `DELETE /channels/{target}/messages/bulk`
  ///
  /// - Parameters:
  ///   - target: Channel ID
  ///   - ids: Array of message IDs
  public func bulkDeleteMessages(
    _ target: String,
    _ ids: [String]
  ) async throws {
    try await deleteReq(
      path: "channels/\(target)/messages/bulk", body: BulkDeleteMessagesPayload(ids: ids))
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
  ///   - user: Remove a specific user's reaction
  ///   - remove_all: Remove all reactions
  public func removeReaction(
    _ target: String,
    _ message: String,
    _ emoji: String,
    user: String? = nil,
    removeAll: Bool? = nil
  ) async throws {
    var query: [URLQueryItem] = []

    if user != nil && !(user!.isEmpty) {
      query.append(URLQueryItem(name: "user_id", value: user))
    }

    if removeAll != nil && removeAll! {
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
  public func createGroup(
    _ name: String,
    users: [String],
    description: String? = nil,
    nsfw: Bool? = nil
  ) async throws -> Channel {
    return try await postReq(
      path: "channels/create",
      body: CreateGroupPayload(
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
  case description = "Description"
  case icon = "Icon"
  case defaultPermissions = "DefaultPermissions"
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
  case relevance = "Relevance"
  case latest = "Latest"
  case oldest = "Oldest"
}

public enum FetchMessagesResponse: Codable {
  case onlyMessages([Message])
  case withUsers(FetchMessagesWithUsers)
}

public struct FetchMessagesWithUsers: Codable {
  /// List of messages
  public let messages: [Message]

  /// List of users
  public let users: [User]

  /// List of members
  public let members: [Member]?
}

public struct SendMessagePayload: Codable {
  /// Unique token to prevent duplicate message sending (deprecated)
  public let nonce: String?

  /// Message content to send
  public let content: String?

  /// Attachments to include in message
  public let attachments: [String]?

  /// Messages to reply to
  public let replies: [Reply]?

  public let embeds: [Embed]?

  public let masquerade: Masquerade?

  public let interactions: Interactions?
}

public struct Reply: Codable {
  public let id: String

  public let mention: Bool

  public init(id: String, mention: Bool = false) {
    self.id = id
    self.mention = mention
  }
}

public struct EditMessagePayload: Codable {
  public let content: String?

  public let embeds: [SendableEmbed]?
}

public struct BulkDeleteMessagesPayload: Codable {
  public let ids: [String]
}
