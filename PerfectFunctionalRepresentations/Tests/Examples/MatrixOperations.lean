import PerfectFunctionalRepresentations.Matrix.Operations
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Parametric Examples 2-5 from ISIT Section III-A

R14 checks all entries of Equations (11)-(15), with the source-side hypothesis
`0 < beta < 1` needed for all five source columns to be active. Paper labels
become zero-based indices. The designated extended version 16 supplies the
full source range for merges, including the final column in Example 3.
Fixtures are private; no stable example API or later preservation result is claimed.
-/

namespace PerfectFunctionalRepresentations.MatrixOperations
open scoped BigOperators ENNReal
noncomputable section

private def eq11 (b : ℝ) : Matrix (Fin 3) (Fin 5) ℝ :=
  ![![1 - b, b, 0, 0, 0], ![0, b, 1 - b, 0, 0], ![1 - b, 0, 0, b / 2, b / 2]]

private def eq12 (b : ℝ) : Matrix (Fin 3) (Fin 6) ℝ :=
  ![![1 - b, b / 2, b / 2, 0, 0, 0], ![0, b / 2, b / 2, 1 - b, 0, 0],
    ![1 - b, 0, 0, 0, b / 2, b / 2]]

private def eq13 (b : ℝ) : Matrix (Fin 3) (Fin 4) ℝ :=
  ![![1 - b, b, 0, 0], ![0, b, 1 - b, 0], ![1 - b, 0, 0, b]]

private def eq14 (b : ℝ) : Matrix (Fin 3) (Fin 6) ℝ :=
  ![![1 - b, 0, b, 0, 0, 0], ![0, 0, b, 1 - b, 0, 0],
    ![0, 1 - b, 0, 0, b / 2, b / 2]]

private def eq15 (b : ℝ) : Matrix (Fin 3) (Fin 4) ℝ :=
  ![![1 - b, b, 0, 0], ![1 - b, b, 0, 0], ![1 - b, 0, b / 2, b / 2]]

private theorem eq11_nonneg (b : ℝ) (h0 : 0 ≤ b) (h1 : b ≤ 1) (x : Fin 3) (j : Fin 5) :
    0 ≤ eq11 b x j := by
  fin_cases x <;> fin_cases j <;> simp [eq11] <;> linarith

private theorem eq11_sum (b : ℝ) (x : Fin 3) : ∑ j, eq11 b x j = 1 := by
  fin_cases x <;> simp [eq11, Fin.sum_univ_succ]

private def eq11Channel (b : ℝ) (h0 : 0 ≤ b) (h1 : b ≤ 1) : Fin 3 → PMF (Fin 5) :=
  channelOfRealMatrix (eq11 b) (eq11_nonneg b h0 h1) (eq11_sum b)

private abbrev exampleSource (b : ℝ) (h0 : 0 < b) (h1 : b < 1) :
    ActiveFiniteChannel (Fin 3) where
  outputCard := 5
  outputCard_pos := by decide
  channel := eq11Channel b h0.le h1.le
  output_active := by
    intro j
    fin_cases j
    · refine ⟨0, ?_⟩
      change ENNReal.ofReal (1 - b) ≠ 0
      exact ne_of_gt (ENNReal.ofReal_pos.mpr (by linarith))
    · refine ⟨0, ?_⟩
      change ENNReal.ofReal b ≠ 0
      exact ne_of_gt (ENNReal.ofReal_pos.mpr h0)
    · refine ⟨1, ?_⟩
      change ENNReal.ofReal (1 - b) ≠ 0
      exact ne_of_gt (ENNReal.ofReal_pos.mpr (by linarith))
    · refine ⟨2, ?_⟩
      change ENNReal.ofReal (b / 2) ≠ 0
      exact ne_of_gt (ENNReal.ofReal_pos.mpr (by linarith))
    · refine ⟨2, ?_⟩
      change ENNReal.ofReal (b / 2) ≠ 0
      exact ne_of_gt (ENNReal.ofReal_pos.mpr (by linarith))

