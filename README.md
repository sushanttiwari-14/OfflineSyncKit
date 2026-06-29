# OfflineSyncKit

A Swift Package for offline-first sync on iOS. Notes save locally when offline and sync automatically when network returns.

## How it works
User creates a note while offline. It saves to SwiftData instantly and a sync operation gets queued. The moment network returns, NWPathMonitor detects it, SyncManager processes the queue, and the server gets updated. No data loss. No user action needed.

## Features
Offline-first local storage with SwiftData  
Persistent operation queue that survives app restarts  
Automatic sync triggered by NWPathMonitor  
Retry logic with exponential backoff  
Real-time sync status streamed via AsyncStream  
Protocol-oriented design — every layer is swappable  
Fully tested with Swift Testing  

## Architecture
SwiftUI App → SyncManager (actor) → NoteStorage Protocol → SwiftData  
                                  → NoteAPIClientProtocol → Your API → 
                                    SyncQueue (SwiftData) + NetworkMonitor  

## What I learned building this
Swift Package Manager, SwiftData, Protocols and Dependency Injection, Async/Await and Actors, AsyncStream, Exponential Backoff, NWPathMonitor, Swift Testing

## Requirements
iOS 17+  
Xcode 15+  

## Author
Sushant Tiwari
