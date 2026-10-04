# PFR-C05 planning notes

These advisory notes accompany [proposed Draft revision 2](plans/pfr-c05-binary-input-lemma3.md).
The [current revision decisions](#draft-revision-2-selection-and-rationale) follow
the preserved planning and revision-1 review history below. The notes record
reasoning and attributed evidence, not approval or implementation. Proposed
acceptance criteria belong to the plan; prior review is specific to revision 1.

## Startup and prerequisite reconciliation

The actual originating request is preserved in
`.pfr-review/setup/c05-planning-20260912/original-user-request.txt`.
It authorizes reviewer setup, planning, focused discovery probes and appropriate
planning documentation only. The root ran the installed read-only
`python -B tools/pfr_review/cli.py inspect`; its original JSON and source
hash inventory were captured before canonical planning edits. HEAD remains
`54c1714d1a9a891939d6c9f7d38c0d05896b2c75`; inherited C02-C04 changes include
untracked maintained Lean sources, plans and review tools. They are preserved.
LeanInfoTheory v0.1.0 and the Lean/mathlib v4.33.1 pins are unchanged and clean.

A bounded read-only helper inspected original production records without
opening a cross-parent session or changing durable state. All C02/C03/C04
steps (8/7/6) are complete; all 21 original step reports are classified VALID
and explicitly reconciled, with satisfied required criteria. There is no
active step, pause/cancellation, external blocker or decision obligation.
The two historical documentation findings have resolved histories; C04 has
no finding. This is prerequisite evidence inspection, not a new independent
mathematical or plan review.

| Chunk | Final closure | Final source F | Explicit final-report reconciliation |
| --- | --- | --- | --- |
| C02 S08 | `5a59434952e2e5776a0f29166b957a7eb389eccae723552944a671ec9ee684e0` | `17f766b119808a26d4572c94f5ca08ff9b1e19c6a3e09cba77c9f1a95a9d76b2` | `ab616dd6fdc96d9dc9af10ca4e95bb18a981903da6de1af63c78f8ad78c29431` |
| C03 S07 | `8a0d64e10a0a823477ab423f0e653149191afbc110c11863ef59164493a103d1` | `778463340fef9ba5a7b7296f50349e600c1c1d9c3040309deac6411749fd9f17` | `94af5a12022657b5dd47aed94e6c0034ed2970312007c98f9a4376799191b199` |
| C04 S06 | `259c743e6d15342685a85d24c23786f4c85a20e4c04b64f57adf0edf861a44f0` | `45c763da2fe0b185801b43cd453384d0d359b7fa63ccefc0620574d635c14350` | `ac057a2500735f804905fe83e3456742f456717aed967e0b916419e8fc71a906` |

Objects reside under the respective
`.pfr-review/chunks/PFR-C0N/execution/durable/objects/` directories.
The C04 original cumulative report SHA-256 is
`1888bc12a4df623af08f26aa8b81e769eaa83a65634459ba534241941f35b87d`.
Original object bytes/hash links, reports, reconciliations and final evidence
were inspected. These cooperative records are not authenticated native
transport or independent Lean proof certificates.

All 91 real C04 F files, its derived environment/Git facts and eighteen
supplemental dependency hashes matched at startup (108 unique real files
across the two source inventories). C02 matched 63/71 real F files and C03
64/71; differences are later documented root integrations and current-context
Markdown. Their semantic/test/dependency files and closed plans remain exact.
The detailed audit is temporarily retained under
`tmp/c05-planning-prerequisites/`.

C04's frozen plan, implementation notes and log entry 67 correctly recorded
pre-F readiness at their capture time. Subsequent durable S06 closure resolves
completion; those original records are not edited. Current summary/map and
reader-facing status are normalized to C04 complete in this planning change.

## Persistent reviewer binding

No C05 binding existed. The exact user instruction and neutral bootstrap intent
were preserved before the native creation call. The requested profile was
`model="gpt-6-astra"`, `reasoning_effort="ultra"`, `fork_turns="none"`.
The full observed creation result was exactly
`{"task_name":"/root/pfr_c05_reviewer"}`. Installed `bind` succeeded, retaining
parent task `01a096ae-bb53-7ef3-a819-4a3c6b1a1066` separately from role `/root`.

The exclusive binding is `.pfr-review/chunks/PFR-C05/binding.json`.
Original request, bootstrap intent, creation result, bind packet/result and
native readiness event are in `.pfr-review/setup/c05-planning-20260912/`.
References explicitly say “local capture” where the runtime exposed no
backend event ID. No prior chunk or diagnostic reviewer was transferred.

The readiness event reports no review or source inspection. Effective model,
reasoning effort and history settings are not independently observable and
remain unknown. The reviewer received no implementation conversation, plan,
self-review conclusion or sibling solution and was instructed to remain
read-only, not delegate, and wait for an exact request. Read-only instructions
are not OS isolation: the parent has danger-full-access/never approval settings
and native children inherit parent permissions, consistent with the
[official OpenAI Subagents documentation](https://learn.chatgpt.com/docs/agent-configuration/subagents)
consulted on 2026-09-12. The native schema provides the requested settings;
the creation response provides identity only.

No plan-review or execution session is open. A readiness acknowledgement is
not independent plan review. Discovery/prerequisite helpers are planning
support and are not the bound reviewer or acceptance authorities.

## Manuscript observations and proposed interpretation

The root freshly checked both exact hashes/page counts recorded in the plan,
extracted and visually inspected ISIT p. 2 and extended v16 pp. 12-14.
Only the relevant binary-input argument and Lemma 3 proof were consulted;
neighboring completed material and Appendix B were not reassigned to C05.
The binaries remain in their designated external local locations; extracts
and renders remain ignored under `tmp/c05-planning/references/`.

The exact local sources are:

- `C:/Users/coban/Desktop/On perfect functional representations/my paper/ISIT_2026__On_perfect_functional_representations___final_manuscript_ (3).pdf`;
- `C:/Users/coban/Downloads/On_perfect_functional_representation__Extended_version_ (16).pdf`.

ISIT II begins by identifying alphabets with supports. Its II-C maximum and
equality claims therefore implicitly have both binary input probabilities
positive. The proposed formal contract preserves that interpretation for the
ambient intrinsic-channel iff while proving the bound and construction under
arbitrary priors. For a point prior the objective is H(Y), regardless of the
unused row, because H(X)=0. This extension is justified separately; it is not
an assertion that the degenerate pair determines the ambient channel.

The support-subtype alternative remains legitimate but unnecessary for this
contract. C02 already constructs the support prior and proves the joint-law
inclusion bridge. Extending the quantitative theorem to any ambient input
alphabet with support cardinality two would add finite subtype enumeration,
input-information transport and a singleton-support convention for r. The
plan recommends explicit full support for the ambient binary iff and avoids
that extra theorem family. It does not restrict the other hypotheses globally.

The extended source supplies three additional formal boundaries:

1. The A/B/C partition in (112)-(114) covers active outputs; a both-zero
   ambient symbol is a fourth null case. Common positive mass produces only
   a constant vector; exclusive output mass reveals the input. C04's exact
   maximal-coupling support and endpoints already implement the needed
   probability structure, including zero and one overlap.
2. The normalized component distributions (118)-(120) are explanatory
   intermediates. A proved singular atom-formula bridge to (121) preserves
   their mixture's meaning without normalizing zero mass or rebuilding C04.
3. The conditional entropy assertion (153) is meaningful on supported vector
   fibers. Null fibers are discarded by their zero weight using the pinned
   explicit convention. The maximum/minimum prose (155)-(163) is a finite
   universal bound plus an actual attaining law, not an unproved optimizer.

The map records these dispositions in OM-063-OM-067 and preserves related
earlier records. Extended-only algorithmic, later matrix and other cited
results remain outside scope. No numbered Future Work Note is needed.

## Pinned reuse search and advisory proof routes

The API helper read actual local source and pinned
`docs/api-documentation.md`, `docs/v0.1-public-api.md` and its JSON manifest,
plus the website declaration index, theorem highlights, module guide and
relevant mathlib PMF/Fin/Fintype source. No external formalization was used.
The plan's reuse table lists existing declaration families; the final probe
logs distinguish verified signatures from proposed C05 statements.

**Binary representation.** Use `finTwoArrowEquiv beta` and PMF map composition.
The inverse's 0/1 coordinates reduce to the ordered pair coordinates. This
verifies the intended coordinate convention and avoids a custom vector type.
Use `Fintype.equivFinOfCardEq` only in noncomputable contexts as necessary.

**Singular posterior.** For the vector law q from C04, apply
`condFstGivenSndChannel` to `q.map (fun w => (w, w i))`. Pick row 0's posterior
when its output mass is nonzero and row 1's otherwise. On shared positive
singular outputs, C04's off-diagonal support criterion forces the same constant
vector in both fibers. On exclusive outputs only the active row needs a
nonzero factorization. On a both-zero output, the pinned first-marginal fallback
is q itself. This avoids gratuitous Nonempty-beta/default-vector hypotheses.
The equality of these conditional laws and coordinate factorizations remains
a C05 proof obligation; no such theorem was proved during planning.

**Entropy.** The pinned finite weighted conditional-entropy identity is
`condEntropy_eq_sum_sndMarginal_mul_condEntropyFstGivenSnd` in
`LeanInfoTheory.Shannon.SemanticBridge.Conditional`. Its null/nonzero fiber
lemmas and `entropy_map_injective`, `entropy_pure` supply the analytic content.
The binary evaluation map is constant or injective. The remaining local work
is identifying its conditional law and regrouping the finite weights into
C04 mismatch. No new generic conditional-entropy theory is proposed.

**Bound and equality.** Full-support canonicalization uses C02's already
proved information preservation and row cancellation. A nonfull binary PMF
has singleton support, hence is pure; use the existing H(X)=0 and ordinary
mutual-information upper bound. This avoids arbitrary law restriction or
completion of missing decoder rows. Information attainment then combines C04
with the new entropy identity. C01 Equation (3) gives I(X;Y) ≤ rH(X).
For a singular channel, C02 supplies a perfect pair and the universal bound
gives the reverse inequality. Conversely, equality makes the attaining
representation perfect; C02's full-support pair/channel equivalence and C03
necessity give singularity. There is no circular dependence on Lemma 3 and
no need for a new strict-concavity equality theorem.

**Transport.** There are no verified `entropyOf_map`, `mutualInfoOf_map` or
`condEntropyOf_map` names. The existing definitions plus `PMF.map_comp` provide
the needed pushforward transport directly. That routine discovery does not
justify new generic public aliases or a discoverability-log entry. Keep
production imports focused; the optional FiniteCouplingDecoding/Fano surface
is not needed for mismatch.toReal.

## Draft self-review and separate reassessment

The original draft before this pass is retained as
`.pfr-review/setup/c05-planning-20260912/draft-before-self-review.md`.
This is the implementer's contextual critique, not independent plan review.

| ID | Original recommendation and evidence | Materiality / confidence |
| --- | --- | --- |
| C05-PLAN-SR01 | Section 3.2 requires a total posterior but leaves the null-output fallback implicit. Record the pinned q fallback explicitly so later work does not add a global Nonempty-beta hypothesis or an unjustified conditional law. Evidence: the inspected total-posterior source and C04 both-zero support case. | Optional clarification / high |
| C05-PLAN-SR02 | R17 promises information-objective invariance under a common output injection, but Section 3.5 primarily specifies input transport. Make R17's consumer contract explicit and restrict it to given laws on a common subtype; avoid suggesting that C04 already constructs ambient restrictions. | Required acceptance clarity / high |
| C05-PLAN-SR03 | The source/default build verifies prerequisites, whereas the proposed API table still awaits clean final probe logs. Preserve the initial failed inventory and remove guessed identifiers from the successful inventory; distinguish actual compile evidence from source inspection in the final notes. | Required evidence accuracy / high |

Separate reassessment accepted SR01: it is a justified proof-route clarification,
not a mathematical assumption or normative API addition. Accepted SR02: its
existing R17 obligation should have a precise statement in Section 3.5; no
new theorem family is required. Accepted SR03: initial exploratory errors
remain negative evidence; only a successful final probe supports a claim of
compiling verification. None of these decisions authorizes implementation,
independent review or dependency/workflow changes.

The whole draft was also checked for dependency cycles, full-support creep,
finite source/auxiliary universe conflation, null fiber assumptions, maximum
attainment versus mismatch attainment, combined Lemma 2 coverage, scalar
normalization, omission completeness and future-event review criteria. The
S07 report is explicitly assessed before later reconciliation/F/closure;
the plan does not ask the reviewer to certify those future events.

## Planning validation and remaining uncertainty

Fresh prerequisite focused/regression and default builds passed, with 2770 and
2761 jobs respectively and no diagnostics. The placeholder scan returned no
matches. These were executed by the prerequisite helper; they establish the
current dependency surface, not the proposed C05 mathematics.

Two ignored focused API probes check existing declarations, elementary finite
equivalence consumers and direct pushforward transport. The initial inventory
had three nonexistent convenience-name checks and a noncomputable-definition
error; its exact original source/log are retained. They are not passing
evidence. Final corrected probe and planning hygiene results are recorded
below when available.

The unproved work is explicitly scoped: binary conditional-law/support
comparison, the weighted entropy calculation, and semantic transport. Source
search and probes support feasible routes but do not certify these future
proofs. No unresolved mathematical interpretation needs a separate choice
beyond approval or revision of the proposed full-support contract. There is
no claim of independent plan acceptance.

### Final compiling evidence

Both final probes passed with native exit 0 and no warnings/errors:

- `lake env lean tmp/c05-planning-api/Inventory.lean`;
- `lake env lean tmp/c05-planning-api/PosteriorAndTransport.lean`.

Together they verify 76 `#check` commands, four elementary
equivalence/cardinality consumers and three direct pushforward consumers.
They establish the existing API route, not the C05 conditional-law,
singularity, entropy or optimum theorems. Focused imports are
`PerfectFunctionalRepresentations.Semantics.Singularity`,
`PerfectFunctionalRepresentations.Probability.FiniteCoupling`,
`Mathlib.Logic.Equiv.Fin.Basic`, plus `Mathlib.Data.Fintype.EquivFin` in the
inventory probe. The initial source/log remains separately retained as
`Inventory.initial.lean`/`Inventory.initial.log`; no negative result was
rewritten as success.

Discovery documentation lives in the pinned `docs/` and `home_page/`
directories, including `home_page/docs/declaration_index.json` and
`home_page/module-guide.html`; “website” above describes their role, not a
directory named `website`.

| Evidence file | SHA-256 |
| --- | --- |
| `tmp/c05-planning-api/Inventory.lean` | `1a626630568d6fe2cc24bcd24c59a05d396d5cdca4c2ce4903b4904e9bca26de` |
| `tmp/c05-planning-api/Inventory.log` | `88d0f02983790cdbc7ecd6b4920a80d79ff1dbef9507adeb893643da0af4c1ea` |
| `tmp/c05-planning-api/PosteriorAndTransport.lean` | `7108084dbca520a35c5e12748a3ca6af6dc4026dd73d181d87db3021cf1eb9c7` |
| `tmp/c05-planning-api/PosteriorAndTransport.log` | `dd0121ea760c43b14456052a3000e5821bb758b89e32666365399c0d45f800b1` |
| `tmp/c05-planning-prerequisites/audit.json` | `1ac1036808c05394a21fac4df616d0cf96d3aed45225a29a0a78bd90810e709f` |
| `tmp/c05-planning-prerequisites/build-results.json` | `94831d770c55da43c9b87e561595f82d173e436e9c681833bedb597071ecad03` |

The helper's ancillary full import-header traversal does not strip all block
comments and produced false unresolved module words. It remains limited
diagnostic evidence, not an import-closure certificate. Actual direct-root
and local-module imports plus successful compiler builds establish the
bounded optional-decoder separation needed for planning.

SR01/SR02 were applied to the proposed contract. SR03 is resolved by the two
clean final probe results while retaining the original negative evidence.
No independent review was dispatched. The requested profile remains recorded
separately from unknown effective settings.

### Final planning hygiene

The parent checked the final planning diff against startup, validated local
document-link targets and the seven-step/21-criterion/18-regression/ten-outcome
allocation, and verified all 67 stable omission IDs. The placeholder scan
has no matches and `git diff --check` passes. Only six existing current-context
documents changed, and the proposed plan and these notes are the only new
maintained files. All inherited mathematical sources, configurations,
dependency pins, closed chunk plans and review tools are byte-identical to
startup. Reference extracts, probes and the private reviewer records remain
ignored; no generated media or build artifact entered maintained source.

The binding retains the actual parent/reviewer and requested profile, with
unknown effective settings, and there is no C05 review/execution session.
The earlier and final hygiene captures are retained separately under
`.pfr-review/setup/c05-planning-20260912/`; final source identity and commands
are in `final-planning-hygiene-r2.json`. Mathematical builds remain applicable
because no Lean/configuration/dependency bytes changed during planning.

## Requested plan review and suggestions - 2026-09-12

The review began on 2026-09-12; format recovery and final reconciliation
completed on 2026-09-13 in Europe/Zurich. Session identifiers retain the start date.

The lead requested review and suggestions, explicitly saying not to update the
plan, and subsequently confirmed the task title PFR-C05. The exact proposed
Draft revision 1 remains byte-identical, SHA-256
`9c1b2b217762a58069522df58b9b46b1a85281e3f631b80693afa5cc72ee6db2`.
Its pre-review status block and all earlier planning records remain historical;
this section records the later review without revising or approving the contract.

The parent first retained a contextual critique and separate reassessment. The
same bound `/root/pfr_c05_reviewer` then received a neutral source-bound request,
without parent suggestions, planning-note self-review or sibling solutions.
The independent assessment found all six planning criteria satisfied, no material
defect, and one optional regression suggestion. The parent critically reconciled
every criterion and finding; this establishes plan-review completion only.

| Criterion | Original assessment and parent reconciliation |
| --- | --- |
| C05-PR01 | Satisfied; exact manuscript allocation, source departures, finite-auxiliary interpretation and closed-prerequisite boundary are adequate. |
| C05-PR02 | Satisfied; vector/coupling orientation, prior-free common posterior and combined Lemma 2 are coherent. |
| C05-PR03 | Satisfied; the arbitrary-prior entropy identity, finite-auxiliary bound and actual information-attaining witness have feasible contracts. |
| C05-PR04 | Satisfied; full support is confined to ambient-channel recovery, with the degenerate-prior guard and correct law transport. |
| C05-PR05 | Satisfied on inspected source signatures, public imports and the prerequisite build; stopped signature probes supply no passing evidence. |
| C05-PR06 | Satisfied; retain the seven-step structure, cumulative criteria and explicit post-report reconciliation/finalization duties. |

### Suggestions retained without applying them

All suggestions below are optional and nonmaterial. They do not alter mathematical
intent, acceptance, design-gate status or omission dispositions. No additional
theorem family, implementation step or numbered Future Work Note is opened.

| Stable ID / attribution | Recommendation and rationale | Disposition |
| --- | --- | --- |
| `pfr-finding:c05-r1-001`, independent reviewer | Strengthen R04 with a singular fixture whose exclusive-output posterior has multiple atoms. The proposed rows on Fin 6 are `(1/4,3/8,3/8,0,0,0)` and `(1/4,0,0,1/4,1/2,0)`. They combine shared mass, nontrivial exclusive posteriors and an unused output. | Recommend the coverage property; exact fixture choice may remain implementation advice. Parent independently verified normalization, marginals and all 432 factorization atom equations. The larger fixture is justified for this focused consumer. |
| `pfr-finding:C05-PARENT-PR02`, parent | In Sections 3.5/S05, list the required intrinsic, pair-law and common-base theorem forms and their hypotheses. Make prior mapping through `e` and channel precomposition through `e.symm` explicit. | Recommend a compact interface table while keeping Lean names flexible. Existing wording is adequate mathematically; no expansion of the theorem family is intended. |
| `pfr-finding:C05-PARENT-PR03`, parent | Make R12's intermediate-TV example nonsingular, also reusable for R14. Rows `(3/4,1/4)` and `(1/4,3/4)` with prior `(1/3,2/3)` give TV `1/2` and output marginal `(5/12,7/12)`. | Recommend. Exact coupling atoms are `(0,0)=1/4`, `(0,1)=1/2`, `(1,1)=1/4`. This checks general attainment independently of singular shared-fiber collapse and complements the reviewer's R04 suggestion. |
| `pfr-finding:C05-PARENT-PR01`, parent | Keep the pinned null-fiber fallback `q` as recommended proof guidance; if revised, require correct total fibers and no extra hypotheses normatively. | Lower-priority optional flexibility. C02 `coordinateFactorization_congr_posterior` permits changes at globally unused outputs. The fallback itself is sound; this refines, rather than erases, the earlier SR01 drafting rationale. |
| `pfr-finding:C05-PARENT-PR04`, parent | Assign the empty-input/cardinality and impossible empty-output/PMF checks at the end of Section 7 to existing S01/S02 consumers. | Minor organization; keep R01-R18 and the existing cumulative requirement. |

The parent recommends retaining the support boundary, actual finite information
attainment, unrestricted source spaces, reuse of C01-C04, and the seven-step order.
The two suggested fixtures are exact finite-model checks, not Lean proofs.

### Original reports, format correction and evidence limits

Private session `plan-r1-20260912` retained the exact initial request, uncertain
empty dispatch receipt, complete native report and separate report-backed delivery.
The installed parser rejected the report because `inspected_source` was an array
where it requires a string. Its cited inconclusive probe also belonged in limitations
and verification rather than a satisfied criterion's passing-evidence list. The
rendered schema did not state the first field type. No original content was rewritten.

The PLAN adapter allows one request per session and binds delivery to original bytes.
A linked format-only session, `plan-r1-format-20260912`, continued the same explicit
review request with the same reviewer and unchanged plan/criteria/source. The reviewer
supplied a complete schema-correct report; original findings, criterion assessments
and negative checks remain preserved. This was formatting recovery, not a new plan
revision, replacement reviewer, workflow change or source of execution authority.

Valid report: `54cc9725b4eed5f98fef51be6d2c3ad36c93c3807348429d23b73c47dc851e7d`.
Explicit reconciliation: `f222eb38793f15e2f05a6a7e5546b818e041e8aa69fc9d40e58be5861256f6b4`.
Installed result: `plan_approved: false`, `AWAITING_EXPLICIT_LEAD_APPROVAL`.
Original events, requests, format rejection, exact parent decisions and checks live
under `.pfr-review/setup/c05-plan-review-r1-20260912/` and its `format-retry/` directory.

The reviewer freshly authenticated both manuscript hashes/page counts and inspected
the scoped rendered pages; compared 27 relevant source hashes at entry and exit;
inspected the actual local and pinned declarations/public imports; passed the root
plus seven prerequisite regression targets (2774 jobs); and found no placeholders.
Its first PDF extraction failed through cp1252 stdout, followed by a successful UTF-8
retry and visual inspection. Two optional declaration probes produced no output
within their bounds and were stopped, both exit 1. These remain FAIL/inconclusive,
not compiler signature successes or evidence of missing declarations. Earlier clean
planning probes are separately attributed history, not fresh reviewer checks.

The parent rechecked its nonsingular fixture and independently verified the reviewer's
singular fixture with exact rational arithmetic. All 76 startup maintained files were
byte-identical before report receipt. Only current-context review notes/status prose
change afterward; no Lean, dependency, configuration, closed plan or C05-plan bytes
change. Final identity/diff/placeholder/artifact evidence belongs to the private
`final-review-hygiene.json` capture. Requested reviewer settings remain separate from
unknown effective settings; read-only behavior is cooperative rather than OS isolation.
No C05 theorem, mathematical execution session, commit or push is part of this review.

## Draft revision 2 selection and rationale

**2026-09-13.** The lead authorized selecting the best combination of the earlier
suggestions, including leaving the draft unchanged if warranted. The selected
revision incorporates all seven recommendations in bounded form because each
improves a distinct signature, proof-choice or validation boundary. Exact fixture
coordinates remain advisory, and the interface table requires usable results
without a duplicate theorem family. This is a proposed-plan update, not execution
approval or a newly requested independent review.

The user-supplied General Assistant report is an advisory second opinion, not the
bound reviewer's original report or an installed acceptance. It recommends the
unseen-row regression and explicit finite-output assumption, finds no blocking
issue, and supports the existing hypothesis allocation, information attainment,
noncircular equality route, scope restraint and S06/S07 sequencing. The parent
agrees with those assessments after checking the relevant local definitions and
test pattern. Its reported build/manuscript checks remain attributed claims; its
stopped probes remain inconclusive. Local labels `C05-GA-01/02` below identify
these two suggestions for reconciliation only, not native reviewer findings.

| Suggestion | Selected disposition and reason |
| --- | --- |
| Parent `C05-PARENT-PR02`: explicit semantic interfaces | Adopt in Section 3.5. State the input/prior/pair-law transport and the five consumer interfaces, retaining the independent output branch of Lemma 2. Final Lean names and directly composable theorem packaging remain flexible; no general wrapper for every private entropy bridge is required. |
| Bound reviewer `pfr-finding:c05-r1-001`: nontrivial singular posterior | Adopt the coverage property in R04: an exclusive-output posterior has at least two positive vector atoms. Keep the reviewed Fin 6 coordinates advisory so a smaller equally effective consumer can be selected. |
| Parent `C05-PARENT-PR03`: nonsingular intermediate-TV attainment | Adopt in R12 with a nonuniform full-support prior. The fixture may also supply R14. It exercises general information attainment independently of the singular posterior collapse. |
| Parent `C05-PARENT-PR01`: null-fiber proof flexibility | Adopt with a checked boundary: the total posterior and all positive-output factorizations remain required; q remains the recommended pinned fallback. Another globally-unused-output completion requires factorization preservation through the existing C02 theorem. This does not relax a mathematical hypothesis or change the pinned API's own convention. |
| Parent `C05-PARENT-PR04`: assign empty cases | Adopt in existing R02/R03 at S01. No new regression ID or later catch-all obligation is needed. |
| Advisory `C05-GA-01`: actual unseen-row bound regression | Adopt in R13. Require the structural representation, exact channel pair law, an actual unseen-coordinate discrepancy and application of the bound. R15 remains separate: it guards the ambient-channel equality converse. |
| Advisory `C05-GA-02`: finite-output notation | Adopt in Section 3.1 specifically for finiteTV/overlap. Preserve arbitrary-beta product/vector and structural coupling-law bridges, matching the actual definitions. |

The seven steps, all 21 step-criterion identifiers, R01-R18, ten completion
outcomes, exact manuscript anchors, optional-decoder import boundary and finite
auxiliary scope remain. The refinement selects more effective consumers within
the earlier regression allocation; it is not a claim that revision 1 failed its
review criteria. No new optimizer, ambient-input support-subtype family, theorem
chunk or numbered Future Work Note is opened. DG-04/DG-05 remain partially open.
OM-066 now distinguishes the required total posterior from its recommended null
completion; its source interpretation and omission rationale remain intact.

### Advisory fixture choices and source checks

R04 and R12 may use the exact finite models in the preceding review notes. Their
existing rational-check evidence is retained and is not a new Lean proof or rerun.
R04's Fin 6 example exercises both nontrivial exclusive posteriors and an unused
output; the required coverage property permits another suitable small fixture.
R12's rows `(3/4,1/4)` and `(1/4,3/4)`, prior `(1/3,2/3)`, and exact coupling
already provide the requested nonsingular intermediate-TV case.

For R13, a particularly small choice is input `Fin 2`, output `Bool`, and source
and auxiliary `Unit`. Use `p = PMF.pure 0`, rows `kappa 0 = PMF.pure false` and
`kappa 1 = PMF.pure true`, and actual variables X=0, Y=false, Z=(). The constant
false decoder is correct on the actual source; its vector law is concentrated
on the constant-false vector. Its unseen coordinate is `PMF.pure false`, unequal
to the specified row 1. Ambient TV is 1 while this decoder vector's mismatch is
0, making an illicit all-row-coupling inference visible. The information bound
still applies because H(p)=0. The actual C05 bound consumer is future S04 work;
no such Lean proof was implemented during this revision.

The read-only discovery helper and parent inspected C02's decoder-completion
regressions at `Tests/Semantics/Canonical.lean:334-417`. Their fixtures and helper
theorems are private; reuse the pattern and supported public APIs, not imports
of those private names or promotion of test machinery. The existing definitions
`IsCoupling`, `IsCanonicalCoupling` and `finTwoArrowEquiv` have no finite-beta
premise, whereas C04 places `[Fintype beta]` before `finiteTV` and `overlapMass`.
The parent also inspected C02 `coordinateFactorization_congr_posterior`, which
permits posterior changes only away from every row's support. These source
checks justify the drafting choices without implementing new mathematics.

### Revision provenance and validation

Reviewed revision 1 remains preserved with SHA-256
`9c1b2b217762a58069522df58b9b46b1a85281e3f631b80693afa5cc72ee6db2`.
The unchanged original review events, classification history and reconciliation
records remain under their existing sessions. Revision 2 SHA-256 is
`b78bb1063ac53de67d3e07e596db0c2d3598d9f5e6eff0175338e48437b60568`. New before-images, the user request, supplied advisory report,
selection evidence and final diff/checks live in
`.pfr-review/setup/c05-plan-revision2-20260913/`; this is a documentation capture,
not a new installed review or execution session.

The parent freshly ran `lake build`: Build completed successfully (2761 jobs).
This validates the unchanged prerequisite project, not the proposed C05 proofs.
Final hygiene checks compare all maintained files to the revision startup,
retain the seven-step/21-criterion/18-regression/ten-outcome allocation and all
67 omission IDs, check local links and diff whitespace, and scan for placeholders.
An initial diff-print attempt failed on Windows stdout encoding after successfully
saving its UTF-8 diff; the saved diff was then read successfully. That failed
display attempt is retained separately and is not passing build/proof evidence.
All Lean, dependency/configuration, prior closed plans and review-tool bytes
remain outside the change. No independent revision-2 assessment, approval,
implementation, commit or push is claimed.
