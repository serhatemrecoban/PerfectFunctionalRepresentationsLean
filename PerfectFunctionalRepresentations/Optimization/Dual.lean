import PerfectFunctionalRepresentations.Optimization.Primal

/-!
# Reduced dual feasibility and elementary witnesses

The dual in ISIT Section IV-B, Corollary 1/(19), uses nonnegative occurring-pattern
coordinates, transpose incidence inequalities and the value-vector dot product.
These are C13's same reduced incidence system and C12's valid compressed data;
the admissible-partition index may be empty. Dual feasibility is distinct from
both the equality-incidence predicate and the primal inequality predicate.

Weak duality uses coefficient nonnegativity on the primal side and coordinate
nonnegativity on the dual side. Every input row of the input-incidence matrix
supplies a dual witness of objective one, by `P H = 1` and `P v = 1`. Thus one
is an attained dual value for every valid datum; this membership alone does not
characterize perfectness. No minimum or separation result is asserted here.

When no admissible partition exists, the zero vector is dual feasible with
objective zero. Pattern values are normalized per input, without a total-value
normalization or prior assumption.

Independent finite row and column presentations preserve feasibility, the
transpose incidence image and the entire attained objective image. Both vector
directions use the supplied equivalences, including empty partition coordinates.
-/

namespace PerfectFunctionalRepresentations.Dual

noncomputable section
attribute [local instance] Classical.propDecidable

open scoped BigOperators Matrix
open Incidence (AdmissiblePartition inputMatrix reducedMatrix)

universe u

variable {α : Type u} [Fintype α] [Nonempty α] (D : CompressedPatternData α)

/-- Nonnegative pattern coordinates whose sum on every admissible partition is at least one. -/
def Feasible (y : Incidence.OccurringPattern D → ℝ) : Prop :=
  (∀ p, 0 ≤ y p) ∧ ∀ j, 1 ≤ ((reducedMatrix D)ᵀ *ᵥ y) j

/-- The dual objective is the dot product with the occurring-pattern values. -/
def objective (y : Incidence.OccurringPattern D → ℝ) : ℝ := D.value ⬝ᵥ y

/-- All reduced dual-feasible pattern vectors. -/
def feasibleSet : Set (Incidence.OccurringPattern D → ℝ) := {y | Feasible D y}

/-- Values actually attained by the dual objective on feasible vectors. -/
def objectiveValues : Set ℝ := objective D '' feasibleSet D

/-- The zero pattern vector has objective zero for every valid datum. -/
@[simp]
theorem objective_zero : objective D (fun _ => 0) = 0 := by
  simp [objective]

/-- Every dual-feasible objective is nonnegative. -/
theorem objective_nonneg {y : Incidence.OccurringPattern D → ℝ} (hy : Feasible D y) :
    0 ≤ objective D y :=
  Finset.sum_nonneg (fun p _ => mul_nonneg (D.value_pos p).le (hy.1 p))

/-- Every primal-feasible value is bounded above by every dual-feasible value. -/
theorem weak_duality {x : AdmissiblePartition D → ℝ} {y : Incidence.OccurringPattern D → ℝ}
    (hx : Primal.Feasible D x) (hy : Feasible D y) :
    Primal.objective D x ≤ objective D y := by
  calc
    Primal.objective D x ≤ x ⬝ᵥ ((reducedMatrix D)ᵀ *ᵥ y) := by
      apply Finset.sum_le_sum
      intro j _
      exact le_mul_of_one_le_right (hx.1 j) (hy.2 j)
    _ = (reducedMatrix D *ᵥ x) ⬝ᵥ y :=
      (Matrix.dotProduct_transpose_mulVec (reducedMatrix D) x y).trans
        (dotProduct_comm _ _)
    _ ≤ objective D y := by
      apply Finset.sum_le_sum
      intro p _
      exact mul_le_mul_of_nonneg_right (hx.2 p) (hy.1 p)

/-- The indicator of the occurring patterns containing a supplied input. -/
def rowWitness (i : α) : Incidence.OccurringPattern D → ℝ := inputMatrix D i

/-- Every input-row witness makes all dual incidence constraints equalities. -/
theorem transpose_mulVec_rowWitness (i : α) :
    (reducedMatrix D)ᵀ *ᵥ rowWitness D i = (fun _ => 1) := by
  ext j
  have h := congrFun (congrFun (Incidence.inputMatrix_mul_reducedMatrix D) i) j
  simpa only [rowWitness, Matrix.mul_apply, Matrix.mulVec, Matrix.transpose_apply,
    dotProduct, mul_comm] using h

/-- Every input-row witness has objective one by row-wise value normalization. -/
theorem objective_rowWitness (i : α) : objective D (rowWitness D i) = 1 := by
  have h := congrFun (Incidence.inputMatrix_mulVec_value D) i
  simpa only [objective, rowWitness, Matrix.mulVec, dotProduct, mul_comm] using h

