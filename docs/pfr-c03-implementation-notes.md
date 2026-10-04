# PFR-C03 implementation notes

The lead approved [Draft revision 2](plans/pfr-c03-singularity-binary-output-counterexample.md)
and requested **S01 with review** on 2026-09-11. After S01 closure, the lead
separately requested **S02 with review**, conditional on S01 completion.
After S02 closure, the lead separately requested **S03 with review**, conditional
on S02 completion. After S03 closure, the lead separately requested **S04 with
review**, conditional on S03 completion. After S04 closure, the lead separately
requested **S05 with review**, conditional on S04 completion. After S05 closure,
the lead separately requested **S06 with review**, conditional on S05 completion.
S07 needs a separate request.

## S01: intrinsic singularity and necessity

**Status:** S01 durably complete. At S02 start the actual closure
`6864e97cfd096f81decd0ada77bac7a93103aaedcd55bdeb01dfc1f9f88c714e`
was inspected read-only, including satisfied criteria and report reconciliation.
All 68 real files and the environment still matched S01 F
`9d6fc99e1d8335838010338053dc5fa1ae0ecfcc086b7cf2de2b236082bbf96b`.
The previous frozen preclosure wording was not evidence of missing closure.

**Baseline:** HEAD `54c1714d1a9a891939d6c9f7d38c0d05896b2c75` plus the actual
inherited working bytes. The execution B snapshot is
`ba30af6976cad87e0ac1e81c4510ecc5cbb58f9f6f57a4f13d78c205af763575`.
Only the two new Singularity modules and this note, together with approval/status
documentation changes, belong to S01. C02 source, the mathematical root,
dependencies and inherited work are preserved. The plan's normative digest is
`b1987d8e45763af3e6c2f608150a41c2b71ae663ceac7235b566c2df20f92367`;
approval/progress changes are confined to its editorial status block.

**Source:** ISIT Section II-B, Definition 3 and Lemma 2's necessary direction
(page 2), supplemented by extended Appendix A (105)-(110), page 12 of designated
version 16 dated 2026-09-03. Both manuscript hashes match the plan and were
rechecked against the local files. The extended proof's full-support-prior
cancellation is already supplied by C02's prior-free common-posterior contract.
S01 reuses that contract, so it needs no new prior or finite-alphabet assumption.

| Public declaration in `Semantics/Singularity.lean` | Contract and boundary |
| --- | --- |
| `IsSingularChannel` | Any two nonzero entries in one output column agree; arbitrary input/output universes, with no nonempty or finiteness assumption |
| `isSingularChannel_iff_mul_pos` | Equivalent to Definition 3's positive-product premise; zero and single-positive-entry columns impose no condition |
| `IsPerfectlyRepresentableChannel.isSingular` | Necessity for C02's channel property; only its existing `Nonempty alpha` assumption |

The one private helper extracts coordinate equality from a supported common
posterior atom via `PMF.mem_support_channelJoint_iff` and
`PMF.mem_support_map_iff`. For that same atom, injectivity of
`w ↦ (w x, w)` gives its mass using `PMF.map_apply_of_injective` and
`PMF.channelJoint_apply`. `ENNReal.mul_left_inj` cancels the posterior mass only
after support membership proves it nonzero and `PMF.apply_ne_top` proves it
finite. This does not divide by a zero mass or choose two unrelated posteriors.
The necessity theorem is generic; singularity means columnwise equality, not
determinant singularity. No contrapositive alias or extra public helper is added.

The production module imports only `Semantics.Canonical`; the root stays as it
was until S06. Tests import the new module and keep fixtures/helpers private:

- R01 uses pure rows on `Option Bool`, explicitly checking the unused `none`
  column and the single positive entry in each other column.
- R02 uses a pure row and a uniform Bool row. The common false column has
  positive masses 1 and 1/2, so necessity rejects perfect representability.
- R03 checks vacuous empty-input singularity and impossibility of supplying the
  intrinsic property's nonempty witness, plus arbitrary-output singleton input.
- Polymorphic anonymous consumers check the exact general equivalence and
  necessity signatures without introducing an input law or finiteness instance.

**Allocation at S01 closeout:** Definition 3 and necessity are implemented. Binary-output
sufficiency, finite transport, active restriction, the displayed counterexample
and root integration remain later C03 steps; binary-input and combined Lemma 2
remain C05. The proof follows the approved route; no contract revision or new
omission, decision gate, discoverability issue or Future Work Note is needed.

**Initial validation:** The production and S01 regression build passed (2758
jobs). The root plus C01/C02/C03 regression aggregate passed (2763 jobs), and
`lake build` passed (2759 jobs). The signature/trust probe passed; all three
public declarations use only `propext`, `Classical.choice` and `Quot.sound`.
The required placeholder scan found no matches. The B comparison confirms
unchanged pre-existing Lean, root, configuration and pinned dependency files;
the normative plan digest is unchanged. No files are staged or tracked generated
artifacts introduced. Local document-link checks passed. Git's existing
LF-to-CRLF notices are not source changes. A parent-side consistency check led
to including the new regression target in README and correcting the roadmap's
approval summary before self-review.

**Review:** Contextual self-review was retained before a separate reassessment;
no further change was justified. The neutral request was sent once to the bound
reviewer. Its empty immediate result remains `UNCERTAIN`; the observed complete
original report supplied a separate delivery confirmation, then was accepted
and explicitly reconciled. Reviewed R is
`bb7f3ce10e1efbe41fbdf0f58f5b8eda087a4b4716d180ea39bc902256c15f57`;
original report capture is
`56b7ec24067d744e17d060627e70b92bb0d29cff66dfff2c005894abbe88ac78`.

The independent reviewer satisfied C03-S01-C01/C02/C03 with no new findings.
It independently checked the exact manuscripts, proof and regressions, compiled
the 2763-job aggregate and 2759-job full build, and ran a signature/API/trust
probe and the placeholder scan. All passed. It confirmed that both earlier
plan-review corrections are present, without rewriting the original report or
claiming a separate revision-2 plan review. All 68 reviewed real files matched
at entry and exit. The parent agrees with its assessments on the stated evidence.

