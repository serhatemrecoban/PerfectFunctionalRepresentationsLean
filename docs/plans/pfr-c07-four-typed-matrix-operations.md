# PFR-C07 - Four Typed Matrix Operations

<!-- pfr-review-status:start -->
**Status:** Approved / implemented; S01-S04 durably complete; S05 cumulative
independent report critically reconciled; final checks/F/closure follow this checkpoint,
2026-09-21. The S05 request was accepted after checking S04 closure,
original-report reconciliation and exact current-source applicability.
**Revision:** Approved revision 2; original delivered draft preserved privately.
**Authority:** The lead endorsed this delivered revision and subsequently wrote
"good, start step 1 with its revies process". Taken together, these messages
approve this contract and authorize S01 with installed review. The actual
messages and this contextual interpretation are retained; no separate quoted
beta approval is claimed. The lead subsequently requested "Continue with step 2
with review process if step 1 with its review process is completed". Only S02
was authorized by that request. The subsequent request "Continue with step 3
with review process if step 2 with its review process is completed" authorizes
only S03 after verification. The subsequent "good, continue with step 4 with
its review process" authorizes only S04; S05 requires a later step request.
The lead subsequently wrote "good, continue with step 5 with its review process
which is the last step of our plan", authorizing the final cumulative step S05.
**Reviewer:** `/root/pfr_c07_reviewer`, bound to originating task
`01a0c0fd-b90d-7920-98f5-79bb1d515bc3` (role `/root`). Requested
`gpt-6-astra` / `ultra` / `fork_turns: "none"`; effective settings unknown.
Bootstrap and its context-visibility clarification are preserved. Revision 1's
independent plan review satisfied all six criteria with no findings and was
reconciled. That original review remains historical; no separate revision-2
plan review is claimed. The user-supplied General Assistant
report is advisory and distinct from the installed review.
**Decision:** The endorsed contract adopts Sections 3-6, including the intended
VPS domain `0 < beta <= 1`. The printed strict upper bound and this source
departure remain explicit. S01 implements only the raw layer and index laws.
The proposal-era approval wording below is retained as the frozen original
contract; this dated status block records its subsequent approval.
**S01 review checkpoint:** The same bound reviewer satisfied all three S01
criteria with no findings. Its original report and the parent's critical
reconciliation are preserved. Ordered indices, raw semantic operations,
exact/Real coordinates and R01-R03 compile; 69 public signatures/axiom checks
pass. See [implementation notes](../pfr-c07-implementation-notes.md) for exact
evidence and the distinction between this checkpoint and subsequent closure.
**S01 closure / S02 startup:** S01 closed under
`a678f0c258c0e87b6c3392c283cd19967d4595653d9ddd20f00a454efda2999e`.
All 112 final source/environment inventory entries matched at S02 startup.
The existing execution session and bound reviewer continue for the PP pair,
column data, both witnessed recoveries and R04-R08. Later steps are unstarted.
**S02 review checkpoint:** Legal PPS/PPM, complete exact/Real column data and
both witnessed recoveries pass all three independent criteria with no findings.
The complete original report is preserved and critically reconciled. R01-R08's
69 examples, all 153 public signature/axiom checks, nine independent consumers
and focused/default builds pass. Final checks, F capture and durable closure
follow this pre-F checkpoint; see the implementation notes for evidence and
the subsequent execution record. S03-S05 remain unstarted.
**S02 closure / S03 startup:** S02 closed under
`d7379a98dc1ce7d492d3bb0ba94d5a413fc870decf0400f0e2b918ba431873e9`.
All 112 final inventory entries matched before the S03 request was accepted.
The preceding S02 pre-F paragraph remains historical. S03 implements the VP
pair, support/indicator bridges, mask irrelevance, both recoveries and R09-R13,
including the approved value-one interpretation. S04-S05 remain unstarted.
**S03 review checkpoint:** Legal VPS/VPM, support/indicator and column-data
contracts, mask irrelevance and both witnessed recoveries satisfy all three
independent criteria with no findings. The original report is preserved and
critically reconciled. All 105 maintained examples, 233 public signature/axiom
checks, 12 independent consumers and focused/default builds pass. Only owning
status/reconciliation documents change after review; the normative plan and
reviewed mathematics are unchanged. Final applicable validation, F capture and
durable closure follow this checkpoint; the implementation notes distinguish
these stages. S04-S05 require later requests.
**S03 closure / S04 startup:** S03 closed under
`8ad60f2da56c3fb22e11de633d270ef399fc85554c2176d91db6d1e8e56c2759`.
All 112 final inventory entries matched before the S04 request was accepted.
The preceding S03 pre-F paragraphs remain historical. S04 owns the complete
parametric Examples 2-5, generic public handoff consumers, R14-R16 and the
cumulative declaration/criterion/consumer readiness audit. S05 remains unstarted.
**S04 review checkpoint:** Complete parametric Examples 2-5, public handoff
consumers and readiness mapping satisfy all three independent criteria with no
findings. The complete original report is preserved and critically reconciled.
All 169 maintained examples, 233 public signature/axiom checks, five independent
consumers and required/default builds pass. One assumption-wording clarification
is adopted; reviewed mathematics and normative plan remain unchanged. Final
applicable checks, F capture and durable closure follow this checkpoint; the
implementation notes retain exact evidence and limits. S05 needs a later request.
**S04 closure / S05 startup:** S04 closed under
`f7ed3e569bd960c1e032c62e111cbe67ccddaaca4458c453300b2f586a38e0d4`.
Its original report/reconciliation and all three satisfied criteria were
verified; all 114 final source/environment inventory entries matched F
`f2c6c597bcbabcdc8908f3dd0e1e07d7e748f15393ba308a2bbef453b056b1fe`.
Earlier pre-F passages remain historical. S05 now owns the fresh cumulative
assessment of all twelve earlier criteria, R01-R16 and CC01-CC10, all maintained
test/example builds and subsequent reconciliation/finalization. C08-C16 are not
authorized by this request.
**S05 cumulative independent checkpoint:** The same reviewer freshly satisfies
all three S05 criteria, all twelve earlier criteria, R01-R16 and CC01-CC10, with
no findings. Its complete original report is retained and critically reconciled.
All maintained test/example builds, public audits and manuscript checks support
the report. A self-review current-status correction is resolved; no mathematical
change or new deferral is needed. Only owning status/reconciliation documents
change after R. Final applicable validation, F capture and supported durable
closure follow this checkpoint; only that later record establishes completion.
See implementation notes for exact evidence and limits. C08-C16 remain unstarted.
<!-- pfr-review-status:end -->

