import Mathlib.Data.Fin.Tuple.Basic
import Mathlib.Logic.Equiv.Fin.Basic
import Lean.Elab.Tactic.Omega

/-!
# Ordered split, merge and recovery indices

These maps realize the column order of ISIT Section III-A, Equations (11)-(15),
with the extended manuscript's corrected range of all source columns for a merge.
A split inserts its second child immediately after the selected column. A merge
keeps the lower selected column and deletes the higher one, including when that
higher column is the final source label.

`recoveryPerm` maps the order after a merge and adjacent re-split back to the
original order. Its forward and inverse formulas are purely about finite labels;
this module proves no channel construction, closure or operation recovery theorem.
-/
namespace PerfectFunctionalRepresentations.MatrixOperations

variable {n m : ℕ}

/-- The first child retains the selected column's numeric index. -/
def splitLeft (l : Fin n) : Fin (n + 1) := l.castSucc

/-- The second child is inserted immediately after the selected column. -/
def splitRight (l : Fin n) : Fin (n + 1) := l.succ

/-- Embed old output labels while leaving a hole for the second child. -/
def splitKeep (l : Fin n) : Fin n → Fin (n + 1) := l.succ.succAbove

@[simp] theorem splitKeep_self (l : Fin n) : splitKeep l l = splitLeft l :=
  Fin.succAbove_succ_self l

theorem splitKeep_injective (l : Fin n) : Function.Injective (splitKeep l) :=
  Fin.succAbove_right_injective

@[simp] theorem splitKeep_ne_right (l j : Fin n) : splitKeep l j ≠ splitRight l :=
  Fin.succAbove_ne _ _

@[simp] theorem splitLeft_ne_right (l : Fin n) : splitLeft l ≠ splitRight l := by
  simpa only [splitKeep_self] using splitKeep_ne_right l l

theorem split_cases (l : Fin n) (j : Fin (n + 1)) :
    j = splitRight l ∨ ∃ k, j = splitKeep l k :=
  Fin.eq_self_or_eq_succAbove _ _

theorem splitKeep_of_le (l j : Fin n) (hj : j ≤ l) : splitKeep l j = j.castSucc :=
  Fin.succAbove_succ_of_le l j hj

theorem splitKeep_of_lt (l j : Fin n) (hj : l < j) : splitKeep l j = j.succ :=
  Fin.succAbove_succ_of_lt l j hj

/-- The lower selected label after deleting the higher selected label. -/
def mergeSurvivor (a b : Fin (m + 1)) (hab : a < b) : Fin m :=
  (finSuccAboveEquiv b).symm ⟨a, ne_of_lt hab⟩

@[simp] theorem mergeSurvivor_succAbove (a b : Fin (m + 1)) (hab : a < b) :
    b.succAbove (mergeSurvivor a b hab) = a :=
  congrArg Subtype.val ((finSuccAboveEquiv b).apply_symm_apply ⟨a, ne_of_lt hab⟩)

@[simp] theorem mergeSurvivor_val (a b : Fin (m + 1)) (hab : a < b) :
    (mergeSurvivor a b hab).val = a.val := by
  have h := mergeSurvivor_succAbove a b hab
  have hlt : (mergeSurvivor a b hab).castSucc < b :=
    (Fin.succAbove_lt_iff_castSucc_lt b _).mp (by rw [h]; exact hab)
  rw [Fin.succAbove_of_castSucc_lt _ _ hlt] at h
  exact congrArg Fin.val h
/-- Collapse the selected pair to the lower label and delete the higher label. -/
def mergeIndex (a b : Fin (m + 1)) (hab : a < b) : Fin (m + 1) → Fin m :=
  Fin.insertNth (α := fun _ => Fin m) b (mergeSurvivor a b hab) id

@[simp] theorem mergeIndex_right (a b : Fin (m + 1)) (hab : a < b) :
    mergeIndex a b hab b = mergeSurvivor a b hab := by
  simp [mergeIndex]

@[simp] theorem mergeIndex_succAbove (a b : Fin (m + 1)) (hab : a < b) (j : Fin m) :
    mergeIndex a b hab (b.succAbove j) = j := by
  simp [mergeIndex]

