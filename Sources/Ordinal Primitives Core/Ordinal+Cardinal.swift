

// MARK: - Protocol Conformances

extension Ordinal: Equation.`Protocol` {}
extension Ordinal: Comparison.`Protocol` {}

// MARK: - Position ↔ Count Comparisons

/// Cross-type comparisons between ordinals and cardinals.
///
/// These operators are disfavored so that same-type comparisons
/// (Cardinal > Cardinal, Ordinal > Ordinal) are preferred during type inference.
/// This prevents ambiguity when using `.zero` with a known LHS type.
///
/// The canonical bounds check `position < count` still works - you just need
/// both sides to have explicit types.

@inlinable
@_disfavoredOverload
public func < (lhs: Ordinal, rhs: Cardinal) -> Bool {
    lhs.rawValue < rhs.rawValue
}

@inlinable
@_disfavoredOverload
public func <= (lhs: Ordinal, rhs: Cardinal) -> Bool {
    lhs.rawValue <= rhs.rawValue
}

@inlinable
@_disfavoredOverload
public func > (lhs: Ordinal, rhs: Cardinal) -> Bool {
    lhs.rawValue > rhs.rawValue
}

@inlinable
@_disfavoredOverload
public func >= (lhs: Ordinal, rhs: Cardinal) -> Bool {
    lhs.rawValue >= rhs.rawValue
}

// Reverse direction (Cardinal ↔ Ordinal)

@inlinable
@_disfavoredOverload
public func < (lhs: Cardinal, rhs: Ordinal) -> Bool {
    lhs.rawValue < rhs.rawValue
}

@inlinable
@_disfavoredOverload
public func <= (lhs: Cardinal, rhs: Ordinal) -> Bool {
    lhs.rawValue <= rhs.rawValue
}

@inlinable
@_disfavoredOverload
public func > (lhs: Cardinal, rhs: Ordinal) -> Bool {
    lhs.rawValue > rhs.rawValue
}

@inlinable
@_disfavoredOverload
public func >= (lhs: Cardinal, rhs: Ordinal) -> Bool {
    lhs.rawValue >= rhs.rawValue
}

// MARK: - Ordinal + Cardinal → Ordinal (Advance by Count)

/// Advances an ordinal by a cardinal amount.
///
/// This is the total operation for moving forward by a non-negative count.
/// Traps on overflow (matching Swift integer semantics).
@inlinable
public func + (lhs: Ordinal, rhs: Cardinal) -> Ordinal {
    Ordinal(lhs.rawValue + rhs.rawValue)
}

/// Advances an ordinal by a cardinal amount (commutative).
@inlinable
public func + (lhs: Cardinal, rhs: Ordinal) -> Ordinal {
    Ordinal(lhs.rawValue + rhs.rawValue)
}

/// Advances an ordinal by a cardinal amount in place.
@inlinable
public func += (lhs: inout Ordinal, rhs: Cardinal) {
    lhs = lhs + rhs
}

// MARK: - Ordinal % Cardinal → Ordinal (Modular Projection)

/// Projects an ordinal into a bounded range.
///
/// This is the canonical operation for ring buffer wrap-around:
/// `position % capacity` yields a position within `[0, capacity)`.
///
/// - Precondition: `rhs > 0` (division by zero traps).
@inlinable
public func % (lhs: Ordinal, rhs: Cardinal) -> Ordinal {
    Ordinal(lhs.rawValue % rhs.rawValue)
}
