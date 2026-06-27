//
//  File.swift
//  OfflineSyncKit
//
//  Created by sushant tiwari on 23/06/26.
//

import Foundation
import SwiftData

public final class SyncQueue {
    private let context: ModelContext
    
    public init(context: ModelContext) {
        self.context = context
    }
    
    // add a new operation to the queue
    public func enqueue(_ operation: SyncOperation) throws {
        context.insert(operation)
        try context.save()
    }
    
    // get all pending operations in order
    public func pendingOperations() throws -> [SyncOperation] {
        let descriptor = FetchDescriptor<SyncOperation>(
            predicate: #Predicate { $0.status == "pending" },
            sortBy: [SortDescriptor(\.createdAt)]
        )
        return try context.fetch(descriptor)
    }
    // mark an operation as completed and remove it
    public func remove(_ operation: SyncOperation) throws {
        context.delete(operation)
        try context.save()
    }
    
    // mark an operation as failed
    public func markFailed(_ operation: SyncOperation) throws {
        operation.status = SyncStatus.failed.rawValue  // was .failed
        operation.retryCount += 1
        try context.save()
    }
}
