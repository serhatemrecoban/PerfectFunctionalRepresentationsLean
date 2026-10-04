# PFR-C04 implementation notes

The approved contract is [Draft revision 2](plans/pfr-c04-finite-total-variation-maximal-coupling.md).
These notes record implementation choices and step evidence. They do not
authorize a later step or replace the original review records.

## S01 - finite total variation and overlap

**Status:** S01 durably complete. Its original closure and exact source
applicability were verified before accepting the fresh S02 request below.
The preclosure validation narrative is retained as dated evidence.

### Authority and baseline

On 2026-09-12, after accepting revision 2 and confirming readiness, the lead
requested "great, star step 1 with its review process". This approves the
accepted draft and starts S01 only. The lead's preceding guidance emphasizes
reasoned adjustments, recorded rationale and review of the actual result.
The approved mathematical requirements and scope remain unchanged.

The accepted pre-status draft SHA-256 is
`395327c5614bcb9ee7d3dea1615e801e6fa8dbb813debc78f486d53abe095e5f`.
After the editorial approval update, the execution registration uses full-file
SHA-256 `5a21fa5214edb34245eb4fc195b0978564a86e373984d16d25254688e936d5b4`
and unchanged normative SHA-256
`7a15413a8f39661e0e69a623867902f1ef311c4b8caad056d13a3aaa60e00ed9`.
Exact step baseline B is
`025c32bcc3ebc095d9dd7d6b20aab7c4c57adc369b9dabe7a0920f41ce4b321a`.
The installed execution session is `.pfr-review/chunks/PFR-C04/execution/`;
setup/authority/validation records are under
`.pfr-review/setup/c04-s01-20260912/`. The existing reviewer binding is reused.

HEAD remains `54c1714d1a9a891939d6c9f7d38c0d05896b2c75` with inherited C02/C03
and workflow changes. B distinguishes those bytes from this step's work.
LeanInfoTheory remains immutable `v0.1.0`; all installed pins passed the
read-only startup inspection. Earlier closed plans and review records remain
historical. No separate revision-2 plan review is claimed.

### Mathematical route and source boundary

The new independently importable probability module owns half-L1 `finiteTV`
and exact `overlapMass`. Sum pointwise minima to obtain the overlap bound;
sum the truncated-subtraction identity to obtain exact residual mass. The
pointwise real identity `|a-b| = a+b-2*min(a,b)`, together with both PMF mass
sums, gives the half-L1/overlap bridge. Non-top conditions are explicit before
using `ENNReal.toReal`. Symmetry, range and endpoint/support characterizations
are consequences of those identities. Residual functions remain notation,
without new public bundled types or helper definitions.

This is ISIT Section II-C Equation (9), supplemented by the overlap identity
in extended version 16 Appendix A (159)-(161). Their exact manuscript hashes
were rechecked and the relevant previously rendered pages visually inspected
again. The source version is unchanged. Common/exclusive-mass discussion in
the same designated extended version supplies downstream context only.
No coupling, mismatch, decoding bridge, root integration or C05 semantic
result is part of S01.

Pinned `LeanInfoTheory.Probability.Finite` supplies the mass sums and PMF
infrastructure. Existing mathlib min, truncated-subtraction, finite-sum and
real-conversion lemmas supply the remaining arithmetic. The planning search
and API probes retain their original provenance; fresh implementation builds
and consumers are separate checks. No new discoverability issue or upstream
proposal is inferred from routine theorem lookup.

### Public surface and consumers

The foundation exposes seventeen declarations: the two definitions; overlap
symmetry, bound, finiteness and real conversion; one exact residual-sum
theorem; the three TV formulas; TV symmetry, nonnegativity, upper bound and
zero/one characterizations; and the pointwise-zero/disjoint-support overlap
characterizations. These belong to namespace
`PerfectFunctionalRepresentations` and are exported by module
`PerfectFunctionalRepresentations.Probability.FiniteCoupling`.

The complementary-mass bound, finiteness and addition identity use existing
arithmetic directly. Reversing the residual-sum and positive-part theorems
provides their second orientations. Anonymous regression consumers check
those uses, the real-minimum formula and the combined disjoint-support
endpoint without adding public aliases. R01-R04 also retain the literal
half-L1 calculations, exact partial-overlap masses, singleton equality and
empty-alphabet impossibility. The two numerical fixture definitions are
private to the regression module.

### Validation and review

The maintained probability module compiled with 2497 jobs. Its first pass
reported a deprecated minimum-zero lemma; the namespace-free replacement
compiled without warnings in the subsequent focused build. The final
regression build passed 2498 jobs without warnings, covering R01-R04 and all
generic complementary/reversed consumers. The full default build passed
2760 jobs. That default target does not import the separate C04 regressions;
later fixture-only edits leave its root/import closure unchanged.

All seventeen public signatures and axiom lists were printed by an actual
Lean probe: only `[Fintype beta]`, the arbitrary universe and supplied laws
appear as public parameters; all lists contain only `propext`,
`Classical.choice` and `Quot.sound`. Subsequent edits touched private
regression proofs, not those public proof sources. The source/hygiene audit
checks exact B attribution, the normative plan, imports, pins, placeholders,
file links, generated artifacts and final diff for the review handoff.
At the handoff, independent review, original-report reconciliation, final
source validation and supported S01 closure remained subsequent duties.

