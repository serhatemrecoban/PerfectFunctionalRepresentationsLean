# PerfectFunctionalRepresentationsLean Roadmap

This roadmap summarizes completed work and possible future directions. It is
not an execution contract: inclusion here does not start theorem development.
Current status belongs in the
[living summary](perfect-functional-representations-living-summary.md), scope
belongs in [project scope](project-scope.md), the current dependency-aware
allocation belongs in the [formalization map](formalization-map.md), and
implementation requires an explicitly approved chunk plan.

<a id="current-c16-reviewed-final-checkpoint"></a>

## Current: C01–C16 complete

**Current, 2026-10-04:** all sixteen formalization chunks are complete. C16's
final validation was checked against the completed source before the
[private repository checkpoint](project-log.md#post-c16-checkpoint).
The [C16 plan](plans/pfr-c16-coverage-api-trust-closure.md) records the completion
criteria, and the [integrated readiness matrix](pfr-c16-readiness-audit.md#c16-s05-readiness)
maps those criteria, mathematical boundaries and final outcomes. Original
checkpoints and the later completion evidence remain available
through the [closure/history routes](pfr-c16-readiness-audit.md#c16-s04-navigation).

## Completed mathematical workstreams

| Workstream | Completed chunks |
| --- | --- |
| Functional/canonical representations, singularity and binary cases | C01–C03, C05 |
| Finite total variation and maximal coupling | C04 |
| Channel/matrix boundary, typed operations and normalization | C06–C08 |
| Preservation, finite operation synthesis and constructive characterization | C09–C11 |
| Active-pattern compression and full/reduced incidence systems | C12–C13 |
| Attained primal and dual characterizations | C14–C15 |

The map retains the dependency history and source allocation. New theorem work
requires a separate approved plan; this status summary adds no new scope.

## Completion and release direction

C16 completed the coverage, example, API, import, documentation and local trust
audits. Publication required separate checks of content, attribution,
reproducibility and remote validation; mathematical completion alone did not
establish those facts.

The repository became public on 2026-10-14 under the existing Apache-2.0 license.
The [publication checkpoint](project-log.md#public-repository-checkpoint) records
the visibility change. The [public-readiness record](public-readiness.md)
documents content/history checks, author credits and the public all-module build
gate. A tagged release, additional verified metadata and publication-facing
omission curation remain separate decisions.

### Research website

The [website plan](plans/pfr-website.md) records the design and implementation
begun on 2026-10-14. The [site is live](https://serhatemrecoban.github.io/PerfectFunctionalRepresentationsLean/)
on GitHub Pages, with an overview, mathematical blueprint, compiler-generated
PFR API, source-linked results, discussion of limitations and normalization,
and reproduction/citation guidance. It uses LeanInfoTheory's blue–green palette
and an academic layout with the paper's exact title, ISIT 2026 description and
verified public paper link. The DOI is also recorded in [AUTHORS.md](../AUTHORS.md).

The [blueprint/API delivery record](public-readiness.md#blueprint-api-and-palette-extension--2026-10-14)
and [academic-layout record](public-readiness.md#academic-layout-correction--2026-10-14)
preserve the hosted checks, source-link validation and desktop/mobile evidence.
The PFR-only API complements LeanInfoTheory's library documentation; it does not
republish its dependency API or change the dependency pin.

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
- any additional verified publication metadata beyond the now-linked ISIT paper DOI.

The completed case study stays pinned to **LeanInfoTheory v0.1.0**, including
during public presentation and any celebration in the library's next release.
An upgrade is a separate possible future task, not a publication prerequisite.

## Approval boundary

Future Work Notes, roadmap items, formalization-map proposals, omission
records, experiments, and proof-risk investigations do not authorize
implementation. I approve new chunks through explicit plans, which are
stored under `docs/plans/` with a stable filename and explicit status,
baseline, scope, steps, and completion criteria. Completing one step or chunk
never authorizes the next one.
