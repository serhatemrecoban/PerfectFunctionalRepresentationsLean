# PFR-C14 implementation notes

## S04 — Fresh cumulative validation and closeout, 2026-10-01

**Status:** Fresh cumulative validation and independent review satisfy all three S04
criteria without findings. The complete original report is critically reconciled.
This is the pre-F readiness checkpoint: final applicability, F and supported
closure establish CC08/C14 completion in the durable review record. C15 remains
unstarted.

Startup verified S01-S03 durable closure, nine satisfied criteria, all three
original report reconciliations and exact equality of all 159 S03 final
source/environment entries, including Git/index, pins and normative plan.
S03 closure is `71de940fb9b67cd410f6b03639f8910ce891d986152cdf573cbc9d6a6c3fe495`;
S03 F is `0127bbe86be88e76d880c1596be51f82202916349cb148746788d6236e2fc9b2`.
Only the current S04 request was accepted. Private startup/evidence records are
under `.pfr-review/setup/c14-s04-20261001/`. Earlier pre-F records remain intact.

### Fresh mathematical and manuscript assessment

The parent reread every Primal definition/proof and every C14 consumer/helper,
checked exact public signatures and necessary C12/C13/mathlib boundaries, and
critically inspected two read-only helper assessments. No mathematical repair,
new assumption, public helper, dependency change or normative plan revision was
needed. The [readiness audit](pfr-c14-readiness-audit.md) maps all nine earlier
criteria, R01-R10 and CC01-CC07 against current source.

Both original PDF hashes match the approved plan. The parent freshly rendered
and viewed ISIT p.5 and extended v16 pp.7,16,17, checking only Theorem 2/(18)/(64)
and Appendix B (203)-(221). The all-input-row nonnegative slack argument,
explicit attaining witness, reduced admissible columns and nonempty input
retain the documented manuscript interpretation. Adjacent duality and
extended-only material remain excluded. No manuscript is reproduced here.

### Fresh compilation and trust evidence

The six-target production/test/C12/C13 build passes (2,784 jobs), as does the
default build (2,762 jobs). The isolated C13-only consumer, whose sole import
is IncidenceConstruction, freshly applies both row identities, equality
characterization and normalization without Primal. All commands exit zero.
Builds reuse cached dependencies; no clean repository rebuild is claimed.

The exhaustive audit freshly recompiles exact byte copies of Primal and all
three test owners. It then recompiles reversible same-line copies that name
anonymous examples privately and adds a current-module kernel inventory.
Every source declaration is matched to emitted signatures and transitive
axioms, including local instances and generated constants. Only `propext`,
`Classical.choice` and `Quot.sound` occur. Exact source copies have no warnings;
synthetic copies report only expected proposition/class-definition warnings
caused by naming the examples. Original sources and compiled module artifacts
remain unchanged. The test-owner audit also covers their inherited C13 fixtures.

| Audited owner | Named public | Named private | Anonymous examples | Anonymous instances |
| --- | ---: | ---: | ---: | ---: |
| Primal | 16 | 1 | 0 | 0 |
| Generic Primal tests | 0 | 10 | 25 | 1 |
| Optimization incidence tests, including C13 | 0 | 48 | 98 | 9 |
| Paper incidence tests, including C13 | 0 | 258 | 94 | 4 |

C14 itself adds 67 anonymous tests, 37 private named test declarations and one
local instance across those owners. The source inventory assigns every item
to S01/S02/S03 and its regression. Source-level helper assessments remain
attributed assistance, separate from the bound independent review.

Exact commands, outputs, reversible header edits, kernel inventories, coverage
checks and source hashes are retained under `tmp/c14-s04/`, with helper source
and test inventories in their separate ignored directories. Initial scratch
setup failed on an implicit Windows text encoding, followed by two unavailable
script commands; no Lean validation ran in those failed setup attempts.
Explicit UTF-8 reads resolved the setup problem; originals/results are retained.

### Advice, omissions and C15

