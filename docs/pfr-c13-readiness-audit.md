# PFR-C13 readiness audit

**Status, 2026-09-30:** S01-S05 are durably complete. S06 freshly reassesses
all fifteen earlier criteria, R01-R14 and CC01-CC08 against the complete current
source, manuscripts and declaration/trust inventory.
S06 cumulative validation and independent review pass; all three criteria are satisfied, and the original report is reconciled. Final applicability, F and durable closure follow this pre-F checkpoint.
The original report has now been received and reconciled. Final applicable
validation/F and supported closure remain acceptance duties; only that closure
completes CC09/C13. [Implementation notes](pfr-c13-implementation-notes.md)
retain exact commands, counts, original evidence and limits.

The [approved revision-2 plan](plans/pfr-c13-exact-partitions-incidence-systems.md)
owns requirements. S06 startup verified all five closures and fifteen criteria,
their reconciled original reports, and exact agreement of all 153 S05 final entries.
S05 closure: `bc86357cb2f045db4c57c3ed0dd36863e06b082a3bf47d72301bb66787e338bf`.

## Source owners and assumptions

| Key | Maintained source and role |
| --- | --- |
| I | [Optimization/Incidence.lean](../PerfectFunctionalRepresentations/Optimization/Incidence.lean): intrinsic indices, matrices, structural identities, nonnegative transport, normalization, support and necessity. |
| C | [Optimization/IncidenceConstruction.lean](../PerfectFunctionalRepresentations/Optimization/IncidenceConstruction.lean): actual coefficient-specific operation phases and characterizations. |
| G | [Tests/Optimization/Incidence.lean](../PerfectFunctionalRepresentations/Tests/Optimization/Incidence.lean): generic public consumers, singleton, empty indices, finite and ambient presentations. |
| E | [Tests/Examples/Incidence.lean](../PerfectFunctionalRepresentations/Tests/Examples/Incidence.lean): private concrete fixtures, exhaustive paper coordinates and adversarial examples. |

Production declarations belong to `PerfectFunctionalRepresentations.Incidence`.
Pattern and partition facts use `[Fintype α]`. Data-dependent statements use
`[Fintype α] [Nonempty α]` and C12's `CompressedPatternData α`: a finite family
of nonempty patterns, positive Real values and per-input row sums. They assume
neither perfectness nor feasibility nor a nonempty admissible family. Total
pattern values need not sum to one. Ambient wrappers use `[Finite β]` and an
explicit singularity proof, with inactive output labels allowed. No prior or
full-input-support hypothesis enters the channel characterizations.

The full system indexes all nonempty patterns and all exact partitions. The
reduced system restricts both indices. `FullFeasible` and `Feasible` include
nonnegativity. Equality alone gives total weight one; the coefficient bounds
and elimination of absent-pattern contributions use nonnegativity. The
extend-after-restrict inverse requires full feasibility. The reverse inverse
holds for arbitrary reduced weights.

`partitionConstruction D w hw` retains the supplied feasible vector and the
same three labelled phase endpoints. `PartitionConstruction.mk` takes phase
witnesses. The construction-existence characterization quantifies `w`
existentially; it does not assert that every signed vector underlying any
such bundle is feasible.

## Manuscript crosswalk

The six-page ISIT final has SHA256
`48963aa59485b2c33b1a1e6e7c6ead2251fdddd26bd3691b6fcffe683e6ed1c4`.
The designated extended version 16, eighteen pages, has SHA256
`98636d4c9f0618ec08fca84559572780f604f197fda90d8d7c787b3624245b8f`.
S05 freshly checked both binary identities, reread ISIT p4 and extended pp5-7
extracts, and visually checked the extended p6 matrix. Local reference files
remain outside maintained source. The extended manuscript clarifies the
full/reduced repair already approved under DG-12.

