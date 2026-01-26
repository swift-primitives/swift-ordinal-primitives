public import Property_Primitives

extension Ordinal.Position {
    /// Tag type for predecessor operations.
    public enum Predecessor {}

    /// Policy-aware predecessor operations.
    ///
    /// Use this accessor to navigate backward by one position:
    /// - `.predecessor.exact()` — throws at position zero
    ///
    /// Note: There is no `.predecessor.saturating()` because saturating
    /// predecessor would always return zero at position zero, which is
    /// semantically meaningless (unlike saturating at a maximum bound).
    @inlinable
    public var predecessor: Property<Predecessor, Self> {
        Property(self)
    }
}

extension Property where Tag == Ordinal.Position.Predecessor, Base == Ordinal.Position {
    /// Returns the previous position, throwing at zero.
    ///
    /// - Returns: The previous position.
    /// - Throws: `Ordinal.Position.Error.underflow` if at position zero.
    @inlinable
    public func exact() throws(Base.Error) -> Base {
        if base.rawValue == 0 {
            throw .underflow
        }
        return Base(base.rawValue - 1)
    }
}
