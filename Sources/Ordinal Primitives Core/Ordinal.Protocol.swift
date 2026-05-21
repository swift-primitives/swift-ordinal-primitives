// Ordinal.Protocol.swift
// Operator-ergonomics protocol for ordinal-carrying types.
//
// `Ordinal.`Protocol`` is a SIBLING to `Carrier.`Protocol`<Ordinal>` (not a
// refinement). Its sole reason to exist is the `associatedtype Count:
// Carrier.`Protocol`<Cardinal>` machinery — per-conformer concrete `Count`
// is what makes `slot + .one` infer cleanly at call sites:
//
//   - Ordinal.Count               == Cardinal              (bare)
//   - Tagged<Slot, Ordinal>.Count == Tagged<Slot, Cardinal> (Tagged)
//
// `Carrier.`Protocol`<Ordinal>` conformance (in `Ordinal+Carrier.swift`)
// handles the cross-type generic-dispatch role; this protocol handles the
// operator-ergonomics role. Both protocols coexist on the same
// conforming types — same precedent as `Hash.`Protocol``,
// `Equation.`Protocol``, `Comparison.`Protocol`` coexisting with
// Carrier per capability-lift-pattern.md Recommendation #6.
//
// Resolution: `swift-institute/Research/operator-ergonomics-and-carrier-migration.md`
// (RECOMMENDATION, 2026-04-26).

public import Cardinal_Primitives
public import Carrier_Primitives
public import Tagged_Primitives

// MARK: - Protocol

extension Ordinal {
    /// A type that carries an ordinal position with associated typed-advance
    /// ergonomics — `Self + Self.Count → Self`.
    ///
    /// Conformers wrap or represent an `Ordinal` value and can round-trip
    /// through it. The `Count` associatedtype provides per-conformer
    /// concrete operator dispatch:
    ///
    /// - `Ordinal.Count == Cardinal`
    /// - `Tagged<Tag, Ordinal>.Count == Tagged<Tag, Cardinal>`
    ///
    /// At call sites, `slot + .one` resolves cleanly because `Self.Count`
    /// is concrete per conformer.
    ///
    /// ## Relationship to Carrier
    ///
    /// `Ordinal.`Protocol`` is a SIBLING to `Carrier.`Protocol`<Ordinal>` — it
    /// does not refine Carrier. Conforming types provide both
    /// conformances independently. Consumers needing typed-advance
    /// ergonomics constrain on `some Ordinal.`Protocol``; consumers
    /// needing cross-type generic dispatch (Form-D algorithms,
    /// `func describe<C: Carrier.`Protocol`>(_ c: C)`) constrain on
    /// `some Carrier.`Protocol`<Ordinal>`.
    ///
    /// ## Conformers
    ///
    /// - `Ordinal` — identity (self-conformance), `Count = Cardinal`
    /// - `Tagged<Tag, R: Ordinal.`Protocol`>` — phantom-typed ordinal
    ///   wrapper, `Count = Tagged<Tag, Cardinal>`
    public protocol `Protocol` {
        /// The domain that scopes this ordinal position.
        ///
        /// For bare `Ordinal`, `Domain` is `Never` (unscoped).
        /// For `Tagged<Tag, Ordinal>`, `Domain` is `Tag`, enabling
        /// cross-type operators to enforce same-tag safety via
        /// `where O.Domain == C.Domain`.
        associatedtype Domain: ~Copyable

        /// The cardinal-carrying type that measures distances between
        /// positions in the same `Domain`.
        ///
        /// Per-conformer concreteness lets operators infer `.one` and
        /// other static members at call sites without explicit typing.
        associatedtype Count: Carrier.`Protocol`<Cardinal>

        /// The underlying ordinal value.
        var ordinal: Ordinal { get }

        /// Creates an instance from an ordinal value.
        init(_ ordinal: Ordinal)
    }
}

// MARK: - Ordinal Conformance

extension Ordinal: Ordinal.`Protocol` {
    /// Bare ordinals are unscoped.
    public typealias Domain = Never

