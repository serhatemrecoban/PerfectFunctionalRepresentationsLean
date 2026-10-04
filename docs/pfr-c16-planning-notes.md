# PFR-C16 planning notes

**Current — 2026-10-02:** [C16 revision 2](plans/pfr-c16-coverage-api-trust-closure.md)
is **Approved; S01 unstarted**, following the lead's endorsement and explicit
instruction not to start implementation yet.
It adopts seven refinements from the revision-1 installed review, parent assessment
and supplied General Assistant advice. The revision-1 original, six satisfied
planning criteria, two optional findings and reconciliation remain preserved;
no separate revision-2 independent review is claimed. The exact contract is
approved; no execution step, mathematical change, commit or push has begun.
Earlier checkpoints remain below; the final section records approval and guidance.

## Baseline and C15 prerequisite verification

Startup HEAD is `54c1714d1a9a891939d6c9f7d38c0d05896b2c75`. Its nine tracked
changes and 142 nonignored untracked files predate C16. The exact status and
read-only `python -B tools/pfr_review/cli.py inspect` output are retained under
`.pfr-review/setup/c16-planning-20261002-baseline-git.json` and
`c16-planning-20261002-inspect.json`. All installed packages are clean and match
their locks; LeanInfoTheory remains `v0.1.0` and Lean/mathlib remain `v4.33.1`.

The read-only planning helper `/root/c16_prerequisite_check` used the installed
integrity-checking `ProjectRecordFS`, `Store.get`, `Journal.load` and source
snapshot adapter. Its actual script and receipt are in ignored
`tmp/c16-planning/prerequisite-check/`; the parent inspected those records and
the relevant source. The durable C15 journal is revision 188, tip
`097d4c1445832bd64a71713a816e1fbf0b093ee2d8ae90a858360a73e3546e30`.

| Record | Identity / observation |
| --- | --- |
| Supported S05 closure | `473fbfaa8cffa154fa1011e65f719c113eae30d4dd722dfae25ff302ee691c5c` |
| Final F | `dcdbe6434aafa45dd8df7e8b730ec2515c06b5eda581c61dfe1d2c83c603d5cf` |
| Independent R | `b34b728b628d3f67c55013da07c5c1aaeecbaa55c3b37fa4e7f762db90cd9131` |
| Original S05 report | `e5cb2a3a653fc3a986e2bfa2ae473f6d6cc65e4daf1159c0bd1287ea4113eb7e` |
| Original report text SHA-256 | `3ea9ea45bbd0ad33b76d3a8bcee99efe0ef9eb4cbf7c0e7b1ce52fe0ac48dd9d` |
| S05 reconciliation | `431d5aa0c933406b49e385bfbb0cd31658a295d26e7418b13a4c70332eb2953b` |

All five steps are closed with no active step. All fifteen closing criteria and
their matching independent assessments are SATISFIED; all five VALID original
reports have explicit exact-source reconciliations. Four historical findings
are RESOLVED. No pause, cancellation, restriction, blocker, decision obligation
or escalation remains. This supported closure establishes CC09/C15 completion.

Before parent planning edits, two fresh same-scope comparisons found all 174
final source/environment entries identical, without additions/deletions, and all
Git fields equal. Distinguish C15's historical R-to-F change of ten owning Markdown
files from this zero-difference startup F-to-current comparison. Subsequent C16
draft/status edits are new documentation changes; they do not alter Lean, pins,
the C15 plan/notes or private original evidence. Final planning checks compare
that bounded delta explicitly.

The maintained C15 plan, readiness audit and implementation notes intentionally
retain the pre-F checkpoint. They were inspected, including their full cumulative
validation account and late generated-constant correction. They are preserved;
current summary/map pointers identify the later durable completion. C01-C14 are
accepted completed prerequisites, subject to concrete discrepancies, without
reopening their development or fabricating fresh historical review.

The different-parent session loader correctly refused `WRONG_ORIGINATING_PARENT`
during the helper's exploration. Read-only record interfaces then provided access
without changing identity, environment or records. Exploratory schema-key/path
failures are retained in the receipt; none establishes a prerequisite defect.
This is bounded applicability verification, not fresh cumulative proof review.

## Persistent reviewer setup

No C16 binding existed. Before native creation the parent saved the exact user
attachment, actual parent identity, requested profile and neutral bootstrap in
`.pfr-review/setup/c16-planning-20261002-bootstrap-intent.json`.

- Originating `CODEX_THREAD_ID`: `01a0fd72-febb-7d03-ae0c-9e8ee42d78bf`;
  recipient role `/root` is recorded separately.
