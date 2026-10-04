# PFR-C10 implementation notes

The [approved revision-2 plan](plans/pfr-c10-generic-reachability-easy-direction.md)
owns the mathematical contract. These notes record implementation, source
interpretation, validation and review evidence. Earlier planning and advice
remain in the [planning notes](pfr-c10-planning-notes.md).

## S01 - Restricted reachability, reversal and easy direction

**Status, 2026-09-28:** S01 implementation and independent review complete; the
original report is critically reconciled. Final validation, F and durable closure
follow this maintained checkpoint. The lead requested S01 with review after
endorsing revision 2. S02-S07 remain unstarted.

### Baseline and authority

The execution session registered the approved plan at full-file SHA-256
`10732683bb6327a307e9b4807a0d26b5bb08630110f75d7ebf00ca573e1e3267`.
Its normative text is unchanged; only the reserved status region may record
progress. The actual S01 baseline B is
`68c56ca27d589f19dc1ff66887286c860469e6e63a0542d4d453c77525e0b5e4`.
It includes inherited uncommitted C01-C09 source at HEAD
`54c1714d1a9a891939d6c9f7d38c0d05896b2c75`; cumulative Git differences are not
attributed to S01. Private evidence lives under
`.pfr-review/setup/c10-s01-20260928/` and the installed C10 execution record.

The existing reviewer `/root/pfr_c10_reviewer` remains bound to originating task
`01a0e771-5cb9-7710-b634-1c4ca0b6cad3`. Requested settings remain Astra/ultra with
no parent-history copying; effective settings remain unobserved. Implementation
helpers are separate from that reviewer. Revision 1's report-admission limitation
is retained history and is not rewritten by this execution session.

### Source interpretation and boundaries

The parent freshly inspected both page-4 renderings and corresponding text:

- ISIT III-B, Theorem 1's opening and easy direction, Lemmas 5-6 and their
  repeated-use/inverse prose. The six-page manuscript SHA-256 is
  `48963aa59485b2c33b1a1e6e7c6ead2251fdddd26bd3691b6fcffe683e6ed1c4`.
- Extended version 16, designated 2026-09-03, III-B p. 4, the same reachability
  directions and opening proof. The eighteen-page manuscript SHA-256 is
  `98636d4c9f0618ec08fca84559572780f604f197fda90d8d7c787b3624245b8f`.

The from-seed restriction is PPS/VPS/PPM; reduction to the seed permits
PPM/PPS/VPM. Reversal uses the supplied operation's remembered ratio or support
mask and a directed recovered-to-original output equivalence. This implements
OM-051's interpretation of inverse prose. A merge alone does not determine its
source, and no equality of twice-reversed proof data is required.

Finite, nonempty inputs are the existing active-channel boundary. Perfectness
folds require no prior, full-support premise or extra singularity premise.
Generic singularity propagation keeps its initial hypothesis for a nil path.
The seed supplies that hypothesis for reachability. The canonical construction
and hard perfectness direction remain C11; finite multiway synthesis remains
S03-S05. No mapped deferral or numbered Future Work Note is added by S01 startup.

### Implementation and public contract

The new [Reachability module](../PerfectFunctionalRepresentations/Matrix/Reachability.lean)
imports only `Matrix.OperationPaths` and `Matrix.Preservation`. Its declarations
live in `PerfectFunctionalRepresentations.MatrixOperations`. The mathematical
root, C07-C09 implementations and pinned dependencies stay unchanged.

| Contract | Public interface and proof boundary |
| --- | --- |
| Remembered operation reversal | `OperationKind.reverse` swaps PPS/PPM and VPS/VPM. `OperationStep.reverse` returns one concrete recovery operation and its C07 output correspondence. `tags_reverse` and `length_reverse` certify its kind and operation count. |
| Finite reversal | `OperationPath.reverse` reverses the final edge before the prefix. `Cascade.reverse` first uses the inverse of its final output comparison. Their tag laws give `tags.reverse.map OperationKind.reverse`; operation count is unchanged. |
| Restriction transfer | `OperationPath.Reducing` is exactly PPM/PPS/VPM. Path and cascade `reverse_allowed` transfer any tag predicate; `reverse_reducing` and `reverse_normalizing` exchange the two required restrictions. |
| Local-result folds | Path and cascade `isPerfectlyRepresentable` fold the three C09 positive implications. Their `not_isPerfectlyRepresentable` folds the three negative implications, and `reflects_isPerfectlyRepresentable` gives the contrapositive. |
| Directed relabeling | `OutputEquiv.isPerfectlyRepresentable_iff` consumes the existing semantic injective-map theorem. `FromAllOnes.outputEquiv` and `ToAllOnes.outputEquiv` preserve the two predicates through the supplied bijection. |
| Paper-facing outcomes | `FromAllOnes` and `ToAllOnes` existentially retain typed cascades and their restrictions. Both seed lemmas use nil. `fromAllOnes_iff_toAllOnes` reverses those witnesses. Each predicate's `isPerfectlyRepresentable` and `isSingular` gives its prior-free consequences. |
| Nil singularity | `Cascade.isSingular` retains a source-singularity premise and reuses the existing path theorem. Reachability supplies the seed premise; no blanket singularity assertion is made about arbitrary active states. |

The stronger prior-free easy implications immediately specialize to the paper's
singular-channel statement. There is no theorem constructing reachability from
perfectness. No plan change or additional abstraction was needed. The only
involution statement concerns the four operation **kinds**, not reverse proof data.

### Regression and validation scope

The separately imported [test module](../PerfectFunctionalRepresentations/Tests/Matrix/Reachability.lean)
owns R01-R04. Its private fixtures use unequal rational PP masses and deterministic
VP columns, with independent coordinate checks. R03 distinguishes a final output
permutation from its inverse on unequal or zero entries. R04 consumes C03's actual
nonrepresentable channel and explicitly rejects the forbidden operation kinds.
Focused/default build, exhaustive signature/axiom audit, source preservation and
independent review results will be recorded before the final source snapshot.

### Initial validation and review handoff

Fresh parent focused validation builds the production module, its external tests,
and the existing C07 Operations, C08 OperationPaths/OperationCalculus and C09
Preservation test consumers. The default project build also passes. The root
continues to exclude heavy matrix modules, so the focused results establish the
new module's compilation. R01-R04 compile with the actual public interface.

The parent inspected all 37 public signatures and audited all 83 module-owned
named constants, including generated/private constants, with `#print axioms`
and a checked allowed-axiom filter. Only `propext`, `Classical.choice` and
`Quot.sound` occur. The source-bound audit records exact source, compiled
artifact and driver hashes; anonymous examples are checked by test compilation.
Source-relative checks preserve the 131-entry B inventory outside owned edits,
all earlier Lean/closed plans, pins and tooling. The normative plan is byte-exact,
the placeholder scan has no matches, document links and whitespace checks pass,
all 71 omission IDs remain, and no generated/reference/private files are tracked.
Both manuscript identities were freshly checked against the approved plan.

