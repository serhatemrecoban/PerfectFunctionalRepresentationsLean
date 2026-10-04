# PFR-C10 readiness audit

**Status, 2026-09-29:** S07 fresh cumulative independent review and reconciliation complete; final validation/closure checkpoint.
S07 startup verified all six original reports/reconciliations, eighteen satisfied
criteria and all 141 final source/environment entries. This document now covers
the complete cumulative closeout scope. The fresh independent report satisfies
all three current criteria and is critically reconciled. Its one optional
stale-status finding is corrected in the living summary. Final
applicable validation/F and supported durable closure remain; only that later
record completes CC08 and establishes C10 completion.
The [approved revision-2 plan](plans/pfr-c10-generic-reachability-easy-direction.md)
owns the contract. [Implementation notes](pfr-c10-implementation-notes.md) own
dated checks, original reports, reconciliation and finalization evidence.

## Source identity and mathematical boundaries

The six-page ISIT manuscript has SHA-256
`48963aa59485b2c33b1a1e6e7c6ead2251fdddd26bd3691b6fcffe683e6ed1c4`.
The designated extended v16 manuscript (18 pages, version designated 2026-09-03)
has SHA-256 `98636d4c9f0618ec08fca84559572780f604f197fda90d8d7c787b3624245b8f`.
Exact local paths are retained in the approved plan. S06 visually reread ISIT p.4
and extended pp.4-6, including the right-column conclusion (32) on p.5. S07
freshly authenticates and renders ISIT pp.3-4 and extended pp.4-6 for cumulative review.
Current source checks authenticate both PDFs; local media remain ignored.

| Manuscript anchor | Formal boundary and owner |
| --- | --- |
| ISIT p.4 III-B, repeated-operation paragraph, Theorem 1 “if”, Lemmas 5-6 inverse prose; extended p.4 III-B | S01 folds the existing C09 implications over supplied paths; remembered C07 recovery reverses each actual edge. Both restrictions and directed output comparisons are explicit. The theorem assumes finite nonempty input, active finite outputs and no input prior. |
| ISIT p.4 IV-A sets of nonzero patterns summing to all-ones; extended p.4 after (24), p.6 construction instruction 2 | S02 uses exact finite partitions of support finsets, with nonempty disjoint blocks, exact coverage and a bijection from supplied labels. S04 constructs finite legal VPS paths from those supplied partitions, including value one. |
| ISIT p.4 IV-A instruction 1; extended p.4 construction after (24), p.6 instruction 1 | S03 assumes supplied finite normalized weights. Positive support removes exactly zero weights; ENNReal masses round-trip exactly through NNReal. C13 retains deriving normalization from incidence feasibility. |
| ISIT p.4 IV opening and IV-A instruction 3; extended p.6 instruction 3 | S05 merges supplied equal-pattern selections/fibers. Empty selection is a no-op; unused labels are excluded by range and restored as zero by inclusion. C12 retains choosing all equal-pattern classes and compressed Real data. |
| Extended p.5 Example 6 (25)-(32) | S06's private fixture checks printed rows, value/pattern presentations, four legal operations, explicit (30) output swap, actual reverse certificate and easy perfectness. This is the reduction example; ISIT's differently numbered Example 6 concerns partitions and remains with C13. |
| Three Section IV construction instructions and C08 Lemma 4 | S06 combines the public constructors, independent endpoint matrices, original labels and actual normal-form witness. C11 still supplies canonical decoder fibers; C13/C14 retain incidence, enumeration and optimization results. |

The generic singularity fold retains its source premise for a nil path. Positive
and negative preservation use exactly their allowed operations. Witnessed reversal
does not assert a global inverse, unique mask or involution on proof data. All
matrix states retain active outputs; zero weights and empty pieces never become
active columns. Every primitive PPS ratio is strict; VPS permits value one under
the approved C07 interpretation. All endpoint comparisons specify their direction.

## Maintained API and pinned reuse

