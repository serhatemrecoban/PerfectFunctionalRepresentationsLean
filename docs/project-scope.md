# Project Scope

## Primary target

The project formalizes the six-page ISIT version of *On Perfect Functional
Representations* in Lean 4. Local manuscript copies used for planning remain
outside the repository or in ignored reference directories and must not be
committed. A verified bibliographic record and an appropriate public link may
be added after the project lead confirms them.

The extended version is a proof supplement: it may explain arguments omitted
from the conference paper, but additional definitions, theorems, algorithms,
and claims from that version are outside scope unless explicitly approved.

## Paper boundary

The six-page target consists of:

- the functional-representation and canonical-representation definitions;
- perfect representability and singularity;
- the binary-input total-variation result;
- column values, patterns, and the four split/merge operations;
- the constructive characterization of perfect representability;
- the primal and dual linear-program characterizations; and
- the examples and supporting lemmas needed by those results.

The extended manuscript may be used for omitted proofs of these ISIT results.
Its separate computational-complexity discussion, hypergraph-coloring claims,
unproved auxiliary claim, broader information-measure discussion, and other
extended-only material are not current formalization targets.

## Library boundary

This repository is a downstream case study of LeanInfoTheory. It uses the
immutable `v0.1.0` release and inherits its finite-PMF, entropy, information
measure, KL, channel, Markov, data-processing, and sufficiency conventions.

Paper-specific notions, representations, constructions, and main results are
owned here. A missing result belongs upstream only when it is useful beyond the
paper, fits LeanInfoTheory's mathematical architecture, and receives separate
review. Until a new LeanInfoTheory release is adopted, downstream proofs must
continue to compile against `v0.1.0`.

## Version policy

- The Lake dependency uses the immutable `v0.1.0` tag.
- `lake-manifest.json` records the resolved commit and is committed.
- Upgrades occur in dedicated commits after release-note review and a complete
  project build.
- The project does not track LeanInfoTheory `master` in maintained state.

## Current phase

The repository has a validated dependency scaffold and is preparing its first
formalization map. No paper theorem is represented as formalized until its
statement, assumptions, source location, Lean ownership, and validation
evidence are recorded. No theorem-development chunk is currently approved.