| Manuscript obligation | Source contract or explicit disposition |
| --- | --- |
| ISIT IV opening, p4: distinct-pattern count and values | C12's intrinsic data and `value_le_one`; I's `card_nonzeroPattern`, `card_occurringPattern`, `patterns_card_le`. Repeated-pattern compression and its constructive inverse belong to completed C12. Complexity claims remain documentation under OM-019. |
| ISIT IV-A partition definition; extended (33) | `ExactPartition`, `exactPartition_indicator_sum`, `exists_exactPartition_of_indicator_sum` give both real-indicator and exact-block directions through C10's `Finpartition` adapter. |
| Extended (34), general Bell identity | Excluded under OM-017. The concrete three-input count is proved in E; no generic enumerator or Bell-growth theorem is claimed. |
| ISIT Example 6; extended (35)-(38), Example 7 | E's `partition_cases`, `paperPartitions`, `paperColumns`: every exact partition is one of the five distinct listed partitions. |
| Extended (39)-(40), all patterns and supplied ordering | `NonzeroPattern`, `OccurringPattern`, supplied finite equivalences, `reindex_mulVec`, `system_reindex_iff`. E's `paperRows` enumerates all seven patterns in paper order. No intrinsic subtype ordering is assumed. |
| Extended (41)-(42), zero-padded full values | `fullValue`, `fullValue_of_mem`, `fullValue_of_not_mem`; exact concrete paper value vectors in E. |
| Extended (43)-(46), binary full system and nonnegative characterization | `fullMatrix`, `fullMatrix_apply`, `fullMatrix_nonneg`, `FullFeasible`; C's `isPerfectlyRepresentableChannel_iff_exists_fullFeasible`. |
| Extended (47)-(49), admissible subset and dimensions | `IsAdmissible`, `AdmissiblePartition`, `card_admissiblePartition_le`; no nonemptiness assumption. E checks cardinalities zero, one, two and five for the relevant fixtures. The comparison to general Bell numbers remains OM-017. |
| Extended (50)-(51), reduced incidence as a restriction | `reducedMatrix`, `reducedMatrix_apply`, `reducedMatrix_eq_full`. E checks all-pattern equality with the full 7-by-5 matrix and the proper R13 4-by-2 submatrix. |
| Extended (52)-(53), nonnegative full/reduced equivalence | `feasible_restrictWeights`, `fullFeasible_extendWeights`, `exists_fullFeasible_iff`, with actual coefficient maps. |
| Extended (54)-(55), equality-derived normalization | `inputMatrix_mulVec_value`, `inputMatrix_mul_reducedMatrix`, `sum_eq_one_of_reduced_eq`, plus full variants. `P H` is a rectangular all-ones matrix. Equality normalization permits signed weights. |
| Extended (56), absent-row argument and converse extension | `full_weight_eq_zero_of_not_admissible`, `extend_restrictWeights`, `restrict_extendWeights` and the feasibility transport proofs. R07/R08 detect missing nonnegativity or a false unconditional inverse. |
| Three construction stages after ISIT (16)/extended (56) | C's `partitionConstruction`: C10 positive-support PPS, transported exact-partition VPS and prescribed-pattern-fiber PPM. Its dependent bundle retains all phase paths, labels, coordinates and patterns; `normalForm` gives the directed final presentation. R09/R13 inspect the same returned construction. |
| Compressed necessity argument following the stages | I's `exists_feasible_of_isPerfectlyRepresentableChannel` and full companion extract weights from the public C02 perfectness witness. Supported decoder fibers give admissible partitions; finite aggregation gives each incidence row. E's explicit R13 witness checks shared-block aggregation and a null decoder. No C11 private API or arbitrary-path extraction theorem is introduced. |
| ISIT Example 7/(17); extended (57)-(60), Example 8 | E's `paper_fullMatrix` verifies all 35 entries in the explicit Fin 7/Fin 5 presentation. All-pattern reduced and full matrices coincide; R13 exercises strict restriction of both index families. |
| ISIT (16) and its matrix rewrite; extended (61)-(63) | `reducedMatrix_apply` and finite `Matrix.mulVec` give the block-incidence sum; `Feasible` supplies the nonnegative vector. C's reduced/full perfectness, construction and C11 reachability equivalences prove the intended existential claim. E pins the actual sparse vectors to the five paper columns. |
| ISIT paragraph after (17), weights in [0,1] | `reduced_weight_le_value`, `full_weight_le_value`, `reduced_weight_le_one`, `full_weight_le_one`, `reduced_unit_iff`, `full_unit_iff`; nonnegativity is explicit. The mixed occurring-row/all-partition encoding is invalid, as R06 and R08 show. |
| Extended (64)-(68) boundary | Optimization and duality belong to C14/C15. C13 supplies finite dimensions and structural identities. General Bell enumeration/growth remains OM-017. |

