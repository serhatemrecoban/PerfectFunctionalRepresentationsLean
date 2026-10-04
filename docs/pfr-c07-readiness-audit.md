# PFR-C07 cumulative readiness audit

Updated 2026-09-21. **S01-S04 are durably complete; S05 fresh cumulative
independent review is critically reconciled.** This final documentation checkpoint
precedes applicable final checks, F capture and the supported durable record that
establishes chunk completion. This parent map does not replace those records.
The [approved revision-2 plan](plans/pfr-c07-four-typed-matrix-operations.md)
owns the contract; [implementation notes](pfr-c07-implementation-notes.md)
own the original reports, exact execution references and validation history.

S01-S04 are durably complete with their original reports critically reconciled.
S04 closed under
`f7ed3e569bd960c1e032c62e111cbe67ccddaaca4458c453300b2f586a38e0d4`.
Before accepting S05, all 114 final source/environment inventory entries exactly
matched F `f2c6c597bcbabcdc8908f3dd0e1e07d7e748f15393ba308a2bbef453b056b1fe`.
Earlier pre-F records remain historical. The same bound reviewer is retained;
requested Astra/ultra/no-parent-history, effective settings unknown. The separate
S05 request authorizes fresh assessment of all twelve S01-S04 criteria.

## Manuscript and interpretation map

S04 freshly hashes the two designated binaries and visually rereads ISIT p. 3
and extended v16 pp. 3-4 using freshly rendered helper-owned pages. The files
and page images remain external or ignored. Only III-A's allocated mathematics
and relevant recovery prose are in scope; neighboring later claims are context.

| Source | Identity and allocated anchors |
| --- | --- |
| Six-page ISIT final, filename ending `final_manuscript_ (3).pdf` | SHA-256 `48963AA59485B2C33B1A1E6E7C6EAD2251FDDDD26BD3691B6FCFFE683E6ED1C4`; III-A p. 3, operations 1-4, Examples 2-5 and Equations (11)-(15). Definition 4 is the completed C06 boundary. |
| Eighteen-page extended draft, version 16, designated 2026-09-03 | SHA-256 `98636D4C9F0618EC08FCA84559572780F604F197FDA90D8D7C787B3624245B8F`; III-A pp. 3-4, same operations/examples and full source merge-index range. III-B inverse prose informs the approved witnessed-recovery contracts only. |

Input rows and output columns retain paper order; labels shift from one-based
paper coordinates to zero-based `Fin`. Adjacent children are inserted in order;
merging retains the lower label and removes the higher. Numeric cardinality
casts do not choose a new enumeration. Recovery maps from the adjacent-resplit
order to the original order; its inverse acts on the original row.

| Interpretation / omission | Current disposition and later owner |
| --- | --- |
| OM-014, OM-044, OM-045, OM-068 | Reuse C06 active states, exact/Real coordinates, data and transport. No values for zero columns. C10/C11 retain later zero-weight/fiber removal. |
| OM-024 / duplicate OM-070 | Extended v16 supplies all `m+1` source labels. General index laws and final-column regressions implement the repair; Example 3 merges actual indices 3/4. OM-070 remains a historical cross-reference. |
| OM-026 / OM-050 | Complete parametric fixtures stay private; no demonstrated consumer needs public example names. Strict `0 < beta < 1` keeps all five source columns active. Zero/unit beta fail activity; this does not narrow general VP legality. Revisit naming only for a concrete C08/C09 consumer. |
| OM-037 | Closure is proved by active-state construction and separate singularity theorems. No theorem is attached to the prose adjective “straightforward”; completed canonical mathematics is reused. |
| OM-038 | VPS needs two nonempty pieces inside the selected support. Raw degenerate splits create no admitted column data. C08/C10 may revisit pruning only for a concrete need. |
| OM-049 | Approved inclusive value-one VPS domain is explicit, despite the printed strict bound. The strict-domain five-operation alternative remains unselected; C09 could own that bounded alternative only under an approved contract revision. |
| OM-051 | Four witnessed recoveries retain ratio or original support, exact adjacent rows and explicit nonadjacent equivalence. No global inverse or unique off-support mask. C08 retains path equivalence and normalization. |
| OM-052 | C10/C11 own later multiway/partition constructions. |
| OM-042 / OM-043 | C08 owns Lemma 4 and extended (167)-(174); C09 owns preservation Lemmas 5-6 and extended (175)-(202). No such theorem is implemented here. |

