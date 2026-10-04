# PFR-C15 — Dual Characterization

<!-- pfr-review-status:start -->
**Status:** Active revision 2, PFR-C15-S05 cumulative independent review reconciled; final closure checkpoint, 2026-10-02.
S01-S04 are durably complete; all three S05 independent criteria are satisfied.
The complete original report is critically reconciled; final F/closure remain.
**Authority:** The actual conditional S05-with-review request was accepted after
fresh verification of all four earlier closures/original-report reconciliations,
twelve criteria, resolved findings and exact 174-entry source/environment/Git
agreement. B and owned
before-images precede changes. No installed independent plan review is claimed.
**S05:** Freshly reassess all earlier criteria, R01-R10, CC01-CC08 and the complete
mathematical/API/import/trust surface. Fresh parent checks/audits pass;
Fresh cumulative independent assessment satisfies all three criteria, without
findings; original report reconciliation is complete. Final applicability/F and
supported closure follow this checkpoint.
**Lead guidance:** Use evidence-based judgment within this step, preserving
mathematical intent, assumptions, scope, acceptance and frozen normative text.
**Reviewer:** Existing `/root/pfr_c15_reviewer`, originating task
`01a0f81e-1ab9-7413-9ed8-c2e905e955cb`, parent role `/root`; requested
`gpt-6-astra` / `ultra` / `fork_turns="none"`; effective settings unknown.
Read-only is instructed, not OS-enforced. [Implementation notes](../pfr-c15-implementation-notes.md)
own exact originals, checks and limits. Only supported final closure completes
CC09 and C15; no later chunk starts. Normative Sections 1-9 remain unchanged.
<!-- pfr-review-status:end -->

## 1. Baseline, scope and proposed DG-14 decision

HEAD is `54c1714d1a9a891939d6c9f7d38c0d05896b2c75`. Preserve inherited tracked
and untracked changes and `.pfr-review/` durable records. C14 S04 closure is
`22433dd6bda1ff040dd0c16b54781e251599429537fef10902dd81b246fa1b8b`, with final
source F `7d87d9b7baf75d739ee9a2f08ed49ba178187b71624a98ab94b7d533ecc9751c`.
The later closure establishes completion; initializing C15 does not reopen C14.

