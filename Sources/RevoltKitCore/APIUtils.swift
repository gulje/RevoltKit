//
//  APIUtils.swift
//
//
//  Created by gulje on 19.06.2023.
//

import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

extension RevoltREST {
  public static let encoder = JSONEncoder()

  public static let decoder = JSONDecoder()

  public static func getData(request: URLRequest) async throws -> (Data, URLResponse) {
    var (data, response): (Data?, URLResponse?)

    #if canImport(FoundationNetworking)
      (data, response) = await withCheckedContinuation { continuation in
        RevoltREST.session.dataTask(with: request) { data, response, _ in
          continuation.resume(returning: (data, response))
        }.resume()
      }
    #else
      (data, response) = try await RevoltREST.session.data(for: request)
    #endif

    guard let data = data, let response = response else {
      throw RevoltREST.InternalRestError.invalidResponse
    }

    return (data, response)
  }
}
