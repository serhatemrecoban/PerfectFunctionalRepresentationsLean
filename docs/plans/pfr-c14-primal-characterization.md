# PFR-C14 — Primal Characterization

<!-- pfr-review-status:start -->
**Status:** Approved revision 2 — cumulative validation and independent review
passed, 2026-10-01. Completion is subject to the durable S04 closure record.
**Authority:** The lead approved revision 2 and separately requested S01, S02,
S03 and S04 with review. Each conditional request was accepted only after the
previous step's durable closure and exact source applicability were verified.
S04 startup verified all three closures, nine satisfied criteria, all original
report reconciliations and all 159 final source/environment entries.
**S01 closure:** `fbe7d3338e15b9ed59032aea880ae7eb5c1ca8254e6910555a97f96860c166f3`.
**S02 closure:** `03ef05bae58f8254cb1d5ec32195db153be9a1b77c7ca3caea2ed4050ca44564`.
**S03 closure:** `71de940fb9b67cd410f6b03639f8910ce891d986152cdf573cbc9d6a6c3fe495`.
**S04 checkpoint:** Fresh source/manuscript/build/trust assessment covers all
nine earlier criteria, R01-R10 and CC01-CC07. All three S04 criteria satisfy
the fresh validation and independent review without findings. The complete original report is critically reconciled.
This is the pre-F readiness checkpoint: final applicability, F and supported
closure establish CC08/C14 completion in the durable review record. C15 remains
unstarted.
**Reviewer:** `/root/pfr_c14_reviewer`, originating task
`01a0f3d9-7dad-7190-8587-fd641698aa29`; requested Astra/ultra/no parent history,
effective settings unknown. No independent plan review is claimed.
[Implementation notes](../pfr-c14-implementation-notes.md) retain exact evidence;
[planning notes](../pfr-c14-planning-notes.md) preserve original approval/advice.
<!-- pfr-review-status:end -->

## 1. Baseline, scope and proposed gate decision

HEAD is `54c1714d1a9a891939d6c9f7d38c0d05896b2c75`. Preserve the substantial
inherited tracked and untracked work and all private `.pfr-review` records.
C13 S06 closure is
`b722301a08704288a781de37208dc02ee9837a3070c7f6ca592eedd43e76abdf`, with final
source F `b6d6e42e131670c47c588463375166d785e9c8ae56729359881181afca3fab09`.
The supported closure, rather than the older pre-F wording, establishes C13
completion. C14 initialization does not reopen it.

