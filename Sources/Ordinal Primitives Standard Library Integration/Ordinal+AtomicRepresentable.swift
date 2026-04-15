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

public import Synchronization

// MARK: - Ordinal + AtomicRepresentable

extension Ordinal: AtomicRepresentable {
    public typealias AtomicRepresentation = UInt.AtomicRepresentation

    @inlinable
    public static func encodeAtomicRepresentation(
        _ value: consuming Ordinal
    ) -> AtomicRepresentation {
        UInt.encodeAtomicRepresentation(value.rawValue)
    }

    @inlinable
    public static func decodeAtomicRepresentation(
        _ representation: consuming AtomicRepresentation
    ) -> Ordinal {
        Ordinal(UInt.decodeAtomicRepresentation(representation))
    }
}
