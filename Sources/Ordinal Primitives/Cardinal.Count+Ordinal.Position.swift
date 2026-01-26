public import Cardinal_Primitives

// MARK: - Ordinal.Position to Cardinal.Count Conversion

extension Cardinal.Count {
    /// Creates a count from a position.
    ///
    /// This is a total operation: every ordinal position maps directly
    /// to a cardinal count with the same numeric value. The semantic
    /// meaning differs (position vs. quantity), but the representation
    /// is identical.
    ///
    /// - Parameter position: The ordinal position to convert.
    @inlinable
    public init(_ position: Ordinal.Position) {
        self.init(__unchecked: position.rawValue)
    }
}
