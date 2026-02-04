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
    /// ## Conformers
    ///
    /// - `Ordinal` — identity (self-conformance)
    /// - `Tagged<Tag, Ordinal>` — phantom-typed ordinal wrapper
    ///
    /// ## Example
    ///
    /// ```swift
    /// func next<O: Ordinal.`Protocol`>(_ value: O) -> O {
    ///     O(ordinal: Ordinal(value.ordinal.rawValue + 1))
    /// }
    /// ```
    public protocol `Protocol` {
        /// The underlying ordinal value.
        var ordinal: Ordinal { get }

        /// Creates an instance from an ordinal value.
        init(_ ordinal: Ordinal)
    }
}

// MARK: - Ordinal Conformance

extension Ordinal: Ordinal.`Protocol` {
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
    /// The underlying ordinal value.
    @inlinable
    public var ordinal: Ordinal { rawValue }

    /// Creates a tagged ordinal from an ordinal value.
    @inlinable
    public init(_ ordinal: Ordinal) {
        self.init(__unchecked: (), ordinal)
    }
}
