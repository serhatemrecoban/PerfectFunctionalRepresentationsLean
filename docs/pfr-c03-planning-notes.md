# PFR-C03 planning notes

These advisory notes accompany [Draft revision 2](plans/pfr-c03-singularity-binary-output-counterexample.md).
They record proposed proof routes and actual planning evidence, not theorem
implementation. The dated follow-up below records the later independent review;
it does not replace the original reviewer report. The plan owns acceptance criteria;
notes cannot change its scope, hypotheses or approval boundary.

## Proof routes and risks

### S01: necessity directly from the common posterior

Unpack C02's existing structural channel definition as `q, V, h`. For two
positive entries in column `y`, choose `w ∈ (V y).support`. The coordinate
graph `w ↦ (w x,w)` is injective. Positivity of the channel-joint atom and
graph support force `w x1 = y` and `w x2 = y`. Evaluation then gives
`q w = kappa xi y * V y w` for both inputs. Cancel the nonzero, finite
posterior mass using `PMF.apply_ne_top` and `ENNReal.mul_left_inj`.

This is the prior-free form of extended (105)-(110), using the factorization
C02 already obtained from the support-qualified Markov contract. Do not
reintroduce a full-support prior merely to cancel it again. No entropy or
`Real` conversion is needed. A support-saturation helper can remain private;
S05 may provide genuine consumer pressure for reusing it, which should be
assessed then rather than preemptively exposing an abstraction.

### S02/S03: transport full witnesses, then restrict outputs

For input/output equivalences transport canonical vectors by
`w ↦ eY ∘ w ∘ eX.symm`, push forward `q`, and transport the common posterior
under the same map and inverse output label. Check equality of the full
coordinate joint law; coordinate marginals alone are insufficient.

For an injective output map, the forward posterior on an in-range symbol is
the transported old posterior. Outside its range, any PMF on the new function
alphabet, for example the new `q`, gives a total completion. In reverse, the
coupling equations imply that every coordinate of each supported vector is
in range. A classical retraction can be used privately to pull back vector
laws and posteriors; equations are required only where output mass is positive.
Do not require posterior support information on unused outputs.

Assess the reverse implication early during authorized S02 work, before
investing in convenience interfaces. Supported-vector concentration is one
route; an equivalent recovery construction is acceptable. Keep the stated
hypotheses and unrestricted posterior completion at unused outputs. If a new
public assumption appears necessary, stop for plan-health review. This is an
advisory risk priority, not a fixed proof order, named helper or retraction.

The active restriction lambda was typechecked in a disposable probe:

```text
(kappa x).bindOnSupport (fun y hy =>
  PMF.pure (⟨y, ⟨x, hy⟩⟩ : {y // ∃ x, y ∈ (kappa x).support}))
```

It needs no normalizing denominator, finite type or default atom merely to
construct the PMF. The mass and inclusion theorems remain unproved C03 work.
Once inclusion recovery is established, S02's injective output invariance
gives the restriction iff. This ordering avoids proving two unrelated versions
of pruning. Generic dependent-bind bookkeeping should stay private. C02's
private input retraction is an implementation example, not a public API.

For the paper support interpretation, use `PMF.mem_support_channelJoint_iff` and
`PMF.mem_support_map_iff` on the output marginal. Full input support removes
only the input-support restriction from the existential. Under a degenerate
prior the union may shrink, which is precisely why the intrinsic theorem
counts all channel rows.

### S04: two-output classification and witnesses

On a two-element active type, suppose one row has positive mass at both
outputs. Singularity plus normalization rules out every pure row and then
forces every row equal to that row. Otherwise each row has singleton support
and is pure. The singleton-active case is already deterministic; zero active
outputs contradict a row's normalization. Work on `Fin 2` through a proved
equivalence if useful; no enumeration choice remains in the final contract.

