# PFR-C12 readiness audit

**Status, 2026-09-30:** S01-S04 are durably complete. S05 freshly assessed all
twelve earlier criteria, R01-R13 and CC01-CC08 against actual source and exact
manuscript anchors. Fresh cumulative validation and independent review pass.
Both original reports are preserved and critically reconciled. Final applicability,
F and supported durable closure follow this checkpoint; only that closure
completes CC09 and C12.

The [approved revision-2 plan](plans/pfr-c12-active-pattern-compression-real-bridge.md)
owns the requirements. [Implementation notes](pfr-c12-implementation-notes.md)
own exact commands, original reports, reconciliation and closure records.
S05 startup verified all four original report reconciliations and twelve
satisfied criteria; all 145 S04 final source/environment entries matched.
S04 durable closure: `a2672869035f413ec17f44f6624a93fdf0ae95fa4de8fd2abfe352dc172d24de`.

## Manuscript identity and interpretation

The six-page ISIT final manuscript has SHA256
`48963aa59485b2c33b1a1e6e7c6ead2251fdddd26bd3691b6fcffe683e6ed1c4`.
The designated extended version 16, 18 pages, has SHA256
`98636d4c9f0618ec08fca84559572780f604f197fda90d8d7c787b3624245b8f`.
S05 freshly hashed both actual binaries and reread the relevant extracted pages:
ISIT p4 and extended pp5-6. The identities are unchanged from the earlier
visual checks. All three relevant pages were freshly rendered and visually
inspected in S05, with targeted text checked against the Lean contracts. Local manuscripts, extracts and images remain outside maintained
source. No new interpretation or omission was introduced.

| Manuscript obligation | Precise contract and owner |
| --- | --- |
| ISIT IV opening, p4; extended IV opening, p5: merge columns with the same pattern | Intrinsic nonempty input-support finsets determine the fibers. Unequal values within one pattern are summed exactly; equal values on distinct patterns do not merge. `occurringPatterns`, `patternFiber`, `patternAggregate` and the semantic pushforward specify every coordinate. |
| The opening reachability equivalence | `patternCompression` specializes the existing C10 binary PPM synthesis. Its actual path, labels and directed output comparison are retained. `patternCompressionInverse` is exactly the witnessed PPS reversal; perfectness and both reachability predicates are preserved and reflected. Compressed values alone are not a global inverse. |
| Distinct nonzero patterns and bounded values | Compressed patterns are nonempty and injective. Positivity, finiteness and the upper bound one are derived for each aggregate. Values equal to one and repeated source patterns with unequal values are valid. |
| Numeric pattern/value description | Exact ENNReal finite sums convert to Real without loss. Weighted sums over patterns containing each input equal one. `CompressedPatternData` stores only a finite pattern family, positive Real values and these row identities. Bounds and output nonemptiness are derived. Total pattern values need not equal one. |
| Extended IV-A (39)-(42), pp5-6: actual occurring patterns within the full nonzero-pattern family | Occurrence is intrinsic; supplied finite enumerations are presentations. Full data recovery explicitly transports membership proofs. C12 supplies actual patterns and constants; C13 owns the full/reduced incidence encodings, zero extension and feasibility equivalence. |
| Effective support counts and omitted inactive labels | C06 restriction preserves active masses and inclusion restores every ambient atom. S04 composes the retained inverse with that inclusion. Injective output extensions and changed active enumerations preserve the whole family, every exact/Real aggregate and the full extracted data record. Unused labels have zero mass and no admitted pattern/value. |
| Channel-facing use of valid data | The ambient perfectness iff passes through the C06 active presentation, actual S02 compression/reversal and S03 reconstruction. It requires nonempty finite input and finite ambient output, with singularity and no prior, full-support or feasibility premise. The data domain includes singular nonperfect channels. |
| Opening bound `m ≤ 2^k - 1`; adjoining algorithmic prose | C13 owns the exact pattern-count theorem. Singularity-check and broader running-time prose remain documentation-only under OM-016/019. |
| Extended IV-A (54)-(55), p6 | C13 must derive total partition weight one from feasibility and a chosen input row. C12 provides the row identity; it does not substitute a false total-pattern-value normalization. Optimization attainment and objective-one characterizations remain C14/C15. |

