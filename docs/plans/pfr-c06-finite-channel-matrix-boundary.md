# PFR-C06 - Finite Channel-to-Matrix Boundary

<!-- pfr-review-status:start -->
**Status:** Approved; S01-S05 durably complete. S06 fresh cumulative independent review and reconciliation complete; final applicable validation/F/durable chunk closure follow this checkpoint.
**Revision:** Draft revision 2, 2026-09-19.
**Authority:** On 2026-09-19, after endorsing this exact revision, the lead
requested S01 with its review process. This approves Draft revision 2's
unchanged normative contract and authorizes S01 only. The delivered draft
and actual request are preserved in `.pfr-review/setup/c06-s01-20260919/`.
No independent plan review has been requested or claimed. The lead then
requested S02 with review conditional on completed S01. Its actual closure and
all 96 final inventory entries were verified before S02 was selected; records
are in `.pfr-review/setup/c06-s02-20260919/`. On 2026-09-20 the lead separately
approved the narrow finding-ID recovery and completion of S02 closeout;
records are in `.pfr-review/setup/c06-s02-identity-recovery-20260920/`.
Conditional S03-S06 requests were processed while S02 was unclosed and skipped;
they remain consumed. Later steps require fresh requests. No dependency change,
commit or push is authorized.
**Reviewer:** `/root/pfr_c06_reviewer`, exclusively bound to originating task
`01a0b902-b394-7493-a9d8-8a5216ee86d7` (role `/root`). Requested
`gpt-6-astra` / `ultra` / `fork_turns: "none"`; effective settings unknown.
The original S01 assessment satisfies all three step criteria and is reconciled;
its optional editorial finding is resolved and S01 durably closed under
`5b7ba14bd996ef54e0f677b6fbf14668b857e230cb3e568b0ff36c18a1b88096`.
The same reviewer independently satisfied all three S02 criteria. Its original
report and identity-only clarification are retained; the accepted original is
reconciled under `2e765ce5b466971db7b305e6fcce72f0821142397c6cc58f9c9dd3cf14366e73`.
The separate S02 editorial observation uses its corrected fresh ID; S01's
finding and closure remain unchanged. Final validation, F and durable closure
follow this checkpoint in the execution session. See
[implementation notes](../pfr-c06-implementation-notes.md).
**Current reconciliation, 2026-09-20:** The preceding S02 checkpoint was followed
by durable closure `a2595df99036e9214753b19c81c29901437d71772c629620904ec16f692dfd7e`.
The fresh S03-with-review request was accepted only after checking all three
independent/parent criteria, original-report reconciliation, resolved finding,
and all 97 final source/environment entries. S03 alone now implements active
states, finite presentations and transport; no earlier skipped request was
re-armed. Records: `.pfr-review/setup/c06-s03-20260920/`.
**S03 review checkpoint:** The same bound reviewer independently satisfied
all three S03 criteria with one optional editorial finding. The complete original report is
retained and critically reconciled. Final applicable validation, F capture
and durable closure are subsequent installed-session operations; this
checkpoint does not certify their completion. No later step has started.
**S04 authorization, 2026-09-20:** S03's preceding checkpoint was followed by
actual durable closure `35c91f22d348feef566b11d7829b8b8a1efe1f67239a737848da4027b36bef61`.
The fresh conditional S04 request was accepted after verifying its original
report/reconciliation, all satisfied criteria, resolved finding and all 97
final source/environment entries. S04 alone is authorized, with the same
bound reviewer and unchanged normative contract. Records:
`.pfr-review/setup/c06-s04-20260920/`. S05-S06 remain unstarted.
**S04 review checkpoint:** The same bound reviewer independently satisfied all
three S04 criteria with no findings. The complete original report is retained
and critically reconciled. Final applicable checks, F capture and durable
closure are subsequent installed-session operations, not certified here.
**S05 authorization, 2026-09-20:** S04's preceding checkpoint was followed by
durable closure `f76be6e91550d0b217d02fececf3d2b4e0287dd346aa86026522298c36f1fe99`.
Its original report/reconciliation, all satisfied criteria, absence of findings
and all 99 final source/environment entries were verified before the fresh
conditional S05 request was accepted. S05 alone adds the Definition 4 fixture
and integrated readiness audit; the same reviewer and normative revision 2
remain in force. Records: `.pfr-review/setup/c06-s05-20260920/`.
See the [readiness audit](../pfr-c06-readiness-audit.md); S06 remains unstarted.
**S05 review checkpoint:** The same bound reviewer independently satisfied
all three S05 criteria with no findings. The complete original report is
retained and critically reconciled. Final applicable checks, F capture and
durable step closure follow this checkpoint as subsequent installed operations.
**Revision history:** Revision 1 is preserved privately. See the
[selection rationale](../pfr-c06-planning-notes.md#draft-revision-2-selection-and-rationale)
for merged suggestion references, dispositions and evidence limits.
**Prerequisites:** C01-C05 complete; mapped mathematical prerequisites are C02
and C03. Startup checked original durable closure/reconciliation and exact
prerequisite-source applicability. Closed plans and preclosure checkpoints are
retained. See [planning notes](../pfr-c06-planning-notes.md).
**S06 authorization, 2026-09-20:** S05's preceding checkpoint was followed by
durable closure `7a4efd66291362a6626ad59c84edfb863e049517630638ffe298ea608f79421b`
and F `827d8f6ec6f9e6dc81d3309b633a6aee7d5e87824b3c801efdd8ca28ece46769`.
All five durable predecessor records, original independent assessments and
reconciliations, plus all 101 immediate final source/environment entries, were
verified before processing the fresh S06 request. This request arrived during
authorized S05 closeout and was held unprocessed until closure; no consumed
request was re-armed. The same reviewer and normative revision 2 remain in force.
S06 is cumulative validation/closeout only; C07 remains unapproved and unstarted.
Records: `.pfr-review/setup/c06-s06-20260920/`.
**S06 independent-review checkpoint:** At R `4a25416709ee055f3ad62ca8a970c4fc5f5e85927f7252a5bb6c1f81ae01d1c5`,
the same reviewer independently satisfied C06-S06-C01/C02/C03 and explicitly
assessed all fifteen earlier criteria, R01-R16 and CC01-CC10, with no findings.
The complete original report is retained and critically reconciled. Final
applicable validation, source-impact checks, F capture and supported durable
closure are subsequent duties; this checkpoint does not certify those events.
C07 remains unapproved and unstarted.
<!-- pfr-review-status:end -->

## 1. Baseline, authority and scope

Planning baseline: HEAD `54c1714d1a9a891939d6c9f7d38c0d05896b2c75`, with
inherited tracked and untracked C02-C05 work preserved. The actual working
tree, not HEAD alone, is the mathematical baseline. LeanInfoTheory remains
immutable `v0.1.0`, commit `0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`;
Lean is `v4.33.1`, mathlib `v4.33.1` at
`0df444a360eaa60ab8c11dca51a86af692955474`. Installed dependencies are clean.
The exact startup inspection and source hashes are privately retained under
`.pfr-review/setup/c06-planning-20260919/`.

C06 supplies the finite coordinate boundary, active state, nonzero singular
column data, and Definition 4 fixture. Semantic channels remain
`alpha → PMF beta`. Matrix views and matrix-to-channel constructors prove
coordinate equivalence; they do not own a parallel probability theory.

Non-goals: PPS/PPM/VPS/VPM, their inverses or examples 2-5; cascades, operation
relations or reachability; pattern compression or distinct-pattern hypotheses;
partitions, incidence systems or LPs; further information inequalities;
executable algorithms; changes to C01-C05 mathematics; dependency upgrades.
Downstream map entries C07-C13 inform interfaces only. The existing lightweight
root remains free of matrix and optimization imports.

## 2. Manuscripts and interpretation contract

The root authenticated and visually read the relevant pages of these exact
local binaries; they remain external/ignored, not repository artifacts:

| Source | Identity | C06 anchors |
| --- | --- | --- |
| Six-page ISIT final manuscript, local filename ending `final_manuscript_ (3).pdf` | SHA-256 `48963AA59485B2C33B1A1E6E7C6EAD2251FDDDD26BD3691B6FCFFE683E6ED1C4` | Section III opening across PDF pp. 2-3; III-A matrix paragraph, Definition 4 and its Example 1 sentence on p. 3 |
| Current approved eighteen-page extended draft, local version 16, designated 2026-09-03 | SHA-256 `98636D4C9F0618EC08FCA84559572780F604F197FDA90D8D7C787B3624245B8F` | Section III opening and III-A opening/Definition 4 on p. 3; neighboring operations on pp. 3-4 inspected only for interface boundaries |

ISIT Section II opening on p. 2 supplies the positive support-cardinality
convention; Definition 3's matrix sentence and Example 1 Equation (8) on that
page are prerequisite/fixture anchors, not new C03 proofs. The extended
Definition 4 agrees with the ISIT statement; no new extended-only claim enters
scope. Reauthenticate affected contracts if the designated companion changes.

Printed: a `k × m` conditional matrix has input rows, output columns, and
column `j` is `p(Y=j | X=·)`. The paper works on positive support alphabets,
calls all equal positive entries in a singular column its value, and defines
its pattern by division by that value.

Intended: each admitted column has a positive entry. Its value is unique,
lies in `(0,1]`, and its normalized column is a nonzero 0/1 vector. Zero
entries inside a nonzero column are permitted. Equal patterns in different
columns are permitted; no compression has occurred.

Proposed Lean contract: active outputs are intrinsic unions over all channel
rows. They are not identified with the output law of an arbitrary input prior.
If relating to a pair, use C03's explicit full-input-support identification,
or C02's restriction to the prior's input support. No prior, entropy, full-row
support, or strictly positive matrix-entry assumption is needed for C06.
Paper labels `1,...,k` and `1,...,m` become `Fin k` and `Fin m`, with label 1
represented by 0. Reconstruction and division bridges below preserve the
printed mathematical content.

## 3. Proposed decisions and representation

All names introduced in this section are **proposed**, not existing verified
declarations. Names may be improved during an authorized step without changing
the contracts. Verified reuse is listed separately in Section 5.

### DG-06: dependent active channel record

Recommend a small `ActiveFiniteChannel alpha` record, with `[Finite alpha]`
and `[Nonempty alpha]` at its public boundary and fields:

```text
outputCard : Nat
outputCard_pos : 0 < outputCard
channel : alpha → PMF (Fin outputCard)
output_active : ∀ j, ∃ x, channel x j ≠ 0
```

This packages the useful heterogeneous content of a Sigma while naming its
invariants. Two states may have different output cardinalities with the same
input type. The positivity field is deliberately explicit even though a
nonempty-input PMF channel already forces a nonempty output type. Do not
store chosen input points, priors, independent matrices, or column values.
Singularity is a separate premise on `state.channel`, not a field: coordinate
and activity bridges apply to all channels, and later operations can require
singularity. The paper's `S`/`S_{k,m}` is presented by states with that premise
and, where needed, an explicit output-cardinality condition. No new singular
state wrapper is required merely to mimic the set notation.

Reject a bare Sigma: it omits the active/positive boundary. Reject a primary
rectangular stochastic-matrix record: it duplicates normalization ownership.
Mathlib's square stochastic-matrix predicate is not the channel carrier.
Do not quotient output labels: explicit equivalences retain column order for
C07. C08 will decide its operation/path endpoint relation, consuming C06's
transport facts rather than requiring an equivalence-relation framework now.

### DG-07: raw coordinates versus admitted columns

Raw coordinate maps accept arbitrary semantic channels, including ambient
zero columns and empty input types where the raw function type is meaningful.
The active record excludes empty input, zero output cardinality and every
globally zero column. A PMF row over an empty output type cannot exist.

An admitted column of an arbitrary channel is indexed by
`y : activeOutputs kappa`, reusing C03, or by an equivalent explicit nonzero
column witness. State columns automatically meet this condition. The public
Definition 4 value requires both that admission and `IsSingularChannel kappa`.
Its support pattern is nonempty. No value or Definition 4 pattern accessor is
totalized on zero columns, and no fallback value 0 or empty pattern is used.

### DG-10, C06 portion: exact masses and derived Real coordinates

For `kappa : alpha → PMF beta`, propose
`massMatrix kappa x y = kappa x y : ENNReal` and
`realMatrix kappa x y = (kappa x y).toReal : Real`.
Rows are inputs and columns are outputs in both views. Each mass is finite,
at most one; each Real entry lies in `[0,1]`; finite rows sum to one.

Reconstruction is two-sided, not just a view lemma:

1. Given `M : Matrix alpha beta ENNReal`, `[Fintype beta]` and
   `∀ x, ∑ y, M x y = 1`, apply `PMF.ofFintype` rowwise. Its exact mass
   matrix is `M`, and reconstructing the mass view of a channel returns that
   channel. Entry finiteness and the upper bound follow from normalization;
   no extra artificial finiteness hypothesis is needed.
2. Given `A : Matrix alpha beta Real`, entrywise `0 ≤ A x y` and row sums
   one, apply the first constructor to `ENNReal.ofReal` coordinates. Prove
   its Real view is exactly `A` and that the Real view of an existing channel
   reconstructs that channel. `ENNReal.ofReal (realMatrix kappa x y)` equals
   its exact mass. Thus the Real view is injective on channels.

These are functions and inverse theorems, not another semantic probability
structure. Arbitrary matrices need their normalization/nonnegativity proofs;
the proof is not supplied by the matrix type alone. C12 retains aggregation of
equal patterns, compressed-data validity and optimization-weight interfaces.
Approval of this plan would settle only C06's portion of DG-10.

### Singularity in coordinates

Use one small project-owned column predicate (proposed `HasSingularColumns`)
on `Matrix alpha beta R` with `[Zero R]`:
`∀ x1 x2 y, M x1 y ≠ 0 → M x2 y ≠ 0 → M x1 y = M x2 y`.
This generic notation serves the two numeric views; it is not a new general
matrix theorem hierarchy. Document explicitly that it is unrelated to a
determinant or rank. Prove equivalence to `IsSingularChannel kappa` for the
exact view and the Real view, including the positive-entry/product reading
on nonnegative coordinates. Zero columns make the predicate vacuous, but do
not become admitted Definition 4 columns.

### Finite alphabets, activity and relabeling

For finite nonempty input and arbitrary finite ambient output `beta`:

- Restrict using C03's `restrictActiveOutputs`; retain its exact atom formula
  and inclusion-map recovery, with no scaling or new restriction construction.
- Enumerate that active subtype by an explicit equivalence with `Fin m`,
  where `m` is its cardinality; prove `m > 0`, all state columns active, and
  recover the ambient channel by mapping back and including the subtype.
  An injective output extension may create zero columns outside its image;
  prove their zero coordinates and return to an active state by restriction
  and enumeration. Compare the result with an active presentation of the
  original channel, or directly with the original state when it was already
  active, using an explicit output equivalence. Do not compare the reduced
  alphabet with an ambient alphabet that still contains unused labels.
  The unreduced extension is not falsely packaged as an active state.
- If the ambient channel is already active, also offer the direct finite
  enumeration and inverse-map round trip, preserving its given labels via
  an explicit equivalence. Do not claim ambient zero labels are in bijection
  with fewer active labels: the recovery there is an injection plus PMF.map.
- Transport along `eX : alpha ≃ alpha'` and `eY : beta ≃ beta'` using
  `kappa' x' = (kappa (eX.symm x')).map eY`. Prove
  `M' (eX x) (eY y) = M x y` in both numeric views, and the matching
  `Matrix.reindex eX eY` identity. Prove inverse/identity/composition recovery
  in the strength needed to compare coordinate presentations.
- Different enumerations of the same active alphabet give states related by
  their explicit output equivalence. For such presentations `A` and `B`
  over the same input type, provide `e : Fin A.outputCard ≃ Fin B.outputCard` with
  `∀ x, (A.channel x).map e = B.channel x`, and its exact atom identity.
  This is the required presentation comparison, not literal equality of
  dependent records or a new quotient/equivalence-relation framework.
  Preserve/reflect singularity and channel perfect representability
  using C03's iff theorems. The input/output `Fin` presentation is a proved
  corollary, not an assumed identification or a cast hiding dimension changes.

Public semantic bridges use `[Finite]` when enumeration is internal; sums,
patterns and exposed cardinals use `[Fintype]`. Choose classical instances
locally. Input and ambient output universes may differ. No mathematical
`DecidableEq`, chosen default label or `Inhabited` requirement may leak into
the public semantic contracts merely for proof convenience.

### Values, patterns, uniqueness and reconstruction

For admitted `y` and singular `kappa`, define `columnValue` in `ENNReal` from
any positive entry and prove independence of the chosen input witness.
It satisfies `0 < v`, `v ≤ 1`, `v ≠ ∞`, and every nonzero entry equals `v`.
The Real value is `v.toReal`, with `0 < v.toReal ≤ 1` and exact ofReal recovery.
Do not make `v < 1` a hypothesis; value-one columns are required.

Recommend the core pattern representation `{s : Finset alpha // s.Nonempty}`,
implemented using a local classical instance and the finite set of inputs
with nonzero mass in that column. Its membership theorem is exactly
`x ∈ s ↔ kappa x y ≠ 0`. It is a support set over inputs, not a PMF support
finset: column entries need not sum to one. A named alias is optional; do not
add an independent vector/Boolean owner or a bundled pattern algebra.

Required identities and uniqueness:

- `kappa x y = if x ∈ s then v else 0` and the corresponding Real identity.
- The derived Boolean membership vector and numeric 0/1 indicator agree.
  In particular, `realMatrix kappa x y / v.toReal = if x ∈ s then 1 else 0`.
  This is Definition 4's division formula, with nonzero denominator proved.
- If another nonempty finite set `t` and positive value `w` reconstruct the
  same column by this formula, then `t = s` and `w = v`. The corresponding
  Real uniqueness follows with positive Real values. No uniqueness is
  asserted for zero values or empty patterns.
- On an active finite singular channel, summing reconstructed columns gives
  `∑ j, (if x ∈ s_j then v_j else 0) = 1` in exact and Real coordinates.
  The data recover the entire channel, and equal data on the same indices
  imply equality by the coordinate inverse. Duplicate patterns are allowed.
- Conversely, for `[Fintype alpha] [Nonempty alpha] [Fintype beta]`, any family
  indexed by `beta` of nonempty input finsets and strictly positive
  ENNReal values with these weighted row sums constructs an active
  singular channel through the existing coordinate constructor and recovers
  exactly its supplied values/patterns. For each column, an input in its
  nonempty pattern makes its value a summand of a normalized row. Derive
  `v_j ≤ 1` and hence `v_j ≠ ∞`; neither is an extra premise of the main
  converse. Equivalent assumptions `0 < v_j ≤ 1` are acceptable in a
  convenience consumer. This checks reconstruction without introducing a
  compressed-data or LP structure.
  Nonempty output follows from a normalized row; no separate output-default
  assumption is needed. The total sum of all column values need not be one:
  only the per-input weighted row sums are normalization conditions.
- Under input relabeling, patterns map by `Finset.map eX.toEmbedding` and
  values are unchanged. Under output relabeling, column data are permuted
  at `eY y`. Active restriction and enumeration preserve the same data.
  Assertions must compare actual transported channels and column indices.

## 4. Module and API ownership

| Proposed file | Ownership and imports |
| --- | --- |
| `PerfectFunctionalRepresentations/Matrix/Channel.lean` | Exact/Real coordinates, reconstruction, column-singularity predicate/bridges, active state and finite reindexing. Focused `LeanInfoTheory.Probability.Finite`, `Mathlib.LinearAlgebra.Matrix.Defs`, and finite-equivalence imports as needed; C03 `Semantics.Singularity` once its predicates/transport are used. |
| `PerfectFunctionalRepresentations/Matrix/SingularColumns.lean` | Admitted values/nonempty patterns, uniqueness, division/reconstruction and data transport. Imports Channel and only additional finset/numeric lemmas actually needed. |
| `PerfectFunctionalRepresentations/Tests/Matrix/Channel.lean` | Coordinate, cardinality, activity, transport and prior-boundary regressions. |
| `PerfectFunctionalRepresentations/Tests/Matrix/SingularColumns.lean` | Values, patterns, uniqueness, reconstruction and transport consumers. |
| `PerfectFunctionalRepresentations/Tests/Examples/Nonrepresentable3x3Columns.lean` | Definition 4 fixture consuming existing C03 example and new columns module. No edits needed to the closed C03 fixture. |

All public declarations stay in `PerfectFunctionalRepresentations`. These two
production modules are separately importable; no new broad matrix aggregate is
required. No production import of Tests or Examples. No matrix import in
`PerfectFunctionalRepresentations.lean`. Prefer `Matrix.Defs` to the heavier
`Matrix.Reindex` module, whose imports include determinant machinery. Keep
choice witnesses, enumeration bookkeeping and one-use inequalities private.
Public promotion requires a real consumer, not symmetry or naming convenience.

## 5. Verified reuse and feasibility evidence

The planning notes retain the exact successful discovery command and results.
The inventory probe only checks installed declarations and constructor
applications; it does not implement C06 results. Source and signatures were
checked against the actual pins, including the LeanInfoTheory API inventory,
declaration index, theorem highlights and module guide. No external
information-theory formalization repository was consulted.

| Verified surface | Intended reuse |
| --- | --- |
| PFR `activeOutputs`, `restrictActiveOutputs`, `restrictActiveOutputs_apply`, `map_val_restrictActiveOutputs`, `activeOutputs_nonempty`, `activeOutputs_restrictActiveOutputs` | Exact intrinsic active subtype and normalized PMF restriction, already implemented using `bindOnSupport`, without renormalization |
| PFR `isSingularChannel_restrictActiveOutputs_iff`, `isPerfectlyRepresentableChannel_restrictActiveOutputs_iff` | Both predicate bridges back to ambient labels |
| PFR `isSingularChannel_relabel_iff`, `isPerfectlyRepresentableChannel_relabel_iff`, and both `..._map_iff` theorems | Finite input/output equivalences and unused-output injections |
| PFR `IsSingularChannel`, `isSingularChannel_iff_mul_pos`, `IsPerfectlyRepresentableChannel.isSingular` | Semantic predicate, positive-product form and existing necessity; no new necessity proof |
| PFR `support_sndMarginal_channelJoint_eq_activeOutputs_of_fullSupport` | Explicit support-sensitive pair interpretation; use only with its hypothesis |
| PFR `inputSupportPrior`, `mem_support_inputSupportPrior`, `map_val_inputSupportPrior`, `channelJoint_inputSupportPrior_map_val`, `isPerfectlyRepresentablePair_channelJoint_iff_inputSupportPrior`, `isPerfectlyRepresentablePair_channelJoint_iff_restrict_support` | Existing arbitrary-prior input-support boundary for R16; do not delete unseen inputs in a theorem about the original intrinsic channel |
| PFR `nonrepresentable3x3`, `nonrepresentable3x3_apply`, `nonrepresentable3x3_isSingular` | Exact existing fixture and row/column orientation |
| Mathlib `PMF.ofFintype`, `PMF.ofFintype_apply`, `PMF.ext`, `PMF.tsum_coe`, `PMF.coe_le_one`, `PMF.apply_ne_top` | Rectangular exact reconstruction, extensionality, normalization and finiteness |
| LeanInfoTheory `PMF.toReal_nonneg`, `PMF.toReal_le_one`, `PMF.sum_toReal` in `Probability.Finite` | Already available Real bounds and normalization; do not reprove generic versions |
| LeanInfoTheory `PMF.map_apply_equiv`, `PMF.map_apply_of_injective`, `PMF.map_apply_eq_zero_of_notMem_range`; mathlib `PMF.map_comp`, `PMF.map_id` | Exact relabeling, ambient zero columns and recovery |
| Mathlib `ENNReal.ofReal_toReal`, `ENNReal.toReal_ofReal`, `ENNReal.toReal_eq_toReal_iff'`, `ENNReal.toReal_pos`, `ENNReal.toReal_ne_zero`, `ENNReal.ofReal_sum_of_nonneg`, `ENNReal.toReal_sum` | Checked numeric conversions with explicit non-top/nonnegative premises |
| Mathlib `Fintype.equivFin`, `Fintype.equivFinOfCardEq`, `Fintype.card_pos_iff`, `Fintype.ofFinite` | Explicit finite presentations and positivity |
| Mathlib `Matrix.reindex`, `Matrix.reindex_apply`, `Matrix.reindex_refl_refl`, `Matrix.reindex_symm`, `Matrix.reindex_trans` | Coordinate orientation and presentation recovery |
| Mathlib `Finset.filter_nonempty_iff`, `Finset.mem_filter`, `Finset.Nonempty.map`, `Finset.map_injective`, `Finset.ext` | Nonempty support patterns and input equivariance |

`PMF.supportFinset` is available but is **not** a column-pattern constructor:
it applies to a normalized PMF over its alphabet, while a column is a function
of inputs without column-sum normalization. Reuse finset operations directly.
No genuine discoverability friction or new upstream request was found.

## 6. Dependency-driven implementation steps

Each step requires its own request after approval of this exact contract.
Complete the fixed step and its review/validation, report and stop. No later
step starts automatically. The split follows the exact numeric foundation,
derived numeric/semantic bridge, active carrier, Definition 4 data, integration,
and independent cumulative acceptance; it is not a declaration-count quota.

### PFR-C06-S01 - Exact rectangular coordinates and reconstruction

Prerequisites: approved C06 plan; current C02/C03 source applicability verified.
Implement Section 3's exact mass view and rowwise `PMF.ofFintype` reconstruction
in Channel, with bounds, finiteness, normalization, extensionality and both
round trips. Keep alphabets as general as each statement permits. Start the
Channel tests with R01/R02 and raw empty-boundary portions of R04.

- **C06-S01-C01:** Exact entries, input-row/output-column orientation, mass
  finiteness/bounds and finite row sums are proved for arbitrary rectangular
  channels using the pinned PMF API.
- **C06-S01-C02:** Every ENNReal matrix with normalized finite rows reconstructs
  a channel with exactly those entries; both inverse laws and channel
  extensionality hold, including meaningful raw empty-boundary cases.
- **C06-S01-C03:** Focused and downstream builds, required regressions and
  public signature/axiom/import audits pass; source coverage and numeric
  premises are documented without placeholders or a second probability owner.

### PFR-C06-S02 - Derived Real view and coordinate singularity

Depends on S01. Implement Real bounds/sums and both Real reconstruction
directions, then the two coordinate singularity equivalences and positive
reading. Extend Channel tests with R03 and the singular/zero-column portions
of R06/R07. Non-top premises come from PMF masses or normalized row sums.

- **C06-S02-C01:** Real coordinates lie in `[0,1]`, sum to one, recover exact
  masses by ofReal, and yield two-sided reconstruction/injectivity under the
  precise nonnegativity and normalization premises for arbitrary Real input.
- **C06-S02-C02:** Semantic singularity is equivalent to singular columns in
  both numeric views and to their positive formulation; vacuous zero columns
  and unequal positive entries are tested without determinant semantics.
- **C06-S02-C03:** Relevant builds, R01-R03 and assigned R06/R07 portions,
  signature/axiom/import checks pass, and DG-10's local versus C12 boundary
  and all conversion hypotheses are accurately documented.

### PFR-C06-S03 - Active states, finite presentations and transport

Depends on S01/S02 and C03 activity/invariance. Add the dependent active record,
arbitrary finite ambient-to-active-to-Fin construction, direct active
enumeration, and recovery. Prove exact reindexing and predicate invariance,
including independence of chosen enumerations by explicit output equivalence.
For R06, check the complete injection, off-image zero coordinates, active
restriction, re-enumeration and comparison with the original active
presentation. S04 adds the corresponding transported column data.
Consume existing semantic transport rather than rebuilding common posteriors.
Add R04-R11/R16 as allocated below.

- **C06-S03-C01:** The state explicitly enforces nonempty finite input,
  positive output cardinality and nonzero columns without requiring
  singularity. Arbitrary finite ambient channels produce such states through
  exact C03 restriction, and mapping back recovers their full rows. The full
  R06 unused-output extension/recovery chain is checked, including its
  comparison of active presentations rather than unequal ambient alphabets.
- **C06-S03-C02:** Direct active/Fin round trips, arbitrary-finite and distinct
  universe consumers, input/output reindex orientation, inverse/composition
  and enumeration comparison by the stated mapped-channel equation are proved.
  R10 includes direction-distinguishing three-cycles separately on inputs and
  outputs. Singularity and channel perfectness are preserved/reflected;
  no prior or hidden full-support premise is added.
- **C06-S03-C03:** Empty/singleton/rectangular/zero-column/nonsingular and
  degenerate-prior regressions, focused/downstream builds and API/trust/import
  audits pass. State assumptions and all remaining later-chunk gates remain
  visible in maintained documentation.

### PFR-C06-S04 - Admitted singular column values and nonempty patterns

Depends on S02/S03. Implement Section 3's value/pattern contracts in
SingularColumns: witness-independent values, support finsets, exact/Real
bounds, division indicator, uniqueness, weighted row sums, data reconstruction
and equivariance. Reuse S01/S02 to reconstruct PMFs; do not add a compressed
pattern-data structure. Add R05/R12-R14 and data-transport R06/R10/R11 consumers.

- **C06-S04-C01:** Every admitted nonzero singular column has a uniquely
  determined positive value at most one and nonempty input-support pattern,
  with exact membership/entry formulas. No zero-column or nonsingular value
  is invented; value one and repeated patterns remain permitted.
- **C06-S04-C02:** The exact and Real reconstruction, Definition 4 division,
  uniqueness, normalized family-to-channel converse and row-sum identities
  are proved, deriving the converse's value bounds/finiteness from its
  nonempty patterns and row sums. Input/output relabeling, active restriction
  and finite enumeration transport the actual data correctly, including
  the full R06 unused-output recovery chain and direction-sensitive R10 cases.
- **C06-S04-C03:** Required value/pattern and transport regressions,
  focused/downstream builds, signature/axiom/import checks and coverage notes
  pass; helpers remain local unless a concrete consumer justifies promotion.

### PFR-C06-S05 - Definition 4 fixture and integrated readiness

Depends on S01-S04. In the new example-test module consume C03's existing
channel and prove R15: first column (Lean output 0) has ENNReal and Real value
`1/2`, support pattern `{0,1} : Finset (Fin 3)`, Boolean pattern
`[true,true,false]` and ordered numeric pattern `[1,1,0]^T`. Check both raw
coordinates and a direct active-state package of this same `Fin 3` channel,
with `outputCard = 3` and labels unchanged; the tested state column is also
0. Prove activity from the existing entries. Arbitrary active enumeration
is tested separately through R11 and does not redefine this fixture's index.
No new proof of nonrepresentability or duplicate channel definition. Finish
all regression consumers and a cumulative source/criterion/coverage readiness audit.

- **C06-S05-C01:** The focused Definition 4 fixture consumes the actual C03
  channel and new value/pattern/division API, with the exact first-column
  orientation and all stated exact, Real and ordered-vector equalities.
- **C06-S05-C02:** Every R01-R16 obligation and all earlier step criteria
  have evidence linked to current declarations/consumers. All new modules
  and important existing downstream aggregates build, and public signatures,
  axioms, imports and lightweight-root isolation are audited.
- **C06-S05-C03:** A maintained C06 readiness audit maps CC01-CC10 and source
  anchors, omissions, validation and remaining gates. Documentation is
  coherent, inherited records/source are preserved, and no later-chunk
  operation/compression/partition/LP implementation has entered scope.

### PFR-C06-S06 - Fresh independent cumulative validation and closeout

Depends on durable completion of S01-S05 and a separate request. No routine
new theorem family belongs here. Freshly inspect the entire C06 source and
manuscript contract, then use the same bound reviewer for a cumulative review
covering all fifteen earlier criteria, R01-R16 and CC01-CC10. Earlier favorable
step reports are historical evidence, not substitutes for this fresh pass.

- **C06-S06-C01:** Fresh cumulative source/manuscript/hypothesis and
  regression review establishes CC01-CC08 and accounts for every earlier
  mathematical criterion and corresponding regression,
  including coordinate reconstruction, support restrictions, finite/universe
  transport, numeric bounds and Definition 4.
- **C06-S06-C02:** Fresh cumulative builds and trust/placeholder/API/import/
  hygiene/documentation audits establish CC09 and CC10's closeout-readiness
  evidence, accounting for every earlier validation criterion. Reused,
  inherited or unavailable evidence is explicitly qualified.
- **C06-S06-C03:** The independent original report supplies explicit
  assessments of all required criteria/outcomes and material findings with
  source/evidence provenance, adequate for subsequent implementer
  reconciliation. It must not certify that its own later reconciliation,
  final F capture or durable closure has already occurred.

**Ordered duties after the report (required for completion):** retain the
complete original report; critically reconcile its findings and criterion
assessments; resolve material findings and gaps through the installed protocol,
with justified in-scope corrections and linked further independent assessment
where changes or missing assessments require it; finalize canonical documents
with truthful provisional closure wording; run final applicable validation and
source-impact checks; capture F; record exact final applicability and obtain
the supported durable closure record; report C06 only and stop. An implementer
check cannot replace a missing reviewer assessment; every required outcome
must receive a satisfactory explicit independent assessment before completion.
Documents captured by F are not silently edited after closure; subsequent
status reconciliation cites the durable record. C07 remains unapproved and unstarted.

If closeout exposes substantive missing mathematics, weakening, scope or
acceptance decisions, stop for the lead under the installed protocol rather
than declaring completion. Bounded in-scope corrections require affected
revalidation and renewed independent assessment when applicability changes.

## 7. Regression and edge-case obligations

These are mathematical consumer obligations, not one required theorem name
per row. Several may share a fixture; they must actually exercise the public
contracts. Impossible cases need a checked rejection/contradiction or precise
signature audit, not manufactured PMFs or untested prose.

| ID | Required consumer or check | Owner |
| --- | --- | --- |
| R01 | A rectangular `k ≠ m` channel: exact orientation, atom bounds/finiteness and row sums | S01 |
| R02 | Exact normalized-matrix reconstruction and both round trips, checking pointwise data and channel equality | S01 |
| R03 | Real reconstruction in both directions, ofReal/toReal recovery, and singularity equivalence; invalid nonnegative/normalization premises are not silently omitted | S02 |
| R04 | Raw empty-input semantics distinguished from rejected empty active input; no nonempty-input PMF channel with zero output cardinality; no active zero columns | S01 raw; S03 state |
| R05 | Singleton input and singleton output, with full/singleton patterns as applicable; value-one columns admitted | S03 state; S04 data |
| R06 | Complete unused-output recovery chain: injectively extend an active channel into an alphabet with unused labels, prove off-image zero coordinates, restrict using C03, re-enumerate, and compare with the original state by an explicit output equivalence and mapped-channel equation. Check exact/Real masses, predicate invariance and transported Definition 4 data only on admitted labels; for a general ambient starting channel, compare its active presentation | S02 predicate; S03 chain; S04 data |
| R07 | A nonsingular channel with every output active: state admissible, singularity false, no singular-column value accessor without its premise | S02/S03; S04 signature |
| R08 | Already active arbitrary finite output alphabet, direct enumeration and inverse-map recovery | S03 |
| R09 | Arbitrary finite alphabets in distinct universes, including a lifted finite type; no public default/decidable-equality assumption | S03 |
| R10 | Exact Matrix.reindex orientation, inverse/composition and transported values/patterns. Include input-only and output-only non-involutive three-cycles on a channel whose entries distinguish forward from inverse indexing; check literal exact/Real entries and pattern memberships through the new APIs. Separate cases must prevent simultaneous relabelings from cancelling | S03; S04 data |
| R11 | Two explicit enumerations of the same active output alphabet; actual coordinate/data comparison under the induced equivalence | S03; S04 data |
| R12 | Nonzero singular columns with singleton and larger supports, zero entries within a column, value bounds, division and uniqueness | S04 |
| R13 | Distinct columns with the same nonempty pattern and different positive values; reconstruction allows them without compression or injective-pattern hypotheses | S04 |
| R14 | Positive ENNReal values/nonempty patterns satisfying weighted row sums reconstruct an active singular channel and recover its data, with upper bounds and finiteness derived, not assumed; incompatible families require missing proof obligations | S04 |
| R15 | Definition 4: existing Example 1 column 0, value `1/2`, pattern `{0,1}` and ordered `[1,1,0]^T`, also at column 0 of its direct label-preserving `Fin 3` active state | S05 |
| R16 | A degenerate input prior can have smaller output support than the intrinsic active union; consume C03/C02 boundaries without asserting equality for that prior | S03 |

## 8. Validation and cumulative completion criteria

During each coherent change build the touched production and test modules,
then the other C06 consumer when it depends on the change. Build the C03
Singularity, Canonical and example consumers when their interfaces are
consumed or affected. Before every step milestone run `lake build` plus the
separately imported relevant tests; the default root does not build C06.

At S05/S06 explicitly build both proposed production modules, both Matrix test
modules, the new example-test module, the root and existing C01-C05 semantic,
probability, root-boundary and example regressions. Retain exact commands,
results and source identities. Audit all new public signatures and `#print
axioms` output, proof-specific noncomputability/classical choices, active
assumptions, import closure, and the actual Def. 4 formula. Compiler success
alone does not establish manuscript fidelity. Repeated generic checks are
unnecessary once applicable; cumulative closeout nevertheless requires its
own fresh required pass.

Require no matches from the AGENTS placeholder scan:

```powershell
rg -n --glob '*.lean' '\b(sorry|admit|axiom|opaque|undefined)\b' `
  PerfectFunctionalRepresentations PerfectFunctionalRepresentations.lean
```

Inspect final diff/status, staged and generated files, pins, ignored references
and temporary artifacts. Preserve `.pfr-review/` and inherited work; never
require a clean tree or infer commit/push authorization. Keep B/R/F identities
separate under the installed protocol. Document failed/inconclusive probes
honestly and distinguish fresh, reused and other-actor checks.

| Outcome | Required cumulative result | Main owners |
| --- | --- | --- |
| C06-CC01 | Exact rectangular coordinates, finite masses and normalized rows with two-sided PMF reconstruction | S01 |
| C06-CC02 | Derived Real bounds/row sums, exact numeric recovery and two-sided nonnegative Real reconstruction | S02 |
| C06-CC03 | Semantic and both matrix singularity forms equivalent, with zero-column and positive-entry meaning explicit | S02 |
| C06-CC04 | Positive-cardinality active heterogeneous state; arbitrary finite ambient recovery through exact C03 restriction | S03 |
| C06-CC05 | Finite reindexing, predicate invariance and enumeration-independent presentation with correct universes/labels | S03 |
| C06-CC06 | Admitted column value/nonempty pattern existence, bounds and uniqueness, including value one | S04 |
| C06-CC07 | Exact/Real reconstruction, normalized division, compatible-data converse, row sums and data equivariance | S04 |
| C06-CC08 | Definition 4's exact existing Example 1 fixture without duplicate semantics | S05 |
| C06-CC09 | R01-R16, public API/trust and import ownership, canonical documentation/omissions and preserved prerequisites | S01-S05 |
| C06-CC10 | Fresh cumulative closeout readiness with source/evidence provenance and explicit independent assessments sufficient for subsequent reconciliation and finalization | S06 |

CC01-CC10 are assessed at review time. Establishing them does not itself
complete C06: S06's ordered post-report duties, final applicability and actual
supported durable closure remain mandatory. S05 audits readiness for this
pass without claiming the future independent assessment or closure has occurred.

## 9. Inherited deferrals and intentional omissions

The project-log Future Work Notes register was searched: **no numbered notes
exist**, so none are silently ignored. Targeted log entries 48, 49-50, 53-54,
56, 58, 68, 77-78 and the map's relevant omission rows were revisited.

| Item / original source | Handling and revisit trigger |
| --- | --- |
| OM-014; C03 planning's deferred matrix sentence, log 49-50 | Discharge finite-alphabet/Fin coordinate boundary here in S03, with explicit input/output order. |
| OM-044; DG-06/DG-07 | Proposed active record and separate singularity premise above; gates remain open until exact lead approval. |
| OM-045; C03 S02/S03 records, log 53-54 | Consume existing exact restriction/invariance here; no duplicate probability construction. Later auxiliary/operation-weight restrictions remain C10/C11. |
| DG-10 / C12 allocation | C06 owns entry/column-value Real conversion and reconstruction. C12 revisits aggregation, compressed validity and optimization weights at its planning stage. |
| DG-11 / C10 and C13 | Use nonempty input support finsets now; C10 decides minimal exact partitions when multiway VPS needs them; C13 owns enumeration/incidence. No partition structure added here. |
| OM-024, OM-026, OM-038, OM-049-OM-051 | C07 owns operation indexing, examples 2-5, nondegenerate splits, value-one operation legality and inverse contracts. C06 admits value-one columns without settling VPS's printed strict range. Revisit at C07 planning. |
| DG-09, OM-043, OM-051-OM-052 | C08 owns path/endpoint equivalence and normalization; C10/C11 own multiway constructions. Revisit at those planning gates; C06 supplies explicit output equivalence facts only. |
| OM-040; existing Example 1 negative proof | Preserve completed C03 proof. C06 adds only Definition 4 data consumers; no duplicate negative proof. |

Intentional source dispositions, recorded in the map rather than only here:

- Section III's overview of preservation/constructive characterization is
  assigned to C07-C11, not re-proved as an introductory C06 theorem. The
  necessity sentence consumes C03; “easy”/“straightforward” language has no
  separate Lean proposition (OM-016/OM-037). Routine transitions are OM-022.
- Literal support labels and `S`/`S_{k,m}` set ownership are replaced by
  explicit coordinate equivalences and the active channel record
  (OM-014/OM-044). Ambient zeros are removed by the proved bridge (OM-045).
- Definition 4's divided ordered vector is a derived presentation of a
  nonempty support finset, with the exact division theorem required, not an
  omitted mathematical claim. No zero-column pattern/value exists (OM-068).
- Definition 4's Example 1 sentence is a maintained focused fixture, not a
  promised separate stable public theorem family (OM-069).
- Neighboring operation examples/Lemma 4 and Section III-B are later mapped
  work, not C06 omissions from the project. Extended-only material remains
  outside scope. No local manuscript copy or rendered page is committed.

No worthwhile unowned new deferral was identified. If review or implementation
produces one, retain its original suggestion reference, assign an existing
owner and trigger or open an immutable numbered Future Work Note and normalize
it in the summary. Optional uncertainty may remain deferred; required
correctness or acceptance concerns must be investigated or escalated.

## 10. Documentation, plan review and revision policy

The plan owns proposed contracts and acceptance. Planning notes own setup,
feasibility, contextual critique and reassessment; the living summary owns
current status; the map owns gates, allocation and omissions; project log owns
dated decisions/evidence; README/scope/roadmap keep concise reader-facing state.
Once implementation is approved, maintain step implementation notes and an
S05/S06 readiness audit without duplicating detailed narratives across owners.
No implementation progress is claimed by writing this draft.

For a later explicitly requested independent plan review, proposed criteria:

- **C06-PR01:** Scope/source versions, prerequisite applicability, omissions
  and authority boundaries are accurate and complete.
- **C06-PR02:** The active carrier, zero/empty boundaries and arbitrary finite
  bridges preserve semantic channels and downstream dimension changes.
- **C06-PR03:** Exact/Real reconstruction and singularity contracts state all
  needed hypotheses and are feasible with verified pinned APIs.
- **C06-PR04:** Values, nonempty patterns, uniqueness, division, reconstruction
  and transport cover Definition 4 and its example without hidden assumptions.
- **C06-PR05:** Module ownership, step dependencies, regressions, cumulative
  acceptance and documentation duties are sufficient and reviewable.
- **C06-PR06:** Deferred work, risks, revision handling and final approval/step
  boundaries are explicit, with no accidental later-chunk implementation.

These assess the plan, not nonexistent C06 proofs. Do not open or dispatch that
review until requested. Its result still awaits approval of the exact revision.
Requested/effective reviewer settings remain separate; preserve original
reports and bindings and use installed waiting guidance without changing scope.

The optional status block above contains only editorial status/history; all
other plan text is normative once approved. Routine proof routes, private
helpers, names and focused import refinements may improve during an authorized
step with reasons and review of the actual result. Stable step, criterion,
regression and completion IDs must remain traceable. Reassess later steps when
discoveries affect them without starting those steps. Mathematical weakening,
new simplifying assumptions, substantive scope/API/acceptance changes or a
material replacement plan require lead approval. Preserve original approved
and reviewed revisions and record decisions before changing execution scope.
