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

public import Tagged_Primitives

// MARK: - MutableSpan + Tagged<Element, Ordinal>.Count

extension Swift.MutableSpan where Element: ~Copyable {
    /// Creates a mutable span from a start address and typed count.
    ///
    /// - Parameters:
    ///   - start: A pointer to the start of the span.
    ///   - count: The number of elements in the span as a typed count.
    /// - Warning: The caller must ensure lifetime safety.
    @_lifetime(immortal)
    @inlinable
    public init(
        _unsafeStart start: UnsafeMutablePointer<Element>,
        count: Tagged<Element, Ordinal>.Count
    ) {
        let span = unsafe Swift.MutableSpan(
            _unsafeStart: start,
            count: Int(bitPattern: count.underlying)
        )
        unsafe (self = _overrideLifetime(span, borrowing: ()))
    }
}
