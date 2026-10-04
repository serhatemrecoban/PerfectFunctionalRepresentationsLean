# PFR-C08: operation paths and Lemma 4 normalization

**Status:** Approved / Active, revision 2.
**Prepared / revised:** 2026-09-26.
**Authority:** the lead endorsed the delivered revision 2 and then requested
S01 with its review process. Together these messages approve this contract and
authorize S01 only. Later steps require their own requests. The lead also
confirmed that justified implementation refinements should use judgment,
retain the intended outcomes and be documented and reviewed.

<!-- pfr-review-status:start -->
S01-S06 are durably complete. S07 freshly validated the entire current C08
contract, all eighteen earlier criteria, R01-R18, CC01-CC10 and CC11 review-time
readiness. The same bound reviewer's complete original cumulative report
assesses all three S07 criteria SATISFIED without findings and is critically
reconciled. Final validation, F and supported durable closure follow this
pre-F checkpoint. Only their actual completion satisfies CC11 in full; the
private durable execution record determines acceptance. C09-C16 are unstarted.
See [implementation notes](../pfr-c08-implementation-notes.md) and the
[readiness audit](../pfr-c08-readiness-audit.md) for exact evidence and limits.
The normative approved contract is unchanged. Only S07 is authorized.
<!-- pfr-review-status:end -->

## 1. Baseline and prerequisite applicability

The baseline is the actual dirty working tree at HEAD
`54c1714d1a9a891939d6c9f7d38c0d05896b2c75`, not HEAD's older mathematics.
All inherited tracked/untracked work is preserved. Startup captures, binding,
discovery and attributed evidence are indexed in
[C08 planning notes](../pfr-c08-planning-notes.md).

C07's approved revision 2, actual C06/C07 source, readiness audit, implementation
notes and original durable records were inspected. Final C07 S05 closure is
`6f0c6d6bd8c496c578db3a5b7ff4b73a776b534c35fddb99823641a5a9ea58d2`;
F is `084701230c34b26785fa43e78f25be90c0ba3a775e1dea38f39f2a0e3c56c879`.
Before planning-document edits all 114 F entries matched current bytes,
including 113 concrete files and the reconstructed environment. All five
original reports are reconciled, all criteria satisfied, and no open finding
or lifecycle restriction remains. The preserved pre-F C07 documents are
historical checkpoints; their wording does not reopen completed mathematics.

C01's historical closeout and C02-C06's final closure/report/reconciliation
objects and source applicability were checked proportionately. Earlier
differences are subsequent root integration, owning documents and the authorized
review-tool repair. Earlier non-root mathematics, closed plans and pins remain
exact. This is not a new independent mathematical review of C01-C07.

