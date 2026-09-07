# PerfectFunctionalRepresentationsLean Living Project Summary

This is the canonical living project-memory document for the PFR case study.
It is primarily an onboarding and reconciliation document for assistants and
also the best comprehensive human-readable view of where the project stands.
It summarizes architecture, mathematical coverage, decisions, limitations,
risks, and normalized future-work status without requiring readers to
reconstruct the chronological log. It does not replace Lean source,
`AGENTS.md`, project scope, the manuscripts, the formalization map, approved
chunk plans, or the project log.

Status labels:

- **[Current]** verified against the repository, pinned dependency, or paper;
- **[Decision]** an approved project rule;
- **[Target]** accepted formalization coverage that is not yet implemented;
  this label does not approve an implementation chunk;
- **[Approved plan]** work explicitly authorized by the project lead in a
  named plan, within that plan's exact scope and status;
- **[Provisional]** a design candidate requiring plan approval;
- **[History]** useful rationale that does not establish current code;
- **[Deferred]** intentionally outside current work;
- **[Superseded]** an earlier position replaced by a later decision; and
- **[Uncertain]** requiring verification before implementation.

## 0. AI Assistant Quick Start

**[Current] Mission.** This private Lean 4 repository will formalize the
six-page ISIT manuscript *On Perfect Functional Representations* by Serhat Emre
Coban, Yanina Y. Shkel, and Emre Telatar. It is a downstream case study of
LeanInfoTheory, not an extension of LeanInfoTheory's core library scope.

**[Current] State.** The lightweight root exposes the PFR-C01 semantic module
alongside the dependency smoke test; regressions remain separately imported.
PFR-C01 is complete after independent S08 validation and closeout on 2026-09-07.
The semantic module is also independently importable and
contains the two support-aware structural functional-representation predicates,
their common-base expansion theorem, full-triple-law transport,
independence under deterministic right-postprocessing, the Equation (1)
equivalence, the unconditional Equation (2) decomposition, and Equation (3)
with its bound and equality/Markov criteria. It also distinguishes specified
auxiliary perfectness from existential pair perfectness, with a separate
regression module. Its 23 public declarations
include `isFunctionalRepresentationOf_iff_zero_conditions`: finite-valued
`X`, `Y`, and `Z` form a functional representation iff `I(X;Z) = 0` and
`H(Y|(X,Z)) = 0`, with an unrestricted source type and an existential decoder
correct only on support. `mutualInfoOf_eq_pfr_decomposition` gives exact
Equation (2), with finite value alphabets, an unrestricted source, and no
functional-representation premise. All four Equation (3) methods retain a
functional-representation premise and the same finite-value boundary; equality
holds iff `I(X;Z|Y) = 0`, equivalently the Markov chain `X - Y - Z`. No full
support or null-fiber conditional law is required. Fixed-perfect equality,
zero-CMI, and Markov equivalences retain the structural conjunct, and transport
uses the full triple law. The existential pair predicate depends only on the
pair law, permits a separate perfect `Fin n` triple-law extension, and accepts
any finite perfect auxiliary in any universe through the finite reindexing
bridge. Canonicalization, channel-level perfectness, matrix results,
algorithms, and complexity claims are not yet formalized.
The initial source baseline is commit `57e132c`.

