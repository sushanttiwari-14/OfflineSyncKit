//
//  File.swift
//  OfflineSyncKit
//
//  Created by sushant tiwari on 18/06/26.
//

public protocol NoteStorage : Sendable {
    func save(_ note: Note) throws
    func fetchAll() throws -> [Note]
    func delete(_ note: Note) throws
    func update(_ note: Note) throws
}