P01/GA01 signed rejection, P02/GA02 entire-image/asymmetric tests, P03 private
slack identity, P04 regression staging and P05 C13-only isolation all satisfy
their current obligations. The extra R09 fixture remains redundant with the
scaled detector and R05 zero coordinate. No blocked consumer warrants a C12
idempotence alias or C11 helper promotion. Existing ownership and revisit
triggers remain; no numbered Future Work Note opens.

DG-13's approved mathematical interfaces are satisfied. C15 can consume the
nonnegative coefficients, pointwise incidence bounds, finite-sum objective,
zero, universal bound, characterizations and unchanged C13 identities. Duality,
separation, sign correction, scaling, leastness and its empty-column treatment
remain C15 duties. All existing omission identifiers and C16 scope decisions
are retained. The cumulative independent review is recorded below; finalization
follows this pre-F checkpoint.

### Independent cumulative review and pre-F reconciliation

Fresh cumulative validation and independent review satisfy all three S04
criteria without findings. The complete original report is critically reconciled.
This is the pre-F readiness checkpoint: final applicability, F and supported
closure establish CC08/C14 completion in the durable review record. C15 remains
unstarted.

Reviewed source R is `fc337870955660ac3b840eb004df8e752ee9928da23375a7b78663088f71900c`. The original report is
`071c80df814b218018a59af48796eb30e12193a969fbe6ffc7b93195b8652e72`, reconciled as
`7a2680ceca7a48f7a9db2b1917b57ec9cc32ffd7f54b4c95584c3879b4943776`.

The same bound reviewer freshly read all production declarations, every C14
test/helper and necessary inherited fixtures/interfaces. It matched all 158
physical R paths before and after review, verified the normative plan digest
and clean pinned dependencies, rehashed both original manuscripts and viewed
fresh renders of all four required pages. It independently reassessed all nine
earlier criteria, R01-R10 and CC01-CC07, finding no correctness or acceptance gap.

Its six-target build passed with 2,784 jobs and its default build with 2,762.
The fresh C13-only five-example consumer compiled without diagnostics. Its
four complete source-copy audits individually checked all 122 C14 declarations:
16 public and one private production declaration, 67 anonymous tests, 37 private
named test declarations and one local instance. Every entry uses only
`propext`, `Classical.choice` and `Quot.sound`. The parent checked the disclosed
reversible header transformation, all 122 inventory entries and the announced
inventory/result hashes against the actual reviewer artifacts.

The test copies have 65 proposition-as-definition warnings and one class-valued
definition warning caused by the disclosed naming transformation. The initial
reviewer postprocessor expected only the first kind and failed; its retained
original and corrected check distinguish that failure from the successful Lean
compilations. Only the bounded postprocessor expectation changed. No maintained
source, statement, proof or compiled audit copy needed correction.

The reviewer checked placeholder absence, whitespace and generated artifacts,
and resolved 371 local document file links. Existing advice/omission dispositions
and the C15 boundary remain justified. Its normal builds used cached artifacts;
no clean rebuild is claimed. It did not reproduce the virtual environment hash,
inspect private historical closures, validate heading anchors, or certify future
receipt/reconciliation/F/closure. Those later duties remain with the parent.

The parent critically checked the complete report, source applicability, fresh
evidence and stated limits and agrees with its three assessments. No mathematical
correction, normative plan change or new deferral is required. All prior original
reports and reconciliations remain retained. The first S04 request preparation
refused a copied S03 request ID before dispatch; a fresh S04 ID corrected it
without overwriting or resending an earlier request.

R-to-final changes only these ten owning Markdown documents. All 52 maintained
Lean files, dependencies, imports, reviewer binding and normative contract stay
identical to R. Fresh final integrity/applicability checks precede F and supported
closure. Under the installed protocol these included documents remain unchanged
after F; `.pfr-review/setup/c14-s04-20261001/closure.json` records the later actual
result. Only successful supported closure establishes CC08/C14 completion.

