# PFR-C08 cumulative readiness audit

Updated 2026-09-27 under the [approved revision-2 plan](plans/pfr-c08-operation-paths-lemma4-normalization.md).
S01-S06 are durably complete. S07 has completed fresh cumulative validation
and independent assessment of the entire C08 contract; final closeout follows. The original S06
crosswalk/evidence remains below; it is not substituted for the fresh S07 pass.
Current duties and results are recorded here and in the
[implementation notes](pfr-c08-implementation-notes.md).

## 0. Current S07 cumulative closeout

Startup verified S06 durable closure
`20378366f1194b032ef919f08a2e97a9b13409042d8188e6e44915d3aea0ddb4`,
all satisfied criteria, its original report/reconciliation and all 123 final
source/environment entries. S07 freshly assessed all eighteen S01-S06 criteria,
R01-R18, CC01-CC10 and CC11's review-time readiness. The same bound reviewer
has returned the fresh cumulative original report and the parent has critically
reconciled it. Final validation, F and durable closure remain mandatory;
CC11 is not complete until those duties finish. C09-C16 remain unstarted.

The parent freshly inspected the path/transport and public consumer contracts,
all six earlier original-report/reconciliation chains, the current source and
manuscript boundaries, and the maintained crosswalk. Two implementation helpers
freshly audited the local calculus and complete structural factorization proof;
their source-based results remain attributed, not independent acceptance.
All 24 current matrix/test/example targets and default `lake build` passed
without diagnostics. A07 freshly checked every one of the 1,828 production
constants and all 98 authored public declarations, with only ordinary axioms.
The sole exhaustive-driver diagnostic is the inherited generated
`OperationKind.toCtorIdx` deprecation; maintained builds are clean.

Every row in Sections 2-4 below has now been reassessed against current source,
fresh builds and A07. The parent finds all eighteen earlier criteria, R01-R18
and CC01-CC10 covered, and CC11 ready for cumulative independent review.
This is the parent's current assessment. The bound cumulative review and original-report reconciliation are complete;
final validation/F and durable closure remain outstanding at this pre-F checkpoint. Sections 1 and 8 preserve
historical S06 checkpoints; their future-duty wording is superseded here.

The original S07 report for R `6a5c14ec570a55c877de3f172cf35001db145e4e367b683ed6358cb53d5019d9`
assesses C08-S07-A/B/C SATISFIED without findings, with explicit fresh coverage
of every earlier criterion, regression and completion-readiness item.
Original capture: `ccff2fe9dc306c92b18d8572beee1ecf3a90feb421abb08895ab800cf7cb4efc`.
Critical reconciliation: `f7c8dbe70a07e6f5ec6970490f03669e75d8920db63c0d080481c9753087f604`.
The report's actual commands, checks and limits remain in the complete original
record. The parent accepts its current-source conclusions after critical review;
its S07-C/CC11 readiness assessment does not certify future F or closure.
All earlier original reports/reconciliations are retained. The nine-document
R-to-F status update includes the independently identified stale OM-042 clause;
no Lean, API, dependency or normative requirement changes. Final source/build
validation and durable closure still determine full CC11 completion.

## 1. Historical S06 status and evidence boundary

The parent freshly verified S05 durable closure
`bfdfe7f14c5c6165d65fd46a278acfbba43af0086fb7b3b680f761adee45c146`
and F `9c07a57997d661700bcd566eebc26b6032737db6b68e14dba4f0eec8631b5b91`.
All 122 entries (121 concrete files plus environment), Git/deletions and both
designated manuscripts match. The original report
`16716006c34243e63b75aebff023560966bbd92543c237144dfd87ab350a3c91`
is reconciled by
`7acf6e499a357372201e343618087fb1a7774220870b7304ed900d76277650e0`;
final PASS evidence is
`7d884472c4dd3dea0cc7b544042b89fe864df3576376b3efb9dfbfebd21fd305`.
All criteria are satisfied with no findings or restrictions. The originating parent checked these original durable records directly. Earlier S05 pre-F prose remains historical and does not reopen S05.

S01-S05 implementation is present and has retained validation/review evidence.
The fresh S06 request covers integrated public consumers and readiness only.
R17/R18 are integrated at TC:409-643. All 16 focused matrix/example/semantic
targets and the default `lake build` passed without diagnostics. The initial exact
source/pin/placeholder/artifact check also passed. S06 independent review and critical reconciliation are complete; final applicable
validation, F and durable closure follow this pre-F checkpoint.
The parent has completed a fresh exhaustive audit of Paths, Factorization and
Calculus on unchanged production bytes/objects: all 1,828 constants passed.
Its exact evidence is recorded below. The original S06 independent report now assesses all three criteria SATISFIED
with no findings; the parent has critically reconciled it. Durable acceptance
still depends on final validation, F and closure. S07 remains
future and must obtain fresh cumulative independent assessment and complete all
subsequent reconciliation/finalization duties.

### Source and evidence keys

All source paths below are relative to the repository root. A reference such as
`P:179` identifies the exact starting line of the named declaration/test region.