| Module | Public boundary exercised here |
| --- | --- |
| [Matrix/Reachability.lean](../PerfectFunctionalRepresentations/Matrix/Reachability.lean) | `OperationKind.reverse`; step/path/cascade `reverse` and tag/length/restriction laws; positive/negative folds and reflection; `FromAllOnes`, `ToAllOnes`, transport, direction equivalence and both prior-free easy implications. |
| [Matrix/Partitions.lean](../PerfectFunctionalRepresentations/Matrix/Partitions.lean) | `partitionOfBlocks`, `partitionOfBlocksEquiv`, `partitionOfBlocksEquiv_apply_val`. The carrier alphabet has no finiteness or decidable-equality premise; labels need only `Finite`. Pinned `Finpartition` supplies the invariants. |
| [Matrix/MultiwayOperations.lean](../PerfectFunctionalRepresentations/Matrix/MultiwayOperations.lean) | `LabelledOperationResult` retains endpoint, actual path, homogeneous tags, full label equivalence and all coordinates. `isSingular`, `outputCard`, `outputEquiv`, `cascade` consume that same witness. |
| Same module, PPS | `multiPps`, `multiPpsFamily`, nonnegative and ENNReal adapters; positive-support sum/nonempty/map/off-range laws; selected cardinality, length, singleton and admitted value/pattern specifications. |
| Same module, VPS | `multiVps`, `multiVpsFamily`; selected cardinality, length, singleton, exact block pattern, unchanged admitted value and complementary data. |
| Same module, PPM | `multiPpm`, `multiPpmOrEmpty`, `multiPpmFibers`, `multiPpmRange`, `multiPpmRange_map`; selected/fiber lengths, exact value sums and patterns. Range construction needs no finite ambient label type. |
| [Matrix/OperationPaths.lean](../PerfectFunctionalRepresentations/Matrix/OperationPaths.lean) and [OperationFactorization.lean](../PerfectFunctionalRepresentations/Matrix/OperationFactorization.lean) | Existing C08 `OutputEquiv`, `Cascade.comp`, homogeneous restrictions, `NormalForm` and public `Cascade.normalize`; no private C08 declaration is used by the new consumers. |