The first complete source-audit attempt failed the required lexical scan
because a regression comment contained the English word `admit`. That
comment was corrected and a subsequent complete audit passed; the original
attempt remains negative evidence. Two maintained regression attempts failed:
the first needed explicit numeric `Fin 3` coordinates, and the second needed
explicit finite real conversion for overlap and a truncated-subtraction
ordering. Their original outputs, including compiler recovery warnings, are
retained as failures. No proof placeholder was added to maintained source.
The final successful check uses private exact fixtures and explicit side
conditions. Initial scratch attempts stopped after long waits without
diagnostics are incomplete checks; the later scratch prototype pass is
attributed separately and does not replace maintained validation. Concurrent
local builds were observed, but the precise cause of the delays was not
established.

### Independent review and finalization

The existing bound reviewer returned request
`pfr-review:PFR-C04:execution:s01-20260912-r1`, attempt 1, against R
`ef9fcc6bfaee55e320c9aa8f800c842717a3c9b70a80c3377da39a67382c825f`.
All three criteria, C04-S01-C01 through C04-S01-C03, are `SATISFIED`, with no
findings. The complete original report has SHA-256
`79878696be8c084a9a7f52c0364e8fc816a8c3b3c9be219e6fb0b0440f61ea84`
and durable capture
`6702f769999164091a7b836fce3822a32e7b558c6a089cc1701106f4638b9dd6`.
The parent preserved its exact saved bytes after observing and comparing the
complete native report. The original empty submission remains `UNCERTAIN`;
separate report-backed delivery confirmation, a `VALID` receipt and explicit
reconciliation are retained in the execution records.

Fresh reviewer focused and full builds passed 2498 and 2760 jobs without
warnings. Independent source review covers the full mathematical contract,
all seventeen public declarations, R01-R04, exact manuscript normalization,
ownership and support/finite-conversion boundaries. All 87 real inventory
files and seven supplements matched at entry and exit; both pins stayed
clean. An import-header audit recorded 2,481 files and only
`LeanInfoTheory.Probability.Finite` from LeanInfoTheory in the new production
closure. This is a header traversal, not proof review of every dependency;
core `Init`/`Lean`/`Std` internals were not traversed.

The reviewer's optional fresh signature/axiom probe and four extra scratch
consumers were stopped without output and returned exit -1. That observation
remains `FAIL` and supports no satisfied criterion; no result is claimed for
those extra consumers. As expressly allowed by the request, the reviewer
instead inspected the actual signatures/proofs and freshly checked all
seventeen names/axiom lists and unchanged production/configuration hashes
against the original successful parent probe. That compiler run remains
attributed to the parent. The independent applicability assessment and fresh
maintained builds support its use; no theorem-assessment gap is overridden.

The parent agrees with the three assessments because the exact statements,
finite arithmetic, support endpoints and regression obligations match the
approved contract. No Lean correction or plan-contract change is warranted.
The original report, failed/stopped checks and reasoned parent assessment are
preserved separately. Private/native provenance remains cooperatively
checked, not authenticated; effective reviewer settings remain unknown.

Finalization updates only the eight owning Markdown documents. Fresh final
source, B/R attribution, link/hygiene and actual-build applicability checks
precede F capture and supported S01 closure in the durable execution store.
These later records determine durable completion; this preclosure document
records validation readiness and is left unchanged after F. All Lean,
regression, import, configuration, pin and normative-plan bytes remain as
reviewed. S02-S06 and C05 remain unstarted.

## S02 - couplings, mismatch and universal bounds

**Status:** Durably complete; closure and exact source applicability verified at
S03 startup. The preclosure chronology below is preserved as history.

The lead's fresh 2026-09-12 request was: "Continue with step 2 with review
process if step 1 with its review process is completed". S01's actual closure
`4cc08f04a654fb66a04bacf756ddd619c5f7f3d50a5977ab46d6d54c35b4b9da`,
original report and reconciliation were checked. All 88 captured entries
(87 real files and derived environment) and seven supplemental pinned files
still matched S01 F `78918f886433cb8a8961b344cd49f7aaaafbfb37fac1938d126d27ff51ddf29d`.
The condition was satisfied and the installed intake accepted S02 at B
`3a166527d753fed78829139e9facaefaf980444d129bca89f04d4adc3f958ce6`.

An earlier parent call mistakenly passed a step identifier as the optional
journal-revision argument. That request was consumed without starting S02;
its failure records remain unchanged. Subsequent S03-S06 conditional requests
were unmet and are not queued. This fresh actual request uses the supported
call without that argument; it starts only S02. Private records are under
`.pfr-review/setup/c04-s02-20260912-fresh/`. At startup, the existing reviewer confirmed availability under the same
binding; its subsequent source-bound review is recorded below.

S02 implements approved Section 3.2: the plain-PMF coupling predicate, exact
mismatch/event/diagonal identities and range, and the universal exact/Real
lower bounds. A separate module identifies Real mismatch with the existing
`decodingErrorProbability g id` API. R05-R06 cover the diagonal pushforward
and the strictly nonmaximal independent fair two-point coupling. The core
uses the existing marginals and atom bounds from `Shannon.InfoMeasures`;
Fano is imported only by the compatibility bridge. No new Real probability
definition is planned. Root integration, attainment and later C04/C05 work
remain outside this step. Normative plan and dependency pins are unchanged.

Both manuscript SHA-256 identities were reverified and the same-binary
rendered ISIT p.2 and extended-version-16 p.14 re-inspected. The universal
argument is extended (157)-(161), supplementing ISIT Equation (9). The
attainment sentence and neighboring entropy/representation claims retain
their approved later ownership. No source reinterpretation is needed.

### S02 implementation and initial validation

