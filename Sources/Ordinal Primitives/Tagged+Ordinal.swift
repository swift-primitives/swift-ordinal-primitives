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

public import Identity_Primitives

// MARK: - Tagged<Tag, Ordinal> Properties and Constants

extension Tagged where RawValue == Ordinal, Tag: ~Copyable {
    /// The underlying ordinal position.
    @inlinable
    public var position: Ordinal { rawValue }

    /// The zero position.
    @inlinable
    public static var zero: Self { .init(__unchecked: (), .zero) }
}

// MARK: - Tagged<Tag, Ordinal> Construction

extension Tagged where RawValue == Ordinal, Tag: ~Copyable {
    /// Creates a tagged ordinal from an ordinal.
    @inlinable
    public init(_ position: Ordinal) {
        self.init(__unchecked: (), position)
    }

    /// Creates a tagged ordinal from a signed integer.
    ///
    /// - Parameter position: The position value. Must be non-negative.
    /// - Throws: `Ordinal.Error.negativeSource` if position is negative.
    @inlinable
    public init(_ position: Int) throws(Ordinal.Error) {
        self.init(__unchecked: (), try Ordinal(position))
    }
}

// MARK: - Tagged<Tag, Ordinal> ↔ Tagged<Tag, Cardinal> Conversion

extension Tagged where RawValue == Ordinal, Tag: ~Copyable {
    /// Creates a tagged ordinal from a tagged cardinal.
    ///
    /// This is total - Cardinal is non-negative, so the resulting Ordinal is valid.
    @inlinable
    public init(_ count: Tagged<Tag, Cardinal>) {
        self.init(__unchecked: (), Ordinal(count.rawValue))
    }
}

extension Tagged where RawValue == Cardinal, Tag: ~Copyable {
    /// Creates a tagged cardinal from a tagged ordinal.
    ///
    /// Semantically, position N means "N elements precede this position",
    /// so the count equals the position's numeric value.
    @inlinable
    public init(_ index: Tagged<Tag, Ordinal>) {
        self.init(__unchecked: (), Cardinal(index.rawValue))
    }
}

// MARK: - Tagged<Tag, Ordinal> + Tagged<Tag, Cardinal> → Tagged<Tag, Ordinal>

/// Phantom-typed ordinal advancement by cardinal.
///
/// These operators enable type-safe index arithmetic where an ordinal position
/// is advanced by a cardinal count. The phantom type ensures that only
/// positions and counts from the same domain can be combined.
///
/// ## Example
///
/// ```swift
/// let index: Tagged<Element, Ordinal> = ...
/// let count: Tagged<Element, Cardinal> = ...
/// let advanced = index + count  // OK: same Tag
///
/// let otherCount: Tagged<Other, Cardinal> = ...
/// // index + otherCount  // Compile error: different Tags
/// ```

extension Tagged where RawValue == Ordinal, Tag: ~Copyable {
    /// Advances a tagged ordinal by a tagged cardinal.
    ///
    /// This is a total operation - both ordinal and cardinal are non-negative,
    /// so the result is always valid (may trap on overflow).
    @inlinable
    public static func + (lhs: Self, rhs: Tagged<Tag, Cardinal>) -> Self {
        Self(__unchecked: (), lhs.rawValue + rhs.rawValue)  // Delegates to Ordinal + Cardinal
    }

    /// Advances a tagged ordinal by a tagged cardinal in place.
    @inlinable
    public static func += (lhs: inout Self, rhs: Tagged<Tag, Cardinal>) {
        lhs = lhs + rhs
    }
}

/// Advances a tagged ordinal by a tagged cardinal (commutative).
@inlinable
public func + <Tag: ~Copyable>(
    lhs: Tagged<Tag, Cardinal>,
    rhs: Tagged<Tag, Ordinal>
) -> Tagged<Tag, Ordinal> {
    rhs + lhs
}

// MARK: - Tagged<Tag, Ordinal> % Tagged<Tag, Cardinal> → Tagged<Tag, Ordinal>

