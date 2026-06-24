//
//  NoteAPIClientProtocol.swift
//  OfflineSyncKit
//
//  Created by sushant tiwari on 24/06/26.
//

import Foundation

protocol NoteAPIClientProtocol {
    func createNote(_ note: Note) async throws
    func updateNote(_ note: Note) async throws
    func deleteNote(_ noteId: UUID) async throws
}