The core adds sixteen public declarations (thirty-three total); the optional
`Probability/FiniteCouplingDecoding.lean` adds two, for thirty-five across both.
`IsCoupling` is only the two existing marginal equalities, with no finiteness
premise. The pointwise diagonal bound needs only `[Finite beta]`; enumerated
mismatch, overlap and Real results use `[Fintype beta]`. No public `Inhabited`,
`Nonempty`, `DecidableEq`, full-support or independence assumption was added.
The existing seventeen S01 proof bodies and R01-R04 fixtures are preserved.

The exact mismatch sum equals the existing outer-measure event, complements
diagonal agreement, is at most one and is finite. Its Real finite sum,
decomposition, complement and range are explicit. Existing marginal atom
bounds give the pointwise minimum and summed overlap bounds; truncated
subtraction and finite `toReal` monotonicity give the universal mismatch bound.
The separate bridge handles the reversed coordinate test in the existing
identity-decoder sum API and exposes its coupling lower-bound corollary.
Only a diagonal-indicator helper is private in production; no bundled joint
law, parallel marginal construction or new Real probability is introduced.

R05 proves both marginals for an arbitrary finite diagonal pushforward,
exact agreement one/mismatch zero, and independently computes the unequal
coordinate event's empty preimage. The separate bridge regression calculates
zero using the existing decoder sum API. R06 reuses supported `indepProd` for
the same fair `Fin 2` marginals: exact and Real mismatch are `1/2`, finite TV
is zero, and the universal inequality is strict. The bridge independently
computes decoder error `1/2` and consumes existing generic range results.
Fixtures remain private and tests separately importable.

Actual parent validation on the maintained bytes passed without warnings:
all four focused production/regression targets together (2759 jobs), the full
`lake build` (2760 jobs), and `#check`/`#print axioms` for all thirty-five
public declarations. Each uses only `propext`, `Classical.choice` and
`Quot.sound`. Every recorded build/probe has matching maintained Lean and
configuration hashes before and after. The earlier direct two-production
build also passed (2757 jobs); it had no before/after hash wrapper and is not
substituted for the later recorded validation.

The parent's dependency bridge probe and helpers' core/fixture probes passed,
but are development evidence only. The core's first probe and the first two
fixture probes failed elaboration; actual inputs/results remain preserved.
Repairs localized classical equality and finite-sum simplification, including
`id_eq` for diagonal maps and narrow normalization of the fair law. A fixture
wrapper's Unicode-display error occurred after its failed Lean result was
saved; that tooling error also remains recorded. No failed or incomplete
probe supports a satisfied criterion. Current maintained validation is a
separate successful observation.

Supported pinned `Shannon.InfoMeasures` supplies marginals and atom bounds;
`Shannon.Fano` supplies decoding error, its finite sum and range; tests
explicitly import supported `Shannon.SemanticBridge.Product`. The core has
no Fano/KL dependency, and the unchanged root gains neither bridge nor Fano.
The root's prior semantic KL dependency remains. This step does not construct
a maximal coupling, settle C05 or start root integration. All eight owning
documents were updated for the initial review handoff; the resulting source,
import and hygiene audits passed.


The source audit initially failed its preserved-regression substring check
because a Windows write changed test line endings from LF to CRLF. The actual
S01 fixture text was unchanged. The initial diagnostic wrongly attributed
CRLF to B; the corrected byte inspection, original failure and revised audit
are retained. Owned files now preserve B's LF convention, and the subsequent
checks use those exact bytes. This is tooling evidence, not a Lean proof defect.
A helper's static PFR/LeanInfoTheory import traversal confirms the stated core,
bridge and root boundaries and supported public modules. Its mathlib frontier
is not a full foundational dependency review; the supplemental source hashes
make that limited scope explicit. Parent source/hygiene checks remain separate.


### S02 contextual review, independent assessment and finalization

The parent retained the contextual critique before a separate reassessment.
Neither found a justified mathematical/API change after initial validation.
The existing bound reviewer assessed request
`pfr-review:PFR-C04:execution:s02-20260912-fresh-r1`, attempt 1, at R
`9f1ab8839893aacf65f3263839a120af99316f49bbd9347b41d8e1278fe4e929`.
All three S02 criteria are `SATISFIED`, with no findings.
The complete original report SHA-256 is
`7660f4f99e84021d2cd6fcfedcfadc2a22ba8b50a0453ad21b296fe7ce1a460c`;
its durable capture is
`f43a6d3b893ec7a522f628756fab70b0353356e661ea4c147c5ebbac66a76c07`.
The original empty native submission remains
`UNCERTAIN`; separate report-backed confirmation, valid receipt and explicit
reconciliation are retained without rewriting that observation.

Fresh reviewer four-target and full builds passed (2759 and 2760 jobs) without
warnings. Six additional core boundary consumers passed: unconditionally
coupling a joint law with its own marginals, the `Finite` pointwise bound,
the event-facing universal bound, singleton zero mismatch, empty-product PMF
impossibility and diagonal-sum finiteness. One unused-simp warning belongs
only to that scratch probe and remains disclosed.

The reviewer independently inspected all thirty-five public signatures and
proofs, and verified applicability of the supplied original parent signature/
axiom probe by matching all names, output lists and production/configuration
hashes. All axiom lists use only the standard three axioms. That Lean run
remains attributed to the parent; no fresh reviewer Trust execution is claimed.
Fresh manuscript hash/page-count and scoped text inspection supplement the
reviewer's earlier visual inspection of the same binaries. The review preserves
the Equation (9), extended (157)-(161), arbitrary-coupling and C05 boundaries.