## 1. Baseline, authority and boundaries

The mathematical baseline is the actual inherited working tree at HEAD
`54c1714d1a9a891939d6c9f7d38c0d05896b2c75`, including untracked completed
modules, tests, plans and review tools. Preserve that work. LeanInfoTheory is
immutable `v0.1.0`, commit `0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`;
Lean is `v4.33.1` and mathlib is
`0df444a360eaa60ab8c11dca51a86af692955474` (`v4.33.1`). Installed pins match
the manifest and are clean. No dependency or workflow change is proposed.

C01-C06 are complete. The direct prerequisite is C06, whose original durable
S06 closure is `ff1ee497358f72b2becfa2d490fe0b3c8e425dfaeba9ec7157b6e365d6516d96`,
with final source F
`7ae17fefdb080284ea8ee18db440e79b9b69fd1cfed1b753e8959bef81e82b2b`.
Startup verified the completion/reconciliation records and all 100 concrete
C06 F source/configuration/dependency entries before planning edits. Its
preserved approved plan, implementation notes and readiness audit intentionally
describe the earlier pre-F checkpoint. They are not evidence of unfinished
mathematics. See [planning notes](../pfr-c07-planning-notes.md) for attribution,
earlier prerequisite applicability, actual build results and private references.

Consume `ActiveFiniteChannel`, its state-owned `Fin outputCard`, exact and
Real coordinates/reconstruction, admitted values/patterns and explicit
transport. Keep singularity a separate premise. DG-06, DG-07 and C06's
portion of DG-10 are resolved; C12's remaining part does not block C07.

Scope: the four binary operations, legality, exact order, normalization,
activity, singularity, column data, witness-parameterized recovery, and
Examples 2-5. No new prior or information measure is involved.

Non-goals: C08's tagged operation relation, paths, equivariance of paths and
Lemma 4 normalization; C09's perfectness/nonperfectness preservation and
all-ones perfectness theorem; C10/C11's multiway operations, partitions and
reachability; C12 onward's compression, incidence and LPs; a quotient of
states, a second probability theory, algorithms, or modifications of completed
mathematics. Existing C06 transport may be used by regression consumers without
proving any later preservation theorem.

## 2. Manuscripts and interpretation record

The designated binaries were freshly hashed, counted, extracted and visually
read at the relevant pages. They remain external; no reference binary, page
image or extracted manuscript text is a maintained deliverable.

| Source | Identity and anchors |
| --- | --- |
| Six-page ISIT final manuscript, local filename ending `final_manuscript_ (3).pdf` | SHA-256 `48963AA59485B2C33B1A1E6E7C6EAD2251FDDDD26BD3691B6FCFFE683E6ED1C4`; PDF p. 3, Section III-A operations 1-4, Equations (11)-(15), Examples 2-5. Definition 4 is inherited C06 context. |
| Eighteen-page approved extended draft, version 16, designated 2026-09-03 | SHA-256 `98636D4C9F0618EC08FCA84559572780F604F197FDA90D8D7C787B3624245B8F`; III-A pp. 3-4, same operations/examples, with both merge indices ranging through `m+1`. Neighboring III-B on p. 4 was read only for recovery/value-one consumer requirements. |

Paper labels 1 through n become Lean labels 0 through n-1. Rows are inputs;
columns are outputs. Matrices are exact/Real views of PMF rows. The active
state excludes globally zero columns, without requiring all entries positive
or introducing a full-support input prior. Column values lie in `(0,1]`.

Material interpretations, to be retained in source comments and coverage:

1. PPM/VPM select distinct columns from all `m+1` source columns. The extended
   correction is required even for Example 3, which merges the final column.
2. PPS has a strict ratio. VPS has two nonempty pieces of the *selected
   column's* support. A nonconstant ambient mask is insufficient.
3. Both sources print VPS with value strictly below one, while VPM permits
   one and later constructions use arbitrary positive auxiliary weights.
   Section 3 presents the substantive decision; it remains unapproved.
4. Recovery retains the split ratio or support partition. Merges are not
   injective functions, and nonadjacent recovery requires output reindexing.
5. All four examples share the implicit hypothesis `0 < beta < 1`.

No independent theorem is attached to the adjective "straightforward" or to
the literal set notation for singular matrices. The underlying closure facts
are mandatory. Reauthenticate these anchors if the designated companion changes.

## 3. Proposed DG-08 decisions

### 3.1 Semantic construction and active legality

Use PMF constructions first: an input-independent binary refinement kernel
for PPS, a deterministic output map for either merge, and a deterministic
map depending on the input row for VPS. Expose these semantic equations for
C09. In particular, VPS is not falsely presented as a single output-only
post-channel. Derive matrix, normalization and data formulas from them.

Raw construction helpers need no singularity or input nonemptiness; they do
not assign values/patterns to zero columns or promise an active result.
Legal constructors consume the existing active state and separate singularity
proof. They return an active state with proved singularity and exact output
cardinality. No singular-state replacement record is needed. Small argument
records are permissible only if their dependent arguments justify them;
they must not preempt C08's operation relation.