**Subsequent S03 closure verified at S04 startup:** S03 is durably complete;
the following original S03 pre-F account retains its historical meaning.

## S03 — Channel and coordinate boundaries, 2026-10-01

**Status:** S03 alone is authorized after successful S02 review and closure.
S03 validation and independent review satisfy all three criteria without findings. The
complete original report is critically reconciled. Final applicability, F and supported
durable closure follow this pre-F checkpoint; S04 remains unstarted.

Startup verified S02 closure
`03ef05bae58f8254cb1d5ec32195db153be9a1b77c7ca3caea2ed4050ca44564`,
all three satisfied criteria and original-report reconciliation. All 158 final
source/environment entries match S02 F
`7c7ddabe47588b4291c50a0d102aa75b40916ab7f3946c912e83e326829bfccd`,
including environment, HEAD/index, dependency pins and the normative plan.
The installed workflow accepted only S03. Its startup and actual user request
are retained in `.pfr-review/setup/c14-s03-20261001/`. The original parent/reviewer
binding remains; requested Astra/ultra/no parent history, effective settings unknown.

### Implementation and interpretation

The two ambient wrappers compose C12's prior-free active restriction/compression
perfectness bridge with the S02 data theorem. They require only finite output
and explicit singularity; unused outputs receive no invented pattern/value.
The two presentation lemmas preserve feasibility and the entire objective image.
They reuse C13 `reindex_mulVec` and pinned `Equiv.sum_comp`. The inverse map
`z ∘ cols` covers arbitrary finite vectors; forward coordinates use `cols.symm`
and `rows.symm`. Sum preservation stays local. No duplicate active-channel
wrapper, canonical enumeration, generic LP abstraction or additional helper is
introduced. C13 production, the lightweight root and imports remain unchanged.

The [readiness audit](pfr-c14-readiness-audit.md) maps all sixteen public
production declarations, the private shared slack identity, manuscript
(203)-(221), R01-R10, CC01-CC07, omissions/advice and the C15 interface.
P02/GA02 now have the exact image theorem and scaled asymmetric fixture; P05
has a disposable C13-only consumer. Earlier advice dispositions and scope stay
unchanged; S04 freshly reassesses them. No numbered Future Work Note is opened.

### Validation and review

Parent validation passes:

- Production `lake build ...Optimization.Primal`: 2,779 jobs; final attempt
  10 seconds Lean / 14.13 seconds wall, with no diagnostics.
- Generic Primal tests: 2,780 jobs, 31 seconds Lean, no diagnostics.
- Combined six-target Primal/generic/incidence/paper/C13/C12 build: 2,784 jobs,
  exit zero, 3.64 seconds with cached artifacts.
- Default `lake build`: 2,762 jobs, exit zero, 7.16 seconds.
- Exact production-prefix signature/axiom probe: all sixteen public declarations
  and the private identity, exit zero, 41.46 seconds. Only `propext`,
  `Classical.choice` and `Quot.sound` occur; no extra public assumptions or imports.
- Isolated `C13Only.lean`: imports only IncidenceConstruction, consumes both row
  identities, equality perfectness and coefficient normalization; exit zero,
  18.58 seconds, no diagnostics. Test-module edits do not affect this boundary.

S03 adds 23 anonymous consumers: three generic inverse/greatestness/ambient
consumers, twelve ambient/empty-column consumers and eight paper consumers.
The latter two owners add respectively one private definition and seven private
theorems, three private definitions and two private abbreviations. Existing
fixtures remain private. The readiness audit identifies each regression group.

The ambient helper's first build passed with one long-line lint warning; it
shortened the line and added the direct arbitrary ActiveFiniteChannel consumer.
Its final build passes without warnings (2,780 jobs, 15 seconds Lean).
The paper helper retained three failed attempts: broad definitional reduction
hit recursion limits, a row-label rewrite needed an explicitly typed private
equivalence, and coordinate simplification needed explicit projection/composition
and vector reductions. Its fourth build passes without diagnostics (2,781 jobs,
20 seconds Lean). No resource option, production API or mathematical contract
was changed to make those tests compile.

