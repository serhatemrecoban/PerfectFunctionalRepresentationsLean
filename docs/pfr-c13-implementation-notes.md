# PFR-C13 implementation notes

## S01 — intrinsic partitions and incidence coordinates, 2026-09-30

**Checkpoint:** implementation, contextual self-review and independent step
review are complete; the original report is critically reconciled. Final
applicability/F capture and durable closure follow this pre-F record. Only the
supported execution closure establishes S01 completion. Only S01 is authorized by the lead's
“good, do step 1 with its review process.” S02-S06 remain unstarted. The
[approved revision-2 plan](plans/pfr-c13-exact-partitions-incidence-systems.md)
retains all six steps, eighteen criteria and fourteen regressions.

### Scope and source crosswalk

The new separately importable production module is
[`Optimization/Incidence.lean`](../PerfectFunctionalRepresentations/Optimization/Incidence.lean).
Its namespace is `PerfectFunctionalRepresentations.Incidence`; its 31 public
declarations cover the following boundary.

| Criterion | Implemented contract and consumer |
| --- | --- |
| S01-A | `NonzeroPattern`, `ExactPartition`, `OccurringPattern`, `IsAdmissible`, `AdmissiblePartition`; finite full/reduced matrices and input incidence; zero-padded full values; entry equations and restrictions. `exactPartition_indicator_sum` and `exists_exactPartition_of_indicator_sum` preserve the supplied pattern-to-block bijection through C10's adapter. |
| S01-B | `card_nonzeroPattern` gives `2^card α - 1`; `card_occurringPattern`, `patterns_card_le` and `card_admissiblePartition_le` give full/reduced dimensions. |
| S01-C | Arbitrary supplied row/column equivalences use their inverses in coordinates. `reindex_mulVec` transports arbitrary real vectors; `system_reindex_iff` also transports nonnegativity. Generic full/reduced and input-matrix consumers, singleton data and a genuine empty admissible family are maintained tests. |

The paper boundary is ISIT p.4, IV opening's pattern bound, IV-A's partition
definition and the index/entry content of (16)-(17). Extended v16 pp.5-6,
(33)-(51)/(56), clarify full/occurring patterns, full/admissible partitions and
reduced matrix entries.
Both exact manuscript hashes in plan Section 2 were freshly rechecked and match.
No other extended-only result is added.

The core data assumptions remain C12's `[Fintype α] [Nonempty α]` and a
`CompressedPatternData α`. No perfectness, feasibility or nonempty admissible
family is assumed. Pure pattern/partition lemmas need only finite input.
Classical decidability remains local. `Finpartition` supplies the full finite
partition index; general Bell enumeration stays excluded under OM-017.
The lightweight root, dependency pins and earlier maintained Lean modules are
unchanged. There is no new generic information-theory construction.

### Regression boundary

[`Tests/Optimization/Incidence.lean`](../PerfectFunctionalRepresentations/Tests/Optimization/Incidence.lean)
checks R01 and the S01 portions of R02-R04/R11. The singleton fixture treats
arbitrary valid data on `Unit`: one pattern, one partition, value one and unit
matrix entries. The empty-family fixture directly constructs the three pair
patterns on `Fin 3`, each of value `1/2`, proves row normalization and proves
there is no admissible exact partition. Its enumeration has exactly `Fin 0`
columns. The full index still contains the absent whole-input pattern, whose
value is zero and whose full incidence entry at the indiscrete partition is one.
The C03 channel-extraction bridge remains S02/S05 R05; this fixture does not
claim to discharge it. A non-involutive three-cycle with asymmetric entries
checks inverse direction, and a signed vector checks unrestricted transport.

No `P v`/`P H` theorem, feasible-vector restriction/extension, coefficient
normalization, necessity/synthesis/perfectness equivalence or optimization theorem
is implemented here. Those remain the explicit later-step owners. OM-019 and
OM-025 now record S01's actual finite bounds/coordinates; no omission ID or
numbered Future Work Note is added. C12's optional compression-idempotence alias
still has no S01 consumer and retains its S04/S05 integration trigger.

### Validation and implementation evidence

The execution baseline B is
`c6199827df06f7b136a185aecb1169513c3a3812f2263a22ba381ffdea690aa0`.
The inherited dirty checkout was preserved; C12 durable closure and exact
prerequisite source applicability were verified before S01 acceptance.
Commands and disposable evidence are under ignored `tmp/c13-s01/`.

- Parent initial focused build: production/test incidence plus C10 partition and
  C12 compression test modules, exit 0, 2,780 jobs (`initial-focused-build.log`).
- Parent default `lake build`: exit 0, 2,762 jobs (`default-build.log`).
- After the self-review refinement, parent focused/default builds again pass
  (2,780/2,762 jobs; `refined-focused-build.log`, `refined-default-build.log`),
  including the signed-vector consumer; no diagnostics.
  The default root remains light, so the focused build is separately required.
- Initial factual helper audit: all 30 then-public signatures and axiom lists,
  exit 0; only `propext`, `Classical.choice`, `Quot.sound`. Parent inspected the
  complete manifest and log. Refined helper audit `lake env lean
  tmp/c13-s01/api/PublicAudit.refined.lean` passes with 31 signatures, 31 axiom
  reports and no diagnostics; only the same standard axioms occur. Source
  `d7512897e63f99eaf5e7670eed989dbb2a0850c7556700f4f4c6d41e31c1ed8e`
  and the refreshed imported `.olean` stayed unchanged during the audit.
  Parent inspected the result, full declaration list and unrestricted transport
  signature. Original audit evidence remains preserved.
- Factual helpers verified a C10 adapter/indicator probe and supplied disposable
  singleton/empty-family consumers; parent integrated, inspected and built the
  maintained tests. These are helper checks, not independent review.
- The required maintained-source placeholder scan returned no matches.

The explicit review source inventory includes six pinned mathlib files and
is not a claim of universal dependency closure. Two further inspected helpers,
`Finset.card_eq_one_iff_existsUnique` and `Finset.sum_boole`, have exact auxiliary
source hashes in `api/PublicAudit.dependencies.json`; both are in the unchanged
pinned mathlib checkout. Imports reuse the C10 adapter and C12 data plus focused
mathlib finite-set, partition and matrix APIs.

Failed attempts are preserved. Initial consumers collided with C12's older
unqualified `OccurringPattern`; putting consumers in the new `Incidence`
namespace fixed resolution. Broad simplification of the three-cycle exceeded
recursion depth; explicit coordinate equations fixed it without changing limits.
The empty fixture's indiscrete partition needed explicit `univ_nonempty.ne_empty`.
Two unused-instance warnings and one spacing warning were fixed. The first
scratch audit used unsupported `pp.width`; its corrected run passed. Each
failure is limited to its original source and does not count as passing evidence.

### Contextual self-review and separate reassessment

Original optional finding `pfr-finding:c13-s01-self-001` recommended exposing the
already-proved unrestricted matrix-vector identity directly, with a signed
consumer. The separate decision pass adopted it: one `reindex_mulVec` theorem
now serves both systems and input incidence, and `system_reindex_iff` reuses it.
This preserves the approved contract and avoids multiple specialized aliases.
No material correctness or acceptance gap was identified by the self-review.

The first recording attempt had extra fields beyond the six-field finding
schema and was refused; the premature reassessment was then refused because
initial validation was still the active phase. The corrected record preserves
the original mathematical critique and successfully records the required
self-review followed by reassessment. No journal or workflow code was edited.

### Independent review, reconciliation and finalization

The existing reviewer `/root/pfr_c13_reviewer` independently satisfies all three
S01 criteria with no material or optional findings. Requested settings remain
Astra/ultra/no-parent-history; effective settings are unknown. It authenticated
the neutral request and all 149 concrete inventory entries, read the actual
source and exact ISIT p.4/extended pp.5-6 anchors, and freshly ran focused/default
builds (2,780/2,762 jobs), direct compilation of both touched files, additional
consumers and its own 31-public signature/axiom audit. All passed. The additional
probe verifies exact block membership equivalence, empty-column system transport,
full input-incidence coordinates and the pure pattern count at empty input.
Only the pure combinatorial boundary admits empty input; C12 data still require
nonempty input.