- Requested native settings: `model="gpt-6-astra"`,
  `reasoning_effort="ultra"`, `fork_turns="none"`.
- Complete actual creation result: `{"task_name":"/root/pfr_c16_reviewer"}`.
- Installed `bind` succeeded; actual binding is
  `.pfr-review/chunks/PFR-C16/binding.json`. Exact creation result and binding
  packet/result remain under `.pfr-review/setup/c16-planning-20261002-*`.

The reviewer received only neutral initialization instructions: wait for explicit
source-bound authorization, read-only review, no edits/delegation/unrelated access.
It received no implementation history, self-review conclusions or expected defects.
Both original native initialization events are preserved in `bootstrap-events.json`
under the same setup prefix. The reviewer acknowledged initialization and waits.

Requested settings are distinct from unknown effective settings. Read-only behavior
is instructed, not OS isolation. No other chunk's or diagnostic reviewer was
transferred. No plan or execution session was opened and no review was dispatched.
The two planning helpers are research assistance, not independent plan reviewers.

## Bounded source, manuscript and API checks

The parent inspected AGENTS, the living-summary quick start and relevant scope,
coverage, risk, dependency, current-work and provenance sections; map C16,
DG-14/15, source allocation and omission headings; roadmap; installed protocol
and operations; C15 approved plan/readiness/implementation/planning records;
targeted recent log entries and the authoritative Future Work Notes register.
The register contains no numbered notes. Earlier advice/deferrals were traced
to their existing owners; no new unowned deferral or omission is introduced.

Both original manuscript hashes freshly match the identities in plan Section 2.
Using the PDF skill, the parent extracted selected ISIT pages 1/4/5/6 and extended
p.7, freshly rendered and viewed complete ISIT p.5 and extended p.7. The ISIT page
confirms the singularity-before-LP paragraph, both LP statements, variable-count
prose and Appendix/Figure 1 context. The extended page distinguishes (65)-(67)
from the adjacent excluded complexity discussion. Remaining dependency anchors
come from completed plans and await C16-S01's complete source reconciliation.
Local identities/extracts/renders remain ignored in `tmp/c16-planning/manuscript/`;
no manuscript media or raw extracts are copied into durable review records.

The helper `/root/c16_api_planning` and parent inspected actual singularity,
compression, incidence, primal and dual source, relevant test owners and root
imports. The helper's disposable
`tmp/c16-api-planning-agent/ExistingComposition.lean` compiled with exit 0:

```text
lake env lean tmp/c16-api-planning-agent/ExistingComposition.lean
```

It checks four existing endpoint signatures, nonsingular exclusion with only
nonempty input, and an anonymous dependent-existential combination of the ambient
primal and dual iff statements. Both ambient iff axiom checks return only
`propext`, `Classical.choice`, `Quot.sound`. This is helper-executed feasibility
evidence, not a parent rerun, public declaration or comprehensive trust audit.
An accidentally duplicated invocation was stopped; only the tracked completed
invocation supports the PASS. Source/probe evidence is retained separately.

**Wrapper recommendation:** add none. The singularity proof is already an explicit
input to compressed data, the two singular iff statements cover inactive ambient
outputs, and nonsingular rejection is immediate from necessity. No blocked consumer
was identified. The combined statement is feasible but adds dependent packaging
and import ownership without new mathematical coverage. S03 reassesses the decision
against the final ledger; a newly justified implementation would need a precise
approved revision. Existing OM-018/C16 ownership supplies its revisit trigger.

No generic replacement is proposed. Existing dependency reuse was inspected through
current source and C15's applicable recorded search; this planning pass does not
claim a new exhaustive LeanInfoTheory/mathlib search. The plan explicitly requires
the pinned source/API/index/highlights/module-guide search and a compiling candidate
probe before any generic replacement is proposed during execution.

## Critical draft assessment and resulting refinements

The parent reviewed the draft against the actual request before delivery:

- Source completeness must be established by a page/paragraph sweep and individual
  numbered/prose rows, not inferred from the map's grouped coverage table.
- Coverage, boundary/trust evidence, API decisions, documentation integration and
  final independent validation are five distinct dependent outputs; no arbitrary
  step-count target determined them.
- Default build alone is insufficient for separately imported modules. The plan
  requires an actual maintained-module inventory (currently 55 files plus root)
  and explicit builds, without inventing an Optimization aggregate.
- C15's generated constant outside the initial name filter makes whole-owner
  declaration reconciliation mandatory. Anonymous-copy attribution remains separate.
- The final reviewer must freshly assess the whole contract, with closure acts
  explicitly future at review time. Earlier reports cannot substitute for this.
