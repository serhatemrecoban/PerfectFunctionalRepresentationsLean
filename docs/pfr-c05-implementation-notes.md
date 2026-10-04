# PFR-C05 implementation notes

The [approved revision-2 plan](plans/pfr-c05-binary-input-lemma3.md) owns the
mathematical contract. These notes record actual implementation and validation,
with original review records retained privately. C01-C04 prerequisite closure
and source provenance are recorded in the [planning notes](pfr-c05-planning-notes.md).

## S01 - Binary coupling, vector and law boundary

**Authority and baseline (2026-09-13).** The lead accepted revision 2 and
requested "good, start with step 1 with its review process". This authorizes
S01 only. The exact preapproval draft has SHA-256
`b78bb1063ac53de67d3e07e596db0c2d3598d9f5e6eff0175338e48437b60568`.
Only its reserved editorial status block changed before registration; the
registered full-file hash is
`874587a781af5b642f0c96602ebb25b81e686dd2e19f58957653a290c37b326b`.
The installed execution session registers all seven steps and 21 criteria,
consumes the actual native S01 request once, and captures B before maintained
implementation edits: B is
`12a61c6de3023fac16a4aa5cc0508e5f1c7c84f432423e77fcc594e72dc46ddd`.
HEAD remains `54c1714d1a9a891939d6c9f7d38c0d05896b2c75`;
inherited C02-C04 changes are baseline, not S01 work. The same bound reviewer
`/root/pfr_c05_reviewer` is retained. No separate revision-2 plan review is claimed.

**Current phase:** implementation, contextual self-review, separate reassessment,
independent assessment and original-report reconciliation passed. S01 is
validation ready; completion is governed by the subsequent durable execution
closure in `.pfr-review/`, not by this pre-F status statement. S02 is unstarted.

### Contract and source correspondence

`Semantics/Binary.lean` supplies the binary boundary in Section 3.1. The
structural statements retain arbitrary output types and universes. The two
maps induced by `finTwoArrowEquiv` are inverse on complete laws, and their four
marginal identities fix product first/second as vector coordinates 0/1.
Both coupling equivalences preserve every channel row. The full evaluation
triple and its auxiliary product transport agree exactly; C02's channel-joint
theorem then supplies the pair law for every prior, including either point
prior. No inference from an unsupported input row is used.

ISIT p. 2, II-C Equation (10), selects C04's existing `finiteTV` of these rows.
The regression module unfolds the half-L1 definition and consumes C04's
`finiteTV_eq_one_sub_overlap_toReal`; there is no additional public `r` or
normalization theorem. The new enumeration-independence theorem compares any
two `alpha ≃ Fin 2` choices, using a private two-permutation argument and C04
symmetry. It needs `[Fintype beta]`; the equivalences themselves supply the
binary input structure without a redundant input finiteness assumption.
`Fintype.equivFinOfCardEq` is exercised as a consumer of that theorem.

The law boundary corresponds to extended version 16 p. 13 (147)-(148) and
p. 14 (149)-(151). Exact manuscript identities remain those in plan Section 2.
S01 adds no singularity, entropy, optimality, or equality-characterization
theorem. Those later mathematical targets remain pending.

### API reuse and bounded implementation choices

Production imports Canonical, the C04 finite-coupling core and mathlib's
focused finite-equivalence module. Importing Singularity was proposed for the
eventual combined module, but S01 has no consumer of it; that import can be
added when S02 needs it. Root integration remains S06. The optional decoding
bridge and tests are not production imports.

The reused pinned declarations are `PMF.map_comp`, `map_id`, `map_bind`,
the Shannon marginal-map identities, C02's
`IsCanonicalCoupling.fstSndMarginal_canonicalJoint`, mathlib's
`finTwoArrowEquiv` and elementary equivalence/Fin-two facts, and C04's TV
symmetry/overlap identities. The source search found these directly; no
generic information theorem is reimplemented and no discoverability issue
or Future Work Note is opened. There are twelve new public theorems and one
private enumeration helper; no new public definition or bundled abstraction.

### Regression and criterion allocation

| Obligation | Maintained consumer and intended boundary |
| --- | --- |
| C05-S01-C01 / R01 | Arbitrary-output inverse laws, both coupling directions, and nonsymmetric two-atom coupling with masses 1/3 at (0,1), 2/3 at (1,0); both vector and recovered product marginals |
| C05-S01-C02 / R02 | Full-triple evaluation/return maps; pair law under prior (1/3,2/3) and each point prior; all four exact pair atoms; a supplied row PMF rules out empty outputs |
| C05-S01-C02 / R03 | Product swap agrees with swapping vector entries; exact row TV 1/3, C04 half-L1/overlap identity, row reversal, Bool input orientation/reversed enumeration, arbitrary cardinality-two enumeration, empty-input impossibility |
| C05-S01-C03 | Separately importable binary tests, focused/downstream/full builds, public signature/axiom/import and placeholder audit, exact B-to-final ownership and current canonical documentation |

### Validation and evidence limits

The focused Binary/test build passed (2759 jobs), including R01-R03. The default
root build passed (2761 jobs). All twelve public signature/axiom checks passed;
only `propext`, `Classical.choice` and `Quot.sound` occur. The root build does not
yet import Binary; the explicit focused build establishes its separate consumers.
Production source is unchanged since the successful trust audit.

Initial independent helper
probes for enumeration and fixture arithmetic, and the parent's combined bridge
probe, were stopped without diagnostics during shared-machine compiler loading.
Their source is retained privately; each result is interrupted/inconclusive,
not a passing compiler check. Their candidates are integrated into the maintained
module/tests for one consolidated compiler run. No unrelated process was altered.

The first consolidated build completed with three proof errors: two round-trip
simplifications and one theorem-application syntax issue. The remaining new
production declarations compiled. Explicit equivalence composition identities
and the explicit C02 method application replace those failed attempts; the
corrected production module now builds. All twelve public signatures and axiom
reports passed, with only `propext`, `Classical.choice` and `Quot.sound`.
A fresh default `lake build` passed (2761 jobs).
A reconfiguration retry launched just as the
first result arrived was stopped and is not passing evidence. No dependency or
maintained configuration was changed.

The first regression compilation exposed seven test-proof failures: unrestricted
`simp` expands the vector equivalence before the round-trip rule can match;
one marginal simplification needed `id_eq`; and exact PMF arithmetic needed
controlled finite-sum expansion and justified real conversion. The statements
and fixture are retained. Tests now apply the named round-trip theorems, expand
the two-element sum before simplification, and use finite `ENNReal.toReal`
injectivity for the four pair atoms. A subsequent test pass also required
explicit reduction of the two `Fin.rev` values; the corrected aggregate now
passes. Every earlier diagnostic remains preserved and does not support acceptance.