extension Tagged where RawValue == Ordinal, Tag: ~Copyable {
    /// Projects a tagged ordinal into a bounded range.
    ///
    /// This is the canonical operation for ring buffer wrap-around:
    /// `position % capacity` yields a position within `[0, capacity)`.
    ///
    /// - Precondition: `rhs > 0` (division by zero traps).
    @inlinable
    public static func % (lhs: Self, rhs: Tagged<Tag, Cardinal>) -> Self {
        Self(__unchecked: (), lhs.rawValue % rhs.rawValue)  // Delegates to Ordinal % Cardinal
    }
}

// MARK: - Tagged<Tag, Ordinal> ↔ Tagged<Tag, Cardinal> Comparisons

/// Cross-type comparisons between ordinals and cardinals.
///
/// These operators are disfavored so that same-type comparisons
/// (Cardinal > Cardinal, Ordinal > Ordinal) are preferred during type inference.
/// This prevents ambiguity when using `.zero` with a known LHS type.
///
/// The canonical bounds check `position < count` still works - you just need
/// both sides to have explicit types.

@inlinable
@_disfavoredOverload
public func < <Tag: ~Copyable>(
    lhs: Tagged<Tag, Ordinal>,
    rhs: Tagged<Tag, Cardinal>
) -> Bool {
    lhs.rawValue < rhs.rawValue  // Delegates to Ordinal < Cardinal
}

@inlinable
@_disfavoredOverload
public func <= <Tag: ~Copyable>(
    lhs: Tagged<Tag, Ordinal>,
    rhs: Tagged<Tag, Cardinal>
) -> Bool {
    lhs.rawValue <= rhs.rawValue
}

@inlinable
@_disfavoredOverload
public func > <Tag: ~Copyable>(
    lhs: Tagged<Tag, Ordinal>,
    rhs: Tagged<Tag, Cardinal>
) -> Bool {
    lhs.rawValue > rhs.rawValue
}

@inlinable
@_disfavoredOverload
public func >= <Tag: ~Copyable>(
    lhs: Tagged<Tag, Ordinal>,
    rhs: Tagged<Tag, Cardinal>
) -> Bool {
    lhs.rawValue >= rhs.rawValue
}

// Reverse direction (Cardinal ↔ Ordinal)
//
// These cross-type operators are disfavored so that same-type comparisons
// (Cardinal > Cardinal, Ordinal > Ordinal) are preferred during type inference.
// This prevents ambiguity when using `.zero` with a known LHS type.

@inlinable
@_disfavoredOverload
public func < <Tag: ~Copyable>(
    lhs: Tagged<Tag, Cardinal>,
    rhs: Tagged<Tag, Ordinal>
) -> Bool {
    lhs.rawValue < rhs.rawValue  // Delegates to Cardinal < Ordinal
}

@inlinable
@_disfavoredOverload
public func <= <Tag: ~Copyable>(
    lhs: Tagged<Tag, Cardinal>,
    rhs: Tagged<Tag, Ordinal>
) -> Bool {
    lhs.rawValue <= rhs.rawValue
}

@inlinable
@_disfavoredOverload
public func > <Tag: ~Copyable>(
    lhs: Tagged<Tag, Cardinal>,
    rhs: Tagged<Tag, Ordinal>
) -> Bool {
    lhs.rawValue > rhs.rawValue
}

@inlinable
@_disfavoredOverload
public func >= <Tag: ~Copyable>(
    lhs: Tagged<Tag, Cardinal>,
    rhs: Tagged<Tag, Ordinal>
) -> Bool {
    lhs.rawValue >= rhs.rawValue
}

// MARK: - Int Conversions for Tagged<Tag, Ordinal>

extension Int {
    /// Creates an integer from a tagged ordinal, returning `nil` if it exceeds `Int.max`.
    @inlinable
    public init?<Tag: ~Copyable>(exactly position: Tagged<Tag, Ordinal>) {
        self.init(exactly: position.rawValue)
    }

    /// Creates an integer from a tagged ordinal, throwing if it exceeds `Int.max`.
    @inlinable
    public init<Tag: ~Copyable>(_ position: Tagged<Tag, Ordinal>) throws(Ordinal.Error) {
        self = try Int(position.rawValue)
    }

    /// Creates an integer by reinterpreting the tagged ordinal's bit pattern.
    ///
    /// This is an unchecked conversion for low-level operations like pointer arithmetic.
    @inlinable
    public init<Tag: ~Copyable>(bitPattern position: Tagged<Tag, Ordinal>) {
        self = Int(bitPattern: position.rawValue)
    }
}

