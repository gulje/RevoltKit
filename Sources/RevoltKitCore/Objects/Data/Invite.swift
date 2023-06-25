//
//  Invite.swift
//
//
//  Created by gulje on 25.06.2023.
//

import Foundation

public struct Invite: Codable {
  public let type: InviteType

  public let id: String

  /// Only available in server invites
  public let server: String

  public let creator: String

  public let channel: String

  private enum CodingKeys: String, CodingKey {
    case type
    case id = "_id"
    case server
    case creator
    case channel
  }
}

public enum InviteType: String, Codable {
  case server = "Server"
  case group = "Group"
}