All 89 real inventory files and sixteen supplements matched at entry/exit.
The corrected static import audit recorded 2,749 source-header files and
185 external toolchain leaves, confirming the core excludes Fano/KL and the
unchanged root gains neither Fano nor the decoding bridge. Those recorded
headers also matched at exit. This is a scoped import audit, not semantic
review of every dependency; external Lean/Init/Std/Lake leaves were not read
recursively. Three prior script attempts failed on toolchain/comment/import
syntax handling; each remains `FAIL` and supports no satisfied criterion.
The fourth successful run is separate evidence. Both dependency pins are clean
and exact. The ordinary builds used Lake's incremental cache.

The parent agrees with all three assessments after checking their statements,
assumptions, fixtures and evidence. No Lean or normative-plan correction is
warranted. The original report and negative checks remain distinct from the
parent's reasoned reconciliation. Final updates clarify current status and the
separate S01/S02 authorizations while retaining historical preclosure records.
Native/private provenance is cooperative, effective reviewer settings remain
unknown, and no remote CI validation is claimed.

Finalization changes only eight owning Markdown documents. Final source,
B/R attribution, links/hygiene and exact build/pin applicability checks precede
F capture and supported S02 closure. This document records validation readiness;
the subsequent private execution record determines durable completion. Included
files stay unchanged after F. All Lean, regression, import, configuration, pin
and normative-plan bytes remain as reviewed. S03-S06 and C05 remain unstarted.


## S03 - explicit maximal coupling, attainment and support

**Status:** Durably complete; closure and exact source applicability verified at
S04 startup. The original preclosure chronology below is preserved as history.

The lead's fresh request, "Continue with step 3 with review process if step 2
with its review process is completed", was accepted after verifying S02's
original report/reconciliation and durable closure
`60bc2b75f7deae46c0e35bd0bd1f00d7f9bd4f73ba64ea922ff1d7862e2b36ce`.
All 90 captured entries (89 real files and derived environment) and sixteen
supplemental pinned files still matched S02 F
`c988a9fd265af09edd4e7e6718339e7e68cc35184fe3c007e84e93d20f3240b9`.
S03 B is `fcd196587b992f9a3ea0e44bbcafc39230cd5d90ca28466bb72aaeb263aa9d4f`. The earlier unmet
conditional S03 request stays consumed; this is a fresh actual request after
S02 completion. S04-S06 remain unstarted. Private execution records are under
`.pfr-review/setup/c04-s03-20260912-fresh/`.

Approved Section 3.3 requires the explicit normalized product PMF, complete
atom formula, marginal/diagonal/mismatch/attainment guarantees, endpoint and
support consequences, the decoder-facing attainment, and R07-R10 including
both R09 fixtures. The construction uses diagonal minimum mass plus the
product of residual masses divided by their single common total. Existing
ENNReal cancellation may handle the zero-total case uniformly, retaining its
explicit vanishing obligations without a selected atom or normalized zero-mass
PMF. Private proof organization is adaptable; no acceptance criterion changes.

Both manuscript hashes were reverified. The same-binary extended p.12
(111)-(122) and p.14 (156)-(161) with its attainment sentence were visually
re-inspected. The general atom formula supplies a detailed proof of the
extended attainment assertion; it is not a displayed general manuscript
formula. The p.12 specialized common/exclusive construction is context for
endpoint/fiber behavior; its representation/entropy proof remains C05.
At the startup checkpoint, the same bound reviewer confirmed availability
and awaited the exact S03 request; no source acceptance was claimed then.


### S03 implementation and initial validation

The core adds eleven public declarations: `maximalCoupling`, its all-atom and
marginal contracts, exact diagonal/summed-diagonal/mismatch identities, Real
attainment, a minimum-attaining existential corollary, off-diagonal support,
the identical-law diagonal endpoint and zero-overlap independent endpoint.
The separate decoding bridge adds `decodingErrorProbability_maximalCoupling`.
All thirty-five prior public declarations and R01-R06 remain unchanged.

Four private declarations hold residual bounds, raw weights, row summation
and raw-weight symmetry. Residual mass is bounded by its total. The pinned
`ENNReal.mul_div_cancel_right'` explicitly discharges zero-total vanishing and
the impossible infinite-total case. This proves row normalization uniformly
without a case-selected PMF, a default atom or a normalized zero distribution.
The column proof only uses private raw-weight symmetry; public swap/relabeling
remains S04. Diagonal residual products vanish pointwise. No hypothesis is
weakened and no acceptance criterion or normative plan text changes.

Anonymous general consumers establish zero denominator implies equal laws
and the diagonal law, strict excess implies a positive denominator, equal-mass
fiber saturation, positive diagonal mass and marginal-support containment.
The latter reuses the pinned marginal zero/nonzero lemmas. R07-R10 include
arbitrary identical/disjoint laws, distinct pure laws with unused labels,
singleton/empty boundaries and both complete R09 matrices. The Fin4 fixture
checks the four unequal residual products, normalization, both marginals,
overlap 5/8 and mismatch/TV 3/8; the Fin3 fixture retains the original zero row.

Actual parent four-target and full builds and all forty-seven public signature/
axiom checks passed without warnings. Only standard `propext`, `Classical.choice`
and `Quot.sound` are used. Development failures are preserved separately from
passing checks, with helper API/fixture work attributed as development evidence.
Core imports add only supported `SemanticBridge.Product`, as approved for the
independent endpoint. Tests additionally use `Mathlib.Tactic.FinCases`.
The core remains free of Fano/LeanInfoTheory KL; the root is unchanged and the
decoder bridge remains optional. Detailed source/import/build records are
private execution evidence; they do not claim a full semantic dependency audit.