The first complete original report is preserved under capture
`491f57a60c7a44809c324b9fd4e8fad1d76d3ebf92cd440e7e2dbdf72774656f`.
Its admission failed because `inspected_source` and `limitations` were lists,
where the installed recorder requires text. The supported failed-review retry
kept the same source, criteria and reviewer. The reviewer independently confirmed
all 149 hashes again and reissued the full report with those fields serialized
as strings. The accepted original is
`24a544e27a60ed9e9b8ebfc39a2ba30bfcac81ef6d202051f61fa39a98b899ec`,
against R2
`aa0f6419dcfc802e8f68ae85d47e114669bf99ef8f0dae866f64df8647a6f707`.
R1 `21ed27a1bcd43b58b8d43ae8bf79ecc26092b9057b60fd520a14ced582720d24`
has the identical inventory. Both native empty submission returns remain
recorded as uncertain; subsequent complete original reports separately confirmed
delivery. No report was rewritten by the parent and no workflow code changed.

The parent critically reconciled both reports' mathematical content and the
accepted report through the supported reconciliation operation. The assessment
agrees with the actual subtype/Finpartition definitions, exact indicator-family
bijection, cardinality proofs and inverse reindexing. The parent read the
reviewer's independent probe and verified that its empty-column hypothesis is
provided by the maintained concrete fixture. No new theorem or regression is
required by the report. The resolved self-review suggestion remains the only
finding in the step ledger.

Limits remain explicit. The reviewer did not reconstruct the derived environment
digest or inspect private B records; the parent separately verified the full
150-entry R inventory and preservation of all 46 earlier maintained Lean files.
Hash coverage does not claim every file was semantically reviewed. The public
31-declaration audit does not replace S06's cumulative audit of internal machinery.
The direct pair-only fixture does not replace the later C03 extraction regression.
The reviewer's initial broad filename search listed unrelated Desktop paths,
but those files were not opened or used. These limits do not leave an S01
criterion gap. No plan review or later-step mathematics is certified here.

Final document edits record this reconciliation and the pre-F checkpoint only.
The Lean source, tests, imports, dependency pins and approved normative contract
remain byte-identical to the reviewed state, so the passing builds and audits
remain applicable. Final source/hygiene checks and current evidence precede F
and the supported durable closure. The durable execution record owns the final
F/closure references, avoiding a self-referential edit after F. S02 does not
start automatically. No commit or push was made.


## S02 — structural identities and nonnegative feasibility, 2026-09-30

**Checkpoint:** implementation, validation, contextual self-review, separate
reassessment and independent S02 review pass. The complete original report is
critically reconciled. Final applicability/F and durable closure follow this
pre-F record; only the supported execution closure establishes S02 completion.
Only S02 is authorized; S03-S06 remain unstarted.

### Startup and scope

The conditional request was accepted only after confirming S01 closure
`736ebae3a8d948a5835d0b80f145d319b02aa01b4a22abc7e1ba66455f7fd2de`,
its accepted original report/reconciliation and exact agreement of all 150 final
source/environment entries. Its F is
`484126e41254bdbe5de39db70dd1ab67c601f91f03bdec0466c59a1098754f69`.
The preceding S01 pre-F wording is historical. S02 B is
`c674b2a61b9d75fba49b4ae27d2af115fbbefe0e0fec38b6aef9dce74f005981`.
The existing persistent reviewer is retained. Neither a new plan review nor
later-step implementation is implied.

| Criterion | Production contract |
| --- | --- |
| C13-S02-A | `inputMatrix_mulVec_value`, `fullInputMatrix_mulVec_fullValue`, `inputMatrix_mul_reducedMatrix`, `fullInputMatrix_mul_fullMatrix` state the four vector/rectangular all-ones identities without feasibility. |
| C13-S02-B | `FullFeasible`/`Feasible` require nonnegative equality. `restrictWeights`/`extendWeights` preserve feasibility; full feasible inadmissible coefficients vanish. Restrict-after-extend is unconditional, while extend-after-restrict requires full feasibility. `exists_fullFeasible_iff` packages existence. |
| C13-S02-C | Equality alone yields total mass one. Nonnegative solutions satisfy sharp incidence/value bounds and unit bounds, with equivalent unit-interval formulations. `PositivePartition`, its normalized sum and nonemptiness, `positive_incidence_sum`, and `positiveBlockPattern_surjective` expose positive-support coverage. Empty admissible indices admit no equality solution, even signed. |

The data assumptions remain `[Fintype α] [Nonempty α]` and arbitrary valid
C12 compressed data. No nonempty admissible-family or perfectness premise was
introduced. The full partition/input identity remains purely finite and even
allows empty input. No signed or inequality full/reduced equivalence is asserted.
The production imports remain those of S01; the one sum-restriction helper is
private. No separate probability or information-theory result is recreated.

The source anchors are ISIT p.4, IV-A (16)-(17) and its feasibility/bounds
paragraph, with extended v16 pp.5-6 (33)-(56) supplying the full/reduced repair,
structural identities and nonnegative coefficient argument. The exact binaries
remain identified by the hashes in approved plan Section 2.

### Regression design and proof-route decisions

The generic maintained consumers exercise the public predicates, arbitrary
finite presentations, both inverse laws and positive support. Singleton data
use coefficient one; the existing concrete empty-family fixture proves both
reduced and full infeasibility and checks a `Fin 0` column presentation.
An actual C10 `multiPpsOfNonnegative` consumer derives NNReal weights and their
normalization from the supplied real coefficients, transports their positive
labels, and checks the coordinate equation for the same returned endpoint.
This is the planned early interface check, not S04's three-phase synthesis.

The separate maintained `Tests/Examples/Incidence.lean` checks R05-R08/R13-R14.
R05 starts from the public C03 channel and C12 extraction; the S01 direct datum
is not substituted for that bridge. Sparse sums of point-supported partition
weights check arbitrary full rows without proving the general five-partition
enumeration, which remains S05. R13 classifies just its two admissible partitions.

R14 uses a shorter local obstruction: a pair row forces the corresponding split
partition coefficient to `3/8`, whereas its singleton block has value `1/8` and
bounds that coefficient above by `1/8`. The explicit signed vector still checks
the negative all-singleton coefficient `-1/4`. This establishes the approved
nonnegative obstruction and signed control without proving uniqueness of every
signed solution at S02. The full paper-order classification remains S05.
This is a proof-route improvement within the approved outcomes, not a new
assumption, abandoned regression or changed mathematical contract.

Mapped omissions OM-025/OM-047 retain their original rationale. CC02-CC04's
proofs are implemented; validation and independent assessment are recorded below.
R09/R12, necessity, actual three-phase construction and cumulative enumeration
retain S03-S06 owners. The C12 idempotence alias still has no actual consumer;
its existing C13 integration trigger remains. No new numbered Future Work Note
or unowned optional deferral is opened.

### Validation and evidence limits

The final six-target build passed (2,783 jobs): production incidence, both new
incidence test modules, C10 synthesis consumers, C12 pattern-compression tests
and the C03 example tests. `lake build` passed (2,762 jobs). Its root/dependency
closure is unchanged by the subsequent docstring-only correction. The refreshed
focused build and 60-public-declaration `#check`/`#print axioms` audit then passed
against stable final Lean source. S02 adds 29 public declarations: 23 theorems,
five definitions and one alias. Only `propext`, `Classical.choice` and
`Quot.sound` occur in the audit. All named concrete fixture machinery is private.

