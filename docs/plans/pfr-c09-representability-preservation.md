# PFR-C09 - Representability preservation

**Revision:** 2, 2026-09-27  
**Status:** Approved / Active; no separate revision-2 plan review  
**Owner:** C09 planning and implementation task  
**Primary module:** `PerfectFunctionalRepresentations/Matrix/Preservation.lean`

**Authority:** The lead endorsed the delivered revision 2 and then requested
Step 1 with its review process. Together these messages approve this contract
and authorize S01 only. Later steps require their own requests. Justified
implementation refinements use judgment, preserve the intended outcomes, and
are documented and reviewed against the actual resulting work.

<!-- pfr-review-status:start -->
C09 implementation and the fresh S05 cumulative independent assessment are complete. All twelve earlier criteria, R01-R14, CC01-CC08 and CC09 review-time readiness were reassessed. All three S05 review criteria are satisfied. No material or optional findings were raised. The original report is critically reconciled. Final applicable checks, F and supported durable closure follow this maintained checkpoint; only that later record completes CC09 and closes C09. C10 remains unstarted.
S04 closure is d6a47f8e5ee3b9cb784a45ab6ecb58bae0b919517597c93795bde4b6d628fb0f.
All 124 entries of S04 F 77fd4651ff88093b71e28be9207d04fd3eb682b159559f49f940a29eebb348b7 match at S05 startup.
Earlier stop/authorization clauses and pre-F notes are historical checkpoints.
[Implementation notes](../pfr-c09-implementation-notes.md) own evidence and limits.
Original reports and advice remain preserved. No separate revision-2 plan review
is claimed. C10 requires its own approved plan and authorization.
<!-- pfr-review-status:end -->

## 1. Baseline, prerequisites and evidence limits

The baseline is the actual dirty working tree at HEAD
`54c1714d1a9a891939d6c9f7d38c0d05896b2c75`, including substantial uncommitted
completed mathematics. HEAD alone is not the implementation baseline. The
pre-edit inventory, installed inspection, binding and discovery evidence are
indexed in [C09 planning notes](../pfr-c09-planning-notes.md).

C09's mathematical prerequisites are C02's intrinsic common-posterior contract,
C03's semantic output transport, C06's finite matrix boundary and C07's legal
operations/recoveries. C08 supplies optional public handoff consumers; neither
its factorization machinery nor Lemma 4 is needed for local preservation.

C08 S07 closed under
`563027c353d94b430dd0c83192f274915f4ca46f6395761cc0a80b14a9f350b3`, with F
`b7c5cecade3f7d6c1e0c49e8f3c1ffd3fab0ad6308263867bcceb04417d6f453`.
The parent verified its 201-event journal, 299 state-referenced objects, all
seven closures and original-report reconciliations. All 123 F inventory entries
matched before planning-document edits, including the derived environment.
No finding or lifecycle restriction remained. Earlier C08 plan/readiness and
implementation checkpoints remain historical; their pending-F wording does not
reopen the later completed step.

C02-C07 durable records and final source applicability were checked. Earlier
differences are subsequent root integration, owning documents/instructions and
the authorized review-tool repair; earlier non-root mathematics, closed plans
and pinned environment match. C01 retains its historical closeout. This is a
bounded prerequisite inspection, not a new independent mathematical review of
C01-C08. C08's exhaustive trust audit and cumulative independent report remain
attributed retained evidence. Fresh planning builds/probes are listed separately
in the notes; incremental compilation is not a clean rebuild or paper-fidelity
certificate.

