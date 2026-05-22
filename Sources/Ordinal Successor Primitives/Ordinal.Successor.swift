public import Ordinal_Error_Primitives
public import Ordinal_Primitive
public import Property_Primitives

extension Ordinal {
    /// Tag type for successor operations.
    public enum Successor {}

    /// Policy-aware successor operations.
    ///
    /// Use this accessor to navigate forward by one position:
    /// - `.successor.saturating()` — clamps at `UInt.max`
    /// - `.successor.exact()` — throws on overflow
    @inlinable
    public var successor: Property<Successor, Self> {
        Property(self)
    }
}

extension Property where Tag == Ordinal.Successor, Base == Ordinal {
    /// Returns the next position, saturating at the maximum representable value.
    ///
    /// If at `UInt.max`, returns `UInt.max` (no change).
    ///
    /// - Returns: The next position, clamped to `UInt.max` on overflow.
    @inlinable
    public func saturating() -> Base {
        if base.rawValue == .max {
            return base
        }
        return Base(base.rawValue + 1)
    }

    /// Returns the next position, throwing on overflow.
    ///
    /// - Returns: The next position.
    /// - Throws: `Ordinal.Error.overflow` if at `UInt.max`.
    @inlinable
    public func exact() throws(Base.Error) -> Base {
        if base.rawValue == .max {
            throw .overflow
        }
        return Base(base.rawValue + 1)
    }
}
