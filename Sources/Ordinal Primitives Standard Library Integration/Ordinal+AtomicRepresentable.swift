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

#if SYNCHRONIZATION_AVAILABLE
    public import Synchronization

    // MARK: - Ordinal + AtomicRepresentable

    extension Ordinal: AtomicRepresentable {
        /// The atomic storage representation used to back ``Ordinal`` in ``Synchronization/Atomic``.
        ///
        /// Mirrors `UInt`'s atomic representation since `Ordinal` is a single-`UInt` value type.
        public typealias AtomicRepresentation = UInt.AtomicRepresentation

        /// Encodes an ordinal position into its atomic storage representation.
        @inlinable
        public static func encodeAtomicRepresentation(
            _ value: consuming Ordinal
        ) -> AtomicRepresentation {
            UInt.encodeAtomicRepresentation(value.rawValue)
        }

        /// Decodes an atomic storage representation back into an ordinal position.
        @inlinable
        public static func decodeAtomicRepresentation(
            _ representation: consuming AtomicRepresentation
        ) -> Ordinal {
            Ordinal(UInt.decodeAtomicRepresentation(representation))
        }
    }
#endif
