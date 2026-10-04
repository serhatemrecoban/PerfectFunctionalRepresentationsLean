# PFR-C07 implementation notes

These notes record execution of the
[approved revision-2 plan](plans/pfr-c07-four-typed-matrix-operations.md).
The [planning notes](pfr-c07-planning-notes.md) retain manuscript identities,
prerequisite verification, original plan review and suggestion dispositions.

## S01 - Ordered index maps and raw PMF core

### Authority and baseline

On 2026-09-21, after endorsing the delivered revision, the lead wrote
"good, start step 1 with its revies process". Together these messages authorize
the exact revision-2 execution contract and S01 with the installed review.
This adopts the recommended DG-08 interpretation including value-one VPS;
it is contextual approval of the presented plan, not a fabricated separately
quoted beta decision. Only S01 is authorized now.

The exact original delivered revision, actual messages and interpretation are
retained in `.pfr-review/setup/c07-s01-20260921/`. Only the plan's reserved
editorial status block changed at approval; its normative body remains exact.
The registered approved file hash is
`1015017cfcba458774e938541286cb5db0fd65f7f5c2fc92f4019193e359d635`.
The execution session captured B before mathematical edits and reuses the
bound `/root/pfr_c07_reviewer`; requested Astra/ultra/no-parent-history,
effective settings unknown. C06 remains complete and unchanged.

### Scope and implementation choices

S01 owns Section 4, the Section 6 permutation's index laws, and R01-R03.
Raw channels retain arbitrary input types, including empty and infinite types;
there is no activity, singularity, input-prior or finite-input premise.
Endpoints and constant masks are valid raw constructions. Their later active
legality is not asserted here. S02/S03 own legal operation wrappers and all
operation recovery equations; C08/C09 and subsequent mathematics remain outside
this work.

