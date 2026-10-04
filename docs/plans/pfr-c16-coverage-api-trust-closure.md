# PFR-C16 — Coverage, API, and Trust Closure

<!-- pfr-review-status:start -->
**Status:** Active, revision 2 — 2026-10-03; S01–S04 complete; S05 reviewed, provisional final checkpoint. Supported S05 closure establishes Complete.
The lead endorsed revision 2 and separately authorized each implementation step.
S05 startup verified all four prior durable closures, twelve satisfied parent and
independent criteria, four original-report reconciliations and exact S04 F/current
source, Git and environment equality before accepting the conditional request once.
S04 closure is
`a8accbaafe313343cb3953bf80a7bffab09712f18b948902caf2415ccda53cdc`.
S05 freshly reassessed the complete manuscript, boundary, API/import, trust and
documentation contract. The original independent report identified one stale
current-status paragraph. The bounded correction and readiness pointer were
independently reassessed; all three S05 criteria are satisfied. Both original
reports are preserved and reconciled. Applicable final checks and supported
durable closure establish CC09 and C16 completion. No later work starts.
C01–C15 prerequisites remain complete. No Lean/API/import change is made.

The original approved draft and earlier reviewed records are preserved; only
this editorial block changes. Revision 1 satisfied its six planning criteria;
that review is not a separate revision-2 plan review. The lead supports justified
adaptation during an authorized step, retaining mathematical intent, scope,
acceptance and actual-result review. A separate step request starts only its step.