Exact actual commands, outputs, source hashes and failed snapshots are in
`tmp/c14-s03/`, including attributed `ambient-tests/` and `paper-tests/` records.
The parent read every S03 proof and consumer and checked all R01-R10/CC01-CC07
against the source/manuscript crosswalk. A separate helper's read-only
source/document consistency check found no gap; it is not the bound review.
Builds are incremental, not clean rebuilds. S04 still owns the fresh exhaustive
cumulative independent assessment, including all inherited private/test declarations.
The complete original S03 report is retained below; finalization evidence follows
before F.
The initial production-build attempt was stopped after 119 seconds without
output or an active Lean compiler; its failed/interrupted result is preserved.
The second attempt reached Lean and failed because inverse feasibility needed
explicit unfolding of set membership. The third attempt passed after that local
elaboration correction; both failures remain preserved.
Both original manuscript hashes are checked against the approved plan; the
existing authenticated ISIT p.5 and extended pp.7/16/17 renders were re-inspected.
Only the designated primal passages support the crosswalk.

### Independent review and pre-F reconciliation

S03 validation and independent review satisfy all three criteria without findings. The
complete original report is critically reconciled. Final applicability, F and supported
durable closure follow this pre-F checkpoint; S04 remains unstarted.

Reviewed source R is `c591fbcb72866cb540badbab4153d4c401c685681eb8942e7a5744603a24e16c`. The original report is
`4c24348baaf88ee92e06b81ea88882fbb27f2a7163196dd28f03324f69cb2b30`, reconciled as
`daf7260f6fa5215c4029ea27578721871fa2e1153451d1aeb16eeb3821cfa9af`.

The bound reviewer freshly matched all 158 physical R entries, dependency pins
and the normative plan digest. It read all production Primal declarations, the
generic tests, every S03 addition and the required earlier fixtures/interfaces.
It rehashed both designated manuscripts and viewed fresh renders of ISIT p.5
and extended v16 pp.7,16-17. Its focused six-target build passed (2,784 jobs),
and its default build passed (2,762 jobs); both were incremental.

Its independent probe printed all sixteen public signatures and standard axiom
dependencies, then compiled arbitrary inverse-vector recovery, membership and
greatestness transport, empty-column image and ambient equality-witness
consumers. A separate probe with only the C13 IncidenceConstruction import also
passed. The first disposable probes failed from omitted local classical
decidability and an unspecialized rewrite; their original files and separate
FAIL evidence remain preserved. Corrected successful runs alone support the
criteria. No maintained-source correction was needed.

The reviewer found no placeholder or tracked generated artifact, passed the
whitespace check and resolved 371 local document file links. Its crosswalk
confirms R01-R10, CC01-CC07, manuscript anchors and existing advice/omission
dispositions. It did not independently inspect private baseline records,
regenerate the virtual environment digest, verify Markdown anchors, perform a
clean rebuild or certify future finalization. Those limits are retained in the
complete original report. S04 remains the separate fresh cumulative assessment.

The parent agrees with all three assessments after critically checking their
evidence and limits. No mathematical correction or normative plan change is
required. R-to-final changes only nine owning Markdown documents for the
review/reconciliation checkpoint and DG-13 mathematical readiness. All Lean
and dependency bytes remain reviewed; final applicability and integrity checks
precede F and supported closure. That later record establishes S03 completion.

**Subsequent S02 closure verified at S03 startup:** S02 is durably complete.
The following S02 pre-F account and original evidence retain their history.

## S02 — Saturation and the data-level primal theorem, 2026-10-01

**Status:** S02 implementation, validation and independent review pass. All three
criteria are satisfied without findings, and the complete original report is
critically reconciled. Final applicability, F and supported durable closure follow
this pre-F checkpoint. S03-S04 remain unstarted. The mathematical and acceptance
contract is unchanged.

### Prerequisite and source boundary

