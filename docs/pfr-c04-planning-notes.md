# PFR-C04 planning notes

These advisory notes accompany [proposed Draft revision 2](plans/pfr-c04-finite-total-variation-maximal-coupling.md).
They record design rationale, planning evidence and subsequent review provenance.
They do not implement theorems or approve the plan. The proposed plan owns
acceptance criteria.

## Source and baseline observations

The exact six-page ISIT digest `48963AA5...E6ED1C4` and designated eighteen-page
extended version 16 digest `98636D4C...245B8F` were reverified. Full hashes and
anchors are in the plan. ISIT p. 2 II-C fixes half-L1 TV. The maximal-coupling
bound and attainment sentence are in extended Appendix A p. 14, (156)-(161),
not in the ISIT passage. Extended p. 12 (111)-(122) supplies the necessary
common/exclusive-mass construction context for the C05 handoff. The adjacent
canonical/conditional-entropy and singularity arguments remain C05. The
general all-atom construction is an explicit proof of the extended assertion
of attainment, rather than a displayed general formula copied from it.

At C04 startup, installed read-only `inspect` passed with the unchanged pins
and HEAD in the plan. A separate bounded read-only helper checked C03's
original records: S07 closure
`8a0d64e10a0a823477ab423f0e653149191afbc110c11863ef59164493a103d1`, F
`778463340fef9ba5a7b7296f50349e600c1c1d9c3040309deac6411749fd9f17`.
All seven step closures, original report, explicit reconciliation and satisfied
criteria remain valid, with no unfinished obligation. All 71 actual F files,
nine supplemental dependency files and environment/Git facts matched before
C04 document edits. This helper performed evidence inspection, not a new
mathematical review. Its supported session-load attempt correctly refused
`WRONG_ORIGINATING_PARENT`; it continued by reading original JSON and hashes,
without spoofing identity or modifying closed records.

C01/C02 remain historically complete. Relevant earlier Lean files match their
recorded source; root changes are the documented C02/C03 integrations. C04's
current-context normalization does not rewrite their certificates or the frozen
C03 plan. No semantic chunk is a mathematical prerequisite for C04.

Private startup evidence is under
`.pfr-review/setup/c04-planning-20260911/`; temporary probes and source extracts
are under ignored `tmp/codex-handoffs/pfr-c04-planning/`. Only this task's
planning documents and contextual edits belong to C04.

## Persistent reviewer setup

No C04 binding existed. The exact user request and neutral bootstrap intent
were preserved before creation. The native creation result was exactly
`{"task_name":"/root/pfr_c04_reviewer"}` and was saved in full. Installed
`bind` succeeded, preserving parent task
`01a09251-8d05-7961-a8e0-4993f061aa49` separately from native role `/root`.
The binding is `.pfr-review/chunks/PFR-C04/binding.json`; the setup output is
`.pfr-review/setup/c04-reviewer-binding-20260911.json`.

Requested profile: `gpt-6-astra`, `ultra`, `fork_turns: "none"`. Effective
settings remain unknown. The original readiness event is preserved. The
reviewer acknowledged readiness, reported no inspection/review, accepted
read-only/no-delegation instructions and did not independently verify its
effective profile. At setup it had received no plan, implementation conversation,
self-review findings or source-bound review request, and no C04 review/execution
session had opened. The later requested plan review is recorded below.
Discovery helpers are not the bound reviewer and their
outputs are not independent plan acceptance.