No mathematical correction is needed after R. Only current review/validation
status and documentation are finalized before F; Lean, tests, dependencies and
the normative plan remain unchanged. Final validation rechecks actual current
source, B/R attribution and documentation; the earlier trust checks apply through
identical Lean/dependency bytes, without claiming a new trust-probe execution.
Exact final checks, criterion assessments, F and supported S01 closure belong to
`.pfr-review/chunks/PFR-C03/execution/`. Private setup captures use
`.pfr-review/setup/c03-s01-20260911-`. Those records remain durable and are not
scratch cleanup. No later step, commit or push starts from this closeout.

## S02: finite relabeling and unused-output extension

**Status:** S02 durably complete. At S03 start, actual closure
`d92835f9b9772e7558881bba43361716781ba517fe801b203efcb7b0d1ed7c02`
and its accepted original report/reconciliation were inspected read-only.
All three criteria were satisfied, no obligations remained, and all 68 real
files and the environment exactly matched S02 F
`56d48591ec27e11c5a272262b3fd02a1994c61a9c7c6e19810fba835cb0e9b85`.
The historical pre-F wording did not imply missing closure.
Only S02 was accepted after verifying the lead's prerequisite condition.
The existing C03 reviewer and originating-parent association remain unchanged.

**Baseline:** S02 B is
`2ef745b32128b46b9696359274843c2c396ed953b37f6b409948447ef7f0a4ec`.
It captures S01's final working bytes, including inherited C01/C02 work, at the
same HEAD. S02 appends to the two Singularity modules and updates these notes
and concise canonical status records; cumulative changes since HEAD are not
S02's contribution. The approved normative plan digest remains unchanged.

**Source and interpretation:** ISIT Section II's support-label convention,
Definition 2's common posterior, and the relabeling/unused-output boundary needed
for II-B Lemma 2; extended version 16 Appendix A's two-output normalization
clarifies the boundary. Both manuscript hashes were freshly checked and match
the approved plan. No binary proof is developed in S02.

| New public declaration in `Semantics/Singularity.lean` | Contract |
| --- | --- |
| `isSingularChannel_map_iff` | Singularity iff for an injective output map |
| `isPerfectlyRepresentableChannel_map_iff` | Complete common-posterior perfectness iff for the same output map |
| `isSingularChannel_relabel_iff` | Singularity iff under `kappa (eX.symm x')` followed by output map `eY` |
| `isPerfectlyRepresentableChannel_relabel_iff` | Perfectness iff in that orientation, transporting the whole witness |

All source/target alphabets carry the approved `[Finite]` public boundary in
independent universes. Perfectness requires only `Nonempty` source input and
transfers target input nonemptiness through the equivalence. The proofs need no
public enumeration, default output, prior, full support or decidable equality.
Production imports remain only `Semantics.Canonical`; root integration is S06.

**Proof route:** For output injection `j`, choose a left inverse `r` internally.
A row's nonempty support supplies the necessary nonempty output type, so the
construction does not add a public assumption. Forward transport maps the
whole vector by `w ↦ j ∘ w`, and transports posterior `V (r y')` by the same
map. Reverse transport maps the whole vector by `w ↦ r ∘ w` and transports
posterior `V' (j y)` by that map. In both directions, pushing each complete
coordinate/vector joint through the corresponding pair map proves factorization
directly using `r (j y) = y`. Arbitrary values of `r` off the image only complete
null-output posteriors. This shorter route avoids unnecessary production support
machinery while proving the same required contract. R05 separately checks the
approved support claim and recovery of the supplied full vector law.

Input reindexing uses one private one-way precomposition helper, transporting
both `q` and every posterior by `w ↦ w ∘ f`; it is applied to each direction of
the input equivalence. No input-deletion iff or general public transport framework
is introduced. Four public theorems suffice; identity equivalences provide the
one-sided consumers without extra aliases.

**Verified reuse:** C02's `isCanonicalCoupling_of_coordinateFactorization` and
`coordinateFactorization_congr_posterior`; pinned `PMF.map_apply_of_injective`,
`PMF.map_apply_eq_zero_of_notMem_range`, `PMF.mem_support_map_iff`, `PMF.map_comp`,
`PMF.map_bind`, `PMF.bind_map`, `PMF.map_id`, `PMF.channelJoint`, and
`Function.leftInverse_invFun`. Focused compiling probes preceded maintained
use. No generic information-theory result or parallel probability construction
was recreated, and no new discoverability issue arose.

The fixed session's explicit dependency inventory does not infer transitive
imports. S02 additionally inspected pinned mathlib
`Probability/ProbabilityMassFunction/Constructions.lean` and
`Logic/Function/Basic.lean`, which supply the actual map/bind and inverse APIs.
Their exact hashes are retained with the S02 validation evidence and supplied
as additional read-only source references to review; no frozen scope or pin is
silently changed. The clean pinned checkout is rechecked alongside these files.

**Regressions:** R04 checks explicit full joint/posterior relabeling, an inverse
vector-law roundtrip, four independent universes, both identity specializations,
and a three-cycle that distinguishes forward from inverse input orientation
with nontrivial output relabeling. R05 embeds Bool outputs using `some`, proves
the new `none` column is zero, checks both iff directions, and derives supported
coordinate range and full vector-law recovery from an arbitrary supplied
embedded factorization. It also permits any posterior PMF at the null `none`
output, including one with vectors outside the injection's image. These fixtures
and their proof machinery remain test-local.

**Allocation:** No S03 active-output restriction, S04 binary sufficiency, S05
counterexample, S06 integration or S07 closeout begins. C05 keeps binary-input
and combined Lemma 2. No contract revision, new omission, decision gate or Future
Work Note is needed; only the advisory proof route is simplified.

**Initial validation:** The production module compiled, then the root plus all
C01/C02/C03 regression targets passed (2763 jobs), and `lake build` passed
(2759 jobs). The four new public signatures have exactly the stated hypotheses
and independent universes; their trust audit uses only `propext`,
`Classical.choice` and `Quot.sound`. The corrected regression build has no
warnings. The source audit compares against S02 B, including byte preservation
of S01 after removing only the appended S02 sections. The required placeholder
scan and Git staging check passed. Local file-link checks found no missing
targets. The retained read-only self-review found no required correction; a
separate reassessment confirmed that no additional API or proof machinery was
justified before independent review.

