# PFR-C02 implementation notes

These are advisory planning and proof notes for
[the C02 plan](plans/pfr-c02-canonical-representations.md), initially
recorded with Draft revision 2 on 2026-09-10. Draft revision 3 is now approved
and S01-S07 are complete. S08's fresh cumulative independent review and
reconciliation passed; C02 is validation ready, with closure subject to the
durable S08 record.
The plan owns required results, assumptions, coverage and
acceptance; these notes cannot change them. Keep this file source-visible in
later review snapshots. Update a route here when evidence favors a better
method, recording why; log material decisions in the project log.

## S01 construction and reconstruction

The implemented canonical joint uses the pinned independent product and a
single evaluation pushforward. Its triple characterization reconstructs the
law from the first/third projection using equality of maps on support; this
one-consumer PMF bookkeeping is private. The pair projection reduces to the
existing `PMF.channelJoint`, so the support boundary reuses
`PMF.channelJoint_eq_iff_eq_on_support` directly. No finite or nonempty
assumptions enter S01. Production compilation passed; consolidated validation
and independent review are recorded in project log entry 40.

## S02 decoder-induced structural canonicalization

`decoderVector f z x = f (x,z)` keeps the paper's function vector explicit.
C01's `isIndependentOf_comp_right` supplies its independence; the S01
common-source equivalence then supplies evaluation decoding and canonicality.
The existential interface extracts a decoder through C01's structural
expansion, with no finiteness assumption on any carrier.

The full-triple characterization yields a common-source joint-law theorem;
its pair projection and the S01 support cancellation bridge identify supplied
channel rows exactly on input support. Full support is an explicit premise
for the all-row coupling. The vector-law identity is directly the existing
`PMF.map_comp`, so no public alias for generic PMF composition is added.

Changing a decoder on unused input rows may change the entire vector law.
Only the fixed pair and supported coordinate rows are forced to agree.
R04/R05 check these boundaries. S03 supplies information preservation and
finite canonical sufficiency at the finite-information boundary below;
structural canonicalization alone does not discharge OM-053.

The independent S02 report satisfies all three criteria with no findings.
Its fresh source elaborations and separate consumer confirm this route;
no mathematical correction or new abstraction was needed. Validation and
reconciliation details belong to project log entry 41.

## S03 information preservation and finite canonical sufficiency

The implementation applies C01 Equation (3) to the original and canonical
representations to derive Equation (7). Ordinary deterministic data processing gives
`I(Y;W) ≤ I(Y;Z)`. For the conditional inequality, apply
`mutualInfoOf_comp_right_le` to `(Z,Y) ↦ (F Z,Y)`, use
`mutualInfoOf_chain_rule_fst` and cancel the common `I(X;Y)`.
The opposing signs then force equality. The conditional contraction is a
private helper; the exact Equation (7) and ordinary contraction remain local
checked proof terms in `mutualInfoOf_decoderVector_eq`. No generic information
theorem or additional production import is introduced. Focused composed
probes and the production-only consumer compile against the pinned release.

The five public theorems provide chosen-decoder information equality,
existential canonical replacement preserving information, chosen-decoder
and existential fixed-perfect replacement, and the exact canonical-law
characterization of C01 pair perfectness. The forward characterization uses
the original triple as a probability source, then S02's joint/pair bridges;
the reverse uses C01's existing finite witness reindexing. No numeric
cardinality bound or new pair predicate is needed.

All information results retain finite value alphabets and an unrestricted
source. The function alphabet has an explicit caller-supplied
`[Fintype (alpha → beta)]`, derivable from finite `alpha` and `beta`.
This adds no mathematical restriction: it lets the conclusion use the
caller's enumeration instance instead of embedding a classical enumeration
inside information quantities. Probes verified that the latter alternative
needs an otherwise unnecessary instance-equality conversion in ordinary
concrete consumers. Equality and structural replacement expose only
`[Finite alpha]`; fixed-perfect results retain C01's `[Fintype alpha]`.
There is no infinite-auxiliary information claim. OM-053 records the precise
finite sufficiency now proved. The independent report satisfies all three
criteria with no findings; no mathematical correction or proof-route change
was needed. Validation and reconciliation belong to project log entry 42.