Keep semantic conditions pointwise, so active constructors may use
`[Finite alpha] [Nonempty alpha]`. Exposed C06 finset pattern formulas use
`[Fintype alpha]`. Local classical decisions are acceptable; no chosen input,
default output, public `Inhabited` or mathematical decidability assumption
may leak merely from implementation mechanics.

### 3.2 Column order and dimension changes

Keep the paper's adjacent split and lower-index-survives merge order, not an
arbitrary enumeration after every operation. Section 4 fixes the index maps.
Normalize a supplied unordered distinct merge pair to `a < b`; an ordered
pair is an acceptable primary interface. The order convention always refers
to the original lower column, including recovery ratio/mask orientation.

Splits have output cardinality `n+1`; merges have cardinality `n-1`, with
`2 <= n` derived from the distinct indices and positive target cardinality
proved. A fixed-size core may write the merge input as `Fin (m+1)` and output
as `Fin m`. State wrappers must expose the cardinality equality and actual
channel equation. Any dependent transport must use proved arithmetic and a
named equivalence/cast with coordinate equations, never an unchecked cast or
an assumed equality of heterogeneous records.

The following are representative **proposed signature shapes**, under
`[Finite alpha] [Nonempty alpha]`, not existing operation declarations:

```text
pps : (S : ActiveFiniteChannel alpha) -> IsSingularChannel S.channel ->
  (l : Fin S.outputCard) -> (t : NNReal) -> 0 < t -> t < 1 ->
  ActiveFiniteChannel alpha
ppm : (S : ActiveFiniteChannel alpha) -> IsSingularChannel S.channel ->
  (a b : Fin S.outputCard) -> a < b ->
  (forall x, S.channel x a != 0 <-> S.channel x b != 0) ->
  ActiveFiniteChannel alpha
```

For the returned state S', expose separate theorems for
`IsSingularChannel S'.channel` and for
`S'.outputCard = S.outputCard + 1` (split) or
`S'.outputCard = S.outputCard - 1` (merge). VPS/VPM follow the same shape with
exactly Section 5's mask/value/support hypotheses. State construction and its
singularity theorem remain separate; there is no new bundled singular state.

Given `hdim : S'.outputCard = n'` and a raw result
`raw : alpha -> PMF (Fin n')`, expose the wrapper equation
`forall x, (S'.channel x).map (finCongr hdim) = raw x`. A label `j : Fin n'`
is viewed in S' by `Fin.cast hdim.symm j`. These directions work for both
`n' = S.outputCard + 1` and `n' = S.outputCard - 1`.

For a recovered state A and original state S, first prove
`hcard : A.outputCard = S.outputCard`. Derive the cardinality equivalence
`e_card := finCongr hcard : Fin A.outputCard ≃ Fin S.outputCard`, whose numeric
action is the identity. With Section 6's explicitly directed rho, use
`e_rec = e_card.trans rho` and expose
`forall x, (A.channel x).map e_rec = S.channel x`. For adjacent recovery rho
is identity, leaving only the cardinality transport. This is the packaged
form of the fixed-output-type equations below. Final names and proof-argument
placement may change; the advertised hypotheses, cardinalities and map direction
may not. S01-S03 implement these interfaces and S04 consumes them generically.

### 3.3 Value-one VPS: recommendation requiring lead approval

Recommend interpreting the intended active VPS domain as `0 < beta <= 1`.
The operation routes each selected mass wholly to one child, without division
by `1-beta`; normalization, activity and singularity use no strict upper bound.
C06 already permits one. VPM explicitly permits one, and its reverse support
split must be available to recover a legal merge in C09. Splitting the
one-output all-ones channel along two nonempty input sets is the decisive
endpoint regression. This is a documented source repair, not a claim that
the printed VPS definition already says `<= 1`.

The strict printed alternative is mathematically viable but changes the
interface contract. For a value-one column and a nondegenerate mask, first PPS
it with a fixed strict ratio (say 1/2), VPS each of the two strict-value
children using the same mask, then PPM the two first-pattern children and the
two second-pattern children. All intermediate columns are active: both
support pieces are nonempty, and both temporary values are positive and below
one. Each final value is one. This five-operation construction has the desired
endpoint up to the explicitly tracked column order.

That paragraph is a planning argument, not a Lean cascade proof. Under the
strict alternative C09 cannot claim a single VPS inverse for a value-one VPM;
it needs the finite simulation and preservation along it. A bounded option is
for C09 to own this fixed five-operation construction and its endpoint equation,
then apply its already-proved individual PPS/VPS/PPM preservation lemmas in
sequence. That needs no general cascade theorem and adds no C08/C10 dependency.
Alternatively, a broader simulation API would need an earlier owner; C09 must
not wait on C10, which already depends on C09. Choosing the strict domain would
still require revising and approving the promised recovery contract and its
owner, but does not inherently require a dependency-graph change. This draft
selects neither fallback implementation nor a second operation family. Do not
silently choose the strict alternative, widen the printed domain, or strengthen
C06's value bound during implementation.

### 3.4 Recovery and public example policy

Require both directed recovery laws for each pair, with remembered witnesses,
semantic row equalities and explicit reindexing where necessary (Section 6).
No global inverse function or quotient-based equality is proposed.
Examples 2-5 will be private fixtures and anonymous compiling examples in a
separate test module. No public example theorem family has a demonstrated
consumer. Reconsider promotion only if C08/C09 needs a named fixture; record
the actual consumer before promotion.

## 4. Exact index and raw PMF contracts

All new names in this plan are **proposed**, not verified existing declarations.
Final spelling and private helper decomposition may change without weakening
these contracts. Section 8 separately lists verified reuse.

For `l : Fin n`, use children `L = l.castSucc` and `R = l.succ` in
`Fin (n+1)`. Let `keep = l.succ.succAbove : Fin n -> Fin (n+1)`.
It sends l to L, keeps indices below l and shifts indices above l by one.
Every target index is either `keep j` or R. A split replaces the selected
column at `keep l`; all `keep j` with `j != l` are unaffected.

