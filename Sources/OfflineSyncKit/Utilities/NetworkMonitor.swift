//
//  File.swift
//  OfflineSyncKit
//
//  Created by sushant tiwari on 25/06/26.
//

import Network
import Foundation

final class NetworkMonitor {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private var syncManager: SyncManager?
    
    init(syncManager: SyncManager) {
        self.syncManager = syncManager
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                print("Network available — triggering sync")
                Task {
                    await self?.syncManager?.sync()
                }
            } else {
                print("Network unavailable")
            }
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
