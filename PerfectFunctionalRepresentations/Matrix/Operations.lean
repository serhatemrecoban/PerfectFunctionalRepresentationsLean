import LeanInfoTheory.Probability.FiniteMixture
import PerfectFunctionalRepresentations.Matrix.OperationIndices
import PerfectFunctionalRepresentations.Matrix.Channel
import PerfectFunctionalRepresentations.Matrix.SingularColumns

/-!
# Split and merge operations on channel rows

The four operations in ISIT Section III-A, supplemented by extended version 16
Section III-A, use three raw constructions: a binary refinement kernel for PPS,
a common output pushforward for both merges, and an input-dependent output map
for VPS. Inputs remain arbitrary types; the PMF rows own normalization.

These raw constructions permit PPS endpoint weights and support-degenerate VPS
masks. They do not assert the activity or singularity required for legal active
operations. The four legal operations below add those premises, prove closure and recover
the original channel with remembered witnesses and explicit column ordering.
Exact coordinates retain the adjacent split and lower-index-survivor
merge order, including the final source column. Real coordinates are derived
from these finite PMF masses at the matrix boundary.

Legal VPS admits column value one under the approved interpretation of the
printed strict bound. Its two nonempty support pieces are explicit witnesses;
VPM requires equal admitted values and disjoint support. Recovery remembers
the split data and treats masks outside the selected support as irrelevant.
-/

namespace PerfectFunctionalRepresentations.MatrixOperations

open scoped BigOperators ENNReal

universe u
variable {alpha : Type u} {n m : Nat}

noncomputable section

/-- Binary output refinement, with the first child receiving weight `t`.
The raw kernel permits both endpoint weights. -/
def ppsKernel (l : Fin n) (t : NNReal) (ht : t ≤ 1) : Fin n → PMF (Fin (n + 1)) :=
  fun j => if j = l then
    PMF.binaryMixture t ht (PMF.pure (splitLeft l)) (PMF.pure (splitRight l))
  else PMF.pure (splitKeep l j)

@[simp]
theorem ppsKernel_selected (l : Fin n) (t : NNReal) (ht : t ≤ 1) :
    ppsKernel l t ht l =
      PMF.binaryMixture t ht (PMF.pure (splitLeft l)) (PMF.pure (splitRight l)) := by
  simp [ppsKernel]

theorem ppsKernel_unaffected (l : Fin n) (t : NNReal) (ht : t ≤ 1)
    {j : Fin n} (hj : j ≠ l) :
    ppsKernel l t ht j = PMF.pure (splitKeep l j) := by
  simp [ppsKernel, hj]

/-- Raw PPS is composition with the input-independent refinement kernel. -/
def ppsRaw (K : alpha → PMF (Fin n)) (l : Fin n) (t : NNReal) (ht : t ≤ 1) :
    alpha → PMF (Fin (n + 1)) :=
  fun x => (K x).bind (ppsKernel l t ht)

theorem ppsRaw_apply_bind (K : alpha → PMF (Fin n)) (l : Fin n)
    (t : NNReal) (ht : t ≤ 1) (x : alpha) :
    ppsRaw K l t ht x = (K x).bind (ppsKernel l t ht) := rfl

/-- Raw merge is the pushforward by the common two-to-one output collapse. -/
def mergeRaw (K : alpha → PMF (Fin (m + 1))) (a b : Fin (m + 1)) (hab : a < b) :
    alpha → PMF (Fin m) :=
  fun x => (K x).map (mergeIndex a b hab)

theorem mergeRaw_apply_map (K : alpha → PMF (Fin (m + 1)))
    (a b : Fin (m + 1)) (hab : a < b) (x : alpha) :
    mergeRaw K a b hab x = (K x).map (mergeIndex a b hab) := rfl

/-- A raw value-preserving split routes the selected output to one child. -/
def vpsIndex (l : Fin n) (chooseLeft : Bool) : Fin n → Fin (n + 1) :=
  fun j => if j = l then
    if chooseLeft then splitLeft l else splitRight l
  else splitKeep l j

@[simp]
theorem vpsIndex_selected (l : Fin n) (chooseLeft : Bool) :
    vpsIndex l chooseLeft l = if chooseLeft then splitLeft l else splitRight l := by
  simp [vpsIndex]

theorem vpsIndex_unaffected (l : Fin n) (chooseLeft : Bool) {j : Fin n} (hj : j ≠ l) :
    vpsIndex l chooseLeft j = splitKeep l j := by
  simp [vpsIndex, hj]

/-- Raw VPS is a deterministic output map depending on the input row. -/
def vpsRaw (K : alpha → PMF (Fin n)) (l : Fin n) (mask : alpha → Bool) :
    alpha → PMF (Fin (n + 1)) :=
  fun x => (K x).map (vpsIndex l (mask x))

theorem vpsRaw_apply_map (K : alpha → PMF (Fin n)) (l : Fin n)
    (mask : alpha → Bool) (x : alpha) :
    vpsRaw K l mask x = (K x).map (vpsIndex l (mask x)) := rfl

private theorem splitKeep_ne_left_of_ne (l : Fin n) {j : Fin n} (hj : j ≠ l) :
    splitKeep l j ≠ splitLeft l := by
  intro h
  apply hj
  apply splitKeep_injective l
  simpa only [splitKeep_self] using h

private theorem ppsKernel_mass_left (l : Fin n) (t : NNReal) (ht : t ≤ 1) (j : Fin n) :
    ppsKernel l t ht j (splitLeft l) = if j = l then (t : ENNReal) else 0 := by
  by_cases hj : j = l
  · subst j
    simp [ppsKernel, PMF.binaryMixture_apply, PMF.pure_apply, splitLeft_ne_right]
  · simp [ppsKernel, hj, PMF.pure_apply, Ne.symm (splitKeep_ne_left_of_ne l hj)]

private theorem ppsKernel_mass_right (l : Fin n) (t : NNReal) (ht : t ≤ 1) (j : Fin n) :
    ppsKernel l t ht j (splitRight l) =
      if j = l then ((1 - t : NNReal) : ENNReal) else 0 := by
  by_cases hj : j = l
  · subst j
    simp [ppsKernel, PMF.binaryMixture_apply, PMF.pure_apply, Ne.symm (splitLeft_ne_right l)]
  · simp [ppsKernel, hj, PMF.pure_apply, Ne.symm (splitKeep_ne_right l j)]

private theorem ppsKernel_mass_keep (l : Fin n) (t : NNReal) (ht : t ≤ 1)
    {j : Fin n} (hj : j ≠ l) (k : Fin n) :
    ppsKernel l t ht k (splitKeep l j) = if k = j then 1 else 0 := by
  by_cases hk : k = l
  · subst k
    simp [ppsKernel, PMF.binaryMixture_apply, PMF.pure_apply,
      splitKeep_ne_left_of_ne l hj, splitKeep_ne_right, Ne.symm hj]
  · simp [ppsKernel, hk, PMF.pure_apply, (splitKeep_injective l).eq_iff, eq_comm]

theorem ppsRaw_left (K : alpha → PMF (Fin n)) (l : Fin n)
    (t : NNReal) (ht : t ≤ 1) (x : alpha) :
    ppsRaw K l t ht x (splitLeft l) = (t : ENNReal) * K x l := by
  rw [ppsRaw_apply_bind, PMF.bind_apply]
  simp [ppsKernel_mass_left, mul_comm]

theorem ppsRaw_right (K : alpha → PMF (Fin n)) (l : Fin n)
    (t : NNReal) (ht : t ≤ 1) (x : alpha) :
    ppsRaw K l t ht x (splitRight l) = ((1 - t : NNReal) : ENNReal) * K x l := by
  rw [ppsRaw_apply_bind, PMF.bind_apply]
  simp [ppsKernel_mass_right, mul_comm]

theorem ppsRaw_keep (K : alpha → PMF (Fin n)) (l : Fin n)
    (t : NNReal) (ht : t ≤ 1) (x : alpha) {j : Fin n} (hj : j ≠ l) :
    ppsRaw K l t ht x (splitKeep l j) = K x j := by
  rw [ppsRaw_apply_bind, PMF.bind_apply]
  simp [ppsKernel_mass_keep l t ht hj, mul_ite]

theorem mergeRaw_survivor (K : alpha → PMF (Fin (m + 1)))
    (a b : Fin (m + 1)) (hab : a < b) (x : alpha) :
    mergeRaw K a b hab x (mergeSurvivor a b hab) = K x a + K x b := by
  rw [mergeRaw_apply_map, PMF.map_apply, tsum_fintype, Fin.sum_univ_succAbove _ b]
  simp [add_comm]

theorem mergeRaw_unaffected (K : alpha → PMF (Fin (m + 1)))
    (a b : Fin (m + 1)) (hab : a < b) (x : alpha) {j : Fin m}
    (hj : j ≠ mergeSurvivor a b hab) :
    mergeRaw K a b hab x j = K x (b.succAbove j) := by
  rw [mergeRaw_apply_map, PMF.map_apply, tsum_fintype, Fin.sum_univ_succAbove _ b]
  simp [hj]

private theorem vpsIndex_left_iff (l : Fin n) (c : Bool) (j : Fin n) :
    splitLeft l = vpsIndex l c j ↔ j = l ∧ c = true := by
  by_cases hj : j = l
  · subst j
    cases c <;> simp [vpsIndex, splitLeft_ne_right]
  · simp [vpsIndex, hj, Ne.symm (splitKeep_ne_left_of_ne l hj)]

private theorem vpsIndex_right_iff (l : Fin n) (c : Bool) (j : Fin n) :
    splitRight l = vpsIndex l c j ↔ j = l ∧ c = false := by
  by_cases hj : j = l
  · subst j
    cases c <;> simp [vpsIndex, Ne.symm (splitLeft_ne_right l)]
  · simp [vpsIndex, hj, Ne.symm (splitKeep_ne_right l j)]

private theorem vpsIndex_keep_iff (l : Fin n) (c : Bool) {j : Fin n} (hj : j ≠ l)
    (k : Fin n) : splitKeep l j = vpsIndex l c k ↔ k = j := by
  by_cases hk : k = l
  · subst k
    cases c <;> simp [vpsIndex, splitKeep_ne_left_of_ne l hj, splitKeep_ne_right, Ne.symm hj]
  · simp [vpsIndex, hk, (splitKeep_injective l).eq_iff, eq_comm]

theorem vpsRaw_left (K : alpha → PMF (Fin n)) (l : Fin n)
    (mask : alpha → Bool) (x : alpha) :
    vpsRaw K l mask x (splitLeft l) = if mask x then K x l else 0 := by
  rw [vpsRaw_apply_map, PMF.map_apply]
  simp only [vpsIndex_left_iff]
  cases mask x <;> simp

theorem vpsRaw_right (K : alpha → PMF (Fin n)) (l : Fin n)
    (mask : alpha → Bool) (x : alpha) :
    vpsRaw K l mask x (splitRight l) = if mask x then 0 else K x l := by
  rw [vpsRaw_apply_map, PMF.map_apply]
  simp only [vpsIndex_right_iff]
  cases mask x <;> simp

theorem vpsRaw_keep (K : alpha → PMF (Fin n)) (l : Fin n)
    (mask : alpha → Bool) (x : alpha) {j : Fin n} (hj : j ≠ l) :
    vpsRaw K l mask x (splitKeep l j) = K x j := by
  rw [vpsRaw_apply_map, PMF.map_apply]
  simp [vpsIndex_keep_iff l (mask x) hj]

theorem ppsRaw_row_sum (K : alpha → PMF (Fin n)) (l : Fin n)
    (t : NNReal) (ht : t ≤ 1) (x : alpha) : ∑ y, ppsRaw K l t ht x y = 1 := by
  simpa only [massMatrix_apply] using massMatrix_row_sum (ppsRaw K l t ht) x

theorem mergeRaw_row_sum (K : alpha → PMF (Fin (m + 1)))
    (a b : Fin (m + 1)) (hab : a < b) (x : alpha) : ∑ y, mergeRaw K a b hab x y = 1 := by
  simpa only [massMatrix_apply] using massMatrix_row_sum (mergeRaw K a b hab) x

theorem vpsRaw_row_sum (K : alpha → PMF (Fin n)) (l : Fin n)
    (mask : alpha → Bool) (x : alpha) : ∑ y, vpsRaw K l mask x y = 1 := by
  simpa only [massMatrix_apply] using massMatrix_row_sum (vpsRaw K l mask) x

end

end PerfectFunctionalRepresentations.MatrixOperations

namespace PerfectFunctionalRepresentations.MatrixOperations

open scoped BigOperators ENNReal

universe u
variable {alpha : Type u} {n m : Nat}

/-- The raw NNReal ratio is the printed Real parameter; subtraction is
ordinary Real subtraction because the supplied ratio is at most one. -/
theorem splitRatio_complement (t : NNReal) (ht : t ≤ 1) :
    ((1 - t : NNReal) : ℝ) = 1 - (t : ℝ) := by
  simpa using NNReal.coe_sub ht

theorem ppsRaw_real_left (K : alpha → PMF (Fin n)) (l : Fin n)
    (t : NNReal) (ht : t ≤ 1) (x : alpha) :
    realMatrix (ppsRaw K l t ht) x (splitLeft l) = (t : ℝ) * realMatrix K x l := by
  simp only [realMatrix_apply, ppsRaw_left, ENNReal.toReal_mul, ENNReal.coe_toReal]

theorem ppsRaw_real_right (K : alpha → PMF (Fin n)) (l : Fin n)
    (t : NNReal) (ht : t ≤ 1) (x : alpha) :
    realMatrix (ppsRaw K l t ht) x (splitRight l) =
      (1 - (t : ℝ)) * realMatrix K x l := by
  simp only [realMatrix_apply, ppsRaw_right, ENNReal.toReal_mul, ENNReal.coe_toReal,
    splitRatio_complement t ht]

theorem ppsRaw_real_keep (K : alpha → PMF (Fin n)) (l : Fin n)
    (t : NNReal) (ht : t ≤ 1) (x : alpha) {j : Fin n} (hj : j ≠ l) :
    realMatrix (ppsRaw K l t ht) x (splitKeep l j) = realMatrix K x j := by
  simp only [realMatrix_apply, ppsRaw_keep K l t ht x hj]