LeanInfoTheory stays at immutable `v0.1.0`, commit
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`; mathlib stays at `v4.33.1`, commit
`0df444a360eaa60ab8c11dca51a86af692955474`; Lean is `v4.33.1`. The installed
inspection checks all ten packages against the manifest. No dependency,
workflow, commit or push change belongs to this plan.

## 2. Exact sources and interpretation

The two designated PDFs were freshly hashed; their page counts are six and
eighteen. ISIT p. 4 and extended pp. 15-16 were also visually inspected.
Relevant surrounding text was extracted locally. Manuscripts, extracts and
renders remain external or ignored and are not maintained deliverables.

| Source | Identity and anchors |
| --- | --- |
| Six-page ISIT final, local filename ending `final_manuscript_ (3).pdf` | SHA-256 `48963AA59485B2C33B1A1E6E7C6EAD2251FDDDD26BD3691B6FCFFE683E6ED1C4`. Section III-B starts at the bottom of p. 3 right column; its all-ones paragraph continues on p. 4 left column. Lemmas 5-6 and the intervening recovery/contraposition prose are on p. 4 left column. |
| Designated extended version 16, designated 2026-09-03 | SHA-256 `98636D4C9F0618EC08FCA84559572780F604F197FDA90D8D7C787B3624245B8F`. Section III-B begins on p. 4. Appendix B proof of Lemma 5 begins on p. 15 left column, continues on p. 15 right and p. 16 left; Lemma 6 proof begins at the bottom of p. 16 left and ends in p. 16 right before Theorem 2. |
| Extended (175)-(177), p. 15 left | One complete perfect canonical witness, its decoding/independence/Markov properties and coordinate laws. Reuse C02; coordinate marginals alone are insufficient. |
| Extended (178)-(183), p. 15 | PPS uses a single independent Bernoulli choice for the entire vector; unchanged outputs average both vector lifts, and selected children fix the branch. |
| Extended (184)-(192), p. 15 right; (193)-(195), p. 16 left | PPM uses equal column supports, positive admitted values, the common collapse, and an input-independent posterior mixture with the admitted-value ratio. |
| Extended (196)-(202), p. 16 left | VPS maps the entire vector coordinatewise with the row mask; both selected children use the pushforward of the same old selected-output posterior. |
| Extended Lemma 6 prose, p. 16 | Contraposition using PPS after PPM, PPM after PPS, VPS after VPM; C07's remembered legal witnesses and directed output maps replace informal global inverses. |

The printed argument chooses a pair and uses conditional distributions. The
Lean contract is intrinsic and prior-free. Work directly with C02's rowwise
factorization of the complete coordinate/vector joint law. Its established
canonical and all-prior pair bridges interpret the printed independence,
decoder and Markov statements without adding a full-support prior premise.
Pointwise finite PMF equality covers the measurable-set mixture in (193)-(195).
It does not require a new measure-theoretic or conditional-law theorem family.

The all-ones paragraph means one fixed output for all inputs. Its exact and
Real matrix is the rectangular function `fun _ _ => 1` on
`alpha × Fin 1`, not Lean's square identity-matrix numeral. The C07 approved
interpretation of VPS allows admitted value one. Every operation still requires
the original strict PPS ratios or nonempty selected-support pieces. No new
mathematical interpretation decision is proposed. Reauthenticate and reassess
affected contracts if the lead designates a new companion manuscript.

## 3. Scope, ownership and non-goals

C09 owns the all-ones active seed and its semantic/matrix identification,
Lemma 5 for PPM/PPS/VPS, and Lemma 6 for PPM/PPS/VPM. Use
`ActiveFiniteChannel alpha`, with `[Finite alpha] [Nonempty alpha]`, the existing
`IsSingularChannel`, and the existing intrinsic perfectness predicate. Choose
`Fintype.ofFinite` internally when a proof needs enumeration. No extra prior,
full output support, strict VPS value bound or input cardinality premise is
permitted. Activity and singularity retain their existing separate meanings.

Production belongs in `Matrix/Preservation.lean`, initially importing only
`Matrix.Operations`. Keep the lightweight root unchanged. Regressions belong in
`Tests/Matrix/Preservation.lean`; this test module may additionally import
C08 `Matrix.OperationPaths` and the public C03 counterexample for handoff checks.
Do not import `OperationFactorization` or `OperationCalculus` into preservation.
Declarations stay in `PerfectFunctionalRepresentations`, with operation results
in its `MatrixOperations` namespace and the seed at the active-state boundary.

One-off vector maps, posterior definitions, weighted identities and support
proofs should remain private. Give a helper public status only for an actual
consumer and document the need. Any lower-level raw-channel proof must culminate
in the promised legal active-operation theorem. It is not a new generic channel
transformation API. Reuse pinned PMFs, mixtures and map/bind laws.

Outside C09: Theorem 1; arbitrary path/cascade preservation or reversal;
reachability definitions; multiway weights, partitions and finite-fiber
synthesis; canonical-coupling reachability; normalization; compression; LPs;
extended-only applications; arbitrary postprocessing preservation; general
identical-row/deterministic representability families; and the unselected
strict-VPS simulation. C10 owns path folds and recovery-based reachability.

## 4. Mathematical and public contracts

For this plan only, write `P(S)` for
`IsPerfectlyRepresentableChannel S.channel`. This notation does not introduce a
new predicate. The actual definition is

```lean
∃ q : PMF (alpha → beta), ∃ V : beta → PMF (alpha → beta),
  ∀ x, q.map (fun w => (w x, w)) = PMF.channelJoint (K x) V
```

Every forward construction must supply both `q'` and a total posterior channel
`V'`, and prove that equality for every input. A coupling or list of marginal
laws alone does not establish acceptance. Derive coordinate laws through the
existing canonical-coupling interface; keep decoding and the common posterior
visible in the proof and audit.

### 4.1 Minimal named handoff

Names below are **proposed**, not existing declarations:

- `ActiveFiniteChannel.allOnes alpha`, with output cardinality one and row
  `PMF.pure (0 : Fin 1)`, exact/Real coordinates all equal to one, singularity,
  and intrinsic perfectness. Use C03's public at-most-two-output equivalence
  for the perfectness proof. C06 already has a private one-output fixture;
  C03's general constant/deterministic witnesses remain private (OM-058).