The raw occurrence and semantic compression APIs require finite alphabets but
neither singularity nor nonempty input. Aggregate/value facts require singularity.
The valid-data and finite operation interfaces explicitly require nonempty input.
The ambient inverse theorem can use a supplied finite active enumeration even
without an additional finite ambient-output instance. Empty-input LP data is
excluded while C06's broader raw matrix boundary remains available.

## Modules, reuse and validation boundary

- [Production](../PerfectFunctionalRepresentations/Matrix/PatternCompression.lean)
  owns the intrinsic data, actual operation interface, exact Real bridge and
  ambient transport. Its two focused imports are `Matrix.MultiwayOperations`
  and `Matrix.Reachability`.
- [Regression consumers](../PerfectFunctionalRepresentations/Tests/Matrix/PatternCompression.lean)
  reuse the quarter, identity, mixed and existing C03 nonperfect fixtures.
  Fixture helpers remain private. S04 adds no import and uses no
  compiler-generated private declaration name.
- C06 supplies active restriction, inclusion, supplied enumeration,
  `activeOutputsMapEquiv`, exact/Real coordinates and column-data transport.
  C10 supplies prescribed-fiber PPM synthesis and actual witness reversal.
  Mathlib supplies PMFs, finite sums, subtype equivalences and exact numeric
  conversion. LeanInfoTheory remains pinned to immutable `v0.1.0`; no dependency
  change or project-local probability theory was introduced.

S05 freshly invoked the focused production/C12/C10-Synthesis/C11-characterization
build (2,781 jobs) and default build (2,762 jobs); both passed. Lake reused available
artifacts. The default target alone does not establish maintained test coverage.
Fresh exhaustive source-copy audits checked all 113 explicit production
declarations (90 public, 23 private), plus the constructor and four projections:
118 checks. All 277 test declarations were audited: 147 private, 128 anonymous
examples and two local instances. There is no named public test API. Every
reported axiom set is limited to `propext`, `Classical.choice` and `Quot.sound`.
Generated recursors and auxiliary equations are outside the explicit inventory.
Naming anonymous consumers in the scratch copy exposed two unused-section-variable
warnings for `[Nonempty α]` in C06 matrix-reconstruction examples. These are
audit-copy lint diagnostics; they do not change the maintained statements or
reported axiom sets. The production audit has no diagnostics.

Production SHA256 remains
`3fd499c98966ab77c4b057755619cd5e1ca954e30955aeeaf22e9fce441bb52a`;
test SHA256 remains
`e71623d80c957ad5556d6af30d1f7c8591dcf53abd8398c4f5944fb137a31fcd`.
Fresh import/pin/private-name and placeholder scans pass. The root remains
lightweight; production keeps its two focused imports and uses supported pinned
LeanInfoTheory imports. No maintained Lean file changed in S05. These are fresh
implementation-side checks. The reviewer separately ran fresh focused/default
builds, all 118/277 signature/axiom checks with source-copy re-elaboration, manuscript
renders and initial/final checks of all 144 concrete source files. A linked
reassessment checks unchanged source applicability and the review-time boundary;
both original reports are preserved and reconciled. Earlier S01-S04 reports remain
historical evidence. Review-time success does not certify future F or closure.

Earlier disposable failures concerned explicit finite-cardinality arguments,
finite vector elaboration, and Lean's transparency when comparing a state's
output cardinality with the supplied enumeration size. The final consumers
use the same mathematical contracts. No proof placeholder, weakened statement
or new premise was used to resolve those failures.

## Step criteria crosswalk

`P` refers to the production module linked above; `T` to the regression module.
The numbers are one-based declaration or consumer start lines in the S04 source.
S01-S04 acceptance is supported by their durable records. S05 freshly checked
each declaration/consumer obligation below, including assumptions, witness
directions and edge cases; all twelve earlier criteria pass the implementation-side
cumulative assessment. The separate cumulative independent review also supports all twelve criteria; both original reports are preserved and reconciled.