These are incremental builds. Earlier failed elaboration attempts are retained:
explicit path recursion and restriction-lemma application fixed the production
errors; dependent finite-index presentation and exact rational calculations
fixed the fixture errors. The unsupported Lake `-j` attempt, the stopped silent
default-worker fixture attempt, and the parent console-encoding failure remain
negative observations. The latter occurred after a successful focused build
with six line-length warnings; the warnings were corrected and a fresh focused
build rerun. Exact commands, diagnostics and outcomes are retained privately.
Implementation-helper checks remain attributed assistance. Independent review
and original-report reconciliation still follow this checkpoint.

### Independent review and finalization

The existing bound reviewer independently satisfies C10-S01-A, C10-S01-B and
C10-S01-C with no findings. The complete original report is retained under
`d07f0fc1a0102f42c4203d09fb02f49adb5828c4901c9319975aaf7221d714f2`; its frozen R source is
`9823eb074415e515992cd611f17bea7bb824f932989c9ef88fc8c4219040925b`. Critical parent reconciliation is
`12178454c9377eb026be3d43cdc2953eb6ceb45007d36ee567647a4c10a62384`. The original empty native submission remains recorded as
uncertain; the full native report supplies separate supported delivery confirmation.
Revision 1's historical plan-report admission limitation remains unchanged.

The reviewer authenticated all 133 concrete inventory files and both manuscript
identities, read the relevant page-4 anchors, and checked reversal orientation,
restriction transfer, both folds, reachability consequences and R01-R04 against
actual source. Fresh focused/default builds passed (2778/2762 jobs). Its independent
probe checked all 37 public signatures/axioms and external consumers. The
placeholder scan passed. Its two scratch setup failures and the failed initial
PowerShell hash invocation remain negative evidence, separate from the corrected
successful checks. These are incremental checks;
the derived environment entry is not a separately reconstructed file hash.

The parent accepts the assessments on their stated evidence and limitations.
The stronger prior-free easy implications specialize to the printed singular
case; no converse construction is claimed. All four remembered recoveries and
the non-involutive comparison retain the required direction. No mathematical
correction, plan-contract change, deferral or new Future Work Note is needed.

After review, only owning Markdown documents change to record these results and
pre-F status. Exact historical project-log bytes are restored after an incidental
line-ending normalization; only entry 120 is added relative to B. A separate
implementation helper checked private finalization drivers. The parent added
exact final checked-file hash comparisons and disabled newline translation in
the saved diff. This is record-keeping assistance, not independent acceptance.

Final focused/downstream/default builds, manuscript/source/link/placeholder/artifact
checks and exact continued applicability of the 83-constant audit follow this
document checkpoint. All included files then stay fixed through F and closure.
The later durable execution record establishes S01 completion; this document does
not claim that future operation has already happened. S02-S07 remain unstarted.

## S02 - Exact finite partitions and supplied labels

**Status, 2026-09-28:** independent review and reconciliation complete; final validation/closure checkpoint. The repeated
conditional S02 request was accepted only after verifying successful S01 closure
`ffff8ca1d5d0164dbe3b2ed9f54eb9059f648143e62b60a895491e54765be025`,
its original independent report/reconciliation, three satisfied criteria and no
findings. All 134 entries of S01 F
`51a836475d9c3aaa30674e7b65f59978b5c0e6820de358eda5620a3da8aaf88e`
match current source. Earlier S01 pre-F prose remains historical.

S02 baseline B is `fefd8dc9a1258b8df492b6ccb50899b3f1670bab96f2d73d9dda3f996368ba3a`.
The same bound reviewer is retained. Private execution evidence is under
`.pfr-review/setup/c10-s02-20260928/`. Interrupted startup had made no maintained
edits or workflow selection; its read-only research was resumed. S02 is the only
selected step. S03-S07 remain unstarted.

### Source and interface boundary

Fresh parent page-4 ISIT and page-6 extended-v16 renderings/text confirm IV-A's
nonzero disjoint patterns covering the input set and partition-splitting prose.
Both exact manuscript hashes match the approved identities recorded above.
The C11 (23)-(24) decoder-fiber argument is a later consumer requirement, not an
S02 construction. C13 owns incidence, partition enumeration and Bell counts.

The interface reuses mathlib `Finpartition` directly. Its existing fields and
theorems supply nonempty parts, pairwise disjointness, exact coverage, unique
membership, finite block labels, singleton and empty-carrier behavior. A minimal
adapter retains each supplied label through a bijection to the resulting parts,
with an exact equation for the represented block. Finiteness of the label type
is internal; local classical decidability avoids a public `DecidableEq` premise.
No C06 import is needed in production: its already nonempty support finset can
be supplied directly. R05-R06 test that public boundary.

### Implemented API and consumer coverage

`Matrix.Partitions` imports only `Mathlib.Order.Partition.Finpartition` and adds
three public declarations in `PerfectFunctionalRepresentations`:

- `partitionOfBlocks` takes a finite label type, nonempty pairwise disjoint
  blocks and an exact carrier-membership equivalence, and returns `Finpartition s`;
- `partitionOfBlocksEquiv` returns `I ≃ P.parts` for that actual partition;
- `partitionOfBlocksEquiv_apply_val` identifies every image with the originally
  supplied finset and is a simp theorem.

The private injectivity proof uses nonemptiness and disjointness. The construction
uses `Finpartition.ofExistsUnique`; no parallel partition structure, enumeration
interface or aliases for the existing invariant are introduced. `Finite I` is the
only typeclass premise. Internal enumeration and classical decidability do not
require finite input alphabets, supplied enumerations or public decidable equality.

R05 uses the proper carrier `{0,1,2,3,4,5}` inside `Fin 7`, with labels 0, 1, 2
assigned respectively to `{3,4,5}`, `{0}`, `{1,2}`. Assertions cover exact sets,
sizes, disjointness, unique membership, coverage and exclusion of the seventh
input. Four malformed families isolate overlap, missing coverage, empty blocks
and extraneous coverage. R06 checks the bijection, its inverse, each supplied
block, finite/nonempty parts, singleton and empty label/carrier cases, and generic
consumers with no decidability premise. A test-only C06 `columnPattern` consumer
uses its nonempty support and exact membership theorem.

For C11, a supplied finite family of nonempty decoder fibers can retain its
original labels through `partitionOfBlocksEquiv`, then compose with S04's planned
output equivalence. C11 still proves the fiber hypotheses and handles inactive
outputs. C13 can use `Finpartition` directly for its separate enumeration and
incidence work. `equivSigmaParts` remains the distinct equivalence from carrier
elements to elements within blocks. No downstream claim depends on an arbitrary
ordering of the resulting finset of blocks.

OM-017 retains Bell enumeration/growth outside S02; OM-052 assigns actual finite
binary synthesis to S03-S05 and the C11 application; OM-068 retains C06's nonempty
support-finset representation. No new omission, deferral or Future Work Note is
needed. The foundational reuse search found the needed APIs in pinned mathlib;
the searched pinned LeanInfoTheory public API/docs exposed no competing partition
construction. This introduced no information-theory theorem or discoverability
friction. S01 and all inherited mathematics remain unchanged.

### Initial validation and self-review checkpoint