For a merge with `a < b : Fin (m+1)`, let
`d_b : {j : Fin (m+1) // j != b} ≃ Fin m` be the inverse of the pinned
`finSuccAboveEquiv b`. Set `r = d_b(a)` and define the collapse map q by
`q b = r` and `q (b.succAbove j) = j`. Thus r has numeric index a;
the merged column stays at a, columns strictly between a and b stay put,
and those after b shift left. The fiber of r is exactly `{a,b}`; every
other fiber has the unique original column `b.succAbove j`.
This handles b equal to the final source column without an exceptional
out-of-range pivot. Required lemmas cover selected images, unaffected images,
fiber classification and exhaustive cases; one-use arithmetic stays private.

For a raw channel K, define:

| Construction | Required semantic equation | Selected coordinates |
| --- | --- | --- |
| PPS with `t : NNReal`, `t <= 1` at the raw layer | `PPS(K) x = (K x).bind T`, with `T l = PMF.binaryMixture t ht (PMF.pure L) (PMF.pure R)` and `T j = PMF.pure (keep j)` for `j != l` | L has `(t : ENNReal) * K x l`; R has `((1-t : NNReal) : ENNReal) * K x l` |
| Common merge | `Merge(K) x = (K x).map q` | r has `K x a + K x b` |
| VPS with `mask : alpha -> Bool` | `VPS(K) x = (K x).map f_x`, where `f_x l` is L when `mask x = true`, otherwise R; other j map to `keep j` | L has `if mask x then K x l else 0`; R has the complementary expression |

In every row, unaffected coordinates equal their original masses under the
maps above. Prove these statements as exact ENNReal identities and as Real
matrix identities, with row sums one. PMF owns normalization; do not rebuild
row laws by an unrelated normalization construction. Conversion of sums,
products and complements must justify finiteness and nonnegative subtraction.
The NNReal ratio's Real coercion is the printed PPS parameter; prove the
parameter/conversion bridge instead of offering an unrelated Real operation.

Raw total constructions may use endpoints/masks that are illegal for active
operations. They stay implementation support, not another paper operation
family. No raw-split/pruning bridge is required by the chosen nondegenerate
active contract, and no such bridge is silently used in recovery.

## 5. Four legal operations and column-data formulas

Let S be an active finite channel, h its singularity proof, `v_j` its admitted
exact column value and `P_j` its nonempty input support. Obtain admitted labels
through C06's `ActiveFiniteChannel.activeEquiv`. The support notation below
has a pointwise version when no `Fintype` instance is exposed.

| Operation | Legality beyond S and h | Resulting selected data |
| --- | --- | --- |
| PPS | `l : Fin S.outputCard`, `t : NNReal`, `0 < t` and `t < 1` | values `t*v_l` and `(1-t)*v_l`; both patterns `P_l` |
| PPM | `a < b` from all source labels; `forall x, S.channel x a != 0 iff S.channel x b != 0` (equivalently `P_a = P_b`) | value `v_a+v_b`, pattern `P_a` |
| VPS | l and mask; `exists x, S.channel x l != 0 and mask x = true`, and `exists x, S.channel x l != 0 and mask x = false` | both values `v_l`; patterns `P_l.filter (mask = true)` and `P_l.filter (mask = false)` |
| VPM | `a < b`, `v_a = v_b`, and disjoint input supports (pointwise, the two masses are never both nonzero) | common value `v_a`, pattern `P_a union P_b` |

Products in exact formulas coerce NNReal weights into ENNReal. Exposed Real
data have the corresponding products/sum. Prove the support-condition/finset
bridges, and the equivalence of disjointness to the paper's indicator sum
being 0/1; merely knowing equal values is insufficient for VPM. VPS's two
pieces form a disjoint partition of `P_l`, including rows outside that support
where both masses are zero. Changing mask entries only outside `P_l` gives the
same resulting channel; the mask is not uniquely recoverable there.

For each operation, prove activity of every selected and unaffected column,
singularity of the entire output channel, the stated output cardinality,
row normalization, all selected and unaffected exact/Real coordinates and
column data. No all-positive-entry, distinct-pattern or column-sum-one
assumption is allowed. Derive PPM's `v_a+v_b <= 1` from a row in their common
nonempty pattern and normalization; the sum can equal one. VPM's common value
and VPS's original value can equal one under the proposed approved repair.

Required edge boundaries: a one-output state permits PPS; it permits VPS
exactly when the selected support admits two nonempty pieces. No legal merge
exists there. An empty input is excluded only at the active-state boundary;
no active state has zero outputs. A singleton selected support cannot be
legally VPS-split, even when other input rows make the mask nonconstant.
Equal indices are excluded. Duplicate patterns with unequal values are legal
for PPM; disjoint patterns with unequal values are illegal for VPM. Zero or
unit PPS ratios remain illegal. No data are fabricated for ambient zero
columns; C03/C06 restriction remains the preexisting entry route.

## 6. Witness-parameterized recovery and C09 handoff

Use semantic channel equality on fixed output types. For different packaged
presentations, supply a specific output equivalence e and the row equation
`forall x, (A.channel x).map e = B.channel x`, with coordinate equations and
the cardinality bridge. C06 transports singularity and perfectness across
this equation; C07 does not prove operation perfectness.

Required recovery laws:

1. **PPS then PPM:** merging its adjacent children is legal and recovers every
   original PMF row exactly, with identity output ordering. Retain the strict
   ratio used by the split for the other direction; do not claim the merge
   output determines it.
2. **PPM then PPS:** for old values u and v at a<b, take the NNReal ratio
   `u.toNNReal / (u+v).toNNReal`. Prove denominator positivity/finiteness,
   strict ratio bounds and both product identities, including `u+v=1`.
   Split the merged column at the survivor index with this ratio. The first
   child recovers old a, the second old b, and unaffected columns are recovered
   under the explicit permutation below. No arbitrary choice of ratio suffices.
