import PerfectFunctionalRepresentations.Optimization.Dual

/-!
# Consumers of the reduced dual algebra

C15-S01 checks the generic R01 and R03 interfaces on arbitrary valid compressed
data. Row witnesses and their attained objective do not assume perfectness or
inhabited admissible partitions. The empty-family branch is separate. Concrete
Unit, empty-pair and signed-dual consumers remain in the existing fixture owners.
C15-S04 checks independent finite coordinates, inverse recovery for arbitrary
finite vectors, the entire objective image and the exact reduced variable count.
-/

namespace PerfectFunctionalRepresentations.Dual.Tests

open scoped BigOperators Matrix

noncomputable section
attribute [local instance] Classical.propDecidable

variable {α : Type*} [Fintype α] [Nonempty α] (D : CompressedPatternData α)

-- R01: the domains and feasibility directions are the actual reduced system.
example : Fintype (Incidence.OccurringPattern D) := inferInstance
example : Fintype (Incidence.AdmissiblePartition D) := inferInstance

example (y : Incidence.OccurringPattern D → ℝ) : Dual.Feasible D y ↔
    (∀ p, 0 ≤ y p) ∧ ∀ j, 1 ≤ ((Incidence.reducedMatrix D)ᵀ *ᵥ y) j := Iff.rfl

example (y : Incidence.OccurringPattern D → ℝ) :
    Dual.objective D y = ∑ p, D.value p * y p := rfl

example (y : Incidence.OccurringPattern D → ℝ) :
    y ∈ Dual.feasibleSet D ↔ Dual.Feasible D y := Iff.rfl

example {y : Incidence.OccurringPattern D → ℝ} (hy : Dual.Feasible D y) :
    0 ≤ Dual.objective D y := Dual.objective_nonneg D hy

-- Each image member retains an actual feasible vector, not an unattained bound.
example {r : ℝ} (hr : r ∈ Dual.objectiveValues D) :
    ∃ y, Dual.Feasible D y ∧ Dual.objective D y = r := by
  rcases hr with ⟨y, hy, he⟩
  exact ⟨y, hy, he⟩

example {r : ℝ} (hr : r ∈ Dual.objectiveValues D) : 0 ≤ r := by
  rcases hr with ⟨y, hy, rfl⟩
  exact Dual.objective_nonneg D hy

-- Weak duality has the primal objective on the lower side.
example {x : Incidence.AdmissiblePartition D → ℝ}
    {y : Incidence.OccurringPattern D → ℝ}
    (hx : Primal.Feasible D x) (hy : Dual.Feasible D y) :
    (∑ j, x j) ≤ ∑ p, D.value p * y p := Dual.weak_duality D hx hy

-- Equality weights are consumed through C14's existing same-vector bridge.
example {x : Incidence.AdmissiblePartition D → ℝ}
    {y : Incidence.OccurringPattern D → ℝ}
    (hx : Incidence.Feasible D x) (hy : Dual.Feasible D y) :
    1 ≤ Dual.objective D y := by
  obtain ⟨hp, ho⟩ := (Primal.equality_feasible_iff D).mp hx
  rw [← ho]
  exact Dual.weak_duality D hp hy

-- Every supplied input supplies the witness; no fixed row is built into the API.
example (i : α) :
    (Incidence.reducedMatrix D)ᵀ *ᵥ Dual.rowWitness D i = (fun _ => 1) :=
  Dual.transpose_mulVec_rowWitness D i

example (i : α) :
    Dual.Feasible D (Dual.rowWitness D i) ∧ Dual.objective D (Dual.rowWitness D i) = 1 :=
  ⟨Dual.feasible_rowWitness D i, Dual.objective_rowWitness D i⟩

example : 1 ∈ Dual.objectiveValues D := Dual.one_mem_objectiveValues D

example : (Dual.objectiveValues D).Nonempty := ⟨1, Dual.one_mem_objectiveValues D⟩

-- R03: primal zero is feasible, but any inhabited column index rejects dual zero.
example [Nonempty (Incidence.AdmissiblePartition D)] :
    Primal.Feasible D (fun _ => 0) ∧ ¬ Dual.Feasible D (fun _ => 0) := by
  refine ⟨Primal.feasible_zero D, ?_⟩
  intro hy
  have h := hy.2 (Classical.arbitrary (Incidence.AdmissiblePartition D))
  norm_num [Matrix.mulVec, dotProduct] at h

-- R04's generic empty-family boundary uses vacuity, not a nonempty hull.
example [IsEmpty (Incidence.AdmissiblePartition D)] :
    Dual.Feasible D (fun _ => 0) ∧ Dual.objective D (fun _ => 0) = 0 ∧
      Dual.objective D (fun _ => 0) < 1 := by
  refine ⟨Dual.feasible_zero_of_isEmpty D, Dual.objective_zero D, ?_⟩
  rw [Dual.objective_zero]
  exact zero_lt_one

example [IsEmpty (Incidence.AdmissiblePartition D)] : 0 ∈ Dual.objectiveValues D :=
  ⟨fun _ => 0, Dual.feasible_zero_of_isEmpty D, Dual.objective_zero D⟩

example [IsEmpty (Incidence.AdmissiblePartition D)]
    (x : Incidence.AdmissiblePartition D → ℝ) : ¬ Incidence.Feasible D x :=
  fun hx => Incidence.not_reduced_eq_of_isEmpty D x hx.2

