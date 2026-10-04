# PFR-C10 - Generic reachability and the easy direction

**Revision:** 2, 2026-09-28  
<!-- pfr-review-status:start -->
**Status:** Approved / Active finalization checkpoint; implementation and fresh cumulative independent assessment complete  
**Owner:** C10 planning and implementation task  
**Authority:** The lead endorsed revision 2 and separately requested all seven steps with review; the fresh S07 request was accepted after verified S06 closure on 2026-09-29.

S01-S06 are durably complete. S07's fresh cumulative independent report satisfies
all three current criteria and reassesses all eighteen earlier criteria, R01-R18
and CC01-CC08 review-time readiness. Its one optional stale-status finding is
corrected in the living summary. The complete original report is critically
reconciled. Final applicable validation/F and supported durable
closure follow this checkpoint; only that later record completes CC08 and closes
C10. Included documents then remain fixed. C11-C16 remain unstarted.
Current evidence belongs to the [implementation notes](../pfr-c10-implementation-notes.md)
and [readiness audit](../pfr-c10-readiness-audit.md). Earlier originals, advice and
skipped requests remain historical; no separate revision-2 plan review is claimed.
<!-- pfr-review-status:end -->

The seven steps below follow proof dependencies and separately reviewable outcomes.

## 1. Baseline and prerequisites

Use the actual inherited working tree at HEAD
`54c1714d1a9a891939d6c9f7d38c0d05896b2c75`, including completed uncommitted C01-C09
mathematics. HEAD alone is not the implementation baseline. The pre-edit inventory,
fresh checks, source identities and durable prerequisite reconciliation are in
[C10 planning notes](../pfr-c10-planning-notes.md). Preserve inherited changes.

C06 supplies `ActiveFiniteChannel`, active columns, exact coordinates, finite
presentations and admitted singular-column data. C07 supplies legal binary
operations, their coordinates and remembered recoveries. C08 supplies witnessed
`OperationPath`, directed `OutputEquiv`, `Cascade`, transport and composition;
its normal-form theorem is available for consumers, not a synthesis constructor.
C09 supplies `allOnes` and the six local perfectness/nonperfectness implications.
C01-C09 are completed prerequisites, subject to concrete source discrepancies.
Their original pre-finalization documents remain historical; later durable
closure determines completion. No earlier mathematics is reopened by startup.

LeanInfoTheory remains immutable `v0.1.0`, commit
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`. Lean is `v4.33.1`; mathlib is
`v4.33.1`, commit `0df444a360eaa60ab8c11dca51a86af692955474`.
Planning probes demonstrate existing API consumption and limited feasibility;
they are not completed steps or independent acceptance.

Revision 2 incorporates selected clarifications from the revision-1 reviewer,
parent assessment and user-supplied General Assistant advisory. The original
proposal, reports and suggestion dispositions are retained in the planning notes
and private evidence, including revision 1's report-admission format limitation.
Revision 2 is now approved; no independent review of revision 2 is claimed.

## 2. Manuscript anchors and interpretation

Both local source binaries were freshly hashed and have the designated six and
eighteen pages. Exact local paths and inspection evidence are in the planning
notes; no manuscript, extract or rendered page is a maintained deliverable.

| Source | Identity and relevant anchors |
| --- | --- |
| Six-page ISIT final, filename ending `final_manuscript_ (3).pdf` | SHA-256 `48963AA59485B2C33B1A1E6E7C6EAD2251FDDDD26BD3691B6FCFFE683E6ED1C4`. III-A, p. 3: the binary operations, reused through C07. III-B, p. 4 left: all-ones repeated-use paragraph, Theorem 1 and its “if” paragraph, Lemmas 5-6 and the inverse prose. IV opening, p. 4 left/right: equal-pattern merging. IV-A, p. 4 right: the three numbered PPS/VPS/PPM construction instructions after (16). |
| Designated extended version 16, designated 2026-09-03 | SHA-256 `98636D4C9F0618EC08FCA84559572780F604F197FDA90D8D7C787B3624245B8F`. III-B, p. 4 left: Theorem 1's opening/easy direction. P. 4 right, final construction after (24): multiway weighted and partition splitting; C10 supplies only the generic machinery. P. 5 left continuing at the top right, Example 6 (25)-(32): the reduction certificate. IV-A, p. 6 right: numbered PPS/VPS/PPM construction after (56). |
| Existing proof companions | C07's operations/recoveries and C09's proofs of (175)-(202), Appendix B pp. 15-16, are reused as completed mathematics. C10 does not reprove their common-posterior calculations. |

The printed operations are binary. “Use PPS” for many weights and “split by VPS”
for a whole partition mean finite cascades with proved endpoints. Zero weights
are removed before constructing active columns; empty decoder fibers are not
parts. Theorem 1's printed direction reduces a singular matrix to all-ones using
PPM/PPS/VPM. Its reverse certificate starts at all-ones using PPS/VPS/PPM.
Remembered recoveries justify reversal; merges are not globally invertible.

**Example 6 output order.** In extended (29)-(30), merging the second and fourth
columns gives, under C07's lower-survivor convention, the order
`[A/3, 2*U/3, B/3]`, while (30) displays `[A/3, B/3, 2*U/3]`, where
`A=(1,1,0)`, `B=(0,0,1)`, `U=(1,1,1)`. Supply the explicit permutation swapping
the last two labels. Either compose through that output equivalence to follow
(31), or use the exact ordered path with the corresponding changed indices and
prove its comparison with every displayed state. Do not change the operation's
survivor rule or claim literal ordered equality. OM-071 records this repair.

One concrete exact-order certificate uses zero-based pairs `(1,2)`, `(1,3)`,
`(0,2)`, `(0,1)` at output sizes 5, 4, 3, 2, respectively. Its tags are
VPM/PPM/VPM/PPM. The third pair differs from the displayed `(0,1)` only because
the display has applied the stated transposition after the second operation.

Extended Example 6 is the reachability fixture. ISIT Examples 6-7 and extended
Examples 7-8 are partition/incidence fixtures owned by C13. Nearby Theorem 1's
canonical construction (extended (16)-(24), ISIT Appendix (20)-(28)) remains C11.
The interpretation changes here concern explicit finite realization and output
labels, not the intended mathematical claim. Reauthenticate and reassess affected
contracts if the lead designates a replacement manuscript.

## 3. Ownership, scope and imports

All project declarations remain under `PerfectFunctionalRepresentations`.

| Proposed module | Responsibility and intended focused imports |
| --- | --- |
| `Matrix/Reachability.lean` | Restricted reachability, witnessed reversal, local-result folds and easy direction. Imports `Matrix.OperationPaths` and `Matrix.Preservation`. No factorization implementation or partition import is needed for this core. |
| `Matrix/Partitions.lean` | Minimal exact-partition boundary, using `Mathlib.Order.Partition.Finpartition`; import `Matrix.SingularColumns` only if an actual pattern specialization requires it. |
| `Matrix/MultiwayOperations.lean` | Selected-column synthesis, exact labelled endpoints and finite family/fiber consumers. Imports `Matrix.OperationPaths`, `Matrix.Partitions` and only needed finite-sum/induction modules. This extra focused module keeps generic synthesis separate from semantic perfectness. |
| `Tests/Matrix/Reachability.lean`, `Tests/Matrix/Partitions.lean`, `Tests/Matrix/MultiwayOperations.lean` | External consumers of public contracts, with private fixture data and discriminating regressions. |
| `Examples/Reachability.lean` | Separately importable extended Example 6 fixture; helpers private unless an actual public consumer justifies promotion. |

Keep the mathematical root lightweight and unchanged. An integrated test module
may import C08 factorization to consume normalization; production reachability
and synthesis do not need it. Final module splits/names may change for concrete
proof organization, with documented import/ownership review and unchanged outcomes.

Out of scope: C11's canonical law, active `Y'` and decoder-fiber extraction,
hard direction and full perfectness iff; C12's global pattern compression,
distinct-pattern data and Real optimization bridge; C13 partition enumeration,
incidence systems and Bell counts; C14-C15 optimization/duality; extended-only
algorithms/applications; new probability theory, dependency upgrades, workflow
changes, commits and pushes. Interfaces for later consumers do not implement
their mathematics.