| Key | Source or evidence |
| --- | --- |
| P | `PerfectFunctionalRepresentations/Matrix/OperationPaths.lean` |
| F | `PerfectFunctionalRepresentations/Matrix/OperationFactorization.lean` |
| C | `PerfectFunctionalRepresentations/Matrix/OperationCalculus.lean` |
| TP | `PerfectFunctionalRepresentations/Tests/Matrix/OperationPaths.lean` |
| TC | `PerfectFunctionalRepresentations/Tests/Matrix/OperationCalculus.lean` |
| O | `PerfectFunctionalRepresentations/Matrix/Operations.lean` (closed C07 contract) |
| N | `docs/pfr-c08-implementation-notes.md` |
| PL | `docs/plans/pfr-c08-operation-paths-lemma4-normalization.md` |
| M | `docs/formalization-map.md`, especially OM-042/043/051/052 |
| A05 | `tmp/c08-s05-audit/module-audit.json`, complete `module-audit.log`, `source-inventory.json` |
| A03 | `tmp/c08-s03-audit/public-api-audit.json` and complete log; historical source identity |
| A07 | `tmp/c08-s07-audit/audit.json`, complete `audit.log` and `source-inventory.json`; fresh full signature/axiom audit. `.pfr-review/setup/c08-s07-20260927/initial-builds.json` records all 24 targets plus default build. `tmp/c08-s07-path-audit/` and `tmp/c08-s07-factor-audit/` retain attributed fresh source audits. |
| A06 | `tmp/c08-s06-audit/audit.json`, complete `audit.log`, `source-inventory.json`; fresh parent three-module audit PASS; integrated consumer builds: `.pfr-review/setup/c08-s06-20260927/initial-builds.json` |

N owns detailed actor/command/review attribution. Its S01-S05 review sections
report all three criteria satisfied for each step, with original reports and
critical reconciliation. This crosswalk cites those maintained records rather
than presenting the helper's inspection as another independent review.

## 2. All eighteen S01-S06 criteria

Each row was freshly reassessed for S07. References to earlier checks retain
their historical attribution; A07 and the current 24-target/default builds
supply fresh trust and compilation evidence. The original S07 cumulative assessment is complete and reconciled; final
validation/F and closure remain pending. The exact source outcomes in the middle column are unchanged.

| Criterion | Current source and exact outcome | Evidence and remaining duty |
| --- | --- | --- |
| C08-S01-A | P:29/34 four witnessed tags/edges; P:77/82 named explicit quiver/path; P:103-179 chronological tags, append/length, restrictions and source-premised singularity. | Fresh S07 source assessment: covered; A07 and current cumulative builds PASS. Earlier source/test references in this row remain applicable on unchanged Lean bytes. |
| C08-S01-B | P:188 directed `OutputEquiv`; P:197/202/210 identity/inverse/composition; P:217/221/227 card and coordinates; P:234/240 `Cascade`/`NormalForm` data. | Fresh S07 source assessment: covered; A07 and current cumulative builds PASS. Earlier source/test references in this row remain applicable on unchanged Lean bytes. |
| C08-S01-C | TP:44-90 exact C07 targets and changing cards; TP:95/101 recover actual ratio/mask data; TP:180 incompatible local quiver; TP:230 empty cascade retains its bijection. | Fresh S07 source assessment: covered; A07 and current cumulative builds PASS. Earlier source/test references in this row remain applicable on unchanged Lean bytes. |
| C08-S02-A | P:263 split equivalence; P:426/450 merge equivalence and unaffected outputs; P:480/511/526 legal PP/VP transport hypotheses; P:576/583 all four actual edge transports. | Fresh S07 source assessment: covered; A07 and current cumulative builds PASS. Earlier source/test references in this row remain applicable on unchanged Lean bytes. |
| C08-S02-B | P:605/612 path transport preserves exact tags; P:626/630 restrictions; P:649 cascade composition uses the inverse terminal equivalence; P:655-693 tags, identity and associativity. | Fresh S07 source assessment: covered; A07 and current cumulative builds PASS. Earlier source/test references in this row remain applicable on unchanged Lean bytes. |
| C08-S02-C | TP R04-R06 uses unequal weights and a non-involutive permutation, including reversed selected pair/final source label and rejection of the wrong map direction. | Fresh S07 source assessment: covered; A07 and current cumulative builds PASS. Earlier source/test references in this row remain applicable on unchanged Lean bytes. |
| C08-S03-A | C:803/806 disjoint merge/split; C:1295 `ppOverlapCascade`; C:1772 `pvOverlapCascade`; C:1884/1896 exhaustive PPM/PPS and PPM/VPS selectors. | Fresh S07 source assessment: covered; A07 and current cumulative builds PASS. Earlier source/test references in this row remain applicable on unchanged Lean bytes. |
| C08-S03-B | C:466/469 `vpLeftCascade`/`vpRightCascade`; C:868/870 disjoint split case; C:1910 exhaustive VPS/PPS selector. Left overlap uses the required transposition; right overlap has identity final order. | Fresh S07 source assessment: covered; A07 and current cumulative builds PASS. Earlier source/test references in this row remain applicable on unchanged Lean bytes. |
| C08-S03-C | O:1355/1385 supplies (167); C:1933 `c08Inversions` classifies (174); local cases cover (168)-(173). F:1988/2058 supplies the separate global argument. | Fresh S07 source assessment: covered; A07 and current cumulative builds PASS. Earlier source/test references in this row remain applicable on unchanged Lean bytes. |
| C08-S04-A | F:25/39 finite leaf carrier/enumeration; F:67/72/81 positive coefficients/sum one; F:177 `SplitForest`; F:241/269 legal supports; F:277-321 exact mass/value coordinates; F:350/375/391/449 certificate, exhaustive match, root coordinates and gather legality; F:188/361 identity. | Fresh S07 source assessment: covered; A07 and current cumulative builds PASS. Earlier source/test references in this row remain applicable on unchanged Lean bytes. |
| C08-S04-B | F:514/654/780 append PPS/VPS/PPM; F:211 same-sheet exclusion; F:735 injectivity after merge; F:800/815 induction on the original allowed path. | Fresh S07 source assessment: covered; A07 and current cumulative builds PASS. Earlier source/test references in this row remain applicable on unchanged Lean bytes. |
| C08-S04-C | F:819-1327 checks certificate/R11-R13; private/local helper boundary; notes give the exact support/value/matching interface. | Fresh S07 source assessment: covered; A07 and current cumulative builds PASS. Earlier source/test references in this row remain applicable on unchanged Lean bytes. |
| C08-S05-A | F:1455 `srPpsTree`, F:1514 `srVpsTree`, F:1936 `sgGatherTree`; F:1643/1723 finite root-family induction; F:1988 `FactorizationCertificate.realize`. Explicit bijections preserve pending/completed ambient coordinates. | Fresh S07 source assessment: covered; A07 and current cumulative builds PASS. Earlier source/test references in this row remain applicable on unchanged Lean bytes. |
| C08-S05-B | F:2058 `OperationPath.normalize`, F:2067 `Cascade.normalize`; P:704 `NormalForm.toCascade`, P:715 allowed-tag converse, P:725-737 singularity with explicit `hS`, P:741 terminal composition, P:749-799 empty/one-block constructors. | Fresh S07 source assessment: covered; A07 and current cumulative builds PASS. Earlier source/test references in this row remain applicable on unchanged Lean bytes. |
| C08-S05-C | TC:56-185 R14/R16; TC:187-405 mixed R15; F has 58 examples, TC has 28 before S06 integration. A05 covers all 790 P/F constants and the 16 authored S05 additions. | Fresh S07 source assessment: covered; A07 and current cumulative builds PASS. Earlier source/test references in this row remain applicable on unchanged Lean bytes. |
| C08-S06-A | TC:411 extracts three actual stages, exact replicated tag words, concatenation, singularity and final PMF map. TC:443-531 structurally extracts ratios/masks and proves count/order/legality. TC:535-643 composes directed output maps and checks asymmetric traps. | Fresh S07 source assessment: covered; A07 and current cumulative builds PASS. Earlier source/test references in this row remain applicable on unchanged Lean bytes. |
| C08-S06-B | This audit maps all 18 S01-S06 criteria, R01-R18, CC01-CC11, source anchors and every public declaration through complete inventories. Omission/deferral reassessment is below. | Fresh S07 source assessment: covered; A07 and current cumulative builds PASS. Earlier source/test references in this row remain applicable on unchanged Lean bytes. |
| C08-S06-C | All 16 focused targets and default build pass without diagnostics. Fresh A06 audits all current production signatures/axioms. Production imports/API and prior tests remain unchanged. | Fresh S07 source assessment: covered; A07 and current cumulative builds PASS. Earlier source/test references in this row remain applicable on unchanged Lean bytes. |

