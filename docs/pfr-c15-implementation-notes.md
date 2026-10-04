# PFR-C15 implementation notes

**Current, 2026-10-02:** Revision 2 is active at the S05 cumulative independent-review/final closure checkpoint.
S01-S04 are durably complete. All four original-report reconciliations, twelve
satisfied criteria, resolved findings and exact 174-entry current source/environment
agreement were freshly verified before the conditional S05 request was accepted.
Fresh parent and independent cumulative checks pass; the complete original
report is critically reconciled. Final applicable source/F and supported CC09
closure follow this checkpoint. Earlier dated records retain history; no later chunk starts.

## S01 startup and authority

The actual message, exact approved contract and processing result are retained
under `.pfr-review/setup/c15-s01-20261002/`. The session registers the five ordered
steps/all fifteen exact criteria without authorizing later steps. Its normative
anchor includes the complete approved plan except the reserved editorial status
contents. The contract explicitly records the actual local/pinned source paths;
source capture also includes relevant maintained and nonignored untracked files.
No reviewed plan requirement, dependency or workflow code changes.

The read-only prerequisite audit verifies C14 journal revision 109, all four
durable closures, twelve satisfied criteria and four original-report
reconciliations, with no unresolved obligation. C14 S04 closure is
`22433dd6bda1ff040dd0c16b54781e251599429537fef10902dd81b246fa1b8b`.
All 54 maintained Lean files and three configuration files match the approval
baseline. The six changed canonical documents and two later C15 planning files
relative to C14 F have the expected documented provenance; mathematical and
environment/Git facts remain applicable. Raw `.git/index` bytes and the installed
logical-entry digest are distinct representations; both like-for-like checks
pass. Evidence: `tmp/c15-s01/prerequisite-api-audit.json`.

The designated ISIT/extended PDF hashes were freshly checked and match the plan's
identities. The parent revisited ISIT IV-B/(19) and extended IV-B/(65), retaining
the reduced-coordinate reading clarified in extended IV-A. Earlier full-page
renders remain applicable to identical binaries; no fresh render is claimed.
Manuscripts remain external/ignored and are not stored in durable review state.

The persistent reviewer is `/root/pfr_c15_reviewer`, bound to actual task
`01a0f81e-1ab9-7413-9ed8-c2e905e955cb`, parent role `/root`. Requested
Astra/ultra/no-parent-history settings remain distinct from unknown effective
settings. Read-only review is cooperative, not OS isolation. The same binding is
reused; planning helpers do not replace this independent reviewer.

## S01 mathematical and API contract

`Optimization/Dual.lean` imports only `Optimization.Primal`. The four definitions
are nonnegative transpose feasibility, `D.value` dot-product objective, feasible
vectors and their actual objective image. Existing equality and primal predicates
are unchanged. Values are normalized per input, with no total-value normalization,
input prior or partition-nonemptiness assumption.

Weak duality uses primal coefficient signs for `sum x ≤ x·Hᵀy`, the verified
transpose dot-product identity plus commutation, then dual coordinate signs for
`Hx·y ≤ v·y`. Objective nonnegativity uses positive values and dual signs.
Every supplied input yields the indicator row of `P`: C13's `P H = 1` and
`P v = 1` prove transpose equalities, feasibility and objective one. Membership
at one selects an input internally; it is universal and does not characterize
perfectness. Empty admissible indices are handled directly: zero is feasible by
vacuity and has objective zero. No separation/minimum/finite-transport API is added.

The compiled public inventory has thirteen declarations: `Feasible`, `objective`,
`feasibleSet`, `objectiveValues`, `objective_zero`, `objective_nonneg`,
`weak_duality`, `rowWitness`, `transpose_mulVec_rowWitness`,
`objective_rowWitness`, `feasible_rowWitness`, `one_mem_objectiveValues`,
`feasible_zero_of_isEmpty`. Exact compiled signatures and axioms are audited in
the retained checks; these prose descriptions are not a substitute for the source.

## S01 regressions and staging

Generic Dual consumers check R01/R03 domains, directions, image witnesses,
nonnegative values, equality-witness specialization, all-input row witnesses,
primal-zero/dual-zero distinction, and the separate empty-family case.
The existing Unit fixture checks `y ≥ 1`, objective-one and larger feasible values,
and weak duality with objectives one and two so reversing the inequality is
detectable. The pair-only fixture keeps its empty index and nonperfectness,
attains both zero and one as dual values, and directly rejects leastness at one
using the zero member. This is a fixture assertion, not S03's characterization.

The existing obstructed seven-pattern datum tests R03's signed vector
`(2,2,2,-1,-1,-1,1)`: transpose products `(1,1,1,1,6)`, objective `-1/4`, and
feasibility rejection at a negative coordinate. Its labels and five-partition
enumeration are reused privately; no fixture/public helper is promoted.
R02/R04's characterization consumers remain staged for S03 and finite `Fin 0`
transport remains S04. S02's geometric alternative and R06/R07 are unstarted.

## Validation, review and stopping boundary

Initial checks pass: seven-target focused build (2,786 jobs), default `lake build`
(2,762 jobs), isolated C13-only/Primal-only/lightweight-root consumers, required
placeholder scan (no matches) and `git diff --check`. The isolated probes also
inspect the environment to confirm Dual does not enter those earlier imports.
All thirteen new public signatures and their transitive axioms were compiled and
inspected; eighteen generic examples were audited through a transparent named
copy. Only `propext`, `Classical.choice` and `Quot.sound` occur. That disposable
copy emitted expected representation lint warnings; maintained modules compile
without warnings. The core helper owns those build/audit observations; the parent
owns integrated fixture/default/boundary/source checks and inspects all evidence.