LeanInfoTheory remains immutable `v0.1.0`, commit
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`; mathlib remains `v4.33.1`,
commit `0df444a360eaa60ab8c11dca51a86af692955474`; Lean is `v4.33.1`.
All ten installed dependencies were clean and matched their configured revisions.
Fresh planning checks and retained C07 evidence are distinguished in the notes.

## 2. Manuscript anchors and interpretation

Both designated PDFs were freshly hashed and their page counts checked.
The relevant pages were extracted and visually inspected. Reference media and
extracts remain external or ignored, never maintained deliverables.

| Source | Identity and exact anchors |
| --- | --- |
| Six-page ISIT final, local filename ending `final_manuscript_ (3).pdf` | SHA-256 `48963AA59485B2C33B1A1E6E7C6EAD2251FDDDD26BD3691B6FCFFE683E6ED1C4`; PDF p. 3, Section III-A, paragraph introducing order manipulation and Lemma 4 at the end of the right column. Operations 1-4 and (11)-(15) supply inherited C07 conventions. |
| Designated eighteen-page extended draft, filename version 16, designated 2026-09-03 | SHA-256 `98636D4C9F0618EC08FCA84559572780F604F197FDA90D8D7C787B3624245B8F`; Lemma 4 statement on PDF p. 4, left column; Appendix B starts on p. 14, right column. Its Lemma 4 proof runs through p. 15, left column, immediately before the proof of Lemma 5. |
| Extended (167) | p. 14: the two VPS support pieces partition the selected pattern, with ordinary addition of indicators. |
| Extended (168)-(169) | p. 14: PPM followed by PPS, with the shared-column case replaced by two PPS and two PPM operations. |
| Extended (170)-(171) | p. 14: VPS followed by PPS on a child, replaced by one PPS, two VPS and one PPM. |
| Extended (172)-(173) | p. 15: PPM followed by VPS, replaced by two VPS and two PPM operations. |
| Extended (174) and concluding paragraphs | p. 15: the three out-of-order tag pairs and the asserted eventual normal form. The latter needs the rigorous argument in Section 6. |

ISIT p. 4 III-B and IV-A were read only to identify downstream contracts:
both reachability directions, and the use of normalized stages to extract
partition weights. Their theorems/constructions remain C09-C13. Extended
(149)-(166) and (175) onward adjoining the proof are outside C08.

The intended assertion is about equivalent channels after a finite legal
cascade, with output names allowed to change. It does not require perfect
representability. This plan makes equivalence an explicit bijection and
pointwise PMF-map equation, not equality of unordered value/pattern multisets.

One additional ordering issue is visible in (171). With the displayed four
intermediate columns and C07's lower-index survivor, the last merge leaves
`[t*c*p1, c*p2, (1-t)*c*p1]`. The printed endpoint is
`[t*c*p1, (1-t)*c*p1, c*p2]`. The final two labels must be exchanged.
The plan proves the directed permutation, including unaffected columns;
it does not assert literal ordered equality for this display. For arbitrary
nonadjacent columns, other local rewrites can also move intervening outputs.
OM-051 owns these explicit cascade-equivalence repairs.

For a concrete R09 fixture, start from the two-input one-output all-ones
channel, split its support into the two singleton patterns, then PPS the first
child with ratio 1/3. The original endpoint has rows `[1/3, 2/3, 0]` and
`[0, 0, 1]`. The displayed normalized construction with C07 ordering has rows
`[1/3, 0, 2/3]` and `[0, 1, 0]`. Its forward equivalence sends labels
`0,1,2` to `0,2,1`. This also checks the approved value-one VPS boundary.

Keep C07's approved strict PPS ratios, inclusive value-one VPS, nonempty
selected-support pieces, adjacent insertion and lower-index merge survivor.
No strict-VPS alternative is revived. Reauthenticate and reassess the affected
contracts if the lead designates a new companion manuscript.

## 3. Scope, ownership and non-goals

C08 owns tagged operation paths, explicit endpoint equivalence, transport and
composition, all three local interchange families, and a rigorous proof of
the PPS/VPS/PPM normal form. It uses `ActiveFiniteChannel alpha` with separate
singularity proofs and `[Finite alpha] [Nonempty alpha]`; finite-set views may
expose `[Fintype alpha]`. The input alphabet is fixed throughout a cascade.

The shared tag type includes all four existing operations so later consumers
can express both reachability directions without replacing the path type.
The VPM constructor is only a typed wrapper around C07. Lemma 4 applies solely
to paths whose tags are PPS, VPS or PPM. C08 proves no VPM normalization claim
and no semantic reachability characterization or path-reversal theorem.

Proposed module ownership, all under `PerfectFunctionalRepresentations`:

| Module | Responsibility |
| --- | --- |
| `Matrix/OperationPaths.lean` | Minimal public step/tag, concrete path, output-equivalence and cascade boundary; transport/composition. Imports C07 Operations and focused mathlib path infrastructure. |
| `Matrix/OperationCalculus.lean` | Local interchange proofs, private finite factorization certificates and realization, public Lemma 4 normal-form theorem. Imports OperationPaths. |
| `Tests/Matrix/OperationPaths.lean` | Public-interface transport, composition and witnessed-recovery consumers. |
| `Tests/Matrix/OperationCalculus.lean` | Interchanges, finite-factorization boundary cases and normalized-stage consumers. |

Split a proof-support module only if actual size/import pressure warrants it.
Private certificate data are not a second public channel representation.
Keep `PerfectFunctionalRepresentations.lean` lightweight; matrix calculus and
tests remain separately importable. Do not alter C06/C07 public contracts or
edit their closed plans and reports. A genuinely necessary compatibility lemma
belongs to the new consumer module unless ownership evidence justifies otherwise.

Out of scope: C09 preservation/non-preservation, C10 arbitrary weighted or
partition reachability constructors, C11 canonical-coupling construction,
C12 compression, C13 partition-weight equivalence, LP results, executable
normalization complexity bounds, uniqueness/minimality/confluence, arbitrary
rewrite-strategy termination, zero-column pruning and dependency upgrades.

## 4. Proposed public contracts and DG-09 selection

Names in Sections 4-7 are proposals, not existing declarations. Exact spelling
and private decomposition may change; mathematical hypotheses and outcomes may not.

### 4.1 Witnessed steps and concrete paths

Use a Type-valued inductive `OperationStep S T`, with constructors for C07's
four legal operations. Each constructor retains selected indices, the strict
PPS ratio or VPS mask, all legality witnesses and the source singularity proof;
its target is the actual C07 result. It exposes a tag in
`OperationKind = {pps, vps, ppm, vpm}`. No free permutation is an operation.
State-owned `Fin S.outputCard` handles changing dimensions without unsafe casts.

Use the pinned `Quiver.Path` over this graph of active states, with its local
quiver instance controlled explicitly. This gives nil, extension, concatenation
and structural induction without a second generic path implementation. Define
the chronological `tags : List OperationKind` by recursion; prove append
concatenates tag lists and length agrees. A filtered-path predicate restricts
every tag to a supplied set/predicate; a homogeneous path has one chosen tag.
Nil is permitted for every block. Preserve singularity along paths from a
singular source, including the explicit nil case.

`Relation.ReflTransGen` was evaluated, not presumed selected. It is useful for
Prop-valued reachability after forgetting a witness, and can support existential
proofs. Plain untagged closure does not expose the actual word and parameters
as Type-valued data. A custom word-indexed relation could also work, but would
duplicate path infrastructure for this task. Add a forgetful closure theorem
only for a demonstrated consumer; the selected primary API is the witnessed path.

### 4.2 Explicit equivalence and cascades

`OutputEquiv S T` retains an actual
`e : Fin S.outputCard ≃ Fin T.outputCard` and
`forall x, (S.channel x).map e = T.channel x`.
Its orientation is always source labels to destination labels. Prove identity,
inverse, composition, cardinality equality, and exact coordinate consequences.
Use existing C06/C07 PMF transport facts, not entropy or prior hypotheses.

A concrete `Path S U` ends at exactly U. A paper-facing `Cascade S T` packages
that path and `OutputEquiv U T`; thus empty cascades can express pure output
relabeling while their tag word stays empty. No quotient erases the bijection.
For two cascades from the same source, equivalence means an explicit output
equivalence between their actual endpoints. Different sources require a supplied
source equivalence and the transport theorem, not an implicit identification.

First prove one-step transport: given `OutputEquiv S S'` and a concrete edge
`S -> T`, construct an edge `S' -> U` with the same tag and `OutputEquiv U T`.
For a split, the new-to-old child correspondence preserves left/right identity,
ratio and mask. For a merge, sort the transported pair into lower/higher order;
the output equivalence accounts for survivor movement and every unaffected
label. If a remembered recovery uses the original lower column, retain that
orientation explicitly instead of silently swapping its ratio or mask.