## 3. All eighteen regression rows

| ID | Current concrete coverage | State at this snapshot |
| --- | --- | --- |
| R01 | TP:11-35 nil/tags/restrictions; TP:196/200 equivalence laws; TP:230-260 nontrivial empty relabeling; TP:272 package from empty blocks. | Fresh S07 source inspection and maintained compilation PASS; exact witnesses and edge cases checked. |
| R02 | TP:44-90 all four actual C07 edges, changed cards and VPM exclusion; TP:95-115 Type-valued parameter recovery. | Fresh S07 source inspection and maintained compilation PASS; exact witnesses and edge cases checked. |
| R03 | TP:119-193 actual PPS/PPM path, chronological `[pps, ppm]`, append/length/restrictions, source singularity and explicit-quiver boundary. | Fresh S07 source inspection and maintained compilation PASS; exact witnesses and edge cases checked. |
| R04 | TP:291-436 generic label transport and numerical first/final split choices; ratio 1/3, unequal masses, both mask pieces, every retained label. | Fresh S07 source inspection and maintained compilation PASS; exact witnesses and edge cases checked. |
| R05 | TP:437 onward nonadjacent labels 1/3 mapped in reversed order for PP and VP, including original final label. | Fresh S07 source inspection and maintained compilation PASS; exact witnesses and edge cases checked. |
| R06 | TP's `ppSplitRecovery`, `ppMergeRecovery`, `vpSplitRecovery`, `vpMergeRecovery`, `concretePPRecovery`, `concreteVPRecovery`, and final composition consumers. Actual recovery maps, inverses and asymmetric direction rejection. | Fresh S07 source inspection and maintained compilation PASS; exact witnesses and edge cases checked. |
| R07 | C:2139 onward all three disjoint interchange types, three merge/split relative positions, both disjoint VPS/PPS orders. | Fresh S07 source inspection and maintained compilation PASS; exact witnesses and edge cases checked. |
| R08 | C:1308 onward selected pair 0/3, unequal positive masses, nonsymmetric strict ratio and intervening outputs; actual cascade at C:1406. | Fresh S07 source inspection and maintained compilation PASS; exact witnesses and edge cases checked. |
| R09 | C:1945 onward literal value-one (171) fixture, right-child counterpart, asymmetric relabeled source at C:2054 and forward map `[4,0,2,1,3]`; inverse/direction checks. | Fresh S07 source inspection and maintained compilation PASS; exact witnesses and edge cases checked. |
| R10 | C:1788 onward equal-support selected columns with unequal masses; null input 2 and two masks differing only off selected support. | Fresh S07 source inspection and maintained compilation PASS; exact witnesses and edge cases checked. |
| R11 | F:1111/1146-1179 genuine two-output singleton-input source; nil outer/support/gather trees, explicit matching inverses and coordinates, impossibility of two legal VPS pieces on Unit. | Fresh S07 source inspection and maintained compilation PASS; exact witnesses and edge cases checked. |
| R12 | F:831-862 generic PPS duplicate compensation and labels; F:1049-1108 concrete sheet with two support pieces and every unaffected gathering coordinate. | Fresh S07 source inspection and maintained compilation PASS; exact witnesses and edge cases checked. |
| R13 | F:873-923 value-one VPS; F:923-1048 successive legal refinements; F:1213-1327 nonadjacent/final-label PPM, explicit fragment targets/matches and same-sheet exclusion. | Fresh S07 source inspection and maintained compilation PASS; exact witnesses and edge cases checked. |
| R14 | TC:56-91 all-empty/one-block witnesses; TC:135-177 actual normalization of nil/PPS/VPS/PPM and exact endpoint cards/row maps. | Fresh S07 source inspection and maintained compilation PASS; exact witnesses and edge cases checked. |
| R15 | F:1405-1447 and F:1900-1927 early correspondence; TC:187-405 mixed `[ppm,vps,pps]`, cards 3→2→3→4, three initial columns, unequal masses, explicit non-self-inverse terminal permutation and both normalization entry points. | Fresh S07 source inspection and maintained compilation PASS; exact witnesses and edge cases checked. |
| R16 | TC:92-133 exact final cardinality, every intermediate output active, positive finite admitted values and no VPM; F:72 `sfCoeff_pos`, F:2015 its actual VPS-legality use supplies positive branch coefficients. | Fresh S07 source inspection and maintained compilation PASS; exact witnesses and edge cases checked. |
| R17 | TC:411 extracts actual stages and compares each tag word with `List.replicate length kind`, concatenates in order, obtains intermediate singularity and directed endpoint PMF equality. TC:557 also compares composed concrete cascades. | Fresh S07 source inspection and maintained compilation PASS; exact witnesses and edge cases checked. |
| R18 | TC:443-531 uses structural path induction to collect actual strict PPS ratios and VPS records containing source/label/mask/nonempty-support proofs; homogeneous block counts and exact snoc order are checked. TC:535/546 composes a supplied output equivalence and proves forward/inverse coordinates and both row maps. TC:581/622/631 rejects erased or reversed bijections. | Fresh S07 source inspection and maintained compilation PASS; exact witnesses and edge cases checked. |

