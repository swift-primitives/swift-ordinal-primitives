import Testing
@testable import Ordinal_Primitives
import Ordinal_Primitives_Test_Support

@Suite
struct OrdinalPositionTests {
    // MARK: - Construction

    @Test
    func constructionFromUInt() {
        let position: Ordinal.Position = 42
        #expect(position == 42)
    }

    @Test
    func constructionFromIntSuccess() throws {
        let position = try Ordinal.Position(Int(42))
        #expect(position.rawValue == 42)
    }

    @Test
    func constructionFromIntFailsForNegative() {
        #expect(throws: Ordinal.Position.Error.negativeSource(-1)) {
            try Ordinal.Position(Int(-1))
        }
    }

    @Test
    func constructionExactlyReturnsNilForNegative() {
        #expect(Ordinal.Position(exactly: Int(-1)) == nil)
    }

    @Test
    func constructionExactlySucceeds() {
        #expect(Ordinal.Position(exactly: 42) == 42)
    }

    // MARK: - Constants

    @Test
    func zeroConstant() {
        #expect(Ordinal.Position.zero == 0)
    }

    // MARK: - Successor

    @Test
    func successorSaturating() {
        let position: Ordinal.Position = 5
        #expect(position.successor.saturating() == 6)
    }

    @Test
    func successorSaturatingAtMax() {
        let max = Ordinal.Position(UInt.max)
        #expect(max.successor.saturating() == max)
    }

    @Test
    func successorExact() throws {
        let position: Ordinal.Position = 5
        let next = try position.successor.exact()
        #expect(next == 6)
    }

    @Test
    func successorExactThrowsAtMax() {
        let max = Ordinal.Position(UInt.max)
        #expect(throws: Ordinal.Position.Error.overflow) {
            try max.successor.exact()
        }
    }

    // MARK: - Predecessor

    @Test
    func predecessorExact() throws {
        let position: Ordinal.Position = 5
        let prev = try position.predecessor.exact()
        #expect(prev == 4)
    }

    @Test
    func predecessorExactThrowsAtZero() {
        #expect(throws: Ordinal.Position.Error.underflow) {
            try Ordinal.Position.zero.predecessor.exact()
        }
    }

    @Test
    func successorPredecessorRoundTrip() throws {
        let position: Ordinal.Position = 5
        let result = try position.successor.exact().predecessor.exact()
        #expect(result == position)
    }

    // MARK: - Advance

    @Test
    func advanceSaturating() {
        let position: Ordinal.Position = 5
        let count: Cardinal.Count = 3
        #expect(position.advance.saturating(by: count) == 8)
    }

    @Test
    func advanceSaturatingOverflow() {
        let position = Ordinal.Position(UInt.max - 5)
        let count: Cardinal.Count = 10
        #expect(position.advance.saturating(by: count).rawValue == UInt.max)
    }

    @Test
    func advanceExact() throws {
        let position: Ordinal.Position = 5
        let count: Cardinal.Count = 3
        let result = try position.advance.exact(by: count)
        #expect(result == 8)
    }

    @Test
    func advanceExactThrowsOnOverflow() {
        let position = Ordinal.Position(UInt.max - 5)
        let count: Cardinal.Count = 10
        #expect(throws: Ordinal.Position.Error.overflow) {
            try position.advance.exact(by: count)
        }
    }

    // MARK: - Distance

    @Test
    func distanceForward() throws {
        let a: Ordinal.Position = 3
        let b: Ordinal.Position = 8
        let distance = try a.distance.forward(to: b)
        #expect(distance == 5)
    }

    @Test
    func distanceForwardSame() throws {
        let position: Ordinal.Position = 5
        let distance = try position.distance.forward(to: position)
        #expect(distance == 0)
    }

    @Test
    func distanceForwardThrowsWhenBackward() {
        let a: Ordinal.Position = 8
        let b: Ordinal.Position = 3
        #expect(throws: Ordinal.Position.Error.notForward) {
            try a.distance.forward(to: b)
        }
    }

    // MARK: - Comparison

    @Test
    func comparison() {
        let a: Ordinal.Position = 3
        let b: Ordinal.Position = 5
        #expect(a < b)
        #expect(a <= b)
        #expect(b > a)
        #expect(b >= a)
        #expect(a == a)
        #expect(a != b)
    }

    // MARK: - Cardinal Conversion

    @Test
    func cardinalToPosition() {
        let count: Cardinal.Count = 42
        let position = Ordinal.Position(count)
        #expect(position == 42)
    }

    @Test
    func positionToCardinal() {
        let position: Ordinal.Position = 42
        let count = Cardinal.Count(position)
        #expect(count == 42)
    }

    // MARK: - Int Conversion

    @Test
    func intConversionSuccess() throws {
        let position: Ordinal.Position = 42
        let value = try Int(position)
        #expect(value == 42)
    }

    @Test
    func intConversionExactlySuccess() {
        let position: Ordinal.Position = 42
        #expect(Int(exactly: position) == 42)
    }
}
