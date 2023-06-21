//
//  Bot.swift
//  
//
//  Created by gulje on 20.06.2023.
//

import Foundation

public struct Bot: Identifiable, Codable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case owner
        case token
        case isPublic = "public"
        case analytics
        case isDiscoverable = "discoverable"
        case interactionsURL = "interactions_url"
        case termsOfServiceURL = "terms_of_service_url"
        case privacyPolicyURL  = "privacy_policy_url"
        case flags
    }
    
    /// Bot ID, This equals the associated bot user's id
    public let id: String
    
    /// User ID of the bot owner
    public let owner: String
    
    /// Token used to authenticate requests for this bot
    public let token: String
    
    /// Whether the bot is public (may be invited by anyone)
    public let isPublic: Bool
    
    /// Whether to enable analytics
    public let analytics: Bool?
    
    /// Whether this bot should be publicly discoverable
    public let isDiscoverable: Bool?
    
    /// Reserved; URL for handling interactions
    public let interactionsURL: String?
    
    /// URL for terms of service
    public let termsOfServiceURL: String?
    
    /// URL for privacy policy
    public let privacyPolicyURL: String?
    
    /// Bot flags
    public let flags: UInt32?
}