For a constant-row channel `kappa x = p`, take
`q = p.map (fun y => fun _ => y)` and
`V y = PMF.pure (fun _ => y)`. For a deterministic channel
`kappa x = PMF.pure (f x)`, take `q = PMF.pure f` and `V y = q`.
These are advisory explicit witnesses to be proved, not existing declarations.
They avoid importing total variation, maximal coupling or a general mixture
construction. Keep their helper lemmas private unless actual consumers justify
promotion. This does not pre-implement C09's all-ones matrix theorem.

### S05: the direct support obstruction

The displayed half/half rows can be built with `PMF.ofFintype`; its required
finite sum is exact in `ENNReal`. Derive the entry equation once and use it
for the nine cases and positivity facts. No matrix package or floating point
calculation is needed.

Assume any perfect witness. The first coordinate law has mass `1/2` at `0`,
so `PMF.mem_support_map_iff` supplies a positive vector atom with `w 0 = 0`.
Factorization forces `w 1 = 0`, since rows 0 and 1 both assign positive mass
to output 0. The third coordinate is 1 or 2 by its row support. If it is 1,
the same support argument forces `w 0 = 1`; if it is 2, it forces `w 1 = 2`.
Both contradict the earlier equalities.

This is the logical content of extended Lemma 7's conditional-probability
contradictions, expressed using C02's common posterior. The uniform-prior
Markov interpretation is already justified by C02; R13 checks the resulting
pair consequence. The proof does not refute merely one candidate coupling.

## S06: negative transport integration consumer

R15 uses the label-preserving injection from `Fin 3` to `Fin 4`. The fourth
output has zero mass by the existing off-range map theorem. The future S02
singularity invariance supplies singularity of the embedded channel. For its
negative result, an assumed perfect witness for the embedded channel would
transport back through S02's reverse implication and contradict S05's universal
negative theorem. This checks their composition without repeating the direct
obstruction proof. Keep it anonymous in a separately built example/regression
consumer; the optional example-test module is available if needed for import
separation. It introduces no root import or public fixture hierarchy.

Do not require the additional active-pruning roundtrip suggested as an option
in the supplied review. R06/R07 already check that restriction bridge, while
R15 supplies the new negative use of output transport. Add a further consumer
only if implementation exposes a specific coverage gap worth its subtype
bookkeeping.

## Verified API search and focused imports

Discovery inspected actual Canonical/FunctionalRepresentation source, installed
LeanInfoTheory Probability/Shannon source, `docs/api-documentation.md`,
`docs/v0.1-public-api.json`, `home_page/docs/declaration_index.json`,
`home_page/module-guide.html`, `home_page/theorems.html`, and pinned mathlib's
PMF, finite-cardinality and `ENNReal` source. This is expected paper-specific
infrastructure, not a genuine discoverability incident; no new entry is needed
in the discoverability log.

Source ownership matters even when a declaration is already in the import
closure:

| Module or source | Verified existing API and contract |
| --- | --- |
| `LeanInfoTheory.Probability.Finite` | `PMF.map_apply_of_injective p hf a`: map mass at `f a` equals `p a`; `PMF.map_apply_eq_zero_of_notMem_range p hb`: off-range map mass is zero; `PMF.map_apply_equiv`; `PMF.eq_pure_iff_support_eq_singleton` |
| `LeanInfoTheory.Probability.FiniteChannel` | `PMF.channelJoint_apply p V y w`: mass is `p y * V y w`; `PMF.mem_support_channelJoint_iff`, projections, and support-qualified channel equality |
| mathlib PMF `Basic`, `Monad`, `Constructions` | `PMF.bindOnSupport p (f : ∀ a ∈ p.support, PMF beta)`, its apply/support/bind APIs; `PMF.mem_support_map_iff`; `PMF.support_nonempty`, `PMF.apply_ne_top`, `PMF.coe_le_one`, `PMF.tsum_coe`; pure/map composition APIs |
| mathlib PMF constructions | `PMF.ofFintype f (h : ∑ a, f a = 1)` for `f : alpha → ENNReal`, with `PMF.ofFintype_apply`; `PMF.bernoulli` is available but not required by the planned route |
| mathlib `ENNReal` | `ENNReal.mul_left_inj` cancels a right multiplier, `ENNReal.mul_right_inj` a left multiplier; both require nonzero and non-top conditions |
| mathlib finite set/type API | `Fintype.equivFinOfCardEq`, `Fintype.card_congr`, `Fintype.card_pos_iff`, `Fintype.card_le_one_iff_subsingleton`, `Fin.sum_univ_two`, `Fin.sum_univ_three` |
| Optional cardinality alternatives | `Set.fintypeCard_eq_ncard`, `Set.ncard_eq_two`, `Set.ncard_le_one_iff_subsingleton`, `Nat.card_coe_set_eq`; the draft chooses finite subtype cardinality, avoiding `ncard`'s infinite-set zero value |

