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

// MARK: - Span + Tagged<Element, Ordinal>.Count

extension Swift.Span where Element: ~Copyable {
    /// Creates a span from a start address and typed count.
    ///
    /// - Parameters:
    ///   - start: A pointer to the start of the span.
    ///   - count: The number of elements in the span as a typed count.
    /// - Warning: The caller must ensure lifetime safety.
    @_lifetime(immortal)
    @inlinable
    public init(
        _unsafeStart start: UnsafePointer<Element>,
        count: Tagged<Element, Ordinal>.Count
    ) {
        let span = unsafe Swift.Span(
            _unsafeStart: start,
            count: Int(bitPattern: count.underlying)
        )
        unsafe (self = _overrideLifetime(span, borrowing: ()))
    }
}
