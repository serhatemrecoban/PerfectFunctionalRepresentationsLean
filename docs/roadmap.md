# PerfectFunctionalRepresentationsLean Roadmap

This reader-facing roadmap describes where the project may go. It is
directional, not an execution contract: its ordering and workstreams remain
subject to the formalization map, and no item here authorizes theorem
implementation. Current status belongs in the
[living summary](perfect-functional-representations-living-summary.md), scope
belongs in [project scope](project-scope.md), the current dependency-aware
allocation belongs in the [formalization map](formalization-map.md), and only
an explicitly approved chunk plan may authorize implementation.

## Now: detailed planning for PFR-C01

Revision 2 of the global formalization map passed a second adversarial review
and was accepted by the project lead as the current adaptable reference. The
next activity is to prepare the detailed `PFR-C01` plan for separate approval;
no theorem implementation is authorized yet. The map:

- reconciles each in-scope ISIT statement with the current extended proof and
  clarification draft;
- frames recommended semantic contracts and the decisions still required for
  functional representations, canonical representations, perfect
  representability, priors, support, and null fibers;
- identifies candidate representations and decision gates for finite matrices
  and output-changing operations;
- records verified reusable mathlib and pinned LeanInfoTheory candidates and
  missing surfaces, subject to focused verification in each chunk plan;
- exposes the high-risk total-variation, reachability, and linear-program
  boundaries;
- proposes sixteen dependency-aware chunks with reviewable boundaries,
  explicit concurrency waves, and completion expectations;
- moves the minimal exact-partition interface before its reachability and
  decoder-fiber consumers;
- records the literal ISIT incidence-system issue, binary support/cardinality
  distinction, value-one VPS question, and operation shorthand as open design
  obligations rather than silent assumptions.

The map remains adaptable as implementation exposes better interfaces. A
separate approved chunk plan is still required before production theorem work
begins.

## Expected mathematical workstreams

The formalization map refines these reader-facing workstreams into stable
candidate chunk identifiers; this list deliberately remains higher level:

1. Semantic functional and canonical representations, followed by the
   canonicalization result.
2. Perfect representability, singularity, binary-input/output consequences,
   and the finite counterexample.
3. The binary-input total-variation and maximal-coupling characterization.
4. The finite channel-to-matrix boundary, column values and patterns, the four
   split/merge operations, and heterogeneous reachability.
5. The constructive characterization of perfect representability.
6. Pattern compression and the primal and dual linear-program
   characterizations.
7. Final paper-coverage, edge-case, API, documentation, and trust audits.

The map may reorder, combine, split, or supersede candidate chunks after their
actual dependencies and proof risks are understood, with the change recorded.

## Completion and release direction

After the mathematical development, a release-readiness phase may reconcile
the final coverage table, maintained examples, public imports, documentation,
licensing and citation metadata, and local and remote validation. No public
release or publication state is implied by this roadmap.

## Later or deferred directions

- adoption of a later tagged LeanInfoTheory release;
- reusable upstream proposals justified by concrete downstream proof pressure;
- executable decision software or certified LP-solver integration;
- extended-only algorithms, complexity results, hypergraph/coloring
  constructions, or information-measure claims that receive separate scope
  approval;
- an optional presentation layer emphasizing bits beyond the existing
  nats-to-bits conversion; and
- a public project website, DOI, and final publication metadata.

PFR currently has no website, website source, Pages configuration, hosting
configuration, or approved website plan. A website may be reconsidered during
public-release preparation; LeanInfoTheory's website is documentation for the
dependency, not a PFR website.

## Approval boundary

Future Work Notes, roadmap items, formalization-map proposals, omission
records, experiments, and proof-risk investigations do not authorize
implementation. When the project lead approves a chunk, its contract will be
stored under `docs/plans/` with a stable filename and explicit status,
baseline, scope, steps, and completion criteria. Completing one step or chunk
never authorizes the next one.
