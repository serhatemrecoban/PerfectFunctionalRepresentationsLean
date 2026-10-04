# PerfectFunctionalRepresentationsLean Formalization Map

**Status:** project-lead-accepted revision 2; current non-authorizing global map
**Created:** 2026-09-03
**Last adversarial review:** 2026-09-03
**Project-lead acceptance:** 2026-09-03
**Last planning-status reconciliation:** 2026-10-03
**Last completion/dependency reconciliation:** 2026-10-04
**Map-preparation baseline:** repository commit `0e28f7a`; at that baseline,
Lean declarations were unchanged from the bootstrap implementation at `57e132c`
**Dependency baseline:** LeanInfoTheory `v0.1.0` at
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`, Lean and mathlib `v4.33.1`

This is the canonical, adaptable global map for the paper formalization. It
assigns source coverage, records dependency order and decision gates, and
proposes coherent theorem-development chunks. It is more concrete than the
[roadmap](roadmap.md) and less detailed than an approved file under
`docs/plans/`.

**Current, 2026-10-04:** C01–C16 are durably complete. C16's supported S05
closure and exact final-source applicability were verified before the
[private repository checkpoint](project-log.md#post-c16-checkpoint).
The [completed C16 contract](plans/pfr-c16-coverage-api-trust-closure.md)
preserves its reviewed pre-closure checkpoint; the later durable record establishes
completion. [Current readiness](pfr-c16-readiness-audit.md#c16-s05-readiness)
and [history routes](pfr-c16-readiness-audit.md#c16-s04-navigation) replace repeated
checkpoint narratives. Original C01–C15 plans/notes and all 71 omission rows are
preserved. DG-01–DG-15 are resolved; the no-wrapper decision is retained.

## 1. How to Read and Maintain This Map

The map is a working reference, not a frozen prediction. Proof discoveries may
change representations, dependencies, module boundaries, or chunk sizes. Such
changes should improve the map rather than force an obsolete plan onto the
development.

The following rules keep that flexibility auditable:

- Chunk identifiers are stable references. Do not silently reuse an identifier
  for materially different work.
- A chunk may be split, combined, reordered, or superseded after a plan-health
  review. Record the change here and in the project log, preserving the old
  disposition.
- A detailed chunk plan owns executable steps and exact theorem contracts.
  This map owns only the global allocation and dependency interface.
- Completing a chunk does not approve its dependents.
- Update this map when a completed chunk changes a downstream prerequisite,
  resolves a decision gate, exposes a new risk, or changes paper coverage.
- Every detailed chunk plan must audit its manuscript anchors for intentional
  omissions and update Section 9. The initial register is deliberately
  exhaustive for internal use.
- Before public-release preparation, the project lead may approve a curation
  pass that retains or condenses the mathematically meaningful omissions in
  reader-facing documents. Curation must not silently erase rationale: the
  project log must record what was archived, combined, or removed.

Candidate chunk statuses used here are:

| Status | Meaning |
| --- | --- |
| Mapped | Candidate scope and dependencies are recorded; no execution approval |
| Ready for detailed planning | Blocking predecessor facts are stable enough to draft the chunk plan |
| Proposed detailed plan | A concrete draft exists; independent review and exact plan approval remain separate |
| Draft plan under review | A proposed detailed contract exists outside the approved-plan register; it is non-authorizing |
| Approved | The project lead approved the detailed plan |
| Active | Work is proceeding under the approved plan |
| Complete | The approved completion and independent-validation criteria passed |
| Superseded | The allocation was replaced, with its successor recorded |
| Deferred | Work remains discoverable but is outside the current implementation sequence |

**Current allocation, 2026-10-04:** C01–C16 are **Complete**. C16's five
supported closures, satisfied criteria and final-source applicability were
verified in the [post-closure checkpoint](project-log.md#post-c16-checkpoint).
All fifteen gates are resolved.
Older checkpoint text in chunk entries, gate rationale and omission rows is
historical; it does not override this current status. The
[closure/history routes](pfr-c16-readiness-audit.md#c16-s04-navigation) identify
the preserved records and later handoff checks. Map endorsement itself does not
authorize theorem implementation, commits or publication.

## 2. Source and Interpretation Contract

### Primary target

The primary source is the six-page ISIT manuscript *On Perfect Functional
Representations*, reviewed in full, with SHA-256 digest:

`48963AA59485B2C33B1A1E6E7C6EAD2251FDDDD26BD3691B6FCFFE683E6ED1C4`.

The 2026-09-05 S01 review identified a digest mismatch in the then-available
same-named copy. On 2026-09-07 the exact approved binary was recovered, and S08
freshly authenticated and inspected the C01 Section I anchors. The approved
source identity remains unchanged; see the
[provenance history and resolution](perfect-functional-representations-living-summary.md#10-reference-and-provenance-boundary).
This closes the missing-binary limitation without retroactively authenticating
earlier checks or changing mathematical coverage or omission dispositions.

The accepted mathematical target comprises Equations (1)-(3), Definitions
1-4, Lemmas 1-6, Theorems 1-2, Corollary 1, the non-representable
`3 × 3` example, the four matrix operations, the pattern system, and the
supporting claims needed to state and connect those results precisely.

### Current proof and clarification companion

The current extended manuscript is the eighteen-page draft designated by the
project lead on 2026-09-03, with SHA-256 digest:

`98636D4C9F0618EC08FCA84559572780F604F197FDA90D8D7C787B3624245B8F`.

Its Sections II-IV on PDF pages 2-7 and Appendices A-B on PDF pages 12-17,
through Equation (221) before Appendix C, are the principal proof and
clarification anchors for in-scope results. Appendix C begins later on PDF
page 17 and remains extended-only. In particular, the draft:

- supplies the omitted proofs of Lemmas 2-6 and Theorems 1-2;
- treats the zero-common-mass and conditional-support cases in Lemma 2;
- gives a direct proof of the `3 × 3` counterexample under the label Lemma 7;
- corrects the PPM/VPM source-index range to the `m + 1` source columns; and
- distinguishes the full `2^k - 1`-pattern system from the reduced system on
  the `m` occurring patterns.

The companion may evolve. A chunk plan must record the digest it used and
revalidate affected contracts after the project lead supplies a replacement.
Extended-only results do not enter scope merely because they occur in this
draft.

### Interpretation rule

For every source item, distinguish:

1. the printed statement or prose;
2. the mathematically intended assertion; and
3. the precise Lean contract and representation.

Finite-support conventions, zero-probability symbols, null conditional fibers,
coordinate counts, and output relabelings must be made explicit. A technically
defective literal reading must not be formalized merely for fidelity, but any
material repair or alternative interpretation must be recorded. If two
plausible readings change theorem strength or hypotheses, the responsible
chunk stops for project-lead guidance.

## 3. Verified Reuse and Known Missing Infrastructure

The semantic development should reuse mathlib `PMF` and LeanInfoTheory's
channel convention `alpha -> PMF beta`. The following relevant declarations
were verified against the pinned release, not against `master`:

- `PMF.deterministicChannel`, `PMF.channelComp`, `PMF.channelJoint`, and
  `PMF.channelExtension`;
- `LeanInfoTheory.Shannon.entropyOf`, `condEntropyOf`, `mutualInfoOf`, and
  `condMutualInfoOf`;
- `LeanInfoTheory.Shannon.IsIndependent`, `IsIndependentOf`,
  `IsMarkovChain`, and `IsMarkovChainOf`;
- `LeanInfoTheory.Shannon.mutualInfoOf_eq_zero_iff_isIndependentOf`;
- `LeanInfoTheory.Shannon.condEntropyOf_eq_zero_iff_exists_function`;
- `LeanInfoTheory.Shannon.condMutualInfoOf_eq_zero_iff_isMarkovChainOf`;
- `LeanInfoTheory.Shannon.mutualInfoOf_deterministic_chain_rule_left`;
- `LeanInfoTheory.Shannon.mutualInfoOf_markov_chain_rule` and
  `mutualInfoOf_dataProcessing`; and
- `LeanInfoTheory.Shannon.isMarkovChain_iff_exists_channelExtension`.

The same pinned surface provides
`LeanInfoTheory.Shannon.fstMarginal` and `sndMarginal` for product PMFs. The
channel-extension equivalence is a one-joint-law factorization theorem; it
does not by itself prove the common-posterior cancellation required by the
implemented prior-free channel contract in `DG-03`.

These are discovery inputs, not a blanket import list. Every chunk must
recheck the declarations it actually uses with focused imports and a compiling
probe.

Additional focused probes confirmed relevant construction surfaces including
`PMF.ofFintype`, `PMF.sum_toReal`, `PMF.supportFinset`, PMF mapping under
equivalences, `Fintype.equivFin`, `Fin.succAbove`, `Fin.predAbove`,
`Matrix.reindex`, `Matrix.mulVec`, `Relation.ReflTransGen`, mathlib
`Finpartition` with `Finpartition.existsUnique_mem` and
`Finpartition.ofExistsUnique`, and the order predicates `IsGreatest` and
`IsLeast`. Convex-hull compactness and strict point-separation support are also
available: the leading finite-coordinate route uses
`geometric_hahn_banach_point_closed` and `dotProductEquiv`. C15 revision 2 approved this
specialized route, now implemented and cumulatively validated through C15
closure. [C16 S03](pfr-c16-readiness-audit.md#generality-and-library-reuse) rechecked
pinned reuse and current consumers; later adoption of a new library API still
requires a separately reviewed upgrade.

The pinned dependencies have no ready paper-specific functional
representation, canonical-representation, perfect-representability,
singular-channel, or split/merge API. They also have no ready finite-PMF
maximal-coupling/total-variation interface and no theorem-level LP
strong-duality layer. Mathlib has useful finite sums, matrices, finite sets,
equivalences, convex geometry, and signed/vector-measure total variation, but
those facilities do not remove the local design work identified below.

No external information-theory formalization repository is an allowed
dependency or discovery source without separate project-lead approval.

<a id="4-proposed-mathematical-and-module-architecture"></a>
## 4. Mathematical and Module Architecture

The implemented architecture follows the mathematical dependencies:

| Layer | Responsibility | Implemented modules |
| --- | --- | --- |
| Semantic | Random-variable functional representations, entropy identity, canonical couplings, perfect representability, singularity, binary cases | `Semantics/FunctionalRepresentation.lean`, `Semantics/Canonical.lean`, `Semantics/Singularity.lean`, `Semantics/Binary.lean` |
| Finite coupling | Finite-PMF total variation, coupling bounds, and maximal coupling; separate bridge to existing Real decoding error | `Probability/FiniteCoupling.lean`; opt-in `Probability/FiniteCouplingDecoding.lean` |
| Finite matrix | Channel-coordinate bridge, singular columns, typed split/merge operations, normal forms, exact partitions, finite PPS/VPS synthesis, preservation, and reachability | `Matrix/Channel.lean`, `Matrix/SingularColumns.lean`, `Matrix/OperationIndices.lean`, `Matrix/Operations.lean`, `Matrix/OperationPaths.lean`, `Matrix/OperationFactorization.lean`, `Matrix/OperationCalculus.lean`, `Matrix/Partitions.lean`, `Matrix/MultiwayOperations.lean`, `Matrix/Preservation.lean`, `Matrix/Reachability.lean`, `Matrix/CanonicalReachability.lean` |
| Optimization | Equal-pattern compression, exact-partition incidence systems, full/reduced equivalence, primal and dual characterizations | `Matrix/PatternCompression.lean`, `Optimization/Incidence.lean`, `Optimization/IncidenceConstruction.lean`, `Optimization/Primal.lean`, `Optimization/Dual.lean`, `Optimization/DualCharacterization.lean` |
| Demonstration | Paper examples and computational checks that should not burden the stable API | focused `Examples/` or `Tests/` modules chosen by the relevant chunk |

The lightweight root imports Basic, FunctionalRepresentation, Canonical,
Singularity, FiniteCoupling and Binary. Optional decoding, matrix, optimization,
examples and tests stay separate. [C16's actual import audit](pfr-c16-readiness-audit.md#isolated-compiled-import-audit-e21)
checks all 26 production and two demonstration closures. Public project-owned
declarations remain in `PerfectFunctionalRepresentations` and its subnamespaces.

Semantic statements should use arbitrary finite alphabets when practical.
`Fin k`, concrete matrices, and enumerations should appear at an explicit
coordinate boundary. Reindexing must be theorem-backed; it must not be hidden
inside casts.

## 5. Decision Gates

These questions are intentionally visible. A chunk plan must resolve the gates
assigned to it before implementation of declarations that depend on them. A
gate remains **Open** until the map records a dated resolution and the approved
chunk plan supplies its exact contract.

| Gate | State | Question and current recommendation | Resolution owner |
| --- | --- | --- | --- |
| `DG-01` | Resolved — 2026-09-04 | Use a layered carrier: a law-level predicate on `q : PMF (alpha × beta × gamma)`, a common-base `...Of` wrapper defined by the full triple pushforward, and a separate law-invariant existential predicate for a pair law. Structural functional representation means independence of the first/third marginal plus existence of a product decoder correct on support, independently of entropy equalities. Fixed-auxiliary perfectness remains distinct from pair perfect representability; the latter is witnessed by `∃ n, ∃ q : PMF (alpha × beta × Fin n)`, with the required pair marginal and perfectness. Equations (1)-(3) and perfectness use exactly the finite-valued hypotheses required by pinned LeanInfoTheory, with no `[Fintype omega]`. Structural fixed-`Z` semantics remain unrestricted; `OM-053` records the deliberate finite-information source interpretation and PFR-C02's later canonicalization obligation. | `PFR-C01` |
| `DG-02` | Resolved — C02 Draft revision 3 approved 2026-09-10 | Represent a marginally canonical auxiliary by a law `q : PMF (alpha -> beta)` whose coordinate pushforwards equal channel rows, but do not mistake those marginals for a canonical representation of an already fixed pair. The pair contract must retain `Y = W_X` on source support and the correct joint law; the channel contract covers every input. | `PFR-C02` |
| `DG-03` | Resolved — C02 Draft revision 3 approved 2026-09-10 | Give channel-level perfect representability a prior-free factorization contract. The approved witness is one posterior `V : beta -> PMF (alpha -> beta)` with `q.map (fun w => (w x, w)) = PMF.channelJoint (kappa x) V` for every `x`. Prove its connection to full-support-prior Markov statements and explain arbitrary null-output fibers. The pinned channel-extension equivalence factors one joint law only; `PFR-C02` must prove the full-support cancellation that yields a single common `V` across all inputs. | `PFR-C02` |
| `DG-04` | Resolved — C03 output contract approved 2026-09-11; C05 input contract approved 2026-09-13 | Separate intrinsic channel cardinality from pair support. Approved C03 Draft revision 2 uses active-output subtype cardinality at most two, exact restriction/inclusion, injective unused-output extension and finite relabeling invariance. S02's finite relabeling and injective output invariance are durably complete. S03's exact active restriction, finite invariance bridges and full-support identification are durably complete. S04 implements sufficiency and the iff for at most two active outputs, with the ambient-cardinality specialization, singleton cases and actual identical-row/deterministic witnesses. All three S04 criteria passed independent validation with no findings; the original report was reconciled. S04 is durably complete, with closure and exact source applicability verified before S05 acceptance. C05 approved revision 2 selects `Fintype.card alpha = 2` intrinsically and full input support only for the ambient equality iff; arbitrary-prior bounds/attainment use a degenerate branch. C05 S02 intrinsic cardinality-two sufficiency and combined Lemma 2 are durably complete. S05 implements the quantitative arbitrary-prior interfaces and explicit-full-input-support equality converse. These mathematical contracts and S06 root integration/readiness are durably complete. S07 cumulative review and original-report reconciliation are complete; final applicable validation, F capture and durable chunk closure are governed by the subsequent execution record. | `PFR-C03` and `PFR-C05` |
| `DG-05` | Resolved — C04 probability contract approved 2026-09-12; C05 semantic contract approved 2026-09-13 | Approved C04 Draft revision 2 selects half-L1 Real TV, ENNReal overlap/residual identities, a product-PMF coupling predicate and explicit attaining witness. S01's TV/overlap foundation is durably complete after independent review and reconciliation. S02 implements the plain-PMF coupling, exact mismatch/event identities and universal bounds, with a separate decoding bridge. All three S02 criteria passed independent review with no findings; the original report was reconciled. S02 durably closed, with closure/source applicability verified before the fresh S03 request. S03 maximal coupling, attainment and support passed independent review with all three criteria satisfied and no findings; the original report was reconciled. S03 is durably complete; S04 probability transport passed independent review/reconciliation and durably closed; S05 root integration/readiness durably closed; S06 independent cumulative review, original-report reconciliation, final validation and durable closure completed. C05 startup verified the completion record and exact prerequisite sources; see the C05 planning notes. C05 revision 2 is approved; S01-S06 durably completed and S07 was separately accepted after exact closure/source verification. Commits and pushes remain unapproved. C05 retains its optimization and pair/prior decisions. Couplings use a PMF on `beta × beta` with existing marginals, exact `ENNReal` construction data and the paper's finite `Real` equality. C05 approved revision 2 realizes the maximum through the new conditional-entropy bridge, a universal finite-auxiliary bound and a finite attaining representation for arbitrary priors; only the ambient equality converse requires full support. These C05 contracts and root integration/readiness are established through durable S06 closure. S07 cumulative review and original-report reconciliation are complete; final applicable validation, F capture and durable chunk closure are governed by the subsequent execution record. | `PFR-C04` and `PFR-C05` |
| `DG-06` | Resolved — C06 revision 2 approved 2026-09-19 | The approved active dependent channel record has finite nonempty input, positive output cardinality and active columns, with separate singularity. Semantic `alpha → PMF beta` remains authoritative; exact/Real matrix views and explicit finite relabeling are proved coordinates. S01-S03 implement exact/Real coordinates, activity and state transport; S04 adds admitted data. | `PFR-C06` |
| `DG-07` | Resolved — C06 revision 2 approved 2026-09-19 | Raw coordinates may include empty inputs and ambient zero columns. The active state requires nonempty input, positive output cardinality and no zero columns. Definition 4 values require an admitted active column and singularity. The nonempty support pattern needs activity alone; no value or pattern is invented for zero columns. State/data implementation is owned by S03/S04. | `PFR-C06` |
| `DG-08` | Resolved by endorsed C07 revision 2 and S01 request, 2026-09-21 | The [approved contract](plans/pfr-c07-four-typed-matrix-operations.md) uses adjacent insertion, deletion of the higher merge index, PMF bind/map constructions, strict PPS ratios and two nonempty pieces of the selected VPS support. It adopts the intended VPS range `0 < beta <= 1`, retaining the printed strict bound as an explicit source departure. Four witness-parameterized recovery directions use exact adjacent equality or specified nonadjacent output equivalence. The strict-domain five-operation C09 alternative remains an unselected historical option, not added scope. S01 implements only indices/raw semantics; approval does not establish later proofs. | `PFR-C07` |
| `DG-09` | Resolved by endorsed C08 revision 2 and S01 request, 2026-09-26 | [Approved C08 revision 2](plans/pfr-c08-operation-paths-lemma4-normalization.md) selects Type-valued witnessed C07 edges with `Quiver.Path`, chronological tags, directed output equivalences and concrete three-stage paths. `Relation.ReflTransGen` was evaluated as a Prop-valued alternative. S01 durably completed this foundation and the endpoint packages. S02 ordered equivariance and cascade composition are durably complete. S03 implements all local interchange cases and directed coordinates; all three independent S03 criteria are satisfied without findings, and the original report is critically reconciled. Subsequent final validation and durable S03 closure completed. S04 implements the private finite certificate and append invariants; all three independent S04 criteria are satisfied without findings; the original report is critically reconciled. Final validation/F and durable S04 closure completed. S05 implements concrete realization and global normalization; focused/default validation and the signature/axiom audit pass; independent S05 review satisfies all three criteria without findings and is critically reconciled. S05 final validation and durable closure completed; S06 startup verified its exact final source. S06 integrated consumers and readiness are durably complete. S07 freshly checked cumulative coverage and the structural proof; the original independent report is reconciled. Final validation/F and durable closure follow the maintained pre-F checkpoint. Expanding rewrites are not assumed to terminate. Approval does not establish those proofs. | `PFR-C08` |
| `DG-10` | Resolved — C06 contract approved 2026-09-19; C12 revision 2 approved 2026-09-29 | C06 keeps exact ENNReal masses, derives Real bounds/row sums and proves both numeric reconstruction directions; admitted column values have derived bounds/finiteness and exact Real recovery. S01-S02 implement the numeric coordinate foundation and S04 owns admitted value bounds/reconstruction. C12 retains aggregation, compressed-data validity and the optimization-facing numeric boundary. Its [approved revision-2 contract](plans/pfr-c12-active-pattern-compression-real-bridge.md#45-ambient-and-numeric-interface-boundaries) uses exact aggregates, positive Real pattern values and row normalization, with a generic reconstruction converse; C13 retains feasibility-derived partition-weight normalization. Approval resolves the design gate; S01 implements intrinsic occurrence/exact compression and is durably complete. S02 retained PPM compression, PPS reversal and constructive reachability transport are durably complete after validation, independent review and original-report reconciliation. S03 exact Real aggregates, minimal valid data and full generic recovery are durably complete after independent review and original-report reconciliation. S04 implements actual ambient recovery, exact/Real injection and enumeration transport, and the prior-free channel-to-valid-data perfectness bridge; implementation validation passes; independent review is reconciled; final S04 closure remains pending. That S04 checkpoint is historical: S04 durably closed; S05 verified all 145 final entries and freshly validated the full C12 boundary. Cumulative independent review is reconciled; final applicability/F and supported closure remain. C13 startup subsequently verified durable C12 S05 closure and all 145 final entries; the preceding finalization checkpoint remains historical. | `PFR-C06` and `PFR-C12` |
| `DG-11` | Resolved — C10 revision 2 approved, 2026-09-28 | The [approved plan](plans/pfr-c10-generic-reachability-easy-direction.md#52-dg-11-resolution-exact-finite-partitions) selects pinned mathlib `Finpartition` with a minimal labelled-family adapter, an explicit supplied-label-to-block bijection and internal classical decidability. C10-S02 implements the exact-partition interface for multiway VPS and decoder fibers; patterns remain nonempty support finsets. Internal `DecidableEq` does not become a mathematical public assumption. C13 owns enumeration, incidence and ordered matrix presentations. Approval resolves the representation choice. S02 now implements the three-declaration adapter over mathlib with exact supplied-block equations; R05-R06, final validation and independent review completed successfully; S03 startup verified durable S02 closure and exact source applicability. | `PFR-C10` and `PFR-C13` |
| `DG-12` | Resolved — C13 revision 2 endorsed, 2026-09-30 | Reject the literal ISIT `m × R` system that retains all Bell partitions while dropping unobserved-pattern rows. Make the extended full all-nonzero-pattern system and the reduced admissible occurring-pattern system separate objects connected by a proved equivalence for nonnegative equality feasibility. The qualifier is essential: without nonnegativity, coefficients on inadmissible partitions can cancel on omitted rows. The reduced dual has `m` variables; do not transfer that count to the full encoding. Approved C13 revision 2 (2026-09-30) fixes the exact contract in [Sections 4.2-4.3](plans/pfr-c13-exact-partitions-incidence-systems.md#42-full-and-reduced-incidence), including per-vector inverse laws and mixed/signed regressions. Approval resolves the design choice. S01 coordinates and dimensions are durably complete. S02 implements nonnegative equivalence and per-vector inverse laws; concrete weight regressions and independent review pass; the original report is reconciled. No signed or inequality equivalence is asserted. | `PFR-C13` |
| `DG-13` | Resolved — C14 complete, 2026-10-01 | Reduced-data bound, saturation, attained greatestness, ambient singular wrappers and entire finite objective image are implemented and cumulatively validated. C15 startup verified supported S04 closure, all twelve closing criteria, original reports and exact final-source applicability; historical pre-F documents are unchanged. See [C15 planning notes](pfr-c15-planning-notes.md). C16 retains the broader wrapper decision. | `PFR-C14` |
| `DG-14` | Resolved — C15 complete, closure verified 2026-10-02 | Reduced-data separation/leastness, ambient singular corollary, finite all-vector transport, inverse and entire-image equality, exact reduced count and cumulative validation are complete. C16 startup verified supported S05 closure, all fifteen criteria, five original-report reconciliations and all 174 final source/environment entries. Historical pre-F records remain unchanged; see [C16 planning notes](pfr-c16-planning-notes.md). No generic LP framework or global optimizer. C16's approved plan retains the no-wrapper default, subject to its S03 consumer audit. | `PFR-C15` |
| `DG-15` | Resolved — C16 S03 ownership audit, 2026-10-03; independent criteria satisfied; original report reconciled | [Item-by-item audit](pfr-c16-readiness-audit.md#c16-s03-dg15) checks Remark 1 public law/prior bridges, Example 1 four named declarations, private ISIT Examples 2–7 and v16 Examples 2–8 (including C10 reachability), documentation-only Remark 2, and private Figure 1 proof content. Existing consumers need no fixture/helper promotion. All source repairs, finite/support hypotheses and OM-010–012/020/024/026/033/047/050/057/069/070 rationale remain intact. | Owning modules retain their APIs; C16 S04/S05 integrate and freshly validate this disposition |

## 6. Dependency Graph and Checkpoints

The main dependency shape is:

```text
Semantic:
  PFR-C01 -> PFR-C02 -> PFR-C03
  PFR-C04
  (PFR-C02, PFR-C03, PFR-C04) ----> PFR-C05

