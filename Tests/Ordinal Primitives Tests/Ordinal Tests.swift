import Ordinal_Primitives_Test_Support
import Testing

@testable import Ordinal_Primitives

extension Ordinal {
    @Suite
    struct Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
        @Suite struct Performance {}
    }
}

// MARK: - Unit

extension Ordinal.Test.Unit {

    // MARK: Construction

    @Test
    func `construction from UInt`() {
        let position: Ordinal = 42
        #expect(position == 42)
    }

    @Test
    func `construction from int success`() throws(Ordinal.Error) {
        let position = try Ordinal(Int(42))
        #expect(position.rawValue == 42)
    }

    @Test
    func `construction exactly succeeds`() {
        #expect(Ordinal(exactly: 42) == 42)
    }

    // MARK: Constants

    @Test
    func `zero constant`() {
        #expect(Ordinal.zero == 0)
    }

    // MARK: Successor

    @Test
    func `successor saturating`() {
        let position: Ordinal = 5
        #expect(position.successor.saturating() == 6)
    }

    @Test
    func `successor exact`() throws(Ordinal.Error) {
        let position: Ordinal = 5
        let next = try position.successor.exact()
        #expect(next == 6)
    }

    // MARK: Predecessor

    @Test
    func `predecessor exact`() throws(Ordinal.Error) {
        let position: Ordinal = 5
        let prev = try position.predecessor.exact()
        #expect(prev == 4)
    }

    @Test
    func `successor predecessor round trip`() throws(Ordinal.Error) {
        let position: Ordinal = 5
        let result = try position.successor.exact().predecessor.exact()
        #expect(result == position)
    }

    // MARK: Advance

    @Test
    func `advance saturating`() {
        let position: Ordinal = 5
        let count: Cardinal = 3
        #expect(position.advance.saturating(by: count) == 8)
    }

    @Test
    func `advance exact`() throws(Ordinal.Error) {
        let position: Ordinal = 5
        let count: Cardinal = 3
        let result = try position.advance.exact(by: count)
        #expect(result == 8)
    }

    // MARK: Distance

    @Test
    func `distance forward`() throws(Ordinal.Error) {
        let a: Ordinal = 3
        let b: Ordinal = 8
        let distance = try a.distance.forward(to: b)
        #expect(distance == 5)
    }

    @Test
    func `distance forward same`() throws(Ordinal.Error) {
        let position: Ordinal = 5
        let distance = try position.distance.forward(to: position)
        #expect(distance == 0)
    }

    // MARK: Comparison

    @Test
    func comparison() {
        let a: Ordinal = 3
        let b: Ordinal = 5
        #expect(a < b)
        #expect(a <= b)
        #expect(b > a)
        #expect(b >= a)
        #expect(a == a)
        #expect(a != b)
    }

    // MARK: Cardinal Conversion

    @Test
    func `cardinal to position`() {
        let count: Cardinal = 42
        let position = Ordinal(count)
        #expect(position == 42)
    }

    @Test
    func `position to cardinal`() {
        let position: Ordinal = 42
        let count = Cardinal(position)
        #expect(count == 42)
    }
}

// MARK: - Edge Case

extension Ordinal.Test.`Edge Case` {

    @Test
    func `construction from int fails for negative`() {
        #expect(throws: Ordinal.Error.negativeSource(-1)) {
            try Ordinal(Int(-1))
        }
    }

    @Test
    func `construction exactly returns nil for negative`() {
        #expect(Ordinal(exactly: Int(-1)) == nil)
    }

    @Test
    func `successor saturating at max`() {
        let max = Ordinal(UInt.max)
        #expect(max.successor.saturating() == max)
    }

    @Test
    func `successor exact throws at max`() {
        let max = Ordinal(UInt.max)
        #expect(throws: Ordinal.Error.overflow) {
            try max.successor.exact()
        }
    }

    @Test
    func `predecessor exact throws at zero`() {
        #expect(throws: Ordinal.Error.underflow) {
            try Ordinal.zero.predecessor.exact()
        }
    }

    @Test
    func `advance saturating overflow`() {
        let position = Ordinal(UInt.max - 5)
        let count: Cardinal = 10
        #expect(position.advance.saturating(by: count).rawValue == UInt.max)
    }

    @Test
    func `advance exact throws on overflow`() {
        let position = Ordinal(UInt.max - 5)
        let count: Cardinal = 10
        #expect(throws: Ordinal.Error.overflow) {
            try position.advance.exact(by: count)
        }
    }

    @Test
    func `distance forward throws when backward`() {
        let a: Ordinal = 8
        let b: Ordinal = 3
        #expect(throws: Ordinal.Error.notForward) {
            try a.distance.forward(to: b)
        }
    }
}

// MARK: - Integration

extension Ordinal.Test.Integration {

    @Test
    func `int conversion success`() throws(Ordinal.Error) {
        let position: Ordinal = 42
        let value = try Int(position)
        #expect(value == 42)
    }

    @Test
    func `int conversion exactly success`() {
        let position: Ordinal = 42
        #expect(Int(exactly: position) == 42)
    }
}
