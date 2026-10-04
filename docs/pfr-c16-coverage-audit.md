# PFR-C16 — Source and interpretation coverage audit

**S01 review reconciled; final validation checkpoint — 2026-10-03.** This ledger reconciles the complete
six-page ISIT manuscript with current C01–C15 source. It records mathematical
coverage and intentional dispositions; S02 owns the cumulative boundary/trust
audit, S03 the final API/DG-15 decisions, and S05 the final cumulative validation.
The [approved plan](plans/pfr-c16-coverage-api-trust-closure.md) remains revision 2.
[Implementation notes](pfr-c16-implementation-notes.md) own evidence IDs, actors,
commands, source applicability, original review and closure references.
Within the ledger, E00–E07 abbreviate C16-E00–C16-E07. The notes add E08 for the
original independent review and E09 for final validation/applicability. Validation
is ready; completion is subject to the durable execution record.

## Source identities and reading method

| Source | Version and exact SHA-256 | Inspected scope |
| --- | --- | --- |
| ISIT final | Local six-page file ending `final_manuscript_ (3).pdf`; `48963aa59485b2c33b1a1e6e7c6ead2251fdddd26bd3691b6fcffe683e6ed1c4` | All six original pages, both columns, captions, displays, footnotes and metadata. |
| Extended companion | Eighteen-page version 16, lead-designated 2026-09-03; `98636d4c9f0618ec08fca84559572780f604f197fda90d8d7c787b3624245b8f` | Relevant I–IV and Appendices A/B through (221), using the dependency rows below. Extended-only regions remain under their existing omissions. |

Page numbers are one-based PDF pages. All hashes were freshly checked against
the original local binaries. Whole-page renders were inspected; text extracts
assisted navigation. The papers and renders remain external or ignored. Rows
paraphrase source claims rather than reproduce manuscript text. Every numbered
item has its own stable row. Prose locators refer to bounded paragraphs, list
items, proof regions or sentences; shared contracts apply explicitly to each
referencing row. Repeated occurrences retain distinct rows.

Coverage modes distinguish public declarations, proof-internal results, compiling
fixtures, documentation dispositions and intentional omissions. A private fixture
is coverage only for its actual assertions. The fresh build checks its original
maintained module; no copied anonymous elaboration is claimed here. Completed
chunk history supplies approved intent and prerequisite status, while E01–E07
separately identify S01's fresh source and compiler evidence.

