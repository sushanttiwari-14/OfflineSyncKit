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
    
    init(storage: NoteStorage, apiClient: NoteAPIClientProtocol, queue: SyncQueue) {
        self.storage = storage
        self.apiClient = apiClient
        self.queue = queue
    }
    
    func sync() async {
        do {
            let pending = try queue.pendingOperations()
            
            for operation in pending {
                await processOperation(operation)
            }
        } catch {
            print("Failed to fetch pending operations: \(error)")
        }
    }
    
    private func processOperation(_ operation: SyncOperation) async {
        do {
            // fetch the note this operation refers to
            let notes = try storage.fetchAll()
            let note = notes.first { $0.id == operation.noteId }
            
            // call correct API method based on operation type
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
            
            // success — remove from queue
            try queue.remove(operation)
            
        } catch {
            // failure — mark failed, retry later
            try? queue.markFailed(operation)
            print("Operation failed: \(error)")
        }
    }
}