- `pps_isPerfectlyRepresentable`, `ppm_isPerfectlyRepresentable`,
  `vps_isPerfectlyRepresentable`: the three implications in the table below.
- `pps_not_isPerfectlyRepresentable`, `ppm_not_isPerfectlyRepresentable`,
  `vpm_not_isPerfectlyRepresentable`: the three negative implications below.

Names may improve during the authorized step while these contracts stay fixed.
Do not add public iff/reflection aliases merely for symmetry. C10 can use the
negative implications by contraposition. Add an alias only if a real consumer
needs it and retain both directions in the source audit.

| C07 operation target, with its actual arguments | Lemma 5 | Lemma 6 |
| --- | --- | --- |
| `pps S hS l t ht0 ht1` | `P(S) → P(target)` | `¬ P(S) → ¬ P(target)` |
| `ppm S hS a b hab hp` | `P(S) → P(target)` | `¬ P(S) → ¬ P(target)` |
| `vps S hS l mask hl hr` | `P(S) → P(target)` | No such claim |
| `vpm S hS a b hab hv hd` | No such claim | `¬ P(S) → ¬ P(target)` |

All six targets retain the supplied `hS : IsSingularChannel S.channel` so they
match the existing witnessed operation constructors; forward perfectness also
implies singularity but need not replace that argument. Legal parameters are:

- PPS: `l : Fin S.outputCard`, `t : NNReal`, `ht0 : 0 < t`, `ht1 : t < 1`.
- PPM: `a b : Fin S.outputCard`, `hab : a < b`,
  `hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0`.
- VPS: `mask : alpha → Bool`, with both
  `∃ x, S.channel x l ≠ 0 ∧ mask x = true` and its false analogue.
- VPM: `hab : a < b`, equal admitted `columnValue`s at `S.activeEquiv a/b`,
  and `hd : ∀ x, S.channel x a ≠ 0 → S.channel x b = 0`.

Adjacent split insertion, lower-index merge survival, all unaffected columns,
the full merge source-label range and changed cardinalities remain C07's exact
conventions. No matrix-to-PMF reconstruction is needed for these results.

### 4.2 Output and finite-presentation transport

Reuse `isPerfectlyRepresentableChannel_map_iff`,
`isPerfectlyRepresentableChannel_relabelChannel_iff` and C06's
`ActiveFiniteChannel.isPerfectlyRepresentableChannel_ofActive_iff`,
`...ofChannelWithEquiv_iff` and `...ofChannel_iff`. They already cover actual
finite presentation changes and unused ambient outputs. Do not define a parallel
matrix-perfectness predicate or new arbitrary output-equivalence hierarchy.

An anonymous integrated consumer should take an existing C08 `OutputEquiv S T`,
use its directed row equation to transport `P(S) ↔ P(T)`, and consume the new
local theorems at the exact `OperationStep` endpoints. This validates the C10
handoff without proving a path fold. C10 can later conclude perfectness from a
supplied cascade from all-ones using PPM/PPS/VPS, or to all-ones using
PPM/PPS/VPM and reflection. Those two cascade theorems remain C10.

## 5. Proof constructions and explicit obligations

### 5.1 PPS: one shared choice for the vector

Let `Fleft w` apply `vpsIndex l true` to every coordinate of `w`, and let
`Fright w` use `false`. Define `q'` as the binary mixture, with weights
`t` and `1-t`, of `q.map Fleft` and `q.map Fright`. This is the law of the
manuscript's single independent Bernoulli choice followed by its full-vector
map. It is not independent resampling at each coordinate.
Verify that mixture interpretation through the pinned map/bind construction;
an internal law identity suffices, without a new public Bernoulli theorem.

At the left child use `(V l).map Fleft`, at the right child use
`(V l).map Fright`, and at an unaffected output `j` use the binary mixture
of `(V j).map Fleft` and `(V j).map Fright`. Prove all cases using the original
joint factorization, map/bind identities and the actual `ppsKernel`/`ppsRaw`
equations. The unaffected posterior must retain both lifts even though its
displayed output label is unchanged. These are valid PMFs at null rows as well;
zero coefficients establish the corresponding joint-law equality without
conditioning on a zero-probability event. Require R02-R04 below.

### 5.2 PPM: one fixed posterior mixture

Use C07's actual collapse, including `mergeSourceEquiv` and `mergeIndex`, from
old labels to the target. Apply it to every vector coordinate to obtain `F` and
set `q' = q.map F`. Let `u,v` be the positive admitted values of the selected
columns, and let `r = ppmRatio S hS a b`. At the merged output use the binary
mixture of `(V a).map F` and `(V b).map F` with weights `r` and `1-r`.
At each unaffected target label use the pushforward of its unique old posterior.