| Criterion | Actual declarations | Consumer evidence and status |
| --- | --- | --- |
| C12-S01-A | P37 `occurringPatterns`, P43 membership, P51 `toOccurringPattern_surjective`, P62 fibers, P74/P79/P87 nonempty/disjoint/unique coverage | T97 empty input; T114 C10 carrier; T186/T250/T352/T360 exact fibers. Durably complete. |
| C12-S01-B | P110 semantic channel, P113/P127 coordinate/fiber equations, P133/P177/P182 positivity/bounds/finiteness, P162 rows, P212/P217 recovered pattern/value, P224 pattern injectivity | T198 quarter coordinates; T263/T278/T284 identity; T382/T386 mixed coordinates and off-pattern zero. Durably complete. |
| C12-S01-C | P259/P270 bijective family/aggregate transport; shared intrinsic carrier | T114 public C10 grouping; T408/T411/T414/T423/T430 source three-cycle, family, masses and aggregates. Durably complete. |
| C12-S02-A | P323 actual `patternCompression`; P342/P351 column data; P372/P380/P393 length and actual no-op laws | T606/T612/T618 quarter count/labels/coordinates; T645/T664 distinct/singleton no-op; T715/T719/T725 retained mixed path/count/tags. Durably complete. |
| C12-S02-B | P402/P409/P416 supplied states and comparison; P426/P434 actual cascade/reverse; P437/P445 inverse tags/coordinates | T625/T716 actual reversal; T635 unequal recovery; T759/T764/T767/T772 actual endpoint and directed comparison; T791-T808 changed compressed presentation. Durably complete. |
| C12-S02-C | P450/P459/P470 perfectness, FromAllOnes and ToAllOnes iff | T827/T833 nonperfect reachability; T847/T851/T859/T868/T876 generic actual witness consumers. Durably complete. |
| C12-S03-A | P493/P498 Real positivity/bounds; P504 exact conversion; P509/P524/P530 finite sums; P537 rows; P543/P550 coordinates/reconstruction | T891-T916 generic conversions; T970-T983 quarter; T993-T1005 identity total two versus rows one; T1016-T1045 mixed Real coordinates. Durably complete. |
| C12-S03-B | P568 minimal data; P577 extraction; P600 reconstruction; P607/P611/P617/P621 channel data; P629/P657/P670/P696 full family, singleton fiber, value and record recovery | T928 record equality; T934 explicit membership transport; T945-T956 exact/Real rows and data; T1201-T1248 supplied presentations. Durably complete. |
| C12-S03-C | P720/P726 derived bounds/nonempty; P732 supplied state; P780 compressed-channel recovery | T1110-T1158 actual nonperfect data, total three halves and recovered coordinates; T1191/T1194/T1196 bounds/nonempty/empty-family contradiction. Durably complete. |
| C12-S04-A | P952/P968 actual inverse ambient row/atom recovery, using C06 inclusion | T1275 full injected matrix; T1284/T1287 exact/Real zeros and image coordinates; T1291/T1295 no admitted extra label; T1327 inclusion before compression; T1331/T1338/T1345 retained inverse recovery; T1524 changed-source/target inverse at every ambient atom. Durably complete; freshly reassessed in S05. |
| C12-S04-B | P868/P874/P883/P891 injective family/exact/Real/data transport; P902/P908/P919/P929 supplied active-enumeration transport | T1356/T1362 changed source coordinates/map; T1395-T1422 whole injected family and every exact/Real aggregate/full record; T1429/T1438 actual source column pattern/value; T1444-T1471 changed source family/aggregates/data; T1490-T1524 independently cycled target coordinates/comparison/ambient inverse. Durably complete; freshly reassessed in S05. |
| C12-S04-C | P997 `isPerfectlyRepresentableChannel_iff_compressedPatternData`; all earlier interfaces and this crosswalk | T1372 public actual-pattern/Real-constant consumer; T1535 generic ambient iff; T1541 injection specialization. Durably complete; all R01-R13 and the handoff crosswalk were freshly reassessed in S05. Omission/advice dispositions are recorded below. |
| C12-S05-A | Fresh cumulative source/manuscript/build/trust assessment of the twelve earlier criteria and CC01-CC08 | Fresh cumulative source/manuscript/build/trust checks pass. All twelve prior criteria, R01-R13 and CC01-CC08 are covered; prior reports remain separately attributed. |
| C12-S05-B | Fresh source-bound cumulative independent assessment and critical reconciliation | Fresh cumulative independent assessment passes every earlier criterion, R01-R13 and CC01-CC09 review-time readiness. The first B/C temporal gaps are retained; the linked reassessment satisfies all three review-time criteria. Both complete originals are preserved and critically reconciled. |
| C12-S05-C | Final applicable validation, current owning documents, F and durable closure | Advice, omissions and owning documents are current; both reports are reconciled. Final source applicability, F and supported durable closure follow this checkpoint. Only that closure completes CC09 and C12. |

