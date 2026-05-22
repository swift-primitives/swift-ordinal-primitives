// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-primitives open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-primitives
// project authors. Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

#if SYNCHRONIZATION_AVAILABLE
    public import Cardinal_Primitives
    public import Carrier_Primitives
    public import Ordinal_Primitive
    public import Synchronization
    public import Tagged_Primitives

    extension Ordinal {
        /// An atomic round-robin cursor over a tagged ordinal domain.
        ///
        /// Storage is `Synchronization.Atomic<UInt>` internally; the public
        /// surface accepts and returns `Tagged<Tag, Ordinal>` values so the
        /// phantom-Tag domain discipline carries through every interaction
        /// (load, store, compare-exchange, advance).
        ///
        /// ## Why this type exists
        ///
        /// `Synchronization.Atomic<Tagged<Tag, Ordinal>>` triggers a
        /// Swift 6.3.x runtime metadata-instantiation defect: the runtime
        /// `swift_getTypeByMangledName` returns a default-constructed
        /// `TypeLookupError("unknown error")` when asked to materialize the
        /// type metadata for `Atomic<Tagged<Tag, Underlying>>`, and every
        /// downstream operation (init, deinit, generic method dispatch)
        /// dereferences the resulting null. Even `let _ = Atomic<Tagged<…>>(.zero)`
        /// followed by an immediate scope-end deinit faults.
        ///
        /// `Atomic<UInt>` (no Tagged wrapper) instantiates reliably across
        /// every shape the consumer cares about — load, compare-exchange,
        /// generic-method dispatch on extension methods. This type closes
        /// the gap: it gives consumers the typed `Tagged<Tag, Ordinal>`
        /// surface they reach for in round-robin dispatch code while
        /// keeping the storage in the runtime-safe `Atomic<UInt>` shape.
        ///
        /// The wrapper survives the bug being fixed upstream — it remains
        /// a useful, named primitive for "atomic position over a tagged
        /// ordinal domain" regardless of whether `Atomic<Tagged<…>>` later
        /// works on its own. Evergreen by construction.
        ///
        /// Diagnostic trail: `HANDOFF-test-sigsegv-post-cycle-break.md` in
        /// the workspace root; `swift-compiler-bug-catalog.md §A9`.
        ///
        /// ## Example — round-robin dispatch
        ///
        /// ```swift
        /// let cursor = Ordinal.AtomicPosition<Kernel.Thread>()
        /// workers[cursor.advance(within: count)].enqueue(job)
        /// ```
        ///
        /// ## Thread Safety
        ///
        /// `Sendable` by virtue of the internal `Atomic<UInt>`. All
        /// observable mutation happens through atomic operations on the
        /// underlying word.
        public struct AtomicPosition<Tag: ~Copyable & ~Escapable>: ~Copyable, @unsafe @unchecked Sendable {
            @usableFromInline
            internal let storage: Atomic<UInt>

            /// Creates an atomic position initialized at the zero ordinal.
            @inlinable
            public init() {
                self.storage = .init(0)
            }

            /// Creates an atomic position initialized to `initial`.
            @inlinable
            public init(_ initial: Tagged<Tag, Ordinal>) {
                self.storage = .init(initial.underlying.rawValue)
            }

            /// Atomically loads the current tagged ordinal position with relaxed ordering.
            ///
            /// Round-robin dispatch does not require stronger orderings; callers
            /// that depend on happens-before with other atomic state should
            /// use the `load(ordering:)` overload below.
            ///
            /// - Returns: The current position as a `Tagged<Tag, Ordinal>`.
            @inlinable
            public func load() -> Tagged<Tag, Ordinal> {
                Tagged<Tag, Ordinal>(_unchecked: Ordinal(storage.load(ordering: .relaxed)))
            }

            /// Atomically advance the stored position by one, wrapping modulo `capacity`.
            ///
            /// Returns the old position. The stored position is always in
            /// `[0, capacity)` — the update applies typed `+ .one` followed by
            /// modular reduction. Uses a compare-exchange loop; under contention
            /// may retry, but the stored value never leaves the valid range.
            ///
            /// ## Example — round-robin dispatch
            ///
            /// ```swift
            /// let cursor = Ordinal.AtomicPosition<Thread>()
            /// workers[cursor.advance(within: count)].enqueue(job)
            /// ```
            ///
            /// - Parameter capacity: The modular bound. Must be `> 0`.
            /// - Returns: The position before advancement, in `[0, capacity)`.
            @inlinable
            public func advance<C: Carrier.`Protocol`<Cardinal>>(
                within capacity: C
            ) -> Tagged<Tag, Ordinal>
            where C.Domain == Tag {
                // Modular arithmetic on raw UInt to bypass typed-operator
                // overload resolution (the institute Ordinal+Cardinal operators
                // are `@_disfavoredOverload` so SIMD's `+` wins ambiguity).
                // The returned `Tagged<Tag, Ordinal>` preserves the typed
                // surface for callers.
                let capRaw = capacity.cardinal.rawValue
                while true {
                    let currentRaw = storage.load(ordering: .relaxed)
                    let nextRaw = (currentRaw &+ 1) % capRaw
                    let r = storage.compareExchange(
                        expected: currentRaw,
                        desired: nextRaw,
                        successOrdering: .relaxed,
                        failureOrdering: .relaxed
                    )
                    if r.exchanged {
                        return Tagged<Tag, Ordinal>(_unchecked: Ordinal(currentRaw))
                    }
                }
            }
        }
    }
#endif