LeanInfoTheory stays at immutable `v0.1.0`, commit
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`; Lean is `v4.33.1`, mathlib is
`0df444a360eaa60ab8c11dca51a86af692955474`. Installed pins are clean and match
the manifest. No dependency, workflow, commit, push or website change is planned.

**Proposed DG-14 resolution:** Use the same valid reduced data as C13/C14.
Prove weak duality and a universal objective-one row witness. For nonperfect
data, split empty admissible partitions first; otherwise separate the value
vector from the finite convex hull of incidence columns, represent the
functional by coordinates, correct signs by pattern cardinalities, and scale
by a proved positive threshold. Obtain a feasible objective strictly below one.
Combine this with weak duality and the row witness to prove attained `IsLeast`
at one iff perfectness, then transfer to ambient singular channels and finite
presentations. DG-14 remains **Open** at draft time; design approval and proof
completion are distinct events.

Non-goals: generic LP strong duality or Farkas infrastructure, solvers,
algorithms/runtime claims, infimum notation, global optimizer existence for
every nonperfect datum, a full-coordinate dual theorem hierarchy, Bell-number
enumeration, extended-only applications and the broader nonsingular/singular
wrapper. C16 retains that wrapper's scope assessment. Do not weaken the target
to an objective-one existence statement: such a witness exists for all valid data.

## 2. Authenticated manuscript anchors and interpretation

Fresh hashes and complete-page renders were checked locally. Manuscript binaries,
extracts and images remain external or ignored, never maintained or stored in
private review records. The extended identity must be rechecked after an update.

| Source | Version identity | Relevant passages |
| --- | --- | --- |
| Six-page ISIT final, filename ending `final_manuscript_ (3).pdf` | SHA-256 `48963aa59485b2c33b1a1e6e7c6ead2251fdddd26bd3691b6fcffe683e6ed1c4` | PDF p.5, left, Section IV-B, Corollary 1/(19), variable vector and `m ≤ 2^k − 1`. The neighboring concluding runtime prose is only an omission cross-reference. |
| Eighteen-page extended version 16, designated 2026-09-03 | SHA-256 `98636d4c9f0618ec08fca84559572780f604f197fda90d8d7c787b3624245b8f` | IV-A p.6, (40)-(56): full/reduced clarification, especially (47)-(53) and normalization (55); IV-B p.7 left, Corollary 1/(65)-(67). (68)'s Bell bound is already excluded under OM-017. |

The ISIT's intended `m` variables refer to occurring patterns in the **reduced**
system, whose columns are admissible exact partitions. C13 already repaired
the printed mixed system and proved the full/reduced nonnegative equality
bridge. C15 does not silently apply that equality bridge to dual inequalities.
The full nonzero-pattern universe has `2^k − 1` coordinates; the reduced dual
has exactly `m = D.patterns.card`. No absent pattern or inactive output gets a
fabricated positive value. The precise minimum contract is `IsLeast` of values
actually attained by feasible vectors, with membership supplied explicitly.

The local separation/correction argument supplies a rigorous specialized proof
of the in-scope corollary. It is not a manuscript claim of a general strong-duality
library. Reading ends at these anchors; extended Section V and Appendix C
algorithmic/complexity results are excluded.

## 3. Ownership and verified reuse

Proposed production files, both in namespace `PerfectFunctionalRepresentations.Dual`:

- `Optimization/Dual.lean`: algebraic predicate, objective, row witness, weak
  duality and finite-presentation transport; focused import `Optimization.Primal`.
- `Optimization/DualCharacterization.lean`: specialized alternative, leastness,
  ambient singular corollary and its finite-presentation corollary; imports Dual
  and justified focused mathlib geometry.
  Convex-hull, cardinality and correction machinery stays private/local.

The second file contains the heavy separation imports; Dual-only consumers
need not import it. Neither file enters the lightweight mathematical root.
No third optimization hierarchy or bundled generic LP record is introduced.

Generic tests: `Tests/Optimization/Dual.lean` and
`Tests/Optimization/DualCharacterization.lean`. Add concrete consumers beside
existing private fixtures in `Tests/Optimization/Incidence.lean` and
`Tests/Examples/Incidence.lean`; do not copy or promote them. Their extra imports
are consumer changes, not reverse production dependencies. Retain disposable
C13-only and Primal-only consumers to check earlier public boundaries.

For R07, proof/audit evidence for the actual private correction helpers stays
within their defining module; any direct helper consumer is local there. External
fixtures check the explicit correction arithmetic through public `Dual.Feasible`
and `Dual.objective`, and instantiate the public alternative separately. They
must not assume its existential witness equals the hand-calculated vector. Do not
expose a public correction helper solely for testing or duplicate its proof.

| Existing declaration / source | Verified role and restriction |
| --- | --- |
| `CompressedPatternData`, `.value_pos`, `.row_sum`, `.channel` | Finite nonempty input, distinct nonempty patterns, positive values normalized per input. No perfectness, feasibility or prior assumption. |
| `Incidence.OccurringPattern`, `.AdmissiblePartition`, `.reducedMatrix`, `.inputMatrix` | Intrinsic finite coordinates; admissible partitions may be empty. |
| `inputMatrix_mulVec_value`, `inputMatrix_mul_reducedMatrix`, `inputMatrix_nonneg` | `P v = 1`, `P H = 1`; furnish row witnesses and, after summing input rows, cardinality correction identities. |
| `Incidence.Feasible`, `sum_eq_one_of_reduced_eq`, `isPerfectlyRepresentableChannel_iff_exists_feasible` | Nonnegative **equality** witnesses and their normalization; normalization is used only after equality. |
| `Primal.Feasible`, `.objective`, `.equality_feasible_iff`, `.isPerfectlyRepresentableChannel_iff_exists_objective_eq_one` | Existing nonnegative inequality primal, unchanged; perfectness supplies an actual primal vector of objective one. |
| `isPerfectlyRepresentableChannel_iff_compressedPatternData`, `compressedPatternData_map_injective`, `D.extraction_roundTrip` | Ambient active restriction/compression and injection/presentation bridges; no new idempotence alias is needed. |
| `Incidence.reindex_mulVec`, `Equiv.sum_comp`, `card_occurringPattern`, `patterns_card_le`, `card_nonzeroPattern` | Transpose transport by swapped equivalences, objective sum transport, exact reduced count and full-universe bound. |
| `convexHull_range_eq_exists_affineCombination`, `mem_convexHull_of_exists_fintype`, `Finset.affineCombination_eq_linear_combination` | Hull/equality bridge; finitely supported hull coefficients are extended by zero to all admissible partitions. |
| `Set.Finite.isCompact_convexHull`, `.isClosed_convexHull`, `convex_convexHull`, `geometric_hahn_banach_point_closed` | Finite coordinate space over ℝ; compact/closed hull and strict separation of an outside point. |
| `dotProductEquiv`, `StrongDual.toLinearMap` | Convert the continuous separating functional to exact finite dot-product coefficients, with evaluation proved via the inverse law. |
| `Matrix.dotProduct_transpose_mulVec`, `dotProduct_comm`, finite-sum order, `div_lt_one`, `one_lt_div` | Weak-duality algebra and positive-denominator normalization; the transpose identity returns `y · Hx` and commutation is explicit. |

Pinned LeanInfoTheory source, public API contract, documentation, index,
highlights and module guide, and pinned mathlib were searched. No new generic
information-theory theorem is needed. Search found geometric cone/Farkas tools,
but no ready theorem-level LP strong-duality result in the inspected release.
That is a bounded search result, not a universal absence claim. Probe receipts,
exact imports and limitations are in the planning notes; proposed names below
are not existing declarations.

## 4. Mathematical contracts

Let `{α : Type u} [Fintype α] [Nonempty α]`, `D : CompressedPatternData α`,
`O := Incidence.OccurringPattern D`, `J := Incidence.AdmissiblePartition D`,
`H := Incidence.reducedMatrix D`, `P := Incidence.inputMatrix D`, `v := D.value`.
Use the existing finite instances with internal classical decidability.

### 4.1 Dual core and elementary witnesses

For `y : O → ℝ`, propose:

```text
Dual.Feasible D y := (∀ p, 0 ≤ y p) ∧ (∀ j, 1 ≤ (Hᵀ *ᵥ y) j)
Dual.objective D y := v ⬝ᵥ y
Dual.feasibleSet D := {y | Dual.Feasible D y}
Dual.objectiveValues D := Dual.objective D '' Dual.feasibleSet D
```

These remain distinct from C13 equality and C14 primal inequality feasibility.
For each `i : α`, `rowWitness D i p := P i p` is nonnegative,
`Hᵀ *ᵥ rowWitness D i = 1`, and its objective is one. Thus one belongs to
`objectiveValues D` for **every** valid datum. Selecting `Classical.arbitrary α`
is internal; no chosen input is part of the semantic theorem.

For existing `Primal.Feasible D x` and `Dual.Feasible D y`, require
`Primal.objective D x ≤ Dual.objective D y`. The orientation follows
`∑x ≤ x · Hᵀy = y · Hx ≤ y · v = v · y`, using `x ≥ 0` for the first
inequality and `y ≥ 0` for the last. Also prove dual objectives nonnegative
using value positivity. No bound `objective ≤ 1` is asserted for arbitrary duals.

### 4.2 Specialized alternative and leading proof

The public specialized result proposed is:

```text
¬ IsPerfectlyRepresentableChannel D.channel →
  ∃ y, Dual.Feasible D y ∧ Dual.objective D y < 1
