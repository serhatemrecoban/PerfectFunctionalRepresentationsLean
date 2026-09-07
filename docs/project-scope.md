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

The repository has a validated dependency scaffold. Revision 2 of its first
formalization map was accepted by the project lead as the current adaptable,
non-authorizing global reference after a second adversarial pass. PFR-C01
detailed-plan Draft revision 2 was approved on 2026-09-04, and DG-01 was
resolved according to it. Approval-checkpoint commit
`5a9c7ca999639afe26c7bf235b4d044e0341b55a` is the execution baseline.
PFR-C01 is `Complete`; S01's structural predicates and common-base expansion
and S02's full-triple-law transport and deterministic-postprocessing
independence theorem are implemented and validated. S03's Equation (1)
equivalence was separately authorized and validated on 2026-09-05, with finite
value alphabets, an unrestricted source type, and existential decoding correct
only on support. S04's unconditional Equation (2) decomposition was explicitly
authorized and validated on 2026-09-06, with finite value alphabets, no
finite-source assumption, and no functional-representation premise. S05 was
separately authorized on 2026-09-06 and validated on 2026-09-07: Equation (3),
its bound, and its equality/Markov consequences all retain a
functional-representation premise, finite value alphabets, an unrestricted
source, and support-only decoding. The project lead explicitly authorized
S06 on 2026-09-07, and it completed implementation-step validation that day.
Fixed-auxiliary perfectness retains support-aware representation alongside
its equality, zero-CMI, and Markov forms. Existential pair perfectness is a
pair-law property with a finite triple-law extension, not an auxiliary
required on the original source. Its arbitrary-finite bridge preserves the
approved universe and finite-value boundary; it does not prove a general
existence or channel-level canonicalization theorem. S07 integration was
explicitly authorized and internally validated on 2026-09-07. The lightweight
root now exposes the semantic API, with regressions separately built. S08 was
explicitly authorized on 2026-09-07. Its independent chunk-wide validation
and completion reconciliation passed, so all S01-S08 steps are validated.
The exact approved ISIT copy was recovered and the C01 source anchors freshly
rechecked; no source redesignation or scope change was needed. C02 detailed
planning is next eligible, but requires a new prompt and has not started.
Completion does not enlarge project scope or authorize C02 implementation.
No further paper theorem is represented as formalized until its
statement, assumptions, source location, Lean ownership, and validation
evidence are recorded.