Matrix and reachability:
  (PFR-C02, PFR-C03) -> PFR-C06 -> PFR-C07 -> PFR-C08
  (PFR-C02, PFR-C06, PFR-C07) ------> PFR-C09
  (PFR-C08, PFR-C09) -------------> PFR-C10 -> PFR-C11

Optimization:
  (PFR-C06, PFR-C07, PFR-C08, PFR-C09, PFR-C10) -> PFR-C12
  (PFR-C10, PFR-C11, PFR-C12) ----------> PFR-C13
  PFR-C13 -> PFR-C14 -> PFR-C15

Closure:
  all in-scope chunks -> PFR-C16
```

`PFR-C04` is an infrastructure branch with no project-code prerequisite and
can proceed independently under its own approved plan. `PFR-C05` joins the
semantic and coupling branches by completing the binary-input part of Lemma 2
and Lemma 3. `PFR-C10` introduces the minimal
exact-partition interface already needed by its multiway split constructors;
`PFR-C11` reuses it for decoder fibers, and `PFR-C13` later builds the
incidence systems on top. Pattern compression in `PFR-C12` can complete once
the operation paths and preservation interfaces are stable. Although
read-only design work for `PFR-C13` may start from `PFR-C12`, a single
production plan for that chunk must not be approved or implemented until
`PFR-C10` and `PFR-C11` are complete.

The following waves are concurrency guidance for separate tasks, not approval
or a promise that every wave remains unchanged:

| Wave | Candidate chunks | Coordination condition |
| --- | --- | --- |
| 1 | `PFR-C01` and `PFR-C04` | Dependency-independent, but each still needs a separate approved plan |
| 2 | `PFR-C02` | Establish the canonical/channel contract after C01 |
| 3 | `PFR-C03` | Requires the channel contract from C02 |
| 4 | `PFR-C05` and `PFR-C06` | May proceed in parallel after C03, with C05 also requiring C04 |
| 5 | `PFR-C07` | Fix the changing-output operation API |
| 6 | `PFR-C08` and `PFR-C09` | May proceed in parallel after C07 if shared interfaces are frozen |
| 7 | `PFR-C10` | Establish multiway cascades and the minimal partition interface |
| 8 | `PFR-C11` and `PFR-C12` | May proceed in parallel after C10, with separate owned modules |
| 9 | `PFR-C13` | Begin implementation only after C10-C12 are complete |
| 10 | `PFR-C14`, then `PFR-C15`, then `PFR-C16` | Optimization and closure remain sequential |

No two active tasks should edit a shared owner module without an explicit
coordination handoff. Each detailed plan must name its exact predecessor
commits, owned files, and imported public interfaces.

If a later chunk exposes a defect in an earlier interface, it triggers a
reviewed map/plan revision; it does not mutate the earlier contract silently.
Suggested global review checkpoints are:

1. after `PFR-C02`: semantic and prior-independence contract;
2. after `PFR-C06`: semantic-to-matrix, active-column, and numeric boundary;
3. after `PFR-C10`: tagged operation paths, multiway cascades, and the minimal
   exact-partition interface;
4. after `PFR-C11`: complete constructive characterization;
5. after `PFR-C13`: full/reduced pattern-system contract; and
6. after `PFR-C14`: primal formulation before committing to the dual
   separation proof.

Separate Codex tasks may own separate chunks, but each task must start from the
exact approved baseline and reconcile canonical documents. Parallel work is
appropriate only for dependency-independent chunks and coordinated files.

<a id="7-candidate-chunks"></a>
## 7. Chunk Allocations

### PFR-C01 — Semantic Functional Representations

**Current completion overlay, 2026-10-03:** C01 is **Complete**.
[Verified handoff and preserved records](pfr-c16-readiness-audit.md#c16-history-c01)
establish later closure; any pre-F status below remains its original checkpoint.

**Status:** Complete — Draft revision 2 approved 2026-09-04; S01-S08 validated.
S08 was explicitly authorized on 2026-09-07; independent chunk-wide validation
and canonical completion reconciliation passed that day.
**Approved plan:**
[PFR-C01 semantic functional representations](plans/pfr-c01-semantic-functional-representations.md).
**Planning baseline:** repository commit
`d9f63e713eab6f778132dc6888420adb442d0802`.
**Execution baseline:** approval-checkpoint commit
`5a9c7ca999639afe26c7bf235b4d044e0341b55a`.
**Anchors:** ISIT Section I, including the unnumbered distinction between a
specified perfect auxiliary and a perfectly representable pair, and Equations
(1)-(3).
**Prerequisites:** pinned `PMF` and LeanInfoTheory semantic bridge.
**Risk:** medium.
**Approved module:** `Semantics/FunctionalRepresentation.lean`.

S01-S03 now provide the structural predicates and expansion, full-triple-law
transport, independence under deterministic right-postprocessing, and the
Equation (1) equivalence `isFunctionalRepresentationOf_iff_zero_conditions`.
Equation (1) requires finite value alphabets but no finite source assumption,
and preserves existential decoding correct only on support. S04 adds
`mutualInfoOf_eq_pfr_decomposition`, the exact unconditional Equation (2)
identity with finite value alphabets and an unrestricted source type; it does
not require functional representation. S05 adds four methods requiring the
structural representation premise: Equation (3), its upper bound, equality
iff `I(X;Z|Y) = 0`, and equality iff `X - Y - Z` is Markov. They retain exactly
the three finite value alphabets and unrestricted source, without requiring
full support or a chosen conditional law on null fibers. S06 adds the
fixed-perfect law/common-base predicates, equality/zero-CMI/Markov
equivalences retaining structural representation, and full-triple-law
transport. Its separate existential pair predicates admit a perfect
`Fin n` triple-law extension with the prescribed pair marginal, transport by
pair-law equality, and accept any finite perfect auxiliary through
`Fintype.equivFin`, including higher-universe auxiliaries. No auxiliary on
the original source or redundant positivity premise is imposed. This is
the approved finite-information boundary, not a new cardinality bound or
the later C02 canonicalization result.
S07 exposes this 23-declaration semantic module through the lightweight project
root, retaining the dependency smoke test and excluding the separate regression
module. No source allocation, decision-gate disposition, or later chunk is
changed by this integration.
S03 validation is recorded in
[project log entry 16](project-log.md#16-pfr-c01-s03-equation-1---2026-09-05),
S04 validation in
[project log entry 19](project-log.md#19-pfr-c01-s04-equation-2---2026-09-06),
S05 validation in
[project log entry 22](project-log.md#22-pfr-c01-s05-equation-3---2026-09-06-to-2026-09-07),
S06 validation in
[project log entry 25](project-log.md#25-pfr-c01-s06-fixed-and-existential-perfectness---2026-09-07),
and the S07 internal milestone in
[project log entry 28](project-log.md#28-pfr-c01-s07-integration-and-internal-milestone---2026-09-07).
S08 independent validation and completion, including approved-source recovery,
are recorded in
[project log entry 31](project-log.md#31-pfr-c01-s08-independent-validation-and-chunk-completion---2026-09-07).

The completed chunk's approved scope was to:

- choose and document the common probability-space or joint-law carrier used
  for pair-level random variables, with transport lemmas sufficient to avoid
  dependence on an accidental sample-space presentation;
- define a support-aware semantic functional representation of `(X,Y)` by
  an auxiliary `Z` and existence of a decoder correct almost surely;
- distinguish a specified auxiliary `Z` being a perfect functional
  representation from the pair `(X,Y)` being perfectly representable via some
  finite auxiliary on an extension of the pair law, rather than only on the
  original source space;
- prove the fixed-`Z` equality, zero-CMI, and Markov formulations equivalent;
- connect independence and deterministic decoding to the two entropy/mutual
  information zero conditions in Equation (1);
- formalize the exact identity in Equation (2);
- derive Equation (3), including its equality condition
  `I(X;Z | Y) = 0`;
- identify that equality with the Markov chain `X - Y - Z` through the pinned
  LeanInfoTheory API; and
- prove the deterministic-postprocessing independence fact needed when a
  canonical vector is constructed as a function of `Z`.

The structural representation predicate should not require an entropy
equality merely to be well-formed. The chunk should not reprove the externally
cited general existence theorem for functional representations. Completion
requires exact nats-valued statements, explicit finite hypotheses on every
information-valued random variable including `Z`, source-support decoding,
focused imports, and tests for deterministic and degenerate cases.

### PFR-C02 — Canonical Representations and the Channel Property

**Current completion overlay, 2026-10-03:** C02 is **Complete**.
[Verified handoff and preserved records](pfr-c16-readiness-audit.md#c16-history-c02)
establish later closure; any pre-F status below remains its original checkpoint.

**Status:** Complete — Draft revision 3 approved 2026-09-10 by the lead's
request to begin S01 with review; see
[the C02 plan](plans/pfr-c02-canonical-representations.md). S01-S07 are complete.
S02's Equation (5) construction and structural properties 1-3 passed
implementation and independent validation. S03's property 4, Lemma 1,
Equation (7) and finite canonical sufficiency also passed implementation and
independent validation and are durably complete. S04's Definition 2,
common-posterior factorization and support-aware Markov connection passed
implementation and independent validation and are durably complete. S05's
law reuse and all-prior/full-support pair equivalences passed implementation
and independent validation and are durably complete. S06 input-support
transport and arbitrary-prior equivalence are also durably complete. S07
exposes Canonical through the lightweight root, covers R12/R13 and audits
cumulative readiness and is durably complete. S08's fresh cumulative review
satisfied all fourteen criteria and was explicitly reconciled. The durable
S08 closure is `5a59434952e2e5776a0f29166b957a7eb389eccae723552944a671ec9ee684e0`;
C03's read-only prerequisite check confirmed it and exact startup applicability.
The same persistent reviewer remains bound to C02; no independent plan review
was requested. C03 also completed its separately approved plan. See the
[readiness audit](pfr-c02-readiness-audit.md).
**Anchors:** ISIT Section II-A, Equations (5)-(7), Definition 1, Remark 1,
Lemma 1, Definition 2; current extended Section II-A.
**Prerequisite:** completed `PFR-C01`, with the public guarantees and
non-guarantees in Section 14 of its approved plan. Private proof helpers are
not a downstream API. S03 establishes finite canonical sufficiency at the
approved finite-information boundary; S04 implements the channel
contract and S05 implements the full-support prior equivalences; input-support
transport passed independent S06 validation. DG-02 and DG-03
are resolved by exact plan approval.
**Risk:** high because it fixes the semantic API used by every later chunk.
**Implemented module:** `Semantics/Canonical.lean`, exposed by the root in S07.

This chunk should:

- distinguish a marginally canonical finite coupling law on
  `alpha -> beta` from a canonical representation of a fixed pair, and prove
  the coordinate-marginal contract for the former;
- make the latter retain the joint-law/decoder condition `Y = W_X` on source
  support rather than treating coordinate marginals and independence alone as
  sufficient;
- construct the canonical vector induced by any semantic representation and
  prove the four properties listed before Definition 1;
- prove Lemma 1, including the equality `I(Y;W) = I(Y;Z)` and the
  sufficient-to-focus-on-canonical corollary;
- define channel-level perfect representability without dependence on an
  accidentally degenerate input prior;
- test the preferred prior-free contract: one posterior
  `V : beta -> PMF (alpha -> beta)` factors every coordinate joint law as
  `q.map (fun w => (w x, w)) = PMF.channelJoint (kappa x) V`;
- prove the paper-facing `pW|Y`/Markov characterization needed by Definition
  2, including the converse from a full-support prior;
- prove the cancellation/common-posterior step that turns a full-support
  pair-level Markov factorization into one posterior valid for every channel
  input, rather than attributing it to the pinned one-joint-law channel
  extension theorem; and
- formalize the prior-independence content of Remark 1 with explicit support
  qualifications.

Exact plan approval settled `DG-02` and `DG-03` before declaring the public
API. Pair-level statements may transport to the input-law support, whereas the
intrinsic channel contract covers every input of its declared input alphabet.
Null fibers, globally unused outputs, and zero-prior input symbols are
mandatory test cases.

Approved Draft revision 3 has eight steps through independent closeout, separating
full-support prior equivalences from input-support value-type transport.
Step identities and references now follow execution order S01-S08.
Its DG-02/DG-03 resolutions are approved; implementation and proof acceptance
remain step-specific. Focused pinned-source discovery found that
`PMF.channelJoint_eq_iff_eq_on_support` already supplies the mass-cancellation
boundary; C02 still owns the canonical-law reassociation and common-posterior
bridge. OM-054/OM-055 retain the Remark 1/Definition 2 interpretation
boundaries. S07 reconciles all C02 omission dispositions against the source
without deletion, renumbering or a new gate resolution. The global chunk
dependencies and C03 completion prerequisite are unchanged.

### PFR-C03 — Singularity Core, Binary Output, and Counterexample

**Current completion overlay, 2026-10-03:** C03 is **Complete**.
[Verified handoff and preserved records](pfr-c16-readiness-audit.md#c16-history-c03)
establish later closure; any pre-F status below remains its original checkpoint.

**Status:** Complete — [Approved Draft revision 2](plans/pfr-c03-singularity-binary-output-counterexample.md),
2026-09-11. The lead authorized evaluating both revision-1 reviews and revising
the proposal. Revision 2 corrects the API/omission citations, clarifies proof
mechanics and R08 ownership, and adds an anonymous negative output-embedding
consumer R15 in S06. Mathematical contracts, seven steps and chunk allocation
remain. The lead subsequently approved exact revision 2 and requested S01 with
review. Revision 1 retains its original report assessments; no separate
revision-2 plan review is claimed. See [revision record](project-log.md#50-c03-draft-revision-2-after-both-reviews---2026-09-11).
C01/C02 prerequisites were verified, including actual C02 S08 closure and its
current-source applicability. See [planning notes](pfr-c03-planning-notes.md)
and project log entry 48. S01 now implements the generic intrinsic predicate,
positive-product equivalence and perfect-implies-singular theorem, with R01-R03.
All three criteria passed independent review with no findings, and its durable
closure/source applicability were verified at S02 start. S02 adds both predicates'
finite input/output relabeling and injective output-extension iff theorems, with
full joint/posterior transport and R04-R05. All three criteria passed independent
review with no findings; the original report was reconciled and S02 durably closed.
The separate conditional S03 request was accepted after verifying that closure
and exact current-source applicability. S03 implements `activeOutputs`,
`restrictActiveOutputs`, exact masses and inclusion recovery without
renormalization, activity/nonemptiness, finite singularity/perfectness equivalences,
and the output-support/prior relationship with full-support identification.
R06-R07 and R08's structural empty/singleton portion passed independent validation.
All three S03 criteria are satisfied with no findings, and the original report
was explicitly reconciled. Independent aggregate/full builds, all nine new public
signature/axiom checks and the placeholder scan passed, followed by durable S03
closure. The separate conditional S04 request was accepted after verifying that
closure and exact source/environment/Git applicability. S04 implements
singularity/perfectness equivalence for at most two active outputs, its
ambient-cardinality-at-most-two specialization, actual identical-row and
deterministic common-posterior witnesses, and R08's sufficiency portion/R09-R11.
The final contracts retain finite alphabets, nonempty input and the cardinality
bound; chosen enumerations, strict probability bounds, public defaults and priors
are not additional hypotheses. All three S04 criteria passed independent validation
with no findings; the original report was explicitly reconciled. Independent
aggregate/full builds, both public signature/axiom checks, the placeholder scan
and all 68 real-file plus six supplemental-reference hashes passed against R.
S04 is durably complete; its closure and all 68 real files, exact bytes,
environment/Git facts, normative plan, binding and clean pins were verified
against F before S05 acceptance. S05 implements the named `Fin 3` channel, exact
nine entries and normalized rows, singularity and direct universal negative
theorem in the separate example module. R12-R13 check all three active outputs,
generic full-support and uniform negative pairs, and a positive support-restricted
witness for any point prior. The existing `coordinate_eq_of_posterior_support`
helper is now public in `Semantics/Singularity.lean` for S01/S05 reuse, with its
statement and proof unchanged. All three S05 criteria passed independent validation
with no findings; the original report was explicitly reconciled. Independent
aggregate/full builds, all five public signature/axiom checks and the hashes of
all 70 real inventory files and eight supplemental dependencies passed.
S05 is durably complete. Its closure and all 70 real files, exact bytes,
environment/Git facts, normative plan, binding and clean pins matched F before
S06 acceptance. S06 now imports Singularity through the lightweight root and
makes semantic regressions consume that root for R14; R15 is maintained in the
existing separate example tests. The [readiness audit](pfr-c03-readiness-audit.md)
is populated. All three S06 criteria passed independent review with no independent
findings; the original report was explicitly reconciled. Independent aggregate/full
builds and all 23 public signature/axiom checks passed, with only `propext`,
`Classical.choice` and `Quot.sound`; all 71 real-file and nine supplemental hashes
matched at entry and exit. S06 adds no public theorem or production proof change.
S06 durably closed under `f228cae1eee80a5fd96845287e39e107648f90aef8ab4d9bfd3744b200865ae0`.
Its F `249f20a5623a0d6e85ae0b376f2b6fb3a5e75fe8325ab142eec04ac09e7ccdfb`
matched all 71 real files, exact bytes, environment/Git facts, normative plan,
binding and clean pins before S07 acceptance at B
`c368387c3191b6a81b70c4bc19a660062d3ece1bf0e8ba40b15864442471d266`.
S07 fresh cumulative validation and independent review passed with all three step
criteria satisfied and no findings, freshly covering all ten C03 completion rows
and all eighteen earlier step criteria. The original report was reconciled.
C04 startup verified S07 closure
`8a0d64e10a0a823477ab423f0e653149191afbc110c11863ef59164493a103d1`,
all original-report reconciliation and exact F/source applicability. C03 is
complete. The original plan and closed records are unchanged; see entry 59.
C05's binary-input/combined Lemma 2 allocation is unchanged. See
[implementation notes](pfr-c03-implementation-notes.md).

**Anchors:** ISIT Section II-B, Definition 3, Lemma 2, Equation (8), Example 1;
current extended Appendix A and its Lemma 7 proof.
**Prerequisite:** `PFR-C02`.
**Risk:** high.
**Modules:** `Semantics/Singularity.lean`, including the shared posterior-support
coordinate lemma, is imported by the lightweight root under durably completed
S06. S05 adds separately importable `Examples/Nonrepresentable3x3.lean`
and `Tests/Examples/Nonrepresentable3x3.lean`. The four example declarations are
`nonrepresentable3x3`, `nonrepresentable3x3_apply`, `nonrepresentable3x3_isSingular`
and `nonrepresentable3x3_not_isPerfectlyRepresentableChannel`; the test module owns
R12-R13 and R15.

This chunk should:

- define singularity intrinsically for arbitrary channel alphabets (S01);
- prove that perfect representability implies singularity;
- define or select the channel's active-output union and prove the restriction
  and ambient-zero-output invariance needed by the binary-output statement;
- prove singularity is sufficient when that active output alphabet has at most
  two elements, including one-output, identical-row, and deterministic edge
  branches;
- prove singularity and perfect representability are invariant under finite
  input/output relabeling;
- formalize the displayed `3 × 3` singular channel; and
- prove directly that the example is not perfectly representable.

The binary-input direction of Lemma 2 is deliberately postponed to
`PFR-C05` because its clean proof shares the maximal-coupling infrastructure
needed by Lemma 3. The final paper-facing combined Lemma 2 is also exposed
there. Its intrinsic channel statement uses a two-element input alphabet;
pair-level corollaries must separately expose support restriction or a
full-support prior.

### PFR-C04 — Finite Total Variation and Maximal Coupling

**Current completion overlay, 2026-10-03:** C04 is **Complete**.
[Verified handoff and preserved records](pfr-c16-readiness-audit.md#c16-history-c04)
establish later closure; any pre-F status below remains its original checkpoint.

**Status:** Complete — [approved Draft revision 2](plans/pfr-c04-finite-total-variation-maximal-coupling.md),
2026-09-12. S01's finite-TV/overlap foundation passed independent review
with all three criteria satisfied and no findings; the original report was
reconciled and S01 durably closed. The fresh S02 request was accepted after
closure/source verification. S02 coupling/mismatch bounds and the separate
decoding bridge are implemented. S02 passed independent review with all three criteria satisfied and no findings;
the original report was reconciled. S02 durably closed; its closure and exact source applicability were verified
before accepting the fresh S03 request. S03 implements the explicit maximal coupling, exact attainment and
support/endpoint contracts. All three S03 criteria passed independent review with no findings; the
original report was reconciled and S03 durably closed. Its closure and exact
source applicability were verified before accepting the fresh S04 request.
S04 implements injective relabeling, swap and C05 probability consumers.
All three S04 criteria passed independent review with no findings; the original
report was reconciled and S04 durably closed. Its closure and exact source
applicability were verified before the fresh S05 request was accepted.
S05 durably closed after independent review, original-report reconciliation and final validation. Its closure and exact final source applicability were verified before the fresh S06 request. S06 independent cumulative review, original-report reconciliation, final validation and durable closure completed. C05 startup verified the completion record and exact prerequisite sources; see the C05 planning notes. For C05's current S07 cumulative review/closeout status and verified S01-S06 closure, see [C05 implementation notes](pfr-c05-implementation-notes.md). Commits and pushes remain unapproved. The original
revision-1 report remains historical; no separate revision-2 plan review is
claimed. Six approved steps separate TV identities,
universal mismatch bound, explicit construction, transport/C05 consumers,
integration and independent closeout. See [implementation notes](pfr-c04-implementation-notes.md).
**Anchors:** ISIT Section II-C Equation (9), PDF p. 2; extended version 16
Appendix A, PDF p. 14, (156)-(161) and the following attainment sentence.
The detailed maximal-coupling argument is in the extended proof, not ISIT.
Extended p. 12 (111)-(122) was consulted for C05 common/exclusive-mass needs;
its channel proof and pp. 13-14 conditional-entropy/optimization remain C05.
**Prerequisites:** pinned finite `PMF` infrastructure only; independent of the
semantic chunks.
**Remaining work/risk:** the explicit probability API and transport are now
implemented and durably validated through S04. S05 root integration and readiness durably closed after independent review/reconciliation and final validation. S06 independent cumulative review, original-report reconciliation, final validation and durable closure completed. C05 startup verified the completion record and exact prerequisite sources; see the C05 planning notes. For C05's current S07 cumulative review/closeout status and verified S01-S06 closure, see [C05 implementation notes](pfr-c05-implementation-notes.md). Commits and pushes remain unapproved.
C05 quantitative contracts and root/readiness are durably complete through S06; current cumulative closeout work is recorded in the [C05 implementation notes](pfr-c05-implementation-notes.md).
**Module:** `Probability/FiniteCoupling.lean` implements the S01 TV/overlap foundation
and S02 coupling/mismatch/event bounds. S03 adds the normalized attaining
construction, exact atoms, support and endpoint contracts, independently
validated with the original report reconciled. S04 adds simultaneous injective
map and swap contracts, with R11-R14 and the exact
[C05 probability handoff](pfr-c04-implementation-notes.md#c05-probability-handoff).
S05 now exposes the core through the root, adds a root-only R15 consumer and
prepares the [readiness audit](pfr-c04-readiness-audit.md); it adds no theorem target.

S02 also implements the approved small separately importable
`Probability/FiniteCouplingDecoding.lean` bridge to the existing
`LeanInfoTheory.Shannon.decodingErrorProbability` specialization in Fano.
The independently importable coupling core excludes Fano/KL; the root gains
neither this bridge nor its Fano dependency. The root's existing KL dependency
through semantic modules remains unchanged. No new Real decoder-error theory
or restructuring of earlier semantic modules is proposed.

This chunk should:

- define finite-PMF total variation in `Real`; the approved plan selects
  Equation (9)'s half-`L1` definition and proves the exact overlap and
  positive-part finite-sum forms; S01 owns this approved foundation;
- define a finite coupling as a PMF on the product alphabet, reuse its first
  and second marginals, and define mismatch probability;
- prove the universal mismatch lower bound by total variation;
- construct an explicit finite maximal coupling attaining that bound,
  including TV-zero, TV-one, disjoint-support, and zero-common-mass cases; and
- retain exact `ENNReal` construction identities alongside the derived `Real`
  probability statement; and
- prove the overlap/minimum-mass and relabeling facts needed by `PFR-C05`.

This is genuine finite probability infrastructure, not yet a paper theorem.
It stays project-local initially. Any later upstream proposal requires
separate review after downstream use establishes the right interface.

### PFR-C05 — Binary-Input Completion and Lemma 3

**Current completion overlay, 2026-10-03:** C05 is **Complete**.
[Verified handoff and preserved records](pfr-c16-readiness-audit.md#c16-history-c05)
establish later closure; any pre-F status below remains its original checkpoint.

**Status:** Active approved Draft revision 2, 2026-09-13; S01-S06 durably
complete after independent review, original-report reconciliation and final
validation. S06 closure and exact final-source applicability were verified
before the separate S07 request was accepted. Fresh S07 cumulative validation
and independent review are complete; the complete original report has been
critically reconciled. Final cumulative/default builds and source-impact checks pass; F capture and durable completion are governed by the subsequent execution record. The
[readiness audit](pfr-c05-readiness-audit.md) records all eighteen earlier
step criteria, R01-R18 and ten completion outcomes. Earlier validation and
favorable reviews remain historical evidence.

S01-S05 establish the binary law/coordinate boundary, singular input
sufficiency and combined Lemma 2, entropy/mismatch identity, arbitrary-prior
information bounds and finite attainment, singular forward equality and the
full-input-support ambient-channel converse, with semantic transport and
R01-R17. S06 maps all fifteen earlier criteria, R01-R18 and the ten completion
outcomes to source and actual validation evidence, preserving the optional
decoder/test/example import boundary. Source-bound chronology, prior failed
checks and exact closure/startup references remain in the
[implementation notes](pfr-c05-implementation-notes.md). Revision-1 independent
review/reconciliation remain historical; no separate revision-2 plan review is claimed.
**Approved plan:** [Draft revision 2](plans/pfr-c05-binary-input-lemma3.md);
seven dependency-based steps, eighteen regressions and ten cumulative
readiness outcomes. Own persistent reviewer established; see
[planning evidence and prerequisite reconciliation](pfr-c05-planning-notes.md).
C02/C03/C04 durable completion and applicable source were verified without
reopening their closed contracts or treating inherited work as new C05 work.
**Anchors:** binary-input clause of ISIT Lemma 2; ISIT Section II-C,
Equation (10), Lemma 3; current extended v16 Appendix A p. 12 (111)-(124)
for binary-input sufficiency and pp. 13-14 (147)-(166) for Lemma 3.
**Prerequisites:** `PFR-C02`, `PFR-C03`, and `PFR-C04`.
**Risk:** high.
**Module:** `Semantics/Binary.lean`; the lightweight root imports it, and its direct import remains available. Root/API/import integration and R18 are durably validated through S06; S07 fresh cumulative review and reconciliation are complete, with final validation/closure governed by the subsequent execution record.

This chunk should:

- prove singularity is sufficient for an intrinsic channel whose input
  alphabet has cardinality two;
- expose the final combined paper-facing Lemma 2 from the three separately
  proved clauses;
- connect binary canonical couplings, mismatch events, and conditional
  entropy;
- prove that every finite-auxiliary binary-input functional representation
  of a specified channel pair law satisfies `I(Y;Z) <= H(Y) - r H(X)` for
  every prior, with a separate degenerate-prior branch;
- construct a finite representation attaining the bound, which gives a
  type-safe Lean meaning to the manuscript's “maximum”; and
- prove `r H(X) = I(X;Y)` exactly in the singular case under the correct
  binary/full-support contract.

Construction-heavy arguments may use `Fin 2` and transport through a checked
cardinality-two equivalence. The approved revision selects explicit full
input support for the ambient-channel
equality iff, while the bound and finite attaining representation allow every
prior. It supplies a point-prior branch and leaves the optional larger ambient
input-support theorem family outside this contract. DG-04/DG-05 were resolved
by exact C05 revision-2 approval on 2026-09-13. A
degenerate-prior regression test is mandatory: without full input support,
`r H(X) = I(X;Y)` can hold for a nonsingular ambient channel.

### PFR-C06 — Finite Channel-to-Matrix Boundary

**Current completion overlay, 2026-10-03:** C06 is **Complete**.
[Verified handoff and preserved records](pfr-c16-readiness-audit.md#c16-history-c06)
establish later closure; any pre-F status below remains its original checkpoint.

**Status:** Complete under approved [revision 2](plans/pfr-c06-finite-channel-matrix-boundary.md).
C07 startup verified durable S06 closure
`ff1ee497358f72b2becfa2d490fe0b3c8e425dfaeba9ec7157b6e365d6516d96`, original
report/reconciliation and all 101 final source/environment entries. See
[C07 planning notes](pfr-c07-planning-notes.md). The following checkpoint is
historical; its subsequent closure is not rewritten into the closed records.

**Historical pre-F checkpoint:**
S01-S05 durably complete with original independent reports reconciled. S05's
exact final snapshot and all predecessor records were verified before the
fresh S06 cumulative-validation request. S06 fresh cumulative independent review and
reconciliation are complete, with all fifteen earlier criteria, R01-R16 and
CC01-CC10 accounted for and no findings. Final validation/F/durable closure
follow this checkpoint.
The same persistent reviewer is retained. No separate plan review is claimed;
C07 remains unapproved. See [implementation notes](pfr-c06-implementation-notes.md)
and [readiness audit](pfr-c06-readiness-audit.md).
**Anchors:** ISIT opening of Section III and Definition 4; current extended
Section III-A.
**Prerequisites:** `PFR-C02` and `PFR-C03`.
**Risk:** high because this chunk fixes changing-dimension and numeric
interfaces.
**Implemented modules:** `Matrix/Channel.lean` and `Matrix/SingularColumns.lean`.
The approved plan specifies a dependent record over finite nonempty input, with positive
output cardinality and active columns; singularity remains a separate premise.
It retains exact/Real two-sided reconstruction, nonempty support-finset patterns,
their division bridge and explicit reindexing. DG-06/DG-07 and C06's portion
of DG-10 are approved contracts; implementation remains step-specific.
C12 retains its DG-10 duties.

This chunk should:

- define or select an active heterogeneous finite channel state, based on
  `Sigma fun m => alpha -> PMF (Fin m)` only after adding nonempty-input,
  positive-output-cardinality, and nonzero-column invariants, and prove its
  relationship with arbitrary finite output alphabets;
- expose the exact `ENNReal` mass matrix and a proved derived `Real` view
  without making either a second probability object;
- prove the channel and matrix formulations of singularity agree;
- require the positive-cardinality/active-output invariant used by the paper,
  and provide explicit restriction and reindexing bridges for ambient zero
  columns by consuming C03's existing `restrictActiveOutputs`: its
  `bindOnSupport` construction is already normalized, preserves exact masses
  and requires no renormalization or unjustified ambient-to-subtype map;
- define the value and pattern of every admitted nonzero singular column;
- prefer a nonempty support finset for the core pattern, with Boolean-vector
  and ordered-column presentations derived at the paper boundary;
- check Definition 4's observation that Example 1's first column has value
  `1/2` and pattern `[1,1,0]^T` as a focused fixture;
- prove reconstruction from value and pattern, uniqueness, nonnegativity,
  upper bounds, and row-sum facts; and
- provide explicit arbitrary-finite-type/`Fin` reindexing for paper matrices.

No operation should be implemented before `DG-06`, `DG-07`, and C06's portion
of `DG-10` are resolved by an approved contract. C12 retains its later
compression/optimization-weight portion; C07 does not depend on completing C12.
Mathlib's square-only row-stochastic matrix predicate is not by
itself a suitable rectangular channel owner.
The semantic channel remains authoritative; matrices are a proved finite
coordinate representation, not a second probability theory.

### PFR-C07 — Four Typed Matrix Operations

**Current completion overlay, 2026-10-03:** C07 is **Complete**.
[Verified handoff and preserved records](pfr-c16-readiness-audit.md#c16-history-c07)
establish later closure; any pre-F status below remains its original checkpoint.

**Status:** Approved / Active [revision 2](plans/pfr-c07-four-typed-matrix-operations.md),
2026-09-21. The lead endorsed the delivered revision and requested S01 with
review. Revision 1's original independent plan review remains historical.
Five approved steps
cover common order/PMF machinery, the PP pair/recovery, the VP pair/recovery,
complete fixtures/handoff/readiness, and fresh cumulative independent closeout.
DG-08 adopts the documented value-one VPS interpretation. S01 is durably complete;
the conditional S02 request was accepted after exact closure/source verification.
S02 is now durably closed with review; its exact final source and closure were
verified before the fresh conditional S03 request. S03 is also durably complete;
its closure and exact source were verified before the S04 request was accepted.
S04's durable closure and all 114 final inventory entries were verified before
the separate S05 request. Only that final cumulative step is now authorized.
Current status is in
the [implementation notes](pfr-c07-implementation-notes.md).
Prerequisite C06 is durably complete; C12's remaining numeric work does not block
this chunk. See [planning notes](pfr-c07-planning-notes.md) for source evidence.

S01's ordered indices, raw PMF core and exact/Real formulas are implemented;
R01-R03 and all three independent criteria pass, with no findings. The original
report is reconciled and final validation/durable closure completed. S02 implements
legal PPS/PPM, complete exact/Real column data and both witnessed recoveries.
The merged value may equal one; nonadjacent recovery uses the explicit permutation.
R04-R08 and affected earlier regressions pass, as do all three independent S02
criteria, with no findings. The original report is critically reconciled.
Final validation and durable closure completed. S03 implements legal VPS/VPM,
support/indicator bridges, mask irrelevance and both witnessed recoveries,
including the approved value-one interpretation. All three S03 independent
criteria are satisfied with no findings; the original report is critically
reconciled. R01-R13's 105 examples, all 233 public signature/axiom checks,
12 independent consumers and focused/default builds pass. Final applicable
validation and durable closure completed. S04 implements complete parametric
Examples 2-5, generic handoff consumers and a
[cumulative readiness audit](pfr-c07-readiness-audit.md); its validation and review
satisfy all three independent criteria with no findings, and the complete original
report is critically reconciled. All 169 maintained examples, 233 public
signature/axiom checks, five independent consumers and required/default builds
pass. Final applicable checks, F capture and durable S04 closure completed.
S05 freshly reassesses all earlier criteria, R01-R16 and CC01-CC10 with all
maintained builds and public audits. The same reviewer satisfies every cumulative
assessment with no findings, and its complete original report is critically
reconciled. Final applicable checks, F capture and supported durable closure
follow this owning-document checkpoint; see the implementation notes.

**Anchors:** ISIT Section III-A, Equations (11)-(15), Examples 2-5; current
extended Section III-A, including the corrected merge indices.
**Prerequisite:** `PFR-C06`.
**Risk:** high.
**Modules:** `Matrix/OperationIndices.lean` and `Matrix/Operations.lean`;
the focused helper keeps finite-label consumers independent of probability imports.

This chunk should:

- define legal PPS, PPM, VPS, and VPM operations with all parameter and pattern
  side conditions;
- define the operations at the semantic channel/PMF layer using maps, binds,
  or channel composition where practical, then prove the displayed matrix
  formulas;
- encode output-type changes and paper column order without unsafe casts;
- require strict PPS weights and either nonempty VPS pieces or an explicit
  raw-split/prune-zero bridge, so active output columns remain active;
- resolve the source mismatch in which VPS is printed only for
  `0 < beta < 1` but Theorem 1 and the partition construction can require a
  split of a value-one column;
- prove that every operation preserves row stochasticity and singularity;
- prove the expected value, pattern, and unaffected-column formulas;
- state witness-parameterized recovery theorems for split/merge pairs, not
  false global inverse-function claims, literally or up to the explicit
  reindexing selected by `DG-08`; and
- reproduce Examples 2-5 as compiling fixtures or tests under the missing
  source-side assumption `0 < beta < 1`.

The precise PPM/VPM source indices follow the current extended correction:
both selected columns range over all `m + 1` source columns. The detailed plan
must decide whether the displayed examples deserve public names; no such names
are promised by this map.

### PFR-C08 — Operation Paths and Lemma 4 Normalization

**Current completion overlay, 2026-10-03:** C08 is **Complete**.
[Verified handoff and preserved records](pfr-c16-readiness-audit.md#c16-history-c08)
establish later closure; any pre-F status below remains its original checkpoint.

**Anchors:** ISIT Lemma 4; current extended Appendix B, local rewrites
corresponding to Equations (167)-(174).
**Prerequisite:** `PFR-C07`.
**Risk:** high.
**Modules:** S01-S02 supply `Matrix/OperationPaths.lean`; S03 adds private local
interchange proofs and maintained anonymous tests in `Matrix/OperationCalculus.lean`.
S04 adds private certificate support and 43 examples in `Matrix/OperationFactorization.lean`.
**Status, 2026-09-27:** Complete under approved revision 2. C09 startup
verified the subsequent S07 durable closure and all 123 final inventory entries;
[C09 planning notes](pfr-c09-planning-notes.md) retain the actual evidence and
limits. Original C08 pre-F checkpoints and reports remain historical.
Revision 1's independent plan review remains
historical; [planning notes](pfr-c08-planning-notes.md) record revision-2 advice
and approval. No separate revision-2 plan review is claimed.

This chunk should:

- define tagged witnessed steps over the existing active state and heterogeneous
  paths; approved revision 2 retains verified `Quiver.Path` after evaluating
  `Relation.ReflTransGen`, retaining chronological operation tags and witnesses;
- define cascade equivalence by endpoint equality or the selected explicit
  output equivalence, then prove path composition and relabeling invariance;
- prove local interchange laws with all index/relabeling effects;
- give a rigorous termination or structural-factorization argument for
  normalization; and
- prove Lemma 4's PPS-then-VPS-then-PPM normal form.

The manuscript's informal instruction to interchange operations repeatedly is
not by itself a termination proof, especially where a rewrite can lengthen a
cascade. The normal-form theorem must be strong enough for later reachability
and partition-weight arguments. One-off interchange facts should remain
private unless multiple consumers justify a stable API.

### PFR-C09 — Representability Preservation

**Current completion overlay, 2026-10-03:** C09 is **Complete**.
[Verified handoff and preserved records](pfr-c16-readiness-audit.md#c16-history-c09)
establish later closure; any pre-F status below remains its original checkpoint.

**Anchors:** ISIT Lemmas 5-6 and surrounding Section III-B prose; current
extended Appendix B preservation constructions.
**Prerequisites:** `PFR-C02`, `PFR-C06`, and `PFR-C07`.
**Risk:** high because semantic witnesses must cross the coordinate boundary.
**Implemented module:** `Matrix/Preservation.lean` (seed, Lemmas 5-6 and handoffs complete; fresh cumulative S05 independent review reconciled).
**Current status, 2026-09-28:** Complete; C10 startup verified durable S05 closure and source applicability. See [C10 planning notes](pfr-c10-planning-notes.md).

**Historical pre-F status, 2026-09-28:** [Approved revision-2 plan](plans/pfr-c09-representability-preservation.md).
C09 implementation and the fresh S05 cumulative independent assessment are complete. All twelve earlier criteria, R01-R14, CC01-CC08 and CC09 review-time readiness were reassessed. All three S05 review criteria are satisfied. No material or optional findings were raised. The original report is critically reconciled. Final applicable checks, F and supported durable closure follow this maintained checkpoint; only that later record completes CC09 and closes C09. C10 remains unstarted. [Implementation notes](pfr-c09-implementation-notes.md) own source correspondence and validation; the [readiness audit](pfr-c09-readiness-audit.md) maps cumulative obligations. Original reviews and revision-2 advice dispositions are preserved; no separate revision-2 plan review is claimed.
C03 supplies semantic transport; C08 public wrappers are test consumers only,
with no normalization prerequisite. The original C02/C06/C07 dependencies remain.

This chunk should:

- prove the all-ones one-output channel is perfectly representable;
- reuse the semantic output-equivalence theorem owned by `PFR-C03` at the
  matrix boundary;
- prove Lemma 5 for PPM, PPS, and VPS; and
- derive Lemma 6 for PPM, PPS, and VPM using the proved recovery interfaces.

The result should expose exactly which operations preserve perfect
representability and which reflect non-representability. Every construction
must make null merged/split fibers and any nonzero denominator obligation
explicit. Local witness constructions belong here; a general
channel-transformation framework does not.

### PFR-C10 — Generic Reachability and the Easy Direction

**Current completion overlay, 2026-10-03:** C10 is **Complete**.
[Verified handoff and preserved records](pfr-c16-readiness-audit.md#c16-history-c10)
establish later closure; any pre-F status below remains its original checkpoint.

**Status:** Complete. C11 startup verified durable S07 closure and exact final
source applicability; see [C11 planning notes](pfr-c11-planning-notes.md).

**Historical pre-F planning status, 2026-09-29:** [Approved C10 revision-2 plan](plans/pfr-c10-generic-reachability-easy-direction.md); seven approved steps,
with S01-S06 durably complete after review. S07 startup verified successful S06
closure, all six original reports/reconciliations and all 141 final source/environment
entries. Fresh cumulative independent review satisfies all current criteria and
reassesses the complete earlier/regression/completion scope with one optional stale-status finding, corrected here.
The original report is critically reconciled; final validation/F and durable
closure follow this checkpoint. The
[readiness audit](pfr-c10-readiness-audit.md) owns the cumulative crosswalk.
No independent revision-2 plan review is claimed. DG-11 and
OM-051/052/071 handling are specified in that plan. [Planning notes](pfr-c10-planning-notes.md)
retain API probes, selected advice dispositions and revision 1's formal
report-admission limitation. Revision 2 preserves this allocation.

**Anchors:** ISIT Theorem 1 “if” direction and the operation constructions
used by Section IV; current extended Theorem 1 opening and Example 6.
**Prerequisites:** `PFR-C08` and `PFR-C09`.
**Risk:** high.
**Candidate modules:** `Matrix/Partitions.lean` and
`Matrix/Reachability.lean`; the approved plan separates synthesis into
`Matrix/MultiwayOperations.lean` to keep semantic folds and synthesis imports focused.

This chunk should:

- define the two paper-facing reachability directions precisely;
- derive the “if” direction from preservation and the proved
  witness-parameterized recovery operations;
- define the minimal finite exact-partition interface needed for pattern
  splitting, including nonempty parts, pairwise disjointness, and coverage;
- prove repeated PPS can generate any finite family of positive weights
  summing to one, first restricting a merely nonnegative family to its
  positive support so no zero-valued output column is created;
- prove repeated VPS can split a nonempty pattern along an exact finite
  partition;
- prove repeated PPM can merge finite fibers of equal patterns; and
- check the current extended Example 6 as a reachability certificate fixture.

The manuscript's multiway “use PPS” and “split by VPS” phrases must be realized
as finite binary-operation cascades, including the singleton-family and
value-one cases. These reusable-but-paper-owned constructors keep the hard
Theorem 1 chunk focused. They must use active columns and be invariant under
the output relabelings fixed by `PFR-C06`.

### PFR-C11 — Theorem 1 Canonical-Coupling Construction

**Current completion overlay, 2026-10-03:** C11 is **Complete**.
[Verified handoff and preserved records](pfr-c16-readiness-audit.md#c16-history-c11)
establish later closure; any pre-F status below remains its original checkpoint.

**Current status:** Complete. C12 startup verified S06 durable closure, all six
original report reconciliations and all 139 final source/environment entries.
See [C12 planning notes](pfr-c12-planning-notes.md). Original C11 records remain
historical.

**Historical pre-F execution status, 2026-09-29:** [Revision 2](plans/pfr-c11-theorem1-canonical-coupling.md)
is active, with the same six steps. S01-S05 are durably complete. S06 freshly reassessed all fifteen earlier criteria, R01-R16, CC01-CC07 and CC08 review-time readiness. Required builds and exhaustive audits pass. The persistent reviewer satisfies all three S06 criteria without findings; the complete original report is critically reconciled. Final applicability checks/F and durable closure follow this checkpoint; only that closure completes CC08 and C11. C12 remains unstarted.
[Implementation notes](pfr-c11-implementation-notes.md) own exact evidence.
It strengthens S05/R14, schedules an early actual-endpoint partition consumer in
S04 and prefers private NormalForm reuse in S05. Shared inputs and no-op proof
guidance remain lightweight. Revision 1's eight-criterion independent report is
preserved and reconciled; the supplied General Assistant advisory is separate.
No independent revision-2 review is claimed. [Planning notes](pfr-c11-planning-notes.md#revision-2-selection-and-dispositions)
own evidence and every suggestion's disposition.

**Anchors:** ISIT Theorem 1 and Appendix Equations (20)-(28); current extended
Theorem 1 proof, Equations (16)-(24), Figure 1, and Appendix B's completed
Lemma 5/6 prerequisites, reused through C09/C10. Appendix B's Theorem 2 remains C14.
**Prerequisites:** `PFR-C02`, `PFR-C06`, and `PFR-C10`.
**Risk:** very high.
**Implemented module:** `Matrix/CanonicalReachability.lean`, importing C10
reachability and finite synthesis, keeps internal support/fiber machinery private
and exposes the two characterization iff statements. Separate public consumers
live in `Tests/Matrix/CanonicalReachability.lean`. The
[readiness audit](pfr-c11-readiness-audit.md) maps the full construction and
C12/C13 handoff; S06 cumulative independent review is reconciled. Final
applicability/F and durable closure follow the maintained checkpoint.

This chunk should:

- formalize the “only if” construction through `Y' = (Y,W)`;
- replace the manuscript's “without loss of generality, `pW(w)>0`” by an
  explicit `supportFinset` restriction or equivalent theorem;