```

It covers all valid data, including empty `J`. Internal proof obligations:

1. **Empty case first.** With `IsEmpty J`, `y = 0` satisfies vacuous partition
   constraints and has objective zero. This is not the row witness, and equality
   feasibility fails by the existing C13 boundary. No hull nonemptiness is used.
2. **Exact hull bridge.** Define columns `h j p := H p j` and
   `C := convexHull ℝ (Set.range h)`. Prove
   `v ∈ C ↔ ∃ x, Incidence.Feasible D x`, with the same total-index vector.
   In the forward direction, zero-extend finitely supported affine coefficients;
   in the reverse, use C13's equality-implied `∑x = 1`. Equivalently, normalized
   nonnegative equality witnesses are precisely the hull representations.
   No total-value normalization is substituted.
3. **Topology and separation.** In `O → ℝ` use its finite product topology,
   real topological vector-space and finite-dimensional instances. Finite range
   gives compact/closed `C`; `convex_convexHull` gives convexity. In the nonempty
   `J` branch, exhibit a column in `C`. Nonperfectness and the hull bridge give
   `v ∉ C`. `geometric_hahn_banach_point_closed` yields a continuous functional
   `f` and real `c` with `f v < c` and `c < f z` for every `z ∈ C`.
4. **Coordinates and orientation.** Put
   `w := (dotProductEquiv ℝ O).symm f.toLinearMap`. Prove `w · z = f z` for
   every `z`; then `w · v < c < w · h j` for every admissible partition.
   Do not reverse a strict inequality or assume the raw separator is nonnegative.
5. **Cardinality correction.** Set `q p := (p.val.val.card : ℝ)` and
   `k := (Fintype.card α : ℝ)`. Every pattern is nonempty, so `q p ≥ 1`, and
   input nonemptiness gives `k ≥ 1`. Summing the existing identities over inputs
   proves `q · v = k` and `q · h j = k`, using
   `q p = ∑ i, P i p`. These identities preserve the gap; a constant all-ones
   coordinate shift would generally fail because partition block counts differ.
6. **Positive scaling.** Choose `t := (∑ p, |w p|) + |c| + 1`,
   `a := w + t • q`, `b := c + t * k`. Single-summand control and the preceding
   lower bounds prove `a p ≥ 0` and `b > 0`, hence `b ≠ 0`.
   Both sides shift by `t*k`: `a · v < b < a · h j`.
   Put `y p := a p / b`; finite-sum division gives `v · y < 1` and
   `(Hᵀ *ᵥ y) j > 1`, hence the required non-strict feasibility constraint.
   Prove every division identity and inequality using `b > 0` explicitly.

The route is specialized to these data; no generic strong-duality assertion is
introduced. Internal results stay private unless actual consumers justify exposure.

**Alternate interface and split policy.** The separately compiled
`geometric_hahn_banach_compact_closed` composition separates the compact singleton
`{v}` from the closed hull and gives `f v < a < b < f (h j)`; choose `b` as the
threshold and use the same coordinate/correction route. Pinned mathlib implements
`geometric_hahn_banach_point_closed` directly through this singleton composition.
The alternate entry point may help with elaboration or proof packaging, but does
not provide an independent route past hull-closedness or separation difficulties.
Neither probe assembles the complete C15 alternative. A more substantial fallback is
separation from the finitely generated incidence cone using pinned geometric
Farkas tools: prove that cone closed, identify cone membership with nonnegative
equality feasibility, then correct a separating vector so its column products
have a common positive lower bound while the value product stays smaller. Cone
closedness and the Farkas-to-coordinate composition are not established by the
current probes. Do not silently switch to that unverified route or enlarge scope.
If S02 needs substantial foundational infrastructure beyond this contract,
stop for a reviewed split of the specialized alternative and corollary phases
within C15; retain global chunk identifiers and the full target. Current probes
support retaining one chunk with S02 isolated as its main proof-risk step.

### 4.3 Attained leastness and ambient corollary

Require:

```text
IsPerfectlyRepresentableChannel D.channel ↔ IsLeast (Dual.objectiveValues D) 1
```

Perfectness supplies a primal point of objective one through C14; weak duality
gives the lower bound for every dual objective. The row witness supplies membership.
Conversely, nonperfectness would give a feasible value below one by Section 4.2,
contradicting leastness. Objective-one existence alone cannot prove this converse.

For `{β : Type v} [Finite β]`, `κ : α → PMF β`, `hκ : IsSingularChannel κ`, require:

```text
IsPerfectlyRepresentableChannel κ ↔
  IsLeast (Dual.objectiveValues (compressedPatternData κ hκ)) 1
