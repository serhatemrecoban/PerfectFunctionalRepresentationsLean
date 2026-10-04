# Project Scope

## Primary target

The project formalizes the six-page ISIT version of *On Perfect Functional
Representations* in Lean 4. Local manuscript copies used for planning remain
outside the repository or in ignored reference directories and must not be
committed. A verified bibliographic record and an appropriate public link may
be added after the project lead confirms them.

The six-page manuscript fixes the default inclusion boundary. The current
extended draft is an evolving proof and clarification reference: it may give
fuller arguments or make compressed ISIT passages more precise, but its
additional definitions, theorems, algorithms, applications, and claims remain
outside scope unless explicitly approved. Material reliance on the extended
draft must identify the consulted version and be revisited when that draft
changes.

## Interpretation boundary

The manuscripts are written for mathematically informed human readers. They
may omit routine hypotheses, compress indexing or representation details, or
describe effective quantities where a literal formal encoding has a larger
ambient representation.

Formalization must distinguish:

1. the literal printed prose or displayed formulation;
2. the mathematically intended reading in context, including clarification
   supplied by the current extended draft; and
3. the technically precise Lean statement and representation.

Lean should express a correct version of the intended mathematical claim, not
a knowingly false or ill-typed literal reading. Any material implicit
assumption, repaired index, representation change, or mismatch must be
recorded, with an explicit equivalence bridge when practical. If competing
interpretations change truth, assumptions, conclusion, theorem strength, or
scope, the project lead must choose between them.

## Paper boundary

The six-page target consists of:

- the functional-representation and canonical-representation definitions;
- perfect representability and singularity;
- the binary-input total-variation result;
- column values, patterns, and the four split/merge operations;
- the constructive characterization of perfect representability;
- the primal and dual linear-program characterizations; and
- the examples and supporting lemmas needed by those results.

The extended draft's separate algorithms, computational-complexity and
NP-hardness results, hypergraph/coloring constructions, broader
information-measure discussion, and other extended-only material are not
current formalization targets.

## Library boundary

Mathlib and LeanInfoTheory are the project's two primary libraries. Mathlib
supplies the foundational mathematics and `PMF` infrastructure. The immutable
LeanInfoTheory `v0.1.0` release supplies the finite-discrete
information-theory layer, including its entropy, information-measure, KL,
channel, Markov, data-processing, and sufficiency conventions.

Search and reuse their pinned sources, documented APIs, and relevant examples
before introducing a project-local definition, theorem, or helper. A failed
name guess or external search is not evidence that a declaration is absent;
candidate reuse must be verified in Lean. Existing library content must not be
recreated merely for paper-facing naming convenience.

LeanInfoTheory examples and non-stable internals may guide discovery but are
not the maintained dependency surface. Production PFR modules should reuse the
release's supported public imports and declarations.

Rocq developments and other external information-theory formalizations are not
routine dependency or implementation sources for this downstream case study.
Consultation or reuse requires an explicit project-lead request and recorded
provenance or attribution where applicable.

Paper-specific notions, representations, constructions, and main results are
owned here. A missing result belongs upstream only when it is useful beyond the
paper, fits LeanInfoTheory's mathematical architecture, and receives separate
review. Until a new LeanInfoTheory release is adopted, downstream proofs must
continue to compile against `v0.1.0`.

## Version policy

- The Lake dependency uses the immutable `v0.1.0` tag.
- `lake-manifest.json` records the resolved commit and is committed.
- The current resolved baseline uses Lean and mathlib `v4.33.1`.
- Upgrades occur in dedicated commits after release-note review and a complete
  project build.
- The project does not track LeanInfoTheory `master` in maintained state.

## Current phase

**Current, 2026-10-04:** C01–C16 are durably complete. C16's supported S05
closure and exact final-source applicability were verified before the
[private repository checkpoint](project-log.md#post-c16-checkpoint).
The [approved C16 revision-2 plan](plans/pfr-c16-coverage-api-trust-closure.md)
authorizes formalization closure within the existing six-page scope. Its
[readiness matrix](pfr-c16-readiness-audit.md#c16-s05-readiness) separates
established coverage and decisions from the final durable closure boundary.
Original plans and pre-finalization records keep their historical meaning;
[current closure navigation](pfr-c16-readiness-audit.md#c16-s04-navigation)
points to the preserved records and later verified handoffs.

The current API retains support-aware semantic contracts, exact active-output
and numeric bridges, finite nonempty-input LP interfaces, private fixtures and
the no-wrapper decision. DG-01–DG-15 are resolved. Original OM-001–071 rationale
is preserved without publication-facing condensation or archival curation.

C16 does not authorize new theorem families, extended-only results, generic LP
infrastructure, solver integration, a dependency upgrade, commits/pushes,
release, publication or a website. Those directions retain their separate
owners and triggers in the [disposition register](pfr-c16-readiness-audit.md#c16-s04-dispositions)
and [roadmap](roadmap.md).

The lead separately authorized committing and pushing accumulated progress
through C16 on 2026-10-04 while keeping the repository private. That checkpoint
does not authorize a release, public publication, new mathematics or website work.
