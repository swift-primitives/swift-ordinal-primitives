// Ordinal+Cardinal.swift
// Cross-type operations between ordinals and cardinals.
//
// The typed-advance operator (`Self + Self.Count`) lives on
// `Ordinal.`Protocol`` (which has the `Count` associatedtype). This
// file hosts the cross-type comparisons and the modular projection
// where the LHS is an ordinal-carrying type and the RHS is a
// cardinal-carrying type with matching `Domain`.

public import Cardinal_Primitives
public import Carrier_Primitives

// Institute-protocol conformances live in per-protocol files:
// - `Ordinal+Equation.Protocol.swift`
// - `Ordinal+Hash.Protocol.swift`
// - `Ordinal+Comparison.Protocol.swift`

// MARK: - Position ↔ Count Comparisons
//
// Cross-type comparisons between ordinal-carrying and cardinal-carrying
// types with matching `Domain`. Disfavored so that same-type
// comparisons (Cardinal > Cardinal, Ordinal > Ordinal) win type
// inference for ambiguous literals.

/// Returns `true` if the ordinal position precedes the cardinal value.
@inlinable
@_disfavoredOverload
public func < <O: Ordinal.`Protocol`, C: Carrier.`Protocol`<Cardinal>>(
    lhs: O,
    rhs: C
) -> Bool where O.Domain == C.Domain {
    lhs.ordinal.rawValue < rhs.cardinal.rawValue
}

/// Returns `true` if the ordinal position does not follow the cardinal value.
@inlinable
@_disfavoredOverload
public func <= <O: Ordinal.`Protocol`, C: Carrier.`Protocol`<Cardinal>>(
    lhs: O,
    rhs: C
) -> Bool where O.Domain == C.Domain {
    lhs.ordinal.rawValue <= rhs.cardinal.rawValue
}

/// Returns `true` if the ordinal position follows the cardinal value.
@inlinable
@_disfavoredOverload
public func > <O: Ordinal.`Protocol`, C: Carrier.`Protocol`<Cardinal>>(
    lhs: O,
    rhs: C
) -> Bool where O.Domain == C.Domain {
    lhs.ordinal.rawValue > rhs.cardinal.rawValue
}

/// Returns `true` if the ordinal position does not precede the cardinal value.
@inlinable
@_disfavoredOverload
public func >= <O: Ordinal.`Protocol`, C: Carrier.`Protocol`<Cardinal>>(
    lhs: O,
    rhs: C
) -> Bool where O.Domain == C.Domain {
    lhs.ordinal.rawValue >= rhs.cardinal.rawValue
}

// Reverse direction (Cardinal ↔ Ordinal)

/// Returns `true` if the cardinal value precedes the ordinal position.
@inlinable
@_disfavoredOverload
public func < <C: Carrier.`Protocol`<Cardinal>, O: Ordinal.`Protocol`>(
    lhs: C,
    rhs: O
) -> Bool where C.Domain == O.Domain {
    lhs.cardinal.rawValue < rhs.ordinal.rawValue
}

/// Returns `true` if the cardinal value does not follow the ordinal position.
@inlinable
@_disfavoredOverload
public func <= <C: Carrier.`Protocol`<Cardinal>, O: Ordinal.`Protocol`>(
    lhs: C,
    rhs: O
) -> Bool where C.Domain == O.Domain {
    lhs.cardinal.rawValue <= rhs.ordinal.rawValue
}

/// Returns `true` if the cardinal value follows the ordinal position.
@inlinable
@_disfavoredOverload
public func > <C: Carrier.`Protocol`<Cardinal>, O: Ordinal.`Protocol`>(
    lhs: C,
    rhs: O
) -> Bool where C.Domain == O.Domain {
    lhs.cardinal.rawValue > rhs.ordinal.rawValue
}

/// Returns `true` if the cardinal value does not precede the ordinal position.
@inlinable
@_disfavoredOverload
public func >= <C: Carrier.`Protocol`<Cardinal>, O: Ordinal.`Protocol`>(
    lhs: C,
    rhs: O
) -> Bool where C.Domain == O.Domain {
    lhs.cardinal.rawValue >= rhs.ordinal.rawValue
}

// MARK: - Ordinal + Cardinal → Ordinal (Cross-Carrier Advance)
//
// The `Self + Self.Count → Self` operator on `Ordinal.`Protocol``
// is the ergonomic form (per-conformer concrete RHS, `.one` infers).
// This free function handles the general cross-Carrier case where the
// RHS is some `Carrier.`Protocol`<Cardinal>` not necessarily equal to
// `Self.Count` — e.g., when consumer code is generic over a separate
// `C: Carrier.`Protocol`<Cardinal>` type parameter with matching `Domain`.

/// Advances an ordinal-carrying position by any `Carrier.`Protocol`<Cardinal>` with
/// matching `Domain`.
@inlinable
@_disfavoredOverload
public func + <O: Ordinal.`Protocol`, C: Carrier.`Protocol`<Cardinal>>(
    lhs: O,
    rhs: C
) -> O where O.Domain == C.Domain {
    O(Ordinal(lhs.ordinal.rawValue + rhs.cardinal.rawValue))
}

/// Advances an ordinal-carrying position by a cardinal-carrying count
/// (commutative free-function form).
@inlinable
@_disfavoredOverload
public func + <C: Carrier.`Protocol`<Cardinal>, O: Ordinal.`Protocol`>(
    lhs: C,
    rhs: O
) -> O where C.Domain == O.Domain {
    rhs + lhs
}

/// Advances an ordinal-carrying position by a cardinal-carrying count
/// in place (free-function form).
@inlinable
@_disfavoredOverload
public func += <O: Ordinal.`Protocol`, C: Carrier.`Protocol`<Cardinal>>(
    lhs: inout O,
    rhs: C
) where O.Domain == C.Domain {
    lhs = lhs + rhs
}

// MARK: - Ordinal % Cardinal → Ordinal (Modular Projection)

/// Projects an ordinal into a bounded range — canonical ring-buffer wrap.
///
/// `position % capacity` yields a position within `[0, capacity)`.
///
/// - Precondition: `rhs > 0` (division by zero traps).
@inlinable
@_disfavoredOverload
public func % <O: Ordinal.`Protocol`, C: Carrier.`Protocol`<Cardinal>>(
    lhs: O,
    rhs: C
) -> O where O.Domain == C.Domain {
    O(Ordinal(lhs.ordinal.rawValue % rhs.cardinal.rawValue))
}
