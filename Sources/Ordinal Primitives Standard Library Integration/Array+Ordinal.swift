// Array+Ordinal.swift

// MARK: - Array Subscript with Ordinal

extension Array {
    /// Accesses an element at an ordinal position.
    ///
    /// This subscript accepts any `Ordinal.Protocol` conformer, enabling
    /// both bare `Ordinal` and phantom-typed `Tagged<Tag, Ordinal>` as indices.
    ///
    /// - Parameter position: The ordinal position to access.
    /// - Returns: The element at the specified position.
    /// - Precondition: The position must be a valid index for the array.
    @inlinable
    public subscript<O: Ordinal.`Protocol`>(_ position: O) -> Element {
        self[Int(bitPattern: position.ordinal)]
    }
}
