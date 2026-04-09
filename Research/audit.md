# Audit: swift-ordinal-primitives

## Legacy — Consolidated 2026-04-08

### From: swift-institute/Research/audit-primitives.md (2026-04-03)

**Pre-publication dependency-tree audit — P0/P1/P2 checks**

#### P2: Methods in Type Body [API-IMPL-008]

**File**: `Sources/Ordinal Primitives Core/Ordinal.swift` (6 items in body)

All operator overloads and `zero` static property are defined inside the struct body (lines 39-88). No extensions exist in the file.

| Line | Item |
|------|------|
| 57 | `static var zero` |
| 63 | `static func ==` |
| 70 | `static func <` |
| 75 | `static func <=` |
| 80 | `static func >` |
| 85 | `static func >=` |

**Recommendation**: Move operators and static property to extensions.

---

### From: swift-institute/Research/audits/implementation-naming-2026-03-20/swift-core-infrastructure-batch.md (2026-03-20)

**Implementation + naming audit**

HIGH=0, MEDIUM=0, LOW=1, INFO=0
Finding IDs: IMPL-002, IMPL-010, ORD-001, PATTERN-017, PATTERN-021
