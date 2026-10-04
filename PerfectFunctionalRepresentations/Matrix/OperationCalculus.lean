import PerfectFunctionalRepresentations.Matrix.OperationFactorization
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Finiteness

/-!
# Local interchange of legal matrix operations

This module implements extended version 16, Appendix B (167)-(173), using the
actual ordered C07 operations. Endpoint comparisons retain their directed output
bijections. The left-child VPS/PPS law includes the column transposition required
by the lower-survivor convention in (171). Interchanges and their regression
consumers remain private. The imported OperationFactorization module proves
structural normalization; these local laws assert no termination of expanding rewrites.
-/

namespace PerfectFunctionalRepresentations.MatrixOperations

noncomputable section
attribute [local instance] operationQuiver

private theorem vpKeep_val {n : Nat} (l j : Fin n) :
    (splitKeep l j).val = if j.val ≤ l.val then j.val else j.val + 1 := by
  by_cases h : j ≤ l
  · rw [splitKeep_of_le l j h]
    change j.val ≤ l.val at h
    simp only [Fin.val_castSucc, if_pos h]
  · rw [splitKeep_of_lt l j (lt_of_not_ge h)]
    change ¬ j.val ≤ l.val at h
    simp only [Fin.val_succ, if_neg h]

private theorem vpFin_eq {n : Nat} (i j : Fin n) (h : i.val = j.val) : i = j := Fin.ext h

private theorem vpKeep_ne_left {n : Nat} (l j : Fin n) (h : j ≠ l) :
    splitKeep l j ≠ splitLeft l := by
  intro he
  apply h
  apply splitKeep_injective l
  simpa only [splitKeep_self] using he

private theorem vpKeep_right {n : Nat} (l : Fin n) :
    splitKeep l.castSucc l.succ = l.succ.succ := by
  exact splitKeep_of_lt _ _ Fin.castSucc_lt_succ

private def vpKeep2 {n : Nat} (l j : Fin n) : Fin (n + 1 + 1) :=
  splitKeep l.castSucc (splitKeep l j)

private theorem vpKeep2_val {n : Nat} (l j : Fin n) (h : j ≠ l) :
    (vpKeep2 l j).val = if j.val < l.val then j.val else j.val + 2 := by
  have hn : j.val ≠ l.val := fun he => h (Fin.ext he)
  simp only [vpKeep2, vpKeep_val, Fin.val_castSucc]
  split_ifs <;> omega

private theorem vpKeep2_right {n : Nat} (l j : Fin n) (h : j ≠ l) :
    splitKeep l.succ (splitKeep l j) = vpKeep2 l j := by
  apply Fin.ext
  rw [vpKeep_val, vpKeep_val, vpKeep2_val l j h]
  have hn : j.val ≠ l.val := fun he => h (Fin.ext he)
  simp only [Fin.val_succ]
  split_ifs <;> omega

private theorem vpKeep2_ne {n : Nat} (l j : Fin n) (h : j ≠ l) :
    vpKeep2 l j ≠ l.succ.succ := by
  intro he
  have hv := congrArg Fin.val he
  rw [vpKeep2_val l j h] at hv
  simp only [Fin.val_succ] at hv
  have hn : j.val ≠ l.val := fun he => h (Fin.ext he)
  split_ifs at hv <;> omega

private def vpKeep3 {n : Nat} (l j : Fin n) : Fin (n + 1 + 1 + 1) :=
  splitKeep l.succ.succ (vpKeep2 l j)

private theorem vpKeep3_val {n : Nat} (l j : Fin n) (h : j ≠ l) :
    (vpKeep3 l j).val = if j.val < l.val then j.val else j.val + 3 := by
  simp only [vpKeep3, vpKeep_val, vpKeep2_val l j h, Fin.val_succ]
  have hn : j.val ≠ l.val := fun he => h (Fin.ext he)
  split_ifs <;> omega

