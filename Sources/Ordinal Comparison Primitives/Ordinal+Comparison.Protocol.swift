// Ordinal+Comparison.Protocol.swift
// Conformance of Ordinal to Comparison.Protocol — unconditional.
//
// On Swift <6.4, `Comparison.Protocol` is the institute fork supporting
// `borrowing` parameters for `~Copyable` conformers. On Swift 6.4+, it is
// a typealias to `Swift.Comparable` per SE-0499 — this same extension then
// satisfies the stdlib `Comparable` conformance directly. The stdlib
// `extension Ordinal: Comparable {}` declaration below is guarded
// `#if swift(<6.4)` to avoid duplicate-conformance.

public import Comparison_Primitives
public import Ordinal_Primitive

extension Ordinal: Comparison.`Protocol` {}

#if swift(<6.4)
    extension Ordinal: Comparable {}
#endif