## R01-R13 regression crosswalk

| ID | Discriminating assertion and maintained evidence |
| --- | --- |
| R01 | Quarter weights `1/4,3/4` share one full pattern: T180/T186/T198 exact data; T606-T635 actual compression, complete labels and unequal-value inverse; T970-T983 Real sum/reconstruction. |
| R02 | Identity columns have equal value one and distinct singleton patterns: T237/T243/T250. Mixed singleton fibers T360 retain equal values on different supports. |
| R03 | The quarter fiber is all labels including the last: T186. Actual one-merge count, labels, endpoint and retained reverse: T606-T625. |
| R04 | Identity coordinates, exact total two and rows one: T263/T278/T284. Real total two, row identities and every reconstructed coordinate: T993/T1001/T1005. |
| R05 | Already-distinct identity retains the actual zero-length path and empty tags, with every endpoint coordinate and full label comparison: T645/T649/T656. |
| R06 | Mixed singleton fibers T360; singleton state count/tags, value-one aggregate and actual inverse/no-op coordinates: T664-T697. |
| R07 | Shared source has nonadjacent unequal columns on proper support: T331-T386. Directed recovery permutation and inverse mismatch: T517/T530/T533. Ratio arithmetic: T575. Actual PPM/PPS path and all endpoint coordinates: T715-T772. Real sums and full reconstructed coordinates, including zeros: T1016-T1045. |
| R08 | Existing `nonrepresentable3x3` excludes both compressed reachability predicates: T827/T833. Its exact three pair supports, values one half, total three halves, row identities, recovered coordinates and reconstructed nonperfectness: T1110-T1158. No new counterexample channel is introduced. |
| R09 | Generic exact/Real sums, row identities and full dependent data-to-channel-to-data equality: T891-T956. C06 exact/Real reconstruction: T1176-T1185. Supplied presentation recovery and comparison: T1201-T1248. |
| R10 | Derived value bounds and nonempty pattern family: T1191/T1194; empty family cannot normalize a nonempty input row: T1196. T97 preserves the broader raw empty-input case. |
| R11 | Explicit unchanged-index `Fin 4 → Fin 5` injection: T1255-T1299. All image coordinates, extra-label exact/Real zeros and no admitted extra label are checked. C06 restriction/inclusion and actual inverse recover before/after compression: T1308/T1327/T1331/T1338/T1345; T1524 covers every ambient atom after both enumeration changes. |
| R12 | Original three-cycle and intrinsic exact transport: T408-T430. Independent compressed three-cycle and its directed comparison: T791-T808. Injection and supplied active enumeration preserve the whole family and every exact/Real aggregate/full record: T1395-T1471. Source column patterns/values survive at the changed indices: T1429/T1438. Simultaneous source/target changes, forward versus inverse cycle, all exact/Real coordinates and PMF map: T1490-T1519. |
| R13 | T1372 consumes actual occurrence, positive bounded Real constants, exact conversion, row normalization, reconstructed singularity and full data recovery through public APIs. T1535/T1541 consume the explicit prior-free ambient perfectness bridge. No partition or incidence definition is introduced. The optional separate C11 iff consistency consumer is unnecessary for this direct C06/S02/S03 boundary; C11 source remains unchanged. |

