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

public import Property_Primitives
public import Tagged_Primitives

// MARK: - Tagged<Tag, Ordinal>.Predecessor

extension Tagged where Underlying == Ordinal, Tag: ~Copyable {
    /// Tag for predecessor operations on tagged ordinals.
    public enum Predecessor {}
}

// MARK: - Tagged<Tag, Ordinal> Predecessor (Property-based)

extension Tagged where Underlying == Ordinal, Tag: ~Copyable {
    /// Access to policy-aware predecessor operations.
    ///
    /// Use this accessor to navigate backward by one position:
    /// - `.predecessor.exact()` — throws at position zero
    @inlinable
    public var predecessor: Property<Predecessor, Self> {
        Property(self)
    }
}

extension Property {
    /// Returns the previous position, throwing at zero.
    ///
    /// - Returns: The previous position.
    /// - Throws: `Ordinal.Error.underflow` if at position zero.
    @inlinable
    public func exact<T: ~Copyable>() throws(Ordinal.Error) -> Base
    where
        Tag == Tagged<T, Ordinal>.Predecessor,
        Base == Tagged<T, Ordinal>
    {
        try base.map { ordinal throws(Ordinal.Error) in try ordinal.predecessor.exact() }
    }
}
