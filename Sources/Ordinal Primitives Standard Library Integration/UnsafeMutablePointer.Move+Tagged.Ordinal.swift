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
import Property_Primitives
public import Tagged_Primitives

// MARK: - Tag Type

extension UnsafeMutablePointer where Pointee: ~Copyable {
    /// Tag for move operations on typed pointers.
    public enum Move {}
}

// MARK: - Accessor

extension UnsafeMutablePointer where Pointee: ~Copyable {
    /// Namespace for move operations.
    ///
    /// Use this accessor for move-based initialization and update:
    ///
    /// ```swift
    /// pointer.move.initialize(from: source, count: count)
    /// pointer.move.update(from: source, count: count)
    /// ```
    @inlinable
    public var move: Property_Primitives.Property<Move, Self> {
        unsafe Property_Primitives.Property(self)
    }
}

// MARK: - Property Extension

extension Property_Primitives.Property {

    /// Moves instances from source memory into uninitialized memory.
    ///
    /// The source memory is left uninitialized after the move.
    ///
    /// - Parameters:
    ///   - source: A pointer to the values to move.
    ///   - count: The number of values to move.
    @inlinable
    public func initialize<Pointee: ~Copyable>(
        from source: UnsafeMutablePointer<Pointee>,
        count: Tagged<Pointee, Ordinal>.Count
    ) where Tag == UnsafeMutablePointer<Pointee>.Move, Base == UnsafeMutablePointer<Pointee> {
        unsafe base.moveInitialize(
            from: source,
            count: Int(bitPattern: count.underlying)
        )
    }

    /// Moves instances from source memory to replace values at this pointer.
    ///
    /// The source memory is left uninitialized after the move.
    /// The destination memory must already be initialized.
    ///
    /// - Parameters:
    ///   - source: A pointer to the values to move.
    ///   - count: The number of values to move.
    @inlinable
    public func update<Pointee>(
        from source: UnsafeMutablePointer<Pointee>,
        count: Tagged<Pointee, Ordinal>.Count
    ) where Tag == UnsafeMutablePointer<Pointee>.Move, Base == UnsafeMutablePointer<Pointee> {
        unsafe base.moveUpdate(from: source, count: Int(bitPattern: count.underlying))
    }
}