Fresh parent focused builds pass for `Matrix.Partitions`, its external regressions,
S01 Reachability tests and the C06 SingularColumns tests. The default build also
passes; the lightweight root remains unchanged and excludes matrix modules.
All three public declarations and all 9 module-owned named constants
were audited with printed signatures/axioms and a checked foundational-axiom
allowlist. Source, compiled artifacts and audit-driver hashes bind those results.
Only the standard `propext`, `Classical.choice` and `Quot.sound` axioms occur.

The source checks preserve the 134-entry B inventory outside owned edits, the
normative approved contract, all earlier Lean, dependency pins and workflow tools.
The placeholder scan, link/whitespace/artifact checks and all 71 omission IDs pass.
Historical project-log bytes remain exact. Both manuscript hashes were freshly
rechecked. These are incremental builds, and helper checks are attributed
implementation assistance. Original failed fixture attempts are retained in
`tmp/c10-s02-tests/` and as separate private negative evidence; corrected tests
and current parent validation provide passing evidence. Exact source snapshots
were not retained for the first two failed fixture attempts; their diagnostic
logs remain available. Later attempt sources were preserved before rerunning.

The adapter deliberately uses internal classical decidability. Consumers of its
`Finpartition` value use the same local classical instance when selecting the
underlying finset lattice; no decidability parameter leaks into theorem signatures.
Generic consumers can use `attribute [local instance] Classical.propDecidable`;
concrete types with an existing decidable equality may need an explicit local
classical `DecidableEq` instance before partition-typed declarations. The external
regressions check both usages. Independent review and
critical reconciliation remain separate obligations.

### Independent review and finalization boundary

The retained reviewer `/root/pfr_c10_reviewer` returned the complete original
S02 report for R `913e126b50de36de2da2c09d6d093481f2546fb05e98ac6ed60ac6943de29647`. Supported report admission is valid; the original
report and every positive/negative observation remain unchanged. All three
criteria are satisfied, with no findings. Parent reconciliation separately
assesses each criterion and the report's precise verification limits; the
complete original is not replaced by this summary. Its durable report reference
is `81d666abc35c9929ff6c3c3bec980dd8088099525ac59e5d0c5fcf6503dd5580`; reconciliation is `dc5f2ec5782936f6196bcf82f1fdcd7ce4b2fc1b523ab1c02e4043960c419221`.

The report supports the existing Finpartition invariant, exact original-label
bijection, empty/singleton/nonempty boundaries and the generic no-decidability
signature. R05-R06 inspect both omitted and extraneous elements, original labels
and a C06 active pattern. All 135 ordinary inventory hashes matched before and
after independent review. Its focused/default builds and three-declaration probe
passed; the latter emitted one harmless scratch-only unnecessarySimpa warning.
There were no failed reviewer Lean/build attempts. Its derived environment entry
was not independently reconstructed, and builds were incremental.
The parent retains the nine-constant exhaustive audit
separately from the reviewer's checks. Original fixture and helper-probe failures
remain negative observations with their stated source-snapshot limits. The first
parent build's line-length warning was fixed and fresh initial2 checks passed.

A separate implementation helper checked the private validation drivers. The
parent added exact checks of every validated owned-file hash before recording
initial evidence, so a post-build test edit cannot inherit a passing claim.
This was record-keeping assistance, not independent mathematical acceptance.

No mathematical correction, normative plan change or new deferral is needed.
After R, only owning Markdown documents change to record review/reconciliation
and this pre-F checkpoint. Historical log bytes remain exact. Final focused and
default builds, source/manuscript/link/placeholder/artifact checks and exact
continued applicability of the production audit follow these final documents.
Included files then stay fixed through F and supported durable closure. That
later private record establishes S02 completion. S03-S07 remain unstarted.

## S03 - Finite PPS weight synthesis

**Status, 2026-09-28:** independent review and reconciliation complete; final validation/closure checkpoint. The new conditional
S03 request was accepted after verifying S02 successful durable closure
`0933ea859f14aa7e96288659b60904dd5b0f6d1bc6449d522f3e645e70c5f4d0`,
its original report/reconciliation, all three satisfied criteria and no findings.
All 136 entries of S02 F
`7ec9678099b3e8899633bbb631211748f6dafb96967f75a3b82eda7965f064b1`
match current source. Earlier pre-F prose remains historical.

S03 B is `ce50a54780f49073e8b296f3c649a3307d5e3c3959e6376fe21f8a51d06694a3`.
The same bound reviewer and approved normative revision-2 contract remain.
Private evidence is under `.pfr-review/setup/c10-s03-20260928/`.
Only the PPS portion of `Matrix.MultiwayOperations` and its consumers is active.
S04-S07 remain unstarted. Actual paths, exact labels, strict ratios, positive
support and ENNReal conversion remain required; no ambient zero column may enter
an active endpoint. C11 chooses its own canonical weights later, and C12 retains
the broader Real optimization conversion contract.

### Implemented construction and public boundary

`Matrix.MultiwayOperations` introduces `LabelledOperationResult`: one actual
homogeneous path, its active endpoint, a total supplied-label equivalence and
the exact coordinates of that same endpoint. The package has concrete selected
and per-column consumers. Its `isSingular`, `outputCard`, `outputEquiv` and
`cascade` accessors preserve the same witness; target comparisons point from the
constructed endpoint to an independently supplied labelled target.

`multiPps` accepts positive normalized NNReal weights on arbitrary finite labels.
Private `Fintype.induction_empty_option` proves nonemptiness of the complete
witness package before `Classical.choice` extracts it. In a genuine split, the
first weight is strictly between zero and one because the remaining positive
sum is nonzero. Remaining weights are divided by that residual; exact NNReal
coercion and cancellation recover the original ENNReal coordinates. The recursive
invariant carries `Unit ⊕ R` source labels and `I ⊕ R` target labels, retaining
all unaffected coordinates. Singleton input produces a nil path. Public
cardinality and length specifications prove that the chosen witness has
`card I - 1` PPS edges, hence length zero for a singleton. This count follows
from the cardinality change of each primitive PPS; it is not a runtime bound
or a shortest-path claim for unrestricted operations.

Child admitted values are multiplied by their weights, child patterns remain
the selected support, and unaffected admitted values/patterns remain exact.
These specifications consume C06's activity and admitted-data API. Activity is
part of every returned state; singularity follows along the retained path.

`multiPpsFamily` traverses every original source label and retains earlier
children inside the unchanged-label component while later splits insert columns.
The private finite induction follows the same-project C08 labelled traversal
precedent, adapted locally to the complete result package. It does not import
or promote C08's heavy factorization machinery. `ULift` aligns source-index and
arbitrary child-label universes inside the traversal; the public endpoint labels
are exactly `Σ j, I j`, with mass `(weights j i : ENNReal) * S.channel x j`.

`multiPpsOfNonnegative` and `multiPpsFamilyOfNonnegative` restrict each supplied
NNReal family to `{i // 0 < weights i}`. Public positive-weight facts establish
nonemptiness, unchanged total, zero mass outside the inclusion range and exact
ambient PMF coordinates under inclusion. The latter directly uses supported
LeanInfoTheory `PMF.map_apply_of_injective` and
`PMF.map_apply_eq_zero_of_notMem_range`; no parallel PMF construction is added.
`multiPpsOfENNReal` and `multiPpsFamilyOfENNReal` derive finite summands from
normalization, use pinned `ENNReal.toNNReal_sum` and `coe_toNNReal`, and restore
the original positive-label subtypes through an explicit equivalence. Their
public coordinates retain the original ENNReal masses without a finiteness
premise. Unused intermediate conversion aliases were removed.

