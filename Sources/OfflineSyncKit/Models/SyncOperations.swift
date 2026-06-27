//
//  File.swift
//  OfflineSyncKit
//
//  Created by sushant tiwari on 22/06/26.
//

import Foundation
import SwiftData

@Model public class SyncOperation {
    public var id: UUID
    public var noteId: UUID
    public var type: OperationType
    public var status: String
    public var retryCount: Int
    public var createdAt: Date
    
    public enum OperationType: String, Codable {
        case create
        case update
        case delete
    }
    
    public init(noteId: UUID, type: OperationType) {
        self.id = UUID()
        self.noteId = noteId
        self.type = type
        self.status = SyncStatus.pending.rawValue
        self.retryCount = 0 
        self.createdAt = Date()
    }
}