Lift this by structural path induction, retaining the exact chronological tag
word. Then compose cascades by transporting the second concrete path across
the inverse of the first endpoint equivalence. Prove identity/associativity at
the semantic endpoint level and tag concatenation; do not demand judgmental
equality of chosen witnesses. These proofs precede interchange and normalization.

### 4.3 Normal form usable by later chunks

The central contract has the following shape:

```text
normalize (hS : IsSingularChannel S.channel) (p : Path S T)
  (allowed : every tag of p is PPS, VPS, or PPM) :
  exists A B C,
    exists pp : Path S A, exists vp : Path A B, exists pm : Path B C,
      only PPS pp and only VPS vp and only PPM pm and Nonempty (OutputEquiv C T)
```

Expose these witnesses through a small `NormalForm S T` package, with all
three actual paths, their homogeneous-tag proofs and the directed final
equivalence as data. The theorem may return `Nonempty (NormalForm S T)`;
the package itself retains the actual bijection and all step witnesses.
Existence is sufficient; no runtime algorithm is promised.
Expose the converse by concatenation with this proposed signature:

```text
NormalForm.toCascade (nf : NormalForm S T) : Cascade S T
```

Its concrete path is `pp` followed by `vp` followed by `pm`, ending at C;
the stored `OutputEquiv C T` supplies the cascade's final comparison. Prove
that every tag of this path is PPS, VPS or PPM. This construction does not
need a source-singularity premise. Also expose normalization of an allowed
`Cascade S T` under `hS : IsSingularChannel S.channel`.
The source is exactly S; the final labeling is compared with T by the bijection.
The intermediate states A, B and C are active by their state type. Their
singularity consequences take `hS` explicitly and propagate it along the
three stored paths, including when any or all stages are empty. Keep this
premise visible in public accessors or generic consumers; an arbitrary
`NormalForm S T` package alone need not certify singularity of a nil source.

C10/C11 can concatenate typed certificates, transport labels and inspect legal
steps without reconstructing parameters from an existential relation. C13's
partition-weight argument can inspect each homogeneous block by induction,
recover its intermediate channel and use C07's positive-value/support formulas.
It must not depend on C08's private factorization trees. No arbitrary weight
family, exact-partition API, all-ones reachability theorem or numerical
partition-weight identity is proved in C08. These are later owned consumers.

## 5. Complete local interchange obligations

Each law starts with two concrete legal edges, returns a finite path with the
specified ordered tags and a directed endpoint equivalence, and preserves the
starting state exactly. Selected and unaffected coordinates both matter.
All legality witnesses are constructed; no extra generic-position hypothesis is
allowed. Disjoint cases have one operation of each type in reversed order.

| Original pair | Overlapping replacement | Cases and source coverage |
| --- | --- | --- |
| PPM; PPS | PPS; PPS; PPM; PPM | Split the merged survivor with the same strict ratio on both original columns; otherwise use the unique unaffected preimage. Covers (168)-(169), final higher index and arbitrary gap. |
| VPS; PPS | PPS; VPS; VPS; PPM | PPS acts on the left child, right child, or an unaffected column. Split the parent with the same ratio, apply the remembered mask to both copies, then merge the two copies of the unsplit sibling. Covers (170)-(171); right-child case is separately accounted for. |
| PPM; VPS | VPS; VPS; PPM; PPM | On the survivor, both original equal-support columns inherit the same two nonempty pieces; otherwise use the unaffected preimage. Covers (172)-(173). |

(167) is the checked support-disjointness/union and indicator-sum bridge from
C07, used to justify every support split. (174) identifies exactly the three
inversions for the order PPS < VPS < PPM. It does not supply a decreasing measure.

State each comparison map by images of descendants and unaffected labels,
using the actual C07 insertion/deletion maps. Prove bijectivity and the forward
row-map equation; derive the inverse equation rather than guess its direction.
Small convenient block notation must be connected to actual `Fin` labels.
In particular, test (171)'s transposition, the right-child counterpart, and a
nonadjacent example whose relevant permutation is not self-inverse. Use distinct
patterns and unequal weights so equality cannot conceal a reversed permutation.