**Independent review and reconciliation:** The existing reviewer received the
neutral request once. Its empty immediate result remains `UNCERTAIN`; the full
original native report supplied separate report-backed delivery confirmation.
Reviewed R is
`2a402be99014b98aadd22f3cb5ba109c4ddfde03378293fa5bcc4a09baee8bbf`;
accepted original capture is
`55cdf6b6cc278382bf9a02b6a17a8a66a8ee1fb89fdf46773ef27ab5b4cfd701`;
explicit reconciliation is
`7ebf6b12875f983a5bbd8a64a9dd669a69c81878ce19a44c338f5d810a2e06da`.

The reviewer independently satisfied C03-S02-C01/C02/C03 with no findings. It
checked the exact manuscripts, full proofs and regressions, all 68 real inventory
files at entry/exit, both supplemental dependency hashes, and preservation of
the S01 prefixes against its earlier reviewed identities. Its 2763-job aggregate,
2759-job full build, placeholder and hygiene checks passed. The original
four-theorem signature/axiom probe took unusually long but completed with exit 0
and only the standard three axioms; no process was interrupted or probe replaced.
Its generic negative-transport consumer is a check of this API, not the S06 R15
counterexample consumer. The parent agrees with the report on the stated evidence.

**Finalization:** No mathematical correction is required after R. Only review
status and stale current coverage/remaining-duty sentences are updated. The
formalization map now distinguishes implemented transport from the S03/S04
support/binary duties, and the living summary points to actual current coverage.
Final checks compare B/R/current bytes, verify the revised documents and source
hygiene, and establish continued applicability of both parties' successful
build/trust checks through identical Lean, regression and dependency bytes.
No additional build or trust-probe execution is claimed merely from that reuse.
The exact final evidence, assessments, F and supported closure are retained in
`.pfr-review/chunks/PFR-C03/execution/`, with setup captures under
`.pfr-review/setup/c03-s02-20260911-`. Included documents remain unchanged after
F. S03-S07 are unstarted; this step includes no commit, push or dependency change.

## S03: active-output restriction and support interpretation

**Status:** S03 durably complete. At S04 start, actual closure
`977d743955ac2521f37138220cbe3cad7e6ac8b33ab225282ee818bdc231d567`,
all three satisfied criteria and the valid original report/reconciliation were
inspected read-only. No obligations remained, and all 68 real files, environment
and Git facts exactly matched S03 F
`a29c0cbcabe515f34f38a91650298e99d3b7e5dad35e12acd1fa4c9d82d4e106`.
Historical pre-F wording did not imply missing closure.
The conditional request was accepted only after the actual S02 closure and
current-source applicability check above. The persistent C03 reviewer and
originating-parent association are unchanged; only S03 is authorized.

**Baseline:** S03 B is
`1d89477648ecfa4891158dd9b3a2de00708cce14d3f9002f08499b44aabccdcb`.
It records S02's final working bytes at the unchanged HEAD. S03 appends to the
two Singularity modules and updates concise canonical state and these notes.
Cumulative changes since HEAD include inherited work and are not the S03 delta.
The normative approved-plan digest remains unchanged; only its reserved
editorial status block changes.

**Source and interpretation:** ISIT page 2 Section II's full-support labeling
convention and II-B Lemma 2's output boundary; designated extended version 16
dated 2026-09-03 Appendix A, part 3's two-output normalization on pages 12-13.
Both exact manuscript hashes were freshly checked against the approved plan.
The output alphabet counted intrinsically is the union over every channel row,
which a degenerate prior need not observe. The binary proof remains S04.

**Construction and reuse:** `activeOutputs` is the set of outputs in some row's
support. `restrictActiveOutputs` uses pinned mathlib `PMF.bindOnSupport` to attach
that membership proof to each supported atom. It neither renormalizes nor
chooses a default. The dependent bind's associativity and pure laws recover the
original PMF under subtype inclusion. The injective-map mass theorem then gives
exact row masses. Every restricted output is active, and an actual input row
supplies active-set nonemptiness when input is nonempty. These structural laws
need no finite enumeration or prior. Both finite predicate iff theorems reuse
S02's injection transport with `Subtype.val`; perfectness keeps C02's nonempty
input assumption and adds no output inhabitance or posterior parameter.

The generic prior/output-support formula is already pinned reuse:
`sndMarginal` is the public second-coordinate map abbreviation,
`PMF.channelJoint_map_snd` identifies it with `p.bind kappa`, and
`PMF.mem_support_bind_iff` gives the existential over `p.support`. Only the
full-support equality with `activeOutputs` needs a stable new public bridge.
C02's `inputSupportPrior`, its full support and inclusion law, and
`isPerfectlyRepresentablePair_channelJoint_iff_restrict_support` supply the
arbitrary-prior pair boundary without asserting intrinsic perfectness of
unobserved rows. No generic information-theory result is redeveloped.

**Allocation:** R06 checks mass/inclusion/activity and usable predicate iff
consumers. R07 distinguishes a degenerate Bool prior's output support from the
intrinsic union, recovers that union for full support, and consumes C02's exact
input-support pair bridge. R08's S03 portion covers positive active cardinality,
empty output impossibility and exact singleton restriction/inclusion. Its
perfectness consequences remain S04, as do all small-output sufficiency proofs.
Production ownership stays in `Semantics.Singularity`, with only the existing
focused `Semantics.Canonical` import; root integration remains S06. Binary-input
and combined Lemma 2 remain C05. No allocation, omission or contract revision,
new decision gate, discoverability issue or Future Work Note is needed.

| New public declaration | Boundary |
| --- | --- |
| `activeOutputs` | Intrinsic union of row supports |
| `restrictActiveOutputs` | Support-aware restriction to that subtype |
| `map_val_restrictActiveOutputs` | Inclusion recovers each original row |
| `restrictActiveOutputs_apply` | Exact mass at every restricted output |
| `activeOutputs_nonempty` | Set nonemptiness from nonempty input |
| `activeOutputs_restrictActiveOutputs` | Restricted active union equals `Set.univ` |
| `isSingularChannel_restrictActiveOutputs_iff` | Both directions, finite alphabets |
| `isPerfectlyRepresentableChannel_restrictActiveOutputs_iff` | Both directions, finite alphabets and nonempty input |
| `support_sndMarginal_channelJoint_eq_activeOutputs_of_fullSupport` | Full-support prior identifies the pair's output support with the intrinsic union |