Failed core attempts exposed name shadowing of `Incidence.OccurringPattern` and
a redundant tactic after a closing rewrite; both were repaired without changing
contracts. A failed signed-fixture proof needed an explicit tuple reduction to
`0 ≤ -1`; the actual coordinate/product/objective assertions are unchanged.
Complete receipts and corresponding source snapshots remain under `tmp/c15-s01/`.
An initial root fixture build overlapped the helper's core build and returned the
same core name-resolution errors; its displayed output was truncated, while the
helper's corresponding complete failure receipt is retained. Later integrated
checks are sequential and pass on unchanged Lean bytes. Two administrative
source-audit attempts (index-key lookup and Windows text encoding) also failed
and were repaired; neither modifies maintained source or workflow records.

The source audit compares this step with B, separately from inherited differences
since HEAD. Only the thirteen recorded owned paths change: four Lean owners and
nine documents. Untouched mathematical files, full normative plan, pinned
dependencies, toolchain, Git HEAD/index and reviewer binding remain unchanged.
No maintained generated artifact or reference PDF is tracked. All check outputs,
source hashes, attributed helper evidence and failures are retained in the initial
evidence bundle. Builds reuse cached dependencies; no clean rebuild is claimed.

The original contextual self-review was retained before a separate reassessment;
no recommendations or additional API were recorded. The later source-bound
documentation checks identify the inherited stale sentence discussed below. The neutral request was
frozen at R and delivered to the existing bound reviewer. Empty immediate native
output was preserved as uncertain, without resending. The actual complete final
report supplies separate report-backed delivery confirmation under the current
step authority. Exact original text, native sender/recipient wrapper, extraction
provenance, reviewer evidence, derived findings and reconciliation are retained.

The independent reviewer satisfies all three criteria. It independently verifies
all 170 real-file hashes and derived environment, clean immutable dependencies,
relevant source and freshly rendered manuscript pages, focused/default builds,
public signatures/transitive axioms, source hygiene and earlier-import controls.
Its checks remain attributed separately from the parent's checks; neither cached
build is described as clean. The private C14 journal was outside its source-access
scope; the parent's retained startup closure/applicability audit owns that evidence.
The reviewer disclosed an interrupted duplicate audit attempt; only its separately
completed audit is counted as favorable evidence.

The report's one optional finding concerns the stale current authorization claim
in the map. The parent agrees on the actual lead authorization and corrects it,
refreshing the map's status date. A separate parent documentation pass found the
same sentence. Reviewer-waiting wording is also updated chronologically. These
are bounded documentation corrections, with no Lean or normative-plan change.
The original advice is preserved and adopted within this step; no new deferral
or Future Work Note is needed. Final source/hygiene checks and explicitly
applicable successful Lean evidence support resolution and criterion assessments.

Final R-to-F changes are confined to the nine owning Markdown documents. All
reviewed mathematical/dependency/configuration bytes remain identical, so initial
successful Lean checks remain applicable; no redundant final rebuild is claimed.
Final applicability/F and supported closure follow this pre-F checkpoint.
Builds and records establish neither manuscript alignment nor independent
acceptance by themselves. No commit, push or later step follows S01; only
supported durable closure completes this step.

Original independent report: `e3b6220afe9d29e99f779371c1a7c85a5cf5687532c9c63573b24157201baab0`; reconciliation: `1b0860b41691219cd78f2d63475f5403ee75222c39bd886cd46f5b95b4c183e2`.
Optional finding: `pfr-finding:c15-s01-map-authorization-20261002`. R: `6322cbbdce5ac857baa892f42a328036f9fea0aee08858b7f7031d26f4703b71`.
Report SHA-256: `d09a8b4952eeaa6c443a7b88f3836c74020bb518f722613fd194123f89acb0ad`.

## S01 durable closure and S02 startup — 2026-10-02

S01 closure is `290e0ce3209dcdbe33a065b32604bf3176219453e3ce0fa4844c47e026b458b1`;
F is `0f932def0bdaafa47d15a04d89276aaaeb5b84df2310990d62035f7986cec668`.
Actual S02 startup inspected journal revision 38, its three satisfied criteria,
original accepted report/reconciliation and the resolved optional authorization
finding. Every current inventory hash, environment and Git fact matches F.
The approved normative plan is unchanged. The actual conditional lead message
and supported processing result are retained under
`.pfr-review/setup/c15-s02-20261002/`; only S02 is accepted. B and bounded
before-images were captured before new maintained edits. Source records remain
separate from inherited changes since HEAD; no commit or push is authorized.

The parent freshly rehashed the designated manuscripts and visually reread their
relevant pages using S01 reviewer's existing renders of identical binaries.
ISIT IV-B/(19), extended IV-A's reduced-system and equality-normalization
clarification, and extended IV-B/(65)-(67) retain the approved interpretation.
No new root render or enlarged manuscript scope is claimed. The local specialized
separation/correction proof is the approved route supporting that intended result.

S02 adds only the specialized nonperfect certificate as public API. The actual
intrinsic hull/equality/finite-topology/separation/functional-coordinate route,
cardinality correction identities, positive/nonzero scaling and division proofs
remain private. R04/R06/R07 consumers reuse existing private fixtures and test
explicit arithmetic separately from the theorem's existential witness. No general
leastness/ambient corollary or finite dual transport starts in S02. The existing
bound reviewer is reused after initial validation, retained self-review and
separate reassessment; complete original-report reconciliation and final
source/closure remain required. Initial check outcomes will be recorded here.

## S02 proof, API and regression allocation

