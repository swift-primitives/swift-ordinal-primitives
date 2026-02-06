// Ordinal.Protocol.swift
// Abstraction over types that carry an ordinal position.

public import Identity_Primitives

// MARK: - Protocol

extension Ordinal {
    /// A type that carries an ordinal position.
    ///
    /// Conforming types wrap or represent an `Ordinal` value and can
    /// round-trip through it. This enables generic operations to accept
    /// both bare `Ordinal` and phantom-typed wrappers like `Index<T>`
    /// without rawValue extraction.
    ///
    /// ## Associated Types
    ///
    /// - `Count` — The cardinal type that measures distances between positions.
    ///   For `Ordinal`, this is `Cardinal`. For `Tagged<Tag, Ordinal>`, this is
    ///   `Tagged<Tag, Cardinal>`, preserving the phantom type through distance operations.
    ///
    /// ## Conformers
    ///
    /// - `Ordinal` — identity (self-conformance), `Count = Cardinal`
    /// - `Tagged<Tag, Ordinal>` — phantom-typed ordinal wrapper, `Count = Tagged<Tag, Cardinal>`
    ///
    /// ## Example
    ///
    /// ```swift
    /// func next<O: Ordinal.`Protocol`>(_ value: O) -> O {
    ///     O(ordinal: Ordinal(value.ordinal.rawValue + 1))
    /// }
    /// ```
    ///
    /// ## Future: Domain-based Unification
    ///
    /// Cross-type operators (Ordinal + Cardinal, comparisons) are currently
    /// duplicated for bare and tagged types. Full unification via an
    /// `associatedtype Domain` is blocked by Swift's requirement that
    /// associated types be `Copyable`. When `Tag: ~Copyable`, we cannot
    /// satisfy `Domain = Tag`.
    ///
    /// See: swift-cardinal-primitives/Experiments/tag-preserving-protocol-abstraction/
    /// for the validated design that would enable full unification once Swift
    /// allows `associatedtype Domain: ~Copyable`.
    public protocol `Protocol` {
        /// The cardinal type that measures distances between positions.
        ///
        /// The distance between two ordinal positions is a cardinal quantity.
        /// For phantom-typed ordinals, the count preserves the phantom type.
        associatedtype Count: Cardinal.`Protocol`

        /// The underlying ordinal value.
        var ordinal: Ordinal { get }

        /// Creates an instance from an ordinal value.
        init(_ ordinal: Ordinal)
    }
}

// MARK: - Ordinal Conformance

extension Ordinal: Ordinal.`Protocol` {
    /// The cardinal type for measuring distances between ordinals.
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

extension Tagged: Ordinal.`Protocol` where RawValue == Ordinal, Tag: ~Copyable {
    /// The cardinal type for measuring distances between tagged ordinals.
    ///
    /// Preserves the phantom type: `Tagged<Tag, Ordinal>.Count = Tagged<Tag, Cardinal>`.
    public typealias Count = Tagged<Tag, Cardinal>

    /// The underlying ordinal value.
    @inlinable
    public var ordinal: Ordinal { rawValue }

    /// Creates a tagged ordinal from an ordinal value.
    @inlinable
    public init(_ ordinal: Ordinal) {
        self.init(__unchecked: (), ordinal)
    }
}

// MARK: - Arithmetic

extension Ordinal.`Protocol` {
    /// Advances an ordinal position by its associated count type.
    ///
    /// This uses the `Count` associated type to ensure phantom-type safety:
    /// - `Ordinal + Cardinal → Ordinal`
    /// - `Index<T> + Index<T>.Count → Index<T>`
    @inlinable
    public static func + (lhs: Self, rhs: Count) -> Self {
        Self(lhs.ordinal + rhs.cardinal)
    }

    /// Advances an ordinal position by its associated count type in place.
    @inlinable
    public static func += (lhs: inout Self, rhs: Count) {
        lhs = lhs + rhs
    }
}