3. **VPS then VPM:** the adjacent children have equal values and disjoint
   nonempty patterns, so their VPM exactly recovers the original channel.
   The same mask recovers the split result; recovering a unique global mask
   is neither needed nor true.
4. **VPM then VPS:** use a mask selecting the old smaller column's support
   inside the union; for example its indicator on all inputs. Both child
   support witnesses come from old activity. Recover both original columns
   and every unaffected column under the same permutation. This must include
   common value one; a `<1` premise is not an acceptable hidden repair.

For an original n-column channel with `a<b`, merge then adjacent split yields
the ordered list of original labels
`[0,...,a-1,a,b,a+1,...,b-1,b+1,...,n-1]`.
Supply an explicit equivalence `rho : Fin n ≃ Fin n` from this new order to
the old order. Its numeric action is:

- `rho j = j` for `j <= a` or `b < j`;
- `rho (a+1) = b`;
- `rho j = j-1` for `a+1 < j <= b`.

Express the recovered rows on `Fin n` using Section 3.2's cardinality
equivalence, and call that channel `recoveredRow`. Require
`(recoveredRow x).map rho = S.channel x`; the packaged equation uses `e_rec`,
including the proved cardinality transport. Prove the inverse direction
as a usable corollary and the adjacent case `rho = Equiv.refl`. The split-to-merge
round trip uses only adjacent indices and needs no nontrivial permutation.
Prove selected and unaffected formulas before concluding equality by PMF/matrix
extensionality. A regression with a nonadjacent pair producing a three-cycle
must detect reversed use of rho.

Use this concrete R07 fixture: one input row with masses
`[1/10, 2/10, 3/10, 4/10]`, merging indices 0 and 3. All columns are active,
singular and have the same singleton pattern. The merge gives
`[1/2, 2/10, 3/10]`; splitting its first column with recovered ratio `1/5`
gives `[1/10, 4/10, 2/10, 3/10]`. Here rho has images `[0,3,1,2]`.
Mapping the recovered row by rho gives the original, while mapping it by
`rho.symm` gives `[1/10, 3/10, 4/10, 2/10]`, which differs at index 1.
Require both the correct equality and the wrong-direction inequality as
compiling regression facts. The inverse-direction recovery corollary instead
maps the *original* row by `rho.symm` to the recovered row. Unequal selected
values alone do not detect reversal because the lower selected position is
fixed by rho. This fixture supplements the generic recovery theorem.

C09 must be able to instantiate the PPS kernel/common merge/VPS row map and
each recovery theorem without unfolding private definitions or manufacturing
illegal witnesses. S04 supplies generic compiling consumers with exactly
these hypotheses and the existing C06 output-equivalence theorem. C09 retains
all actual perfectness witnesses and null-posterior analysis. C08 retains
path-level reindexing, local rewrites and termination; C07 promises no global
equivariance theorem for arbitrarily relabeled ordered operation arguments.

## 7. Module and import ownership

| Proposed module | Responsibility |
| --- | --- |
| `PerfectFunctionalRepresentations/Matrix/Operations.lean` | Shared index/PMF core and both legal pairs with semantic equations, coordinate/data laws and recovery. Import `Matrix.SingularColumns`, supported `LeanInfoTheory.Probability.FiniteMixture`, and focused Fin/ENNReal modules actually needed. |
| `PerfectFunctionalRepresentations/Tests/Matrix/Operations.lean` | Legality, edge, indexing, recovery, numeric and generic downstream consumers. |
| `PerfectFunctionalRepresentations/Tests/Examples/MatrixOperations.lean` | Private shared Equation (11) fixture and complete Equations (12)-(15) checks under strict beta. |

Namespace is `PerfectFunctionalRepresentations`; no PMF namespace extension is
needed. The root stays unchanged and light. No production import of tests,
fixtures or unstable dependency internals. Common index machinery stays in
Operations initially; split a focused helper module only if actual size/reuse
justifies it, with the reason recorded. Promote only helpers used by both
operation pairs or promised C09 consumers. No four-file hierarchy is mandated
merely because there are four operation names.

Consumer visibility is determined by the following inventory, not by a quota
of public declarations:

| Consumer-visible contract | Implementation detail that may remain private |
| --- | --- |
| Four legal state constructors, their cardinality equations and separate singularity theorems, with Section 5's exact hypotheses. | Packaging proofs, activity witnesses and one-use arithmetic. |
| PPS refinement kernel, common merge map and VPS row-dependent map, available as named terms or explicit terms in usable theorem signatures; their semantic bind/map equations. | Raw construction helpers and fiber-sum reductions not needed to instantiate those terms/equations. |
| Selected/unaffected coordinate and column-data laws in exact and Real form, with the specified index maps and numeric/support bridges. | Intermediate rewrites and conversion proofs; no separate public family for each proof step. |
| All four recovery contracts, legal inverse witnesses, explicit cardinality/output equivalences and forward/inverse row equations. | The internal proof of the permutation and its exhaustive cases, beyond coordinate laws actually needed by consumers. |

S04's generic consumers must access these contracts through the production
module, without opening private helper definitions. This inventory clarifies
the existing handoff; it introduces no general operation relation, new state
record or public fixture family.

## 8. Verified reuse and feasibility evidence

The actual pinned source and discovery documentation were searched, and the
focused compiling probes and exact commands are recorded in the planning notes.
These are existing declarations, unlike the proposed operation names above:

- PFR C06: `ActiveFiniteChannel`, `ActiveFiniteChannel.activeEquiv`,
  `massMatrix`, `realMatrix`, their row-sum/injectivity/reconstruction theorems,
  `columnValue_eq_of_ne_zero`, `columnValue_pos`, `columnValue_le_one`,
  `columnValue_ne_top`, `columnPattern`, `mem_columnPattern`, `column_eq_ite`,
  `columnData_unique`, `columnValue_transport`, `columnPattern_transport`,
  `relabelChannel` and `isPerfectlyRepresentableChannel_relabelChannel_iff`.