LeanInfoTheory stays at immutable `v0.1.0`, commit
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`; Lean is `v4.33.1`, mathlib is
`0df444a360eaa60ab8c11dca51a86af692955474`. Installed dependencies are clean and
match the manifest. No upgrade, workflow change, commit, push or website work
is part of this plan.

**Proposed DG-13 resolution:** On C12 valid compressed data with nonempty finite
input, use C13's reduced pattern/admissible-partition system. Prove the
inequality bound, exact saturation, objective-one attainment characterization,
and perfect representability iff `IsGreatest` of the feasible objective-value
set at one. Lift this to finite ambient singular channels through the established
active restriction/compression bridge. DG-13 remains open pending exact-plan
approval; its mathematical obligations are not satisfied by approving a design.

A convenience theorem combining a nonsingular branch and the singular primal
branch remains a **C16 scope decision**, not an implementation obligation here.
C14 already covers arbitrary finite ambient output alphabets, including inactive
labels, under an explicit singularity hypothesis. There is no input prior.

Excluded: dual feasibility, weak duality, separation, nonnegative separator
correction, scaling, dual leastness and all other C15 obligations; a generic LP
framework; algorithms/solvers or complexity claims; unconditional optimizer
existence for every datum; supremum notation; a separate full-coordinate primal
theorem family. None is necessary for attained greatestness at one. The existing
full/reduced equality results remain available without being silently extended
to inequality feasibility or objectives.

## 2. Authenticated manuscript anchors

Both local binaries were freshly hashed, relevant text extracted and complete
relevant pages rendered for visual checking. No manuscript is reproduced in
maintained files or private review records. Neighboring material visible on the
same pages is outside these anchors.

| Source | Version identity | Consulted C14 passages |
| --- | --- | --- |
| Six-page ISIT final, filename ending `final_manuscript_ (3).pdf` | SHA-256 `48963aa59485b2c33b1a1e6e7c6ead2251fdddd26bd3691b6fcffe683e6ed1c4` | PDF p.5, upper left: Theorem 2, (18), equality-feasibility lead-in and singularity-check paragraph. |
| Eighteen-page extended version 16, designated 2026-09-03 | SHA-256 `98636d4c9f0618ec08fca84559572780f604f197fda90d8d7c787b3624245b8f` | p.7, left: Theorem 2/(64) and its immediate setup; Appendix B p.16 right, proof of Theorem 2/(203)-(212); p.17 left, (213)-(221), stopping before Appendix C. |

The ISIT display inherits the repaired incidence interpretation of C13/DG-12:
use occurring patterns **and admissible partitions**, rather than occurring rows
with all Bell-partition columns. Extended v16 supplies the detailed argument.

| Anchor | Logical content and planned owner |
| --- | --- |
| (203)-(204) | Reuse C13 nonnegative equality feasibility/perfectness and reduced incidence; no second construction proof. |
| (205); ISIT (18); extended (64) | S02/S03 give explicit attainment and `IsGreatest` iff statements. |
| (206)-(208), (210)-(211) | Reuse C13 input incidence, `P H` rectangular all-ones and `P v = 1`; derive the arbitrary-coefficient `P(Hx)` identity locally. |
| (209), (212)-(214) | S01 uses nonnegative input incidence and slack, preferably through the shared private identity in Section 4.2, then evaluates at an input to bound the objective. |
| (215)-(216) | Equality gives sum one through C13; together with the bound this proves attained greatestness. |
| (217)-(219) | Greatestness includes a feasible attaining vector; saturation makes every input-row slack sum zero. |
| (220)-(221) and intervening kernel prose | S02 eliminates every slack coordinate using a containing input in each nonempty pattern, then recovers equality. |

The printed optimal vector in the converse is supplied by membership in the
objective-value set, not by an unproved assertion that a supremum is attained.
No public declaration per displayed proof line is required (OM-042/046).
Reauthenticate the affected contract if the designated extended draft changes.

## 3. Ownership and verified dependency reuse

Production owner: `PerfectFunctionalRepresentations/Optimization/Primal.lean`,
namespace `PerfectFunctionalRepresentations.Primal`. Start from the focused
local `Optimization.IncidenceConstruction` import, which supplies C13's equality
characterization and incidence dependencies. Add only justified focused mathlib
imports if the actual proof requires them. Do not add optimization imports to
`PerfectFunctionalRepresentations.lean` or create a generic LP abstraction.

Generic tests: `Tests/Optimization/Primal.lean`. Reuse C13 private fixtures by
adding primal consumers beside them in `Tests/Optimization/Incidence.lean`
(singleton, empty family and ambient consumers) and `Tests/Examples/Incidence.lean`
(concrete paper vectors), with a Primal import. This changes test consumers, not
production dependency direction or fixture visibility. No C13 private name is
imported elsewhere.
Use private/local algebra and slack helpers unless a real downstream consumer
justifies a public interface.

Once these test modules import Primal, their builds also depend on C14. S03 and
S04 therefore compile a small disposable consumer importing only the production
`Optimization.IncidenceConstruction` module. It applies C13's structural
identities and equality characterization without a Primal import. This checks
the retained C13 boundary without a fixture refactor or new maintained module.

Source inspection and compiling probes distinguish these existing APIs from
the proposed names in Section 4:

| Existing API | Role / restriction |
| --- | --- |
| `CompressedPatternData`, `.value_pos`, `.row_sum`, `.channel` | Positive values on distinct nonempty patterns, normalized per input. No feasibility or perfectness premise. |
| `Incidence.OccurringPattern`, `.AdmissiblePartition`, `.reducedMatrix`, `.inputMatrix` | Intrinsic finite coordinates; admissible partitions may be empty. |
| `Incidence.inputMatrix_mulVec_value`, `.inputMatrix_mul_reducedMatrix`, `.inputMatrix_nonneg` | `P v = 1`, `P H =` rectangular all-ones, order-preserving multiplication by `P`. |
| `Incidence.sum_eq_one_of_reduced_eq` | Requires `H x = v`. Use only after equality is given or proved; it is not an inequality-feasibility lemma. |
| `Incidence.Feasible`, `.isPerfectlyRepresentableChannel_iff_exists_feasible` | Existing nonnegative **equality** feasibility and data-channel iff, unchanged. |
| `Incidence.isPerfectlyRepresentableChannel_iff_feasible_compressedPatternData` | Finite ambient singular-channel equality characterization through C12. |
| `isPerfectlyRepresentableChannel_iff_compressedPatternData` | Underlying active restriction/compression/perfectness bridge; no prior or full-support assumption. |
| `Incidence.reindex_mulVec`, `Equiv.sum_comp` | Supplied finite presentations transport multiplication and preserve the coefficient sum. C13's `system_reindex_iff` itself concerns equality. |
| `Matrix.mulVec_mulVec`, `Matrix.mulVec_sub`, `Finset.sum_le_sum`, `Finset.single_le_sum`, `IsGreatest`, `Set.mem_image` | Finite algebra, order, nonnegative summand control and explicit attained greatestness. |

Pinned LeanInfoTheory source, API documentation, declaration index, theorem
highlights and module guide were searched along with mathlib. No new generic
information-theory theorem is needed: C13/C12 own the semantic bridge. Probes
test algebra/order interfaces, not maintained C14 coverage. Exact verified
signatures, failures/corrections and limits belong in the planning notes.

## 4. Mathematical and public interface contracts

All names introduced below are **proposed**, not existing declarations. Routine
naming may improve during an authorized step without altering the contracts.

### 4.1 Domain and definitions

Let `{α : Type u} [Fintype α] [Nonempty α]` and `D : CompressedPatternData α`.
Write `O := Incidence.OccurringPattern D`,
`J := Incidence.AdmissiblePartition D`, `H := Incidence.reducedMatrix D`,
`P := Incidence.inputMatrix D` and `v := D.value`.
For `x : J → ℝ`, propose:

```text
Primal.Feasible D x := (∀ j, 0 ≤ x j) ∧ (∀ p, (H *ᵥ x) p ≤ v p)
Primal.objective D x := ∑ j, x j
Primal.feasibleSet D := {x | Primal.Feasible D x}
Primal.objectiveValues D := Primal.objective D '' Primal.feasibleSet D
```

`Primal.Feasible` is distinct from `Incidence.Feasible`; qualify both at their
boundary. No global notation makes them ambiguous. Zero belongs to the primal
feasible set and has objective zero even if equality feasibility fails or `J`
is empty. Values sum to one only on patterns containing each input, not over O.
No `[Nonempty J]`, decidable perfectness or LP optimizer is assumed.

### 4.2 Feasible objectives and exact saturation

Public contracts:

```text
feasible_zero : Primal.Feasible D (fun _ => 0)
objective_zero : Primal.objective D (fun _ => 0) = 0
objective_nonneg (hx : Primal.Feasible D x) : 0 ≤ Primal.objective D x
objective_le_one (hx : Primal.Feasible D x) : Primal.objective D x ≤ 1
objective_eq_one_iff (hx : Primal.Feasible D x) :
  Primal.objective D x = 1 ↔ H *ᵥ x = v
