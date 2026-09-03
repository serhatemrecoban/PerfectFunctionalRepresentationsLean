# PerfectFunctionalRepresentationsLean Agent Instructions

This repository formalizes the six-page ISIT paper *On Perfect Functional
Representations* as a downstream case study of LeanInfoTheory. This file
contains stable operating rules. Use
[`docs/perfect-functional-representations-living-summary.md`](docs/perfect-functional-representations-living-summary.md)
for canonical project context, paper coverage, architecture, and current status.

## Required startup context

Before substantial planning or implementation:

1. Read this `AGENTS.md`.
2. Read Section 0, **AI Assistant Quick Start**, in the living summary.
3. Read only the living-summary sections relevant to the task.
4. Read `docs/formalization-map.md` when global coverage, chunk dependencies,
   or unresolved design gates matter.
5. Read the active approved plan when one exists.
6. Search relevant `docs/project-log.md` entries and Future Work Notes rather
   than reading the entire log indiscriminately.
7. Consult `docs/roadmap.md` when high-level direction or deferred phases
   matter; roadmap inclusion is not implementation approval.
8. Inspect the actual local Lean declarations, pinned dependency, and relevant
   builds before relying on documentation.

Small, direct tasks may use a proportionate subset, but no assistant should
guess current declarations, project status, or source meaning.

## Authority and conflict handling

Use the following seven reference points with judgment. Their numbering is a
navigation aid, not a universal precedence algorithm: first identify the kind
of question being answered, then weigh the sources that are competent to
answer it, including their recency, specificity, and verification state.

1. Local Lean source and successful builds determine current implementation
   facts.
2. Current explicit project-lead decisions and approved plans determine project
   intent and authorized execution contracts; the living summary records their
   normalized current status.
3. The exact six-page ISIT manuscript determines the in-scope mathematical
   content, interpreted under the documented manuscript protocol.
4. The current extended manuscript is the main proof and clarification
   companion for in-scope ISIT statements, but does not enlarge scope
   automatically.
5. The source and API contract of the pinned LeanInfoTheory release determine
   available dependency declarations; the pinned mathlib source determines
   available foundational declarations.
6. Git history and targeted project-log entries explain historical rationale.
7. GitHub determines relevant remote, CI, and publication state.

For example, a successful build can establish what the repository currently
implements but not what the paper intended, while a manuscript can establish
the intended mathematics but not the current Lean API. Report genuine
conflicts and explain the resolution or escalation. Do not follow the list
mechanically, silently choose the most convenient source, treat historical
prose as current implementation, or promote a proposal, roadmap item, or
Future Work Note to an approved plan.

## Scope and dependency

- The primary scope is the six-page ISIT paper. Use the extended manuscript
  actively for fuller proofs and clarification of terse or ambiguous ISIT
  passages. Extended-only sections, claims, and applications require separate
  approval.
- Treat mathlib as the foundational Lean library and the pinned
  LeanInfoTheory release as this project's primary information-theory library.
  Reuse both before creating project-local alternatives.
- Keep paper-specific definitions, constructions, matrix operations, and
  characterizations in this repository.
- Record a result for possible LeanInfoTheory upstreaming only when it is
  genuinely reusable beyond this paper and fits the library's architecture.
- Depend on immutable LeanInfoTheory `v0.1.0`. Do not switch to `master`, a
  mutable ref, or a local path without explicit approval.
- Treat every LeanInfoTheory upgrade as a dedicated, reviewed, fully validated
  project step. Verify names against the pinned release, not current upstream
  development.

## Manuscript interpretation

- Both manuscripts are written for mathematically informed human readers.
  They may suppress routine hypotheses, use effective rather than literal
  coordinate counts, or choose concise notation whose intended meaning is
  clearer than its most literal formal reading.
- Distinguish the printed formulation, the mathematically intended claim, and
  the precise Lean contract. Preserve the intended theorem rather than
  formalizing a knowingly defective literal reading, but never make that
  interpretation silently.
- Record material implicit assumptions, indexing repairs, representation
  choices, and source departures. When practical, state or prove the bridge
  between a paper-facing formulation and the technically convenient Lean
  formulation.
- If plausible interpretations change the mathematical content, assumptions,
  or claimed strength, stop and ask the project lead instead of guessing.
- The extended manuscript may evolve before publication or archival release.
  When an argument depends on it, identify the consulted version sufficiently
  for later revalidation and recheck affected contracts after an update.