## 4. Existing API versus proposed work

Names in this table exist in current source. Focused compiling consumers and
their results/limits are recorded in the planning notes. Names introduced in
Section 5 describe approved targets, not declarations already implemented.

| Existing public API | Intended reuse |
| --- | --- |
| `ActiveFiniteChannel.allOnes`, `allOnes_apply`, `allOnes_isSingular`, `allOnes_isPerfectlyRepresentable` | One active output, rectangular entries one and prior-free perfect seed. |
| `pps_isPerfectlyRepresentable`, `vps_isPerfectlyRepresentable`, `ppm_isPerfectlyRepresentable`; `pps_not_isPerfectlyRepresentable`, `ppm_not_isPerfectlyRepresentable`, `vpm_not_isPerfectlyRepresentable` in `MatrixOperations` | Exactly the two three-operation restrictions. No forward perfectness theorem for arbitrary VPM or forward nonperfectness for arbitrary VPS is supplied or asserted. |
| `isPerfectlyRepresentableChannel_map_iff` | Perfectness transport through the explicit output equivalence; C09's corresponding `OutputEquiv` consumer is private and is not a production API. |
| `OperationStep`, `OperationPath.nil/snoc/append`, `Allowed`, `Homogeneous`, `Normalizing`, `allowed_snoc/append`, `transport`, `transport_allowed`, `transport_homogeneous` | Actual witnesses, chronological restrictions and finite construction/transport. `Normalizing` already means PPS/VPS/PPM. |
| `OutputEquiv.equiv/map_eq/apply/apply_symm`, `symm/trans`, `ofCoordinates`; `Cascade.refl/ofPath/ofOutputEquiv/comp`, `allowed_comp` | Directed endpoint data and composition. `Cascade.outputEquiv` maps its concrete endpoint to its nominal target. |
| `ppsRecovery`, `ppmRecovery`, `vpsRecovery`, `vpmRecovery` and their `*_channel` equations; `ppmRecoveryEquiv`, `vpmRecoveryEquiv` | Reverse each witnessed edge with the actual remembered ratio/mask and recovered-to-original output correspondence. |
| C07 `pps_left/right/keep`, `vps_left/right/keep`, `ppm_apply_survivor/unaffected`, column value/pattern equations, positivity and singularity closure | Exact synthesis coordinates and invariants. Verify exact signatures at implementation, not by name resemblance. |
| mathlib `Finpartition`, `nonempty_of_mem_parts`, `disjoint`, `existsUnique_mem`, `parts_nonempty`, `ofExistsUnique`, `equivSigmaParts`, `indiscrete` | Reuse nonempty/disjoint/exact-cover semantics, labelled block conversion and singleton partition. |
| `Finite.induction_empty_option`, `Fintype.induction_empty_option`; `Finset.single_le_sum`; `ENNReal.toNNReal_sum`, `coe_toNNReal`, `toNNReal_pos_iff`, `toNNReal_one`, `ofNNReal_finsetSum` | Finite realization and exact weight conversion. The compiled adapter derives each summand's finiteness from sum one; no new generic information-theory result is needed. |

