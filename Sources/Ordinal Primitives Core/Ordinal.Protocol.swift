// Ordinal.Protocol.swift
// Abstraction over types that carry an ordinal position.

public import Tagged_Primitives

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
    /// - `Tagged<Tag, R: Ordinal.Protocol>` — phantom-typed ordinal wrapper, `Count = Tagged<Tag, Cardinal>`
    ///
    /// ## Example
    ///
    /// ```swift
    /// func next<O: Ordinal.`Protocol`>(_ value: O) -> O {
    ///     O(ordinal: Ordinal(value.ordinal.rawValue + 1))
    /// }
    /// ```
    ///
    public protocol `Protocol` {
        /// The domain that scopes this ordinal position.
        ///
        /// For bare `Ordinal`, `Domain` is `Never` (unscoped).
        /// For `Tagged<Tag, Ordinal>`, `Domain` is `Tag`, enabling
        /// cross-type operators to enforce same-tag safety via
        /// `where O.Domain == C.Domain`.
        associatedtype Domain: ~Copyable

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
    /// Bare ordinals are unscoped.
    public typealias Domain = Never

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

extension Tagged: Ordinal.`Protocol` where RawValue: Ordinal.`Protocol`, Tag: ~Copyable {
    /// The phantom type is the domain.
    public typealias Domain = Tag

    /// The cardinal type for measuring distances between tagged ordinals.
    ///
    /// Preserves the phantom type: `Tagged<Tag, Ordinal>.Count = Tagged<Tag, Cardinal>`.
    public typealias Count = Tagged<Tag, Cardinal>

    /// The underlying ordinal value.
    @inlinable
    public var ordinal: Ordinal { rawValue.ordinal }

    /// Creates a tagged ordinal from an ordinal value.
    @inlinable
    public init(_ ordinal: Ordinal) {
        self.init(__unchecked: (), RawValue(ordinal))
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
        Self(Ordinal(lhs.ordinal.rawValue + rhs.cardinal.rawValue))
    }

    /// Advances an ordinal position by its associated count type in place.
    @inlinable
    public static func += (lhs: inout Self, rhs: Count) {
        lhs = lhs + rhs
    }
}