The ratio depends on remembered admitted column values, never on a potentially
null row. Reuse `ppmRatio_denominator_pos`, `ppmRatio_denominator_ne_top`,
`ppmRatio_pos`, `ppmRatio_lt_one`, `ppmRatio_mul_sum` and
`ppmRatio_complement_mul_sum`, together with C06 value-equality facts. Split
the row proof on the common support: both masses are zero off support; on
support they are `u,v`. Make every cancellation/finite-coercion premise explicit.
The private C07 row-product helper is not a public API; a small local derivation
from the public value identities is sufficient unless actual shared use
justifies promotion. This yields (191)-(195) as exact weighted PMF identities,
including the null merged fiber, without arbitrary channel-postprocessing
preservation. Require R05-R07.

### 5.3 VPS: a deterministic full-vector map

Set `F w x = vpsIndex l (mask x) (w x)` and `q' = q.map F`. Both split-child
posteriors are `(V l).map F`; an unaffected posterior is `(V j).map F`.
The chosen coordinate map depends on `x`, but `F` is one deterministic function
of the entire vector and `V'` is independent of the currently queried row.

Prove the full joint identity separately for the selected children and
unaffected labels, using the original factorization and the explicit row mask.
On the wrong side of the mask the child coefficient is zero; outside the old
selected support both are zero. A total posterior is already supplied by the
pushforward PMF, so no asserted equality of null conditional completions is
needed. The actual legal result uses both selected-support witnesses and allows
value one. Mask equality only on that support suffices for endpoint equality
via C07; the construction must not imply equality of arbitrary ambient masks.
Require R08-R10.

### 5.4 Lemma 6: witnessed recovery and contraposition

| Given allegedly perfect result | Apply Lemma 5 to | Existing comparison to the original source |
| --- | --- | --- |
| PPM result | `ppmRecovery`: PPS at the survivor with remembered `ppmRatio` and its strict bounds | `ppmRecovery_channel` maps the recovered row by `ppmRecoveryEquiv` **to** the original row. |
| PPS result | `ppsRecovery`: PPM of its adjacent equal-support children | `ppsRecovery_channel` with `finCongr ppsRecovery_outputCard`. |
| VPM result | `vpmRecovery`: VPS with `vpmRecoveryMask`, `vpmRecovery_leftWitness`, `vpmRecovery_rightWitness` | `vpmRecovery_channel` maps the recovered row by `vpmRecoveryEquiv` **to** the original row. |

Transport perfectness across these actual comparisons, contradicting source
nonperfectness. Inverse row equations use the inverse permutation; do not silently
reverse the forward map. The operation's legal singularity proof is supplied by
C07. No merge is a global inverse and no forgotten ratio/mask is reconstructed
from its output alone. The fourth recovery (VPS then VPM) remains available for
coordinate checks but cannot justify either forbidden preservation direction.
Require R11-R14.

## 6. Verified existing reuse

The local source, pinned LeanInfoTheory documentation/declaration index,
highlights/module guide and source, and pinned mathlib were searched. Focused
existing-API probes and their exact outcomes are indexed in the planning notes.
The target names in Section 4.1 are proposed; the following are existing:

| Existing surface | Intended use |
| --- | --- |
| C02 `IsPerfectlyRepresentableChannel`, `isCanonicalCoupling_of_coordinateFactorization`, `IsPerfectlyRepresentableChannel.exists_canonicalCoupling` | Complete witness contract and derived marginals; no new representation hierarchy. |
| C02 `coordinateFactorization_congr_posterior` | Explicit irrelevance of unused posterior completions. |
| C03 `coordinate_eq_of_posterior_support` | Supported-coordinate facts. |
| C02 canonical joint / common-posterior / all-prior pair bridges | Interpret (175)-(177); no new prior hypothesis. |
| C03 `IsPerfectlyRepresentableChannel.isSingular`, small-output iff and injective-output iff | Necessary singularity, seed perfectness, semantic invariance. |
| C06 `massMatrix`, `realMatrix`, `ActiveFiniteChannel.ofActive`, finite-presentation and relabeling iffs | All-ones coordinates and active/ambient handoff. |
| C06 `columnValue_eq_of_ne_zero`, positivity and finiteness | Supported-row values and justified ratio arithmetic. |
| C07 legal operations, raw coordinate/map/bind laws, index cases, `ppmRatio_*`, three required recoveries | Sole operation definitions and recovery contracts. |
| C08 `OutputEquiv` and witnessed `OperationStep` | Test-only directed endpoint consumers; no normalization dependency. |
| Supported `PMF.binaryMixture`, `binaryMixture_apply` in `Probability.FiniteMixture` | Valid binary PMFs for PPS vector/posterior laws and PPM posterior law. |
| Supported `PMF.channelJoint`, `channelJoint_apply`, `map_apply_equiv` | Exact joint factorization and output relabeling. |
| mathlib `PMF.map_comp`, `map_bind`, `bind_map`, `bind_apply`, `PMF.ext`, `pure_map`, finite sums and `Fintype.ofFinite` | Local map/mixture manipulation, joint equality and internal enumeration. |

