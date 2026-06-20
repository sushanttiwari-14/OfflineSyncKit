import Testing
@testable import OfflineSyncKit

@Test func saveAndFetch() async throws {
    let storage = MockNoteStorage()
    let note = Note(title: "Test", content: "Hello")
    
    try storage.save(note)
    
    let notes = try storage.fetchAll()
    
    #expect(notes.count == 1)
    #expect(notes.first?.title == "Test")
}

@Test func deleteTest() async throws {
    let storage = MockNoteStorage()
    let note = Note(title: "ToDelete", content: "Bye")
    
    try storage.save(note)
    try storage.delete(note)
    
    let notes = try storage.fetchAll()
    #expect(notes.count == 0)
}

@Test func updateTest() async throws {
    let storage = MockNoteStorage()
    var note = Note(title: "Original", content: "Hello")
    
    try storage.save(note)
    
    note.title = "Updated"
    try storage.update(note)
    
    let notes = try storage.fetchAll()
    #expect(notes.first?.title == "Updated")
}