-- C15-S04 / R01: both equivalences are swapped when transposing the finite matrix.
example (y : Incidence.OccurringPattern D → ℝ) {m n : ℕ}
    (rows : Incidence.OccurringPattern D ≃ Fin m)
    (cols : Incidence.AdmissiblePartition D ≃ Fin n) :
    (Matrix.reindex rows cols (Incidence.reducedMatrix D))ᵀ *ᵥ (y ∘ rows.symm) =
      ((Incidence.reducedMatrix D)ᵀ *ᵥ y) ∘ cols.symm :=
  Dual.transpose_mulVec_reindex D y rows cols

example (y : Incidence.OccurringPattern D → ℝ) {m n : ℕ}
    (rows : Incidence.OccurringPattern D ≃ Fin m)
    (cols : Incidence.AdmissiblePartition D ≃ Fin n) :
    Dual.Feasible D y ↔ ((∀ i, 0 ≤ (y ∘ rows.symm) i) ∧
      ∀ j, 1 ≤ ((Matrix.reindex rows cols (Incidence.reducedMatrix D))ᵀ *ᵥ
        (y ∘ rows.symm)) j) :=
  Dual.feasible_reindex_iff D y rows cols

example (y : Incidence.OccurringPattern D → ℝ) {m : ℕ}
    (rows : Incidence.OccurringPattern D ≃ Fin m) :
    (D.value ∘ rows.symm) ⬝ᵥ (y ∘ rows.symm) = Dual.objective D y :=
  Dual.objective_reindex D y rows

example {m n : ℕ} (rows : Incidence.OccurringPattern D ≃ Fin m)
    (cols : Incidence.AdmissiblePartition D ≃ Fin n) :
    (fun z : Fin m → ℝ => (D.value ∘ rows.symm) ⬝ᵥ z) ''
      {z | (∀ i, 0 ≤ z i) ∧
        ∀ j, 1 ≤ ((Matrix.reindex rows cols (Incidence.reducedMatrix D))ᵀ *ᵥ z) j} =
      Dual.objectiveValues D :=
  Dual.objectiveValues_reindex D rows cols

-- Every finite vector is lifted, rather than only transporting one existing witness.
example {m n : ℕ} (rows : Incidence.OccurringPattern D ≃ Fin m)
    (cols : Incidence.AdmissiblePartition D ≃ Fin n) (z : Fin m → ℝ)
    (hz : (∀ i, 0 ≤ z i) ∧
      ∀ j, 1 ≤ ((Matrix.reindex rows cols (Incidence.reducedMatrix D))ᵀ *ᵥ z) j) :
    Dual.Feasible D (z ∘ rows) ∧
    (D.value ∘ rows.symm) ⬝ᵥ z = Dual.objective D (z ∘ rows) ∧
    (z ∘ rows) ∘ rows.symm = z := by
  have hr : (z ∘ rows) ∘ rows.symm = z := by
    ext i
    simp only [Function.comp_apply, Equiv.apply_symm_apply]
  refine ⟨(Dual.feasible_reindex_iff D (z ∘ rows) rows cols).mpr ?_, ?_, hr⟩
  · simpa only [hr] using hz
  · simpa only [hr] using Dual.objective_reindex D (z ∘ rows) rows

example {m n : ℕ} (rows : Incidence.OccurringPattern D ≃ Fin m)
    (cols : Incidence.AdmissiblePartition D ≃ Fin n) (r : ℝ) :
    (r ∈ (fun z : Fin m → ℝ => (D.value ∘ rows.symm) ⬝ᵥ z) ''
      {z | (∀ i, 0 ≤ z i) ∧
        ∀ j, 1 ≤ ((Matrix.reindex rows cols (Incidence.reducedMatrix D))ᵀ *ᵥ z) j}) ↔
      r ∈ Dual.objectiveValues D := by
  rw [Dual.objectiveValues_reindex]

-- R10: supplied finite coordinates have exactly the occurring-pattern count m.
example {m : ℕ} (rows : Incidence.OccurringPattern D ≃ Fin m) :
    m = D.patterns.card ∧ m ≤ 2 ^ Fintype.card α - 1 ∧
    Fintype.card (Incidence.NonzeroPattern α) = 2 ^ Fintype.card α - 1 := by
  have hc := Fintype.card_congr rows
  simp only [Fintype.card_fin] at hc
  have hm : m = D.patterns.card := hc.symm.trans (Incidence.card_occurringPattern D)
  exact ⟨hm, hm ▸ Incidence.patterns_card_le D, Incidence.card_nonzeroPattern⟩

example :
    (fun z : Fin (Fintype.card (Incidence.OccurringPattern D)) → ℝ =>
      (D.value ∘ (Fintype.equivFin (Incidence.OccurringPattern D)).symm) ⬝ᵥ z) ''
      {z | (∀ i, 0 ≤ z i) ∧ ∀ j,
        1 ≤ ((Matrix.reindex (Fintype.equivFin (Incidence.OccurringPattern D))
          (Fintype.equivFin (Incidence.AdmissiblePartition D))
          (Incidence.reducedMatrix D))ᵀ *ᵥ z) j} = Dual.objectiveValues D :=
  Dual.objectiveValues_reindex D (Fintype.equivFin _) (Fintype.equivFin _)

end

end PerfectFunctionalRepresentations.Dual.Tests
