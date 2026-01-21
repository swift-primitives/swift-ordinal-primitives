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

public import Affine_Primitives

/// A non-negative ordinal position.
///
/// Wraps `Affine.Discrete.Position` with a throwing initializer for
/// backwards compatibility with code that expects errors on invalid input.
///
/// > Migration: Consider using `Affine.Discrete.Position` directly for
/// > failable (Optional-returning) construction, which avoids error handling
/// > overhead.
///
/// ## Semantic Model
///
/// An ordinal is a non-negative integer representing position in an ordered
/// sequence. Unlike raw integers:
/// - Ordinals are non-negative (position 0, 1, 2, ...)
/// - Ordinals represent **where** not **how many**
/// - Arithmetic on ordinals produces typed offsets, not more ordinals
///
/// ## Example
///
/// ```swift
/// let position = try Ordinal(5)
/// let offset = Ordinal.Offset(3)
/// let newPosition = try position + offset  // Ordinal(8)
/// let distance = newPosition - position    // Offset(3)
/// ```
public struct Ordinal: Hashable, Comparable, Sendable {
    /// The underlying discrete position.
    public let position: Affine.Discrete.Position

    /// The underlying position value.
    @inlinable
    public var rawValue: Int { position.rawValue }

    /// Creates an ordinal at the given position.
    ///
    /// - Parameter rawValue: The position value. Must be non-negative.
    /// - Throws: `Ordinal.Error.negativeValue` if `rawValue < 0`.
    @inlinable
    public init(_ rawValue: Int) throws(Ordinal.Error) {
        guard rawValue >= 0 else {
            throw .negativeValue(rawValue)
        }
        self.position = Affine.Discrete.Position(__unchecked: (), rawValue)
    }

    /// Creates an ordinal from a validated position.
    @inlinable
    public init(_ position: Affine.Discrete.Position) {
        self.position = position
    }

    /// Creates an ordinal without bounds checking.
    ///
    /// - Parameter rawValue: Must be non-negative.
    /// - Warning: No validation is performed. Use only when the value
    ///   is known to be non-negative.
    @inlinable
    public init(__unchecked rawValue: Int) {
        self.position = Affine.Discrete.Position(__unchecked: (), rawValue)
    }

    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.position < rhs.position
    }
}

// MARK: - ExpressibleByIntegerLiteral
//
// Ordinal intentionally does NOT conform to ExpressibleByIntegerLiteral.
//
// The checked initializer `init(_ rawValue: Int)` throws for negative values,
// and ExpressibleByIntegerLiteral requires a non-throwing initializer.
//
// To create an ordinal:
// - Checked: `try Ordinal(5)` - throws if negative
// - Unchecked: `Ordinal(__unchecked: 5)` - caller guarantees non-negative

// MARK: - CustomStringConvertible

extension Ordinal: CustomStringConvertible {
    public var description: String {
        "Ordinal(\(rawValue))"
    }
}
