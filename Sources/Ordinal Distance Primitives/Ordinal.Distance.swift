public import Cardinal_Primitives
public import Ordinal_Error_Primitives
public import Ordinal_Namespace
public import Ordinal_Protocol_Primitives
public import Property_Primitives

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

// MARK: - forward(to:)

extension Property where Tag == Ordinal.Distance, Base: Ordinal.`Protocol` {
    /// Computes the forward distance to another position.
    ///
    /// This operation is directional: it only succeeds when `other >= self`.
    /// One signature covers both shapes:
    /// - Bare `Ordinal` (`Base.Count == Cardinal`) — result is bare `Cardinal`.
    /// - `Tagged<T, Ordinal>` (`Base.Count == Tagged<T, Cardinal>`) — result preserves the phantom tag.
    ///
    /// - Parameter other: The target position.
    /// - Returns: The cardinal-carrying distance from `self` to `other`.
    /// - Throws: `Ordinal.Error.notForward` if `other < self`.
    @inlinable
    public func forward(to other: Base) throws(Ordinal.Error) -> Base.Count {
        if other.ordinal < base.ordinal {
            throw .notForward
        }
        return Base.Count(Cardinal(other.ordinal.rawValue - base.ordinal.rawValue))
    }
}

// MARK: - unchecked(to:)

extension Property where Tag == Ordinal.Distance, Base: Ordinal.`Protocol` {
    /// Computes the forward distance to another position assuming forward-monotonicity.
    ///
    /// This is the unchecked variant of ``forward(to:)``: the caller MUST
    /// guarantee `other.ordinal >= base.ordinal`. Use this at proven-monotonic
    /// call sites — for example, computing `count` on a `Range<Bound>` where
    /// the Range invariant guarantees `lowerBound <= upperBound`.
    ///
    /// If `other.ordinal < base.ordinal`, the underlying `UInt` subtraction
    /// underflows and produces a meaningless distance. The non-throwing form
    /// is the right tool only when the invariant proves the precondition;
    /// otherwise prefer ``forward(to:)``.
    ///
    /// - Parameter other: The target position. MUST be forward of `self`.
    /// - Returns: The cardinal-carrying distance from `self` to `other`.
    @inlinable
    public func unchecked(to other: Base) -> Base.Count {
        Base.Count(Cardinal(other.ordinal.rawValue - base.ordinal.rawValue))
    }
}