private theorem exampleSource_singular (b : ℝ) (h0 : 0 < b) (h1 : b < 1) :
    IsSingularChannel (exampleSource b h0 h1).channel := by
  intro x z j hx hz
  change ENNReal.ofReal (eq11 b x j) = ENNReal.ofReal (eq11 b z j)
  change ENNReal.ofReal (eq11 b x j) ≠ 0 at hx
  change ENNReal.ofReal (eq11 b z j) ≠ 0 at hz
  fin_cases x <;> fin_cases z <;> fin_cases j <;> simp_all [eq11]

private theorem exampleSource_real (b : ℝ) (h0 : 0 < b) (h1 : b < 1) :
    realMatrix (exampleSource b h0 h1).channel = eq11 b :=
  realMatrix_channelOfRealMatrix (eq11 b) (eq11_nonneg b h0.le h1.le) (eq11_sum b)

private theorem exampleSource_real_apply (b : ℝ) (h0 : 0 < b) (h1 : b < 1)
    (x : Fin 3) (j : Fin 5) : realMatrix (exampleSource b h0 h1).channel x j = eq11 b x j :=
  congrFun (congrFun (exampleSource_real b h0 h1) x) j

private theorem exampleSource_pattern34 (b : ℝ) (h0 : 0 < b) (h1 : b < 1) (x : Fin 3) :
    (exampleSource b h0 h1).channel x 3 ≠ 0 ↔ (exampleSource b h0 h1).channel x 4 ≠ 0 := by
  change ENNReal.ofReal (eq11 b x 3) ≠ 0 ↔ ENNReal.ofReal (eq11 b x 4) ≠ 0
  fin_cases x <;> rfl

private def exampleMask : Fin 3 → Bool := ![true, true, false]

private theorem exampleSource_left (b : ℝ) (h0 : 0 < b) (h1 : b < 1) :
    ∃ x, (exampleSource b h0 h1).channel x 0 ≠ 0 ∧ exampleMask x = true := by
  refine ⟨0, ?_, rfl⟩
  change ENNReal.ofReal (1 - b) ≠ 0
  exact ne_of_gt (ENNReal.ofReal_pos.mpr (by linarith))

private theorem exampleSource_right (b : ℝ) (h0 : 0 < b) (h1 : b < 1) :
    ∃ x, (exampleSource b h0 h1).channel x 0 ≠ 0 ∧ exampleMask x = false := by
  refine ⟨2, ?_, rfl⟩
  change ENNReal.ofReal (1 - b) ≠ 0
  exact ne_of_gt (ENNReal.ofReal_pos.mpr (by linarith))

private theorem exampleSource_value0 (b : ℝ) (h0 : 0 < b) (h1 : b < 1) :
    columnValue (exampleSource b h0 h1).channel (exampleSource_singular b h0 h1)
      ((exampleSource b h0 h1).activeEquiv 0) = ENNReal.ofReal (1 - b) := by
  rw [columnValue_eq_of_ne_zero _ _ _ (x := 0) (by
    change ENNReal.ofReal (1 - b) ≠ 0
    exact ne_of_gt (ENNReal.ofReal_pos.mpr (by linarith)))]
  rfl

private theorem exampleSource_values02 (b : ℝ) (h0 : 0 < b) (h1 : b < 1) :
    columnValue (exampleSource b h0 h1).channel (exampleSource_singular b h0 h1)
        ((exampleSource b h0 h1).activeEquiv 0) =
      columnValue (exampleSource b h0 h1).channel (exampleSource_singular b h0 h1)
        ((exampleSource b h0 h1).activeEquiv 2) := by
  rw [exampleSource_value0, columnValue_eq_of_ne_zero _ _ _ (x := 1) (by
    change ENNReal.ofReal (1 - b) ≠ 0
    exact ne_of_gt (ENNReal.ofReal_pos.mpr (by linarith)))]
  rfl

private theorem exampleSource_disjoint02 (b : ℝ) (h0 : 0 < b) (h1 : b < 1)
    (x : Fin 3) (hx : (exampleSource b h0 h1).channel x 0 ≠ 0) :
    (exampleSource b h0 h1).channel x 2 = 0 := by
  change ENNReal.ofReal (eq11 b x 0) ≠ 0 at hx
  change ENNReal.ofReal (eq11 b x 2) = 0
  fin_cases x <;> simp_all [eq11]

