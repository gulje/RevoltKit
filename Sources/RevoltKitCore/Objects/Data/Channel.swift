//
//  Channel.swift
//
//
//  Created by gulje on 20.06.2023.
//

import Foundation

public enum ChannelType: String, Codable {
  case savedMessages = "SavedMessages"
  case directMessage = "DirectMessage"
  case group = "Group"
  case textChannel = "TextChannel"
  case voiceChannel = "VoiceChannel"
}

public struct PermissionTable: Codable {
  public let a: UInt64
  public let d: UInt64
}

/// Represents a Channel.
public struct Channel: Codable, Equatable {
  /// The unique identifier of the channel. This ID is present at all times and serves as a unique identifier for the channel.
  public let id: String

  /// The type of the channel, indicating its category or purpose. This field is present at all times.
  public let type: ChannelType

  /// The ID of the user to whom the channel belongs. This field is present in channels of type `SavedMessages`.
  public let user: String?

  /// Indicates whether this direct message channel is currently open on both sides. This field is present in channels of type `DirectMessage`.
  public let isActive: Bool?

  /// The permissions assigned to members of this group (excluding the owner of the group). This field is present in channels of type `Group`.
  public let permissions: UInt64?

  /// The user ID of the owner of the group. This field is present in channels of type `Group`.
  public let owner: String?

  ///  An array of user IDs representing the participants in the channel. This field is present in channels of type `DirectMessage` and `Group`.
  public let recipients: [String]?

  /// Represents a single permission override as it appears on models and in the database. This field is present in channels of type `TextChannel` and `VoiceChannel`.
  public let defaultPermissions: [PermissionTable]?

  /// Permissions assigned to this channel based on roles. This field is present in channels of type `TextChannel` and `VoiceChannel`.
  public let rolePermissions: [String: PermissionTable]?

  /// The ID of the server to which this channel belongs. This field is present in channels of type `TextChannel` and `VoiceChannel`.
  public let server: String?

  /// The ID of the last message sent in this channel. This field is present in channels of type `Group`, `TextChannel`, and `DirectMessage`.
  public let lastMessageID: String?

  /// Represents a file on Revolt generated by Autumn. This field is present in channels of type `Group`, `TextChannel`, and `VoiceChannel`.
  public let icon: File?

  /// The description of the channel. This field is present in channels of type `Group`, `TextChannel`, and `VoiceChannel`.
  public let description: String?

  /// The display name of the channel. This field is present in channels of type `Group`, `TextChannel`, and `VoiceChannel`.
  public let name: String?

  /// Indicates whether this channel is marked as not safe for work (NSFW).
  public let isNSFW: Bool?

  private enum CodingKeys: String, CodingKey {
    // Present all the time
    case type = "channel_type"
    case id = "_id"

    // Present in SavedMessages
    case user

    // Present in DirectMessage
    case isActive = "active"

    // Present in Group
    case permissions
    case owner

    // Present in DirectMessage and Group
    case recipients

    // Present in TextChannel and VoiceChannel
    case defaultPermissions = "default_permissions"
    case rolePermissions = "role_permissions"
    case server

    // Present in DirectMessage, Group and TextChannel
    case lastMessageID = "lastMessageID"

    // Present in Group, TextChannel and VoiceChannel
    case icon
    case description
    case isNSFW = "nsfw"
    case name
  }

  /// Compares two `Channel` instances for equality.
  public static func == (lhs: Channel, rhs: Channel) -> Bool {
    lhs.id == rhs.id
  }
}