equality_feasible_iff :
  Incidence.Feasible D x ↔ Primal.Feasible D x ∧ Primal.objective D x = 1
```

The lower bound follows from coefficient nonnegativity. Prefer one shared
private identity for the upper bound and saturation:

```text
P *ᵥ (v - H *ᵥ x) = (fun _ => 1 - Primal.objective D x)
```

It holds for **arbitrary real coefficients**, using C13's `P v = 1`, `P H`
and matrix associativity/subtraction. No feasibility premise or public helper
is needed. For feasible x, set `s := v - Hx`. Both s and P are nonnegative,
so evaluating `P s ≥ 0` at any input gives the objective bound. Nonempty input
is indispensable. An equivalent direct inequality proof is acceptable if the
implementation gives a reason to prefer it; the public contracts stay fixed.

For saturation, objective one gives `P s = 0` at **every** input. For each
`p : O`, choose `i ∈ p` using its nonempty-pattern witness. The nonnegative
summand `s p`, with coefficient
`P i p = 1`, is bounded by the zero sum in row i. Thus `s p = 0`. Function
extensionality gives `Hx = v`. Looking only at one fixed row would not eliminate
patterns missing that row. This is a nonnegative-kernel argument; it does not
assert that P has trivial kernel on arbitrary signed vectors.

The reverse implication uses C13 equality normalization. Equality feasibility
retains exactly the same coefficient vector, including zero coordinates.

### 4.3 Data-level characterization and attained greatestness

Public contracts:

```text
isPerfectlyRepresentableChannel_iff_exists_objective_eq_one :
  IsPerfectlyRepresentableChannel D.channel ↔
    ∃ x, Primal.Feasible D x ∧ Primal.objective D x = 1