- Frozen earlier records stay unchanged; current summary/map overlays carry the
  later completion. The draft was tightened to remove wording that might permit
  rewriting a frozen record merely because a snapshot existed.
- No-wrapper is a proposed default, not implemented mathematics or automatic
  permission for a different wrapper. Material discoveries require scoped approval.
- Internal omissions and optional advice keep original references and owners;
  publication curation and release readiness remain separate.

These are parent planning judgments, not an independent review report. No substantive
mathematical ambiguity requiring an immediate lead decision was found. Later exact
plan approval, including its no-wrapper default and acceptance contract, is required;
independent plan review must first be explicitly requested if desired.

## Planning validation and stopping point

The parent freshly ran `lake build`: exit 0, **2,762 jobs**, using cached dependencies.
No maintained Lean source changed. The literal placeholder scan, document/link/ID
checks, final diff/status and exact source/configuration preservation checks are
recorded in the final planning receipt. Successful planning checks do not establish
C16 execution acceptance or a full manuscript/declaration audit.

Private setup captures and planning receipts preserve actual results and limits;
ignored scratch remains separate from durable `.pfr-review/`. No commits, pushes,
dependency/workflow changes, public release, website work, approved execution
session or independent review dispatch occurred. The reviewer remains available
for the lead's later explicit request. Stop with this proposed plan.

## Revision-1 plan review and proposed improvements — 2026-10-02

The lead requested a review and suggestions, expressly stating: "Dont update the
plan yet." The parent used the existing bound reviewer and the installed PLAN
session `plan-r1-20261002`; no execution session or step was opened. The unchanged
plan SHA-256 is
`a71c0b63b3804f646f48fed14b72f5a21dedf2406f05314357d8a3e4bf60ce53`.
Its status block remains the earlier planning checkpoint at the lead's request;
this section and current status summaries record the subsequent review.

The full original native report, evidence and event envelope were preserved before
classification. The installed procedure classified the report VALID and retained
the parent's critical reconciliation:

- Reviewed source: `db309fc33e8fb4b5cc04747a5b4dfa02ca605b4b5a7b99ae9bdd9fb3642a2caa`.
- Original-report observation: `c6b4c3321070bb4b7040fc7b398fa32610013c77a8f59757a512e44883853ab8`.
- Classified report: `c6774a66ac4dde13ce68167140a8e8b418b7cb1232ca5eeefffed68f1c57b1d3`.
- Parent reconciliation: `6db24a925976b110c8d5b23e5030894a238e5e12003d992744b3281ac069fe55`.
- Original report text SHA-256: `3fcbcc362b170d4a6997cc3ffa0fbdd668c27087f59a66471c97506836377222`.

All six PR01-PR06 assessments are SATISFIED at the planning level. The parent agrees
that the five-step structure, complete manuscript-accounting duties, no-wrapper
default and fresh cumulative validation are appropriate. No material plan defect
was found. This assessment does not establish C16 execution acceptance or replace
the future full source, declaration, import and trust audits.

### Independent checks and limits

The reviewer verified all 168 real files in the request inventory with no hash
mismatch, checked the designated manuscripts' hashes/page counts and visually
inspected ISIT p.5 and extended v16 p.7. Selected actual source/API/fixture inspection,
a stdin composition/signature/selected-axiom probe, and focused root,
DualCharacterization and BinaryRoot builds passed; the cached build reported
2,787 jobs. These are reviewer-executed checks, not parent reruns. The reviewer did
not reconstruct the virtual environment digest, repeat C15's full historical audit
or perform C16's complete coverage/trust work.

The generated-declaration diagnostic found that `Dual.Feasible.eq_1` resolves with
`#check` and `#print axioms` while the tested `Environment.contains` query is false;
ordinary declaration controls are true. This establishes a limitation of that
simple membership test. It does not establish the precise realization mechanism
or owner, or invalidate C15's attributed historical evidence. S02 already requires
a stronger reconciliation and owns that investigation.

An initial LF-to-CRLF conversion in the request transport file caused the reviewer
to pause on a hash mismatch before source inspection. The parent preserved the
original bytes, verified exact equality after line-ending normalization, restored
the original UTF-8 bytes and continued the same request. The reviewer independently
verified the corrected hash. The empty native dispatch result was recorded as
uncertain; the actual final report supplied supported delivery confirmation. No
request was resent and no negative observation was erased. One preliminary reviewer
diagnostic lacked retained completion output; its complete rerun alone supports the
reported result. Private originals and detailed limits remain in `.pfr-review/`.

### Suggestion dispositions pending the lead's decision

