//
//  Bot.swift
//
//
//  Created by gulje on 20.06.2023.
//

import Foundation

/// Represents a bot within the Revolt.
public struct Bot: Identifiable, Codable, Equatable {
  /// The unique identifier of the bot. This identifier is equal to associated bot user's ID.
  public let id: String

  /// The user ID of the bot owner. This ID corresponds to the user who created and manges the bot.
  public let owner: String

  /// The token used to authenticate requests for this bot.
  public let token: String

  /// Indicates whether the bot is public and can be invited by anyone.
  public let isPublic: Bool

  /// Indicates whether the analytics enabled for this bot.
  public let analytics: Bool?

  /// Indicates whether this bot should be publicly discoverable.
  public let isDiscoverable: Bool?

  /// The reserved URL for handling interactions with the bot.
  public let interactionsURL: String?

  /// The URL for the terms of service associated with the bot. This URL provides information about the legal terms and conditions that apply to the bot's usage.
  public let termsOfServiceURL: String?

  /// The URL for the privacy policy associated with the bot. This URL outlines the privacy practices and policies governing the bot's data handling and user interactions.
  public let privacyPolicyURL: String?

  /// Additional flags associated with the bot.
  public let flags: UInt32?

  private enum CodingKeys: String, CodingKey {
    case id = "_id"
    case owner
    case token
    case isPublic = "public"
    case analytics
    case isDiscoverable = "discoverable"
    case interactionsURL = "interactions_url"
    case termsOfServiceURL = "terms_of_service_url"
    case privacyPolicyURL = "privacy_policy_url"
    case flags
  }
}