The structural and support-only declarations retain independent universes and
need no finiteness. No extra public generic support wrapper, cardinality alias,
type instance or one-off proof helper is introduced. The fixed source inventory
does not infer imports. Additional transitive source references are independently
hash-recorded in validation: mathlib `Constructions.lean`, `Logic/Function/Basic.lean`,
`Data/Fintype/Card.lean`, and LeanInfoTheory `Shannon/InfoMeasures.lean` in the
same clean pinned checkouts. The frozen session inventory is not silently enlarged.

**Initial validation:** The focused 2758-job production/test build passed; two
test-local `letI` style notices and a long line were then corrected. The corrected
root plus C01/C02/C03 regression aggregate passed with 2763 jobs and no warnings;
`lake build` passed with 2759 jobs. All nine new public signatures matched the
stated assumptions, and their trust audit used only `propext`, `Classical.choice`
and `Quot.sound`. The exact prior-support formula was verified from pinned APIs,
and all R06/R07/R08 structural consumers compiled. B attribution preserves both
S01/S02 Lean bodies byte-for-byte after removing the appended S03 sections, all
other inherited captured source and the normative plan. Placeholder and Git
staging checks passed; no generated file is tracked or reference copied.

**Self-review and independent review:** The contextual read-only critique was
retained before a separate reassessment. Neither pass recommended a correction;
additional generic support/cardinality aliases or subtype instances were not
justified by current consumers. The generated neutral request was sent once to
the existing reviewer. Its actual empty immediate result remains `UNCERTAIN`;
the complete original native report separately confirmed delivery. Reviewed R is
`e93de2bb180afbb0d48cb608dbc76ef2ecd1e22a93266650f7d341b180ae88f4`;
the accepted original capture is
`1080bcd241348b740b02c50c500acc99d70e1fbf788fddb27ccd52452d92ce55`;
explicit reconciliation is
`fe2b3879153495f3051ab755e95f707fb237afbd5d68c70b3a1c913519f5771a`.

The reviewer independently satisfied C03-S03-C01/C02/C03 with no findings.
It verified all 68 real inventory files and four additional dependency hashes
at entry/exit, the exact manuscript versions and relevant pages, all proofs and
regressions, and the preserved S02 production/test prefixes. Its 2763-job aggregate
and 2759-job full build passed without warnings. The nine-declaration signature
and axiom probe completed with exit 0 and only the standard three axioms. Its
original single-worker process took several minutes and completed without
interruption or replacement. Placeholder, pin and repository hygiene checks
passed. The source inventory's derived environment was not independently
reconstructed; actual relevant toolchain/pin facts were separately checked.

The parent agrees with these assessments: support-aware restriction has exact
mass and inclusion laws; both iff directions preserve the complete S02 witness;
full-support and input-support boundaries express the intended support convention;
and R08 stops at the approved structural boundary. No mathematical correction
follows R. Only current review/status documentation is finalized before F.
Final source/document checks compare B/R/current bytes, verify links and hygiene,
and establish continued applicability of the successful parent/reviewer builds
and trust checks through identical Lean/test/import/configuration/pin bytes.
Reuse is not a claim to rerun those commands after documentation-only changes.

Exact final evidence, criterion assessments, F and supported S03 closure belong
to `.pfr-review/chunks/PFR-C03/execution/`. The uniquely named setup records use
`.pfr-review/setup/c03-s03-20260911-`; these are durable, excluded from scratch
cleanup. Included documents remain unchanged after F. S04-S07 are unstarted;
this step includes no commit, push or dependency change.

## S04: sufficiency for at most two active outputs

**Status:** S04 durably complete. At S05 start, actual closure
`31b3b1c083da92800fab6a93bdb5fd4faf2faebc6d56f14bf0eb549579e206e8`,
all three satisfied criteria, the valid classified original report and explicit
reconciliation were inspected read-only. No outstanding obligation remained;
all 68 real files, exact inventory/bytes, environment and Git facts matched S04 F
`c3eb28a2fd9ec257fc49653c81d32a1c92606c7fd598fdb4b4d5912c6eaa3494`.
Historical pre-F wording did not imply missing closure.
The conditional request was accepted after verifying actual S03 closure and
current-source applicability. Only S04 is active, with the unchanged persistent
C03 reviewer and originating-parent association.

**Baseline:** S04 B is
`eb5de615198d53012c8ae1a62daa9ab72858d729c235547d907d8340e9bab6fb`.
HEAD remains `54c1714d1a9a891939d6c9f7d38c0d05896b2c75`, with inherited dirty
and untracked work preserved. S04 appends to the two Singularity modules and
updates concise canonical status and these notes; cumulative changes since HEAD
are not its contribution. The normative approved-plan digest stays unchanged.

**Source:** ISIT page 2 Section II-B, Lemma 2's output clause; designated extended
version 16 dated 2026-09-03, Appendix A part 3 on pages 12-13, Equations (125)-(134).
Both exact manuscript SHA256 values were freshly verified against the plan.
The approved at-most-two-active interpretation uses S03's intrinsic union of all
row supports. The input clause and combined paper-facing Lemma 2 remain C05.

**Proof route:** A direct finite-cardinality dichotomy avoids selecting a Bool
enumeration. If some row supports two distinct outputs, the cardinality bound
makes that row positive at every ambient output. Singularity makes any other
row pointwise at most that row. A strict inequality would contradict their equal
total mass one, using pinned `ENNReal.tsum_lt_tsum`; hence all rows agree.
Otherwise every row's nonempty support is a singleton, and pinned
`PMF.eq_pure_iff_support_eq_singleton` identifies an actual pure output per row.
This is the same two manuscript branches, with normalization replacing the
strict-probability endpoint case analysis. Both outcomes and their complete
common-posterior witnesses remain required; no mathematical contract changes.

