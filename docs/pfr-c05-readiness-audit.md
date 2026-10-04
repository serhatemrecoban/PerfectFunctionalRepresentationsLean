# PFR-C05 cumulative readiness audit

Updated 2026-09-13. S01-S06 are durably complete. The separately authorized
S07 fresh cumulative review and closeout are active after exact prerequisite
verification. Fresh cumulative/default builds and all 38 public signature/axiom
checks pass. Independent S07 review satisfied every required assessment and
its complete original report is critically reconciled. Final applicable
validation, F and durable closure are governed by the subsequent execution record. See the [S07 evidence section](#s07-fresh-cumulative-assessment).

The following S06 source maps account for the approved plan's fifteen S01-S05
criteria, three S06 criteria, R01-R18 and ten completion outcomes. Their Lean
anchors remain current because S07 preserves every reviewed Lean byte. E1-E5
and F06, including dated S06 preclosure wording, are retained historical
evidence; the new S07 checks and cumulative assessment are recorded separately.

## Baseline, source identity and evidence

| Item | Captured value |
| --- | --- |
| Accepted S06 baseline B | `517245dfd4374d99217e79e892a680fd34fb2a62764a6b7b869995c150172e8b` |
| Verified S05 prerequisite closure | `69082fa98c31b9009fcd4dc00c43cb14bc435133db67af7e236b4a9a22c474fb` |
| S05 final source/environment fingerprint | `057e3593dd8a0c9fb4307a00aea93558d76072c669fd0c23c50eb17c9271b3d4`; exact applicability verified before S06 acceptance |
| Binary source | `PerfectFunctionalRepresentations/Semantics/Binary.lean`, SHA-256 `3C9FCDD5F5565C845CABB491B8C4D5489332CE95A3106674F81BC4AA7BF243CA` |
| Binary regressions | `PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean`, SHA-256 `BF2DD0D06C826C39183A9A14E09873F605DCD5E8738D4697ABF1AB96354FF1CA` |
| Approved contract | [C05 plan](plans/pfr-c05-binary-input-lemma3.md), especially Sections 6–9; normative contract preserved during editorial status updates |
| Mathematical root | [root:6](../PerfectFunctionalRepresentations.lean#L6) adds only `Semantics.Binary`; SHA-256 `178E0970D3A5B6D7DF8028D69957A0D9DF0F05D64008C4D5FB8266CBA91A7AC4` |
| Root regression | [BinaryRoot:1](../PerfectFunctionalRepresentations/Tests/Semantics/BinaryRoot.lean#L1) imports only the mathematical root; four anonymous examples; SHA-256 `D37AF700458286C5E023CB058B6EEB2C62B8B72288EEA59E37D7012791BA865F` |
| Fresh reference applicability | All eight supplemental and both manuscript hashes verified; exact retained anchor extracts reread. This is not a claim of fresh visual PDF inspection. |
| Outstanding audit state | Independent S06 review and original-report reconciliation are complete. Final validation/closure are governed by the execution record. S07 is unstarted. |

E1–E5 are historical step validation recorded in the maintained implementation notes. **F06 is fresh cumulative S06 validation and applies to every source declaration and regression mapped below.** F06 does not replace independent review and is not a durable-closure claim.

| Evidence key | Provenance / scope | Actual result |
| --- | --- | --- |
| E1 | [implementation notes:81](pfr-c05-implementation-notes.md#L81) | Corrected S01 focused build 2759 jobs, default 2761; 12 signature/axiom checks. Interrupted probes and failed iterations retained separately. |
| E2 | [implementation notes:271](pfr-c05-implementation-notes.md#L271) | Corrected S02 focused Binary/R01–R07/C03 counterexample 2765 jobs, default 2761; 5 new public checks. |
| E3 | [implementation notes:414](pfr-c05-implementation-notes.md#L414) | Corrected S03 focused Binary/R01–R10/Canonical/Singularity 2764 jobs, default 2761; 5 new public checks. |
| E4 | [implementation notes:589](pfr-c05-implementation-notes.md#L589) | Corrected S04 focused 2762 jobs, default 2761; 3 new public checks. Arithmetic failures are not passing evidence. |
| E5 | [implementation notes:713](pfr-c05-implementation-notes.md#L713) | S05 production/default 2761 and corrected fifth focused run 2765; 13 new public checks. Failed transport, declaration-enumeration and concrete Bool attempts remain distinct. |
| F06 — cumulative build | Twelve targets: production Binary, mathematical root, all five semantic regression modules, separate C03 example and example regression, and all three C04 probability/decoder/root regression modules | **PASS**, 2777 jobs, 27.439 seconds. Includes R01–R18 and preservation of separately imported probability/decoder/counterexample consumers. |
| F06 — default build | `lake build` | **PASS**, 2762 jobs, 3.664 seconds. |
| F06 — root-only public audit | All 38 `#check` and `#print axioms` checks, plus two `#print` inspections, through the mathematical root | **PASS**, 17.082 seconds. Only `propext`, `Classical.choice` and `Quot.sound`. |
| F06 — imports | 2745 resolved modules plus 185 standard frontier entries | **PASS**. Only newly reached project module is Binary; no new LeanInfoTheory/foundational modules and no optional decoder/Fano/test/example imports. |
| F06 — references | Eight supplemental and two manuscript hashes; retained exact source-anchor extracts | **PASS**. Hashes freshly verified and extracts reread; no fresh visual inspection claim. |
| Retained negative attempt | Initial root/R18 attempt | Root built, but the first R18 combined consumer failed because `intro` consumed its leading let-bound Fintype. Adding `dsimp only` before `intro` repaired elaboration. This failed attempt is retained as negative evidence; acceptance relies on the corrected F06 run. |

E1–E5 historical trust summaries also report only `propext`, `Classical.choice` and `Quot.sound`. The current trust conclusion comes from F06’s fresh root-only audit.

## Fifteen earlier criteria

| Criterion | Exact implementation anchors | Assumptions / representation boundary | Regression / validation provenance |
| --- | --- | --- | --- |
| C05-S01-C01 | [map_finTwoArrowEquiv_symm_roundtrip](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L52); [map_finTwoArrowEquiv_roundtrip](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L57); four marginal laws at 62/68/74/80; [isCoupling_iff_isCanonicalCoupling_finTwoArrowEquiv](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L86); [isCanonicalCoupling_iff_isCoupling_finTwoArrowEquiv](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L94). | Arbitrary output type; no finite-output hypothesis on the product/vector law equivalence. | R01; E1. F06 current validation. |
| C05-S01-C02 | [canonicalJoint_map_finTwoArrowEquiv_symm](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L103); [canonicalJoint_map_finTwoArrowEquiv](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L112); [IsCoupling.fstSndMarginal_binaryCanonicalJoint](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L123); [finiteTV_inputEnumeration_eq](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L151). C04 owns [finiteTV](../PerfectFunctionalRepresentations/Probability/FiniteCoupling.lean#L48), [finiteTV_eq_one_sub_overlap_toReal](../PerfectFunctionalRepresentations/Probability/FiniteCoupling.lean#L87) and [finiteTV_comm](../PerfectFunctionalRepresentations/Probability/FiniteCoupling.lean#L118). | Every prior, including either point prior. Only numeric TV/overlap uses `[Fintype beta]`; no new r definition. | R02/R03; E1. F06 current validation. |
| C05-S01-C03 | [Tests/Binary:39](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L39) through the empty-input check at [Tests/Binary:199](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L199); 12 public theorems / one private helper; current four production imports at Binary:1. | Source/import/API inventory is explicit; F06 validates the cumulative implementation and public signatures. | E1; F06 cumulative checks pass. |
| C05-S02-C01 | [IsSingularChannel.overlapMass_eq_sum_shared](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L180); [IsSingularChannel.maximalCoupling_apply_shared_exclusive](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L191); [exists_binary_maximal_commonPosterior](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L331). Private supported-fiber collapse at 229/286 and selected null fallback at 313/318. | `[Fintype beta]`; singular Fin 2 channel; no prior, full output support or `Nonempty beta`. Public existential includes actual globally-null fallback. | R04/R05/R06; E2. F06 current validation. |
| C05-S02-C02 | [isPerfectlyRepresentableChannel_iff_isSingular_of_input_card_eq_two](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L364); [isPerfectlyRepresentableChannel_iff_isSingular_of_binary](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L384); C03 generic necessity and existing ambient-two-output theorem consumed at [Tests/Binary:413](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L413) / [Tests/Binary:418](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L418). | `[Fintype alpha] [Finite beta] [Nonempty alpha]`; cardinality-two input or at most two active outputs. Prior-free. | R07; E2. F06 current validation. |
| C05-S02-C03 | [Tests/Binary:241](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L241), [Tests/Binary:325](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L325), [Tests/Binary:335](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L335), [Tests/Binary:343](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L343), [Tests/Binary:360](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L360), [Tests/Binary:388](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L388). Preserve [nonrepresentable3x3_isSingular](../PerfectFunctionalRepresentations/Examples/Nonrepresentable3x3.lean#L33) and [nonrepresentable3x3_not_isPerfectlyRepresentableChannel](../PerfectFunctionalRepresentations/Examples/Nonrepresentable3x3.lean#L40). | Five new public theorems; four private definitions and ten private theorems; C03 counterexample remains separately imported. | E2; F06 counterexample/downstream builds pass. |
| C05-S03-C01 | [condFstGivenSnd_binaryCanonicalJoint](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L432); private [entropy_binaryEvaluation](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L443), [weighted_fiber](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L465), [mismatch_vector_sum](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L480); [condEntropyOf_binaryCanonicalJoint](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L494). | Every p/q, `[Fintype beta]`; pointwise conditional law requires `q w ≠ 0`; null terms vanish by weight. | R08/R09; E3. F06 current validation. |
| C05-S03-C02 | [mutualInfoOf_binaryCanonicalJoint](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L509); [IsCanonicalFunctionalRepresentationOf.condEntropyOf_eq_binary_mismatch](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L518); [IsCanonicalFunctionalRepresentationOf.mutualInfoOf_eq_binary_mismatch](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L530). | Full-triple-law transport, unrestricted source and independent output universe; entropy/information remain in nats. | R10 and aggregate half-mismatch fixture; E3. F06 current validation. |
| C05-S03-C03 | [Tests/Binary:479](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L479), [Tests/Binary:523](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L523), [Tests/Binary:544](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L544), [Tests/Binary:554](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L554), [Tests/Binary:567](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L567), [Tests/Binary:575](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L575), [Tests/Binary:581](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L581); five public and five private theorems. | Uses pinned weighted conditional entropy and deterministic/injective entropy APIs; no new decoding or generic entropy layer. | E3; F06 cumulative checks pass. |
| C05-S04-C01 | [IsFunctionalRepresentationOf.mutualInfoOf_le_binary_bound](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L567); private [entropy_binary_eq_zero_of_not_fullSupport](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L545). | Exact prescribed pair law; arbitrary p; unrestricted omega; independent beta/gamma universes with finite value alphabets. Full support is a proof split, never a premise. | R11/R13; E4. F06 current validation. |
| C05-S04-C02 | [maximalBinaryCanonicalJoint_attains](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L604); [exists_binary_information_maximizer](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L629). | Specified C04 maximal coupling mapped to vectors; canonical/structural representation, exact pair marginal and actual information equality. Maximum = bound plus finite attaining triple-law extension. | R12/R13; E4. F06 current validation. |
| C05-S04-C03 | [Tests/Binary:602](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L602), [Tests/Binary:618](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L618), [Tests/Binary:654](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L654), [Tests/Binary:680](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L680), [Tests/Binary:688](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L688), [Tests/Binary:749](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L749), [Tests/Binary:764](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L764), [Tests/Binary:775](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L775), [Tests/Binary:786](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L786); three public theorems / one private helper. | Unseen-row discrepancy and actual representation are checked together; higher-universe finite auxiliary and singleton outputs included. | E4; F06 cumulative checks pass. |
| C05-S05-C01 | [mutualInfo_channelJoint_le_binary_entropy](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L673); [IsSingularChannel.binary_entropy_eq_mutualInfo](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L683); [binary_entropy_eq_mutualInfo_iff_isSingular_of_fullSupport](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L700). | Inequality and singular forward equality hold for every prior. Only converse has `∀ x, x ∈ p.support`. Perfectness route reuses C01/C02/C03/S04; no division by entropy or new analytic equality theorem. | R14/R15; E5. F06 current validation. |
| C05-S05-C02 | [channelJoint_map_binaryInput](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L724); [IsFunctionalRepresentationOf.mutualInfoOf_le_twoInput_bound](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L776); [maximalTwoInputCanonicalJoint_attains](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L809); [exists_twoInput_information_maximizer](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L859); pair wrappers 873/882/894 and common-base wrappers 914/927/941. | `e : alpha ≃ Fin 2`; `[Fintype alpha] [Fintype beta]` and finite gamma only for auxiliary MI bound; no finite source. Vector transport is `w ↦ fun x => w (e x)`. Generic function enumeration is classical locally, without a DecidableEq caller premise. | R16; E5. F06 current validation. |
| C05-S05-C03 | [Tests/Binary:829](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L829), [Tests/Binary:843](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L843), [Tests/Binary:880](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L880), [Tests/Binary:894](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L894), [Tests/Binary:939](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L939), [Tests/Binary:962](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L962), [Tests/Binary:1058](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L1058), [Tests/Binary:1097](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L1097), [Tests/Binary:1118](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L1118), [Tests/Binary:1130](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L1130), [Tests/Binary:1142](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L1142), [Tests/Binary:1157](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L1157); thirteen public and seven private theorems. | Mandatory nonsingular point-prior guard; actual mapped attaining witness with unused labels; subtype rows are supplied on the subtype, never inferred by restriction. | R14/R15/R16/R17; E5; F06 all-signature/import audit passes. |

## Regression mapping

Anonymous `example` declarations are cited by exact file lines; named fixtures remain private.

| ID | Exact regression anchors | What the consumer establishes | Production/evidence connection |
| --- | --- | --- | --- |
| R01 | [Tests/Binary:39](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L39), [Tests/Binary:42](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L42), [Tests/Binary:45](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L45), [Tests/Binary:64](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L64), [Tests/Binary:107](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L107), [Tests/Binary:113](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L113), [Tests/Binary:117](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L117), [Tests/Binary:122](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L122) | Inverse full laws; four coordinate marginals; nonsymmetric masses 1/3 at (0,1), 2/3 at (1,0); product swap agrees with vector swap. | S01 public law boundary (52–112); E1. F06 current validation. |
| R02 | [Tests/Binary:126](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L126), [Tests/Binary:129](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L129), [Tests/Binary:133](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L133), [Tests/Binary:137](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L137), [Tests/Binary:141](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L141), [Tests/Binary:145](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L145), [Tests/Binary:194](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L194) | Nonuniform full-support prior and each point prior; exact four pair atoms; supplied PMF row rules out Empty output. | `IsCoupling.fstSndMarginal_binaryCanonicalJoint`; E1. F06 current validation. |
| R03 | [Tests/Binary:158](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L158), [Tests/Binary:162](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L162), [Tests/Binary:166](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L166), [Tests/Binary:171](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L171), [Tests/Binary:176](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L176), [Tests/Binary:180](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L180), [Tests/Binary:186](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L186), [Tests/Binary:199](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L199) | Half-L1 and overlap identity, TV=1/3, row swap, Bool orientation/different enumeration, Fintype.equivFinOfCardEq, Empty input cannot have card 2. | `finiteTV_inputEnumeration_eq` + C04; E1. F06 current validation. |
| R04 | [Tests/Binary:241](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L241), [Tests/Binary:254](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L254), [Tests/Binary:258](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L258), [Tests/Binary:262](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L262), [Tests/Binary:270](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L270), [Tests/Binary:325](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L325) | Singular shared/exclusive Fin 5 rows; exact atom table; actual common posterior with two distinct positive exclusive-vector atoms. | `exists_binary_maximal_commonPosterior` and private `posterior_nontrivial`; E2. F06 current validation. |
| R05 | [Tests/Binary:305](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L305), [Tests/Binary:308](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L308), [Tests/Binary:335](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L335), [Tests/Binary:343](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L343) | Identical rows give diagonal coupling/overlap 1; disjoint rows give independent product/overlap 0; new semantic theorem is consumed. | C04 endpoint results + S02; E2. F06 current validation. |
| R06 | [Tests/Binary:298](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L298), [Tests/Binary:315](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L315), [Tests/Binary:325](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L325) | Fin 5 output 4 is outside active union; actual selected V 4 equals vector law; singleton output channel is perfectly representable. | Null clause in common-posterior existential; E2. F06 current validation. |
| R07 | [Tests/Binary:360](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L360), [Tests/Binary:378](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L378), [Tests/Binary:388](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L388), [Tests/Binary:413](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L413), [Tests/Binary:418](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L418); [C03 separate counterexample consumer](../PerfectFunctionalRepresentations/Tests/Examples/Nonrepresentable3x3.lean#L29) | Input branch has four active outputs; other branch has three inputs/two active outputs; Bool input transport and printed-two-output consumer; generic necessity and 3×3 counterexample remain distinct. | Combined Lemma 2 + unchanged C03 APIs; E2; F06 cumulative counterexample build passes. |
| R08 | [Tests/Binary:449](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L449), [Tests/Binary:458](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L458), [Tests/Binary:482](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L482), [Tests/Binary:487](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L487), [Tests/Binary:493](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L493), [Tests/Binary:500](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L500), [Tests/Binary:508](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L508), [Tests/Binary:514](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L514), [Tests/Binary:544](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L544), [Tests/Binary:548](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L548) | Positive w00/w10 fibers under fair vector mixture and nonuniform input; actual pure law/zero entropy, reversed masses 2/3 and 1/3, unchanged input entropy; mismatch coefficient independently equals 1/2. | Positive law and aggregate identities; E3. F06 current validation. |
| R09 | [Tests/Binary:524](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L524), [Tests/Binary:528](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L528) | Null unequal w01 vector: weight times arbitrary real value is zero; actual weighted conditional-entropy term also vanishes. | No arbitrary null conditional PMF entropy assertion; E3. F06 current validation. |
| R10 | [Tests/Binary:555](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L555), [Tests/Binary:560](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L560), [Tests/Binary:567](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L567), [Tests/Binary:575](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L575), [Tests/Binary:581](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L581) | Both point priors, arbitrary vector PMF/output universe, higher-universe unrestricted carrier, Nat source and ULift output; full-triple and MI transport. | S03 common-source APIs and C02 full-law theorem; E3. F06 current validation. |
| R11 | [Tests/Binary:602](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L602), [Tests/Binary:618](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L618) | Original finite auxiliary with any support-correct decoder; independence + actual support decoding; exact pair law; unrestricted source and distinct value universes. | C02 MI preservation + S04 universal bound; E4. F06 current validation. |
| R12 | [Tests/Binary:645](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L645), [Tests/Binary:654](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L654), [Tests/Binary:665](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L665), [Tests/Binary:680](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L680), [Tests/Binary:688](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L688) | Nonsingular skew/reversed rows; TV 1/3; nonuniform supported prior; output masses 5/9 and 4/9; specified maximal vector, exact pair law, actual information objective and finite existential. | `maximalBinaryCanonicalJoint_attains`, not only a mismatch optimizer; E4. F06 current validation. |
| R13 | [Tests/Binary:714](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L714), [Tests/Binary:719](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L719), [Tests/Binary:728](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L728), [Tests/Binary:733](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L733), [Tests/Binary:741](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L741), [Tests/Binary:749](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L749), [Tests/Binary:764](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L764), [Tests/Binary:775](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L775), [Tests/Binary:786](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L786) | Nat source, constant input/output, ULift Unit auxiliary; actual FR and pure-0 pair; decoder vector differs from unseen row; unused Fin 3 output 2; arbitrary point-prior attainment and Unit output. | Degenerate bound/attainment; distinct from R15 nonsingularity guard; E4. F06 current validation. |
| R14 | [Tests/Binary:814](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L814), [Tests/Binary:829](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L829), [Tests/Binary:843](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L843) | All-prior singular forward interface; nonuniform full-support deterministic singular equality; full-support nonsingular strict gap from inequality + iff. | S05 Fin 2 three-theorem package; E5. F06 current validation. |
| R15 | [Tests/Binary:863](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L863), [Tests/Binary:871](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L871), [Tests/Binary:875](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L875), [Tests/Binary:880](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L880), [Tests/Binary:888](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L888) | Mandatory pure-0 prior with fair row0 / pure-0 row1: ambient nonsingularity, TV 1/2, H(X)=I(X;Y)=0 and rH(X)=I(X;Y). | Shows removing support from ambient iff would be false; E5. F06 current validation. |
| R16 | [Tests/Binary:894](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L894), [Tests/Binary:920](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L920), [Tests/Binary:925](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L925), [Tests/Binary:929](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L929), [Tests/Binary:939](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L939), [Tests/Binary:944](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L944), [Tests/Binary:951](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L951), [Tests/Binary:955](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L955), [Tests/Binary:962](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L962), [Tests/Binary:977](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L977) | Four independent source/value universes; nonuniform Bool prior, exact pair, full support, entropy and explicit inverse-coordinate attaining vector; native/classical finite vector instances reconciled by congruence. | Semantic input interfaces, enumeration independence; E5. F06 current validation. |
| R17 | [Tests/Binary:1020](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L1020), [Tests/Binary:1058](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L1058), [Tests/Binary:1097](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L1097), [Tests/Binary:1108](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L1108), [Tests/Binary:1118](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L1118), [Tests/Binary:1130](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L1130), [Tests/Binary:1142](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L1142), [Tests/Binary:1157](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L1157) | Common injection preserves scalar, objective and actual mapped canonical witness with exact pair; Fin 3 label2 unused; rows already on common subtype; mapped-channel inequality/equality consumers. | C04 injective TV + pinned entropy invariance + S04/S05; private fixture helpers only; E5. F06 current validation. |
| R18 | [BinaryRoot:18](../PerfectFunctionalRepresentations/Tests/Semantics/BinaryRoot.lean#L18) combined input/active-output Lemma 2; [28](../PerfectFunctionalRepresentations/Tests/Semantics/BinaryRoot.lean#L28) printed ambient-output branch; [35](../PerfectFunctionalRepresentations/Tests/Semantics/BinaryRoot.lean#L35) a specified finite canonical attainer with exact pair law/information and domination of every original finite auxiliary; [65](../PerfectFunctionalRepresentations/Tests/Semantics/BinaryRoot.lean#L65) common-base inequality, singular forward equality and explicit-support iff. Sole import [line1](../PerfectFunctionalRepresentations/Tests/Semantics/BinaryRoot.lean#L1) is the root. | Uses independent omega/alpha/beta/gamma universes, unrestricted source, arbitrary priors and `Fintype.equivFinOfCardEq`; no full-support premise on the bound/attainment/inequality/forward equality. Structural branch retains `[Finite beta]`. | F06 cumulative 12-target build passes, including the complete corrected R18 module. Initial let-bound Fintype failure and `dsimp only` repair at line23 are retained separately as negative history. |

## All ten completion outcomes

| Outcome | Required content | Source/evidence mapping | Readiness qualification |
| --- | --- | --- | --- |
| C05-CC01 | Source interpretation documented | Plan Section 2, [implementation notes:30](pfr-c05-implementation-notes.md#L30), [implementation notes:200](pfr-c05-implementation-notes.md#L200), [implementation notes:373](pfr-c05-implementation-notes.md#L373), [implementation notes:548](pfr-c05-implementation-notes.md#L548), [implementation notes:674](pfr-c05-implementation-notes.md#L674); departure table below; map OM-014/053/055/056/059–067. | Source mapping complete; F06 freshly verified both manuscript and eight supplemental hashes and reread exact retained anchor extracts. No fresh visual inspection is claimed. |
| C05-CC02 | C04-normalized laws and scalar | S01 criteria; Binary52–151; C04 finiteTV48 / overlap87 / symmetry118; R01–R03. | Present in current source; E1 history and F06 fresh validation. |
| C05-CC03 | Prior-free binary/combined Lemma 2 | S02 criteria; Binary180/191/331/364/384; R04–R07; C03 necessity/output branch. | Present in current source; E2 history and F06 fresh validation. Counterexample remains separate. |
| C05-CC04 | Arbitrary p/q entropy and MI identities | S03 criteria; Binary432/494/509/518/530; R08–R10. | Present in current source; E3 history and F06 fresh validation. No coupling/full-support premise. |
| C05-CC05 | Universal finite-auxiliary information bound | S04-C01 and S05 semantic bound; Binary567/776; R11/R13/R16. | Present in current source; E4/E5 history and F06 fresh validation. Source unrestricted, auxiliary finite. |
| C05-CC06 | Specified finite information attainment | S04-C02; Binary604/629/809/859; R12/R13/R16 and actual mapped R17 witness. | Present in current source; E4/E5 history and F06 fresh validation. Maximum supplied by composable bound and attaining witness; R18 consumes the comparison directly. |
| C05-CC07 | Inequality, singular equality, support-qualified iff | S05-C01/C02; Binary673/683/700/873/882/894/914/927/941; R14–R17. | Present in current source; E5 history and F06 fresh validation; mandatory nonsingular degenerate guard is explicit. |
| C05-CC08 | All regressions, boundaries and public trust audit | R01–R18 table and fresh cumulative build; all 38 public signatures/axioms checked through the root in F06; historical trust checks 12+5+5+3+13 remain separate. | F06 regression and root-only trust checks pass; only standard axioms occur. Initial source/artifact checks pass; independent S06 assessment and reconciliation are complete; final closeout is governed by the execution record. |
| C05-CC09 | Builds, import boundary and proof integrity | Four Binary imports, required placeholder scan, F06 cumulative/default/import/trust results and the Section9 target matrix. | F06 focused/default/downstream/root and optional-decoder-preservation checks pass. Required scan returned no matches. Initial source/artifact checks pass; final closeout remains pending. No from-scratch clean-build claim. |
| C05-CC10 | Truthful cumulative documentation and provenance | Plan, implementation notes, living summary, formalization map/omission register, project log, README/roadmap and this cumulative mapping. | Initial owning-document and source/diff/artifact audits pass; independent S06 review and reconciliation are complete; final closure is governed by the execution record. S07 is unstarted and requires separate authorization. |

## Assumptions, source departures and omissions

| Boundary | Current precise contract and ownership |
| --- | --- |
| Manuscript identity | Plan Section2 records six-page ISIT SHA-256 `48963AA59485B2C33B1A1E6E7C6EAD2251FDDDD26BD3691B6FCFFE683E6ED1C4` and eighteen-page extended version16 SHA-256 `98636D4C9F0618EC08FCA84559572780F604F197FDA90D8D7C787B3624245B8F`. Exact C05 anchors: ISIT PDFp2 opening support convention, II-B Lemma2 and II-C Equation10/Lemma3; extended AppendixA p12 (111)–(124), p13 (147)–(148), p14 (149)–(166). F06 freshly verified both manuscript hashes and reread exact retained anchor extracts; it does not claim fresh visual PDF inspection. |
| Coordinate numbering | Paper vector labels1/2 become Lean0/1. Product first/second order is fixed by four public marginal laws. Semantic inputs use `e : alpha ≃ Fin 2`; structural intrinsic iff also exposes `Fintype.card alpha = 2`. OM-014/067. |
| Scalar r and units | r is C04’s existing `finiteTV row0 row1`, exactly half-L1; overlap/mismatch use ENNReal and checked toReal identities. Entropy/MI are pinned Real-valued nats. No r alias, new normalization, base conversion or generic TV theory. OM-059/060/067. |
| Finite information | Structural laws have arbitrary output types where possible. Entropy/TV interfaces use finite value alphabets; source omega is unrestricted. Finite auxiliary may be in an independent universe. No infinite-auxiliary information result. OM-053/064. |
| Maximum | Universal bound plus explicit maximal-coupling canonical triple and finite existential attaining extension. No auxiliary on every original source, optimizer structure, supremum over types, uniqueness, minimum-cardinality/entropy result or infinite-type optimization. OM-046/064. |
| Prior support | Bound, attainment, inequality and singular forward equality allow every prior. Only ambient-channel equality converse requires every input in p.support. Nonfull Fin2 priors are proved pure; an unseen decoder coordinate is never identified with an ambient row. OM-055/063; R13 differs from R15. |
| Active output scope | Binary-input singular construction includes both-zero ambient columns. The printed common/exclusive partition is interpreted on active outputs. Combined Lemma2 reuses C03’s at-most-two-active-output branch, with existing printed ambient-two-output consumer. OM-056/066. |
| Null conditional fibers | Positive-vector conditional law requires nonzero q atom. Null vector terms vanish under zero weights; no entropy of an arbitrary null PMF is prescribed. The S02 selected total common posterior has explicit globally-null value equal to the vector law. OM-065/066. |
| Normalized components/endpoints | C04’s unnormalized overlap/residual masses and single-denominator maximal law are reused. Shared/exclusive atom theorem preserves (111)–(124) logical content without public normalized A/B/C PMFs or normalization of zero mass. Overlap0/1 are checked. OM-061/066. |
| Transport and function enumeration | The prior is p.map e, rows are kappa(e.symm i), vector maps by precomposition with e. Entropy/MI invariance uses pinned injective/equivalence laws. Generic finite function enumeration is supplied classically within statements, without [DecidableEq alpha]. Concrete Bool consumer reconciles native/classical Fintype instances using congruence/subsingleton equality. |
| Output injections/subtypes | A common injection preserves scalar, objective and actual mapped attaining witness. Subtype examples begin with both PMFs already on the common subtype. No restriction of arbitrary ambient laws is inferred. OM-066/067. |
| Public granularity | No public theorem per numbered intermediate is promised. C01–C04 retain their existing ownership. C03’s separate 3×3 counterexample and C04 probability equations(156)–(161) are reused, not reopened. AppendixB/later/extended-only results remain outside C05. OM-042/059–062/067. |

## Source API inventory

All named production declarations below belong to `PerfectFunctionalRepresentations`. Counts exclude imported APIs, generated equation theorems and anonymous examples.

| Step | Public theorems | Private theorems | Private definitions | Named total |
| --- | ---: | ---: | ---: | ---: |
| S01 | 12 | 1 | 0 | 13 |
| S02 | 5 | 10 | 4 | 19 |
| S03 | 5 | 5 | 0 | 10 |
| S04 | 3 | 1 | 0 | 4 |
| S05 | 13 | 7 | 0 | 20 |
| Total | **38** | **24** | **4** | **66** |

Binary regressions contain **83 anonymous examples**, **37 private theorems**, **30 private definitions** and **one private abbreviation**; no named public fixture API. These are an inventory, not proof/coverage quotas.

### Public theorem checklist

| Step | Declaration | Current source |
| --- | --- | --- |
| S01 | `map_finTwoArrowEquiv_symm_roundtrip` | [Binary:52](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L52) |
| S01 | `map_finTwoArrowEquiv_roundtrip` | [Binary:57](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L57) |
| S01 | `map_finTwoArrowEquiv_symm_eval_zero` | [Binary:62](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L62) |
| S01 | `map_finTwoArrowEquiv_symm_eval_one` | [Binary:68](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L68) |
| S01 | `fstMarginal_map_finTwoArrowEquiv` | [Binary:74](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L74) |
| S01 | `sndMarginal_map_finTwoArrowEquiv` | [Binary:80](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L80) |
| S01 | `isCoupling_iff_isCanonicalCoupling_finTwoArrowEquiv` | [Binary:86](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L86) |
| S01 | `isCanonicalCoupling_iff_isCoupling_finTwoArrowEquiv` | [Binary:94](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L94) |
| S01 | `canonicalJoint_map_finTwoArrowEquiv_symm` | [Binary:103](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L103) |
| S01 | `canonicalJoint_map_finTwoArrowEquiv` | [Binary:112](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L112) |
| S01 | `IsCoupling.fstSndMarginal_binaryCanonicalJoint` | [Binary:123](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L123) |
| S01 | `finiteTV_inputEnumeration_eq` | [Binary:151](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L151) |
| S02 | `IsSingularChannel.overlapMass_eq_sum_shared` | [Binary:180](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L180) |
| S02 | `IsSingularChannel.maximalCoupling_apply_shared_exclusive` | [Binary:191](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L191) |
| S02 | `exists_binary_maximal_commonPosterior` | [Binary:331](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L331) |
| S02 | `isPerfectlyRepresentableChannel_iff_isSingular_of_input_card_eq_two` | [Binary:364](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L364) |
| S02 | `isPerfectlyRepresentableChannel_iff_isSingular_of_binary` | [Binary:384](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L384) |
| S03 | `condFstGivenSnd_binaryCanonicalJoint` | [Binary:432](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L432) |
| S03 | `condEntropyOf_binaryCanonicalJoint` | [Binary:494](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L494) |
| S03 | `mutualInfoOf_binaryCanonicalJoint` | [Binary:509](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L509) |
| S03 | `IsCanonicalFunctionalRepresentationOf.condEntropyOf_eq_binary_mismatch` | [Binary:518](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L518) |
| S03 | `IsCanonicalFunctionalRepresentationOf.mutualInfoOf_eq_binary_mismatch` | [Binary:530](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L530) |
| S04 | `IsFunctionalRepresentationOf.mutualInfoOf_le_binary_bound` | [Binary:567](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L567) |
| S04 | `maximalBinaryCanonicalJoint_attains` | [Binary:604](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L604) |
| S04 | `exists_binary_information_maximizer` | [Binary:629](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L629) |
| S05 | `mutualInfo_channelJoint_le_binary_entropy` | [Binary:673](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L673) |
| S05 | `IsSingularChannel.binary_entropy_eq_mutualInfo` | [Binary:683](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L683) |
| S05 | `binary_entropy_eq_mutualInfo_iff_isSingular_of_fullSupport` | [Binary:700](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L700) |
| S05 | `channelJoint_map_binaryInput` | [Binary:724](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L724) |
| S05 | `IsFunctionalRepresentationOf.mutualInfoOf_le_twoInput_bound` | [Binary:776](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L776) |
| S05 | `maximalTwoInputCanonicalJoint_attains` | [Binary:809](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L809) |
| S05 | `exists_twoInput_information_maximizer` | [Binary:859](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L859) |
| S05 | `mutualInfo_channelJoint_le_twoInput_entropy` | [Binary:873](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L873) |
| S05 | `IsSingularChannel.twoInput_entropy_eq_mutualInfo` | [Binary:882](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L882) |
| S05 | `twoInput_entropy_eq_mutualInfo_iff_isSingular_of_fullSupport` | [Binary:894](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L894) |
| S05 | `mutualInfoOf_le_twoInput_entropy` | [Binary:914](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L914) |
| S05 | `IsSingularChannel.twoInput_entropyOf_eq_mutualInfoOf` | [Binary:927](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L927) |
| S05 | `twoInput_entropyOf_eq_mutualInfoOf_iff_isSingular_of_fullSupport` | [Binary:941](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L941) |

F06 successfully checked these exact 38 names and their axioms through the mathematical root. The declaration inventory and the trust check are distinct evidence. All declarations above are prefixed by `PerfectFunctionalRepresentations.` in fully qualified Lean checks. S06 root integration adds no named mathematical theorem; R18 adds four anonymous examples and no private helper API.

### Private implementation inventory

| Step | Current source names and anchors | Ownership |
| --- | --- | --- |
| S01 | [`finiteTV_binary_perm`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L133) | One private row-permutation theorem. |
| S02 | [`singular_binary_column`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L161); [`vectorLaw`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L206); [`rowJoint`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L209); [`rowPosterior`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L212); [`vectorLaw_isCanonicalCoupling`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L215); [`vectorLaw_apply`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L220); [`shared_vector_eq`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L229); [`rowJoint_snd`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L255); [`rowJoint_fst`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L260); [`rowPosterior_factorization`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L265); [`rowPosterior_support`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L273); [`shared_rowPosterior_eq_pure`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L286); [`commonPosterior`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L313); [`commonPosterior_null`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L318) | 10 private theorems; four private definitions (vectorLaw, rowJoint, rowPosterior, commonPosterior). Explicit total posterior construction stays private; the public existential theorem exposes only the necessary factorization and actual null fallback. |
| S03 | [`outputVectorLaw`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L411); [`outputVectorLaw_apply`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L421); [`entropy_binaryEvaluation`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L443); [`weighted_fiber`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L465); [`mismatch_vector_sum`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L480) | Five private law/entropy/summation theorems. The positive conditional-law bridge is public due R08 consumer pressure; branch entropy and zero-weight machinery remain private. |
| S04 | [`entropy_binary_eq_zero_of_not_fullSupport`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L545) | One private degenerate binary-prior theorem; no generic entropy library duplication. |
| S05 | [`conditionalOutput_eq_entropy_sub_mutualInfo`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L647); [`functionalRepresentation_coordinates`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L661); [`binaryInput_outputLaw`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L731); [`binaryInput_mutualInfo`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L738); [`binaryInput_fullSupport`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L750); [`functional_binaryInput`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L761); [`canonicalJoint_binaryInput`](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L798) | Seven private common-source/transport helpers. Public output-injection theorem family was not added; R17 consumes existing C03/C04 transport. |

## Root and optional-module boundary

The current [Binary import list](../PerfectFunctionalRepresentations/Semantics/Binary.lean#L1) is exactly:

```lean
import PerfectFunctionalRepresentations.Semantics.Singularity
import PerfectFunctionalRepresentations.Probability.FiniteCoupling
import Mathlib.Logic.Equiv.Fin.Basic
import Mathlib.Data.Fintype.EquivFin
```

The root adds only `PerfectFunctionalRepresentations.Semantics.Binary` at [line 6](../PerfectFunctionalRepresentations.lean#L6), and the root-only regression adds only the mathematical root at [line 1](../PerfectFunctionalRepresentations/Tests/Semantics/BinaryRoot.lean#L1). Its four consumers use existing public declarations and do not require a new public theorem. F06’s passing transitive import audit resolves 2745 modules plus 185 standard frontier entries. Binary is the only newly reached project module; no newly reached LeanInfoTheory/foundational modules and no optional decoder/Fano/test/example imports occur.

The inherited semantic closure already reaches KL. The preserved optional boundary is `Probability.FiniteCouplingDecoding` and its Fano-facing dependency, plus tests/examples/matrix/optimization modules. No new dependency version, trusted axiom, entropy units or generic TV theory is proposed.

## Validation and remaining audit duties

| Evidence duty | Source/command scope | Current status |
| --- | --- | --- |
| Cumulative focused matrix | `PerfectFunctionalRepresentations.Semantics.Binary`, `PerfectFunctionalRepresentations`, `PerfectFunctionalRepresentations.Tests.Semantics.FunctionalRepresentation`, `PerfectFunctionalRepresentations.Tests.Semantics.Canonical`, `PerfectFunctionalRepresentations.Tests.Semantics.Singularity`, `PerfectFunctionalRepresentations.Tests.Semantics.Binary`, `PerfectFunctionalRepresentations.Tests.Semantics.BinaryRoot`, `PerfectFunctionalRepresentations.Examples.Nonrepresentable3x3`, `PerfectFunctionalRepresentations.Tests.Examples.Nonrepresentable3x3`, `PerfectFunctionalRepresentations.Tests.Probability.FiniteCoupling`, `PerfectFunctionalRepresentations.Tests.Probability.FiniteCouplingDecoding`, `PerfectFunctionalRepresentations.Tests.Probability.FiniteCouplingRoot` | F06 **PASS**, 2777 jobs, 27.439 seconds. |
| Default downstream build | `lake build` | F06 **PASS**, 2762 jobs, 3.664 seconds. |
| Public visibility and trust | All 38 exact fully qualified names above, imported through the root; `#check`, `#print axioms` and two `#print` inspections | F06 **PASS**, 17.082 seconds; only `propext`, `Classical.choice`, `Quot.sound`. |
| Transitive imports | Root and Binary production dependency closure | F06 **PASS**, 2745 resolved modules plus 185 standard frontier entries; only newly reached project module Binary, no new LeanInfoTheory/foundational modules; optional boundaries preserved. |
| Maintained proof-placeholder scan | Required AGENTS `rg -n --glob '*.lean' '\b(sorry|admit|axiom|opaque|undefined)\b' PerfectFunctionalRepresentations PerfectFunctionalRepresentations.lean` | No matches in the initial and post-reconciliation exact-source audits. |
| Prerequisite/source applicability | Verified S05 closure and F fingerprint; eight supplemental and two manuscript hashes; exact retained anchor extracts | Prerequisite closure/source applicability verified before S06 acceptance; F06 fresh reference verification passes. No fresh visual PDF inspection claim. |
| Source/diff/artifact audit | Maintained source, `git diff`, `git status`, index/tracked generated files, ignored references and retained attempts | Initial audit passes: nine changed baseline files, two new files and 90 unchanged real baseline files. S01-S05 Lean/tests and normative plan bytes are preserved; local links and tracked-artifact checks pass. Inherited changes and negative attempts remain distinct. |
| Owning-document audit | Plan/status/coverage/implementation notes/readiness, map dependencies/omissions, project log and reader-facing summaries | Current status/coverage and root/readiness links are normalized; all 67 omission IDs and earlier dated history remain preserved. Normative scope and S07 authorization are unchanged. |
| Independent S06 review and reconciliation | All three S06 criteria and cumulative mapping, with actual evidence | All three satisfied; no findings. Complete original report retained and critically reconciled. |
| Final validation/closure and later S07 | Final exact-source validation after reconciliation; separately authorized S07 cumulative assessment | S06 final completion is governed by the subsequent durable closure record. S07 unstarted; no automatic later-step authorization. |

## Three S06 readiness criteria

| Criterion | Source/evidence mapping | Current disposition |
| --- | --- | --- |
| C05-S06-C01 | [root:6](../PerfectFunctionalRepresentations.lean#L6) imports Binary; R18 at [18](../PerfectFunctionalRepresentations/Tests/Semantics/BinaryRoot.lean#L18)/[28](../PerfectFunctionalRepresentations/Tests/Semantics/BinaryRoot.lean#L28)/[35](../PerfectFunctionalRepresentations/Tests/Semantics/BinaryRoot.lean#L35)/[65](../PerfectFunctionalRepresentations/Tests/Semantics/BinaryRoot.lean#L65) consumes combined Lemma2, the ambient-output C03 branch, the full finite optimum package and common-base Lemma3. No added production theorem or optional import. | F06 cumulative/default/root-only/import checks pass. Independent S06 review satisfied this criterion; its original report is reconciled. The initial failed R18 attempt is retained as negative evidence. |
| C05-S06-C02 | All 15 earlier criteria, R01–R18, all ten C05-CC outcomes, 38-public/28-private production inventory and assumptions/departures/omissions are mapped above. F06 applies to every mapped source/regression and audits all public signatures/axioms. | Build/trust/import/reference and initial source/diff/artifact audits pass. Independent S06 assessment satisfied this criterion; its original report is reconciled. |
| C05-S06-C03 | Cumulative readiness is mapped with historical E1–E5 and fresh F06 evidence separately identified. Remaining audit, review and closure states are explicit. | Initial owning-document and source/diff/artifact audits pass. Independent S06 review and reconciliation are complete; final closure is governed by the execution record. S07 is unstarted and requires separate authorization. |

R18’s third consumer proves an actual existential finite canonical witness with the specified pair law and information value, then compares every original finite auxiliary on an arbitrary independent-universe source against it. Its fourth consumer keeps arbitrary priors for the inequality and singular forward implication and exposes full input support exactly on the converse. The first consumer’s corrected leading `let` handling changes elaboration only; it adds no mathematical hypothesis.


## Exact evidence and source audit provenance

Fresh initial records are retained privately under
`.pfr-review/setup/c05-s06-20260913/`: `cumulative-attempt01.json`,
`full-initial.json`, `public-initial.json`, `imports-initial.json`,
`supplemental-sources.json`, `source-integrated.json` and the subsequent
current-source audit. `F06` above is an evidence-table label, not a final
snapshot or closure reference. The public probe used
`lake env lean --threads=1 tmp/c05-s06/PublicAudit.lean` and printed the proofs
of `exists_binary_information_maximizer` and
`binary_entropy_eq_mutualInfo_iff_isSingular_of_fullSupport` after all checks.

Against accepted B, the only Lean changes are the root import/description and
four anonymous R18 consumers. The other nine owning Markdown files consist
of eight updated records and this new readiness audit. All 90 other real
baseline files remain unchanged. The exact normative plan outside its reserved
editorial block, pinned dependencies and eight supplements are preserved.
The required placeholder scan returns no matches. Git whitespace checking,
local links and the tracked generated/reference/private-artifact check pass.
The inherited dirty checkout is neither a clean-tree claim nor S06's diff.
Ignored support drafts and probes remain separate from durable review records;
the latter are preserved. This is a bounded source/header audit, not a universal
dependency or automated semantic verification of the Markdown tables.

## Independent S06 review and critical reconciliation

The same bound reviewer assessed R
`ce019066ca1a6d6cba69100cc1f5ae447c39ee7acb4841b985d562f57f78d6cb`.
Its complete original native report was preserved before classification,
captured as `09e132427b9196c8a1eacd6f8a53f97c46209d4bb8a63ad5187141eebc902e1d`,
accepted as valid and explicitly reconciled. The original empty submission
receipt remains uncertain; a separate original-report-backed confirmation
established delivery without resending. All three S06 criteria are satisfied
with no findings. This assesses root integration and mapping readiness; S07's
separate cumulative acceptance duties remain unstarted.

Independent checks passed the twelve-target build (2777 jobs), default build
(2762 jobs), all 38 root-only public signatures/axioms, two proof prints and
two additional consumers: finite attainment dominating arbitrary original
finite auxiliaries and the supported nonsingular common-source strict gap.
The corrected public audit exited 0 in 114.20 seconds using one Lean worker.
Only `propext`, `Classical.choice` and `Quot.sound` occur. The reviewer checked
all 267 source line links, actual boundary fixtures, both manuscript hashes
and exact anchor text, import scope, 67 omissions and current documentation.
Its 41 selected source hashes matched; this does not certify every inventory
entry or the implementer's private baseline/closure records. Standard runtime
import frontier entries remained unexpanded. No fresh visual PDF inspection
or clean rebuild is claimed.

The first reviewer scratch regex missed six same-line simp declarations and
misclassified numeric link labels. Its incomplete compiler was stopped at
98.31 seconds (exit 4294967295, no output). That attempt remains FAIL evidence;
none of the satisfied criteria cites it. The corrected complete audit supplies
the passing evidence. The initial implementer R18 failure is separately retained.

Critical reconciliation accepts C01 for the actual usable root package and
preserved optional imports; C02 for individually reviewable mappings, precise
hypotheses and actual boundary fixtures; and C03 for truthful internal-readiness
records supported by current builds and integrity checks. Prior optional advice
remains resolved without rewriting history. No mathematical, public-API, test
or normative-plan correction is warranted. Reconciliation changes only owning
Markdown records. Final cumulative/default builds and exact B/R checks pass, confirming continued
applicability before final capture and supported closure.

### Final validation checkpoint

Post-reconciliation cumulative validation passes all twelve targets again
(2777 jobs, 149.849 seconds); the default build passes 2762 jobs (9.316 seconds).
Records are `cumulative-closeout.json` and `full-closeout.json` in the private
S06 setup directory. The exact B and R audits, placeholder scan, local-link,
whitespace and tracked-artifact checks also pass. Only nine owning Markdown
files differ from R; all 92 other reviewed real files and the eight supplied
supplements remain unchanged. Earlier public signature/axiom and import evidence
therefore remains applicable. No clean rebuild or universal dependency audit
is inferred. The final current-document audit is retained as
`source-closeout.json`, with `review-impact-closeout.json` recording R
applicability. Final source capture and durable completion belong to the
subsequent supported execution record; no included source is edited after that
capture. S07 remains unstarted.

## S07 fresh cumulative assessment

S06 durable closure is
`a86b8723a79b0648de7776d5328e33bda7d80b87f7af9f923ebb863bfb7e49d9`;
its F is `af8539437df033b8e4c4cb2255719b61bd359ef3e58c4226fd128557cc1999f5`.
The implementation task verified its reconciliation, all three criteria and
exact equality of all 102 final source/environment entries before accepting
S07 once. S07 B is
`d3def0b47679f216bd37c22650a69a123e24a516b2553d613bf28954ea3f0352`.
These are parent-owned durable-history facts, not facts certified by the reviewer.

The fresh independent assessment must individually cover all eighteen earlier
criteria, R01-R18 and C05-CC01-C05-CC10, in addition to the three S07 criteria.
Earlier favorable reports do not substitute for the new assessment. All
current mathematics and consumer anchors above are retained without source
changes; S07 changes owning Markdown status/evidence records only.

| Fresh S07 evidence | Actual scope and result |
| --- | --- |
| Parent cumulative build | PASS: the twelve exact Section 9 targets, 2777 jobs, 4.689 seconds. Includes R01-R18, C01-C04 semantic/probability/root consumers and the separate optional decoder/example regressions. |
| Parent default build | PASS: `lake build`, 2762 jobs, 8.003 seconds. |
| Parent public trust/API audit | PASS: all 38 signatures and axiom prints plus two representative proof prints, through the root alone, one worker, 221.257 seconds. Only `propext`, `Classical.choice` and `Quot.sound`. |
| Parent import-header audit | PASS: 2745 resolved modules plus 185 unexpanded standard runtime frontier entries; no nonstandard missing imports or optional-boundary violations. Historical comparison with the S05 preintegration root still adds only Binary and no LeanInfoTheory/foundational modules. S07 itself changes no root/import/Lean bytes relative to S06 F. Existing semantic KL imports are not claimed absent. |
| Parent source references | PASS: eight pinned supplemental identities and both exact manuscript hashes freshly authenticated; ISIT p.2 and extended v16 pp.12-14 freshly extracted, rendered and visually read. Source meaning agrees with the finite-information, active-output, null-fiber and support-qualified contracts already documented above. Adjacent extended-only material remains outside scope. |

These are fresh incremental builds and bounded source/header/public-API checks,
not clean builds or a universal dependency trust audit. Successful long-running
checks are counted only after actual exit zero. Historical failed attempts
remain separate and never support acceptance. The original S07 review and its explicit reconciliation are recorded below.
Final source/validation checks and durable completion follow the execution record.

### Original independent S07 review and critical reconciliation

The bound reviewer freshly assessed R `32740fddc06d0897bdf83920c04180659b615e6fd91027d325d1e41c1c733964`.
The complete original native report was preserved before classification,
captured as `c21b4826ef9375f692afc18a4366f5cfbb75b32e2311c6182968a8f705e33318`; original payload SHA-256 is
`69e3d5a59644591b1b412b906b9543e101d98863833c3d84a9c3b6049e548769`.
It was accepted as valid and explicitly reconciled. All three S07 criteria,
eighteen earlier criteria, R01-R18 and ten completion outcomes are satisfied;
the independent report contains no findings. Its seventeen PASS evidence
objects and one FAIL remain separate. The original assessments below apply
to R, with subsequent applicability established by final source comparison.

The reviewer freshly read complete Binary production/regression/root source,
traced the needed C01-C04 and pinned dependencies, authenticated and visually
inspected the manuscript anchors, and matched all 101 real inventory files.
The twelve-target and default builds passed 2777/2762 jobs. All 38 public
signatures/axioms and two proof prints passed, plus two independent root-only
consumers: finite-attainer domination and a common-source strict gap. That
audit completed in 211.83 seconds with only the standard three axioms.
The 267 source links, exact declaration ownership, bounded import graph,
pins, placeholders, artifacts and all 67 omission entries were checked.

The first UTF-8 reporting-helper attempt failed during output decoding;
its remaining postprocessing did not execute. The surrounding shell's later
zero exit does not turn it into a passing attempt. The corrected helper
explicitly used UTF-8 and passed; every actual S07 compiler invocation passed.
The original failure is retained as `reviewer:c05-s07-helper-failure` and is
not cited as support by any satisfied criterion. Checks remain incremental,
with existing compiled prerequisites and an unexpanded standard import
frontier. Private prerequisite/B/F history and effective reviewer settings
were not authenticated by the reviewer; parent startup verification owns the
former, and effective model/history isolation remain unknown.

Parent reconciliation accepts the mathematical conclusions on the actual
noncircular proof chain, hypotheses, concrete consumers and fresh compiler
evidence. It accepts the validation conclusions with these limits, and the
report-completeness criterion as adequate for subsequent reconciliation,
without claiming the reviewer certified its own later F or closure.

Reconciliation corrects short source citations without editing the original
report. In particular, R09's original `Tests/Binary:544/554` citation points
to aggregation/R10 context; its actual zero-weight examples are
[Tests/Binary:524](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L524)
and [Tests/Binary:528](../PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean#L528).
The following mapping also refines coarse companion citations for R05-R10
and R15. Those examples were already in the freshly read and compiled test
file and in the correct earlier readiness mapping. This is a documentary
citation correction, with no mathematical criterion gap, altered hypothesis
or material invalidation requiring another independent review.

Each table below records the original status and source-based assessment,
with those parent citation refinements. Parenthetical short evidence names
expand to `reviewer:c05-s07-<name>` in the preserved original report.

#### Fresh assessments of earlier criteria

| Criterion | Independent assessment | Source and evidence |
| --- | --- | --- |
| C05-S01-C01 | SATISFIED | Binary:52-100 proves inverse law maps, all four coordinate marginals and both coupling/canonicality directions; R01 freshly builds (laws-singularity, focused-build). |
| C05-S01-C02 | SATISFIED | Binary:103-161 proves full evaluation/pair laws for every prior and enumeration-invariant C04 TV; R02/R03 cover point priors and orientation (laws-singularity, regression-source). |
| C05-S01-C03 | SATISFIED | Current R01-R03, 12 S01 public declarations within the complete 38, focused imports and source maps pass fresh cumulative checks (focused-build, public-audit, inventory-imports, documentation). |
| C05-S02-C01 | SATISFIED | Binary:180-354 supplies the singular atom bridge and one all-row posterior with actual null fallback; R04-R06 cover multiatom exclusive fibers and endpoints (laws-singularity, regression-table). |
| C05-S02-C02 | SATISFIED | Binary:364/384 transports input cardinality two and combines C03 necessity/active-output sufficiency; direct printed-two-output consumer is present, without a prior (laws-singularity, regression-table). |
| C05-S02-C03 | SATISFIED | R04-R07 and separate C03 semantic/counterexample consumers build; public/private ownership and documented source departures match current code (focused-build, inventory-imports, documentation). |
| C05-S03-C01 | SATISFIED | Binary:432-506 proves the positive conditional law, constant/injective entropy branches and zero-weight null treatment for arbitrary p/q (entropy-optimum, regression-table). |
| C05-S03-C02 | SATISFIED | Binary:509-539 transports the full canonical triple law and derives actual MI in pinned nats on unrestricted sources (entropy-optimum, pinned). |
| C05-S03-C03 | SATISFIED | R08-R10 compile; local entropy helpers remain private and use pinned generic results; no optional decoder import appears (focused-build, inventory-imports, pinned). |
| C05-S04-C01 | SATISFIED | Binary:545-600 bounds every finite original auxiliary; full-support canonicalization and pure-prior branch avoid identifying unseen rows (entropy-optimum, regression-table). |
| C05-S04-C02 | SATISFIED | Binary:604-640 gives the specified finite canonical triple, exact pair marginal and actual objective; bound plus witness is the maximum (entropy-optimum, public-audit). |
| C05-S04-C03 | SATISFIED | R11-R13 and independent domination consumer compile, including the actual unseen-row witness, singleton outputs and higher-universe auxiliary (focused-build, public-audit, regression-table). |
| C05-S05-C01 | SATISFIED | Binary:673-721 proves all-prior inequality/forward equality and full-input-support iff through finite attaining perfectness, noncircularly (equality-transport). |
| C05-S05-C02 | SATISFIED | Binary:724-956 gives exact enumeration/prior/pair/vector transport and all semantic quantitative wrappers with independent universes and unrestricted source (equality-transport, public-audit). |
| C05-S05-C03 | SATISFIED | R14-R17 compile, including mandatory nonsingular degenerate equality and actual mapped-attainer information; hypothesis and public API audits pass (regression-table, focused-build, public-audit). |
| C05-S06-C01 | SATISFIED | Root exposes Binary and four R18 consumers; one finite canonical witness dominates all original finite auxiliaries; optional imports remain separate (focused-build, public-audit, inventory-imports). |
| C05-S06-C02 | SATISFIED | Current source/evidence maps account for all earlier criteria, R01-R18, ten outcomes, 38 public declarations and preserved omissions; freshly checked individually here (documentation, inventory-imports, outcome-table). |
| C05-S06-C03 | SATISFIED | Current readiness/status distinguishes S07 activity from pending closure; fresh default build and source/diff/artifact checks establish applicable cumulative readiness (default-build, documentation, integrity). |

#### Fresh regression assessments

| Regression | Independent assessment | Source and evidence after citation reconciliation |
| --- | --- | --- |
| R01 | SATISFIED | Tests/Binary:39-122 proves both round trips, four marginals and swap with nonsymmetric masses 1/3 at (0,1), 2/3 at (1,0) (regression-source, focused-build). |
| R02 | SATISFIED | Tests/Binary:126-145/194 checks exact channel pair atoms under a nonuniform supported prior and both point priors; a supplied PMF rules out Empty outputs (regression-source, focused-build). |
| R03 | SATISFIED | Tests/Binary:158-199 checks half-L1/overlap normalization, row swap, Bool/different enumeration and impossibility of an empty cardinality-two input (regression-source, focused-build). |
| R04 | SATISFIED | Fin 5 rows [1/2,1/2,0,0,0] and [1/2,0,1/4,1/4,0] yield actual common factorization and two distinct positive posterior atoms at the exclusive output (Tests/Binary:241-333; regression-source, focused-build). |
| R05 | SATISFIED | Tests/Binary:305/308/335/343 consumes C04 identical-row diagonal and zero-overlap independent-product endpoints; singular/perfect semantic consumers retain them (regression-source, focused-build). |
| R06 | SATISFIED | Tests/Binary:298/315/325 checks globally unused label 4, actual vector-law null fallback and singleton-output perfectness, without an ambient positive-output assumption (regression-source, focused-build). |
| R07 | SATISFIED | Tests/Binary:360/388/413/418 consumes input-cardinality and active-output branches, generic necessity and printed Fin 3-to-Bool output specialization; separate C03 counterexample builds (laws-singularity, focused-build). |
| R08 | SATISFIED | Tests/Binary:482/487/493/500/508/514 checks actual positive equal/distinct fibers, pure/evaluation posterior laws and entropy under nonuniform input (regression-source, focused-build). |
| R09 | SATISFIED | Tests/Binary:524/528 proves zero vector weight annihilates arbitrary scalar contribution and the actual conditional-entropy term (regression-source, focused-build). |
| R10 | SATISFIED | Tests/Binary:544/548/555/560/567/575/581 covers arbitrary q with both point priors, half-mismatch aggregation and full-law entropy/MI transport on unrestricted Nat/higher-universe sources (regression-source, focused-build). |
| R11 | SATISFIED | Tests/Binary:602/618 consumes C02's information preservation for arbitrary support-correct decoder and finite original Z before the universal bound (entropy-optimum, focused-build). |
| R12 | SATISFIED | Tests/Binary:654/680/688 checks nonsingular intermediate-TV channel, nonuniform full-support prior, exact pair and specified maximal canonical information attainment (regression-source, focused-build). |
| R13 | SATISFIED | Tests/Binary:749-814 constructs an actual support-correct FR on arbitrary Nat law with higher-universe finite auxiliary, exact pair and unseen-row discrepancy; both point-prior attainers and singleton output also pass (regression-source, focused-build). |
| R14 | SATISFIED | Tests/Binary:829/843 checks full-support singular equality and nonsingular strict inequality via the established inequality/iff; forward equality also permits every prior (equality-transport, focused-build). |
| R15 | SATISFIED | Tests/Binary:880/888 proves the required pure-0 prior/fair row-0/pure row-1 ambient channel is nonsingular although H(X)=I(X;Y)=0 and equality holds (regression-source, focused-build). |
| R16 | SATISFIED | Tests/Binary:939/962 and generic consumers check Bool prior transport, explicit support transport, inverse-coordinate attaining law and independent-universe cardinality-two interfaces (equality-transport, public-audit, focused-build). |
| R17 | SATISFIED | Tests/Binary:1058-1167 checks common injection with unused output, the actual mapped canonical triple, its exact pair and information, mapped channel equality/inequality, and PMFs supplied on a common subtype (regression-source, focused-build). |
| R18 | SATISFIED | Tests/Semantics/BinaryRoot imports only the root and checks combined/printed Lemma 2, actual finite canonical maximizer dominating every original finite auxiliary, and common-base inequality/forward/qualified iff (focused-build, public-audit, inventory-imports). |

#### Fresh completion-outcome assessments

| Outcome | Independent assessment | Source and evidence |
| --- | --- | --- |
| C05-CC01 | SATISFIED | Authenticated exact manuscript anchors and documented support, finite-information, null, coordinate and attainment interpretations agree with source (manuscripts, documentation, laws-singularity, entropy-optimum, equality-transport). |
| C05-CC02 | SATISFIED | Inverse product/vector and full evaluation laws, exact pair and enumeration-independent r reuse C04 half-L1/overlap normalization (laws-singularity, regression-table R01-R03). |
| C05-CC03 | SATISFIED | Prior-free all-input singular factorization, cardinality-two transport and combined Lemma 2 reuse C03 necessity/output clauses (laws-singularity, regression-table R04-R07). |
| C05-CC04 | SATISFIED | Weighted conditional entropy and actual MI identities hold for arbitrary binary p/q with correct positive/null fibers (entropy-optimum, regression-table R08-R10). |
| C05-CC05 | SATISFIED | Universal bound covers every finite original auxiliary, unrestricted source and every prior, with a valid degenerate branch (entropy-optimum, equality-transport, public-audit). |
| C05-CC06 | SATISFIED | Specified maximal finite canonical law and its semantic transport have exact pair and actual information attainment; root consumer composes domination (entropy-optimum, equality-transport, public-audit). |
| C05-CC07 | SATISFIED | Noncircular all-prior inequality/forward equality and explicit-full-support ambient iff, plus R15 negative guard and input/output transport, are established (equality-transport, regression-table R14-R17). |
| C05-CC08 | SATISFIED | All R01-R18 and empty/singleton/support/universe consumers pass; all 38 public signatures and axiom dependencies were freshly audited (focused-build, public-audit, regression-table). |
| C05-CC09 | SATISFIED | Required twelve-target/default builds pass; optional decoder boundary holds; placeholder scan is empty and public trust uses only standard axioms (focused-build, default-build, public-audit, inventory-imports, integrity). |
| C05-CC10 | SATISFIED | Current owning records/maps describe cumulative readiness and pending closure accurately, preserve all 67 omissions and prerequisite ownership, and distinguish historical/parent evidence from this fresh assessment (documentation, identity, integrity). |

#### S07 criteria and subsequent duties

| Criterion | Independent result | Parent reconciliation |
| --- | --- | --- |
| C05-S07-C01 | SATISFIED | Accept: all required mathematics, eighteen prior criteria and regressions are individually source-backed; finite information and explicit converse support match the manuscripts and noncircular Lean chain. |
| C05-S07-C02 | SATISFIED | Accept: current independent builds, 38-public audit, imports, identity/coverage and integrity checks establish CC08-CC10 with incremental/private-provenance limits retained. |
| C05-S07-C03 | SATISFIED | Accept: complete original report and all per-ID tables provide evidence, limitations and negative-attempt provenance for reconciliation. Corrected short citations do not conceal a mathematical gap. Later F/closure are not reviewer predictions. |

After this reconciliation, only the nine owning Markdown records change.
All reviewed Lean, root imports, pins, normative plan and omissions remain
preserved. Final cumulative/default builds and exact B/R source-impact checks
must establish current applicability before F and supported durable closure.
C06 remains mapped and requires its own approved plan and implementation request.

Final post-reconciliation cumulative/default builds pass (2777/2762 jobs,
9.789/8.221 seconds). Exact B/R source, placeholder, whitespace, local-link
and tracked-artifact checks pass. R-to-final changes remain confined to nine
Markdown records; all 92 other reviewed real files, eight pinned supplements
and normative plan bytes are unchanged. The fresh original independent review
and public trust/import checks retain applicability. Final source assertions
are refreshed after this evidence note, before F and durable closure. Included
documents are not edited after F; a subsequent task may normalize their status
from the supported record. No later chunk work is included.