C08's `srPpsTree`, `srVpsTree`, `sfSplitFamily`, `sfGatherFamily` and
`sgGatherTree` are private. They realize trees/callbacks already recorded in a
normalization proof. They do not expose arbitrary weight, partition or fiber
synthesis. The chosen route is direct finite induction over public C07 operations
and C08 transport, keeping bookkeeping private. This avoids importing the full
normalization implementation merely to reuse its traversal. No promotion is
selected. If an approved step develops concrete pressure for a small wrapper,
identify the exact helper, consumer, signature and import cost before changing it;
review that bounded change and rebuild all affected C08 consumers. This cannot
weaken a synthesis outcome or silently enlarge the public API.

## 5. Precise mathematical and representation contracts

### 5.1 Reachability, reversal and the easy direction

Let `S T : ActiveFiniteChannel alpha` with `[Finite alpha] [Nonempty alpha]`.
Use the existing `IsPerfectlyRepresentableChannel`, with no input prior or
full-support premise. Define paper-facing Prop predicates with retained witness
types, schematically:

```text
FromAllOnes S := exists c : Cascade (allOnes alpha) S, c.path.Normalizing
ToAllOnes S := exists c : Cascade S (allOnes alpha),
  c.path.Allowed (fun k => k = ppm or k = pps or k = vpm)
```

Reuse `Allowed` for the second restriction; a small named predicate is justified
by repeated use, not a new path type. Prove both predicates respect directed output
equivalence and include the zero-length seed. Produce a witnessed reversed cascade
for every supplied cascade, with chronological tags equal to the reversed original
list after swapping PPS/PPM and VPS/VPM, hence equal operation count. Recoveries
must retain supplied witnesses; reversing twice need not give the same proof data.

For a path ending with `e`, reverse `e` before the earlier path. For a cascade
whose endpoint comparison is `E -> T`, first use its inverse `T -> E`, then reverse
the concrete path. C08 composition handles intermediate relabelings. Prove the
restriction transfer and `FromAllOnes S <-> ToAllOnes S` without invoking C11.

Lift C09's three positive implications along normalizing paths/cascades, and its
three negative implications along PPM/PPS/VPM paths/cascades. Derive reflection of
perfectness along the latter and the two easy implications to perfectness. The
paper-facing singular specialization follows immediately. Generic singularity
propagation retains its source premise for an empty path; perfectness folds do
not acquire an unnecessary singularity or full-support assumption. Prove
singularity of reachable states from the seed where needed.

### 5.2 DG-11 resolution: exact finite partitions

Use mathlib `Finpartition s` for `s : Finset alpha`, with at most a thin
project-local abbreviation/adapter. Its blocks are finite, nonempty, pairwise
disjoint and cover exactly `s`; every `x in s` belongs to exactly one block.
Use a local classical decidability instance so `DecidableEq alpha` is not a
mathematical public assumption. A `Fintype` parameter is appropriate when a
statement exposes enumeration or finite sums; otherwise use `Finite`.

The minimal public consumer interface must provide:

- direct access to blocks, nonemptiness, disjointness and exact membership/coverage;
- a finite block-label type and the unique-block membership fact;
- a checked adapter from a finite labelled family of nonempty pairwise disjoint
  finsets `blocks : I -> Finset alpha` covering `s`, returning a partition
  `P : Finpartition s`, a bijection `e : I ≃ P.parts`, and the exact equation
  `(e i).1 = blocks i` for every supplied label `i`;
- the singleton partition and the nonempty block family when `s` is nonempty.

Reuse existing mathlib facts directly where possible instead of making aliases
for every lemma. Nonempty disjoint blocks make the labelled family injective.
The supplied-label bijection composes with the VPS output labels. Mathlib's
`Finpartition.equivSigmaParts` instead relates elements of `s` to elements within
its blocks; both interfaces retain their respective roles.
The underlying interface may also handle the empty finset; selected active patterns
are explicitly nonempty, so no empty block family can become an active split.
C11 constructs its own nonempty decoder fibers and supplies this adapter's
hypotheses. C13 owns enumeration of partitions and ordered presentations.

Comparison: an indexed `Finset` family with separate proofs is useful input data
but duplicates the validated partition invariant if used as the primary record.
`Setoid`/equivalence classes describe partitions of a carrier but require further
finite/support and nonempty-block bridges. `Finpartition` already provides the
needed invariant and sigma-of-parts equivalence, so it is the selected design.
The lead's endorsement of revision 2 resolves DG-11 on 2026-09-28; S02 implements
this approved interface.

### 5.3 Multiway PPS

Given singular active `S`, selected `l`, finite labels `I` and `w : I -> NNReal`
with each weight positive and `sum w = 1`, construct an actual PPS-only path
`S -> T`. Supply a bijection
`I + {j : Fin S.outputCard // j != l} -> Fin T.outputCard` and prove, at every row:

