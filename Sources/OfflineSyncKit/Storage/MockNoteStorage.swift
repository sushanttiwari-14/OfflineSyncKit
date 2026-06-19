//
//  File.swift
//  OfflineSyncKit
//
//  Created by sushant tiwari on 19/06/26.
//

final class MockNoteStorage: NoteStorage {
    private var notes: [Note] = []
    
    func save(_ note: Note) throws {
        notes.append(note)
    }
    
    func fetchAll() throws -> [Note] {
        return notes
    }
    
    func delete(_ note: Note) throws {
        notes.removeAll { $0.id == note.id }
    }
    
    func update(_ note: Note) throws {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
        }
    }
}
