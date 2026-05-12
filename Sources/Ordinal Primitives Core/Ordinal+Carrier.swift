// Ordinal+Carrier.swift
// Ordinal conforms to Carrier.`Protocol` as a trivial-self-carrier — provides
// cross-type generic dispatch (Form-D algorithms, `some Carrier.`Protocol`<Ordinal>`).
//
// The typed-advance ergonomics (`Self + Self.Count → Self`) live on
// `Ordinal.`Protocol`` as a sibling protocol — Carrier has no
// `Count` associatedtype to host the per-conformer dispatch. See:
// `swift-institute/Research/operator-ergonomics-and-carrier-migration.md`.

public import Carrier_Primitives

// MARK: - Carrier Conformance (trivial self-carrier)

extension Ordinal: Carrier.`Protocol` {
    /// Ordinal IS its own Underlying.
    public typealias Underlying = Ordinal

    // `Domain` defaults to `Never` per the Carrier protocol declaration.
    // `var underlying` and `init(_:)` are inherited from the
    // `Carrier.`Protocol` where Underlying == Self` default extension.
}
