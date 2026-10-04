# PFR-C11 readiness audit

**Status, 2026-09-29:** S01-S05 durably complete; S06 fresh cumulative
validation and independent review complete; original report critically reconciled. Startup verified all five original
reports/reconciliations, fifteen satisfied criteria and all 139 S05 final entries.
Final applicability checks/F and durable closure follow this maintained checkpoint.
Only durable S06 closure completes CC08 and C11.
The [revision-2 plan](plans/pfr-c11-theorem1-canonical-coupling.md) owns the
requirements; [implementation notes](pfr-c11-implementation-notes.md) own dated
validation, review, reconciliation and closure evidence.

## Source identity and interpretation

The six-page ISIT final manuscript has SHA-256
`48963aa59485b2c33b1a1e6e7c6ead2251fdddd26bd3691b6fcffe683e6ed1c4`.
The designated extended version 16 (18 pages, designated 2026-09-03) has SHA-256
`98636d4c9f0618ec08fca84559572780f604f197fda90d8d7c787b3624245b8f`.
S06 freshly verified both binaries and reread the relevant pages: ISIT III-B
Theorem 1 on page 4 and Appendix on page 5; extended III-B on page 4 and Figure 1
on page 5. The freshly verified source identity also makes the retained page-5
renders applicable. Local papers, extracts and images remain external or ignored.

| Manuscript anchor | Precise contract and source owner |
| --- | --- |
| ISIT Appendix introduction and (20)-(22); extended III-B (16)-(18) | S01 reuses the intrinsic common canonical q/V factorization. `auxiliaryChannel_apply`, `bind_posteriorSplit` and both marginals specify every ambient atom. `fixedW_perfect` and the support-law variants prove perfectness of the specified W for every input prior, rather than only existence of some representation. |
| Positive-weight WLOG and pair alphabet | S01/S02 restrict to q.support and active pairs with nonempty decoder fibers. `posteriorLabelsEquiv`, `decoderLabelsEquiv` and `partitionLabelsEquiv` retain the original ordered pair (y,w). No inactive pair becomes an admitted column. |
| ISIT (23)-(28); extended (19)-(24) | S02 proves nonempty/disjoint/covering decoder blocks, their original-label equivalence, indexed row uniqueness, exact q values and fiber patterns at independently specified `commonEndpoint q eA`. The posterior-support equivalence explicitly needs an active original output. |
| Splitting M into the auxiliary channel, after (22)/(18) | S03 `originalPps` retains the actual C10 posterior family and `originalBridge` compares its endpoint to the independently specified common endpoint, with both maps and ambient recovery. |
| Final weighted-partition construction and Figure 1 | S04 `seedPps` and `seedVps` retain the actual C10 paths. `seedPartition` uses each actual intermediate pattern; complete labels and coordinates reach the same common endpoint. `seedBridge` appends the paths in PPS-then-VPS order. |
| ISIT III-B Theorem 1 and inverse-operation proof prose; extended III-B | S05 assembles both final witnessed reverse/compositions and publishes the two iff statements. C10 already supplies the easy implications. The active finite channel theorem needs finite nonempty input but no additional singularity or prior premise; its singular `Fin k` specialization expresses the printed matrix theorem. |
| Extended Appendix B, Lemma 5 (175)-(202), pp.15-16, and Lemma 6, p.16 | Reuse the completed C09 preservation/reflection results through C10's easy implications and witnessed recoveries. S06 reread these relevant prerequisite arguments. No second preservation proof is introduced; adjacent Theorem 2 (203)-(221) remains C14. |

The paper's effective coordinate counts become explicit support subtypes in Lean.
Its conditional displays are law factorization statements with support-aware
conditional meaning; arbitrary null-fiber completions are not identified. Legal
multiway synthesis consists of actual binary operations: PPS ratios are strict,
VPS pieces are nonempty, and value-one VPS remains admitted. Empty stages retain
the returned witness and directed comparison. Reversal consumes remembered
recoveries and inverts the output comparison; no global inverse or permutation
involution is asserted. Separate supported vectors may yield equal patterns and
remain distinct labels. C12 owns global grouping.

## Modules, public boundary and reuse

- [Production](../PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean)
  owns the private auxiliary/label/partition/bridge construction and the two
  public characterization theorems. Its imports are the existing
  `Matrix.Reachability` and `Matrix.MultiwayOperations`.
- [External consumers](../PerfectFunctionalRepresentations/Tests/Matrix/CanonicalReachability.lean)
  exercise the public signatures, actual cascade extraction, ambient restriction,
  enumeration changes, the existing counterexample and finite matrix boundary.
  They must not access compiler-generated private names.
