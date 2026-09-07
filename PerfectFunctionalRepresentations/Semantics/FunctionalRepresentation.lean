import LeanInfoTheory.Shannon.SemanticBridge.Markov

/-!
# Semantic functional representations

This module defines the support-aware structural notion of a functional
representation, first for a triple law and then for random variables on a
common probability space. For finite-valued variables, it also characterizes
this structure by the zero-information conditions of Equation (1), proves
the unconditional information decomposition of Equation (2), and derives
Equation (3) and its equality/Markov criteria under the structural hypothesis.
Fixed-auxiliary perfectness is distinguished from existential perfect
representability of a pair law on a possibly enlarged probability space.
The latter uses a `Fin n` witness at the approved finite-information boundary.
-/

namespace PerfectFunctionalRepresentations

open LeanInfoTheory.Shannon

universe u v w x y

/--
A triple law is a functional representation when its first and third
coordinates are independent and its second coordinate is a function of the
first and third coordinates on the law's support. The product is Lean's
right-associated `alpha × (beta × gamma)`, with projections `t.1`, `t.2.1`,
and `t.2.2` in that order.
-/
def IsFunctionalRepresentation
    {alpha : Type u} {beta : Type v} {gamma : Type w}
    (q : PMF (alpha × beta × gamma)) : Prop :=
  IsIndependent (fstThirdMarginal q) ∧
    ∃ decoder : alpha × gamma → beta,
      ∀ t ∈ q.support,
        t.2.1 = decoder (t.1, t.2.2)

/--
Random variables form a functional representation when their full triple
pushforward law is a functional representation. Decoder correctness is required
only on the support of that law.
-/
def IsFunctionalRepresentationOf
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    (p : PMF omega) (X : omega → alpha) (Y : omega → beta)
    (Z : omega → gamma) : Prop :=
  IsFunctionalRepresentation
    (p.map fun omega ↦ (X omega, Y omega, Z omega))

/--
The common-base structural predicate expands to independence of `X` and `Z`
and existence of a decoder correct on the source PMF's support.
-/
theorem isFunctionalRepresentationOf_iff
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    (p : PMF omega) (X : omega → alpha) (Y : omega → beta)
    (Z : omega → gamma) :
    IsFunctionalRepresentationOf p X Y Z ↔
      IsIndependentOf p X Z ∧
        ∃ decoder : alpha × gamma → beta,
          ∀ omega ∈ p.support,
            Y omega = decoder (X omega, Z omega) := by
  unfold IsFunctionalRepresentationOf IsFunctionalRepresentation
  constructor
  · rintro ⟨hIndependent, decoder, hDecoder⟩
    constructor
    · simpa [IsIndependentOf] using hIndependent
    · refine ⟨decoder, ?_⟩
      intro omega homega
      exact hDecoder (X omega, Y omega, Z omega)
        (by
          rw [PMF.mem_support_map_iff]
          exact ⟨omega, homega, rfl⟩)
  · rintro ⟨hIndependent, decoder, hDecoder⟩
    constructor
    · simpa [IsIndependentOf] using hIndependent
    · refine ⟨decoder, ?_⟩
      intro t ht
      rw [PMF.mem_support_map_iff] at ht
      rcases ht with ⟨omega, homega, htriple⟩
      subst t
      exact hDecoder omega homega

/--
Functional representation transports between source spaces with the same full
triple law, preserving the support-correct decoder condition.
-/
theorem isFunctionalRepresentationOf_congr_jointLaw
    {omega : Type u} {omega' : Type v} {alpha : Type w} {beta : Type x}
    {gamma : Type y} {p : PMF omega} {p' : PMF omega'}
    {X : omega → alpha} {Y : omega → beta} {Z : omega → gamma}
    {X' : omega' → alpha} {Y' : omega' → beta} {Z' : omega' → gamma}
    (hLaw :
      p.map (fun omega ↦ (X omega, Y omega, Z omega)) =
        p'.map (fun omega ↦ (X' omega, Y' omega, Z' omega))) :
    IsFunctionalRepresentationOf p X Y Z ↔
      IsFunctionalRepresentationOf p' X' Y' Z' := by
  unfold IsFunctionalRepresentationOf
  rw [hLaw]

