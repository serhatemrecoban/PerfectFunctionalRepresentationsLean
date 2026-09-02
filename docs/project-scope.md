# Project Scope

## Primary target

The project formalizes the six-page ISIT version of *On Perfect Functional
Representations* in Lean 4. The exact bibliographic record and paper files will
be added or linked after the project lead supplies and verifies them.

The extended version is a proof supplement: it may explain arguments omitted
from the conference paper, but additional definitions, theorems, algorithms,
and claims from that version are outside scope unless explicitly approved.

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

The repository is being bootstrapped. No paper theorem is represented as
formalized until its statement, assumptions, source location, Lean ownership,
and validation evidence are recorded.
