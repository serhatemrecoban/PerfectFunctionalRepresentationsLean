# PFR-C11 implementation notes

## S01 — Auxiliary law and supported pair labels

**Checkpoint, 2026-09-29:** implementation validated; independent review and
original-report reconciliation complete. Final validation/F and durable closure
follow this checkpoint.
The lead requested “great, do step 1 with its review process”. The approved
revision-2 plan is unchanged outside its reserved editorial status region.
Only S01 is authorized; S02-S06 remain unstarted.

The execution session captures the inherited working tree before S01 edits,
separately from HEAD `54c1714d1a9a891939d6c9f7d38c0d05896b2c75`. C01-C10 source,
review records, pins and workflow tools remain prerequisites. Fresh startup
inspection found all ten dependencies clean at their recorded pins.

The owned production file is `Matrix/CanonicalReachability.lean`. Its auxiliary
channel, posterior split, support-law transport, fixed-W perfectness and pair
label machinery remain private. The root stays lightweight.

Exact source anchors are ISIT Appendix (20)-(22), PDF p.5, and designated extended
version 16 (16)-(18), PDF p.4. Their identities are retained in plan Section 2.
Conditional formulas mean selected total law factorizations with agreement on
supported conditioning fibers. No equality of arbitrary null completions is
claimed. A positive posterior weight implies an active pair only when the original
output is active.

### Implemented contract and manuscript crosswalk

| Obligation | Private checked content |
| --- | --- |
| S01-A; ISIT (21), extended (17) | `auxiliaryChannel_apply`, `auxiliaryChannel_factor_apply`, `posteriorSplit_apply`, `bind_posteriorSplit` prove both all-atom formulas and the actual split composition. `auxiliaryChannel_map_fst`/`_map_snd` recover the original channel row and q. |
| S01-A; positive-auxiliary WLOG | `supportPrior_apply` reuses C02's normalized `inputSupportPrior` and its exact inclusion. `supportedAuxiliaryChannel_map` recovers every ambient pair atom. Existing PMF support/nonemptiness/normalization are reused directly. |
| S01-B; ISIT (20), (22), extended (16), (18) | `fixedW_perfect` proves independence, evaluation decoding and Markov perfectness for the specified W for every prior. `fixedW_pair_eq_channelJoint` identifies the pair law with the auxiliary channel. `fixedW_factorization` retains the deterministic projection posterior as a total channel-extension equality. |
| S01-B; supported law | `supported_product_include`, `supported_pair_include`, `supported_triple_include`, `supported_factorization`, `supported_factorization_include`, `supported_fixedW_perfect` carry that complete law through support inclusion. |
| S01-A; active labels | `auxiliaryChannel_active_iff`, `posterior_active_iff`, `posterior_support_iff`, `posteriorLabelsEquiv` and its three projection lemmas retain `(y,w)` exactly. A consumer instantiates this at `ActiveFiniteChannel.output_active`. Finite/nonempty active labels are checked without a prior. Decoder labels/partitions remain S02. |

The mass/support helpers work on arbitrary types; finiteness is imposed where
the existing information-theoretic predicate needs finite alphabets. Its two
private perfectness helpers expose `[Fintype alpha] [Fintype beta]` and
`[DecidableEq alpha]`. The last instance keeps the function alphabet's enumeration
consistent with each consumer. These are finite enumeration choices, not input
mass hypotheses, and do not alter the planned public `[Finite alpha]` boundary.
The remaining proofs use only law maps and existing PMF/channel interfaces.

The full pair/triple transports make the supported construction concrete rather
than relying on existential perfectness. A contextual scratch probe also checked
the pinned conditional-channel bridge on the actual prior-weighted conditioning
support. That optional probe is not a new maintained API or a claim at null
fibers. The maintained law equalities are the approved contract.

### R01-R03

One private `Fin 2` fixture takes q pure at the identity vector, V constant q,
and each channel row pure at its input. The swapped vector has zero q/V mass.
R01 checks its exclusion, support nonemptiness, exact supported atoms, positive
restricted masses, total mass one and exact inclusion. R02 checks zero pair
atoms, a positive atom, both label projections and distinct active labels.
R03 uses the pure prior at input 0: input row 1 is unused by that prior but
remains present in the channel. Both ambient and supported fixed auxiliaries
are perfect, the deterministic factorization holds, and the unused joint row
has mass zero. No full-support premise is supplied.

### Validation and scope

The focused build passed for `Matrix.CanonicalReachability`,
`Tests.Semantics.FunctionalRepresentation`, `Tests.Semantics.Canonical`,
`Tests.Semantics.Singularity` and `Tests.Matrix.Channel` (2783 jobs).
The default build passed (2762 jobs). A compiling scratch copy of the exact
production bytes prints signatures and axioms for all 39 named declarations;
only `propext`, `Classical.choice` and `Quot.sound` occur. The maintained file
and its anonymous consumers were compiled separately by the focused build.
The placeholder scan has no matches. The scope audit retains the old log prefix,
all 71 omission IDs and the exact normative plan. Git's whitespace check reports
no error; its existing LF-to-CRLF notices are informational.
Initial elaboration failures were limited to exposing the predicate's Fintype
instances, equality-instance alignment and explicit map/label rewrites; they
are retained in private iteration evidence. No mathematical contract changed.

The fresh prerequisite check matched 7 selected C02, 28 C06 and 99 C10 final
entries, including relevant completed plans and Lean modules; C10's root,
workflow and explicit pinned-source entries also match. Its environment equals
the current environment and all ten dependencies are clean. This is a targeted
applicability check, not reimplementation or a fresh cumulative C10 review.

The module imports only the two approved focused matrix modules. All named
declarations are private; regressions are anonymous in-module consumers.
There is no new public API, root import, partition, finite presentation,
operation path, theorem characterization or dependency/tool change in S01.
OM-021/045/048 are updated for this probability/support boundary; later
obligations retain their original owners and triggers. No new Future Work Note
or dependency discoverability issue is introduced.

### Independent review and finalization