The maintained-source placeholder scan returns no matches. An initial scan
matched the English word “admit” in a theorem docstring; that wording was changed
to “have no,” followed by the refreshed build, exact-source audit and clean scan.
This was a strict textual false positive, not a proof placeholder. Two earlier
production style warnings were corrected. Failed discovery/proof attempts remain
preserved, including unavailable guessed sum names, finite-coordinate
simplification repairs and one scratch import failure during production rebuild.

Logs and hashes are in ignored `tmp/c13-s02/`, including `validation.json`, the
focused/default logs, final public audit and the concrete/helper evidence.
The first helper public audit used a stable built interface while source comments
changed; it is explicitly limited, and the later exact-source parent audit
supersedes that applicability gap. Factual helper checks are implementation
evidence, not independent review. Fresh helper manuscript hashes match both
approved binaries; its source rereading uses their authenticated local extracts.

The exact B/current audit confirms only the eleven intended source/document paths
changed, with 48 other maintained Lean files unchanged and 151 inventory entries.
The entire earlier project-log prefix and approved normative plan are preserved.
Production imports, lightweight root, pins and tools are unchanged. The explicit
review dependency inventory plus auxiliary finite-order-sum hashes is a bounded
inspection, not a universal import-closure claim. `git diff --check` passes; local
references, scratch and durable review records remain ignored. No commit or push.

### Contextual self-review and separate reassessment

The parent reviewed the integrated work without editing: four correctly typed
structural identities, equality-only normalization, the exact nonnegative inverse
domain, positive-support coverage and its C10 consumer, concrete acceptance
controls, public hypotheses/imports and private helper ownership. No material
or worthwhile optional finding was identified. A separate decision pass confirmed
that no correction or stronger assumption was warranted; R14's local obstruction
preserves S02's required outcome. No later-step work or new deferral was introduced.

The source-bound initial validation, original no-findings critique and separate
reassessment are preserved in the execution record. The neutral independent
request follows canonical validation-status updates. The following independent-review record supersedes that pending checkpoint.


### Independent review, reconciliation and finalization

The same bound reviewer independently satisfies all three S02 criteria without
material or optional findings. Its complete original report is accepted as
a4e0d797847e8281b7e2510aa6f17975c24f95f0eff5679d20ce0e9624854448
against R
50150d5b0eb884f6889781d15bba478ac21eceba1104c69335288e93ee468df6.
All ten evidence entries, the original native envelope and identical Temp copy
are retained. The empty native submission return was recorded as uncertain;
the subsequent original report separately confirmed delivery. No report
rewriting, format retry, reviewer replacement or workflow change was needed.

The reviewer rechecked all 150 concrete inventory hashes and exact manuscript
identities; its focused/default builds passed (2,782/2,762 jobs). Direct Lean
compilation of the owner and both incidence test modules passed without
diagnostics. Its fresh 60-public signature/axiom audit found only standard
axioms. Additional compiling consumers build an equivalence of the actual
feasible-vector subtypes, derive absent-block zero weights, obtain positive
block coverage and normalize NNReal positive coefficients. An initial
reviewer-written NNReal annotation error was corrected in external scratch;
that failed attempt remains explicitly reported.

The parent read the full original report and independently reassessed its
claims against the integrated source. The structural types and hypotheses
match the contract; inverse transport retains the supplied vector and the
nonnegative domain; R07/R08 prevent stronger false interpretations. The parent
also inspected the reviewer's feasible-subtype and positive-NNReal probe.
The R14 local coefficient contradiction, exact signed witness, R13 actual
transport and C10 same-result consumer establish the staged requirements.
No new theorem, public convenience equivalence or extra test is needed.

Limits remain explicit. The reviewer did not reconstruct the derived
environment digest or inspect private B records; the parent separately verified
all 151 reviewed entries and the bounded B-to-R change. Hash coverage is not a
universal semantic audit. The public-declaration audit does not replace S06's
private/anonymous cumulative audit. S05 retains exhaustive five-partition
classification; S03/S04 retain necessity and complete construction. Requested
reviewer settings remain distinguished from unknown effective settings.

Only final canonical documentation changes follow R, including the planning
notes' stale S01 pointer. All Lean sources, imports, dependency pins, tools and
normative plan remain exactly reviewed, so the successful builds and audits
remain applicable. Final source/hygiene checks, current criterion assessments,
F capture and supported durable closure follow these edits. The durable record
owns F/closure references, avoiding an edit after F. S03 does not start
automatically. No new deferral, commit or push.


## S03 — extracting weights from public perfectness, 2026-09-30

**Checkpoint:** S03 implementation, validation, contextual review, separate
reassessment and independent review pass. The original report is reconciled.
Final applicability/F and durable closure follow this pre-F checkpoint.
Only S03 is authorized. S04-S06 remain unstarted.

### Startup and scope

S02 durable closure
`a5836b8ed06f47eeddad842d516f2ef11bce08c7ed4e9706c8a3abcc0fc966ac`
and F `c5609e81ccf84b5937309472b417c5d4d1d2b827660a5f43c70133d7dc0f0c11`
were verified before selection. All three satisfied criteria, original-report
reconciliation and exact agreement of all 151 final source/environment entries
were checked. The earlier pre-F prose remains historical. S03 B is
`94f77284ac5e4c0e1fffc96ae733f79cfd0e06653be5d98a571f43149c28607b`.
The existing reviewer and approved normative contract are retained.

The parent rechecked the exact ISIT and extended-v16 SHA-256 hashes and reread
the authenticated local extracts at ISIT p.4 IV-A and extended pp.5-7 (33)-(63).
The necessity proof will make the source's compressed weight-extraction argument
explicit through the public common-posterior witness. No prior, full-support
input law or private C11 construction is needed. S04 retains the reverse
construction and the final equivalences; C14/C15 retain optimization.

### Mathematical boundary and proof route

| Criterion | Implemented contract under validation |
| --- | --- |
| C13-S03-A | Restrict the public decoder law to its finite nonzero support. Coordinate-joint support gives channel support and posterior support. The public `coordinate_eq_of_posterior_support` proves the reverse fiber inclusion; actual nonempty fibers equal their occurring patterns. The C10 adapter and its supplied-label equivalence give an admissible exact partition. |
| C13-S03-B | Sum each supported decoder's Real mass into its partition coefficient. Nonnegativity follows termwise. Swap finite sums and use the exact partition/block membership equivalence at an input in the pattern; the resulting row is the coordinate marginal. Zero-mass decoders contribute zero when the sum is extended to the full decoder type. |
| C13-S03-C | `exists_feasible_of_isPerfectlyRepresentableChannel` extracts the reduced witness; `exists_fullFeasible_of_isPerfectlyRepresentableChannel` uses S02's existing full/reduced transport. Both accept arbitrary valid data and public perfectness, without a prior or extra feasibility assumption. |

Decoder labels are the used output subtype. The partition uses their nonempty
pattern finsets after proving the fiber equality, so it retains exact labels
through `partitionOfBlocksEquiv`. Distinct pattern labels are the input data's
actual subtypes. No posterior uniqueness on unused outputs is required.

The Real marginal uses pinned LeanInfoTheory's public `PMF.bind_toReal_apply`
and `isCanonicalCoupling_of_coordinateFactorization`. The former already
justifies finite probability-to-Real conversion with finite PMF atoms; no local
probability theory or new generic information theorem is needed. Support and
partition bookkeeping stay private. The two final necessity theorems are the
only proposed new public declarations; production imports remain unchanged.

The singleton test constructs its semantic pure decoder law directly. The
shared-block R13 fixture uses a finite selector with weights `1/3, 2/3, 0`,
mapped to two valid decoders and one null decoder. The shared singleton output's
posterior retains both positive atoms. At other outputs the posterior is the
appropriate pure decoder. This establishes public perfectness independently
of S04. The null decoder deliberately has a fiber different from its output
pattern, testing why partition extraction must restrict to supported decoders.

