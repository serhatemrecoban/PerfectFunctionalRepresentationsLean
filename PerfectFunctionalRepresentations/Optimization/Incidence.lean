import PerfectFunctionalRepresentations.Matrix.PatternCompression
import PerfectFunctionalRepresentations.Matrix.Partitions
import Mathlib.Data.Fintype.Powerset
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Data.Matrix.Mul
import Mathlib.LinearAlgebra.Matrix.Defs

/-!
# Exact partitions and pattern incidence

The intrinsic full system has every nonempty input pattern as a row and every
exact partition as a column. The reduced system restricts both indices to the
occurring patterns of valid C12 data and partitions using only those patterns.
Admissible partitions may be absent; their type has no nonemptiness assumption.

This module supplies the finite coordinates of ISIT Section IV-A, interpreted
using extended-version (33)-(56)'s separate full/reduced systems. In particular,
dropping absent rows while retaining all partition columns is not the reduced
system. Pattern values are normalized per input, not by a sum over all patterns.

As in the C10 partition adapter, classical decidability is fixed locally before
partition-typed declarations. Arbitrary enumerations are supplied explicitly.
Nonnegative equality feasibility is equivalent in the two systems by restriction
and zero extension. Equality gives total weight one; nonnegative solutions have
incidence bounds and normalized positive support covering every occurring pattern.
No feasible weights, perfectness or optimization hypothesis is part of the data.
Public perfectness supplies nonnegative reduced and full witnesses by aggregating
supported decoder probabilities over their admissible exact partitions.
-/

namespace PerfectFunctionalRepresentations.Incidence

noncomputable section
attribute [local instance] Classical.propDecidable

open scoped BigOperators Matrix

universe u v w

