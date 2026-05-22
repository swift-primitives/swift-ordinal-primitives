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

public import Ordinal_Error_Primitives
public import Ordinal_Primitive
public import Ordinal_Protocol_Primitives
public import Property_Primitives
public import Tagged_Primitives

// MARK: - Tagged<Tag, Ordinal>.Successor

extension Tagged where Underlying == Ordinal, Tag: ~Copyable {
    /// Tag for successor operations on tagged ordinals.
    public enum Successor {}
}

// MARK: - Tagged<Tag, Ordinal> Successor (Property-based)

extension Tagged where Underlying == Ordinal, Tag: ~Copyable {
    /// Access to policy-aware successor operations.
    ///
    /// Use this accessor to navigate forward by one position:
    /// - `.successor.saturating()` — clamps at `UInt.max`
    /// - `.successor.exact()` — throws on overflow
    @inlinable
    public var successor: Property<Successor, Self> {
        Property(self)
    }
}

extension Property {
    /// Returns the next position, saturating at the maximum representable value.
    ///
    /// If at `UInt.max`, returns `UInt.max` (no change).
    ///
    /// - Returns: The next position, clamped to `UInt.max` on overflow.
    @inlinable
    public func saturating<T: ~Copyable>() -> Base
    where
        Tag == Tagged<T, Ordinal>.Successor,
        Base == Tagged<T, Ordinal>
    {
        base.map { ordinal in ordinal.successor.saturating() }
    }

    /// Returns the next position, throwing on overflow.
    ///
    /// - Returns: The next position.
    /// - Throws: `Ordinal.Error.overflow` if at `UInt.max`.
    @inlinable
    public func exact<T: ~Copyable>() throws(Ordinal.Error) -> Base
    where
        Tag == Tagged<T, Ordinal>.Successor,
        Base == Tagged<T, Ordinal>
    {
        try base.map { ordinal throws(Ordinal.Error) in try ordinal.successor.exact() }
    }
}