These laws may remain private with maintained anonymous tests beside the
private declarations in the same module. The same placement rule applies to
S04 certificate checks; a separate test module cannot name private declarations.
Separate test modules exercise the public path/normalization interface. Their full
logical content is mandatory even though Section 6 uses structural factorization
instead of an unproved global rewrite strategy. Exposing a stable public
interchange family requires a real second consumer, not one name per display.

## 6. Rigorous structural factorization

### 6.1 Finite certificate and invariant

Use a private finite three-layer forest certificate attached to a *given*
PPS/VPS/PPM path. All trees are ordinary finite binary trees, not recursively
defined reachability predicates or assumed normalized paths.

Pinned tree alternatives were inspected and checked: `BinaryTree` labels
internal nodes but not leaves; `FreeMagma` labels leaves but not internal nodes;
`WType` can encode both with extra shape/leaf machinery. Reuse `BinaryTree` with
explicit leaf labels if that remains small, otherwise use a private paper-specific
inductive carrying the two kinds of labels and legality data. This is a bounded
certificate representation choice, not authority for a generic tree library.

1. For every source column i, an outer PPS tree records strict ratios at
   internal nodes. A leaf is a sheet with positive coefficient w (the product
   of its branch ratios); the coefficients for this source sum to one.
2. Each sheet carries a binary VPS tree partitioning the source support P_i.
   Its internal nodes retain masks and nonempty child-support witnesses.
   Every leaf is assigned a current endpoint label j and has *exactly* that
   endpoint's nonempty support P_j. Within one sheet these supports are pairwise
   disjoint and cover P_i; hence j occurs at most once in that sheet.
3. For every current output j, a nonempty binary PPM tree gathers exactly its
   assigned fragments. A bijection matches all gathering-tree leaves with all
   sheet-tree leaves, once each. Each fragment from source i and sheet w has
   exact mass `w * v_i` on P_j and zero elsewhere. Every internal gather node
   merges equal nonempty supports. The root sum is the actual value of j.

Use NNReal coefficients and the existing admitted ENNReal values (or their
verified finite NNReal conversions). Prove the pointwise PMF-coordinate identity,
not only a sum of nominal values. Retain output/fragment enumeration bijections;
equality of unordered trees does not settle ordered channel equality. The
identity certificate has one sheet and one support leaf per source column,
and one gathering leaf per endpoint. It uses coefficient one without a PPS step.

### 6.2 Closure under appending one original operation

The invariant is proved by induction on the original witnessed path. Each
extension uses bounded traversals of the already finite trees:

- **PPS on j with ratio t:** refine every sheet containing a j-leaf into
  two sheets with coefficients t*w and (1-t)*w. Copy its entire support tree,
  replacing j by the left output in one copy and the right output in the other.
  Both new j gathering trees copy the old tree with the corresponding leaves.
  For every other affected fragment, replace its gathering leaf by a two-leaf
  merge joining the scaled copies; their sum restores its original mass.
  Unaffected sheets remain as they are. Thus other columns are preserved even
  when a sheet contains several different support pieces. All new ratios are
  the given strict ratio, and no zero sheet or degenerate support leaf appears.
- **VPS on j:** in each contributing sheet replace its j support leaf by the
  two mask children. Their supports are exactly the new endpoint supports and
  are nonempty because the original operation is legal. Duplicate j's gathering
  tree for the two new outputs with corresponding child fragments. Coefficients
  do not change, including when the admitted value is one.
- **PPM on a,b:** relabel the relevant support leaves to the new survivor and
  join the two gathering roots. A single sheet cannot contain both a and b:
  their equal nonempty supports would contradict disjointness of that sheet's
  partition. This proves the injectivity needed after label collapse. Positivity,
  pointwise root sums and the exhaustive fragment bijection are preserved.

Apply the actual index maps to all other endpoint labels in each update.
This includes endpoints between nonadjacent merged labels. These constructions
are simultaneous finite tree transforms, not recursive calls to normalization
on a longer rewritten path. They rely only on C06/C07 arithmetic/support data
and Section 4 transport. They do not assume Lemma 4, C09 preservation or C10
arbitrary partition/weight constructors.

### 6.3 Realization and finite recursion

Use one private correspondence invariant throughout the three traversals.
At each stage, a finite carrier describes the currently available objects:
unexpanded split-subtree roots, realized fragments, or roots of completed
gathering subtrees, as appropriate for that stage. These objects form the current
traversal boundary; they are not all nodes of the certificate at once.

- A bijection sends these objects to every actual current output label,
  exactly once. Each object's prescribed pointwise mass and support equal
  the coordinates and support at its corresponding label.
- A split replaces one available object by its two children. A merge replaces
  two distinct available child roots by their parent. The operation's legality
  follows from the certificate and coordinate invariant. Update every retained
  label using C07's insertion/deletion maps, including intervening columns.
- At stage boundaries, the certificate's leaf correspondences identify the
  completed layer with the next layer's starting objects and preserve the
  coordinate equation. No output or fragment is lost or counted twice.

S04 records the certificate's enumeration and coordinate interface for this
invariant. At the start of S05, check its local updates on a small legal PPS
followed by a nonadjacent PPM with an intervening output, as an initial case
of R15. This check precedes the full realization proof and does not depend on
the normalization theorem. Exact private carriers and helper decomposition
remain implementation choices; no public traversal framework is required.