For the maintained exact-coefficient consumer, obtain the witness from the
public necessity theorem and use R13's isolating incidence rows to identify
its two coefficients. This checks the same returned witness and its shared
row without exposing internal partition or aggregation definitions. Generic
consumers also check S02 normalization, bounds, positive coverage and actual
inverse transport, plus the public C11/C12 boundaries. S04 still owns the
construction from arbitrary feasible weights and both directions of the final
characterizations; no such sufficiency theorem is used here.

CC05 is the S03 outcome being validated. OM-042 retains the internal proof
route and does not promise public names for every intermediate display. The
C12 idempotence alias and C11 helper-promotion suggestions retain their recorded
owners/triggers; neither is needed by these consumers. No scope change, new
numbered Future Work Note or dependency change is introduced.

### Validation and preserved iteration evidence

The complete extraction scratch proof compiled with no diagnostics. Production
integration initially omitted its section-level nonempty-input binder, which was
restored before the successful owner build. The generic test build then exposed
a singleton default-label coercion; the explicit subsingleton equality repaired
it, and the owner plus generic consumers passed (2,778 jobs).

The complete R13/R05 fixture scratch compiled with exit zero and no diagnostics
before integration. It checks the public common-posterior factorization, both
positive decoder atoms, the zero atom and invalid null-decoder fiber, the exact
coefficients of the same returned public witness, both contributions to the
shared row, full necessity and C03/C12 pair-only rejection through necessity.
Its source and fragment hashes, every failed probe and compiler output are
retained in ignored `tmp/c13-s03/fixtures/`. Helper checks are factual implementation
evidence, not independent review.

Failed extraction probes involved explicit section variables, dependent subtype
projections, Finset/Set subtype enumeration and the orientation of equalities
in pure-PMF simplification. The fixture's failed probes involved finite-label
simplification and explicit ENNReal arithmetic premises; one import was unavailable
during the production rebuild. The root singleton probe required the explicit
pure-map rewrite. These were repaired without changing the mathematical contract.
The implementation notes and original tool outputs preserve the root integration
failure; scratch logs preserve the other attempts. No failed check is counted
as passing evidence.

Production imports and the lightweight root remain unchanged. The generic tests
explicitly import the public C11 characterization module for its consumer.
The final full check run is recorded below once complete. Public signature/axiom
coverage is limited to the 62 explicit public declarations; S06 retains the
cumulative audit of every private helper and anonymous test. The four relevant
pinned dependency sources have separately recorded hashes; this is bounded
inspection, not a universal dependency-closure audit.

The initial seven-target build passes (2,785 jobs), including both incidence test
modules and C10/C11/C12/C03 consumers. The default build passes (2,762 jobs).
All 62 explicit public signatures and axiom reports pass, with only `propext`,
`Classical.choice` and `Quot.sound`. The strict placeholder scan has no matches,
and `git diff --check` passes. Source hashes were stable throughout these checks.
The fixture build reported five long-line warnings; these are recorded for the
separate contextual review and reassessment before independent submission.

### Contextual self-review and separate reassessment

The parent preserved a read-only critique of C13-S03-A/B/C, the source/manuscript
boundary and exact consumers before making corrections. No mathematical or
acceptance gap was found. Optional finding `pfr-finding:c13-s03-self-001`
identified the five build-reported long lines in the new fixture. A separate
reassessment adopted the correction because it improves readability and clears
the actual linter output; it does not change a theorem, proof route or scope.

All five lines were split, and an exact comparison confirms the fixture's
non-whitespace text is unchanged. Its targeted build is being refreshed.
The production source/olean and generic tests are unchanged, so the existing
62-public-declaration audit remains applicable. The original critique and
separate decision are retained in the private execution record. No other
optional API, test or plan change was needed; existing later-step owners remain.

The refreshed fixture build passes (2,778 jobs) without diagnostics. Default
build, strict placeholder scan and diff checks pass again. Exact production
source/olean identity preserves the 62-public-declaration audit; generic tests
are also unchanged. `tmp/c13-s03/validation.json` links the initial checks and
this bounded refresh. The earlier warning-bearing result remains preserved.
All S03 mathematics and required consumers are now validated for the neutral
independent review. The contextual finding will be disposed using current-source
evidence before dispatch; no later step begins.


### Independent review, critical reconciliation and finalization

The same bound reviewer independently satisfies C13-S03-A/B/C without material
or optional findings. The complete original report is accepted as
e082f99169cf32f87d5b23f18379140d3a1c2cbde44542041a709d8c5947cd37
against R `d809dc4c20a783357da99bbf96b65f9ea4cbbbf9a1abfffb68f9f610183df891`.
Its exact native payload and identical reviewer-saved UTF-8 copy, SHA-256
`a540a160db9f38f6cc11b1f24bd748f5df0f80a94990bd5756bfe1b1764982db`,
are preserved with all nine evidence records. The empty native submission return
was recorded as uncertain and the full report separately confirmed delivery.
No report rewriting, formatting retry or reviewer replacement was needed.

The reviewer verified all 150 concrete source hashes before and after its work,
plus both exact manuscript hashes and pinned dependency states. Its focused/default
builds pass (2,782/2,762 jobs). Direct Lean compilation of the owner and both
incidence tests passes without diagnostics. An external copy of the unchanged
owner checks all 62 public declarations and all 15 S03 private signatures/axioms,
with only standard Lean axioms. Additional independent consumers prove supported
decoder recovery from its partition, normalization of the actual aggregated
weights, empty-admissible-family nonperfectness and full-vector normalization
and recovery. These are checks, not proposals for more public API.

The parent read the complete original report and its independent probe, and
critically compared them with the actual source. The support argument retains
its necessary premise; the null-decoder regression demonstrates that premise
cannot simply be dropped. The actual partition adapter preserves used-output
labels. Each incidence row is derived from the supported coordinate marginal,
with finite Real conversion supplied by the pinned public PMF API. R13's explicit
q,V witness precedes sufficiency, and isolating rows check both coefficients of
the same returned witness. Public hypotheses, S02 transport and C11/C12 consumers
match the approved boundary. No mathematical correction or new deferred advice
is warranted. The earlier contextual style finding is resolved by the clean
refreshed build and is retained in its original record.

Limits remain explicit. The reviewer did not reconstruct the derived environment
digest or access private B; the parent verified all 151 entries and the intended
B-to-R changes. Required quick-start/map reads incidentally exposed brief status
and contextual-review summaries. The reviewer reports not using those verdicts
as evidence and did not read dedicated self-review sections, private records or
implementation conversations. This is source-based independence, not a fully
blind assessment. Direct compilation and the fresh source-copy probes support
the conclusions independently. S06 still owns the cumulative audit of inherited
private helpers and anonymous tests. Requested settings remain separate from
unknown effective settings. The initial dependency-document filename lookup
failure is preserved in the original report; it created no unresolved API issue.

Only final canonical documentation changes follow R. Lean sources, imports,
public and private contracts, dependency pins, tools and normative plan remain
exactly reviewed, so the successful builds and audits remain applicable. Final
source/hygiene checks, refreshed finding disposition and criterion assessments,
F capture and supported durable closure follow these edits. The private durable
record owns the final F/closure references, avoiding an edit after F. Only that
closure completes S03. S04-S06 and C14/C15 remain unstarted; no commit or push.


## S04 — coefficient-specific construction and characterization, 2026-09-30

**Checkpoint:** S03 is durably complete. S04 validation and independent review pass; all three criteria are satisfied, and the original report is reconciled. Final applicability/F and durable closure follow this pre-F checkpoint.
Only S04 is authorized; S05-S06 remain unstarted.

### Startup, source and organization

The conditional S04 request was accepted after verifying S03 closure
`59f44d95ae55f5078ed2e8482a7bb65af12f809e885573ffcc669cd141c002cf`,
its three satisfied criteria and complete original-report reconciliation. All
151 entries of S03 final source F
`260e10fda68701a0b70542c5a28678d526a05a7561d35e7fcf6e1273fe92751c`
match the actual startup source, including the derived environment. S04 B is
`20c9eb17b4f819ebdc549938ad983a9e2e142cf760cb0aa77aba028e5b607f6d`.
The earlier pre-F statements are historical; they do not block S04.