/-- Every input supplies a dual-feasible row witness, even with no partition columns. -/
theorem feasible_rowWitness (i : α) : Feasible D (rowWitness D i) := by
  refine ⟨fun p => Incidence.inputMatrix_nonneg D i p, fun j => ?_⟩
  rw [transpose_mulVec_rowWitness]

/-- One is an attained dual objective value for every valid compressed datum. -/
theorem one_mem_objectiveValues : 1 ∈ objectiveValues D := by
  exact ⟨rowWitness D (Classical.arbitrary α),
    feasible_rowWitness D _, objective_rowWitness D _⟩

/-- With no admissible partition, the zero vector satisfies all dual constraints vacuously. -/
theorem feasible_zero_of_isEmpty [IsEmpty (AdmissiblePartition D)] :
    Feasible D (fun _ => 0) :=
  ⟨fun _ => le_rfl, fun j => isEmptyElim j⟩

/-- Transpose multiplication transports a dual vector through independent finite
presentations; transposition swaps the row and column equivalences. -/
theorem transpose_mulVec_reindex (y : Incidence.OccurringPattern D → ℝ) {m n : ℕ}
    (rows : Incidence.OccurringPattern D ≃ Fin m)
    (cols : AdmissiblePartition D ≃ Fin n) :
    (Matrix.reindex rows cols (reducedMatrix D))ᵀ *ᵥ (y ∘ rows.symm) =
      ((reducedMatrix D)ᵀ *ᵥ y) ∘ cols.symm := by
  rw [Matrix.transpose_reindex, Incidence.reindex_mulVec]

/-- Independent finite presentations preserve all dual feasibility inequalities,
with the inverse vector transport covering every finite vector. -/
theorem feasible_reindex_iff (y : Incidence.OccurringPattern D → ℝ) {m n : ℕ}
    (rows : Incidence.OccurringPattern D ≃ Fin m)
    (cols : AdmissiblePartition D ≃ Fin n) :
    Feasible D y ↔ ((∀ i, 0 ≤ (y ∘ rows.symm) i) ∧
      ∀ j, 1 ≤ ((Matrix.reindex rows cols (reducedMatrix D))ᵀ *ᵥ
        (y ∘ rows.symm)) j) := by
  rw [transpose_mulVec_reindex]
  constructor
  · rintro ⟨hn, hi⟩
    exact ⟨fun i => hn (rows.symm i), fun j => hi (cols.symm j)⟩
  · rintro ⟨hn, hi⟩
    constructor
    · intro p
      simpa only [Function.comp_apply, Equiv.symm_apply_apply] using hn (rows p)
    · intro π
      simpa only [Function.comp_apply, Equiv.symm_apply_apply] using hi (cols π)

/-- Reindexing pattern values and dual coordinates preserves their dot product. -/
theorem objective_reindex (y : Incidence.OccurringPattern D → ℝ) {m : ℕ}
    (rows : Incidence.OccurringPattern D ≃ Fin m) :
    (D.value ∘ rows.symm) ⬝ᵥ (y ∘ rows.symm) = objective D y := by
  change (∑ i : Fin m, D.value (rows.symm i) * y (rows.symm i)) =
    ∑ p, D.value p * y p
  exact rows.symm.sum_comp (fun p => D.value p * y p)

/-- The entire finite-coordinate attained objective image equals the intrinsic
image. The inverse vector `z ∘ rows` covers every finite vector, including when
the partition presentation has no coordinates. -/
theorem objectiveValues_reindex {m n : ℕ}
    (rows : Incidence.OccurringPattern D ≃ Fin m)
    (cols : AdmissiblePartition D ≃ Fin n) :
    (fun z : Fin m → ℝ => (D.value ∘ rows.symm) ⬝ᵥ z) ''
      {z | (∀ i, 0 ≤ z i) ∧
        ∀ j, 1 ≤ ((Matrix.reindex rows cols (reducedMatrix D))ᵀ *ᵥ z) j} =
      objectiveValues D := by
  ext r
  constructor
  · rintro ⟨z, hz, rfl⟩
    change (∀ i, 0 ≤ z i) ∧
      (∀ j, 1 ≤ ((Matrix.reindex rows cols (reducedMatrix D))ᵀ *ᵥ z) j) at hz
    refine ⟨z ∘ rows, (feasible_reindex_iff D (z ∘ rows) rows cols).mpr ?_, ?_⟩
    · simpa only [Function.comp_def, Equiv.apply_symm_apply] using hz
    · simpa only [Function.comp_def, Equiv.apply_symm_apply]
        using (objective_reindex D (z ∘ rows) rows).symm
  · rintro ⟨y, hy, rfl⟩
    exact ⟨y ∘ rows.symm, (feasible_reindex_iff D y rows cols).mp hy,
      objective_reindex D y rows⟩

end

end PerfectFunctionalRepresentations.Dual