/-- Deterministic postprocessing of `Z` preserves its independence from `X`. -/
theorem isIndependentOf_comp_right
    {omega : Type u} {alpha : Type v} {gamma : Type w} {delta : Type x}
    (p : PMF omega) (X : omega → alpha) (Z : omega → gamma)
    (f : gamma → delta) (h : IsIndependentOf p X Z) :
    IsIndependentOf p X (fun omega ↦ f (Z omega)) := by
  rw [isIndependentOf_iff_map_eq_indepProd] at h ⊢
  have hmap := congrArg
    (fun q : PMF (alpha × gamma) ↦ q.map fun t ↦ (t.1, f t.2)) h
  simpa only [indepProd, PMF.map_bind, PMF.map_comp, Function.comp_def] using hmap

/--
Equation (1): finite-valued variables form a functional representation exactly
when `I(X;Z)` and `H(Y|(X,Z))` vanish. The source type is unrestricted, and the
decoder supplied by zero conditional entropy is existential and correct only
on source support, not an arbitrary preselected decoder.
-/
theorem isFunctionalRepresentationOf_iff_zero_conditions
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    (p : PMF omega) (X : omega → alpha) (Y : omega → beta)
    (Z : omega → gamma) :
    IsFunctionalRepresentationOf p X Y Z ↔
      mutualInfoOf p X Z = 0 ∧
        condEntropyOf p Y (fun omega => (X omega, Z omega)) = 0 := by
  rw [isFunctionalRepresentationOf_iff, mutualInfoOf_eq_zero_iff_isIndependentOf,
    condEntropyOf_eq_zero_iff_exists_function]

private theorem condEntropyOf_conditionPair_swap
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    (p : PMF omega) (X : omega → alpha) (Y : omega → beta)
    (Z : omega → gamma) :
    condEntropyOf p X (fun omega => (Y omega, Z omega)) =
      condEntropyOf p X (fun omega => (Z omega, Y omega)) := by
  have hPair := entropyOf_comp_equiv p (fun omega => (Y omega, Z omega))
    (Equiv.prodComm beta gamma)
  have hTriple := entropyOf_comp_equiv p (fun omega => (X omega, Y omega, Z omega))
    ((Equiv.refl alpha).prodCongr (Equiv.prodComm beta gamma))
  change entropyOf p (fun omega => (Z omega, Y omega)) =
    entropyOf p (fun omega => (Y omega, Z omega)) at hPair
  change entropyOf p (fun omega => (X omega, Z omega, Y omega)) =
    entropyOf p (fun omega => (X omega, Y omega, Z omega)) at hTriple
  simp only [condEntropyOf_eq, jointEntropyOf]
  rw [hPair, hTriple]

/--
Equation (2): the unconditional decomposition
`I(Y;Z) = H(Y|X) - I(X;Z|Y) - H(Y|(X,Z)) + I(X;Z)` for finite-valued
variables. The source type is unrestricted; no functional-representation
hypothesis is required.
-/
theorem mutualInfoOf_eq_pfr_decomposition
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    (p : PMF omega) (X : omega → alpha) (Y : omega → beta)
    (Z : omega → gamma) :
    mutualInfoOf p Y Z =
      condEntropyOf p Y X
        - condMutualInfoOf p X Z Y
        - condEntropyOf p Y (fun omega => (X omega, Z omega))
        + mutualInfoOf p X Z := by
  have h := (mutualInfoOf_chain_rule_fst p Z Y X).symm.trans
    (mutualInfoOf_chain_rule_snd p Z Y X)
  rw [mutualInfoOf_swap p X Z, mutualInfoOf_swap p Y Z,
    condMutualInfoOf_swap p Y Z X, condMutualInfoOf_swap p X Z Y,
    condMutualInfoOf_eq_condEntropyOf_sub_condEntropyOf p Y Z X,
    condEntropyOf_conditionPair_swap p Y Z X] at h
  linarith

/--
Equation (3): a functional representation satisfies
`I(Y;Z) = H(Y|X) - I(X;Z|Y)`. Value alphabets are finite, the source is
unrestricted, and the structural hypothesis requires decoding only on support.
-/
theorem IsFunctionalRepresentationOf.mutualInfoOf_eq_condEntropyOf_sub_condMutualInfoOf
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    {p : PMF omega} {X : omega → alpha} {Y : omega → beta}
    {Z : omega → gamma} (hFR : IsFunctionalRepresentationOf p X Y Z) :
    mutualInfoOf p Y Z =
      condEntropyOf p Y X - condMutualInfoOf p X Z Y := by
  rcases (isFunctionalRepresentationOf_iff_zero_conditions p X Y Z).1 hFR with
    ⟨hIndependent, hDecoder⟩
  simpa only [hIndependent, hDecoder, sub_zero, add_zero] using
    mutualInfoOf_eq_pfr_decomposition p X Y Z

