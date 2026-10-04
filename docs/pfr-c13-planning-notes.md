# PFR-C13 planning notes

**Status, 2026-09-30:** [Revision 2](plans/pfr-c13-exact-partitions-incidence-systems.md)
is **Active** at S06. All five earlier steps are durably complete with their
original reports reconciled; all 153 S05 final entries match at startup.
S06 cumulative validation and independent review pass; all three criteria are satisfied, and the original report is reconciled. Final applicability, F and durable closure follow this pre-F checkpoint. C14/C15 remain unstarted.
The [readiness audit](pfr-c13-readiness-audit.md) maps current mathematical coverage;
[implementation notes](pfr-c13-implementation-notes.md) own exact execution evidence.
Original setup and [advice dispositions](#revision-2-advice-dispositions) remain
historical. No independent plan review is claimed.

## Verified C12 handoff

The parent ran the installed read-only inspection from the checkout. Its full
result is `.pfr-review/setup/c13-planning-20260930-inspect.json`. HEAD remains
`54c1714d1a9a891939d6c9f7d38c0d05896b2c75`; inherited tracked/untracked work
is preserved. LeanInfoTheory v0.1.0, mathlib and all installed dependency pins
are clean and match the manifest; Lean remains v4.33.1.

The parent read C12's actual journal through the installed `Store`/`Journal`
interfaces. Revision 157 has all five steps closed, no active step, pause,
cancellation, plan restriction, external blocker or substantive decision
obligation. All fifteen closing criteria are SATISFIED. All six original
reports are VALID, have no findings, and have explicit reconciliations.

| C12 S05 record | Exact durable reference |
| --- | --- |
| Closure | `1451fe774e1e68737a7e152022d1c7203ffd3d48f46292aa9e750c5cebf4fa0e` |
| Final source F | `aacc8e9d3d25a3eafb818f3ad3dfffbf2e91b31686c873dcae2508e69ba43744` |
| First original cumulative report | `1e9e9f9a21440f05c7eb3eea7f3ef8efc444563ce21ad9c93fcf5d4253b26224` |
| Linked original assessment | `e180d5ff679b85801771c326931c5fe98eeb89aa7d4ee3dab4ea769fd7a1575a` |
| First reconciliation | `d3aad49da467cc0cb21272a81e3b4e16508d714b50a4851f6f8a40ce3e0d7bd6` |
| Linked reconciliation | `7949802da8ec8061e106dccc16671b865ad10005e31148a711dc68f7bf004d9a` |
| Final PASS evidence | `69e65610179be2691a7898340348b96d90fe368879aeec6aac16672df4320e2d` |

The first cumulative report's original two `NOT_ESTABLISHED` assessments
concerned future workflow acts. They remain unchanged. The linked report
satisfied review-time criteria while retaining final duties; the later durable
record completes CC09/C12. Original C12 plan, implementation/readiness notes and
log entry 144 retain their historical pre-F wording. Initialization reopened no
proof or review step.

Before planning-document edits, `project_source.snapshot` with F's six explicit
dependency files matched **all 145 entries**, including `@environment`, with
no additions or differences. The journal observation and complete comparison
are preserved in `.pfr-review/setup/c13-planning-20260930-c12-journal-observation.json`
and `...-handoff.json`. The initial read-only snapshot call mistakenly passed
the scope object rather than its `explicit_files` list and was refused with
`SOURCE_SCOPE_MUST_BE_FILE_LIST`; the corrected call succeeded without modifying
source or workflow state.

This verifies source applicability of C12's closing evidence. It is not a fresh
C12 exhaustive trust audit or new independent acceptance. Fresh planning builds
separately passed: four focused targets (2,781 jobs) and `lake build` (2,762 jobs).
Lake reused available artifacts.

## Persistent C13 reviewer

No C13 binding existed. Before creation, the parent saved the exact user
attachment and neutral bootstrap intent in
`.pfr-review/setup/c13-planning-20260930-bootstrap-intent.json`.
The actual native request used `model="gpt-6-astra"`,
`reasoning_effort="ultra"`, `fork_turns="none"`. Its complete creation result was
`{"task_name":"/root/pfr_c13_reviewer"}`.

The supported `project.bind` operation created
`.pfr-review/chunks/PFR-C13/binding.json` with originating task
`01a0f1b4-e5ca-7742-b5d3-ed5e37838d41`, parent role `/root`, and that exact
canonical reviewer. The packet and both original acknowledgment events are
retained in setup records. The reviewer reported that it inspected no files
and is waiting for an exact source-bound request.

Requested settings are recorded separately from unknown effective settings.
Read-only behavior is instruction-level, not OS isolation, as accepted by the
installed supervised procedure. No reviewer was transferred from another chunk
or diagnostic task. The C13 store has a binding only: no plan-review session,
execution session or dispatched review request. Planning assistants supplied
API/manuscript research to the parent; none of that context was sent to the
persistent reviewer. Their work is not an independent plan review.

## Manuscripts and mathematical findings

The manuscript assistant used the PDF skill, authenticated both full hashes
listed in the plan, freshly extracted and rendered ISIT p.4 and extended v16
pp.5-7, and visually inspected the relevant passages. The parent read the
relevant extracts and checked the proposed contract against local Lean source.
Ignored artifacts remain under `tmp/c13-planning/manuscript/`; no manuscript
binary, extract or render enters maintained documents or private review records.

The source repair is explicit: use full nonzero-pattern/all-partition indices
with zero-padded values, or occurring-pattern/admissible-partition indices.
Nonnegative equality feasibility admits restriction/zero-extension with inverse
laws. Signed equality can cancel on absent rows; inequalities and optimization
are not included in this equivalence. `P H` is a rectangular all-ones matrix.
Equality and a chosen input normalize partition weights; per-input value
normalization never means total pattern-value normalization.

An exact `Fraction` checker passed the complete three-input five-partition
enumeration and all 35 source incidence entries, plus structural identities and
the discriminating fixtures in plan R05-R10. The pair-only data with values
`1/2` have no admissible partition, while the mixed encoding admits weights of
total `3/2`. A negative singleton-partition coefficient makes the full signed
equations hold, demonstrating why nonnegativity matters. All seven patterns
with value `1/4` admit a feasible vector with one zero coefficient, so the
positive-support construction must retain every output pattern while discarding
that partition. These are computational planning checks, not Lean coverage.

## Public API discovery and bounded compiling probes

The API assistant searched actual C10 partition/synthesis, C11 characterization,
C12 reconstruction and earlier semantic declarations. It consulted the pinned
LeanInfoTheory API manifest, declaration index, module guide, theorem highlights
and relevant public source, plus pinned mathlib. The parent checked actual
`CompressedPatternData`, `Finpartition` adapters, phase/cascade types, C10
constructor signatures, C11 iff endpoints and the C12 ambient bridge.
No genuine LeanInfoTheory discoverability friction arose, so that log is unchanged.

All three final probes pass with recorded `LEAN_EXIT_CODE=0` and no diagnostics:

| Probe and retained log | Established | Limitation |
| --- | --- | --- |
| `tmp/c13-planning/api/Interfaces.lean`; `Interfaces.verified.log` | Intrinsic nonempty-pattern, whole-input Finpartition and admissible-subtype types; finite instances without nonempty admissible assumptions; dependent zero-padded values; full/reduced Real matrix types; correctly typed `P v` / `P H` targets; arbitrary `Fin` reindexing; exact public declaration signatures. | Matrix identities, feasibility equivalence and counting theorems were typechecked as targets, not proved. |
| `tmp/c13-planning/api/Consumers.lean`; `Consumers.log` | Generic normalized Real-to-NNReal/ENNReal conversion; actual `multiPpsOfENNReal` consumer and `.cascade` with a supplied target enumeration/coordinate equation; positive-support equivalence; public coordinate-marginal/atom access; Real mass sum over `q.supportFinset`. | Total normalization and endpoint coordinates are supplied in this generic probe. It does not construct the C13 VPS/PPM phases or extract incidence weights. |
| `tmp/c13-planning/api/Endpoint.lean`; `Endpoint.log` | Actual all-ones PPS endpoint for a positive normalized family, complete label equivalence after removing the empty unaffected summand, derived whole-input column carriers, `Finpartition.copy` transport with unchanged parts, and actual `multiVpsFamily` with its sigma labels and coordinates. | Weights and partitions are supplied; no C13 feasibility, block-map surjectivity or final PPM theorem is proved. |

Useful verified declarations include `coordinate_eq_of_posterior_support`,
`PMF.mem_support_map_iff`, `PMF.mem_support_channelJoint_iff`,
`PMF.sum_toReal`, `Finpartition.existsUnique_mem`,
`Finpartition.nonempty_of_mem_parts`, `Matrix.submatrix_mulVec_equiv`,
`Matrix.mulVec_mulVec`, `Finset.sum_eq_zero_iff_of_nonneg` and `Equiv.sum_comp`.
The probes also check `Finpartition.ofSetoid` and its fiber membership laws as
an alternative local route; the proposed contract retains C10's established
labelled-block boundary. General Finpartition enumeration has poor computational
cost, so concrete tests use explicit partitions and coverage proofs.

Two failed consumer attempts are preserved as `Consumers.initial-failure.log`
and `Consumers.second-failure.log`. They record a Real/NNReal coercion mismatch,
two rejected guessed names (`Finpartition.eq_part` and `Finpartition.part_eq`),
and an ambiguous subtype sum predicate. The final proof rewrites
`NNReal.coe_sum` before unfolding, uses verified part lemmas and supplies the
subtype predicate explicitly. No hypothesis was weakened. Import loading was
slow on initial runs; no timeout was treated as a pass and no toolchain was changed.

The final endpoint probe initially exposed the anticipated semireducible
`Fin 1` versus `allOnes.outputCard` mismatch. One repair uses an explicit
complete label equivalence and the actual PPS coordinate equations to derive
the carrier equality. The public `Finpartition.copy` keeps the parts unchanged,
and the subsequent VPS consumer compiles. `Endpoint.initial-source.log` and
`Endpoint.initial-failure.log` preserve the first attempt. This informed S04's
explicit early consumer requirement without changing the mathematical contract.

## Revision-1 parent draft assessment and dispositions

The parent critically checked mathematical strength, dependency order,
representation feasibility, zero/empty cases, full/reduced correctness,
consumer imports and C14/C15 boundaries before delivery. This is a parent
assessment, not the separately requested independent plan review.

- Necessity cannot cite C11's iff as if it extracted weights: its construction
  internals are private. S03 instead uses the public common posterior and the
  existing decoder-support lemma, then aggregates supported decoder masses.
- Sufficiency must establish surjectivity onto every occurring pattern before
  `multiPpmFibers`. S02 derives that from positive values and feasible equality;
  S04 retains the actual phase labels, coordinates and directed endpoint.
- Typing `P H` with matrix `1`, adding `Nonempty J`, or assuming a normalized
  sum of all pattern values would change the mathematics. The draft explicitly
  excludes those shortcuts and gives corresponding regressions.
- S03 and S04 separate extraction and synthesis because they have different
  risks. S05 completes fixtures/readiness; S06 freshly checks every earlier
  criterion and requires cumulative independent assessment plus subsequent
  final applicability/F/closure. No missing theorem is reserved for closeout.
- C12's optional compression-idempotence alias has no consumer pressure here:
  the existing extraction/reconstruction, presentation and perfectness bridges
  suffice. Its original deferral remains owned by C13-S04/S05 at an actual
  integration need; it is not an implementation promise.

Existing OM-014/017/019/025/027/042/044-047/051/052/068 and DG-12 carry the
relevant source dispositions; later optimization/extended-only owners remain
unchanged. No numbered Future Work Note is needed. DG-12 stays Open pending
exact-plan approval. No substantive mathematical choice remains unresolved by
this planning pass; proof feasibility beyond the bounded probes remains an
implementation obligation. No independent review, execution registration,
dependency/tooling change, commit or push occurred.

## Revision-1 delivery checks

The parent verified that all 46 maintained Lean files and every existing
non-owned entry of the C12 final inventory are unchanged. The original project
log is preserved as a prefix, all 71 omission IDs remain, DG-12 remains Open,
and the C13 binding has no plan-review or execution session. Local Markdown
links, whitespace, the strict placeholder scan, tracked generated-file checks
and ignored scratch/private-record checks pass. The parent also reran the
exact-arithmetic fixture checker successfully. Only the two new planning
documents and six owning status/history documents are changed by this task.
The retained planning validation records distinguish these checks from prior
C12 audits and from independent review, which has not occurred.

## Revision-2 advice dispositions

The lead first requested the parent's assessment without edits, then supplied
the General Assistant's **Independent advisory review — PFR-C13**, and finally
authorized selecting and applying the best subset. P01-P04 below identify the
four suggestions in this thread's parent assessment; GA01-GA03 identify the
numbered suggestions in the pasted advisory. These are distinct advice sources,
not findings from the bound reviewer and not implementation approval.

Revision 1's exact bytes and all eight owning documents were preserved before
editing under `.pfr-review/setup/c13-revision2-20260930/before/`. The original
plan SHA-256 is
`da4c4b8c5c40e906add92f6f08a4ffe27f0e2d23f68ead5ce0619e18857ad8b8`.
Earlier delivery evidence and the original log entry 145 remain unchanged.

| Advice / original suggestion | Disposition and reason | Owner / acceptance |
| --- | --- | --- |
| P01: the repeated complete partition image requirement is impossible for distinct supported decoders into C12's distinct pattern labels. | Adopt the correction. Fiber-pattern equality makes the decoder recoverable from its partition. Generic finite-sum aggregation may remain, but no impossible fixture or public injectivity theorem is required. | Plan §4.4, S03-B; R13 tests different partitions sharing one block. |
| P02: add valid data with nonempty admissible family but no nonnegative solution. | Adopt. The pair-only example tests an empty family; it cannot detect accidentally replacing feasibility by existence of any admissible partition. All-seven-pattern values `1/8` on singletons/whole input and `3/8` on pairs force all-singleton weight `-1/4`. | R14: S02 algebra, S04 characterization consumer, S05 full classification. |
| P03: add a positive proper full/reduced fixture and require diagnostic tests during S02; proposed weights `(1/4,1/4,0,0,1/2)` give a `5 × 3` reduced system. | Adopt the purpose and earlier timing, but omit that separate numeric fixture. GA03's shared-block case already reduces both rows and columns (`7 × 5` to `4 × 2`) and also tests S03/S04. A second positive fixture adds little coverage. This is a resolved selection, not a deferred task. | S02 validation, R06-R08 and R13; exhaustive global classification stays in S05. |
| P04: prove usable coefficient-specific specifications for the same returned construction, and check the actual VPS-to-PPM label map early. | Adopt. `NormalForm` lacks explicit supplied-coefficient and semantic-label fields; unrelated existence statements do not establish the required public interface. Existing labelled results plus specification lemmas suffice; no new bundle is mandated. | Plan §4.5, S04-A/B and the public construction consumer. |
| GA01: replace repeated partition images by distinct partitions sharing a block; do not require a new public injectivity theorem. | Adopt with P01. The repeated-image issue is an acceptance correction; R13 exercises the intended accumulation without contradicting the decoder contract. | Plan §4.4, S03-B, R13. |
| GA02: R08 must distinguish full rejection, reduced acceptance after restriction, and failure to recover the original infeasible full vector. | Adopt exactly. `(1,0,0,0,2)` fails absent singleton rows, its one-coordinate restriction is feasible, and zero extension is `(1,0,0,0,0)`. Section 4.3 already assumes full feasibility in its recovery law and needs no weakening. | R08, checked in S02 and integrated in S05. |
| GA03: retain R09 for zero coefficients and add weights `1/3` on all singletons, `2/3` on `{01,2}` for a genuine final PPM merge. | Adopt. R09's positive partitions have disjoint block families, so its final merge is a no-op. R13 has two PPS outputs, five VPS leaves and four final patterns; the unequal `{2}` columns merge to value one. This also fulfills P03's proper full/reduced transport objective. | R13: S02 equations/transport, S03 explicit two-decoder witness, S04 actual synthesis and one PPM operation, S05 integration. |

The selected revision preserves six steps, eighteen criterion IDs, the full/reduced
nonnegative equality contract, empty-family handling, row-derived normalization,
public-witness necessity, actual coefficient-specific synthesis and C14/C15
boundaries. It adds R13-R14 and updates all regression cross-references.
The advice has concrete plan owners; no new Future Work Note or omission is needed.
DG-12 remains Open pending exact-plan approval. The persistent reviewer remains
idle, with no source-bound review or execution session.

### Revision-2 checks and limits

The parent independently checked the advice against the stated contracts and
exact rational arithmetic. `tmp/c13-planning/revision2/check_fixtures.py` passes:
it reuses the original 35-entry/five-partition checker and checks the exact R08
distinction, R13's `4 × 2` transport and shared-block sums/counts, R09's singleton
merge fibers, and R14's forced negative coefficient. The unselected `5 × 3`
fixture also checks correctly; redundancy is the reason for omitting it.
These are computational planning checks, not C13 Lean proofs or constructed paths.

A bounded API follow-up inspected `NormalForm` (`Matrix/OperationPaths.lean`,
line 240), `LabelledOperationResult` (`Matrix/MultiwayOperations.lean`, line 31),
`multiVpsFamily` (line 771), `multiPpmFibers` (line 1231) and
`multiPpmFibers_length` (line 1535). It confirmed the actual output-index map,
dependent block correspondence, surjectivity and equal-support obligations;
the length law gives one merge for the proposed five-to-four-column fixture.
This was factual planning support, not an independent plan review or a compiled
C13 fixture. The original endpoint probe stops at PPS-to-VPS coordinates;
VPS-to-PPM integration remains a stated implementation obligation.

The General Assistant reported successful reruns of all three original probes,
exact-arithmetic checks and manuscript inspection, and explicitly reported no
full project build or implementation. Those claims retain their advisory
provenance; they are not presented as new parent-run probes or installed-review
evidence. The parent did not rerun the unchanged Lean probes in this revision.

A fresh `lake build` passes (2,762 jobs, exit 0), reusing available Lake
artifacts; its log is `tmp/c13-planning/revision2/default-build.log`. This
documentation revision changes no maintained Lean source or dependency.
Final inventory checks confirm only the eight owning documents changed; all
132 other inventoried files, including 46 maintained Lean files, are unchanged.
Revision-1 bytes, the original log prefix, all 71 omission IDs and open DG-12
are preserved. Local links, whitespace/diff checks, the placeholder scan and
tracked-artifact checks pass. C13 still has only its binding and ownership marker,
with no review or execution session. The retained validation record is
`tmp/c13-planning/revision2/final-validation.json`; its final copy is preserved
with the revision archive. Initial validation-script assumptions about the
number of revision pointers and the ownership marker were corrected; an
accidental CRLF rewrite of two documents was restored to their original LF
format before the successful final checks.

## Lead endorsement and S01 readiness — 2026-09-30

The lead endorsed the presented revision 2 and emphasized intelligent use of
the plan and review procedure, including justified changes during a step.
The lead also explicitly said, "No need to start implementation yet, lmk when
you are ready for step 1." The exact message and endorsed draft hash
`75ab649f3f120b35f21fe244e0bc358c807877561c66a6ae3ff00e0dcd3c0084`
are preserved in `.pfr-review/setup/c13-approval-20260930.json`.

The plan is now Approved, awaiting an S01 request. Its existing revision policy
already permits justified proof-route, organization and test improvements,
with documented reasons and review of the actual resulting work. Substantive
changes to mathematical intent, scope, hypotheses or acceptance still require
the lead. No mathematical contract or criterion changed in this status update.
Approval resolves DG-12's design choice; the C13 proofs remain unimplemented.

Before these status edits, all 140 entries of the preserved revision-2 final
inventory matched exactly. A bounded read-only API check confirmed S01's
unchanged C10/C12 interfaces and no new source blocker. The three successful
planning probes and latest 2,762-job default build remain applicable to the
unchanged mathematical sources; no fresh build or probe was needed or run.
Counting, indicator and reindexing proofs remain S01 work. No incidence module
was created, execution session opened, or review dispatched. S01 is ready for
a separate request, and implementation remains unstarted.


## S05 advice-trigger reassessment, 2026-09-30

The selected revision-2 advice is exercised by the complete paper fixture:
P04 retains same-construction specifications; P02/R14 has all five admissible
partitions yet no nonnegative solution; P03/GA03 uses the proper 7-by-5 to 4-by-2
R13 system and its actual unequal-column merge; P01/GA01 use shared blocks;
GA02 checks R08 full rejection, feasible restriction and changed zero extension.
No second 5-by-3 fixture or supported-decoder partition collision is needed.

The original optional C12 compression-idempotence alias (C12 plan Section 9;
this document's earlier reuse note and the S04 implementation notes) was
reassessed at its S05 consumer trigger. The actual inactive Option output
consumer uses compressedPatternData_map_injective and D.extraction_roundTrip
with the exact complete data record. No alias is needed by the integrated
C13 consumers, so the suggestion is declined for C13 rather than left as an
unowned deferral. A later chunk may reopen it upon a concrete consumer that
needs a distinct ergonomic interface. This preserves the original reference
and does not change C12's closed records. C11 private-helper promotion likewise
has no trigger: the public semantic route already proves necessity.
General Bell enumeration, algorithms and C14/C15 optimization remain with their
existing omission/plan owners. No numbered Future Work Note is opened.


## S06 cumulative advice and boundary check, 2026-09-30

Fresh source assessment retains the revision-2 selections and the S05 alias
disposition. R08 distinguishes the original full vector from its feasible
restriction; R09 exercises zero coefficients; R13 exercises shared incidence
and an actual unequal-column merge. R14 keeps the accepted nonempty-family
nonnegative obstruction. The actual public construction preserves supplied
coefficients and all three endpoints. No concrete consumer reopens the C12
alias or C11 private-helper proposal. All worthwhile omitted work keeps its
existing map owner and trigger; no new Future Work Note is needed. C14/C15's
optimization and separator obligations remain unstarted. Only supported
S06 closure completes C13; the current audit does not certify future acts.