## 4. CC01-CC11 readiness and remaining duties

| Completion criterion | Evidence crosswalk | Readiness versus later duties |
| --- | --- | --- |
| CC01 | P:34 legal C07 wrappers, P:156 three-tag restriction; F:2058 exact allowed-path theorem. R02/R14/R16. | Fresh S07 parent assessment: covered by current source, A07, cumulative builds and reconciled owning documents; original cumulative review SATISFIED and critically reconciled; final validation/F/closure follow. |
| CC02 | P:103-179 and TP R01-R03; constructors retain parameters and exact state-indexed dimensions. | Fresh S07 parent assessment: covered by current source, A07, cumulative builds and reconciled owning documents; original cumulative review SATISFIED and critically reconciled; final validation/F/closure follow. |
| CC03 | P:188-227, split/ordered-merge transport and P:612/649; R04-R06/R15. | Fresh S07 parent assessment: covered by current source, A07, cumulative builds and reconciled owning documents; original cumulative review SATISFIED and critically reconciled; final validation/F/closure follow. |
| CC04 | O:1355/1385, all C local case selectors, C:1933 and F realization. R07-R10 and source table below. | Fresh S07 parent assessment: covered by current source, A07, cumulative builds and reconciled owning documents; original cumulative review SATISFIED and critically reconciled; final validation/F/closure follow. |
| CC05 | F:177-815 support/value/coordinate invariant, exhaustive matching and actual append closures; R11-R13. | Fresh S07 parent assessment: covered by current source, A07, cumulative builds and reconciled owning documents; original cumulative review SATISFIED and critically reconciled; final validation/F/closure follow. |
| CC06 | F tree inductions and finite-family induction, F:1988/2058/2067. Multiple initial outputs in R11/R15. | Fresh S07 parent assessment: covered by current source, A07, cumulative builds and reconciled owning documents; original cumulative review SATISFIED and critically reconciled; final validation/F/closure follow. |
| CC07 | P:240/704-799 and F:2058/2067. Actual three stages, retained legal-step parameters, terminal map and source-premised singularity are public. | Fresh S07 parent assessment: covered by current source, A07, cumulative builds and reconciled owning documents; original cumulative review SATISFIED and critically reconciled; final validation/F/closure follow. |
| CC08 | TP60/C51/F58/TC38 examples; all 24 current targets and default build PASS. Fresh A07 audits all 1,828 production constants with ordinary axioms only. | Fresh S07 parent assessment: covered by current source, A07, cumulative builds and reconciled owning documents; original cumulative review SATISFIED and critically reconciled; final validation/F/closure follow. |
| CC09 | Approved PL Sections 2/3/11; M OM-042/043/051/052 and related owner/trigger rows; no-FWN register. | Fresh S07 parent assessment: covered by current source, A07, cumulative builds and reconciled owning documents; original cumulative review SATISFIED and critically reconciled; final validation/F/closure follow. |
| CC10 | N, living summary, README, scope, roadmap, map, log, editorial plan marker and this readiness audit. | Fresh S07 parent assessment: covered by current source, A07, cumulative builds and reconciled owning documents; original cumulative review SATISFIED and critically reconciled; final validation/F/closure follow. |
| CC11 | PL explicitly separates review-time readiness from later report receipt/reconciliation, correction, final validation, F and closure. | **S07 review-time readiness covered and independently assessed.** The original report is retained and critically reconciled; no required correction remains. Final validation/F and durable closure are mandatory subsequent duties. Only their actual completion satisfies CC11 in full. |

## 5. Exact manuscript allocation

