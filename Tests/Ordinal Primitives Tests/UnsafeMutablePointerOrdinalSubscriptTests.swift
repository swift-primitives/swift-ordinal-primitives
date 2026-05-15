import Ordinal_Primitives
import Ordinal_Primitives_Standard_Library_Integration
import Testing

/// Regression guard: generic extension subscripts on UnsafeMutablePointer with
/// Ordinal.Protocol constraint must resolve across module boundaries.
/// See experiment: member-import-visibility-stdlib-subscript
@Suite
struct UnsafeMutablePointerOrdinalSubscriptTests {
    @Test
    func `get via ordinal`() {
        var values: [Int] = [10, 20, 30]
        unsafe values.withUnsafeMutableBufferPointer { buf in
            let ptr = buf.baseAddress!
            let val = unsafe ptr[Ordinal(1)]
            #expect(val == 20)
        }
    }

    @Test
    func `set via ordinal`() {
        var values: [Int] = [10, 20, 30]
        unsafe values.withUnsafeMutableBufferPointer { buf in
            let ptr = buf.baseAddress!
            unsafe ptr[Ordinal(0)] = 99
            #expect(unsafe ptr[0] == 99)
        }
    }

    @Test
    func `get via tagged ordinal`() {
        struct Slot: ~Copyable {}
        var values: [Int] = [10, 20, 30]
        unsafe values.withUnsafeMutableBufferPointer { buf in
            let ptr = buf.baseAddress!
            let idx = Tagged<Slot, Ordinal>(Ordinal(2))
            let val = unsafe ptr[idx]
            #expect(val == 30)
        }
    }

    @Test
    func `set via tagged ordinal`() {
        struct Slot: ~Copyable {}
        var values: [Int] = [10, 20, 30]
        unsafe values.withUnsafeMutableBufferPointer { buf in
            let ptr = buf.baseAddress!
            let idx = Tagged<Slot, Ordinal>(Ordinal(1))
            unsafe ptr[idx] = 77
            #expect(unsafe ptr[1] == 77)
        }
    }
}
