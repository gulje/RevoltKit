//
//  RevoltREST.swift
//
//
//  Created by gulje on 19.06.2023.
//

import Foundation
import Logging

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public enum RevoltKitErrors: Error {
  case notImplemented(String)
}

public class RevoltREST {
  static let log = Logger(label: "RevoltREST", level: nil)

  static let session: URLSession = {
    let configuration = URLSessionConfiguration.default

    return URLSession(configuration: configuration)
  }()

  internal var token: String?

  public init() {}

  public func setToken(token: String?) {
    self.token = token
  }
}
