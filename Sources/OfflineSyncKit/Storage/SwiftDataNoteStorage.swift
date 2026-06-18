//
//  File.swift
//  OfflineSyncKit
//
//  Created by sushant tiwari on 18/06/26.
//

import SwiftData

final class SwiftDataNoteStorage: NoteStorage {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func save(_ note: Note) throws {
        context.insert(note)
        try context.save()
    }
    
    func fetchAll() throws -> [Note] {
        return try context.fetch(FetchDescriptor<Note>())
    }
    
    func delete(_ note: Note) throws {
        context.delete(note)
        try context.save()
    }
    
    func update(_ note: Note) throws {
        try context.save()
    }
}
