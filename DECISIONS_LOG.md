# Decisions Log

Version: 1

## DEC-001: Architecture Pattern Selection: MVVM with SwiftData

**Chosen:** MVVM + SwiftData

**Rationale:** SwiftUI pairs naturally with @Observable ViewModels. SwiftData for persistence provides native Apple framework with automatic CloudKit sync potential. Document-based app (NSDocument) gives open/save/save-as for free. Mind map state (selected node, expand/collapse, canvas transform) lives in MindMapViewModel (@Observable, @MainActor isolated). Node-specific state in NodeViewModel.

**Alternatives Considered:**
- **MVC with Core Data**: Traditional MVC with NSController subclasses and Core Data (Rejected: Core Data is heavier, SwiftData is the modern Apple recommendation for new macOS apps)
- **VIPER**: VIPER modules with separate Interactor/Presenter/View/Entity/Router (Rejected: Overkill for a mind map app with ~10 screens. High ceremony, low productivity.)
- **Flux/Redux**: Unidirectional data flow with single store (Rejected: SwiftUI's @State/@Binding makes two-way binding natural. Redux adds boilerplate without benefit here.)

**Status:** ACTIVE
**Created:** 2026-03-23T00:00:00Z by lead_architect
**Gate:** 1

---

## DEC-002: Canvas Rendering: Viewport Culling with Spatial Index

**Chosen:** Viewport culling + R-tree spatial index

**Rationale:** Mind map with 10,000+ nodes requires O(log n) visibility queries. R-tree provides excellent performance for 2D spatial queries. Only nodes intersecting visibleRect are rendered as SwiftUI views. Off-screen nodes show placeholder dots. Connections culled when both endpoints off-screen.

**Alternatives Considered:**
- **LazyVGrid/LazyHStack**: Apple's built-in lazy containers (Rejected: These handle only linear layouts, not the 2D spatial layout of a mind map canvas)
- **No culling (render all)**: Simply render all nodes regardless of visibility (Rejected: FATAL: O(n) render at 10k nodes makes app unusable. BLOCKER-002.)
- **Quadtree**: Simple 2D spatial partitioning (Rejected: R-tree has better average performance for variable-density spatial data typical in mind maps)

**Status:** ACTIVE
**Created:** 2026-03-23T00:00:00Z by lead_architect
**Gate:** 1

---

## DEC-003: File Persistence: Atomic Writes with Backup

**Chosen:** Atomic write pattern + automatic backup

**Rationale:** SwiftData ModelContext.save() with try? silently fails. BLOCKER-001 (FATAL): data loss on crash. Solution: write to temp location, verify, rename to final location. Before every save, copy current to .backup directory with timestamp. On launch, check store integrity.

**Alternatives Considered:**
- **SQLite WAL mode**: Write-Ahead Logging for atomic transactions (Rejected: SwiftData doesn't expose low-level SQLite configuration. Not directly controllable.)
- **NSDocument automatic versioning**: Use NSDocument's built-in versioning (Rejected: Designed for conflict resolution in multi-user scenarios, not crash recovery. Doesn't protect against mid-write corruption.)

**Status:** ACTIVE
**Created:** 2026-03-23T00:00:00Z by lead_architect
**Gate:** 1

---

## DEC-004: Thread Safety: MainActor Isolation

**Chosen:** @MainActor on all SwiftData operations

**Rationale:** SwiftData ModelContext is not thread-safe. BLOCKER-005 (HIGH): concurrent access causes CrossActorViolation. Solution: ALL ModelContext operations (save, fetch, insert, delete) run on @MainActor. Auto-save timer uses Task { @MainActor in } for main thread dispatch. MindMapViewModel is @MainActor isolated.

**Alternatives Considered:**
- **Actor-isolated ModelContext**: Create isolated actor wrapping ModelContext (Rejected: SwiftData ModelContext is already @MainActor constrained by Apple. Adding another layer adds complexity without benefit.)
- **Serialize all context access via serial queue**: DispatchQueue.serial for all SwiftData operations (Rejected: Works but less idiomatic than @MainActor. Doesn't integrate with SwiftUI's @State/@StateObject.)

**Status:** ACTIVE
**Created:** 2026-03-23T00:00:00Z by lead_architect
**Gate:** 1

---

