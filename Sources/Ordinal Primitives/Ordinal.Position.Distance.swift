public import Property_Primitives
public import Cardinal_Primitives

extension Ordinal.Position {
    /// Tag type for distance operations.
    public enum Distance {}

    /// Distance operations between positions.
    ///
    /// Ordinal distance is directional — it only computes forward distances.
    /// For signed displacement, use `Affine.Discrete.Vector` from swift-affine-primitives.
    @inlinable
    public var distance: Property<Distance, Self> {
        Property(self)
    }
}

extension Property where Tag == Ordinal.Position.Distance, Base == Ordinal.Position {
    /// Computes the forward distance to another position.
    ///
    /// This operation is directional: it only succeeds when `other >= self`.
    /// For signed displacement between arbitrary positions, use
    /// `Affine.Discrete.Vector` from swift-affine-primitives.
    ///
    /// - Parameter other: The target position.
    /// - Returns: The cardinal distance from `self` to `other`.
    /// - Throws: `Ordinal.Position.Error.notForward` if `other < self`.
    @inlinable
    public func forward(to other: Base) throws(Base.Error) -> Cardinal.Count {
        if other.rawValue < base.rawValue {
            throw .notForward
        }
        return Cardinal.Count(other.rawValue - base.rawValue)
    }
}