The plan permits a focused `Optimization/IncidenceConstruction.lean` sibling.
It imports the existing incidence owner and the public C11 characterization
where used; the incidence owner and lightweight root need no added dependency.
A dependent `PartitionConstruction D w` bundle is justified by the required
public consumer: its three labelled operation results retain the same PPS,
VPS and PPM endpoints, exact coordinates and supplied coefficient vector.
The normal form packages those same paths and the directed comparison to
any supplied C12 enumeration, while the bundle retains the phase specifications.

The exact ISIT and extended-version hashes still match the approved plan.
The parent reread ISIT p.4 IV-A's three stages and the relevant extended p.6-p.7
construction/equality passages in the authenticated planning extracts. The
full/reduced repair, removal of zero coefficients, row-derived normalization
and prior-free hypotheses remain unchanged. Optimization, exhaustive global
three-input partition classification and cumulative closeout retain their
existing later owners. No C12 idempotence alias is currently needed.


### Implemented contract and same-construction consumers

| Criterion | Actual implementation |
| --- | --- |
| C13-S04-A | `partitionConstruction D w hw` uses precisely `PositivePartition D w`. Its `PartitionConstruction` bundle retains three dependent `LabelledOperationResult`s with the same actual endpoints, complete semantic labels and coordinates for the supplied `w`. Public pattern accessors specify PPS `univ`, each VPS block and each final occurring pattern. |
| C13-S04-B | `Finpartition.copy` transports each partition to the actual PPS column carrier. An explicit `Equiv.sigmaCongrLeft` identifies actual VPS labels with `PositiveBlock D w`. The PPM map is `positiveBlockPattern` after the returned VPS inverse labels; S02 proves surjectivity. Equal target patterns give equal column supports. Reindexing the finite sum through those labels, summing each partition's unique matching block, and using the positive incidence equality identifies every PPM mass with `D.channel`. |
| C13-S04-C | The retained normal form proves perfectness through C10's easy implication. S03 necessity and S02 inverse transport supply both feasibility equivalences; existential construction, both public C11 reachability predicates on each supplied presentation, and both finite ambient singular-channel wrappers follow. |

The production sibling imports only `Optimization.Incidence` and public
`Matrix.CanonicalReachability`. The incidence owner and lightweight root stay
unchanged. There are 18 explicitly named new public declarations and 19 private
helpers. The bundle is justified by the public consumer's need to recover all
specifications from one returned object. The function `partitionConstruction D w hw`
requires the exact supplied feasible vector; `PartitionConstruction.mk` accepts
the three labelled phase witnesses. The construction-existence equivalence quantifies over
vectors; the bundle's positive labels alone are not a pointwise converse for
arbitrary signed coefficients outside that support.

The generic maintained consumer obtains one returned construction for its supplied
`w`, then recovers all three complete label equivalences, exact coordinate and
pattern equations, identical normal-form endpoints and the final PMF-map equation.
The directed final equivalence is `C.ppm.labels.symm.trans e`. Changing `e` to `f`
composes on the right with `e.symm.trans f`, while the actual paths are retained.
Another consumer starts from coefficients in independently supplied matrix row
and partition enumerations and constructs the vector transported back through
the supplied partition enumeration. Full feasibility and both reachability
predicates are consumed together.

The explicit ambient injection into `Option` has an unused `none` output of mass
zero. The new ambient feasibility wrapper applies to it, and existing C12
injective-data transport plus `D.extraction_roundTrip` recovers exactly `D`.
This exercises the deferred C12 idempotence-alias question: the existing API is
sufficient for the actual S04 consumer. Any new S05 pressure retains its existing
owner/trigger; no new alias, deferral or numbered Future Work Note is introduced.

### Required fixture evidence

- R02: the same singleton construction has one output in each endpoint and
  zero-length PPS, VPS and PPM paths. A small private test-only homogeneous-VPS
  count proof derives the middle no-op from its endpoint counts; no generic
  public length API was added solely for this test.
- R09: all seven patterns have value `1/4`; the supplied sparse full vector is
  `(1/4,1/4,1/4,1/4,0)`. Exactly four positive coefficients produce four PPS
  columns and seven VPS leaves. Every VPS leaf has value `1/4` on its supplied
  block and zero elsewhere. All seven final patterns remain positive; the
  zero-weight all-singleton partition has no positive label. PPM has length zero.
- R13: the actual endpoints have 2 PPS columns, 5 VPS leaves and 4 final patterns.
  Two distinct retained VPS labels for `{2}` have masses `2/3` and `1/3`, and
  their sum equals the same construction's final mass `1` on that block and
  zero outside it. The actual PPM path length is one by the existing C10 law.
- R11: a concrete four-cycle maps output index `0` forward to `3` and backward
  to `1`; the retained construction's final comparison and target coordinate
  use the forward direction.
- R14: all patterns occur and the admissible family is nonempty, but the new
  perfectness/feasibility iff and S02 extension contradict the existing
  nonnegative full-system obstruction. This proves nonperfectness without
  confusing nonempty admissible partitions with feasibility.

Only the positive supports of the supplied fixtures were enumerated. The full
five-partition classification and complete paper-matrix integration remain S05.
C14/C15 optimization and S06 cumulative closeout remain outside this step.

### Validation and implementation history

Required focused build includes both production owners, both incidence test
modules, C10 synthesis, C11 characterization, C12 compression and the public
nonrepresentable example. Default `lake build`, the strict placeholder scan and
`git diff --check` pass. Exact commands/logs and before/after Lean hashes are
retained under `tmp/c13-s04/validation.json`, then bound to the review record.
The owner has a fresh clean build after two long docstrings were shortened;
its proof terms and all public contracts were unchanged by that formatting fix.

The factual audit checked all 18 source-public signatures plus
`PartitionConstruction.mk`, `.pps`, `.vps` and `.ppm`; all 22 axiom reports contain
only `propext`, `Classical.choice` and `Quot.sound`. The exact owner and olean
hashes were stable through the audit. All signatures retain finite nonempty
input; `partitionConstruction` and its lengths receive the exact feasible vector;
ambient wrappers require only finite output and the stated singularity premise.
No prior, full support or assumed inhabited admissible family was introduced.
This helper audit supports the parent validation; it is not the bound reviewer's
independent step assessment. S06 retains cumulative private/anonymous coverage.

Negative evidence remains preserved. The first construction probe needed an
explicit retained `hw` argument, the dependent sigma equivalence needed its
family supplied explicitly, and equal PPM sums with different decidability
instances needed a pointwise conditional proof. The initial length rewrite
attempt changed a dependent endpoint; rewriting only the numerical right side
resolved it. Root discovery rejected a nonexistent generic labelled-pattern
accessor; the actual public pattern proofs now use coordinates and support.
The first change-enumeration consumer needed explicit equivalence composition;
the first inactive-output consumer supplied an injectivity theorem without its
type argument. Fixture iterations fixed explicit private-definition unfolding,
finite coordinate types and exact finite cardinal reductions. Optional audit
presentation commands unsupported by the pinned Lean version were removed;
the preserved clean rerun checks the same 22 declarations. No failed attempt
is reported as a passing complete check.

The manuscripts, dependency pins, toolchain, review tools and normative plan are
unchanged. Normalized living-summary status/coverage rows that still described
planning or S01 were reconciled with verified closures and this S04 implementation.
Original step records and historical log entries remain preserved. Contextual
review, separate reassessment, independent review and final closure follow this
implementation checkpoint; no later step is authorized by these checks.


### Contextual review and separate reassessment