/-- Equation (3)'s upper bound for finite-valued, support-aware functional representations. -/
theorem IsFunctionalRepresentationOf.mutualInfoOf_le_condEntropyOf
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    {p : PMF omega} {X : omega → alpha} {Y : omega → beta}
    {Z : omega → gamma} (hFR : IsFunctionalRepresentationOf p X Y Z) :
    mutualInfoOf p Y Z ≤ condEntropyOf p Y X := by
  rw [hFR.mutualInfoOf_eq_condEntropyOf_sub_condMutualInfoOf]
  exact sub_le_self _ (condMutualInfoOf_nonneg p X Z Y)

/--
Under a finite-valued, support-aware functional representation, equality in
Equation (3)'s upper bound is equivalent to `I(X;Z|Y) = 0`.
-/
theorem IsFunctionalRepresentationOf.mutualInfoOf_eq_condEntropyOf_iff_condMutualInfoOf_eq_zero
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    {p : PMF omega} {X : omega → alpha} {Y : omega → beta}
    {Z : omega → gamma} (hFR : IsFunctionalRepresentationOf p X Y Z) :
    mutualInfoOf p Y Z = condEntropyOf p Y X ↔
      condMutualInfoOf p X Z Y = 0 := by
  rw [hFR.mutualInfoOf_eq_condEntropyOf_sub_condMutualInfoOf, sub_eq_self]

/--
Under a finite-valued, support-aware functional representation, equality in
Equation (3)'s upper bound is equivalent to the Markov chain `X → Y → Z`.
No conditional distribution is chosen on null `Y` fibers.
-/
theorem IsFunctionalRepresentationOf.mutualInfoOf_eq_condEntropyOf_iff_isMarkovChainOf
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    {p : PMF omega} {X : omega → alpha} {Y : omega → beta}
    {Z : omega → gamma} (hFR : IsFunctionalRepresentationOf p X Y Z) :
    mutualInfoOf p Y Z = condEntropyOf p Y X ↔
      IsMarkovChainOf p X Y Z := by
  exact hFR.mutualInfoOf_eq_condEntropyOf_iff_condMutualInfoOf_eq_zero.trans
    (condMutualInfoOf_eq_zero_iff_isMarkovChainOf p X Y Z)

/--
A finite triple law is perfect when it is a support-aware functional
representation and satisfies `I(Y;Z) = H(Y|X)`. Coordinates of the
right-associated triple are `X = t.1`, `Y = t.2.1`, and `Z = t.2.2`.
-/
def IsPerfectFunctionalRepresentation
    {alpha : Type u} {beta : Type v} {gamma : Type w}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    (q : PMF (alpha × beta × gamma)) : Prop :=
  IsFunctionalRepresentation q ∧
    mutualInfoOf q (fun t => t.2.1) (fun t => t.2.2) =
      condEntropyOf q (fun t => t.2.1) (fun t => t.1)

/--
The specified finite-valued auxiliary is perfect when the full triple law is
perfect. Decoding is required only on support; the source type is unrestricted.
-/
def IsPerfectFunctionalRepresentationOf
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    (p : PMF omega) (X : omega → alpha) (Y : omega → beta)
    (Z : omega → gamma) : Prop :=
  IsPerfectFunctionalRepresentation
    (p.map fun omega => (X omega, Y omega, Z omega))

/-- Fixed perfectness is support-aware functional representation plus `I(Y;Z) = H(Y|X)`. -/
theorem isPerfectFunctionalRepresentationOf_iff
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    (p : PMF omega) (X : omega → alpha) (Y : omega → beta)
    (Z : omega → gamma) :
    IsPerfectFunctionalRepresentationOf p X Y Z ↔
      IsFunctionalRepresentationOf p X Y Z ∧
        mutualInfoOf p Y Z = condEntropyOf p Y X := by
  simp only [IsPerfectFunctionalRepresentationOf, IsPerfectFunctionalRepresentation,
    IsFunctionalRepresentationOf, mutualInfoOf, condEntropyOf, PMF.map_comp,
    Function.comp_def]

