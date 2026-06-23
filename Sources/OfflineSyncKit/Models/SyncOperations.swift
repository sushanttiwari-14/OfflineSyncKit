//
//  File.swift
//  OfflineSyncKit
//
//  Created by sushant tiwari on 22/06/26.
//

import Foundation
import SwiftData

@Model class SyncOperation {
    var id: UUID
    var noteId: UUID
    var type: OperationType
    var status: String
    var retryCount: Int
    var createdAt: Date
    
    enum OperationType: String, Codable {
        case create
        case update
        case delete
    }
    
    init(noteId: UUID, type: OperationType) {
        self.id = UUID()
        self.noteId = noteId
        self.type = type
        self.status = SyncStatus.pending.rawValue
        self.retryCount = 0 
        self.createdAt = Date()
    }
}