theorem mergeRaw_real_survivor (K : alpha → PMF (Fin (m + 1)))
    (a b : Fin (m + 1)) (hab : a < b) (x : alpha) :
    realMatrix (mergeRaw K a b hab) x (mergeSurvivor a b hab) =
      realMatrix K x a + realMatrix K x b := by
  simp only [realMatrix_apply, mergeRaw_survivor,
    ENNReal.toReal_add (PMF.apply_ne_top _ _) (PMF.apply_ne_top _ _)]

theorem mergeRaw_real_unaffected (K : alpha → PMF (Fin (m + 1)))
    (a b : Fin (m + 1)) (hab : a < b) (x : alpha) {j : Fin m}
    (hj : j ≠ mergeSurvivor a b hab) :
    realMatrix (mergeRaw K a b hab) x j = realMatrix K x (b.succAbove j) := by
  simp only [realMatrix_apply, mergeRaw_unaffected K a b hab x hj]

theorem vpsRaw_real_left (K : alpha → PMF (Fin n)) (l : Fin n)
    (mask : alpha → Bool) (x : alpha) :
    realMatrix (vpsRaw K l mask) x (splitLeft l) =
      if mask x then realMatrix K x l else 0 := by
  simp only [realMatrix_apply, vpsRaw_left]
  cases mask x <;> simp

theorem vpsRaw_real_right (K : alpha → PMF (Fin n)) (l : Fin n)
    (mask : alpha → Bool) (x : alpha) :
    realMatrix (vpsRaw K l mask) x (splitRight l) =
      if mask x then 0 else realMatrix K x l := by
  simp only [realMatrix_apply, vpsRaw_right]
  cases mask x <;> simp

theorem vpsRaw_real_keep (K : alpha → PMF (Fin n)) (l : Fin n)
    (mask : alpha → Bool) (x : alpha) {j : Fin n} (hj : j ≠ l) :
    realMatrix (vpsRaw K l mask) x (splitKeep l j) = realMatrix K x j := by
  simp only [realMatrix_apply, vpsRaw_keep K l mask x hj]

theorem ppsRaw_real_row_sum (K : alpha → PMF (Fin n)) (l : Fin n)
    (t : NNReal) (ht : t ≤ 1) (x : alpha) :
    ∑ y, realMatrix (ppsRaw K l t ht) x y = 1 := realMatrix_row_sum _ _

theorem mergeRaw_real_row_sum (K : alpha → PMF (Fin (m + 1)))
    (a b : Fin (m + 1)) (hab : a < b) (x : alpha) :
    ∑ y, realMatrix (mergeRaw K a b hab) x y = 1 := realMatrix_row_sum _ _

theorem vpsRaw_real_row_sum (K : alpha → PMF (Fin n)) (l : Fin n)
    (mask : alpha → Bool) (x : alpha) :
    ∑ y, realMatrix (vpsRaw K l mask) x y = 1 := realMatrix_row_sum _ _

end PerfectFunctionalRepresentations.MatrixOperations

namespace PerfectFunctionalRepresentations.MatrixOperations

open scoped BigOperators ENNReal

universe u
variable {alpha : Type u} [Finite alpha] [Nonempty alpha]

noncomputable section

/-- Legal pattern-preserving split: both children retain nonempty support. -/
def pps (S : ActiveFiniteChannel alpha) (_hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1) :
    ActiveFiniteChannel alpha where
  outputCard := S.outputCard + 1
  outputCard_pos := Nat.succ_pos _
  channel := ppsRaw S.channel l t ht1.le
  output_active := by
    intro j
    rcases split_cases l j with rfl | ⟨k, rfl⟩
    · obtain ⟨x, hx⟩ := S.output_active l
      refine ⟨x, ?_⟩
      rw [ppsRaw_right]
      exact mul_ne_zero (ENNReal.coe_ne_zero.mpr (ne_of_gt (tsub_pos_of_lt ht1))) hx
    · by_cases hk : k = l
      · subst k
        obtain ⟨x, hx⟩ := S.output_active l
        refine ⟨x, ?_⟩
        rw [splitKeep_self, ppsRaw_left]
        exact mul_ne_zero (ENNReal.coe_ne_zero.mpr (ne_of_gt ht0)) hx
      · obtain ⟨x, hx⟩ := S.output_active k
        exact ⟨x, by rw [ppsRaw_keep S.channel l t ht1.le x hk]; exact hx⟩

