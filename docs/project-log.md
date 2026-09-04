# PerfectFunctionalRepresentationsLean Project Log

This document records meaningful decisions, mathematical steps, reviews,
validation milestones, rejected alternatives, and the authoritative detailed
Future Work Notes. Current normalized cross-thread status belongs in the
[`living summary`](perfect-functional-representations-living-summary.md), and
high-level possible direction belongs in the [roadmap](roadmap.md). The
[formalization map](formalization-map.md) owns the adaptable global source and
chunk allocation.

## Future Work Notes

Future Work Notes are the stable-numbered register for work that must remain
discoverable beyond an active plan or a single chronological entry. Numbers
are immutable: do not renumber, reuse, or delete them when a note is completed,
superseded, transferred, or made obsolete.

Each future note should record a short title, current status, opening date,
rationale, scope boundary, trigger or review point, and dated disposition
updates. Current statuses may be active, standing, transferred, or deferred;
terminal statuses may be completed, superseded, or obsolete. An active or
standing note does not authorize implementation. Risks, roadmap ideas, and
approved-plan steps do not automatically become Future Work Notes.

No numbered Future Work Notes have been opened yet.

## Chronological Record

### 1. Private downstream repository bootstrap - 2026-09-02

- Created the private repository
  `serhatemrecoban/PerfectFunctionalRepresentationsLean` as a downstream case
  study of LeanInfoTheory.
- Selected the six-page ISIT manuscript as the primary formalization target;
  the extended manuscript is a proof supplement rather than an automatic scope
  expansion.
- Pinned LeanInfoTheory `v0.1.0`, resolving to commit
  `0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`, with Lean/mathlib `v4.33.1`.
- Added the minimal Lake project, Apache-2.0 license, scope documentation,
  assistant instructions, and a dependency smoke test.
- `lake build` passed with 2,605 jobs and the strict project-source placeholder
  scan passed. Initial commit: `57e132c`.

### 2. Inherited-context and General Assistant seed - 2026-09-02

- Re-read the complete six-page ISIT manuscript and the relevant extended
  manuscript, including the omitted-proof appendices.
- Verified the PFR-facing foundations and absences against the pinned
  LeanInfoTheory source and its `v0.1.x` API contract.
- Established a PFR-specific living summary, source-of-truth hierarchy,
  paper-coverage matrix, scope boundary, canonical-document workflow, and
  initial risk/future-work register.
- Confirmed that extended-only computational-complexity, hypergraph-coloring,
  and broader information-measure material is not part of the current target.
- Prepared an ignored structured inherited-context report and initialization
  prompt for the future PFR General Assistant. No paper theorem or Lean source
  was added or changed in this step.

### 3. General Assistant initialization consistency audit - 2026-09-02

- Reconciled the complete project documentation and inherited-context report
  against both project commits, the clean local tree, GitHub repository state,
  the six-page ISIT manuscript, only the relevant extended proof pages, and the
  pinned LeanInfoTheory and mathlib sources.
- Corrected stale phase and manuscript-location wording, made coverage and
  provenance status labels explicit, recorded the exact two directions of the
  Theorem 1 reachability statement, and clarified that the root import and
  smoke-test module are the two current Lean sources.
- Verified every LeanInfoTheory declaration named in the living summary under
  its exact namespace. A targeted pinned-mathlib audit found no ready finite-PMF
  coupling/total-variation API or theorem-level LP strong-duality layer.
- Re-ran the 2,605-job default build, the focused channel/Markov build, compiled
  declaration checks, and the strict placeholder scan successfully.
- Identified support, zero-column, operation-indexing, coverage-granularity, and
  LP-contract questions for the forthcoming formalization map. No theorem,
  dependency, approved plan, or remote state was changed; the resulting
  checkpoint is documentation-only.

### 4. Documentation roles and interpretation policy - 2026-09-03

- Adopted a PFR-scaled document structure: `README.md` is the reader entry
  point; `AGENTS.md` owns stable operating rules; `docs/project-scope.md` owns
  project boundaries; the living summary owns canonical current context; this
  log owns chronology, rationale, and detailed stable-numbered Future Work
  Notes; `docs/roadmap.md` presents high-level possible direction; and future
  files under `docs/plans/` will contain explicitly approved chunk contracts.
- Recast the seven project sources as a question-sensitive judgment framework
  rather than a mechanical precedence ladder. A source governs only the kinds
  of facts it is competent to establish, and material conflicts must still be
  reported and reconciled.