### Source, reuse and scope dispositions

The inspected ISIT IV-A page 4 instruction 1 and extended-v16 page 6 instruction 1
specify the weighted all-ones family; extended page 4 after (24) gives the later
canonical-weight application. Text and page renders were inspected, and fresh
binary hashes match the approved manuscript identities. The current constructor
accepts supplied weights and does not make C11's canonical choice. The printed
multiway shorthand is realized as legal binary edges with exact endpoints.

Pinned mathlib supplies finite Option induction, dependent equivalences,
positive-support finite sums and exact ENNReal/NNReal conversion. C07 supplies
primitive strict PPS and coordinates; C08 supplies paths, singularity transport
and directed output comparison. No new information-theory theorem or generic
PMF implementation was needed, so no discoverability entry was warranted.
OM-045's zero-operation-weight bridge and OM-052's PPS synthesis obligation are
implemented here. VPS/PPM synthesis remains S04/S05, nonempty canonical decoder
fibers remain C11, and broader Real optimization conversion remains C12.
The earlier advice on witness extraction, exact labels and early external
family consumers is applied. The all-columns PPM advice remains assigned to
S05 R14/R15. There is no new numbered Future Work Note or normative plan change.

### Initial validation and self-review checkpoint

Fresh parent focused builds pass for `Matrix.MultiwayOperations`, its external
R07-R09 regressions, S01 Reachability tests and C06 SingularColumns tests.
The default build passes separately; it does not import the new matrix module.
All 109 module-owned named constants, including private and generated
declarations, pass an exhaustive printed-signature/axiom audit with only
`propext`, `Classical.choice` and `Quot.sound`. Source, compiled artifacts and
audit-driver hashes bind this evidence. Anonymous regression examples are
checked by compilation. Builds are incremental.

The early external family consumer was compiled before the larger fixtures:
two source columns receive two and three children, and every resulting sigma
label is compared with a separately defined five-column PMF. R07 then checks
the prescribed `1/6,1/3,1/2` selected family, unaffected mass, null selected rows,
cardinality, actual path length, singularity and admitted data. R08 checks
singleton weight one, interspersed zero weights and positive support, exact
NNReal/ENNReal constructors, inclusion and impossible empty/all-zero normalized
families. It also maps the actual synthesized endpoint back to every original
ambient label, checking zero mass at discarded labels and unchanged complementary
coordinates through the public PMF map laws. R09 checks dependent families, directed output transport, alternative
enumeration and synthesis on a nontrivially permuted input with distinguishable
rows. S01 consumers use the actual synthesized paths for reachability and the
easy perfectness implication. The public endpoint accessors, not private
induction details, support these checks.

Source checks preserve the normative revision-2 plan and every unowned B entry,
including prior Lean, dependency pins, root and workflow tools. The placeholder,
link, whitespace, generated-artifact and manuscript-hash checks pass; all 71
omission IDs and historical project-log bytes are retained. Original failed
implementation/probe attempts remain separate negative evidence. Passing helper
probes are implementation assistance, not independent review. The first external
family check that overlapped a production rebuild failed because its `.olean`
was temporarily unavailable; a later check on the built module passed. Bound
independent review and critical reconciliation remain separate obligations.

### Independent review and finalization boundary

The retained reviewer `/root/pfr_c10_reviewer` returned the complete original
S03 report for R `bc89e9bbc2d5f9dc7b23c710b6672724a35371b6ea933e60d01b658b5be84932`. Supported admission is valid; every original
assessment and positive/negative observation is retained. All three independent
criteria are satisfied with no findings. Parent reconciliation separately
evaluates the mathematical and validation evidence. The durable report reference
is `d550eaa0d2f46596d0840e5fd162ad05501806d7624393bd4feca6d05ff18a9d`; reconciliation is `fa841207455c85b58261d1bf248593a73915720561a12f44856fc0e69e419321`.

The review independently inspected the complete production and regression modules,
the precise manuscript anchors and pinned APIs. Fresh focused and default builds
passed, as did a public consumer/signature/axiom probe covering all 22 explicit
public declarations and nine generated result constants. Its generic ENNReal
family consumer uses the original positive labels without a decidability premise
on inputs. The parent separately audited all 109 owned named constants; both
audits found only `propext`, `Classical.choice` and `Quot.sound`.

Two reviewer failures are preserved separately: an initial ENNReal singleton
scratch proof needed `dsimp only [multiPpsOfENNReal]`, and a literal Windows
wildcard source-search path was invalid. The corrected external proof and search
succeeded. No maintained source correction was needed. Parent reconciliation
checked the actual path/label package, residual normalization, support inclusion,
exact conversions, target orientation, family invariants and distinct input/output
transport consumers; it found no unresolved acceptance concern or new deferral.

These builds were incremental. The reviewer checked all 137 ordinary source
inventory entries but did not reconstruct the derived environment digest. Its
public API audit does not cover every dependency declaration; the parent's broader
module audit remains a separate observation. Final parent checks still follow
this checkpoint. Original reports, failed attempts and evidence limits remain in
the private durable records.


Only owning Markdown status/evidence records change after R. The reviewed Lean
and tests, normative plan, earlier mathematics, root, dependencies and workflow
tools remain fixed. Historical project-log bytes are preserved. Final focused
and default builds, source/manuscript/link/placeholder/artifact checks and exact
continued applicability of the production audit follow these documents.
Included files then remain fixed through F and supported durable closure. That
later record establishes S03 completion. S04-S07 remain unstarted.

## S04 - Finite VPS partition synthesis

**Status, 2026-09-28:** independent review and reconciliation complete; final validation/closure checkpoint. The conditional
S04 request was accepted after verifying S03 successful durable closure
`e0685da5a254d8622d17525ada4ec680e9facdd891152cd40b1a54c1da49b22c`,
its original report/reconciliation, all three satisfied criteria and no findings.
All 138 entries of S03 F
`f491820d12f1f74fc20629abd4afc95ec22183584b60c7d1c28ef3739f7f282e`
match current source. Earlier pre-F prose remains historical.

S04 B is `1c8ce86ce8c959937a0e0a964f13bb7ffedaf80a48011c4c5a42ece594b9c983`.
The approved normative revision-2 contract and same bound reviewer remain.
Private evidence is under `.pfr-review/setup/c10-s04-20260928/`.
Only the VPS portion of `Matrix.MultiwayOperations` and its consumers is active.
S05-S07 remain unstarted. Supplied exact partitions determine all nonempty child
patterns; values are retained, including one. Singleton partitions use no split.
C11 constructs its own decoder fibers; C13 retains partition enumeration.

### Construction and public boundary