All seventy omission IDs remain. No numbered Future Work Note is open. No new
abstraction, dependency upgrade, operation relation, prior restriction or
information-theory theorem is needed for this handoff.

## Modules, assumptions and public boundary

| Key | Actual owner |
| --- | --- |
| I | [Matrix/OperationIndices](../PerfectFunctionalRepresentations/Matrix/OperationIndices.lean): 34 public finite-index declarations; focused Fin imports only. |
| O | [Matrix/Operations](../PerfectFunctionalRepresentations/Matrix/Operations.lean): 199 public declarations, shared PMF core, legal pairs and recovery. Imports supported `LeanInfoTheory.Probability.FiniteMixture`, I and C06 Channel/SingularColumns. |
| T | [Tests/Matrix/Operations](../PerfectFunctionalRepresentations/Tests/Matrix/Operations.lean): R01-R13 boundary regressions and S04 R15 generic public consumers. |
| E | [Tests/Examples/MatrixOperations](../PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean): private shared Real-parametric source and complete Equations (11)-(15), R14. |
| Prerequisites | [C06 Channel](../PerfectFunctionalRepresentations/Matrix/Channel.lean), [C06 SingularColumns](../PerfectFunctionalRepresentations/Matrix/SingularColumns.lean), their tests, [Definition 4 fixture](../PerfectFunctionalRepresentations/Tests/Examples/Nonrepresentable3x3Columns.lean), and [C03 singularity tests](../PerfectFunctionalRepresentations/Tests/Semantics/Singularity.lean). |
| Root | [PerfectFunctionalRepresentations.lean](../PerfectFunctionalRepresentations.lean): unchanged lightweight mathematical imports. Operations, matrix tests and examples remain separately imported. |

Raw PMF constructions allow arbitrary inputs and need no singularity or input
nonemptiness. Active constructors require only `Finite`/`Nonempty` inputs and
separate singularity; all output labels are active by construction. PPS requires
a strict NNReal ratio; PPM requires identical support; VPS requires both selected
support witnesses; VPM requires equal admitted values and disjoint support.
Only explicit finite-set pattern formulas expose `Fintype`; the numeric divided
indicator bridge enumerates internally. No default label or prior enters.

PP recovery derives strict ratio, denominator positivity/finiteness and both
weight-product identities from the original values. VP recovery uses the original
lower-support indicator. The public cardinality equations and explicit map
equations expose all four actual recovered endpoints. R15 consumes C06 relabeling
on these endpoints using their proved row equations. This establishes existing
invariance under relabeling of a recovered channel, not preservation under an
individual operation. C08/C09 still own their full mathematical constructions.

## Regression-to-contract map

| ID | Actual production contract and maintained consumer |
| --- | --- |
| R01 | I split/merge/fiber/permutation laws; T first/last split, adjacent/nonadjacent/final merge and non-involutive direction checks. |
| R02 | O raw kernel/map, exact/Real coordinates and row sums; T generic unrestricted inputs, including empty/infinite instances. |
| R03 | I dimensions/transport; T singleton source split, impossible distinct singleton merge and actual inverse coordinate transport. |
| R04 | O legal PPS, activity/data; T value-one source, unequal strict weights and unaffected column. |
| R05 | O legal PPM/data; T repeated support, unequal positive values, sum one and final selected label. |
| R06 | O `ppsRecovery_channel` and `ppmRatio_pps`; T every-row adjacent recovery and remembered unequal ratio. |
| R07 | O `ppmRecovery`, `ppmRecoveryEquiv` and forward/inverse laws; T all numeric masses for original `[1/10,2/10,3/10,4/10]`, merge0/3, recovered ratio1/5, actual correct maps and wrong-direction inequality. |
| R08 | O strict PPS/same-support PPM domains; T inactive raw endpoint child and failed unequal-pattern merge premise. |
| R09 | O VPS data/support/indicator formulas; T value-one singleton-output source, row-dependent map, proper-support filters and null row. |
| R10 | O selected-support legality/mask irrelevance; T ambient-nonconstant but support-degenerate mask, impossible singleton-support split and off-support changes. |
| R11 | O VPM value/disjointness bridges; T common value one, nonadjacent final index, union/unaffected data and each weaker-legality failure. |
| R12 | O `vpsRecovery_channel`, `vpsRecovery_mask_legal`, `vpsRecovery_resplit`; T every-row adjacent recovery and legal resplit including null selected row. |
| R13 | O `vpmRecoveryMask`, witnesses, actual forward/inverse/permutation laws; T original support mask and every-row nonadjacent recovery. |
| R14 | E constructs shared source through C06 Real reconstruction, proves every entry of (11)-(15), all source columns active/singular, explicit legal operations at the specified labels, and inactive endpoint columns. |
| R15 | T generic constructor/kernel/map/data/recovery consumers and C06 relabeling of actual recovered endpoints. Public declarations alone supply every witness; later preservation is not assumed or proved. |
| R16 | Required C06/root/Definition 4/C03 builds plus production import/root audit; no operation/test/example root import or hidden prior assumption. |