private abbrev example2 (b : ℝ) (h0 : 0 < b) (h1 : b < 1) :=
  pps (exampleSource b h0 h1) (exampleSource_singular b h0 h1) (1 : Fin 5) (1 / 2)
    (by change (0 : ℝ) < 1 / 2; norm_num) (by change (1 / 2 : ℝ) < 1; norm_num)

private abbrev example3 (b : ℝ) (h0 : 0 < b) (h1 : b < 1) :=
  ppm (exampleSource b h0 h1) (exampleSource_singular b h0 h1) (3 : Fin 5) 4
    (by change (3 : Fin 5) < 4; decide)
    (exampleSource_pattern34 b h0 h1)

private abbrev example4 (b : ℝ) (h0 : 0 < b) (h1 : b < 1) :=
  vps (exampleSource b h0 h1) (exampleSource_singular b h0 h1) (0 : Fin 5) exampleMask
    (exampleSource_left b h0 h1) (exampleSource_right b h0 h1)

private abbrev example5 (b : ℝ) (h0 : 0 < b) (h1 : b < 1) :=
  vpm (exampleSource b h0 h1) (exampleSource_singular b h0 h1) (0 : Fin 5) 2
    (by change (0 : Fin 5) < 2; decide)
    (exampleSource_values02 b h0 h1) (exampleSource_disjoint02 b h0 h1)

private theorem example2_real (b : ℝ) (h0 : 0 < b) (h1 : b < 1) :
    realMatrix (example2 b h0 h1).channel = eq12 b := by
  funext x j
  fin_cases j
  · change realMatrix (example2 b h0 h1).channel x (splitKeep (1 : Fin 5) 0) = eq12 b x (0 : Fin 6)
    rw [pps_real_keep _ _ _ _ _ _ _ (by change (0 : Fin 5) ≠ 1; decide), exampleSource_real_apply]
    fin_cases x
    · change (1 - b : ℝ) = (1 - b)
      ring
    · change (0 : ℝ) = (0)
      ring
    · change (1 - b : ℝ) = (1 - b)
      ring
  · change realMatrix (example2 b h0 h1).channel x (splitLeft (1 : Fin 5)) = eq12 b x (1 : Fin 6)
    rw [pps_real_left, exampleSource_real_apply]
    fin_cases x
    · change ((1 / 2) * (b) : ℝ) = (b / 2)
      ring
    · change ((1 / 2) * (b) : ℝ) = (b / 2)
      ring
    · change ((1 / 2) * (0) : ℝ) = (0)
      ring
  · change realMatrix (example2 b h0 h1).channel x (splitRight (1 : Fin 5)) = eq12 b x (2 : Fin 6)
    rw [pps_real_right, exampleSource_real_apply]
    fin_cases x
    · change ((1 - 1 / 2) * (b) : ℝ) = (b / 2)
      ring
    · change ((1 - 1 / 2) * (b) : ℝ) = (b / 2)
      ring
    · change ((1 - 1 / 2) * (0) : ℝ) = (0)
      ring
  · change realMatrix (example2 b h0 h1).channel x (splitKeep (1 : Fin 5) 2) = eq12 b x (3 : Fin 6)
    rw [pps_real_keep _ _ _ _ _ _ _ (by change (2 : Fin 5) ≠ 1; decide), exampleSource_real_apply]
    fin_cases x
    · change (0 : ℝ) = (0)
      ring
    · change (1 - b : ℝ) = (1 - b)
      ring
    · change (0 : ℝ) = (0)
      ring
  · change realMatrix (example2 b h0 h1).channel x (splitKeep (1 : Fin 5) 3) = eq12 b x (4 : Fin 6)
    rw [pps_real_keep _ _ _ _ _ _ _ (by change (3 : Fin 5) ≠ 1; decide), exampleSource_real_apply]
    fin_cases x
    · change (0 : ℝ) = (0)
      ring
    · change (0 : ℝ) = (0)
      ring
    · change (b / 2 : ℝ) = (b / 2)
      ring
  · change realMatrix (example2 b h0 h1).channel x (splitKeep (1 : Fin 5) 4) = eq12 b x (5 : Fin 6)
    rw [pps_real_keep _ _ _ _ _ _ _ (by change (4 : Fin 5) ≠ 1; decide), exampleSource_real_apply]
    fin_cases x
    · change (0 : ℝ) = (0)
      ring
    · change (0 : ℝ) = (0)
      ring
    · change (b / 2 : ℝ) = (b / 2)
      ring