/-- Fixed perfectness retains structural representation as well as `I(X;Z|Y) = 0`. -/
theorem isPerfectFunctionalRepresentationOf_iff_condMutualInfoOf_eq_zero
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    (p : PMF omega) (X : omega → alpha) (Y : omega → beta)
    (Z : omega → gamma) :
    IsPerfectFunctionalRepresentationOf p X Y Z ↔
      IsFunctionalRepresentationOf p X Y Z ∧
        condMutualInfoOf p X Z Y = 0 := by
  rw [isPerfectFunctionalRepresentationOf_iff]
  constructor
  · rintro ⟨hFR, hEq⟩
    exact ⟨hFR, hFR.mutualInfoOf_eq_condEntropyOf_iff_condMutualInfoOf_eq_zero.mp hEq⟩
  · rintro ⟨hFR, hZero⟩
    exact ⟨hFR, hFR.mutualInfoOf_eq_condEntropyOf_iff_condMutualInfoOf_eq_zero.mpr hZero⟩

/-- Fixed perfectness retains support-aware representation as well as `X → Y → Z`. -/
theorem isPerfectFunctionalRepresentationOf_iff_isMarkovChainOf
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    (p : PMF omega) (X : omega → alpha) (Y : omega → beta)
    (Z : omega → gamma) :
    IsPerfectFunctionalRepresentationOf p X Y Z ↔
      IsFunctionalRepresentationOf p X Y Z ∧ IsMarkovChainOf p X Y Z := by
  rw [isPerfectFunctionalRepresentationOf_iff]
  constructor
  · rintro ⟨hFR, hEq⟩
    exact ⟨hFR, hFR.mutualInfoOf_eq_condEntropyOf_iff_isMarkovChainOf.mp hEq⟩
  · rintro ⟨hFR, hMarkov⟩
    exact ⟨hFR, hFR.mutualInfoOf_eq_condEntropyOf_iff_isMarkovChainOf.mpr hMarkov⟩

/-- Fixed perfectness transports across source spaces with equal full triple laws. -/
theorem isPerfectFunctionalRepresentationOf_congr_jointLaw
    {omega : Type u} {omega' : Type v} {alpha : Type w} {beta : Type x}
    {gamma : Type y} [Fintype alpha] [Fintype beta] [Fintype gamma]
    {p : PMF omega} {p' : PMF omega'}
    {X : omega → alpha} {Y : omega → beta} {Z : omega → gamma}
    {X' : omega' → alpha} {Y' : omega' → beta} {Z' : omega' → gamma}
    (hLaw : p.map (fun omega => (X omega, Y omega, Z omega)) =
      p'.map (fun omega => (X' omega, Y' omega, Z' omega))) :
    IsPerfectFunctionalRepresentationOf p X Y Z ↔
      IsPerfectFunctionalRepresentationOf p' X' Y' Z' := by
  unfold IsPerfectFunctionalRepresentationOf
  rw [hLaw]

/--
A pair law is perfectly representable at the finite-information boundary when
it has a perfect triple-law extension with auxiliary `Fin n`. This new law
allows probability-space enlargement. Its PMF already excludes `n = 0`.
-/
def IsPerfectlyRepresentablePair
    {alpha : Type u} {beta : Type v} [Fintype alpha] [Fintype beta]
    (r : PMF (alpha × beta)) : Prop :=
  ∃ n : Nat, ∃ q : PMF (alpha × beta × Fin n),
    fstSndMarginal q = r ∧ IsPerfectFunctionalRepresentation q

/--
Perfect representability depends on the pair pushforward law, not on an
auxiliary map existing on the original, unrestricted source space.
-/
def IsPerfectlyRepresentablePairOf
    {omega : Type u} {alpha : Type v} {beta : Type w}
    [Fintype alpha] [Fintype beta]
    (p : PMF omega) (X : omega → alpha) (Y : omega → beta) : Prop :=
  IsPerfectlyRepresentablePair (p.map fun omega => (X omega, Y omega))

/-- Extract or supply a perfect finite triple-law extension of the given pair law. -/
theorem isPerfectlyRepresentablePairOf_iff_exists_fin_extension
    {omega : Type u} {alpha : Type v} {beta : Type w}
    [Fintype alpha] [Fintype beta]
    (p : PMF omega) (X : omega → alpha) (Y : omega → beta) :
    IsPerfectlyRepresentablePairOf p X Y ↔
      ∃ n : Nat, ∃ q : PMF (alpha × beta × Fin n),
        fstSndMarginal q = p.map (fun omega => (X omega, Y omega)) ∧
          IsPerfectFunctionalRepresentation q := Iff.rfl

