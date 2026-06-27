//
//  File.swift
//  OfflineSyncKit
//
//  Created by sushant tiwari on 18/06/26.
//

import SwiftData

public final class SwiftDataNoteStorage: NoteStorage, @unchecked Sendable {
    private let context: ModelContext
    
    public init(context: ModelContext) {
        self.context = context
    }
    
    public func save(_ note: Note) throws {
        context.insert(note)
        try context.save()
    }
    
    public func fetchAll() throws -> [Note] {
        return try context.fetch(FetchDescriptor<Note>())
    }
    
    public func delete(_ note: Note) throws {
        context.delete(note)
        try context.save()
    }
    
    public func update(_ note: Note) throws {
        try context.save()
    }
}
