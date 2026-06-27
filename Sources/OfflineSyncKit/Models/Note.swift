//
//  File.swift
//  OfflineSyncKit
//
//  Created by sushant tiwari on 18/06/26.
//

import SwiftData
import Foundation

@Model public class Note {
    public var id: UUID
    public var title: String
    public var content: String
    public var createdAt: Date
    public var updatedAt: Date
    
    public init(id: UUID = UUID(), title: String, content: String, createdAt: Date = Date(), updatedAt: Date = Date()) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
