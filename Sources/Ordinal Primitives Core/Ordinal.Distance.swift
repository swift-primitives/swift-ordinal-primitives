public import Carrier_Primitives
public import Property_Primitives
public import Cardinal_Primitives

extension Ordinal {
    /// Tag type for distance operations.
    public enum Distance {}
}

extension Ordinal.`Protocol` {
    /// Distance operations between positions.
    ///
    /// Ordinal distance is directional — it only computes forward distances.
    /// For signed displacement, use `Affine.Discrete.Vector` from swift-affine-primitives.
    @inlinable
    public var distance: Property<Ordinal.Distance, Self> {
        Property(self)
    }
}

extension Property where Tag == Ordinal.Distance, Base: Ordinal.`Protocol` {
    /// Computes the forward distance to another position.
    ///
    /// This operation is directional: it only succeeds when `other >= self`.
    /// For signed displacement between arbitrary positions, use
    /// `Affine.Discrete.Vector` from swift-affine-primitives.
    ///
    /// The return type is `Base.Count`, which preserves phantom types:
    /// - `Ordinal.distance.forward(to:)` → `Cardinal`
    /// - `Index<T>.distance.forward(to:)` → `Index<T>.Count`
    ///
    /// - Parameter other: The target position.
    /// - Returns: The cardinal distance from `self` to `other`.
    /// - Throws: `Ordinal.Error.notForward` if `other < self`.
    @inlinable
    public func forward(to other: Base) throws(Ordinal.Error) -> Base.Count {
        if other.ordinal < base.ordinal {
            throw .notForward
        }
        return Base.Count(Cardinal(other.ordinal.rawValue - base.ordinal.rawValue))
    }
}
