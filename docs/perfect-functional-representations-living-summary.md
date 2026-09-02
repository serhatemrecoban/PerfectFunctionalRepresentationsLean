# PerfectFunctionalRepresentationsLean Living Project Summary

This is the canonical living project-memory document for the PFR case study.
It is an orientation and reconciliation layer, not a replacement for Lean
source, `AGENTS.md`, the paper, approved plans, or the project log.

Status labels:

- **[Current]** verified against the repository, pinned dependency, or paper;
- **[Decision]** an approved project rule;
- **[Planned]** approved scope or future work with no implementation claim;
- **[Provisional]** a design candidate requiring plan approval;
- **[History]** useful rationale that does not establish current code;
- **[Deferred]** intentionally outside current work;
- **[Superseded]** an earlier position replaced by a later decision; and
- **[Uncertain]** requiring verification before implementation.

## 0. AI Assistant Quick Start

**[Current] Mission.** This private Lean 4 repository will formalize the
six-page ISIT manuscript *On Perfect Functional Representations* by Serhat Emre
Coban, Yanina Y. Shkel, and Emre Telatar. It is a downstream case study of
LeanInfoTheory, not an extension of LeanInfoTheory's core library scope.

**[Current] State.** The repository contains a lightweight root import and one
dependency smoke-test example. No paper definition, lemma, theorem, corollary,
algorithm, or complexity claim is currently formalized. The initial source
baseline is commit `57e132c`.

