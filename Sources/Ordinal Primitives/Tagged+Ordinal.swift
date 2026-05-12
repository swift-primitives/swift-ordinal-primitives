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

// MARK: - Tagged<Tag, Ordinal> Properties and Constants

extension Tagged where Underlying == Ordinal, Tag: ~Copyable {
    /// The underlying ordinal position.
    @inlinable
    public var position: Ordinal { underlying }

    /// The zero position.
    @inlinable
    public static var zero: Self { .init(_unchecked: .zero) }
}

// MARK: - Tagged<Tag, Ordinal> ↔ Tagged<Tag, Cardinal> Conversion

extension Tagged where Underlying == Cardinal, Tag: ~Copyable {
    /// Creates a tagged cardinal from a tagged ordinal.
    ///
    /// Semantically, position N means "N elements precede this position",
    /// so the count equals the position's numeric value.
    @inlinable
    public init(_ index: Tagged<Tag, Ordinal>) {
        self = index.map(Cardinal.init)
    }
}

// MARK: - Int Conversions for Tagged<Tag, Ordinal>

extension Int {
    /// Creates an integer from a tagged ordinal, returning `nil` if it exceeds `Int.max`.
    @inlinable
    public init?<Tag: ~Copyable>(exactly position: Tagged<Tag, Ordinal>) {
        self.init(exactly: position.underlying)
    }

    /// Creates an integer from a tagged ordinal, throwing if it exceeds `Int.max`.
    @inlinable
    public init<Tag: ~Copyable>(_ position: Tagged<Tag, Ordinal>) throws(Ordinal.Error) {
        self = try Int(position.underlying)
    }

    /// Creates an integer by reinterpreting the tagged ordinal's bit pattern.
    ///
    /// This is an unchecked conversion for low-level operations like pointer arithmetic.
    @inlinable
    public init<Tag: ~Copyable>(bitPattern position: Tagged<Tag, Ordinal>) {
        self = Int(bitPattern: position.underlying)
    }
}
