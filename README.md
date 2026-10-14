# PerfectFunctionalRepresentationsLean

Lean 4 formalization of the six-page ISIT paper *On Perfect Functional
Representations*, developed as a downstream case study of
[LeanInfoTheory](https://github.com/serhatemrecoban/LeanInfoTheory).

## Status

**Current, 2026-10-14:** all sixteen planned formalization chunks are complete.
The source is public under Apache-2.0, with the scope qualifications below.
This is a completed downstream case study of **LeanInfoTheory v0.1.0**, not
a claim to formalize the entire extended manuscript. See the
[public-readiness record](docs/public-readiness.md) for content checks,
attribution and reproducibility evidence. No tagged release or website has been
published.

The development includes semantic/canonical representations, singularity and
binary cases, finite maximal coupling, typed matrix operations and constructive
reachability, pattern/incidence systems, and attained primal/dual
characterizations. The [source ledger](docs/pfr-c16-coverage-audit.md) maps every
numbered item and substantive prose occurrence to a theorem, proof, checked
fixture, documentation disposition or intentional omission.

## Scope and mathematical boundaries

The six-page ISIT manuscript fixes scope. Extended version 16 supplies the
historical C01–C16 proof/clarification baseline. The lead supplied extended
`(19) (2)` on 2026-10-13; selected appended proofs were compared, not the entire
new draft. Extended-only results remain outside current scope.
Information uses finite value alphabets and nats, with unrestricted source spaces
where supported. In particular, information-preserving canonicalization and the
binary information bound cover finite-valued auxiliaries, not the paper's fully
unrestricted auxiliary reading. Support-only decoders and null fibers remain explicit.
All-prior bounds and forward results retain their generality; ambient converses
that need full input support say so. The ambient-channel LP characterizations
assume singularity, finite alphabets and nonempty input. They use the corrected
full/reduced indexing clarified by the extended manuscript, and are mathematical
characterizations, not an executable LP solver. See
[project scope](docs/project-scope.md) and the
[boundary audit](docs/pfr-c16-readiness-audit.md#boundary-index).

## Dependencies and build

Lean is pinned to `v4.33.1`; LeanInfoTheory is pinned to immutable `v0.1.0`
(`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`). Mathlib is resolved through
`lake-manifest.json`. Upgrades need a dedicated reviewed step.

Install Git, [elan](https://github.com/leanprover/elan) and Python 3.11 or newer
(use `python3` below if your system does not name it `python`).
The committed toolchain file selects the Lean version automatically. From a fresh
checkout:

```text
git clone https://github.com/serhatemrecoban/PerfectFunctionalRepresentationsLean.git
cd PerfectFunctionalRepresentationsLean
lake exe cache get --cache-from=master,legacy
python -B tools/check_public_build.py build
```

The last command builds **all 56 maintained modules**, including tests and
examples, then the default target, and verifies the installed dependency pins.
The cache command downloads public mathlib release artifacts; it does not reuse
PFR build artifacts. Do not run `lake update` to reproduce the frozen baseline.
See the [public build workflow](.github/workflows/lean.yml) and
[readiness record](docs/public-readiness.md) for actual validation status.

To build only the lightweight mathematical entry point:

```powershell
lake build
```

The default target excludes separately imported matrix, optimization,
demonstration and regression modules; use the all-module command above for full
validation. Historical chunk acceptance and validation remain available in the
[implementation notes](docs/pfr-c16-implementation-notes.md) and
[completion checkpoint](docs/project-log.md#post-c16-checkpoint).

## Reading and module routes

| Need | Start here |
| --- | --- |
| Current status and essential limits | [Living summary / Quick Start](docs/perfect-functional-representations-living-summary.md#0-ai-assistant-quick-start) |
| Exact paper-to-Lean coverage | [C16 source ledger](docs/pfr-c16-coverage-audit.md) |
| Boundaries, trust, API and readiness | [C16 readiness audit](docs/pfr-c16-readiness-audit.md) |
| Chunk allocation, decisions and omissions | [Formalization map](docs/formalization-map.md) |
| Evidence, history and agent workflow | [Implementation notes](docs/pfr-c16-implementation-notes.md), [project log](docs/project-log.md), [AGENTS.md](AGENTS.md) |
| Measured LeanInfoTheory reuse | [Complete declaration list](output/reuse-audit/leaninfotheory-pfr-reuse-list.txt), [evidence and source locations](output/reuse-audit/leaninfotheory-pfr-reuse-evidence.json) |
| Public readiness and scope qualifications | [Publication checks and website direction](docs/public-readiness.md) |

The [root](PerfectFunctionalRepresentations.lean) imports Basic, four semantic
modules and finite coupling. `Probability/FiniteCouplingDecoding.lean`,
`Matrix/`, `Optimization/`, `Examples/` and `Tests/` stay separately importable.
The [complete module/API table](docs/pfr-c16-readiness-audit.md#complete-module-disposition)
records all owners and the [compiled import audit](docs/pfr-c16-readiness-audit.md#isolated-compiled-import-audit-e21)
checks their actual boundaries. Historical implementation checkpoints remain in
their original plans, notes and project-log entries.

## Website and release

Public repository availability is authorized separately from C16 completion.
Website direction is under discussion; no website has been built or deployed.
A later request will authorize implementation. Tagged releases, unverified
metadata and publication-facing omission curation remain separate decisions;
see the [roadmap](docs/roadmap.md). Local papers and references remain external
or ignored and must not be committed.

## Authors and citation

The mathematical paper is by **Serhat Emre Coban, Yanina Y. Shkel, and Emre
Telatar**. The Lean formalization is by **Serhat Emre Coban**. See
[AUTHORS.md](AUTHORS.md) for attribution and [CITATION.cff](CITATION.cff) for
software citation. Cite the paper separately for its mathematical results;
an approved public paper link and complete bibliography are still pending.

This case study was completed with **LeanInfoTheory v0.1.0**. Its publication
and recognition in a future LeanInfoTheory release do not require a dependency
upgrade.

## License

Project-authored software is licensed under Apache-2.0; see [LICENSE](LICENSE).
The paper and cited references retain their own copyrights and licences.
On 2026-10-14 the project lead confirmed retaining this license for public
availability and leaving unverified copyright-holder and bibliographic metadata
unspecified. The subsequently confirmed authorship credits are listed above;
affiliation, DOI and copyright-holder claims are not inferred from them.
