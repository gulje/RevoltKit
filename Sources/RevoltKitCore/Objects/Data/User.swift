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

public struct IsBot: Codable {
    public let owner: String
}

public struct User: Identifiable, Equatable, Codable {
    private var _id: String
    public var id: String {
        set {}
        get { return _id }
    }
    
    public static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    public init(
        _id: String,
        username: String,
        discriminator: String,
        display_name: String?,
        avatar: File?,
        badges: Int32?,
        status: Status?,
        profile: Profile?,
        flags: Int32?,
        privileged: Bool?,
        bot: IsBot?,
        relationship: Relationship?,
        online: Bool?,
        relations: [Relationship]
    ) {
        self._id = _id
        self.username = username
        self.discriminator = discriminator
        self.display_name = display_name
        self.avatar = avatar
        self.badges = badges
        self.status = status
        self.profile = profile
        self.flags = flags
        self.relations = relations
        self.privileged = privileged
        self.bot = bot
        self.relationship = relationship
        self.online = online
    }
    
    public let username: String
    
    public let discriminator: String
    
    public let display_name: String?
    
    public let avatar: File?
    
    public let badges: Int32?
    
    public let status: Status?
    
    public let profile: Profile?
    
    public let flags: Int32?
    
    public let privileged: Bool?
    
    public let bot: IsBot?
    
    public let relationship: Relationship?
    
    public let online: Bool?
    
    public let relations: [Relationship]?
}