- Supported LeanInfoTheory `Probability.FiniteMixture`: `PMF.binaryMixture`,
  `PMF.binaryMixture_apply`. The parameter is NNReal and weights the first
  component; this avoids rebuilding a Bernoulli mixture. Its raw endpoints
  do not relax the active PPS contract.
- Pinned mathlib PMF: `PMF.bind`, `PMF.map`, `PMF.pure`, their atom formulas,
  composition and extensionality. Use the installed finite-sum reduction for
  fiber calculations, without inventing a generic information theorem.
- Pinned Fin: `Fin.succAbove`, `finSuccAboveEquiv`, `Fin.insertNth` and their
  selected/unaffected coordinate equations. A candidate collapse is
  `Fin.insertNth b r id`. Do not use `Fin.predAbove` as if its pivot admitted
  every source column; deletion of the last column must remain valid.
- Pinned cardinality transport: `finCongr`, `Fin.cast`, `finCongr_apply`,
  `finCongr_symm` and `Fin.val_cast`. Revision-2 type-only probes check the
  proposed wrapper and recovery signature shapes with local function
  parameters; they do not define or prove the proposed operations.

The probes verify declarations, signatures and applications, not any C07
closure or recovery theorem. No existing paper-specific four-operation API
was found. No LeanInfoTheory discoverability defect or upgrade is inferred
from this normal local construction work. Exact additional arithmetic names
may be selected during the authorized proof after a compiling check.

## 9. Proposed execution steps and acceptance criteria

Five steps follow the proof dependencies: common order/PMF machinery, two
operation pairs with their own recovery, integrated fixtures/consumers, then
fresh cumulative closeout. The PP and VP pairs share S01, not a new abstract
operation calculus. Each requires its own separately processed request; no
later step follows automatically.

### PFR-C07-S01 - Ordered index maps and semantic operation core

Prerequisite: approved exact C07 plan and completed C06. Implement only Section
4 and Section 6's rho construction/index laws, not its operation recovery
theorems. Add raw PMF
helpers and exact/Real selected/unaffected coordinate formulas; do not claim
active legal operation closure yet. Own R01-R03.

- **C07-S01-C01:** Index maps, exhaustive fibers, explicit dimensions and rho
  satisfy paper order for every legal index, including the last merge column.
- **C07-S01-C02:** Semantic bind/map equations and every raw coordinate/row-sum
  formula in Section 4 compile, with justified numeric conversions and no
  extra input/singularity assumption.
- **C07-S01-C03:** R01-R03, focused/default/prerequisite builds, new public
  signature/axiom and import audits pass; initial implementation notes map
  the source repair and raw-versus-active boundary.

### PFR-C07-S02 - Pattern-preserving pair and recovery

Prerequisite: durable S01 completion. Implement legal PPS/PPM, their complete
Section 5 closure/data contracts, and Section 6 recovery laws 1-2. Derive the
ratio and its strict bounds; reuse the common merge. Own R04-R08.

- **C07-S02-C01:** PPS and PPM legal domains, state cardinalities, normalization,
  activity, singularity, all exact/Real coordinates and column data are proved.
- **C07-S02-C02:** Both PP recovery directions include legal witnesses,
  denominator/ratio identities, all unaffected columns and the correctly
  directed explicit equivalence; no global inverse is asserted.
- **C07-S02-C03:** R04-R08 and all affected earlier regressions/builds/audits
  pass; consumer-facing kernels/recovery are accessible, and documentation
  records source/order/numeric obligations without starting VP work.

### PFR-C07-S03 - Value-preserving pair and recovery

Prerequisite: durable S02 completion and the explicitly approved value-one
interpretation in this exact plan. Implement legal VPS/VPM, Section 5 closure,
support/indicator bridges and mask irrelevance outside selected support, and
Section 6 recovery laws 3-4. Own R09-R13.

- **C07-S03-C01:** VPS/VPM use the exact nonempty/disjoint support and equal
  value conditions; all state, exact/Real coordinate and column-data formulas
  hold, including common value one.
- **C07-S03-C02:** Both VP recovery directions supply legal masks, exact
  adjacent recovery and explicit nonadjacent output equivalence, without
  assuming unique masks, strict value bounds or arbitrary output-only VPS maps.
- **C07-S03-C03:** R09-R13 and affected cumulative builds/audits pass; failures
  of weaker legality conditions are tested, and the approved manuscript
  interpretation and downstream boundary are recorded.

### PFR-C07-S04 - Examples, regression handoff and review readiness

Prerequisite: durable S03 completion. Own R14-R16, complete all R01-R16, and
prepare a declaration-to-anchor/criterion/consumer audit. The shared fixture
has Real parameter beta with `0 < beta < 1`; construct it through C06's
existing coordinate or column-data constructor and check all five columns
active and singular. Prove all entries of Equations (11)-(15), not a selected
entry or just normalization. Lean split index 1 uses ratio 1/2; PPM indices
3/4 include the last column; VPS index 0 uses `[true,true,false]`; VPM indices
0/2 are nonadjacent. Public fixture names are not required.

- **C07-S04-C01:** Examples 2-5 are complete parametric compiling fixtures
  with exact numeric/Real bridges, explicit legality and printed column order.
- **C07-S04-C02:** R01-R16 and the generic C08/C09 interface consumers pass;
  the readiness audit maps every earlier criterion and CC01-CC10 to actual
  declarations/tests, with every source repair and later owner accounted for.
- **C07-S04-C03:** All relevant module/default builds, public API/trust/import
  and source/hygiene checks pass. Owning documents honestly report review-time
  readiness and preserve original reports. They do not certify future F or
  closure. No later mathematical consumer is proved to satisfy this criterion.

### PFR-C07-S05 - Fresh cumulative independent validation and closeout