The initial source audit confirms twelve public theorems, one private helper,
three focused production imports, no placeholders, unchanged normative plan,
all 67 omission IDs and valid local document links. DG-04/DG-05 resolution leaves
ten open or partially open map gates. All baseline files outside the seven current
status documents (including the plan's editorial block) match B; the two binary
Lean modules and these notes are new.

### Contextual critique and independent reconciliation

The contextual self-review found no material gap. Its one optional suggestion,
`C05-S01-SELF-01`, was a direct reversed-Bool coordinate assertion. Separate
reassessment declined it: natural Bool orientation and the generic product/vector
swap already check the nonsymmetric laws before TV symmetry is used. The extra
assertion would repeat those reductions. A later input/prior transport may merit
its own consumer; no S01 outcome is deferred.

The same bound reviewer returned its complete original report for R
`52ab5b19f29f8a90a05b828d4d3b0518f156c5e0ea5d9b02c6dc5925c85a5788`.
The native report was preserved before classification and confirmed delivery
of the initially uncertain native submission. The installed receiver classified
it `VALID`, capture
`ae6e629e46997bbc14d7aab18f9e167f6232c456d62df82664f0eded35bd2487`.
All three criteria are satisfied; no material or optional source finding was
raised. The original assessment is retained without rewriting its evidence.

Fresh independent focused/downstream and default builds passed (2765 and
2761 jobs). A corrected reviewer-owned probe passed five additional consumers,
including infinite Nat outputs and distinct pure rows, all twelve signatures
and axiom reports, and two printed proof terms. Manuscript hashes and the
specified rendered anchors were freshly checked. The import audit confirms
three direct production imports and no new LeanInfoTheory module relative to
the existing root. The root's inherited KL dependency remains; standard
toolchain module internals were not traversed.

The reviewer's first unresponsive probe is inconclusive. Its original consumer
proof errors and two import-parser attempts are separately retained as failed
verification attempts. Explicit existing lemmas corrected the scratch proofs;
comment-aware import-header parsing corrected the inventory. No maintained
statement, proof or criterion changed, and none of those failed attempts
supports a satisfied criterion.

The implementer explicitly reconciled the report against the actual laws,
regressions and hypotheses. The complete-law and arbitrary-prior conclusions
match the source; the C04 scalar reuse and focused imports remain appropriate.
The independent Nat-output consumers strengthen evidence for the deliberately
unrestricted structural API. The optional earlier R04 posterior suggestion
belongs to its later approved step and was not promoted into S01. The review's
selected 29-file identity check is not a complete inventory audit; the parent's
final B/R comparison covers the complete explicit inventory. These limits do
not leave a required S01 criterion open. No mathematical correction or further
independent round is warranted.

Only owning Markdown status/reconciliation records change after R. All reviewed
Lean source, regressions, imports, pinned declarations and normative plan bytes
remain unchanged, preserving applicability of the independent assessment and
trust checks. Final focused/default builds, source ownership, placeholders,
links, omissions, whitespace and artifact checks are captured before F.
Private `.pfr-review/setup/c05-s01-20260913/` retains the original native event,
validation outputs, reconciliation, final applicability and subsequent closure.
This record prepares S01 closure only; C05 remains active, and no later step,
commit, push or dependency change follows automatically.

## S02 - Binary singular sufficiency and combined Lemma 2

**Authority and startup (2026-09-13).** The lead requested S02 with review
conditional on completed S01 review. The parent verified S01 closure
`3f5dffc497c6a18dd551c41d9c9a74dae00c54d2a2e1aaac2e69378df88814c8`,
all three satisfied criteria, original-report reconciliation and exact equality
of all 100 F source/environment entries. S01 F is
`555bbac921c534a9e4f78639a54d6b3c75f058eda37882a20acbaff322eeb981`.
The installed workflow accepted the new message once for S02. No native message
ID was exposed in the current context; its original text is preserved under an
explicitly local capture identity. The same bound reviewer is retained.

**Current phase:** implementation validation, contextual self-review, separate
reassessment, independent assessment and original-report reconciliation passed.
S02 is validation ready; completion is governed by the subsequent durable execution
closure in `.pfr-review/`, not this pre-F statement. S02 supplies the total common
posterior for the binary maximal-coupling vector law, the shared/exclusive
construction bridge, cardinality-two input transport and combined Lemma 2.
S03 and later results are unstarted. This section records current S02 progress;
the original S01 preclosure narrative above is historical.

### S02 source and representation contract

The step baseline B is
`5d77cbae079ae4d2d847fc3e2a891c5e162c19d5b8a047fa1b76837387700bf4`.
The manuscript binaries were freshly hashed and match plan Section 2. The
consulted anchors are ISIT p. 2 II-B Lemma 2 and extended version 16 p. 12
(111)-(124); the retained page extracts were read against those identities.

Two singular specializations connect C04 to the companion: the shared-column
sum is exactly `overlapMass`, and the atom law is shared diagonal mass plus
the product of exclusive masses divided once by the residual total. The
pointwise proof explicitly includes both-zero columns. C04 supplies both
normalization and the overlap-zero/one endpoints; no normalized A/B/C laws
or replacement coupling is introduced.

The explicit maximal-coupling vector law has a single total common posterior.
At a shared positive output, C04's strict off-diagonal support condition forces
every supported vector touching that output to be constant. Both row
posteriors are therefore the same pure law. At an exclusive output only its
active row matters. At a globally unused output, the pinned total conditional
channel falls back to the vector law. The public existential theorem includes
that exact null-completion clause, allowing a consumer to inspect the actual
witness without exposing its private definition or assuming nonempty outputs.

The input-cardinality theorem transports this witness through
`Fintype.equivFinOfCardEq` and C03's relabeling theorem. The combined Lemma 2
wrapper uses either cardinality-two input or C03's at-most-two-active-output
branch. Generic necessity and the printed ambient-two-output specialization
remain the existing C03 interfaces. Both new semantic wrappers use `[Finite beta]`
and choose a `Fintype` internally; this retains every planned finite-output
consumer without making its enumeration public. Input `[Fintype alpha]` remains
because its cardinality is in the statement. No input prior occurs.

Production adds five public theorems; all construction machinery is private.
It now imports Singularity in place of Canonical, which Singularity imports,
and the focused finite-cardinality equivalence module. Binary remains separate
from the root until S06. No entropy/optimization theorem or decoder import is added.

### S02 regressions and initial diagnostics

R04/R06 use rows `(1/2,1/2,0,0,0)` and `(1/2,0,1/4,1/4,0)` on `Fin 5`.
Their maximal law has masses `1/2` at `(0,0)` and `1/4` at each of `(1,2)`
and `(1,3)`. The actual production witness's posterior at exclusive output 1
has two distinct positive vector atoms; its null-output posterior at 4 equals
the vector law. R05 consumes C04's identical/disjoint endpoint laws together
with the new semantic theorem. Singleton outputs are allowed. R07 distinguishes
the input branch (four active outputs) from the output branch (three inputs,
three ambient outputs, two active outputs), exercises Bool input transport and
the printed two-output consumer, and retains the separate C03 counterexample.

Initial helper and parent probes exposed ordinary elaboration failures:
finite-coordinate motives/reductions, explicit map identity/swap simplification,
and a missing section terminator. A parent relabeling probe needed the coerced
identity equivalence simplified before `PMF.map_id`. One retry overlapped a
Binary rebuild and found its temporarily absent object file; subsequent dependent
checks are serialized. The initial atom integration also exposed self-resolution
of an overloaded theorem name; the singular bridge is now named
`maximalCoupling_apply_shared_exclusive`. A combined-wrapper attempt introduced
the local `Fintype` binder instead of the disjunction; explicit goal normalization
corrected that. No contract changed. The initial integrated production module
then compiled, while new regression proofs still needed explicit subtype
enumerations and Fin numeral reduction.

All original diagnostics remain retained. The helper's failed elaboration
reported `sorryAx` for an unfinished scratch declaration; it is not passing
trust evidence or a maintained placeholder. Its initial source survives in
the native transcript, with diagnostics copied to scratch; no separate original
source file is claimed. The successful fixture probe is supporting evidence,
not a substitute for compiled production-witness consumers. One parent probe
output was initially saved under the prior setup directory by a reused runner;
an exact copy is retained in the S02 setup, with the original preserved.

The final focused invocation passed Binary, R01-R07, C03's semantic aggregate
and its separate 3-by-3 counterexample (2765 jobs). The default build passed
(2761 jobs). All five new public signatures and axiom reports passed, with
only `propext`, `Classical.choice` and `Quot.sound`; the two representative
printed proofs agree with the source. The final test correction made Fin-value
equality explicit in the four-active-output count. No new linter warning remains.

The B-based audit verifies exact preservation of S01's proof and test bodies,
all C01-C04 sources, the root, pins and normative plan bytes. All 67 omission
IDs remain; the source scan has no placeholders, local links resolve, and no
generated or reference artifact is tracked. Singularity's sole production import
is Canonical, already present before S02; the additional finite-equivalence
import is a mathlib module. Thus no additional LeanInfoTheory module or optional
decoder dependency enters through these imports. The root's existing KL reachability
is unchanged. The worktree still contains inherited changes; S02 attribution
uses B, not HEAD.

| S02 criterion | Implementation and evidence |
| --- | --- |
| C05-S02-C01 | Shared-overlap and exclusive-product atom bridges; explicit maximal-coupling common posterior, shared pure fibers, all-input factorization and actual null fallback; R04-R06 and endpoint consumers |
| C05-S02-C02 | Input cardinality-two iff, combined active-output/input wrapper, Bool transport, distinct disjunct fixtures, C03 generic necessity and printed-two-output consumer |
| C05-S02-C03 | R01-R07, C03 semantic/counterexample and default builds; five signature/axiom checks, source/import/placeholder and documentation audit |

### S02 contextual critique and independent reconciliation

Contextual self-review found no material gap or further recommended source change.
Separate reassessment retained the construction, the internal output enumeration
in semantic wrappers, and the actual-witness regressions. No required S02 outcome
was deferred. Exact posterior-mass assertions and a symmetric shared-sum alias
would duplicate consequences already supplied by factorization and singularity.

The same bound reviewer returned the complete original report for R
`1f89b0853c5ff79ff80b5adc05356ddde349c2fd7e68ac9c8cc72161362a1416`.
The native original was preserved before classification and confirmed delivery
of the uncertain submission without a resend. The installed receiver classified
it `VALID`, capture
`e67dcca25c0d2ae26cef61986e9fd6f312cb5390b039c9d704af82f6d17f2587`.
All three S02 criteria are satisfied. Its one nonmaterial finding,
`pfr-finding:c05-s02-001`, correctly identifies the README module index's older
S01/R01-R03 description. The implementer adopts that discovery improvement:
the index now includes the five S02 interfaces and R04-R07 coverage. No Lean
or mathematical-contract correction is required.

Independent focused/prerequisite and default builds passed (2767/2761 jobs).
Five additional consumers passed, including actual-witness factorization/null
completion, shared-output support, a caller with only `Finite beta`, unrestricted
necessity and a seven-input printed-two-output consumer. All five new public
signatures and axiom reports passed with only the three standard axioms.
Fresh manuscript hashes, page counts and visual anchor inspection agreed with
the construction. Exact rational enumeration independently checked the fixture,
both endpoints and singleton outputs; a nonsingular negative control failed
factorization as expected. This arithmetic supplements the general Lean proofs.

The reviewer's original wildcard-search error, scratch predicate-annotation error
and unresponsive corrected-probe attempt remain separate negative/inconclusive
evidence. The unchanged corrected probe subsequently passed using Lean's
`--threads=1`; this changes scheduling, not trust settings. No cause for the
unresponsive attempt is claimed and it is never counted as passing evidence.

The implementer reconciled the report against the actual common-posterior proof,
null fallback, explicit cardinality transport and distinct regression branches.
The multiatom fixture meets the earlier plan-review suggestion without requiring
its advisory coordinates. The finite semantic interface remains appropriate,
and generic necessity retains its existing scope. The reviewer's final identity
check covered 32 selected files, not the entire source inventory; its import
traversal excluded standard Lean/Init/Std internals. The parent final audit covers
all 99 real R inventory entries and verifies the two additionally inspected
pinned declaration hashes. These limits leave no required criterion unresolved.

Only eight owning Markdown documents change after R, for current status,
reconciliation and the README finding. All reviewed Lean, tests, imports, pins
and normative plan bytes remain unchanged; the independent mathematical and
trust evidence therefore remains applicable. Final focused/default builds and
B/R source, placeholder, link, omission, whitespace and artifact checks precede F.
Private `.pfr-review/setup/c05-s02-20260913/` retains the original report,
reconciliation, final evidence, finding disposition and subsequent closure.
No additional independent round is warranted for these bounded documentation
changes. S03, commit, push and dependency changes do not follow automatically.

## S03 - Conditional entropy and mismatch identity

**Authority and baseline (2026-09-13).** The lead requested S03 with review
conditional on completed S02 review. Before accepting it, the parent verified
S02 closure `9a9757cddace75284caf2fca3c580d699c722e2c1517bff8cbccec427807d61c`,
its three satisfied criteria, original-report reconciliation, resolved README
finding and exact equality of all 100 final source/environment entries. S02 F is
`2bc9f5704266fe26bcd20bdeb26e9f568a584cc192d2dea0fd2e0c6b046bd00c`.
The installed workflow accepted the actual new request once for S03 only, using
an explicitly local message capture because no native message ID was exposed.
The existing reviewer and normative contract remain unchanged. S03 B is
`5c76a3bd8d2aa709a24dffcdd37a3cb7514a92f895b5391037235aec82ef5c41`.

**Current phase:** implementation, contextual critique, separate reassessment,
independent review and original-report reconciliation passed. S03 is validation
ready; completion is governed by the subsequent durable execution closure. S03 concerns
the conditional-entropy/mismatch identity for arbitrary binary vector laws and
priors, its mutual-information form and fixed-pair canonical transport on an
unrestricted source. Both manuscripts were freshly hashed and match plan Section 2;
the consulted anchors are ISIT p. 2 II-C and extended v16 p. 13 (147)-(148),
p. 14 (149)-(155). S04 is unstarted. Earlier preclosure notes above are historical.

### S03 source, API and regression correspondence

The output/vector marginal is the swapped channel joint of q with the channel
`w ↦ p.map w`. PMF bind commutation and the existing atom formula prove this
complete-law identity. The public positive-fiber theorem then cancels the
nonzero finite vector weight to identify the actual conditional PMF with
`p.map w`. Its finite-output hypothesis is explicit; no full support, channel,
coupling-marginal, singularity or additional nonempty-alphabet premise occurs.

Binary evaluation is constant when the entries agree and injective otherwise.
The pinned deterministic and injective-map entropy theorems provide the two
entropy values. A private weighted-fiber lemma multiplies any null contribution
by zero. The existing finite conditional-entropy sum and C04's
`mismatchMass_toReal`, reindexed by `finTwoArrowEquiv`, yield exactly the
conditional-entropy/mismatch identity. No generic conditioning or entropy
theory is reimplemented. The total-channel fallback from S02 is not imposed
on this positive-only conditional PMF API.

The mutual-information identity uses the pinned `I = H - H_given` theorem.
The two common-source results rewrite C02's full triple law through the
pushforward definitions. They retain the original input/output variables and
output entropy, with no finite-source assumption and independent source/output
universes. A new generic transport alias is unnecessary.

Five public theorems are added: `condFstGivenSnd_binaryCanonicalJoint`,
`condEntropyOf_binaryCanonicalJoint`, `mutualInfoOf_binaryCanonicalJoint`, and
the `IsCanonicalFunctionalRepresentationOf` methods
`condEntropyOf_eq_binary_mismatch` and `mutualInfoOf_eq_binary_mismatch`.
Five calculation helpers stay private; the two structural marginal helpers
omit output finiteness. The existing four production imports suffice. The
positive-law theorem is public because R08 consumes the actual conditional
law and its reversed masses, beyond the aggregate entropy equality.

| S03 criterion / regression | Consumer boundary |
| --- | --- |
| C05-S03-C01 / R08 | Fair vector law on `[0,0]` and `[1,0]`, with the existing nonuniform prior `(1/3,2/3)`; actual conditional PMFs, zero entropy and input entropy, and reversed conditional masses `(2/3,1/3)` |
| C05-S03-C01 / R09 | Unequal vector `[0,1]` has zero mass; both its actual weighted entropy term and its weight times an arbitrary real value vanish |
| C05-S03-C02 / R10 | Both point priors with arbitrary q and finite output universe; common-source conditional entropy on a higher-universe unrestricted carrier; full-law and MI consumers on `Nat` with lifted outputs |
| C05-S03-C02 / R08-R10 | The mixed fixture has an independently calculated mismatch coefficient 1/2, consumed by both aggregate identities |
| C05-S03-C03 | R01-R10 and Canonical/Singularity consumers, default build, five public signature/axiom checks and exact B/import/source/documentation audit |

### S03 validation and retained diagnostics

Pinned source and its API index, declaration index, theorem highlights and
module guide supplied the required APIs. Supplemental Entropy, Conditional,
FiniteChannel and discovery-document hashes are retained beside the unchanged
registered source inventory. Routine path/glob and text-encoding discovery
errors were corrected; they are not evidence of missing mathematical APIs and
do not merit a discoverability-log entry or Future Work Note.

The first helper probe completed with local classical-decision and finite-motive
elaboration errors. The positive conditional law already elaborated. Explicit
scoped classical decisions and the finite predicate corrected the candidate;
its second single-worker compile passed without diagnostics. Original source
and errors are retained, including Lean's error-recovery placeholders in that
failed scratch output; they are not maintained placeholders or passing evidence.
The delivered candidate removed only a redundant Conditional import, whose
availability through the existing import chain was then verified by the
successful production build. No helper compiler was stopped.

The root's separate unrestricted-source transport probe passed and reported
only the three standard axioms. The first integrated build passed production
but left one fixture calculation open: broad simplification expanded the
vector map before composing it into a product law. The correction explicitly
identifies the product law as the fair pushforward `z ↦ (z,0)` before finite
summation. It changes no regression statement. The exact failed test source
and command output are retained; subsequent validation is recorded below.
That retry reduced the fixture obligation to the cardinality of a singleton
filter on `Fin 2`; an explicit kernel-checked finite decision closes it. Its
intermediate source and failed output are also preserved. Build durations were
variable; no compiler timing is treated as mathematical evidence.

The corrected focused build passed all 2764 jobs, including Binary, R01-R10,
and the Canonical/Singularity test consumers, without diagnostics. The default
build passed 2761 jobs. A separate public audit checked all five new signatures
and axiom reports: only `propext`, `Classical.choice` and `Quot.sound` occur.
The printed aggregate and common-source proofs confirm the weighted sum and
C02 full-law route. Binary remains separately imported until S06, so the
explicit focused targets supplement the default build.

The initial B audit verifies exact preservation of earlier S01-S02 proof/test
bodies, four production imports, root, pins and normative plan bytes. It also
checks placeholders, local links, 67 omission records, whitespace and tracked
artifacts. A refreshed source audit after these documentation updates precedes
the source-bound independent request. Failed attempts retain their actual
outcomes; only the corrected passing checks support acceptance.

### S03 contextual review and independent reconciliation

Contextual self-review found no mathematical gap or further source correction.
Separate reassessment retained the proof route, five public interfaces and
private calculation helpers. A later ancillary documentation check identified
stale current summaries in living-summary Section 1 and map DG-05; a separately
recorded edit corrected those before R. The original critique and later advice
remain distinct. No mathematical outcome was weakened or deferred.

The same bound reviewer returned its complete original report for R
`a0bf38ae33d8c7bd3bd92a86274ae59272dd45bd90a2a7103d6c121de5efb632`.
The native original was preserved before classification and confirmed delivery
of the uncertain submission without a resend. The receiver classified it `VALID`,
capture `1b58cd3bbc3bb75e59b9ddc024856bae0d2c07b834ea1858cc8bb80829567acc`.
All three S03 criteria are satisfied, with no actionable findings. The implementer
explicitly reconciled the original report against the positive-fiber cancellation,
constant/injective evaluation, weighted null branch, mismatch reindexing and
complete-law transport. Earlier README and multiatom-fixture advice remains
satisfied in the preserved S02/S03 source.

Independent focused builds included Binary/R01-R10, Canonical, Singularity and
FiniteCoupling consumers (2765 jobs); the default build passed 2761 jobs. The
reviewer independently inspected the maintained R08-R10 consumers and compiled
a separate audit of all five public signatures and axiom dependencies. That
audit passed with only the three standard axioms. Fresh manuscript hashes,
page counts and visual anchor inspection agreed with the implemented contract.

The larger supplementary reviewer probe did not complete: the first compiler
attempt was stopped after about 3 minutes 30 seconds, a launcher retry after
about 2 minutes 13 seconds, and a direct compiler retry timed out at 90 seconds.
None produced a Lean diagnostic or verified its four custom consumers/full
declaration printouts. They remain `FAIL`/inconclusive evidence. The smaller
declaration/axiom audit subsequently passed with two workers in 47.7 seconds;
this does not retroactively validate the larger probe, and no cause for the
stalls is claimed. Parent proof printouts passed separately. Required compiling
consumer coverage comes from the independently inspected and built R08-R10,
so these optional probe failures leave no required criterion unestablished.

The reviewer verified 35 selected inventory files and three supplemental pinned
declarations, not the complete source inventory. Its import-header traversal
resolved 2743 modules, leaving 185 standard Lean/Init/Std modules unexpanded,
with no unresolved nonstandard module or optional decoding/test/example import.
This is not a universal dependency audit. The parent final audit covers all 99
real R inventory entries and the seven recorded supplemental hashes; the installed
final snapshot rechecks the environment and pins.

Only eight owning Markdown documents change after R, for reconciliation, current
status and minor README list grammar. All reviewed Lean, tests, imports, pins and
normative plan bytes remain unchanged. Final focused/default builds and exact
B/R source, placeholder, link, omission, whitespace and artifact checks precede F.
No additional independent round is warranted for these bounded document changes.
Private `.pfr-review/setup/c05-s03-20260913/` retains the original report,
reconciliation, evidence and subsequent closure. S04 remains unstarted; no commit,
push or dependency change is included.

## S04 - Universal bound and finite information attainment

**Authority and baseline (2026-09-13).** The lead requested S04 with review
conditional on S03 completion. The parent verified closure
`120decc9372a4512817d24bd89cf9c9ca1cc6aa0a58b0f52341d70497d6bc6df`,
all three satisfied criteria, the original-report reconciliation and exact equality
of all 100 final source/environment entries. S03 F is
`4b1e1e3ed968cce5b0872889f6b35117f6829632d3895df7fff8b2e4cc181e54`.
The actual new request was accepted once for S04 only, with the same reviewer
and unchanged normative contract. S04 B is
`94b7b7c4939218eafe94ca6310ce164d0d217cd4a5f1982e3d11438ffd6cab6e`.

**Current phase:** implementation, focused/full builds and public-interface
checks pass. Independent review satisfied all three S04 criteria; the original
report was critically reconciled and its optional README clarification adopted.
S04 is validation ready; final completion is governed by the subsequent durable
execution closure. The universal
bound keeps arbitrary binary priors, unrestricted sources and finite auxiliaries
in independent universes. C02 canonicalization supplies the full-support branch;
the other branch uses a point prior and the pinned information/entropy bound.
The specified maximal-coupling vector law achieves the exact information
value via S03, with its pair marginal and structural representation property.
S05 remains unstarted. Earlier checkpoints in this document are historical.

The plan's `jointLaw` notation is implemented as the existing pair pushforward
`mu.map (fun s => (X s, Y s))`, without adding a generic alias. For R12, the
existing skew/reversed bit rows and skew prior give a nonsingular channel of
TV `1/3` and output law `(5/9,4/9)`; this meets the approved intermediate-TV
contract while avoiding a duplicate prior fixture. R13 uses an actual constant
decoder on a `Nat` source with a lifted singleton auxiliary and an unused output
label. Its unseen decoder coordinate disagrees with the supplied second channel
row. These are routine fixture choices, not changes to the reviewed requirements.

### Source correspondence and API

The exact ISIT p. 2 II-C Lemma 3 first assertion and extended v16 p. 13
(147)-(148), p. 14 (149)-(163) were reread, with both current manuscript hashes
matching the approved plan. S03 supplies (149)-(154); C04 supplies (156)-(161)
and the specified maximal coupling. S04 connects them through (155) and
(162)-(163). The equality discussion (164)-(166) stays S05. The maximum is over
finite auxiliary representations with the fixed pair law, permitting a new
finite triple-law extension. It does not promise an optimizer on an arbitrary
original source, infinite-auxiliary information, uniqueness or minimal cardinality.

Three public theorems extend `Semantics/Binary.lean` (25 public theorems total):

| Declaration | Contract and proof |
| --- | --- |
| `IsFunctionalRepresentationOf.mutualInfoOf_le_binary_bound` | Exact supplied pair law, arbitrary binary prior, unrestricted source and independently universe-polymorphic finite output/auxiliary. Full support permits C02 information-preserving canonicalization and all-row coupling, then C04's mismatch lower bound multiplied by nonnegative input entropy and S03's information identity. Without full support, a private binary lemma proves the prior is pure and its entropy zero; pinned `mutualInfoOf_le_entropyOf_left` completes the bound without recovering an unseen row. |
| `maximalBinaryCanonicalJoint_attains` | The prescribed C04 maximal coupling pushed through the inverse product/vector equivalence, then `canonicalJoint p`, simultaneously has canonical structure, exact channel pair marginal, and information `H(Y)-TV*H(p)`. The proof uses S01's pair bridge, C02's canonical structure, S03's entropy formula and C04's exact real mismatch attainment. |
| `exists_binary_information_maximizer` | Packages that same finite vector auxiliary in an existential structural triple-law representation with the prescribed pair and exact objective. Together with the universal bound, this is the directly composable maximum package permitted by Section 3.4. |

The one new pure-prior helper is private. Production imports remain the existing
four; the lightweight root remains unchanged until S06. No generic entropy,
optimization, support-subtype or probability construction is duplicated.
Discovery checked pinned source plus the API index, declaration index, theorem
highlights and module guide. Successful isolated probes checked the bound and
attainment before integration. No genuine discoverability issue or Future Work
Note was identified. Earlier S01-S03 proofs and test bodies are preserved.

### Criterion and regression evidence

| Criterion | Concrete maintained coverage |
| --- | --- |
| `C05-S04-C01` | The universal theorem's separate source/output/auxiliary universes and support split; R11 constructs a functional representation from an original support-correct decoder and separately consumes C02 information preservation. R13 applies the bound to an actual unseen-row disagreement. |
| `C05-S04-C02` | The explicit canonical law's structure, pair marginal and information equality, plus the finite existential witness. A generic R11 consumer combines the bound and existential theorem into an actual comparison with an attaining representation. |
| `C05-S04-C03` | R12's nonsingular skew/reversed rows, full-support nonuniform prior, TV `1/3`, independently checked output atoms `(5/9,4/9)`, and both explicit and existential information consumers. R13 checks both point priors for arbitrary finite output/channel, singleton outputs, a globally unused output, arbitrary `PMF Nat`, and a `ULift.{1} Unit` auxiliary. |

The R13 original decoder law has mismatch zero while the ambient channel TV is
one. This is deliberately compatible with the exact pair law under `pure 0`:
only the prescribed attaining construction needs both channel rows. The example
guards against applying the full-support coupling theorem in the point-prior
branch and differs from the later R15 equality regression.

### Validation chronology before review

The first isolated attainment attempt failed on a line break after field-notation
`.`; replacing it by the verified named theorem application passed. Its failed
output and source snapshot are retained, including Lean's error-recovery trust
output, and are not proof evidence. The separate bound probe passed on its first
attempt. The first integrated focused build compiled production but failed four
test arithmetic sites involving `ENNReal.toReal` and `Fin 3` inequalities.
Explicit real conversion/non-top simplification and finite inequality proofs
resolved them without changing the contracts or fixture data. The corrected
focused build passed all 2762 jobs, including Binary, its R01-R13 regression
module, and the Canonical and FiniteCoupling consumers. No unsuccessful attempt
is counted as passing evidence.

The default `lake build` passed all 2761 jobs. The separate three-declaration
signature/axiom probe passed, retaining source/output/auxiliary universe
independence and only `propext`, `Classical.choice`, and `Quot.sound`. These are
incremental builds, supplemented by explicit Binary targets because S06 root
integration has not begun. No clean-rebuild or universal-dependency claim is made.

### Contextual review, independent assessment and reconciliation

Contextual self-review retained the mathematical implementation and recommended
one minor correction, `pfr-finding:c05-s04-self-001`: status-grammar errors from
the parent documentation normalization. A separate reassessment adopted that
bounded correction. It was applied before independent review, and refreshed
source evidence confirmed unchanged Lean, dependency and normative-plan bytes.
An ancillary diff check identified one historical plural agreement changed by
that cleanup; its original wording was restored during final documentation work.

The neutral request froze R
`b48d6e8ed05d8e8912a37ac0db1e6b090e3ff9eea8d6c8c8a06d9695a479f140`.
The native submission returned an empty body, retained honestly as `UNCERTAIN`
without resending. The complete original native report was preserved before
classification and then received as `VALID`, with capture
`9a80c974962e1d48d8b04912a1ada7ef9577fc7116bc75ed94513a12d565b371`.
Report-backed delivery confirmation remains separate from that original receipt.

The same bound reviewer independently satisfied `C05-S04-C01` through C03.
It freshly passed the focused build (2762 jobs), full build (2761 jobs), all
three public signature/axiom checks and two independently written consumers:
one finite law dominates all eligible representations with separate higher
universes, and either point prior specializes the bound without an unseen-row
premise. Its selected 35 source files and three supplemental dependency hashes
matched; the manuscript identities, page counts and relevant rendered passages
were revalidated. Its initial unavailable PyMuPDF attempt remains a failure;
the alternative PDFium/pypdf rendering passed. An initially empty text slice was
not manuscript evidence; direct visual inspection supplied that check. These
limits and the earlier S03 failed optional probes remain preserved.

Critical reconciliation accepts the three criteria because the source contracts,
support split, exact witness and successful evidence substantiate them. The
optional finding `pfr-finding:c05-s04-001` is also adopted: README's old S01-only
authorization sentence is made explicitly historical and points to the current
C05 plan. This is distinct from the earlier resolved Binary-index finding, and
its original introduction is not attributed to S04. No mathematical correction
or new independent round is required for these bounded documentary changes.

Closeout preserves every reviewed Lean/import/dependency byte and the normative
plan. The final record must supply fresh focused/full builds, the complete
explicit B/R ownership and placeholder/link/artifact audits, current dispositions
for both findings, all three criterion assessments and exact F closure. The
eight owning documents are finalized before F; S05, commits, pushes and dependency
changes remain outside this step. No new omission number or Future Work Note is
introduced.

## S05 equality and semantic input transport — 2026-09-13

The new conditional S05-with-review request was accepted after verifying S04
durable closure `744140328f9c2aaa4033cd70b0a1b5f5e4fb24bac9f5ea2ed93dd7311863157f`,
its original-report reconciliation, three satisfied criteria and exact equality
of all 100 final source/environment entries. S04 F is
`01dfb88c838da41793f6ee55dbef2a83b4af7493445310bbd77243ef9f36cb3f`.
S05 B is `4619d866231f0401ecc8e7425d7db98ed99d08a91776c1005c56b8e924788480`.
The existing reviewer binding and normative revision-2 contract are unchanged.

Only S05 is authorized. Its mathematical targets are the arbitrary-prior
information inequality and singular forward equality, the full-support ambient
equality iff, and the cardinality-two pair/common-base and finite-witness
interfaces from Section 3.5. R14-R17 cover their support and relabeling boundaries.
Implementation and initial validation pass. Contextual review, separate
reassessment and independent review are complete; the original report is
reconciled. Final validation and closure are governed by the subsequent durable
record. No S06, commit, push or pin change is included.

### S05 source meaning and proof route

Fresh hashes match the designated six-page ISIT manuscript and eighteen-page
extended version 16 recorded in the plan. The consulted anchors are ISIT p. 2,
II-C Lemma 3's second assertion, and extended p. 14 (164)-(166), using the
already implemented (147)-(163) contracts. The printed ambient-channel iff
suppresses the input-support distinction: the Lean converse explicitly requires
every input in the prior support. The forward equality and inequality keep
arbitrary priors. No new manuscript interpretation or omission is introduced;
OM-063 and OM-067 retain the approved boundary and proof allocation.

The inequality applies C01's representation-information bound to the finite
attaining witness from S04 and cancels the common output entropy. Singular
forward equality uses S02's intrinsic sufficiency and C02's canonical perfect
witness for every prior, then the S04 universal bound. Conversely, quantitative
equality makes the finite S04 attaining witness perfect. C01's finite-witness
bridge, C02's full-support pair/channel equivalence and C03's generic necessity
recover ambient-channel singularity. This dependency order is noncircular and
never divides by input entropy or introduces a new analytic equality theorem.

Input transport uses `p.map e` and rows `kappa (e.symm i)`. The full pair-law
map, entropy, output marginal, mutual information and full support are checked
at that boundary. The attaining vector is transported by `w ↦ (fun x => w (e x))`;
the full canonical triple map and injectivity of this coordinate map preserve
its information value. Common-base conclusions identify the input and output
entropies through the exact pair law and retain an unrestricted source and
independent value-alphabet universes. S01's enumeration-independence theorem
continues to identify the scalar for different choices of `e`.

The pinned source, declaration index, API index, theorem highlights and module
guide were searched before selecting the proof route. The implementation reuses
the entropy identities and injective/equivalence invariance in `Entropy.lean`
and `InfoMeasures.lean`, PMF map/bind laws and channel marginal theorems, and
the existing C01-C04 semantic/probability interfaces. Only local bridge helpers
are added; production retains its four focused imports. The eight supplemental
dependency/discovery hashes are recorded privately alongside the source capture.
No dependency upgrade, broad information-theory import or public transport
framework is introduced.

### S05 implementation and initial evidence

Thirteen new public theorems cover the Fin 2 inequality/forward equality/
full-support iff, exact input pair law, arbitrary-input common-base universal
bound, explicit and existential finite attainment, and the pair/common-base
quantitative inequality/equality interfaces. The S01-S04 proof bodies remain
unchanged. The equality helper's first isolated probe passed with the three
Fin 2 proofs and eight API checks. The parent's first transport probe failed at
one rewrite beneath `fstMarginal`; production now unfolds that marginal
explicitly. The fixture helper's first attempt failed three elaboration sites
(support-map arguments, a typed `Fin.val` projection, and a section terminator).
Those negative attempts remain retained and do not count as passing validation.

The integrated production module subsequently built successfully. Its two
preliminary failed builds identified finite-function enumeration in two theorem
statements, an explicitly typed projection across universes, and an output-law
rewrite. The statements supply classical enumeration locally without adding a
decidability premise; the proof reuses the existing private output-law bridge.
All thirteen public signature/axiom checks passed, with only `propext`,
`Classical.choice` and `Quot.sound`. The initial full build passed (2761 jobs).

The first focused integration passed production but failed two Bool fixture
elaborations. Explicit double-inverse simplification resolved the pair-law
rewrite. The concrete attaining consumer additionally exposes the native versus
classical finite vector enumeration; a scoped classical opening alone did not
resolve this, and its failed rerun is retained. The current native-statement
consumer uses mathlib congruence and the subsingleton instance for `Fintype`.
The fourth focused attempt left only the concrete Bool coordinate identities;
closing those by reflexivity gave a successful fifth attempt: all 2765 focused
jobs passed, with Binary regressions built in 272 seconds and a total command
duration of 434.898 seconds. No public assumption or information formula changed
in this elaboration work.

R14 uses a full-support nonuniform prior with both a singular deterministic
channel and the nonsingular skew/reversed-row channel; strictness follows from
the inequality and iff. R15 independently proves the mandatory fair-row/point-row
counterexample has TV 1/2, zero input entropy, zero pair information and numerical
equality despite ambient nonsingularity. R16 transports the nonuniform prior to
Bool, its full support and exact pair law, input entropy and explicit attaining
vector, and consumes the common-base APIs in four independent universes. Its
full-support premise is confined to the iff part of the consumer. R17 preserves
the scalar, objective and information of the actual mapped canonical witness,
with exact pair law and structure, and consumes the new inequality/equality
results after injective output mapping. Fin 3 label 2 is unused; the common-subtype
example begins with both row laws already on that subtype.

No implementation compiler was stopped. The first three isolated probes had unusually slow
startup but completed; the parent transport attempt took 948.005 seconds and
failed, while the equality helper's successful log-capture interval was
932.9377054 seconds (not a separate Lean-process stopwatch). Unrelated build
processes were not interrupted. Successful integrated checks, failed attempts,
and source-level ancillary advice remain distinct. Ancillary helpers are
implementation support, not the bound independent reviewer.

### S05 contextual review, independent assessment and reconciliation

After initial validation, the parent inspected the complete integrated contracts,
proof dependencies, hypothesis allocation, representation boundaries, regressions,
API/import ownership, source correspondence and documentation. The retained
contextual critique identified no actionable finding. A separate reassessment
retained the implementation: a support-subtype optimizer family, generic public
transport framework or extra decidability premise would add scope without a
required consumer. No source edit occurred between these two phases.

The existing bound reviewer independently assessed R
`a78e75d3c5d842a0c02966192ce6238d9f67dba244b35569c1a7e0f21abfa1fa`.
Its complete original native report was preserved before classification, captured
as `65c2c81bd5d9a348c4663abeaade866c8b831a294542c1ecafec9d8358bff531`,
accepted as valid and explicitly reconciled. The original empty submission receipt
remains uncertain; a separate original-report-backed confirmation established
delivery without resending. All three S05 criteria are satisfied with no findings.

The reviewer independently passed the focused build (2765 jobs), full build
(2761 jobs), all thirteen public signature/axiom checks and two additional
consumers: an arbitrary-source maximum package and a full-support nonsingular
strict gap. Its final compiler audit exited 0 in 10.89 seconds with one worker;
all printed axiom dependencies are standard `propext`, `Classical.choice` and
`Quot.sound`. It inspected the exact manuscript anchors visually after verifying
both hashes. Its selected source-identity check covered 35 relevant files and
the justified supplements. Its import-header scan found no new imports and no
unresolved nonstandard imports; standard runtime modules were not fully expanded.

Four unsuccessful reviewer attempts remain separate negative evidence: compiler
timeouts at 60.89 and 90.11 seconds, a dangling scope line introduced by a scratch
filter, and an initial manuscript excerpt selector that matched a cited lemma
instead of the intended assertion. Corrected checks passed, but those earlier
attempts are not passing evidence. The two timed-out reviewer compilers were
stopped; no maintained source was changed by the reviewer.

Critical reconciliation accepts the three assessments because their cited PASS
evidence establishes the actual finite-attainment/perfectness argument, explicit
support boundary, quantitative transport and R14-R17 contracts. None relies on a
failed attempt. Selected source and import-header checks are not promoted to a
universal dependency audit. Earlier optional findings were rechecked in current
source without replacing their historical records. No mathematical, API, test or
normative-plan correction is warranted. Reconciliation changes only owning
Markdown status/evidence notes; the final B/R audits and builds verify continued
applicability. S05 is validation ready, with durable completion determined by the
subsequent execution record. S06 root integration and S07 cumulative closeout
remain unstarted.

## S06 - root integration and cumulative readiness (2026-09-13)

The lead requested S06 with review conditional on S05 completion. Startup
verified S05 durable closure
`69082fa98c31b9009fcd4dc00c43cb14bc435133db67af7e236b4a9a22c474fb`,
its original-report reconciliation and three satisfied criteria, and exact
equality of all 100 final source/environment entries at F
`057e3593dd8a0c9fb4307a00aea93558d76072c669fd0c23c50eb17c9271b3d4`.
The installed workflow accepted the actual request once for S06, with B
`517245dfd4374d99217e79e892a680fd34fb2a62764a6b7b869995c150172e8b`.
Earlier preclosure statements above are historical. S07, commits, pushes and
dependency changes are not included.

S06 adds the Binary import and mathematical description to the lightweight
root. Its only other Lean change is `Tests/Semantics/BinaryRoot.lean`, whose
sole import is the root. Four anonymous R18 consumers establish combined
input/active-output Lemma 2, the printed ambient-output branch, a specified
finite canonical attainer with exact pair law and actual information value
dominating every original finite auxiliary, and common-base inequality,
singular forward equality and the explicitly full-support iff. Independent
source/value universes and arbitrary priors are retained. No production
theorem, helper API or new assumption is introduced; S01-S05 proofs/tests
and C01-C04 source remain byte-for-byte unchanged.

The [cumulative readiness audit](pfr-c05-readiness-audit.md) owns the complete
15-earlier-criterion, R01-R18, ten-outcome and 38-public-declaration mapping,
with precise assumptions, manuscript departures, omission and import scope.
Its tables establish internal readiness; they do not perform S07's separately
authorized independent cumulative acceptance review. Current status summaries
are condensed and normalized while earlier dated records remain preserved.

Fresh initial cumulative validation passed all twelve required targets
(2777 jobs, 27.439 seconds), including C01-C04 consumers and the optional
decoding regression. The default build passed 2762 jobs (3.664 seconds).
All 38 public signatures and `#print axioms` checks, plus representative
proof prints of the finite maximizer and equality iff, passed through a
root-only probe (17.082 seconds, one worker). Only `propext`,
`Classical.choice` and `Quot.sound` occur. These are incremental builds,
not clean rebuilds. The initial root/R18 attempt failed because `intro`
introduced the statement's leading let-bound Fintype instance as the
disjunction hypothesis. `dsimp only` resolves that binder before `intro`;
the corrected whole module passed. That failed attempt is retained and
never counted as passing evidence.

The transitive import-header audit resolved 2745 modules with 185 standard
Lean/Init/Std frontier entries left unexpanded. Binary is the only newly
reached project module; no new LeanInfoTheory or foundational module is
reached. Optional decoding/Fano and project tests, examples, matrix and
optimization modules remain outside the root. Existing KL dependencies are
not claimed absent. Eight justified pinned supplements and both designated
manuscript hashes were freshly verified. The authenticated retained extracts
of ISIT p.2 and extended v16 pp.12-14 were reread; this is not a new visual
inspection claim or an expansion into incidental adjacent text.

Initial source/diff/artifact and owning-document audits pass: nine baseline
files changed, two files added and all 90 other real baseline files preserved.
Normative plan bytes and all 67 omission IDs remain intact; placeholder,
whitespace, local-link and tracked-artifact checks pass. Contextual critique,
separate reassessment and independent S06 review remain pending at this checkpoint.
Private evidence is retained under `.pfr-review/setup/c05-s06-20260913/`;
ignored probes and bounded support drafts remain under `tmp/c05-s06*/`.
No private records, manuscript copies or generated build outputs are staged.

### S06 contextual critique, independent review and reconciliation

After initial validation, the retained read-only contextual critique found no
actionable issue in the mathematical consumers, finite/support boundaries,
source mapping, dependency ownership or documentation. A separate decision
pass retained the implementation: a public optimizer abstraction or root alias
would add no required consumer capability, while the complete readiness tables
serve S06's explicit traceability duty. No maintained edit occurred between
critique and reassessment.

The original bound review of R `ce019066ca1a6d6cba69100cc1f5ae447c39ee7acb4841b985d562f57f78d6cb`
was preserved before classification, captured as
`09e132427b9196c8a1eacd6f8a53f97c46209d4bb8a63ad5187141eebc902e1d`, accepted as valid and
explicitly reconciled. All three S06 criteria are satisfied with no findings.
The [readiness audit](pfr-c05-readiness-audit.md#independent-s06-review-and-critical-reconciliation)
owns the cumulative review/evidence mapping and its limits. Independent
cumulative/default builds passed 2777/2762 jobs. The corrected 38-public
root audit, two proof prints and two independent consumers passed in 114.20
seconds with only standard axioms. Both manuscript hashes and exact text,
41 selected source identities, 267 links, imports and omissions were checked.
The first incomplete reviewer audit was stopped at 98.31 seconds after scratch
enumeration/link-classification errors; it remains FAIL, never acceptance
evidence. No maintained reviewer edit occurred. Earlier failed checks and
original optional-finding records retain their original dispositions.

Reconciliation accepts the source-backed root usability, mapping accuracy and
internal-readiness assessments while preserving their bounded source/header,
incremental-build and text-inspection limits. It does not certify the private
B/F history through the reviewer or replace S07. Only Markdown status/evidence
records change after R; no mathematical correction or additional review is
needed. Final exact B/R audits and cumulative/default builds establish the
applicability of the original review and public trust checks before F. S06 is
validation ready; durable completion is determined by the subsequent execution
record. S07 remains unstarted.

Final post-reconciliation cumulative/default builds pass (2777/2762 jobs).
The exact B/R audits, placeholder, whitespace, local-link and tracked-artifact
checks pass. R-to-final changes are confined to nine Markdown records; all
92 other reviewed real files, eight supplements and normative plan bytes are
preserved. The original independent review and root-only trust/import evidence
remain applicable. Final current-document checks and the supported execution
record govern F and durable S06 closure. No S07 work is included.

## S07 - Fresh cumulative review and chunk closeout - 2026-09-13

The lead requested S07 with review only if S06 and its review were complete.
Before accepting that request once, the installed workflow verified S06 closure
`a86b8723a79b0648de7776d5328e33bda7d80b87f7af9f923ebb863bfb7e49d9`,
F `af8539437df033b8e4c4cb2255719b61bd359ef3e58c4226fd128557cc1999f5`,
three satisfied criteria, original-report reconciliation and exact equality of
all 102 final source/environment entries. S07 B is
`d3def0b47679f216bd37c22650a69a123e24a516b2553d613bf28954ea3f0352`.
No C06, dependency modification, commit or push is authorized.

The implementation preserves all S01-S06 Lean source and regression bytes.
Current status records now recognize S06 durable closure and S07 activation;
the living summary's current root description now includes Binary, and README's
explicit regression command includes BinaryRoot. The approved normative plan
and all 67 omission records remain intact. C06's existing C02/C03 prerequisites
and open design gates are unchanged; cumulative completion does not approve it.

Fresh cumulative/default builds pass 2777/2762 jobs (4.689/8.003 seconds).
The complete 38-public root-only signature/axiom audit and two proof prints pass
in 221.257 seconds with only the standard three axioms. Import-header checks
pass with 2745 resolved modules and 185 standard frontier entries. Their
historical comparison is to the S05 preintegration root; S07 introduces no
module or import change. The eight pinned supplements and both exact source
hashes were verified; ISIT p.2 and extended v16 pp.12-14 were freshly extracted,
rendered and visually read. This refresh is distinct from S06's retained-text
inspection. No new interpretation or mathematical repair was needed.

The [readiness audit](pfr-c05-readiness-audit.md#s07-fresh-cumulative-assessment)
owns the fresh evidence and cumulative mapping for eighteen earlier criteria,
R01-R18, ten completion outcomes and all 38 public declarations. All checks
are bounded and incremental; no clean rebuild or universal dependency audit
is claimed. Contextual critique, separate reassessment and independent S07
assessment remain pending at this startup checkpoint. Private evidence is
retained under `.pfr-review/setup/c05-s07-20260913/`; ignored working drafts and
probes are separate from maintained source and durable review records.

### S07 contextual critique, independent review and reconciliation

After initial validation, the read-only contextual critique found no remaining
mathematical/API/hypothesis/coverage gap. A separate reassessment retained the
implemented proofs and explicit cumulative tables; extra optimizer machinery
or altered support contracts would not improve the authorized outcome.
No maintained source was edited between critique and reassessment.

The same bound reviewer freshly assessed the complete chunk at R
`32740fddc06d0897bdf83920c04180659b615e6fd91027d325d1e41c1c733964`. The complete original native report
was preserved before classification, captured as
`c21b4826ef9375f692afc18a4366f5cfbb75b32e2311c6182968a8f705e33318`, accepted as valid and explicitly
reconciled. Its payload SHA-256 is
`69e3d5a59644591b1b412b906b9543e101d98863833c3d84a9c3b6049e548769`.
All three S07 criteria, eighteen earlier criteria, R01-R18 and ten completion
outcomes are individually satisfied; the report has no findings. The
[readiness audit](pfr-c05-readiness-audit.md#original-independent-s07-review-and-critical-reconciliation)
owns the complete cumulative assessment/evidence mapping and its limits.

Independent cumulative/default builds pass 2777/2762 jobs. All 38 public
signatures/axioms, two proof prints and two independent root consumers pass
in 211.83 seconds, with only standard axioms. Fresh manuscript visual reading,
all 101 source identities, needed pinned declarations, 267 links, declaration
ownership, import boundaries, integrity and all 67 omissions were checked.
One initial reviewer UTF-8 postprocessing failure remains FAIL; its later
postprocessing did not run despite the encompassing shell ending zero. The
corrected helper and all actual current compiler checks passed separately.
Effective reviewer settings and private B/F history remain outside independent
authentication; builds and dependency/trust checks are bounded and incremental.

Critical reconciliation confirms the source-based mathematical and validation
conclusions and report completeness. It corrects short regression citations
in the maintained mapping, especially R09's actual lines 524/528 instead of
the original 544/554, and refines coarse companion citations for R05-R10/R15.
The original report remains unchanged. Required examples were already freshly
read and compiled and correctly mapped in readiness; this is not a criterion
gap or material mathematical change requiring another independent review.

Only nine owning Markdown records change after R. Final cumulative/default
validation and exact B/R audits establish review/trust/import applicability
before F and supported closure. S07 is validation ready; durable completion
of the approved C05 chunk is determined by the subsequent execution record.
C06, new chunks, commits, pushes and dependency changes are not authorized.

Final post-reconciliation cumulative/default builds pass (2777/2762 jobs,
9.789/8.221 seconds). Exact B/R source, placeholder, whitespace, local-link
and tracked-artifact checks pass. R-to-final changes remain confined to nine
Markdown records; all 92 other reviewed real files, eight pinned supplements
and normative plan bytes are unchanged. The fresh original independent review
and public trust/import checks retain applicability. Final source assertions
are refreshed after this evidence note, before F and durable closure. Included
documents are not edited after F; a subsequent task may normalize their status
from the supported record. No later chunk work is included.
