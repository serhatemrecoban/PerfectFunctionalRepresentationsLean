# PFR-C06 planning notes

These notes accompany [Draft revision 2](plans/pfr-c06-finite-channel-matrix-boundary.md),
dated 2026-09-19. They retain revision-1 setup, attributed discovery evidence
and contextual assessment, followed by revision-2 selection and rationale.
The plan is **Draft / Proposed**; no installed independent plan review or
mathematical implementation has been requested. Acceptance
criteria and proposed contracts belong to the plan.

## Startup and prerequisite reconciliation

The exact originating user request is retained in
`.pfr-review/setup/c06-planning-20260919/original-user-request.txt`.
The root ran `python -B tools/pfr_review/cli.py inspect` and saved the original
inspection as `.pfr-review/setup/c06-planning-20260919-inspect.json` before
canonical documentation edits. HEAD is
`54c1714d1a9a891939d6c9f7d38c0d05896b2c75`. Inherited tracked root/document
changes and untracked C02-C05 Lean modules, tests, plans and review tools are
preserved. Pre-edit file hashes are in the private setup directory.

LeanInfoTheory `v0.1.0` resolves to
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`, mathlib `v4.33.1` to
`0df444a360eaa60ab8c11dca51a86af692955474`; Lean is `v4.33.1`. Installed
dependencies are clean and agree with the manifest. Configuration is
`lakefile.toml`. No dependency, workflow code or configuration changes were made.

A bounded read-only planning helper checked original production records using
the installed `ProjectRecordFS`, `Store.get`, and `Journal.load` interfaces,
without opening another parent's session or mutating durable state. It verified
all C02-C05 journal chains/projections and referenced object hashes: respectively
345/224/168/201 revisions and 387/314/265/327 records. All 28 steps (8/7/6/7)
are durably closed; all original step reports are VALID, explicitly reconciled,
and have satisfied required criteria. No active step, pause, cancellation,
external blocker, plan restriction or decision obligation remains.

| Chunk | Final closure | Final source F |
| --- | --- | --- |
| C02 S08 | `5a59434952e2e5776a0f29166b957a7eb389eccae723552944a671ec9ee684e0` | `17f766b119808a26d4572c94f5ca08ff9b1e19c6a3e09cba77c9f1a95a9d76b2` |
| C03 S07 | `8a0d64e10a0a823477ab423f0e653149191afbc110c11863ef59164493a103d1` | `778463340fef9ba5a7b7296f50349e600c1c1d9c3040309deac6411749fd9f17` |
| C04 S06 | `259c743e6d15342685a85d24c23786f4c85a20e4c04b64f57adf0edf861a44f0` | `45c763da2fe0b185801b43cd453384d0d359b7fa63ccefc0620574d635c14350` |
| C05 S07 | `fe274ecf3bb77b2f184b99e9bf800c361b91239878dc1713b06d9270bc056f04` | `d91ab03a22006441ea56fe55dc527dad32ca45fba3453a55cfd45642e1b2bc1e` |

These objects are under
`.pfr-review/chunks/PFR-C0N/execution/durable/objects/<hash>.json`.
The final original-report and explicit reconciliation references are:

| Chunk | Original report | Reconciliation |
| --- | --- | --- |
| C02 | `c8c68cca8673cc612ad66629fba5f51cf75755efa630a9b0362322c1bf7c8ef5` | `ab616dd6fdc96d9dc9af10ca4e95bb18a981903da6de1af63c78f8ad78c29431` |
| C03 | `a6b9fcdaec67799d9eab623dca8d0d4969ca6edae4d77bd2130b9534734a09ef` | `94af5a12022657b5dd47aed94e6c0034ed2970312007c98f9a4376799191b199` |
| C04 | `a544940ead8c137598c0ece7163edb722ed1476694ce94dfe5e8a1ac0aeab8ea` | `ac057a2500735f804905fe83e3456742f456717aed967e0b916419e8fc71a906` |
| C05 | `c21b4826ef9375f692afc18a4366f5cfbb75b32e2311c6182968a8f705e33318` | `f46a9485f1ae2982bc9d3aaf447c3dd824971b06a3f14e005c16e185928bf798` |

C01 is the recognized historical prerequisite: closeout commit
`60913637e7a8a982730112415cfd9ddeea59d367` exists and is an ancestor of HEAD.
The closed plan records independent S08 validation/completion on 2026-09-07.
Basic, FunctionalRepresentation and its regressions still match that commit;
only the root expanded later. No synthetic automation closure was created.

Exact current applicability at startup: 61/71 C02 real F files, 61/71 C03,
81/91 C04 and 96/101 C05 matched. The relevant Lean/test/dependency/configuration
files and closed plans remain exact. Earlier root differences are later documented
integrations. Every maintained Lean file, including the root, matches C05 F.
C05's five differing files are AGENTS, living summary, project log, review
operations and review protocol: subsequent deferred-suggestion and waiting
guidance, not mathematical or workflow-code changes. This is scoped source
applicability, not a claim that every historical inventory is unchanged.

C06's principal source hashes are:

- `Semantics/Canonical.lean`: `df8a384afd6840a5e3635cd3d934235f48bdb31eec2656150f0ecfbcb1b33cb8`.
- `Semantics/Singularity.lean`: `735d8f5239b9ce732c1956a733a16c84485c06e48fc39006aa4df417eaface32`.
- `Examples/Nonrepresentable3x3.lean`: `35a468af3f340b8455503d09d05a3ced639d53b3e44e0a6142d1de552d44305b`.

C05's frozen plan, implementation/readiness notes and project-log entry 77
retain their correct pre-F validation-ready wording. The subsequent durable
S07 record establishes completion; current reader/status documents are now
reconciled to C01-C05 complete. Original closed records are retained, and no
completed mathematical work is reopened. The audit verifies cooperative local
records and source bytes, not authenticated transport or a new independent
mathematical validation pass.

## Persistent reviewer binding

No C06 binding existed at startup. Before creation the root retained the exact
user instruction and neutral bootstrap intent. The requested native profile
was `model="gpt-6-astra"`, `reasoning_effort="ultra"`, `fork_turns="none"`.
The complete observed creation result was
`{"task_name":"/root/pfr_c06_reviewer"}`. Installed `bind` succeeded with
parent task `01a0b902-b394-7493-a9d8-8a5216ee86d7`, distinct from role `/root`.

The exclusive record is `.pfr-review/chunks/PFR-C06/binding.json`; original
request, intent, actual creation result, bind packet and readiness event are
retained under `.pfr-review/setup/c06-planning-20260919/`, with the CLI result
at `.pfr-review/setup/c06-planning-20260919-bind-result.json`. Native references
are explicitly labeled local captures where no backend event ID was exposed.
No sibling or General Assistant reviewer was transferred or replaced.

The reviewer received no implementation conversation, plan, critique or helper
solution. It acknowledged readiness and no effective-setting visibility.
Effective model/reasoning/history settings remain unknown; the creation result
establishes identity only. Read-only behavior is instruction-level, not OS
isolation, under the accepted supervised limitations. The same reviewer is
reserved for later C06 reviews. No plan-review or execution session exists;
the readiness event is not a review. Planning helpers are not reviewers or
acceptance authorities.

## Manuscript and API discovery

The root checked both approved SHA-256 digests and page counts, extracted and
visually inspected ISIT pp. 2-3 and extended v16 p. 3, with the adjoining
III-A operations through p. 4 checked only for interface context. Exact paths:

- `C:/Users/coban/Desktop/On perfect functional representations/my paper/ISIT_2026__On_perfect_functional_representations___final_manuscript_ (3).pdf`;
- `C:/Users/coban/Downloads/On_perfect_functional_representation__Extended_version_ (16).pdf`.

The identities and precise mathematical anchors are in plan Section 2. Temporary
extracts/renders remain ignored under `tmp/c06-planning/references/`. The first
PDF text-print command failed on Windows stdout encoding after rendering ISIT
p. 3; the corrected `python -X utf8` command authenticated and read both sources.
No dependency was installed or changed.

A bounded API helper inspected actual PFR and pinned library sources and their
documentation, then successfully compiled
`lake env lean tmp/c06-api-discovery-20260919.lean` (exit 0). Its output is
`tmp/c06-api-discovery-20260919.log`: 57 exact declaration checks plus two
elaborated applications of existing constructors/conversion APIs. The earlier
failed attempt used literal `0 : Fin n` without positivity in a disposable
smoke expression; its negative log is retained separately. The corrected
expression uses an explicit `i : Fin n`. No C06 declaration or proof was
implemented by these probes. Plan Section 5 separates verified declarations
from proposed names and records the resulting reuse choices.

A separate supplemental seven-declaration probe also passed (exit 0):
`lake env lean tmp/c06-api-supplement-20260919.lean`, with output in the
matching `.log`. It verifies `IsPerfectlyRepresentableChannel.isSingular`
and the six C02 input-support declarations listed in the plan. The final
support-restriction iff supplies its subtype instances internally and assumes
no ambient full support. The original successful inventory/log bytes remain
unchanged. Both probes are declaration/application checks, not C06 proofs.

Concrete discoveries affecting the plan:

- C03 restriction is already normalized by `bindOnSupport`, retains exact
  masses, and requires no renormalization or public default. The map's older
  prospective “normalized finite PMF construction” wording is updated to
  point to that actual API; plain mapping from ambient labels is not invented.
- `Probability.Finite` already supplies Real mass bounds and row sums.
  `Matrix.Defs` supplies reindexing without importing determinant machinery.
- A column is not a PMF over inputs; `PMF.supportFinset` is not a valid direct
  pattern constructor. Use nonempty input support finsets and derive the
  numeric division/Boolean presentations.
- C03 transport supports independent universes, contravariant input
  equivalences and forward output maps. Its perfectness iff carries the
  target nonempty-input instance explicitly. Injective extension can leave
  the active carrier until the output restriction is performed.
- A typed active record with a separate singularity premise handles both
  ambient coordinate bridges and later singular operations. Repeated patterns
  and value one must remain legal. C12 owns distinct-pattern compression.

No genuine upstream/discoverability issue was found. Relevant mapped deferrals
retain their owners/triggers in plan Section 9. The numbered Future Work Notes
register contains none; no new unowned deferral was identified.

## Revision-1 contextual review and reassessment

The root retained the first draft, then its read-only critique and separate
reassessment in the private setup directory before applying corrections.
This is parent contextual review, not the independently requested plan review.

CTX01 changed the carrier from `[Fintype alpha]` to `[Finite alpha]`: the state
stores no input enumeration, so exposed finite sums/patterns can request
Fintype locally without making the carrier depend on that choice. CTX02 made
the data-reconstruction converse's finite/nonempty hypotheses explicit and
clarified that only weighted row sums, not the sum of column values, equal
one. CTX03 made the injected-zero-column/restriction boundary explicit.
CTX04 retained the coherent six-step dependency split; S04's consequences
share one support decomposition and its reconstruction converse remains
required. CTX05 awaited the corrected successful compiling probe rather than
using builds to claim API verification. CTX06 reconciled current status and
the outdated prospective restriction sentence while preserving closed bytes.
The final consistency pass also clarified the map's DG-10 sequencing: C07
waits on C06's approved numeric contract, while C12 retains its later portion.
It does not wait on completing its own downstream C12 dependent.

The final draft contains six proposed steps, eighteen step criteria, sixteen
regression obligations, ten completion outcomes and six future plan-review
criteria. It explicitly requires a fresh independent cumulative closeout,
actual normalized division, finite/universe transport, value-one and repeated
pattern guards, no hidden prior, root isolation and later-chunk boundaries.
DG-06/DG-07 and C06's portion of DG-10 remain proposed decisions pending exact
approval; C12's numeric/compression contract and C07 operation choices remain
unsettled. No substantive mathematical ambiguity required a separate question
during this draft; the lead's choice is whether to approve these exact contracts.

## Revision-1 planning validation

The root freshly ran the Canonical/Singularity/example production and regression
aggregate (2765 jobs) and `lake build` (2762 jobs), both successfully. The strict
maintained-Lean placeholder scan returned no matches. These checks validate
the current prerequisite baseline, not unimplemented C06 mathematics.
Final documentation/link, source-preservation and repository-hygiene checks
passed: all 234 checked local file links exist, all plan/register IDs are
consistent, no tracked generated/private artifacts or staged changes exist,
and all 75 other baseline files retain exact bytes. Only six current canonical
documents and the two new C06 documents differ from the preserved baseline.
Private setup evidence retains the results. No commit, push, approved-plan
registration, mathematical step or independent review dispatch follows this
planning task.

## Draft revision 2 selection and rationale

On 2026-09-19 the lead authorized choosing improvements from the parent's
unapplied suggestions and the supplied **Independent advisory review -
PFR-C06**, identifying Draft revision 1 of the same date. This is editorial
planning authority, not exact plan approval or permission to invoke the bound
reviewer. The General Assistant report is advisory and does not replace the
installed independent process. Its original C06-GA-01-C06-GA-04 identifiers
are retained below; PARENT-01-PARENT-04 are local cross-reference labels for
the four earlier parent suggestions, not independent-review finding IDs.

The selected revision adopts all six distinct improvements after merging
overlaps. Each improves a contract or the ability to check it without adding
a theorem family outside C06. The architecture and all six step identifiers,
eighteen step criteria, sixteen regression IDs, ten cumulative outcomes and
six proposed plan-review criteria remain. No suggestion needs a new deferred
owner or numbered Future Work Note.

| Original suggestion | Disposition and reason | Required plan location |
| --- | --- | --- |
| PARENT-01: precise output-equivalence comparison | Adopt. The pruned extension is compared with the original active presentation, not an ambient alphabet that can have more labels. For active states specify an output equivalence and the actual PMF.map equation; no quotient or state-equivalence framework is introduced. | Section 3 transport; S03-C01/C02; R06/R11 |
| PARENT-02 and C06-GA-01: readiness versus completed closure | Adopt together, following C05's existing timing distinction. Review-time criteria concern mathematics, validation and an explicit report adequate for reconciliation; subsequent reconciliation, applicable final checks, F and supported durable closure remain mandatory ordered duties. This removes a demand to certify future events without relaxing completion. | S06-C01-C03 and ordered duties; CC10 and Section 8 timing paragraph |
| PARENT-03: redundant ENNReal finiteness premise | Adopt. A nonempty pattern supplies an input at which its positive value is a summand of a row totaling one. Thus the bound and finiteness are conclusions; the main reconstruction converse needs neither extra premise. Positivity, nonempty patterns and normalization remain required. | Section 3 converse; S04-C02; R14 |
| PARENT-04 and C06-GA-02: fixture column index | Adopt the direct label-preserving option. Package the existing already-active `Fin 3` channel directly, preserving output 0; do not depend on an arbitrary active-subtype enumeration. General enumeration transport remains separately required. | S05; R15; OM-069 |
| C06-GA-03: complete unused-output recovery test | Adopt as explicit traceability of an existing obligation. S03 checks injection, off-image zeros, restriction, re-enumeration and active-presentation comparison; S04 checks the transported admitted column data. | S03-C01; S04-C02; R06 |
| C06-GA-04: distinguish forward/inverse permutations | Adopt and sharpen. Require separate input-only and output-only three-cycle checks with direction-sensitive entries/patterns, preventing simultaneous relabelings from cancelling. Consumers must use the new matrix/column APIs. | S03-C02; S04-C02; R10 |

The parent rechecked C05's acceptance timing precedent and the current C06
contracts. A bounded read-only helper inspected C03's existing three-cycle
regression and source orientation; it did not invoke the bound reviewer,
edit source, or implement C06 mathematics. C03's current input cycle is
`(swap 0 1).trans (swap 1 2)`, with `e 0 = 2` and `e.symm 0 = 1`.
One suitable future R10 fixture is `kappa x = PMF.pure x` on `Fin 3`:
input-only transport has entry `(0,1) = 1` and column-0 pattern `{2}`;
output-only transport has entry `(0,2) = 1` and column-2 pattern `{0}`.
These coordinate choices are explanatory candidates, not mandatory public
names or newly compiled proofs. R10's direction-distinguishing behavior is
mandatory. Values are also transported through the new API.

The converse's bound follows either by the finite-sum inequality or by
constructing the row with the already verified `PMF.ofFintype` and then using
`PMF.coe_le_one` and `PMF.apply_ne_top` at an input in the pattern. The latter
requires normalization alone, so it does not assume finiteness circularly.
No additional C06 proof or API discovery probe was implemented for this
documentation revision.

The lead-supplied General Assistant report says it freshly reran both existing
API probes and a distinct-universe reindexing probe, inspected sources, and
authenticated/visually checked ISIT pp. 2-3 and extended version 16 p. 3; it
reports no fresh full-project build. These are attributed advisory claims,
not a fresh parent run or a bound-reviewer assessment. Revision 1's original
parent verification evidence remains separately recorded above.

The exact delivered revision-1 plan (SHA-256
`051abde05ef6ab29f2d53d9f14612ed0247e0bcbd9a605b168db90d9f79ef3d1`),
before-images of the eight affected documents, the revision authority and
baseline/private-record hashes are preserved under
`.pfr-review/setup/c06-revision2-20260919/`. Original setup, closed plans,
reports and reviewer binding are retained. The supplied advisory text is
preserved there with its provenance; it is not an installed review record.

Revision 2 remains **Draft / Proposed**. DG-06/DG-07 and C06's portion of
DG-10 await exact approval. Independent plan review remains a separate lead
request, and implementation additionally requires approval and a step request.

### Revision-2 validation

Fresh `lake build` passed (2762 jobs); the maintained-Lean placeholder scan
returned no matches, and the installed read-only `inspect` succeeded. These
check the unchanged baseline, not future C06 proofs. The contextual final
diff review checked the selected contracts against both suggestion sets and
made the required satisfactory independent assessments explicit alongside
the ordered post-report duties.

Source-preservation checks confirmed that only the eight intended documents
changed: all 75 other baseline files and all 4003 pre-existing private files
retained their exact bytes, including closed records and the C06 binding.
Local file links and all step/criterion/regression IDs passed, with no staged
changes or tracked generated/private artifacts. C06 still has no installed
plan-review or execution session. The final documentation-only pass reuses
the applicable source/build/private-record checks; evidence and the final
document hashes are retained in the revision-2 setup directory.

## Lead guidance and S01 readiness

On 2026-09-19 the lead endorsed Draft revision 2 and reiterated that the plan
and review procedures are valuable aids to clear goals, critique and better
work, to be interpreted with judgment. During an authorized step, improve
proof routes, organization and plan details when implementation evidence
warrants it; explain and record the reasons, and ensure review evaluates the
actual resulting work. Routine improvements need no repeated permission.
Preserve the intended mathematical guarantees, original reviewed records and
traceability. Raise substantive mathematical-intent, scope or acceptance
decisions rather than silently weakening the required outcome.

This guidance already agrees with AGENTS.md and the plan's revision policy;
no policy redesign or change to the delivered plan is needed. The lead did
not request implementation. The endorsement is recorded without opening an
execution session or dispatching the separately requested independent review.

S01's defined scope is the exact rectangular ENNReal coordinate view, bounds,
finite row sums, rowwise `PMF.ofFintype` reconstruction, both inverse laws and
channel extensionality, with R01/R02 and the raw empty-boundary parts of R04.
Its verified API and prerequisite evidence is recorded above. Later Real,
active-state and column-data steps remain separate requests.

A bounded read-only readiness check confirmed the delivered plan hash remains
`a1c46e3de0aa688e591fcdf6e2a459cfa28da6f7c3407b3a69bdc25e983aa20d`.
Eleven relevant source/configuration files match the revision-2 baseline;
installed pinned dependencies are clean and match the manifest. The same
C06 reviewer binding belongs to this parent, with no plan-review/execution
session. The recent successful prerequisite build remains applicable; no
fresh build, proof probe or independent assessment is claimed. An initial
helper read encountered Windows text encoding and was corrected with a
byte-based JSON read before the successful check. S01 is technically ready
for the lead's separate start request; no mathematical step has begun.
