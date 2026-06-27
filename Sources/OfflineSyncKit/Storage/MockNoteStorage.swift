//
//  File.swift
//  OfflineSyncKit
//
//  Created by sushant tiwari on 19/06/26.
//

public final class MockNoteStorage: NoteStorage, @unchecked Sendable {
    private var notes: [Note] = []
    
    public func save(_ note: Note) throws {
        notes.append(note)
    }
    
    public func fetchAll() throws -> [Note] {
        return notes
    }
    
    public func delete(_ note: Note) throws {
        notes.removeAll { $0.id == note.id }
    }
    
    public func update(_ note: Note) throws {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
        }
    }
}
