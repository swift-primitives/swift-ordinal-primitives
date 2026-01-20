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

/// A non-negative ordinal position.
///
/// Represents a discrete position on an ordered axis. The foundational
/// type for both compile-time bounded ordinals (`Finite.Ordinal<N>`) and
/// runtime bounded indices (`Index<Element>`).
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
    /// The underlying position value.
    public let rawValue: Int

    /// Creates an ordinal at the given position.
    ///
    /// - Parameter rawValue: The position value. Must be non-negative.
    /// - Throws: `Ordinal.Error.negativeValue` if `rawValue < 0`.
    @inlinable
    public init(_ rawValue: Int) throws(Ordinal.Error) {
        guard rawValue >= 0 else { throw .negativeValue(rawValue) }
        self.rawValue = rawValue
    }

    /// Creates an ordinal without bounds checking.
    ///
    /// - Parameter rawValue: Must be non-negative.
    /// - Warning: No validation is performed. Use only when the value
    ///   is known to be non-negative.
    @inlinable
    public init(__unchecked rawValue: Int) {
        self.rawValue = rawValue
    }

    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
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