```

Use the existing active restriction/compression perfectness iff. Include inactive
ambient output labels and supplied active presentations through C12's established
bridges. No prior, full support, positive-mass assertion for inactive labels or
nonsingular pattern definition is added.

### 4.4 Finite presentation and exact count

For independently supplied `rows : O ≃ Fin m`, `cols : J ≃ Fin n`, set
`H' := Matrix.reindex rows cols H`, `v' := v ∘ rows.symm`, `y' := y ∘ rows.symm`.
Prove feasibility equivalence and objective equality for every `y`. In particular,
`H'ᵀ y' = (Hᵀ y) ∘ cols.symm`; swapping the row/column equivalences after
transposition is mandatory. Prove equality of the **entire** finite objective image:

```text
(fun z : Fin m → ℝ => v' ⬝ᵥ z) ''
  {z | (∀ i, 0 ≤ z i) ∧ (∀ j, 1 ≤ (H'ᵀ *ᵥ z) j)} = Dual.objectiveValues D
```

Use the inverse `z ∘ rows` to cover every finite vector; a forward-only witness
transport is insufficient. Algebraic transport and the entire objective-image
equality belong in `Dual.lean`. In `DualCharacterization.lean`, combine that
equality with Section 4.3 to transfer `IsLeast` and prove the finite paper-facing
singular-channel corollary. This corollary must not introduce a characterization
or geometry dependency into `Dual.lean`. No new bundled LP record is needed.
The type `Fin m → ℝ` supplies
exactly one variable per occurring pattern, with
`m = Fintype.card O = D.patterns.card ≤ 2^Fintype.card α − 1` by existing APIs.
Supplied equivalences, including `n = 0`, and canonical `Fintype.equivFin` suffice.
The full universe's exact count is reused, not reproved or presented as `m`.

