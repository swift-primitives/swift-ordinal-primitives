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

public import Identity_Primitives

/// Retreat operations for phantom-typed ordinals.
public struct TaggedOrdinalRetreat<Tag: ~Copyable>: ~Copyable {
    @usableFromInline
    let base: Tagged<Tag, Ordinal>

    @inlinable
    init(base: Tagged<Tag, Ordinal>) {
        self.base = base
    }

    /// Retreats by a count, clamping to a dynamic bound.
    ///
    /// - Parameters:
    ///   - count: The cardinal amount to retreat by.
    ///   - bound: The minimum position to clamp to.
    /// - Returns: The new position, clamped to `bound` if it would go below it.
    @inlinable
    public func clamped(
        by count: Tagged<Tag, Cardinal>,
        to bound: Tagged<Tag, Ordinal>
    ) -> Tagged<Tag, Ordinal> {
        Tagged<Tag, Ordinal>(
            __unchecked: (),
            base.rawValue.retreat.clamped(by: count.rawValue, to: bound.rawValue)
        )
    }
}
