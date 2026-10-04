# PFR-C14 planning notes

**Current status, 2026-10-01:** [Revision 2](plans/pfr-c14-primal-characterization.md)
is approved and has passed fresh cumulative validation and independent review.
The complete report is reconciled without findings. Final applicability/F and
supported S04 closure establish completed status after this pre-F checkpoint.
The [implementation notes](pfr-c14-implementation-notes.md) own execution evidence.
Original draft-time records and suggestion dispositions below remain historical.
No independent plan review is claimed; C15 remains unstarted.

## C13 closure and current-source applicability

The parent ran the requested installed read-only `cli.py inspect` from the
checkout; its complete output is retained at
`.pfr-review/setup/c14-planning-20260930-inspect.json`. HEAD is
`54c1714d1a9a891939d6c9f7d38c0d05896b2c75`, with substantial inherited tracked
and untracked work. All installed dependency pins match the manifest and are
clean. LeanInfoTheory remains v0.1.0, Lean/mathlib v4.33.1.

Planning helper `/root/c14_context_audit` used the installed `ProjectRecordFS`,
`Store.get` and `Journal.load` interfaces read-only. C13 journal revision 194,
tip `65ab58eba8f74f9b80b9ea3a68873a9eb98c2455997d80d7df01b183adc0df92`, has all
six steps durably completed, all eighteen closing criteria SATISFIED and all
six original independent reports explicitly reconciled. No active step, pause,
cancellation, restriction, blocker or substantive decision obligation remains.
The three contextual findings are resolved; independent reports have no findings.

| C13 S06 record | Durable reference |
| --- | --- |
| Closure | `b722301a08704288a781de37208dc02ee9837a3070c7f6ca592eedd43e76abdf` |
| Final source F | `b6d6e42e131670c47c588463375166d785e9c8ae56729359881181afca3fab09` |
| Original cumulative report | `a70a73e3614562b89a404c3df4e10f9f961e13f654944b113903938e3ac4d96e` |
| Original-report reconciliation | `089ef9adaa9bc6955b5547c587c02d33f45186cfd2a1217bb116c8922aa89073` |
| Final PASS evidence | `ef7abfce32fa6466ee1928bfdc0c295fe05e9f4e0b4807268002d94e36cc4e78` |

Before canonical planning edits, two captures using `project_source.snapshot`
and the recorded explicit scope matched **153/153 entries**, without additions,
deletions or changed bytes; Git/environment facts matched too. The full attributed
audit is retained at
`.pfr-review/setup/c14-planning-20260930-c13-closure-audit.json`.
This establishes applicability of C13's closing source/evidence at startup;
it is not a fresh independent acceptance or exhaustive C13 trust audit.

C13 is complete. Its plan, implementation notes, readiness audit and log entry
159 intentionally retain the earlier pre-F checkpoint. Those records are not
rewritten or reopened. Current canonical summaries cite this later reconciliation.
Subsequent C14 documentation edits change that source snapshot, with their scope
explicitly recorded; C13's immutable closure still describes its original F.

## Persistent C14 reviewer

No C14 binding existed at startup. Before creation the parent retained the exact
user attachment and neutral bootstrap intent in
`.pfr-review/setup/c14-planning-20260930-bootstrap-intent.json`.
The native request used `model="gpt-6-astra"`, `reasoning_effort="ultra"`,
`fork_turns="none"`. Its complete returned result was
`{"task_name":"/root/pfr_c14_reviewer"}`.

The installed `project.bind` procedure created
`.pfr-review/chunks/PFR-C14/binding.json`, associated with actual originating
`CODEX_THREAD_ID` `01a0f3d9-7dad-7190-8587-fd641698aa29`, parent role `/root`, and
that exact canonical reviewer. Packet/result and the complete original bootstrap
acknowledgment are preserved under `.pfr-review/setup/c14-planning-20260930-*`.
The reviewer reported no repository inspection and awaits an exact source-bound
request. No context, findings or helper research was sent to it after bootstrap.

Requested settings are separate from unknown effective settings. Read-only
behavior is instruction-level, not OS isolation, under the accepted installed
procedure. No reviewer was transferred from another chunk or the diagnostic.
C14 has a binding only: no execution or plan-review session, no dispatched
independent review. The planning helpers are source/API research assistants,
not this reviewer or substitutes for independent plan review.

## Manuscript assessment and interpretation

The parent used the PDF skill, freshly checked both full hashes in plan Section
2, extracted local text and rendered ISIT p.5 and extended v16 pp.7,16,17 with
Poppler. Visual inspection checked Theorem 2/(18)/(64) and Appendix B
(203)-(221). Reading stops at the identified proof; adjoining dual, earlier
operation proofs and extended-only sections are not new coverage. The version
identities and exact source-page boundaries are recorded in the plan.

Ignored manuscript artifacts remain in `tmp/c14-planning/manuscript/`; no
manuscript binary, extract or page image is added to maintained files or private
review records. The ISIT display uses C13's already approved full/reduced repair;
C14 selects the reduced system. The extended proof supplies `P H`, `P v`, the
nonnegative slack argument and the attained optimizer interpretation.