The lead requested “continue with step 2 with its review process if step 1 with
its review process is completed successfully”. Startup verified S01 closure
`fbe7d3338e15b9ed59032aea880ae7eb5c1ca8254e6910555a97f96860c166f3`,
all three satisfied criteria, the complete original report's reconciliation and
no unresolved findings or active step. All 158 source/environment entries match
S01 F `6ba82f98164cc07c4c01db96ffcc5c980a2ec1de3c2dd36732195f5e06289412`;
the binding, normative contract, HEAD/index and clean dependency pins match.
The installed execution session accepted only `PFR-C14-S02`. Exact startup and
actual user-message records are retained under `.pfr-review/setup/c14-s02-20261001/`.
The helper's attributed read-only startup evidence is in `tmp/c14-s02/context-audit/`.

### Implemented mathematical contract

`Primal.objective_eq_one_iff` uses S01's private arbitrary-coefficient identity
to make every input-row slack sum zero. For each occurring pattern it chooses
an input from that pattern's nonempty witness. `Finset.single_le_sum` bounds
that nonnegative slack coordinate by its zero row sum, proving the coordinate
vanishes. No fixed single row or injectivity claim on signed vectors is used.
The reverse direction reuses C13 equality normalization.

`equality_feasible_iff` preserves the exact coefficient vector, including zero
coordinates. `isPerfectlyRepresentableChannel_iff_exists_objective_eq_one`
composes it with C13's equality-feasibility characterization. The final
`isPerfectlyRepresentableChannel_iff_isGreatest` uses image membership for an
actual attaining vector and S01's bound for the upper-bound clause. No optimizer
existence theorem or supremum is introduced. All four theorems remain in Primal
under the original finite nonempty-input/valid-data assumptions; admissible
partitions may be empty. Production imports and C13 production remain unchanged.

ISIT p.5 Theorem 2/(18) and extended v16 Theorem 2/(64), Appendix B (215)-(221)
supply the contract. S01 covers the reused bound and structural identities.
The proof replaces the printed nonnegative-kernel prose with coordinatewise
summand control and the printed optimal vector with explicit image membership.
These are the approved interpretations, not stronger assumptions.

### Regression and validation record

| Obligation | Implemented consumer |
| --- | --- |
| R02 | Existing Unit fixture: endpoint saturation, perfectness and greatestness; the equality bridge rejects weight `1/2`. |
| R03 | Generic zero rejection through both the new saturation and equality-feasibility bridges. |
| R04 | Existing pair-only empty-family datum: both characterizations recover nonperfectness. |
| R05 | Existing seven-pattern fixture: actual `(1/4,1/4,1/4,1/4,0)` coefficients, per-input normalization, retained total value `7/4`, saturation preserving the zero coordinate, perfectness and greatestness. |
| R06 | All five partitions remain admissible. The explicit slack vector is feasible with objective `1/2`; no objective-one feasible vector or greatestness at one exists. The signed vector satisfies equality and objective one but is rejected at its `-1/4` coefficient. Private all-admissible restriction identities handle arbitrary coefficients without a nonnegativity premise. |
| R07 | Private valid two-input singleton data: nonnegative second-only slack gives first row zero and second row one while remaining nonzero. Concrete all-row elimination and public saturation consumers check both coordinates. |

There are 13 new generic/R07 anonymous consumers, five beside the existing
singleton/pair-only fixtures and nine in the paper-fixture module. All new
fixture/algebra helpers stay private or local. No later R08-R10 claim is added.

Validation passed:

- First production build, `lake build PerfectFunctionalRepresentations.Optimization.Primal`:
  2,779 jobs, 16 seconds.
- Parent six-target build of Primal, its generic/incidence/example tests,
  IncidenceConstruction and Tests.Matrix.PatternCompression: 2,784 jobs.
- Parent `lake build`: 2,762 jobs.
- Parent `lake env lean tmp/c14-s02/PrimalAudit.lean`: all twelve public
  declarations and the private identity compile with exact signatures; transitive
  axioms are limited to `propext`, `Classical.choice` and `Quot.sound`.