Every assigned logical assertion in (33)-(63) has an owner above, including
the explicit (34) exclusion. Private intermediates need no public name per
display (OM-042); fixtures remain separate from the stable API (OM-027).

## Step and completion criteria

| Criterion | Concrete source or evidence |
| --- | --- |
| S01-A | I's intrinsic indices, entry formulas, both indicator directions; G's arbitrary-data and empty-index consumers. |
| S01-B | I's full-pattern count and reduced dimension bounds; E's explicit finite examples. |
| S01-C | I's two reindexing theorems; G's arbitrary independent indices and asymmetric direction detector; E's paper permutations. |
| S02-A | I's four input-incidence identities on arbitrary valid data, with no feasibility assumption. |
| S02-B | I's actual-vector restriction/extension equivalence, zeroing of inadmissible coefficients and both inverse laws. E's R05-R08/R13/R14 distinguish the corrected systems from mixed or signed ones. |
| S02-C | I's signed equality normalization, nonnegative bounds, positive support, block-map surjectivity and empty-family obstruction. G checks the actual C10 positive-support input and its normalized coefficients. |
| S03-A | I's supported-decoder fiber/partition construction inside the public necessity proof. |
| S03-B | I's supported PMF weight aggregation; E's explicit R13 posterior, two unequal positive contributions and null-decoder control. |
| S03-C | I's two public necessity theorems, G's C11/C12 consumers and E's public nonrepresentable channel. |
| S04-A | C's actual dependent PPS/VPS/PPM bundle, feasible-vector construction, phase pattern lemmas and paths. |
| S04-B | I's `positiveBlockPattern_surjective` and C's private `ppmGroup_surjective` establish complete target coverage; C's normal form and final coordinates retain direction. G checks the same object and E checks R09/R13 exact counts, masses, omission and merge. |
| S04-C | C's nine semantic characterization/consequence declarations; G's arbitrary supplied presentations, inactive Option label and injective ambient transport. |
| S05-A | E's exhaustive five-partition equivalence, `paper_fullMatrix`, all-pattern full/reduced equality and proper R13 restriction. |
| S05-B | All fourteen regressions below, including paper-coordinate vector bridges and independent non-involutive presentations. |
| S05-C | Fresh public signature/axiom and import audit, this manuscript/source crosswalk, downstream handoff and omission/advice dispositions; exact evidence in implementation notes. |
| CC01-CC04 | S01/S02 source and tests: indices/indicators/dimensions, both structural systems, inverse transport, normalization/bounds/support/empty case. |
| CC05-CC06 | S03 necessity and S04 actual construction plus all required characterizations, with same-witness consumers. |
| CC07-CC08 | S05 complete fixtures, finite/ambient presentations, public import/API audit, repair/omission/advice records and C14/C15 handoff. |
| CC09 / S06 | Fresh cumulative source/manuscript/build/trust assessment now covers every earlier criterion and regression, with exact declaration/example inventory in implementation notes. Contextual critique and separate reassessment are preserved; fresh independent review satisfies all three S06 criteria and its original report is critically reconciled. Final evidence/F and supported closure remain required. Only supported closure completes CC09/C13. |

