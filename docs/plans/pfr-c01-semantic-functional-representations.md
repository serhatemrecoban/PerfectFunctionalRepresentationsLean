# PFR-C01 - Semantic Functional Representations

## Approved Detailed Plan

**Status:** Complete
**Planning baseline:** `d9f63e713eab6f778132dc6888420adb442d0802`
**Approved contract:** Draft revision 2 dated 2026-09-04
**Approval date:** 2026-09-04
**Execution baseline:** `5a9c7ca999639afe26c7bf235b4d044e0341b55a`
**Implementation status:** PFR-C01-S01 through S08 validated; independent validation and completion reconciliation passed 2026-09-07
**Active theorem-development chunk:** None; PFR-C02 is not approved or started

This tracked file is the canonical approved execution contract for PFR-C01.
The project lead approved Draft revision 2 without a contract change and
resolved DG-01 according to Section 3. The authorized approval checkpoint is
commit `5a9c7ca999639afe26c7bf235b4d044e0341b55a`. After verifying that baseline,
the pinned dependencies, and the understood worktree, PFR-C01 was activated
for S01 on 2026-09-04. Each later stable step still requires its own explicit
prompt.

## 1. Baselines and provenance

### Repository

- The planning baseline is exactly commit
  `d9f63e713eab6f778132dc6888420adb442d0802`.
- At planning time this commit was `HEAD` and was present in history.
- The branch was `master`, two commits ahead of `origin/master`.
- The tracked worktree was clean.
- `lake build` passed with 2,605 jobs.
- The required placeholder scan returned no matches.
- Existing maintained Lean source consisted only of the lightweight root and
  dependency smoke test; no paper theorem had been implemented.

### Dependency baseline

- Lean toolchain: `v4.33.1`.
- LeanInfoTheory: immutable tag `v0.1.0`, resolved commit
  `0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`.
- mathlib: resolved commit
  `0df444a360eaa60ab8c11dca51a86af692955474`.
- The dependency must not be changed during PFR-C01.

### Manuscripts

- Primary manuscript: the six-page ISIT final manuscript
  `ISIT_2026__On_perfect_functional_representations___final_manuscript_ (3).pdf`,
  SHA-256
  `48963AA59485B2C33B1A1E6E7C6EAD2251FDDDD26BD3691B6FCFFE683E6ED1C4`.
  The relevant anchor is Section I through Equations (1)-(3), including the
  unnumbered prose distinguishing a perfect auxiliary from a perfectly
  representable pair.
- Clarification companion: current extended manuscript
  `On_perfect_functional_representation__Extended_version_ (16).pdf`, SHA-256
  `98636D4C9F0618EC08FCA84559572780F604F197FDA90D8D7C787B3624245B8F`.
  Only the corresponding introductory material was needed; it adds no separate
  PFR-C01 theorem.

The manuscripts must not be copied into or reproduced by the repository.

