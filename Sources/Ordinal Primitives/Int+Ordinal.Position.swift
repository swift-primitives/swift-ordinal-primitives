// MARK: - Int to Ordinal Conversions

extension Ordinal {
    /// Creates a position from a signed integer, returning `nil` if negative.
    ///
    /// - Parameter value: The signed integer value.
    /// - Returns: A position if `value >= 0`, otherwise `nil`.
    @inlinable
    public init?(exactly value: Int) {
        guard value >= 0 else { return nil }
        self.init(UInt(value))
    }

    /// Creates a position from a signed integer, throwing if negative.
    ///
    /// - Parameter value: The signed integer value.
    /// - Throws: `Error.negativeSource` if `value < 0`.
    @inlinable
    public init(_ value: Int) throws(Error) {
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
    /// On 64-bit platforms, this can fail for positions near `UInt.max`.
    /// On 32-bit platforms, this fails for positions exceeding `Int32.max`.
    ///
    /// - Parameter position: The ordinal position.
    /// - Returns: The integer value if representable, otherwise `nil`.
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
        self = Int(bitPattern: position.rawValue)
    }
}