These recommendations do not amend the plan. Each has an existing C16 owner;
no duplicate numbered Future Work Note or automatic implementation is created.
R01 is original finding
`pfr-finding:c16-plan-r1-generated-inventory-controls-20261002`; R02 is
`pfr-finding:c16-plan-r1-explicit-import-exclusions-20261002`. P01-P05 refer to the
parent's preserved assessment made before receiving the independent report.

| Original suggestion | Parent assessment | Existing owner and revisit trigger |
| --- | --- | --- |
| R01: generated-inventory diagnostic controls | Recommend retaining a small completeness diagnostic alongside the audit method, with lookup/enumeration differences explained. Keep it private; no public helper or workflow change. | Section 3.2, S02-B and S05-B; revisit when a revision is authorized or S02 selects its audit method. |
| R02: explicit import exclusions | Recommend naming expected absent project modules as well as available declarations. Check actual import closure; a positive consumer alone does not establish absence. Do not split fixtures or exclude needed mathlib geometry by default. | Section 4, S03-A and S05-B; revisit when a revision is authorized or the import matrix is designed. |
| P01: shared evidence IDs | Recommend recording actor, command, source/configuration identity, result and limits once, with links from coverage/readiness rows. | Section 2.2, S01-A, Section 3.2 and S04-C; revisit on authorized revision or ledger design. |
| P02: refresh after API changes | Recommend making affected signature, ownership/axiom, import-consumer and coverage-link rechecks explicit before S04. The general obligation already exists. | S03-C/S04-C; revisit on authorized revision and whenever S03 changes audited source. |
| P03: approval wording | Recommend clarifying approval of an exact revision versus the separate request needed for each step. Material contract revisions still require approval. | Sections 1/8; revisit on a lead-authorized plan revision. |
| P04: coverage versus verification status | Retain the distinction as a useful ledger-design question; do not adopt the tentative status vocabulary wholesale. S01 must still establish source correspondence and S04 cannot leave required checks pending. | S01-A/S04-C; revisit at ledger design, without a parallel status table. |
| P05: reverse public-API correspondence | Existing complete-public-surface disposition already covers checking each public declaration's paper or supporting role. No additional exhaustive table or plan amendment is currently recommended. | S03-A; revisit if the actual public inventory contains unexplained declarations. |

Only review records and concise current-status documentation are updated after
reconciliation. The plan, Lean sources, dependencies, earlier plans and review tools
remain unchanged. The supported result awaits explicit lead approval and authorizes
no execution; any plan revision remains pending the lead's instruction.

## Revision-2 selection and dispositions — 2026-10-02

The lead authorized choosing and applying a useful subset of the suggestions.
Revision 2 retains the five dependent steps, their fifteen stable acceptance IDs,
all nine completion IDs, exact manuscript boundaries and proposed no-wrapper
default. It adds concrete evidence and navigation duties without new theorem
scope or a new execution step. The revision-1 reviewed source preserves the exact
original plan, SHA-256
`a71c0b63b3804f646f48fed14b72f5a21dedf2406f05314357d8a3e4bf60ce53`;
the parent verified byte equality before revision. Original reviews, private
session/binding records and earlier contracts are unchanged. The prior installed
verdict applies to revision 1; this revision request does not dispatch another
independent review or approve execution.

### Advisory origin and factual checks

The lead supplied the General Assistant's "Independent advisory review — PFR-C16"
in this chat. Its two suggestions are labelled **GA01** (short Quick Start) and
**GA02** (finite nonempty LP domain) here for stable reference. The supplied
text is retained at `.pfr-review/setup/c16-revision2-20261002-advisory.txt` with its
original revision-1 line references. It reports no blocking issue, a 2,786-job
cached build, composition/axiom checks and clean pins/hygiene. Those are
advisory-reported checks; the parent did not relabel them as its own results or
as the installed reviewer's report.

