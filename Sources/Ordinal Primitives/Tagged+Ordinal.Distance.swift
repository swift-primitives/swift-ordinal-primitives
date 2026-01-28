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
public import Property_Primitives

// MARK: - Tagged<Tag, Ordinal>.Distance

extension Tagged where RawValue == Ordinal, Tag: ~Copyable {
    /// Tag for distance operations on tagged ordinals.
    public enum Distance {}
}

// MARK: - Tagged<Tag, Ordinal> Distance (Property-based)

extension Tagged where RawValue == Ordinal, Tag: ~Copyable {
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
    /// - Parameter other: The target position.
    /// - Returns: The cardinal distance from `self` to `other`.
    /// - Throws: `Ordinal.Error.notForward` if `other < self`.
    @inlinable
    public func forward<T: ~Copyable>(to other: Tagged<T, Ordinal>) throws(Ordinal.Error) -> Tagged<T, Cardinal>
    where
    Tag == Tagged<T, Ordinal>.Distance,
    Base == Tagged<T, Ordinal> {
        Tagged<T, Cardinal>(
            __unchecked: (),
            try base.rawValue.distance.forward(to: other.rawValue)
        )
    }
}