**[Current] Dependency.** `lakefile.toml` pins LeanInfoTheory `v0.1.0`; the
manifest resolves it to
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`. That release uses Lean and
mathlib `v4.33.1`. Verify every upstream name against this checkout.

**[Decision] Scope.** The six-page ISIT manuscript fixes target inclusion. The
current extended draft is an evolving proof and clarification companion for
in-scope results: consult it when the conference version is terse or unclear,
but do not import extended-only material without separate approval.

**[Decision] Architecture.** Treat mathlib as the foundational library and the
pinned LeanInfoTheory release as the primary information-theory library. Reuse
their `PMF`, channel, entropy, information-measure, independence, and Markov
APIs before adding local material. Keep paper-specific functional
representations, singular channels, matrix operations, reachability, and LP
statements downstream. Canonical information units remain nats.

**[Current] Work status.** Project bootstrap, initialization audit, and
document-role reconciliation are complete. The project lead accepted revision
2 of the formalization map as the current adaptable global reference.
PFR-C01 detailed-plan Draft revision 2 was approved on 2026-09-04, and DG-01
was resolved according to it. Approval-checkpoint commit
`5a9c7ca999639afe26c7bf235b4d044e0341b55a` is the verified execution
baseline. PFR-C01 was activated for S01, which completed and validated on 2026-09-04;
the project lead explicitly authorized S02 on 2026-09-05, and it completed
and validated that day. The project lead explicitly authorized S03 on
2026-09-05; the Equation (1) equivalence and its regressions completed and
validated that day. The independent S03 review received on 2026-09-06
recommended no corrective or optional change. The project lead separately
authorized S04 on 2026-09-06; implementation and validation completed that day.
The independent S04 report received that day recommended retaining the
implementation with no corrective or optional change; its receipt and source
identity were reconciled without a Lean change.
The project lead separately authorized S05 on 2026-09-06; Equation (3) and its
equality/Markov consequences completed and validated on 2026-09-07.
The independent S05 report received on 2026-09-07 recommended no corrective
or optional change. Its source identity was reconciled, and S05 was finalized
without a Lean change. The project lead explicitly authorized S06 on
2026-09-07; fixed and existential perfectness completed implementation-step
validation that day. The independent S06 report received that day recommended
retention with no corrective or optional change. Its source identity was
reconciled, and S06 was finalized without a Lean change. The project lead then
explicitly authorized S07 on 2026-09-07; root integration and internal
validation passed that day, leaving C01 `Active` at the milestone
"implementation finished; independent validation pending." The independent
S07 report received that day was reconciled against
the current files, and S07 was finalized without a Lean or regression change.
The project lead then explicitly authorized S08 on 2026-09-07. A fresh
independent chunk-wide pass and completion reconciliation succeeded: C01 is
`Complete`, and all eight steps are validated. The exact approved ISIT binary
was recovered and the C01 source anchors freshly rechecked; the earlier
missing-binary limitation is closed. C02 is ready for detailed planning but
has not started and requires a new prompt; no later chunk begins automatically.
The subsequent `Reviewer - Chunk 1` S08 report covered the final self-review
notes and was reconciled against all sixteen supplied fingerprints. S08 and
C01 retain their validated/complete statuses without a Lean change; detailed
review evidence is recorded in Section 9.

Read next by task:

| Task | Read next |
| --- | --- |
| Formalization-map review | Sections 2-8, `docs/formalization-map.md`, the exact ISIT paper, and relevant material in the current extended draft |
| Lean theorem implementation | The approved step, its formalization-map chunk, Sections 3-7, owning modules, and exact source statement |
| API or architecture review | Sections 3, 5, 7, 8, and targeted Git/log history |
| Dependency upgrade | Sections 1, 4, 5, and the candidate LeanInfoTheory release notes/API contract |
| General Assistant reconciliation | This whole summary, `AGENTS.md`, project scope, the roadmap, `docs/project-log.md`, Git state, and temporary handoffs |

## 1. Document and Repository Status

| Field | Value |
| --- | --- |
| Last reconciled | 2026-09-07 |
| Repository | `serhatemrecoban/PerfectFunctionalRepresentationsLean`, private |
| Branch | `master` |
| Initial source baseline | `57e132c` |
| LeanInfoTheory dependency | immutable tag `v0.1.0`, commit `0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f` |
| Lean/mathlib baseline | `v4.33.1` |
| Paper coverage | C01 structural predicates, expansion, law transport, postprocessing independence, Equations (1)-(3), fixed perfectness, and existential pair perfectness independently validated; canonicalization and later results remain targets |
| Formalization map | accepted revision 2; current adaptable global reference; non-authorizing |
| PFR-C01 detailed plan | [Approved Draft revision 2 dated 2026-09-04](plans/pfr-c01-semantic-functional-representations.md); status `Complete` |
| Active chunk | None; PFR-C01 S01-S08 validated, C02 detailed planning next eligible but not started |
| C01 delivery checkpoint | The commit introducing [project log entry 34](project-log.md#34-authorized-c01-delivery-checkpoint---2026-09-07); distinct from the approved execution baseline |
| Numbered Future Work Notes | none |
| Website | none; no approved website plan |
| Validation baseline | S08 independent chunk-wide pass; fresh production, regression, root, default, consumer, signature, axiom, and hygiene checks passed; details in Section 9 |

The maintained document roles are:

- `README.md`: reader entry point and basic project navigation;
- `AGENTS.md`: how assistants work;
- this living summary: where the project stands, including normalized
  future-work status;
- `docs/project-scope.md`: what belongs in the project;
- `docs/project-log.md`: what happened and why, plus authoritative detailed
  Future Work Notes;
- `docs/roadmap.md`: where the project may go, without authorizing work;
- `docs/formalization-map.md`: current global source allocation, candidate
  chunks, dependencies, decision gates, and internal omission register; and
- approved files under `docs/plans/`: what the project lead has authorized to
  do next.

Any task that materially changes current status, coverage, decisions, risks,
architecture, map dependencies or omission dispositions, dependency or
manuscript identity, validation evidence, approved work, roadmap direction, or
future-work disposition must update the owning canonical documents before
completion without waiting for a separate request. Use links and compact
derived summaries instead of duplicating detailed content across owners.

## 2. Mission, Scope, and Success Criteria

**[Decision] Primary goal.** Give kernel-checked Lean statements and proofs for
the mathematical content of the six-page ISIT paper, with explicit finite
alphabet, support, and representation contracts.

**[History] Project role.** The case study is intended to demonstrate that a
research-paper formalization can be built on the public LeanInfoTheory library.
Paper-specific constructions remain here, just as application-specific
certificate machinery belongs in its own downstream repository.

**[Target] In scope.** Definitions 1-4, Lemmas 1-6, Theorems 1-2, Corollary
1, the non-representable example, the operation examples needed for validation,
and the finite optimization statements used by the ISIT paper.

**[Deferred] Outside current scope.** The extended manuscript's separation-
oracle algorithm, computational-complexity and NP-hardness results,
hypergraph/coloring constructions, separate discussion of Wyner common
information, excess functional information, Körner graph entropy, and privacy
funnel, and formalization of unrelated references.

**[Decision] Proof and clarification companion.** The current extended draft
may provide fuller proofs and clarify compressed or ambiguous formulations of
in-scope ISIT results. Because it may change before publication or archival
release, material reliance must identify the consulted version and be
revalidated after an update. Such use does not promote extended-only claims
into scope.

**[Decision] Human-oriented source interpretation.** The manuscripts address
informed human readers and may suppress routine hypotheses, compress indexing
or representation details, or describe effective quantities rather than the
literal size of one displayed encoding. Formalization must distinguish the
printed formulation, its mathematically intended reading in context, and the
precise Lean contract. Preserve the intended correct theorem, document
material representation bridges and mismatches, and ask the project lead when
an interpretation changes truth, assumptions, conclusion, theorem strength,
or scope. The full interpretation boundary is maintained in
`docs/project-scope.md`.

Success requires exact source traceability, no placeholders, focused module
ownership, complete builds, recorded assumptions and departures, and a final
coverage audit. It does not require executable LP solving unless separately
approved; theorem-level equivalence is the primary paper claim.

## 3. Paper Coverage Matrix

These rows record accepted coverage dispositions. Most are Lean targets; a row
marked documentation-only is intentionally not a theorem target. The rows are
not execution authority: PFR-C01 approval comes only from its tracked plan.
Equations (1)-(3) and the adjacent unnumbered fixed/existential pair perfectness
notions are implemented and independently validated in C01 at the approved
finite-value boundary; the remaining
numbered targets are unimplemented. The structural semantic API and validation
evidence are recorded separately in Sections 0 and 9.

| ISIT item | Mathematical role | Proof source | Status |
| --- | --- | --- | --- |
| Equation (1) | Functional representation: independence and deterministic decoding | ISIT I | Implemented and validated in S03; finite value alphabets, unrestricted source |
| Equation (2) | Unconditional mutual-information decomposition | ISIT I; extended I; LeanInfoTheory chain rules | Implemented and validated in S04; finite value alphabets, unrestricted source, no representation premise |
| Equation (3) | Representation-specific reduced identity and perfect upper bound | ISIT I; extended I; LeanInfoTheory nonnegativity and Markov equivalence | Implemented and validated in S05; all four consequences retain the representation premise, finite value alphabets, and unrestricted source |
| Definition 1 | Canonical functional representation | ISIT II-A | Target |
| Lemma 1 | Replace an arbitrary representation by an equally informative canonical one | ISIT II-A | Target |
| Definition 2 | Channel-level perfect representability | ISIT II-A | Target |
| Definition 3 | Singular finite channel/matrix | ISIT II-B | Target |
| Lemma 2 | Perfect implies singular; singular is sufficient for binary input or output | ISIT II-B; extended appendix | Target |
| Example 1 | A singular `3 x 3` channel that is not perfectly representable | ISIT II-B; extended appendix | Target |
| Equation (9), Lemma 3 | Binary-input optimum via total variation and maximal coupling | ISIT II-C; extended appendix | Target |
| Definition 4 | Nonzero column value and binary support pattern | ISIT III-A | Target |
| PPS, PPM, VPS, VPM | Four operations on singular channel matrices | ISIT III-A | Target |
| Lemma 4 | Normalize an operation cascade to PPS, then VPS, then PPM | ISIT III-A; extended appendix | Target |
| Lemmas 5-6 | Preservation of representability/non-representability | ISIT III-B; extended appendix | Target |
| Theorem 1 | Reach `1_k` from `M` via PPM/PPS/VPM; equivalently construct `M` from `1_k` via PPS/VPS/PPM | ISIT III-B and appendix; extended proof | Target |
| Pattern compression and incidence matrix `H` | Reduce a singular matrix to distinct patterns and partition weights | ISIT IV-A | Target |
| Theorem 2 | Primal LP optimum equals one iff perfectly representable | ISIT IV-A; extended appendix | Target |
| Corollary 1 | Dual LP characterization | ISIT IV-B | Target |
| Complexity remark | LP size and the efficient-solvability question posed by the ISIT paper; the current extended draft gives extended-only answers | ISIT IV-C | Documentation-only coverage |

Draft map revision 2 allocates these rows across sixteen candidate chunks and
splits high-risk rows such as Lemma 2, Theorem 1, and the LP development. A
detailed chunk plan may split an allocation further after a plan-health review.

**[Provisional] Map coverage granularity.** Revision 2 assigns Remark 1
formal theorem coverage, Examples 2-7 to checked fixtures or demonstrations,
and externally sourced Remark 2 to the internal omission register. Equation
(4) is intentionally not targeted because it is an external bound, is not
needed by the exact characterization, and has unit-sensitive wording. These
are accepted as adaptable map dispositions rather than frozen public-API
contracts; they do not bring the extended-only information-measure discussion
into scope.

## 4. Evidence and Conflict Judgment

`AGENTS.md` owns the full seven-source judgment framework. It is a routing
guide, not a rigid precedence ladder. First identify whether the question is
about current implementation, authorized execution, normalized project status,
target mathematics, proof clarification, available dependency APIs,
historical rationale, or remote/publication state. Then consult the sources
competent for that question and weigh overlapping evidence by relevance,
specificity, recency, and verification quality.

In compact form: source and builds establish current implementation; current
project-lead decisions establish intent; an exact approved plan establishes
authorized work; this summary records normalized current status; the ISIT
manuscript fixes target inclusion; the current extended draft supports proof
and interpretation; pinned mathlib and LeanInfoTheory establish available
library facts; the project log and Git explain history; and GitHub establishes
remote state. None of those sources automatically governs a different category
of fact.

Material conflicts must be reported and reconciled with mathematical and
engineering judgment. Paper prose may need a precise Lean contract, but an
assistant must not silently strengthen assumptions, suppress zero-probability
cases, substitute a different theorem, rewrite historical rationale as current
state, or treat a roadmap item as approval.

## 5. Available LeanInfoTheory v0.1.0 Foundations

The following public declarations were verified in the pinned release and are
likely foundations, not an exhaustive import prescription. The channel names
are in namespace `PMF`; every other name in this list is in namespace
`LeanInfoTheory.Shannon`:

- channels: `PMF.deterministicChannel`, `PMF.channelComp`,
  `PMF.channelJoint`, and `PMF.channelExtension`;
- information quantities: `entropyOf`, `condEntropyOf`, `mutualInfoOf`, and
  `condMutualInfoOf`;
- semantics: `IsIndependent`, `IsIndependentOf`, `IsMarkovChain`, and
  `IsMarkovChainOf`;
- deterministic and Markov facts:
  `condEntropyOf_eq_zero_iff_exists_function`,
  `condMutualInfoOf_eq_zero_iff_isMarkovChainOf`,
  `mutualInfoOf_deterministic_chain_rule_left`,
  `mutualInfoOf_markov_chain_rule`, and
  `mutualInfoOf_dataProcessing`.

**[Decision] Discovery and reuse workflow.** Mathlib and pinned LeanInfoTheory
are both principal libraries for this project. Failure to remember a name is
not evidence that a facility is absent. Before adding local content:

1. search LeanInfoTheory's frozen `v0.1.x` API inventory, module guide,
   declaration index, and relevant maintained examples;
2. search the exact pinned LeanInfoTheory and mathlib sources;
3. inspect candidates with the lightest relevant import and Lean tools such as
   `#check`, `#print`, and a minimal compiling probe; and
