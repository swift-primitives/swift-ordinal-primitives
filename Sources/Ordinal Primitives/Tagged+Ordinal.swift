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
