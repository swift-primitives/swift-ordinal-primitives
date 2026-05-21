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

// MARK: - MutableCollection + Ordinal.Protocol

extension MutableCollection where Self.Index == Int {
    /// Exchanges the elements at the two ordinal positions.
    ///
    /// Typed-Ordinal overload mirroring stdlib's
    /// `MutableCollection.swapAt(_:_: Self.Index)`. Constrained to
    /// `Self.Index == Int` so it applies to `Array`, `ContiguousArray`,
    /// `ArraySlice`, and any other `Int`-indexed `MutableCollection`
    /// conformer with one declaration.
    ///
    /// Accepts any `Ordinal.`Protocol`` conformer (bare `Ordinal` or
    /// phantom-typed `Tagged<Tag, Ordinal>`), removing the
    /// `Int(bitPattern:)` dance at the call site.
    ///
    /// - Parameters:
    ///   - i: The position of the first element to be swapped.
    ///   - j: The position of the second element to be swapped.
    @inlinable
    public mutating func swapAt(_ i: some Ordinal.`Protocol`, _ j: some Ordinal.`Protocol`) {
        self.swapAt(Int(bitPattern: i.ordinal), Int(bitPattern: j.ordinal))
    }
}
