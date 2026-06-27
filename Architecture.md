
# OfflineSyncKit Architecture

## Overview
SwiftUI Demo App
       ↓
OfflineSyncKit (Swift Package)
       ↓
  SyncManager (actor)
   ↙              ↘
NoteStorage    NoteAPIClientProtocol
Protocol       Protocol
   ↓               ↓
SwiftDataNoteStorage  MockAPIClient
(SwiftData)           (Fake Server)
       ↓
SyncQueue (persisted operations)
       ↓
NetworkMonitor (auto-triggers sync)

## Target vs Product
- Target: a unit of code SPM compiles (one module)
- Product: wraps targets and exposes them to the outside world
- OfflineSyncKit is a library — no entry point, importable by the demo app

## Why Separate Folders
- Each folder has one responsibility
- Enables isolated testing per layer
- Makes swapping implementations easier
Principle: Separation of Concerns

## Why private on SyncManager.storage
- Only SyncManager should interact with storage directly
- Outside code must go through SyncManager
- Protects internal implementation
- Principle: Encapsulation

## Why SwiftData requires @Model on a class
- Classes are reference types — one object, multiple references
- SwiftData needs to track the same instance over time
- Structs are value types — copies lose identity
- Persistence requires identity

## Why update() only calls context.save()
- Note is a class with @Model — SwiftData tracks changes automatically
- Mutating a property is enough; no explicit "update" call needed
- save() persists whatever changes are pending

## QuickTest vs real tests
- QuickTest prints output — requires human judgment
- Swift Testing uses #expect — automatic pass/fail
- Real tests scale; manual printout reading doesn't

## #expect vs #require
- #expect: records failure, test keeps running (see all issues at once)
- #require: stops test immediately if false (use when later code depends on it)

## Why SyncOperation uses let for most properties
- id, noteId, type, createdAt never change after creation — let enforces this
- status changes over the operation lifecycle — var allows this
- Principle: make things immutable by default, mutable only when necessary

## Why SyncManager is an actor
- sync() could be triggered from multiple places simultaneously
- Actor ensures only one sync runs at a time
- Prevents data races on the operation queue
- Compiler enforces safety — not the developer

## Why try? on queue.markFailed
- Already inside a catch block handling sync failure
- If markFailed also throws, there's no meaningful recovery
- try? silently ignores the error and moves on
- Rule: use try? when failure is acceptable and unrecoverable

## Why Exponential Backoff
- Fixed interval retries cause thundering herd problem
- Exponential backoff spreads retries naturally over time
- Formula: baseDelay * (2 ^ retryCount)
- Prevents hammering a struggling server

## Why AsyncStream for status updates
- SyncManager is an actor — UI can't directly observe its properties
- AsyncStream bridges actor state to SwiftUI
- continuation = writing end (SyncManager owns this)
- statusStream = reading end (UI observes this)
- Native Swift alternative to Combine publishers

## Rapid connectivity changes + multiple syncs
- pathUpdateHandler can fire multiple times rapidly
- Each fires sync() on SyncManager
- Actor isolation ensures only one sync runs at a time
- Others wait, find empty queue, exit immediately
- No extra protection code needed — actor handles it

## Dependency Injection + storage swapping
- SyncManager depends on NoteStorage, not SwiftDataStorage
- Storage is injected through the initializer
- Different implementations (SwiftDataStorage, MockStorage) can be swapped easily
- SyncManager never changes when storage implementation changes
- Loose coupling makes testing and maintenance easier
- No extra refactoring needed — DI handles it
