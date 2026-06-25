import Testing
import SwiftData
import Foundation
@testable import OfflineSyncKit

@Test func saveAndFetch() async throws {
    let storage = MockNoteStorage()
    let note = Note(title: "Test", content: "Hello")
    
    try storage.save(note)
    
    let notes = try storage.fetchAll()
    
    #expect(notes.count == 1)
    #expect(notes.first?.title == "Test")
}
// test for delete test
@Test func deleteTest() async throws {
    let storage = MockNoteStorage()
    let note = Note(title: "ToDelete", content: "Bye")
    
    try storage.save(note)
    try storage.delete(note)
    
    let notes = try storage.fetchAll()
    #expect(notes.count == 0)
}

// test for updating note
@Test func updateTest() async throws {
    let storage = MockNoteStorage()
    let note = Note(title: "Original", content: "Hello")
    
    try storage.save(note)
    
    note.title = "Updated"
    try storage.update(note)
    
    let notes = try storage.fetchAll()
    #expect(notes.first?.title == "Updated")
}

@MainActor
@Suite struct SyncQueueTests {
    
    @Test func enqueueAddsOperation() async throws {
        // setup in-memory database
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: SyncOperation.self, configurations: config)
        let context = container.mainContext
        let queue = SyncQueue(context: context)
        
        // enqueue an operation
        let operation = SyncOperation(noteId: UUID(), type: .create)
        try queue.enqueue(operation)
        
        // verify it's in the queue
        let pending = try queue.pendingOperations()
        #expect(pending.count == 1)
    }
    
    @Test func markFailedUpdatesStatus() async throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: SyncOperation.self, configurations: config)
        let context = container.mainContext
        let queue = SyncQueue(context: context)
        
        let operation = SyncOperation(noteId: UUID(), type: .create)
        try queue.enqueue(operation)
        try queue.markFailed(operation)
        
        #expect(operation.status == "failed")
        #expect(operation.retryCount == 1)
    }
    
    @Test func removeDeletesOperation() async throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: SyncOperation.self, configurations: config)
        let context = container.mainContext
        let queue = SyncQueue(context: context)
        
        let operation = SyncOperation(noteId: UUID(), type: .create)
        try queue.enqueue(operation)
        try queue.remove(operation)
        
        let pending = try queue.pendingOperations()
        #expect(pending.count == 0)
    }
    
    @Test func removeOnlyDeletesOneOperation() async throws {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: SyncOperation.self, configurations: config)
            let context = container.mainContext
            let queue = SyncQueue(context: context)

            let operation1 = SyncOperation(noteId: UUID(), type: .create)
            let operation2 = SyncOperation(noteId: UUID(), type: .create)
            try queue.enqueue(operation1)
            try queue.enqueue(operation2)
        
            try queue.remove(operation1)
            #expect(try queue.pendingOperations().count == 1)
        
    }
}

@MainActor
@Suite struct SyncManagerTests {
    
    @Test func syncSuccessRemovesOperation() async throws {
        // setup queue
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: SyncOperation.self, configurations: config)
        let context = container.mainContext
        let queue = SyncQueue(context: context)
        
        // setup mocks
        let storage = MockNoteStorage()
        let apiClient = MockAPIClient()
        
        // create sync manager
        let syncManager = SyncManager(storage: storage, apiClient: apiClient, queue: queue)
        
        // save note and enqueue operation
        let note = Note(title: "Test", content: "Hello")
        try storage.save(note)
        let operation = SyncOperation(noteId: note.id, type: .create)
        try queue.enqueue(operation)
        
        // run sync
        await syncManager.sync()
        
        // queue should be empty after success
        let pending = try queue.pendingOperations()
        #expect(pending.count == 0)
    }
    
    @Test func syncFailureIncrementsRetryCount() async throws {
        // setup queue
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: SyncOperation.self, configurations: config)
        let context = container.mainContext
        let queue = SyncQueue(context: context)
        
        let storage = MockNoteStorage()
        let apiClient = MockAPIClient()
        apiClient.shouldFail = true
        
        let syncManager = SyncManager(storage: storage, apiClient: apiClient, queue: queue)
        
        let note = Note(title: "Test", content: "Hello")
        try storage.save(note)
        let operation = SyncOperation(noteId: note.id, type: .create)
        try queue.enqueue(operation)
        
        await syncManager.sync()
        
        // operation should still be in queue with retryCount = 1
        let pending = try queue.pendingOperations()
        #expect(pending.count == 0)
        #expect(operation.retryCount == 1)
    }
    
    @Test func duplicateSyncOnlyRunsOnce() async throws {

        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: SyncOperation.self, configurations: config)
        let context = container.mainContext
        let queue = SyncQueue(context: context)
        
        let storage = MockNoteStorage()
        let apiClient = MockAPIClient()
        
        let syncManager = SyncManager(storage: storage, apiClient: apiClient, queue: queue)
        
        let note = Note(title: "Test", content: "Hello")
        try storage.save(note)
        let operation = SyncOperation(noteId: note.id, type: .create)
        try queue.enqueue(operation)
        
        // call sync three times simultaneously
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await syncManager.sync() }
            group.addTask { await syncManager.sync() }
            group.addTask { await syncManager.sync() }
        }
        
        // queue should be empty — operation processed exactly once
        let pending = try queue.pendingOperations()
        #expect(pending.count == 0)
    }
}
