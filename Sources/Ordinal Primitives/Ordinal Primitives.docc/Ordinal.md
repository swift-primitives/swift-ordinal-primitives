# ``Ordinal_Primitives_Core/Ordinal``

@Metadata {
    @DisplayName("Ordinal")
    @TitleHeading("Ordinal Primitives")
}

A non-negative finite ordinal number representing a position in a well-order.

## Overview

`Ordinal` answers the question *"which one?"*. It is backed by `UInt` so that non-negativity is a property of the representation, not a runtime check — there is no construction path that produces a negative ordinal at runtime, and the type system rejects negative literals at compile time.

```swift
let first: Ordinal = 0          // OK — UInt-typed literal
let invalid: Ordinal = -1       // ❌ compile error
```

The navigation surface splits across distinct policy-aware accessors so the consumer chooses overflow handling at each call site:

- **`.successor`** (single-step forward) — `.saturating()` clamps at `UInt.max`; `.exact()` throws ``Error/overflow``.
- **`.predecessor`** (single-step backward) — `.exact()` throws ``Error/underflow`` at zero. There is no `.predecessor.saturating()` because saturating predecessor would always return zero at position zero, which is semantically meaningless (unlike saturating at a maximum bound).
- **`.advance`** (forward by a cardinal-carrying count) — `.saturating(by:)`, `.exact(by:)`, `.clamped(by:to:)`.
- **`.retreat`** (backward by a cardinal-carrying count) — `.exact(by:)`, `.clamped(by:to:)`.
- **`.distance`** (directional measurement) — `.forward(to:)` throws ``Error/notForward`` if `other < self`; `.unchecked(to:)` for proven-monotonic call sites where the precondition holds by invariant.

## No `-` operator

Ordinal does **not** provide a `-` operator. Predecessor of zero is undefined for ordinals; there is no negative position. The two policy variants — `.predecessor.exact()` (throws ``Error/underflow``) and `.retreat.clamped(by:to:)` (clamps at a dynamic minimum) — make the partiality explicit at the call site:

```swift
let zero = Ordinal.zero
let prev = try zero.predecessor.exact()                     // throws .underflow

let three: Ordinal = 3
let clamped = three.retreat.clamped(by: Cardinal(10), to: .zero)   // 0 (clamped)
```

Hiding partiality behind a `-` operator would silently produce wrong values; making the consumer choose a policy is the typed alternative.

## No backward distance

`distance.forward(to:)` is directional — it throws ``Error/notForward`` when `other < self`. Signed displacement between positions is the domain of `Affine` (the third Story-1 package, succeeding launch). For the proven-monotonic case where the consumer's invariant guarantees the forward precondition (e.g., `lowerBound <= upperBound` on a `Range`), use `.distance.unchecked(to:)` to elide the runtime check.

## Construction

```swift
public init(_ value: UInt)                                  // Total
public init?(exactly value: Int)                            // Returns nil on negative input
public init(_ value: Int) throws(Ordinal.Error)             // Throws .negativeSource(Int) on negative input
```

`Ordinal: ExpressibleByIntegerLiteral` accepts unsigned literals; negative literals are compile-time errors. The `Int`-taking init is the standard escape hatch when the source is signed, with the rejected value carried in ``Error/negativeSource(_:)``.

## Conformances

| Protocol | Source | Notes |
|----------|--------|-------|
| `Hashable`, `Comparable`, `Sendable` | Auto-synthesized via `let rawValue: UInt`. |  |
| `CustomStringConvertible` | Renders the underlying `UInt`. |  |
| `Equation.\`Protocol\`` | Cross-package via `swift-equation-primitives`. | Ordinal explicit `==` matches the synthesized version. |
| `Comparison.\`Protocol\`` | Cross-package via `swift-comparison-primitives`. | Ordinal explicit `<`, `<=`, `>`, `>=` match the synthesized versions; explicit overloads exist to satisfy the protocol's exact-shape requirement. |
| `Hash.\`Protocol\`` | Cross-package via `swift-hash-primitives`. |  |
| `Carrier.\`Protocol\`` | Cross-package via `swift-carrier-primitives`. | Trivial self-carrier (`Underlying = Ordinal`). The `Domain` associated type defaults to `Never`. |
| `Ordinal.\`Protocol\`` | This package. | SIBLING to `Carrier.\`Protocol\`<Ordinal>`, not a refinement. `Count = Cardinal`, `Domain = Never`. |
| `AtomicRepresentable` | Cross-package via `Synchronization`. | `AtomicRepresentation = UInt.AtomicRepresentation`; encode/decode round-trip via the underlying `UInt`. |

## Constants

```swift
public static var zero: Ordinal { Ordinal(UInt.zero) }
```

`Ordinal.zero` is the canonical anchor — the first position in a well-order. There is no `Ordinal.one` or `Ordinal.max` because those values are semantically expressed as `Ordinal(1)` / `Ordinal(UInt.max)`; the `.zero` accessor exists because it is the algebraic identity for `+ Cardinal`.