isPerfectlyRepresentableChannel_iff_isGreatest :
  IsPerfectlyRepresentableChannel D.channel ↔
    IsGreatest (Primal.objectiveValues D) 1
```

Use `Incidence.isPerfectlyRepresentableChannel_iff_exists_feasible` and the
same-vector bridge. `IsGreatest S 1` means both `1 ∈ S` and that every member
of S is at most one. The bound alone holds even for nonperfect data, so it
cannot imply perfectness. Empty `J` has objective-value set `{0}` and fails
greatestness at one. A separate theorem exposing global optimizer attainment,
or any `sSup` claim, is unnecessary and excluded.

### 4.4 Ambient singular channels and supplied finite presentations

With `{β : Type v} [Finite β]`, `κ : α → PMF β` and
`hκ : IsSingularChannel κ`, propose both wrapper conclusions:

```text
IsPerfectlyRepresentableChannel κ ↔
  ∃ x, Primal.Feasible (compressedPatternData κ hκ) x ∧
    Primal.objective (compressedPatternData κ hκ) x = 1
IsPerfectlyRepresentableChannel κ ↔
  IsGreatest (Primal.objectiveValues (compressedPatternData κ hκ)) 1
```

Compose existing C12/C13 bridges; do not reconstruct probability conversions,
postulate full support, or delete inactive outputs without their proved bridge.
An `ActiveFiniteChannel` consumer is a specialization of this wrapper; add no
duplicate public wrapper solely for a name.

For supplied `rows : O ≃ Fin m`, `cols : J ≃ Fin n`, set
`H' := Matrix.reindex rows cols H`, `v' := v ∘ rows.symm`,
and `x' := x ∘ cols.symm`. Provide the paper-boundary bridge:

1. `Primal.Feasible D x ↔ ((∀ j, 0 ≤ x' j) ∧ H' *ᵥ x' ≤ v')`, with
   vector order explicitly pointwise.
2. `∑ j, x' j = Primal.objective D x`.
3. The entire objective-value image in these finite coordinates equals
   `Primal.objectiveValues D`:

```text
(fun z : Fin n → ℝ => ∑ j, z j) ''
  {z | (∀ j, 0 ≤ z j) ∧ ∀ i, (H' *ᵥ z) i ≤ v' i}
  = Primal.objectiveValues D
```

Hence its `IsGreatest ... 1` statement is equivalent. For an arbitrary finite
vector z, the inverse map is `x := z ∘ cols`; show that transporting x forward
recovers z and preserves its objective. The reverse direction uses
`x' := x ∘ cols.symm`.

