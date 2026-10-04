# PFR-C09 cumulative readiness audit

Freshly reassessed under S05 on 2026-09-28 against the [approved revision-2 plan](plans/pfr-c09-representability-preservation.md). S01-S04 are durably complete. The fresh cumulative independent review and parent reconciliation are complete; final checks/F and durable closure follow this maintained checkpoint. The [implementation notes](pfr-c09-implementation-notes.md) own attributed checks, original reports and exact status.

## 1. Scope and evidence boundaries

S05 startup verified all four prior closure/report/reconciliation records and all 124 entries of S04 F `77fd4651ff88093b71e28be9207d04fd3eb682b159559f49f940a29eebb348b7`, following closure `d6a47f8e5ee3b9cb784a45ab6ecb58bae0b919517597c93795bde4b6d628fb0f`. Earlier step-stop and pre-F statements retain their historical meaning. Current mathematics and the normative plan are unchanged.

The tables below record the cumulative source assessment, freshly checked by the parent and the bound reviewer. The complete original independent report is retained and critically reconciled. Final applicable checks, F and durable closure remain subsequent duties at this checkpoint. C10 remains outside this request.

Abbreviations: **P** is [Matrix/Preservation.lean](../PerfectFunctionalRepresentations/Matrix/Preservation.lean); **T** is [Tests/Matrix/Preservation.lean](../PerfectFunctionalRepresentations/Tests/Matrix/Preservation.lean); **O** is [Matrix/Operations.lean](../PerfectFunctionalRepresentations/Matrix/Operations.lean); **OP** is [Matrix/OperationPaths.lean](../PerfectFunctionalRepresentations/Matrix/OperationPaths.lean). The declaration index below gives current source locations for every authored named declaration in P and T. The exhaustive imported-module audit additionally covers P's generated named constants. Anonymous checks are counted and compiled separately.

## 2. All twelve S01-S04 criteria

| Criterion | Current implementation and acceptance obligation |
| --- | --- |
| C09-S01-A | P `allOnes` has one active output, pure rows and exact/Real rectangular coordinates one. `allOnes_isPerfectlyRepresentable` reuses C03's at-most-two-output characterization. R01 checks singleton/multiple inputs and presentations. Empty input stays outside the active-state contract. |
| C09-S01-B | P `ppsVectorLaw_eq_shared_selector`, `ppsPosterior_left/right/keep`, `pps_factorization` and `pps_isPerfectlyRepresentable` retain one shared whole-vector choice, strict ratios and a total posterior. Joint identities include null selected rows and unaffected outputs. |
| C09-S01-C | R01-R04 and public/canonical consumers are retained unchanged apart from module documentation. Fresh S05 cumulative/default builds and trust audit refresh applicability; original S01 review/closure remain historical. |
| C09-S02-A | P `ppmCollapse`, `ppmVectorLaw`, `ppmPosterior`, `ppm_factorization` and `ppm_isPerfectlyRepresentable` use the actual ordered collapse, entire vector and fixed admitted-value mixture. |
| C09-S02-B | `ppm_row_products` separates common-support and null rows; C07's ratio positivity/finiteness and weighted identities discharge arithmetic. R05-R07 distinguish unequal posterior atoms, unaffected coordinates, nonadjacent ordering and the final source label. |
| C09-S02-C | R05-R07 plus earlier consumers are retained. Fresh S05 tests/trust audit check source applicability and R07's directed-recovery handoff. Both original S02 wording findings remain corrected. |
| C09-S03-A | P `vpsVectorLift`, `vpsVectorLaw`, `vpsPosterior`, `vps_factorization` and `vps_isPerfectlyRepresentable` transport the complete joint through one deterministic map. The posterior is indexed only by output. |
| C09-S03-B | Both selected-support witnesses remain explicit; R08 exercises admitted value one. R09 checks wrong-side/off-support null children, all unaffected posteriors and support-only mask equality versus global-map inequality. R10 rejects an empty selected-support piece. |
| C09-S03-C | R08-R10 and all previous forward checks remain. The source table covers all (175)-(202) content. The documented simultaneous map proof preserves all planned cases. Fresh S05 builds/trust checks refresh applicability. |
| C09-S04-A | `pps_not_isPerfectlyRepresentable`, `ppm_not_isPerfectlyRepresentable`, `vpm_not_isPerfectlyRepresentable` apply the appropriate proved forward result to each remembered recovery, then C03 output transport along the recovered-to-original map. |
| C09-S04-B | T R11-R14 exercise arbitrary legal witnesses, exact recovered endpoints/maps, the actual C03 counterexample, value-one VPM recovery, C08 witnessed edges, non-involutive output transport and C06 finite/unused-label presentations. No path fold or promoted fixture/helper is needed. |
| C09-S04-C | R01-R14, applicable C02/C03/C06/C07/C08 consumers, focused/default builds, all fourteen public signatures and exhaustive P axiom audit are required at this checkpoint. This audit records declaration, source, regression, criterion and omission coverage for the fresh S05 reassessment. |