Identical-row and deterministic witness machinery remains private. Public iff
theorems expose ambient cardinality at most two and intrinsic active cardinality
at most two, with the latter using S03 restriction and both invariance bridges.
Necessity is S01's existing theorem. Public enumeration boundaries are the
approved `[Fintype alpha] [Fintype beta] [Nonempty alpha]`; the active subtype
uses an internal classical Fintype. There is no caller-supplied labeling, strict
mass hypothesis, prior, default output or canonical witness.

R08's S04 portion covers singleton active/ambient output and singleton input
within the small-output contract. R09 supplies nonuniform non-pure identical
rows and an actual common-posterior witness. R10 covers different deterministic
row outputs and one-output degeneration. R11 covers two active outputs in a
larger ambient type and transport through finite relabeling. Empty active/output
impossibility and the empty-input property boundary remain supplied by S03/S01.
No root integration, counterexample, matrix, information-theory redevelopment,
dependency change, allocation change or new omission/Future Work Note is needed.

| New public declaration | Contract |
| --- | --- |
| `isPerfectlyRepresentableChannel_iff_isSingular_of_card_le_two` | Perfectness iff singularity under `Fintype.card beta ≤ 2` |
| `isPerfectlyRepresentableChannel_iff_isSingular_of_activeOutputs_card_le_two` | Same iff under the intrinsic active-subtype cardinality bound; the subtype Fintype is internal |

The three private helpers are the dichotomy and the two actual witness
constructions. For a common row `p`, the vector law is
`p.map (fun y => fun _ => y)`, with posterior `pure (fun _ => y)` at output `y`.
For a deterministic map `f`, both the vector law and every posterior are
`pure f`. Pinned map-composition, pure-map, pure-bind and channel-joint definitions
prove the entire coordinate/vector factorization. Neither proof substitutes a
coordinate-marginal claim for C02's common-posterior requirement. The production
module still imports only `Semantics.Canonical`; tests keep all fixtures local.

Both public theorems intentionally retain the plan's explicit `Fintype` boundary
even where their proofs need only finiteness. The unused-Fintype style linter is
disabled locally for those two declarations only; no logical check or trust
setting is changed. The active theorem's proof explicitly exposes the proposition
after its internal Fintype let binder, avoiding accidental introduction of that
instance as the cardinality hypothesis.

**Initial validation:** The corrected focused production/test build passed with
2758 jobs and no warnings. The root plus C01/C02/C03 regression aggregate passed
with 2763 jobs, and `lake build` passed with 2759 jobs. Both new public signatures
retain independent universes and the exact approved assumptions; their axiom
audit uses only `propext`, `Classical.choice` and `Quot.sound`. R08's S04 cases and
R09-R11 compile, including both full common-posterior factorizations.
The first maintained build exposed the internal-let elaboration issue and style
notices described above; these were corrected before the successful checks.

The frozen source inventory does not infer imports. Six supplemental transitive
references from the same clean pinned checkouts are hash-recorded separately:
mathlib `Constructions.lean`, `Logic/Function/Basic.lean`, `Data/Fintype/Card.lean`,
`Topology/Algebra/InfiniteSum/ENNReal.lean`, `Logic/Equiv/Option.lean`, and
LeanInfoTheory `Shannon/InfoMeasures.lean`. This does not enlarge the frozen
inventory or claim that every transitive import was individually inspected.

**Self-review and independent review:** A contextual read-only critique was
retained before separate reassessment. Both passes kept the implementation:
the direct cardinality/normalization route proves both required branch outcomes,
and additional enumeration machinery or public witness helpers have no consumer
need. The generated neutral request was sent once to the existing reviewer.
The actual empty immediate result remains `UNCERTAIN`; the complete original
native report separately confirmed delivery and was accepted as `VALID`.
Reviewed R is
`36df2f9cceba2c33a4eac6499e581d77ce1142ce8aa2307f487cbaa6d8ced3fa`;
original capture is
`67cf8b4575dc959cc5a9c337c5fe350b382d4e4deeef1535adf6a7f2a3b1e664`;
explicit reconciliation is
`7839b0c2917543ba52a777fc3da06958b405d30468c0b91053baaa2d31b204c0`.

The reviewer satisfied C03-S04-C01/C02/C03 with no findings. It independently
checked both exact manuscript versions and the owning pages, both public
contracts, all three private proofs, both full witness factorizations and the
R08 sufficiency/R09-R11 regressions. Its 2763-job aggregate and 2759-job full
build passed without warnings; both public signatures and axiom audits passed
with only the standard three axioms. Entry/exit hashes matched all 68 real
inventory files and all six supplemental references. In-memory reconstruction
matched its previously reviewed S03 production and test hashes. Placeholder,
pin and repository hygiene checks passed. The derived environment was not
independently reconstructed; actual relevant toolchain and pin facts were
separately checked. No maintained source changed during review.

The parent agrees with those source-bound assessments. The proof route preserves
the approved content, all degeneracies retain the correct property boundary,
and the public active count remains intrinsic. No mathematical correction follows
R. Final edits only record the review and current status. Fresh B/R/current,
link and hygiene checks establish applicability of the actual parent/reviewer
builds and trust checks to identical Lean/test/import/configuration/pin bytes.
Reuse is not a claim to rerun those commands after documentation-only changes.

Exact final evidence, criterion assessments, F and supported S04 closure belong
to `.pfr-review/chunks/PFR-C03/execution/`. Uniquely named setup records use
`.pfr-review/setup/c03-s04-20260911-`; these are durable, excluded from scratch
cleanup. Included documents remain unchanged after F. S05-S07 remain unstarted;
no commit, push or dependency change is included.

## S05: the displayed singular nonrepresentable channel

**Status:** S05 durably complete. At S06 start, actual closure
`fac3d4ecc054406075237396f2797674d7dc8442f36a12a64fb54f80d5e04fe5`,
all three satisfied criteria, the valid original report and reconciliation were
checked read-only. All 70 real files, exact inventory/bytes, environment/Git facts,
normative plan, clean pins and reviewer binding matched F
`bd86bdbcd9e53da28f8c76af0af363539778dc986b55459af715cd90afccf97b`.
No outstanding obligation remained; pre-F prose did not imply missing closure.
The conditional request was accepted after verifying actual S04 closure and
exact current-source applicability. The persistent reviewer and its originating
parent association remain unchanged. Only S05 is active.

