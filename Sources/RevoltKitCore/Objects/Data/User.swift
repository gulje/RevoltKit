//
//  User.swift
//  
//
//  Created by gulje on 19.06.2023.
//

import Foundation

public enum Presence: String, Codable {
    case Online
    case Idle
    case Focus
    case Busy
    case Invisible
}

public enum Relationship: String, Codable {
    case None
    case User
    case Friend
    case Outgoing
    case Incoming
    case Blocked
    case BlockedOther
}

public struct Profile: Codable {
    
    public let content: String?
    
    public let background: File?
}

public struct Status: Codable {
    public let text: String?
    
    public let presence: Presence?
}

public struct Relations: Codable {
    private var _id: String
    public var id: String {
        get { return _id }
    }
    
    public let status: Relationship
}

public struct IsBot: Codable {
    public let owner: String
}

public struct User: Equatable, Codable {
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case username
        case discriminator
        case display_name
        case avatar
        case badges
        case status
        case profile
        case flags
        case privileged
        case bot
        case relationship
        case online
        case relations
    }

    public static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    public let id: String
    
    /// Username of the user
    public let username: String
    
    /// Discriminator of the user
    public let discriminator: String
    
    /// Display name of user
    public let display_name: String?
    
    /// Representation of a File on Revolt generated by Autumn (CDN)
    public let avatar: File?
    
    /// Bitfield of user badges
    public let badges: Int32?
    
    /// User's active status
    public let status: Status?
    
    /// User's profile
    public let profile: Profile?
    
    /// User flags
    public let flags: Int32?
    
    /// Whether this user is privileged
    public let privileged: Bool?
    
    /// Bot information for if the user is a bot
    public let bot: IsBot?
    
    /// User's relationship with another user (or themselves)
    public let relationship: Relationship?
    
    /// Whether the user is currently online
    public let online: Bool?
    
    public let relations: [Relationship]?
}
