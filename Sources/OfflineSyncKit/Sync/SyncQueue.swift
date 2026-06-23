//
//  File.swift
//  OfflineSyncKit
//
//  Created by sushant tiwari on 23/06/26.
//

import Foundation
import SwiftData

final class SyncQueue {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    // add a new operation to the queue
    func enqueue(_ operation: SyncOperation) throws {
        context.insert(operation)
        try context.save()
    }
    
    // get all pending operations in order
    func pendingOperations() throws -> [SyncOperation] {
        let descriptor = FetchDescriptor<SyncOperation>(
            predicate: #Predicate { $0.status == "pending" },
            sortBy: [SortDescriptor(\.createdAt)]
        )
        return try context.fetch(descriptor)
    }
    // mark an operation as completed and remove it
    func remove(_ operation: SyncOperation) throws {
        context.delete(operation)
        try context.save()
    }
    
    // mark an operation as failed
    func markFailed(_ operation: SyncOperation) throws {
        operation.status = SyncStatus.failed.rawValue  // was .failed
        operation.retryCount += 1
        try context.save()
    }
}