The proposed theorem keeps greatestness and its membership witness explicit.
It neither assumes that an upper bound is attained nor needs a theorem asserting
optimizer existence for every nonperfect datum. To eliminate slack, each pattern
chooses a containing input; checking only one input would be insufficient.
Nonempty input is explicit, while admissible partitions may be empty. Zero is
always primal feasible. Total pattern values need not equal one.

## API discovery and bounded feasibility probes

The parent inspected the actual `Incidence`, `IncidenceConstruction` and
`PatternCompression` definitions, structural identities, equality normalization
and public semantic bridges. Planning helper `/root/c14_api_feasibility` searched
pinned LeanInfoTheory source and its public API contract, API documentation,
declaration index, theorem highlights and module guide, plus pinned mathlib
matrix/order sources. No new generic information-theory result or discoverability
friction was found; the discoverability log is unchanged.

Both final probes compiled with exit 0 and no warnings/errors. They are ignored
scratch, import supported public local modules, and contain no placeholders.
The parent inspected their complete source and the attributed results.

| Command | Verified interface or narrow proof | Limit |
| --- | --- | --- |
| `lake env lean tmp/c14-api-probes/Algebra.lean` | Actual C13/C12 bridge signatures; arbitrary-coefficient `P(Hw) = constant (sum w)`; every nonnegative slack coordinate vanishes when `P s = 0`; `IsGreatest` of an image iff explicit attainment under a supplied bound; ambient singular equality consumer. | Does not define the primal predicate or prove the full C14 bound, saturation iff or final characterization. |
| `lake env lean tmp/c14-api-probes/Reindex.lean` | Coordinatewise nonnegative inequality equivalence using `Incidence.reindex_mulVec`, and sum preservation using `cols.symm.sum_comp`; no nonempty-column premise. | Does not yet assemble the complete objective-value-set equality or prove maintained channel/primal wrappers. |

Exact probe outputs, exit results and source-discovery paths are retained in
`tmp/c14-api-probes/evidence.json`. No failed candidate compilation is reported
for these final probes. They verify a credible route, not an implementation or
formal independent review of the draft. Remaining work is the approved-step
assembly, finite-set presentation proof and concrete regression integration;
there is no presently identified proof-route blocker.

## Step choice, fixtures and critical draft pass

The draft proposes four steps: inequality interface/bound; saturation and the
data theorem; channel/presentation boundaries and integrated readiness; fresh
cumulative independent closeout. This follows actual dependencies and leaves
no unimplemented mathematical duty for the final validation step.

C13's private fixtures already cover singleton, empty admissible families,
non-unit total pattern mass and nonperfect data with all five admissible
partitions. C14 consumers belong beside them in their existing test owners,
without public fixture promotion or copied private definitions. The nonperfect
fixture also admits the concrete slack vector of objective `1/2` stated in R06.
No exact global optimum for that fixture is required. The separate all-row slack
guard prevents a vacuous regression that only checked one input.

The parent critically assessed the draft before handoff; this is not an
independent plan review. Retained critique and separate decisions are in
`tmp/c14-planning/draft-critique.json`. The concrete improvement makes both
existing test owners explicit, since singleton/empty/Option consumers are in
`Tests/Optimization/Incidence` and the numerical fixtures are in
`Tests/Examples/Incidence`. The proof interfaces, all-vector presentation duty,
and distinction between review-time readiness and later final closure are explicit.

DG-13's proposed resolution awaits exact-plan approval. The recommended scope
choice is to keep the broader nonsingular/singular convenience wrapper for
C16's scope assessment; the singular wrapper itself already covers inactive
ambient outputs. C15 retains all dual/separation obligations. Existing omission
IDs and earlier advice dispositions are preserved; no numbered Future Work Note
is needed. In particular, no new consumer revives the declined C12 idempotence
alias, C11 private-helper promotion or redundant extra C13 fixture.

## Revision-2 advisory decisions — 2026-10-01

After requesting the parent's suggestions and supplying the General Assistant's
advisory, the lead authorized choosing the best subset and updating the draft,
including the option to leave it unchanged. This authorizes a planning revision,
not exact-plan approval, implementation or an installed independent review.
The revision keeps the four steps, twelve step criteria, ten regressions and
eight completion criteria, with the same manuscript anchors and scope.

The exact revision-1 plan is preserved at
`.pfr-review/setup/c14-revision1-20260930-plan.md`, SHA-256
`b3784c60e7bc021da77121ca90aa80900de3d1de44bd454ab7bd1fdf9a33358e`.
Before editing, a source capture matched all 155 entries in revision 1's final
inventory; its environment, HEAD and index also matched. The capture and the
five maintained-document before-images are retained in
`tmp/c14-planning/revision2/`. Both advisory sources are separately preserved:

- Parent suggestions: `.pfr-review/setup/c14-revision2-20261001-parent-suggestions.md`.
- User-supplied General Assistant report: `.pfr-review/setup/c14-revision2-20261001-general-assistant-advisory.md`.