/-- Pair perfect representability transports using only equality of pair laws. -/
theorem isPerfectlyRepresentablePairOf_congr_pairLaw
    {omega : Type u} {omega' : Type v} {alpha : Type w} {beta : Type x}
    [Fintype alpha] [Fintype beta]
    {p : PMF omega} {p' : PMF omega'}
    {X : omega → alpha} {Y : omega → beta}
    {X' : omega' → alpha} {Y' : omega' → beta}
    (hLaw : p.map (fun omega => (X omega, Y omega)) =
      p'.map (fun omega => (X' omega, Y' omega))) :
    IsPerfectlyRepresentablePairOf p X Y ↔
      IsPerfectlyRepresentablePairOf p' X' Y' := by
  unfold IsPerfectlyRepresentablePairOf
  rw [hLaw]

private theorem mutualInfoOf_comp_equiv_right
    {omega : Type u} {alpha : Type v} {gamma : Type w} {delta : Type x}
    [Fintype alpha] [Fintype gamma] [Fintype delta]
    (p : PMF omega) (X : omega → alpha) (Z : omega → gamma) (e : gamma ≃ delta) :
    mutualInfoOf p X (fun omega => e (Z omega)) = mutualInfoOf p X Z := by
  have hZ := entropyOf_comp_equiv p Z e
  have hXZ := entropyOf_comp_equiv p (fun omega => (X omega, Z omega))
    ((Equiv.refl alpha).prodCongr e)
  change entropyOf p (fun omega => (X omega, e (Z omega))) =
    entropyOf p (fun omega => (X omega, Z omega)) at hXZ
  simp only [mutualInfoOf_eq, jointEntropyOf]
  rw [hZ, hXZ]

/--
Any finite perfect auxiliary, in any universe, gives a perfect pair-law
extension by relabeling it as `Fin (Fintype.card gamma)` and transporting its
support-correct decoder through the inverse equivalence.
-/
theorem IsPerfectFunctionalRepresentation.isPerfectlyRepresentablePair
    {alpha : Type u} {beta : Type v} {gamma : Type w}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    {q : PMF (alpha × beta × gamma)} (h : IsPerfectFunctionalRepresentation q) :
    IsPerfectlyRepresentablePair (fstSndMarginal q) := by
  classical
  let e := Fintype.equivFin gamma
  have hFR : IsFunctionalRepresentationOf q (fun t => t.1) (fun t => t.2.1)
      (fun t => e t.2.2) := by
    apply (isFunctionalRepresentationOf_iff _ _ _ _).mpr
    refine ⟨isIndependentOf_comp_right q (fun t => t.1) (fun t => t.2.2) e h.1.1, ?_⟩
    rcases h.1.2 with ⟨decoder, hDecoder⟩
    refine ⟨fun t => decoder (t.1, e.symm t.2), ?_⟩
    intro t ht
    simpa only [Equiv.symm_apply_apply] using hDecoder t ht
  have hPerfect : IsPerfectFunctionalRepresentationOf q (fun t => t.1)
      (fun t => t.2.1) (fun t => e t.2.2) := by
    apply (isPerfectFunctionalRepresentationOf_iff _ _ _ _).mpr
    exact ⟨hFR, (mutualInfoOf_comp_equiv_right q (fun t => t.2.1)
      (fun t => t.2.2) e).trans h.2⟩
  refine ⟨Fintype.card gamma,
    q.map (fun t : alpha × beta × gamma => (t.1, t.2.1, e t.2.2)), ?_, ?_⟩
  · exact fstSndMarginal_map_triple q (fun t => t.1) (fun t => t.2.1) (fun t => e t.2.2)
  · exact hPerfect

/-- A specified finite perfect auxiliary witnesses perfect representability of its pair. -/
theorem IsPerfectFunctionalRepresentationOf.isPerfectlyRepresentablePairOf
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    {p : PMF omega} {X : omega → alpha} {Y : omega → beta} {Z : omega → gamma}
    (h : IsPerfectFunctionalRepresentationOf p X Y Z) :
    IsPerfectlyRepresentablePairOf p X Y := by
  have hPair := IsPerfectFunctionalRepresentation.isPerfectlyRepresentablePair h
  simpa only [fstSndMarginal_map_triple, IsPerfectlyRepresentablePairOf] using hPair

end PerfectFunctionalRepresentations