- the column labelled `i` is `(w i : ENNReal) * S.channel x l`;
- the column labelled an unaffected `j` is exactly `S.channel x j`;
- every target column has one of these labels; cardinality is
  `S.outputCard - 1 + Fintype.card I`, and the state is active and singular.

The output patterns of children equal the selected pattern and their admitted
values are the corresponding weighted values. Sum one implies a nonempty label
family. A singleton has weight one and uses a zero-length path plus explicit
labels. In a genuine split, the chosen first weight and the positive residual
give a strict ratio; normalize the remaining positive weights by that residual.
Do not apply a primitive split at ratio zero or one. Finite induction, with exact
coordinate labels throughout, is the intended construction.

For private induction, carry a source-label equivalence `Unit + R` and a
target-label equivalence `I + R`, with every `R` coordinate unchanged. Induction
through `Option I` isolates one weight; the nonempty residual receives the
normalized remaining weights. The finite family corollary threads this invariant
through all source labels, rather than assuming insertion leaves numeric indices
fixed. VPS may use the same invariant with indexed blocks and their exact-cover
hypotheses internally; the public boundary remains `Finpartition`.

For merely nonnegative weights (represented by `NNReal`), restrict to
`{i // 0 < w i}` before construction. Prove this subtype is nonempty, retains
total weight one, and has exactly the intended surviving coordinates. When
comparing to the ambient family, inclusion has zero mass off its image. Supply
an exact ENNReal normalized-family adapter using derived finiteness and existing
`toNNReal`/coercion laws, so later PMF consumers do not rebuild the bridge.
No ambient zero column enters an `ActiveFiniteChannel`. Real optimization data
and its broader conversion contract remain C12.

Expose a finite family corollary: for each source output `j`, choose finite
labels `I j` and normalized weights. The endpoint labels are `Sigma j, I j`
(positive subtypes for zero-containing input), with coordinate
`(w j i : ENNReal) * S.channel x j`. A finite traversal of selected-column
constructors must prove all labels survive subsequent insertions. This is generic
synthesis only, not C11's choice of canonical weights.

### 5.4 Multiway VPS

Given singular active `S`, selected `l`, its nonempty pattern `s`, and an exact
partition `P : Finpartition s`, construct a VPS-only path `S -> T` and a bijection
`P.parts + {j // j != l} -> Fin T.outputCard`. Each block-labelled coordinate is
`if x in block then S.channel x l else 0`; unaffected coordinates are exact.
Child patterns are the supplied blocks, and all child admitted values equal the
selected value, including value one. Cardinality is
`S.outputCard - 1 + P.parts.card`; activity and singularity are retained.

Induct on the nonempty block family. For more than one block, split off one
nonempty block and the nonempty union of the remaining blocks, both inside the
selected support. Use the characteristic mask only on that support; its values
outside support are irrelevant. Recurse on the residual exact partition.
One block requires no operation. No zero child, empty piece, artificial weight
perturbation or strict upper-bound assumption is allowed.

Expose the analogous finite family corollary, with endpoint labels
`Sigma j, (P j).parts` and exact coordinates for every source output's partition.
It accepts already supplied partitions and does not construct decoder fibers.

### 5.5 Finite equal-pattern PPM fibers

Given singular active `S` and a nonempty finite selected family `F` of source
columns with the same support, construct a PPM-only path to an active singular
endpoint labelled by `Unit + {j // j notin F}`. The new column is exactly
`sum j in F, S.channel x j`; unaffected coordinates remain exact, its pattern
is the common pattern and its admitted value is the sum of the admitted values.
Cardinality is `S.outputCard - F.card + 1`. Singleton fibers use no merge.
For an empty selected family, the no-op branch retains `S` and creates no column;
it must not claim a merged empty column has an admitted value or pattern.

For the reusable finite-fiber interface, accept a surjection
`g : Fin S.outputCard -> B` with a finite label type and equality of supports
inside each fiber. Construct a PPM-only path with endpoint labels
`B -> Fin T.outputCard` and exact coordinate
`sum j, if g j = b then S.channel x j else 0`. Every fiber is nonempty by
surjectivity. An arbitrary non-surjective map may instead target its finite
range, with unused ambient labels explicitly absent/zero under inclusion.
No assumption requires different fibers to have different patterns. This is
the prescribed-fiber constructor; forming all equal-pattern equivalence classes,
global compression and optimization data remain C12.

### 5.6 Common endpoint and transport duties

Synthesis results retain the actual Type-valued witnessed path (or a package
containing it), the homogeneous tag proof, a total output-label bijection and
all coordinate equations. A bare existential up to unspecified permutation is
insufficient. Use one minimal package only if repeated consumers justify it.
Expose usable result data or a noncomputable chosen witness with accessors and
proved specifications; do not leave later consumers only a Prop existence claim
with no documented witness interface. The reachability predicates themselves
remain Prop-valued.

The cited `Finite.induction_empty_option` and `Fintype.induction_empty_option`
have Prop-valued motives. When using them for synthesis, prove `Nonempty` of the
combined path, labels and specification data, then expose a noncomputable chosen
witness and its accessors. Keep the specifications attached to that same witness.
An alternative proof route may produce the data directly; the required usable
interface is unchanged, and no additional public record is mandated.