- The paper-test helper's first build passed. The generic-test helper retained
  three failed R07 elaboration attempts before correcting namespace qualification,
  incidence unfolding, the local decidable-equality alignment and explicit
  two-term sum reduction. Its final build and the parent aggregate pass without
  diagnostics. No source placeholder was introduced.

Exact outputs and source hashes are in `tmp/c14-s02/`, with attributed helper
records in `generic-tests/` and `paper-tests/`. Builds use cached dependencies;
no clean rebuild is claimed. Both original manuscript hashes are rechecked, and
the authenticated cached ISIT p.5 and extended pp.7/17 renders are re-inspected
for the S02 statement and (215)-(221). Contextual self-review, separate
reassessment, independent review and final validation remain distinct installed
phases. The same bound reviewer is retained;
requested Astra/ultra/no parent history, effective settings unknown.

P01/GA01, P03 and the S02 part of P04 are addressed by this step. P02/GA02/P05
retain their S03/S04 owners and triggers. No new omission, numbered Future Work
Note, public helper, C13 API change or later-step work is introduced.

### Independent review and finalization checkpoint

The same bound reviewer assessed source R
`820f94f5d3a739909e5400e09541ae4b11f356f31072911495206e73dab7ac7a`
under request `pfr-review:PFR-C14:execution:s02-20261001-r1`, attempt 1.
All three criteria are `SATISFIED`, with no findings. The complete original report
is retained as `4e4390e61934f8e486bda7a96efc7366327e0f68beca4dd0b214d4d9a2685edd`,
with critical reconciliation
`5934274594dae5ad881d6e7d29678290683448004a25ba50bf948dfe934a6c81`.
The parent agrees with its assessment after checking the exact-vector bridge,
every-coordinate slack argument, actual attaining witness and R02-R07 evidence.
No Lean correction, normative plan change or additional review is needed.

The reviewer freshly checked the production proof and regressions, reran the
six-target build (2,784 jobs) and default build (2,762 jobs), and compiled an
independent audit of all twelve public declarations with four new signatures
and additional consumers. These exercise coordinatewise slack elimination,
preservation of a zero coefficient, witness extraction from greatestness,
objective-image membership and arbitrary empty partition families. Only the
standard Lean axioms occur. Its scratch probe emits one deprecation warning
for `Set.mem_setOf_eq`; maintained sources are unaffected. The default-build
batch exits one because its following source search has no matches; the build
itself succeeds, as does the parent's separately recorded default command.

Both original manuscript hashes match. The reviewer inspected freshly rendered
ISIT p.5 and extended pp.7/16/17, and verified all 157 physical R files at entry
and exit. Baseline-delta facts supplied by the parent remain attributed. The
normative plan hash was independently matched after clarifying the installed
status-block transform, which retains both markers and removes only their
intervening text. This was a hashing clarification, with no source change.
The virtual environment inventory was not independently regenerated, though
actual pins and configuration were checked. Builds are incremental.

The complete native final report matches the reviewer-provided UTF-8 copy,
SHA-256 `7ce12d4d2ac1b5b66871ff1df47a1cd832e1e2344783c5cb23edd41f068a2586`.
The original empty submission receipt and its uncertain classification remain
preserved; the matching full report supports the appended delivery confirmation.
Private execution records retain both the original report and its critical
assessment. Only eight owning Markdown documents change after R to record this
review, refine remaining S03 obligations and correct stale current-status rows.
Final validation checks source applicability and document/Git integrity before
F capture and supported closure. That later closure, rather than this pre-F
checkpoint, establishes S02 completion. S03 is not started.

## S01 — Inequality feasibility and the universal bound, 2026-10-01

**Subsequent closure verified at S02 startup:** S01 is durably complete as recorded
above. The following pre-F account and its original evidence retain their history.

