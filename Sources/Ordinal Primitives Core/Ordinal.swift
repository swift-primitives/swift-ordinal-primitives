/// Namespace for ordinal number types.
///
/// Ordinal numbers answer the question "which one?" — they denote position
/// in a well-ordered sequence. Unlike cardinals (which count quantity),
/// ordinals indicate rank or order.
///
/// ## Scope
///
/// This package provides finite ordinals for programming use:
/// - `Ordinal` — a non-negative position backed by `UInt`
///
/// Transfinite ordinals (ω, ω+1, etc.) are explicitly out of scope.
/// This is "finite ordinals for programming," not set-theoretic ordinal arithmetic.

/// A finite ordinal number representing position in a well-order.
///
/// `Ordinal` answers "which one?" with a non-negative integer.
/// It is backed by `UInt` to make non-negativity representational
/// rather than runtime-checked.
///
/// ## Usage
///
/// ```swift
/// let first = Ordinal.zero
/// let second = try first.successor.exact()
///
/// // Advance by a cardinal amount
/// let fifth = try first.advance.exact(by: Cardinal(4))
///
/// // Compute distance (throws if not forward)
/// let distance = try first.distance.forward(to: fifth)  // Cardinal(4)
/// ```
///
/// ## Design
///
/// - **Backing**: `UInt` (machine word) ensures non-negativity at the type level
/// - **Successor/Predecessor**: Policy-aware operations for navigation
/// - **Distance**: Always returns `Cardinal` (unsigned), throws if not forward
public struct Ordinal {
    /// The underlying unsigned integer value.
    public let rawValue: UInt
}

// Stdlib Hashable / Comparable conformances are gated `#if swift(<6.4)` only.
// On Swift 6.4+ each institute `*.Protocol` is a typealias to its stdlib
// counterpart per SE-0499, so the unconditional institute conformance in the
// per-protocol files (`Ordinal+Hash.Protocol.swift`,
// `Ordinal+Comparison.Protocol.swift`) IS the stdlib conformance. Both lines
// would error as duplicate conformance on 6.4. Pattern matches
// swift-pair-primitives / swift-either-primitives.
#if swift(<6.4)
    extension Ordinal: Hashable {}
    extension Ordinal: Comparable {}
#endif
extension Ordinal: Sendable {}

extension Ordinal {

    // MARK: - Construction

    /// Creates a position from an unsigned integer.
    ///
    /// - Parameter value: The non-negative position value.
    @inlinable
    public init(_ value: UInt) {
        self.rawValue = value
    }

    // MARK: - Constants

    /// The zero position (first element in a well-order).
    @inlinable
    public static var zero: Self { Ordinal(UInt.zero) }
}

extension Ordinal {
    // MARK: - Equatable / Equation.Protocol

    /// Explicit equality for Equatable/Equation.Protocol compatibility.
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue == rhs.rawValue
    }

    // MARK: - Comparable / Comparison.Protocol

    /// Returns `true` if `lhs` precedes `rhs` in the well-order.
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    /// Returns `true` if `lhs` does not follow `rhs` in the well-order.
    @inlinable
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue <= rhs.rawValue
    }

    /// Returns `true` if `lhs` follows `rhs` in the well-order.
    @inlinable
    public static func > (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue > rhs.rawValue
    }

    /// Returns `true` if `lhs` does not precede `rhs` in the well-order.
    @inlinable
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue >= rhs.rawValue
    }
}