An absent ready-made mixture transport simplifier does not justify duplicating
the probability construction. Search again if a concrete implementation need
arises; prove only small private algebraic consequences when appropriate.
Record genuine discoverability friction in its owning log, not routine search.

## 7. Approved dependency-driven steps

Each separately authorized implementation request handles exactly one approved
step, including applicable supervised review/finalization, and stops. Only S01
is currently authorized. S01 establishes the shared mixture proof work;
S02 and S03 independently cover the other forward constructions; S04 needs
all three for recovery-based reflection; S05 must freshly validate the whole.

### PFR-C09-S01 - All-ones seed and PPS witness

Implement the minimal seed/coordinate API through existing one-output semantics
and the complete PPS construction in Section 5.1. Add only the local PMF/vector
algebra needed for this result. Inspect subsequent PPM/VPS needs without
implementing them. Cover (175)-(183) and R01-R04.

- **C09-S01-A:** The finite nonempty all-ones state has exactly one active output,
  all exact/Real entries one, singularity and intrinsic perfectness by existing
  C03 reuse; no general special-case family is exposed.
- **C09-S01-B:** Legal PPS preserves intrinsic perfectness via the complete
  shared-choice vector law and total posterior, including both child and
  unaffected cases; strict ratios and null-row behavior are explicit.
- **C09-S01-C:** R01-R04, focused/default builds and new public signature/axiom
  audit pass; source anchors, omissions and current implementation evidence are
  recorded, with S02-S05 unstarted.

### PFR-C09-S02 - PPM witness with fixed posterior ratio

Implement Section 5.2 using C07's admitted-value ratio and actual ordered
collapse. Preserve the entire coordinate/vector law. Cover (184)-(195),
R05-R07 and S01 downstream regressions.

- **C09-S02-A:** Legal equal-support PPM preserves intrinsic perfectness through
  the complete collapsed vector law and fixed merged posterior mixture.
- **C09-S02-B:** Supported and null rows, denominator positivity/finiteness,
  unequal values, unchanged outputs and nonadjacent ordering are handled without
  a hidden prior, rowwise division or arbitrary postprocessing theorem.
- **C09-S02-C:** R05-R07 plus applicable S01 tests, builds and public trust audit
  pass; complete anchor/representation evidence is recorded and plan health is
  reassessed before stopping.

### PFR-C09-S03 - VPS witness at the approved value-one boundary

Implement Section 5.3, cover (196)-(202) and R08-R10, and retain both selected
support witnesses. Check all earlier forward results remain applicable.

- **C09-S03-A:** Legal VPS preserves intrinsic perfectness via a deterministic
  whole-vector map and one total output posterior independent of the queried row.
- **C09-S03-B:** Value one, both null child cases, off-support rows, unaffected
  outputs and mask irrelevance on unused rows are explicit; no stricter VPS
  domain, new prior or forbidden reflection theorem is introduced.
- **C09-S03-C:** R08-R10 and previous forward regressions/builds/trust checks pass;
  Lemma 5 and all (175)-(202) logical obligations are accounted for in the
  maintained coverage record, with Lemma 6 still pending.

### PFR-C09-S04 - Lemma 6, public consumers and cumulative readiness

Implement the three negative implications through Section 5.4, and complete
R11-R14 plus the active/ambient/output-equivalence handoff. Populate a cumulative
readiness audit mapping every declaration, anchor, regression and earlier
criterion. This step supplies current readiness, not S05's independent closeout.

- **C09-S04-A:** Nonperfectness is preserved by legal PPM/PPS/VPM, using the three
  proved forward constructions and the precise remembered C07 recoveries; every
  direction and output permutation is correct.
- **C09-S04-B:** R11-R14 consume actual legal endpoints, explicit finite/ambient
  transport and C08 public wrappers; the C10 handoff is sufficient without a
  path fold, general synthesis, theorem-family promotion or heavier production
  dependency.
- **C09-S04-C:** All R01-R14, maintained prerequisite consumers, focused/default
  builds and cumulative C09 public signature/axiom checks pass; the readiness
  crosswalk, manuscript/omission audit and current documents are complete for
  S05's later fresh assessment.

### PFR-C09-S05 - Fresh cumulative independent validation and closeout

Freshly re-read the full approved C09 contract, integrated proofs and exact
anchors. Reassess all twelve S01-S04 criteria, R01-R14 and CC01-CC09 below.
Do not substitute previous step reports for this pass. Use the same bound
reviewer with a fresh cumulative source-bound request.

- **C09-S05-A:** Fresh cumulative source, mathematical/API, build and trust
  assessment covers all twelve prior criteria, every regression and CC01-CC08;
  no omission, unsupported assumption, direction error or later-chunk result
  escapes the integrated check.
