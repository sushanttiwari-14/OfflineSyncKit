//
//  File.swift
//  OfflineSyncKit
//
//  Created by sushant tiwari on 22/06/26.
//

import Foundation

struct SyncOperation {
    let id: UUID
    let noteId: UUID
    let type: OperationType
    var status: SyncStatus
    let createdAt: Date
    
    enum OperationType {
        case create
        case update
        case delete
    }
    
    init(noteId: UUID, type: OperationType) {
        self.id = UUID()
        self.noteId = noteId
        self.type = type
        self.status = .pending
        self.createdAt = Date()
    }
}
