public import Cardinal_Primitives
public import Ordinal_Namespace

// MARK: - Cardinal to Ordinal Conversion

extension Ordinal {
    /// Creates a position from a count.
    ///
    /// This is a total operation: every cardinal count maps directly
    /// to an ordinal position with the same numeric value. The semantic
    /// meaning differs (quantity vs. position), but the representation
    /// is identical.
    ///
    /// - Parameter count: The cardinal count to convert.
    @inlinable
    public init(_ count: Cardinal) {
        self.init(count.rawValue)
    }
}
