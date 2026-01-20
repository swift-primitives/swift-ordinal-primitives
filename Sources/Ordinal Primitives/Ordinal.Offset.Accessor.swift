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
    /// Accessor for offset operations with failable and clamped variants.
    ///
    /// Use `ordinal.offset(by:)` for the failable version that returns
    /// `nil` on underflow, or `ordinal.offset.clamped(by:)` for the
    /// clamping version.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let position: Ordinal = 5
    ///
    /// // Failable offset
    /// position.offset(by: Offset(-3))   // Ordinal(2)
    /// position.offset(by: Offset(-10))  // nil (would underflow)
    ///
    /// // Clamped offset
    /// position.offset.clamped(by: Offset(-10))  // Ordinal(0)
    /// ```
    public struct OffsetAccessor: Sendable {
        @usableFromInline
        let ordinal: Ordinal

        @usableFromInline
        init(_ ordinal: Ordinal) {
            self.ordinal = ordinal
        }

        /// Returns an ordinal offset by the given amount, or nil if result would be negative.
        ///
        /// - Parameter delta: The signed offset to apply.
        /// - Returns: The offset ordinal, or `nil` if the result would be negative.
        @inlinable
        public func callAsFunction(by delta: Offset) -> Ordinal? {
            let result = ordinal.rawValue + delta.rawValue
            guard result >= 0 else { return nil }
            return Ordinal(__unchecked: result)
        }

        /// Returns an ordinal offset by the given amount, clamped to zero minimum.
        ///
        /// - Parameter delta: The signed offset to apply.
        /// - Returns: The offset ordinal, clamped to `0` if the result would be negative.
        @inlinable
        public func clamped(by delta: Offset) -> Ordinal {
            let result = ordinal.rawValue + delta.rawValue
            return Ordinal(__unchecked: max(0, result))
        }
    }

    /// Accessor for offset operations.
    @inlinable
    public var offset: OffsetAccessor { OffsetAccessor(self) }
}
