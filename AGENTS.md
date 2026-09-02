# PerfectFunctionalRepresentationsLean Agent Instructions

This repository formalizes the ISIT paper *On Perfect Functional
Representations* as a downstream case study of LeanInfoTheory. These are stable
operating rules; detailed plans and history belong in project documentation.

## Startup context

Before substantial planning or implementation:

1. Read this file, `README.md`, and `docs/project-scope.md`.
2. Read the active approved plan when one exists.
3. Inspect the actual local Lean declarations and dependency version.
4. Read only the exact paper sections and proof supplements relevant to the
   current task.

## Scope and dependency

- The primary target is the six-page ISIT paper. The extended paper supplies
  omitted proof details but does not automatically enlarge the target.
- Keep paper-specific mathematics in this repository. Record potentially
  reusable information-theory results for separate LeanInfoTheory review.
- Depend on the immutable LeanInfoTheory `v0.1.0` release. Do not switch to its
  `master` branch, a mutable ref, or a local path without explicit approval.
- Treat a LeanInfoTheory upgrade as a dedicated, validated project step.
- Verify imported declarations against the pinned release rather than current
  LeanInfoTheory development state.

## Proof and implementation integrity

- Do not introduce `sorry`, `admit`, an unapproved `axiom`, `opaque`,
  `undefined`, or an equivalent proof placeholder.
- Do not silently weaken a target theorem or strengthen assumptions merely to
  make a proof compile.
- Report assumptions, edge cases, representation choices, and departures from
  the paper explicitly.
- Reuse mathlib and the pinned LeanInfoTheory API before adding local
  alternatives. Keep one-off proof machinery private.
- Apart from pinned dependencies, do not consult or reuse external
  formalization repositories unless the project lead explicitly requests it.
  Record the source and required attribution for any external implementation
  code that is consulted or reused.

## References and provenance

- Do not commit copyrighted paper PDFs, textbooks, or local reference files.
- Cite the exact paper section supporting a formalization contract.
- Do not guess authorship, rights-holder, affiliation, or source-header
  metadata. The project lead must confirm those fields before public release.

## Validation and workflow

- Use one approved implementation step per prompt and stop after that step.
- After each coherent Lean change, build the touched module and important
  downstream aggregate.
- Before a commit or milestone, run `lake build` and require the following scan
  to return no matches:

```powershell
rg -n --glob '*.lean' '\b(sorry|admit|axiom|opaque|undefined)\b' `
  PerfectFunctionalRepresentations PerfectFunctionalRepresentations.lean
```

- Inspect the final diff, Git status, generated files, and temporary artifacts
  before committing or reporting completion.
