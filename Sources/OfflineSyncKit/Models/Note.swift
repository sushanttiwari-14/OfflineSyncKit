//
//  File.swift
//  OfflineSyncKit
//
//  Created by sushant tiwari on 18/06/26.
//

import Foundation

struct Note: Identifiable {
    let id: UUID
    var title: String
    var content: String
    var createdAt: Date
    var updatedAt: Date
}