private theorem example4_real (b : ℝ) (h0 : 0 < b) (h1 : b < 1) :
    realMatrix (example4 b h0 h1).channel = eq14 b := by
  funext x j
  fin_cases j
  · change realMatrix (example4 b h0 h1).channel x (splitLeft (0 : Fin 5)) = eq14 b x (0 : Fin 6)
    rw [vps_real_left, exampleSource_real_apply]
    fin_cases x
    · change (1 - b : ℝ) = (1 - b)
      ring
    · change (0 : ℝ) = (0)
      ring
    · change (0 : ℝ) = (0)
      ring
  · change realMatrix (example4 b h0 h1).channel x (splitRight (0 : Fin 5)) = eq14 b x (1 : Fin 6)
    rw [vps_real_right, exampleSource_real_apply]
    fin_cases x
    · change (0 : ℝ) = (0)
      ring
    · change (0 : ℝ) = (0)
      ring
    · change (1 - b : ℝ) = (1 - b)
      ring
  · change realMatrix (example4 b h0 h1).channel x (splitKeep (0 : Fin 5) 1) = eq14 b x (2 : Fin 6)
    rw [vps_real_keep _ _ _ _ _ _ _ (by change (1 : Fin 5) ≠ 0; decide), exampleSource_real_apply]
    fin_cases x
    · change (b : ℝ) = (b)
      ring
    · change (b : ℝ) = (b)
      ring
    · change (0 : ℝ) = (0)
      ring
  · change realMatrix (example4 b h0 h1).channel x (splitKeep (0 : Fin 5) 2) = eq14 b x (3 : Fin 6)
    rw [vps_real_keep _ _ _ _ _ _ _ (by change (2 : Fin 5) ≠ 0; decide), exampleSource_real_apply]
    fin_cases x
    · change (0 : ℝ) = (0)
      ring
    · change (1 - b : ℝ) = (1 - b)
      ring
    · change (0 : ℝ) = (0)
      ring
  · change realMatrix (example4 b h0 h1).channel x (splitKeep (0 : Fin 5) 3) = eq14 b x (4 : Fin 6)
    rw [vps_real_keep _ _ _ _ _ _ _ (by change (3 : Fin 5) ≠ 0; decide), exampleSource_real_apply]
    fin_cases x
    · change (0 : ℝ) = (0)
      ring
    · change (0 : ℝ) = (0)
      ring
    · change (b / 2 : ℝ) = (b / 2)
      ring
  · change realMatrix (example4 b h0 h1).channel x (splitKeep (0 : Fin 5) 4) = eq14 b x (5 : Fin 6)
    rw [vps_real_keep _ _ _ _ _ _ _ (by change (4 : Fin 5) ≠ 0; decide), exampleSource_real_apply]
    fin_cases x
    · change (0 : ℝ) = (0)
      ring
    · change (0 : ℝ) = (0)
      ring
    · change (b / 2 : ℝ) = (b / 2)
      ring

private theorem example3_survivor (b : ℝ) (h0 : 0 < b) (h1 : b < 1) :
    activeMergeSurvivor (exampleSource b h0 h1) 3 4
      (by change (3 : Fin 5) < 4; decide) = (3 : Fin 4) := by
  apply Fin.ext
  exact activeMergeSurvivor_val _ _ _ _