Canonical imports only FunctionalRepresentation, whose focused upstream
boundary is `LeanInfoTheory.Shannon.SemanticBridge.Markov`. Start Singularity
with Canonical and add only justified foundational imports. The checked
active-output probe needed `LeanInfoTheory.Probability.FiniteChannel` and
`Mathlib.Data.Fintype.EquivFin`. The broad discovery probe also inspected the
opt-in `LeanInfoTheory.Probability.FiniteMixture`; that is discovery only and
the planned production proof does not need it.

## Initial planning evidence and limitations

This section records the initial planning stage before either review. The
review/revision reconciliation below gives the current status.

Evidence records under `.pfr-review/setup/` use prefix
`c03-20260911-01a08fa8-`. They retain the startup inspection, actual-byte planning
baseline, exact user authorization, pre-creation bootstrap intent, complete
native creation result, binding packet/result and readiness event. Installed
`bind` created its own C03 store; the store was not pre-created. The observable
identity is `/root/pfr_c03_reviewer`; originating parent is
`01a08fa8-5f40-7373-8680-bb6d477a90a8`. Requested Astra/ultra/no-parent-history
settings are separate from unknown effective backend settings. No plan review
or execution session was opened. Helper discovery is not independent review.

The read-only prerequisite helper checked the actual C02 approved contract,
all closure references, report/reconciliation records, frozen normative plan,
71 real F files and derived environment. Its complete report was retained
byte-for-byte as `c03-20260911-01a08fa8-prerequisite-helper-report.json`.
The parent inspected the corresponding sources and boundary, confirmed the
pins and manuscripts, and ran current builds. No C02 operation or record edit,
originating-task impersonation or historical reopening occurred.

The targeted existing-source build command was
`lake build PerfectFunctionalRepresentations.Semantics.Canonical PerfectFunctionalRepresentations.Tests.Semantics.Canonical PerfectFunctionalRepresentations.Tests.Semantics.FunctionalRepresentation`;
it passed with 2,758 jobs. The full `lake build` passed with 2,759 jobs.
Final hygiene checks have their actual outputs in the planning evidence and project log. These establish
the prerequisite source/build state, not the proposed C03 theorems.

Disposable API checks live under ignored
`tmp/codex-handoffs/c03-api-discovery-20260911-a/`, with retained copies/hashes
in private C03 evidence. `ActiveApiProbe.lean` passed, including the restriction
lambda. The first broad probe rejected speculative names `PMF.sum_coe` and
`ENNReal.toReal_inj`; those are not claimed as APIs. Its corrected distinct
probe uses `PMF.tsum_coe` and removes the unnecessary `Real` conversion lookup;
`ApiProbeVerified.lean` passed with exit 0. Actual final results are recorded
with the retained logs. No probe proves a
C03 production target. No generic helper was added to maintained Lean source.

Planning self-review and separate reassessment are parent work, retained in
private setup records. They are not a report from the persistent reviewer.
Mathematical construction/transport feasibility remains a plan-review subject;
a typechecked lambda or discovered declaration is not a completed proof.

## Review reconciliation and revision 2 — 2026-09-11