`Optimization/DualCharacterization.lean` imports only the algebraic `Dual`,
mathlib's focused locally convex separation module and matrix dual coordinates.
Its sole public theorem is `Dual.exists_feasible_objective_lt_one_of_not_perfect`:
every valid nonperfect compressed datum has a feasible dual objective below one.
The existing arbitrary-universe `Fintype`/`Nonempty` input contract is preserved;
no partition inhabitance, total-value normalization or optimizer assumption is
added. The geometric and normalization machinery stays private (six definitions
and seventeen theorems). Four generated private equations are also included in
the actual compiled-declaration audit.

The proof first uses the S01 zero witness when admissible partitions are empty.
Otherwise, finite affine coefficients are zero-extended into the exact intrinsic
equality system; conversely, C13 supplies their sum-one normalization. The finite
column hull is convex, compact and closed, with an explicit column witness in
the nonempty branch. Nonperfectness puts the value outside it. The pinned
point/closed separation theorem and `dotProductEquiv` inverse law supply actual
coordinates with correctly oriented strict gaps. Summing `P v = 1` and `P H = 1`
over inputs proves both pattern-cardinality products. The prescribed absolute-sum
shift makes coordinates nonnegative and the common threshold positive; its
explicit nonzero proof supports division, strict transpose inequalities and the
subunit objective. The compact-singleton interface and unverified cone fallback
are unnecessary; the approved target and route are unchanged.

Generic consumers check the public certificate, actual objective-image membership
below one and empty-family specialization. R04 reuses the pair-only empty datum.
R06 reuses the five-partition obstructed datum: `(1,1,1,0,0,0,1)` is feasible with
objective `1/2`, while every row witness still has objective one. The existing
primal `1/2` witness checks equality in weak duality. R07 independently calculates
the raw negative separator, cardinality identities across different block counts,
the exact prescribed shift `45/4`, positive/nonzero threshold `63/2`, corrected
coordinates, normalized vector, objective `125/126` and all five strict transpose
products. These explicit arithmetic consumers are separate from the public
existential certificate; no private production helper is exposed for testing.
The general leastness characterization and R06's staged leastness consequence
remain S03 obligations, just as finite empty-index transport remains S04.

The production-only first assembly compiled with two style warnings; replacing
`letI` with `let` removed them. Every attempted source and complete build receipt
is retained. Fixture proof-repair attempts and their failed outputs also remain
retained; they do not alter the mathematical contract. Actual compiled audit
records are distinct from isolated arithmetic source-copy probes. Additional
foundational API owner files outside the fixed explicit source scope are recorded
with current hashes and clean pinned commit/blob equality. This is bounded
dependency provenance, not an inferred universal import closure.

An initial scratch Dual-only boundary probe wrongly demanded absence of mathlib's
separation declaration, which S01's unchanged dependency closure already imports
transitively. Its failed source/output is retained. The repaired probe checks the
actual new boundary: neither the project `DualCharacterization` module nor its
public certificate is imported by `Dual`. No maintained import changes or
stronger dependency-isolation claim follows from this probe.

## S02 initial validation and contextual dispositions — 2026-10-02

Root newly executed the nine-target focused build (2,788 jobs), default build
(2,762 jobs), C13-only/Primal-only/lightweight-root/Dual-only consumers, required
placeholder scan (no matches) and whitespace check. All pass with source unchanged
during each command. The production/test helpers' actual module builds and every
failed/repaired attempt are separately attributed and retained. Builds reused
caches; no clean rebuild is claimed. The Dual-only repaired probe checks absence
of the new project module/certificate, preserving its failed overbroad predecessor.

The read-only trust helper audits 28 actual production constants (24 source
declarations plus four generated equations) and 34 selected new paper-fixture
constants (29 named helpers plus five generated descendants). Every signature
and transitive axiom closure is checked. Seventeen anonymous examples are not
retained original-olean constants: separate header-only renamed exact-body copies
audit them with reversible provenance. Thus 70 new source declarations correspond
to 62 actual constants plus 17 attributed copy constants, all using only
`propext`, `Classical.choice` and `Quot.sound`. Scratch's unused-variable warning
and Windows Unicode preview/metadata failures remain disclosed and do not become
production warnings or favorable failed checks. Original source/olean/ilean bytes
are unchanged during those audits.

Root's B/current audit finds exactly the thirteen owned changed paths and 173
inventory entries. All other source, environment, Git HEAD/index and the complete
normative plan remain unchanged. Actual designated manuscript identities and
relevant source passages were refreshed. Full source meanings, assumption/edge
cases, scope, imports and consumer staging were inspected, including all actual
compiled private topology/correction declarations; independent acceptance remains
distinct from compiler and structural record checks.

Read-only contextual self-review retained two optional recommendations, followed
by a separate reasoned reassessment. Both are adopted: the current map discovery
paragraph now identifies the approved/compiled specialized route, and current
documents align compiled implementation, passing initial checks and pending
independent dispatch. IDs are `pfr-finding:c15-s02-map-route-status-20261002` and
`pfr-finding:c15-s02-document-stage-20261002`. Their original advice, evidence and
dispositions are durable; historical S01/planning records stay intact. An initial
self-review packet was refused for extra metadata fields. The supported six-field
presentation preserves every omitted detail verbatim in its narrative and the
original private record, with no changed claim or source. No deferred advice or
new Future Work Note is needed. Independent source-bound review, original-report
reconciliation, final applicability/F and supported S02 closure remain required.

## S02 independent report reconciliation and final-source readiness — 2026-10-02

The persistent reviewer returns one complete original source-bound report for R.
All three exact S02 criteria are independently SATISFIED, with no findings. The
original runtime wrapper/payload, uncertain immediate receipt and separate
report-backed delivery confirmation are retained. Delivery confirmation is not
acceptance. Root separately inspects the full criterion rationale, attributed
checks, source/manuscript/assumption interpretation and disclosed limits; the
complete original report is critically reconciled through the supported interface.
Its own source refresh, build/probe/trust evidence remains reviewer-attributed,
separate from parent/helper checks. No favorable prose substitutes for either
actual source applicability or the later supported closure record.

