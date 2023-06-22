//
//  File.swift
//
//
//  Created by gulje on 19.06.2023.
//

import Foundation

/// Represents the type of metadata associated with a file.
public enum MetadataType: String, Codable {
  case file = "File"
  case text = "Text"
  case image = "Image"
  case video = "Video"
  case audio = "Audio"
}

/// Represents metadata associated with a file.
public struct Metadata: Codable {
  /// The type of metadata.
  let type: MetadataType

  /// The width of the file. This field is present only for `Image` and `Video` types.
  let width: Int?

  /// The height of the file. This field is present only for `Image` and `Video` types.
  let height: Int?

  enum CodingKeys: String, CodingKey {
    case type
    case width
    case height
  }
}

public struct File: Equatable, Codable {
  /**
     Represents a file object.
     */

  /// The unique ID of the file.
  public let id: String

  /// The tag or bucket this file was uploaded to.
  public let tag: String

  /// The original filename of the file.
  public let filename: String

  /// The raw content type of the file.
  public let contentType: String

  /// The size of the file in bytes.
  public let size: UInt

  /// Indicates whether the file was deleted.
  public let isDeleted: Bool?

  /// Indicates whether the file was reported.
  public let isReported: Bool?

  /// The ID of the message associated with the file. This field is optional and may not be present.
  public let messageID: String?

  /// The ID of the user associated with the file. This field is optional and may not be present.
  public let userID: String?

  /// The ID of the server associated with the file. This field is optional and may not be present.
  public let serverID: String?

  /// The ID of the object associated with the file. This field is optional and may not be present.
  public let objectID: String?

  /// The metadata associated with the file.
  public let metadata: Metadata

  private enum CodingKeys: String, CodingKey {
    case id = "_id"
    case tag
    case filename
    case contentType = "content_type"
    case size
    case isDeleted = "deleted"
    case isReported = "reported"
    case messageID = "message_id"
    case userID = "user_id"
    case serverID = "server_id"
    case objectID = "object_id"
    case metadata
  }

  /// Compares two `File` instances for equality.
  public static func == (lhs: File, rhs: File) -> Bool {
    lhs.id == rhs.id
  }
}