## Earlier criteria and completion outcomes

All twelve earlier criteria have their original independent reports and durable
step closures. Their actual declaration families and cumulative consumers are
mapped here for the separately requested S05 cumulative assessment. Earlier
checks do not substitute for that fresh independent assessment.

| Criterion | Source/consumer coverage |
| --- | --- |
| C07-S01-C01 | I all ordered split/merge/fiber/rho laws; R01/R03, R07 and R13. |
| C07-S01-C02 | O raw PMF semantic/exact/Real/row-sum families; R02/R03 and all complete paper displays. |
| C07-S01-C03 | R01-R03, focused/default/prerequisite and full signature/axiom/import checks; source-order repair and raw boundary documented. |
| C07-S02-C01 | O legal PPS/PPM, dimensions, activity, singularity, all coordinates and column data; R04/R05/R08 and Examples 2/3. |
| C07-S02-C02 | O strict derived ratio, both product identities and two legal PP recoveries with explicit permutation; R06/R07/R15. |
| C07-S02-C03 | R04-R08 cumulative validation, public semantic/recovery access and source/order/numeric notes; R15. |
| C07-S03-C01 | O legal VPS/VPM, complete closure/data/support/indicator bridges; R09-R11 and Examples 4/5, including general value one. |
| C07-S03-C02 | O both legal VP recoveries, mask witnesses/resplit, selected/unaffected coordinates, explicit forward/inverse/adjacent equivalence; R12/R13/R15. |
| C07-S03-C03 | R09-R13 cumulative validation, weaker-legality failures, documented manuscript departure and later consumer boundaries. |
| C07-S04-C01 | R14 complete parametric Equations (11)-(15), exact/Real bridges, explicit legality and printed order. |
| C07-S04-C02 | R01-R16 and R15 public consumers; this declaration/anchor/criterion map and all ten outcome rows. |
| C07-S04-C03 | Actual relevant/default builds, full public API/trust/import and source checks; owning documents distinguish readiness, report reconciliation, F capture and closure. |

| Outcome | Cumulative source/evidence and boundary |
| --- | --- |
| CC01 | Authenticated manuscripts and interpretation/omission table above; exact III-A allocation and later owners retained. |
| CC02 | I order/dimensions, O four legal constructors and explicit wrapper/cardinality equations; R01/R03/R04/R05/R09/R11/R14/R15. |
| CC03 | O PPS kernel/common merge/VPS row map, semantic equations and exact/Real selected/unaffected formulas; R02/R14/R15. |
| CC04 | Four active-state constructors, separate singularity and exact/Real row sums; permitted edge regressions and complete fixtures. |
| CC05 | O values/patterns, support/indicator iff bridges and unaffected data; R04/R05/R09-R11, generic consumers. |
| CC06 | Four witnessed recoveries, strict PP ratio/products, legal VP masks, explicit cardinality plus new-to-original equivalence and inverse/adjacent laws; R06/R07/R12/R13/R15. |
| CC07 | Approved inclusive VP domain, selected-support guards and full parametric Examples 2-5 under their distinct strict beta hypothesis. |
| CC08 | R01-R16 and usable public downstream boundary; no C08/C09 preservation/path theorem or new dependency cycle. |
| CC09 | Required builds, all 233 public signatures/axioms, focused imports/root exclusion, no placeholders, clean immutable pins and inherited-worktree ownership audit. |
| CC10 | Owning documents, original reports and omission/deferral dispositions support review-time readiness. S04 report/reconciliation/final closure and S05 cumulative report/reconciliation/closure remain separately recorded events; this row does not pre-certify them. |

## Declaration-to-anchor/criterion/consumer inventory