    /// The cardinal type for measuring distances between bare ordinals.
    public typealias Count = Cardinal

    /// Returns self.
    @inlinable
    public var ordinal: Ordinal { self }

    /// Creates an ordinal from an ordinal (identity).
    @inlinable
    public init(_ ordinal: Ordinal) {
        self = ordinal
    }
}

// MARK: - Tagged Conformance

extension Tagged: Ordinal.`Protocol` where Underlying: Ordinal.`Protocol`, Tag: ~Copyable {
    /// The phantom type is the domain.
    public typealias Domain = Tag

    /// The cardinal type for measuring distances between tagged ordinals,
    /// preserving the phantom type.
    public typealias Count = Tagged<Tag, Cardinal>

    /// The underlying ordinal value.
    @inlinable
    public var ordinal: Ordinal { underlying.ordinal }

    /// Creates a tagged ordinal from an ordinal value.
    ///
    /// `@_disfavoredOverload` to defer to `Tagged: Carrier.`Protocol``'s
    /// `init(_ underlying: Underlying)` when both apply (same effective
    /// signature for `Underlying == Ordinal`).
    @_disfavoredOverload
    @inlinable
    public init(_ ordinal: Ordinal) {
        self.init(_unchecked: Underlying(ordinal))
    }
}

// MARK: - Arithmetic

extension Ordinal.`Protocol` {
    /// Advances an ordinal position by its associated count type.
    ///
    /// Uses the `Count` associatedtype for phantom-type safety:
    /// - `Ordinal + Cardinal → Ordinal`
    /// - `Index<T> + Index<T>.Count → Index<T>`
    ///
    /// Per-conformer concreteness of `Count` makes `.one` infer cleanly
    /// at call sites: `slot + .one` resolves `.one` as the conformer's
    /// `Count.one`.
    #if compiler(>=6.4)
    @inlinable
    public static func + (lhs: Self, rhs: Count) -> Self {
        Self(Ordinal(lhs.ordinal.rawValue + rhs.cardinal.rawValue))
    }
    #else
    // swiftlint:disable:next workaround_marker_present
    // WORKAROUND: Swift 6.3.x Wasm SDK Embedded `MandatoryPerformanceOptimizations`
    // pass crashes (signal 11) on cross-module monomorphization of the
    // nested-expression form
    // `Self(Ordinal(lhs.ordinal.rawValue + rhs.cardinal.rawValue))`
    // when this operator is invoked from a downstream consumer module
    // under `-enable-experimental-feature Embedded`. Same code compiles
    // cleanly on Swift 6.4-dev nightly Embedded — fixed upstream — so
    // the `#if compiler(>=6.4)` branch above keeps the evergreen form
    // for any toolchain with the fix.
    // WHY: SIL `eliminateDeadAllocations` sub-pass hits an
    //      `isLegalSILType` assertion on the nested-construction
    //      pattern during consumer-module monomorphization. Splitting
    //      into intermediate let-bindings breaks the SIL pattern. At
    //      `-O` the let-bindings are SSA values; the optimized SIL
    //      after MandatoryPerformanceOptimizations is equivalent to
    //      the nested form, so there is no runtime cost.
    // TRACKING: swift-institute/Issues/swift-issue-embedded-wasm-mandatory-perf-crash/.
    // WHEN TO REMOVE: when CI drops the Swift 6.3.x Wasm SDK matrix leg
    //                 (i.e., when the Wasm SDK ships against Swift ≥ 6.4).
    //                 At that point this entire `#else` branch becomes
    //                 unreachable on every CI runner and is mechanically
    //                 removable.
    @inlinable
    public static func + (lhs: Self, rhs: Count) -> Self {
        let sum: UInt = lhs.ordinal.rawValue + rhs.cardinal.rawValue
        let ord = Ordinal(sum)
        return Self(ord)
    }
    #endif

    /// Advances an ordinal position by its associated count type in place.
    @inlinable
    public static func += (lhs: inout Self, rhs: Count) {
        lhs = lhs + rhs
    }
}
