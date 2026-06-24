//
//  File.swift
//  OfflineSyncKit
//
//  Created by sushant tiwari on 24/06/26.
//

import Foundation

final class MockAPIClient: NoteAPIClientProtocol {
    // controls whether calls succeed or fail
    var shouldFail: Bool = false
    
    enum MockError: Error {
        case simulatedFailure
    }
    
    func createNote(_ note: Note) async throws {
        if shouldFail { throw MockError.simulatedFailure }
    }
    
    func updateNote(_ note: Note) async throws {
        if shouldFail { throw MockError.simulatedFailure }
    }
    
    func deleteNote(_ noteId: UUID) async throws {
        if shouldFail { throw MockError.simulatedFailure }
    }
}