## Regression crosswalk

The names below are private fixture references in E or namespace/consumer
references in G, not new supported public declarations.

| ID | Maintained assertion |
| --- | --- |
| R01 | G's generic data consumers require only C12's data fields, with all finite indices including empty J. E's `r09Data` has all seven values 1/4, so total pattern value is 7/4. |
| R02 | G's `SingletonFixture` has its unique pattern/partition and feasible weight one. The same actual construction has one output in each phase and all three path lengths zero. |
| R03 | E's `r05NoPartition`, empty presentation and card zero, plus I's `not_reduced_eq_of_isEmpty`; even signed reduced equality is impossible. G also checks empty full/reduced feasibility. |
| R04 | G's actual inverse-law consumers; E's `shared_fullFeasible` and feasible restriction recover the same full vector. R08 separately shows why full feasibility is necessary. |
| R05 | E extracts `r05Data` from the public C03 singular nonperfect channel and proves exactly the three pair patterns at value 1/2. Public necessity also refutes perfectness. |
| R06 | `r06_mixed_solution`, `r06_sum`, `r06_bounds`: actual paper vector (0,1/2,1/2,1/2,0) passes the invalid mixed rows and all [0,1] bounds but has total 3/2. |
| R07 | `r07_signed_full`: paper vector (0,1/2,1/2,1/2,-1/2) satisfies all full rows; its negative coefficient and empty reduced family disprove signed reduction. |
| R08 | `WholeOnly`: actual bad vector (1,0,0,0,2) passes its mixed row but fails absent singleton full rows. Its sole admissible restriction has weight one and is feasible; actual zero extension is (1,0,0,0,0), unequal to the original. |
| R09 | `r09Data`, `r09Construction`: all seven values 1/4, five admissible partitions, paper weights (1/4,1/4,1/4,1/4,0), four positive partitions and phase counts 4/7/7. The zero singleton partition is absent; every actual VPS leaf has mass 1/4 on its supplied block and zero outside. Final values are 1/4, PPS length is three and PPM length zero. |
| R10 | Seven-pattern and five-partition bijections, card five, and all 35 entries. Rows: 100,010,001,110,101,011,111. Columns: {111}, {110,001}, {101,010}, {011,100}, {100,010,001}. |
| R11 | G's arbitrary full/reduced transports, including signed equations, nonnegativity and empty indices. E adds independent non-involutive paper row/column permutations with an asymmetric inversion detector. Its test weights (1,2,3,4,5) exercise generic linear transport without claiming normalized channel data; the actual R13 output four-cycle checks final directed mass transport. |
| R12 | G's supplied active presentations, full/reduced reachability, generic ambient and injective-map feasibility consumers. Its actual inactive Option.none label has mass zero and exact recovered data D. |
| R13 | Actual paper weights (0,2/3,0,0,1/3), values (1/3,1/3,1,2/3,0,0,0), retained rows 0,1,2,3 and columns 1,4 give a 4-by-2 reduced system. Actual restriction/extension agree. An explicit two-decoder witness aggregates the shared block; the same `r13Construction` has phase counts 2/5/4 and merges distinct 2/3 and 1/3 leaves to mass one in one PPM operation. |
| R14 | `obstructedData` has all five admissible partitions. Its signed full vector is (1/8,3/8,3/8,3/8,-1/4), but no nonnegative full/reduced solution exists and its channel is nonperfect. The accepted local contradiction forces a pair weight 3/8 against a singleton value bound 1/8; universal signed-solution uniqueness is not required. |

## C14/C15 handoff and scope