4. only then record a genuine missing surface or design a project-local API.

The pinned release's supported inventory contains 31 modules and 601 public
declarations, so targeted local inspection is practical. Mathlib additionally
offers broad documentation and external search services, but those services
must not be assumed to index LeanInfoTheory-specific declarations. Imported
environment tools such as `#find`, `exact?`, `apply?`, and `simp?`, when their
supporting modules are imported, can still inspect or use declarations from
either library. Search-only probes may use `LeanInfoTheory.Shannon`; maintained
PFR modules must retain focused imports.

**[Current] Missing upstream surfaces.** The release contains no dedicated
functional-representation, perfect-representability, singular-channel,
conditional-probability-matrix operation, finite-PMF total-variation, or LP
API. These are not accidental bootstrap omissions in this repository.

**[Current] Missing pinned-mathlib surfaces.** A targeted `v4.33.1` source
audit found no ready finite-PMF coupling/total-variation API and no theorem-level
linear-program structure or off-the-shelf LP strong-duality theorem.
Signed/vector-measure total variation, geometric separation machinery, and
tactic-internal simplex code do not by themselves settle the paper's required
interfaces.

Focused imports are preferred. The PFR root must not import heavy matrix or
optimization machinery merely because a late paper theorem uses it.

## 6. Stable and Provisional Design Decisions

