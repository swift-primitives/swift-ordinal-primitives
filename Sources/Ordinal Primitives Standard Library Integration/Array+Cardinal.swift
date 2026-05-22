// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-primitives open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-primitives
// project authors. Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

public import Cardinal_Primitives
public import Cardinal_Primitives_Standard_Library_Integration
public import Ordinal_Primitive
public import Tagged_Primitives

// MARK: - Array + Tagged<Tag, Cardinal>

extension Array {
    /// Creates an array by evaluating a closure for each ordinal position
    /// up to a tagged cardinal count.
    ///
    /// The closure receives the typed ordinal position, preserving the
    /// phantom tag from the cardinal count:
    ///
    /// ```swift
    /// let executors = Array(count: threadCount) { _ in Executor() }
    /// let workers = Array(count: poolSize) { position in Worker(position) }
    /// ```
    ///
    /// - Parameters:
    ///   - count: The number of elements to create.
    ///   - element: A closure that receives the typed ordinal position
    ///     and returns an element.
    /// - Throws: Whatever error type `element` throws (typed via `E`).
    @inlinable
    public init<Tag: ~Copyable, E: Swift.Error>(
        count: Tagged<Tag, Cardinal>,
        _ element: (Tagged<Tag, Ordinal>) throws(E) -> Element
    ) throws(E) {
        let n = Int(bitPattern: count.underlying)
        self = try (0..<n).map { (index: Int) throws(E) -> Element in
            try element(Tagged<Tag, Ordinal>(Ordinal(UInt(index))))
        }
    }
}
