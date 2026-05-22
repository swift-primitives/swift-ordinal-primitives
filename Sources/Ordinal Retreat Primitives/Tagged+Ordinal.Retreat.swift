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

public import Cardinal_Primitives
public import Ordinal_Primitive
public import Ordinal_Protocol_Primitives
public import Property_Primitives
public import Tagged_Primitives

// MARK: - Tagged<Tag, Ordinal>.Retreat

extension Tagged where Underlying == Ordinal, Tag: ~Copyable {
    /// Tag for retreat operations on tagged ordinals.
    public enum Retreat {}
}

// MARK: - Tagged<Tag, Ordinal> Retreat (Property-based)

extension Tagged where Underlying == Ordinal, Tag: ~Copyable {
    /// Access to policy-aware retreat operations.
    ///
    /// Use this accessor to move backward by a cardinal amount:
    /// - `.retreat.clamped(by:to:)` — clamps at a dynamic bound
    @inlinable
    public var retreat: Property<Retreat, Self> {
        Property(self)
    }
}

extension Property {
    /// Retreats by a count, clamping to a dynamic bound.
    ///
    /// - Parameters:
    ///   - count: The cardinal amount to retreat by.
    ///   - bound: The minimum position to clamp to.
    /// - Returns: The new position, clamped to `bound` if it would go below it.
    @inlinable
    public func clamped<T: ~Copyable>(
        by count: Tagged<T, Cardinal>,
        to bound: Tagged<T, Ordinal>
    ) -> Base
    where
        Tag == Tagged<T, Ordinal>.Retreat,
        Base == Tagged<T, Ordinal>
    {
        base.map { ordinal in ordinal.retreat.clamped(by: count.underlying, to: bound.underlying) }
    }
}