**[Decision] Stable.** Use functions `alpha -> PMF beta` for channels, arbitrary
finite types for semantic statements when practical, right-associated products,
and LeanInfoTheory's nats convention. Make channel-to-coordinate-matrix
translation explicit.

**[Decision] PFR-C01 semantic contract.** DG-01 was resolved on 2026-09-04 by
the [approved PFR-C01 plan](plans/pfr-c01-semantic-functional-representations.md).
Use a law-level triple predicate with a full-pushforward common-base `...Of`
wrapper. Structural representation is independence plus existence of a
support-correct product decoder and has no finiteness requirement. Keep
fixed-`Z` perfectness distinct from law-invariant existential pair perfectness;
normalize the latter's hidden finite auxiliary as `Fin n` on an enlarged
triple-law space. Information/perfectness statements use the pinned
finite-valued API, with no source-space `Fintype` assumption; `OM-053` records
this source-to-Lean boundary and PFR-C02's later canonicalization obligation.

**[Provisional] Canonical representation.** A canonical random vector over an
input alphabet `alpha` naturally has value type `alpha -> beta`; its law may be
represented as `PMF (alpha -> beta)`, with coordinate pushforwards matching the
channel rows. The draft map recommends a prior-free common-posterior
factorization for channel-level perfection, together with a proved
full-support-prior Markov bridge. This still requires an approved chunk
contract, especially for null output fibers and zero-prior inputs.

**[Provisional] Layering.** Map revision 2 proposes sixteen chunks across
semantic representation, finite coupling, the active finite-matrix boundary,
typed operations and reachability, pattern/incidence systems, primal/dual
characterizations, and final trust closure. The allocation remains adaptable;
outside approved PFR-C01, no chunk or module name is approved.

**[Provisional] Matrix boundary.** A direct `Matrix (Fin k) (Fin m)` encoding
matches the paper but operations change the output dimension. The draft map's
leading candidate is an active heterogeneous finite-channel state based on
`Sigma fun m => alpha -> PMF (Fin m)`, but strengthened with nonempty input,
positive output-cardinality, and active-column invariants. It uses explicit
output relabeling and derived `ENNReal`/`Real` matrix views. The detailed chunk
plan must verify that choice; dimension changes must not be buried under casts.

**[Superseded] Earlier ownership framing.** An early readiness discussion
treated PFR-specific notions as possible LeanInfoTheory prerequisites. The
approved downstream ownership boundary replaces that framing; it is not an
active upstream proposal.

**[Decision] Upstream boundary.** Do not move paper-specific APIs into
LeanInfoTheory for convenience. A missing general theorem may be proposed
upstream only after a concrete downstream need and separate compatibility
review. PFR continues to build against `v0.1.0` until an approved release
upgrade.

## 7. Anticipated Lean and Mathematical Risks

- The paper treats the support of `X` as the whole finite input alphabet,
  while channel-level perfect representability is prior-independent. The
  intrinsic binary-input channel clause should use a two-element input type;
  pair-level Lemma 3 must instead expose a full-support input law or transport
  to its support subtype. Its final equality can fail as a channel criterion
  for a degenerate prior. Binary-output claims likewise need an active-output
  restriction or an explicit globally-zero-output invariance theorem.
- Canonical vectors are finite dependent products in mathematical prose but
  ordinary function types in Lean; coordinate laws and extensionality need a
  clean API. A bare coupling law with the right coordinate marginals is not by
  itself a canonical representation of a fixed pair: the joint decoder
  relation `Y = W_X` must remain explicit.
- The manuscript fixes finite `X` and `Y` but does not literally
  finite-qualify every auxiliary alphabet. The approved PFR-C01 contract leaves
  structural fixed-`Z` semantics unrestricted, places information/perfectness
  statements at the finite-valued boundary required by the pinned API, and
  uses `Fin n` only to normalize the hidden finite pair witness. `OM-053`
  records this source-to-Lean interpretation; implementation must preserve it,
  and PFR-C02 later supplies the finite-canonical-witness justification.
- Split and merge operations change output types and reorder columns. The ISIT
  text gives PPM/VPM the domain `S_{k,m+1}` while quantifying merge indices only
  through `m`; the current extended draft clarifies that both source indices
  range through `m + 1`. The formal contract should adopt and record that
  source-backed correction while still specifying the resulting column order.
- The paper takes the output alphabet to be the support of `Y`, whereas an
  ambient matrix type may admit all-zero columns for which Definition 4 has no
  value or pattern. The matrix boundary must state its nonzero-column contract.
- Literal VPS masks can create an all-zero child column, while PPS requires a
  strict split to preserve active columns. VPS is also printed for
  `0 < beta < 1`, although later constructions may split a value-one column.
  The operation contract must resolve both issues and state Examples 2-5 under
  their implicit `0 < beta < 1` parameter condition.
- The paper's claims that split/merge pairs are “inverses” retain hidden split
  parameters, and its multiway PPS/VPS prose abbreviates finite binary
  cascades. Lean must use witness-parameterized recovery theorems and explicit
  finite paths, including singleton, zero-weight, empty-fiber, and value-one
  cases.
- Lemma 4's informal repeated-interchange argument needs a rigorous
  normalization or termination measure, particularly if a local rewrite can
  lengthen a cascade.
- Multiway VPS and the decoder-fiber construction need an exact-partition
  interface before the later incidence-system chunk. The draft map now assigns
  its minimal form to `PFR-C10` and leaves enumeration and incidence ownership
  to `PFR-C13`, avoiding a hidden dependency cycle.
- PMF masses are `ENNReal`, while the paper's LP is real-valued. The conversion
  boundary and finiteness/nonnegativity obligations require deliberate design.
- Neither LeanInfoTheory nor pinned mathlib has a ready finite-PMF
  total-variation/coupling API. The draft map allocates a local finite
  maximal-coupling development before the binary-input part of Lemma 2 and
  Lemma 3.
- Conditional and Markov statements must handle null fibers consistently.
- Theorem 1 mixes semantic existence with combinatorial matrix reachability;
  explicit equivalence and relabeling lemmas will likely dominate the proof.
- Theorem 2 and Corollary 1 require an explicit optimization contract. Because
  pinned mathlib has no ready LP strong-duality layer, the draft map recommends
  `IsGreatest`/`IsLeast` attainment statements and a specialized finite
  convex-separation argument rather than a general LP library. The dual chunk
  still requires focused feasibility probes before approval.