## 3. All fourteen regressions

| ID | Concrete coverage and discriminating behavior |
| --- | --- |
| R01 | T `allOnes` over Fin 1 and Fin 3; exact/Real entries; `ofActive`, `ofChannel` and `seedAmbient` with two unused labels. C06's retained empty-input tests establish the existing raw boundary; active seed still requires Nonempty. |
| R02 | P `r03*` fixture splits selected label 0 at weight 1/3. Source vector [0,0,1] makes row 2 a null selected row; all child/unaffected channel entries are checked under actual insertion. |
| R03 | Actual vector law has masses 1/3 at [0,0,2], 2/3 at [1,1,2], zero at [0,1,2]. The independently sampled comparison gives 2/9 at the mixed vector despite equal marginals. The unaffected posterior retains both distinct lifts. |
| R04 | P full PPS factorization supplies canonical coupling and every-prior canonical representation. Both null child joints vanish. T consumes the exact public theorem. Retained C07 endpoint-ratio rejection tests remain in the focused build. |
| R05 | P `r05*` source mixes [0,0,1] and [3,3,2] with weights 1/3 and 2/3; merge labels 0 and 3. Both values sum to one on support {0,1}; row 2 is null. Distinct collapsed posterior atoms detect incorrect mixture weights. |
| R06 | P checks selected/merged/unaffected full joints, zero row products, denominator positivity/finiteness, actual full factorization and canonical/every-prior handoffs. Total null posteriors are supplied, without identifying arbitrary conditional completions. |
| R07 | P nonadjacent merge includes final source label 3 and unequal unaffected values. Its explicit recovery permutation and C07's wrong-direction check are retained; T generic recovery/output-equivalence consumers complete the local negative handoff. |
| R08 | P actual `allOnes (Fin 2)` with mask [true,false] and admitted value one; transformed law and both posteriors pure [0,1], four channel entries, both wrong-side joints, complete witness and canonical handoffs. |
| R09 | P proper-support VPS produces [0,1,2] and [4,4,3] with unequal weights. All 15 channel entries, all five posteriors, positive/crossed-zero joints and wrong-side/off-support children are tested. Masks agreeing only on selected support give equal legal endpoints but may give unequal whole-vector maps elsewhere. |
| R10 | P mask [true,true,false] is globally nonconstant but has no false selected-support witness. C07 failed-legality coverage is retained; new public VPS consumers include value one without a strict upper bound. No VPS nonperfectness theorem is asserted. |
| R11 | T consumes all three new negative implications with arbitrary legal witnesses. Separate consumers reconstruct each actual recovery and retain the directed row equality to the original; P applies the correct forward theorem in each proof. |
| R12 | T privately wraps public `nonrepresentable3x3`, splits column 0 at ratio 1/3 and merges the adjacent children. Both new endpoints are proved nonperfect through the new negative APIs. Unequal child masses and row 2's two zero child masses are checked. |
| R13 | T concrete value-one VPM-to-VPS recovery retains actual equal values, disjoint supports, remembered mask and both support witnesses; a generic consumer uses the new VPM negative theorem. A second concrete negative VPM example is not required: the original 3x3 fixture has no disjoint-support pair. |
| R14 | Combined P/OP imports consume actual `OperationStep` endpoints and directed `OutputEquiv`. A non-involutive output permutation distinguishes forward and inverse labels. Existing one-output seed plus explicit finite/active/ambient transports remain covered. These are individual-edge/output consumers, with no path or cascade theorem. |