For any supplied target with the same labelled coordinates, derive the directed
`OutputEquiv`/cascade through existing coordinate extensionality. Different finite
enumerations therefore compare explicitly. Output relabeling uses C08's witnessed
transport at a fixed input type. For R09 input reindexing, instantiate synthesis
on a source with its rows relabelled through the C06 channel/active-state boundary,
and compare its endpoint with the independently specified target coordinates
relabelled by C06. Use a nontrivial input equivalence on a fixture with
distinguishable rows. A general input-reindexing theorem for arbitrary witnessed
paths is not required by this synthesis consumer.
Keep every equivalence's direction explicit, including non-involutive output
permutations. No uniqueness, shortest path, canonical ordering or runtime bound
is claimed.

Within each of S03-S05, exercise the first compiling generic family constructor
through a small external consumer of its witness accessors and comparison with
an independently supplied target. Use the existing R09/R12/R15 cases and the
applicable R18 interfaces, including different child counts for split families.
Do this before expanding the larger concrete fixtures. S06 then integrates these
established interfaces across the three operation families.

## 6. Approved steps and independent acceptance criteria

Each step includes the common validation/review duties in Section 8, its listed
regressions, a public API/import audit and updates to the owning implementation
notes, map/status and log. These common obligations are normative for every step.
No step begins automatically. The order below is sequential for execution;
mathematical dependencies are given separately.

### PFR-C10-S01 - Restricted reachability, reversal and easy direction

**Prerequisites:** C07-C09. **Owns:** `Matrix.Reachability` and its tests.
**Anchors:** III-B Theorem 1 opening and Lemmas 5-6 inverse/repeated-use prose.
**Objective:** all of Section 5.1 using public APIs in Section 4. New declarations
are the predicates, witnessed reversal/tag laws, output transport and folds;
C09 seed/local implications and C08 composition remain reused.
**Edges/regressions:** R01-R04. **Documents:** exact contracts, endpoint orientation,
prior-free proof and OM-051 coverage; no C11 completion claim.

- **C10-S01-A:** The two reachability predicates retain explicit endpoints and
  exactly the specified operation restrictions. Witnessed reversal has the
  correct reversed/swapped chronological tags and directed endpoint transport.
- **C10-S01-B:** Both local-result families lift to their restricted paths and
  cascades, giving both easy implications and equivalence of the two reachability
  directions without the hard perfectness implication or hidden assumptions.
- **C10-S01-C:** R01-R04 and focused/downstream/default validation pass; all new
  public signatures, axioms and imports are audited, and documentation distinguishes
  remembered recovery from global inversion and preserves the nil case.

### PFR-C10-S02 - Minimal exact-partition interface

**Prerequisites:** C06; DG-11 is resolved by approval of revision 2.
**Owns:** `Matrix.Partitions` and tests. **Anchors:** IV-A sets of nonzero
patterns summing to all-ones, multiway VPS prose; C11 (23)-(24) only as a future
consumer requirement. **Objective:** Section 5.2; reuse mathlib's invariant.
**Edges/regressions:** R05-R06. **Documents:** dated DG-11 decision after approval,
public/underlying mathlib boundary and C13 ownership, OM-017/052/068.

- **C10-S02-A:** The selected interface enforces nonempty blocks, pairwise
  disjointness, exact coverage and unique membership, reusing pinned `Finpartition`.
- **C10-S02-B:** A finite labelled exact family converts with an explicit
  label-to-block bijection and the equation identifying every supplied block;
  singleton, nonempty-carrier and empty-carrier behavior are explicit. No incidental
  decidability assumption or decoder-fiber construction leaks into the API.
- **C10-S02-C:** R05-R06, public external consumers and focused/default checks
  pass; source/API/import and downstream C11/C13 adequacy are documented without
  partition enumeration, incidence or Bell-count implementation.

### PFR-C10-S03 - Finite PPS weight synthesis

**Prerequisites:** C07/C08; S01 for reachability consumers. S02 is not a
mathematical prerequisite. **Owns:** PPS portion of `Matrix.MultiwayOperations`
and tests. **Anchors:** ISIT IV-A numbered instruction 1; extended p. 4 after
(24) and p. 6 instruction 1. **Objective:** Section 5.3 and applicable 5.6.
**Edges/regressions:** R07-R09. **Documents:** exact numeric bridge, positive
support, singleton contract, finite traversal and OM-045/052 handling.

- **C10-S03-A:** Actual binary PPS paths realize arbitrary finite positive
  normalized weights on a selected column and finite per-column families, with
  strict primitive ratios, all child/unaffected coordinates and complete labels.
- **C10-S03-B:** Nonnegative families restrict to positive support with exact
  total and inclusion/off-image laws; the ENNReal input adapter preserves masses.
  Empty normalized families are impossible and singleton cases introduce no split.
- **C10-S03-C:** R07-R09 and integrated S01 consumers pass; endpoint cardinality,
  activity, singularity, admitted values/patterns, transport, trust/import checks
  and owning documentation are complete with no zero active column.

### PFR-C10-S04 - Finite VPS partition synthesis

**Prerequisites:** S02, C07/C08; use S03's private labelled traversal only if
its actual signature fits. **Owns:** VPS portion of `Matrix.MultiwayOperations`
and tests. **Anchors:** same source groups, numbered instruction 2.
**Objective:** Section 5.4 and applicable 5.6. **Edges/regressions:** R10-R12.
**Documents:** partition-to-mask induction, retained value-one domain, exact
pattern/coordinate correspondence, OM-038/049/052.

