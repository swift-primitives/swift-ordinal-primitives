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

// MARK: - ExpressibleByIntegerLiteral

extension Ordinal: ExpressibleByIntegerLiteral {
    /// Creates a position from an unsigned integer literal.
    ///
    /// This conformance is total (cannot fail) because the literal type is `UInt`,
    /// which matches the backing type. Negative literals are compile-time errors.
    ///
    /// ```swift
    /// let position: Ordinal = 5  // OK
    /// let invalid: Ordinal = -1  // Compile error: negative literal
    /// ```
    @_disfavoredOverload
    @inlinable
    public init(integerLiteral value: UInt) {
        self.init(value)
    }
}
