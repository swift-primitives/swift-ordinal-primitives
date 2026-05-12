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

// MARK: - OutputSpan + Ordinal.Protocol

extension Swift.OutputSpan where Element: ~Copyable {

    /// Exchanges the elements at the two given ordinal positions.
    ///
    /// Bridges typed `Ordinal.Protocol` positions (including bare `Ordinal`
    /// and phantom-typed `Tagged<Tag, Ordinal>` such as `Index<Element>`)
    /// to the stdlib `Int`-based `swapAt(_:_:)`.
    ///
    /// - Parameters:
    ///   - i: A valid ordinal position in this span.
    ///   - j: A valid ordinal position in this span.
    @inlinable
    @_lifetime(self: copy self)
    public mutating func swapAt(
        _ i: some Ordinal.`Protocol`,
        _ j: some Ordinal.`Protocol`
    ) {
        swapAt(
            Int(bitPattern: i.ordinal),
            Int(bitPattern: j.ordinal)
        )
    }
}
