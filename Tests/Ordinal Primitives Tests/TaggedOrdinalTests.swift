import Ordinal_Primitives_Test_Support
import Testing

@testable import Ordinal_Primitives

@Suite
struct TaggedOrdinalTests {
    // Tag types for the Tagged<Tag, Ordinal> surface.
    enum SlotPosition {}
    enum LanePosition {}

    typealias Slot = Tagged<SlotPosition, Ordinal>
    typealias Lane = Tagged<LanePosition, Ordinal>
    typealias SlotCount = Tagged<SlotPosition, Cardinal>

    // MARK: - Construction

    @Test
    func constructionFromOrdinal() {
        let slot = Slot(Ordinal(3))
        #expect(slot.position == Ordinal(3))
    }

    @Test
    func constructionFromIntegerLiteral() {
        let slot: Slot = 5
        #expect(slot.position == 5)
    }

    @Test
    func zeroConstant() {
        #expect(Slot.zero == 0)
        #expect(Slot.zero.position == .zero)
    }

    // MARK: - Tag Discrimination

    @Test
    func crossTagComparisonForbidden() {
        // Same numeric value but distinct phantom tags — equality only holds
        // within the same Tag domain. A cross-tag operation would not compile;
        // this test verifies the same-tag path works.
        let slotA: Slot = 7
        let slotB: Slot = 7
        #expect(slotA == slotB)
    }

    // MARK: - Successor / Predecessor

    @Test
    func successorSaturating() {
        let slot: Slot = 5
        let next = slot.successor.saturating()
        #expect(next == 6)
    }

    @Test
    func successorExact() throws(Ordinal.Error) {
        let slot: Slot = 5
        let next = try slot.successor.exact()
        #expect(next == 6)
    }

    @Test
    func successorExactThrowsAtMax() {
        let max = Slot(Ordinal(UInt.max))
        #expect(throws: Ordinal.Error.overflow) {
            try max.successor.exact()
        }
    }

    @Test
    func predecessorExact() throws(Ordinal.Error) {
        let slot: Slot = 5
        let prev = try slot.predecessor.exact()
        #expect(prev == 4)
    }

    @Test
    func predecessorExactThrowsAtZero() {
        #expect(throws: Ordinal.Error.underflow) {
            try Slot.zero.predecessor.exact()
        }
    }

    // MARK: - Advance (Tagged + Tagged.Count)

    @Test
    func advanceSaturatingTaggedCount() {
        let slot: Slot = 5
        let count: SlotCount = 3
        let result = slot.advance.saturating(by: count)
        #expect(result == 8)
    }

    @Test
    func advanceExactTaggedCount() throws(Ordinal.Error) {
        let slot: Slot = 5
        let count: SlotCount = 3
        let result = try slot.advance.exact(by: count)
        #expect(result == 8)
    }

    @Test
    func advanceExactTaggedCountThrowsOnOverflow() {
        let slot = Slot(Ordinal(UInt.max - 5))
        let count: SlotCount = 10
        #expect(throws: Ordinal.Error.overflow) {
            try slot.advance.exact(by: count)
        }
    }

    @Test
    func advanceViaPlusOperator() {
        let slot: Slot = 5
        let count: SlotCount = 3
        let result = slot + count
        #expect(result == 8)
    }

    // MARK: - Distance (forward + unchecked)

    @Test
    func distanceForwardTagged() throws(Ordinal.Error) {
        let a: Slot = 3
        let b: Slot = 8
        let distance = try a.distance.forward(to: b)
        #expect(distance == SlotCount(5))
    }

    @Test
    func distanceForwardThrowsWhenBackward() {
        let a: Slot = 8
        let b: Slot = 3
        #expect(throws: Ordinal.Error.notForward) {
            try a.distance.forward(to: b)
        }
    }

    @Test
    func distanceUncheckedForwardMonotonic() {
        // distance.unchecked is the new accessor introduced in this dispatch
        // for proven-monotonic call sites where the forward precondition holds
        // by invariant. Bare-Ordinal path is exercised in-package via the
        // Range<Ordinal>.count consumer; here we exercise it directly.
        let a: Ordinal = 3
        let b: Ordinal = 8
        let distance = a.distance.unchecked(to: b)
        #expect(distance == Cardinal(5))
    }

    // MARK: - Range<Tagged<Tag, Ordinal>>

    @Test
    func rangeCountTagged() {
        let lower: Slot = 3
        let upper: Slot = 8
        let range = lower..<upper
        #expect(range.count == SlotCount(5))
    }

    @Test
    func rangeIsEmptyWhenEqual() {
        let position: Slot = 5
        let range = position..<position
        #expect(range.isEmpty)
    }

    @Test
    func rangeInitFromStartAndCount() {
        let start: Slot = 3
        let count: SlotCount = 5
        let range = Swift.Range(start: start, count: count)
        #expect(range.lowerBound == start)
        #expect(range.upperBound == 8)
    }

    // MARK: - Tagged<Tag, Cardinal> from Tagged<Tag, Ordinal>

    @Test
    func cardinalFromOrdinal() {
        let slot: Slot = 5
        let count = SlotCount(slot)
        #expect(count == 5)
    }

    // MARK: - Int Conversion

    @Test
    func intExactlyFromTaggedOrdinal() {
        let slot: Slot = 42
        #expect(Int(exactly: slot) == 42)
    }

    @Test
    func intFromTaggedOrdinal() throws(Ordinal.Error) {
        let slot: Slot = 42
        let value = try Int(slot)
        #expect(value == 42)
    }

    @Test
    func intBitPatternFromTaggedOrdinal() {
        let slot = Slot(Ordinal(UInt.max))
        let bits = Int(bitPattern: slot)
        #expect(bits == -1)
    }
}
