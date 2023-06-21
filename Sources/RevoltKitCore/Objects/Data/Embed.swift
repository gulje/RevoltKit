//
//  Embed.swift
//  
//
//  Created by gulje on 20.06.2023.
//

import Foundation

public struct Embed: Codable {
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
    
    public let type: EmbedType
    
    /// Direct URL to web page, video or image ,present in `Website`,  `Image`, `Text` and`Video`
    public let url: String?
    
    /// Original direct URL, present in `Website`
    public let originalURL: String?
    
    /// Present in `Website`
    public let special: SpecialRemoteContent?
    
    /// Present in `Website` and `Text`
    public let title: String?
    
    /// Present in `Website` and `Text`
    public let description: String?
    
    /// Present in `Website`
    public let image: EmbeddedImage?
    
    /// Present in `Website`
    public let video: EmbeddedVideo?
    
    /// Present in `Website`
    public let siteName: String?
    
    /// Present in `Website` and `Text`
    public let iconURL: String?
    
    /// Present in `Website` and `Text`
    public let colour: String?
    
    /// Present in `Image`, `Video`
    public let width: Int?
    
    /// Present in `Image`, `Video`
    public let height: Int?
    
    /// Present in `Image`
    public let size: EmbeddedImageSizeType?
    
    /// Present in `Text`
    public let media: File?
}

public enum EmbedType: String, Codable {
    case Website
    case Image
    case Video
    case Text
    case None
}

public struct EmbeddedVideo: Codable {
    public let url: String
    public let width: Int
    public let height: Int
}

public struct EmbeddedImage: Codable {
    public let url: String
    public let width: Int
    public let height: Int
    public let size: EmbeddedImageSizeType
}

public enum EmbeddedImageSizeType: String, Codable {
    case Large
    case Preview
}

public struct SpecialRemoteContent: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case timestamp
        case contentType = "content_type"
    }
    
    public let type: SpecialRemoteContentType
    
    /// Not present in `None`, `GIF` and `Soundcloud`
    public let id: String?
    
    /// Present in `YouTube`
    public let timestamp: String?
    
    /// Present in `Lightspeed`, `Bandcamp`, `Spotify` and `Twitch`
    public let contentType: SpecialRemoteContentTypes?
}

public enum SpecialRemoteContentTypes: Codable {
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
    /// `Twitch`
    case Video
    case Clip
    
    /// `Bandcamp`
    case Album
    case Track
    
    /// `Lightspeed` and `Twitch`
    case Channel
}

public enum SpecialRemoteContentType: String, Codable {
    case None
    case GIF
    case YouTube
    case Lightspeed
    case Twitch
    case Spotify
    case Soundcloud
    case Bandcamp
    case Streamable
}