**Status:** S01 implementation, validation and independent review pass under
approved revision 2. All three criteria are satisfied without findings, and the
complete original report is critically reconciled. Final applicability, F and
supported durable closure follow this pre-F checkpoint.
The lead requested “okay, do step 1 with its review process” after accepting the
draft and affirming reasoned changes during implementation. The installed
execution session selected only `PFR-C14-S01`. S02-S04 remain unstarted.
The exact pre-approval draft and actual user request are preserved under
`.pfr-review/setup/c14-s01-20261001/`; only the plan's editorial status block
changed for registration. No independent plan review is claimed.

### Startup and source boundary

Fresh startup checks verified C13's durable S06 closure
`b722301a08704288a781de37208dc02ee9837a3070c7f6ca592eedd43e76abdf`, journal
revision 194, all eighteen satisfied criteria and all six original-report
reconciliations. All 50 maintained Lean files, four reviewed C13 documents,
review tools and dependency/environment facts still match C13's F. The six
shared-document changes and two new C14 planning files are the recorded planning
delta. All 155 entries match revision 2's delivered inventory at startup.
The read-only helper's attributed checks are in `tmp/c14-s01/context-audit/`.

The original requested profile and binding remain unchanged: reviewer
`/root/pfr_c14_reviewer`, parent task `01a0f3d9-7dad-7190-8587-fd641698aa29`,
requested Astra/ultra/no parent history, effective settings unknown. C13's
historical pre-F records are preserved. The substantial inherited dirty and
untracked work is outside this step's edits.

### Implemented contract and ownership

`Optimization/Primal.lean` owns namespace `PerfectFunctionalRepresentations.Primal`.
It imports the focused local `Optimization.IncidenceConstruction` module; the
lightweight mathematical root remains unchanged. The four definitions are
`Feasible`, `objective`, `feasibleSet` and `objectiveValues`. The public results
are `feasible_zero`, `objective_zero`, `objective_nonneg` and `objective_le_one`.
Their domain is valid C12 compressed data over finite nonempty input, with
possibly empty admissible-partition indices. C13's equality predicate is unchanged.

The private `inputMatrix_mulVec_slack` identity holds for arbitrary real
coefficients. Matrix subtraction/associativity and C13's `P v = 1`, `P H = 1`
give `P (v - Hx) = constant (1 - objective x)`. Feasibility makes every slack
coordinate nonnegative. Nonnegative input incidence preserves that inequality;
evaluation at an input proves the upper bound. Coefficient nonnegativity gives
the lower bound. This uses row normalization, never a total-pattern-value sum.
No equality feasibility, perfectness, optimizer or nonempty partition premise
is used. The same private identity remains available for S02's saturation proof.

The pinned C13/mathlib interfaces were inspected again; the planning probes
remain available as earlier evidence with their original limits. No new generic
information-theory theorem is needed. LeanInfoTheory stays at immutable v0.1.0.

### Manuscript and regression allocation

The manuscript identities are the exact full hashes in the approved plan.
S01 implements the inequality predicate/objective of ISIT Theorem 2/(18),
supplemented by extended v16 Appendix B (206)-(214). The shared slack identity
is an equivalent algebraic organization of the printed `P Hx ≤ P v` argument.
The full characterization and greatestness at one remain S02/S03 obligations.

| Obligation | S01 consumer / boundary |
| --- | --- |
| R01 | `Tests/Optimization/Primal.lean` applies definitions, zero and both bounds to arbitrary valid data without perfectness or nonempty admissible indices. |
| R02 | Existing private singleton fixture in `Tests/Optimization/Incidence.lean` checks primal feasibility and objectives for weights zero, `1/2` and one. Saturation/characterization consumers remain S02. |
| R03 | Generic tests show zero is primal feasible with objective zero but fails C13 equality feasibility, using C13 equality normalization. S02 will consume its new bridge on zero. |
| R04 | Existing private pair-only fixture checks every objective zero, objective-value set `{0}`, greatestness at zero, failure at one and no objective-one witness. S02 will consume the new perfectness characterization. |