Prerequisite: durable S04 completion and its own explicit request. Freshly
recheck all twelve S01-S04 criteria, R01-R16, CC01-CC10, exact manuscript
anchors, all public assumptions/proofs, dependency reuse and trust/import
boundaries. Earlier passing reports are historical evidence, not substitutes
for this new source-based assessment by the same bound reviewer.

- **C07-S05-C01:** A fresh cumulative mathematical/source/consumer assessment
  establishes all earlier criteria, R01-R16 and CC01-CC09 at the actual source.
- **C07-S05-C02:** The same reviewer independently assesses every earlier
  criterion and completion outcome, with a consolidated report and exact
  checks/limitations. At review time this assesses the current source and
  readiness, not future receipt/reconciliation of that very report. After
  receipt, retain and reconcile every original report; material findings and
  criterion gaps receive adequate correction and a new satisfactory
  independent assessment where required by the protocol before closure.
- **C07-S05-C03:** CC10 review-time readiness, cumulative validation and
  documented applicability support finalization. After the report, complete
  reconciliation/corrections, owning-document updates, final applicable
  checks, F capture and supported durable closure. Only that later closure
  marks the chunk complete; a reviewer cannot certify its own future receipt.

Bounded in-contract corrections are permitted during closeout, with renewed
checks and review where impact requires. A substantive missing outcome,
source interpretation or scope change triggers escalation and stop with
recoverable records; it is not quietly deferred or replaced by an easier claim.

## 10. Regression allocation

These are required behavior/contract consumers, not a quota of trivial tests.
Generic parametric checks should accompany small non-symmetric fixtures.

| ID | Owner | Required observation |
| --- | --- | --- |
| R01 | S01 | First/last split positions and adjacent/nonadjacent/final-column merge fibers; non-involutive rho direction. |
| R02 | S01 | Raw PMF kernels/maps, exact and Real selected/unaffected formulas and row sums, without input nonemptiness where unnecessary. |
| R03 | S01 | n=1 split core and impossible distinct pair for n=1 merge; cardinality transports and no unchecked cast. |
| R04 | S02 | Strict PPS on a value-one column with unequal weights, both active children and unchanged other columns. |
| R05 | S02 | PPM on repeated patterns with unequal positive values, including sum exactly one and a final source index. |
| R06 | S02 | PPS/PPM adjacent recovery, remembered unequal ratio, exact row equality. |
| R07 | S02 | Section 6's one-row `[1/10,2/10,3/10,4/10]` fixture at indices 0/3: ratio 1/5, three-cycle rho, actual mapped-row equality in both directions, and inequality when rho.symm is wrongly applied to the recovered row. |
| R08 | S02 | Endpoint PPS ratios fail active legality; unequal-pattern PPM is rejected without falsely asserting every raw unequal-pattern merge is nonsingular. |
| R09 | S03 | Nondegenerate VPS at value one, support partition/indicator formulas and exact row-dependent map. |
| R10 | S03 | Globally nonconstant mask constant on a selected proper support fails VPS legality; singleton support cannot split; masks agreeing on support give identical channels. |
| R11 | S03 | VPM disjoint supports with equal value including one, nonadjacent and final indices; overlapping or unequal-value hypotheses do not meet its legal domain. |
| R12 | S03 | VPS/VPM adjacent exact recovery with remembered mask, including rows outside selected support. |
| R13 | S03 | VPM/VPS nonadjacent recovery with constructed support mask, common value one and actual rho transport. |
| R14 | S04 | Entire parametric Equation (11) and Equations (12)-(15), all operation hypotheses, selected and unaffected columns; endpoints beta=0/1 are not active suite instances. |
| R15 | S04 | Generic consumers instantiate all four legal operations and recovery directions with only advertised hypotheses; reuse C06 relabeling for actual endpoints without proving C09 preservation. |
| R16 | S04 | C06 prerequisite/root regression builds and import audit; operations/tests/examples remain absent from the lightweight root and no prior restriction enters the operations. |

## 11. Completion outcomes and validation

| Outcome | Required cumulative evidence |
| --- | --- |
| CC01 | Exact manuscript identity, Section III-A allocation and every interpretation/omission recorded. |
| CC02 | All four legal domains and explicit dimension/order contracts, including all source merge indices. |
| CC03 | Semantic PMF construction equations and exact/Real formulas for selected and unaffected columns. |
| CC04 | Row normalization, activity and singularity for all operations with permitted edge cases. |
| CC05 | Exact/Real values, nonempty support patterns, indicator bridges and unaffected data formulas. |
| CC06 | All four witness-parameterized recovery directions, strict recovered ratio and explicit output equivalence. |
| CC07 | Approved value-one resolution, support-degenerate guards and complete Examples 2-5 fixtures. |
| CC08 | R01-R16 and usable generic downstream consumers; no hidden later-chunk implementation or dependency cycle. |
| CC09 | All builds, public declaration/axiom/import audits, placeholder scan, pinned dependency and worktree hygiene. |
| CC10 | Owning documents, omission/deferral dispositions, cumulative independent report and reconciliation readiness; subsequent final checks/F/durable closure separately completed. |

During each authorized coherent change build `PerfectFunctionalRepresentations.Matrix.Operations`
and touched tests plus the important downstream aggregates that actually exist.
S04/S05 include both new test modules, both C06 test modules,
`PerfectFunctionalRepresentations.Tests.Examples.Nonrepresentable3x3Columns`,
the C03 singularity regressions and root. Run `lake build` before each milestone.
S05 also reruns all maintained test/example modules, not only the default target.

Inventory every new public declaration; compile exact signatures and
`#print axioms`, allowing only the project's existing standard axioms and no
proof placeholders. Require this scan to have no matches:

```powershell
rg -n --glob '*.lean' '\b(sorry|admit|axiom|opaque|undefined)\b' `
  PerfectFunctionalRepresentations PerfectFunctionalRepresentations.lean
