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

/// Advance operations for phantom-typed ordinals.
public struct TaggedOrdinalAdvance<Tag: ~Copyable>: ~Copyable {
    @usableFromInline
    let base: Tagged<Tag, Ordinal>

    @inlinable
    init(base: Tagged<Tag, Ordinal>) {
        self.base = base
    }

    /// Advances by a count, clamping to a dynamic bound.
    ///
    /// - Parameters:
    ///   - count: The cardinal amount to advance by.
    ///   - bound: The maximum position to clamp to.
    /// - Returns: The new position, clamped to `bound` if it would exceed it.
    @inlinable
    public func clamped(
        by count: Tagged<Tag, Cardinal>,
        to bound: Tagged<Tag, Ordinal>
    ) -> Tagged<Tag, Ordinal> {
        Tagged<Tag, Ordinal>(
            __unchecked: (),
            base.rawValue.advance.clamped(by: count.rawValue, to: bound.rawValue)
        )
    }
}
