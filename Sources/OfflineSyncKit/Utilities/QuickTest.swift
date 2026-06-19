//
//  File.swift
//  OfflineSyncKit
//
//  Created by sushant tiwari on 19/06/26.
//

import SwiftData

@MainActor func runQuickTest() {
    do {
        // set up storage for Note
        let container = try ModelContainer(for: Note.self)
        let context = container.mainContext

        // inject context into our storage
        let storage = SwiftDataNoteStorage(context: context)

        // save a note
        let note = Note(title: "Test Note", content: "Hello SwiftData")
        try storage.save(note)

        // fetch and check
        let notes = try storage.fetchAll()
        print(notes)

    } catch {
        print("Error: \(error)")
         
    }
}