At S07 startup the parent freshly verified both designated PDF hashes, then
visually reread the retained ISIT p.3 and extended pp.4,14-15 renders. This is
fresh visual reading of retained renders, not a claim of fresh rendering.
The path-audit helper separately rechecked the relevant manuscript pages.
Exact identities and anchors remain those of approved PL Section 2.

- Six-page ISIT final (3):
  `48963aa59485b2c33b1a1e6e7c6ead2251fdddd26bd3691b6fcffe683e6ed1c4`.
  PDF p.3, III-A, order-manipulation paragraph and Lemma 4; inherited Operations
  1-4 and (11)-(15) stay C07 contracts.
- Designated extended (16), 18 pages:
  `98636d4c9f0618ec08fca84559572780f604f197fda90d8d7c787b3624245b8f`.
  Lemma 4 statement p.4 left; Appendix B p.14 right through p.15 left before Lemma 5.

| Anchor | Precise checked content and current source | Boundary/repair |
| --- | --- | --- |
| ISIT Lemma 4; extended Lemma 4 statement | F:2058/2067, P:240/704/715. Every allowed finite path/cascade from an active singular source has PPS/VPS/PPM stages and an actual directed terminal bijection; converse is concatenation. | No perfect-representability, prior or full-input-support premise. Empty stages allowed. |
| (167), p.14 | O:1355 `vps_support_indicator_sum` and O:1385 `vps_indicator_sum`; inherited nonempty support partition feeds legal VPS traversals. | Ordinary addition of disjoint support indicators; reused C07 result. |
| (168)-(169), p.14 | C:1295 `ppOverlapCascade`, disjoint C:806 and exhaustive C:1884; R08/R07. | Same strict ratio on both original columns, all survivor/unaffected coordinates and final higher label. |
| (170)-(171), p.14 | C:466/469, disjoint C:870, exhaustive C:1910; R09. | Left replacement ends in `[t*A,B,(1-t)*A]`; terminal swap compares it to printed order. Right-child case separately proved. No false literal ordered equality. |
| (172)-(173), p.15 | C:1772, disjoint C:806, exhaustive C:1896; R10/R07. | Both equal-support columns inherit the same nonempty pieces. Masks may differ on null rows outside support. |
| (174), p.15 | C:1933 `c08Inversions`. | Exactly three out-of-order pairs; classification only, not a decreasing measure. |
| Concluding repeat-interchanges argument, p.15 | F:800 original-path induction; F:1455/1514/1936 proper-subtree traversal; F:1643/1723 finite-family induction; F:1988 realization. | Supplies the missing global finite argument. No claim about every expanding rewrite strategy. |
| Adjacent later passages | Source context identifies future consumers only. | Extended (149)-(166) stays C05; (175)-(202), ISIT III-B/IV-A stay mapped C09-C13. |

## 6. Public API, imports and trust

The machine-readable `tmp/c08-s06-readiness/retained-declaration-index.csv` lists all 790 audited P/F
constants with kind, visibility, authored-public source line where applicable,
axiom dependencies and exact-current-source applicability. Its public subset is
`tmp/c08-s06-readiness/retained-public-api-index.csv`: 312 entries, including generated constants; 98
are authored public declarations (96 in P, two in F). These totals are not 312
independent authored API commitments. All entries point to complete A05 evidence.
`tmp/c08-s06-readiness/current-declaration-index.csv` and `tmp/c08-s06-readiness/current-public-api-index.csv` supplement
these retained indices with fresh A06 evidence for all 1,828 constants; the
312 compiler-public / 98 authored-public surface remains unchanged.

| Public surface | Current source | Intended downstream use |
| --- | --- | --- |
| Four tags/edges, explicit `operationQuiver`, `OperationPath` and nil/snoc/append/tag/length/restriction laws | P:29-185 | Actual witnesses with state-owned finite labels, no global quiver instance. |
| `OutputEquiv` and identity/inverse/trans/cardinality/coordinate/coordinate-construction laws | P:188-227 and transport section | Directed finite output bijection, not a quotient or unordered multiset. |
| Split insertion correspondence, ordered merge endpoints and PP/VP equivariance | P:263-565 | Arbitrary explicit source permutation, including selected-pair reversal and every retained coordinate. |
| `OperationStep.Transport`, `OperationPath.Transport`, restriction transport | P:576-632 | Same operation kind/chronological word and a new-to-original terminal comparison. |
| Cascade identity/path embedding/composition/semantic comparison and tag laws | P:640-695 | Compose through the inverse terminal map; retain semantic endpoint identity/associativity. |
| NormalForm fields and fourteen S05 convenience/converse declarations | P:240 and P:704-799 | Three actual paths/states, homogeneous proofs, explicit terminal map, nil/one-block cases and source-premised singularity. |
| `OperationPath.normalize`, `Cascade.normalize` | F:2058/2067 | `Nonempty (NormalForm S T)` for arbitrary allowed source-singular path/cascade. All private certificate types stay out of signatures. |

Current direct imports are acyclic:

```text
OperationPaths -> Matrix.Operations + Mathlib.Combinatorics.Quiver.Path
OperationFactorization -> OperationPaths + Mathlib.Data.Tree.Basic
                        + Mathlib.Data.Fintype.Option + Mathlib.Logic.Equiv.Sum
OperationCalculus -> OperationFactorization + NormNum + FinCases + Finiteness
Tests.Matrix.OperationCalculus -> OperationCalculus
```

O consumes supported `LeanInfoTheory.Probability.FiniteMixture` and C06/C07 local
modules. C06 Channel consumes supported `LeanInfoTheory.Probability.Finite`.
The lightweight root still has only its six semantic/probability imports and
does not directly import matrix calculus/tests. No dependency upgrade or new
general information-theory theorem is involved. S06's generic consumers must keep
using public imports and must not copy private certificate names into their types.