## Stable mathematical conventions

- Reuse mathlib `PMF` and LeanInfoTheory's channel convention
  `alpha -> PMF beta`; do not create a parallel probability theory.
- Reuse LeanInfoTheory's `Real`-valued entropy and information measures in
  nats. Base conversion is opt-in and does not justify a duplicate theorem
  hierarchy.
- Define random-variable quantities through pushforward laws. Lean product
  types are right-associated.
- Keep support-sensitive claims support-aware. Do not hide a full-support
  assumption in a statement intended to depend only on a channel.
- Treat null conditional fibers explicitly and preserve LeanInfoTheory's
  documented total-channel conventions.
- Prefer arbitrary finite alphabets for semantic statements when practical;
  introduce `Fin k`, matrices, or enumerations at the paper's matrix boundary.
- Prefer `[Fintype alpha]` when exposing finite enumeration and `[Finite alpha]`
  when finiteness is only internal.

## Architecture and API rules

- Put project-owned declarations in namespace
  `PerfectFunctionalRepresentations`. Extend `PMF` only for a genuinely
  reusable PMF construction whose ownership is clear.
- Keep `PerfectFunctionalRepresentations.lean` a lightweight mathematical
  root. Keep heavy matrix, optimization, demonstration, and reference modules
  separately importable.
- Separate semantic functional-representation and channel statements from
  finite-coordinate matrix encodings and optimization consequences.
- Before proving a new information-theoretic lemma or creating a local
  alternative, search the installed pinned LeanInfoTheory dependency, its
  generated public API inventory, declaration index, module guide and relevant
  examples, and the pinned mathlib source. Verify every candidate declaration
  with focused imports and Lean (`#check`, `#print`, or a compiling probe).
- Treat LeanInfoTheory examples and non-stable internals as discovery and
  reference material only. Maintained PFR modules should depend on supported
  public imports and declarations unless a separately reviewed need justifies
  otherwise.
- For discovery, a disposable probe may import a broader umbrella such as
  `LeanInfoTheory.Shannon`; production modules must retain the lightest
  justified focused imports. External mathlib search services must not be
  assumed to index LeanInfoTheory-specific declarations.
- Do not recreate an existing LeanInfoTheory construction or theorem merely
  because its name was initially difficult to find.
- Keep one-off proof machinery private or local. Promote helpers, aliases,
  bundled structures, and symmetric variants only after real proof or consumer
  pressure.
- Do not silently change a paper statement to fit a convenient representation.
  Record representation lemmas at explicit boundaries.
- Preserve useful generality without turning this case study into a second
  general-purpose information-theory library.

## Proof integrity

- Do not introduce `sorry`, `admit`, an unapproved `axiom`, `opaque`,
  `undefined`, or an equivalent proof placeholder.
- Do not silently weaken a target theorem or strengthen assumptions merely to
  make a proof compile.
- Do not present an invented or remembered declaration name as verified.
- Report assumptions, edge cases, source departures, and representation
  choices explicitly, especially support, zero-probability symbols, empty or
  singleton alphabets, coordinate orientation, and probability-to-real
  conversions.
- After each coherent Lean change, build the touched module and important
  downstream aggregates. Audit new public declarations and imports before
  reporting completion.

## Chunk workflow

- A formalization map may propose dependency order and chunk boundaries, but it
  does not by itself authorize theorem implementation.
- `docs/formalization-map.md` is the canonical adaptable global allocation.
  Keep its source coverage, stable chunk identifiers, dependencies, decision
  gates, and internal omission register current as proofs change what later
  work needs.
- A new theorem-development chunk requires a project-lead-approved plan. Store
  actual approved, completed, or superseded chunk contracts under
  `docs/plans/`; do not create a fictional active plan merely to reserve a
  filename.
- A chunk plan must record its status and baseline, exact manuscript anchors,
  prerequisites, scope and non-goals, mathematical and representation
  contracts, verified mathlib/LeanInfoTheory reuse, module/API ownership,
  stable step identifiers, edge cases, validation duties, completion criteria,
  documentation consequences, and revision policy.
- Each implementation prompt addresses one approved step. Complete and
  validate that step, report it, and stop.