Use two small named public presentation lemmas (feasibility and objective-value
set equality); sum preservation may remain local. All coordinate vectors are
covered by the inverse equivalence, not just the forward image of one witness.
No second LP definition hierarchy or canonical enumeration is introduced.
These contracts include `n = 0`; arbitrary independent enumerations are allowed.

## 5. Proposed steps and acceptance criteria

Four steps follow the proof dependencies. S01 isolates the inequality interface;
S02 uses it for the one new saturation argument and the data theorem; S03
finishes the existing-channel and coordinate boundaries plus integrated tests.
No mathematical target is deferred to the separate S04 cumulative validation.
Approval of this plan does not start any step. Each later eligible prompt
authorizes one step, its installed review process when requested, and a stop.

### PFR-C14-S01 — Inequality feasibility and the universal bound

**Prerequisite:** C13 closure/source applicability checked at execution startup.
Implement Section 4.1 and the zero, nonnegative and upper-bound contracts of
Section 4.2 in Primal, with generic/initial boundary tests.

- **C14-S01-A:** The separate primal predicate and objective/image definitions
  have exactly the stated hypotheses; `Incidence.Feasible` is unchanged. Zero
  feasibility and objective zero are proved for every valid datum, including
  an empty admissible index.
- **C14-S01-B:** Every feasible objective lies in `[0,1]`. The proof reuses C13's
  row identities without assuming equality, perfectness, total-pattern-value
  normalization or nonempty admissible partitions.
- **C14-S01-C:** Generic, singleton and empty-index consumers compile; public
  signatures/imports and proof integrity are audited. R01-R04 have their S01
  assertions, and documentation records the implemented boundary accurately.

**Validation/stop:** Build Primal, its tests, touched concrete tests and important
C13/C12 consumers, then the default target. Preserve commands/results and
placeholder/public-axiom audits. Stop before the saturation step.

### PFR-C14-S02 — Saturation and the data-level primal theorem

**Prerequisite:** S01 durably closed. Implement the remaining Section 4.2 and
Section 4.3 contracts, reusing the exact C13 equality witness.

- **C14-S02-A:** Under primal feasibility, objective one iff `H x = v` is proved
  by eliminating every slack coordinate. The equality-feasibility bridge keeps
  the same vector and its zero coefficients; no signed-kernel claim is used.
- **C14-S02-B:** Perfectness of `D.channel` iff feasible objective-one attainment
  and iff `IsGreatest (objectiveValues D) 1` are proved. Membership supplies the
  attaining vector; no supremum or general optimizer theorem is assumed.
- **C14-S02-C:** R02-R07 exercise saturation, zero versus equality feasibility,
  empty and nonempty nonperfect families, row-wise normalization and a
  representable vector with a zero coefficient. R06 also rejects the signed
  equality solution despite its objective being one. Audit exact public assumptions,
  reused equality normalization and manuscript (215)-(221) coverage.

**Validation/stop:** Build all current Primal/test owners and actual C13
characterization consumers, then default build and trust/import checks. Update
implementation evidence and map coverage. Stop before channel/presentation work.

### PFR-C14-S03 — Channel and coordinate boundaries; integrated readiness

**Prerequisite:** S02 durably closed. Implement Section 4.4 and finish every
required regression and the source/manuscript/criterion crosswalk.

- **C14-S03-A:** Both finite ambient singular-channel wrappers follow through
  existing active restriction/compression. Inactive outputs, changed active
  presentations and injective output relabeling are exercised without a prior
  or an unsupported data assignment to zero columns.
- **C14-S03-B:** Supplied finite row/partition presentations preserve inequality
  feasibility and the entire objective-value set, including empty columns.
  Independent non-involutive permutations test inverse orientation.
- **C14-S03-C:** R01-R10 and CC01-CC07 are complete. Readiness and implementation
  notes map every anchor, public/private owner, regression, omission and advice
  disposition. Audit C15's intended consumption without implementing duality.

**Validation/stop:** Build all production/test owners and important C12/C13
consumers; default build; public signature/axiom and import audits; strict
placeholder scan and the C13-only import consumer from Section 3. No missing
mathematics is reserved for closeout. Stop.

