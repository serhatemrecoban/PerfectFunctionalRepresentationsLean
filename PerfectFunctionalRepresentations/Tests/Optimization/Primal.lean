import PerfectFunctionalRepresentations.Optimization.Primal

/-!
# Consumers of the primal inequality interface

C14-S01 checks R01/R03 on arbitrary valid compressed data. The admissible
partition family need not be inhabited, and no equality feasibility or
perfectness hypothesis is used. Concrete singleton and empty-family consumers
remain beside the existing private fixtures in `Tests.Optimization.Incidence`.
C14-S02 consumes same-vector saturation and both directions of the data-level
characterizations, including extraction of an attaining vector from greatestness.
-/

namespace PerfectFunctionalRepresentations.Primal.Tests

open scoped BigOperators Matrix

noncomputable section
attribute [local instance] Classical.propDecidable

variable {α : Type*} [Fintype α] [Nonempty α] (D : CompressedPatternData α)

-- S03: arbitrary finite presentations preserve the entire attained image.
example {m n : ℕ} (rows : Incidence.OccurringPattern D ≃ Fin m)
    (cols : Incidence.AdmissiblePartition D ≃ Fin n) :
    IsGreatest ((fun z : Fin n → ℝ => ∑ j, z j) ''
      {z | (∀ j, 0 ≤ z j) ∧
        ∀ i, (Matrix.reindex rows cols (Incidence.reducedMatrix D) *ᵥ z) i ≤
          (D.value ∘ rows.symm) i}) 1 ↔ IsPerfectlyRepresentableChannel D.channel := by
  rw [Primal.objectiveValues_reindex]
  exact (Primal.isPerfectlyRepresentableChannel_iff_isGreatest D).symm

example {m n : ℕ} (rows : Incidence.OccurringPattern D ≃ Fin m)
    (cols : Incidence.AdmissiblePartition D ≃ Fin n) (z : Fin n → ℝ)
    (hz : (∀ j, 0 ≤ z j) ∧
      ∀ i, (Matrix.reindex rows cols (Incidence.reducedMatrix D) *ᵥ z) i ≤
        (D.value ∘ rows.symm) i) :
    Primal.Feasible D (z ∘ cols) ∧
      ((z ∘ cols) ∘ cols.symm = z) ∧ Primal.objective D (z ∘ cols) = ∑ j, z j := by
  refine ⟨(Primal.feasible_reindex_iff D (z ∘ cols) rows cols).mpr ?_, ?_, ?_⟩
  · simpa only [Function.comp_def, Equiv.apply_symm_apply] using hz
  · funext j
    exact congrArg z (cols.apply_symm_apply j)
  · exact cols.sum_comp z

-- Only Finite output is needed at the ambient boundary; no prior is present.
example {β : Type*} [Finite β] (κ : α → PMF β) (hκ : IsSingularChannel κ)
    (h : IsGreatest (Primal.objectiveValues (compressedPatternData κ hκ)) 1) :
    ∃ x, Incidence.Feasible (compressedPatternData κ hκ) x := by
  have hp := (Primal.isPerfectlyRepresentableChannel_iff_isGreatest_compressedPatternData
    κ hκ).mpr h
  obtain ⟨x, hx, ho⟩ :=
    (Primal.isPerfectlyRepresentableChannel_iff_exists_objective_eq_one_compressedPatternData
      κ hκ).mp hp
  exact ⟨x, (Primal.equality_feasible_iff _).mpr ⟨hx, ho⟩⟩

-- R01: the finite coordinates and feasible domain require no inhabited partitions.
example : Fintype (Incidence.AdmissiblePartition D) := inferInstance

example : Set (Incidence.AdmissiblePartition D → ℝ) := Primal.feasibleSet D

example (x : Incidence.AdmissiblePartition D → ℝ) (hx : Primal.Feasible D x) :
    0 ≤ Primal.objective D x ∧ Primal.objective D x ≤ 1 :=
  ⟨Primal.objective_nonneg D hx, Primal.objective_le_one D hx⟩

-- An objective image member retains an actual feasible preimage.
example {r : ℝ} (hr : r ∈ Primal.objectiveValues D) :
    ∃ x, Primal.Feasible D x ∧ Primal.objective D x = r := by
  rcases hr with ⟨x, hx, he⟩
  exact ⟨x, hx, he⟩

example {r : ℝ} (hr : r ∈ Primal.objectiveValues D) : 0 ≤ r ∧ r ≤ 1 := by
  rcases hr with ⟨x, hx, rfl⟩
  exact ⟨Primal.objective_nonneg D hx, Primal.objective_le_one D hx⟩

