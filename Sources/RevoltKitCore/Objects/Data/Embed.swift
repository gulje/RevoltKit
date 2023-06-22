//
//  Embed.swift
//
//
//  Created by gulje on 20.06.2023.
//

import Foundation

/// Represents an embedded content object, such as a website, image, video, or text.
public struct Embed: Codable {
  /// The type of the embedded content, indicating its category. This field is present at all times.
  public let type: EmbedType

  /// The direct URL to the web page, video, or image associated with the embedded content. This field is present in embeds of type `Website`, `Image`, `Text`, and `Video`.
  public let url: String?

  /// The original direct URL of the embedded content. This field is present in embeds of type `Website`.
  public let originalURL: String?

  /// Special remote content associated with the embedded content. This field is present in embeds of type `Website`.
  public let special: SpecialRemoteContent?

  /// The title of the embedded content. This field is present in embeds of type `Website` and `Text`.
  public let title: String?

  /// The description of the embedded content. This field is present in embeds of type `Website` and `Text`.
  public let description: String?

  /// The image associated with the embedded content. This field is present in embeds of type `Website`.
  public let image: EmbeddedImage?

  /// The video associated with the embedded content. This field is present in embeds of type `Website`.
  public let video: EmbeddedVideo?

  /// The name of the site associated with the embedded content. This field is present in embeds of type `Website`.
  public let siteName: String?

  /// The URL of the icon associated with the embedded content. This field is present in embeds of type `Website` and `Text`.
  public let iconURL: String?

  /// The CSS color associated with the embedded content. This field is present in embeds of type `Website` and `Text`.
  public let colour: String?

  /// The width of the embedded image or video. This field is present in embeds of type `Image` and `Video`.
  public let width: Int?

  /// The height of the embedded image or video. This field is present in embeds of type `Image` and `Video`.
  public let height: Int?

  /// The size type of the embedded image. This field is present in embeds of type `Image`.
  public let size: EmbeddedImageSizeType?

  /// The media file associated with the embedded text. This field is present in embeds of type `Text`.
  public let media: File?

  private enum CodingKeys: String, CodingKey {
    case type
    case url
    case originalURL = "original_url"
    case special
    case title
    case description
    case image
    case video
    case siteName = "site_name"
    case iconURL = "icon_url"
    case colour
    case width
    case height
    case size
    case media
  }
}

/// The type of an embedded content.
public enum EmbedType: String, Codable {
  case website = "Website"
  case image = "Image"
  case video = "Video"
  case text = "Text"
  case none = "None"
}

public struct EmbeddedVideo: Codable {
  /**
     Represents an embedded video object.
     */

  /// The URL of the embedded video.
  public let url: String

  /// The width of the embedded video.
  public let width: Int

  /// The height of the embedded video.
  public let height: Int
}

public struct EmbeddedImage: Codable {
  /**
     Represents an embedded image object.
     */

  /// The URL of the embedded image.
  public let url: String

  /// The width of the embedded image.
  public let width: Int

  /// The height of the embedded image.
  public let height: Int

  /// The size type of the embedded image.
  public let size: EmbeddedImageSizeType
}

/// The size type of an embedded image.
public enum EmbeddedImageSizeType: String, Codable {
  case large = "Large"
  case preview = "Preview"
}

/// Represents special remote content associated with an embedded object.
public struct SpecialRemoteContent: Codable {
  /// The type of special remote content.
  public let type: SpecialRemoteContentType

  /// The ID associated with the special remote content. This field is not present in special remote content of types `None`, `GIF`, and `Soundcloud`.
  public let id: String?

  /// The timestamp associated with the special remote content. This field is present in special remote content of type `YouTube`.
  public let timestamp: String?

  /// The content type of the special remote content. This field is present in special remote content of types `Lightspeed`, `Bandcamp`, `Spotify`, and `Twitch`.
  public let contentType: SpecialRemoteContentTypes?

  private enum CodingKeys: String, CodingKey {
    case type
    case id
    case timestamp
    case contentType = "content_type"
  }
}

public enum SpecialRemoteContentTypes: Codable {
  /**
     Represents the content type of special remote content.
     */

  case string(String)
  case enumValue(SpecialRemoteContentTypeEnum)

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()

    if let stringValue = try? container.decode(String.self) {
      self = .string(stringValue)
    } else if let enumValue = try? container.decode(SpecialRemoteContentTypeEnum.self) {
      self = .enumValue(enumValue)
    } else {
      throw DecodingError.typeMismatch(
        SpecialRemoteContentTypeEnum.self,
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Invalid type"
        )
      )
    }
  }
}

public enum SpecialRemoteContentTypeEnum: String, Codable {
  /// The content type for special remote content of type `Twitch`.
  case video = "Video"
  case clip = "Clip"

  /// The content type for special remote content of type `Bandcamp`.
  case album = "Album"
  case track = "Track"

  /// The content type for special remote content of types `Lightspeed` and `Twitch`.
  case channel = "Channel"
}

// swift-format-ignore: AlwaysUseLowerCamelCase
/// Represents the type of special remote content.
public enum SpecialRemoteContentType: String, Codable {
  case None = "None"
  case GIF
  case YouTube
  case Lightspeed
  case Twitch
  case Spotify
  case Soundcloud
  case Bandcamp
  case Streamable
}
