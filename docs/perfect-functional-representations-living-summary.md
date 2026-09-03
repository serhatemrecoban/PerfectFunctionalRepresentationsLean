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

**[Current] State.** The repository contains a lightweight root import and one
dependency smoke-test example. No paper definition, lemma, theorem, corollary,
algorithm, or complexity claim is currently formalized. The initial source
baseline is commit `57e132c`.

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

**[Current] Active work.** Project bootstrap, initialization audit, and
document-role reconciliation are complete. The project lead accepted revision
2 of the formalization map as the current adaptable global reference after its
second adversarial review. The next activity is detailed planning for
`PFR-C01`; the map approves no chunk, and no theorem-development chunk or
detailed chunk plan is approved.

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
| Last reconciled | 2026-09-03 |
| Repository | `serhatemrecoban/PerfectFunctionalRepresentationsLean`, private |
| Branch | `master` |
| Initial source baseline | `57e132c` |
| LeanInfoTheory dependency | immutable tag `v0.1.0`, commit `0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f` |
| Lean/mathlib baseline | `v4.33.1` |
| Paper coverage | zero paper declarations implemented |
| Formalization map | accepted revision 2; current adaptable global reference; non-authorizing |
| Active chunk | none |
| Numbered Future Work Notes | none |
| Website | none; no approved website plan |
| Validation baseline | default build passed; strict project-source placeholder scan passed |

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
- future approved files under `docs/plans/`: what the project lead has
  authorized to do next.

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
marked documentation-only is intentionally not a theorem target. No row is
implemented work or an approved chunk.

| ISIT item | Mathematical role | Proof source | Status |
| --- | --- | --- | --- |
| Equation (1) | Functional representation: independence and deterministic decoding | ISIT I | Target |
| Equations (2)-(3) | Mutual-information identity and perfect upper bound | ISIT I; LeanInfoTheory chain rules | Target |
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

**[Provisional] Canonical representation.** A canonical random vector over an
input alphabet `alpha` naturally has value type `alpha -> beta`; its law may be
represented as `PMF (alpha -> beta)`, with coordinate pushforwards matching the
channel rows. The draft map recommends a prior-free common-posterior
factorization for channel-level perfection, together with a proved
full-support-prior Markov bridge. This still requires an approved chunk
contract, especially for null output fibers and zero-prior inputs.

**[Provisional] Layering.** Draft map revision 2 proposes sixteen chunks across
semantic representation, finite coupling, the active finite-matrix boundary,
typed operations and reachability, pattern/incidence systems, primal/dual
characterizations, and final trust closure. The allocation is reviewable and
adaptable; no chunk or module name is approved.

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
- The manuscript fixes finite `X` and `Y` but does not separately emphasize
  every auxiliary-alphabet hypothesis. Structural representation predicates
  should be separated from information-valued statements, whose use of the
  pinned LeanInfoTheory API requires the appropriate finite-valued auxiliary
  contract.
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
| Current activity | Prepare the detailed `PFR-C01` plan for project-lead review |
| Formalization map | accepted revision 2 in `docs/formalization-map.md`; sixteen mapped candidate chunks, fifteen open decision gates, fifty-two internal omission/disposition records, no chunk approved |
| Approved chunk plan | None |
| Active theorem-development chunk | None |
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