- **C10-S04-A:** A selected nonempty pattern and every supplied exact finite
  partition yield a binary VPS path with precisely those blocks, unchanged values,
  complete endpoint labels and exact unaffected coordinates.
- **C10-S04-B:** Finite per-column partition families compose with exact sigma
  labels; each primitive split has two nonempty pieces inside the current support.
  Singleton partitions, null rows, mask irrelevance and value one remain covered.
- **C10-S04-C:** R10-R12 and integrated reachability/transport consumers pass;
  cardinality, activity, singularity, public API/axiom/import and documentation
  audits confirm no zero column or unselected strict-VPS alternative.

### PFR-C10-S05 - Finite equal-pattern PPM synthesis

**Prerequisites:** C07/C08 and synthesis endpoint conventions; S01 consumers.
**Owns:** PPM portion of `Matrix.MultiwayOperations` and tests.
**Anchors:** IV opening equal-pattern merging and IV-A instruction 3.
**Objective:** Section 5.5 and applicable 5.6. **Edges/regressions:** R13-R15.
**Documents:** prescribed versus globally chosen fibers, exact sums and C12
handoff, empty-fiber convention, OM-045/052.

- **C10-S05-A:** Finite nonempty equal-pattern families and prescribed surjective
  fibers have witnessed PPM paths with exact aggregate masses/admitted values,
  retained patterns, all unaffected coordinates and complete endpoint labels.
- **C10-S05-B:** Empty/no-op, singleton and all-columns cases, range restriction
  for unused labels, nonadjacent/final columns and output transport are explicit;
  no distinct pattern assumption across fibers or global compression result
  is introduced.
- **C10-S05-C:** R13-R15, downstream consumers and focused/default validation
  pass; activity/cardinality/singularity, public signatures/axioms/imports and
  documentation establish the promised C12 constructor boundary.

### PFR-C10-S06 - Example 6 and integrated readiness

**Prerequisites:** S01-S05. **Owns:** `Examples.Reachability`, integrated tests
and `docs/pfr-c10-readiness-audit.md`. **Anchors:** extended Example 6 (25)-(32)
and the three Section IV operation instructions. **Objective:** validate the
complete reduction, Section 5.6 handoffs and every earlier criterion together.
**Edges/regressions:** R16-R18 plus R01-R15. **Documents:** cumulative API,
source-anchor/omission, regression and criterion crosswalk; exact OM-071 bridge.

- **C10-S06-A:** The private Example 6 fixture checks every displayed coordinate,
  operation legality and endpoint, including (30)'s explicit output permutation,
  and derives prior-free perfectness using the easy direction alone.
- **C10-S06-B:** Public-interface consumers combine weighted PPS, exact VPS
  partitions and prescribed PPM fibers with explicit endpoint transport and the
  existing normal form. C11/C12/C13 boundary adequacy is demonstrated without
  implementing their canonical, compression, incidence or optimization results.
- **C10-S06-C:** R01-R18, all fifteen earlier criteria and CC01-CC07 have a
  complete source/API/manuscript/trust crosswalk with fresh relevant checks.
  Documents and original review/advice dispositions are ready for S07; this is
  readiness, not the later fresh independent cumulative closeout.

### PFR-C10-S07 - Fresh cumulative independent validation and closeout

**Prerequisites:** S01-S06 durably complete with their original independent
reports reconciled. **Owns:** cumulative validation/readiness and final owning
documents; no new theorem family. **Anchors:** all C10 anchors and contracts.
**Objective:** freshly reassess all eighteen earlier criteria, R01-R18 and
CC01-CC08 against actual current source, manuscripts, imports and pinned APIs.

- **C10-S07-A:** Fresh cumulative mathematical/source/API/build/trust assessment
  covers all eighteen previous criteria, R01-R18 and CC01-CC07, including exact
  endpoints, numerical/support cases, every source repair and downstream boundary.
- **C10-S07-B:** The bound reviewer independently reassesses that complete
  cumulative scope and CC08 review-time readiness with attributed checks and
  limits. Earlier original reports/advice remain preserved and reconciled; any
  criterion gap receives a new satisfactory independent assessment.
- **C10-S07-C:** At review time the readiness crosswalk and subsequent duties
  are complete. After receiving the report, the parent retains and critically
  reconciles it, resolves required findings/review, prepares owning documents,
  runs final applicable validation, captures F and obtains supported durable
  closure. Only that later record completes CC08 and closes C10. Stop afterward.

Bounded in-contract fixes may occur during closeout with documented impact and
appropriate renewed checks/review. A materially different theorem, scope or
acceptance contract needs lead adjudication; it cannot be parked as optional work.

## 7. Regression obligations

Exact fixture choices may improve with evidence; the discriminating obligations
below must survive. Use anonymous/private fixtures instead of unnecessary public
example APIs. Do not let a test prove its expectation by merely restating the
same implementation expression; check explicit coordinates or independent data.