The bound reviewer independently satisfies C11-S01-A/B/C with no findings.
The complete original JSON report is preserved, including all nine evidence
records and its explicit limits. Its source recheck matched all 136 requested
files; focused/default builds passed (2782/2762 jobs). It freshly elaborated
the exact module with all 26 anonymous examples, audited all 39 named signatures
and axioms, and compiled independent consumers that extract the actual intrinsic
q/V witness and instantiate supported perfectness from a `[Finite]` input
boundary. The sole consumer style warning is confined to reviewer scratch.

The parent critically reconciled each criterion: exact support and label laws
are covered; the all-prior statement retains the specified W and full triple;
build, trust, ownership and OM-021/045/048 evidence support S01-C. Independent
evidence does not replace final workflow closure. The earlier optional R14
advice remains adopted under S05/R14, with its original owner and trigger.

Exact references:

- S01 B: `62b96627c40d0e54150473b2591b0368a356b32dc8e579a09a9d761f42f57603`.
- Reviewed R: `63b04d87c155d164f200a049336326b2c2b158366466a0209e55684d5b77358e`.
- Original admitted report: `df8fd3feada6e85b946c0cdcc0d44bbdab9c7c30f1a66e49396956897a259465`.
- Original report text SHA-256: `006dcafa83732cdd8420d2dc8224d2715642694ab562a4415c9d4b19c528065e`.
- Original-report reconciliation: `232445444b1565d4515953d4d6827800df63972332fc5d4ddb6f0e78840c84a8`.

After R, the parent corrected only current-status prose and stale normalized
living-summary tables that still described S01 as unstarted. Historical approval,
planning and earlier chunk records remain preserved. The Lean module, imported
prerequisites, all normative plan text and pinned environment remain unchanged;
this bounded documentation correction does not invalidate the independent
mathematical assessment. Final applicable checks and source comparison precede
F and closure. S02-S06 remain unstarted; no commit or push is authorized.
Durable completion is governed by the subsequent `.pfr-review` closure record.


## S02 — Exact decoder partitions and shared active endpoint

**Checkpoint, 2026-09-29:** implementation and review in progress. The lead's
conditional S02 request was accepted only after verifying S01 durable closure
`c991d5b003d9c84bc79723632354bbf76d8f332b6cdb6d042b841b7bb88fbf09`, all three
SATISFIED criteria, original-report reconciliation and exact equality of all
137 final source/environment entries. The historical S01 pre-F text above is
preserved; S01 subsequently closed successfully. Only S02 is authorized.

S02 owns ISIT Appendix (23)-(28), p.5, and extended version 16 (19)-(24), p.4,
plus Figure 1's constant-value blocks and decoder partitions (extended p.5).
Fresh PDF hashes match the plan's recorded manuscript identities. The figure's
artwork remains omitted. The retained nonempty decoder fibers, indexed by their
original output labels, implement the intended partition; empty fibers and zero
q atoms contribute no column. The indexed uniqueness statement behind (28)
is stronger than counting distinct numerical values in a literal set.

The private endpoint is C06's active presentation of the auxiliary channel for
an explicitly supplied enumeration eA. S03 and S04 will take the same S, q, V,
hV, derived A and eA, so both constructions will be compared to this same
endpoint. No path or public context structure is introduced in S02.

The intended private handoff keeps `S : ActiveFiniteChannel alpha`,
`q : PMF (alpha → Fin S.outputCard)`, `V`, the all-row factorization `hV`,
`A = activeOutputs (auxiliaryChannel q)` and `eA : A ≃ Fin mA` visible.
The common result is `M' = commonEndpoint q eA`. S03 will return an actual
`a : Cascade S M'` with a homogeneous PPS path and its directed endpoint
comparison. S04 will return an actual `b : Cascade (allOnes alpha) M'` from
retained homogeneous PPS and VPS stages, their comparisons and their composition.
Both consumers use this same supplied `q`, `V`, `hV` and `eA`; neither chooses
a new endpoint internally. S04's first partition consumer must use the actual
seed endpoint's column patterns. This records later obligations without
constructing either path in S02.

Validation, regression details and review evidence will be added before F.
S03-S06 remain unstarted. The eventual durable execution record governs closure.


### Implemented contracts and regression crosswalk

All added machinery remains private in `Matrix/CanonicalReachability.lean`:

- `decoderLabelsEquiv` and its forward/inverse projections identify supported
  vectors and nonempty output fibers with the original ordered pairs `(y,w)`.
  Decoder labels are finite and nonempty under the existing finite-output and
  nonempty-input boundary.
- `decoderBlocks` proves nonempty, disjoint and covering fibers. The existing
  `partitionOfBlocks`/`partitionOfBlocksEquiv` produce the partition and retain
  every original output label. `partitionLabelsEquiv` records both projections,
  the inverse block finset and the inverse original output. No generic partition
  framework or global grouping is added.
- `commonEndpoint q eA` is exactly C06's active presentation of the auxiliary
  channel. Its coordinates and ambient PMF recovery hold at every atom; its
  singularity is proved directly from the auxiliary law. The admitted value is
  `q w` and its pattern is the exact decoder fiber. Each supported vector has
  exactly one positive entry per input row, with the other entries zero.
- `posterior_fiber_iff`, `posterior_fiber_pattern` and `posterior_value_identity`
  connect positive posterior labels to the original column's support and value.
  They retain the activity premise and the same `q`, `V` and row factorization.
- The indexed weighted-product uniqueness behind ISIT (28)/extended (24)
  uses the deterministic projection posterior and selects exactly `(w x,w)`.
  Anonymous interface consumers carry both label presentations to the same
  supplied enumeration and endpoint; they do not implement the later paths.

R04/R05 use the permitted equivalent fixture with three inputs/outputs,
`f=(0,0,1)`, `g=(0,0,2)` and weights `1/3,2/3`. The channel has two identical
pure-0 rows and final row `(0,1/3,2/3)`; its selected posterior factorization
is checked at every pair. Output 2 is active but omitted by supported f, so
that decoder label and active pair are absent. The f fibers have sizes 2 and 1;
actual partition blocks, coverage, disjointness, original labels and inverse
projections are checked. The endpoint retains value `1/3` and fiber `{0,1}`.
R06 uses a pure constant vector and an explicit singleton active enumeration,
checking output cardinality one, value one, universal pattern and the actual
partition. These fixtures implement the required phenomena without extra paths.

