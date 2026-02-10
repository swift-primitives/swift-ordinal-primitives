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

// MARK: - ContiguousArray + Ordinal.Protocol

extension ContiguousArray {
    /// Accesses an element at an ordinal position.
    ///
    /// This subscript accepts any `Ordinal.Protocol` conformer, enabling
    /// both bare `Ordinal` and phantom-typed `Tagged<Tag, Ordinal>` as indices.
    ///
    /// - Parameter position: The ordinal position to access.
    /// - Returns: The element at the specified position.
    /// - Precondition: `position` must be a valid index for the array.
    @inlinable
    public subscript<O: Ordinal.`Protocol`>(position position_: O) -> Element {
        get {
            self[Int(bitPattern: position_.ordinal)]
        }
        set {
            self[Int(bitPattern: position_.ordinal)] = newValue
        }
    }
}
