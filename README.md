# PerfectFunctionalRepresentationsLean

Lean 4 formalization of the six-page ISIT paper *On Perfect Functional
Representations*, developed as a downstream case study of
[LeanInfoTheory](https://github.com/serhatemrecoban/LeanInfoTheory).

## Status

**Current, 2026-10-04:** C01–C16 are complete. C16's supported final closure,
satisfied criteria and exact final-source applicability were verified before
this [private repository checkpoint](docs/project-log.md#post-c16-checkpoint).
The [approved C16 plan](docs/plans/pfr-c16-coverage-api-trust-closure.md) and
[integrated readiness](docs/pfr-c16-readiness-audit.md#c16-s05-readiness) retain
their original pre-closure evidence; the later durable record establishes completion.
The repository remains private. Formalization completion, release and public
publication are separate milestones.

The development includes semantic/canonical representations, singularity and
binary cases, finite maximal coupling, typed matrix operations and constructive
reachability, pattern/incidence systems, and attained primal/dual
characterizations. The [source ledger](docs/pfr-c16-coverage-audit.md) maps every
numbered item and substantive prose occurrence to a theorem, proof, checked
fixture, documentation disposition or intentional omission.

## Scope and mathematical boundaries

The six-page ISIT manuscript fixes scope. Extended version 16 supplies recorded
proofs and clarification; its additional results are outside current scope.
Information uses finite value alphabets and nats, with unrestricted source spaces
where supported. Support-only decoders and null fibers remain explicit.
All-prior bounds and forward results retain their generality; ambient converses
that need full input support say so. The LP interfaces require finite alphabets
and nonempty input. See [project scope](docs/project-scope.md) and the
[boundary audit](docs/pfr-c16-readiness-audit.md#boundary-index).

## Dependencies and build

Lean is pinned to `v4.33.1`; LeanInfoTheory is pinned to immutable `v0.1.0`
(`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`). Mathlib is resolved through
`lake-manifest.json`. Upgrades need a dedicated reviewed step.

From the repository root, build the lightweight mathematical entry point:

```powershell
lake build
```

The default target excludes separately imported matrix, optimization,
demonstration and regression modules. Build every maintained module explicitly
(PowerShell, with `rg` available):

```powershell
$pfrTargets = @('PerfectFunctionalRepresentations') + @(rg --files PerfectFunctionalRepresentations -g '*.lean' | ForEach-Object { $_.Replace('\', '.').Replace('/', '.') -replace '\.lean$', '' })
lake build @pfrTargets
```

The current inventory has 56 owners including the root. S05's fresh complete-target
build passed 2,823 jobs and the default build passed 2,762, using cached artifacts.
[Implementation notes](docs/pfr-c16-implementation-notes.md) distinguish fresh
checks, inherited evidence and later validation.

## Reading and module routes

| Need | Start here |
| --- | --- |
| Current status and essential limits | [Living summary / Quick Start](docs/perfect-functional-representations-living-summary.md#0-ai-assistant-quick-start) |
| Exact paper-to-Lean coverage | [C16 source ledger](docs/pfr-c16-coverage-audit.md) |
| Boundaries, trust, API and readiness | [C16 readiness audit](docs/pfr-c16-readiness-audit.md) |
| Chunk allocation, decisions and omissions | [Formalization map](docs/formalization-map.md) |
| Evidence, history and agent workflow | [Implementation notes](docs/pfr-c16-implementation-notes.md), [project log](docs/project-log.md), [AGENTS.md](AGENTS.md) |

The [root](PerfectFunctionalRepresentations.lean) imports Basic, four semantic
modules and finite coupling. `Probability/FiniteCouplingDecoding.lean`,
`Matrix/`, `Optimization/`, `Examples/` and `Tests/` stay separately importable.
The [complete module/API table](docs/pfr-c16-readiness-audit.md#complete-module-disposition)
records all owners and the [compiled import audit](docs/pfr-c16-readiness-audit.md#isolated-compiled-import-audit-e21)
checks their actual boundaries. Historical implementation checkpoints remain in
their original plans, notes and project-log entries.

## Website and release

No project website or website plan is approved. A public site, release metadata,
remote validation and publication-facing curation require separate decisions;
see the [roadmap](docs/roadmap.md). Local papers and references remain external
or ignored and must not be committed.

## License

Project-authored software is licensed under Apache-2.0; see [LICENSE](LICENSE).
The paper and cited references retain their own copyrights and licences.
Copyright-holder wording and source-file headers require project-lead
verification before public release.