```

Inspect final diff, status, pins, tracked generated/reference files and
temporary artifacts. Preserve inherited work and private records. Discovery
probes stay ignored; compile failures remain negative observations, not
evidence of an absent API. Incremental build invocations must not be described
as clean dependency rebuilds.

For later explicit review requests follow the installed protocol unchanged:
exact one-step authority; B before edits, R at independent dispatch, F after
final corrections/documents; contextual self-review and separate reassessment;
neutral source-bound request; original native receipts/reports and reconciliation;
one writer and supported closure. Unknown effective settings remain unknown.
Bound waits to 60 seconds and increase repeated uninformative short waits within
that bound; continue useful independent work. A timeout is pending, not failure
or a reason to resend. No execution or plan-review session is opened by this draft.

## 12. Omissions, deferred work and document maintenance

Retain the map's immutable omission identifiers. Relevant dispositions:

| Register | C07 handling and later owner/trigger |
| --- | --- |
| OM-014, OM-044, OM-045, OM-068 | Consume C06 enumeration/state/data. No redesign or zero-column value. C10/C11 revisit their own zero-weight/fiber removal when constructing cascades. |
| OM-024; OM-070 retained as its duplicate cross-reference | OM-024 owns the full source merge-index correction. S01-S03 prove exact order/mass contracts; S04 checks the final-column and nonadjacent examples. Preserve OM-070's identifier and original rationale. |
| OM-026 | Owns the private-fixture/public-name policy for Examples 2-5. Revisit promotion only for a concrete C08/C09 consumer. OM-050 separately owns the missing beta hypothesis. |
| OM-037 | Prove operation closure; do not encode prose adjectives or reprove completed canonical facts. |
| OM-038 | Adopt support-nondegenerate active VPS. Raw zero children receive no Definition 4 data; no pruning theorem is promised. Revisit only if a later C08/C10 consumer needs one. |
| OM-049 | Proposed inclusive value-one repair in Section 3; lead decision required. Strict simulation remains an alternative, not an approved deferred correctness obligation. |
| OM-050 | Strict beta hypothesis for Examples 2-5; S04 owns complete display coverage. Public-name policy is owned by OM-026. |
| OM-051 | C07 owns four witness recovery directions; C08 owns endpoint/path equivalence and normalized cascades. |
| OM-052 | C10/C11 own multiway/partition constructions when those chunks are planned; no finite cascade implementation here. |
| OM-042, OM-043 | C08 owns Lemma 4 and extended (167)-(174); C09 owns Lemmas 5-6 and (175)-(202). They are consulted only to define handoff requirements. |

The map also records the exact merge-index correction and the intentional
private-fixture policy for the reviewed III-A anchors. No unrelated
extended-only statement, external cited result or public theorem for each
display is added. Definition 4 is completed C06; adjacent Lemma 4 and III-B
are later scope, not silent omissions from C07.

The authoritative numbered Future Work Notes register was checked; none
exists. Relevant mapped obligations above retain owner and revisit trigger,
so no duplicate numbered note is needed. Uncertain optional promotion of
fixture names/general reindexing helpers is reassessed when C08/C09 supplies
a real consumer. New worthwhile suggestions without an owner/trigger must
receive a numbered log note and normalized summary entry; required acceptance
cannot be bypassed by deferral.

The plan owns contracts. Planning/implementation notes own attributed discovery,
proof choices and actual results; a readiness audit owns cumulative mappings.
Update the living summary, map and project log with material coverage, decisions,
risks and deferral dispositions in the same change. Update README/scope/roadmap
concisely when their current status changes. Preserve C01-C06 closed bytes and
original reports; reconcile their later closure in current documents.

## 13. Revision and approval policy

Approval must identify this exact revision and settle DG-08, expressly including
the value-one VPS interpretation. Approval alone starts no step. A later eligible
step request authorizes exactly one approved step, not automatic continuation.

During execution, justified proof-route, helper-name and module-organization
improvements may be made with reasons and review of the actual result. Preserve
all original reviewed records and acceptance outcomes. Changes in mathematical
intent, active legality, source interpretation, recovery strength, scope or
acceptance require the lead. Follow the installed frozen normative contract and
revision handling; never silently edit acceptance to fit a proof. The reserved
status block holds only editorial status/history, not requirements.

This revision incorporates selected advisory refinements; their attribution,
dispositions and verification limits are in the planning notes. Revision 1's
original plan/review records are retained. No mathematical implementation,
new independent review, approved-plan registration, dependency/workflow change,
commit or push is included. Revision 2 and DG-08 await explicit approval.

## 14. Criteria for a separately requested plan review

These criteria assess this proposal, not nonexistent C07 proofs. They do not
dispatch review or approve the plan.

- **C07-PR01:** Baseline/prerequisite applicability, designated manuscript
  anchors, scope and non-goals are established without reopening completed
  mathematics or treating a preserved pre-F checkpoint as unfinished work.
- **C07-PR02:** Proposed legal domains, index/dimension order, semantic
  constructions, selected/unaffected coordinates and column-data contracts
  express all four intended operations and their edge cases.
- **C07-PR03:** The value-one discrepancy and strict alternative are justified,
  approval boundaries and downstream consequences explicit, with no silent
  strengthening of C06 or unresolved cyclic dependency in the recommended route.
- **C07-PR04:** Witness-parameterized recovery is strong enough for C09 and
  includes explicit nonadjacent reindexing, remembered parameters, legality
  and null-support behavior, without proving later consumers or global inverses.
- **C07-PR05:** Verified reuse/probes, ownership/imports, dependency-driven
  steps, Examples 2-5, R01-R16 and CC01-CC10 make the proposal feasible and
  reviewable; proposed names are distinct from verified declarations.
- **C07-PR06:** Source repairs/omissions, mapped deferrals, document duties,
  revision policy and fresh cumulative review are complete, with review-time
  readiness distinct from subsequent final capture and durable closure.