`multiVps` accepts a `Finpartition` of the actual selected `columnPattern`.
It returns the existing `LabelledOperationResult`: one concrete active endpoint,
its actual VPS-only path, a total equivalence from `P.parts` plus the unaffected
source labels, and every exact row coordinate. A child has mass
`if x ∈ block then S.channel x l else 0`; a complementary label retains its
original mass. The new public `multiVpsFamily` accepts one such partition for
each source output and exposes exactly `Σ j, (P j).parts` with the corresponding
coordinates. Both constructors use `[Fintype alpha]` at this finite-pattern
boundary, with classical decidability internal and no public `DecidableEq`
premise. They accept already supplied partitions; neither enumerates partitions
nor extracts decoder fibers.

The private selected induction accepts finite indexed blocks and a
`Unit ⊕ R` source-label equivalence. Its exact nonzero-support/coverage iff,
nonempty blocks and pairwise disjointness persist throughout. In the genuine
Option case, membership in the first block defines the Boolean mask; witnesses
from that block and a remaining block prove both primitive pieces nonempty
inside the current support. On the right child, the remaining original block
finsets still give exact coverage. The left child moves into the retained
complement, so later splits preserve it along with the original unaffected
columns. The empty case contradicts source activity; the singleton case uses
`OperationPath.nil`. A Prop-valued `Nonempty` proof carries the full result,
then choice selects that same package with its specifications attached.

Keeping indexed blocks inside the induction avoids repeated dependent casts of
a residual `Finpartition`. The public boundary still uses the approved mathlib
invariant. This is the planned representation choice, not a changed hypothesis.
The wrapper uses `nonempty_of_mem_parts`, `disjoint`, `exists_mem` and `subset`.
S02's supplied-label equivalence composes directly with the returned part labels.

The per-column construction reuses S03's private `mwSplitFamily` unchanged, now
with a VPS callback. Exact current-root coordinates transfer the original
partition's coverage to each intermediate selected column. Its complement
retains completed children through subsequent splits. No C08 normalization helper
is imported or promoted; the new production import is `Matrix.Partitions`.
No new generic probability or information-theory theorem was needed.

### Specifications and edge cases

The selected endpoint has `S.outputCard - 1 + P.parts.card` outputs. Its actual
homogeneous VPS path has `P.parts.card - 1` operations, hence zero for a singleton.
These counts follow from the total label equivalence and the primitive cardinality
increment. Every child's pattern is exactly its supplied block and its admitted
value is the original selected value. Unaffected values and patterns are also
equal to their original data. No strict upper bound on the selected value is
introduced; value one uses the same construction. Activity is intrinsic to the
endpoint, and singularity follows along its stored path from source singularity.

The common `outputEquiv` and `cascade` accessors compare that same endpoint with
any independently supplied target having the same labelled coordinates. Their
direction remains constructed endpoint to target. Exact family coordinates and
C06 admitted-data facts provide family value/pattern consumers without another
public alias layer. The tests compose S02's original-label-to-part equivalence
with the VPS labels, so original supplied block names remain usable.

### Manuscripts, reuse and mapped obligations

Both source PDFs were freshly authenticated with unchanged hashes and page
counts. The rendered ISIT IV-A page 4 instruction 2, extended v16 page 6
instruction 2 and page 4 prose after (24) were inspected. Their multiway VPS
shorthand is realized by finite binary paths on the supplied partition.
The extended version retains its approved 2026-09-03 designation; C11 owns the
canonical decoder-fiber partition preceding this construction. Exact identities
and current observations are retained under `tmp/c10-s04-manuscripts/` and the
private step records; no manuscript content is a maintained artifact.

Pinned mathlib's finite Option induction has a Prop motive, and its partition
facts provide exactly the nonempty/disjoint/coverage contract. C07 supplies the
inclusive-value VPS primitive, legal support witnesses, coordinates and mask
irrelevance; C08 supplies actual path composition/transport. C06 supplies the
admitted pattern/value interface. Existing dependency pins and earlier modules
remain unchanged. Targeted compiling probes establish the exact reused APIs.

OM-038 now records the finite constructor's nonempty-piece handling, OM-049
retains the inclusive value-one domain and unselected strict-domain simulation,
and OM-052 records generic VPS realization plus private traversal reuse.
No new omission or numbered Future Work Note is needed. S05 retains PPM
synthesis, C11 canonical fibers, and C13 enumeration/incidence.

### Initial validation and self-review checkpoint

Fresh parent focused builds pass for `Matrix.MultiwayOperations`, its R10-R12
and earlier regressions, S01 Reachability, S02 Partitions, C06 SingularColumns,
C07 Operations, C08 OperationPaths/OperationCalculus and C09 Preservation tests.
The default build passes separately; it does not import the synthesis module.
All 137 module-owned named constants, including private and generated
declarations, pass an exhaustive printed-signature/axiom audit with only
`propext`, `Classical.choice` and `Quot.sound`. Source, compiled artifacts and
audit-driver hashes bind this evidence; final applicability is rechecked.
Anonymous regression examples are checked by compilation. Builds are incremental.

The small external two-plus-one-part family consumer was checked against an
independent three-column target before larger fixture expansion. R10 uses a
selected final source label, noncontiguous blocks of sizes three, one and two,
a proper input support, and exact child/unaffected coordinates. R11 checks
singleton path length zero, admitted value one, null selected rows, masks that
differ only off support, and an invalid empty selected-support piece. R12 uses
mixed per-column part counts, all sigma labels and an independent six-column
target; actual C08 transport uses a non-involutive source-output permutation with
distinguishing coordinates. The all-ones VPS consumer has no complementary
source label and supplies an actual S01 reachability/perfectness certificate.
Generic family value/pattern and target consumers use only the public API.

Source checks preserve the normative revision-2 plan and every unowned B entry,
including prior Lean, dependency pins, root and workflow tools. Placeholder,
link, whitespace, generated-artifact and manuscript-hash checks pass; all 71
omission IDs and historical project-log bytes are retained. The S03 regression
file remains an exact prefix of the extended tests. Original failed probes and
their corrections are separate observations in private records. Helper checks
are implementation assistance; independent review and reconciliation remain
separate obligations.

### Independent review and finalization boundary

The retained reviewer `/root/pfr_c10_reviewer` returned the complete original
S04 report for R `145e225cea9b3a4e5a5989ebb29fefb238a20465173cb804b8427bdd3b0f44b5`. Supported admission is valid; every original
assessment and positive/negative observation is retained. All three independent
criteria are satisfied with no findings. Parent reconciliation separately
evaluates the mathematical and validation evidence. The durable report reference
is `a6a2c983e5efd9f6b259d4224cee392d329b129662efb42a30af914f46a25235`; reconciliation is `1c310f5949d8eef5ec6def770a7e3c25fb22589fa651161d7e8d78e7da2f4c52`.

The reviewer freshly authenticated the request, all 137 ordinary inventory
entries and the exact manuscript anchors. It inspected the complete VPS
induction, family composition, selected specifications and new regressions.
Its focused build passed with 2784 jobs, and its default build passed with
2762 jobs. The corrected standalone probe passed: forty public signatures and
axiom reports, six pinned APIs, and four generic consumers of original block
labels, family target cascades, singleton path length and family cardinality.
Only the accepted foundational axioms were reported. Parent inspection of that
probe and log confirmed its contents and absence of diagnostics.