- **C09-S05-B:** The bound reviewer independently reassesses the same complete
  scope and review-time readiness, with actual commands/results and limitations;
  all original prior reports and their reconciliations remain available and
  applicable, and any new acceptance gap receives the required satisfactory
  independent reassessment.
- **C09-S05-C:** At review time, the cumulative readiness audit is complete and
  required subsequent duties are fully specified. After receiving the
  report, the parent must retain and critically reconcile it, resolve required
  findings/review, prepare final owning documents, run final applicable checks,
  capture F and obtain supported durable closure. Only that later record closes
  C09. Stop afterward; C10 is not authorized.

The reviewer cannot certify its own future receipt, reconciliation, final
validation/F or closure. S05-C and CC09 have explicit review-time and later
finalization phases. Repairs during cumulative validation must remain bounded
and be revalidated/reviewed as required; substantive contract changes go to the
lead. A repaired readiness checkpoint is not a completed chunk.

## 8. Regression and edge-case contract

Use private fixtures and anonymous consumers, with assertions that examine
the complete construction where indicated. Existing C06/C07 fixture names need
not be promoted. Retained prerequisite checks may be reused only with explicit
source applicability; new C09 assertions must exercise the new results.
When an assertion must inspect a private vector/posterior construction, keep
an anonymous local check beside that construction if the separate test module
cannot access it. This does not require promoting a private helper to public API.

| ID | Required case and purpose | Owner |
| --- | --- | --- |
| R01 | All-ones over singleton and multi-input alphabets; exact/Real rectangular coordinates; existing finite/active presentation transport; empty input remains outside active-state contract. | S01 |
| R02 | Strict unequal PPS weight, e.g. 1/3; both children and unaffected coordinates under actual insertion, including a null selected row. | S01 |
| R03 | Inspect full PPS vector law: a vector mixing left/right children across selected coordinates has zero mass, although independent coordinate choices would give positive mass. The unaffected-output posterior includes both distinct lifted laws. | S01 |
| R04 | Complete rowwise factorization/decoder/coupling handoff and null fibers; no prior premise. Endpoint ratios remain illegal for legal PPS, reusing C07 legality tests. | S01 |
| R05 | PPM with unequal positive values, including sum one and a proper common support with a row outside it; fixed-ratio mixture and both zero row coefficients. Use distinct pushed posteriors so incorrect mixture weights change the merged posterior and are detected by the assertions. | S02 |
| R06 | Selected, merged and unaffected full-joint cases; finite/nonzero denominator facts; no arbitrary null conditional identification. | S02 |
| R07 | Nonadjacent merge including the final source label; unequal unaffected values distinguish ordering. Consume the existing asymmetric C07 recovery direction in the integrated check. | S02/S04 |
| R08 | Legal VPS of value-one all-ones with two nonempty mask sides; complete witness and null child rows on both sides. | S03 |
| R09 | VPS on proper selected support with rows outside it and unaffected labels; masks agreeing only on that support yield the same endpoint. | S03 |
| R10 | Globally nonconstant mask with an empty selected-support piece remains illegal; no `< 1` value premise or VPS nonperfectness-preservation assertion. Reuse C07 failed-legality coverage with a new C09 positive consumer. | S03 |
| R11 | All three Lemma 6 contracts consumed with arbitrary legal witnesses and source nonperfectness; reconstruct the exact recovery target and directed map in each case. | S04 |
| R12 | Public C03 nonrepresentable3x3 wrapped privately as an active state, PPS at column 0 with ratio 1/3, then legal PPM of its children. New negative theorems establish both endpoints nonperfect; unequal children and row 2's null selected fiber are checked. | S04 |
| R13 | Concrete value-one VPM-to-VPS remembered recovery plus generic VPM negative consumer. The original 3x3 fixture has no disjoint-support pair; no extra counterexample or reachability construction is required merely for a concrete negative VPM fixture. | S04 |
| R14 | Combined import of Preservation and OperationPaths: directed OutputEquiv transport (including a non-involutive permutation), actual witnessed endpoints, one-output seed and C06 finite presentation/unused-label transport. No path/cascade theorem. | S04 |

Suggested private fixtures make these checks concrete. Their exact labels and
rational values may vary if the assertions retain the stated discrimination
and all required edge-case coverage; several obligations may share one fixture.

- **R03:** take the deterministic source vector `[0,0,1]`, with its point-mass
  vector law, and split label 0 at weight `1/3`. The resulting law has masses
  `1/3` on `[0,0,2]` and `2/3` on `[1,1,2]`, and zero on `[0,1,2]`.
  Independent coordinate choices would assign that last vector mass `2/9`
  despite the same marginals. The posterior at unaffected output 2 contains
  both lifted vectors. This fixture needs only a private point-mass witness.