The general atom formula is the explicit proof of the extended attainment
sentence after (161), supplemented by the common/exclusive presentation at
(115)-(122). The manuscript identities and scope boundaries above remain
current. OM-060/OM-061 reflect the implemented probability content while C05
retains representation/entropy and specialized-construction interpretation.
No discoverability issue or new Future Work Note is warranted by routine API
reuse. Contextual critique, separate reassessment and independent review are
subsequent duties at this checkpoint; builds alone do not close S03.


### S03 independent review and finalization

The contextual critique and separate reassessment retained the implementation
without a mathematical/API change. Independent S03 review at R
`f56b5cc26dd3bed050350d00238f6ed197f703ff480cc2b472587a383098328b` satisfies C04-S03-C01, C04-S03-C02 and C04-S03-C03
with no findings. The complete original report (SHA-256
`f70add4534a40a331f80271ea0657ac98341b31774c8e851811d1d2527ce8ca7`) was captured and explicitly reconciled.
The original empty native submission remains `UNCERTAIN`; a separate
report-backed delivery confirmation preserves that observation unchanged.

Fresh reviewer four-target and full builds passed (2759 and 2760 jobs)
without warnings. Six additional core-only Lean consumers passed without
warnings: TV-zero diagonal law, TV-one independent endpoint, both vanishing
residual functions at zero total, exact ENNReal minimality, both full fibers
at a common-zero label and existence/attainment on `ULift.{v} beta`. The
reviewer also independently recomputed both complete rational matrices.

All forty-seven production signatures and proofs were independently inspected.
The reviewer matched the original parent signature/axiom output and its source/
configuration hashes; all lists contain only the standard three axioms. That
compiler run remains attributed to the parent, not a fresh reviewer Trust run.
Fresh manuscript hashes/page counts and scoped text inspection supplement the
reviewer's earlier visual inspection of the same binaries. The original R09
planning suggestion is addressed by the four unequal residual products.

All 106 unique inventory/supplemental files matched at entry and exit (the
89 real inventory entries and eighteen supplements share ENNReal/Inv.lean).
The reviewer recorded and rechecked 2,749 import-header files and 185 external
toolchain leaves, confirming the core excludes Fano/KL and the unchanged root
gains neither C04 nor Fano. This is an import-header audit, not semantic review
of every dependency; external toolchain leaves were not recursively read.
Pins remain clean and exact. Builds used normal incremental Lake caching.
All current reviewer checks passed; earlier stopped/failed S01/S02 observations
remain historical negative evidence.

The parent agrees after inspecting the original criterion evidence, source
contracts and limitations; the reasoned reconciliation is distinct from the
reviewer's original report. No Lean or normative-plan correction is warranted.
All development failures and wrapper diagnoses remain retained as negative
observations. Native/private provenance is cooperative, effective reviewer
settings remain unknown, and no remote CI is claimed.

Finalization updates only the eight owning Markdown documents. The living
coverage row now distinguishes implemented Equation (9)/coupling probability
content from C05's semantic Lemma 3 target. Other changes normalize actual
S03 review/reconciliation and preserve historical S01/S02 preclosure records.
Final B/R/source/links/hygiene and exact build/pin applicability checks precede
F capture and supported S03 closure. This document records validation readiness;
the subsequent private execution record determines durable completion. All
Lean/test/import/configuration, pins and normative-plan bytes stay as reviewed.
Included files remain unchanged after F. S04-S06 and C05 are unstarted.


## S04 - relabeling, swap and C05 probability handoff

**Status:** Independently validated and original report reconciled; validation ready, durable closure subsequent.

The fresh actual request, "Continue with step 4 with review process if step 3
with its review process is completed", was accepted after verifying S03's
original report, explicit reconciliation and durable closure
`0137e13eb929699635fa4e89b4cb3e2460bf2314e66bdfebe5badd9ee3b8b8da`.
All 90 captured entries and eighteen supplemental entries still matched S03 F
`c4c7c3580703092957d0e28c3736a24bcf0d51801ddb5271715604647b9cf62e`.
The lists cover 106 unique real files plus derived environment metadata.
S04 B is `519b6384591b84bd9dfa8a3bbeecb8dea7e5fe6bc4e8babb1f5bcd50c22c5882`. Earlier unmet conditional
requests stay consumed; this actual message authorizes only S04. S03's original
preclosure chronology above remains historical. S05-S06 stay unstarted.
Private execution records are under `.pfr-review/setup/c04-s04-20260912-fresh/`.

Approved Section 3.4 requires simultaneous injective relabeling of coupling,
overlap, TV and exact/Real mismatch, transported attainment, coordinate swap,
R11-R14 and a precise C05 handoff. Target universes may differ. The same finite
subtype is used for both laws; no support-containment or restriction framework
is introduced. The chosen maximal constructors need not be equal after map.
These are representation bridges for the approved probability contracts, not
additional displayed manuscript claims or C05 semantic implementation.
At startup, the existing bound reviewer confirmed availability and awaited the
exact S04 request; no independent acceptance was claimed at that checkpoint.


### S04 implementation and initial validation

Seven public core theorems add simultaneous map/swap of the bare coupling
predicate, injective overlap/TV and exact-mismatch invariance, swap mismatch
invariance and transported maximal-coupling attainment. Coupling map/swap need
no finiteness or injectivity; the quantitative contracts expose finite source
and target alphabets in independent universes. No new definition, private core
helper, import or production decoder theorem is necessary. Real mismatch is
a direct rewrite of exact mismatch. Equivalence and common-subtype inclusion
are consumers of the same injection theorem; the transported witness is
sufficient without proving equality of chosen maximal constructions.