universe u
variable {alpha : Type u} [Finite alpha] [Nonempty alpha]
variable (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
  (l : Fin S.outputCard) (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1)
  (mask : alpha → Bool)
  (hl : ∃ x, S.channel x l ≠ 0 ∧ mask x = true)
  (hr : ∃ x, S.channel x l ≠ 0 ∧ mask x = false)

private abbrev vpA := pps S hS l t ht0 ht1

private theorem vpAWitness (b : Bool) (hb : ∃ x, S.channel x l ≠ 0 ∧ mask x = b) :
    ∃ x, (vpA S hS l t ht0 ht1).channel x l.castSucc ≠ 0 ∧ mask x = b := by
  obtain ⟨x, hx, hm⟩ := hb
  exact ⟨x, (pps_left_ne_zero_iff S hS l t ht0 ht1 x).mpr hx, hm⟩

private abbrev vpB :=
  vps (vpA S hS l t ht0 ht1) (pps_isSingular S hS l t ht0 ht1) l.castSucc mask
    (vpAWitness S hS l t ht0 ht1 mask true hl)
    (vpAWitness S hS l t ht0 ht1 mask false hr)

private theorem vpB_right (x : alpha) :
    (vpB S hS l t ht0 ht1 mask hl hr).channel x l.succ.succ =
      ((1 - t : NNReal) : ENNReal) * S.channel x l := by
  rw [← vpKeep_right l]
  exact (vps_keep _ _ _ _ _ _ x (ne_of_gt Fin.castSucc_lt_succ)).trans
    (pps_right S hS l t ht0 ht1 x)

private theorem vpBWitness (b : Bool) (hb : ∃ x, S.channel x l ≠ 0 ∧ mask x = b) :
    ∃ x, (vpB S hS l t ht0 ht1 mask hl hr).channel x l.succ.succ ≠ 0 ∧ mask x = b := by
  obtain ⟨x, hx, hm⟩ := hb
  refine ⟨x, ?_, hm⟩
  rw [vpB_right]
  exact mul_ne_zero (ENNReal.coe_ne_zero.mpr (ne_of_gt (tsub_pos_iff_lt.mpr ht1))) hx

private abbrev vpC :=
  vps (vpB S hS l t ht0 ht1 mask hl hr)
    (vps_isSingular _ _ _ _ _ _) l.succ.succ mask
    (vpBWitness S hS l t ht0 ht1 mask hl hr true hl)
    (vpBWitness S hS l t ht0 ht1 mask hl hr false hr)

private theorem vpC_zero (x : alpha) :
    (vpC S hS l t ht0 ht1 mask hl hr).channel x l.castSucc.castSucc.castSucc =
      (t : ENNReal) * (if mask x then S.channel x l else 0) := by
  have hk : splitKeep l.succ.succ l.castSucc.castSucc = l.castSucc.castSucc.castSucc :=
    splitKeep_of_le _ _ (by simp only [Fin.le_def, Fin.val_castSucc, Fin.val_succ]; omega)
  have h1 : (vpC S hS l t ht0 ht1 mask hl hr).channel x l.castSucc.castSucc.castSucc =
      (vpB S hS l t ht0 ht1 mask hl hr).channel x l.castSucc.castSucc :=
    (congrArg ((vpC S hS l t ht0 ht1 mask hl hr).channel x) hk.symm).trans
      (vps_keep _ _ _ _ _ _ x (by
        intro h; have := congrArg Fin.val h;
        simp only [Fin.val_castSucc, Fin.val_succ] at this; omega))
  have h2 : (vpB S hS l t ht0 ht1 mask hl hr).channel x l.castSucc.castSucc =
      if mask x then (t : ENNReal) * S.channel x l else 0 :=
    (vps_left _ _ _ _ _ _ x).trans
      (congrArg (fun z : ENNReal => if mask x then z else 0) (pps_left S hS l t ht0 ht1 x))
  exact h1.trans (h2.trans (by cases mask x <;> simp))

private theorem vpC_one (x : alpha) :
    (vpC S hS l t ht0 ht1 mask hl hr).channel x l.succ.castSucc.castSucc =
      (t : ENNReal) * (if mask x then 0 else S.channel x l) := by
  have hk : splitKeep l.succ.succ l.castSucc.succ = l.succ.castSucc.castSucc := by
    apply Fin.ext
    rw [vpKeep_val]
    simp only [Fin.val_succ, Fin.val_castSucc]
    split_ifs <;> omega
  have h1 : (vpC S hS l t ht0 ht1 mask hl hr).channel x l.succ.castSucc.castSucc =
      (vpB S hS l t ht0 ht1 mask hl hr).channel x l.castSucc.succ :=
    (congrArg ((vpC S hS l t ht0 ht1 mask hl hr).channel x) hk.symm).trans
      (vps_keep _ _ _ _ _ _ x (by
        intro h; have := congrArg Fin.val h;
        simp only [Fin.val_castSucc, Fin.val_succ] at this; omega))
  have h2 : (vpB S hS l t ht0 ht1 mask hl hr).channel x l.castSucc.succ =
      if mask x then 0 else (t : ENNReal) * S.channel x l :=
    (vps_right _ _ _ _ _ _ x).trans
      (congrArg (fun z : ENNReal => if mask x then 0 else z) (pps_left S hS l t ht0 ht1 x))
  exact h1.trans (h2.trans (by cases mask x <;> simp))

private theorem vpC_two (x : alpha) :
    (vpC S hS l t ht0 ht1 mask hl hr).channel x l.succ.succ.castSucc =
      ((1 - t : NNReal) : ENNReal) * (if mask x then S.channel x l else 0) := by
  exact (vps_left _ _ _ _ _ _ x).trans
    ((congrArg (fun z : ENNReal => if mask x then z else 0)
      (vpB_right S hS l t ht0 ht1 mask hl hr x)).trans (by cases mask x <;> simp))

private theorem vpC_three (x : alpha) :
    (vpC S hS l t ht0 ht1 mask hl hr).channel x l.succ.succ.succ =
      ((1 - t : NNReal) : ENNReal) * (if mask x then 0 else S.channel x l) := by
  exact (vps_right _ _ _ _ _ _ x).trans
    ((congrArg (fun z : ENNReal => if mask x then 0 else z)
      (vpB_right S hS l t ht0 ht1 mask hl hr x)).trans (by cases mask x <;> simp))

private theorem vpC_keep (x : alpha) (j : Fin S.outputCard) (hj : j ≠ l) :
    (vpC S hS l t ht0 ht1 mask hl hr).channel x (vpKeep3 l j) = S.channel x j := by
  exact (vps_keep _ _ _ _ _ _ x (vpKeep2_ne l j hj)).trans
    ((vps_keep _ _ _ _ _ _ x (vpKeep_ne_left l j hj)).trans
      (pps_keep S hS l t ht0 ht1 x hj))

private abbrev vpV := vps S hS l mask hl hr
private abbrev vpOL := pps (vpV S hS l mask hl hr) (vps_isSingular _ _ _ _ _ _)
  l.castSucc t ht0 ht1
private abbrev vpOR := pps (vpV S hS l mask hl hr) (vps_isSingular _ _ _ _ _ _)
  l.succ t ht0 ht1

private theorem vpOL_zero (x : alpha) :
    (vpOL S hS l t ht0 ht1 mask hl hr).channel x l.castSucc.castSucc =
      (t : ENNReal) * (if mask x then S.channel x l else 0) :=
  (pps_left _ _ _ _ _ _ x).trans
    (congrArg (fun z : ENNReal => (t : ENNReal) * z) (vps_left S hS l mask hl hr x))

private theorem vpOL_one (x : alpha) :
    (vpOL S hS l t ht0 ht1 mask hl hr).channel x l.succ.castSucc =
      ((1 - t : NNReal) : ENNReal) * (if mask x then S.channel x l else 0) :=
  (pps_right _ _ _ _ _ _ x).trans
    (congrArg (fun z : ENNReal => ((1 - t : NNReal) : ENNReal) * z)
      (vps_left S hS l mask hl hr x))

private theorem vpOL_two (x : alpha) :
    (vpOL S hS l t ht0 ht1 mask hl hr).channel x l.succ.succ =
      (if mask x then 0 else S.channel x l) :=
  (congrArg ((vpOL S hS l t ht0 ht1 mask hl hr).channel x) (vpKeep_right l).symm).trans
    ((pps_keep _ _ _ _ _ _ x (ne_of_gt Fin.castSucc_lt_succ)).trans
      (vps_right S hS l mask hl hr x))

private theorem vpOL_keep (x : alpha) (j : Fin S.outputCard) (hj : j ≠ l) :
    (vpOL S hS l t ht0 ht1 mask hl hr).channel x (vpKeep2 l j) = S.channel x j :=
  (pps_keep _ _ _ _ _ _ x (vpKeep_ne_left l j hj)).trans (vps_keep S hS l mask hl hr x hj)

private theorem vpOR_zero (x : alpha) :
    (vpOR S hS l t ht0 ht1 mask hl hr).channel x l.castSucc.castSucc =
      (if mask x then S.channel x l else 0) := by
  have hk : splitKeep l.succ l.castSucc = l.castSucc.castSucc :=
    splitKeep_of_le _ _ Fin.castSucc_lt_succ.le
  exact (congrArg ((vpOR S hS l t ht0 ht1 mask hl hr).channel x) hk.symm).trans
    ((pps_keep _ _ _ _ _ _ x (ne_of_lt Fin.castSucc_lt_succ)).trans
      (vps_left S hS l mask hl hr x))

private theorem vpOR_one (x : alpha) :
    (vpOR S hS l t ht0 ht1 mask hl hr).channel x l.succ.castSucc =
      (t : ENNReal) * (if mask x then 0 else S.channel x l) :=
  (pps_left _ _ _ _ _ _ x).trans
    (congrArg (fun z : ENNReal => (t : ENNReal) * z) (vps_right S hS l mask hl hr x))

private theorem vpOR_two (x : alpha) :
    (vpOR S hS l t ht0 ht1 mask hl hr).channel x l.succ.succ =
      ((1 - t : NNReal) : ENNReal) * (if mask x then 0 else S.channel x l) :=
  (pps_right _ _ _ _ _ _ x).trans
    (congrArg (fun z : ENNReal => ((1 - t : NNReal) : ENNReal) * z)
      (vps_right S hS l mask hl hr x))

private theorem vpOR_keep (x : alpha) (j : Fin S.outputCard) (hj : j ≠ l) :
    (vpOR S hS l t ht0 ht1 mask hl hr).channel x (vpKeep2 l j) = S.channel x j :=
  (congrArg ((vpOR S hS l t ht0 ht1 mask hl hr).channel x) (vpKeep2_right l j hj).symm).trans
    ((pps_keep _ _ _ _ _ _ x (splitKeep_ne_right l j)).trans
      (vps_keep S hS l mask hl hr x hj))

private theorem vpPatternL (x : alpha) :
    (vpC S hS l t ht0 ht1 mask hl hr).channel x l.succ.castSucc.castSucc ≠ 0 ↔
      (vpC S hS l t ht0 ht1 mask hl hr).channel x l.succ.succ.succ ≠ 0 := by
  have h0 : (t : ENNReal) ≠ 0 := ENNReal.coe_ne_zero.mpr (ne_of_gt ht0)
  have h1 : ((1 - t : NNReal) : ENNReal) ≠ 0 :=
    ENNReal.coe_ne_zero.mpr (ne_of_gt (tsub_pos_iff_lt.mpr ht1))
  refine (Iff.of_eq (congrArg (fun z : ENNReal => z ≠ 0)
    (vpC_one S hS l t ht0 ht1 mask hl hr x))).trans ?_
  refine Iff.trans ?_ (Iff.of_eq (congrArg (fun z : ENNReal => z ≠ 0)
    (vpC_three S hS l t ht0 ht1 mask hl hr x).symm))
  exact ⟨fun h => mul_ne_zero h1 (mul_ne_zero_iff.mp h).2,
    fun h => mul_ne_zero h0 (mul_ne_zero_iff.mp h).2⟩

private theorem vpPatternR (x : alpha) :
    (vpC S hS l t ht0 ht1 mask hl hr).channel x l.castSucc.castSucc.castSucc ≠ 0 ↔
      (vpC S hS l t ht0 ht1 mask hl hr).channel x l.succ.succ.castSucc ≠ 0 := by
  have h0 : (t : ENNReal) ≠ 0 := ENNReal.coe_ne_zero.mpr (ne_of_gt ht0)
  have h1 : ((1 - t : NNReal) : ENNReal) ≠ 0 :=
    ENNReal.coe_ne_zero.mpr (ne_of_gt (tsub_pos_iff_lt.mpr ht1))
  refine (Iff.of_eq (congrArg (fun z : ENNReal => z ≠ 0)
    (vpC_zero S hS l t ht0 ht1 mask hl hr x))).trans ?_
  refine Iff.trans ?_ (Iff.of_eq (congrArg (fun z : ENNReal => z ≠ 0)
    (vpC_two S hS l t ht0 ht1 mask hl hr x).symm))
  exact ⟨fun h => mul_ne_zero h1 (mul_ne_zero_iff.mp h).2,
    fun h => mul_ne_zero h0 (mul_ne_zero_iff.mp h).2⟩

private abbrev vpPL := ppm (vpC S hS l t ht0 ht1 mask hl hr)
  (vps_isSingular _ _ _ _ _ _) l.succ.castSucc.castSucc l.succ.succ.succ
  (by change l.val + 1 < l.val + 1 + 1 + 1; omega)
  (vpPatternL S hS l t ht0 ht1 mask hl hr)

private abbrev vpPR := ppm (vpC S hS l t ht0 ht1 mask hl hr)
  (vps_isSingular _ _ _ _ _ _) l.castSucc.castSucc.castSucc l.succ.succ.castSucc
  (by change l.val < l.val + 1 + 1; omega)
  (vpPatternR S hS l t ht0 ht1 mask hl hr)

private theorem vpRetained_val (T : ActiveFiniteChannel alpha) (b : Fin T.outputCard)
    (j : Fin (T.outputCard - 1)) :
    (activeMergeRetained T b j).val = if j.val < b.val then j.val else j.val + 1 := by
  change ((mergeSourceEquiv T b).succAbove j).val = _
  simp only [Fin.succAbove, Fin.lt_def, Fin.val_castSucc, mergeSourceEquiv_val]
  split_ifs <;> rfl

private theorem vpPpmSurvivor (T : ActiveFiniteChannel alpha) (hT : IsSingularChannel T.channel)
    (a b : Fin T.outputCard) (hab : a < b)
    (hp : ∀ x, T.channel x a ≠ 0 ↔ T.channel x b ≠ 0)
    (x : alpha) (j : Fin (T.outputCard - 1)) (hj : j.val = a.val) :
    (ppm T hT a b hab hp).channel x j = T.channel x a + T.channel x b :=
  (congrArg ((ppm T hT a b hab hp).channel x)
    (Fin.ext (hj.trans (activeMergeSurvivor_val T a b hab).symm))).trans
    (ppm_apply_survivor T hT a b hab hp x)

private theorem vpPpmKeep (T : ActiveFiniteChannel alpha) (hT : IsSingularChannel T.channel)
    (a b : Fin T.outputCard) (hab : a < b)
    (hp : ∀ x, T.channel x a ≠ 0 ↔ T.channel x b ≠ 0)
    (x : alpha) (j : Fin (T.outputCard - 1)) (k : Fin T.outputCard)
    (hj : j.val ≠ a.val) (hk : k.val = if j.val < b.val then j.val else j.val + 1) :
    (ppm T hT a b hab hp).channel x j = T.channel x k :=
  (ppm_apply_unaffected T hT a b hab hp x (fun he =>
    hj ((congrArg Fin.val he).trans (activeMergeSurvivor_val T a b hab)))).trans
    (congrArg (T.channel x) (Fin.ext ((vpRetained_val T b j).trans hk.symm)))

private theorem vpPL_zero (x : alpha) :
    (vpPL S hS l t ht0 ht1 mask hl hr).channel x l.castSucc.castSucc =
      (t : ENNReal) * (if mask x then S.channel x l else 0) :=
  (vpPpmKeep _ _ _ _ _ _ x _ l.castSucc.castSucc.castSucc
    (by simp only [Fin.val_castSucc, Fin.val_succ]; omega)
    (by simp only [Fin.val_castSucc, Fin.val_succ]; split_ifs <;> omega)).trans
    (vpC_zero S hS l t ht0 ht1 mask hl hr x)

private theorem vpPL_one (x : alpha) :
    (vpPL S hS l t ht0 ht1 mask hl hr).channel x l.succ.castSucc =
      (if mask x then 0 else S.channel x l) := by
  have hs := vpPpmSurvivor (vpC S hS l t ht0 ht1 mask hl hr)
    (vps_isSingular _ _ _ _ _ _) l.succ.castSucc.castSucc l.succ.succ.succ
    (by change l.val + 1 < l.val + 1 + 1 + 1; omega)
    (vpPatternL S hS l t ht0 ht1 mask hl hr) x l.succ.castSucc rfl
  exact hs.trans ((congrArg₂ (· + ·) (vpC_one S hS l t ht0 ht1 mask hl hr x)
    (vpC_three S hS l t ht0 ht1 mask hl hr x)).trans (by
      rw [← add_mul, ← ENNReal.coe_add, add_tsub_cancel_of_le ht1.le]
      simp))

private theorem vpPL_two (x : alpha) :
    (vpPL S hS l t ht0 ht1 mask hl hr).channel x l.succ.succ =
      ((1 - t : NNReal) : ENNReal) * (if mask x then S.channel x l else 0) :=
  (vpPpmKeep _ _ _ _ _ _ x _ l.succ.succ.castSucc
    (by simp only [Fin.val_castSucc, Fin.val_succ]; omega)
    (by simp only [Fin.val_castSucc, Fin.val_succ]; split_ifs <;> omega)).trans
    (vpC_two S hS l t ht0 ht1 mask hl hr x)

private theorem vpPL_keep (x : alpha) (j : Fin S.outputCard) (hj : j ≠ l) :
    (vpPL S hS l t ht0 ht1 mask hl hr).channel x (vpKeep2 l j) = S.channel x j := by
  have hn : j.val ≠ l.val := fun he => hj (Fin.ext he)
  exact (vpPpmKeep _ _ _ _ _ _ x _ (vpKeep3 l j)
    (by change (vpKeep2 l j).val ≠ l.val + 1; rw [vpKeep2_val l j hj]; split_ifs <;> omega)
    (by change (vpKeep3 l j).val = if (vpKeep2 l j).val < l.val + 1 + 1 + 1 then _ else _
        rw [vpKeep2_val l j hj, vpKeep3_val l j hj]; split_ifs <;> omega)).trans
    (vpC_keep S hS l t ht0 ht1 mask hl hr x j hj)

private theorem vpPR_zero (x : alpha) :
    (vpPR S hS l t ht0 ht1 mask hl hr).channel x l.castSucc.castSucc =
      (if mask x then S.channel x l else 0) := by
  have hs := vpPpmSurvivor (vpC S hS l t ht0 ht1 mask hl hr)
    (vps_isSingular _ _ _ _ _ _) l.castSucc.castSucc.castSucc l.succ.succ.castSucc
    (by change l.val < l.val + 1 + 1; omega)
    (vpPatternR S hS l t ht0 ht1 mask hl hr) x l.castSucc.castSucc rfl
  exact hs.trans ((congrArg₂ (· + ·) (vpC_zero S hS l t ht0 ht1 mask hl hr x)
    (vpC_two S hS l t ht0 ht1 mask hl hr x)).trans (by
      rw [← add_mul, ← ENNReal.coe_add, add_tsub_cancel_of_le ht1.le]
      simp))

private theorem vpPR_one (x : alpha) :
    (vpPR S hS l t ht0 ht1 mask hl hr).channel x l.succ.castSucc =
      (t : ENNReal) * (if mask x then 0 else S.channel x l) :=
  (vpPpmKeep _ _ _ _ _ _ x _ l.succ.castSucc.castSucc
    (by simp only [Fin.val_castSucc, Fin.val_succ]; omega)
    (by simp only [Fin.val_castSucc, Fin.val_succ]; split_ifs <;> omega)).trans
    (vpC_one S hS l t ht0 ht1 mask hl hr x)

private theorem vpPR_two (x : alpha) :
    (vpPR S hS l t ht0 ht1 mask hl hr).channel x l.succ.succ =
      ((1 - t : NNReal) : ENNReal) * (if mask x then 0 else S.channel x l) :=
  (vpPpmKeep _ _ _ _ _ _ x _ l.succ.succ.succ
    (by simp only [Fin.val_castSucc, Fin.val_succ]; omega)
    (by simp only [Fin.val_castSucc, Fin.val_succ]; split_ifs <;> omega)).trans
    (vpC_three S hS l t ht0 ht1 mask hl hr x)

private theorem vpPR_keep (x : alpha) (j : Fin S.outputCard) (hj : j ≠ l) :
    (vpPR S hS l t ht0 ht1 mask hl hr).channel x (vpKeep2 l j) = S.channel x j := by
  have hn : j.val ≠ l.val := fun he => hj (Fin.ext he)
  exact (vpPpmKeep _ _ _ _ _ _ x _ (vpKeep3 l j)
    (by change (vpKeep2 l j).val ≠ l.val; rw [vpKeep2_val l j hj]; split_ifs <;> omega)
    (by change (vpKeep3 l j).val = if (vpKeep2 l j).val < l.val + 1 + 1 then _ else _
        rw [vpKeep2_val l j hj, vpKeep3_val l j hj]; split_ifs <;> omega)).trans
    (vpC_keep S hS l t ht0 ht1 mask hl hr x j hj)

private theorem vpCases {n : Nat} (l : Fin n) (j : Fin (n + 1 + 1)) :
    j = l.castSucc.castSucc ∨ j = l.succ.castSucc ∨ j = l.succ.succ ∨
      ∃ k, k ≠ l ∧ j = vpKeep2 l k := by
  rcases split_cases l.castSucc j with rfl | ⟨k, rfl⟩
  · exact Or.inr (Or.inl rfl)
  · rcases split_cases l k with rfl | ⟨k, rfl⟩
    · exact Or.inr (Or.inr (Or.inl (vpKeep_right l)))
    · by_cases hk : k = l
      · subst k
        exact Or.inl (by simp only [splitKeep_self, splitLeft])
      · exact Or.inr (Or.inr (Or.inr ⟨k, hk, rfl⟩))

private def vpSwap {n : Nat} (l : Fin n) : Fin (n + 1 + 1) ≃ Fin (n + 1 + 1) :=
  Equiv.swap l.succ.castSucc l.succ.succ

private theorem vpSwap_zero {n : Nat} (l : Fin n) :
    vpSwap l l.castSucc.castSucc = l.castSucc.castSucc :=
  Equiv.swap_apply_of_ne_of_ne
    (by
      intro h; have := congrArg Fin.val h;
      simp only [Fin.val_castSucc, Fin.val_succ] at this; omega)
    (by
      intro h; have := congrArg Fin.val h;
      simp only [Fin.val_castSucc, Fin.val_succ] at this; omega)

private theorem vpSwap_one {n : Nat} (l : Fin n) :
    vpSwap l l.succ.castSucc = l.succ.succ := Equiv.swap_apply_left _ _

private theorem vpSwap_two {n : Nat} (l : Fin n) :
    vpSwap l l.succ.succ = l.succ.castSucc := Equiv.swap_apply_right _ _

private theorem vpSwap_keep {n : Nat} (l j : Fin n) (hj : j ≠ l) :
    vpSwap l (vpKeep2 l j) = vpKeep2 l j := by
  have hn : j.val ≠ l.val := fun he => hj (Fin.ext he)
  apply Equiv.swap_apply_of_ne_of_ne
  · intro h
    have hv := congrArg Fin.val h
    rw [vpKeep2_val l j hj] at hv
    simp only [Fin.val_castSucc, Fin.val_succ] at hv
    split_ifs at hv <;> omega
  · exact vpKeep2_ne l j hj

private def vpLeftEquiv :
    OutputEquiv (vpPL S hS l t ht0 ht1 mask hl hr) (vpOL S hS l t ht0 ht1 mask hl hr) :=
  OutputEquiv.ofCoordinates (vpSwap l) (by
    intro x j
    rcases vpCases l j with rfl | rfl | rfl | ⟨k, hk, rfl⟩
    · exact (congrArg ((vpOL S hS l t ht0 ht1 mask hl hr).channel x) (vpSwap_zero l)).trans
        ((vpOL_zero S hS l t ht0 ht1 mask hl hr x).trans
          (vpPL_zero S hS l t ht0 ht1 mask hl hr x).symm)
    · exact (congrArg ((vpOL S hS l t ht0 ht1 mask hl hr).channel x) (vpSwap_one l)).trans
        ((vpOL_two S hS l t ht0 ht1 mask hl hr x).trans
          (vpPL_one S hS l t ht0 ht1 mask hl hr x).symm)
    · exact (congrArg ((vpOL S hS l t ht0 ht1 mask hl hr).channel x) (vpSwap_two l)).trans
        ((vpOL_one S hS l t ht0 ht1 mask hl hr x).trans
          (vpPL_two S hS l t ht0 ht1 mask hl hr x).symm)
    · exact (congrArg ((vpOL S hS l t ht0 ht1 mask hl hr).channel x) (vpSwap_keep l k hk)).trans
        ((vpOL_keep S hS l t ht0 ht1 mask hl hr x k hk).trans
          (vpPL_keep S hS l t ht0 ht1 mask hl hr x k hk).symm))

private def vpRightEquiv :
    OutputEquiv (vpPR S hS l t ht0 ht1 mask hl hr) (vpOR S hS l t ht0 ht1 mask hl hr) :=
  OutputEquiv.ofCoordinates (Equiv.refl _) (by
    intro x j
    rcases vpCases l j with rfl | rfl | rfl | ⟨k, hk, rfl⟩
    · exact (vpOR_zero S hS l t ht0 ht1 mask hl hr x).trans
        (vpPR_zero S hS l t ht0 ht1 mask hl hr x).symm
    · exact (vpOR_one S hS l t ht0 ht1 mask hl hr x).trans
        (vpPR_one S hS l t ht0 ht1 mask hl hr x).symm
    · exact (vpOR_two S hS l t ht0 ht1 mask hl hr x).trans
        (vpPR_two S hS l t ht0 ht1 mask hl hr x).symm
    · exact (vpOR_keep S hS l t ht0 ht1 mask hl hr x k hk).trans
        (vpPR_keep S hS l t ht0 ht1 mask hl hr x k hk).symm)

private def vpPrefix : OperationPath S (vpC S hS l t ht0 ht1 mask hl hr) :=
  ((OperationPath.nil.snoc (.pps S hS l t ht0 ht1)).snoc
    (.vps (vpA S hS l t ht0 ht1) (pps_isSingular _ _ _ _ _ _) l.castSucc mask
      (vpAWitness S hS l t ht0 ht1 mask true hl)
      (vpAWitness S hS l t ht0 ht1 mask false hr))).snoc
    (.vps (vpB S hS l t ht0 ht1 mask hl hr) (vps_isSingular _ _ _ _ _ _) l.succ.succ mask
      (vpBWitness S hS l t ht0 ht1 mask hl hr true hl)
      (vpBWitness S hS l t ht0 ht1 mask hl hr false hr))

private def vpLeftPath : OperationPath S (vpPL S hS l t ht0 ht1 mask hl hr) :=
  (vpPrefix S hS l t ht0 ht1 mask hl hr).snoc
    (.ppm (vpC S hS l t ht0 ht1 mask hl hr) (vps_isSingular _ _ _ _ _ _)
      l.succ.castSucc.castSucc l.succ.succ.succ
      (by change l.val + 1 < l.val + 1 + 1 + 1; omega) (vpPatternL S hS l t ht0 ht1 mask hl hr))

private def vpRightPath : OperationPath S (vpPR S hS l t ht0 ht1 mask hl hr) :=
  (vpPrefix S hS l t ht0 ht1 mask hl hr).snoc
    (.ppm (vpC S hS l t ht0 ht1 mask hl hr) (vps_isSingular _ _ _ _ _ _)
      l.castSucc.castSucc.castSucc l.succ.succ.castSucc
      (by change l.val < l.val + 1 + 1; omega) (vpPatternR S hS l t ht0 ht1 mask hl hr))

private def vpLeftCascade : Cascade S (vpOL S hS l t ht0 ht1 mask hl hr) :=
  ⟨_, vpLeftPath S hS l t ht0 ht1 mask hl hr, vpLeftEquiv S hS l t ht0 ht1 mask hl hr⟩

private def vpRightCascade : Cascade S (vpOR S hS l t ht0 ht1 mask hl hr) :=
  ⟨_, vpRightPath S hS l t ht0 ht1 mask hl hr, vpRightEquiv S hS l t ht0 ht1 mask hl hr⟩

private theorem vpLeft_tags :
    (vpLeftCascade S hS l t ht0 ht1 mask hl hr).path.tags = [.pps, .vps, .vps, .ppm] := rfl

private theorem vpRight_tags :
    (vpRightCascade S hS l t ht0 ht1 mask hl hr).path.tags = [.pps, .vps, .vps, .ppm] := rfl

-- Equation (167) is consumed from C07, including null rows and its Real interpretation.
section
attribute [local instance] Classical.propDecidable
example (x : alpha) :
    (if (vpV S hS l mask hl hr).channel x (splitLeft l) ≠ 0 then (1 : ℝ) else 0) +
      (if (vpV S hS l mask hl hr).channel x (splitRight l) ≠ 0 then 1 else 0) =
      if S.channel x l ≠ 0 then 1 else 0 :=
  vps_support_indicator_sum S hS l mask hl hr x
end

end
end PerfectFunctionalRepresentations.MatrixOperations

-- Disjoint operations commute; the private coordinate evaluator covers every
-- ordering of the selected labels and every unaffected output.
namespace PerfectFunctionalRepresentations.MatrixOperations
noncomputable section
universe u
variable {alpha : Type u} {n : Nat}
private def dcMass (K : alpha → PMF (Fin n)) (x : alpha) (j : Nat) : ENNReal :=
  if h : j < n then K x ⟨j, h⟩ else 0
private theorem dcMass_fin (K : alpha → PMF (Fin n)) (x : alpha) (j : Fin n) :
    dcMass K x j.val = K x j := by simp [dcMass, j.isLt]
private def dcSplit (f : Nat → ENNReal) (l : Nat) (p q : ENNReal) (j : Nat) : ENNReal :=
  if j < l then f j else if j = l then p * f l
  else if j = l + 1 then q * f l else f (j - 1)
private theorem dcKeepVal (l j : Fin n) :
    (splitKeep l j).val = if j.val ≤ l.val then j.val else j.val + 1 := by
  by_cases h : j ≤ l
  · rw [splitKeep_of_le l j h, if_pos (show j.val ≤ l.val from h)]; rfl
  · rw [splitKeep_of_lt l j (lt_of_not_ge h), if_neg (show ¬ j.val ≤ l.val from h)]; rfl
private theorem dcSplitCoordinates (K : alpha → PMF (Fin n))
    (L : alpha → PMF (Fin (n + 1))) (l : Fin n) (p q : ENNReal) (x : alpha)
    (hl : L x (splitLeft l) = p * K x l)
    (hr : L x (splitRight l) = q * K x l)
    (hk : ∀ i, i ≠ l → L x (splitKeep l i) = K x i) (j : Nat) :
    dcMass L x j = dcSplit (dcMass K x) l.val p q j := by
  by_cases hj : j < n + 1
  · let k : Fin (n + 1) := ⟨j, hj⟩
    change dcMass L x k.val = _
    rw [dcMass_fin]
    rcases split_cases l k with hright | ⟨i, hi⟩
    · have hjl : j = l.val + 1 := congrArg Fin.val hright
      rw [hright, hr]
      subst j
      simp [dcSplit, dcMass_fin]
    · have hjl : j = (splitKeep l i).val := congrArg Fin.val hi
      rw [hi]
      by_cases hil : i = l
      · subst i
        rw [splitKeep_self, hl]
        have hjl' : j = l.val := by simpa [splitLeft] using hjl
        rw [hjl']
        simp [dcSplit, dcMass_fin]
      · rw [hk i hil]
        rw [dcKeepVal] at hjl
        have hne : i.val ≠ l.val := fun h => hil (Fin.ext h)
        by_cases hle : i.val ≤ l.val
        · rw [if_pos hle] at hjl
          subst j
          rw [dcSplit, if_pos (by omega), dcMass_fin]
        · rw [if_neg hle] at hjl
          subst j
          rw [dcSplit, if_neg (by omega), if_neg (by omega), if_neg (by omega)]
          simpa using (dcMass_fin K x i).symm
  · have hbound := l.isLt
    rw [dcMass, dif_neg hj, dcSplit, if_neg (by omega), if_neg (by omega),
      if_neg (by omega), dcMass, dif_neg (by omega)]

private theorem dcPps (K : alpha → PMF (Fin n)) (l : Fin n)
    (t : NNReal) (ht : t ≤ 1) (x : alpha) (j : Nat) :
    dcMass (ppsRaw K l t ht) x j =
      dcSplit (dcMass K x) l.val t (1 - t : NNReal) j :=
  dcSplitCoordinates K _ l _ _ x (ppsRaw_left K l t ht x)
    (ppsRaw_right K l t ht x) (fun _ h => ppsRaw_keep K l t ht x h) j

private theorem dcVps (K : alpha → PMF (Fin n)) (l : Fin n)
    (mask : alpha → Bool) (x : alpha) (j : Nat) :
    dcMass (vpsRaw K l mask) x j = dcSplit (dcMass K x) l.val
      (if mask x then 1 else 0) (if mask x then 0 else 1) j :=
  dcSplitCoordinates K _ l _ _ x
    (by rw [vpsRaw_left]; cases mask x <;> simp)
    (by rw [vpsRaw_right]; cases mask x <;> simp)
    (fun _ h => vpsRaw_keep K l mask x h) j

private def dcMerge (f : Nat → ENNReal) (a b j : Nat) : ENNReal :=
  if j = a then f a + f b else if j < b then f j else f (j + 1)
private def dcInsert (l j : Nat) := if j ≤ l then j else j + 1
private def dcDelete (b j : Nat) := if j < b then j else j - 1

private theorem dcMergeSplitDisjoint (f : Nat → ENNReal) (a b c : Nat)
    (hab : a < b) (hca : c ≠ a) (hcb : c ≠ b) (p q : ENNReal) (j : Nat) :
    dcSplit (dcMerge f a b) (dcDelete b c) p q j =
    dcMerge (dcSplit f c p q) (dcInsert c a) (dcInsert c b) j := by
  by_cases hc0 : c < a
  · by_cases h0 : j < c
    · simp (disch := omega) [dcInsert, dcDelete, dcSplit, dcMerge, if_pos, if_neg]
    by_cases h1 : j = c
    · subst j; simp (disch := omega) [dcInsert, dcDelete, dcSplit, dcMerge, if_pos, if_neg]
    by_cases h2 : j = c + 1
    · subst j; simp (disch := omega) [dcInsert, dcDelete, dcSplit, dcMerge, if_pos, if_neg]
    by_cases h3 : j < a + 1
    · simp (disch := omega) [dcInsert, dcDelete, dcSplit, dcMerge, if_pos, if_neg]
    by_cases h4 : j = a + 1
    · subst j; simp (disch := omega) [dcInsert, dcDelete, dcSplit, dcMerge, if_pos, if_neg]
    by_cases h5 : j < b + 1
    · simp (disch := omega) [dcInsert, dcDelete, dcSplit, dcMerge, if_pos, if_neg]
    simp (disch := omega) [dcInsert, dcDelete, dcSplit, dcMerge, if_pos, if_neg]
  · by_cases hc1 : c < b
    · by_cases h0 : j < a
      · simp (disch := omega) [dcInsert, dcDelete, dcSplit, dcMerge, if_pos, if_neg]
      by_cases h1 : j = a
      · subst j; simp (disch := omega) [dcInsert, dcDelete, dcSplit, dcMerge, if_pos, if_neg]
      by_cases h2 : j < c
      · simp (disch := omega) [dcInsert, dcDelete, dcSplit, dcMerge, if_pos, if_neg]
      by_cases h3 : j = c
      · subst j; simp (disch := omega) [dcInsert, dcDelete, dcSplit, dcMerge, if_pos, if_neg]
      by_cases h4 : j = c + 1
      · subst j; simp (disch := omega) [dcInsert, dcDelete, dcSplit, dcMerge, if_pos, if_neg]
      by_cases h5 : j < b + 1
      · simp (disch := omega) [dcInsert, dcDelete, dcSplit, dcMerge, if_pos, if_neg]
      simp (disch := omega) [dcInsert, dcDelete, dcSplit, dcMerge, if_pos, if_neg]
    · by_cases h0 : j < a
      · simp (disch := omega) [dcInsert, dcDelete, dcSplit, dcMerge, if_pos, if_neg]
      by_cases h1 : j = a
      · subst j; simp (disch := omega) [dcInsert, dcDelete, dcSplit, dcMerge, if_pos, if_neg]
      by_cases h2 : j < b
      · simp (disch := omega) [dcInsert, dcDelete, dcSplit, dcMerge, if_pos, if_neg]
      by_cases h3 : j < c - 1
      · simp (disch := omega) [dcInsert, dcDelete, dcSplit, dcMerge, if_pos, if_neg]
      by_cases h4 : j = c - 1
      · subst j; simp (disch := omega) [dcInsert, dcDelete, dcSplit, dcMerge, if_pos, if_neg]
      by_cases h5 : j = c
      · subst j; simp (disch := omega) [dcInsert, dcDelete, dcSplit, dcMerge, if_pos, if_neg]
      simp (disch := omega) [dcInsert, dcDelete, dcSplit, dcMerge, if_pos, if_neg]
private theorem dcSplitSplitOrdered (f : Nat → ENNReal) (a b : Nat)
    (hab : a < b) (p q r s : ENNReal) (j : Nat) :
    dcSplit (dcSplit f a p q) (dcInsert a b) r s j =
    dcSplit (dcSplit f b r s) (dcInsert b a) p q j := by
  have hba : ¬ b ≤ a := by omega
  simp only [dcInsert, if_pos (Nat.le_of_lt hab), if_neg hba]
  by_cases hj0 : j < a
  · simp (disch := omega) [dcSplit, if_pos, if_neg]
  by_cases hj1 : j = a
  · subst j; simp (disch := omega) [dcSplit, if_pos, if_neg]
  by_cases hj2 : j = a + 1
  · subst j; simp (disch := omega) [dcSplit, if_pos, if_neg]
  by_cases hj3 : j < b + 1
  · simp (disch := omega) [dcSplit, if_pos, if_neg]
  by_cases hj4 : j = b + 1
  · subst j; simp (disch := omega) [dcSplit, if_pos, if_neg]
  by_cases hj5 : j = b + 2
  · subst j; simp (disch := omega) [dcSplit, if_pos, if_neg]
  simp (disch := omega) [dcSplit, if_pos, if_neg]
private theorem dcSplitSplitDisjoint (f : Nat → ENNReal) (a b : Nat)
    (hab : a ≠ b) (p q r s : ENNReal) (j : Nat) :
    dcSplit (dcSplit f a p q) (dcInsert a b) r s j =
    dcSplit (dcSplit f b r s) (dcInsert b a) p q j := by
  rcases lt_or_gt_of_ne hab with h | h
  · exact dcSplitSplitOrdered f a b h p q r s j
  · exact (dcSplitSplitOrdered f b a h r s p q j).symm

variable [Finite alpha] [Nonempty alpha]
private theorem dcRetainedVal (S : ActiveFiniteChannel alpha) (b : Fin S.outputCard)
    (j : Fin (S.outputCard - 1)) :
    (activeMergeRetained S b j).val = if j.val < b.val then j.val else j.val + 1 := by
  simp only [activeMergeRetained, mergeSourceEquiv_symm_val, Fin.succAbove]
  simp only [Fin.lt_def, Fin.val_castSucc, mergeSourceEquiv_val]
  split_ifs <;> rfl

private theorem dcPpm (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) (x : alpha) (j : Nat) :
    dcMass (ppm S hS a b hab hp).channel x j =
      dcMerge (dcMass S.channel x) a.val b.val j := by
  have ha : a.val < b.val := hab
  have hb := b.isLt
  by_cases hj : j < S.outputCard - 1
  · let k : Fin (S.outputCard - 1) := ⟨j, hj⟩
    change dcMass (ppm S hS a b hab hp).channel x k.val = _
    rw [dcMass_fin (ppm S hS a b hab hp).channel x k]
    by_cases hk : k = activeMergeSurvivor S a b hab
    · have hja : j = a.val := (congrArg Fin.val hk).trans (activeMergeSurvivor_val S a b hab)
      rw [hk, ppm_apply_survivor, hja, dcMerge, if_pos rfl, dcMass_fin, dcMass_fin]
    · have hja : j ≠ a.val :=
        fun h => hk (Fin.ext (h.trans (activeMergeSurvivor_val S a b hab).symm))
      rw [ppm_apply_unaffected S hS a b hab hp x hk]
      rw [← dcMass_fin S.channel x (activeMergeRetained S b k), dcRetainedVal]
      rw [dcMerge, if_neg hja]
      change dcMass S.channel x (if j < b.val then j else j + 1) = _
      split_ifs <;> rfl
  · rw [dcMass, dif_neg (show ¬ j < (ppm S hS a b hab hp).outputCard from hj),
      dcMerge, if_neg (by omega), if_neg (by omega),
      dcMass, dif_neg (by omega)]
private inductive DcChoice (S : ActiveFiniteChannel alpha) (l : Fin S.outputCard)
  | pp (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1)
  | vp (mask : alpha → Bool)
      (hl : ∃ x, S.channel x l ≠ 0 ∧ mask x = true)
      (hr : ∃ x, S.channel x l ≠ 0 ∧ mask x = false)

private def dcDo (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) : DcChoice S l → ActiveFiniteChannel alpha
  | .pp t ht0 ht1 => pps S hS l t ht0 ht1
  | .vp mask hl hr => vps S hS l mask hl hr
private def dcStep (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (c : DcChoice S l) : OperationStep S (dcDo S hS l c) :=
  match c with
  | .pp t ht0 ht1 => .pps S hS l t ht0 ht1
  | .vp mask hl hr => .vps S hS l mask hl hr
private theorem dcDoCard (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (c : DcChoice S l) : (dcDo S hS l c).outputCard = S.outputCard + 1 := by
  cases c <;> rfl
private def dcWeightL {S : ActiveFiniteChannel alpha} {l : Fin S.outputCard}
    (c : DcChoice S l) (x : alpha) : ENNReal :=
  match c with | .pp t _ _ => t | .vp mask _ _ => if mask x then 1 else 0
private def dcWeightR {S : ActiveFiniteChannel alpha} {l : Fin S.outputCard}
    (c : DcChoice S l) (x : alpha) : ENNReal :=
  match c with | .pp t _ _ => (1 - t : NNReal) | .vp mask _ _ => if mask x then 0 else 1
private def dcKind {S : ActiveFiniteChannel alpha} {l : Fin S.outputCard}
    (c : DcChoice S l) : OperationKind := match c with | .pp .. => .pps | .vp .. => .vps
private theorem dcStepKind (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (c : DcChoice S l) : (dcStep S hS l c).kind = dcKind c := by
  cases c <;> rfl
private theorem dcDoMass (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (c : DcChoice S l) (x : alpha) (j : Nat) :
    dcMass (dcDo S hS l c).channel x j =
      dcSplit (dcMass S.channel x) l.val (dcWeightL c x) (dcWeightR c x) j := by
  cases c with
  | pp t ht0 ht1 => exact dcPps S.channel l t ht1.le x j
  | vp mask hl hr => exact dcVps S.channel l mask x j

private def dcKeep (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (c : DcChoice S l) (i : Fin S.outputCard) :
    Fin (dcDo S hS l c).outputCard :=
  (finCongr (dcDoCard S hS l c)).symm (splitKeep l i)
private theorem dcKeep_val (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (c : DcChoice S l) (i : Fin S.outputCard) :
    (dcKeep S hS l c i).val = if i.val ≤ l.val then i.val else i.val + 1 := dcKeepVal l i
private theorem dcDoKeep (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (c : DcChoice S l) (x : alpha) {i : Fin S.outputCard} (hi : i ≠ l) :
    (dcDo S hS l c).channel x (dcKeep S hS l c i) = S.channel x i := by
  cases c with
  | pp t ht0 ht1 => exact pps_keep S hS l t ht0 ht1 x hi
  | vp mask hl hr => exact vps_keep S hS l mask hl hr x hi
private theorem dcKeep_lt (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (c : DcChoice S l) (a b : Fin S.outputCard) (hab : a < b) :
    dcKeep S hS l c a < dcKeep S hS l c b := by
  change (dcKeep S hS l c a).val < (dcKeep S hS l c b).val
  rw [dcKeep_val, dcKeep_val]
  have h : a.val < b.val := hab
  split_ifs <;> omega

private def dcRebase {S : ActiveFiniteChannel alpha} {l : Fin S.outputCard}
    (c : DcChoice S l) (T : ActiveFiniteChannel alpha) (k : Fin T.outputCard)
    (h : ∀ x, T.channel x k = S.channel x l) : DcChoice T k :=
  match c with
  | .pp t ht0 ht1 => .pp t ht0 ht1
  | .vp mask hl hr => .vp mask
      (by obtain ⟨x, hx, hm⟩ := hl; exact ⟨x, by rwa [h], hm⟩)
      (by obtain ⟨x, hx, hm⟩ := hr; exact ⟨x, by rwa [h], hm⟩)
private theorem dcRebaseWeightL {S T : ActiveFiniteChannel alpha}
    {l : Fin S.outputCard} (c : DcChoice S l) (k : Fin T.outputCard)
    (h : ∀ x, T.channel x k = S.channel x l) (x : alpha) :
    dcWeightL (dcRebase c T k h) x = dcWeightL c x := by cases c <;> rfl
private theorem dcRebaseWeightR {S T : ActiveFiniteChannel alpha}
    {l : Fin S.outputCard} (c : DcChoice S l) (k : Fin T.outputCard)
    (h : ∀ x, T.channel x k = S.channel x l) (x : alpha) :
    dcWeightR (dcRebase c T k h) x = dcWeightR c x := by cases c <;> rfl
private theorem dcRebaseKind {S T : ActiveFiniteChannel alpha}
    {l : Fin S.outputCard} (c : DcChoice S l) (k : Fin T.outputCard)
    (h : ∀ x, T.channel x k = S.channel x l) :
    dcKind (dcRebase c T k h) = dcKind c := by cases c <;> rfl

private def dcOfMass (S T : ActiveFiniteChannel alpha) (hcard : S.outputCard = T.outputCard)
    (h : ∀ x j, dcMass T.channel x j = dcMass S.channel x j) : OutputEquiv S T :=
  OutputEquiv.ofCoordinates (finCongr hcard) (by
    intro x j
    calc T.channel x (finCongr hcard j)
        = dcMass T.channel x j.val := (dcMass_fin T.channel x (finCongr hcard j)).symm
      _ = dcMass S.channel x j.val := h x j.val
      _ = S.channel x j := dcMass_fin S.channel x j)

section MergeDisjoint
variable (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0)
local notation "M" => ppm S hS a b hab hp
local notation "hM" => ppm_isSingular S hS a b hab hp
variable (l : Fin (S.outputCard - 1)) (hl : l ≠ activeMergeSurvivor S a b hab)
    (spec : DcChoice (ppm S hS a b hab hp) l)
local notation "c" => activeMergeRetained S b l

include hab hl in
private theorem dcRetained_ne_a : c ≠ a := by
  have hla : l.val ≠ a.val := by
    intro he
    exact hl (Fin.ext (he.trans (activeMergeSurvivor_val S a b hab).symm))
  intro he
  have hv := congrArg Fin.val he
  rw [dcRetainedVal] at hv
  have ha : a.val < b.val := hab
  split_ifs at hv <;> omega
private theorem dcRetained_ne_b : c ≠ b := by
  intro he
  have hv := congrArg Fin.val he
  rw [dcRetainedVal] at hv
  split_ifs at hv <;> omega

local notation "sp" => dcRebase spec S c
  (fun x => Eq.symm (ppm_apply_unaffected S hS a b hab hp x hl))
local notation "P" => dcDo S hS c sp
local notation "hP" => OperationStep.isSingular (dcStep S hS c sp)
local notation "aa" => dcKeep S hS c sp a
local notation "bb" => dcKeep S hS c sp b
include S hS a b hab hp l hl spec
private theorem dcDisjointPattern (x : alpha) : (P).channel x aa ≠ 0 ↔ (P).channel x bb ≠ 0 := by
  have ha := dcDoKeep S hS c sp x (Ne.symm (dcRetained_ne_a S a b hab l hl))
  have hb := dcDoKeep S hS c sp x (Ne.symm (dcRetained_ne_b S b l))
  constructor
  · intro hx hz
    exact (hp x).mp (fun h => hx (ha.trans h)) (hb.symm.trans hz)
  · intro hx hz
    exact (hp x).mpr (fun h => hx (hb.trans h)) (ha.symm.trans hz)
local notation "hh" => dcKeep_lt S hS c sp a b hab
local notation "hpp" => dcDisjointPattern S hS a b hab hp l hl spec
private def dcMergeDisjointPath : OperationPath S (ppm P hP aa bb hh hpp) :=
  (OperationPath.nil.snoc (dcStep S hS c sp)).snoc (.ppm P hP aa bb hh hpp)

private def dcMergeDisjoint : Cascade S (dcDo M hM l spec) where
  endpoint := ppm P hP aa bb hh hpp
  path := dcMergeDisjointPath S hS a b hab hp l hl spec
  outputEquiv := dcOfMass _ _ (by
    calc (ppm P hP aa bb hh hpp).outputCard
        = (S.outputCard + 1) - 1 := congrArg (fun n => n - 1) (dcDoCard S hS c sp)
      _ = (S.outputCard - 1) + 1 := by have := S.outputCard_pos; omega
      _ = (dcDo M hM l spec).outputCard := (dcDoCard M hM l spec).symm) (by
    intro x j
    have hm : dcMass (M).channel x = dcMerge (dcMass S.channel x) a.val b.val :=
      funext (dcPpm S hS a b hab hp x)
    have hs : dcMass (P).channel x = dcSplit (dcMass S.channel x) (c).val
        (dcWeightL sp x) (dcWeightR sp x) := funext (dcDoMass S hS c sp x)
    have hs' : dcMass (P).channel x = dcSplit (dcMass S.channel x) (c).val
        (dcWeightL spec x) (dcWeightR spec x) :=
      hs.trans (congrArg₂ (fun p q => dcSplit (dcMass S.channel x) (c).val p q)
        (dcRebaseWeightL spec c _ x) (dcRebaseWeightR spec c _ x))
    have hindex : l.val = dcDelete b.val (c).val := by
      unfold dcDelete
      rw [dcRetainedVal]
      split_ifs <;> omega
    calc dcMass (dcDo M hM l spec).channel x j
        = dcSplit (dcMass (M).channel x) l.val (dcWeightL spec x) (dcWeightR spec x) j :=
          dcDoMass M hM l spec x j
      _ = dcSplit (dcMerge (dcMass S.channel x) a.val b.val) l.val
          (dcWeightL spec x) (dcWeightR spec x) j :=
          congrArg (fun f => dcSplit f l.val (dcWeightL spec x) (dcWeightR spec x) j) hm
      _ = dcSplit (dcMerge (dcMass S.channel x) a.val b.val) (dcDelete b.val (c).val)
          (dcWeightL spec x) (dcWeightR spec x) j :=
          congrArg (fun i => dcSplit (dcMerge (dcMass S.channel x) a.val b.val) i
            (dcWeightL spec x) (dcWeightR spec x) j) hindex
      _ = dcMerge (dcSplit (dcMass S.channel x) (c).val (dcWeightL spec x) (dcWeightR spec x))
          (dcInsert (c).val a.val) (dcInsert (c).val b.val) j :=
          dcMergeSplitDisjoint (dcMass S.channel x) a.val b.val (c).val hab
            (fun he => dcRetained_ne_a S a b hab l hl (Fin.ext he))
            (fun he => dcRetained_ne_b S b l (Fin.ext he))
            (dcWeightL spec x) (dcWeightR spec x) j
      _ = dcMerge (dcMass (P).channel x) (dcInsert (c).val a.val) (dcInsert (c).val b.val) j :=
          congrArg (fun f => dcMerge f (dcInsert (c).val a.val) (dcInsert (c).val b.val) j) hs'.symm
      _ = dcMerge (dcMass (P).channel x) (aa).val (bb).val j :=
          congrArg₂ (fun i k => dcMerge (dcMass (P).channel x) i k j)
            (dcKeep_val S hS c sp a).symm (dcKeep_val S hS c sp b).symm
      _ = dcMass (ppm P hP aa bb hh hpp).channel x j := (dcPpm P hP aa bb hh hpp x j).symm)

private theorem dcMergeDisjoint_tags :
    (dcMergeDisjoint S hS a b hab hp l hl spec).path.tags = [dcKind spec, .ppm] := by
  cases spec <;> rfl
end MergeDisjoint

section SplitDisjoint
variable (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (a : Fin S.outputCard) (first : DcChoice S a) (b : Fin S.outputCard) (hba : b ≠ a)
local notation "A" => dcDo S hS a first
local notation "hA" => OperationStep.isSingular (dcStep S hS a first)
local notation "bA" => dcKeep S hS a first b
variable (second : DcChoice (dcDo S hS a first) (dcKeep S hS a first b))
local notation "bs" => dcRebase second S b (fun x => Eq.symm (dcDoKeep S hS a first x hba))
local notation "B" => dcDo S hS b bs
local notation "hB" => OperationStep.isSingular (dcStep S hS b bs)
local notation "aB" => dcKeep S hS b bs a
local notation "as" => dcRebase first B aB (fun x => dcDoKeep S hS b bs x (Ne.symm hba))
include S hS a first b hba second
private def dcSplitDisjointPath : OperationPath S (dcDo B hB aB as) :=
  (OperationPath.nil.snoc (dcStep S hS b bs)).snoc (dcStep B hB aB as)
private def dcSplitDisjoint : Cascade S (dcDo A hA bA second) where
  endpoint := dcDo B hB aB as
  path := dcSplitDisjointPath S hS a first b hba second
  outputEquiv := dcOfMass _ _ (by simp only [dcDoCard]) (by
    intro x j
    have ha : dcMass (A).channel x = dcSplit (dcMass S.channel x) a.val
        (dcWeightL first x) (dcWeightR first x) := funext (dcDoMass S hS a first x)
    have hb : dcMass (B).channel x = dcSplit (dcMass S.channel x) b.val
        (dcWeightL bs x) (dcWeightR bs x) := funext (dcDoMass S hS b bs x)
    rw [dcDoMass, dcDoMass, ha, hb]
    simp only [dcRebaseWeightL, dcRebaseWeightR, dcKeep_val]
    exact dcSplitSplitDisjoint (dcMass S.channel x) a.val b.val
      (fun he => hba (Fin.ext he.symm)) (dcWeightL first x) (dcWeightR first x)
      (dcWeightL second x) (dcWeightR second x) j)
private theorem dcSplitDisjoint_tags :
    (dcSplitDisjoint S hS a first b hba second).path.tags = [dcKind second, dcKind first] := by
  simp only [dcSplitDisjoint, dcSplitDisjointPath, OperationPath.tags_snoc,
    OperationPath.tags_nil, dcStepKind, dcRebaseKind]
  rfl
end SplitDisjoint

end
end PerfectFunctionalRepresentations.MatrixOperations

-- The two merge/split overlaps share their finite-label calculations.
namespace PerfectFunctionalRepresentations.MatrixOperations
universe u
variable {alpha : Type u} [Finite alpha] [Nonempty alpha]
noncomputable section

private def ppLiftLabel (a k : Nat) : Nat := if k ≤ a then k else k + 1
private def ppRetainLabel (b k : Nat) : Nat := if k < b then k else k + 1

private theorem ppRetainLift (a b k : Nat) (hab : a < b) :
    ppRetainLabel (b + 1) (ppRetainLabel (b + 1) (ppLiftLabel a k)) =
      ppLiftLabel (b + 1) (ppLiftLabel a (ppRetainLabel b k)) := by
  simp only [ppRetainLabel, ppLiftLabel]
  split_ifs <;> omega

private theorem ppRetainLiftNe (a b k : Nat) (hab : a < b) (hk : k ≠ a) :
    ppRetainLabel (b + 1) (ppLiftLabel a k) ≠ a := by
  simp only [ppRetainLabel, ppLiftLabel]
  split_ifs <;> omega

private theorem ppSplitKeepVal {n : Nat} (l j : Fin n) :
    (splitKeep l j).val = if j.val ≤ l.val then j.val else j.val + 1 := by
  by_cases h : j ≤ l
  · rw [splitKeep_of_le l j h, if_pos (show j.val ≤ l.val from h)]
    rfl
  · rw [splitKeep_of_lt l j (lt_of_not_ge h), if_neg (show ¬ j.val ≤ l.val from h)]
    rfl

private theorem ppRetainedVal (S : ActiveFiniteChannel alpha) (b : Fin S.outputCard)
    (j : Fin (S.outputCard - 1)) :
    (activeMergeRetained S b j).val = if j.val < b.val then j.val else j.val + 1 := by
  change ((mergeSourceEquiv S b).succAbove j).val = _
  by_cases h : j.val < b.val
  · rw [Fin.succAbove_of_castSucc_lt _ _ (show j.castSucc < mergeSourceEquiv S b from h), if_pos h]
    rfl
  · rw [Fin.succAbove_of_le_castSucc _ _
      (show mergeSourceEquiv S b ≤ j.castSucc from le_of_not_gt h), if_neg h]
    rfl

section Overlap
variable (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
  (a b : Fin S.outputCard) (hab : a < b)
  (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0)
  (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1)

include hab

local notation "A" => pps S hS a t ht0 ht1
local notation "hA" => pps_isSingular S hS a t ht0 ht1
local notation "b'" => splitKeep a b
local notation "B" => pps A hA b' t ht0 ht1
local notation "hB" => pps_isSingular A hA b' t ht0 ht1
local notation "aL" => splitKeep b' (splitLeft a)
local notation "aR" => splitKeep b' (splitRight a)
local notation "bL" => splitLeft b'
local notation "bR" => splitRight b'

private theorem ppBVal : (b').val = b.val + 1 := by rw [splitKeep_of_lt a b hab]; rfl
private theorem ppALVal : (aL).val = a.val := by
  have h : splitLeft a ≤ b' := by
    change a.val ≤ (b').val
    rw [ppBVal S a b hab]
    have ha : a.val < b.val := hab
    omega
  exact congrArg Fin.val (splitKeep_of_le b' (splitLeft a) h)
private theorem ppARVal : (aR).val = a.val + 1 := by
  have h : splitRight a ≤ b' := by
    change a.val + 1 ≤ (b').val
    rw [ppBVal S a b hab]
    have ha : a.val < b.val := hab
    omega
  exact congrArg Fin.val (splitKeep_of_le b' (splitRight a) h)
private theorem ppBLVal : (bL).val = b.val + 1 := ppBVal S a b hab
private theorem ppBRVal : (bR).val = b.val + 2 := by
  simp only [splitRight, Fin.val_succ, ppBVal S a b hab]

private theorem ppALNeB : splitLeft a ≠ b' := by
  intro h
  have he := congrArg Fin.val h
  simp only [splitLeft, Fin.val_castSucc, ppBVal S a b hab] at he
  omega
private theorem ppARNeB : splitRight a ≠ b' := by
  intro h
  have he := congrArg Fin.val h
  simp only [splitRight, Fin.val_succ, ppBVal S a b hab] at he
  have := hab
  omega

private theorem ppBAL (x : alpha) : (B).channel x aL = (t : ENNReal) * S.channel x a :=
  (pps_keep A hA b' t ht0 ht1 x (ppALNeB S a b hab)).trans
    (pps_left S hS a t ht0 ht1 x)
private theorem ppBAR (x : alpha) :
    (B).channel x aR = ((1 - t : NNReal) : ENNReal) * S.channel x a :=
  (pps_keep A hA b' t ht0 ht1 x (ppARNeB S a b hab)).trans
    (pps_right S hS a t ht0 ht1 x)
private theorem ppBBL (x : alpha) : (B).channel x bL = (t : ENNReal) * S.channel x b :=
  (pps_left A hA b' t ht0 ht1 x).trans
    (congrArg (fun p => (t : ENNReal) * p)
      (pps_keep S hS a t ht0 ht1 x (ne_of_gt hab)))
private theorem ppBBR (x : alpha) :
    (B).channel x bR = ((1 - t : NNReal) : ENNReal) * S.channel x b :=
  (pps_right A hA b' t ht0 ht1 x).trans
    (congrArg (fun p => ((1 - t : NNReal) : ENNReal) * p)
      (pps_keep S hS a t ht0 ht1 x (ne_of_gt hab)))

private theorem ppLeftLt : aL < bL := by
  change (aL).val < (bL).val
  rw [ppALVal S a b hab, ppBLVal S a b hab]
  have := hab
  omega

include hp in
private theorem ppLeftPattern (x : alpha) : (B).channel x aL ≠ 0 ↔ (B).channel x bL ≠ 0 := by
  rw [ppBAL S hS a b hab t ht0 ht1 x, ppBBL S hS a b hab t ht0 ht1 x]
  have ht : (t : ENNReal) ≠ 0 := ENNReal.coe_ne_zero.mpr (ne_of_gt ht0)
  exact ⟨fun h => mul_ne_zero ht ((hp x).mp (right_ne_zero_of_mul h)),
    fun h => mul_ne_zero ht ((hp x).mpr (right_ne_zero_of_mul h))⟩

local notation "C" => ppm B hB aL bL (ppLeftLt S a b hab)
  (ppLeftPattern S hS a b hab hp t ht0 ht1)
local notation "hC" => ppm_isSingular B hB aL bL (ppLeftLt S a b hab)
  (ppLeftPattern S hS a b hab hp t ht0 ht1)

-- After deleting bL, these are exactly the retained right descendants.
private def ppRightA : Fin (C).outputCard := ⟨a.val + 1, by
  change a.val + 1 < (S.outputCard + 1 + 1) - 1
  have hb := b.isLt
  have ha : a.val < b.val := hab
  omega⟩
private def ppRightB : Fin (C).outputCard := ⟨b.val + 1, by
  change b.val + 1 < (S.outputCard + 1 + 1) - 1
  have hb := b.isLt
  omega⟩

private theorem ppRightARetained : activeMergeRetained B bL
    (ppRightA S hS a b hab hp t ht0 ht1) = aR := by
  apply Fin.ext
  have h := ppRetainedVal B bL (ppRightA S hS a b hab hp t ht0 ht1)
  have hl := ppBLVal S a b hab
  have hr := ppARVal S a b hab
  change (activeMergeRetained B bL (ppRightA S hS a b hab hp t ht0 ht1)).val =
    (if a.val + 1 < (bL).val then a.val + 1 else a.val + 1 + 1) at h
  rw [hl, if_pos (by have ha : a.val < b.val := hab; omega)] at h
  exact h.trans hr.symm
private theorem ppRightBRetained : activeMergeRetained B bL
    (ppRightB S hS a b hab hp t ht0 ht1) = bR := by
  apply Fin.ext
  have h := ppRetainedVal B bL (ppRightB S hS a b hab hp t ht0 ht1)
  have hl := ppBLVal S a b hab
  have hr := ppBRVal S a b hab
  change (activeMergeRetained B bL (ppRightB S hS a b hab hp t ht0 ht1)).val =
    (if b.val + 1 < (bL).val then b.val + 1 else b.val + 1 + 1) at h
  rw [hl, if_neg (lt_irrefl _)] at h
  exact h.trans hr.symm

private theorem ppRightANeSurvivor : ppRightA S hS a b hab hp t ht0 ht1 ≠
    activeMergeSurvivor B aL bL (ppLeftLt S a b hab) := by
  intro h
  have he : a.val + 1 = a.val := (congrArg Fin.val h).trans
    ((activeMergeSurvivor_val B aL bL (ppLeftLt S a b hab)).trans (ppALVal S a b hab))
  omega
private theorem ppRightBNeSurvivor : ppRightB S hS a b hab hp t ht0 ht1 ≠
    activeMergeSurvivor B aL bL (ppLeftLt S a b hab) := by
  intro h
  have he : b.val + 1 = a.val := (congrArg Fin.val h).trans
    ((activeMergeSurvivor_val B aL bL (ppLeftLt S a b hab)).trans (ppALVal S a b hab))
  have ha : a.val < b.val := hab
  omega

private theorem ppCRightA (x : alpha) :
    (C).channel x (ppRightA S hS a b hab hp t ht0 ht1) =
      ((1 - t : NNReal) : ENNReal) * S.channel x a := by
  exact (ppm_apply_unaffected B hB aL bL (ppLeftLt S a b hab)
    (ppLeftPattern S hS a b hab hp t ht0 ht1) x
    (ppRightANeSurvivor S hS a b hab hp t ht0 ht1)).trans
    ((congrArg ((B).channel x) (ppRightARetained S hS a b hab hp t ht0 ht1)).trans
      (ppBAR S hS a b hab t ht0 ht1 x))
private theorem ppCRightB (x : alpha) :
    (C).channel x (ppRightB S hS a b hab hp t ht0 ht1) =
      ((1 - t : NNReal) : ENNReal) * S.channel x b := by
  exact (ppm_apply_unaffected B hB aL bL (ppLeftLt S a b hab)
    (ppLeftPattern S hS a b hab hp t ht0 ht1) x
    (ppRightBNeSurvivor S hS a b hab hp t ht0 ht1)).trans
    ((congrArg ((B).channel x) (ppRightBRetained S hS a b hab hp t ht0 ht1)).trans
      (ppBBR S hS a b hab t ht0 ht1 x))

private theorem ppRightLt : ppRightA S hS a b hab hp t ht0 ht1 <
    ppRightB S hS a b hab hp t ht0 ht1 := by
  change a.val + 1 < b.val + 1
  omega
private theorem ppRightPattern (x : alpha) :
    (C).channel x (ppRightA S hS a b hab hp t ht0 ht1) ≠ 0 ↔
      (C).channel x (ppRightB S hS a b hab hp t ht0 ht1) ≠ 0 := by
  rw [ppCRightA S hS a b hab hp t ht0 ht1 x, ppCRightB S hS a b hab hp t ht0 ht1 x]
  have ht : ((1 - t : NNReal) : ENNReal) ≠ 0 :=
    ENNReal.coe_ne_zero.mpr (ne_of_gt (tsub_pos_of_lt ht1))
  exact ⟨fun h => mul_ne_zero ht ((hp x).mp (right_ne_zero_of_mul h)),
    fun h => mul_ne_zero ht ((hp x).mpr (right_ne_zero_of_mul h))⟩

private def ppReplacement : Cascade S (ppm C hC
    (ppRightA S hS a b hab hp t ht0 ht1) (ppRightB S hS a b hab hp t ht0 ht1)
    (ppRightLt S hS a b hab hp t ht0 ht1) (ppRightPattern S hS a b hab hp t ht0 ht1)) :=
  Cascade.ofPath <| (((OperationPath.nil.snoc (.pps S hS a t ht0 ht1)).snoc
    (.pps A hA b' t ht0 ht1)).snoc
      (.ppm B hB aL bL (ppLeftLt S a b hab) (ppLeftPattern S hS a b hab hp t ht0 ht1))).snoc
        (.ppm C hC (ppRightA S hS a b hab hp t ht0 ht1)
          (ppRightB S hS a b hab hp t ht0 ht1) (ppRightLt S hS a b hab hp t ht0 ht1)
          (ppRightPattern S hS a b hab hp t ht0 ht1))

example : (ppReplacement S hS a b hab hp t ht0 ht1).path.tags = [.pps, .pps, .ppm, .ppm] := rfl

local notation "rA" => ppRightA S hS a b hab hp t ht0 ht1
local notation "rB" => ppRightB S hS a b hab hp t ht0 ht1
local notation "hr" => ppRightLt S hS a b hab hp t ht0 ht1
local notation "hpr" => ppRightPattern S hS a b hab hp t ht0 ht1
local notation "D" => ppm C hC rA rB hr hpr
local notation "M" => ppm S hS a b hab hp
local notation "hM" => ppm_isSingular S hS a b hab hp
local notation "s" => activeMergeSurvivor S a b hab
local notation "O" => pps M hM s t ht0 ht1

private def ppEndpointEquiv : Fin (D).outputCard ≃ Fin (O).outputCard := finCongr (by
  change (S.outputCard + 1 + 1 - 1) - 1 = S.outputCard - 1 + 1
  have := S.outputCard_pos
  omega)
local notation "E" => ppEndpointEquiv S hS a b hab hp t ht0 ht1

private theorem ppEVal (j : Fin (D).outputCard) : (E j).val = j.val := rfl
private theorem ppESymmVal (j : Fin (O).outputCard) : ((E).symm j).val = j.val := rfl

private theorem ppLeftNeFinalSurvivor : (E).symm (splitLeft s) ≠
    activeMergeSurvivor C rA rB hr := by
  intro h
  have hj : ((E).symm (splitLeft s)).val = a.val :=
    (ppESymmVal S hS a b hab hp t ht0 ht1 (splitLeft s)).trans (activeMergeSurvivor_val S a b hab)
  have hf : (activeMergeSurvivor C rA rB hr).val = a.val + 1 :=
    activeMergeSurvivor_val C rA rB hr
  have hv : a.val = a.val + 1 := hj.symm.trans ((congrArg Fin.val h).trans hf)
  omega

private theorem ppLeftRetained : activeMergeRetained C rB ((E).symm (splitLeft s)) =
    activeMergeSurvivor B aL bL (ppLeftLt S a b hab) := by
  apply Fin.ext
  have hj : ((E).symm (splitLeft s)).val = a.val :=
    (ppESymmVal S hS a b hab hp t ht0 ht1 (splitLeft s)).trans (activeMergeSurvivor_val S a b hab)
  have hf : (activeMergeSurvivor B aL bL (ppLeftLt S a b hab)).val = a.val :=
    (activeMergeSurvivor_val B aL bL (ppLeftLt S a b hab)).trans (ppALVal S a b hab)
  have hlt : ((E).symm (splitLeft s)).val < (rB).val := by
    change ((E).symm (splitLeft s)).val < b.val + 1
    exact hj ▸ Nat.lt_succ_of_lt hab
  exact (ppRetainedVal C rB ((E).symm (splitLeft s))).trans
    ((if_pos hlt).trans (hj.trans hf.symm))

private theorem ppRightFinalSurvivor : (E).symm (splitRight s) =
    activeMergeSurvivor C rA rB hr := by
  apply Fin.ext
  exact ((ppESymmVal S hS a b hab hp t ht0 ht1 (splitRight s)).trans
    (congrArg (· + 1) (activeMergeSurvivor_val S a b hab))).trans
      (activeMergeSurvivor_val C rA rB hr).symm

private theorem ppKeepVal (k : Fin (M).outputCard) :
    ((E).symm (splitKeep s k)).val = ppLiftLabel a.val k.val :=
  (ppESymmVal S hS a b hab hp t ht0 ht1 (splitKeep s k)).trans
    ((ppSplitKeepVal s k).trans
      (congrArg (fun q => ppLiftLabel q k.val) (activeMergeSurvivor_val S a b hab)))

private theorem ppKeepFirstRetainedVal (k : Fin (M).outputCard) :
    (activeMergeRetained C rB ((E).symm (splitKeep s k))).val =
      ppRetainLabel (b.val + 1) (ppLiftLabel a.val k.val) :=
  (ppRetainedVal C rB ((E).symm (splitKeep s k))).trans
    (congrArg (ppRetainLabel (b.val + 1)) (ppKeepVal S hS a b hab hp t ht0 ht1 k))

private theorem ppDLeft (x : alpha) : (D).channel x ((E).symm (splitLeft s)) =
    (t : ENNReal) * (S.channel x a + S.channel x b) := by
  calc
    _ = (C).channel x (activeMergeRetained C rB ((E).symm (splitLeft s))) :=
      ppm_apply_unaffected C hC rA rB hr hpr x
        (ppLeftNeFinalSurvivor S hS a b hab hp t ht0 ht1)
    _ = (C).channel x (activeMergeSurvivor B aL bL (ppLeftLt S a b hab)) :=
      congrArg ((C).channel x) (ppLeftRetained S hS a b hab hp t ht0 ht1)
    _ = (B).channel x aL + (B).channel x bL := ppm_apply_survivor _ _ _ _ _ _ x
    _ = (t : ENNReal) * S.channel x a + (t : ENNReal) * S.channel x b :=
      congrArg₂ (· + ·) (ppBAL S hS a b hab t ht0 ht1 x) (ppBBL S hS a b hab t ht0 ht1 x)
    _ = _ := (mul_add _ _ _).symm

private theorem ppDRight (x : alpha) : (D).channel x ((E).symm (splitRight s)) =
    ((1 - t : NNReal) : ENNReal) * (S.channel x a + S.channel x b) := by
  calc
    _ = (D).channel x (activeMergeSurvivor C rA rB hr) :=
      congrArg ((D).channel x) (ppRightFinalSurvivor S hS a b hab hp t ht0 ht1)
    _ = (C).channel x rA + (C).channel x rB := ppm_apply_survivor _ _ _ _ _ _ x
    _ = ((1 - t : NNReal) : ENNReal) * S.channel x a +
          ((1 - t : NNReal) : ENNReal) * S.channel x b :=
      congrArg₂ (· + ·) (ppCRightA S hS a b hab hp t ht0 ht1 x)
        (ppCRightB S hS a b hab hp t ht0 ht1 x)
    _ = _ := (mul_add _ _ _).symm

private theorem ppKeepNeFinalSurvivor (k : Fin (M).outputCard) :
    (E).symm (splitKeep s k) ≠ activeMergeSurvivor C rA rB hr := by
  intro h
  exact splitKeep_ne_right s k ((E).symm.injective
    (h.trans (ppRightFinalSurvivor S hS a b hab hp t ht0 ht1).symm))

private theorem ppKeepNeFirstSurvivor (k : Fin (M).outputCard) (hk : k ≠ s) :
    activeMergeRetained C rB ((E).symm (splitKeep s k)) ≠
      activeMergeSurvivor B aL bL (ppLeftLt S a b hab) := by
  have hkval : k.val ≠ a.val := by
    intro h
    apply hk
    apply Fin.ext
    exact h.trans (activeMergeSurvivor_val S a b hab).symm
  intro h
  exact ppRetainLiftNe a.val b.val k.val hab hkval
    ((ppKeepFirstRetainedVal S hS a b hab hp t ht0 ht1 k).symm.trans
      ((congrArg Fin.val h).trans
        ((activeMergeSurvivor_val B aL bL (ppLeftLt S a b hab)).trans (ppALVal S a b hab))))

private theorem ppKeepRetained (k : Fin (M).outputCard) :
    activeMergeRetained B bL (activeMergeRetained C rB ((E).symm (splitKeep s k))) =
      splitKeep b' (splitKeep a (activeMergeRetained S b k)) := by
  apply Fin.ext
  have hl : (activeMergeRetained B bL (activeMergeRetained C rB
      ((E).symm (splitKeep s k)))).val =
        ppRetainLabel (b.val + 1) (ppRetainLabel (b.val + 1) (ppLiftLabel a.val k.val)) :=
    (ppRetainedVal B bL (activeMergeRetained C rB ((E).symm (splitKeep s k)))).trans
      ((congrArg (fun q => ppRetainLabel q
          (activeMergeRetained C rB ((E).symm (splitKeep s k))).val)
        (ppBLVal S a b hab)).trans
          (congrArg (ppRetainLabel (b.val + 1))
            (ppKeepFirstRetainedVal S hS a b hab hp t ht0 ht1 k)))
  have hr' : (splitKeep b' (splitKeep a (activeMergeRetained S b k))).val =
      ppLiftLabel (b.val + 1) (ppLiftLabel a.val (ppRetainLabel b.val k.val)) :=
    (ppSplitKeepVal b' (splitKeep a (activeMergeRetained S b k))).trans
      ((congrArg (fun q => ppLiftLabel q (splitKeep a (activeMergeRetained S b k)).val)
        (ppBVal S a b hab)).trans
          (congrArg (ppLiftLabel (b.val + 1))
            ((ppSplitKeepVal a (activeMergeRetained S b k)).trans
              (congrArg (ppLiftLabel a.val) (ppRetainedVal S b k)))))
  exact hl.trans ((ppRetainLift a.val b.val k.val hab).trans hr'.symm)

private theorem ppOldKeepNeA (k : Fin (M).outputCard) (hk : k ≠ s) :
    activeMergeRetained S b k ≠ a := by
  have hkval : k.val ≠ a.val := by
    intro h
    apply hk
    apply Fin.ext
    exact h.trans (activeMergeSurvivor_val S a b hab).symm
  intro h
  have hv := congrArg Fin.val h
  have hret := ppRetainedVal S b k
  have ha : a.val < b.val := hab
  split_ifs at hret <;> omega

private theorem ppOldKeepNeB (k : Fin (M).outputCard) :
    activeMergeRetained S b k ≠ b := by
  intro h
  have hv := congrArg Fin.val h
  have hret := ppRetainedVal S b k
  split_ifs at hret <;> omega

private theorem ppDKeep (k : Fin (M).outputCard) (hk : k ≠ s) (x : alpha) :
    (D).channel x ((E).symm (splitKeep s k)) = S.channel x (activeMergeRetained S b k) := by
  calc
    _ = (C).channel x (activeMergeRetained C rB ((E).symm (splitKeep s k))) :=
      ppm_apply_unaffected C hC rA rB hr hpr x (ppKeepNeFinalSurvivor S hS a b hab hp t ht0 ht1 k)
    _ = (B).channel x (activeMergeRetained B bL
          (activeMergeRetained C rB ((E).symm (splitKeep s k)))) :=
      ppm_apply_unaffected B hB aL bL (ppLeftLt S a b hab)
        (ppLeftPattern S hS a b hab hp t ht0 ht1) x
        (ppKeepNeFirstSurvivor S hS a b hab hp t ht0 ht1 k hk)
    _ = (B).channel x (splitKeep b' (splitKeep a (activeMergeRetained S b k))) :=
      congrArg ((B).channel x) (ppKeepRetained S hS a b hab hp t ht0 ht1 k)
    _ = (A).channel x (splitKeep a (activeMergeRetained S b k)) :=
      pps_keep A hA b' t ht0 ht1 x
        ((splitKeep_injective a).ne (ppOldKeepNeB S hS a b hab hp k))
    _ = _ := pps_keep S hS a t ht0 ht1 x (ppOldKeepNeA S hS a b hab hp k hk)

private theorem ppEndpointCoordinates (x : alpha) (j : Fin (O).outputCard) :
    (D).channel x ((E).symm j) = (O).channel x j := by
  rcases split_cases s j with rfl | ⟨k, rfl⟩
  · exact (ppDRight S hS a b hab hp t ht0 ht1 x).trans
      ((congrArg (fun q => ((1 - t : NNReal) : ENNReal) * q)
        (ppm_apply_survivor S hS a b hab hp x)).symm.trans
          (pps_right M hM s t ht0 ht1 x).symm)
  · by_cases hk : k = s
    · subst k
      rw [splitKeep_self]
      exact (ppDLeft S hS a b hab hp t ht0 ht1 x).trans
        ((congrArg (fun q => (t : ENNReal) * q)
          (ppm_apply_survivor S hS a b hab hp x)).symm.trans
            (pps_left M hM s t ht0 ht1 x).symm)
    · exact (ppDKeep S hS a b hab hp t ht0 ht1 k hk x).trans
        ((ppm_apply_unaffected S hS a b hab hp x hk).symm.trans
          (pps_keep M hM s t ht0 ht1 x hk).symm)

private def ppEndpointOutputEquiv : OutputEquiv D O :=
  OutputEquiv.ofCoordinates E (by
    intro x j
    simpa only [Equiv.symm_apply_apply] using
      (ppEndpointCoordinates S hS a b hab hp t ht0 ht1 x (E j)).symm)

private def ppOverlapCascade : Cascade S O where
  endpoint := D
  path := (ppReplacement S hS a b hab hp t ht0 ht1).path
  outputEquiv := ppEndpointOutputEquiv S hS a b hab hp t ht0 ht1

example : (ppOverlapCascade S hS a b hab hp t ht0 ht1).path.tags = [.pps, .pps, .ppm, .ppm] := rfl

example (x : alpha) : ((ppOverlapCascade S hS a b hab hp t ht0 ht1).endpoint.channel x).map
    (ppOverlapCascade S hS a b hab hp t ht0 ht1).outputEquiv.equiv = (O).channel x :=
  (ppOverlapCascade S hS a b hab hp t ht0 ht1).outputEquiv.map_eq x

end Overlap

-- R08: nonadjacent pair 0/3, unequal positive masses, strict nonsymmetric ratio,
-- and two distinct intervening outputs. Both descendants and every other label
-- are checked against an explicit row, not just a cardinality equality.
private def ppR08Weights : Fin 4 → NNReal := ![1 / 10, 2 / 10, 3 / 10, 4 / 10]
private theorem ppR08WeightsSum : ∑ j, ppR08Weights j = 1 := by
  norm_num [ppR08Weights, Fin.sum_univ_succ]
private theorem ppR08WeightsNe (j : Fin 4) : (ppR08Weights j : ENNReal) ≠ 0 := by
  rw [ENNReal.coe_ne_zero]
  fin_cases j <;> norm_num [ppR08Weights]
private abbrev ppR08State : ActiveFiniteChannel Unit where
  outputCard := 4
  outputCard_pos := by decide
  channel := fun _ => PMF.ofFintype (fun j => (ppR08Weights j : ENNReal))
    (by exact_mod_cast ppR08WeightsSum)
  output_active j := ⟨(), ppR08WeightsNe j⟩
private theorem ppR08Singular : IsSingularChannel ppR08State.channel := by
  intro x z j _ _
  rfl
private theorem ppR08Pattern (x : Unit) :
    ppR08State.channel x 0 ≠ 0 ↔ ppR08State.channel x 3 ≠ 0 :=
  ⟨fun _ => ppR08WeightsNe 3, fun _ => ppR08WeightsNe 0⟩
private abbrev ppR08Merge := ppm ppR08State ppR08Singular 0 3 (by decide) ppR08Pattern
private abbrev ppR08Survivor := activeMergeSurvivor ppR08State 0 3 (by decide)
private theorem ppR08SurvivorEq : ppR08Survivor = (0 : Fin 3) := by
  apply Fin.ext
  exact activeMergeSurvivor_val ppR08State 0 3 (by decide)

private theorem ppR08MergeMass (j : Fin 3) :
    ppR08Merge.channel () j = ((![1 / 2, 1 / 5, 3 / 10] j : NNReal) : ENNReal) := by
  fin_cases j
  · calc
      _ = ppR08Merge.channel () ppR08Survivor :=
        congrArg (ppR08Merge.channel ()) ppR08SurvivorEq.symm
      _ = ppR08State.channel () 0 + ppR08State.channel () 3 :=
        ppm_apply_survivor ppR08State ppR08Singular 0 3 (by decide) ppR08Pattern ()
      _ = _ := by
        change (ppR08Weights 0 : ENNReal) + (ppR08Weights 3 : ENNReal) =
          ((1 / 2 : NNReal) : ENNReal)
        rw [← ENNReal.coe_add]
        apply congrArg (fun r : NNReal => (r : ENNReal))
        norm_num [ppR08Weights, Matrix.cons_val_three]
  · have hret : activeMergeRetained ppR08State 3 (1 : Fin 3) = (1 : Fin 4) := by
      apply Fin.ext
      exact (ppRetainedVal ppR08State 3 (1 : Fin 3)).trans (by decide)
    have hmass : ppR08State.channel () (1 : Fin 4) = ((1 / 5 : NNReal) : ENNReal) := by
      change ((2 / 10 : NNReal) : ENNReal) = ((1 / 5 : NNReal) : ENNReal)
      apply congrArg (fun r : NNReal => (r : ENNReal))
      norm_num
    exact (ppm_apply_unaffected ppR08State ppR08Singular 0 3 (by decide) ppR08Pattern ()
      (show (1 : Fin 3) ≠ ppR08Survivor by rw [ppR08SurvivorEq]; decide)).trans
        ((congrArg (ppR08State.channel ()) hret).trans hmass)
  · have hret : activeMergeRetained ppR08State 3 (2 : Fin 3) = (2 : Fin 4) := by
      apply Fin.ext
      exact (ppRetainedVal ppR08State 3 (2 : Fin 3)).trans (by decide)
    exact (ppm_apply_unaffected ppR08State ppR08Singular 0 3 (by decide) ppR08Pattern ()
      (show (2 : Fin 3) ≠ ppR08Survivor by rw [ppR08SurvivorEq]; decide)).trans
        (congrArg (ppR08State.channel ()) hret)

private abbrev ppR08Target := pps ppR08Merge
  (ppm_isSingular ppR08State ppR08Singular 0 3 (by decide) ppR08Pattern)
  ppR08Survivor (1 / 3) (by norm_num) (by norm_num)
private def ppR08Expected : Fin 4 → NNReal := ![1 / 6, 1 / 3, 1 / 5, 3 / 10]

private theorem ppR08TargetMass (j : Fin 4) :
    ppR08Target.channel () j = (ppR08Expected j : ENNReal) := by
  have hchannel : ppR08Target.channel = ppsRaw (n := 3) ppR08Merge.channel (0 : Fin 3)
      (1 / 3) (le_of_lt (by norm_num : (1 / 3 : NNReal) < 1)) :=
    congrArg (fun l : Fin 3 => ppsRaw (n := 3) ppR08Merge.channel l (1 / 3)
      (le_of_lt (by norm_num : (1 / 3 : NNReal) < 1))) ppR08SurvivorEq
  rw [hchannel]
  fin_cases j
  · change ppsRaw (n := 3) ppR08Merge.channel (0 : Fin 3) (1 / 3) _ () (splitLeft 0) = _
    refine (ppsRaw_left (n := 3) ppR08Merge.channel (0 : Fin 3) (1 / 3) _ ()).trans ?_
    refine (congrArg (fun q : ENNReal => ((1 / 3 : NNReal) : ENNReal) * q)
      (ppR08MergeMass 0)).trans ?_
    change ((1 / 3 : NNReal) : ENNReal) * ((1 / 2 : NNReal) : ENNReal) =
      ((1 / 6 : NNReal) : ENNReal)
    rw [← ENNReal.coe_mul]
    apply congrArg (fun r : NNReal => (r : ENNReal))
    norm_num
  · change ppsRaw (n := 3) ppR08Merge.channel (0 : Fin 3) (1 / 3) _ () (splitRight 0) = _
    refine (ppsRaw_right (n := 3) ppR08Merge.channel (0 : Fin 3) (1 / 3) _ ()).trans ?_
    refine (congrArg (fun q : ENNReal => ((1 - (1 / 3 : NNReal) : NNReal) : ENNReal) * q)
      (ppR08MergeMass 0)).trans ?_
    change ((1 - (1 / 3 : NNReal) : NNReal) : ENNReal) * ((1 / 2 : NNReal) : ENNReal) =
      ((1 / 3 : NNReal) : ENNReal)
    rw [← ENNReal.coe_mul]
    apply congrArg (fun r : NNReal => (r : ENNReal))
    apply NNReal.coe_injective
    norm_num [NNReal.coe_sub_def]
  · change ppsRaw (n := 3) ppR08Merge.channel (0 : Fin 3) (1 / 3) _ () (splitKeep 0 (1 : Fin 3)) = _
    exact (ppsRaw_keep (n := 3) ppR08Merge.channel (0 : Fin 3) (1 / 3) _ ()
      (show (1 : Fin 3) ≠ 0 by decide)).trans (ppR08MergeMass 1)
  · change ppsRaw (n := 3) ppR08Merge.channel (0 : Fin 3) (1 / 3) _ () (splitKeep 0 (2 : Fin 3)) = _
    exact (ppsRaw_keep (n := 3) ppR08Merge.channel (0 : Fin 3) (1 / 3) _ ()
      (show (2 : Fin 3) ≠ 0 by decide)).trans (ppR08MergeMass 2)

private abbrev ppR08Witness :=
  ppOverlapCascade ppR08State ppR08Singular 0 3 (by decide) ppR08Pattern
    (1 / 3) (by norm_num) (by norm_num)

example : ppR08Witness.path.tags = [.pps, .pps, .ppm, .ppm] ∧
    ppR08Witness.path.length = 4 := ⟨rfl, rfl⟩

example (j : Fin 4) : ppR08Witness.endpoint.channel ()
    (ppR08Witness.outputEquiv.equiv.symm j) = (ppR08Expected j : ENNReal) :=
  (ppR08Witness.outputEquiv.apply_symm () j).trans (ppR08TargetMass j)

example : (ppR08Witness.endpoint.channel ()).map ppR08Witness.outputEquiv.equiv =
    ppR08Target.channel () ∧
    (ppR08Target.channel ()).map ppR08Witness.outputEquiv.equiv.symm =
      ppR08Witness.endpoint.channel () :=
  ⟨ppR08Witness.outputEquiv.map_eq (), ppR08Witness.outputEquiv.symm.map_eq ()⟩

section PVOverlap
variable (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
  (a b : Fin S.outputCard) (hab : a < b)
  (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0)
  (mask : alpha → Bool)
  (hmaskTrue : ∃ x, (ppm S hS a b hab hp).channel x (activeMergeSurvivor S a b hab) ≠ 0 ∧
    mask x = true)
  (hmaskFalse : ∃ x, (ppm S hS a b hab hp).channel x (activeMergeSurvivor S a b hab) ≠ 0 ∧
    mask x = false)
include hab

private theorem pvSourceLeftWitness (value : Bool)
    (h : ∃ x, (ppm S hS a b hab hp).channel x (activeMergeSurvivor S a b hab) ≠ 0 ∧
      mask x = value) : ∃ x, S.channel x a ≠ 0 ∧ mask x = value := by
  obtain ⟨x, hx, hm⟩ := h
  have hsum : S.channel x a + S.channel x b ≠ 0 :=
    fun hz => hx ((ppm_apply_survivor S hS a b hab hp x).trans hz)
  have ha : S.channel x a ≠ 0 := by
    intro ha
    have hb : S.channel x b = 0 := by
      by_contra hb
      exact (hp x).mpr hb ha
    exact hsum (by simp [ha, hb])
  exact ⟨x, ha, hm⟩

private theorem pvSourceRightWitness (value : Bool)
    (h : ∃ x, (ppm S hS a b hab hp).channel x (activeMergeSurvivor S a b hab) ≠ 0 ∧
      mask x = value) : ∃ x, S.channel x b ≠ 0 ∧ mask x = value := by
  obtain ⟨x, hx, hm⟩ := pvSourceLeftWitness S hS a b hab hp mask value h
  exact ⟨x, (hp x).mp hx, hm⟩

local notation "haT" => pvSourceLeftWitness S hS a b hab hp mask true hmaskTrue
local notation "haF" => pvSourceLeftWitness S hS a b hab hp mask false hmaskFalse
local notation "A" => vps S hS a mask haT haF
local notation "hA" => vps_isSingular S hS a mask haT haF
local notation "b'" => splitKeep a b

private theorem pvSecondWitness (value : Bool)
    (h : ∃ x, (ppm S hS a b hab hp).channel x (activeMergeSurvivor S a b hab) ≠ 0 ∧
      mask x = value) : ∃ x, (A).channel x b' ≠ 0 ∧ mask x = value := by
  obtain ⟨x, hx, hm⟩ := pvSourceRightWitness S hS a b hab hp mask value h
  exact ⟨x, fun hz => hx ((vps_keep S hS a mask haT haF x (ne_of_gt hab)).symm.trans hz), hm⟩

local notation "hbT" => pvSecondWitness S hS a b hab hp mask hmaskTrue hmaskFalse true hmaskTrue
local notation "hbF" => pvSecondWitness S hS a b hab hp mask hmaskTrue hmaskFalse false hmaskFalse
local notation "B" => vps A hA b' mask hbT hbF
local notation "hB" => vps_isSingular A hA b' mask hbT hbF
local notation "aL" => splitKeep b' (splitLeft a)
local notation "aR" => splitKeep b' (splitRight a)
local notation "bL" => splitLeft b'
local notation "bR" => splitRight b'

private theorem pvBAL (x : alpha) : (B).channel x aL =
    if mask x then S.channel x a else 0 :=
  (vps_keep A hA b' mask hbT hbF x (ppALNeB S a b hab)).trans
    (vps_left S hS a mask haT haF x)
private theorem pvBAR (x : alpha) : (B).channel x aR =
    if mask x then 0 else S.channel x a :=
  (vps_keep A hA b' mask hbT hbF x (ppARNeB S a b hab)).trans
    (vps_right S hS a mask haT haF x)
private theorem pvBBL (x : alpha) : (B).channel x bL =
    if mask x then S.channel x b else 0 :=
  (vps_left A hA b' mask hbT hbF x).trans
    (congrArg (fun p => if mask x then p else 0)
      (vps_keep S hS a mask haT haF x (ne_of_gt hab)))
private theorem pvBBR (x : alpha) : (B).channel x bR =
    if mask x then 0 else S.channel x b :=
  (vps_right A hA b' mask hbT hbF x).trans
    (congrArg (fun p => if mask x then 0 else p)
      (vps_keep S hS a mask haT haF x (ne_of_gt hab)))

private theorem pvLeftPattern (x : alpha) : (B).channel x aL ≠ 0 ↔ (B).channel x bL ≠ 0 := by
  rw [pvBAL S hS a b hab hp mask hmaskTrue hmaskFalse x,
    pvBBL S hS a b hab hp mask hmaskTrue hmaskFalse x]
  by_cases hx : mask x = true
  · simpa only [if_pos hx] using hp x
  · simp only [if_neg hx]

local notation "C" => ppm B hB aL bL (ppLeftLt S a b hab)
  (pvLeftPattern S hS a b hab hp mask hmaskTrue hmaskFalse)
local notation "hC" => ppm_isSingular B hB aL bL (ppLeftLt S a b hab)
  (pvLeftPattern S hS a b hab hp mask hmaskTrue hmaskFalse)

-- After deleting bL, these are exactly the retained right descendants.
private def pvRightA : Fin (C).outputCard := ⟨a.val + 1, by
  change a.val + 1 < (S.outputCard + 1 + 1) - 1
  have hb := b.isLt
  have ha : a.val < b.val := hab
  omega⟩
private def pvRightB : Fin (C).outputCard := ⟨b.val + 1, by
  change b.val + 1 < (S.outputCard + 1 + 1) - 1
  have hb := b.isLt
  omega⟩

private theorem pvRightARetained : activeMergeRetained B bL
    (pvRightA S hS a b hab hp mask hmaskTrue hmaskFalse) = aR := by
  apply Fin.ext
  have h := ppRetainedVal B bL (pvRightA S hS a b hab hp mask hmaskTrue hmaskFalse)
  have hl := ppBLVal S a b hab
  have hr := ppARVal S a b hab
  change (activeMergeRetained B bL (pvRightA S hS a b hab hp mask hmaskTrue hmaskFalse)).val =
    (if a.val + 1 < (bL).val then a.val + 1 else a.val + 1 + 1) at h
  rw [hl, if_pos (by have ha : a.val < b.val := hab; omega)] at h
  exact h.trans hr.symm
private theorem pvRightBRetained : activeMergeRetained B bL
    (pvRightB S hS a b hab hp mask hmaskTrue hmaskFalse) = bR := by
  apply Fin.ext
  have h := ppRetainedVal B bL (pvRightB S hS a b hab hp mask hmaskTrue hmaskFalse)
  have hl := ppBLVal S a b hab
  have hr := ppBRVal S a b hab
  change (activeMergeRetained B bL (pvRightB S hS a b hab hp mask hmaskTrue hmaskFalse)).val =
    (if b.val + 1 < (bL).val then b.val + 1 else b.val + 1 + 1) at h
  rw [hl, if_neg (lt_irrefl _)] at h
  exact h.trans hr.symm

private theorem pvRightANeSurvivor : pvRightA S hS a b hab hp mask hmaskTrue hmaskFalse ≠
    activeMergeSurvivor B aL bL (ppLeftLt S a b hab) := by
  intro h
  have he : a.val + 1 = a.val := (congrArg Fin.val h).trans
    ((activeMergeSurvivor_val B aL bL (ppLeftLt S a b hab)).trans (ppALVal S a b hab))
  omega
private theorem pvRightBNeSurvivor : pvRightB S hS a b hab hp mask hmaskTrue hmaskFalse ≠
    activeMergeSurvivor B aL bL (ppLeftLt S a b hab) := by
  intro h
  have he : b.val + 1 = a.val := (congrArg Fin.val h).trans
    ((activeMergeSurvivor_val B aL bL (ppLeftLt S a b hab)).trans (ppALVal S a b hab))
  have ha : a.val < b.val := hab
  omega

private theorem pvCRightA (x : alpha) :
    (C).channel x (pvRightA S hS a b hab hp mask hmaskTrue hmaskFalse) =
      (if mask x then 0 else S.channel x a) := by
  exact (ppm_apply_unaffected B hB aL bL (ppLeftLt S a b hab)
    (pvLeftPattern S hS a b hab hp mask hmaskTrue hmaskFalse) x
    (pvRightANeSurvivor S hS a b hab hp mask hmaskTrue hmaskFalse)).trans
    ((congrArg ((B).channel x) (pvRightARetained S hS a b hab hp mask hmaskTrue hmaskFalse)).trans
      (pvBAR S hS a b hab hp mask hmaskTrue hmaskFalse x))
private theorem pvCRightB (x : alpha) :
    (C).channel x (pvRightB S hS a b hab hp mask hmaskTrue hmaskFalse) =
      (if mask x then 0 else S.channel x b) := by
  exact (ppm_apply_unaffected B hB aL bL (ppLeftLt S a b hab)
    (pvLeftPattern S hS a b hab hp mask hmaskTrue hmaskFalse) x
    (pvRightBNeSurvivor S hS a b hab hp mask hmaskTrue hmaskFalse)).trans
    ((congrArg ((B).channel x) (pvRightBRetained S hS a b hab hp mask hmaskTrue hmaskFalse)).trans
      (pvBBR S hS a b hab hp mask hmaskTrue hmaskFalse x))

private theorem pvRightLt : pvRightA S hS a b hab hp mask hmaskTrue hmaskFalse <
    pvRightB S hS a b hab hp mask hmaskTrue hmaskFalse := by
  change a.val + 1 < b.val + 1
  omega
private theorem pvRightPattern (x : alpha) :
    (C).channel x (pvRightA S hS a b hab hp mask hmaskTrue hmaskFalse) ≠ 0 ↔
      (C).channel x (pvRightB S hS a b hab hp mask hmaskTrue hmaskFalse) ≠ 0 := by
  rw [pvCRightA S hS a b hab hp mask hmaskTrue hmaskFalse x,
    pvCRightB S hS a b hab hp mask hmaskTrue hmaskFalse x]
  by_cases hx : mask x = true
  · simp only [if_pos hx]
  · simpa only [if_neg hx] using hp x

private def pvReplacement : Cascade S (ppm C hC
    (pvRightA S hS a b hab hp mask hmaskTrue hmaskFalse)
    (pvRightB S hS a b hab hp mask hmaskTrue hmaskFalse)
    (pvRightLt S hS a b hab hp mask hmaskTrue hmaskFalse)
    (pvRightPattern S hS a b hab hp mask hmaskTrue hmaskFalse)) :=
  Cascade.ofPath <| (((OperationPath.nil.snoc (.vps S hS a mask haT haF)).snoc
    (.vps A hA b' mask hbT hbF)).snoc
      (.ppm B hB aL bL (ppLeftLt S a b hab)
        (pvLeftPattern S hS a b hab hp mask hmaskTrue hmaskFalse))).snoc
        (.ppm C hC (pvRightA S hS a b hab hp mask hmaskTrue hmaskFalse)
          (pvRightB S hS a b hab hp mask hmaskTrue hmaskFalse)
          (pvRightLt S hS a b hab hp mask hmaskTrue hmaskFalse)
          (pvRightPattern S hS a b hab hp mask hmaskTrue hmaskFalse))

example : (pvReplacement S hS a b hab hp mask hmaskTrue hmaskFalse).path.tags =
    [.vps, .vps, .ppm, .ppm] := rfl

local notation "rA" => pvRightA S hS a b hab hp mask hmaskTrue hmaskFalse
local notation "rB" => pvRightB S hS a b hab hp mask hmaskTrue hmaskFalse
local notation "hr" => pvRightLt S hS a b hab hp mask hmaskTrue hmaskFalse
local notation "hpr" => pvRightPattern S hS a b hab hp mask hmaskTrue hmaskFalse
local notation "D" => ppm C hC rA rB hr hpr
local notation "M" => ppm S hS a b hab hp
local notation "hM" => ppm_isSingular S hS a b hab hp
local notation "s" => activeMergeSurvivor S a b hab
local notation "O" => vps M hM s mask hmaskTrue hmaskFalse

private def pvEndpointEquiv : Fin (D).outputCard ≃ Fin (O).outputCard := finCongr (by
  change (S.outputCard + 1 + 1 - 1) - 1 = S.outputCard - 1 + 1
  have := S.outputCard_pos
  omega)
local notation "E" => pvEndpointEquiv S hS a b hab hp mask hmaskTrue hmaskFalse

private theorem pvEVal (j : Fin (D).outputCard) : (E j).val = j.val := rfl
private theorem pvESymmVal (j : Fin (O).outputCard) : ((E).symm j).val = j.val := rfl

private theorem pvLeftNeFinalSurvivor : (E).symm (splitLeft s) ≠
    activeMergeSurvivor C rA rB hr := by
  intro h
  have hj : ((E).symm (splitLeft s)).val = a.val :=
    (pvESymmVal S hS a b hab hp mask hmaskTrue hmaskFalse (splitLeft s)).trans
      (activeMergeSurvivor_val S a b hab)
  have hf : (activeMergeSurvivor C rA rB hr).val = a.val + 1 :=
    activeMergeSurvivor_val C rA rB hr
  have hv : a.val = a.val + 1 := hj.symm.trans ((congrArg Fin.val h).trans hf)
  omega

private theorem pvLeftRetained : activeMergeRetained C rB ((E).symm (splitLeft s)) =
    activeMergeSurvivor B aL bL (ppLeftLt S a b hab) := by
  apply Fin.ext
  have hj : ((E).symm (splitLeft s)).val = a.val :=
    (pvESymmVal S hS a b hab hp mask hmaskTrue hmaskFalse (splitLeft s)).trans
      (activeMergeSurvivor_val S a b hab)
  have hf : (activeMergeSurvivor B aL bL (ppLeftLt S a b hab)).val = a.val :=
    (activeMergeSurvivor_val B aL bL (ppLeftLt S a b hab)).trans (ppALVal S a b hab)
  have hlt : ((E).symm (splitLeft s)).val < (rB).val := by
    change ((E).symm (splitLeft s)).val < b.val + 1
    exact hj ▸ Nat.lt_succ_of_lt hab
  exact (ppRetainedVal C rB ((E).symm (splitLeft s))).trans
    ((if_pos hlt).trans (hj.trans hf.symm))

private theorem pvRightFinalSurvivor : (E).symm (splitRight s) =
    activeMergeSurvivor C rA rB hr := by
  apply Fin.ext
  exact ((pvESymmVal S hS a b hab hp mask hmaskTrue hmaskFalse (splitRight s)).trans
    (congrArg (· + 1) (activeMergeSurvivor_val S a b hab))).trans
      (activeMergeSurvivor_val C rA rB hr).symm

private theorem pvKeepVal (k : Fin (M).outputCard) :
    ((E).symm (splitKeep s k)).val = ppLiftLabel a.val k.val :=
  (pvESymmVal S hS a b hab hp mask hmaskTrue hmaskFalse (splitKeep s k)).trans
    ((ppSplitKeepVal s k).trans
      (congrArg (fun q => ppLiftLabel q k.val) (activeMergeSurvivor_val S a b hab)))

private theorem pvKeepFirstRetainedVal (k : Fin (M).outputCard) :
    (activeMergeRetained C rB ((E).symm (splitKeep s k))).val =
      ppRetainLabel (b.val + 1) (ppLiftLabel a.val k.val) :=
  (ppRetainedVal C rB ((E).symm (splitKeep s k))).trans
    (congrArg (ppRetainLabel (b.val + 1)) (pvKeepVal S hS a b hab hp mask hmaskTrue hmaskFalse k))

private theorem pvDLeft (x : alpha) : (D).channel x ((E).symm (splitLeft s)) =
    (if mask x then S.channel x a + S.channel x b else 0) := by
  calc
    _ = (C).channel x (activeMergeRetained C rB ((E).symm (splitLeft s))) :=
      ppm_apply_unaffected C hC rA rB hr hpr x
        (pvLeftNeFinalSurvivor S hS a b hab hp mask hmaskTrue hmaskFalse)
    _ = (C).channel x (activeMergeSurvivor B aL bL (ppLeftLt S a b hab)) :=
      congrArg ((C).channel x) (pvLeftRetained S hS a b hab hp mask hmaskTrue hmaskFalse)
    _ = (B).channel x aL + (B).channel x bL := ppm_apply_survivor _ _ _ _ _ _ x
    _ = (if mask x then S.channel x a else 0) + (if mask x then S.channel x b else 0) :=
      congrArg₂ (· + ·) (pvBAL S hS a b hab hp mask hmaskTrue hmaskFalse x)
        (pvBBL S hS a b hab hp mask hmaskTrue hmaskFalse x)
    _ = _ := by by_cases hx : mask x = true <;> simp [hx]

private theorem pvDRight (x : alpha) : (D).channel x ((E).symm (splitRight s)) =
    (if mask x then 0 else S.channel x a + S.channel x b) := by
  calc
    _ = (D).channel x (activeMergeSurvivor C rA rB hr) :=
      congrArg ((D).channel x) (pvRightFinalSurvivor S hS a b hab hp mask hmaskTrue hmaskFalse)
    _ = (C).channel x rA + (C).channel x rB := ppm_apply_survivor _ _ _ _ _ _ x
    _ = (if mask x then 0 else S.channel x a) +
          (if mask x then 0 else S.channel x b) :=
      congrArg₂ (· + ·) (pvCRightA S hS a b hab hp mask hmaskTrue hmaskFalse x)
        (pvCRightB S hS a b hab hp mask hmaskTrue hmaskFalse x)
    _ = _ := by by_cases hx : mask x = true <;> simp [hx]

private theorem pvKeepNeFinalSurvivor (k : Fin (M).outputCard) :
    (E).symm (splitKeep s k) ≠ activeMergeSurvivor C rA rB hr := by
  intro h
  exact splitKeep_ne_right s k ((E).symm.injective
    (h.trans (pvRightFinalSurvivor S hS a b hab hp mask hmaskTrue hmaskFalse).symm))

private theorem pvKeepNeFirstSurvivor (k : Fin (M).outputCard) (hk : k ≠ s) :
    activeMergeRetained C rB ((E).symm (splitKeep s k)) ≠
      activeMergeSurvivor B aL bL (ppLeftLt S a b hab) := by
  have hkval : k.val ≠ a.val := by
    intro h
    apply hk
    apply Fin.ext
    exact h.trans (activeMergeSurvivor_val S a b hab).symm
  intro h
  exact ppRetainLiftNe a.val b.val k.val hab hkval
    ((pvKeepFirstRetainedVal S hS a b hab hp mask hmaskTrue hmaskFalse k).symm.trans
      ((congrArg Fin.val h).trans
        ((activeMergeSurvivor_val B aL bL (ppLeftLt S a b hab)).trans (ppALVal S a b hab))))

private theorem pvKeepRetained (k : Fin (M).outputCard) :
    activeMergeRetained B bL (activeMergeRetained C rB ((E).symm (splitKeep s k))) =
      splitKeep b' (splitKeep a (activeMergeRetained S b k)) := by
  apply Fin.ext
  have hl : (activeMergeRetained B bL (activeMergeRetained C rB
      ((E).symm (splitKeep s k)))).val =
        ppRetainLabel (b.val + 1) (ppRetainLabel (b.val + 1) (ppLiftLabel a.val k.val)) :=
    (ppRetainedVal B bL (activeMergeRetained C rB ((E).symm (splitKeep s k)))).trans
      ((congrArg (fun q => ppRetainLabel q
          (activeMergeRetained C rB ((E).symm (splitKeep s k))).val)
        (ppBLVal S a b hab)).trans
          (congrArg (ppRetainLabel (b.val + 1))
            (pvKeepFirstRetainedVal S hS a b hab hp mask hmaskTrue hmaskFalse k)))
  have hr' : (splitKeep b' (splitKeep a (activeMergeRetained S b k))).val =
      ppLiftLabel (b.val + 1) (ppLiftLabel a.val (ppRetainLabel b.val k.val)) :=
    (ppSplitKeepVal b' (splitKeep a (activeMergeRetained S b k))).trans
      ((congrArg (fun q => ppLiftLabel q (splitKeep a (activeMergeRetained S b k)).val)
        (ppBVal S a b hab)).trans
          (congrArg (ppLiftLabel (b.val + 1))
            ((ppSplitKeepVal a (activeMergeRetained S b k)).trans
              (congrArg (ppLiftLabel a.val) (ppRetainedVal S b k)))))
  exact hl.trans ((ppRetainLift a.val b.val k.val hab).trans hr'.symm)

private theorem pvDKeep (k : Fin (M).outputCard) (hk : k ≠ s) (x : alpha) :
    (D).channel x ((E).symm (splitKeep s k)) = S.channel x (activeMergeRetained S b k) := by
  calc
    _ = (C).channel x (activeMergeRetained C rB ((E).symm (splitKeep s k))) :=
      ppm_apply_unaffected C hC rA rB hr hpr x
        (pvKeepNeFinalSurvivor S hS a b hab hp mask hmaskTrue hmaskFalse k)
    _ = (B).channel x (activeMergeRetained B bL
          (activeMergeRetained C rB ((E).symm (splitKeep s k)))) :=
      ppm_apply_unaffected B hB aL bL (ppLeftLt S a b hab)
        (pvLeftPattern S hS a b hab hp mask hmaskTrue hmaskFalse) x
        (pvKeepNeFirstSurvivor S hS a b hab hp mask hmaskTrue hmaskFalse k hk)
    _ = (B).channel x (splitKeep b' (splitKeep a (activeMergeRetained S b k))) :=
      congrArg ((B).channel x) (pvKeepRetained S hS a b hab hp mask hmaskTrue hmaskFalse k)
    _ = (A).channel x (splitKeep a (activeMergeRetained S b k)) :=
      vps_keep A hA b' mask hbT hbF x
        ((splitKeep_injective a).ne (ppOldKeepNeB S hS a b hab hp k))
    _ = _ := vps_keep S hS a mask haT haF x (ppOldKeepNeA S hS a b hab hp k hk)

private theorem pvEndpointCoordinates (x : alpha) (j : Fin (O).outputCard) :
    (D).channel x ((E).symm j) = (O).channel x j := by
  rcases split_cases s j with rfl | ⟨k, rfl⟩
  · exact (pvDRight S hS a b hab hp mask hmaskTrue hmaskFalse x).trans
      ((congrArg (fun q => (if mask x then 0 else q))
        (ppm_apply_survivor S hS a b hab hp x)).symm.trans
          (vps_right M hM s mask hmaskTrue hmaskFalse x).symm)
  · by_cases hk : k = s
    · subst k
      rw [splitKeep_self]
      exact (pvDLeft S hS a b hab hp mask hmaskTrue hmaskFalse x).trans
        ((congrArg (fun q => (if mask x then q else 0))
          (ppm_apply_survivor S hS a b hab hp x)).symm.trans
            (vps_left M hM s mask hmaskTrue hmaskFalse x).symm)
    · exact (pvDKeep S hS a b hab hp mask hmaskTrue hmaskFalse k hk x).trans
        ((ppm_apply_unaffected S hS a b hab hp x hk).symm.trans
          (vps_keep M hM s mask hmaskTrue hmaskFalse x hk).symm)

private def pvEndpointOutputEquiv : OutputEquiv D O :=
  OutputEquiv.ofCoordinates E (by
    intro x j
    simpa only [Equiv.symm_apply_apply] using
      (pvEndpointCoordinates S hS a b hab hp mask hmaskTrue hmaskFalse x (E j)).symm)

private def pvOverlapCascade : Cascade S O where
  endpoint := D
  path := (pvReplacement S hS a b hab hp mask hmaskTrue hmaskFalse).path
  outputEquiv := pvEndpointOutputEquiv S hS a b hab hp mask hmaskTrue hmaskFalse

example : (pvOverlapCascade S hS a b hab hp mask hmaskTrue hmaskFalse).path.tags =
    [.vps, .vps, .ppm, .ppm] := rfl

example (x : alpha) :
    ((pvOverlapCascade S hS a b hab hp mask hmaskTrue hmaskFalse).endpoint.channel x).map
      (pvOverlapCascade S hS a b hab hp mask hmaskTrue hmaskFalse).outputEquiv.equiv =
        (O).channel x :=
  (pvOverlapCascade S hS a b hab hp mask hmaskTrue hmaskFalse).outputEquiv.map_eq x

end PVOverlap

-- R10: the selected columns have unequal masses and both vanish at input 2.
-- The masks agree on their support and differ at that null selected row.
private def pvR10Weights (x : Fin 3) : Fin 3 → NNReal :=
  if x = 2 then ![0, 1, 0] else ![1 / 3, 0, 2 / 3]
private theorem pvR10WeightsSum (x : Fin 3) : ∑ j, pvR10Weights x j = 1 := by
  fin_cases x <;> norm_num [pvR10Weights, Fin.sum_univ_succ, Fin.ext_iff]
private abbrev pvR10State : ActiveFiniteChannel (Fin 3) where
  outputCard := 3
  outputCard_pos := by decide
  channel x := PMF.ofFintype (fun j => (pvR10Weights x j : ENNReal))
    (by exact_mod_cast pvR10WeightsSum x)
  output_active j := by
    fin_cases j
    · exact ⟨0, by change ((1 / 3 : NNReal) : ENNReal) ≠ 0; norm_num⟩
    · exact ⟨2, by change ((1 : NNReal) : ENNReal) ≠ 0; norm_num⟩
    · exact ⟨0, by change ((2 / 3 : NNReal) : ENNReal) ≠ 0; norm_num⟩
private theorem pvR10Singular : IsSingularChannel pvR10State.channel := by
  intro x z j hx hz
  change (pvR10Weights x j : ENNReal) = (pvR10Weights z j : ENNReal)
  change (pvR10Weights x j : ENNReal) ≠ 0 at hx
  change (pvR10Weights z j : ENNReal) ≠ 0 at hz
  fin_cases x <;> fin_cases z <;> fin_cases j <;>
    norm_num [pvR10Weights, Fin.ext_iff, Matrix.cons_val_two] at *
private theorem pvR10Pattern (x : Fin 3) :
    pvR10State.channel x 0 ≠ 0 ↔ pvR10State.channel x 2 ≠ 0 := by
  change (pvR10Weights x 0 : ENNReal) ≠ 0 ↔ (pvR10Weights x 2 : ENNReal) ≠ 0
  fin_cases x <;> norm_num [pvR10Weights, Fin.ext_iff, Matrix.cons_val_two]
private abbrev pvR10Merge := ppm pvR10State pvR10Singular 0 2 (by decide) pvR10Pattern
private abbrev pvR10Survivor := activeMergeSurvivor pvR10State 0 2 (by decide)
private theorem pvR10SurvivorMass (x : Fin 3) :
    pvR10Merge.channel x pvR10Survivor = if x = 2 then 0 else 1 := by
  refine (ppm_apply_survivor pvR10State pvR10Singular 0 2 (by decide) pvR10Pattern x).trans ?_
  change (pvR10Weights x 0 : ENNReal) + (pvR10Weights x 2 : ENNReal) = _
  by_cases hx : x = 2
  · simp [pvR10Weights, hx, Matrix.cons_val_two]
  · have hsum : pvR10Weights x 0 + pvR10Weights x 2 = 1 := by
      norm_num [pvR10Weights, hx, Matrix.cons_val_two]
    rw [← ENNReal.coe_add, hsum, if_neg hx]
    rfl
private def pvR10Mask (x : Fin 3) : Bool := decide (x = 0)
private def pvR10Mask' (x : Fin 3) : Bool := decide (x ≠ 1)
private theorem pvR10True : ∃ x, pvR10Merge.channel x pvR10Survivor ≠ 0 ∧ pvR10Mask x = true :=
  ⟨0, by rw [pvR10SurvivorMass]; norm_num [Fin.ext_iff], rfl⟩
private theorem pvR10False : ∃ x, pvR10Merge.channel x pvR10Survivor ≠ 0 ∧ pvR10Mask x = false :=
  ⟨1, by rw [pvR10SurvivorMass]; norm_num [Fin.ext_iff], rfl⟩
private theorem pvR10True' : ∃ x, pvR10Merge.channel x pvR10Survivor ≠ 0 ∧ pvR10Mask' x = true :=
  ⟨0, by rw [pvR10SurvivorMass]; norm_num [Fin.ext_iff], rfl⟩
private theorem pvR10False' : ∃ x, pvR10Merge.channel x pvR10Survivor ≠ 0 ∧ pvR10Mask' x = false :=
  ⟨1, by rw [pvR10SurvivorMass]; norm_num [Fin.ext_iff], rfl⟩
private abbrev pvR10Target := vps pvR10Merge
  (ppm_isSingular pvR10State pvR10Singular 0 2 (by decide) pvR10Pattern)
  pvR10Survivor pvR10Mask pvR10True pvR10False
private abbrev pvR10Target' := vps pvR10Merge
  (ppm_isSingular pvR10State pvR10Singular 0 2 (by decide) pvR10Pattern)
  pvR10Survivor pvR10Mask' pvR10True' pvR10False'
private abbrev pvR10Witness := pvOverlapCascade pvR10State pvR10Singular 0 2
  (by decide) pvR10Pattern pvR10Mask pvR10True pvR10False

example : pvR10Witness.path.tags = [.vps, .vps, .ppm, .ppm] ∧
    pvR10Witness.path.length = 4 := ⟨rfl, rfl⟩

example : pvR10State.channel 2 0 = 0 ∧ pvR10State.channel 2 2 = 0 ∧
    pvR10Mask 2 ≠ pvR10Mask' 2 := by
  exact ⟨rfl, rfl, by decide⟩

example : pvR10Target.channel = pvR10Target'.channel := by
  apply vps_mask_irrelevant
  intro x hx
  have h : x ≠ 2 := by
    intro he
    subst x
    exact hx ((pvR10SurvivorMass 2).trans (if_pos rfl))
  fin_cases x <;> simp_all [pvR10Mask, pvR10Mask']

example (x : Fin 3) (j : Fin 3) :
    pvR10Witness.endpoint.channel x (pvR10Witness.outputEquiv.equiv.symm j) =
      pvR10Target.channel x j := pvR10Witness.outputEquiv.apply_symm x j

example (x : Fin 3) :
    (pvR10Witness.endpoint.channel x).map pvR10Witness.outputEquiv.equiv =
      pvR10Target.channel x ∧
    (pvR10Target.channel x).map pvR10Witness.outputEquiv.equiv.symm =
      pvR10Witness.endpoint.channel x :=
  ⟨pvR10Witness.outputEquiv.map_eq x, pvR10Witness.outputEquiv.symm.map_eq x⟩

end
end PerfectFunctionalRepresentations.MatrixOperations

namespace PerfectFunctionalRepresentations.MatrixOperations
noncomputable section
universe u
variable {alpha : Type u} [Finite alpha] [Nonempty alpha]

-- Exhaustive selectors keep the exact endpoint of the original two C07 edges.
-- The selected-column cases use the overlap laws; all other labels use the
-- disjoint laws. No premise about relative positions is added.
private def c08PpmPps (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0)
    (l : Fin (ppm S hS a b hab hp).outputCard) (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1) :
    {c : Cascade S (pps (ppm S hS a b hab hp) (ppm_isSingular S hS a b hab hp) l t ht0 ht1) //
      c.path.tags = [.pps, .ppm] ∨ c.path.tags = [.pps, .pps, .ppm, .ppm]} := by
  by_cases hl : l = activeMergeSurvivor S a b hab
  · subst l
    exact ⟨ppOverlapCascade S hS a b hab hp t ht0 ht1, Or.inr rfl⟩
  · exact ⟨dcMergeDisjoint S hS a b hab hp l hl (.pp t ht0 ht1),
      Or.inl (dcMergeDisjoint_tags S hS a b hab hp l hl (.pp t ht0 ht1))⟩

private def c08PpmVps (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0)
    (l : Fin (ppm S hS a b hab hp).outputCard) (mask : alpha → Bool)
    (hl : ∃ x, (ppm S hS a b hab hp).channel x l ≠ 0 ∧ mask x = true)
    (hr : ∃ x, (ppm S hS a b hab hp).channel x l ≠ 0 ∧ mask x = false) :
    {c : Cascade S (vps (ppm S hS a b hab hp) (ppm_isSingular S hS a b hab hp) l mask hl hr) //
      c.path.tags = [.vps, .ppm] ∨ c.path.tags = [.vps, .vps, .ppm, .ppm]} := by
  by_cases hs : l = activeMergeSurvivor S a b hab
  · subst l
    exact ⟨pvOverlapCascade S hS a b hab hp mask hl hr, Or.inr rfl⟩
  · exact ⟨dcMergeDisjoint S hS a b hab hp l hs (.vp mask hl hr),
      Or.inl (dcMergeDisjoint_tags S hS a b hab hp l hs (.vp mask hl hr))⟩

private def c08VpsPps (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (mask : alpha → Bool)
    (hl : ∃ x, S.channel x l ≠ 0 ∧ mask x = true)
    (hr : ∃ x, S.channel x l ≠ 0 ∧ mask x = false)
    (k : Fin (vps S hS l mask hl hr).outputCard) (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1) :
    {c : Cascade S (pps (vps S hS l mask hl hr) (vps_isSingular S hS l mask hl hr) k t ht0 ht1) //
      c.path.tags = [.pps, .vps] ∨ c.path.tags = [.pps, .vps, .vps, .ppm]} := by
  apply Classical.choice
  rcases split_cases l k with hk | ⟨j, hj⟩
  · subst k
    exact ⟨⟨vpRightCascade S hS l t ht0 ht1 mask hl hr, Or.inr rfl⟩⟩
  · subst k
    by_cases h : j = l
    · subst j
      rw [splitKeep_self]
      exact ⟨⟨vpLeftCascade S hS l t ht0 ht1 mask hl hr, Or.inr rfl⟩⟩
    · exact ⟨⟨dcSplitDisjoint S hS l (.vp mask hl hr) j h (.pp t ht0 ht1),
        Or.inl (dcSplitDisjoint_tags S hS l (.vp mask hl hr) j h (.pp t ht0 ht1))⟩⟩

-- Equation (174) identifies the three inversions. This rank is used only for
-- this finite classification, not as a decreasing measure on expanding paths.
private def c08KindRank : OperationKind → Nat
  | .pps => 0 | .vps => 1 | .ppm => 2 | .vpm => 3
private theorem c08Inversions (a b : OperationKind) (ha : a ∈ [.pps, .vps, .ppm])
    (hb : b ∈ [.pps, .vps, .ppm]) :
    c08KindRank b < c08KindRank a ↔
      (a = .ppm ∧ b = .pps) ∨ (a = .vps ∧ b = .pps) ∨ (a = .ppm ∧ b = .vps) := by
  cases a <;> cases b <;> simp_all [c08KindRank]
end
end PerfectFunctionalRepresentations.MatrixOperations

namespace PerfectFunctionalRepresentations.MatrixOperations

noncomputable section

-- R09: the literal (171) source at admitted value one.
private abbrev vpUnit : ActiveFiniteChannel (Fin 2) where
  outputCard := 1
  outputCard_pos := by decide
  channel := fun _ => PMF.pure 0
  output_active := by
    intro j
    have hj : j = 0 := Subsingleton.elim _ _
    subst j
    exact ⟨0, by simp⟩

private theorem vpUnit_singular : IsSingularChannel vpUnit.channel := by
  intro x z j _ _
  rfl

private def vpMask : Fin 2 → Bool := fun x => decide (x = 0)
private theorem vpThird_pos : (0 : NNReal) < 1 / 3 := by norm_num
private theorem vpThird_lt : (1 / 3 : NNReal) < 1 := by norm_num
private theorem vpThird_complement : (1 - (1 / 3 : NNReal)) = 2 / 3 := by
  apply NNReal.coe_injective
  norm_num [NNReal.coe_sub_def]
private theorem vpTwoNinths : (2 / 3 : ENNReal) * 3⁻¹ = 2 / 9 := by
  have h : (2 / 3 : NNReal) * 3⁻¹ = 2 / 9 := by norm_num
  simpa only [ENNReal.coe_mul,
    ENNReal.coe_div (show (3 : NNReal) ≠ 0 by norm_num),
    ENNReal.coe_div (show (9 : NNReal) ≠ 0 by norm_num),
    ENNReal.coe_inv (show (3 : NNReal) ≠ 0 by norm_num),
    ENNReal.coe_ofNat] using congrArg (fun r : NNReal => (r : ENNReal)) h
private theorem vpNinth : (3 : ENNReal)⁻¹ * 3⁻¹ = 9⁻¹ := by
  have h : (3 : NNReal)⁻¹ * 3⁻¹ = 9⁻¹ := by norm_num
  simpa only [ENNReal.coe_mul,
    ENNReal.coe_inv (show (3 : NNReal) ≠ 0 by norm_num),
    ENNReal.coe_inv (show (9 : NNReal) ≠ 0 by norm_num),
    ENNReal.coe_ofNat] using congrArg (fun r : NNReal => (r : ENNReal)) h
private theorem vpUnit_left : ∃ x, vpUnit.channel x 0 ≠ 0 ∧ vpMask x = true :=
  ⟨0, by simp [vpUnit], by decide⟩
private theorem vpUnit_right : ∃ x, vpUnit.channel x 0 ≠ 0 ∧ vpMask x = false :=
  ⟨1, by simp [vpUnit], by decide⟩

private def vpUnitLeft := vpLeftCascade vpUnit vpUnit_singular 0 (1 / 3)
  vpThird_pos vpThird_lt vpMask vpUnit_left vpUnit_right
private def vpUnitRight := vpRightCascade vpUnit vpUnit_singular 0 (1 / 3)
  vpThird_pos vpThird_lt vpMask vpUnit_left vpUnit_right

example : vpUnitLeft.outputEquiv.equiv (1 : Fin 3) = (2 : Fin 3) := rfl
example : vpUnitLeft.outputEquiv.equiv (2 : Fin 3) = (1 : Fin 3) := rfl
example : vpUnitRight.outputEquiv.equiv (1 : Fin 3) = (1 : Fin 3) := rfl

example : vpUnitLeft.endpoint.channel 0 (0 : Fin 3) = ((1 / 3 : NNReal) : ENNReal) :=
  (vpPL_zero vpUnit vpUnit_singular 0 (1 / 3) vpThird_pos vpThird_lt
    vpMask vpUnit_left vpUnit_right 0).trans (by
      norm_num [vpUnit, vpMask, vpThird_complement, ← ENNReal.coe_mul, ENNReal.coe_inj])
example : vpUnitLeft.endpoint.channel 0 (1 : Fin 3) = 0 :=
  (vpPL_one vpUnit vpUnit_singular 0 (1 / 3) vpThird_pos vpThird_lt
    vpMask vpUnit_left vpUnit_right 0).trans (by
      norm_num [vpUnit, vpMask, vpThird_complement, ← ENNReal.coe_mul, ENNReal.coe_inj])
example : vpUnitLeft.endpoint.channel 0 (2 : Fin 3) = ((2 / 3 : NNReal) : ENNReal) :=
  (vpPL_two vpUnit vpUnit_singular 0 (1 / 3) vpThird_pos vpThird_lt
    vpMask vpUnit_left vpUnit_right 0).trans (by
      norm_num [vpUnit, vpMask, vpThird_complement, ← ENNReal.coe_mul, ENNReal.coe_inj])
example : vpUnitLeft.endpoint.channel 1 (1 : Fin 3) = 1 :=
  (vpPL_one vpUnit vpUnit_singular 0 (1 / 3) vpThird_pos vpThird_lt
    vpMask vpUnit_left vpUnit_right 1).trans (by
      norm_num [vpUnit, vpMask, vpThird_complement, ← ENNReal.coe_mul, ENNReal.coe_inj])
example : vpUnitRight.endpoint.channel 0 (0 : Fin 3) = 1 :=
  (vpPR_zero vpUnit vpUnit_singular 0 (1 / 3) vpThird_pos vpThird_lt
    vpMask vpUnit_left vpUnit_right 0).trans (by
      norm_num [vpUnit, vpMask, vpThird_complement, ← ENNReal.coe_mul, ENNReal.coe_inj])
example : vpUnitRight.endpoint.channel 1 (1 : Fin 3) = ((1 / 3 : NNReal) : ENNReal) :=
  (vpPR_one vpUnit vpUnit_singular 0 (1 / 3) vpThird_pos vpThird_lt
    vpMask vpUnit_left vpUnit_right 1).trans (by
      norm_num [vpUnit, vpMask, vpThird_complement, ← ENNReal.coe_mul, ENNReal.coe_inj])
example : vpUnitRight.endpoint.channel 1 (2 : Fin 3) = ((2 / 3 : NNReal) : ENNReal) :=
  (vpPR_two vpUnit vpUnit_singular 0 (1 / 3) vpThird_pos vpThird_lt
    vpMask vpUnit_left vpUnit_right 1).trans (by
      norm_num [vpUnit, vpMask, vpThird_complement, ← ENNReal.coe_mul, ENNReal.coe_inj])

-- A three-column source with distinguishable unchanged columns and unequal descendants.
private abbrev vpAsym : ActiveFiniteChannel (Fin 2) where
  outputCard := 3
  outputCard_pos := by decide
  channel := fun x => PMF.binaryMixture (1 / 3) vpThird_lt.le
    (PMF.pure 0) (PMF.pure (if x = 0 then 1 else 2))
  output_active := by
    intro j
    fin_cases j
    · exact ⟨0, by norm_num [PMF.binaryMixture_apply, PMF.pure_apply,
        vpThird_complement, Fin.ext_iff]⟩
    · exact ⟨0, by norm_num [PMF.binaryMixture_apply, PMF.pure_apply,
        vpThird_complement, Fin.ext_iff]⟩
    · exact ⟨1, by norm_num [PMF.binaryMixture_apply, PMF.pure_apply,
        vpThird_complement, Fin.ext_iff]⟩

private theorem vpAsym_singular : IsSingularChannel vpAsym.channel := by
  intro x z j hx hz
  fin_cases x <;> fin_cases z <;> fin_cases j <;>
    norm_num [vpAsym, PMF.binaryMixture_apply, PMF.pure_apply, vpThird_complement, Fin.ext_iff] at *

private theorem vpAsym_left : ∃ x, vpAsym.channel x 0 ≠ 0 ∧ vpMask x = true :=
  ⟨0, by norm_num [vpAsym, PMF.binaryMixture_apply, PMF.pure_apply,
      vpThird_complement, Fin.ext_iff], by decide⟩
private theorem vpAsym_right : ∃ x, vpAsym.channel x 0 ≠ 0 ∧ vpMask x = false :=
  ⟨1, by norm_num [vpAsym, PMF.binaryMixture_apply, PMF.pure_apply,
      vpThird_complement, Fin.ext_iff], by decide⟩

private def vpCycle : Fin 3 ≃ Fin 3 :=
  (Equiv.swap 1 2).trans (Equiv.swap 0 1)
private def vpMoved := ActiveFiniteChannel.ofActive vpAsym.channel vpCycle vpAsym.output_active
private def vpMoveEquiv : OutputEquiv vpAsym vpMoved := ⟨vpCycle, fun _ => rfl⟩
private def vpMovedLeft := vpLeftCascade vpMoved (vpMoveEquiv.isSingular vpAsym_singular)
  (vpCycle 0) (1 / 3) vpThird_pos vpThird_lt vpMask
  (vpMoveEquiv.vpsWitness 0 vpMask true vpAsym_left)
  (vpMoveEquiv.vpsWitness 0 vpMask false vpAsym_right)
private def vpMovedV := vpMoveEquiv.vps vpAsym_singular 0 vpMask vpAsym_left vpAsym_right
private def vpMovedP := vpMovedV.pps (vps_isSingular vpAsym vpAsym_singular 0 vpMask
  vpAsym_left vpAsym_right) (0 : Fin 4) (1 / 3) vpThird_pos vpThird_lt

private def vpSurrounding : OutputEquiv vpMovedLeft.endpoint
    (vpOL vpAsym vpAsym_singular 0 (1 / 3) vpThird_pos vpThird_lt vpMask
      vpAsym_left vpAsym_right) :=
  vpMovedLeft.outputEquiv.trans vpMovedP.symm

example (j : Fin 3) : vpCycle j = (![1, 2, 0] : Fin 3 → Fin 3) j := by
  fin_cases j <;> rfl
example (j : Fin 5) : vpSurrounding.equiv j = (![4, 0, 2, 1, 3] : Fin 5 → Fin 5) j := by
  fin_cases j <;> rfl
example : vpSurrounding.equiv.symm (0 : Fin 5) = (1 : Fin 5) := rfl
example : vpSurrounding.equiv (0 : Fin 5) ≠ vpSurrounding.equiv.symm (0 : Fin 5) := by
  change (4 : Fin 5) ≠ 1
  decide

-- Both unchanged columns are checked on both rows; equal nominal mass does not hide their patterns.
private theorem vpMoved_zero : vpMovedLeft.endpoint.channel 0 (0 : Fin 5) = 0 :=
  (vpSurrounding.apply 0 (0 : Fin 5)).symm.trans
    ((vpOL_keep vpAsym vpAsym_singular 0 (1 / 3) vpThird_pos vpThird_lt vpMask
      vpAsym_left vpAsym_right 0 2 (by decide)).trans
        (by norm_num [vpAsym, PMF.binaryMixture_apply, PMF.pure_apply,
          vpThird_complement, Fin.ext_iff]))
example : vpMovedLeft.endpoint.channel 1 (0 : Fin 5) = ((2 / 3 : NNReal) : ENNReal) :=
  (vpSurrounding.apply 1 (0 : Fin 5)).symm.trans
    ((vpOL_keep vpAsym vpAsym_singular 0 (1 / 3) vpThird_pos vpThird_lt vpMask
      vpAsym_left vpAsym_right 1 2 (by decide)).trans
        (by norm_num [vpAsym, PMF.binaryMixture_apply, PMF.pure_apply,
          vpThird_complement, Fin.ext_iff]))
example : vpMovedLeft.endpoint.channel 0 (4 : Fin 5) = ((2 / 3 : NNReal) : ENNReal) :=
  (vpSurrounding.apply 0 (4 : Fin 5)).symm.trans
    ((vpOL_keep vpAsym vpAsym_singular 0 (1 / 3) vpThird_pos vpThird_lt vpMask
      vpAsym_left vpAsym_right 0 1 (by decide)).trans
        (by norm_num [vpAsym, PMF.binaryMixture_apply, PMF.pure_apply,
          vpThird_complement, Fin.ext_iff]))
example : vpMovedLeft.endpoint.channel 1 (4 : Fin 5) = 0 :=
  (vpSurrounding.apply 1 (4 : Fin 5)).symm.trans
    ((vpOL_keep vpAsym vpAsym_singular 0 (1 / 3) vpThird_pos vpThird_lt vpMask
      vpAsym_left vpAsym_right 1 1 (by decide)).trans
        (by norm_num [vpAsym, PMF.binaryMixture_apply, PMF.pure_apply,
          vpThird_complement, Fin.ext_iff]))
private theorem vpWrong_value : (vpOL vpAsym vpAsym_singular 0 (1 / 3) vpThird_pos vpThird_lt
    vpMask vpAsym_left vpAsym_right).channel 0 (vpSurrounding.equiv.symm (0 : Fin 5)) =
      ((2 / 9 : NNReal) : ENNReal) :=
  (vpOL_one vpAsym vpAsym_singular 0 (1 / 3) vpThird_pos vpThird_lt
    vpMask vpAsym_left vpAsym_right 0).trans
      (by
        norm_num [vpAsym, vpMask, PMF.binaryMixture_apply, PMF.pure_apply,
          vpThird_complement, Fin.ext_iff, ← ENNReal.coe_mul, ENNReal.coe_inj]
        exact vpTwoNinths)

-- The two descendants have unequal masses, so their order is observable as well.
example : vpMovedLeft.endpoint.channel 0 (1 : Fin 5) = ((1 / 9 : NNReal) : ENNReal) :=
  (vpSurrounding.apply 0 (1 : Fin 5)).symm.trans
    ((vpOL_zero vpAsym vpAsym_singular 0 (1 / 3) vpThird_pos vpThird_lt vpMask
      vpAsym_left vpAsym_right 0).trans (by
        norm_num [vpAsym, vpMask, PMF.binaryMixture_apply, PMF.pure_apply,
          vpThird_complement, Fin.ext_iff, ← ENNReal.coe_mul, ENNReal.coe_inj]
        exact vpNinth))
example : vpMovedLeft.endpoint.channel 0 (3 : Fin 5) = ((2 / 9 : NNReal) : ENNReal) :=
  (vpSurrounding.apply 0 (3 : Fin 5)).symm.trans vpWrong_value

example : (vpMovedLeft.endpoint.channel 0).map vpSurrounding.equiv.symm ≠
    (vpOL vpAsym vpAsym_singular 0 (1 / 3) vpThird_pos vpThird_lt
      vpMask vpAsym_left vpAsym_right).channel 0 := by
  intro h
  have hMass := congrArg (fun q : PMF (Fin 5) => q (vpSurrounding.equiv.symm (0 : Fin 5))) h
  have hbad : (0 : ENNReal) = ((2 / 9 : NNReal) : ENNReal) := vpMoved_zero.symm.trans
    ((PMF.map_apply_equiv (vpMovedLeft.endpoint.channel 0) vpSurrounding.equiv.symm
      (0 : Fin 5)).symm.trans (hMass.trans vpWrong_value))
  exact (ENNReal.coe_ne_zero.mpr (by norm_num : (2 / 9 : NNReal) ≠ 0)) hbad.symm

end
end PerfectFunctionalRepresentations.MatrixOperations

namespace PerfectFunctionalRepresentations.MatrixOperations

noncomputable section

-- R07 disjoint order regimes with a constant unequal positive Bool row.

private def r07Weights : Fin 4 → NNReal := ![1 / 10, 2 / 10, 3 / 10, 4 / 10]

private theorem r07Sum : ∑ j, r07Weights j = 1 := by
  norm_num [r07Weights, Fin.sum_univ_succ]

private theorem r07Pos (j : Fin 4) : (r07Weights j : ENNReal) ≠ 0 := by
  fin_cases j <;> norm_num [r07Weights]

private abbrev r07S : ActiveFiniteChannel Bool where
  outputCard := 4
  outputCard_pos := by decide
  channel _ := PMF.ofFintype (fun j => (r07Weights j : ENNReal))
    (by exact_mod_cast r07Sum)
  output_active j := ⟨true, r07Pos j⟩

private theorem r07Singular : IsSingularChannel r07S.channel := by
  intro x z j _ _
  rfl

private theorem r07Pattern (a b : Fin 4) (x : Bool) :
    r07S.channel x a ≠ 0 ↔ r07S.channel x b ≠ 0 :=
  ⟨fun _ => r07Pos b, fun _ => r07Pos a⟩

private abbrev r07M (a b : Fin 4) (hab : a < b) :=
  ppm r07S r07Singular a b hab (r07Pattern a b)

private theorem r07MPos (a b : Fin 4) (hab : a < b) (x : Bool) (j : Fin 3) :
    (r07M a b hab).channel x j ≠ 0 := by
  obtain ⟨z, hz⟩ := (r07M a b hab).output_active j
  exact hz

private def r07VP (a b : Fin 4) (hab : a < b) (j : Fin 3) : DcChoice (r07M a b hab) j :=
  .vp id ⟨true, r07MPos a b hab true j, rfl⟩ ⟨false, r07MPos a b hab false j, rfl⟩

private abbrev r07PP (S : ActiveFiniteChannel Bool) (j : Fin S.outputCard) : DcChoice S j :=
  .pp (1 / 3) (by norm_num) (by norm_num)

private theorem r07NeSurvivor (a b : Fin 4) (hab : a < b) (j : Fin 3)
    (h : j.val ≠ a.val) : j ≠ activeMergeSurvivor r07S a b hab := by
  intro he
  exact h ((congrArg Fin.val he).trans (activeMergeSurvivor_val r07S a b hab))

private abbrev r07MC (a b : Fin 4) (hab : a < b) (l : Fin 3) (hl : l.val ≠ a.val)
    (spec : DcChoice (r07M a b hab) l) :=
  dcMergeDisjoint r07S r07Singular a b hab (r07Pattern a b) l
    (r07NeSurvivor a b hab l hl) spec

private theorem r07MergeCoord (a b : Fin 4) (hab : a < b) (l : Fin 3) (hl : l.val ≠ a.val)
    (spec : DcChoice (r07M a b hab) l) (x : Bool)
    (j : Fin (dcDo (r07M a b hab) (ppm_isSingular r07S r07Singular a b hab
      (r07Pattern a b)) l spec).outputCard) :
    (r07MC a b hab l hl spec).endpoint.channel x
      ((r07MC a b hab l hl spec).outputEquiv.equiv.symm j) =
      dcSplit (dcMerge (dcMass r07S.channel x) a.val b.val) l.val
        (dcWeightL spec x) (dcWeightR spec x) j.val := by
  refine ((r07MC a b hab l hl spec).outputEquiv.apply_symm x j).trans ?_
  refine (dcMass_fin _ x j).symm.trans ?_
  refine (dcDoMass (r07M a b hab) (ppm_isSingular r07S r07Singular a b hab
    (r07Pattern a b)) l spec x j.val).trans ?_
  exact congrArg (fun f => dcSplit f l.val (dcWeightL spec x) (dcWeightR spec x) j.val)
    (funext (dcPpm r07S r07Singular a b hab (r07Pattern a b) x))

private abbrev r07BeforePP :=
  r07MC 1 3 (by decide) 0 (by decide) (r07PP (r07M 1 3 (by decide)) (0 : Fin 3))

example : r07BeforePP.path.tags = [.pps, .ppm] :=
  dcMergeDisjoint_tags r07S r07Singular 1 3 (by decide) (r07Pattern 1 3) (0 : Fin 3)
    (r07NeSurvivor 1 3 (by decide) 0 (by decide)) (r07PP (r07M 1 3 (by decide)) (0 : Fin 3))

example (x : Bool) (j : Fin 4) : r07BeforePP.endpoint.channel x
    (r07BeforePP.outputEquiv.equiv.symm j) =
      ((![1 / 30, 1 / 15, 3 / 5, 3 / 10] j : NNReal) : ENNReal) := by
  refine (r07MergeCoord 1 3 (by decide) 0 (by decide)
    (r07PP (r07M 1 3 (by decide)) (0 : Fin 3)) x j).trans ?_
  cases x <;> fin_cases j <;>
    norm_num [dcSplit, dcMerge, dcMass, dcWeightL, dcWeightR, r07PP, r07VP,
      r07S, PMF.ofFintype_apply, r07Weights, Matrix.cons_val_three, Fin.ext_iff]
  all_goals
    apply (ENNReal.toNNReal_eq_toNNReal_iff' (by finiteness) (by finiteness)).mp
    simp (disch := finiteness) only [ENNReal.toNNReal_add, ENNReal.toNNReal_mul,
      ENNReal.toNNReal_div, ENNReal.toNNReal_inv, ENNReal.toNNReal_sub,
      ENNReal.toNNReal_ofNat, ENNReal.toNNReal_one]
  all_goals
    apply NNReal.coe_injective
    norm_num [NNReal.coe_sub_def]

private abbrev r07BeforeVP := r07MC 1 3 (by decide) 0 (by decide) (r07VP 1 3 (by decide) 0)

example : r07BeforeVP.path.tags = [.vps, .ppm] :=
  dcMergeDisjoint_tags r07S r07Singular 1 3 (by decide) (r07Pattern 1 3) (0 : Fin 3)
    (r07NeSurvivor 1 3 (by decide) 0 (by decide)) (r07VP 1 3 (by decide) 0)

example (x : Bool) (j : Fin 4) : r07BeforeVP.endpoint.channel x
    (r07BeforeVP.outputEquiv.equiv.symm j) =
      ((![if x then 1 / 10 else 0, if x then 0 else 1 / 10, 3 / 5, 3 / 10]
        j : NNReal) : ENNReal) := by
  refine (r07MergeCoord 1 3 (by decide) 0 (by decide) (r07VP 1 3 (by decide) 0) x j).trans ?_
  cases x <;> fin_cases j <;>
    norm_num [dcSplit, dcMerge, dcMass, dcWeightL, dcWeightR, r07PP, r07VP,
      r07S, PMF.ofFintype_apply, r07Weights, Matrix.cons_val_three, Fin.ext_iff]
  all_goals
    apply (ENNReal.toNNReal_eq_toNNReal_iff' (by finiteness) (by finiteness)).mp
    simp (disch := finiteness) only [ENNReal.toNNReal_add,
      ENNReal.toNNReal_div, ENNReal.toNNReal_inv,
      ENNReal.toNNReal_ofNat]
  all_goals
    apply NNReal.coe_injective
    norm_num [NNReal.coe_sub_def]

private abbrev r07BetweenPP :=
  r07MC 0 2 (by decide) 1 (by decide) (r07PP (r07M 0 2 (by decide)) (1 : Fin 3))

example : r07BetweenPP.path.tags = [.pps, .ppm] :=
  dcMergeDisjoint_tags r07S r07Singular 0 2 (by decide) (r07Pattern 0 2) (1 : Fin 3)
    (r07NeSurvivor 0 2 (by decide) 1 (by decide)) (r07PP (r07M 0 2 (by decide)) (1 : Fin 3))

example (x : Bool) (j : Fin 4) : r07BetweenPP.endpoint.channel x
    (r07BetweenPP.outputEquiv.equiv.symm j) =
      ((![2 / 5, 1 / 15, 2 / 15, 2 / 5] j : NNReal) : ENNReal) := by
  refine (r07MergeCoord 0 2 (by decide) 1 (by decide)
    (r07PP (r07M 0 2 (by decide)) (1 : Fin 3)) x j).trans ?_
  cases x <;> fin_cases j <;>
    norm_num [dcSplit, dcMerge, dcMass, dcWeightL, dcWeightR, r07PP, r07VP,
      r07S, PMF.ofFintype_apply, r07Weights, Matrix.cons_val_three, Fin.ext_iff]
  all_goals
    apply (ENNReal.toNNReal_eq_toNNReal_iff' (by finiteness) (by finiteness)).mp
    simp (disch := finiteness) only [ENNReal.toNNReal_add, ENNReal.toNNReal_mul,
      ENNReal.toNNReal_div, ENNReal.toNNReal_inv, ENNReal.toNNReal_sub,
      ENNReal.toNNReal_ofNat, ENNReal.toNNReal_one]
  all_goals
    apply NNReal.coe_injective
    norm_num [NNReal.coe_sub_def]

private abbrev r07BetweenVP := r07MC 0 2 (by decide) 1 (by decide) (r07VP 0 2 (by decide) 1)

example : r07BetweenVP.path.tags = [.vps, .ppm] :=
  dcMergeDisjoint_tags r07S r07Singular 0 2 (by decide) (r07Pattern 0 2) (1 : Fin 3)
    (r07NeSurvivor 0 2 (by decide) 1 (by decide)) (r07VP 0 2 (by decide) 1)

example (x : Bool) (j : Fin 4) : r07BetweenVP.endpoint.channel x
    (r07BetweenVP.outputEquiv.equiv.symm j) =
      ((![2 / 5, if x then 1 / 5 else 0, if x then 0 else 1 / 5, 2 / 5] j : NNReal) : ENNReal) := by
  refine (r07MergeCoord 0 2 (by decide) 1 (by decide) (r07VP 0 2 (by decide) 1) x j).trans ?_
  cases x <;> fin_cases j <;>
    norm_num [dcSplit, dcMerge, dcMass, dcWeightL, dcWeightR, r07PP, r07VP,
      r07S, PMF.ofFintype_apply, r07Weights, Matrix.cons_val_three, Fin.ext_iff]
  all_goals
    apply (ENNReal.toNNReal_eq_toNNReal_iff' (by finiteness) (by finiteness)).mp
    simp (disch := finiteness) only [ENNReal.toNNReal_add,
      ENNReal.toNNReal_div, ENNReal.toNNReal_inv,
      ENNReal.toNNReal_ofNat]
  all_goals
    apply NNReal.coe_injective
    norm_num [NNReal.coe_sub_def]

private abbrev r07AfterPP :=
  r07MC 0 1 (by decide) 1 (by decide) (r07PP (r07M 0 1 (by decide)) (1 : Fin 3))

example : r07AfterPP.path.tags = [.pps, .ppm] :=
  dcMergeDisjoint_tags r07S r07Singular 0 1 (by decide) (r07Pattern 0 1) (1 : Fin 3)
    (r07NeSurvivor 0 1 (by decide) 1 (by decide)) (r07PP (r07M 0 1 (by decide)) (1 : Fin 3))

example (x : Bool) (j : Fin 4) : r07AfterPP.endpoint.channel x
    (r07AfterPP.outputEquiv.equiv.symm j) =
      ((![3 / 10, 1 / 10, 1 / 5, 2 / 5] j : NNReal) : ENNReal) := by
  refine (r07MergeCoord 0 1 (by decide) 1 (by decide)
    (r07PP (r07M 0 1 (by decide)) (1 : Fin 3)) x j).trans ?_
  cases x <;> fin_cases j <;>
    norm_num [dcSplit, dcMerge, dcMass, dcWeightL, dcWeightR, r07PP, r07VP,
      r07S, PMF.ofFintype_apply, r07Weights, Matrix.cons_val_three, Fin.ext_iff]
  all_goals
    apply (ENNReal.toNNReal_eq_toNNReal_iff' (by finiteness) (by finiteness)).mp
    simp (disch := finiteness) only [ENNReal.toNNReal_add, ENNReal.toNNReal_mul,
      ENNReal.toNNReal_div, ENNReal.toNNReal_inv, ENNReal.toNNReal_sub,
      ENNReal.toNNReal_ofNat, ENNReal.toNNReal_one]
  all_goals
    apply NNReal.coe_injective
    norm_num [NNReal.coe_sub_def]

private abbrev r07AfterVP := r07MC 0 1 (by decide) 1 (by decide) (r07VP 0 1 (by decide) 1)

example : r07AfterVP.path.tags = [.vps, .ppm] :=
  dcMergeDisjoint_tags r07S r07Singular 0 1 (by decide) (r07Pattern 0 1) (1 : Fin 3)
    (r07NeSurvivor 0 1 (by decide) 1 (by decide)) (r07VP 0 1 (by decide) 1)

example (x : Bool) (j : Fin 4) : r07AfterVP.endpoint.channel x
    (r07AfterVP.outputEquiv.equiv.symm j) =
      ((![3 / 10, if x then 3 / 10 else 0, if x then 0 else 3 / 10, 2 / 5]
        j : NNReal) : ENNReal) := by
  refine (r07MergeCoord 0 1 (by decide) 1 (by decide) (r07VP 0 1 (by decide) 1) x j).trans ?_
  cases x <;> fin_cases j <;>
    norm_num [dcSplit, dcMerge, dcMass, dcWeightL, dcWeightR, r07PP, r07VP,
      r07S, PMF.ofFintype_apply, r07Weights, Matrix.cons_val_three, Fin.ext_iff]
  all_goals
    apply (ENNReal.toNNReal_eq_toNNReal_iff' (by finiteness) (by finiteness)).mp
    simp (disch := finiteness) only [ENNReal.toNNReal_add,
      ENNReal.toNNReal_div, ENNReal.toNNReal_inv,
      ENNReal.toNNReal_ofNat]
  all_goals
    apply NNReal.coe_injective
    norm_num [NNReal.coe_sub_def]

private def r07First (a : Fin 4) : DcChoice r07S a :=
  .vp id ⟨true, r07Pos a, rfl⟩ ⟨false, r07Pos a, rfl⟩

private abbrev r07A (a : Fin 4) := dcDo r07S r07Singular a (r07First a)

private abbrev r07Second (a b : Fin 4) :=
  r07PP (r07A a) (dcKeep r07S r07Singular a (r07First a) b)

private abbrev r07SC (a b : Fin 4) (hba : b ≠ a) :=
  dcSplitDisjoint r07S r07Singular a (r07First a) b hba (r07Second a b)

private theorem r07SplitCoord (a b : Fin 4) (hba : b ≠ a) (x : Bool) (j : Fin 6) :
    (r07SC a b hba).endpoint.channel x ((r07SC a b hba).outputEquiv.equiv.symm j) =
      dcSplit (dcSplit (dcMass r07S.channel x) a.val
        (dcWeightL (r07First a) x) (dcWeightR (r07First a) x))
        (if b.val ≤ a.val then b.val else b.val + 1)
        (dcWeightL (r07Second a b) x) (dcWeightR (r07Second a b) x) j.val := by
  refine ((r07SC a b hba).outputEquiv.apply_symm x j).trans ?_
  refine (dcMass_fin _ x j).symm.trans ?_
  refine (dcDoMass (r07A a) (OperationStep.isSingular (dcStep r07S r07Singular a
    (r07First a))) (dcKeep r07S r07Singular a (r07First a) b) (r07Second a b) x j.val).trans ?_
  refine (congrArg (fun f => dcSplit f (dcKeep r07S r07Singular a (r07First a) b).val
    (dcWeightL (r07Second a b) x) (dcWeightR (r07Second a b) x) j.val)
      (funext (dcDoMass r07S r07Singular a (r07First a) x))).trans ?_
  exact congrArg (fun k => dcSplit (dcSplit (dcMass r07S.channel x) a.val
    (dcWeightL (r07First a) x) (dcWeightR (r07First a) x)) k
    (dcWeightL (r07Second a b) x) (dcWeightR (r07Second a b) x) j.val)
      (dcKeep_val r07S r07Singular a (r07First a) b)

private abbrev r07SplitFirst := r07SC 0 3 (by decide)

example : r07SplitFirst.path.tags = [.pps, .vps] :=
  dcSplitDisjoint_tags r07S r07Singular 0 (r07First 0) 3 (by decide) (r07Second 0 3)

example (x : Bool) (j : Fin 6) : r07SplitFirst.endpoint.channel x
    (r07SplitFirst.outputEquiv.equiv.symm j) =
      ((![if x then 1 / 10 else 0, if x then 0 else 1 / 10, 1 / 5, 3 / 10, 2 / 15, 4 / 15]
        j : NNReal) : ENNReal) := by
  refine (r07SplitCoord 0 3 (by decide) x j).trans ?_
  cases x <;> fin_cases j <;>
    norm_num [dcSplit, dcMass, dcWeightL, dcWeightR, r07PP, r07First, r07Second,
      r07S, PMF.ofFintype_apply, r07Weights, Matrix.cons_val_three, Fin.ext_iff]
  all_goals
    apply (ENNReal.toNNReal_eq_toNNReal_iff' (by finiteness) (by finiteness)).mp
    simp (disch := finiteness) only [ENNReal.toNNReal_mul,
      ENNReal.toNNReal_div, ENNReal.toNNReal_inv, ENNReal.toNNReal_sub,
      ENNReal.toNNReal_ofNat, ENNReal.toNNReal_one]
  all_goals
    apply NNReal.coe_injective
    norm_num [NNReal.coe_sub_def]

private abbrev r07SplitFinal := r07SC 3 0 (by decide)

example : r07SplitFinal.path.tags = [.pps, .vps] :=
  dcSplitDisjoint_tags r07S r07Singular 3 (r07First 3) 0 (by decide) (r07Second 3 0)

example (x : Bool) (j : Fin 6) : r07SplitFinal.endpoint.channel x
    (r07SplitFinal.outputEquiv.equiv.symm j) =
      ((![1 / 30, 1 / 15, 1 / 5, 3 / 10, if x then 2 / 5 else 0, if x then 0 else 2 / 5]
        j : NNReal) : ENNReal) := by
  refine (r07SplitCoord 3 0 (by decide) x j).trans ?_
  cases x <;> fin_cases j <;>
    norm_num [dcSplit, dcMass, dcWeightL, dcWeightR, r07PP, r07First, r07Second,
      r07S, PMF.ofFintype_apply, r07Weights, Matrix.cons_val_three, Fin.ext_iff]
  all_goals
    apply (ENNReal.toNNReal_eq_toNNReal_iff' (by finiteness) (by finiteness)).mp
    simp (disch := finiteness) only [ENNReal.toNNReal_mul,
      ENNReal.toNNReal_inv, ENNReal.toNNReal_sub,
      ENNReal.toNNReal_ofNat, ENNReal.toNNReal_one]
  all_goals
    apply NNReal.coe_injective
    norm_num [NNReal.coe_sub_def]

end
end PerfectFunctionalRepresentations.MatrixOperations
