//
//  File.swift
//  OfflineSyncKit
//
//  Created by sushant tiwari on 22/06/26.
//

enum SyncStatus {
    case pending
    case inProgress
    case completed
    case failed(error: Error, retryCount: Int)
}
