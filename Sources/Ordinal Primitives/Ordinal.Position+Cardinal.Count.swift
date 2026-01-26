public import Cardinal_Primitives

// MARK: - Cardinal.Count to Ordinal.Position Conversion

extension Ordinal.Position {
    /// Creates a position from a count.
    ///
    /// This is a total operation: every cardinal count maps directly
    /// to an ordinal position with the same numeric value. The semantic
    /// meaning differs (quantity vs. position), but the representation
    /// is identical.
    ///
    /// - Parameter count: The cardinal count to convert.
    @inlinable
    public init(_ count: Cardinal.Count) {
        self.init(count.rawValue)
    }
}
