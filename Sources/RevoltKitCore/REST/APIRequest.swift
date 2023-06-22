//
//  APIRequest.swift
//
//
//  Created by gulje on 19.06.2023.
//

import Foundation

extension RevoltREST {
  public enum InternalRestError: Error {
    case invalidResponse
    case jsonDecodingError(error: Error)
    case unexpectedResponseCode(_ code: Int)
  }

  public enum APIError: Error {
    case tooMany(type: String, max: UInt)
    case missingPermission(_ permission: Permission)
    case missingUserPermission(_ permission: Permission)
    case error(_ type: String)
    case unauthorized
  }

  public enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
  }

  /**
     This function is used to send requests to the Revolt API. It takes several parameters:

     - Parameters:
       - path: The endpoint path of the API request.
       - query: An optional array of URL query items.
       - attachments: An optional array of URL attachments.
       - body: The request body data, if applicable.
       - method: The HTTP request method (default is .get).

     The method performs the following steps:

     1. Checks if the authentication token is not `nil`. If it is `nil`, an assertion failure is triggered.
     2. Constructs the API URL by appending the provided `path` to the base URL.
     3. Builds the request URL by adding the `query` items to the URL components.
     4. Creates an instance of `URLRequest` using the request URL and sets the HTTP method.
     5. Sets the appropriate session token header based on whether the client is a bot or a user.
     6. If a request `body` is provided (`body` is not `nil`), sets it as the request's HTTP body.
     7. Sends the request using the `RevoltREST.session.data(for:)` method, which performs the actual network request.
     8. Checks the response received from the API. If the response is not a successful HTTP response (status code not in the 2xx range), an error is thrown.
     9. If the response status code is 401 (Unauthorized), throws an `APIError.unauthorized` error.
     10. If the response status code is not 401, attempts to decode the response data into a `RestError` object using the `RevoltREST.decoder`.
     11. If there is an error during JSON decoding, throws an `InternalRestError.jsonDecodingError`.
     12. Calls `handleError()` to handle specific errors based on the `RestError` object.
     13. If none of the specific error cases match or an error occurs during error handling, throws an `InternalRestError.invalidResponse`.

     - Returns: The response data from the API as Data in an asynchronous manner.
     */
  public func makeRequest(
    path: String,
    query: [URLQueryItem] = [],
    attachments: [URL] = [],
    body: Data? = nil,
    method: RequestMethod = .get
  ) async throws -> Data {
    assert(token != nil, "Token should not be nil.")
    let token = token!

    Self.log.trace(
      "Making request",
      metadata: [
        "method": "\(method)",
        "path": "\(path)",
      ])

    let apiURL = RevoltKitConfig.default.restBase.appendingPathComponent(path, isDirectory: false)

    var urlBuilder = URLComponents(url: apiURL, resolvingAgainstBaseURL: true)!
    urlBuilder.queryItems = query
    let reqURL = urlBuilder.url!

    var req = URLRequest(url: reqURL)
    req.httpMethod = method.rawValue

    req.setValue(
      token, forHTTPHeaderField: RevoltKitConfig.default.isBot ? "x-bot-token" : "x-session-token")

    if body != nil {
      req.httpBody = body
    }

    guard let (data, response) = try? await RevoltREST.session.data(for: req),
      let httpResponse = response as? HTTPURLResponse
    else {
      throw InternalRestError.invalidResponse
    }

    guard httpResponse.statusCode / 100 == 2 else {
      Self.log.error(
        "Response status code is not 2xx",
        metadata: [
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

  /// Perform a `GET` request to the specified `path`with specified `query` parameter in the Revolt REST API.
  public func getReq<T: Decodable>(
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

  /// Perform a `POST` request to the specified `path` with `attachments` and `body` in the Revolt REST API.
  public func postReq<D: Decodable, B: Encodable>(
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

  /// Perform a `PUT` request to the specified `path` with a request body of type `B` that conforms to the `Encodable` protocol.
  public func putReq<B: Encodable, Response: Decodable>(
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

  /// Perform a `PUT` request to the specified `path` without a request body.
  public func putReq<Response: Decodable>(path: String) async throws -> Response {
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

  /// Perform a `PUT` request to the specified `path` without a request body and without expecting a response.
  public func putReq(path: String) async throws {
    _ = try await makeRequest(path: path, method: .put)
  }

  /// Perform a `DELETE` request to the specified path without any query parameters.
  public func deleteReq(path: String) async throws {
    _ = try await makeRequest(path: path, method: .delete)
  }

  /// Perform a `DELETE` request to the specified `path` with the given `query` parameters.
  public func deleteReq(path: String, query: [URLQueryItem] = []) async throws {
    _ = try await makeRequest(path: path, query: query, method: .delete)
  }

  /// Make a `PATCH` request to the Revolt REST API
  public func patchReq<B: Encodable, Response: Decodable>(
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

  /// This function allows for specific handling of different types of errors returned by the Revolt API.
  /// It translates the received `RestError` into custom error types (`APIError`) that can be caught and handled separately by the caller of the API request.
  public func handleError(
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
