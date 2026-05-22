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

public import Ordinal_Primitive
public import Ordinal_Protocol_Primitives

// MARK: - ContiguousArray + Ordinal.Protocol

extension ContiguousArray {
    /// Accesses an element at an ordinal position.
    ///
    /// This subscript accepts any `Ordinal.Protocol` conformer, enabling
    /// both bare `Ordinal` and phantom-typed `Tagged<Tag, Ordinal>` as indices.
    ///
    /// - Parameter position: The ordinal position to access.
    /// - Returns: The element at the specified position.
    @inlinable
    public subscript(_ position: some Ordinal.`Protocol`) -> Element {
        get {
            self[Int(bitPattern: position.ordinal)]
        }
        set {
            self[Int(bitPattern: position.ordinal)] = newValue
        }
    }
}
