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

public import Synchronization

public import Carrier_Primitives
public import Cardinal_Primitives

// MARK: - Atomic + Ordinal.Protocol

extension Atomic
where
    Value: Ordinal.`Protocol` & AtomicRepresentable,
    Value.AtomicRepresentation == UInt.AtomicRepresentation
{
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
    /// let cursor: Atomic<Index<Thread>> = .init(.zero)
    /// workers[cursor.advance(within: count)].enqueue(job)
    /// ```
    ///
    /// - Parameter capacity: The modular bound. Must be `> 0`.
    /// - Returns: The position before advancement, in `[0, capacity)`.
    @inlinable
    public func advance<C: Carrier<Cardinal>>(
        within capacity: C
    ) -> Value
    where Value.Domain == C.Domain {
        while true {
            let current = load(ordering: .relaxed)
            let next = (current + C.one) % capacity
            let result = compareExchange(
                expected: current,
                desired: next,
                successOrdering: .relaxed,
                failureOrdering: .relaxed
            )
            if result.exchanged { return current }
        }
    }
}