| Consumer need | Existing interface and limit |
| --- | --- |
| Positive bounded valid data | C12 `CompressedPatternData`, `value_pos`, `value_le_one`, `patterns_nonempty`; full values are zero or an occurring value. No additional full-value bound alias is needed by a present consumer. |
| Structural identities | I's `inputMatrix_mulVec_value`, `fullInputMatrix_mulVec_fullValue`, `inputMatrix_mul_reducedMatrix`, `fullInputMatrix_mul_fullMatrix`; no feasibility assumption. |
| Exact finite dimensions and nonempty patterns | `card_nonzeroPattern`, `card_occurringPattern`, `patterns_card_le`, `card_admissiblePartition_le`, subtype nonemptiness of each pattern. No nonempty admissible-family guarantee. |
| Normalized equality witnesses | `sum_eq_one_of_reduced_eq`, `sum_eq_one_of_full_eq`, sharper incidence bounds, positive support, and the actual restriction/extension functions. |
| Perfectness and arbitrary coordinates | C's reduced/full and ambient equivalences; `system_reindex_iff` preserves supplied coefficients, equation and nonnegativity. `normalForm` retains the directed output comparison. |
| C14-owned work | Inequality feasible set, objective bound, saturation/equality, greatestness and attainment contract, including empty J; no primal theorem implemented here. |
| C15-owned work | Weak duality, finite separation/convex-hull hypotheses, pattern-size weighted identity and sign correction, scaling positivity, leastness and attainment. Handle empty J before invoking a nonempty convex-hull result. |

I imports public C12 `Matrix.PatternCompression`, C10 `Matrix.Partitions` and
four focused mathlib modules. C imports I and public C11
`Matrix.CanonicalReachability`. Neither imports tests/examples or C11 private
declarations. The lightweight root remains unchanged. There is no new generic
information-theory proof, dependency upgrade, public alias or solver API.

## Advice and omissions

The [original advice dispositions](pfr-c13-planning-notes.md#revision-2-advice-dispositions)
remain in force: shared blocks replace impossible repeated supported-decoder
partition images; R08 separates the typed vectors; R09 and R13 cover zero
coefficients and a genuine merge; R14 distinguishes nonempty J from feasibility;
the public construction consumer inspects the same returned object.
The separate proposed 5-by-3 fixture was already declined in favor of R13.

The C12 optional idempotence alias was reassessed at its S04/S05 trigger.
`compressedPatternData_map_injective` and `D.extraction_roundTrip` already
prove the actual inactive-output consumer. The suggestion is declined for C13;
a concrete later consumer demonstrating new interface friction may reopen it.
The original reference, owner and disposition remain in the planning notes and
OM-068. No numbered Future Work Note is needed. C11 private-helper promotion
has no trigger because the public-witness necessity route works.

OM-017 retains general Bell enumeration/growth; OM-019 retains complexity prose;
OM-025/OM-047 retain the full/reduced/nonnegative repair; OM-027 and OM-042
record private fixtures and displayed-intermediate coverage; OM-051/OM-052
retain actual witnessed paths and directed comparisons; OM-068 retains the
support-finset representation and C12 transport. Optimization/duality remain
OM-046 and C14/C15. Algorithmic, extended-only and publication exclusions are
unchanged. All 71 omission identifiers and prior history are preserved.


## S06 cumulative assessment boundary

The tables above were freshly checked against the complete current source,
with separate exhaustive compiler/axiom inventory and manuscript assessment.
Earlier favorable step reports serve as provenance; they do not replace this
new pass. The parent independently inspected production contracts, generic
consumers and the sensitive concrete regressions, reran required focused/full
builds and exact finite arithmetic, and checked scope, pins and prior records.
No new mathematical assertion is deferred to closeout. The same bound reviewer has
now completed its fresh cumulative assessment, and the parent has critically
reconciled the complete original report. The review establishes readiness at its
source snapshot; final applicable validation/F and supported closure remain
separate duties. Only that closure certifies workflow completion. C14/C15 remain unstarted.