| ID | Required behavior |
| --- | --- |
| R01 | Nil all-ones reachability in both directions, a relabel-only cascade, singleton input/output, and explicit nil singularity premise for generic propagation. |
| R02 | All four remembered one-edge reversals, including unequal PP weights, nonadjacent/final merge labels, VP value one and an unaffected column. |
| R03 | Mixed multi-edge cascade reversal, changing cardinalities, exact reversed/swapped tag word, directed endpoint comparison and a non-involutive permutation that distinguishes `e` from `e.symm`. |
| R04 | Both restricted folds, easy implications and direction equivalence; a concrete nonperfect C03 channel consumes the negative fold, and forbidden kinds are excluded rather than assigned false preservation properties. |
| R05 | Singleton partition, three unequal-sized disjoint parts, exact coverage/unique membership and failure of overlapping, missing-element or empty-part candidate data. |
| R06 | Labelled family adapter with nontrivial label order, an explicit `I ≃ P.parts` and the supplied-block equation at each label, nonempty block index, empty ambient finset boundary and a public consumer with no `DecidableEq` assumption. |
| R07 | Selected PPS weights `1/6, 1/3, 1/2`, all exact child entries, nonuniform positive residuals, null rows and an unaffected source column. |
| R08 | Singleton weight one, nonnegative family with interspersed zeros, positive subtype/inclusion and ENNReal coercion round trip; reject all-zero/empty total-one input. |
| R09 | Finite PPS family with different child cardinalities, every sigma label, total target cardinality, output transport and alternative enumeration comparison. Instantiate synthesis on a nontrivially row-relabelled source with distinguishable rows and compare with the independently relabelled target coordinates, as specified in Section 5.6. |
| R10 | Selected VPS with three nonempty parts of different sizes and a selected support smaller than the input alphabet; all block and unaffected entries. |
| R11 | Singleton partition/no operation, value-one selected column, null selected rows, two masks differing only outside support and rejection of an empty selected-support piece. |
| R12 | Finite per-column partition family with mixed block counts, sigma labels, changed cardinality and non-involutive output transport. |
| R13 | Three nonadjacent equal-pattern columns of unequal values, including final source label, exact aggregate value/masses and unchanged complementary columns. |
| R14 | Singleton and empty/no-op selected fibers, non-surjective ambient labels via range restriction, and no invented active empty fiber. Also select all columns (`F = Finset.univ`) in the generic S05 constructor on a constant-row channel with three masses `1/6, 1/3, 1/2`: check the empty complementary label type, output cardinality one and explicit comparison to `allOnes`. Reuse this fixture for the prescribed single-fiber interface. |
| R15 | Several prescribed fibers, including two with the same pattern, all exact sums, target cardinality and directed output relabeling. |
| R16 | Extended Example 6 all entries (25)-(32), VPM/PPM/VPM/PPM tags, equation (30)'s transposition, actual reverse certificate and easy perfectness. |
| R17 | Integrated finite weighted partition construction and prescribed grouping consumer with exact composed endpoints; C08 normalization is consumed through public API only. |
| R18 | Public import boundary and later-consumer shape checks: ENNReal weights, supplied labelled nonempty partition families, prescribed fibers and explicit comparison to a target. Check witness accessors and the applicable family/target interface early within S03-S05, then integrate at S06; no private namespace access or later-chunk theorem assumed. |

## 8. Validation and review duties

For each coherent Lean edit, build the touched module and important downstream
consumers. At step milestones run default `lake build` as well. The root excludes
heavy matrix modules, so default success cannot replace the focused matrix/test
build. Discover actual maintained modules before composing commands. Include
C07 Operations tests, C08 OperationPaths/OperationCalculus tests and C09
Preservation tests when their interfaces or integrated consumers are affected.

Audit every new/changed public signature for intended quantifiers, restrictions,
finiteness, nonempty assumptions, exact endpoint orientation, prior-free perfectness
and numerical domain. Inspect imported/generated named constants in touched
production modules as appropriate and `#print axioms`; only the accepted Lean
foundational axioms are permitted. Prohibit all placeholders; require the standard
AGENTS.md scan to return no matches. Inspect the final task-relative diff,
Git status, generated/tracked/ignored artifacts, closed plans and immutable pins.
Do not attribute inherited changes to this chunk.

For an eligible explicit “with review” or plan-review request, use the installed
[protocol](../review-protocol.md) and [operations](../review-operations.md).
The C10 binding belongs to this originating task; never replace another chunk's
reviewer. Keep requested settings separate from observed settings. Preserve B,
neutral source-bound R and final F, original reports, findings, separate contextual
self-review and reassessment, evidence attribution and negative attempts.
One request authorizes one step. Plan review uses its own explicitly authorized
session; reviewer setup does not dispatch it. Respect the installed bounded waits
and lossless/report-backed delivery rules. A criterion gap is not overridden by
parent success or lack of findings.

S07 requires a fresh independent cumulative pass. The reviewer assesses current
mathematics and readiness, not future parent receipt/reconciliation, final checks,
F capture or closure. The parent completes those afterward. Update owning
documents before final checks/F, leaving pending closure explicit; preserve the
later durable record instead of rewriting the frozen checkpoint after closure.

## 9. Completion criteria

