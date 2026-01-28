# Ordinal Primitives Insights

<!--
---
title: Ordinal Primitives Insights
version: 1.0.0
last_updated: 2026-01-28
applies_to: [swift-ordinal-primitives]
normative: false
---
-->

@Metadata {
    @TitleHeading("Ordinal Primitives")
}

Design decisions, implementation patterns, and lessons learned specific to this package.

## Overview

This document captures insights that emerged during development of swift-ordinal-primitives. These are not API requirements—they are recorded decisions and patterns that inform future work on this package.

**Document type**: Non-normative (recorded decisions, not requirements).

**Consolidation source**: Reflection entries tagged with `[Package: swift-ordinal-primitives]`.

---

## Dynamic Bounds vs Static Saturation

**Date**: 2026-01-28

**Context**: Adding clamped advancement that respects caller-specified bounds rather than saturating to UInt.max.

Ordinal Primitives had `.advance.saturating(by:)` which clamps to `UInt.max`. This is appropriate for some uses—"advance as far as possible without overflow"—but inappropriate for bounded iteration where the meaningful maximum is a loop bound, not the type's maximum representable value.

`.advance.clamped(by:to:)` takes both an increment count and a dynamic bound:

```swift
public func clamped(by count: Cardinal, to bound: Base) -> Base {
    let (result, overflow) = base.rawValue.addingReportingOverflow(count.rawValue)
    if overflow || result > bound.rawValue {
        return bound
    }
    return Base(result)
}
```

The operation advances by `count`, but clamps at `bound` if the result would exceed it. This is O(1)—no iteration, just arithmetic with overflow detection.

The same pattern applies to retreat: `.retreat.clamped(by:to:)` decrements but clamps at a lower bound. For iteration, this means "go back N positions, but not past the start."

Range.Lazy's drop and prefix operations use clamped advancement internally:

```swift
let newStart = base.start.advance.clamped(by: count, to: base.end)
```

This computes the new range bound in O(1) without iteration. The clamping handles the edge case where `count` exceeds the range size—you get the endpoint, not an overflow.

**Applies to**: `Ordinal.Position.Advance.clamped(by:to:)`, `Ordinal.Position.Retreat.clamped(by:to:)`, bounded iteration.

---

## Topics

### Related Documents

- <doc:Ordinal-Position>
- <doc:Ordinal-Position-Advance>
- <doc:Ordinal-Position-Retreat>