Realize a valid certificate in three stages:

1. Traverse each outer tree, performing its recorded PPS at the current label.
2. Traverse each sheet's support tree, performing its recorded VPS at the current
   label. All sheet fragments are now present, with an explicit label bijection.
3. Traverse each gathering tree in postorder, performing PPM on its two child
   roots. Keep a bijection for still-available leaves and processed roots;
   update it by the lower-survivor deletion map after every merge.

Every tree recursion consumes a proper subtree, or the number of unprocessed
internal nodes in a fixed forest. Distinct child subtrees supply distinct
available columns; both have the prescribed nonempty support, so each PPM is
legal. No arbitrary fiber partition has to be synthesized: the gathering trees
were built during induction on the supplied path. Intermediate channel laws
come from C07 operations, so activity, row normalization and value bounds do
not rely on an assumed final normal-form theorem.

At the end, gathering-root labels correspond bijectively to T's labels, and
the coordinate invariant proves the forward PMF-map equation. Concatenating
these finite homogeneous paths yields Section 4.3. This establishes existence
for every finite original path even though the generated forest/path may grow.
The two structural inductions (original path; fixed certificate trees) are the
termination argument. Do not replace them with a claim about decreasing length
or inversion count of the manuscript's expanding word rewrites.

This private realization is restricted to recorded binary trees generated by
the original cascade. C10 retains the distinct task of constructing cascades
from arbitrary positive weights, exact partitions or finite same-pattern fibers;
C08 supplies no such general-purpose construction theorem. If implementation
shows that avoiding a new public general constructor is impractical, reassess
ownership before expanding scope. Never make C08 depend on C10, C11 or C13.
Any later extraction or promotion of these private constructions is an OM-052
consumer decision for the corresponding later approved plan.

## 7. Dependency-driven implementation steps

The seven steps below form the approved contract; the status region records
current execution. Each implementation request covers exactly one approved
step. Criteria are cumulative obligations, not
permission to start another step. S03 and S04 both consume S02; S05 needs both
the complete source coverage of S03 and the invariant of S04.

### PFR-C08-S01 — witnessed path and equivalence foundations

- **C08-S01-A:** Define witnessed four-kind edges, concrete paths, chronological
  tag words and homogeneous/allowed predicates; prove path concatenation/tag
  laws and singularity propagation with the existing active state.
- **C08-S01-B:** Define directed OutputEquiv with identity/inverse/composition,
  cardinality and coordinate consequences, plus the endpoint-wrapped Cascade
  and proposed NormalForm data boundary. No transport or normalization is assumed.
- **C08-S01-C:** R01-R03 compile; public signatures/imports and source-state
  boundary are audited. Verify a concrete ordered C07 operation embeds exactly.

### PFR-C08-S02 — ordered equivariance and cascade composition

- **C08-S02-A:** Prove all four operation-transport cases for arbitrary explicit
  source equivalences, including reordered merge arguments, left/right split
  orientation and complete unaffected-label equations.
- **C08-S02-B:** Lift transport along concrete paths with exact tag preservation;
  implement cascade composition and its semantic laws. Consume the existing
  remembered recovery equations in both map directions, without a new inverse claim.
- **C08-S02-C:** R04-R06 and asymmetric permutation consumers compile; tests
  distinguish permutation direction and confirm no added legality assumptions.

### PFR-C08-S03 — complete Appendix B local interchanges

- **C08-S03-A:** Prove PPM/PPS and PPM/VPS disjoint and overlapping cases with
  all legality, exact PMF coordinates and directed endpoint comparisons.
- **C08-S03-B:** Prove VPS/PPS for disjoint, left-child and right-child cases;
  resolve the actual (171) order and account for every unchanged label.
- **C08-S03-C:** R07-R10 compile; (167)-(174) are mapped to proofs/tests or the
  explicit structural-argument obligation, with no false termination claim.

### PFR-C08-S04 — finite factorization certificate and extension invariant

- **C08-S04-A:** Define only the private finite tree/fragment certificate needed
  by Section 6, with positive coefficients, legal support partitions, exhaustive
  leaf bijection and exact endpoint-coordinate invariant; establish identity.
- **C08-S04-B:** Prove closure under each of the three allowed appended operations
  by structural traversals, including PPS compensation of all other sheet pieces
  and the PPM same-sheet exclusion. No normalization theorem is a premise.
- **C08-S04-C:** R11-R13 compile as private in-module checks where required;
  audit acyclic dependencies, finite recursion and absence of hidden zero-piece,
  strict-VPS or one-output-source assumptions. Record precise invariant names
  and the enumeration/coordinate interface consumed by S05 in implementation
  notes for independent inspection. Realization remains S05's responsibility.

### PFR-C08-S05 — realization and Lemma 4

- **C08-S05-A:** Realize the three fixed forest layers by legal homogeneous
  concrete paths, with finite structural recursion and explicit label bijections
  throughout, using Section 6.3's correspondence invariant. Check its small
  R15 split/merge case before the full traversals. Final coordinates imply the
  directed endpoint equivalence.