- **R05-R07:** take source vectors `A = [0,0,1]`, `B = [3,3,2]` with weights
  `1/3`, `2/3`, and source posteriors `V 0 = V 1 = pure A`,
  `V 2 = V 3 = pure B`. Merge labels 0 and 3. Their common support is rows
  0 and 1; row 2 is outside it. The merged posterior mixes distinct vectors
  `[0,0,1]`, `[0,0,2]` with the original unequal weights. Row 2 retains unequal
  unaffected masses. This combines the sum-one boundary, null selected row,
  nonadjacent final-label merge and posterior-weight check. The private source
  witness follows directly from a binary mixture of point masses, independently
  of S03's future VPS theorem.

Public statement inspection must verify that neither VPM forward perfectness nor
VPS forward nonperfectness was accidentally asserted. Failure to prove such a
statement is not a mathematical counterexample; no new counterexample family is
required. Empty outputs are excluded by active-state positivity; singleton input
cannot satisfy a nondegenerate VPS mask, while singleton output and value-one
VPS over multiple inputs are required positive cases.

## 9. Completion and validation

- **CC01:** The all-ones seed has the exact semantic and rectangular-matrix
  identification and perfectness, reusing existing special-case semantics.
- **CC02:** PPS, PPM and VPS each preserve the complete intrinsic witness at
  precisely C07's legal domain; all (175)-(202) logical content is covered.
- **CC03:** PPM/PPS/VPM preserve nonperfectness through the correct remembered
  recovery and directed output comparison; no forbidden direction is claimed.
- **CC04:** Null rows/fibers, denominator/finite-coercion duties, active supports,
  unchanged labels, cardinalities, singleton and value-one cases are explicit.
- **CC05:** The minimal public API and existing transport support C10's future
  consumers without normalization, new perfectness predicates or general paths.
- **CC06:** R01-R14, current prerequisite consumers, builds and public signature/
  axiom/import audits pass with no proof placeholders or unexpected trust basis.
- **CC07:** Scope, all source interpretations, intentional omissions and
  worthwhile deferrals have owners/triggers; later mathematics stays outside C09.
- **CC08:** Current canonical documents and source-bound evidence distinguish
  new checks, retained checks, proposed APIs and completed implementation while
  preserving inherited work and original records.
- **CC09:** Fresh cumulative independent assessment establishes review-time
  readiness. The parent then completes original-report receipt/reconciliation,
  required corrections/review, final validation/F and supported durable closure.
  CC09 is satisfied in full only after all those duties finish.

After each coherent Lean change build the touched production/test module and
important downstream consumers. Before each step milestone run `lake build`.
Because the root intentionally omits matrices/tests, explicitly build
`Matrix.Preservation` and `Tests.Matrix.Preservation`; include affected C06/C07
and C08 public handoff tests. For S05 run the current maintained PFR test/example
inventory, C09 production, important matrix aggregates and default/root build.
Use actual module discovery, not a historical job count.

Audit every new public declaration's complete type and `#print axioms`, the
focused import closure, no prior/full-support premise and intended operation
direction. Inspect private witness equations for manuscript fidelity. Require
the AGENTS.md placeholder scan to return no matches. Preserve actual command,
actor, source, outcome and limitations. Run final diff/status, unrelated-byte,
pin-cleanliness and tracked-generated/reference/scratch-artifact checks.
Disposable discovery success is not an implemented theorem or independent
acceptance. No commit or push is included.

## 10. Omissions, deferrals and documentation duties

Every logical intermediate in the reviewed preservation anchors is allocated
above. The following intentional non-public or out-of-chunk items retain a
reason and owner; none is silently dropped.

