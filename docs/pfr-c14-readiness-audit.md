# PFR-C14 readiness audit

This crosswalk covers the complete approved revision-2 implementation. Fresh S04
parent and independent assessments pass; supported closure establishes completion. The
[implementation notes](pfr-c14-implementation-notes.md) own dated checks, original
reports and their limits; this file maps the mathematical coverage.

## Source and public interface

All production declarations belong to `PerfectFunctionalRepresentations.Primal`
in [Primal.lean](../PerfectFunctionalRepresentations/Optimization/Primal.lean).
Its only import is the existing `Optimization.IncidenceConstruction`. The root,
C12/C13 production and dependency pins remain unchanged.

| Owner | Declarations / contract |
| --- | --- |
| S01 | `Feasible`, `objective`, `feasibleSet`, `objectiveValues`; `feasible_zero`, `objective_zero`, `objective_nonneg`, `objective_le_one`. |
| Private shared algebra | `inputMatrix_mulVec_slack` holds for arbitrary real coefficients. It is the sole private production helper. |
| S02 | `objective_eq_one_iff`, `equality_feasible_iff`, `isPerfectlyRepresentableChannel_iff_exists_objective_eq_one`, `isPerfectlyRepresentableChannel_iff_isGreatest`. |
| S03 ambient | `isPerfectlyRepresentableChannel_iff_exists_objective_eq_one_compressedPatternData`, `isPerfectlyRepresentableChannel_iff_isGreatest_compressedPatternData`. Both compose C12's prior-free active restriction/compression bridge. |
| S03 presentation | `feasible_reindex_iff`, `objectiveValues_reindex`. Forward coordinates use `cols.symm`/`rows.symm`; arbitrary finite vectors return through `z ∘ cols`. `Equiv.sum_comp` supplies objective preservation locally. |

The sixteen public declarations and one private identity use finite nonempty
input and valid compressed data. Ambient outputs need only `Finite`; singularity
is explicit. No input prior, full support, inhabited partition type, signed
kernel injectivity, supremum or general optimizer premise is introduced.
Zero coefficients remain in the same vector. Finite presentations allow empty
columns and independent supplied row/column equivalences.

## Manuscript crosswalk

