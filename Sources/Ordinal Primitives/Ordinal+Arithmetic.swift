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

// Ordinal Affine Arithmetic
//
// Ordinal follows affine space semantics:
// - Ordinal + Offset → Ordinal (throws if result would be negative)
// - Ordinal - Offset → Ordinal (throws if result would be negative)
// - Ordinal - Ordinal → Offset
// - Offset ± Offset → Offset

// MARK: - Ordinal + Offset → Ordinal (Point + Vector → Point)

/// Advances an ordinal by an offset.
///
/// - Throws: `Ordinal.Error.negativeValue` if the result would be negative.
@inlinable
public func + (lhs: Ordinal, rhs: Ordinal.Offset) throws(Ordinal.Error) -> Ordinal {
    guard let pos = lhs.position + rhs.displacement else {
        throw .negativeValue(lhs.rawValue + rhs.rawValue)
    }
    return Ordinal(pos)
}

/// Advances an ordinal by an offset (commutative).
///
/// - Throws: `Ordinal.Error.negativeValue` if the result would be negative.
@inlinable
public func + (lhs: Ordinal.Offset, rhs: Ordinal) throws(Ordinal.Error) -> Ordinal {
    try rhs + lhs
}

// MARK: - Ordinal - Offset → Ordinal (Point - Vector → Point)

/// Retreats an ordinal by an offset.
///
/// - Throws: `Ordinal.Error.negativeValue` if the result would be negative.
@inlinable
public func - (lhs: Ordinal, rhs: Ordinal.Offset) throws(Ordinal.Error) -> Ordinal {
    guard let pos = lhs.position - rhs.displacement else {
        throw .negativeValue(lhs.rawValue - rhs.rawValue)
    }
    return Ordinal(pos)
}

// MARK: - Ordinal - Ordinal → Offset (Point - Point → Vector)

/// Returns the signed offset (displacement) between two ordinals.
///
/// The result is positive if `lhs > rhs`, negative if `lhs < rhs`.
@inlinable
public func - (lhs: Ordinal, rhs: Ordinal) -> Ordinal.Offset {
    Ordinal.Offset(lhs.position - rhs.position)
}

// MARK: - Offset ± Offset → Offset (Vector ± Vector → Vector)

/// Adds two offsets.
@inlinable
public func + (lhs: Ordinal.Offset, rhs: Ordinal.Offset) -> Ordinal.Offset {
    Ordinal.Offset(lhs.displacement + rhs.displacement)
}

/// Subtracts two offsets.
@inlinable
public func - (lhs: Ordinal.Offset, rhs: Ordinal.Offset) -> Ordinal.Offset {
    Ordinal.Offset(lhs.displacement - rhs.displacement)
}

/// Negates an offset.
@inlinable
public prefix func - (offset: Ordinal.Offset) -> Ordinal.Offset {
    Ordinal.Offset(-offset.displacement)
}

// MARK: - Compound Assignment

/// Advances an ordinal by an offset in place.
///
/// - Throws: `Ordinal.Error.negativeValue` if the result would be negative.
@inlinable
public func += (lhs: inout Ordinal, rhs: Ordinal.Offset) throws(Ordinal.Error) {
    lhs = try lhs + rhs
}

/// Retreats an ordinal by an offset in place.
///
/// - Throws: `Ordinal.Error.negativeValue` if the result would be negative.
@inlinable
public func -= (lhs: inout Ordinal, rhs: Ordinal.Offset) throws(Ordinal.Error) {
    lhs = try lhs - rhs
}

/// Adds an offset to another offset in place.
@inlinable
public func += (lhs: inout Ordinal.Offset, rhs: Ordinal.Offset) {
    lhs = lhs + rhs
}

/// Subtracts an offset from another offset in place.
@inlinable
public func -= (lhs: inout Ordinal.Offset, rhs: Ordinal.Offset) {
    lhs = lhs - rhs
}