## 5. Dependency-based execution steps and acceptance criteria

Every implementation request addresses one approved step and stops after its
supported closure. All IDs below are stable; actual criterion contracts must
include these exact duties, not merely a subset selected by substring matching.

### PFR-C15-S01 — Dual core, weak duality and objective-one witnesses

Depends on completed C13/C14. Add Dual and generic tests; stage singleton/empty
fixture consumers and the signed-dual rejection on existing `obstructedData`
in their existing owners. Do not start the separator proof.

- **C15-S01-A:** Definitions in Section 4.1 express nonnegative dual inequalities
  and the actual objective image without changing C13/C14 predicates. Nonnegative
  objectives and weak duality hold on arbitrary valid data with correct orientation.
- **C15-S01-B:** For every input, row witnesses satisfy `Hᵀy = 1` and objective one;
  membership at one is explicit for all valid data. Empty-partition zero feasibility
  and objective zero are separately established; no partition nonemptiness is assumed.
- **C15-S01-C:** R01-R04's S01 assertions compile; imports, all new public signatures
  and transitive axioms are audited. Prior C14 closure/current-source applicability
  is checked; documentation records why objective-one existence does not suffice.

### PFR-C15-S02 — Specialized strict-below-one alternative

Depends on S01. Add DualCharacterization with only the specialized alternative
public; all Section 4.2 machinery is private/local. Do not substitute a global
optimizer or a literal mixed incidence system.

- **C15-S02-A:** The exact hull/equality bridge, finite topology, compactness,
  closedness, convexity, outside-point separation and functional-coordinate
  evaluation are proved for the actual intrinsic types. Empty partitions are
  split off before the nonempty hull argument.
- **C15-S02-B:** Prove both cardinality identities, coordinate correction,
  common-gap preservation, positive/nonzero normalization and correctly oriented
  strict inequalities; assemble the public Section 4.2 certificate for every
  nonperfect datum without new assumptions.
- **C15-S02-C:** R04/R06/R07's certificate and sign/scaling assertions compile,
  including the nonempty-partition obstructed datum. R07 distinguishes local
  proof/audit evidence for the private production helpers from external explicit
  arithmetic and public-certificate consumers. Audit all new public and private
  proof declarations and focused imports; record route limits/dispositions.

### PFR-C15-S03 — Leastness and ambient singular-channel corollary

Depends on S01/S02. Prove Section 4.3, using the existing C14 attained point;
stage representable/nonperfect/inactive-output consumers in place.

- **C15-S03-A:** Data perfectness iff `IsLeast` is proved in both directions,
  with explicit membership and universal lower bound; a subunit certificate
  contradicts leastness. R02/R04/R05/R06 validate the logical distinction.
- **C15-S03-B:** The finite ambient singular-channel iff uses the actual C12
  active/compression bridge; R09 covers unused labels, injections and changed
  presentations with no prior/full-support or hidden active-output assumption.
