//
//  APIRequest.swift
//  
//
//  Created by gulje on 19.06.2023.
//

import Foundation

public extension RevoltREST {
    enum InternalRestError: Error {
        case invalidResponse
        case jsonDecodingError(error: Error)
        case unexpectedResponseCode(_ code: Int)
    }
    
    enum APIError: Error {
        case tooMany(type: String, max: UInt)
        case missingPermission(_ permission: Permission)
        case missingUserPermission(_ permission: Permission)
        case error(_ type: String)
        case unauthorized
    }
    
    enum RequestMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case patch = "PATCH"
    }
    
    /// Low level method for Revolt API requests
    func makeRequest(
        path: String,
        query: [URLQueryItem] = [],
        attachments: [URL] = [],
        body: Data? = nil,
        method: RequestMethod = .get
    ) async throws -> Data {
        assert(token != nil, "Token should not be nil.")
        let token = token!
        
        Self.log.trace("Making request", metadata: [
            "method": "\(method)",
            "path": "\(path)"
        ])
        
        let apiURL = RevoltKitConfig.default.restBase.appendingPathComponent(path, isDirectory: false)
        
        var urlBuilder = URLComponents(url: apiURL, resolvingAgainstBaseURL: true)!
        urlBuilder.queryItems = query
        let reqURL = urlBuilder.url!
        
        var req = URLRequest(url: reqURL)
        req.httpMethod = method.rawValue
        
        req.setValue(token, forHTTPHeaderField: RevoltKitConfig.default.isBot ? "x-bot-token" : "x-session-token")
        
        if body != nil {
            req.httpBody = body
        }
        
        guard let (data, response) = try? await RevoltREST.session.data(for: req),
              let httpResponse = response as? HTTPURLResponse else {
            throw InternalRestError.invalidResponse
        }
        
        guard httpResponse.statusCode / 100 == 2 else {
            Self.log.error("Response status code is not 2xx", metadata: [
                "res.statusCode": "\(httpResponse.statusCode)"
            ])
            Self.log.debug("Raw response: \(String(decoding: data, as: UTF8.self))")
            
            if httpResponse.statusCode == 401 {
                throw APIError.unauthorized
            }
            
            var error: RestError
            
            do {
                error = try RevoltREST.decoder.decode(RestError.self, from: data)
            } catch {
                throw InternalRestError.jsonDecodingError(error: error)
            }
            
            try handleError(error)
            
            throw InternalRestError.invalidResponse
        }
        
        return data
    }
    
    /// Make a `GET` request to the Revolt REST API
    func getReq<T: Decodable>(
        path: String,
        query: [URLQueryItem] = []
    ) async throws -> T {
        let respData = try await makeRequest(path: path, query: query)
        do {
            return try RevoltREST.decoder.decode(T.self, from: respData)
        } catch {
            throw InternalRestError.jsonDecodingError(error: error)
        }
    }
    
    /// Make a `POST` request to the Revolt REST API
    func postReq<D: Decodable, B: Encodable>(
        path: String,
        body: B? = nil,
        attachments: [URL] = []
    ) async throws -> D {
        let payload = body != nil ? try RevoltREST.encoder.encode(body) : nil
        
        let respData = try await makeRequest(
            path: path,
            attachments: attachments,
            body: payload,
            method: .post
        )
        
        do {
            return try RevoltREST.decoder.decode(D.self, from: respData)
        } catch {
            throw InternalRestError.jsonDecodingError(error: error)
        }
    }
    
    /// Make a `PUT` request to the Revolt REST API
    func putReq<B: Encodable, Response: Decodable>(
        path: String,
        body: B
    ) async throws -> Response {
        let payload = try RevoltREST.encoder.encode(body)
        let data = try await makeRequest(
            path: path,
            body: payload,
            method: .put
        )
        
        do {
            return try RevoltREST.decoder.decode(Response.self, from: data)
        } catch {
            throw InternalRestError.jsonDecodingError(error: error)
        }
    }
    
    /// Make a `PUT` request to the Revolt REST API
    func putReq<Response: Decodable>(path: String) async throws -> Response {
        let data = try await makeRequest(
            path: path,
            method: .put
        )
        
        do {
            return try RevoltREST.decoder.decode(Response.self, from: data)
        } catch {
            throw InternalRestError.jsonDecodingError(error: error)
        }
    }
    
    /// Make a `PUT` request to the Revolt REST API wthout Response
    func putReq(path: String) async throws {
        _ = try await makeRequest(path: path, method: .put)
    }
    
    /// Make a `DELETE` request to the Revolt REST API
    func deleteReq(path: String) async throws {
        _ = try await makeRequest(path: path, method: .delete)
    }
    
    func deleteReq(path: String, query: [URLQueryItem] = []) async throws {
        _ = try await makeRequest(path: path, query: query, method: .delete)
    }
    
    /// Make a `PATCH` request to the Revolt REST API
    func patchReq<B: Encodable, Response: Decodable>(
        path: String,
        body: B
    ) async throws -> Response {
        let payload: Data?
        payload = try? RevoltREST.encoder.encode(body)
        let data = try await makeRequest(
            path: path,
            body: payload,
            method: .patch
        )
        
        do {
            return try RevoltREST.decoder.decode(Response.self, from: data)
        } catch {
            throw InternalRestError.jsonDecodingError(error: error)
        }
    }
    
    func handleError(
        _ err: RestError
    ) throws {
        if err.type.contains("TooMany") || err.type == "GroupTooLarge" {
            throw APIError.tooMany(type: err.type, max: err.max!)
        } else if err.type == "MissingPermission" {
            throw APIError.missingPermission(err.permission!)
        } else if err.type == "MissingUserPermission" {
            throw APIError.missingUserPermission(err.permission!)
        } else {
            throw APIError.error(err.type)
        }
    }
}

public struct RestError: Codable {
    public let type: String
    
    /// Present in error types with `TooMany` in the name
    /// Or specifically `GroupTooLarge`
    public let max: UInt?
    
    /// Present in `MissingPermission` or`MissingUserPermission`
    public let permission: Permission?
}

public enum Permission: String, Codable {
    case ManageChannel
    case ManageServer
    case ManagePermissions
    case ManageRole
    case ManageCustomisation
    case KickMembers
    case BanMembers
    case TimeoutMembers
    case AssignRoles
    case ChangeNickname
    case ManageNicknames
    case ChangeAvatar
    case RemoveAvatars
    case ViewChannel
    case ReadMessageHistory
    case SendMessage
    case ManageMessages
    case ManageWebhooks
    case InviteOthers
    case SendEmbeds
    case UploadFiles
    case Masquerade
    case React
    case Connect
    case Speak
    case Video
    case MuteMembers
    case DeafenMembers
    case MoveMembers
    case GrantAllSafe
    case GrantAll
    case Access
    case ViewProfile
    case Invite
}
