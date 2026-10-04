import PerfectFunctionalRepresentations.Optimization.IncidenceConstruction

/-!
# Reduced primal feasibility and perfectness

The primal in ISIT Theorem 2/(18) uses nonnegative coefficients and a
coordinatewise incidence inequality. Its coordinates are C13's occurring
patterns and admissible exact partitions of valid C12 compressed data.
The admissible-partition family may be empty.

Pattern values are normalized per input. The identities `P H = 1` and
`P v = 1` therefore bound every feasible coefficient sum by one, as in
extended-version Appendix B (206)-(214). Input nonemptiness is explicit.
`Primal.Feasible` is separate from C13's nonnegative equality predicate.

At objective one, every input-row slack sum vanishes. Each occurring pattern
contains an input, so nonnegative slack vanishes in every coordinate. This
recovers equality feasibility and C13's perfectness characterization. Greatestness
includes an attaining vector; no general optimizer-existence theorem is used.
-/

namespace PerfectFunctionalRepresentations.Primal

noncomputable section
attribute [local instance] Classical.propDecidable

open scoped BigOperators Matrix
open Incidence (AdmissiblePartition inputMatrix reducedMatrix)

universe u v

variable {α : Type u} [Fintype α] [Nonempty α] (D : CompressedPatternData α)

/-- Nonnegative coefficients whose reduced incidence image is bounded by the data. -/
def Feasible (x : AdmissiblePartition D → ℝ) : Prop :=
  (∀ j, 0 ≤ x j) ∧ ∀ p, (reducedMatrix D *ᵥ x) p ≤ D.value p

/-- The primal objective is the sum of all admissible-partition coefficients. -/
def objective (x : AdmissiblePartition D → ℝ) : ℝ := ∑ j, x j

/-- All reduced primal-feasible coefficient vectors. -/
def feasibleSet : Set (AdmissiblePartition D → ℝ) := {x | Feasible D x}

/-- Values actually attained by the primal objective on feasible vectors. -/
def objectiveValues : Set ℝ := objective D '' feasibleSet D

/-- Zero is primal feasible, even when no admissible partition exists. -/
theorem feasible_zero : Feasible D (fun _ => 0) := by
  refine ⟨fun _ => le_rfl, fun p => ?_⟩
  simpa only [Matrix.mulVec, dotProduct, mul_zero, Finset.sum_const_zero]
    using (D.value_pos p).le

@[simp]
theorem objective_zero : objective D (fun _ => 0) = 0 := by
  simp [objective]

/-- A feasible objective is nonnegative by coefficient nonnegativity. -/
theorem objective_nonneg {x : AdmissiblePartition D → ℝ} (hx : Feasible D x) :
    0 ≤ objective D x :=
  Finset.sum_nonneg (fun j _ => hx.1 j)

-- The same identity will support saturation; it uses arbitrary real coefficients.
private theorem inputMatrix_mulVec_slack (x : AdmissiblePartition D → ℝ) :
    inputMatrix D *ᵥ (D.value - reducedMatrix D *ᵥ x) =
      (fun _ => 1 - objective D x) := by
  rw [Matrix.mulVec_sub, Incidence.inputMatrix_mulVec_value,
    Matrix.mulVec_mulVec, Incidence.inputMatrix_mul_reducedMatrix]
  ext i
  simp only [Pi.sub_apply, Matrix.mulVec, dotProduct, one_mul, objective]

/-- Every primal-feasible objective is at most one, using per-input normalization. -/
theorem objective_le_one {x : AdmissiblePartition D → ℝ} (hx : Feasible D x) :
    objective D x ≤ 1 := by
  have hs (i : α) : 0 ≤ (inputMatrix D *ᵥ (D.value - reducedMatrix D *ᵥ x)) i :=
    Finset.sum_nonneg (fun p _ =>
      mul_nonneg (Incidence.inputMatrix_nonneg D i p) (sub_nonneg.mpr (hx.2 p)))
  rw [inputMatrix_mulVec_slack] at hs
  exact sub_nonneg.mp (hs (Classical.arbitrary α))

/-- A feasible vector attains one exactly when every incidence inequality is tight. -/
theorem objective_eq_one_iff {x : AdmissiblePartition D → ℝ} (hx : Feasible D x) :
    objective D x = 1 ↔ reducedMatrix D *ᵥ x = D.value := by
  constructor
  · intro ho
    have hs (i : α) :
        (inputMatrix D *ᵥ (D.value - reducedMatrix D *ᵥ x)) i = 0 := by
      rw [inputMatrix_mulVec_slack, ho, sub_self]
    funext p
    obtain ⟨i, hi⟩ := p.val.property
    have hp := Finset.single_le_sum
      (f := fun q => inputMatrix D i q * (D.value q - (reducedMatrix D *ᵥ x) q))
      (fun q _ => mul_nonneg (Incidence.inputMatrix_nonneg D i q)
        (sub_nonneg.mpr (hx.2 q))) (Finset.mem_univ p)
    change inputMatrix D i p * (D.value p - (reducedMatrix D *ᵥ x) p) ≤
      (inputMatrix D *ᵥ (D.value - reducedMatrix D *ᵥ x)) i at hp
    rw [hs, Incidence.inputMatrix_apply, if_pos hi, one_mul] at hp
    exact le_antisymm (hx.2 p) (sub_nonpos.mp hp)
  · exact Incidence.sum_eq_one_of_reduced_eq D x

