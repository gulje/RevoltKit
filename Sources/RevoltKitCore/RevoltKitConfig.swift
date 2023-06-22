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
  public var cdnURL: URL

  /// The base URL for the Revolt REST API.
  /// It is derived from the `baseURL`` property and represents the endpoint for making REST API requests.
  public let restBase: URL

  /// The URL for the Revolt WebSocket gateway. It is used for real-time communication with the Revolt server.
  public var gatewayURL: URL

  /// The version number of the Revolt API to be used. By default, it is set to 1.
  public var version: Int

  /// A boolean flag indicating whether the client using the RevoltKit is a bot or not.
  /// By default, it is set to true.
  public var isBot: Bool

  /**
  - Parameters:
    - baseURL: The base URL for the Revolt API. Defaults to "revolt.chat".
    - cdnURL: The URL for the Revolt CDN. Defaults to "autumn.revolt.chat".
    - gatewayURL: The URL for the Revolt WebSocket gateway. Defaults to "ws.revolt.chat".
    - version: The version number of the Revolt API to be used. Defaults to 1.
    - isBot: A boolean flag indicating whether the client is a bot or not. Defaults to `true`.
    - discoverURLs: A boolean flag determines whether RevoltKit should automatically discover the
    appropriate URLs from the Revolt REST API. When this flag is set to `true`, RevoltKit will make
    a fetch API request to the provided `baseURL`, retrieve all the necessary URLs and override the
    existing URL parameters (`cdnURL`, `gatewayURL`) with the fetched values.
   */
  public init(
    baseURL: String = "revolt.chat",
    cdnURL: String = "https://autumn.revolt.chat",
    gatewayURL: String = "wss://ws.revolt.chat/",
    version: Int = 1,
    isBot: Bool = true
  ) {
    self.baseURL = URL(string: "https://\(baseURL)/")!
    self.restBase = self.baseURL.appendingPathComponent("api")
    self.version = version
    self.isBot = isBot
    self.cdnURL = URL(string: cdnURL)!
    self.gatewayURL = URL(string: gatewayURL)!
  }

  public static var `default`: Self = Self()

  /**
    Discovers the appropriate URLs from the Revolt REST API and updates the URL configurations in RevoltKit.

    This function makes a fetch API request to the provided `baseURL`, retrieves the necessary URLs,
    and overrides the existing URL configurations (`cdnURL`, `gatewayURL`) in the `RevoltKitConfig.default` with the fetched values.

    Example usage:
    ```
      RevoltKitConfig.default.isBot = false
      try await RevoltKitConfig.discover("my-awesome-instance.love")

      // The URLs are updated now
      print(RevoltKitConfig.default.isBot) //=> false
    ```
    */
  public static func discover(_ baseURL: String = "revolt.chat") async throws {
    let restBase = URL(string: "https://\(baseURL)/")!.appendingPathComponent("api")

    RevoltREST.log.trace("Fetching server configuration.")

    var req = URLRequest(url: restBase)
    req.httpMethod = "GET"

    guard let (data, response) = try? await RevoltREST.session.data(for: req),
      let _ = response as? HTTPURLResponse
    else {
      throw RevoltREST.InternalRestError.invalidResponse
    }

    let res = try RevoltREST.decoder.decode(FetchingResponse.self, from: data)

    if !res.features.autumn.enabled {
      RevoltREST.log.critical("CDN server is not enabled in this instance!")
    } else {
      RevoltREST.log.trace("Retrieved CDN server: \(res.features.autumn.url)")
      self.default.cdnURL = URL(string: res.features.autumn.url)!
    }

    RevoltREST.log.trace("Retrieved gateway server: \(res.ws)")
    self.default.gatewayURL = URL(string: res.ws)!
  }

  public struct FetchingResponse: Codable {
    public struct FeatureConfiguration: Codable {
      public struct CaptchaConfiguration: Codable {
        public let enabled: Bool
        public let key: String
      }

      public struct GenericServiceConfiguration: Codable {
        public let enabled: Bool
        public let url: String
      }

      public struct VoiceServerConfiguration: Codable {
        public let enabled: Bool
        public let url: String
        public let ws: String
      }

      public let captcha: CaptchaConfiguration

      public let email: Bool

      public let invite_only: Bool

      public let autumn: GenericServiceConfiguration

      public let january: GenericServiceConfiguration

      public let voso: VoiceServerConfiguration
    }

    public struct BuildInformation: Codable {
      public let commit_sha: String
      public let commit_timestamp: String
      public let semver: String
      public let origin_url: String
      public let timestamp: String
    }

    public let revolt: String

    public let features: FeatureConfiguration

    public let ws: String

    public let app: String

    public let vapid: String

    public let build: BuildInformation

  }
}
