//
//  File.swift
//  
//
//  Created by gulje on 19.06.2023.
//

import Foundation

public struct File: Equatable, Codable {
    public init(
        id: String,
        tag: String,
        filename: String,
        content_type: String,
        size: UInt,
        deleted: Bool?,
        reported: Bool?,
        message_id: String?,
        user_id: String?,
        server_id: String?,
        object_id: String?
    ) {
        self.id = id
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
    }
    
    public let id: String
    
    public let tag: String
    
    public let filename: String
    
    public let content_type: String
    
    public let size: UInt
    
    public let deleted: Bool?
    
    public let reported: Bool?
    
    public let message_id: String?
    
    public let user_id: String?
    
    public let server_id: String?
    
    public let object_id: String?
}