- **C15-S03-C:** Fresh focused/downstream/default builds and signature/axiom
  audits pass. Record exact manuscript alignment and the retained C16 wrapper
  scope decision; no execution/solver or global-attainment claim appears.

### PFR-C15-S04 — Finite presentations, variable count and integrated readiness

Depends on S01-S03. Add Section 4.4's algebraic transport to Dual and finite
singular corollary to DualCharacterization, finite consumers to tests and the C15
readiness crosswalk. This step finishes all mathematics/tests.

- **C15-S04-A:** All-vector feasibility/objective transport and equality of the
  entire finite objective image hold, with inverse vector recovery and independent
  row/column equivalences, including empty columns. The finite singular corollary
  follows in DualCharacterization from S03 and Dual's image equality; existing
  counts establish exactly `m` reduced variables and the bound.
- **C15-S04-B:** R01-R10 are complete in their maintained owners, with an
  asymmetric non-involutive transpose/objective detector and explicit inactive
  labels. Private fixtures remain private; C13-only and Primal-only consumers pass.
- **C15-S04-C:** Audit the complete production API/import graph and all selected
  source/omission/advice records. Readiness maps CC01-CC08, every earlier criterion
  and regression to actual source; no required mathematical duty is left for S05.

### PFR-C15-S05 — Fresh cumulative independent validation and closeout

Depends on durable S01-S04 closure. Reassess the complete approved C15 contract;
do not relabel a prior step review as chunk completion.

- **C15-S05-A:** Freshly inspect all production proofs/private helpers, tests and
  dependencies against Sections 2-4; reassess all twelve earlier criteria,
  R01-R10 and CC01-CC08. Rehash affected manuscripts and check exact interpretations.
- **C15-S05-B:** Freshly run required builds, isolated earlier-boundary consumers,
  exhaustive named/private/anonymous signature/axiom audits and source hygiene;
  obtain the persistent reviewer's fresh cumulative assessment. At review time
  this assesses mathematical/readiness evidence, not yet-performed closure acts.
- **C15-S05-C:** Critically reconcile every original report and finding, prepare
  owning canonical documents, obtain applicable final validation and exact F,
  then use supported closure to establish CC09. A material repair needs renewed
  applicable review and repair-and-stop handling; no later chunk starts.

## 6. Regression allocation

Anonymous consumers and private/local helpers are preferred. Assertions are
staged in the listed step; an S01 test must not depend on a future declaration.

