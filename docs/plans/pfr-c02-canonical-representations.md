# PFR-C02 - Canonical Representations and the Channel Property

## Proposed detailed plan

<!-- pfr-review-status:start -->
**Status:** Active
**Revision:** Draft revision 3, 2026-09-10
**Authorization:** The lead approved the presented revision by requesting Step 1 with review on 2026-09-10.
**Independent plan review:** Not requested or dispatched; this authorization requests step review.
**Implementation:** S01-S07 complete; S07 durable closure is `ce2c908fc2bce919b37862383c2561dfa72e0f1d966be09808870eb423234418`. S08 was separately authorized on 2026-09-11 through the conditional request after S07 closure. Its fresh cumulative independent review satisfied all fourteen criteria with no new finding; the original report was retained and explicitly reconciled. C02 is validation ready, with closure subject to the durable S08 record. C03 and later chunks are unstarted and require separate authorization.
**Execution baseline:** HEAD `54c1714d1a9a891939d6c9f7d38c0d05896b2c75` plus actual working bytes captured as S01 B `7512076a5f11e8bd85bb17692b59b5035c4cf05ce63bf3cfb8f4dd5d463e392c`.
**S02 baseline:** Same HEAD plus actual working bytes captured as B `386c8cddddd1e3b4b63a6ff73f22a7ffbdef0f309f79bc7a068c8e1f9d6b8e79`; source matches S01's final snapshot before S02 edits.
**S03 baseline:** Same HEAD plus actual working bytes captured as B `ae8817b997e10eb25cecc097e000bc4c243089372ffe4f12341df007d5d570f4`; source matches S02's final snapshot before S03 edits.
**S04 baseline:** Same HEAD plus actual working bytes captured as B `68906798263b50e1e5440bd810e03a4dd8856cba52e8b02b566212d99b556bb0`; source matches S03's final snapshot before S04 edits.
**S05 baseline:** Same HEAD plus actual working bytes captured as B `bf1addeed12a12d569c60e909b202760f6b6db0d626be4bb59aa13e98f01d532`; source matches S04's final snapshot before S05 edits.
**S06 baseline:** Same HEAD plus actual working bytes captured as B `ad6c18f748712b342dce18091c8e573e5a39c53758089c35baeb417ac36ed585`; source matches S05's final snapshot before S06 edits.
**S07 baseline:** Same HEAD plus actual working bytes captured as B `1b2da4baeaacb6fdba5e431042cdce03016ed4992369944669243fbacdb3f1d4`; source matches S06 F before the approved root integration and empty-boundary checks.
**S08 baseline:** Same HEAD plus actual working bytes captured as B `abbad8581e59e2b16f0e482bd3fb58d5f29af711e10b4f243b81aeea13b84dc0`; source matches S07 F exactly before closeout documentation and fresh cumulative validation.
**Chronology:** Proposal/status statements in the original drafting narrative below describe preparation before this approval; its mathematical contracts are unchanged.
<!-- pfr-review-status:end -->

This is a concrete proposal for project-lead consideration, not an approved
execution contract. Its location under `docs/plans/` does not grant authority.
Approval must identify the exact revision; a favorable plan review also awaits
explicit lead approval. Each later implementation prompt authorizes one step
only. The editorial block above is reserved exclusively for status and dated
chronology; no mathematical requirement may be moved into it.

The contracts and acceptance criteria below fix required outcomes. Provisional
proof organization and implementation choices are kept in the separate
[implementation notes](../pfr-c02-implementation-notes.md); they may evolve
under Section 9 without changing these outcomes. Those notes do not add
requirements or confer implementation authority.

## 1. Baseline, references, and prerequisites

### 1.1 Repository and dependency evidence

Planning inspected checkout HEAD
`54c1714d1a9a891939d6c9f7d38c0d05896b2c75`. This is a planning baseline,
not a new execution checkpoint. The checkout already contained modifications
to `.gitignore`, `AGENTS.md`, the living summary and project log, plus the
untracked installed review documents and `tools/pfr_review/`. Preserve those
changes; compare future step B snapshots with actual working bytes, separately
from cumulative Git changes. No staging, commit, push, or dependency change is
part of this plan's preparation or implicit in its approval.