The reviewer independently builds the focused/default targets (2,788/2,762 jobs),
audits all 28 actual production constants, compiles four earlier-boundary probes,
recomputes R07 using exact rationals and checks all 172 real-file hashes plus the
derived environment before and after review. Its first scratch audit fails on an
omitted `Nat` annotation; the original failure remains `FAIL`, and its separately
passing correction establishes the audit. The reviewer source-inspects/builds
fixtures; the parent/helper's additional 34 actual test constants and 17 anonymous
copies remain separately attributed. Exact helper/reviewer probe sources and all
failed/passing receipts are also retained durably outside the source inventory.

The two earlier contextual optional corrections remain adopted; their dispositions
are refreshed against final current evidence rather than inherited from stale
documentation bytes. No new reviewer advice or deferral needs routing. R-to-final
changes only nine owning Markdown documents for reconciliation/checkpoint status.
All reviewed Lean proofs, consumers, imports, pinned dependency/configuration,
Git HEAD/index and frozen normative-plan bytes remain identical. Final source,
document, environment and hygiene checks are fresh; successful initial Lean builds,
four boundaries and full attributed trust audit remain explicitly applicable.
No redundant or clean rebuild is claimed. Only supported durable S02 closure
completes this step. S03-S05, dependency changes, commits and pushes remain
unstarted/unapproved; the full Corollary1 characterization remains S03 work.

Original S02 report: `ba7bbcb1047a258446b97faf11c310e53d52b7a1fca285718c91e9044277fd31`; reconciliation: `3171adc0629f3d9f7cc5787effa3db9b391b5c52dc51ed9a94bd7c6630cc09a9`.
R: `9edafd8cda153f971d0848359b5c4cbe0991443a63de76ac942ff52d6dde10af`. Report SHA-256: `51ec6e109d1957f6207cbffc5c0db98fc07b169c7f9a3ee5ac33327e36fc5f11`.

## S02 durable closure and S03 startup — 2026-10-02

Root freshly verifies S02 closure
`bccaacb4a04775f1c158e7315277aac44e48d9cbf84c0bd403660e0d33bb5311`,
F `f1e67a5fe6383273f8c2df0c4b2a529f74ea4f3123c8f7ae572eb6a37072e1cf`,
all three satisfied criteria, complete original-report reconciliation and both
resolved contextual findings. All 173 source/environment entries, Git/index,
pins and frozen normative plan agree exactly. The actual user request and
accepted S03 processing are retained in `.pfr-review/setup/c15-s03-20261002/`.
An early begin-edit call ran before the source-capture operation had finished
and safely refused NO_ACTIVE_STEP; a retained-state continuation then observed
the original accepted request. No duplicate request or authority was created.
The owned edit was captured before maintained changes. A third helper could not
be resumed because of the native agent limit; no nonexistent audit is claimed.
The existing persistent reviewer/history will be used after contextual phases.
No installed plan review, dependency/tooling change, commit, push or S04 work.

## S03 initial validation and source alignment — 2026-10-02

Exactly two new public production theorems establish the data leastness iff and
finite ambient singular-channel iff. The former obtains C14's actual primal point
of value one, supplies membership with S01's row witness, and bounds every dual
image witness by weak duality. The reverse direction contradicts the lower-bound
component using S02's actual subunit certificate. The latter composes the actual
C12 active/compression perfectness iff, retaining arbitrary finite ambient output
types, unused labels and no prior/full-support premise. All 23 private S02 helpers
and direct imports remain unchanged. No finite presentation/count theorem, global
optimizer, executable solver or broader C16 wrapper is introduced.

ISIT p.5 IV-B/(19) is interpreted as attained `IsLeast` of actual feasible values;
designated extended v16 p.6 IV-A supplies the reduced-system clarification and
p.7 IV-B/(65)-(67) supports the intended corollary. Root freshly rehashes both
original binaries and rereads the identical earlier complete-page renders at these
anchors; no fresh rendering, literal mixed-system dual or unrelated extended-only
scope is claimed. C16 retains the broader nonsingular/singular wrapper decision.

R02 uses the Unit datum's actual primal point for a universal dual lower bound
and both leastness directions. R04 proves empty-family nonperfectness/leastness
failure while row witnesses retain objective one. R05 reuses the zero-containing
`r09Weights` equality/primal point, row normalization and total value `7/4`, proving
every dual value at least one. R06 proves leastness failure for the existing
five-column obstruction using its feasible objective `1/2`. R09 covers explicit
perfect/nonperfect Option channels, zero and inactive `none`, unchanged patterns
and injected extraction, and a genuine swap of distinct active labels with actual
channel transport and equal intrinsic data for the two supplied presentations.
Generic consumers exercise both iff directions and lower-bound sufficiency.
Private fixtures remain private, without identifying the existential separator
with the hand-calculated correction vector. Existing C12 injection/extraction/
enumeration bridges suffice; the declined idempotence alias has no new need.

Production helper build/signature/actual-olean checks pass; the actual module has
30 constants, with both new public signatures freshly audited. Root's actual test
audit covers 17 new named private declarations plus six generated descendants
(23 constants). The test helper additionally checks all 33 new test source entries
through exactly reversible header-only anonymous renaming: 17 named and 16
anonymous bodies. Named scratch checks supplement their actual-olean checks;
anonymous copies are separate elaborations, not retained original-olean constants.
All transitive axioms belong to `propext`, `Classical.choice`, `Quot.sound`.
Current source/olean/ilean identities are stable. Thus all 35 new source declarations
are covered with accurate actual/copy attribution, without promoting helpers.

