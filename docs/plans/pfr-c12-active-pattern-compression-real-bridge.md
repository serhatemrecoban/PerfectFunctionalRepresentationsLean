# PFR-C12 — Active-Pattern Compression and the Real Bridge

<!-- pfr-review-status:start -->
**Status:** Active — S01-S04 durably complete; S05 cumulative review reconciled,
final applicability/F and supported durable closure pending.
**Revision:** Approved revision 2, 2026-09-29.
**Authority:** The lead separately requested S05 with review conditional on S04
completion. Startup verified all four original reports/reconciliations, twelve
satisfied criteria and exact agreement of all 145 S04 final source/environment
entries before accepting only S05. S04 durable closure is
`a2672869035f413ec17f44f6624a93fdf0ae95fa4de8fd2abfe352dc172d24de`.
**Review:** Fresh cumulative source/manuscript/build/trust checks and the bound
reviewer's independent assessment pass. Both original reports are retained and
critically reconciled. The linked reassessment distinguishes review-time readiness
from later implementation-task receipt/reconciliation, final applicability/F and
closure; none of those duties is waived. Only subsequent supported durable
closure completes CC09 and C12.
**Boundary:** No later chunk starts. The normative revision-2 contract below is
unchanged; original reviews and historical implementation records are preserved.
<!-- pfr-review-status:end -->

