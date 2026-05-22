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
public import Property_Primitives

extension Ordinal {
    /// Tag type for retreat operations.
    public enum Retreat {}

    /// Policy-aware retreat operations.
    ///
    /// Use this accessor to move backward by a cardinal amount:
    /// - `.retreat.clamped(by:to:)` — clamps at a dynamic bound
    /// - `.retreat.exact(by:)` — throws on underflow
    @inlinable
    public var retreat: Property<Retreat, Self> {
        Property(self)
    }
}

extension Property where Tag == Ordinal.Retreat, Base == Ordinal {
    /// Retreats by a count, throwing on underflow.
    ///
    /// - Parameter count: The cardinal amount to retreat by.
    /// - Returns: The new position.
    /// - Throws: `Ordinal.Error.underflow` if the result would be negative.
    @inlinable
    public func exact(by count: Cardinal) throws(Base.Error) -> Base {
        if count.rawValue > base.rawValue {
            throw .underflow
        }
        return Base(base.rawValue - count.rawValue)
    }

    /// Retreats by a count, clamping to a dynamic bound.
    ///
    /// Use this for bounded operations where retreating beyond a limit
    /// should clamp rather than underflow or throw.
    ///
    /// - Parameters:
    ///   - count: The cardinal amount to retreat by.
    ///   - bound: The minimum position to clamp to.
    /// - Returns: The new position, clamped to `bound` if it would go below it.
    @inlinable
    public func clamped(by count: Cardinal, to bound: Base) -> Base {
        // Check if retreat would go below bound
        if count.rawValue > base.rawValue - bound.rawValue {
            return bound
        }
        return Base(base.rawValue - count.rawValue)
    }
}