The first fixture build fails only on an overbroad simplification of the changed
enumeration equality. Its exact source/output is retained; an explicit equivalence
rewrite fixes it. The three-target b02 passes (2,785 jobs). The mandatory scan then
matches a forbidden word in a comment, not a proof hole. That single word is
corrected, exact before/current substitution verified, paper b03 passes (2,783
jobs), and its refreshed anonymous audit passes. Root's current focused/default
builds pass (2,788/2,762 jobs), along with C13-only/Primal-only/root/Dual-only probes,
the no-match placeholder scan and whitespace check. Earlier boundary probes remain
applicable: only the unrelated paper-test comment differs, and all imported
production/dependency bytes are unchanged. No unnecessary rerun is claimed.
All failed/passing attempts, own-script encoding/phase-order failures and lookup
limits remain retained; builds reuse caches and are not clean rebuilds.

Root audits the exact B-to-current delta, preserving other source, Git HEAD/index,
dependency/environment facts and the full frozen normative plan. Source-based
checks and helper contextual advice do not replace independent acceptance.
Contextual self-review, separate reassessment, source-bound independent review,
original-report reconciliation and final validation/F/closure follow this checkpoint.

## S03 contextual disposition — 2026-10-02

Read-only contextual self-review and a separate reassessment adopt one optional
current-document correction, `pfr-finding:c15-s03-planning-current-header-20261002`.
The original helper D01 critique and root's original full evaluation remain
retained with their source attribution. The explicitly Current planning header
now records durable S01-S02 completion and accepted S03/passing initial checks,
with independent review pending. Current summaries are normalized at the same
checkpoint; all original planning/pre-F history and normative mathematics remain.
Fresh current evidence supports the editorial resolution; no deferral or numbered
Future Work Note is needed. Independent review, full original-report reconciliation,
final validation/F and supported closure remain separate required operations.

## S03 independent report reconciliation and final-source readiness — 2026-10-02

The same persistent reviewer returns one complete original source-bound report
on the registered R. All three exact S03 criteria are independently SATISFIED,
with no findings. The full runtime envelope/payload and original uncertain receipt
are preserved; separate report-backed delivery confirmation is distinct from
acceptance. Root critically evaluates the original criterion/evidence rationale,
source/manuscript assumptions, actual checks, earlier advice and disclosed limits,
then explicitly reconciles the original report through the supported interface.
Reviewer-owned checks remain attributed independently from parent/helper evidence.

The earlier optional planning Current-header advice stays adopted, with its
original critique/history retained and disposition refreshed on final exact
evidence. No new advice, mathematical repair or deferred work needs routing.
R-to-final changes only nine owning Markdown documents for full reconciliation
and final-checkpoint status. Every reviewed Lean proof/test, import, explicit
dependency/configuration, Git HEAD/index and frozen normative plan is unchanged.
Fresh final source/document/environment/hygiene checks support current applicability
of successful compilation and actual/copy trust evidence. Cached builds and the
earlier-boundary unrelated-comment mapping remain explicit; no redundant clean
rebuild or workflow-based mathematical certificate is claimed. Exact failed/passing
attempt sources/receipts are retained durably outside the source inventory.

ISIT IV-B/(19)'s attained minimum and the designated extended reduced clarification
align with data leastness and ambient finite singular perfectness. S04 retains
finite presentations/counts, S05 the fresh complete-chunk audit/closure, and C16
the broader nonsingular/singular wrapper scope decision. No solver, global dual
optimizer, dependency/tooling change, commit, push or later step is started.
Only supported durable closure completes S03 after this pre-F checkpoint.

The report's two production line spans are imprecise: the reviewed declarations
start at lines 234 (data iff) and 252 (ambient iff). Root records those locators
in its separate reconciliation and preserves the original report unchanged.
Byte-bound source, declaration names, full compiled signatures and proof logic
identify the correct results; this navigational error changes no acceptance claim.
Reviewer anonymous audit copies emit expected proposition-definition linter
warnings from the transparent scratch renaming. They pass with standard axioms;
those warnings are not attributed to maintained source.

S03 R: `135c7993bfe6f1e6f01d98169cf4bc953004af1324cfee7ea92b69dbd48d3c5a`. Original report: `8e55aec8ab6bb1500659e01b222b0c49cffb0fa7783b02854778bb46eada683b`.
Reconciliation: `fb9250ac6b1e6615d2996c0eb40535a895f3749ecef4987c32c69899745cc12f`. Report UTF-8 SHA-256: `0a41903d0e3cf23242763b42da215d41376d6a97944f107222fdaa4539aa05ae`.

## S03 durable closure and S04 startup — 2026-10-02

Fresh root inspection confirms S03 closure
`03b94eed03b3f3ee61ccc52b9817c3ed5db39d642c1593ea651d2db9c8ffe61e`,
F `ca728df6a77c03479055d25ed3522a52b5199f42a47bed3f5df48aaeee5e5669`,
all three parent/independent criteria, complete original-report reconciliation,
resolved contextual finding and exact equality of all 173 inventory entries,
environment and Git/index. The normative revision-2 plan is unchanged. The actual
conditional user request is accepted only for S04; its B and owned before-images
precede maintained changes. Records are in `.pfr-review/setup/c15-s04-20261002/`.
The two implementation helpers own disjoint production/test paths; root owns
documentation, integrated checks and the installed workflow. The same persistent
reviewer is reserved for neutral source-bound review after contextual phases.
Some initial path guesses failed; `rg --files` located the actual owners. These
read failures supply no theorem-absence evidence and change no maintained source.
S04 keeps algebraic presentation/image transport in Dual, finite characterizations
in DualCharacterization, and reuses counts/private fixtures. No generic LP bundle,
global optimizer, solver, dependency/tooling change, commit, push or S05 work.

