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
    private var _id: String;
    
    public init(
        _id: String,
        tag: String,
        filename: String,
        content_type: String,
        size: UInt,
        deleted: Bool?,
        reported: Bool?,
        message_id: String?,
        user_id: String?,
        server_id: String?,
        object_id: String?,
        metadata: Metadata
    ) {
        self._id = _id
        self.tag = tag
        self.filename = filename
        self.content_type = content_type
        self.size = size
        self.deleted = deleted
        self.reported = reported
        self.message_id = message_id
        self.user_id = user_id
        self.server_id = server_id
        self.object_id = object_id
        self.metadata = metadata
    }
    
    /// Unique ID
    public var id: String {
        get { return _id }
    }
    
    /// Tag / bucket this file was uploaded to
    public let tag: String
    
    /// Original filename
    public let filename: String
    
    /// Raw  content type of this file
    public let content_type: String
    
    /// Size of this file (in bytes)
    public let size: UInt
    
    /// Whether this file was deleted
    public let deleted: Bool?
    
    /// Whether this file was reported
    public let reported: Bool?
    
    public let message_id: String?
    
    public let user_id: String?
    
    public let server_id: String?
    
    /// ID of the object this file is associated with
    public let object_id: String?
    
    /// Metadata associated with file
    public let metadata: Metadata
}