**Provenance follow-up — 2026-09-05.** The independent S01 review found that
the available same-named ISIT PDF hashes to
`15D9ADEEBB42E67FE7C57794F3FE5F65DECEAD4F5AD8F44E7506A83C9859F171`,
not the approved digest above. A targeted local search did not recover the
approved binary. The reviewer found the available Section I consistent with
S01, but this is not fresh verification of the approved binary. The extended
companion's digest matches. The approved source identity and execution
contract remained unchanged; recovery, or project-lead designation of a
replacement and revalidation of affected source contracts, was then pending.
See [project log entry 12](../project-log.md#12-independent-s01-review-and-provenance-follow-up---2026-09-05).

**Provenance resolution — 2026-09-07.** S08 recovered the exact approved
six-page binary in the project lead's local paper folder outside the checkout.
The implementing task and fresh independent validator each confirmed the
approved `48963AA5...E6ED1C4` digest above, the matching extended companion,
and the relevant Section I/page 1 anchors by text and visual inspection.
The missing-binary limitation is closed without source redesignation or a
contract revision. Earlier same-name-copy checks remain historically limited;
this does not assert whole-manuscript equivalence or extend C01 coverage. See
[project log entry 31](../project-log.md#31-pfr-c01-s08-independent-validation-and-chunk-completion---2026-09-07).

## 2. Exact scope and non-goals

PFR-C01 covers:

1. A structural functional representation of `(X,Y)` by a specified auxiliary
   `Z`.
2. Independence of `X` and `Z`.
3. Existence of a decoder correct on the source PMF support.
4. Equation (1): equivalence of the structural conditions with zero mutual
   information and zero conditional entropy.
5. The unconditional identity in Equation (2).
6. Equation (3), its upper bound, its equality condition, and its Markov form.
7. Perfectness of a specified auxiliary `Z`.
8. The existential statement that a pair `(X,Y)` is perfectly representable
   when some perfect auxiliary exists on a possibly enlarged probability
   space, exposed in C01 only at its explicit finite-auxiliary information
   boundary.
9. Law transport sufficient to avoid dependence on accidental sample-space
   presentations.
10. Independence under deterministic postprocessing of `Z`, needed by
    PFR-C02.

PFR-C01 does not cover:

- the cited general existence theorem for functional representations;
- Equation (4) or its cited strong functional-representation bound;
- a theorem that every pair is functionally or perfectly representable;
- minimum-entropy functional representations;
- optimization over all auxiliaries, attainment, or auxiliary-cardinality
  bounds;
- canonical auxiliaries or canonical vectors;
- channel-level, prior-free perfect representability;
- a common posterior valid for every input of a channel;
- bit-valued duplicate information quantities;
- infinite-alphabet information theorems;
- any PFR-C02 implementation.

All information quantities use LeanInfoTheory's `Real`-valued nats API.

## 3. DG-01 resolved contract

### 3.1 Approved carrier

Use a layered design:

1. A law-level predicate on `q : PMF (alpha x beta x gamma)`.
2. A common-base `...Of` wrapper formed by the full triple pushforward.
3. A separate existential predicate on a pair law whose witness is a finite
   triple-law extension.

Lean products are right-associated, so the actual Lean type
`alpha × beta × gamma` is `alpha × (beta × gamma)`. The three coordinates of a
term `t` are therefore `t.1`, `t.2.1`, and `t.2.2`.

This organization mirrors LeanInfoTheory's `IsIndependent`/`IsIndependentOf`
and `IsMarkovChain`/`IsMarkovChainOf` layers. It gives paper-facing
random-variable statements while making law invariance an explicit theorem.

### 3.2 Alternatives rejected

| Alternative | Disposition |
| --- | --- |
| Common-base maps only | Ergonomic, but sample-space invariance remains implicit and every transport becomes ad hoc. |
| Joint law only | Invariant, but unnecessarily awkward for the paper-facing equations and PFR-C02 construction. |
| A structure bundling a chosen decoder | Reject. Zero conditional entropy proves existence of some decoder, not correctness of a caller-selected decoder; bundling also creates witness-identity baggage. |
| An almost-everywhere primary definition | Reject. It adds unnecessary measurable-space hypotheses to a discrete PMF statement. Support correctness is canonical. |
| A curried decoder `alpha -> gamma -> beta` | Reject in favor of `alpha × gamma -> beta`, matching the conditioning variable in Equation (1). |
| Pair representability as `exists Z : omega -> gamma` | Reject. It can forbid the probability-space enlargement needed by an auxiliary representation. |
| `exists gamma : Type, ...` | Reject. It silently fixes the witness to universe zero. |
| `exists gamma : Type u, ...` | Reject. It introduces an artificial universe parameter that Lean cannot existentially hide. |
| A Sigma/bundled finite-type witness | Reject. It retains the universe and witness-identity problems. |

### 3.3 Universe-safe pair witness

For a pair law `r : PMF (alpha × beta)`, use:

```lean
def IsPerfectlyRepresentablePair
    {alpha : Type u} {beta : Type v}
    [Fintype alpha] [Fintype beta]
    (r : PMF (alpha × beta)) : Prop :=
  ∃ n : Nat, ∃ q : PMF (alpha × beta × Fin n),
    fstSndMarginal q = r ∧ IsPerfectFunctionalRepresentation q
```

Its common-base wrapper is:

```lean
def IsPerfectlyRepresentablePairOf
    {omega : Type w} {alpha : Type u} {beta : Type v}
    [Fintype alpha] [Fintype beta]
    (p : PMF omega) (X : omega -> alpha) (Y : omega -> beta) : Prop :=
  IsPerfectlyRepresentablePair (p.map fun omega => (X omega, Y omega))
```

The witness `q` is itself a new probability space extending the `(X,Y)` law.
The definition never quantifies an auxiliary map on the original `omega`.

`Fin n` adds no restriction beyond C01's explicit finite-auxiliary information
boundary. The manuscripts do not literally state that `Z` is finite. This
boundary is a source-to-Lean interpretation required by the finite-valued
contracts of the pinned LeanInfoTheory information API and was recorded when
DG-01 was resolved on 2026-09-04. Structural fixed-`Z` semantics remain
unrestricted.

Every finite `gamma` is equivalent to `Fin (Fintype.card gamma)`, and the
focused probe compiled the bridges from an arbitrary finite auxiliary using
`Fintype.equivFin gamma`, including a genuinely higher-universe auxiliary
`ULift (Fin 2) : Type 1`. PFR-C02 canonicalization is the later mathematical
justification that finite canonical witnesses suffice; C01 does not prove that
channel-level claim.

No explicit `0 < n` premise is needed. An actual witness
`q : PMF (alpha × beta × Fin n)` supplies a nonempty support, which already
rules out `n = 0`. The regression suite must make this concrete by deriving
`0 < n` from any such witness or proving that a witness with `Fin 0` implies
`False`.

## 4. Support and finiteness contracts

The structural layer requires no:

- `Fintype` or `Finite` instance;
- measurable-space structure;
- explicit `Nonempty` assumption;
- full-support hypothesis;
- finiteness of the source sample type.

Equations (1)-(3), fixed perfectness, and fixed-perfect equality/CMI/Markov
equivalences require exactly:

```lean
[Fintype alpha] [Fintype beta] [Fintype gamma]
```

This is C01's explicit finite-auxiliary information boundary, not a claim that
the manuscripts literally assume finite `Z`. The 2026-09-04 DG-01 resolution
records this source-to-Lean interpretation. PFR-C02 later owns the
mathematical canonicalization argument showing why finite canonical witnesses
suffice.

Existential pair perfect representability requires exactly:

```lean
[Fintype alpha] [Fintype beta]
```

Its witness `Fin n` supplies its own `Fintype` instance. The decoder product
`alpha × gamma` inherits `Fintype` from its factors. No theorem may require
`[Fintype omega]`.

Decoding is correct only on `p.support`. Values at null source atoms and
unrealized `(X,Z)` pairs are deliberately unconstrained.

## 5. Exact mathematical contracts

Use common variables:

```lean
p  : PMF omega
p' : PMF omega'
X  : omega -> alpha
Y  : omega -> beta
Z  : omega -> gamma
X' : omega' -> alpha
Y' : omega' -> beta
Z' : omega' -> gamma
```

### 5.1 Structural definitions

```lean
def IsFunctionalRepresentation
    (q : PMF (alpha × beta × gamma)) : Prop :=
  IsIndependent (fstThirdMarginal q) ∧
    ∃ decoder : alpha × gamma -> beta,
      ∀ t ∈ q.support,
        t.2.1 = decoder (t.1, t.2.2)
```

```lean
def IsFunctionalRepresentationOf
    (p : PMF omega) (X : omega -> alpha) (Y : omega -> beta)
    (Z : omega -> gamma) : Prop :=
  IsFunctionalRepresentation
    (p.map fun omega => (X omega, Y omega, Z omega))
```

Public expansion:

```lean
theorem isFunctionalRepresentationOf_iff :
    IsFunctionalRepresentationOf p X Y Z ↔
      IsIndependentOf p X Z ∧
        ∃ decoder : alpha × gamma -> beta,
          ∀ omega ∈ p.support,
            Y omega = decoder (X omega, Z omega)
```

This theorem is both a constructor and an eliminator for the paper-facing
structural predicate.

### 5.2 Equation (1)

Under `[Fintype alpha] [Fintype beta] [Fintype gamma]`:

```lean
theorem isFunctionalRepresentationOf_iff_zero_conditions :
    IsFunctionalRepresentationOf p X Y Z ↔
      mutualInfoOf p X Z = 0 ∧
        condEntropyOf p Y (fun omega => (X omega, Z omega)) = 0
```

The reused theorem
`condEntropyOf_eq_zero_iff_exists_function` supplies an existential decoder.
It must never be described as certifying an arbitrary preselected decoder.

### 5.3 Equation (2)

Under the same three finite-value assumptions and with no representation
hypothesis:

```lean
theorem mutualInfoOf_eq_pfr_decomposition :
    mutualInfoOf p Y Z =
      condEntropyOf p Y X
        - condMutualInfoOf p X Z Y
        - condEntropyOf p Y (fun omega => (X omega, Z omega))
        + mutualInfoOf p X Z
```

The argument order is exact:

- `condMutualInfoOf p X Z Y` is `I(X;Z|Y)`;
- the final conditional entropy is `H(Y|(X,Z))`.

Equation (2) is unconditional and must not be proved under or stated with an
`IsFunctionalRepresentationOf` hypothesis.

### 5.4 Equation (3)

Under the same finite assumptions and
`hFR : IsFunctionalRepresentationOf p X Y Z`:

```lean
theorem IsFunctionalRepresentationOf.mutualInfoOf_eq_condEntropyOf_sub_condMutualInfoOf :
    mutualInfoOf p Y Z =
      condEntropyOf p Y X - condMutualInfoOf p X Z Y
```

```lean
theorem IsFunctionalRepresentationOf.mutualInfoOf_le_condEntropyOf :
    mutualInfoOf p Y Z <= condEntropyOf p Y X
```

```lean
theorem IsFunctionalRepresentationOf.mutualInfoOf_eq_condEntropyOf_iff_condMutualInfoOf_eq_zero :
    mutualInfoOf p Y Z = condEntropyOf p Y X ↔
      condMutualInfoOf p X Z Y = 0
```

```lean
theorem IsFunctionalRepresentationOf.mutualInfoOf_eq_condEntropyOf_iff_isMarkovChainOf :
    mutualInfoOf p Y Z = condEntropyOf p Y X ↔
      IsMarkovChainOf p X Y Z
```

The functional-representation hypothesis is essential to every Equation (3)
consequence.

### 5.5 Fixed-auxiliary perfectness

Law-level definition:

```lean
def IsPerfectFunctionalRepresentation
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    (q : PMF (alpha × beta × gamma)) : Prop :=
  IsFunctionalRepresentation q ∧
    mutualInfoOf q (fun t => t.2.1) (fun t => t.2.2) =
      condEntropyOf q (fun t => t.2.1) (fun t => t.1)
```

The coordinate `...Of` quantities are intentional: they make the equality
orientation unambiguous. Bare `condEntropy` on the first-second marginal would
otherwise naturally read as `H(X|Y)`, not `H(Y|X)`.

Common-base wrapper:

```lean
def IsPerfectFunctionalRepresentationOf
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    (p : PMF omega) (X : omega -> alpha) (Y : omega -> beta)
    (Z : omega -> gamma) : Prop :=
  IsPerfectFunctionalRepresentation
    (p.map fun omega => (X omega, Y omega, Z omega))
```

Its expansion is not merely definitional; normalizing the nested pushforwards
requires `PMF.map_comp`.

Public equivalences:

```lean
theorem isPerfectFunctionalRepresentationOf_iff :
    IsPerfectFunctionalRepresentationOf p X Y Z ↔
      IsFunctionalRepresentationOf p X Y Z ∧
        mutualInfoOf p Y Z = condEntropyOf p Y X
```

```lean
theorem isPerfectFunctionalRepresentationOf_iff_condMutualInfoOf_eq_zero :
    IsPerfectFunctionalRepresentationOf p X Y Z ↔
      IsFunctionalRepresentationOf p X Y Z ∧
        condMutualInfoOf p X Z Y = 0
```

```lean
theorem isPerfectFunctionalRepresentationOf_iff_isMarkovChainOf :
    IsPerfectFunctionalRepresentationOf p X Y Z ↔
      IsFunctionalRepresentationOf p X Y Z ∧
        IsMarkovChainOf p X Y Z
```

The structural conjunct must be retained. A bare Markov condition is not a
functional representation.

### 5.6 Pair-level existential perfect representability

The two definitions are the `Fin n` law-extension predicates from Section 3.3.
Their public elimination and transport interfaces are:

```lean
theorem isPerfectlyRepresentablePairOf_iff_exists_fin_extension :
    IsPerfectlyRepresentablePairOf p X Y ↔
      ∃ n : Nat, ∃ q : PMF (alpha × beta × Fin n),
        fstSndMarginal q = p.map (fun omega => (X omega, Y omega)) ∧
          IsPerfectFunctionalRepresentation q
```

```lean
theorem isPerfectlyRepresentablePairOf_congr_pairLaw
    (hLaw :
      p.map (fun omega => (X omega, Y omega)) =
        p'.map (fun omega => (X' omega, Y' omega))) :
    IsPerfectlyRepresentablePairOf p X Y ↔
      IsPerfectlyRepresentablePairOf p' X' Y'
```

Arbitrary-finite fixed-auxiliary bridges:

```lean
theorem IsPerfectFunctionalRepresentation.isPerfectlyRepresentablePair
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    {q : PMF (alpha × beta × gamma)}
    (h : IsPerfectFunctionalRepresentation q) :
    IsPerfectlyRepresentablePair (fstSndMarginal q)
```

```lean
theorem IsPerfectFunctionalRepresentationOf.isPerfectlyRepresentablePairOf
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    (h : IsPerfectFunctionalRepresentationOf p X Y Z) :
    IsPerfectlyRepresentablePairOf p X Y
```

These bridge proofs map `gamma` to `Fin (Fintype.card gamma)` using
`Fintype.equivFin gamma`, transport the support decoder through the inverse
equivalence, preserve independence under deterministic postprocessing, and
preserve mutual information under bijective relabeling. They were compiled in
focused probes and are not to be treated as definitional reductions.

### 5.7 Transport and postprocessing

Full triple-law transport for the structural predicate:

```lean
theorem isFunctionalRepresentationOf_congr_jointLaw
    (hLaw :
      p.map (fun omega => (X omega, Y omega, Z omega)) =
        p'.map (fun omega => (X' omega, Y' omega, Z' omega))) :
    IsFunctionalRepresentationOf p X Y Z ↔
      IsFunctionalRepresentationOf p' X' Y' Z'
```

Full triple-law transport for fixed perfectness:

```lean
theorem isPerfectFunctionalRepresentationOf_congr_jointLaw
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    (hLaw :
      p.map (fun omega => (X omega, Y omega, Z omega)) =
        p'.map (fun omega => (X' omega, Y' omega, Z' omega))) :
    IsPerfectFunctionalRepresentationOf p X Y Z ↔
      IsPerfectFunctionalRepresentationOf p' X' Y' Z'
```

Equality of only the `(X,Y)` marginal cannot transport a specified auxiliary
`Z`; the full triple law is necessary.

Deterministic right-postprocessing independence:

```lean
theorem isIndependentOf_comp_right
    (p : PMF omega) (X : omega -> alpha) (Z : omega -> gamma)
    (f : gamma -> delta)
    (h : IsIndependentOf p X Z) :
    IsIndependentOf p X (fun omega => f (Z omega))
```

This theorem has no finiteness or measurability assumptions. It proves only
independence. It does not assert that `f(Z)` remains a functional
representation, remains perfect, or preserves `I(Y;Z)`.

## 6. Approved public declaration inventory

All declarations belong to namespace `PerfectFunctionalRepresentations` in
module `PerfectFunctionalRepresentations.Semantics.FunctionalRepresentation`.

| Declaration | Typeclasses | Hypotheses/input | Exact result | Intended consumer |
| --- | --- | --- | --- | --- |
| `IsFunctionalRepresentation` | None | Triple law `q` | Independence of first/third marginal and support-correct existential decoder | Semantic owner |
| `IsFunctionalRepresentationOf` | None | `p X Y Z` | Law predicate on full triple pushforward | Paper API, C02 |
| `isFunctionalRepresentationOf_iff` | None | `p X Y Z` | Exact independence/decoder expansion | Paper API, C02 |
| `isFunctionalRepresentationOf_congr_jointLaw` | None | Full triple-law equality | Structural iff across source presentations | Transport |
| `isIndependentOf_comp_right` | None | Independence and `f : gamma -> delta` | Independence of `X` and `f(Z)` | C02 |
| `isFunctionalRepresentationOf_iff_zero_conditions` | `Fintype alpha beta gamma` | `p X Y Z` | Equation (1) iff | Paper Equation (1) |
| `mutualInfoOf_eq_pfr_decomposition` | `Fintype alpha beta gamma` | `p X Y Z`; no FR | Exact Equation (2) | Paper Equation (2) |
| `IsFunctionalRepresentationOf.mutualInfoOf_eq_condEntropyOf_sub_condMutualInfoOf` | `Fintype alpha beta gamma` | `hFR` | Equation (3) equality | Paper Equation (3) |
| `IsFunctionalRepresentationOf.mutualInfoOf_le_condEntropyOf` | Same | `hFR` | Equation (3) bound | Paper Equation (3) |
| `IsFunctionalRepresentationOf.mutualInfoOf_eq_condEntropyOf_iff_condMutualInfoOf_eq_zero` | Same | `hFR` | Equality iff zero CMI | Paper equality condition |
| `IsFunctionalRepresentationOf.mutualInfoOf_eq_condEntropyOf_iff_isMarkovChainOf` | Same | `hFR` | Equality iff Markov | Paper Markov form |
| `IsPerfectFunctionalRepresentation` | `Fintype alpha beta gamma` | Triple law `q` | Structural predicate plus correctly oriented perfect equality | Fixed-Z law API |
| `IsPerfectFunctionalRepresentationOf` | Same | `p X Y Z` | Fixed-perfect law wrapper | Paper API |
| `isPerfectFunctionalRepresentationOf_iff` | Same | `p X Y Z` | FR plus equality | Paper API |
| `isPerfectFunctionalRepresentationOf_iff_condMutualInfoOf_eq_zero` | Same | `p X Y Z` | FR plus zero CMI | Paper API |
| `isPerfectFunctionalRepresentationOf_iff_isMarkovChainOf` | Same | `p X Y Z` | FR plus Markov | Paper API, C02 |
| `isPerfectFunctionalRepresentationOf_congr_jointLaw` | Same | Full triple-law equality | Fixed-perfect iff across presentations | Transport |
| `IsPerfectlyRepresentablePair` | `Fintype alpha beta` | Pair law `r` | Finite perfect triple-law extension exists | Pair-law API |
| `IsPerfectlyRepresentablePairOf` | `Fintype alpha beta` | `p X Y` | Pair predicate on `(X,Y)` pushforward | Paper API, C02 |
| `isPerfectlyRepresentablePairOf_iff_exists_fin_extension` | Same | `p X Y` | Exact finite extension witness | Stable elimination API |
| `isPerfectlyRepresentablePairOf_congr_pairLaw` | Same | Equality of pair pushforwards | Pair-perfect iff across presentations | Transport, C02 |
| `IsPerfectFunctionalRepresentation.isPerfectlyRepresentablePair` | `Fintype alpha beta gamma` | Fixed-perfect triple law | Pair marginal is perfectly representable | Law bridge |
| `IsPerfectFunctionalRepresentationOf.isPerfectlyRepresentablePairOf` | Same | Fixed-perfect `p X Y Z` | Pair `(X,Y)` is perfectly representable | Paper API, C02 |

The names distinguish:

- fixed auxiliary: `IsPerfectFunctionalRepresentation[Of]`;
- existential pair property: `IsPerfectlyRepresentablePair[Of]`;
- future channel property: must receive an explicitly channel-specific name,
  such as `IsPerfectlyRepresentableChannel`.

## 7. Verified reuse and focused import

The sole approved direct production import is:

```lean
import LeanInfoTheory.Shannon.SemanticBridge.Markov
```

This is a supported public import. It transitively imports
`LeanInfoTheory.Probability.FiniteChannel`; those channel declarations are in
the dependency closure but PFR-C01 does not call them directly.

All LeanInfoTheory declarations below are in namespace
`LeanInfoTheory.Shannon`.

| Origin module | Exact pinned contract | Planned use | Evidence |
| --- | --- | --- | --- |
| `Entropy` | `entropyOf p X : Real` under `[Fintype alpha]` | Entropy algebra | Checked and probe-used |
| `Entropy` | `entropyOf_comp_equiv p X (e : alpha ≃ beta) : entropyOf p (fun omega => e (X omega)) = entropyOf p X`, with both finite | Tuple and finite-auxiliary relabeling | Checked and probe-used |
| `InfoMeasures` | `condEntropyOf p X Y : Real` under `[Fintype alpha] [Fintype beta]`; orientation `H(X|Y)` | Equations (1)-(3) | Checked and probe-used |
| `InfoMeasures` | `mutualInfoOf p X Y : Real` under the two finite-value instances | Equations (1)-(3), perfectness | Checked and probe-used |
| `InfoMeasures` | `condMutualInfoOf p X Y Z : Real` under three finite-value instances; orientation `I(X;Y|Z)` | Equation (2), equality/Markov | Checked and probe-used |
| `InfoMeasures` | `mutualInfoOf_swap p X Y : mutualInfoOf p Y X = mutualInfoOf p X Y` | Equation (2) | Checked and probe-used |
| `InfoMeasures` | `condMutualInfoOf_swap p X Y Z : condMutualInfoOf p Y X Z = condMutualInfoOf p X Y Z` | Orientation normalization | Checked |
| `InfoMeasures` | `fstThirdMarginal_map_triple p X Y Z` yields `p.map fun omega => (X omega, Z omega)` | Structural expansion | Checked and probe-used |
| `InfoMeasures` | `fstSndMarginal_map_triple p X Y Z` yields `p.map fun omega => (X omega, Y omega)` | Pair-law bridge | Checked and probe-used |
| `SemanticBridge.Independence` | `IsIndependent q` and `IsIndependentOf p X Y`; no finiteness | Structural layer | Checked and probe-used |
| Same | `isIndependentOf_iff_map_eq_indepProd p X Y : IsIndependentOf p X Y ↔ p.map (fun omega => (X omega,Y omega)) = indepProd (p.map X) (p.map Y)`; no finiteness | Postprocessing proof | Checked and probe-used |
| Same | `mutualInfoOf_eq_zero_iff_isIndependentOf p X Y : mutualInfoOf p X Y = 0 ↔ IsIndependentOf p X Y`; finite `alpha,beta` | Equation (1) | Checked and probe-used |
| `SemanticBridge.Theorems` | `condEntropyOf_eq_zero_iff_exists_function p X Y : condEntropyOf p X Y = 0 ↔ ∃ f : beta -> alpha, ∀ omega ∈ p.support, X omega = f (Y omega)`; finite `alpha,beta` | Equation (1), existential decoder | Checked and probe-used |
| `InfoMeasures` | `condMutualInfoOf_eq_condEntropyOf_sub_condEntropyOf p X Y Z : condMutualInfoOf p X Y Z = condEntropyOf p X Z - condEntropyOf p X (fun omega => (Y omega,Z omega))`; three finite values | Equation (2) | Checked and probe-used |
| `SemanticBridge.Theorems` | `mutualInfoOf_chain_rule_fst p X Y Z : mutualInfoOf p X (fun omega => (Y omega,Z omega)) = mutualInfoOf p X Z + condMutualInfoOf p X Y Z`; three finite values | Equation (2) | Checked and probe-used |
| Same | `mutualInfoOf_chain_rule_snd p X Y Z : mutualInfoOf p X (fun omega => (Y omega,Z omega)) = mutualInfoOf p X Y + condMutualInfoOf p X Z Y`; three finite values | Equation (2) | Checked and probe-used |
| Same | `condMutualInfoOf_nonneg p X Y Z : 0 <= condMutualInfoOf p X Y Z`; three finite values | Equation (3) bound | Checked and probe-used |
| `SemanticBridge.Markov` | `IsMarkovChainOf p X Y Z := IsCondIndependentOf p X Z Y`; no finiteness | Markov conclusion | Checked and probe-used |
| Same | `condMutualInfoOf_eq_zero_iff_isMarkovChainOf p X Y Z : condMutualInfoOf p X Z Y = 0 ↔ IsMarkovChainOf p X Y Z`; three finite values | Exact Markov orientation | Checked and probe-used |
| mathlib `Mathlib.Probability.ProbabilityMassFunction.Constructions`, namespace `PMF` | `map_comp`, `support_map`, `mem_support_map_iff`, `map_bind`; no finiteness | Nested maps, support, postprocessing | Checked and probe-used |
| mathlib PMF basic/monad modules, namespace `PMF` | `PMF.ext`, `mem_support_iff`, `support_nonempty`, bind laws | Local PMF proofs | Checked |
| mathlib `Mathlib.Data.Fintype.EquivFin` | `Fintype.equivFin gamma : gamma ≃ Fin (Fintype.card gamma)` | Universe-safe finite witness bridge | Checked and probe-used |

Audited but not selected as direct proof dependencies include deterministic
entropy rules, deterministic mutual-information chain rules, data-processing
inequalities, Markov chain rules, channel joint/extension constructors, and
mathlib's measure-theoretic `ProbabilityTheory.IndepFun.comp`.
`IndepFun.comp` was rejected for the core proof because it adds measurable
spaces and measurable-map hypotheses.

There is no pinned PMF-first `isIndependentOf_comp_right` theorem and no direct
pinned theorem stating Equation (2). Both planned local results compiled in
focused probes.

## 8. Module ownership and private helpers

### Production

```text
PerfectFunctionalRepresentations/Semantics/FunctionalRepresentation.lean
```

### Regressions

```text
PerfectFunctionalRepresentations/Tests/Semantics/FunctionalRepresentation.lean
```

The regression module imports the production module, not LeanInfoTheory
examples or non-stable internals. The project root exposes the production
module after integration but never imports the regression module.

### Namespace

```lean
namespace PerfectFunctionalRepresentations
open LeanInfoTheory.Shannon
```

Use `noncomputable section` where the finite equivalence witness requires it.

### Private or local machinery

Keep private unless actual consumer pressure appears:

- PMF map equality from agreement on source support;
- tuple and cyclic relabeling used by Equation (2);
- conditioning-pair permutation algebra;
- mutual-information preservation under an equivalence;
- fixed-perfect auxiliary relabeling to `Fin (Fintype.card gamma)`;
- nested-map normalization helpers;
- both-sides deterministic postprocessing;
- AE/support conversion;
- minor projection simplifiers.

Do not initially mark large existential or paper-identity theorems `[simp]`.

### Temporarily project-local generic results

`isIndependentOf_comp_right` is genuinely reusable beyond this paper, but
PFR-C02 consumes it immediately and the pinned LeanInfoTheory release lacks a
supported generic theorem with this PMF-first contract. It is therefore
temporarily public and project-local. Upstreaming requires a separate
architecture/API review and does not occur in PFR-C01.

Revisit this existing candidate after C01 in a separately authorized
LeanInfoTheory maintenance/release window, or when another concrete consumer
needs it. Re-search the then-current LeanInfoTheory and mathlib APIs before
proposing an addition. Naming, generality, downstream compatibility, and any
dependency update require separate assessment and authorization. The current
contract remains structural, with no finiteness or measurability assumptions;
this note authorizes no migration or family of generalized theorems.

The unconditional Equation (2) identity is also mathematically reusable, but
its current owner is PFR-C01 because it is an exact manuscript anchor. Possible
future upstreaming does not widen this chunk.

## 9. Approval, execution baseline, and status transitions

### Approved - completed transition

- The project lead approved PFR-C01 Draft revision 2 dated 2026-09-04 without
  changing its contract.
- DG-01 is resolved according to Section 3.
- This tracked plan and the approval-time canonical-document reconciliation
  are contained in the authorized approval checkpoint
  `5a9c7ca999639afe26c7bf235b4d044e0341b55a`.
- PFR-C01 remained `Approved`, not `Active`, until the separately prompted S01
  activation on 2026-09-04.
- The planning/probe baseline remains `d9f63e7...`.

The project lead separately authorized the approval-documentation commit, but
no push. The complete approval-checkpoint validation and evidence are recorded
in Section 13. Its verified hash is
`5a9c7ca999639afe26c7bf235b4d044e0341b55a`.

Because a commit cannot contain its own hash, the approved plan initially
identifies the execution baseline as "the authorized approval-checkpoint commit
containing this plan." At S01, substituting the verified hash of that same
successfully validated commit is expressly preauthorized bookkeeping, changes
no contract, and is not a material plan revision. S01's first bookkeeping edit
records that hash in the plan and log without triggering reapproval.

Any different, amended, replaced, or later checkpoint is a material execution-
baseline change. It requires the ordinary plan-health review, explicit
project-lead reapproval, full approval-checkpoint revalidation, and separate
commit authorization before S01 may begin.

### Active - historical transition

The project lead's explicit instruction to start step 1 supplied the required
PFR-C01-S01 prompt. At S01 start:

1. Verify the exact approval-checkpoint hash.
2. Verify a clean or completely understood worktree.
3. Verify dependency pins and approved-plan status.
4. Stop on any unexpected HEAD, dependency change, or unexplained modification.
5. Record the execution-baseline hash.
6. Change PFR-C01 from `Approved` to `Active` in the same coherent change.

All activation checks passed on 2026-09-04. The two unrelated worktree paths
`AGENTS.md` and `docs/leaninfotheory-discoverability.md` were understood as
concurrent user-owned documentation work and excluded from S01. PFR-C01
remained `Active` through S01-S07. Each step requires its own explicit prompt,
validates, reports, and stops.

PFR-C01-S01 completed and passed its implementation-step validation on
2026-09-04. The project lead explicitly authorized PFR-C01-S02 on 2026-09-05;
it completed and passed validation that day. The project lead separately
authorized PFR-C01-S03 on 2026-09-05; it completed and passed validation that
day. The project lead separately authorized S04 on 2026-09-06; it completed
and passed validation that day. The project lead separately authorized S05
on 2026-09-06; it completed and passed validation on 2026-09-07. The project
lead explicitly authorized S06 on 2026-09-07; it completed and passed
implementation-step validation that day. The project lead subsequently
authorized S07 on 2026-09-07; root integration and internal validation passed
that day. At that milestone, "implementation finished; independent validation
pending," C01 remained `Active`; S08 had not started and required a separate
explicit prompt.

### Complete

S07 may record only "implementation finished; independent validation pending."
It leaves the chunk `Active`.

S08 requires an independent reviewer and a separate prompt. Only a passing
independent validation followed by successful canonical-document
reconciliation permits status `Complete`. Completion does not approve or start
PFR-C02.

If S08 fails, the exact affected step is reopened and PFR-C01 remains `Active`.
A repair requires a separate prompt and a fresh independent pass. A reviewer
who materially repairs the implementation cannot provide that final pass.

The project lead explicitly authorized S08 on 2026-09-07. Its fresh independent
chunk-wide validation passed without an implementation repair. Completion
documentation was reconciled under Section 15, and C01 became `Complete` that
day. S08 evidence is recorded below and in project log entry 31; C02 remains
unstarted and requires separate authorization.

## 10. Stable implementation steps

The dated S01-S07 evidence below records status and provenance as they stood
at each step or review. Later completion and source recovery are recorded at
S08 and in Section 1; they do not retroactively change those earlier checks.

### PFR-C01-S01 - Structural foundation

**Status:** Validated — 2026-09-04.

**Prerequisites:** Approved plan; authorized approval-checkpoint commit;
verified execution baseline; pinned dependencies.

**Outputs:** Production and regression module skeletons;
`IsFunctionalRepresentation`; `IsFunctionalRepresentationOf`;
`isFunctionalRepresentationOf_iff`; activation bookkeeping.

**Implementation prompt:**

> Verify the approval-checkpoint hash, clean or fully understood worktree,
> dependency pins, and approved plan. Record the execution baseline and change
> PFR-C01 from `Approved` to `Active`. Implement only the structural law/`Of`
> predicates and `isFunctionalRepresentationOf_iff`. Add support-only and
> unused-ambient-point regressions. Do not add entropy, transport, perfectness,
> or pair-existential declarations. Validate, report, and stop.

**Validation evidence:**

- Added only the approved production and regression modules.
- Exposed exactly `IsFunctionalRepresentation`,
  `IsFunctionalRepresentationOf`, and
  `isFunctionalRepresentationOf_iff`; no public helper, typeclass premise, or
  declaration attribute was added.
- The expansion theorem transports support in both directions with the pinned
  `PMF.mem_support_map_iff` theorem and preserves first/third independence,
  right-associated triple projections, and the support-qualified decoder.
- Polymorphic constructor/eliminator examples compile without typeclasses; the
  concrete regressions cover a null source point and arbitrary decoder behavior
  at an unrealized `(X,Z)` input. Two later non-blocking review fixtures also
  reject a positive-support decoder collision and show that deterministic
  decodability does not compensate for dependence of `X` and `Z`.
- Focused production and regression builds passed with 2,755 and 2,756 jobs;
  the 2,605-job default build also passed.
- A disposable consumer importing only the production module compiled all
  three declarations. `#print axioms` reported only `propext`,
  `Classical.choice`, and `Quot.sound`, with no `sorryAx`.
- The strict placeholder scan, whitespace checks, dependency-pin audit, public
  API/import/scope inspection, and an independent read-only S01 review passed.
- The root import remains unchanged, disposable consumer and PDF-render probes
  were removed, and no S02-or-later declaration was added.

**Independent reviewer follow-up — 2026-09-05:** `Reviewer - Chunk 1` reported
`PASS WITH NON-BLOCKING SUGGESTIONS`, with no required code, API, regression,
or documentation-status correction. Both optional negative fixtures were
already present and passed. Its sole caveat concerns the manuscript identity
recorded in Section 1. S01 remains validated; this step review does not replace
the chunk-wide S08 review or authorize S02 or a checkpoint commit.

### PFR-C01-S02 - Transport and deterministic postprocessing

**Status:** Validated — authorized and completed 2026-09-05.

**Prerequisites:** Validated S01 outputs.

**Outputs:** Full-triple-law structural transport;
`isIndependentOf_comp_right`; private PMF algebra; relevant regressions.

**Implementation prompt:**

> Implement full-triple-law transport and `isIndependentOf_comp_right`. Keep
> support-map and two-sided processing machinery private. Test different source
> spaces with equal triple laws, noninjective triple maps, and noninjective
> postprocessing. Do not claim preservation of decoding, perfectness, or mutual
> information. Validate, report, and stop.

**Validation evidence:**

- Added exactly `isFunctionalRepresentationOf_congr_jointLaw` and
  `isIndependentOf_comp_right`. Their contracts have five and four independent
  universe parameters respectively, with no typeclass or injectivity premise.
- Triple-law transport unfolds the existing law wrapper and rewrites by the
  full joint-law equality. Right-postprocessing maps the pinned independence
  factorization and normalizes with `indepProd`, `PMF.map_bind`,
  `PMF.map_comp`, and `Function.comp_def`. No separate PMF helper, two-sided
  processing theorem, import, or declaration attribute was needed.
- The initial eight anonymous regressions cover the two polymorphic public
  contracts, supported collisions in a noninjective triple map, transport between
  uniform `Bool` and pure `Unit` source presentations, and projection of a
  two-bit independent auxiliary onto its first bit. The latter fixture also
  proves that decoding was possible before projection and fails afterwards,
  even though independence survives. All named fixtures/helpers are private.
- Focused production and regression builds passed with 2,755 and 2,756 jobs;
  the default build passed with 2,605 jobs. A production-only consumer checked
  the exact signatures and independent source universes. Both new theorem
  axiom audits reported only `propext`, `Classical.choice`, and `Quot.sound`.
- A separate read-only source/regression audit found no issue and verified
  preservation of S01. S01 production changed only by adding a universe name
  unused by its declarations; removing the appended tests in memory reproduces
  the exact pre-S02 S01 test digest. The final repository checks are recorded in
  [project log entry 13](../project-log.md#13-pfr-c01-s02-transport-and-postprocessing---2026-09-05).
- The ISIT provenance caveat in Section 1 is unchanged. No numbered
  information identity, perfectness result, root import, or S03 work was added.
- The contextual review follow-up added one combined anonymous regression:
  equality of all three pairwise laws does not suffice for structural
  transport. Production is unchanged. Repeated builds and public theorem
  axiom checks passed; direct whitespace checks cover both untracked Lean
  files. Their final SHA-256 snapshot and the deduplicated upstream-note
  clarification are recorded in
  [project log entry 14](../project-log.md#14-s02-contextual-review-follow-up---2026-09-05).

**Independent reviewer follow-up — 2026-09-05:** `Reviewer - Chunk 1`
reviewed the final integrated S02 snapshot, including the pairwise-law
regression, and found no issue requiring a change. Its subsequent comparison
with the implementation-side material left that assessment and confidence
unchanged, with no correction or optional improvement recommended. Fresh
first-pass checks, the comparison's lack of additional checks, and the
source-identity, historical-diff, and non-blindness limitations are recorded in
[project log entry 15](../project-log.md#15-independent-s02-review-and-comparison---2026-09-05).
S02 remains validated; this review does not complete S08 or authorize S03,
upstream migration, or a checkpoint commit.

### PFR-C01-S03 - Equation (1)

**Status:** Validated — authorized and completed 2026-09-05.

**Prerequisites:** Structural API from S01; pinned zero-MI and
zero-conditional-entropy equivalences. S02 is the enforced predecessor but not
a mathematical prerequisite.

**Outputs:** Exact Equation (1) iff; wrong-preselected-decoder regression;
infinite-source signature regression.

**Implementation prompt:**

> Implement the exact structural/zero-information equivalence with
> `[Fintype alpha] [Fintype beta] [Fintype gamma]` and no finite sample-space
> assumption. Add a regression in which zero conditional entropy supplies a
> valid existential decoder while a separately chosen bad decoder fails on
> support. Validate through a public consumer import, report, and stop.

**Validation evidence:**

- Added exactly `isFunctionalRepresentationOf_iff_zero_conditions`, reusing
  the S01 structural expansion and the pinned zero-MI/independence and
  zero-conditional-entropy/existential-function equivalences. A compiling
  discovery probe verified both dependency contracts before use.
- The theorem has four independent universes, exactly the three value-type
  `Fintype` instances, and no source-finiteness, measurability, full-support,
  explicit nonemptiness, or chosen-decoder premise. The conditional entropy
  has the exact orientation `H(Y|(X,Z))`. No helper, import, or attribute was
  added; earlier production declarations are unchanged.
- Three anonymous regressions cover the generic signature, recovery of an
  existential decoder from the zero conditions while a named bad decoder
  fails on support, and a pure PMF on the infinite ambient type `Nat`.
  The new named fixture is private, and all previous regressions are retained.
- Focused production/regression builds passed with 2,755/2,756 jobs; the
  default build passed with 2,605 jobs. A production-only consumer checked the
  exact public signature. The new theorem's axiom audit reported only
  `propext`, `Classical.choice`, and `Quot.sound`, with no `sorryAx`.
- An internal read-only source/regression audit found no issue. The
  pre-S03 Lean bytes were preserved in an ignored review handoff, and final
  module fingerprints identify the compiled snapshot. Detailed checks,
  source interpretation, and artifact disposition are recorded in
  [project log entry 16](../project-log.md#16-pfr-c01-s03-equation-1---2026-09-05).
- The ISIT source-identity caveat and approved finite-value boundary remain
  unchanged. S04 and the later independent chunk-wide S08 review have not
  started; no checkpoint commit or push is authorized by this step.

**Contextual self-review — 2026-09-05.** The requested read-only review and
subsequent implementation reassessment found no justified source or regression
change. Fresh focused/default builds, a production-only signature and decoder
extraction consumer, and the axiom audit passed on the unchanged entry-16
source fingerprints. The actual pre-S03 Lean comparison preserves attribution;
there is no corresponding whole-document snapshot. Only review-evidence
records were updated. This is not independent validation, and the source
provenance caveat, approved contract, and S04 boundary remain unchanged. See
[project log entry 17](../project-log.md#17-s03-contextual-self-review-and-reassessment---2026-09-05).

**Independent step review received — 2026-09-06.** The project lead supplied
`Reviewer - Chunk 1`'s consolidated source-based review of this final snapshot.
It recommended no corrective or optional change before S03 finalization under
the approved finite-valued contract. Receipt checks matched all five reported
source/document fingerprints before reconciliation. Source and regressions
remain unchanged; S03 remains validated. The manuscript-authentication and
historical-diff limitations remain explicit. This review does not complete
S08 or authorize S04. See
[project log entry 18](../project-log.md#18-independent-s03-review-and-finalization---2026-09-06).

### PFR-C01-S04 - Equation (2)

**Status:** Validated — authorized and completed 2026-09-06.

**Prerequisites:** The S01-created module and pinned chain and entropy
identities. S03 is the enforced predecessor but not a mathematical
prerequisite. Private permutation and relabeling algebra is an S04 internal
implementation obligation whose feasibility was probe-verified, not a
pre-existing prerequisite.

**Outputs:** Unconditional exact Equation (2); private coordinate-relabeling
helpers; orientation regression.

**Implementation prompt:**

> Implement the unconditional manuscript identity with exact signs, `(X,Z)`
> conditioning, and `condMutualInfoOf p X Z Y`. Keep cyclic/permutation algebra
> private. Do not introduce a functional-representation hypothesis. Validate
> orientation against the manuscript and a focused consumer, report, and stop.

**Implementation evidence — 2026-09-06:** Added exactly
`mutualInfoOf_eq_pfr_decomposition` with the Section 5.3 contract and one
private conditioning-pair swap helper. There is no representation hypothesis,
finite-source assumption, new direct import, or simp attribute. The pinned
chain rules, conditional-entropy identity, and equivalence invariance were
checked in a focused compiling probe before production use. Two anonymous
regressions cover the unrestricted polymorphic contract and the exact
orientation on an arbitrary `PMF Nat` with distinct value types. Production,
regression, public-only consumer, signature/axiom audit, and default build
passed; only standard `propext`, `Classical.choice`, and `Quot.sound` axioms
occur. Direct pre-S04 snapshot comparison preserves all earlier declarations
and regressions. The manuscript-provenance caveat remains unchanged. Full
checks and fingerprints are in
[project log entry 19](../project-log.md#19-pfr-c01-s04-equation-2---2026-09-06).
This closes S04 only: S05 has not started, and S08 remains pending.

**Contextual self-review and reassessment — 2026-09-06:** No correctness,
contract, API, or maintenance issue justified a source or regression change.
The read-only recommendation to retain the implementation was presented before
the implementation-side reassessment, which upheld it. Fresh focused/default
builds, public-only signature/axiom and edge-instance checks, and source/diff
audits cover the unchanged S04 Lean fingerprints. This is not an independent
review. See
[project log entry 20](../project-log.md#20-s04-contextual-self-review-and-reassessment---2026-09-06).

**Independent review and finalization — 2026-09-06:** The independent S04
report recommended no corrective or optional change. All five supplied
source/document fingerprints matched before receipt was recorded; no Lean
change followed. The reviewer's direct source/snapshot assessment, fresh
builds, consumer, signature/axiom audit, and documented limitations are
recorded separately from implementation-side evidence in
[project log entry 21](../project-log.md#21-independent-s04-review-and-finalization---2026-09-06).
S04 retains status `Validated`. The approved ISIT provenance caveat is
unresolved; this step review does not complete S08 or authorize S05.

### PFR-C01-S05 - Equation (3)

**Status:** Validated on 2026-09-07 after separate authorization on 2026-09-06.
The exact pre-S05 source and seven-document snapshot was preserved before
maintained edits. Implementation and validation are recorded in
[project log entry 22](../project-log.md#22-pfr-c01-s05-equation-3---2026-09-06-to-2026-09-07).

**Prerequisites:** S01 structural predicate; S03 zero conditions; S04
decomposition; pinned CMI nonnegativity and zero-CMI/Markov equivalence.

**Outputs:** Reduced equality, upper bound, equality iff zero CMI, equality iff
Markov; null-fiber regressions.

**Implementation prompt:**

> Under `IsFunctionalRepresentationOf p X Y Z`, implement the reduced identity,
> upper bound, equality iff zero CMI, and equality iff
> `IsMarkovChainOf p X Y Z`. Ensure no theorem drops the
> functional-representation assumption. Add null-conditioning-fiber and
> unused-value regressions. Validate, report, and stop.

**Implementation evidence — 2026-09-07:** Exactly the four Section 5.4 methods
are implemented, each retaining `hFR`, four independent universes, three
finite value alphabets, and an unrestricted source. The reduced identity uses
S03/S04; the bound and Markov form reuse pinned nonnegativity and zero-CMI
equivalence. No helper, import, simp attribute, or perfectness predicate was
added. Five anonymous regressions cover all four generic contracts and an
actual null `Y` fiber with support-only decoding. Production (2,755 jobs),
regression (2,756 jobs), and default (2,605 jobs) builds passed, as did a
production-only consumer auditing all eleven public signatures and axioms.
Only `propext`, `Classical.choice`, and `Quot.sound` appeared. The approved
ISIT provenance caveat remains unresolved. This completed S05's
implementation-step validation, not S08; at that closeout C01 remained
`Active`, and S06 had not started or been authorized by that completion.

**Contextual self-review and editorial correction — 2026-09-07:** The review
and subsequent implementation reassessment retained the source and tests.
`S05-SR-01` joined three qualified declaration names in Section 5.4: a line
break immediately after the dot fails Lean parsing. This is a Section 17
editorial correction only; no name, signature, hypothesis, or contract changed.
Fresh builds and public-only signature/axiom and edge-instance checks passed.
See [project log entry 23](../project-log.md#23-s05-contextual-self-review-and-reassessment---2026-09-07).
At that self-review S05 remained `Validated`, C01 remained `Active`, and S06
was unstarted. This is not an independent step review or the S08 pass.

**Independent review received and reconciled — 2026-09-07:** The independent,
source-based report recommended finalizing S05 without a corrective or
optional change. Its five supplied fingerprints matched the current files
before these receipt notes. It separately checked the four new signatures
and axioms, focused/default builds, a new consumer, and all three parser-name
corrections. Evidence and limitations are attributed in
[project log entry 24](../project-log.md#24-independent-s05-review-and-finalization---2026-09-07).
S05 is finalized without a Lean or test change and retains status `Validated`.
C01 remains `Active`; the manuscript-provenance caveat remains unresolved.
This review does not complete S08 or authorize S06.

### PFR-C01-S06 - Fixed and existential perfectness

**Status:** Validated on 2026-09-07 after explicit authorization that day. The exact
pre-S06 source and seven-document snapshot was preserved before implementation.
Implementation and validation are recorded in
[project log entry 25](../project-log.md#25-pfr-c01-s06-fixed-and-existential-perfectness---2026-09-07).
This step does not authorize S07 or complete S08.

**Prerequisites:** S01 structural layer; S02 postprocessing theorem; S05
Equation-(3) reduced equality, bound, zero-CMI equality condition, and Markov
equivalence; pinned finite equivalence and marginal machinery.

**Outputs:** Fixed-perfect definitions/equivalences/transport; pair-law and
pair-`Of` existential definitions; finite-extension extraction; pair-law
transport; arbitrary-finite bridges; concrete zero-cardinality and genuinely
higher-universe regressions; perfectness regressions.

**Implementation prompt:**

> Implement fixed-perfect law/`Of` predicates and their equality, CMI, Markov,
> and full-law transport forms. Then implement
> `IsPerfectlyRepresentablePair`, its `...PairOf` wrapper, finite-extension
> extraction, pair-law congruence, and arbitrary-finite fixed-perfect bridges
> via `Fintype.equivFin`. Test finite reindexing, a pair-law witness on a
> separate triple-law probability space, deterministic/singleton positive
> cases, and an XOR-style fixed-auxiliary nonperfect case. Include a compiling
> test deriving `0 < n` from
> `q : PMF (alpha × beta × Fin n)` (or deriving `False` from the `Fin 0`
> specialization), and instantiate the arbitrary-finite bridge with
> `gamma := ULift (Fin 2) : Type 1`; a universe-zero-only test is insufficient.
> Do not infer that the XOR pair itself is nonrepresentable. Validate, report,
> and stop.

**Implementation evidence — 2026-09-07:** Exactly the four definitions and
eight theorems assigned to S06 are implemented, bringing the production API
to 23 public declarations. The fixed-perfect equivalences retain structural
representation and exactly the required finite value alphabets, with an
unrestricted source. Full-triple-law transport and pair-law transport remain
distinct. The pair predicates use a separate `Fin n` triple-law extension;
the arbitrary-finite bridge reindexes through `Fintype.equivFin`, transports
the support decoder through its inverse, and preserves independence and
mutual information. The new relabeling helper is private; no public alias,
new direct import, or simp attribute was added.

Fifteen anonymous regressions with five private helpers cover the polymorphic
interfaces, deterministic/singleton positive cases, a functional but
nonperfect XOR auxiliary, cross-source pair-law transport, separate-space
witness extraction, `ULift (Fin 2) : Type 1`, and impossibility of a `Fin 0`
extension. The XOR regression makes no negative claim about the pair itself.
Production (2,755 jobs), regression (2,756 jobs), and default (2,605 jobs)
builds passed. A production-only consumer checked all twelve new signatures
and all eight new theorem axiom reports, with only `propext`,
`Classical.choice`, and `Quot.sound`; it also exercised unrestricted `PMF Nat`,
distinct value types, higher-universe bridging, and extension extraction.
The bounded source audit is implementation-side evidence, not S08. Exact
pre-S06 comparison preserves earlier production declaration bodies and test
text. The available manuscripts' page 1 was rechecked; the approved ISIT
provenance caveat is unchanged. C01 remains `Active`; S07 has not started.

**Contextual self-review and reassessment — 2026-09-07:** The read-only review
recommended retention and was presented before the implementation-side second
decision pass. Reassessment retained the Lean source and regressions without
a contract or API change. Fresh combined production/regression and default
builds, twelve signature checks, eight theorem axiom reports, and isolated
nondegenerate higher-universe, support-only perfectness, and positive-witness
checks passed. No new finding or Future Work Note was justified. This is not
independent validation; S06 remains `Validated`, C01 remains `Active`, S07 is
unstarted, and the approved ISIT provenance caveat is unchanged. See
[project log entry 26](../project-log.md#26-s06-contextual-self-review-and-reassessment---2026-09-07).

**Independent review received — 2026-09-07:** The independent report recommends
retaining and finalizing S06 for the approved finite-information contract,
with no required or optional change or additional review turn. All five
supplied fingerprints matched before receipt edits. The reviewer separately
checked the twelve new signatures, eight theorem axiom reports, focused and
default builds, a new consumer, source/regression boundaries, and available
manuscript anchors. Its direct and delegated evidence and snapshot limitations
are distinguished in
[project log entry 27](../project-log.md#27-independent-s06-review-and-finalization---2026-09-07).
The implementation and tests are retained unchanged. S06 is finalized and
remains `Validated`; C01 remains `Active`, S07 is unstarted, and S08 is still
required. Approved-ISIT authentication remains unresolved. These receipt notes
are outside the reviewer's frozen document fingerprints and change no contract.

### PFR-C01-S07 - Integration and internal milestone

**Status:** Validated after explicit authorization on 2026-09-07. The root,
two semantic Lean files, and seven canonical documents were preserved in an
ignored pre-step comparison snapshot. The execution baseline is unchanged.
Milestone: **implementation finished; independent validation pending**.
C01 remains `Active`; S08 has not started.

**Prerequisites:** All validated S01-S06 outputs.

**Outputs:** Root import; completed regression suite; import/public API audit;
full internal validation; status remains `Active` with validation pending.

**Implementation prompt:**

> Import the production module from the project root, finish the regression
> matrix, audit every public declaration and import, run the full validation
> suite, and remove temporary artifacts. Keep status `Active` and record only
> "implementation finished; independent validation pending." Do not mark
> complete or begin C02. Report and stop.

**Implementation evidence — 2026-09-07:** The root now imports semantic
production alongside Basic and excludes the regression module. Production
and regressions are unchanged: all 23 approved declarations (six definitions,
seventeen theorems) and all seventeen regression-matrix rows were audited.
The existing 42 anonymous examples meet the matrix, so no new fixture or
public API was needed. Both production helpers and all test helpers remain
private; finite-value, support, universe, transport, and import contracts are
unchanged. The root closes over three project modules and eleven supported
LeanInfoTheory modules, without examples or non-stable anchors.

The combined production/regression/root build passed (2,759 jobs), and the
default build passed (2,758 jobs). A consumer importing only the root checked
all 23 signatures, all seventeen theorem axiom reports, and five integration
examples covering structural extraction, exact Equation (2) with distinct
higher-universe values, finite witness extraction with positive cardinality,
pair transport, and the arbitrary-finite law bridge. Only `propext`,
`Classical.choice`, and `Quot.sound` occurred. The available manuscripts' page 1
anchors were rechecked; approved-ISIT authentication remains unresolved.
Detailed validation, regression mapping, attribution, and artifact disposition
are in
[project log entry 28](../project-log.md#28-pfr-c01-s07-integration-and-internal-milestone---2026-09-07).
This is the internal implementation milestone, not S08 or C01 completion. No
contract revision, source redesignation, C02 work, commit, or push is implied.

**Contextual self-review and reassessment — 2026-09-07:** The read-only review
recommended retention before a separate implementation-side decision pass.
Reassessment retained the root, production, and regressions unchanged. Fresh
builds, all 23 signature and seventeen theorem axiom checks, a root-only import
boundary check, and generic Markov-to-pair witness extraction passed. No missing
regression, actionable finding, or new Future Work Note was justified. See
[project log entry 29](../project-log.md#29-s07-contextual-self-review-and-reassessment---2026-09-07).
S07 remains `Validated` at the internal milestone; C01 remains `Active`, S08
is unstarted, and approved-ISIT authentication remains unresolved. This is
implementation-side evidence, not independent validation or a contract revision.

**Independent review received and reconciled — 2026-09-07:** The focused S07
report recommends retaining and finalizing the implementation, with no required
or optional change or additional reviewer turn. All ten supplied fingerprints
matched before receipt edits. The reviewer separately checked the root-only
API/import environment, all 23 signatures and seventeen theorem axiom reports,
five integration examples, focused/default builds, regressions, documentation,
and available manuscript anchors. Its direct and delegated evidence and
limitations are attributed in
[project log entry 30](../project-log.md#30-independent-s07-review-and-finalization---2026-09-07).
Root, production, and regressions are retained unchanged. S07 is finalized and
remains `Validated`; C01 remains `Active` at the internal milestone, S08 is
unstarted, and approved-ISIT authentication remains unresolved. These receipt
notes are outside the reviewer's frozen document fingerprints and do not
complete S08 or authorize C02.

### PFR-C01-S08 - Independent validation and completion reconciliation

**Status:** Validated — explicitly authorized and completed 2026-09-07.

**Prerequisites:** Completed S07 state; independent reviewer; separate explicit
prompt.

**Outputs on success:** Independent evidence; completion documentation;
PFR-C01 status `Complete`.

**Implementation prompt:**

> Independently inspect the implementation, source anchors, support semantics,
> finite/universe assumptions, public API, regressions, and builds without
> relying on the implementer's report. If anything fails, leave C01 `Active`,
> reopen the exact affected step, and stop; a fresh independent pass is required
> after repair. If everything passes, reconcile completion documentation and
> mark C01 `Complete`. Do not begin C02, commit, or push without separate
> authorization.

**Independent validation and completion evidence:**

- A fresh reviewer agent, given the approved contract and local evidence but
  no inherited implementation verdict, independently inspected the whole
  chunk. It made no implementation or canonical-document edits and used
  separately scoped build/API and documentation/artifact subaudits.
- All six definitions, seventeen public theorems, seventeen regression-matrix
  rows, support/finite/universe boundaries, enlarged pair-law witnesses,
  private helpers, and focused root/import boundaries passed. No step needed
  reopening; the root, production, and regression source bytes were retained.
- The exact approved ISIT and matching extended companion were independently
  authenticated and their C01 page 1 anchors freshly inspected. Section 1
  records the prospective resolution of the prior missing-binary limitation.
- Fresh production, regression, root, and default builds, root/semantic
  consumers, signature and axiom checks, strict placeholder scans, and
  dependency/artifact audits passed. Evidence attribution and check details
  are recorded in
  [project log entry 31](../project-log.md#31-pfr-c01-s08-independent-validation-and-chunk-completion---2026-09-07).
- The seven owning documents were reconciled to C01 `Complete`, with C02
  ready for detailed planning only. The approved contracts, execution
  baseline, pins, DG-01, and omission dispositions are unchanged. No Lean
  repair, commit, push, dependency migration, or C02 work was performed.

**Implementation-side self-review — 2026-09-07:** The requested read-only
review and subsequent reassessment found no justified corrective or optional
implementation change. Fresh source/manuscript, build, provenance, and
documentation checks support retaining S08 `Validated` and C01 `Complete`.
Only self-review records were added; no earlier-step code or approved contract
changed. This is not another independent S08 pass, and these follow-up notes
are outside that review's frozen document fingerprints. See
[project log entry 32](../project-log.md#32-pfr-c01-s08-self-review-and-retention---2026-09-07).

**Independent reviewer follow-up — 2026-09-07:** `Reviewer - Chunk 1`
reviewed the final integrated S08 state, including the later self-review
notes, and recommended retaining S08 `Validated` and C01 `Complete`. All
eighteen completion criteria were assessed; no corrective change, optional
addition, step reopening, or further reviewer turn was recommended. All
sixteen supplied fingerprints matched again on receipt. Its fresh direct and
delegated checks, earlier-finding reconciliation, and remaining historical
and release limitations are recorded in
[project log entry 33](../project-log.md#33-independent-s08-review-and-finalization---2026-09-07).
Lean source is retained unchanged. These receipt notes are outside that
review's frozen document state; no C02 work, commit, or push follows from them.

## 11. Logical prerequisites and enforced execution order

The enforced execution order is:

```text
approval checkpoint
-> S01 -> S02 -> S03 -> S04 -> S05 -> S06 -> S07 -> S08
```

This is an authorization and audit contract. It is intentionally stricter than
mathematical dependency.

| Step | True logical/API prerequisites | Enforced predecessor |
| --- | --- | --- |
| S01 | Approved plan, pinned dependency API, execution checkpoint | Approval checkpoint |
| S02 | S01 structural predicates | S01 |
| S03 | S01 plus pinned zero-information iff theorems; no logical dependency on S02 | S02 |
| S04 | S01-created module plus pinned chain/entropy identities; private permutation/relabeling algebra is an S04 output, not a prerequisite; no mathematical dependency on S02 or S03 | S03 |
| S05 | S01 structural hypothesis, S03 zero conditions, S04 decomposition, pinned nonnegativity/Markov iff | S04 |
| S06 | S01 structural layer, S02 postprocessing theorem, S05 Equation-(3) consequences, finite reindexing/marginals | S05 |
| S07 | All S01-S06 outputs | S06 |
| S08 | Completed S07 state and an independent reviewer | S07 |

No step may begin its successor automatically.

## 12. Edge-case and regression matrix

| Case | Fixture or assertion | Required outcome | Owning step |
| --- | --- | --- | --- |
| Proper source support | Pure PMF on a larger source type; coordinates vary off support | Structural predicate ignores null source points | S01 |
| Unsupported decoder input | Decoder arbitrary away from realized `(X,Z)` values | Representation remains valid | S01 |
| Noninjective triple map | Multiple source points map to one triple | Predicate depends only on pushed-forward law | S02 |
| Different source spaces, same triple law | For example, a `Unit` presentation and a pure larger presentation | Structural predicate transports | S02 |
| Noninjective postprocessing | Independent `X,Z` and noninjective `f` | `X` remains independent of `f(Z)` | S02 |
| Wrong preselected decoder | Conditional entropy zero, but a named bad decoder fails on support | Existential theorem does not certify the bad decoder | S03 |
| Infinite sample space | `omega = Nat`, pure PMF, finite values | Information theorem compiles without `[Fintype omega]` | S03 |
| Equation (2) orientation | Distinct value types/order in a consumer | CMI is `I(X;Z|Y)` and entropy is `H(Y|(X,Z))` | S04 |
| Null `Y` fiber | Ambient `beta` has an unused value | Markov/CMI equivalence needs no chosen null-fiber conditional | S05 |
| No full support | Source PMF omits ambient points | All decoder conclusions stay support-qualified | S01/S05 |
| Deterministic `Y = f(X)` | Constant/singleton `Z` | Specified `Z` is perfect and the pair is perfectly representable | S06 |
| Singleton alphabets | Singleton `alpha`, `beta`, or `gamma` | No exceptional hypotheses | S06 |
| Functional but specified-`Z` nonperfect | Independent fair bits with `Y = X xor Z` | FR holds, but that `Z` fails perfectness/Markov | S06 |
| Pair-law transport | Different original sources with equal `(X,Y)` law | Pair perfectness transports | S06 |
| Enlarged-space witness | Pair `...Of` elimination returns a separate triple law `q` | No `Z` on original source is required | S06 |
| Genuinely higher-universe auxiliary | Instantiate the fixed-perfect bridge with `gamma := ULift (Fin 2) : Type 1` | Reindexing through `Fintype.equivFin` yields a `Fin (card gamma)` witness with the same pair law; a universe-zero-only fixture is insufficient | S06 |
| Zero-cardinality code | Compile `q : PMF (alpha × beta × Fin 0) ⊢ False`, using PMF support nonemptiness and `Fin.elim0`, or derive `0 < n` from every actual witness `q : PMF (alpha × beta × Fin n)` | Impossible `Fin 0` witnesses are excluded by proof, with no redundant positivity premise in the public definition | S06 |

The XOR regression concerns only the specified auxiliary. It must not be
mistaken for a proof that the underlying pair has no other perfect auxiliary.

## 13. Validation duties

### Approval checkpoint - before any approval-documentation commit

With the tracked `Approved` plan and approval-time documentation assembled, but
before the separately authorized approval-checkpoint commit:

1. Run the full default build: `lake build`.
2. Run the exact strict placeholder scan required by `AGENTS.md`:

   ```powershell
   rg -n --glob '*.lean' '\b(sorry|admit|axiom|opaque|undefined)\b' `
     PerfectFunctionalRepresentations PerfectFunctionalRepresentations.lean
   ```

3. Run `git diff --check`.
4. Validate all maintained Markdown relative links and anchors, and audit for
   forbidden absolute local paths and app-only directives.
5. Compare `lean-toolchain`, `lakefile.toml`, `lake-manifest.json`, and the
   resolved LeanInfoTheory/mathlib revisions with the approved dependency
   baseline.
6. Inspect the complete diff and `git status --short --branch`.
7. Audit tracked and ignored files for generated output, manuscript copies,
   probes, handoffs, and temporary artifacts; apply Section 18's handoff
   supersession rule.
8. Check every tracked-plan hygiene requirement in Section 18.
9. Record the complete validation evidence in the tracked plan and project
   log.
10. After recording that evidence, rerun items 1-8 against the final
    would-be-committed tree. Make no further file edit after this closeout;
    report its terminal evidence with the approval checkpoint. If any edit is
    needed, restart the entire phase.

Any failure requires correction and a rerun of this entire phase. Commit only
with separate explicit authorization; no push is implied.

### Approval-checkpoint evidence - 2026-09-04

The initial items 1-8 pass completed against the assembled approval tree:

- `lake build` completed successfully with 2,605 jobs;
- the exact strict project-source placeholder scan returned no matches;
- tracked and untracked diff whitespace checks passed;
- all 24 relative links across the eight maintained Markdown files resolved,
  no Markdown anchors were present, and the absolute-path/app-directive audit
  passed;
- the Lean toolchain, manifest, and resolved LeanInfoTheory and mathlib pins
  matched the approved baseline;
- the complete diff and status contained only the six expected canonical
  documentation changes and this new tracked plan, with no Lean, manifest,
  toolchain, or dependency change;
- the superseded ignored full-draft handoff was absent, and the remaining
  ignored `.lake` tree and two pre-existing context handoffs were understood;
- plan hygiene passed, including 64 balanced code fences, the contiguous
  `OM-001` through `OM-053` register, resolved `DG-01`, and fourteen remaining
  open decision gates; and
- an independent approval-transition audit found no remaining content,
  status, API, link, or artifact-hygiene blocker.

After this evidence record is written and the exact seven-file candidate is
staged, items 1-8 are rerun in full. No file edit follows a successful
closeout; its terminal evidence accompanies the checkpoint commit.

### Every implementation step

1. Build the touched production module.
2. Build the regression module once it exists.
3. Compile a consumer importing only the intended public production module.
4. Run the required placeholder scan.
5. Inspect every new public declaration, hypothesis, namespace, and attribute.
6. Run `git diff --check`.
7. Inspect the complete diff and worktree status.
8. Confirm dependency pins and manifest are unchanged.
9. Remove all disposable probes and generated artifacts.
10. Record validation evidence and step status in the approved plan.
11. Report and stop without starting the next step.

### Chunk-completion commands

```powershell
lake build PerfectFunctionalRepresentations.Semantics.FunctionalRepresentation
lake build PerfectFunctionalRepresentations.Tests.Semantics.FunctionalRepresentation
lake build PerfectFunctionalRepresentations
lake build
rg -n --glob '*.lean' '\b(sorry|admit|axiom|opaque|undefined)\b' `
  PerfectFunctionalRepresentations PerfectFunctionalRepresentations.lean
git diff --check
git status --short --branch
```

### Additional completion audits

- Run `#print axioms` on every new public theorem.
- Require no `sorryAx` or new/unapproved project axiom. The audit need not be
  literally empty when accepted foundational principles such as classical
  choice appear.
- Recheck Equations (1)-(3) directly against the ISIT manuscript.
- Confirm all finite assumptions arise from the pinned information API and no
  source-space finiteness was added.
- Confirm pair perfectness is a law property and its witness uses an enlarged
  triple-law space.
- Audit public/private boundaries and focused imports.
- Inspect tracked, ignored, generated, manuscript, probe, and temporary files.
- Confirm the root remains lightweight.

## 14. Completion criteria and downstream boundary

### Completion criteria

PFR-C01 is complete only when:

- DG-01 is explicitly approved and recorded.
- All six definitions and every public theorem in Section 6 compile with the
  exact stated contracts.
- Fixed-auxiliary perfectness and existential pair perfectness remain distinct.
- Every arbitrary finite perfect auxiliary bridges to the `Fin n` pair witness.
- A compiling regression excludes `Fin 0` witnesses or derives `0 < n` from
  every actual witness, and the arbitrary-finite bridge is instantiated at
  `ULift (Fin 2) : Type 1`.
- Structural declarations remain type-generic and support-aware.
- Information declarations use exactly the required finite-value assumptions.
- Equation (2) is unconditional and correctly oriented.
- Every perfect equality/CMI/Markov equivalence retains the structural
  representation condition.
- Full triple-law transport works across different source types.
- Pair perfectness depends only on the pair law and permits an enlarged space.
- Deterministic postprocessing proves only the required independence result.
- Every regression row passes.
- The public/private/import audit passes.
- Full builds, placeholder scan, and axiom audit pass.
- An independent reviewer passes the chunk.
- Canonical documentation is reconciled.
- No unapproved commit or push and no unintended tracked, ignored, generated,
  manuscript, probe, or temporary artifact remains; every expected change is
  accounted for.

### Guarantees offered to PFR-C02

PFR-C02 may depend on:

- `IsFunctionalRepresentation` and `IsFunctionalRepresentationOf`;
- `isFunctionalRepresentationOf_iff` for independence and decoder extraction;
- full-triple-law transport;
- `isIndependentOf_comp_right`;
- fixed-perfect equality/CMI/Markov formulations;
- `IsPerfectlyRepresentablePair` and
  `IsPerfectlyRepresentablePairOf`;
- finite-extension witness extraction;
- the bridge from fixed perfectness to pair perfect representability;
- pair-law transport across original sample-space presentations.

PFR-C02 must not depend on C01's private support-map, tuple-permutation,
nested-map, or finite-reindexing helpers.

### Deliberate non-guarantees

PFR-C01 does not provide:

- existence of a functional or perfect auxiliary for every pair;
- a chosen, canonical, or unique decoder;
- a canonical vector or coordinate law;
- preservation of decoding, perfectness, or mutual information under arbitrary
  postprocessing;
- channel-level prior independence;
- a common posterior for every channel input;
- the C02 relation `Y = W_X`;
- an optimizer, attainment result, or auxiliary-cardinality bound;
- an AE/measurable-space public API;
- infinite-alphabet information statements;
- a channel-level predicate contract.

The future channel predicate must use a channel-specific name and separately
resolve DG-02 and DG-03.

## 15. Documentation transitions

### Approval-time transition

This approval checkpoint performs the following coherent maintained change:

1. `docs/plans/pfr-c01-semantic-functional-representations.md`
   - exact approved contract;
   - approved revision identity and approval date;
   - status `Approved`;
   - planning baseline;
   - execution-baseline protocol;
   - stable steps;
   - revision policy;
   - validation and completion criteria.
2. `docs/formalization-map.md`
   - PFR-C01 status `Approved`;
   - dated DG-01 resolution;
   - exact pair-level allocation;
   - downstream API boundary;
   - confirmed omission dispositions.
3. `docs/perfect-functional-representations-living-summary.md`
   - approved-plan pointer;
   - normalized decisions and risks;
   - current activity;
   - explicit statement that no theorem-development chunk is active yet.
4. `docs/project-log.md`
   - dated approval and rationale;
   - manuscript designations/digests;
   - focused-probe evidence;
   - prospective approval-checkpoint history.
5. `README.md`
   - replace the stale claim that no chunk plan is approved;
   - state that C01 is approved but no paper theorem is complete.
6. `docs/roadmap.md`
   - replace "detailed planning for C01" with the approved execution boundary;
   - retain its non-authorizing role.
7. `docs/project-scope.md`
   - update the stale current-phase sentence saying no chunk is approved;
   - do not change the underlying project scope.

The full ignored review handoff was removed before approval-checkpoint
validation and does not remain as a competing complete plan. Its absence is
part of the approval-time artifact audit.

This approval documentation is committed only after the complete Section 13
approval-checkpoint validation passes and under the explicit authorization of
2026-09-04. No push is implied.

### Activation transition

At explicit S01 start, update every document whose status becomes stale. At
minimum, record the exact execution baseline and status `Active` in the plan,
formalization map, living summary, and project log.

### Completion transition

After S08 passes:

- mark the approved plan and map `Complete`;
- record independent-validation evidence;
- update the living summary and project log;
- update README status and exposed-module information;
- move the roadmap's next activity to PFR-C02 detailed planning;
- update project-scope current-phase prose if stale;
- confirm PFR-C02 dependency notes and relevant omission dispositions.

Completion does not approve or begin PFR-C02.

## 16. Omission and disposition audit

| Record | PFR-C01 disposition |
| --- | --- |
| `OM-001` | The cited general functional-representation existence theorem is excluded. |
| `OM-002` | Minimum-entropy literature remains context only. |
| `OM-003` | General channel-synthesis applications are excluded. |
| `OM-004` | Privacy applications are excluded. |
| `OM-005` | Equation (4) and its cited bound are excluded. |
| `OM-006` | The product-distribution consequence of Equation (4) is excluded. |
| `OM-007` | Cited special cases are not public targets; deterministic cases may appear as regressions. |
| `OM-008` | Poisson functional-representation optimality is excluded. |
| `OM-009` | The Wyner common-information condition is excluded. |
| `OM-010` | The Korner graph-entropy equivalence is excluded. |
| `OM-011` | Privacy-funnel and `g0` equivalences are excluded. |
| `OM-012` | The channel-synthesis redundancy interpretation remains documentation-only context. |
| `OM-014` | Literal support identification with `{1,...,k}` and `{1,...,m}` is a representation departure, not lost mathematics: semantic declarations use arbitrary finite types and PFR-C06 later proves the finite-coordinate bridge. |
| `OM-022` | Abstract, transitions, acknowledgements, and publication metadata receive no declarations. |
| `OM-023` | Bibliography entries remain provenance, not formal developments. |
| `OM-035` | Nats are canonical; no duplicate bit hierarchy is created. |
| `OM-036` | "Captures all information" and nonuniqueness remain explanatory prose. |
| `OM-041` | Refined product-channel redundancy rates are excluded. |
| `OM-046` | Manuscript max/min language does not import an optimizer or attainment theorem. |
| `OM-048` | Downstream C02 guard: canonicality must retain `Y = W_X`; this is not C01 work. |
| `OM-053` | C01 keeps structural fixed-`Z` semantics unrestricted but deliberately places its information/perfectness API and existential pair witness at the finite-valued boundary required by the pinned LeanInfoTheory contracts. `Fin n` only universe-normalizes the hidden finite witness; C01 excludes infinite-alphabet information statements. The 2026-09-04 `DG-01` resolution adopts this source-to-Lean interpretation. PFR-C02 canonicalization later supplies the mathematical justification that finite canonical witnesses suffice. |

The manuscript's existential pair-level notion is included in C01 under the
approved plan rather than omitted. `OM-053` records only the finite-boundary
source-to-Lean interpretation; it is not a source-allocation transfer.

## 17. Revision policy

### Harmless editorial corrections

Spelling, formatting, relative-link repair, and wording clarification may stay
within the same approved revision only when they change none of:

- mathematical meaning;
- manuscript coverage or omission disposition;
- hypotheses or conclusions;
- support, finiteness, or universe treatment;
- public names, signatures, or visibility;
- module/file ownership;
- imports or dependencies;
- downstream guarantees;
- step meaning, order, outputs, or prerequisites;
- validation or completion criteria;
- execution baseline, except for the exact prospective-label substitution
  described below.

Such corrections do not require project-lead reapproval. Add a dated correction
note when it helps provenance.

The sole execution-baseline exception is substituting the verified hash of the
same successfully validated approval-checkpoint commit for the prospective
phrase "the authorized approval-checkpoint commit containing this plan."
That S01 bookkeeping substitution is preauthorized, changes no contract, and
is not material. Every different, amended, replaced, or later checkpoint is a
material revision.

### Material revisions

A change to any item above is material. On a material discovery:

1. Stop the active step before implementing the divergent contract.
2. Do not begin later steps.
3. Open a versioned plan-health review and record its trigger.
4. Reconcile the proposal with the formalization map, project log, and every
   other affected canonical document.
5. Preserve the current approved revision as historical authority for work
   already completed under it.
6. Obtain explicit project-lead reapproval.
7. Establish a new authorized approval checkpoint and execution baseline.
8. Revalidate all completed work affected by the revision.

### Stable identifiers

- Preserve an ID when its meaning is unchanged, even if an approved revision
  reorders it.
- Never silently reuse an ID for materially different work.
- Mark materially replaced steps `Superseded`.
- Introduce an explicit successor such as `PFR-C01-S04-R1`, or a new suffixed
  ID when splitting a step.
- Retain completed and superseded IDs and their dispositions in the plan/log.
- Repeated attempts under an unchanged S08 contract may be attempt records; a
  changed validation contract needs a new or superseding ID.
- A change large enough to alter source allocation may require a map-level
  split or successor instead of overloading PFR-C01.

## 18. Tracked-plan hygiene

This tracked plan must:

- contain no app-only `:codex-file-citation` directives;
- contain no absolute local repository or manuscript paths;
- identify manuscripts by designation, revision label, digest, and source
  anchor;
- use repository-relative links and module paths;
- avoid links to ignored probes, rendered manuscript pages, or handoff files;
- summarize compiling-probe evidence without tracking disposable probes;
- never reproduce or commit manuscript contents.

The ignored full-draft handoff was removed before approval-checkpoint
validation and does not remain as competing authority.

## 19. Approved decisions

On 2026-09-04, the project lead approved Draft revision 2 and confirmed:

1. The layered law/`Of` carrier.
2. The support-correct existential product decoder.
3. The explicit source-to-Lean finite-auxiliary information boundary: the
   manuscripts do not literally state finite `Z`; `Fin n` adds no restriction
   beyond that boundary, and PFR-C02 later owns the canonicalization
   justification that finite canonical witnesses suffice.
4. The names `IsPerfectlyRepresentablePair` and
   `IsPerfectlyRepresentablePairOf`.
5. The complete public contract inventory.
6. The focused direct import and public/private ownership boundary.
7. The S01-S08 execution contract.
8. The approval-checkpoint, status-transition, documentation, and revision
   policies.
9. The explicit PFR-C02 guarantees and non-guarantees.
10. The approval-time validation and ignored-handoff supersession duties.

The approval resolved DG-01 and established status `Approved`; it did not by
itself establish status `Active`. The separately authorized approval checkpoint
was then validated, committed, and verified before S01 activation, as recorded
in Section 9.
