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
public struct Ordinal: Hashable, Comparable, Sendable {
    /// The underlying unsigned integer value.
    public let rawValue: UInt

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
    public static var zero: Self { .init(.zero) }

    // MARK: - Equatable / Equation.Protocol

    /// Explicit equality for Equatable/Equation.Protocol compatibility.
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue == rhs.rawValue
    }

    // MARK: - Comparable / Comparison.Protocol

    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    @inlinable
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue <= rhs.rawValue
    }

    @inlinable
    public static func > (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue > rhs.rawValue
    }

    @inlinable
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue >= rhs.rawValue
    }
}
