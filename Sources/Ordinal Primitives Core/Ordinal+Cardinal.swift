// Ordinal+Cardinal.swift
// Cross-type operations between ordinals and cardinals.
//
// These protocol-generic operators enforce same-domain safety via
// `where O.Domain == C.Domain`. They cover:
// - Bare: Ordinal ↔ Cardinal (Domain = Never)
// - Tagged: Tagged<Tag, Ordinal> ↔ Tagged<Tag, Cardinal> (Domain = Tag)
// - Bounded: Tagged<Tag, Ordinal.Finite<N>> ↔ Tagged<Tag, Cardinal> (Domain = Tag)

public import Cardinal_Primitives
public import Hash_Primitives

// MARK: - Protocol Conformances

extension Ordinal: Equation.`Protocol` {}
extension Ordinal: Comparison.`Protocol` {}
extension Ordinal: Hash.`Protocol` {}

// MARK: - Position ↔ Count Comparisons

/// Cross-type comparisons between ordinal-carrying and cardinal-carrying types.
///
/// These operators are disfavored so that same-type comparisons
/// (Cardinal > Cardinal, Ordinal > Ordinal) are preferred during type inference.
/// This prevents ambiguity when using `.zero` with a known LHS type.

@inlinable
@_disfavoredOverload
public func < <O: Ordinal.`Protocol`, C: Cardinal.`Protocol`>(
    lhs: O, rhs: C
) -> Bool where O.Domain == C.Domain {
    lhs.ordinal.rawValue < rhs.cardinal.rawValue
}

@inlinable
@_disfavoredOverload
public func <= <O: Ordinal.`Protocol`, C: Cardinal.`Protocol`>(
    lhs: O, rhs: C
) -> Bool where O.Domain == C.Domain {
    lhs.ordinal.rawValue <= rhs.cardinal.rawValue
}

@inlinable
@_disfavoredOverload
public func > <O: Ordinal.`Protocol`, C: Cardinal.`Protocol`>(
    lhs: O, rhs: C
) -> Bool where O.Domain == C.Domain {
    lhs.ordinal.rawValue > rhs.cardinal.rawValue
}

@inlinable
@_disfavoredOverload
public func >= <O: Ordinal.`Protocol`, C: Cardinal.`Protocol`>(
    lhs: O, rhs: C
) -> Bool where O.Domain == C.Domain {
    lhs.ordinal.rawValue >= rhs.cardinal.rawValue
}

// Reverse direction (Cardinal ↔ Ordinal)

@inlinable
@_disfavoredOverload
public func < <C: Cardinal.`Protocol`, O: Ordinal.`Protocol`>(
    lhs: C, rhs: O
) -> Bool where C.Domain == O.Domain {
    lhs.cardinal.rawValue < rhs.ordinal.rawValue
}

@inlinable
@_disfavoredOverload
public func <= <C: Cardinal.`Protocol`, O: Ordinal.`Protocol`>(
    lhs: C, rhs: O
) -> Bool where C.Domain == O.Domain {
    lhs.cardinal.rawValue <= rhs.ordinal.rawValue
}

@inlinable
@_disfavoredOverload
public func > <C: Cardinal.`Protocol`, O: Ordinal.`Protocol`>(
    lhs: C, rhs: O
) -> Bool where C.Domain == O.Domain {
    lhs.cardinal.rawValue > rhs.ordinal.rawValue
}

@inlinable
@_disfavoredOverload
public func >= <C: Cardinal.`Protocol`, O: Ordinal.`Protocol`>(
    lhs: C, rhs: O
) -> Bool where C.Domain == O.Domain {
    lhs.cardinal.rawValue >= rhs.ordinal.rawValue
}

// MARK: - Ordinal + Cardinal → Ordinal (Advance by Count)

/// Advances an ordinal by a cardinal amount.
///
/// This is a total operation for moving forward by a non-negative count.
/// Traps on overflow (matching Swift integer semantics).
@inlinable
@_disfavoredOverload
public func + <O: Ordinal.`Protocol`, C: Cardinal.`Protocol`>(
    lhs: O, rhs: C
) -> O where O.Domain == C.Domain {
    O(Ordinal(lhs.ordinal.rawValue + rhs.cardinal.rawValue))
}

/// Advances an ordinal by a cardinal amount (commutative).
@inlinable
@_disfavoredOverload
public func + <C: Cardinal.`Protocol`, O: Ordinal.`Protocol`>(
    lhs: C, rhs: O
) -> O where C.Domain == O.Domain {
    rhs + lhs
}

/// Advances an ordinal by a cardinal amount in place.
@inlinable
@_disfavoredOverload
public func += <O: Ordinal.`Protocol`, C: Cardinal.`Protocol`>(
    lhs: inout O, rhs: C
) where O.Domain == C.Domain {
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
@_disfavoredOverload
public func % <O: Ordinal.`Protocol`, C: Cardinal.`Protocol`>(
    lhs: O, rhs: C
) -> O where O.Domain == C.Domain {
    O(Ordinal(lhs.ordinal.rawValue % rhs.cardinal.rawValue))
}
