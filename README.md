# PerfectFunctionalRepresentationsLean

Lean 4 formalization of the ISIT paper *On Perfect Functional
Representations*, developed as a downstream case study of
[LeanInfoTheory](https://github.com/serhatemrecoban/LeanInfoTheory).

## Status

This repository is in its initial theorem-development phase. A
[current formalization map](docs/formalization-map.md) allocates the paper to
dependency-aware candidate chunks. Its acceptance as the adaptable global
reference does not itself approve theorem implementation. PFR-C01 is complete
under its
[approved detailed plan](docs/plans/pfr-c01-semantic-functional-representations.md),
following independent S08 validation and closeout on 2026-09-07. S01-S06
implemented the support-aware structural
functional-representation predicates, their common-base expansion theorem,
full-triple-law transport, independence under deterministic postprocessing,
the Equation (1) equivalence, the unconditional Equation (2) decomposition,
and Equation (3) with its bound and equality/Markov criteria. The information
results use finite-valued variables on an unrestricted source space; all four
Equation (3) consequences require a functional representation. Fixed-auxiliary
perfectness has equality, zero-CMI, Markov, and full-law transport interfaces.
The separate existential pair predicate permits a new finite triple-law
extension, depends only on the pair law, and accepts any finite perfect
auxiliary through the universe-safe `Fin n` bridge.

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

The pinned Lean toolchain is Lean `v4.33.1`. Build the mathematical root and
the separately maintained regression module:

```powershell
lake build
lake build PerfectFunctionalRepresentations.Tests.Semantics.FunctionalRepresentation
```

The root exposes the production semantic API but does not import regressions;
the second command is required to validate them.

## Repository structure

- `PerfectFunctionalRepresentations.lean`: lightweight project root exposing
  the dependency smoke test and production semantic API, without regressions;
- `PerfectFunctionalRepresentations/`: Lean source modules;
- `PerfectFunctionalRepresentations/Semantics/FunctionalRepresentation.lean`:
  the separately importable 23-declaration structural, transport, Equations
  (1)-(3), and fixed/existential perfectness API from PFR-C01-S01 through S06;
- `PerfectFunctionalRepresentations/Tests/Semantics/FunctionalRepresentation.lean`:
  support-sensitive, polymorphic, transport, postprocessing, and Equations
  (1)-(3) regressions, including infinite sources, a bad preselected decoder,
  distinct-value-type orientation checks, null conditioning fibers,
  deterministic and singleton perfectness, an XOR fixed-auxiliary negative
  case, separate-space witnesses, higher universes, and impossible `Fin 0`
  extensions;
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
- [approved PFR-C01 plan](docs/plans/pfr-c01-semantic-functional-representations.md)
  and future `docs/plans/` files: what the project lead has explicitly approved
  to do next.

PFR-C01 is `Complete`: S01-S08 are validated, including the independent
chunk-wide source, API, regression, manuscript, and build review. The root
exposes the semantic module while regressions remain separately built.
PFR-C02 detailed planning is the next eligible activity, but has not started
and is not authorized by C01 completion. See the
[S08 completion record](docs/project-log.md#31-pfr-c01-s08-independent-validation-and-chunk-completion---2026-09-07).

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