- **C08-S05-B:** Prove normalization for every allowed path/cascade from every
  active singular source, and the cascade-valued concatenation converse of
  Section 4.3. Expose all three intermediate states/path witnesses, their
  singularity under the starting premise, and empty-block cases through the API.
- **C08-S05-C:** R14-R16 compile, source and public trust audits pass, and the
  completed proof explicitly discharges OM-043 without depending on later chunks.

### PFR-C08-S06 — integrated consumers and readiness

- **C08-S06-A:** Compile generic downstream consumers of normalized stage
  extraction, exact tag restrictions, intermediate singularity and composed
  endpoint transport, using public imports only; implement R17-R18.
- **C08-S06-B:** Complete a readiness audit mapping every earlier criterion,
  R01-R18, CC01-CC11, public declaration/import/axiom and source anchor to
  current evidence. For subsequent review and finalization duties, record
  readiness and the responsible step, keeping those duties visibly outstanding.
  Revisit omissions and concrete deferral triggers.
- **C08-S06-C:** Required focused/downstream/default builds and trust/placeholder/
  source checks pass; owning docs describe actual coverage and remaining work.
  No C09 preservation or C10/C11 reachability theorem is proved as a consumer.

### PFR-C08-S07 — fresh cumulative independent closeout

- **C08-S07-A:** Freshly validate all eighteen S01-S06 criteria, R01-R18,
  CC01-CC10 and CC11's review-time readiness, maintained test modules and public
  assumptions/imports against the exact current candidate. Earlier review labels
  do not replace this pass.
- **C08-S07-B:** The same bound reviewer independently reassesses the entire
  cumulative contract and current source, returning a complete original report
  with actual checks and limitations. The assessment covers current source and
  readiness; receipt and reconciliation of that report remain subsequent duties.
- **C08-S07-C:** Retain and critically reconcile every original report, finding
  and criterion assessment. Complete required corrections, renewed independent
  assessment where the installed rules require it, owning documentation, final
  applicable validation, F capture and supported durable closure, then report
  and stop. Prepare documentation before final checks/F; keep closure status
  provisional until closure succeeds and preserve included bytes afterward.
  Only completion of these subsequent duties satisfies CC11 in full. If a
  material repair changes scope/acceptance, obtain the lead's decision; never
  declare completion by weakening criteria or silently beginning another chunk.

## 8. Regression and edge-case allocation

These are distinct mathematical boundaries, not a requirement to duplicate
every implementation lemma as a test. Use meaningful anonymous consumers and
private fixtures. Existing C07 examples need no new public names.

| ID | Boundary and owner |
| --- | --- |
| R01 | Empty path, empty tag word, identity endpoint equivalence; S01. |
| R02 | All four witnessed C07 constructors and actual output-cardinality changes; S01. |
| R03 | Concatenation order, nonempty mixed tag words, singularity with explicit starting premise; S01. |
| R04 | Split at first/final label under an arbitrary non-involutive source permutation; both children and all unaffected labels; S02. |
| R05 | Nonadjacent merge transported across a permutation reversing the selected pair, including original final label; both PP and VP; S02. |
| R06 | C07 adjacent/nonadjacent remembered recoveries as path endpoints; directed and inverse row-map consumers; S02. |
| R07 | Disjoint versions of all three interchanges, including operations on either side of shifted labels; S03. |
| R08 | PPM/PPS overlap with unequal positive values, strict nonsymmetric ratio and intervening outputs; S03. |
| R09 | VPS/PPS on either child; actual (171) output order and a non-self-inverse surrounding permutation; S03. |
| R10 | PPM/VPS overlap, nonempty pieces, null rows outside selected support, mask changes only there; S03. |
| R11 | Identity forest for a multiple-output singular source, and singleton input where no legal VPS exists; S04. |
| R12 | PPS refinement of a sheet having several support pieces; compensation preserves all unsplit endpoint columns; S04. |
| R13 | PPM equal-support labels cannot both inhabit one support tree; VPS at value one and successive refinements retain activity; S04. |
| R14 | Normalize nil and each one-operation path; all legitimate empty-stage choices; S05. |
| R15 | First check Section 6.3's local correspondence updates for a split followed by a nonadjacent merge with an intervening output. Then normalize an alternating mixed path with overlap and growth, multiple initial columns and explicit asymmetric final output correspondence; S05. |
| R16 | Original endpoint cardinality restored, active intermediate states, positive coefficients and no VPM in normalized blocks; S05. |
| R17 | Public generic extraction/concatenation of the three stages without private certificate imports; S06. |
| R18 | Compose normalization with a supplied output equivalence and inspect ratios/masks by path induction; no C09 theorem needed; S06. |

Empty input alphabets are outside the inherited active-state contract, whose
`Nonempty` assumption stays visible. Output cardinality is positive; a merge's
two distinct indices force at least two outputs. Zero/one PPS ratios and VPS
with an empty selected-support piece are unavailable as legal edges. Values
equal to one and rows outside a selected support remain allowed. No prior,
full-support input law, strictly positive matrix or unique off-support mask is
introduced. Equality of probability masses must justify finite-value coercions.

## 9. Verified reuse and discovery boundary

Existing local source, pinned LeanInfoTheory source/public API documentation,
declaration index/highlights/module guide, and pinned mathlib were searched.
Focused probe details, exact outputs and limitations are in the planning notes.
Only verified candidates are listed as existing; none implements C08 already.

