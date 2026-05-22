public import Ordinal_Error_Primitives
public import Ordinal_Primitive
public import Property_Primitives

extension Ordinal {
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

extension Property where Tag == Ordinal.Predecessor, Base == Ordinal {
    /// Returns the previous position, throwing at zero.
    ///
    /// - Returns: The previous position.
    /// - Throws: `Ordinal.Error.underflow` if at position zero.
    @inlinable
    public func exact() throws(Base.Error) -> Base {
        if base.rawValue == 0 {
            throw .underflow
        }
        return Base(base.rawValue - 1)
    }
}
