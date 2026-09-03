# PerfectFunctionalRepresentationsLean

Lean 4 formalization of the ISIT paper *On Perfect Functional
Representations*, developed as a downstream case study of
[LeanInfoTheory](https://github.com/serhatemrecoban/LeanInfoTheory).

## Status

This repository is in its private formalization-planning phase. It does not yet
claim a completed formalization of any theorem from the paper. A
[current formalization map](docs/formalization-map.md) allocates the paper to
dependency-aware candidate chunks. Its acceptance as the adaptable global
reference does not approve any chunk or theorem implementation.

## Scope

The six-page ISIT version fixes the primary formalization scope. The current
extended draft is an evolving proof and clarification reference for fuller
arguments and compressed or ambiguous ISIT passages, but its additional
statements are not automatically part of the project. See
[`docs/project-scope.md`](docs/project-scope.md) for the boundary between
literal paper wording, intended mathematics, and the precise Lean contract.

Paper-specific definitions and results belong here. Generally reusable finite
information-theory results may instead be proposed for LeanInfoTheory after a
separate ownership and API review.

## Primary libraries and pinned dependency

Mathlib supplies the foundational mathematics and `PMF` infrastructure.
LeanInfoTheory supplies the finite-discrete information-theory API. The project
searches and reuses both before adding local material; paper-specific
functional-representation and matrix results remain here.

The project currently depends on the immutable LeanInfoTheory `v0.1.0`
release, which uses Lean and mathlib `v4.33.1`:

```toml
[[require]]
name = "LeanInfoTheory"
git = "https://github.com/serhatemrecoban/LeanInfoTheory"
rev = "v0.1.0"
```

Dependency upgrades are deliberate project changes. This repository must not
silently track LeanInfoTheory `master` or a machine-local checkout.

## Build

The pinned Lean toolchain is Lean `v4.33.1`.

```powershell
lake update
lake build
```

## Repository structure

- `PerfectFunctionalRepresentations.lean`: project root import;
- `PerfectFunctionalRepresentations/`: Lean source modules;
- [`AGENTS.md`](AGENTS.md): how assistants work;
- [living summary](docs/perfect-functional-representations-living-summary.md):
  where the project currently stands;
- [project scope](docs/project-scope.md): what belongs in the project;
- [project log](docs/project-log.md): what happened and why, plus detailed
  Future Work Notes;
- [roadmap](docs/roadmap.md): where the project may go, without authorizing
  implementation;
- [formalization map](docs/formalization-map.md): the adaptable global source
  allocation, chunk dependencies, decision gates, and internal omission
  register; and
- future `docs/plans/` files: what the project lead has explicitly approved to
  do next.

No theorem-development chunk or chunk plan is currently approved.

Local paper copies, textbooks, and working references are intentionally ignored
and must not be committed.

## Website

PFR currently has no project website, website source, hosting configuration, or
approved website plan. A possible public site is deferred until a later
release-readiness phase. LeanInfoTheory's website documents the dependency and
is not a website for this project.

## License

Project-authored software is licensed under Apache-2.0; see `LICENSE`. The
paper and other cited references retain their own copyrights and licences.
Copyright-holder wording and source-file headers will be finalized before the
repository is made public.
