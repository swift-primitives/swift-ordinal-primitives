// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-primitives open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

// MARK: - Computed Properties

extension Swift.Range where Bound: Ordinal.`Protocol` {
    /// Whether the range contains no positions.
    @inlinable
    public var isEmpty: Bool { lowerBound == upperBound }
}

// MARK: - count

extension Swift.Range where Bound: Ordinal.`Protocol` {
    /// The number of positions in the range.
    ///
    /// One signature covers both shapes:
    /// - Bare `Range<Ordinal>` (`Bound.Count == Cardinal`) — result is bare `Cardinal`.
    /// - `Range<Tagged<Tag, Ordinal>>` (`Bound.Count == Tagged<Tag, Cardinal>`) — result preserves the phantom tag.
    ///
    /// Uses the unchecked distance variant: the `Range` invariant guarantees
    /// `lowerBound <= upperBound`, so the forward-distance precondition holds
    /// without runtime check.
    @inlinable
    public var count: Bound.Count {
        lowerBound.distance.unchecked(to: upperBound)
    }
}

// MARK: - init(start:count:)

extension Swift.Range where Bound: Ordinal.`Protocol` {
    /// Creates a range from a start position and a cardinal-carrying count.
    ///
    /// This is a total operation: `start + count >= start` is guaranteed
    /// because both are non-negative, so the Range invariant holds.
    @inlinable
    public init(start: Bound, count: Bound.Count) {
        unsafe self.init(uncheckedBounds: (lower: start, upper: start + count))
    }
}