The tests reuse private fixtures in place. Adding a Primal import makes the
existing incidence test module a C14 consumer; the approved small C13-only
import check remains assigned to S03/S04. R05-R10 are not implemented in S01.

### Review, validation and advice

Initial validation passed with no Lean errors or warnings:

- `lake build PerfectFunctionalRepresentations.Optimization.Primal` — 2,779 jobs.
- The five-target build of Primal, Tests.Optimization.Primal,
  Tests.Optimization.Incidence, IncidenceConstruction and
  Tests.Matrix.PatternCompression — 2,783 jobs, executed by the test helper;
  the parent checked its exact output and source hashes.
- `lake build` — 2,762 jobs.
- `lake env lean tmp/c14-s01/PrimalAudit.lean` — exit 0. A byte-identical
  production prefix with an audit footer checks all eight public declarations
  and the private identity, their exact signatures and transitive axioms.
  Dependencies are limited to `propext`, `Classical.choice` and `Quot.sound`.
- The maintained placeholder scan returns no matches. Owned-file whitespace,
  document links, source deltas, actual imports and Git status were checked.
  All prior production Lean, C13 reviewed documents, pins, root and tooling
  remain unchanged; only the existing incidence test gains C14 consumers.

Both designated manuscript hashes match. The parent re-inspected the relevant
ISIT p.5 and extended p.16 page renders and the (213)-(214) continuation on p.17.
Builds reuse existing dependencies; they are not clean rebuilds. The audit's
temporary Python reporting initially needed explicit UTF-8 and normalization
of printed universe suffixes; the saved Lean output already had exit 0 and
was inspected without rerunning the successful Lean command.

The source includes nine generic anonymous tests, eight concrete anonymous
tests and four new private concrete-test helpers. No public test fixture is
introduced. Exact outputs/hashes are in `tmp/c14-s01/` and its `tests/` directory.
Contextual self-review and separate reassessment found no correction to make.
The independent report for R
`7e6ce71985c1b33c91ad49833aeeb518ee210dad1624bed3427c20b36ff47166`
satisfies `C14-S01-A`, `C14-S01-B` and `C14-S01-C`, with no findings.
Its complete original report is preserved as
`42a9ba21277a279c80aff05068a3d15c3d4a0976ade508efcda161e0e5596421`
and explicitly reconciled as
`6d028f95e46673840b88b5707793a788f0973c62ba7832771de578e73c9d92d9`.

The reviewer independently inspected the designated manuscript passages, all
eight public signatures and their axioms, both inequality bounds and the assigned
regressions. Its six-target build additionally includes `Tests.Examples.Incidence`
and passes (2,784 jobs); its default build passes (2,762 jobs). A separate probe
checks the definition bodies, interval membership, generic empty-index objective
set `{0}` and zero's failure of equality feasibility. The captured probe run
passes; an earlier launch had no retained completion receipt and is not evidence.
All 157 physical R inventory files matched throughout review. The reviewer did
not inspect private B records or regenerate the virtual environment digest;
the parent's exact baseline/environment checks supply those separate facts.

The parent accepts the report after checking its mathematical reasoning,
regression staging, source applicability and explicit limits. The private helper
is directly audited by the parent and transitively covered by the reviewer's
public axiom audit. No source or normative-plan correction is needed. The only
post-review edits update eight owning documents with this review checkpoint.
Final checks must confirm unchanged reviewed Lean/dependencies, the bounded
documentation diff, current placeholders, links and Git state. Prior successful
Lean builds and audits remain applicable only with that exact source check;
no additional or clean rebuild is claimed. The installed closure record, produced
after those checks, establishes S01 completion and starts no later step.

The revision-2 advice dispositions remain in the planning notes. P03's shared
private identity and P04's precise S01 staging are implemented here. P01/GA01,
P02/GA02 and P05 retain their S02/S03/S04 owners and triggers. No new unowned
deferral or numbered Future Work Note is introduced. C15 duality and C16's
broader wrapper decision remain outside this step.
