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
public import Ordinal_Error_Primitives
public import Ordinal_Namespace
public import Ordinal_Protocol_Primitives
public import Property_Primitives
public import Tagged_Primitives

// MARK: - Tagged<Tag, Ordinal>.Distance

extension Tagged where Underlying == Ordinal, Tag: ~Copyable {
    /// Tag for distance operations on tagged ordinals.
    public enum Distance {}
}

// MARK: - Tagged<Tag, Ordinal> Distance (Property-based)

extension Tagged where Underlying == Ordinal, Tag: ~Copyable {
    /// Access to distance operations between phantom-typed ordinal positions.
    ///
    /// Ordinal distance is directional — it only computes forward distances.
    /// - `.distance.forward(to:)` — throws if target is behind
    @inlinable
    public var distance: Property<Distance, Self> {
        Property(self)
    }
}

extension Property {
    /// Computes the forward distance to another position.
    ///
    /// This operation is directional: it only succeeds when `other >= self`.
    ///
    /// Returns `Tagged<T, Cardinal>` — the phantom-typed cardinal distance,
    /// preserving the phantom tag from the operand.
    ///
    /// - Parameter other: The target position.
    /// - Returns: The cardinal distance from `self` to `other`.
    /// - Throws: `Ordinal.Error.notForward` if `other < self`.
    @inlinable
    public func forward<T: ~Copyable>(to other: Tagged<T, Ordinal>) throws(Ordinal.Error) -> Tagged<T, Ordinal>.Count
    where
        Tag == Tagged<T, Ordinal>.Distance,
        Base == Tagged<T, Ordinal>
    {
        if other.ordinal < base.ordinal {
            throw .notForward
        }
        return Tagged<T, Ordinal>.Count(Cardinal(other.ordinal.rawValue - base.ordinal.rawValue))
    }
}