### Validation and API audit

The focused build covers `Matrix.CanonicalReachability` and C06/C10 channel,
column, partition, multiway, reachability and synthesis regressions. The default
build also passes. The exact-source compiling audit covers all
116 named private declarations and
58 anonymous consumers; only `propext`, `Classical.choice`
and `Quot.sound` occur. Both original focused imports and the lightweight root
are unchanged. No dependency, production test module or public declaration is
added. Initial dependent-elaboration failures remain recorded in scratch logs;
final checked proofs use explicit equivalence projections and the established
local classical convention. This changes proof organization, not hypotheses.

The reuse search checked local C03 activity/posterior APIs, C06 active
presentations/admitted column data, C10 labelled partitions and their pinned
mathlib declarations. No new generic information-theory result or upstream
proposal was needed. The plan's mathematical contracts and six-step structure
are unchanged. OM-020/021/045 record this step; their later operation and
unused-output obligations remain S03-S05. The early actual-Q partition consumer
remains S04, NormalForm packaging remains S05, and compression/incidence remain
C12/C13. No new Future Work Note is required.

Initial validation is complete; contextual review, independent review and final
closure are recorded separately below when available. S03-S06 remain unstarted.


### Independent review and finalization

The persistent reviewer independently satisfies C11-S02-A/B/C without findings.
The original complete JSON report is retained and critically reconciled. Its
scope includes the exact decoder/partition label laws, independent C06 endpoint,
posterior support/value equations, R04-R06 and the shared-input handoff. Review
focused/default builds pass, and its fresh source audit compiles all 58 maintained
examples and checks all 116 named private declarations. Only the accepted
foundational axioms occur. Parent final checks remain a separate obligation.
S01's original closure is preserved.

Six supplemental reviewer-written consumers remain unverified: two bounded
compilation attempts ended without diagnostics and are retained as FAIL evidence.
They support no passing criterion. The required maintained handoff consumers
compiled successfully, and the relevant value/pattern and label-injectivity
properties were independently inspected in source. The extra repeated-pattern
fixture maps to existing S04/R10: revisit retained vector labels when testing the
actual stages, without requiring adoption of that unverified scratch proof.
The initial invalid build-target invocation is also retained separately from the
corrected passing build. Incidental neighboring historical status sentences seen
during document reads were not used as correctness evidence; the review remains
source-based with its disclosed limits, not fully blind.

Exact references:

- S02 B: `1e5b7a1897f160f941bab0dd1f3b0a7872c78cc316c3752e8e468d0d66bbdc51`.
- Reviewed R: `9ea08f2b43e075640e49acd4db3d38f8b5dcbe4f9ec01d8a4e21c002ef7e22b9`.
- Original admitted report: `08e950d65b36100dd482340f85db46bb815e713cb77df51680de9a32c4bde36f`.
- Original report text SHA-256: `16dc400203295e9d1df1e2b8424995482f593b565f10d12999561d11c74b1327`.
- Original-report reconciliation: `a191eff7d38fef47d8313391e86ba094afc26f4d4d300dfc0157aa04b3477071`.

R-to-final changes update only current-status documentation and record the review
and reconciliation. All Lean bytes, imports, dependencies, workflow tools and
normative plan text remain identical to R. Final focused/default builds and the
source/hygiene audit must pass before F and supported closure. No new optional
suggestion or Future Work Note is introduced; mapped later obligations retain
their owners. S03-S06 remain unstarted. The subsequent execution record governs
durable completion; this is the maintained pre-F checkpoint.


## S03 — PPS bridge from the original channel

**Initial checkpoint, 2026-09-29 (history):** implementation and review were in progress. Startup verified
S02 durable closure `286eb17a6982125206a75198e7a59d3b7ee25604270198247b6cad21fb587d46`,
all three satisfied criteria, original-report reconciliation and equality of all
137 entries of final source `1b8d194f70955b6c5269f14993196086325c95408c23314cceb3ca23a436b011`.
The historical S02 pre-F checkpoint above is preserved; S02 subsequently closed.
The lead's conditional request authorizes S03 only. S04-S06 remain unstarted.

The source anchor is ISIT Appendix (21), p.5, and its statement that posterior
splits obtain the auxiliary channel, supplemented by extended version 16 (17)
and the corresponding Theorem 1 proof paragraph on p.4. Fresh hashes of both
designated PDFs match the approved plan. S03 uses the same S,q,V,hV,A,eA and
`commonEndpoint q eA` specified in S02. It retains the actual C10 returned witness,
original positive posterior labels and the directed endpoint comparison.

Existing public C10 family synthesis, labelled coordinates/comparison/cascade,
C06 admitted column data and C08 path singularity are the intended reuse. The
selected-operation singleton theorem does not apply to the returned family;
the plan permits a private column-growth argument for its actual zero-length
path and empty tags. No new public counting or partition interface is needed.

At that initial checkpoint, validation and review evidence were pending. The actual all-ones PPS/VPS bridge
and early actual-Q partition consumer remain S04; repeated-pattern coverage is
owned by S04/R10, including the context of S02's inconclusive extra reviewer
fixture. S05 owns the unused-output posterior guard and final composition.
C12/C13 retain compression/incidence. No new numbered Future Work Note is opened.


### Implemented contracts and regression crosswalk

`originalPps S hS V` is the actual C10 `multiPpsFamilyOfENNReal` result.
PMF normalization supplies the sums; its sigma labels retain exactly the positive
posterior atoms, including different support sizes for different source outputs.
`originalBridge S hS q V hV eA` retains that same path and compares its actual
endpoint to `commonEndpoint q eA`. The forward label map is the actual result's
inverse label map, followed by the S01 posterior-pair equivalence and the supplied
eA. Explicit forward/inverse equations, both PMF map equations and ambient recovery
fix its direction at every coordinate. No new q, V or enumeration is chosen.