**Baseline:** S05 B is
`bae204ede417d6e9b56e698e8d0eac9649cb77a07c9c588c7a972baa6b6cb7c3`.
HEAD remains `54c1714d1a9a891939d6c9f7d38c0d05896b2c75`; inherited dirty and
untracked work is preserved. S05 owns the separate example and example-test
modules, the narrowly justified helper export below and concise documentation.
Cumulative changes since HEAD are not the S05 contribution.

**Source and representation:** ISIT page 2, Example 1, Equation (8); designated
extended version 16 dated 2026-09-03, Appendix A page 13, Lemma 7 and
Equations (135)-(146). Both manuscript hashes were freshly verified against the
plan, and both relevant pages were extracted and visually inspected. Rows are
inputs and columns outputs. Paper labels `1,2,3` become Lean `0,1,2` in both
coordinates. The displayed half/half rows remain exact `ENNReal` PMFs; no matrix
package, floating-point arithmetic or later characterization is involved.

The proof uses C02's prior-free common-posterior factorization, justified against
the source's uniform-prior Markov argument by its existing full-support bridge.
A supported canonical atom with first coordinate `0` must have second coordinate
`0`. Its third coordinate is `1` or `2`; the respective common-posterior support
conditions force first coordinate `1` or second coordinate `2`, giving both
contradictions. Atom positivity and coordinate support are explicit. The target
quantifies over every canonical law and posterior, not a selected coupling.

**Ownership:** `coordinate_eq_of_posterior_support` in `Semantics/Singularity.lean`
is exported for the genuine second consumer in the example. Its statement and proof
are unchanged; the S01 necessity proof continues to use it. This avoids copying
the same factorization-to-coordinate argument into the example. The added
docstring explains its semantics; no other S01-S04 proof or contract changes.
The promoted helper and existing semantic regressions passed the 2758-job build.
The example and R12-R13 remain separately importable. Root integration/R15 are
S06, fresh cumulative closeout is S07, and binary-input/combined Lemma 2 remain C05.

R13's compiling API probes verified both existing C02 boundaries. Any full-support
prior transfers assumed pair perfectness to the channel; the uniform prior is a
specialization. A point prior instead uses the input-support equivalence and an
explicit constant-vector law/posterior on that singleton support. The maintained
tests specialize these to the example. No new public pair theorem or
general representation-existence API is needed.

| New public example declaration | Contract |
| --- | --- |
| `nonrepresentable3x3` | The normalized `Fin 3 → PMF (Fin 3)` channel |
| `nonrepresentable3x3_apply` | Mass is zero exactly when `x.val + y.val = 2`, otherwise `1/2` |
| `nonrepresentable3x3_isSingular` | Intrinsic singularity of that exact channel |
| `nonrepresentable3x3_not_isPerfectlyRepresentableChannel` | Universal nonrepresentability, excluding every canonical law and common posterior |

R12 compares all nine entries with an explicit table independently of the
antidiagonal encoding, checks each row's finite sum is one, proves the active
set is all of `Fin 3`, and consumes both named property theorems. R13 checks
every full-support prior, the manuscript's uniform prior, and every point prior
on this fixed example. The positive point-prior witness lives only on the prior's
input support; it cannot imply perfectness of the original channel. The complete
negative proof extracts a positive vector atom from the first coordinate law,
obtains each relevant posterior atom through joint support, and invokes the
shared support lemma three times. No cancellation or candidate-law enumeration
is needed. Both contradictions are labeled with their source equations.

**Initial validation:** The maintained example/example-test/semantic-test build
passed with 2760 jobs and no warnings. The full root plus C01/C02/C03 regression
aggregate, including the separate example tests, passed with 2765 jobs; `lake
build` passed with 2759 jobs. The four example declarations and promoted helper
passed public-signature and axiom checks, using only `propext`, `Classical.choice`
and `Quot.sound`. The helper retains independent universes and its original
assumptions; the fixed example theorems have no added hypothesis.

Two runs of a disposable construction probe exposed `ENNReal` normalization and
noncomputability details. The maintained definition uses `ENNReal.add_halves`
with `two_mul` normalization and is explicitly `noncomputable`; its first
maintained build passed. Both failed probe results remain attributed to scratch,
not counted as successful checks. The R13 discovery probe also passed separately.
Eight supplemental transitive reference files are hash-recorded from the same
clean pinned checkouts: the six retained from S04, plus mathlib `Data/ENNReal/Inv.lean`
and `Algebra/BigOperators/Fin.lean`. This does not expand the frozen explicit
inventory or claim automatic import analysis. Only the two owned manuscript
renders and their empty directory were removed after inspection; original
manuscripts, inherited scratch and durable records are preserved.

**Review and reconciliation:** Read-only contextual self-review and a separate
reassessment recommended no mathematical correction. The generated neutral
request froze R
`06826158e44863c752a4378e0178b004f4db3fb69c0a5dc2a5e6ddb4823f99c1`.
The persistent C03 reviewer independently satisfied C03-S05-C01/C02/C03 with no
findings. Its original full report was captured as
`a4f753c3711e7aabc57520eca5764f013b0c40f16366dcceca7058c8bb3bdd39`,
classified valid and explicitly reconciled under
`9ce453c74b50a9c67a96f47da3df0eac393727f98c5eeb85e38f6aad99eb24e6`.
The original empty submission response remains uncertain; the correlated full
report supplies a separate delivery confirmation without rewriting that receipt.

The independent example/semantic regression aggregate passed with 2765 jobs;
the full build passed with 2759 jobs, without warnings. All five public
signature/axiom checks passed with only `propext`, `Classical.choice` and
`Quot.sound`. The reviewer rechecked both exact manuscripts, all 70 real source
files at entry/exit and all eight supplemental reference hashes. It independently
reconstructed the earlier S04 semantic bytes by reversing only the helper export
and docstring, confirming its statement/proof and every other semantic byte
were preserved. The placeholder scan was clear and pins remained clean.