Parent reconciliation accepts each original criterion on its mathematical
evidence: support-relative legality and retained coordinates; original sigma
labels and singleton/null-mask/value-one boundaries; and complete R10-R12/S01
consumers with API, import and documentation checks. The independent audit and
parent's exhaustive 137-constant audit retain their separate coverage. No
production correction, extra public abstraction or new deferral is warranted.

The complete report retains fifteen evidence entries, including three FAIL
observations: a premature missing-log lookup and two unsuccessful proofs in the
reviewer's own labelled-block consumer. They remain separate from the corrected
passing probe and are not acceptance evidence. Builds are incremental; source
hashing does not establish semantic review of every file. The reviewer did not
reconstruct the virtual environment digest or independently authenticate early
implementation chronology. Parent source checks and the retained early-consumer
sequence cover those boundaries. Runtime delays are not evidence about
mathematical correctness. Final validation and durable closure remain subsequent acts.


Only owning Markdown status/evidence records change after R. The reviewed Lean
and tests, normative plan, earlier mathematics, root, dependencies and workflow
tools remain fixed. Historical project-log bytes are preserved. Final focused
and default builds, source/manuscript/link/placeholder/artifact checks and exact
continued applicability of the production audit follow these documents.
Included files then remain fixed through F and supported durable closure. That
later record establishes S04 completion. S05-S07 remain unstarted.

## S05 - Finite equal-pattern PPM synthesis

**Status, 2026-09-29:** independent review and reconciliation complete; final validation/closure checkpoint. The fresh request
was accepted after verifying S04 successful durable closure
`1b1e542451c260299d54e3ba8fa63b2b1e12ad1f90ffedd787ed5002395774d8`,
its original report/reconciliation, all three satisfied criteria and no findings.
All 138 entries of S04 F
`b4e052675be3c10d0a1960dd371e077bb1e14c60c437118c2f7e69caa5991541`
match current source. Earlier pre-F prose remains historical.

S05 B is `ae49cfd7ac80318d1610131b0a8c5e5740bd800bc04be43dfb7c77d15fb6e0e4`.
Private evidence is under `.pfr-review/setup/c10-s05-20260929/`.
The earlier S05 startup reused S04's authorization ID and was consumed as skipped
before any maintained edit or review. Its interrupted scratch probes are not
validation evidence. The later conditional S06/S07 requests were ineligible;
none of these requests is rearmed. The fresh S05 request uses a distinct recorded
identity and retains the same approved contract and bound reviewer.

This step realizes supplied equal-support selections and prescribed surjective
fibers with actual binary PPM paths, complete labels, exact sums and unchanged
complements. Empty selection creates no column; singleton selection needs no
merge. Range restriction excludes unused ambient labels. Global equal-pattern
compression and Real optimization data remain C12; S06-S07 remain unstarted.

### Construction and public boundary

`multiPpm` consumes a supplied nonempty finite selection and equality of supports
inside it. Its returned `LabelledOperationResult` retains the actual PPM path,
homogeneous tag proof, the total `Unit + complement` label bijection and every
coordinate. `multiPpmOrEmpty` is the total entry point: its empty branch has
endpoint `S`, identity labels on all original outputs and a nil path. It does not
create a merged empty column. The selected specifications give cardinality
`S.outputCard - F.card + 1`, actual path length `F.card - 1`, zero singleton length,
exact admitted-value sum/common pattern and unchanged complementary data.

The private core inducts over a nonempty finite selected type. It first aggregates
the tail while retaining the head and all complementary labels, then performs one
legal binary PPM. A retained-subtype equivalence accounts for deleting the higher
numeric index; swapping the two selected roots handles either numeric order while
preserving C07's lower-survivor convention. Equal supports ensure a nonempty sum
has that same support. No C08 private construction is promoted or imported.

`multiPpmFibers` accepts a supplied surjection and equal support only within each
fiber. A private finite traversal threads completed aggregates through subsequent
merges. Explicit sigma labels and a universe lift preserve original source indices;
the final labels are exactly the supplied codomain. Different fibers may have the
same pattern. Coordinates are the sum of precisely the source entries in each
fiber. Public admitted-value/pattern and chosen path-length specifications refer
to the same returned result; its common `outputCard` accessor gives target cardinality.

`multiPpmRange` restricts any supplied map to its actual finite range. It needs no
finiteness instance on the ambient label type: the pinned range instance derives
finiteness from the source. `multiPpmRange_map` includes actual generated outputs
through inverse labels followed by subtype inclusion and proves the full ambient
fiber sum, including zero at unused labels. This adopts the helper's optional
assumption simplification; no separate deferral remains.

The constructors need only finite nonempty input. `Fintype alpha` is required
only by pattern accessors. Production imports are unchanged; the mathematical
root remains lightweight. Existing C07/C08 binary operations/path APIs and pinned
finite induction, equivalence and sum APIs supply the proof. C12 still chooses
all equal-pattern equivalence classes and establishes global distinctness and
Real optimization data; C11 still chooses canonical decoder fibers.

### Early public consumer

The first integrated family constructor compiled on 2026-09-29 before larger
fixtures were expanded. Its preserved production SHA-256 is
`0c69908908193b2f0f1039699b6280879dd65982f01af828b58de6dca659573f`.
The successful external `Early-03.lean` consumer has SHA-256
`aca3040b6d8b270d375e830c59e980f43697f528235498f5f3fb7a4638491348`;
it completed at 2026-09-28 22:30:06 UTC (2026-09-29 locally), exit zero without
diagnostics. The source has constant-row weights `1/6, 1/3, 1/2`, grouping
`[1,0,1]`, and an independently supplied target with weights `1/3, 2/3`.
It consumes the actual witness, homogeneous tags, labels, cardinality, coordinates,
activity/singularity, directed comparison and cascade. The two target fibers
share the same pattern. Hash/timing metadata and the first production snapshot
are retained privately; the parent inspected them before authorizing larger
fixture expansion. Earlier failed arithmetic and concrete-decidability-instance
consumer attempts remain negative observations, not passing evidence.

The S05 anchors remain ISIT p.4 IV opening and IV-A instruction3, supplemented by
designated extended v16 p.6 instruction3. The same authenticated manuscript pages
were visually read during the preserved preliminary S05 work; current hashes are
rechecked during source validation. Finite prescribed merging realizes this part
of the paper's shorthand without claiming C12's global compression theorem.

### Regression and initial validation crosswalk

R13 selects nonadjacent columns 0, 2 and 4 from a five-column source. Their
admitted values `1/12`, `1/4` and `1/3` sum to `2/3`; every coordinate is compared
with an independently supplied three-column target. The common pattern is
`{false}`, the null row stays zero, and both complementary columns retain their
values, patterns and coordinates. Cardinality, actual path length, activity and
singularity are explicit consumers of the public result.

R14 checks the actual singleton witness has zero merges. The total empty wrapper
retains the original endpoint, identity labels and a zero-length path. A local
equality-elimination proof removes the wrapper's dependent casts; no generated
auxiliary declaration or extra public helper is used. On the constant-row
`1/6, 1/3, 1/2` fixture, selecting all columns leaves an empty complement, one
output and two merges. Its exact comparison with `allOnes` supplies S01's two
reachability directions and prior-free perfectness. The same source is also
processed by the prescribed single-fiber interface. The non-surjective ambient
map `[3,1,3]` gives actual endpoint inclusion weights `[0,1/3,0,2/3]`, with both
unused labels zero. A generic ambient-label consumer has no finiteness or
decidable-equality premise.