| Register / material | C09 disposition and revisit trigger |
| --- | --- |
| OM-042; (175)-(202) | Reuse C02 for (175)-(177), S01 for (178)-(183), S02 for (184)-(195), S03 for (196)-(202). Internal maps, scalar conditionals, finite measurable-set identities and branch-symmetric arguments need no separate public theorem per line; full logical coverage is mandatory. S04 readiness and S05 audit the crosswalk. |
| OM-049; printed strict VPS range | Keep the approved inclusive value-one domain. The historical PPS/two-VPS/two-PPM strict-domain simulation remains unselected, with no implementation duty. Revisit only after explicit approval of a changed operation/recovery contract and ownership. |
| OM-051; inverse prose | S04 uses remembered ratios/masks and directed recovery equivalences. No global merge inverse or unique ambient mask. C10 retains path reversal/reachability, revisited in its approved plan. |
| OM-058; special-case semantic families | Existing C03 small-output theorem supplies all-ones perfectness. Do not expose general constant/deterministic families or reprove them. Revisit helper promotion only for an actual later consumer beyond the seed. |
| OM-048; incomplete canonical-witness reading | Retain the complete coordinate/vector factorization and decoder, not merely marginal coupling laws. C02 owns the existing semantic repair; C09 applies it throughout S01-S03. |
| OM-014/044/045/068; finite/support boundary | Reuse active/ambient and finite enumeration bridges. No value for zero columns, fake full-support prior or replacement state. C10/C11 retain zero weights and empty fibers in arbitrary constructions. |
| OM-026/050; Examples 2-5 | No public fixture promotion is needed; their separate strict-beta fixture hypothesis is unchanged. C09 uses private focused cases. Revisit only for an actual named-fixture consumer. |
| OM-038/052; degenerate masks and multiway prose | Legal selected-support pieces remain nonempty. Generic pruning and arbitrary weight/partition/fiber synthesis stay with C10/C11; a future concrete consumer triggers reconsideration. |
| ISIT III-B repeated-use prose and Theorem 1; extended adjacent proof | C09 supplies seed/local preservation; repeated-path conclusions and the easy direction belong to C10, canonical-coupling reachability to C11. No duplicate C09 path API. |
| OM-010/011/012; adjacent Remark 2 applications | External graph-entropy/privacy/channel-synthesis equivalences remain excluded. Their adjacency to Lemmas 5-6 does not add scope. |
| OM-022; transitions and concluding restatements | No duplicate declaration. The mathematical content is accounted for by the seed, three forward and three negative contracts. |
| Adjoining Appendix B (167)-(174), (203)-(221) | Completed C08 normalization and future C14 primal proof retain ownership; neither is imported as new C09 mathematics. |

Targeted log and review-suggestion inspection found no numbered Future Work
Notes. The C07 signature/asymmetric-recovery advice is already implemented;
C08's possible helper promotion belongs to C10/C11 and has no current C09
consumer. Existing mapped obligations cover the deferrals above. Open a numbered
Future Work Note only for a worthwhile new suggestion lacking such an owner;
retain its origin and revisit trigger. Required correctness or acceptance gaps
cannot be deferred as optional work.

During implementation maintain `docs/pfr-c09-implementation-notes.md` for
proof/API/evidence history and `docs/pfr-c09-readiness-audit.md` for the cumulative
crosswalk; those files need not exist before implementation. Update the living
summary, formalization map and project log for material status, coverage,
interpretation or omission changes. README and roadmap carry concise current
status only. Preserve prior plans, original reports and historical checkpoints.
No discoverability entry is warranted merely because a routine search was made.

## 11. Reviewer, plan review and revision rules

Persistent reviewer `/root/pfr_c09_reviewer` is bound at
`.pfr-review/chunks/PFR-C09/binding.json` to originating task
`01a0e235-68e6-77f2-9c78-09c28039eaba` (role `/root`). Requested profile:
`gpt-6-astra`, `ultra`, `fork_turns="none"`. Effective settings remain unknown.
The neutral bootstrap reported repository/environment instructions and no parent
discussion or assessments. The same reviewer later completed revision 1's
independent plan review; all six criteria below were satisfied, with one optional
attribution correction now incorporated. Its original report and parent
reconciliation remain unchanged. The supplied General Assistant review is
advisory evidence, separate from that installed record. Revision 2 has no
separate independent plan review. Read-only behavior is instruction-level, not
OS isolation. Retain that binding for every C09 review; do not transfer, silently
replace or recreate another reviewer.

An explicitly requested review of this revision should assess:

- **C09-PLAN-A:** Current baseline, closed-prerequisite applicability, source
  identities and evidence limitations are adequate and accurately attributed.
- **C09-PLAN-B:** Seed, intrinsic full-witness constructions, domains, null cases
  and all implication/recovery directions faithfully cover the sources.
- **C09-PLAN-C:** Verified reuse, focused ownership/imports and the minimal C10
  handoff avoid circular dependencies, hidden assumptions and unnecessary scope.
- **C09-PLAN-D:** Stable steps and R01-R14/CC01-CC09 give complete, practical
  acceptance and independent cumulative validation, with correct phase timing.
- **C09-PLAN-E:** Every intentional source omission and worthwhile deferred
  suggestion has a reason, owner and revisit trigger; historical records remain.
- **C09-PLAN-F:** Reviewer/provenance, approval, revision, documentation and
  stop rules match the installed supervised workflow and this planning authority.

Revision 1's assessments apply to its preserved contract; they are not a new
verdict on revision 2. Apply the installed protocol/operations for later explicit
review requests, using a fresh plan session with the same bound reviewer.
During an approved step, routine proof-route, organization or name improvements
are allowed with documented reasons and review of the actual result. Preserve
the original reviewed contract; do not silently change frozen normative text.
Mathematical intent, theorem strength, domain, scope or acceptance changes need
lead resolution and an appropriate approved revised contract. Revisit later-step
health after relevant discoveries without starting that later step.

The lead's endorsement and S01-with-review request approve revision 2 and
authorize only S01 implementation, validation, review and finalization. Stop
after that step. Later steps require separate explicit requests. No dependency
or workflow change, commit, push or later chunk is authorized.