The parent agrees with the source-based assessment: exact entries and
normalization, the universal quantifier and both support contradictions, genuine
helper reuse and R12-R13 satisfy the approved step. Earlier draft findings retain
their historical attribution; no criterion gap or mathematical correction
remains. A separate documentation check identified only the map's stale
"through S04" module description, now clarified to include the S05 helper export.
R-to-final edits concern documentation only. Current byte/applicability and
document checks govern reuse of the actual successful build/trust evidence;
those builds are not claimed as rerun after documentation updates.

Private B/R/F, report, reconciliation and closure records remain under
`.pfr-review/chunks/PFR-C03/`, with unique setup captures under
`.pfr-review/setup/c03-s05-20260911-`. These are durable and excluded from scratch
cleanup. Included documents remain unchanged after F. S06-S07 are unstarted;
no commit, push or dependency change is included.

## S06: integrated API and cumulative readiness

**Status:** S06 is durably complete under
`f228cae1eee80a5fd96845287e39e107648f90aef8ab4d9bfd3744b200865ae0`.
The original independent report is reconciled and all three criteria satisfied.
Its final snapshot and exact current applicability were checked before S07.
The conditional request was accepted once after verifying S05 closure and exact
current-source applicability. Only S06 was active for that request, with the existing C03 reviewer.

**Baseline:** B
`c5fbd7c85713b05198743ad9fbb98700547b487430eeaa8bb8a814e50efd995c`,
at unchanged HEAD `54c1714d1a9a891939d6c9f7d38c0d05896b2c75`.
Inherited work is preserved and distinct from this step's contribution.

The root now imports Singularity and describes its semantic guarantees. Existing
semantic regressions import only that production root, with one generic consumer
of `coordinate_eq_of_posterior_support`; every earlier proof remains intact.
The separate example regressions own R15: `Fin.castSucc` embeds the exact
three-output channel into four outputs, the new output has mass zero, and S02's
reverse perfectness implication transfers S05's universal negative. No public
fixture, new production theorem or second obstruction argument is introduced.

The [cumulative readiness audit](pfr-c03-readiness-audit.md) maps all 23 public
declarations, R01-R15, every C03-CC criterion and the reviewed source/omission
obligations to current proof content. The full production source and existing
regressions were read, and both designated manuscript binaries were freshly
hashed with relevant pages extracted/visually inspected. The audit explains
the necessity cancellation, identical/deterministic branch witnesses, full
posterior transports, effective output/prior boundary and both direct example
contradictions. It preserves C05's input/combined Lemma 2 and C06's matrix bridge.

The 23 existing public signatures and axiom dependencies were freshly checked
through the separate example production import: all pass, with only `propext`,
`Classical.choice` and `Quot.sound`. Root plus semantic tests passed with 2761
jobs, example tests with 2759 jobs, the complete aggregate with 2765 jobs and
`lake build` with 2760 jobs; all exited 0 without warnings. The R15 helper's
first disposable probe also passed without warnings or revisions. The maintained
R15 proof uses that checked reverse-transport route unchanged.

All nine supplemental transitive reference hashes are retained: the eight from
S05 plus mathlib `Data/Fin/SuccPred.lean`, inspected for `Fin.castSucc_injective`
and `Fin.castSucc_ne_last`. These factual references do not enlarge the frozen
explicit dependency inventory. An initial narrow source search included a
nonexistent mathlib `Data/Fin/Defs.lean` path; searching the actual directory
located both declarations in `SuccPred.lean`, followed by the successful probe.
No unverified name or failed search is counted as proof evidence. Only the three
owned inspected manuscript renders and their empty directory were removed.
The initial dynamic cleanup command was blocked before execution; explicit
verified literal-path, nonrecursive PowerShell removals succeeded.

S06 review assessed that readiness mapping; it does not
replace S07's separately authorized fresh cumulative assessment and closure.

**Self-review:** The retained read-only critique identified one nonmaterial
wording issue, `pfr-finding:c03-s06:self:stale-example-test-header`: the example
test header still said semantic test imports were unchanged. That was accurate
for S05 but became stale when S06 made the semantic tests import the root.
Separate reassessment chose to state the actual separate production-example
import boundary. Only that comment and these review notes changed; mathematical
proofs and imports were retained. No other correction was recommended.

The corrected example tests passed their 2759-job build without warnings before
the independent handoff. The self finding is resolved; final source evidence
refreshes that disposition after documentation changes.

**Independent review and reconciliation:** The neutral request froze R
`f901cde39f4abae8c132fb2d93751bbe09906c7592920c1e00a527017b96b8a7`.
The persistent reviewer satisfied C03-S06-C01/C02/C03 with no findings. Its
original full report was captured as
`125c03b2e30cd1f7c5b4af8d614da8b637da815145c987a5eb91d017b81fd7bf`,
classified valid and explicitly reconciled under
`e8491f3d711cfe90aec093c117e835e497a0176ea790a57b6e0435023d609a32`.
The original empty submission receipt remains uncertain; the correlated report
provides a separate delivery confirmation.

The reviewer freshly checked all 23 public declarations and current proof
content, all R01-R15 consumers, every C03-CC row, both exact manuscript binaries
and the documented omissions. Its aggregate/full builds passed with 2765/2760
jobs and no warnings. Separate root/example probes checked all 23 signatures
and axiom lists with only `propext`, `Classical.choice` and `Quot.sound`;
`Fin.castSucc` helper signatures and label preservation also compiled. Both
original probes completed after initially remaining pending; no rerun or
interruption is counted. All 71 real inventory hashes and nine supplemental
references matched at entry and exit, with clean pins and no placeholder matches.

The report retains a failed initial shorthand-plan lookup as `FAIL`. The reviewer
subsequently read the actual inventory-bound approved plan. The failed lookup
supports no satisfied criterion and is not relabeled successful. Exact private
approval, prerequisite closure and B/F provenance remain externally supplied to
the reviewer; the parent separately checked those durable records and current
applicability. Historical plan/S01-S05 advice retains its original attribution.

The parent agrees with the source-based assessment: the root exposes the 19
semantic declarations while the four example declarations remain separate;
R15 preserves labels and uses the reverse transport implication; the readiness
audit accounts for every approved criterion and omission. No new production
theorem, mathematical correction or criterion gap remains. A separate concise
documentation check also found the current status and downstream boundaries
consistent. R-to-final changes concern documentation only. Fresh source, link
and hygiene checks establish applicability of the actual successful build/trust
evidence; those checks are not claimed as rerun after prose-only changes.

