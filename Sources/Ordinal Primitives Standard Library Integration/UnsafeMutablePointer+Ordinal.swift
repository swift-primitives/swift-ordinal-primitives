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

public import Carrier_Primitives

// MARK: - UnsafeMutablePointer + Ordinal.Protocol

extension UnsafeMutablePointer {
    /// Accesses the element at an ordinal offset from this pointer.
    ///
    /// This subscript accepts any `Ordinal.Protocol` conformer, enabling
    /// both bare `Ordinal` and phantom-typed `Tagged<Tag, Ordinal>` as indices.
    ///
    /// - Parameter position: The ordinal offset from this pointer.
    /// - Returns: The element at the specified offset.
    @inlinable
    public subscript(_ position: some Ordinal.`Protocol`) -> Pointee {
        get {
            unsafe self[Int(bitPattern: position.ordinal)]
        }
        nonmutating set {
            unsafe self[Int(bitPattern: position.ordinal)] = newValue
        }
    }
}