### Retained audit and fresh S06 audit

A05 passed all 790 signatures/axiom reports: P319 (14 private), F471 (464 private).
F's seven public module-attributed constants are the two authored normalizers plus
five verified inherited equations: four `OperationStep.kind.eq_i` and
`OperationPath.Homogeneous.eq_1`. P adds fourteen authored S05 helpers and four
generated support constants. Only `propext`, `Classical.choice`, `Quot.sound`
occur; 106 constants are axiom-free. The sole warning is the preserved inherited
`OperationKind.toCtorIdx` deprecation from exhaustive inspection.

The original classification FAIL for the generated homogeneous equation remains
retained, followed by its actual `Eq.refl` body inspection and passing rerun.
This does not add a third authored normalization API. Exact source hashes currently
match A05; `tmp/c08-s06-readiness/evidence-snapshot.json` records this read-only comparison. No build or
audit was rerun by this helper.

A06 is a fresh parent audit with all 14 checks passing: P319 (14 private),
F471 (464 private), C1038 (all private), total 1,828; 325 are axiom-free.
The public surface is exactly S05's 312 compiler-public constants, including
98 authored public declarations. Only `propext`, `Classical.choice`, and
`Quot.sound` occur. The sole retained diagnostic is the inherited generated
`OperationKind.toCtorIdx` deprecation. Complete signatures, dependencies and
imports are in A06, with unchanged source/objects/drivers during execution.

- A06 report SHA-256:
  `bdc6e07aa005846fd8db5938ab2ab02a1e2f8fbaa412b2e2fdd921624cfee485`.
- A06 complete log SHA-256:
  `ac147b2287001ca78a3684a0d2db6e17005cf17a536f1251fd50fa290c0eaf10`.
- `tmp/c08-s06-readiness/current-audit-snapshot.json` records the helper's read-only evidence/hash
  comparison and preserves exact production source/olean/driver identities.

| Module | Retained audited source SHA-256 | Current applicability |
| --- | --- | --- |
| P | `238494c96b01c199480003f15b63d9a89a1a10354775b3a6070d2e3989f0111e` | Exact A05/A06 match. |
| F | `c960f20d699d946bddc8365fa5ee233bb1c2de4b73e43c5dc45360e0238b10ca` | Exact A05/A06 match. |
| C, current A06 | `5b9de2d4f08e4abe076aaa32da37ffa2a49ac4f4cddd9f61f4274debca227e02` | Fresh exact A06 match. A03's different source hash remains historical, not current evidence. |

S05's three supplemental pinned foundations remain explicitly separate from the
registered source-manifest entries. S06 adds a fourth: the parent inspected
`List.eq_replicate_length` at `Mathlib/Data/List/Basic.lean:206`, used by the
generic homogeneous-tag consumer with no new import. All four files are freshly rehashed for S07 and carried explicitly into the
independent request, separate from the fixed inventory:

| Relative mathlib path | Expected SHA-256 |
| --- | --- |
| `Data/Fintype/Option.lean` | `c386ad09d8a6dd38e5f9522cdec969cc389eec739760f8472b0fa6a0aa32956f` |
| `Logic/Equiv/Defs.lean` | `2609b0e60761a9e1cbb9d8dcc964b387f4e80a71936727a300c7a48c72804449` |
| `Logic/Equiv/Sum.lean` | `c62a5e93b50417600d663d4207ca0b58ef48d097620c1bbf6d943de161fd086d` |
| `Data/List/Basic.lean` | `34f4595efa94a796ce054f9fdc00628c4154827e7b4e0574f2a02e05ecbde5b0` |

### Fresh S07 exhaustive audit

A07 was newly executed for cumulative closeout, rather than relabeling A06.
All fourteen checks passed: P319/F471/C1038 constants (1,828 total),
14/464/1038 private respectively, 312 compiler-public constants, and all
96/2/0 authored public declarations. Exactly 325 constants are axiom-free;
the others use only `propext`, `Classical.choice`, and `Quot.sound`.
Complete signatures and dependencies were freshly printed. Production source,
objects, driver and parser stayed exact throughout. The hashes above match A07.

- A07 report SHA-256: `f7b379708db1208271967b7240782e6d70dbdba8738828209e274ea0ea43fdc6`.
- A07 complete log SHA-256: `90b36c96c52f1e004e153b852c6f4a9e81061dbcd4cccce4ff7b2a2ddfe6eea2`.
- Fresh full inventories and authored source lines are in A07 and its
  `source-inventory.json`; the maintained 98-name index below remains exact.

## 7. Omission and deferral reassessment

| Owner / trigger | Fresh reassessment at S07 | Disposition |
| --- | --- | --- |
| OM-042: current source-anchor audit | Trigger occurs now. Every (167)-(174) item is mapped above, with global justification separated from inversion classification. | Required logical content is implemented. Keep scalar/private helpers private; S07/A07 validates current coverage. |
| OM-043: rigorous global argument | Implemented by original-path certificate plus finite tree/family realization. S05 review/closure is completed per parent verification. | Required structural argument discharged. Arbitrary rewrite termination, shortest form, uniqueness/confluence/complexity remain outside scope; revisit only under an explicitly approved algorithmic consumer. |
| OM-051: equivalence/inverse prose | Current API retains direction and remembered ratios/masks; (171)'s corrected permutation and asymmetric tests are present. R17/R18 exercise the public consumer boundary. | No global inverse/unique off-support mask is claimed. Path reversal remains C10's two-direction reachability obligation; no new owner needed. |
| OM-052: arbitrary multiway synthesis / private-helper promotion | Private finite-family wrappers only combine supplied single-tree callbacks; production realization uses recorded forests from a given path. S06's consumers need only public paths/NormalForm. | No trigger to expose tree machinery or synthesize arbitrary weights/partitions/fibers. C10/C11 retain those constructors; revisit promotion for a concrete consumer in their approved plans. |
| OM-024/070: full ordered merge range | Existing nonadjacent/final-label regressions and actual C07 maps remain in use. | No further repair; preserve the historical duplicate ID. |
| OM-026/050: named example API and beta | Generic public S06 consumers do not require exposing C07 Examples 2-5. Existing assumptions remain attributed. | No fixture promotion; trigger remains a real named-fixture consumer. |
| OM-038/049: zero weights/empty pieces/pruning | Recorded support trees keep nonempty pieces, PPS ratios are strict, inclusive value-one VPS is exercised. | No raw/prune-zero bridge required here. C10/C11 handle arbitrary-family zero weights/empty fibers when their triggers arise. |
| OM-044/045/068: state/value/presentation | ActiveFiniteChannel, existing singular-column reconstruction and exact finite labels are reused. | No replacement state or value assigned to a zero column. |