- Clarified that the current extended manuscript is an evolving proof and
  clarification companion for in-scope ISIT results. Manuscript shorthand must
  be separated into its literal wording, mathematically intended reading, and
  technically precise Lean contract; material interpretation choices must be
  recorded rather than silently repaired.
- Made mathlib and pinned LeanInfoTheory the two reuse-first libraries and
  recorded a search-then-verify workflow using the frozen API inventory,
  declaration index, examples, exact source, and compiled Lean probes.
- Recorded the possible distinction between `m` effective dual-LP variables
  and a literal ambient encoding with as many as `2^k - 1` coordinates as an
  unresolved formalization risk. It is not resolved here and does not open a
  numbered Future Work Note.
- Required canonical documents to be updated proactively when work materially
  changes their owned facts, without creating helper-level log churn or
  duplicating detailed content across documents.
- Verified that PFR has no website or approved website plan; website work
  remains a deferred roadmap direction. No theorem, dependency, formalization
  map, or chunk plan was created or changed in this documentation step.
- Independently reviewed the revised rules/scope, living summary, log, and
  roadmap with no blocking findings. The 2,605-job default build and the
  3,056-job complete `LeanInfoTheory.Shannon` build passed, as did exact
  `#check`s for all 17 named dependency declarations, the strict placeholder
  scan, local-link and manuscript-digest checks, diff hygiene, and the final
  repository-scope audit.

### 5. Current extended-draft update and revalidation - 2026-09-03

- The project lead designated a newer eighteen-page extended draft as the
  current proof and clarification companion until a later replacement. Its
  SHA-256 digest is
  `98636D4C9F0618EC08FCA84559572780F604F197FDA90D8D7C787B3624245B8F`.
  The previously reviewed sixteen-page draft with digest
  `EEE73B34AE974D7486201C8403E45DC881C826DE16FDBB98EEA566336941D357`
  is superseded as a current reference but remains part of this historical
  record.
- Compared both drafts and re-read the current draft's complete in-scope
  statements and proof sections. Definitions 1-4, Lemmas 1-6, Theorems 1-2,
  Corollary 1, and both directions of the reachability characterization remain
  aligned with the ISIT target. The relevant current-draft anchors are Sections
  II-IV on pages 2-7 and Appendices A-B on pages 12-17. The current draft
  strengthens omitted-proof details, notably the zero-common-mass and
  conditional-support cases in Lemma 2, and labels the existing direct proof
  of the non-representable `3 x 3` example as Lemma 7.
- The current draft clarifies that PPM/VPM source indices range through
  `m + 1`, resolving the earlier printed merge-index ambiguity for planning.
  It also explicitly relates the full system on all `2^k - 1` nonzero patterns
  to the reduced system on the `m` occurring patterns, explaining why the
  reduced dual has `m` variables. The formalization map must still choose and
  justify its Lean representation and optimization contracts.
- The previous draft's unproved-claim wording is no longer current: the new
  draft states a separation-oracle algorithm and proved NP-hardness results.
  They remain extended-only and outside current scope; no Lean source,
  dependency, formalization map, or chunk approval changed in this reference
  update.

### 6. Draft formalization map - 2026-09-03

- Created `docs/formalization-map.md` as the canonical adaptable layer between
  the reader-facing roadmap and future approved chunk plans. Draft revision 1
  is proposed for project-lead review and does not authorize implementation.
- Reconciled the complete six-page ISIT source, the current eighteen-page
  extended proof/clarification companion, the zero-declaration Lean baseline,
  the pinned LeanInfoTheory `v0.1.0` API, and relevant pinned-mathlib
  surfaces.
- Allocated the target to sixteen dependency-aware candidate chunks: semantic
  representation and canonicalization; singular and binary cases; finite
  coupling; the active matrix boundary; operation definitions, normalization,
  preservation, and reachability; pattern compression and incidence systems;
  primal and dual characterizations; and final trust/coverage closure.
- Recorded fifteen cross-chunk decision gates, including prior independence,
  support cardinality, active output columns, output-changing types,
  `ENNReal`/`Real` conversion, maximal coupling, full/reduced incidence
  systems, primal/dual attainment, and the missing generic strong-duality
  layer.
- Opened a separate stable-numbered internal omission/disposition register in
  the map. It is intentionally exhaustive during private development and is
  not the Future Work Note register. It records cited external results,
  documentation-only claims, proof/fixture dispositions, source repairs, and
  extended-only exclusions so they cannot be forgotten during later chunk
  planning.