Private B/R/F, original report, reconciliation, finding dispositions and closure
records remain under `.pfr-review/chunks/PFR-C03/`, with unique setup captures
under `.pfr-review/setup/c03-s06-20260911-`. S06's completed snapshot remains
immutable; S07's documentation changes are separately attributed below.
At S06 closure S07 was unstarted. No commit, push or dependency change was included.

## S07: fresh cumulative validation and closeout

**Status:** Fresh cumulative validation and independent review passed; the
original report was reconciled. Validation ready, with closure subject to the
durable execution record. No new mathematical implementation or subsequent
chunk is authorized by this step.

S06 closure `f228cae1eee80a5fd96845287e39e107648f90aef8ab4d9bfd3744b200865ae0`,
its original valid report, reconciliation and satisfied criteria were inspected.
S01-S06 are complete, with no unresolved finding or review/decision obligation.
S06 F `249f20a5623a0d6e85ae0b376f2b6fb3a5e75fe8325ab142eec04ac09e7ccdfb`
matched all 71 real files, exact inventory/bytes, environment, Git facts,
normative plan, clean pins and originating-parent/reviewer binding at acceptance.
S07 B is `c368387c3191b6a81b70c4bc19a660062d3ece1bf0e8ba40b15864442471d266`.
The actual lead message was processed once for S07 only; native message identity
remains unavailable and the local capture is explicitly labeled.

The initial apparent difference in `AGENTS.md` was an inspection impression,
not an actual source change: its bytes match S06 B, F and S07 B. A supplemental
read-only prerequisite audit overlapped the parent's authorized S07 acceptance;
its no-active-step/journal-stability guards therefore returned false while its
other 40 checks passed. The retained exact source comparison has no F/current
delta. Those two observations describe the actual transition, not missing S06
closure or an unresolved mathematical prerequisite.

The [readiness audit](pfr-c03-readiness-audit.md) now explicitly maps all 18 earlier
step criteria and the three S07 criteria, in addition to every C03-CC row,
R01-R15, public declaration and reviewed manuscript disposition. The parent
freshly read both production modules, both C03 regression modules and relevant
C01/C02 contracts. A separate helper's source-only 18-row audit found no concrete
mathematical/regression/import gap; it is supplemental evidence, not independent
review or fresh compiler evidence. Both exact manuscript hashes and targeted
page extracts were refreshed. Prior visual inspection applies to the identical
binaries; no new manuscript copies or renders are introduced in S07.

Fresh parent aggregate/full builds passed with 2765/2760 jobs and no warnings.
All 23 public signatures and axiom lists passed in Lean, using only `propext`,
`Classical.choice` and `Quot.sound`. The trust wrapper subsequently failed while
printing Unicode under cp1252; its complete UTF-8 JSON had already been saved.
An initial recovery parser failed because axiom lists span lines. Both actual
failures remain preserved, separately from the compiler result. The corrected
read-only parser verified all 23 lists, Lean exit 0, empty stderr and unchanged
sources without a Lean rerun. These wrapper/parser failures support no passing
criterion. Fresh source/document/hygiene checks precede independent handoff.
The nine supplemental dependency references remain read-only scope supplements;
the installed explicit inventory and pinned dependencies are unchanged. All
inherited work is preserved. Current mathematical and regression bytes are
unchanged from B; initial S07 edits concern only eight audit/status documents.
The required independent reviewer received the exact current source and
normative cumulative obligations, without parent history or private records.

**Independent review and reconciliation:** Read-only contextual self-review and
separate reassessment recommended no correction. The fresh independent request
froze R `656d7a07cca33325361f2bcffc4f31531f0a436eb1ef5f783877f2b5447ac426`.
The original full native report satisfied all three S07 criteria and explicitly
assessed every C03-CC row, all eighteen earlier step criteria, all R01-R15 and
every reviewed source/omission obligation. No finding was reported. Capture
`a6b9fcdaec67799d9eab623dca8d0d4969ca6edae4d77bd2130b9534734a09ef`
is valid and reconciled under
`94af5a12022657b5dd47aed94e6c0034ed2970312007c98f9a4376799191b199`.
The original empty immediate receipt remains uncertain; the correlated full
report supplies a separate delivery confirmation. Its exact saved UTF-8 bytes
were copied without reserialization and compared with the observed full native
payload; native display/file correspondence is not authenticated byte transport.

Independent aggregate/full builds passed with 2765/2760 jobs and no warnings.
Two new production-only probes checked all 23 public signatures and axiom lists,
with only `propext`, `Classical.choice` and `Quot.sound`. Both original probes
passed without reruns. Fresh manuscript hashes, extracts and visual checks,
all proof/consumer/import/omission assessments, clean pins and placeholder checks
passed. All 71 real-file and nine supplemental hashes matched at entry and exit.
The reviewer treats private authority/closure provenance as supplied, not
independently authenticated. Its first report-save command was rejected before
process creation with Windows error 206; subsequent bounded writes preserved the
complete report. That original FAIL remains and supports no satisfied criterion.

The parent agrees with all original assessments on their stated evidence. No
mathematical correction, criterion gap or independently reopened concern remains.
A separate helper's final-document checklist identified `project-scope.md`'s
inherited S01-only Current phase paragraph. Parent inspection confirmed the stale
milestone, while its mathematical scope and C05 allocation remained correct.
This nonmaterial status repair adds the ninth file to the recorded final edit;
it neither attributes a new finding to the reviewer nor changes an acceptance
contract. The reviewer's eight-document assessment is not relabeled as an
independent check of that later paragraph edit.

Final B/R/current source and document checks cover all nine status/audit files,
the unchanged mathematical/regression/configuration bytes and nine supplements.
Actual successful parent/reviewer builds remain applicable; no post-prose build
rerun is claimed. Private records use the unique `c03-s07-20260911-` setup prefix
and the existing C03 execution store. Included files remain unchanged after F;
only the supported durable closure completes S07 and C03. No later chunk starts.