## 4. Manuscript correspondence

The source identities and exact local filenames remain in the approved plan and implementation notes. S05 freshly hashed both PDFs, extracted the complete designated scope and visually inspected new renders of ISIT pp. 3-4 and extended v16 pp. 4, 15-16. The correspondence below was rechecked against those pages and actual source, rather than inherited from an earlier report.

| Anchor | Logical content and formal boundary |
| --- | --- |
| ISIT III-B all-ones paragraph, pp. 3-4 | P seed is a rectangular one-output channel; C03 supplies perfectness. Repeated applications remain C10. |
| ISIT Lemma 5, p. 4; extended (175)-(177), p. 15 | Existing C02 full coordinate/vector witness and canonical/all-prior bridges interpret decoder, independence and Markov statements. All three positive theorems return this complete intrinsic witness. |
| Extended (178)-(183), p. 15 | Shared-selector PPS law and selected/unaffected posteriors; P's joint proof and R02-R04. |
| Extended (184)-(192), p. 15; (193)-(195), p. 16 | PPM collapse and input-independent admitted-value mixture, with exact finite PMF identities and null row products. The fixed selector weights do not become zero off support; their weighted row-mass contributions do. |
| Extended (196)-(198), p. 16 | One fixed row mask and deterministic map of the entire vector; C07 labels are adjacent children plus retained coordinates. |
| Extended (199)-(202), p. 16 | Printed (199) is the decoder, intervening prose gives independence, (200) gives actual-channel marginals, and (201)-(202) give common pushed child posteriors. The stronger Lean joint factorization and C02 bridges establish all of these. |
| ISIT Lemma 6 and recovery prose, p. 4; extended Lemma 6 proof, p. 16 | The three negative theorems follow by contraposition using the table below. Remembered recovery data and directed output equivalence formalize the inverse prose; no global inverse is asserted. |
| Adjacent Theorem 1/repeated-use prose and (203)-(221) | C10/C11 and C14 retain their allocations. Neither path reachability nor optimization is a C09 result. |

| Allegedly perfect endpoint | Forward theorem at the remembered recovery | Map from recovered output to original output |
| --- | --- | --- |
| PPS | PPM at the adjacent children, using equal support and legal singularity from C07 | `finCongr (ppsRecovery_outputCard ...)`, with `ppsRecovery_channel` |
| PPM | PPS at `activeMergeSurvivor`, with `ppmRatio` and both strict bounds | `ppmRecoveryEquiv`, with `ppmRecovery_channel` |
| VPM | VPS at the survivor, with `vpmRecoveryMask` and both selected-support witnesses | `vpmRecoveryEquiv`, with `vpmRecovery_channel` |

Each proof uses `.2` of `isPerfectlyRepresentableChannel_map_iff` to obtain perfectness of the mapped recovery channel, then rewrites that channel to the original. The equivalence is not silently replaced by its inverse.

## 5. Public API, ownership and trust

All fourteen public declarations belong to P: eight `ActiveFiniteChannel.allOnes*` declarations and six `MatrixOperations` implications. The complete authored declaration index below lists each individually. The seed requires finite nonempty input, has one active output and uses existing small-output semantics. The operation results preserve their exact C07 legality arguments and explicit singularity premise. No prior, full-support, input-cardinality or strict VPS-value assumption is added.

P imports only `Matrix.Operations`. Its local production closure consists of Channel, SingularColumns, OperationIndices, Operations, Preservation, and the existing FunctionalRepresentation/Canonical/Singularity semantics. T additionally imports OperationPaths and the public nonrepresentable example for consumers. OperationFactorization and OperationCalculus are absent from the production closure; the mathematical root remains unchanged.

