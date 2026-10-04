# PFR-C13 — Exact Partitions and Full/Reduced Incidence Systems

<!-- pfr-review-status:start -->
**Status:** Active — revision 2; S06 cumulative review reconciled; pre-F checkpoint, 2026-09-30.
S06 cumulative validation and independent review pass; all three criteria are satisfied, and the original report is reconciled. Final applicability, F and durable closure follow this pre-F checkpoint.
**Authority:** The conditional S06 request was accepted after verifying all
S01-S05 durable closures, fifteen satisfied criteria, original-report
reconciliation and exact agreement of all 153 S05 final entries.
S05 closure: `bc86357cb2f045db4c57c3ed0dd36863e06b082a3bf47d72301bb66787e338bf`.
Only S06 is authorized. C14/C15 remain unstarted. No independent plan review is claimed.
**Prerequisites:** C01-C12 and C13-S01 through S05 complete. Earlier checkpoints
and original reports remain preserved; the mathematical contract below is unchanged.
**Reviewer:** `/root/pfr_c13_reviewer`, bound to originating task
`01a0f1b4-e5ca-7742-b5d3-ed5e37838d41`; requested Astra/ultra/no-parent-history,
effective settings unknown. The same reviewer freshly reassessed the complete contract and satisfies all three S06 criteria. Its original report is critically reconciled; supported final closure remains required.
The [readiness audit](../pfr-c13-readiness-audit.md) maps coverage;
[implementation notes](../pfr-c13-implementation-notes.md) own exact evidence and limits.
Only supported final closure completes CC09/C13.
<!-- pfr-review-status:end -->