The authoritative register at `docs/project-log.md:11-34` says no numbered Future
Work Notes have been opened. PL Section 11 and the planning dispositions preserve
the same state. This inspection identifies no new worthwhile unowned deferral:
all remaining duties have existing S07 or C10/C11 owners and concrete triggers.
Do not create a duplicate FWN or turn pending acceptance work into optional work.

## 8. Historical S06 validation and subsequent duties

The parent integrated ten new anonymous examples and private test-only folds in
TC:409-643. The original 28 examples remain intact, giving 38 total. The parent
focused build covers all 16 current matrix, matrix-test, example and semantic
singularity targets; it and the default `lake build` passed without diagnostics.
Actual commands/output are retained in
`.pfr-review/setup/c08-s06-20260927/initial-builds.json`. Builds may be incremental.
A06 independently enumerates/audits every current production constant as above;
its one generated deprecation is separate from these clean build results.

The seven generic consumers check exact stage words, actual concatenation,
source-premised singularity, retained ratio/mask values and legality by structural
path induction, endpoint transport and semantic cascade comparison. Three
concrete fixtures distinguish stored bijections even for equal columns, distinguish
permuted pure rows, and reject the inverse of a non-involutive three-cycle as the
forward map. All helper definitions remain private in the test module. The
production files, production public surface and direct imports are unchanged.

The helper's successful scratch probe and all four superseded failing probe logs
are retained in `tmp/c08-s06-consumers/`. The first probes needed dependent-source
annotations and explicit finite labels; these were proof-elaboration repairs,
not new assumptions. The parent integrated and built the maintained source.
A scan-only English comment was changed before the maintained build completed.

The initial exact source check passed: only the ten owned paths changed; all
three production modules and normative plan bytes remain exact to B; no
placeholders, tracked generated artifacts, missing local links or trailing spaces
were found; all four supplemental pinned hashes and all seventy omission IDs
are intact. That status-only update was checked again before freezing review.

S06 contextual self-review and separate reassessment are retained. The same
bound reviewer returned one complete original report for R `d86b935d8884ee1538e6c2083510a01c9f5821d89e816ee547c5ed64dae30ab1`,
assessing all three S06 criteria SATISFIED with no findings. Its original capture
`e6d1733532d1218fee6c9444a2d67c61db88a0b55b3ec17a06c17427931bc383` is critically reconciled by
`0df732de8fcbd2c9834c0ab1cfa4625eac752a5e0b504eac5e85e0e812a3c270`. Exact checks and original limitations remain
in that report; no parent or helper verdict replaces its evidence.

This document now records the pre-F checkpoint. Final applicable focused/default
builds, exact source/pin/placeholder/artifact checks, F and durable S06 closure
follow the nine bounded documentation updates. Reviewed production/tests/imports,
all normative requirements, pins and tooling stay unchanged. The complete A06
audit remains applicable only under exact source/object hashes. Step acceptance
is determined by the durable execution record, not this prospective status text.

S07 remains unstarted. S07-A/B must freshly assess all eighteen S01-S06 criteria,
R01-R18, CC01-CC10 and CC11 review-time readiness against then-current source.
S07-C owns receipt/reconciliation of that report, justified corrections, final
validation, F and durable chunk closure. Only completing those subsequent duties
satisfies CC11 in full; neither this audit nor the S06 review pre-certifies them.

## 9. Complete authored public declaration index

All 98 authored public declarations below are covered by the fresh A07 signature
and axiom pass. Names are relative to `PerfectFunctionalRepresentations.MatrixOperations`.
Structure constructors/projections and generated support constants are also
covered individually in the complete 1,828-entry audit: the public subset has
312 constants. This compiler inventory is broader than the authored API.
The full audit, drivers, source/object hashes and declaration CSV are retained
durably under `.pfr-review/setup/c08-s07-20260927/audit/`; the original scratch
evidence remains intact. No production declaration, test or import changed in S07.