@[simp] theorem mergeIndex_left (a b : Fin (m + 1)) (hab : a < b) :
    mergeIndex a b hab a = mergeSurvivor a b hab := by
  simpa only [mergeSurvivor_succAbove] using
    mergeIndex_succAbove a b hab (mergeSurvivor a b hab)

theorem mergeIndex_fiber_survivor (a b : Fin (m + 1)) (hab : a < b) (j : Fin (m + 1)) :
    mergeIndex a b hab j = mergeSurvivor a b hab ↔ j = a ∨ j = b := by
  rcases Fin.eq_self_or_eq_succAbove b j with rfl | ⟨k, rfl⟩
  · simp
  · rw [mergeIndex_succAbove]
    constructor
    · intro h
      left
      rw [h, mergeSurvivor_succAbove]
    · rintro (h | h)
      · apply Fin.succAbove_right_injective (p := b)
        simpa using h
      · exact False.elim (Fin.succAbove_ne b k h)

theorem mergeIndex_fiber_ne (a b : Fin (m + 1)) (hab : a < b) (j : Fin m)
    (hj : j ≠ mergeSurvivor a b hab) (k : Fin (m + 1)) :
    mergeIndex a b hab k = j ↔ k = b.succAbove j := by
  rcases Fin.eq_self_or_eq_succAbove b k with rfl | ⟨r, rfl⟩
  · simp [Ne.symm hj, Fin.ne_succAbove]
  · rw [mergeIndex_succAbove]
    exact ⟨fun h => congrArg b.succAbove h, fun h => Fin.succAbove_right_injective h⟩

theorem mergeIndex_val_of_lt (a b : Fin (m + 1)) (hab : a < b)
    (j : Fin (m + 1)) (hj : j < b) : (mergeIndex a b hab j).val = j.val := by
  obtain ⟨k, hk⟩ := Fin.exists_succAbove_eq (ne_of_lt hj)
  rw [← hk, mergeIndex_succAbove]
  have hlt : k.castSucc < b :=
    (Fin.succAbove_lt_iff_castSucc_lt b k).mp (by rwa [hk])
  rw [Fin.succAbove_of_castSucc_lt _ _ hlt]
  rfl

theorem mergeIndex_val_of_gt (a b : Fin (m + 1)) (hab : a < b)
    (j : Fin (m + 1)) (hj : b < j) : (mergeIndex a b hab j).val = j.val - 1 := by
  obtain ⟨k, hk⟩ := Fin.exists_succAbove_eq (ne_of_gt hj)
  rw [← hk, mergeIndex_succAbove]
  have hle : b ≤ k.castSucc :=
    (Fin.lt_succAbove_iff_le_castSucc b k).mp (by rwa [hk])
  rw [Fin.succAbove_of_le_castSucc _ _ hle]
  simp
end PerfectFunctionalRepresentations.MatrixOperations

namespace PerfectFunctionalRepresentations.MatrixOperations

variable {n m : ℕ}

/-- Reorder the adjacent re-split output back to the original source order. -/
def recoveryPerm {n : ℕ} (a b : Fin n) (hab : a < b) : Fin n ≃ Fin n :=
  match n with
  | 0 => Fin.elim0 a
  | _m + 1 =>
    (finSuccEquiv' (mergeSurvivor a b hab).succ).trans (finSuccEquiv' b).symm

@[simp] theorem recoveryPerm_right (a b : Fin (m + 1)) (hab : a < b) :
    recoveryPerm a b hab (mergeSurvivor a b hab).succ = b := by
  simp [recoveryPerm, Equiv.trans_apply]

@[simp] theorem recoveryPerm_keep (a b : Fin (m + 1)) (hab : a < b) (j : Fin m) :
    recoveryPerm a b hab ((mergeSurvivor a b hab).succ.succAbove j) = b.succAbove j := by
  simp [recoveryPerm, Equiv.trans_apply]

@[simp] theorem recoveryPerm_left (a b : Fin (m + 1)) (hab : a < b) :
    recoveryPerm a b hab (mergeSurvivor a b hab).castSucc = a := by
  simpa only [Fin.succAbove_succ_self, mergeSurvivor_succAbove] using
    recoveryPerm_keep a b hab (mergeSurvivor a b hab)