The parent read the integrated source, requirements and consumers without edits
and recorded the original critique. No mathematical acceptance gap was found.
Finding `pfr-finding:c13-s04-self-001` identified ambiguous prose about the
constructor: the feasible-vector function receives `hw`, while the structure
constructor receives the phase witnesses. A separate pass adopted the wording
correction without changing either Lean contract. The exact Lean/olean hashes
still match the passing builds and public audit. The initial Markdown line-ending
diff failure and the restored-LF successful check are preserved. Independent
review and finalization remain pending.

A factual helper also identified future-tense startup wording in this current
section. The parent adopted a present-tense clarification after checking the
implemented imports and normal form; no contract changed.


### Independent review, reconciliation and final pre-F checkpoint

The same bound reviewer received the exact neutral request through an authenticated
standalone text artifact, with source R
`31385287b10fbd7db0d76724c29b57008187992259897c2c781da100141447a9`.
The original empty native return is preserved as uncertain; the attributed full
report separately confirms delivery. A failed normalized-status bookkeeping call
and its precise clarification remain in private records; it caused no native
resend or source change. The original full report is
`ab9d81f67f1a83689fdd00e06257de3d1b98d6762e2b62fb32ff3ea5990a614c`, with ten evidence entries, all three S04
criteria **SATISFIED**, and no findings. Its exact original text and runtime-event
envelope are retained independently of this summary.

The reviewer matched all 151 concrete source hashes twice and rechecked the
exact manuscripts and pinned dependencies. Focused/default builds and fresh
direct elaboration of the owner and both test modules passed. An independent
source-copy probe checked actual-carrier part preservation, inverse-label
surjectivity, coordinates for arbitrary actual VPS outputs, all three retained
paths and final output direction. Its 18 public plus 19 named private declaration
audits used only standard axioms. The parent checked the probe prefix/hash and
read its added consumers; the parent audit separately includes the structure
constructor and three generated fields. Neither audit replaces S06 cumulative
private/anonymous coverage.

The parent critically accepts the assessments: the construction uses the exact
supplied feasible vector and actual dependent endpoints; positivity and incidence
establish the prescribed PPM grouping and endpoint; and C10 preservation plus
S02/S03 and public C11/C12 give the stated existential characterizations. The
existential signed-vector qualification remains explicit. No mathematical
correction, criterion gap or new optional obligation was identified. The harmless
explicit C11 test import is retained as a direct consumer dependency. The C12
idempotence alias remains unnecessary for S04, with any new S05 consumer pressure
assigned to its existing trigger.

The reviewer checks concrete files rather than the derived environment or private
B; the parent verifies all 152 entries and the exact twelve-path B delta. Read-only
independence is instruction-level, not OS isolation or full blindness; effective
requested settings are unknown. Parent and reviewer builds may reuse pinned
dependencies, while the reviewer directly elaborated the three changed sources.
The complete report owns its individual evidence limits.

Only nine owning Markdown documents change after R. The three validated Lean
files, production olean, imports, dependency pins, review tools and normative
plan retain their reviewed bytes. The final milestone build, strict placeholder
scan, diff/link/prefix checks and exact source applicability are recorded before
F capture. The private durable record owns final F and closure references; only
that closure completes S04. Earlier implementation and contextual checkpoint
statements remain chronological records. S05-S06 and C14/C15 remain unstarted.
No commit or push occurred.


## S05 — Paper fixtures and integrated readiness, 2026-09-30

**Checkpoint:** S05 validation and independent review pass; all three criteria are satisfied, and the original report is reconciled. Final applicability/F and durable closure follow this pre-F checkpoint.
Only S05 is authorized by the lead's conditional request. S06 and C14/C15
remain unstarted. The [readiness audit](pfr-c13-readiness-audit.md) owns the
complete manuscript/source/criterion/regression crosswalk and downstream handoff.

### Verified prerequisite and bounded implementation

The parent verified S04 durable closure
`6df596eaff11ff10852492bb3d13e3b1f75f511f29733ccd986a68e46dd5d7c1`,
its final source F
`2cde698a16e9807b255634587d864835f01b7cc20a8c33e09a926596d1bb4ed4`,
all three satisfied criteria, original-report reconciliation
`bcf39553c2c2ddd85b8951babe10933c78bb578c5a52db08a7e20db53f4b010f`
and its resolved contextual finding. All 152 final source/environment entries
matched before the actual conditional S05 message was processed. The installed
workflow accepted exactly S05 and captured B before maintained edits. The
original local message capture, B, before-images and edit intent remain private
durable records. Earlier S04 pre-F prose is historical.

The only maintained Lean change is the separately imported
`Tests/Examples/Incidence.lean`. Its new private fixture classifies an arbitrary
exact partition of `Fin 3`: a whole block gives the indiscrete partition; a pair
block gives the corresponding pair/singleton split; otherwise all blocks are
singletons. The explicit five labels are distinct and exhaustive. `paperColumns`
and `paperRows` give complete Fin 5/Fin 7 equivalences without computing a
generic partition enumeration or promoting test helpers to public API.

`paper_fullMatrix` checks all 35 intrinsic entries in the manuscript's order.
The all-pattern R09 reduced presentation equals the full 7-by-5 matrix, and
R09/R14 each have five admissible partitions. R13's actual subtype inclusions
select rows 0,1,2,3 and columns 1,4, giving the 4-by-2 matrix and its actual
coefficient restriction/extension. The sparse-vector bridge pins R06, R07,
R09, R13 and R14 to the paper coordinates. WholeOnly's R08 bridge uses the
existing bad vector and its actual zero extension, preserving full rejection,
reduced acceptance and nonrecovery. Independent non-involutive row/column
permutations check equation/nonnegativity transport and an asymmetric entry
that distinguishes inverse from forward indexing. R09 explicitly has total
pattern value 7/4, compatible with its per-input normalization.

### Validation, imports and mathematical contract

The required focused build includes both production owners, both incidence
test modules and the important C10 synthesis/C11 reachability/C12 compression
and public nonrepresentable-example consumers. The default build, strict
placeholder scan and diff check pass. Exact commands, outputs, source hashes
and compiler diagnostics are retained under `tmp/c13-s05/` and attached to
private execution evidence. Earlier failed scratch attempts remain available;
they are not reported as passing checks. The initial fixture iterations needed
explicit finite-vector component simplification and controlled equivalence
unfolding for the independent permutation test; these were local proof-script
issues, with no change to the assertions or production contracts.

A factual helper freshly ran `lake env lean -j 1 tmp/c13-s05/audit/PublicAudit.lean`.
All 62 public declarations in Incidence, 18 in IncidenceConstruction, and four
generated structure signatures passed: 84 matching `#check` and `#print axioms`
reports, with no diagnostics or missing names. Every report uses only
`propext`, `Classical.choice` and `Quot.sound`. Both source/olean pairs and
dependency configuration remained byte-identical. This is a fresh public
audit, not S06's exhaustive private/anonymous cumulative audit.

The parent inspected the production imports, signatures and current public
consumers. No production source, lightweight root, dependency, toolchain,
review tool or normative plan change is needed. I retains its focused public
C10/C12 imports; C imports I and public C11. The current API supplies all
C13-owned interface prerequisites for C14/C15, including the possibly empty
admissible family and rectangular structural identities. Optimization,
separation, pattern-size
correction, greatestness/leastness and attainment stay with those later chunks.

Both manuscript hashes match the approved plan. The parent reread the relevant
authenticated extracts; the factual helper also checked the extended p6 matrix
visually. The readiness crosswalk accounts for all assigned logical content
in (33)-(63), with the general Bell identity explicitly excluded under OM-017.
No mathematical assertion required by S05 is reserved for closeout.

### Advice, omissions and documentation