-- R03: zero remains an inequality witness even when equality feasibility fails.
example : Primal.Feasible D (fun _ => 0) ∧
    Primal.objective D (fun _ => 0) = 0 :=
  ⟨Primal.feasible_zero D, Primal.objective_zero D⟩

example : 0 ∈ Primal.objectiveValues D :=
  ⟨fun _ => 0, Primal.feasible_zero D, Primal.objective_zero D⟩

example : (Primal.objectiveValues D).Nonempty :=
  ⟨0, fun _ => 0, Primal.feasible_zero D, Primal.objective_zero D⟩

example : Primal.Feasible D (fun _ => 0) ∧
    ¬ Incidence.Feasible D (fun _ => 0) := by
  refine ⟨Primal.feasible_zero D, ?_⟩
  intro he
  have hs := Incidence.sum_eq_one_of_reduced_eq D (fun _ => 0) he.2
  norm_num at hs

-- S02: saturation concerns this supplied vector, not a replacement witness.
example {x : Incidence.AdmissiblePartition D → ℝ} (hx : Primal.Feasible D x) :
    Primal.objective D x = 1 ↔ Incidence.reducedMatrix D *ᵥ x = D.value :=
  Primal.objective_eq_one_iff D hx

example {x : Incidence.AdmissiblePartition D → ℝ} (hx : Incidence.Feasible D x) :
    Primal.Feasible D x ∧ Primal.objective D x = 1 :=
  (Primal.equality_feasible_iff D).mp hx

example {x : Incidence.AdmissiblePartition D → ℝ} (hx : Primal.Feasible D x)
    (hobj : Primal.objective D x = 1) : Incidence.Feasible D x :=
  (Primal.equality_feasible_iff D).mpr ⟨hx, hobj⟩

-- R03: the new saturation theorem rejects equality for the zero vector.
example : Incidence.reducedMatrix D *ᵥ (fun _ => 0) ≠ D.value := by
  intro heq
  have h := (Primal.objective_eq_one_iff D (Primal.feasible_zero D)).mpr heq
  rw [Primal.objective_zero D] at h
  exact zero_ne_one h

example : ¬ Incidence.Feasible D (fun _ => 0) := by
  intro hx
  have h := ((Primal.equality_feasible_iff D).mp hx).2
  rw [Primal.objective_zero D] at h
  exact zero_ne_one h

example (h : IsPerfectlyRepresentableChannel D.channel) :
    ∃ x, Primal.Feasible D x ∧ Primal.objective D x = 1 :=
  (Primal.isPerfectlyRepresentableChannel_iff_exists_objective_eq_one D).mp h

example {x : Incidence.AdmissiblePartition D → ℝ} (hx : Primal.Feasible D x)
    (hobj : Primal.objective D x = 1) : IsPerfectlyRepresentableChannel D.channel :=
  (Primal.isPerfectlyRepresentableChannel_iff_exists_objective_eq_one D).mpr ⟨x, hx, hobj⟩

example (h : IsPerfectlyRepresentableChannel D.channel) :
    IsGreatest (Primal.objectiveValues D) 1 :=
  (Primal.isPerfectlyRepresentableChannel_iff_isGreatest D).mp h

example (h : IsGreatest (Primal.objectiveValues D) 1) :
    IsPerfectlyRepresentableChannel D.channel :=
  (Primal.isPerfectlyRepresentableChannel_iff_isGreatest D).mpr h

-- Membership, rather than the upper bound, supplies an actual equality witness.
example (h : IsGreatest (Primal.objectiveValues D) 1) :
    ∃ x, Incidence.Feasible D x := by
  rcases h.1 with ⟨x, hx, hobj⟩
  exact ⟨x, (Primal.equality_feasible_iff D).mpr ⟨hx, hobj⟩⟩

namespace SlackFixture

open Incidence (NonzeroPattern)

local instance : DecidableEq (Fin 2) := fun a b => Classical.propDecidable (a = b)

-- R07: each of two inputs has its own singleton pattern, of value one.
private def p0 : NonzeroPattern (Fin 2) := ⟨{0}, by simp⟩
private def p1 : NonzeroPattern (Fin 2) := ⟨{1}, by simp⟩

private theorem p0_ne_p1 : p0 ≠ p1 := by
  intro h
  have he := congrArg (fun p : NonzeroPattern (Fin 2) => (0 : Fin 2) ∈ p.val) h
  norm_num [p0, p1, Fin.ext_iff] at he