- The internal register may receive a project-lead-approved
  publication-facing curation later, while mathematically meaningful
  omissions and the historical rationale remain recorded.
- Reconciled one stale bootstrap comment in
  `PerfectFunctionalRepresentations/Basic.lean` so map approval cannot be
  mistaken for chunk approval. No Lean declaration or executable proof
  content, Lake file, dependency, approved plan, Future Work Note, theorem
  status, website state, commit, or remote state changed in this map drafting
  step.

### 7. Second adversarial formalization-map review - 2026-09-03

- Re-read draft revision 1 against the complete six-page ISIT manuscript, the
  complete current eighteen-page extended draft, the canonical documentation,
  and the pinned dependency sources. Revision 2 remains a non-authorizing
  draft with the same sixteen stable candidate chunks and fifteen open decision
  gates.
- Corrected a hidden dependency: multiway VPS and decoder-fiber constructions
  need a minimal exact-partition interface before the incidence-system chunk.
  `PFR-C10` now owns that interface, `PFR-C11` reuses it, and `PFR-C13` owns
  enumeration and incidence. `PFR-C12` now depends on C10's repeated-PPS
  machinery, allowing C11 and C12 to proceed in parallel afterward.
- Separated intrinsic channel cardinality from pair support in the binary
  results; exposed the finite-auxiliary hypothesis for information-valued
  statements; distinguished a marginally canonical coupling law from a
  canonical representation of a fixed pair; and made the full-support
  cancellation needed for a common channel posterior a local C02 obligation.
- Refined the matrix and operation contracts: the proposed heterogeneous
  state must package nonempty input, positive output cardinality, and active
  columns; VPS's printed exclusion of value one remains an explicit gate;
  split/merge “inverses” become witness-parameterized recovery theorems; and
  multiway operation prose must elaborate to finite binary cascades.
- Rejected the literal ISIT `m × R` system that keeps all Bell partitions but
  removes unobserved-pattern rows, because it can admit unconstrained weights.
  C13 instead owns the extended full/reduced systems and their equivalence for
  nonnegative equality feasibility, together with the input-pattern incidence
  identities needed by the primal and dual proofs.
- Added `OM-047` through `OM-052` for the incidence-system defect, weakened
  reading of Definition 1, value-one VPS mismatch, missing parameter
  hypothesis in Examples 2-5, nonliteral inverse claims, and multiway-operation
  shorthand. Expanded existing entries for Equation (4), extended
  information-measure claims, VPS masks, and numbered proof intermediates.
  The internal omission/disposition register now contains fifty-two immutable
  records; no omitted external or extended-only result entered scope.
- Refined C04 as dependency-independent finite-PMF infrastructure, made C13's
  core indices subtype-based, narrowed C14 to the completed C13 interface, and
  made the primal and dual core domains and attainment iff statements
  explicit. The specialized C15 separation route remains provisional but has
  verified pinned support through finite convex separation and coordinate
  duality declarations.
- Validated revision 2 with an independent dependency-graph and source-coverage
  review, exact sequential-ID and reference checks for all chunks, gates, and
  omissions, a focused compiling probe for the newly named pinned declarations,
  the 2,605-job default build, the strict placeholder scan, Markdown-link and
  manuscript-digest checks, and `git diff --check`. No theorem-development
  chunk was approved or started.

### 8. Formalization-map acceptance checkpoint - 2026-09-03

- The project lead accepted formalization-map revision 2 as the current
  adaptable global allocation and requested a committed documentation
  checkpoint before opening the first chunk task.
- This acceptance makes the map the planning reference but does not approve a
  chunk contract or authorize theorem implementation. All fifteen decision
  gates remain open for their owning detailed plans, and all sixteen candidate
  chunks remain mapped rather than approved.
- The next activity is a fresh task devoted to the detailed `PFR-C01` plan.
  That task must resolve `DG-01`, verify the exact focused pinned APIs and
  manuscript contract, present stable proposed implementation steps, and stop
  for project-lead approval before editing theorem source.

### 9. PFR-C01 detailed-plan Draft revision 2 under review - 2026-09-04

- Prepared the non-authorizing PFR-C01 detailed-plan Draft revision 2 against
  planning baseline `d9f63e713eab6f778132dc6888420adb442d0802`. The draft
  remains outside `docs/plans/`; no chunk plan is approved and no
  theorem-development chunk is active.
- The first independent review confirmed Equations (1)-(3), their signs and
  conditioning order, support-aware decoding, the Markov equivalence, and the
  finite-value boundary, but found that the original proposal discussed and
  deferred, rather than allocated as a formal target, the manuscript's
  separate existential statement that `(X,Y)` is perfectly representable.