The actual PPS endpoint has the original column pattern and the exact weighted
value; S02's posterior identities identify that value with q w and the pattern
with the decoder fiber. Singularity holds at the source, actual endpoint and every
intermediate vertex represented by a concrete path prefix. If each posterior
support is a singleton, normalization makes every fiber nonempty. The actual
family label cardinality and a private homogeneous-PPS growth proof give path
length zero and empty tags while retaining its directed endpoint comparison.
This does not publish a general counting API or replace the returned witness.

The anonymous intrinsic-perfectness consumer accepts only finite nonempty input,
extracts one q,V,hV and derives source singularity with C03. A local Fintype supplies
the private finite sums. For every supplied eA it extracts a witnessed homogeneous
PPS cascade to the same endpoint. It adds no posterior positivity or prior premise.

R07/R08 reuse S02's exact mixed fixture: f=(0,0,1), g=(0,0,2), weights 1/3 and 2/3,
and posterior support sizes 2,1,1. The actual PPS family has four columns and one
PPS edge. An explicit enumeration of (0,f),(0,g),(1,f),(2,g) followed by the cycle
[1,2,0,3] defines the independent target. Its rows are (0,1/3,2/3,0),
(0,1/3,2/3,0), and (1/3,0,0,2/3). Every target coordinate, both directed maps,
ambient recovery, zero-label exclusion and the original singleton-child labels
are checked. The forward and inverse cycle give different row-0 masses, 1/3 and
2/3, so an orientation error is observable. A separate constant posterior checks
the actual returned family's zero path length, empty tags and both endpoint maps.

### Validation and API audit

The production module and C10 multiway, reachability and synthesis regressions
build successfully, as does the default project target. The exact-source audit
compiles all 88 anonymous consumers and checks the signatures
and axioms of all 173 named private declarations. Only
`propext`, `Classical.choice` and `Quot.sound` occur. The two original imports,
lightweight root, pinned dependencies and approved normative plan remain unchanged.
The source/hygiene audit checks the actual step baseline, preserved log history
and omission IDs, placeholder absence, whitespace, artifacts and local links.
Iteration failures are retained separately from the final successful checks.

The source reuse search checked C10's family constructor and supplied-label
comparison, C06 values/patterns, C08 path singularity and the pinned PMF
normalization and sigma-equivalence APIs. No generic information-theory result
or upstream change was needed. OM-021/045/052 record the first actual bridge.
S04 retains the same q,V,hV,A,eA and must construct the actual PPS/VPS seed bridge,
including the early consumer on Q's actual column patterns. S04/R10, S05/R14 and
the C12/C13 boundaries keep their owners. No new numbered Future Work Note is
needed. Independent review and final closure remain separate obligations.


### Independent review and finalization

The persistent reviewer independently satisfies C11-S03-A/B/C without findings.
The complete original report is retained and critically reconciled. The review
covers the actual C10 posterior family, the supplied endpoint comparison and its
direction, positive-label exclusion, admitted values/patterns, stage singularity,
actual singleton no-op behavior and R07/R08. The detailed original evidence and
its limits remain in the review record; the parent reconciliation is separate.

The reviewer reran the focused and default builds and freshly compiled the
exact-source audit: all 173 named private declarations and 88 anonymous examples
passed, with no warnings or errors. A redundant `CompiledAudit.lean` probe failed
because its generated commands mishandled numeric components in compiler-private
names. That failed diagnostic is retained as unused evidence; acceptance relies
on the successful complete source audit. The historical six supplemental S02
consumers remain inconclusive and are not relabelled as passing evidence.

Exact references:

- S03 B: `55d53eeaf1118b01840969234f3d7d82bce61f146af1e527f16de60ea8c4bea0`.
- Reviewed R: `46a98bc2bba7e93554e5b13e1119c589f5a3f13188e491c6f640c8fe17ade9a6`.
- Original admitted report: `a8bbb6163141cc79c8d4b7e0e397baaa5cd4ae7d498158e0d4a4b933fff679ee`.
- Original report text SHA-256: `80ac157a08bd00fc1215981e4e9009e568110daa9bf6c7e1478d353865d74787`.
- Original-report reconciliation: `d1df7de97c955941a3a8c017d85d89298f61a91f2e87aaf48feec15a826ab473`.

R-to-final changes update exactly eight owning Markdown files to record review
and normalize current status. All Lean, imports, root, dependencies, environment,
workflow tools and normative plan text remain identical to R. The successful
focused/default builds and exact-source trust audit remain applicable by those
unchanged bytes. Final validation freshly checks that applicability, the audited
source hash, the complete B-to-final scope, placeholders, diff and file hygiene;
it does not repeat identical builds after documentation-only changes.

S04 retains the actual all-ones PPS/VPS bridge and its early actual-Q partition
consumer; S04/R10, S05/R14 and the C12/C13 boundaries retain their existing owners.
No new numbered Future Work Note is introduced. S04-S06 remain unstarted. The
subsequent execution closure record governs durable completion; this is the
maintained pre-F checkpoint.


## S04 — PPS/VPS bridge from all-ones

**Initial checkpoint, 2026-09-29 (history):** implementation and review were in progress. Startup
verified S03 closure `58b319d10966bff2658af848d3562f519eea384416715e1bac48869fd0c9db72`,
all three satisfied criteria, original-report reconciliation and all 137 entries
of final source `1368fd32daa952da744ca1772d454f5f41cdbbabdbe20fac6af5dc223793ce24`.
S03's original pre-F checkpoint is retained as history. Only S04 is authorized.

ISIT Appendix (23)-(28), page 5's final construction paragraph and Figure 1,
supplemented by extended version 16 (19)-(24), page 4's construction and page 5's
Figure 1, specify this bridge. Both manuscript hashes freshly match the plan.
The seed uses the same q, and its final comparison uses the same A and supplied
eA as S03; no second posterior witness or enumeration is selected.

