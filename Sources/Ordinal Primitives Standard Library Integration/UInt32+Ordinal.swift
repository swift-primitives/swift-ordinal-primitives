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

// MARK: - Ordinal to UInt32 Conversion

extension UInt32 {
    /// Creates a 32-bit unsigned integer from any ordinal position.
    ///
    /// Accepts bare `Ordinal` and phantom-typed `Tagged<Tag, Ordinal>` /
    /// `Index<Element>` etc. via `Ordinal.`Protocol`` conformance. Removes the
    /// `UInt32(Int(bitPattern: ...))` intermediate dance at the call site.
    ///
    /// - Parameter position: The ordinal position.
    /// - Precondition: The position's value must fit in `UInt32`.
    @inlinable
    public init(_ position: some Ordinal.`Protocol`) {
        self = UInt32(position.ordinal.rawValue)
    }
}