variable (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
  (l : Fin S.outputCard) (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1)

@[simp] theorem pps_outputCard : (pps S hS l t ht0 ht1).outputCard = S.outputCard + 1 := rfl

/-- The active operation exposes the same semantic refinement as the raw PMF construction. -/
theorem pps_channel : (pps S hS l t ht0 ht1).channel = ppsRaw S.channel l t ht1.le := rfl

theorem pps_apply_bind (x : alpha) :
    (pps S hS l t ht0 ht1).channel x = (S.channel x).bind (ppsKernel l t ht1.le) := rfl

theorem pps_left (x : alpha) :
    (pps S hS l t ht0 ht1).channel x (splitLeft l) = (t : ENNReal) * S.channel x l :=
  ppsRaw_left S.channel l t ht1.le x

theorem pps_right (x : alpha) :
    (pps S hS l t ht0 ht1).channel x (splitRight l) =
      ((1 - t : NNReal) : ENNReal) * S.channel x l :=
  ppsRaw_right S.channel l t ht1.le x

theorem pps_keep (x : alpha) {j : Fin S.outputCard} (hj : j ≠ l) :
    (pps S hS l t ht0 ht1).channel x (splitKeep l j) = S.channel x j :=
  ppsRaw_keep S.channel l t ht1.le x hj

theorem pps_left_ne_zero_iff (x : alpha) :
    (pps S hS l t ht0 ht1).channel x (splitLeft l) ≠ 0 ↔ S.channel x l ≠ 0 := by
  rw [pps_left]
  exact ⟨right_ne_zero_of_mul,
    mul_ne_zero (ENNReal.coe_ne_zero.mpr (ne_of_gt ht0))⟩

theorem pps_right_ne_zero_iff (x : alpha) :
    (pps S hS l t ht0 ht1).channel x (splitRight l) ≠ 0 ↔ S.channel x l ≠ 0 := by
  rw [pps_right]
  exact ⟨right_ne_zero_of_mul,
    mul_ne_zero (ENNReal.coe_ne_zero.mpr (ne_of_gt (tsub_pos_of_lt ht1)))⟩

/-- The adjacent children are a legal pair for the later pattern-preserving merge. -/
theorem pps_children_sameSupport (x : alpha) :
    (pps S hS l t ht0 ht1).channel x (splitLeft l) ≠ 0 ↔
      (pps S hS l t ht0 ht1).channel x (splitRight l) ≠ 0 := by
  rw [pps_left_ne_zero_iff, pps_right_ne_zero_iff]

/-- Singularity is a theorem about the returned channel, separate from its active state. -/
theorem pps_isSingular : IsSingularChannel (pps S hS l t ht0 ht1).channel := by
  intro x₁ x₂ j h₁ h₂
  rcases split_cases l j with rfl | ⟨k, rfl⟩
  · rw [pps_right, pps_right]
    exact congrArg (fun v => ((1 - t : NNReal) : ENNReal) * v)
      (hS x₁ x₂ l ((pps_right_ne_zero_iff S hS l t ht0 ht1 x₁).mp h₁)
        ((pps_right_ne_zero_iff S hS l t ht0 ht1 x₂).mp h₂))
  · by_cases hk : k = l
    · subst k
      rw [splitKeep_self] at h₁ h₂ ⊢
      rw [pps_left, pps_left]
      exact congrArg (fun v => (t : ENNReal) * v)
        (hS x₁ x₂ l ((pps_left_ne_zero_iff S hS l t ht0 ht1 x₁).mp h₁)
          ((pps_left_ne_zero_iff S hS l t ht0 ht1 x₂).mp h₂))
    · rw [pps_keep S hS l t ht0 ht1 x₁ hk] at h₁ ⊢
      rw [pps_keep S hS l t ht0 ht1 x₂ hk] at h₂ ⊢
      exact hS x₁ x₂ k h₁ h₂

theorem pps_real_left (x : alpha) :
    realMatrix (pps S hS l t ht0 ht1).channel x (splitLeft l) =
      (t : ℝ) * realMatrix S.channel x l :=
  ppsRaw_real_left S.channel l t ht1.le x

theorem pps_real_right (x : alpha) :
    realMatrix (pps S hS l t ht0 ht1).channel x (splitRight l) =
      (1 - (t : ℝ)) * realMatrix S.channel x l :=
  ppsRaw_real_right S.channel l t ht1.le x

theorem pps_real_keep (x : alpha) {j : Fin S.outputCard} (hj : j ≠ l) :
    realMatrix (pps S hS l t ht0 ht1).channel x (splitKeep l j) =
      realMatrix S.channel x j :=
  ppsRaw_real_keep S.channel l t ht1.le x hj

theorem pps_row_sum (x : alpha) : ∑ y, (pps S hS l t ht0 ht1).channel x y = 1 :=
  ppsRaw_row_sum S.channel l t ht1.le x

theorem pps_real_row_sum (x : alpha) :
    ∑ y, realMatrix (pps S hS l t ht0 ht1).channel x y = 1 :=
  ppsRaw_real_row_sum S.channel l t ht1.le x

theorem columnValue_pps_left :
    columnValue (pps S hS l t ht0 ht1).channel (pps_isSingular S hS l t ht0 ht1)
        ((pps S hS l t ht0 ht1).activeEquiv (splitLeft l)) =
      (t : ENNReal) * columnValue S.channel hS (S.activeEquiv l) := by
  obtain ⟨x, hx⟩ := S.output_active l
  rw [columnValue_eq_of_ne_zero _ _ _ ((pps_left_ne_zero_iff S hS l t ht0 ht1 x).mpr hx),
    columnValue_eq_of_ne_zero _ _ _ hx]
  exact pps_left S hS l t ht0 ht1 x

theorem columnValue_pps_right :
    columnValue (pps S hS l t ht0 ht1).channel (pps_isSingular S hS l t ht0 ht1)
        ((pps S hS l t ht0 ht1).activeEquiv (splitRight l)) =
      ((1 - t : NNReal) : ENNReal) * columnValue S.channel hS (S.activeEquiv l) := by
  obtain ⟨x, hx⟩ := S.output_active l
  rw [columnValue_eq_of_ne_zero _ _ _ ((pps_right_ne_zero_iff S hS l t ht0 ht1 x).mpr hx),
    columnValue_eq_of_ne_zero _ _ _ hx]
  exact pps_right S hS l t ht0 ht1 x

theorem columnValue_pps_keep {j : Fin S.outputCard} (hj : j ≠ l) :
    columnValue (pps S hS l t ht0 ht1).channel (pps_isSingular S hS l t ht0 ht1)
        ((pps S hS l t ht0 ht1).activeEquiv (splitKeep l j)) =
      columnValue S.channel hS (S.activeEquiv j) := by
  apply columnValue_transport S.channel (pps S hS l t ht0 ht1).channel hS
    (pps_isSingular S hS l t ht0 ht1) (S.activeEquiv j)
    ((pps S hS l t ht0 ht1).activeEquiv (splitKeep l j)) (Equiv.refl alpha)
  intro x
  exact pps_keep S hS l t ht0 ht1 x hj

theorem columnValue_pps_left_toReal :
    (columnValue (pps S hS l t ht0 ht1).channel (pps_isSingular S hS l t ht0 ht1)
        ((pps S hS l t ht0 ht1).activeEquiv (splitLeft l))).toReal =
      (t : ℝ) * (columnValue S.channel hS (S.activeEquiv l)).toReal := by
  rw [columnValue_pps_left, ENNReal.toReal_mul, ENNReal.coe_toReal]

theorem columnValue_pps_right_toReal :
    (columnValue (pps S hS l t ht0 ht1).channel (pps_isSingular S hS l t ht0 ht1)
        ((pps S hS l t ht0 ht1).activeEquiv (splitRight l))).toReal =
      (1 - (t : ℝ)) * (columnValue S.channel hS (S.activeEquiv l)).toReal := by
  rw [columnValue_pps_right, ENNReal.toReal_mul, ENNReal.coe_toReal,
    splitRatio_complement t ht1.le]

theorem columnValue_pps_keep_toReal {j : Fin S.outputCard} (hj : j ≠ l) :
    (columnValue (pps S hS l t ht0 ht1).channel (pps_isSingular S hS l t ht0 ht1)
        ((pps S hS l t ht0 ht1).activeEquiv (splitKeep l j))).toReal =
      (columnValue S.channel hS (S.activeEquiv j)).toReal := by
  rw [columnValue_pps_keep S hS l t ht0 ht1 hj]

variable [Fintype alpha]

theorem columnPattern_pps_left :
    columnPattern (pps S hS l t ht0 ht1).channel
        ((pps S hS l t ht0 ht1).activeEquiv (splitLeft l)) =
      columnPattern S.channel (S.activeEquiv l) := by
  apply Subtype.ext
  ext x
  simp only [mem_columnPattern]
  exact pps_left_ne_zero_iff S hS l t ht0 ht1 x

theorem columnPattern_pps_right :
    columnPattern (pps S hS l t ht0 ht1).channel
        ((pps S hS l t ht0 ht1).activeEquiv (splitRight l)) =
      columnPattern S.channel (S.activeEquiv l) := by
  apply Subtype.ext
  ext x
  simp only [mem_columnPattern]
  exact pps_right_ne_zero_iff S hS l t ht0 ht1 x

theorem columnPattern_pps_keep {j : Fin S.outputCard} (hj : j ≠ l) :
    columnPattern (pps S hS l t ht0 ht1).channel
        ((pps S hS l t ht0 ht1).activeEquiv (splitKeep l j)) =
      columnPattern S.channel (S.activeEquiv j) := by
  apply Subtype.ext
  ext x
  simp only [mem_columnPattern]
  change (pps S hS l t ht0 ht1).channel x (splitKeep l j) ≠ 0 ↔ S.channel x j ≠ 0
  rw [pps_keep S hS l t ht0 ht1 x hj]

end

end PerfectFunctionalRepresentations.MatrixOperations

namespace PerfectFunctionalRepresentations.MatrixOperations

open scoped BigOperators ENNReal
noncomputable section
universe u
variable {alpha : Type u} [Finite alpha] [Nonempty alpha]

/-- The actual active output cardinality, expressed as its predecessor plus one. -/
theorem mergeSource_card (S : ActiveFiniteChannel alpha) :
    S.outputCard = S.outputCard - 1 + 1 := by
  have := S.outputCard_pos
  omega

def mergeSourceEquiv (S : ActiveFiniteChannel alpha) :
    Fin S.outputCard ≃ Fin (S.outputCard - 1 + 1) := finCongr (mergeSource_card S)

@[simp] theorem mergeSourceEquiv_val (S : ActiveFiniteChannel alpha) (j : Fin S.outputCard) :
    (mergeSourceEquiv S j).val = j.val := rfl

@[simp] theorem mergeSourceEquiv_symm_val (S : ActiveFiniteChannel alpha)
    (j : Fin (S.outputCard - 1 + 1)) : ((mergeSourceEquiv S).symm j).val = j.val := rfl

@[simp] theorem mergeSourceEquiv_lt_iff (S : ActiveFiniteChannel alpha)
    (a b : Fin S.outputCard) : mergeSourceEquiv S a < mergeSourceEquiv S b ↔ a < b := Iff.rfl

@[simp] theorem mergeSourceEquiv_map_apply (S : ActiveFiniteChannel alpha)
    (x : alpha) (j : Fin S.outputCard) :
    ((S.channel x).map (mergeSourceEquiv S)) (mergeSourceEquiv S j) = S.channel x j :=
  PMF.map_apply_equiv _ _ _

private theorem mergeSourceEquiv_map_apply_symm (S : ActiveFiniteChannel alpha)
    (x : alpha) (j : Fin (S.outputCard - 1 + 1)) :
    ((S.channel x).map (mergeSourceEquiv S)) j = S.channel x ((mergeSourceEquiv S).symm j) := by
  simpa only [Equiv.apply_symm_apply] using
    mergeSourceEquiv_map_apply S x ((mergeSourceEquiv S).symm j)

theorem mergeSourceEquiv_isSingular (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) :
    IsSingularChannel (fun x => (S.channel x).map (mergeSourceEquiv S)) :=
  (isSingularChannel_map_iff S.channel (mergeSourceEquiv S) (mergeSourceEquiv S).injective).mpr hS

theorem mergeSourceEquiv_active (S : ActiveFiniteChannel alpha)
    (j : Fin (S.outputCard - 1 + 1)) :
    ∃ x, ((S.channel x).map (mergeSourceEquiv S)) j ≠ 0 := by
  obtain ⟨x, hx⟩ := S.output_active ((mergeSourceEquiv S).symm j)
  exact ⟨x, by simpa only [mergeSourceEquiv_map_apply_symm] using hx⟩

def activeMergeSurvivor (S : ActiveFiniteChannel alpha) (a b : Fin S.outputCard)
    (hab : a < b) : Fin (S.outputCard - 1) :=
  mergeSurvivor (mergeSourceEquiv S a) (mergeSourceEquiv S b)
    ((mergeSourceEquiv_lt_iff S a b).mpr hab)

def activeMergeRetained (S : ActiveFiniteChannel alpha) (b : Fin S.outputCard)
    (j : Fin (S.outputCard - 1)) : Fin S.outputCard :=
  (mergeSourceEquiv S).symm ((mergeSourceEquiv S b).succAbove j)

@[simp] theorem activeMergeRetained_source (S : ActiveFiniteChannel alpha) (b : Fin S.outputCard)
    (j : Fin (S.outputCard - 1)) :
    mergeSourceEquiv S (activeMergeRetained S b j) = (mergeSourceEquiv S b).succAbove j :=
  (mergeSourceEquiv S).apply_symm_apply _

@[simp] theorem activeMergeSurvivor_val (S : ActiveFiniteChannel alpha)
    (a b : Fin S.outputCard) (hab : a < b) : (activeMergeSurvivor S a b hab).val = a.val := by
  simp [activeMergeSurvivor]

@[simp] theorem activeMergeRetained_survivor (S : ActiveFiniteChannel alpha)
    (a b : Fin S.outputCard) (hab : a < b) :
    activeMergeRetained S b (activeMergeSurvivor S a b hab) = a := by
  simp [activeMergeRetained, activeMergeSurvivor]

theorem activeMerge_two_le (S : ActiveFiniteChannel alpha)
    (a b : Fin S.outputCard) (hab : a < b) : 2 ≤ S.outputCard := by
  have ha : a.val < b.val := hab
  have hb := b.isLt
  omega

/-- Pattern-preserving merge, with the higher selected position deleted. -/
def ppm (S : ActiveFiniteChannel alpha) (_hS : IsSingularChannel S.channel)
    (a b : Fin S.outputCard) (hab : a < b)
    (_hpattern : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) : ActiveFiniteChannel alpha where
  outputCard := S.outputCard - 1
  outputCard_pos := by have := activeMerge_two_le S a b hab; omega
  channel := mergeRaw (fun x => (S.channel x).map (mergeSourceEquiv S))
    (mergeSourceEquiv S a) (mergeSourceEquiv S b) ((mergeSourceEquiv_lt_iff S a b).mpr hab)
  output_active := by
    intro j
    obtain ⟨x, hx⟩ := mergeSourceEquiv_active S ((mergeSourceEquiv S b).succAbove j)
    refine ⟨x, ?_⟩
    rw [mergeRaw_apply_map, ← PMF.mem_support_iff, PMF.mem_support_map_iff]
    exact ⟨_, (PMF.mem_support_iff _ _).mpr hx, mergeIndex_succAbove _ _ _ j⟩

variable (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
  (a b : Fin S.outputCard) (hab : a < b)
  (hpattern : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0)

@[simp] theorem ppm_outputCard : (ppm S hS a b hab hpattern).outputCard = S.outputCard - 1 := rfl

theorem ppm_channel (x : alpha) :
    (ppm S hS a b hab hpattern).channel x =
      mergeRaw (fun x => (S.channel x).map (mergeSourceEquiv S))
        (mergeSourceEquiv S a) (mergeSourceEquiv S b)
        ((mergeSourceEquiv_lt_iff S a b).mpr hab) x := rfl

theorem ppm_channel_map (x : alpha) :
    ((ppm S hS a b hab hpattern).channel x).map
        (finCongr (ppm_outputCard S hS a b hab hpattern)) =
      mergeRaw (fun x => (S.channel x).map (mergeSourceEquiv S))
        (mergeSourceEquiv S a) (mergeSourceEquiv S b)
        ((mergeSourceEquiv_lt_iff S a b).mpr hab) x := by
  exact PMF.map_id _

theorem ppm_apply_survivor (x : alpha) :
    (ppm S hS a b hab hpattern).channel x (activeMergeSurvivor S a b hab) =
      S.channel x a + S.channel x b := by
  rw [ppm_channel]
  change mergeRaw _ _ _ _ x (mergeSurvivor _ _ _) = _
  rw [mergeRaw_survivor, mergeSourceEquiv_map_apply, mergeSourceEquiv_map_apply]

theorem ppm_apply_unaffected (x : alpha) {j : Fin (S.outputCard - 1)}
    (hj : j ≠ activeMergeSurvivor S a b hab) :
    (ppm S hS a b hab hpattern).channel x j = S.channel x (activeMergeRetained S b j) := by
  change mergeRaw (fun x => (S.channel x).map (mergeSourceEquiv S))
    (mergeSourceEquiv S a) (mergeSourceEquiv S b) _ x j = _
  rw [mergeRaw_unaffected _ _ _ _ x hj, mergeSourceEquiv_map_apply_symm]
  rfl

private theorem common_support_add_ne_zero {u v : ENNReal} (h : u ≠ 0 ↔ v ≠ 0) :
    u + v ≠ 0 ↔ u ≠ 0 := by
  by_cases hu : u = 0
  · have hv : v = 0 := by
      by_contra hv
      exact (h.mpr hv) hu
    simp [hu, hv]
  · exact iff_of_true (fun hz => hu (add_eq_zero.mp hz).1) hu

theorem ppm_isSingular : IsSingularChannel (ppm S hS a b hab hpattern).channel := by
  intro x z j hx hz
  by_cases hj : j = activeMergeSurvivor S a b hab
  · subst j
    rw [ppm_apply_survivor] at hx hz ⊢
    have hxa := (common_support_add_ne_zero (hpattern x)).mp hx
    have hza := (common_support_add_ne_zero (hpattern z)).mp hz
    rw [hS x z a hxa hza, hS x z b ((hpattern x).mp hxa) ((hpattern z).mp hza)]
    exact (ppm_apply_survivor S hS a b hab hpattern z).symm
  · rw [ppm_apply_unaffected S hS a b hab hpattern x hj] at hx ⊢
    rw [ppm_apply_unaffected S hS a b hab hpattern z hj] at hz ⊢
    exact hS _ _ _ hx hz

theorem ppm_real_survivor (x : alpha) :
    realMatrix (ppm S hS a b hab hpattern).channel x (activeMergeSurvivor S a b hab) =
      realMatrix S.channel x a + realMatrix S.channel x b := by
  change ((ppm S hS a b hab hpattern).channel x (activeMergeSurvivor S a b hab)).toReal =
    (S.channel x a).toReal + (S.channel x b).toReal
  rw [ppm_apply_survivor,
    ENNReal.toReal_add ((S.channel x).apply_ne_top a) ((S.channel x).apply_ne_top b)]

theorem ppm_real_unaffected (x : alpha) {j : Fin (S.outputCard - 1)}
    (hj : j ≠ activeMergeSurvivor S a b hab) :
    realMatrix (ppm S hS a b hab hpattern).channel x j =
      realMatrix S.channel x (activeMergeRetained S b j) := by
  change ((ppm S hS a b hab hpattern).channel x j).toReal =
    (S.channel x (activeMergeRetained S b j)).toReal
  rw [ppm_apply_unaffected S hS a b hab hpattern x hj]

theorem ppm_row_sum (x : alpha) : ∑ j, (ppm S hS a b hab hpattern).channel x j = 1 := by
  simpa only [massMatrix_apply] using massMatrix_row_sum (ppm S hS a b hab hpattern).channel x

theorem ppm_real_row_sum (x : alpha) :
    ∑ j, realMatrix (ppm S hS a b hab hpattern).channel x j = 1 :=
  realMatrix_row_sum _ _

theorem ppm_columnValue_survivor :
    columnValue (ppm S hS a b hab hpattern).channel (ppm_isSingular S hS a b hab hpattern)
        ((ppm S hS a b hab hpattern).activeEquiv (activeMergeSurvivor S a b hab)) =
      columnValue S.channel hS (S.activeEquiv a) + columnValue S.channel hS (S.activeEquiv b) := by
  obtain ⟨x, hx⟩ := S.output_active a
  have hb := (hpattern x).mp hx
  have hn : (ppm S hS a b hab hpattern).channel x (activeMergeSurvivor S a b hab) ≠ 0 := by
    rw [ppm_apply_survivor]
    exact (common_support_add_ne_zero (hpattern x)).mpr hx
  rw [columnValue_eq_of_ne_zero _ _ _ hn,
    columnValue_eq_of_ne_zero S.channel hS (S.activeEquiv a) hx,
    columnValue_eq_of_ne_zero S.channel hS (S.activeEquiv b) hb]
  exact ppm_apply_survivor S hS a b hab hpattern x

theorem ppm_columnValue_unaffected {j : Fin (S.outputCard - 1)}
    (hj : j ≠ activeMergeSurvivor S a b hab) :
    columnValue (ppm S hS a b hab hpattern).channel (ppm_isSingular S hS a b hab hpattern)
        ((ppm S hS a b hab hpattern).activeEquiv j) =
      columnValue S.channel hS (S.activeEquiv (activeMergeRetained S b j)) := by
  apply columnValue_transport S.channel (ppm S hS a b hab hpattern).channel hS
    (ppm_isSingular S hS a b hab hpattern) (S.activeEquiv (activeMergeRetained S b j))
    ((ppm S hS a b hab hpattern).activeEquiv j) (Equiv.refl alpha)
  intro x
  exact ppm_apply_unaffected S hS a b hab hpattern x hj

include hab hpattern in
theorem ppm_columnValue_sum_le_one :
    columnValue S.channel hS (S.activeEquiv a) +
      columnValue S.channel hS (S.activeEquiv b) ≤ 1 := by
  obtain ⟨x, hx⟩ := S.output_active a
  have hb := (hpattern x).mp hx
  rw [columnValue_eq_of_ne_zero S.channel hS (S.activeEquiv a) hx,
    columnValue_eq_of_ne_zero S.channel hS (S.activeEquiv b) hb]
  change S.channel x a + S.channel x b ≤ 1
  rw [← ppm_apply_survivor S hS a b hab hpattern x]
  exact ((ppm S hS a b hab hpattern).channel x).coe_le_one _

theorem ppm_columnValue_real_survivor :
    (columnValue (ppm S hS a b hab hpattern).channel (ppm_isSingular S hS a b hab hpattern)
        ((ppm S hS a b hab hpattern).activeEquiv (activeMergeSurvivor S a b hab))).toReal =
      (columnValue S.channel hS (S.activeEquiv a)).toReal +
        (columnValue S.channel hS (S.activeEquiv b)).toReal := by
  rw [ppm_columnValue_survivor,
    ENNReal.toReal_add (columnValue_ne_top _ _ _) (columnValue_ne_top _ _ _)]

theorem ppm_columnValue_real_unaffected {j : Fin (S.outputCard - 1)}
    (hj : j ≠ activeMergeSurvivor S a b hab) :
    (columnValue (ppm S hS a b hab hpattern).channel (ppm_isSingular S hS a b hab hpattern)
        ((ppm S hS a b hab hpattern).activeEquiv j)).toReal =
      (columnValue S.channel hS (S.activeEquiv (activeMergeRetained S b j))).toReal :=
  congrArg ENNReal.toReal (ppm_columnValue_unaffected S hS a b hab hpattern hj)

include hab hpattern in
theorem ppm_columnValue_real_sum_le_one :
    (columnValue S.channel hS (S.activeEquiv a)).toReal +
      (columnValue S.channel hS (S.activeEquiv b)).toReal ≤ 1 := by
  rw [← ppm_columnValue_real_survivor S hS a b hab hpattern]
  exact columnValue_toReal_le_one _ _ _

section Patterns
variable [Fintype alpha]

theorem same_support_iff_columnPattern_eq (S : ActiveFiniteChannel alpha)
    (a b : Fin S.outputCard) :
    (∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) ↔
      columnPattern S.channel (S.activeEquiv a) = columnPattern S.channel (S.activeEquiv b) := by
  constructor
  · intro h
    apply Subtype.ext
    ext x
    simp only [mem_columnPattern]
    change S.channel x a ≠ 0 ↔ S.channel x b ≠ 0
    exact h x
  · intro h x
    have hm : x ∈ (columnPattern S.channel (S.activeEquiv a)).val ↔
        x ∈ (columnPattern S.channel (S.activeEquiv b)).val := by rw [h]
    simp only [mem_columnPattern] at hm
    change S.channel x a ≠ 0 ↔ S.channel x b ≠ 0 at hm
    exact hm

theorem ppm_columnPattern_survivor :
    columnPattern (ppm S hS a b hab hpattern).channel
        ((ppm S hS a b hab hpattern).activeEquiv (activeMergeSurvivor S a b hab)) =
      columnPattern S.channel (S.activeEquiv a) := by
  apply Subtype.ext
  ext x
  simp only [mem_columnPattern]
  change (ppm S hS a b hab hpattern).channel x (activeMergeSurvivor S a b hab) ≠ 0 ↔
    S.channel x a ≠ 0
  rw [ppm_apply_survivor]
  exact common_support_add_ne_zero (hpattern x)

theorem ppm_columnPattern_unaffected {j : Fin (S.outputCard - 1)}
    (hj : j ≠ activeMergeSurvivor S a b hab) :
    columnPattern (ppm S hS a b hab hpattern).channel ((ppm S hS a b hab hpattern).activeEquiv j) =
      columnPattern S.channel (S.activeEquiv (activeMergeRetained S b j)) := by
  apply Subtype.ext
  ext x
  simp only [mem_columnPattern]
  change (ppm S hS a b hab hpattern).channel x j ≠ 0 ↔ S.channel x (activeMergeRetained S b j) ≠ 0
  rw [ppm_apply_unaffected S hS a b hab hpattern x hj]

end Patterns
end
end PerfectFunctionalRepresentations.MatrixOperations

namespace PerfectFunctionalRepresentations.MatrixOperations
open scoped ENNReal
noncomputable section
universe u
variable {alpha : Type u} {n m : Nat}

private theorem adjacent_survivor (l : Fin n) :
    mergeSurvivor (splitLeft l) (splitRight l) (by simp [splitLeft, splitRight]) = l := by
  apply Fin.ext
  exact mergeSurvivor_val l.castSucc l.succ Fin.castSucc_lt_succ

theorem mergeRaw_ppsRaw (K : alpha → PMF (Fin n)) (l : Fin n)
    (t : NNReal) (ht : t ≤ 1) (x : alpha) :
    mergeRaw (ppsRaw K l t ht) (splitLeft l) (splitRight l)
      (by simp [splitLeft, splitRight]) x = K x := by
  apply PMF.ext
  intro j
  by_cases hj : j = l
  · subst j
    have h := mergeRaw_survivor (ppsRaw K l t ht) (splitLeft l) (splitRight l)
      (by simp [splitLeft, splitRight]) x
    rw [adjacent_survivor, ppsRaw_left, ppsRaw_right] at h
    rw [h, ← add_mul, ← ENNReal.coe_add,
      add_tsub_cancel_of_le ht]
    simp
  · rw [mergeRaw_unaffected (ppsRaw K l t ht) (splitLeft l) (splitRight l)
      (by simp [splitLeft, splitRight]) x (by simpa only [adjacent_survivor] using hj)]
    exact ppsRaw_keep K l t ht x hj

private theorem split_merge_map (K : alpha → PMF (Fin (m + 1)))
    (a b : Fin (m + 1)) (hab : a < b) (t : NNReal) (ht : t ≤ 1)
    (hl : ∀ x, (t : ENNReal) * (K x a + K x b) = K x a)
    (hr : ∀ x, ((1 - t : NNReal) : ENNReal) * (K x a + K x b) = K x b)
    (x : alpha) :
    (ppsRaw (mergeRaw K a b hab) (mergeSurvivor a b hab) t ht x).map
      (recoveryPerm a b hab) = K x := by
  apply PMF.ext
  intro y
  obtain ⟨z, rfl⟩ := (recoveryPerm a b hab).surjective y
  rw [PMF.map_apply_equiv]
  rcases split_cases (mergeSurvivor a b hab) z with rfl | ⟨j, rfl⟩
  · rw [ppsRaw_right, mergeRaw_survivor]
    exact (hr x).trans (congrArg (K x) (recoveryPerm_right a b hab).symm)
  · by_cases hj : j = mergeSurvivor a b hab
    · subst j
      rw [splitKeep_self, ppsRaw_left, mergeRaw_survivor]
      exact (hl x).trans (congrArg (K x) (recoveryPerm_left a b hab).symm)
    · rw [ppsRaw_keep _ _ _ _ _ hj, mergeRaw_unaffected _ _ _ _ _ hj]
      exact congrArg (K x) (recoveryPerm_keep a b hab j).symm

private theorem recovery_ratio_facts (u v : ENNReal) (hu : 0 < u) (hv : 0 < v)
    (hu_top : u ≠ ∞) (hv_top : v ≠ ∞) :
    0 < (u + v).toNNReal ∧ (u + v) ≠ ∞ ∧
    0 < u.toNNReal / (u + v).toNNReal ∧
    u.toNNReal / (u + v).toNNReal < 1 ∧
    ((u.toNNReal / (u + v).toNNReal : NNReal) : ENNReal) * (u + v) = u ∧
    ((1 - u.toNNReal / (u + v).toNNReal : NNReal) : ENNReal) * (u + v) = v := by
  have hu' := ENNReal.toNNReal_pos (ne_of_gt hu) hu_top
  have hv' := ENNReal.toNNReal_pos (ne_of_gt hv) hv_top
  have hsum : (u + v).toNNReal = u.toNNReal + v.toNNReal :=
    ENNReal.toNNReal_add hu_top hv_top
  have hs : 0 < u.toNNReal + v.toNNReal := add_pos hu' hv'
  have hlt : u.toNNReal / (u.toNNReal + v.toNNReal) < 1 :=
    (div_lt_one hs).mpr (lt_add_of_pos_right _ hv')
  have hprod : u.toNNReal / (u.toNNReal + v.toNNReal) *
      (u.toNNReal + v.toNNReal) = u.toNNReal := div_mul_cancel₀ _ (ne_of_gt hs)
  have hcomp : (1 - u.toNNReal / (u.toNNReal + v.toNNReal)) *
      (u.toNNReal + v.toNNReal) = v.toNNReal := by
    rw [tsub_mul, one_mul, hprod, add_tsub_cancel_left]
  refine ⟨by rwa [hsum], ENNReal.add_ne_top.mpr ⟨hu_top, hv_top⟩,
    by rw [hsum]; exact div_pos hu' hs, by rwa [hsum], ?_, ?_⟩
  · have h := congrArg (fun z : NNReal => (z : ENNReal)) hprod
    simpa only [← hsum, ENNReal.coe_mul, ENNReal.coe_toNNReal hu_top,
      ENNReal.coe_toNNReal (ENNReal.add_ne_top.mpr ⟨hu_top, hv_top⟩)] using h
  · have h := congrArg (fun z : NNReal => (z : ENNReal)) hcomp
    simpa only [← hsum, ENNReal.coe_mul, ENNReal.coe_toNNReal hv_top,
      ENNReal.coe_toNNReal (ENNReal.add_ne_top.mpr ⟨hu_top, hv_top⟩)] using h

end
end PerfectFunctionalRepresentations.MatrixOperations

namespace PerfectFunctionalRepresentations.MatrixOperations
open scoped ENNReal
noncomputable section
universe u
variable {alpha : Type u}

section PPRatio
variable [Finite alpha] [Nonempty alpha]

/-- Recover the first split weight from the two original admitted column values.
The original values are remembered witnesses, not determined by the merged row. -/
def ppmRatio (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (a b : Fin S.outputCard) : NNReal :=
  (columnValue S.channel hS (S.activeEquiv a)).toNNReal /
    (columnValue S.channel hS (S.activeEquiv a) +
      columnValue S.channel hS (S.activeEquiv b)).toNNReal

private theorem ppmRatio_facts (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (a b : Fin S.outputCard) :
    let u := columnValue S.channel hS (S.activeEquiv a)
    let v := columnValue S.channel hS (S.activeEquiv b)
    0 < (u + v).toNNReal ∧ (u + v) ≠ ∞ ∧
    0 < u.toNNReal / (u + v).toNNReal ∧ u.toNNReal / (u + v).toNNReal < 1 ∧
    ((u.toNNReal / (u + v).toNNReal : NNReal) : ENNReal) * (u + v) = u ∧
    ((1 - u.toNNReal / (u + v).toNNReal : NNReal) : ENNReal) * (u + v) = v :=
  recovery_ratio_facts
    (columnValue S.channel hS (S.activeEquiv a))
    (columnValue S.channel hS (S.activeEquiv b))
    (columnValue_pos _ _ _) (columnValue_pos _ _ _)
    (columnValue_ne_top _ _ _) (columnValue_ne_top _ _ _)

theorem ppmRatio_denominator_pos (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (a b : Fin S.outputCard) :
    0 < (columnValue S.channel hS (S.activeEquiv a) +
      columnValue S.channel hS (S.activeEquiv b)).toNNReal :=
  (ppmRatio_facts S hS a b).1

theorem ppmRatio_denominator_ne_top (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (a b : Fin S.outputCard) :
    columnValue S.channel hS (S.activeEquiv a) +
      columnValue S.channel hS (S.activeEquiv b) ≠ ∞ :=
  (ppmRatio_facts S hS a b).2.1

theorem ppmRatio_pos (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (a b : Fin S.outputCard) :
    0 < ppmRatio S hS a b := (ppmRatio_facts S hS a b).2.2.1

theorem ppmRatio_lt_one (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (a b : Fin S.outputCard) :
    ppmRatio S hS a b < 1 := (ppmRatio_facts S hS a b).2.2.2.1

theorem ppmRatio_mul_sum (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (a b : Fin S.outputCard) :
    (ppmRatio S hS a b : ENNReal) *
      (columnValue S.channel hS (S.activeEquiv a) +
        columnValue S.channel hS (S.activeEquiv b)) =
      columnValue S.channel hS (S.activeEquiv a) :=
  (ppmRatio_facts S hS a b).2.2.2.2.1

theorem ppmRatio_complement_mul_sum (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (a b : Fin S.outputCard) :
    ((1 - ppmRatio S hS a b : NNReal) : ENNReal) *
      (columnValue S.channel hS (S.activeEquiv a) +
        columnValue S.channel hS (S.activeEquiv b)) =
      columnValue S.channel hS (S.activeEquiv b) :=
  (ppmRatio_facts S hS a b).2.2.2.2.2

/-- The exact NNReal ratio is the printed Real ratio. -/
theorem ppmRatio_toReal (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (a b : Fin S.outputCard) :
    (ppmRatio S hS a b : ℝ) =
      (columnValue S.channel hS (S.activeEquiv a)).toReal /
      ((columnValue S.channel hS (S.activeEquiv a)).toReal +
        (columnValue S.channel hS (S.activeEquiv b)).toReal) := by
  simp only [ppmRatio, NNReal.coe_div, ENNReal.coe_toNNReal_eq_toReal,
    ENNReal.toReal_add (columnValue_ne_top _ _ _) (columnValue_ne_top _ _ _)]

private theorem ppmRatio_row_products (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (a b : Fin S.outputCard)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) (x : alpha) :
    (ppmRatio S hS a b : ENNReal) * (S.channel x a + S.channel x b) = S.channel x a ∧
    ((1 - ppmRatio S hS a b : NNReal) : ENNReal) *
      (S.channel x a + S.channel x b) = S.channel x b := by
  by_cases ha : S.channel x a = 0
  · have hb : S.channel x b = 0 := by
      by_contra hb
      exact (hp x).mpr hb ha
    simp [ha, hb]
  · have hb := (hp x).mp ha
    have hu := columnValue_eq_of_ne_zero S.channel hS (S.activeEquiv a) ha
    have hv := columnValue_eq_of_ne_zero S.channel hS (S.activeEquiv b) hb
    change columnValue S.channel hS (S.activeEquiv a) = S.channel x a at hu
    change columnValue S.channel hS (S.activeEquiv b) = S.channel x b at hv
    rw [← hu, ← hv]
    exact ⟨ppmRatio_mul_sum S hS a b, ppmRatio_complement_mul_sum S hS a b⟩

end PPRatio

end
end PerfectFunctionalRepresentations.MatrixOperations

namespace PerfectFunctionalRepresentations.MatrixOperations
open scoped ENNReal
noncomputable section
universe u
variable {alpha : Type u}

section PPRecovery
variable [Finite alpha] [Nonempty alpha]

theorem pps_channel_map (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (l : Fin S.outputCard)
    (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1) (x : alpha) :
    ((pps S hS l t ht0 ht1).channel x).map
      (finCongr (pps_outputCard S hS l t ht0 ht1)) = ppsRaw S.channel l t ht1.le x :=
  PMF.map_id _

theorem ppmRatio_pps (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (l : Fin S.outputCard)
    (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1) :
    ppmRatio (pps S hS l t ht0 ht1) (pps_isSingular S hS l t ht0 ht1)
      (splitLeft l) (splitRight l) = t := by
  unfold ppmRatio
  rw [columnValue_pps_left S hS l t ht0 ht1,
    columnValue_pps_right S hS l t ht0 ht1, ← add_mul, ← ENNReal.coe_add,
    add_tsub_cancel_of_le ht1.le, ENNReal.coe_one, one_mul, ENNReal.toNNReal_mul]
  simp only [ENNReal.toNNReal_coe]
  exact mul_div_cancel_right₀ t (ne_of_gt (ENNReal.toNNReal_pos
    (ne_of_gt (columnValue_pos _ _ _)) (columnValue_ne_top _ _ _)))

/-- Legal adjacent PPM of the two PPS children, remembering the original ratio. -/
def ppsRecovery (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1) :
    ActiveFiniteChannel alpha :=
  ppm (pps S hS l t ht0 ht1) (pps_isSingular S hS l t ht0 ht1)
    (splitLeft l) (splitRight l) (by exact Fin.castSucc_lt_succ)
    (pps_children_sameSupport S hS l t ht0 ht1)

@[simp] theorem ppsRecovery_outputCard (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (l : Fin S.outputCard)
    (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1) :
    (ppsRecovery S hS l t ht0 ht1).outputCard = S.outputCard := rfl

theorem ppsRecovery_channel (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (l : Fin S.outputCard)
    (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1) (x : alpha) :
    ((ppsRecovery S hS l t ht0 ht1).channel x).map
      (finCongr (ppsRecovery_outputCard S hS l t ht0 ht1)) = S.channel x := by
  change (mergeRaw (fun x => (ppsRaw S.channel l t ht1.le x).map id)
    (splitLeft l) (splitRight l) _ x).map id = S.channel x
  simpa only [PMF.map_id] using mergeRaw_ppsRaw S.channel l t ht1.le x

/-- Legal PPS after PPM, with the ratio computed from the original two values. -/
def ppmRecovery (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) : ActiveFiniteChannel alpha :=
  pps (ppm S hS a b hab hp) (ppm_isSingular S hS a b hab hp)
    (activeMergeSurvivor S a b hab) (ppmRatio S hS a b)
    (ppmRatio_pos S hS a b) (ppmRatio_lt_one S hS a b)

theorem ppmRecovery_outputCard (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) :
    (ppmRecovery S hS a b hab hp).outputCard = S.outputCard := (mergeSource_card S).symm

theorem ppmRecovery_left (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) (x : alpha) :
    (ppmRecovery S hS a b hab hp).channel x (splitLeft (activeMergeSurvivor S a b hab)) =
      S.channel x a := by
  calc
    _ = (ppmRatio S hS a b : ENNReal) *
        (ppm S hS a b hab hp).channel x (activeMergeSurvivor S a b hab) :=
      pps_left _ _ _ _ _ _ x
    _ = _ := by
      rw [ppm_apply_survivor]
      exact (ppmRatio_row_products S hS a b hp x).1

theorem ppmRecovery_right (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) (x : alpha) :
    (ppmRecovery S hS a b hab hp).channel x (splitRight (activeMergeSurvivor S a b hab)) =
      S.channel x b := by
  calc
    _ = ((1 - ppmRatio S hS a b : NNReal) : ENNReal) *
        (ppm S hS a b hab hp).channel x (activeMergeSurvivor S a b hab) :=
      pps_right _ _ _ _ _ _ x
    _ = _ := by
      rw [ppm_apply_survivor]
      exact (ppmRatio_row_products S hS a b hp x).2

theorem ppmRecovery_keep (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) (x : alpha)
    {j : Fin (S.outputCard - 1)} (hj : j ≠ activeMergeSurvivor S a b hab) :
    (ppmRecovery S hS a b hab hp).channel x (splitKeep (activeMergeSurvivor S a b hab) j) =
      S.channel x (activeMergeRetained S b j) := by
  exact (pps_keep (ppm S hS a b hab hp) (ppm_isSingular S hS a b hab hp)
    _ _ _ _ x hj).trans (ppm_apply_unaffected S hS a b hab hp x hj)

/-- The explicit new-to-original equivalence, including cardinality transport. -/
def ppmRecoveryEquiv (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) :
    Fin (ppmRecovery S hS a b hab hp).outputCard ≃ Fin S.outputCard :=
  (finCongr (ppmRecovery_outputCard S hS a b hab hp)).trans (recoveryPerm a b hab)

private theorem ppmRecoveryEquiv_transport (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) :
    (fun z => (mergeSourceEquiv S).symm
      (recoveryPerm (mergeSourceEquiv S a) (mergeSourceEquiv S b)
        ((mergeSourceEquiv_lt_iff S a b).mpr hab) z)) =
      ppmRecoveryEquiv S hS a b hab hp := by
  funext z
  apply Fin.ext
  change ((mergeSourceEquiv S).symm
    (recoveryPerm (mergeSourceEquiv S a) (mergeSourceEquiv S b) _ z)).val =
    (recoveryPerm a b hab (finCongr (ppmRecovery_outputCard S hS a b hab hp) z)).val
  simp only [mergeSourceEquiv_symm_val, recoveryPerm_val, mergeSourceEquiv_val]
  rfl

theorem ppmRecovery_channel (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) (x : alpha) :
    ((ppmRecovery S hS a b hab hp).channel x).map
      (ppmRecoveryEquiv S hS a b hab hp) = S.channel x := by
  have h := split_merge_map (fun x => (S.channel x).map (mergeSourceEquiv S))
    (mergeSourceEquiv S a) (mergeSourceEquiv S b)
    ((mergeSourceEquiv_lt_iff S a b).mpr hab) (ppmRatio S hS a b)
    (ppmRatio_lt_one S hS a b).le
    (fun x => by simpa only [mergeSourceEquiv_map_apply] using
      (ppmRatio_row_products S hS a b hp x).1)
    (fun x => by simpa only [mergeSourceEquiv_map_apply] using
      (ppmRatio_row_products S hS a b hp x).2) x
  have hh := congrArg (fun p => p.map (mergeSourceEquiv S).symm) h
  rw [PMF.map_comp, PMF.map_comp] at hh
  have hid : (mergeSourceEquiv S).symm ∘ mergeSourceEquiv S = id :=
    funext (mergeSourceEquiv S).symm_apply_apply
  rw [hid, PMF.map_id] at hh
  change ((ppmRecovery S hS a b hab hp).channel x).map
    (fun z => (mergeSourceEquiv S).symm
      (recoveryPerm (mergeSourceEquiv S a) (mergeSourceEquiv S b) _ z)) = _ at hh
  rwa [ppmRecoveryEquiv_transport] at hh

/-- The inverse direction maps the original row into the recovered ordering. -/
theorem ppmRecovery_channel_inverse (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) (x : alpha) :
    (S.channel x).map (ppmRecoveryEquiv S hS a b hab hp).symm =
      (ppmRecovery S hS a b hab hp).channel x := by
  rw [← ppmRecovery_channel S hS a b hab hp x, PMF.map_comp]
  have hid : (ppmRecoveryEquiv S hS a b hab hp).symm ∘
      ppmRecoveryEquiv S hS a b hab hp = id :=
    funext (ppmRecoveryEquiv S hS a b hab hp).symm_apply_apply
  rw [hid, PMF.map_id]

theorem ppmRecovery_reindex (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) (x : alpha) :
    (((ppmRecovery S hS a b hab hp).channel x).map
      (finCongr (ppmRecovery_outputCard S hS a b hab hp))).map
      (recoveryPerm a b hab) = S.channel x := by
  rw [PMF.map_comp]
  exact ppmRecovery_channel S hS a b hab hp x

theorem ppmRecovery_reindex_inverse (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) (x : alpha) :
    (S.channel x).map (recoveryPerm a b hab).symm =
      ((ppmRecovery S hS a b hab hp).channel x).map
        (finCongr (ppmRecovery_outputCard S hS a b hab hp)) := by
  rw [← ppmRecovery_reindex S hS a b hab hp x, PMF.map_comp]
  have hid : (recoveryPerm a b hab).symm ∘ recoveryPerm a b hab = id :=
    funext (recoveryPerm a b hab).symm_apply_apply
  rw [hid, PMF.map_id]

theorem ppmRecovery_adjacent (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0)
    (hadj : b.val = a.val + 1) (x : alpha) :
    ((ppmRecovery S hS a b hab hp).channel x).map
      (finCongr (ppmRecovery_outputCard S hS a b hab hp)) = S.channel x := by
  have h := ppmRecovery_reindex S hS a b hab hp x
  rw [recoveryPerm_adjacent a b hab hadj] at h
  exact (PMF.map_id _).symm.trans h

end PPRecovery

end
end PerfectFunctionalRepresentations.MatrixOperations

namespace PerfectFunctionalRepresentations.MatrixOperations

open scoped BigOperators ENNReal

universe u

noncomputable section
attribute [local instance] Classical.propDecidable

/-- A raw value-preserving split depends on the mask only on the selected support. -/
theorem vpsRaw_mask_irrelevant {alpha : Type u} {n : Nat}
    (K : alpha → PMF (Fin n)) (l : Fin n) (mask mask' : alpha → Bool)
    (hmask : ∀ x, K x l ≠ 0 → mask x = mask' x) :
    vpsRaw K l mask = vpsRaw K l mask' := by
  funext x
  apply PMF.ext
  intro j
  rcases split_cases l j with rfl | ⟨k, rfl⟩
  · rw [vpsRaw_right, vpsRaw_right]
    by_cases hx : K x l = 0
    · simp only [hx, ite_self]
    · rw [hmask x hx]
  · by_cases hk : k = l
    · subst k
      rw [splitKeep_self, vpsRaw_left, vpsRaw_left]
      by_cases hx : K x l = 0
      · simp only [hx, ite_self]
      · rw [hmask x hx]
    · rw [vpsRaw_keep K l mask x hk, vpsRaw_keep K l mask' x hk]

variable {alpha : Type u} [Finite alpha] [Nonempty alpha]

/-- Legal value-preserving split. Both witnesses concern the selected support;
the admitted value may be one, under the approved interpretation of Section III-A. -/
def vps (S : ActiveFiniteChannel alpha) (_hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (mask : alpha → Bool)
    (hleft : ∃ x, S.channel x l ≠ 0 ∧ mask x = true)
    (hright : ∃ x, S.channel x l ≠ 0 ∧ mask x = false) : ActiveFiniteChannel alpha where
  outputCard := S.outputCard + 1
  outputCard_pos := Nat.succ_pos _
  channel := vpsRaw S.channel l mask
  output_active := by
    intro j
    rcases split_cases l j with rfl | ⟨k, rfl⟩
    · obtain ⟨x, hx, hm⟩ := hright
      refine ⟨x, ?_⟩
      rw [vpsRaw_right, hm]
      exact hx
    · by_cases hk : k = l
      · subst k
        obtain ⟨x, hx, hm⟩ := hleft
        refine ⟨x, ?_⟩
        rw [splitKeep_self, vpsRaw_left, hm]
        exact hx
      · obtain ⟨x, hx⟩ := S.output_active k
        exact ⟨x, by rw [vpsRaw_keep S.channel l mask x hk]; exact hx⟩

variable (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
  (l : Fin S.outputCard) (mask : alpha → Bool)
  (hleft : ∃ x, S.channel x l ≠ 0 ∧ mask x = true)
  (hright : ∃ x, S.channel x l ≠ 0 ∧ mask x = false)

@[simp] theorem vps_outputCard :
    (vps S hS l mask hleft hright).outputCard = S.outputCard + 1 := rfl

theorem vps_channel (x : alpha) :
    (vps S hS l mask hleft hright).channel x = vpsRaw S.channel l mask x := rfl

/-- The deterministic output map depends on the input row. -/
theorem vps_apply_map (x : alpha) :
    (vps S hS l mask hleft hright).channel x = (S.channel x).map (vpsIndex l (mask x)) := rfl

/-- Cardinality transport maps the returned labels to the advertised split labels. -/
theorem vps_channel_map (x : alpha) :
    ((vps S hS l mask hleft hright).channel x).map
        (finCongr (vps_outputCard S hS l mask hleft hright)) = vpsRaw S.channel l mask x :=
  PMF.map_id _

theorem vps_left (x : alpha) :
    (vps S hS l mask hleft hright).channel x (splitLeft l) =
      if mask x then S.channel x l else 0 :=
  vpsRaw_left S.channel l mask x

theorem vps_right (x : alpha) :
    (vps S hS l mask hleft hright).channel x (splitRight l) =
      if mask x then 0 else S.channel x l :=
  vpsRaw_right S.channel l mask x

theorem vps_keep (x : alpha) {j : Fin S.outputCard} (hj : j ≠ l) :
    (vps S hS l mask hleft hright).channel x (splitKeep l j) = S.channel x j :=
  vpsRaw_keep S.channel l mask x hj

theorem vps_left_ne_zero_iff (x : alpha) :
    (vps S hS l mask hleft hright).channel x (splitLeft l) ≠ 0 ↔
      S.channel x l ≠ 0 ∧ mask x = true := by
  rw [vps_left]
  cases mask x <;> simp

theorem vps_right_ne_zero_iff (x : alpha) :
    (vps S hS l mask hleft hright).channel x (splitRight l) ≠ 0 ↔
      S.channel x l ≠ 0 ∧ mask x = false := by
  rw [vps_right]
  cases mask x <;> simp

/-- The two children have disjoint pointwise input supports. -/
theorem vps_children_disjoint (x : alpha)
    (hx : (vps S hS l mask hleft hright).channel x (splitLeft l) ≠ 0) :
    (vps S hS l mask hleft hright).channel x (splitRight l) = 0 := by
  have hm := ((vps_left_ne_zero_iff S hS l mask hleft hright x).mp hx).2
  rw [vps_right, hm]
  rfl

theorem vps_children_support_union (x : alpha) :
    ((vps S hS l mask hleft hright).channel x (splitLeft l) ≠ 0 ∨
      (vps S hS l mask hleft hright).channel x (splitRight l) ≠ 0) ↔
      S.channel x l ≠ 0 := by
  rw [vps_left_ne_zero_iff, vps_right_ne_zero_iff]
  cases mask x <;> simp

theorem vps_isSingular : IsSingularChannel (vps S hS l mask hleft hright).channel := by
  intro x z j hx hz
  rcases split_cases l j with rfl | ⟨k, rfl⟩
  · obtain ⟨hxs, hxm⟩ := (vps_right_ne_zero_iff S hS l mask hleft hright x).mp hx
    obtain ⟨hzs, hzm⟩ := (vps_right_ne_zero_iff S hS l mask hleft hright z).mp hz
    rw [vps_right, vps_right, hxm, hzm]
    exact hS x z l hxs hzs
  · by_cases hk : k = l
    · subst k
      rw [splitKeep_self] at hx hz ⊢
      obtain ⟨hxs, hxm⟩ := (vps_left_ne_zero_iff S hS l mask hleft hright x).mp hx
      obtain ⟨hzs, hzm⟩ := (vps_left_ne_zero_iff S hS l mask hleft hright z).mp hz
      rw [vps_left, vps_left, hxm, hzm]
      exact hS x z l hxs hzs
    · rw [vps_keep S hS l mask hleft hright x hk] at hx ⊢
      rw [vps_keep S hS l mask hleft hright z hk] at hz ⊢
      exact hS x z k hx hz

theorem vps_real_left (x : alpha) :
    realMatrix (vps S hS l mask hleft hright).channel x (splitLeft l) =
      if mask x then realMatrix S.channel x l else 0 :=
  vpsRaw_real_left S.channel l mask x

theorem vps_real_right (x : alpha) :
    realMatrix (vps S hS l mask hleft hright).channel x (splitRight l) =
      if mask x then 0 else realMatrix S.channel x l :=
  vpsRaw_real_right S.channel l mask x

theorem vps_real_keep (x : alpha) {j : Fin S.outputCard} (hj : j ≠ l) :
    realMatrix (vps S hS l mask hleft hright).channel x (splitKeep l j) =
      realMatrix S.channel x j :=
  vpsRaw_real_keep S.channel l mask x hj

theorem vps_row_sum (x : alpha) :
    ∑ y, (vps S hS l mask hleft hright).channel x y = 1 :=
  vpsRaw_row_sum S.channel l mask x

theorem vps_real_row_sum (x : alpha) :
    ∑ y, realMatrix (vps S hS l mask hleft hright).channel x y = 1 :=
  vpsRaw_real_row_sum S.channel l mask x

theorem columnValue_vps_left :
    columnValue (vps S hS l mask hleft hright).channel
        (vps_isSingular S hS l mask hleft hright)
        ((vps S hS l mask hleft hright).activeEquiv (splitLeft l)) =
      columnValue S.channel hS (S.activeEquiv l) := by
  have hex := hleft
  obtain ⟨x, hx, hm⟩ := hex
  have ho := (vps_left_ne_zero_iff S hS l mask hleft hright x).mpr ⟨hx, hm⟩
  rw [columnValue_eq_of_ne_zero _ _ _ ho, columnValue_eq_of_ne_zero _ _ _ hx]
  change (vps S hS l mask hleft hright).channel x (splitLeft l) = S.channel x l
  exact (vps_left S hS l mask hleft hright x).trans (by simp [hm])

theorem columnValue_vps_right :
    columnValue (vps S hS l mask hleft hright).channel
        (vps_isSingular S hS l mask hleft hright)
        ((vps S hS l mask hleft hright).activeEquiv (splitRight l)) =
      columnValue S.channel hS (S.activeEquiv l) := by
  have hex := hright
  obtain ⟨x, hx, hm⟩ := hex
  have ho := (vps_right_ne_zero_iff S hS l mask hleft hright x).mpr ⟨hx, hm⟩
  rw [columnValue_eq_of_ne_zero _ _ _ ho, columnValue_eq_of_ne_zero _ _ _ hx]
  change (vps S hS l mask hleft hright).channel x (splitRight l) = S.channel x l
  exact (vps_right S hS l mask hleft hright x).trans (by simp [hm])

theorem columnValue_vps_keep {j : Fin S.outputCard} (hj : j ≠ l) :
    columnValue (vps S hS l mask hleft hright).channel
        (vps_isSingular S hS l mask hleft hright)
        ((vps S hS l mask hleft hright).activeEquiv (splitKeep l j)) =
      columnValue S.channel hS (S.activeEquiv j) := by
  apply columnValue_transport S.channel (vps S hS l mask hleft hright).channel hS
    (vps_isSingular S hS l mask hleft hright) (S.activeEquiv j)
    ((vps S hS l mask hleft hright).activeEquiv (splitKeep l j)) (Equiv.refl alpha)
  intro x
  exact vps_keep S hS l mask hleft hright x hj

theorem columnValue_vps_left_toReal :
    (columnValue (vps S hS l mask hleft hright).channel
        (vps_isSingular S hS l mask hleft hright)
        ((vps S hS l mask hleft hright).activeEquiv (splitLeft l))).toReal =
      (columnValue S.channel hS (S.activeEquiv l)).toReal :=
  congrArg ENNReal.toReal (columnValue_vps_left S hS l mask hleft hright)

theorem columnValue_vps_right_toReal :
    (columnValue (vps S hS l mask hleft hright).channel
        (vps_isSingular S hS l mask hleft hright)
        ((vps S hS l mask hleft hright).activeEquiv (splitRight l))).toReal =
      (columnValue S.channel hS (S.activeEquiv l)).toReal :=
  congrArg ENNReal.toReal (columnValue_vps_right S hS l mask hleft hright)

theorem columnValue_vps_keep_toReal {j : Fin S.outputCard} (hj : j ≠ l) :
    (columnValue (vps S hS l mask hleft hright).channel
        (vps_isSingular S hS l mask hleft hright)
        ((vps S hS l mask hleft hright).activeEquiv (splitKeep l j))).toReal =
      (columnValue S.channel hS (S.activeEquiv j)).toReal :=
  congrArg ENNReal.toReal (columnValue_vps_keep S hS l mask hleft hright hj)

/-- The support indicators partition the original support, including zero rows. -/
theorem vps_support_indicator_sum (x : alpha) :
    (if (vps S hS l mask hleft hright).channel x (splitLeft l) ≠ 0 then (1 : ℝ) else 0) +
      (if (vps S hS l mask hleft hright).channel x (splitRight l) ≠ 0 then 1 else 0) =
      if S.channel x l ≠ 0 then 1 else 0 := by
  simp only [vps_left_ne_zero_iff, vps_right_ne_zero_iff]
  cases mask x <;> simp

/-- The first divided Real column is the original indicator times the mask. -/
theorem vps_indicator_left (x : alpha) :
    realMatrix (vps S hS l mask hleft hright).channel x (splitLeft l) /
        (columnValue (vps S hS l mask hleft hright).channel
          (vps_isSingular S hS l mask hleft hright)
          ((vps S hS l mask hleft hright).activeEquiv (splitLeft l))).toReal =
      (realMatrix S.channel x l / (columnValue S.channel hS (S.activeEquiv l)).toReal) *
        (if mask x then 1 else 0) := by
  rw [columnValue_vps_left, vps_real_left]
  cases mask x <;> simp

/-- The second divided Real column uses the complementary Boolean indicator. -/
theorem vps_indicator_right (x : alpha) :
    realMatrix (vps S hS l mask hleft hright).channel x (splitRight l) /
        (columnValue (vps S hS l mask hleft hright).channel
          (vps_isSingular S hS l mask hleft hright)
          ((vps S hS l mask hleft hright).activeEquiv (splitRight l))).toReal =
      (realMatrix S.channel x l / (columnValue S.channel hS (S.activeEquiv l)).toReal) *
        (1 - (if mask x then 1 else 0)) := by
  rw [columnValue_vps_right, vps_real_right]
  cases mask x <;> simp

/-- Definition 4's divided Real columns give the same indicator partition. -/
theorem vps_indicator_sum (x : alpha) :
    realMatrix (vps S hS l mask hleft hright).channel x (splitLeft l) /
        (columnValue (vps S hS l mask hleft hright).channel
          (vps_isSingular S hS l mask hleft hright)
          ((vps S hS l mask hleft hright).activeEquiv (splitLeft l))).toReal +
      realMatrix (vps S hS l mask hleft hright).channel x (splitRight l) /
        (columnValue (vps S hS l mask hleft hright).channel
          (vps_isSingular S hS l mask hleft hright)
          ((vps S hS l mask hleft hright).activeEquiv (splitRight l))).toReal =
      realMatrix S.channel x l / (columnValue S.channel hS (S.activeEquiv l)).toReal := by
  rw [columnValue_vps_left, columnValue_vps_right, vps_real_left, vps_real_right]
  cases mask x <;> simp

theorem vps_mask_irrelevant (mask' : alpha → Bool)
    (hleft' : ∃ x, S.channel x l ≠ 0 ∧ mask' x = true)
    (hright' : ∃ x, S.channel x l ≠ 0 ∧ mask' x = false)
    (hmask : ∀ x, S.channel x l ≠ 0 → mask x = mask' x) :
    (vps S hS l mask hleft hright).channel = (vps S hS l mask' hleft' hright').channel :=
  vpsRaw_mask_irrelevant S.channel l mask mask' hmask

section Patterns
variable [Fintype alpha]

/-- The pointwise legal witness is exactly nonemptiness of the filtered C06 pattern. -/
theorem vps_witness_iff_filter_nonempty (S : ActiveFiniteChannel alpha)
    (l : Fin S.outputCard) (mask : alpha → Bool) (b : Bool) :
    (∃ x, S.channel x l ≠ 0 ∧ mask x = b) ↔
      ((columnPattern S.channel (S.activeEquiv l)).val.filter (fun x => mask x = b)).Nonempty := by
  simp only [Finset.filter_nonempty_iff, mem_columnPattern]
  rfl

theorem columnPattern_vps_left :
    (columnPattern (vps S hS l mask hleft hright).channel
        ((vps S hS l mask hleft hright).activeEquiv (splitLeft l))).val =
      (columnPattern S.channel (S.activeEquiv l)).val.filter (fun x => mask x = true) := by
  ext x
  simp only [mem_columnPattern, Finset.mem_filter]
  exact vps_left_ne_zero_iff S hS l mask hleft hright x

theorem columnPattern_vps_right :
    (columnPattern (vps S hS l mask hleft hright).channel
        ((vps S hS l mask hleft hright).activeEquiv (splitRight l))).val =
      (columnPattern S.channel (S.activeEquiv l)).val.filter (fun x => mask x = false) := by
  ext x
  simp only [mem_columnPattern, Finset.mem_filter]
  exact vps_right_ne_zero_iff S hS l mask hleft hright x

theorem columnPattern_vps_keep {j : Fin S.outputCard} (hj : j ≠ l) :
    columnPattern (vps S hS l mask hleft hright).channel
        ((vps S hS l mask hleft hright).activeEquiv (splitKeep l j)) =
      columnPattern S.channel (S.activeEquiv j) := by
  apply Subtype.ext
  ext x
  simp only [mem_columnPattern]
  change (vps S hS l mask hleft hright).channel x (splitKeep l j) ≠ 0 ↔ S.channel x j ≠ 0
  rw [vps_keep S hS l mask hleft hright x hj]

theorem columnPattern_vps_disjoint :
    Disjoint (columnPattern (vps S hS l mask hleft hright).channel
        ((vps S hS l mask hleft hright).activeEquiv (splitLeft l))).val
      (columnPattern (vps S hS l mask hleft hright).channel
        ((vps S hS l mask hleft hright).activeEquiv (splitRight l))).val := by
  apply Finset.disjoint_left.mpr
  intro x hx hz
  exact ((mem_columnPattern _ _ x).mp hz)
    (vps_children_disjoint S hS l mask hleft hright x ((mem_columnPattern _ _ x).mp hx))

theorem columnPattern_vps_union :
    (columnPattern (vps S hS l mask hleft hright).channel
        ((vps S hS l mask hleft hright).activeEquiv (splitLeft l))).val ∪
      (columnPattern (vps S hS l mask hleft hright).channel
        ((vps S hS l mask hleft hright).activeEquiv (splitRight l))).val =
      (columnPattern S.channel (S.activeEquiv l)).val := by
  ext x
  simp only [Finset.mem_union, mem_columnPattern]
  exact vps_children_support_union S hS l mask hleft hright x

end Patterns
end
end PerfectFunctionalRepresentations.MatrixOperations

namespace PerfectFunctionalRepresentations.MatrixOperations

open scoped BigOperators ENNReal
noncomputable section
attribute [local instance] Classical.propDecidable
universe u
variable {alpha : Type u} [Finite alpha] [Nonempty alpha]

/-- Value-preserving merge uses the common pushforward at two disjoint columns
with the same admitted value. The value may be one. -/
def vpm (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (a b : Fin S.outputCard) (hab : a < b)
    (_hv : columnValue S.channel hS (S.activeEquiv a) =
      columnValue S.channel hS (S.activeEquiv b))
    (_hd : ∀ x, S.channel x a ≠ 0 → S.channel x b = 0) : ActiveFiniteChannel alpha where
  outputCard := S.outputCard - 1
  outputCard_pos := by have := activeMerge_two_le S a b hab; omega
  channel := mergeRaw (fun x => (S.channel x).map (mergeSourceEquiv S))
    (mergeSourceEquiv S a) (mergeSourceEquiv S b) ((mergeSourceEquiv_lt_iff S a b).mpr hab)
  output_active := by
    intro j
    obtain ⟨x, hx⟩ := mergeSourceEquiv_active S ((mergeSourceEquiv S b).succAbove j)
    refine ⟨x, ?_⟩
    rw [mergeRaw_apply_map, ← PMF.mem_support_iff, PMF.mem_support_map_iff]
    exact ⟨_, (PMF.mem_support_iff _ _).mpr hx, mergeIndex_succAbove _ _ _ j⟩

variable (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
  (a b : Fin S.outputCard) (hab : a < b)
  (hv : columnValue S.channel hS (S.activeEquiv a) =
    columnValue S.channel hS (S.activeEquiv b))
  (hd : ∀ x, S.channel x a ≠ 0 → S.channel x b = 0)

@[simp] theorem vpm_outputCard : (vpm S hS a b hab hv hd).outputCard = S.outputCard - 1 := rfl

theorem vpm_channel (x : alpha) :
    (vpm S hS a b hab hv hd).channel x =
      mergeRaw (fun x => (S.channel x).map (mergeSourceEquiv S))
        (mergeSourceEquiv S a) (mergeSourceEquiv S b)
        ((mergeSourceEquiv_lt_iff S a b).mpr hab) x := rfl

theorem vpm_channel_map (x : alpha) :
    ((vpm S hS a b hab hv hd).channel x).map
        (finCongr (vpm_outputCard S hS a b hab hv hd)) =
      mergeRaw (fun x => (S.channel x).map (mergeSourceEquiv S))
        (mergeSourceEquiv S a) (mergeSourceEquiv S b)
        ((mergeSourceEquiv_lt_iff S a b).mpr hab) x := by
  exact PMF.map_id _

theorem vpm_apply_survivor (x : alpha) :
    (vpm S hS a b hab hv hd).channel x (activeMergeSurvivor S a b hab) =
      S.channel x a + S.channel x b := by
  rw [vpm_channel]
  change mergeRaw _ _ _ _ x (mergeSurvivor _ _ _) = _
  rw [mergeRaw_survivor, mergeSourceEquiv_map_apply, mergeSourceEquiv_map_apply]

theorem vpm_apply_unaffected (x : alpha) {j : Fin (S.outputCard - 1)}
    (hj : j ≠ activeMergeSurvivor S a b hab) :
    (vpm S hS a b hab hv hd).channel x j = S.channel x (activeMergeRetained S b j) := by
  change mergeRaw (fun x => (S.channel x).map (mergeSourceEquiv S))
    (mergeSourceEquiv S a) (mergeSourceEquiv S b) _ x j = _
  rw [mergeRaw_unaffected _ _ _ _ x hj]
  simpa only [activeMergeRetained_source] using
    mergeSourceEquiv_map_apply S x (activeMergeRetained S b j)

theorem vpm_survivor_ne_zero_iff (x : alpha) :
    (vpm S hS a b hab hv hd).channel x (activeMergeSurvivor S a b hab) ≠ 0 ↔
      S.channel x a ≠ 0 ∨ S.channel x b ≠ 0 := by
  rw [vpm_apply_survivor]
  simp only [ne_eq, add_eq_zero, not_and_or]

include hv hd in
private theorem vpm_sum_eq_value (x : alpha) (hx : S.channel x a + S.channel x b ≠ 0) :
    S.channel x a + S.channel x b = columnValue S.channel hS (S.activeEquiv a) := by
  by_cases ha : S.channel x a = 0
  · have hb : S.channel x b ≠ 0 := by simpa only [ha, zero_add] using hx
    rw [ha, zero_add, hv]
    exact (columnValue_eq_of_ne_zero S.channel hS (S.activeEquiv b) hb).symm
  · rw [hd x ha, add_zero]
    exact (columnValue_eq_of_ne_zero S.channel hS (S.activeEquiv a) ha).symm

theorem vpm_isSingular : IsSingularChannel (vpm S hS a b hab hv hd).channel := by
  intro x z j hx hz
  by_cases hj : j = activeMergeSurvivor S a b hab
  · subst j
    have hxm := (vpm_apply_survivor S hS a b hab hv hd x)
    have hzm := (vpm_apply_survivor S hS a b hab hv hd z)
    exact (hxm.trans (vpm_sum_eq_value S hS a b hv hd x (hxm ▸ hx))).trans
      (hzm.trans (vpm_sum_eq_value S hS a b hv hd z (hzm ▸ hz))).symm
  · rw [vpm_apply_unaffected S hS a b hab hv hd x hj] at hx ⊢
    rw [vpm_apply_unaffected S hS a b hab hv hd z hj] at hz ⊢
    exact hS _ _ _ hx hz

theorem vpm_real_survivor (x : alpha) :
    realMatrix (vpm S hS a b hab hv hd).channel x (activeMergeSurvivor S a b hab) =
      realMatrix S.channel x a + realMatrix S.channel x b := by
  change ((vpm S hS a b hab hv hd).channel x (activeMergeSurvivor S a b hab)).toReal =
    (S.channel x a).toReal + (S.channel x b).toReal
  rw [vpm_apply_survivor,
    ENNReal.toReal_add ((S.channel x).apply_ne_top a) ((S.channel x).apply_ne_top b)]

theorem vpm_real_unaffected (x : alpha) {j : Fin (S.outputCard - 1)}
    (hj : j ≠ activeMergeSurvivor S a b hab) :
    realMatrix (vpm S hS a b hab hv hd).channel x j =
      realMatrix S.channel x (activeMergeRetained S b j) := by
  change ((vpm S hS a b hab hv hd).channel x j).toReal =
    (S.channel x (activeMergeRetained S b j)).toReal
  rw [vpm_apply_unaffected S hS a b hab hv hd x hj]

theorem vpm_row_sum (x : alpha) : ∑ j, (vpm S hS a b hab hv hd).channel x j = 1 := by
  simpa only [massMatrix_apply] using massMatrix_row_sum (vpm S hS a b hab hv hd).channel x

theorem vpm_real_row_sum (x : alpha) :
    ∑ j, realMatrix (vpm S hS a b hab hv hd).channel x j = 1 := realMatrix_row_sum _ _

theorem columnValue_vpm_survivor :
    columnValue (vpm S hS a b hab hv hd).channel (vpm_isSingular S hS a b hab hv hd)
        ((vpm S hS a b hab hv hd).activeEquiv (activeMergeSurvivor S a b hab)) =
      columnValue S.channel hS (S.activeEquiv a) := by
  obtain ⟨x, hx⟩ := S.output_active a
  have hn := (vpm_survivor_ne_zero_iff S hS a b hab hv hd x).mpr (Or.inl hx)
  rw [columnValue_eq_of_ne_zero _ _ _ hn]
  change (vpm S hS a b hab hv hd).channel x (activeMergeSurvivor S a b hab) =
    columnValue S.channel hS (S.activeEquiv a)
  rw [vpm_apply_survivor]
  exact vpm_sum_eq_value S hS a b hv hd x (by
    rw [hd x hx, add_zero]
    exact hx)

theorem columnValue_vpm_unaffected {j : Fin (S.outputCard - 1)}
    (hj : j ≠ activeMergeSurvivor S a b hab) :
    columnValue (vpm S hS a b hab hv hd).channel (vpm_isSingular S hS a b hab hv hd)
        ((vpm S hS a b hab hv hd).activeEquiv j) =
      columnValue S.channel hS (S.activeEquiv (activeMergeRetained S b j)) := by
  apply columnValue_transport S.channel (vpm S hS a b hab hv hd).channel hS
    (vpm_isSingular S hS a b hab hv hd) (S.activeEquiv (activeMergeRetained S b j))
    ((vpm S hS a b hab hv hd).activeEquiv j) (Equiv.refl alpha)
  intro x
  exact vpm_apply_unaffected S hS a b hab hv hd x hj

theorem columnValue_vpm_survivor_toReal :
    (columnValue (vpm S hS a b hab hv hd).channel (vpm_isSingular S hS a b hab hv hd)
        ((vpm S hS a b hab hv hd).activeEquiv (activeMergeSurvivor S a b hab))).toReal =
      (columnValue S.channel hS (S.activeEquiv a)).toReal :=
  congrArg ENNReal.toReal (columnValue_vpm_survivor S hS a b hab hv hd)

theorem columnValue_vpm_unaffected_toReal {j : Fin (S.outputCard - 1)}
    (hj : j ≠ activeMergeSurvivor S a b hab) :
    (columnValue (vpm S hS a b hab hv hd).channel (vpm_isSingular S hS a b hab hv hd)
        ((vpm S hS a b hab hv hd).activeEquiv j)).toReal =
      (columnValue S.channel hS (S.activeEquiv (activeMergeRetained S b j))).toReal :=
  congrArg ENNReal.toReal (columnValue_vpm_unaffected S hS a b hab hv hd hj)

/-- The paper's numeric support indicators sum to zero or one exactly when
the two support predicates are disjoint. This condition needs no equal-value premise. -/
theorem disjoint_support_iff_indicator_sum (S : ActiveFiniteChannel alpha)
    (a b : Fin S.outputCard) :
    (∀ x, S.channel x a ≠ 0 → S.channel x b = 0) ↔
      ∀ x, ((if S.channel x a ≠ 0 then (1 : ℝ) else 0) +
          (if S.channel x b ≠ 0 then (1 : ℝ) else 0) = 0 ∨
        (if S.channel x a ≠ 0 then (1 : ℝ) else 0) +
          (if S.channel x b ≠ 0 then (1 : ℝ) else 0) = 1) := by
  constructor
  · intro h x
    by_cases ha : S.channel x a = 0
    · by_cases hb : S.channel x b = 0 <;> simp [ha, hb]
    · simp [ha, h x ha]
  · intro h x ha
    by_contra hb
    simpa [ha, hb] using h x

section Patterns
variable [Fintype alpha]

theorem disjoint_support_iff_columnPattern_disjoint (S : ActiveFiniteChannel alpha)
    (a b : Fin S.outputCard) :
    (∀ x, S.channel x a ≠ 0 → S.channel x b = 0) ↔
      Disjoint (columnPattern S.channel (S.activeEquiv a)).val
        (columnPattern S.channel (S.activeEquiv b)).val := by
  rw [Finset.disjoint_left]
  constructor
  · intro h x hxa hxb
    exact ((mem_columnPattern S.channel (S.activeEquiv b) x).mp hxb)
      (h x ((mem_columnPattern S.channel (S.activeEquiv a) x).mp hxa))
  · intro h x hxa
    by_contra hxb
    exact h ((mem_columnPattern S.channel (S.activeEquiv a) x).mpr hxa)
      ((mem_columnPattern S.channel (S.activeEquiv b) x).mpr hxb)

omit [Fintype alpha] in
/-- The same 0/1 criterion in Definition 4's divided Real-column presentation. -/
theorem disjoint_support_iff_div_value_sum (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (a b : Fin S.outputCard) :
    (∀ x, S.channel x a ≠ 0 → S.channel x b = 0) ↔
      ∀ x, (realMatrix S.channel x a / (columnValue S.channel hS (S.activeEquiv a)).toReal +
          realMatrix S.channel x b / (columnValue S.channel hS (S.activeEquiv b)).toReal = 0 ∨
        realMatrix S.channel x a / (columnValue S.channel hS (S.activeEquiv a)).toReal +
          realMatrix S.channel x b / (columnValue S.channel hS (S.activeEquiv b)).toReal = 1) := by
  let : Fintype alpha := Fintype.ofFinite alpha
  have hi (x : alpha) (j : Fin S.outputCard) :
      realMatrix S.channel x j / (columnValue S.channel hS (S.activeEquiv j)).toReal =
        if S.channel x j ≠ 0 then 1 else 0 := by
    have h := column_div_value S.channel hS (S.activeEquiv j) x
    simp only [mem_columnPattern] at h
    change realMatrix S.channel x j / (columnValue S.channel hS (S.activeEquiv j)).toReal =
      (if S.channel x j ≠ 0 then 1 else 0) at h
    exact h
  simp_rw [hi]
  exact disjoint_support_iff_indicator_sum S a b

theorem columnPattern_vpm_survivor :
    (columnPattern (vpm S hS a b hab hv hd).channel
        ((vpm S hS a b hab hv hd).activeEquiv (activeMergeSurvivor S a b hab))).val =
      (columnPattern S.channel (S.activeEquiv a)).val ∪
        (columnPattern S.channel (S.activeEquiv b)).val := by
  ext x
  simp only [mem_columnPattern, Finset.mem_union]
  change (vpm S hS a b hab hv hd).channel x (activeMergeSurvivor S a b hab) ≠ 0 ↔
    S.channel x a ≠ 0 ∨ S.channel x b ≠ 0
  exact vpm_survivor_ne_zero_iff S hS a b hab hv hd x

theorem columnPattern_vpm_unaffected {j : Fin (S.outputCard - 1)}
    (hj : j ≠ activeMergeSurvivor S a b hab) :
    columnPattern (vpm S hS a b hab hv hd).channel ((vpm S hS a b hab hv hd).activeEquiv j) =
      columnPattern S.channel (S.activeEquiv (activeMergeRetained S b j)) := by
  apply Subtype.ext
  ext x
  simp only [mem_columnPattern]
  change (vpm S hS a b hab hv hd).channel x j ≠ 0 ↔ S.channel x (activeMergeRetained S b j) ≠ 0
  rw [vpm_apply_unaffected S hS a b hab hv hd x hj]

end Patterns
end
end PerfectFunctionalRepresentations.MatrixOperations

namespace PerfectFunctionalRepresentations.MatrixOperations
open scoped ENNReal
noncomputable section
universe u
variable {alpha : Type u} {n m : Nat}

private theorem vp_adjacent_survivor (l : Fin n) :
    mergeSurvivor (splitLeft l) (splitRight l) Fin.castSucc_lt_succ = l := by
  apply Fin.ext
  exact mergeSurvivor_val l.castSucc l.succ Fin.castSucc_lt_succ

/-- Adjacent merge recovers any raw value-preserving split, including null rows. -/
theorem mergeRaw_vpsRaw (K : alpha → PMF (Fin n)) (l : Fin n)
    (mask : alpha → Bool) (x : alpha) :
    mergeRaw (vpsRaw K l mask) (splitLeft l) (splitRight l)
      Fin.castSucc_lt_succ x = K x := by
  apply PMF.ext
  intro j
  by_cases hj : j = l
  · subst j
    have h := mergeRaw_survivor (vpsRaw K l mask) (splitLeft l) (splitRight l)
      Fin.castSucc_lt_succ x
    rw [vp_adjacent_survivor, vpsRaw_left, vpsRaw_right] at h
    rw [h]
    cases mask x <;> simp
  · rw [mergeRaw_unaffected (vpsRaw K l mask) (splitLeft l) (splitRight l)
      Fin.castSucc_lt_succ x (by simpa only [vp_adjacent_survivor] using hj)]
    exact vpsRaw_keep K l mask x hj

private theorem vp_split_merge_map (K : alpha → PMF (Fin (m + 1)))
    (a b : Fin (m + 1)) (hab : a < b) (mask : alpha → Bool)
    (hl : ∀ x, (if mask x then K x a + K x b else 0) = K x a)
    (hr : ∀ x, (if mask x then 0 else K x a + K x b) = K x b)
    (x : alpha) :
    (vpsRaw (mergeRaw K a b hab) (mergeSurvivor a b hab) mask x).map
      (recoveryPerm a b hab) = K x := by
  apply PMF.ext
  intro y
  obtain ⟨z, rfl⟩ := (recoveryPerm a b hab).surjective y
  rw [PMF.map_apply_equiv]
  rcases split_cases (mergeSurvivor a b hab) z with rfl | ⟨j, rfl⟩
  · rw [vpsRaw_right, mergeRaw_survivor]
    exact (hr x).trans (congrArg (K x) (recoveryPerm_right a b hab).symm)
  · by_cases hj : j = mergeSurvivor a b hab
    · subst j
      rw [splitKeep_self, vpsRaw_left, mergeRaw_survivor]
      exact (hl x).trans (congrArg (K x) (recoveryPerm_left a b hab).symm)
    · rw [vpsRaw_keep _ _ _ _ hj, mergeRaw_unaffected _ _ _ _ _ hj]
      exact congrArg (K x) (recoveryPerm_keep a b hab j).symm

end
end PerfectFunctionalRepresentations.MatrixOperations

namespace PerfectFunctionalRepresentations.MatrixOperations
open scoped ENNReal
noncomputable section
attribute [local instance] Classical.propDecidable
universe u
variable {alpha : Type u} [Finite alpha] [Nonempty alpha]

/-- The remembered support mask selects the original lower column. -/
def vpmRecoveryMask (S : ActiveFiniteChannel alpha) (a : Fin S.outputCard) : alpha → Bool :=
  fun x => decide (S.channel x a ≠ 0)

@[simp] theorem vpmRecoveryMask_true_iff (S : ActiveFiniteChannel alpha)
    (a : Fin S.outputCard) (x : alpha) :
    vpmRecoveryMask S a x = true ↔ S.channel x a ≠ 0 := by
  simp [vpmRecoveryMask]

@[simp] theorem vpmRecoveryMask_false_iff (S : ActiveFiniteChannel alpha)
    (a : Fin S.outputCard) (x : alpha) :
    vpmRecoveryMask S a x = false ↔ S.channel x a = 0 := by
  simp [vpmRecoveryMask]

/-- Legal adjacent VPM of a VPS's two nonempty children. -/
def vpsRecovery (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (mask : alpha → Bool)
    (hl : ∃ x, S.channel x l ≠ 0 ∧ mask x = true)
    (hr : ∃ x, S.channel x l ≠ 0 ∧ mask x = false) : ActiveFiniteChannel alpha :=
  vpm (vps S hS l mask hl hr) (vps_isSingular S hS l mask hl hr)
    (splitLeft l) (splitRight l) Fin.castSucc_lt_succ
    ((columnValue_vps_left S hS l mask hl hr).trans
      (columnValue_vps_right S hS l mask hl hr).symm)
    (vps_children_disjoint S hS l mask hl hr)

@[simp] theorem vpsRecovery_outputCard (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (l : Fin S.outputCard) (mask : alpha → Bool)
    (hl : ∃ x, S.channel x l ≠ 0 ∧ mask x = true)
    (hr : ∃ x, S.channel x l ≠ 0 ∧ mask x = false) :
    (vpsRecovery S hS l mask hl hr).outputCard = S.outputCard := rfl

theorem vpsRecovery_isSingular (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (l : Fin S.outputCard) (mask : alpha → Bool)
    (hl : ∃ x, S.channel x l ≠ 0 ∧ mask x = true)
    (hr : ∃ x, S.channel x l ≠ 0 ∧ mask x = false) :
    IsSingularChannel (vpsRecovery S hS l mask hl hr).channel :=
  vpm_isSingular _ _ _ _ _ _ _

theorem vpsRecovery_channel (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (l : Fin S.outputCard) (mask : alpha → Bool)
    (hl : ∃ x, S.channel x l ≠ 0 ∧ mask x = true)
    (hr : ∃ x, S.channel x l ≠ 0 ∧ mask x = false) (x : alpha) :
    ((vpsRecovery S hS l mask hl hr).channel x).map
      (finCongr (vpsRecovery_outputCard S hS l mask hl hr)) = S.channel x := by
  change (mergeRaw (fun x => (vpsRaw S.channel l mask x).map id)
    (splitLeft l) (splitRight l) _ x).map id = S.channel x
  simpa only [PMF.map_id] using mergeRaw_vpsRaw S.channel l mask x

private theorem vpsRecovery_eq (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (l : Fin S.outputCard) (mask : alpha → Bool)
    (hl : ∃ x, S.channel x l ≠ 0 ∧ mask x = true)
    (hr : ∃ x, S.channel x l ≠ 0 ∧ mask x = false) (x : alpha) :
    (vpsRecovery S hS l mask hl hr).channel x = S.channel x := by
  have h := vpsRecovery_channel S hS l mask hl hr x
  change ((vpsRecovery S hS l mask hl hr).channel x).map id = _ at h
  simpa only [PMF.map_id] using h

/-- The original mask remains a legal witness after exact recovery. -/
theorem vpsRecovery_mask_legal (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (l : Fin S.outputCard) (mask : alpha → Bool)
    (hl : ∃ x, S.channel x l ≠ 0 ∧ mask x = true)
    (hr : ∃ x, S.channel x l ≠ 0 ∧ mask x = false) :
    (∃ x, (vpsRecovery S hS l mask hl hr).channel x l ≠ 0 ∧ mask x = true) ∧
    (∃ x, (vpsRecovery S hS l mask hl hr).channel x l ≠ 0 ∧ mask x = false) := by
  constructor
  · obtain ⟨x, hx, hm⟩ := hl
    refine ⟨x, ?_, hm⟩
    rw [vpsRecovery_eq]
    exact hx
  · obtain ⟨x, hx, hm⟩ := hr
    refine ⟨x, ?_, hm⟩
    rw [vpsRecovery_eq]
    exact hx

/-- Splitting the recovered state by the remembered mask recovers the split row. -/
theorem vpsRecovery_resplit (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (l : Fin S.outputCard) (mask : alpha → Bool)
    (hl : ∃ x, S.channel x l ≠ 0 ∧ mask x = true)
    (hr : ∃ x, S.channel x l ≠ 0 ∧ mask x = false) (x : alpha) :
    (vps (vpsRecovery S hS l mask hl hr) (vpsRecovery_isSingular S hS l mask hl hr) l mask
      (vpsRecovery_mask_legal S hS l mask hl hr).1
      (vpsRecovery_mask_legal S hS l mask hl hr).2).channel x =
      (vps S hS l mask hl hr).channel x := by
  change ((vpsRecovery S hS l mask hl hr).channel x).map (vpsIndex l (mask x)) = _
  rw [vpsRecovery_eq]
  rfl

section VPMRecovery
variable (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
  (a b : Fin S.outputCard) (hab : a < b)
  (hv : columnValue S.channel hS (S.activeEquiv a) =
    columnValue S.channel hS (S.activeEquiv b))
  (hd : ∀ x, S.channel x a ≠ 0 → S.channel x b = 0)

theorem vpmRecovery_leftWitness :
    ∃ x, (vpm S hS a b hab hv hd).channel x (activeMergeSurvivor S a b hab) ≠ 0 ∧
      vpmRecoveryMask S a x = true := by
  obtain ⟨x, hx⟩ := S.output_active a
  refine ⟨x, ?_, (vpmRecoveryMask_true_iff S a x).mpr hx⟩
  rw [vpm_apply_survivor, hd x hx, add_zero]
  exact hx

theorem vpmRecovery_rightWitness :
    ∃ x, (vpm S hS a b hab hv hd).channel x (activeMergeSurvivor S a b hab) ≠ 0 ∧
      vpmRecoveryMask S a x = false := by
  obtain ⟨x, hx⟩ := S.output_active b
  have ha : S.channel x a = 0 := by
    by_contra ha
    exact hx (hd x ha)
  refine ⟨x, ?_, (vpmRecoveryMask_false_iff S a x).mpr ha⟩
  rw [vpm_apply_survivor, ha, zero_add]
  exact hx

/-- Legal VPS after VPM, selecting the old lower column's support. -/
def vpmRecovery : ActiveFiniteChannel alpha :=
  vps (vpm S hS a b hab hv hd) (vpm_isSingular S hS a b hab hv hd)
    (activeMergeSurvivor S a b hab) (vpmRecoveryMask S a)
    (vpmRecovery_leftWitness S hS a b hab hv hd)
    (vpmRecovery_rightWitness S hS a b hab hv hd)

theorem vpmRecovery_outputCard :
    (vpmRecovery S hS a b hab hv hd).outputCard = S.outputCard := (mergeSource_card S).symm

include hd in
private theorem vpmRecovery_row_parts (x : alpha) :
    (if vpmRecoveryMask S a x then S.channel x a + S.channel x b else 0) = S.channel x a ∧
    (if vpmRecoveryMask S a x then 0 else S.channel x a + S.channel x b) = S.channel x b := by
  by_cases ha : S.channel x a = 0
  · simp [vpmRecoveryMask, ha]
  · simp [vpmRecoveryMask, ha, hd x ha]

theorem vpmRecovery_left (x : alpha) :
    (vpmRecovery S hS a b hab hv hd).channel x (splitLeft (activeMergeSurvivor S a b hab)) =
      S.channel x a := by
  calc
    _ = if vpmRecoveryMask S a x then
        (vpm S hS a b hab hv hd).channel x (activeMergeSurvivor S a b hab) else 0 :=
      vps_left _ _ _ _ _ _ x
    _ = _ := by
      rw [vpm_apply_survivor]
      exact (vpmRecovery_row_parts S a b hd x).1

theorem vpmRecovery_right (x : alpha) :
    (vpmRecovery S hS a b hab hv hd).channel x (splitRight (activeMergeSurvivor S a b hab)) =
      S.channel x b := by
  calc
    _ = if vpmRecoveryMask S a x then 0 else
        (vpm S hS a b hab hv hd).channel x (activeMergeSurvivor S a b hab) :=
      vps_right _ _ _ _ _ _ x
    _ = _ := by
      rw [vpm_apply_survivor]
      exact (vpmRecovery_row_parts S a b hd x).2

theorem vpmRecovery_keep (x : alpha) {j : Fin (S.outputCard - 1)}
    (hj : j ≠ activeMergeSurvivor S a b hab) :
    (vpmRecovery S hS a b hab hv hd).channel x (splitKeep (activeMergeSurvivor S a b hab) j) =
      S.channel x (activeMergeRetained S b j) := by
  exact (vps_keep (vpm S hS a b hab hv hd) (vpm_isSingular S hS a b hab hv hd)
    _ _ _ _ x hj).trans (vpm_apply_unaffected S hS a b hab hv hd x hj)

/-- New-to-original equivalence, including the identity numeric cardinality cast. -/
def vpmRecoveryEquiv : Fin (vpmRecovery S hS a b hab hv hd).outputCard ≃ Fin S.outputCard :=
  (finCongr (vpmRecovery_outputCard S hS a b hab hv hd)).trans (recoveryPerm a b hab)

private theorem vpmRecoveryEquiv_transport :
    (fun z => (mergeSourceEquiv S).symm
      (recoveryPerm (mergeSourceEquiv S a) (mergeSourceEquiv S b)
        ((mergeSourceEquiv_lt_iff S a b).mpr hab) z)) =
      vpmRecoveryEquiv S hS a b hab hv hd := by
  funext z
  apply Fin.ext
  change ((mergeSourceEquiv S).symm
    (recoveryPerm (mergeSourceEquiv S a) (mergeSourceEquiv S b) _ z)).val =
    (recoveryPerm a b hab (finCongr (vpmRecovery_outputCard S hS a b hab hv hd) z)).val
  simp only [mergeSourceEquiv_symm_val, recoveryPerm_val, mergeSourceEquiv_val]
  rfl

theorem vpmRecovery_channel (x : alpha) :
    ((vpmRecovery S hS a b hab hv hd).channel x).map
      (vpmRecoveryEquiv S hS a b hab hv hd) = S.channel x := by
  have h := vp_split_merge_map (fun x => (S.channel x).map (mergeSourceEquiv S))
    (mergeSourceEquiv S a) (mergeSourceEquiv S b)
    ((mergeSourceEquiv_lt_iff S a b).mpr hab) (vpmRecoveryMask S a)
    (fun x => by simpa only [mergeSourceEquiv_map_apply] using
      (vpmRecovery_row_parts S a b hd x).1)
    (fun x => by simpa only [mergeSourceEquiv_map_apply] using
      (vpmRecovery_row_parts S a b hd x).2) x
  have hh := congrArg (fun p => p.map (mergeSourceEquiv S).symm) h
  rw [PMF.map_comp, PMF.map_comp] at hh
  have hid : (mergeSourceEquiv S).symm ∘ mergeSourceEquiv S = id :=
    funext (mergeSourceEquiv S).symm_apply_apply
  rw [hid, PMF.map_id] at hh
  change ((vpmRecovery S hS a b hab hv hd).channel x).map
    (fun z => (mergeSourceEquiv S).symm
      (recoveryPerm (mergeSourceEquiv S a) (mergeSourceEquiv S b) _ z)) = _ at hh
  rwa [vpmRecoveryEquiv_transport] at hh

theorem vpmRecovery_channel_inverse (x : alpha) :
    (S.channel x).map (vpmRecoveryEquiv S hS a b hab hv hd).symm =
      (vpmRecovery S hS a b hab hv hd).channel x := by
  rw [← vpmRecovery_channel S hS a b hab hv hd x, PMF.map_comp]
  have hid : (vpmRecoveryEquiv S hS a b hab hv hd).symm ∘
      vpmRecoveryEquiv S hS a b hab hv hd = id :=
    funext (vpmRecoveryEquiv S hS a b hab hv hd).symm_apply_apply
  rw [hid, PMF.map_id]

theorem vpmRecovery_reindex (x : alpha) :
    (((vpmRecovery S hS a b hab hv hd).channel x).map
      (finCongr (vpmRecovery_outputCard S hS a b hab hv hd))).map
      (recoveryPerm a b hab) = S.channel x := by
  rw [PMF.map_comp]
  exact vpmRecovery_channel S hS a b hab hv hd x

theorem vpmRecovery_reindex_inverse (x : alpha) :
    (S.channel x).map (recoveryPerm a b hab).symm =
      ((vpmRecovery S hS a b hab hv hd).channel x).map
        (finCongr (vpmRecovery_outputCard S hS a b hab hv hd)) := by
  rw [← vpmRecovery_reindex S hS a b hab hv hd x, PMF.map_comp]
  have hid : (recoveryPerm a b hab).symm ∘ recoveryPerm a b hab = id :=
    funext (recoveryPerm a b hab).symm_apply_apply
  rw [hid, PMF.map_id]

theorem vpmRecovery_adjacent (hadj : b.val = a.val + 1) (x : alpha) :
    ((vpmRecovery S hS a b hab hv hd).channel x).map
      (finCongr (vpmRecovery_outputCard S hS a b hab hv hd)) = S.channel x := by
  have h := vpmRecovery_reindex S hS a b hab hv hd x
  rw [recoveryPerm_adjacent a b hab hadj] at h
  exact (PMF.map_id _).symm.trans h

end VPMRecovery
end
end PerfectFunctionalRepresentations.MatrixOperations
