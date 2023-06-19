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
}
