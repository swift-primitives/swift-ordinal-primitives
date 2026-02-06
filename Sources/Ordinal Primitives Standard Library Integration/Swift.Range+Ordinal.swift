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

    /// The number of positions in the range.
    ///
    /// Returns the cardinal distance from `lowerBound` to `upperBound`.
    /// The result type is `Bound.Count`, preserving phantom types:
    /// - `Range<Ordinal>.count` returns `Cardinal`
    /// - `Range<Index<Element>>.count` returns `Index<Element>.Count`
    @inlinable
    public var count: Bound.Count {
        try! lowerBound.distance.forward(to: upperBound)
    }
}

// MARK: - Factory Methods

extension Swift.Range where Bound: Ordinal.`Protocol` {
    /// Creates a range from a start position and count.
    ///
    /// - Parameters:
    ///   - start: The first position in the range.
    ///   - count: The number of positions in the range.
    ///
    /// This is a total operation: `start + count >= start` is guaranteed
    /// because both are non-negative, so the Range invariant holds.
    @inlinable
    public init(start: Bound, count: Bound.Count) {
        unsafe self.init(uncheckedBounds: (lower: start, upper: start + count))
    }
}
