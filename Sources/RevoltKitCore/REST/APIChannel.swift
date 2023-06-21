//
//  APIChannel.swift
//  
//
//  Created by gulje on 20.06.2023.
//

import Foundation

public extension RevoltREST {
    // CHANNEL INFORMATION
    
    /// Fetch Channel
    ///
    /// Fetch channel by its ID.
    ///
    /// `GET /channels/{target}`
    ///
    /// - Parameter target: ID of the channel
    func fetchChannel(_ target: String) async throws -> Channel {
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
    func closeChannel(_ target: String, leave_silently: Bool = false) async throws {
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
    func editChannel<B: Encodable>(_ target: String, _ body: B) async throws -> Channel {
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
    func editChannel(
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
    func createInvite() async throws {
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
    func setRolePermission() async throws {
        throw RevoltKitErrors.notImplemented("Not implemented yet")
    }
    
    // TODO: Implement permissions
    /// Set Default Permission
    ///
    /// Sets permissions for the default role in this channel.
    /// Channel must be a `Group`, `TextChannel` or `VoiceChannel`.
    ///
    /// `PUT /channels/{target}/permissions/default`
    func setDefaultPermission() async throws {
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
    func acknowledgeMessage(_ target: String, _ message: String) async throws {
        try await putReq(
            path: "channels/\(target)/ack/\(message)"
        )
    }
    
    // TODO: Implement messages
    /// Fetch Messages
    ///
    /// Fetch multiple messages.
    ///
    /// `GET /channels/{target}/messages`
    func fetchMessages() async throws {
        throw RevoltKitErrors.notImplemented("Not implemented yet")
    }
    
    // TODO: Implement messages
    /// Send Message
    ///
    /// Sends a message to the given channel.
    ///
    /// `POST /channels/{target}/messages`
    func sendMessage() async throws {
        throw RevoltKitErrors.notImplemented("Not implemented yet")
    }
    
    // TODO: Implement messages
    /// Search for Messages
    ///
    /// This route searches for messages within the given parameters.
    ///
    /// `POST /channels/{target}/search`
    func searchMessages() async throws {
        throw RevoltKitErrors.notImplemented("Not implemented yet")
    }
    
    // TODO: Implement messages
    /// Fetch Message
    ///
    /// Retrieves a message by its ID.
    ///
    /// `GET /channels/{target}/messages/{message_id}`
    func fetchMessage() async throws {
        throw RevoltKitErrors.notImplemented("Not implemented yet")
    }
    
    // TODO: Implement messages
    /// Delete Message
    ///
    /// Delete a message you've sent or one you have permission to delete.
    ///
    /// `DELETE /channels/{target}/messages/{message_id}`
    func deleteMessage() async throws {
        throw RevoltKitErrors.notImplemented("Not implemented yet")
    }
    
    // TODO: Implement messages
    /// Edit Message
    ///
    /// Edits a message that you've previously sent.
    ///
    /// `PATCH /channels/{target}/messages/{message_id}`
    func editMessage() async throws {
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
    func bulkDeleteMessages() async throws {
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
    func addReaction(_ target: String, _ message: String, _ emoji: String) async throws {
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
    func removeReaction(
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
    func removeAllReactions(_ target: String, _ message: String) async throws {
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
    func fetchGroupMembers(_ target: String) async throws -> [User] {
        return try await getReq(
            path: "channels/\(target)/members"
        )
    }
    
    /// Create Group
    ///
    /// Create a new group channel.
    ///
    /// `POST /channels/create`
    func createGroup<B: Encodable>(_ body: B) async throws -> Channel {
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
    func createGroup(
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
    func adddMemberToGroup(_ target: String, _ member: String) async throws {
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
    func removeMemberFromGroup(_ target: String, _ member: String) async throws {
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
