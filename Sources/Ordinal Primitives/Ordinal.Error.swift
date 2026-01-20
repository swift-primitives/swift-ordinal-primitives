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

extension Ordinal {
    /// Errors that can occur when constructing or operating on ordinals.
    ///
    /// Ordinals represent non-negative positions. Operations that would
    /// produce a negative result are represented as errors rather than
    /// runtime crashes.
    public enum Error: Swift.Error, Hashable, Sendable {
        /// The provided value was negative.
        ///
        /// Ordinals must be non-negative (0, 1, 2, ...). This error
        /// occurs when attempting to construct an ordinal from a
        /// negative integer or when an arithmetic operation would
        /// produce a negative result.
        ///
        /// - Parameter value: The negative value that was rejected.
        case negativeValue(Int)
    }
}
