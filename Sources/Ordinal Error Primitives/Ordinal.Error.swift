public import Ordinal_Namespace

extension Ordinal {
    /// Errors that can occur during ordinal operations.
    public enum Error: Swift.Error, Hashable, Sendable {
        /// The operation would overflow the representable range.
        ///
        /// Thrown by `.successor.exact()` at `UInt.max`, or by
        /// `.advance.exact(by:)` when the result exceeds `UInt.max`.
        case overflow

        /// The operation would require a negative result.
        ///
        /// Thrown by `.predecessor.exact()` at position zero.
        case underflow

        /// The source integer was negative.
        ///
        /// Thrown by `init(_: Int)` when the input is less than zero.
        /// - Parameter value: The negative value that was provided.
        case negativeSource(Int)

        /// The target position is not forward from this position.
        ///
        /// Thrown by `.distance.forward(to:)` when `other < self`.
        case notForward
    }
}
