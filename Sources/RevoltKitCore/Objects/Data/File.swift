//
//  File.swift
//  
//
//  Created by gulje on 19.06.2023.
//

import Foundation

public enum MetadataType: String, Codable {
    case File
    case Text
    case Image
    case Video
    case Audio
}

public struct Metadata: Codable, Equatable {
    let type: MetadataType
    let width: Int?
    let height: Int?
    
    enum CodingKeys: String, CodingKey {
        case type
        case width
        case height
    }
}

public struct File: Equatable, Codable {
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
    
    /// Unique ID
    public let id: String
    
    /// Tag / bucket this file was uploaded to
    public let tag: String
    
    /// Original filename
    public let filename: String
    
    /// Raw  content type of this file
    public let contentType: String
    
    /// Size of this file (in bytes)
    public let size: UInt
    
    /// Whether this file was deleted
    public let isDeleted: Bool?
    
    /// Whether this file was reported
    public let isReported: Bool?
    
    public let messageID: String?
    
    public let userID: String?
    
    public let serverID: String?
    
    /// ID of the object this file is associated with
    public let objectID: String?
    
    /// Metadata associated with file
    public let metadata: Metadata
}
