# PFR-C03 - Singularity Core, Binary Output, and Counterexample

## Proposed detailed plan

<!-- pfr-review-status:start -->
**Status:** Active; S01-S06 durably complete; S07 fresh cumulative validation and independent review passed, original report reconciled; validation ready, closure subject to the durable execution record
**Revision:** Draft revision 2, 2026-09-11
**Authority:** The lead endorsed this exact revision and requested S01 with review, followed by separate conditional S02-S07 requests. Each preceding step's durable closure and exact current-source applicability were verified before accepting the next request.
**Review history:** Revision-1 reports and the revision-2 corrections are preserved; no separate revision-2 plan review is claimed.
**Implementation:** S01-S05 passed independent review with all three criteria satisfied for each step and no findings; all five original reports were reconciled and the steps durably closed. They implement singularity/necessity, finite transport, exact active restriction, the at-most-two-output characterization, and the named exact `Fin 3` singular nonrepresentable channel with R01-R13. S06 now imports `Semantics/Singularity.lean` through the lightweight root and makes semantic tests consume that root for R14. R15 is maintained in the existing separately built example tests, and the [readiness audit](../pfr-c03-readiness-audit.md) is populated. S06 adds no public theorem or production proof change. All three S06 criteria passed independent review with no independent findings; the original report was explicitly reconciled. Independent aggregate/full builds (2765/2760 jobs) and all 23 public signature/axiom checks passed, with only `propext`, `Classical.choice` and `Quot.sound`; all 71 real-file and nine supplemental hashes matched at entry and exit. S06 durably closed. The example remains separately importable. S07 was separately accepted; fresh parent aggregate/full builds (2765/2760 jobs) passed without warnings, all 23 public signature/axiom checks passed with the standard three axioms, and source/pin bytes matched. S07 fresh independent cumulative review satisfied all three step criteria with no findings and freshly assessed all ten completion rows and eighteen earlier step criteria. Independent aggregate/full builds (2765/2760 jobs), all 23 public signature/axiom checks, manuscript/omission/regression checks and 71 real-file plus nine supplemental entry/exit hashes passed. The original report was explicitly reconciled. Validation ready; closure subject to the durable execution record. No new mathematical source changes or subsequent chunk authorization are implied. C03 remains Active; binary-input and combined Lemma 2 remain C05. See [implementation notes](../pfr-c03-implementation-notes.md). The original proposed wording below is now governed by this approved status.
**S03 baseline:** HEAD `54c1714d1a9a891939d6c9f7d38c0d05896b2c75` plus actual working bytes captured as B `1d89477648ecfa4891158dd9b3a2de00708cce14d3f9002f08499b44aabccdcb`; the read-only prerequisite check matched all 68 real files, environment and Git facts to S02 F.
**S04 baseline:** Same HEAD plus actual working bytes captured as B `eb5de615198d53012c8ae1a62daa9ab72858d729c235547d907d8340e9bab6fb`; all 68 real files, exact bytes, environment and Git facts matched S03 F before acceptance.
**S05 baseline:** Same HEAD plus actual working bytes captured as B `bae204ede417d6e9b56e698e8d0eac9649cb77a07c9c588c7a972baa6b6cb7c3`; all 68 real files, exact bytes, environment and Git facts matched S04 F before acceptance.
**S06 baseline:** Same HEAD plus actual working bytes captured as B `c5fbd7c85713b05198743ad9fbb98700547b487430eeaa8bb8a814e50efd995c`; all 70 real files, exact bytes, environment and Git facts matched S05 F before acceptance.
**S07 baseline:** Same HEAD plus actual working bytes captured as B `c368387c3191b6a81b70c4bc19a660062d3ece1bf0e8ba40b15864442471d266`; all 71 real files, exact bytes, environment and Git facts matched S06 F before acceptance.
**Prerequisites:** C01/C02 complete; durable C02 S08 closure inspected at C03 startup. C03 S06 closure `f228cae1eee80a5fd96845287e39e107648f90aef8ab4d9bfd3744b200865ae0`, F `249f20a5623a0d6e85ae0b376f2b6fb3a5e75fe8325ab142eec04ac09e7ccdfb`, normative plan, originating-parent/reviewer binding and clean pins were verified before S07 acceptance, with no unresolved prior-step obligation.
<!-- pfr-review-status:end -->

This document proposes required mathematical outcomes and acceptance criteria.
Its location under `docs/plans/` grants no execution authority. The lead must
approve the exact revision separately, even after a favorable plan review.
Each subsequent implementation request addresses one approved step and stops.
Only status and dated chronology may enter the editorial block above.

The separate [planning notes](../pfr-c03-planning-notes.md) contain advisory
proof routes and planning evidence. They may evolve without silently changing
the contracts below. Proposed declaration names are not existing Lean APIs.

Draft revision 2 corrects the support-API and omission citations, separates
required proof content from advisory mechanics, clarifies R08 ownership, and
adds the S06-only R15 negative transport consumer. The seven steps, theorem
contracts and C05/C06 allocation remain. The [planning notes](../pfr-c03-planning-notes.md)
record the selected and declined suggestions with their reasons.

## 1. Objective, baseline, and prerequisites