LeanInfoTheory remains immutable `v0.1.0` at
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`; mathlib remains
`0df444a360eaa60ab8c11dca51a86af692955474`, on Lean `v4.33.1`.
The earlier compiling probes and production proofs verify pinned finite induction,
sum/subtype/range and equivalence APIs, `Finpartition.ofExistsUnique` and its
membership/disjointness/coverage/singleton laws, ENNReal conversion and finite-sum
laws, and LeanInfoTheory's supported PMF map laws. `Finpartition.equivSigmaParts`
alone does not supply original block labels; the three-declaration adapter does.
S06 adds public consumers and private fixtures, with no replacement probability
construction or generic information-theory theorem. No new discoverability issue
or dependency upgrade is proposed.

The mathematical root stays lightweight. Reachability imports only the existing
path and preservation modules; Partitions imports pinned finite partitions;
MultiwayOperations imports paths, partitions and the two justified foundational
field-sum/finite-option modules. Examples and integrated tests stay separately
importable. Classical selection extracts actual witnessed data from Prop-valued
finite induction; specifications refer to that selected witness.

## Regression crosswalk

Source references below identify maintained tests; the frozen review inventory
and validation records bind their exact bytes. All earlier test files are preserved
exactly from S06 B.

| ID | Source and discriminating check |
| --- | --- |
| R01 | [Tests/Matrix/Reachability.lean](../PerfectFunctionalRepresentations/Tests/Matrix/Reachability.lean), seed/nil consumers: both directions, singleton input/output, relabel-only cascade and explicit generic nil singularity premise. |
| R02 | Same module, one-edge recoveries: unequal PP weights, nonadjacent/final labels, value-one VP split and retained column; general endpoint map laws, independent PP/VPM row comparisons and discriminating VPS selected/retained coordinates. |
| R03 | Same module, mixed path and genuine cycle: reversed/swapped chronological tags, changed cardinality, length and directed endpoint comparison distinguish forward from inverse images. |
| R04 | Same module, generic folds and C03 counterexample: both allowed restrictions, positive/negative consequences, easy implications and direction equivalence; forbidden operation kinds excluded. |
| R05 | [Tests/Matrix/Partitions.lean](../PerfectFunctionalRepresentations/Tests/Matrix/Partitions.lean): singleton and three parts of sizes 3,1,2 in a proper carrier; unique membership, disjointness and coverage; overlapping, missing, extra and empty-block candidates rejected. |
| R06 | Same module: original-label bijection and inverse, supplied-block equations, nonempty active pattern, empty label/carrier boundaries and generic consumers without decidable-equality premises. |
| R07 | [Tests/Matrix/MultiwayOperations.lean](../PerfectFunctionalRepresentations/Tests/Matrix/MultiwayOperations.lean), selected PPS: weights 1/6,1/3,1/2, nonuniform residuals, every child entry, null rows and retained source column. |
| R08 | Same module, nonnegative/ENNReal adapters: singleton witness has zero splits, interspersed zeros and positive inclusion retain exact original masses, off-image zeros, rejection of all-zero/empty normalized families. |
| R09 | Same module, PPS family and relabel consumers: mixed child counts, all sigma labels, cardinality, independent five-cycle target; fresh synthesis on a nontrivially row-relabelled source compared with independently relabelled rows. |
| R10 | Same module, selected VPS: final source column on a proper support, three unequal noncontiguous pieces, exact block and complementary coordinates. |
| R11 | Same module, VPS edges: actual singleton no-op, admitted value one, null selected rows, masks differing outside support, and rejection of an empty selected-support piece. |
| R12 | Same module, VPS family: 2,1,3 block counts, original sigma labels, cardinality six, exact admitted values/patterns, genuine three-cycle transport and easy reachability. |
| R13 | Same module, selected PPM: nonadjacent source labels 0,2,4 of unequal values, final label included, exact sum 2/3, complementary columns and null row preserved. |
| R14 | Same module, PPM edges: chosen singleton has zero merges; actual empty wrapper retains all labels/nil path; generic all-columns 1/6,1/3,1/2 case has empty complement and an explicit all-ones comparison; arbitrary ambient range restores zero mass at unused labels. |
| R15 | Same module, prescribed fibers: grouping [1,0,1,2,1], distinct fibers sharing a pattern, exact sums/values/cardinality/length, independent five-cycle transport; all-columns source also consumed by single-fiber interface. |
| R16 | [Examples/Reachability.lean](../PerfectFunctionalRepresentations/Examples/Reachability.lean): every displayed coordinate (25)-(32), legal VPM/PPM/VPM/PPM path, (30) transposition, actual reverse cascade and easy perfectness. |
| R17 | [Tests/Matrix/Synthesis.lean](../PerfectFunctionalRepresentations/Tests/Matrix/Synthesis.lean): weighted PPS, supplied labelled exact partitions, prescribed equal-pattern fibers, exact composed independent endpoints and actual C08 normal-form consumption. |
| R18 | S03-S05 early public-family consumers retained in MultiwayOperations tests and implementation checkpoints; S06 Synthesis integrates original ENNReal/partition/fiber labels and explicit targets, with generic public consumers and no private-name access or later theorem assumption. |

## Criterion crosswalk

Each earlier criterion retains its independent satisfied assessment and durable
closure. S07 freshly reassesses all eighteen criteria below against current source,
manuscripts, pinned APIs and cumulative builds/trust evidence. Its independent
review has now separately assessed that full scope; the original report is reconciled.

| Earlier criterion | Current evidence and acceptance boundary |
| --- | --- |
| C10-S01-A | Reachability predicates, remembered reversal, directed transport, tags/counts; R01-R03 and R16. |
| C10-S01-B | Restricted positive/negative folds, both easy implications and equivalence; R04, R16-R17. No hard converse. |
| C10-S01-C | R01-R04, focused/default builds, signatures/axioms/imports and documented nil/recovery limits. |
| C10-S02-A | Pinned exact partition invariant and adapter proofs; R05-R06, labelled VPS in R17-R18. |
| C10-S02-B | Explicit original-label bijection and block equation, singleton/nonempty/empty boundaries, no extra decidability/decoder premise; R06/R18. |
| C10-S02-C | External consumers, build/trust/import checks and C11/C13 ownership; R05-R06/R18. No incidence or Bell-count implementation. |
| C10-S03-A | Actual strict binary PPS selected/family paths, complete labels and coordinates; R07/R09/R17. |
| C10-S03-B | Positive support, exact ENNReal conversion, impossible empty normalized input and singleton no-op; R08/R18. |
| C10-S03-C | R07-R09 plus S01 integration, activity/cardinality/singularity/admitted data, row/output transport and trust/import audit. |
| C10-S04-A | Exact selected partition synthesis, values/patterns/coordinates and complements; R10/R17. |
| C10-S04-B | Family sigma labels and legal nonempty primitive pieces, singleton/null/mask/value-one edges; R11-R12/R18. |
| C10-S04-C | R10-R12 plus reachability/transport, counts/activity/singularity and API/trust/import audit. Inclusive VPS retained. |
| C10-S05-A | Actual selected/prescribed PPM paths, sums, patterns, complements and complete labels; R13/R15/R17. |
| C10-S05-B | Empty/singleton/all-columns/range boundaries, arbitrary order and transport, same-pattern distinct fibers; R14-R15/R18. No global compression. |
| C10-S05-C | R13-R15, early/final public consumers, activity/cardinality/singularity and API/trust/import checks; prescribed-fiber C12 handoff. |
| C10-S06-A | Private Example 6 (25)-(32), every operation and coordinate, explicit (30) swap, actual reverse path and prior-free easy perfectness; R16. |
| C10-S06-B | Independent weighted/partition/fiber targets, original labels, directed cycle, composed path and actual public C08 normalization; generic later-boundary consumers; R17-R18. |
| C10-S06-C | R01-R18, earlier criterion/source/API/manuscript/trust and advice crosswalk, fresh S06 validation and reconciled original report; current S07 reassessment covers these collectively. |

| Completion criterion | Readiness evidence |
| --- | --- |
| CC01 | S01-A, R01-R03 and R16 actual reverse certificate. |
| CC02 | S01-B, R04 and R16-R17 perfectness from supplied paths. |
| CC03 | S02-A/B/C, R05-R06/R17-R18; DG-11 resolved with approved `Finpartition`. |
| CC04 | S03-A/B/C, R07-R09/R17-R18, exact support/weight conversion. |
| CC05 | S04-A/B/C, R10-R12/R17-R18, exact nonempty support partitions. |
| CC06 | S05-A/B/C, R13-R15/R17-R18, supplied fibers and empty/range behavior. |
| CC07 | S06-A/B/C: Example 6, all regressions, cumulative source/API/import/trust and omission crosswalk, owning documents. Fresh validation is recorded below. |
| CC08 | Fresh cumulative independent assessment and original-report reconciliation are complete with one optional stale-status finding, corrected here. Complete scope and subsequent duties are explicit. Final applicable checks/F and supported closure follow this checkpoint; only that later closure completes this row and C10. |

## Review history, advice and later owners

S06 startup verified all five closed steps' original review/reconciliation records,
fifteen satisfied criteria, production acceptance and no findings. Original reports,
negative observations and exact B/R/F snapshots remain in durable `.pfr-review/`;
their attributed summaries remain in the implementation notes. S05's final
inventory matched all 138 entries before the fresh S06 request was accepted.
Earlier skipped requests were not retried or reused.

The original revision-1 plan report remains preserved with six satisfied criteria
and one optional suggestion; its source-field format prevented formal admission.
Revision 2 was lead-approved after selective revision; no separate independent
revision-2 plan review is claimed. The retained reviewer and original records are
not replaced. Effective model settings remain unknown; requested settings were
Astra/ultra with no parent history.

| Original advice | Disposition and current owner |
| --- | --- |
| `pfr-finding:c10-pr1-001`; parent witness-extraction advice | Adopted in revision 2; S03-S05 use Prop-valued finite induction followed by coherent witness selection. Public result consumers verify actual data. |
| Parent `PA02`, early family/independent-target consumers | Adopted; preserved S03-S05 checkpoints precede larger fixtures. S06 integrates those interfaces under R17-R18; original chronology evidence remains separately attributed. |
| Parent `PA01`, input-reindexing clarification | Adopted; R09 synthesizes on distinguishable relabelled rows and checks independently relabelled targets. |
| General Assistant `GA01`, original block-label bijection | Adopted; S02 `partitionOfBlocksEquiv` and its block equation, integrated by S06. |
| General Assistant `GA02`, all-columns PPM boundary | Adopted; S05 R14 uses the generic constructor on all three unequal columns, empty complement and all-ones endpoint, then prescribed single-fiber reuse. |
| Parent `PA03`, empty-wrapper packaging | No extra plan prescription; S05's nonempty core and total empty wrapper meet the existing contract. Resolved choice, no deferral. |

The [formalization map](formalization-map.md) retains all 71 omission identifiers.
OM-014/044/068 finite labels and support boundaries are exercised through the
label equivalences. OM-024/070 preserve lower-survivor ordered indices. OM-027/042
keep numbered Example 6 intermediates private; promotion requires an actual named
consumer. OM-071 records the explicit (30) transposition, with the exact-order
third merge using indices (0,2). OM-038/045/052 retain positive support, nonempty
pieces, empty/no-op/range handling and supplied multiway constructors.
OM-049/050 preserve inclusive VPS without importing example-specific beta bounds.
OM-051 retains remembered reversal rather than a global inverse. C08 helper
promotion was unnecessary; S03-S05's private traversal remains local.

C11 planning/implementation must consume these interfaces for actual canonical
decoder fibers and the hard direction. C12 must choose all equal-pattern classes
and establish global compression/Real data. C13/C14 own incidence, normalization
from feasibility, Bell partitions and primal characterization. OM-010/011/012,
016/017/019, 022/023/037 and 043 retain the existing external equivalences,
complexity/count/prose and algorithmic omissions. Their owners and revisit triggers
remain as stated in plan Section 10 and the map. No numbered Future Work Note
is open; no new unowned suggestion is introduced by S06.

## Fresh validation and closeout boundary

Fresh parent validation passes for fourteen focused C10 production/fixture/test
and C06-C09 regression targets, plus default `lake build`. R01-R18 therefore
compile together, including the new Example 6 and integrated normal-form consumers.
The exhaustive signature/axiom audit covers all 1009 named constants owned by
the three C10 production and five fixture/test modules, including private/generated
declarations. Only `propext`, `Classical.choice` and `Quot.sound` occur. Anonymous
examples are checked by compilation. Source/artifact/driver hashes bind applicability.
Builds are incremental; the trust audit does not independently establish chronology.

All unowned B entries, earlier production/tests, normative plan, immutable pins,
lightweight root and installed workflow tools are unchanged. Placeholder, source,
manuscript-hash, link, whitespace and tracked-artifact checks pass; all 71 omission
identifiers and historical project-log bytes are preserved. Task-relative diff and
Git status were inspected; inherited changes are not attributed to S06. Superseded
failed probes and warning cleanup remain separately preserved. A preliminary source
capture during concurrent helper editing was correctly rejected as unstable; the
subsequent frozen-source check passes. No record or tool was patched to bypass it.

S06's contextual self-review and separate reassessment are complete. The bound
reviewer satisfies all three S06 criteria with no findings, and its complete
original report is critically reconciled. [Implementation notes](pfr-c10-implementation-notes.md)
record the independent checks and limits. Final applicable checks, F and supported
durable closure follow this maintained checkpoint; they remain separate acts.
After its closure, S07 still requires its own fresh eligible request and cumulative
independent review. No later step, commit or push is started here.


## S07 cumulative closeout checkpoint - 2026-09-29

The startup and initial-validation paragraphs below retain their earlier
checkpoints. The final S07 subsection records the subsequent independent review
and reconciliation; the durable execution record governs final closure.

S06 durably closed after its original report was reconciled and final validation
passed. S07 startup verified closure `b318a3f0c09eeaf12d3809a5d8eba39514a5e700d842e49a226d976d23e1e939`,
all six original reports/reconciliations, eighteen satisfied criteria and all 141
final source/environment entries. Earlier S06/pre-F statements above remain dated
evidence; they do not describe a still-open prerequisite.

The parent performs a fresh cumulative source, mathematical contract, manuscript,
pinned API, import and trust assessment. Contextual helpers refresh reachability/
partitions/Example 6 and multiway/integrated consumers; their advice is parent
assistance, separate from the bound reviewer's required fresh pass. The R02 wording
now distinguishes universal endpoint laws from explicitly numerical regressions.
No new mathematical contract or fixture is needed for that precision change.

Fresh focused/default builds and the exhaustive eight-module signature/axiom
audit are being run. The later original independent report, critical reconciliation,
required corrections/review and final validation/F/closure remain pending. C11-C16
retain their existing scope and require their own approved work; no later chunk,
commit or push is authorized by this closeout.


### S07 fresh cumulative validation

Fresh S07 cumulative validation passes: all fourteen focused production/fixture/
test and C06-C09 regression targets (2788 jobs), default `lake build` (2762 jobs),
and a newly run exhaustive signature/axiom audit of all 1009 named constants in
eight C10 modules. Only `propext`, `Classical.choice` and `Quot.sound` occur.
All eighteen earlier criteria, R01-R18 and CC01-CC07 have been reassessed against
current source, designated manuscript pages and pinned APIs. CC08's later report,
reconciliation, final validation/F and durable closure remain pending.

The task-relative changes are owning Markdown only. All maintained Lean,
normative plan, root, pins and tooling are exact; historical project-log bytes,
all 71 omission IDs and earlier originals/advice are preserved. Placeholder,
manuscript-hash, link, whitespace and tracked-artifact checks pass. Builds are
incremental; anonymous examples are checked by compilation. Contextual helper
audits are parent assistance, separate from the required independent review.
No new mathematical defect or unowned deferral is identified.


### S07 independent assessment and finalization boundary

The bound reviewer freshly reassessed the complete C10 source, all eighteen
earlier criteria, R01-R18 and CC01-CC08 review-time readiness. All three registered
S07 criteria are satisfied. Its one optional stale-status finding is corrected,
and the complete original report is critically reconciled. The fresh independent
review read the complete three production and five
fixture/test modules, relevant C06-C09/pinned APIs and the designated manuscript
pages. It explicitly reassessed all eighteen earlier criteria, R01-R18 and
CC01-CC08 review-time readiness. Its focused/default builds passed (2788/2762 jobs),
and its new exhaustive type/axiom audit covered 1009 named constants across eight
modules, including all 86 explicit production declarations. Only `propext`,
`Classical.choice` and `Quot.sound` occur. Builds were incremental; anonymous
examples were compiled. The full audit was archived and mechanically checked,
without a claim that every generated signature was interpreted line by line.

Optional finding `pfr-finding:c10-s07-001` correctly identified the current living
summary row that still called S07 unstarted. The parent adopted that correction
within the existing final-document duty. The row now identifies S07 closeout and
its remaining validation/F/closure duties; formal resolution follows current final
evidence. The original finding and negative evidence remain preserved. No Lean
change, new deferral or additional mathematical review is required.

Historical early-consumer sequencing and prior private closure/report preservation
remain separately attributed to verified parent records. The reviewer verified
all 140 ordinary inventory entries; the parent also checks the environment entry.
Unavailable `fitz`, an invalid Windows wildcard lookup and a pre-output absent log
remain failed observations, followed by separately recorded successful checks.
Requested effective reviewer settings and instruction-level isolation retain
their stated limits. This original report establishes review-time readiness;
subsequent supported closure alone completes CC08 and C10.


No mathematical correction or new deferred suggestion is required. All earlier
originals/advice and mapped owners/triggers remain preserved. Final focused/default
builds and source checks follow these owning documents; the newly run S07 exhaustive
audit will be checked for exact source/artifact/driver applicability. F and supported
durable closure then complete CC08 and C10. C11-C16 require their own approved
work and remain unstarted. No maintained files change after F.