The early checkpoint applies `multiVpsFamily` to labelled decoder partitions on
the actual PPS endpoint's column patterns. R09-R11 cover a pure weight-one seed,
nontrivial legal VPS, mixed singleton/multiple blocks, distinct repeated patterns,
and the one-input/one-output boundary. The earlier S02 extra fixture remained
inconclusive; R10 now revisits its intended phenomenon through the actual bridge.
S05 retains final compositions and R14's unused-output guard. C12/C13 retain
compression/incidence. No new numbered Future Work Note is introduced.


### Actual intermediate endpoint and bridge

`seedPps q` reuses C10's selected `multiPpsOfENNReal` on the sole all-ones
column. Its endpoint and path are unchanged; an explicit equivalence replaces
positive labels plus the empty unaffected-output type by q.support. Every actual
Q coordinate and admitted value equals its original q mass; every pattern is
universal. The label-range theorem excludes exactly the zero q atoms.

`seedPartition q j` calls `partitionOfBlocks` on that actual Q column pattern,
using the original nonempty decoder blocks and their established coverage.
`seedPartitionEquiv` retains the original decoder output and its exact finset.
The focused actual-Q `multiVpsFamily` checkpoint passed before the full bridge
was assembled: source SHA-256
`385f8141bc5053bbd4a086c540a34d6dedc105248e6e08904d3bc89a8dfb69b7`.
It is contextual implementation evidence; production validation and independent
review are recorded separately. The maintained construction reuses this consumer.

`seedVps q` keeps the actual family witness. Its complete sigma-label equivalence
maps through the original decoder labels into A, and then through the same
supplied eA into `commonEndpoint q eA`. Every coordinate is the auxiliary atom;
each child has its exact decoder pattern and unchanged q value. `seedBridge q eA`
literally appends the actual PPS and VPS paths, which already meet at Q, and
retains the VPS endpoint comparison. This avoids unnecessary transport at their
shared vertex and exposes both witnesses for S05. The exact chronological word
is a PPS block followed by a VPS block, allowing either block to be empty.

Forward/inverse labels, both directed PMF maps and full ambient recovery fix
the comparison direction. Every actual prefix endpoint is singular. Private
column-growth arguments prove zero length and empty tags for the actual returned
PPS stage when q.support is a singleton and for the actual VPS stage when every
decoder label family is a singleton. The existing C10 constructors supply strict
PPS parameters and nonempty VPS pieces; no extra strict upper bound on a VPS
column value is introduced. No public counting or partition framework is added.

The finite-only intrinsic consumer extracts q,V,hV once and supplies both
`originalBridge S hS q V hV eA` and `seedBridge q eA` at literally the same target.
It retains original PPS homogeneity and the seed's ordered word. It introduces
no input prior, full-support premise or new posterior assumption. Final reversed
compositions and the two public characterization theorems remain S05.

### R09-R11 and retained advice

R09 uses the pure vector (0,0,1). The actual seed has value one and no PPS edge;
its actual decoder partition has blocks {0,1} and {2}, and its VPS stage has
one legal edge. Every resulting coordinate is checked against the independently
specified deterministic target, and both constructions map to that same target.

R10 uses (0,0,0), (1,1,2), (3,3,3), with q masses 1/4, 1/2, 1/4.
The actual seed has three columns and two PPS edges; VPS produces four columns
with one edge. The two distinct constant-vector labels remain distinct columns
with equal universal patterns and masses 1/4. The middle vector's actual partition
has block sizes two and one. Every output coordinate, forward/inverse endpoint
maps and the original bridge's no-op behavior are checked. This adopts and
discharges the repeated-pattern testing obligation owned by S04/R10. The original
S02 supplemental probe remains historical inconclusive evidence, not a retroactive
pass; these are fresh checks of the actual S04 construction.

R11 uses one input and one output. Both returned seed stages have zero length
and empty tags, as does the original PPS bridge. Both constructions are compared
at one explicitly supplied common endpoint, including the inverse seed map.

### Validation and source ownership

Focused production, partition, multiway, reachability and synthesis builds pass,
as does `lake build`. The fresh exact-source audit compiles all
129 anonymous examples and checks signatures/axioms of all
322 named private declarations. Only the accepted
`propext`, `Classical.choice` and `Quot.sound` occur. Exploratory failures remain
retained separately from successful final validation. The original two imports,
lightweight root, pinned environment and normative plan are unchanged.

Source inspection checked C10's ENNReal support adapter and legal split recursion,
the exact-partition adapter and original-label equivalence, C08 path concatenation
and singularity, C06 admitted data and the pinned PMF normalization/equivalence
APIs. No new information-theoretic theorem or dependency change was needed.
The source audit checks the complete step baseline, placeholders, diff, log
history, omission IDs, generated/reference files and links. OM-020/021/045/052
record Figure 1's forward construction. S05 owns its witnessed reverse and final
characterizations, including R14's adversarial unused-output posterior. C12/C13
retain compression/incidence. No new numbered Future Work Note is needed.
At the implementation checkpoint, independent review and durable closure remained separate obligations.


### Independent review and finalization

The persistent reviewer independently satisfies C11-S04-A/B/C without findings.
The complete original report is retained and critically reconciled. The review
covers the actual C10 seed and VPS witnesses, partitions on the actual Q patterns,
complete original labels and exact coordinates, directed endpoint maps, the shared
q/V/eA target, chronological PPS-then-VPS order, legal boundaries and R09-R11.
The detailed original evidence and its limits remain in the review record;
the parent reconciliation is separate.

The reviewer reran the focused build (2781 jobs), default build (2762 jobs) and
a fresh exact-source audit of all 322 named private declarations and 129 anonymous
examples, including the attribute-prefixed local equality helper. The Lean checks
passed without warnings or errors; only `propext`, `Classical.choice` and
`Quot.sound` occur. Manuscript identities, all 136 real frozen files and the
derived environment matched. The private module prefix changes in the audit copy;
production builds check the maintained module separately.

The early consumer's historical timing remains documentary implementation
provenance; its current source was freshly compiled by the reviewer. An initial
PowerShell inspection-syntax failure and stdout-encoding display error are retained
as corrected peripheral failures, not passing checks; the Lean audit itself passed.
Earlier parent proof attempts and the S02 inconclusive probes retain their original
outcomes. Fresh S04/R10 checks discharge the repeated-pattern testing obligation.