The exact original PDF identities and paths are retained in the
[plan](plans/pfr-c14-primal-characterization.md#2-authenticated-manuscript-anchors)
and planning evidence. Only the designated ISIT p.5 and extended v16 p.7 and
Appendix B pp.16-17 support this contract; adjacent extended-only material is excluded.

| Anchor | Implementation / interpretation |
| --- | --- |
| ISIT Theorem 2/(18), extended Theorem 2/(64), (205) | S02 data iff statements and S03 ambient wrappers; `objectiveValues_reindex` connects every finite-coordinate objective value. |
| (203)-(204) | C13 `isPerfectlyRepresentableChannel_iff_exists_feasible`, reduced incidence and C12 valid data, unchanged. Both occurring rows and admissible partitions are retained. |
| (206)-(208), (210)-(211) | C13 input incidence, `inputMatrix_mulVec_value`, `inputMatrix_mul_reducedMatrix`, and the private slack identity. Normalization is per input, not a total pattern sum. |
| (209), (212)-(214) | `objective_le_one` evaluates nonnegative input-incidence slack at an input. Nonempty input is explicit. |
| (215)-(216) | C13 equality normalization, `equality_feasible_iff` and the universal bound yield attained greatestness. |
| (217)-(219) | Membership in the objective image supplies an actual feasible attaining vector; the shared identity makes every row's slack sum zero. |
| (220)-(221) | `objective_eq_one_iff` selects a containing input for each nonempty pattern and eliminates its nonnegative slack coordinate. No assertion about arbitrary signed kernel vectors is used. |

## Regression and criterion crosswalk

Tests remain anonymous, with fixture helpers private/local. No fixture was
promoted for reuse. The existing C13 tests retain their earlier assertions.

| Regression | Maintained owner and assertions |
| --- | --- |
| R01 | `Tests/Optimization/Primal.lean`: generic definitions, zero, bounds and image witnesses without `Nonempty` partitions or perfectness. |
| R02 | `Tests/Optimization/Incidence.lean`, Unit data: weights zero, half and one; endpoint saturation and greatestness. |
| R03 | Generic Primal tests: zero primal feasibility/objective versus failed equality, also through the new bridges. |
| R04 | Incidence tests, pair-only three-input data: empty partitions, image `{0}`, greatestness at zero, failure at one and nonperfectness. |
| R05 | `Tests/Examples/Incidence.lean`, seven-pattern R09 datum: per-input sum one, total values `7/4`, attaining vector with its zero coefficient preserved. |
| R06 | Same paper-test owner, obstructed datum: five admissible partitions, feasible objective `1/2`, no attainment/greatestness at one; signed equality/objective-one vector rejected at `-1/4`. |
| R07 | Generic Primal tests: two-input singleton-pattern slack guard, first row zero while the second coordinate remains nonzero; all-row elimination and saturation. |
| R08 | Incidence tests: Option output extension retains zero at `none`; injection and changed active presentations recover identical compressed data and compatible primal conclusions. |
| R09 | Paper tests: `(1,2,3,4,5)/40`, product `(9,8,7,2,3,4,1)/40`, objective `3/8`; independent non-involutive cycles give coefficient `4/40` and product `8/40` at zero. Forward-direction alternatives give `5/40` and `7/40`. Incidence tests cover empty columns. |
| R10 | Incidence tests apply the final ambient greatestness iff to perfect Unit and nonperfect pair-only channels. Generic and paper tests use the finite-coordinate image in both directions and transfer greatestness. |

| Criterion / completion | Evidence owner |
| --- | --- |
| S01-A / CC01 | Separate definitions, unchanged C13 equality predicate, generic/zero consumers. |
| S01-B / CC02 | Nonnegative objective and upper bound, row identities, empty-family regression. |
| S01-C | R01-R04 staged consumers, production signatures/imports and exact prior closure. |
| S02-A / CC03 | All-coordinate saturation, exact-vector bridge, R03/R05/R07. |
| S02-B / CC04 | Explicit attainment and `IsGreatest` equivalence through C13, R02/R04/R06. |
| S02-C | R02-R07, signed control and (215)-(221) crosswalk; exact prior closure. |
| S03-A / CC05 | Both ambient wrappers, R08/R10 and existing C12 active/injection/presentation bridges. |
| S03-B / CC05 | Both public presentation lemmas, generic inverse recovery, asymmetric and empty-column consumers. |
| S03-C / CC06-CC07 | R01-R10, full production audit, C13-only consumer, this crosswalk and advice/C15 allocation below. |
| CC08 | Fresh S04 cumulative parent and independent assessment covers all nine earlier criteria and all declarations/tests. The original report is reconciled; final checks/F/supported closure establish completion after this pre-F checkpoint. |

## Omissions and advice

All existing omission identifiers and historical proposals remain preserved in
the [map](formalization-map.md). No new mathematical omission is introduced.

| Record | Current disposition / owner |
| --- | --- |
| DG-13; OM-044 | S01-S03 implement the approved nonempty-input reduced contract. Fresh S04 parent and independent assessments confirm it; supported closure establishes completion. |
| DG-10/11/12; OM-014/025/047/068 | Reuse existing valid data, finite coordinates and nonnegative equality bridges. No mixed full/reduced inequality system or second LP hierarchy. |
| OM-042/046 | Every logical step (203)-(221) is covered; private proof algebra and image membership replace unnecessary public display aliases and unproved general optimizer claims. |
| OM-018/019; C16 | Algorithms, runtime and the broader nonsingular/singular convenience wrapper remain separate scope decisions. |
| OM-017/027; DG-15 | Existing private fixtures and finite counts suffice; Bell growth/enumeration and publication curation keep their original owners. |
| DG-14; C15 | Duality/separation/correction/scaling/leastness remain unimplemented here. |
| C12 compression-idempotence advice | Existing ambient bridge suffices. No concrete C14 consumer requires reviving the declined alias. Revisit only if a future approved consumer is blocked. |
| C11 private-helper advice | C14 uses public C13 characterization; no helper promotion is needed. |
| C13 P01-P04 / GA01-GA03 | Completed dispositions retained; existing fixtures reused. |
| C14 P01/GA01, P03, P04 | Signed control, shared private slack identity and staged R02-R04 are implemented in S01/S02. |
| C14 P02/GA02 | S03 implements the exact entire-image theorem, inverse map and one discriminating scaled fixture. The extra two-fixture recipe remains declined as redundant; R05 already covers zero coefficients. Fresh S04 parent and independent assessments confirm these consumers. |
| C14 P05 | S03 compiles an isolated C13-only import consumer; S04 freshly reruns it successfully. No maintained fixture refactor is needed. |
| OM-028-032/039 | Extended-only algorithms, hardness, information-measure applications and general LP infrastructure remain excluded. |

No numbered Future Work Note is opened. Uncertain or later consumer needs keep
their existing owner and trigger; no required mathematics is deferred to S04.

## C15 consumption boundary

C15 can import Primal separately and use `Feasible`'s coefficient signs and
pointwise `reducedMatrix *ᵥ x ≤ D.value`, `objective`'s finite sum, zero
feasibility, the universal bound and the final data/ambient characterizations.
C13 retains the same row/partition types and incidence identities needed by
the dual. Empty admissible families are covered on the primal side without
inventing a partition witness; C15 owns its own dual treatment of that case.
No dual predicate, weak-duality result, separator, sign correction, scaling
argument or leastness theorem is added by C14.

## Historical S03 pre-F readiness — 2026-10-01

S03 validation and independent review satisfy all three criteria without findings. The
complete original report is critically reconciled. Final applicability, F and supported
durable closure follow this pre-F checkpoint; S04 remains unstarted.

The independent assessment confirms the S03 mathematical and regression
boundary and the CC01-CC07 crosswalk. DG-13 mathematical requirements are
satisfied at this source. CC08 and S04 fresh cumulative closeout remain
separate. Exact report evidence and limits are in the implementation notes.

## S04 cumulative assessment — 2026-10-01

Fresh parent assessment covers all nine S01-S03 criteria, R01-R10 and CC01-CC07;
no mathematics or regression is left for another step. All sixteen public
declarations, the private identity, 67 C14 anonymous consumers, 37 private test
declarations and one local instance are inventoried and audited. Fresh exact
source recompilation and kernel audits additionally cover inherited declarations
in the two incidence test owners. Details and limits are in the implementation notes.

All manuscript anchors and advice/omission dispositions above were rechecked
against actual source and authenticated pages. P05's C13-only consumer freshly
passes. Existing declined extras need no revival; no new deferral opens.

### Independent cumulative assessment and completion boundary

Fresh cumulative validation and independent review satisfy all three S04
criteria without findings. The complete original report is critically reconciled.
This is the pre-F readiness checkpoint: final applicability, F and supported
closure establish CC08/C14 completion in the durable review record. C15 remains
unstarted.

The complete original report and its evidence/limits are retained in the
implementation notes and durable review records. Existing omission/advice
dispositions remain unchanged; no later mathematical step is started.