The global omission register remains [map Section 9](formalization-map.md#9-internal-exhaustive-omission-and-disposition-register).
All OM-001–071 rows and their full rationale are preserved. The final disposition
section below checks their relationship to this ledger without replacing them.
The parent and independent reviewer found no unresolved in-scope mathematical gap
in this S01 coverage audit. Later C16 audit duties remain as stated above.

## Page and paragraph sweep

| PDF region | Coverage route |
| --- | --- |
| p1 title/authors/abstract; both columns of I, affiliation/funding footnote and outline paragraph | Semantic numbered/prose rows below, including abstract restatements, cited literature and metadata dispositions. |
| p2 left II preliminary support convention and II-A properties/Remark1/Lemma1/Definition2; right II-A continuation, II-B and II-C, III opening at bottom | Semantic rows through Lemma3/(10), then the page-spanning III introductory prose. Definition4 begins III-A on p3. |
| p3 both columns III-A operations/(11)–(15)/Examples2–5/Lemma4; III-B opening at lower right | Matrix operation and normalization rows; page-spanning III-B seed paragraph continues on p4. |
| p4 left III-B seed continuation/Theorem1/Lemmas5–6/Remark2; IV opening; right IV/IV-A/(16)–(17)/Examples6–7 | Matrix rows, semantic Remark2 occurrences and IV rows. The IV compression paragraph crosses from left bottom to right top. |
| p5 left Theorem2/(18), IV-B Corollary1/(19), IV-C, Appendix opening/(20)–(22); right Appendix/(23)–(28), Figure1 and caption | IV theorem/prose rows plus every Appendix display and proof/figure region in matrix rows. |
| p6 both columns bibliography [1]–[33] | REF-01/02 documentation dispositions; substantive cited assertions are classified at their source occurrence. |


## Semantic source rows

E01 owns the attributed fresh helper inspection; E04 supplies the parent
build of these original maintained modules. Source interpretations K01–K12
and version-bound C16-X-SEM01–09 below apply explicitly to their referencing rows.

### Semantic file keys

All production identifiers below are in namespace `PerfectFunctionalRepresentations`; dependency identifiers in `LeanInfoTheory.Shannon`. Line locators refer to the hashed source snapshot. Test regions contain real theorem/anonymous-example proofs, not a claim that every fixture in each test file was read.

- `FR`: `PerfectFunctionalRepresentations/Semantics/FunctionalRepresentation.lean`
- `CAN`: `PerfectFunctionalRepresentations/Semantics/Canonical.lean`
- `SING`: `PerfectFunctionalRepresentations/Semantics/Singularity.lean`
- `EX`: `PerfectFunctionalRepresentations/Examples/Nonrepresentable3x3.lean`
- `TV`: `PerfectFunctionalRepresentations/Probability/FiniteCoupling.lean`
- `BIN`: `PerfectFunctionalRepresentations/Semantics/Binary.lean`
- `TFR`: `PerfectFunctionalRepresentations/Tests/Semantics/FunctionalRepresentation.lean`
- `TCAN`: `PerfectFunctionalRepresentations/Tests/Semantics/Canonical.lean`
- `TEX`: `PerfectFunctionalRepresentations/Tests/Examples/Nonrepresentable3x3.lean`
- `TTV`: `PerfectFunctionalRepresentations/Tests/Probability/FiniteCoupling.lean`
- `TBIN`: `PerfectFunctionalRepresentations/Tests/Semantics/Binary.lean`
- `ENT`: `.lake/packages/LeanInfoTheory/LeanInfoTheory/Shannon/Entropy.lean`
- `IND`: `.lake/packages/LeanInfoTheory/LeanInfoTheory/Shannon/SemanticBridge/Independence.lean`
- `DET`: `.lake/packages/LeanInfoTheory/LeanInfoTheory/Shannon/SemanticBridge/Theorems.lean`
- `MARKOV`: `.lake/packages/LeanInfoTheory/LeanInfoTheory/Shannon/SemanticBridge/Markov.lean`

### Exact local contracts and source interpretations

- **K01** — FR:30,43,54 structural independence plus an existential product decoder correct on PMF support; full triple pushforward, right-associated products, unrestricted source and structural value types. FR:118 information equivalence requires Fintype X,Y,Z, never Fintype source. Pinned IND:278 and DET:222 supply semantic zero bridges. Null atoms impose no decoder condition. Fixtures TFR:245-374,393-430 distinguish postprocessing loss, triple-vs-pair data and a wrong fixed decoder. OM-053 finite information, OM-035 nats.
- **K02** — FR:153 proves (2) for all finite value alphabets with no representation premise using pinned entropy chain rules and conditioner-swap proof :129-150. FR:176/189 specialize under K01 to equality and inequality (3). FR:202/216 prove equality iff zero CMI iff X-Y-Z Markov; MARKOV:168 verifies exact argument order. All information quantities are Real in nats (ENT:35), support-sensitive, on arbitrary source. TFR:393-486 checks identities, nonfinite source and null-output behavior.
- **K03** — FR:231/243 fixed perfectness retains structural FR and information equality; :265/:281 its zero-CMI/Markov characterizations. FR:314 pair perfectness is an enlarged triple-law witness with exact pair marginal and hidden Fin n auxiliary, :324 Of via pair pushforward, :331/:341 pair-law invariance, :372/:398 normalization from arbitrary finite auxiliary universes. Structural infinite auxiliaries are allowed by K01; infinite-auxiliary information or an optimizer on the original sample space is not claimed. TFR:487-567. OM-053.
- **K04** — CAN:21 marginal-only IsCanonicalCoupling is separate from CAN:33/38 fixed-pair IsCanonicalFunctionalRepresentation, which includes independence and Y=W X on support. CAN:26 canonicalJoint independently samples input and vector; :113 actual representation, :137 reconstructs full triple, :161/:176 exact prescribed pair from all-row coupling. CAN:192 decoderVector; :198/:209 construct from decoder; :238 supported coordinate laws, :249 all rows only full input support. TCAN:111-177 has independent correct marginals and exact pair yet mismatch probability 1/2, refuting weakened Definition 1. OM-048/055.
- **K05** — CAN:280 mutualInfoOf_decoderVector_eq proves (7) internally using explicit hEqSeven and the two DPI inequalities (:264 conditional bridge); finite input, output and auxiliary values, unrestricted source. CAN:308 exists_canonical_preserving_mutualInfo, :323/:341 perfect canonicalization and :358 finite pair iff canonical joint. TFR transport and C02 TCAN adversarial fixture preserve full-law rather than only pairwise data. OM-042/053.
- **K06** — CAN:402 IsPerfectlyRepresentableChannel quantifies one vector law q and one total posterior V with every coordinate joint equal to channelJoint(row,V); input Nonempty, structural definition does not need finite alphabets/prior. CAN:408 derives coupling. :431/:440 supported/full-support factorization, :450 Markov, :462 fixed-coupling full-support converse, :479 irrelevant unused-output posterior. Finite-information :512/:532/:545 gives one q and perfect fresh canonical joints for every prior, :558/:590 converse only full support. :606 changes full-support prior, :619 common-base pair transport, :808/:823 arbitrary-prior restriction to actual input support with exact inclusion. TCAN:616-741 checks unseen-row and null-output failures. OM-054/055.
- **K07** — SING:18 IsSingularChannel uses equality of nonzero masses in each output column, equivalent to positive product :23, with no prior or finiteness. SING:53 perfect-channel necessity uses supported posterior atom and ENNReal cancellation with justified nonzero/finite factors (:37-78). SING:181 activeOutputs is union of row supports; :186/:191 exact restriction and inclusion; :207 nonempty input implies an active output; :222/:231 restriction invariance. :242 identifies pair-output support only under full input support. Finite alphabets and Nonempty input: :323 output-card <=2, :342 active-output-card <=2 sufficiency (private equal-row/deterministic dichotomy :258-320). BIN:364 input-card=2 and :384 combined theorem, finite outputs, no chosen prior. OM-056/058/063.
- **K08** — EX:22 nonrepresentable3x3 is the exact Fin 3 row channel, :28 all entry formula, :33 singularity and :40 direct all-witness nonperfectness using common-posterior support contradiction. TEX:1-85 checks all nine entries, normalization, active outputs, generic full-support/uniform pair negatives, point-prior positives and unused-output extension. No reliance on later Theorem 1. OM-033/057; later duplicate proof omission OM-040 remains distinct.
- **K09** — TV:48 finiteTV is Real half-L1 of ENNReal masses converted with toReal. :87/:101 overlap complements explicitly justify finite mass conversions; :183/:188 mismatch/event bridge; :264/:270/:277 universal coupling lower bound. :289-341 constructs and normalizes actual residual PMF, :354/:367/:372 exact overlap/mismatch, :377 witness plus universal bound, :398 equal laws diagonal, :412 zero overlap independent product. No optimizer assumed, full metric or arbitrary-measure theory claimed. TTV:63-117,190-228,406-441 checks partial/disjoint/identical/singleton/empty and all16 unequal-coupling entries. OM-059/060/061.
- **K10** — BIN:86/:94 actual Fin 2 product/vector coupling equivalence and :103/:112 full triple maps (paper 1,2 become Lean 0,1); :123 pair law. :191 shared/exclusive singular atom formula, :331 actual common posterior including both-zero fallback, :364 Lemma2 binary-input sufficiency. :432 positive-vector conditional law, :443 constant/injective entropy, :465 null weight, :494/:509 arbitrary-prior canonical entropy/MI. No full support or coupling needed for these raw entropy identities. TBIN:479-558 positive unequal/nonuniform, constant and null fibers. OM-065/066.
- **K11** — BIN:567 universal binary bound for every finite auxiliary on arbitrary source and exact prescribed pair law, arbitrary prior; full-support branch canonicalizes, point-prior branch uses H(X)=0 without inferring unseen rows. :604 specified maximal canonical joint is actual representation with exact pair and objective; :629 finite attaining triple-law extension. :151 scalar independent of input enumeration; :776/:809/:859 transport to an explicit alpha equiv Fin 2 and arbitrary source/universes. TV scalar remains definition, no public r alias needed. TBIN:157-189 row/enumeration guards, :617-696 combines actual universal bound/attaining witness and nonuniform nonsingular objective 1/3. OM-046/053/064/067.
- **K12** — BIN:673 all-prior I(X;Y)<=TV*H(X); :683 singular gives equality for every prior; :700 equality iff singular has explicit full input support, matching II's support convention. :873/:882/:894 arbitrary-cardinality-two input transport; :914/:927/:941 common-base forms retain exact pair law and needed support. TBIN:828-935 strictly nonsingular/full-support example, nonsingular point prior with equality (H=MI=0), arbitrary universes. OM-063. Equality converse on an arbitrary ambient degenerate prior is false and not claimed.

### Extended proof/clarification dependencies

No extended-only theorem is promoted by inspecting neighboring material.

| Key | Exact extended v16 anchor | Owner and actual checked content |
|---|---|---|
| C16-X-SEM01 | EXT16 I, p1, (1)-(3) | C01: Same information identities and introductory perfectness; no extra theorem claimed. Approved finite-valued interpretation is OM-053; nats OM-035. |
| C16-X-SEM02 | EXT16 II-A, p2, (5)-(7), Definition 1, Remark 1, Lemma 1, Definition 2 | C02: Same decoder-vector proof. Fixed-pair decoding, same-law new-source reading and support-qualified channel inference are explicit Lean repairs (OM-048/054/055). |
| C16-X-SEM03 | EXT16 Appendix A, p12 L, Lemma 2 part 1, (105)-(110) | C03: Common-posterior supported-atom necessity; SING:37-78 translates conditional calculations to prior-free factorization. |
| C16-X-SEM04 | EXT16 Appendix A, p12 R bottom to p13 L top, Lemma 2 part 3, (125)-(134) | C03: Binary-output equal-row/deterministic dichotomy and witnesses; SING:258-358. Helpers remain private, active-output interpretation explicit (OM-056/058). |
| C16-X-SEM05 | EXT16 Appendix A, p13 L/R, Lemma 7, (135)-(146) | C03: ISIT Example 1 direct two-branch support contradiction, EX:40-85; translated from uniform-prior conditional notation via C02 factorization. No dependence on Theorem 1 (OM-033/057). |
| C16-X-SEM06 | EXT16 Appendix A, p14 L, (156)-(161), and the attainment sentence immediately after (161) | C04: TV lower bound and actual normalized maximal coupling. TV:264-377 checks diagonal bound, residual construction, exact mismatch; equality and zero-overlap cases are implemented (OM-059/060/061). |
| C16-X-SEM07 | EXT16 Appendix A, p12 L/R, Lemma 2 part 2, (111)-(124) | C05: Binary singular common-posterior construction. BIN:161-399 verifies shared/exclusive atom law and total posterior; both-zero outputs handled. No normalization of zero-mass A/B/C components (OM-061/066/067). |
| C16-X-SEM08 | EXT16 Appendix A, p13 R bottom (147)-(148), p14 L (149)-(154) | C05: Canonical binary entropy. BIN:411-542 computes actual positive-fiber law and weighted entropy; null fibers vanish under zero weight, not a pointwise arbitrary-completion claim (OM-065). |
| C16-X-SEM09 | EXT16 Appendix A, p14, (155), (162)-(166); statement II-C p3 L, Lemma 3 (10) | C05: Universal information bound plus explicit attaining finite extension; equality iff singular requires full input support for converse. BIN:567-717; arbitrary input enumeration :776-956. OM-063/064/067. |

### Numbered and prose occurrence ledger

Each row retains its own printed locator. `K` links name the actual declarations/proof regions, hypotheses and inspected fixtures above; `C16-X-SEM` links bind relevant proof/clarification to this exact extended version. A documentation or external omission is expressly not Lean coverage. Later-claim references are completed by the matrix and IV rows in this integrated audit.

| ID | Source locator and printed occurrence | Coverage, exact owner and extended anchor | Intended/Lean distinction and OM IDs |
|---|---|---|---|
| C16-EQ01 | ISIT p1 L, I, first display (1): Independence and deterministic recovery encoded by two zero information quantities. | direct theorem; K01; C16-X-SEM01 | Finite-valued entropy iff structural representation; no finite-source premise; support-only decoding. [OM-035, OM-053] |
| C16-EQ02 | ISIT p1 L, I, middle display (2): Four-term chain-rule decomposition of I(Y;Z). | direct theorem; K02; C16-X-SEM01 | FR:153 holds without the representation constraints; sign and variable order read in proof. [OM-035] |
| C16-EQ03 | ISIT p1 L, I, display (3): Under (1), exact conditional-entropy/CMI identity and upper bound. | direct theorems; K02; C16-X-SEM01 | FR:176 is equality, :189 inequality; two claims individually present. [OM-035, OM-053] |
| C16-EQ04 | ISIT p1 R top, I, display (4): Cited strong-representation logarithmic-gap bound. | external-result omission; OM-005; no Lean owner claimed; EXT16 p1 I repeats additive-logarithmic wording | This exact displayed inequality and its cited theorem are excluded; local exact identities do not cover it. Factor/additive wording and units remain unaccepted external claim. [OM-005, OM-035] |
| C16-EQ05 | ISIT p2 L, II-A, display (5): Decoder vector with one coordinate for every supported input. | definition and construction; K04; C16-X-SEM02 | CAN:192 pointwise function alpha->beta replaces printed column vector; actual same-source decoding and independence :198, row laws support-qualified :238. [OM-014, OM-053, OM-055] |
| C16-EQ06 | ISIT p2 L, Lemma1 proof, display (6): Same decoder-vector choice inside proof. | definition plus proof reuse; K04, K05; C16-X-SEM02 | Separate occurrence of (5), same actual decoderVector; not an extra theorem-name obligation. [OM-042, OM-053] |
| C16-EQ07 | ISIT p2 L, Lemma1 proof, display (7): Difference of information equals difference of conditional information. | proof-internal identity; K05; C16-X-SEM02 | CAN:280-304 hEqSeven has the printed orientation; unconditional and conditional DPI force both sides zero. [OM-042] |
| C16-EQ08 | ISIT p2 R, Example1, display (8): 3x3 half-mass channel with zero entries at (1,3),(2,2),(3,1). | explicit fixture and theorems; K08; C16-X-SEM05 | All nine entries checked under one-based-to-Fin3 coordinate translation; singular and not perfect, independently of Theorem1. [OM-033, OM-057] |
| C16-EQ09 | ISIT p2 R, II-C opening display (9): Total variation half-L1 formula. | definition; K09; C16-X-SEM06 | TV:48 exact finite Real formula; no metric-instance or infinite alphabet interpretation. [OM-059] |
| C16-EQ10 | ISIT p2 R, Lemma3, display (10): r denotes TV between the two conditional rows. | definitional specialization and transport; K09, K11; C16-X-SEM09 | finiteTV(kappa0,kappa1) occurs directly in theorem types; BIN:151 proves enumeration invariance; TBIN:157-189 checks exact half-L1 and order. [OM-063, OM-067] |
| C16-DEF01 | ISIT p2 L, II-A, Definition1: Canonical representation described by independent vector and row marginals. | interpreted definition with counterexample guard; K04; C16-X-SEM02 | The intended term functional representation retains Y=W_X. Marginals alone are only IsCanonicalCoupling, with a direct fixed-pair adversarial fixture showing insufficiency. [OM-014, OM-048, OM-053, OM-055] |
| C16-DEF02 | ISIT p2 L bottom, II-A, Definition2 and p2 R continuation: Perfectly representable conditional law via common W\|Y. | definition and equivalence bridges; K06; C16-X-SEM02 | Prior-free all-row coordinate factorization exposes the implicit Markov/common posterior condition. Pair converse is full-support or support-subtype only; null-output posterior arbitrary. [OM-054, OM-055] |
| C16-DEF03 | ISIT p2 R, II-B, Definition3: A column's two positive entries are equal; same term for matrices. | semantic definition/equivalence; matrix cross-reference; K07; Channel.lean:175–215 `HasSingularColumns` and exact/Real iff bridges for final sentence; C16-X-SEM03, C16-X-SEM07, C16-X-SEM04 | SING:18/:23 exact nonzero/positive-product equivalence; semantic portion directly inspected. Parent E03 inspected `hasSingularColumns_massMatrix_iff` and `hasSingularColumns_realMatrix_iff`, including finite-mass conversion in the proof. [OM-014] |
| C16-LEM01 | ISIT p2 L, II-A, Lemma1 and proof through both sides zero: Canonical replacement preserves I(Y;Z). | direct theorem and actual proof; K04, K05; C16-X-SEM02 | Finite original value alphabets; source arbitrary. CAN:308 witness on same source, :358 canonical finite pair sufficiency. No information theorem for an infinite original auxiliary. [OM-042, OM-048, OM-053] |
| C16-LEM02 | ISIT p2 R, II-B, Lemma2: Perfect implies singular; converse if input or output binary. | direct theorems with support interpretation; K07, K10; C16-X-SEM03, C16-X-SEM04, C16-X-SEM07 | Necessity prior-free. Binary-input theorem cardinality2; output theorem counts active union and even allows singleton. Source's support convention prevents arbitrary degenerate-prior reading. [OM-056, OM-058, OM-063, OM-066, OM-067] |
| C16-LEM03 | ISIT p2 R, II-C, Lemma3 after (10): Maximum information is H(Y)-rH(X), and rH(X)=I(X;Y) iff singular. | universal bound + actual attainment + equality theorem; K11, K12; C16-X-SEM06, C16-X-SEM08, C16-X-SEM09 | Arbitrary prior for bound, attainment and singular forward equality; full input support for iff converse. Attaining finite law may enlarge source. No optimizer existence inferred solely from max notation. [OM-046, OM-053, OM-060, OM-063, OM-064, OM-065, OM-067] |
| C16-REM01 | ISIT p2 L, II-A, Remark1: Same canonical representation for all input priors with the same conditional law. | law-level interpretation and theorems; K04, K06; C16-X-SEM02 | Same specified coupling law gives fresh canonical joints under each prior; CAN:532 one coupling quantifies before all priors. No assertion that an already-fixed random variable remains independent of arbitrary new variables on its original sample space. [OM-054, OM-055] |
| C16-REM02 | ISIT p4 L, Remark2 between Theorem1 proof and IV: Restates graph-entropy, privacy-funnel/g0 and zero-redundancy consequences. | four external/documentation dispositions; C16-PROSE-REM02-01 through -04; no Lean owner claimed; None required; current extended VI is separately omitted | Whole rendered p4 inspected. Theorem1 coverage does not formalize any cited external equivalence or measure; each unnumbered display is separately located below. [OM-010, OM-011, OM-012] |
| C16-EX01 | ISIT p2 R, II-B, Example1 including text after (8): Singularity is insufficient in general, witnessed by the displayed 3x3 channel. | explicit fixture + singularity + direct negative theorem; K08; C16-X-SEM05 | EX:33/:40 and TEX:1-85 verify matrix, singularity and universal nonperfectness; later reachability corollaries are separate occurrence/owner. [OM-033, OM-040, OM-057] |
| C16-PROSE-FRONT-01 | ISIT p1 full-width title and author line: Title and author byline. | publication metadata; Documentation only | Observed as printed; this inspection does not verify release metadata or create source headers. [OM-022] |
| C16-PROSE-ABS-01 | ISIT p1 L, abstract opening: Existence of independent auxiliary and deterministic recovery for given pair. | external existence omission + local contract restatement; K01; C16-X-SEM01 | Cited general existence is not claimed formalized; structural meaning locally formalized. [OM-001, OM-022, OM-053] |
| C16-PROSE-ABS-02 | ISIT p1 L, abstract after existence sentence: Auxiliary captures information missing from input. | documented intuition; OM-036 | No extra informal-information predicate. [OM-022, OM-036] |
| C16-PROSE-ABS-03 | ISIT p1 L, abstract naming sentence: Perfect representation when information equals conditional entropy. | definition restatement; K03; C16-X-SEM01 | Retains representation premise; finite information interpretation. [OM-022, OM-053] |
| C16-PROSE-ABS-04 | ISIT p1 L, abstract conditional-law sentence: Existence depends solely on the conditional law. | support-qualified theorem restatement; K06; C16-X-SEM02 | Conditional law is on actual input support; arbitrary ambient degenerate priors cannot determine unseen rows. [OM-022, OM-055] |
| C16-PROSE-ABS-05 | ISIT p1 L, abstract necessary-and-sufficient sentence: Main characterization announcement. | cross-reference; C16-THM01 below; E02/E04 | Repeated announcement; no duplicate semantic declaration asserted. [OM-022] |
| C16-PROSE-ABS-06 | ISIT p1 L, abstract LP sentence: Perfectness cast as linear program. | cross-reference; C16-THM02 and C16-COR01; E03/E06 | Requires corrected reduced/full allocation; the integrated IV rows provide the actual proof owners. [OM-022, OM-025, OM-047] |
| C16-PROSE-ABS-07 | ISIT p1 L, abstract final tractability phrase: Computational tractability discussed. | documentation/algorithm exclusion; OM-018/019 | No runtime or solver result attributed to Lean. [OM-018, OM-019, OM-022] |
| C16-PROSE-I-01 | ISIT p1 L, I opening before (1): Functional representation lemma [1] supplies a witness. | external-result omission; OM-001 | Distinct occurrence from abstract; no general existence theorem claimed. [OM-001] |
| C16-PROSE-I-02 | ISIT p1 L, I opening before (1): Independent auxiliary and deterministic decoder restated as (1). | local structural/information bridge; K01; C16-X-SEM01 | Both directions checked, finite values for information and support-correct decoding. [OM-053] |
| C16-PROSE-I-03 | ISIT p1 L, I immediately after (1): Functional representations are nonunique. | documentation intuition; OM-036 | No generic nonuniqueness proposition; exact contracts avoid selecting canonical unique witness. [OM-036] |
| C16-PROSE-I-04 | ISIT p1 L, I minimum-entropy paragraph: Minimum-entropy literature [2]-[13]. | external context omission; OM-002 | No cited result silently inherited. [OM-002, OM-023] |
| C16-PROSE-I-05 | ISIT p1 L, I same paragraph channel-synthesis uses: Max-information representations used in channel synthesis and other tasks [14]-[17]. | external context omission; OM-003 | Specific bound/asymptotic/zero redundancy have independent rows. [OM-003, OM-023] |
| C16-PROSE-I-06 | ISIT p1 L, I same paragraph privacy connections: Privacy connections [5],[6],[18]-[26]. | external context omission; OM-004 | No privacy library target. [OM-004, OM-023] |
| C16-PROSE-I-07 | ISIT p1 L, I paragraph immediately before (2): Maximize information with output subject to (1). | problem statement tied to precise local contracts; K01, K02, K11; C16-X-SEM01, C16-X-SEM09 | C01 upper bound general finite values; actual binary maximum covered by C05. No all-channel optimizer theorem implied. [OM-046, OM-053, OM-064] |
| C16-PROSE-I-08 | ISIT p1 L, I lead-in to (2): Chain rule yields decomposition. | proof explanation; K02; C16-X-SEM01 | Actual chain-rule algebra read, not just matching theorem name. [OM-035] |
| C16-PROSE-I-09 | ISIT p1 L, I lead-in to (3): Representation constraints simplify decomposition. | proof explanation; K02; C16-X-SEM01 | FR:176 uses zero-info characterization, :189 nonnegative CMI. [OM-053] |
| C16-PROSE-I-10 | ISIT p1 L, I after (3): Conditional entropy is an upper bound on maximum information. | universal bound; K02; C16-X-SEM01 | Universal inequality is sufficient; a general optimizer is not asserted. [OM-046] |
| C16-PROSE-I-11 | ISIT p1 L, I after (3), equality clause: Upper bound attained exactly at zero conditional information. | iff theorem; K02, K03; C16-X-SEM01 | FR:202 proves both directions under FR, stronger precision than just sufficient whenever wording. [OM-053] |
| C16-PROSE-I-12 | ISIT p1 L, I final two lines: Zero conditional information iff the indicated Markov chain. | semantic bridge theorem; K02; C16-X-SEM01 | Exact X-Y-Z ordering, finite value alphabets; MARKOV:168 inspected. [OM-053] |
| C16-PROSE-I-13 | ISIT p1 R top, I lead-in to (4): Cited strong bound described as logarithmic factor. | external-result/wording omission; C16-EQ04; EXT16 I p1 wording comparison | Displayed gap is additive logarithmic; no silent local correction or unit claim for cited theorem. [OM-005, OM-035] |
| C16-PROSE-I-14 | ISIT p1 R, I paragraph immediately after (4): Product-pair bound approaches the upper bound after normalization. | external consequence omission; OM-006 | Distinct from finite exact PFR theorem and from refined rates. [OM-006] |
| C16-PROSE-I-15 | ISIT p1 R, I same paragraph X^n,Y^n and normalized redundancy: Product strong bound gives order-log-n conditional information and vanishing per-symbol gap. | external consequence omission; OM-006 | Both unnormalized growth and normalized limit explicitly excluded. [OM-006] |
| C16-PROSE-I-16 | ISIT p1 R, I same paragraph [17] nonsingular clause: Refined nonsingular redundancy has leading one-half log n. | external-result omission; OM-041 | Not folded into OM-006. [OM-041] |
| C16-PROSE-I-17 | ISIT p1 R, I same paragraph singular clause: Singular product channels have sublogarithmic redundancy. | external-result omission; OM-041 | Separate rate assertion retained. [OM-041] |
| C16-PROSE-I-18 | ISIT p1 R, I goal paragraph opening: Characterize exact attainment of (3), naming perfect pairs and auxiliaries. | definitions and local objective; K03, K06; C16-X-SEM01, C16-X-SEM02 | Fixed auxiliary perfectness distinct from finite pair extension and prior-free channel perfectness. [OM-053, OM-055] |
| C16-PROSE-I-19 | ISIT p1 R, I goal paragraph ubiquity phrase: Ubiquity rhetoric. | nonmathematical transition; Documentation | No additional formal claim. [OM-022] |
| C16-PROSE-I-20 | ISIT p1 R, I special-case sentence [5]: Perfect cases X a function of Y or Y a function of X. | external-result omission; OM-007 | Private binary-output witnesses do not claim the cited general family; retained revisit condition. [OM-007] |
| C16-PROSE-I-21 | ISIT p1 R, I Poisson sentence [14]: Poisson representation minimizes CMI for binary output support. | external-result omission; OM-008 | C05 local coupling proof is distinct. [OM-008] |
| C16-PROSE-I-22 | ISIT p1 R, I common-information sentence [18]: Equality of Wyner common information and mutual information suffices. | external-result omission; OM-009 | No common-information API formalized. [OM-009] |
| C16-PROSE-I-23 | ISIT p1 R, I graph-entropy sentence [27]-[29]: Perfectness equivalent to graph entropy equal to conditional entropy. | external-result omission; OM-010 | This introduction occurrence distinct from Remark2 display. [OM-010] |
| C16-PROSE-I-24 | ISIT p1 R, I privacy-funnel sentence [30]: Perfectness equivalent to vanishing GPF at conditional entropy. | external-result omission; OM-011 | Specific GPF expression excluded. [OM-011] |
| C16-PROSE-I-25 | ISIT p1 R, I g0 clause [31]: Equivalent g0 value equals conditional entropy. | external-result omission; OM-011 | Separate g0 occurrence, not only funnel umbrella. [OM-011] |
| C16-PROSE-I-26 | ISIT p1 R, I final connection [17]: Exact zero redundancy in channel synthesis, stronger than asymptotically vanishing. | external interpretation documented; OM-012 | No external channel-synthesis development certified. [OM-012] |
| C16-PROSE-I-27 | ISIT p1 R bottom, section outline: II definitions, III characterization, IV algorithm, omitted proofs due space. | nonmathematical outline with mathematical cross-references; II rows here; C16-THM01/02/COR01 and III/IV rows; extended dependency inventory C16-X-SEM01–09 and C16-X-MATRIX-01–10 | Omitted ISIT proofs are supplied only through listed exact v16 proof anchors, not accepted from an earlier audit alone. [OM-022] |
| C16-PROSE-FRONT-02 | ISIT p1 L bottom footnote: Affiliations, addresses and grant acknowledgement. | publication metadata; Documentation only | Observed; no authorship, rights or funding verification or source-header update. [OM-022] |
| C16-PROSE-II-01 | ISIT p2 L top, II opening before II-A: Input and output alphabets are supports, identified with positive finite integer ranges. | representation/support contract; K01, K06, K07; Matrix/Channel.lean:360–494 active presentation; OM-014; C16-X-SEM02 | Arbitrary finite semantic types; entropy APIs finite; active union only equals pair output support for full input support. Literal indexing replaced by explicit equivalences, not ignored. [OM-014, OM-053, OM-055, OM-056, OM-063] |
| C16-PROSE-IIA-01 | ISIT p2 L, II-A opening before (5): Choose decoder f for an existing representation. | existential decoder extraction; K01, K04; C16-X-SEM02 | CAN:209 extracts support-correct decoder; no preselected arbitrary f assumed valid. [OM-048] |
| C16-PROSE-IIA-02 | ISIT p2 L, property 1 after (5): Decoder vector independent of input. | structural theorem/proof; K04; C16-X-SEM02 | CAN:198 uses deterministic postprocessing independence. [OM-037] |
| C16-PROSE-IIA-03 | ISIT p2 L, property 2 after (5), evaluation: Evaluating coordinate X yields Y. | support decoder theorem; K04; C16-X-SEM02 | CAN:198 preserves exact same-source Y=W X on support. [OM-048] |
| C16-PROSE-IIA-04 | ISIT p2 L, property 2 after (5), consequence: Thus vector is itself a functional representation. | implication theorem; K04; C16-X-SEM02 | CAN:63/:69 exact structural implication. [OM-048] |
| C16-PROSE-IIA-05 | ISIT p2 L, property 3 after (5): Every coordinate has its corresponding conditional-row law. | support-qualified row law; K04; C16-X-SEM02 | CAN:238 per supported input, :249 for all rows with full support; source already calls X the support. [OM-055] |
| C16-PROSE-IIA-06 | ISIT p2 L, property 4 after (5): Information with Y preserved. | theorem restatement; K05; C16-X-SEM02 | Same finite-value hypotheses as Lemma1; source is unrestricted. [OM-053] |
| C16-PROSE-IIA-07 | ISIT p2 L, sentence after four properties: First three called trivial; last deferred to Lemma1. | proof routing/adjective disposition; K04, K05; C16-X-SEM02 | Underlying facts explicitly proved; adjective has no theorem obligation. [OM-037] |
| C16-PROSE-IIA-08 | ISIT p2 L, sentence before Definition1: Attribution to Kallenberg Lemma3.22 [32]. | external attribution omission; OM-013 | Local Definition1 and Lemma1 covered; textbook lemma not reproduced or claimed. [OM-013, OM-023] |
| C16-PROSE-IIA-09 | ISIT p2 L, Lemma1 proof after (6): W is a deterministic function of Z. | definition/proof fact; K04, K05; C16-X-SEM02 | Actual decoderVector composition supplies both DPI arguments. [OM-042] |
| C16-PROSE-IIA-10 | ISIT p2 L, Lemma1 proof before (7): Apply identity (3) separately to original and canonical witnesses. | proof-internal calculation; K05; C16-X-SEM02 | CAN:280-304 explicitly invokes the two structural representations and forms hEqSeven. [OM-042] |
| C16-PROSE-IIA-11 | ISIT p2 L, Lemma1 proof after (7), left sign: Unconditional DPI makes the left difference nonnegative. | proof-internal inequality; K05; C16-X-SEM02 | Actual mutual-information deterministic DPI used with correct orientation. [OM-042] |
| C16-PROSE-IIA-12 | ISIT p2 L, Lemma1 proof after (7), right sign: Conditional DPI makes the right difference nonpositive. | proof-internal inequality; K05; C16-X-SEM02 | CAN:264-277 proves conditional contraction by pair DPI and chain-rule subtraction. [OM-042] |
| C16-PROSE-IIA-13 | ISIT p2 L, Lemma1 proof concluding line: Both sides zero, yielding equality. | proof-internal conclusion; K05; C16-X-SEM02 | Actual linarith conclusion with both sign constraints. [OM-042] |
| C16-PROSE-IIA-14 | ISIT p2 L, paragraph between Lemma1 and Definition2: It suffices to focus on canonical representations without losing information. | canonical sufficiency theorem; K05, K03; C16-X-SEM02 | CAN:308 for fixed finite-valued witness; :358 iff for approved finite pair existential. Infinite original auxiliary not covered. [OM-053] |
| C16-PROSE-IIA-15 | ISIT p2 L bottom, immediately after Definition2: Channel extension factorization implies X-Y-W Markov. | factorization/Markov theorem; K06; C16-X-SEM02 | CAN:431/:450 exact factorization and Markov laws, with supported versus all-row distinctions. [OM-055] |
| C16-PROSE-IIA-16 | ISIT p2 L bottom to p2 R top, continuation sentence: Canonical representation plus Markov saturates (3). | perfectness iff theorem; K02, K06; C16-X-SEM02 | CAN:491/:512 with actual canonical structural witness, not just row marginals. [OM-055] |
| C16-PROSE-IIA-17 | ISIT p2 R top, two sentences before II-B: Perfect-pair status depends only on conditional law, so study channels. | support-qualified pair/channel equivalences; K06; C16-X-SEM02 | CAN:558/:577/:590/:606 all/every/full-support prior forms; :808/:823 exact support-subtype form for arbitrary prior. [OM-054, OM-055] |
| C16-PROSE-IIB-01 | ISIT p2 R, Definition3 last sentence: Same singular terminology for corresponding probability matrices. | matrix-boundary cross-reference; Matrix/Channel.lean:175–215 `HasSingularColumns` and its mass/Real iff bridges; E03/E04 | Semantic predicate and positive-product equivalence checked here; actual mass/Real bridges inspected by the parent. [OM-014] |
| C16-PROSE-IIB-02 | ISIT p2 R, paragraph after Definition3, [17] clause: Singular channels important in related work. | external narrative; OM-015 | No substantive Lean proposition. [OM-015, OM-023] |
| C16-PROSE-IIB-03 | ISIT p2 R, same paragraph necessity announcement: Singularity necessary for perfectness. | theorem restatement; K07; C16-X-SEM03 | SING:53 prior-free necessity. |
| C16-PROSE-IIB-04 | ISIT p2 R, paragraph after Lemma2, necessity clause: Repeats necessary condition. | theorem restatement; K07; C16-X-SEM03 | Distinct repeated occurrence, same actual owner. [OM-022] |
| C16-PROSE-IIB-05 | ISIT p2 R, paragraph after Lemma2, binary clause: Repeats sufficient condition for either binary side. | theorem restatement; K07, K10; C16-X-SEM04, C16-X-SEM07 | Active outputs/count and intrinsic input-cardinality conditions retained. [OM-056, OM-063] |
| C16-PROSE-IIB-06 | ISIT p2 R, paragraph after Lemma2, general caveat: Singularity not sufficient in general. | counterexample consequence; K08; C16-X-SEM05 | Actual 3x3 witness, not unproved narrative. [OM-033, OM-057] |
| C16-PROSE-IIB-07 | ISIT p2 R, sentence after Example1 matrix (8): Displayed channel singular and nonperfect. | two theorem claims; K08; C16-X-SEM05 | All-witness negative proof checked directly; all nine cells fixture checked. [OM-033, OM-057] |
| C16-PROSE-IIC-01 | ISIT p2 R, II-C opening before (9): Distance between distributions over the same alphabet. | finite definition; K09; C16-X-SEM06 | The word distance does not require an unused general metric hierarchy. [OM-059] |
| C16-PROSE-IIC-02 | ISIT p2 R, paragraph between (9) and Lemma3, existence clause: For any binary-input pair a maximizing representation can be found. | universal bound plus finite attaining law; K11; C16-X-SEM06, C16-X-SEM08, C16-X-SEM09 | Specified maximal coupling translated to canonical structural representation with exact pair; no same-original-source optimizer claimed. [OM-046, OM-053, OM-064] |
| C16-PROSE-IIC-03 | ISIT p2 R, same paragraph value clause: Maximum value computable from conditional-row TV. | exact value theorem; K11; C16-X-SEM06, C16-X-SEM08, C16-X-SEM09 | H(Y)-TV*H(X) bound and actual equality; no executable numeric routine claimed. [OM-064] |
| C16-PROSE-IIC-04 | ISIT p2 R, Lemma3 final sentence: TV times input entropy equals mutual information exactly for singular channel. | support-qualified equality theorem; K12; C16-X-SEM09 | Explicit full-support converse essential; observed nonsingular point-prior equality fixture rules out literal arbitrary-ambient reading. [OM-063] |
| C16-PROSE-BOUNDARY-01 | ISIT p2 R bottom, III heading; p3 opening continuation: Section II-C ends before III; p3 begins continuation of main-results overview. | page sweep boundary; C16-PROSE-III-01 below completes the page-spanning region | Whole p3 inspected to establish no unnoticed II continuation; the separate III occurrence carries its actual matrix proof owners. [OM-022] |
| C16-PROSE-REM02-01 | ISIT p4 L, Remark2 first unnumbered display: Graph entropy equality as a perfectness criterion. | external-result omission; OM-010 | Separate displayed occurrence from introduction; no local graph entropy definition/proof. [OM-010] |
| C16-PROSE-REM02-02 | ISIT p4 L, Remark2 second unnumbered display (GPF): Vanishing privacy-funnel quantity as a perfectness criterion. | external-result omission; OM-011 | Specific GPF expression remains outside formal scope. [OM-011] |
| C16-PROSE-REM02-03 | ISIT p4 L, Remark2 third unnumbered display (g0): Equivalent g0 equality. | external-result omission; OM-011 | Independent unnumbered expression retained; no privacy-measure equivalence inferred from Theorem1 alone. [OM-011] |
| C16-PROSE-REM02-04 | ISIT p4 L, Remark2 final sentence before IV: Zero redundancy in channel synthesis. | external interpretation documented; OM-012 | No external synthesis model formalized; this statement is intentionally documentation only. [OM-012] |


## Matrix, operation and Appendix source rows

E02 owns the attributed fresh helper inspection. E04 freshly compiled every
original maintained owner and fixture listed here; no inherited build is needed
to establish this S01 compilation result. Each item below is a stable ledger row,
presented as a short record to keep its full proof/fixture locators readable.
All use the source identities above. Private names are source locators and retain
their private ownership.

### C16-PROSE-III-01 — ISIT p.2 right, Section III opening paragraph continuing at p.3 left top

- **Printed:** Four operations on singular probability matrices; three preserve perfectness, three preserve nonperfectness; seed-generated matrices characterize perfectness.
- **Intended:** Finite legal cascades with the stated preservation/reduction operation sets characterize the active matrix domain.
- **Lean:** Normalizing = PPS/VPS/PPM, Reducing = PPM/PPS/VPM; both seed reachability characterizations are proved.
- **Hypotheses/boundary:** Finite nonempty input; ActiveFiniteChannel owns a positive finite output cardinality and every output is active. Singularity is an explicit operation premise. Input rows/output columns; no input prior or full-support prior premise.
- **Coverage:** public theorem plus checked proof.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/Reachability.lean:242` — `MatrixOperations.FromAllOnes / ToAllOnes` (declaration): Existence of a concrete permitted cascade with a directed terminal output equivalence.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:2466` — `MatrixOperations.isPerfectlyRepresentable_iff_toAllOnes / _iff_fromAllOnes` (declaration): Both directions for every active state.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 pp.3–5, Section III and Theorem 1 proof; Appendix B pp.14–16.
- **Omission/disposition relation:** OM-014, OM-044, OM-045, OM-051

### C16-PROSE-IIIA-01 — ISIT p.3 left, III-A first paragraph, before Definition 4

- **Printed:** View p(Y|X) as a k by m probability matrix, inputs as rows, outputs as columns, and the ith column as p(i|·).
- **Intended:** Expose exact finite coordinates of a channel and preserve its ambient law under active presentation.
- **Lean:** massMatrix / realMatrix use input rows and output columns; active states enumerate only nonzero output columns.
- **Hypotheses/boundary:** Finite nonempty input; ActiveFiniteChannel owns a positive finite output cardinality and every output is active. Singularity is an explicit operation premise. Input rows/output columns; no input prior or full-support prior premise.
- **Coverage:** public definitions/representation boundary.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/Channel.lean:35` — `massMatrix` (declaration): Matrix.of of channel masses; realMatrix takes finite masses to Real.
  - `PerfectFunctionalRepresentations/Matrix/SingularColumns.lean:34` — `columnValue / columnPattern` (declaration): Column data belong to active output labels.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.3 III-A opening.
- **Omission/disposition relation:** OM-014, OM-044, OM-045

### C16-PROSE-IIIA-02 — ISIT p.3 left, III-A first paragraph, Lemma 2/singularity/easy-check sentences

- **Printed:** Perfectness requires singularity; singularity is easy to check, so the remaining characterization focuses on singular matrices.
- **Intended:** The necessity theorem justifies this mathematical restriction. Computational ease is documentation prose.
- **Lean:** The public C11 forward proof invokes hP.isSingular before constructing operations. No complexity theorem follows from the matrix API.
- **Hypotheses/boundary:** Finite nonempty input; ActiveFiniteChannel owns a positive finite output cardinality and every output is active. Singularity is an explicit operation premise. Input rows/output columns; no input prior or full-support prior premise.
- **Coverage:** checked reuse plus documentation-only complexity disposition.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:2472` — `isPerfectlyRepresentable_iff_toAllOnes proof` (declaration): Derives IsSingularChannel from the supplied perfectness witness.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.3 III-A opening.
- **Omission/disposition relation:** OM-016, OM-037

### C16-DEF04 — ISIT p.3 left, Definition 4

- **Printed:** Value is the column’s unique nonzero probability; pattern is its column divided by that value.
- **Intended:** Admitted columns have a positive value at most one and a nonempty Boolean support pattern; division is justified by positivity.
- **Lean:** columnValue and nonempty-finset columnPattern, with exact/Real uniqueness, indicator, divided-column and reconstruction bridges.
- **Hypotheses/boundary:** Finite nonempty input; ActiveFiniteChannel owns a positive finite output cardinality and every output is active. Singularity is an explicit operation premise. Input rows/output columns; no input prior or full-support prior premise.
- **Coverage:** public declarations.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/SingularColumns.lean:34` — `columnValue` (declaration): The selected active nonzero mass; unique on nonzero entries, positive and at most one.
  - `PerfectFunctionalRepresentations/Matrix/SingularColumns.lean:79` — `columnPattern` (declaration): Nonempty finset of inputs with nonzero selected mass.
  - `PerfectFunctionalRepresentations/Matrix/SingularColumns.lean:117` — `column_div_value` (declaration): Real column divided by the real admitted value equals its 0/1 membership indicator.
  - `PerfectFunctionalRepresentations/Matrix/SingularColumns.lean:144` — `columnData_unique / columnData_toReal_unique` (declaration): Both exact and real column data are unique.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.3 Definition 4.
- **Omission/disposition relation:** OM-045, OM-068

### C16-PROSE-IIIA-03 — ISIT p.3 left, sentence immediately after Definition 4; unnumbered [1,1,0]^T display

- **Printed:** Example 1’s first column has value 1/2 and pattern [1,1,0]^T.
- **Intended:** Check the existing Example 1 channel at its original ordered label, without a new public fixture API.
- **Lean:** Private raw-channel and direct-state fixtures prove exact and Real value 1/2, support {0,1}, Boolean, indicator and divided vector.
- **Hypotheses/boundary:** Finite nonempty input; ActiveFiniteChannel owns a positive finite output cardinality and every output is active. Singularity is an explicit operation premise. Input rows/output columns; no input prior or full-support prior premise.
- **Coverage:** private fixture and anonymous consumers.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Tests/Examples/Nonrepresentable3x3Columns.lean:1` — `firstColumn / firstValue / firstPattern / firstDivided / fixtureState` (private proof/fixture locator): Source module assertions consume the existing channel and retain Fin 3 labels.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.3, same illustration.
- **Omission/disposition relation:** OM-069, OM-068

### C16-PROSE-IIIA-04 — ISIT p.3 left, paragraph introducing four operations and S, S_{k,m}

- **Printed:** The four transformations preserve singular probability matrices; S and S_{k,m} denote the domain and dimensions.
- **Intended:** Every legal transformation must preserve row probability laws, active output labels and singularity.
- **Lean:** Each operation returns ActiveFiniteChannel, and pps/ppm/vps/vpm_isSingular prove closure with corresponding row-sum and output-cardinality facts.
- **Hypotheses/boundary:** Finite nonempty input; ActiveFiniteChannel owns a positive finite output cardinality and every output is active. Singularity is an explicit operation premise. Input rows/output columns; no input prior or full-support prior premise.
- **Coverage:** public operation contracts.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/Operations.lean:303` — `MatrixOperations.pps` (declaration): Active state return and +1 output count.
  - `PerfectFunctionalRepresentations/Matrix/Operations.lean:623` — `ppm_isSingular` (declaration): Same-pattern merge preserves singularity.
  - `PerfectFunctionalRepresentations/Matrix/Operations.lean:1257` — `vps_isSingular` (declaration): Legal masked split preserves singularity.
  - `PerfectFunctionalRepresentations/Matrix/Operations.lean:1546` — `vpm_isSingular` (declaration): Equal-value disjoint-pattern merge preserves singularity.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 pp.3–4 III-A.
- **Omission/disposition relation:** OM-037, OM-038, OM-044

### C16-PROSE-IIIA-05 — ISIT p.3 left, Operation 1 PPS definition and unnumbered column formulas

- **Printed:** Split selected column l into adjacent α times column and (1−α) times column, with 0<α<1.
- **Intended:** Preserve the pattern and all other columns, with an exact insertion order and strict positive children.
- **Lean:** pps, pps_left/right/keep and real-coordinate/value/pattern laws prove the complete operation.
- **Hypotheses/boundary:** Finite nonempty input; ActiveFiniteChannel owns a positive finite output cardinality and every output is active. Singularity is an explicit operation premise. Input rows/output columns; no input prior or full-support prior premise.
- **Coverage:** public declarations.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/Operations.lean:303` — `pps` (declaration): Strict NNReal ratio 0<t<1 and selected Fin source index.
  - `PerfectFunctionalRepresentations/Matrix/Operations.lean:345` — `pps_left / pps_right / pps_keep` (declaration): Two adjacent scaled children; retained columns transported exactly.
  - `PerfectFunctionalRepresentations/Matrix/Operations.lean:376` — `pps_isSingular` (declaration): Singular closure.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.3 Operation 1.
- **Omission/disposition relation:** OM-044

### C16-EQ11 — ISIT p.3 left, Equation (11)

- **Printed:** 3 by 5 source matrix in the printed order.
- **Intended:** Compare every entry parametrically and check legality, activity, singularity and row normalization.
- **Lean:** Private independent real matrix specification and entire realMatrix equality; exact ENNReal consumers quantify over every input/output (75 entries across (11)–(15)).
- **Hypotheses/boundary:** One common real parameter b with 0 < b < 1; source has all five columns active. Separate b=0 and b=1 regressions prove loss of activity.
- **Coverage:** private fixture and anonymous consumers.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean:21` — `eq11` (private proof/fixture locator): Independent literal matrix specification.
  - `PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean:80` — `exampleSource_real` (private proof/fixture locator): Entire realMatrix equality, preserving displayed order.
  - `PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean:406` — `anonymous ENNReal consumers` (private proof/fixture locator): Every mass is ENNReal.ofReal of the independently specified matrix entry.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 pp.3–4 Equation (11).
- **Omission/disposition relation:** OM-026, OM-050

### C16-EQ12 — ISIT p.3 left, Equation (12)

- **Printed:** 3 by 6 result of PPS at zero-based column 1, ratio 1/2 in the printed order.
- **Intended:** Compare every entry parametrically and check legality, activity, singularity and row normalization.
- **Lean:** Private independent real matrix specification and entire realMatrix equality; exact ENNReal consumers quantify over every input/output (75 entries across (11)–(15)).
- **Hypotheses/boundary:** One common real parameter b with 0 < b < 1; source has all five columns active. Separate b=0 and b=1 regressions prove loss of activity.
- **Coverage:** private fixture and anonymous consumers.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean:24` — `eq12` (private proof/fixture locator): Independent literal matrix specification.
  - `PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean:150` — `example2_real` (private proof/fixture locator): Entire realMatrix equality, preserving displayed order.
  - `PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean:406` — `anonymous ENNReal consumers` (private proof/fixture locator): Every mass is ENNReal.ofReal of the independently specified matrix entry.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 pp.3–4 Equation (12).
- **Omission/disposition relation:** OM-026, OM-050

### C16-EQ13 — ISIT p.3 right, Equation (13)

- **Printed:** 3 by 4 result of PPM on zero-based source columns 3 and 4 in the printed order.
- **Intended:** Compare every entry parametrically and check legality, activity, singularity and row normalization.
- **Lean:** Private independent real matrix specification and entire realMatrix equality; exact ENNReal consumers quantify over every input/output (75 entries across (11)–(15)).
- **Hypotheses/boundary:** One common real parameter b with 0 < b < 1; source has all five columns active. Separate b=0 and b=1 regressions prove loss of activity.
- **Coverage:** private fixture and anonymous consumers.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean:28` — `eq13` (private proof/fixture locator): Independent literal matrix specification.
  - `PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean:274` — `example3_real` (private proof/fixture locator): Entire realMatrix equality, preserving displayed order.
  - `PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean:406` — `anonymous ENNReal consumers` (private proof/fixture locator): Every mass is ENNReal.ofReal of the independently specified matrix entry.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 pp.3–4 Equation (13).
- **Omission/disposition relation:** OM-026, OM-050, OM-024, OM-070

### C16-EQ14 — ISIT p.3 right, Equation (14)

- **Printed:** 3 by 6 result of VPS at zero-based column 0 with [true,true,false] in the printed order.
- **Intended:** Compare every entry parametrically and check legality, activity, singularity and row normalization.
- **Lean:** Private independent real matrix specification and entire realMatrix equality; exact ENNReal consumers quantify over every input/output (75 entries across (11)–(15)).
- **Hypotheses/boundary:** One common real parameter b with 0 < b < 1; source has all five columns active. Separate b=0 and b=1 regressions prove loss of activity.
- **Coverage:** private fixture and anonymous consumers.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean:31` — `eq14` (private proof/fixture locator): Independent literal matrix specification.
  - `PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean:209` — `example4_real` (private proof/fixture locator): Entire realMatrix equality, preserving displayed order.
  - `PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean:406` — `anonymous ENNReal consumers` (private proof/fixture locator): Every mass is ENNReal.ofReal of the independently specified matrix entry.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 pp.3–4 Equation (14).
- **Omission/disposition relation:** OM-026, OM-050

### C16-EQ15 — ISIT p.3 right, Equation (15)

- **Printed:** 3 by 4 result of VPM on zero-based source columns 0 and 2 in the printed order.
- **Intended:** Compare every entry parametrically and check legality, activity, singularity and row normalization.
- **Lean:** Private independent real matrix specification and entire realMatrix equality; exact ENNReal consumers quantify over every input/output (75 entries across (11)–(15)).
- **Hypotheses/boundary:** One common real parameter b with 0 < b < 1; source has all five columns active. Separate b=0 and b=1 regressions prove loss of activity.
- **Coverage:** private fixture and anonymous consumers.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean:35` — `eq15` (private proof/fixture locator): Independent literal matrix specification.
  - `PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean:332` — `example5_real` (private proof/fixture locator): Entire realMatrix equality, preserving displayed order.
  - `PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean:406` — `anonymous ENNReal consumers` (private proof/fixture locator): Every mass is ENNReal.ofReal of the independently specified matrix entry.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 pp.3–4 Equation (15).
- **Omission/disposition relation:** OM-026, OM-050, OM-024, OM-070

### C16-EX02 — ISIT p.3, Example 2 heading, lead-in and explanatory sentence after (12)

- **Printed:** The common matrix (11), transformed by PPS column 2 by 1/2, gives (12).
- **Intended:** The example is an actual legal operation on the same source, not only a standalone numeric matrix identity.
- **Lean:** example2 invokes the operation constructor; whole-matrix equality and explicit source guards connect it to (11) and (12).
- **Hypotheses/boundary:** One common real parameter b with 0 < b < 1; source has all five columns active. Separate b=0 and b=1 regressions prove loss of activity.
- **Coverage:** private fixture and anonymous consumers.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean:132` — `example2` (private proof/fixture locator): Actual operation on exampleSource, with admissibility witnesses.
  - `PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean:428` — `anonymous operation-legality and closure consumers` (private proof/fixture locator): Strict ratio, same support, both masked pieces, equal values/disjointness as applicable; all outputs active and singular.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 pp.3–4 Example 2.
- **Omission/disposition relation:** OM-026, OM-050

### C16-EX03 — ISIT p.3, Example 3 heading, lead-in and explanatory sentence after (13)

- **Printed:** The common matrix (11), transformed by PPM columns 4 and 5, gives (13).
- **Intended:** The example is an actual legal operation on the same source, not only a standalone numeric matrix identity.
- **Lean:** example3 invokes the operation constructor; whole-matrix equality and explicit source guards connect it to (11) and (13).
- **Hypotheses/boundary:** One common real parameter b with 0 < b < 1; source has all five columns active. Separate b=0 and b=1 regressions prove loss of activity.
- **Coverage:** private fixture and anonymous consumers.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean:136` — `example3` (private proof/fixture locator): Actual operation on exampleSource, with admissibility witnesses.
  - `PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean:428` — `anonymous operation-legality and closure consumers` (private proof/fixture locator): Strict ratio, same support, both masked pieces, equal values/disjointness as applicable; all outputs active and singular.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 pp.3–4 Example 3.
- **Omission/disposition relation:** OM-026, OM-050, OM-024, OM-070

### C16-EX04 — ISIT p.3, Example 4 heading, lead-in and explanatory sentence after (14)

- **Printed:** The common matrix (11), transformed by VPS column 1 by [1,1,0], gives (14).
- **Intended:** The example is an actual legal operation on the same source, not only a standalone numeric matrix identity.
- **Lean:** example4 invokes the operation constructor; whole-matrix equality and explicit source guards connect it to (11) and (14).
- **Hypotheses/boundary:** One common real parameter b with 0 < b < 1; source has all five columns active. Separate b=0 and b=1 regressions prove loss of activity.
- **Coverage:** private fixture and anonymous consumers.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean:141` — `example4` (private proof/fixture locator): Actual operation on exampleSource, with admissibility witnesses.
  - `PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean:428` — `anonymous operation-legality and closure consumers` (private proof/fixture locator): Strict ratio, same support, both masked pieces, equal values/disjointness as applicable; all outputs active and singular.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 pp.3–4 Example 4.
- **Omission/disposition relation:** OM-026, OM-050

### C16-EX05 — ISIT p.3, Example 5 heading, lead-in and explanatory sentence after (15)

- **Printed:** The common matrix (11), transformed by VPM columns 1 and 3, gives (15).
- **Intended:** The example is an actual legal operation on the same source, not only a standalone numeric matrix identity.
- **Lean:** example5 invokes the operation constructor; whole-matrix equality and explicit source guards connect it to (11) and (15).
- **Hypotheses/boundary:** One common real parameter b with 0 < b < 1; source has all five columns active. Separate b=0 and b=1 regressions prove loss of activity.
- **Coverage:** private fixture and anonymous consumers.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean:145` — `example5` (private proof/fixture locator): Actual operation on exampleSource, with admissibility witnesses.
  - `PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean:428` — `anonymous operation-legality and closure consumers` (private proof/fixture locator): Strict ratio, same support, both masked pieces, equal values/disjointness as applicable; all outputs active and singular.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 pp.3–4 Example 5.
- **Omission/disposition relation:** OM-026, OM-050, OM-024, OM-070

### C16-PROSE-IIIA-06 — ISIT p.3 left, Operation 2 PPM definition, index ranges, unnumbered sum and ordering clauses

- **Printed:** Map S_{k,m+1} to S_{k,m}; merge equal patterns l1,l2, printed both indices only through m; retain the smaller, sum their entries, remove larger and shift later columns.
- **Intended:** Both indices range through the full m+1 source columns; lower survivor and precise retained order are part of the contract.
- **Lean:** ppm takes a<b in Fin S.outputCard and pointwise same support; survivor is the sum and all retained columns are exactly transported.
- **Hypotheses/boundary:** Finite nonempty input; ActiveFiniteChannel owns a positive finite output cardinality and every output is active. Singularity is an explicit operation premise. Input rows/output columns; no input prior or full-support prior premise.
- **Coverage:** public declarations with recorded source repair.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/Operations.lean:565` — `ppm` (declaration): Two full-source Fin indices, ordered a<b, support equivalence.
  - `PerfectFunctionalRepresentations/Matrix/Operations.lean:599` — `ppm_apply_survivor / ppm_apply_unaffected` (declaration): Exact sum and unaffected-column order.
  - `PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean:274` — `example3_real` (private proof/fixture locator): Final-source-column merge gives the entire printed output.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.3 Operation 2 explicitly uses {1,…,m+1}.
- **Omission/disposition relation:** OM-024, OM-070

### C16-PROSE-IIIA-07 — ISIT p.3 right, Operation 3 VPS definition; p1=p·b, p2=p·(1_k−b), all-ones and elementwise clauses

- **Printed:** Split a column of printed value 0<β<1 using a Boolean mask into adjacent disjoint patterns with the same value.
- **Intended:** Allow 0<β≤1, require each intersection of the mask with selected support to be nonempty, and preserve the original support union.
- **Lean:** vps takes two selected-support witnesses; exact mass/real laws and child support disjointness/union prove the mask formula. Value one is admitted.
- **Hypotheses/boundary:** Finite nonempty input; ActiveFiniteChannel owns a positive finite output cardinality and every output is active. Singularity is an explicit operation premise. Input rows/output columns; no input prior or full-support prior premise.
- **Coverage:** public declarations with recorded domain repairs.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/Operations.lean:1172` — `vps` (declaration): No strict-upper-bound value premise; both selected-support pieces must exist.
  - `PerfectFunctionalRepresentations/Matrix/Operations.lean:1216` — `vps_left / vps_right / vps_keep` (declaration): Masked adjacent children, unchanged other columns.
  - `PerfectFunctionalRepresentations/Matrix/Operations.lean:1243` — `vps_children_disjoint / vps_children_support_union` (declaration): Children partition selected support.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.3 Operation 3 retains strict β<1; this is an approved interpretation repair, not a correction obtained from v16.
- **Omission/disposition relation:** OM-038, OM-049

### C16-PROSE-IIIA-08 — ISIT p.3 right, Operation 4 VPM definition; binary pattern-sum condition and sum-column formula

- **Printed:** Merge equal-value β∈(0,1] columns whose pattern sum remains binary; indices are printed through m despite m+1 source columns.
- **Intended:** Use full source index range, ordinary disjoint support, equal positive values, lower survivor and exact deletion order.
- **Lean:** vpm has equal columnValue and disjoint support premises; disjoint_support_iff_indicator_sum and divided-value variant establish the printed binary condition.
- **Hypotheses/boundary:** Finite nonempty input; ActiveFiniteChannel owns a positive finite output cardinality and every output is active. Singularity is an explicit operation premise. Input rows/output columns; no input prior or full-support prior premise.
- **Coverage:** public declarations with recorded index repair.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/Operations.lean:1476` — `vpm` (declaration): Equal values, pointwise disjoint support and a<b in full source Fin type.
  - `PerfectFunctionalRepresentations/Matrix/Operations.lean:1514` — `vpm_apply_survivor / vpm_apply_unaffected` (declaration): Sum at the lower survivor and exact retained order.
  - `PerfectFunctionalRepresentations/Matrix/Operations.lean:1620` — `disjoint_support_iff_indicator_sum` (declaration): Ordinary sum is a 0/1 support indicator exactly under disjointness.
  - `PerfectFunctionalRepresentations/Matrix/Operations.lean:1656` — `disjoint_support_iff_div_value_sum` (declaration): Connects the divided-column numeric version.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.4 Operation 4 uses {1,…,m+1} and β∈(0,1].
- **Omission/disposition relation:** OM-024, OM-070, OM-068

### C16-PROSE-IIIA-09 — ISIT p.3 right, paragraph immediately before Lemma 4

- **Printed:** The order of PPS, VPS and PPM operations can be manipulated.
- **Intended:** Produce a finite equivalent legal cascade with a stated output equivalence; no arbitrary rewrite termination claim.
- **Lean:** Local overlap/disjoint two-step identities are checked and global normalization is proved independently by structural factorization.
- **Hypotheses/boundary:** Finite nonempty input; ActiveFiniteChannel owns a positive finite output cardinality and every output is active. Singularity is an explicit operation premise. Input rows/output columns; no input prior or full-support prior premise.
- **Coverage:** checked private local proof and public global theorem.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/OperationCalculus.lean:1884` — `c08PpmPps / c08PpmVps / c08VpsPps` (private proof/fixture locator): Exhaustive local cases with exact supplied endpoints; private proof helpers.
  - `PerfectFunctionalRepresentations/Matrix/OperationFactorization.lean:2058` — `OperationPath.normalize` (declaration): A legal three-block normal form exists.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 Appendix B pp.14–15, (167)–(174).
- **Omission/disposition relation:** OM-042, OM-043, OM-051

### C16-LEM04 — ISIT p.3 right, Lemma 4

- **Printed:** Any PPS/VPS/PPM sequence is equivalent to PPS, then VPS, then PPM blocks.
- **Intended:** Existence of actual homogeneous finite paths meeting the original target up to an explicit directed output bijection.
- **Lean:** OperationPath.normalize and Cascade.normalize produce Nonempty (NormalForm S T); certificate induction recurses on the original path and realization uses finite split/gather trees.
- **Hypotheses/boundary:** Finite nonempty input; ActiveFiniteChannel owns a positive finite output cardinality and every output is active. Singularity is an explicit operation premise. Input rows/output columns; no input prior or full-support prior premise.
- **Coverage:** public theorem plus checked private structural proof.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/OperationPaths.lean:240` — `NormalForm` (declaration): Concrete PPS/VPS/PPM paths and terminal output equivalence.
  - `PerfectFunctionalRepresentations/Matrix/OperationFactorization.lean:800` — `SplitForest.ofPath / FactorizationCertificate.ofPath` (private proof/fixture locator): Identity and append invariants; original-path structural recursion.
  - `PerfectFunctionalRepresentations/Matrix/OperationFactorization.lean:1988` — `FactorizationCertificate.realize` (private proof/fixture locator): Realizes three finite legal stages and exact terminal comparison.
  - `PerfectFunctionalRepresentations/Matrix/OperationFactorization.lean:2058` — `OperationPath.normalize / Cascade.normalize` (declaration): Public normal-form conclusion.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 pp.14–15 Appendix B Lemma 4, (167)–(174); local EQ171 order needs explicit relabeling.
- **Omission/disposition relation:** OM-042, OM-043, OM-051

### C16-PROSE-IIIB-01 — ISIT p.3 right bottom through p.4 left top, III-B opening seed paragraph

- **Printed:** The channel mapping every input to one fixed output a is perfect, by constant Z=a; its matrix is 1_k.
- **Intended:** The one-output seed is a probability channel for every finite nonempty input and is intrinsically perfectly representable.
- **Lean:** allOnes uses PMF.pure 0 on Fin 1, has mass/real matrix all ones and perfectness from the supported single-output criterion.
- **Hypotheses/boundary:** Finite nonempty input; ActiveFiniteChannel owns a positive finite output cardinality and every output is active. Singularity is an explicit operation premise. Input rows/output columns; no input prior or full-support prior premise.
- **Coverage:** public declarations.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/Preservation.lean:36` — `ActiveFiniteChannel.allOnes` (declaration): Actual one-output pure channel.
  - `PerfectFunctionalRepresentations/Matrix/Preservation.lean:60` — `allOnes_massMatrix / allOnes_realMatrix` (declaration): Every matrix entry is one.
  - `PerfectFunctionalRepresentations/Matrix/Preservation.lean:74` — `allOnes_isPerfectlyRepresentable` (declaration): Intrinsic seed perfectness.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.4 III-B opening.
- **Omission/disposition relation:** OM-044

### C16-PROSE-IIIB-02 — ISIT p.4 left, opening paragraph after the seed sentence

- **Printed:** Repeated PPS/PPM/VPS starting from the seed preserves perfectness; these are the only perfect matrices.
- **Intended:** Finite actual reachability from the seed is equivalent to intrinsic perfectness.
- **Lean:** Cascade.isPerfectlyRepresentable and final iff_fromAllOnes prove the two claims with the same operation types.
- **Hypotheses/boundary:** Finite nonempty input; ActiveFiniteChannel owns a positive finite output cardinality and every output is active. Singularity is an explicit operation premise. Input rows/output columns; no input prior or full-support prior premise.
- **Coverage:** public theorems.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/Reachability.lean:223` — `Cascade.isPerfectlyRepresentable` (declaration): Induction over legal positive-preserving paths plus terminal output transport.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:2481` — `isPerfectlyRepresentable_iff_fromAllOnes` (declaration): Necessary construction and sufficient preservation.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 pp.4–5 III-B and Theorem 1 proof.
- **Omission/disposition relation:** OM-051, OM-052

### C16-THM01 — ISIT p.4 left, Theorem 1

- **Printed:** A singular k by m M is perfect iff PPM/PPS/VPM can reduce it to 1_k.
- **Intended:** Concrete finite legal reductions characterize all active finite channel states; initial singularity can be derived from perfectness.
- **Lean:** isPerfectlyRepresentable_iff_toAllOnes has only [Finite alpha] [Nonempty alpha] and active state S; forward extracts the full canonical witness and constructs a cascade, reverse uses preservation.
- **Hypotheses/boundary:** Finite nonempty input; ActiveFiniteChannel owns a positive finite output cardinality and every output is active. Singularity is an explicit operation premise. Input rows/output columns; no input prior or full-support prior premise.
- **Coverage:** public theorem plus checked constructive proof.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:2466` — `MatrixOperations.isPerfectlyRepresentable_iff_toAllOnes` (declaration): Public exact reduction iff; no prior hypothesis.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:2334` — `canonicalToAllOnes` (private proof/fixture locator): Original posterior PPS bridge composed with reverse seed PPS/VPS bridge.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 pp.4–5 (16)–(24), ISIT Appendix (20)–(28), Appendix B pp.14–16 for supporting lemmas.
- **Omission/disposition relation:** OM-014, OM-021, OM-044, OM-045, OM-051, OM-052

### C16-PROSE-IIIB-03 — ISIT p.4 left, paragraph after Theorem 1 introducing the if direction

- **Printed:** The seed is perfect and the if direction follows from the following preservation lemmas.
- **Intended:** Reflect perfectness along a reduction to the seed using nonperfectness preservation, equivalently reverse witnessed operations.
- **Lean:** ToAllOnes.isPerfectlyRepresentable obtains a concrete reduction and calls Cascade.reflects_isPerfectlyRepresentable with seed perfectness.
- **Hypotheses/boundary:** Finite nonempty input; ActiveFiniteChannel owns a positive finite output cardinality and every output is active. Singularity is an explicit operation premise. Input rows/output columns; no input prior or full-support prior premise.
- **Coverage:** public theorem proof.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/Reachability.lean:286` — `ToAllOnes.isPerfectlyRepresentable` (declaration): Exact sufficient direction, independent of an input prior.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.4 III-B and p.16 Lemma 6.
- **Omission/disposition relation:** OM-051

### C16-LEM05 — ISIT p.4 left, Lemma 5

- **Printed:** PPS, PPM and VPS preserve perfect representability.
- **Intended:** Transport the full canonical vector joint-factorization witness through each actual operation, including null selected fibers.
- **Lean:** PPS uses one shared Bernoulli branch for the whole vector; PPM maps the whole vector and uses fixed admitted-value posterior mixture; VPS applies the row mask to the whole vector. Full joint atom laws establish the target witness.
- **Hypotheses/boundary:** Finite nonempty input; ActiveFiniteChannel owns a positive finite output cardinality and every output is active. Singularity is an explicit operation premise. Input rows/output columns; no input prior or full-support prior premise.
- **Coverage:** public theorems plus checked private witnesses.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/Preservation.lean:179` — `pps_factorization` (private proof/fixture locator): Full joint equality.
  - `PerfectFunctionalRepresentations/Matrix/Preservation.lean:209` — `pps_isPerfectlyRepresentable` (declaration): Public PPS preservation theorem.
  - `PerfectFunctionalRepresentations/Matrix/Preservation.lean:540` — `ppm_factorization` (private proof/fixture locator): Full collapse identity with zero products off common support.
  - `PerfectFunctionalRepresentations/Matrix/Preservation.lean:573` — `ppm_isPerfectlyRepresentable` (declaration): Public PPM preservation theorem.
  - `PerfectFunctionalRepresentations/Matrix/Preservation.lean:915` — `vps_factorization` (private proof/fixture locator): Deterministic masked vector map and posterior factorization.
  - `PerfectFunctionalRepresentations/Matrix/Preservation.lean:929` — `vps_isPerfectlyRepresentable` (declaration): Public VPS preservation theorem.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.15 (175)–(195), p.16 (196)–(202).
- **Omission/disposition relation:** OM-042, OM-048, OM-038, OM-049

### C16-PROSE-IIIB-04 — ISIT p.4 left, paragraph between Lemmas 5 and 6

- **Printed:** PPS/PPM and VPS/VPM are inverse pairs, so PPM/PPS/VPM preserve nonperfectness.
- **Intended:** Each operation has a witnessed inverse using remembered ratios or masks and possibly a directed output permutation; a globally inverse function is not asserted.
- **Lean:** Reverse construction supplies legal ratio/mask witnesses and output equivalence; contraposition of Lemma 5 recovers the source.
- **Hypotheses/boundary:** Finite nonempty input; ActiveFiniteChannel owns a positive finite output cardinality and every output is active. Singularity is an explicit operation premise. Input rows/output columns; no input prior or full-support prior premise.
- **Coverage:** public recovery/cascade contracts plus checked proof.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/Operations.lean:989` — `ppsRecovery_channel` (declaration): Recovers the original channel after its matching merge.
  - `PerfectFunctionalRepresentations/Matrix/Operations.lean:1068` — `ppmRecovery_channel` (declaration): Recovers using the positive admitted-value ratio and explicit labels.
  - `PerfectFunctionalRepresentations/Matrix/Operations.lean:1798` — `vpsRecovery_channel` (declaration): Recovers via remembered selected support.
  - `PerfectFunctionalRepresentations/Matrix/Operations.lean:1937` — `vpmRecovery_channel` (declaration): Recovers with a remembered split mask and labels.
  - `PerfectFunctionalRepresentations/Matrix/Reachability.lean:1` — `OperationStep.reverse / OperationPath.reverse / Cascade.reverse` (declaration): Actual finite witnessed reversals.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.16 proof of Lemma 6; operation formulas pp.3–4.
- **Omission/disposition relation:** OM-051

### C16-LEM06 — ISIT p.4 left, Lemma 6

- **Printed:** PPM, PPS and VPM preserve nonperfect representability.
- **Intended:** For a legal operation on a nonperfect active singular source, perfectness of its output would contradict the recovered source.
- **Lean:** Three public negative-preservation theorems reuse the recovered perfect witness and output-map perfectness equivalence.
- **Hypotheses/boundary:** Finite nonempty input; ActiveFiniteChannel owns a positive finite output cardinality and every output is active. Singularity is an explicit operation premise. Input rows/output columns; no input prior or full-support prior premise.
- **Coverage:** public theorem proofs.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/Preservation.lean:1192` — `pps_not_isPerfectlyRepresentable` (declaration): Contraposition via matching PPM.
  - `PerfectFunctionalRepresentations/Matrix/Preservation.lean:1211` — `ppm_not_isPerfectlyRepresentable` (declaration): Contraposition via ratio PPS and output relabeling.
  - `PerfectFunctionalRepresentations/Matrix/Preservation.lean:1229` — `vpm_not_isPerfectlyRepresentable` (declaration): Contraposition via remembered-mask VPS and output relabeling.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.16 Appendix B Lemma 6.
- **Omission/disposition relation:** OM-051

### C16-PROSE-IIIB-05 — ISIT p.4 left, sentence immediately after Lemma 6

- **Printed:** The only-if proof of Theorem 1 is in the Appendix.
- **Intended:** A cross-reference to the constructive necessity argument.
- **Lean:** The Appendix rows below trace actual private C11 witness constructions to the public characterization.
- **Hypotheses/boundary:** Finite nonempty input; ActiveFiniteChannel owns a positive finite output cardinality and every output is active. Singularity is an explicit operation premise. Input rows/output columns; no input prior or full-support prior premise.
- **Coverage:** cross-reference with checked target.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:2466` — `isPerfectlyRepresentable_iff_toAllOnes` (declaration): Forward branch consumes the constructive Appendix bridge.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 places the corresponding proof directly after Theorem 1 on pp.4–5.
- **Omission/disposition relation:** OM-021, OM-042

### C16-PROSE-APP-01 — ISIT p.5 left lower, Appendix proof opening through positive-pW assumption

- **Printed:** A perfect M has a perfect canonical W; without loss every w has positive probability. Goal is reduction to the seed.
- **Intended:** Use the full canonical vector witness, restrict W to its positive support with exact law inclusion, and construct actual operation paths.
- **Lean:** Public proof extracts q,V,hV; supportPrior and supportedAuxiliaryChannel preserve atoms/laws and include back into ambient vector space.
- **Hypotheses/boundary:** Finite nonempty input and finite output; q is a PMF of full decoder vectors and V a total common posterior, with auxiliaryChannel q x = PMF.channelJoint (kappa x) V for every x. Only positive-q vectors and nonempty decoder fibers become active labels. Private law equalities also retain zero ambient atoms; no unique null conditional completion is asserted.
- **Coverage:** checked private proof and public witness extraction.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:95` — `supportPrior_apply / supportedAuxiliaryChannel / supportedAuxiliaryChannel_map` (private proof/fixture locator): Exact support restriction and inclusion.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:149` — `supported joint/pair/triple inclusion proofs` (private proof/fixture locator): Support-law inclusion preserves the full law and factorization.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:2473` — `isPerfectlyRepresentable_iff_toAllOnes proof` (declaration): Extracts q,V,hV and an active auxiliary enumeration.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.4 Theorem 1 proof opening.
- **Omission/disposition relation:** OM-021, OM-042, OM-048, OM-052

### C16-PROSE-APP-02 — ISIT p.5 left lower, paragraph beginning First, let Y′=(Y,W), before (20)

- **Printed:** Set Y′=(Y,W); Y−Y′−W follows by deterministic projections.
- **Intended:** Retain the specified canonical W and exact full pair law, rather than replacing it with an unrelated representation.
- **Lean:** auxiliaryChannel q maps each vector w to (w x,w); its second marginal is q. The deterministic-projection theorem isMarkovChainOf_comp, used in fixedW_perfect with first variable X, also supplies the stated Y-first projection specialization; no separate named Y-first lemma is claimed. fixedW_perfect proves the specified W for every prior p.
- **Hypotheses/boundary:** Finite nonempty input and finite output; q is a PMF of full decoder vectors and V a total common posterior, with auxiliaryChannel q x = PMF.channelJoint (kappa x) V for every x. Only positive-q vectors and nonempty decoder fibers become active labels. Private law equalities also retain zero ambient atoms; no unique null conditional completion is asserted.
- **Coverage:** checked private definitions/law proofs and generic projection specialization.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:33` — `auxiliaryChannel / auxiliaryChannel_map_snd` (private proof/fixture locator): Exact decoder pair law and independent-vector marginal.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:118` — `fixedW_perfect` (private proof/fixture locator): Specified W is a perfect representation of X and the exact pair (Y,W); proof uses isMarkovChainOf_comp for the deterministic second projection.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.4 paragraph before (16).
- **Omission/disposition relation:** OM-021, OM-048

### C16-EQ20 — ISIT p.5 left lower, Equation (20)

- **Printed:** The posterior of W at (y,w) is the point mass at w.
- **Intended:** Choose the total deterministic second-projection kernel and prove its joint factorization; no uniqueness of a conditional law on null pairs.
- **Lean:** fixedW_factorization proves the auxiliary full joint law factors through pure Prod.snd; supported version and inclusion preserve that identity.
- **Hypotheses/boundary:** Finite nonempty input and finite output; q is a PMF of full decoder vectors and V a total common posterior, with auxiliaryChannel q x = PMF.channelJoint (kappa x) V for every x. Only positive-q vectors and nonempty decoder fibers become active labels. Private law equalities also retain zero ambient atoms; no unique null conditional completion is asserted.
- **Coverage:** checked private proof.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:132` — `fixedW_factorization` (private proof/fixture locator): Explicit pure projection posterior, not just scalar marginals.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:175` — `supported_factorization` (private proof/fixture locator): Same law on the support subtype.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.4 (16).
- **Omission/disposition relation:** OM-021, OM-042

### C16-EQ21 — ISIT p.5 left lower, Equation (21)

- **Printed:** The conditional law of (Y,W) given Y=y assigns (y,w) the posterior mass p(W=w|Y=y).
- **Intended:** Specify the full total splitting kernel with zero mass when the first label differs, then prove it composes to the auxiliary channel.
- **Lean:** posteriorSplit y = (V y).map (fun w => (y,w)); posteriorSplit_apply, auxiliaryChannel_factor_apply and bind_posteriorSplit prove all atoms and composition.
- **Hypotheses/boundary:** Finite nonempty input and finite output; q is a PMF of full decoder vectors and V a total common posterior, with auxiliaryChannel q x = PMF.channelJoint (kappa x) V for every x. Only positive-q vectors and nonempty decoder fibers become active labels. Private law equalities also retain zero ambient atoms; no unique null conditional completion is asserted.
- **Coverage:** checked private proof.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:54` — `posteriorSplit / posteriorSplit_apply` (private proof/fixture locator): Total split kernel with exact first-label indicator.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:77` — `auxiliaryChannel_factor_apply / bind_posteriorSplit` (private proof/fixture locator): kappa(x,y)*V(y,w) and full bind identity.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.4 (17).
- **Omission/disposition relation:** OM-021, OM-042, OM-052

### C16-PROSE-APP-03 — ISIT p.5 left lower, sentence between (21) and (22)

- **Printed:** W remains perfect for (X,Y′), because X−Y′−W and the new decoder is deterministic.
- **Intended:** Prove perfectness of that same W, for every input law, using exact joint laws.
- **Lean:** fixedW_perfect and supported_fixedW_perfect establish independence, deterministic decoder and the requisite Markov relation on the stated probability space.
- **Hypotheses/boundary:** Finite nonempty input and finite output; q is a PMF of full decoder vectors and V a total common posterior, with auxiliaryChannel q x = PMF.channelJoint (kappa x) V for every x. Only positive-q vectors and nonempty decoder fibers become active labels. Private law equalities also retain zero ambient atoms; no unique null conditional completion is asserted.
- **Coverage:** checked private proof.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:118` — `fixedW_perfect` (private proof/fixture locator): All-prior specified-W theorem.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:197` — `supported_fixedW_perfect` (private proof/fixture locator): Supported version with original law inclusion.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.4 paragraph between (17) and (18).
- **Omission/disposition relation:** OM-021, OM-048

### C16-EQ22 — ISIT p.5 left lower, Equation (22)

- **Printed:** Y′=(Y,W)=(g(X,W),W)=g′(X,W).
- **Intended:** In canonical coordinates g(x,w)=w(x), so the new decoder is exactly the ordered pair (w(x),w).
- **Lean:** auxiliaryChannel is the PMF map by this pair, and fixedW_pair_eq_channelJoint proves the actual pair-law identification.
- **Hypotheses/boundary:** Finite nonempty input and finite output; q is a PMF of full decoder vectors and V a total common posterior, with auxiliaryChannel q x = PMF.channelJoint (kappa x) V for every x. Only positive-q vectors and nonempty decoder fibers become active labels. Private law equalities also retain zero ambient atoms; no unique null conditional completion is asserted.
- **Coverage:** checked private definition/proof.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:33` — `auxiliaryChannel` (private proof/fixture locator): Definition by map w ↦ (w x,w).
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:141` — `fixedW_pair_eq_channelJoint` (private proof/fixture locator): Exact auxiliary pair law.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.4 (18).
- **Omission/disposition relation:** OM-021, OM-042, OM-048

### C16-PROSE-APP-04 — ISIT p.5 right top, Moreover paragraph: deterministic Y projection and original→auxiliary PPS

- **Printed:** Y is a deterministic function of Y′ and the auxiliary matrix is obtained from M by the PPS operation.
- **Intended:** The projection recovers the original channel; finitely many positive posterior labels require an actual finite homogeneous binary PPS cascade, not one binary step.
- **Lean:** auxiliaryChannel_map_fst proves recovery; originalPps uses multiPpsFamilyOfENNReal; originalBridge meets the independently supplied commonEndpoint with exact directed labels.
- **Hypotheses/boundary:** Finite nonempty input and finite output; q is a PMF of full decoder vectors and V a total common posterior, with auxiliaryChannel q x = PMF.channelJoint (kappa x) V for every x. Only positive-q vectors and nonempty decoder fibers become active labels. Private law equalities also retain zero ambient atoms; no unique null conditional completion is asserted.
- **Coverage:** checked private proof using public multiway constructor.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:87` — `auxiliaryChannel_map_fst` (private proof/fixture locator): Exact original-channel recovery by projection.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:579` — `originalPps` (private proof/fixture locator): Actual positive-posterior PPS family.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:663` — `originalBridge` (private proof/fixture locator): Concrete homogeneous PPS cascade and exact shared endpoint.
  - `PerfectFunctionalRepresentations/Matrix/MultiwayOperations.lean:488` — `multiPpsFamilyOfENNReal` (declaration): Actual finite binary path on original positive weight labels.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.4 paragraph after (18).
- **Omission/disposition relation:** OM-021, OM-051, OM-052

### C16-PROSE-APP-05 — ISIT p.5 right top, same paragraph: sufficiency of auxiliary→seed and inverse-operation reduction

- **Printed:** It suffices to reduce the auxiliary by PPM/VPM; by inverse pairs, construct it from the seed via PPS/VPS.
- **Intended:** Compose witnessed paths meeting the exact same auxiliary endpoint, reverse with remembered legal data and directed inverse maps.
- **Lean:** seedBridge has PPS then VPS; originalBridge has PPS; canonicalToAllOnes composes originalBridge with seedBridge.reverse, with chronological word PPS/VPM/PPM.
- **Hypotheses/boundary:** Finite nonempty input and finite output; q is a PMF of full decoder vectors and V a total common posterior, with auxiliaryChannel q x = PMF.channelJoint (kappa x) V for every x. Only positive-q vectors and nonempty decoder fibers become active labels. Private law equalities also retain zero ambient atoms; no unique null conditional completion is asserted.
- **Coverage:** checked private constructive proof.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:1663` — `seedBridge` (private proof/fixture locator): Actual composed PPS/VPS paths to commonEndpoint.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:2334` — `canonicalToAllOnes / canonicalFromAllOnes` (private proof/fixture locator): Witnessed compositions, with directed maps verified at 2409–2449.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:2387` — `canonicalToAllOnes_word` (private proof/fixture locator): Reduction word is original PPS followed by reversed VPS then reversed seed PPS.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.4 paragraph after (18).
- **Omission/disposition relation:** OM-021, OM-051, OM-052

### C16-EQ23 — ISIT p.5 right upper, Equation (23)

- **Printed:** Fix w and define Y′_w to be outputs (y,w) in Y′.
- **Intended:** For positive w, retain exactly y that occur as w(x); exclude empty decoder fibers when using active output labels.
- **Lean:** auxiliaryChannel_active_iff and decoderLabelsEquiv identify active auxiliary labels with Σ w:q.support, {y // ∃x,w x=y}, retaining original (y,w).
- **Hypotheses/boundary:** Finite nonempty input and finite output; q is a PMF of full decoder vectors and V a total common posterior, with auxiliaryChannel q x = PMF.channelJoint (kappa x) V for every x. Only positive-q vectors and nonempty decoder fibers become active labels. Private law equalities also retain zero ambient atoms; no unique null conditional completion is asserted.
- **Coverage:** checked private exact label equivalence.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:213` — `auxiliaryChannel_active_iff` (private proof/fixture locator): Active iff q(w)>0 and some input decodes to y.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:289` — `decoderLabelsEquiv` (private proof/fixture locator): Both directions preserve the exact ordered pair.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.4 (19).
- **Omission/disposition relation:** OM-021, OM-045, OM-052

### C16-PROSE-APP-06 — ISIT p.5 right upper, paragraph after (23) before (24)

- **Printed:** The Y′_w sets partition Y′; for fixed x,w exactly one (y,w) is positive, namely the decoder.
- **Intended:** Keep w as an index, including distinct w with equal decoder-support patterns; positivity requires supported w.
- **Lean:** decoderLabelsEquiv gives the disjoint sigma decomposition and auxiliaryChannel_unique_in_block proves unique positive y at each row and supported w.
- **Hypotheses/boundary:** Finite nonempty input and finite output; q is a PMF of full decoder vectors and V a total common posterior, with auxiliaryChannel q x = PMF.channelJoint (kappa x) V for every x. Only positive-q vectors and nonempty decoder fibers become active labels. Private law equalities also retain zero ambient atoms; no unique null conditional completion is asserted.
- **Coverage:** checked private proof.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:289` — `decoderLabelsEquiv` (private proof/fixture locator): Exact supported-w block decomposition.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:388` — `auxiliaryChannel_unique_in_block` (private proof/fixture locator): Unique positive decoder output in each supported block.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.4 paragraph between (19) and (20).
- **Omission/disposition relation:** OM-021, OM-052

### C16-EQ24 — ISIT p.5 right upper/middle, Equation (24)

- **Printed:** The decoder output (y,w) has positive auxiliary mass at x.
- **Intended:** Positivity is q(w)>0 at y=w(x).
- **Lean:** auxiliaryChannel_apply gives the exact if w(x)=y then q(w) else 0 formula for all ambient atoms; support restriction supplies positivity.
- **Hypotheses/boundary:** Finite nonempty input and finite output; q is a PMF of full decoder vectors and V a total common posterior, with auxiliaryChannel q x = PMF.channelJoint (kappa x) V for every x. Only positive-q vectors and nonempty decoder fibers become active labels. Private law equalities also retain zero ambient atoms; no unique null conditional completion is asserted.
- **Coverage:** checked private atom identity.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:37` — `auxiliaryChannel_apply` (private proof/fixture locator): Exact full ambient atom formula, including zero cases.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:388` — `auxiliaryChannel_unique_in_block` (private proof/fixture locator): Supported-w unique positive output.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:436` — `commonEndpoint_value` (private proof/fixture locator): The admitted auxiliary column value is q(w).
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.4 (20).
- **Omission/disposition relation:** OM-021, OM-042

### C16-EQ25 — ISIT p.5 right upper/middle, Equation (25)

- **Printed:** Every other output (ỹ,w) in the fixed-w block has zero auxiliary mass at x.
- **Intended:** The exact decoder indicator vanishes for ỹ≠w(x).
- **Lean:** auxiliaryChannel_apply gives the exact if w(x)=y then q(w) else 0 formula for all ambient atoms; support restriction supplies positivity.
- **Hypotheses/boundary:** Finite nonempty input and finite output; q is a PMF of full decoder vectors and V a total common posterior, with auxiliaryChannel q x = PMF.channelJoint (kappa x) V for every x. Only positive-q vectors and nonempty decoder fibers become active labels. Private law equalities also retain zero ambient atoms; no unique null conditional completion is asserted.
- **Coverage:** checked private atom identity.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:37` — `auxiliaryChannel_apply` (private proof/fixture locator): Exact full ambient atom formula, including zero cases.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:388` — `auxiliaryChannel_unique_in_block` (private proof/fixture locator): Supported-w unique positive output.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:436` — `commonEndpoint_value` (private proof/fixture locator): The admitted auxiliary column value is q(w).
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.4 (21).
- **Omission/disposition relation:** OM-021, OM-042

### C16-EQ26 — ISIT p.5 right upper/middle, Equation (26)

- **Printed:** The decoder auxiliary mass is exactly pW(w)>0, independent of x.
- **Intended:** For supported w its nonzero mass is q(w) at every input row.
- **Lean:** auxiliaryChannel_apply gives the exact if w(x)=y then q(w) else 0 formula for all ambient atoms; support restriction supplies positivity.
- **Hypotheses/boundary:** Finite nonempty input and finite output; q is a PMF of full decoder vectors and V a total common posterior, with auxiliaryChannel q x = PMF.channelJoint (kappa x) V for every x. Only positive-q vectors and nonempty decoder fibers become active labels. Private law equalities also retain zero ambient atoms; no unique null conditional completion is asserted.
- **Coverage:** checked private atom identity.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:37` — `auxiliaryChannel_apply` (private proof/fixture locator): Exact full ambient atom formula, including zero cases.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:388` — `auxiliaryChannel_unique_in_block` (private proof/fixture locator): Supported-w unique positive output.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:436` — `commonEndpoint_value` (private proof/fixture locator): The admitted auxiliary column value is q(w).
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.4 (22).
- **Omission/disposition relation:** OM-021, OM-042

### C16-PROSE-APP-07 — ISIT p.5 right middle, sentence immediately after (26)

- **Printed:** The displayed positive value does not depend on x.
- **Intended:** One supported-w block has the constant admitted nonzero value q(w).
- **Lean:** Exact auxiliary atoms and commonEndpoint_value identify each block value as q(w), while zeros still depend on the decoder fiber.
- **Hypotheses/boundary:** Finite nonempty input and finite output; q is a PMF of full decoder vectors and V a total common posterior, with auxiliaryChannel q x = PMF.channelJoint (kappa x) V for every x. Only positive-q vectors and nonempty decoder fibers become active labels. Private law equalities also retain zero ambient atoms; no unique null conditional completion is asserted.
- **Coverage:** checked private proof.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:37` — `auxiliaryChannel_apply` (private proof/fixture locator): Every positive decoder atom equals q(w).
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:436` — `commonEndpoint_value` (private proof/fixture locator): Same admitted value for all columns in that fixed-w block.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.4 sentence after (22).
- **Omission/disposition relation:** OM-021

### C16-EQ27 — ISIT p.5 right middle, Equation (27)

- **Printed:** S_y′ is the set of input indices x decoding to the fixed output y′=(y,w).
- **Intended:** Use the exact nonempty fiber of w at an occurring y, with arbitrary finite input semantics before ordered presentation.
- **Lean:** decoderBlocks is univ.filter (w x=y); commonEndpoint_pattern and decoder-pattern equivalences identify it with the admitted column pattern.
- **Hypotheses/boundary:** Finite nonempty input and finite output; q is a PMF of full decoder vectors and V a total common posterior, with auxiliaryChannel q x = PMF.channelJoint (kappa x) V for every x. Only positive-q vectors and nonempty decoder fibers become active labels. Private law equalities also retain zero ambient atoms; no unique null conditional completion is asserted.
- **Coverage:** checked private definitions/proofs.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:315` — `decoderBlocks` (private proof/fixture locator): Exact finite decoder fiber.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:447` — `commonEndpoint_pattern / commonEndpoint_decoder_pattern` (private proof/fixture locator): Equality with the actual auxiliary column pattern.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.4 (23).
- **Omission/disposition relation:** OM-014, OM-021, OM-052, OM-068

### C16-EQ28 — ISIT p.5 right middle, Equation (28) and immediate exactly-one clause

- **Printed:** For every x,w, the displayed auxiliary-mass times posterior family has exactly one nonzero entry.
- **Intended:** Use supported w and the specified deterministic projection posterior; retain the indexed output label rather than forgetting repeated numeric values.
- **Lean:** auxiliary_weighted_positive_iff and auxiliary_unique_weighted_positive prove exactly one active labelled pair, including zero products off the fixed-w block.
- **Hypotheses/boundary:** Finite nonempty input and finite output; q is a PMF of full decoder vectors and V a total common posterior, with auxiliaryChannel q x = PMF.channelJoint (kappa x) V for every x. Only positive-q vectors and nonempty decoder fibers become active labels. Private law equalities also retain zero ambient atoms; no unique null conditional completion is asserted.
- **Coverage:** checked private proof.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:524` — `auxiliary_weighted_positive_iff` (private proof/fixture locator): Characterizes positive products with the pure projection posterior.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:538` — `auxiliary_unique_weighted_positive` (private proof/fixture locator): Indexed uniqueness for each x and positive-q w.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.4 (24).
- **Omission/disposition relation:** OM-021, OM-042

### C16-PROSE-APP-08 — ISIT p.5 right, paragraph after (28), partition and Boolean-indicator sentences

- **Printed:** For each w, the decoder sets partition {1,…,k}; b_y′ is the 0/1 membership vector.
- **Intended:** Only nonempty fibers form partition parts; the parts are pairwise disjoint, cover all inputs and keep their y,w labels.
- **Lean:** decoderBlocks_nonempty/disjoint/cover construct decoderPartition via partitionOfBlocks; seedPartition uses the actual intermediate admitted pattern and exact labels.
- **Hypotheses/boundary:** Finite nonempty input and finite output; q is a PMF of full decoder vectors and V a total common posterior, with auxiliaryChannel q x = PMF.channelJoint (kappa x) V for every x. Only positive-q vectors and nonempty decoder fibers become active labels. Private law equalities also retain zero ambient atoms; no unique null conditional completion is asserted.
- **Coverage:** checked private proof using public finite partition adapter.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:318` — `decoderBlocks_nonempty / _disjoint / _cover / decoderPartition` (private proof/fixture locator): All exact finite-partition laws.
  - `PerfectFunctionalRepresentations/Matrix/Partitions.lean:42` — `partitionOfBlocks / partitionOfBlocksEquiv` (declaration): Retains a finite labelled family of nonempty disjoint exact-cover blocks.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:1529` — `seedPartition` (private proof/fixture locator): Parts partition the actual seed-PPS column support.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 pp.4–5 paragraph after (24).
- **Omission/disposition relation:** OM-014, OM-021, OM-038, OM-052, OM-068

### C16-PROSE-APP-09 — ISIT p.5 right, final paragraph after (28), seed PPS coefficients c_w=pW(w)

- **Printed:** Split 1_k with coefficients c_w=pW(w), yielding all-ones-pattern columns of value c_w for every w.
- **Intended:** The finite positive weights sum to one; realize them by strict binary PPS paths. Singleton support yields a valid zero-length stage.
- **Lean:** seedPps uses multiPpsOfENNReal on q; exact coordinates, all-ones patterns and admitted values retain original positive-w labels.
- **Hypotheses/boundary:** Finite nonempty input and finite output; q is a PMF of full decoder vectors and V a total common posterior, with auxiliaryChannel q x = PMF.channelJoint (kappa x) V for every x. Only positive-q vectors and nonempty decoder fibers become active labels. Private law equalities also retain zero ambient atoms; no unique null conditional completion is asserted.
- **Coverage:** checked private construction using public multiway synthesis.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:1481` — `seedPps` (private proof/fixture locator): Concrete homogeneous PPS stage on q-positive labels.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:1494` — `seedPps_apply / seedPps_pattern / seedPps_value` (private proof/fixture locator): Exact q(w), all-ones pattern and value.
  - `PerfectFunctionalRepresentations/Matrix/MultiwayOperations.lean:468` — `multiPpsOfENNReal` (declaration): Normalized ENNReal family converted exactly; original positive labels retained.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.4–5 final Theorem 1 construction paragraph.
- **Omission/disposition relation:** OM-021, OM-049, OM-052

### C16-PROSE-APP-10 — ISIT p.5 right, final paragraph after (28), VPS construction and Figure 1 reference

- **Printed:** Split each fixed-w all-ones column by the b_y′ patterns to obtain the entire auxiliary matrix.
- **Intended:** Build legal binary VPS cascades from exact nonempty decoder partitions; identify every resulting coordinate with the same auxiliary endpoint used by original posterior splitting.
- **Lean:** seedVps, its exact labels/coordinates/value/pattern proofs and seedVpsBridge construct the actual auxiliary matrix, then seedBridge appends actual PPS and VPS stages.
- **Hypotheses/boundary:** Finite nonempty input and finite output; q is a PMF of full decoder vectors and V a total common posterior, with auxiliaryChannel q x = PMF.channelJoint (kappa x) V for every x. Only positive-q vectors and nonempty decoder fibers become active labels. Private law equalities also retain zero ambient atoms; no unique null conditional completion is asserted.
- **Coverage:** checked private constructive proof using public multiway operations.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:1550` — `seedVps / seedVps_decoder_coordinates` (private proof/fixture locator): Actual multiVpsFamily on exact decoder partitions.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:1605` — `seedVpsLabels / seedVps_coordinates / seedVps_pattern / seedVps_value` (private proof/fixture locator): Original y,w labels, every mass, pattern and value.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:1658` — `seedVpsBridge / seedBridge` (private proof/fixture locator): Directed comparison to the supplied commonEndpoint, with actual finite stages.
  - `PerfectFunctionalRepresentations/Matrix/MultiwayOperations.lean:771` — `multiVpsFamily` (declaration): One actual finite homogeneous VPS path for all source-column partitions.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 pp.4–5 final construction and Figure 1.
- **Omission/disposition relation:** OM-020, OM-021, OM-038, OM-049, OM-052

### C16-FIG01 — ISIT p.5 right bottom, Figure 1 artwork and caption

- **Printed:** Within fixed-w blocks entries are c_w or zero, one positive per row; VPM makes c_w 1_k per block and PPM makes 1_k. Caption states VPM/PPM reduction.
- **Intended:** Check the mathematical construction and its witnessed reversed stages; reproducing artwork is not a formalization target.
- **Lean:** Decoder partition/value/uniqueness and exact seed coordinates prove the pictured block structure; reversing seedBridge gives VPM then PPM, with exact directed output maps and original labels.
- **Hypotheses/boundary:** Finite nonempty input and finite output; q is a PMF of full decoder vectors and V a total common posterior, with auxiliaryChannel q x = PMF.channelJoint (kappa x) V for every x. Only positive-q vectors and nonempty decoder fibers become active labels. Private law equalities also retain zero ambient atoms; no unique null conditional completion is asserted.
- **Coverage:** checked private constructive proof; artwork intentionally omitted.
- **Current source evidence:**
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:388` — `auxiliaryChannel_unique_in_block` (private proof/fixture locator): One positive output per row per fixed supported vector.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:1614` — `seedVps_coordinates / seedVps_value` (private proof/fixture locator): Every pictured block mass is the exact q(w) or zero.
  - `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:2334` — `canonicalToAllOnes` (private proof/fixture locator): Uses actual seedBridge.reverse, not only a numerical existence argument.
- **Validation status:** E02 fresh whole-page and current-source inspection; E04 parent build of the original maintained module.
- **Extended dependency:** v16 p.5 Figure 1 and the same proof construction.
- **Omission/disposition relation:** OM-020, OM-021, OM-051, OM-052

## Version-bound extended proof dependencies

### C16-X-MATRIX-01 — v16 pp.3–4, Operations 2 and 4

- **Role:** clarification.
- **Logical content:** Both merge source indices range over all m+1 columns; lower-index survivor and higher-index deletion.
- **Actual source:** `PerfectFunctionalRepresentations/Matrix/Operations.lean:565`; `PerfectFunctionalRepresentations/Matrix/Operations.lean:1476`; `PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean:274`; `PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean:332`.
- **Recorded dispositions:** OM-024, OM-070.

### C16-X-MATRIX-02 — v16 p.14 Appendix B, (167)

- **Role:** proof companion.
- **Logical content:** VPS patterns are disjoint and have ordinary sum equal to original pattern.
- **Actual source:** `PerfectFunctionalRepresentations/Matrix/Operations.lean:1243`; `PerfectFunctionalRepresentations/Matrix/Operations.lean:1620`.
- **Recorded dispositions:** OM-038, OM-042.

### C16-X-MATRIX-03 — v16 p.14 Appendix B, (168)–(169)

- **Role:** proof companion.
- **Logical content:** PPM followed by PPS: disjoint commute or overlapping PPS/PPS/PPM/PPM replacement; complete exact-endpoint local cases.
- **Actual source:** `PerfectFunctionalRepresentations/Matrix/OperationCalculus.lean:1884`.
- **Recorded dispositions:** OM-042, OM-051.

### C16-X-MATRIX-04 — v16 p.14 Appendix B, (170)–(171)

- **Role:** proof companion with ordering repair.
- **Logical content:** VPS followed by PPS: disjoint/left-child/right-child cases and necessary directed output permutation after the replacement.
- **Actual source:** `PerfectFunctionalRepresentations/Matrix/OperationCalculus.lean:1910`.
- **Recorded dispositions:** OM-042, OM-051.

### C16-X-MATRIX-05 — v16 p.15 Appendix B, (172)–(174) and termination paragraph

- **Role:** proof companion plus replacement of incomplete termination argument.
- **Logical content:** PPM followed by VPS replacements and exactly three inversion types are checked; global proof instead uses original-path induction and finite realization. No arbitrary rewrite-strategy termination, uniqueness, confluence or complexity claim.
- **Actual source:** `PerfectFunctionalRepresentations/Matrix/OperationCalculus.lean:1896`; `PerfectFunctionalRepresentations/Matrix/OperationCalculus.lean:1933`; `PerfectFunctionalRepresentations/Matrix/OperationFactorization.lean:800`; `PerfectFunctionalRepresentations/Matrix/OperationFactorization.lean:1988`.
- **Recorded dispositions:** OM-042, OM-043, OM-051.

### C16-X-MATRIX-06 — v16 p.15 Appendix B, (175)–(183)

- **Role:** proof companion.
- **Logical content:** Canonical full-vector witness, single shared PPS Bernoulli branch, full joint/posterior factorization for affected and retained labels.
- **Actual source:** `PerfectFunctionalRepresentations/Matrix/Preservation.lean:91`; `PerfectFunctionalRepresentations/Matrix/Preservation.lean:155`; `PerfectFunctionalRepresentations/Matrix/Preservation.lean:179`; `PerfectFunctionalRepresentations/Matrix/Preservation.lean:209`.
- **Recorded dispositions:** OM-042, OM-048.

### C16-X-MATRIX-07 — v16 pp.15–16 Appendix B, (184)–(195)

- **Role:** proof companion.
- **Logical content:** Whole-vector PPM collapse, positive admitted-value ratio, fixed posterior mixture, explicit null-row zero products and full joint law.
- **Actual source:** `PerfectFunctionalRepresentations/Matrix/Preservation.lean:439`; `PerfectFunctionalRepresentations/Matrix/Preservation.lean:491`; `PerfectFunctionalRepresentations/Matrix/Preservation.lean:519`; `PerfectFunctionalRepresentations/Matrix/Preservation.lean:540`; `PerfectFunctionalRepresentations/Matrix/Preservation.lean:573`.
- **Recorded dispositions:** OM-042, OM-048, OM-051.

### C16-X-MATRIX-08 — v16 p.16 Appendix B, (196)–(202)

- **Role:** proof companion.
- **Logical content:** Whole-vector deterministic masked VPS and both-child posterior factorization, including value one and null fibers.
- **Actual source:** `PerfectFunctionalRepresentations/Matrix/Preservation.lean:888`; `PerfectFunctionalRepresentations/Matrix/Preservation.lean:915`; `PerfectFunctionalRepresentations/Matrix/Preservation.lean:929`.
- **Recorded dispositions:** OM-038, OM-042, OM-048, OM-049.

### C16-X-MATRIX-09 — v16 p.16 Appendix B, proof of Lemma 6

- **Role:** proof companion.
- **Logical content:** Contraposition through witnessed recoveries. Values, masks and directed output bijections remain explicit.
- **Actual source:** `PerfectFunctionalRepresentations/Matrix/Preservation.lean:1192`; `PerfectFunctionalRepresentations/Matrix/Preservation.lean:1211`; `PerfectFunctionalRepresentations/Matrix/Preservation.lean:1229`; `PerfectFunctionalRepresentations/Matrix/Reachability.lean:1`.
- **Recorded dispositions:** OM-051.

### C16-X-MATRIX-10 — v16 pp.4–5, Theorem 1 proof (16)–(24), Figure 1

- **Role:** parallel extended proof and clarification.
- **Logical content:** Exact counterpart of ISIT (20)–(28); full supported canonical law, decoder blocks and both concrete paths to the same auxiliary endpoint.
- **Actual source:** `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:33`; `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:118`; `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:213`; `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:315`; `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:579`; `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:1481`; `PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean:2334`.
- **Recorded dispositions:** OM-020, OM-021, OM-042, OM-048, OM-051, OM-052.


## C16-X-MATRIX-11 — Extended v16 p.5, Example 6, (25)–(32), every operation sentence and concluding perfectness sentence

**Role:** Completed C10 illustrative reachability fixture; supplements the ISIT Theorem 1 proof/operation interpretation without enlarging primary ISIT scope

**Printed:** The displayed three-input five-output matrix reduces to the all-ones column by VPM, PPM, VPM, PPM. Displays (26)/(27) and (28)/(29) repeat the valued-pattern forms; (30) reorders the final two columns relative to lower-survivor merging. The concluding sentence infers perfectness.

**Intended:** Retain lower-survivor operation semantics and compare the displayed (30) by an explicit output transposition. Supply every coordinate, legality witness, entire finite reduction and actual reverse; the permutation is a comparison, not an extra operation.

**Lean:** All fixtures are private in Examples.Reachability. The exact-order path uses zero-based source pairs (1,2), (1,3), (0,2), (0,1). The second result is [A/3,2U/3,B/3]; the displayed result is [A/3,B/3,2U/3]. display30Equiv maps actual second to printed30 using Equiv.swap 1 2. The four-edge reduction has tags [vpm,ppm,vpm,ppm], length 4 and an identity-index final output equivalence to allOnes. reconstruction is reduction.reverse, with tags [pps,vps,pps,vps], length 4 and Normalizing proof. source_fromAllOnes yields intrinsic perfectness without an input prior.

**Hypotheses:** Concrete Fin 3 inputs and Fin 5 initial outputs; normalized NNReal masses, active columns and singularity are proved. Every VPM has equal admitted values and disjoint support; every PPM has identical support. No input-law/full-support premise.

**Coverage:** Private independently specified matrices and quantified coordinate proofs, exact directed output equivalence, concrete operation certificate and reverse, anonymous consumers

**Actual assertions:**

- `PerfectFunctionalRepresentations/Examples/Reachability.lean:26` — `matrix25; patterns26; columns26; source_coordinates; source_values; source_patterns; anonymous consumer at 79`: (25): all 15 exact masses; (26)/(27): all five values equal 1/3 and every pattern/valued-column coefficient in the printed order.
- `PerfectFunctionalRepresentations/Examples/Reachability.lean:92` — `first; firstEdge; matrix28; columns29; first_coordinates; anonymous consumer at 131`: (27)→(28): actual VPM at source columns 1,2; all 12 coordinates. (28)/(29): complete corresponding valued-column equality.
- `PerfectFunctionalRepresentations/Examples/Reachability.lean:141` — `second; secondEdge; matrix30Actual; second_coordinates; matrix30; printed30`: (29)→(30): actual PPM at current columns 1,3; all nine actual and independently specified displayed coordinates.
- `PerfectFunctionalRepresentations/Examples/Reachability.lean:196` — `display30_coordinates; display30Equiv; anonymous consumers at 208/212`: Exact directed law (second.channel x).map (Equiv.swap 1 2) = printed30.channel x; label 0 fixed, 1↦2 and 2↦1. This output comparison is not counted as a fifth operation.
- `PerfectFunctionalRepresentations/Examples/Reachability.lean:236` — `third; thirdEdge; matrix31; third_coordinates`: (31): actual-order VPM merges columns 0,2 (the displayed first two after swap) and proves all six coordinates [U/3,2U/3].
- `PerfectFunctionalRepresentations/Examples/Reachability.lean:274` — `fourth; fourthEdge; matrix32; fourth_coordinates`: (32): final PPM at columns 0,1 gives all three masses equal to one.
- `PerfectFunctionalRepresentations/Examples/Reachability.lean:294` — `reductionPath; finalEquiv; reduction; reduction_tags; reduction_reducing; reconstruction; reconstruction_normalizing; source_fromAllOnes; anonymous consumers 308,319,323,330,336`: Full actual four-operation reduction to allOnes; actual witnessed reverse and exact reverse tags/length; ToAllOnes, FromAllOnes and prior-free perfectness.

**Evidence:** C16-E07 supplemental helper and parent inspection: fresh full-file source/body inspection and fresh full rendered v16 p.5 visual inspection. Original v16 PDF freshly rehashed and matched the earlier rendered source. No fresh build/probe by this helper; C16-E04 supplies the fresh build, with the identical source hash confirmed by the parent. No independent review or S02 trust audit.
**Fresh inspection timestamp (UTC):** `2026-10-02T22:16:13.764983+00:00`.
**Fresh v16 SHA-256:** `98636d4c9f0618ec08fca84559572780f604f197fda90d8d7c787b3624245b8f`.
**Examples.Reachability SHA-256:** `cf36a395a0783c08e7d124e5602b81efd55a86d37a913c0c92e8fc5916255f36`.

**Disposition:** Existing OM-071 exactly matches the source and displayed matrix order. No new discrepancy. Related records: OM-027, OM-071, OM-024, OM-051.


## Optimization and concluding source rows

These rows use **C16-E03** (parent original-page and actual-source inspection),
**C16-E04** (fresh builds), and extended dependencies **C16-X10–X12** below.
No row has an unresolved mathematical issue. Final API disposition belongs to S03.

### Shared precise contracts for IV

**C16-I-LP.** The LP domain is `[Fintype α] [Nonempty α] [Finite β]`,
`κ : α → PMF β`, with supplied `IsSingularChannel κ` for compression. Its
`CompressedPatternData α` has distinct nonempty patterns, strictly positive Real
values and normalization separately at each input. Ambient unused output symbols
are removed and recovered by the existing active-channel bridge. Pattern values
need not sum to one. The finite types of occurring patterns and admissible exact
partitions need not be literal `Fin` types; supplied equivalences give the paper's
coordinates. An admissible partition family may be empty.

**C16-I-FULL.** ISIT IV-A informally combines all Bell partitions with occurring
pattern rows. The intended contract uses either all nonzero patterns with absent
values zero, or occurring patterns with only partitions whose blocks occur.
Nonnegative equality feasibility is equivalent under restriction and zero extension.
The mixed system is not accepted; equality alone does not imply coefficient bounds
without nonnegativity. This is the already approved DG-12/OM-025/047 repair, made
explicit by extended v16 (39)–(56), not a new S01 interpretation. The general Bell
enumeration theorem remains OM-017. Reduced primal/dual inequalities and objective
images are stated on their own terms; equality transport is not silently reused for
full/reduced LP equivalence.

**C16-I-EXTREMA.** `IsGreatest (Primal.objectiveValues D) 1` and
`IsLeast (Dual.objectiveValues D) 1` include attainment and the relevant universal
bound. A dual feasible vector with objective one alone is insufficient. The proofs
cover empty partition families. The dual proof uses a specialized finite convex
separation argument, not an imported generic strong-duality theorem.

Owner abbreviations in this section are links to actual source files:
[Compression](../PerfectFunctionalRepresentations/Matrix/PatternCompression.lean),
[Incidence](../PerfectFunctionalRepresentations/Optimization/Incidence.lean),
[Construction](../PerfectFunctionalRepresentations/Optimization/IncidenceConstruction.lean),
[Primal](../PerfectFunctionalRepresentations/Optimization/Primal.lean),
[Dual](../PerfectFunctionalRepresentations/Optimization/Dual.lean),
[Dual characterization](../PerfectFunctionalRepresentations/Optimization/DualCharacterization.lean),
[incidence fixtures](../PerfectFunctionalRepresentations/Tests/Examples/Incidence.lean).
Names below are in `PerfectFunctionalRepresentations`, with the displayed subnamespace.

| Stable row | Exact ISIT anchor; printed claim | Intended reading / precise Lean contract | Coverage mode and actual owner | Companion / disposition |
| --- | --- | --- | --- | --- |
| C16-EQ16 | p4 right, IV-A, weight sum over partitions containing each pattern | C16-I-LP/FULL: `Incidence.Feasible D w` is coefficient nonnegativity and `reducedMatrix D *ᵥ w = D.value`; `FullFeasible` is the zero-padded alternative. | Public definitions in Incidence; `exists_fullFeasible_iff`, `reduced_unit_iff`, `full_unit_iff` check equivalence and upper bounds. | X10; DG-12, OM-047. |
| C16-EQ17 | p4 right, Example7, displayed 7×5 matrix | The specified seven patterns and five partitions in their printed orders give all 35 entries. | Compiling private fixture `paperMatrix`, `paper_entries`, `paper_fullMatrix` in incidence fixtures, lines1392–1407; all-pattern reduced equality at lines1454–1458. | X10; OM-027; no public example alias. |
| C16-EQ18 | p5 left, Theorem2, primal maximum one | C16-I-LP/EXTREMA: nonnegative coefficients, coordinatewise `H*x ≤ v`, objective sum; attained greatest value one iff perfect. | Public `Primal.Feasible`, `objectiveValues`, `isPerfectlyRepresentableChannel_iff_isGreatest` and `_compressedPatternData`; proof uses saturation of nonnegative slack and C13 equality. | X11; OM-018/047. |
| C16-EQ19 | p5 left, Corollary1, dual minimum one | C16-I-LP/EXTREMA: nonnegative occurring-pattern vector, transpose inequalities and value dot product. | Public Dual `Feasible`, `objectiveValues`, `isPerfectlyRepresentableChannel_iff_isLeast` and `_compressedPatternData` in Dual characterization. | X12; OM-025/039/047. |
| C16-THM02 | p5 left, Theorem2 including its conditional data construction | C16-EQ18 plus supplied singularity; no data is fabricated for a nonsingular channel. | Same public primal endpoints; finite-coordinate transport in `objectiveValues_reindex`. | X11; OM-018. |
| C16-COR01 | p5 left, Corollary1 | C16-EQ19 including attained leastness; exact reduced system, finite nonempty input. | Same public dual endpoints, `_reindex` and `_compressedPatternData_reindex`; private separator and public `exists_feasible_objective_lt_one_of_not_perfect` prove reverse direction. | X12; OM-025/039. |
| C16-EX06 | p4 right, Example6, three-input partitions | The whole block, the three pair/singleton partitions and all singletons exhaust the five exact partitions. | Compiling private `partition_cases`, bijective `paperPartitions`, `paperColumns`, and anonymous cardinality-five fixture, lines1324–1390. | Extended Example7 (35)–(38); X10, OM-027. General Bell identity is OM-017. |
| C16-EX07 | p4 right, Example7 patterns and matrix | C16-EQ17 with exhaustive row/column equivalences; no arbitrary numbering silently substituted. | `paperRows`, `paperColumns`, `paper_entries`, `paper_fullMatrix`; the actual proper reduced 4×2 submatrix is checked by `r13Paper_submatrix` and adjacent exact entries. | Extended Example8 (57)–(63); X10, OM-027. |

### Every IV prose occurrence

Each row inherits the precise hypotheses above and E03/E04. Distinct occurrences
are retained even when they restate the same theorem. Textual locators bound the
source region; short descriptions paraphrase the content.

| Stable row | Page / column / bounded region | Claim and precise disposition | Actual owner / companion / OM |
| --- | --- | --- | --- |
| C16-PROSE-IV-01 | p4 left, IV opening paragraph | Frames checking perfect representability; the mathematical problem is the channel predicate under C16-I-LP. | `IsPerfectlyRepresentableChannel`; EQ18/19; solver OM-018. |
| C16-PROSE-IV-02 | p4 left, next paragraph, first sentence about linear time | Singularity-test runtime is an intentional documentation disposition. | OM-016; no executable/runtime theorem. |
| C16-PROSE-IV-03 | p4 left, same paragraph, singularity reduction sentence | Nonsingular channels are excluded by necessity; finite LP branch uses supplied singularity. | `IsPerfectlyRepresentableChannel.isSingular` in Semantics/Singularity; only `[Nonempty α]` for necessity. OM-018; no broader wrapper needed for S01 coverage. |
| C16-PROSE-IV-04 | p4 left bottom, compression iff sentence | Equal-pattern aggregation preserves perfectness and actual construction/reduction reachability. | Compression `isPerfectlyRepresentableChannel_iff_compressedPatternData`, `isPerfectlyRepresentable_iff_patternCompressedState`, `fromAllOnes_iff_patternCompressedState`, `toAllOnes_iff_patternCompressedState`; OM-068. |
| C16-PROSE-IV-05 | p4 left bottom through right top, distinct-pattern and bound sentences | Active compressed columns have distinct nonempty patterns; `m ≤ 2^k−1`. | `occurringPatterns`, `CompressedPatternData`, Incidence `card_nonzeroPattern`, `patterns_card_le`; OM-014/019. |
| C16-PROSE-IV-06 | p4 right top, final value-vector sentence | Pattern/value data reconstruct the channel; positive active values are bounded by one, with row-wise normalization. | Compression `channel_apply`, `extraction_roundTrip`, `compressedPatternData_channel`, `value_le_one`; OM-068. |
| C16-PROSE-IV-A-01 | p4 right, first paragraph through real-arithmetic sentence | Nonzero binary vectors summing to one are exact partitions. | Incidence `exactPartition_indicator_sum`, `exists_exactPartition_of_indicator_sum` with complete block equivalence; X10. |
| C16-PROSE-IV-A-02 | p4 right, same paragraph, Bell-count sentence | Full partition count identified with Bell number by cited source. | OM-017; exact three-input case is EX06. |
| C16-PROSE-IV-A-03 | p4 right, question before (16) | Feasible coefficients lie in [0,1]; equivalently nonnegative equality coefficients under normalization. | Incidence `reduced_unit_iff`, `full_unit_iff`, `sum_eq_one_of_reduced_eq`; C16-I-FULL. |
| C16-PROSE-IV-A-04 | p4 right, numbered construction item1 | PPS from the seed realizes precisely positive coefficient labels; zero weights are discarded. | Construction `partitionConstruction`, field `pps`, `pps_pattern`, `partitionConstruction_pps_length`; X10. |
| C16-PROSE-IV-A-05 | p4 right, construction item2 | VPS splits each positive column into its exact nonempty partition blocks. | Same construction field `vps`, `vps_pattern`, exact coordinates; private `vpsResult`. |
| C16-PROSE-IV-A-06 | p4 right, construction item3 | PPM merges blocks sharing their occurring pattern. | Same construction field `ppm`, `ppm_pattern`, `partitionConstruction_ppm_length`, private `ppmMass`. |
| C16-PROSE-IV-A-07 | p4 right, paragraph invoking Lemma4 | Existence of a cascade is equivalent to feasible weights; same supplied feasible vector drives forward construction. | Construction `exists_feasible_iff_fromAllOnes`, `isPerfectlyRepresentableChannel_iff_exists_partitionConstruction`; no signed same-vector converse is claimed. |
| C16-PROSE-IV-A-08 | p4 right, definition of H before Example7 | H is pattern/partition membership incidence, after the approved full/reduced repair. | Incidence `fullMatrix`, `reducedMatrix`, apply lemmas; C16-I-FULL, X10, OM-047. |
| C16-PROSE-IV-A-09 | p4 right bottom, coefficient-vector paragraph through iff | Coordinate sums are `H*x=v`; existence with nonnegative coefficients iff perfect. | Construction `isPerfectlyRepresentableChannel_iff_exists_feasible`, `_exists_fullFeasible`, both ambient bridges. |
| C16-PROSE-IV-A-10 | p4 right bottom, final coefficient-bound sentence | Every nonnegative equality coefficient is at most one. The printed omission of the sign premise is retained as a documented repair. | Incidence `reduced_weight_le_one`, `full_weight_le_one`; signed obstruction in fixtures. OM-047. |
| C16-PROSE-IV-A-11 | p5 left top, pre-Theorem2 transition | Restates nonnegative equality feasibility as the characterization. | C16-EQ16 / Construction iff; X11. |
| C16-PROSE-IV-A-12 | p5 left, after Theorem2, algorithm sentence | Mathematical reduction to LP is EQ18; executing a solver is excluded. | Primal ambient iff; OM-018. |
| C16-PROSE-IV-A-13 | p5 left, same paragraph, nonsingular rejection | Necessity allows rejection before constructing LP data. | Singularity theorem as IV-03; OM-018. |
| C16-PROSE-IV-B-01 | p5 left, Dual LP opening | Dual alternative with `m` variables belongs to the reduced system. | C16-EQ19; Dual types, C16-I-FULL/EXTREMA; X12, OM-025. |
| C16-PROSE-IV-B-02 | p5 left, after (19), variable tuple and bound | Exact occurring-pattern count and finite-coordinate presentation; upper bound `2^k−1`. | Incidence `card_occurringPattern`, `patterns_card_le`; Dual `objectiveValues_reindex`; X12. |
| C16-PROSE-IV-C-01 | p5 left, conclusion first sentence | Restates necessary/sufficient structural characterization. | C16-THM01/02/COR01; finite nonempty channel domain. |
| C16-PROSE-IV-C-02 | p5 left, conclusion second sentence | LP formulation supplies a mathematical criterion; executable testing is deferred. | EQ18/19; OM-018. |
| C16-PROSE-IV-C-03 | p5 left, conclusion variable count and size comparison | Exact finite variable bound is proved; runtime/asymptotic size language is documentation-only. | `patterns_card_le`; OM-019, with general Bell count/growth OM-017. |
| C16-PROSE-IV-C-04 | p5 left, conclusion final two sentences | Constraint-count and open efficient-solvability discussion. | `card_admissiblePartition_le` gives structural inclusion bound; OM-017/019. Extended-only later answers remain OM-028–031. |
| C16-PROSE-REF-01 | p6 left, heading and bibliography [1]–[21] | Nonmathematical attribution/reference records; cited substantive assertions are separately classified at their occurrence. | Documentation disposition OM-023; no authorship/release-metadata verification. |
| C16-PROSE-REF-02 | p6 right, bibliography [22]–[33] | Same bibliography disposition; page ends after [33]. | OM-023. |

### Extended dependencies for IV

All refer to the exact extended-v16 digest in the source identity section.
Recheck the affected owners and interpretation if a replacement version is designated.

| ID | Exact companion anchor | Role and source relationship | Actual implementation |
| --- | --- | --- | --- |
| C16-X10 | IV opening p5 right; IV-A (33)–(63), pp5–7 left before Theorem2; Examples7–8 | Clarification/representation repair: full patterns, zero extension, admissible reduced partitions, nonnegative restriction/extension, coefficient normalization, actual three-phase construction. Examples fix five partitions and all 35 matrix coordinates. Bell identity remains background OM-017. | Compression; Incidence through `exists_fullFeasible_iff` and decoder extraction; Construction through actual phase endpoints and iff; incidence fixtures `paperPartitions`/`paper_entries`. |
| C16-X11 | IV-A Theorem2/(64), p7 left; AppendixB Theorem2 proof (203)–(221), p16 right–p17 left before AppendixC | Proof: `P*H=1`, `P*v=1`, primal upper bound, equality saturation and attaining witness. Nonempty input, active nonzero patterns and nonnegative slack are explicit in Lean. Printed maximum is realized as attained greatestness. | Incidence structural identities; Primal `objective_le_one`, `objective_eq_one_iff`, equality/attainment/greatestness endpoints. |
| C16-X12 | IV-B Corollary1/(65)–(67), p7 left; reduced-system setup (47)–(53), p6 left | Statement/clarification: reduced variables and minimum-one characterization. The companion does not provide the project's specialized separator proof; it is an alternative valid proof route, not a manuscript dependency on generic strong duality. (68) bounds partitions, with Bell enumeration background only. | Dual weak duality/row witness/coordinate transport; DualCharacterization finite convex hull separation, cardinality correction, normalized subunit certificate and attained leastness. Pinned mathlib separation and matrix dot-product identity. |

## Omission and deferred-work reconciliation

Each existing ID was revisited. This table records the S01 assessment; the map
retains every original row, rationale and historical checkpoint verbatim.
Earlier pre-F checkpoints are historical, with C01–C15 completion established
by the separate prerequisite record. No new omission is needed and no actual
gap is deferred. The helper's explicitly bounded inspection judgments remain
in the original private evidence; the integrated parent/matrix checks resolve
their later-owner references here. Extended-only exclusions are scope checks,
not claims that their mathematics was verified. Full release metadata remains
outside this audit.

| ID | S01 disposition | Fresh evidence / coverage route |
| --- | --- | --- |
| OM-001 | Retain the specific cited-result/context exclusion. Distinct assertions and repeated occurrences are recorded in semantic rows. | C16-E01; semantic I/II and Remark2 rows |
| OM-002 | Retain the specific cited-result/context exclusion. Distinct assertions and repeated occurrences are recorded in semantic rows. | C16-E01; semantic I/II and Remark2 rows |
| OM-003 | Retain the specific cited-result/context exclusion. Distinct assertions and repeated occurrences are recorded in semantic rows. | C16-E01; semantic I/II and Remark2 rows |
| OM-004 | Retain the specific cited-result/context exclusion. Distinct assertions and repeated occurrences are recorded in semantic rows. | C16-E01; semantic I/II and Remark2 rows |
| OM-005 | Retain the specific cited-result/context exclusion. Distinct assertions and repeated occurrences are recorded in semantic rows. | C16-E01; semantic I/II and Remark2 rows |
| OM-006 | Retain the specific cited-result/context exclusion. Distinct assertions and repeated occurrences are recorded in semantic rows. | C16-E01; semantic I/II and Remark2 rows |
| OM-007 | Retain the specific cited-result/context exclusion. Distinct assertions and repeated occurrences are recorded in semantic rows. | C16-E01; semantic I/II and Remark2 rows |
| OM-008 | Retain the specific cited-result/context exclusion. Distinct assertions and repeated occurrences are recorded in semantic rows. | C16-E01; semantic I/II and Remark2 rows |
| OM-009 | Retain the specific cited-result/context exclusion. Distinct assertions and repeated occurrences are recorded in semantic rows. | C16-E01; semantic I/II and Remark2 rows |
| OM-010 | Retain the specific cited-result/context exclusion. Distinct assertions and repeated occurrences are recorded in semantic rows. | C16-E01; semantic I/II and Remark2 rows |
| OM-011 | Retain the specific cited-result/context exclusion. Distinct assertions and repeated occurrences are recorded in semantic rows. | C16-E01; semantic I/II and Remark2 rows |
| OM-012 | Retain the specific cited-result/context exclusion. Distinct assertions and repeated occurrences are recorded in semantic rows. | C16-E01; semantic I/II and Remark2 rows |
| OM-013 | Retain the specific cited-result/context exclusion. Distinct assertions and repeated occurrences are recorded in semantic rows. | C16-E01; semantic I/II and Remark2 rows |
| OM-014 | Retain arbitrary finite/support types and explicit coordinate equivalences; no literal integer-support identification. | C16-E01–E03; K06/K07, III-A and IV contracts |
| OM-015 | Retain external significance narrative only. | C16-E01; IIB-02 |
| OM-016 | Retain linear-time singularity checking as documentation; semantic necessity remains proved. | C16-E02/E03; III-A and IV-02/03 |
| OM-017 | Retain general Bell identity/growth exclusion; the concrete five-partition case is actually checked. | C16-E03/E04; EX06, IV-A-02 |
| OM-018 | Retain solver deferral. Mathematical singular/nonsingular case split is covered; final no-wrapper disposition belongs to S03, reopened only for concrete consumer need. | C16-E03/E06; THM02/COR01, IV-A-12/13 |
| OM-019 | Retain runtime/open-efficiency exclusion; exact finite pattern-count bound remains proved. | C16-E03/E04; IV-C-03/04 |
| OM-020 | Retain artwork exclusion while checking the figure’s actual partition and operation construction. | C16-E02/E04; FIG01 |
| OM-021 | Retain proof-internal ownership for every Appendix display; no public-name quota. | C16-E02/E04; EQ20–28 |
| OM-022 | Retain metadata/ordinary-transition disposition; every mathematical restatement routes to a checked row. | C16-E01–E03; front, abstract, outline, IV-C and sweep |
| OM-023 | Retain bibliography/citation provenance; no cited work claimed formalized. | C16-E01/E03; I citations and REF-01/02 |
| OM-024 | Preserve both original IDs and history for the full m+1 merge-source range and lower-survivor ordering repair. | C16-E02/E04; IIIA-06/08 |
| OM-025 | Retain exact reduced-variable count; never assign m coordinates to the full system. | C16-E03/E06; C16-I-FULL, IV-B |
| OM-026 | Retain private operation fixtures with 0<β<1 and exact printed coordinates; no stable public aliases. | C16-E02/E04; EX02–05/EQ11–15 |
| OM-027 | Retain private example ownership: extended reduction plus exhaustive three-input partitions/incidence. | C16-E02/E03/E04/E07; X-MATRIX-11, EX06/07 |
| OM-028 | Retain existing extended-only/documentation exclusion and complete original rationale. No proof or new scope is claimed; recheck only if the lead changes manuscript scope. | C16-E01 register check; E03 designated-v16/ISIT boundary assessment |
| OM-029 | Retain existing extended-only/documentation exclusion and complete original rationale. No proof or new scope is claimed; recheck only if the lead changes manuscript scope. | C16-E01 register check; E03 designated-v16/ISIT boundary assessment |
| OM-030 | Retain existing extended-only/documentation exclusion and complete original rationale. No proof or new scope is claimed; recheck only if the lead changes manuscript scope. | C16-E01 register check; E03 designated-v16/ISIT boundary assessment |
| OM-031 | Retain existing extended-only/documentation exclusion and complete original rationale. No proof or new scope is claimed; recheck only if the lead changes manuscript scope. | C16-E01 register check; E03 designated-v16/ISIT boundary assessment |
| OM-032 | Retain existing extended-only/documentation exclusion and complete original rationale. No proof or new scope is claimed; recheck only if the lead changes manuscript scope. | C16-E01 register check; E03 designated-v16/ISIT boundary assessment |
| OM-033 | Retain direct Example1 proof coverage without a separate public extended-Lemma7 name. | C16-E01/E04; K08, X-SEM05 |
| OM-034 | Retain existing extended-only/documentation exclusion and complete original rationale. No proof or new scope is claimed; recheck only if the lead changes manuscript scope. | C16-E01 register check; E03 designated-v16/ISIT boundary assessment |
| OM-035 | Retain pinned Real entropy in nats; external logarithmic bound units are not adopted. | C16-E01; K01/K02, EQ04 |
| OM-036 | Retain intuition and generic nonuniqueness prose disposition; exact local contracts are separate. | C16-E01; abstract/I |
| OM-037 | Retain adjectives as prose; underlying canonical and operation facts have checked proofs. | C16-E01/E02/E04; IIA-07 and III-A |
| OM-038 | Retain nonempty selected-support children; no data for zero columns or arbitrary mask normalization. | C16-E02/E04; IIIA-07 |
| OM-039 | Retain exclusion of a generic LP/convex-analysis library; specialized existing dual separation suffices. | C16-E03/E06; X12, COR01 |
| OM-040 | Retain direct counterexample and later reachability consumers without duplicate public proof machinery. | C16-E01/E02/E04; EX01, THM01 |
| OM-041 | Retain both refined external redundancy rates, separate from the general normalized product consequence. | C16-E01; I-16/17 |
| OM-042 | Retain all listed proof-intermediate logical-content duties, without a public name for each display. | C16-E01–E04; complete numbered ledger and extended inventory |
| OM-043 | Retain structural normalization proof; no claim of arbitrary expanding-rewrite termination, uniqueness or confluence. | C16-E02/E04; LEM04 |
| OM-044 | Retain active finite channel/data representations and exact nonemptiness boundaries. | C16-E01–E04; K07, matrix hypotheses, C16-I-LP |
| OM-045 | Retain support restriction, exact inclusion/recovery and null-fiber conventions. | C16-E01–E04; K06/K07 and Appendix/Compression rows |
| OM-046 | Retain explicit finite attainment and attained LP extrema; no general optimizer theorem. | C16-E01/E03/E04/E06; LEM03, THM02/COR01 |
| OM-047 | Retain full zero-padding/reduced admissible equality repair and nonnegativity; no mixed-system or LP-objective equivalence asserted. | C16-E03/E04; C16-I-FULL, EQ16/18/19 |
| OM-048 | Retain fixed-pair decoding and whole-vector witnesses; marginal-only contract is insufficient. | C16-E01/E02/E04; DEF01, LEM05 and Appendix |
| OM-049 | Retain approved value-one VPS domain; no strict-domain simulation branch is started. | C16-E02/E04; IIIA-07 |
| OM-050 | Retain private operation fixtures with 0<β<1 and exact printed coordinates; no stable public aliases. | C16-E02/E04; EX02–05/EQ11–15 |
| OM-051 | Retain witnessed inverse ratio/mask data and directed output equivalences. | C16-E02/E04; LEM06/THM01 and X-MATRIX-09 |
| OM-052 | Retain actual finite binary operation paths, exact endpoints and positive/nonempty labels. | C16-E02/E03/E04; Appendix and IV-A-04–07 |
| OM-053 | Retain finite-value information/finite existential auxiliary contract and unrestricted structural source. | C16-E01/E04; K01/K03/K05/K11 |
| OM-054 | Retain one common vector law for every new prior and exact pair-law transport. | C16-E01/E04; K06, REM01 |
| OM-055 | Retain supported/all-row distinction, full-support converses and arbitrary null posterior. | C16-E01/E04; K04/K06, DEF02 |
| OM-056 | Retain active union of channel-row supports; pair support agrees only with full input support. | C16-E01/E04; K07, LEM02 |
| OM-057 | Retain translated direct two-branch contradiction, full-support negative and degenerate-prior guards. | C16-E01/E04; K08, EX01 |
| OM-058 | Retain private binary witnesses and public seed consumer; no external general theorem family is added. | C16-E01/E02/E04; K07, IIIB-01 |
| OM-059 | Retain finite half-L1/overlap boundary; no metric hierarchy or infinite-alphabet claim. | C16-E01/E04; K09, EQ09 |
| OM-060 | Retain actual normalized maximal coupling and attaining mismatch witness. | C16-E01/E04; K09, X-SEM06 |
| OM-061 | Retain residual/shared/exclusive constructions with zero-overlap and null-component cases. | C16-E01/E04; K09/K10 |
| OM-062 | Retain C03/C04/C05 proof ownership split across the exact Appendix A anchors. | C16-E01/E04; X-SEM03–09 |
| OM-063 | Retain all-prior inequality/forward equality and explicitly full-support equality converse. | C16-E01/E04; K12, LEM03 |
| OM-064 | Retain universal finite-auxiliary bound and actual attaining enlarged law; no original-source or infinite-auxiliary optimizer claim. | C16-E01/E04; K11, LEM03 |
| OM-065 | Retain positive-fiber entropy plus weighted-zero treatment for null fibers. | C16-E01/E04; K10, X-SEM08 |
| OM-066 | Retain shared/exclusive active partition and total posterior with both-zero outputs. | C16-E01/E04; K10, X-SEM07 |
| OM-067 | Retain binary scalar/proof/label transport content and existing adjoining-scope exclusions. | C16-E01/E04; K10–K12, X-SEM07–09 |
| OM-068 | Retain support-finset/division bridge, compression/Real recovery and dependent membership transport; declined optional alias remains for concrete-consumer revisit in S03. | C16-E02/E03/E04; DEF04, IV-04–06, X10 |
| OM-069 | Retain the actual Example1 first-column value/pattern fixture in its C06 owner. | C16-E02/E04; IIIA-03 |
| OM-070 | Preserve both original IDs and history for the full m+1 merge-source range and lower-survivor ordering repair. | C16-E02/E04; IIIA-06/08 |
| OM-071 | Retain exact ordered PPM result and explicit output transposition for extended (29)–(30). | C16-E04/E07; X-MATRIX-11 |

The authoritative Future Work Notes register still contains no numbered notes.
No new unmapped suggestion arose. C16 planning advice keeps its recorded owners:
S02/S05 inventory controls, S03/S05 import checks and affected-evidence refresh,
S04 Quick Start shortening and disposition reconciliation. The no-wrapper
recommendation remains for S03's concrete-consumer assessment; no wrapper is
implemented by this source audit. No omnibus status system or duplicate API table
was needed to make the individual coverage modes explicit.

## S05 source-locator correction — 2026-10-03

Fresh inspection of the same version-16 binary corrects C16-X-MATRIX-07 from
“p.15” to “pp.15–16”: (184)–(192) are on p.15; (193)–(195) continue at the top
left of p.16. The original S01 locator and reviewed before-image are preserved
in S05 evidence. The PPM claim, proof owner, assumptions and coverage disposition
are unchanged. S01's original checkpoint above remains historical; the
[S05 cumulative assessment](pfr-c16-readiness-audit.md#c16-s05-readiness) owns
the fresh validation and current closure checkpoint.
