//
//  SyncManager.swift
//  OfflineSyncKit
//
//  Created by sushant tiwari on 18/06/26.
//

final class SyncManager {
    private let storage: NoteStorage
    
    init(storage: NoteStorage) {
        self.storage = storage
    }
}