Fresh source reading confirms the LP endpoints' `[Fintype α] [Nonempty α]
[Finite β]` domain and the weaker nonempty-only necessity theorem. The Quick Start
occupies lines 26-846 before this revision's small status update, confirming the
navigation problem. Its actual restructuring belongs to S04; this planning turn
only specifies the outcome. Read-only helper `/root/c16_api_planning` inspected
the relevant plan/source/imports and earlier probe evidence. It confirms that
Dual deliberately imports Primal and Primal imports IncidenceConstruction; these
dependencies must remain allowed. It ran no new probe/build and did not invoke
the installed review workflow.

### Selection and rationale

R01/R02 and P01-P05 retain the origins identified in the revision-1 review section.
The seven main recommendations are adopted as contract refinements. The two
lesser parent ideas remain covered by existing duties without extra structures.

| Suggestion | Revision-2 decision and reason | Owning duty / future trigger |
| --- | --- | --- |
| R01: inventory-method controls | Adopt. Require retained controls and explained lookup/enumeration differences. Controls supplement full project-owner reconciliation; no fixed declaration count or exhaustive dependency inventory. | Section 3.2, S02-B/S05-B; select and rerun controls during those steps. |
| R02: expected import exclusions | Adopt. The small matrix makes absence checks reviewable while preserving intended layer dependencies. Shared test fixtures cannot establish isolated production boundaries. | Section 4, S03-A/S05-B; derive exact module names from the current inventory. |
| P01: shared evidence IDs | Adopt within the existing implementation notes from S01 onward. Coverage/readiness rows reference one source of evidence metadata; originals and later checks remain distinct. No new registry tool or document. | Section 2.2 and Section 6; S01 establishes entries, later steps extend them. |
| P02: refresh after API changes | Adopt before S03 closes. Refresh affected checks and justify retained evidence; append to original S02 records. Documentation-only changes need an impact assessment, not an automatic complete mathematical rerun. | S03-C/S04-C; any actual source/import change triggers revalidation; S05 retains the full fresh pass. |
| P03: approval wording | Adopt. Distinguish approval of an exact revision from the separate eligible request for each step. Material contract revisions still need approval. | Sections 1/8; applies to later authorization and revision. |
| GA01: short Quick Start | Adopt as an explicit S04-A/CC08 outcome. Keep current state, decisions, plan pointer, limitations and reading routes. Link preserved history and retain unique context before removing duplicate navigation prose. No arbitrary word-count gate or omission curation. | S04-A and living-summary ownership; implementation waits for that authorized step. |
| GA02: qualify full case split | Adopt. State the exact finite/nonempty LP domain while preserving the necessity theorem's more general contract. This corrects prose without changing mathematics. | Section 4.2; B04/S03 verify domain consistency during execution. |
| P04: extra coverage-status vocabulary | Do not add a prescribed status system or parallel table. Existing coverage modes, evidence provenance and unresolved-issue fields already distinguish correspondence from completed checks. | S01-A/S04-C; reconsider only if actual ledger rows remain ambiguous, without weakening S01 or leaving required checks pending at S04. |
| P05: duplicate reverse-API table | Do not add another exhaustive table. Existing S03-A public-surface disposition already requires a paper/consumer/supporting role. | S03-A; investigate any actual unmatched public declaration and record its disposition there. |

Every suggestion has an existing owner and trigger; no numbered Future Work Note
is opened. Only the draft and owning status/planning documents change. The scope,
assumptions and acceptance strength of prior mathematics, all omission IDs/rationale,
dependency pins and review tools are preserved. Validation receipts retain the
actual build, source-preservation, ID/link and hygiene results with their limits.

The parent freshly ran `lake build`: exit 0, 2,762 jobs with cached dependencies.
This validates the default target against unchanged Lean sources, not the future
all-module C16 suite. Final checks compare exact current files with the revision
baseline, verify stable IDs and document links, and inspect placeholders, whitespace,
tracked generated artifacts and ignored scratch boundaries.

## Revision-2 approval and readiness for S01 — 2026-10-02

The lead endorsed revision 2 and emphasized that plans and procedures serve sound
judgment. During an authorized step, improve methods, organization and plan details
when evidence warrants; document the reason, preserve original reviewed records and
ensure review covers the actual resulting work. AGENTS.md's chunk workflow already
provides this discretion. Substantive mathematical-intent, scope or acceptance
decisions still belong to the lead. No normative rewrite or workflow change is needed.

The user expressly said not to start implementation yet. Approval therefore covers
the exact revision-2 contract, while S01 awaits its own request. The approved draft
SHA-256 is `8d5a5d0c6a03c66ea5aaaeb4bf394ee0aa5ac50060f93ae3a494ebdb49e15dcb`.
The actual user message and exact pre-status plan bytes are preserved in
`.pfr-review/setup/c16-approval-20261002-user.json`. Only the plan's marked editorial
block changes; its normative content, fifteen step criteria and nine completion
criteria remain unchanged. Earlier source/review records and the existing reviewer
binding remain preserved; no separate revision-2 independent review is claimed.

C01-C15 prerequisites are verified, the S01 source/interpretation contract and
evidence owners are defined, and the persistent reviewer is available. The parent
is ready for a separate S01 request. No execution session, source sweep, coverage
ledger, proof change or S04 Quick Start restructuring is started by this approval.