R15 uses prescribed grouping `[1,0,1,2,1]`, retaining two different fibers with
the same pattern. Independent row data verify every aggregate coordinate and
admitted value; cardinality, common patterns and chosen path length are checked.
Actual C08 transport uses a five-cycle whose forward/inverse images have different
coordinates, then composes the directed endpoint comparison. The earlier small
family consumer and these public accessors cover the applicable R18 obligation;
cross-family integration remains S06.

Fresh parent focused builds pass for `Matrix.MultiwayOperations`, its complete
regression module, S01 Reachability, C06 SingularColumns, S02 Partitions, C07
Operations, C08 OperationPaths/OperationCalculus and C09 Preservation tests.
Default `lake build` passes separately; it does not replace focused synthesis
validation. All 219 module-owned named constants, including generated and
private declarations, pass the exhaustive signature/axiom audit with only
`propext`, `Classical.choice` and `Quot.sound`. Source, compiled artifacts and
driver hashes preserve its exact applicability. Anonymous examples are checked
by compilation. Builds are incremental.

Source checks preserve all unowned B entries, the entire S04 production namespace
body and the byte-identical 1,422-line test prefix, immutable pins, lightweight
root, workflow tools, normative plan and historical project-log bytes. Placeholder,
link, whitespace, generated-artifact and manuscript-hash checks pass; all 71
omission identifiers remain. Superseded failures and interrupted attempts are
retained separately with their source and diagnostic limits. Helper checks are
implementation assistance; contextual self-review, independent review and final
closure remain separate obligations.

### Independent review and finalization boundary

The retained reviewer `/root/pfr_c10_reviewer` returned the complete original
S05 report for R `ffa9d6cd92cc5318bf13d056b21d19c19a74b35468f4231ce4abed2cf0cc79eb`. Supported admission is valid; all three independent
criteria are satisfied with no findings. The original report and its positive
and negative observations are preserved. Parent reconciliation separately
evaluates their mathematical meaning and limits. The durable report reference
is `3f70dbb97976f3e6c0501e36fc9d1fbd0d6b8e7d00af53c31d22a125581c4228`; reconciliation is `b0931639ba19b20098c754a4aae91a84b73eec1e42f3d510515b3a517d047880`.

The reviewer freshly authenticated all 137 ordinary source entries and the exact
ISIT/extended manuscript anchors. It inspected the selected induction, prescribed
fiber traversal, range inclusion, admitted-data laws and all new regressions.
Its focused build passed with 2783 jobs and its default build with 2762 jobs.
The initial independent probe passed: 55 public/generated signatures and axiom
reports, six pinned API checks, and four generic consumers of target cascades,
fiber cardinality, all-columns cardinality and off-range zero mass. Only the
accepted foundational axioms occurred. Parent inspection of its source/logs
confirmed these checks.

Parent reconciliation accepts each original criterion on that evidence: legal
binary merges with complete retained labels and exact data; explicit empty,
singleton, all-columns, range and transport boundaries; and complete regressions,
API/import checks and documented C12 ownership. The reviewer's public audit and
the parent's exhaustive 219-constant audit retain their separate coverage.
No mathematical correction, new public helper or new deferral is warranted.

All twelve reviewer evidence entries report PASS. The initial unsuccessful
mathlib-only symbol search and subsequent reuse of the pinned LeanInfoTheory
PMF map laws are retained as discovery history. All reviewer S05 Lean/build
invocations passed; earlier and parent/helper failures remain separately preserved.
Builds are incremental. Hashing does not establish semantic review of every file.
The reviewer did not independently reconstruct the virtual environment digest or
authenticate early implementation chronology; parent source checks and the actual
early-consumer checkpoint cover those boundaries. Native provenance and effective
model settings retain the installed workflow's stated limits. Final validation
and durable closure remain subsequent acts.


Only owning Markdown status and evidence records change after R. The reviewed
production/tests, normative plan, earlier mathematics, lightweight root, pins
and workflow tools remain fixed. Historical project-log bytes are preserved.
Final focused/default builds, source/manuscript/link/placeholder/artifact checks
and exact continued applicability of the exhaustive 219-constant audit follow
these documents. Included files then remain fixed through F and supported durable
closure. That later record establishes S05 completion. S06-S07 remain unstarted.


## S06 - Example 6 and integrated readiness

**Status, 2026-09-29:** independent review and reconciliation complete; final validation/closure checkpoint.

S05 durably closed under
`041c9df58cd94d5009b731e4b944344f027d25216f7c091d5596eb3727c4d0c7`.
Before accepting the fresh conditional S06 request, startup verified that closure,
all original S01-S05 reports/reconciliations, fifteen satisfied criteria and all
138 final source/environment entries. The earlier skipped requests stay historical.
S06 B is `104c692af00b70f34cf34806dfe020ed7867c899f7f785f9c9926fcb91a63e50`.
No S07 or later mathematics is authorized by this request.

The [readiness audit](pfr-c10-readiness-audit.md) owns the cumulative regression,
criterion, API, manuscript, trust and advice crosswalk. This section records
implementation and review evidence, including the subsequent finalization boundary.

### Example 6 and integrated public consumers

`Examples.Reachability` uses independent NNReal tables for (25), (28), the
actual and printed (30), (31) and (32), and checks the valued-column presentations
in (26)/(27)/(29). The actual reduction uses zero-based pairs (1,2), (1,3),
(0,2), (0,1), with tags VPM/PPM/VPM/PPM. Equal admitted values and disjoint
supports justify both VPMs; equal supports justify both PPMs. All survivor and
retained coordinates are checked using the public C07 coordinate laws.

After the second operation the lower-survivor order is `[A/3, 2U/3, B/3]`.
The independently supplied printed state is `[A/3, B/3, 2U/3]`.
`OutputEquiv` records the swap of outputs 1 and 2 and its directed PMF equation.
The exact-order path continues with (0,2). The final endpoint is explicitly
compared with all-ones. Reversing that actual cascade gives chronological tags
PPS/VPS/PPS/VPS and four operations. Its easy-direction consumer proves intrinsic
perfectness with no input law. These fixtures remain private; no public theorem
per display or change to the primitive survivor convention is introduced.

`Tests.Matrix.Synthesis` supplies a compact 1-to-2-to-4-to-3 construction. PPS
uses the ENNReal family `[1/3, 0, 2/3]`, preserving original positive labels 0
and 2. For both resulting columns the caller's Bool labels mean false = `{1}`
and true = `{0,2}`. `partitionOfBlocksEquiv` and its block equation compose
with the actual family-VPS endpoint labels. A separate four-column matrix checks
all entries. Prescribed PPM grouping `[0,1,2,1]` merges the two nonadjacent
`{0,2}` leaves while retaining two different fibers with pattern `{1}`.
The final comparison uses the genuine cycle `[1,2,0]`; a concrete coordinate
distinguishes its forward and inverse images. Independent target rows are
`[0,0,1]`, `[1/3,2/3,0]`, `[0,0,1]`.

