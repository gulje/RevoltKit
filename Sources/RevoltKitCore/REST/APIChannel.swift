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
    /// - Parameter target: ID of the channel
    /// - Parameter leave_silently: Whether to not send a leave message
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
    /// Creates an ivnite to this channel.
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