| ID | Required completed outcome |
| --- | --- |
| CC01 | Both restricted reachability predicates, directed transport, witnessed reversal/tag laws and their equivalence. |
| CC02 | C09 local positive/negative folds and both prior-free easy implications; no hard perfectness direction. |
| CC03 | Approved DG-11 minimal exact-partition interface with labelled adapter and support/decidability boundaries. |
| CC04 | Positive/nonnegative finite PPS synthesis, exact ENNReal adapter and selected/family endpoints. |
| CC05 | Exact finite VPS partition synthesis, selected/family endpoints, nonempty pieces and value one. |
| CC06 | Prescribed finite equal-pattern PPM fibers with exact aggregate/unaffected coordinates and empty-fiber handling. |
| CC07 | Extended Example 6, all regressions, public consumer/import/trust/source-omission crosswalk and owning documentation. |
| CC08 | Fresh independent cumulative assessment, original-report reconciliation, required corrections/review, final applicable validation/F and supported durable closure. Readiness is assessed before the report; completion only after the later closure. |

## 10. Omissions, deferrals and downstream triggers

The formalization map owns the omission register. These are the dispositions
within reviewed C10 anchors; historical records are retained.

| Source/obligation | C10 handling; owner and revisit trigger |
| --- | --- |
| OM-014/044/068 finite labels and patterns | Reuse active finite states and support finsets; endpoint label bijections prove the representation boundary. C10 S02-S06 own current consumers. |
| OM-024/070 ordered merge indices | Retain C07's full index range/lower survivor. C10 S01/S05/S06 check exact indices; the historical duplicate OM-070 remains. |
| OM-027/042 Example 6 and numbered intermediates | S06 checks logical content/coordinates with private fixtures; no public name per display. C13 retains the later partition/incidence examples. Revisit fixture promotion only for an actual consumer requiring a name. |
| OM-038/045/052 zero weights, empty pieces/fibers and multiway shorthand | S03 positive support, S04 exact nonempty partitions, S05 range/no-op cases. C11 still constructs actual canonical active `Y'` fibers. Its planning/implementation is the trigger for consuming these interfaces. No raw create-zero-then-prune API is selected. |
| OM-049 inclusive VPS; OM-050 example-specific beta | Keep the approved value-one domain; no revival of the unselected strict-VPS simulation. C07 fixture beta hypotheses do not constrain the new constructors. |
| OM-051 inverse and cascade equivalence prose | S01 implements witnessed reversal with explicit output transport. No global inverse, unique mask or proof-data involution is promised. |
| OM-052 C08 private-helper promotion | Reassessed now: direct public-API induction is selected. Revisit only when S03-S05 reveals a concrete duplicated traversal and justified public consumer; name and review any bounded wrapper/extraction then. |
| OM-071 extended Example 6 (30) order | Explicit transposition under the unchanged lower-survivor rule; S06 owns exact coordinates and comparison to (31). |
| ISIT IV opening global compression | C10 supplies prescribed PPM fibers and inverse reachability transport only. C12 owns grouping by all equal patterns, global distinctness and Real compressed data; revisit when C12 consumes S03/S05. |
| Theorem 1 “only if”, (16)-(24), ISIT Appendix and Figure 1 | C11 owns canonical law, support restriction, actual decoder fibers, both bridge paths and hard direction (OM-020/021/042/045/048). C10's generic adapters do not claim that proof. |
| IV-A incidence, normalization derived from feasibility, Bell partitions | C13 owns full/reduced systems, nonnegative feasibility and enumeration (OM-017/025/047); C14 owns primal characterization. C10 assumes supplied normalized weights and exact partitions, not LP feasibility. |
| Remark 2; complexity, bibliography, nearby explanatory prose | OM-010/011/012 cover external information-measure equivalences; OM-016/017/019 cover complexity/count claims; OM-022/023/037 cover restatement, citations and adjectives. No new formal targets. |
| Rewrite strategy, canonical normal form, shortest cascade and algorithms | OM-043 and the roadmap retain these unselected goals. Revisit only for a separately approved algorithmic consumer. |

The authoritative Future Work Notes register contains no numbered notes at
planning startup. All identified worthwhile deferrals above have mapped owners
and triggers, so no duplicate note is opened. Any later advice without such an
owner must receive a stable numbered note and living-summary classification.
Required correctness/acceptance gaps cannot be deferred as optional suggestions.

## 11. Documentation, revision policy and stopping boundary

Implementation notes own exact checks and decisions; the readiness audit maps
every source anchor, declaration, regression, criterion and omission at S06/S07.
The living summary owns current status and active-plan pointer; the map owns
DG-11, dependencies and omission dispositions; the project log retains dated
history/advice; README and roadmap need only concise honest coverage updates.
Update the scope document only if its current status/boundaries materially change.
Record genuine library discovery friction only, not every successful search.

During an authorized step, improve proof routes and organization with evidence,
preserve the reviewed original contract, document the reason and review the actual
result. Exact names and private bookkeeping may change; mathematical assumptions,
required interfaces, manuscript meaning, scope and acceptance must not silently
change. Substantive changes need the lead. The marked editorial status block
above is reserved for status and chronological notes under the installed
procedure; all requirements remain outside it. Plan approval registers no
execution session.

For a later explicit plan review, assess PR01 source/prerequisite fidelity,
PR02 reachability/reversal/easy direction, PR03 partition and synthesis contracts,
PR04 edge cases/imports/verified reuse, PR05 coverage/deferrals/downstream boundaries,
and PR06 executable step/validation/closeout/authority completeness. The exact
criteria and normative excerpts must be captured in that separately authorized
plan-review session. Earlier revision-1 assessments remain attributed history;
no independent revision-2 review is claimed.

Await the lead's explicit S01 request. Plan approval does not start a mathematical
step, register an execution session or authorize independent plan-review dispatch.
Each later step still needs its own request.
