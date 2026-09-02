# PerfectFunctionalRepresentationsLean

Lean 4 formalization of the ISIT paper *On Perfect Functional
Representations*, developed as a downstream case study of
[LeanInfoTheory](https://github.com/serhatemrecoban/LeanInfoTheory).

## Status

This repository is in its private bootstrap phase. It does not yet claim a
completed formalization of any theorem from the paper.

## Scope

The primary formalization target is the shorter six-page ISIT version of the
paper. The extended version may be consulted for proof details omitted from the
ISIT paper, but its additional statements are not automatically part of the
formalization scope.

Paper-specific definitions and results belong here. Generally reusable finite
information-theory results may instead be proposed for LeanInfoTheory after a
separate ownership and API review.

## LeanInfoTheory dependency

The project currently depends on the immutable LeanInfoTheory `v0.1.0`
release:

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
- `docs/project-scope.md`: formalization and dependency boundaries;
- `AGENTS.md`: stable assistant operating rules.

Local paper copies, textbooks, and working references are intentionally ignored
and must not be committed.

## License

Project-authored software is licensed under Apache-2.0; see `LICENSE`. The
paper and other cited references retain their own copyrights and licences.
Copyright-holder wording and source-file headers will be finalized before the
repository is made public.
