# PerfectFunctionalRepresentationsLean Roadmap

This reader-facing roadmap describes where the project may go. It is
directional, not an execution contract: its ordering and workstreams remain
subject to the formalization map, and no item here authorizes theorem
implementation. Current status belongs in the
[living summary](perfect-functional-representations-living-summary.md), scope
belongs in [project scope](project-scope.md), the current dependency-aware
allocation belongs in the [formalization map](formalization-map.md), and only
an explicitly approved chunk plan may authorize implementation.

<a id="current-c16-reviewed-final-checkpoint"></a>

## Current: C01–C16 complete

**Current, 2026-10-04:** C01–C16 are durably complete. C16's supported S05
closure and exact final-source applicability were verified before the
[private repository checkpoint](project-log.md#post-c16-checkpoint).
The [approved plan](plans/pfr-c16-coverage-api-trust-closure.md) is the execution
contract. The [integrated readiness matrix](pfr-c16-readiness-audit.md#c16-s05-readiness)
maps every earlier C16 criterion, boundary and completion outcome. S05
reassessed and closed the complete contract under its own accepted request.
Original historical checkpoints and later completion evidence are available
through the [closure/history routes](pfr-c16-readiness-audit.md#c16-s04-navigation).

## Completed mathematical workstreams

| Workstream | Complete owners |
| --- | --- |
| Functional/canonical representations, singularity and binary cases | C01–C03, C05 |
| Finite total variation and maximal coupling | C04 |
| Channel/matrix boundary, typed operations and normalization | C06–C08 |
| Preservation, finite operation synthesis and constructive characterization | C09–C11 |
| Active-pattern compression and full/reduced incidence systems | C12–C13 |
| Attained primal and dual characterizations | C14–C15 |

The map retains the dependency history and source allocation. New theorem scope
requires a new approved contract; none is allocated by this status summary.

## Completion and release direction

C16 owns final formalization coverage, maintained-example/API/import, documentation
and local trust closure. A separately authorized release-readiness phase may then
address rights, licensing/citation metadata, distribution and remote validation.
No release, publication-facing omission curation or public publication state is
implied by C16 completion or this roadmap.

The lead separately authorized public repository availability on 2026-10-14,
under the existing Apache-2.0 license and without inventing unverified metadata.
The [publication checkpoint](project-log.md#public-repository-checkpoint) records
that bounded delivery. The subsequent [public-readiness work](public-readiness.md)
adds content/history checks, confirmed author credits and a public all-module
build gate. A tagged release, unverified metadata and omission curation remain
separate decisions, not consequences of this visibility change.

## Later or deferred directions

The [dated disposition register](pfr-c16-readiness-audit.md#c16-s04-dispositions)
records original references, owners and reconsideration triggers. These possible
directions are outside current execution:

- adoption of a later tagged LeanInfoTheory release;
- reusable upstream proposals justified by concrete downstream proof pressure;
- executable decision software or certified LP-solver integration;
- extended-only algorithms, complexity results, hypergraph/coloring
  constructions, or information-measure claims that receive separate scope
  approval;
- an optional presentation layer emphasizing bits beyond the existing
  nats-to-bits conversion; and
- a DOI and final publication metadata.

The lead subsequently authorized website implementation on 2026-10-14. The
[website plan](plans/pfr-website.md) owns that bounded delivery. The subsequent
approved extension adds a mathematical blueprint and compiler-generated PFR API
to the overview, source-linked results, discussion/limitations, normalization
proof feedback and reproduction/citation, using LeanInfoTheory's blue–green
palette. The updated
[site is live](https://serhatemrecoban.github.io/PerfectFunctionalRepresentationsLean/)
on GitHub Pages, with verified source links and desktop/mobile validation. The
[readiness record](public-readiness.md#blueprint-api-and-palette-extension--2026-10-14)
owns current delivery evidence, including the completed extension's hosted and
live validation.
The PFR-only API complements LeanInfoTheory's library documentation; it does not
republish its dependency API or change the dependency pin.

The completed case study stays pinned to **LeanInfoTheory v0.1.0**, including
during public presentation and any celebration in the library's next release.
An upgrade is a separate possible future task, not a publication prerequisite.

## Approval boundary

Future Work Notes, roadmap items, formalization-map proposals, omission
records, experiments, and proof-risk investigations do not authorize
implementation. When the project lead approves a chunk, its contract will be
stored under `docs/plans/` with a stable filename and explicit status,
baseline, scope, steps, and completion criteria. Completing one step or chunk
never authorizes the next one.
