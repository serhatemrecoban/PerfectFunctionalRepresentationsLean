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
4. Read the active approved plan when one exists.
5. Search relevant `docs/project-log.md` entries rather than reading the
   entire log indiscriminately.
6. Inspect the actual local Lean declarations, pinned dependency, and relevant
   builds before relying on documentation.

## Authority and conflict handling

Use the following source order:

1. Local Lean source and successful builds determine current implementation
   facts.
2. Approved plans and the living summary determine current project intent and
   status.
3. The exact six-page ISIT manuscript determines the target mathematical
   statements, subject to documented project conventions.
4. The extended manuscript may supply omitted proof details, but does not
   enlarge scope automatically.
5. The source and API contract of the pinned LeanInfoTheory release determine
   available upstream declarations.
6. Git history and targeted project-log entries explain historical rationale.
7. GitHub determines relevant remote, CI, and publication state.

Report conflicts explicitly. Do not silently choose one source, treat
historical prose as current implementation, or promote a proposal to an
approved plan.

## Scope and dependency

- The primary target is the six-page ISIT paper. Extended-only sections,
  claims, and applications require separate approval.
- Keep paper-specific definitions, constructions, matrix operations, and
  characterizations in this repository.
- Record a result for possible LeanInfoTheory upstreaming only when it is
  genuinely reusable beyond this paper and fits the library's architecture.
- Depend on immutable LeanInfoTheory `v0.1.0`. Do not switch to `master`, a
  mutable ref, or a local path without explicit approval.
- Treat every LeanInfoTheory upgrade as a dedicated, reviewed, fully validated
  project step. Verify names against the pinned release, not current upstream
  development.

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
- Reuse mathlib and the pinned LeanInfoTheory API before creating local
  alternatives.
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

- A new theorem-development chunk requires an approved plan.
- Each implementation prompt addresses one approved step. Complete and
  validate that step, report it, and stop.
- Do not begin a later step automatically.
- If a discovery invalidates later steps, stop for a plan-health review.
- Record deferred ideas without pulling them into the active step.
- Chunk completion requires an independent validation pass against its
  completion criteria.

## Canonical-document ownership

- `docs/perfect-functional-representations-living-summary.md` is shared
  canonical context. Any project thread may update it when its work materially
  changes project context; the project lead remains the decision authority.
- Reconcile living-summary edits against source, builds, approved plans,
  relevant log entries, the paper, and Git history.
- Threads that materially change context without editing the living summary
  should write structured handoffs under ignored `tmp/codex-handoffs/`.
- The General Assistant performs periodic cross-thread reconciliation but is
  neither the exclusive editor nor an approval gate.
- Update `docs/project-log.md` at meaningful mathematical steps, decisions,
  reviews, and milestones, not after every helper lemma.
- Change `AGENTS.md` only when a stable rule, convention, or ownership boundary
  changes.

## Targeted source reading

- Begin with the living-summary quick start and active plan.
- Inspect the relevant local module, dependency closure, and pinned upstream
  declarations.
- Search targeted project-log entries and active future-work items.
- Read the exact relevant ISIT section and only the needed extended proof
  supplement.
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
  when an extended-version proof supplements an ISIT statement.
- Do not guess authorship, rights-holder, affiliation, publication, DOI, or
  source-header metadata. The project lead must verify release metadata.
