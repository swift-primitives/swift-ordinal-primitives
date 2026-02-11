import Testing
import Ordinal_Primitives
import Ordinal_Primitives_Standard_Library_Integration

/// Regression guard: generic extension subscripts on UnsafePointer with
/// Ordinal.Protocol constraint must resolve across module boundaries.
/// See experiment: member-import-visibility-stdlib-subscript
@Suite
struct UnsafePointerOrdinalSubscriptTests {
    @Test
    func getViaOrdinal() {
        let values: [Int] = [10, 20, 30]
        unsafe values.withUnsafeBufferPointer { buf in
            let ptr = buf.baseAddress!
            let val = unsafe ptr[Ordinal(1)]
            #expect(val == 20)
        }
    }

    @Test
    func getViaTaggedOrdinal() {
        struct Slot: ~Copyable {}
        let values: [Int] = [10, 20, 30]
        unsafe values.withUnsafeBufferPointer { buf in
            let ptr = buf.baseAddress!
            let idx = Tagged<Slot, Ordinal>(Ordinal(2))
            let val = unsafe ptr[idx]
            #expect(val == 30)
        }
    }
}
