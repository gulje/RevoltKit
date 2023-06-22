//
//  APIBot.swift
//
//
//  Created by gulje on 20.06.2023.
//

import Foundation

extension RevoltREST {
  /// Create Bot
  ///
  /// Create a new Revolt bot.
  ///
  /// `POST /bots/create`
  ///
  /// - Parameters:
  ///   - name: The username of the bot.
  /// - Returns: The created bot instance.
  public func createBot(_ name: String) async throws -> Bot {
    return try await postReq(
      path: "bots/create",
      body: CreateBotPayload(name: name)
    )
  }

  /// Fetch Public Bot
  ///
  /// Fetch details of a public (or owned) bot by its ID.
  ///
  /// `GET /bots/{bot}/invite`
  ///
  /// - Parameters:
  ///   - bot: The ID of the bot.
  /// - Returns: The fetched bot instance.
  public func fetchPublicBot(_ bot: String) async throws -> Bot {
    return try await getReq(path: "bots/\(bot)/invite")
  }

  /// Invite Bot
  ///
  /// Invite a bot to a server.
  ///
  /// `POST /bots/{bot}/invite`
  ///
  /// - Parameters:
  ///   - bot: The ID of the bot.
  ///   - server: The ID of the server.
  /// - Returns: The invited bot instance.
  public func inviteBot(_ bot: String, server: String) async throws -> Bot {
    return try await postReq(
      path: "bots/\(bot)/invite",
      body: InviteBotServerPayload(server: server)
    )
  }

  /// Invite Bot
  ///
  /// Invite a bot to a group.
  ///
  /// `POST /bots/{bot}/invite`
  ///
  /// - Parameters:
  ///   - bot: The ID of the bot.
  ///   - group: The ID of the group.
  /// - Returns: The invited bot instance.
  public func inviteBot(_ bot: String, group: String) async throws -> Bot {
    return try await postReq(
      path: "bots/\(bot)/invite",
      body: InviteBotGroupPayload(group: group)
    )
  }

  /// Fetch Bot
  ///
  /// Fetch details of a bot you own by its id.
  ///
  /// `GET /bots/{bot}`
  ///
  /// - Parameters:
  ///   - bot: The ID of the bot.
  /// - Returns: A tuple containing the bot instance and the user instance associated with the bot.
  public func fetchBot(_ bot: String) async throws -> (Bot, User) {
    let response: FetchBotResponse = try await getReq(path: "bots/\(bot)")

    return (response.bot, response.user)
  }

  /// Fetch Owned Bots
  ///
  /// Fetch all of the bots that you have control over.
  ///
  /// `GET /bots/@me`
  ///
  /// - Returns: A tuple containing an array of bot instances and an array of user instances associated with the bots.
  public func fetchOwnedBots() async throws -> ([Bot], [User]) {
    let response: FetchBotsResponse = try await getReq(path: "/bots/@me")

    return (response.bots, response.users)
  }

  /// Delete Bot
  ///
  /// Delete a bot by its ID.
  ///
  /// `DELETE /bots/{bot}`
  ///
  /// - Parameters:
  ///   - bot: The ID of the bot.
  /// - Throws: An error if the request fails.
  public func deleteBot(_ bot: String) async throws {
    try await deleteReq(path: "/bots/\(bot)")
  }

  /// Edit Bot
  ///
  /// Edit bot details by its ID.
  ///
  /// `PATCH /bots/{bot}`
  ///
  /// - Parameters:
  ///   - bot: The ID of the bot.
  ///   - body: The payload containing the updated bot details.
  /// - Returns: The edited bot instance.
  public func editBot<B: Encodable>(_ bot: String, body: B) async throws -> Bot {
    return try await patchReq(
      path: "/bots/\(bot)",
      body: body
    )
  }

  /// Edit Bot
  ///
  /// Edit bot details by its ID.
  ///
  /// `PATCH /bots/{bot}`
  ///
  /// - Parameters:
  ///   - bot: The ID of the bot.
  ///   - name: The new name for the bot (optional).
  ///   - isPublic: The new visibility status for the bot (optional).
  ///   - analytics: The new analytics status for the bot (optional).
  ///   - interactionsURL: The new interactions URL for the bot (optional).
  ///   - remove: The list of bot components to remove (optional).
  /// - Returns: The edited bot instance.
  public func editBot(
    _ bot: String,
    name: String?,
    isPublic: Bool?,
    analytics: Bool?,
    interactionsURL: String?,
    remove: [RemoveBotPayload]
  ) async throws -> Bot {
    return try await editBot(
      bot,
      body: EditBotPayload(
        name: name,
        isPublic: isPublic,
        analytics: analytics,
        interactionsURL: interactionsURL,
        remove: remove
      )
    )
  }
}

public struct FetchBotResponse: Codable {
  public let bot: Bot
  public let user: User
}

public struct FetchBotsResponse: Codable {
  public let bots: [Bot]
  public let users: [User]
}

public struct CreateBotPayload: Codable {
  public let name: String
}

public struct InviteBotServerPayload: Codable {
  public let server: String
}

public struct InviteBotGroupPayload: Codable {
  public let group: String
}

public enum RemoveBotPayload: String, Codable {
  case Token
  case InteractionsURL
}

public struct EditBotPayload: Codable {
  public let name: String?
  public let isPublic: Bool?
  public let analytics: Bool?
  public let interactionsURL: String?
  public let remove: [RemoveBotPayload]?

  private enum CodingKeys: String, CodingKey {
    case name
    case isPublic = "public"
    case analytics
    case interactionsURL = "interactions_url"
    case remove
  }
}
