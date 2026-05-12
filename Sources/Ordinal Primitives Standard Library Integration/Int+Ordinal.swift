// MARK: - Int to Ordinal Conversions

extension Ordinal {
    /// Creates a position from a signed integer, returning `nil` if negative.
    ///
    /// Returns a position if `value >= 0`, otherwise `nil`.
    ///
    /// - Parameter value: The signed integer value.
    @inlinable
    public init?(exactly value: Int) {
        guard value >= 0 else { return nil }
        self.init(UInt(value))
    }

    /// Creates a position from a signed integer, throwing if negative.
    ///
    /// - Parameter value: The signed integer value.
    /// - Throws: ``Ordinal/Error/negativeSource(_:)`` if `value < 0`.
    @inlinable
    public init(_ value: Int) throws(Ordinal.Error) {
        guard value >= 0 else {
            throw .negativeSource(value)
        }
        self.init(UInt(value))
    }
}

// MARK: - Ordinal to Int Conversions

extension Int {
    /// Creates an integer from a position, returning `nil` if it exceeds `Int.max`.
    ///
    /// Returns the integer value if representable, otherwise `nil`. On 64-bit
    /// platforms, this can fail for positions near `UInt.max`; on 32-bit
    /// platforms, it fails for positions exceeding `Int32.max`.
    ///
    /// - Parameter position: The ordinal position.
    @inlinable
    public init?(exactly position: Ordinal) {
        guard position.rawValue <= UInt(Int.max) else { return nil }
        self = Int(position.rawValue)
    }

    /// Creates an integer from a position, throwing if it exceeds `Int.max`.
    ///
    /// - Parameter position: The ordinal position.
    /// - Throws: `Ordinal.Error.overflow` if the position exceeds `Int.max`.
    @inlinable
    public init(_ position: Ordinal) throws(Ordinal.Error) {
        guard position.rawValue <= UInt(Int.max) else {
            throw .overflow
        }
        self = Int(position.rawValue)
    }

    /// Creates an integer by reinterpreting the position's bit pattern.
    ///
    /// This is an unchecked conversion that reinterprets the underlying `UInt`
    /// as `Int`. Values greater than `Int.max` become negative.
    ///
    /// Use this for pointer arithmetic and other low-level operations where
    /// you need the raw bit pattern without validation.
    ///
    /// - Parameter position: The ordinal position.
    @inlinable
    public init(bitPattern position: Ordinal) {
        // reason: typed-system bottom-out — this file IS the [INFRA-002]
        // Int.init(bitPattern: Ordinal) integration overload definition;
        // the position.rawValue → UInt → stdlib Int.init(bitPattern: UInt)
        // chain is the canonical grounding. Direct analog of wave-2a
        // cardinal Int+Cardinal.swift:48 (commit abd750b).
        // swiftlint:disable:next bitpattern_rawvalue_chain_anti_pattern
        self = Int(bitPattern: position.rawValue)
    }
}