| ID | Required assertions | Owner / first step |
| --- | --- | --- |
| R01 | Generic definitions; weak-duality direction; objective nonnegativity; actual image witnesses; explicit distinction from equality/primal feasibility. | Generic Dual tests / S01; image transport S04. |
| R02 | Existing Unit datum: scalar dual constraint `y ≥ 1`, row witness at one and objectives above one; data leastness/perfectness in both directions. | Optimization incidence fixture / S01, S03. |
| R03 | Zero dual vector fails a constraint when `J` is nonempty, though primal zero is feasible; row witness always has objective one. On existing `obstructedData`, signed `y=(2,2,2,-1,-1,-1,1)` in `allPatterns` order has transpose products `(1,1,1,1,6)` and objective `-1/4`; it satisfies all partition inequalities but fails `Dual.Feasible` through coordinate nonnegativity. This guards both predicate distinctions and the dual sign condition. | Generic/Unit consumers and existing paper incidence fixture / S01. |
| R04 | Existing pair-only three-input datum has empty `J`: zero dual feasible, objective zero, nonperfectness and failure of leastness at one despite row witness objective one; finite `Fin 0` constraints are vacuous. | Optimization incidence fixture / S01-S03, finite S04. |
| R05 | Existing seven-pattern `r09Data`: row normalization one, total pattern values `7/4`; reuse its actual equality/primal witness (including a zero coefficient), all dual objectives ≥ one and attained leastness. | Paper incidence fixture / S03. |
| R06 | Existing `obstructedData` with five admissible partitions: in `allPatterns` order, `y = (1,1,1,0,0,0,1)` satisfies every dual constraint, objective `1/2 < 1`; row witness still objective one. Check the public alternative and leastness failure, not a promised global optimum. Pair it with existing primal objective `1/2` to test weak-duality equality. | Paper incidence fixture / S02-S03. |
| R07 | Correction identities on different partition block counts; negative raw separating coordinates; `b > 0`, division orientation and all corrected coordinates. On obstructed data take `q=(1,1,1,2,2,2,3)`, raw `w=(1,1,1,0,0,0,1)-q=(0,0,0,-2,-2,-2,-2)` and `c=3/4-3=-9/4`. Then `w·v=-5/2<c` and every column product is at least `-2>c`. The prescribed correction gives `t=45/4`, `b=63/2`, normalized `y=(5/14,5/14,5/14,41/63,41/63,41/63,127/126)`, objective `125/126` and transpose products `(127/126,127/126,127/126,127/126,15/14)`. External consumers check this explicit vector's feasibility/objective and the public alternative separately; local proof/audit evidence covers the actual private helpers without requiring that the alternative chooses this vector. | Private-helper evidence in DualCharacterization; generic and existing paper tests / S02. |
| R08 | Independently reindex pattern and partition coordinates with non-involutive permutations; exact transpose products/objective, inverse recovery and entire-image equality in both directions. The row permutation must cross unequal value classes: the old singleton-only cycle would not detect objective orientation. On `obstructedData` use `y=(1,2,4,8,16,32,64)`, row equivalence `(swap 0 3).trans (swap 3 6)` and existing `paperColumnCycle`: raw transpose products `(64,12,18,33,7)` and objective `239/8`; transported coordinate zero is `8` (forward error `64`), value zero is `3/8` (forward error `1/8`) and transpose coordinate zero is `33` (forward-column error `7`). | Generic/paper tests / S04. |
| R09 | Existing Option/injection ambient consumers: inactive label has zero mass and no occurring pattern; original/changed-active-presentation corollaries agree through C12. Cover representable and nonperfect ambient directions. | Optimization incidence fixture / S03-S04. |
| R10 | Reuse `card_occurringPattern`, `patterns_card_le`, `card_nonzeroPattern`; instantiate canonical finite presentations and the finite singular corollary. Check Dual-only, Primal-only, C13-only and lightweight-root import boundaries. | Generic/fixture consumers / S04-S05. |

R03/R06/R07 vectors are planning calculations to verify in the authorized step;
they are not claims that a maintained C15 fixture already compiles. Retain
existing signed-equality rejection regressions; R03 adds a distinct dual-sign guard.

## 7. Validation and completion criteria

After each coherent Lean change build the touched production/test modules and
important downstream consumers. For each milestone run `lake build`; the root
does not import optimization, so its pass alone never validates C15. The focused
suite includes Dual, DualCharacterization, their two generic test owners, both
incidence fixture owners, Primal, IncidenceConstruction and PatternCompression
consumers as relevant. Compile the isolated C13-only and Primal-only probes.

Audit exact types/assumptions/imports for every public declaration after each
step. S02 additionally audits private geometric/correction helpers; S05 freshly
inventories and kernel-audits all C15 production and test declarations, including
private helpers, anonymous examples and local instances, with transparent source
copy transformations if needed. Only the standard Lean axioms `propext`,
`Classical.choice`, `Quot.sound` are permitted; no placeholders.

Require the AGENTS placeholder scan to return no matches. Inspect final diff,
Git status, tracked/generated and ignored artifacts, document links, root/pins
and inherited edits. Attribute checks accurately; a cached build is not a clean
rebuild, a successful probe is not an approved theorem, and a source hash is
not independent acceptance. Preserve actual failed attempts and their limits.

| Completion ID | Required result |
| --- | --- |
| CC01 | Separate dual predicate/objective/actual image on the existing valid reduced data. |
| CC02 | Weak duality, objective nonnegativity and all-input row witnesses with objective one. |
| CC03 | Exact hull/equality equivalence and finite topology/separation/coordinate composition. |
| CC04 | Empty-family zero case and full nonperfect strict certificate, including all sign/scaling obligations. |
| CC05 | Data perfectness iff attained leastness at one, with the lower-bound direction essential. |
| CC06 | Ambient finite singular-channel corollary through active/compression bridges, including inactive labels. |
| CC07 | Entire finite objective image/inverse presentation transport, exact `m` variables and full-universe bound. |
| CC08 | All regressions, API/import/trust audits, source/advice/omission crosswalk and canonical documentation ready. |
| CC09 | Fresh cumulative independent validation, explicit reconciliation, applicable final checks/F and supported closure. |