Exact references:

- S04 B: `f7c4667a0fbb5f24f73eaecd3a2cbda84d3e346b4903bf46c0a6d0e2cf3e9c35`.
- Reviewed R: `0233459f6204a27b0263a40580feccbb7ad0bd0177729916edbf10ba1a6a3f97`.
- Original admitted report: `924b81b457497cf76d7a016d3bf1c73bcafca3f270e8d66189891bec22d3849a`.
- Original report text SHA-256: `a3bc5c75b7248af53245872b980009ca9205f3975691484cd157993276bdfef0`.
- Original-report reconciliation: `239536e8b1b10cc3688d4525539bbb0973e9fbad66d6e8befe21a1eda0744852`.

R-to-final changes update exactly eight owning Markdown files to record review
and normalize current status, including historical labels on earlier map and
implementation checkpoints. All Lean, imports, root, dependencies, environment,
workflow tools and normative plan text remain identical to R. The successful
focused/default builds and exact-source trust audit remain applicable by those
unchanged bytes. Final validation freshly checks that applicability, the audited
source hash, the complete B-to-final scope, placeholders, diff and file hygiene;
it does not repeat identical builds after documentation-only changes.

S05 owns the witnessed reverse/compositions, both final characterization theorems
and R12-R16, including the adversarial unused-output posterior in R14. S06 remains
the distinct cumulative validation step. C12/C13 retain compression/incidence.
No new numbered Future Work Note is introduced. S05-S06 remain unstarted. The
subsequent execution closure record governs durable completion; this is the
maintained pre-F checkpoint.


## S05 — Both characterizations and integrated handoff

**Initial checkpoint, 2026-09-29 (history):** implementation and review were in progress.
Startup verified S04 closure
`a3bf7456868c14c88145d025501e419ffc75869f8b1976fe0932f2383bd5cb1a`,
all three satisfied criteria, original-report reconciliation
`239536e8b1b10cc3688d4525539bbb0973e9fbad66d6e8befe21a1eda0744852`
and all 137 entries of final source
`c8a708223bdc4399bc69a72aceda979758db1930b919593c64936e3bd62da8c4`.
The S04 pre-F checkpoint above remains historical. Only S05 is authorized.

ISIT Theorem 1 (III-B, page 4) and its Appendix proof (page 5), supplemented by
extended version 16 III-B (page 4) and Figure 1 (page 5), provide the contract.
Both original PDF hashes freshly match the approved plan. The actual original
and seed bridges share one q,V,hV/eA target. Their witnessed reversal/composition
must retain the prescribed order and directed comparisons. Existing C10 easy
implications provide the converse directions without a new prior or singularity
premise. R12-R16 cover the final witnesses, finite ambient/active boundary,
adversarial unused-output posterior, existing negative example and matrix/input
reindexing. The readiness audit will map S01-S05, R01-R16 and CC01-CC08, explicitly
leaving S06's fresh cumulative review and closure unstarted.


### Actual compositions and public boundary

`canonicalToAllOnes` is literally `a.comp b.reverse`, and
`canonicalFromAllOnes` is literally `b.comp a.reverse`, for the original and seed
bridges built from the same q,V,hV and supplied eA. The first has chronological
blocks PPS(original), VPM(seed VPS), PPM(seed PPS). The second has blocks
PPS(seed), VPS(seed), PPM(original). Their word theorems use the actual stage
lengths, including zero. Directed comparison formulas retain path transport and
the actual reversed bridge's final comparison; inverse formulas reverse that
composition order. Both PMF map directions are proved.

The preferred private `canonicalNormalForm` stores exactly the seed PPS/VPS
paths and the transported actual reverse of the original bridge. Its
`toCascade` is definitionally the forward composite (`rfl`), preserving paths
and final comparison. No alternative witness or new public package is introduced.
The only public additions, in `MatrixOperations`, are
`isPerfectlyRepresentable_iff_toAllOnes` and
`isPerfectlyRepresentable_iff_fromAllOnes`. Both require only `[Finite alpha]`
and `[Nonempty alpha]`. Each extracts the intrinsic q/V witness, derives source
singularity and chooses one active enumeration; C10 supplies the converse.
There is no extra prior, full-support or singularity premise.

S05 also reread the relevant extended Appendix B Lemma 5/6 arguments on
pages 15-16. Their complete-vector preservation and remembered inverse content
is reused through C09/C10; adjacent Theorem 2 remains C14. The readiness crosswalk
and map make that prerequisite-only allocation explicit.

### R12-R16 and source crosswalk

R12 reuses the mixed S03 fixture and its non-involutive three-cycle. Actual words
are `[pps,vps,vps,ppm]` and `[pps,vpm,vpm,ppm]`; the retained NormalForm stages,
initial inverse comparison, final inverse coordinates and both row-map directions
are checked. The S04 pure fixture gives `[vps]` and `[vpm]`; the one-input/output
fixture gives actual empty stages and zero length, retaining both maps.

The separate test module uses public declarations only. R13 extracts actual
cascades, restrictions and directed maps from both iff statements. R14 checks
arbitrary finite ambient recovery, supplied enumerations, changed order and the
adversarial unused-output posterior: deterministic rows `(1,0,0)` and `(0,1,0)`,
q concentrated on `(0,1)`, and V 2 concentrated on `(2,2)`. Every factorization
atom holds although V 2 (2,2) = 1 and q (2,2) = 0. Thus the unrestricted support
implication is false. R15 reuses C03's existing negative 3x3 example to reject
both reachability predicates via the new iff statements. R16 checks the singular
exact ENNReal matrix boundary and an input swap with distinguishable row masses,
including both reachability consequences.

The [readiness audit](pfr-c11-readiness-audit.md) maps exact manuscript anchors,
all fifteen S01-S05 criteria, R01-R16, CC01-CC08 and every relevant advice or
omission. C12 owns equal-pattern compression and the exact-to-Real bridge; C13
owns incidence systems and normalization derived from feasibility. C11's PMF
normalization does not discharge that latter obligation. No numbered Future Work
Note is open. S06 must still perform fresh cumulative independent validation.