Establish the intrinsic singularity obstruction, its converse for channels
with at most two active outputs, the finite alphabet transport needed to state
that converse correctly, and the paper's explicit singular nonrepresentable
channel. Preserve C02's single common posterior and prior-free channel contract.
The result supplies semantic prerequisites for C05 and C06.

### 1.1 Actual planning baseline

Repository HEAD is `54c1714d1a9a891939d6c9f7d38c0d05896b2c75`, on `master`.
This is not a clean C03 checkpoint. Before C03 edits, tracked modifications
already affected `.gitignore`, `AGENTS.md`, the root Lean module, `README.md`,
the formalization map, living summary, project log, project scope and roadmap.
The two Canonical Lean modules, C02 plan/notes/readiness audit, review documents
and `tools/pfr_review/` were already untracked. All are inherited work.

The installed `inspect` succeeded. Exact working bytes, Git/index state and
configuration were captured by the installed `snapshot` before planning edits
in `.pfr-review/setup/c03-20260911-01a08fa8-planning-baseline.json`, SHA-256
`03a712a020d432be9965643699aa8c49a9b902db8c102c8cc8012dfa30ab6220`.
The accompanying `c03-20260911-01a08fa8-start-inspection.json` records actual
installed dependencies. This is a planning snapshot, not an execution B or an
approved plan. Future steps capture their own B and compare to actual working
bytes; cumulative differences from HEAD are never attributed wholesale to C03.

The revision-2 starting bytes are separately captured by the installed snapshot
in `.pfr-review/setup/c03-20260911-draft2-planning-baseline.json`. They include
revision 1 and its subsequent review-status notes. This is a proposal-revision
baseline, not an execution B. The frozen `plan-r1-20260911` session retains its
original contract and assessments; revision 2 is not adopted into that session.

Keep LeanInfoTheory `v0.1.0` at
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`, mathlib `v4.33.1` at
`0df444a360eaa60ab8c11dca51a86af692955474`, and Lean `v4.33.1`.
Both installed dependency checkouts are clean and match the manifest.

### 1.2 Completed prerequisite evidence

C01's approved historical closeout is commit
`60913637e7a8a982730112415cfd9ddeea59d367`, an ancestor of HEAD.
Its Basic, semantic and regression sources still match. The root's difference
is the approved C02-S07 Canonical integration, not a C01 discrepancy.

C02's approved Draft revision 3 and cumulative closeout are independently
relevant; the generic inspection command does not establish this prerequisite.
Read-only inspection of `.pfr-review/setup/c02-s08-closure.json` and its
underlying production records established supported closure
`5a59434952e2e5776a0f29166b957a7eb389eccae723552944a671ec9ee684e0`.
All S01-S08 are complete, all fourteen S08/cumulative criteria are satisfied,
and no active step, open finding, decision obligation, pause or blocker remains.
The original report, explicit reconciliation, final validation and documentation
records are linked and their object hashes check.

C02 final snapshot F is
`17f766b119808a26d4572c94f5ca08ff9b1e19c6a3e09cba77c9f1a95a9d76b2`.
At C03 startup all 71 real inventory files and the derived `@environment`
matched. The non-status C02 plan bytes match its frozen contract. C03's later
documentation updates are new contextual changes, not retroactive edits to
that certificate. The C02 plan and private records remain untouched. Their
preclosure wording is read with the actual closure, not treated as its absence.
See [project log entry 48](../project-log.md#48-c03-reviewer-establishment-prerequisite-check-and-proposed-plan---2026-09-11).

### 1.3 Existing guarantees and limits

Reuse C01's support-correct functional representation and finite pair-perfectness
contracts, and C02's canonical law, coordinate couplings, common-posterior
factorization, finite perfect-witness reduction and prior/support bridges.
In particular, C02 supplies:

```text
IsPerfectlyRepresentableChannel kappa :=
  ∃ q : PMF (alpha → beta), ∃ V : beta → PMF (alpha → beta),
    ∀ x, q.map (fun w => (w x, w)) = PMF.channelJoint (kappa x) V
