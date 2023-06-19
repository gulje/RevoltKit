//
//  APIRequest.swift
//  
//
//  Created by gulje on 19.06.2023.
//

import Foundation

public extension RevoltREST {
    enum RequestError: Error {
        case invalidResponse
        case jsonDecodingError(error: Error)
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
        
        // TODO: Support for session tokens
        req.setValue(token, forHTTPHeaderField: "x-bot-token")
        
        if body != nil {
            req.httpBody = body
        }
        
        guard let (data, response) = try? await RevoltREST.session.data(for: req),
              let _ = response as? HTTPURLResponse else {
            throw RequestError.invalidResponse
        }
        
        Self.log.debug("Raw response: \(String(decoding: data, as: UTF8.self))")
        
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
            throw RequestError.jsonDecodingError(error: error)
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
            throw RequestError.jsonDecodingError(error: error)
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
            throw RequestError.jsonDecodingError(error: error)
        }
    }
    
    /// Make a `DELETE` request to the Revolt REST API
    func deleteReq(path: String) async throws {
        _ = try await makeRequest(path: path, method: .delete)
    }
    
    /// Make a `PATCH` request to the Revolt REST API
    func patchReq<B: Encodable>(
        path: String,
        body: B
    ) async throws {
        let payload: Data?
        payload = try? RevoltREST.encoder.encode(body)
        _ = try await makeRequest(
            path: path,
            body: payload,
            method: .patch
        )
    }
}