- restrict the ambient product `Y × support(W)` to active pairs with nonempty
  decoder fibers, so `Y'` contains no globally zero channel column;
- extract, for each supported `w`, an instance of `PFR-C10`'s exact-partition
  interface from the decoder's nonempty fibers;
- prove the two explicit bridge paths: `M --PPS--> pY'|X` and
  `1_k --PPS/VPS--> pY'|X`, then reverse them using PPM/VPM; and
- prove the final equivalence, exposing both `M -> 1_k` by PPM/PPS/VPM and
  `1_k -> M` by PPS/VPS/PPM.

Figure 1 is explanatory artwork; its block/partition construction must appear
in the proof, not as a formalized picture. If this chunk remains too large
after its detailed proof probes, it may split into support/fiber construction
and final reachability theorem subchunks without weakening the target.

### PFR-C12 — Active-Pattern Compression and the Real Bridge

**Current completion overlay, 2026-10-03:** C12 is **Complete**.
[Verified handoff and preserved records](pfr-c16-readiness-audit.md#c16-history-c12)
establish later closure; any pre-F status below remains its original checkpoint.

**Current status, 2026-09-30:** Complete. C13 startup verified S05 durable
closure, all six original-report reconciliations and exact agreement of all
145 final source/environment entries; see [C13 planning notes](pfr-c13-planning-notes.md).
The following pre-F checkpoint is historical.

**Status, 2026-09-30:** S01-S04 are durably complete. S05 freshly reassesses all twelve earlier criteria, R01-R13 and CC01-CC09. Fresh cumulative validation and independent review pass. Both complete original reports are preserved and critically reconciled. Final applicability, F and supported durable closure follow this checkpoint; only that closure completes CC09 and C12. The [approved revision-2 plan](plans/pfr-c12-active-pattern-compression-real-bridge.md) is unchanged. The [readiness audit](pfr-c12-readiness-audit.md) records all source obligations and review-time readiness; only subsequent S05 closure completes CC09 and C12. [Implementation notes](pfr-c12-implementation-notes.md) own evidence.

Revision 2 schedules full dependent-data recovery early in S03 and initial
enumeration invariance in S01, stages regression assertions, combines the
fixture for proper support and directed recovery, and adds a non-surjective
injection test. [Advice dispositions](pfr-c12-planning-notes.md#revision-2-advice-dispositions)
retain the rationale; existing omission IDs and later owners are unchanged.

**Anchors:** ISIT Section IV opening compression prose; current extended
Section IV-A full/reduced setup.
**Prerequisites:** `PFR-C06` through `PFR-C10`.
**Risk:** high.
**Implemented module:** `Matrix/PatternCompression.lean`.

Implemented coverage:

- define equal-pattern fibers without depending on output-label order;
- merge each fiber, aggregate its positive `ENNReal` value, and reconstruct
  every row;
- prove the compressed active matrix has pairwise distinct nonempty patterns;
- prove compression preserves and reflects reachability/perfect
  representability through PPM and its inverse construction;
- expose the reduced pattern/value family in an enumeration-free form;
- derive the finite `Real` values used by optimization and prove their
  strict positivity for active patterns, upper bounds, and row-stochastic
  identities;
- package the valid compressed active singular pattern data that forms the
  domain of the primal and dual cores; and
- require a nonempty input alphabet at the LP boundary.

This chunk is the last owner of the `ENNReal`/`Real` conversion contract.
Keeping it separate prevents incidence combinatorics from becoming entangled
with PMF reconstruction.

### PFR-C13 — Exact Partitions and Full/Reduced Incidence Systems

**Current completion overlay, 2026-10-03:** C13 is **Complete**.
[Verified handoff and preserved records](pfr-c16-readiness-audit.md#c16-history-c13)
establish later closure; any pre-F status below remains its original checkpoint.

**Current status, 2026-09-30:** Complete. C14 startup verified supported S06
closure `b722301a08704288a781de37208dc02ee9837a3070c7f6ca592eedd43e76abdf`,
all six original-report reconciliations and exact agreement of all 153 final
source/environment entries. [C14 planning notes](pfr-c14-planning-notes.md)
record applicability; C13's original reviewed documents remain unchanged.

**Historical status, 2026-09-30:** [Revision 2](plans/pfr-c13-exact-partitions-incidence-systems.md)
is Active at S06. S01-S05 are durably closed, with all fifteen criteria satisfied
and original reports reconciled. Fresh cumulative assessment covers intrinsic
incidence, nonnegative full/reduced transport, normalization, witness extraction,
actual coefficient-specific construction, characterizations and all regressions.
S06 cumulative validation and independent review pass; all three criteria are satisfied, and the original report is reconciled. Final applicability, F and durable closure follow this pre-F checkpoint.
Final F and supported closure remain required for CC09/C13. C14/C15 remain
unstarted. The [readiness audit](pfr-c13-readiness-audit.md) maps exact source,
manuscript coverage, omissions and interfaces; [implementation notes](pfr-c13-implementation-notes.md)
retain the evidence and limits. No omission identifier or gate boundary changes.

**Anchors:** ISIT Section IV-A, Equation (16), incidence matrix Equation (17),
Examples 6-7; current extended Section IV-A, Equations (33)-(63), Examples
7-8.
**Prerequisites:** `PFR-C10`, `PFR-C11`, and `PFR-C12`. Read-only design may
start earlier, but implementation of this single chunk waits for all three.
**Risk:** very high.
**Implemented owners:** `Optimization/Incidence.lean` and its focused
`Optimization/IncidenceConstruction.lean` consumer.

This chunk should:

- represent each occurring nonzero pattern as a finite row-support set;
- reuse `PFR-C10`'s minimal exact-partition interface and define its incidence
  relation with occurring patterns;
- use mathlib `Finpartition` if its detailed plan confirms that its
  nonempty-part and finite-instance contracts fit that existing interface,
  keeping any classical `DecidableEq` choice internal;
- keep occurring-pattern and admissible-partition subtypes as the core matrix
  indices, using `Matrix.reindex` only for a paper-facing `Fin m`/`Fin R`
  presentation;
- define the paper-facing full system over all nonzero patterns and all exact
  partitions;
- define the reduced system using only occurring patterns and admissible exact
  partitions;
- define the input-pattern incidence matrix `P` and prove the structural
  identities `P v = 1` and `P H = 1` in their correctly typed vector/matrix
  forms; these identities support normalization in `PFR-C14` and the
  nonnegative separator correction in `PFR-C15`;
- handle the case of no admissible exact partition without inventing a
  nonempty index type;
- prove extension by zero and restriction give equivalent full/reduced
  nonnegative equality feasibility, using nonnegativity to rule out
  cancellation on omitted rows;
- prove nonnegative equality feasibility `Hx = v` is equivalent to the
  partition-weight operation construction and hence to perfect
  representability;
- prove `Hx = v` forces total partition weight one and the bounds on weights
  used in the manuscript;
- prove that operation constructions may restrict a nonnegative feasible
  weight vector to its positive support without changing `Hx = v`;
- prove the finite bound `m <= 2^k - 1` from distinct nonzero patterns; and
- provide the `k = 3` partition/incidence examples as tests or demonstration
  modules.

This chunk owns the precise answer to the “`m` variables versus
`2^k - 1` coordinates” issue. Both encodings should exist only if their
relationship is theorem-backed. The reduced system is the intended basis for
Corollary 1. The literal ISIT `m × R` system with every Bell partition but only
occurring-pattern rows is not a valid third encoding: partitions containing
unobserved patterns can introduce unconstrained weights. Its intended content
must pass through the full or reduced system above.

### PFR-C14 — Primal Characterization

**Current completion overlay, 2026-10-03:** C14 is **Complete**.
[Verified handoff and preserved records](pfr-c16-readiness-audit.md#c16-history-c14)
establish later closure; any pre-F status below remains its original checkpoint.

**Current status, 2026-10-01:** Complete. C15 startup verified S04 supported
closure, all four original-report reconciliations, twelve satisfied closing
criteria and exact agreement of all 159 final source/environment entries.
[C15 planning notes](pfr-c15-planning-notes.md) own the later evidence; C14's
original pre-F plan/notes/readiness remain historical and unchanged.

Revision 2 selectively incorporates the parent's and user-supplied General
Assistant's advisory suggestions: R06 rejects the signed equality solution;
R09 uses one scaled asymmetric fixture to distinguish both inverse coordinate
directions; the finite objective-value-set contract, private slack route,
regression staging and C13-only import check are explicit. The planning notes
retain both originals and dispositions. Step count, scope and omission owners
are unchanged; the dated revision-1 omission records below remain historical.

**Anchors:** ISIT Theorem 2 and Equation (18); current extended Theorem 2,
Equation (64), and Appendix B proof Equations (203)-(221).
**Prerequisite:** the completed `PFR-C13` interface, which already carries the
reachability/perfect-representability equivalence from `PFR-C11`.
**Risk:** high.
**Candidate module:** `Optimization/Primal.lean`.

S02 maps (215)-(216) to C13 normalization plus the attained upper bound,
(217)-(219) to image membership and the shared slack identity, and (220)-(221)
to nonnegative summand control at a containing input for every pattern. This
fulfills the data-level content assigned by OM-042/046 without a public kernel
API, general optimizer theorem or new omission. S03 implements the ambient
channel/presentation boundaries; S04 freshly reassesses the complete contract.

This chunk should:

- state its core theorem on the valid compressed active singular pattern data
  produced by `PFR-C12`;
- define the reduced finite primal feasible set `x >= 0` and `Hx <= v`;
- prove every feasible objective value `1 · x` is at most one;
- connect objective value one with `Hx = v`;
- prove that a feasible point attains objective one if and only if the channel
  is perfectly representable;
- package these facts as an iff between channel perfect representability and
  `IsGreatest (objective '' feasible) 1`, or an equally explicit precise
  version of “`max 1 · x = 1`”; and
- expose the paper-facing theorem for an active singular channel through
  restriction and compression, while deciding explicitly whether a broader
  arbitrary-channel decision wrapper belongs here or in `PFR-C16`.

The input alphabet must be nonempty: for an empty input the displayed primal
can be unbounded and Theorem 2 is false. Introducing a general LP framework is
not a goal. The empty-admissible-partition case must be a regression test.
Executable LP solving and running-time claims remain outside this chunk.

### PFR-C15 — Dual Characterization

**Current completion overlay, 2026-10-03:** C15 is **Complete**.
[Verified handoff and preserved records](pfr-c16-readiness-audit.md#c16-history-c15)
establish later closure; any pre-F status below remains its original checkpoint.

**Current status, 2026-10-02:** [Revision 2](plans/pfr-c15-dual-characterization.md)
is **Active** at S05. S01-S04 are durably complete; finite dual presentations,
counts and readiness are implemented and validated. Fresh cumulative validation
passes fresh independent assessment; the original report is reconciled and
final exact F/supported CC09 closure remain at this checkpoint.

R03 adds a dual-sign guard; R07 clarifies
private-helper evidence and exact arithmetic; S04 locates the finite singular
corollary in DualCharacterization; the compact-singleton route is an alternate
separation interface. [Advice dispositions](pfr-c15-planning-notes.md#revision-2-advisory-dispositions)
retain the rationale. The persistent reviewer is bound to the originating C15
task and reused for the fresh cumulative S05 review. All three criteria are
satisfied without findings; the original report is reconciled. No installed plan review is claimed.
Five approved steps isolate the dual core,
specialized alternative, leastness/ambient corollary, finite presentation/counts,
and fresh cumulative closeout. [Planning notes](pfr-c15-planning-notes.md) record
actual-type hull/separation/cardinality-correction/positive-normalization and
compact-singleton alternate-interface probes, all passing. DG-14's specialized alternative and data/ambient leastness are durably validated
through S04, including independent finite presentations. Only S05 is currently
authorized; C14 is durably complete and no later chunk starts.

**Anchors:** ISIT Section IV-B, Corollary 1, Equation (19); current extended
Section IV-B and Equation (65).
**Prerequisites:** `PFR-C13` and `PFR-C14`.
**Risk:** S02's main separator/correction proof risk is resolved at independent
review: the maintained specialized proof and regressions pass. S01-S04
are durably complete; fresh cumulative validation and independent assessment
pass. Final exact F/supported CC09 closure follow the reconciled report checkpoint.
No generic LP strong-duality theorem or global optimizer is needed.
**Modules:** `Optimization/Dual.lean` owns the dual algebra and all-vector finite
transport; `Optimization/DualCharacterization.lean` owns focused separation,
data/ambient leastness and both finite corollaries. Existing Incidence count APIs
supply the variable count without duplicate aliases.

This chunk should:

- state its core theorem on the same valid reduced data used by `PFR-C14`;
- define the reduced dual feasible set `y >= 0` and `H^T y >= 1`;
- prove weak duality against the primal interface;
- construct the elementary row-indicator dual witnesses with objective one;
- establish the specialized alternative selected at `DG-14`, with every
  finite-dimensional closure and feasibility hypothesis explicit;
- for the leading convex-hull route, strictly separate a nonrepresentable
  value vector from the finite incidence-column hull, represent the separator
  by finite coordinate coefficients, correct it into nonnegative coordinates
  using pattern sizes, and normalize it—with positivity and nonzero
  denominators proved—to a strict-below-one dual certificate;
- use the row-indicator witness to supply objective-one membership and package
  the representable minimum statement as
  `IsLeast (objective '' feasible) 1`;
- derive Corollary 1;
- state the exact reduced-coordinate count of `m` variables and its connection
  to the full `2^k - 1` pattern universe; and
- expose the paper-facing active-singular-channel corollary through the same
  restriction/compression bridge, without implying that values and patterns
  are defined for an arbitrary nonsingular matrix.

Before approval, the detailed plan must compile probes for the intended finite
convex-hull and strict-separation declarations and state a fallback. If the
required infrastructure is too large for one coherent chunk, split it into a
local specialized-alternative chunk and a short corollary chunk rather than
weakening the theorem or claiming generic LP duality.

The no-admissible-partition case must be split off before any
nonempty-convex-hull lemma is used. Its dual constraints are vacuous and
`y = 0` is feasible with objective zero, giving the immediate
strict-below-one certificate. A global dual optimizer for every
nonrepresentable channel is not part of this chunk unless the detailed plan
shows it is needed.

### PFR-C16 — Coverage, API, and Trust Closure

**Current plan status, 2026-10-03:** [Approved revision 2](plans/pfr-c16-coverage-api-trust-closure.md)
is at S05 finalization after verified S01–S04 durable closure. Fresh cumulative
validation and corrected-source independent review pass; both original reports
are reconciled. Completion remains subject to the supported durable S05 record.
[Readiness](pfr-c16-readiness-audit.md#c16-s05-readiness) and
[dated dispositions](pfr-c16-readiness-audit.md#c16-s04-dispositions) own the current
crosswalks; [planning notes](pfr-c16-planning-notes.md) preserve original advice.

**OM-018 current disposition, 2026-10-03:** retain the approved no-wrapper default.
For finite channels with nonempty input, necessity rejects nonsingular channels;
the existing singular-channel primal/dual characterizations compose. Current
consumers and a fresh anonymous proof provide no blocked use case. The
[detailed decision](pfr-c16-readiness-audit.md#c16-s03-wrapper) retains the precise
domain and original OM-018 rationale. Reopen only for a concrete approved consumer
with a precise proposed contract and review/approval of any material revision.
No solver, generic optimization framework or publication curation is authorized.

**Anchors:** complete six-page ISIT manuscript and every completed chunk plan.
**Prerequisites:** all in-scope chunks.
**Risk:** medium, but mandatory.
**Candidate artifacts:** documentation, import audits, and focused validation
modules; no theorem family is allocated here.

This chunk should:

- assess whether a broader nonsingular/singular convenience wrapper is needed
  after C14/C15; C14 proposes deferring this scope decision here, without
  authorizing new theorem implementation or solver work;
- reconcile every numbered definition, equation, lemma, theorem, corollary,
  remark, example, figure, and substantive prose claim with a formal
  declaration, proof-internal coverage, fixture, documentation disposition, or
  omission entry;
- recheck every extended-proof dependency against the then-current draft;
- audit support, null-fiber, empty/singleton, zero-column, reindexing, and
  `ENNReal`/`Real` edge cases;
- audit public names, namespaces, imports, declaration generality, and the
  lightweight root;
- run all module, aggregate, default-build, and placeholder validations;
- reconcile the living summary, roadmap, project log, map, and completed plans;
  and
- reconcile the internal omission register while preserving every original ID
  and rationale. Publication-facing curation is a separately approved later phase.

Release, GitHub publication, website work, and publication metadata remain
separate decisions even after this chunk.

## 8. Source Coverage Allocation

### Numbered ISIT content

| Source item | Allocation |
| --- | --- |
| Equations (1)-(3) | `PFR-C01` |
| Equation (4) | `OM-005`: cited external bound, intentionally not formalized |
| Equations (5)-(7), Definition 1, Remark 1, Lemma 1, Definition 2 | `PFR-C02` |
| Definition 3, perfect-implies-singular and binary-output clauses of Lemma 2, Equation (8), Example 1 | `PFR-C03` |
| Equation (9) and finite maximal coupling | `PFR-C04` |
| Binary-input clause and combined statement of Lemma 2, Equation (10), Lemma 3 | `PFR-C05` |
| Definition 4 | `PFR-C06` |
| Equations (11)-(15), PPS/PPM/VPS/VPM, Examples 2-5 | `PFR-C07` |
| Lemma 4 | `PFR-C08` |
| Lemmas 5-6 | `PFR-C09` |
| Theorem 1 easy direction and generic operation constructions | `PFR-C10` |
| Theorem 1 hard direction, final equivalence, and proof Equations (20)-(28) | `PFR-C11` |
| Equal-pattern compression and Real value bridge | `PFR-C12` |
| Equations (16)-(17), Examples 6-7, exact partitions, and incidence matrix `H` | `PFR-C13` |
| Theorem 2 and Equation (18) | `PFR-C14` |
| Corollary 1 and Equation (19) | `PFR-C15` |
| Remark 2 | `OM-010` through `OM-012` |
| Algorithmic and complexity prose | documentation plus `OM-016` through `OM-019` |
| Figure 1 | proof content in `PFR-C11`; artwork disposition in `OM-020` |

The ISIT Appendix Equations (20)-(28) are proof anchors rather than a promise
that each intermediate equality will become a public declaration. Their
logical content must occur in the checked proof of Theorem 1 in `PFR-C11`.

### Supporting prose selected for formal coverage

The following unnumbered claims are assigned because they connect or clarify
the named results:

- the introduction's pair-level notion of a perfect functional representation
  and its equality/Markov forms — `PFR-C01`;
- the four canonical-vector properties and the
  sufficient-to-focus-on-canonical conclusion — `PFR-C02`;
- dependence of channel perfect representability only on the channel,
  including fixed-prior/full-support bridges — `PFR-C02`;
- the perfect-equality/Markov equivalence — `PFR-C01` and `PFR-C02`;
- equivalence of semantic and matrix singularity — `PFR-C06`;
- value/pattern reconstruction for singular columns and compressed matrices —
  `PFR-C06` and `PFR-C12`;
- closure of singular matrices under all four operations — `PFR-C07`;
- witness-parameterized recovery relations between PPS/PPM and VPS/VPM —
  `PFR-C07`;
- perfect representability of the all-ones channel — `PFR-C09`;
- equal-pattern compression — `PFR-C12`;
- finite binary-cascade realization of multiway weights and partitions —
  `PFR-C10`;
- operation/partition-weight equivalence — `PFR-C08`, `PFR-C10`, and
  `PFR-C13`;
- full/reduced incidence-system feasibility equivalence — `PFR-C13`;
- automatic normalization and coordinate bounds for feasible equality
  solutions — `PFR-C13`;
- restriction of the primal and dual statements to valid compressed active
  singular data, with paper-facing channel bridges — `PFR-C12`, `PFR-C14`,
  and `PFR-C15`; and
- non-singular channels are not perfectly representable — a corollary of
  `PFR-C03`, reused by the optimization layer.

## 9. Internal Exhaustive Omission and Disposition Register

This register is intentionally broader than a future reader-facing coverage
note. It records every presently identified source claim or artifact that the
map consciously does not assign as a public formal theorem. “Omitted” does not
always mean ignored: some entries are cited context, proof-internal steps,
fixtures, representation departures, or extended-only work.

| ID | Source material | Initial disposition and reason |
| --- | --- | --- |
| `OM-001` | Introductory functional representation lemma existence claim [1] | Do not re-formalize the cited theorem. `PFR-C01` formalizes the representation contract and consequences; existence from an external paper/textbook is not needed for the PFR theorems. |
| `OM-002` | Minimum-entropy functional-representation literature [2]-[13] | Context only and results of other works; outside the paper's theorem chain. |
| `OM-003` | General motivational channel-synthesis and one-shot uses [14]-[17] | Context only; do not formalize the cited papers. Specific bound, asymptotic, Poisson, and zero-redundancy claims are tracked separately in `OM-005`, `OM-006`, `OM-008`, `OM-012`, and `OM-041`. |
| `OM-004` | General motivational privacy applications [5], [6], [18]-[26] | Context only; do not build the external privacy results or a privacy library. Specific common-information, funnel, and extended information-measure claims are tracked in `OM-009`, `OM-011`, and `OM-032`. |
| `OM-005` | Strong functional-representation bound in Equation (4) [14], [16] | Intentionally excluded: externally sourced and not used in the exact characterization. The ISIT prose calls the displayed additive-logarithmic gap a “logarithmic factor,” while the current extended draft calls it an additive logarithmic term. Auditing the external theorem, wording, or units requires separate approval; see also `OM-035`. |
| `OM-006` | General normalized product-distribution consequence derived from Equation (4) | Externally sourced through the strong representation results [14], [16]; outside this finite exact formalization. The refined nonsingular/singular rates from [17] are tracked separately in `OM-041`. |
| `OM-007` | Cited special cases where `X` is a function of `Y` or `Y` of `X` [5] | Not a target theorem. Reconsider only as a low-cost local corollary after the semantic API stabilizes; do not import the cited paper's development. |
| `OM-008` | Poisson functional representation minimizes `I(X;Z ∣ Y)` for binary `Y` [14] | Externally sourced and not needed for Lemma 3's local finite coupling proof. |
| `OM-009` | Wyner common-information sufficient condition [18] | Externally sourced; the required common-information API is outside current scope. |
| `OM-010` | Körner graph-entropy equivalence in the introduction and Remark 2 [27]-[29] | Externally sourced equivalence; graph entropy and the cited construction are outside scope. |
| `OM-011` | Privacy-funnel and `g0` equivalences in the introduction and Remark 2 [30], [31] | Externally sourced equivalences; privacy measures are outside scope. |
| `OM-012` | Exact-zero channel-synthesis redundancy equivalence in the introduction and Remark 2 [17] | Externally sourced interpretation; document the connection but do not formalize the referenced channel-synthesis theory. |
| `OM-013` | Attribution of Definition 1 to Kallenberg Lemma 3.22 [32] | Formalize Definition 1 and Lemma 1 locally, but do not reproduce or claim coverage of the external textbook lemma. |
| `OM-014` | Literal identification of supports with `{1,...,k}` and `{1,...,m}` | Representation departure, not lost mathematics: semantic chunks use arbitrary finite support types. C06-S03 implements exact active-output enumeration/recovery and finite input/output coordinate transport; its step validation/review status is recorded in the C06 implementation notes. C12 S01-S03 durably supply intrinsic patterns, explicit compressed presentations, minimal Real data and full dependent recovery with membership transport. S04 implements coordinate-exact transport under changed active enumeration and injective output relabeling, with actual inverse ambient recovery. Implementation validation passes; independent review is reconciled; final S04 closure remains pending. S05 checkpoint, 2026-09-30: S01-S04 durable closure and exact S04 final-source applicability are verified; fresh cumulative source/manuscript/build/trust checks support this C12 obligation. Cumulative independent review passes and both original reports are reconciled; final applicability/F and supported closure remain. Earlier checkpoints retain their historical meaning. C15 S04 initial checkpoint, 2026-10-02: all-vector/inverse entire dual-image transport and exact reduced-variable count are implemented and validated; independent step review remains pending. [C15 readiness](pfr-c15-readiness-audit.md) owns current crosswalk; S05 cumulative closeout is unstarted. Current C15: S01-S04 are durably complete; S05 freshly revalidates this disposition and its cumulative independent report is reconciled. Final applicable F/supported CC09 closure follow this checkpoint. |
| `OM-015` | Narrative that singular channels are important in [17] | Context and attribution only; no Lean proposition. |
| `OM-016` | Claims that singularity can be checked in linear time | Algorithmic complexity claim, not required for the structural theorem; documentation-only unless executable algorithms receive separate approval. Broader ISIT complexity prose is `OM-019`. |
| `OM-017` | Bell-partition count and Bell-number growth | [33] supports the ISIT Bell-number/count discussion; current-extended [34] supports the growth claim. C10-S02 supplies the exact-partition interface over mathlib for later VPS and C13 consumers. The enumerative identity and asymptotic growth remain outside S02 and are not theorem prerequisites. C13 revision-1 planning retains this exclusion and assigns only the explicit five-partition, three-input completeness fixture to S05. S05 proves the concrete five-partition classification with an explicit Fin 5 equivalence; the general Bell identity and growth remain excluded. |
| `OM-018` | Executing an LP solver to decide perfect representability | Theorems 2 and Corollary 1 are formal targets; certified solver integration and executable decision software are deferred roadmap work. The current-extended theoretical algorithm is separately tracked in `OM-028`. C14 revision-1 planning, 2026-09-30: the post-Theorem-2 decision prose is covered by the singular-channel mathematical iff; no solver is added. A broader nonsingular/singular convenience wrapper remains for C16 scope assessment, with the existing singularity-necessity theorem available; this is distinct from executable solver integration. |
| `OM-019` | ISIT running-time discussion, “linear in the output-alphabet size/exponential in the input-alphabet size,” number-of-constraint discussion, and open efficient-solvability question | Documentation-only source coverage. The exact finite coordinate bounds used by the mathematics are assigned to `PFR-C13`; the Bell enumeration is `OM-017` and extended answers are `OM-028` through `OM-031`. C12 planning, 2026-09-29: the bound in ISIT IV opening is explicitly retained by C13; C12 supplies distinct nonempty patterns, while the adjacent linear-time prose remains documentation-only. C13 revision-1 S01 proposes the exact full-pattern cardinality and occurring-pattern bound, with intrinsic indices and explicit finite presentations; no runtime theorem is added. S01 implementation now proves `card_nonzeroPattern` and `patterns_card_le`; review/closure state is in the C13 implementation notes. |
| `OM-020` | Figure 1 as a graphical artifact | Do not reproduce the figure. `PFR-C11` formalizes the partition and operation construction it illustrates. C11 revision-2 proposal assigns its exact constant-value blocks, nonempty partitions and reverse-stage construction to S02/S04/S05; artwork remains omitted. At the S02 checkpoint, C11 supplied the exact labelled decoder partitions, constant q-valued blocks and indexed row uniqueness; actual operation paths were assigned to S03-S05. See C11 implementation notes for review status. C11 S04 now realizes Figure 1's forward weighted-pattern construction with actual PPS/VPS paths, original decoder labels and distinct repeated patterns. At the S04 checkpoint, witnessed reversal and final compositions remained assigned to S05. S05 now supplies both actual witnessed reverse/compositions, exact chronological words and directed inverse maps; R12 checks mixed and empty stages. Artwork remains omitted. |
| `OM-021` | ISIT Appendix proof Equations (20)-(28) as individually named public results | Their content is proof-internal to `PFR-C11` unless later reuse justifies a helper. Checked proof coverage is mandatory even without matching public names. C11 revision-2 proposal requires all-prior specified-W perfectness and law-level deterministic-posterior factorization in S01, explicit active label/partition bridges in S02, and actual paths in S03-S05. Conditional formulas are asserted on supported fibers; no uniqueness of null completions or public name per display is promised. C11 S01 now implements the private all-prior specified-W perfectness, both exact auxiliary atoms, split composition, marginals, deterministic projection factorization and full support-law inclusion. Its validation/review status is recorded in the C11 implementation notes. S02 supplies the subsequent partition/endpoint content; operation paths retain their S03-S05 owners. C11 S02 now checks (23)-(28) through supported decoder labels, finite partitions, the shared active endpoint, exact values/patterns and indexed deterministic-posterior uniqueness. The S01/S02 passages above are historical checkpoints. At the S03 checkpoint, C11 realized the (21)/(17) posterior splitting as an actual homogeneous binary PPS path, with a directed comparison to the independently specified auxiliary endpoint; the all-ones bridge and final compositions remained assigned to S04-S05. C11 S04 realizes the final construction paragraph after (28)/(24): q-positive PPS columns, partitions on their actual patterns, complete VPS labels and exact auxiliary coordinates. Both actual bridges meet the same supplied endpoint; at the S04 checkpoint final characterization remained assigned to S05. S05 completes the final witnessed construction and both public iff statements. The earlier allocation checkpoints remain history; the readiness audit maps all numbered content without a public name per display. |
| `OM-022` | Abstract, section outline, concluding restatement, acknowledgements/funding, author metadata, and ordinary transitions | No duplicate Lean declarations. Mathematical claims are routed by the coverage tables; nonmathematical publication metadata remains documentation. |
| `OM-023` | Bibliography entries as mathematical developments | Citations and provenance only. None of the referenced works is treated as formalized by this repository. |
| `OM-024` | ISIT's literal PPM/VPM merge-index range through `m` for a source in `S_{k,m+1}` | Canonical owner of the repair: use the designated extended v16 range through `m + 1` for both distinct indices, retain the lower position, delete the higher and shift only later columns. C07 S01-S03 implements exact index/mass contracts; S04's complete parametric Examples 3/5 check final-column and nonadjacent merges with every resulting column in order. Validation/review status is in the implementation notes. The 2026-09-21 reconciliation retains OM-070 as a duplicate cross-reference with its rationale/history, not a second obligation. |
| `OM-025` | Any reading that assigns “`m` dual variables” to the full `2^k - 1`-coordinate system | Do not formalize this misleading conflation. `PFR-C13` proves the full/reduced equivalence; `PFR-C15` states `m` only for the reduced dual. C13 revision-1 S01/S02 specify exact full/reduced dimensions and coefficient restriction/extension. C15 remains the owner of dual-variable wording. S01 now implements those finite indices, dimension bounds and supplied coordinate presentations. S02 now implements nonnegative full/reduced feasible-vector equivalence and both inverse laws; validation and independent review pass, with the original report reconciled. C15 revision-2 S04 proposes all-vector reduced dual finite-presentation/image transport and reuses the exact occurring/full cardinality APIs; no full dual hierarchy is added. C15 S04 initial checkpoint, 2026-10-02: all-vector/inverse entire dual-image transport and exact reduced-variable count are implemented and validated; independent step review remains pending. [C15 readiness](pfr-c15-readiness-audit.md) owns current crosswalk; S05 cumulative closeout is unstarted. Current C15: S01-S04 are durably complete; S05 freshly revalidates this disposition and its cumulative independent report is reconciled. Final applicable F/supported CC09 closure follow this checkpoint. |
| `OM-026` | Examples 2-5 as guaranteed stable public declarations | Canonical owner of fixture visibility. Approved C07 revision 2 S04 implements private fixtures and anonymous consumers covering all 75 entries of Equations (11)-(15), actual legality and closure. No current consumer requires public fixture names; revisit only for an actual C08/C09 consumer. The 2026-09-21 reconciliation routes the duplicate public-name prose from OM-050 here; OM-050 retains the separate parameter hypothesis. |
| `OM-027` | ISIT Examples 6-7 and current extended Examples 6-8 as guaranteed stable public declarations | Current-extended Example 6 is a `PFR-C10` reachability fixture; ISIT Example 6/current-extended Example 7 and ISIT Example 7/current-extended Example 8 are `PFR-C13` partition/incidence fixtures. They are validation or demonstration content rather than stable public API. C10-S06 implements the extended reduction in separately importable private `Examples.Reachability` fixtures, checking (25)-(32) and the actual reverse certificate; the C13 examples remain with their mapped owner. C13 revision-1 S05 assigns ISIT Examples 6-7 / extended Examples 7-8 to explicit partition/incidence fixtures with all 35 entries; C10 extended Example 6 remains completed. C13 S05 implements the exhaustive private three-input classification, all 35 paper entries, all-pattern full/reduced equality and proper 7-by-5 to 4-by-2 restriction. See the C13 readiness audit for source and review status. |
| `OM-028` | Current extended Section V-A separation-oracle algorithm | Extended-only: omit the subset recurrence, minimizing-partition witness recovery, `O(m 2^k)` separation-call bound, constraint-generation runtime, separation-optimization appeal [35], `2^k poly(m,L)` guarantee, and fixed-`k` consequence. These are theoretical complexity results, not the executable-solver deferral in `OM-018`. |
| `OM-029` | Current extended Appendix C-A separation and exact-optimization hardness | Extended-only: omit RXC3 [37], NP-hardness/NP-completeness of separation, hardness of the first constraint-generation call, exact compact-dual optimization hardness, its strong-duality transfer to the primal, and the caveat that this does not prove optimality of the `2^k` dependence. |
| `OM-030` | Current extended Theorem 3 and 3-colorability reduction for NP-hardness of perfect representability | Extended-only theorem relying on 3-colorability NP-completeness [36]; outside current scope. |
| `OM-031` | Current extended Appendix C-B and Corollary 2 | Extended-only bounded-degree reduction [38] and hardness under all four stated restrictions: every positive entry is `1/3`, every row has three positive entries, every occurring pattern has value `1/3`, and every occurring pattern has size at most five. |
| `OM-032` | Current extended Section VI information-measure discussion | Extended-only: omit the definitions, derivations, and claimed relations for Wyner common information, `g0`, `h0`, excess functional information, Körner graph entropy, the privacy funnel, and the binary-erasure counterexample. `OM-009` through `OM-011` separately own the related ISIT introduction/Remark 2 citations. These extended claims rely on external results and their literal contracts are not accepted: the displayed excess-functional-information minimization appears to suppress a decoding constraint, while the supremum discussion may suppress attainment. Revisit only under separately approved scope. |
| `OM-033` | Current extended Lemma 7 as an additional public theorem name | Its mathematical content is the proof of ISIT Example 1 and is assigned to `PFR-C03`. The extended numbering does not create a separate target. |
| `OM-034` | Current extended Section VII conclusion and additional bibliography [34]-[38] | No duplicate formal statements; extended-only claims are covered by `OM-028` through `OM-032` and citations remain provenance. |
| `OM-035` | Bits-versus-nats phrasing in source discussion | Canonical theorems use LeanInfoTheory's nats. No parallel bit-valued hierarchy; optional conversion is deferred unless a paper-facing presentation needs it. |
| `OM-036` | Introductory descriptions that `Z` “captures all information” and that functional representations are nonunique | Documentation-only intuition. The exact independence, decoding, and optimization statements are formalized; no vague duplicate predicate is introduced. |
| `OM-037` | Prose calling canonical properties “trivial,” operation closure “straightforward,” or singularity “easy” | No theorem corresponds to an adjective. The underlying canonical properties and C07 operation-closure facts are implemented and independently assessed; algorithmic ease is covered by `OM-016`. |
| `OM-038` | Generic VPS definition with degenerate selected-support pieces | A mask may create a zero child even when globally nonconstant. Approved C07 revision 2 requires both intersections with the selected support to be nonempty. S03 implements those witnesses, their filter-nonemptiness bridge and mask irrelevance outside support; R10 owns failed-legality regressions. Validation/review status is in the implementation notes. Raw PMF helpers do not give zero children values/patterns; no pruning bridge is promised. C08/C10 may revisit a raw-pruning API only with a concrete consumer. Examples 2-5's separate parameter assumption remains OM-050. C10-S04 derives both nonempty selected-support pieces from each supplied exact partition, with singleton/no-op and null-row/mask regressions; it introduces no raw-pruning API. |
| `OM-039` | A reusable general linear-program or conic strong-duality library | Not needed to claim Corollary 1. `PFR-C15` targets the specialized finite alternative only; any general library work requires separate scope and ownership review. C14 revision-1 proposal likewise excludes a generic primal LP framework; finite incidence algebra and attained greatestness suffice. C15 revision 2 proposes only the specialized finite-hull alternative; geometric Farkas APIs were found, but a complete cone/LP route remains outside scope. Current actual-type probes support the local hull route. S03 checkpoint, 2026-10-02: data attained leastness and ambient inactive-output corollary are owned by S03 (independent review reconciled; final closure checkpoint); finite presentation and cumulative closure remain S04/S05. Existing scope exclusions stand. Current C15: S01-S04 are durably complete; S05 freshly revalidates this disposition and its cumulative independent report is reconciled. Final applicable F/supported CC09 closure follow this checkpoint. |
| `OM-040` | A second formal proof of Example 1 derived later from Theorem 1 | The direct extended Lemma 7 argument is assigned to `PFR-C03`. The later theorem may yield a corollary/check, but duplicate public proof infrastructure is not a target. C11 S05/R15 now consumes the existing public C03 counterexample to refute both reachability predicates through the new equivalences, with no duplicate public counterexample API. |
| `OM-041` | Refined product-channel redundancy rates from [17] | Externally sourced: omit the leading `(1/2) log n` nonsingular statement and sublogarithmic singular statement. They are distinct from the general normalized product consequence in `OM-006`. |
| `OM-042` | Numbered construction and proof intermediates as guaranteed public declarations | ISIT Equations (6)-(7) are checked content of `PFR-C02` and ISIT Appendix Equations (20)-(28) are covered by `OM-021`. Current-extended Theorem 1 Equations (16)-(24) belong internally to `PFR-C11`; Example 6 Equations (25)-(32) are covered by `OM-027`; and the full/reduced construction and proof Equations (33)-(63) belong to `PFR-C13` without promising a public name for every line. Current-extended Lemma 2 Equations (105)-(134) belong internally to `PFR-C03`/`PFR-C05`; Lemma 7 (135)-(146) to `PFR-C03`; Lemma 3 (147)-(166) to `PFR-C04`/`PFR-C05`; Lemma 4 (167)-(174) to `PFR-C08`; Lemmas 5-6 (175)-(202) to `PFR-C09`; and Theorem 2 (203)-(221) to `PFR-C14`. Equations (66)-(68) divide between the reduced-dimension claims in `PFR-C13`/`PFR-C15` and Bell enumeration in `OM-017`. All assigned logical content must be checked, but one public Lean name per printed line is not promised. C08 revision 1 introduced this allocation, retained by approved revision 2: (167) is reused from C07; S03 implements (168)-(173) with private anonymous regressions and the finite inversion classification in (174). All three independent S03 criteria are satisfied without findings, and the original report is critically reconciled. Subsequent final validation and durable S03 closure completed. S04 implements the private finite certificate and append invariants. All three independent S04 criteria are satisfied without findings; the original report is critically reconciled. Final validation/F and durable S04 closure completed; S05 implements realization and global normalization, with validation and independent S05 review complete and the original report critically reconciled, followed by successful final validation and durable S05 closure. S06 completed the anchor-coverage audit; S07 freshly reassessed every anchor and the cumulative source contract. Its original independent report is reconciled; final validation/F and durable closure follow the maintained pre-F checkpoint. Private factorization trees need no stable public names. C09 approved revision 2 retains revision 1's allocation of (175)-(177) to existing C02 semantics, (178)-(183) to S01, (184)-(195) to S02 and (196)-(202) to S03, with full joint-witness obligations and S04/S05 coverage audit; private scalar/conditional intermediates need no public names. S01 implements (178)-(183) with a private shared-choice full-vector witness and total posterior; focused/default builds and R01-R04 pass, with all three independent criteria satisfied and the original report reconciled. S01 final validation/F and durable closure subsequently completed. S02 implements (184)-(195) through the actual ordered whole-vector collapse, one fixed admitted-value mixture and explicit zero row products off the common support. R05-R07 inspect distinct unequal posterior atoms, all affected/unaffected joints and remembered recovery ordering. All three S02 independent criteria are satisfied with two nonmaterial wording findings corrected; the original report is critically reconciled. S02 final validation/F and durable closure subsequently completed. S03 startup verified all 123 final entries; (196)-(202), the full deterministic VPS witness and R08-R10 passed independent review with all three criteria satisfied. The original report is critically reconciled; S03 subsequently closed, and S04 startup verified all 123 final entries. S04 completed Lemma 6 and the cumulative anchor/readiness audit, with independent review, reconciliation, final validation and durable closure. S05 freshly reassessed every C09 anchor and completion obligation; cumulative independent review is reconciled. Final checks/F and durable closure follow the maintained checkpoint. C11 S05 completes the internal (16)-(24)/(20)-(28) construction and exposes only the two final characterization theorems. Its readiness audit records the source crosswalk and S06 obligation. C13 revision-1 S01-S05 allocate the full/reduced logical content of (33)-(63), with the general Bell claims still excluded under OM-017. Its public semantic weight-extraction route replaces the terse appeal to normal form without exposing C11 private internals. S03 now implements that route through supported decoder fibers, the C10 labelled partition adapter and explicit Real mass aggregation; the two public necessity theorems reuse S02 transport. Required source builds, semantic fixtures and public audits pass; independent review satisfies all three S03 criteria without findings, and the original report is reconciled. C13 S04 now implements the coefficient-specific construction in a focused sibling: private carrier/group/sum helpers feed a public dependent phase bundle and both characterization directions. Required consumers and all three independent S04 criteria pass; the original report is reconciled. Final applicability/F and closure follow the pre-F checkpoint. S05/S06 retain integrated fixtures and cumulative audit. C13 S05 maps every assigned logical assertion in (33)-(63) to production contracts or private fixtures in its readiness audit; (34) remains the explicit OM-017 exclusion. C14 revision-1 planning assigns (203)-(204), (206)-(208), (210)-(211) to verified C13 reuse, (209)/(212)-(214) to the new inequality bound, and (215)-(221) to equality normalization, attained greatestness and all-coordinate nonnegative slack elimination. Scalar/kernel helpers may remain private; all logical content is required. |
| `OM-043` | Treating the current-extended adjacent-rewrite discussion as a complete termination proof of Lemma 4 | Do not copy the informal “repeat interchanges” step without justification. `PFR-C08` must supply a structural factorization or well-founded normalization argument, especially when a rewrite lengthens the path. The route introduced in C08 revision 1 is retained by approved revision 2: induction on the original path plus finite PPS/VPS/PPM tree realization in S04/S05. S04 implements the private certificate, identity and append invariants; all three independent S04 criteria are satisfied without findings; the original report is critically reconciled. Final validation/F and durable S04 closure completed. S05 implements concrete realization and global normalization; focused/default validation and the signature/axiom audit pass; independent S05 review satisfies all three criteria without findings and is critically reconciled. S05 final validation and durable closure completed; S06 startup verified its exact final source. S06 integrated consumers and readiness are durably complete. S07 freshly checked cumulative coverage and the structural proof; the original independent report is reconciled. Final validation/F and durable closure follow the maintained pre-F checkpoint. It claims no arbitrary rewrite-strategy termination, uniqueness, confluence or complexity bound; a future algorithmic consumer would need explicit approval. |
| `OM-044` | Literal set notation `S` and `S_{k,m}` as the Lean owner of channel matrices | C06-S03 implements `ActiveFiniteChannel` over finite nonempty input, with positive state-owned output cardinality and nonzero columns, exact coordinates and explicit `Fin` presentation/recovery. Singularity stays a separate premise. This is a representation repair, not a change to the theorem; validation/review status is in the C06 implementation notes. C12 S01-S03 are durably complete, including minimal Real pattern data over explicitly nonempty finite input, derived output nonemptiness and supplied finite presentations. S04 connects the original ambient channel to the reconstructed data channel through the C06 presentation and retained S02 witnesses. Implementation validation passes; independent review is reconciled; final S04 closure remains pending. No prior, full-support, perfectness or feasibility premise is added to valid data. S05 checkpoint, 2026-09-30: S01-S04 durable closure and exact S04 final-source applicability are verified; fresh cumulative source/manuscript/build/trust checks support this C12 obligation. Cumulative independent review passes and both original reports are reconciled; final applicability/F and supported closure remain. Earlier checkpoints retain their historical meaning. C14 revision-1 proposal retains nonempty input in the valid-data boundary and permits an empty admissible family; that family has only objective zero. No empty-input primal theorem is promised. S03 checkpoint, 2026-10-02: data attained leastness and ambient inactive-output corollary are owned by S03 (independent review reconciled; final closure checkpoint); finite presentation and cumulative closure remain S04/S05. Existing scope exclusions stand. Current C15: S01-S04 are durably complete; S05 freshly revalidates this disposition and its cumulative independent report is reconciled. Final applicable F/supported CC09 closure follow this checkpoint. |
| `OM-045` | Ambient zero columns and “without loss of generality” deletion of zero auxiliary weights | Do not assign a fake value or pattern. C03 owns semantic active-output restriction/invariance, as clarified on 2026-09-11. C06-S03 consumes that exact bridge, including injective extension, off-image zero coordinates, restriction, enumeration and comparison of active presentations; S04 implements actual admitted-data transport through the same chain; its validation/review status is in the C06 implementation notes. C10-S03 implements positive-support NNReal/ENNReal PPS constructors and exact inclusion/off-image laws; its review state is in the C10 implementation notes. C10-S05 adds a total empty-selection no-op and actual-range PPM with zero ambient mass off range, without an active empty fiber. `PFR-C11` restricts both the canonical auxiliary and `Y'` to active support/fibers with explicit bridges. Later owners/triggers are unchanged. C11 revision-2 proposal makes q-support inclusion, positive-posterior/active-pair/nonempty-decoder-label bijections and ambient row recovery explicit in S01-S04; S05/R14 tests an arbitrary posterior at an unused output. C11 S01 now implements exact q-support and auxiliary pair inclusion, full pair/triple/factorization recovery, and the positive-posterior/active-pair bijection with ordered projections. At the S01 checkpoint, the decoder-label bijection and common finite endpoint were assigned to S02, later operations to S03-S04, and the adversarial unused-output fixture to S05/R14. See C11 implementation notes for current validation/review status. C11 S02 now supplies the nonempty decoder-label and partition-label bijections, exact common endpoint and full ambient row recovery. Empty fibers and zero q atoms receive no admitted data. S05/R14 retains the unused-output posterior guard. C11 S03 uses C10 on the exact positive posterior labels and proves ambient recovery from the actual PPS endpoint, without assigning columns to zero posterior atoms. R07-R08 retain omitted labels and supplied output order. C11 S04 retains exactly q.support in the actual seed and excludes empty decoder fibers in the actual VPS stage, with forward/inverse maps and full ambient recovery. At the S04 checkpoint, the unused-output posterior guard remained assigned to S05/R14. C11 S05/R14 now verifies the adversarial unused-output completion: valid row factorization with V 2 (2,2) = 1 and q (2,2) = 0. Active restriction/reconstruction and a changed supplied enumeration are checked; posterior-support equivalence keeps its activity premise. C12 revision-1 proposal, 2026-09-29: S04/R11 consumes the active restriction, actual compression inverse and inclusion to recover every ambient coordinate; unused labels receive no data. C12 S04 now implements actual inverse recovery followed by the C06 inclusion, including every inactive coordinate. R11/R12 use the explicit Fin 4 to Fin 5 injection and prove the added label has zero mass and no admitted data. Implementation validation passes; independent review is reconciled; final S04 closure remains pending. S05 checkpoint, 2026-09-30: S01-S04 durable closure and exact S04 final-source applicability are verified; fresh cumulative source/manuscript/build/trust checks support this C12 obligation. Cumulative independent review passes and both original reports are reconciled; final applicability/F and supported closure remain. Earlier checkpoints retain their historical meaning. S03 checkpoint, 2026-10-02: data attained leastness and ambient inactive-output corollary are owned by S03 (independent review reconciled; final closure checkpoint); finite presentation and cumulative closure remain S04/S05. Existing scope exclusions stand. Current C15: S01-S04 are durably complete; S05 freshly revalidates this disposition and its cumulative independent report is reconciled. Final applicable F/supported CC09 closure follow this checkpoint. |
| `OM-046` | Reading manuscript “max” and “min” notation as silently guaranteeing a Lean optimizer | `PFR-C05` uses a universal bound plus finite attaining witness; `PFR-C14` uses `IsGreatest` at objective one; `PFR-C15` uses `IsLeast` at objective one and a separate no-partition case. No unproved global attainment assumption is imported from prose. C14 revision-1 proposal states both explicit feasible objective-one attainment and perfectness iff IsGreatest at one, with the ambient singular-channel and supplied finite-presentation bridges. General optimizer existence for every datum and a supremum formulation are intentionally omitted as unnecessary; the probe validates membership-based attainment, not global optimization. C15 revision-2 S01/S02 separates vacuous empty-partition constraints (zero certificate) from row-witness membership at one; S03 requires the universal lower bound and IsLeast. Global dual optimizer/infimum-attainment claims remain omitted as unnecessary. S03 checkpoint, 2026-10-02: data attained leastness and ambient inactive-output corollary are owned by S03 (independent review reconciled; final closure checkpoint); finite presentation and cumulative closure remain S04/S05. Existing scope exclusions stand. Current C15: S01-S04 are durably complete; S05 freshly revalidates this disposition and its cumulative independent report is reconciled. Final applicable F/supported CC09 closure follow this checkpoint. |
| `OM-047` | ISIT's literal `m × R` incidence matrix with all Bell partitions but rows only for occurring patterns | Do not formalize this system as written. A partition containing an unobserved pattern can create a partly or wholly unconstrained column, so `Hx = v` need not encode the operation construction and the claimed coordinate bound on `x` can fail. `PFR-C13` must use the current extended draft's full `2^k - 1`-row zero-padded system or its reduced admissible-partition system and prove their equivalence. `OM-025` separately owns the dual-variable-count wording. C13 revision-1 S02/S05 retain nonnegative per-vector equivalence and explicit mixed-system false positives, signed cancellation and unconstrained-column bounds as regressions; no third encoding is accepted. Revision 2 corrects R08 to full rejection/reduced restriction acceptance and stages R06-R08/R13 transport in S02; the mathematical recovery law still assumes full feasibility. S02 implements that law, structural normalization and positive support; its concrete controls and independent review pass; the original report is reconciled. C14 revision-1 proposal uses only the verified reduced system for the primal. It does not extend C13 equality transport silently to inequalities/objectives or introduce a separate full-coordinate primal API; the proposed finite-presentation theorem transports the reduced system only. C15 revision 2 retains the same reduced rows/admissible columns. S04 transports that dual image through supplied equivalences only; equality full/reduced bridges are not silently reused for dual objectives. C15 S04 initial checkpoint, 2026-10-02: all-vector/inverse entire dual-image transport and exact reduced-variable count are implemented and validated; independent step review remains pending. [C15 readiness](pfr-c15-readiness-audit.md) owns current crosswalk; S05 cumulative closeout is unstarted. Current C15: S01-S04 are durably complete; S05 freshly revalidates this disposition and its cumulative independent report is reconciled. Final applicable F/supported CC09 closure follow this checkpoint. |
| `OM-048` | Definition 1 read as independence plus coordinate marginals only | Do not formalize this weakened literal reading. “Canonical functional representation” inherits the functional-representation decoder relation `Y = W_X`; `PFR-C02` must make the fixed pair's joint-law/decoder condition explicit and distinguish it from a marginally canonical coupling law. C09 approved S01-S03 likewise require the complete coordinate/vector law and total common posterior through each operation; marginal coupling laws alone do not suffice. C11 S01 checks the specified W through independence, evaluation decoding, Markov perfectness and complete law-level factorization for every prior, including support-restricted W. Its fixed pair is explicitly the joint induced by the auxiliary channel; coordinate marginals alone are not used as the representation contract. |
| `OM-049` | VPS's printed restriction `0 < beta < 1` versus later value-one splits | The lead-endorsed C07 revision-2 contract and S01 request adopt the intended active range `0 < beta <= 1` on 2026-09-21. S03 implements legal VPS/VPM and both recoveries without a strict upper-bound premise; its validation/review status is in the implementation notes. Section 3's strict-domain alternative uses PPS, two VPS and two PPM. C09 could own that fixed construction without a general cascade theorem or new C08/C10 dependency, but it is unselected. Selecting it later would require an approved recovery-contract/ownership revision. No fallback implementation or C06 bound change is authorized. C09 planning on 2026-09-27 retains the inclusive domain; the strict-domain simulation remains unselected and outside the approved plan. S03 checks legal value-one VPS preservation directly. C10-S04 now supplies finite partition synthesis with unchanged admitted values, including one; its R11 consumers retain that domain without a strict-domain simulation. |
| `OM-050` | Examples 2-5 omit a hypothesis on their shared parameter `beta` | Approved C07 revision 2 S04 implements the complete Real-parametric Equations (11)-(15) under `0 < beta < 1`, with exact ENNReal bridges. Explicit regressions prove source inactivity at beta zero and one; this fixture premise does not narrow the approved general VPS/VPM value-one domain. The public-name policy previously repeated here is cross-referenced to its canonical owner OM-026 by the 2026-09-21 reconciliation. The parameter obligation remains distinct. |
| `OM-051` | Prose saying PPS/PPM and VPS/VPM “are inverses,” and calling cascades “equivalent” | Approved C07 revision 2 S02/S03 implements the four directed recoveries with remembered ratio/support mask, legal witnesses, exact adjacent equality and specified nonadjacent output permutation, including unaffected columns. S02/S03 are durably closed; S05 freshly rechecks all recoveries and their consumers. Exact review/finalization status is in the implementation notes. R07 distinguishes a wrongly reversed permutation; R12/R13 exercise VP recovery including null support rows and common value one. Merges forget information and masks are irrelevant outside selected support; no global inverse or unique ambient mask is asserted. C08 startup verified subsequent C07 durable completion. C08 approved revision 2 retains this allocation: S01-S02 are durably complete, including directed endpoint data, ordered operation/path transport, cascade composition and remembered-recovery consumers. S03 implements every local interchange and extended (171)'s corrected terminal permutation under the unchanged lower-survivor rule. All three S03 independent criteria are satisfied and the original report is reconciled; final validation and durable closure completed. S04 implements the private certificate and append invariants. All three independent S04 criteria are satisfied without findings; the original report is critically reconciled. Final validation/F and durable S04 closure completed; global realization is implemented in S05 with validation and independent S05 review complete and the original report critically reconciled, followed by final validation and durable S05 closure; path reversal remains with C10 reachability. C09 S04 implements Lemma 6 through the three required remembered recoveries and recovered-to-original output maps; R11-R14 exercise exact endpoints and non-involutive output transport. S04 independent review, original-report reconciliation, final validation and durable closure completed. S05 freshly reassessed these recovery directions and cumulative readiness; independent review is reconciled. Final checks/F and durable closure follow the maintained checkpoint. C10-S01 now implements witnessed operation/path/cascade reversal, exact reversed/swapped tags, restriction transfer and the two prior-free easy implications. R01-R04 and focused/default validation pass; all three independent S01 criteria are satisfied without findings, and the original report is critically reconciled. Final checks/F and durable closure follow the maintained checkpoint. The C10 implementation notes own current evidence. No global inverse or proof-data involution is asserted. S06 startup subsequently verified all S01-S05 durable closures, their original-report reconciliations and exact final-source applicability; the preceding pre-F checkpoints remain historical. C11 S05 composes a with the witnessed reverse of b and b with the witnessed reverse of a. The initial inverse comparison, final directed maps and non-involutive cycle are checked in R12; no global inverse is asserted. C12 revision-1 proposal, 2026-09-29: S02 retains the actual PPM certificate and its witnessed PPS reversal. Reduced pattern/value data reconstruct the compressed channel; original multiplicities and unequal fiber values require the retained witness. S02 now retains exactly the returned C10 path/labels and its Cascade.reverse; all-coordinate recovery uses the directed comparison. Validation and independent review pass; the original report is reconciled, and final applicability/F and durable closure follow the implementation checkpoint. C12 S02 subsequently durably closed; S03 startup verified its closure and exact final-source applicability on 2026-09-30. The preceding C12 pre-F checkpoint remains historical. S05 checkpoint, 2026-09-30: S01-S04 durable closure and exact S04 final-source applicability are verified; fresh cumulative source/manuscript/build/trust checks support this C12 obligation. Cumulative independent review passes and both original reports are reconciled; final applicability/F and supported closure remain. Earlier checkpoints retain their historical meaning. C13 S04 retains actual labelled phases and the final output comparison in the supplied direction. The concrete four-cycle distinguishes forward and inverse output indices. No global inverse or arbitrary-path classification is added. Independent S04 review is reconciled; final applicability/F and closure follow the pre-F checkpoint. |
| `OM-052` | Multiway-operation shorthand in Theorem 1 and the partition-weight construction | Primitive PPS and VPS operations are binary, while the prose sometimes creates an arbitrary weighted family or splits along an entire partition “by” one named operation. `PFR-C10`/`PFR-C11` must realize these as finite cascades, restrict zero weights and empty fibers, handle singleton and value-one cases, and prove the resulting endpoint. The C08 revision-1 boundary is retained by approved revision 2: S04/S05 realize only recorded binary forests generated from a supplied cascade, with no arbitrary weight/partition/fiber synthesis API; S04 implements the private certificate and append invariants. All three independent S04 criteria are satisfied without findings; the original report is critically reconciled. Final validation/F and durable S04 closure completed; S05 implements concrete realization and global normalization; focused/default validation and the signature/axiom audit pass; independent S05 review satisfies all three criteria without findings and is critically reconciled. S05 final validation and durable closure completed; S06 startup verified its exact final source. S06 integrated consumers and readiness are durably complete. S07 freshly checked cumulative coverage and the structural proof; the original independent report is reconciled. Final validation/F and durable closure follow the maintained pre-F checkpoint. C10/C11 retain those general constructors; revisit private-helper promotion only for a concrete consumer in their approved plans. C10-S02 supplies exact partitions and the original-label bijection only; C10-S03 implements actual finite PPS paths, selected/family label bijections and exact weight adapters, with validation/review state in the implementation notes. C10-S04 implements selected/family VPS synthesis on supplied exact partitions, reusing the S03 private labelled traversal without promoting C08 machinery. C10-S05 implements selected equal-pattern PPM and prescribed-fiber paths with complete labels, exact masses/values/patterns, empty/singleton handling and range inclusion. The decoder-fiber application remains C11 and global compression remains C12; validation/review state is in the implementation notes. C10-S06 integrates the public ENNReal PPS, original-label partition VPS and prescribed-fiber PPM interfaces with exact independent targets and actual C08 normal-form consumption. No C08 private helper is promoted; canonical decoder choices and global compression remain later work. C11 S03 supplies the actual posterior PPS family, exact directed endpoint comparison and actual singleton-family no-op length/tags. At the S03 checkpoint, the seed PPS/VPS construction remained assigned to S04; global compression remains C12. C11 S04 constructs the chronological PPS-then-VPS bridge from legal C10 binary paths, including actual singleton-stage length/tags, value-one VPS and separate equal-pattern columns in R09-R11. At the S04 checkpoint final reversal/compositions remained S05; global compression remains C12. C11 S05 retains those actual stages in the final composites and a private existing NormalForm, whose toCascade is definitionally the actual forward composite. R12 verifies full block order and empty-stage maps. Compression remains C12. C12 revision-1 proposal, 2026-09-29: global grouping consumes C10 prescribed-fiber/range PPM; no new finite-synthesis framework or C11 private helper promotion is planned. S02 now specializes that public C10 result and its length theorem; distinct patterns and singleton cases retain actual zero-step paths. Validation and independent review pass; the original report is reconciled, and final applicability/F and durable closure follow the implementation checkpoint. C12 S02 subsequently durably closed; S03 startup verified its closure and exact final-source applicability on 2026-09-30. The preceding C12 pre-F checkpoint remains historical. S05 checkpoint, 2026-09-30: S01-S04 durable closure and exact S04 final-source applicability are verified; fresh cumulative source/manuscript/build/trust checks support this C12 obligation. Cumulative independent review passes and both original reports are reconciled; final applicability/F and supported closure remain. Earlier checkpoints retain their historical meaning. C13 revision-1 S04 consumes the actual C10 positive-support PPS, exact-partition VPS and prescribed-fiber PPM results, proving target-pattern surjectivity and exact directed endpoint comparison. C13 revision 2 makes the same-construction public specifications explicit and adds R13's genuine unequal-column merge; no new path framework is added. C13 S04 now invokes the C10 binary realizations on positive partition coefficients, transported exact blocks and prescribed pattern fibers. R09 omits a zero coefficient, singleton phases have length zero, and R13 proves an actual one-operation PPM merge of unequal shared-block masses. Independent S04 review is reconciled; final applicability/F and closure follow the pre-F checkpoint. S05 retains exhaustive fixture integration. C13 S04 subsequently durably closed. S05 integrates the paper coordinates with the actual R09 and R13 phase consumers; S06 retains fresh cumulative validation. |
| `OM-053` | The introductory existential auxiliary for perfect representability is not literally finite-qualified | C01 keeps structural fixed-`Z` semantics unrestricted but deliberately places its information/perfectness API and existential pair witness at the finite-valued boundary required by the pinned LeanInfoTheory contracts. `Fin n` only universe-normalizes the hidden finite witness; C01 excludes infinite-alphabet information statements. The 2026-09-04 `DG-01` resolution adopts this source-to-Lean interpretation. C02-S03 now proves information-preserving canonical replacement for finite value alphabets on an unrestricted source, and `isPerfectlyRepresentablePair_iff_exists_canonicalJoint` characterizes the approved finite pair witness by a law on `alpha → beta`. This supplies canonical sufficiency within the approved finite-information boundary; it does not extend information equality to an infinite original auxiliary. S03 implementation and independent validation passed. |
| `OM-054` | Remark 1 read as reusing the same random variable on every already fixed source | Do not assert independence/decoding with arbitrary new variables on the original source. S05 checks S01's canonical-joint and marginal theorems for every prior with the same specified coupling, and supplies one coupling law giving perfect canonical joints for all priors. The original-source pair consequence uses C01 pair-law transport, permitting an enlarged witness space. This approved precise law-level reading passed independent S05 validation. |
| `OM-055` | The Definition 2 discussion read as inferring an entire ambient channel from a degenerate-prior pair, or fixing a unique posterior on unused outputs | Section II identifies the input alphabet with support. S04's fixed-posterior support cancellation, full-support fixed-coupling Markov converse and unused-output invariance passed independent validation, including R03/R08/R09. S05's all-prior forward implication and full-support perfect-pair/channel equivalences, including every-prior and some-full-support-prior formulations, also passed independent validation. No full-output-support premise or null-fiber posterior uniqueness is asserted. S06 implements the exact arbitrary-prior support-subtype bridge and unused-input-row regression; it passed independent validation. |
| `OM-056` | Lemma 2's printed two-output condition interpreted as arbitrary ambient cardinality or a degenerate-prior pair's output support | Approved C03 Draft revision 2 counts the union of all channel-row supports and requires exact restriction, unused-output extension and finite relabeling bridges. At most two includes singleton degeneration; zero active outputs are impossible for nonempty input. The pair support equals that union only under full input support, or after C02 input-support restriction. S02's finite relabeling and unused-output extension are durably complete. S03's exact restriction, activity/nonemptiness, finite invariance and full-support identification passed independent validation, including R06-R07 and R08's structural portion. All three criteria are satisfied with no findings; the report was reconciled and S03 durably closed. S04 at-most-two sufficiency, its ambient-cardinality specialization, singleton perfectness and the R08 sufficiency/R09-R11 cases passed independent validation with all three criteria satisfied and no findings. The original report was reconciled and S04 durably closed; exact applicability was verified before S05 acceptance. Binary-input/combined Lemma 2 stay C05. |
| `OM-057` | Extended Lemma 7's uniform-prior conditional calculations (136)-(146) as a separate public conditional-probability API | C03 S05 implements the same direct two-branch support contradiction through C02's prior-free common-posterior factorization, whose full-support Markov bridge justifies the source interpretation. Positivity, atom existence and both contradictions passed independent validation with all three S05 criteria satisfied and no findings; the original report was reconciled. S05 is durably complete, with exact applicability verified before S06. No public theorem per conditional display or dependence on later Theorem 1 is added. Generic full-support and uniform-prior negative pairs, together with point-prior positive witnesses, are regression consumers. |
| `OM-058` | Extended Lemma 2 part 3's identical-row and deterministic witnesses as standalone general theorem families | C03 S04 checked the internal identical-row and deterministic common-posterior witnesses and their binary-output sufficiency regressions; independent validation satisfied all three criteria with no findings, and the original report was reconciled. No separate public theorem family, duplicate general representation-existence hierarchy or external special-case theorem from OM-007 is added; the all-ones matrix theorem remains C09. Helper promotion requires actual consumer pressure. C09 S01 implements the paper-facing all-ones seed using the public at-most-two-output equivalence; no private general witness is promoted. R01 checks the rectangular entries and existing active/ambient transports. |
| `OM-059` | Equation (9)'s word “distance” as a request for a full TV metric or arbitrary-measure library | C04 Draft revision 2 retains half-L1, overlap/positive-part identities, range/endpoints and the coupling application. Triangle inequality, metric instances, supremum-over-events characterizations and infinite alphabets have no required consumer here and are not targets. |
| `OM-060` | Extended Lemma 3 (156) and the unexpanded maximal-coupling attainment sentence after (161) | C04 represents the finite minimum by a universal bound and an explicit normalized attaining PMF with exact atom/support formulas; it does not assume an optimizer or import an external maximal-coupling theorem. No separate public optimization wrapper is promised. The ISIT text supplies Equation (9)/Lemma 3, while this proof anchor is extended. |
| `OM-061` | Extended Lemma 2 part 2 (115)-(121) as guaranteed public normalized-common/residual PMF APIs | C04 S03 implements unnormalized minimum/residual masses and a single-denominator product law, checking zero/one common mass explicitly; these probability contracts passed independent review and original-report reconciliation. No public distribution is created by normalizing zero mass. C05 retains the specialized construction's logical content and any needed bridge to (118)-(121), rather than requiring one C04 public name per auxiliary distribution. |
| `OM-062` | Neighboring extended Lemma 3 (147)-(155), (162)-(166) and Lemma 2 (111)-(124) as C04 semantic targets | These remain C05: canonical binary-vector interpretation, conditional entropy, information bound/attaining representation, singularity and prior/support choices. C04 supplies only the probability facts within the reviewed anchors. Earlier C03 material visible on the same pages remains completed C03 coverage, not reopened work. |
| `OM-063` | ISIT II support convention, Lemma 2 binary-input clause and Lemma 3 equality iff read on arbitrary ambient input priors | C05 approved revision 2 uses an intrinsic cardinality-two channel and explicitly full input support for the ambient-channel equality converse. The bound/attaining representation and singular forward equality allow arbitrary priors, with a mandatory nonsingular point-prior equality regression. A new theorem family on larger ambient input alphabets with support cardinality two is not required; C02's existing support-prior bridge remains available. This interpretation was explicitly approved with revision 2 on 2026-09-13; DG-04 records the decision. S05 implements the all-prior inequality/forward equality and explicit-full-support converse, with the nonsingular pure-prior equality regression. S05 durably closed after independent review, original-report reconciliation and final validation. |
| `OM-064` | ISIT II-C “maximum,” extended (155), (162)-(163), and unrestricted auxiliary wording | C05 S04 implements a universal bound over every finite auxiliary on an unrestricted source, specified maximal canonical attainment and a finite existential attaining triple-law extension, all for arbitrary priors. It does not assert an optimizer on an arbitrary original source, a supremum over types, uniqueness or minimal auxiliary cardinality, or infinite-auxiliary information theorems. C04 mismatch attainment is converted to actual information attainment through S03's entropy bridge. Focused/full validation and the public signature/axiom audit pass. Independent review satisfied all three S04 criteria, and the complete original report was reconciled. S04 durably closed; its closure and all 100 final source/environment entries were verified before S05 acceptance. See OM-046/OM-053. |
| `OM-065` | Extended Lemma 3 (152)-(154), especially (153) on zero-probability vector fibers | C05 preserves the weighted conditional-entropy identity. The evaluation-law/constant-or-injective entropy assertion is required on positive vector fibers; null fibers contribute zero under the pinned convention. No public pointwise entropy assertion for every arbitrary null completion or separate public theorem for each displayed line is promised. |
| `OM-066` | Extended Lemma 2 part 2 (112)-(124): A/B/C partition and normalized mixture components | The printed partition covers active outputs. C05 S02 includes both-zero ambient output fibers and proves the singular specialization of C04's atom law matches the shared-diagonal/exclusive-product construction, including overlap 0/1. The implementation provides a total common posterior with the pinned null fallback; revision 2 permits an alternative only at globally unused outputs with checked factorization preservation. No public A/B/C partition or normalized qA/qB/qC distribution family is required; no zero-mass normalization or ambient-law restriction is inferred from C04 subtype transport. OM-061's historical C04 disposition is retained. |
| `OM-067` | Extended (111)-(124), (147)-(166) proof intermediates and labels 1/2; adjoining completed and later material | C05 checks the logical content through product/vector/evaluation, singularity, entropy, bound/attainment and perfectness bridges, without a public name for every scalar step, r alias, or independent normalized-component API. S03 exposes the positive vector-fiber law and proves (149)-(154) through the pinned weighted entropy sum; null vectors vanish under their zero weight, without assigning an arbitrary completed PMF the printed entropy. S04 implements (155), (162)-(163) as a universal information bound and actual information attainment by the specified maximal canonical law, with its structural representation and exact pair law, plus a finite existential witness. Its point-prior branch uses zero input entropy without identifying an original decoder's unseen row with the specified channel. Focused/full validation and the public signature/axiom audit pass. Independent review satisfied all three S04 criteria, and the complete original report was reconciled. S04 durably closed. S05 now addresses (164)-(166) through the functional-representation information bound and binary perfectness/singularity bridge: inequality for every prior, singular forward equality for every prior, and the ambient-channel equality converse under explicit full input support. Lean labels 0/1 and arbitrary-cardinality-two enumeration require checked quantitative input transport; injective output relabeling retains actual witness information with unused labels and laws supplied on a common subtype. S05 inequality/equality and input transport are implemented, and R14-R17 include the mapped-channel and actual mapped-witness consumers. S05 durably closed after independent review, original-report reconciliation and final validation. Equation (9)/(156)-(161) reuse C04; Lemma 2 parts 1/3 and extended Lemma 7 remain completed C03; Appendix B and extended-only claims are not C05. See OM-042/OM-059-OM-062. |
| `OM-068` | Definition 4's divided ordered column as the primary pattern object | C06-S04 implements a nonempty input-support finset, derived Boolean/numeric indicators and the Real column/value division theorem. Exact/Real uniqueness and reconstruction preserve Definition 4 across this representation boundary; zero columns receive no data. Value one and repeated patterns with unequal values remain valid. See C06 implementation notes for validation/review status; the focused Example 1 fixture is recorded under OM-069. C10-S02 consumes this same nonempty support finset directly as a `Finpartition` carrier; its C06 regression requires no new ordered numeric pattern representation. C12 revision-1 proposal, 2026-09-29: occurring patterns are intrinsic finite members, grouping ignores unequal values, and exact aggregates supply a minimal positive Real family with row identities. Total pattern values need not sum to one. S03 owns generic data/channel recovery; arbitrary enumerations are proved presentations. These DG-10 choices awaited approval at that revision-1 checkpoint. Revision 2 was endorsed on 2026-09-29, resolving the design gate. S01 now implements the intrinsic finite family/fibers and exact semantic channel, with derived aggregate bounds and initial enumeration transport; validation and independent review pass, with final closure following the implementation checkpoint. S01 subsequently durably closed. S02 now implements the operation witness/reversal and constructive reachability transport; validation and independent review pass, with the original report reconciled; final applicability/F and durable closure follow the implementation checkpoint. S03/S04 retain Real-data and ambient obligations. C12 S02 subsequently durably closed. On 2026-09-30, S03 startup verified its closure and all 144 final entries before the conditional request was accepted. Exact Real aggregates, minimal positive row-normalized data and full generic recovery with membership transport are in progress; no completed generic recovery is claimed at this startup checkpoint. The preceding startup checkpoint remains historical. S03 now proves both round trips, including full dependent record recovery with membership transport, exact Real aggregates, derived bounds/output nonemptiness and supplied finite presentations. The data domain includes the existing singular nonperfect example. Validation and independent review pass; all three S03 criteria are satisfied without findings and the original report is critically reconciled. Final applicability/F and durable closure follow this provisional checkpoint. S04 retains ambient/injection integration. C12 S03 subsequently durably closed; its closure and all 144 final source/environment entries were verified before S04. The preceding pre-F checkpoint remains historical. S04 now supplies full extracted-data transport under injective ambient relabeling and supplied active presentations, plus the ambient channel-to-data perfectness bridge. Implementation validation passes; independent review is reconciled; final S04 closure remains pending. The optional idempotence alias was revisited and remains deferred to concrete C13 consumer pressure under the existing plan Section 9 record. S05 checkpoint, 2026-09-30: S01-S04 durable closure and exact S04 final-source applicability are verified; fresh cumulative source/manuscript/build/trust checks support this C12 obligation. Cumulative independent review passes and both original reports are reconciled; final applicability/F and supported closure remain. Earlier checkpoints retain their historical meaning. At the C13 S05 consumer reassessment, existing compressedPatternData_map_injective and extraction_roundTrip still suffice. No alias is added; the original optional suggestion is declined for C13, with a fresh demonstrated need required to reopen it. C15 S04 initial checkpoint, 2026-10-02: all-vector/inverse entire dual-image transport and exact reduced-variable count are implemented and validated; independent step review remains pending. [C15 readiness](pfr-c15-readiness-audit.md) owns current crosswalk; S05 cumulative closeout is unstarted. Current C15: S01-S04 are durably complete; S05 freshly revalidates this disposition and its cumulative independent report is reconciled. Final applicable F/supported CC09 closure follow this checkpoint. |
| `OM-069` | Definition 4's Example 1 sentence as a separate stable public theorem family | C06-S05 adds a separately imported fixture consuming C03's existing channel: raw and direct-state column 0, exact/Real value `1/2`, support `{0,1}`, Boolean `[true,true,false]` and ordered numeric/divided `[1,1,0]^T`. Its direct `Fin 3` state preserves all labels. See the C06 readiness audit for validation/review status. Fixture helpers remain private; no duplicate channel or nonrepresentability proof is added. |
| `OM-070` | ISIT III-A PPM/VPM source indices literally restricted through `m` although the input has `m+1` columns | **2026-09-21 disposition: duplicate of OM-024; identifier and rationale retained.** Originally added during C07 revision-1 planning to record extended v16's full range, lower-index survivor, higher-index deletion, and later-column shift, with S01-S03 index/mass proofs and S04 Examples 3/5 regressions. OM-024 now owns this same obligation. The correction still prevents dropping final-column cases without changing the operation. |
| `OM-071` | Extended Example 6 (29)-(30) as literal equality in the established ordered PPM convention | C10 planning, 2026-09-28: merging positions 2 and 4 retains the lower position, yielding `[A/3, 2U/3, B/3]`; (30) displays `[A/3, B/3, 2U/3]`. Proposed C10-S06 must prove the explicit transposition of the last two labels and the full certificate (25)-(32), or compare the exact-order path using its adjusted next indices. Preserve C07's survivor rule. This is an output-equivalence repair, not a change to the reachability claim; OM-027 retains private fixture ownership. C10-S06 implementation, 2026-09-29: `Examples.Reachability` checks every coordinate (25)-(32), the directed swap of zero-based labels 1 and 2, and the exact-order four-operation path using pairs (1,2), (1,3), (0,2), (0,1). Its actual reverse certificate gives prior-free easy perfectness. The planned bridge is implemented; validation/review status belongs to the C10 implementation notes. |

The register is a living audit. A newly noticed omission must receive a new
entry or be explicitly subsumed by an existing entry. Do not renumber entries.
An omission can later become formalized, deferred, combined, or
publication-curated, but its dated disposition belongs in the project log.

## 10. Validation Required of Every Chunk

Every detailed plan should specialize, not weaken, these duties:

1. Record exact ISIT and extended anchors, extended digest, and dependency
   baseline.
2. Search pinned LeanInfoTheory, its generated API material, and pinned
   mathlib before introducing an information-theoretic helper.
3. Verify every candidate external declaration with `#check`, `#print`, or a
   compiling focused probe.
4. Resolve assigned decision gates and record representation departures.
5. Distinguish intrinsic channel cardinality from pair support and record all
   finite-valued hypotheses required by information quantities.
6. Cover null fibers, support restrictions, degenerate alphabets, zero
   columns, value-one operation endpoints, and numeric conversions that touch
   the chunk.
7. Expand every multiway or inverse-operation shorthand into a checked finite
   path or an exact recovery theorem.
8. Build the touched module and important downstream aggregates.
9. Scan project Lean source for forbidden placeholders.
10. Inspect public declarations and imports for accidental API or dependency
   expansion.
11. Reconcile this map, the living summary, project log, roadmap, and the
   approved plan when status or downstream contracts change.
12. Obtain an independent validation pass against the chunk's explicit
    completion criteria.

## 11. Planning Order

PFR-C01 Draft revision 2 was approved on 2026-09-04 and `DG-01` is resolved.
Approval-checkpoint commit `5a9c7ca999639afe26c7bf235b4d044e0341b55a`
is the verified execution baseline. PFR-C01 is `Complete`. S01-S08 are validated,
with S02 and S03 separately authorized and completed on 2026-09-05. S04 was
separately authorized and completed on 2026-09-06. S05 was separately
authorized on that date and completed on 2026-09-07. S06 was explicitly
authorized and validated on 2026-09-07. S07 integration was explicitly
authorized and internally validated that day. The project lead then explicitly
authorized S08; its independent chunk-wide pass and completion reconciliation
completed on 2026-09-07. The lead authorized C02 reviewer setup and detailed
planning on 2026-09-10, then approved Draft revision 3 by requesting S01 with
review. S01-S07 are complete; S08 was accepted under a separately processed
conditional request after exact S07 closure/source verification. C02
fresh cumulative independent validation, reconciliation and durable S08 closure
passed. C03's authorized planning pass on 2026-09-11 verified the actual closure
and source applicability, established its own reviewer, and prepared proposed
Draft revision 1. The lead then requested independent C03 plan review and
suggestions; that pass is complete, with the two documentation corrections
recorded in entry 49. The lead then supplied an advisory review and authorized
selecting suggestions for Draft revision 2; see entry 50. The revised proposal
keeps the allocation and seven steps, with one added S06 integration consumer.
The lead then approved exact revision 2 and requested S01 with review. S01 is
independently validated and durably complete. The lead's conditional S02 request
was accepted only after verifying closure and exact source applicability; S02's
independent review passed with all three criteria satisfied and no findings,
followed by durable closure. The separate conditional S03 request was accepted
after verifying that closure and exact current-source applicability. S03 passed
independent review with all three criteria satisfied and no findings; the original
report was reconciled, followed by durable S03 closure. The separate conditional
S04 request was accepted after checking that closure and exact current-source
applicability. S04 passed independent validation with all three criteria satisfied
and no findings; the original report was reconciled and S04 durably closed. The
separate conditional S05 request was accepted after exact closure/source
verification. S05 passed independent validation with all three criteria satisfied
and no findings; the original report was reconciled and S05 durably closed. The
separate conditional S06 request was accepted after exact closure/source
verification. S06 root integration and R14/R15 consumers are implemented, the
readiness audit is populated. All three S06 criteria passed independent review
with no independent findings; the original report was reconciled and S06 durably
closed. The separate conditional S07 request was accepted after exact closure/source
verification. S07 fresh cumulative validation and independent review passed; the
original report was reconciled and S07 durably closed. C04 startup verified
the original record and exact source applicability; C03 is complete. C04
reviewer setup, detailed planning and Draft revision 1 review are complete. The
original review is reconciled with all six criteria satisfied and one optional
suggestion; neither plan approval nor mathematical implementation follows from it.
The lead then supplied an advisory review and authorized selection/application
of improvements. Proposed Draft revision 2 separates reviewable readiness from
subsequent closure, corrects the import description, specifies the common
carrier and extends R09 with one unequal-weight fixture. Scope, allocation and
dependencies remain; the original review is not acceptance of revision 2.
The lead then accepted revision 2 and requested S01 with review. Its exact
baseline was captured by the installed execution workflow. S01 subsequently
passed independent review with all three criteria satisfied and no findings;
the report was reconciled and S01 durably closed. Its closure and exact source
applicability were verified before the fresh S02 request. S02 implements the
coupling/mismatch bound and decoding bridge. S02 passed independent review with all three criteria satisfied and no findings;
the original report was reconciled. S02 durably closed; its closure and exact source applicability were verified
before accepting the fresh S03 request. S03 implements the explicit maximal coupling, exact attainment and
support/endpoint contracts. All three S03 criteria passed independent review with no findings; the
original report was reconciled and S03 durably closed. Its closure and exact
source applicability were verified before accepting the fresh S04 request.
S04 implements injective relabeling, swap and C05 probability consumers.
All three S04 criteria passed independent review with no findings; the original
report was reconciled and S04 durably closed. Its closure and exact source
applicability were verified before the fresh S05 request was accepted.
S05 durably closed after independent review, original-report reconciliation and final validation. Its closure and exact final source applicability were verified before the fresh S06 request. S06 independent cumulative review, original-report reconciliation, final validation and durable closure completed. C05 startup verified the completion record and exact prerequisite sources; see the C05 planning notes. For C05's current S07 cumulative review/closeout status and verified S01-S06 closure, see [C05 implementation notes](pfr-c05-implementation-notes.md). Commits and pushes remain unapproved. C04's probability
portion of DG-05 is approved,
with no C05 semantic decision implied.
C02 independent plan review was not requested.
No later chunk may begin automatically.

The C02 planning pass inspected what C01 actually exposed. Hold the
Section 6 checkpoints before approving `PFR-C06`, `PFR-C11`/`PFR-C12`,
`PFR-C13`, and `PFR-C15`. This staged replanning is intentional: it preserves a
coherent global direction without pretending that high-risk Lean interfaces
can be fixed perfectly before the preceding proofs exist.