**[Current] Dependency.** `lakefile.toml` pins LeanInfoTheory `v0.1.0`; the
manifest resolves it to
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`. That release uses Lean and
mathlib `v4.33.1`. Verify every upstream name against this checkout.

**[Decision] Scope.** The six-page ISIT manuscript is authoritative for target
statements. The 16-page extended manuscript is a proof supplement only. Its
extra complexity section, unproved hypergraph claim, and broader discussion do
not enter scope without separate approval.

**[Decision] Architecture.** Reuse mathlib `PMF` and LeanInfoTheory's finite
channel, entropy, information-measure, independence, and Markov APIs. Keep
paper-specific functional representations, singular channels, matrix
operations, reachability, and LP statements downstream. Canonical information
units remain nats.

**[Current] Active work.** Project bootstrap and context reconciliation are
complete. The next activity is a careful formalization map and chunk plan; no
theorem-development chunk has been approved.

Read next by task:

| Task | Read next |
| --- | --- |
| Formalization-map planning | Sections 2-8, the exact ISIT paper, and relevant extended proofs |
| Lean theorem implementation | The approved step, Sections 3-7, owning modules, and exact source statement |
| API or architecture review | Sections 3, 5, 7, 8, and targeted Git/log history |
| Dependency upgrade | Sections 1, 4, 5, and the candidate LeanInfoTheory release notes/API contract |
| General Assistant reconciliation | This whole summary, `AGENTS.md`, `docs/project-log.md`, Git state, and temporary handoffs |

## 1. Document and Repository Status

| Field | Value |
| --- | --- |
| Last reconciled | 2026-09-02 |
| Repository | `serhatemrecoban/PerfectFunctionalRepresentationsLean`, private |
| Branch | `master` |
| Initial source baseline | `57e132c` |
| LeanInfoTheory dependency | immutable tag `v0.1.0`, commit `0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f` |
| Lean/mathlib baseline | `v4.33.1` |
| Paper coverage | zero paper declarations implemented |
| Active chunk | none |
| Validation baseline | default build passed; strict project-source placeholder scan passed |

`AGENTS.md` owns stable operating instructions. This file owns canonical
cross-thread context and status. `docs/project-scope.md` owns the paper and
library boundary. `docs/project-log.md` owns chronology and rationale.

## 2. Mission, Scope, and Success Criteria

**[Decision] Primary goal.** Give kernel-checked Lean statements and proofs for
the mathematical content of the six-page ISIT paper, with explicit finite
alphabet, support, and representation contracts.

**[History] Project role.** The case study is intended to demonstrate that a
research-paper formalization can be built on the public LeanInfoTheory library.
Paper-specific constructions remain here, just as application-specific
certificate machinery belongs in its own downstream repository.

**[Decision] In scope.** Definitions 1-4, Lemmas 1-6, Theorems 1-2, Corollary
1, the non-representable example, the operation examples needed for validation,
and the finite optimization statements used by the ISIT paper.

**[Deferred] Outside current scope.** The extended manuscript's computational
complexity and hypergraph-coloring section, its unproved Claim 2, its separate
discussion of Wyner common information, excess functional information, Korner
graph entropy, and privacy funnel, and formalization of unrelated references.

**[Decision] Proof supplement.** Extended appendices may supply omitted proofs
for ISIT statements. Such use must be cited as proof support without promoting
extended-only claims into the target.

Success requires exact source traceability, no placeholders, focused module
ownership, complete builds, recorded assumptions and departures, and a final
coverage audit. It does not require executable LP solving unless separately
approved; theorem-level equivalence is the primary paper claim.

## 3. Paper Coverage Matrix

All rows are currently **planned**, not implemented.

| ISIT item | Mathematical role | Proof source | Status |
| --- | --- | --- | --- |
| Equation (1) | Functional representation: independence and deterministic decoding | ISIT I | Planned |
| Equations (2)-(3) | Mutual-information identity and perfect upper bound | ISIT I; LeanInfoTheory chain rules | Planned |
| Definition 1 | Canonical functional representation | ISIT II-A | Planned |
| Lemma 1 | Replace an arbitrary representation by an equally informative canonical one | ISIT II-A | Planned |
| Definition 2 | Channel-level perfect representability | ISIT II-A | Planned |
| Definition 3 | Singular finite channel/matrix | ISIT II-B | Planned |
| Lemma 2 | Perfect implies singular; singular is sufficient for binary input or output | ISIT II-B; extended appendix | Planned |
| Example 1 | A singular `3 x 3` channel that is not perfectly representable | ISIT II-B; extended appendix | Planned |
| Equation (9), Lemma 3 | Binary-input optimum via total variation and maximal coupling | ISIT II-C; extended appendix | Planned |
| Definition 4 | Nonzero column value and binary support pattern | ISIT III-A | Planned |
| PPS, PPM, VPS, VPM | Four operations on singular channel matrices | ISIT III-A | Planned |
| Lemma 4 | Normalize an operation cascade to PPS, then VPS, then PPM | ISIT III-A; extended appendix | Planned |
| Lemmas 5-6 | Preservation of representability/non-representability | ISIT III-B; extended appendix | Planned |
| Theorem 1 | Reach `1_k` from `M` via PPM/PPS/VPM; equivalently construct `M` from `1_k` via PPS/VPS/PPM | ISIT III-B and appendix; extended proof | Planned |
| Pattern compression and incidence matrix `H` | Reduce a singular matrix to distinct patterns and partition weights | ISIT IV-A | Planned |
| Theorem 2 | Primal LP optimum equals one iff perfectly representable | ISIT IV-A; extended appendix | Planned |
| Corollary 1 | Dual LP characterization | ISIT IV-B | Planned |
| Complexity remark | Size of LP and unresolved efficient-solvability question | ISIT IV-C | Planned - documentation only |

The formalization map must split any row whose representation or proof risk is
too large for one implementation step.

**[Uncertain] Coverage granularity.** The map must decide whether ISIT Remarks
1-2 and Examples 2-7 become formal declarations, validation fixtures, or
documentation-only coverage. It must also classify the introductory bound in
Equation (4), whose logarithm convention is unit-sensitive. This does not bring
the extended-only information-measure discussion into scope.

## 4. Source-of-Truth Hierarchy

1. Current local Lean source and successful builds establish implementation.
2. Approved plans and this summary establish current intent and status.
3. The exact six-page ISIT manuscript establishes target mathematics.
4. The extended manuscript supplies only relevant omitted proof details.
5. The pinned LeanInfoTheory source and API contract establish dependency facts.
6. Git history and targeted log entries establish historical rationale.
7. GitHub establishes remote/private/publication state.

Conflicts must be reported and reconciled. Paper prose may need a precise Lean
contract, but the assistant must not silently strengthen assumptions, suppress
zero-probability cases, or substitute a different theorem.

## 5. Available LeanInfoTheory v0.1.0 Foundations

The following public declarations were verified in the pinned release and are
likely foundations, not an exhaustive import prescription. The channel names
are in namespace `PMF`; every other name in this list is in namespace
`LeanInfoTheory.Shannon`:

- channels: `PMF.deterministicChannel`, `PMF.channelComp`,
  `PMF.channelJoint`, and `PMF.channelExtension`;
- information quantities: `entropyOf`, `condEntropyOf`, `mutualInfoOf`, and
  `condMutualInfoOf`;
- semantics: `IsIndependent`, `IsIndependentOf`, `IsMarkovChain`, and
  `IsMarkovChainOf`;
- deterministic and Markov facts:
  `condEntropyOf_eq_zero_iff_exists_function`,
  `condMutualInfoOf_eq_zero_iff_isMarkovChainOf`,
  `mutualInfoOf_deterministic_chain_rule_left`,
  `mutualInfoOf_markov_chain_rule`, and
  `mutualInfoOf_dataProcessing`.

**[Current] Missing upstream surfaces.** The release contains no dedicated
functional-representation, perfect-representability, singular-channel,
conditional-probability-matrix operation, finite-PMF total-variation, or LP
API. These are not accidental bootstrap omissions in this repository.

**[Current] Missing pinned-mathlib surfaces.** A targeted `v4.33.1` source
audit found no ready finite-PMF coupling/total-variation API and no theorem-level
linear-program structure or off-the-shelf LP strong-duality theorem.
Signed/vector-measure total variation, geometric separation machinery, and
tactic-internal simplex code do not by themselves settle the paper's required
interfaces.

Focused imports are preferred. The PFR root must not import heavy matrix or
optimization machinery merely because a late paper theorem uses it.

## 6. Stable and Provisional Design Decisions

**[Decision] Stable.** Use functions `alpha -> PMF beta` for channels, arbitrary
finite types for semantic statements when practical, right-associated products,
and LeanInfoTheory's nats convention. Make channel-to-coordinate-matrix
translation explicit.

**[Provisional] Canonical representation.** A canonical random vector over an
input alphabet `alpha` naturally has value type `alpha -> beta`; its law may be
represented as `PMF (alpha -> beta)`, with coordinate pushforwards matching the
channel rows. This is promising but requires an approved contract, especially
for the paper's `pW|Y` Markov formulation and zero-prior inputs.

**[Provisional] Layering.** Likely layers are semantic functional
representations, perfect representability/singularity, matrix compatibility,
split/merge operations and reachability, binary total variation, and LP
characterizations. Final module names and order are not approved.

**[Provisional] Matrix boundary.** A direct `Matrix (Fin k) (Fin m)` encoding
matches the paper but operations change the output dimension. The plan must
choose a type-safe heterogeneous representation or an invariant packaging; do
not bury dimension changes under casts.

**[Superseded] Earlier ownership framing.** An early readiness discussion
treated PFR-specific notions as possible LeanInfoTheory prerequisites. The
approved downstream ownership boundary replaces that framing; it is not an
active upstream proposal.

**[Decision] Upstream boundary.** Do not move paper-specific APIs into
LeanInfoTheory for convenience. A missing general theorem may be proposed
upstream only after a concrete downstream need and separate compatibility
review. PFR continues to build against `v0.1.0` until an approved release
upgrade.

## 7. Anticipated Lean and Mathematical Risks

- The paper treats the support of `X` as the whole finite input alphabet;
  channel-level perfect representability is intended to be prior-independent.
  Formal definitions must expose, not conceal, any full-support hypothesis. In
  particular, the final equivalence in binary Lemma 3 fails for a degenerate
  prior on a merely two-element ambient type.
- Canonical vectors are finite dependent products in mathematical prose but
  ordinary function types in Lean; coordinate laws and extensionality need a
  clean API.
- Split and merge operations change output types and reorder columns. The
  manuscript also gives PPM/VPM the domain `S_{k,m+1}` while quantifying merge
  indices only through `m`; the formal statement must resolve and record this
  indexing inconsistency.
- The paper takes the output alphabet to be the support of `Y`, whereas an
  ambient matrix type may admit all-zero columns for which Definition 4 has no
  value or pattern. The matrix boundary must state its nonzero-column contract.
- PMF masses are `ENNReal`, while the paper's LP is real-valued. The conversion
  boundary and finiteness/nonnegativity obligations require deliberate design.
- Neither LeanInfoTheory nor pinned mathlib has a ready finite-PMF
  total-variation/coupling API. Lemma 3 may need a local definition and
  maximal-coupling development or an explicit bridge to general measure theory.
- Conditional and Markov statements must handle null fibers consistently.
- Theorem 1 mixes semantic existence with combinatorial matrix reachability;
  explicit equivalence and relabeling lemmas will likely dominate the proof.
- Theorem 2 and Corollary 1 require an explicit optimization contract. Because
  pinned mathlib has no ready LP strong-duality layer, the plan must compare a
  specialized separation/Farkas-style proof with a separately scoped local
  duality development before either statement is approved.

## 8. Active and Deferred Work

**Active next planning work:**

1. Audit each ISIT statement and its extended proof supplement.
2. Approve the semantic definitions and prior/support contract.
3. Choose the channel-to-matrix representation and heterogeneous operation
   model.
4. Audit mathlib and LeanInfoTheory `v0.1.0` for each required bridge.
5. Produce and review a chunked formalization map with explicit completion
   criteria.

**Standing deferred work:**

- LeanInfoTheory dependency upgrades;
- generally reusable upstream proposals discovered by real proof pressure;
- executable decision software or certified LP solver integration;
- extended-only complexity, hypergraph, and information-measure sections;
- public website, release, DOI, and final legal metadata;
- a bit-valued presentation layer beyond existing nats-to-bits conversion.

## 9. Validation and Trust State

At bootstrap and again during the 2026-09-02 initialization audit, `lake build`
completed successfully with 2,605 jobs against the pinned dependency. The
strict project-source placeholder scan returned no matches. The project Lean
sources are a lightweight `PerfectFunctionalRepresentations.lean` root and
`PerfectFunctionalRepresentations/Basic.lean`; the latter's only substantive
content is a smoke-test example importing `LeanInfoTheory.Shannon.Entropy` and
applying `entropy_nonneg`.

The same audit built the focused channel and Markov modules and compiled
`#check`s for all 17 declarations named in Section 5 under their exact
namespaces.

Future Lean steps must run focused owner/downstream builds. Milestones require
the default build, placeholder scan, diff and import audit, documentation
reconciliation, and repository-hygiene check. Approved axioms must be audited
explicitly before any release claim.

## 10. Reference and Provenance Boundary

Reviewed copies of both manuscripts live outside the repository. Any local
working copies placed inside the project must remain under ignored reference
directories and must not be committed.

**[Uncertain] Release metadata.** The exact bibliographic record, publication
status, rights holder, source-file header, and citation metadata remain subject
to project-lead verification before public release.

**[History] Provenance attestation.** The inherited-context report records that
no external information-theory formalization repository was consulted or
reused before this audit; this audit likewise consulted none. Non-consultation
is an attestation rather than a fact independently provable from Git history.
Existing implementation code outside this repository is not a source unless
the project lead explicitly authorizes consultation and attribution is
recorded.
