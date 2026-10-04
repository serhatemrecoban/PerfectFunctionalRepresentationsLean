import PerfectFunctionalRepresentations.Optimization.Dual
import Mathlib.Analysis.LocallyConvex.Separation
import Mathlib.LinearAlgebra.Matrix.Dual

/-!
# Strict dual certificates and attained leastness

This module supplies the specialized alternative used for ISIT Section IV-B,
Corollary 1/(19), and extended Section IV-B/(65). It uses the same valid C12
compressed data and reduced C13 incidence coordinates as the primal and dual.
All geometric and normalization machinery is private.

The empty admissible-partition case uses the zero dual vector first. Otherwise,
nonperfectness places the value vector outside the finite incidence-column hull.
Strict separation supplies finite dot-product coordinates. Adding a sufficiently
large multiple of the pattern-cardinality vector makes those coordinates
nonnegative while shifting every column and the value by the same amount.
A proved positive, nonzero threshold then normalizes a feasible dual objective
strictly below one. Row-wise normalization supplies the cardinality identities;
the sum of all pattern values need not be one.

Perfectness supplies a primal witness of value one, so weak duality proves
one is the least attained dual value. The strict certificate proves the
converse. The ambient singular-channel result uses the existing C12 compression
bridge, including inactive outputs.

Independent finite presentations preserve the entire attained objective image,
so the same leastness characterization holds in their supplied coordinates.
-/

namespace PerfectFunctionalRepresentations.Dual

noncomputable section
attribute [local instance] Classical.propDecidable

open scoped BigOperators Matrix
open Incidence (AdmissiblePartition inputMatrix reducedMatrix)

universe u v

variable {α : Type u} [Fintype α] [Nonempty α] (D : CompressedPatternData α)

private def incidenceColumn (j : AdmissiblePartition D) : Incidence.OccurringPattern D → ℝ :=
  fun p => reducedMatrix D p j

private def incidenceHull : Set (Incidence.OccurringPattern D → ℝ) :=
  convexHull ℝ (Set.range (incidenceColumn D))

private theorem column_mem_incidenceHull (j : AdmissiblePartition D) :
    incidenceColumn D j ∈ incidenceHull D :=
  subset_convexHull ℝ _ (Set.mem_range_self j)

private theorem incidenceHull_convex : Convex ℝ (incidenceHull D) :=
  convex_convexHull ℝ _

private theorem incidenceHull_isCompact : IsCompact (incidenceHull D) :=
  (Set.finite_range _).isCompact_convexHull ℝ

private theorem incidenceHull_isClosed : IsClosed (incidenceHull D) :=
  (incidenceHull_isCompact D).isClosed

private theorem incidenceHull_nonempty [Nonempty (AdmissiblePartition D)] :
    (incidenceHull D).Nonempty :=
  ⟨incidenceColumn D (Classical.arbitrary _), column_mem_incidenceHull D _⟩