### PFR-C14-S04 — Fresh cumulative independent validation and closeout

**Prerequisite:** S01-S03 durably closed with all original reports reconciled.
This is a fresh assessment of the complete approved contract, not a collection
of prior favorable reports or another theorem-development phase.

- **C14-S04-A:** Fresh source, manuscript, build and trust assessment covers all
  nine earlier criteria, R01-R10 and CC01-CC07. Audit every new named declaration,
  private helper and anonymous test, actual imports and the unchanged pins;
  rerun the C13-only import consumer from Section 3.
- **C14-S04-B:** The same bound reviewer independently reassesses the complete
  actual implementation and cumulative contract. Retain every original report
  and critically reconcile findings and criterion assessments. Earlier reviews
  cannot replace this pass.
- **C14-S04-C:** Complete applicable final validation, owning documentation,
  source F and supported durable closure. Review-time readiness is assessed
  before later receipt/reconciliation/F/closure; these later acts remain
  acceptance duties and are not certified in advance by the review.

**Repair/stop:** Investigate correctness/acceptance gaps. Bounded repairs require
fresh affected validation and review under the installed protocol; substantive
contract changes require the lead. Only supported closure completes CC08/C14.
Stop; C15 does not start.

## 6. Required regressions

Assertions are staged with their implementing step and freshly reassessed in
S04. Concrete fixtures stay private. Do not duplicate the C13 paper-matrix
enumeration or promote it solely to reuse a test.

| ID | Contract | Due |
| --- | --- | --- |
| R01 | Generic `D` needs only finite nonempty input and valid compressed data. No perfectness/equality-feasibility or `Nonempty J` is assumed. Definitions and bound elaborate under those hypotheses. | S01 |
| R02 | Singleton input: one pattern of value one and one admissible partition. Weights zero, `1/2` and one are primal feasible with those objectives. Weight one saturates and gives attained greatestness. | S01: feasibility and objective calculations. S02: saturation and characterization consumers. |
| R03 | Zero is primal feasible for every D and has objective zero; it is not equality feasible for valid D. This remains true for nonperfect data. | S01: all three elementary facts, using existing C13 normalization for rejection. S02: consume the saturation/equality bridge on zero. |
| R04 | Empty admissible family: every objective is zero, `objectiveValues D = {0}`, greatestness at zero holds and at one fails. Instantiate with C13/C03 pair-only three-input data; do not synthesize `Nonempty J`. | S01: all elementary objective/set/greatestness facts and no objective-one witness. S02: consume the new characterization to recover nonperfectness. |
| R05 | All seven patterns with value `1/4` have total pattern value `7/4`, yet row sums one. C13's vector `(1/4,1/4,1/4,1/4,0)` is primal feasible, attains one and recovers equality, with its zero coordinate preserved. | S02 |
| R06 | C13 R14: all seven patterns occur, singleton/whole values `1/8`, pair values `3/8`; all five partitions are admissible, but nonnegative equality feasibility fails. The primal is nonempty and cannot attain one or have greatestness at one. Check the explicit slack vector `(1/8,1/8,1/8,1/8,0)` is feasible with objective `1/2`. Also check `(1/8,3/8,3/8,3/8,-1/4)` satisfies `Hx = v` and has objective one, yet fails `Primal.Feasible` because its last coefficient is negative. An exact global optimum below one is not required. | S02 |
| R07 | All-coordinate slack guard: on two inputs with singleton patterns each of value one, slack supported only on the second pattern has zero input-incidence sum at the first input but is nonzero. Check all-row elimination and the saturation theorem on valid data; no proof may infer all-coordinate equality from that one row. | S02 |
| R08 | Ambient singular channel with an unused output: wrapper agrees with its active/compressed channel; the unused coordinate remains zero. Reuse C12/C13 injection and changed-active-presentation consumers. | S03 |
| R09 | Independent row and partition enumerations, including non-involutive permutations, preserve primal feasibility, objective values and greatestness; empty columns also transport. On R05 data use `x = (1,2,3,4,5)/40`, with `Hx = (9,8,7,2,3,4,1)/40` and objective `3/8`. Reuse C13's asymmetric cycles and check transported coefficient and product coordinates as described below, as well as feasibility and the objective. | S03 |
| R10 | A representable and a genuinely nonperfect channel consume the final ambient `IsGreatest` iff. The finite-coordinate objective-value-set theorem is used in both directions, not merely checked by name. | S03 |

