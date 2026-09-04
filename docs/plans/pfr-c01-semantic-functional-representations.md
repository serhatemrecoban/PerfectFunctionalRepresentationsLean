# PFR-C01 - Semantic Functional Representations

## Approved Detailed Plan

**Status:** Approved; not active
**Planning baseline:** `d9f63e713eab6f778132dc6888420adb442d0802`
**Approved contract:** Draft revision 2 dated 2026-09-04
**Approval date:** 2026-09-04
**Execution baseline:** the authorized approval-checkpoint commit containing this plan
**Implementation status:** Not started
**Active theorem-development chunk:** None

This tracked file is the canonical approved execution contract for PFR-C01.
The project lead approved Draft revision 2 without a contract change and
resolved DG-01 according to Section 3. Approval does not activate theorem
development. The authorized approval-checkpoint commit containing this plan is
the execution baseline. S01 must verify and record its hash before changing
PFR-C01 from `Approved` to `Active`; each stable step still requires its own
explicit prompt.

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
theorem IsFunctionalRepresentationOf.
    mutualInfoOf_eq_condEntropyOf_sub_condMutualInfoOf :
    mutualInfoOf p Y Z =
      condEntropyOf p Y X - condMutualInfoOf p X Z Y
```

```lean
theorem IsFunctionalRepresentationOf.mutualInfoOf_le_condEntropyOf :
    mutualInfoOf p Y Z <= condEntropyOf p Y X
```

```lean
theorem IsFunctionalRepresentationOf.
    mutualInfoOf_eq_condEntropyOf_iff_condMutualInfoOf_eq_zero :
    mutualInfoOf p Y Z = condEntropyOf p Y X ↔
      condMutualInfoOf p X Z Y = 0
```

```lean
theorem IsFunctionalRepresentationOf.
    mutualInfoOf_eq_condEntropyOf_iff_isMarkovChainOf :
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

The unconditional Equation (2) identity is also mathematically reusable, but
its current owner is PFR-C01 because it is an exact manuscript anchor. Possible
future upstreaming does not widen this chunk.

## 9. Approval, execution baseline, and status transitions

### Approved - current

- The project lead approved PFR-C01 Draft revision 2 dated 2026-09-04 without
  changing its contract.
- DG-01 is resolved according to Section 3.
- This tracked plan and the approval-time canonical-document reconciliation
  are contained in the authorized approval checkpoint.
- PFR-C01 is `Approved`, not `Active`; no theorem-development chunk is active
  and no Lean implementation has begun.
- The planning/probe baseline remains `d9f63e7...`.

The project lead separately authorized the approval-documentation commit, but
no push. The complete approval-checkpoint validation and evidence are recorded
in Section 13. The authorized commit containing this plan is the execution
baseline and must be verified before S01 begins.

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

### Active

A later explicit PFR-C01-S01 prompt is required. At S01 start:

1. Verify the exact approval-checkpoint hash.
2. Verify a clean or completely understood worktree.
3. Verify dependency pins and approved-plan status.
4. Stop on any unexpected HEAD, dependency change, or unexplained modification.
5. Record the execution-baseline hash.
6. Change PFR-C01 from `Approved` to `Active` in the same coherent change.

PFR-C01 remains `Active` through S01-S07. Each step requires its own explicit
prompt, validates, reports, and stops.

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

## 10. Stable implementation steps

### PFR-C01-S01 - Structural foundation

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

### PFR-C01-S02 - Transport and deterministic postprocessing

**Prerequisites:** Validated S01 outputs.

**Outputs:** Full-triple-law structural transport;
`isIndependentOf_comp_right`; private PMF algebra; relevant regressions.

**Implementation prompt:**

> Implement full-triple-law transport and `isIndependentOf_comp_right`. Keep
> support-map and two-sided processing machinery private. Test different source
> spaces with equal triple laws, noninjective triple maps, and noninjective
> postprocessing. Do not claim preservation of decoding, perfectness, or mutual
> information. Validate, report, and stop.

### PFR-C01-S03 - Equation (1)

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

### PFR-C01-S04 - Equation (2)

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

### PFR-C01-S05 - Equation (3)

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

### PFR-C01-S06 - Fixed and existential perfectness

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

### PFR-C01-S07 - Integration and internal milestone

**Prerequisites:** All validated S01-S06 outputs.

**Outputs:** Root import; completed regression suite; import/public API audit;
full internal validation; status remains `Active` with validation pending.

**Implementation prompt:**

> Import the production module from the project root, finish the regression
> matrix, audit every public declaration and import, run the full validation
> suite, and remove temporary artifacts. Keep status `Active` and record only
> "implementation finished; independent validation pending." Do not mark
> complete or begin C02. Report and stop.

### PFR-C01-S08 - Independent validation and completion reconciliation

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

This approval resolves DG-01 and establishes status `Approved`; it does not
establish status `Active`. The separately authorized approval checkpoint must
be validated, committed, and verified before S01 may begin.