private theorem value_mem_incidenceHull_iff : D.value ∈ incidenceHull D ↔
    ∃ x, Incidence.Feasible D x := by
  change D.value ∈ convexHull ℝ (Set.range (incidenceColumn D)) ↔ _
  constructor
  · intro h
    rw [convexHull_range_eq_exists_affineCombination] at h
    obtain ⟨s, x, hn, hs, he⟩ := h
    let x' : AdmissiblePartition D → ℝ := fun j => if j ∈ s then x j else 0
    refine ⟨x', (fun j => by by_cases hj : j ∈ s <;> simp [x', hj, hn]), ?_⟩
    rw [Finset.affineCombination_eq_linear_combination _ _ _ hs] at he
    ext p
    have hp := congrFun he p
    simp only [Finset.sum_apply, Pi.smul_apply, smul_eq_mul, incidenceColumn] at hp
    simpa [Matrix.mulVec, dotProduct, x', mul_ite, mul_comm] using hp
  · rintro ⟨x, hn, he⟩
    refine mem_convexHull_of_exists_fintype x (incidenceColumn D) hn
      (Incidence.sum_eq_one_of_reduced_eq D x he) (fun j => Set.mem_range_self j) ?_
    ext p
    simpa [incidenceColumn, Matrix.mulVec, dotProduct, mul_comm] using congrFun he p

private theorem separating_coordinates (h : D.value ∉ incidenceHull D) :
    ∃ (w : Incidence.OccurringPattern D → ℝ) (c : ℝ),
      w ⬝ᵥ D.value < c ∧ ∀ j, c < w ⬝ᵥ incidenceColumn D j := by
  obtain ⟨f, c, hv, hc⟩ := geometric_hahn_banach_point_closed
    (incidenceHull_convex D) (incidenceHull_isClosed D) h
  let w := (dotProductEquiv ℝ (Incidence.OccurringPattern D)).symm f.toLinearMap
  have hw (z : Incidence.OccurringPattern D → ℝ) : w ⬝ᵥ z = f z := by
    exact congrArg (fun g : Module.Dual ℝ (Incidence.OccurringPattern D → ℝ) => g z)
      ((dotProductEquiv ℝ (Incidence.OccurringPattern D)).apply_symm_apply f.toLinearMap)
  refine ⟨w, c, ?_, fun j => ?_⟩
  · simpa only [hw] using hv
  · simpa only [hw] using hc _ (column_mem_incidenceHull D j)

private def patternCard (p : Incidence.OccurringPattern D) : ℝ := p.val.val.card

private theorem patternCard_one_le (p : Incidence.OccurringPattern D) :
    1 ≤ patternCard D p := by
  unfold patternCard
  exact_mod_cast Nat.succ_le_of_lt (Finset.card_pos.mpr p.val.property)

private theorem sum_inputMatrix_eq_patternCard (p : Incidence.OccurringPattern D) :
    ∑ i : α, inputMatrix D i p = patternCard D p := by
  simp [Incidence.inputMatrix_apply, patternCard]

private theorem patternCard_dot_value : patternCard D ⬝ᵥ D.value = (Fintype.card α : ℝ) := by
  calc
    _ = ∑ p, (∑ i, inputMatrix D i p) * D.value p := by
      simp only [dotProduct, sum_inputMatrix_eq_patternCard]
    _ = ∑ i : α, (inputMatrix D *ᵥ D.value) i := by
      simp only [Matrix.mulVec, dotProduct, Finset.sum_mul]
      exact Finset.sum_comm
    _ = Fintype.card α := by rw [Incidence.inputMatrix_mulVec_value]; simp

private theorem patternCard_dot_column (j : AdmissiblePartition D) :
    patternCard D ⬝ᵥ incidenceColumn D j = (Fintype.card α : ℝ) := by
  calc
    _ = ∑ p, (∑ i, inputMatrix D i p) * reducedMatrix D p j := by
      simp only [dotProduct, incidenceColumn, sum_inputMatrix_eq_patternCard]
    _ = ∑ i : α, (inputMatrix D * reducedMatrix D) i j := by
      simp only [Matrix.mul_apply, Finset.sum_mul]
      exact Finset.sum_comm
    _ = Fintype.card α := by rw [Incidence.inputMatrix_mul_reducedMatrix]; simp

private theorem inputCard_one_le : (1 : ℝ) ≤ Fintype.card α := by
  exact_mod_cast Fintype.card_pos_iff.mpr (inferInstance : Nonempty α)

private def correctionScale (w : Incidence.OccurringPattern D → ℝ) (c : ℝ) : ℝ :=
  (∑ p, |w p|) + |c| + 1

private def correctedVector (w : Incidence.OccurringPattern D → ℝ) (c : ℝ) :
    Incidence.OccurringPattern D → ℝ := w + correctionScale D w c • patternCard D

private def correctedThreshold (w : Incidence.OccurringPattern D → ℝ) (c : ℝ) : ℝ :=
  c + correctionScale D w c * (Fintype.card α : ℝ)

private theorem correction_signs (w : Incidence.OccurringPattern D → ℝ) (c : ℝ) :
    (∀ p, 0 ≤ correctedVector D w c p) ∧ 0 < correctedThreshold D w c := by
  let s : ℝ := ∑ p, |w p|
  let t := correctionScale D w c
  have hs : 0 ≤ s := Finset.sum_nonneg (fun _ _ => abs_nonneg _)
  have ht : 0 < t := by change 0 < s + |c| + 1; positivity
  have hc : |c| < t := by change |c| < s + |c| + 1; linarith
  refine ⟨fun p => ?_, ?_⟩
  · change 0 ≤ w p + t * patternCard D p
    have hw : |w p| ≤ s := Finset.single_le_sum (f := fun r => |w r|)
      (fun _ _ => abs_nonneg _) (Finset.mem_univ p)
    have hwp := neg_abs_le (w p)
    have hmul : t ≤ t * patternCard D p := by
      simpa only [mul_one] using
        mul_le_mul_of_nonneg_left (patternCard_one_le D p) ht.le
    have hwt : |w p| < t := by change |w p| < s + |c| + 1; linarith [abs_nonneg c]
    linarith
  · change 0 < c + t * (Fintype.card α : ℝ)
    have hcneg := neg_abs_le c
    have hmul : t ≤ t * (Fintype.card α : ℝ) := by
      simpa only [mul_one] using
        mul_le_mul_of_nonneg_left (inputCard_one_le (α := α)) ht.le
    linarith

private theorem corrected_gaps (w : Incidence.OccurringPattern D → ℝ) (c : ℝ)
    (hv : w ⬝ᵥ D.value < c) (hc : ∀ j, c < w ⬝ᵥ incidenceColumn D j) :
    correctedVector D w c ⬝ᵥ D.value < correctedThreshold D w c ∧
      ∀ j, correctedThreshold D w c < correctedVector D w c ⬝ᵥ incidenceColumn D j := by
  constructor
  · simp only [correctedVector, correctedThreshold, add_dotProduct, smul_dotProduct,
      smul_eq_mul, patternCard_dot_value]
    linarith
  · intro j
    simp only [correctedVector, correctedThreshold, add_dotProduct, smul_dotProduct,
      smul_eq_mul, patternCard_dot_column]
    have hj := hc j
    linarith

private theorem transpose_mulVec_div (a : Incidence.OccurringPattern D → ℝ) (b : ℝ)
    (j : AdmissiblePartition D) :
    ((reducedMatrix D)ᵀ *ᵥ (fun p => a p / b)) j = (a ⬝ᵥ incidenceColumn D j) / b := by
  change (∑ p, reducedMatrix D p j * (a p / b)) =
    (∑ p, a p * reducedMatrix D p j) / b
  rw [Finset.sum_div]
  apply Finset.sum_congr rfl
  intro p _
  ring

private theorem objective_div (a : Incidence.OccurringPattern D → ℝ) (b : ℝ) :
    objective D (fun p => a p / b) = (a ⬝ᵥ D.value) / b := by
  change (∑ p, D.value p * (a p / b)) = (∑ p, a p * D.value p) / b
  rw [Finset.sum_div]
  apply Finset.sum_congr rfl
  intro p _
  ring

private theorem normalized_certificate (w : Incidence.OccurringPattern D → ℝ) (c : ℝ)
    (hv : w ⬝ᵥ D.value < c) (hc : ∀ j, c < w ⬝ᵥ incidenceColumn D j) :
    ∃ y, Feasible D y ∧ objective D y < 1 := by
  let a := correctedVector D w c
  let b := correctedThreshold D w c
  obtain ⟨ha, hb⟩ := correction_signs D w c
  obtain ⟨hav, hac⟩ := corrected_gaps D w c hv hc
  have hb0 : b ≠ 0 := ne_of_gt hb
  have hstrict (j : AdmissiblePartition D) :
      1 < ((reducedMatrix D)ᵀ *ᵥ (fun p => a p / b)) j := by
    calc
      1 = b / b := (div_self hb0).symm
      _ < (a ⬝ᵥ incidenceColumn D j) / b := div_lt_div_of_pos_right (hac j) hb
      _ = ((reducedMatrix D)ᵀ *ᵥ (fun p => a p / b)) j := (transpose_mulVec_div D a b j).symm
  refine ⟨fun p => a p / b, ⟨fun p => div_nonneg (ha p) hb.le, fun j => (hstrict j).le⟩, ?_⟩
  rw [objective_div]
  exact (div_lt_one hb).mpr hav

/-- Every nonperfect valid compressed datum admits a dual-feasible objective strictly below one. -/
theorem exists_feasible_objective_lt_one_of_not_perfect
    (h : ¬ IsPerfectlyRepresentableChannel D.channel) :
    ∃ y, Feasible D y ∧ objective D y < 1 := by
  rcases isEmpty_or_nonempty (AdmissiblePartition D) with he | hn
  · let : IsEmpty (AdmissiblePartition D) := he
    refine ⟨fun _ => 0, feasible_zero_of_isEmpty D, ?_⟩
    rw [objective_zero]
    exact zero_lt_one
  · let : Nonempty (AdmissiblePartition D) := hn
    -- The separation interface does not require nonemptiness; this branch proves it explicitly.
    have _hHull := incidenceHull_nonempty D
    have hv : D.value ∉ incidenceHull D := by
      intro hm
      apply h
      exact (Incidence.isPerfectlyRepresentableChannel_iff_exists_feasible D).mpr
        ((value_mem_incidenceHull_iff D).mp hm)
    obtain ⟨w, c, hw, hc⟩ := separating_coordinates D hv
    exact normalized_certificate D w c hw hc

/-- Valid compressed data are perfect exactly when one is their least attained dual value.
Membership comes from a row witness; perfectness supplies the universal lower bound. -/
theorem isPerfectlyRepresentableChannel_iff_isLeast :
    IsPerfectlyRepresentableChannel D.channel ↔ IsLeast (objectiveValues D) 1 := by
  constructor
  · intro hD
    obtain ⟨x, hx, ho⟩ :=
      (Primal.isPerfectlyRepresentableChannel_iff_exists_objective_eq_one D).mp hD
    refine ⟨one_mem_objectiveValues D, ?_⟩
    rintro r ⟨y, hy, rfl⟩
    have hxy := weak_duality D hx hy
    rw [ho] at hxy
    exact hxy
  · intro hleast
    by_contra hD
    obtain ⟨y, hy, ho⟩ := exists_feasible_objective_lt_one_of_not_perfect D hD
    exact (not_lt_of_ge (hleast.2 ⟨y, hy, rfl⟩)) ho

/-- A finite ambient singular channel is perfect exactly when one is the least attained
dual value of its intrinsic compressed data. Inactive outputs use the C12 bridge. -/
theorem isPerfectlyRepresentableChannel_iff_isLeast_compressedPatternData
    {β : Type v} [Finite β] (κ : α → PMF β) (hκ : IsSingularChannel κ) :
    IsPerfectlyRepresentableChannel κ ↔
      IsLeast (objectiveValues (compressedPatternData κ hκ)) 1 :=
  (isPerfectlyRepresentableChannel_iff_compressedPatternData κ hκ).trans
    (isPerfectlyRepresentableChannel_iff_isLeast _)

/-- Independent finite row and column presentations preserve the data leastness
characterization through equality of the entire attained objective image. -/
theorem isPerfectlyRepresentableChannel_iff_isLeast_reindex {m n : ℕ}
    (rows : Incidence.OccurringPattern D ≃ Fin m)
    (cols : AdmissiblePartition D ≃ Fin n) :
    IsPerfectlyRepresentableChannel D.channel ↔
      IsLeast ((fun z : Fin m → ℝ => (D.value ∘ rows.symm) ⬝ᵥ z) ''
        {z | (∀ i, 0 ≤ z i) ∧
          ∀ j, 1 ≤ ((Matrix.reindex rows cols (reducedMatrix D))ᵀ *ᵥ z) j}) 1 := by
  rw [objectiveValues_reindex]
  exact isPerfectlyRepresentableChannel_iff_isLeast D

/-- The finite singular-channel dual corollary in supplied reduced coordinates.
Inactive ambient outputs and empty admissible-partition presentations are retained. -/
theorem isPerfectlyRepresentableChannel_iff_isLeast_compressedPatternData_reindex
    {β : Type v} [Finite β] (κ : α → PMF β) (hκ : IsSingularChannel κ) {m n : ℕ}
    (rows : Incidence.OccurringPattern (compressedPatternData κ hκ) ≃ Fin m)
    (cols : AdmissiblePartition (compressedPatternData κ hκ) ≃ Fin n) :
    IsPerfectlyRepresentableChannel κ ↔
      IsLeast ((fun z : Fin m → ℝ =>
          ((compressedPatternData κ hκ).value ∘ rows.symm) ⬝ᵥ z) ''
        {z | (∀ i, 0 ≤ z i) ∧
          ∀ j, 1 ≤ ((Matrix.reindex rows cols
            (reducedMatrix (compressedPatternData κ hκ)))ᵀ *ᵥ z) j}) 1 := by
  rw [objectiveValues_reindex]
  exact isPerfectlyRepresentableChannel_iff_isLeast_compressedPatternData κ hκ

end

end PerfectFunctionalRepresentations.Dual
