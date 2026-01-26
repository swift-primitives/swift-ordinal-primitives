// MARK: - Int to Ordinal.Position Conversions

extension Ordinal.Position {
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

// MARK: - Ordinal.Position to Int Conversions

extension Int {
    /// Creates an integer from a position, returning `nil` if it exceeds `Int.max`.
    ///
    /// On 64-bit platforms, this can fail for positions near `UInt.max`.
    /// On 32-bit platforms, this fails for positions exceeding `Int32.max`.
    ///
    /// - Parameter position: The ordinal position.
    /// - Returns: The integer value if representable, otherwise `nil`.
    @inlinable
    public init?(exactly position: Ordinal.Position) {
        guard position.rawValue <= UInt(Int.max) else { return nil }
        self = Int(position.rawValue)
    }

    /// Creates an integer from a position, throwing if it exceeds `Int.max`.
    ///
    /// - Parameter position: The ordinal position.
    /// - Throws: `Ordinal.Position.Error.overflow` if the position exceeds `Int.max`.
    @inlinable
    public init(_ position: Ordinal.Position) throws(Ordinal.Position.Error) {
        guard position.rawValue <= UInt(Int.max) else {
            throw .overflow
        }
        self = Int(position.rawValue)
    }
}