| Existing surface | Use |
| --- | --- |
| C06 `ActiveFiniteChannel`, `activeEquiv`, `ofActive`, `extensionEquiv`, `extension_compare` | State/active-label boundary and existing coordinate transport. Singularity remains separate. |
| C06 singular-column value/pattern reconstruction and relabeling facts | Exact fragment values, support identities and endpoint reconstruction. |
| C07 `pps`, `ppm`, `vps`, `vpm`, cardinality/coordinate/closure/data theorems | Sole legal operation implementations. |
| C07 `splitKeep`, split case analysis, merge retained/survivor maps, `recoveryPerm` | Ordered labels and direction-sensitive permutation reasoning. |
| C07 four recovery constructions and forward/inverse channel equations | Remembered-witness consumers; no global inverse or arbitrary-operation equivariance inferred. |
| mathlib `Quiver.Path`, nil/cons, comp, length and mapPath support | Type-valued dependent paths, structural recursion and optional graph maps. |
| mathlib `finSuccEquiv'`, `Equiv.optionCongr`, `finSuccAboveEquiv`, `finCongr` | Verified insertion-compatible equivalence and numeric cardinality transport. |
| mathlib `Relation.ReflTransGen` and list-chain APIs | Evaluated alternatives; not the primary tagged witness. |
| mathlib `BinaryTree`, `FreeMagma`, `WType` | Inspected/compiled alternatives for private finite trees; their labeling limits and selection rule are recorded in Section 6.1. |
| mathlib `PMF.map_comp`, `PMF.ext`, finite equivalences | Directed endpoint transport and coordinate equality. |
| Supported `LeanInfoTheory.Probability.Finite`, `PMF.map_apply_equiv` | Exact coordinate transport across output bijections; this theorem belongs to LeanInfoTheory. |
| Pinned public `PMF.binaryMixture` / `LeanInfoTheory.Probability.FiniteMixture` | Already consumed through C07; no duplicate probability construction. |

LeanInfoTheory supplies no paper-specific tagged operation calculus or Lemma 4.
No new information-theory theorem is proposed here. Keep focused imports;
absence from a partial local compiled cache is not absence from pinned source.
Candidate discovery names must compile before implementation relies on them.
Record only genuine API-discoverability friction in the discoverability log.

## 10. Completion criteria and validation

- **CC01:** Exact inherited active-state and legal-operation contracts preserved;
  all four edge wrappers are witnessed, and Lemma 4 excludes VPM explicitly.
- **CC02:** Paths retain chronological operation tags and parameters; nil,
  concatenation, singularity and changed cardinalities are handled correctly.
- **CC03:** Output equivalence is an actual directed finite bijection with PMF
  equality; arbitrary relabeling and cascade composition retain tag information.
- **CC04:** All local interchange cases and the logical content of (167)-(174)
  are covered, including unaffected labels and (171)'s output permutation.
- **CC05:** The factorization invariant has exact support/value and exhaustive
  fragment semantics, and is preserved by each original operation without a
  circular appeal to normalization or a later chunk.
- **CC06:** Realization has an explicit finite recursion argument and proves the
  public normal-form theorem for every allowed finite path, with no hidden
  one-column source restriction or false arbitrary-rewrite termination claim.
- **CC07:** The public three-stage contract and endpoint equation are sufficient
  for later path/weight reasoning without exposing private forest machinery.
- **CC08:** R01-R18 and maintained prerequisite consumers pass; new public
  signatures/imports and axioms are audited, with no proof placeholders.
- **CC09:** Source interpretation, omissions and deferrals have stable owners
  and revisit points; no C09-C16 theorem or generic C10 constructor enters scope.
- **CC10:** Owning documents, actual validation and source applicability are
  reconciled while preserving inherited work and original review records.
- **CC11:** Fresh cumulative independent assessment establishes review-time
  readiness across every criterion. Receipt and critical reconciliation of all
  original reports, required corrections/review, final applicable validation,
  F capture and supported durable closure remain subsequent mandatory duties
  under S07-C. CC11 is satisfied in full only when those duties are complete.

Apply this phase distinction in readiness audits and review-request criteria.
The reviewer assesses the current source and readiness for later duties;
future receipt/reconciliation of its report, final capture and durable closure
cannot be certified by that report. Preserve all completion duties and reassess
evidence applicability after corrections or other source changes.

After each coherent change, build touched modules and important consumers.
Before a milestone run `lake build` plus explicit separate matrix/tests targets;
the lightweight default root alone does not cover them. For cumulative closeout,
build all maintained PFR test/example modules, both C08 modules, C06/C07 matrix
modules/consumers, and the lightweight root/default target. Use the current
module inventory, not a fixed historical job count. Retain command, actor,
source identity, result and limits; builds may be incremental.

Require no matches from the repository's exact placeholder scan over maintained
Lean sources. Audit every new public signature and `#print axioms`, excluding
private certificate mechanics from public API unless a consumer requires them.
Inspect final diff/status, tracked generated files, ignored reference/probe files,
dependency cleanliness and byte preservation of unrelated files. No commit or
push is authorized. Do not claim a compiler pass proves manuscript fidelity.

