# PFR-C11 - Theorem 1 canonical-coupling construction

**Revision:** 2, 2026-09-29
<!-- pfr-review-status:start -->
**Status:** Active; S01-S05 durably complete, S06 cumulative review reconciled and finalizing  
**Owner:** C11 planning and implementation task  
**Authority:** The lead endorsed revision 2 on 2026-09-29 and confirmed that
implementation judgment may improve the plan as evidence warrants. The conditional
S06 request was accepted after verifying S05 durable closure, all five original
reports/reconciliations, fifteen satisfied criteria and all 139 final entries.
Only S06 is authorized by this message.

S06 freshly reassesses the complete construction, all fifteen earlier criteria,
R01-R16 and CC01-CC08 readiness against the exact source and manuscripts, with
required focused/default builds and an exhaustive trust audit, all passing. The
persistent reviewer satisfies all three S06 criteria without findings; the full
original cumulative report is critically reconciled. Final applicability checks,
F and durable closure follow this maintained checkpoint.
Only durable S06 closure completes C11. C12 remains unstarted. Earlier plan and
step reports remain preserved; no separate revision-2 plan review is claimed.
See [implementation notes](../pfr-c11-implementation-notes.md) and the
[readiness audit](../pfr-c11-readiness-audit.md) for evidence and boundaries.
[Planning notes](../pfr-c11-planning-notes.md#revision-2-selection-and-dispositions)
retain original advice and selection decisions. Drafting history below retains
its pre-approval context.
<!-- pfr-review-status:end -->

## 1. Baseline and execution boundary

The baseline is the inherited working tree at HEAD
`54c1714d1a9a891939d6c9f7d38c0d05896b2c75`, including completed uncommitted
C01-C10 work. HEAD alone does not describe the implemented prerequisites.
The pre-edit inventory records 126 ordinary project files; C10's final source
also includes its explicit dependency scope and derived environment, for 141
entries. All 141 matched before these planning/status edits. Preserve inherited
changes and private `.pfr-review/` records.

C10 S07 durably closed under
`e96f139f27bb4780148674a1730a1a9dd73ba597d5b3c64cd22b9db3621f2cae`.
Its seven original reports are reconciled, all 21 closing criteria satisfied,
and its sole optional stale-status finding resolved. Original C10 plan/notes
intentionally retain their pre-F checkpoint. Their later closure establishes
completion; this proposal does not reopen them.

Prerequisites and ownership:

- C02: intrinsic, prior-free common posterior, canonical coupling and fixed
  perfectness, with explicit support-prior transport.
- C03/C06: perfect implies singular, active-output restriction, exact finite
  presentation and reconstruction, admitted values and support-finset patterns.
- C07-C09: legal operations, remembered recoveries, directed output comparison,
  paths/composition, all-ones seed and local preservation/reflection.
- C10: restricted reachability and easy implications; exact labelled partitions;
  finite PPS/VPS/PPM synthesis, including ENNReal positive-support adapters.

Pinned dependencies remain LeanInfoTheory `v0.1.0` at
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`, mathlib `v4.33.1` at
`0df444a360eaa60ab8c11dca51a86af692955474`, and Lean `v4.33.1`.
All ten installed packages were inspected as clean and matching the manifest.
No dependency, workflow, commit or push change is in this plan.

Approval of this exact plan would establish the execution contract. Each later
eligible implementation request authorizes one fixed step only. A plan-review
request authorizes review of the proposal, not implementation.

## 2. Exact sources and interpretation

The parent rehashed the designated local binaries and inspected the relevant
pages. Local paths and evidence are in the planning notes; papers, extracts
and renders remain external or ignored.

| Source | Identity and anchors |
| --- | --- |
| Six-page ISIT final manuscript | SHA-256 `48963aa59485b2c33b1a1e6e7c6ead2251fdddd26bd3691b6fcffe683e6ed1c4`. Theorem 1, III-B, PDF p.4 left; Appendix proof on p.5, Equations (20)-(28), following construction paragraph and Figure 1. |
| Designated extended version 16, eighteen pages, designated 2026-09-03 | SHA-256 `98636d4c9f0618ec08fca84559572780f604f197fda90d8d7c787b3624245b8f`. III-B Theorem 1 proof, p.4, Equations (16)-(24), following weighted-partition construction; Figure 1, p.5 upper left. |
| Relevant extended Appendix B prerequisites | Lemma 5, (175)-(202), pp.15-16, and Lemma 6 proof on p.16: fixed canonical vector/posterior and witnessed inverses. Reuse completed C09/C10 results; no second preservation proof. Theorem 2 (203)-(221) belongs to C14. |

Printed: a singular conditional matrix is perfectly representable iff it can
be reduced to `1_k` using PPM/PPS/VPM. Its proof takes `Y'=(Y,W)`, assumes
positive `pW`, splits each output by its common posterior, and partitions each
supported vector's all-ones pattern by decoder fibers.

Intended and proposed Lean reading:

1. The intrinsic channel predicate supplies one `q` and one `V` valid for
   **every input row**. No input prior is introduced to obtain this witness.
2. Replace the positive-auxiliary WLOG with an explicit law on `q.support`
   and an inclusion-map equality. Nonempty decoder fibers further restrict
   `Y × support(W)`: the ambient product usually contains zero columns.
3. The conditional formulas in (20)-(21)/(16)-(17) mean law factorization and
   equality on supported conditioning fibers. A selected deterministic channel
   may be total, but the pinned null conditional completion is not asserted
   equal to it on every unused fiber of an arbitrary input prior.
4. Multiway PPS/VPS means actual finite paths of legal binary operations.
   Singleton families allow zero-length paths; value-one VPS is admitted by
   the approved C07 convention. C10 supplies these facts.
5. Figure 1's per-vector constant value, disjoint nonempty blocks, coverage and
   VPM-then-PPM reduction are checked proof content. Its artwork is omitted.
6. Endpoint equality means an explicit directed `OutputEquiv`, with every
   coordinate checked. Equal cardinalities alone do not identify endpoints.

These are applications of DG-01/DG-06/DG-07/DG-08/DG-11 and existing omissions
OM-014/020/021/042/044/045/048/049/051/052. No new mathematical interpretation
decision is proposed. Revalidate affected contracts if the designated manuscript
changes. A genuine competing interpretation affecting strength requires the lead.

## 3. Mathematical contracts

All names in this section that are not listed as existing in Section 4 are
**proposed**, and may be renamed during an authorized step without changing
their mathematical meaning.

### 3.1 One canonical law and the auxiliary channel

Work first with `S : ActiveFiniteChannel alpha`, `[Finite alpha] [Nonempty alpha]`.
Install finite enumerations classically only where sums/finsets are exposed.
Write `Y = Fin S.outputCard`, `W = alpha → Y`, and `κ = S.channel`.
Unpack intrinsic perfectness into

```text
q : PMF W, V : Y → PMF W
hV : ∀ x, q.map (fun w => (w x,w)) = PMF.channelJoint (κ x) V.
η x := q.map (fun w => (w x,w)).
```

Prove exact ENNReal atoms for every ambient label, including zeros:

```text
η x (y,w) = if w x = y then q w else 0
η x (y,w) = κ x y * V y w.
```

Make the split channel in (21)/(17) explicit as
`L y := (V y).map (fun w => (y,w))`, with atom formula
`L y (z,w) = if z = y then V y w else 0` and row composition
`(κ x).bind L = η x`. This is a selected total factorization channel; its
agreement with a conditional law is support-qualified as in Section 2.

The first and second projections give `κ x` and `q`, respectively. Let
`W+ = q.support` (equivalently `{w // 0 < q w}`). Reuse `inputSupportPrior q`
as the normalized restricted law, prove its atoms are `q w.val`, and retain
`map_val_inputSupportPrior q`. No division or renormalization is needed.

For any prior `p : PMF alpha`, the specified `W` on `indepProd p q` is a
perfect functional representation of `(X,Y')`, where `X=x`, `Y'=(w x,w)`.
Require actual independence, decoder correctness and Markov/perfectness via
the existing semantics, plus the channel-extension factorization with posterior
`(y,w) ↦ PMF.pure w`. Carry this law through the support inclusion. This checks
the fixed-W assertion in (20)-(22)/(16)-(18); existential perfectness of `η`
alone is insufficient. A separate public entropy/conditional-probability API
is unnecessary.

### 3.2 Active pairs and exact label correspondences

Choose the common endpoint by C06's active presentation of `η`, independently
of either synthesis output. Its semantic label type is

```text
A := activeOutputs η
  ≃ { z : Y × W // 0 < q z.2 ∧ ∃ x, z.2 x = z.1 }.
```

For every active original output `y`, prove

```text
0 < V y w ↔ (0 < q w ∧ ∃ x, w x = y).
```

The forward direction uses activity of `y`; it cannot be assumed for unused
ambient outputs. Establish actual bijections, with projection equations:

```text
(Σ y : Y, {w : W // 0 < V y w}) ≃ A
(Σ w : W+, {y : Y // ∃ x, w.val x = y}) ≃ A.
```

Both maps send the labels to the same ordered pair `(y,w)`. Preserve this order
through all sigma/subtype/`Fin` transports. Prove the nonemptiness and finite
cardinality of A; there is no active empty output state.

For a positive posterior label, also prove

```text
(w x = y) ↔ κ x y ≠ 0
q w = V y w * columnValue κ hκ (S.activeEquiv y).
```

Thus the PPS child's pattern is exactly the original output's pattern and its
value is exactly `q w`. Derive `hκ` from perfectness using C03, or carry it
explicitly in lower-level construction lemmas. Do not assume singularity of
an intermediate state without proving it.

### 3.3 Decoder partitions and the common finite endpoint

For supported `w`, label only `D_w = {y // ∃ x, w.val x = y}` and define
`B(w,y) = {x | w.val x = y.val}` as a finset. Prove nonemptiness, pairwise
disjointness and exact coverage of `Finset.univ`. Build
`P_w : Finpartition univ` with `partitionOfBlocks`, retaining
`D_w ≃ P_w.parts` and its exact finset equation via `partitionOfBlocksEquiv`.
Nonempty disjoint blocks also ensure that distinct output labels are not
silently collapsed as duplicate finsets.

Choose one enumeration `eA : A ≃ Fin mA` and set
`M' = ActiveFiniteChannel.ofChannelWithEquiv η eA`. Require all-atom recovery
to ambient `η`, admitted value `q w`, exact pattern `B(w,y)`, and singularity.
Show each supported w has exactly one nonzero entry in each input row's
w-block; all other y entries there are zero. The deterministic projection
posterior in (28)/(24) selects exactly that block. Repeated patterns across
different w are retained; they are not globally compressed.

### 3.4 The two actual bridges

**Original-channel bridge.** Apply `multiPpsFamilyOfENNReal S hκ V` using
`PMF.tsum_coe`/finite sum normalization. Its label type is the first sigma
type in Section 3.2 and its coordinates are `V y w * κ x y`.
Use the proved bijection followed by eA and the factorization equation to
construct a directed endpoint comparison to M'. Produce a witnessed cascade
`a : Cascade S M'` with `a.path.Homogeneous .pps`.

**All-ones bridge.** Apply the existing ENNReal PPS constructor to the sole
all-ones column with weights `q w`, discarding exactly zero weights. Retain
an explicit equivalence from its actual output labels to W+. Call the
intermediate active state Q; prove `Q(x,w)=q w`, pattern univ and singularity.
Realize the same labelled partition on each *actual* Q column's pattern finset,
preferably by calling `partitionOfBlocks` on that carrier with the original
decoder blocks and the proved full-pattern coverage. This avoids relying on a
definitional equality with univ or publishing a generic partition-transport API.
Apply `multiVpsFamily`. Its complete sigma labels must be matched to A through the
original decoder labels and eA, with the coordinate equation
`if w x = y then q w else 0`. Produce actual homogeneous PPS and VPS stages,
their comparison maps and a composed `b : Cascade (allOnes alpha) M'`.
The chronological word consists of a PPS block followed by a VPS block,
allowing either block to be empty. Merely proving permitted tag membership
does not discharge this explicit construction requirement.

S03 and S04 must use the *same* specified q, V, A and eA. Extracted paths and
their specifications must refer to the same returned C10 witness.

At the S02 handoff, record the intended private bridge inputs and results:
`S`, `q`, `V`, their row-factorization proof `hV`, the derived A, and the chosen
`eA` defining M'. Keep these parameters visible in the two consumers. Explicit
arguments or a small private context are both suitable; no new public bundle
or implementation of a later step is required at this handoff.

In S04, as soon as the seed PPS witness and its full-pattern equations exist,
compile a focused consumer applying `multiVpsFamily` to partitions on its
**actual endpoint Q**. Check the original decoder-label-to-part equivalence
and its exact block equation before assembling the complete bridge. Use C10's
local classical decidability convention consistently before partition-typed
declarations; `Finpartition` carries its lattice instances in its type. Reuse
this consumer in the final construction or remove redundant test scaffolding.

For singleton/no-op checks, the required result concerns the actual returned
stage: zero path length and empty tags, with its directed endpoint comparison.
Prefer existing selected-operation length lemmas when applicable. For family
results, homogeneous split paths and exact output cardinalities give a short
local column-growth proof. This is proof guidance; no new public counting API
or claim about optimal path length is required.

### 3.5 Constructive characterization and public boundary

Use witnessed reversal and composition:

```text
a.comp b.reverse : Cascade S (allOnes alpha)       -- PPS, then VPM, then PPM
b.comp a.reverse : Cascade (allOnes alpha) S       -- PPS, then VPS, then PPM
```

Prove both restrictions and the chronological stage descriptions. Reversal
includes the inverse directed endpoint map before reversing the actual path;
do not invent a global inverse for a merge or assume a permutation is involutive.

Prefer packaging the retained forward PPS/VPS/PPM stages privately as the
existing `NormalForm (allOnes alpha) S`. Use `OperationPath.transport` and
`transport_homogeneous` to align actual endpoints, then `NormalForm.toCascade`,
`toCascade_tags` and `toCascade_normalizing`. The package must use the stages
already constructed in S03/S04 and their witnessed reversal. A justified
equivalent organization is allowed if it preserves the same stages, exact tag
order and directed comparison; no additional public abstraction is needed.

Proposed principal public signatures in `PerfectFunctionalRepresentations.MatrixOperations`:

```lean
theorem isPerfectlyRepresentable_iff_toAllOnes
    (S : ActiveFiniteChannel alpha) :
    IsPerfectlyRepresentableChannel S.channel ↔ ToAllOnes S

theorem isPerfectlyRepresentable_iff_fromAllOnes
    (S : ActiveFiniteChannel alpha) :
    IsPerfectlyRepresentableChannel S.channel ↔ FromAllOnes S
```

Use C10's existing easy implications for the reverse implications. No extra
singularity hypothesis is needed on these intrinsic active-state iff statements:
perfectness implies it by C03, and reachability implies it by C10. Their
singular-matrix specialization is exactly the paper-facing theorem.

Include a checked arbitrary-finite-output consumer using C06 `ofChannel` and
its perfectness iff, and a supplied-enumeration consumer using
`ofChannelWithEquiv`. Reachability applies to the active presentation; no
literal binary-operation path on globally zero ambient columns is asserted.
Include actual witness extraction from both iff results and a `Fin k` matrix
consumer using existing exact-coordinate bridges. No implicit full-support
input prior, new compression or information-theory theorem is introduced.

## 4. Verified reuse and feasibility evidence

Existing declarations are distinct from the proposed contracts above. The
planning notes record source searches and focused compiling probes with limits.

| Existing source | Reuse |
| --- | --- |
| `Semantics.Canonical` | `IsPerfectlyRepresentableChannel`, `isCanonicalCoupling_of_coordinateFactorization`, `inputSupportPrior`, `map_val_inputSupportPrior`; exact support-aware and all-prior semantic bridges. |
| `Semantics.FunctionalRepresentation` | Structural expansion and `isPerfectFunctionalRepresentationOf_iff_isMarkovChainOf`; fixed-W logical content stays with the existing predicate. |
| `Semantics.Singularity`, `Matrix.Channel`, `Matrix.SingularColumns` | `coordinate_eq_of_posterior_support`, `IsPerfectlyRepresentableChannel.isSingular`, `activeOutputs`, `restrictActiveOutputs_apply`, `ActiveFiniteChannel.ofChannelWithEquiv_apply`/`recover`, perfectness invariance, `columnValue_eq_of_ne_zero`, support-finset pattern. |
| `Matrix.Partitions` | `partitionOfBlocks`, `partitionOfBlocksEquiv`, `partitionOfBlocksEquiv_apply_val`; DG-11 is already resolved. |
| `Matrix.MultiwayOperations` | `multiPpsFamilyOfENNReal`, `multiPpsOfENNReal`, `multiVpsFamily`, exact labels/coordinates, `LabelledOperationResult.outputEquiv`/`cascade`/`isSingular`; PPM is supplied by witnessed reversal here. |
| `Matrix.Reachability`, `Matrix.OperationPaths` | Both reachability predicates and easy implications, `Cascade.comp`, `Cascade.reverse`, reverse tag/restriction laws, directed output comparison; existing direction equivalence. `NormalForm`, `OperationPath.transport`/`transport_homogeneous`, and `NormalForm.toCascade`/`toCascade_tags`/`toCascade_normalizing` supply the private ordered-stage packaging route. |
| Pinned LeanInfoTheory public PMF/semantic modules | `PMF.channelJoint_apply`, `PMF.mem_support_channelJoint_iff`, `PMF.map_apply_of_injective`, `PMF.map_apply_eq_zero_of_notMem_range`, `PMF.channelExtension_deterministicChannel`, `isMarkovChainOf_comp`. |
| Pinned mathlib | PMF support and normalization, finsets, finite function/subtype/sigma types, `Equiv.sigmaCongrRight`, finite enumeration and sum transport, `Finpartition`. |

Planning probes check the support/label equivalences and partition adapter,
the fixed-W semantic route, and conditional composition of supplied bridges.
They do **not** implement maintained C11 paths, final theorems, regression
coverage or an approved step. The most significant remaining engineering work
is transporting the partitions to actual PPS endpoint patterns, composing the
dependent labels and validating the resulting concrete witnesses.
The review-time `NormalForm` probe additionally checks packaging and exact tag
concatenation for three supplied stages. It constructs none of the C11 stages.
Public `multiPps_length_singleton` and `multiVps_length_singleton` apply to the
selected constructors; private growth proofs and the existing synthesis test
are local proof models, not callable public family-length APIs.

## 5. Modules, public API and non-goals

Own one focused production module:
`PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean`, importing
`Matrix.Reachability` and `Matrix.MultiwayOperations`, with only additional
focused public imports demonstrated necessary by compilation.
Keep support, pair-channel, decoder-fiber, enumeration and one-off bridge
machinery private in that module. This permits S01-S04 to evolve coherently
without publishing a construction framework solely to cross file boundaries.

Own a separately imported
`PerfectFunctionalRepresentations/Tests/Matrix/CanonicalReachability.lean`
for external final consumers. During S01-S04, small in-module anonymous/private
consumers may exercise private interfaces; a test module must not depend on
compiler-generated private names. Move or remove redundant fixtures at integration.
The two iff theorems are the expected public API. Promote another helper or
bundle only for an actual consumer and document why its contract is needed.
Do not recreate C02/C06/C10 interfaces or edit completed prerequisites merely
to shorten a proof. A concrete defect requires an attributed reviewed repair.

The root `PerfectFunctionalRepresentations.lean` remains free of heavy matrix
imports. C12 owns global equal-pattern compression and optimization-facing
Real data. C13 owns enumeration/incidence/Bell systems and weight normalization
derived from feasibility. C14/C15 own optimization; C16 owns final project
curation. No artwork, new entropy hierarchy, solver, executable complexity
claim, minimal auxiliary cardinality, unique witness or path optimality is promised.

## 6. Proposed steps and acceptance criteria

The six steps separate the probabilistic support boundary, combinatorial label
boundary, two independently checkable path constructions, public integration,
and fresh cumulative assessment. S03 and S04 both depend on S02; execute them
in the listed order so S04 consumes the already tested common endpoint. Splitting
the chunk itself is not currently necessary. These identifiers remain stable.

### PFR-C11-S01 - Auxiliary law and supported pair labels

Prerequisite: exact plan approval and fresh prerequisite applicability check.
Implement Section 3.1 and the active/posterior pair correspondence of Section
3.2, retaining explicit support-law inclusion. Do not construct operation paths.

- **C11-S01-A:** Prove both exact atom formulas, split-channel atoms/composition,
  first/second marginals, normalized positive-support law and exact inclusion,
  plus equivalence of positive
  posterior labels and active pair labels with projection equations.
- **C11-S01-B:** Prove the fixed-W perfect representation and deterministic
  projection factorization for every prior, with supported/null-fiber limits
  explicit. Check R01-R03 without an input full-support premise.
- **C11-S01-C:** Build the touched module, appropriate semantic regressions and
  default target; audit imports, assumptions and private/public visibility.
  Update implementation evidence and OM-021/045/048 coverage.

### PFR-C11-S02 - Exact decoder partitions and the shared active endpoint

Prerequisite: S01 durably complete. Implement Sections 3.2-3.3's decoder side,
pattern/value correspondences and the independently specified M'.

- **C11-S02-A:** Derive finite nonempty decoder labels, exact nonempty/disjoint/
  covering blocks and the original-label-to-part bijection. Check every projection
  in the equivalence between partition sigma labels and active pairs.
- **C11-S02-B:** Construct the C06 active presentation, prove ambient recovery,
  singularity, exact values/patterns and unique positive row entries per w-block.
  Prove positive-posterior fiber equals original-column support and the exact
  weight/value equation. R04-R06 cover real unequal fibers and empty exclusions.
- **C11-S02-C:** Compile private interface consumers, relevant C06/C10 partition
  regressions and default build; audit no global compression or public generic
  partition duplication. Record Figure 1/(23)-(28) correspondence and downstream
  label obligations, including the explicit shared-input/result handoff of
  Section 3.4. Leave the path implementations to S03/S04.

### PFR-C11-S03 - PPS bridge from the original channel

Prerequisite: S02 durably complete. Apply C10 to the actual V families.

- **C11-S03-A:** Produce actual homogeneous PPS data from S and a cascade to the
  specified M'; verify PMF normalization, exact zero exclusion, original positive
  labels and every target coordinate. No additional posterior assumptions.
- **C11-S03-B:** Prove the directed endpoint map from actual path endpoint to M',
  singularity of every stage, exact patterns/values and singleton no-op behavior.
  R07-R08 exercise differing posterior supports and nontrivial output order.
- **C11-S03-C:** Build production and C10 synthesis/reachability regressions,
  default build and trust/import audit; record the exact consumer and remaining
  seed-path duty. Do not start S04 automatically.

### PFR-C11-S04 - PPS/VPS bridge from all-ones

Prerequisite: S03 durably complete. Apply C10 to q and the actual P_w families.

- **C11-S04-A:** Produce the positive-weight PPS seed stage, actual Q labels,
  constant masses/universal patterns, and partitions transported to those patterns.
  Compile the early actual-Q `multiVpsFamily` consumer from Section 3.4 before
  completing the bridge, preserving original decoder labels and block equations.
  Prove the VPS stage's complete labels and exact coordinates at M'.
- **C11-S04-B:** Compose the two stages with explicit maps into one witness b;
  check chronological PPS-then-VPS order, admissibility/singularity, value one,
  singleton cases and R09-R11. Verify a and b meet the same q/V/eA endpoint.
- **C11-S04-C:** Build production and relevant finite-synthesis consumers/default
  target; audit strict PPS legality and nonempty VPS pieces via the reused
  constructors. Record Figure 1 construction and reverse-stage readiness.

### PFR-C11-S05 - Both characterizations and integrated handoff

Prerequisite: S04 durably complete. Complete Section 3.5, public consumers and
the readiness crosswalk.

- **C11-S05-A:** Construct both final cascades from a and b by witnessed reversal
  and composition; retain the ordered stages and directed endpoint maps using
  Section 3.5's private packaging route. Verify tags/endpoints and combine with
  C10's easy implications to prove both public iff statements. No theorem-strength
  or prior change.
- **C11-S05-B:** Check R12-R16, actual witness extraction, active/ambient and
  supplied-enumeration consumers, finite matrix specialization and a concrete
  negative guard. Audit public signatures and all new declarations' axioms.
- **C11-S05-C:** Complete manuscript/step/regression/completion crosswalk and
  C12/C13 handoff, focused/default builds, namespace/import/root audit and canonical
  documents. Every deferred suggestion has an owner and trigger. Leave S06 as
  a distinct, unstarted cumulative-validation step.

### PFR-C11-S06 - Fresh cumulative validation and independent closeout

Prerequisite: S05 durably complete. No new mathematical theorem family.

- **C11-S06-A:** Freshly reassess all fifteen S01-S05 criteria, R01-R16,
  CC01-CC07 and CC08 review-time readiness against the exact source/manuscripts;
  run required focused/default builds and exhaustive new-module trust audit.
- **C11-S06-B:** Obtain a fresh cumulative source-bound assessment from the
  persistent C11 reviewer, preserve the full original report and checks, critically
  reconcile all findings and every criterion, and satisfy the installed gap policy.
  Prior step reviews alone do not meet this requirement.
- **C11-S06-C:** Resolve required corrections, validate their impact, complete
  owning documents before F, then finish supported final validation/F/closure.
  Only durable closure completes CC08 and C11. Stop without starting C12 or
  another step; unresolved material scope/acceptance changes go to the lead.

## 7. Required regression and edge-case crosswalk

Fixtures remain private unless a real public consumer emerges. Use small exact
PMFs and checked predicates, not numerical sampling or cardinality-only tests.

| ID | Earliest owner | Required evidence |
| --- | --- | --- |
| R01 | S01 | Zero q atoms removed; support law includes back to q exactly; positive support nonempty and mass unchanged. |
| R02 | S01 | At least one zero V(y,w), exact null-pair mass and positive-posterior/active-pair equivalence; no global positivity assumption. |
| R03 | S01 | Pure input prior with unused input rows: fixed-W perfectness and factorization still hold; no null conditional uniqueness claim. |
| R04 | S02 | Supported vector omits some active original output: that pair's decoder fiber is empty and excluded. |
| R05 | S02 | Nonconstant vector with at least two nonempty fibers of different sizes: original labels, disjointness and coverage checked. |
| R06 | S02 | Finite nonempty input/active endpoint, q-positive singleton/constant vector, exact q value and fiber pattern; empty label subtype contributes no column. |
| R07 | S03 | Actual V families with differing positive-support sizes, exact every-output mass and homogeneous PPS bridge. |
| R08 | S03 | Supplied non-involutive output enumeration, actual-endpoint-to-M' map direction, inverse/recovery and unaffected original labels. |
| R09 | S04 | q support of size one and value one; no PPS edge and legal multi-part VPS. |
| R10 | S04 | Multiple q-positive vectors, at least one single decoder block and one multi-block case; retain repeated patterns across vectors. |
| R11 | S04 | One-input/one-output boundaries and an all-singleton/no-op stage; compare two independent constructions at the exact common endpoint. |
| R12 | S05 | Both explicit compositions and chronological block words, including an empty stage and inverse endpoint maps. |
| R13 | S05 | External consumer obtains actual Cascade witnesses and restrictions from both final iff results. |
| R14 | S05 | Arbitrary finite output with an unused label, exact active restriction/reconstruction and changed supplied enumeration. Give an unused output a posterior with positive mass on a q-null vector; verify row factorization still holds and the unrestricted posterior-support implication fails there. |
| R15 | S05 | Existing C03 nonrepresentable 3x3 witness implies neither reachability predicate; no duplicate public counterexample proof. |
| R16 | S05 | Paper-facing singular `Fin k` matrix and a finite input reindexing with distinguishable rows; lightweight root stays unchanged. |

Empty input is excluded at the existing intrinsic/active boundary, not repaired
with a new convention. An ambient empty output admits no PMF for nonempty input.
Nonempty q support and nonempty D_w follow from normalization and nonempty input;
they are not new premises. Zero weights and empty fibers must never acquire
admitted column data. No Real conversion is needed beyond existing exact adapters.

Concrete proposed fixture designs make these checks discriminating:

- For R01/R02/R04/R07/R08, take two inputs and three outputs with rows
  `(1,0,0)` and `(0,1/3,2/3)`. The two positive canonical vectors are `(0,1)`
  and `(0,2)`, with weights `1/3,2/3`. The posterior at output 0 has two atoms;
  outputs 1 and 2 have one each. Four pairs are active out of the six pairs
  in `Y × support(q)`. A three-cycle within the four active labels tests a
  non-involutive enumeration. Verify q/V factorization and all counts in Lean;
  these designs are not already validated fixtures.
- For R05/R10, take three inputs and four outputs, with q supported on vectors
  `(0,0,0)`, `(1,1,2)` and `(3,3,3)` with weights `1/4,1/2,1/4`. The induced
  rows are `(1/4,1/2,0,1/4)`, `(1/4,1/2,0,1/4)`, `(1/4,0,1/2,1/4)`; each used
  output has a pure posterior. This combines two separate full-pattern
  columns, unequal two/one-element blocks and both single/multi-block vectors.
- For R14's posterior guard, use two inputs and three outputs with rows
  `(1,0,0)` and `(0,1,0)`. Let `q = pure (0,1)`, `V 0 = V 1 = q`, and
  `V 2 = pure (2,2)`. Check every row-factorization atom, including unused
  output 2. Then `V 2 (2,2) = 1` but `q (2,2) = 0`. This isolates the activity
  premise with a smaller fixture; R14 still requires its active-reconstruction
  and enumeration consumers. This fixture design awaits its Lean check in S05.

Equivalent small fixtures are permitted if they establish the same required
phenomena. Do not replace the generic constructions by hand-picked paths.

## 8. Validation and documentation duties

For each coherent Lean change build `PerfectFunctionalRepresentations.Matrix.CanonicalReachability`
and its available downstream test module. Run the relevant existing semantic,
channel/column, partition, multiway and reachability tests named by that step.
At milestones run `lake build`. Before S06 closure also build all C11 modules,
`Tests.Semantics.Canonical`, `Tests.Semantics.Singularity`, `Tests.Matrix.Channel`,
`Tests.Matrix.SingularColumns`, `Tests.Matrix.Partitions`,
`Tests.Matrix.MultiwayOperations`, `Tests.Matrix.Reachability` and
`Tests.Matrix.Synthesis` with the full project prefix. Compile actual external
consumers; imported but unchecked prose is not validation.

Audit all new public signatures and all named declarations in the new module(s)
with `#print`/`#print axioms`. Only the project's accepted foundational axioms
`propext`, `Classical.choice`, `Quot.sound` are expected. Audit explicit imports,
namespaces, support assumptions, universes, implicit instances and construction
witness consistency. Require the AGENTS.md placeholder scan to return no matches.
Inspect final diff/status, generated files, ignored references and scratch.
Distinguish fresh compilation, incremental builds and applicable older audits.

Own the C11 plan/status block, planning notes, later implementation notes and
readiness audit. Update the living summary, map coverage/omission rows, project
log, README/roadmap current status and scope status when materially changed.
Do not rewrite earlier review originals or historical log entries. The map
keeps the same C11/C12/C13 dependencies; no completed mathematics moves owners.
Ordinary helper/probe iteration does not require duplicate canonical log entries.

For reviewed steps follow the installed protocol and operations documents.
Record B before changes, maintain separate self-review/reassessment, neutral
review at R and complete original reconciliation, then applicable final checks/F
and supported closure. Prepare owning document updates before F; the plan's
marked status region is editorial only, not a means to change normative scope.

## 9. Completion criteria

- **CC01:** Actual C02 q/V witness and supported auxiliary law are reused;
  both auxiliary atom laws, marginals and all-prior specified-W perfectness are checked.
- **CC02:** Active pairs, posterior positive labels and nonempty decoder labels
  have exact bijections and inclusion/reconstruction laws; no zero columns remain.
- **CC03:** Supplied-label partitions, exact fibers, unique nonzero block entries,
  admitted values/patterns and singularity implement (23)-(28)/(19)-(24).
- **CC04:** Actual homogeneous PPS bridge from M and PPS-then-VPS bridge from
  all-ones meet the same independently specified M' with directed coordinate maps.
- **CC05:** Witnessed reversals/compositions yield both final characterizations
  with C10 easy implications, correct tags and no implicit prior assumption.
- **CC06:** R01-R16 and public/ambient/matrix consumers pass; namespace, import,
  trust and placeholder audits pass; the root and pinned dependencies stay appropriate.
- **CC07:** Exact source/step/omission crosswalk and C12/C13 handoff are complete;
  all advice is resolved or properly owned with a revisit trigger.
- **CC08:** Fresh cumulative independent review, complete original reconciliation,
  any required corrections and applicable final validation/F/durable closure
  complete. Review-time readiness alone is not chunk completion.

## 10. Omissions, deferrals and revision policy

The authoritative numbered Future Work Notes register is empty at startup.
No new unowned suggestion is introduced by this proposal. Existing dispositions:

| Obligation | C11 handling and revisit trigger |
| --- | --- |
| OM-014/044/045: finite active labels, zero weights and zero columns | S01-S04 explicit support/fiber/enumeration bridges; S05/R14 checks arbitrary posterior completion at an unused output. Revisit whenever a proposed intermediate state gains an inactive label. |
| OM-020/021/042: Figure 1 and numbered proof intermediates | All mathematical content is required through CC01-CC05; artwork and a public name per display are omitted. Revisit helper visibility only for a real consumer. |
| OM-038/049/052: empty pieces, value one and multiway shorthand | Reuse legal C10 paths, derive actual decoder partitions and test degeneracies. No raw zero-child pruning API or strict-value fallback. |
| OM-048/051: complete vector law and remembered reversal | S01 and S05 retain full witnesses and directed maps. Marginals or an abstract invertibility slogan cannot replace them. |
| C10 original-label/witness-extraction refinements and R18 handoff | Consume in S02-S05 with actual canonical data; do not promote anonymous generic fixtures without a consumer. |
| Global equal-pattern grouping and Real optimization values | C12 owns them; revisit at C12 planning and actual compression proof. Distinct q atoms/decoder labels remain distinct in C11. |
| Partition enumeration, incidence, Bell counts, feasible-weight normalization | C13 owns the mathematical incidence obligations; OM-017 retains excluded Bell-count/growth claims. Revisit at C13 planning, not for the supplied decoder partitions. |
| OM-040: Theorem 1 reproving Example 1 | R15 is a private negative consumer of the existing counterexample, not a second proof infrastructure. |
| OM-009-012/016-019/022-023/028-037 | Adjacent external equivalences, complexity, metadata and extended-only material retain existing omissions and separately approved revisit triggers; C11 adds none to scope. |

Within an authorized step, adjust proof routes, helper names, local packaging and
evidence scheduling when source results justify it; record the reason and review
the actual outcome. Preserve stable IDs and original reviewed contracts. Moving
requirements across approved steps or splitting the chunk needs an explicit
revision with faithful coverage; it never starts later work automatically.
Escalate changes to mathematical intent, hypotheses, scope, acceptance, dependency
pins or unsupported workflow transitions. Do not defer an unresolved correctness
gap as optional future work. Any worthwhile new deferral needs an existing owner
and trigger or a stable numbered Future Work Note and normalized summary entry.

The next decision is approval or revision of this exact proposal. Independent
plan review and every implementation step remain separately requested actions.

## 11. Revision history

- **Revision 1:** Original proposal, SHA-256
  `96f630a3413d836bcae7c16bb5082487aab6b394d68f57494bf5b8ef191e12eb`.
  Its complete source, installed independent report and reconciliation remain
  preserved. The report found no material gap and suggested the R14 guard.
- **Revision 2:** At the lead's request, adopts that guard using the General
  Assistant's simpler deterministic fixture, schedules an early S04 actual-Q
  consumer, and makes existing private `NormalForm` reuse the preferred route.
  Clarifies the shared-witness handoff and no-op evidence while leaving helper
  packaging and the count proof flexible. Six step IDs, theorem strength,
  public API and C12/C13 ownership are retained. The
  [selection record](../pfr-c11-planning-notes.md#revision-2-selection-and-dispositions)
  distinguishes the two review sources and records every suggestion's handling.
  This is a proposed revision, not implementation approval or a newly reviewed
  execution contract.