Revision 2 keeps the five steps and mathematical scope. It tests representation
choices earlier, stages regression acceptance explicitly, combines the R07
fixture suggestions and adds a non-surjective injection regression. The
[advice dispositions](../pfr-c12-planning-notes.md#revision-2-advice-dispositions)
record the selections and preserve revision 1's provenance.

## 1. Baseline and authorization boundary

HEAD is `54c1714d1a9a891939d6c9f7d38c0d05896b2c75`. The inherited working
tree includes completed, uncommitted C02-C11 work; HEAD alone does not describe
the mathematical baseline. Before these planning edits, the installed snapshot
matched every one of C11 S06's 139 final source/environment entries, without
additions or differences. All six original execution reports are reconciled,
and all eighteen closing criteria are satisfied. S06 closure is
`618f778c67fc13bf7b4e938a05f22567bacd30cfa93cddf6dc6383881bd4f23f`.
Original C11 pre-F documents and private review records remain historical.

LeanInfoTheory remains immutable `v0.1.0`, commit
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`; Lean is `v4.33.1`, and mathlib
is pinned at `0df444a360eaa60ab8c11dca51a86af692955474`. The installed
inspection found the dependencies clean and matching the manifest.

The lead's endorsement approves the mathematical contract below and resolves
DG-10's remaining C12 design choices. Implementation awaits a separate step
request. No dependency or review-tool change, commit or push is authorized.
Preserve all inherited work.

## 2. Exact manuscript anchors and interpretation

The authenticated local manuscripts remain external or ignored. No paper,
page image or extract belongs in maintained files or private review records.

| Source | Version identity | Relevant anchor |
| --- | --- | --- |
| Six-page ISIT final manuscript, filename ending `final_manuscript_ (3).pdf` | SHA-256 `48963aa59485b2c33b1a1e6e7c6ead2251fdddd26bd3691b6fcffe683e6ed1c4` | Section IV opening, PDF p.4 lower left continuing at top right, before IV-A: equal-pattern merging, obtainability equivalence, distinct patterns and reconstruction from patterns/values. |
| Eighteen-page extended draft, version 16, designated 2026-09-03 | SHA-256 `98636d4c9f0618ec08fca84559572780f604f197fda90d8d7c787b3624245b8f` | Section IV opening, p.5 right, same compression argument; IV-A (39), p.5, and (40)-(42), p.6, clarify full versus occurring patterns and zero extension. |
| Same extended companion, boundary inspection only | Same binary | IV-A (43)-(53), (56) and adjacent deletion/extension argument on p.6 belong to C13. Equations (54)-(55) normalize partition weights using a chosen input row, not the sum of pattern values. |

The manuscript prose permits assuming distinct patterns after merging. The
Lean contract must retain the actual merge path, its exact endpoint comparison
and a witnessed inverse. The finite semantic pattern family is independent of
output enumeration; a sorted or otherwise chosen `Fin m` representative is not
its identity. C06's nonempty support finset remains the pattern representation.

The printed values lie in `[0,1]`. On occurring active patterns, the precise
contract is strict positivity and an upper bound of one. Zero values belong
only to a later extension outside the occurring family, not admitted columns.
Normalization is per input row. The sum of all distinct-pattern values need
not equal one. No assumption of perfect representability, feasible partition
weights or an optimizer may be used to define valid compressed data.

The opening bound `m ≤ 2^k - 1` remains C13, as explicitly requested. The
opening linear-time singularity claim remains documentation-only. Adjacent
incidence systems, coordinate-count repair and primal/dual statements are
read for compatibility and retain C13-C15 ownership. Reauthenticate affected
contracts if the designated extended manuscript changes.

## 3. Ownership, consumers and non-goals

Production owner: `PerfectFunctionalRepresentations/Matrix/PatternCompression.lean`.
Use namespace `PerfectFunctionalRepresentations`; operation-specific results
may sit in its existing `MatrixOperations` namespace. The expected focused
imports are `Matrix.MultiwayOperations` and `Matrix.Reachability`, whose
closures already include C06 column data and C09 preservation. Do not import
`CanonicalReachability` merely to turn a constructive proof into an iff rewrite.
Its public equivalences may be used in external integration consumers.

Public consumers/regressions belong in
`PerfectFunctionalRepresentations/Tests/Matrix/PatternCompression.lean`.
One-off label bijections and proof machinery remain private/local. Reuse
`LabelledOperationResult` and `Cascade` for the compression certificate unless
an actual consumer shows a missing field. Do not introduce a second path,
probability, column-data or arbitrary quotient framework. The root
`PerfectFunctionalRepresentations.lean` remains lightweight and unchanged.

C13 needs finite occurring pattern indices, their inclusion into nonempty
input patterns, strictly positive Real constants and weighted row identities,
together with a reconstructed singular channel and the perfectness bridge.
These requirements justify one minimal compressed-data package. C14/C15
will consume it through C13. No partition enumeration, incidence matrix,
feasibility theorem, weight normalization, pattern-count theorem, LP solver,
primal/dual theorem, generic LP theory or extended-only result is in C12.
Do not promote C11 private canonical or NormalForm machinery.

## 4. Mathematical contracts and approved DG-10 resolution

Names below describe proposed declarations, not verified existing API names.
Their spelling/private decomposition may improve while preserving these
hypotheses, witness content and conclusions.

### 4.1 Intrinsic occurring patterns and fibers

For `κ : α → PMF β`, with finite input and output alphabets, use C06's
`activeOutputs κ` and `columnPattern κ` on active labels. The occurring family
is exactly the finite range of that pattern map in
`{p : Finset α // p.Nonempty}`. Its elements are the patterns themselves,
not chosen representative columns. The fiber of occurring pattern `p` is
the finite subtype of active outputs whose pattern equals `p`.

Choose one occurring-pattern carrier for the semantic channel, aggregate
family and later membership-indexed Real data. If C10's `Set.range` carrier
requires a correspondence with that carrier, establish it once in S01's
interface consumer and reuse it. Equivalent finite presentations must not
create competing notions of pattern identity.

Expose membership/existence, fiber nonemptiness, equality/disjointness and
coverage sufficient to reindex finite sums. Singularity is needed for values
and reconstruction, not to define the support pattern. Use `[Fintype α]`
where finite supports are exposed; `[Finite β]` may be used at the ambient
boundary with internal finite enumeration. Keep `DecidableEq` choices internal
where practical. No empty or globally zero column receives column data.

For singular κ and occurring p, define the exact aggregate

```text
Vκ(p) = ∑ y in the active equal-pattern fiber of p, columnValue κ hκ y.
```

Equivalently sum over all active labels with an equality filter. Prove the
equivalence of these sums. Equal patterns can have unequal values. No group
may be split by value, nor may a representative value replace the sum.

The semantic compressed channel on occurring patterns is the pushforward of
each active-restricted row by the pattern map. Prove, for every x and p,

```text
compressedκ x p = ∑ y in fiber(p), κ x y
                = if x ∈ p then Vκ(p) else 0.
```

Use this to prove its singularity, activity, exact supplied patterns, exact
aggregate values, pairwise distinctness and row identities. Positivity follows
from a nonempty fiber and positive original values. For the upper bound, pick
an input in the nonempty pattern and identify Vκ(p) with a PMF entry; equivalently
use C06's normalized column-family bound. Thus `0 < Vκ(p) ≤ 1` and
`Vκ(p) ≠ ∞` are conclusions, never unsupported aggregate assumptions.

Prove invariance of the occurring family and every exact aggregate under a
supplied bijective output relabeling here. This checks enumeration independence
before operation and Real-data API accumulate. S04 extends the boundary to
injective relabeling and full ambient coordinate recovery.

### 4.2 Actual finite compression and witnessed inverse

For singular `S : ActiveFiniteChannel α`, specialize C10 `multiPpmFibers`
using the map from original labels to their occurring pattern, or use
`multiPpmRange` with the proved range correspondence. The grouping map is
surjective onto exactly the occurring patterns, and pattern equality supplies
the same-support hypothesis. Retain the actual `LabelledOperationResult`:
endpoint T, PPM-only path, complete pattern-to-output equivalence and its
coordinate specification. Instantiate the existing admitted value/pattern
specifications. Prove a directed `OutputEquiv` to any supplied finite
presentation of the independently defined semantic compressed channel.

Retain the resulting `Cascade S compressedState` and apply the existing
`Cascade.reverse` to that very witness. The inverse is PPS-only, includes the
remembered ratios and directed endpoint comparison, and reconstructs every
original coordinate after that comparison. Do not assert literal equality
of chosen ordered endpoints or a global inverse determined by compressed data.
Reduced data alone do not recover original multiplicities or the values inside
each fiber; those are retained by the compression witness and reversal.

Prove through these actual witnesses:

```text
Perfect(S) ↔ Perfect(compressedState)
FromAllOnes S ↔ FromAllOnes compressedState
ToAllOnes S ↔ ToAllOnes compressedState.
```

All four reachability directions must expose the appropriate concatenation
with compression or its inverse and prove its tag restriction. Both PPM and
PPS are allowed in both required restrictions. Perfectness follows from the
existing path/cascade preservation and reflection results. C11's iff theorems
are an available compatibility check, not a replacement for the witnesses.

Prove the actual compression length is original output count minus occurring
pattern count, using C10's length theorem. Already-distinct input has an actual
zero-length path and empty tags, with a retained endpoint comparison. An
all-columns fiber reaches one full-input pattern with exact value one.

### 4.3 Exact aggregate conversion to Real

Set `vκ(p) := (Vκ(p)).toReal`. Require all of:

1. `0 < vκ(p) ≤ 1`, exact aggregate finiteness and nonnegativity.
2. `ENNReal.ofReal (vκ(p)) = Vκ(p)`.
3. `vκ(p) = ∑ y in fiber(p), (columnValue κ hκ y).toReal`;
   the filtered and subtype forms agree.
4. `∀ x, ∑ p, if x ∈ p then Vκ(p) else 0 = 1` and its exact Real counterpart.
5. Every Real compressed coordinate is the indicator times/conditional
   occurrence of `vκ(p)`, and applying `ofReal` reconstructs its exact mass.
6. C06 exact and Real matrix/column reconstruction return the semantic
   compressed channel, with the explicit finite-presentation comparison
   when coordinate types differ.

The finite-sum `toReal` law must discharge finiteness term by term. Do not
silently apply it to arbitrary ENNReal values. These are aggregate applications
of completed C06 conversions, not a replacement numeric foundation.

### 4.4 Minimal valid compressed data and converse

Propose one Real-facing `CompressedPatternData α` under
`[Fintype α] [Nonempty α]`, with just:

- a finite set of nonempty input-support finsets;
- a Real value indexed by membership in that set;
- strict positivity of each value; and
- the weighted row identity for each input.

Uniqueness is structural because members are actual patterns. Do not add an
arbitrary finite index carrier, redundant bounds, a perfectness field,
partition weights, feasibility or attainment. An equivalent minimal packaging
is acceptable only if it preserves intrinsic pattern identity and is justified
by the first consumer. The exact aggregate family remains a theorem-backed
precursor rather than a second parallel public data structure.

For arbitrary valid data D, reconstruct a channel using C06
`channelOfColumnData`, the supplied nonempty patterns and `ofReal (D.value p)`.
Derive ENNReal row normalization from nonnegative Real finite sums. Prove
activity, singularity, every coordinate, exact pattern and value recovery,
the derived upper bounds and nonempty output family. Prove the round trips:

- channel → compressed data → channel returns the semantic compressed channel;
- valid data → reconstructed channel → compressed data returns the same
  pattern set and every value, with an explicit membership transport if needed;
- any finite enumeration of those patterns presents that channel via a
  directed output equivalence; values and supports agree under its maps.

Equality of proof fields or chosen enumerations is not a mathematical target.
Use extensionality or a small extensional recovery theorem without constructing
a second equivalence hierarchy. The domain includes singular nonperfect
channels; the existing C03 counterexample must instantiate it.

### 4.5 Ambient and numeric interface boundaries

For arbitrary finite ambient outputs, restrict through C06 before compression.
Prove inclusion recovers original rows before compression and that the
retained inverse, followed by C06 inclusion, recovers them afterward. Unused
labels have zero mass and no admitted pattern/value. Prove extraction and
aggregation commute with a supplied change of active enumeration or injective
output relabeling, using the induced equivalence of active fibers. Supply exact
coordinate equations, not merely equal cardinalities.

Expose the end-to-end consequence for a finite ambient singular channel:
its perfect representability is equivalent to perfect representability of the
channel reconstructed from its extracted valid compressed data. The proof
must pass through the actual C06 restriction/presentation, S02 compression
certificate and S03 reconstruction laws. This is the C13-facing semantic
bridge and requires no input prior or full-support premise.

DG-10 decision: aggregate in ENNReal; derive finite positive bounded Real
constants by exact conversion; define valid Real pattern data by positivity
and row normalization; reconstruct a singular channel with `ofReal`. Later
optimization variables are Real nonnegative coefficients. C12 supplies their
constant-data boundary, without requiring those coefficients to exist. C13
must prove feasibility forces total partition weight one and justify any
conversion to positive-support C10 synthesis weights. C10 already supplies
normalized ENNReal/NNReal synthesis adapters. C12 does not duplicate them or
assume C13's normalization theorem. Approval of revision 2 resolves C12's
remaining DG-10 design choices; the required proofs remain implementation duties.

## 5. Verified reuse and feasibility evidence

| Existing owner | Verified declarations / purpose |
| --- | --- |
| C06 `Matrix.Channel` | `restrictActiveOutputs`; `ActiveFiniteChannel.ofChannelWithEquiv`, its apply/recover/compare and singularity/perfectness iff laws; `ofActive` and its comparison; `channelOfMassMatrix`, `channelOfRealMatrix`, exact/Real row sums and two-sided reconstruction. |
| C06 `Matrix.SingularColumns` | `columnPattern`, `mem_columnPattern`, `columnValue`, positivity/bound/finiteness and `ofReal_columnValue_toReal`; `column_eq_ite`; `channelOfColumnData`, exact supplied value/pattern recovery, `columnData_value_le_one`, `columnData_toReal_row_sum`, exact/Real reconstruction. |
| C10 `Matrix.MultiwayOperations` | `LabelledOperationResult` fields and `.isSingular`, `.outputEquiv`, `.cascade`; `multiPpmFibers`, `multiPpmRange`, `multiPpmFibers_columnValue`, `multiPpmFibers_columnPattern`, `multiPpmRange_map`, `multiPpmFibers_length`. |
| C08/C10 path and reachability | `Cascade.comp`, `Cascade.reverse`, tag/restriction laws, `OperationPath.Homogeneous`; cascade perfectness preservation/reflection; `FromAllOnes`, `ToAllOnes` and their output-equivalence transport. |
| C11, optional external consumers | `isPerfectlyRepresentable_iff_toAllOnes`, `isPerfectlyRepresentable_iff_fromAllOnes`; no private names. |
| Pinned mathlib | Finite ranges/subtypes and sum reindexing; PMF map atoms and support; `ENNReal.toReal_sum`, `ofReal_toReal`, `toReal_ofReal`, `ofReal_sum_of_nonneg`, positivity and order conversion. |

Discovery consulted the installed LeanInfoTheory source and public API
contract, API documentation, declaration index, theorem highlights and module
guide, together with pinned mathlib and local consumers. No new generic
information-theory result is needed; the paper-specific compression belongs
here. Disposable probe source, commands, actual outcomes and limitations are
recorded in the planning notes. Probe success demonstrates interface feasibility,
not completion of these proposed outcomes. No discoverability issue warrants
a new library-friction entry unless a concrete failed search establishes one.

Planning validation passed 38 declaration checks and seven anonymous generic
feasibility consumers through the two proposed imports. They cover the pattern
map into actual C10 PPM, exact finite sum conversion, witnessed PPS reversal,
perfectness/both reachability iff statements, Real bounds and componentwise
reconstruction. Full data extensionality and R01-R13 remain implementation
duties. The notes preserve intermediate elaboration failures and the final
successful source hashes. The fresh default build passed with 2762 jobs.

## 6. Approved dependency-driven steps

Five steps separate intrinsic data, constructive paths, numeric validity,
integrated consumers and fresh cumulative acceptance. Real bounds can reuse
the semantic channel from S01 while S02 independently preserves the actual
operation witness. Combining integrated readiness with fresh closeout would
hide the requirement for a separate cumulative independent pass.

Each implementation prompt authorizes exactly one approved step. No later
step follows automatically. All steps include their relevant tests, source/API
audit, documentation and normal installed review phases when requested.

### PFR-C12-S01 — Intrinsic pattern fibers and exact compressed channel

Prerequisites: completed C06-C10. Implement §4.1, including the finite range,
equal-pattern fibers, aggregate values, semantic pushforward and all exact
coordinate/column/normalization laws. Use the C10 grouping consumer early
enough to confirm the source-to-pattern map has the required type; S02 owns
the maintained operation certificate and inverse.

- **C12-S01-A:** Occurring patterns and fibers are intrinsic, exhaustive and
  nonempty; no value-based grouping or admitted zero column; R01/R02/R07.
- **C12-S01-B:** Every compressed coordinate and exact aggregate is specified;
  activity, singularity, distinctness, positivity, bounds, finiteness and row
  sums are derived from actual channel structure; R01/R03/R04/R07.
- **C12-S01-C:** Focused public consumers, light imports and verified reuse
  establish the shared S02/S03 carrier interface and bijective source-relabeling
  invariance; R12. Documentation records representation and normalization
  distinctions. Builds and placeholder/API audits pass.

### PFR-C12-S02 — Actual compression, inverse and preservation

Depends on S01. Implement §4.2 with C10's actual returned result and an
independently specified semantic target. Supply arbitrary compressed
enumerations at this boundary, actual reverse and all three iff statements.
Instantiate length/no-op laws on the returned compression, not a substitute.

- **C12-S02-A:** PPM-only compression retains its full labels, exact sums,
  patterns, target comparison and actual length; R01/R03/R05/R06.
- **C12-S02-B:** The reverse of that certificate is PPS-only and recovers all
  original coordinates through directed maps, including unequal fiber values;
  R01/R06/R07.
- **C12-S02-C:** Perfectness and both all-ones reachability iff statements use
  the actual compression/reverse composites with verified restrictions.
  Tests extract the witnesses, and validation/documentation pass; R07/R08.

### PFR-C12-S03 — Exact Real aggregates and valid compressed data

Depends on S01-S02. Implement §4.3-4.4, including aggregate sum conversion,
minimal data extraction, generic converse and both round trips. As the first
representation check after the minimal definitions and reconstruction laws,
prove the full generic data→channel→data recovery: equality of the whole
occurring pattern set, singleton extraction fibers, and recovery of every
aggregate value through the induced membership transport. Reuse S01's carrier
correspondence. Complete this check before convenience API or specialized
consumers; fieldwise recovery on unchanged labels alone does not discharge it.
All finiteness, positivity and bounds must be derived.

- **C12-S03-A:** ENNReal/Real aggregates commute with finite fiber sums and
  reconstruct every mass; strict positivity, bounds and both row identities
  hold with no total-pattern normalization assumption; R01/R04/R07/R09.
- **C12-S03-B:** Arbitrary valid Real data reconstruct an active singular
  channel and recover their exact pattern family and every value. Both round
  trips, including membership transport, and finite presentations compile;
  R09/R10.
- **C12-S03-C:** The data domain includes the existing singular nonperfect
  example. Nonempty input is explicit, no partition feasibility is assumed,
  and the public package is minimal. API/trust audits, builds and DG-10
  implementation notes pass; R04/R08/R10.

### PFR-C12-S04 — Ambient reconstruction and integrated readiness

Depends on S01-S03. Complete §4.5 and the regression crosswalk below. Add only
necessary public boundary facts; keep fixtures private or in the test module.
Prepare a readiness audit linking every manuscript obligation, criterion,
regression and completion outcome to actual declarations/checks. Demonstrate
the C13-facing consumer using actual patterns and Real constants, without
defining partitions or incidence feasibility.

- **C12-S04-A:** C06 active restriction/inclusion and actual inverse recover
  all original ambient coordinates; unused outputs have zero mass; R11.
- **C12-S04-B:** Changed source and target enumerations preserve semantic
  patterns, aggregates, coordinates and comparisons. The integration uses
  public APIs only and tests a non-involutive permutation and a non-surjective
  output injection with explicit off-image zeros; R11/R12/R13.
- **C12-S04-C:** R01-R13 and the readiness crosswalk are complete; consumer
  pressure justifies public exports/imports, the ambient channel-to-data
  perfectness bridge is explicit, C13-C15 duties retain owners, and all
  relevant validation and advice dispositions are recorded.

### PFR-C12-S05 — Fresh cumulative independent validation and closeout

Depends on durably completed S01-S04. Freshly reassess all twelve prior step
criteria, R01-R13 and CC01-CC09 against actual source and exact manuscript
anchors. Perform focused/default builds and exhaustive signature/axiom/import
and placeholder audits for every C12 declaration and anonymous consumer.
Then obtain a fresh source-bound cumulative assessment from this chunk's
persistent reviewer under the installed workflow.

- **C12-S05-A:** Fresh source/manuscript/build/trust review establishes all
  earlier mathematical criteria and CC01-CC08 with exact assumptions,
  witnesses, round trips and edge cases; previous favorable reports remain
  attributed evidence rather than a replacement for this pass.
- **C12-S05-B:** The persistent reviewer independently assesses every required
  earlier criterion, regression and completion outcome, including CC09's
  review-time readiness. Its complete original report is retained and
  critically reconciled; no correctness gap or unresolved material finding
  remains.
- **C12-S05-C:** Advice/omission dispositions and handoff documents are current,
  final validation is applicable to the final bytes, and the installed F/closure
  process completes CC09 after reconciliation. No later chunk starts.

If this pass finds a defect requiring a substantive mathematical/scope decision,
retain the evidence and ask the lead. Otherwise repair in scope, revalidate and
renew affected review as required; do not silently weaken criteria. A reviewer
cannot certify its own future receipt, reconciliation, F or closure. Only the
subsequent supported durable closure establishes C12 completion.

## 7. Discriminating regressions

Each row is a maintained proof consumer obligation, not a numerical experiment.
Use exact rational values and check all specified coordinates/reconstruction.
Shared fixtures may support several rows; the staged assertions below determine
what is due at each step. An early citation of a regression does not require
its later-step assertions prematurely.

| ID | Discriminating case | First owner |
| --- | --- | --- |
| R01 | Unequal values on one repeated pattern, e.g. `1/4` and `3/4`, aggregate to one. Exact and Real sums, every row, retained inverse recovering each unequal value. | S01; extend S02/S03 |
| R02 | Equal values on different patterns remain different groups; the grouping criterion is pattern alone. | S01 |
| R03 | All source columns in one group, including the last original label: full-input pattern, aggregate one, complete labels and actual merge count. | S01/S02 |
| R04 | Two-input deterministic identity: distinct singleton patterns each with value one; every row sums to one while total pattern values equal two. | S01; extend S03 |
| R05 | Already-distinct patterns: returned path length zero and empty tags, with complete endpoint coordinate comparison. | S02 |
| R06 | Singleton input/output, singleton fibers inside a nontrivial family and value-one aggregate; actual no-op stages and labels. | S02 |
| R07 | The shared proper-support fixture below: unequal nonadjacent columns aggregate below one; check off-pattern zeros, reverse witness and every original coordinate. The directed recovery map must distinguish its inverse. | S01 exact fixture; extend S02/S03 |
| R08 | Existing `nonrepresentable3x3`: form valid compressed data despite nonperfectness; patterns remain the three pair supports, values `1/2`, total `3/2`; both reachability predicates remain false using public existing facts. | S02/S03 |
| R09 | Generic valid Real family: `ofReal`/`toReal`, exact/Real rows and full data→channel→data recovery; no probability-to-real loss. | S03 |
| R10 | Valid-data nonempty-output consequence from a chosen input; empty pattern family cannot normalize a nonempty row. Empty-input LP data is excluded explicitly, while C06's broader raw boundary is preserved. | S03 |
| R11 | Unused ambient labels: restrict, compress, reverse and include, with exact zero coordinates outside activity and no fabricated admitted data. Include the explicit non-surjective injection below. | S04 |
| R12 | Change original output enumeration and separately choose a changed compressed enumeration, using a three-cycle; match each intrinsic pattern/value and every coordinate. Also inject the source into a larger ambient alphabet and check unchanged extracted family and every aggregate. | S01 intrinsic invariance; extend S02/S04 |
| R13 | Public C13-facing extraction/reconstruction consumer plus optional C11 public-iff consistency consumer, no compiler-private names or incidence implementation. | S04 |

### Shared R07 fixture and directed presentations

Use two inputs and four active outputs, with source and compressed matrices
in input-row/output-column orientation:

```text
M = [ 1/6   0    1/2   1/3 ]       C = [ 1/2   0    1/2 ]
    [  0   1/2   1/2    0  ]           [  0   1/2   1/2 ].
```

Merge columns 0 and 3, whose common pattern is the proper support `{0}`.
The ordered compressed patterns are `{0}`, `{1}`, `{0,1}`, each with value
`1/2`. Every row normalizes while the total pattern value is `3/2`.
Original columns 1 and 2 have equal values but different patterns and remain
separate. This combines the two suggested fixtures; R01/R03 retain the
full-support, aggregate-one cases without a duplicate four-column fixture.

In this chosen compressed presentation, splitting column 0 with relative
weights `1/3, 2/3` gives

```text
R = [ 1/6   1/3    0    1/2 ]
    [  0     0    1/2   1/2 ].
```

The map from recovered indices to original indices is `ρ = [0,3,1,2]`, so
`(R x).map ρ = M x`. Its inverse is `[0,2,3,1]`; incorrectly using that
inverse in the same direction sends row 0, output 1 to `1/2` instead of `0`.
Compare the generic constructor's actual endpoint and retained reversal with
these presentations through its labels or a directed `OutputEquiv`; the
matrices are not a claim of definitional equality for arbitrary enumerations.

For R11/R12, also use the injection `Fin 4 → Fin 5` sending each original
index to the same numeric index. The added output 4 has zero mass in every
row. Check the full extracted pattern set and every exact/Real aggregate are
unchanged, then exercise ambient recovery. This is separate from the bijective
relabeling checks and needs no new public relabeling framework.

### Assertions due at each step

| Step | Required regression assertions at that boundary |
| --- | --- |
| S01 | R01 exact aggregate/coordinates; R02 grouping by pattern; R03 exact one-pattern channel; R04 exact row-versus-total distinction; R07 source/fibers/exact compressed coordinates; R12 bijective source-relabeling invariance of the whole pattern family and every exact aggregate. |
| S02 | Extend R01 with witnessed unequal-value recovery and R03 with complete labels/merge count. Complete R05/R06 operation/no-op assertions and R07 actual path, retained reverse and directed comparison. R08 establishes both reachability predicates remain false using existing public facts. R12 checks supplied target presentations and their directed coordinate comparison. |
| S03 | Extend R01/R04/R07 with exact Real conversion and reconstruction, and R08 with valid compressed data despite nonperfectness. Complete R09's generic full data round trip early, including membership transport, and R10's nonempty-output/empty-family boundary. |
| S04 | Complete R11 ambient restriction/inverse/inclusion and the R11/R12 non-surjective injection. Finish R12's combined source/target comparisons and all exact/Real transport; complete R13 and the cumulative R01-R13 readiness crosswalk. |
| S05 | Freshly reassess every completed assertion in R01-R13; no new deferred portion is reserved for closeout. |

Compression idempotence as a separately named API is optional: its mathematical
content is already checked by distinctness and R05. Revisit only if C13's
extraction/reconstruction consumer needs a public statement; owner C12-S04/C13
planning. No canonical ordering or shortest-path theorem is promised.

## 8. Validation, documentation and completion

During each coherent Lean change build
`PerfectFunctionalRepresentations.Matrix.PatternCompression` and
`PerfectFunctionalRepresentations.Tests.Matrix.PatternCompression`; include
important actual downstream imports. At integration/closeout also build the
C10 synthesis and C11 public-characterization test modules when used. Run
`lake build` before every milestone. Do not count compiling probes as maintained
coverage or infer full test coverage from the lightweight default target.

Require the repository placeholder scan with
`\b(sorry|admit|axiom|opaque|undefined)\b` over all maintained Lean files to have
no matches. Audit all new public signatures, imports, proof assumptions and
axioms; cumulative closeout must include private named machinery and anonymous
examples, preserving actual source/declaration inventories and check results.
Distinguish fresh checks, applicable prior checks and reviewer-reported checks.

Inspect the final working diff against the real step baseline, Git status,
untracked files, tracked generated files, ignored references and scratch.
Preserve `.pfr-review/` and all original reports. Owning documents must be
updated before final source capture, with pending closure labelled accurately.

| ID | Completion outcome |
| --- | --- |
| CC01 | Intrinsic occurring patterns and all equal-pattern fibers are fully specified independently of output enumeration. |
| CC02 | Actual PPM compression and witnessed PPS inverse have exact coordinates, complete label comparisons and no-op laws. |
| CC03 | Compressed patterns are distinct/nonempty and exact aggregate values have derived positivity, finiteness and bounds. |
| CC04 | Perfectness, FromAllOnes and ToAllOnes are preserved/reflected with the actual witnesses available. |
| CC05 | Real sums, row normalization, exact conversion and compressed-channel reconstruction are proved. |
| CC06 | Minimal valid Real data include nonperfect singular channels; generic reconstruction and both round trips hold at the nonempty-input boundary. |
| CC07 | Ambient restriction/recovery, enumeration comparisons and injective output relabeling preserve every coordinate, pattern and aggregate, with explicit off-image zeros; R01-R13 are covered. |
| CC08 | Public ownership/imports and pinned reuse are audited; source/omission/deferral records and C13-C15 handoff are current; no unauthorized later mathematics. |
| CC09 | Fresh cumulative independent review, complete reconciliation, final applicable validation, owning documents, F and durable closure are all complete. Review-time readiness alone is insufficient. |

Implementation notes own dated evidence, the readiness audit owns the final
crosswalk, the project log owns milestones and advice history, and the living
summary owns current status/risks. Update the map for DG-10 approval and actual
coverage; keep the roadmap directional. Update README/scope only for relevant
reader-facing status or real boundary changes. No documentation status may
silently turn this draft into an approved contract.

## 9. Omissions, mapped deferrals and revisit triggers

No numbered Future Work Notes existed at planning startup. Relevant suggestions
already have the owners below; do not create duplicate notes. These entries
record every intentionally omitted part of the reviewed anchors, including
prose and boundary-only extended material.

| Source/record | Disposition and owner/trigger |
| --- | --- |
| OM-014/044/068, ordered divided columns | Retain C06 nonempty support finsets; C12-S01/S03/S04 prove occurrence, values and presentation bridges. No new ordered-pattern semantic identity. |
| OM-045, inactive labels | Reuse C06 restriction/inclusion; C12-S04/R11 handles the full ambient round trip. |
| OM-051/052, inverses and multiway shorthand; C10 plan §10 | Actual C10 prescribed fibers and reversal are consumed in S02. No global inverse, new synthesis framework or promotion of private C08 machinery. |
| C11 readiness handoff | Repeated decoder/vector patterns are intentional inputs to C12-S01/S02; C11 source remains unchanged. |
| OM-019, opening pattern-count bound | C13 owns `m ≤ 2^k - 1`; revisit with incidence-system planning. C12 provides distinct nonempty pattern indices only. |
| OM-016/019, singularity-check and broader running time | Documentation-only; no complexity or executable-check theorem in C12. |
| OM-017/027/042, Bell discussion, adjacent examples and display granularity | Bell counts/growth remain excluded; exact partitions/incidence fixtures belong to C13. No new public theorem for every displayed equation. Completed Figure 1/Example 6 content is not duplicated. |
| OM-025/047 and DG-12, full/reduced systems | C13 owns enumeration, zero extension/restriction, nonnegative feasibility equivalence and coordinate repair. C12 provides the actual occurrence inclusion and valid constants; it does not admit the defective mixed system. |
| Extended (54)-(55), partition weights | C13 must derive their total weight one from feasibility using a nonempty input row. C12's row identity is supplied, never substituted by total pattern-value one. |
| OM-046, DG-13/DG-14 | Objective-one greatestness/leastness and attainment remain C14/C15; no feasibility or optimizer premise in C12 valid data. |
| OM-018/028-032/039/043 and roadmap | Solvers, generic LP theory, extended-only algorithms/hardness, and canonical/shortest normal forms remain outside scope. Revisit only in their mapped owners or separately approved work. |
| Optional public idempotence alias | Source: C12 planning research. Its content is covered by CC02/CC03 and R05; revisit public API value at C12-S04 or a concrete C13 consumer. No separate implementation promise. |

Record these dispositions under existing map entries where they fit; a genuinely
new omission needs its own stable entry. Optional advice of uncertain value may
remain deferred with its original reference and trigger. Required correctness
or acceptance concerns must be resolved or escalated, never deferred away.

## 10. Revision policy and separately requested plan review

Revision 2 is approved. Any separately requested independent
plan review uses the retained C12 reviewer and a fresh source-bound plan session.
It does not approve execution. Preserve the original draft/review and every
subsequent advice disposition. Use the installed review process to assess the
actual resulting work; requested
settings remain separate from unknown effective settings, and read-only reviewer
behavior remains instruction-level rather than OS isolation.

During an authorized step, use judgment to improve the proof route,
organization, tests or plan details when evidence warrants it. Record the
change and its reason in the plan or implementation notes, preserve the
original contract and review records, and ensure review addresses the actual
result. Reassess affected later steps without starting them. A substantive
change to mathematical intent, scope, assumptions or acceptance requires the
lead. The reserved status block contains editorial progress only; required
outcomes must not be silently weakened or rewritten as progress notes.
No step prompt authorizes a later step, dependency upgrade, commit or push.

Proposed independent plan-review criteria, for a later explicit request:

- **C12-PR01:** Baseline, completed prerequisites, exact manuscripts and
  authorization boundaries are supported by attributed evidence.
- **C12-PR02:** Intrinsic grouping, unequal values, actual finite PPM/reverse
  witnesses, directed maps and preservation/reflection cover the source claim.
- **C12-PR03:** DG-10 aggregate conversion, minimal Real validity and both
  reconstruction directions are sound without assuming perfectness/feasibility.
- **C12-PR04:** Verified reuse/probes, ownership/imports and dependency-driven
  steps make all outcomes feasible without private C11 promotion.
- **C12-PR05:** Edge cases and R01-R13 discriminate wrong grouping, wrong
  normalization, inactive labels and incorrect enumeration/recovery maps.
- **C12-PR06:** Omissions/deferrals, C13-C15 boundaries, validation, cumulative
  independence, documentation and revision/stop rules cover the whole chunk.

Planning is complete and revision 2 is approved. Implementation starts only
with a separately authorized step request.