The original revision-2 advice remains traceable. Shared blocks replace the
unattainable supported-decoder collision, R08 keeps its precise typed-vector
distinction, R13 gives actual unequal-column merging, and R14 has a nonempty
admissible family but no nonnegative solution. The accepted R14 local-bound
contradiction remains sufficient; no universal signed-solution uniqueness
theorem is added. The all-seven total-value assertion is a small useful
readability check. Draft audit feedback corrected the S02 criterion mapping
and qualified actual VPS masses by block membership; target-map surjectivity
is explicit in the final crosswalk.

At its S05 trigger, the optional C12 alias is declined for C13: the actual
inactive-output consumer already combines `compressedPatternData_map_injective`
with `D.extraction_roundTrip`. The original suggestion and history are retained,
and a later concrete consumer demonstrating new friction can reopen it. The
C11 private-helper promotion trigger likewise did not arise. Existing omission
owners cover general Bell enumeration, complexity, private fixtures, displayed
proof intermediates, full/reduced repair and downstream optimization; no new
numbered Future Work Note is opened.

The canonical current-status documents now record verified S04 closure and S05
readiness. The map records the concrete OM-017/OM-027/OM-042 work and retains all
71 identifiers and the remaining DG-15 owners. Plan edits are confined to its
editorial status block; original contract bytes and all earlier log entries
remain unchanged. The production and generic-test sources remain unchanged.
No commit, push or later-step execution occurred.


### Contextual review, independent report and final pre-F checkpoint

The parent preserved its original read-only contextual critique and then made
a separate reassessment. Neither pass identified a finding or required a
correction. The assessment checked the exhaustive intrinsic enumeration,
same-vector restriction/extension, the generic versus normalized R11 controls,
support-aware phase consumers, public API ownership and exact plan coverage.

The bound reviewer received the exact neutral request through a standalone
UTF-8 artifact, source R
`06d84076e0c44948683e54e6ba96f4a3bdc54c9f2e69e2761b8e4f4d4235f8ee`.
The original empty native result remains recorded as uncertain; the attributed
full report separately confirms delivery. The complete original report is
`607f8ddb71a677d0bf789267ca4fd8c9112f02097cdfaa4bf0c2a43d71c6f920`, with all three S05 criteria **SATISFIED** and no findings.
Its exact JSON text, native sender/recipient envelope, source binding and
individual evidence limits are preserved separately from this summary.

Ten evidence records support the report. The reviewer matched all 152 concrete
inventory hashes before and after its work, rechecked the manuscript identities
and visually compared its authenticated same-copy page renders. Independent
finite enumeration found exactly five partitions and all 35 matrix entries;
integer arithmetic with denominator 24 confirmed the regression vectors. Its
seven-target focused build (2,785 jobs), default build (2,762 jobs), and fresh
direct elaboration of the entire 1,807-line example module passed. Its fresh
80-public-declaration signature/axiom audit used only standard axioms. The
parent inspected that probe and output; the separate factual helper audit
also covers four generated structure signatures. The parent's eight-target
focused build additionally includes the nonrepresentable-example test.

The reviewer found no whitespace errors; its Git check emitted only line-ending
normalization warnings. The parent's explicit core.autocrlf=false checks are
clean. During targeted canonical crosswalk reads, the reviewer incidentally saw
historical status and a draft-feedback reference. It reports that it did not
rely on those assessments or inspect their underlying conversations/private
records. The neutral request supplied no parent critique or verdict. This
limitation is retained with the report's source-based independence claim.

The parent critically accepts the report against actual source. Five distinct
and exhaustive exact partitions give the complete matrix presentation. The
R09 and R13 comparisons use the actual full/reduced index maps and coefficients;
R08 preserves the distinction between an infeasible full vector and its feasible
restriction. The other semantic and construction regressions remain the same
witnesses. The current public interface and complete manuscript crosswalk leave
no required S05 mathematical assertion for S06. No correction, criterion gap,
new optional obligation or reopened earlier criterion is identified.

The reviewer checks concrete inventory files; the parent also checks the derived
environment and the private B delta. Independence is source-based and enforced
by instructions, not OS isolation or full blindness; requested effective settings
remain unknown. Builds may reuse unchanged dependencies. The public signature
audit does not replace S06's future cumulative private/anonymous audit.

A final factual documentation check clarified that the handoff covers C13's
assigned interfaces; C15 also depends on future C14 work. This changes no
mathematical contract or acceptance criterion.

Only ten owning Markdown documents change after R to record review,
reconciliation, current evidence limits and this final pre-F checkpoint. All
four incidence production/test Lean files, both production oleans, imports,
dependency pins, tooling and normative plan retain reviewed bytes. The final
milestone build, strict placeholder scan, diff/link/prefix checks and all 153
source/environment entries are checked before F. The private durable record
owns final F and closure; only that record completes S05. Earlier checkpoints
remain historical. S06 and C14/C15 remain unstarted. No commit or push occurred.


## S06 — Fresh cumulative validation and closeout, 2026-09-30

**Checkpoint:** S06 fresh cumulative validation passes; contextual review, independent review and finalization remain.
Only S06 is authorized by the lead's conditional request. This is a new
assessment of the entire contract, including earlier source and regressions.
Only supported final closure completes CC09/C13; C14/C15 remain unstarted.

### Prerequisites and source scope

The parent verified all five earlier durable closures, fifteen satisfied
criteria, original-report reconciliations and closed finding dispositions.
S05 closure is
`bc86357cb2f045db4c57c3ed0dd36863e06b082a3bf47d72301bb66787e338bf`,
with final F
`7f6b86a28750d883a25e4d1b56fe770c0771d7ea39d5b087967b384c80eadada`.
All 153 current source/environment entries matched before the actual S06
request was processed. The supported session accepted exactly S06 and captured
B before maintained edits. Prior checkpoints and original records remain intact.

