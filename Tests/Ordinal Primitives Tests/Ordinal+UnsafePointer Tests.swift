import Ordinal_Primitives
import Ordinal_Primitives_Standard_Library_Integration
import Testing

/// Regression guard: generic extension subscripts on UnsafePointer with
/// Ordinal.Protocol constraint must resolve across module boundaries.
/// See experiment: member-import-visibility-stdlib-subscript
extension Ordinal {
    @Suite
    struct `UnsafePointer Subscript` {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
        @Suite(.serialized) struct Performance {}
    }
}

// MARK: - Unit

extension Ordinal.`UnsafePointer Subscript`.Unit {

    @Test
    func `get via ordinal`() {
        let values: [Int] = [10, 20, 30]
        unsafe values.withUnsafeBufferPointer { buf in
            let ptr = buf.baseAddress!
            let val = unsafe ptr[Ordinal(1)]
            #expect(val == 20)
        }
    }

    @Test
    func `get via tagged ordinal`() {
        struct Slot: ~Copyable {}
        let values: [Int] = [10, 20, 30]
        unsafe values.withUnsafeBufferPointer { buf in
            let ptr = buf.baseAddress!
            let idx = Tagged_Primitives.Tagged<Slot, Ordinal>(Ordinal(2))
            let val = unsafe ptr[idx]
            #expect(val == 30)
        }
    }
}
