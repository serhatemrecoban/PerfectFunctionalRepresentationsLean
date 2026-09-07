import PerfectFunctionalRepresentations.Semantics.FunctionalRepresentation

/-!
# Structural functional-representation regressions

These anonymous regressions check support-restricted decoding, arbitrary
behavior at unrealized decoder inputs, consistency at realized decoder inputs,
and the independence requirement separate from deterministic decodability.
-/

namespace PerfectFunctionalRepresentations

open LeanInfoTheory.Shannon

noncomputable section

universe u v w x

section PolymorphicContract

variable {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
variable (p : PMF omega) (X : omega → alpha) (Y : omega → beta)
  (Z : omega → gamma)

/-- The expansion constructs the structural predicate without typeclasses. -/
example (hIndependent : IsIndependentOf p X Z)
    (decoder : alpha × gamma → beta)
    (hDecoder : ∀ omega ∈ p.support,
      Y omega = decoder (X omega, Z omega)) :
    IsFunctionalRepresentationOf p X Y Z :=
  (isFunctionalRepresentationOf_iff p X Y Z).2
    ⟨hIndependent, decoder, hDecoder⟩

/-- The expansion eliminates the structural predicate without typeclasses. -/
example (hRepresentation : IsFunctionalRepresentationOf p X Y Z) :
    IsIndependentOf p X Z ∧
      ∃ decoder : alpha × gamma → beta,
        ∀ omega ∈ p.support,
          Y omega = decoder (X omega, Z omega) :=
  (isFunctionalRepresentationOf_iff p X Y Z).1 hRepresentation

end PolymorphicContract

private def supportOnlySource : PMF Bool :=
  PMF.pure false

private def supportOnlyX (_ : Bool) : Bool :=
  false

private def supportOnlyY (omega : Bool) : Bool :=
  omega

private def supportOnlyZ (_ : Bool) : Bool :=
  false

private def supportOnlyDecoder (_ : Bool × Bool) : Bool :=
  false

/-- A null source point need not satisfy the decoder equation. -/
example :
    IsFunctionalRepresentationOf supportOnlySource supportOnlyX supportOnlyY
      supportOnlyZ := by
  rw [isFunctionalRepresentationOf_iff]
  constructor
  · rw [isIndependentOf_iff_map_eq_indepProd]
    simp only [supportOnlySource, supportOnlyX, supportOnlyZ, PMF.pure_map]
    apply PMF.ext
    rintro ⟨x, z⟩
    cases x <;> cases z <;> simp
  · refine ⟨supportOnlyDecoder, ?_⟩
    intro omega homega
    have homega_eq : omega = false := by
      simpa [supportOnlySource] using homega
    subst omega
    rfl

/-- The chosen decoder really does fail at the omitted source point. -/
example :
    supportOnlyY true ≠
      supportOnlyDecoder (supportOnlyX true, supportOnlyZ true) := by
  decide

private def unusedInputSource : PMF (Bool × Bool) :=
  indepProd (PMF.pure false) (PMF.pure false)

private def unusedInputY (_ : Bool × Bool) : Bool :=
  false

private def unusedInputDecoder : Bool × Bool → Bool
  | (false, false) => false
  | _ => true

/-- Decoder behavior at an unrealized `(X,Z)` value is irrelevant. -/
example :
    IsFunctionalRepresentationOf unusedInputSource Prod.fst unusedInputY
      Prod.snd := by
  rw [isFunctionalRepresentationOf_iff]
  constructor
  · unfold IsIndependentOf
    change IsIndependent (unusedInputSource.map id)
    rw [PMF.map_id]
    simp [IsIndependent, unusedInputSource]
  · refine ⟨unusedInputDecoder, ?_⟩
    intro omega homega
    rcases omega with ⟨x, z⟩
    have hxz : x = false ∧ z = false := by
      simpa [unusedInputSource, Set.prod] using homega
    rcases hxz with ⟨rfl, rfl⟩
    rfl

/-- The arbitrary value is observable at an unrealized decoder input. -/
example : unusedInputDecoder (true, true) = true := by
  rfl

private def decoderCollisionSource : PMF Bool :=
  PMF.uniformOfFintype Bool

private def decoderCollisionX (_ : Bool) : Bool :=
  false

private def decoderCollisionY (omega : Bool) : Bool :=
  omega

private def decoderCollisionZ (_ : Bool) : Bool :=
  false

/--
Two supported outcomes with the same `(X, Z)` value cannot decode to different
`Y` values.
-/
example :
    ¬ IsFunctionalRepresentationOf decoderCollisionSource decoderCollisionX
      decoderCollisionY decoderCollisionZ := by
  intro hRepresentation
  obtain ⟨_, decoder, hDecoder⟩ :=
    (isFunctionalRepresentationOf_iff decoderCollisionSource decoderCollisionX
      decoderCollisionY decoderCollisionZ).1 hRepresentation
  have hFalse := hDecoder false (PMF.mem_support_uniformOfFintype false)
  have hTrue := hDecoder true (PMF.mem_support_uniformOfFintype true)
  exact Bool.false_ne_true (hFalse.trans hTrue.symm)

private def dependentSource : PMF Bool :=
  PMF.uniformOfFintype Bool

private def dependentY (omega : Bool) : Bool :=
  omega

private def dependentDecoder (xz : Bool × Bool) : Bool :=
  xz.1

/--
Deterministic recovery of `Y` does not compensate for dependence of `X` and
`Z`.
-/
example :
    (∃ decoder : Bool × Bool → Bool,
        ∀ omega ∈ dependentSource.support,
          dependentY omega = decoder (id omega, id omega)) ∧
      ¬ IsFunctionalRepresentationOf dependentSource id dependentY id := by
  constructor
  · exact ⟨dependentDecoder, by intro omega _; rfl⟩
  · intro hRepresentation
    have hIndependent :=
      ((isFunctionalRepresentationOf_iff dependentSource id dependentY id).1
        hRepresentation).1
    rw [isIndependentOf_iff_map_eq_indepProd] at hIndependent
    have hOffDiagonal := congrArg
      (fun q : PMF (Bool × Bool) ↦ q (false, true)) hIndependent
    norm_num [dependentSource, PMF.map_apply, PMF.uniformOfFintype_apply] at hOffDiagonal

universe y z

section PolymorphicTransportAndPostprocessing

variable {omega : Type u} {omega' : Type v} {alpha : Type w} {beta : Type x}
  {gamma : Type y} {delta : Type z}

/-- Triple-law transport permits separate source universes and no typeclasses. -/
example (p : PMF omega) (p' : PMF omega')
    (X : omega → alpha) (Y : omega → beta) (Z : omega → gamma)
    (X' : omega' → alpha) (Y' : omega' → beta) (Z' : omega' → gamma)
    (hLaw : p.map (fun omega => (X omega, Y omega, Z omega)) =
      p'.map (fun omega' => (X' omega', Y' omega', Z' omega'))) :
    IsFunctionalRepresentationOf p X Y Z ↔
      IsFunctionalRepresentationOf p' X' Y' Z' :=
  isFunctionalRepresentationOf_congr_jointLaw hLaw

/-- Postprocessing has an independent target universe and no typeclasses. -/
example (p : PMF omega) (X : omega → alpha) (Z : omega → gamma)
    (f : gamma → delta) (hIndependent : IsIndependentOf p X Z) :
    IsIndependentOf p X (fun omega => f (Z omega)) :=
  isIndependentOf_comp_right p X Z f hIndependent

end PolymorphicTransportAndPostprocessing

private def collapsedSource : PMF Bool :=
  PMF.uniformOfFintype Bool

private def collapsedCoordinate (_ : Bool) : Bool :=
  false

private def unitCoordinate (_ : Unit) : Bool :=
  false

/-- The full triple map identifies two positive-probability source outcomes. -/
example :
    ¬ Set.InjOn (fun b =>
      (collapsedCoordinate b, collapsedCoordinate b, collapsedCoordinate b))
      collapsedSource.support := by
  intro hInjective
  exact Bool.false_ne_true
    (hInjective (PMF.mem_support_uniformOfFintype false)
      (PMF.mem_support_uniformOfFintype true) rfl)

/-- A noninjective Bool presentation transports from the same law on Unit. -/
example :
    IsFunctionalRepresentationOf collapsedSource collapsedCoordinate
      collapsedCoordinate collapsedCoordinate := by
  have hLaw :
      collapsedSource.map (fun b =>
        (collapsedCoordinate b, collapsedCoordinate b, collapsedCoordinate b)) =
      (PMF.pure ()).map (fun u =>
        (unitCoordinate u, unitCoordinate u, unitCoordinate u)) := by
    rw [PMF.pure_map]
    change collapsedSource.map (Function.const Bool (false, false, false)) =
      PMF.pure (false, false, false)
    exact PMF.map_const collapsedSource (false, false, false)
  apply (isFunctionalRepresentationOf_congr_jointLaw hLaw).2
  rw [isFunctionalRepresentationOf_iff]
  refine ⟨?_, fun _ => false, by intro u _; rfl⟩
  rw [isIndependentOf_iff_map_eq_indepProd]
  simp only [unitCoordinate, PMF.pure_map]
  apply PMF.ext
  rintro ⟨x, z⟩
  cases x <;> cases z <;> simp

private def postprocessingSource : PMF (Bool × (Bool × Bool)) :=
  indepProd (PMF.uniformOfFintype Bool) (PMF.uniformOfFintype (Bool × Bool))

private theorem postprocessingIndependent :
    IsIndependentOf postprocessingSource Prod.fst Prod.snd := by
  unfold IsIndependentOf
  change IsIndependent (postprocessingSource.map id)
  rw [PMF.map_id]
  exact isIndependent_indepProd _ _

/-- Before postprocessing, the auxiliary contains the bit to be decoded. -/
example :
    IsFunctionalRepresentationOf postprocessingSource Prod.fst
      (fun omega => omega.2.2) Prod.snd := by
  rw [isFunctionalRepresentationOf_iff]
  exact ⟨postprocessingIndependent, fun xz => xz.2.2, by intro omega _; rfl⟩

/-- Projecting a two-bit auxiliary onto its first bit is noninjective. -/
example : ¬ Function.Injective (Prod.fst : Bool × Bool → Bool) := by
  intro hInjective
  have h := hInjective (a₁ := (false, false)) (a₂ := (false, true)) rfl
  exact Bool.false_ne_true (congrArg Prod.snd h)

/-- Noninjective postprocessing preserves independence of the first coordinate. -/
example :
    IsIndependentOf postprocessingSource Prod.fst (fun omega => omega.2.1) :=
  isIndependentOf_comp_right postprocessingSource Prod.fst Prod.snd Prod.fst
    postprocessingIndependent

/-- Losing the auxiliary's second bit destroys decoding, despite independence. -/
example :
    ¬ IsFunctionalRepresentationOf postprocessingSource Prod.fst
      (fun omega => omega.2.2) (fun omega => omega.2.1) := by
  intro hRepresentation
  obtain ⟨_, decoder, hDecoder⟩ :=
    (isFunctionalRepresentationOf_iff postprocessingSource Prod.fst
      (fun omega => omega.2.2) (fun omega => omega.2.1)).1 hRepresentation
  have hFalse := hDecoder (false, (false, false)) (by simp [postprocessingSource, Set.prod])
  have hTrue := hDecoder (false, (false, true)) (by simp [postprocessingSource, Set.prod])
  exact Bool.false_ne_true (hFalse.trans hTrue.symm)

private def pairwiseParityY (omega : Bool × (Bool × Bool)) : Bool :=
  Bool.xor omega.1 omega.2.1

/--
For independent fair bits `A,B,C`, the triples `(A,A xor B,B)` and `(A,C,B)`
have the same three pairwise laws, but only the first admits a decoder. Thus
even equality of all pairwise laws cannot replace the full triple-law premise.
-/
example :
    postprocessingSource.map (fun omega => (omega.1, pairwiseParityY omega)) =
      postprocessingSource.map (fun omega => (omega.1, omega.2.2)) ∧
    postprocessingSource.map (fun omega => (pairwiseParityY omega, omega.2.1)) =
      postprocessingSource.map (fun omega => (omega.2.2, omega.2.1)) ∧
    postprocessingSource.map (fun omega => (omega.1, omega.2.1)) =
      postprocessingSource.map (fun omega => (omega.1, omega.2.1)) ∧
    IsFunctionalRepresentationOf postprocessingSource Prod.fst pairwiseParityY
      (fun omega => omega.2.1) ∧
    ¬ IsFunctionalRepresentationOf postprocessingSource Prod.fst
      (fun omega => omega.2.2) (fun omega => omega.2.1) := by
  refine ⟨?_, ?_, rfl, ?_, ?_⟩
  · apply PMF.ext
    rintro ⟨a, b⟩
    cases a <;> cases b <;>
      norm_num [postprocessingSource, pairwiseParityY, PMF.map_apply,
        PMF.uniformOfFintype_apply, Fintype.sum_prod_type, two_mul]
  · apply PMF.ext
    rintro ⟨a, b⟩
    cases a <;> cases b <;>
      norm_num [postprocessingSource, pairwiseParityY, PMF.map_apply,
        PMF.uniformOfFintype_apply, Fintype.sum_prod_type, two_mul]
  · rw [isFunctionalRepresentationOf_iff]
    exact ⟨isIndependentOf_comp_right postprocessingSource Prod.fst Prod.snd
      Prod.fst postprocessingIndependent, fun ab => Bool.xor ab.1 ab.2,
      by intro omega _; rfl⟩
  · intro hRepresentation
    obtain ⟨_, decoder, hDecoder⟩ :=
      (isFunctionalRepresentationOf_iff postprocessingSource Prod.fst
        (fun omega => omega.2.2) (fun omega => omega.2.1)).1 hRepresentation
    have hFalse := hDecoder (false, (false, false))
      (by simp [postprocessingSource, Set.prod])
    have hTrue := hDecoder (false, (false, true))
      (by simp [postprocessingSource, Set.prod])
    exact Bool.false_ne_true (hFalse.trans hTrue.symm)

section PolymorphicZeroConditions

variable {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
variable [Fintype alpha] [Fintype beta] [Fintype gamma]

/-- Equation (1) needs finite values, not a finite source or shared universes. -/
example (p : PMF omega) (X : omega → alpha) (Y : omega → beta)
    (Z : omega → gamma) :
    IsFunctionalRepresentationOf p X Y Z ↔
      mutualInfoOf p X Z = 0 ∧
        condEntropyOf p Y (fun omega => (X omega, Z omega)) = 0 :=
  isFunctionalRepresentationOf_iff_zero_conditions p X Y Z

end PolymorphicZeroConditions

private def supportOnlyBadDecoder (_ : Bool × Bool) : Bool :=
  true

/--
The zero conditions provide some support-correct decoder; they do not certify
a preselected decoder that fails at a positive-probability source point.
-/
example :
    mutualInfoOf supportOnlySource supportOnlyX supportOnlyZ = 0 ∧
    condEntropyOf supportOnlySource supportOnlyY
      (fun omega => (supportOnlyX omega, supportOnlyZ omega)) = 0 ∧
    (∃ decoder : Bool × Bool → Bool,
      ∀ omega ∈ supportOnlySource.support,
        supportOnlyY omega = decoder (supportOnlyX omega, supportOnlyZ omega)) ∧
    (∃ omega ∈ supportOnlySource.support,
      supportOnlyY omega ≠
        supportOnlyBadDecoder (supportOnlyX omega, supportOnlyZ omega)) := by
  have hDecoder : ∀ omega ∈ supportOnlySource.support,
      supportOnlyY omega =
        supportOnlyDecoder (supportOnlyX omega, supportOnlyZ omega) := by
    intro omega homega
    have homega_eq : omega = false := by
      simpa [supportOnlySource] using homega
    subst omega
    rfl
  have hIndependent : IsIndependentOf supportOnlySource supportOnlyX supportOnlyZ := by
    rw [isIndependentOf_iff_map_eq_indepProd]
    simp only [supportOnlySource, supportOnlyX, supportOnlyZ, PMF.pure_map]
    apply PMF.ext
    rintro ⟨x, z⟩
    cases x <;> cases z <;> simp
  have hRepresentation :=
    (isFunctionalRepresentationOf_iff supportOnlySource supportOnlyX supportOnlyY
      supportOnlyZ).2 ⟨hIndependent, supportOnlyDecoder, hDecoder⟩
  obtain ⟨hMI, hEntropy⟩ :=
    (isFunctionalRepresentationOf_iff_zero_conditions supportOnlySource
      supportOnlyX supportOnlyY supportOnlyZ).1 hRepresentation
  have hRecovered :=
    (isFunctionalRepresentationOf_iff_zero_conditions supportOnlySource
      supportOnlyX supportOnlyY supportOnlyZ).2 ⟨hMI, hEntropy⟩
  have hExists :=
    ((isFunctionalRepresentationOf_iff supportOnlySource supportOnlyX supportOnlyY
      supportOnlyZ).1 hRecovered).2
  exact ⟨hMI, hEntropy, hExists,
    ⟨false, by simp [supportOnlySource], by decide⟩⟩

/-- A pure PMF on the infinite type `Nat` is a valid Equation (1) source. -/
example :
    IsFunctionalRepresentationOf (PMF.pure (0 : Nat))
      (fun _ => false) (fun _ => false) (fun _ => false) ↔
    mutualInfoOf (PMF.pure (0 : Nat)) (fun _ => false) (fun _ => false) = 0 ∧
      condEntropyOf (PMF.pure (0 : Nat)) (fun _ => false)
        (fun _ => (false, false)) = 0 :=
  isFunctionalRepresentationOf_iff_zero_conditions (PMF.pure (0 : Nat))
    (fun _ => false) (fun _ => false) (fun _ => false)

section PolymorphicPfrDecomposition

variable {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
variable [Fintype alpha] [Fintype beta] [Fintype gamma]

/-- Equation (2) has no representation premise or finite-source requirement. -/
example (p : PMF omega) (X : omega → alpha) (Y : omega → beta)
    (Z : omega → gamma) :
    mutualInfoOf p Y Z =
      condEntropyOf p Y X
        - condMutualInfoOf p X Z Y
        - condEntropyOf p Y (fun omega => (X omega, Z omega))
        + mutualInfoOf p X Z :=
  mutualInfoOf_eq_pfr_decomposition p X Y Z

end PolymorphicPfrDecomposition

/--
Distinct value types fix the argument order `I(X;Z|Y)` and `H(Y|(X,Z))`;
the source PMF on the infinite ambient type `Nat` is arbitrary.
-/
example (p : PMF Nat) (X : Nat → Fin 2) (Y : Nat → Bool)
    (Z : Nat → Option Bool) :
    mutualInfoOf p Y Z =
      condEntropyOf p Y X
        - condMutualInfoOf p X Z Y
        - condEntropyOf p Y (fun omega => (X omega, Z omega))
        + mutualInfoOf p X Z :=
  mutualInfoOf_eq_pfr_decomposition p X Y Z

section PolymorphicPfrConsequences

variable {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
variable [Fintype alpha] [Fintype beta] [Fintype gamma]
variable (p : PMF omega) (X : omega → alpha) (Y : omega → beta)
  (Z : omega → gamma)

/-- Equation (3) retains the representation premise and unrestricted source. -/
example (hFR : IsFunctionalRepresentationOf p X Y Z) :
    mutualInfoOf p Y Z =
      condEntropyOf p Y X - condMutualInfoOf p X Z Y :=
  hFR.mutualInfoOf_eq_condEntropyOf_sub_condMutualInfoOf

/-- The upper bound has the same four-universe, finite-value contract. -/
example (hFR : IsFunctionalRepresentationOf p X Y Z) :
    mutualInfoOf p Y Z ≤ condEntropyOf p Y X :=
  hFR.mutualInfoOf_le_condEntropyOf

/-- Equality is characterized by `I(X;Z|Y) = 0`, under the structural premise. -/
example (hFR : IsFunctionalRepresentationOf p X Y Z) :
    mutualInfoOf p Y Z = condEntropyOf p Y X ↔
      condMutualInfoOf p X Z Y = 0 :=
  hFR.mutualInfoOf_eq_condEntropyOf_iff_condMutualInfoOf_eq_zero

/-- The equality condition uses the Markov orientation `X → Y → Z`. -/
example (hFR : IsFunctionalRepresentationOf p X Y Z) :
    mutualInfoOf p Y Z = condEntropyOf p Y X ↔
      IsMarkovChainOf p X Y Z :=
  hFR.mutualInfoOf_eq_condEntropyOf_iff_isMarkovChainOf

end PolymorphicPfrConsequences

/--
All four Equation (3) consequences apply when `Y = true` is a null fiber.
The source has proper support and its decoder fails off support; no conditional
law or decoder correctness on that omitted fiber is supplied.
-/
example :
    (supportOnlySource.map supportOnlyY) true = 0 ∧
    mutualInfoOf supportOnlySource supportOnlyY supportOnlyZ =
      condEntropyOf supportOnlySource supportOnlyY supportOnlyX -
        condMutualInfoOf supportOnlySource supportOnlyX supportOnlyZ supportOnlyY ∧
    mutualInfoOf supportOnlySource supportOnlyY supportOnlyZ ≤
      condEntropyOf supportOnlySource supportOnlyY supportOnlyX ∧
    (mutualInfoOf supportOnlySource supportOnlyY supportOnlyZ =
      condEntropyOf supportOnlySource supportOnlyY supportOnlyX ↔
        condMutualInfoOf supportOnlySource supportOnlyX supportOnlyZ supportOnlyY = 0) ∧
    (mutualInfoOf supportOnlySource supportOnlyY supportOnlyZ =
      condEntropyOf supportOnlySource supportOnlyY supportOnlyX ↔
        IsMarkovChainOf supportOnlySource supportOnlyX supportOnlyY supportOnlyZ) := by
  have hFR : IsFunctionalRepresentationOf supportOnlySource supportOnlyX
      supportOnlyY supportOnlyZ := by
    rw [isFunctionalRepresentationOf_iff]
    constructor
    · rw [isIndependentOf_iff_map_eq_indepProd]
      simp only [supportOnlySource, supportOnlyX, supportOnlyZ, PMF.pure_map]
      apply PMF.ext
      rintro ⟨x, z⟩
      cases x <;> cases z <;> simp
    · refine ⟨supportOnlyDecoder, ?_⟩
      intro omega homega
      have homega_eq : omega = false := by
        simpa [supportOnlySource] using homega
      subst omega
      rfl
  exact ⟨by simp [supportOnlySource, supportOnlyY],
    hFR.mutualInfoOf_eq_condEntropyOf_sub_condMutualInfoOf,
    hFR.mutualInfoOf_le_condEntropyOf,
    hFR.mutualInfoOf_eq_condEntropyOf_iff_condMutualInfoOf_eq_zero,
    hFR.mutualInfoOf_eq_condEntropyOf_iff_isMarkovChainOf⟩

/-! ## Fixed-perfect and pair-law regressions -/

section PolymorphicPerfectness

variable {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
variable [Fintype alpha] [Fintype beta] [Fintype gamma]
variable (p : PMF omega) (X : omega → alpha) (Y : omega → beta)
  (Z : omega → gamma)

/-- Fixed perfectness requires both structural representation and equality. -/
example :
    IsPerfectFunctionalRepresentationOf p X Y Z ↔
      IsFunctionalRepresentationOf p X Y Z ∧
        mutualInfoOf p Y Z = condEntropyOf p Y X :=
  isPerfectFunctionalRepresentationOf_iff p X Y Z

/-- The zero-CMI formulation retains its structural conjunct and orientation. -/
example :
    IsPerfectFunctionalRepresentationOf p X Y Z ↔
      IsFunctionalRepresentationOf p X Y Z ∧ condMutualInfoOf p X Z Y = 0 :=
  isPerfectFunctionalRepresentationOf_iff_condMutualInfoOf_eq_zero p X Y Z

/-- Markov alone is not asserted to imply fixed perfectness. -/
example :
    IsPerfectFunctionalRepresentationOf p X Y Z ↔
      IsFunctionalRepresentationOf p X Y Z ∧ IsMarkovChainOf p X Y Z :=
  isPerfectFunctionalRepresentationOf_iff_isMarkovChainOf p X Y Z

/-- Fixed-perfect witnesses provide the existential pair property. -/
example (hPerfect : IsPerfectFunctionalRepresentationOf p X Y Z) :
    IsPerfectlyRepresentablePairOf p X Y :=
  hPerfect.isPerfectlyRepresentablePairOf

end PolymorphicPerfectness

/-- A pair witness is a separate triple-law PMF, not an auxiliary on `omega`. -/
example {omega : Type u} {alpha : Type v} {beta : Type w}
    [Fintype alpha] [Fintype beta]
    (p : PMF omega) (X : omega → alpha) (Y : omega → beta) :
    IsPerfectlyRepresentablePairOf p X Y ↔
      ∃ n : Nat, ∃ q : PMF (alpha × beta × Fin n),
        fstSndMarginal q = p.map (fun omega => (X omega, Y omega)) ∧
          IsPerfectFunctionalRepresentation q :=
  isPerfectlyRepresentablePairOf_iff_exists_fin_extension p X Y

/-- Full-law transport permits unrelated source types and universes. -/
example {omega : Type u} {omega' : Type v} {alpha : Type w} {beta : Type x}
    {gamma : Type y} [Fintype alpha] [Fintype beta] [Fintype gamma]
    {p : PMF omega} {p' : PMF omega'}
    {X : omega → alpha} {Y : omega → beta} {Z : omega → gamma}
    {X' : omega' → alpha} {Y' : omega' → beta} {Z' : omega' → gamma}
    (hLaw : p.map (fun omega => (X omega, Y omega, Z omega)) =
      p'.map (fun omega => (X' omega, Y' omega, Z' omega))) :
    IsPerfectFunctionalRepresentationOf p X Y Z ↔
      IsPerfectFunctionalRepresentationOf p' X' Y' Z' :=
  isPerfectFunctionalRepresentationOf_congr_jointLaw hLaw

/-- Pair-law transport neither fixes an auxiliary nor requires a finite source. -/
example {omega : Type u} {omega' : Type v} {alpha : Type w} {beta : Type x}
    [Fintype alpha] [Fintype beta]
    {p : PMF omega} {p' : PMF omega'}
    {X : omega → alpha} {Y : omega → beta}
    {X' : omega' → alpha} {Y' : omega' → beta}
    (hLaw : p.map (fun omega => (X omega, Y omega)) =
      p'.map (fun omega => (X' omega, Y' omega))) :
    IsPerfectlyRepresentablePairOf p X Y ↔
      IsPerfectlyRepresentablePairOf p' X' Y' :=
  isPerfectlyRepresentablePairOf_congr_pairLaw hLaw

private theorem deterministicPerfect
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    (p : PMF omega) (X : omega → alpha) (f : alpha → beta) (z0 : gamma) :
    IsPerfectFunctionalRepresentationOf p X (fun omega => f (X omega))
      (fun _ => z0) := by
  apply (isPerfectFunctionalRepresentationOf_iff_isMarkovChainOf _ _ _ _).2
  constructor
  · apply (isFunctionalRepresentationOf_iff _ _ _ _).2
    refine ⟨?_, fun t => f t.1, by intro omega _; rfl⟩
    rw [isIndependentOf_iff_map_eq_indepProd]
    change p.map (fun omega => (X omega, z0)) =
      indepProd (p.map X) (p.map (Function.const omega z0))
    rw [PMF.map_const]
    simp [indepProd, PMF.map, Function.comp_def]
  · exact isMarkovChainOf_comp p X (fun omega => f (X omega)) (fun _ => z0)

/-- Deterministic `Y = f(X)` is perfect with singleton `Z`, and so is its pair. -/
example {omega : Type u} {alpha : Type v} {beta : Type w}
    [Fintype alpha] [Fintype beta]
    (p : PMF omega) (X : omega → alpha) (f : alpha → beta) :
    IsPerfectFunctionalRepresentationOf p X (fun omega => f (X omega))
      (fun _ => ()) ∧
    IsPerfectlyRepresentablePairOf p X (fun omega => f (X omega)) := by
  have hPerfect := deterministicPerfect p X f ()
  exact ⟨hPerfect, hPerfect.isPerfectlyRepresentablePairOf⟩

/-- All singleton value alphabets work even on an unrestricted infinite source. -/
example (p : PMF Nat) :
    IsPerfectFunctionalRepresentationOf p (fun _ => ()) (fun _ => ())
      (fun _ => ()) ∧
    IsPerfectlyRepresentablePairOf p (fun _ => ()) (fun _ => ()) := by
  have hPerfect := deterministicPerfect p (fun _ => ()) (fun _ => ()) ()
  exact ⟨hPerfect, hPerfect.isPerfectlyRepresentablePairOf⟩

private def xorSource : PMF (Bool × Bool) :=
  indepProd (PMF.uniformOfFintype Bool) (PMF.uniformOfFintype Bool)

private def xorOutput (t : Bool × Bool) : Bool :=
  Bool.xor t.1 t.2

private theorem xorFunctional :
    IsFunctionalRepresentationOf xorSource Prod.fst xorOutput Prod.snd := by
  rw [isFunctionalRepresentationOf_iff]
  refine ⟨?_, fun t => Bool.xor t.1 t.2, by intro t _; rfl⟩
  unfold IsIndependentOf
  change IsIndependent (xorSource.map id)
  rw [PMF.map_id]
  exact isIndependent_indepProd _ _

private theorem xorNotMarkov :
    ¬ IsMarkovChainOf xorSource Prod.fst xorOutput Prod.snd := by
  intro h
  have hm : IsMarkovChain (xorSource.map fun t => (t.1, xorOutput t, t.2)) := by
    simpa only [IsMarkovChain, IsMarkovChainOf, IsCondIndependentOf,
      PMF.map_comp, Function.comp_def] using h
  have hCross := (isMarkovChain_iff_crossProduct _).1 hm false false false
  norm_num [xorSource, xorOutput, PMF.map_apply, PMF.uniformOfFintype_apply,
    fstSndMarginal, sndThirdMarginal, sndMarginal, Fintype.sum_prod_type,
    two_mul] at hCross
  have hReal := congrArg ENNReal.toReal hCross
  have hFinite : (2 : ENNReal)⁻¹ * 2⁻¹ ≠ ⊤ := by finiteness
  rw [ENNReal.toReal_mul, ENNReal.toReal_add hFinite hFinite] at hReal
  norm_num [ENNReal.toReal_mul] at hReal

/--
Independent fair bits with `Y = X xor Z` give a functional but nonperfect
specified auxiliary. This makes no nonrepresentability claim about the pair.
-/
example :
    IsFunctionalRepresentationOf xorSource Prod.fst xorOutput Prod.snd ∧
    ¬ IsPerfectFunctionalRepresentationOf xorSource Prod.fst xorOutput Prod.snd ∧
    ¬ IsMarkovChainOf xorSource Prod.fst xorOutput Prod.snd := by
  refine ⟨xorFunctional, ?_, xorNotMarkov⟩
  intro hPerfect
  exact xorNotMarkov
    ((isPerfectFunctionalRepresentationOf_iff_isMarkovChainOf _ _ _ _).1 hPerfect).2

/-- A perfectly representable law transports concretely from `Unit` to `Nat`. -/
example :
    IsPerfectlyRepresentablePairOf (PMF.pure ()) (fun _ => false) (fun _ => true) ∧
    IsPerfectlyRepresentablePairOf (PMF.pure (0 : Nat))
      (fun _ => false) (fun _ => true) := by
  have hUnit := (deterministicPerfect (PMF.pure ()) (fun _ => false)
    (fun _ => true) ()).isPerfectlyRepresentablePairOf
  have hLaw :
      (PMF.pure ()).map (fun _ => (false, true)) =
      (PMF.pure (0 : Nat)).map (fun _ => (false, true)) := by
    simp only [PMF.pure_map]
  exact ⟨hUnit, (isPerfectlyRepresentablePairOf_congr_pairLaw hLaw).1 hUnit⟩

/-- A concrete pair yields a witness on a separate finite triple-law carrier. -/
example :
    ∃ n : Nat, ∃ q : PMF (Bool × Bool × Fin n),
      fstSndMarginal q =
        (PMF.pure (0 : Nat)).map (fun _ => (false, true)) ∧
      IsPerfectFunctionalRepresentation q := by
  have hPair := (deterministicPerfect (PMF.pure (0 : Nat)) (fun _ => false)
    (fun _ => true) ()).isPerfectlyRepresentablePairOf
  exact (isPerfectlyRepresentablePairOf_iff_exists_fin_extension _ _ _).1 hPair

/-- A genuinely `Type 1` auxiliary can be recoded by the law-level bridge. -/
example (q : PMF (Bool × Bool × ULift.{1} (Fin 2)))
    (hPerfect : IsPerfectFunctionalRepresentation q) :
    IsPerfectlyRepresentablePair (fstSndMarginal q) :=
  hPerfect.isPerfectlyRepresentablePair

/-- The common-base bridge also accepts a concrete higher-universe auxiliary. -/
example :
    IsPerfectFunctionalRepresentationOf (PMF.pure (0 : Nat))
      (fun _ => false) (fun _ => true)
      (fun _ => (ULift.up (0 : Fin 2) : ULift.{1} (Fin 2))) ∧
    IsPerfectlyRepresentablePairOf (PMF.pure (0 : Nat))
      (fun _ => false) (fun _ => true) := by
  have hPerfect := deterministicPerfect (PMF.pure (0 : Nat)) (fun _ => false)
    (fun _ => true) (ULift.up (0 : Fin 2) : ULift.{1} (Fin 2))
  exact ⟨hPerfect, hPerfect.isPerfectlyRepresentablePairOf⟩

/-- An actual extension PMF excludes `Fin 0` without an extra public premise. -/
example {alpha : Type u} {beta : Type v}
    (q : PMF (alpha × beta × Fin 0)) : False := by
  obtain ⟨t, _⟩ := q.support_nonempty
  exact Fin.elim0 t.2.2

end

end PerfectFunctionalRepresentations
