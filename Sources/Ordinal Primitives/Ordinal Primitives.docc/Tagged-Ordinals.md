# Tagged Ordinals

@Metadata {
    @TitleHeading("Topical Article")
}

Phantom-tagged position types — `Tagged<Slot, Ordinal>`, `Tagged<Lane, Ordinal>` — for per-domain navigation that the type system enforces.

## Overview

Bare ``Ordinal_Primitives_Core/Ordinal`` is *unscoped*: an ordinal position with `Domain = Never`. When two unrelated domains both index by position — slot-positions in a buffer and lane-positions in a queue, say — using bare `Ordinal` for both lets the compiler accept code that the domains forbid:

```swift
let slot: Ordinal = 3
let lane: Ordinal = 2
let mixed = slot + Cardinal(1)              // Ordinal(4) — but is this a slot or a lane? Both, neither.
```

`Tagged<Tag, Ordinal>` adds a phantom `Tag` to the position so the type system distinguishes:

```swift
extension Slot {}
extension Lane {}

let slot: Tagged<Slot, Ordinal> = 3
let lane: Tagged<Lane, Ordinal> = 2

let nextSlot = slot + .one                  // Tagged<Slot, Ordinal>(4)
// let mixed = slot + lane                  // ❌ compile error — Tag mismatch
```

The phantom carries no runtime cost; it is a compile-time discriminant.

## The `Count` associatedtype

The interesting design move in `Tagged<Tag, Ordinal>` is the per-conformer concrete `Count`. ``Ordinal_Primitives_Core/Ordinal/Protocol-swift.protocol`` declares:

```swift
public protocol `Protocol` {
    associatedtype Domain: ~Copyable
    associatedtype Count: Carrier.\`Protocol\`<Cardinal>
    var ordinal: Ordinal { get }
    init(_ ordinal: Ordinal)
}
```

The two conformers in this package set `Count` concretely:

```swift
extension Ordinal: Ordinal.\`Protocol\` {
    public typealias Domain = Never
    public typealias Count = Cardinal
}

extension Tagged: Ordinal.\`Protocol\` where Underlying: Ordinal.\`Protocol\`, Tag: ~Copyable {
    public typealias Domain = Tag
    public typealias Count = Tagged<Tag, Cardinal>
}
```

The `static func + (lhs: Self, rhs: Count) -> Self` operator on `Ordinal.\`Protocol\`` reads as `slot + .one` — `.one` infers as `Self.Count.one` (`Cardinal.one` for bare `Ordinal`, `Tagged<Slot, Cardinal>.one` for `Tagged<Slot, Ordinal>`). The per-conformer concreteness is the load-bearing reason `Ordinal.\`Protocol\`` is a SIBLING to `Carrier.\`Protocol\`<Ordinal>` rather than a refinement: refinement-side associated-type defaults are not admissible in Swift, so the sibling form is the only path to the `.one`-infers ergonomic.

## Sibling-not-refinement protocol shape

`Ordinal.\`Protocol\`` and `Carrier.\`Protocol\`<Ordinal>` coexist on the same conforming types. Each protocol carries a different role:

| Protocol | Role | Conformance shape |
|----------|------|-------------------|
| `Carrier.\`Protocol\`<Ordinal>` | Cross-type generic dispatch (e.g., `func describe<C: Carrier.\`Protocol\`<Ordinal>>(_:)`) | `Underlying = Ordinal` (trivial self-carrier on bare `Ordinal`; `Underlying = Ordinal` on `Tagged<Tag, Ordinal>` via the Tagged-Carrier conditional conformance) |
| `Ordinal.\`Protocol\`` | Operator-ergonomics with per-conformer `Count` | `Domain` and `Count` per-conformer concrete |

Consumers needing typed-advance ergonomics constrain on `some Ordinal.\`Protocol\``; consumers needing cross-type generic dispatch constrain on `some Carrier.\`Protocol\`<Ordinal>`. Both protocols are required-via-implementation (not via refinement) on the conformers, matching the same pattern that `Hash.\`Protocol\`` / `Equation.\`Protocol\`` / `Comparison.\`Protocol\`` use to coexist with Carrier per the capability-lift convention.

## Standard-library integration

`Tagged<Tag, Ordinal>` extends the bridges its bare counterpart ships:

- `Tagged: Ordinal.\`Protocol\`` — same conformance shape; `Domain = Tag`, `Count = Tagged<Tag, Cardinal>`.
- `Tagged: AtomicRepresentable` (`@retroactive`) where `Underlying == Ordinal, Tag: ~Copyable` — atomic storage round-trips via the underlying `UInt`.
- `Span`, `MutableSpan`, `OutputSpan`, `UnsafeBufferPointer`, `UnsafeMutableBufferPointer`, `UnsafePointer`, `UnsafeMutablePointer` accept `Tagged<Tag, Ordinal>` subscripts via the `some Ordinal.\`Protocol\`` overload set in the Standard Library Integration target.
- `Array.init(count:_:)` accepts a `Tagged<Tag, Cardinal>` count and yields elements indexed by `Tagged<Tag, Ordinal>`, preserving the phantom domain through construction.

```swift
let workers: [Worker] = Array(count: poolSize) { (slot: Tagged<Slot, Ordinal>) in
    Worker(slot)                            // slot is phantom-tagged at construction
}
```

## When to use bare `Ordinal` vs `Tagged<Tag, Ordinal>`

Use bare `Ordinal` when:

- The position is local to a single computation and does not cross into a domain where slot-vs-lane confusion is possible.
- The consumer is a generic primitive that operates on any `some Ordinal.\`Protocol\`` and does not constrain on a specific `Domain`.

Use `Tagged<Tag, Ordinal>` when:

- The position threads through public API where a domain mismatch would be a real bug (slot-positions in a buffer pool, lane-positions in a scheduler, sequence-positions in a parser).
- The consumer benefits from the type-system-enforced separation between domain-distinct position spaces.

The bare and tagged paths share the same operator and accessor surface; the only difference is the phantom discriminant the type system carries.