Revision 2 keeps all six steps and eighteen criterion IDs. It corrects the
supported-decoder and R08 acceptance statements, adds shared-block tests and
infeasibility with nonempty admissible families, and makes the public construction consumer
explicit. [Advice dispositions](../pfr-c13-planning-notes.md#revision-2-advice-dispositions)
record the selected subset and preserved revision-1 baseline.

## 1. Baseline and authorization

HEAD is `54c1714d1a9a891939d6c9f7d38c0d05896b2c75`; substantial completed
work remains dirty or untracked. Preserve it. C12 S05 closure is
`1451fe774e1e68737a7e152022d1c7203ffd3d48f46292aa9e750c5cebf4fa0e`, with
final source F `aacc8e9d3d25a3eafb818f3ad3dfffbf2e91b31686c873dcae2508e69ba43744`.
All five closing steps satisfy their fifteen criteria. The first cumulative
report's two temporal `NOT_ESTABLISHED` assessments remain historical; the
linked independent assessment and subsequent finalization completed the duties.
The original C12 plan/notes retain their pre-F checkpoint wording.

LeanInfoTheory remains immutable `v0.1.0`, commit
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`; Lean is `v4.33.1`, and mathlib
is pinned at `0df444a360eaa60ab8c11dca51a86af692955474`. Installed pins are
clean and match the manifest. [Planning notes](../pfr-c13-planning-notes.md)
own exact setup, discovery, probe and validation evidence with limitations.

The lead endorsed this exact revision on 2026-09-30. A later eligible request
authorizes one approved step and its review, then stops. C14 primal
optimization and C15 duality/separation/attainment are outside C13. No dependency
or review-tool changes, execution registration, independent review dispatch,
commit or push are authorized by the planning, draft-revision or readiness requests.

## 2. Manuscript anchors and interpretation

Manuscript binaries, page images and extracts remain external or ignored.

| Source | Version identity | C13 anchors |
| --- | --- | --- |
| Six-page ISIT final, filename ending `final_manuscript_ (3).pdf` | SHA-256 `48963aa59485b2c33b1a1e6e7c6ead2251fdddd26bd3691b6fcffe683e6ed1c4` | PDF p.4: IV opening's distinct-pattern bound; IV-A partition definition and Example 6; (16), three construction stages, Example 7/(17), and the following feasibility/weight-bound paragraph. |
| Eighteen-page extended version 16, designated 2026-09-03 | SHA-256 `98636d4c9f0618ec08fca84559572780f604f197fda90d8d7c787b3624245b8f` | IV-A, p.5 (33)-(39), p.6 (40)-(61), p.7 (62)-(63): full universe, occurring family, admissible partitions, zero extension/restriction, normalization and construction; Examples 7-8. |
| Same extended companion, boundary reading | Same binary | p.7 (64)-(65) belong to C14/C15; (66)-(68) use C13's finite dimensions but leave the dual claim to C15 and general Bell enumeration to OM-017. |

The printed ISIT `m × R` system retains every exact partition while only
listing occurring-pattern rows. That mixed encoding can give positive weight
to an absent block. It does not characterize perfectness or justify the stated
weight bounds. The intended repair, clarified by extended (39)-(56), is two
separate systems: all nonzero patterns/all partitions, or occurring
patterns/admissible partitions. Their **nonnegative equality feasibility** must
be theorem-backed equivalent. Approval resolves DG-12's design choice;
the equivalence proofs remain C13 implementation obligations.

The paper's binary vectors become C06 support finsets, and its sets of vectors
become mathlib `Finpartition`. Addition is over the reals, with exactly one
block containing each input. Positive occurring-pattern values need not sum
to one; stochastic normalization is separately per input. Coefficients may be
zero and must be removed before active split operations. Nonempty input is
explicit, already required by C12 data. No prior or full-support prior is added.

The necessity proof below uses the public common-posterior witness to extract
weighted partitions. This supplies the extraction hidden by the manuscript's
appeal to Lemma 4 without importing C11 private proof machinery. The converse
still constructs the three actual operation phases. No public declaration per
display, general Bell-number theorem or algorithmic complexity claim is promised.
Reauthenticate affected contracts if the extended draft changes.

## 3. Ownership and verified reuse

Proposed production owner: `PerfectFunctionalRepresentations/Optimization/Incidence.lean`.
If construction size warrants separation, use a focused sibling
`Optimization/IncidenceConstruction.lean`, with the mathematical contracts and
consumer import direction recorded before review. The incidence definitions
must not depend on a generic optimization framework. Use namespace
`PerfectFunctionalRepresentations`; existing operations remain in
`MatrixOperations`. One-off decoder, cast and sum helpers stay private.

Start with `Matrix.PatternCompression`, `Matrix.Partitions` and the focused
mathlib matrix imports actually needed. `PatternCompression` already brings
C10 synthesis/reachability through supported local imports. C11 public
characterizations may be imported by the construction/integration layer when
used; do not import its private names or broaden the lightweight root.
Regressions belong in `Tests/Optimization/Incidence.lean`; bulky paper fixtures
may be separately imported from `Tests/Examples/Incidence.lean`.

Existing declarations below are source-verified; compiling discovery and
consumer results, including rejected guesses, belong in the planning notes.
Names for new C13 declarations in this plan are descriptive, not existing API.

| Existing surface | Use |
| --- | --- |
| `CompressedPatternData`, `.channel`, `.channel_apply`, `.channel_columnPattern`, `.value_le_one`, `.patterns_nonempty`, `.toActiveFiniteChannel` | Minimal valid data, reconstructed channel and supplied active presentation. |
| `isPerfectlyRepresentableChannel_iff_compressedPatternData` | Prior-free ambient singular-channel wrapper, including inactive output labels. |
| `partitionOfBlocks`, `partitionOfBlocksEquiv`, `partitionOfBlocksEquiv_apply_val` | Exact labelled blocks and correspondence to mathlib parts. |
| `Finpartition` finite instance, `existsUnique_mem`, `nonempty_of_mem_parts` | Finite intrinsic partition indices, nonempty parts and exact coverage. |
| `Finpartition.copy`, `copy_parts` | Verified transport to actual PPS column-pattern carriers while retaining exactly the supplied parts for VPS. |
| `multiPpsOfNonnegative` / `multiPpsOfENNReal`, `multiVpsFamily`, `multiPpmFibers` | Actual finite PPS, VPS and PPM with positive support, complete labels and exact coordinates. |
| `LabelledOperationResult`, `NormalForm`, `Cascade`, `FromAllOnes.isPerfectlyRepresentable` | Retained construction witnesses and C10 easy implication. |
| `IsPerfectlyRepresentableChannel`, `isCanonicalCoupling_of_coordinateFactorization` | Public `q,V` witness and its coordinate marginals for necessity. |
| `coordinate_eq_of_posterior_support` | Existing C03 public decoder-support consequence of common-posterior factorization; reuse it when identifying whole pattern fibers. |
| `isPerfectlyRepresentable_iff_fromAllOnes`, `isPerfectlyRepresentable_iff_toAllOnes` | C11 public integration consequences on active states; no implicit extraction theorem. |
| Finite sums, PMF map/atom laws, `PMF.sum_toReal`, `Matrix.reindex`, matrix-vector multiplication | Aggregation, conversion and explicit coordinates. |

Pinned LeanInfoTheory's API contract, declaration index, module guide, theorem
highlights and relevant public probability/channel source are discovery
inputs. Reuse their conventions through the existing PFR layer. C13 needs no
new generic entropy, information, channel or probability theory. Finpartition's
general enumeration can be expensive; finite instances are logical tools, not
a claimed efficient algorithm. Concrete fixtures should use explicit partitions.

## 4. Mathematical contract

### 4.1 Valid data and intrinsic indices

Let `α` have `[Fintype α] [Nonempty α]`, and let `D : CompressedPatternData α`.
Its only data assumptions are positive Real values on a finite set of distinct
nonempty patterns and C12's per-input `row_sum`. Do not add total-pattern
normalization, perfectness, feasible coefficients or an optimizer.

Use these intrinsic finite types, with consistent local classical decidability
as in C10 so that the lattice instance in `Finpartition` agrees:

- `A := {s : Finset α // s.Nonempty}`: all nonzero patterns;
- `O := ↥D.patterns`: occurring patterns, with the natural inclusion into `A`;
- `Q := Finpartition (Finset.univ : Finset α)`: all exact partitions;
- `J := {π : Q // every part of π, as an element of A, belongs to D.patterns}`.

Neither `J` nor the positive coefficient support has a global `Nonempty`
instance. All definitions and transports must work with empty `J`.
Prove `Fintype.card A = 2 ^ Fintype.card α - 1` and
`D.patterns.card ≤ 2 ^ Fintype.card α - 1`. Prove the partition/indicator
boundary: parts are nonempty and their indicator vectors sum to one; conversely
a finite set of nonzero patterns with indicator sum one yields an exact
partition via the existing adapters. No general Bell identity is required.

### 4.2 Full and reduced incidence

Define Real matrices and vectors:

| Object | Type | Entry |
| --- | --- | --- |
| `v̂` | `A → ℝ` | `D.value p` on occurring patterns, zero otherwise |
| `Ĥ` | `Matrix A Q ℝ` | 1 iff the row pattern is a part of the column partition |
| `H` | `Matrix O J ℝ` | The corresponding restriction of both rows and columns of `Ĥ` |
| `P̂` | `Matrix α A ℝ` | 1 iff the input belongs to the pattern |
| `P` | `Matrix α O ℝ` | The same incidence on occurring patterns |

Expose membership/entry specifications and nonnegativity. Full feasibility is
`(∀ π, 0 ≤ ŵ π) ∧ Ĥ.mulVec ŵ = v̂`; reduced feasibility is
`(∀ π, 0 ≤ w π) ∧ H.mulVec w = D.value`. These are predicates on vectors,
not fields of valid data.

Prove all four structural identities:

```text
P.mulVec D.value = (fun _ => 1)
P * H = (fun _ _ => 1)
P̂.mulVec v̂ = (fun _ => 1)
P̂ * Ĥ = (fun _ _ => 1)
```

The matrix right-hand sides are rectangular all-ones functions of types
`Matrix α J ℝ` and `Matrix α Q ℝ`; they are not `Matrix 1` or identity matrices.
The identities hold independently of feasibility, including empty `J`.

### 4.3 Restriction, zero extension and weight consequences

Restrict full coefficients along `J → Q`. Extend reduced coefficients by
zero outside `J`. Prove, with actual vectors:

1. Restricting a zero extension gives the original reduced vector.
2. A nonnegative full feasible vector vanishes at every inadmissible partition.
   Use an absent block and its zero row; every summand is nonnegative.
3. Restriction maps full feasible vectors to reduced feasible vectors;
   zero extension maps reduced feasible vectors to full feasible vectors.
4. Extending a restricted full feasible vector recovers it. Deduce existential
   equivalence. A bundled equivalence of feasible subtypes is optional unless
   it simplifies an actual consumer; the inverse laws themselves are required.

Do not claim this for arbitrary signed coefficients or inequality systems.
Using the structural identities at a chosen input, derive total coefficient
weight one for equality solutions. This algebraic normalization needs equality
and nonempty input; nonnegativity is needed for the further bounds.
For every nonnegative feasible vector prove `0 ≤ w π ≤ 1` and the sharper
`w π ≤ D.value p` when `p` is a part of `π` (with the full zero-padded analog).
This proves the paper's `[0,1]` formulation equivalent to nonnegative equality
feasibility. It does not assume coefficient bounds initially.

For `J+ := {π : J // 0 < w π}`, prove normalized positive total, nonemptiness
derived from feasibility, and preservation of every incidence sum on restriction.
The block-to-pattern map from `(π : J+) × (parts of π)` is surjective onto `O`:
positive `D.value p` forces a positive contributing weight. This is a required
input to prescribed-fiber PPM, not an extra premise. Empty `J` implies equality
infeasibility for valid data; no invented partition or dummy active column.

### 4.4 Perfectness implies feasible weights

For `IsPerfectlyRepresentableChannel D.channel`, obtain its public witness
`q : PMF (α → O)` and common posterior `V`. Restrict decoder functions to the
finite positive support of `q`. For each supported function `f`:

- a nonempty decoder fiber for output `p` equals the whole pattern `p.val.val`;
  prove this from the common-posterior factorization and positive mass, reusing
  `coordinate_eq_of_posterior_support` rather than reproving its generic content;
- its nonempty fibers partition `univ`, so the C10 adapter gives an element of
  `J`, with exact output/block labels;
- aggregate `q f` by that admissible partition, using exact finite sums and
  then Real masses, with all conversions and support zeros justified.

Prove the resulting coefficients are nonnegative and satisfy `H w = D.value`.
At an input in pattern `p`, membership of `p` in the decoder partition is
equivalent to `f input = p`, so the incidence sum reduces to the existing
coordinate marginal. No posterior uniqueness on unused fibers or full-support
input prior is assumed. Decoder partitions and pushforward bookkeeping stay
private unless real consumer pressure justifies promotion.

Because occurring-pattern labels are distinct, the resulting partition
determines its supported decoder: the unique block containing an input determines
that input's output label. Distinct supported decoders therefore cannot have
identical complete partition images. The finite-sum aggregation route may remain
generic, but no such duplicate-image fixture or public injectivity theorem is
required. Instead, test distinct partitions that share a block: their different
coefficients must both contribute to that pattern's incidence row (R13).

This proof route is proposed, not implemented by a typechecking probe. C11's
public iff is available for reachability wrappers, but cannot replace the
weight-extraction argument with a citation. Routine proof-route improvements
are permitted within the contract; changing its strength or hypotheses is not.

### 4.5 Feasible weights imply an actual operation construction

For each supplied feasible `w` and each enumeration `e : O ≃ Fin m`, construct
the actual PPS/VPS/PPM phases from `ActiveFiniteChannel.allOnes α` to
`D.toActiveFiniteChannel e`:

1. Convert the coefficients exactly to NNReal or ENNReal and use C10 PPS on
   `J+`. The labels are precisely positive-weight partitions and masses are
   the supplied coefficients, not an unrelated existence witness.
2. On the **actual** PPS endpoint, show each pattern is `univ`; transport its
   supplied `Finpartition univ` to the exact carrier expected by `multiVpsFamily`.
   Retain the equivalence between resulting labels and dependent pairs of
   positive partitions and their blocks. The mass is `ofReal (w π)` on that
   block and zero elsewhere.
3. Apply `multiPpmFibers` to the block-pattern map, using its proved
   surjectivity and equal-pattern fibers. The complete final labels correspond
   to `O`; prove each merged mass is the C12 reconstructed channel mass and
   provide the directed output equivalence to the supplied presentation.

Retain the actual paths, homogeneous tags, intermediate coordinates and label
bijections using existing `LabelledOperationResult` and `NormalForm`/`Cascade`.
`NormalForm` alone retains paths and the final comparison, not the coefficient
and label specifications. A public consumer must start with supplied feasible
`w`, obtain one returned construction, and recover its PPS, VPS and PPM label
equivalences and exact coordinate equations for those same returned endpoints.
Those specifications must refer to that supplied `w`; unrelated existential
phase witnesses do not meet the contract. Public construction/specification
lemmas suffice; a new bundle is optional. Singleton phases may be zero-length;
do not require a strict split when weight is one.

Deduce the chain of equivalences between reduced/full nonnegative equality
feasibility, existence of this partition-weight construction, perfectness of
`D.channel`, and C11's two reachability predicates on each supplied active
presentation. Use C12's public bridge for a finite ambient singular channel.
The converse from any such operation construction uses C10 preservation; no
universal classification of every arbitrary path is added.

### 4.6 Finite presentations and downstream interface

Keep intrinsic indices primary. For arbitrary supplied equivalences of `O`,
`J`, `A` and `Q` with the appropriate `Fin` types, use `Matrix.reindex` and
explicit vector transport. Prove entry, matrix-vector equation and nonnegativity
transport, full/reduced feasibility invariance, and the directed compatibility
of the construction endpoint with C12's supplied presentation. Input row
enumerations similarly reindex `P`; no canonical sorting is imposed.

Write `m = card O`, `R = card J` and `R̂ = card Q`. The full matrix has
`(2^k - 1) × R̂` coordinates; the reduced matrix has `m × R`, with `R ≤ R̂`.
Do not identify either general partition cardinality with a Bell number in C13.
Only the reduced dual later has `m` variables.

C14 receives valid data, both incidence systems, positive bounded values,
structural identities, equality feasibility/perfectness, normalized weights
and enumeration transport. C14 owns inequalities, objective saturation and
greatestness. C15 receives the same data, exact dimensions, nonempty patterns
and the rectangular identities; it can derive pattern-size weighted identities
for its separator correction. C15 owns weak duality, separation, normalization
of separators, leastness and attainment. No such proof starts in C13.

## 5. Proposed steps

The six steps follow distinct proof dependencies. They are not permission to
start work. Each step inherits Sections 2-4 and the validation/documentation
rules in Section 7, and stops after its own accepted outcome. Criterion IDs are
stable; proposed declaration spelling and private proof organization may improve.

### PFR-C13-S01 — Intrinsic partitions and incidence coordinates

**Prerequisites:** C10-C12 completed and exact-plan approval.
**Objective/ownership:** Create the finite indices, exact-partition indicator
boundary, full/reduced matrices and arbitrary finite presentations in the
incidence module. Reuse C12 data without modifying its assumptions. Helpers
for cardinal arithmetic and typeclass coherence stay private.

- **C13-S01-A:** `A/O/Q/J`, full values and both matrices have exact membership
  contracts and finite instances; `J` may be empty. The partition/indicator
  bridge faithfully implements the source definition.
- **C13-S01-B:** The full pattern cardinality, distinct-occurrence bound and
  admissible-partition inclusion bound are proved with explicit dimensions.
- **C13-S01-C:** Supplied reindexings preserve entries, vector equations and
  nonnegativity. Early consumers cover singleton input and an empty `J` type.

**Validation/docs/stop:** Build incidence and its tests plus the C10 partition
consumer. Start implementation notes and the step/regression crosswalk; update
actual map coverage without claiming feasibility. Stop before weight theorems.

### PFR-C13-S02 — Structural identities and full/reduced feasibility

**Prerequisite:** S01 closed.
**Objective/ownership:** Prove Sections 4.2-4.3 in the incidence module; finite
sum/cancellation machinery stays private. Positive-support facts are explicit
public inputs where the synthesis consumer needs them.

- **C13-S02-A:** Both `P v = 1` and rectangular `P H = 1` identities, with
  full analogs, hold on arbitrary valid data without feasibility assumptions.
- **C13-S02-B:** Restriction/zero extension preserve nonnegative equality
  solutions and satisfy the required inverse/support laws; the existential
  equivalence does not extend silently to signed vectors or inequalities.
- **C13-S02-C:** Equality gives total weight one; nonnegative solutions have
  incidence/value and unit bounds. Positive-support restriction preserves sums,
  has derived nonemptiness, and covers every occurring pattern. Empty `J` is
  infeasible. Check the actual C10 positive-support input type early.

**Validation/docs/stop:** Focused incidence tests plus C10 synthesis consumers;
record the DG-12 contract's proved portions and explicit zero/absent cases.
Use explicit three-input partitions to check the mixed/signed controls R06-R08,
the proper full/reduced feasible correspondence in R13, and the nonnegative
infeasibility in R14 during this step. Full five-partition classification remains
S05; use forced coefficient rows for the negative controls rather than waiting
for that classification. Stop before perfectness extraction.

### PFR-C13-S03 — Extract weights from a perfect channel

**Prerequisite:** S02 closed.
**Objective/ownership:** Implement Section 4.4 from the public semantic witness.
Keep decoder partitions, support aggregation and scalar cancellations private;
expose a nonnegative feasible witness theorem for arbitrary valid `D`.

- **C13-S03-A:** Every supported decoder yields an admissible exact partition,
  with complete nonempty-fiber/pattern correspondence and no hidden prior.
- **C13-S03-B:** Aggregation gives actual Real coefficients with nonnegativity
  and every equality row, including contributions from distinct partitions
  sharing a block and support zeros; use the precise decoder contract in §4.4.
- **C13-S03-C:** Public consumers recover full and reduced feasibility from
  perfectness using S02 transport; audit that no private C11 names, assumed
  feasibility or strengthened valid-data hypotheses entered the proof.

**Validation/docs/stop:** Build the owner, tests and public C11/C12 consumers;
check singleton, shared-block aggregation (R13) and zero-mass decoder cases.
Use an explicit two-decoder witness for R13, without depending on S04's later
sufficiency theorem. Document the common-posterior extraction route as the
bridge for the paper's compressed
necessity argument. Stop before construction from arbitrary feasible weights.

### PFR-C13-S04 — Construct the three operation phases and characterize perfectness

**Prerequisite:** S03 closed; S02 positive-support interface available.
**Objective/ownership:** Implement Sections 4.5-4.6 using C10 public synthesis,
C11 public characterizations and C12 reconstruction. Reuse labelled phase
results and directed equivalences; introduce no duplicate path framework.
Begin with a compiling consumer across the actual phase endpoints: transport
the supplied partitions to the actual PPS column-pattern carriers, then compose
the actual VPS output-label equivalence with the semantic dependent-pair
equivalence and block-to-pattern map expected by `multiPpmFibers`. Establish its
surjectivity and equal-pattern fibers before final coordinate simplification.
Do not rely on implicit unfolding of an active state's output cardinality or
a guessed equality of dependent types. The earlier planning probe covers only
PPS to VPS; this VPS-to-PPM boundary remains an implementation obligation.

- **C13-S04-A:** Each feasible vector produces actual PPS/VPS/PPM phases on
  its positive support. Phase labels, patterns and masses are specified on the
  same returned construction, including the dependent VPS carrier transport;
  a public consumer recovers them for its supplied coefficients as in §4.5.
- **C13-S04-B:** The PPM target map is surjective by valid-data positivity and
  feasibility. Its endpoint equals the reconstructed channel under a complete
  directed label equivalence for every supplied enumeration.
- **C13-S04-C:** Reduced/full feasibility, partition-weight construction,
  perfectness and both C11 reachability formulations are equivalent. The ambient
  singular-channel wrapper uses C12 and handles inactive output coordinates.

**Validation/docs/stop:** Build construction/incidence/tests and C10 synthesis,
C11 characterizations and C12 compression consumers. Exercise an actual feasible
vector with a zero coefficient while all required patterns remain positive,
singleton no-op phases, and R13's unequal columns sharing a block through a
genuine PPM merge (one operation by the existing `multiPpmFibers_length` law).
Use R14 with the new characterization to obtain a nonperfect valid-data consumer
despite nonempty admissible partitions. Record source interpretation and
signatures. Stop before later optimization or the next validation step.

### PFR-C13-S05 — Paper fixtures and integrated readiness

**Prerequisite:** S04 closed.
**Objective/ownership:** Complete separate fixtures, all regressions in Section 6,
and an auditable source/criterion/manuscript crosswalk. Helpers remain private;
fix only evidenced C13 integration issues within the approved contract.

- **C13-S05-A:** Classify all five exact partitions for three inputs, verify
  every entry of the paper's `7 × 5` matrix and its full/reduced correspondence.
- **C13-S05-B:** Complete R01-R14, especially false mixed/signed witnesses,
  empty and nonempty infeasible admissible families, zero-weight actual synthesis,
  shared-block aggregation/merging, non-involutive enumerations and ambient C12 transport.
- **C13-S05-C:** Audit public signatures/imports and downstream C14/C15 needs;
  prepare readiness/implementation notes and omission/advice dispositions with
  no missing required mathematical assertion reserved for closeout.

**Validation/docs/stop:** Build every C13 production/test/example module and the
important C10-C12 consumers, then default build. Check public axioms and the
placeholder scan. Stop after integrated readiness; S06 is a separate request.

### PFR-C13-S06 — Fresh cumulative independent validation and closeout

**Prerequisite:** S01-S05 durably closed with original reports reconciled.
**Objective:** Freshly assess the entire approved contract, not merely collect
earlier favorable reports. No new theorem-development phase is reserved here.

- **C13-S06-A:** Fresh source/manuscript/build/trust assessment covers all
  fifteen earlier criteria, R01-R14 and CC01-CC08. Audit every new named
  declaration, private helper and anonymous test, and inspect dependency scope.
- **C13-S06-B:** The same bound reviewer performs a fresh cumulative independent
  assessment of the complete contract and actual final implementation. Preserve
  every original report and critically reconcile findings and criterion status;
  earlier assessments do not replace this fresh pass.
- **C13-S06-C:** Complete applicable final validation, owning documentation,
  source F and supported durable closure. Review-time readiness is assessable
  before later receipt/reconciliation/F/closure; those future duties remain
  acceptance requirements and are not certified by the earlier review.

**Repair/stop:** Investigate correctness gaps; do not downgrade them to optional
future work. Bounded in-scope repairs require fresh affected checks and review
as required by the installed protocol. Substantive contract changes require the
lead. Only supported closure completes CC09/C13. Stop; C14 does not start.

## 6. Required regressions

| ID | Assertion | Due |
| --- | --- | --- |
| R01 | Arbitrary valid C12 data elaborate without perfectness, feasibility or total-pattern normalization; intrinsic indices remain finite when `J` is empty. | S01; strengthen S02 |
| R02 | Singleton input has the one nonempty pattern/value one and one exact partition; feasible weight one permits no-op phases. | S01, S02, S04 |
| R03 | Empty admissible family implies equality infeasibility without creating `Nonempty J`; existing pair-only three-input data instantiate it. | S02; concrete completeness S05 |
| R04 | Absent patterns have zero full value; full feasible coefficients on inadmissible partitions vanish, and restriction/extension recover actual vectors. | S02 |
| R05 | Pair-only patterns `{01,02,12}`, each value `1/2`, are valid but nonperfect; reuse the public C03 channel and C12 extraction, not private test fixtures. | S02, S03/S04 wrappers, S05 |
| R06 | Invalid mixed system for R05 has weights `(0,1/2,1/2,1/2,0)` and total `3/2`; this is a false positive even with coefficient bounds `[0,1]`. | S02 assertions; S05 classification |
| R07 | Same data have full signed solution `(0,1/2,1/2,1/2,-1/2)` but no reduced solution, demonstrating the essential nonnegativity qualifier. | S02 assertions; S05 classification |
| R08 | With only pattern `111`, value one, the mixed system permits `(1,0,0,0,2)`. The full system rejects it because absent singleton rows receive mass `2`. Restriction to the sole admissible partition `{111}` is weight `1` and is reduced feasible; zero extension gives `(1,0,0,0,0)`, not the original vector. The original five-vector is not reduced-typed, and recovery of arbitrary full vectors was never promised. | S02; integrated S05 |
| R09 | All seven patterns each of value `1/4`, with feasible weights `(1/4,1/4,1/4,1/4,0)`: retain all output patterns but remove the zero-weight partition; inspect actual PPS/VPS/PPM labels and endpoint. The four positive partitions share no blocks, so this checks zero-weight handling but has a no-op final PPM phase. | S04; fixture completeness S05 |
| R10 | Paper row order `100,010,001,110,101,011,111`; columns `{111}`, `{110,001}`, `{101,010}`, `{011,100}`, `{100,010,001}`: exhaustive five-partition classification and all 35 incidence entries. | S05 |
| R11 | Independent non-involutive row/partition enumerations preserve matrix-vector equations, nonnegativity and endpoint direction; full/reduced comparison handles empty indices too. | S01, S02, S04; integrated S05 |
| R12 | Supplied C12 active presentations, inactive ambient outputs and injective output relabeling preserve the feasibility/perfectness consumer without a compression-idempotence alias. | S04-S05 |
| R13 | Shared-block positive fixture: `{100,010,001}` has weight `1/3` and `{110,001}` has weight `2/3`; full weights are `(0,2/3,0,0,1/3)`. Full values are `(1/3,1/3,1,2/3,0,0,0)`. Exactly four patterns and two partitions survive reduction, giving a proper `7 × 5` to `4 × 2` correspondence with restriction/extension recovering the feasible vectors. The shared `001` row receives both coefficients. The actual construction has two PPS outputs, five VPS leaves and four final patterns: the unequal `001` columns of mass `1/3` and `2/3` must merge to mass `1`. | S02 equations/transport; S03 aggregation; S04 synthesis; S05 integrated |
| R14 | All seven patterns occur: singleton and `111` values are `1/8`, pair values `3/8`. Every input row sums to one and all five partitions are admissible, yet nonnegative equality is infeasible. Pair rows force their three partition coefficients to `3/8`; a singleton row then forces the all-singleton coefficient to `-1/4`. The signed solution `(1/8,3/8,3/8,3/8,-1/4)` confirms this is a nonnegativity obstruction with nonempty `J`. | S02 algebraic obstruction; S04 nonperfectness consumer; S05 classification |

All numeric vectors use R10's paper row and column orders. R13's reduced
presentation may use occurring rows `100,010,001,110` and columns
`{110,001}`, `{100,010,001}`, with coefficients `(2/3,1/3)`. Its exact
admissible-family description follows directly from the four allowed blocks.
In S02, define full vectors as sparse functions supported on the displayed
partitions and check transport to the two admissible partitions. The complete
five-column enumeration of the full universe, including its cardinality and
the full `7 × 5` presentation, remains S05. This stages the same fixture without
requiring S05's global classification in S02.

The R09 family sums to `7/4` across patterns but to one at each input.
Empty input is excluded by the valid-data boundary, not by inventing a theorem
over it. No tests should assume efficient exhaustive general `Finpartition`
evaluation. Every regression is freshly reassessed in S06.

## 7. Validation, documents and completion

After each coherent Lean change, build its owner and actual consumers. Before
each milestone run `lake build`; the lightweight target alone does not cover
matrix/tests. Preserve exact commands, source inventories and failures. Require
the AGENTS.md placeholder scan to return no matches. Audit public hypotheses,
imports and axiom dependencies; S06 includes private named machinery and
anonymous examples, with the actual inventory and any audit limits explicit.

Compare against the real step baseline, not just HEAD. Inspect final diff,
status, tracked generated files, ignored references and temporary artifacts.
Preserve inherited work, original reports and durable `.pfr-review` records.
Apply canonical document updates before final source checks/F. Proposed names
and probes are not implemented coverage, and status must never imply approval.

| ID | Completion outcome |
| --- | --- |
| CC01 | Intrinsic finite pattern/partition indices, exact indicator boundary, valid-data assumptions and exact dimension bounds are implemented. |
| CC02 | Full/reduced incidence and typed structural identities hold without feasibility assumptions. |
| CC03 | Nonnegative equality restriction/extension, absent-coefficient zeroing and inverse laws are proved. |
| CC04 | Total weight, incidence/unit bounds, positive-support coverage and empty-family infeasibility are proved. |
| CC05 | Public perfectness yields a verified admissible partition-weight witness without private C11 dependencies or prior assumptions. |
| CC06 | Every feasible weight vector has specified actual PPS/VPS/PPM phases, complete labels, exact endpoint and all required characterization/ambient bridges. |
| CC07 | R01-R14, complete three-input fixtures and arbitrary finite presentations are checked. |
| CC08 | Public/import ownership, pinned reuse, manuscript repairs, omissions/advice and C14/C15 handoff are current; optimization remains outside C13. |
| CC09 | Fresh cumulative independent assessment, complete original-report reconciliation, final applicable checks, documents, F and supported durable closure are complete. |

Implementation notes own execution evidence; the readiness audit owns the final
crosswalk; the log owns milestones and disposition history. The living summary
owns current status and risks; the map owns DG-12, coverage and omissions.
README/scope/roadmap receive concise status updates when those facts change.

## 8. Omissions, deferrals and advice

The Future Work Notes register has no numbered notes at planning startup.
All currently identified omissions and advice have existing owners below.

| Record | C13 disposition / owner and trigger |
| --- | --- |
| OM-014/044/068; DG-10/DG-11 | Retain support finsets, existing valid data and Finpartition. C13-S01/S04 bridge explicit enumerations; no replacement semantic data structure. |
| OM-017 | General Bell identity/asymptotics remain excluded. C13-S05 proves only the concrete five-partition fixture; no efficient enumerator claim. |
| OM-019 | C13-S01 proves the finite distinct-pattern bound. Running-time and efficient-solvability prose remain documentation-only. |
| OM-025/047; DG-12 | Sections 4.2-4.3 and S02/S05 own the full/reduced repair, inverse laws and mixed/signed counterexamples. C15 retains reduced-dual wording. |
| OM-027/042; DG-15 | ISIT Examples 6-7 / extended Examples 7-8 are separate fixtures; all assigned logical content (33)-(63) is covered without a public name per display. C10's extended Example 6 remains completed history. |
| OM-051/052 | S04 retains actual C10 paths and directed comparisons, including singleton and zero-weight cases. No global inverse or abstract synthesis replacement. |
| OM-046; DG-13/DG-14 | Equality feasibility and normalization stop at C13. C14/C15 own optimization, separator correction, greatestness/leastness and attainment at their planning triggers. |
| C12 planning research / approved plan §9, revisited at C12-S04 | No current C13 consumer needs a separate compression-idempotence alias. Continue the existing deferral to a concrete consumer during C13 integration; owner C13-S04/S05. Preserve the original suggestion, with no promise to implement. |
| API planning advice: C11 private construction helpers | Use the public common-posterior witness in S03 and existing public iff statements in S04. Private-helper promotion is unnecessary for this route; revisit only if an actual blocked consumer demonstrates the need. |
| Parent suggestions P01-P04 and General Assistant advisory GA01-GA03 | [Revision-2 dispositions](../pfr-c13-planning-notes.md#revision-2-advice-dispositions) record their distinct provenance, selection and exact owners. S02-S04 and R08/R13/R14 incorporate the corrections and strengthened consumers; the separate proposed `5 × 3` positive fixture is unnecessary because R13 already exercises proper full/reduced transport. No new deferral is created. |
| OM-018/028-032/039/043 and roadmap | Solvers, generic LP theory, extended-only algorithms/hardness/applications and shortest/canonical normal forms remain excluded; separate approval is required. |

New material omissions must be recorded under the established map/log ownership
rules. Optional advice may be deferred with a question and trigger; correctness
and acceptance gaps must be resolved or escalated.

## 9. Revision and review policy

This approved revision awaits a separate step request. A separately requested plan
review uses the same persistent reviewer and an actual source-bound `plan-*`
session. It does not approve implementation. Keep requested settings separate
from observable effective settings and retain the installed supervised limits.
The endorsement/readiness request does not start an execution session or dispatch review.

During an authorized step, improve proof routes, private organization and
tests when evidence warrants it; record reasons and assess downstream plan
health. Preserve original reviewed contracts/reports and review the resulting
work. Substantive changes to mathematical intent, scope, hypotheses or acceptance
require the lead. The reserved status block is editorial only. No completed
step starts its successor automatically.

For a later explicit plan review, proposed criteria are:

- **C13-PR01:** Baseline, prerequisite closure, manuscript identity and authority
  are supported by attributed evidence.
- **C13-PR02:** Intrinsic types, minimal data, indicator/matrix orientation,
  dimensions and arbitrary presentations are precise and feasible.
- **C13-PR03:** Full/reduced nonnegative equality equivalence, inverse laws,
  normalization, bounds and empty/absent cases repair the printed defect.
- **C13-PR04:** Necessity genuinely extracts weights, and sufficiency retains
  actual coefficient-specific operation witnesses using public supported APIs.
- **C13-PR05:** Dependency-driven steps, probe limits, regression staging and
  fresh cumulative closeout cover the exact mathematical contract.
- **C13-PR06:** Omissions, advice, ownership, C14/C15 boundaries and stopping
  rules are complete without unauthorized implementation or scope expansion.