- The root remains free of heavy matrix imports. No additional public bundle,
  partition transport framework, counting API, entropy theorem or probability
  construction is required by C11.

The checked public boundary, with `[Finite alpha] [Nonempty alpha]`, is:

```lean
isPerfectlyRepresentable_iff_toAllOnes (S : ActiveFiniteChannel alpha) :
  IsPerfectlyRepresentableChannel S.channel ↔ ToAllOnes S

isPerfectlyRepresentable_iff_fromAllOnes (S : ActiveFiniteChannel alpha) :
  IsPerfectlyRepresentableChannel S.channel ↔ FromAllOnes S
```

| Existing interface | C11 use |
| --- | --- |
| C02 intrinsic canonical law and common posterior, support restriction, fixed-W semantics | Reuse the same q/V witness and PMF laws; no second information-theory hierarchy. |
| C03 singularity and active-output semantics; C06 finite presentations/coordinates | Derive source singularity, restrict/reconstruct ambient rows and compare supplied enumerations. |
| C08 `OutputEquiv`, `OperationPath.transport`, `Cascade.comp`, `NormalForm` | Retain actual path stages and directed endpoint maps through relabeling and ordered-stage packaging. |
| C10 `Cascade.reverse`, tag/restriction laws and easy reachability implications | Witnessed inverses and both final converse implications. |
| C10 exact labelled partitions and ENNReal PPS/VPS constructors | Actual positive-weight seed/posterior and decoder-family paths, with complete labels and primitive legality. |
| Pinned LeanInfoTheory PMF maps/joint laws and semantic bridges | Exact atoms, maps, factorization and fixed-W perfectness through supported public imports. |
| Pinned mathlib PMF, finite subtypes/sigma equivalences and `Finpartition` | Normalization, support nonemptiness, finite enumerations and exact partitions. |