| Declaration | Module:line |
| --- | --- |
| `Cascade` | OperationPaths:234 |
| `Cascade.Equivalent` | OperationPaths:669 |
| `Cascade.allowed_comp` | OperationPaths:664 |
| `Cascade.comp` | OperationPaths:649 |
| `Cascade.comp_assoc` | OperationPaths:682 |
| `Cascade.comp_refl` | OperationPaths:679 |
| `Cascade.compare` | OperationPaths:672 |
| `Cascade.length_comp` | OperationPaths:659 |
| `Cascade.normalize` | OperationFactorization:2067 |
| `Cascade.ofOutputEquiv` | OperationPaths:640 |
| `Cascade.ofPath` | OperationPaths:646 |
| `Cascade.refl` | OperationPaths:643 |
| `Cascade.refl_comp` | OperationPaths:676 |
| `Cascade.tags_comp` | OperationPaths:655 |
| `Cascade.tags_comp_assoc` | OperationPaths:693 |
| `Cascade.tags_comp_refl` | OperationPaths:689 |
| `Cascade.tags_refl_comp` | OperationPaths:685 |
| `NormalForm` | OperationPaths:240 |
| `NormalForm.isSingular` | OperationPaths:737 |
| `NormalForm.ofOutputEquiv` | OperationPaths:749 |
| `NormalForm.ofPpm` | OperationPaths:791 |
| `NormalForm.ofPps` | OperationPaths:765 |
| `NormalForm.ofVps` | OperationPaths:778 |
| `NormalForm.pm_isSingular` | OperationPaths:733 |
| `NormalForm.pp_isSingular` | OperationPaths:725 |
| `NormalForm.refl` | OperationPaths:762 |
| `NormalForm.toCascade` | OperationPaths:704 |
| `NormalForm.toCascade_normalizing` | OperationPaths:715 |
| `NormalForm.toCascade_tags` | OperationPaths:710 |
| `NormalForm.transOutputEquiv` | OperationPaths:741 |
| `NormalForm.transOutputEquiv_tags` | OperationPaths:745 |
| `NormalForm.vp_isSingular` | OperationPaths:729 |
| `OperationKind` | OperationPaths:29 |
| `OperationPath` | OperationPaths:82 |
| `OperationPath.Allowed` | OperationPaths:148 |
| `OperationPath.Homogeneous` | OperationPaths:152 |
| `OperationPath.Normalizing` | OperationPaths:156 |
| `OperationPath.Transport` | OperationPaths:605 |
| `OperationPath.allowed_append` | OperationPaths:166 |
| `OperationPath.allowed_nil` | OperationPaths:159 |
| `OperationPath.allowed_snoc` | OperationPaths:162 |
| `OperationPath.append` | OperationPaths:99 |
| `OperationPath.append_assoc` | OperationPaths:121 |
| `OperationPath.append_nil` | OperationPaths:119 |
| `OperationPath.homogeneous_append` | OperationPaths:173 |
| `OperationPath.homogeneous_nil` | OperationPaths:170 |
| `OperationPath.isSingular` | OperationPaths:179 |
| `OperationPath.length` | OperationPaths:103 |
| `OperationPath.length_append` | OperationPaths:139 |
| `OperationPath.length_nil` | OperationPaths:134 |
| `OperationPath.length_snoc` | OperationPaths:136 |
| `OperationPath.nil` | OperationPaths:92 |
| `OperationPath.nil_append` | OperationPaths:116 |
| `OperationPath.normalize` | OperationFactorization:2058 |
| `OperationPath.snoc` | OperationPaths:95 |
| `OperationPath.tags` | OperationPaths:106 |
| `OperationPath.tags_append` | OperationPaths:125 |
| `OperationPath.tags_length` | OperationPaths:142 |
| `OperationPath.tags_nil` | OperationPaths:111 |
| `OperationPath.tags_snoc` | OperationPaths:113 |
| `OperationPath.transport` | OperationPaths:612 |
| `OperationPath.transport_allowed` | OperationPaths:626 |
| `OperationPath.transport_homogeneous` | OperationPaths:630 |
| `OperationStep` | OperationPaths:34 |
| `OperationStep.Transport` | OperationPaths:576 |
| `OperationStep.isSingular` | OperationPaths:66 |
| `OperationStep.kind` | OperationPaths:59 |
| `OperationStep.transport` | OperationPaths:583 |
| `OutputEquiv` | OperationPaths:188 |
| `OutputEquiv.apply` | OperationPaths:221 |
| `OutputEquiv.apply_symm` | OperationPaths:227 |
| `OutputEquiv.columnValue` | OperationPaths:304 |
| `OutputEquiv.isSingular` | OperationPaths:296 |
| `OutputEquiv.mergeEquiv` | OperationPaths:426 |
| `OutputEquiv.mergeEquiv_ne_survivor` | OperationPaths:464 |
| `OutputEquiv.mergeEquiv_survivor` | OperationPaths:442 |
| `OutputEquiv.mergeEquiv_unaffected` | OperationPaths:450 |
| `OutputEquiv.mergeLower` | OperationPaths:393 |
| `OutputEquiv.mergeUpper` | OperationPaths:397 |
| `OutputEquiv.merge_lt` | OperationPaths:400 |
| `OutputEquiv.ofCoordinates` | OperationPaths:285 |
| `OutputEquiv.outputCard_eq` | OperationPaths:217 |
| `OutputEquiv.ppm` | OperationPaths:491 |
| `OutputEquiv.ppmPattern` | OperationPaths:480 |
| `OutputEquiv.pps` | OperationPaths:313 |
| `OutputEquiv.refl` | OperationPaths:197 |
| `OutputEquiv.symm` | OperationPaths:202 |
| `OutputEquiv.trans` | OperationPaths:210 |
| `OutputEquiv.vpm` | OperationPaths:540 |
| `OutputEquiv.vpmDisjoint` | OperationPaths:526 |
| `OutputEquiv.vpmValue` | OperationPaths:511 |
| `OutputEquiv.vps` | OperationPaths:337 |
| `OutputEquiv.vpsWitness` | OperationPaths:330 |
| `operationQuiver` | OperationPaths:77 |
| `splitOutputEquiv` | OperationPaths:263 |
| `splitOutputEquiv_keep` | OperationPaths:272 |
| `splitOutputEquiv_left` | OperationPaths:276 |
| `splitOutputEquiv_right` | OperationPaths:268 |
