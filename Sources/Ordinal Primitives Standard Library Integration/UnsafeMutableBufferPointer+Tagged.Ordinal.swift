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

// MARK: - UnsafeMutableBufferPointer + Tagged<Element, Ordinal>

extension UnsafeMutableBufferPointer where Element: ~Copyable {
    /// Creates a mutable buffer pointer from a start address and typed count.
    ///
    /// - Parameters:
    ///   - start: A pointer to the start of the buffer.
    ///   - count: The number of elements in the buffer as a typed count.
    @inlinable
    public init(
        start: UnsafeMutablePointer<Element>?,
        count: Tagged<Element, Ordinal>.Count
    ) {
        unsafe self.init(start: start, count: Int(bitPattern: count.count))
    }
}

extension UnsafeMutableBufferPointer {
    /// Accesses the element at the given typed index.
    ///
    /// This subscript enables type-safe mutable buffer access using `Tagged<Element, Ordinal>`:
    ///
    /// ```swift
    /// let buffer = UnsafeMutableBufferPointer(start: pointer, count: count)
    /// for i in (0..<count) {
    ///     buffer[i] = computeValue(at: i)  // i is Tagged<Element, Ordinal>
    /// }
    /// ```
    ///
    /// - Parameter index: A typed index into the buffer.
    /// - Returns: The element at the specified index.
    @inlinable
    public subscript(
        _ index: Tagged<Element, Ordinal>
    ) -> Element {
        get {
            unsafe self[Int(bitPattern: index.rawValue)]
        }
        nonmutating set {
            unsafe self[Int(bitPattern: index.rawValue)] = newValue
        }
    }
}