### Validation and ownership

Focused production/new-test, canonical/singularity, channel/columns, partition,
multiway, reachability and synthesis builds pass; `lake build` passes. Exact-source
audits compile all 192 anonymous examples and check all
374 named declarations: 351 production
(2 public) and 23 private test declarations.
The declaration inventory is cross-checked against both maintained `.ilean`
inventories, including attribute-prefixed definitions. Only `propext`,
`Classical.choice` and `Quot.sound` occur; no audit warning or error remains.
The production imports, lightweight root, pinned dependencies, workflow tools
and normative plan are unchanged. Earlier Lean source bodies are preserved.

Exploratory core/fixture elaboration failures and the external base failures
remain retained with exact commands, sources and logs. The first parent production
build also failed because the append patch matched an earlier repeated namespace
ending, placing new fixtures before declarations they use. The failed source and
Lake trace are retained. Moving that block after the complete baseline restores
the original declaration order; the source audit checks the complete prefix.
Later success does not relabel those attempts. The maintained builds and
exhaustive audits check the final integrated source. The planning-notes introduction now labels its original
planning/approval checkpoint as historical; all original planning records after
that header remain byte-identical. Source scope, placeholders, diff, omission IDs,
log history, links, generated/reference files and temporary artifacts are audited
before the review snapshot. Independent review and durable S05 closure remained
separate obligations at that implementation checkpoint.


### Independent review and finalization

The persistent reviewer independently satisfies C11-S05-A/B/C without findings.
The complete original report is preserved and critically reconciled. It assesses
the actual reverse/compositions, retained ordered stages and directed maps, both
public iff contracts, R12-R16, external finite/ambient/matrix consumers and the
readiness/C12-C13 handoff. The original report and the separate parent assessment
retain their respective evidence and limitations.

The reviewer independently reran a focused build (2784 jobs), default build
(2762 jobs) and fresh exact-source audits for both C11 modules. Its focused
selection includes preservation and the original counterexample; the parent's
required selection also checks singularity, channel/columns and partitions
(2790 jobs). These are separate successful commands. All 351 production names
(two public), 23 private external names and 192 anonymous examples are checked;
both `.ilean` inventories match. No audit warning or error remains, and only
`propext`, `Classical.choice` and `Quot.sound` occur.

All 138 real frozen files and the derived environment match at the final review
check; all ten installed packages remain clean at their pins. Fresh manuscript
hashes match. The prior Figure 1 visual check is reused on identical binaries,
with fresh reading of the S05 proof and prerequisite prose. An initial text
selector missed a heading and was corrected; it is retained as a peripheral
failure. Source-copy audits change private module prefixes and are accompanied
by production builds and actual external imports.

The reviewer retains history and reports unknown effective model/effort settings.
Canonical-context reads exposed adjacent historical status/review sentences,
which were not used as correctness evidence. Parent/helper scratch, private
records and implementation conversation were not read. Inventory hashing is not
a universal dependency or clean-commit claim. The original report and parent
reconciliation preserve these limits and all earlier negative evidence.

Exact references:

- S05 B: `1897eeee354b49d337ce4563e6ac93ffec202e263a3709f48b94eaef0beaef36`.
- Reviewed R: `68653e23490dbc240d0d7fda4826e9bd9a9d082af353a68a0baaef4cd708d93a`.
- Original admitted report: `eabe49ac7f854556eb3ea576330697162441a348df53057e5b63d89f24102f6d`.
- Original report text SHA-256: `afa4847e48c6ba3bd17e8c3fb3018c298edee0571191f89d989410941eabc528`.
- Original-report reconciliation: `3c564ed3c2c833d318ed189b2cf7e4bd575e5586e53710681953aab764ce61b8`.

R-to-final changes update exactly nine owning Markdown files with the actual
review result and finalization boundary. All reviewed Lean, imports, root,
dependencies, environment, workflow tools and normative plan remain unchanged.
The successful focused/default builds and both exhaustive source audits remain
applicable to identical code. Final validation freshly checks that applicability,
both audited source hashes, the complete twelve-path B scope, placeholders, diff,
links and file hygiene. It does not rerun identical builds after documentation-only
changes. Earlier failures keep their recorded outcomes.

The full source/step/regression/completion crosswalk and all advice dispositions
are in the readiness audit. S06 remains the separate fresh cumulative validation
step; only its eventual durable closure completes C11. C12/C13 retain their
compression/incidence duties and revisit triggers. No numbered Future Work Note
is introduced. The subsequent execution closure record governs durable S05
completion; this maintained record is the pre-F checkpoint.


## S06 — Fresh cumulative validation and independent closeout

**Initial checkpoint, 2026-09-29:** S01-S05 are durably complete; S06 is active.
Startup verified all five original reports and reconciliations, fifteen satisfied
criteria, no outstanding findings and all 139 entries of S05 F
`7d703b35af96ea1697259f403ab1f70e68fb3a97d88d35b53af3919e35663e10`.
S05 closure is `a702c8f60967367e9db1c37c06127105ebf0ee319cb669835ce1cd3c724d2194`.
Its pre-F checkpoint above is historical. The actual conditional S06 request was
consumed once; no later chunk is authorized.

S06 reassesses every S01-S05 criterion, R01-R16, CC01-CC07 and CC08 readiness
against the exact unchanged mathematical source. The readiness audit retains
the full criterion, regression, manuscript and advice/omission crosswalk.
Both manuscript hashes were freshly verified. ISIT Theorem 1/Appendix pp.4-5,
extended v16 III-B/Figure 1 pp.4-5 and relevant Appendix B Lemma 5/6 pp.15-16
were reread; prior page renders remain applicable to the identical binaries and
were reinspected. Adjacent extended Theorem 2 remains C14.

Two read-only contextual helpers reassessed S01-S03 and S04-S05 respectively.
Their analyses supplement parent inspection and are separate from the persistent
reviewer's cumulative assessment. No new mathematical gap has been identified.
The C13 handoff wording now says full/reduced partition incidence systems;
excluded Bell-count/growth claims remain OM-017. This clarifies the approved
scope without changing it. No new deferral or Future Work Note is needed.

