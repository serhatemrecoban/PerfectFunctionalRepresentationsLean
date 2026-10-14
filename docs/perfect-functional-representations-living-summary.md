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

**Current, 2026-10-14:** C01–C16 are durably complete. The General Assistant
verified C16's supported S05 closure, all fifteen criteria and exact final-source
applicability before the [private repository checkpoint](project-log.md#post-c16-checkpoint).
There is no active mathematical implementation step. The
[completed C16 contract](plans/pfr-c16-coverage-api-trust-closure.md) and its
original notes retain their pre-closure checkpoint; the later durable record
establishes CC09 and completion. The lead authorized updating and publishing the
GitHub repository on 2026-10-14; see the
[publication checkpoint](project-log.md#public-repository-checkpoint).
The subsequent [public-readiness review](public-readiness.md) covers content,
attribution and reproducibility without changing the formalization. The lead
subsequently authorized the [research website plan](plans/pfr-website.md), now
complete and live on [GitHub Pages](https://serhatemrecoban.github.io/PerfectFunctionalRepresentationsLean/):
overview, mathematical blueprint and generated PFR API, using LeanInfoTheory's
blue–green palette and retaining Discussion and reproduction. Hosted Lean and
website checks passed; source links, desktop/mobile behavior and all published
file bytes were verified. See [readiness](public-readiness.md#blueprint-api-and-palette-extension--2026-10-14)
for exact delivery evidence.
The lead subsequently requested a closer visual match to the reference sites.
The [academic-layout correction](plans/pfr-website.md#approved-academic-layout-correction--2026-10-14)
is complete and live: a centered full-width masthead, sans-serif headings and a
narrow reading column replace the editorial hero/cards, retaining content and API
scope. The exact title, ISIT 2026 description and verified Paper link are published;
the homepage no longer presents internal chunk counts. See the
[academic-layout delivery evidence](public-readiness.md#academic-layout-correction--2026-10-14).
The lead's subsequent [argument-map revision](plans/pfr-website.md#approved-argument-map-revision--2026-10-14)
reconnects the blueprint's mathematical narrative after rereading the relevant
ISIT/current extended passages. It is complete and live, with independent content
and visual review, hosted Lean/API validation and live delivery checks passed.
See [readiness](public-readiness.md#argument-map-revision--2026-10-14).
New mathematical work requires separate authorization.

Read [AGENTS.md](../AGENTS.md) first, then the relevant routes below. Inspect
actual source and pinned APIs before relying on a summary. Plans and review aid
judgment; preserve mathematical intent and acceptance, document justified
adaptations, and stop after the one authorized step.

**Essential boundaries**

- Scope is the six-page ISIT manuscript. C01–C16's verified proof/clarification
  baseline remains extended v16. On 2026-10-13 the lead supplied extended
  `(19) (2)` as the current companion; the selected Appendix A/B proofs were
  compared, not the whole new draft. See Section 10 and the
  [historical source ledger](pfr-c16-coverage-audit.md#source-identities-and-reading-method).
- Reuse pinned LeanInfoTheory `v0.1.0` and mathlib on Lean `v4.33.1`.
  No dependency upgrade is authorized.
- Structural representations allow unrestricted carriers. Information uses
  finite value alphabets, independent universes and nats; source spaces need not
  be finite. Keep support-only decoding, null fibers, fixed/existential witnesses
  and full-support converse hypotheses explicit.
- The finite ambient-channel LP characterizations use
  `[Fintype α] [Nonempty α] [Finite β]` and singularity.
  Necessity has weaker hypotheses. [B01–B11](pfr-c16-readiness-audit.md#boundary-index)
  record all boundaries; the [no-wrapper decision](pfr-c16-readiness-audit.md#c16-s03-wrapper)
  retains a concrete consumer trigger.
- The lightweight root excludes matrix, optimization, optional decoding,
  examples and tests. Build separately imported modules explicitly.
- DG-01–DG-15 are resolved. OM-001–071 and original review history remain intact.
  Numbered Future Work Notes: **none**. No known required implementation is
  left by S05; final validation and supported closure are complete.
- Public repository availability and readiness checks are separately authorized.
  The lead confirmed paper/formalization credits in [AUTHORS.md](../AUTHORS.md).
  Website implementation is separately authorized; see its plan and readiness
  record for delivery status. Tagged releases, unverified metadata and omission
  curation still require separate decisions.
  Local formalization completion does not establish remote delivery or CI.

| Task | Read next |
| --- | --- |
| Inspect C16 closure | [C16 plan](plans/pfr-c16-coverage-api-trust-closure.md), [readiness matrix](pfr-c16-readiness-audit.md#c16-s05-readiness), [implementation evidence](pfr-c16-implementation-notes.md) |
| Check a paper claim or interpretation | [Source ledger](pfr-c16-coverage-audit.md), then its exact source/fixture and relevant manuscript anchor |
| Check API, imports or trust | [Readiness audit](pfr-c16-readiness-audit.md#complete-declaration-and-trust-inventory), [API/import audit](pfr-c16-readiness-audit.md#c16-s03-api) |
| Revisit an omission or suggestion | [Map register](formalization-map.md#9-internal-exhaustive-omission-and-disposition-register), [dated dispositions](pfr-c16-readiness-audit.md#c16-s04-dispositions), [Future Work Notes](project-log.md#future-work-notes) |
| Recover history or review provenance | [Preserved-record routes](pfr-c16-readiness-audit.md#c16-s04-navigation), then targeted log/notes entries |
| Work with review | [Review protocol](review-protocol.md) and [installed operations](review-operations.md); reuse the bound reviewer and durable private state |
| Understand scope or later direction | [Project scope](project-scope.md), [roadmap](roadmap.md), relevant sections below |
| Check public delivery, reproducibility or website direction | [Public-readiness record](public-readiness.md), [attribution](../AUTHORS.md), [public build workflow](../.github/workflows/lean.yml) |

## 1. Document and Repository Status

| Field | Current value |
| --- | --- |
| Reconciled | 2026-10-14, completed manuscript-grounded website argument map and delivery evidence; C01–C16 completion and historical acceptance unchanged |
| Readiness review baseline | Public `master` at `ceef8793673697cce0a4a1862d30ab0d77fb6dd5`; readiness documentation and build checks do not change Lean sources or historical step baselines |
| Dependency | LeanInfoTheory immutable `v0.1.0`, `0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f` |
| Toolchain / mathlib | Lean `v4.33.1`; mathlib `0df444a360eaa60ab8c11dca51a86af692955474` |
| Completed plan | [C16 revision 2](plans/pfr-c16-coverage-api-trust-closure.md); preserved pre-closure text, later supported completion recorded in the [checkpoint entry](project-log.md#post-c16-checkpoint) |
| Coverage and decisions | [Ledger](pfr-c16-coverage-audit.md), [readiness](pfr-c16-readiness-audit.md#c16-s05-readiness); DG-01–DG-15 resolved, all 71 omission rows preserved |
| Remote/release state | GitHub visibility verified `PUBLIC` on 2026-10-14; secret scanning/push protection enabled. See [readiness](public-readiness.md) for the exact fresh-checkout and CI validation state. No tagged release; [research website with blueprint and API](https://serhatemrecoban.github.io/PerfectFunctionalRepresentationsLean/) deployed and live-checked |

Document ownership is fixed in [AGENTS.md](../AGENTS.md#document-roles-and-proactive-maintenance):
README is the reader entry point; scope owns inclusion; this summary owns current
context; the map owns allocation, gates and omissions; the log owns history and
numbered Future Work Notes; plans own approved contracts; audits and notes own
detailed coverage/evidence. Update the relevant owners in the same coherent
change and link history instead of accumulating it here.

## 2. Mission, Scope, and Success Criteria

**[Decision] Primary goal.** Give kernel-checked Lean statements and proofs for
the mathematical content of the six-page ISIT paper, with explicit finite
alphabet, support, and representation contracts.

**[History] Project role.** The case study is intended to demonstrate that a
research-paper formalization can be built on the public LeanInfoTheory library.
Paper-specific constructions remain here, just as application-specific
certificate machinery belongs in its own downstream repository.

**[Decision] In scope.** Definitions 1-4, Lemmas 1-6, Theorems 1-2, Corollary
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

The [C16 ledger](pfr-c16-coverage-audit.md) is the exhaustive owner: 51 numbered
items, 122 prose occurrences, a six-page sweep and version-bound companion
dependencies. This table is a navigation summary of completed C01–C15 coverage.

| Paper content | Complete owner and detailed record |
| --- | --- |
| Functional representations, Equations (1)–(3), fixed/existential perfectness | [C01 plan](plans/pfr-c01-semantic-functional-representations.md) |
| Definition 1, Lemma 1, canonicalization, Remark 1, Definition 2 and prior boundary | [C02 readiness](pfr-c02-readiness-audit.md) |
| Definition 3, necessity, small-output Lemma 2, singular counterexample | [C03 readiness](pfr-c03-readiness-audit.md) |
| Equation (9), finite total variation/maximal coupling; binary-input Lemmas 2–3 | [C04](pfr-c04-readiness-audit.md), [C05](pfr-c05-readiness-audit.md) |
| Definition 4, channel/matrix/active-output and numeric boundary | [C06 readiness](pfr-c06-readiness-audit.md) |
| Four typed operations and Examples 2–5 | [C07 readiness](pfr-c07-readiness-audit.md) |
| Lemma 4 finite normalization | [C08 readiness](pfr-c08-readiness-audit.md) |
| Lemmas 5–6 preservation | [C09 readiness](pfr-c09-readiness-audit.md) |
| Finite operation synthesis and both Theorem 1 characterizations | [C10](pfr-c10-readiness-audit.md), [C11](pfr-c11-readiness-audit.md) |
| Pattern compression/Real data and full/reduced incidence; Examples 6–7 | [C12](pfr-c12-readiness-audit.md), [C13](pfr-c13-readiness-audit.md) |
| Theorem 2 attained primal characterization | [C14 readiness](pfr-c14-readiness-audit.md) |
| Corollary 1 attained dual characterization and finite counts | [C15 readiness](pfr-c15-readiness-audit.md) |
| External Equation (4), Remark 2, complexity discussion and other intentional omissions | [Original OM register](formalization-map.md#9-internal-exhaustive-omission-and-disposition-register) and [C16 dispositions](pfr-c16-readiness-audit.md#c16-s04-dispositions) |

Complete coverage does not require a public declaration for every display.
[DG-15](pfr-c16-readiness-audit.md#c16-s03-dg15) records exact public, private,
fixture and documentation owners, including Figure 1 and extended examples.
Frozen earlier plans/audits retain their original pre-finalization checkpoints;
later verified handoffs establish their completion.

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

**[Current] Measured explicit reuse, 2026-10-13.** Across all 56 maintained Lean
files, compiler-resolved source references identify 105 pinned LeanInfoTheory
declarations (76 theorems, 23 definitions, six abbreviations) at 1,385 sites.
Implementation modules account for 748 sites, including inline checks; dedicated
tests account for 636 and examples for one. These are direct explicit references,
not all implicit proof dependencies or a measure of code/time saved. The
[measurement record](project-log.md#187-leaninfotheory-explicit-reuse-inventory--2026-10-13)
links the complete list, exact locations and reproducible counter.

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

## 6. Stable Design Decisions and Architecture

- Channels are functions `α → PMF β`; products are right-associated and
  information is Real-valued in nats. Reuse mathlib and pinned LeanInfoTheory.
- Structural functional representation is independence plus a product decoder
  correct on support. The common-base wrapper uses the **full triple pushforward**.
  Fixed-auxiliary perfectness and existential pair perfectness are distinct.
  The latter uses a finite triple-law extension with a `Fin n` hidden witness;
  it need not supply an auxiliary on the original source. C02 supplies finite
  canonical sufficiency, without claiming arbitrary infinite-auxiliary
  information preservation (OM-053).
- Canonical vectors have law `PMF (α → β)`. Coordinate marginals alone do not
  express a representation of a fixed pair: independence and evaluation decoding
  remain explicit. Intrinsic channel perfectness uses one posterior for every
  row. Null-output completions are arbitrary; support transport handles
  arbitrary priors and ambient converses retain full-support hypotheses.
- Finite TV is half-L1 in Real with exact ENNReal overlap/residual laws and an
  explicit product-PMF maximal coupling. The optional Fano decoder bridge stays
  separate; it adds no dependency to the coupling core or root. Existing
  semantic KL dependencies remain allowed.
- Raw coordinates allow empty inputs and zero columns. The active finite channel
  state requires nonempty finite input, positive output cardinality and active
  columns; singularity is separate. Admitted values include one and patterns are
  nonempty support finsets. Exact/Real reconstruction and enumeration bridges are
  explicit; no data is invented for ambient zero columns.
- PPS uses strict positive split ratios; VPS admits value one and requires two
  nonempty pieces. All source merge indices and resulting order are explicit.
  Inverses retain witnesses and directed equivalences. Type-valued witnessed
  paths and a finite structural certificate prove normalization; expanding
  rewrites are not assumed to terminate. Pinned `Finpartition` supports exact
  labelled blocks and finite multiway paths.
- Compression retains actual forward/reverse paths and every ambient coordinate.
  Valid Real data requires positive occurring-pattern values and weighted row
  normalization. Full/reduced incidence restricts both rows and admissible
  partitions; equality-feasibility equivalence requires nonnegative coefficients.
  The literal mixed ISIT encoding is rejected with its reason retained.
- Primal and dual predicates are distinct and use attained `IsGreatest`/`IsLeast`
  objectives. Specialized finite convex separation/correction proves the dual.
  All-vector reindexing preserves inverse maps and entire objective images.
  Reduced counts are not the full-system counts. No general LP library or solver
  is implemented. Existing nonsingular rejection and singular primal/dual
  endpoints support the [no-wrapper decision](pfr-c16-readiness-audit.md#c16-s03-wrapper).

| Layer | Implemented ownership |
| --- | --- |
| Lightweight root | Basic, FunctionalRepresentation, Canonical, Singularity, FiniteCoupling and Binary |
| Optional probability | FiniteCouplingDecoding |
| Matrix | Channel/SingularColumns; OperationIndices/Operations; OperationPaths/OperationFactorization/OperationCalculus; Preservation; Partitions/MultiwayOperations; Reachability/CanonicalReachability; PatternCompression |
| Optimization | Incidence/IncidenceConstruction; Primal; Dual/DualCharacterization |
| Demonstrations/regressions | Two Examples owners and 28 Tests owners, separately imported |

The [complete 56-owner API/import audit](pfr-c16-readiness-audit.md#c16-s03-api)
owns exact modules, public-name counts and actual import exclusions. C01–C15
decisions are implemented; [DG-01–DG-15](formalization-map.md#5-decision-gates)
retain their approved rationale. Generic upstream candidates require separate
library review and a reviewed release upgrade before downstream adoption.

## 7. Mathematical Boundaries to Preserve

The anticipated design risks are now checked contracts, recorded in
[B01–B11](pfr-c16-readiness-audit.md#boundary-index). Future changes must preserve:

- independent universes, unrestricted source spaces, the finite-information
  boundary and full joint-law transport;
- support-only decoding, a common all-row posterior, null-fiber conventions and
  full-support converses;
- distinct raw, active, semantic and LP empty/singleton cases; LP input must be
  nonempty, while an admissible partition family may be empty;
- exact active restriction/injection and compression recovery, including every
  unused ambient output;
- ENNReal finiteness, justified Real conversion/cancellation and the explicit
  zero-residual branch of totalized maximal-coupling division;
- strict PPS/legal VPS guards, all merge indices, directed recoveries, genuine
  finite paths and retained endpoints;
- independent noninvolutive input/output reindexing and entire objective images;
- nonnegative full/reduced feasibility and both index restrictions; signed and
  mixed-system guards prevent false equivalences; and
- distinct LP attainment contracts, positive certificate correction and exact
  reduced variable counts.

Printed/intended/Lean differences remain in the source ledger and original
omission register. A changed extended manuscript requires affected-contract
revalidation. A plausible interpretation that changes mathematical content or
strength requires a project-lead decision.

## 8. Current Work, Roadmap, and Future Work

**Current, 2026-10-04:** C01–C16 are durably complete. The
[readiness record](pfr-c16-readiness-audit.md#c16-s05-readiness) establishes
CC01–CC08 at its reviewed checkpoint. Both S05 original reports are reconciled;
final checks and supported closure establish CC09, freshly verified in the
[post-closure checkpoint](project-log.md#post-c16-checkpoint).
No new theorem family or unresolved mathematical/API implementation is identified.

| Register | Normalized current state |
| --- | --- |
| Completed chunks | C01–C16; [preserved contracts and closure checks](pfr-c16-readiness-audit.md#c16-s04-navigation), with final C16 closure in the [checkpoint entry](project-log.md#post-c16-checkpoint) |
| Gates / omissions | DG-01–DG-15 resolved; OM-001–071 original IDs and rationale preserved |
| C16 reviewer | Existing `/root/pfr_c16_reviewer`, originating task `01a0fd72-febb-7d03-ae0c-9e8ee42d78bf`; requested Astra/ultra/no parent history, effective settings unknown. All five steps are closed and original reports reconciled. S05 cumulative assessment and corrected-source reassessment satisfy all three criteria; supported closure is verified. Revision-1 plan review is historical; no separate revision-2 plan review is claimed. |
| Numbered Future Work Notes | None opened; [authoritative register](project-log.md#future-work-notes) freshly checked in S05 |
| Mapped suggestions and later directions | [Dated disposition register](pfr-c16-readiness-audit.md#c16-s04-dispositions) names original references, owners and triggers; no unowned worthwhile deferral |
| Release / website | [Research website](plans/pfr-website.md) authorized separately and deployed on 2026-10-14; tagged release and unverified publication metadata remain separate decisions |

Future notes retain immutable numbers and full history in the log. Their current
classification belongs here, including terminal dispositions. Mapped work,
review advice and roadmap inclusion do not authorize implementation. Reassess
concrete triggers; neither automatically implement nor silently discard an idea.

## 9. Validation and Trust State

C16 S01–S05 are durably complete. The [C16 evidence register](pfr-c16-implementation-notes.md)
owns exact actors, commands, failures, source identities and original reports.
The [S05 cumulative crosswalk](pfr-c16-readiness-audit.md#c16-s05-readiness)
records the fresh assessment. The following earlier results retain their original
dates and limits; S05 evidence is recorded separately.

- S01 reconciled all six ISIT pages, 51 numbered items, 122 prose occurrences and
  version-bound extended dependencies, including the corrected Example 6 entry.
  Its independent review freshly checked the manuscripts and source.
- S02 audited all 56 maintained owners: 6,534 original compiled-owner occurrences,
  6,518 distinct names, complete public/private/generated/instance inventories,
  and 1,813 anonymous commands in 34 exact-body copy files. Copies and generated
  descendants have separate counts and provenance. Allowed transitive axioms are
  `propext`, `Classical.choice` and `Quot.sound`; generated ownership and compiler
  runtime-helper investigations retain their precise limits.
- S02 independent review reproduced the original-owner audit and controls,
  checked all copy transformations and independently compiled two copy files.
  It did not independently recompile all 34. Complete details are in the
  [trust inventory](pfr-c16-readiness-audit.md#complete-declaration-and-trust-inventory).
- S03 checked all 935 public source-named declarations, all 28 isolated
  production/example module closures, nine public consumers, pinned reuse and
  endpoint composition. The reviewer freshly replayed the closures and consumers;
  it inspected parent build receipts and reused S02 trust under exact hashes.
  It did not rerun the full build or whole trust audit in S03.
- S03 parent builds passed all 56 explicit targets (2,823 jobs) and the default
  target (2,762), with cached artifacts. Required placeholder and whitespace
  checks passed. S04 changed documentation and checked exact applicability; its original
  build and hygiene results remain in its evidence section.

- S05 freshly rehashed and inspected both manuscripts, every source/interpretation
  and boundary obligation, complete public/API ownership, full maintained builds
  and trust/import controls. The independent reviewer also ran the complete
  original-owner audit, all 34 anonymous-copy elaborations, all 28 isolated
  imports, consumers and builds. One PPM page locator is corrected with provenance.
  The original review found a stale current map allocation; the bounded correction
  and readiness pointer received a separate independent reassessment. All three
  S05 criteria are satisfied, with both original reports and their limits retained.
  Final checks and supported durable closure establish C16 completion; the
  [2026-10-04 checkpoint](project-log.md#post-c16-checkpoint) verifies the later record.

Earlier plan reviews, execution reviews, workflow recoveries and unavailable or
failed probes retain their original meaning in
[preserved records](pfr-c16-readiness-audit.md#c16-s04-navigation). Later successful
checks do not retroactively certify them. Favorable review is distinct from
subsequent durable closure. No remote CI, clean rebuild, arbitrary library/compiler
safety theorem or publication acceptance is claimed by these local checks.

## 10. Reference and Provenance Boundary

Reviewed copies of both manuscripts live outside the repository. Any local
working copies placed inside the project must remain under ignored reference
directories and must not be committed.

**[History] C01–C16 reviewed reference identity.** The six-page ISIT manuscript was
reviewed on 2026-09-02 and its digest was reverified on 2026-09-03. On
2026-09-03 the project lead designated a newer extended draft as the current
proof and clarification companion, and its in-scope statements and proof
sections were revalidated. The audit used local files identified without
committing their contents:

- six-page ISIT manuscript, SHA-256
  `48963AA59485B2C33B1A1E6E7C6EAD2251FDDDD26BD3691B6FCFFE683E6ED1C4`;
- then-current eighteen-page extended v16 draft, SHA-256
  `98636D4C9F0618EC08FCA84559572780F604F197FDA90D8D7C787B3624245B8F`.

**[Current] Updated companion — 2026-10-13.** The lead supplied
`On_perfect_functional_representation__Extended_version_ (19) (2).pdf`
(18 pages), SHA-256
`59A7CCD1E881B0A8F4BEE657727CE92A561108CA0DDB6B8F2AEB60E1D56DBC16`,
as the current extended version while requesting a private annotated ISIT
reading copy. Its selected Appendix A/B proofs (pp.12–16 and p.17 left through
Theorem 2's concluding sentence) match v16 after subtracting two from equation
numbers and their references: new (103)–(219), old (105)–(221). The existing
support, output-order and normalization-proof qualifications remain applicable.
The new IV-B passage still supplies no separate Corollary 1 proof.

This is a bounded proof-supplement comparison, not whole-draft revalidation or
new Lean acceptance. Check other affected passages before relying on them in
future work. Preserve v16-bound C01–C16 source identities, locators and original
validation records. The source PDFs and previous reading copy were not modified;
the requested derivative is local and not authorized for commit/publication.
See [project log entry 185](project-log.md#185-updated-extended-companion-and-private-reading-copy---2026-10-13).

A subsequent lead-requested private revision retains the original Lemma 4
proof in black/red and adds a blue human-language reconstruction of the existing
finite-certificate proof, followed by a discussion of the termination gap and
its resolution. The finite-auxiliary limitation and extended-version LP remark
remain explicit. This is editorial feedback to the paper, not a new Lean theorem
or approval of arbitrary rewrite termination; see
[project log entry 186](project-log.md#186-lemma-4-proof-feedback-in-the-private-reading-copy--2026-10-13).

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

**[Decision] Publication metadata boundary — 2026-10-14.** The lead approved
public repository availability under the existing Apache-2.0 software license,
with unverified copyright-holder and bibliographic metadata left unspecified.
That initial decision introduced no new source-header, rights-holder, affiliation,
DOI or publication-status claim. The lead subsequently specified **ISIT 2026**
and requested the public paper link; the verified DOI is recorded in
[AUTHORS.md](../AUTHORS.md). Further metadata remains subject to lead verification;
the manuscripts and private derived reports remain unpublished by this repository.

The lead subsequently confirmed separate authorship credits: the paper is by
Serhat Emre Coban, Yanina Y. Shkel and Emre Telatar; the Lean formalization is
credited to Serhat Emre Coban. [AUTHORS.md](../AUTHORS.md) and
[CITATION.cff](../CITATION.cff) record that distinction, without inferring
third-party permissions. The paper DOI is a public link, not a claim that the
publisher PDF was compared with the recorded local manuscript. Public readiness and a
future LeanInfoTheory announcement preserve the **v0.1.0** dependency baseline;
neither requires an upgrade. The [readiness record](public-readiness.md) owns
the publication checks and live website evidence, not a new theorem plan.

**[History] Provenance attestation.** The inherited-context report records that
no external information-theory formalization repository was consulted or
reused before this audit; this audit likewise consulted none. Non-consultation
is an attestation rather than a fact independently provable from Git history.
Existing implementation code outside this repository is not a source unless
the project lead explicitly authorizes consultation and attribution is
recorded.
