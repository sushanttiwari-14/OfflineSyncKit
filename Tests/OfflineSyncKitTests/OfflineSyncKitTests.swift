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