```

This existing structural definition requires `[Nonempty alpha]`, but no prior
or finiteness. A common posterior precedes every input quantifier. It is not
enough to refute a particular coupling or a particular posterior. C02's R08
only refutes one specified coupling's posterior; it is not the C03 counterexample.
`coordinateFactorization_congr_posterior` allows arbitrary null-output posterior
values; it does not yet prove invariance under changing the output alphabet.

## 2. Manuscripts, scope, and decision gates

### 2.1 Authenticated anchors

Both binaries were freshly hashed and relevant pages extracted and visually
inspected on 2026-09-11. Private manuscript files and renders are not maintained
source and must not be committed or copied into review journals.

| Source | Identity and reviewed anchors |
| --- | --- |
| Six-page ISIT manuscript | SHA-256 `48963AA59485B2C33B1A1E6E7C6EAD2251FDDDD26BD3691B6FCFFE683E6ED1C4`; PDF p. 2, Section II support convention; II-B Definition 3, Lemma 2, adjoining necessity/sufficiency prose, Example 1 and Equation (8) |
| Current eighteen-page extended draft | Designated 2026-09-03, local version 16; SHA-256 `98636D4C9F0618EC08FCA84559572780F604F197FDA90D8D7C787B3624245B8F`; Appendix A, PDF p. 12, Lemma 2 part 1, Equations (105)-(110); part 3 spanning pp. 12-13, Equations (125)-(134); p. 13, Lemma 7, Equations (135)-(146) |

The adjacent binary-input part 2, Equations (111)-(124), was read to verify the
scope boundary; it remains C05 work with C04's coupling prerequisites. Section
II-A material visible on ISIT p. 2 remains covered by C02. Section II-C and the
beginning of the extended Lemma 3 proof are neighboring material, not C03 targets.
Revalidate affected contracts after any newly designated companion version.

### 2.2 In scope and explicit non-goals

In scope: intrinsic singularity; perfectness implies singularity; finite input
and output relabeling; active-output restriction and adding/removing globally
unused outputs; singularity suffices for at most two active outputs, including
degenerate cases; and the exact displayed `3 × 3` channel with direct
nonrepresentability. Relabeling and restriction are proved representation
bridges needed for the manuscript's support convention.

The binary-input converse and the combined paper-facing Lemma 2 remain in C05.
No total variation, maximal coupling, Lemma 3 optimizer, matrix state or operations,
column value/pattern API, reachability, LP, general channel representation-existence
theorem, algorithm, complexity claim or extended-only application is included.
There is no new infinite-alphabet entropy theorem or dependency upgrade.

### 2.3 Proposed gate handling

- **DG-04, C03 portion:** count the union of channel row supports, not the output
  support under an arbitrary input prior. Prove active restriction and injective
  output extension invariance; use explicit equivalences for finite relabeling.
  The final C03 converse covers cardinality at most two. Zero active outputs
  are impossible for a nonempty-input channel; singleton outputs are included.
  Approval would settle this portion only. DG-04 stays open for C05's
  binary-input/pair-support contract until that separately approved work.
- **DG-15, C03 portion:** Example 1 has a named channel, exact entry theorem,
  singularity theorem and universal nonrepresentability theorem, in a separately
  importable example module. Auxiliary calculations and branch fixtures remain
  private or anonymous unless actual consumer pressure justifies promotion.
- **DG-06/DG-07:** C06 consumes the output restriction/relabeling boundary; C03
  does not choose matrix carriers, active-column values or matrix encodings.
  **DG-02/DG-03:** reuse the approved C02 resolutions unchanged.

These are proposed contracts, not already resolved gates. No substantive
interpretation conflict requiring a separate decision was found during drafting.

## 3. Precise proposed mathematical contracts

Notation: `alpha : Type u`, `beta : Type v`, with independently universe-polymorphic
transported alphabets; `kappa : alpha → PMF beta`, `q : PMF (alpha → beta)`,
`V : beta → PMF (alpha → beta)`. Masses remain exact `ENNReal` values.
The proposed singularity definition and necessity theorem are type-generic.
Finite transport requires `[Finite]` on each source and target alphabet and
nonempty input for statements mentioning C02 perfectness; transfer the latter
across input equivalences. Use `[Fintype]` for exposed finite enumeration.
The explicit cardinality formulation below uses `[Fintype alpha]`
and `[Fintype beta]`, with a classical induced Fintype on the active subtype.
No public `DecidableEq`, chosen default output, full-output-support assumption
or prior is added. Information/pair consumers retain C02's finite-value bounds.

### 3.1 Singularity and necessity

```text
IsSingularChannel kappa :=
  ∀ x1 x2 y, kappa x1 y ≠ 0 → kappa x2 y ≠ 0 →
    kappa x1 y = kappa x2 y

[Nonempty alpha] →
  IsPerfectlyRepresentableChannel kappa → IsSingularChannel kappa