@[simp] theorem recoveryPerm_symm_right (a b : Fin (m + 1)) (hab : a < b) :
    (recoveryPerm a b hab).symm b = (mergeSurvivor a b hab).succ :=
  (recoveryPerm a b hab).symm_apply_eq.mpr (recoveryPerm_right a b hab).symm

@[simp] theorem recoveryPerm_symm_keep (a b : Fin (m + 1)) (hab : a < b) (j : Fin m) :
    (recoveryPerm a b hab).symm (b.succAbove j) =
      (mergeSurvivor a b hab).succ.succAbove j :=
  (recoveryPerm a b hab).symm_apply_eq.mpr (recoveryPerm_keep a b hab j).symm

theorem recoveryPerm_val (a b : Fin n) (hab : a < b) (j : Fin n) :
    (recoveryPerm a b hab j).val =
      if j.val ≤ a.val ∨ b.val < j.val then j.val
      else if j.val = a.val + 1 then b.val else j.val - 1 := by
  cases n with
  | zero => exact Fin.elim0 a
  | succ m =>
    have habv : a.val < b.val := hab
    rcases Fin.eq_self_or_eq_succAbove (mergeSurvivor a b hab).succ j with rfl | ⟨k, rfl⟩
    · rw [recoveryPerm_right]
      simp only [Fin.val_succ, mergeSurvivor_val]
      split_ifs <;> omega
    · rw [recoveryPerm_keep]
      simp only [Fin.succAbove]
      split_ifs <;>
        simp_all only [Fin.lt_def, Fin.val_castSucc, Fin.val_succ, mergeSurvivor_val] <;> omega

theorem recoveryPerm_fixed_of_le (a b : Fin n) (hab : a < b) (j : Fin n) (hj : j ≤ a) :
    recoveryPerm a b hab j = j := by
  apply Fin.ext
  rw [recoveryPerm_val, if_pos (Or.inl (show j.val ≤ a.val from hj))]

theorem recoveryPerm_fixed_of_gt (a b : Fin n) (hab : a < b) (j : Fin n) (hj : b < j) :
    recoveryPerm a b hab j = j := by
  apply Fin.ext
  rw [recoveryPerm_val, if_pos (Or.inr (show b.val < j.val from hj))]

theorem recoveryPerm_second (a b : Fin n) (hab : a < b) (j : Fin n)
    (hj : j.val = a.val + 1) : recoveryPerm a b hab j = b := by
  apply Fin.ext
  rw [recoveryPerm_val]
  have habv : a.val < b.val := hab
  split_ifs <;> omega

theorem recoveryPerm_between_val (a b : Fin n) (hab : a < b) (j : Fin n)
    (haj : a.val + 1 < j.val) (hjb : j ≤ b) :
    (recoveryPerm a b hab j).val = j.val - 1 := by
  rw [recoveryPerm_val]
  have hbj : j.val ≤ b.val := hjb
  split_ifs <;> omega

theorem recoveryPerm_symm_val (a b : Fin n) (hab : a < b) (j : Fin n) :
    ((recoveryPerm a b hab).symm j).val =
      if j.val ≤ a.val ∨ b.val < j.val then j.val
      else if j = b then a.val + 1 else j.val + 1 := by
  have h := recoveryPerm_val a b hab ((recoveryPerm a b hab).symm j)
  simp only [Equiv.apply_symm_apply] at h
  have habv : a.val < b.val := hab
  have hjb : j = b ↔ j.val = b.val := Fin.ext_iff
  split_ifs at h ⊢ <;> omega

theorem recoveryPerm_adjacent (a b : Fin n) (hab : a < b) (hadj : b.val = a.val + 1) :
    recoveryPerm a b hab = Equiv.refl _ := by
  ext j
  rw [recoveryPerm_val]
  change (if j.val ≤ a.val ∨ b.val < j.val then j.val
    else if j.val = a.val + 1 then b.val else j.val - 1) = j.val
  split_ifs <;> omega

end PerfectFunctionalRepresentations.MatrixOperations

