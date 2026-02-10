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

// MARK: - UnsafeRawPointer + Ordinal.Protocol

extension UnsafeRawPointer {
    /// Returns a raw pointer advanced by the given ordinal byte offset.
    ///
    /// - Parameter offset: The ordinal byte offset to advance by.
    /// - Returns: A raw pointer offset from this pointer by `offset` bytes.
    @inlinable
    public func advanced<O: Ordinal.`Protocol`>(by offset: O) -> Self {
        unsafe self.advanced(by: Int(bitPattern: offset.ordinal))
    }

    /// Loads a value of the given type from this pointer at an ordinal byte offset.
    ///
    /// - Parameters:
    ///   - offset: The ordinal byte offset to load from.
    ///   - type: The type of value to load.
    /// - Returns: The value loaded from the specified offset.
    @inlinable
    public func load<O: Ordinal.`Protocol`, T>(fromByteOffset offset: O, as type: T.Type) -> T {
        unsafe self.load(fromByteOffset: Int(bitPattern: offset.ordinal), as: type)
    }
}
