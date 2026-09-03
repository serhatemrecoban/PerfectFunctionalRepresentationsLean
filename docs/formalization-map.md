# PerfectFunctionalRepresentationsLean Formalization Map

**Status:** project-lead-accepted revision 2; current non-authorizing global map
**Created:** 2026-09-03
**Last adversarial review:** 2026-09-03
**Project-lead acceptance:** 2026-09-03
**Implementation baseline:** repository commit `0e28f7a`; Lean declarations
are unchanged from the bootstrap implementation at `57e132c`
**Dependency baseline:** LeanInfoTheory `v0.1.0` at
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`, Lean and mathlib `v4.33.1`

This is the canonical, adaptable global map for the paper formalization. It
assigns source coverage, records dependency order and decision gates, and
proposes coherent theorem-development chunks. It is more concrete than the
[roadmap](roadmap.md) and less detailed than an approved file under
`docs/plans/`.

The map does **not** authorize implementation. Each chunk requires its own
detailed plan and explicit project-lead approval. No chunk is approved or
active at this revision.

## 1. How to Read and Maintain This Map

The map is a working reference, not a frozen prediction. Proof discoveries may
change representations, dependencies, module boundaries, or chunk sizes. Such
changes should improve the map radther than force an obsolete plan onto the
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
| Draft plan under review | A proposed detailed contract exists outside the approved-plan register; it is non-authorizing |
| Approved | The project lead approved the detailed plan |
| Active | Work is proceeding under the approved plan |
| Complete | The approved completion and independent-validation criteria passed |
| Superseded | The allocation was replaced, with its successor recorded |
| Deferred | Work remains discoverable but is outside the current implementation sequence |

At revision 2, `PFR-C01` through `PFR-C16` are all **Mapped**. All decision
gates in Section 5 are **Open**: their recommendations are planning hypotheses,
not adopted theorem or representation contracts.

## 2. Source and Interpretation Contract

### Primary target

The primary source is the six-page ISIT manuscript *On Perfect Functional
Representations*, reviewed in full, with SHA-256 digest:

`48963AA59485B2C33B1A1E6E7C6EAD2251FDDDD26BD3691B6FCFFE683E6ED1C4`.

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
proposed prior-free channel contract in `DG-03`.

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
`geometric_hahn_banach_point_closed` and `dotProductEquiv`. Its suitability for
the exact `PFR-C15` obligations remains a proof-design question rather than an
approved duality route.

The pinned dependencies have no ready paper-specific functional
representation, canonical-representation, perfect-representability,
singular-channel, or split/merge API. They also have no ready finite-PMF
maximal-coupling/total-variation interface and no theorem-level LP
strong-duality layer. Mathlib has useful finite sums, matrices, finite sets,
equivalences, convex geometry, and signed/vector-measure total variation, but
those facilities do not remove the local design work identified below.

No external information-theory formalization repository is an allowed
dependency or discovery source without separate project-lead approval.

## 4. Proposed Mathematical and Module Architecture

The architecture should follow the mathematics rather than the paper's page
order:

| Layer | Responsibility | Candidate modules |
| --- | --- | --- |
| Semantic | Random-variable functional representations, entropy identity, canonical couplings, perfect representability, singularity, binary cases | `Semantics/FunctionalRepresentation.lean`, `Semantics/Canonical.lean`, `Semantics/Singularity.lean`, `Semantics/Binary.lean` |
| Finite coupling | Finite-PMF total variation, coupling bounds, and maximal coupling | `Probability/FiniteCoupling.lean` |
| Finite matrix | Channel-coordinate bridge, singular columns, typed split/merge operations, normal forms, a minimal exact-partition interface, preservation, and reachability | `Matrix/Channel.lean`, `Matrix/Operations.lean`, `Matrix/OperationCalculus.lean`, `Matrix/Partitions.lean`, `Matrix/Preservation.lean`, `Matrix/Reachability.lean` |
| Optimization | Equal-pattern compression, exact-partition incidence systems, full/reduced equivalence, primal and dual characterizations | `Matrix/PatternCompression.lean`, `Optimization/Incidence.lean`, `Optimization/Primal.lean`, `Optimization/Dual.lean` |
| Demonstration | Paper examples and computational checks that should not burden the stable API | focused `Examples/` or `Tests/` modules chosen by the relevant chunk |

All paths are proposals. A detailed plan may refine them after import and API
probes.

The project root should expose the lightweight semantic API that proves useful
to users. Matrix, optimization, and bulky demonstration modules should remain
separately importable unless later use gives a concrete reason to broaden the
root. Paper-specific declarations remain in namespace
`PerfectFunctionalRepresentations`.

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
| `DG-01` | Open | Choose the pair-level carrier: a common base PMF with random-variable maps, or an equivalent joint-law package with proved transport. Define structural functional representation using `IsIndependentOf` plus existence of a support-correct decoder, separately from entropy equalities. The zero-conditional-entropy theorem supplies some decoder; it does not validate an arbitrary preselected bundled decoder. State Equation (1)-(3) results only under the finite-valued hypotheses required by LeanInfoTheory, including a finite auxiliary alphabet. | `PFR-C01` |
| `DG-02` | Open | Represent a marginally canonical auxiliary by a law `q : PMF (alpha -> beta)` whose coordinate pushforwards equal channel rows, but do not mistake those marginals for a canonical representation of an already fixed pair. The pair contract must retain `Y = W_X` on source support and the correct joint law; the channel contract covers every input. | `PFR-C02` |
| `DG-03` | Open | Give channel-level perfect representability a prior-free factorization contract. The preferred witness is one posterior `V : beta -> PMF (alpha -> beta)` with `q.map (fun w => (w x, w)) = PMF.channelJoint (kappa x) V` for every `x`. Prove its connection to full-support-prior Markov statements and explain arbitrary null-output fibers. The pinned channel-extension equivalence factors one joint law only; `PFR-C02` must prove the full-support cancellation that yields a single common `V` across all inputs. | `PFR-C02` |
| `DG-04` | Open | Separate intrinsic channel cardinality from pair support. For the binary-input channel clause, prefer `Fintype.card alpha = 2`; for Lemma 3, use a full-support input PMF or transport to its support subtype. For binary output, use the channel's active-output union or prove invariance under adding/removing globally zero outputs. Use checked relabeling to expose `Fin 2` constructions. | `PFR-C03` and `PFR-C05` |
| `DG-05` | Open | Choose a local finite-PMF real-valued total-variation and coupling interface, freezing its normalization. Represent a coupling as a PMF on `beta × beta` with the existing marginal operations; retain exact `ENNReal` construction data while exposing the paper's finite `Real` equality. Express “maximum over all auxiliaries” as a universal upper bound plus a finite attaining witness. | `PFR-C04` and `PFR-C05` |
| `DG-06` | Open | Fix the finite matrix state and its equivalence with `alpha -> PMF beta`. The leading candidate is an active heterogeneous indexed state based on `Sigma fun m => alpha -> PMF (Fin m)`, with `[Nonempty alpha]`, positive output cardinality, output-relabeling invariance, an `ENNReal` mass view, and a derived `Real` view. Do not use a bare Sigma or matrix as a second semantic channel: when the input type is empty, the bare Sigma admits the meaningless `m = 0` case. | `PFR-C06` |
| `DG-07` | Open | Make positive input/output cardinality and active nonzero columns explicit at the paper matrix boundary. Singularity is vacuous on an all-zero column, so no value or pattern may be invented for one. | `PFR-C06` |
| `DG-08` | Open | Choose how operations change output types and preserve paper order. PPS weights should be strict; an active VPS must produce nonempty pieces or use a raw-split/pruning bridge. Resolve the printed `0 < beta < 1` VPS restriction against later value-one splits. “Inverse” claims must be witness-parameterized recovery theorems, with exact equality or explicit output equivalence, not global bijections. | `PFR-C07` |
| `DG-09` | Open | Choose a tagged inductive one-step operation type recording whether a step is PPS, VPS, or PPM, and build heterogeneous paths from it, likely with `Relation.ReflTransGen`. An untagged existential relation loses the operation order that Lemma 4 must normalize. Define “equivalent cascade” by proved endpoint equality/equivalence and supply a well-founded normalization or structural factorization, not an unsupported “swap until done” assertion. | `PFR-C08` |
| `DG-10` | Open | Fix the `ENNReal`-to-`Real` boundary for column values and optimization weights. Keep channel masses exact in `ENNReal` until the finite real-coordinate view is needed, then prove nonnegativity, row sums, and reconstruction. | `PFR-C06` and `PFR-C12` |
| `DG-11` | Open | Represent patterns label-invariantly, preferably as nonempty support finsets. Introduce the minimal checked exact-partition interface needed by multiway VPS and decoder fibers in `PFR-C10`, using mathlib `Finpartition` or an equivalent structure. Enumeration may use a classical/noncomputable internal `DecidableEq`; do not leak it as a mathematical public assumption. Let `PFR-C13` own enumeration, incidence, and ordered matrix presentations rather than defining the first partition notion after its consumers. | `PFR-C10` and `PFR-C13` |
| `DG-12` | Open | Reject the literal ISIT `m × R` system that retains all Bell partitions while dropping unobserved-pattern rows. Make the extended full all-nonzero-pattern system and the reduced admissible occurring-pattern system separate objects connected by a proved equivalence for nonnegative equality feasibility. The qualifier is essential: without nonnegativity, coefficients on inadmissible partitions can cancel on omitted rows. The reduced dual has `m` variables; do not transfer that count to the full encoding. | `PFR-C13` |
| `DG-13` | Open | State the primal core on valid compressed active singular pattern data and the paper-facing channel theorem through the `PFR-C12` bridge. The contract should be an iff between channel perfect representability and `IsGreatest (objective '' feasible) 1`, or an equally explicit formulation, rather than unconditional greatestness. Require nonempty input: the displayed primal is otherwise unbounded. | `PFR-C14` |
| `DG-14` | Open | State the dual core on the same valid reduced data and connect it to the paper-facing channel theorem. Use `IsLeast` and prove only the specialized finite alternative needed here. The leading route uses `geometric_hahn_banach_point_closed`, converts the functional with `dotProductEquiv`, then corrects it by the positive pattern-cardinality vector. Its plan must prove sign correction, positive scaling, and nonzero denominators. Do not promise a generic LP strong-duality library. | `PFR-C15` |
| `DG-15` | Open | Classify remarks and examples as public theorems, private proof fixtures, compiling examples, or documentation-only coverage according to downstream value. Revision 2 recommends named theorem coverage for ISIT Remark 1 and the central Example 1 counterexample, fixtures for ISIT Examples 2-7 and current-extended Examples 2-8, and documentation-only treatment of externally sourced ISIT Remark 2. | Each owning chunk; final audit in `PFR-C16` |

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

## 7. Candidate Chunks

### PFR-C01 — Semantic Functional Representations

**Anchors:** ISIT Section I, Equations (1)-(3).
**Prerequisites:** pinned `PMF` and LeanInfoTheory semantic bridge.
**Risk:** medium.
**Candidate module:** `Semantics/FunctionalRepresentation.lean`.

This chunk should:

- choose and document the common probability-space or joint-law carrier used
  for pair-level random variables, with transport lemmas sufficient to avoid
  dependence on an accidental sample-space presentation;
- define a support-aware semantic functional representation of `(X,Y)` by
  an auxiliary `Z` and existence of a decoder correct almost surely;
- define the pair-level notion of a perfect functional representation and
  prove its equality, zero-CMI, and Markov formulations equivalent;
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

**Anchors:** ISIT Section II-A, Equations (5)-(7), Definition 1, Remark 1,
Lemma 1, Definition 2; current extended Section II-A.
**Prerequisite:** `PFR-C01`.
**Risk:** high because it fixes the semantic API used by every later chunk.
**Candidate module:** `Semantics/Canonical.lean`.

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

The detailed plan must settle `DG-02` and `DG-03` before declaring the public
API. Pair-level statements may transport to the input-law support, whereas the
intrinsic channel contract covers every input of its declared input alphabet.
Null fibers, globally unused outputs, and zero-prior input symbols are
mandatory test cases.

### PFR-C03 — Singularity Core, Binary Output, and Counterexample

**Anchors:** ISIT Section II-B, Definition 3, Lemma 2, Equation (8), Example 1;
current extended Appendix A and its Lemma 7 proof.
**Prerequisite:** `PFR-C02`.
**Risk:** high.
**Candidate modules:** `Semantics/Singularity.lean` and a separately importable
`Examples/Nonrepresentable3x3.lean` module containing the named counterexample
theorem.

This chunk should:

- define singularity intrinsically for a finite channel;
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

**Anchors:** ISIT Equation (9) and Section II-C maximal-coupling argument;
current extended Appendix A, pages 13-14.
**Prerequisites:** pinned finite `PMF` infrastructure only; independent of the
semantic chunks.
**Risk:** high because the pinned libraries have no ready finite-PMF coupling
API.
**Candidate module:** `Probability/FiniteCoupling.lean`.

This chunk should:

- define finite-PMF total variation in `Real`, freeze whether the normalization
  is the half-`L1` or overlap form, and prove the finite-sum forms actually
  needed by the paper;
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

**Anchors:** binary-input clause of ISIT Lemma 2; ISIT Section II-C,
Equation (10), Lemma 3; current extended Appendix A, pages 13-14.
**Prerequisites:** `PFR-C02`, `PFR-C03`, and `PFR-C04`.
**Risk:** high.
**Candidate module:** `Semantics/Binary.lean`.

This chunk should:

- prove singularity is sufficient for an intrinsic channel whose input
  alphabet has cardinality two;
- expose the final combined paper-facing Lemma 2 from the three separately
  proved clauses;
- connect binary canonical couplings, mismatch events, and conditional
  entropy;
- prove that every finite-auxiliary binary-input functional representation
  under the chosen full-support or support-subtype contract satisfies the
  upper bound `I(Y;Z) <= H(Y) - r H(X)`;
- construct a finite representation attaining the bound, which gives a
  type-safe Lean meaning to the manuscript's “maximum”; and
- prove `r H(X) = I(X;Y)` exactly in the singular case under the correct
  binary/full-support contract.

Construction-heavy arguments may use `Fin 2` and transport through a checked
cardinality-two equivalence. The chunk plan must state whether its pair theorem
assumes full input support or is formulated on `pX.supportFinset`. A
degenerate-prior regression test is mandatory: without full input support,
`r H(X) = I(X;Y)` can hold for a nonsingular ambient channel.

### PFR-C06 — Finite Channel-to-Matrix Boundary

**Anchors:** ISIT opening of Section III and Definition 4; current extended
Section III-A.
**Prerequisites:** `PFR-C02` and `PFR-C03`.
**Risk:** high because this chunk fixes changing-dimension and numeric
interfaces.
**Candidate module:** `Matrix/Channel.lean`.

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
  columns, noting that restriction to a support subtype needs a normalized
  finite PMF construction rather than an unjustified plain `PMF.map`;
- define the value and pattern of every admitted nonzero singular column;
- prefer a nonempty support finset for the core pattern, with Boolean-vector
  and ordered-column presentations derived at the paper boundary;
- check Definition 4's observation that Example 1's first column has value
  `1/2` and pattern `[1,1,0]^T` as a focused fixture;
- prove reconstruction from value and pattern, uniqueness, nonnegativity,
  upper bounds, and row-sum facts; and
- provide explicit arbitrary-finite-type/`Fin` reindexing for paper matrices.

No operation should be implemented before `DG-06`, `DG-07`, and `DG-10` are
resolved. Mathlib's square-only row-stochastic matrix predicate is not by
itself a suitable rectangular channel owner.
The semantic channel remains authoritative; matrices are a proved finite
coordinate representation, not a second probability theory.

### PFR-C07 — Four Typed Matrix Operations

**Anchors:** ISIT Section III-A, Equations (11)-(15), Examples 2-5; current
extended Section III-A, including the corrected merge indices.
**Prerequisite:** `PFR-C06`.
**Risk:** high.
**Candidate module:** `Matrix/Operations.lean`.

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

**Anchors:** ISIT Lemma 4; current extended Appendix B, local rewrites
corresponding to Equations (167)-(174).
**Prerequisite:** `PFR-C07`.
**Risk:** high.
**Candidate module:** `Matrix/OperationCalculus.lean`.

This chunk should:

- define a tagged inductive one-step operation type and heterogeneous paths,
  likely with `Relation.ReflTransGen` over the packaged channel state;
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

**Anchors:** ISIT Lemmas 5-6 and surrounding Section III-B prose; current
extended Appendix B preservation constructions.
**Prerequisites:** `PFR-C02`, `PFR-C06`, and `PFR-C07`.
**Risk:** high because semantic witnesses must cross the coordinate boundary.
**Candidate module:** `Matrix/Preservation.lean`.

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

**Anchors:** ISIT Theorem 1 “if” direction and the operation constructions
used by Section IV; current extended Theorem 1 opening and Example 6.
**Prerequisites:** `PFR-C08` and `PFR-C09`.
**Risk:** high.
**Candidate modules:** `Matrix/Partitions.lean` and
`Matrix/Reachability.lean`.

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

**Anchors:** ISIT Theorem 1 and Appendix Equations (20)-(28); current extended
Theorem 1 proof, Equations (16)-(24), Figure 1, and Appendix B.
**Prerequisites:** `PFR-C02`, `PFR-C06`, and `PFR-C10`.
**Risk:** very high.
**Candidate module:** `Matrix/Reachability.lean` or a focused theorem module
importing it.

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

**Anchors:** ISIT Section IV opening compression prose; current extended
Section IV-A full/reduced setup.
**Prerequisites:** `PFR-C06` through `PFR-C10`.
**Risk:** high.
**Candidate module:** `Matrix/PatternCompression.lean`.

This chunk should:

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

**Anchors:** ISIT Section IV-A, Equation (16), incidence matrix Equation (17),
Examples 6-7; current extended Section IV-A, Equations (33)-(63), Examples
7-8.
**Prerequisites:** `PFR-C10`, `PFR-C11`, and `PFR-C12`. Read-only design may
start earlier, but implementation of this single chunk waits for all three.
**Risk:** very high.
**Candidate module:** `Optimization/Incidence.lean`.

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

**Anchors:** ISIT Theorem 2 and Equation (18); current extended Theorem 2,
Equation (64), and Appendix B proof Equations (203)-(221).
**Prerequisite:** the completed `PFR-C13` interface, which already carries the
reachability/perfect-representability equivalence from `PFR-C11`.
**Risk:** high.
**Candidate module:** `Optimization/Primal.lean`.

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

**Anchors:** ISIT Section IV-B, Corollary 1, Equation (19); current extended
Section IV-B and Equation (65).
**Prerequisites:** `PFR-C13` and `PFR-C14`.
**Risk:** very high because no ready pinned strong-duality theorem was found.
**Candidate module:** `Optimization/Dual.lean`.

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

**Anchors:** complete six-page ISIT manuscript and every completed chunk plan.
**Prerequisites:** all in-scope chunks.
**Risk:** medium, but mandatory.
**Candidate artifacts:** documentation, import audits, and focused validation
modules; no theorem family is allocated here.

This chunk should:

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
- review the internal omission register for project-lead-approved
  publication-facing curation.

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
| `OM-014` | Literal identification of supports with `{1,...,k}` and `{1,...,m}` | Representation departure, not lost mathematics: semantic chunks use arbitrary finite support types and `PFR-C06` proves the finite-coordinate bridge. |
| `OM-015` | Narrative that singular channels are important in [17] | Context and attribution only; no Lean proposition. |
| `OM-016` | Claims that singularity can be checked in linear time | Algorithmic complexity claim, not required for the structural theorem; documentation-only unless executable algorithms receive separate approval. Broader ISIT complexity prose is `OM-019`. |
| `OM-017` | Bell-partition count and Bell-number growth | [33] supports the ISIT Bell-number/count discussion; current-extended [34] supports the growth claim. Exact partitions are needed in `PFR-C13`, but the enumerative identity and asymptotic growth are not theorem prerequisites. |
| `OM-018` | Executing an LP solver to decide perfect representability | Theorems 2 and Corollary 1 are formal targets; certified solver integration and executable decision software are deferred roadmap work. The current-extended theoretical algorithm is separately tracked in `OM-028`. |
| `OM-019` | ISIT running-time discussion, “linear in the output-alphabet size/exponential in the input-alphabet size,” number-of-constraint discussion, and open efficient-solvability question | Documentation-only source coverage. The exact finite coordinate bounds used by the mathematics are assigned to `PFR-C13`; the Bell enumeration is `OM-017` and extended answers are `OM-028` through `OM-031`. |
| `OM-020` | Figure 1 as a graphical artifact | Do not reproduce the figure. `PFR-C11` formalizes the partition and operation construction it illustrates. |
| `OM-021` | ISIT Appendix proof Equations (20)-(28) as individually named public results | Their content is proof-internal to `PFR-C11` unless later reuse justifies a helper. Checked proof coverage is mandatory even without matching public names. |
| `OM-022` | Abstract, section outline, concluding restatement, acknowledgements/funding, author metadata, and ordinary transitions | No duplicate Lean declarations. Mathematical claims are routed by the coverage tables; nonmathematical publication metadata remains documentation. |
| `OM-023` | Bibliography entries as mathematical developments | Citations and provenance only. None of the referenced works is treated as formalized by this repository. |
| `OM-024` | ISIT's literal PPM/VPM merge-index range through `m` for a source in `S_{k,m+1}` | Do not formalize the inconsistent literal range. Use the current extended draft's clarified range through `m + 1` and record the source repair in `PFR-C07`. |
| `OM-025` | Any reading that assigns “`m` dual variables” to the full `2^k - 1`-coordinate system | Do not formalize this misleading conflation. `PFR-C13` proves the full/reduced equivalence; `PFR-C15` states `m` only for the reduced dual. |
| `OM-026` | Examples 2-5 as guaranteed stable public declarations | Their calculations are planned as fixtures in `PFR-C07`. Public names are intentionally undecided until the operation API shows genuine reuse value. |
| `OM-027` | ISIT Examples 6-7 and current extended Examples 6-8 as guaranteed stable public declarations | Current-extended Example 6 is a `PFR-C10` reachability fixture; ISIT Example 6/current-extended Example 7 and ISIT Example 7/current-extended Example 8 are `PFR-C13` partition/incidence fixtures. They are validation or demonstration content rather than stable public API. |
| `OM-028` | Current extended Section V-A separation-oracle algorithm | Extended-only: omit the subset recurrence, minimizing-partition witness recovery, `O(m 2^k)` separation-call bound, constraint-generation runtime, separation-optimization appeal [35], `2^k poly(m,L)` guarantee, and fixed-`k` consequence. These are theoretical complexity results, not the executable-solver deferral in `OM-018`. |
| `OM-029` | Current extended Appendix C-A separation and exact-optimization hardness | Extended-only: omit RXC3 [37], NP-hardness/NP-completeness of separation, hardness of the first constraint-generation call, exact compact-dual optimization hardness, its strong-duality transfer to the primal, and the caveat that this does not prove optimality of the `2^k` dependence. |
| `OM-030` | Current extended Theorem 3 and 3-colorability reduction for NP-hardness of perfect representability | Extended-only theorem relying on 3-colorability NP-completeness [36]; outside current scope. |
| `OM-031` | Current extended Appendix C-B and Corollary 2 | Extended-only bounded-degree reduction [38] and hardness under all four stated restrictions: every positive entry is `1/3`, every row has three positive entries, every occurring pattern has value `1/3`, and every occurring pattern has size at most five. |
| `OM-032` | Current extended Section VI information-measure discussion | Extended-only: omit the definitions, derivations, and claimed relations for Wyner common information, `g0`, `h0`, excess functional information, Körner graph entropy, the privacy funnel, and the binary-erasure counterexample. `OM-009` through `OM-011` separately own the related ISIT introduction/Remark 2 citations. These extended claims rely on external results and their literal contracts are not accepted: the displayed excess-functional-information minimization appears to suppress a decoding constraint, while the supremum discussion may suppress attainment. Revisit only under separately approved scope. |
| `OM-033` | Current extended Lemma 7 as an additional public theorem name | Its mathematical content is the proof of ISIT Example 1 and is assigned to `PFR-C03`. The extended numbering does not create a separate target. |
| `OM-034` | Current extended Section VII conclusion and additional bibliography [34]-[38] | No duplicate formal statements; extended-only claims are covered by `OM-028` through `OM-032` and citations remain provenance. |
| `OM-035` | Bits-versus-nats phrasing in source discussion | Canonical theorems use LeanInfoTheory's nats. No parallel bit-valued hierarchy; optional conversion is deferred unless a paper-facing presentation needs it. |
| `OM-036` | Introductory descriptions that `Z` “captures all information” and that functional representations are nonunique | Documentation-only intuition. The exact independence, decoding, and optimization statements are formalized; no vague duplicate predicate is introduced. |
| `OM-037` | Prose calling canonical properties “trivial,” operation closure “straightforward,” or singularity “easy” | No theorem corresponds to an adjective. The underlying canonical properties and operation-closure facts are formal targets; algorithmic ease is covered by `OM-016`. |
| `OM-038` | Generic VPS definition with an all-zero or all-one splitting vector | The unrestricted generic mask can create a zero child column and make its value/pattern language undefined. `PFR-C07` will formalize a nondegenerate active operation or an explicit raw-split/pruning bridge. The separate implicit parameter assumption needed by Examples 2-5 is tracked in `OM-050`. |
| `OM-039` | A reusable general linear-program or conic strong-duality library | Not needed to claim Corollary 1. `PFR-C15` targets the specialized finite alternative only; any general library work requires separate scope and ownership review. |
| `OM-040` | A second formal proof of Example 1 derived later from Theorem 1 | The direct extended Lemma 7 argument is assigned to `PFR-C03`. The later theorem may yield a corollary/check, but duplicate public proof infrastructure is not a target. |
| `OM-041` | Refined product-channel redundancy rates from [17] | Externally sourced: omit the leading `(1/2) log n` nonsingular statement and sublogarithmic singular statement. They are distinct from the general normalized product consequence in `OM-006`. |
| `OM-042` | Numbered construction and proof intermediates as guaranteed public declarations | ISIT Equations (6)-(7) are checked content of `PFR-C02` and ISIT Appendix Equations (20)-(28) are covered by `OM-021`. Current-extended Theorem 1 Equations (16)-(24) belong internally to `PFR-C11`; Example 6 Equations (25)-(32) are covered by `OM-027`; and the full/reduced construction and proof Equations (33)-(63) belong to `PFR-C13` without promising a public name for every line. Current-extended Lemma 2 Equations (105)-(134) belong internally to `PFR-C03`/`PFR-C05`; Lemma 7 (135)-(146) to `PFR-C03`; Lemma 3 (147)-(166) to `PFR-C04`/`PFR-C05`; Lemma 4 (167)-(174) to `PFR-C08`; Lemmas 5-6 (175)-(202) to `PFR-C09`; and Theorem 2 (203)-(221) to `PFR-C14`. Equations (66)-(68) divide between the reduced-dimension claims in `PFR-C13`/`PFR-C15` and Bell enumeration in `OM-017`. All assigned logical content must be checked, but one public Lean name per printed line is not promised. |
| `OM-043` | Treating the current-extended adjacent-rewrite discussion as a complete termination proof of Lemma 4 | Do not copy the informal “repeat interchanges” step without justification. `PFR-C08` must supply a structural factorization or well-founded normalization argument, especially when a rewrite lengthens the path. |
| `OM-044` | Literal set notation `S` and `S_{k,m}` as the Lean owner of channel matrices | Replace it with the typed active channel-state package selected in `PFR-C06` and prove its coordinate/`Fin` presentation. This is a representation repair, not a change to the theorem. |
| `OM-045` | Ambient zero columns and “without loss of generality” deletion of zero auxiliary weights | Do not assign a fake value or pattern. `PFR-C06` owns active-output restriction, `PFR-C10` removes zero operation weights, and `PFR-C11` restricts both the canonical auxiliary and `Y'` to active support/fibers with explicit bridges. |
| `OM-046` | Reading manuscript “max” and “min” notation as silently guaranteeing a Lean optimizer | `PFR-C05` uses a universal bound plus finite attaining witness; `PFR-C14` uses `IsGreatest` at objective one; `PFR-C15` uses `IsLeast` at objective one and a separate no-partition case. No unproved global attainment assumption is imported from prose. |
| `OM-047` | ISIT's literal `m × R` incidence matrix with all Bell partitions but rows only for occurring patterns | Do not formalize this system as written. A partition containing an unobserved pattern can create a partly or wholly unconstrained column, so `Hx = v` need not encode the operation construction and the claimed coordinate bound on `x` can fail. `PFR-C13` must use the current extended draft's full `2^k - 1`-row zero-padded system or its reduced admissible-partition system and prove their equivalence. `OM-025` separately owns the dual-variable-count wording. |
| `OM-048` | Definition 1 read as independence plus coordinate marginals only | Do not formalize this weakened literal reading. “Canonical functional representation” inherits the functional-representation decoder relation `Y = W_X`; `PFR-C02` must make the fixed pair's joint-law/decoder condition explicit and distinguish it from a marginally canonical coupling law. |
| `OM-049` | VPS's printed restriction `0 < beta < 1` versus later value-one splits | Do not silently use VPS outside its stated source domain. `PFR-C07`/`PFR-C10` must either justify the intended active range `0 < beta <= 1` or prove that a value-one split is simulated by a legal finite cascade. |
| `OM-050` | Examples 2-5 omit a hypothesis on their shared parameter `beta` | Treat the suite as an active-column fixture only under the implicit condition `0 < beta < 1`. At an endpoint, some displayed columns are zero and the value/pattern and operation hypotheses used in the prose no longer apply. `PFR-C07` must state the assumption. |
| `OM-051` | Prose saying PPS/PPM and VPS/VPM “are inverses,” and calling cascades “equivalent” | Do not encode global mutually inverse functions: merges forget the split ratio or mask. Prove the exact witness-parameterized recovery directions needed by Lemma 6, with remembered parameters and endpoint equality or explicit output reindexing. `PFR-C07` and `PFR-C08` own these contracts. |
| `OM-052` | Multiway-operation shorthand in Theorem 1 and the partition-weight construction | Primitive PPS and VPS operations are binary, while the prose sometimes creates an arbitrary weighted family or splits along an entire partition “by” one named operation. `PFR-C10`/`PFR-C11` must realize these as finite cascades, restrict zero weights and empty fibers, handle singleton and value-one cases, and prove the resulting endpoint. |

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

The next action is to draft the detailed plan for `PFR-C01` only. That plan
should make `DG-01` precise, probe the focused LeanInfoTheory imports, assign
stable implementation steps, and stop for project-lead approval before any
Lean implementation.

Before `PFR-C02` is planned, review what `PFR-C01` actually exposed. Hold the
Section 6 checkpoints before approving `PFR-C06`, `PFR-C11`/`PFR-C12`,
`PFR-C13`, and `PFR-C15`. This staged replanning is intentional: it preserves a
coherent global direction without pretending that high-risk Lean interfaces
can be fixed perfectly before the preceding proofs exist.
