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

// MARK: - RangeReplaceableCollection + Ordinal.Protocol

extension RangeReplaceableCollection where Self.Index == Int {
    /// Inserts a new element into the collection at the specified ordinal position.
    ///
    /// Typed-Ordinal overload mirroring stdlib's
    /// `RangeReplaceableCollection.insert(_:at: Self.Index)`. Constrained to
    /// `Self.Index == Int` so it applies to `Array`, `ContiguousArray`,
    /// `ArraySlice`, and any other `Int`-indexed `RangeReplaceableCollection`
    /// conformer with one declaration.
    ///
    /// Accepts any `Ordinal.`Protocol`` conformer (bare `Ordinal` or
    /// phantom-typed `Tagged<Tag, Ordinal>`), removing the
    /// `Int(bitPattern:)` dance at the call site.
    ///
    /// - Parameters:
    ///   - newElement: The new element to insert into the collection.
    ///   - i: The ordinal position at which to insert the new element.
    @inlinable
    public mutating func insert(_ newElement: __owned Element, at i: some Ordinal.`Protocol`) {
        self.insert(newElement, at: Int(bitPattern: i.ordinal))
    }

    /// Removes and returns the element at the specified ordinal position.
    ///
    /// Typed-Ordinal overload mirroring stdlib's
    /// `RangeReplaceableCollection.remove(at: Self.Index) -> Element`.
    /// Constrained to `Self.Index == Int` so it applies to `Array`,
    /// `ContiguousArray`, `ArraySlice`, and any other `Int`-indexed
    /// `RangeReplaceableCollection` conformer with one declaration.
    ///
    /// Accepts any `Ordinal.`Protocol`` conformer (bare `Ordinal` or
    /// phantom-typed `Tagged<Tag, Ordinal>`), removing the
    /// `Int(bitPattern:)` dance at the call site.
    ///
    /// - Parameter i: The ordinal position of the element to remove.
    /// - Returns: The removed element.
    @discardableResult
    @inlinable
    public mutating func remove(at i: some Ordinal.`Protocol`) -> Element {
        self.remove(at: Int(bitPattern: i.ordinal))
    }
}