- Do not begin a later step automatically.
- If a discovery invalidates later steps, stop for a plan-health review.
- Record deferred ideas without pulling them into the active step.
- During initial planning, record every intentional omission from the reviewed
  manuscript anchors in the map's internal omission register, including cited
  results, proof-only prose, fixtures not intended as public API, technically
  misleading literal readings, and extended-only material. Do not wait until
  publication review to reconstruct these decisions.
- A later publication-facing curation may condense or archive minor omission
  records only with project-lead approval and a logged disposition. It must
  retain mathematically meaningful omissions and must not silently erase
  rationale.
- Chunk completion requires an independent validation pass against its
  completion criteria.

## Document roles and proactive maintenance

- `README.md` is the reader entry point: project purpose, honest project status,
  basic build instructions, and links to maintained documents.
- This `AGENTS.md` owns how assistants work: stable operating rules,
  conventions, validation duties, and document-maintenance routing.
- `docs/project-scope.md` owns what belongs in the project: manuscript,
  library, dependency-version, and publication boundaries.
- `docs/perfect-functional-representations-living-summary.md` owns where the
  project stands: canonical cross-thread context, current coverage, decisions,
  risks, active-plan pointer, and a normalized view of Future Work Notes.
- `docs/project-log.md` owns what happened and why: chronological decisions,
  implementation and validation milestones, rejected alternatives, and the
  authoritative detailed stable-numbered Future Work Notes.
- `docs/roadmap.md` owns where the project may go at a reader-facing,
  high-level granularity. It is directional and non-authorizing.
- `docs/formalization-map.md` owns the current global source allocation,
  dependency-aware candidate chunks, cross-chunk decision gates, and internal
  omission/disposition register. It is adaptable and non-authorizing.
- Future files under `docs/plans/` own what the project lead has explicitly
  approved for execution. A plan is authoritative only for its stated scope
  and status.
- Ignored reports under `tmp/codex-handoffs/` transfer context temporarily;
  they are not canonical records.

Any project thread must update the owning canonical documents in the same
coherent change whenever its work materially changes project state, coverage,
decisions, risks, map dependencies or omission dispositions, approved plans,
validation evidence, roadmap direction, or a Future Work Note. Do this
proactively without waiting for a separate reminder. Avoid documentation churn
for trivial helper work and avoid copying detailed content into multiple
owners; use links and short normalized summaries.

Future Work Notes use immutable numbers. The project log owns each note's full
rationale, trigger, history, and disposition; the living summary owns its
current normalized classification. Active or standing notes do not authorize
implementation, and completed, superseded, or obsolete notes remain available
for stable historical references.

The living summary is shared canonical context: any project thread may edit it
when its work materially changes that context, and the project lead remains the
decision authority. Reconcile such edits against relevant source, builds,
approved plans, log entries, manuscripts, and Git history. The General
Assistant performs periodic cross-thread reconciliation but is neither the
exclusive editor nor an approval gate.

## Targeted source reading

- Begin with the living-summary quick start, the relevant formalization-map
  chunk, and the active plan.
- Inspect the relevant local module, dependency closure, and pinned upstream
  declarations.
- Search targeted project-log entries and active future-work items.
- Read the exact relevant ISIT section and the needed part of the current
  extended proof/clarification companion. Do not read unrelated extended-only
  sections merely for completeness.
- Consult Git history when provenance or rejected alternatives matter.
- Apart from pinned dependencies, do not consult or reuse external
  information-theory formalization repositories unless the project lead
  explicitly requests it. Record the source and required attribution if
  external implementation code is consulted or reused.
- Avoid loading unrelated repositories, references, logs, or websites merely
  for completeness.

## Validation

- During iteration, run `lake build <Touched.Module>` and its important
  downstream aggregate.
- Before a commit or milestone, run `lake build`.
- Require this placeholder scan to return no matches:

```powershell
rg -n --glob '*.lean' '\b(sorry|admit|axiom|opaque|undefined)\b' `
  PerfectFunctionalRepresentations PerfectFunctionalRepresentations.lean
```

- Inspect the final diff, Git status, tracked generated files, ignored
  references, and temporary artifacts before committing or reporting.

## Local references and provenance

- Local paper copies, textbooks, and working references may be consulted but
  must not be committed or reproduced.
- Cite the exact paper section supporting a formalization contract and note
  when an extended-version proof or clarification supplements an ISIT
  statement. Record enough version identity to revisit extended-manuscript
  dependencies after an update.
- Do not guess authorship, rights-holder, affiliation, publication, DOI, or
  source-header metadata. The project lead must verify release metadata.
