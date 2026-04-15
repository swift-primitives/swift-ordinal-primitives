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

// MARK: - Tagged<Tag, Ordinal> + AtomicRepresentable

extension Tagged: @retroactive AtomicRepresentable where RawValue == Ordinal, Tag: ~Copyable {
    public typealias AtomicRepresentation = UInt.AtomicRepresentation

    @inlinable
    public static func encodeAtomicRepresentation(
        _ value: consuming Self
    ) -> AtomicRepresentation {
        UInt.encodeAtomicRepresentation(value.ordinal.rawValue)
    }

    @inlinable
    public static func decodeAtomicRepresentation(
        _ representation: consuming AtomicRepresentation
    ) -> Self {
        Self(Ordinal(UInt.decodeAtomicRepresentation(representation)))
    }
}
