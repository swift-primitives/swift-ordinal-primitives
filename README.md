# Ordinal Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

A typed ordinal-number primitive — `Ordinal`, a non-negative position in a well-order, with policy-aware navigation (`.successor` / `.predecessor` / `.advance` / `.retreat` / `.distance`) and a phantom-tagged variant `Tagged<Tag, Ordinal>` for per-domain position types.

`Ordinal` separates *position* from the two other things stdlib calls `Int`: **count** (see [`swift-cardinal-primitives`](https://github.com/swift-primitives/swift-cardinal-primitives)) and **signed offset** (see [`swift-affine-primitives`](https://github.com/swift-primitives/swift-affine-primitives)).

---

## Quick Start

```swift
import Ordinal_Primitives

// Bare Ordinal — a non-negative position
let first: Ordinal = 0
let next = try first.successor.exact()                     // 1 (or throws .overflow at UInt.max)
let fifth = try first.advance.exact(by: Cardinal(4))       // 4 (or throws .overflow)
let distance = try first.distance.forward(to: fifth)       // Cardinal(4) (or throws .notForward)

// Phantom-tagged Ordinal — distinct position types per domain
extension Slot {}
extension Lane {}

let slot: Tagged<Slot, Ordinal> = 3
let lane: Tagged<Lane, Ordinal> = 2
// slot + lane                                              // ❌ compile error — different domains
let nextSlot = slot + .one                                  // Tagged<Slot, Ordinal>(4) via Count = Tagged<Slot, Cardinal>
```

Ordinal is backed by `UInt`, which makes non-negativity representational rather than runtime-checked. Distance is directional — `distance.forward(to:)` only succeeds when the target is forward of `self`; signed displacement belongs in `Affine` (Story 1, succeeding launch). The arithmetic surface splits across three policies — saturating, exact, clamped — so the consumer chooses how overflow is handled at each call site.

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-primitives/swift-ordinal-primitives.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Ordinal Primitives", package: "swift-ordinal-primitives"),
    ]
)
```

The package is pre-1.0 — until 0.1.0 is tagged, depend on `branch: "main"` rather than `from: "0.1.0"`. Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain).

---

## Architecture

Four library products covering the bare type, its standard-library integration, the umbrella, and a Test Support target.

| Product | Target | Purpose |
|---------|--------|---------|
| `Ordinal Primitives` | `Sources/Ordinal Primitives/` | Umbrella — re-exports Core and Standard Library Integration; the default import for application code. Adds `Tagged<Tag, Ordinal>` navigation accessors (`.successor`, `.predecessor`, `.advance`, `.retreat`, `.distance`) bridging the Property-based API to phantom-tagged positions. |
| `Ordinal Primitives Core` | `Sources/Ordinal Primitives Core/` | The `Ordinal` type itself — backing `UInt` storage, the `Ordinal.\`Protocol\`` operator-ergonomics protocol with the `Count` associatedtype, the policy-aware `.successor` / `.predecessor` / `.advance` / `.retreat` / `.distance` accessors, and `Ordinal.Error`. |
| `Ordinal Primitives Standard Library Integration` | `Sources/Ordinal Primitives Standard Library Integration/` | Conformances and integration overloads bridging Ordinal into the standard library: `ExpressibleByIntegerLiteral`, `Int(_:Ordinal)` conversions, `AtomicRepresentable`, `Range<Bound: Ordinal.\`Protocol\`>` extensions, and subscripts on `Array` / `ContiguousArray` / `InlineArray` / `UnsafePointer` family that accept `some Ordinal.\`Protocol\``. |
| `Ordinal Primitives Test Support` | `Tests/Support/` | Re-exports the cardinal Test Support fixtures + the umbrella for downstream test consumers. |

Import the narrowest product you need: `Ordinal Primitives Core` for just the type, `Ordinal Primitives` (the umbrella) for the full surface including Standard Library Integration bridges and Tagged-ordinal navigation.

The package depends on seven primitives — `swift-tagged-primitives`, `swift-carrier-primitives`, `swift-property-primitives`, `swift-cardinal-primitives`, `swift-equation-primitives`, `swift-comparison-primitives`, `swift-hash-primitives`. See [Related Packages](#related-packages).

Foundation-free.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 26 | Full support |
| Linux | Full support (CI matrix) |
| Windows | Full support (CI matrix) |
| iOS / tvOS / watchOS / visionOS | Supported |
| Swift Embedded | Supported (no concurrency surface, no Foundation) |

---

## Related Packages

Direct dependencies:

- [swift-cardinal-primitives](https://github.com/swift-primitives/swift-cardinal-primitives) — cohort sibling, providing `Cardinal` (count). Distance between two ordinal positions yields a cardinal-carrying value; advance / retreat / distance APIs accept `some Carrier.\`Protocol\`<Cardinal>`.
- [swift-tagged-primitives](https://github.com/swift-primitives/swift-tagged-primitives) — provides `Tagged<Tag, Underlying>` for the phantom-tagged `Tagged<Tag, Ordinal>` surface.
- [swift-carrier-primitives](https://github.com/swift-primitives/swift-carrier-primitives) — provides `Carrier.\`Protocol\`<Underlying>`, the unified super-protocol Ordinal conforms to (as a trivial self-carrier, `Underlying = Ordinal`).
- [swift-property-primitives](https://github.com/swift-primitives/swift-property-primitives) — provides `Property<Tag, Base>`, the carrier underlying the `.successor` / `.predecessor` / `.advance` / `.retreat` / `.distance` policy-aware accessors.
- [swift-equation-primitives](https://github.com/swift-primitives/swift-equation-primitives) — provides `Equation.\`Protocol\``, the `Equatable`-shape conformance Ordinal exposes.
- [swift-comparison-primitives](https://github.com/swift-primitives/swift-comparison-primitives) — provides `Comparison.\`Protocol\``, the `Comparable`-shape conformance Ordinal exposes.
- [swift-hash-primitives](https://github.com/swift-primitives/swift-hash-primitives) — provides `Hash.\`Protocol\``, the `Hashable`-shape conformance Ordinal exposes.

Companion primitives covering the other two things stdlib calls `Int`:

- [swift-cardinal-primitives](https://github.com/swift-primitives/swift-cardinal-primitives) — `Cardinal`, a non-negative count.
- [swift-affine-primitives](https://github.com/swift-primitives/swift-affine-primitives) — `Affine.Discrete.Vector`, a signed offset between ordinal positions.

---

## Community

<!-- BEGIN: discussion -->
Discuss this package: [swift-institute/discussions/30](https://github.com/orgs/swift-institute/discussions/30)
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
