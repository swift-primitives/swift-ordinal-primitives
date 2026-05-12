// MARK: - Ordinal from UnsignedInteger

extension Ordinal {
    /// Creates a position from any unsigned integer type.
    ///
    /// - Parameter value: The unsigned integer value.
    @inlinable
    public init<T: UnsignedInteger>(_ value: T) {
        self.init(UInt(value))
    }
}
