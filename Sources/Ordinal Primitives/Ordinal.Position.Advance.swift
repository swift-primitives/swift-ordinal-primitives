public import Property_Primitives
public import Cardinal_Primitives

extension Ordinal {
    /// Tag type for advance operations.
    public enum Advance {}

    /// Policy-aware advance operations.
    ///
    /// Use this accessor to move forward by a cardinal amount:
    /// - `.advance.saturating(by:)` — clamps at `UInt.max`
    /// - `.advance.exact(by:)` — throws on overflow
    @inlinable
    public var advance: Property<Advance, Self> {
        Property(self)
    }
}

extension Property where Tag == Ordinal.Advance, Base == Ordinal {
    /// Advances by a count, saturating at the maximum representable value.
    ///
    /// If the result would overflow, returns `Position(UInt.max)`.
    ///
    /// - Parameter count: The cardinal amount to advance by.
    /// - Returns: The new position, clamped to `UInt.max` on overflow.
    @inlinable
    public func saturating(by count: Cardinal) -> Base {
        let (result, overflow) = base.rawValue.addingReportingOverflow(count.rawValue)
        if overflow {
            return Base(UInt.max)
        }
        return Base(result)
    }

    /// Advances by a count, throwing on overflow.
    ///
    /// - Parameter count: The cardinal amount to advance by.
    /// - Returns: The new position.
    /// - Throws: `Ordinal.Error.overflow` if the result exceeds `UInt.max`.
    @inlinable
    public func exact(by count: Cardinal) throws(Base.Error) -> Base {
        let (result, overflow) = base.rawValue.addingReportingOverflow(count.rawValue)
        if overflow {
            throw .overflow
        }
        return Base(result)
    }
}
