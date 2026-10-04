import PerfectFunctionalRepresentations.Optimization.DualCharacterization

/-!
# Consumers of the specialized subunit dual certificate

C15-S02 instantiates the public alternative on arbitrary valid data and on
an empty admissible family. Concrete nonempty-family arithmetic stays beside
the retained private paper fixture; it does not identify the existential
certificate with any particular hand-calculated vector.
C15-S03 checks both leastness directions and the universal lower bound,
including the empty-family distinction from objective-one membership.
C15-S04 consumes literal finite objective images and the finite ambient corollary.
-/

namespace PerfectFunctionalRepresentations.Dual.CharacterizationTests

open scoped BigOperators Matrix

noncomputable section
attribute [local instance] Classical.propDecidable

variable {α : Type*} [Fintype α] [Nonempty α] (D : CompressedPatternData α)

example (hD : ¬ IsPerfectlyRepresentableChannel D.channel) :
    ∃ y, Dual.Feasible D y ∧ Dual.objective D y < 1 :=
  Dual.exists_feasible_objective_lt_one_of_not_perfect D hD

example (hD : ¬ IsPerfectlyRepresentableChannel D.channel) :
    ∃ r ∈ Dual.objectiveValues D, r < 1 := by
  obtain ⟨y, hy, ho⟩ := Dual.exists_feasible_objective_lt_one_of_not_perfect D hD
  exact ⟨Dual.objective D y, ⟨y, hy, rfl⟩, ho⟩

-- The public alternative accepts the empty branch with no hull inhabitance.
example [IsEmpty (Incidence.AdmissiblePartition D)] :
    ∃ y, Dual.Feasible D y ∧ Dual.objective D y < 1 := by
  apply Dual.exists_feasible_objective_lt_one_of_not_perfect D
  intro hD
  obtain ⟨x, hx⟩ :=
    (Incidence.isPerfectlyRepresentableChannel_iff_exists_feasible D).mp hD
  exact Incidence.not_reduced_eq_of_isEmpty D x hx.2

-- C15-S03: membership and the universal lower bound are separate obligations.
example : IsPerfectlyRepresentableChannel D.channel ↔
    IsLeast (Dual.objectiveValues D) 1 :=
  Dual.isPerfectlyRepresentableChannel_iff_isLeast D

example (hD : IsPerfectlyRepresentableChannel D.channel) :
    IsLeast (Dual.objectiveValues D) 1 ∧
    ∀ y, Dual.Feasible D y → 1 ≤ Dual.objective D y := by
  have hl := (Dual.isPerfectlyRepresentableChannel_iff_isLeast D).mp hD
  exact ⟨hl, fun y hy => hl.2 ⟨y, hy, rfl⟩⟩

example (hl : IsLeast (Dual.objectiveValues D) 1) :
    IsPerfectlyRepresentableChannel D.channel :=
  (Dual.isPerfectlyRepresentableChannel_iff_isLeast D).mpr hl

example (hb : ∀ y, Dual.Feasible D y → 1 ≤ Dual.objective D y) :
    IsPerfectlyRepresentableChannel D.channel := by
  apply (Dual.isPerfectlyRepresentableChannel_iff_isLeast D).mpr
  refine ⟨Dual.one_mem_objectiveValues D, ?_⟩
  rintro r ⟨y, hy, rfl⟩
  exact hb y hy

example [IsEmpty (Incidence.AdmissiblePartition D)] :
    ¬ IsLeast (Dual.objectiveValues D) 1 ∧
    ¬ IsPerfectlyRepresentableChannel D.channel ∧
    (1 : ℝ) ∈ Dual.objectiveValues D := by
  have hn : ¬ IsLeast (Dual.objectiveValues D) 1 := by
    intro hl
    have hz := hl.2 ⟨fun _ => 0, Dual.feasible_zero_of_isEmpty D, Dual.objective_zero D⟩
    norm_num at hz
  refine ⟨hn, ?_, Dual.one_mem_objectiveValues D⟩
  exact fun hp => hn ((Dual.isPerfectlyRepresentableChannel_iff_isLeast D).mp hp)

