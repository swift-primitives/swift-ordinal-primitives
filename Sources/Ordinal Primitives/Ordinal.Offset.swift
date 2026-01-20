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

extension Ordinal {
    /// A signed offset between ordinal positions.
    ///
    /// Represents the directed distance between two ordinals. The sign
    /// indicates direction: positive offsets move forward (toward higher
    /// indices), negative offsets move backward.
    ///
    /// ## Semantic Model
    ///
    /// An offset is the result of subtracting two ordinals:
    /// - `position2 - position1 → offset`
    /// - `position1 + offset → position2`
    ///
    /// Offsets form a group under addition (can be combined, negated,
    /// have identity 0), while ordinals do not (no negative positions).
    ///
    /// ## Example
    ///
    /// ```swift
    /// let forward: Ordinal.Offset = 5
    /// let backward: Ordinal.Offset = -3
    /// let combined = forward + backward  // Offset(2)
    /// ```
    public struct Offset: Hashable, Comparable, Sendable {
        /// The underlying signed value.
        public let rawValue: Int

        /// Creates an offset with the given signed value.
        @inlinable
        public init(_ rawValue: Int) {
            self.rawValue = rawValue
        }

        @inlinable
        public static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Ordinal.Offset: ExpressibleByIntegerLiteral {
    @inlinable
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}

// MARK: - CustomStringConvertible

extension Ordinal.Offset: CustomStringConvertible {
    public var description: String {
        "Offset(\(rawValue))"
    }
}
