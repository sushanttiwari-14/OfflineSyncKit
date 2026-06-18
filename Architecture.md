
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
