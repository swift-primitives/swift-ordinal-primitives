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

// MARK: - Position + Offset → Position

/// Advances an ordinal by an offset.
///
/// - Throws: `Ordinal.Error.negativeValue` if the result would be negative.
@inlinable
public func + (lhs: Ordinal, rhs: Ordinal.Offset) throws(Ordinal.Error) -> Ordinal {
    try Ordinal(lhs.rawValue + rhs.rawValue)
}

/// Advances an ordinal by an offset (commutative).
///
/// - Throws: `Ordinal.Error.negativeValue` if the result would be negative.
@inlinable
public func + (lhs: Ordinal.Offset, rhs: Ordinal) throws(Ordinal.Error) -> Ordinal {
    try Ordinal(lhs.rawValue + rhs.rawValue)
}

/// Retreats an ordinal by an offset.
///
/// - Throws: `Ordinal.Error.negativeValue` if the result would be negative.
@inlinable
public func - (lhs: Ordinal, rhs: Ordinal.Offset) throws(Ordinal.Error) -> Ordinal {
    try Ordinal(lhs.rawValue - rhs.rawValue)
}

// MARK: - Position - Position → Offset

/// Returns the signed offset between two ordinals.
///
/// The result is positive if `lhs > rhs`, negative if `lhs < rhs`.
@inlinable
public func - (lhs: Ordinal, rhs: Ordinal) -> Ordinal.Offset {
    Ordinal.Offset(lhs.rawValue - rhs.rawValue)
}

// MARK: - Offset ± Offset → Offset

/// Adds two offsets.
@inlinable
public func + (lhs: Ordinal.Offset, rhs: Ordinal.Offset) -> Ordinal.Offset {
    Ordinal.Offset(lhs.rawValue + rhs.rawValue)
}

/// Subtracts two offsets.
@inlinable
public func - (lhs: Ordinal.Offset, rhs: Ordinal.Offset) -> Ordinal.Offset {
    Ordinal.Offset(lhs.rawValue - rhs.rawValue)
}

/// Negates an offset.
@inlinable
public prefix func - (offset: Ordinal.Offset) -> Ordinal.Offset {
    Ordinal.Offset(-offset.rawValue)
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