All S01-S03 consumers are retained byte-for-byte before the appended S04 section.
The inverse comparisons use the constructor's actual endpoint and retained output
equivalence. No arbitrary internal merge order or equality with an independently
ordered fixture is assumed.

## Completion outcomes

| ID | Implementation readiness and remaining acceptance boundary |
| --- | --- |
| CC01 | S01-A/C plus S04-B specify intrinsic occurrence/fibers and exact transport independently of output enumeration. |
| CC02 | S02-A/B retain actual PPM compression, PPS reverse, exact coordinates, label comparisons and no-op laws. S04-A includes every ambient atom afterward. |
| CC03 | S01-B proves distinct nonempty patterns and positive finite bounded exact aggregates; S03 derives the corresponding Real bounds and data nonemptiness. |
| CC04 | S02-C preserves/reflects perfectness and both reachability predicates with witnesses. P997 supplies the explicit ambient channel-to-data perfectness bridge. |
| CC05 | S03-A and R01/R04/R07/R09 establish finite Real sums, row normalization, exact conversion and reconstruction. |
| CC06 | S03-B/C and R08/R09/R10 establish minimal nonempty-input data, generic reconstruction, both round trips and inclusion of singular nonperfect channels. |
| CC07 | S04-A/B and R11-R13 implement ambient recovery, changed enumerations and non-surjective output injection with all coordinates and off-image zeros. Validation and independent S04 assessment pass; the original report is reconciled. |
| CC08 | Public ownership, focused imports, pinned reuse and C13-C15 handoff are explicit. Production and maintained test audits pass; independent S04 assessment passes and the original report is reconciled. Existing omission/advice owners are retained below. |
| CC09 | Review-time readiness passes after fresh cumulative implementation/independent validation and reconciliation of both original reports. Final applicability, F and supported durable closure remain required; this checkpoint does not certify those future acts. |

## Omissions, advice and downstream handoff

The [formalization map](formalization-map.md) retains all 71 omission IDs and
four open or partially open decision gates. This step resolves no new gate.

- OM-014/044/068 retain support-finset patterns, explicit presentations,
  exact Real data and membership transport. S04 provides their actual
  injection/enumeration and channel-facing bridges.
- OM-045's inactive-label obligation is exercised by R11. OM-051/052 retain
  the actual C10 synthesis and witnessed reversal; no global inverse or new
  synthesis framework is introduced.
- C11's repeated decoder/vector patterns are intentional compression inputs.
  No C11 private helper is promoted or source changed.
- OM-019's pattern count, OM-025/047 and DG-12's full/reduced incidence repair,
  and extended (54)-(55)'s feasibility-derived partition-weight normalization
  remain C13. The C13 handoff is actual patterns, exact/Real constants, row
  identities and the prior-free channel-to-data perfectness bridge.
- OM-046 and DG-13/DG-14 retain objective-one greatestness/leastness and
  attainment in C14/C15. C12 valid data assume no optimizer or feasibility.
- OM-016/019's running-time prose, OM-017/027/042's Bell/adjacent display
  material and the plan's other extended-only or algorithmic exclusions
  retain their existing dispositions and revisit triggers.
- The optional public idempotence alias was revisited at the S04 trigger on
  2026-09-30. Pattern injectivity, actual no-op length/tags and the full data
  round trip serve all current consumers. Continue deferring a separate name
  to concrete C13 consumer pressure under the original planning-research
  reference and plan Section 9 obligation. This adds no implementation promise.

No new numbered Future Work Note, omission, dependency change or additional
mathematical scope is needed. The original planning/advice records and earlier
review reports remain preserved. S05 freshly reassessed the entire crosswalk
and retained these dispositions. No later chunk starts automatically.