Required focused/default builds and exhaustive source-copy trust audits run
freshly for this cumulative step. Exact checks, retained limitations and the
independent result will be recorded below before final validation/F. All Lean,
root/imports, pins, workflow tools and normative plan bytes remain unchanged.
Only durable S06 closure completes CC08/C11. C12 remains unstarted.


### Fresh cumulative validation checkpoint (before independent review)

The ten required focused targets pass (2790 jobs), and `lake build` passes
(2762 jobs). These are fresh incremental build invocations. Fresh source-copy
compilation checks 351 production declarations (two public), 23 private external
declarations and all 192 anonymous examples. Both maintained `.ilean` inventories
match the complete enumeration, including attribute-prefixed definitions.
Every name has an axiom audit and full `#print` output; only `propext`,
`Classical.choice` and `Quot.sound` occur. Production imports stay focused and the
root stays semantic-only. Public iff signatures retain just finite nonempty
input and the supplied active channel.

The supplemental print pass initially compiled production successfully, then
its output-count assertion failed because Lean prints attributes such as
`@[defeq]` and `@[reducible]` before some declarations. The original script,
output and failed assertion are retained. The corrected parser accepts those
prefixes and compares the complete ordered name list, reusing that successful
compilation on identical source; the external print pass runs separately. A
peripheral diagnostic hit Windows' default text encoding; it did not change
source or supply passing evidence. These are audit-tool limitations, distinct
from the successful maintained Lean builds and axiom checks.

The complete B comparison limits this step to nine owning Markdown files.
All Lean, dependency/environment, root/imports, workflow tools, original planning
records and normative plan remain unchanged. The log keeps its original prefix;
all 71 omission IDs, local links and reference/generated-file boundaries remain
intact. The required placeholder scan and whitespace checks pass. Earlier S02
inconclusive probes, S03 private-name attempt and S05 integration failure retain
their original outcomes. The readiness crosswalk records fresh reassessment of
all fifteen earlier criteria and R01-R16, with CC08 explicitly awaiting review,
reconciliation and durable closure. No mathematical correction is required by
this contextual assessment.


### Fresh cumulative independent review and finalization

The persistent reviewer independently satisfies C11-S06-A/B/C without findings.
Its new cumulative report reassesses all fifteen S01-S05 criteria, R01-R16,
CC01-CC07 and CC08 review-time readiness against the actual source and manuscript
anchors. The complete native original report is preserved, admitted and critically
reconciled. Earlier favorable reviews were not substituted for this assessment.

The reviewer freshly read all 2631 production lines and 270 external-test lines,
all fifteen earlier criteria and R01-R16. Its required focused build passes
(2790 jobs), as does the default build (2762 jobs). Fresh source-copy audits
cover 351 production names (two public), 23 private external names and all
192 anonymous examples; both `.ilean` inventories match. Production has
346 standard-axiom reports and five axiom-free reports; consumers have 22 and
one respectively. There are no warnings/errors, and only `propext`,
`Classical.choice` and `Quot.sound` occur. The reviewer checks private signatures
with `#check`, public signatures with `#print` and all named axioms; the parent
also records full `#print` output for every named declaration.

The two independent audits completed in about 345 and 326 seconds, including
startup. Their processes made progress and were neither terminated nor retried.
Both initial/final checks match all 138 ordinary frozen files and the derived
environment; all ten installed packages are clean at their manifest revisions.
Both designated manuscript hashes match. The reviewer freshly reread the exact
anchors and rendered/reinspected both Figure 1 pages. Its prerequisite review
checked the actually reused interfaces and key proof bodies.

The report preserves its limits: effective model/effort settings are unknown;
the persistent reviewer retains history; mixed canonical context exposed adjacent
historical status/advisory summaries, which were not used as correctness evidence.
Parent/helper scratch beyond the neutral request, private workflow records,
implementation conversation and other original reports were not read. Source
binding is cooperative; copied-source audits use compiled prerequisites and
different private module prefixes. Incremental builds and fresh source-copy
compilation are distinguished. Historical early-checkpoint timing is documentary,
and earlier failed/inconclusive attempts retain their original outcomes.

The separate parent reconciliation checks every criterion and cumulative contract,
all advice/omission ownership and the stated evidence limits. No mathematical
correction or new unowned deferral is required. The C13 wording refinement
preserves the approved OM-017 exclusion. Original reports and all earlier
negative/inconclusive attempts remain intact.

Exact references:

- S06 B: `e08e479ee8f096200215293937809193f4a5de55f7d3ffc0d27ea369c031b01f`.
- Reviewed R: `7d3487403e4eb0285b862249d0a14dc788cecd4ddfe984e27e2a5f3b65d0819f`.
- Original admitted report: `80860340686f9a9e32d1b6200fd298b444c2077148aa2200fae709a8ebad3c4a`.
- Original report text SHA-256: `b8f0fa57f6e1ea46b9363616e56a454047dc6f5362bd8ed03630ff79942a52d5`.
- Original-report reconciliation: `e15fa7eb999dbbdf165c70005830819bd3f6ddaebd9127d35d1b4e7a96296aa7`.

R-to-final changes update exactly nine owning Markdown files with the actual
review/reconciliation and closeout boundary. All reviewed Lean, root/imports,
dependencies, environment, workflow tools, original planning records and
normative plan remain unchanged. Successful current-step focused/default builds
and all print/axiom/example audits therefore remain applicable. Final validation
freshly checks that applicability, both source hashes, the complete nine-path B
scope, placeholders, whitespace, links, omission IDs and artifact hygiene.
No identical Lean build is claimed as rerun after these final Markdown edits.

CC01-CC07 are cumulatively assessed. CC08 requires the final applicability check,
exact F and supported durable closure after this maintained pre-F checkpoint.
Only that subsequent execution record completes S06 and C11. No included file
is edited afterward. C12-C16 remain unstarted, their owners and revisit triggers
unchanged. No commit or push is performed by this step.
