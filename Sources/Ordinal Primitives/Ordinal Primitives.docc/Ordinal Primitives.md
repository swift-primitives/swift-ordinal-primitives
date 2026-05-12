# ``Ordinal_Primitives``

@Metadata {
    @DisplayName("Ordinal Primitives")
    @TitleHeading("Swift Institute — Primitives Layer")
}

A typed ordinal-number primitive — `Ordinal`, a non-negative position in a well-order, with policy-aware navigation and a phantom-tagged variant for per-domain position types.

## Overview

`Ordinal Primitives` ships ``Ordinal_Primitives_Core/Ordinal``, a value type backed by `UInt` that answers the question *"which one?"*. Ordinal is non-negative by representation: the `UInt` backing makes negativity unrepresentable rather than checked-and-rejected at runtime. Navigation is policy-aware — `.successor` / `.predecessor` / `.advance` / `.retreat` / `.distance` accessors expose saturating, exact (throwing), and clamped variants so the consumer chooses overflow handling at each call site.

Ordinal is the second of three packages in **Story 1 of the data-structures cohort**: cardinal (count), ordinal (position), affine (offset) — three things stdlib calls `Int`. The package also ships `Tagged<Tag, Ordinal>` navigation accessors so per-domain position types (`Tagged<Slot, Ordinal>`, `Tagged<Lane, Ordinal>`) compose naturally with the Tagged primitive.

The operator-ergonomics protocol ``Ordinal_Primitives_Core/Ordinal/Protocol-swift.protocol`` is a **sibling** to `Carrier.Protocol<Ordinal>`, not a refinement. The protocol's `Count` associatedtype is per-conformer concrete (`Cardinal` for bare `Ordinal`; `Tagged<Tag, Cardinal>` for `Tagged<Tag, Ordinal>`) so `slot + .one` infers `.one` cleanly at call sites without explicit typing.

## Topics

### Essentials

- <doc:Ordinal>
- <doc:Tagged-Ordinals>

### Core Type

- ``Ordinal_Primitives_Core/Ordinal``
- ``Ordinal_Primitives_Core/Ordinal/Error``
- ``Ordinal_Primitives_Core/Ordinal/Protocol-swift.protocol``

### Navigation Accessors

- ``Ordinal_Primitives_Core/Ordinal/Successor``
- ``Ordinal_Primitives_Core/Ordinal/Predecessor``
- ``Ordinal_Primitives_Core/Ordinal/Advance``
- ``Ordinal_Primitives_Core/Ordinal/Retreat``
- ``Ordinal_Primitives_Core/Ordinal/Distance``

### Standard-Library Integration

- ``Swift/Int/init(_:)-3ordinal``
- ``Swift/Int/init(exactly:)-2ordinal``
- ``Swift/Int/init(bitPattern:)-1ordinal``
- ``Swift/Range``