## 8. Documentation, omissions and inherited advice

During implementation update the owning plan/status, C15 implementation notes,
readiness audit, living summary, map, project log and reader status as facts
change, before final source capture. Keep detailed evidence in its owner and
short links elsewhere. At draft time only planning state is added; no completed
dual coverage or resolved DG-14 is claimed.

| Existing record | C15 disposition / owner and trigger |
| --- | --- |
| DG-14; OM-039 | Specialized alternative/leastness owned by S02/S03; generic duality remains excluded. Approval selects a route; closure verifies mathematics. |
| OM-014/025/047/068 | S04 owns intrinsic-to-finite reduced presentation and exact count; no mixed encoding, duplicated count theorem or full-dual hierarchy. |
| OM-044/045/046 | Nonempty input, empty admissible family, inactive labels and attained minimum owned by S01-S03. Global optimizer/infimum claims are intentionally unnecessary. |
| OM-017/018/019/027 | General Bell enumeration/growth, solvers/runtime and public fixture promotion stay excluded or separately deferred with their existing owners; S04 reuses only finite counts and private fixtures. |
| OM-028-032 | Extended-only algorithms, hardness, coloring and information-measure applications remain excluded; C15 never enters those anchors. |
| OM-042 | Local separator/correction intermediates remain private; no public name per display or paper proof-line promise. |
| C12 idempotence advice, C12 plan §9 / OM-068 | Previously declined for C13; existing public extraction/injection bridges suffice. Preserve the decline; reopen only if an approved C15 ambient consumer is concretely blocked. |
| C11 helper-promotion advice | Public C13 necessity/construction and C14 attainment suffice; no new consumer pressure. Preserve the original owner/trigger. |
| C13 P01-P04 / GA01-GA03 | Completed attribution/construction/fixture dispositions stand. Extra numerical fixture remains declined; reuse existing R09/R14 data in place. |
| C14 P01/GA01, P02/GA02, P03-P05 | Signed guard, whole-image inverse transport, shared private slack proof, staged fixtures and isolated C13 consumer are completed. Extra two-fixture permutation recipe remains declined; S04 needs one new dual-specific transpose detector for its new contract. |

No numbered Future Work Notes exist. No new unowned deferral is introduced by
the draft. If new advice is worthwhile but outside the approved contract, route
it to an existing map/plan owner with original reference and revisit trigger,
or open a stable-numbered note; never defer a correctness/acceptance obligation.
The intentional omissions above are recorded against existing map IDs, without
renumbering, deleting historical rationale or pretending the draft approves them.

Revision 2 adopts the parent's signed-dual guard (R03/S01), the shared parent/General
Assistant R07 validation clarification (S02), explicit finite-corollary ownership
from the General Assistant (S04), and the parent's alternate-interface clarification
(Section 4.2). [Advice dispositions](../pfr-c15-planning-notes.md#revision-2-advisory-dispositions)
retain their origins and rationale. No suggestion is left as an unowned deferral;
the route, five steps, theorem contracts, manuscript scope and draft status remain.

## 9. Revision and review policy

This revision is proposed for later explicit plan review and exact-plan approval.
Only the installed neutral source-bound procedure may dispatch to the persistent
reviewer after authorization; planning helpers are not independent reviewers.
Preserve requested/effective setting distinctions and every original record.

After approval, routine proof/naming/import improvements may be made within an
authorized step with reasons and appropriate plan/notes updates. Changes to
mathematical strength, hypotheses, scope, acceptance, or a material execution
contract require a lead decision. Do not silently weaken the alternative,
replace leastness by witness existence, promote a fallback to verified, or
begin the next step. Preserve the reviewed normative plan; reserve the marked
editorial status region only for status and chronology.

The main acceptance decision is whether to approve this specialized separation
route and five-step scope after the separately requested plan review. No further
mathematical-intent choice or mandatory chunk split is currently identified;
S02 remains the principal technical risk, with the escalation boundary above.
