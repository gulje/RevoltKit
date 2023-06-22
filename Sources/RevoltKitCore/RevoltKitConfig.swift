//
//  RevoltKitConfig.swift
//
//
//  Created by gulje on 19.06.2023.
//

import Foundation

/// It is a configuration object used in the RevoltKit.
/// It provides various properties to configure the Revolt API endpoints and settings.
/// To provide custom config, just make changes on the `default` property.
public struct RevoltKitConfig {
  /// The base URL for the Revolt API. It represents the main server endpoint for making API requests.
  public let baseURL: URL

  /// The URL for the Revolt Content Delivery Network (CDN). It is used for fetching and serving media content.
  public let cdnURL: URL

  /// The base URL for the Revolt REST API.
  /// It is derived from the `baseURL`` property and represents the endpoint for making REST API requests.
  public let restBase: URL

  ///  The URL for the Revolt WebSocket gateway. It is used for real-time communication with the Revolt server.
  public var gatewayURL: URL

  /// The version number of the Revolt API to be used. By default, it is set to 1.
  public var version: Int

  /// A boolean flag indicating whether the client using the RevoltKit is a bot or not.
  /// By default, it is set to true.
  public var isBot: Bool

  public init(
    baseURL: String = "revolt.chat",
    cdnURL: String = "autumn.revolt.chat",
    gatewayURL: String = "ws.revolt.chat",
    version: Int = 1,
    isBot: Bool = true
  ) {
    self.cdnURL = URL(string: "https://\(cdnURL)/")!
    self.baseURL = URL(string: "https://\(baseURL)/")!
    self.gatewayURL = URL(string: "ws://\(gatewayURL)")!
    self.version = version
    self.isBot = isBot

    self.restBase = self.baseURL.appendingPathComponent("api")
  }

  public static var `default` = Self()
}