The second source is the report pasted by the lead; no native General Assistant
event or task identifier is inferred. Its reported checks and favorable verdict
remain attributed to that report. They are neither new parent executions nor
the installed C14 reviewer's assessment. That reviewer has not been contacted.

| Source ID | Advice | Decision, owner and check point |
| --- | --- | --- |
| P01 | Explicitly reject the signed objective-one equality solution. | Adopt within R06/S02. The negative last coordinate must fail `Primal.Feasible`; Hx = v and the sum alone do not suffice. Reassess in S04 with R06. |
| P02 | State the full finite-coordinate objective-value-set equality and inverse map; use asymmetric permutations, including a moved zero coordinate. | Adopt the precise set and inverse `z ∘ cols` in Section 4.4/S03 and R10. Replace the suggested two-fixture/zero-coordinate permutation recipe with GA02's existing single fixture, which distinguishes both directions numerically; R05 retains zero-coefficient saturation. The extra recipe is declined as redundant, not deferred. S04 reassesses the set theorem and R09/R10. |
| P03 | Prefer a shared private slack identity for the bound and saturation. | Adopt as the preferred route in Section 4.2/S01-S02. Its algebra works for arbitrary coefficients. A justified equivalent route remains allowed; no additional public theorem is required. S04 checks the resulting proof. |
| P04 | State exactly which singleton/zero/empty-family assertions belong to each step. | Adopt in R02-R04. S01 handles elementary feasibility, objectives, zero rejection and the empty objective set; S02 consumes the new saturation and perfectness characterizations. No step count or stable ID changes. |
| P05 | Preserve a C13-only import check after adding Primal to existing test owners. | Adopt a small disposable consumer for S03/S04, importing only `Optimization.IncidenceConstruction` and applying its structural/equality API. Avoid a new maintained test module or fixture refactor. |
| GA01 | Add the same signed-vector negative control within R06. | Adopt together with P01; this is one regression obligation with both sources retained. |
| GA02 | Use `(1,2,3,4,5)/40` and the existing asymmetric cycles; test a coordinate as well as the objective. | Adopt in R09/S03. Check both the transported coefficient and product at zero, plus feasibility/objective and existing greatestness transport. This replaces P02's extra permutation fixtures. S04 reassesses R09. |

The parent rechecked the source fixtures; planning helper
`/root/c14_api_feasibility` independently checked their indexing and exact
rational arithmetic as planning support. Existing `paper_mulVec` gives
`(9,8,7,2,3,4,1)/40`, objective `3/8`, and slack
`(1,2,3,8,7,6,9)/40` under constant value `1/4`. The inverse cycles give
coefficient `4/40` and product `8/40` at zero; forward cycles would give
`5/40` and `7/40`. The existing signed-solution and negative-coordinate facts
support R06. These are source/arithmetic checks, not new compiled C14 tests.
The original two compiling probes retain their stated limits.

Every selected suggestion is assigned above to an existing step/regression and
cumulative check. No uncertain suggestion is left unowned, no new omission is
introduced, and no numbered Future Work Note is needed. DG-13 stays open pending
approval; C15 and C16 retain their existing boundaries.

## Revision-1 validation and limits

Fresh parent planning builds passed:

- `lake build PerfectFunctionalRepresentations.Optimization.Incidence PerfectFunctionalRepresentations.Optimization.IncidenceConstruction PerfectFunctionalRepresentations.Tests.Optimization.Incidence PerfectFunctionalRepresentations.Tests.Examples.Incidence`
  — 2,781 jobs.
- `lake build` — 2,762 jobs.

Lake reused existing artifacts; these are fresh invocations, not clean rebuilds.
The earlier C13 final evidence is separately source-applicable historical
evidence, not relabeled as these parent checks. Final planning validation checks
all 50 maintained Lean hashes against the pre-edit inventory, document links,
stable criterion/step IDs, whitespace, placeholder absence, current pins, Git
status, generated/reference artifacts and the binding-only C14 store. Its
retained result is `tmp/c14-planning/final-validation.json`.

Only the draft, these notes and concise current-context/map/log updates are
maintained changes. Mathematical source, pins, tooling and C13 reviewed documents
are preserved. No commit, push, next step or review dispatch follows planning.

## Revision-2 validation and limits

The revision changes only the draft, these notes, the formalization map, the
living summary and project-log entry 161. Validation evidence is retained
separately at `tmp/c14-planning/revision2/final-validation.json`; revision 1's
evidence remains intact. Fresh `lake build` passed (2,762 jobs), as did the
placeholder scan, whitespace/local-link checks and final diff/status audit.
All 50 maintained Lean files, pins, HEAD and index are unchanged; the final
155-entry inventory differs only in the five named documents. Prior focused
builds and probe results remain
applicable to unchanged Lean source; no new C14 theorem or Lean test is claimed.
Builds use available artifacts rather than a clean rebuild. The C14 binding
remains initialization-only, with no execution or plan-review session.
