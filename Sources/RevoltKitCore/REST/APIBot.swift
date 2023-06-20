//
//  APIBot.swift
//  
//
//  Created by gulje on 20.06.2023.
//

import Foundation

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
    public let `public`: Bool?
    public let analytics: Bool?
    public let interactions_url: String?
    public let remove: [RemoveBotPayload]?
}

public extension RevoltREST {
    /// Create Bot
    ///
    /// Create a new Revolt bot.
    ///
    /// `POST /bots/create`
    ///
    /// - Parameter name: Bot username
    func createBot(_ name: String) async throws -> Bot {
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
    /// - Parameter bot: Bot ID
    func fetchPublicBot(_ bot: String) async throws -> Bot {
        return try await getReq(path: "bots/\(bot)/invite")
    }
    
    /// Invite Bot
    ///
    /// Invite a bot to a server.
    ///
    /// `POST /bots/{bot}/invite`
    ///
    /// - Parameter bot: Bot ID
    /// - Parameter server: Server ID
    func inviteBot(_ bot: String, server: String) async throws -> Bot {
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
    /// - Parameter bot: Bot ID
    /// - Parameter group: Group ID
    func inviteBot(_ bot: String, group: String) async throws -> Bot {
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
    /// - Parameter bot: Bot ID
    func fetchBot(_ bot: String) async throws -> (Bot, User) {
        let response: FetchBotResponse = try await getReq(path: "bots/\(bot)")
        
        return (response.bot, response.user)
    }
    
    /// Fetch Owned Bots
    ///
    /// Fetch all of the bots that you have control over.
    ///
    /// `GET /bots/@me`
    func fetchOwnedBots() async throws -> ([Bot], [User]) {
        let response: FetchBotsResponse = try await getReq(path: "/bots/@me")
        
        return (response.bots, response.users)
    }
    
    /// Delete Bot
    ///
    /// Delete a bot by its ID.
    ///
    /// `DELETE /bots/{bot}`
    ///
    /// - Parameter bot: Bot ID
    func deleteBot(_ bot: String) async throws {
        try await deleteReq(path: "/bots/\(bot)")
    }
    
    /// Edit Bot
    ///
    /// Edit bot details by its ID.
    ///
    /// `PATCH /bots/{bot}`
    func editBot<B: Encodable>(_ bot: String, body: B) async throws -> Bot {
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
    func editBot(
        _ bot: String,
        name: String?,
        public: Bool?,
        analytics: Bool?,
        interactions_url: String?,
        remove: [RemoveBotPayload]
    ) async throws -> Bot {
        return try await editBot(
            bot,
            body: EditBotPayload(
                name: name,
                public: `public`,
                analytics: analytics,
                interactions_url: interactions_url,
                remove: remove
            )
        )
    }
}
