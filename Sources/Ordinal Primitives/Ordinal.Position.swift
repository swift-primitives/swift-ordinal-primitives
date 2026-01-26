extension Ordinal {
    /// A finite ordinal number representing position in a well-order.
    ///
    /// `Ordinal.Position` answers "which one?" with a non-negative integer.
    /// It is backed by `UInt` to make non-negativity representational
    /// rather than runtime-checked.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let first = Ordinal.Position.zero
    /// let second = try first.successor.exact()
    ///
    /// // Advance by a cardinal amount
    /// let fifth = try first.advance.exact(by: Cardinal.Count(4))
    ///
    /// // Compute distance (throws if not forward)
    /// let distance = try first.distance.forward(to: fifth)  // Cardinal.Count(4)
    /// ```
    ///
    /// ## Design
    ///
    /// - **Backing**: `UInt` (machine word) ensures non-negativity at the type level
    /// - **Successor/Predecessor**: Policy-aware operations for navigation
    /// - **Distance**: Always returns `Cardinal.Count` (unsigned), throws if not forward
    public struct Position: Hashable, Comparable, Sendable {
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
}

// MARK: - Protocol Conformances

extension Ordinal.Position: Equation.`Protocol` {}
extension Ordinal.Position: Comparison.`Protocol` {}