```

The definition itself requires neither nonempty nor finite types. Its
nonzero-mass condition must be explicitly related to Definition 3's positive
product condition using nonnegativity of PMF masses. An all-zero column
satisfies singularity vacuously; singular does not mean a matrix determinant
vanishes. The necessity proof keeps one common `V`, handles zero entries, and
justifies every positive finite-mass cancellation. The contrapositive is
available to later consumers without requiring a redundant public alias.

### 3.2 Finite relabeling and injective output extension

For equivalences `eX : alpha ≃ alpha'` and `eY : beta ≃ beta'`, define or
spell out the transported channel by

```text
kappa' x' := (kappa (eX.symm x')).map eY
```

Prove `IsSingularChannel kappa' ↔ IsSingularChannel kappa` and the analogous
iff for `IsPerfectlyRepresentableChannel`. Nonempty input transfers across
`eX`. The canonical vector transport is `w ↦ (fun x' => eY (w (eX.symm x')))`;
the joint law and posterior, not just coordinate marginals, must transport.
Input-only and output-only cases must be usable by specialization to identity
equivalences. Do not claim invariance under deleting an arbitrary input row.

For an injection `j : beta → beta'` between finite output alphabets, let
`kappaJ x := (kappa x).map j`. Require both

```text
IsSingularChannel kappaJ ↔ IsSingularChannel kappa
IsPerfectlyRepresentableChannel kappaJ ↔ IsPerfectlyRepresentableChannel kappa
```

This is the exact unused-output extension contract. The reverse implication
must recover a complete common-posterior witness, justifying recovery of
supported vector values in `Set.range j`. Arbitrary extensions outside this
range cannot become assumptions. Posterior completion at unused outputs is
arbitrary, with C02's null-fiber theorem available. A particular retraction,
helper lemma or proof order is not required; the notes give an advisory route.
No invariance is asserted for noninjective merging of outputs.

### 3.3 Active-output restriction and paper support bridge

```text
activeOutputs kappa : Set beta := {y | ∃ x, y ∈ (kappa x).support}
A := {y // y ∈ activeOutputs kappa}
restrictActiveOutputs kappa : alpha → PMF A
```

Require the exact mass and law bridges

```text
restrictActiveOutputs kappa x a = kappa x a.val
(restrictActiveOutputs kappa x).map Subtype.val = kappa x
∀ a : A, ∃ x, a ∈ (restrictActiveOutputs kappa x).support
IsSingularChannel (restrictActiveOutputs kappa) ↔ IsSingularChannel kappa
IsPerfectlyRepresentableChannel (restrictActiveOutputs kappa) ↔
  IsPerfectlyRepresentableChannel kappa
```

For nonempty input, prove the active subtype is nonempty using an actual row's
support. The restriction discards only globally zero masses: it is not
conditioning on an event with a new normalizing denominator. It is uniquely
specified by its mass bridge; implementation may use `PMF.bindOnSupport`.

For a finite input law `p`, explicitly check the support relationship

```text
y ∈ (PMF.channelJoint p kappa).sndMarginal.support ↔
  ∃ x ∈ p.support, y ∈ (kappa x).support
```

Under `∀ x, x ∈ p.support`, this is exactly `y ∈ activeOutputs kappa`.
This supplies the manuscript-facing interpretation of `Y` as support.
For arbitrary priors use C02's input-support channel first; do not replace
intrinsic active-output cardinality with the smaller support of such a pair.
The support formula can remain a focused internal lemma if a pinned theorem
already supplies it; a stable full-support boundary must be directly usable.

### 3.4 At most two active outputs

With finite input/output alphabets and `[Nonempty alpha]`, require

```text
Fintype.card {y // y ∈ activeOutputs kappa} ≤ 2 →
  (IsPerfectlyRepresentableChannel kappa ↔ IsSingularChannel kappa)
```

Equivalently expose the sufficiency implication and reuse necessity; the iff
must be immediately available without new hypotheses. Include a directly
usable `Fintype.card beta ≤ 2` specialization, hence the literal two-output
case. The public theorem must not retain a chosen enumeration, a strict
probability hypothesis, or a caller-supplied canonical witness.

The proof must cover both manuscript branches: a row with two positive
outputs forces all rows equal; otherwise every row is a pure PMF. Construct
actual common-posterior witnesses for identical-row and deterministic channels.
These witness lemmas need not be public. Exact witness formulas and case order
are advisory; both branch outcomes and actual factorization witnesses remain
required. The singleton-active case belongs to these outcomes; active cardinality zero is ruled out from row normalization.
Empty ambient outputs with nonempty input admit no channel. Empty input remains
outside C02's intrinsic property, even though the singularity predicate is
vacuous. C05 retains the binary-input direction and combined Lemma 2.

### 3.5 Exact counterexample and its quantifiers

Define a channel `nonrepresentable3x3 : Fin 3 → PMF (Fin 3)` with
input rows and output columns in the displayed order. Paper labels `1,2,3`
correspond to Lean labels `0,1,2` in both coordinates. Its mass table is

```text
          y=0   y=1   y=2
x=0       1/2   1/2    0
x=1       1/2    0    1/2
x=2        0    1/2   1/2
```

All entries are `ENNReal`; each row is a normalized PMF. Prove an exact
entry specification, singularity and
`¬ IsPerfectlyRepresentableChannel nonrepresentable3x3`. The last statement
rules out every canonical law and every common posterior. It cannot be
replaced by failure of a chosen coupling, bounded enumeration of witnesses,
an axiom, numerical evidence, or a later matrix/LP characterization.

The direct proof must retain Lemma 7's logical obstruction: common-posterior
support forces coordinate equalities for a positive vector atom, and both
remaining coordinate alternatives yield incompatible equalities. Establish
atom existence, coordinate-support restrictions and positivity before any
cancellation. Trace both manuscript contradictions explicitly. The notes give
the displayed-label route starting with `w 0 = 0`; that initial atom choice,
case order and private helper organization are advisory. Equivalent direct
proof organization is allowed while retaining all this logical content.
Using C02 factorization instead of the manuscript's uniform-prior conditional
probability calculations is an explicit representation change, justified by
C02's full-support Markov bridge; it does not change the theorem or omit a
branch. The uniform-input pair corollary is a checked consumer of C02's
existing equivalence, not a substitute for the intrinsic negative theorem.

## 4. Reuse and module/API ownership

The existing declarations below were inspected in local pinned source. Focused
API probes provide selected signature and consumer checks, with exact scope,
imports and unsuccessful lookups retained in the planning notes/evidence.
Revision 1's misnamed support theorem and overbroad probe-verification claim
are corrected here; the replacement was independently compiled. None of the
listed declarations is a proposed new API.

| Existing surface | Intended reuse |
| --- | --- |
| C02 `IsPerfectlyRepresentableChannel`, `isCanonicalCoupling_of_coordinateFactorization`, `IsPerfectlyRepresentableChannel.exists_canonicalCoupling` | Common-posterior witnesses and coordinate laws |
| C02 `canonicalJoint_eq_channelExtension_iff_of_fullSupport`, `IsCanonicalCoupling.exists_commonPosterior_iff_isMarkovChain` | Bridge the prior-free proof to the manuscript's full-support Markov arguments |
| C02 `coordinateFactorization_congr_posterior` | Null-output posterior completion |
| C02 `isPerfectlyRepresentablePair_channelJoint_iff_of_fullSupport`, `isPerfectlyRepresentablePair_channelJoint_iff_restrict_support` | Paper-facing/full-support consumers and arbitrary-prior regression boundaries |
| Pinned `PMF.channelJoint_apply`, `PMF.mem_support_channelJoint_iff`, `PMF.channelJoint_map_fst`, `PMF.channelJoint_eq_iff_eq_on_support` | Exact products, support and row-law equality |
| Pinned LeanInfoTheory `PMF.map_apply_of_injective`, `PMF.map_apply_eq_zero_of_notMem_range`; mathlib `PMF.map_comp`, `PMF.map_id`, `PMF.mem_support_map_iff` | Coordinate evaluation, relabeling and embedding |
| Pinned mathlib `PMF.bindOnSupport`, `PMF.support_nonempty`, `PMF.apply_ne_top`, `PMF.pure`, `PMF.ofFintype` | Active subtype construction, inhabitedness, finite exact fixtures |
| Pinned mathlib `ENNReal.mul_left_inj`, `ENNReal.mul_right_inj` | Cancellation with explicit nonzero and non-top hypotheses |
| Pinned mathlib `Fintype.equivFinOfCardEq`, finite subtype/cardinality API | Explicit finite relabeling and small-output reduction |

No ready singularity, channel-perfectness relabeling or active-output pruning
theorem was found in the pinned dependency source/API material. C02's private
support retraction and private permutation helpers are not public reuse. Search
again before adding any generic information-theory helper; do not build a
second Markov/entropy theory or use a current-upstream name against v0.1.0.

Proposed production ownership is deliberately small:

- `PerfectFunctionalRepresentations/Semantics/Singularity.lean`: singularity,
  necessity, channel relabeling/embedding and active-output bridges, binary-output
  sufficiency. Begin with the focused public Canonical import; justify any
  additional foundational import with an actual use.
- `PerfectFunctionalRepresentations/Examples/Nonrepresentable3x3.lean`: named
  channel, exact entries, singularity and direct negative theorem. Import
  Singularity and only the needed finite arithmetic/PMF construction material.
- `PerfectFunctionalRepresentations/Tests/Semantics/Singularity.lean`: anonymous
  semantic/transport/binary regressions and public consumers. A separate
  example test module is optional if it materially improves import separation.
- The lightweight root imports Singularity at S06. It does not import the
  example, test, matrix or optimization modules.

All project declarations belong to `PerfectFunctionalRepresentations`.
Do not introduce a parallel channel structure, global finiteness/default
instances, a bundled singular-channel hierarchy, or a generic transport
framework. One-consumer algebra, retractions, branch classification and
posterior completion stay private/local. Names and equivalent proof organization
may be refined within these outcomes; public promotion needs consumer evidence.

## 5. Stable proposed steps and acceptance criteria

Execution order is S01-S07. This order is a future contract, not permission to
start. The dependency graph is S01 → S02 → S03 → S04; S05 needs S01 and C02;
S06 joins S01-S05; S07 follows S06. The separate transport and active restriction
steps isolate the principal type-change risk. The example is a separate
mathematical outcome; integration and fresh closeout remain distinct.

Every criterion requires current source evidence, its owning regression rows,
focused module/downstream builds, and the common duties in Section 7.

### PFR-C03-S01 - Intrinsic singularity and the necessary condition

**Prerequisite:** completed C02. **Anchors:** Definition 3; Lemma 2 first
direction; extended (105)-(110). **Owns:** Section 3.1.

- **C03-S01-C01:** The intrinsic predicate and positive-product interpretation
  express equality exactly on pairs of positive masses, including zero columns.
- **C03-S01-C02:** Every C02-perfect channel is singular, with the generic
  nonempty-input contract, one common posterior and justified mass cancellation.
- **C03-S01-C03:** R01-R03 compile; public/private/import boundaries and source
  coverage are recorded, with no binary converse or matrix definition claimed.

### PFR-C03-S02 - Finite relabeling and unused-output extension

**Prerequisite:** S01. **Anchors:** Section II finite-support labeling; the
explicit representation boundary for Lemma 2. **Owns:** Section 3.2.

- **C03-S02-C01:** Both predicates are invariant under finite input/output
  equivalences in the specified orientation, with usable identity specializations.
- **C03-S02-C02:** Both predicates are invariant under injective output maps,
  including the reverse witness transport and arbitrary null-output completion.
- **C03-S02-C03:** R04-R05 compile and check joint/posterior transport, inverse
  relabeling, a non-surjective injection and globally zero new outputs.

### PFR-C03-S03 - Active-output restriction and support interpretation

**Prerequisite:** S02. **Anchors:** Section II support convention and Lemma 2's
output cardinality. **Owns:** Section 3.3.

- **C03-S03-C01:** Active outputs, their restricted channel, exact masses,
  inclusion recovery and activity/nonemptiness are proved without renormalization.
- **C03-S03-C02:** Singularity and perfectness are equivalent before and after
  restriction; no unspecified default or posterior value leaks into the contract.
- **C03-S03-C03:** The output-support/prior relationship and full-support
  identification are checked. R06-R07 and R08's S03 portion distinguish global
  activity from pair support and establish structural empty/singleton restriction
  facts; perfect-representability consequences of those degeneracies belong to S04.

### PFR-C03-S04 - Sufficiency for at most two active outputs

**Prerequisite:** S03. **Anchors:** Lemma 2 output clause; extended part 3,
Equations (125)-(134). **Owns:** Section 3.4.

- **C03-S04-C01:** Singularity is sufficient under the active-cardinality bound,
  with necessity giving the iff and an ambient-cardinality specialization.
- **C03-S04-C02:** Identical-row and deterministic branches have actual common
  posterior witnesses; all degenerate cases are discharged without strict-mass
  assumptions in the final theorem.
- **C03-S04-C03:** R08's S04 portion and R09-R11 compile, including nonuniform
  identical rows, nonconstant deterministic rows and unused outputs; C05's binary-input and
  combined Lemma 2 ownership remains unchanged.

### PFR-C03-S05 - The displayed singular nonrepresentable channel

**Prerequisite:** S01 and C02; the scheduled earlier steps remain closed.
**Anchors:** Example 1/(8); extended Lemma 7/(135)-(146).
**Owns:** Section 3.5 and the separately importable example module.

- **C03-S05-C01:** The named `Fin 3` channel has exactly the nine displayed
  masses and normalized rows, with documented row/column and indexing conventions.
- **C03-S05-C02:** Its singularity and universal nonrepresentability are proved
  directly, with both last-coordinate contradictions and no later-chunk dependency.
- **C03-S05-C03:** R12-R13 compile; the proof-to-manuscript bridge and public
  example import boundary are documented. No coupling-specific negative is
  reported as the required channel-wide theorem.

### PFR-C03-S06 - Integrated API and cumulative readiness

**Prerequisite:** S01-S05 closed. **Owns:** root integration, all consumers and
the current source/criterion/anchor coverage audit.

- **C03-S06-C01:** The root exposes the semantic C03 API; the example remains
  separately importable. R14-R15 and every earlier regression pass with C01/C02
  consumers. R15 uses S02 transport and S05's negative theorem in a separately
  built test consumer; it adds no public counterexample theorem or root import.
- **C03-S06-C02:** All Section 8 readiness criteria are audited against current
  declarations, imports, builds and trust evidence, not merely earlier verdicts.
- **C03-S06-C03:** Owning documents and omissions accurately record implementation
  readiness, downstream guarantees and pending independent closeout. S07 is not
  marked complete or begun by this step.

### PFR-C03-S07 - Fresh independent cumulative validation and closeout

**Prerequisite:** S06 durably closed and this step separately authorized.
**Owns:** cumulative assessment of the complete C03 contract and finalization.

- **C03-S07-C01:** The persistent C03 reviewer performs a fresh source-bound
  cumulative pass against every C03-CC criterion and all step/anchor/regression
  obligations; prior step reviews alone do not replace the pass.
- **C03-S07-C02:** The reviewed source has complete required validation and a
  source-applicable coverage/import/trust audit, with all limitations explicit.
- **C03-S07-C03:** Reviewable documents accurately describe readiness and
  remaining lifecycle duties; no subsequent chunk or mathematical work is inferred.

After the report, Section 8's reconciliation and closure duties are mandatory.
They are future events, not criteria the reviewer must certify before receipt.

## 6. Mandatory regression and boundary matrix

Fixtures check mathematical boundaries; anonymous consumers are sufficient.
Do not introduce a public API merely to give each row a name. A documented
compiling impossibility proof is the correct test when no channel can exist.

| Row | Required check | Owner |
| --- | --- | --- |
| R01 | Definition 3 positive-product/nonzero interpretation; zero and single-positive-entry columns impose no spurious constraint | S01 |
| R02 | A concrete nonsingular channel is rejected by necessity, exercising unequal positive masses rather than a zero entry | S01 |
| R03 | Singularity on empty input is vacuous; intrinsic perfectness retains nonempty input; singleton input is singular | S01 |
| R04 | Nontrivial input and output equivalences, inverse roundtrip, identity specializations, independently universe-polymorphic types and explicit coordinate orientation | S02 |
| R05 | Embed a channel into a larger output type; added symbols have zero mass; both forward and reverse invariance are usable | S02 |
| R06 | Active restriction has identical row masses, inclusion recovers the original channel, and every restricted output is active | S03 |
| R07 | A degenerate prior sees fewer outputs than the intrinsic union; full support recovers the union; C02 support restriction gives the correct pair interpretation | S03 |
| R08 | **S03:** active cardinality is positive for nonempty input; no PMF on empty output; exact singleton restriction/inclusion facts. **S04:** perfect-representability consequences for singleton active/ambient outputs and singleton input within the small-output contract. | S03 structural; S04 sufficiency |
| R09 | Identical non-pure rows with nonuniform probabilities give a common-posterior witness; no fair-coin assumption | S04 |
| R10 | A deterministic channel with different row outputs, including one-output degeneration, is covered | S04 |
| R11 | At most two active outputs inside a larger ambient type; finite relabeling transports the converse | S04 |
| R12 | Exact nine entries, normalization, all three active outputs, singularity and universal negative theorem for the example | S05 |
| R13 | The example gives a nonperfect pair under a full-support prior via C02; a point prior may give a perfect pair, preserving the support qualification | S05 |
| R14 | Production-only imports consume all public C03 families; root excludes examples/tests/heavy later modules; C01/C02 regression modules still compile | S06 |
| R15 | For the label-preserving injection `j : Fin 3 → Fin 4`, set `kappa4 x := (nonrepresentable3x3 x).map j`. Check `kappa4 x 3 = 0`, singularity, and universal nonrepresentability. Derive the negative result using the reverse perfectness-transport implication and S05's theorem, without a second obstruction proof or public fixture API. | S06 |

## 7. Validation and installed review operation

For each coherent Lean edit run `lake build <Touched.Module>` and important
downstream modules. Build the separate example and regression modules explicitly;
the default root does not imply their coverage. Before a milestone run
`lake build`, plus the existing C01/C02 regression modules and all C03 consumers.
Use focused compiling probes to verify any newly selected pinned API/import.
Require the AGENTS.md production placeholder scan to return no matches:

```powershell
rg -n --glob '*.lean' '\b(sorry|admit|axiom|opaque|undefined)\b' `
  PerfectFunctionalRepresentations PerfectFunctionalRepresentations.lean
```

Audit every new public declaration's actual statement, assumptions and imports.
Run `#print axioms` for the main theorem families and audit unexpected trust
dependencies; ordinary Lean logical foundations must be distinguished from a
new project axiom or placeholder. Inspect final diffs relative to the step's B,
Git status, tracked generated files, ignored references and owned temporary files.
Preserve all inherited changes and all durable `.pfr-review/` records.

This task's persistent reviewer is `/root/pfr_c03_reviewer`, originating parent
`01a08fa8-5f40-7373-8680-bb6d477a90a8`, role `/root`, recorded by installed `bind`
at `.pfr-review/chunks/PFR-C03/binding.json`. Requested settings are
`gpt-6-astra`, `ultra`, `fork_turns: none`; effective backend settings remain
unobservable. Neutral bootstrap and actual creation/readiness records are under
the unique `c03-20260911-01a08fa8-` setup prefix. Read-only reviewer behavior is
instruction-level, not OS isolation; the accepted supervised limitations remain.
No C02 or diagnostic reviewer was transferred.

For a later explicit plan-review request, use a separate `plan-*` session with
this binding and the exact proposed plan hash/PR criteria; do not register an
execution approval. For an approved step requested with review, follow
[review protocol](../review-protocol.md) and
[installed operations](../review-operations.md) with C03 identifiers: inspect
eligibility, retain actual authority and B, implement only the selected step,
validate, preserve self-review then separate reassessment, finish justified
edits, freeze a neutral source-bound request, persist intent, send natively to
the bound reviewer, retain actual receipt/report, reconcile, validate final
source and obtain supported closure. Unknown delivery is not a resend trigger.
The parent handles the phases; the lead need not relay messages between tasks.

Record exact manuscript identities and necessary pinned dependency source in
the source scope; distinguish B, reviewed R and final F. Include the plan,
planning notes and affected canonical documents as source-visible context.
Reviewers receive normative contracts and provenance-labeled facts, not parent
conversation or private self-review conclusions. No workflow redesign, scheduling,
unattended operation, automatic next step, commit or push is authorized here.

## 8. Cumulative readiness and completion

S06 prepares this audit. S07 independently assesses it against current source,
in addition to all step criteria and regression rows.

| Criterion | Required current result |
| --- | --- |
| C03-CC01 | Exact plan/step authority, baseline attribution, completed prerequisites, clean matching pins and correct reviewer binding are established |
| C03-CC02 | Intrinsic singularity matches Definition 3 and perfectness implies singularity with the required support/nonempty boundary |
| C03-CC03 | Finite relabeling and injective output extension preserve both predicates in both directions, transporting the complete common-posterior witness |
| C03-CC04 | Active restriction, exact mass/inclusion bridges, activity/nonemptiness and the full-support output-support interpretation are established |
| C03-CC05 | The converse/iff for at most two active outputs and its ambient specialization cover identical, deterministic and all degenerate branches |
| C03-CC06 | The exact displayed `3 × 3` PMF channel is singular and universally nonrepresentable by the direct two-branch support contradiction |
| C03-CC07 | Every R01-R15 obligation and required C01/C02 consumer passes; priors, null fibers, empty/singleton types, indexing and `ENNReal` boundaries are explicit |
| C03-CC08 | Public/private ownership, root/example separation, focused imports, builds, placeholder and axiom audits pass against the reviewed source |
| C03-CC09 | Every reviewed source anchor and proposed theorem family is mapped to actual proof content or an explicit omission/disposition, with current evidence and limits |
| C03-CC10 | Owning documents, proposed/approved gate status, downstream guarantees and repository hygiene are accurate; independent completion is not claimed before its durable record |

Completion additionally requires retaining the original fresh cumulative report
and provenance, explicitly reconciling every finding and assessment, satisfying
all required criteria and outstanding report obligations, final document
reconciliation, applicable final checks, F capture and supported step closure.
Before F, documents may say validation ready with closure subject to the durable
record. Do not mutate included files afterward and silently retain that closure.

Bounded repairs that preserve the approved contract may be made during closeout,
with affected-source validation and renewed independent assessment wherever a
criterion gap or changed claim requires it. A material contract defect requires
a plan-health review and stop, not an improvised theorem weakening or favorable
certificate. A completed C03 exposes the Section 3 semantic guarantees to C05/C06;
it does not complete the binary-input Lemma 2 clause, matrix singularity bridge,
all-ones matrix theorem, operations, or any optimization claim. Then stop.

## 9. Plan-review criteria and revision policy

These assess planning adequacy, not nonexistent proofs. They become applicable
only when the lead explicitly requests independent review of this exact draft.

| Criterion | Required assessment |
| --- | --- |
| C03-PR01 | Authenticated ISIT/extended anchors and every deliberate omission are allocated accurately; binary-input and combined Lemma 2 remain C05 |
| C03-PR02 | Singularity, factorization, active-output/relabeling and small-output contracts preserve theorem strength, support, null-fiber and degenerate boundaries |
| C03-PR03 | The exact example and direct universal negative proof obligation are adequate, with indexing and manuscript-to-factorization interpretation explicit |
| C03-PR04 | Existing local/pinned APIs are verified and distinct from proposals; proof routes and focused module ownership are feasible without unnecessary new theory |
| C03-PR05 | Dependency-driven steps, stable criteria, regressions, current-source validation and independent closeout cover the whole proposed chunk |
| C03-PR06 | Baseline/prerequisite evidence, reviewer provenance, approval/stopping boundaries, document maintenance and revision rules are accurate and non-authorizing |

Equivalent proofs, routine theorem names and private helper choices may evolve
within the approved outcomes, with reasons in advisory notes and material state
changes in the project log. Advisory freedom concerns proof mechanics only; it
does not remove the supported-witness obligations, either binary branch, either
source counterexample contradiction, or a regression/acceptance requirement.
Execution freezes the non-status plan bytes; do not rewrite an apparently
advisory passage inside a frozen contract silently.
Changing assumptions, theorem strength, carrier meaning, step acceptance,
ownership, source allocation or dependencies requires explicit approval of a
concrete revised contract. If a discovery invalidates later steps, stop for
plan-health review. No later step starts automatically from the present plan.

## 10. Omissions, deferred work, and documentation consequences

The [map's omission register](../formalization-map.md#9-internal-exhaustive-omission-and-disposition-register)
remains canonical. This reviewed-anchor audit records all deliberate dispositions:

| Reviewed material | Disposition |
| --- | --- |
| Section II literal support labels `{1,...,k}`, `{1,...,m}` | OM-014 and proposed OM-056: arbitrary finite types plus proved relabeling/active-output bridges; `Fin 3` only at the example boundary |
| Definition 3's conditional-probability-matrix sentence | Semantic definition now; matrix equivalence stays with the [C06 allocation](../formalization-map.md#pfr-c06--finite-channel-to-matrix-boundary); no matrix structure introduced in C03 |
| Singularity's role in cited work [17] | OM-015: contextual attribution only; no external information-theory repository or cited-paper proof is consulted |
| Lemma 2 binary-input clause and extended (111)-(124), including common-mass zero/one branches | Deferred to C05 with C04; not claimed as C03 proof coverage or quietly omitted from the global allocation |
| Combined paper-facing Lemma 2 and surrounding restatement | C05 combines the directions; C03 provides its necessity and output portion; no duplicate declaration for prose (OM-022) |
| Extended necessity (105)-(110) and binary-output (125)-(134) as separate named equations | OM-042: checked logical content within C03, no public name for every display |
| Extended identical-row and deterministic witness constructions | Proposed OM-058: checked internal proofs/regressions, no general existence hierarchy or external special-case theorem; all-ones matrix result remains C09 |
| Example 1/(8), extended Lemma 7/(135)-(146) | Named exact channel and singularity/negative theorems; OM-042/OM-057 record the factorization proof of the same support contradiction and the unused uniform-prior conditional-display API |
| Second proof of the example through Theorem 1 | OM-040: not a target; direct proof is mandatory |
| Neighboring ISIT II-A, II-C, Section III transition and extended Lemma 3 proof | Already C02, future C04/C05, or later matrix chunks; page adjacency adds no C03 scope |
| Abstract/restatements, bibliography and publication material visible in consulted sources | OM-022/OM-023: no duplicate mathematics or invented metadata; extended-only material remains excluded |

OM-045 is clarified to route semantic active restriction to C03 and its matrix
use to C06, consistently with the already accepted C03 allocation. This is not
a new chunk reallocation. No numbered Future Work Note is opened: C04/C05 and
C06+ already own the relevant deferrals; ordinary proof risks belong here.

Planning updates the living summary/current activity, map proposal/omissions,
roadmap next planning state and project log, with short reader-facing status
links where needed. It does not change C02's closed plan or private records.
Implementation steps later update coverage and evidence in the owning documents;
plan approval records only the approved partial DG-04/DG-15 resolutions. At
closeout provide a cumulative declaration/anchor/criterion audit, exact closure
reference and downstream boundary. A draft, favorable review, build or roadmap
entry is never execution approval.