LeanInfoTheory remains `v0.1.0` at
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`; mathlib remains
`0df444a360eaa60ab8c11dca51a86af692955474`, on Lean `v4.33.1`.
No dependency upgrade or generic information-theory reproof is part of C11.

## Regression crosswalk

All rows identify maintained proof consumers freshly reassessed during S06.
Current cumulative builds and exact-source audits check these unchanged modules.
Earlier independent assessments retain their original scope. The fresh cumulative
S06 assessment satisfies all current criteria and has been critically reconciled. In-module fixtures retain private interface access;
external consumers use public declarations only.

| ID | Maintained source and discriminating check |
| --- | --- |
| R01 | Production `Regression`: q-null vector exclusion, normalized support law and exact inclusion without renormalization. |
| R02 | Same fixture: zero posterior/pair masses and exact positive-posterior/active-pair labels. |
| R03 | Same fixture: pure input prior leaves an unused input row; specified-W perfectness and factorization hold without conditional uniqueness on null fibers. |
| R04 | Production `RegressionS02`: a supported vector omits an active output; its empty decoder fiber and corresponding pair are excluded. |
| R05 | Same fixture: actual unequal decoder fibers, original labels, nonemptiness, disjointness and coverage. |
| R06 | Same fixture: constant singleton law, exact value-one block, common endpoint and exclusion of empty labels. |
| R07 | Production `RegressionS02`, extended by S03's PPS consumers: differing posterior support sizes, every actual PPS output coordinate and homogeneous returned path. |
| R08 | Same fixture: genuine three-cycle on four labels distinguishes endpoint map directions and retains singleton-family labels. |
| R09 | Production `RegressionS04.PureSplit`: pure (0,0,1), actual weight-one/no-PPS seed and one legal VPS edge on blocks of sizes two and one. |
| R10 | `RegressionS04.Repeated`: three q atoms of masses 1/4,1/2,1/4, three seed/four final columns, mixed block counts, distinct equal-pattern outputs and exact maps. |
| R11 | `RegressionS04.Singleton`: one input/output; actual seed PPS/VPS and original PPS lengths/tags are zero/empty, with one supplied common target. |
| R12 | Production `RegressionS02` S05 extension and `RegressionS04.PureSplit`/`Singleton`: actual words [pps,vps,vps,ppm] and [pps,vpm,vpm,ppm], private NormalForm identity/stages, genuine inverse cycle, [vps]/[vpm] and empty-stage maps. |
| R13 | S05 external consumers: extract actual `Cascade` witnesses and their restrictions from both public iff statements. |
| R14 | S05 external consumers: arbitrary finite output and supplied enumeration, active reconstruction, changed enumeration, and unused-output posterior positive at a q-null vector despite valid row factorization. |
| R15 | S05 external consumers: the existing C03 `nonrepresentable3x3` refutes both reachability predicates via the new iff statements; no duplicate public counterexample. |
| R16 | S05 external consumers: singular `Fin k` exact matrix specialization and a finite input reindexing with distinguishable rows. |

## Step and completion crosswalk

Earlier steps retain their original independent assessments and durable closure.
S06 freshly reassesses all fifteen criteria below against the current source and
exact manuscript anchors; the previous reports are provenance, not a substitute
for cumulative independent review.

| Criterion | Evidence boundary |
| --- | --- |
| C11-S01-A | Exact auxiliary/split atoms, factorization, both marginals and normalized support inclusion; R01/R02. |
| C11-S01-B | Actual specified-W perfectness for every prior and supported variants; R03. |
| C11-S01-C | Private interface, pinned reuse, source interpretation and successful S01 validation/review. |
| C11-S02-A | Original decoder labels and actual nonempty/disjoint/covering partitions, complete active-pair equivalences; R04/R05. |
| C11-S02-B | Independently specified common endpoint, recovery, values/patterns, singularity and indexed row uniqueness; R04-R06. |
| C11-S02-C | Exact shared q/V/hV/eA handoff and private consumer/partition validation; no global grouping. |
| C11-S03-A | Actual posterior PPS family and homogeneous bridge to the shared endpoint; R07. |
| C11-S03-B | Directed maps, admitted data, prefix singularity and returned singleton no-op; R07/R08. |
| C11-S03-C | Production/downstream/default builds, complete private trust audit and preserved source/handoff. |
| C11-S04-A | Actual positive seed Q and carrier-correct partitions, early actual-Q consumer and complete VPS labels/coordinates. |
| C11-S04-B | Actual PPS-then-VPS bridge, same q/V/eA target, legality/singularity and degeneracies; R09-R11. |
| C11-S04-C | Production/finite-synthesis/default builds and complete trust audit; Figure 1 forward construction and reverse-stage readiness. |
| C11-S05-A | Both final witnessed compositions and ordered stages, both public iff statements with C10 converse implications. |
| C11-S05-B | R12-R16, actual witnesses, ambient/active/enumeration/matrix/input consumers and exhaustive public/private audit. |
| C11-S05-C | This source/step/regression/completion crosswalk, C12/C13 handoff, required checks and owning documents; S06 remains distinct. |

| Completion criterion | Current readiness boundary |
| --- | --- |
| CC01 | S01 auxiliary/support laws and all-prior specified-W perfectness; completed source, R01-R03. |
| CC02 | S01/S02 complete label correspondences and ambient reconstruction; completed source, R01/R02/R04. |
| CC03 | S02 exact decoder partitions and admitted data implementing numbered displays; R04-R06. |
| CC04 | S03/S04 actual bridges to the same independently specified endpoint; R07-R11. |
| CC05 | S05 final reverse/compositions and two public equivalences; implemented and parent-validated; S05 durably complete; fresh cumulative S06 assessment and validation are satisfied. |
| CC06 | S05 integrates R01-R16 and public/ambient/matrix/trust/import checks; all named declarations/examples checked; S05 durably complete; fresh cumulative S06 assessment and validation are satisfied. |
| CC07 | S05 source crosswalk and owned advice/C12/C13 handoff are recorded here and in implementation notes; S05 durably complete; fresh cumulative S06 assessment and validation are satisfied. |
| CC08 | Fresh cumulative independent assessment and complete original reconciliation are done, with no unresolved finding. Final applicability/F and durable closure follow this checkpoint; only that closure completes CC08 and C11. |

## Advice, omissions and downstream handoff

The [original selection record](pfr-c11-planning-notes.md#revision-2-selection-and-dispositions)
retains the distinct installed-review, parent and supplied General Assistant
advisory sources. No numbered Future Work Note is open.

| Advice or obligation | Owner, disposition and revisit trigger |
| --- | --- |
| `pfr-finding:C11-plan-r1-unused-output-posterior-guard`; General Assistant refinement 1 | Adopted by revision 2; S05/R14 checks the simpler deterministic three-output fixture. Reassess any attempted posterior-support statement lacking an activity premise. |
| General Assistant refinement 2, early actual-Q consumer | S04 implemented and preserved its original checkpoint provenance. Current source retains the carrier-correct consumer. No generic partition framework is deferred. |
| Parent `pfr-finding:c11-plan-parent-001`, ordered private packaging | S05 adopts the preferred existing private NormalForm with toCascade definitionally equal to the actual forward composite; exact stages, words and maps are checked. No public framework is needed. |
| Parent `pfr-finding:c11-plan-parent-003`, visible shared inputs | S02-S04 retain S/q/V/hV/A/eA explicitly and supply both bridges at the literal same target. |
| Parent `pfr-finding:c11-plan-parent-002`, actual singleton stages | S03/S04 use private column-growth facts to prove lengths/tags of returned paths; R09/R11 retain their comparisons. |
| S02 supplemental repeated-pattern probe | Historical attempts remain inconclusive; fresh S04/R10 actual-stage checks discharge the intended test obligation without relabelling old evidence. |
| OM-014/044/045, support and effective outputs | Explicit restriction/recovery and positive/nonempty labels are maintained; S05/R14 tests unused-output completion. |
| OM-020/021/042/048/051/052, construction and inverses | Full q/V witnesses, exact numbered contracts, actual legal stages and directed witnessed reversal belong to S01-S05. Artwork, a public name per display and a global inverse remain intentionally omitted. |
| OM-038/049, legal degenerate boundaries | Reuse C10 strict PPS and nonempty VPS constructors, including value one and actual no-op stages. |
| OM-040, Theorem 1 versus Example 1 | R15 consumes the existing negative example; no second counterexample infrastructure. |

C12 may consume the two public equivalences together with C06 admitted
values/patterns and C10 prescribed merge families to establish global equal-pattern
compression and its exact-to-Real boundary. C11 keeps distinct decoder/vector
labels even when their patterns agree. C12 planning and its actual compression
proof are the revisit trigger; no compression is implemented here.

C13 may consume the completed C10 labelled partition interface and C11's
characterizations after its C10/C11/C12 prerequisites are complete. Enumeration,
full/reduced partition incidence systems and weight normalization derived from
feasibility remain C13 duties. Bell-count/growth claims remain excluded under
OM-017; the handoff does not enlarge that scope. C11's q normalization comes from a PMF and is not
an incidence-feasibility proof. C13 planning is the revisit trigger. C14/C15 keep
optimization and C16 keeps publication curation. Existing adjacent omissions
OM-009-012/016-019/022-023/028-037 retain their original owners and triggers.

## Historical S05 validation and review checkpoint

Focused production/external-consumer and relevant downstream builds, default
build and both exact-source audits pass. All 374 named declarations and
192 anonymous examples are checked; the only public additions are the two
iff theorems, with no extra premise. The `.ilean` inventories independently check
the named-declaration enumeration. Only the accepted Lean axioms occur.

The implementation notes retain exact evidence, negative attempts and limits.
The old root/import/pin/tool/normative-plan boundaries are preserved. Independent
review satisfies C11-S05-A/B/C without findings; the complete original report is
preserved and critically reconciled. Final documentation changes preserve all
reviewed Lean/environment bytes, so the successful builds and audits remain
applicable. Fresh final source/applicability checks, F and durable S05 closure
follow this checkpoint. S06 remains unstarted and C11 is not yet complete.


## S06 cumulative reassessment

The mathematical source is unchanged from S05 F. Fresh inspection covers all
fifteen criteria and R01-R16 above: specified-W perfectness for every prior,
active-only posterior support, exact original decoder labels and partitions,
independently specified shared target, actual posterior/seed operation paths,
their ordered witnessed composites and both public finite-input equivalences.
The external adversarial unused-output, negative example, matrix and input
reindexing consumers remain part of the exhaustive compilation duty.

Both designated manuscript hashes match. Fresh text reads cover ISIT pp.4-5,
extended pp.4-5 and relevant Appendix B Lemma 5/6 on pp.15-16. Earlier matching
page renders remain applicable and were reinspected for the construction.
The earlier S02 inconclusive probes, S03 private-name failure and S05 integration
failure keep their recorded outcomes. Current checks establish the maintained
source separately. C12/C13 owners and triggers remain as above; no new Future
Work Note is opened. Exact S06 validation and review records belong in the
implementation notes. Fresh cumulative independent review satisfies all three S06
criteria without findings and is critically reconciled. It reassesses all fifteen
earlier criteria, R01-R16 and CC01-CC07, with CC08 explicitly limited to
review-time readiness. The final source/applicability checks, F and supported
durable closure remain the last required actions after this maintained checkpoint.


The ten required focused targets and default build pass (2790/2762 jobs).
Fresh source-copy audits check every named declaration (351 production, including
the two public iff statements; 23 private external) and all 192 anonymous
examples. Full print/axiom coverage agrees with both `.ilean` inventories; only
accepted foundational axioms occur. The original audit-parser failure and its
corrected attribute-aware validation remain recorded in the implementation notes.
Final changes from R are documentation only; final verification checks exact
Lean/environment applicability, scope, placeholders, whitespace, links and
artifact hygiene. The independent report and separate reconciliation preserve
their actual checks and limits. C12 remains unstarted.
