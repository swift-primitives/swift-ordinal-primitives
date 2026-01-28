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

    /// Creates a tagged ordinal by retagging from another tag domain.
    ///
    /// This is a total operation - retagging preserves the position value.
    @inlinable
    public init<Other: ~Copyable>(_ other: Tagged<Other, RawValue>) {
        self.init(__unchecked: (), other.rawValue)
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

    /// Creates a tagged ordinal from a tagged cardinal in a different domain.
    @inlinable
    public init<Other: ~Copyable>(_ count: Tagged<Other, Cardinal>) {
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

    /// Creates a tagged cardinal from a tagged ordinal in a different domain.
    @inlinable
    public init<Other: ~Copyable>(_ index: Tagged<Other, Ordinal>) {
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

/// Checks if a tagged ordinal is less than a tagged cardinal.
///
/// This is the canonical bounds check: `position < count` means the position
/// is a valid index for a collection of the given count.
@inlinable
public func < <Tag: ~Copyable>(
    lhs: Tagged<Tag, Ordinal>,
    rhs: Tagged<Tag, Cardinal>
) -> Bool {
    lhs.rawValue < rhs.rawValue  // Delegates to Ordinal < Cardinal
}

@inlinable
public func <= <Tag: ~Copyable>(
    lhs: Tagged<Tag, Ordinal>,
    rhs: Tagged<Tag, Cardinal>
) -> Bool {
    lhs.rawValue <= rhs.rawValue
}

@inlinable
public func > <Tag: ~Copyable>(
    lhs: Tagged<Tag, Ordinal>,
    rhs: Tagged<Tag, Cardinal>
) -> Bool {
    lhs.rawValue > rhs.rawValue
}

@inlinable
public func >= <Tag: ~Copyable>(
    lhs: Tagged<Tag, Ordinal>,
    rhs: Tagged<Tag, Cardinal>
) -> Bool {
    lhs.rawValue >= rhs.rawValue
}

// Reverse direction

@inlinable
public func < <Tag: ~Copyable>(
    lhs: Tagged<Tag, Cardinal>,
    rhs: Tagged<Tag, Ordinal>
) -> Bool {
    lhs.rawValue < rhs.rawValue  // Delegates to Cardinal < Ordinal
}

@inlinable
public func <= <Tag: ~Copyable>(
    lhs: Tagged<Tag, Cardinal>,
    rhs: Tagged<Tag, Ordinal>
) -> Bool {
    lhs.rawValue <= rhs.rawValue
}

@inlinable
public func > <Tag: ~Copyable>(
    lhs: Tagged<Tag, Cardinal>,
    rhs: Tagged<Tag, Ordinal>
) -> Bool {
    lhs.rawValue > rhs.rawValue
}

@inlinable
public func >= <Tag: ~Copyable>(
    lhs: Tagged<Tag, Cardinal>,
    rhs: Tagged<Tag, Ordinal>
) -> Bool {
    lhs.rawValue >= rhs.rawValue
}