The private construction families are the shared PPS lifts/collapse/posteriors, mixture transport and full joint proof; ordered PPM collapse/posteriors, row products and finite joint-mass proof; and deterministic VPS lift/posteriors and full joint proof. P's remaining private declarations are discriminating R02-R10 fixtures. T's private declarations are regression states and transport consumers. S04 adds no production helper. Generated equations and private names are included in the exhaustive imported P audit; anonymous examples are validated by compiling their modules.

The relevant dependency remains immutable LeanInfoTheory v0.1.0 (`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`), with mathlib `0df444a360eaa60ab8c11dca51a86af692955474` and Lean 4.33.1. S04 reuses public C03/C07/C09 interfaces rather than proving a new generic information-theory result. Source discovery and compiling probes found no new discoverability friction.

## 6. Completion readiness and later duties

| Criterion | S05 cumulative assessment and remaining owner |
| --- | --- |
| CC01 | Seed semantics, rectangular coordinates and existing C03 reuse are covered by P/R01. |
| CC02 | All three full intrinsic witnesses and every (175)-(202) obligation are mapped above. |
| CC03 | Three negative implications use the precise recovery directions; R11-R14 exercise the handoff. Neither VPM forward perfectness nor VPS forward nonperfectness is exposed. |
| CC04 | Null rows, fixed-ratio arithmetic, active support, retained labels, cardinalities, singleton cases and value one are explicit in R01-R13 and existing legality consumers. |
| CC05 | The minimal public API plus existing output/presentation transport supports C10's later individual-step use. Path folds, synthesis and normalization remain outside C09. |
| CC06 | All current tests, focused/default builds, cumulative signatures/axioms/imports and source hygiene are validation duties recorded below. S05 freshly runs its broader discovered maintained inventory. |
| CC07 | Source interpretations and omissions have dispositions in Section 7. No new unowned deferral or numbered Future Work Note is needed. |
| CC08 | Owning documents distinguish source coverage, retained earlier evidence, fresh S05 validation/review and later closeout. Original reports and historical checkpoints remain preserved. |
| CC09 | Fresh cumulative independent assessment covers all twelve earlier criteria, R01-R14 and CC01-CC08. The complete original report is retained and critically reconciled; no required finding or reassessment remains unresolved. Final applicable checks/F and supported durable closure follow this checkpoint. Only that later record satisfies CC09 in full and closes C09. |

## 7. Omissions, earlier advice and plan health

| Register/advice | Current disposition, owner and revisit trigger |
| --- | --- |
| OM-042/048: complete witness and numbered intermediates | Every logical anchor is allocated in Section 4. Private conditional/scalar identities need no public theorem per printed line. S05 freshly reassesses this crosswalk. |
| OM-051: inverse/reversal prose | S04 consumes C07's three remembered recoveries and directed comparisons to prove Lemma 6. C10 owns general path reversal/reachability, revisited in its approved plan. |
| OM-049: printed strict VPS range | Approved inclusive value-one domain is retained and tested. The strict-domain simulation stays unselected; revisit only after an explicit operation/recovery-contract decision. |
| OM-014/044/045/068; OM-038/052 | Existing active/finite boundaries and nonempty selected-support pieces remain. C10/C11 own zero weights, empty fibers, multiway partitions and synthesis when their plans are approved. |
| OM-058; OM-026/050 | No general deterministic/identical-row family or public fixture promotion. Revisit promotion only for actual consumer pressure beyond current private examples. |
| OM-010/011/012/022 and adjacent (167)-(174)/(203)-(221) | External applications remain excluded; restatements need no duplicate declarations. C08 owns normalization and C14 the future primal proof. |
| Revision-2 shared-choice/distinct-posterior suggestions | Adopted in R03 and R05-R07; current checks retain the discrimination. No further advice is left unowned. |
| Earlier independent findings | C03 ownership attribution, ISIT hash spelling and both S02 wording corrections remain in current source. Original reports/dispositions are preserved; no historical acceptance is rewritten. |
| S03 proof-route refinement | One joint-map calculation covers all VPS outputs, supported by explicit posterior equations and joint-mass checks. The normative mathematical contract is unchanged. |