## 11. Omissions, deferrals and document duties

| Register / source item | Disposition and owner or trigger |
| --- | --- |
| OM-042, (167)-(174) | All logical content is allocated to S03-S05; scalar lines and private binary-tree mechanics need no separate stable public name. S06 audits complete anchor coverage. |
| OM-043, repeat-interchanges prose | Replace the missing global justification by Section 6's finite factorization. Arbitrary rewrite termination, shortest normal form and confluence are outside the manuscript target; no such theorem is asserted. Revisit only for an explicitly approved algorithmic consumer. |
| OM-051, equivalent cascades and inverse prose | C08 proves explicit endpoint/path equivalence and (171)'s ordering repair. C07 recoveries are reused with remembered witnesses. Path reversal using them remains C10's two-direction reachability obligation. |
| OM-024 / OM-070 | Retain the approved full source merge-index range and historical duplicate ID; no new repair. |
| OM-026 / OM-050 | No concrete C08 consumer needs public Examples 2-5 names. Existing private fixtures retain their strict beta assumption; C08 tests use purpose-built private cases. Revisit only for an actual named-fixture consumer. |
| OM-038 / OM-049 | Every copied support tree keeps nonempty pieces, so no raw/prune-zero bridge is needed. Inclusive value-one VPS remains approved. C10/C11 own zero-weight/empty-fiber handling when arbitrary families arise. |
| OM-044 / OM-045 / OM-068 | Use C06 state/data/finite presentation boundaries; no replacement state or zero-column values. |
| OM-052 | C10/C11 retain multiway weights/partitions/fibers. C08 realizes only recorded binary trees derived from a supplied path; it does not construct arbitrary finite partitions or weight lists. |
| Neighboring source passages | Definition 4 and operation definitions/examples remain completed C06/C07. ISIT III-B, IV-A and extended (175)-(202) remain C09-C13 as mapped; adjoining (149)-(166) remains completed C05. No extended-only claim is imported. |

There are no numbered Future Work Notes. Existing mapped obligations suffice
for the reviewed suggestions; do not create a duplicate note or promise optional
promotion. New worthwhile deferrals without an existing owner/trigger must be
numbered in the project log and normalized in the living summary. Required
correctness/acceptance gaps cannot be deferred as optional work.

During execution keep this plan's status region editorial only; record proof
choices, checks and review history in implementation notes and the cumulative
mapping in a readiness audit. Update the living summary, map and project log
when coverage/decisions change. Update README/roadmap/scope only for their owned
material facts. Preserve original closed plans, review reports and historical
checkpoints. Planning notes distinguish proposal from execution approval.

## 12. Reviewer, revision and stopping rules

The exclusive C08 binding is `.pfr-review/chunks/PFR-C08/binding.json`:
reviewer `/root/pfr_c08_reviewer`, parent task
`01a0dd19-3545-7f71-9a8e-ef093087fb06` (role `/root`). Requested settings are
`gpt-6-astra`, `ultra`, `fork_turns="none"`; effective model/effort/history settings
remain unknown. Its observed bootstrap context contains repository setup and
neutral instructions, with no parent discussion or assessment. Its revision-1
review satisfied all six plan criteria with no findings and was critically
reconciled. That original assessment remains tied to revision 1. The supplied
General Assistant report is separate advisory input; neither report approves
this revision or starts implementation. Read-only behavior is instruction-level,
not OS isolation. Preserve the installed delivery, waiting, source and closure
rules; no workflow redesign or extra automation is part of C08.

The lead's endorsement and S01 request approve DG-09's representation,
explicit-equivalence interpretation and structural proof route in revision 2.
Approval does not establish any unimplemented result. A separately requested
plan review uses the same reviewer and the criteria below. Each eligible step
request starts one fixed step only and stops after validated reporting.

During an authorized step, justified helper, proof-route and module refinements
may proceed with recorded reasons and review of the actual result. Preserve
original reviewed records and all acceptance outcomes. Changed mathematical
meaning, stronger assumptions, weaker output contracts, scope or acceptance need
the lead. A material plan replacement cannot be smuggled into the editorial
status block or substituted for an already registered normative contract.

## 13. Criteria for a separately requested plan review

- **C08-PR01:** Baseline, prerequisite applicability, exact manuscripts and
  inherited contracts are evidenced, with fresh/retained checks distinguished.
- **C08-PR02:** Tagged paths, equivalence, relabeling and composition are precise,
  feasible with verified APIs and strong enough for later consumers.
- **C08-PR03:** Every local interchange case and output-order effect is allocated;
  the printed and proposed contracts and material source repairs are explicit.
- **C08-PR04:** The structural certificate, three extension cases and realization
  form a rigorous acyclic proof route with finite recursion, no hidden extra
  hypothesis and no dependency on the theorem being proved or later chunks.
- **C08-PR05:** Step dependencies, API/module ownership, edge cases, regressions
  and cumulative validation establish reviewable outcomes without unnecessary
  infrastructure or implementing C09/C10/C11 consumers.
- **C08-PR06:** Omission/deferral routing, documentation, persistent reviewer,
  revision and approval/stopping boundaries are complete and accurate.

These criteria concern the proposal. They do not dispatch a review or claim
that any proposed C08 definition or theorem has been implemented.
