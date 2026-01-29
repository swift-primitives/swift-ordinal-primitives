// Array+Ordinal.swift

// MARK: - Array Subscript with Ordinal

extension Array {
    /// Accesses an element at an ordinal position.
    ///
    /// This subscript allows using `Ordinal` directly as an array index.
    /// The ordinal's raw value is used for indexing.
    ///
    /// - Parameter position: The ordinal position to access.
    /// - Returns: The element at the specified position.
    /// - Precondition: `position.rawValue` must be a valid index for the array.
    @inlinable
    public subscript(position: Ordinal) -> Element {
        self[Int(bitPattern: position)]
    }
}
