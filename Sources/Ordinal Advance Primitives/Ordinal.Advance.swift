public import Cardinal_Primitives
public import Carrier_Primitives
public import Ordinal_Error_Primitives
public import Ordinal_Namespace
public import Ordinal_Protocol_Primitives
public import Property_Primitives

extension Ordinal {
    /// Tag type for advance operations.
    public enum Advance {}
}

extension Ordinal.`Protocol` {
    /// Policy-aware advance operations.
    ///
    /// Use this accessor to move forward by a cardinal amount:
    /// - `.advance.saturating(by:)` — clamps at `UInt.max`
    /// - `.advance.exact(by:)` — throws on overflow
    @inlinable
    public var advance: Property<Ordinal.Advance, Self> {
        Property(self)
    }
}

// MARK: - Advance — Carrier.`Protocol`<Cardinal> (unified bare + Tagged path)

extension Property where Tag == Ordinal.Advance, Base: Ordinal.`Protocol` {
    /// Advances by a cardinal-carrying count, saturating at the maximum representable value.
    ///
    /// One signature covers both bare `Cardinal` and `Tagged<Tag, Cardinal>`
    /// via `Carrier.`Protocol`<Cardinal>`. If the result would overflow,
    /// returns `Position(UInt.max)`.
    ///
    /// - Parameter count: The cardinal-carrying amount to advance by.
    /// - Returns: The new position, clamped to `UInt.max` on overflow.
    @inlinable
    public func saturating(by count: some Carrier.`Protocol`<Cardinal>) -> Base {
        let (result, overflow) = base.ordinal.rawValue.addingReportingOverflow(count.cardinal.rawValue)
        if overflow {
            return Base(Ordinal(UInt.max))
        }
        return Base(Ordinal(result))
    }

    /// Advances by a cardinal-carrying count, throwing on overflow.
    ///
    /// - Parameter count: The cardinal-carrying amount to advance by.
    /// - Returns: The new position.
    /// - Throws: `Ordinal.Error.overflow` if the result exceeds `UInt.max`.
    @inlinable
    public func exact(by count: some Carrier.`Protocol`<Cardinal>) throws(Ordinal.Error) -> Base {
        let (result, overflow) = base.ordinal.rawValue.addingReportingOverflow(count.cardinal.rawValue)
        if overflow {
            throw .overflow
        }
        return Base(Ordinal(result))
    }

    /// Advances by a cardinal-carrying count, clamping to a dynamic bound.
    ///
    /// Use this for bounded operations where advancing beyond a limit
    /// should clamp rather than overflow or throw.
    ///
    /// - Parameters:
    ///   - count: The cardinal-carrying amount to advance by.
    ///   - bound: The maximum position to clamp to.
    /// - Returns: The new position, clamped to `bound` if it would exceed it.
    @inlinable
    public func clamped(by count: some Carrier.`Protocol`<Cardinal>, to bound: Base) -> Base {
        let (result, overflow) = base.ordinal.rawValue.addingReportingOverflow(count.cardinal.rawValue)
        if overflow || result > bound.ordinal.rawValue {
            return bound
        }
        return Base(Ordinal(result))
    }
}
