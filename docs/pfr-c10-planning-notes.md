# PFR-C10 planning notes

Prepared 2026-09-28. The [revision-2 plan](plans/pfr-c10-generic-reachability-easy-direction.md)
is at its **Approved / Active finalization checkpoint**; S01-S06 are durably complete and S07 fresh cumulative independent review is reconciled on 2026-09-29. Final validation/F and durable closure follow this checkpoint.
The [implementation notes](pfr-c10-implementation-notes.md) own current execution evidence.
See [approval and readiness](#approval-and-s01-readiness---2026-09-28) and
[revision-2 dispositions](#selective-revision-2-and-suggestion-dispositions)
for the five adopted refinements and one unchanged API choice. Earlier planning
and review checkpoints below remain historical, including revision 1's incomplete
formal report admission. The execution session now covers S07; no independent
revision-2 plan review is claimed.

## Prerequisite reconciliation

The installed `python -B tools/pfr_review/cli.py inspect` ran from the repository
root. Its saved result is `.pfr-review/setup/c10-planning-20260928-inspect.json`.
The pre-document inventory contains 114 nonignored tracked/untracked files at
HEAD `54c1714d1a9a891939d6c9f7d38c0d05896b2c75`; the inherited dirty tree is
the baseline. None of its maintained mathematics is attributed to C10.

The parent used installed `ProjectRecordFS`, `Store`, `Journal.load` and
checkout-inspection interfaces read-only. C09's 149-event journal and 225
state-referenced objects validate. All five steps have durable closure, VALID
original reports, explicit reconciliation and all fifteen closing criteria
SATISFIED. Its three historical optional wording/metadata findings are RESOLVED.
No active step, pause, cancellation, external blocker, decision obligation or
plan restriction remains.

| C09 S05 evidence | Durable reference |
| --- | --- |
| Final closure | `2a15c4d4a76719bca5e681abce2af15b98d8c5488b4b3b86a4dc8f5882f30d44` |
| Final source F | `5189b0f97491548821d6169c6fbac914d8f164aa656bfc9d572b4640ddabac4c` |
| Original cumulative report | `d168385151be8bcba03f472ceabfbfda01f35a7664210f2cea528af23914702c` |
| Explicit reconciliation | `c71ee7d0db56a34cf125996c38aa40bf7203e22f7e60871c9d46c1b69fdd1fff` |
| Final PASS validation | `d8384cdd7146f1e2c2cb3329d350785930c4dce1e46ab910f70b2696ff738dc8` |

Objects remain under `.pfr-review/chunks/PFR-C09/execution/durable/objects/`.
The parent read the final report, closing criteria, reconciliations, historical
finding dispositions and final validation, not just a summary. **All 124 final
source/environment entries matched before owning-status edits.** The new plan
was absent from C09's frozen inventory; no existing source changed during this
comparison. Subsequent C10 planning/status changes are a new attributed change,
not a rewrite of C09's acceptance snapshot.

The original C09 plan, readiness audit, implementation/planning notes and log
entry 115 deliberately stop before F/closure. The later durable record completes
CC09. Their pending wording is historical, not an unresolved mathematical task.
They are preserved. C09's retained fresh 26-module/default builds and
fourteen-public/241-constant audit are earlier evidence, not newly rerun audits.

C02-C08 journals and final closure/report/reconciliation/F records were also
read through the installed stores. C02-C04 have fourteen changed F files, C05
thirteen, C06-C08 six each: later root integration where applicable, owning
documents/instructions and the authorized review-tool repair account for them.
Earlier non-root Lean, closed plan and pinned environment files match. In
particular C08's seven-step closeout remains
`563027c353d94b430dd0c83192f274915f4ca46f6395761cc0a80b14a9f350b3`; the six
changed files are README, map, summary, log, scope and roadmap. C01's historical
closeout is an ancestor, with original semantic/test source unchanged and later
root integration. No synthetic C01 workflow record was created.

This is a bounded evidence-custody/source-applicability audit, not a fresh
independent mathematical review of C01-C09 or authenticated native provenance.
No genuine prerequisite discrepancy was found. All ten installed packages are
clean and match the manifest. LeanInfoTheory `v0.1.0`, mathlib `v4.33.1` and
Lean `v4.33.1` remain unchanged; exact commits are in the plan.

## Persistent reviewer setup

No C10 binding existed at startup. Before creation the parent retained the
actual user request and neutral bootstrap intent. The native call requested
`gpt-6-astra`, `ultra`, `fork_turns="none"` and returned exactly
`{"task_name":"/root/pfr_c10_reviewer"}`. The complete creation result and
binding packet are preserved; the installed bind operation succeeded.

The exclusive binding is `.pfr-review/chunks/PFR-C10/binding.json`, associated
with originating task `01a0e771-5cb9-7710-b634-1c4ca0b6cad3`, distinct from
role `/root`. No other chunk's reviewer or General Assistant reviewer was reused
or transferred. No plan-review or execution session was opened.

The full original bootstrap response is retained. It says the reviewer has not
inspected the repository and will wait for an exact source-bound request.
Effective model, reasoning and history-fork settings are not directly observable.
It reports visible operating/tool/skill instructions, repository AGENTS.md rules,
environment and the neutral bootstrap. Requested settings are not reported as
observed effective settings. Read-only behavior is instruction-level, not OS
isolation; local captured references are labeled as such.

The reviewer received no plan, implementation history, helper report, self-review
conclusion or expected verdict. Setup is authorized; independent plan-review
dispatch is not. Reuse the binding for a later explicit request under the
installed workflow, without asking the lead to relay review messages.

## Sources and planning decisions

The parent freshly hashed the designated PDFs (six/eighteen pages), extracted
relevant pages and visually inspected ISIT p. 4 and extended pp. 4-6. Exact
identities and anchors appear in plan Section 2. Local sources are:

- `C:/Users/coban/Desktop/On perfect functional representations/my paper/ISIT_2026__On_perfect_functional_representations___final_manuscript_ (3).pdf`;
- `C:/Users/coban/Downloads/On_perfect_functional_representation__Extended_version_ (16).pdf`.

Extracts/renders remain ignored under `tmp/codex-handoffs/pfr-c10/references/`.
No paper copy or extract is stored in maintained documents or private review
records. Theorem 1's easy direction, the Section IV operation instructions and
extended Example 6 are the C10 anchors; adjacent C11/C13 content retains its owner.

Extended Example 6 (30) silently moves the merged column past an unaffected
column, unlike C07's lower-survivor ordering. OM-071 records an explicit
transposition. The proposed exact-order path uses zero-based pairs `(1,2)`,
`(1,3)`, `(0,2)`, `(0,1)` with tags VPM/PPM/VPM/PPM; S06 must prove each
coordinate and its comparison to (25)-(32). This is a representation repair
within the established output-equivalence convention, not a changed theorem.
No fixture is claimed implemented by this inspection.

DG-11 remains Open with a proposed resolution: use mathlib `Finpartition` on
the actual support finset, local classical decidability and a minimal labelled
family adapter. Existing nonempty/disjoint/coverage and sigma-of-parts APIs fit.
A duplicate indexed partition record or `Setoid` quotient would add avoidable
invariant/finite-support proofs. Approval of the exact plan would select the
resolution; the planning task has not resolved the gate itself.

The seven proposed steps cover reachability/reversal/easy direction, partitions,
PPS weights, VPS partitions, PPM fibers, Example 6/integration/readiness, and
fresh cumulative independent closeout. Direct finite induction over public
C07/C08 APIs is selected. Private C08 normalization trees and traversals remain
private. Exact endpoint labels and all unaffected coordinates are required,
including finite per-column family corollaries. The ENNReal weight adapter
supports C11's later PMF consumer; Real compressed data remain C12.

## API discovery and attributed validation

Two research helpers supplied bounded source/API analysis and disposable probes.
They are implementation assistance, not the persistent independent reviewer.
The parent inspected their reports, probe files, actual declarations and outputs
where saved. Pinned LeanInfoTheory's public API contract/inventory, declaration
index, API documentation, module guide/highlights and relevant probability source
were searched, together with pinned mathlib. No new generic information-theory
theorem or genuine discoverability problem was identified.

| Actor/check | Actual result and limits |
| --- | --- |
| Parent, installed inspection and read-only prerequisite audit | PASS; journals, original reports/reconciliations, findings, source comparisons and package state described above. |
| Parent, focused build of `Matrix.Operations`, `Matrix.OperationPaths`, `Matrix.OperationFactorization`, `Matrix.Preservation`, `Tests.Matrix.Operations`, `Tests.Matrix.OperationPaths`, `Tests.Matrix.OperationCalculus`, `Tests.Matrix.Preservation` | PASS, 2776 jobs, no diagnostics. Incremental prerequisite build, not a clean rebuild or repeated exhaustive trust audit. |
| `/root/c10_api_research`, pinned native `lean -j 1` on `api-research-retry3.lean`, with root and all manifest package build-library paths in `LEAN_PATH` | PASS, exit 0. Existing signatures, all four remembered reverse edges, path/cascade reversal terms, perfectness output transport, positive restricted folds and seed consumer. Reverse-tag theorem and arbitrary synthesis were not proved. |
| Same helper, Operations-only `api-coordinate-research.lean` | PASS, exit 0. Exact eight coordinate names compile: `pps_left/right/keep`, `vps_left/right/keep`, `ppm_apply_survivor/unaffected`. |
| `/root/c10_partition_research`, `lake env lean -j 1 tmp/codex-handoffs/pfr-c10/partition-research.lean` | PASS, exit 0. `Finpartition` consumers, proposed endpoint conclusion shapes, hidden decidability signatures and positive-support sum preservation. No synthesis theorem. |
| Same helper, analogous command on `partition-research-weights.lean` | PASS, exit 0. Finite ENNReal sum-one implies finite summands, exact normalized NNReal conversion and matching positive support. |
| Parent, default `lake build` | PASS, 2762 jobs, no diagnostics. The root and every maintained Lean/configuration file are unchanged; later Markdown corrections do not affect this incremental result. |

The first parent focused command named a nonexistent
`Tests.Matrix.OperationFactorization` module and failed. The corrected command
uses the discovered `Tests.Matrix.OperationCalculus`; the original failed log
is retained. The API helper interrupted its initial slow Lake launch, then
preserved three failed native probes: path pattern elaboration needed the local
`operationQuiver` instance and explicit recursive endpoint binders. Only retry 3
is passing evidence. Its earlier files/outputs remain in scratch. The partition
probe's first support-sum proof used the wrong namespace; the corrected
`Finset.sum_congr_set` proof passed. These are disposable verification errors,
not changes to maintained mathematics; no negative attempt is relabeled success.

Fresh final default-build and document/source/artifact results are recorded in
the closing validation section below. All Lean, root, pins and review tooling
remain outside this task's maintained edits.

## Contextual self-review and reassessment

The initial draft and original critique were retained privately, followed by a
separate reassessment before edits. This was the parent's review, not independent
plan acceptance.

| Reference | Decision and resulting change |
| --- | --- |
| C10-P-SR01 | Corrected misnamed split-coordinate candidates to the actual `pps_left/right/keep` and `vps_left/right/keep`; the supplemental compiling probe passed. |
| C10-P-SR02 | Clarified usable witnessed constructor/result data and the private `Unit + R` to `I + R` induction invariant, including finite family traversal. |
| C10-P-SR03 | Named verified finite ENNReal conversion laws and retained C12's broader Real ownership. |
| C10-P-SR04 | Added the concrete exact-order Example 6 operation pairs and the displayed-state transposition under OM-071. |
| C10-P-SR05 | Declined extra step splitting without evidence of a reviewability problem. Existing revision policy owns reassessment if implementation reveals one. |
| C10-P-SR06 | Reconciled current C09 completion and Proposed C10 status while preserving original closed-plan/readiness/implementation records and historical log entries. |

Multiway synthesis, recovery/reversal, zero weights/empty fibers and possible
helper promotion were reassessed against OM-038/045/049/051/052 and C08/C09
readiness deferrals. The strict-VPS alternative remains unselected. Every
worthwhile deferral has an existing owner/trigger in plan Section 10; no numbered
Future Work Note is opened. There were none in the authoritative register at
startup. No correctness or acceptance gap was deferred as optional work.

## Evidence custody and closing validation

Private evidence lives in `.pfr-review/setup/c10-planning-20260928/`: exact user
request, neutral bootstrap intent, full creation result, binding packet/reply,
inherited baseline, before-images, prerequisite audit, original C09 final report,
initial draft, contextual critique and separate reassessment. Native references
without exposed backend IDs are explicitly local capture labels. This private
directory is durable state, not scratch; no C10 review R/F or closure exists.

The maintained changes are the proposed plan, these notes and concise owning
status/map/log updates. Earlier C08/C09 plans, readiness and implementation notes
remain byte-identical to the captured baseline. No implementation, dependency
change, review-tool change, independent dispatch, commit or push occurred.

Final task-relative checks identify exactly six changed inherited status documents
and two new Markdown files. No inherited file was removed. Maintained Lean,
closed plans, root, configuration and review tooling are byte-identical to the
baseline. Local document links resolve; the map retains all 71 distinct omission
IDs. The plan has seven steps, 21 step criteria, 18 regressions and eight completion
criteria, with Proposed status and no C10 execution session. The placeholder scan
has no matches; `git diff --check` passes with pre-existing LF/CRLF warnings.
No reference media, compiled Lean or log artifact is tracked; references/probes
and private evidence remain ignored. The task-relative diff is retained separately
from the inherited diff against HEAD.

The first disposable document validator stopped on Windows' default text encoding;
the original script is retained, and the explicit UTF-8 correction passes. A
second scratch check omitted the installed `.project-owner.json` marker from
its expected binding-directory files; source inspection confirmed the marker
is mandatory, and the corrected check accepts the marker plus binding with no
session directory. The original failed check is retained. Final
visual source checking also corrected the extended p. 6 construction anchor to
the right column. These were planning checks/corrections, not changes to Lean
or review tooling. The delivered plan/notes and final validation capture are
retained in the private setup directory.

The substantive proposal for the lead is exact-plan approval, including DG-11's
`Finpartition` boundary. No unsupported obstacle or additional mathematical
decision was found. A later explicit plan-review request is separate from setup;
any later implementation still requires approval and an explicit step request.

## Independent plan review and unapplied suggestions

This section records the revision-1 review checkpoint. The later selective
revision and current suggestion dispositions are recorded below.

On 2026-09-28 the lead requested a review and improvement suggestions, expressly
forbidding plan changes. The existing bound `/root/pfr_c10_reviewer` returned a
complete original report for `PFR-C10/plan-r1-20260928`. It assesses PR01-PR06 as
SATISFIED and finds no material mathematical or acceptance gap. These are the
reviewer's assessments; formal admission has the format limitation below.
The parent critically agrees with those assessments at plan-feasibility level.
No unimplemented C10 theorem is claimed proved, and DG-11 remains Open.

Fresh reviewer checks matched all 130 concrete inventory hashes and both exact
manuscripts, including five rendered relevant pages. The focused prerequisite
build (2778 jobs), default build (2762 jobs), corrected existing-API probe,
seven named prerequisite axiom queries, placeholder scan and exact rational
Example 6 check passed. The initial probe's noncomputability errors remain
preserved as a failed attempt. These are reviewer-executed checks, not parent
reruns; historical private closure evidence remains separately attributed.

| Suggestion | Assessment and existing owner/revisit trigger |
| --- | --- |
| `pfr-finding:c10-pr1-001` | Optional, LOW severity/HIGH confidence. Both cited finite-induction principles have Prop-valued motives. Explicitly describe induction on `Nonempty` of the required witnessed data, followed by noncomputable witness selection and accessors. Section 5.6 already permits this. Owner: S03 signature design; revisit at an authorized revision or S03 proof organization, with S04-S05 reuse only where useful. |
| Parent `PA01` | Clarify Section 5.6/R09 input reindexing: C06 provides raw channel row relabeling, while C08 path transport fixes the input type and relabels outputs. State whether the regression checks endpoint coordinates or requires an additional general input-path transport theorem. Owner: S03/R09; revisit before settling that consumer. |
| Parent `PA02` | Check dependent-family witness access and comparison to an independently supplied target early in S03-S05, before the large integrated fixture. Existing R09/R12/R15/R18 already own these outcomes; this changes timing, not scope or step count. Revisit during the next authorized revision or those steps. |
| Parent `PA03` | Prefer the nonempty PPM core constructor plus a separate empty/no-op fact unless a consumer needs a total dependent wrapper. Section 5.5 already forbids a phantom empty column. This is a low-priority interface refinement owned by S05/R14. |

All four suggestions remain unapplied. They have existing owners and triggers,
so no numbered Future Work Note is opened. The seven steps and mathematical
scope remain recommended. The exact plan is byte-identical at SHA-256
`8a0e21bdd68f5a31794d9a2723ae384bdd69e35ffb723651823ad6153b6085e1`.

### Report custody and admission limit

Private originals, parent pre-report advice, separate reassessment and critical
post-report evaluation are retained under
`.pfr-review/setup/c10-plan-review-r1-20260928/`. The empty native dispatch
return remains UNCERTAIN; the complete original response separately confirmed
delivery under `71bf0ffad0fc37d063b19818aeeead4a182553f2700b527dfdbfb46557e27557`.
The preserved report observation is
`78d74d22691ecc1a7f2dc8ff9bda1fdf9a09632505616acf648328a42154cf10`.

The installed recorder classified the report
`DIAGNOSTIC_INPUT_REFUSED:REVIEWER_EVIDENCE_SCHEMA`: its `inspected_source`
fields are lists, whereas the installed adapter requires text. The generated
request lists the field without specifying that type. This format mismatch
does not alter the original mathematical assessments. Formal report admission
and the supported reconciliation call remain incomplete; the retained parent
evaluation is not represented as successful workflow reconciliation.
The original bytes and tools were not altered, and no conflicting resubmission
or replacement session was attempted. Any later action requiring formal
plan-review acceptance must account for this exact limitation through an
authorized supported route. It does not approve implementation or redesign.

Final checks preserve every maintained Lean file, closed plan, dependency pin
and workflow file. Only these notes and concise canonical review-status entries
change. The unchanged plan, placeholder scan and whitespace checks are verified
separately from the reviewer's builds. No commit or push is included.

## Selective revision 2 and suggestion dispositions

The lead subsequently supplied the General Assistant's independent advisory,
initially requesting only that it be read. A later message authorized choosing
the best subset of all suggestions and revising the proposal. That is revision
authority, not exact-plan approval or an implementation request.

The supplied advisory reports no blocking mathematical/API issue, successful
reruns of the three existing planning probes, source/pinned-API inspection, and
manuscript checks on ISIT p. 4 and extended pp. 4-6. It explicitly did not rerun
the full build or claim the synthesis theorems implemented. These remain
user-supplied reviewer claims. Its two suggestions are identified here as GA01
and GA02, preserving their original numbers and source.

| Original suggestion | Revision-2 decision and rationale | Owning obligation |
| --- | --- | --- |
| Bound reviewer `pfr-finding:c10-pr1-001`; first suggestion in the parent's user-facing review | Adopted. State that the cited Prop-valued finite-induction principles establish `Nonempty` of witnessed data, followed by noncomputable selection with coherent accessors/specifications. Direct data-producing proof routes remain permitted. This avoids an elaboration dead end without prescribing another public record. | Section 5.6; S03-S05 |
| Parent `PA02`; second user-facing suggestion | Adopted. Exercise generic-family accessors and independently specified target comparisons early within S03-S05, before expanding larger fixtures. The existing regressions supply the cases, so no step or theorem is added. | Section 5.6; R09/R12/R15/R18; S06 integration |
| Parent `PA01`; third user-facing suggestion | Adopted. R09 re-instantiates synthesis on the C06 row-relabelled source and checks independently relabelled target coordinates. C08 supplies output-path transport at fixed input type. A general theorem transporting arbitrary paths across input types is not required. This makes the existing regression precise. | Section 5.6; S03/R09 |
| Parent `PA03`; fourth user-facing suggestion | No additional plan prescription adopted. Section 5.5 already requires a nonempty merge core and correct empty/no-op behavior without a phantom column; it leaves packaging open. Mandating separate public functions now would constrain implementation without a demonstrated consumer benefit. The suggested simple shape remains an available implementation choice. This advice is resolved as no plan change, not outstanding deferred work. | Existing Section 5.5; S05/R14 |
| General Assistant suggestion 1 (`GA01`) | Adopted. Require `P : Finpartition s`, `e : I ≃ P.parts`, and `(e i).1 = blocks i` for every supplied label. This makes composition with VPS labels explicit. `Finpartition.equivSigmaParts` has a different carrier-to-sigma role. | Section 5.2; S02-B/R06 |
| General Assistant suggestion 2 (`GA02`) | Adopted. Add an all-columns selected-family call at `F = Finset.univ` on a constant-row three-column channel with masses `1/6, 1/3, 1/2`; check empty complement, cardinality one and comparison to independently specified `allOnes`. Reuse the fixture for the prescribed single-fiber interface. This reaches a boundary not forced by nonadjacent or multi-fiber fixtures. | S05-B/R14; C12 handoff |

The parent rechecked the pinned induction signatures, `Finpartition.equivSigmaParts`,
C06 row-relabeling declarations and C08 transport's fixed input type. A separate
read-only helper checked the GA suggestions and input-reindexing interpretation;
this was revision assistance with parent context, not installed independent review.
It confirmed that a direct selected-family all-columns call exercises the empty
complement even if the fiber wrapper later uses a different implementation.

Revision 2 preserves seven steps, 21 step criteria, R01-R18, CC01-CC08, the exact
manuscript anchors/OM-071 repair and downstream ownership. The adopted refinements
do not change mathematical hypotheses, numerical domains, production module
allocation or C11-C13 scope. DG-11 still awaits approval. Existing mapped deferrals
retain their owners/triggers; no numbered Future Work Note or omission ID is added.

The exact revision-1 proposal and before-images are preserved under
`.pfr-review/setup/c10-plan-revision2-20260928/`, alongside the current request,
advisory provenance and task-relative validation. The earlier report and failed
formal-admission record remain untouched. Revision 2 does not repair that record,
claim its formal reconciliation or inherit independent revision-2 acceptance.
No review session, mathematical implementation, dependency/tool change, commit
or push is authorized by this revision.

Fresh validation for this revision: incremental `lake build` passes (2762 jobs).
The task-relative document diff, stable identifiers/counts, new links, placeholder
scan and whitespace checks are audited. The before-images distinguish these
eight Markdown edits from the inherited working tree. All maintained Lean,
closed plans, pins and installed review records/tools remain unchanged.

## Approval and S01 readiness - 2026-09-28

The lead endorsed the delivered revision 2 and explicitly asked not to start
implementation yet. The endorsed proposal's SHA-256 is
`acee6544f8bd1ddb8470596152644ad52bdaabb750b7a1e793b3943846f31aa7`;
its exact bytes remain in the revision-2 delivery evidence. This update records
approval and readiness without changing the mathematical contracts or incrementing
the revision number. It reserves the documented editorial status region before
any execution registration. Endorsement resolves DG-11's partition choice;
C10-S02 still owns implementation.

The lead reaffirmed judgment during authorized work: improve proof routes,
organization and plan details when evidence warrants, preserve the reviewed
originals, record the reasons and review the resulting work. The existing AGENTS
rules and plan section 11 already support this. Changes to mathematical meaning,
scope or acceptance require the lead; routine improvements do not need a new
approval round. The seven steps retain separate requests and reviews.

The readiness check found S01's named C07-C09 recovery, path, output-equivalence,
seed and preservation prerequisites in actual source. All 70 maintained Lean,
tooling and environment files match the previous revision-2 baseline, so that
turn's successful incremental `lake build` (2762 jobs) remains applicable; no new
build or proof probe was run for this status-only update. The installed read-only
inspection succeeded. An ordinary read-only helper independently inspected the
prerequisite names and absence of C10 implementation; this was not an installed
independent review.

No C10 mathematical module, execution session or step has started. Revision 1's
original review and formal-admission limitation remain unchanged; approval does
not rewrite that history or assert an independent revision-2 review. Private
evidence under `.pfr-review/setup/c10-approval-20260928/` retains the exact user
message, before-images, source identities, read-only inspection and final status
diff/checks. S01 is ready for the lead's explicit request.