No substantive plan change or new Future Work Note is currently indicated. S05 reassesses every existing owner/trigger and all original advice; required correctness or acceptance gaps cannot be deferred. No later chunk is authorized.

## 8. Current validation and review status

Fresh S05 validation passed: all 26 discovered maintained test/example/matrix modules (2798 jobs), separate default build (2762 jobs), all 106 maintained C09 anonymous checks, fourteen public signatures and all 241 imported P named constants with standard axioms only. The 203 authored declaration rows match current source exactly. The sole production import and eight-module local closure remain focused. Source/artifact/driver hashes match around the fresh audit.

The parent freshly verified the manuscript identities and inspected all designated manuscript pages and checked every anchor, criterion, regression and omission. Placeholder, inherited-source, normative-plan, root/pin, link, whitespace, omission-ID and artifact checks pass. Builds are incremental; named-constant and anonymous-check scopes are distinct. Helper source/inventory reports are attributed implementation assistance, not independent acceptance. No mathematical change is indicated.

Contextual self-review and separate reassessment completed. The same bound reviewer freshly reassessed the complete scope with all three S05 criteria satisfied. No material or optional findings were raised. The complete original report is retained and critically reconciled; exact independent commands, results and limits are attributed in the implementation notes. Final applicable checks/F and durable closure follow this maintained checkpoint. The fixed normative plan and inherited Lean source remain unchanged; no theorem family or public helper is added.

## 9. Complete authored declaration index

The following inventory is generated from the current P/T source and checked against it during validation. Public/private ownership is explicit. The exhaustive audit covers generated P constants in addition to these authored declarations; anonymous consumers are counted separately in the validation record.

