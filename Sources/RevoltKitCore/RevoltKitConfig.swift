//
//  RevoltKitConfig.swift
//
//
//  Created by gulje on 19.06.2023.
//

import Foundation

public struct RevoltKitConfig {
  public let baseURL: URL

  public let cdnURL: String

  public let restBase: URL

  public var version: Int

  public var gateway: String {
    "wss://ws.revolt.chat?version=\(version)&format=json"
  }

  public var isBot: Bool

  public init(
    baseURL: String = "revolt.chat",
    version: Int = 1,
    isBot: Bool = true
  ) {
    self.cdnURL = "https://autumn.revolt.chat/"
    self.baseURL = URL(string: "https://\(baseURL)/")!
    self.version = version
    self.isBot = isBot

    self.restBase = self.baseURL.appendingPathComponent("api")

  }

  public static var `default` = Self()
}
