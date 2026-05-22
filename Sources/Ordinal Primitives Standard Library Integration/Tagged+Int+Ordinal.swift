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

public import Ordinal_Error_Primitives
public import Ordinal_Primitive
public import Tagged_Primitives

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