- Draft revision 2 restores that source allocation by proposing a law-invariant
  pair predicate witnessed by a finite triple-law extension whose `(X,Y)`
  marginal is the fixed pair law. Its `Fin n` normalization adds no restriction
  beyond C01's proposed finite-auxiliary information boundary and avoids
  requiring the auxiliary to live on the original sample space.
- Added immutable record `OM-053` for the source-to-Lean boundary that the
  manuscripts do not literally finite-qualify the introductory existential
  auxiliary, while C01 deliberately limits information/perfectness statements
  to the finite-valued pinned API. Structural fixed-`Z` semantics remain
  unrestricted, `Fin n` only normalizes the hidden finite witness,
  infinite-alphabet information statements remain excluded in C01, and PFR-C02
  canonicalization later supplies the finite-canonical-witness justification.
  `OM-014` retains its distinct canonical support-enumeration meaning.
- Focused pinned-API probes compiled the structural and information contracts,
  the pair-extension encoding, and normalization of an arbitrary finite
  auxiliary, including `ULift (Fin 2)`, using the supported focused import
  `LeanInfoTheory.Shannon.SemanticBridge.Markov`.
- A second independent review found the mathematical and pinned-API proposal
  feasible and requested exact revision identity, approval-checkpoint
  validation, execution-baseline bookkeeping, revision policy, status
  reconciliation, concrete edge regressions, and minor contract-table
  corrections before approval.
- DG-01 remains open. No maintained Lean source, dependency, manifest,
  toolchain, approved plan, or gate resolution changed; no implementation,
  commit, or push was authorized.

### 10. PFR-C01 plan approval and DG-01 resolution - 2026-09-04

- The project lead explicitly approved PFR-C01 Draft revision 2 dated
  2026-09-04 without changing its contract and separately authorized creation
  and commit of the approval-documentation checkpoint. No push was authorized.
- Created the tracked approved plan at
  [`docs/plans/pfr-c01-semantic-functional-representations.md`](plans/pfr-c01-semantic-functional-representations.md).
  PFR-C01 is `Approved`, not `Active`; no theorem implementation has begun.
- The approved source anchors are the six-page ISIT final manuscript, Section I
  through Equations (1)-(3), digest
  `48963AA59485B2C33B1A1E6E7C6EAD2251FDDDD26BD3691B6FCFFE683E6ED1C4`,
  and the corresponding introduction of current extended version 16, digest
  `98636D4C9F0618EC08FCA84559572780F604F197FDA90D8D7C787B3624245B8F`.
  Focused probes through the supported
  `LeanInfoTheory.Shannon.SemanticBridge.Markov` import compiled the structural
  carrier, Equations (1)-(3), fixed perfectness, pair-law extension, and
  higher-universe finite-witness bridge.
- Resolved `DG-01` with the layered law-level/common-base `...Of` carrier,
  support-correct existential product decoder, separate structural and
  information layers, distinct fixed-auxiliary and existential-pair notions,
  and the law-invariant `Fin n` triple-law extension. Information/perfectness
  statements use the finite-valued pinned API without a source-space
  `Fintype` assumption; structural fixed-`Z` semantics remain unrestricted.
- Adopted `OM-053` as the explicit source-to-Lean record for the finite-valued
  information boundary and retained PFR-C02's later finite-canonical-witness
  justification. The other fourteen decision gates remain open.
- Reconciled the formalization map, living summary, README, roadmap, and
  project-scope phase language. The full ignored draft handoff was removed
  before validation so it cannot compete with the tracked plan.
- The authorized, successfully validated approval-checkpoint commit containing
  the plan is the execution baseline. S01 must verify that exact commit before
  activation records its hash; substituting that same hash is preauthorized
  bookkeeping, while any different checkpoint is a material revision.
- The initial approval-checkpoint validation passed: the 2,605-job default
  build, exact strict placeholder scan, diff whitespace checks, all 24 relative
  links across eight maintained Markdown files, absolute-path/app-directive
  audit, dependency-pin checks, complete diff/status and artifact audit, and
  tracked-plan hygiene. An independent approval-transition audit found no
  remaining blocker. The final staged items 1-8 closeout is run after this
  evidence record, with no subsequent file edit before commit.
- PFR-C01 remains `Approved`, not `Active`. No Lean theorem implementation
  occurred; S01 is the next separately prompted step.
