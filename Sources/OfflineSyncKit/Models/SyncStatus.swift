//
//  File.swift
//  OfflineSyncKit
//
//  Created by sushant tiwari on 22/06/26.
//

public enum SyncStatus: String, Codable {
    case pending
    case inProgress
    case completed
    case failed
}