private theorem example3_real (b : ℝ) (h0 : 0 < b) (h1 : b < 1) :
    realMatrix (example3 b h0 h1).channel = eq13 b := by
  funext x j
  fin_cases j
  · change realMatrix (example3 b h0 h1).channel x (0 : Fin 4) = eq13 b x 0
    rw [ppm_real_unaffected _ _ _ _ _ _ x
      (by rw [example3_survivor]; change (0 : Fin 4) ≠ 3; decide)]
    change realMatrix (exampleSource b h0 h1).channel x (0 : Fin 5) = _
    rw [exampleSource_real_apply]
    fin_cases x
    · change (1 - b : ℝ) = (1 - b)
      ring
    · change (0 : ℝ) = (0)
      ring
    · change (1 - b : ℝ) = (1 - b)
      ring
  · change realMatrix (example3 b h0 h1).channel x (1 : Fin 4) = eq13 b x 1
    rw [ppm_real_unaffected _ _ _ _ _ _ x
      (by rw [example3_survivor]; change (1 : Fin 4) ≠ 3; decide)]
    change realMatrix (exampleSource b h0 h1).channel x (1 : Fin 5) = _
    rw [exampleSource_real_apply]
    fin_cases x
    · change (b : ℝ) = (b)
      ring
    · change (b : ℝ) = (b)
      ring
    · change (0 : ℝ) = (0)
      ring
  · change realMatrix (example3 b h0 h1).channel x (2 : Fin 4) = eq13 b x 2
    rw [ppm_real_unaffected _ _ _ _ _ _ x
      (by rw [example3_survivor]; change (2 : Fin 4) ≠ 3; decide)]
    change realMatrix (exampleSource b h0 h1).channel x (2 : Fin 5) = _
    rw [exampleSource_real_apply]
    fin_cases x
    · change (0 : ℝ) = (0)
      ring
    · change (1 - b : ℝ) = (1 - b)
      ring
    · change (0 : ℝ) = (0)
      ring
  · change realMatrix (example3 b h0 h1).channel x (3 : Fin 4) = eq13 b x 3
    conv_lhs => rw [← example3_survivor b h0 h1]
    rw [ppm_real_survivor,
      exampleSource_real_apply, exampleSource_real_apply]
    fin_cases x
    · change ((0) + (0) : ℝ) = (0)
      ring
    · change ((0) + (0) : ℝ) = (0)
      ring
    · change ((b / 2) + (b / 2) : ℝ) = (b)
      ring

private theorem example5_survivor (b : ℝ) (h0 : 0 < b) (h1 : b < 1) :
    activeMergeSurvivor (exampleSource b h0 h1) 0 2
      (by change (0 : Fin 5) < 2; decide) = (0 : Fin 4) := by
  apply Fin.ext
  exact activeMergeSurvivor_val _ _ _ _

private theorem example5_real (b : ℝ) (h0 : 0 < b) (h1 : b < 1) :
    realMatrix (example5 b h0 h1).channel = eq15 b := by
  funext x j
  fin_cases j
  · change realMatrix (example5 b h0 h1).channel x (0 : Fin 4) = eq15 b x 0
    conv_lhs => rw [← example5_survivor b h0 h1]
    rw [vpm_real_survivor,
      exampleSource_real_apply, exampleSource_real_apply]
    fin_cases x
    · change ((1 - b) + (0) : ℝ) = (1 - b)
      ring
    · change ((0) + (1 - b) : ℝ) = (1 - b)
      ring
    · change ((1 - b) + (0) : ℝ) = (1 - b)
      ring
  · change realMatrix (example5 b h0 h1).channel x (1 : Fin 4) = eq15 b x 1
    rw [vpm_real_unaffected _ _ _ _ _ _ _ x
      (by rw [example5_survivor]; change (1 : Fin 4) ≠ 0; decide)]
    change realMatrix (exampleSource b h0 h1).channel x (1 : Fin 5) = _
    rw [exampleSource_real_apply]
    fin_cases x
    · change (b : ℝ) = (b)
      ring
    · change (b : ℝ) = (b)
      ring
    · change (0 : ℝ) = (0)
      ring
  · change realMatrix (example5 b h0 h1).channel x (2 : Fin 4) = eq15 b x 2
    rw [vpm_real_unaffected _ _ _ _ _ _ _ x
      (by rw [example5_survivor]; change (2 : Fin 4) ≠ 0; decide)]
    change realMatrix (exampleSource b h0 h1).channel x (3 : Fin 5) = _
    rw [exampleSource_real_apply]
    fin_cases x
    · change (0 : ℝ) = (0)
      ring
    · change (0 : ℝ) = (0)
      ring
    · change (b / 2 : ℝ) = (b / 2)
      ring
  · change realMatrix (example5 b h0 h1).channel x (3 : Fin 4) = eq15 b x 3
    rw [vpm_real_unaffected _ _ _ _ _ _ _ x
      (by rw [example5_survivor]; change (3 : Fin 4) ≠ 0; decide)]
    change realMatrix (exampleSource b h0 h1).channel x (4 : Fin 5) = _
    rw [exampleSource_real_apply]
    fin_cases x
    · change (0 : ℝ) = (0)
      ring
    · change (0 : ℝ) = (0)
      ring
    · change (b / 2 : ℝ) = (b / 2)
      ring