Overlap uses the pinned finite-sum injection theorem: image masses are unchanged
and off-image mass is zero. Mismatch uses the existing outer-measure pushforward
identity and injectivity of equality; swap uses symmetry of inequality. Existing
marginal map/swap theorems prove coupling transport. The two map-mass lemmas
(`PMF.map_apply_of_injective`, `PMF.map_apply_eq_zero_of_notMem_range`) and four
marginal map/swap lemmas are supported LeanInfoTheory APIs. The finite-sum,
map-composition and outer-measure event-preimage operations come from pinned
mathlib. No generic probability theorem is reproved
and no discoverability problem warrants a new entry.

R11-R14 exercise equivalences, Fin2-to-Fin3 unused-label inclusion, a ULift target
universe, the same finite subtype carrying both laws, both mapped marginals and
zero unused-label fibers, constant-map TV one-to-zero, and all nine R14 atoms.
The R14 witness has only (0,0)=1/4 and (1,2)=3/4; its marginals and exact/Real
mismatch 3/4 are checked. Supported pairs meeting an equal-mass label coincide;
common-zero labels leave both entire fibers empty. Anonymous decoder consumers
check mapped error invariance/attainment and swap using the existing bridge.

Actual parent four-target/full builds and all 54 public signature/axiom checks
passed without warnings. Every axiom list uses only propext, Classical.choice
and Quot.sound. All 47 prior public proofs and R01-R10 bodies are retained.
The production decoder bridge, root, all production imports, pins and normative
plan are unchanged. Failed development attempts remain separate negative
observations. Helper source/API and fixture checks are attributed development
evidence, not independent acceptance. Source/link/placeholder/Git/artifact and
import-applicability checks are retained in private execution records.

Both manuscript hashes were freshly verified against the approved identities.
Scoped reading of the existing same-binary extended p.14 (156)-(161) and p.12
common/exclusive context preserves the earlier mathematical interpretation.
Relabeling/swap are representation bridges for this probability content; no
new displayed manuscript formula or semantic theorem is claimed. OM-059–062
retain their dispositions. No new omission, numbered Future Work Note or
normative-plan revision is needed. Contextual critique, separate reassessment
and independent review are subsequent duties at this checkpoint.

### C05 probability handoff

Import `PerfectFunctionalRepresentations.Probability.FiniteCoupling` directly
or use the mathematical root `PerfectFunctionalRepresentations` for the
following current core contracts (S05 integration). The table selects C05-facing contracts
from the 54 project declarations in namespace `PerfectFunctionalRepresentations`.
The four pinned support lemmas listed separately below are dependency APIs and
are not included in that project count. The root exports the 51 core declarations;
the three decoder declarations still require the separate bridge import.
Finite quantitative results use `[Fintype beta]`; injection results allow
`gamma : Type v` with its own `[Fintype gamma]` and arbitrary unused labels.

| Available contract | Exact C05 use and boundary |
| --- | --- |
| `IsCoupling p q g`; `isCoupling_maximalCoupling p q` | A law on `beta × beta` with the existing first/second marginals equal to p/q; no bundled optimizer or full-support premise. |
| `finiteTV`, `overlapMass`; `finiteTV_eq_one_sub_overlap_toReal`, `finiteTV_eq_sub_overlap_toReal`, `sum_sub_min_eq_one_sub_overlapMass` | Half-L1 Real TV, exact minimum mass and each residual total; the complement has exact ENNReal and finite Real formulations. |
| `IsCoupling.sub_overlapMass_le_mismatchMass`, `IsCoupling.finiteTV_le_mismatchMass_toReal` | Universal exact/Real lower bounds for every coupling, without an independence premise. |
| `mismatchMass`, `mismatchMass_eq_toOuterMeasure`, `mismatchMass_toReal` | Exact mass of the unequal-coordinate event and its finite Real sum. |
| `maximalCoupling_apply`, `maximalCoupling_apply_diag`, `sum_maximalCoupling_diag` | Every atom equals diagonal minimum plus the residual product divided once by 1-overlap. Diagonal mass is exactly the minimum; total agreement is overlap. Zero residual is covered. |
| `mismatchMass_maximalCoupling`, `mismatchMass_maximalCoupling_toReal`, `exists_coupling_minimizing_mismatch` | The specified law attains exact complementary overlap and Real TV; the existential corollary includes comparison with every coupling. |
| `maximalCoupling_apply_pos_iff_of_ne` | At y≠z, positive mass iff q y<p y and p z<q z. Equal-mass fibers therefore have no off-diagonal support; `maximalCoupling_apply_diag` supplies their common mass. Generic consumers cover common zero. |
| `maximalCoupling_self`, `maximalCoupling_eq_indepProd_of_overlapMass_eq_zero`; `finiteTV_eq_zero_iff`, `finiteTV_eq_one_iff`, `overlapMass_eq_zero_iff_disjoint` | Diagonal identical-law and independent disjoint-law endpoints, including unused labels; no normalized zero-mass PMF. |
| `IsCoupling.map`, `overlapMass_map_injective`, `finiteTV_map_injective`, `mismatchMass_map_injective`, `isCoupling_map_maximalCoupling_attains` | Simultaneously map both coordinates through the same injection. Preserve both marginals, exact/Real quantities and a concrete attaining witness. Equivalence/ULift/common finite subtype inclusion need no extra framework or surjectivity. |
| `IsCoupling.swap`, `mismatchMass_map_swap`, `finiteTV_comm` | Swap reverses marginals and preserves exact/Real mismatch; a witness also attains the reversed-law TV. No row-order choice enters the bound. |

