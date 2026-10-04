# PFR-C16 — Boundary, trust, API and import readiness audit

## Scope and current checkpoint

**Current, 2026-10-03:** C01–C15 and C16 S01–S04 are durably complete.
C16 S05 fresh cumulative validation and independent review are complete; all
three criteria are satisfied after the bounded documentation correction. Both
original reports are reconciled. This is the provisional final checkpoint:
supported durable S05 closure establishes CC09 and C16 completion.
The [S05 cumulative readiness matrix](#c16-s05-readiness) reassesses every earlier
criterion, boundary and CC01–CC08 to source and evidence. Its final supported
closure record establishes CC09.
The [implementation notes](pfr-c16-implementation-notes.md) own actual checks and
review history; the [coverage ledger](pfr-c16-coverage-audit.md) owns source alignment.

The S02–S04 bodies below preserve their reviewed text and historical checkpoints.
The appended S05 assessment supplies current evidence with separate attribution.
No Lean/API/import/dependency changed. All 71 omission rows remain unchanged;
S05 corrects one companion page locator with its original reference preserved.

## Boundary evidence

E11 supplies semantic checks and a fresh 74-name signature probe. E12 supplies
matrix/LP source and regression inspection. Both distinguish fresh reads from
S01 readings reused only after exact hash comparison. E13 audits every compiled
owner's elaborated type and transitive axioms; E14 supplies the original module
builds. Consequently a fixture below is supported by its actual assertion,
original maintained build, and, for erased anonymous commands, the separately
attributed E13 transparent-copy elaboration. The detailed source owners below
remain the canonical mathematical references.

For B06, the approved denominator check means that cancellation and normalization
must be justified. `ENNReal` division is total: the maximal coupling formula
contains a zero denominator when overlap is one, and the proof explicitly shows
the corresponding residual is zero. Its equal-law regression verifies the
diagonal law and zero mismatch. This is the existing approved endpoint behavior;
the audit does not claim that no totalized zero-denominator expression occurs.


### Evidence provenance

- **Semantic source/signature evidence:** actor `/root/c16_prerequisite_check`, local date 2026-10-03 (Europe/Zurich); evidence generated 2026-10-02T23:15:11.613298+00:00. Fresh types, proof portions and maintained assertions are recorded in `tmp/c16-s02/semantic-helper/inspection-log.jsonl` and `evidence.json`. S01 proof regions explicitly marked inherited below retain their original inspection scope; a fresh comparison matched all 15 earlier source hashes. That comparison does not turn the earlier bounded reads into fresh whole-file inspection.
- **Matrix/LP source evidence:** actor `/root/c16_api_planning`, local date 2026-10-03; fragment written 2026-10-02T23:13:45.136Z. `tmp/c16-s02/matrix-helper/command-results.json` preserves receipts M00–M26. Freshly read proof/fixture ranges are distinguished below from exact-hash inherited S01 ranges. M21 is the fresh hash comparison for all 13 retained S01 matrix snapshots. `source-identities.json` and `evidence.json` record 32 source snapshots and their unchanged recheck at 2026-10-02T23:14:40.287060+00:00.
- **Compiler evidence has a separate owner:** the semantic original-module 74-name lookup receipt is `tmp/c16-s02/semantic-helper/signature-receipt.json` (2026-10-02T23:11:10.079548+00:00–23:11:41.718718+00:00, exit status 0), with source/`.olean`/`.ilean` and configuration identities before/after. Full module/root/default build receipts are `tmp/c16-s02/build-receipts.json`. The matrix helper ran no compiler; its existing artifact hashes are observations, not freshness certification.
- **Limits retained:** the signature printer shows all 74 headers and external hypotheses but suppresses one proof-valued argument as `w ⋯`; the explicit `hw : q w ≠ 0` and original `Binary.lean:432–440` conditioning proof were inspected. The original unsupported `pp.width` attempt is retained as failed-formatting evidence, separate from the successful lookup. Matrix receipts M00 and M04 include unsuccessful wildcard/missing-path discovery (exit 1); later correct-path reads supply the cited evidence.
- **Scope:** this section assembles existing source/signature/assertion evidence. S01 manuscript coverage and exact anchors are inherited. It does not repeat manuscript inspection or report a transitive-axiom inventory, trust determination or review decision. Private names are source locators; anonymous assertions remain anonymous.

All source paths are repository-relative. `Matrix/…`, `Optimization/…` and `Tests/…` abbreviate paths below `PerfectFunctionalRepresentations/`. Line ranges are inclusive human one-based locators; preserved commands retain their actual zero-based PowerShell slice syntax when used.

### Boundary index

| Boundary | Contracts and evidence |
| --- | --- |
| [C16-B01](#c16-b01) | Independent universes, unrestricted source, full triple pushforward and fixed versus existential witnesses. |
| [C16-B02](#c16-b02) | Support-only decoding, one all-row posterior, all-prior forward results and full-support converses. |
| [C16-B03](#c16-b03) | Pinned fallback, weighted null entropy, complete posterior preservation and unused-output counterexamples. |
| [C16-B04](#c16-b04) | Raw/semantic/active alphabets, actual empty/singleton paths, empty admissible families and LP images. |
| [C16-B05](#c16-b05) | Active restriction, injective extension, dependent compressed-data round trips and retained ambient recovery. |
| [C16-B06](#c16-b06) | Finite masses, total division at zero, positive admitted ratios, exact aggregates and per-input row sums. |
| [C16-B07](#c16-b07) | Strict PPS, legal value-one VPS, all merge indices, directed inverses, typed paths and structural normalization. |
| [C16-B08](#c16-b08) | Input/output orientation, independent noninvolutive row/column maps, arbitrary-vector inverses and whole objective images. |
| [C16-B09](#c16-b09) | Both index restrictions, nonnegative feasibility, exact occurring count, mixed-system and signed controls. |
| [C16-B10](#c16-b10) | Distinct predicates, attained extrema, empty constraints, signed rejection and positive correction scale. |
| [C16-B11](#c16-b11) | Nonempty exact blocks, active auxiliary labels, actual multiway paths and retained intermediate/final endpoints. |

### Source file keys

- `FR`: `PerfectFunctionalRepresentations/Semantics/FunctionalRepresentation.lean`
- `CAN`: `PerfectFunctionalRepresentations/Semantics/Canonical.lean`
- `SING`: `PerfectFunctionalRepresentations/Semantics/Singularity.lean`
- `BIN`: `PerfectFunctionalRepresentations/Semantics/Binary.lean`
- `TV`: `PerfectFunctionalRepresentations/Probability/FiniteCoupling.lean`
- `RAW`: `PerfectFunctionalRepresentations/Matrix/Channel.lean`
- `TFR`: `PerfectFunctionalRepresentations/Tests/Semantics/FunctionalRepresentation.lean`
- `TCAN`: `PerfectFunctionalRepresentations/Tests/Semantics/Canonical.lean`
- `TSING`: `PerfectFunctionalRepresentations/Tests/Semantics/Singularity.lean`
- `TBIN`: `PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean`
- `TTV`: `PerfectFunctionalRepresentations/Tests/Probability/FiniteCoupling.lean`
- `TEX`: `PerfectFunctionalRepresentations/Tests/Examples/Nonrepresentable3x3.lean`
- `TRAW`: `PerfectFunctionalRepresentations/Tests/Matrix/Channel.lean`
- `PINNED-MARKOV`: `.lake/packages/LeanInfoTheory/LeanInfoTheory/Shannon/SemanticBridge/Markov.lean`

<a id="c16-b01"></a>

### C16-B01 — Structural and finite information contracts

<a id="b01-structural"></a>

#### B01-STRUCTURAL

- **Type/assumptions:** FR has independent universe parameters for source and all values. IsFunctionalRepresentation(q:PMF(alpha×beta×gamma)) has no finiteness or Nonempty class: first/third independence AND a decoder alpha×gamma→beta correct on q.support. The Of wrapper is the full triple pushforward. Products are right-associated, Y=t.2.1 and Z=t.2.2. Canonical structural form likewise requires independence AND Y=W X on support; marginal-only coupling is a separate predicate.
- **Actual source/proof:** FR:30-110 (definitions, support-map proof both directions, full-law transport); CAN:21-69,137; actual exported signatures in the semantic 74-name signature receipt.
- **Maintained assertions checked:** TFR:21-41 typeclass-free introduction/elimination with four universes; :188-218 independent-source-universe transport; :247-320 postprocessing loses decoding despite independence and equal pairwise laws do not determine triple decoding. TCAN:23-75 checks canonical full-law reconstruction/transport; :128-177 independent vector + correct marginals + exact pair yet supported evaluation failure and mismatch 1/2.
- **Inapplicable cases/limits:** An empty source or any empty coordinate cannot inhabit the relevant PMF/full triple; this is impossibility, not an inhabited successful fixture. See B04. Independence or matching only pairwise laws never substitutes for the decoder/full triple premise.

<a id="b01-finite-info"></a>

#### B01-FINITE-INFO

- **Type/assumptions:** FR Eq1/information/perfectness requires [Fintype alpha] [Fintype beta] [Fintype gamma], with no Fintype/Finite omega. Decoder canonical information theorem uses [Finite alpha] [Fintype beta] [Fintype gamma] [Fintype(alpha→beta)]. Structural canonicalization has no such classes, and admits an infinite original auxiliary.
- **Actual source/proof:** FR:118-127,231-293; CAN:198-209,280-318. B01 source proof connection retains both semantic zero bridges and finite canonical information preservation, inherited S01 proof regions with exact hash match plus fresh type lookup.
- **Maintained assertions checked:** TFR:327-333,383-421,431-451 tests independent universes, Nat source and differently typed values fixing argument order. TCAN:253-332 demonstrates ULift Nat structural auxiliary and nonconstant Nat values; :427-501 finite information on arbitrary source with Type1 auxiliary; :525-561 null-source support and canonical perfectness. TBIN:554-587 source Type(s+1), Nat and ULift values; :894-916 four independent universes for general two-input bounds/equality.
- **Inapplicable cases/limits:** No information equality over an infinite original auxiliary. Inapplicability is deliberate finite-information scope OM-053, not a missing generic information theorem. Structural infinite auxiliary remains supported.

<a id="b01-fixed-existential"></a>

#### B01-FIXED-EXISTENTIAL

- **Type/assumptions:** Fixed perfectness includes structural FR plus MI=conditional entropy for that specified Z. Pair perfectness for finite alpha,beta is ∃n,∃q:PMF(alpha×beta×Fin n), exact pair marginal AND fixed perfectness. The original omega is unrestricted and need not carry the attaining Z. Any finite auxiliary universe is recoded by Fintype.equivFin and the inverse decoder.
- **Actual source/proof:** FR:314-407 checks existential type, pair-law transport and full decoder/info recoding proof. CAN:358 pair/canonical law iff. BIN:567-638 universal arbitrary-source finite-Z bound and specified actual canonical law with pair/structural equality; no maximizer assumption.
- **Maintained assertions checked:** TFR:503-561 fixed versus pair/transport signatures; :609-638 XOR specified auxiliary functional but nonperfect (no pair nonrepresentability asserted); :640-679 Unit/Nat pair transport, separate finite law and ULift auxiliary; :682-685 rules out n=0. TCAN:550-561 both canonical-sufficiency directions preserve finite law. TBIN:617-630 combines actual finite attaining triple with comparison against any supplied original finite auxiliary.
- **Inapplicable cases/limits:** No same-original-source optimizer, supremum over auxiliary types, infinite-information theorem, witness uniqueness or minimum auxiliary cardinality. Fin0 is excluded by actual PMF support, not an extra public premise.

<a id="c16-b02"></a>

### C16-B02 — Support, common posteriors and prior dependence

<a id="b02-decoder"></a>

#### B02-DECODER

- **Type/assumptions:** Decoder equality is only on PMF support; Eq1 yields some correct decoder, not any preselected decoder. Canonicality still refers to actual specified Y and the entire vector law.
- **Actual source/proof:** FR:54-82 and :118-127; CAN:33-69,198-249; exact source proof maps support witnesses in both directions.
- **Maintained assertions checked:** TFR:44-83 null atom decoder failure; :85-117 arbitrary unrealized (X,Z) decoder values; :120-179 supported collisions/dependent X,Z failures; :340-381 information-zero conditions coexist with a bad preselected decoder at positive mass. TCAN:233-243 canonical null-point failure; :364-417 decoder completions agree on supported input yet differ in unused coordinate, entire vector law and all-row coupling.
- **Inapplicable cases/limits:** Off-support decoder values are intentionally unconstrained. An equality only of coordinate marginals is insufficient, as B01-STRUCTURAL guard proves.

<a id="b02-one-posterior"></a>

#### B02-ONE-POSTERIOR

- **Type/assumptions:** IsPerfectlyRepresentableChannel kappa requires [Nonempty alpha] and ∃one q,∃one V:beta→PMF(alpha→beta),∀a coordinate/vector joint = channelJoint(kappa a,V). No prior, finite alphabet or full-output-support premise in the structural definition. Factorization implies coupling by first projection. Finite perfect canonical joints use the same q for every prior.
- **Actual source/proof:** CAN:402-415,431-475,532-602; fixed-posterior equality initially only ∀a∈p.support, upgraded by explicit full input support; fixed-q Markov converse additionally [Finite(alpha→beta)] and coupling.
- **Maintained assertions checked:** TCAN:565-608 full actual quantifiers/types; :620-636 point-prior fixed-V equality does not control null row; :699-709 same fixed coupling perfect for point prior, no all-row common posterior, and fails Markov for fair prior; :747-788 q chosen before every p, and every-prior/some-full-support-prior iff. :817-835 distinct full-support priors and all-prior forward including a zero input.
- **Inapplicable cases/limits:** Do not move ∃q or ∃V inside ∀input row, or replace full-input-support converse with arbitrary ambient prior. Fresh joints reuse a law, not an already-fixed random variable on arbitrary new source variables.

<a id="b02-support-restriction"></a>

#### B02-SUPPORT-RESTRICTION

- **Type/assumptions:** For arbitrary p on finite alpha and finite beta, perfectness of channelJoint p kappa iff intrinsic perfectness on p.support. The support prior and exact pair inclusion itself require no finite alphabet. Support nonemptiness is derived from p; retraction completion is internal and only alters points of mass0.
- **Actual source/proof:** CAN:648-691,808-833; full dependent embedding proof :695-803 inherited from S01 exact source. SING:242-254 requires full input support when identifying pair-output support with union of all rows.
- **Maintained assertions checked:** TCAN:865-891 exact support normalization, pair inclusion and both finite-witness directions; :914-950 proper two-point support and unused ambient row modification, singleton support and globally unused output. TSING:288-367 actual support formula, point-prior loss of true output, full-support equality and restricted active union. TEX:34-60 full-support/uniform negative Example1 pairs versus positive witnesses at every point prior.
- **Inapplicable cases/limits:** A prior cannot determine unseen rows. For an empty source/support, no PMF exists; no caller-chosen default output is introduced.

<a id="b02-binary-converse"></a>

#### B02-BINARY-CONVERSE

- **Type/assumptions:** Universal finite-Z binary information bound and actual attaining canonical triple allow every input prior. I(X;Y)≤TV·H(X), and singular→equality, also allow every prior. Equality→ambient singularity requires ∀x,x∈p.support. Intrinsic arbitrary input type is connected by an actual alpha≃Fin2.
- **Actual source/proof:** BIN:545-598 branches on full support; point branch proves prior is pure and H=0, uses MI≤H(Y) without all-row decoder recovery. :604-638 actual finite attainment; :673-717 equality proof; :776-956 actual common-base/enumeration signatures.
- **Maintained assertions checked:** TBIN:749-772 keeps actual FR/pair, wrong unseen decoder coordinate and valid bound together, with ambient TV1 versus decoder mismatch0. :775-800 both point priors and singleton output actual attainment. :843-889 full-support nonsingular strictness and nonsingular point-prior equality with H=MI=0, TV1/2. :894-916 retains all support/universe premises in common-base consumer.
- **Inapplicable cases/limits:** The pure-prior equality guard disproves the unsupported ambient converse. Larger ambient inputs with support-cardinality2 are not a new promised theorem family (OM-063).

<a id="c16-b03"></a>

### C16-B03 — Null fibers and total posterior conventions

<a id="b03-sem-null"></a>

#### B03-SEM-NULL

- **Type/assumptions:** Pinned condFstGivenSndChannel for q:PMF(alpha×beta), [Fintype alpha], is canonical conditional PMF only when snd marginal is nonzero; at a null fiber it equals fstMarginal q. No extra default or Nonempty alpha premise. Multiplication by conditioning mass reconstructs actual joint including nulls.
- **Actual source/proof:** PINNED-MARKOV:210-259; BIN:313-358 constructs one row-independent posterior and proves both-zero output fallback equals actual maximal vector law, via pinned null-channel theorem.
- **Maintained assertions checked:** TBIN:297-332 output4 absent in both Fin5 rows; production exists_binary_maximal_commonPosterior witness satisfies V4=actual vectorLaw and another posterior fiber has two distinct positive atoms. Structural fallback is checked on the actual supplied production witness, not an invented completion.
- **Inapplicable cases/limits:** Null conditional law has no pointwise conditional semantics. A selected fallback is a valid implementation convention, not uniqueness of all permissible posterior completions.
- **Cross-link:** C09 complete posterior preservation and C11 adversarial unused-output/full witness recovery are recorded in [C16-B03-MATRIX](#c16-b03-matrix).

<a id="b03-sem-weight"></a>

#### B03-SEM-WEIGHT

- **Type/assumptions:** Binary positive-vector fiber law requires q(w)≠0, with finite output and arbitrary prior. It cancels q(w) only with this premise and PMF.apply_ne_top. The weighted entropy equality is total: zero vectors contribute0; positive vector evaluation has entropy0 if constant and H(p) if injective.
- **Actual source/proof:** BIN:432-505 actual positive conditional proof, private entropy_binaryEvaluation and weighted_fiber null/non-null split. :518-536 transports full joint back to arbitrary source. No coupling or full-support premise on raw entropy identity.
- **Maintained assertions checked:** TBIN:482-519 computes constant positive fiber and unequal positive fiber with reversed 2/3,1/3 masses; :524-530 an arbitrary Real fiber value and pinned conditional entropy both vanish at null unequal w01; :533-552 exact mismatch1/2 aggregate; :555-564 every point prior. TFR:460-492 all Eq3 consequences at null Y fiber with off-support decoder failure.
- **Inapplicable cases/limits:** Do not assert H(Y|W=w)=H(X) for arbitrary null conditional completions. Only weighted identity is claimed there.

<a id="b03-sem-posterior"></a>

#### B03-SEM-POSTERIOR

- **Type/assumptions:** Changing V only outside the union of all channel row supports preserves every coordinate/vector factorization; no finiteness classes or nonempty output required. Posterior-support decoder lemma requires an active row mass kappa x y≠0 as well as w∈support(V y).
- **Actual source/proof:** CAN:479-487 coordinateFactorization_congr_posterior; SING:37-51 coordinate_eq_of_posterior_support retains both premises. Extension recovery maps both output/vector components.
- **Maintained assertions checked:** TCAN:724-744 explicitly has V≠Vprime, globally null output true, and both all-row factorizations. TSING:203-220 permits any PMF at new none output, even vectors outside image; :518-523 actual support helper preserves active premise. TCAN:852-860 pair boundary still permits unused output for every prior.
- **Inapplicable cases/limits:** No posterior uniqueness at globally unused labels and no forced inclusion of arbitrary null posterior atoms in q.support/image.
- **Cross-link:** C09 complete posterior preservation and C11 adversarial unused-output/full witness recovery are recorded in [C16-B03-MATRIX](#c16-b03-matrix).

<a id="c16-b03-matrix"></a>

#### C16-B03-MATRIX — Total posteriors, null rows and unused outputs

**Hypotheses:** C09 operation preservation is for singular ActiveFiniteChannel states on finite nonempty input, with a common total posterior and full auxiliary joint factorization. C11 ambient unused outputs remain outside the active subtype. No claim identifies a posterior uniquely where its channel multiplier is zero.

**Production proof connections**

- Matrix/Preservation.lean:1–222,435–581,885–943,1186–1250 (S01 unchanged source, exact inherited ranges) constructs transformed common posteriors and proves full auxiliary-channel factorization; these equalities feed the public operation preservation theorems. Matrix/Operations.lean:857–925 proves the PPM recovery ratio uses positive admitted column values and a finite positive denominator, including when a particular input row is null.
- Matrix/CanonicalReachability.lean:1–557,575–725 (S01 unchanged) restricts posterior labels using active output and positive posterior/vector support before constructing originalPps; public isPerfectlyRepresentable_iff_toAllOnes/fromAllOnes at2466/2481 package actual bridges.

**Maintained assertions inspected**

- Matrix/Preservation.lean:769–853 private r05 fixture has a null merged input row, two posterior vectors of weights1/3 and2/3, positive denominator, strict ratio, and zero full joint atoms at the null row. Its actual ppm_factorization supplies all-prior canonical-law/perfectness consumers. :992–1052 private r08 has a value-one VPS with pure full-vector posteriors, zero null-child joint atoms and the actual vps_factorization.
- Tests/Matrix/CanonicalReachability.lean:30–155,220–240 UnusedOutput fixture has kappa x2=0, q=pure w, V2=pure nullVector, q nullVector=0, and V2 nullVector=1. It proves all-atom factorization and explicitly refutes the unguarded implication Vyf>0→qf>0. Both active enumerations recover output2 with mass0, and the public ToAllOnes/FromAllOnes endpoints are consumed.

**Inapplicable cases and limits:** No posterior uniqueness on unused outputs, no conclusion from posterior positivity without active-output support. B03-SEM-WEIGHT and B03-SEM-NULL above record conditional-entropy weighting and pinned fallback conventions.

**Cross-links:** [B03-SEM-NULL](#b03-sem-null), [B03-SEM-WEIGHT](#b03-sem-weight), [B03-SEM-POSTERIOR](#b03-sem-posterior). **S01 crosswalk references:** `C16-LEM04`, `C16-LEM05`, `C16-LEM06`, `C16-THM01`. **Matrix receipts:** `M11`, `M24`, `M21`.


<a id="c16-b04"></a>

### C16-B04 — Empty and singleton carriers

<a id="b04-sem-empty"></a>

#### B04-SEM-EMPTY

- **Type/assumptions:** No PMF on empty source or empty component of pair/triple; pair Fin0 auxiliary impossible. A function alpha→PMF beta can be vacuous if alpha empty (even beta empty), and singularity is then vacuous. Intrinsic perfect channel explicitly requires Nonempty alpha, so no witness for empty alpha. A supplied row with nonempty alpha forces beta nonempty.
- **Actual source/proof:** CAN:402 Nonempty input definition, SING:18 unrestricted singularity and :207 support nonemptiness; actual source proofs use support_nonempty, never fabricated PMFs.
- **Maintained assertions checked:** TCAN:955-995 six explicit empty source/input/output/predicate/row/channel assertions. TFR:682-685 impossible Fin0 extension. TSING:47-55 empty-input singularity plus impossible intrinsic nonempty witness; :257-265 empty active union/empty PMF; TBIN:194-199 nonempty binary row into Empty impossible, Empty input card≠2. TTV:115-118 and :298-300 empty coupling source impossible.
- **Inapplicable cases/limits:** Vacuous raw channel is admissible; an inhabited empty PMF is not. Negative cases are documented impossibility or deliberate elaboration rejection, never counted as successful inhabited examples.

<a id="b04-raw-empty"></a>

#### B04-RAW-EMPTY

- **Type/assumptions:** massMatrix/realMatrix accepts arbitrary alpha,beta; reconstruction requires finite beta and row normalization (Real also nonnegative). Empty input has no rows, so 0×0 satisfies the quantified premises. Nonempty input with empty output cannot have a normalized row/channel.
- **Actual source/proof:** RAW:35-89 exact matrix round trips; :94-169 Real conversion/recovery; no hidden Nonempty alpha in raw interfaces.
- **Maintained assertions checked:** TRAW:99-105 exact emptyChannel/0×0 reconstruction; :107-115 excludes Unit→PMF Fin0 and normalized Unit×Fin0 mass matrix; :179-183 Real 0×0 and emptyChannel round trips.
- **Inapplicable cases/limits:** Raw rectangular zero shape is a vacuous function, not a PMF row on Fin0. Coordinate conversion cannot manufacture a missing row.

<a id="b04-active-empty"></a>

#### B04-ACTIVE-EMPTY

- **Type/assumptions:** ActiveFiniteChannel alpha requires [Finite alpha] [Nonempty alpha], stores outputCard>0 and every output active. Intrinsic active-output union is nonempty for every nonempty-input PMF channel. A chosen prior is not part of this type.
- **Actual source/proof:** SING:181-219 active union/restriction and nonemptiness. RAW:360-364 exact active structure fields.
- **Maintained assertions checked:** TSING:247-254 card(activeOutputs)>0. TRAW:280-283 fail_if_success rejects ActiveFiniteChannel(Fin0) without a Nonempty instance; :285-292 rules out outputCard0 and all-zero admitted output. This is an actual maintained negative elaboration assertion.
- **Inapplicable cases/limits:** Active empty input is excluded by required instance; active zero-output state contradicts stored positive cardinality. Empty families inside finite path/LP constructions are separate from empty active alphabets.
- **Cross-link:** C10/C11 actual empty/singleton paths and C13–C15 singleton/empty-admissible-family assertions are recorded in [C16-B04-MATRIX-LP](#c16-b04-matrix-lp).

<a id="b04-singleton"></a>

#### B04-SINGLETON

- **Type/assumptions:** Singleton source/value/output/active states are valid. Arbitrary supplied Unit-output rows normalize to point mass1 and are perfect. Unit input singularity alone is structural; perfectness fixture is within the at-most-two-output contract, plus explicit actual singleton-support constructions.
- **Actual source/proof:** SING:258-358 private equal-row/deterministic witnesses and at-most-two active theorem. CAN all-prior/full-support pair bridge; TV maximalCoupling_self; RAW active fields preserve value1.
- **Maintained assertions checked:** TFR:580-599 deterministic singleton auxiliary and all singleton values over arbitrary PMF Nat; TCAN:197-201 arbitrary infinite source canonicality and :838-849 singleton pair/full-support iff; TSING:57-61 Unit input singularity, :272-285 exact singleton restriction, :393-426 Unit output/Unit input/single active label perfectness. TBIN:315-320 arbitrary binary-input Unit-output rows; :786-800 actual MI0 attainment. TTV:106-112 singleton TV0; :286-295 singleton actual diagonal coupling. TRAW:302-311 one active output, exact and Real mass1.
- **Inapplicable cases/limits:** No missing generic singleton-input theorem family is inferred beyond approved contracts. Singleton/no-op paths and singleton partition/LP assertions are recorded in C16-B04-MATRIX-LP below.
- **Cross-link:** C10/C11 actual empty/singleton paths and C13–C15 singleton/empty-admissible-family assertions are recorded in [C16-B04-MATRIX-LP](#c16-b04-matrix-lp).

<a id="b04-lp-family"></a>

#### B04-LP-FAMILY

- **Type/assumptions:** An empty admissible-partition family is allowed for valid compressed data with nonempty finite input, positive values and per-input normalization. The empty finite function domain is distinct from an empty PMF or active channel.
- **Source and maintained evidence:** [C16-B04-MATRIX-LP](#c16-b04-matrix-lp) records the actual Incidence.AdmissiblePartition, Primal and Dual contracts and original Tests/Optimization/Incidence.lean empty-family/singleton assertions. The empty family's primal objective image is {0}; the dual image contains both 0 and 1 and does not have least value 1. [C16-B10-MATRIX](#c16-b10-matrix) records attainment and the separate subunit proof branch.

<a id="c16-b04-matrix-lp"></a>

#### C16-B04-MATRIX-LP — Empty and singleton boundaries are separate by carrier

**Hypotheses:** Raw channels may have empty input. ActiveFiniteChannel requires [Finite α][Nonempty α] and positive outputCard. CompressedPatternData and LP theorems require [Fintype α][Nonempty α]. An empty admissible-partition family is allowed even though occurring patterns cannot be empty.

**Production proof connections**

- Matrix/PatternCompression.lean:568–706,716–735 stores nonempty input patterns, strictly positive values and per-input normalization; CompressedPatternData.patterns_nonempty follows from a chosen input. It does not manufacture a datum with an empty pattern family.
- Optimization/Primal.lean:35–129 and Optimization/Dual.lean:40–110 define functions over the possibly empty AdmissiblePartition D; primal zero is always feasible. Dual.feasible_zero_of_isEmpty handles zero constraints. DualCharacterization.exists_feasible_objective_lt_one_of_not_perfect explicitly branches on IsEmpty before applying nonempty convex separation.
- Matrix/MultiwayOperations.lean:90–172 rules out an empty positive normalized weight family by sum=1, and returns the actual nil path in the singleton branch. multiPpmOrEmpty:1303–1316 returns the source/nil/refl result for an empty selection; this is not an illegal active binary merge.

**Maintained assertions inspected**

- Tests/Matrix/Channel.lean:70–117 permits the raw Fin0→PMF Fin0 function by empty elimination, disproves Unit→PMF Fin0 and its normalized matrix, and :278–311 rejects ActiveFiniteChannel Fin0 by fail_if_success, proves outputCard≠0/no zero active column and tests singleton exact/Real mass1 (also freshly inspected in B04-RAW-EMPTY, B04-ACTIVE-EMPTY and B04-SINGLETON).
- Tests/Optimization/Incidence.lean:246–304 singleton datum has one occurring pattern/partition, equality coefficient1, primal interval0≤t≤1 and dual interval1≤t; actual weak duality1≤2 and rejection of the reverse.
- Tests/Optimization/Incidence.lean:447–517,560–659,667–737 EmptyFixture uses patterns{01,02,12} with each value1/2. It proves IsEmpty AdmissiblePartition and cardinal0, no equality solution, primal image={0}/IsGreatest0, dual zero feasible/objective0, row witness1, and ¬IsLeast1. Arbitrary finite Fin0 presentations retain the same assertions.
- Tests/Matrix/MultiwayOperations.lean:330–340,1098–1130,1761–1818 tests the chosen PPS/VPS/PPM singleton witnesses have path length0 and exact coordinates; emptyMerge is exactly source/nil/refl, has length0 and identity labels. :2047–2064 merges all3 labels to one with length2. Matrix/CanonicalReachability.lean:2591–2627 tests actual PureSplit forward/reverse words [vps]/[vpm], and actual singleton composite empty words, length0 and full maps in both directions.

**Inapplicable cases and limits:** Empty input does not instantiate the active/compressed/LP APIs; zero active outputs contradict nonempty input PMF normalization. Empty constraints do instantiate LP APIs. An empty normalized positive PPS target is impossible, while empty PPM selection is an explicit no-op wrapper.

**Cross-links:** [B04-SEM-EMPTY](#b04-sem-empty), [B04-RAW-EMPTY](#b04-raw-empty), [B04-ACTIVE-EMPTY](#b04-active-empty), [B04-SINGLETON](#b04-singleton). **S01 crosswalk references:** `C16-THM01`. **Matrix receipts:** `M08`, `M09`, `M11`, `M17`, `M22`, `M25`.


<a id="c16-b05"></a>

### C16-B05 — Ambient outputs and exact recovery

<a id="b05-sem-restriction"></a>

#### B05-SEM-RESTRICTION

- **Type/assumptions:** activeOutputs(kappa) is the union of all row supports independent of input prior. restrictActiveOutputs attaches supported labels without renormalization; each active atom has original mass and inclusion recovers every complete original row. Finite singular/perfect invariance adds finite alphabets, perfectness also Nonempty input.
- **Actual source/proof:** SING:181-238 actual bindOnSupport construction, mass equality, all-active union and inverse inclusion. Support-union identification :242 only full prior support, with arbitrary-prior subtype as B02.
- **Maintained assertions checked:** TSING:227-244 exact mass/inclusion/global activity and both iff consumers; :272-285 singleton mass1 recovery; :312-359 strict ambient-vs-pair support distinction and exact input-support inclusion. TEX:64-80 injectively added output3 has mass0 and remains singular/nonperfect.
- **Inapplicable cases/limits:** No rescaling, artificial nonempty witness for empty raw input, or active value/pattern at a zero column.
- **Cross-link:** Supplied active presentations, admitted-column guards, retained compression inverse and dependent-record recovery are recorded in [C16-B05-MATRIX](#c16-b05-matrix).

<a id="b05-sem-injection"></a>

#### B05-SEM-INJECTION

- **Type/assumptions:** Injective output extension transports full coordinate/vector law and common posterior; finite alpha,beta,gamma and Nonempty alpha for perfectness iff. Its inverse completion is internal, derived from an actual row; posterior values outside image are unconstrained. Supported vector law recovers exactly through a supplied left inverse.
- **Actual source/proof:** SING:100-127 public isPerfectlyRepresentableChannel_map_iff maps BOTH components; actual proof obtains beta witness from row support, constructs invFun, uses left inverse. Singularity map :79-94 uses atom equality. TV injection contracts preserve coupling/mismatch with injective common map.
- **Maintained assertions checked:** TSING:153-201 unused none output zero, both iff directions, all supported vector coordinates in image and full vector-law recovery; :205-220 arbitrary posterior at none. TTV:457-476 mapped attaining law, :496-516 Fin.castSucc and independent ULift universe, :524-552 common finite subtype and both unused marginal fibers0. :557-564 constant noninjective map changes TV1→0, guarding injectivity.
- **Inapplicable cases/limits:** Recovery is on supported vectors/full law, not a constraint on arbitrary posterior atoms at unused outputs. Noninjective coarsening does not preserve TV generally.
- **Cross-link:** Supplied active presentations, admitted-column guards, retained compression inverse and dependent-record recovery are recorded in [C16-B05-MATRIX](#c16-b05-matrix).

<a id="c16-b05-matrix"></a>

#### C16-B05-MATRIX — Ambient zeros and full compression/data recovery

**Hypotheses:** Admitted column data uses active-output subtypes; no positive column datum exists for a zero column. Compression uses singularity and finite alphabets; active/cascade and CompressedPatternData bridges require nonempty input. Injective output maps may add ambient unused labels.

**Production proof connections**

- Matrix/PatternCompression.lean:299–362 patternCompression is the actual multiPpmFibers certificate grouped by equal patterns, with exact masses identified with patternCompressedChannel. :417–448 patternCompressionCascade uses the supplied enumeration, and patternCompressionInverse is definitionally that same cascade.reverse, with the retained directed output comparison.
- Matrix/PatternCompression.lean:565–706 constructs a channel from valid compressed data and proves extraction_roundTrip as equality of the whole dependent record: pattern family equality plus values after membership-proof transport. :868–937 proves occurring-pattern/aggregate/value and full compressedPatternData invariance under injective output maps and supplied active enumerations. :952–973 composes the retained reverse with active inclusion to recover every ambient PMF coordinate, including unused outputs.
- Current Matrix/Channel.lean identity equals S01; exact active restriction/recovery and supplied-equivalence facts feed these proofs. B05-SEM-RESTRICTION and B05-SEM-INJECTION above record the semantic restriction/injection claims.

**Maintained assertions inspected**

- Tests/Matrix/Channel.lean:518–558,605–664 tests Optionsome inclusion, none mass0, all ambient labels recovered, no absent label in active inclusion range; a point prior sees one output while the intrinsic active union contains all3, distinguishing prior support from channel support.
- Tests/Matrix/PatternCompression.lean:886–964 tests complete extraction_roundTrip and its dependent membership/value field; :1173–1249 tests reconstructed exact/Real channel, no empty pattern datum, supplied finite presentations and full recovery; :1389–1441 adds a zero label with Fin.castSucc, checks exact/Real aggregate1/2 and equality of the complete compressed record. :641–714 tests zero-path identity and singleton compression/inverse; :765–818 uses a3-cycle with distinct forward/inverse maps.
- Tests/Optimization/Incidence.lean:1261–1366 uses the supplied finite presentation and Option none recovery bridge into incidence, retaining the same D through extractionRoundTrip.

**Inapplicable cases and limits:** Compression is by equality of patterns, not equality of values; a reverse is a witnessed PPS reconstruction with directed comparison, not literal equality of numbered matrices. No arbitrary noninjective output pushforward preserves the full data.

**Cross-links:** [B05-SEM-RESTRICTION](#b05-sem-restriction), [B05-SEM-INJECTION](#b05-sem-injection). **S01 crosswalk references:** `C16-EQ11`, `C16-LEM04`. **Matrix receipts:** `M09`, `M11`, `M13`, `M19`, `M22`, `M21`.


<a id="c16-b06"></a>

### C16-B06 — Mass, Real conversion and normalization

<a id="b06-mass"></a>

#### B06-MASS

- **Type/assumptions:** PMF atoms are finite (apply_ne_top). Overlap is sum of minima ≤1 and finite; mismatch finite as ≤1. toReal sums/minima/injectivity/subtractions explicitly carry finite-mass and order premises. TV is finite half-L1 of Real masses; residual subtraction is ENNReal truncated subtraction.
- **Actual source/proof:** TV:60-115 finite overlap proof and conversion; :133-178 zero/one reflection requires non-top; :203-258 mismatch complement/finiteness; :277 uses toReal_mono with finite mismatch. BIN:432-440 conditions nonzero q and finite PMF q before cancellation.
- **Maintained assertions checked:** TTV:35-59 overlap/residual complement, no-top residual and both positive-part sums; :86-103 exact partial overlap/TV, :303-321 maximal_atom_toReal proves both summands finite and subtraction orders; :407-434 all16 unequal atoms normalized1 and overlap5/8,mismatch3/8 in exact/Real forms; :611-629 all9 shared/exclusive atoms and exact/Real mismatch3/4.
- **Inapplicable cases/limits:** Never infer exact mass equality from toReal alone for arbitrary ENNReal: infinity also maps to0. Actual PMF contracts rule infinity out.

<a id="b06-coupling"></a>

#### B06-COUPLING

- **Type/assumptions:** maximalCouplingWeight uses a single total ENNReal denominator d=1-overlap, including d=0. Row proof uses mul_div_cancel_right' with obligation d=0→residual=0 from residual≤d and d=top impossible; it does not cancel an unproved nonzero denominator. The resulting normalized PMF is actual, with both marginals and mismatch attainment.
- **Actual source/proof:** TV:283-330 residual bound, explicit totalized expression and normalization; :341-418 marginals, diagonal=min, attaining mismatch, exact p=p diagonal and overlap0 product laws. This is the approved reading of B06 no unjustified division/cancellation, not a claim of no literal zero-denominator expression.
- **Maintained assertions checked:** TTV:195-207 explicitly d=0, diagonal law, mismatch0 and zero residual⇒p=q. :210-216 disjoint endpoints product/mismatch1/TV1. :219-247 equal masses/no offdiagonal fibers and positive residual support⇒d>0. :250-283 unused fibers0. :339-363 and :407-434 full 3×3/4×4 atom tables and total1. TBIN:305-357 semantic common-posterior endpoints overlap0/1 and singleton rows.
- **Inapplicable cases/limits:** No public PMF formed by dividing a zero-mass component to normalize it; totalized arithmetic is justified in the zero branch. No assumed optimizer or external maximal-coupling theorem.

<a id="b06-raw-real"></a>

#### B06-RAW-REAL

- **Type/assumptions:** Raw Real reconstruction requires both entry nonnegativity and finite-row sum1. ofReal(toReal mass)=mass uses PMF non-top; toReal(ofReal entry)=entry uses nonnegativity. Raw rows, not columns or total pattern values, are normalized.
- **Actual source/proof:** RAW:43-56 atom bound/finiteness and row normalization; :101-169 nonnegative≤1 Real masses, both conversion and channel/matrix round trips.
- **Maintained assertions checked:** TRAW:188-197 signed (-1,2) row sums1 yet violates nonnegativity and ofReal clips it to total2. :200-206 nonnegative all-ones row does not sum1. :209 infinity and0 have same toReal. :179-183 correct vacuous Real0×0 round trip. TTV/BIN finite PMF examples never depend on arbitrary ENNReal injectivity.
- **Inapplicable cases/limits:** This checks raw numeric boundary only. Total compressed pattern-value sum is not generally 1; column-value positivity and aggregate/dependent Real recovery are recorded in C16-B06-MATRIX-LP below.
- **Cross-link:** Admitted values/strict split ratios, exact/Real aggregates and per-input versus total-value sums are recorded in [C16-B06-MATRIX-LP](#c16-b06-matrix-lp).

<a id="c16-b06-matrix-lp"></a>

#### C16-B06-MATRIX-LP — Mass conversion, admitted ratios and per-input normalization

**Hypotheses:** PMF masses are finite; admitted singular column values are positive and at most1. Occurring-pattern aggregates are finite positive sums. Conversion uses these explicit signs/finiteness hypotheses. Cancellation/division is used only with a proved nonzero divisor; total ENNReal zero-division behavior in the semantic coupling is separately justified there.

**Production proof connections**

- Matrix/SingularColumns.lean:1–245 is unchanged from S01: admitted support witnesses determine positive finite columnValue and its exact/Real laws. Matrix/PatternCompression.lean:492–552 proves aggregate.toReal positivity, ≤1, ofReal_toReal, toReal_sum with each summand ne_top, and row normalization. Its data constructor uses ofReal_sum under nonnegativity.
- Matrix/Operations.lean:857–925 derives ppmRatio facts from positive finite admitted values; the NNReal denominator is positive, ratio strictly between0 and1, and multiplying ratio/complement by their sum recovers each original value. The row-null case never supplies the denominator.
- Optimization/Incidence.lean:333–348 obtains coefficient sum1 from all input equations and a nonempty input. DualCharacterization.lean private patternCard identities use sum_x indicator(x∈p)=card(p) and per-input sum1; corrected threshold positivity is proved before normalization.

**Maintained assertions inspected**

- Tests/Matrix/PatternCompression.lean:203–288 identity columns have equal values1 but different singleton patterns; aggregate values sum to2, while every input row sums to1. :886–964 checks exact/Real aggregate, positivity/bounds and both conversion directions.
- Matrix/Preservation.lean:769–853 checks positive strict recovery ratio despite a null input row. Tests/Examples/Incidence.lean:1991–2214 tests pattern cardinalities1/2/3, actual input cardinal3, per-input normalization despite total pattern-value sum7/4, positive corrected threshold63/2 and strict subunit normalization125/126. See C16-B10-MATRIX for certificate details.

**Inapplicable cases and limits:** No total pattern-value sum=1, no positive data for inactive columns, no cancellation at zero. B06-MASS, B06-COUPLING and B06-RAW-REAL above record overlap endpoints 0/1, residual-zero coupling and raw exact/Real conversions.

**Cross-links:** [B06-MASS](#b06-mass), [B06-COUPLING](#b06-coupling), [B06-RAW-REAL](#b06-raw-real). **S01 crosswalk references:** `C16-EQ11`, `C16-EQ12`. **Matrix receipts:** `M06`, `M07`, `M09`, `M11`, `M19`, `M24`, `M21`.


<a id="c16-b07"></a>

### C16-B07 — Operation guards, recovery and finite normalization

<a id="c16-b07-matrix"></a>

#### C16-B07-MATRIX — Legal operations, recovery and finite normalization

**Hypotheses:** Production active operation/path APIs use finite nonempty input and singular source. PPS requires NNReal0<t<1; VPS requires witnesses for both nonempty selected-support pieces and allows admitted value1. PPM requires equal supports, VPM equal admitted values and disjoint supports. Both merges select a<b from all Fin S.outputCard labels, keep the lower survivor and delete the higher label. Normalization additionally requires p.Normalizing (only PPS/VPS/PPM kinds); reducing paths with VPM are handled by their separate reachability contracts.

**Production proof connections**

- Matrix/Operations.lean:302–411,535–664,985–1135,1172–1320,1476–1575,1761–1990 defines these guards and actual PMF transformations, retains all unaffected coordinates, and proves witnessed recovery through ppmRecoveryEquiv/vpmRecoveryEquiv and their inverse maps. Current bodies match the exact S01 inspected ranges; guards and positive ratios were freshly reread.
- Matrix/OperationPaths.lean:145–257 and Matrix/Reachability.lean:1–304 (unchanged S01 inspected source) carry typed endpoints, empty paths, transports, reverse operation kinds and directed cascade comparisons. Matrix/OperationCalculus.lean:1884–1937 classifies every local selected/disjoint inversion with exact target; the kind rank is only a classification, not a measure on expanding paths.
- Matrix/OperationFactorization.lean:800–824,1934–2076 (unchanged S01 inspected proof) builds SplitForest.ofPath by induction on the original path; FactorizationCertificate.ofPath feeds realize, then OperationPath.normalize/Cascade.normalize. This is finite certificate construction and realization, not termination of arbitrary length-expanding rewrites.
- Matrix/MultiwayOperations.lean:90–172 computes positive residual weight, proves it nonzero, chooses strict PPS, recurses on the smaller finite family and constructs the nil singleton branch. Its selected/family constructors retain labelled coordinates and actual paths. Empty/singleton cases are recorded in C16-B04-MATRIX-LP.

**Maintained assertions inspected**

- Tests/Matrix/Operations.lean:301–347 rejects active PPS ratios0/1 and unequal-pattern PPM; :561–608 permits actual value-one VPS with both active children; :685–776 tests null-row mask irrelevance, rejects a globally nonconstant mask with no second supported child, singleton support splitting, overlapping equal-value VPM and disjoint unequal-value VPM.
- Tests/Matrix/Operations.lean:499–546 uses nonadjacent unequal masses[1,2,3,4]/10: correct recovery forward map and source inverse map hold, while recovered.map rho.symm is false at a distinguishing coordinate. :871–906 checks VPM recovery mask, retained/final coordinates and both directions.
- Tests/Matrix/OperationPaths.lean:623–717 checks reverse3-cycle direction, mixed permitted word[pps,ppm,vps,vpm], path composition identities/associativity, transport selected inverse index and a2/15 mass. Tests/Matrix/OperationCalculus.lean:135–181,409–439,588–647 consumes normalization for empty/single edges, all actual typed intermediate paths with PPS/VPS/PPM blocks, singularity and full terminal map; the noninvolutive terminal comparison has a false wrong-direction control.

**Inapplicable cases and limits:** Raw PPS endpoints0/1 are not legal active splits; global mask nonconstancy is insufficient; no singleton supported column admits nontrivial VPS. No rewrite-confluence, unique normal form, length-decreasing sort, or literal numbered endpoint equality is claimed.

**Cross-links:** [C16-B04-MATRIX-LP](#c16-b04-matrix-lp), [C16-B08-MATRIX](#c16-b08-matrix), [C16-B11-MATRIX](#c16-b11-matrix). **S01 crosswalk references:** `C16-EQ11`, `C16-EQ12`, `C16-EQ13`, `C16-EQ14`, `C16-EQ15`, `C16-LEM04`, `C16-LEM05`, `C16-LEM06`, `C16-THM01`. **Matrix receipts:** `M12`, `M22`, `M24`, `M25`, `M26`, `M21`.


<a id="c16-b08"></a>

### C16-B08 — Orientation and finite reindexing

<a id="c16-b08-matrix"></a>

#### C16-B08-MATRIX — Orientation, independent reindexing and whole objective images

**Hypotheses:** A channel has input rows/output columns. Input relabeling is precomposition; output relabeling is PMF.map. Incidence has occurring-pattern rows and admissible-partition columns; primal vectors use columns, dual vectors use rows. Independent finite equivalences are supplied in both directions.

**Production proof connections**

- Matrix/Channel.lean exact/Real matrix conventions and active enumeration recovery feed PatternCompression.patternCompressedState_compare, whose comparison is e.symm.trans f (:417–420), and the retained reverse/ambient recovery (:434–448,952–973). Operation recovery and cascade reverse retain directed comparisons (B07).
- Optimization/Incidence.lean:233–257 proves reindex_mulVec/system_reindex_iff for arbitrary real vectors. Primal.feasible_reindex_iff/objectiveValues_reindex (:151–192) and Dual.transpose_mulVec_reindex/feasible_reindex_iff/objective_reindex/objectiveValues_reindex (:112–171) prove both directions. The inverse of an arbitrary finite vector z is z∘cols or z∘rows; surjectivity is used to recover every coordinate. Dual transpose swaps the roles of the two index equivalences.
- DualCharacterization.isPerfectlyRepresentableChannel_iff_isLeast_reindex transfers the attained image equality, rather than checking only row witnesses.

**Maintained assertions inspected**

- Tests/Matrix/Channel.lean:70–95 has asymmetric2×3 coordinates, distinguishing orientation. Tests/Matrix/CanonicalReachability.lean:30–155 changes input and active output enumeration. Compression3-cycle fixtures distinguish forward0→1 and inverse0→2 and transport every channel coordinate.
- Tests/Optimization/Primal.lean:24–105 and Tests/Optimization/Dual.lean generic reindex sections recover arbitrary finite vectors and entire objective images. Tests/Optimization/Incidence.lean:667–737 tests empty column Fin0 and finite dual preimage recovery.
- Tests/Examples/Incidence.lean:1801–1845 tests the entire primal finite image with witnesses3/8 and1. :2246–2331 uses independent noninvolutive row and column cycles: inverse vector coordinate8 vs incorrect forward64; inverse value3/8 vs forward1/8; transposed output33 vs incorrect7. It preserves objective239/8, recovers the arbitrary vector, proves whole dual image equality and retains subunit1/2 membership.

**Inapplicable cases and limits:** Tests of involutions or only the all-one witness would not establish direction; current controls distinguish them. Equal channel shapes or selected witness transport alone are not substituted for all-coordinate/full-image equalities.

**Cross-links:** [C16-B05-MATRIX](#c16-b05-matrix), [C16-B07-MATRIX](#c16-b07-matrix), [C16-B10-MATRIX](#c16-b10-matrix). **S01 crosswalk references:** `C16-EQ11`, `C16-EQ12`, `C16-THM01`. **Matrix receipts:** `M03`, `M07`, `M08`, `M11`, `M12`, `M19`, `M21`.


<a id="c16-b09"></a>

### C16-B09 — Full and reduced incidence

<a id="c16-b09-matrix"></a>

#### C16-B09-MATRIX — Full/reduced incidence and sign guards

**Hypotheses:** D:CompressedPatternData α with [Fintype α][Nonempty α]. Full incidence ranges over every nonempty input pattern and every exact partition. Reduced incidence restricts both to occurring patterns and partitions whose every block occurs. Equality feasibility includes coefficient nonnegativity.

**Production proof connections**

- Optimization/Incidence.lean:154–175 gives the exact reduced indices and zero full value on absent patterns. :209–213 distinguishes exact occurring count D.patterns.card from the full universe cardinal2^cardα−1. :415–507 defines separate FullFeasible/Feasible and proves absent-pattern equations force nonadmissible partition weights to zero using nonnegativity, then extends/restricts the same vector and proves existence equivalence.
- Incidence.sum_eq_one_of_reduced_eq and Incidence.sum_eq_one_of_full_eq (:333–347) is valid for arbitrary signed equality solutions; this normalization identity alone does not supply feasibility. Incidence.partitionConstruction (in Optimization/IncidenceConstruction.lean) consumes nonnegative equality feasibility, restricts to positive partitions, and realizes the very supplied vector; no signed same-vector converse is asserted.

**Maintained assertions inspected**

- Tests/Examples/Incidence.lean:681–796 R06 mixed system uses occurring rows with all full columns: nonnegative coefficients[0,1/2,1/2,1/2,0] satisfy it, with sum3/2, even though the correct reduced family is empty/infeasible. R07 signed full coefficients[0,1/2,1/2,1/2,−1/2] satisfy full equality; the explicit negative last coefficient prevents nonnegative bridge use.
- Tests/Examples/Incidence.lean:1581–1645 signed reduced coefficients[1/8,3/8,3/8,3/8,−1/4] satisfy equality and have objective1 yet are not primal feasible. Shared positive controls extend/restrict the same valid vector. Tests/Optimization/Dual.lean: exact occurring count and upper bound are asserted separately; full nonzero-pattern cardinal is exactly2^cardα−1.

**Inapplicable cases and limits:** Neither mixed occurring-rows/full-columns systems nor arbitrary signed equalities satisfy the full/reduced feasibility equivalence. The number of compressed variables need not equal the full nonzero-pattern bound.

**Cross-links:** [C16-B06-MATRIX-LP](#c16-b06-matrix-lp), [C16-B10-MATRIX](#c16-b10-matrix), [C16-B11-MATRIX](#c16-b11-matrix). **S01 crosswalk references:** `S01 C13 incidence crosswalk / DG-12`. **Matrix receipts:** `M03`, `M06`, `M07`, `M13`, `M16`.


<a id="c16-b10"></a>

### C16-B10 — LP attainment and subunit certificates

<a id="c16-b10-matrix"></a>

#### C16-B10-MATRIX — LP predicates, attainment and constructive subunit certificates

**Hypotheses:** Same valid compressed data and nonempty finite input as B09. Equality means nonnegative Hx=v; primal means x≥0,Hx≤v; dual means y≥0,Hᵀy≥1. objectiveValues is the image of the corresponding feasible set, so IsGreatest/IsLeast includes an attaining feasible vector.

**Production proof connections**

- Primal.objective_eq_one_iff/equality_feasible_iff (:81–110) proves equality for the same feasible x: for each pattern p choose an input inside p, use the zero nonnegative input-row slack sum and bound that coordinate. It does not infer all slacks from one fixed row. isPerfectlyRepresentableChannel_iff_isGreatest (:119–129) uses membership to recover the witness.
- Dual.weak_duality (:63–78) separately uses primal coefficient and dual coordinate nonnegativity. rowWitness/one_mem_objectiveValues (:80–104) proves objective1 for every valid D, including nonperfect D. This membership alone cannot characterize perfectness.
- DualCharacterization.lean:42–214 identifies the finite convex hull with nonnegative equality feasibility; its private separation proof uses the pinned mathlib geometric_hahn_banach_point_closed and dotProductEquiv. patternCard is each actual support cardinal. Its dot value and dot every incidence column both equal cardα. correctionScale=Σ|w|+|c|+1, correctedVector=w+t·patternCard and correctedThreshold=c+t·cardα are nonnegative/strictly positive before division. Corrected strict gaps yield an actual nonnegative feasible y of objective<1.
- Dual.exists_feasible_objective_lt_one_of_not_perfect (:216–235) handles empty constraints with y=0 before nonempty separation. isPerfectlyRepresentableChannel_iff_isLeast (:237–252) uses primal attained1 plus weak duality forward, and strict subunit contradiction backward. Ambient wrappers require singular κ,[Fintype α][Nonempty α][Finite β]; finite presentation wrappers preserve entire images.

**Maintained assertions inspected**

- Tests/Optimization/Primal.lean:130–245 two-pattern slack fixture has first input-row slack0 but second1, refuting the fixed-row shortcut; actual saturation forces both coordinates0. Tests/Optimization/Primal.lean and DualCharacterization.lean explicitly extract membership witnesses from IsGreatest/IsLeast.
- Tests/Examples/Incidence.lean:1847–1941 signed dual[2,2,2,−1,−1,−1,1] has all transpose products[1,1,1,1,6] and objective−1/4 but is rejected by y≥0. Actual nonnegative dual[1,1,1,0,0,0,1] has products[1,1,1,1,3], feasible objective1/2 and a nonempty5-partition constraint family. The public existential is not equated to this selected test vector.
- Tests/Examples/Incidence.lean:1991–2214 checks pattern cardinalities[1,1,1,2,2,2,3], all incidence-column cardinal sums3 (including one-block and three-block partitions), dotvalue3, and rowwise normalization. Raw separator[0,0,0,−2,−2,−2,−2] has dotvalue−5/2, threshold−9/4 and products[−2,−2,−2,−2,0]. Shift45/4 gives positive scale63/2; corrected coordinates[45/4,45/4,45/4,41/2,41/2,41/2,127/4]. Normalized coordinates[5/14,5/14,5/14,41/63,41/63,41/63,127/126] are feasible with four products127/126, fifth15/14, objective125/126<1.
- B04’s empty-family tests have both0 and1 in the dual objective image and ¬IsLeast1. r09Data in Tests/Examples/Incidence.lean supplies a perfect positive-control feasible primal and universal dual lower bound1, although total pattern values are7/4.

**Inapplicable cases and limits:** No general optimizer existence, numerical LP solver, uniqueness, or mere equality of supremum/infimum is asserted. Signed vectors satisfying inequalities/equality are excluded by explicit sign predicates. Objective-one dual membership holds even when not perfect.

**Cross-links:** [C16-B04-MATRIX-LP](#c16-b04-matrix-lp), [C16-B08-MATRIX](#c16-b08-matrix), [C16-B09-MATRIX](#c16-b09-matrix). **S01 crosswalk references:** `S01 C14/C15 LP crosswalk`. **Matrix receipts:** `M02`, `M03`, `M04`, `M07`, `M08`, `M26`.


<a id="c16-b11"></a>

### C16-B11 — Decoder fibers and constructed endpoints

<a id="c16-b11-matrix"></a>

#### C16-B11-MATRIX — Decoder fibers and actual multiway endpoints

**Hypotheses:** C11 has a PMF q on full decoder vectors and a total common posterior satisfying every-row full joint factorization; active auxiliary labels admit only positive-q vectors and used outputs. C13 starts from nonnegative equality weights of the same D. Blocks are nonempty exact partitions; prescribed merge fibers must be nonempty or be reduced to their range.

**Production proof connections**

- Matrix/CanonicalReachability.lean:1–557,575–725,1472–1728 (S01 unchanged) constructs active posterior/decoder-label equivalences, originalPps, seedPps and seedVps. Fresh :2334–2453 defines canonicalFromAllOnes as seedBridge.comp originalBridge.reverse and canonicalNormalForm retains those very PPS/VPS paths plus transported reversed original path. toCascade equality is rfl; exact words, inverse composition order and both full PMF maps are proved. Public characterizations consume these witnesses.
- Optimization/Incidence.lean:580–761 proves supported_coordinate_support from the full joint law; decoder_fiber_iff uses a supported used-output anchor and coordinate_eq_of_posterior_support, then actual disjoint covering patterns form decoderPartition. decoderWeights sums q.toReal on partition fibers, handles zero q atoms and satisfies every reduced incidence equation.
- Optimization/IncidenceConstruction.lean:31–387 retains actual pps/vps/ppm endpoints and labels. PositivePartition excludes zero weights, PPS uses normalized supplied coefficients, VPS uses exact supplied partition blocks, and ppmGroup groups block patterns with proved surjectivity/equal support. ppmMass proves every input/pattern mass of D.channel. normalForm retains these endpoints and compares via labels.symm.trans the supplied enumeration. C10 multiPpmFibers (:1231–1266) preserves supplied group labels, rather than merging all groups with the same pattern.

**Maintained assertions inspected**

- Matrix/CanonicalReachability.lean:1844–1895 PureSplit has q(w)=1 and unequal decoder blocks{0,1}/{2}, disjoint with unionuniv. :1897–1995 Repeated starts with three distinct vectors u,v,z of weights1/4,1/2,1/4, repeated full patterns and a nonconstant vector with unequal fibers; factorization is checked by all vector/coordinate cases.
- Matrix/CanonicalReachability.lean:2497–2627 consumes actual composites: forward word[pps,vps,vps,ppm], reverse[pps,vpm,vpm,ppm], exact chosen stages and directed3-cycle comparisons, all output coordinates and PMF maps both ways; singleton/PureSplit empty-stage controls are in C16-B04-MATRIX-LP.
- Tests/Examples/Incidence.lean:1180–1255 actual r13Construction stage cards2→5→4, PPS length1 and PPM length1. Distinct VPS leaves with the same pattern retain unequal masses2/3 and1/3, which the selected actual PPM adds to1 on their support and0 elsewhere. r09Construction has stages4→7→7, PPS length3 and PPM length0. Tests/Optimization/Incidence.lean:1261–1366 checks all retained stage masses/patterns/label inverses for arbitrary finite target presentations.
- Tests/Matrix/MultiwayOperations.lean:2120–2165 maps group[3,1,3] to its2-element range, then ambient inclusion gives masses[0,1/3,0,2/3], explicitly restoring both empty ambient fibers. The ambient label type in this wrapper needs neither finiteness nor decidable equality.

**Inapplicable cases and limits:** Figure1 supplies logical decoder/operation relations, not pixel-level graph layout as an API. Null q vectors and empty decoder fibers are not active blocks. Equal-pattern outputs in different prescribed groups are not silently coalesced. Existence of an abstract path is not substituted for the same stored constructor endpoints.

**Cross-links:** [C16-B03-MATRIX](#c16-b03-matrix), [C16-B04-MATRIX-LP](#c16-b04-matrix-lp), [C16-B05-MATRIX](#c16-b05-matrix), [C16-B07-MATRIX](#c16-b07-matrix). **S01 crosswalk references:** `C16-FIG01`, `C16-LEM05`, `C16-LEM06`, `C16-THM01`. **Matrix receipts:** `M13`, `M14`, `M16`, `M17`, `M18`, `M22`, `M25`, `M21`.

## Complete declaration and trust inventory

### Original compiled owners

E13 enumerates `Environment.header.moduleData` for every maintained owner,
including examples, tests and the lightweight root. It reads each original
`ConstantInfo`, its type, safety flags, source ranges, lookup/enumeration result,
compiled owner and transitive axioms. No namespace or source-header prefix filters
the compiled inventory. The masked source-command inventory and `.ilean` names
are independently reconciled against it, rather than defining its extent.

| Inventory | Result |
| --- | ---: |
| Maintained owners, including root | 56 |
| Source declaration commands | 5,370 |
| Source declarations other than anonymous examples | 3,557 |
| Explicitly named public / private source declarations | 935 / 2,593 |
| Source instances, included above / local instances | 31 / 27 |
| `.ilean` named entries | 3,620 |
| Original compiled owner entries / distinct names | 6,534 / 6,518 |
| Original compiled private entries | 4,963 |
| Unmatched source / `.ilean` / compiled entries | 0 / 0 / 0 |

The 3,557 source declarations comprise 3,528 explicitly named commands plus
29 instances whose names are generated. Instance totals overlap these counts;
they are not added again. Original compiled entries comprise 4,609 theorems,
1,861 definitions, 19 inductives, 26 constructors and 19 recursors. All have
nonempty elaborated signature output. No original axiom or opaque entry occurs.
Private implementation helpers and generated entries are included; the count
does not assert that all 935 nonprivate named commands are intended public API.
The source inventory also retains all 88 attribute commands, including 79
local-instance attribute commands; these create no additional constant and their
context is preserved in the original snapshots and full-context copies.

All 6,534 entries have a source disposition: 3,557 source declarations, 2,726
generated descendants, 192 local-notation generators from 64 commands, three
derived-instance generators, 47 generated entries whose base is another project
module, and nine whose base is a pinned library declaration. The latter bases
are `Finite.equivFin`, `PMF.binaryMixture`, `fstSndMarginal`, `Fin.ext_iff`,
`Finpartition.indiscrete` and `finTwoArrowEquiv`; their actual imported owners
and signatures were checked. Initial unmatched records are retained alongside
their final individual dispositions. Source/.ilean counts need not equal
compiled counts: elaboration produces declarations absent from source headers.

The scratch umbrella of all tests encountered one duplicate local-instance name
between `Tests.Matrix.PatternCompression` and `Tests.Matrix.SingularColumns`.
The successful original audit used two explicit import groups covering every
owner. This is a limitation of that combined scratch import; each maintained
module builds. Fifteen additional generated-name owner occurrences differ from
the environment's single resolved owner. Each original `moduleData` body is
available, its type equals the resolved type, and its own type/body dependency
axiom union was checked. The audit retains all occurrences; it does not silently
charge them to whichever owner wins lookup. Together these explain the difference
between owner-entry and distinct-name counts.

### Axioms and safety

Every original compiled entry and every separately elaborated copy entry has
transitive axioms contained in `{propext, Classical.choice, Quot.sound}`.
The original imported audit uses pinned Lean's exported transitive axiom metadata;
current scratch declarations are traversed before export. Duplicate original
owner bodies receive the additional own-body dependency check described above.
The literal required source scan independently finds no placeholder token.

No original entry is marked unsafe. Sixteen generated `_unsafe_rec` entries are
marked partial: eleven private structural-recursion helpers in
`Matrix.OperationFactorization`, `OperationPath.transport` and `.tags` in
`Matrix.OperationPaths`, `.reverse` in `Matrix.Reachability`, and the private
`s06Masks`/`s06Ratios` helpers in `Tests.Matrix.OperationCalculus`. Pinned Lean
compiler source explains these as runtime companions of safe recursive
definitions. This classification is checked, rather than inferred from a suffix:

- Each of the sixteen has its corresponding safe base and an available body.
- All 6,534 original types and available values were inspected for direct
  references to unsafe or partial declarations. The 6,518 safe entries have none.
- Each partial helper's only partial reference is its own recursion. Its
  type/body dependency axiom union remains within the permitted set.

This scopes the result to the project declarations and their transitive axioms;
it is not an exhaustive declaration audit of Lean, mathlib or LeanInfoTheory.

### Anonymous commands and exact-body copies

The source inventory identifies **1,813 anonymous `example` commands in 34
files**. Original module builds accept them, but the original compiled exports
do not retain one named constant per example. The additional audit replaces only
each known `example` header token with a uniquely named `private def`, preserving
the complete surrounding file, declarations, instances, options and proof bodies.
Removing the explicit audit footer and reversing the recorded replacements
recovers every original source byte exactly. The scratch module name and the
declaration's named/transparent status necessarily differ.

All 34 authoritative copies compile with the five actual project options:
`maxSynthPendingDepth=3`, `relaxedAutoImplicit=false`, `pp.unicode.fun=true`,
`weak.linter.mathlibStandardSet=true`, and `weak.linter.style.header=false`.
A separate option control confirms their effective values. The appended footer
enables explicit/universe signature printing and removes its own heartbeat limit;
it follows the original source body. The first optionless pass is retained as
superseded diagnostic evidence and is not used to establish this result.

Every source example maps to exactly one principal copy constant. The copies
produce 1,813 such principals and 69 generated descendants, **1,882 anonymous-copy
entries** total. Their enclosing files produce 6,694 stage-2 entries in all;
this larger count also includes re-elaborated named source declarations and their
generators. All 6,694 types are recorded and all axiom sets are permitted. There
are no unsafe entries. Thirteen partial runtime helpers match the original safe
base classification; none is an anonymous principal or its generated descendant.

The 2,349 scratch warnings are classified: 1,777 proposition-definition style
warnings caused by the transparent replacement, 443 line-length warnings,
68 pretty-printer-option warnings, 34 footer heartbeat-option warnings and
27 class-definition reducibility style warnings. None is a compiler error or
an additional trusted axiom. These are separate copy elaborations, never described
as recovered original anonymous proof constants. Exact source/configuration and
original olean/ilean identities remain unchanged before and after every command.

### Inventory controls and generated ownership

The retained small diagnostic includes an imported `propext` declaration with
its actual `Init.Core` owner, a private datum, a local instance and generated proof,
an erased anonymous `True` example, and a separately named transparent copy.
It records lookup, enumeration and module ownership before and after command
resolution. `Dual.Feasible.eq_1` specifically distinguishes two valid contexts:

| Import context | Before `#check` | After `#check` | Ownership interpretation |
| --- | --- | --- | --- |
| `Tests.Optimization.Incidence` | Lookup, enumeration and module data all contain the equation | Still present; only permitted axioms | Actual compiled owner is `Tests.Optimization.Incidence`, despite its `Dual` namespace. |
| `Optimization.Dual` only | Absent from lookup, enumeration and module data | Lookup and enumeration contain the newly realized equation | No imported compiled owner: command resolution generated a current scratch declaration. |

The parent independently reproduced the first context and checked an ordinary
imported `Nat.add` control. A successful `#check` after realization cannot establish
that a declaration was already in an earlier enumeration. This is why original
module data, complete reconciliation and before/after controls are all retained.
The controls supplement, rather than replace, the complete inventory.

### Per-module reconciliation

Each row below is an actual maintained owner. `Other source` excludes anonymous
examples but includes instances; `Original` counts original compiled owner entries.
`Copied` counts anonymous principals plus their generated descendants only.
Empty root/aggregate owners are explicitly included. Full names, types, source
ranges, generated dispositions, axioms and file hashes are retained in E13/E16.

| Module below `PerfectFunctionalRepresentations` | Other source | Instances (local) | Anonymous | Original | Copied |
| --- | ---: | ---: | ---: | ---: | ---: |
| `Basic` | 0 | 0 (0) | 1 | 0 | 1 |
| `Examples.Nonrepresentable3x3` | 4 | 0 (0) | 0 | 11 | 0 |
| `Examples.Reachability` | 47 | 0 (0) | 9 | 81 | 9 |
| `Matrix.CanonicalReachability` | 351 | 0 (0) | 159 | 572 | 168 |
| `Matrix.Channel` | 74 | 0 (0) | 0 | 114 | 0 |
| `Matrix.MultiwayOperations` | 94 | 0 (0) | 0 | 219 | 0 |
| `Matrix.OperationCalculus` | 276 | 0 (0) | 51 | 1038 | 53 |
| `Matrix.OperationFactorization` | 170 | 0 (0) | 58 | 471 | 58 |
| `Matrix.OperationIndices` | 34 | 0 (0) | 0 | 74 | 0 |
| `Matrix.OperationPaths` | 105 | 0 (0) | 0 | 319 | 0 |
| `Matrix.Operations` | 220 | 0 (0) | 0 | 280 | 0 |
| `Matrix.Partitions` | 4 | 0 (0) | 0 | 9 | 0 |
| `Matrix.PatternCompression` | 113 | 0 (0) | 0 | 155 | 0 |
| `Matrix.Preservation` | 178 | 0 (0) | 51 | 241 | 56 |
| `Matrix.Reachability` | 37 | 0 (0) | 0 | 83 | 0 |
| `Matrix.SingularColumns` | 35 | 0 (0) | 0 | 43 | 0 |
| `Optimization.Dual` | 17 | 0 (0) | 0 | 19 | 0 |
| `Optimization.DualCharacterization` | 28 | 0 (0) | 0 | 32 | 0 |
| `Optimization.Incidence` | 83 | 0 (0) | 0 | 110 | 0 |
| `Optimization.IncidenceConstruction` | 37 | 0 (0) | 0 | 79 | 0 |
| `Optimization.Primal` | 17 | 0 (0) | 0 | 18 | 0 |
| `Probability.FiniteCoupling` | 56 | 0 (0) | 0 | 73 | 0 |
| `Probability.FiniteCouplingDecoding` | 3 | 0 (0) | 0 | 4 | 0 |
| `Semantics.Binary` | 66 | 0 (0) | 0 | 75 | 0 |
| `Semantics.Canonical` | 64 | 0 (0) | 0 | 71 | 0 |
| `Semantics.FunctionalRepresentation` | 25 | 0 (0) | 0 | 29 | 0 |
| `Semantics.Singularity` | 23 | 0 (0) | 0 | 29 | 0 |
| `Tests.Examples.Incidence` | 308 | 4 (2) | 120 | 465 | 122 |
| `Tests.Examples.MatrixOperations` | 30 | 0 (0) | 28 | 43 | 28 |
| `Tests.Examples.Nonrepresentable3x3` | 0 | 0 (0) | 8 | 0 | 10 |
| `Tests.Examples.Nonrepresentable3x3Columns` | 11 | 0 (0) | 19 | 17 | 19 |
| `Tests.Matrix.CanonicalReachability` | 23 | 0 (0) | 33 | 38 | 34 |
| `Tests.Matrix.Channel` | 29 | 0 (0) | 76 | 46 | 76 |
| `Tests.Matrix.MultiwayOperations` | 231 | 9 (7) | 151 | 400 | 152 |
| `Tests.Matrix.OperationCalculus` | 44 | 0 (0) | 38 | 102 | 38 |
| `Tests.Matrix.OperationPaths` | 38 | 1 (1) | 60 | 74 | 62 |
| `Tests.Matrix.Operations` | 63 | 1 (1) | 141 | 102 | 151 |
| `Tests.Matrix.Partitions` | 24 | 2 (2) | 32 | 37 | 38 |
| `Tests.Matrix.PatternCompression` | 149 | 2 (2) | 128 | 229 | 136 |
| `Tests.Matrix.Preservation` | 25 | 0 (0) | 55 | 40 | 57 |
| `Tests.Matrix.Reachability` | 47 | 0 (0) | 40 | 79 | 40 |
| `Tests.Matrix.SingularColumns` | 54 | 1 (1) | 46 | 78 | 48 |
| `Tests.Matrix.Synthesis` | 52 | 1 (1) | 19 | 105 | 19 |
| `Tests.Optimization.Dual` | 0 | 0 (0) | 26 | 0 | 26 |
| `Tests.Optimization.DualCharacterization` | 0 | 0 (0) | 13 | 0 | 13 |
| `Tests.Optimization.Incidence` | 75 | 9 (9) | 124 | 127 | 127 |
| `Tests.Optimization.Primal` | 11 | 1 (1) | 25 | 27 | 26 |
| `Tests.Probability.FiniteCoupling` | 24 | 0 (0) | 53 | 48 | 54 |
| `Tests.Probability.FiniteCouplingDecoding` | 1 | 0 (0) | 9 | 3 | 9 |
| `Tests.Probability.FiniteCouplingRoot` | 0 | 0 (0) | 4 | 0 | 4 |
| `Tests.Semantics.Binary` | 68 | 0 (0) | 83 | 100 | 88 |
| `Tests.Semantics.BinaryRoot` | 0 | 0 (0) | 4 | 0 | 4 |
| `Tests.Semantics.Canonical` | 51 | 0 (0) | 66 | 70 | 66 |
| `Tests.Semantics.FunctionalRepresentation` | 27 | 0 (0) | 42 | 32 | 42 |
| `Tests.Semantics.Singularity` | 11 | 0 (0) | 41 | 23 | 48 |
| `(root)` | 0 | 0 (0) | 0 | 0 | 0 |

### Reproduction and limits

The private E16 archive preserves the exact scripts and original receipts from
`tmp/c16-s02/`, including `trust-helper/audit.py`, the vendored source parser,
`grouped.py`, `reconcile.py`, `reconcile_generated.py`, `supplement.py`,
`finalize.py`, all Lean probes and copies, and failed/superseded attempts.
Receipts contain actual argv and before/after identities. Reproduction uses a
fresh output directory and new receipt labels so original evidence is not replaced.
S05 owns the fresh cumulative rerun, including these controls and any changed
S03 consumers. No new maintained audit framework was added.

Elaborated signatures are pretty-printed Lean types, not serialized kernel
expressions or complete proof printing. Proof arguments may be elided; actual
expression dependencies are still traversed and boundary hypotheses are inspected
in their source contracts. Builds use cached artifacts. Mathematical source
alignment retains the S01 ledger and exact unchanged source applicability;
this step does not claim a fresh six-page manuscript sweep or manual rederivation
of every proof. Durable workflow closure and the independent review remain
separate from compilation and these inventory checks.

<a id="c16-s03-api"></a>
## S03 — API and import closure, 2026-10-03

Implementation source audit by `/root/c16_prerequisite_check`, 2026-10-03. The current 56 maintained owners contain **935 public source-named declarations**. Every name reconciles to its original S02 compiled owner; all source/olean/ilean/configuration identities still match. Source-public counts exclude generated projections/equations/recursors, which retain S02 inventory treatment. This section records API disposition; parent isolated consumers establish compiled availability and import exclusions.

### Complete module disposition

All public source declarations remain under `PerfectFunctionalRepresentations` and its existing semantic, `ActiveFiniteChannel`, `MatrixOperations`, `CompressedPatternData`, `Incidence`, `Primal` and `Dual` owners. No project-owned public extension of `PMF` is introduced. Existing pinned `PMF` constructions are reused.

| Module (under `PerfectFunctionalRepresentations`) | Public source names | Retained contract and owner |
|---|---:|---|
| `Basic` | 0 | One anonymous entropy smoke test; no public source declaration. Supported focused entropy import. |
| `Examples.Nonrepresentable3x3` | 4 | Exactly four public source names: channel, atom formula, singularity and nonperfectness on Fin 3. Deliberate C03 example API; separate from mathematical root. |
| `Examples.Reachability` | 0 | No public source declarations; concrete reachability fixture stays private and separately imported. |
| `Matrix.CanonicalReachability` | 2 | Exactly two public final iff statements on Finite nonempty active channels. 349 private source names and colocated assertions retain the canonical construction and actual normal-form/composite maps. |
| `Matrix.Channel` | 71 | Raw exact/Real matrices retain arbitrary alphabets, finite output enumeration for row sums, and nonnegativity/normalization. Active state uses Finite nonempty input and positive outputCard; supplied equivalences retain ambient zero-label recovery. |
| `Matrix.MultiwayOperations` | 46 | Finite nonempty active input; independent label/complement universes, explicit normalized weights/exact partitions/prescribed fibers. Retained endpoint+labels+coordinates bundle is justified by C11-C13 consumers; recursive traversal remains private. |
| `Matrix.OperationCalculus` | 0 | No public source declarations; 276 private names and colocated assertions are proof machinery for normalization. Keep private; module import alone does not promise private APIs. |
| `Matrix.OperationFactorization` | 2 | Only OperationPath.normalize and Cascade.normalize are public source declarations. Finite nonempty input, singular source and Normalizing path are explicit; certificates/trees/realization helpers remain private. |
| `Matrix.OperationIndices` | 34 | Fin n ordered split/merge/recovery formulas own the paper indexing convention. Nat/Fin specialization is the explicit matrix boundary, not a semantic alphabet restriction. |
| `Matrix.OperationPaths` | 96 | Finite nonempty input; operation endpoints stay dependent. OutputEquiv, Cascade and NormalForm expose actual maps, paths and specifications without global normalization machinery. |
| `Matrix.Operations` | 199 | Raw coordinate formulas are general in input type; active operations use Finite nonempty input. Particular closure/recovery results state their own singularity, strict-ratio, mask-support or equal-pattern guards. Fintype appears for explicit pattern coordinates. |
| `Matrix.Partitions` | 3 | Finite block-label type with arbitrary input type, nonempty disjoint blocks and exact coverage. Reuses mathlib Finpartition; empty carrier is permitted. No separate partition theory or enumeration API. |
| `Matrix.PatternCompression` | 90 | Fintype input for nonempty-support finsets, Finite ambient output; Nonempty input for valid data/active realization. Positive per-row-normalized dependent data, exact/Real and full-record round trips; private extensionality/transport machinery stays private. |
| `Matrix.Preservation` | 14 | Finite nonempty input; prior-free whole-vector/common-posterior operation proofs. Fourteen public seed/preservation results; scalar/conditional construction helpers and access-dependent fixtures remain private. |
| `Matrix.Reachability` | 37 | Finite nonempty active source/target, homogeneous/allowed tags, inverse direction and all-ones perfectness. Public path predicates consume existing preserved operations; no private canonical representation promised. |
| `Matrix.SingularColumns` | 34 | Arbitrary-universe channel; the active label supplies a nonzero input witness, with no separate Nonempty or finite-alphabet premise for values. Fintype input is added for the Finset pattern; exact/Real transport and reconstruction retain their singularity and finite-mass guards. |
| `Optimization.Dual` | 17 | Same valid-data boundary, nonnegative dual vectors, pointwise transpose constraints, objective image and inverse reindexing. Primal dependency intentional; no generic LP framework or solver. |
| `Optimization.DualCharacterization` | 5 | Five public outcomes; finite hull/separation and positive-threshold normalization stay private. Empty admissible family handled explicitly; ambient result retains Finite output and singularity. |
| `Optimization.Incidence` | 62 | Arbitrary input universe with Fintype for enumeration; valid-data clauses add Nonempty input. Full/reduced vectors retain nonnegativity, explicit zero extension, potentially empty admissible family, finite coordinate universes and support-aware decoder extraction. |
| `Optimization.IncidenceConstruction` | 18 | Fintype nonempty input; same supplied feasible vector drives public dependent PPS/VPS/PPM phases and exact specifications. Ambient iff has Finite output and singularity, no prior or full-support assumption. |
| `Optimization.Primal` | 16 | Fintype nonempty input and valid compressed data; nonnegative feasibility, attained objective-one/greatest characterizations and entire-image coordinate transport. Ambient clauses use Finite output plus singularity. |
| `Probability.FiniteCoupling` | 51 | Structural coupling plus Fintype finite sums; independent-universe injective output transport. PMF finiteness, overlap endpoints and totalized residual-zero branch remain explicit. |
| `Probability.FiniteCouplingDecoding` | 3 | Three Fintype-output identity-decoder consequences reuse pinned Fano; no new conditional-entropy family. Keep separately importable. |
| `Semantics.Binary` | 38 | Fin 2 working input, finite output/auxiliary, unrestricted source. Separate cardinality-two input transport retains universes and full-support equality converse; universal bound and attainment allow point priors. |
| `Semantics.Canonical` | 51 | Unrestricted structural canonicalization and one common posterior; information clauses retain finite value/function spaces. Full-support input premise belongs to converses; arbitrary priors use support restriction. |
| `Semantics.FunctionalRepresentation` | 23 | Independent source/value universes; no source finiteness. Structural support decoder has no classes; finite information uses finite values. Fin n enlarged-law witness preserves pair law, not a same-source auxiliary. |
| `Semantics.Singularity` | 19 | Structural necessity has Nonempty input without finite alphabets. Finite relabeling/output injection, exact active restriction and at-most-two-active-output characterization retain explicit hypotheses. |
| `(root)` | 0 | No own source declaration; six actual direct imports expose Basic, semantic owners and finite coupling. Parent isolated compilation/closure checks establish exclusions; source imports alone do not. |

All **28 test modules have zero public source-named declarations**. The complete per-module counts and mapping are in the evidence JSON. Their coverage owners are:

- `Tests.Examples`: `Incidence`, `MatrixOperations`, `Nonrepresentable3x3`, `Nonrepresentable3x3Columns`.
- `Tests.Semantics`: `Binary`, `BinaryRoot`, `Canonical`, `FunctionalRepresentation`, `Singularity`.
- `Tests.Probability`: `FiniteCoupling`, `FiniteCouplingDecoding`, `FiniteCouplingRoot`.
- `Tests.Matrix`: `CanonicalReachability`, `Channel`, `MultiwayOperations`, `OperationCalculus`, `OperationPaths`, `Operations`, `Partitions`, `PatternCompression`, `Preservation`, `Reachability`, `SingularColumns`, `Synthesis`.
- `Tests.Optimization`: `Dual`, `DualCharacterization`, `Incidence`, `Primal`.

Private fixture declarations and private/local instances stay with their test owner. The four named C03 counterexample declarations are the deliberate public example exception. C07/C10/C13 demonstration fixtures and C08/C09/C11 assertions requiring private access remain private or colocated. Constructors, projections and recursors of public structures retain their enclosing API owner. Generated names—including imported-name equation lemmas and local-notation elaboration—are inventoried for trust, without treating them as independently designed API. The source-public count is not a count of every externally visible environment constant; externally owned generated names are retained in the S02 reconciliation.

### Generality and library reuse

Retain the structural/finite-information distinction and independent universes already validated by S02. Source PMFs remain unrestricted when only values are finite. Full input support is explicit on channel converses; arbitrary-prior claims restrict to actual support. Null fibers retain the pinned total-channel convention and weighted-zero semantics. Finite semantic alphabets are not silently replaced by `Fin`; coordinate operations deliberately use `Fin n`. `Finite` is retained when enumeration is internal, and `Fintype` when finite sums, patterns or public coordinates require it. Active and LP data retain nonempty input while raw empty channels and empty admissible-partition domains keep their stated contracts.

The installed immutable LeanInfoTheory public contract, API-documentation policy, declaration index, theorem highlights and module guide were inspected locally. All direct LeanInfoTheory imports in the maintained project belong to its supported focused modules. The project reuses `PMF`, `PMF.channelJoint`, finite mixtures, mapped-law independence, total conditionals, and Real information in nats. Its functional-representation/coupling/matrix/compression/incidence/LP constructions remain paper-owned. Generated index membership is a name/ownership check, not a substitute for a type; exact source and applicable S02 types support the assumptions here. No new generic replacement or dependency upgrade is proposed.

### Consumer-driven decisions

- **S03-API-D02 — Keep C08 normalization machinery private.** Two public normalize endpoints at OperationFactorization:2058,2067 suffice for actual Tests/Matrix/Synthesis:371-389; C10 carries supplied-label finite synthesis publicly, and C12:323 consumes multiPpmFibers. Colocated private assertions retain original proof access. Revisit: An approved consumer must identify a specific needed certificate/tree property unavailable from existing OperationPath/Cascade/NormalForm or labelled C10 result; test relocation alone is insufficient. Owner: C16/OM-052, inherited C08/C10/C11 planning obligations.

- **S03-API-D03 — Keep C11 canonical construction private.** CanonicalReachability exposes precisely two Theorem1 iff endpoints; actual normal-form/composites stay private at2331-2379 with colocated checks. C13 necessity uses the public common-posterior witness (Incidence:575 onward), and IncidenceConstruction:314-383 uses its retained C10 phases and final public reachability iff endpoints. Revisit: A concrete approved consumer demonstrably needs the particular C11 canonical witness, not merely existence/perfectness or an actual C10/C13 construction. Owner: C16/OM-045/052 and C13 approved API-advice disposition.

- **S03-API-D04 — Preserve the C13 decline of a separate C12 compression-idempotence alias; no new alias.** PatternCompression length/tags-of-injective, extraction_roundTrip (including dependent values) and map-injective equality cover actual consumers. Tests/Optimization/Incidence:1330-1347,1393-1439 and158-163 preserve unused Option output and complete data/objective images without alias. Revisit: A later approved consumer must show a distinct ergonomic interface is needed after trying current exact round-trip/injection/presentation statements. No reopened implementation promise. Owner: C12 approved Section9 suggestion; C13 planning disposition; OM-068; C15 continued disposition; C16 S03 reassessment.

- **S03-API-D05 — Retain isIndependentOf_comp_right as a public project-local generic candidate, with upstream migration separately deferred.** Four independent universes and no finite/measurable classes at FR:102-111; concrete uses in FR:382, Canonical:205/701, Binary:770. No PMF-first comp-right entry was found in pinned public manifest/index, relevant documentation and source searches. mathlib IndepFun.comp and the LIT measurable bridge are mathematically usable with discrete structures; direct PMF proof is a local packaging choice. Search absence is not proof of mathematical impossibility or uniqueness of the current proof route. Revisit: Separately authorized LeanInfoTheory maintenance/release window or another concrete consumer; re-search then-current APIs and review naming, universes, compatibility and any immutable release upgrade. No dependency change authorized here. Owner: C01 approved Section8, original log ownership/revisit note; no duplicate numbered Future Work Note.

- **S03-API-D06 — Retain existing finite-channel wrapper default without broadening public API.** Singularity necessity has Nonempty input and no finite alphabet assumption. Ambient primal/dual endpoints use Fintype nonempty input, Finite output, singularity and compressedPatternData. Existing active/ambient/injective consumers show composition already; parent supplies isolated anonymous composition probe. Revisit: A real blocked consumer requiring a precise alternative contract with imports/hypotheses before any material-plan revision. Owner: C16 Section4.2 / OM-018.

### Evidence and limits

`tmp/c16-s03/api-helper/evidence.json` retains all 56 owner dispositions, every public source-name/compiled-name/type-hash mapping, exact selected source excerpts, local dependency documentation hashes, dependency commits and search commands/results. Existing S02 compiled types are reused only after identity comparison. `PinnedReuse.lean` supplies 11 signature lookups and one four-universe structural consumer for parent compilation; this helper has not compiled it. The helper made no maintained or private workflow edits. Parent E21/E23 supply fresh compilation and unchanged-source applicability below; S04/S05 remain outside this audit.

### Isolated compiled import audit (E21)

Each row ran in a separate Lean process with the subject import plus `Lean` for
environment inspection, under all five project options. The complete actual
`env.header.moduleNames` arrays are retained, not inferred from source imports.
The metaprogram support may enlarge the nonproject closure. Counts below cover
project modules including the subject. Every one of the 26 production owners
(including root), and additionally both demonstration owners, excludes `Tests`;
production also excludes `Examples`. Nine focused consumers check public names.

| Isolated subject below `PerfectFunctionalRepresentations` | Project modules | Required absence / result |
| --- | ---: | --- |
| `Matrix.Channel` | 4 | `Tests`, `Examples`; all absent; positive checks pass. |
| `Matrix.PatternCompression` | 13 | `Tests`, `Examples`; all absent; positive checks pass. |
| `Optimization.Dual` | 18 | `Tests`, `Examples`, `Optimization.DualCharacterization`; all absent; positive checks pass. |
| `Optimization.DualCharacterization` | 19 | `Tests`, `Examples`; all absent; positive checks pass. |
| `Optimization.IncidenceConstruction` | 16 | `Tests`, `Examples`, `Optimization.Primal`, `Optimization.Dual`, `Optimization.DualCharacterization`; all absent; positive checks pass. |
| `Optimization.Primal` | 17 | `Tests`, `Examples`, `Optimization.Dual`, `Optimization.DualCharacterization`; all absent; positive checks pass. |
| `Probability.FiniteCoupling` | 1 | `Tests`, `Examples`; all absent; positive checks pass. |
| `Probability.FiniteCouplingDecoding` | 2 | `Tests`, `Examples`; all absent; positive checks pass. |
| `(root)` | 7 | `Tests`, `Examples`, `Matrix`, `Optimization`, `Probability.FiniteCouplingDecoding`; all absent; positive checks pass. |

Root has exactly its six documented direct imports. There is no Optimization
aggregate. C13 is tested through `Optimization.IncidenceConstruction` itself,
separately from the integrated incidence fixture. Dual→Primal and
Primal→IncidenceConstruction are intentional. Existing mathlib geometry is not
an architectural violation. No proof follows from module counts alone: receipts
retain every actual name and asserted excluded prefix. Failed scratch commands
are retained separately from successful compiler observations.

### Validation, applicability and handoff (E20–E23)

The parent freshly compiled the eleven-signature pinned reuse probe and its
four-universe structural consumer; inspected key actual construction, round-trip,
matrix and reachability assertions; and checked helper methods and identities.
The full build explicitly named all 55 maintained modules plus root (2,823 jobs);
the default target passed (2,762). These builds use cached artifacts. The required
literal placeholder scan has no matches; whitespace checks pass.

All 59 source/configuration and 112 original compiled artifact identities match
S02. Therefore its original declaration, assumption, axiom, anonymous-copy and
generated-ownership evidence remains applicable without rerunning the entire
trust audit. E20 reuses original types with explicit attribution; E21 supplies
fresh isolated compilation. No new declaration requires a new trust disposition.
Neither helper's source reading is independent review. E22 inherits the closed
S01 manuscript anchors and repairs with unchanged hashes; no new PDF sweep is
claimed. The durable E23 archive retains factual receipts and limitations.

S03 resolves DG-15 and current OM-018 handling without public promotion or a new
omission. C08/C11 private helpers and C12 OM-068 alias advice retain the concrete
consumer triggers above. The C01 upstream candidate remains owned by its approved
plan and separate library maintenance. S04 integrates these decisions into its
criterion crosswalk and short Quick Start; S05 freshly validates the whole chunk.
No numbered Future Work Note, new theorem family or publication action arises.

<a id="c16-s03-dg15"></a>
### DG-15: resolved with existing ownership

The following item-by-item disposition is supported by fresh source/assertion reads. Manuscript locations and repairs are inherited from the closed S01 crosswalk, identified by its exact ISIT/v16 source identities; no new manuscript read is claimed. The detailed rows, hypotheses, source owners, consumer observations and read receipts are in `evidence.json`.

| Item | Exact source anchor | Current owner and classification | Checked assertion and limit |
| --- | --- | --- | --- |
| Remark 1 | ISIT II-A p.2; `C16-REM01`; v16 II-A p.2 | Public: `Semantics/Canonical.lean:113–185,532–639`. Canonical-joint, coupling marginal, `exists_canonicalCoupling`, all/full-support-prior and pair-law bridges. | `Tests/Semantics/Canonical.lean:747–860` checks one specified q before all priors, exact marginals/pair, distinct full-support priors, point prior, singleton and unused outputs. Retain law reuse on fresh joints; no same-fixed-random-variable claim (OM-054/055). |
| Example 1 | ISIT II-B (8); v16 App.A Lemma7 (135)–(146) | Public: `Examples/Nonrepresentable3x3.lean:22–80`, `nonrepresentable3x3`, `_apply`, `_isSingular`, `_not_isPerfectlyRepresentableChannel`. | Direct all-witness contradiction retains both final-coordinate branches. `Tests/Examples/Nonrepresentable3x3.lean:11–80` checks all9 entries, full-support negative, point-prior positive and unused-output extension. `Nonrepresentable3x3Columns.lean:27–150` privately checks first value/pattern/indicator. No separate public Lemma7 or column-fixture alias (OM-033/057/069). |
| Example 2 | ISIT III-A, (11)→(12); `C16-EX02` | Private: `Tests/Examples/MatrixOperations.lean:132,150–207`, `example2`, `example2_real`. | Actual PPS on zero-based column1 at ratio1/2; all18 output coordinates. Shared fixture consumers400–490 check exact/Real equality, legality, all activity, singularity and row sums. |
| Example 3 | ISIT III-A, (11)→(13); `C16-EX03` | Private: same file136,268–325, `example3`, `example3_survivor`, `example3_real`. | Actual PPM of columns3,4, lower survivor3; all12 coordinates. The final source column is included under the v16 full-range repair (OM-024/070). |
| Example 4 | ISIT III-A, (11)→(14); `C16-EX04` | Private: same file93,141,209–266, `exampleMask`, `example4`, `example4_real`. | Actual VPS of column0 by[true,true,false], with both supported pieces witnessed; all18 coordinates. General value-one VPS remains allowed by its own contract. |
| Example 5 | ISIT III-A, (11)→(15); `C16-EX05` | Private: same file145,326–382, `example5`, `example5_survivor`, `example5_real`. | Actual VPM of columns0,2, equal admitted values/disjoint supports and lower survivor0; all12 coordinates (OM-024/070). |
| Example 6 | ISIT IV-A p.4; `C16-EX06` | Private: `Tests/Examples/Incidence.lean:1336–1390`, `partition_cases`, `paperPartitions`, injective/surjective proofs and `paperColumns`. | The whole block, three pair/singleton partitions and singleton partition exhaust all exact Fin3 partitions; bijective printed order and cardinal5. General Bell identity remains OM-017. |
| Example 7 | ISIT IV-A (17); `C16-EX07/EQ17` | Private: same file1384–1496, `paperRows`, `paperColumns`, `paperMatrix`, `paper_entries`, `paper_fullMatrix`, `r13Paper_submatrix`. | All35 entries in the printed7×5 order; all-pattern reduced matrix equals it. Proper reduction selects rows[0,1,2,3]/columns[1,4], giving the exact4×2 matrix and checked values/weights/zero extension. Retain full/reduced repair DG-12/OM-047. |
| v16 Example 2 | III-A pp.3–4, Example2/(12) | Same private C07 owner as ISIT Example2. | Version-specific cross-reference to its actual PPS, all coordinates and legality assertions; no second public alias. |
| v16 Example 3 | III-A pp.3–4, Example3/(13) | Same private C07 owner as ISIT Example3. | Same full-source-range PPM and exact printed result; keep the range repair explicit. |
| v16 Example 4 | III-A pp.3–4, Example4/(14) | Same private C07 owner as ISIT Example4. | Same supported-mask VPS, exact coordinates and unaffected-output assertions. |
| v16 Example 5 | III-A pp.3–4, Example5/(15) | Same private C07 owner as ISIT Example5. | Same equal-value/disjoint-support VPM and lower-survivor coordinate assertion. |
| v16 Example 6 | III-B p.5, (25)–(32); `C16-X-MATRIX-11` | Private C10 example: `Examples/Reachability.lean:26–338`, namespace `PerfectFunctionalRepresentations.MatrixOperations`. | All15 source and12/9/6/3 successive masses; actual pairs(1,2),(1,3),(0,2),(0,1). `display30Equiv:203` maps actual second output to printed(30) by swap1 2. Actual four-edge reduction[vpm,ppm,vpm,ppm], reverse[pps,vps,pps,vps], both length4; final allOnes and prior-free perfectness. The output swap is a comparison, not a fifth operation. |
| v16 Example 7 | IV-A, Example7 (35)–(38); `C16-X10` | Same private C13 owner as ISIT Example6. | Same exhaustive partition enumeration and exact count5; no general Bell/complexity theorem. |
| v16 Example 8 | IV-A, Example8 (57)–(63); `C16-X10` | Same private C13 owner as ISIT Example7. | Same full35-entry and actual reduced-submatrix/weight assertions. Both row and column restrictions remain explicit. |
| Remark 2 | ISIT p.4; `C16-REM02`, `C16-PROSE-REM02-01–04` | Documentation only: `docs/formalization-map.md` OM-010/011/012 and exact coverage-ledger rows. No Lean owner claimed. | Preserve four occurrences separately: graph-entropy equality, GPF vanishing, g0 equality, exact-zero synthesis redundancy. Theorem1 does not formalize the external measures/models. Extended VI is separately OM-032. |
| Figure 1 and caption | ISIT App. p.5 R; v16 p.5; `C16-FIG01` | Private C11 proof: `Matrix/CanonicalReachability.lean`, `auxiliaryChannel_unique_in_block`, `seedPps`, `seedPartition`, `seedVps`, `seedBridge`, `canonicalToAllOnes`, `canonicalNormalForm`. | Fresh1456–1576,1641–1729,1875–1895,2334–2376,2534–2564 checks actual q(w) PPS, exact decoder blocks, q(w)/0 VPS masses, labels/maps, literal stage composition and actual reverse. Earlier exact-hash S01/S02 evidence supplies complete active-auxiliary context. Existing public to/fromAllOnes characterizations consume it. Artwork remains OM-020. |

The operation fixtures share one real parameter `0 < b < 1`. Their `b = 0` and `b = 1` controls show why the ambient normalized channel does not instantiate the fully active example suite. Paper labels are translated to zero-based coordinates. Retain OM-026/050 and the full-range/lower-survivor repair OM-024/070; these are hypotheses and interpretation records, not invitations to promote the private fixtures.

**Consumer assessment.** The existing public Remark 1 bridges are consumed by `Semantics/Binary.lean:690`, the pair bridge in `Semantics/Canonical.lean:551`, and maintained semantic tests. The named Example 1 channel is reused by example, preservation, reachability, compression and incidence tests. Private printed-operation and paper-incidence data serve their owning fixtures; the private reachability example and C11 construction consume generic public operation/cascade/characterization APIs. No inspected maintained caller is blocked by these private owners. Keep the existing public/private split; no additional example alias or intermediate normalization/canonical helper promotion is indicated by this search. This is a bounded statement about current repository consumers, not a claim about unknown external users.

<a id="c16-s03-wrapper"></a>
### OM-018: retain the no-wrapper decision

For `κ : α → PMF β` with `[Fintype α] [Nonempty α] [Finite β]`, the mathematical decision split is already available:

- If `¬ IsSingularChannel κ`, contradiction with `IsPerfectlyRepresentableChannel.isSingular` rejects perfectness. This necessity theorem itself needs only `[Nonempty α]`, with no finite-alphabet or prior premise (`Semantics/Singularity.lean:53–71`).
- Given `hκ : IsSingularChannel κ`, `compressedPatternData κ hκ` and its ambient perfectness bridge retain inactive outputs (`Matrix/PatternCompression.lean:568–586,997–1007`). `Primal.isPerfectlyRepresentableChannel_iff_isGreatest_compressedPatternData` and `_iff_exists_objective_eq_one_compressedPatternData` (`Optimization/Primal.lean:132–148`) supply the attained primal criterion. `Dual.isPerfectlyRepresentableChannel_iff_isLeast_compressedPatternData` and its finite-presentation variant (`Optimization/DualCharacterization.lean:255–289`) supply the attained dual criterion.

Current maintained consumers explicitly supply singularity and use these endpoints: `Tests/Optimization/Primal.lean:45–55` recovers an equality-feasible vector from the existing ambient greatestness iff; `Tests/Optimization/DualCharacterization.lean:94–119` consumes supplied and canonical finite presentations; `Tests/Optimization/Incidence.lean` contains integrated support/reindex/finite-presentation callers located by the consumer search. The C11 forward construction itself derives singularity from perfectness before constructing operations. No inspected caller needs a combined existential over a singularity proof or a duplicate public conjunction of primal and dual criteria.

**S03 decision, 2026-10-03:** retain the approved no-wrapper default under the existing C16/OM-018 allocation. A combined proof-dependent existential would package existing equivalences and couple the primal/dual imports without a demonstrated blocked consumer. This is separate from executing an LP solver or extended separation-oracle complexity (OM-028), both outside this step. Reopen only when a concrete approved consumer cannot use the present case split economically; record its exact contract, hypotheses, namespace, imports and validation obligations, and obtain approval for that material revision before implementation.

**Composition evidence (E21):** the parent freshly compiled the isolated anonymous nonsingular rejection and dependent primal/dual conjunction under all five project flags. Both compose from existing APIs, with only the permitted endpoint axioms. The historical planning probe remains background; its uncaptured duplicate invocation is not used as final validation. No public declaration is added.

<a id="c16-s04-readiness"></a>
## S04 — Integrated readiness, 2026-10-03

**Checkpoint:** all three independent S04 criteria are satisfied without
findings; the original report is reconciled. Final validation is ready; completion
is subject to the durable S04 execution record. C01–C15 and C16 S01–S03 are durably
complete. S05 is unstarted. The tables below preserve the reviewed readiness
assessment; CC09 requires the separately authorized fresh cumulative pass and closure.

The parent verified all three earlier C16 closures, nine satisfied parent and
independent criteria, original-report reconciliations and exact equality of the
S03 final snapshot with the S04 startup state before accepting the conditional
S04 request once. S03 closure is
`3714a22ac31c4fe4cc56bbd1e030075a71ea081d06944375f54663c3dfdf6cad`.
The earlier sections retain their original checkpoints. Their future-tense S03
or S04 references are historical; this section is the current readiness overlay.

### Earlier step criteria

Each row identifies the detailed source/assertion owner as well as the shared
[evidence register](pfr-c16-implementation-notes.md#shared-evidence-register).
E26 onward belongs to S04. Existing mathematical evidence retains its original
actor, date and limits; unchanged hashes establish applicability, not a fresh run.

| Criterion | Current source and evidence | S04 disposition |
| --- | --- | --- |
| C16-S01-A | [Six-page sweep](pfr-c16-coverage-audit.md#page-and-paragraph-sweep) and all numbered/prose rows; E01–E05/E08–E09 | Complete: 51 numbered items and 122 prose occurrences, including nonmathematical source regions and external-result dispositions. No unclassified claim. |
| C16-S01-B | [Semantic contracts and companion dependencies](pfr-c16-coverage-audit.md#exact-local-contracts-and-source-interpretations), [matrix companion inventory](pfr-c16-coverage-audit.md#version-bound-extended-proof-dependencies), X-MATRIX-11 and [IV dependencies](pfr-c16-coverage-audit.md#extended-dependencies-for-iv); E01–E03/E06–E09 | Complete: printed/intended/Lean contracts and material assumptions, index repairs and representation choices are bound to exact ISIT/v16 digests. |
| C16-S01-C | [Omission reconciliation](pfr-c16-coverage-audit.md#omission-and-deferred-work-reconciliation), map OM-001–071 and E05/E08–E09 | Complete: all original IDs/rationale retained; no genuine gap reclassified as optional and no new omission. |
| C16-S02-A | [B01–B11 index](#boundary-index), all 29 subordinate checks and actual named/anonymous assertions; E11–E14/E16–E18 | Complete: structural, finite-information, support, numeric, matrix and optimization boundaries retain their approved strength. |
| C16-S02-B | [Complete declaration and trust inventory](#complete-declaration-and-trust-inventory); E13/E15–E18 | Complete: all 56 owners, source/compiled/private/generated/instance/anonymous inventories, diagnostic controls, transitive axioms and safety investigations are reconciled. Exact methods and limitations remain explicit. |
| C16-S02-C | [Per-module reconciliation](#per-module-reconciliation) and E14/E17–E18; S03 E23/E25 | Complete: all 55 separately maintained modules plus root built, as did the default target. S04 checks current source/configuration/compiled identities and default build; prior all-module receipts stay applicable. |
| C16-S03-A | [Complete API/import audit](#c16-s03-api), 935 public source-named declarations in all 56 owners and 28 isolated actual import closures; E19–E21/E23–E25 | Complete: public generality, ownership and pinned reuse resolved; positive consumers and explicit exclusions checked. No Lean/API/import change was needed. |
| C16-S03-B | [DG-15 item audit](#c16-s03-dg15), all 17 version-specific items; E19/E22/E24–E25 | Complete: exact public/private/fixture/documentation owners and assertions recorded without promotion. |
| C16-S03-C | [OM-018 decision](#c16-s03-wrapper), actual consumers and compiled composition; E21–E25 | Complete: no wrapper, precise finite nonempty-input LP domain, weaker necessity theorem retained, concrete reconsideration trigger recorded. |

### Boundary and regression crosswalk

These eleven rows include every subordinate check already recorded above. Each
linked row identifies original production statements and actual maintained
regression assertions. E11/E12 are source/signature inspection, E13 is the
compiled and copied-anonymous audit, E14/E17 are original module builds/review,
and E18/E20/E25/E28 establish later applicability. This table adds no new theorem
or test requirement and does not convert copied elaborations into maintained
public declarations.

| Boundary | Source/assertion owner | Completion criteria |
| --- | --- | --- |
| [C16-B01](#c16-b01) | FunctionalRepresentation/Canonical: independent universes, unrestricted source, finite information and full triple law; three subordinate checks | CC02–CC05 |
| [C16-B02](#c16-b02) | FunctionalRepresentation/Canonical/Singularity/Binary: support-only decoders, all-row posterior, prior/support transport and full-support converse; four checks | CC02–CC05 |
| [C16-B03](#c16-b03) | Pinned null conventions, Canonical/Binary and CanonicalReachability: zero-weight fibers and unused outputs; four checks | CC02–CC05 |
| [C16-B04](#c16-b04) | Semantic, raw/active matrix and incidence/primal/dual carriers: empty/singleton cases, empty admissible family, objective images; six checks | CC02–CC05 |
| [C16-B05](#c16-b05) | Singularity/Channel/PatternCompression: restriction, injection, dependent data round trips and every ambient coordinate; three checks | CC02–CC05 |
| [C16-B06](#c16-b06) | FiniteCoupling/Channel/PatternCompression/incidence: finite mass conversion, total division at zero, positive legal ratios and row sums; four checks | CC02–CC05 |
| [C16-B07](#c16-b07) | Operations/OperationPaths/OperationCalculus: strict PPS, legal value-one VPS, all merge indices, directed inverses and finite normalization | CC02–CC05 |
| [C16-B08](#c16-b08) | Channel/Operations/PatternCompression/incidence/primal/dual: independent noninvolutive reindexing, all-vector inverses and entire objective images | CC02–CC05 |
| [C16-B09](#c16-b09) | Incidence: both row and partition restrictions, nonnegative equality feasibility, counts, mixed-system and signed controls | CC02–CC05 |
| [C16-B10](#c16-b10) | Primal/Dual/DualCharacterization: distinct feasibility predicates, attained extrema, empty constraints and positive correction | CC02–CC05 |
| [C16-B11](#c16-b11) | Partitions/MultiwayOperations/CanonicalReachability/IncidenceConstruction: exact blocks, active labels and actual retained paths/endpoints | CC02–CC05 |

### Completion matrix

| ID | Current readiness and source/evidence basis | Remaining work |
| --- | --- | --- |
| C16-CC01 | Established by C16-S01-A: unchanged complete source ledger, six-page sweep and E01–E09. All 51 numbered and 122 prose rows retain individual dispositions. | S05 independently rechecks the integrated ledger. |
| C16-CC02 | Established by C16-S01-B and S02-A: exact source identities, every version-bound companion dependency, explicit intended contracts, and all B01–B11 assumption/repair rows. | S05 rehashes originals and freshly reassesses the required anchors. |
| C16-CC03 | Established by C16-S02-A: all eleven boundary rows and 29 subordinate assertions; E11–E14/E17–E18. No weakened result or hidden premise. | S05 freshly checks all required boundary/regression evidence. |
| C16-CC04 | Established by C16-S02-B/C: complete source and original compiled-owner inventory, all anonymous copies and generated controls, safe project dependencies, allowed axioms, complete maintained-module/default builds. E13–E18/E20/E23–E25 remain applicable under E28 identities. | S05 freshly repeats the cumulative trust/build duties with honest original-versus-copied attribution. |
| C16-CC05 | Established by C16-S03-A: complete public-surface disposition, all isolated production/example closures, positive availability checks, explicit root/C13/Primal/Dual exclusions, pinned reuse and no unnecessary public helpers. | S05 freshly rechecks actual imports, types and ownership. |
| C16-CC06 | Established by C16-S03-B/C: all 17 DG-15 items resolved, existing fixture visibility retained and approved no-wrapper default confirmed by current consumers. | S05 independently reassesses the retained decisions. No wrapper implementation is pending. |
| C16-CC07 | [Dated disposition register](#c16-s04-dispositions), unchanged OM-001–071, original planning advice and current Future Work Notes register; E26–E28. Every useful open direction has an existing owner and trigger. | S05 verifies the integrated dispositions. No correctness/acceptance concern is deferred. |
| C16-CC08 | Current owning documents and short Quick Start agree; historical context has preserved owner links, earlier plans/notes and omission rationale are unchanged; E26–E28 and [navigation record](#c16-s04-navigation). | S04 review/finalization and S05 fresh cumulative verification. No required documentation implementation is assigned to S05. |
| C16-CC09 | **Pending S05.** Earlier closed steps and favorable reviews are prerequisites only. | Separate request, fresh independent cumulative validation, original-report reconciliation, current final evidence and supported durable C16 closure. |

S05 is a verification/closure step. The tables above leave no known required
mathematical, source, API or documentation implementation unfinished. New evidence
of a genuine gap must be investigated under the approved revision policy; it
cannot be recast as a convenient omission or closed from these tables alone.


<a id="c16-s04-dispositions"></a>
## S04 — Dated suggestion and deferral dispositions, 2026-10-03

This reconciles the original advice and standing deferrals; it does not reopen completed C01–C15 contracts. Original planning notes retain attribution: C13–C15 parent and supplied General Assistant suggestions are distinct from installed-review findings. C16 R01/R02 are the installed revision-1 findings; P01–P05 are the parent assessment; GA01/GA02 are the supplied General Assistant advisory. Earlier checkpoints keep their historical meaning.

The implementation helper freshly checked all 171 inherited source/configuration/compiled identities and all 56 S03 source owners. Earlier consumer/compiler results are reused under those identities with their original actors; the helper ran no compiler and performed no review or workflow action. The complete source/hash/command record is in `tmp/c16-s04/dispositions-helper/evidence.json`.

**Parent integration, 2026-10-03:** GA01 is implemented in the concise current
Quick Start. The [navigation record](#c16-s04-navigation) identifies preserved
history; the [readiness matrix](#c16-s04-readiness) covers every earlier criterion,
B01–B11 and CC01–CC08. Current source identity/build and documentation checks are
E26–E28. Independent S04 review/finalization and S05 cumulative validation remain
explicit acceptance duties.

### Original suggestion families

#### C13

Original reference: [C13 planning advice](pfr-c13-planning-notes.md#revision-2-advice-dispositions), original lines 198–234 (revision-2 advice dispositions; parent P01–P04 and supplied General Assistant advisory GA01–GA03, not installed-review findings).

| Original ID | Dated disposition | Implementation / owner and trigger |
| --- | --- | --- |
| C13-P01, C13-GA01 | **implemented**. Correct the impossible repeated supported-decoder partition image; distinct partitions share a block. No new public injectivity API. | Tests/Examples/Incidence.lean:819–1234 and 1452–1496: actual sharedData decoder/common-posterior, R13 weights, five leaves, shared-block merge and exact 7×5 to 4×2 reduction; C13 readiness:147–156. Owner: Completed C13 S03/S04/S05; retained S01 source coverage and S03 API/DG-15 evidence. Revisit: None: resolved within the existing scope. |
| C13-P02 | **implemented**. R14 separates nonempty admissible family from nonnegative equality feasibility; all five partitions exist but the required singleton coefficient is −1/4. | Tests/Examples/Incidence.lean:387–552, 1549–1643: obstructed data, signed equality, negative coordinate, no attained primal value one. Owner: Completed C13 S02/S04/S05; C14 signed control retains the same datum. Revisit: None: resolved within the existing scope. |
| C13-P03 | **implemented purpose; alternative declined**. Adopted early positive proper-reduction coverage. Separate proposed 5×3 numerical fixture declined in favor of GA03 R13, which also exercises shared blocks and an actual merge. | C13 readiness:147–156; Tests/Examples/Incidence.lean:1033–1234 and 1452–1496. Owner: Completed C13 fixture disposition; C16 S01/S03 retained coverage. Revisit: Reopen only for a newly demonstrated coverage gap; the rejected fixture is not an outstanding task. |
| C13-P04 | **implemented**. Retain coefficient-specific same-construction phases and the actual VPS-to-PPM label map. NormalForm alone does not encode these data. | Optimization/IncidenceConstruction.lean:26–56,314–384; Tests/Examples/Incidence.lean:1033–1234. Public dependent phases consume actual C10 labelled paths. Owner: Completed C13 S04; source/consumer disposition S03-API-D02/D03. Revisit: None: resolved within the existing scope. |
| C13-GA02 | **implemented**. R08 separately rejects the full vector (1,0,0,0,2), accepts its reduced restriction, and proves extension returns (1,0,0,0,0), not the infeasible original. | Tests/Examples/Incidence.lean:2358–2582; r08Bad_not_fullFeasible, r08Restricted_feasible, r08Extended_ne_bad and exhaustive printed-coordinate assertion. Owner: Completed C13 S02/S05; C16 B09. Revisit: None: resolved within the existing scope. |
| C13-GA03 | **implemented**. Keep R09 zero-coefficient coverage and R13 weights 1/3 and 2/3; R13 has two PPS outputs, five VPS leaves, four patterns and an unequal-mass shared-block PPM merge. | Tests/Examples/Incidence.lean:1033–1252,1452–1547; r13Positive_card, r13Blocks_card and actual phase consumers. Owner: Completed C13 S02–S05; C16 B11 and DG-15. Revisit: None: resolved within the existing scope. |

#### C14

Original reference: [C14 planning advice](pfr-c14-planning-notes.md#revision-2-advisory-decisions--2026-10-01), original lines 151–220 (revision-2 parent suggestions and supplied General Assistant advisory; original private source paths retained there).

| Original ID | Dated disposition | Implementation / owner and trigger |
| --- | --- | --- |
| C14-P01, C14-GA01 | **implemented**. Signed equality and objective one are insufficient: the R06 vector has a −1/4 coordinate and fails Primal.Feasible. | Tests/Examples/Incidence.lean:1613–1643; c14Signed_eq, c14Signed_objective, c14Signed_not_feasible. Owner: Completed C14 S02; C16 B09. Revisit: None: resolved within the existing scope. |
| C14-P02 | **implemented; extra fixture recipe declined**. Entire attained objective-image equality and inverse coefficient transport are implemented. Two additional permutation fixtures were declined as redundant with GA02; R05 retains zeros. | Optimization/Primal.lean:151–192 objectiveValues_reindex and feasible_reindex_iff; Tests/Examples/Incidence.lean:1703–1842; C14 readiness:93–96. Owner: Completed C14 S03/S04; C16 B08/S03 import consumers. Revisit: Reopen an extra fixture only for a demonstrated detector gap. C15 adds its required dual-specific detector, not the declined recipe. |
| C14-P03 | **implemented**. One private arbitrary-coefficient slack identity feeds the objective bound and equality saturation. | Optimization/Primal.lean:63–96: inputMatrix_mulVec_slack used by objective_le_one and objective_eq_one_iff. Owner: Completed C14 S01/S02; keep one-off algebra private. Revisit: None: resolved within the existing scope. |
| C14-P04 | **implemented**. Singleton, zero rejection and empty-admissible-family fixtures were staged with elementary LP facts, then saturation/perfectness. | Tests/Optimization/Incidence.lean:284–332 SingletonFixture and 711–762 EmptyFixture, C14 R02–R04; C14 readiness:93; C16 B04/B10 source rows. Owner: Completed C14 S01/S02; C16 B04/B10. Revisit: None: resolved within the existing scope. |
| C14-P05 | **implemented**. An isolated C13-only consumer establishes the import boundary even though shared tests also import Primal. No fixture split is needed. | C14 readiness:96 records original S03 and fresh S04 runs; C16 E21 freshly checks isolated production closures/consumers. This helper does not relabel those compiler runs as its own. Owner: Completed C14 S03/S04 and C16 S03; C16 S05 fresh import pass remains required. Revisit: None: resolved within the existing scope. |
| C14-GA02 | **implemented**. One nonconstant feasible vector (1,2,3,4,5)/40 detects both inverse orientations: transported coefficient 4/40 versus wrong 5/40; product 8/40 versus wrong 7/40. | Tests/Examples/Incidence.lean:1703–1810; c14ScaledWeights, c14ScaledRows, c14ScaledColumns and actual zero-coordinate assertions. Owner: Completed C14 S03; C16 B08. Revisit: None: resolved within the existing scope. |

#### C15

Original reference: [C15 planning advice](pfr-c15-planning-notes.md#revision-2-advisory-dispositions), original lines 202–245 (revision-2 parent P01–P03 and supplied General Assistant GA01/GA02; not installed-review findings).

| Original ID | Dated disposition | Implementation / owner and trigger |
| --- | --- | --- |
| C15-P01 | **implemented**. Signed dual (2,2,2,−1,−1,−1,1) passes column inequalities and gives −1/4 but is rejected by coordinate nonnegativity. | Tests/Examples/Incidence.lean:1844–1891: c15SignedDual_products, c15SignedDual_objective and c15SignedDual_not_feasible. Owner: Completed C15 S01; C16 B09/B10. Revisit: None: resolved within the existing scope. |
| C15-P02, C15-GA01 | **implemented**. Private R07 normalization is checked in its actual owner; external arithmetic and public existential consumers remain distinct. No claim that the existential theorem chooses the explicit numerical vector; no private promotion for testing. | Optimization/DualCharacterization.lean:99–214: cardinality, correction_signs, corrected_gaps, normalized_certificate, positive denominator. Tests/Examples/Incidence.lean:1974–2158: raw threshold −9/4, denominator 63/2, objective 125/126 and products ≥127/126. C16 E13 original-owner audit applies under identical source/artifacts. Owner: Completed C15 S02/S05; C16 B06/B10 and trust inventory. Revisit: None: resolved within the existing scope. |
| C15-GA02 | **implemented**. Finite leastness/perfectness corollaries belong in DualCharacterization; algebraic coordinate/image transport remains in Dual. | Optimization/DualCharacterization.lean:264–287: isPerfectlyRepresentableChannel_iff_isLeast_reindex and ..._compressedPatternData_reindex. S03 isolated module closure agrees. Owner: Completed C15 S04; C16 S03 public/import ownership. Revisit: None: resolved within the existing scope. |
| C15-P03 | **implemented clarification; unused route remains unselected**. Compact-singleton separation is only an alternate interface if the pinned point theorem calls for it, not an independent closure/separation escape hatch. The actual proof uses point-versus-closed-hull separation. | Optimization/DualCharacterization.lean:53–97 proves hull convexity/compactness/closedness then calls geometric_hahn_banach_point_closed. No cone/LP strong-duality route is adopted. Owner: Completed C15 S02 proof-route choice; OM-039 owns any general library work. Revisit: Revisit only under separately approved generic-duality scope or a concrete failure of the specialized route after an approved dependency change. |

#### C16

Original reference: [C16 planning advice](pfr-c16-planning-notes.md#suggestion-dispositions-pending-the-leads-decision), original lines 185–261,263–327; approved C16 plan Section6; original finding pfr-finding:c16-plan-r1-generated-inventory-controls-20261002.

| Original ID | Dated disposition | Implementation / owner and trigger |
| --- | --- | --- |
| C16-R01 | **implemented; required S05 rerun**. Retained generated-name controls and reconciled lookup/enumeration/owner differences without a fixed declaration-count completeness rule. | C16 readiness:518–739, especially634–651; E13/E15/E16; S02 original 6534 owner entries and full-context anonymous-copy reconciliation. Distinguishes cached generated names from owner proof availability. Owner: C16 S02-B completed; S05-B owns the fresh cumulative pass. Revisit: Authorized S05 or a relevant source/compiler/dependency change; S04 does not discharge S05. |
| C16-R02 | **implemented; required S05 rerun**. Explicit actual module exclusions are checked in isolated processes. Intended Dual→Primal→IncidenceConstruction dependencies remain allowed. | C16 E21: 28 isolated module closures, nine positive consumers, exact exclusion matrix; no forbidden project modules. Shared fixtures are not absence evidence. Owner: C16 S03-A completed; S05-B owns fresh import evidence. Revisit: Authorized S05 or an actual import/public-API change. |
| C16-P01 | **implemented; continuing evidence duty**. Shared evidence IDs record actor, commands, identity, result and limits once, with coverage/readiness links. Historical reviewer results retain their actor. | C16 implementation-notes shared registers E00–E25 and coverage/readiness crosslinks. Owner: C16 implementation notes; S04/S05 append their own evidence. Revisit: Each new check or source-applicability claim; no new registry or duplicate evidence document. |
| C16-P02 | **implemented for S03; S04 applicability continuing**. No Lean/API/import change in S03. Retained S02 evidence has exact source/configuration/artifact applicability; documentation edits require an impact assessment. S05 still needs the full fresh pass. | C16 E20/E23/E25; this helper freshly compares all 171 S02 identities and all 56 S03 source hashes. Parent owns final S04 applicability after document integration. Owner: C16 S03-C completed; S04-C and S05 validation owners. Revisit: Any actual source/import/API/configuration change requires affected rechecks; doc-only edits require impact assessment. |
| C16-P03 | **implemented; standing authorization contract**. Approval of the exact revision and one eligible request for one step remain separate; material revisions need approval. | Approved C16 plan Sections1/8; revision-2 selection. This helper neither verifies new request processing nor asserts workflow closure. Owner: Implementation parent and installed review protocol for each step. Revisit: Every subsequent step request or material contract revision. |
| C16-GA01 | **implemented in S04; review pending**. Shorten Quick Start to current state/decisions/plan/limits/reading routes; link retained history without deleting unique context or curating OM records. | Approved S04-A/CC08 duty. The parent integrated the short Quick Start and checked preservation against the linked history routes. Owner: Current S04-A: living summary and parent documentation reconciliation. Revisit: Keep current status and focused reading routes concise; future historical detail belongs in the owning notes/log. S04 review/finalization remains required. |
| C16-GA02 | **implemented**. The full LP case split is finite/nonempty: Fintype input, Nonempty input, Finite ambient output. General singularity necessity keeps its weaker Nonempty-only domain. | C16 plan4.2; C16 B04 and S03 no-wrapper audit; actual Optimization/DualCharacterization.lean and Optimization/Primal.lean ambient types and Semantics/Singularity.lean necessity. Owner: C16 S02/S03 completed; keep qualifiers in S04 current prose. Revisit: None: resolved within the existing scope. |
| C16-P04 | **declined extra prescribed format; underlying duty completed**. No extra coverage-status system or parallel table. Existing modes, actor/evidence provenance and unresolved-issue fields distinguish correspondence and verification. | S01 complete source ledger; S02/S03 evidence and limits; revision-2 decision. S04 must not leave a required check pending behind a status label. Owner: C16 S01-A/S04-C. Revisit: Reconsider formatting only if an actual ledger row remains ambiguous; no such additional format is required by the accepted plan. |
| C16-P05 | **declined duplicate catalog; underlying duty completed**. No second exhaustive reverse-API table. S03 disposes every public source-named surface and separately retains generated trust entries. | S03 E20: all56 owners,935 public source names mapped once; generated imported names are not mistaken for designed PFR APIs. Owner: C16 S03-A/readiness API disposition. Revisit: Investigate a concrete unmatched public declaration in the existing owner; no unmatched mapping in retained S03 evidence. |

### Existing API decisions, mapped exclusions and roadmap work

| Original owner/reference | Current disposition | Owner / revisit trigger |
| --- | --- | --- |
| C01 approved plan Section8; original project-log upstream ownership note; C16 S03-API-D05 | **retained local API; upstream work separately deferred**. isIndependentOf_comp_right remains a four-universe PMF-first public local theorem. Current consumers justify it. Pinned mathlib measurable composition plus LIT bridge is an alternative; bounded search absence is not mathematical impossibility. The same original Section8 also notes Equation(2) may be reusable, but its current owner remains C01 as an exact manuscript anchor; no upstream family is authorized. | C01 Section8 / separately authorized LeanInfoTheory maintenance owner. Trigger: A separately authorized maintenance/release window or another concrete consumer; re-search current APIs and review naming, generality, compatibility and immutable release adoption separately. |
| C08 approved private-factorization decision; OM-042/052; C16 S03-API-D02 | **no promotion; current consumers satisfied**. Private finite trees/certificates stay private. Public OperationPath.normalize/Cascade.normalize and NormalForm fields suffice; C10/C13 labelled endpoints are separately public. | Existing C08/C10/C11 interface owners and OM-052. Trigger: An approved concrete consumer needs a certificate/tree property unavailable through the current public result; audit access or test relocation alone is not a trigger. |
| C11 private canonical-construction decision; OM-021/042/045/052; C13 advice; C16 S03-API-D03 | **no promotion; current consumers satisfied**. Canonical composites stay private. Two public reachability iff endpoints, public posterior witnesses and C10/C13 retained construction phases serve current consumers. | C11/OM-045/052 and the existing C13 API-advice disposition. Trigger: An approved consumer demonstrably needs the particular C11 canonical witness rather than existence/perfectness or an actual C10/C13 construction. |
| C12 approved plan Section9 optional idempotence alias; OM-068; C13 S04/S05 decline; C14/C15 retained decisions; C16 S03-API-D04 | **declined for current consumers; historical optional suggestion retained**. Existing full dependent extraction_roundTrip and compressedPatternData_map_injective suffice; no new alias. Earlier deferred wording is historical, not an unresolved promise. | OM-068 and the next approved concrete consumer owner. Trigger: Fresh demonstrated interface friction blocks an approved consumer; neither audit convenience nor a theoretical alias opportunity suffices. |
| C14/C15 wrapper deferral; C16 approved4.2; OM-018; S03 no-wrapper decision | **no wrapper; executable solver separately deferred**. Existing nonsingular rejection and finite singular primal/dual endpoints compose. No single new public wrapper is justified; preserve exact finite/nonempty qualifiers. | C16 S03 decision in OM-018; solver work remains roadmap-owned. Trigger: A concrete approved consumer blocked by the existing composition; any wrapper implementation needs a revised approved contract. Solver software needs separate scope approval. |
| DG-15; OM-020/026/027/033/042/069; C16 S03 example audit | **resolved existing ownership; public promotion not needed**. Retain the deliberate four-name public C03 counterexample, public Remark1 bridges, private paper-coordinate/operation/reachability fixtures and private proof intermediates. Source coverage does not require one public name per printed line. | Current mathematical owner for each item; C16 S03/readiness disposition. Trigger: Demonstrated approved downstream consumer pressure, assessed with the original source allocation; no publication curation without separate approval. |
| OM-001–006/008–013/015/041; project-scope paper boundary | **excluded or documentation-only**. Cited representation/external bounds, rates, minimum-entropy literature, privacy, common-information, graph-entropy/funnel/redundancy equivalences and textbook attribution are not claimed formalized. OM-013’s local definition is implemented; the cited textbook lemma is not. | Formalization map / project-scope; any new external development needs a separately approved mathematical owner. Trigger: Explicit project-lead scope approval; no automatic trigger from nearby source prose or publication cleanup. |
| OM-007 cited deterministic special cases | **optional local corollary excluded from current targets**. The semantic API is stable, but no C16 consumer needs a new public special-case corollary. Do not import the cited paper’s development. | Semantic API owner / formalization map OM-007. Trigger: An approved concrete local consumer makes the low-cost corollary useful after semantic stabilization; no promise to implement it. |
| OM-016/017/019; C13 finite-count ownership | **finite mathematics implemented; general enumeration/runtime excluded**. Exact card_nonzeroPattern/patterns_card_le and the five-partition Fin3 classification are complete. General Bell identity/growth, linear/exponential runtime and efficient-solvability claims remain documentation-only or excluded. | C13 owns completed finite counts; map/roadmap owns algorithmic scope. Trigger: Separately approved enumerative or executable-algorithm work with a specified complexity model. |
| OM-028–032/034; roadmap later directions; project-scope | **extended-only work excluded**. Separation-oracle recurrence and runtime, hardness/exact-optimization reductions, coloring/bounded-degree restrictions and broader information measures remain excluded. Extra conclusions/bibliography create no duplicate theorem target; literal suppressed constraints/attainment in OM-032 remain unaccepted. | Project lead and formalization map for a separately approved extended-scope chunk. Trigger: Explicit new scope approval followed by re-reading the then-current companion and resolving its exact contracts. |
| OM-039/046; C15 proof-route decision | **specialized targets completed; general framework excluded**. Specialized finite hull alternative, attained greatestness/leastness and coordinate images suffice. No general LP/conic strong-duality library or unrelated global optimizer is promised. | Existing C14/C15 target owners; separate reusable-library owner required for broader work. Trigger: Explicit scope/ownership review based on a genuine reusable need; not needed for current Corollary1 acceptance. |
| OM-038; C07/C08/C10 raw-pruning deferral | **no raw-pruning API; legal constructors complete**. Public legal VPS keeps both selected-support pieces nonempty. C10 exact-partition synthesis derives those guards and current consumers need no raw-zero-child pruning bridge. | C08/C10 approved consumer owner and OM-038. Trigger: A concrete approved consumer needs a raw-pruning bridge; a globally nonconstant mask alone is not legal VPS evidence. |
| OM-043; C08 approved plan Section11; C12 plan Section9 | **structural normalization implemented; stronger algorithmic contracts excluded**. Finite factorization and realization justify normalization even when local rewrites lengthen paths. Arbitrary rewrite-strategy termination, canonical/shortest form, uniqueness, confluence and complexity are not asserted. | OM-043 and a separately approved algorithmic consumer owner. Trigger: Explicit approval for an algorithmic consumer with the exact additional contract; existing existential normalization is not a termination claim for every strategy. |
| OM-035 and roadmap optional bits presentation | **conversion available; extra presentation separately deferred**. LeanInfoTheory nats remain canonical. Existing nats-to-bits conversion does not authorize a duplicate hierarchy. | Paper-facing presentation owner / OM-035. Trigger: An approved paper-facing presentation requires the optional bits layer. |
| Roadmap later tagged LeanInfoTheory release; AGENTS and project-scope version policy | **separately deferred**. Keep immutable LeanInfoTheory v0.1.0 and pinned Lean/mathlib. No upgrade or upstream migration in C16. | Separately authorized dependency-maintenance step. Trigger: Explicit upgrade approval, release/API review and full validation against the selected immutable release. |
| Roadmap completion/release direction and later directions; C16 non-goals | **separately deferred**. Rights/licensing/citation metadata, remote/distribution validation, website, DOI and final publication metadata remain release-readiness work. No PFR website/source/Pages/hosting configuration or approved website plan is claimed. | Project lead / separately authorized release-readiness phase. Trigger: Explicit release-preparation approval and verified metadata/rights; C16 completion alone is not release authorization. |
| C16 Section6; complete map Section9; S01 71-row audit | **retained; no curation**. All OM-001–071 and their rationale/history remain canonical. OM-070 remains an explicit duplicate cross-reference to OM-024; no silent merge/delete. This register does not duplicate the71 rows. | S04 map/document integration; future public curation separately approved. Trigger: Any new justified omission gets a new immutable ID; publication-facing condensation needs explicit approval and logged meaningful rationale preservation. |
| docs/project-log.md:11–34 authoritative Future Work Notes register | **empty register confirmed**. No numbered Future Work Notes have been opened. All suggestions above already have owners; no worthwhile unmapped advice was identified in this bounded reconciliation. | Project log owns full stable-numbered notes; living summary owns normalized status. Trigger: A worthwhile suggestion without an existing map/plan owner requires a new immutable-numbered note; S05 rechecks the register. |

All 28 required C13–C16 suggestion identifiers are represented, including combined rows that preserve both origins. All 71 omission IDs remain individually owned by the map; OM-070’s duplicate relationship to OM-024 is retained. This section summarizes dispositions without reproducing or curating that register. The authoritative Future Work Notes register still has no numbered notes; no new unmapped useful advice was identified in this bounded check.

Current source supports the prior private-helper, alias and no-wrapper decisions. Reopening a declined option requires the stated concrete need; an exclusion requires separate scope approval. None of these optional or separately scoped items removes a current mathematical correctness or acceptance obligation.

<a id="c16-s04-navigation"></a>
## S04 — Navigation and preserved history, 2026-10-03

The Quick Start now contains current completion/remaining duties, the active
plan, essential limits and focused reading routes. Historical narratives were
navigation copies of already preserved records. A bounded implementation-helper
inspection allocated every old Quick Start line 26–842 in 58 contiguous blocks,
checked all 56 full hashes/task IDs from Quick Start/validation history against
maintained notes/log, and traced distinctive recovery/advice histories to their
owners. The parent inspected the resulting routes and retained current
mathematical limits in the living summary and source/readiness audits.
No unique historical context needed a new narrative archive.

The detailed relocation map and actual read/hash receipts are factual S04
evidence, preserved privately with E27/E28. The table below is the maintained
navigation replacement. Original C01–C15 plans/notes and earlier C16 audit bodies
are unchanged. A pre-F record describes its own checkpoint; the next owner's
verified handoff establishes later durable completion. No original failure or
review limitation is upgraded by removing a duplicated status paragraph.

| Completed owner | Preserved original work / review record | Later closure verification |
| --- | --- | --- |
| <a id="c16-history-c01"></a>C01 | [Approved contract](plans/pfr-c01-semantic-functional-representations.md); [C01 completion and review](project-log.md#31-pfr-c01-s08-independent-validation-and-chunk-completion---2026-09-07) | [C02 startup](project-log.md#36-pfr-c02-reviewer-establishment-and-proposed-plan---2026-09-10) |
| <a id="c16-history-c02"></a>C02 | [Approved contract](plans/pfr-c02-canonical-representations.md); [C02 implementation notes](pfr-c02-implementation-notes.md) | [C03 verified predecessor](pfr-c03-planning-notes.md) |
| <a id="c16-history-c03"></a>C03 | [Approved contract](plans/pfr-c03-singularity-binary-output-counterexample.md); [C03 implementation](pfr-c03-implementation-notes.md) / [planning](pfr-c03-planning-notes.md) | [C04 prerequisite verification](pfr-c04-planning-notes.md) |
| <a id="c16-history-c04"></a>C04 | [Approved contract](plans/pfr-c04-finite-total-variation-maximal-coupling.md); [C04 implementation](pfr-c04-implementation-notes.md) / [planning](pfr-c04-planning-notes.md) | [C05 prerequisite verification](pfr-c05-planning-notes.md) |
| <a id="c16-history-c05"></a>C05 | [Approved contract](plans/pfr-c05-binary-input-lemma3.md); [C05 implementation](pfr-c05-implementation-notes.md) / [planning](pfr-c05-planning-notes.md) | [C06 prerequisite verification](pfr-c06-planning-notes.md) |
| <a id="c16-history-c06"></a>C06 | [Approved contract](plans/pfr-c06-finite-channel-matrix-boundary.md); [C06 implementation](pfr-c06-implementation-notes.md) / [planning](pfr-c06-planning-notes.md) | [C07 prerequisite verification](pfr-c07-planning-notes.md) |
| <a id="c16-history-c07"></a>C07 | [Approved contract](plans/pfr-c07-four-typed-matrix-operations.md); [C07 implementation](pfr-c07-implementation-notes.md) / [planning](pfr-c07-planning-notes.md) | [C08 prerequisite verification](pfr-c08-planning-notes.md) |
| <a id="c16-history-c08"></a>C08 | [Approved contract](plans/pfr-c08-operation-paths-lemma4-normalization.md); [C08 implementation](pfr-c08-implementation-notes.md) / [planning](pfr-c08-planning-notes.md) | [C09 prerequisite verification](pfr-c09-planning-notes.md) |
| <a id="c16-history-c09"></a>C09 | [Approved contract](plans/pfr-c09-representability-preservation.md); [C09 implementation](pfr-c09-implementation-notes.md) / [planning](pfr-c09-planning-notes.md) | [C10 prerequisite verification](pfr-c10-planning-notes.md) |
| <a id="c16-history-c10"></a>C10 | [Approved contract](plans/pfr-c10-generic-reachability-easy-direction.md); [C10 implementation](pfr-c10-implementation-notes.md) / [planning](pfr-c10-planning-notes.md) | [C11 prerequisite verification](pfr-c11-planning-notes.md) |
| <a id="c16-history-c11"></a>C11 | [Approved contract](plans/pfr-c11-theorem1-canonical-coupling.md); [C11 implementation](pfr-c11-implementation-notes.md) / [planning](pfr-c11-planning-notes.md) | [C12 prerequisite verification](pfr-c12-planning-notes.md) |
| <a id="c16-history-c12"></a>C12 | [Approved contract](plans/pfr-c12-active-pattern-compression-real-bridge.md); [C12 implementation](pfr-c12-implementation-notes.md) / [planning](pfr-c12-planning-notes.md) | [C13 prerequisite verification](pfr-c13-planning-notes.md) |
| <a id="c16-history-c13"></a>C13 | [Approved contract](plans/pfr-c13-exact-partitions-incidence-systems.md); [C13 implementation](pfr-c13-implementation-notes.md) / [planning](pfr-c13-planning-notes.md) | [C14 prerequisite verification](pfr-c14-planning-notes.md) |
| <a id="c16-history-c14"></a>C14 | [Approved contract](plans/pfr-c14-primal-characterization.md); [C14 implementation](pfr-c14-implementation-notes.md) / [planning](pfr-c14-planning-notes.md) | [C15 prerequisite verification](pfr-c15-planning-notes.md) |
| <a id="c16-history-c15"></a>C15 | [Approved contract](plans/pfr-c15-dual-characterization.md); [C15 implementation](pfr-c15-implementation-notes.md) / [planning](pfr-c15-planning-notes.md) | [C16 prerequisite verification](pfr-c16-planning-notes.md) |

Additional targeted routes preserve the distinctive procedural history:

- [C05 original format correction and failed-probe limits](pfr-c05-planning-notes.md#original-reports-format-correction-and-evidence-limits).
- C06 finding-ID recovery remains in its [implementation notes](pfr-c06-implementation-notes.md) and dated log; the [installed identity-correction rule](review-operations.md#explicit-finding-id-correction) remains authoritative for current operation.
- [C10 report-admission limit](pfr-c10-planning-notes.md#report-custody-and-admission-limit), with skipped/unauthorized requests retained in [implementation notes](pfr-c10-implementation-notes.md).
- C12 invocation refusal and linked review-time-readiness reassessment remain in [implementation notes](pfr-c12-implementation-notes.md); C13's prerequisite record verifies subsequent closure.
- [C13](pfr-c13-planning-notes.md#revision-2-advice-dispositions), [C14](pfr-c14-planning-notes.md#revision-2-advisory-decisions--2026-10-01), [C15](pfr-c15-planning-notes.md#revision-2-advisory-dispositions) and [C16](pfr-c16-planning-notes.md#revision-2-selection-and-dispositions--2026-10-02) retain original advice and selections.
- C16 [S01/S02/S03 evidence](pfr-c16-implementation-notes.md) retains all original observations; the S04 startup check above verifies later S03 closure. The [source identity history](perfect-functional-representations-living-summary.md#10-reference-and-provenance-boundary) retains the missing/recovered ISIT-copy caveat.

README now supplies current scope/build/navigation; project scope keeps inclusion
and dependency policy; the roadmap distinguishes complete mathematical work,
current closure and separately authorized directions. The map gives current
overlays for each complete chunk while preserving original allocation/checkpoint
and all omission prose. Its C16 allocation now explicitly preserves the internal
register and routes publication-facing curation to separate approval, matching
the approved contract. These are current navigation changes, not edits to frozen
plans, reviewed evidence or omission rationale.

<a id="c16-s05-readiness"></a>
## S05 — Fresh cumulative assessment, 2026-10-03

**Current checkpoint:** complete cumulative validation and corrected-source
independent review pass. All three S05 criteria are satisfied; both original
reports are reconciled. Final status is provisional until applicable final checks
and supported durable closure establish CC09. This section supersedes historical
current-status wording above without changing the earlier reviewed records.
Evidence E31 onward is owned by the [S05 implementation record](pfr-c16-implementation-notes.md#s05--fresh-cumulative-validation-and-closure).

### Earlier criteria reassessed from current source

The parent freshly viewed all six original ISIT pages, then integrated fresh
semantic and matrix proof/fixture inspections with its own detailed LP pass.
Both manuscript hashes match the approved originals. Individual row allocation
and the page sweep supplement one another; counts alone do not establish coverage.
No mathematical, API, import or dependency change is required. One companion
locator is corrected to pp.15–16, with its original p.15 entry retained in the
[correction record](pfr-c16-coverage-audit.md#s05-source-locator-correction--2026-10-03).

| Earlier criterion | Fresh S05 assessment and evidence |
| --- | --- |
| C16-S01-A | E32–E34: all 51 numbered items and 122 prose occurrences, both columns of every ISIT page, page-spanning text, Appendix/Figure and bibliography are reconciled to actual contracts and dispositions. |
| C16-S01-B | E32–E34: all twelve semantic interpretation contracts, nine semantic, eleven matrix and three IV companion entries are rechecked against version 16. Appendix A (105)–(166) and relevant Appendix B (167)–(221) remain version-bound. The PPM locator correction changes no claim. |
| C16-S01-C | E32–E34/E37: all 71 omission IDs and rationale remain; actual source alignment reveals no new in-scope gap or omission. External results and extended-only claims retain explicit scope dispositions. |
| C16-S02-A | E32–E34: all eleven boundary groups and their 29 subordinate checks are supported by fresh proof/fixture/API inspection; the boundary crosswalk below gives current ownership. |
| C16-S02-B | E35: fresh complete source/original-owner/generated/instance/type/axiom reconciliation, lookup controls and separate anonymous-copy evidence. Complete fresh batch results and limits are below. |
| C16-S02-C | E36: dynamically enumerated 55 maintained files plus root pass the explicit build (2,823 jobs), and the default build passes (2,762). Source/configuration/compiled identities and effective options bind these cached incremental runs. |
| C16-S03-A | E35–E36: all 935 public source-named declarations reconcile to current original owners/types; namespaces, generality, supported pinned imports and actual consumers are checked. All isolated import/availability checks pass. |
| C16-S03-B | E32–E34/E36: all 17 DG-15 items retain their actual public, private, fixture or documentation owner. Fresh source and manuscript checks support every classification. |
| C16-S03-C | E34/E36: existing nonsingular rejection and singular-channel primal/dual endpoints compose. Their LP domain is Fintype nonempty input and Finite output; necessity has the weaker Nonempty-only requirement. The no-wrapper decision and concrete blocked-consumer trigger remain justified. |
| C16-S04-A | E37–E39: after correction of the stale current map allocation, all current owning documents agree; the Quick Start stays concise, preserved history remains navigable, and frozen records retain their bytes. Exact preservation and link results are recorded with the current checkpoint. |
| C16-S04-B | E32–E34/E36–E37: all 43 disposition rows, including the 28 C13–C16 advice IDs, are reconsidered against their original suggestions and fresh implementation evidence. Owners/triggers remain applicable; no new worthwhile unmapped deferral or numbered Future Work Note is needed. |
| C16-S04-C | E32–E39: the source/readiness crosswalk covers CC01–CC08 with current methods and explicit limits. Independent cumulative assessment and supported closure establish CC09 only after this review checkpoint. |

### Fresh boundary and completion crosswalk

The detailed [boundary index](#boundary-index) retains every original assertion
locator. This compact overlay records which fresh pass checked those assertions,
including negative controls and underlying proof connections.

| Boundary | Fresh proof/fixture reassessment |
| --- | --- |
| B01 | E32: fixed auxiliary, pair-law enlargement, arbitrary finite auxiliary and class-free structural contracts remain distinct; XOR, wrong decoder, Fin0 and universe controls apply. |
| B02 | E32: canonicality includes decoding; one posterior precedes all rows/priors; full-support converses and exact support restriction remain explicit. |
| B03 | E32–E33: actual conditional fallback and arbitrary unused-output posteriors, zero-weight entropy fibers and canonical construction's null branches are checked. |
| B04 | E32–E34: raw empty types differ from inhabited PMFs/active states. Nonempty input is intrinsic where used; singleton data and empty admissible LP columns have actual assertions. |
| B05 | E32–E34: active restriction, injective ambient recovery and dependent compressed-data equality preserve unused zero labels, supplied enumerations and whole laws. |
| B06 | E32–E34: finite PMF-to-Real conversion, total zero-denominator residual branch, per-input normalization and positive dual threshold are justified. No total-pattern-value-one assumption is introduced. |
| B07 | E33: strict PPS ratios, supported VPS splits, distinct PPM/VPM guards, full-source merge indices, actual reversals and finite normalization certificates are checked. |
| B08 | E33–E34: matrix orientation, inverse maps, arbitrary-vector recovery and entire LP objective images are supported; noninvolutive row/column controls distinguish wrong directions. |
| B09 | E33–E34: both full/reduced restrictions and nonnegativity are required. Signed and mixed-system controls, exact absent rows and zero extension prevent false equivalences. |
| B10 | E34: equality, primal and dual feasibility remain separate; attained greatestness/leastness, empty families, signed vectors, slack elimination and the actual positive certificate correction are checked. |
| B11 | E33–E34: actual canonical decoder partitions, seed/reversal maps and labelled incidence PPS/VPS/PPM endpoints are retained. Numeric checks do not pretend to identify existential private witnesses. |

CC01–CC02 use the fresh manuscript/interpretation passes; CC03 uses all boundary
rows above; CC04 uses fresh full builds and complete trust evidence; CC05 uses the
all-owner API and isolated import checks; CC06 uses all DG-15 items and the
consumer-supported wrapper decision; CC07 uses original omission/advice owners
and current triggers; CC08 uses owning-document consistency and preserved
navigation. **CC09 remains subject to independent cumulative review, applicable
final checks and the durable S05 closure record.**

### Fresh trust, import and evidence limits

The source inventory was regenerated from actual maintained files, then
reconciled with complete compiled module data rather than using source names as
the compiled filter. The two owner groups retain the independently maintained
test owners whose local-instance names conflict in a single umbrella.

Fresh original-owner results cover 6,534 occurrences / 6,518 distinct names:
3,557 direct source declarations, 2,726 generated descendants, 192 notation
generators, three deriving generators, 47 imported-project generators and nine
imported-library generators. Source, ilean and compiled unmatched lists are empty.
All original types are recorded. No original entry is unsafe, opaque or an axiom;
transitive axioms are contained in `propext`, `Classical.choice`, `Quot.sound`.
Sixteen compiler partial runtime helpers and fifteen duplicate-owner occurrences
have separate actual-body, resolved-type and dependency checks. These checks do
not certify every dependency or the compiler implementation.

Both `Dual.Feasible.eq_1` contexts were rerun: importing its compiled test owner
makes it available before lookup; importing Dual alone leaves it absent until
lazy realization creates a scratch-owned declaration. Private/local-instance and
anonymous controls, imported generator bases and all five project options are
checked. Newly named anonymous copies remain separate re-elaborations, never
recovered exported proof constants from the original files.

All 34 fresh copy files pass with all five options and exact reversible source
transformations: 1,813 principals plus 69 generated descendants, 1,882 anonymous
copy entries within 6,694 total scratch-stage entries. None of the anonymous
entries is unsafe or partial; all types and axiom sets pass. Thirteen other
copied compiler runtime helpers match their original safe bases. The 2,349
scratch warnings are retained and classified; no warning is hidden as a clean run.

All 28 isolated production/example import closures pass, including nine focused
public consumers and measured expected exclusions. The root excludes matrix,
optimization, examples, tests and optional decoding. C13 construction excludes
Primal/Dual/DualCharacterization; Primal excludes both dual owners; Dual excludes
DualCharacterization. Production modules exclude tests/examples; both example
owners exclude tests. The separate nonsingular-rejection/primal-dual composition
probe passes, with only the permitted endpoint axioms. The pinned API probe
passes eleven signature lookups and a four-universe class-free structural
consumer; its two scratch pretty-printer warnings are retained.

An additional implementation method check recomputes the complete original-owner
and import invariants, reverses all 34 prepared copies and inspects pinned compiler
mechanisms. Its snapshot contains 33 completed copy receipts; the trust actor's
later completed batch establishes all 34. This supplementary check is not a second
independent review. All 171 original source/configuration/compiled identities
remain unchanged.

The original S01–S04 reports were read and critically compared with current
evidence. Their limits remain historical: S02 independently replayed two of 34
copies; S03 inherited full builds/trust under exact hashes; S04 primarily checked
documentation and current applicability. The fresh S05 independent report must
state its own performed work and limits. Earlier favorable verdicts alone do not
discharge any cumulative criterion. Helpers are implementation contributors.

The [S04 disposition register](#c16-s04-dispositions) retains every original
suggestion and current revisit trigger. Fresh source and consumer evidence
continues to support private C08/C11 machinery, the declined C12 alias, the
local C01 upstream candidate, retained fixture choices and the no-wrapper
decision. Solver execution, general Bell/duality/complexity theory, external and
extended-only developments, upstream maintenance, release and website work
remain separately scoped. No correctness concern is deferred into those routes.

### S05 documentation correction checkpoint

The original cumulative report's mathematical/compiler evidence remains intact.
Its documentation gap concerns the map's explicitly current allocation paragraph,
which still said S05 was unstarted. That paragraph now agrees with the other
current owners. The implementation-note introduction now links the S05 readiness
crosswalk; explicitly historical S04 routes remain. The original R and report
are preserved in E38. Current consistency and CC08 require the corrected-source
checks and focused independent reassessment; supported closure alone establishes
CC09. No theorem, assumption, API, import, dependency or omission is changed.

### Corrected-source independent review and final checkpoint

The first cumulative report established fresh mathematical, compiler, trust and
API evidence but rejected S05-A/S05-C because of the explicitly current stale
map allocation. That report remains unchanged. The second report independently
checks the bounded documentary correction and exact applicability of the full
pass. All three S05 criteria are satisfied on the corrected source. Original
failed attempts, inherited evidence and method limits retain their actual roles.
E38–E40 in the implementation record own review, reconciliation and final checks.
All earlier criterion and boundary rows remain as audited; current CC08 includes
the reviewed correction. Only supported durable S05 closure establishes CC09.