## S04 finite presentations and initial readiness — 2026-10-02

S04 adds four all-vector algebraic presentation theorems in Dual and two finite
leastness iff statements in DualCharacterization. Transposition swaps the two
independent equivalences; forward vectors/values use `rows.symm`, columns use
`cols.symm`. Arbitrary finite vectors return as `z ∘ rows`; both directions of
the actual objective image are proved. The finite singular corollary rewrites
that image and consumes S03. Existing C13 counts give exactly `m` occurring-pattern
variables and the full-universe bound; no duplicate count/public LP interface.

Current production locations are Dual:112/121/139/149 and
DualCharacterization:264/276. There are 22 public source declarations and 23
private source helpers in the two modules. The actual imported-module audit
covers 51 compiled constants, including six generated equations (two public,
four private); it retains exact types and transitive axioms. Only `propext`,
`Classical.choice` and `Quot.sound` occur. Source/olean/ilean hashes stay stable.
All prior proof/import bytes are preserved apart from module-docstring appends.
The extra pinned `Equiv.sum_comp` owner in Group/Finset/Defs is hashed separately
as bounded clean-dependency provenance, without changing the registered scope.
Local LeanInfoTheory source/API/docs/index/highlights/module-guide searches and
compiling probes verify reuse; no generic information theory is reproved and
no genuine discoverability friction or dependency change is introduced.

R01-R10 are complete in their maintained owners. S04 adds ten private test helpers
and 28 anonymous consumers. Pair-only data retain three variables with `Fin 0`
constraints, arbitrary inverse and entire image, zero/one membership and failure
of leastness; this differs from C14's primal empty-family image. The actual
obstructed fixture uses independent non-involutive permutations across unequal
values: raw transpose `(64,12,18,33,7)`, objective `239/8`, transported zero
coordinates `8`, `3/8`, `33`; forward errors are `64`, `1/8`, `7`. Option injection
and genuinely changed active presentations instantiate both finite ambient
directions and entire-image equality. Fixture ownership and CRLF bytes are retained.
The [readiness audit](pfr-c15-readiness-audit.md) maps CC01-CC08, every S01-S04
criterion, R01-R10, authenticated manuscript anchors and all selected dispositions.
No mathematical duty is deferred to S05. CC09 and fresh cumulative closeout are
still separate and unstarted; C16 retains the broader wrapper.

Fresh root focused/downstream build passes **2,788 jobs**, and default build
passes **2,762 jobs**, reusing cached dependencies. Four fresh isolated consumers
check Dual-only, Primal-only, C13-only and lightweight-root declaration/module
boundaries. No claim that all foundational geometry is absent is made.
The required literal placeholder scan has no matches; whitespace checking passes
with existing Git LF/CRLF conversion notices. Root compares B/current source,
the entire normative plan, Git HEAD/index and all installed pinned packages,
preserving unrelated dirty/untracked work. No tracked reference/build artifacts.

Actual failures remain attributed: R08's first scratch arithmetic probe failed
only high-index literal reductions, repaired in its second probe (which had
sequencing lint notices); maintained b01 failed on a missing qualified pattern
type, b02 passed with a long-line notice, b03 passed without warnings after its
line split. Scratch-only audit-wrapper/read/encoding failures are retained with
their repairs and are not favorable proof evidence. Some guessed local paths
failed; actual owners were then found. Such failed reads give no absence evidence.
Exact source copies, commands, UTF-8 output, completed sessions and all audit
attempts are retained in `tmp/c15-s04/` until copied to durable private records.

Original PDF hashes match the approved plan: ISIT final(3)
`48963aa59485b2c33b1a1e6e7c6ead2251fdddd26bd3691b6fcffe683e6ed1c4`,
extended v16 `98636d4c9f0618ec08fca84559572780f604f197fda90d8d7c787b3624245b8f`.
Root reread existing authenticated page renders after fresh original identities
matched; no fresh render is claimed. ISIT p5 IV-B/(19) and reduced-variable count
align with extended p6 IV-A reduced clarification and p7 IV-B/(65)-(67). No
extended-only algorithm or manuscript media is retained in maintained/private records.

This is parent implementation/readiness evidence, not independent acceptance.
Production and test-helper checks retain their actor attribution; anonymous
header-only renamed proof bodies are separate elaborations, not original olean
constants. Native provenance is observed rather than authenticated by Python.
The bound reviewer retains its own history; requested profile/effective-unknown
and cooperative read-only limits remain. Contextual self-review, separate
reassessment, neutral registered independent review, explicit reconciliation,
final applicability/F and supported S04 closure still follow. No S05 starts.

## S04 original independent report and reconciliation — 2026-10-02

The existing bound reviewer independently assesses R
`2d29e780325c3039b500adde5bd05acb8ecb91d664156a1ecc339be83b421bc7`, request `pfr-review:PFR-C15:execution:s04-20261002-r1`, attempt 1.
All three S04 criteria are SATISFIED with no findings. Complete original UTF-8
report SHA-256 is `b3712d3629423b6901021b25ef4c90054bc90234742e7cee92ef1605722c8d94`. The original payload and actual native wrapper are
preserved before fallible classification; the initial empty/UNCERTAIN submission
receipt stays unchanged, with separate report-backed delivery confirmation.
Report capture `5208b498f8fb3bf42d78061d3ac2bc6b41ccf15d37e0d1f5562b862b79a9fad4` and reconciliation
`f1a3ca8567ee9a86c6690db55e2cc97ef0e5c4694f517fa833ccd43c51dbfb2d` remain durable and distinct from final step closure.