/-- Equality feasibility is precisely primal feasibility with objective one,
for the same coefficient vector, including its zero coordinates. -/
theorem equality_feasible_iff {x : AdmissiblePartition D → ℝ} :
    Incidence.Feasible D x ↔ Feasible D x ∧ objective D x = 1 := by
  constructor
  · rintro ⟨hn, he⟩
    refine ⟨⟨hn, fun p => (congrFun he p).le⟩, ?_⟩
    exact Incidence.sum_eq_one_of_reduced_eq D x he
  · rintro ⟨hx, ho⟩
    exact ⟨hx.1, (objective_eq_one_iff D hx).mp ho⟩

/-- Perfectness is equivalent to an actual feasible vector attaining one. -/
theorem isPerfectlyRepresentableChannel_iff_exists_objective_eq_one :
    IsPerfectlyRepresentableChannel D.channel ↔
      ∃ x, Feasible D x ∧ objective D x = 1 := by
  rw [Incidence.isPerfectlyRepresentableChannel_iff_exists_feasible]
  exact exists_congr (fun _ => equality_feasible_iff D)

/-- The reduced primal has attained greatest value one exactly for perfect data. -/
theorem isPerfectlyRepresentableChannel_iff_isGreatest :
    IsPerfectlyRepresentableChannel D.channel ↔ IsGreatest (objectiveValues D) 1 := by
  rw [isPerfectlyRepresentableChannel_iff_exists_objective_eq_one]
  constructor
  · rintro ⟨x, hx, ho⟩
    refine ⟨⟨x, hx, ho⟩, ?_⟩
    rintro r ⟨y, hy, rfl⟩
    exact objective_le_one D hy
  · rintro ⟨⟨x, hx, ho⟩, _⟩
    exact ⟨x, hx, ho⟩

/-- A finite ambient singular channel is perfect exactly when its compressed
primal admits a vector attaining one. Inactive outputs use the C12 bridge. -/
theorem isPerfectlyRepresentableChannel_iff_exists_objective_eq_one_compressedPatternData
    {β : Type v} [Finite β] (κ : α → PMF β) (hκ : IsSingularChannel κ) :
    IsPerfectlyRepresentableChannel κ ↔
      ∃ x, Feasible (compressedPatternData κ hκ) x ∧
        objective (compressedPatternData κ hκ) x = 1 :=
  (isPerfectlyRepresentableChannel_iff_compressedPatternData κ hκ).trans
    (isPerfectlyRepresentableChannel_iff_exists_objective_eq_one _)

/-- The finite ambient singular-channel primal has attained greatest value one
exactly when the original channel is perfectly representable. -/
theorem isPerfectlyRepresentableChannel_iff_isGreatest_compressedPatternData
    {β : Type v} [Finite β] (κ : α → PMF β) (hκ : IsSingularChannel κ) :
    IsPerfectlyRepresentableChannel κ ↔
      IsGreatest (objectiveValues (compressedPatternData κ hκ)) 1 :=
  (isPerfectlyRepresentableChannel_iff_compressedPatternData κ hκ).trans
    (isPerfectlyRepresentableChannel_iff_isGreatest _)

/-- Independent finite row and column presentations preserve primal feasibility,
with pointwise inequalities and inverse coordinate transport. -/
theorem feasible_reindex_iff (x : AdmissiblePartition D → ℝ) {m n : ℕ}
    (rows : Incidence.OccurringPattern D ≃ Fin m)
    (cols : AdmissiblePartition D ≃ Fin n) :
    Feasible D x ↔ ((∀ j, 0 ≤ (x ∘ cols.symm) j) ∧
      ∀ i, (Matrix.reindex rows cols (reducedMatrix D) *ᵥ (x ∘ cols.symm)) i ≤
        (D.value ∘ rows.symm) i) := by
  rw [Incidence.reindex_mulVec]
  constructor
  · rintro ⟨hn, hi⟩
    exact ⟨fun j => hn (cols.symm j), fun i => hi (rows.symm i)⟩
  · rintro ⟨hn, hi⟩
    constructor
    · intro j
      simpa only [Function.comp_apply, Equiv.symm_apply_apply] using hn (cols j)
    · intro p
      simpa only [Function.comp_apply, Equiv.symm_apply_apply] using hi (rows p)

/-- The entire finite-coordinate objective image equals the intrinsic image.
The inverse vector map covers every finite vector, including empty columns. -/
theorem objectiveValues_reindex {m n : ℕ}
    (rows : Incidence.OccurringPattern D ≃ Fin m)
    (cols : AdmissiblePartition D ≃ Fin n) :
    (fun z : Fin n → ℝ => ∑ j, z j) ''
      {z | (∀ j, 0 ≤ z j) ∧
        ∀ i, (Matrix.reindex rows cols (reducedMatrix D) *ᵥ z) i ≤
          (D.value ∘ rows.symm) i} = objectiveValues D := by
  ext r
  constructor
  · rintro ⟨z, hz, rfl⟩
    change (∀ j, 0 ≤ z j) ∧
      (∀ i, (Matrix.reindex rows cols (reducedMatrix D) *ᵥ z) i ≤
        (D.value ∘ rows.symm) i) at hz
    refine ⟨z ∘ cols, (feasible_reindex_iff D (z ∘ cols) rows cols).mpr ?_, ?_⟩
    · simpa only [Function.comp_def, Equiv.apply_symm_apply] using hz
    · exact cols.sum_comp z
  · rintro ⟨x, hx, rfl⟩
    exact ⟨x ∘ cols.symm, (feasible_reindex_iff D x rows cols).mp hx,
      cols.symm.sum_comp x⟩

end

end PerfectFunctionalRepresentations.Primal