/-- All nonempty input patterns, including those absent from a particular channel. -/
abbrev NonzeroPattern (α : Type u) := {s : Finset α // s.Nonempty}

/-- Exact partitions of the whole finite input alphabet. -/
abbrev ExactPartition (α : Type u) [Fintype α] :=
  Finpartition (Finset.univ : Finset α)

variable {α : Type u} [Fintype α]

/-- There are exactly `2^k - 1` nonempty input patterns. -/
theorem card_nonzeroPattern :
    Fintype.card (NonzeroPattern α) = 2 ^ Fintype.card α - 1 := by
  let e : NonzeroPattern α ≃ {s : Finset α // ¬s = ∅} :=
    Equiv.subtypeEquivRight (fun _ => Finset.nonempty_iff_ne_empty)
  rw [Fintype.card_congr e, Fintype.card_subtype_compl,
    Fintype.card_subtype_eq, Fintype.card_finset]

/-- Exactly one block of an exact partition contains each input. -/
theorem exactPartition_indicator_sum (π : ExactPartition α) (x : α) :
    ∑ b : π.parts, (if x ∈ b.val then (1 : ℝ) else 0) = 1 := by
  have hu : ∃! b : π.parts, x ∈ b.val := by
    obtain ⟨b, ⟨hb,hxb⟩, hunique⟩ := π.existsUnique_mem (Finset.mem_univ x)
    refine ⟨⟨b,hb⟩,hxb,?_⟩
    intro c hc
    exact Subtype.ext (hunique c.val ⟨c.property,hc⟩)
  have hc : (Finset.univ.filter (fun b : π.parts => x ∈ b.val)).card = 1 := by
    apply Finset.card_eq_one_iff_existsUnique.mpr
    simpa only [Finset.mem_filter, Finset.mem_univ, true_and] using hu
  simp only [Finset.sum_boole, hc, Nat.cast_one]

omit [Fintype α] in
private theorem indicator_unique (S : Finset (NonzeroPattern α))
    (h : ∀ x, ∑ p : ↥S, (if x ∈ p.val.val then (1 : ℝ) else 0) = 1)
    (x : α) : ∃! p : ↥S, x ∈ p.val.val := by
  have hx := h x
  rw [Finset.sum_boole] at hx
  have hc : (Finset.univ.filter (fun p : ↥S => x ∈ p.val.val)).card = 1 := by
    exact_mod_cast hx
  simpa only [Finset.mem_filter, Finset.mem_univ, true_and] using
    (Finset.card_eq_one_iff_existsUnique.mp hc)

omit [Fintype α] in
private theorem indicator_disjoint (S : Finset (NonzeroPattern α))
    (h : ∀ x, ∑ p : ↥S, (if x ∈ p.val.val then (1 : ℝ) else 0) = 1) :
    Pairwise (fun p q : ↥S => Disjoint p.val.val q.val.val) := by
  intro p q hpq
  apply Finset.disjoint_left.mpr
  intro x hxp hxq
  obtain ⟨b, _, hb⟩ := indicator_unique S h x
  exact hpq ((hb p hxp).trans (hb q hxq).symm)

private theorem indicator_cover (S : Finset (NonzeroPattern α))
    (h : ∀ x, ∑ p : ↥S, (if x ∈ p.val.val then (1 : ℝ) else 0) = 1) :
    ∀ x, x ∈ (Finset.univ : Finset α) ↔ ∃ p : ↥S, x ∈ p.val.val := by
  intro x
  constructor
  · intro _
    obtain ⟨p,hp,_⟩ := indicator_unique S h x
    exact ⟨p,hp⟩
  · intro _
    exact Finset.mem_univ x

private def partitionFromIndicators (S : Finset (NonzeroPattern α))
    (h : ∀ x, ∑ p : ↥S, (if x ∈ p.val.val then (1 : ℝ) else 0) = 1) :
    ExactPartition α :=
  partitionOfBlocks Finset.univ (fun p : ↥S => p.val.val)
    (fun p => p.val.property) (indicator_disjoint S h) (indicator_cover S h)

private def partitionFromIndicatorsEquiv (S : Finset (NonzeroPattern α))
    (h : ∀ x, ∑ p : ↥S, (if x ∈ p.val.val then (1 : ℝ) else 0) = 1) :
    ↥S ≃ (partitionFromIndicators S h).parts :=
  partitionOfBlocksEquiv Finset.univ (fun p : ↥S => p.val.val)
    (fun p => p.val.property) (indicator_disjoint S h) (indicator_cover S h)

/-- Indicator rows summing to one give an exact partition with a complete
supplied-pattern-to-block equivalence, via the C10 adapter. -/
theorem exists_exactPartition_of_indicator_sum (S : Finset (NonzeroPattern α))
    (h : ∀ x, ∑ p : ↥S, (if x ∈ p.val.val then (1 : ℝ) else 0) = 1) :
    ∃ π : ExactPartition α, ∃ e : ↥S ≃ π.parts, ∀ p, (e p).val = p.val.val := by
  refine ⟨partitionFromIndicators S h, partitionFromIndicatorsEquiv S h, ?_⟩
  intro p
  rfl


/-- The full pattern/partition incidence matrix. -/
def fullMatrix : Matrix (NonzeroPattern α) (ExactPartition α) ℝ :=
  fun p π => if p.val ∈ π.parts then 1 else 0

/-- Incidence of inputs in all nonempty patterns. -/
def fullInputMatrix : Matrix α (NonzeroPattern α) ℝ :=
  fun x p => if x ∈ p.val then 1 else 0

theorem fullMatrix_apply (p : NonzeroPattern α) (π : ExactPartition α) :
    fullMatrix p π = if p.val ∈ π.parts then 1 else 0 := rfl

omit [Fintype α] in
theorem fullInputMatrix_apply (x : α) (p : NonzeroPattern α) :
    fullInputMatrix x p = if x ∈ p.val then 1 else 0 := rfl

theorem fullMatrix_nonneg (p : NonzeroPattern α) (π : ExactPartition α) :
    0 ≤ fullMatrix p π := by
  simp only [fullMatrix]
  split_ifs <;> norm_num

omit [Fintype α] in
theorem fullInputMatrix_nonneg (x : α) (p : NonzeroPattern α) :
    0 ≤ fullInputMatrix x p := by
  simp only [fullInputMatrix]
  split_ifs <;> norm_num

section Data

variable [Nonempty α] (D : CompressedPatternData α)

/-- The distinct patterns actually occurring in the compressed data. -/
abbrev OccurringPattern := ↥D.patterns

/-- A partition is admissible exactly when every one of its blocks occurs. -/
def IsAdmissible (π : ExactPartition α) : Prop :=
  ∀ b : π.parts,
    (⟨b.val, π.nonempty_of_mem_parts b.property⟩ : NonzeroPattern α) ∈ D.patterns

/-- The possibly empty family of exact partitions using occurring patterns. -/
abbrev AdmissiblePartition := {π : ExactPartition α // IsAdmissible D π}

/-- Reduced incidence restricts both full indices. -/
def reducedMatrix : Matrix (OccurringPattern D) (AdmissiblePartition D) ℝ :=
  fun p π => fullMatrix p.val π.val

/-- Input incidence on the occurring patterns. -/
def inputMatrix : Matrix α (OccurringPattern D) ℝ :=
  fun x p => fullInputMatrix x p.val

/-- Absent full-pattern rows have value zero. -/
def fullValue (p : NonzeroPattern α) : ℝ :=
  if h : p ∈ D.patterns then D.value ⟨p, h⟩ else 0

theorem reducedMatrix_apply (p : OccurringPattern D) (π : AdmissiblePartition D) :
    reducedMatrix D p π = if p.val.val ∈ π.val.parts then 1 else 0 := rfl

theorem inputMatrix_apply (x : α) (p : OccurringPattern D) :
    inputMatrix D x p = if x ∈ p.val.val then 1 else 0 := rfl

theorem reducedMatrix_eq_full (p : OccurringPattern D) (π : AdmissiblePartition D) :
    reducedMatrix D p π = fullMatrix p.val π.val := rfl

theorem inputMatrix_eq_full (x : α) (p : OccurringPattern D) :
    inputMatrix D x p = fullInputMatrix x p.val := rfl

theorem reducedMatrix_nonneg (p : OccurringPattern D) (π : AdmissiblePartition D) :
    0 ≤ reducedMatrix D p π := fullMatrix_nonneg p.val π.val

theorem inputMatrix_nonneg (x : α) (p : OccurringPattern D) :
    0 ≤ inputMatrix D x p := fullInputMatrix_nonneg x p.val

@[simp]
theorem fullValue_of_mem (p : NonzeroPattern α) (h : p ∈ D.patterns) :
    fullValue D p = D.value ⟨p, h⟩ := dif_pos h

@[simp]
theorem fullValue_of_not_mem (p : NonzeroPattern α) (h : p ∉ D.patterns) :
    fullValue D p = 0 := dif_neg h

theorem fullValue_nonneg (p : NonzeroPattern α) : 0 ≤ fullValue D p := by
  unfold fullValue
  split_ifs with h
  · exact le_of_lt (D.value_pos ⟨p, h⟩)
  · exact le_rfl

theorem card_occurringPattern : Fintype.card (OccurringPattern D) = D.patterns.card := by
  exact Fintype.card_coe _

/-- Distinct occurring patterns fit in the full nonempty-pattern universe. -/
theorem patterns_card_le : D.patterns.card ≤ 2 ^ Fintype.card α - 1 := by
  calc
    D.patterns.card = Fintype.card (OccurringPattern D) := (card_occurringPattern D).symm
    _ ≤ Fintype.card (NonzeroPattern α) :=
      Fintype.card_le_of_injective (fun p : OccurringPattern D => p.val) Subtype.val_injective
    _ = 2 ^ Fintype.card α - 1 := card_nonzeroPattern

/-- Reduction cannot add partition columns; this includes an empty reduced index. -/
theorem card_admissiblePartition_le :
    Fintype.card (AdmissiblePartition D) ≤ Fintype.card (ExactPartition α) :=
  Fintype.card_le_of_injective (fun π : AdmissiblePartition D => π.val)
    Subtype.val_injective

end Data

section Presentation

variable {I : Type v} {J : Type w} [Fintype J] {m n : ℕ}

/-- Reindexing transports matrix-vector multiplication for arbitrary real weights. -/
theorem reindex_mulVec (M : Matrix I J ℝ) (weight : J → ℝ)
    (rows : I ≃ Fin m) (cols : J ≃ Fin n) :
    Matrix.reindex rows cols M *ᵥ (weight ∘ cols.symm) =
      (M *ᵥ weight) ∘ rows.symm := by
  simpa only [Matrix.reindex_apply, Function.comp_def, Equiv.symm_symm,
    Equiv.symm_apply_apply] using
    Matrix.submatrix_mulVec_equiv M (weight ∘ cols.symm) rows.symm cols.symm

/-- Supplied row and column enumerations preserve both the vector equation and
coefficient nonnegativity. This applies to either incidence system and to input
incidence, including zero columns; it makes no feasibility assertion. -/
theorem system_reindex_iff (M : Matrix I J ℝ) (value : I → ℝ) (weight : J → ℝ)
    (rows : I ≃ Fin m) (cols : J ≃ Fin n) :
    ((∀ j, 0 ≤ (weight ∘ cols.symm) j) ∧
      Matrix.reindex rows cols M *ᵥ (weight ∘ cols.symm) = value ∘ rows.symm) ↔
    ((∀ j, 0 ≤ weight j) ∧ M *ᵥ weight = value) := by
  rw [reindex_mulVec]
  constructor
  · rintro ⟨hn, he⟩
    refine ⟨fun j => ?_, funext fun i => ?_⟩
    · simpa only [Function.comp_apply, Equiv.symm_apply_apply] using hn (cols j)
    · simpa only [Function.comp_apply, Equiv.symm_apply_apply] using congrFun he (rows i)
  · rintro ⟨hn, he⟩
    exact ⟨fun j => hn (cols.symm j), congrArg (fun f => f ∘ rows.symm) he⟩

end Presentation

/-! ## Structural identities and coefficient consequences

Input incidence turns the pattern equations into row normalization. The
matrix identities have rectangular all-ones right sides, including empty
admissible columns. Equality alone normalizes weights; bounds require
nonnegativity.
-/

theorem fullInputMatrix_mul_fullMatrix :
    (fullInputMatrix : Matrix α (NonzeroPattern α) ℝ) *
      (fullMatrix : Matrix (NonzeroPattern α) (ExactPartition α) ℝ) =
      (fun _ _ => 1) := by
  ext x π
  change (∑ p : NonzeroPattern α,
    (if x ∈ p.val then (1 : ℝ) else 0) *
      (if p.val ∈ π.parts then (1 : ℝ) else 0)) = 1
  let e : π.parts → NonzeroPattern α := fun b => ⟨b.val, π.nonempty_of_mem_parts b.property⟩
  have he : Function.Injective e := fun a b h =>
    Subtype.ext (congrArg (fun p : NonzeroPattern α => p.val) h)
  have hs := Fintype.sum_of_injective e he
    (fun b : π.parts => if x ∈ b.val then (1 : ℝ) else 0)
    (fun p : NonzeroPattern α => (if x ∈ p.val then (1 : ℝ) else 0) *
      (if p.val ∈ π.parts then (1 : ℝ) else 0))
    (by
      intro p hp
      have hn : p.val ∉ π.parts := by
        intro hm
        exact hp ⟨⟨p.val, hm⟩, Subtype.ext rfl⟩
      simp [hn])
    (by intro b; simp [e, b.property])
  rw [← hs]
  exact exactPartition_indicator_sum π x

section StructuralData
variable [Nonempty α] (D : CompressedPatternData α)

theorem inputMatrix_mulVec_value : inputMatrix D *ᵥ D.value = (fun _ => 1) := by
  funext x
  simpa only [Matrix.mulVec, dotProduct, inputMatrix_apply, ite_mul, one_mul, zero_mul]
    using D.row_sum x

theorem fullInputMatrix_mulVec_fullValue :
    fullInputMatrix *ᵥ fullValue D = (fun _ => 1) := by
  funext x
  change (∑ p : NonzeroPattern α, fullInputMatrix x p * fullValue D p) = 1
  have hs := Fintype.sum_of_injective
    (Subtype.val : OccurringPattern D → NonzeroPattern α) Subtype.val_injective
    (fun p : OccurringPattern D => inputMatrix D x p * D.value p)
    (fun p : NonzeroPattern α => fullInputMatrix x p * fullValue D p)
    (by
      intro p hp
      have hn : p ∉ D.patterns := fun hm => hp ⟨⟨p, hm⟩, rfl⟩
      simp [hn])
    (by intro p; simp [inputMatrix, p.property])
  rw [← hs]
  exact congrFun (inputMatrix_mulVec_value D) x

theorem inputMatrix_mul_reducedMatrix :
    inputMatrix D * reducedMatrix D = (fun _ _ => 1) := by
  ext x π
  change (∑ p : OccurringPattern D, inputMatrix D x p * reducedMatrix D p π) = 1
  have hs := Fintype.sum_of_injective
    (Subtype.val : OccurringPattern D → NonzeroPattern α) Subtype.val_injective
    (fun p : OccurringPattern D => inputMatrix D x p * reducedMatrix D p π)
    (fun p : NonzeroPattern α => fullInputMatrix x p * fullMatrix p π.val)
    (by
      intro p hp
      have hn : p.val ∉ π.val.parts := by
        intro hm
        have hpD : p ∈ D.patterns := π.property ⟨p.val, hm⟩
        exact hp ⟨⟨p, hpD⟩, rfl⟩
      simp [fullMatrix, hn])
    (by intro p; rfl)
  rw [hs]
  exact congrFun (congrFun fullInputMatrix_mul_fullMatrix x) π.val

theorem sum_eq_one_of_reduced_eq (w : AdmissiblePartition D → ℝ)
    (heq : reducedMatrix D *ᵥ w = D.value) : ∑ π, w π = 1 := by
  have h := congrArg (fun v => inputMatrix D *ᵥ v) heq
  rw [Matrix.mulVec_mulVec, inputMatrix_mul_reducedMatrix, inputMatrix_mulVec_value] at h
  simpa only [Matrix.mulVec, dotProduct, one_mul] using congrFun h (Classical.arbitrary α)

theorem sum_eq_one_of_full_eq (w : ExactPartition α → ℝ)
    (heq : fullMatrix *ᵥ w = fullValue D) : ∑ π, w π = 1 := by
  have h := congrArg (fun v => fullInputMatrix *ᵥ v) heq
  rw [Matrix.mulVec_mulVec, fullInputMatrix_mul_fullMatrix, fullInputMatrix_mulVec_fullValue] at h
  simpa only [Matrix.mulVec, dotProduct, one_mul] using congrFun h (Classical.arbitrary α)

theorem reduced_weight_le_value (w : AdmissiblePartition D → ℝ)
    (hn : ∀ π, 0 ≤ w π) (heq : reducedMatrix D *ᵥ w = D.value)
    (p : OccurringPattern D) (π : AdmissiblePartition D) (hp : p.val.val ∈ π.val.parts) :
    w π ≤ D.value p := by
  have hs := Finset.single_le_sum
    (f := fun q => reducedMatrix D p q * w q)
    (fun q _ => mul_nonneg (reducedMatrix_nonneg D p q) (hn q))
    (Finset.mem_univ π)
  have hr := congrFun heq p
  change (∑ q, reducedMatrix D p q * w q) = D.value p at hr
  calc
    w π = reducedMatrix D p π * w π := by simp [reducedMatrix_apply, hp]
    _ ≤ ∑ q, reducedMatrix D p q * w q := hs
    _ = D.value p := hr

theorem full_weight_le_value (w : ExactPartition α → ℝ)
    (hn : ∀ π, 0 ≤ w π) (heq : fullMatrix *ᵥ w = fullValue D)
    (p : NonzeroPattern α) (π : ExactPartition α) (hp : p.val ∈ π.parts) :
    w π ≤ fullValue D p := by
  have hs := Finset.single_le_sum
    (f := fun q => fullMatrix p q * w q)
    (fun q _ => mul_nonneg (fullMatrix_nonneg p q) (hn q))
    (Finset.mem_univ π)
  have hr := congrFun heq p
  change (∑ q, fullMatrix p q * w q) = fullValue D p at hr
  calc
    w π = fullMatrix p π * w π := by simp [fullMatrix_apply, hp]
    _ ≤ ∑ q, fullMatrix p q * w q := hs
    _ = fullValue D p := hr

theorem reduced_weight_le_one (w : AdmissiblePartition D → ℝ)
    (hn : ∀ π, 0 ≤ w π) (heq : reducedMatrix D *ᵥ w = D.value)
    (π : AdmissiblePartition D) : w π ≤ 1 := by
  rw [← sum_eq_one_of_reduced_eq D w heq]
  exact Finset.single_le_sum (fun q _ => hn q) (Finset.mem_univ π)

theorem full_weight_le_one (w : ExactPartition α → ℝ)
    (hn : ∀ π, 0 ≤ w π) (heq : fullMatrix *ᵥ w = fullValue D)
    (π : ExactPartition α) : w π ≤ 1 := by
  rw [← sum_eq_one_of_full_eq D w heq]
  exact Finset.single_le_sum (fun q _ => hn q) (Finset.mem_univ π)

theorem reduced_unit_iff (w : AdmissiblePartition D → ℝ) :
    ((∀ π, 0 ≤ w π ∧ w π ≤ 1) ∧ reducedMatrix D *ᵥ w = D.value) ↔
      ((∀ π, 0 ≤ w π) ∧ reducedMatrix D *ᵥ w = D.value) := by
  constructor
  · rintro ⟨hn, he⟩; exact ⟨fun π => (hn π).1, he⟩
  · rintro ⟨hn, he⟩; exact ⟨fun π => ⟨hn π, reduced_weight_le_one D w hn he π⟩, he⟩

theorem full_unit_iff (w : ExactPartition α → ℝ) :
    ((∀ π, 0 ≤ w π ∧ w π ≤ 1) ∧ fullMatrix *ᵥ w = fullValue D) ↔
      ((∀ π, 0 ≤ w π) ∧ fullMatrix *ᵥ w = fullValue D) := by
  constructor
  · rintro ⟨hn, he⟩; exact ⟨fun π => (hn π).1, he⟩
  · rintro ⟨hn, he⟩; exact ⟨fun π => ⟨hn π, full_weight_le_one D w hn he π⟩, he⟩

end StructuralData

section Feasibility

variable [Nonempty α]

/-- Nonnegative equality feasibility in the full coordinates. -/
def FullFeasible (D : CompressedPatternData α) (w : ExactPartition α → ℝ) : Prop :=
  (∀ π, 0 ≤ w π) ∧ fullMatrix *ᵥ w = fullValue D

/-- Nonnegative equality feasibility in the reduced coordinates. -/
def Feasible (D : CompressedPatternData α) (w : AdmissiblePartition D → ℝ) : Prop :=
  (∀ π, 0 ≤ w π) ∧ reducedMatrix D *ᵥ w = D.value

/-- Restrict a supplied full coefficient vector to admissible partitions. -/
def restrictWeights (D : CompressedPatternData α) (w : ExactPartition α → ℝ) :
    AdmissiblePartition D → ℝ := fun π => w π.val

/-- Extend reduced coefficients by zero on every inadmissible partition. -/
def extendWeights (D : CompressedPatternData α) (w : AdmissiblePartition D → ℝ) :
    ExactPartition α → ℝ := fun π => if h : IsAdmissible D π then w ⟨π,h⟩ else 0

@[simp] theorem restrict_extendWeights (D : CompressedPatternData α)
    (w : AdmissiblePartition D → ℝ) : restrictWeights D (extendWeights D w) = w := by
  funext π
  simp [restrictWeights, extendWeights, π.property]

private theorem sum_subtype_of_zero {ι : Type*} [Fintype ι]
    (P : ι → Prop) (f : ι → ℝ) (hz : ∀ i, ¬ P i → f i = 0) :
    (∑ i, f i) = ∑ i : {i // P i}, f i.val := by
  exact Finset.sum_congr_set {i | P i} f (fun i => f i.val) (fun _ _ => rfl) hz

/-- Nonnegativity prevents cancellation on a missing full row. -/
theorem full_weight_eq_zero_of_not_admissible (D : CompressedPatternData α)
    {w : ExactPartition α → ℝ} (hw : FullFeasible D w)
    (π : ExactPartition α) (hπ : ¬ IsAdmissible D π) : w π = 0 := by
  obtain ⟨b,hb⟩ := not_forall.mp hπ
  let p : NonzeroPattern α := ⟨b.val, π.nonempty_of_mem_parts b.property⟩
  have hp : p ∉ D.patterns := hb
  have hz : (∑ q, fullMatrix p q * w q) = 0 := by
    simpa only [Matrix.mulVec, dotProduct, fullValue_of_not_mem D p hp] using congrFun hw.2 p
  have ht := (Finset.sum_eq_zero_iff_of_nonneg
    (fun q _ => mul_nonneg (fullMatrix_nonneg p q) (hw.1 q))).mp hz π (Finset.mem_univ π)
  simpa [fullMatrix, p, b.property] using ht

/-- A full feasible vector is recovered after restricting and extending. -/
theorem extend_restrictWeights (D : CompressedPatternData α)
    {w : ExactPartition α → ℝ} (hw : FullFeasible D w) :
    extendWeights D (restrictWeights D w) = w := by
  funext π
  by_cases h : IsAdmissible D π
  · simp [extendWeights, restrictWeights, h]
  · simp [extendWeights, h, full_weight_eq_zero_of_not_admissible D hw π h]

/-- Restriction retains the occurring rows of a full nonnegative solution. -/
theorem feasible_restrictWeights (D : CompressedPatternData α)
    {w : ExactPartition α → ℝ} (hw : FullFeasible D w) :
    Feasible D (restrictWeights D w) := by
  refine ⟨fun π => hw.1 π.val, funext fun p => ?_⟩
  have hs := sum_subtype_of_zero (IsAdmissible D)
    (fun π => fullMatrix p.val π * w π)
    (fun π h => by rw [full_weight_eq_zero_of_not_admissible D hw π h, mul_zero])
  change (∑ π : AdmissiblePartition D, fullMatrix p.val π.val * w π.val) = D.value p
  rw [← hs]
  simpa only [Matrix.mulVec, dotProduct, fullValue_of_mem D p.val p.property] using
    congrFun hw.2 p.val

/-- Zero extension preserves every full row, including absent patterns. -/
theorem fullFeasible_extendWeights (D : CompressedPatternData α)
    {w : AdmissiblePartition D → ℝ} (hw : Feasible D w) :
    FullFeasible D (extendWeights D w) := by
  constructor
  · intro π
    unfold extendWeights
    split_ifs with h
    · exact hw.1 ⟨π,h⟩
    · exact le_rfl
  · funext p
    have hs := sum_subtype_of_zero (IsAdmissible D)
      (fun π => fullMatrix p π * extendWeights D w π)
      (fun π h => by simp [extendWeights, h])
    change (∑ π, fullMatrix p π * extendWeights D w π) = fullValue D p
    rw [hs]
    simp only [extendWeights, dif_pos (Subtype.property _)]
    by_cases hp : p ∈ D.patterns
    · simpa only [Matrix.mulVec, dotProduct, reducedMatrix, fullValue_of_mem D p hp] using
        congrFun hw.2 ⟨p,hp⟩
    · rw [fullValue_of_not_mem D p hp]
      apply Finset.sum_eq_zero
      intro π _
      have hnot : p.val ∉ π.val.parts := by
        intro hb
        have had := π.property ⟨p.val,hb⟩
        exact hp had
      simp [fullMatrix, hnot]

theorem exists_fullFeasible_iff (D : CompressedPatternData α) :
    (∃ w, FullFeasible D w) ↔ ∃ w, Feasible D w := by
  constructor
  · rintro ⟨w,hw⟩
    exact ⟨restrictWeights D w, feasible_restrictWeights D hw⟩
  · rintro ⟨w,hw⟩
    exact ⟨extendWeights D w, fullFeasible_extendWeights D hw⟩

/-- Exactly the admissible partitions with strictly positive supplied coefficients. -/
abbrev PositivePartition (D : CompressedPatternData α)
    (w : AdmissiblePartition D → ℝ) := {π : AdmissiblePartition D // 0 < w π}

/-- Discarding zero coefficients preserves each incidence row. -/
theorem positive_incidence_sum (D : CompressedPatternData α)
    {w : AdmissiblePartition D → ℝ} (hw : Feasible D w) (p : OccurringPattern D) :
    (∑ π : PositivePartition D w, reducedMatrix D p π.val * w π.val) = D.value p := by
  have hz (π : AdmissiblePartition D) (h : ¬ 0 < w π) : w π = 0 :=
    le_antisymm (le_of_not_gt h) (hw.1 π)
  rw [← sum_subtype_of_zero (fun π => 0 < w π)
    (fun π => reducedMatrix D p π * w π) (fun π h => by rw [hz π h, mul_zero])]
  exact congrFun hw.2 p

/-- Each block of a positive admissible partition has its actual occurring-pattern label. -/
def positiveBlockPattern (D : CompressedPatternData α) (w : AdmissiblePartition D → ℝ)
    (b : (π : PositivePartition D w) × π.val.val.parts) : OccurringPattern D :=
  ⟨⟨b.2.val, b.1.val.val.nonempty_of_mem_parts b.2.property⟩, b.1.val.property b.2⟩

/-- Every positive target row receives a positive partition contribution. -/
theorem positiveBlockPattern_surjective (D : CompressedPatternData α)
    {w : AdmissiblePartition D → ℝ} (hw : Feasible D w) :
    Function.Surjective (positiveBlockPattern D w) := by
  intro p
  have hp : 0 < ∑ π, reducedMatrix D p π * w π := by
    change 0 < (reducedMatrix D *ᵥ w) p
    rw [hw.2]
    exact D.value_pos p
  obtain ⟨π, _, hπ⟩ := (Finset.sum_pos_iff_of_nonneg
    (fun π _ => mul_nonneg (reducedMatrix_nonneg D p π) (hw.1 π))).mp hp
  have hb : p.val.val ∈ π.val.parts := by
    by_contra h
    simp only [reducedMatrix_apply, if_neg h, zero_mul, lt_self_iff_false] at hπ
  have hwπ : 0 < w π := by
    simpa only [reducedMatrix_apply, if_pos hb, one_mul] using hπ
  exact ⟨⟨⟨π,hwπ⟩,⟨p.val.val,hb⟩⟩, rfl⟩

/-- The positive coefficients still have total mass one. -/
theorem sum_positive_weights (D : CompressedPatternData α)
    {w : AdmissiblePartition D → ℝ} (hw : Feasible D w) :
    (∑ π : PositivePartition D w, w π.val) = 1 := by
  rw [← sum_subtype_of_zero (fun π => 0 < w π) w
    (fun π h => le_antisymm (le_of_not_gt h) (hw.1 π))]
  exact sum_eq_one_of_reduced_eq D w hw.2

/-- Positive support is inhabited as a consequence of a feasible solution. -/
theorem nonempty_positivePartition (D : CompressedPatternData α)
    {w : AdmissiblePartition D → ℝ} (hw : Feasible D w) :
    Nonempty (PositivePartition D w) := by
  have hp : 0 < ∑ π, w π := by
    rw [sum_eq_one_of_reduced_eq D w hw.2]
    exact zero_lt_one
  obtain ⟨π, _, hπ⟩ := (Finset.sum_pos_iff_of_nonneg (fun π _ => hw.1 π)).mp hp
  exact ⟨⟨π,hπ⟩⟩

/-- Valid data with no admissible partition have no equality solution, even signed. -/
theorem not_reduced_eq_of_isEmpty (D : CompressedPatternData α)
    [IsEmpty (AdmissiblePartition D)] (w : AdmissiblePartition D → ℝ) :
    reducedMatrix D *ᵥ w ≠ D.value := by
  intro h
  have hs := sum_eq_one_of_reduced_eq D w h
  simp at hs

end Feasibility

/-! ## Necessity from the public common-posterior witness -/

variable [Nonempty α]

section Extraction
variable (D : CompressedPatternData α) (q : PMF (α → OccurringPattern D))
  (V : OccurringPattern D → PMF (α → OccurringPattern D))
  (hV : ∀ x, q.map (fun f => (f x, f)) = PMF.channelJoint (D.channel x) V)

private theorem channel_ne_zero_iff_pattern (x : α) (p : OccurringPattern D) :
    D.channel x p ≠ 0 ↔ x ∈ p.val.val := by
  by_cases hx : x ∈ p.val.val
  · simp [D.channel_apply, hx, ne_of_gt (ENNReal.ofReal_pos.mpr (D.value_pos p))]
  · simp [D.channel_apply, hx]

include hV in
private theorem supported_coordinate_support (f : q.supportFinset) (x : α) :
    D.channel x (f.val x) ≠ 0 ∧ f.val ∈ (V (f.val x)).support := by
  have hs : (f.val x, f.val) ∈ (q.map (fun g => (g x, g))).support :=
    (PMF.mem_support_map_iff _ _ _).mpr
      ⟨f.val, (PMF.mem_supportFinset q f.val).mp f.property, rfl⟩
  rwa [hV x, PMF.mem_support_channelJoint_iff] at hs

private abbrev UsedOutput (f : α → OccurringPattern D) :=
  {p : OccurringPattern D // ∃ x, f x = p}

include hV in
private theorem decoder_fiber_iff (f : q.supportFinset)
    (p : UsedOutput D f.val) (x : α) : f.val x = p.val ↔ x ∈ p.val.val.val := by
  obtain ⟨x₀, hx₀⟩ := p.property
  have hpost := (supported_coordinate_support D q V hV f x₀).2
  rw [hx₀] at hpost
  constructor
  · intro hx
    have hs := (supported_coordinate_support D q V hV f x).1
    rw [hx] at hs
    exact (channel_ne_zero_iff_pattern D x p.val).mp hs
  · intro hx
    exact coordinate_eq_of_posterior_support q D.channel V hV
      ((channel_ne_zero_iff_pattern D x p.val).mpr hx) hpost

include hV in
private theorem decoder_fiber_eq_pattern (f : q.supportFinset)
    (p : UsedOutput D f.val) :
    Finset.univ.filter (fun x => f.val x = p.val) = p.val.val.val := by
  ext x
  simp only [Finset.mem_filter, Finset.mem_univ, true_and]
  exact decoder_fiber_iff D q V hV f p x

include hV in
private theorem decoder_blocks_disjoint (f : q.supportFinset) :
    Pairwise (fun p r : UsedOutput D f.val => Disjoint p.val.val.val r.val.val.val) := by
  intro p r hpr
  apply Finset.disjoint_left.mpr
  intro x hp hr
  apply hpr
  apply Subtype.ext
  exact ((decoder_fiber_iff D q V hV f p x).mpr hp).symm.trans
    ((decoder_fiber_iff D q V hV f r x).mpr hr)

include hV in
private theorem decoder_blocks_cover (f : q.supportFinset) :
    ∀ x, x ∈ (Finset.univ : Finset α) ↔
      ∃ p : UsedOutput D f.val, x ∈ p.val.val.val := by
  intro x
  constructor
  · intro _
    refine ⟨⟨f.val x, x, rfl⟩, ?_⟩
    rw [← decoder_fiber_eq_pattern D q V hV f ⟨f.val x, x, rfl⟩]
    simp
  · intro _; exact Finset.mem_univ x

private def decoderPartition (f : q.supportFinset) : ExactPartition α :=
  partitionOfBlocks Finset.univ (fun p : UsedOutput D f.val => p.val.val.val)
    (fun p => p.val.val.property) (decoder_blocks_disjoint D q V hV f)
    (decoder_blocks_cover D q V hV f)

private def decoderPartitionEquiv (f : q.supportFinset) :
    UsedOutput D f.val ≃ (decoderPartition D q V hV f).parts :=
  partitionOfBlocksEquiv Finset.univ (fun p : UsedOutput D f.val => p.val.val.val)
    (fun p => p.val.val.property) (decoder_blocks_disjoint D q V hV f)
    (decoder_blocks_cover D q V hV f)

private theorem decoderPartitionEquiv_val (f : q.supportFinset) (p : UsedOutput D f.val) :
    (decoderPartitionEquiv D q V hV f p).val = p.val.val.val := rfl

private def supportedDecoderPartition (f : q.supportFinset) : AdmissiblePartition D := by
  refine ⟨decoderPartition D q V hV f, ?_⟩
  intro b
  obtain ⟨p, rfl⟩ := (decoderPartitionEquiv D q V hV f).surjective b
  exact p.val.property

private theorem decoder_part_iff (f : q.supportFinset) (p : OccurringPattern D)
    (x : α) (hx : x ∈ p.val.val) :
    p.val.val ∈ (supportedDecoderPartition D q V hV f).val.parts ↔ f.val x = p := by
  constructor
  · intro hp
    obtain ⟨r, hr⟩ := (decoderPartitionEquiv D q V hV f).surjective ⟨p.val.val, hp⟩
    have heparts : r.val.val.val = p.val.val :=
      (decoderPartitionEquiv_val D q V hV f r).symm.trans
        (congrArg (fun b : (decoderPartition D q V hV f).parts => b.val) hr)
    have he : r.val = p := Subtype.ext (Subtype.ext heparts)
    have hx' : x ∈ r.val.val.val := he.symm ▸ hx
    exact ((decoder_fiber_iff D q V hV f r x).mpr hx').trans he
  · intro hp
    let r : UsedOutput D f.val := ⟨p, x, hp⟩
    exact (decoderPartitionEquiv D q V hV f r).property

include hV in
private theorem supported_marginal (x : α) (p : OccurringPattern D)
    (hx : x ∈ p.val.val) :
    (∑ f : q.supportFinset, if f.val x = p then (q f.val).toReal else 0) = D.value p := by
  have hsum : (∑ f : q.supportFinset, if f.val x = p then (q f.val).toReal else 0) =
      ∑ f : α → OccurringPattern D, if f x = p then (q f).toReal else 0 := by
    rw [Finset.sum_coe_sort q.supportFinset
      (fun f : α → OccurringPattern D => if f x = p then (q f).toReal else 0)]
    apply Finset.sum_subset (Finset.subset_univ _)
    intro f _ hf
    have hz : q f = 0 := by
      simpa only [PMF.mem_supportFinset, PMF.mem_support_iff, not_not] using hf
    simp [hz]
  calc
    _ = ∑ f : α → OccurringPattern D, if f x = p then (q f).toReal else 0 := hsum
    _ = ((q.map (fun f => f x)) p).toReal := by
      rw [PMF.map, PMF.bind_toReal_apply]
      apply Finset.sum_congr rfl
      intro f _
      by_cases hf : f x = p
      · simp [PMF.pure_apply, hf]
      · have hpf : p ≠ f x := Ne.symm hf
        simp [PMF.pure_apply, hf, hpf]
    _ = (D.channel x p).toReal :=
      congrArg (fun μ : PMF (OccurringPattern D) => (μ p).toReal)
        (isCanonicalCoupling_of_coordinateFactorization q D.channel V hV x)
    _ = D.value p := by
      rw [D.channel_apply, if_pos hx, ENNReal.toReal_ofReal (le_of_lt (D.value_pos p))]

private def decoderWeights (π : AdmissiblePartition D) : ℝ :=
  ∑ f : q.supportFinset,
    if supportedDecoderPartition D q V hV f = π then (q f.val).toReal else 0

private theorem decoderWeights_feasible : Feasible D (decoderWeights D q V hV) := by
  constructor
  · intro π
    apply Finset.sum_nonneg
    intro f _
    split_ifs
    · exact q.toReal_nonneg f.val
    · exact le_rfl
  · funext p
    obtain ⟨x, hx⟩ := p.val.property
    change (∑ π, reducedMatrix D p π * decoderWeights D q V hV π) = D.value p
    calc
      _ = ∑ f : q.supportFinset,
          reducedMatrix D p (supportedDecoderPartition D q V hV f) * (q f.val).toReal := by
        simp only [decoderWeights, Finset.mul_sum]
        rw [Finset.sum_comm]
        apply Finset.sum_congr rfl
        intro f _
        simp [mul_ite]
      _ = ∑ f : q.supportFinset, if f.val x = p then (q f.val).toReal else 0 := by
        apply Finset.sum_congr rfl
        intro f _
        rw [reducedMatrix_apply]
        by_cases hm : p.val.val ∈ (supportedDecoderPartition D q V hV f).val.parts
        · rw [if_pos hm, one_mul, if_pos ((decoder_part_iff D q V hV f p x hx).mp hm)]
        · rw [if_neg hm, zero_mul,
            if_neg (fun hf => hm ((decoder_part_iff D q V hV f p x hx).mpr hf))]
      _ = D.value p := supported_marginal D q V hV x p hx

end Extraction

/-- A public common-posterior witness supplies nonnegative reduced incidence weights. -/
theorem exists_feasible_of_isPerfectlyRepresentableChannel
    (D : CompressedPatternData α) (h : IsPerfectlyRepresentableChannel D.channel) :
    ∃ w, Feasible D w := by
  obtain ⟨q, V, hV⟩ := h
  exact ⟨decoderWeights D q V hV, decoderWeights_feasible D q V hV⟩

/-- Perfectness also supplies a full solution, with absent coefficients handled by S02. -/
theorem exists_fullFeasible_of_isPerfectlyRepresentableChannel
    (D : CompressedPatternData α) (h : IsPerfectlyRepresentableChannel D.channel) :
    ∃ w, FullFeasible D w :=
  (exists_fullFeasible_iff D).mpr (exists_feasible_of_isPerfectlyRepresentableChannel D h)


end

end PerfectFunctionalRepresentations.Incidence