Every public C07 declaration appears in exactly one family below. The family
row maps its actual source range to the relevant manuscript interpretation,
approved criteria and maintained consumers. Some infrastructure lemmas implement
the representation boundary rather than a separately printed paper statement.
Private proof helpers and private fixtures are intentionally outside this
public inventory; their enclosing theorems/examples compile in the builds.

The short names below all belong to `PerfectFunctionalRepresentations.MatrixOperations`.

| Family | Source | Manuscript / representation anchor | Earlier criteria | Maintained consumers |
| --- | --- | --- | --- | --- |
| I01 | [OperationIndices:23](../PerfectFunctionalRepresentations/Matrix/OperationIndices.lean#L23) | III-A adjacent split order | C07-S01-C01 | R01/R03/R14 |
| I02 | [OperationIndices:54](../PerfectFunctionalRepresentations/Matrix/OperationIndices.lean#L54) | III-A lower-survivor merge; extended full range | C07-S01-C01 | R01/R03/R05/R11/R14 |
| I03 | [OperationIndices:131](../PerfectFunctionalRepresentations/Matrix/OperationIndices.lean#L131) | Approved Section6 recovery order | C07-S01-C01, C07-S02-C02, C07-S03-C02 | R01/R07/R13/R15 |
| O01 | [Operations:39](../PerfectFunctionalRepresentations/Matrix/Operations.lean#L39) | III-A semantic PPS/merge/VPS constructions | C07-S01-C02 | R02/R14/R15 |
| O02 | [Operations:128](../PerfectFunctionalRepresentations/Matrix/Operations.lean#L128) | III-A all raw exact/Real coordinates and normalization | C07-S01-C02 | R02/R03/R14 |
| O03 | [Operations:302](../PerfectFunctionalRepresentations/Matrix/Operations.lean#L302) | III-A PPS legal closure and Definition4 data | C07-S02-C01 | R04/R06/R08/R14/R15 |
| O04 | [Operations:496](../PerfectFunctionalRepresentations/Matrix/Operations.lean#L496) | Approved Section3.2 numeric cardinality transport | C07-S02-C01, C07-S03-C01 | R05/R07/R11/R13/R15 |
| O05 | [Operations:565](../PerfectFunctionalRepresentations/Matrix/Operations.lean#L565) | III-A PPM legal closure, value/pattern and sum bound | C07-S02-C01 | R05/R08/R14/R15 |
| O06 | [Operations:776](../PerfectFunctionalRepresentations/Matrix/Operations.lean#L776) | Approved Section6 adjacent PP recovery | C07-S02-C02 | R06/R15 |
| O07 | [Operations:857](../PerfectFunctionalRepresentations/Matrix/Operations.lean#L857) | Approved Section6 strict inverse ratio and products | C07-S02-C02 | R06/R07/R15 |
| O08 | [Operations:956](../PerfectFunctionalRepresentations/Matrix/Operations.lean#L956) | PPS wrapper map, remembered ratio, legal adjacent recovery | C07-S02-C02 | R06/R15 |
| O09 | [Operations:999](../PerfectFunctionalRepresentations/Matrix/Operations.lean#L999) | PPM-to-PPS legal recovery and explicit transport | C07-S02-C02 | R07/R15 |
| O10 | [Operations:1148](../PerfectFunctionalRepresentations/Matrix/Operations.lean#L1148) | III-A VPS support interpretation: null-row irrelevance | C07-S03-C01 | R10 |
| O11 | [Operations:1172](../PerfectFunctionalRepresentations/Matrix/Operations.lean#L1172) | III-A VPS closure/value/support/Real indicators | C07-S03-C01 | R09/R10/R14/R15 |
| O12 | [Operations:1409](../PerfectFunctionalRepresentations/Matrix/Operations.lean#L1409) | III-A VPS finite-set partition and witness bridge | C07-S03-C01 | R09/R10/R15 |
| O13 | [Operations:1476](../PerfectFunctionalRepresentations/Matrix/Operations.lean#L1476) | III-A VPM legal closure and exact/Real values | C07-S03-C01 | R11/R14/R15 |
| O14 | [Operations:1620](../PerfectFunctionalRepresentations/Matrix/Operations.lean#L1620) | III-A VPM disjointness/0-1/divided-indicator equivalences | C07-S03-C01 | R11/R15 |
| O15 | [Operations:1675](../PerfectFunctionalRepresentations/Matrix/Operations.lean#L1675) | III-A VPM union and unaffected patterns | C07-S03-C01 | R11 |
| O16 | [Operations:1712](../PerfectFunctionalRepresentations/Matrix/Operations.lean#L1712) | Approved Section6 raw adjacent VP recovery | C07-S03-C02 | R12/R15 |
| O17 | [Operations:1761](../PerfectFunctionalRepresentations/Matrix/Operations.lean#L1761) | Approved Section6 remembered original support mask | C07-S03-C02 | R13/R15 |
| O18 | [Operations:1775](../PerfectFunctionalRepresentations/Matrix/Operations.lean#L1775) | Legal VPS-to-VPM recovery and remembered-mask resplit | C07-S03-C02 | R12/R15 |
| O19 | [Operations:1854](../PerfectFunctionalRepresentations/Matrix/Operations.lean#L1854) | Legal VPM-to-VPS recovery and explicit transport | C07-S03-C02 | R13/R15 |

### I01 (10 declarations)

`splitLeft`, `splitRight`, `splitKeep`, `splitKeep_self`, `splitKeep_injective`, `splitKeep_ne_right`, `splitLeft_ne_right`, `split_cases`, `splitKeep_of_le`, `splitKeep_of_lt`.

### I02 (11 declarations)

`mergeSurvivor`, `mergeSurvivor_succAbove`, `mergeSurvivor_val`, `mergeIndex`, `mergeIndex_right`, `mergeIndex_succAbove`, `mergeIndex_left`, `mergeIndex_fiber_survivor`, `mergeIndex_fiber_ne`, `mergeIndex_val_of_lt`, `mergeIndex_val_of_gt`.

### I03 (13 declarations)

`recoveryPerm`, `recoveryPerm_right`, `recoveryPerm_keep`, `recoveryPerm_left`, `recoveryPerm_symm_right`, `recoveryPerm_symm_keep`, `recoveryPerm_val`, `recoveryPerm_fixed_of_le`, `recoveryPerm_fixed_of_gt`, `recoveryPerm_second`, `recoveryPerm_between_val`, `recoveryPerm_symm_val`, `recoveryPerm_adjacent`.

### O01 (12 declarations)

`ppsKernel`, `ppsKernel_selected`, `ppsKernel_unaffected`, `ppsRaw`, `ppsRaw_apply_bind`, `mergeRaw`, `mergeRaw_apply_map`, `vpsIndex`, `vpsIndex_selected`, `vpsIndex_unaffected`, `vpsRaw`, `vpsRaw_apply_map`.

### O02 (23 declarations)

`ppsRaw_left`, `ppsRaw_right`, `ppsRaw_keep`, `mergeRaw_survivor`, `mergeRaw_unaffected`, `vpsRaw_left`, `vpsRaw_right`, `vpsRaw_keep`, `ppsRaw_row_sum`, `mergeRaw_row_sum`, `vpsRaw_row_sum`, `splitRatio_complement`, `ppsRaw_real_left`, `ppsRaw_real_right`, `ppsRaw_real_keep`, `mergeRaw_real_survivor`, `mergeRaw_real_unaffected`, `vpsRaw_real_left`, `vpsRaw_real_right`, `vpsRaw_real_keep`, `ppsRaw_real_row_sum`, `mergeRaw_real_row_sum`, `vpsRaw_real_row_sum`.

### O03 (25 declarations)

`pps`, `pps_outputCard`, `pps_channel`, `pps_apply_bind`, `pps_left`, `pps_right`, `pps_keep`, `pps_left_ne_zero_iff`, `pps_right_ne_zero_iff`, `pps_children_sameSupport`, `pps_isSingular`, `pps_real_left`, `pps_real_right`, `pps_real_keep`, `pps_row_sum`, `pps_real_row_sum`, `columnValue_pps_left`, `columnValue_pps_right`, `columnValue_pps_keep`, `columnValue_pps_left_toReal`, `columnValue_pps_right_toReal`, `columnValue_pps_keep_toReal`, `columnPattern_pps_left`, `columnPattern_pps_right`, `columnPattern_pps_keep`.

### O04 (14 declarations)

`mergeSource_card`, `mergeSourceEquiv`, `mergeSourceEquiv_val`, `mergeSourceEquiv_symm_val`, `mergeSourceEquiv_lt_iff`, `mergeSourceEquiv_map_apply`, `mergeSourceEquiv_isSingular`, `mergeSourceEquiv_active`, `activeMergeSurvivor`, `activeMergeRetained`, `activeMergeRetained_source`, `activeMergeSurvivor_val`, `activeMergeRetained_survivor`, `activeMerge_two_le`.

### O05 (20 declarations)

`ppm`, `ppm_outputCard`, `ppm_channel`, `ppm_channel_map`, `ppm_apply_survivor`, `ppm_apply_unaffected`, `ppm_isSingular`, `ppm_real_survivor`, `ppm_real_unaffected`, `ppm_row_sum`, `ppm_real_row_sum`, `ppm_columnValue_survivor`, `ppm_columnValue_unaffected`, `ppm_columnValue_sum_le_one`, `ppm_columnValue_real_survivor`, `ppm_columnValue_real_unaffected`, `ppm_columnValue_real_sum_le_one`, `same_support_iff_columnPattern_eq`, `ppm_columnPattern_survivor`, `ppm_columnPattern_unaffected`.

### O06 (1 declarations)

`mergeRaw_ppsRaw`.

### O07 (8 declarations)

`ppmRatio`, `ppmRatio_denominator_pos`, `ppmRatio_denominator_ne_top`, `ppmRatio_pos`, `ppmRatio_lt_one`, `ppmRatio_mul_sum`, `ppmRatio_complement_mul_sum`, `ppmRatio_toReal`.

### O08 (5 declarations)

`pps_channel_map`, `ppmRatio_pps`, `ppsRecovery`, `ppsRecovery_outputCard`, `ppsRecovery_channel`.

### O09 (11 declarations)

`ppmRecovery`, `ppmRecovery_outputCard`, `ppmRecovery_left`, `ppmRecovery_right`, `ppmRecovery_keep`, `ppmRecoveryEquiv`, `ppmRecovery_channel`, `ppmRecovery_channel_inverse`, `ppmRecovery_reindex`, `ppmRecovery_reindex_inverse`, `ppmRecovery_adjacent`.

### O10 (1 declarations)

`vpsRaw_mask_irrelevant`.

### O11 (29 declarations)

`vps`, `vps_outputCard`, `vps_channel`, `vps_apply_map`, `vps_channel_map`, `vps_left`, `vps_right`, `vps_keep`, `vps_left_ne_zero_iff`, `vps_right_ne_zero_iff`, `vps_children_disjoint`, `vps_children_support_union`, `vps_isSingular`, `vps_real_left`, `vps_real_right`, `vps_real_keep`, `vps_row_sum`, `vps_real_row_sum`, `columnValue_vps_left`, `columnValue_vps_right`, `columnValue_vps_keep`, `columnValue_vps_left_toReal`, `columnValue_vps_right_toReal`, `columnValue_vps_keep_toReal`, `vps_support_indicator_sum`, `vps_indicator_left`, `vps_indicator_right`, `vps_indicator_sum`, `vps_mask_irrelevant`.

### O12 (6 declarations)

`vps_witness_iff_filter_nonempty`, `columnPattern_vps_left`, `columnPattern_vps_right`, `columnPattern_vps_keep`, `columnPattern_vps_disjoint`, `columnPattern_vps_union`.

### O13 (16 declarations)

`vpm`, `vpm_outputCard`, `vpm_channel`, `vpm_channel_map`, `vpm_apply_survivor`, `vpm_apply_unaffected`, `vpm_survivor_ne_zero_iff`, `vpm_isSingular`, `vpm_real_survivor`, `vpm_real_unaffected`, `vpm_row_sum`, `vpm_real_row_sum`, `columnValue_vpm_survivor`, `columnValue_vpm_unaffected`, `columnValue_vpm_survivor_toReal`, `columnValue_vpm_unaffected_toReal`.

### O14 (3 declarations)

`disjoint_support_iff_indicator_sum`, `disjoint_support_iff_columnPattern_disjoint`, `disjoint_support_iff_div_value_sum`.

### O15 (2 declarations)

`columnPattern_vpm_survivor`, `columnPattern_vpm_unaffected`.

### O16 (1 declarations)

`mergeRaw_vpsRaw`.

### O17 (3 declarations)

`vpmRecoveryMask`, `vpmRecoveryMask_true_iff`, `vpmRecoveryMask_false_iff`.

### O18 (6 declarations)

`vpsRecovery`, `vpsRecovery_outputCard`, `vpsRecovery_isSingular`, `vpsRecovery_channel`, `vpsRecovery_mask_legal`, `vpsRecovery_resplit`.

### O19 (13 declarations)

`vpmRecovery_leftWitness`, `vpmRecovery_rightWitness`, `vpmRecovery`, `vpmRecovery_outputCard`, `vpmRecovery_left`, `vpmRecovery_right`, `vpmRecovery_keep`, `vpmRecoveryEquiv`, `vpmRecovery_channel`, `vpmRecovery_channel_inverse`, `vpmRecovery_reindex`, `vpmRecovery_reindex_inverse`, `vpmRecovery_adjacent`.

## Current validation and remaining boundary

**Historical S04 validation checkpoint:**

The fresh full public audit passes all 233 signatures and axiom reports with
only `propext`, `Classical.choice` and `Quot.sound`; production hashes and all
ten pinned package revisions remain unchanged and clean. All 169 maintained
C07 examples pass: the earlier 105, 36 generic R15 consumers and 28 R14
consumers covering all 75 displayed entries. The required operation/example,
C06, Definition 4, C03 singularity and root aggregate passes (2774 jobs), as
does default `lake build` (2762 jobs). These are incremental builds. R14's
three failed development attempts remain separate from its successful final
compilation; R15 compiled without diagnostics on its first run. Detailed
evidence and limitations are in the implementation notes.

Contextual self-review, separate reassessment and the same reviewer's independent
S04 assessment subsequently completed. All three criteria are satisfied with
no findings; the complete original native report is preserved and critically
reconciled. Fresh reviewer builds, all 233 signature/axiom checks, manuscript
comparison and five independent public consumers pass. Its failed raw audit-log
comparison is retained separately from the resolved namespace-presentation
comparison and fresh successful Lean audit. The notes record exact references
and the adopted `Finite`/`Nonempty` wording clarification. Only owning Markdown
changes after R; final applicable checks, F capture and durable S04 closure
follow this pre-F checkpoint. The source map does not certify those later events.

S04 subsequently closed and its exact final source was verified as recorded
above. S05 is now authorized for fresh cumulative independent assessment,
any justified corrections, every maintained test/example build and final chunk
closure. C08-C16 remain outside this request.

| S05 criterion | Current work and required closing evidence |
| --- | --- |
| C07-S05-C01 | Fresh source/manuscript/consumer assessment of all twelve earlier criteria, R01-R16 and CC01-CC09; complete maintained builds and public audits. |
| C07-S05-C02 | Same reviewer's fresh consolidated assessment of every earlier criterion and outcome, with actual checks/limits; then original-report retention, critical reconciliation and any necessary correction/review. |
| C07-S05-C03 | CC10 review-time readiness and applicability, then owning-document updates, current final checks, F capture and supported durable closure. This row does not pre-certify those later events. |

**Fresh S05 parent checkpoint:** All mapped earlier criteria, R01-R16 and
CC01-CC09 were freshly assessed against their actual source and consumers.
The eighteen-target build includes every maintained test/example module and
passes (2787 jobs); default build passes (2762 jobs). A fresh generated audit
passes all 233 public signatures/standard-axiom reports. Both source PDFs were
reauthenticated and the three relevant pages visually rechecked. All 75 display
entries also pass an exact rational-affine arithmetic cross-check. No Lean
correction or new deferral was indicated. The implementation notes distinguish
parent checks and attributed helper checks, retain limits and failures, and own
subsequent self-review and independent-review evidence. CC10 remains a current
readiness assessment until those separate finalization events occur.

## S05 cumulative independent checkpoint

S05's fresh cumulative independent report satisfies all three current criteria, all twelve earlier criteria, R01-R16 and CC01-CC10, with no findings. The complete original report is critically reconciled. Owning documents now record this final review checkpoint; applicable final checks, F capture and supported durable closure follow it in the execution record. Only that later closure establishes C07 completion. C08-C16 remain unstarted.

The independent report contains explicit per-ID assessments for all 38 cumulative
items and all three current criteria. Fresh reviewer source/manuscript inspection,
all maintained/default builds, public signature/axiom/import checks and additional
consumers support its conclusions. Exact commands, original failures and evidence
limits are retained in the implementation notes and original report. The parent
reconciles the report on its merits; no mathematical correction or new deferral
is required. Reviewed Lean, dependency and normative-plan bytes remain unchanged.