S06 requires no Lean repair. Its four audited modules are the two production
owners and two separately imported incidence test modules listed in the
[readiness audit](pfr-c13-readiness-audit.md#source-owners-and-assumptions).
The production imports remain focused C10/C12 plus public C11 integration;
the lightweight root, pinned dependencies and review tooling are unchanged.
Only ten owning Markdown files change. The plan's normative bytes, all earlier
log bytes and earlier implementation-note sections are preserved. A small
planning-note attribution correction assigns the same-construction suggestion
to P04 and shared-block correction to P01/GA01; the original advice is retained.

### Fresh mathematical and manuscript assessment

The parent reread both production modules and the entire generic consumer,
then inspected sensitive concrete fixtures and dependency contracts. A separate
factual helper freshly read all four source modules, rehashed both manuscript
binaries, extracted the relevant pages and visually checked ISIT p4 and extended
version 16 pp5-7. The approved manuscript identities match. Its per-criterion,
regression and completion crosswalk is evidence for the parent, not the bound
independent review. The parent critically checked that crosswalk against source.

All fifteen earlier criteria, R01-R14 and CC01-CC08 have current source coverage.
The intrinsic partition/indicator boundary is bidirectional. The two P H
identities use rectangular all-ones matrices; the two P v identities use
all-ones vectors. Full/reduced
transport uses the supplied vector, with nonnegativity in absent-row elimination
and full-vector recovery. Equality alone gives total mass one. Valid data do
not assume perfectness, total-pattern normalization or a nonempty admissible
family. Positive-support nonemptiness and block coverage follow from feasibility.

Necessity starts from the public common-posterior witness, identifies whole
pattern fibers only for supported decoders and obtains actual Real row sums.
Sufficiency retains the supplied coefficients, exact positive labels, dependent
VPS carrier transport, surjective PPM grouping and all three actual endpoints.
The public consumer recovers these specifications from one returned object.
Arbitrary presentations preserve inverse coordinate direction. Ambient wrappers
retain inactive output labels and require neither an input prior nor full support.
The construction-existence characterization is existential in the vector; it
does not assert feasibility of every signed vector used in an arbitrary bundle.

The parent also independently enumerated all 127 nonempty families of the seven
nonempty subsets of a three-element set. Exactly five are partitions, and all
35 resulting entries match the paper matrix. Exact rational products checked
R06-R09/R13/R14, admissible counts 0/1/2/5, the R13 proper 4-by-2 submatrix,
R08's changed zero extension, and the R09/R13 phase counts and merge masses.
These finite arithmetic checks corroborate the source; they are not Lean proofs.
The public C03 pair-only example, nonempty infeasible R14, singleton no-ops,
independent non-involutive enumerations and actual inactive-output recovery are
also covered by the maintained Lean consumers.

### Exhaustive declaration and trust audit

The factual helper inventoried all four sources: 399 named declarations
(80 public, 319 private), 150 anonymous examples and 13 unnamed instances.
The source has 3,764 lines: 761 incidence, 387 construction, 809 generic tests
and 1,807 concrete tests. All 562 source items map uniquely to compiler output,
with zero missing or ambiguous matches. Four additional constants are the
construction constructor and projections; 263 others are compiler generated.
These include four lazy dependency-helper occurrences, explicitly classified
against pinned simplifier/equation-generation code rather than counted as
source-written additions to dependency namespaces.

Fresh byte-identical copies of all four modules elaborate without diagnostics.
A second set of copies changes only each `example` header into a uniquely named
private definition and appends a compiler-inspection footer. Reversing those
header edits recovers the original source bytes exactly. This retains types,
proof bodies, scopes and positions while allowing axiom inspection of examples.
The source-to-compiler reconciliation records exact names and source lines.

The instrumented audits inspect 110/79/174/466 current-module constants,
829 in total, including generated constants. Every reported axiom is one of
`propext`, `Classical.choice` or `Quot.sound`. All eight elaboration/audit
commands pass. Instrumented generic/concrete copies emit 71/77 expected lint
warnings caused by named-example definitions (143 `defProp` and five
`classDefReducibility` warnings, all at transformed headers); the exact sources have none.
Warnings are retained, not suppressed. A first scratch mechanics probe failed
on two JSON-parenthesization errors; the exact failed probe/log and corrected
probe are retained. The first reconciliation conservatively flagged the four
dependency helpers; its failure record and subsequent explicit classification
are also retained. No maintained Lean repair followed from these audit attempts.

The parent inspected the audit script, footer, reversible transformation and
result inventories. All four source/olean pairs remain unchanged. The full
records are under `tmp/c13-s06/trust/`, with hashes and attribution in durable
execution evidence. A generated scratch module has different private names;
source aliases and line mappings establish coverage, not equality of those
private names with the production olean.

### Required validation and evidence limits

The parent's fresh nine-target focused build passed (2,787 jobs): both production
owners, both incidence tests, C10 partitions/synthesis, C11 reachability, C12
compression and the public nonrepresentable example tests. The default build
passed (2,762 jobs). The strict placeholder scan returned no matches and the
whitespace check passed. Exact commands, outputs and hashes are retained under
`tmp/c13-s06/` and attached to private execution evidence. Source/configuration
applicability is checked again after owning-document updates and before F.

Builds may reuse unchanged dependencies. Instrumented anonymous-example copies
are explicitly distinguished from exact source elaboration, and the trust
inventory does not itself establish mathematical intent. Factual helpers have
implementation context; their reports do not replace the same bound reviewer's
fresh cumulative assessment. No independent report or future closure is claimed
at this checkpoint. No commit, push or later-chunk work occurred.

### Omissions, advice and completion boundary

The source/manuscript crosswalk accounts for the assigned logical content of
extended (33)-(63), with the general Bell identity at (34) explicitly excluded
under OM-017. All 71 omission identifiers and existing owners remain. The
full/reduced repair, concrete fixtures, displayed proof intermediates, actual
paths and directed comparisons retain their established dispositions.

The C12 alias remains declined for current C13 because the actual consumer uses
injection transport and the complete data round trip. No new consumer reopens
it or the C11 private-helper proposal. Revision-2 suggestions and the accepted
R14 local-bound proof remain adequate. The Future Work Notes register still
has no numbered entries; no new unowned deferral is introduced.

C14 receives C13's valid-data/incidence/normalization/perfectness interfaces.
C15 receives the same dimensions and structural identities and also depends
on future C14 work. Inequalities, objective saturation, greatestness/leastness,
separator correction and attainment remain with those chunks. C13's cumulative
review must still be received and reconciled, followed by final applicable
validation, documentation, F and supported closure. Earlier passing reports
do not replace that fresh independent pass or certify those future acts.


### S06 original cumulative review and critical reconciliation

**Final pre-F checkpoint, 2026-09-30:** The original contextual critique and
separate reassessment are retained. The same bound reviewer freshly assessed
the entire approved contract and satisfies C13-S06-A/B/C. Its complete original
report is retained at `a70a73e3614562b89a404c3df4e10f9f961e13f654944b113903938e3ac4d96e`, with its actual native envelope and evidence.
The original empty submission receipt remains uncertain; the attributed full
report provides separate delivery confirmation without a resend.

The independent report has fourteen evidence records and no findings. The
reviewer freshly read all 3,764 lines of the four C13 owners and the normative
contract, rechecked both manuscript identities and revisited the designated
pages. All 152 concrete source hashes matched before, during and after review.
Its two focused builds passed (2,785 and 2,776 jobs), as did the default build
(2,762 jobs). All 562 source commands received fresh elaboration and individual
axiom checks. A separate original-import probe checked 80 public declarations
and seven generated construction interfaces, all with standard axioms. Both
original test modules elaborated directly with no diagnostics.

The reviewer's source-command count is distinct from the parent's broader
829-constant inventory; both cover all 562 source declarations. Named copies
retain the types and bodies of anonymous examples but change declaration kind
and reducibility, producing the recorded 71/77 warnings. The original-module
checks close that diagnostic boundary. The parent also retains fresh exact
copies of all four sources and independent rational fixture arithmetic.

The reviewer used the same authenticated PDF versions and revisited its own
page renders; the factual helper freshly rendered the required pages. Selected
canonical omission rows incidentally exposed historical review/status prose;
the reviewer reports no reliance on those assessments and did not read parent
self-review/helper assessment bodies, private records or repository scratch.
Independence is source-based, with instruction-level read-only behavior and
unknown effective model/reasoning settings. Source correlation hashes do not
authenticate native provenance; the parent owns actual receipt and private
baseline/environment/closure verification.

The report preserves corrected discovery-command mistakes and a failed initial
mirror write that exceeded Windows command length before execution. They are
separate from Lean checks, which all passed. Git reported only line-ending
conversion warnings; the parent's explicit whitespace checks are clean.
Builds may reuse pinned dependency artifacts. Neither audit claims a fresh
proof review of every external transitive dependency or any later optimization.

The parent critically accepts the current source-backed interpretation of all
fifteen earlier criteria, R01-R14 and CC01-CC08. The actual same-vector and
same-construction boundaries, nonnegative feasibility, signed normalization,
empty admissible indices and directed ambient presentations remain intact.
The original earlier reports are preserved and reconciled; none substitutes
for this fresh cumulative pass. The independent report assesses source readiness
at R and does not certify its later receipt, reconciliation, final validation/F
or closure. Those are separate supported parent duties.

A final factual documentation check found one shape description to refine:
P H is a rectangular all-ones matrix, whereas P v is an all-ones vector. The
parent checked all four actual Lean signatures and the readiness crosswalk;
they were already correct. The bounded prose correction is adopted in the
supported documentation phase, with the original R text retained. No Lean
repair, new assumption, public API or mathematical plan change is required.

All 153 source/environment entries are checked again after final documentation.
Only ten owning Markdown files differ from R. Earlier log and implementation-note
prefixes, all Lean sources, imports, pins, review tools and normative plan bytes
are preserved. The required final default build, strict placeholder scan and
whitespace/source checks follow the final document edits. Exact records own F
and the supported durable closure; only that closure completes CC09/PFR-C13.
All omission/advice dispositions retain their owners and triggers. C14/C15
remain unstarted. No commit or push occurred.