For decoder-facing Real results, separately import
`PerfectFunctionalRepresentations.Probability.FiniteCouplingDecoding` and use
`mismatchMass_toReal_eq_decodingErrorProbability`,
`IsCoupling.finiteTV_le_decodingErrorProbability` and
`decodingErrorProbability_maximalCoupling`. The decoder is `id`; S04's anonymous
bridge consumers show transport and swap. This optional import reaches Fano;
the probability core does not. For zero fibers and marginal-support containment,
the pinned namespace `LeanInfoTheory.Shannon` supplies
`apply_eq_zero_of_fstMarginal_eq_zero`, `apply_eq_zero_of_sndMarginal_eq_zero`,
`fstMarginal_ne_zero_of_apply_ne_zero` and `sndMarginal_ne_zero_of_apply_ne_zero`.

C05 still owns the equivalence between this product and a two-coordinate
function vector, canonical functional-representation construction, singular
channel consequences, conditional entropy and information optimization, and
input-prior/support hypotheses. Neither support must contain the other; R12
starts with both laws on one common finite subtype and does not construct a
restriction of ambient laws. The listed contracts authorize no C05 step.


### S04 independent review and finalization

The contextual critique and separate reassessment retained the implementation.
Independent S04 review at R
`85852a1854a30aabc315f073a59ae9f76ae363b490d8a651c605c3e51b76c6f5` satisfies C04-S04-C01, C04-S04-C02 and C04-S04-C03
with no findings. The complete original report (SHA-256
`02f14221a85618ce45a2ea81b13c44821583a60168e835353e9021dbfb835ce7`) was captured and explicitly reconciled.
The original native delivery observation and complete report provenance were
retained.

Fresh reviewer four-target and full builds passed (2759/2760 jobs), followed by a five-consumer core probe without diagnostics. The probe checks unrestricted coupling map/swap, unused ambient marginal zeros, exact transported attainment, transported equal-mass support and constant-map zero mismatch. The reviewer independently inspected all 54 public signatures/proofs and verified applicability of the original parent axiom output; no new reviewer execution of that axiom command is claimed. All 89 real inventory entries and eighteen supplemental entries (106 unique files), clean pins and 21 separately audited import headers matched at entry and exit. Scoped manuscript, rational-fixture, handoff, omission, link and artifact checks passed.

During reconciliation the parent also clarified API ownership in the reuse paragraph: the two map-mass lemmas and four marginal transport lemmas belong to supported LeanInfoTheory, while finite-sum, map-composition and event-preimage operations come from mathlib. This bounded attribution clarification changes no mathematical or C05 contract. The original independent report and earlier contextual critique remain unchanged.

The parent's reasoned assessment agrees with the original criterion evidence,
mathematical contracts and stated limits; it is distinct from the original
review report. No Lean or normative-plan correction is warranted. All failed
or interrupted development observations remain retained and support no passing
criterion. Native/private provenance is cooperative, effective reviewer
settings remain unknown, and no remote CI is claimed.

Finalization changes only the eight owning Markdown documents. Final source,
B/R attribution, links, hygiene, pins and exact applicability of actual compiler
evidence are checked before F and supported S04 closure. This document records
validation readiness; the subsequent private execution record establishes
durable completion. All Lean/test/import/configuration/pinned and normative
plan bytes remain as reviewed. No included file is edited after F. S05-S06 and
C05 remain unstarted.


## S05 - root integration and internal readiness

**Status:** S05 durably complete; original report/reconciliation and exact F source applicability verified before S06.

The actual fresh request, "Continue with step 5 with review process if step 4
with its review process is completed", was accepted after verifying S04's
complete original report, explicit reconciliation and durable closure
`ddca30b7b62b58b3c5fa4e33cc0c073fb4bd896c9560384395c3260e793658ae`.
All 90 captured entries and eighteen supplemental entries matched S04 F
`1a72e6378fda13103ebae0ee94083317e8d1142ac567aa586358c26a88123c2b`.
S05 B is `4b8cc89633997b93f2c3a3515118a40450f639047d6d117d22184e7db47a8cfb`. The baseline contains inherited
dirty/untracked work; cumulative differences from HEAD are not S05 attribution.
Earlier chronological status paragraphs remain historical. This request starts
only S05; S06 and C05 remain unstarted. Private records are under
`.pfr-review/setup/c04-s05-20260912-fresh/`.

The root now imports the focused probability core and documents that surface.
One separate root-only regression module checks the universal bound, explicit
witness with both marginals and Real attainment, comparison with every coupling,
and injective transport across independent universes. The existing bridge tests
already consume the same bound and attainment through decoder error; they are
reused unchanged for R15. No production theorem, earlier test, pin or normative
contract changes. The [readiness audit](pfr-c04-readiness-audit.md) is the single
current mapping of all earlier criteria, R01-R15 and the eight closeout outcomes.
It prepares S06's fresh cumulative review and does not replace it.

### S05 initial validation