The registered C03 reviewer assessed Draft revision 1 in the existing
`plan-r1-20260911` session; its original report and parent reconciliation remain
preserved. See [project log entry 49](project-log.md#49-c03-draft-revision-1-independent-plan-review--2026-09-11).
The lead then supplied a separate advisory report attributed to a reviewer
working through the General Assistant and authorized selecting suggestions
from both reviews. Its original attachment is retained with user-supplied
provenance; it is not imported as a report from the bound C03 reviewer.

The registered review had five satisfied criteria and contradicted C03-PR04
because revision 1 cited nonexistent `PMF.support_channelJoint`. The earlier
probe did not check that name, making the blanket verification claim too broad.
The independent reviewer compiled `PMF.mem_support_channelJoint_iff` and the
output-support consumer successfully. Revision 2 now uses that actual API and
states the scope of probe evidence accurately. It also corrects the matrix
sentence's citation to the C06 allocation, leaving OM-037's meaning unchanged.
These are parent-checked draft corrections, not a retroactive change to the
original report or a new independent assessment of revision 2.

| Suggestion | Revision-2 disposition and reason |
| --- | --- |
| Correct the pinned support API and the broad verification claim | Applied; factual errors, with independently checked replacement evidence. |
| Correct the matrix sentence's OM-037 reference | Applied; cite C06 directly without changing source allocation or the stable omission number. |
| Clarify R08's S03/S04 ownership, suggested by both reviews | Applied within the existing row and matching step criteria; structural restriction facts precede sufficiency consequences. |
| Separate exact proof mechanics from logical content | Applied; retain both manuscript branches, supported-witness recovery and both direct contradictions, while permitting equivalent atom/case/helper organization. |
| Add one negative output-embedding consumer | Applied as R15 in S06; its dependencies already join there, so S05 and the public theorem surface stay unchanged. This is an explicit proposed acceptance addition. |
| Prioritize reverse output transport | Adopted as the advisory S02 watchpoint above; no mandatory helper, retraction or proof order. |
| Optionally add an active-pruning roundtrip to the negative consumer | Not required; R06/R07 already cover the bridge, and the extra subtype composition offers limited distinct coverage. Reconsider only for a concrete implementation gap. |

The seven steps and all mathematical contracts remain. No extra public API
wrappers, new generic transport framework, additional step or chunk reallocation
is selected. The exact revised proposal has not received independent plan
review or implementation approval. Any future requested review uses a fresh
plan session with the existing C03 reviewer; the revision-1 session and its
frozen contract remain historical. See [revision record](project-log.md#50-c03-draft-revision-2-after-both-reviews---2026-09-11).

## Lead guidance and S01 readiness — 2026-09-11

The lead endorsed the plan and emphasized that plans and procedures serve
clear mathematical goals and useful critique. During an authorized step, use
judgment to improve the approach and update the plan or notes when evidence
shows a better way. Explain the change and keep review applicable to the work
actually delivered. The revision policy is not a reason to persist with an
inferior proof route or to seek permission for routine adjustments. Preserve
original reviewed records and raise only substantive unresolved decisions
about mathematical intent, scope or acceptance. This is current lead guidance
for interpreting the plan and the installed procedure, not a workflow redesign
or authority to weaken the required mathematics.

S01 is technically ready: its prerequisite source, pinned APIs, precise
singularity/necessity targets and R01-R03 boundaries have no unresolved blocker.
The exact Draft revision 2 remains unchanged. The lead expressly asked not to
start implementation; no execution registration, step start or new review was
performed at that readiness checkpoint. See [project log entry 51](project-log.md#51-c03-lead-guidance-and-s01-readiness---2026-09-11).

The subsequent request to start S01 with review approved this exact revision
and started only S01. The approved necessity route is now implemented; current
validation/review and actual public names belong to the
[implementation notes](pfr-c03-implementation-notes.md). Other routes above remain
planning evidence, not claims of completed proofs.