| Source | Declaration | Ownership |
| --- | --- | --- |
| [P:36](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L36) | `allOnes` | public |
| [P:47](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L47) | `allOnes_outputCard` | public |
| [P:49](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L49) | `allOnes_channel` | public |
| [P:52](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L52) | `allOnes_apply` | public |
| [P:60](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L60) | `allOnes_massMatrix` | public |
| [P:64](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L64) | `allOnes_realMatrix` | public |
| [P:69](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L69) | `allOnes_isSingular` | public |
| [P:74](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L74) | `allOnes_isPerfectlyRepresentable` | public |
| [P:91](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L91) | `ppsVectorLift` | private |
| [P:95](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L95) | `ppsVectorLaw` | private |
| [P:99](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L99) | `ppsPosterior` | private |
| [P:107](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L107) | `ppsCollapse` | private |
| [P:110](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L110) | `ppsCollapse_right` | private |
| [P:113](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L113) | `ppsCollapse_keep` | private |
| [P:117](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L117) | `ppsCollapse_left` | private |
| [P:120](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L120) | `ppsCollapse_index` | private |
| [P:127](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L127) | `ppsPosterior_right` | private |
| [P:132](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L132) | `ppsPosterior_left` | private |
| [P:138](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L138) | `ppsPosterior_keep` | private |
| [P:145](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L145) | `map_binaryMixture` | private |
| [P:155](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L155) | `ppsVectorLaw_eq_shared_selector` | private |
| [P:167](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L167) | `pps_branch_factorization` | private |
| [P:179](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L179) | `pps_factorization` | private |
| [P:209](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L209) | `pps_isPerfectlyRepresentable` | public |
| [P:227](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L227) | `r03SourceVector` | private |
| [P:228](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L228) | `r03LeftVector` | private |
| [P:229](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L229) | `r03RightVector` | private |
| [P:230](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L230) | `r03MixedVector` | private |
| [P:231](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L231) | `r03SourceLaw` | private |
| [P:232](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L232) | `r03SourcePosterior` | private |
| [P:233](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L233) | `r03Channel` | private |
| [P:234](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L234) | `r03Weight` | private |
| [P:235](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L235) | `r03Weight_pos` | private |
| [P:236](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L236) | `r03Weight_lt_one` | private |
| [P:237](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L237) | `r03Complement` | private |
| [P:241](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L241) | `r03Factor` | private |
| [P:245](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L245) | `r03Perfect` | private |
| [P:248](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L248) | `r03State` | private |
| [P:258](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L258) | `r03Target` | private |
| [P:261](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L261) | `r03TargetChannel` | private |
| [P:270](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L270) | `r03Row0` | private |
| [P:274](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L274) | `r03Row1` | private |
| [P:278](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L278) | `r03Row2` | private |
| [P:283](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L283) | `r03Law` | private |
| [P:286](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L286) | `r03Posterior` | private |
| [P:289](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L289) | `r03LiftLeft` | private |
| [P:290](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L290) | `r03LiftRight` | private |
| [P:291](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L291) | `r03Vectors_ne` | private |
| [P:292](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L292) | `r03LeftMixed_ne` | private |
| [P:293](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L293) | `r03RightMixed_ne` | private |
| [P:295](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L295) | `r03Law_eq` | private |
| [P:329](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L329) | `r03Posterior_unaffected` | private |
| [P:348](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L348) | `r03IndependentMap` | private |
| [P:349](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L349) | `r03IndependentMap_injective` | private |
| [P:355](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L355) | `r03IndependentLaw` | private |
| [P:376](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L376) | `r03Posterior_left` | private |
| [P:382](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L382) | `r03Posterior_right` | private |
| [P:400](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L400) | `r03FullFactorization` | private |
| [P:439](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L439) | `ppmCollapse` | private |
| [P:444](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L444) | `ppmVectorLift` | private |
| [P:448](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L448) | `ppmVectorLaw` | private |
| [P:453](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L453) | `ppmPosterior` | private |
| [P:462](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L462) | `ppmCollapse_left` | private |
| [P:466](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L466) | `ppmCollapse_right` | private |
| [P:470](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L470) | `ppmCollapse_retained` | private |
| [P:475](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L475) | `ppmPosterior_survivor` | private |
| [P:483](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L483) | `ppmPosterior_unaffected` | private |
| [P:491](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L491) | `ppm_row_products` | private |
| [P:510](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L510) | `ppm_pair_map_apply` | private |
| [P:519](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L519) | `ppm_joint_mass` | private |
| [P:540](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L540) | `ppm_factorization` | private |
| [P:573](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L573) | `ppm_isPerfectlyRepresentable` | public |
| [P:583](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L583) | `r05A` | private |
| [P:584](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L584) | `r05B` | private |
| [P:585](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L585) | `r05Weight` | private |
| [P:586](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L586) | `r05Weight_pos` | private |
| [P:587](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L587) | `r05Weight_lt_one` | private |
| [P:588](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L588) | `r05Complement` | private |
| [P:591](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L591) | `r05SourceLaw` | private |
| [P:593](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L593) | `r05SourcePosterior` | private |
| [P:595](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L595) | `r05Channel` | private |
| [P:597](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L597) | `r05Posterior_onA` | private |
| [P:599](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L599) | `r05Posterior_onB` | private |
| [P:601](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L601) | `r05SourceFactor` | private |
| [P:609](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L609) | `r05Perfect` | private |
| [P:612](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L612) | `r05SourceWeights` | private |
| [P:614](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L614) | `r05SourceMass` | private |
| [P:621](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L621) | `r05State` | private |
| [P:636](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L636) | `r05Pattern` | private |
| [P:641](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L641) | `r05Value0` | private |
| [P:651](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L651) | `r05Value3` | private |
| [P:661](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L661) | `r05SumValues` | private |
| [P:666](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L666) | `r05Ratio` | private |
| [P:671](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L671) | `r05CollapsedA` | private |
| [P:672](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L672) | `r05CollapsedB` | private |
| [P:673](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L673) | `r05OtherVector` | private |
| [P:674](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L674) | `r05Collapsed_ne` | private |
| [P:675](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L675) | `r05CollapsedA_other` | private |
| [P:676](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L676) | `r05CollapsedB_other` | private |
| [P:678](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L678) | `r05Collapse` | private |
| [P:681](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L681) | `r05Survivor` | private |
| [P:684](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L684) | `r05Retained` | private |
| [P:686](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L686) | `r05LiftA` | private |
| [P:689](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L689) | `r05LiftB` | private |
| [P:692](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L692) | `r05CollapseA` | private |
| [P:694](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L694) | `r05CollapseB` | private |
| [P:697](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L697) | `r05TargetChannel` | private |
| [P:699](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L699) | `r05Law` | private |
| [P:701](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L701) | `r05Posterior` | private |
| [P:704](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L704) | `r05TargetChannel_map` | private |
| [P:709](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L709) | `r05TargetRow` | private |
| [P:718](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L718) | `r05TargetRow0` | private |
| [P:722](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L722) | `r05TargetRow1` | private |
| [P:726](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L726) | `r05TargetRow2` | private |
| [P:730](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L730) | `r05Law_eq` | private |
| [P:738](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L738) | `r05Posterior0` | private |
| [P:745](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L745) | `r05Posterior1` | private |
| [P:751](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L751) | `r05Posterior2` | private |
| [P:819](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L819) | `r05FullFactorization` | private |
| [P:849](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L849) | `r05RecoveryChannel` | private |
| [P:888](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L888) | `vpsVectorLift` | private |
| [P:892](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L892) | `vpsVectorLaw` | private |
| [P:896](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L896) | `vpsPosterior` | private |
| [P:900](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L900) | `vpsPosterior_left` | private |
| [P:905](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L905) | `vpsPosterior_right` | private |
| [P:910](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L910) | `vpsPosterior_keep` | private |
| [P:915](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L915) | `vps_factorization` | private |
| [P:929](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L929) | `vps_isPerfectlyRepresentable` | public |
| [P:951](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L951) | `r08Mask` | private |
| [P:952](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L952) | `r08SourceVector` | private |
| [P:953](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L953) | `r08Vector` | private |
| [P:954](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L954) | `r08SourceLaw` | private |
| [P:955](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L955) | `r08SourcePosterior` | private |
| [P:956](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L956) | `r08SourceFactor` | private |
| [P:961](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L961) | `r08Left` | private |
| [P:964](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L964) | `r08Right` | private |
| [P:967](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L967) | `r08TargetChannel` | private |
| [P:970](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L970) | `r08Law` | private |
| [P:971](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L971) | `r08Posterior` | private |
| [P:973](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L973) | `r08Lift` | private |
| [P:976](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L976) | `r08Law_eq` | private |
| [P:979](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L979) | `r08Posterior_left` | private |
| [P:984](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L984) | `r08Posterior_right` | private |
| [P:989](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L989) | `r08TargetRow` | private |
| [P:993](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L993) | `r08Value` | private |
| [P:1022](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1022) | `r08FullFactorization` | private |
| [P:1039](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1039) | `r09Mask` | private |
| [P:1040](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1040) | `r09AltMask` | private |
| [P:1041](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1041) | `r09BadMask` | private |
| [P:1042](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1042) | `r09A` | private |
| [P:1043](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1043) | `r09B` | private |
| [P:1044](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1044) | `r09Other` | private |
| [P:1045](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1045) | `r09AB_ne` | private |
| [P:1046](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1046) | `r09AOther_ne` | private |
| [P:1047](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1047) | `r09BOther_ne` | private |
| [P:1048](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1048) | `r09SelectedSupport` | private |
| [P:1052](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1052) | `r09Left` | private |
| [P:1054](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1054) | `r09Right` | private |
| [P:1056](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1056) | `r09AltLeft` | private |
| [P:1058](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1058) | `r09AltRight` | private |
| [P:1060](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1060) | `r09TargetChannel` | private |
| [P:1062](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1062) | `r09Law` | private |
| [P:1063](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1063) | `r09Posterior` | private |
| [P:1065](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1065) | `r09LiftA` | private |
| [P:1068](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1068) | `r09LiftB` | private |
| [P:1071](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1071) | `r09Law_eq` | private |
| [P:1075](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1075) | `r09Posterior0` | private |
| [P:1080](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1080) | `r09Posterior1` | private |
| [P:1085](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1085) | `r09Posterior2` | private |
| [P:1090](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1090) | `r09Posterior3` | private |
| [P:1095](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1095) | `r09Posterior4` | private |
| [P:1100](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1100) | `r09TargetRow` | private |
| [P:1108](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1108) | `r09Weights` | private |
| [P:1110](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1110) | `r09Mass` | private |
| [P:1150](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1150) | `r09FullFactorization` | private |
| [P:1192](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1192) | `pps_not_isPerfectlyRepresentable` | public |
| [P:1211](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1211) | `ppm_not_isPerfectlyRepresentable` | public |
| [P:1229](../PerfectFunctionalRepresentations/Matrix/Preservation.lean#L1229) | `vpm_not_isPerfectlyRepresentable` | public |
| [T:50](../PerfectFunctionalRepresentations/Tests/Matrix/Preservation.lean#L50) | `seedAmbient` | private |
| [T:59](../PerfectFunctionalRepresentations/Tests/Matrix/Preservation.lean#L59) | `seedAmbient_perfect` | private |
| [T:232](../PerfectFunctionalRepresentations/Tests/Matrix/Preservation.lean#L232) | `r12State` | private |
| [T:243](../PerfectFunctionalRepresentations/Tests/Matrix/Preservation.lean#L243) | `r12Weight` | private |
| [T:244](../PerfectFunctionalRepresentations/Tests/Matrix/Preservation.lean#L244) | `r12Weight_pos` | private |
| [T:245](../PerfectFunctionalRepresentations/Tests/Matrix/Preservation.lean#L245) | `r12Weight_lt` | private |
| [T:246](../PerfectFunctionalRepresentations/Tests/Matrix/Preservation.lean#L246) | `r12Complement` | private |
| [T:249](../PerfectFunctionalRepresentations/Tests/Matrix/Preservation.lean#L249) | `r12Split` | private |
| [T:251](../PerfectFunctionalRepresentations/Tests/Matrix/Preservation.lean#L251) | `r12Split_singular` | private |
| [T:254](../PerfectFunctionalRepresentations/Tests/Matrix/Preservation.lean#L254) | `r12Pattern` | private |
| [T:258](../PerfectFunctionalRepresentations/Tests/Matrix/Preservation.lean#L258) | `r12Merge` | private |
| [T:261](../PerfectFunctionalRepresentations/Tests/Matrix/Preservation.lean#L261) | `r12Left` | private |
| [T:265](../PerfectFunctionalRepresentations/Tests/Matrix/Preservation.lean#L265) | `r12Right` | private |
| [T:270](../PerfectFunctionalRepresentations/Tests/Matrix/Preservation.lean#L270) | `r12ChildMass` | private |
| [T:304](../PerfectFunctionalRepresentations/Tests/Matrix/Preservation.lean#L304) | `r13State` | private |
| [T:309](../PerfectFunctionalRepresentations/Tests/Matrix/Preservation.lean#L309) | `r13Singular` | private |
| [T:317](../PerfectFunctionalRepresentations/Tests/Matrix/Preservation.lean#L317) | `r13Value` | private |
| [T:321](../PerfectFunctionalRepresentations/Tests/Matrix/Preservation.lean#L321) | `r13Values` | private |
| [T:325](../PerfectFunctionalRepresentations/Tests/Matrix/Preservation.lean#L325) | `r13Disjoint` | private |
| [T:328](../PerfectFunctionalRepresentations/Tests/Matrix/Preservation.lean#L328) | `r13Merge` | private |
| [T:330](../PerfectFunctionalRepresentations/Tests/Matrix/Preservation.lean#L330) | `r13Recovery` | private |
| [T:332](../PerfectFunctionalRepresentations/Tests/Matrix/Preservation.lean#L332) | `r13Comparison` | private |
| [T:361](../PerfectFunctionalRepresentations/Tests/Matrix/Preservation.lean#L361) | `r14OutputIff` | private |
| [T:384](../PerfectFunctionalRepresentations/Tests/Matrix/Preservation.lean#L384) | `r14Unused` | private |
| [T:474](../PerfectFunctionalRepresentations/Tests/Matrix/Preservation.lean#L474) | `r12Split_not_perfect` | private |
