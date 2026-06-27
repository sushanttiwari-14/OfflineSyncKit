//
//  File.swift
//  OfflineSyncKit
//
//  Created by sushant tiwari on 25/06/26.
//

import Network
import Foundation

public final class NetworkMonitor {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private var syncManager: SyncManager?
    
    public init(syncManager: SyncManager) {
        self.syncManager = syncManager
    }
    
    public func startMonitoring() {
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
    
    public func stopMonitoring() {
        monitor.cancel()
    }
}