The common finite-index definitions are separated into
`Matrix/OperationIndices.lean`, with raw PMF constructions in
`Matrix/Operations.lean`. This permitted helper split lets index consumers use
the ordered insertion/deletion/permutation API without importing probability
or C06 column data. Both modules use namespace
`PerfectFunctionalRepresentations.MatrixOperations`; the lightweight root is
unchanged. The permutation uses mathlib's `finSuccEquiv'` directly rather than
introducing a general permutation framework.

The exact paper order keeps the lower merge label and deletes the higher
label, including the final source label. This implements the extended v16
correction recorded by OM-024 (OM-070 remains its historical duplicate).
PPS is a bind through the supported `PMF.binaryMixture` kernel, common merge is
a map, and VPS is a map depending on the input row. PMF normalization and C06's
coordinate views own the row laws. Real formulas are derived from exact
ENNReal laws, with NNReal subtraction and finite PMF sums justified explicitly.

### Initial validation checkpoint

The initial integrated build passed for both production modules and the
regression module (2762 jobs). C06's two matrix tests, the Definition 4 example
and root passed together (2768 jobs); `lake build` passed (2762 jobs).
These are incremental builds, not clean dependency rebuilds. The root does not
import C07, so its successful build is supplemented by the focused targets.

There are 69 new public declarations: 34 index declarations and 35 raw/Real
operation declarations. The kernels/maps and their semantic equations are
consumer-visible; seven one-use PMF coordinate helpers are private. The public
signature and axiom audit compiles every declaration. R01-R03 have 43 compiling
examples, including non-involutive forward/inverse labels, generic exact/Real
laws, empty and infinite input types, raw singleton endpoints and actual PMF
transport through a proved cardinality equality. No example declaration is
promoted to public API.

The source audit preserves all 101 unchanged baseline inventory entries,
including completed Lean, root, dependencies and workflow. Seven owning Markdown
files change and four maintained files are added; the approved plan's normative
body is unchanged. The placeholder scan has no matches, local links and diff
checks pass, all seventy omission IDs remain, and no generated/reference file
is tracked or staged. DG-01-DG-08 are resolved; seven gates remain open or partial.

The first integrated regression build failed on literal Fin simplification and
noncomputability annotations; the corrected second build passes. Index/PMF
scratch failures and speculative absent search names remain negative development
observations, not evidence of a library defect. The initial public-audit parser
needed to normalize universe annotations on standard axiom names; the successful
Lean output is retained separately from that parser failure. No maintained
dependency or proof changed for that correction.

No new Future Work Note or unowned suggestion is introduced. Existing C07
later-step obligations and C08-C12 mapped deferrals retain their owners and
triggers. Contextual self-review and separate reassessment precede independent
dispatch. No independent S01 report or step closure is claimed at this checkpoint;
original report reconciliation, applicable final checks, F capture and durable
closure follow it. S02 will not start automatically.

### Independent review and finalization readiness

The same bound reviewer independently satisfies C07-S01-C01, C02 and C03,
with no material or optional findings. It freshly reauthenticated the source,
fourteen explicit dependency files and designated manuscript pages; its
focused S01/C06/root build passed (2770 jobs), and its default build passed
(2762 jobs). All 69 public signatures and axiom reports passed, with only
`propext`, `Classical.choice` and `Quot.sound`. Six independently written
consumers also compiled, exercising Real parameters, inferred positive merge
dimension, actual cardinality/PMF transport, opposite permutation directions
and raw value-one routing. These remain reviewer-owned probes, not a new
maintained API or later-step implementation.

The parent read the complete report and critically reconciled its criterion
allocation, numeric justifications, generality, manuscript correspondence and
verification limits. The conclusion is supported; no mathematical correction,
extra review round, deferred finding or new Future Work Note is needed. The
initial uncertain native receipt remains unchanged and was separately confirmed
from the actual full original report, without resending. Installed classification
is VALID. Original revision-1 plan review and negative development observations
remain historical and are not relabeled as S01 implementation evidence.

Private execution references:

- B: `a95b85d25d0c6a91247910eab3dde5257cf719f5ce6f85e07fdaa12cb45d255e`.
- R: `0d3027b39949a986e5ceebec55d91f78079a1cf1217964ba7beb805c4e1e7d09`.
- Original report: `a38130ffb9117f7b18eaeb7972dbdcaa91d19515a0910c50ce6234575d001075`;
  original payload SHA-256
  `3fdaf0f54a813fe6a4b0099c1d8593797f70cb8c5e738bdcece5a52e8886c19c`.
- Explicit reconciliation:
  `7a1b3fb843332e560ee54e14ddc656a3b4e7d6ead0ca914b9486da2126b41b09`.

Only owning status/reconciliation Markdown changes after R. Final focused/default
builds and full captured-source applicability checks follow these document
updates, then F capture and supported durable closure. This pre-F checkpoint
does not predict that later transition; `.pfr-review/chunks/PFR-C07/execution/`
owns the actual completion record. S02 remains unstarted and needs a new request.

## S02 - Pattern-preserving pair and recovery

### Authority, prerequisite closure and baseline

On 2026-09-21 the lead requested "Continue with step 2 with review process if
step 1 with its review process is completed". S01's durable closure is
`a678f0c258c0e87b6c3392c283cd19967d4595653d9ddd20f00a454efda2999e`, with F
`e5c5fb3af0b81cf539a4773d98ed40538d10b67e2f9f7ccefa56fa1d448ed598`.
The original accepted report, explicit reconciliation and all three satisfied
criteria were verified; all 112 inventory entries exactly matched current source.
The earlier pre-F text above is retained as a historical checkpoint, not a claim
that S01 remains open. The installed execution workflow consumed this fresh
conditional message once and selected only S02, preserving B before edits.
The same bound reviewer remains responsible for independent review.

S02 owns legal PPS/PPM, their complete closure and exact/Real column-data laws,
both witnessed recoveries and R04-R08. The strict PPS ratio and shared PPM
support remain explicit. Recovery includes positive finite denominator and
the ratio orientation, even when the merged value is one. State-cardinality
casts preserve the source order. No VP closure, C08/C09 theorem, dependency or
workflow change, commit, push or later-step execution is authorized here.

The designated ISIT and extended-v16 files still match their recorded hashes.
The cached page extractions were reread for the PP definitions and the full
merge-index correction. The later inverse prose motivates witnessed recovery;
no global inverse or unique ratio determined by a merge output is asserted.

### Proof organization and public interface

The step's B is
`c5a2ce4ca09fa0801035e537d211fcc8de6a6e402d1913f113dece433bd4f83c`.
`Matrix/Operations.lean` now imports C06's focused `Matrix/SingularColumns`
module. The existing raw constructions and index module remain the semantic
foundation. No root import or completed C06 declaration changes.

`pps` and `ppm` return the existing active state and take singularity as a
separate premise. Their cardinalities are definitionally `n+1` and `n-1`.
The merge derives `2 <= n` from the ordered labels and exposes
`mergeSourceEquiv`, `activeMergeSurvivor` and `activeMergeRetained` to express
the predecessor presentation without choosing a new enumeration. The actual
row equation is a map through that cardinality equivalence followed by the
existing common merge. These maps remain available to S03's common-merge use.

Public equations expose the PPS kernel/bind, both raw/state equations, exact
and Real selected/unaffected coordinates, and PMF-derived row sums. Activity
is part of the result state; singularity is proved separately. C06's
`columnValue` and `columnPattern` are reused directly through `activeEquiv`.
Pointwise support equality is equivalent to equality of the nonempty finset
patterns when a `Fintype` is exposed. The merged-value bound uses an actual row
in the common support and its PMF normalization; it permits equality at one.

`ppmRatio` computes the first original value divided by the sum, in NNReal.
Public laws prove positive finite denominator, both strict bounds, the exact
product identities, and the Real ratio bridge. The private arithmetic proof
reduces finite ENNReal values to NNReal, uses positive-denominator cancellation
and nonnegative subtraction, and transfers the products back. Support cases
then give both product identities in every row, including rows outside the
shared support. `ppmRatio_pps` recovers the remembered strict split weight.

`ppsRecovery` and `ppmRecovery` are witnessed compositions of the legal
constructors, not a new operation relation or global inverse. The first has
identity order after its cardinality cast. The second proves selected and
unaffected coordinates, then uses the existing raw permutation proof.
`ppmRecoveryEquiv` is exactly `finCongr hcard` followed by the S01
new-to-original `recoveryPerm`. Both packaged and normalized-row equations,
their inverse directions and the adjacent identity case are public. This
keeps C09's required semantic kernels and recovery available while leaving
its preservation mathematics unstarted.

The public interface adds no input prior, full-support condition, default label,
distinct-pattern assumption or strict merged-value bound. Constructors use
`Finite`/`Nonempty`; only finset pattern statements expose `Fintype`. No
one-use arithmetic or coordinate helper is promoted merely for enumeration.

### Initial validation checkpoint

The integrated production/regression build passes (2763 jobs); the C06 matrix
tests, Definition 4 fixture and lightweight root pass together (2768 jobs), and
`lake build` passes (2762 jobs). These are incremental checks, not clean
dependency rebuilds. The regression file now has 69 anonymous examples:
43 retained S01 examples and 26 S02 examples, with private fixture lemmas.

R04 splits a value-one column with unequal weights and retains an unaffected
column and null rows. R05 merges its unequal positive children at a final
source index, giving value exactly one. R06 checks remembered ratio `1/3`
and both legal adjacent round trips. R08 rejects endpoint ratios and unequal
patterns. R07 uses the approved `[1/10,2/10,3/10,4/10]` row at indices 0/3,
computes ratio `1/5`, checks all merged/recovered masses, relates the concrete
row to the legal recovery state, and proves correct maps in both directions.
Wrongly mapping that legal recovery by `rho.symm` differs at coordinate 1.

The helper-run public audit freshly compiles all 153 named declarations in
the two production modules: all 69 S01 names plus 84 S02 names. Exactly 153
signature and axiom reports are present; only `propext`, `Classical.choice`
and `Quot.sound` occur. Production hashes are stable before/after that audit.
It separately checks imports, the unchanged root/configuration and all ten
pinned package checkouts. Final regression-body compilation belongs to the
parent's integrated build rather than that signature audit.

Early scratch failures involved proof transparency across definitionally equal
Fin cardinalities, dependent rewriting of the ratio proof, and concrete fixture
elaboration. They are retained as development failures, not library-defect or
passing validation evidence. The first production build had four long-line
warnings; the final production and regression builds have no diagnostics.
Private arithmetic proof types are explicit; no linter is disabled.

Contextual self-review and separate reassessment follow this initial checkpoint,
before the same bound reviewer's source-based assessment. No independent S02
report, reconciliation or closure is claimed here. No new deferral or Future
Work Note is introduced; mapped later work retains its owners and triggers.

### Original independent review and reconciliation

Contextual self-review and the separate reassessment found no unresolved
acceptance issue. The same bound reviewer received a neutral request tied to
the actual R snapshot, inspected the PP source and pinned APIs, reauthenticated
both manuscripts, and rendered and visually checked their allocated pages.
All three original S02 criteria are `SATISFIED`, with no material or optional
findings. The complete native `FINAL_ANSWER` was observed, preserved unchanged,
classified valid, and critically reconciled through the supported workflow.
The uncertain immediate submission remains intact; the original report
separately confirms delivery. No native event ID was exposed or invented.

The reviewer freshly passed the focused/C06/root build (2770 jobs), default
build (2762 jobs), all 153 public signature/axiom checks, and nine independent
consumers using only public interfaces. Those consumers cover generic active
PPM without `Fintype`, a strict Real split parameter, inverse cardinality-cast
coordinates, both ratio products at merged value one, inverse recovery,
unaffected Real recovery coordinates, recovered singularity, C06 pattern
equality as a PPM input, and pointwise Real split-to-merge recovery.
The public audit reports six axiom-free declarations and 147 whose combined
axioms are exactly `propext`, `Classical.choice` and `Quot.sound`.

Two reviewer-owned cast-proof attempts failed before the unchanged statement
compiled with its definitional identity cast made explicit. Their original
`FAIL` evidence remains separate from the final `PASS`; no satisfied criterion
cites the failures. No maintained source or hypothesis changed to obtain that
consumer pass. The parent's reconciliation agrees with the legal domains,
all column-data laws, positive finite ratio derivation, every recovery
coordinate, and explicit new-to-original permutation. The actual asymmetric
R07 regression detects the opposite direction. No correction, new deferral,
or further independent round is required.

Private execution references:

- R: `7c1f9f95fc6629ce406f5a30adf5eb7c696369ce99c2b3d4e3dc5471909de432`.
- Original report: `95c356ede4e695df317800d62ce67b5aaece406adfeced63fe4482617194cf98`;
  original payload SHA-256
  `096c7095d1c265f217927ccc691cf8699b0a6b30eff7ba7c22ff5fe3b1e3fb8c`.
- Explicit reconciliation:
  `b068230f1f448f5775c65db96113dd546c6f2130ed79cb4cada974e27e03b6d0`.

Only owning status/reconciliation Markdown changes after R, including removal
of a stale living-summary row that still described C07 as planning-only.
All reviewed Lean, dependency and normative-plan bytes remain unchanged.
Final focused/default builds and B/R-to-current source checks follow these
updates, then F capture and supported durable closure. These are incremental
builds and targeted consumers, not a clean dependency rebuild or exhaustive
downstream analysis. This pre-F checkpoint does not predict the later closure;
`.pfr-review/chunks/PFR-C07/execution/` owns that actual record. S03 remains
unstarted and requires a later request.

## S03 - Value-preserving pair and recovery

### Authority and prerequisite verification

The lead requested "Continue with step 3 with review process if step 2 with its
review process is completed" on 2026-09-21. Before processing that message,
S02's durable closure
`d7379a98dc1ce7d492d3bb0ba94d5a413fc870decf0400f0e2b918ba431873e9`, original
accepted report, explicit reconciliation and all three satisfied criteria were
verified. All 112 inventory entries exactly matched its final F,
`69cf761712c7a91af827c8ee293e9bc96b022b7e7ee435bd2a813198cc9dfba9`.
The preceding pre-F passages remain historical. The installed workflow consumed
this new message once and selected only S03; the same bound reviewer continues.

S03 implements the legal VPS/VPM pair, complete closure and column data,
support/indicator bridges, mask irrelevance outside selected support, and both
witnessed recoveries with R09-R13. The approved revision-2 interpretation permits
value one in VPS and VPM; the printed strict VPS bound remains a documented
source departure. VPS requires two nonempty pieces of the selected support,
and VPM requires equal exact C06 values and disjoint supports. No global mask
uniqueness or arbitrary output-only VPS channel is asserted. Existing maps,
cardinality casts and recovery permutation are reused. S04-S05 and later
preservation/path mathematics remain unstarted.

The designated manuscript hashes were rechecked and their allocated III-A
passages reread. The extended v16 full merge-index range and the witnessed
interpretation of inverse prose remain applicable. OM-038, OM-049 and OM-051
are exercised by this step; their later pruning/path owners remain intact.
No numbered Future Work Note exists or is introduced at startup.

### Proof organization and public interface

S03's actual B is
`9413e83a19ce0752affc654e0a9eb651dbe08a8f4aff247af4e19f1a88c4fc45`.
The new declarations extend `Matrix/Operations.lean`; the existing index module,
PP declarations, C06 modules, lightweight root and imports remain unchanged.
`vps` routes the selected mass using `vpsIndex l (mask x)`, explicitly depending
on the input row. Its two support witnesses establish child activity; the
unchanged other columns inherit activity. Exact/Real coordinates and row sums
reuse the raw PMF laws, while singularity follows column by column.

`vpm` reuses `mergeRaw` through `mergeSourceEquiv`, `activeMergeSurvivor` and
`activeMergeRetained`. Its selected mass is the sum of the two old masses.
Disjointness ensures at most one contributes in a row; equal admitted values
then prove singularity and the unchanged common value. Both constructors
expose actual cardinalities and map equations. No fresh enumeration, new state
record, strict value bound or input prior is introduced.

C06 column accessors supply exact/Real values and patterns. VPS patterns are
the true/false filters, proved disjoint with union the old pattern. Its legal
witnesses are equivalent to filter nonemptiness. The divided Real child columns
are the original indicator multiplied by the mask or its complement, and
their sum is the original indicator even outside the support. VPM's pointwise
disjointness is equivalent both to finset disjointness and to the printed
indicator sum being zero or one; the C06 divided-value presentation is exposed.
All unaffected column data are retained. Finset formulas alone expose `Fintype`.

`vpsRaw_mask_irrelevant` holds without finite/nonempty inputs or singularity;
`vps_mask_irrelevant` gives the legal-state channel equality. Neither claims
that a mask is recoverable at rows with zero selected mass. `vpsRecovery`
legally merges the adjacent children; exact row recovery gives legal witnesses
for splitting again with the original mask. `vpsRecovery_resplit` proves that
legal remembered-mask round trip directly.

`vpmRecoveryMask` is the Boolean nonzero indicator of the original lower column.
Old activity and disjointness supply both nonempty child witnesses inside the
merged support. The selected and unaffected recovery coordinates precede the
whole-row proof. `vpmRecoveryEquiv` is exactly the cardinality equivalence
followed by the existing new-to-original `recoveryPerm`; forward, inverse,
normalized-row and adjacent recovery equations are public. This includes common
value one without division or a strict upper-bound premise.

Scratch failures involved encoding and dependent Fin/coercion proof elaboration,
not changed mathematical contracts. Their original files/logs remain in ignored
scratch or private check records. Integrated validation and the two contextual
review phases precede the bound reviewer's independent assessment; no S03
independent report or durable closure is claimed at this implementation checkpoint.

### Initial validation checkpoint

Production builds without diagnostics. The integrated index/operations/regression
build passes (2763 jobs); C06 tests, the Definition 4 fixture and lightweight root
pass together (2768 jobs), and the default `lake build` passes (2762 jobs).
These are incremental builds. The maintained suite now has 105 anonymous examples:
69 retained R01-R08 examples plus 36 new R09-R13 examples with private fixtures.
The module overview was then updated to list S03 coverage, followed by a fresh
focused validation of the final source bytes before review.

R09 splits a one-output value-one channel and checks both unchanged values,
the actual row-dependent map, and proper-support filters/indicators with a null
row. R10 rejects an ambient nonconstant mask that is constant on the selected
support, rejects every singleton-support split, and compares masks differing
only off-support. R11 includes disjoint equal-value columns at indices 0/final3,
with common value one, selected/unaffected data and union pattern; equal-value
overlap and unequal-value disjointness each fail the corresponding legal premise.
R12 checks all rows of adjacent recovery and legal resplit with the remembered
mask, including a null selected row. R13 checks the constructed support mask,
both packaged map directions and the actual nonadjacent permutation on every row.

The helper's full public audit passes all 233 exact signatures and axiom reports:
34 index declarations and 199 operations declarations, adding 80 S03 names to
the earlier 153. Only `propext`, `Classical.choice` and `Quot.sound` occur.
Production hashes remain unchanged through the audit; all ten pinned packages
are clean, imports/root/configuration are unchanged, and no placeholder is found.
The numeric disjoint-support/divided-value bridge now exposes only `Finite`,
with a local `Fintype` for the C06 proof. Lean's linter motivated this bounded
generality improvement; the original warning-bearing builds are retained.

Helper coverage advice was adopted by adding both individual divided-indicator
consumers and generalizing adjacent recovery from one row to all rows. A stale
map status sentence was corrected to S01-S02 complete/S03 authorized. No advice
is deferred. The successful imported fixture run and earlier failed coercion
attempts remain distinct records. Contextual self-review, separate reassessment
and the installed independent review follow; no S03 report or closure is claimed
at this checkpoint.

### Independent review and finalization checkpoint

Contextual self-review and the separate reassessment found no unresolved
acceptance issue. The same bound reviewer then returned its complete original
S03 report: all three criteria satisfied, with no material or optional findings.
The actual native payload and sender/recipient metadata are preserved; the
initial empty submission remains uncertain, with delivery separately confirmed
by that correlated original report. The parent's critical reconciliation agrees
with the exact legal domains, complete data/support bridges and both witnessed
recoveries. No mathematical correction, new deferral or additional review round
is required.

The reviewer freshly authenticated both designated manuscript binaries and
visually checked the allocated pages, distinguishing the printed strict VPS
bound from the approved value-one interpretation. Its focused cumulative/C06/root
build passes (2770 jobs), as does the default build (2762 jobs). All 12 independent
generic consumers pass without diagnostics, including finite-only numeric use,
constructors from filter/disjointness witnesses, legal remembered-mask resplit,
value one and forward/inverse/unaffected recovery coordinates. All 233 public
signatures and axiom reports pass, and the earlier 153-report sequence remains
an exact prefix. Only standard Lean axioms occur. Current consumers and audit
passed on their first runs; earlier reviewer failures remain preserved as
historical negative evidence.

Private execution references:

- R: `2c7abb4980f5704c1778394fc439e5d15419b6e95bc9ff8953c1179de34d077d`.
- Original report: `178126c5d5d908190e970faafa3acd3a9e64320e14a549d8017e49df44680089`;
  original payload SHA-256
  `a188a274f73173bb03941a0fe7b2d52d0f00002d4823789b58060da95f811a6f`.
- Explicit reconciliation:
  `9173e253f463738363adf94807788b1726a35cb2b6e1bbe9f4a36c81fd56527e`.

Only owning status/reconciliation Markdown changes after R. Reviewed Lean,
dependencies, imports and the normative plan remain unchanged. Final focused
and default builds, placeholder/source/link/artifact checks and exact B/R
applicability checks follow these updates, then F capture and supported durable
closure. These are incremental builds and targeted consumers, not a clean
dependency rebuild or exhaustive downstream analysis. This pre-F checkpoint
does not predict the later closure; `.pfr-review/chunks/PFR-C07/execution/`
owns the actual record. S04-S05 remain unstarted and require later requests.

## S04 - Examples, regression handoff and review readiness

### Authority, prerequisite closure and baseline

The lead requested "good, continue with step 4 with its review process" on
2026-09-21. S03's durable closure
`8ad60f2da56c3fb22e11de633d270ef399fc85554c2176d91db6d1e8e56c2759`, its original
report, explicit reconciliation and three satisfied criteria were verified.
All 112 inventory entries exactly matched final F
`a453a190b4181c768ac2b32c2fa04baed199c1ccb15e330379930d8448b734c0`.
Earlier pre-F passages remain historical. The same installed execution session
and bound reviewer continue; this message authorizes only S04.

S04's actual B is
`fec86b5b544ce655296ddb5641d701afbfd1b6332e65f171912dedc4e386a68f`.
This step owns complete Real-parametric Equations (11)-(15), Examples 2-5,
generic public C08/C09 consumers and the declaration/criterion/consumer
readiness mapping, with R14-R16 and affected earlier checks. The strict
`0 < beta < 1` hypothesis belongs to these active paper fixtures; it does not
undo the approved value-one domain of the general VP operations.

The designated manuscript hashes were freshly checked and the III-A displays
reread. The full merge-index correction and the private-fixture policy retain
OM-024/OM-070 and OM-026 as owners; OM-050 owns the beta assumption. Existing
later owners and triggers remain in force. No numbered Future Work Note exists
or is introduced. No production change is currently needed; C06, the root,
pins, workflow and normative plan remain unchanged. S05 remains unstarted.

### Implementation and handoff choices

The new private fixture module constructs Equation (11) with C06's
`channelOfRealMatrix`, proves nonnegativity and each row sum, and gives explicit
activity witnesses for all five columns under `0 < beta < 1`. Its singularity
proof checks the displayed support directly. The four actual legal operations
use PPS at index 1 with ratio one half, PPM at indices 3/4, VPS at index 0 with
mask `![true, true, false]`, and VPM at indices 0/2. The legality proofs establish
the support equalities, selected-support pieces, admitted-value equality and
disjointness required by the public constructors.

Whole Real matrix equalities cover every entry and the exact displayed order
of Equations (11)-(15). Each yields an all-entry `ENNReal.ofReal` bridge through
C06's existing conversion theorem. Separate consumers check all five output
cardinalities, every column's activity, singularity and exact/Real row sums.
Endpoint regressions show the particular source columns that lose activity at
beta zero and one. This explains the fixture hypothesis without imposing it on
general VPS/VPM. All fixture declarations are private or anonymous.

R15 adds 36 generic anonymous consumers to the existing operation regression
module. They use all four constructors, their kernels/maps and public legal
inverse witnesses, the recovered ratio and its products, and forward/inverse
recovery transport. Four C06 relabeling consumers concern the actual recovered
endpoints. They do not assert perfectness preservation across an individual
operation. Semantic consumers use `Finite` and `Nonempty`; only the finite-set
presentations add `Fintype`. No private coordinate helper is unfolded.

The [readiness audit](pfr-c07-readiness-audit.md) maps all 233 public names in
22 families to source anchors, the twelve S01-S04 criteria and regression
consumers; it also accounts for R01-R16 and CC01-CC10. It retains every relevant
source interpretation and later owner, and distinguishes this handoff from
S05's fresh cumulative review and actual closure. No new public declaration,
dependency import, production proof or mathematical contract is needed.

### Initial validation and retained development evidence

The parent integrated the exact successfully compiled helper fixture
`6158c5a9502a746acfb077936d7ef90b6a5f89d7c6d95537b7329c274da57d76`.
Its 28 anonymous consumers cover all 75 entries. The operation regression
module has 141 anonymous consumers, including 36 new R15 checks, for 169
maintained C07 examples in total. Both designated manuscript binaries were
freshly hashed, and ISIT p. 3 / extended v16 pp. 3-4 were rendered and visually
checked. No reference artifact is a maintained deliverable.

Initial parent validation passes:

- The integrated R15 operation regression build: 2763 jobs, no diagnostics.
- The required nine-target aggregate: both production modules, both C07 test
  modules, both C06 test modules, the Definition 4 fixture, C03 singularity
  regressions and the lightweight root; 2774 jobs, no diagnostics.
- Default `lake build`: 2762 jobs, no diagnostics.
- Fresh full public audit: all 233 signatures and 233 axiom reports, permitting
  only `propext`, `Classical.choice` and `Quot.sound`. All ten installed pins,
  focused production imports and the root remain unchanged and clean.

R15's helper probe passed first time. R14's first three failed source snapshots
and full outputs are retained: constructor/index elaboration, finite-vector
reduction and survivor rewriting, then recursive simplification plus explicit
row-sum/endpoint arguments. The final proof uses the public Real coordinate
theorems followed by definitionally checked scalar goals and `ring`; the whole
matrix targets and strict beta hypotheses are unchanged. Final scratch attempt
04 and the integrated module pass without diagnostics. No recursion limit or
trust setting was raised. These failures concern proof elaboration, not missing
mathematical outcomes, and are not counted as passing evidence.

The source audit checks exact B ownership, unchanged production/C06/root and
normative plan, retained earlier regression text, the 233-name readiness map,
local links, placeholders and artifact hygiene. Actual records are retained
under `.pfr-review/setup/c07-s04-20260921/`. Validation is incremental and the
dependency/source inventory is explicit rather than a universal analysis.
Contextual self-review, separate reassessment and independent review follow
this initial checkpoint. No S04 report or durable closure is claimed here.

### Independent review and finalization checkpoint

Contextual self-review and separate reassessment found no unresolved issue.
The same bound reviewer then returned its complete original S04 report, with
all three criteria satisfied and no material or optional findings. The actual
native payload and metadata are preserved. The initial empty submission remains
an uncertain receipt; delivery was separately confirmed by that correlated
full report. The parent's critical reconciliation agrees with the complete
fixtures, generic public handoff and readiness mapping. No mathematical
correction, new deferral or additional independent round is required.

Fresh reviewer checks pass: the required aggregate (2774 jobs), default build
(2762 jobs), all 233 public signatures and axiom reports, and five independent
public consumers covering the four recovered endpoints and the exact numeric
bridge. Both manuscripts were freshly authenticated and visually compared.
The reviewer found all 233 names exactly once in the 22-family readiness map,
with source repairs, assumptions and later owners retained. Six declarations
are axiom-free; the remaining trust union is the three standard axioms.

One diagnostic remains explicitly FAIL: raw and newline-normalized comparison
with the reviewer's earlier audit output differed because the open namespaces
changed qualified-name presentation and wrapping. A separate comparison
removing only that qualification and whitespace passes; all 233 axiom records
match. The parent independently confirmed the presentation-only explanation.
No satisfied criterion relies on the failed comparison. Fresh Lean audit
success and unchanged production bytes establish the actual trust result.

A helper's wording suggestion is adopted: the earlier sentence about semantic
consumers now explicitly includes `Nonempty` alongside `Finite`. The code,
compiled signatures and independent report already state these assumptions;
only finite-set presentations add `Fintype`. This is a documentation clarification,
not a changed domain or new deferred obligation.

Private execution references:

- R: `8c24b680a6d9dd9fc6561fe1228590d98d7a65a0c8f346f8c93e8c9be619550f`.
- Original report: `08dc20c56db3d4cfae72377b7562e5b377cb2fe840374609bbe8128bf26ecee5`;
  original payload SHA-256
  `ec3d2c3ab19545a08dbfa7d42aeafa4b8efb3f400114909424e7887daf787b39`.
- Explicit reconciliation:
  `45ba334b3507a44cc542d74af441ecc3d2229f203cd4c0ba8f2126f63afbc6e0`.

Only owning Markdown status/reconciliation and the assumption wording change
after R. Reviewed Lean, dependencies, imports and normative plan stay unchanged.
Final required aggregate/default builds and B/R/source, placeholder, link and
artifact checks follow this checkpoint, then F capture and supported durable
closure. Validation is incremental; explicit inventory is not universal
dependency analysis. This pre-F record does not certify future closure;
`.pfr-review/chunks/PFR-C07/execution/` owns the actual completion record.
S05 remains unstarted and requires its own later request.

## S05 - Fresh cumulative validation and chunk closeout

### Authority and prerequisite closure

On 2026-09-21 the lead requested "good, continue with step 5 with its review
process which is the last step of our plan". S04's durable closure
`f7ed3e569bd960c1e032c62e111cbe67ccddaaca4458c453300b2f586a38e0d4`, original
report, explicit reconciliation and three satisfied criteria were verified.
All 114 source/environment inventory entries exactly matched S04 F
`f2c6c597bcbabcdc8908f3dd0e1e07d7e748f15393ba308a2bbef453b056b1fe`.
Its preceding pre-F checkpoint is historical, not unfinished S04 work.

The existing execution session accepted only S05 and captured actual B
`3cc546b419921530cac5a74c8b89fa07b2c9fbae445f0a9d98dace0eda41a258`.
The same bound reviewer remains responsible for a fresh consolidated assessment
of all twelve earlier criteria, R01-R16 and CC01-CC10. Earlier favorable reports
are retained as historical evidence, not substitutes for that new assessment.
Requested reviewer settings remain Astra/ultra/no-parent-history, with effective
settings unknown. No later chunk, commit, push or dependency change is authorized.

S05 currently needs no new theorem or public API. Its initial work rechecks the
actual index/raw/PP and VP/recovery contracts, numeric/support boundaries,
complete paper fixtures, generic public consumers and declaration/omission map.
Fresh validation includes every maintained test/example module, the two C07
production modules, the lightweight root and default build, plus the complete
public signature/axiom/import and source/pin/hygiene audits. Any actual bounded
correction will be recorded and reviewed on its resulting source. The approved
normative plan and manuscript interpretations are unchanged.

### Fresh cumulative parent assessment

The actual index/raw/PP and VP/recovery source, all required R01-R16 consumers,
C06 interfaces and pinned public reuse were freshly inspected. Both designated
manuscript hashes match Section 2 of the approved plan; ISIT p.3 and extended
version 16 pp.3-4 were newly rendered and visually checked. The approved value-one
VPS departure, full merge-source range, selected-support nondegeneracy, witnessed
inverse language and strict shared example parameter remain explicit. No source
gap or mathematical correction was found. The source/criterion inventory in the
[readiness audit](pfr-c07-readiness-audit.md) was rechecked, not accepted merely
because earlier reports were favorable.

The API-discovery helper freshly inspected the complete index/raw/PP proofs and
their consumers; the prerequisite helper inspected all VP/recovery and fixture
proofs, C06 boundaries and omission ownership. These are attributed implementation
support, not independent review. The parent additionally inspected the semantic
definitions, selected/null-row recovery arguments and permutation transports,
the original manuscript renders, complete coverage map and actual evidence.
An independent rational-affine arithmetic cross-check of the maintained fixture
definitions reproduces all 75 display entries with zero mismatches and all 15
row sums exactly one; it supplements the compiled full-matrix Lean equalities.

Fresh parent validation enumerated all fifteen maintained test/example modules
and built them together with both production modules and the root: all eighteen
targets pass, 2787 jobs, without diagnostics. Default `lake build` also passes,
2762 jobs. All 169 C07 anonymous consumers are included. The helper's fresh
generated public audit passes all 233 exact signatures and axiom reports, with
only `propext`, `Classical.choice` and `Quot.sound`; current production hashes and
pinned environments match. These are incremental builds, not clean dependency
rebuilds or a universal dependency analysis. Source-intent inspection is separate
from compiler acceptance. No theorem, test, public name, import or dependency
changed in S05; current documentation now distinguishes actual S04 closure from
its retained historical pre-F checkpoint.

All twelve earlier criteria, R01-R16 and CC01-CC09 have current source and
validation support. CC10 is ready for independent assessment and subsequent
original-report reconciliation, final document checks, F capture and closure;
these later events are not certified by this checkpoint. Existing omission
owners/triggers remain sufficient and no new Future Work Note is warranted.

Thirty installed API reuse checks also compile; all ten configured dependency
checkouts are clean at their recorded revisions. The completed signature
inspection confirms unrestricted raw constructors, `Finite`/`Nonempty` legal
and recovery constructors, and fifteen `Fintype` signatures that expose finite
sets. No public `Inhabited` or decidability requirement was found. A helper's
auxiliary Python summary parser initially missed the one signature printed
without `@`. Its original script, exit 1 and diagnostic remain preserved;
corrected parsing covers all 233 and passes without rerunning Lean. This was a
presentation-check failure, not a failed Lean proof; it is not passing evidence.

### Contextual self-review and separate reassessment

The fresh cumulative self-review found one stale current-status sentence in the
formalization map's chunk inventory. Finding `pfr-finding:c07-s05-self-001` records
that it still named only S01-S03 complete and S04 authorized. A separate
reassessment confirmed this is a current inventory, not a historical checkpoint,
and adopted a bounded correction to S01-S04 complete and S05 active. The original
critique remains retained; fresh source evidence checks the corrected wording.
No mathematical correction, new deferral or substantive plan decision is needed.
The independent request requires separate explicit cumulative assessments for
all twelve earlier criteria, sixteen regressions and ten completion outcomes.

### Original cumulative independent report and critical reconciliation

The same bound reviewer supplied the complete original native S05 report.
All three current criteria are `SATISFIED`, with separate explicit assessments
of all twelve earlier criteria, R01-R16 and CC01-CC10. Every cumulative item is
satisfied and the finding list is empty. Its CC10 conclusion is explicitly
review-time readiness; it does not certify its own subsequent receipt or closure.

Fresh independent verification includes:

- Both complete production proof bodies, both full operation test/example
  modules, relevant C06 and pinned foundational interfaces, and all 75 displayed
  entries against freshly authenticated and rendered manuscript pages.
- The independently enumerated eighteen-target build (2787 jobs) and default
  build (2762 jobs), both passing; all maintained tests/examples are included.
- All 233 public signatures and axiom reports: six axiom-free, five using only
  `propext`, and 222 using the standard three-axiom set. The complete inventory
  has 233 unique names in 22 families; fixtures add no public named declarations.
- Eleven anonymous public-interface consumers and one reviewer-local helper,
  compiling without diagnostics. Five consumers adapt the reviewer's own earlier
  probe; six add null-row, finite-only indicator, unrestricted raw input,
  final-index and inverse-transport boundaries. Four use the actual recovered
  endpoints with C06 relabeling, without asserting C09 preservation.
- Fresh source/pin/import/placeholder/worktree checks and explicit omission/
  later-owner assessment. The reviewer matched 55 selected frozen entries;
  the parent's separate stability check matched all 114 R entries unchanged.

The parent read the entire report and its additional consumer, checked every
cumulative row and evidence reference, and directly compared the independent
audit output with the fresh helper audit: all 233 axiom records agree. The
source-intent conclusions agree with the independently transcribed manuscript
fixtures, public assumptions and actual recovery equations. All earlier original
reports remain retained, with no open independent finding. The self-review
map-status correction was resolved before R. No mathematical correction, new
deferral or additional independent round is indicated.

The original immediate native submission result was empty and remains recorded
as uncertain. The later complete, correctly correlated original report supplied
separate delivery confirmation; the uncertain receipt was not rewritten and the
request was not resent. The supported receiver classified the original `VALID`,
followed by explicit critical reconciliation. Exact references are:

- R: `dd3d1a40131c07413ee12fcee71a8a8a7857bf4385dc8360433510ff96936dfe`.
- Original report: `963ecd18e26bd4a5963c7003a9b4b72bb88bddff0201c5e8d38e22fd78a13c26`;
  payload SHA-256
  `87bb7d5bf0815daf5652f32562778952a83cce5bd51102f00c3f5ea8f31537ed`.
- Explicit reconciliation:
  `d3bcbba5cb266a8face9d83baecdc5e0ba073f00c6950b6040f0d33d0ee35006`.

No failed Lean check occurred in this fresh independent review. Its tracked
`git diff --check` passed with LF-to-CRLF warnings; it does not cover untracked
whitespace, so source reading, compilation and frozen hashes supply separate
checks. Historical reviewer probe/comparison failures and the parent's S05
summary-parser failure remain negative observations with their original
dispositions. Only passing evidence supports satisfied criteria. Builds are
incremental; explicit source scope is not universal dependency analysis, and
effective reviewer settings remain unknown. The reviewer did not inspect private
workflow records; the parent owns actual prerequisite and closing verification.

Only owning Markdown status, source-coverage and reconciliation updates change
after R. The README now summarizes the implemented interface and links to the
detailed records; OM-037 and OM-051 reflect actual operation-closure/recovery
coverage without changing their mathematical allocation. All reviewed Lean,
dependency, import and frozen normative-plan bytes remain unchanged. Final
all-maintained/default builds and B/R/source, placeholder, link and artifact
checks follow this checkpoint, then F capture and supported durable closure.
Only that subsequent record establishes C07 completion. It is owned under
`.pfr-review/chunks/PFR-C07/execution/`; the initial/final checks and post-closure
verification are retained under `.pfr-review/setup/c07-s05-20260921/`.
C08-C16 remain unstarted; no commit, push or dependency/workflow change is included.

### Finalization formatting correction

Final all-maintained/default builds passed (2787/2762 jobs), but the first
document-finalization call refused with `NORMATIVE_ANCHOR_MISSING` before F.
The closing documentation script had used Windows text-mode output for the
plan, converting LF line endings to CRLF outside the reserved status block.
The mathematical words were unchanged; the earlier parent source comparison
normalized line endings and therefore missed this exact-byte contract violation.
The failed call and source identity are retained as negative evidence.

A bounded correction restores the exact registered plan bytes outside the
status block from S05 B, preserving the actual closing status text inside it.
The strengthened source check now compares the raw normative bytes and their
registered hash and checks every exact normative anchor. No contract or workflow
record is relaxed or rewritten. Reviewed Lean and dependencies remain byte-identical,
so the successful final builds and independent mathematical report still apply;
fresh source/impact/document evidence is required before final capture and closure.