Root evaluates each original assessment against actual source and its own
successful initial checks, with all original failures/limits retained. The report
confirms all-vector feasibility/objective/transpose transport, arbitrary inverse
and full finite image, the finite singular corollary and exact reused counts;
the discriminating unequal-value-class independent permutations, Fin3/Fin0,
inactive Option/injection and genuinely changed presentation consumers; and the
complete API/import/trust, manuscript and CC01-CC08/earlier-criterion/R01-R10
crosswalk. Original report verification and evidence retain exact reviewer command
results, source scope and provenance limits; compiler facts are not synthesized
from a favorable verdict. Root's critical reconciliation is separately retained.

Reviewed Lean, explicit dependency/configuration, Git HEAD/index and normative
plan bytes stay identical while only owning editorial documentation records this
checkpoint. Fresh final source/environment/Git/normative/document/hygiene checks
follow the finished bounded edit; earlier successful compilations and audits
apply by exact bytes. Cached builds and transparent anonymous-copy audits remain
distinguished from actual imported named/private/generated audits. Requested
profile/effective-unknown and cooperative native/read-only limitations persist.
Available exact helper/reviewer/root artifacts and attributed root read/encoding
failure excerpts are retained in durable
`.pfr-review/setup/c15-s04-20261002/attempt-artifacts.json`, excluding
papers/media/raw manuscript extracts. Root made no commit/push/dependency/tooling
change. Only supported closure completes S04; S05 fresh cumulative validation,
CC09 and chunk closeout remain unstarted, and C16 keeps the broader wrapper.

## S04 durable closure and S05 startup — 2026-10-02

Root freshly verified S04 supported closure
`66414a2c1127ec37920d956a5a3d9d0a812f1dc7829669c308bc3df133c1e160`
and final source F
`2ea12fc4c11d6f6a928e564d0ad4ab086159cd2a80b72fd84632ea3967cf9849`.
All four earlier original-report reconciliations, twelve satisfied criteria and
resolved findings agree with the durable closures. All 174 current inventory
entries, environment, Git/index and frozen normative contract match the verified
final source. The preserved S04 pre-F entries remain historical; this later record
establishes its completion and permits the conditional S05 request to be accepted.

Only S05 is authorized. B is
`d4091be5f3f3e20be71b2d2e281dc40c48aa32f32bc2a8f136c68fae6789e384`;
the ten-Markdown owned edit reference is
`e15da52f9a344a3c89e84ba349d49bc7d17058fe69d271174c939c383dad2cc9`.
The existing execution session and persistent reviewer/history are reused.
These identities are root-observed workflow records, not a mathematical proof
certificate. No private records are edited by documentation assistance.

## S05 initial cumulative assessment and pending validation — 2026-10-02

