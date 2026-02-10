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

// MARK: - Tagged<Tag, Ordinal> ↔ Tagged<Tag, Cardinal> Conversion

extension Tagged where RawValue == Cardinal, Tag: ~Copyable {
    /// Creates a tagged cardinal from a tagged ordinal.
    ///
    /// Semantically, position N means "N elements precede this position",
    /// so the count equals the position's numeric value.
    @inlinable
    public init(_ index: Tagged<Tag, Ordinal>) {
        self = index.map(Cardinal.init)
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
///
/// ## Future: Domain-based Unification
///
/// These operators duplicate the bare Ordinal + Cardinal operators from
/// Ordinal+Cardinal.swift. Full unification via generic operators with
/// `where O.Domain == C.Domain` is blocked by Swift's requirement that
/// associated types be `Copyable`. When `Tag: ~Copyable`, we cannot
/// satisfy `Domain = Tag`.
///
/// See: swift-cardinal-primitives/Experiments/tag-preserving-protocol-abstraction/
/// for the validated design that would enable full unification once Swift
/// allows `associatedtype Domain: ~Copyable`.

extension Tagged where RawValue == Ordinal, Tag: ~Copyable {
    /// Advances a tagged ordinal by a tagged cardinal.
    ///
    /// This is a total operation - both ordinal and cardinal are non-negative,
    /// so the result is always valid (may trap on overflow).
    @inlinable
    public static func + (lhs: Self, rhs: Tagged<Tag, Cardinal>) -> Self {
        lhs.map { $0 + rhs.rawValue }  // Delegates to Ordinal + Cardinal
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
        lhs.map { $0 % rhs.rawValue }  // Delegates to Ordinal % Cardinal
    }
}

// MARK: - Tagged<Tag, Ordinal.Protocol> ↔ Tagged<Tag, Cardinal> Comparisons

/// Cross-type comparisons between ordinal-carrying types and cardinals.
///
/// These operators accept any `Ordinal.Protocol` conformer as the raw value,
/// enabling comparisons for both unbounded ordinals (`Tagged<Tag, Ordinal>`)
/// and bounded ordinals (`Tagged<Tag, Ordinal.Finite<N>>`).
///
/// These operators are disfavored so that same-type comparisons
/// (Cardinal > Cardinal, Ordinal > Ordinal) are preferred during type inference.
/// This prevents ambiguity when using `.zero` with a known LHS type.
///
/// The canonical bounds check `position < count` works for both:
/// - `Index<Element> < Index<Element>.Count`
/// - `Index<Element>.Bounded<N> < Index<Element>.Count`

@inlinable
@_disfavoredOverload
public func < <Tag: ~Copyable, R: Ordinal.`Protocol`>(
    lhs: Tagged<Tag, R>,
    rhs: Tagged<Tag, Cardinal>
) -> Bool {
    lhs.rawValue.ordinal < rhs.rawValue  // Delegates to Ordinal < Cardinal
}

@inlinable
@_disfavoredOverload
public func <= <Tag: ~Copyable, R: Ordinal.`Protocol`>(
    lhs: Tagged<Tag, R>,
    rhs: Tagged<Tag, Cardinal>
) -> Bool {
    lhs.rawValue.ordinal <= rhs.rawValue
}

@inlinable
@_disfavoredOverload
public func > <Tag: ~Copyable, R: Ordinal.`Protocol`>(
    lhs: Tagged<Tag, R>,
    rhs: Tagged<Tag, Cardinal>
) -> Bool {
    lhs.rawValue.ordinal > rhs.rawValue
}

@inlinable
@_disfavoredOverload
public func >= <Tag: ~Copyable, R: Ordinal.`Protocol`>(
    lhs: Tagged<Tag, R>,
    rhs: Tagged<Tag, Cardinal>
) -> Bool {
    lhs.rawValue.ordinal >= rhs.rawValue
}

// Reverse direction (Cardinal ↔ Ordinal.Protocol)
//
// These cross-type operators are disfavored so that same-type comparisons
// (Cardinal > Cardinal, Ordinal > Ordinal) are preferred during type inference.
// This prevents ambiguity when using `.zero` with a known LHS type.

@inlinable
@_disfavoredOverload
public func < <Tag: ~Copyable, R: Ordinal.`Protocol`>(
    lhs: Tagged<Tag, Cardinal>,
    rhs: Tagged<Tag, R>
) -> Bool {
    lhs.rawValue < rhs.rawValue.ordinal  // Delegates to Cardinal < Ordinal
}

@inlinable
@_disfavoredOverload
public func <= <Tag: ~Copyable, R: Ordinal.`Protocol`>(
    lhs: Tagged<Tag, Cardinal>,
    rhs: Tagged<Tag, R>
) -> Bool {
    lhs.rawValue <= rhs.rawValue.ordinal
}

@inlinable
@_disfavoredOverload
public func > <Tag: ~Copyable, R: Ordinal.`Protocol`>(
    lhs: Tagged<Tag, Cardinal>,
    rhs: Tagged<Tag, R>
) -> Bool {
    lhs.rawValue > rhs.rawValue.ordinal
}

@inlinable
@_disfavoredOverload
public func >= <Tag: ~Copyable, R: Ordinal.`Protocol`>(
    lhs: Tagged<Tag, Cardinal>,
    rhs: Tagged<Tag, R>
) -> Bool {
    lhs.rawValue >= rhs.rawValue.ordinal
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