- The input alphabet must be nonempty at the LP boundary; for an empty input,
  the manuscript's displayed primal can be unbounded.
- Human-oriented LP descriptions may count effective variables rather than the
  coordinates of one literal displayed encoding. The current extended draft
  now distinguishes a full system indexed by all `2^k - 1` nonzero patterns
  from the reduced system on the `m` patterns that occur, and explains why
  their feasibility is equivalent. The literal ISIT `m × R` system with all
  Bell partitions but only occurring-pattern rows can contain unconstrained
  columns and is not accepted as a third formal encoding. Corollary 1's `m`
  dual variables belong to the reduced system. Draft map revision 2 assigns
  the primary representation and reduction/equivalence decisions to
  `PFR-C12` and `PFR-C13`. No detailed contract, optimization-attainment
  theorem, or complexity theorem is approved yet.

## 8. Current Work, Roadmap, and Future Work

| Register | Current normalized status |
| --- | --- |
| Current activity | PFR-C01 complete; awaiting an explicit PFR-C02 detailed-planning prompt |
| Formalization map | accepted revision 2 in `docs/formalization-map.md`; PFR-C01 complete, PFR-C02 ready for detailed planning, PFR-C03 through PFR-C16 mapped; DG-01 resolved, fourteen decision gates open, fifty-three omission/disposition records |
| Approved chunk plan | [PFR-C01 semantic functional representations](plans/pfr-c01-semantic-functional-representations.md), Draft revision 2 approved 2026-09-04 |
| Active theorem-development chunk | None; PFR-C01 S01-S08 validated against execution baseline `5a9c7ca999639afe26c7bf235b4d044e0341b55a`; no C02 authorization |
| Detailed numbered Future Work Notes | None opened; the authoritative register is in `docs/project-log.md` |
| High-level direction | Maintained in `docs/roadmap.md` |
| Website | Deferred roadmap direction only; no website or approved website plan |

When numbered Future Work Notes exist, this summary will list every note
exactly once in a compact current-status view. Active, standing, transferred,
and deferred notes will be separated from completed, superseded, and obsolete
notes. The project log retains each note's detailed rationale and dated
history. An active note is not an approved chunk.

The roadmap groups possible mathematical, completion, release, and later
directions. The formalization map owns the more detailed current allocation,
decision gates, and internal omission register; it remains adaptable and does
not authorize implementation. Scope exclusions remain governed by Section 2
and `docs/project-scope.md`.

## 9. Validation and Trust State

The following chronological records describe the state and evidence at each
dated milestone. Later status changes and source recovery do not retroactively
enlarge earlier reviews; the final S08 paragraph records current completion.

At bootstrap and again during the 2026-09-02 initialization audit, `lake build`
completed successfully with 2,605 jobs against the pinned dependency. The
strict project-source placeholder scan returned no matches. The project Lean
sources are a lightweight `PerfectFunctionalRepresentations.lean` root and
`PerfectFunctionalRepresentations/Basic.lean`; the latter's only substantive
content is a smoke-test example importing `LeanInfoTheory.Shannon.Entropy` and
applying `entropy_nonneg`.

The same audit built the focused channel and Markov modules and compiled
`#check`s for all 17 declarations named in Section 5 under their exact
namespaces.

The 2026-09-03 documentation-architecture reconciliation again passed the
2,605-job default build. A deliberate broad dependency probe built the complete
`LeanInfoTheory.Shannon` umbrella successfully with 3,056 jobs, after which all
17 named declarations passed exact `#check` verification. Relative Markdown
links, status vocabulary, manuscript digests, document whitespace, placeholder
policy, tracked-file scope, and repository hygiene were also checked; no Lean,
manifest, toolchain, or dependency file changed.

The second formalization-map review on 2026-09-03 again passed the 2,605-job
default build and strict placeholder scan. Independent audits checked the
acyclic chunk graph, source coverage and dispositions, all 16 chunk IDs, 15
decision-gate IDs, and 52 omission IDs and references. A focused compiling
probe verified the additional pinned marginal, partition, reindexing, finite
separation, and coordinate-duality declarations used as planning evidence.
Markdown links, manuscript digests, dependency revisions, and document
whitespace were rechecked. These validations support planning feasibility;
they do not approve a chunk or certify any paper theorem as implemented.

On 2026-09-04, focused PFR-C01 planning probes verified the proposed
support-aware structural layer, Equations (1)-(3), their CMI and Markov
orientation, the fixed-auxiliary perfectness layer, and the `Fin n`
pair-extension encoding. The finite-witness bridge was also compiled for the
genuinely higher-universe auxiliary `ULift (Fin 2)`. These checks establish
planning feasibility. The project lead subsequently approved Draft revision 2
and resolved DG-01 on 2026-09-04. The approval-checkpoint build, placeholder,
link, path/directive, dependency-pin, diff/status, artifact, and plan-hygiene
checks passed, as did an independent approval-transition audit. This validates
the planning and authorization checkpoint only; it does not certify a paper
theorem as implemented.

PFR-C01-S01 then added the separately importable structural production and
regression modules. Focused builds passed with 2,755 and 2,756 jobs, and the
2,605-job default build remained green. A production-only consumer confirmed
the exact three-declaration polymorphic API; its sole public theorem depends
only on `propext`, `Classical.choice`, and `Quot.sound`. The strict placeholder,
whitespace, dependency-pin, import, public-surface, support-edge, and artifact
checks passed. An independent read-only review confirmed the source
orientation, support transport, regressions, and S01-only scope. At that
checkpoint, PFR-C01 remained active and S02 had not started.

On 2026-09-05, the separate `Reviewer - Chunk 1` review was received and
reconciled with verdict `PASS WITH NON-BLOCKING SUGGESTIONS`. It independently
validated the three-declaration API, both negative fixtures, focused/default
builds, proof trust, and documentation state, with no required S01 fix. Its
sole caveat is the unresolved ISIT binary identity in Section 10. This S01
review does not satisfy the later chunk-wide S08 validation or authorize a
checkpoint commit or S02 execution.

