//
//  File.swift
//  OfflineSyncKit
//
//  Created by sushant tiwari on 24/06/26.
//

import Foundation

public final class MockAPIClient: NoteAPIClientProtocol, @unchecked Sendable  {
    // controls whether calls succeed or fail
    public var shouldFail: Bool = false
    
    enum MockError: Error {
        case simulatedFailure
    }
    
    public func createNote(_ note: Note) async throws {
        if shouldFail { throw MockError.simulatedFailure }
    }
    
    public func updateNote(_ note: Note) async throws {
        if shouldFail { throw MockError.simulatedFailure }
    }
    
    public func deleteNote(_ noteId: UUID) async throws {
        if shouldFail { throw MockError.simulatedFailure }
    }
}