The actual paths have lengths 1, 2 and 1; their composed chronological tags are
PPS/VPS/VPS/PPM. A private test-only cardinal-growth induction over public
split constructors proves the family VPS count. Existing public interfaces
suffice, so no production helper is added. The composed cascade supplies both
reachability directions and easy perfectness. Public `Cascade.normalize` then
returns an actual C08 normal form: tests consume each homogeneous stage,
intermediate singularity, final cardinality, directed PMF equation and every
coordinate against the independent final matrix.

Generic consumers additionally accept arbitrary ENNReal families and independently
supplied targets, and compose supplied dependent block labels through family VPS
into prescribed PPM. The latter grouping is defined on the caller's original
labels and transferred to the actual numeric endpoint by the label equivalence.
Its proof retains exact fiber sums under that equivalence and checks the target
map equation. A typeclass consumer checks the existing finite-partition boundary;
it implements no enumeration or incidence result. C11 still chooses canonical
decoder fibers, C12 global equal-pattern classes, and C13/C14 incidence/optimization.

The only new maintained Lean modules are the separately importable private example
and integrated tests. All existing production and test bytes remain unchanged.
The readiness audit maps the fifteen earlier criteria, R01-R18, CC01-CC07,
source anchors, trust and advice dispositions. Independent S06 review and later
S07 cumulative closeout remain distinct duties.

### Initial cumulative validation

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


### Independent review and finalization boundary

The retained reviewer `/root/pfr_c10_reviewer` returned the complete original
S06 report for R `46538155784656701e7c525e90b98e083a55c7e8ce0b8d4f146dcef723ecda0e`. Supported admission is valid; all three independent
criteria are satisfied with no findings. Parent reconciliation separately assesses
the report's mathematical meaning and evidence limits. The durable report reference
is `22a6b293124d292da28c319c71a66c7d00e53b149a388d227872b9987a59d4ca`; reconciliation is `6018abc792e4d4667c2d9143cebacd4625f295263433d2a7df79567c0e7e7b03`.

The reviewer independently authenticated all 140 ordinary R inventory files,
reread the designated manuscript pages and both new Lean modules, refreshed the
earlier source/API boundaries, and checked the readiness crosswalk. It verified
the explicit Example 6 output swap, the actual reverse certificate, independent
PPS/VPS/PPM targets and label maps, and consumption of the public normalizer's
actual witness. All three S06 criteria are satisfied without findings.

Its fresh fourteen-target build (2788 jobs) and default build (2762 jobs) passed.
Its separate exhaustive audit covered 1009 named constants across eight C10
modules, with only `propext`, `Classical.choice` and `Quot.sound`. Its first scratch
audit failed because an untyped counter inferred `MessageData`; the original
failure was retained, and a second run with an explicit `Nat` annotation passed.
No maintained-source defect or mathematical correction resulted.

Parent reconciliation agrees after checking the source contracts and independent
logs/driver. Builds remain incremental; anonymous examples are checked by
compilation. The review does not independently reauthenticate excluded private
workflow history, early-checkpoint chronology or historical log preservation;
separate parent records cover those facts. Requested reviewer settings remain
distinct from unknown effective settings. No new suggestion or deferral arises,
and S07/CC08 retain their separate fresh cumulative review and closure duties.


Only owning Markdown status/evidence records change after R. Reviewed Lean/tests,
normative plan, earlier mathematics, lightweight root, pins and workflow tools
remain fixed; historical project-log bytes are preserved. Fresh final focused/default
builds and source/manuscript/placeholder/link/artifact checks follow these documents.
The exhaustive 1,009-constant audit remains applicable through exact source/artifact/
driver hashes. Included files then remain fixed through F and supported durable
closure. That later record establishes S06 completion. S07 remains unstarted.


## S07 - Fresh cumulative independent validation and closeout - 2026-09-29

The startup and initial-validation paragraphs retain their earlier checkpoints.
The final S07 subsection records the subsequent independent review and
reconciliation; the durable execution record governs final closure.

**Status:** fresh cumulative independent review and reconciliation complete; final validation/closure checkpoint.

S06 durably closed under `b318a3f0c09eeaf12d3809a5d8eba39514a5e700d842e49a226d976d23e1e939`;
its F is `cad93e8c893d559da806bc31caecba0949bf1724d77810b2e193ac85818d1606`.
Startup verified all six original reports/reconciliations, eighteen satisfied
criteria, no outstanding finding/decision and all 141 final source/environment
entries. This resolves the preceding S06 pre-F checkpoint while preserving it.
The fresh conditional S07 request was accepted with B
`4af45cd9bbbff325df215359af25962a2a93f2134c4a9f00b614e0acf2e49e2d`.
Earlier skipped requests remain consumed historical records.

S07 owns the fresh cumulative assessment of all eighteen earlier criteria,
R01-R18 and CC01-CC08. The readiness audit now includes the three S06 criteria
explicitly and distinguishes universal R02 endpoint laws from independently
checked numerical coordinates. All existing mathematics remains unchanged.
Parent contextual helpers refresh actual source; their work is attributed and
does not replace the bound reviewer's separate cumulative review. The exact
normative plan, original reports, dependency pins, root and tools are preserved.

Fresh builds, source/manuscript/API/import checks and an exhaustive eight-module
trust audit follow. Independent report receipt/reconciliation, required corrections/
review, final applicable validation/F and supported durable closure remain separate
subsequent duties. Only that final record completes C10; no later chunk begins.


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


### S07 original independent review and critical reconciliation

The retained reviewer `/root/pfr_c10_reviewer` supplied the complete original
fresh cumulative report on R `fda9bdc153d5d4820e91393518aeb58d8c2fb84dd89df3ac9ba39af198d15191`. It is validly admitted under reference
`694e05b9b94ea83ba9c8c9267302550f084c5f570d1e33a99d3169a5cd1e6bb0` and explicitly reconciled under `b6204258e0d0616345ee31f8e1265b30230bedb23c76dbd24aa9e45cb7a21cdc`.
All three S07 criteria are satisfied with one optional stale-status finding, corrected here. The report explicitly
reassesses all eighteen earlier criteria, R01-R18 and CC01-CC08 review-time readiness.

The fresh independent review read the complete three production and five
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


The parent separately reconciled source meaning, assumptions, manuscript repairs,
full cumulative coverage and evidence limits. No mathematical correction or new
deferral is required. Its earlier local request postcheck failed by looking for
`criteria` instead of the actual `requirements` field after the request was saved.
The original failure remains preserved; separate read-only inspection verified
the saved request, actual criteria and exact text hash. No request or workflow
record was patched or repeated, and no false success was claimed for that check.

Only owning Markdown changes after R. All maintained Lean, exact normative plan,
root, pins and tooling remain fixed, with historical log bytes preserved. Fresh
final focused/default builds and source/manuscript/placeholder/link/artifact checks
follow. The fresh S07 1009-constant trust audit remains applicable through exact
source/artifact/driver hashes. F and supported durable closure follow these records;
only that later record completes CC08 and C10. Included files stay fixed after F.
No later chunk, commit or push begins.
