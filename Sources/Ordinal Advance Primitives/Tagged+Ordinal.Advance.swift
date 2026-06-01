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

// MARK: - Tagged<Tag, Ordinal>.Advance

extension Tagged where Underlying == Ordinal, Tag: ~Copyable & ~Escapable {
    /// Tag for advance operations on tagged ordinals.
    public enum Advance {}
}

// MARK: - Tagged<Tag, Ordinal> Advance (Property-based)

extension Tagged where Underlying == Ordinal, Tag: ~Copyable & ~Escapable {
    /// Access to policy-aware advance operations.
    ///
    /// Use this accessor to move forward by a cardinal amount:
    /// - `.advance.clamped(by:to:)` — clamps at a dynamic bound
    @inlinable
    public var advance: Property<Advance, Self> {
        Property(self)
    }
}

extension Property {
    /// Advances by a count, clamping to a dynamic bound.
    ///
    /// - Parameters:
    ///   - count: The cardinal amount to advance by.
    ///   - bound: The maximum position to clamp to.
    /// - Returns: The new position, clamped to `bound` if it would exceed it.
    @inlinable
    public func clamped<T: ~Copyable & ~Escapable>(
        by count: Tagged<T, Cardinal>,
        to bound: Tagged<T, Ordinal>
    ) -> Base
    where
        Tag == Tagged<T, Ordinal>.Advance,
        Base == Tagged<T, Ordinal>
    {
        base.map { ordinal in ordinal.advance.clamped(by: count.underlying, to: bound.underlying) }
    }
}
