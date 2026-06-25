//
//  SyncManager.swift
//  OfflineSyncKit
//
//  Created by sushant tiwari on 18/06/26.
//
import Foundation
actor SyncManager {
    private let storage: NoteStorage
    private let apiClient: NoteAPIClientProtocol
    private let queue: SyncQueue
    private let maxRetries = 3
    private let baseDelay: TimeInterval = 2.0
    
    init(storage: NoteStorage, apiClient: NoteAPIClientProtocol, queue: SyncQueue) {
        self.storage = storage
        self.apiClient = apiClient
        self.queue = queue
    }
    
    func sync() async {
        do {
            let pending = try queue.pendingOperations()
            print("Sync started — \(pending.count) pending operations")
            
            for operation in pending {
                await processOperation(operation)
            }
            
            print("Sync completed")
        } catch {
            print("Failed to fetch pending operations: \(error)")
        }
    }
    
    private func retryDelay(for retryCount: Int) -> TimeInterval {
        return baseDelay * pow(2.0, Double(retryCount))
    }
    
    private func processOperation(_ operation: SyncOperation) async {
        // check if we've exceeded max retries
        if operation.retryCount >= maxRetries {
            print("Operation \(operation.id) exceeded max retries — giving up")
            return
        }
        
        // if this is a retry, wait with exponential backoff
        if operation.retryCount > 0 {
            let delay = retryDelay(for: operation.retryCount)
            print("Retry attempt \(operation.retryCount) — waiting \(delay)s")
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        
        do {
            let notes = try storage.fetchAll()
            let note = notes.first { $0.id == operation.noteId }
            
            switch operation.type {
            case .create:
                guard let note = note else { return }
                try await apiClient.createNote(note)
            case .update:
                guard let note = note else { return }
                try await apiClient.updateNote(note)
            case .delete:
                try await apiClient.deleteNote(operation.noteId)
            }
            
            print("Operation succeeded — removing from queue")
            try queue.remove(operation)
            
        } catch {
            print("Attempt \(operation.retryCount + 1) failed: \(error)")
            try? queue.markFailed(operation)
        }
    }
}