end
end PerfectFunctionalRepresentations.MatrixOperations
namespace PerfectFunctionalRepresentations.MatrixOperations
open scoped BigOperators ENNReal
noncomputable section

private theorem entry_from_real {n : ℕ} (K : Fin 3 → PMF (Fin n))
    (A : Matrix (Fin 3) (Fin n) ℝ) (h : realMatrix K = A) (x : Fin 3) (j : Fin n) :
    K x j = ENNReal.ofReal (A x j) := by
  have he := ofReal_realMatrix K x j
  rw [h] at he
  exact he.symm

variable (b : ℝ) (h0 : 0 < b) (h1 : b < 1)

-- Whole Real matrices, not selected entries alone.
example : realMatrix (exampleSource b h0 h1).channel = eq11 b := exampleSource_real b h0 h1
example : realMatrix (example2 b h0 h1).channel = eq12 b := example2_real b h0 h1
example : realMatrix (example3 b h0 h1).channel = eq13 b := example3_real b h0 h1
example : realMatrix (example4 b h0 h1).channel = eq14 b := example4_real b h0 h1
example : realMatrix (example5 b h0 h1).channel = eq15 b := example5_real b h0 h1

-- Exact ENNReal bridges cover every row and every output in all five displays.
example (x : Fin 3) (j : Fin 5) :
    (exampleSource b h0 h1).channel x j = ENNReal.ofReal (eq11 b x j) :=
  entry_from_real _ _ (exampleSource_real b h0 h1) x j
example (x : Fin 3) (j : Fin 6) :
    (example2 b h0 h1).channel x j = ENNReal.ofReal (eq12 b x j) :=
  entry_from_real _ _ (example2_real b h0 h1) x j
example (x : Fin 3) (j : Fin 4) :
    (example3 b h0 h1).channel x j = ENNReal.ofReal (eq13 b x j) :=
  entry_from_real _ _ (example3_real b h0 h1) x j
example (x : Fin 3) (j : Fin 6) :
    (example4 b h0 h1).channel x j = ENNReal.ofReal (eq14 b x j) :=
  entry_from_real _ _ (example4_real b h0 h1) x j
example (x : Fin 3) (j : Fin 4) :
    (example5 b h0 h1).channel x j = ENNReal.ofReal (eq15 b x j) :=
  entry_from_real _ _ (example5_real b h0 h1) x j

example : (exampleSource b h0 h1).outputCard = 5 ∧
    (example2 b h0 h1).outputCard = 6 ∧ (example3 b h0 h1).outputCard = 4 ∧
    (example4 b h0 h1).outputCard = 6 ∧ (example5 b h0 h1).outputCard = 4 :=
  ⟨rfl, rfl, rfl, rfl, rfl⟩

-- The printed operations' exact legality witnesses, including source index 4.
example : 0 < (1 / 2 : NNReal) ∧ (1 / 2 : NNReal) < 1 := by norm_num
example (x : Fin 3) : (exampleSource b h0 h1).channel x 3 ≠ 0 ↔
    (exampleSource b h0 h1).channel x 4 ≠ 0 := exampleSource_pattern34 b h0 h1 x
example : (∃ x, (exampleSource b h0 h1).channel x 0 ≠ 0 ∧ exampleMask x = true) ∧
    (∃ x, (exampleSource b h0 h1).channel x 0 ≠ 0 ∧ exampleMask x = false) :=
  ⟨exampleSource_left b h0 h1, exampleSource_right b h0 h1⟩
example : columnValue (exampleSource b h0 h1).channel (exampleSource_singular b h0 h1)
      ((exampleSource b h0 h1).activeEquiv 0) =
    columnValue (exampleSource b h0 h1).channel (exampleSource_singular b h0 h1)
      ((exampleSource b h0 h1).activeEquiv 2) := exampleSource_values02 b h0 h1