Fresh root-only, all-seven-regression aggregate and full builds passed without
diagnostics. All 54 public signature/axiom checks passed with only the standard
`propext`, `Classical.choice` and `Quot.sound` dependencies. Fourteen fresh static
import checks and source/manuscript/placeholder/link/Git/artifact audits pass.
The current [readiness audit](pfr-c04-readiness-audit.md#s05-validation-and-review-historical-checkpoint)
records the exact command coverage and limits. Auxiliary source mappings are
attributed development evidence. All production proofs and earlier test bodies
retain exact S04 F/B bytes; the eleven changed files are the root, new root test
and nine Markdown owners. No normative-plan or omission revision is needed.
Self-review/reassessment and independent review remain subsequent duties.


### S05 independent review and finalization

The contextual critique and separate reassessment retained the minimal root
integration and root-only consumer. Independent review at R
`86b3ae4d14138001019a5933154720fb100e2335875c5c041afc1293d0422c9e` satisfies all three S05 criteria with no findings.
The complete original report (SHA-256 `6185ad952b7ec1a8a573047add1b7add75d2c59a2a3837f9101eaf387524a8f9`)
was preserved byte-for-byte with observed native provenance and explicitly
reconciled. The original empty submission remains UNCERTAIN; a separate
report-backed confirmation records delivery without rewriting that receipt.

Fresh reviewer seven-regression and default builds passed (2773/2761 jobs) without diagnostics. The reviewer inspected all 54 public signatures/proofs and verified applicability of the original successful parent axiom output; no new reviewer Trust execution is claimed. It independently checked R01-R15 and the readiness allocations, all 34 exact atoms across the three required matrices, both manuscript hashes/page counts and scoped text, 22 import headers and 41 targeted file links. All 91 real inventory entries and eighteen supplemental entries (108 unique files), inspected headers and clean pinned dependencies matched at entry and exit.

The original reviewer source-parser assertion remains FAIL: it initially counted a namespace label in prose as a declaration. A separate corrected parser passed at entry and final. The combined shell returned zero after later Git commands; the failing Python component's exit code was not separately captured and is not invented. This failure supports no satisfied criterion. Historical failed/stopped observations also remain negative, distinct from current successful checks.

The parent's reasoned reconciliation agrees with the original criteria and
their actual evidence; it is separate from the independent report. No Lean or
normative-plan correction is needed. Native/private provenance and read-only behavior are cooperative, effective reviewer settings remain unknown, and private B/closure records were not independently authenticated by the reviewer. Import traversal is bounded with foundational leaves; file-link checks do not certify every Markdown anchor. Reviewer rational arithmetic is corroborative and its JSON preserves results rather than the full stdin program. Fresh manuscript hashes/page counts/text are distinguished from earlier same-binary visual evidence. Builds are normal local incremental executions, with no clean-room or remote CI claim; S06 cumulative acceptance is not supplied.

Finalization updates only nine Markdown owners before final source validation
and F. All Lean, earlier regressions, imports, configuration, pinned dependencies
and normative-plan bytes remain as reviewed. Fresh final B/R/source/link/hygiene
and compiler-applicability checks precede supported closure; no compiler rerun
is invented for these documentation-only changes. No included source is edited
after F. This records implementation readiness for S06, not C04 completion;
the subsequent private record establishes durable S05 closure. S06 remains
unstarted. The current [readiness audit](pfr-c04-readiness-audit.md) retains the
complete evidence map and exact C05 probability boundary.


## S06 - fresh cumulative validation and closeout

**Status:** Independently validated and original cumulative report reconciled; final validation ready, durable S06 closure subsequent.

The fresh actual request authorizes S06 after verified S05 closure `3d9da973b8c2139f7885dbee74a74c45d81e4fcea6185aa298c80f859b5d6610`. All 92 captured entries (91 real files plus derived environment metadata) and eighteen supplemental entries matched S05 F; they cover 108 unique real files. S06 B is `a8ea7919da1840a5d30e6f7d186b7188718550b1bdfe266afcf67b50a402ae08`. The approved normative contract and all Lean sources remain unchanged.

S06 refreshes all fifteen earlier criteria, R01-R15, the eight completion outcomes, all 54 public signatures/axioms, actual builds, source/manuscript/import/omission checks and owning documents. The [readiness audit](pfr-c04-readiness-audit.md) retains the exact allocation and current evidence. Independent review is followed by original-report reconciliation, justified corrections, final documentation/validation, F and supported durable closure. Earlier step reviews do not substitute for this pass. The C05 probability handoff above remains exact; C05 canonical/vector, singularity, entropy/information and prior decisions are unchanged.


Fresh S06 parent seven-regression/full builds passed (2773/2761 jobs) without diagnostics, followed by all 54 public signature/axiom checks with only the three standard axioms. Both manuscript binaries, page counts and relevant rendered pages were freshly checked. Current mathematical/source/endpoint/support/transport/omission audits require no Lean or normative-contract repair. The [readiness audit](pfr-c04-readiness-audit.md) owns exact commands and attribution limits, including observed parallel documentation drift in an auxiliary input check. Independent cumulative review and subsequent reconciliation/finalization remain pending.


### S06 independent cumulative review and finalization

The fresh bound-reviewer report individually satisfied all three S06 criteria, fifteen earlier criteria, R01-R15 and eight C04-CC outcomes with no findings. Its complete original was preserved and critically reconciled. No Lean/API or normative-contract change was needed; the exact C05 probability handoff above remains the resulting boundary. Current parent/reviewer builds, all 54 public signature/axiom checks and manuscript/source audits support acceptance with their recorded actors and limits.

See the [cumulative assessment and final applicability](pfr-c04-readiness-audit.md#s06-independent-cumulative-assessment-and-final-applicability) for the exact report identity, evidence, negative observations and outcomes. Only owning Markdown changes after R. Final validation is ready; durable S06/C04 completion is determined by the subsequent supported execution record, with no included edits after F. C05 remains unstarted.
