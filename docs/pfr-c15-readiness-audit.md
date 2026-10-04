# PFR-C15 readiness audit

This crosswalk covers revision 2's complete mathematical surface through durable
S04 closure. S01-S04 and all four original-report reconciliations were freshly
verified before the conditional S05 request was accepted. S05 fresh cumulative
parent/independent validation passes and the complete original report is reconciled.
Final applicable source/F and supported closure follow this pre-F checkpoint.
The [implementation notes](pfr-c15-implementation-notes.md) own original reports,
exact source/check receipts, failures and provenance limits. This audit maps the
mathematical duties; it does not authorize a later step.

## Mathematical source and representation

ISIT p.5 IV-B, Corollary 1/(19), supplies nonnegative dual variables, transpose
inequalities, objective and minimum-one characterization. Its adjacent count
prose gives the effective bound. The designated extended v16, dated 2026-09-03,
p.6 IV-A/(40)-(56) clarifies reduced occurring rows/admissible columns;
p.7 IV-B/(65)-(67) supplies dual/count clarification. PDF identities, current
hash checks and the attributed reading of these pages are in the implementation
notes and [plan](plans/pfr-c15-dual-characterization.md#2-authenticated-manuscript-anchors-and-interpretation).

The Lean contract uses the same valid C12 compressed data and C13 reduced
incidence as C14. Normalization is per input. The sum of all pattern values need
not equal one. `IsLeast (Dual.objectiveValues D) 1` includes both actual attainment
and a universal lower bound. The row witness alone supplies attainment for every
datum and therefore cannot characterize perfectness. No literal mixed full/reduced
inequality system, general optimizer, solver or extended-only algorithm is claimed.

Inputs are arbitrary finite nonempty types; ambient outputs require only `Finite`.
Singularity is explicit. Inactive outputs and empty admissible-partition types
remain included; no prior, full-support or inhabited-partition premise is added.

## Production ownership and API

All declarations belong to `PerfectFunctionalRepresentations.Dual`.
[Dual](../PerfectFunctionalRepresentations/Optimization/Dual.lean) imports only
`Optimization.Primal`. [DualCharacterization](../PerfectFunctionalRepresentations/Optimization/DualCharacterization.lean)
imports Dual and the two focused mathlib separation/matrix-dual modules.
The lightweight root and C12-C14 production remain unchanged.

| Owner | Current declarations / contract |
| --- | --- |
| Dual / S01 | `Feasible`, `objective`, `feasibleSet`, `objectiveValues`; `objective_zero`, `objective_nonneg`, `weak_duality`; `rowWitness`, `transpose_mulVec_rowWitness`, `objective_rowWitness`, `feasible_rowWitness`, `one_mem_objectiveValues`, `feasible_zero_of_isEmpty`. |
| DualCharacterization / S02 | Public `exists_feasible_objective_lt_one_of_not_perfect`. All hull, separation, coordinate/cardinality, correction and normalization intermediates remain private. |
| DualCharacterization / S03 | `isPerfectlyRepresentableChannel_iff_isLeast`, `isPerfectlyRepresentableChannel_iff_isLeast_compressedPatternData`. |
| Dual / S04 | `transpose_mulVec_reindex`, `feasible_reindex_iff`, `objective_reindex`, `objectiveValues_reindex`. These apply to every vector and independent supplied row/column equivalences. |
| DualCharacterization / S04 | `isPerfectlyRepresentableChannel_iff_isLeast_reindex`, `isPerfectlyRepresentableChannel_iff_isLeast_compressedPatternData_reindex`. Both rewrite the entire image and consume S03. |

There are 17 public source declarations in Dual and five in
DualCharacterization. No count alias, bundled LP interface, public correction
helper or public fixture is introduced. The whole actual compiled-module audit
includes private and generated constants and transitive axioms; anonymous test
body copies are separately attributed. Exact inventories and check outcomes
belong to the implementation notes.

Forward dual coordinates and values use `rows.symm`; the transpose image uses
`cols.symm`. Transposition swaps the equivalences before existing
`Incidence.reindex_mulVec` applies. An arbitrary finite vector returns as
`z ∘ rows`, whose forward transport recovers `z`. `Equiv.sum_comp` proves the
objective equality. Both directions appear in `objectiveValues_reindex`;
the result preserves the entire set, including finite vectors not chosen by any
particular witness. Finite characterization belongs in DualCharacterization.

For any supplied `rows : OccurringPattern D ≃ Fin m`, existing
`card_occurringPattern` and `Fintype.card_congr` give exactly `m = D.patterns.card`.
`patterns_card_le` gives `m ≤ 2 ^ Fintype.card α - 1`; `card_nonzeroPattern`
identifies this bound with the full nonempty-pattern universe. The bound is not
the actual reduced variable count. Generic and concrete consumers reuse these
theorems without adding another public hierarchy.

## Completion and earlier-criterion crosswalk

Source references below are to current production declarations and maintained
tests. Earlier durable closures remain historical acceptance records. S05 now
freshly reassesses all twelve earlier criteria and their current integration;
fresh parent/independent source/build/audit checks pass. Original report reconciliation is complete; final exact F/supported closure follow this checkpoint.

| Criterion / completion | Actual source and obligation |
| --- | --- |
| C15-S01-A / CC01-CC02 | Dual definitions, `objective_nonneg`, `weak_duality`; generic Dual tests preserve the distinct equality/primal/dual predicates. |
| C15-S01-B / CC02-CC04 | Dual row-witness identities and actual one membership; `feasible_zero_of_isEmpty` and pair fixture cover zero with no partition witness. |
| C15-S01-C / CC08 | R01-R04 consumers and prior C14 applicability retained; current complete API/import/trust audit checks continued integration. |
| C15-S02-A / CC03 | Private `value_mem_incidenceHull_iff`, hull compactness/closedness/convexity/nonemptiness, `separating_coordinates`; public alternative splits the empty family first. |
| C15-S02-B / CC04 | Private `patternCard_dot_value`, `patternCard_dot_column`, `correction_signs`, `corrected_gaps`, `normalized_certificate`; correction shifts the datum and every column equally and proves positive/nonzero division. |
| C15-S02-C / CC04, CC08 | Generic alternative/empty consumers and paper R06/R07; actual private production proofs and external explicit arithmetic have distinct provenance. |
| C15-S03-A / CC05 | Data leastness iff: C14's attaining primal point and weak duality give the lower bound; S02's subunit member contradicts leastness. R02/R04/R05/R06 retain attainment/leastness distinction. |
| C15-S03-B / CC06 | Ambient singular iff consumes the public C12 compression bridge; Option/injection/changed-active-presentation consumers retain inactive labels. |
| C15-S03-C / CC08 | Preserved signatures, manuscript meaning and successful prior closures/S04 integrated audits; fresh S05 builds and exhaustive audits recheck applicability. C16 broader wrapper stays separate. |
| C15-S04-A / CC07 | Four Dual presentation theorems, two finite iff statements, generic inverse and image consumers, pair `Fin 3` variables/`Fin 0` constraints, supplied/canonical exact-count consumers. |
| C15-S04-B / CC08 | All R01-R10 below; actual asymmetric fixture crosses unequal value classes; isolated C13/Primal consumers preserve import separation. |
| C15-S04-C / CC01-CC08 | This complete crosswalk, actual whole-module API/import/trust audit, manuscript interpretation and all selected omission/advice dispositions below. No mathematical duty is deferred to S05. |
| CC09 / S05 | Fresh parent/independent cumulative validation passes and the complete original report is reconciled. Final applicable F/supported closure follow this checkpoint; only that record establishes CC09/C15. S04 durable step closure does not establish CC09. |

## Regression crosswalk

Fixtures remain private/local in their existing owners; assertions remain anonymous.

| Regression | Maintained owner and assertions |
| --- | --- |
| R01 | `Tests/Optimization/Dual.lean`: definitions, nonnegative image members, weak-duality orientation, witness membership; S04 arbitrary-vector inverse, objective/full-image membership in both directions. |
| R02 | `Tests/Optimization/Incidence.lean`, SingletonFixture: Unit scalar dual lower bound, row witness one, larger values and both leastness/perfectness directions. |
| R03 | Generic nonempty-family zero rejection and singleton primal/equality contrast; `Tests/Examples/Incidence.lean` checks signed `(2,2,2,-1,-1,-1,1)` with transpose `(1,1,1,1,6)`, objective `-1/4`, and rejection through a negative coordinate. |
| R04 | EmptyFixture pair datum: zero dual value/feasibility and nonperfectness despite one membership. `c15EmptyDualValues` retains `Fin 3` variables, vacuous `Fin 0` constraints, arbitrary finite inverse, whole image, zero/one members and failure of leastness. This dual image is not C14's empty primal image `{0}`. |
| R05 | Existing paper `r09Data`: total values `7/4`, row normalization one, zero-containing equality/primal witness, all dual values at least one and attained leastness. |
| R06 | Existing paper `obstructedData`: five partitions; explicit feasible objective `1/2`, public strict alternative and failure of leastness despite row witness one; existing primal value `1/2` attains weak-duality equality. |
| R07 | Private production cardinality/correction proofs are checked locally by the complete actual-module audit. Generic/paper consumers check the public alternative separately from explicit corrected vector arithmetic: raw threshold `-9/4`, positive normalization `63/2`, objective `125/126`, minimum column product `127/126`. No assertion that the existential certificate chooses this vector. |
| R08 | Paper `c15AsymmetricVector`, `c15AsymmetricRows`, `c15AsymmetricColumns`: raw vector `(1,2,4,8,16,32,64)`, transpose `(64,12,18,33,7)`, objective `239/8`. Independent non-involutive row/column maps give transported zero coordinates `8`, value `3/8`, transpose `33`; forward-map errors give `64`, `1/8`, `7`. Inverse recovery and entire-image equality preserve both the large feasible value and subunit `1/2`. |
| R09 | Incidence Option fixtures retain explicit zero mass/inactive `none`, unchanged patterns and extraction. Finite ambient iff consumes representable Unit and nonperfect pair injections; two genuinely changed supplied active presentations have equal finite objective images and compatible nonperfect conclusions through existing C12 bridges. |
| R10 | Generic supplied-row proof derives exact `m` and universe bound from existing counts; canonical finite image and singular corollary consumers, concrete pair/obstructed counts. Fresh Dual-only, Primal-only, C13-only and lightweight-root consumers check declaration/module boundaries. |

## Omission and inherited-advice dispositions

All stable IDs and historical rationale remain in the [map](formalization-map.md).
The complete selected allocation from plan Section 8 is retained here.

| Original record | Current disposition / owner and revisit trigger |
| --- | --- |
| DG-14; OM-039 | S02/S03 specialize separation and leastness; S04 transports them to finite coordinates. Generic LP duality remains excluded. DG-14 cumulative acceptance belongs to S05. |
| OM-014/025/047/068 | S04 supplies intrinsic-to-finite reduced transport and exact count; no mixed encoding, duplicated count or full-dual hierarchy. |
| OM-044/045/046 | S01-S03 cover nonempty input, empty partitions, inactive labels and attained leastness. S04 finite consumers preserve all edge cases. General optimizer/infimum claims remain unnecessary. |
| OM-017/018/019/027 | Existing finite counts and private fixtures suffice. General Bell enumeration/growth, solver/runtime and fixture promotion keep their existing excluded/deferred owners; revisit only under their separately approved scope. |
| OM-028-032 | Extended-only algorithms, hardness, coloring and information-measure applications stay excluded. C15 does not enter these anchors. |
| OM-042 | Separator/correction intermediates remain private; no public declaration per manuscript display is needed. |
| C12 plan Section 9 / OM-068, idempotence advice | Existing extraction/injection/presentation bridges suffice for the actual finite ambient consumers. Preserve the earlier decline; reopen only if an approved consumer is concretely blocked. |
| C11 helper-promotion advice | Public C13 necessity/construction and C14 attainment suffice. No current consumer pressure; preserve original owner/trigger. |
| C13 P01-P04 / GA01-GA03 | Completed attribution/construction/fixture dispositions remain. Extra numerical fixture remains declined; actual existing R09/R14 data are reused. |
| C14 P01/GA01, P02/GA02, P03-P05 | Signed guards, inverse whole-image transport, private slack, staged fixtures and isolated C13 consumer stand. The extra two-fixture recipe remains declined; S04 adds only its required dual-specific transpose/objective detector. |
| C15 revision-2 P01/P02/P03 and General Assistant GA01/GA02 | Signed-dual guard, private R07 provenance distinction, finite-corollary ownership and alternate-interface clarification are implemented with origins retained in the planning notes' revision-2 dispositions. No unowned optional deferral. |

No numbered Future Work Note exists or is opened. Existing advice retains its
original owner and trigger. No correctness, acceptance, mathematical or required
regression obligation is left for S05 to implement; S05 independently revalidates
this completed mathematical surface before chunk closeout. C16 retains the broader
nonsingular/singular wrapper scope decision.

## S05 fresh cumulative validation duties — 2026-10-02

Startup verifies all twelve S01-S04 criteria, four original-report reconciliations,
resolved findings and current 174-entry source/environment/Git/normative agreement.
The earlier rows identify implemented mathematical obligations; they do not infer
fresh S05 success from earlier acceptance. Actual successful checks and their limits are recorded in the
implementation notes; no earlier report is relabeled as cumulative acceptance.

| S05 criterion | Fresh scope and current boundary |
| --- | --- |
| C15-S05-A | Inspect all current production/private proofs, tests and imports; revisit both authenticated manuscripts and the twelve earlier criteria, R01-R10, CC01-CC08 and selected omission/advice dispositions. Manuscript hashes/reread are verified; fresh parent and independent source/audit reassessments pass. |
| C15-S05-B | Run required focused/downstream/default builds and Dual-only, Primal-only, C13-only and lightweight-root consumers; exhaustively audit actual named/private/generated declarations and separately attributed exact-body anonymous copies. Fresh parent/independent checks pass; all three cumulative independent criteria are satisfied. |
| C15-S05-C / CC09 | Critically reconcile every original report/finding, maintain owning documents, obtain final applicable checks and exact F, and use supported closure. The complete original cumulative independent report is preserved and critically reconciled. Final applicable source/F and supported CC09 closure follow this checkpoint. |

No required mathematical duty is newly deferred or omitted. The original advice
dispositions, stable omission IDs and owner/trigger routing remain; no numbered
Future Work Note or later chunk starts.

## S04 independent assessment and stopping boundary — 2026-10-02

The source-bound independent report satisfies all three S04 criteria without
findings. Root critically reconciles its original mathematical, API/import/trust,
manuscript and readiness evidence, including exact inverse/whole-image transport,
empty constraints, counts, R01-R10 and every earlier criterion/CC01-CC08.
Exact original bytes, actual native envelope, delivery/classification/reconciliation
and attributed check limits are retained in implementation notes/private records.

The mathematics and regressions are ready; final exact-source applicability/F
and supported closure complete only S04. S05 must separately perform fresh
cumulative independent validation and CC09. No new deferred advice or numbered
Future Work Note, theorem weakening, public fixture or later-step implementation.

## S05 exhaustive parent validation checkpoint — 2026-10-02

The fresh source inventory contains 200 C15 declarations: 45 production, 64 named
fixture helpers and 91 anonymous consumers. Three Unit dual helpers are selected
by their actual owning region despite lacking a `c15` prefix. Ten inherited local
instances remain attributed prerequisite context. Actual imported constants number
145: 132 C15 (109 source names plus 23 generated) and 13 context instances/descendants.
Transparent exact-body copies additionally check 94 anonymous constants and 13
context constants, including every generated descendant. All types/transitive
axioms, reversible headers and source/olean/ilean identities pass with only the
three standard axioms. Copies elaborate separately; they are not original anonymous
olean constants. The root inspection retains that distinction and all receipts.

Root focused/downstream build passes 2,788 jobs and default build passes 2,762,
using cached dependencies. All four isolated import consumers and source hygiene
checks pass. Manuscript identities and intended reduced-system interpretation,
all twelve earlier criteria, R01-R10, CC01-CC08 and selected advice/omissions were
freshly reassessed. Independent cumulative assessment and final CC09 acts remain
pending; no mathematical change, new deferral or later chunk is authorized.

## S05 original cumulative independent assessment — 2026-10-02

All three S05 criteria are independently SATISFIED without findings. The complete
original source-bound report is preserved and critically reconciled against current
proofs, every earlier criterion/R01-R10/CC01-CC08, exact dependency/manuscript facts,
exhaustive named/private/generated/anonymous/context audits and fresh checks.
The implementation notes retain actual original identities/results/limits and
the review-time readiness distinction. All mathematical source remains identical
to R while editorial owners record reconciliation. Final current applicability/F
and supported closure establish CC09 and complete C15; no later chunk starts.
