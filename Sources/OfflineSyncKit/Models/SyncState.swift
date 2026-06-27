//
//  SyncState.swift
//  OfflineSyncKit
//
//  Created by sushant tiwari on 25/06/26.
//

import Foundation

public enum SyncState {
    case idle
    case syncing
    case failed(Error)
    case completed
}
