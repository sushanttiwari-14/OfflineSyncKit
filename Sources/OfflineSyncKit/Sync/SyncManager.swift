//
//  SyncManager.swift
//  OfflineSyncKit
//
//  Created by sushant tiwari on 18/06/26.
//
import Foundation

public actor SyncManager {
    private let storage: NoteStorage
    private let apiClient: NoteAPIClientProtocol
    private let queue: SyncQueue
    private let maxRetries = 3
    private let baseDelay: Double = 2.0
    
    // the stream UI observes
    public let statusStream: AsyncStream<SyncState>
    
    // continuation is how we push values INTO the stream
    private var continuation: AsyncStream<SyncState>.Continuation?
    
    public init(storage: NoteStorage, apiClient: NoteAPIClientProtocol, queue: SyncQueue) {
        self.storage = storage
        self.apiClient = apiClient
        self.queue = queue
        
        // create stream and capture continuation
        var streamContinuation: AsyncStream<SyncState>.Continuation?
        self.statusStream = AsyncStream { continuation in
            streamContinuation = continuation
        }
        self.continuation = streamContinuation
    }
    
    // emit state into the stream
    private func emit(_ state: SyncState) {
        continuation?.yield(state)
    }
    
    public func sync() async {
        emit(.syncing)
        
        do {
            let pending = try queue.pendingOperations()
            print("Sync started — \(pending.count) pending operations")
            
            for operation in pending {
                await processOperation(operation)
            }
            
            emit(.completed)
            print("Sync completed")
            
        } catch {
            emit(.failed(error))
            print("Failed to fetch pending operations: \(error)")
        }
    }
    
    private func retryDelay(for retryCount: Int) -> Double {
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