**Reviewer:** `/root/pfr_c16_reviewer`, originating task
`01a0fd72-febb-7d03-ae0c-9e8ee42d78bf`, parent `/root`; requested
`gpt-6-astra` / `ultra` / `fork_turns="none"`, effective settings unknown.
The existing binding is retained.
[Readiness audit](../pfr-c16-readiness-audit.md#c16-s03-api) owns S03 dispositions;
[implementation notes](../pfr-c16-implementation-notes.md) own evidence/review;
[coverage audit](../pfr-c16-coverage-audit.md) owns the source ledger;
[planning notes](../pfr-c16-planning-notes.md) retain planning history and limits.
<!-- pfr-review-status:end -->

## 1. Objective, baseline and authority

C16 closes the six-page ISIT formalization's coverage, mathematical boundaries,
public API, imports, documentation and trust evidence. The map allocates no new
theorem family. Completion means that every source claim has an honest verified
disposition and the integrated in-scope development passes the checks below.
It does not mean that every display has a public Lean declaration.

Startup HEAD is `54c1714d1a9a891939d6c9f7d38c0d05896b2c75`, with nine tracked
changes and 142 nonignored untracked files. These inherited changes are part of
the working baseline, not C16 contributions. Preserve them, private review state,
original reports and frozen historical snapshots. Capture each actual step's B
separately from this planning baseline and from changes since HEAD.

C15 S05 supported closure is
`473fbfaa8cffa154fa1011e65f719c113eae30d4dd722dfae25ff302ee691c5c`, with final F
`dcdbe6434aafa45dd8df7e8b730ec2515c06b5eda581c61dfe1d2c83c603d5cf`.
At startup all five steps were closed, all fifteen closing criteria satisfied,
all five original reports reconciled and all four historical findings resolved.
All 174 final source/environment entries and Git facts matched current state
before C16's documentation edits. This accepts C15 as a prerequisite; it does
not claim a fresh cumulative mathematical audit of C01-C15.

The installed pins remain clean and match the manifest:

- Lean `leanprover/lean4:v4.33.1`;
- LeanInfoTheory immutable `v0.1.0`,
  `0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`;
- mathlib `0df444a360eaa60ab8c11dca51a86af692955474`.

**Non-goals:** new theorem families, a generic optimization library, solvers,
executable decision procedures or complexity claims, extended-only mathematics,
broad API refactors, dependency or workflow changes, automation features,
commits/pushes, publication, websites, release metadata and public curation.
No wrapper implementation is proposed in this revision.

Approval applies to one exact plan revision. Each execution step also requires
its own eligible request; requesting a step need not reapprove an unchanged
contract. Material contract revisions require renewed approval. One execution
request closes one step and stops. A missing in-scope result cannot be relabeled
an optional omission to meet completion: investigate it and
seek a scoped repair decision if it exceeds this audit contract. Routine factual
documentation corrections, focused consumer checks and nonbreaking corrections
that preserve an already approved mathematical contract may be handled within
the authorized owning step, with source-bound validation and review.

## 2. Manuscript anchors and the coverage contract

### 2.1 Version identities and source bounds

The original binaries were freshly hashed during planning. Bounded visual checks
covered ISIT p.5 and extended p.7; this is not the full execution coverage audit.

| Source | Exact identity | Execution inspection boundary |
| --- | --- | --- |
| Six-page ISIT final, local filename ending `final_manuscript_ (3).pdf` | SHA-256 `48963aa59485b2c33b1a1e6e7c6ead2251fdddd26bd3691b6fcffe683e6ed1c4` | All six PDF pages: abstract and I; II-A/B/C; III-A/B; IV-A/B/C; Appendix; Figure 1 and caption; references and metadata dispositions. |
| Eighteen-page extended version 16, lead-designated 2026-09-03 | SHA-256 `98636d4c9f0618ec08fca84559572780f604f197fda90d8d7c787b3624245b8f` | Every proof/clarification dependency of the in-scope contracts, identified from C01-C15 plans, source and notes. Principal anchors are I-IV and Appendices A-B through (221), before Appendix C. Read only the relevant parts. |

Local paths, extracts and renders stay external or ignored; do not copy papers
into maintained documents or private review records. Record the designated
version, date, digest and precise section/page/equation anchors. A differing
binary is not silently treated as a replacement. Recheck affected contracts
when the lead designates a new extended version; do not infer new scope from it.

### 2.2 Required source ledger

Create `docs/pfr-c16-coverage-audit.md` as the detailed final crosswalk, linked
from the map's concise allocation. Seed it from the map, then inspect the actual
manuscript from beginning to end; the existing table is not completeness evidence.
Every numbered item must have its own stable row, even when several rows share
one proof. The initial index is Equations (1)-(28), Definitions 1-4, Lemmas 1-6,
Theorems 1-2, Corollary 1, Remarks 1-2, Examples 1-7 and Figure 1. Verify this index
against all pages, including inline numbering, captions and unnumbered displays.

Use stable IDs such as `C16-EQ01`, `C16-DEF01`, `C16-LEM01`, `C16-THM01`,
`C16-COR01`, `C16-REM01`, `C16-EX01`, `C16-FIG01`. Assign substantive prose
`C16-PROSE-<section>-<ordinal>` IDs with page, column and bounded textual locators.
Repeated assertions may point to one contract but keep their source occurrence.
The page/paragraph sweep must also identify nonmathematical regions with explicit
OM-022/023 dispositions, so omitted source regions are visible.

Each row records:

1. exact source anchor and a concise statement of the printed claim;
2. intended mathematical reading and precise Lean contract, with hypotheses;
3. one or more coverage modes: public declaration, proof-internal result,
   compiling fixture, documentation disposition or intentional omission;
4. actual declaration and owner path, or a precise private proof/test region;
5. stable references to supporting source-inspection/build/check evidence;
6. extended-manuscript dependencies, interpretation/decision IDs and OM links;
7. any unresolved issue, its owner, next action and whether it blocks completion.

From S01 onward, keep shared evidence entries in the implementation notes with
stable IDs, actual actor, date, command/method, source/configuration/dependency
identity, result and limitations. Coverage and readiness rows reference these
entries; full originals remain in the existing private evidence records. A later
check gets a new entry with its applicability relationship, preserving earlier
results. This is document organization and requires no new evidence tooling.

A file import, matching theorem name, nearby test or favorable earlier summary
alone does not establish the claim. Check the full type and relevant proof or
fixture assertions. Fixtures must check the claimed coordinates or behavior;
private declarations need not be promoted merely to make a link. Do not count a
source-body copy as the original compiled declaration.

### 2.3 Starting allocation and extended-dependency inventory

The following is a planning index into completed contracts, not a new audit verdict.
S01 expands it into the individual rows above and checks for missed dependencies.

| ISIT anchors / owner | Companion and interpretation checks |
| --- | --- |
| I, (1)-(3), fixed/existential perfectness / C01 | Extended I; finite-valued information contract, unrestricted source, enlarged finite witness law, nats; OM-035/053. |
| II-A, Definition 1, (5)-(7), properties 1-4, Remark 1, Lemma 1, Definition 2 / C02 | Extended II-A p.2; fixed-pair decoder relation, all-prior forward claims, full-support converse and support-subtype bridge; OM-048/054/055. |
| II-B, Definition 3, Lemma 2, (8), Example 1 / C03/C05 | Extended Appendix A (105)-(146), pp.12-13; binary input (111)-(124), binary output (125)-(134), counterexample (135)-(146). Distinguish active outputs from prior-dependent pair support. |
| II-C, (9)-(10), Lemma 3 / C04/C05 | Appendix A (147)-(166), pp.13-14; finite coupling (156)-(161), weighted null-fiber interpretation, actual attainment and full-support equality converse. |
| III-A, Definition 4, (11)-(15), operations, Examples 2-5, Lemma 4 / C06-C08 | Extended III-A and Appendix B (167)-(174), pp.14-15; merge range/order, VPS value one, nondegenerate masks, implicit example parameter, witnessed inverses and normalization proof. |
| III-B, Lemmas 5-6, Theorem 1; Appendix (20)-(28), Figure 1 / C09-C11 | Extended III-B (16)-(24), p.4, and Figure 1 p.5; preservation Appendix B (175)-(202), pp.15-16; generic synthesis and extended Example 6 (25)-(32), including its (30) output permutation. |
| IV opening and IV-A, (16)-(17), Examples 6-7 / C12/C13 | Extended IV-A pp.5-6, particularly full/reduced clarification (40)-(56), plus the completed plans' exact example anchors. Active compression, distinct occurring patterns, exact partitions and nonnegative equality bridge. |
| IV-A, Theorem 2/(18) and nonsingularity paragraph / C14/C03 | Extended (64), p.7; Appendix B (203)-(221), pp.16-17; attained greatestness and conditional singular-data construction. |
| IV-B, Corollary 1/(19), reduced variable count / C15 | Extended (65)-(67), p.7, with IV-A (47)-(53); attained leastness, nonnegative duals and entire finite objective image. No silent full/reduced inequality equivalence. |
| (4), Remark 2, cited claims, algorithmic/runtime prose, restatements and bibliography | Existing omission/disposition owners, including OM-001-023/028-042. Referenced external results and extended-only sections remain outside automatic formalization scope. |

For each extended dependency say whether it supplies proof, clarification,
notation/representation repair, or only background. Record a source departure
separately from an alternative valid proof route. The C15 specialized separator
proof is project mathematics establishing the in-scope corollary; it is not a
claim that the source supplies a generic strong-duality library.

## 3. Mathematical boundaries and trust evidence

### 3.1 Boundary matrix

Create a boundary matrix in `docs/pfr-c16-readiness-audit.md`. Each row below
needs actual declarations/fixtures, applicable evidence and a reason for any
inapplicable case. Reuse existing regressions before adding focused consumers.
An impossible PMF/type instance is documented as such, not represented as a
successful inhabited example.

| ID | Required check and main owners |
| --- | --- |
| C16-B01 | Structural versus finite-information assumptions; independent universes, unrestricted source and finite auxiliary/value boundary; right-associated products, pushforward laws, fixed auxiliary versus existential enlarged law. C01/C02/C05. |
| C16-B02 | Support-only decoding; one common posterior; all-prior forward versus full-input-support converse; arbitrary-prior support restriction; unseen input rows and degenerate-prior equality regression. C01-C03/C05. |
| C16-B03 | Null conditional fibers and pinned total-channel fallback; zero-weight conditional-entropy terms; no posterior uniqueness on unused outputs. C02/C05/C09/C11. |
| C16-B04 | Empty and singleton alphabets at each semantic/raw/active/LP boundary; nonempty input where required; zero active outputs impossible with a nonempty input PMF channel; singleton witnesses; empty admissible-partition family allowed. C03/C06/C10/C13-C15. |
| C16-B05 | Ambient zero-probability outputs, injective extension, exact active restriction and recovery; no invented positive column datum on a zero column; compression round trips, including dependent membership proofs. C03/C06/C12. |
| C16-B06 | `ENNReal` mass finiteness, `toReal`/`ofReal` signs and round trips; no division by zero; overlap endpoints 0/1, exact aggregate/Real bridge, row normalization versus total pattern-value sum. C04-C07/C12/C13. |
| C16-B07 | PPS strict ratios, VPS nonempty pieces and allowed value-one split; full merge-index range, lower survivor and directed permutations; witnessed recovery, empty/singleton paths, finite synthesis and rigorous normalization despite expanding rewrites. C07-C11; OM-024/038/043/049-052/070-071. |
| C16-B08 | Semantic-to-matrix orientation, input/output relabeling, non-involutive independent row/column reindexing, supplied finite enumerations, transpose orientation, arbitrary-vector inverse and entire objective images. C06/C08/C12-C15. |
| C16-B09 | Full versus reduced incidence; equality feasibility requires nonnegative coefficients; absent patterns excluded from reduced constraints; exact occurring-variable count versus `2^k - 1`; mixed-system and signed regressions. C13-C15; DG-12. |
| C16-B10 | Equality/primal/dual predicates distinct; attainable `IsGreatest`/`IsLeast` includes membership; objective-one dual witness alone is insufficient; empty constraints, nonperfect subunit certificate, correction cardinalities and positive scaling. C14/C15; no global optimizer or solver claim. |
| C16-B11 | Figure 1/decoder-fiber and multiway-construction logical content; active auxiliary support, nonempty exact blocks and actual operation endpoints. C10/C11/C13. |

Preserve every approved interpretation. An ambiguity affecting truth, assumptions,
strength or acceptance needs a lead decision; neither an omission entry nor a
passing compiler discharges it.

### 3.2 Evidence and trust protocol

For every check retain its actual actor, command/method, source/configuration and
dependency identity, output, exit status and limits. Label fresh parent results,
fresh reviewer results, applicable historical checks, reviewer-reported checks,
failed attempts and unavailable evidence distinctly. Applicability requires a
source/dependency impact comparison; dates or clean Git status alone do not suffice.

Inventory all maintained project Lean modules and their declaration owners,
including the root, examples and tests. Audit actual elaborated types and
transitive axioms of public, private, generated and local-instance declarations.
Include generated constants outside a namespace/header filter; C15's late
`Dual.Feasible.eq_1` discovery is an explicit regression for inventory completeness.
Reconcile source commands with compiled module ownership. For anonymous examples,
prefer actual compiled evidence where available; if exact-body transparent copies
are needed, retain the reversible transformation, full context, source/olean/ilean
hashes and separate attribution. Never describe copied elaborations as original
anonymous constants or use a regex-only list as an exhaustive environment audit.

Retain a small diagnostic for the inventory method covering known imported,
private/local-instance, generated and copied-anonymous cases. Include
`Dual.Feasible.eq_1`: command lookup and a simple environment-membership query can
differ. Explain lookup, enumeration and ownership differences and classify all
unmatched entries. Successful controls supplement the complete reconciliation;
unexplained omissions prevent closure. S05 reruns the diagnostic. Scope the
inventory to project declarations and inspect their transitive axioms; do not
expand this into an exhaustive inventory of dependency libraries.

Only `propext`, `Classical.choice` and `Quot.sound` are permitted axioms. Investigate
any additional trusted axiom or unsafe proof path; no placeholder, unapproved
axiom or equivalent bypass is acceptable. Run the literal AGENTS placeholder
scan as well as the elaborated audit. Source matching does not prove manuscript
alignment; structural workflow closure is not an independent proof certificate.

The detailed scripts/results belong in ignored scratch and durable private
evidence under the installed procedure; concise methods/results and reproducible
commands belong in the implementation notes. Do not modify the review tooling.

## 4. API, import ownership and the wrapper decision

All project-owned mathematics stays in `PerfectFunctionalRepresentations`, with
existing nested owners retained. Generic PMF ownership requires a demonstrated
reusable construction. Audit public names, hypotheses, finite generality and
consumer use; preserve useful `Finite`/`Fintype` distinctions. A stylistic alias,
symmetric variant or private helper is not promoted without concrete need.

The root currently has six direct Basic/semantic/probability imports. Matrix,
optimization, examples, tests and the optional decoding bridge stay separately
importable. Check transitive closure and declaration availability with isolated
consumers. Do not promise that no foundational geometry is transitively present:
measure the actual boundary. There is no `PerfectFunctionalRepresentations.Optimization`
aggregate to build; use actual module names or an explicitly inventoried existing
aggregate. Do not add a heavy public umbrella just for the audit.

For each isolated consumer, record required declaration availability and expected
absent project modules, then verify the actual transitive import closure. These
are the minimum exclusions, using exact module names from the current inventory:

| Production consumer | Expected absent project modules/layers |
| --- | --- |
| Root | Matrix, Optimization, Examples, Tests and `Probability.FiniteCouplingDecoding`. |
| C13-only `Optimization.IncidenceConstruction` | Primal, Dual, DualCharacterization, Examples and Tests. |
| Primal | Dual, DualCharacterization, Examples and Tests. |
| Dual | DualCharacterization, Examples and Tests. |
| Every production closure | Tests. |

Dual's Primal dependency and Primal's incidence/construction dependencies are
intentional. A positive compiling consumer alone does not establish an exclusion;
the shared incidence test fixture imports later layers and cannot stand in for
the isolated C13 production consumer. These checks do not require splitting that
fixture or excluding foundational mathlib geometry.

### 4.1 Existing interfaces to verify and reuse

These are existing source declarations, not proposed names:

| Owner | Interface / role |
| --- | --- |
| `Semantics.Singularity` | `IsPerfectlyRepresentableChannel.isSingular`; nonsingular rejection follows by contradiction, without imposing finite alphabets on that theorem. |
| `Matrix.PatternCompression` | `CompressedPatternData`, `compressedPatternData`, `isPerfectlyRepresentableChannel_iff_compressedPatternData`; exact/Real and ambient support boundaries. |
| `Optimization.Incidence`, `Optimization.IncidenceConstruction` | Existing full/reduced coordinates, nonnegative equality feasibility and perfectness characterization; counts and reindexing. |
| `Optimization.Primal` | `Primal.isPerfectlyRepresentableChannel_iff_isGreatest_compressedPatternData` and `Primal.isPerfectlyRepresentableChannel_iff_exists_objective_eq_one_compressedPatternData`; arbitrary finite ambient singular channel. |
| `Optimization.Dual`, `Optimization.DualCharacterization` | Weak duality, entire finite objective image, `Dual.isPerfectlyRepresentableChannel_iff_isLeast_compressedPatternData`, and `Dual.exists_feasible_objective_lt_one_of_not_perfect`. |

The boundary uses the established `alpha -> PMF beta` and Real-valued information
in nats. Before suggesting any generic replacement, search local source, pinned
LeanInfoTheory source, `docs/v0.1-public-api.md`, API documentation, declaration
index, theorem highlights and module guide, then pinned mathlib; compile a focused
candidate probe. Record genuine discoverability friction only. Current upstream
or other external information-theory implementations are not substitutes.

### 4.2 Proposed broader-wrapper disposition

**Recommendation: do not add a broader wrapper in C16.** Existing nonsingular
rejection and the two ambient singular-channel iff statements express the full
case split for finite channels with nonempty input: `κ : α → PMF β` with
`[Fintype α] [Nonempty α] [Finite β]`. Singularity necessity retains its weaker
`[Nonempty α]` contract without finite-alphabet assumptions; this does not enlarge
the LP interfaces' domain. `compressedPatternData` depends on singularity; a combined
existential over that proof would add packaging and imports without a demonstrated
consumer benefit. An anonymous composition probe checks that existing endpoints
compose; it is not a proposed public declaration or new formalization obligation.

S03 must reassess this recommendation against the completed coverage ledger and
actual consumers, recording its evidence under the existing C16/OM-018 allocation.
Approval of this plan would adopt the no-wrapper default. If a real blocked
consumer is found, write a precise alternative contract, hypotheses, namespace,
imports, existing dependencies and validation obligations, then obtain approval
of that material revision before implementation. Mention in a map or an optional
review suggestion does not authorize a wrapper. Solver integration and general
optimization infrastructure remain outside either choice.

### 4.3 DG-15 classification

Audit and finish the remaining gate with an explicit per-item disposition:

- Remark 1: C02 public law/prior bridges, preserving its fixed-source limitation;
- Example 1: existing C03 named channel/entries/singularity/nonrepresentability;
- Examples 2-5: existing C07 private operation fixtures;
- Examples 6-7: existing C13 private incidence fixtures;
- current-extended Examples 2-8: cross-reference the corresponding C07/C10/C13
  fixtures, including C10's reachability example, with version-specific numbering;
- Remark 2: documentation-only external equivalences, OM-010-012;
- Figure 1: C11 checked proof content; artwork omission OM-020.

These are starting classifications. Check each exact assertion and owner before
closing DG-15; a category label alone is insufficient. Keep demonstration fixtures
and generic regression tests in their existing owners and avoid duplicated data.

## 5. Dependent steps and stable acceptance criteria

Five steps separate different reviewable outputs. Source reconciliation defines
what must be checked; boundary/trust work establishes evidence; API decisions
use both; document reconciliation makes the result consistent; the final stage
independently validates the complete integrated result. Each stage owns its
substantive work, so S05 is verification rather than unfinished implementation.

### PFR-C16-S01 — Complete source and interpretation crosswalk

Depends on C01-C15 prerequisite evidence. Produce the Section 2 ledger and
extended-dependency inventory; inspect every ISIT page and relevant companion
anchor. Update the map only for actual coverage/interpretation findings.

- **C16-S01-A:** Every numbered item and substantive prose occurrence has a
  source-bounded stable row and an evidence-backed coverage mode; the complete
  page/paragraph sweep leaves no unclassified region or in-scope claim.
- **C16-S01-B:** Printed/intended/Lean readings, every material assumption and
  source departure, and all extended proof/clarification dependencies are
  version-bound and linked to actual declarations, proofs or fixtures.
- **C16-S01-C:** Every omission keeps its original rationale/ID; any newly found
  omission is explicitly registered. Actual gaps are investigated or escalated,
  and inherited completion versus fresh evidence is accurately distinguished.

### PFR-C16-S02 — Mathematical boundaries and trust audit

Depends on closed S01. Establish Section 3 evidence over the whole in-scope
development. Reuse maintained regressions; add only necessary focused consumers
under their existing owners. No theorem family or general infrastructure is added.

- **C16-S02-A:** C16-B01-B11 each has current source/signature/assumption and
  regression evidence, or a justified inapplicability statement; all source
  interpretations retain their approved strength and support conventions.
- **C16-S02-B:** Complete module/declaration/instance/generated/anonymous
  inventories reconcile with the actual compiled owners, and the Section 3.2
  diagnostic explains lookup/enumeration differences. Transitive axiom and
  placeholder audits pass with the Section 3 provenance distinctions and no
  unapproved trust dependency or uninvestigated coverage hole.
- **C16-S02-C:** All maintained project modules, actual downstream aggregates
  and default target build successfully; source/dependency/environment receipts
  make check applicability explicit. Any correction is bounded, reviewed and
  reflected in the coverage/readiness records; material changes require approval.

### PFR-C16-S03 — API, imports, DG-15 and wrapper disposition

Depends on closed S01/S02. Review the public surface against real consumers;
complete Section 4 decisions and focused import/availability probes.

- **C16-S03-A:** Public names, namespaces, generality, pinned reuse and test
  ownership have a complete disposition; isolated root, probability/decoding,
  matrix, C13-only, Primal-only and Dual-only consumers establish actual import
  boundaries through availability checks and explicit expected exclusions,
  without accidental heavy root or reverse test dependencies.
- **C16-S03-B:** Every DG-15 item is linked to its exact checked public, private,
  fixture or documentation owner; resolve the remaining gate without automatic
  fixture/helper promotion. Existing omission rationale remains available.
- **C16-S03-C:** Record a concrete-consumer-based broader-wrapper decision,
  with the proposed no-wrapper default and its revisit condition. No unapproved
  wrapper, broad refactor or generic replacement is implemented; justified
  bounded changes retain old contracts and pass appropriate builds/audits.

Before S03 closes, refresh affected builds, signatures/assumptions/axioms,
declaration/generated-owner inventories and boundary/import consumers after any
Lean or import change. Update coverage/readiness references and justify retained
evidence against the changed source. Preserve S02 originals and append replacement
or supplemental evidence. Documentation-only edits require an applicability
assessment; they do not automatically require every mathematical check to rerun.
S04 readiness must use current evidence, and S05 still performs the full fresh pass.

### PFR-C16-S04 — Documentation, deferred work and integrated readiness

Depends on closed S01-S03. Finish Section 6 owner updates and prepare the complete
readiness crosswalk from every earlier criterion, boundary row and completion ID
to source/evidence. Reconcile stale current wording without rewriting history.

- **C16-S04-A:** Living summary, map, roadmap, project log, reader entry point,
  relevant scope/status and plan pointers agree on actual coverage, decisions
  and limitations. Frozen earlier records remain unchanged; current summary/map
  overlays identify later completion and explain preserved plan checkpoints.
  The Quick Start is a short current-state overview of completion, remaining
  decisions, active-plan pointer, essential limitations and reading routes.
  Replace detailed historical checkpoint narratives there with links to their
  preserved records; preserve any unique context in its owning document first
  and check the links. This internal navigation cleanup does not curate omissions
  or alter frozen plans and original evidence.
- **C16-S04-B:** Every mapped deferral, relevant review suggestion and numbered
  Future Work Note has a dated disposition with original reference, owner and
  trigger where still open. Preserve all OM-001-071 IDs/rationale and any additions;
  do not perform publication-facing condensation or archival.
- **C16-S04-C:** The complete readiness matrix establishes CC01-CC08 below,
  with no unfinished required source, mathematical, API or documentation duty
  delegated to final validation. Builds/hygiene and source applicability are
  current; final independent validation and closure remain explicitly pending.

### PFR-C16-S05 — Fresh independent cumulative validation and closure

Depends on durable S01-S04 closure. The same persistent reviewer must perform a
fresh cumulative assessment of the entire approved C16 contract and the integrated
formalization, not merely review S04's edits or repeat previous favorable verdicts.

- **C16-S05-A:** Fresh parent and independent source-based passes reassess all
  twelve earlier step criteria, CC01-CC08, every coverage/interpretation row,
  C16-B01-B11 and the underlying proof/fixture/API ownership. Rehash manuscripts
  and pins, check full ISIT coverage and every relevant extended dependency;
  historical reports provide context, not substitute independent assessment.
- **C16-S05-B:** Freshly run the full maintained module/default build suite,
  focused import consumers and expected-exclusion checks, complete
  declaration/assumption/axiom inventory with its diagnostic controls, and
  placeholder/artifact checks. Independent results and limits are recorded by
  the reviewer; all original reports/findings are critically reconciled under
  the installed procedure, with any criterion gap receiving a satisfactory
  independent reassessment before acceptance.
- **C16-S05-C:** Prepare final owning documents before F, obtain applicable
  final checks and exact final source, satisfy all finding/report/criterion
  duties and use supported closure to establish CC09. Review-time assessments
  concern evidence and readiness; they do not falsely attest to future closure
  acts. Only the durable closure establishes C16 completion, then stop.

If this cumulative stage finds a material defect, record affected acceptance,
repair only within authorized scope, refresh applicable review and stop without
declaring completion until the complete criteria pass. A repair that changes
mathematical intent, assumptions, scope or acceptance requires a lead decision
and a reviewed contract revision; no automatic later step/chunk is generated.

## 6. Document ownership and deferred-work reconciliation

| Artifact | Ownership in C16 |
| --- | --- |
| This plan and `pfr-c16-planning-notes.md` | Proposed/approved contract and planning evidence; status in the marked editorial region. No fictional approval. |
| `pfr-c16-coverage-audit.md` (proposed S01 artifact) | Exhaustive individual source ledger and extended dependency/interpretation crosswalk; no duplicated manuscript text. |
| `pfr-c16-readiness-audit.md` (proposed S02, completed S04) | Boundary/API/trust and criterion-to-evidence crosswalk; final cumulative readiness. |
| `pfr-c16-implementation-notes.md` (S01 onward) | Shared evidence entries/IDs, actual check commands/results, original review/closure references, applicability and limitations. Private records retain full evidence. |
| Living summary | Short current-state Quick Start linking preserved history; current coverage, active-plan pointer, decisions/risks, normalized deferred-work state and exact completion distinction. |
| Formalization map | Global allocation, DG status, dependencies and exhaustive internal omissions. Detailed final coverage links to the ledger. |
| Project log | Dated decisions, validation milestones, original suggestion provenance and full numbered Future Work Notes. |
| Roadmap, README and project scope | Direction, reader-facing status/build links and unchanged scope boundary. Formalization closure and release readiness remain separate. |
| Completed C01-C15 plans/notes and private records | Historical contracts and evidence; preserve original checkpoints. Prefer current summary/map overlays over rewriting frozen records. |

Initial disposition register (S01/S03/S04 reassess actual triggers):

| Original record / suggestion | Proposed C16 handling, owner and revisit trigger |
| --- | --- |
| All OM-001-071, map Sections 8-9 | S01 checks every row against source coverage and S04 retains every ID/rationale. OM-070 stays a historical duplicate of OM-024. Append justified new IDs; no silent deletion or public condensation. |
| C14/C15 broader wrapper; C16 allocation / OM-018 | S03 owns the proposed no-wrapper decision. Reopen only for a concrete approved consumer blocked by the existing case split; implementation needs revised approval. Solver execution stays separately excluded. |
| DG-15 and OM-020/026/027/033/042/069 | S03 final classifications; private fixture/proof coverage can be sufficient. A new public name requires demonstrated consumer pressure. |
| C12 plan Section 9 / OM-068 idempotence alias; later C13-C15 dispositions | Preserve the recorded decline and reassess actual C16 consumers. Existing extraction/injection bridges suffice at planning time; reopen only on demonstrated need. |
| C08/C11 private normalization/canonical helper promotion | Preserve prior no-promotion decisions; S03 checks consumer needs. Do not broaden NormalForm or CanonicalReachability merely for audit access. |
| C13 P01-P04 / GA01-GA03, C14 P01/GA01 through P05, C15 revision-2 P01-P03 / GA01-GA02 | S04 verifies implemented/declined dispositions against their planning notes and original review/advisory origins. Preserve signed guards, full inverse/image transport, private-helper audit distinctions and existing fixture ownership. Extra numerical/permutation fixtures remain declined unless a newly demonstrated gap requires one. |
| C16 revision-1 installed R01/R02, parent P01-P05 and supplied General Assistant GA01/GA02 | The [revision-2 dispositions](../pfr-c16-planning-notes.md#revision-2-selection-and-dispositions--2026-10-02) preserve every origin and decision. S01 owns shared evidence, S02/S05 inventory controls, S03/S05 import exclusions and refresh, and S04 the short Quick Start. Sections 1/4.2 clarify approval and the LP domain. Extra status machinery and a duplicate API table are not required; revisit only on the recorded S01/S03 design triggers. |
| C01 plan Section 8: reusable `isIndependentOf_comp_right` upstream candidate | Record current reuse/ownership in S03/S04; retain the separate library-maintenance/release-review trigger. No upstream work or dependency upgrade in C16. |
| OM-001-013/015/017-019/028-034/039/041 and roadmap deferrals | Reconcile cited external results, algorithms, Bell growth, general duality, extended-only claims and release/website work as excluded or separately deferred under existing owners. They do not become completion obligations. |
| Numbered Future Work Notes | The authoritative project-log register has none at planning time. Recheck at S01/S04/S05. New worthwhile unmapped advice gets a stable-numbered note with rationale/owner/trigger and normalized summary; do not manufacture notes for already mapped work. |

Optional advice of uncertain value may remain deferred with its question and
trigger. Correctness and required acceptance concerns cannot be deferred away.
Publication-facing curation may later condense material only with separate lead
approval and logged dispositions preserving mathematically meaningful rationale.

## 7. Validation and completion criteria

Build touched modules and important downstream consumers after coherent Lean
changes, and run `lake build` at milestones. At S02 and S05 enumerate the current
maintained Lean files using `rg --files PerfectFunctionalRepresentations -g '*.lean'`,
convert the paths to exact Lake module targets and build all of them, plus the
root. At planning there are 55 such files plus the root; this count is a baseline,
not a fixed exclusion list. A successful root/default build alone does not cover
separately imported matrix/optimization/test modules.

The full suite includes actual Matrix, Optimization, Examples and Tests modules,
with isolated consumers for the boundaries in S03. Derive any aggregate targets
from actual source/configuration. Retain commands, target inventory, outputs,
warnings, exit codes and whether cached dependencies were reused; a cached build
is not a clean rebuild. An unexecuted command is a duty, not evidence.

Require no matches from the exact scan:

```powershell
rg -n --glob '*.lean' '\b(sorry|admit|axiom|opaque|undefined)\b' `
  PerfectFunctionalRepresentations PerfectFunctionalRepresentations.lean
```

Run the Section 3 compiled declaration/axiom checks, verify focused pinned imports,
and inspect final diff, Git status, tracked generated artifacts, ignored manuscripts,
scratch and durable-record boundaries. Check documentation links and ID coverage.
Keep original failures and corrected attempts distinct. No cleanup touches inherited
work or `.pfr-review/`. Do not stage generated files, papers or evidence captures.

| ID | Completion requirement |
| --- | --- |
| CC01 | Exhaustive six-page numbered/prose coverage ledger, with no unclassified substantive claim and honest coverage modes. |
| CC02 | Version-bound extended dependencies, explicit printed/intended/Lean contracts and preserved material assumptions/repairs. |
| CC03 | C16-B01-B11 mathematical boundaries and all relevant regressions verified without weakened statements or hidden hypotheses. |
| CC04 | Complete declaration/assumption/axiom/placeholder audits and successful maintained-module, aggregate and default builds, with honest evidence attribution. |
| CC05 | Public API, generality, pinned reuse, test ownership and lightweight-root/import boundaries audited. |
| CC06 | DG-15 fully reconciled and broader-wrapper decision justified and recorded within approved scope. |
| CC07 | All omission rationale and advice/deferred-work histories retained, with owners/triggers; no unresolved required concern treated as optional. |
| CC08 | Owning documents and readiness crosswalk agree on formalization status, limitations and separate release boundary; the Quick Start gives concise current context and links to preserved history. |
| CC09 | Fresh independent cumulative validation, all original-report/finding reconciliation, applicable final evidence/F and supported durable closure. |

Formalization completion requires all nine criteria. Release readiness additionally
requires separately authorized metadata/rights/citation, publication and distribution
decisions and any chosen remote/release checks. C16 makes none of those claims.

## 8. Plan review and revision policy

Any further plan review requires an explicit request and uses the same persistent
reviewer in a fresh plan session bound to the exact revision. Earlier verdicts
retain their original source applicability. Review assesses these plan criteria:
**C16-PR01** complete source/interpretation scope; **C16-PR02** credible
boundary/trust methods and evidence provenance; **C16-PR03** API/import/DG-15 and
wrapper decisions; **C16-PR04** dependency-based steps, stable acceptance and
completion duties; **C16-PR05** omissions/deferred-work/document ownership;
**C16-PR06** independent cumulative closure and authority/revision boundaries.
Map each criterion to the exact normative sections and required evidence when
opening the authorized plan session; do not reduce it to a substring-only check.

Planning helpers and the parent's critical draft assessment are planning inputs,
not independent review or approval. Retain requested/effective reviewer settings,
originating-parent association, original creation result and all actual reports.
Use the existing installed protocol; do not recreate a reviewer or change bindings
to bypass an error.

After exact approval, preserve the frozen normative contract. The marked editorial
block is reserved only for status/chronology. Routine source routing, proof-check
methods, naming and evidence improvements may be documented within an authorized
step if they preserve intent, scope and acceptance and the installed contract.
Material changes, including a new wrapper, changed hypotheses, a new theorem
family or weaker completion criteria require a lead-approved revision and the
supported review procedure. Preserve prior reviewed versions and dispositions.
No step starts from roadmap/map inclusion, elapsed time or a reviewer suggestion.