The subsequently authorized S02 completed on 2026-09-05. It added full
triple-law structural transport across independent source universes and
deterministic right-postprocessing of independence, bringing the production
API to five public declarations without extra imports or typeclasses.
Focused production/regression builds, the default build, exact-signature
consumer, and theorem axiom audits passed. A separate read-only audit checked
the source and regressions, including supported many-to-one maps and a case
where postprocessing preserves independence but destroys decoding. Full
evidence is in [project log entry 13](project-log.md#13-pfr-c01-s02-transport-and-postprocessing---2026-09-05).
The source-identity caveat below remained recorded; S03 had not started at
that checkpoint.

The S02 contextual review follow-up added a regression showing that even all
three equal pairwise laws cannot replace the full triple-law premise. It
also clarified the existing upstream-ownership note without authorizing a
migration. Production remains unchanged; repeated validation, direct checks
of the untracked files, and final file fingerprints are recorded in
[project log entry 14](project-log.md#14-s02-contextual-review-follow-up---2026-09-05).

The separate `Reviewer - Chunk 1` review of the final S02 snapshot found no
issue requiring a change. Its later comparison with implementation-side
material left that assessment unchanged and recommended no additional optional
improvement. The first-pass verification and remaining limitations are
recorded in [project log entry 15](project-log.md#15-independent-s02-review-and-comparison---2026-09-05).
S02 remained validated; S03 was paused pending an explicit prompt at that
checkpoint, and the chunk-wide S08 review remained a later obligation.

The project lead subsequently authorized S03 on 2026-09-05. It added exactly
`isFunctionalRepresentationOf_iff_zero_conditions` under the unchanged
approved contract, bringing the production API to six declarations. The
theorem requires finite value alphabets, not a finite source type, and reuses
the pinned zero-MI and zero-conditional-entropy equivalences. Its regressions
cover an infinite source and the distinction between an existential
support-correct decoder and a separately chosen bad decoder. Focused and
default builds, the production-only signature consumer, axiom audit,
placeholder scan, and direct untracked-source checks passed. An internal
read-only source audit found no issue; this does not replace the separate
reviewer or chunk-wide S08 validation. The final snapshot and full evidence
are in [project log entry 16](project-log.md#16-pfr-c01-s03-equation-1---2026-09-05).
At that closeout, S03 was validated, S04 had not started, and the
manuscript-provenance caveat remained unchanged.

The subsequent S03 contextual self-review and implementation reassessment
found no justified code or regression change. Fresh focused/default builds,
the public signature and decoder-extraction consumer, and the axiom audit
passed on the unchanged source snapshot. Only review records were updated;
this does not constitute independent validation. See
[project log entry 17](project-log.md#17-s03-contextual-self-review-and-reassessment---2026-09-05).

The independent S03 report received on 2026-09-06 recommended no corrective
or optional change before step finalization. The implementation task verified
that all five reviewed source/document fingerprints matched before recording
receipt; no Lean change followed. The reviewer's source inspection, fresh
builds, consumer, and axiom checks remain separately attributed in
[project log entry 18](project-log.md#18-independent-s03-review-and-finalization---2026-09-06).
At that reconciliation, S03 remained validated, the manuscript-provenance
caveat remained unresolved, and C01 remained `Active` with S04 not started
and S08 still required.

The project lead subsequently authorized S04 on 2026-09-06. The exact
unconditional Equation (2) identity completed and passed implementation-step
validation that day, under the unchanged finite-value contract and without
a functional-representation premise. One private conditioning-pair swap
helper supports the sole new public theorem. Two anonymous regressions cover
the polymorphic contract and an arbitrary source PMF on `Nat` with distinct
value types. Focused production/regression builds, the public-only consumer
and signature/axiom audit, and the default build passed. Exact pre-S04 source
and seven-document snapshots were retained for step-specific comparison;
this does not repair earlier missing historical baselines or complete S08. See
[project log entry 19](project-log.md#19-pfr-c01-s04-equation-2---2026-09-06).
At S04 closeout, S05 had not started and the manuscript-provenance caveat
remained unchanged.

The S04 contextual self-review and subsequent implementation reassessment
retained the same source and regressions: no justified change was found.
Fresh focused/default builds, public-only signature/axiom and edge-instance
checks, and snapshot/diff audits are recorded in
[project log entry 20](project-log.md#20-s04-contextual-self-review-and-reassessment---2026-09-06).
This implementation-side review does not replace independent validation;
at that review S04 remained `Validated`, S05 was unstarted, and S08 was still
required.

The independent S04 report received on 2026-09-06 recommended no corrective
or optional change. Before recording receipt, all five supplied source and
document fingerprints matched the current files. The reviewer inspected the
exact pre-S04 comparisons and reported fresh focused/default builds, a new
public-only consumer, signature/axiom checks, and documentation validation.
Its evidence and limitations are separately attributed in
[project log entry 21](project-log.md#21-independent-s04-review-and-finalization---2026-09-06).
S04 is finalized without a source correction and retains status `Validated`.
At that reconciliation the manuscript-provenance caveat remained unresolved,
C01 remained `Active`, and S05 had not started. Independent chunk-wide S08
validation is still needed.

The project lead subsequently authorized S05 on 2026-09-06; it completed and
passed implementation-step validation on 2026-09-07 under the unchanged
Equation (3) contract. All four reduced-identity, bound, equality/zero-CMI, and
equality/Markov methods retain the functional-representation premise, four
universes, exactly three finite value alphabets, and an unrestricted source.
No helper, import, or simp attribute was added. Five anonymous regressions
consume all four generic contracts and a concrete null `Y` fiber with
support-only decoding. Focused production/regression and default builds, and
a public-only consumer auditing all eleven signatures and axioms passed.
Exact pre-S05 source and seven-document snapshots remain available for
step-specific comparison. The available manuscripts' page 1 statements were
rechecked; the approved ISIT provenance caveat remains unchanged. The bounded
internal audit is implementation-side evidence, not independent S08 validation.
See
[project log entry 22](project-log.md#22-pfr-c01-s05-equation-3---2026-09-06-to-2026-09-07).
At S05 closeout, S05 was `Validated`, C01 remained `Active`, and S06 had not
started and required its own prompt.

The S05 contextual self-review and implementation reassessment on 2026-09-07
retained the Lean source and regressions. It applied only `S05-SR-01`, joining
three qualified names in the plan's contract sketches after paired parser
checks confirmed the line-break issue. Names, contracts, and approved scope
are unchanged. Fresh builds, signature/axiom checks, and isolated S05
edge-instance consumers passed; see
[project log entry 23](project-log.md#23-s05-contextual-self-review-and-reassessment---2026-09-07).
This is implementation-side review evidence, not an independent review or
S08 completion. The manuscript-provenance caveat and S06 stop boundary were
unchanged by that self-review.

The independent S05 report received on 2026-09-07 recommended retaining and
finalizing the implementation with no additional corrective or optional
change. All five supplied fingerprints matched before recording receipt.
The reviewer separately checked the four new signatures and axioms,
production/regression/default builds, a new consumer, and the three corrected
plan-name layouts. Its direct and delegated evidence are distinguished in
[project log entry 24](project-log.md#24-independent-s05-review-and-finalization---2026-09-07).
At that receipt, S05 was finalized and remained `Validated`; C01 remained
`Active`, S06 was unstarted, and S08 was still required. The approved ISIT
provenance caveat remains unresolved. Those receipt notes are not part of the
reviewer's frozen document fingerprints.

The project lead subsequently authorized S06 on 2026-09-07; implementation-step
validation completed that day under the unchanged approved contract. Its four
definitions and eight theorems distinguish fixed-perfect equality/CMI/Markov
forms from existential pair perfectness on a separate finite extension. The
arbitrary-finite bridge preserves the pair marginal, support decoder,
independence, and information equality, including higher-universe auxiliaries.
There are now 23 public declarations; the sole new production helper remains
private, with no new direct import or simp attribute.

Fifteen anonymous regressions cover the generic interfaces, deterministic and
singleton positive cases, a functional but nonperfect XOR auxiliary, pair-law
transport, separate-space extraction, a genuinely `Type 1` auxiliary, and
impossibility of `Fin 0` extensions. Production/regression/default builds
(2,755 / 2,756 / 2,605 jobs) and a production-only consumer passed. The consumer
checked all twelve new signatures and eight new theorem axiom reports, using
only `propext`, `Classical.choice`, and `Quot.sound`, and exercised `PMF Nat`,
distinct value types, higher-universe bridging, and extension extraction.
Exact pre-S06 comparisons preserve earlier production declaration bodies and
test text. The bounded source audit is implementation-side evidence, not S08.
The available manuscripts' page 1 was rechecked; the approved ISIT provenance
caveat is unchanged. Details and evidence attribution are in
[project log entry 25](project-log.md#25-pfr-c01-s06-fixed-and-existential-perfectness---2026-09-07).
S06 is `Validated`, C01 remains `Active`, and S07 has not started. S08 and the
separate ISIT provenance follow-up remain pending; no root integration,
contract revision, commit, or push is implied by S06 completion.

The requested S06 contextual self-review and implementation reassessment on
2026-09-07 retained the source and regressions. Fresh builds, all twelve new
signature checks and eight theorem axiom reports, plus isolated checks of
two supported higher-universe auxiliary values, decoder failure at a null
source point under perfectness, and witness-cardinality positivity found no
defect. The recommendation was presented before reassessment and evidence-only
documentation edits. See
[project log entry 26](project-log.md#26-s06-contextual-self-review-and-reassessment---2026-09-07).
This is not an independent review or S08 completion. S06 remains `Validated`,
S07 is unstarted, and the approved ISIT provenance caveat remains unresolved.

The independent S06 report received on 2026-09-07 recommended retaining and
finalizing S06 for the approved finite-information contract, without a required
or optional change or another review turn. All five supplied fingerprints
matched before recording receipt. Its fresh builds, production-only consumer,
twelve signature and eight theorem axiom checks, source assessment, and
manuscript inspection are distinct from its delegated audits and this task's
receipt checks; see
[project log entry 27](project-log.md#27-independent-s06-review-and-finalization---2026-09-07).
S06 is finalized and remains `Validated`; C01 remains `Active`, S07 is
unstarted, and S08 is still required. The approved ISIT provenance caveat
remains unresolved. These receipt notes are outside the reviewer's frozen
document fingerprints; the Lean source and regressions are unchanged.

The project lead subsequently authorized S07 on 2026-09-07. The root now
exposes the semantic production module alongside Basic, without importing
regressions. Production and all 42 anonymous regressions remain unchanged;
the complete 23-declaration API and all seventeen approved regression rows
were audited, with no missing fixture. Combined production/regression/root
and default builds passed (2,759 and 2,758 jobs). A root-only consumer checked
all 23 signatures, all seventeen theorem axiom reports (only `propext`,
`Classical.choice`, and `Quot.sound`), and five integration examples.
Public/private boundaries, focused imports, pinned dependencies, support and
finite/universe contracts, and available manuscript page 1 anchors were
checked. Full evidence and the regression mapping are in
[project log entry 28](project-log.md#28-pfr-c01-s07-integration-and-internal-milestone---2026-09-07).
S07 is `Validated`; C01 remains `Active` with **implementation finished;
independent validation pending**. This implementation-side audit does not
complete S08 or resolve approved-ISIT authentication. No C02 work, commit, or
push was authorized or performed; S08 has not started.

The S07 contextual self-review and implementation reassessment on 2026-09-07
retained the root, production, and regressions unchanged. Fresh builds,
23 signature and seventeen theorem axiom checks, root-only import-boundary
verification, and generic Markov-to-pair witness extraction passed. The existing
42 examples cover all seventeen approved regression rows; no additional fixture
or earlier-step change was justified. Review and second-pass dispositions are in
[project log entry 29](project-log.md#29-s07-contextual-self-review-and-reassessment---2026-09-07).
This is not independent validation: S07 remains `Validated`, C01 remains
`Active`, S08 is unstarted, and approved-ISIT authentication remains unresolved.

The independent S07 report received on 2026-09-07 recommended retention and
finalization, without a required or optional change or another reviewer turn.
All ten supplied fingerprints matched before receipt edits. The reviewer's
fresh builds, root-only consumer, 23 signature and seventeen theorem axiom
checks, import environment, and manuscript inspection are distinct from its
delegated source/documentation audits and this task's receipt checks. See
[project log entry 30](project-log.md#30-independent-s07-review-and-finalization---2026-09-07).
The root, production, and regressions are unchanged. S07 is finalized and
remains `Validated`; C01 remains `Active` with independent chunk validation
pending. S08 is unstarted, and approved-ISIT authentication remains unresolved.
The receipt notes are outside the reviewer's frozen document fingerprints.

On 2026-09-07 the project lead explicitly authorized **S08**. A fresh
independent reviewer agent inspected the full chunk, not merely S07 or the
implementation report, and obtained separately scoped build/API and
documentation/artifact audits. All six definitions, seventeen public theorems,
seventeen regression-matrix rows, exact Equation (1)-(3) contracts,
support/finite/universe boundaries, pair-law extension bridge, and root/import
boundaries passed. Fresh builds, root and semantic consumers, signature and
axiom checks, and repository hygiene passed. The exact approved six-page ISIT
binary was recovered; the main task and independent reviewer each verified its
digest, the matching extended companion, and their C01 page 1 anchors. The
source-recovery resolution is current evidence, not retroactive authentication
of the older same-name-copy reviews. Seven canonical documents were reconciled
without changing Lean source or dependencies. **C01 is `Complete`; S01-S08
are `Validated`.** C02 is ready for detailed planning only and remains
unstarted. The independent evidence, completion checks, and limitations are in
[project log entry 31](project-log.md#31-pfr-c01-s08-independent-validation-and-chunk-completion---2026-09-07).
No commit, push, dependency migration, or C02 work was authorized or performed.

The subsequent 2026-09-07 S08 self-review and implementation reassessment
recommended retaining the completed implementation and closeout. Fresh checks
found no corrective issue; only the separate self-review record and brief
plan/summary notes were added. This is implementation-side evidence, not a
new independent pass or retrospective enlargement of that review. S08 remains
`Validated`, C01 remains `Complete`, and C02 is unstarted. See
[project log entry 32](project-log.md#32-pfr-c01-s08-self-review-and-retention---2026-09-07).

The independent `Reviewer - Chunk 1` S08 report received on 2026-09-07
assessed all eighteen completion criteria in the final integrated state,
including the self-review notes. It recommended retention with no corrective
or optional change, reopening, or additional reviewer turn. All sixteen
supplied fingerprints matched on receipt. Its fresh builds, public consumer,
signature/axiom checks, and authenticated manuscript inspection are distinct
from its delegated audits and this task's receipt checks. See
[project log entry 33](project-log.md#33-independent-s08-review-and-finalization---2026-09-07).
The root, production, and regressions remain unchanged. S08 is finalized as
`Validated`, C01 remains `Complete`, and C02 remains unstarted. These receipt
notes are outside the reviewer's frozen document fingerprints and do not
authorize a commit, push, dependency migration, or C02 work.

The project lead subsequently authorized committing and pushing completed C01
on 2026-09-07. The delivery checkpoint preserves the reviewed Lean source and
the original approval/execution baseline; separately owned AGENTS and
discoverability edits are excluded. Scope and pre-delivery validation are in
[project log entry 34](project-log.md#34-authorized-c01-delivery-checkpoint---2026-09-07).
C02 remains unstarted. Remote delivery must be verified against Git rather than
inferred from the earlier local review records.

Future Lean steps must run focused owner/downstream builds. Milestones require
the default build, placeholder scan, diff and import audit, documentation
reconciliation, and repository-hygiene check. Approved axioms must be audited
explicitly before any release claim.

## 10. Reference and Provenance Boundary

Reviewed copies of both manuscripts live outside the repository. Any local
working copies placed inside the project must remain under ignored reference
directories and must not be committed.

**[Current] Reviewed reference identity.** The six-page ISIT manuscript was
reviewed on 2026-09-02 and its digest was reverified on 2026-09-03. On
2026-09-03 the project lead designated a newer extended draft as the current
proof and clarification companion, and its in-scope statements and proof
sections were revalidated. The audit used local files identified without
committing their contents:

- six-page ISIT manuscript, SHA-256
  `48963AA59485B2C33B1A1E6E7C6EAD2251FDDDD26BD3691B6FCFFE683E6ED1C4`;
- current eighteen-page extended draft, SHA-256
  `98636D4C9F0618EC08FCA84559572780F604F197FDA90D8D7C787B3624245B8F`.

**[History] ISIT binary identity — 2026-09-05.** The then-available
`ISIT_2026__On_perfect_functional_representations___final_manuscript_ (3).pdf`
instead hashes to
`15D9ADEEBB42E67FE7C57794F3FE5F65DECEAD4F5AD8F44E7506A83C9859F171`.
A targeted search of relevant Downloads manuscripts and repository reference
locations did not recover the approved digest. The independent reviewer
inspected the available Section I and reported the same S01 semantics; this
does not authenticate the approved binary or establish equivalence of the
complete manuscripts. The extended version 16 digest was freshly confirmed.
The approved ISIT designation remained in force. Recovering that copy, or
project-lead designation of a replacement followed by affected-contract
revalidation, was then pending. This was a provenance caveat, not a reported
S01 Lean defect. Those earlier reviews did not establish fresh exact-binary
revalidation. Detailed historical evidence is in
[project log entry 12](project-log.md#12-independent-s01-review-and-provenance-follow-up---2026-09-05).

**[Current] Approved ISIT copy recovered — 2026-09-07.** A broader targeted
local search recovered the original six-page file in the project lead's paper
folder outside the checkout, with the approved full `48963AA5...E6ED1C4`
digest listed above. Both the main task and S08 independent reviewer freshly
confirmed that identity and the extended companion's unchanged digest, then
extracted and visually inspected their relevant page 1 material. Equations
(1)-(3), the Markov orientation, and fixed versus existential pair prose match
the unchanged approved DG-01/OM-053 contract. The missing-approved-binary
limitation is closed; no replacement designation or approval was needed.
This does not authenticate previously uninspected historical snapshots or
claim equivalence of every passage in the differing same-named PDFs. See
[project log entry 31](project-log.md#31-pfr-c01-s08-independent-validation-and-chunk-completion---2026-09-07).

The previously reviewed sixteen-page extended draft is superseded as a current
reference; its digest and the transition are retained in `docs/project-log.md`.

The extended draft may change before publication or stable archival deposit.
Any material plan or interpretation that relies on it must record at least its
review date and cryptographic digest in addition to relevant sections or
pages, then revisit affected contracts when the digest changes. Page numbers
alone are not stable version identity.

**[Uncertain] Release metadata.** The exact bibliographic record, publication
status, rights holder, source-file header, and citation metadata remain subject
to project-lead verification before public release.

**[History] Provenance attestation.** The inherited-context report records that
no external information-theory formalization repository was consulted or
reused before this audit; this audit likewise consulted none. Non-consultation
is an attestation rather than a fact independently provable from Git history.
Existing implementation code outside this repository is not a source unless
the project lead explicitly authorizes consultation and attribution is
recorded.
