// Ordinal+Equation.Protocol.swift
// Conformance of Ordinal to Equation.Protocol — unconditional.
//
// On Swift <6.4, `Equation.Protocol` is the institute fork supporting
// `borrowing` parameters for `~Copyable` conformers. On Swift 6.4+, it is
// a typealias to `Swift.Equatable` per SE-0499 — this same extension then
// satisfies the stdlib `Equatable` conformance directly. The stdlib
// `extension Ordinal: Hashable {}` declaration in `Ordinal Hash Primitives`
// (which implies `Equatable`) is guarded `#if swift(<6.4)` to avoid
// duplicate-conformance.

public import Equation_Primitives
public import Ordinal_Primitive

extension Ordinal: Equation.`Protocol` {}