example (x : Fin 3) (hx : (exampleSource b h0 h1).channel x 0 ≠ 0) :
    (exampleSource b h0 h1).channel x 2 = 0 := exampleSource_disjoint02 b h0 h1 x hx

-- Activity is checked for every output, alongside singularity and both row sums.
example : (∀ j, ∃ x, (exampleSource b h0 h1).channel x j ≠ 0) ∧
    IsSingularChannel (exampleSource b h0 h1).channel :=
  ⟨(exampleSource b h0 h1).output_active, exampleSource_singular b h0 h1⟩
example : (∀ j, ∃ x, (example2 b h0 h1).channel x j ≠ 0) ∧
    IsSingularChannel (example2 b h0 h1).channel :=
  ⟨(example2 b h0 h1).output_active, pps_isSingular _ _ _ _ _ _⟩
example : (∀ j, ∃ x, (example3 b h0 h1).channel x j ≠ 0) ∧
    IsSingularChannel (example3 b h0 h1).channel :=
  ⟨(example3 b h0 h1).output_active, ppm_isSingular _ _ _ _ _ _⟩
example : (∀ j, ∃ x, (example4 b h0 h1).channel x j ≠ 0) ∧
    IsSingularChannel (example4 b h0 h1).channel :=
  ⟨(example4 b h0 h1).output_active, vps_isSingular _ _ _ _ _ _⟩
example : (∀ j, ∃ x, (example5 b h0 h1).channel x j ≠ 0) ∧
    IsSingularChannel (example5 b h0 h1).channel :=
  ⟨(example5 b h0 h1).output_active, vpm_isSingular _ _ _ _ _ _ _⟩

example (x : Fin 3) : (∑ j, (exampleSource b h0 h1).channel x j) = 1 ∧
    (∑ j, realMatrix (exampleSource b h0 h1).channel x j) = 1 :=
  ⟨massMatrix_row_sum (exampleSource b h0 h1).channel x, realMatrix_row_sum _ _⟩
example (x : Fin 3) : (∑ j, (example2 b h0 h1).channel x j) = 1 ∧
    (∑ j, realMatrix (example2 b h0 h1).channel x j) = 1 :=
  ⟨pps_row_sum _ _ _ _ _ _ x, pps_real_row_sum _ _ _ _ _ _ x⟩
example (x : Fin 3) : (∑ j, (example3 b h0 h1).channel x j) = 1 ∧
    (∑ j, realMatrix (example3 b h0 h1).channel x j) = 1 :=
  ⟨ppm_row_sum _ _ _ _ _ _ x, ppm_real_row_sum _ _ _ _ _ _ x⟩
example (x : Fin 3) : (∑ j, (example4 b h0 h1).channel x j) = 1 ∧
    (∑ j, realMatrix (example4 b h0 h1).channel x j) = 1 :=
  ⟨vps_row_sum _ _ _ _ _ _ x, vps_real_row_sum _ _ _ _ _ _ x⟩
example (x : Fin 3) : (∑ j, (example5 b h0 h1).channel x j) = 1 ∧
    (∑ j, realMatrix (example5 b h0 h1).channel x j) = 1 :=
  ⟨vpm_row_sum _ _ _ _ _ _ _ x, vpm_real_row_sum _ _ _ _ _ _ _ x⟩

-- The endpoints are valid ambient matrices but not active-suite source instances.
example : ¬ ∀ j : Fin 5, ∃ x : Fin 3,
    eq11Channel 0 (by norm_num) (by norm_num) x j ≠ 0 := by
  intro h
  obtain ⟨x, hx⟩ := h 1
  change ENNReal.ofReal (eq11 0 x 1) ≠ 0 at hx
  fin_cases x <;> norm_num [eq11] at hx

example : ¬ ∀ j : Fin 5, ∃ x : Fin 3,
    eq11Channel 1 (by norm_num) (by norm_num) x j ≠ 0 := by
  intro h
  obtain ⟨x, hx⟩ := h 0
  change ENNReal.ofReal (eq11 1 x 0) ≠ 0 at hx
  fin_cases x <;> norm_num [eq11] at hx

end
end PerfectFunctionalRepresentations.MatrixOperations