private def data : CompressedPatternData (Fin 2) where
  patterns := {p0, p1}
  value := fun _ => 1
  value_pos := fun _ => zero_lt_one
  row_sum := by
    intro i
    rw [Finset.sum_coe_sort {p0, p1}
      (fun p : NonzeroPattern (Fin 2) => if i ∈ p.val then (1 : ℝ) else 0)]
    rw [Finset.sum_pair p0_ne_p1]
    fin_cases i <;> norm_num [p0, p1, Fin.ext_iff]

private def o0 : Incidence.OccurringPattern data := ⟨p0, by simp [data]⟩
private def o1 : Incidence.OccurringPattern data := ⟨p1, by simp [data]⟩

private theorem occurring_cases (p : Incidence.OccurringPattern data) : p = o0 ∨ p = o1 := by
  have h : p.val = p0 ∨ p.val = p1 := by simpa [data] using p.property
  exact h.imp (fun h => Subtype.ext h) (fun h => Subtype.ext h)

private theorem o0_ne_o1 : o0 ≠ o1 :=
  fun h => p0_ne_p1 (congrArg Subtype.val h)

private theorem input_rows (s : Incidence.OccurringPattern data → ℝ) :
    (Incidence.inputMatrix data *ᵥ s) 0 = s o0 ∧
      (Incidence.inputMatrix data *ᵥ s) 1 = s o1 := by
  constructor
  · change (∑ p, Incidence.inputMatrix data 0 p * s p) = s o0
    rw [Finset.sum_eq_single o0]
    · simp [Incidence.inputMatrix, Incidence.fullInputMatrix, o0, p0]
    · intro p _ hp
      rcases occurring_cases p with h | h
      · exact False.elim (hp h)
      · subst p
        simp [Incidence.inputMatrix, Incidence.fullInputMatrix, o1, p1]
    · simp
  · change (∑ p, Incidence.inputMatrix data 1 p * s p) = s o1
    rw [Finset.sum_eq_single o1]
    · simp [Incidence.inputMatrix, Incidence.fullInputMatrix, o1, p1]
    · intro p _ hp
      rcases occurring_cases p with h | h
      · subst p
        simp [Incidence.inputMatrix, Incidence.fullInputMatrix, o0, p0]
      · exact False.elim (hp h)
    · simp

private def secondSlack (p : Incidence.OccurringPattern data) : ℝ := if p = o1 then 1 else 0

example : (∀ p, 0 ≤ secondSlack p) ∧
    (Incidence.inputMatrix data *ᵥ secondSlack) 0 = 0 ∧
    (Incidence.inputMatrix data *ᵥ secondSlack) 1 = 1 ∧
    secondSlack ≠ (fun _ => 0) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro p
    unfold secondSlack
    split_ifs <;> norm_num
  · rw [(input_rows secondSlack).1]
    simp [secondSlack, o0_ne_o1]
  · rw [(input_rows secondSlack).2]
    simp [secondSlack]
  · intro h
    have he := congrFun h o1
    norm_num [secondSlack] at he

-- Both input equations eliminate the two actual slack coordinates of feasible x.
example {x : Incidence.AdmissiblePartition data → ℝ} (hx : Primal.Feasible data x)
    (hrows : Incidence.inputMatrix data *ᵥ (data.value - Incidence.reducedMatrix data *ᵥ x) =
      (fun _ => 0)) :
    (∀ p, 0 ≤ (data.value - Incidence.reducedMatrix data *ᵥ x) p) ∧
      Incidence.reducedMatrix data *ᵥ x = data.value := by
  refine ⟨fun p => sub_nonneg.mpr (hx.2 p), ?_⟩
  funext p
  have h0 := (input_rows (data.value - Incidence.reducedMatrix data *ᵥ x)).1
  have h1 := (input_rows (data.value - Incidence.reducedMatrix data *ᵥ x)).2
  rw [hrows] at h0 h1
  rcases occurring_cases p with rfl | rfl
  · exact (sub_eq_zero.mp h0.symm).symm
  · exact (sub_eq_zero.mp h1.symm).symm

-- Saturation checks every coordinate on this valid datum, including the second row.
example {x : Incidence.AdmissiblePartition data → ℝ} (hx : Primal.Feasible data x)
    (hobj : Primal.objective data x = 1) :
    (Incidence.reducedMatrix data *ᵥ x) o0 = 1 ∧
      (Incidence.reducedMatrix data *ᵥ x) o1 = 1 := by
  have heq := (Primal.objective_eq_one_iff data hx).mp hobj
  exact ⟨congrFun heq o0, congrFun heq o1⟩

end SlackFixture

end
end PerfectFunctionalRepresentations.Primal.Tests