The cited [official subagent documentation](https://learn.chatgpt.com/docs/agent-configuration/subagents)
was consulted on 2026-09-11. Its inheritance rules support the installed
limitation: read-only instructions do not create OS isolation. The actual native
schema, not an inferred configuration, supplies the requested profile fields;
the return value exposes identity but not effective settings. No configuration
or workflow change was made.

## Construction route and proof risks

Prefer direct finite atoms: diagonal common mass plus the product of the two
residual masses divided by their common total. This yields an explicit law
using `PMF.ofFintype`, with no need to select normalized common/residual PMFs
at zero mass. The total residual mass is `d`, hence the single denominator
`d`. The two main proof branches are `d=0` and `d>0`; common mass zero gives
`d=1` and needs no singular division. Both branches must satisfy the same
all-atom contract. These are proposed proofs, not compiling target theorems.

First bound overlap by one and recover the two residual sums from
`(p y - min (p y) (q y)) + min (p y) (q y) = p y`. A useful generic
sum-to-subtraction route avoids assuming cancellation properties of ENNReal
that its truncated subtraction does not have. For positive finite `d`, summing
each residual row/column cancels only that nonzero finite denominator. At zero
residual mass, all residual atoms vanish and `p=q`; explicitly reduce the law
to the diagonal pushforward. Non-top proofs are needed before `toReal`, and
finiteness of an inverse must never be asserted at zero.

The pointwise residual product on the diagonal vanishes because one of the
two residuals is zero. This establishes the diagonal formula and support
classification. For an arbitrary coupling, bound a diagonal atom by each
existing marginal sum, sum the minimum bound, then use the agreement/mismatch
complement. The same exact identities give the Real theorem through the
existing conversion API. Half-L1 follows from scalar min/absolute-value
algebra plus normalization; no generic information-theory theorem is reproved.

The alternative normalized-mixture route is mathematically valid and supported
by existing PMF normalization/mixture APIs, but introduces more branches and
internal objects than the direct atom contract needs. It is not prohibited if
implementation evidence favors it; it must retain the same exact atoms and
endpoint contracts. No arbitrary normalizer/default may leak into the API.

Injective relabeling is included because C05 must tolerate unused output
symbols and finite support-type changes. Use existing map-at-image and
outside-range-zero lemmas; do not construct a second marginal API. The plan
requires transport of an attaining witness, not uniqueness or equality of
chosen maximal-coupling constructions. Shared equal masses yield exactly the
fiber concentration needed for C05's singular binary-input proof; no entropy
or perfectness theorem is smuggled into this probability module.

## Pinned reuse audit

The bounded discovery helper inspected LeanInfoTheory's `docs/v0.1-public-api.md`,
`docs/api-documentation.md`, source, `home_page/docs/declaration_index.json`,
`home_page/theorems.html` and `home_page/module-guide.html`. It searched pinned
mathlib Probability/MeasureTheory and exact PMF/ENNReal declaration locations.
Representative local search terms were `coupl`, `total.?variation`,
`maximal.?coupl`, `overlap`, `tvDist`, `variationDist` and `variationDistance`.
No dedicated finite-PMF TV/maximal-coupling API was found. Existing signed or
vector measure total variation does not itself provide this finite contract.
No external information-theory formalization repository was consulted.

`LeanInfoTheory.Shannon.InfoMeasures` already supplies marginals and their
ENNReal finite sums and imports `Probability.Finite` transitively via entropy.
That supported dependency closure is acceptable; C04 need not duplicate the
marginals to eliminate the existing entropy import. `SemanticBridge.FiniteSums`
has supported Real marginal identities, which should be reused if needed;
otherwise use the exact sums and elementary conversion lemmas with a lighter
import. `Probability.Finite` supplies finite real mass sums and injective-map
mass preservation. Normalization, mixtures and products were inspected as
alternative proof tools, not a reason to add unused imports.

The detailed temporary discovery report retains searched source locations,
candidate signatures and exact compiling-probe outcomes. Both final probes
passed; the summary and hashes below distinguish those results from the
earlier stopped attempts. Candidate checks alone do not prove normalization,
maximality, the TV identities or any C04 step.

No discoverability-log entry is justified by this routine successful search
and confirmation of the expected gap. Future downstream proof pressure may
justify feedback or an upstream proposal under separate review.

## Draft self-review and separate reassessment

The parent inspected the initial draft without delegating plan review or
asking the bound reviewer for an opinion. The following initial critique was
retained before corrections:

- **C04-DRAFT-01:** The reuse table contained a proposed real-map helper name
  that was not found by direct source search. This is a current-draft evidence
  error, not a dependency defect (material documentation accuracy; high
  confidence). Remove it and use the verified exact map-at-image theorem plus
  `toReal` congruence; do not promote a guessed name to public API evidence.
- **C04-DRAFT-02:** The mismatch event boundary referred generally to an event
  API. Specify its ENNReal `toOuterMeasure` meaning and retain a concrete
  finite-event regression (clarity recommendation; high confidence).
- **C04-DRAFT-03:** Source attribution and status maintenance must distinguish
  the extended attainment argument from ISIT, and C03's durable closure from
  preclosure prose. The draft already identifies both; verify the owning map,
  summary, scope/roadmap and log carry the same correction (material coverage
  accuracy; high confidence).

Separate reassessment: accept 01 and 02 as bounded corrections; accept 03 as
the already authorized contextual-document obligation. Keep six steps, the
half-L1 definition, exact all-atom witness, injective transport and explicit
C05 non-goals. Do not add public normalized-component structures, a full TV
metric theory or a separate named theorem for every fixture. No unresolved
substantive mathematical interpretation requires a lead decision. Proof
engineering and import choices remain provisional within the precise contracts.

A later discovery added **C04-DRAFT-04** before the final draft: the supported
`Shannon.Fano` module already defines `decodingErrorProbability`; decoder `id`
is precisely mismatch. A new unrelated Real mismatch definition would obscure
reuse (material API ownership; high confidence from inspected source).
Separate reassessment: retain the new exact ENNReal event mass, write core Real
theorems using its `toReal`, and add one focused, separately importable
`FiniteCouplingDecoding` bridge to the existing Real decoder-error API. Fano
imports `SemanticBridge.Theorems`, which imports KL, so keep that bridge out of
the core and root. Reuse Fano's existing sum/range lemmas for its Real-facing
consumers. This is an evidence-driven import boundary, not new C05 semantics.

The final parent source audit also corrected **C04-DRAFT-05**: the initial
reuse table attributed `indepProd` to `InfoMeasures`; its actual owner is
`SemanticBridge.Product`. Separate reassessment accepts the location correction
and a justified Product import by S03 to state the promised independent-product
endpoint using the existing construction. Product imports measure-product
infrastructure but no KL module. The lightweight-core requirement excludes
Fano/KL and unrelated semantic/matrix work, not this necessary existing product
law. No source-discovered name is called compiler-verified until its probe returns.

## Planning validation observations

The parent's fresh `lake build` completed successfully with 2760 jobs. The
required maintained-Lean placeholder scan returned no matches (exit 1),
`git diff --check` passed with only existing CRLF notices, all selected local
documentation links resolve, and the plan has six ordered step IDs, eighteen
unique step criteria, fifteen regression rows and eight completion criteria.
At initial planning completion, the C04 binding matched its original
parent/reviewer and had no plan-review or execution session. No tracked generated PDF/image/Lean build artifact is
present. Compared with the startup capture, exactly six inherited documents
change and two planning documents are new; the other 59 startup files remain
unchanged, including all Lean, dependency configuration and closed plans.

Compiler-probe latency was substantial. Observed facts include concurrent
unrelated Lean compilation processes, low resident memory relative to each
probe's committed memory, slow accumulating CPU time and nonzero system paging.
A later reading also showed over 10 GiB available physical memory, so the
sole cause is not established. Only command-line-verified helper-owned probes
were stopped; their original inputs remain and are not passing evidence. The
corrected consolidated probe and separate Product probe both completed. The
`-j 1` runtime option does not change repository/toolchain configuration.

### Final compiling-probe results

Both commands below completed on 2026-09-12 (Europe/Zurich) with actual native
exit code **0**, no errors and no warnings. The parent read both complete
logs and exit files. Paths are relative to the repository; all files remain
in ignored `tmp/codex-handoffs/pfr-c04-planning/reuse-agent/`.

```text
lake env lean -j 1 tmp/codex-handoffs/pfr-c04-planning/reuse-agent/RemainingAPI.lean
lake env lean -j 1 tmp/codex-handoffs/pfr-c04-planning/reuse-agent/ProductAPI.lean
```

| Probe | Verified import and checks | Result |
| --- | --- | --- |
| `RemainingAPI.lean` | `Shannon.Fano`, `SemanticBridge.FiniteSums` and mathlib's unbundled absolute-value module; 85 `#check` commands and three `#print` commands covering retained PMF construction, sums, marginals, ENNReal arithmetic, map/relabeling, events, empty-alphabet elimination and identity-decoder applications | PASS; `RemainingAPI.log`, `RemainingAPI.exit.txt` |
| `ProductAPI.lean` | Exact `SemanticBridge.Product` import; four `#check` commands and one `#print` for `indepProd`, its atoms and both marginals | PASS; `ProductAPI.log`, `ProductAPI.exit.txt` |

SHA-256 evidence identities:

| File | SHA-256 |
| --- | --- |
| `RemainingAPI.lean` | `023c7cbc783dcbb69cbb5fe43bf06111ff1d9f078dcf224336a4071ba64e4683` |
| `RemainingAPI.log` | `ee0c4470ae06a7eb6ad88a8da0df3029aee6e8d0ecd0b40c5be88217e32f8c4e` |
| `ProductAPI.lean` | `4888bfe1476c34650fb1c813304c83169809a71e8d613068a9cbe6d063639d00` |
| `ProductAPI.log` | `ab4132900ace3c535490012fbbf9dac4ede0ff7cd3bcb9a553b0734acc4a3232` |

The output confirms the finite hypotheses on marginal/event sums, explicit
non-top assumptions on `toReal_min` and order/equality reflection, and both
nonzero/non-top obligations on residual division cancellation. The generic
`Finset.sum_tsub_distrib` signature requires `AddLeftReflectLE`; it is not
evidence for that instance on ENNReal. The proposed residual-sum route instead
uses the checked `tsub_add_min`, `tsub_min` and
`ENNReal.eq_sub_of_add_eq'`. The Real half-L1 route can use the checked
`two_nsmul_inf_eq_add_sub_abs_sub`. No source-guessed name remains in the plan's
verified reuse table. `PMF.normalize` was checked; the unused `binaryMixture`
alternative has only source/public-inventory evidence and is not included in
the compiler-verified claims.

The probes do not establish C04's new identities, support characterization or
normalization proof. Those remain proposed step outcomes. Planning verification
is complete; the remaining uncertainties are the proof-engineering risks
above, with no unresolved substantive mathematical decision identified.

## Requested plan review and recommendations — 2026-09-12

The lead requested review and suggestions after naming this task PFR-C04. The
parent retained its initial critique and a separate reassessment before the
neutral independent dispatch. The same bound reviewer assessed Draft revision 1
in session `plan-r1-20260912`. Its exact reviewed full-file SHA-256 was
`80d7efbb68a9892f2bf494a99f7a9bf551d335131f27b0d2de0ecd2403a83262`;
source reference `35c4663e5638237adfd7acc8c5919164273f7cfa888220ad98339176427355ba`.
The complete rendered request was delivered through one explicitly identified,
hash-verified request artifact, with no access to sibling private records or
parent critiques. The empty immediate native result remains recorded as
UNCERTAIN; separate original-report-backed confirmation established delivery.

The original full native report was preserved and classified VALID. All six
criteria C04-PR01 through C04-PR06 are SATISFIED as planning criteria. There is
one LOW-severity, HIGH-confidence nonmaterial finding and no material defect.
The parent agrees with the six assessments after checking their scope and
evidence; no criterion is treated as a proof of a proposed C04 theorem.

- Original report SHA-256: `7a0e805afcd8fef3e45cfd38019e25a2728db04153ac0da505c7134f19869571`.
- Valid report record: `494fb6cd012dcfe197b6862256110577a25191612a37436e4679a87762593f2d`.
- Explicit reconciliation: `3fb32e06f704db2a8a186de9bd205c03b871dfde870eeac8a96b6d296d480399`.
- Original events, parent critique and detailed decisions are retained under
  `.pfr-review/setup/c04-plan-review-r1-20260912/`; session records remain under
  `.pfr-review/chunks/PFR-C04/plan-r1-20260912/`.

### Recommended refinements, not applied to the mathematical contract

This subsection records the disposition at revision-1 review completion;
the later revision-2 decision below supersedes its pending recommendations.

1. **Extend R09 with two residual atoms on each coordinate.** Independent
   finding `pfr-finding:PFR-C04-plan-r1-reviewer-01` matches the parent's
   pre-dispatch recommendation `pfr-finding:C04-PARENT-PR02`. Existing interior
   examples have one deficit atom. The reviewer proposes a valid symmetric
   Fin 4 fixture with overlap/TV one half. Accept the purpose, but prefer one
   unequal-weight fixture for more diagnostic coverage:
   `p=(1/2,1/4,1/8,1/8)`, `q=(1/4,1/8,1/4,3/8)`. Its overlap is `5/8`, TV is
   `3/8`, and its residual atoms are `(0,2)=1/12`, `(0,3)=1/6`, `(1,2)=1/24`,
   `(1,3)=1/12`. The diagonal minima are `1/4,1/8,1/8,1/8`; all other atoms
   vanish. Parent exact-fraction checks verified normalization, marginals and
   mismatch. Retain the current zero-mass fixture and extend R09 without a new
   public API, step or regression ID. This is an enhancement, not a criterion gap.
2. **Clarify the import promise.** Parent `pfr-finding:C04-PARENT-PR01` concerns
   wording in the plan/notes: the *new coupling core* should exclude Fano/KL,
   and the root should gain no decoding-bridge import. The existing root already
   reaches KL through `FunctionalRepresentation -> Markov -> Independence ->
   Theorems -> KL`. Parent source inspection verified this chain; the reviewer
   also qualifies its import assessment by the existing root's broader closure.
   Earlier shorthand about keeping KL outside the root must not be read as a
   claim that this existing closure is KL-free or a request to remove it.
3. **Name the common carrier in R12.** Parent `pfr-finding:C04-PARENT-PR03`
   recommends a single finite subtype carrying both laws, for example the union
   of their supports, or starting with two laws on the same finite subtype.
   Transport both through the same inclusion. This clarifies the existing
   injective-map contract without assuming one law's support contains the other
   or introducing a general restriction framework.

Keep the six steps, exact all-atom formula, endpoints, C05 boundary and mandatory
independent closeout. No evidence justifies a larger API or a split of S03 now.
These recommendations await a requested revision; they are not newly approved
requirements. Only review chronology in the plan's editorial block changes.

### Review validation and limits

The reviewer freshly verified manuscript identities/anchors, 32 relevant source
hashes and clean dependency pins. Its focused core probe passed with eight
declaration checks and five anonymous consumers; the parent inspected that final
source and verified its hash. Two earlier simplifier failures and one PDF-output
encoding failure remain FAIL evidence, distinct from successful retries. The
fresh reviewer `lake build` passed with 2760 jobs; the placeholder scan and diff
checks passed. Prior planning probe logs were inspected as attributed earlier
evidence, not reported as new compiler runs. The parent's first suggestion-check
script likewise hit a Windows decoding error before its corrected UTF-8 read
and exact-fraction check passed. None of these failed exploratory checks was a
production theorem failure. Source applicability was checked before report
admission; later document edits record this review and preserve all normative
plan bytes. No plan approval, execution session, theorem implementation, commit,
push or dependency/configuration change follows from this review.

## Draft revision 2: selected improvements — 2026-09-12

The lead supplied the General Assistant's advisory review, initially requested
reading only, and then authorized choosing and applying the best combination
of its recommendations and the earlier suggestions. This authorizes revising
the proposed plan, not approving it or executing a mathematical step. No new
registered plan-review session was requested or opened.

### Selection and rationale

- **Correct closeout ordering.** Adopt the advisory report's main finding.
  Source inspection of `tools/pfr_review/core/workflow.py` confirms that
  `close()` requires satisfied parent and reviewer criteria before creating
  the closure certificate. Revision 1's S06-C02/C03 and CC08 asked for later
  reconciliation/closure in those very criteria. This is a real process
  defect missed by the earlier parent assessment and registered review; their
  original favorable records are preserved, not rewritten as if they found it.
  Following the existing C03 S07/Section 8 distinction, revision 2 makes the
  three S06 criteria and CC08 assess current readiness and truthful documents.
  Fresh cumulative acceptance, every original report, explicit reconciliation,
  required renewed assessments, final document/check applicability, F capture
  and supported durable closure remain mandatory subsequent duties. This
  changes ordering, not the required assurance or installed workflow.
- **Clarify imports.** Adopt both reviews' and the parent's correction. The
  new coupling core excludes Fano/KL; the root acquires neither the decoding
  bridge nor its Fano dependency. Its existing KL path through
  `FunctionalRepresentation -> Markov -> Independence -> Theorems -> KL` was
  rechecked and remains. No C01 restructuring or dependency change follows.
- **Extend R09 once.** Adopt the two-sided residual-product purpose shared by
  both reviews and the parent, using the unequal-weight example from the
  earlier recommendation. It checks different residual row/column sums and
  four nonuniform entries at `d=3/8`, while keeping R03's original zero-mass
  example. Decline adding the symmetric `1/8`-per-entry version as well:
  it would duplicate this boundary without enough additional coverage to
  justify another fixture. R09 remains one row, with both required consumers;
  no public example API or extra step is added.
- **Specify R12's common carrier.** Adopt the parent's clarification. Use two
  laws on the same finite subtype and the same inclusion on both coordinates.
  The union of ambient supports illustrates a suitable common carrier; a
  general restriction construction is not required. Neither support need
  contain the other, and no C03 active-output machinery is introduced.

Keep all six steps, all eighteen step-criterion IDs, all fifteen regression
IDs and all eight CC IDs. The exact half-L1/ENNReal construction, single
denominator, endpoints, universal lower bound, specified attaining witness,
support/transport guarantees, source anchors and C05 boundary are retained.
The changes complement one another; none requires a broader mathematical API.

### Provenance and applicability

The supplied review is advisory context with history, not a registered C04
report or execution authority. Its original text (SHA-256
`168538231a9d514fb24acb768163a8d47a58a27fa32b34bb5f7082e09eaa3e37`), the exact
revision request and before-images are retained under
`.pfr-review/setup/c04-draft-r2-20260912/`. The pre-revision plan has full-file
SHA-256 `7b4220f0ff744c2818ac62bc0c3d7c55d737c4c814895503eed3ef64ba67e62b`.
The original reviewed bytes with digest
`80d7efbb68a9892f2bf494a99f7a9bf551d335131f27b0d2de0ecd2403a83262`
and the original native report/reconciliation remain in the earlier revision-1
records identified above. Neither source nor verdict in that session has been
retargeted to revision 2. An explicitly requested review of the revised draft
would use a fresh plan session with the same bound reviewer.

The parent rechecked the installed closure implementation and C03 precedent,
current import source, the new exact rational fixture, and plan/document
consistency. A bounded read-only planning helper independently checked the
ordering and arithmetic; it is not the bound reviewer or a registered plan
review. The installed read-only inspection passed with clean matching pins.
The fresh baseline `lake build` passed (2760 jobs). No manuscript anchor or
Lean target changed; prior manuscript/API evidence is retained with its
original provenance, not represented as new theorem proofs or fresh reruns.
Final revision validation and the exact document diff are retained in the
same private revision directory. Revision 2 remains proposed; approval and
one separately requested implementation step are still future actions.
