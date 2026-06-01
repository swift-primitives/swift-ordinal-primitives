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

public import Cardinal_Primitives
public import Ordinal_Cardinal_Primitives
public import Ordinal_Primitive
public import Tagged_Primitives

// MARK: - Tagged<Tag, Ordinal> Properties and Constants

extension Tagged where Underlying == Ordinal, Tag: ~Copyable & ~Escapable {
    /// The underlying ordinal position.
    @inlinable
    public var position: Ordinal { underlying }

    /// The zero position.
    @inlinable
    public static var zero: Self { .init(_unchecked: .zero) }
}

// MARK: - Tagged<Tag, Ordinal> ↔ Tagged<Tag, Cardinal> Conversion

extension Tagged where Underlying == Cardinal, Tag: ~Copyable & ~Escapable {
    /// Creates a tagged cardinal from a tagged ordinal.
    ///
    /// Semantically, position N means "N elements precede this position",
    /// so the count equals the position's numeric value.
    @inlinable
    public init(_ index: Tagged<Tag, Ordinal>) {
        self = index.map(Cardinal.init)
    }
}