S05 owns a fresh complete-contract assessment, not another theorem step. The
[readiness audit](pfr-c15-readiness-audit.md#s05-fresh-cumulative-validation-duties--2026-10-02)
maps the twelve earlier criteria, R01-R10 and CC01-CC08 to actual source; the
complete production API/import graph, private proof machinery, named/generated
test declarations and anonymous bodies require fresh exhaustive checks. Actual
imported olean audits and transparently renamed exact-body anonymous copies keep
their distinct attribution and applicability. No new audit count or favorable
build outcome is claimed at this initial checkpoint.

Root freshly matched both original manuscript hashes to the approved plan and
actually reread the existing authenticated full-page renders for ISIT p5 IV-B/(19)
and extended p6 IV-A/p7 IV-B/(65)-(67). Display images were resized; no fresh render
or extended Section V/algorithmic coverage is claimed. The reduced-system
interpretation, nonempty finite input, inactive ambient outputs, empty admissible
family, attained leastness and exact occurring-variable count stay explicit.

Fresh focused/downstream/default builds and the four isolated import-boundary
checks are running; exhaustive helper auditing is also underway. Their exact
completed commands, outputs, source/olean hashes and any failures remain pending
owner inspection and recording. Historical successful S01-S04 checks supply
provenance, not substitute S05 results. Contextual self-review and reassessment,
neutral source-bound independent review, original-report reconciliation, final
applicability/F and supported CC09 closure remain pending. Only that closure
completes C15. C16, commit/push and dependency/tooling changes do not follow.

## S05 actual fresh checks and contextual assessment — 2026-10-02

Root freshly builds the nine focused/downstream targets (2,788 jobs) and default
target (2,762 jobs), exit zero without warnings, using cached dependencies. Four
separate Dual-only, Primal-only, C13-only and lightweight-root consumers pass.
Dual excludes the Characterization module/names, while its pre-existing mathlib
separation closure is honestly reported. The placeholder scan is empty (rg exit1);
diff checking passes with inherited Git LF/CRLF notices. All source hashes remain
unchanged during checks; dependencies/configuration/Git HEAD/index are preserved.

Helper `/root/c15_feasibility` freshly inventories all 200 C15 source declarations
(45 production, 64 named fixture, 91 anonymous), and ten inherited context instances.
Actual imported trust audit checks 145 constants:132 C15 (109 source+23 generated)
and13 context (10 instances+3 descendants). Three `unit_dual_*` names are included
without relying on the c15 prefix. Four exact full-context source copies first
check165 source headers; a separately retained coverage reassessment adds missing
generated-copy metadata checks, yielding107 copy constants:94 anonymous (91+3)
and13 context (10+3). Nine fresh Lean commands pass; no failed Lean attempt.
Only `propext`, `Classical.choice`, `Quot.sound` occur. Expected scratch definition
linter notices are separately attributed; actual audit/maintained builds are clean.
All18 source/olean/ilean hashes and eight exact header/prefix/suffix reversals pass.
Root parses every actual/copy-generated type/axiom row, verifies109 source names,
all receipts/current hashes and exact-body transformations. This is226 C15 actual
or transparent targets, with13 inherited context targets separately attributed.

Helper `/root/c15_context_audit` freshly checks the full contract/readiness,
selected earlier source bridges, supported pinned LIT source/API/index/highlights/
module guide and justified mathlib owners. All10 packages are clean and match
locks; Lean4.33.1 and LITv0.1.0 remain. The bounded source closure reaches12 supported
LIT modules from19 local modules; no unsupported import, new generic IT theorem
or discoverability friction. Source searches and extra clean Equiv.sum_comp owner
are attributed, not universal absence proofs. Root directly rereads the proofs,
C15 fixture assertions and relevant source bridges, and reassesses all12 earlier
criteria/R01-R10/CC01-CC08. No mathematical repair, weakening or scope expansion.

Actual parent startup failure is retained: the first assertion incorrectly required
an empty original S01 finding list; its optional map finding was already RESOLVED.
The original script/error and correction remain private; no authority was consumed
or source edited before failure. The corrected fresh check verifies each original
finding's disposition and preserves all earlier reports. A premature criteria read
before startup completion is retained as a failed read, not absence evidence.
Initial broad tool excerpts were truncated; narrowed source/receipt reads and
programmatic exact inventories supplement them. Source UTF8 contains no replacement
character; display/transcoding attribution is explicitly retained.

Original self-review, separate decision pass, neutral fresh cumulative independent
review/reconciliation and final F/supported CC09 closure remain distinct pending
acts. Exact root/helper source/check receipts are retained under tmp/c15-s05 until
durably copied without manuscript binaries/media/extracts. Parent/compiler hashes
are not independent acceptance. No commit, push, dependency or tooling change.

## S05 original cumulative independent report and final checkpoint — 2026-10-02

The existing bound reviewer freshly assesses the entire approved contract at R
`b34b728b628d3f67c55013da07c5c1aaeecbaa55c3b37fa4e7f762db90cd9131`, request `pfr-review:PFR-C15:execution:s05-20261002-r1`, attempt 1.
All three S05 criteria are SATISFIED, without findings. Full original UTF8 report
SHA-256 `3ea9ea45bbd0ad33b76d3a8bcee99efe0ef9eb4cbf7c0e7b1ce52fe0ac48dd9d` and actual native FINAL_ANSWER wrapper
are preserved before fallible classification. The original empty/UNCERTAIN native
submission receipt remains unchanged; separate actual report-backed delivery
confirmation, report `e5cb2a3a653fc3a986e2bfa2ae473f6d6cc65e4daf1159c0bd1287ea4113eb7e` and reconciliation
`431d5aa0c933406b49e385bfbb0cd31658a295d26e7418b13a4c70332eb2953b` stay distinct from final closure.

Root reads and critically compares every original assessment and attributed check
with actual source, its own fresh checks and exact helper inventories. All twelve
earlier criteria/R01-R10/CC01-CC08, production/private proof and test surface,
manuscript reduced-variable interpretation, active-output/empty-family boundaries,
all-vector inverse/whole-image/count contracts, source trust/import ownership and
selected advice/omission dispositions retain their approved strength. Original
earlier S01 map advice and S02/S03 editorial findings remain resolved with their
frozen history; no earlier report is relabeled as fresh cumulative acceptance.
Original negative checks, warning attribution and review limits remain explicit.

The fresh reviewer namespace audit covers 637 constants; its separately repaired
exact-module audit covers 640, including three generated context constants outside
the first namespace filter. Its coverage failure remains negative evidence.
All 18 source/olean/ilean identities remain stable. The inventory confirms 200
C15 source declarations (45 production, 64 named fixtures, 91 anonymous examples),
133 actual C15 named/generated constants and 13 inherited instance/context
descendants. All 94 transparent anonymous constants use only the permitted standard
axioms; their 91 transformation warnings belong to scratch copies.

Root's earlier selection audited 132 C15 constants plus 13 context constants.
The comparison identified the additional generated `Dual.Feasible.eq_1`, owned
by the optimization-incidence test module. A separate current root check prints
its exact signature, proof, owner and permitted axioms with unchanged source and
compiled identities. Thus the original narrower 226-target tally remains an
attributed historical scope, with one additional C15 generated constant now
explicitly checked. Neither a namespace nor a source-header filter alone is
claimed exhaustive across whole compiled owners. Root's first artifact inspection
failed because it assumed every reviewer output passed; the separate successful
inspection preserves and correctly classifies the negative coverage diagnostic.
The Windows wildcard search failure and the original startup failure also remain
attributed separately; none establishes a source absence or mathematical defect.

S05-C is independently assessed at review time for mathematical/readiness and
reconciliation/finalization-contract readiness. Root now performs original-report
reconciliation and owning editorial finalization, then obtains final applicability,
F and supported closure. Those acts are not falsely attributed to the reviewer.
Only ten owning Markdown files differ from R; all Lean/tests, explicit dependency/
configuration, Git HEAD/index and frozen normative bytes are identical. Fresh
current source/document/hygiene checks apply; successful fresh builds and exhaustive
audits stay source-bound applicable. No mathematical repair or extra review is
needed for this bounded editorial reconciliation. Only supported closure establishes
CC09/C15. Included files will remain unchanged after F; the private closure record
and user-facing result establish later completion of this provisional checkpoint.

Exact available root/helper/reviewer sources, outputs, scripts and attempts are
durably retained under `.pfr-review/setup/c15-s05-20261002/`, excluding manuscripts,
media and raw extracts. Cached builds, transparent anonymous elaboration versus
actual imported constants, fixed-scope source analysis and cooperative native
read-only/provenance limits persist. Requested reviewer Astra/ultra/no-parent-history
has unknown observable effective settings. No independent plan review, commit/push,
dependency/tooling change, new unowned advice or numbered Future Work Note is claimed.
C16 remains mapped and unstarted; its broader wrapper requires a separate approval.