R05/R06/R09 vectors use C13's paper column order `{111}`, `{110,001}`, `{101,010}`,
`{011,100}`, `{100,010,001}`. For R09, `paperRowCycle.symm 0 = 1` and
`paperColumnCycle.symm 0 = 3`. Thus the transported coefficient at zero is
`4/40` and the product at zero is `8/40`; the incorrect forward orientations
would instead give `5/40` and `7/40`. The objective alone cannot detect a
permutation-direction error. The displayed product is strictly below the
constant value `1/4`, so this vector is primal feasible. R05 already retains
the separate zero-coefficient saturation test.

R07 is a guard on proof logic, not a false example
of a primal-feasible objective-one vector with slack. Empty input is excluded
by the data boundary; no arbitrary fallback input is invented.

## 7. Validation and completion

Each coherent Lean change builds its touched module and actual downstream
consumers. Milestones also run `lake build`; the lightweight default root does
not replace focused optimization/test builds. Expected targets are Primal,
Tests.Optimization.Primal, Tests.Examples.Incidence, Tests.Optimization.Incidence,
IncidenceConstruction and Tests.Matrix.PatternCompression. Adjust the command
list to actual imports and edits, recording why.

Require the AGENTS placeholder scan to return no matches. Inspect public
signatures and axiom dependencies, finite/nonempty assumptions, proof-local
classical choices, vector orientation and the equality/inequality distinction.
Final cumulative audit includes private and anonymous declarations; document
the actual inventory and limits. Compare against the step's actual baseline,
not merely HEAD. Inspect final diff/status, tracked generated files, ignored
references and scratch; preserve inherited work and private review state.

| ID | Completion outcome |
| --- | --- |
| CC01 | Distinct reduced primal feasibility, objective and image definitions preserve the C12/C13 domain and equality API. |
| CC02 | Zero feasibility and every feasible objective's `[0,1]` bound are proved, including empty J. |
| CC03 | Objective-one saturation and the same-vector equality-feasibility bridge are proved with all slack coordinates eliminated. |
| CC04 | Data perfectness iff attainment and iff attained greatestness at one are proved through C13. |
| CC05 | Finite ambient singular-channel and arbitrary finite-presentation boundaries are proved, with inactive labels handled through C12. |
| CC06 | R01-R10 and public/import/trust audits pass; no required mathematical assertion is deferred to closeout. |
| CC07 | Source/anchor crosswalk, omissions, advice dispositions and C15 handoff are current; excluded scope remains excluded. |
| CC08 | Fresh cumulative independent assessment, original-report reconciliation, applicable final checks, documents, F and supported durable closure complete C14. |

Implementation notes will own dated commands/evidence; the readiness audit will
own the completed source/criterion crosswalk. The log owns decisions/history;
the living summary owns normalized status/risks; the map owns DG-13 and omission
dispositions. README/scope/roadmap receive concise changes when status changes.
Prepare owning documentation before F; never claim future review or closure.

## 8. Omissions, deferrals and inherited advice

No numbered Future Work Notes exist at startup. These records retain their
original dispositions; this draft proposes handling, not execution authority.