## S04 common posterior and support-aware Markov factorization

`IsPerfectlyRepresentableChannel` uses the approved single `q` and single
`V` before quantifying over all input rows, with `[Nonempty alpha]` and no
finiteness premise in its definition. First projection of each coordinate
factorization derives `IsCanonicalCoupling`; coupling is not stored as a
redundant conjunct.

Two private map/bind rewrites express the canonical triple and the posterior
extension as channel joints over the same input prior. The pinned
`PMF.channelJoint_eq_iff_eq_on_support` then proves the exact fixed-posterior
support equivalence, followed by its full-support specialization. The
forward Markov theorem works with arbitrary alphabets and every prior. The
fixed-coupling converse uses only `[Finite (alpha → beta)]` for the pinned
existential Markov factorization, then cancels the full-support prior. Its
coupling premise is essential to identify the supplied channel rows.

At the finite-information boundary, canonical structural representation
discharges C01's structural conjunct, yielding canonical perfectness iff
Markov and the common-posterior perfectness consequence. These theorems
retain the caller's function-alphabet `Fintype`, as in S03. No general
perfect-pair/prior equivalence is implemented in S04.

Posterior invariance follows from the same channel-joint support theorem
applied row by row. It needs agreement only on outputs used by some input
row. R08's point-prior counterexample is proved through supports: the null
input hides a row whose required posterior support conflicts with the used
row. R09 changes a posterior at a globally unused output and reuses the
invariance theorem. All additions retain the existing focused import.
Production, regression, consumer and default builds passed. The independent
review satisfied all three S04 criteria without a finding or mathematical
correction. Consolidated validation and reconciliation are recorded in
[project log entry 43](project-log.md#43-c02-s04-common-posterior-channel-property-and-markov-factorization---2026-09-11).

## S05 law reuse and prior equivalences

S01 already proves canonicality and the exact input, vector and pair laws for
`canonicalJoint p q`; an explicit universal-prior regression checks Remark 1
with the same specified coupling `q`. No duplicate bundled specification is
needed. The new `IsPerfectlyRepresentableChannel.exists_canonicalCoupling`
chooses one coupling before every prior and supplies perfect canonical joints
at the finite-information boundary. The all-prior pair consequence consumes
that shared witness and reuses C01's finite-auxiliary bridge.

For the converse, S03 supplies a finite canonical witness for the specified
pair. Its first marginal is the supplied prior. Full-support cancellation
recovers the actual channel coupling, and S04's perfectness/Markov and
fixed-coupling equivalences extract the common posterior. The every-prior and
some-full-support-prior equivalences instantiate the pinned uniform PMF;
two-full-support-prior invariance follows by composing the specified-prior
equivalences. C01 pair-law transport handles an unrestricted original source
without promising an auxiliary on that source.

The six pair-level theorem types do not expose the function-alphabet
enumeration, so it is derived internally from finite input/output alphabets.
Only `exists_canonicalCoupling` retains the caller's `Fintype (alpha → beta)`:
its result contains canonical perfectness at that enumeration. This removes
unused public hypotheses without changing the mathematical contract. The
uniform API is already available through the existing focused import.

R10 uses fair Bool and a prior with masses `1/3` and `2/3`, proves they differ
and both have full support, and instantiates the prior equivalence for an
arbitrary channel. Point-prior, singleton and globally unused-output cases
exercise the remaining boundaries. S06 support-subtype transport is unchanged.
The independent report satisfied all three S05 criteria without requiring a
mathematical correction. Validation and reconciliation are recorded in
[project log entry 44](project-log.md#44-c02-s05-prior-independence-and-full-support-pair-equivalence---2026-09-11).

## S06 input-support transport

The implemented `inputSupportPrior p` is `p.map r`, where a private total
retraction fixes supported inputs and sends other inputs to a chosen supported
point. PMF nonempty support supplies that point. The public full-support,
inclusion-pushforward and channel-joint compatibility lemmas need no finite
alphabet assumption. They use pinned PMF map/support/bind identities and the
existing private support-map equality helper; the retraction is not a type
identification or a conditional law on a null fiber.

The two-way perfect-pair bridge transports the same `Fin n` auxiliary across
input inclusion. For the reverse witness, its pair marginal proves the input
lies in the inclusion's range almost surely, so retracting then including
recovers the entire triple law. Private common-source helpers transport
independence and decoders through the left inverse. Conditional entropy is
preserved using pinned `entropyOf_comp_injective` for the input and the
input/output pair, followed by `condEntropyOf_eq`; the output/auxiliary mutual
information is unchanged. These helpers remain private for this one consumer.

`isPerfectlyRepresentablePair_channelJoint_iff_inputSupportPrior` exposes the
pair-law bridge, with a support enumeration where the conclusion needs it.
`isPerfectlyRepresentablePair_channelJoint_iff_restrict_support` then applies
S05 to the normalized full-support prior. The main theorem derives support
nonemptiness and enumeration internally; callers supply only finite ambient
input/output alphabets, the PMF and the channel. It concludes exactly the
restricted channel property, without recovering unused ambient rows.

Six public declarations (one definition and five theorems) retain the focused
Canonical import. R11 uses a prior on `Option Bool` supported on both `some`
values, proves exclusion of `none`, and changes the unused row while preserving
the restricted channel and pair property. A point prior and globally unused
output cover singleton support and null output fibers. Separate consumer
validation checks distinct universes and unrestricted structural alphabets.

The initial `bindOnSupport` constructor was only a checked type candidate;
the selected map/retraction constructor and finite witness route now compile.
The earlier optional 25-declaration probe remained cancelled, exit 1 with an
empty log, and did not verify a proof. S06's first witness scratch run failed
on elaboration details; the second passed with two style warnings and the
third passed cleanly. The first regression build passed with one unused simp
argument, which was removed. These intermediate observations remain retained
and are not substituted for the final successful validation.

Independent S06 review satisfied all three criteria. Its single low-severity
finding corrected stale quick-start coverage wording without a Lean change.
The authoritative implementation and
validation chronology is [project log entry 45](project-log.md#45-c02-s06-input-support-transport-and-arbitrary-prior-equivalence---2026-09-11).

## S07 integrated consumer boundary

The root retains Basic and FunctionalRepresentation and adds Canonical.
Canonical production keeps its single focused C01 import and all 51 public
declarations unchanged. Six R12 anonymous consumers use pinned PMF nonempty
support to exclude empty source/pair laws and empty-output channels, and
explicitly exercise the intrinsic predicate's nonempty-input parameter.
No generic PMF helper or new public theorem is introduced for these checks.

Complete root-only and Canonical-only consumers check all 51 signatures and
axiom sets, 27 family applications each, and the intended import boundary.
The [readiness audit](pfr-c02-readiness-audit.md) owns the cumulative mapping
and downstream contract; [project log entry 46](project-log.md#46-c02-s07-integrated-semantic-api-and-internal-milestone---2026-09-11)
owns actual commands, intermediate validation issues and review chronology.
S07 does not stand in for S08's fresh independent chunk assessment or closeout.

## S08 cumulative validation

The S08 baseline exactly matches S07's final source. No mathematical or API
repair was needed. The persistent reviewer's fresh cumulative assessment
satisfied the three S08 criteria and every CC01-CC11 criterion with no new
finding. The original report and explicit parent reconciliation are retained;
fresh source, manuscript, build, consumer and axiom checks support the result.
Earlier satisfactory reports did not substitute for this pass. C02 is
validation ready, with closure subject to the durable S08 record.
The [readiness audit](pfr-c02-readiness-audit.md) records current coverage;
[project log entry 47](project-log.md#47-c02-s08-fresh-independent-chunk-validation-and-closeout---2026-09-11)
owns validation, reconciliation and closeout chronology. C03 remains unstarted.

## Revision record

- 2026-09-10: Updated the support-transport reference to S06 for Draft
  revision 3's sequential numbering; proof advice is unchanged.
- 2026-09-10: Moved provisional S03 and support-transport methods out of the
  proposed execution contract. Retained both support-construction candidates
  without choosing an unproved route as a requirement. The initial discovery
  checks and their limitations remain in plan Section 10 and project log
  entries 36-38. No proof, independent review or implementation approval is
  claimed by these notes.