example {β : Type*} [Finite β] (κ : α → PMF β) (hκ : IsSingularChannel κ)
    (hp : IsPerfectlyRepresentableChannel κ) :
    IsLeast (Dual.objectiveValues (compressedPatternData κ hκ)) 1 :=
  (Dual.isPerfectlyRepresentableChannel_iff_isLeast_compressedPatternData κ hκ).mp hp

example {β : Type*} [Finite β] (κ : α → PMF β) (hκ : IsSingularChannel κ)
    (hl : IsLeast (Dual.objectiveValues (compressedPatternData κ hκ)) 1) :
    IsPerfectlyRepresentableChannel κ :=
  (Dual.isPerfectlyRepresentableChannel_iff_isLeast_compressedPatternData κ hκ).mpr hl

-- C15-S04 / R10: leastness is asserted on the exact finite dual objective image.
example {m n : ℕ} (rows : Incidence.OccurringPattern D ≃ Fin m)
    (cols : Incidence.AdmissiblePartition D ≃ Fin n) :
    IsPerfectlyRepresentableChannel D.channel ↔ IsLeast
      ((fun z : Fin m → ℝ => (D.value ∘ rows.symm) ⬝ᵥ z) ''
        {z | (∀ i, 0 ≤ z i) ∧
          ∀ j, 1 ≤ ((Matrix.reindex rows cols (Incidence.reducedMatrix D))ᵀ *ᵥ z) j}) 1 :=
  Dual.isPerfectlyRepresentableChannel_iff_isLeast_reindex D rows cols

example {β : Type*} [Finite β] (κ : α → PMF β) (hκ : IsSingularChannel κ)
    {m n : ℕ} (rows : Incidence.OccurringPattern (compressedPatternData κ hκ) ≃ Fin m)
    (cols : Incidence.AdmissiblePartition (compressedPatternData κ hκ) ≃ Fin n) :
    IsPerfectlyRepresentableChannel κ ↔ IsLeast
      ((fun z : Fin m → ℝ => ((compressedPatternData κ hκ).value ∘ rows.symm) ⬝ᵥ z) ''
        {z | (∀ i, 0 ≤ z i) ∧ ∀ j,
          1 ≤ ((Matrix.reindex rows cols (Incidence.reducedMatrix (compressedPatternData κ hκ)))ᵀ
            *ᵥ z) j}) 1 :=
  Dual.isPerfectlyRepresentableChannel_iff_isLeast_compressedPatternData_reindex
    κ hκ rows cols

example {β : Type*} [Finite β] (κ : α → PMF β) (hκ : IsSingularChannel κ) :
    IsPerfectlyRepresentableChannel κ ↔ IsLeast
      ((fun z : Fin (Fintype.card (Incidence.OccurringPattern (compressedPatternData κ hκ))) → ℝ =>
        ((compressedPatternData κ hκ).value ∘
          (Fintype.equivFin
            (Incidence.OccurringPattern (compressedPatternData κ hκ))).symm) ⬝ᵥ z) ''
        {z | (∀ i, 0 ≤ z i) ∧ ∀ j,
          1 ≤ ((Matrix.reindex
            (Fintype.equivFin (Incidence.OccurringPattern (compressedPatternData κ hκ)))
            (Fintype.equivFin (Incidence.AdmissiblePartition (compressedPatternData κ hκ)))
          (Incidence.reducedMatrix (compressedPatternData κ hκ)))ᵀ *ᵥ z) j}) 1 :=
  Dual.isPerfectlyRepresentableChannel_iff_isLeast_compressedPatternData_reindex
    κ hκ (Fintype.equivFin _) (Fintype.equivFin _)


end

end PerfectFunctionalRepresentations.Dual.CharacterizationTests