| Record | C14 handling, owner and revisit trigger |
| --- | --- |
| DG-13; OM-044 | Propose explicit nonempty input and valid reduced data in S01-S03. Empty input remains excluded; no total-pattern normalization is added. |
| DG-10/DG-11/DG-12; OM-014/025/047/068 | Reuse C12 data and C13 indices/equality bridges; S03 owns only the primal finite-presentation bridge. No mixed incidence encoding or new full-coordinate LP hierarchy. C15 retains reduced-dual variable wording. |
| OM-042/046 | S01-S03 check all logical content of (203)-(221) through existing identities, private slack algebra and public final statements. No public name per display, unsupported supremum or global optimizer theorem. Revisit broader attainment only for a demonstrated later approved consumer. |
| OM-018/019; C16 boundary | No solver or runtime theorem. C16 planning may assess a nonsingular/singular convenience wrapper; this is not a promise or authorization to add one. The existing necessity-of-singularity theorem already supplies the nonsingular logical rejection. |
| OM-017/027; DG-15 | Reuse private concrete fixtures and existing finite counts. General Bell enumeration/growth and publication curation remain with their existing owners/triggers. |
| DG-14; C15 | Preserve weak duality, separator correction/scaling, leastness and empty-partition dual obligations. S03 documents the primal interface needed by C15; it does not implement them. |
| C12 plan §9; C13 planning notes, S05/S06 advice reassessments | The optional compression-idempotence alias was declined for C13 after consumer checks. C14's existing ambient bridge suffices; do not revive it without fresh concrete consumer evidence. |
| C11 private-helper advice; C13 plan §8 and planning notes | C14 consumes public C13 characterization theorems, so private C11 helper promotion remains unnecessary. Revisit only on an actual blocked public consumer. |
| C13 revision-2 P01-P04 / GA01-GA03 | Preserve their completed dispositions. R05/R06 reuse the discriminating fixtures; no declined extra fixture or public constructor redesign is revived. |
| OM-028-032/039 and roadmap | Extended-only algorithms, hardness, information-measure applications and a general LP library remain excluded. No new external formalization source is consulted. |

The map's existing omission entries record these C14 interpretations at planning
time. New worthwhile advice must receive an existing owner/trigger or an immutable
numbered Future Work Note. Correctness and acceptance gaps cannot be deferred as
optional advice.

### Revision-2 suggestion decisions

The lead requested a selective update after the parent's five suggestions and
the user-supplied General Assistant advisory. The preserved originals and full
P01-P05/GA01-GA02 dispositions are in the [planning notes](../pfr-c14-planning-notes.md#revision-2-advisory-decisions--2026-10-01).
This revision adopts the R06 signed control, the exact all-vector image equality,
the private shared slack route, explicit R02-R04 staging and a small C13-only
import check. It uses GA02's single scaled asymmetric fixture for R09 in place
of the parent's more elaborate two-fixture/zero-coordinate recipe: one existing
fixture distinguishes both inverse directions, and R05 covers a zero coefficient.
No additional step, public helper or deferred obligation is introduced.

## 9. Revision and review policy

Exact-plan approval and a later step request are separate. A separately requested
plan review uses this chat's same persistent reviewer and a source-bound plan
session; its result does not approve implementation. No such session is opened
by this draft. Requested versus observable settings remain distinct.

During an authorized step, improve proof routes, private organization and tests
when evidence warrants it; record reasons, assess plan health and review the
actual resulting work. Preserve reviewed originals. Changes to mathematical
intent, scope, assumptions or acceptance need the lead. The marked status block
is editorial only; it cannot alter requirements or automatically start a step.

Suggested criteria for a later explicitly requested plan review:

- **C14-PR01:** Baseline, source applicability, manuscript identity and scope are
  accurate; planning is not represented as approved implementation.
- **C14-PR02:** Precise feasibility, saturation and greatestness contracts preserve
  intended Theorem 2, row normalization and empty-index/nonempty-input boundaries.
- **C14-PR03:** Existing APIs and bounded probe evidence support a credible proof
  route without unverified semantic infrastructure or a hidden optimizer premise.
- **C14-PR04:** Module ownership, singular/presentation wrappers, regressions and
  step dependencies cover the required outcomes with concrete acceptance criteria.
- **C14-PR05:** Validation, cumulative independent closeout, document routing,
  omissions/advice handling and revision/stop rules are complete and feasible.

Stop after delivering this proposed plan. Implementation awaits lead approval
of the exact revision and subsequent authorization of one step.