The installed read-only inspection recognizes C01 as historically complete:
its four Lean files match closeout commit
`60913637e7a8a982730112415cfd9ddeea59d367`, which is an ancestor of HEAD.
C01's current plan status is `Complete`. This is prerequisite evidence, not a
retroactive review-workflow certificate. No discrepancy requiring C01 reopening
was found. The public boundary is
[C01 Section 14](pfr-c01-semantic-functional-representations.md#14-completion-criteria-and-downstream-boundary).

Keep immutable LeanInfoTheory `v0.1.0` at
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`; the installed checkout is clean
and matches the manifest. Lean is `v4.33.1`; pinned mathlib is
`0df444a360eaa60ab8c11dca51a86af692955474` (`v4.33.1`), also clean.
Information quantities use the existing `Real`-valued nats API.

### 1.2 Exact manuscript anchors

Both local binaries were authenticated and their relevant PDF page 2 was
extracted and visually inspected on 2026-09-10. Manuscripts and renders remain
private, outside maintained source.

| Source | Exact identity and consulted coverage |
| --- | --- |
| Six-page ISIT manuscript | SHA-256 `48963AA59485B2C33B1A1E6E7C6EAD2251FDDDD26BD3691B6FCFFE683E6ED1C4`; PDF p. 2, Section II support convention and II-A in the left column, continuing through the prior-independence paragraph at the top of the right column before II-B |
| Current eighteen-page extended draft | SHA-256 `98636D4C9F0618EC08FCA84559572780F604F197FDA90D8D7C787B3624245B8F`; designated 2026-09-03, local version 16; PDF p. 2, Section II and II-A through the paragraph preceding II-B |

Exact C02 anchors are Equation (5), all four properties immediately following
it, Definition 1, Remark 1, Lemma 1 with Equations (6)-(7) and its sign argument,
the canonical-sufficiency paragraph, Definition 2, and the following
factorization/Markov/perfect-equality/channel-only paragraphs. The companion
confirms this same content; no extended-only theorem is added. Revalidate
affected contracts if the lead designates a replacement companion.

### 1.3 Existing local guarantees

Reuse the public structural predicates and `isFunctionalRepresentationOf_iff`
for support-correct decoder extraction; `isIndependentOf_comp_right`; full
triple-law transport; Equation (3); fixed-perfect equality/CMI/Markov
equivalences; pair-law transport; and the arbitrary-finite witness bridge into
`IsPerfectlyRepresentablePair`. The `Fin n` auxiliary in that existential
predicate permits a separate triple-law extension, in arbitrary auxiliary
universes through the bridge. It does not require a witness on the original
probability space. C01's private map, permutation and reindexing helpers are
not available downstream API. C01 proves neither canonicalization nor a
channel property, common posterior, generic optimizer, or infinite-alphabet
information theorem.

## 2. Scope, assumptions, and proposed decision-gate resolutions

The objective is to make the paper's canonical reduction and prior-independent
channel property precise and reusable by C03, C05, C06, C09 and C11. No
singularity, binary optimality, finite total variation, matrix operations,
reachability, LP, complexity, generic representation-existence theorem, or
extended-only application is included.

The following resolves DG-02 and DG-03 **only if this exact plan is approved**.
Both gates remain open while this document is proposed.

**DG-02 proposal.** Use a function alphabet `alpha → beta` for a canonical
vector. Distinguish its coordinate coupling law from a canonical
representation of a fixed pair. The latter must retain independence and
`Y = W X` on source support, and hence the correct pair/triple law. The
coordinate laws determine a channel on all declared inputs; a given pair law
identifies those rows only on its input support.

**DG-03 proposal.** A channel is perfectly representable when a single
canonical law and a single posterior factor every coordinate joint law.
The predicate has no input prior. Prove the bridge to full-support-prior
Markov and pair-perfectness statements, the forward implication for every
prior, and the support-restricted converse for degenerate priors. Null-output
posterior values are arbitrary and unobservable in these joint laws.

Structural definitions and decoder-induced constructions should remain
type-generic wherever their formulas permit it. Information equalities and
C01 perfectness bridges use `[Fintype alpha] [Fintype beta] [Fintype gamma]`
as applicable; the source `omega` remains unrestricted. Internal finiteness
may use `[Finite]`. Finiteness of `alpha → beta` is induced by finite input
and output alphabets, not by a new auxiliary enumeration choice.

For the intrinsic channel predicate and its paper-facing channel theorems,
require `[Nonempty alpha]`. This records the manuscript's positive input
cardinality, prevents vacuous universal-prior characterizations on an empty
input type, and lets an actual row `kappa x : PMF beta` supply output
inhabitedness. Do not add a full-support output assumption or a separately
chosen default output to public contracts. Lower-level coupling/structural
definitions need not require nonempty or finite types.

## 3. Intended mathematical contracts

Notation in this section specifies proposed mathematics, not installed Lean
declarations. `mu` denotes a source PMF, `p : PMF alpha` an input law,
`kappa : alpha → PMF beta` a channel, `q : PMF (alpha → beta)` a canonical
law, and `r : PMF (alpha × beta × gamma)` a right-associated triple law.
Write `eval x w = w x`, `pX = mu.map X`, and use pinned marginal operations.
"Full support" means `∀ x, x ∈ p.support`; no new bundled full-support type
or global typeclass is proposed.

### 3.1 Canonical law and fixed-pair semantics

Proposed construction and predicates:

```text
IsCanonicalCoupling kappa q := ∀ x, q.map (fun w => w x) = kappa x

canonicalJoint p q :=
  (indepProd p q).map (fun xw => (xw.1, xw.2 xw.1, xw.2))

IsCanonicalFunctionalRepresentation r :=
  IsIndependent (fstThirdMarginal r) ∧
    ∀ t ∈ r.support, t.2.1 = t.2.2 t.1
  -- here gamma is alpha → beta

IsCanonicalFunctionalRepresentationOf mu X Y W :=
  IsCanonicalFunctionalRepresentation
    (mu.map (fun s => (X s, Y s, W s)))
```

Required bridges:

- The common-base predicate expands to independence of `X,W` and evaluation
  decoding on `mu.support`; it implies C01 functional representation.
- `canonicalJoint p q` is canonical, has first marginal `p`, third marginal
  `q`, and first/third joint law `indepProd p q`.
- A canonical triple is exactly `canonicalJoint` of its first and third
  marginals. This characterization transports fixed-pair canonicality by
  the full triple law without inventing a chosen decoder.
- If `q` is a coupling for `kappa`, the first-two marginal of
  `canonicalJoint p q` equals `PMF.channelJoint p kappa` for every `p`.
- More exactly, that pair marginal equals `PMF.channelJoint p kappa` iff
  `q.map (eval x) = kappa x` for every `x ∈ p.support`. Under full support
  this is equivalent to `IsCanonicalCoupling kappa q`.

The last equivalence is the explicit boundary between the pair and channel
contracts. Coordinate marginals alone never assert the fixed pair's decoder.

### 3.2 Decoder-induced canonicalization and Equation (5)

Given `IsFunctionalRepresentationOf mu X Y Z` and any support-correct decoder
`f : alpha × gamma → beta`, define
`F z x = f (x,z)` and `W s = F (Z s)`. Prove independence, support-correct
evaluation decoding, and fixed-pair canonicality. This is valid without
finiteness of the source or original auxiliary. The induced law is
`q = (mu.map Z).map F = mu.map W`, and its induced channel is
`x ↦ q.map (eval x)`.

If the original pair law is `PMF.channelJoint pX kappa`, prove equality of
these coordinate laws with `kappa x` on `pX.support`; full support gives
all rows. Do not constrain `f` on unused input rows to recover a supplied
channel's arbitrary null-prior rows. An existential wrapper must extract a
decoder from C01, with no caller-supplied decoder assumption in the final
canonicalization theorem.

### 3.3 Lemma 1, Equation (7), and finite canonical sufficiency

With finite `alpha`, `beta`, `gamma`, the canonical `W` above satisfies
`mutualInfoOf mu Y W = mutualInfoOf mu Y Z` for every support-correct
decoder. Preserve the source proof's content:

```text
I(Y;Z) - I(Y;W) = I(X;W | Y) - I(X;Z | Y).
I(Y;W) ≤ I(Y;Z), and I(X;W | Y) ≤ I(X;Z | Y).
```

Equation (7) and the conditional contraction are checked internal proof
content, not promises of new generic public APIs. The displayed identity,
both signs and the equality are required regardless of the chosen proof
organization; a particular sequence of rewrites is not an acceptance target.

Export an existential canonical representation theorem preserving the
original pair on the same source and preserving `I(Y;Z)`. Also export the
perfect-auxiliary consequence and the following pair-law characterization:

```text
IsPerfectlyRepresentablePair pXY ↔
  ∃ q : PMF (alpha → beta),
    fstSndMarginal (canonicalJoint (fstMarginal pXY) q) = pXY ∧
    IsPerfectFunctionalRepresentation
      (canonicalJoint (fstMarginal pXY) q).
```

This justifies finite canonical witnesses for C01's already approved finite
information contract and permits the C01 `Fin n` witness interface to remain
unchanged. Structural canonicalization accepts arbitrary `gamma`; the
information equality does not thereby become an infinite-alphabet theorem.
No blanket entropy finiteness, optimizer attainment, general existence theorem,
or additional public numerical cardinality-bound theorem is asserted.

### 3.4 Common posterior, Definition 2, and fixed-prior factorization

The proposed public channel predicate is:

```text
IsPerfectlyRepresentableChannel kappa :=
  ∃ q : PMF (alpha → beta), ∃ V : beta → PMF (alpha → beta),
    ∀ x, q.map (fun w => (w x, w)) = PMF.channelJoint (kappa x) V
```

It requires nonempty input as specified in Section 2, but its defining
formula does not need finite alphabets or information quantities.
Project the displayed equality to prove coordinate coupling; do not store
that consequence as a redundant conjunct. The same `V` must serve every
input, not `∀ x, ∃ V` and not a posterior chosen separately under each prior.

For a fixed `q,V`, prove the exact support-aware factorization equivalence:

```text
canonicalJoint p q = PMF.channelExtension (PMF.channelJoint p kappa) V
  ↔ ∀ x ∈ p.support,
      q.map (fun w => (w x,w)) = PMF.channelJoint (kappa x) V.
```

Rewrite both triples as channel joints over `p`, then reuse
`PMF.channelJoint_eq_iff_eq_on_support`. No duplicate ENNReal cancellation
theorem is needed. Full support upgrades the right side to all inputs.
Using the verified Markov/channel-extension equivalence, for a coupling `q`
and finite function alphabet prove:

```text
(∃ V, ∀ x, q.map (fun w => (w x,w)) = PMF.channelJoint (kappa x) V)
  ↔ IsMarkovChain (canonicalJoint p q)    [p has full support].
```

The forward implication is valid for arbitrary `p`. Use C01's structural
plus Markov equivalence to obtain perfect equality for the canonical triple
at the finite boundary. A Markov hypothesis by itself never supplies the
coupling or decoder relation.

For `V,V'` agreeing on all outputs used by some row of `kappa`, prove that
the displayed coordinate factorization is unchanged. This follows by applying
the existing joint-law support theorem row by row. Globally unused output
fibers impose no restriction; no uniqueness or canonical posterior choice is
part of the channel property.

### 3.5 Remark 1 and the precise prior/support boundary

For finite alphabets and nonempty `alpha`, prove:

1. A fixed coupling `q` can be reused with every input law `p` through
   `canonicalJoint p q`. Its pair law is `PMF.channelJoint p kappa`.
   This reuses the **law** of the vector on a fresh product space; it does
   not assert the same random variable is independent of arbitrary new
   variables on an already fixed source.
2. `IsPerfectlyRepresentableChannel kappa` implies
   `IsPerfectlyRepresentablePair (PMF.channelJoint p kappa)` for every `p`.
3. For each full-support `p`, the converse also holds. Extract a finite
   perfect witness from C01, canonicalize it, then obtain one common
   posterior by Section 3.4. This is not supplied by the pinned Markov
   theorem alone.
4. Consequently the channel property is equivalent both to pair perfectness
   under every input prior and to pair perfectness under some full-support
   prior. Two full-support priors give equivalent pair properties. Establish
   existence of a full-support prior using the pinned finite-PMF API.
5. For arbitrary `p`, let `S = {x // x ∈ p.support}` and
   `kappaS s = kappa s.1`. Prove the support-correct statement
   `IsPerfectlyRepresentablePair (PMF.channelJoint p kappa) ↔
   IsPerfectlyRepresentableChannel kappaS`. Construct a normalized PMF `pS`
   with full support on `S` and `pS.map Subtype.val = p`. Prove its
   channel-joint compatibility and the pair-perfectness equivalence under
   this change of input value type, including both directions of finite
   witness transport. C01 pair-law transport alone compares the same value
   alphabets and is insufficient. Constructor choice and proof route remain
   implementation choices; keep one-consumer bookkeeping local and do not
   expose a general reindexing framework merely for this bridge.

The fifth result carries the manuscript's support convention into an ambient
Lean alphabet. For a prior vanishing on some input, pair perfectness does not
justify the intrinsic property of the entire original channel. The plan does
not require C03's nonrepresentable-channel example to demonstrate this: an
explicit failed all-row coupling/cancellation inference suffices as a C02
regression. Global active-output restriction remains C06 work.

## 4. Reuse inventory and proposed API ownership

### 4.1 Verified existing surfaces

The C02 discovery pass reads pinned source and its public API contract,
declaration index, module guide, and theorem highlights; compiling probes
verify candidates under focused imports. Exact probe results and limitations
are recorded in the planning evidence in Section 10. Names in this subsection
are existing APIs, unlike the proposed names in Section 4.2.

| Existing surface | Intended reuse |
| --- | --- |
| C01 `isFunctionalRepresentationOf_iff`, `isIndependentOf_comp_right`, `IsFunctionalRepresentationOf.mutualInfoOf_eq_condEntropyOf_sub_condMutualInfoOf` | Decoder extraction, independence of the function vector, Equation (3) |
| C01 fixed-perfect Markov equivalence and `IsPerfectFunctionalRepresentation.isPerfectlyRepresentablePair` | Canonical perfectness and bridge back to the finite existential pair predicate |
| `LeanInfoTheory.Shannon.indepProd`, its marginal/support lemmas and `isIndependentOf_iff_map_eq_indepProd` | Independent product and canonical joint construction; there is no `PMF.prod` declaration at this pin |
| `PMF.map_comp`, `map_bind`, `bind_map`, `mem_support_map_iff` | Pushforward and support calculus |
| `mutualInfoOf_comp_right_le`, `mutualInfoOf_chain_rule_fst` | Both data-processing signs needed for Equation (7), with a local product-variable calculation |
| `isMarkovChain_iff_exists_channelExtension`, `isMarkovChain_channelExtension` | Extract a middle-to-third channel from one joint law; establish the forward Markov direction |
| `PMF.channelJoint_eq_iff_eq_on_support`, `channelJoint_apply`, `channelExtension_apply`, marginal maps | Support-aware cancellation and canonical/posterior factorization |
| `condFstGivenSndChannel`, its null-fiber irrelevance theorem | Understand the pinned total conditional convention; no dependency on its selected null-fiber values |
| mathlib `PMF.bindOnSupport` and its support/map calculus, `PMF.uniformOfFintype`, `PMF.support_uniformOfFintype` | Support-subtype construction and full-support witness, with focused additional imports where needed |
| `Fintype.ofFinite`, finite function-type instance, `Fintype.equivFin`, `entropyOf_comp_injective` | Internal finiteness and justified support-inclusion transport; prefer the existing C01 existential bridge over repeating its private auxiliary-reindexing proof |

The production import target is
`PerfectFunctionalRepresentations.Semantics.FunctionalRepresentation`, which
already imports `LeanInfoTheory.Shannon.SemanticBridge.Markov` and its product,
information and finite-channel prerequisites. Add only the focused mathlib
imports actually required by support/uniform proofs. Do not import the broad
`LeanInfoTheory.Shannon`, example modules, unstable internals, or heavy
sufficiency/data-processing umbrellas merely for discovery convenience.
The pinned `isSufficientChannel_iff_exists_common_posterior` and related
full-support/all-prior sufficiency theorems were also inspected and checked.
They concern a model family with one observation channel; applying them here
would introduce a larger `(Y,W)` observation alphabet and transport. The
direct Markov-plus-channel-joint route already provides the generic
factorization and cancellation needed by the proposed coordinate-specific
boundary, with fewer imports and no duplicated generic theorem.
No dependency change or upstream proposal is part of C02.

### 4.2 Proposed public surface

All new declarations belong to `PerfectFunctionalRepresentations` in
`PerfectFunctionalRepresentations/Semantics/Canonical.lean`. Regressions belong
to `PerfectFunctionalRepresentations/Tests/Semantics/Canonical.lean`, which
must remain outside production imports. Proposed principal names are
`canonicalJoint`, `IsCanonicalCoupling`,
`IsCanonicalFunctionalRepresentation`,
`IsCanonicalFunctionalRepresentationOf`, and
`IsPerfectlyRepresentableChannel`. These names do not exist at the baseline.

The public theorem families are the semantic expansion/functional bridge and
canonical-law characterization; marginal and support-aware coupling bridges;
decoder-induced and existential information-preserving canonicalization;
finite canonical pair-perfectness characterization; common-posterior and
Markov equivalences; channel/perfect-pair prior bridges; and the support
restriction theorem. They must express exactly Section 3. Final theorem names
may follow local naming conventions without changing a contract. No exact
public-declaration count is an acceptance target.

Keep tuple rewrites, finite-sum expansions, Equation (7), conditional
contraction, support-subtype normalization/transport bookkeeping, and posterior
choice calculations private or local unless a listed public consumer needs
their explicit boundary. Do not edit C01 to expose private helpers without
first establishing real consumer pressure and assessing its public contract.
No new PMF namespace declarations are planned.

## 5. Stable proposed steps and acceptance criteria

All steps are unstarted. Execution order is
`S01 → S02 → S03 → S04 → S05 → S06 → S07 → S08`.
The separation follows distinct reviewable outcomes, not a fixed step count.
Every criterion below is required; Section 7's validation duties apply to
each step in addition to its listed evidence. Refer to the exact step heading
when constructing a future source-bound review contract.

Revision 3 numbers steps in execution order at the lead's request. Relative
to revision 2, support transport moves from S08 to S06, integration from S06
to S07, and closeout from S07 to S08. Their criterion prefixes and all current
references follow that mapping; the work and acceptance requirements are
unchanged. No plan-review or execution session exists to migrate.

Draft revision 1's retired S05-C03 is now covered by S06-C01/C02, and its
S05-C04 regression coverage is divided between S05-C04 and S06-C03. The former
post-report closeout criteria remain mandatory duties under Section 8.2,
rather than criteria the reviewer would have to certify prospectively.

### PFR-C02-S01 - Canonical semantic foundation

**Objective:** Establish the distinction between vector laws, couplings and
fixed-pair canonical representations (Section 3.1).
**Prerequisite:** Explicit plan approval and step authorization; C01 complete.
**Scope:** New production and regression modules; concise owning documents.

| Criterion | Acceptance and required evidence |
| --- | --- |
| C02-S01-C01 | The proposed construction and three canonical predicates implement Section 3.1; common-base expansion retains support decoding and implies C01 representation. Signature inspection and a production-only consumer establish the unrestricted structural boundary. |
| C02-S01-C02 | Canonical joint marginals and the canonical-triple characterization are proved; the pair marginal/channel equality iff row agreement on input support is proved. Full-support specialization is available. |
| C02-S01-C03 | Regressions distinguish a correct coupling from an incorrectly decoded fixed pair, and check deterministic/singleton canonical triples and a zero-prior coordinate. Focused builds and public/private/import audit pass. |

### PFR-C02-S02 - Decoder-induced canonical representation

**Objective:** Formalize Equation (5) and properties 1-3 (Section 3.2).
**Prerequisite:** S01 completed with its required review when invoked.

| Criterion | Acceptance and required evidence |
| --- | --- |
| C02-S02-C01 | For any support-correct decoder, the function vector is independent of X and evaluates to Y on support; both fixed-decoder and existential-decoder interfaces are proved without source or auxiliary finiteness. |
| C02-S02-C02 | The vector law agrees with the decoder pushforward; a given channel's rows are recovered on input support, and on all inputs under full support. The fixed pair law is preserved. |
| C02-S02-C03 | Regression consumers instantiate an unrestricted source and an infinite original auxiliary for the structural result, plus a decoder altered off supported inputs. No mutual-information equality for infinite auxiliaries is asserted. |

### PFR-C02-S03 - Information preservation and canonical sufficiency

**Objective:** Prove property 4, Lemma 1 and its consequence (Section 3.3).
**Prerequisite:** S02 complete.

| Criterion | Acceptance and required evidence |
| --- | --- |
| C02-S03-C01 | I(Y;W)=I(Y;Z), exact Equation (7), and both correctly oriented data-processing inequalities in Section 3.3 are checked proof content. Proof organization may vary; finite value alphabets and unrestricted source remain explicit. |
| C02-S03-C02 | An existential canonical replacement preserves the original pair and information; fixed-perfect canonicalization and the exact canonical-law characterization of C01 pair perfectness are proved in both directions. |
| C02-S03-C03 | Regressions include a noninjective decoder-vector map, a finite auxiliary in a higher universe, and a source with null atoms; theorem axiom checks and consumer builds pass. OM-053's finite-information limit remains explicit. |

### PFR-C02-S04 - Common posterior and intrinsic channel property

**Objective:** Formalize Definition 2 and the factorization/Markov boundary
(Section 3.4).
**Prerequisite:** S03 complete; retain the approved DG-03 contract.

| Criterion | Acceptance and required evidence |
| --- | --- |
| C02-S04-C01 | The prior-free channel predicate has one q and one V for every input and uses the nonempty-input boundary. Coordinate coupling follows as a theorem, not an extra unexplained assumption. |
| C02-S04-C02 | The exact support-aware fixed-V factorization equivalence is proved using existing channel-joint cancellation. Full-support specialization and the fixed-q Markov equivalence hold; forward Markov/perfectness works for any prior. |
| C02-S04-C03 | Globally unused output fibers leave coordinate factorization unchanged when posterior values are changed there. Regressions check this and failure of the fixed-q common-posterior converse under a point prior; no uniqueness of V or full output support is assumed. |

### PFR-C02-S05 - Prior independence and full-support pair equivalence

**Objective:** Prove Remark 1's law reuse and the all-prior/full-support
equivalences (Section 3.5, items 1-4).
**Prerequisite:** S04 complete; use S03's finite canonical sufficiency.

| Criterion | Acceptance and required evidence |
| --- | --- |
| C02-S05-C01 | The same coupling law works under every prior on a fresh canonical joint; channel perfectness implies pair perfectness under every prior, with fixed original sources handled by C01 pair-law transport. |
| C02-S05-C02 | Pair perfectness under any specified full-support prior implies the intrinsic channel property; equivalence under two full-support priors, under every prior, and under some full-support prior is proved, including existence of a full-support prior from the pinned finite-PMF API. |
| C02-S05-C04 | Regressions instantiate two distinct full-support priors, a point prior in the forward bridge, singleton alphabets and a globally unused output. The converse remains explicitly full-support; support restriction is deferred to S06. |

### PFR-C02-S06 - Input-support transport and arbitrary-prior equivalence

**Objective:** Complete the support-restricted pair/channel equivalence
(Section 3.5, item 5), making the change of input value type explicit.
**Prerequisite:** S05 complete; reuse its full-support equivalence on the
support subtype and S03's finite-witness boundary.

| Criterion | Acceptance and required evidence |
| --- | --- |
| C02-S06-C01 | For every p, construct a PMF pS on p.support, prove full support and the inclusion pushforward pS.map Subtype.val = p, and prove compatibility of the restricted-channel joint with the original pair law. No constructor or total retraction is mistaken for a definitional equality of value types. |
| C02-S06-C02 | Pair perfectness is transported in both directions across the supported input inclusion, with explicit finite witness and information/structural justification. Conclude exactly IsPerfectlyRepresentablePair (channelJoint p kappa) iff IsPerfectlyRepresentableChannel (fun s : p.support => kappa s.1). No converse to the unrestricted channel is asserted for an arbitrary prior. |
| C02-S06-C03 | A proper input-support subtype exercises the inclusion law and perfect-pair bridge; changing unused input rows preserves the support-restricted conclusion. Singleton support and unused outputs are covered, and production/consumer builds and the public-helper audit pass. |

### PFR-C02-S07 - Integrated semantic API and internal milestone

**Objective:** Validate the complete C02 consumer boundary and finish
implementation-side integration.
**Prerequisite:** S06 and all preceding mathematical steps complete.

| Criterion | Acceptance and required evidence |
| --- | --- |
| C02-S07-C01 | The lightweight root exposes Canonical alongside its existing semantic surface; regression, matrix, optimization and demonstration modules remain separately imported. Root-only and Canonical-only consumers check all principal definitions and theorem families. |
| C02-S07-C02 | All Section 6 regression rows and Section 8.1 readiness criteria are audited against current Lean source; full build, placeholder and new-public-theorem axiom checks pass. Section 8.2 closeout duties are recorded as pending. No test imports enter production. |
| C02-S07-C03 | Owning canonical documents, exact source coverage, gate resolutions established by approval, omission dispositions and downstream guarantees are reconciled. Status is implementation finished, independent chunk validation pending; C02 is not yet complete and C03 does not begin. |

### PFR-C02-S08 - Fresh independent chunk validation and closeout

**Objective:** Obtain a cumulative source-based pass over all approved C02
criteria and reconcile completion.
**Prerequisite:** S07 and earlier required reviews complete; separate explicit
S08 authorization. The persistent reviewer performs a fresh chunk-wide pass
over current source and every Section 8.1 readiness criterion. Earlier step
reports alone cannot replace this pass.

Once approved and explicitly requested, this step includes bounded repairs
needed to meet the existing C02 contract,
including proof or regression repairs to earlier C02 work. Use the installed
correction phases, retain earlier evidence, rerun affected checks, and obtain
renewed independent assessment for criterion gaps or changed reviewed claims.
A substantive contract/scope change, invalidated later contract, persistent
material disagreement or unsupported transition requires stopping at that
boundary under Section 9. Merely needing to edit a Lean proof does not.

| Criterion | Acceptance and required evidence |
| --- | --- |
| C02-S08-C01 | The current source satisfies every Section 8.1 readiness criterion, exact manuscript contract and regression row; the cumulative source/evidence allocation exposes each requirement for fresh independent assessment. |
| C02-S08-C02 | Any repairs in this step preserve the approved mathematical contracts, are traceable to their reasons, and have applicable validation. Earlier unresolved findings and changed reviewed claims are explicitly identified in the material submitted for assessment; none is silently marked resolved. |
| C02-S08-C03 | The current public/import boundary, validation evidence and owning documents accurately describe the implemented guarantees and pending closeout. No premature completion or next-chunk claim is present. |

These criteria concern the source and evidence being reviewed. Receiving and
reconciling the fresh report, resolving its gaps, recording final validation
and obtaining/reporting closure are mandatory subsequent duties in Section
8.2; they cannot be certified prospectively by that report.

## 6. Mandatory edge-case and regression matrix

Regressions are anonymous consumer checks unless genuine reuse warrants a
public name. They test semantic failure modes, not a quota of examples.

| Row | Required check | Owner |
| --- | --- | --- |
| C02-R01 | Singleton X and independent fair Bool variables Y and W(*) on four equally weighted atoms give W independent of X and the correct sole coordinate law for Y given X, yet Y differs from W X with probability 1/2; thus coupling marginals do not establish fixed-pair decoding | S01 |
| C02-R02 | Product construction, evaluation decoder and pair law on deterministic and singleton examples | S01 |
| C02-R03 | Zero-prior row can disagree with a supplied channel while the pair joint is unchanged | S01/S04 |
| C02-R04 | Structural canonicalization with unrestricted source and an infinite original auxiliary | S02 |
| C02-R05 | Support-only decoder correctness; changes at unused inputs do not create a claimed all-row equality | S02 |
| C02-R06 | Noninjective F preserves I(Y;Z) because of representation structure, without asserting generic information preservation under postprocessing | S03 |
| C02-R07 | Finite higher-universe auxiliary, null source atoms and the C01 finite existential witness interface | S03 |
| C02-R08 | One common posterior and full-support cancellation; for Bool, q equally mixing vectors (false,false) and (false,true) gives a perfect canonical triple under pure false but no common posterior for that q across its two induced rows | S04 |
| C02-R09 | Globally unused output permits two different posterior completions with identical factorizations | S04/S05 |
| C02-R10 | Two distinct full-support priors and a point prior instantiate the precisely qualified prior bridges | S05 |
| C02-R11 | Proper input-support restriction with explicit inclusion pushforward and pair-perfectness bridge; changing unused input rows leaves the support-restricted conclusion unchanged | S06 |
| C02-R12 | Empty source/pair carriers cannot carry a PMF; nonempty-input channel API rules out empty input, and an actual channel rules out empty output | S07 |
| C02-R13 | Root-only and Canonical-only consumers; no regression/heavy imports, no dependence on C01 private declarations | S07 |

No numerical approximation, arbitrary prior, or computed example substitutes
for the universally quantified canonical or channel theorems.

## 7. Validation and installed review operation

At each coherent Lean change build the touched module and important
consumers; each authorized step requires its regression module and a consumer
importing only the intended production surface. Before a milestone run
`lake build`. Once present, the focused commands are:

```powershell
lake build PerfectFunctionalRepresentations.Semantics.Canonical
lake build PerfectFunctionalRepresentations.Tests.Semantics.Canonical
lake build PerfectFunctionalRepresentations.Tests.Semantics.FunctionalRepresentation
lake build PerfectFunctionalRepresentations
lake build
rg -n --glob '*.lean' '\b(sorry|admit|axiom|opaque|undefined)\b' `
  PerfectFunctionalRepresentations PerfectFunctionalRepresentations.lean
git diff --check
git status --short --branch
```

Require the placeholder scan to have no matches (normal `rg` no-match exit
code 1). Inspect every new public signature, universe/finite/nonempty
assumption, namespace, import and `#print axioms` result; no `sorryAx` or
unapproved project axiom is allowed. Check required Markdown links/anchors,
source hashes and pins, all actual dirty/untracked changes, and generated,
ignored and temporary artifacts. Preserve unrelated work and durable
`.pfr-review/` records. Remove only owned disposable probes/renders after
retaining needed evidence. A compiler pass does not establish source fidelity.

Use [the protocol](../review-protocol.md) and
[installed operations](../review-operations.md) as installed. A later explicit
plan-review request opens a `plan-*` session for this proposed revision, with
criteria from Section 9. It does not open execution. Approval of an exact
plan and an eligible step request are required for execution. Do not infer
approval from the draft's presence, reviewer readiness, a favorable report,
a roadmap entry, or prior C01 completion.

For an eligible step with review, the implementation task handles baseline
capture, implementation/validation, contextual self-review, separate
reassessment and corrections, neutral source-bound review dispatch, full
original report capture, explicit reconciliation, justified corrections,
final checks/documents/final source capture and closure. Retain B/R/F
distinctions and criterion gaps. One processed message authorizes one fixed
step, never automatic continuation. Normal phases need no user message relay.
No automation feature or redesign is part of this plan.

For S08's execution-contract entry, include its three step criteria and all
eleven Section 8.1 cumulative criteria, each exactly once. Earlier steps
retain their own listed criteria. Section 8.2 states required lifecycle
duties, not additional pre-closure reviewer criteria: the installed phases
and closure checks enforce their ordering. This allocation prevents the
report or closure certificate from becoming a prerequisite for its own
creation. Keep implementation notes in captured source context so changes
remain visible without treating their suggested methods as acceptance terms.

The actual persistent C02 binding is stored privately at
`.pfr-review/chunks/PFR-C02/binding.json`, including the actual originating
parent UUID, its distinct recipient role, and canonical reviewer identity.
Requested profile is `gpt-6-astra` / `ultra` /
`fork_turns=none`. Native creation returned only the canonical task name;
effective settings remain unknown, as accepted by the supervised installation.
At preparation of this revision, the reviewer acknowledged readiness only;
no plan review or execution session had been opened. Preserve this actual
binding for subsequent requests; do not replace it with the General Assistant's
diagnostic reviewer.

## 8. Cumulative completion and downstream guarantees

C02 completion requires both the reviewable readiness results in Section 8.1
and the subsequent lifecycle duties in Section 8.2. S07 audits readiness and
records finalization as pending. S08 obtains the fresh independent assessment
and completes the remaining duties in the installed order.

### 8.1 Cumulative reviewable readiness criteria

These cumulative criteria concern the actual source and evidence available
for review, in addition to all step criteria and regression rows.

| Criterion | Required result |
| --- | --- |
| C02-CC01 | Exact plan approval, recorded DG-02/DG-03 resolutions, correct baseline/pins and one-step authority are established; C01 history is preserved. |
| C02-CC02 | Coupling law, fixed-pair canonicality and canonicalJoint are distinct and linked by the exact support/joint-law theorems. |
| C02-CC03 | Equation (5) and properties 1-3 hold for decoder-induced canonicalization with the prescribed structural generality and support boundary. |
| C02-CC04 | Lemma 1/property 4 and Equation (7)'s checked proof content hold at the finite-information boundary, with no extra source finiteness. |
| C02-CC05 | Canonical finite witnesses characterize existing pair perfectness without altering C01's predicate or claiming unrestricted-alphabet information coverage. |
| C02-CC06 | Definition 2 is an intrinsic all-input, single-posterior channel property; fixed-V support cancellation and fixed-q full-support Markov equivalence are proved. |
| C02-CC07 | Remark 1's law reuse, all-prior forward bridge, full-support converses/equivalences, and support-restricted arbitrary-prior theorem are proved. |
| C02-CC08 | Null source atoms, unused input rows, unused output fibers, singleton/empty boundaries and universe issues match the plan and all regression rows pass. |
| C02-CC09 | Public/private/import ownership, root integration, complete builds, placeholder and theorem axiom audits pass against the source submitted for assessment, with evidence applicability established. |
| C02-CC10 | The cumulative evidence maps every covered manuscript anchor, public theorem family and regression obligation to current declarations or checks, with source identity and limits explicit; earlier step verdicts do not substitute for current mathematical evidence. |
| C02-CC11 | Owning documents, source allocation, omission register, gate status, downstream guarantees and repository hygiene accurately reflect the source submitted for assessment; completion remains pending until Section 8.2 is fulfilled and no next chunk is started. |

### 8.2 Required report reconciliation and finalization

The following duties remain mandatory for C02 completion. They are performed
through the installed workflow; they are not extra reviewer criteria to mark
`SATISFIED` before the relevant events exist.

1. Retain the original full fresh cumulative report and actual source/receipt
   identity; explicitly reconcile all findings and criterion assessments.
   Retain earlier original reports and disposition histories with their source
   provenance; no newer report silently discharges an older obligation.
2. Correct justified in-contract defects, validate affected source, and obtain
   a new satisfactory assessment wherever a gap or changed reviewed claim
   requires it. Do not close with an unresolved required criterion. Preserve
   report history and the applicability of evidence to the final source.
3. Complete final owning-document reconciliation, required checks and final
   source capture, then obtain supported closure with all installed gates
   satisfied. Before F, documents may state "validation ready, closure subject
   to the durable review record." Included files stay unchanged afterward.
   Report the closure reference, result and limitations in the task; only
   that supported record establishes completion. No subsequent step/chunk,
   commit or push starts automatically.

Revision 1's CC10 requirement for a satisfactory fresh pass and CC11's
recorded-closure requirement are retained here. The revised CC10/CC11 above
describe reviewable readiness, rather than asking the reviewer to attest to
future receipt, reconciliation or closure.

C03 and later consumers may then use the canonical triple/coupling interface,
finite perfect-witness reduction, the intrinsic channel predicate and its
posterior witness, support-aware factorization, and precise prior/pair bridges.
They may not infer full support from an arbitrary pair, uniqueness of a
decoder/coupling/posterior, perfectness of every channel, generic auxiliary
existence, a matrix encoding, an optimizer, an output-pruning theorem, or an
infinite-information result. Those are not C02 guarantees.

## 9. Plan-review criteria and revision policy

The later independent **plan** review assesses the proposed contracts and
their feasibility; it must not assess nonexistent C02 proofs as implemented.

| Criterion | Required planning assessment |
| --- | --- |
| C02-PR01 | The authenticated Section II-A anchors are completely allocated, with printed/intended/Lean distinctions and every intentional omission accounted for. |
| C02-PR02 | DG-02's fixed-pair versus coupling distinction and DG-03's common-posterior contract are mathematically adequate, with correct quantifiers, priors, support, null fibers and empty/universe boundaries. |
| C02-PR03 | Existing local and pinned APIs are verified and distinguished from proposals; proof routes and focused import/module ownership are feasible without duplicating generic theory. |
| C02-PR04 | Stable steps, prerequisites, required acceptance evidence, regressions and cumulative completion criteria cover the actual dependencies and reviewable outcomes. |
| C02-PR05 | Documentation/omission/downstream consequences and repair/stop rules are explicit; scope does not expand to later chunks or infinite-information claims. |
| C02-PR06 | Reviewer identity, requested/effective-setting distinction, exact-revision approval boundary and installed one-step workflow are recorded without claiming undispatched review or authorizing implementation. |

Routine theorem naming, local helper choices and equivalent proof routes may
be refined autonomously within the approved mathematical contracts, with
recorded reasons in the implementation notes and material outcomes in the
project log. Choose methods by current evidence; exploratory routes may be
abandoned. Notes are advisory and cannot change theorem meaning, validation
duties, step scope or acceptance. Preserve the approved plan's non-status
bytes during an execution session: the installed adapter freezes those bytes
even when a passage sounds advisory. Do not disguise a contract amendment as
a note or a status edit.

Changing assumptions, theorem strength, coverage, carrier semantics, public
ownership, a decision gate, dependency pin, or step acceptance criteria requires
a plan-health review and explicit lead approval of the revised exact contract.
When such a change is warranted, prepare its concrete proposal and explain the
effect; the installed recovery path cannot silently replace a frozen contract.
If discovery invalidates later steps, stop at that boundary. Do not silently
drop the support-subtype bridge or replace the common posterior with a
prior-specific or per-input witness. A missing reusable API is a search/proof
planning issue first, not permission to alter mathematics.

## 10. Planning evidence, omissions, and document consequences

The 2026-09-10 preparation is planning evidence only. The installed `inspect`
command succeeded, confirmed the historical C01 prerequisite and clean matching
pins, and initially reported no C02 binding/execution. The authorized neutral
bootstrap was captured before native creation; the installed `bind` command
succeeded with the actual returned identity and current parent UUID. Readiness
is not a review report. No independent plan review was dispatched.

The existing production/regression/root build passed with 2,759 jobs and the
full project build passed with 2,758 jobs. The bounded discovery subtask
reported and retained 76 successful core signature/type-only checks and seven
successful alternative-API checks, each with actual Lean exit 0. Its initial
rejected speculative `PMF.bindOnSupport_congr` name is preserved as negative
discovery evidence and is not used. The planning pass also checks manuscript
hashes and page 2 layout, scans placeholders, and inspects the final
documentation diff and source/pin invariants. Detailed actual results are recorded in
[project log entry 36](../project-log.md#36-pfr-c02-reviewer-establishment-and-proposed-plan---2026-09-10).
These checks validate existing source and API availability, not the unproved
C02 contracts. No maintained Lean or review-tool implementation is changed.

The lead subsequently authorized selective revision following the contextual
reassessment in project log entry 37. Draft revision 2 applies the corrected
R01 fixture, separates proof advice, gives support transport its own step,
permits bounded in-contract closeout repairs, and separates readiness from
post-report duties. Mathematical targets, source allocation and proposed
DG-02/DG-03 decisions remain the same. The implementation notes distinguish
previous compiling checks from the source-only retraction route; the cancelled
optional probe is not successful verification. Revision evidence and the
selection rationale are recorded in
[project log entry 38](../project-log.md#38-c02-proposed-plan-revision-2---2026-09-10).
Revision 3 only renumbers the steps and matching references in execution order;
see [project log entry 39](../project-log.md#39-c02-step-renumbering---2026-09-10).

There are no numbered Future Work Notes in the authoritative project log.
Relevant inherited obligations are C01 Section 14's non-guarantees, DG-02,
DG-03, and the omission records below. C01's generic-helper upstream trigger
remains conditional on actual reusable consumer pressure; no such proposal or
dependency migration is made merely by planning C02.

| Record | C02 disposition |
| --- | --- |
| OM-013 | Formalize Definition 1 and Lemma 1 locally; do not consult/reproduce or claim the cited Kallenberg lemma. |
| OM-014 | Use arbitrary finite alphabets and explicit support restriction; coordinate enumeration remains C06. |
| OM-022, OM-023 | Section transitions and bibliography remain provenance, not duplicate theorems. |
| OM-035 | Preserve nats; no parallel bit hierarchy. |
| OM-037 | The four allegedly trivial canonical properties are substantive checked targets; adjectives are not declarations. |
| OM-042 | Equations (6)-(7) and their sign argument are checked proof content; no public name per line is promised. |
| OM-048 | Independence plus marginals is not fixed-pair canonicality; retain Y=W X. |
| OM-053 | Finite canonical sufficiency justifies the approved finite-information witness boundary; structural arbitrary-auxiliary canonicalization does not assert infinite-information equality. |
| OM-054 | Remark 1 reuses a vector law on a suitable joint extension; it does not place the same random variable on every already fixed source. |
| OM-055 | Channel-only perfectness inference from a pair requires the manuscript's input-support convention: use full support on the declared channel or restrict to input support; null-output posterior completion is arbitrary. |

During preparation, update the map's C02 planning status and omission records,
the living summary's current activity and reviewer status, the roadmap and
reader/scope pointers, and the chronological project log. Keep DG-02/DG-03
open and mathematical coverage marked as target. At exact plan approval,
record the approved resolutions and execution baseline without claiming a
step has run. During implementation, update the owning documents within each
coherent authorized step. At S07 report pending independent validation; only
S08 and its durable closure establish C02 completion.
