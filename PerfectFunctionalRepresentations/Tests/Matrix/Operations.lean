import PerfectFunctionalRepresentations.Matrix.Operations
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.FinCases

/-!
# C07 operation regressions

S01 owns R01-R03: ordered boundary indices and fibers, the direction of a
non-involutive permutation, semantic kernels/maps, exact/Real coordinates and
normalization, unrestricted input types and the singleton-output boundary.
S02 owns R04-R08: legal PP closure/data, witnessed recovery, the value-one
boundary and the asymmetric permutation fixture.
S03 owns R09-R13: value-one VP closure, support and indicator boundaries, mask
irrelevance, rejected weaker legality conditions and both legal recovery directions.
S04 owns R15: generic public constructor, kernel/map and witnessed-recovery
consumers, including C06 relabeling on actual recovered endpoints. R14 paper
fixtures live in Tests.Examples.MatrixOperations; R16 checks imports and prerequisites.
-/

namespace PerfectFunctionalRepresentations.MatrixOperations

open scoped BigOperators ENNReal

universe u

noncomputable section

-- R01: the first and last selected positions insert an adjacent right child.
example : splitLeft (0 : Fin 3) = 0 ∧ splitRight (0 : Fin 3) = 1 ∧
    splitKeep (0 : Fin 3) 1 = 2 ∧ splitKeep (0 : Fin 3) 2 = 3 := by decide

example : splitLeft (2 : Fin 3) = 2 ∧ splitRight (2 : Fin 3) = 3 ∧
    splitKeep (2 : Fin 3) 0 = 0 ∧ splitKeep (2 : Fin 3) 1 = 1 := by decide

-- Adjacent, separated and final-column fibers use the same collapse map.
example (j : Fin 4) : mergeIndex 1 2 (by decide) j = mergeSurvivor 1 2 (by decide) ↔
    j = 1 ∨ j = 2 := mergeIndex_fiber_survivor _ _ _ _

example (j : Fin 5) : mergeIndex 0 3 (by decide) j = mergeSurvivor 0 3 (by decide) ↔
    j = 0 ∨ j = 3 := mergeIndex_fiber_survivor _ _ _ _

example (j : Fin 4) : mergeIndex 0 3 (by decide) j = mergeSurvivor 0 3 (by decide) ↔
    j = 0 ∨ j = 3 := mergeIndex_fiber_survivor _ _ _ _

example : (mergeIndex (0 : Fin 5) 3 (by decide) 4).val = 3 :=
  mergeIndex_val_of_gt _ _ _ _ (by decide)

example (j : Fin 4) : mergeIndex 0 3 (by decide) j = (1 : Fin 3) ↔ j = 1 := by
  have h : (1 : Fin 3) ≠ mergeSurvivor 0 3 (by decide) := by
    intro h
    have := congrArg Fin.val h
    norm_num at this
  simpa [Fin.succAbove] using mergeIndex_fiber_ne 0 3 (by decide) 1 h j

-- The moved three-cycle has opposite forward and inverse images at label 1.
example : (recoveryPerm (0 : Fin 4) 3 (by decide) 1).val = 3 ∧
    ((recoveryPerm (0 : Fin 4) 3 (by decide)).symm 1).val = 2 := by
  constructor
  · norm_num [recoveryPerm_val]
  · norm_num [recoveryPerm_symm_val, show (1 : Fin 4) ≠ 3 by decide]

example : recoveryPerm (0 : Fin 4) 3 (by decide) ≠
    (recoveryPerm (0 : Fin 4) 3 (by decide)).symm := by
  intro h
  have he := congrArg (fun e : Fin 4 ≃ Fin 4 => (e 1).val) h
  norm_num [recoveryPerm_val, recoveryPerm_symm_val, show (1 : Fin 4) ≠ 3 by decide] at he

example : recoveryPerm (1 : Fin 4) 2 (by decide) = Equiv.refl _ :=
  recoveryPerm_adjacent _ _ _ (by decide)

example {n : Nat} (l : Fin n) (j : Fin (n + 1)) :
    j = splitRight l ∨ ∃ k, j = splitKeep l k := split_cases _ _

-- R02: alpha has no typeclass assumptions; all semantic and coordinate APIs
-- can be consumed without a singularity, activity or finite-input witness.
section General

variable {alpha : Type u} {n m : Nat}
variable (K : alpha → PMF (Fin n)) (l : Fin n) (t : NNReal) (ht : t ≤ 1)
variable (mask : alpha → Bool) (x : alpha) (j : Fin n) (hj : j ≠ l)

example : ppsKernel l t ht l =
    PMF.binaryMixture t ht (PMF.pure (splitLeft l)) (PMF.pure (splitRight l)) :=
  ppsKernel_selected _ _ _

example : ppsKernel l t ht j = PMF.pure (splitKeep l j) :=
  ppsKernel_unaffected _ _ _ hj

example : ppsRaw K l t ht x = (K x).bind (ppsKernel l t ht) :=
  ppsRaw_apply_bind _ _ _ _ _

example : ppsRaw K l t ht x (splitLeft l) = (t : ENNReal) * K x l ∧
    ppsRaw K l t ht x (splitRight l) = ((1 - t : NNReal) : ENNReal) * K x l ∧
    ppsRaw K l t ht x (splitKeep l j) = K x j :=
  ⟨ppsRaw_left _ _ _ _ _, ppsRaw_right _ _ _ _ _, ppsRaw_keep _ _ _ _ _ hj⟩

example : realMatrix (ppsRaw K l t ht) x (splitLeft l) = (t : ℝ) * realMatrix K x l ∧
    realMatrix (ppsRaw K l t ht) x (splitRight l) = (1 - (t : ℝ)) * realMatrix K x l ∧
    realMatrix (ppsRaw K l t ht) x (splitKeep l j) = realMatrix K x j :=
  ⟨ppsRaw_real_left _ _ _ _ _, ppsRaw_real_right _ _ _ _ _,
    ppsRaw_real_keep _ _ _ _ _ hj⟩

example : ∑ y, ppsRaw K l t ht x y = 1 := ppsRaw_row_sum _ _ _ _ _
example : ∑ y, realMatrix (ppsRaw K l t ht) x y = 1 := ppsRaw_real_row_sum _ _ _ _ _

example : vpsRaw K l mask x = (K x).map (vpsIndex l (mask x)) :=
  vpsRaw_apply_map _ _ _ _

example : vpsIndex l (mask x) l = if mask x then splitLeft l else splitRight l :=
  vpsIndex_selected _ _

example : vpsRaw K l mask x (splitLeft l) = (if mask x then K x l else 0) ∧
    vpsRaw K l mask x (splitRight l) = (if mask x then 0 else K x l) ∧
    vpsRaw K l mask x (splitKeep l j) = K x j :=
  ⟨vpsRaw_left _ _ _ _, vpsRaw_right _ _ _ _, vpsRaw_keep _ _ _ _ hj⟩

example : realMatrix (vpsRaw K l mask) x (splitLeft l) =
      (if mask x then realMatrix K x l else 0) ∧
    realMatrix (vpsRaw K l mask) x (splitRight l) =
      (if mask x then 0 else realMatrix K x l) ∧
    realMatrix (vpsRaw K l mask) x (splitKeep l j) = realMatrix K x j :=
  ⟨vpsRaw_real_left _ _ _ _, vpsRaw_real_right _ _ _ _, vpsRaw_real_keep _ _ _ _ hj⟩

example : ∑ y, vpsRaw K l mask x y = 1 := vpsRaw_row_sum _ _ _ _
example : ∑ y, realMatrix (vpsRaw K l mask) x y = 1 := vpsRaw_real_row_sum _ _ _ _

variable (M : alpha → PMF (Fin (m + 1))) (a b : Fin (m + 1)) (hab : a < b)

example : mergeRaw M a b hab x = (M x).map (mergeIndex a b hab) :=
  mergeRaw_apply_map _ _ _ _ _

example : mergeRaw M a b hab x (mergeSurvivor a b hab) = M x a + M x b :=
  mergeRaw_survivor _ _ _ _ _

example (k : Fin m) (hk : k ≠ mergeSurvivor a b hab) :
    mergeRaw M a b hab x k = M x (b.succAbove k) := mergeRaw_unaffected _ _ _ _ _ hk

example : realMatrix (mergeRaw M a b hab) x (mergeSurvivor a b hab) =
    realMatrix M x a + realMatrix M x b := mergeRaw_real_survivor _ _ _ _ _

example (k : Fin m) (hk : k ≠ mergeSurvivor a b hab) :
    realMatrix (mergeRaw M a b hab) x k = realMatrix M x (b.succAbove k) :=
  mergeRaw_real_unaffected _ _ _ _ _ hk

example : ∑ y, mergeRaw M a b hab x y = 1 := mergeRaw_row_sum _ _ _ _ _
example : ∑ y, realMatrix (mergeRaw M a b hab) x y = 1 := mergeRaw_real_row_sum _ _ _ _ _

end General

-- Explicit empty and infinite input instantiations guard the raw boundary.
example (K : Empty → PMF (Fin 1)) : Empty → PMF (Fin 2) := ppsRaw K 0 0 (by simp)
example (K : Empty → PMF (Fin 1)) : Empty → PMF (Fin 2) := vpsRaw K 0 (fun _ => false)
example (K : Empty → PMF (Fin 2)) : Empty → PMF (Fin 1) := mergeRaw K 0 1 (by decide)
example (K : Nat → PMF (Fin 1)) (x : Nat) : ∑ y, ppsRaw K 0 1 (by simp) x y = 1 :=
  ppsRaw_row_sum _ _ _ _ _

-- R03: a one-column channel splits into two columns even at raw endpoints.
example (K : Unit → PMF (Fin 1)) : ppsRaw K 0 0 (by simp) () (splitLeft 0) = 0 := by
  simp [ppsRaw_left]

example (K : Unit → PMF (Fin 1)) : ppsRaw K 0 1 (by simp) () (splitRight 0) = 0 := by
  simp [ppsRaw_right]

example (K : Unit → PMF (Fin 1)) :
    vpsRaw K 0 (fun _ => true) () (splitRight 0) = 0 := by simp [vpsRaw_right]

example : ¬ ∃ a b : Fin 1, a < b := by decide

-- The actual-to-advertised equivalence has an explicit inverse coordinate.
example {k n : Nat} (hcard : k = n) (j : Fin n) :
    (finCongr hcard).symm j = Fin.cast hcard.symm j := rfl

example {k n : Nat} (hcard : k = n) (a b : Fin n) (hab : a < b) (j : Fin n) :
    ((finCongr hcard).trans (recoveryPerm a b hab)).symm j =
      Fin.cast hcard.symm ((recoveryPerm a b hab).symm j) := rfl

example {alpha : Type u} {n k : Nat} (K : alpha → PMF (Fin n)) (l : Fin n)
    (t : NNReal) (ht : t ≤ 1) (hcard : n + 1 = k) (x : alpha) (j : Fin k) :
    ((ppsRaw K l t ht x).map (finCongr hcard)) j =
      ppsRaw K l t ht x (Fin.cast hcard.symm j) := by
  simpa using PMF.map_apply_of_injective (ppsRaw K l t ht x)
    (finCongr hcard).injective ((finCongr hcard).symm j)

example {alpha : Type u} {n : Nat} (K : alpha → PMF (Fin n)) (l : Fin n)
    (t : NNReal) (ht : t ≤ 1) (x : alpha) :
    ((ppsRaw K l t ht x).map (finCongr (Nat.add_comm n 1)))
      (Fin.cast (Nat.add_comm n 1) (splitRight l)) =
        ((1 - t : NNReal) : ENNReal) * K x l := by
  rw [show Fin.cast (Nat.add_comm n 1) (splitRight l) =
    finCongr (Nat.add_comm n 1) (splitRight l) from rfl,
    PMF.map_apply_of_injective _ (finCongr (Nat.add_comm n 1)).injective,
    ppsRaw_right]

end

end PerfectFunctionalRepresentations.MatrixOperations
namespace PerfectFunctionalRepresentations.MatrixOperations

open scoped BigOperators ENNReal
noncomputable section

-- R04: a value-one selected column, unequal strict ratio, and an unaffected column.
private abbrev ppsValueOneSource : ActiveFiniteChannel (Fin 2) where
  outputCard := 2
  outputCard_pos := by decide
  channel := fun x => PMF.pure x
  output_active := by intro j; exact ⟨j, by simp⟩

private theorem ppsValueOneSource_singular : IsSingularChannel ppsValueOneSource.channel := by
  intro x z j hx hz
  fin_cases x <;> fin_cases z <;> fin_cases j <;>
    simp_all [ppsValueOneSource, PMF.pure_apply]

private abbrev ppsUnequalState : ActiveFiniteChannel (Fin 2) :=
  pps ppsValueOneSource ppsValueOneSource_singular 1 (1 / 3)
    (by change (0 : ℝ) < 1 / 3; norm_num) (by change (1 / 3 : ℝ) < 1; norm_num)

local instance : NeZero ppsUnequalState.outputCard := ⟨by change 3 ≠ 0; decide⟩

private theorem ppsUnequalState_singular : IsSingularChannel ppsUnequalState.channel :=
  pps_isSingular _ _ _ _ _ _

example : columnValue ppsValueOneSource.channel ppsValueOneSource_singular
    (ppsValueOneSource.activeEquiv 1) = 1 := by
  rw [columnValue_eq_of_ne_zero _ _ _ (x := 1)
    (by change (PMF.pure (1 : Fin 2)) 1 ≠ 0; simp)]
  change (PMF.pure (1 : Fin 2)) 1 = 1
  simp

private theorem ppsUnequalState_left :
    ppsUnequalState.channel 1 1 = ((1 / 3 : NNReal) : ENNReal) := by
  change (pps ppsValueOneSource ppsValueOneSource_singular 1 (1 / 3) _ _).channel
    (1 : Fin 2) (splitLeft (1 : Fin 2)) = _
  rw [pps_left]
  simp [ppsValueOneSource]

private theorem ppsUnequalState_right :
    ppsUnequalState.channel 1 2 = ((2 / 3 : NNReal) : ENNReal) := by
  change (pps ppsValueOneSource ppsValueOneSource_singular 1 (1 / 3) _ _).channel
    (1 : Fin 2) (splitRight (1 : Fin 2)) = _
  rw [pps_right]
  simp only [ppsValueOneSource, PMF.pure_apply_self, mul_one]
  congr 1
  apply NNReal.coe_injective
  norm_num [NNReal.coe_sub_def]

example : ppsUnequalState.channel 1 1 ≠ ppsUnequalState.channel 1 2 := by
  rw [ppsUnequalState_left, ppsUnequalState_right, ne_eq, ENNReal.coe_inj]
  norm_num

example : (∃ x, ppsUnequalState.channel x 1 ≠ 0) ∧
    (∃ x, ppsUnequalState.channel x 2 ≠ 0) :=
  ⟨ppsUnequalState.output_active 1, ppsUnequalState.output_active 2⟩

example (x : Fin 2) : ppsUnequalState.channel x 0 = ppsValueOneSource.channel x 0 := by
  exact pps_keep ppsValueOneSource ppsValueOneSource_singular 1 (1 / 3) _ _ x (j := 0) (by decide)

example : columnValue ppsUnequalState.channel ppsUnequalState_singular
      (ppsUnequalState.activeEquiv 1) = ((1 / 3 : NNReal) : ENNReal) ∧
    columnValue ppsUnequalState.channel ppsUnequalState_singular
      (ppsUnequalState.activeEquiv 2) = ((2 / 3 : NNReal) : ENNReal) := by
  constructor
  · rw [columnValue_eq_of_ne_zero _ _ _ (x := 1)
      (by change ppsUnequalState.channel 1 1 ≠ 0; rw [ppsUnequalState_left]; norm_num)]
    exact ppsUnequalState_left
  · rw [columnValue_eq_of_ne_zero _ _ _ (x := 1)
      (by change ppsUnequalState.channel 1 2 ≠ 0; rw [ppsUnequalState_right]; norm_num)]
    exact ppsUnequalState_right

-- R05: repeated singleton patterns and unequal positive values sum to exactly one;
-- the second selected column is the final source column.
private theorem ppsUnequalState_patterns (x : Fin 2) :
    ppsUnequalState.channel x 1 ≠ 0 ↔ ppsUnequalState.channel x 2 ≠ 0 :=
  pps_children_sameSupport _ _ _ _ _ _ x

private abbrev ppmSumOneState : ActiveFiniteChannel (Fin 2) :=
  ppm ppsUnequalState ppsUnequalState_singular 1 2 (by decide) ppsUnequalState_patterns

example : columnPattern ppsUnequalState.channel (ppsUnequalState.activeEquiv 1) =
    columnPattern ppsUnequalState.channel (ppsUnequalState.activeEquiv 2) :=
  (same_support_iff_columnPattern_eq _ _ _).mp ppsUnequalState_patterns

example : ppmSumOneState.channel 1 (activeMergeSurvivor ppsUnequalState 1 2 (by decide)) = 1 := by
  rw [ppm_apply_survivor, ppsUnequalState_left, ppsUnequalState_right, ← ENNReal.coe_add]
  norm_num

example : ppmSumOneState.outputCard = 2 := rfl

example : columnValue ppmSumOneState.channel
      (ppm_isSingular _ _ _ _ _ _) (ppmSumOneState.activeEquiv
        (activeMergeSurvivor ppsUnequalState 1 2 (by decide))) = 1 := by
  have hm : ppmSumOneState.channel 1 (activeMergeSurvivor ppsUnequalState 1 2 (by decide)) = 1 := by
    rw [ppm_apply_survivor, ppsUnequalState_left, ppsUnequalState_right, ← ENNReal.coe_add]
    norm_num
  have hn : ppmSumOneState.channel 1 (activeMergeSurvivor ppsUnequalState 1 2 (by decide)) ≠ 0 := by
    rw [hm]
    exact one_ne_zero
  exact (columnValue_eq_of_ne_zero ppmSumOneState.channel (ppm_isSingular _ _ _ _ _ _)
    (ppmSumOneState.activeEquiv (activeMergeSurvivor ppsUnequalState 1 2 (by decide))) hn).trans hm

-- R06: the legal adjacent round trip preserves every row and remembers the
-- unequal split ratio rather than silently using one half.
example : ppmRatio ppsUnequalState ppsUnequalState_singular 1 2 = (1 / 3 : NNReal) :=
  ppmRatio_pps ppsValueOneSource ppsValueOneSource_singular 1 (1 / 3) _ _

example (x : Fin 2) :
    ((ppsRecovery ppsValueOneSource ppsValueOneSource_singular 1 (1 / 3)
      (by change (0 : ℝ) < 1 / 3; norm_num) (by change (1 / 3 : ℝ) < 1; norm_num)).channel x).map
        (finCongr (ppsRecovery_outputCard ppsValueOneSource ppsValueOneSource_singular 1 (1 / 3)
          (by change (0 : ℝ) < 1 / 3; norm_num) (by change (1 / 3 : ℝ) < 1; norm_num))) =
      ppsValueOneSource.channel x :=
  ppsRecovery_channel ppsValueOneSource ppsValueOneSource_singular 1 (1 / 3) _ _ x

example (x : Fin 2) :
    ((ppmRecovery ppsUnequalState ppsUnequalState_singular 1 2 (by decide)
      ppsUnequalState_patterns).channel x).map
        (finCongr (ppmRecovery_outputCard ppsUnequalState ppsUnequalState_singular 1 2 (by decide)
          ppsUnequalState_patterns)) = ppsUnequalState.channel x :=
  ppmRecovery_adjacent ppsUnequalState ppsUnequalState_singular 1 2 (by decide)
    ppsUnequalState_patterns (by decide) x

-- R08: endpoint weights cannot meet the active PPS domain, and their zero child
-- really is globally inactive. Unequal support rejects PPM, without a claim that
-- every raw merge of unequal patterns is nonsingular.
example : ¬ (0 < (0 : NNReal) ∧ (0 : NNReal) < 1) := by norm_num
example : ¬ (0 < (1 : NNReal) ∧ (1 : NNReal) < 1) := by norm_num

example : ¬ ∃ x, ppsRaw ppsValueOneSource.channel 1 0 (by norm_num) x (splitLeft 1) ≠ 0 := by
  simp only [ppsRaw_left, ENNReal.coe_zero, zero_mul, ne_eq,
    not_true_eq_false, exists_false, not_false_eq_true]

example : ¬ ∃ x, ppsRaw ppsValueOneSource.channel 1 1 (by norm_num) x (splitRight 1) ≠ 0 := by
  simp only [ppsRaw_right, tsub_self, ENNReal.coe_zero, zero_mul, ne_eq,
    not_true_eq_false, exists_false, not_false_eq_true]

example : ¬ ∀ x, ppsValueOneSource.channel x 0 ≠ 0 ↔ ppsValueOneSource.channel x 1 ≠ 0 := by
  intro h
  simpa [ppsValueOneSource] using h 0

example : columnPattern ppsValueOneSource.channel (ppsValueOneSource.activeEquiv 0) ≠
    columnPattern ppsValueOneSource.channel (ppsValueOneSource.activeEquiv 1) := by
  intro h
  have hp := (same_support_iff_columnPattern_eq _ _ _).mpr h
  simpa [ppsValueOneSource] using hp 0

-- R07: the prescribed non-involutive numeric fixture.
private def nonadjacentWeights : Fin 4 → NNReal := ![1 / 10, 2 / 10, 3 / 10, 4 / 10]

private theorem nonadjacentWeights_sum : ∑ j, nonadjacentWeights j = 1 := by
  norm_num [nonadjacentWeights, Fin.sum_univ_succ]

example : nonadjacentWeights 0 / (nonadjacentWeights 0 + nonadjacentWeights 3) =
    (1 / 5 : NNReal) := by
  norm_num [nonadjacentWeights, Matrix.cons_val_three]

private abbrev nonadjacentState : ActiveFiniteChannel Unit where
  outputCard := 4
  outputCard_pos := by decide
  channel := fun _ => PMF.ofFintype (fun j => (nonadjacentWeights j : ENNReal))
    (by exact_mod_cast nonadjacentWeights_sum)
  output_active := by
    intro j
    refine ⟨(), ?_⟩
    change (nonadjacentWeights j : ENNReal) ≠ 0
    rw [ENNReal.coe_ne_zero]
    fin_cases j <;> norm_num [nonadjacentWeights]

private theorem nonadjacentState_singular : IsSingularChannel nonadjacentState.channel := by
  intro x z j _ _
  rfl

private theorem nonadjacentState_patterns (x : Unit) :
    nonadjacentState.channel x 0 ≠ 0 ↔ nonadjacentState.channel x 3 ≠ 0 := by
  norm_num [nonadjacentState, nonadjacentWeights, PMF.ofFintype_apply, Matrix.cons_val_three]

private theorem nonadjacent_columnValue (j : Fin 4) :
    columnValue nonadjacentState.channel nonadjacentState_singular
        (nonadjacentState.activeEquiv j) =
      (nonadjacentWeights j : ENNReal) := by
  have hn : nonadjacentState.channel () j ≠ 0 := by
    change (nonadjacentWeights j : ENNReal) ≠ 0
    rw [ENNReal.coe_ne_zero]
    fin_cases j <;> norm_num [nonadjacentWeights]
  exact columnValue_eq_of_ne_zero _ _ _ hn

private theorem nonadjacentRatio :
    ppmRatio nonadjacentState nonadjacentState_singular 0 3 = (1 / 5 : NNReal) := by
  unfold ppmRatio
  rw [nonadjacent_columnValue, nonadjacent_columnValue, ← ENNReal.coe_add,
    ENNReal.toNNReal_coe, ENNReal.toNNReal_coe]
  norm_num [nonadjacentWeights, Matrix.cons_val_three]

example : ((ppmRecovery nonadjacentState nonadjacentState_singular 0 3 (by decide)
      nonadjacentState_patterns).channel ()).map
        (ppmRecoveryEquiv nonadjacentState nonadjacentState_singular 0 3 (by decide)
          nonadjacentState_patterns) = nonadjacentState.channel () :=
  ppmRecovery_channel nonadjacentState nonadjacentState_singular 0 3 (by decide)
    nonadjacentState_patterns ()

example : (nonadjacentState.channel ()).map
      (ppmRecoveryEquiv nonadjacentState nonadjacentState_singular 0 3 (by decide)
        nonadjacentState_patterns).symm =
    (ppmRecovery nonadjacentState nonadjacentState_singular 0 3 (by decide)
      nonadjacentState_patterns).channel () :=
  ppmRecovery_channel_inverse nonadjacentState nonadjacentState_singular 0 3 (by decide)
    nonadjacentState_patterns ()

private def nonadjacentMerged : Unit → PMF (Fin 3) :=
  mergeRaw nonadjacentState.channel 0 3 (by decide)

private theorem nonadjacentSurvivor : mergeSurvivor (0 : Fin 4) 3 (by decide) = 0 := by
  apply Fin.ext
  exact mergeSurvivor_val _ _ _

private theorem nonadjacentMerged_mass (j : Fin 3) :
    nonadjacentMerged () j = ((![1 / 2, 2 / 10, 3 / 10] j : NNReal) : ENNReal) := by
  fin_cases j
  · change mergeRaw _ _ _ _ () 0 = _
    rw [← nonadjacentSurvivor, mergeRaw_survivor]
    change (nonadjacentWeights 0 : ENNReal) + (nonadjacentWeights 3 : ENNReal) = _
    rw [← ENNReal.coe_add]
    apply congrArg (fun r : NNReal => (r : ENNReal))
    norm_num [nonadjacentWeights, Matrix.cons_val_three]
  · rw [nonadjacentMerged, mergeRaw_unaffected _ _ _ _ _ (by rw [nonadjacentSurvivor]; decide)]
    rfl
  · rw [nonadjacentMerged, mergeRaw_unaffected _ _ _ _ _ (by rw [nonadjacentSurvivor]; decide)]
    rfl

private abbrev nonadjacentLegalMerge : ActiveFiniteChannel Unit :=
  ppm nonadjacentState nonadjacentState_singular 0 3 (by decide) nonadjacentState_patterns

example : nonadjacentLegalMerge.channel ()
    (activeMergeSurvivor nonadjacentState 0 3 (by decide)) = ((1 / 2 : NNReal) : ENNReal) := by
  rw [ppm_apply_survivor]
  change (nonadjacentWeights 0 : ENNReal) + (nonadjacentWeights 3 : ENNReal) = _
  rw [← ENNReal.coe_add]
  apply congrArg (fun r : NNReal => (r : ENNReal))
  norm_num [nonadjacentWeights, Matrix.cons_val_three]

private theorem nonadjacentLegalMerge_mass (j : Fin 3) :
    nonadjacentLegalMerge.channel () j = nonadjacentMerged () j := by
  change ((nonadjacentState.channel ()).map (mergeSourceEquiv nonadjacentState)).map _ j = _
  have hid : mergeSourceEquiv nonadjacentState = Equiv.refl (Fin 4) := by
    ext i
    rfl
  simp only [hid, Equiv.coe_refl, PMF.map_id]
  rfl

private def nonadjacentRecovered : PMF (Fin 4) :=
  ppsRaw nonadjacentMerged 0 (1 / 5) (by change (1 / 5 : ℝ) ≤ 1; norm_num) ()

private theorem nonadjacentRecovered_mass (j : Fin 4) :
    nonadjacentRecovered j = ((![1 / 10, 4 / 10, 2 / 10, 3 / 10] j : NNReal) : ENNReal) := by
  fin_cases j
  · change ppsRaw _ _ _ _ () (splitLeft (0 : Fin 3)) = _
    rw [ppsRaw_left, nonadjacentMerged_mass, ← ENNReal.coe_mul]
    norm_num
  · change ppsRaw _ _ _ _ () (splitRight (0 : Fin 3)) = _
    rw [ppsRaw_right, nonadjacentMerged_mass, ← ENNReal.coe_mul]
    apply congrArg (fun r : NNReal => (r : ENNReal))
    apply NNReal.coe_injective
    norm_num [NNReal.coe_sub_def]
  · change ppsRaw _ _ _ _ () (splitKeep (0 : Fin 3) 1) = _
    rw [ppsRaw_keep _ _ _ _ _ (by decide), nonadjacentMerged_mass]
    rfl
  · change ppsRaw _ _ _ _ () (splitKeep (0 : Fin 3) 2) = _
    rw [ppsRaw_keep _ _ _ _ _ (by decide), nonadjacentMerged_mass]
    rfl

-- Connect the numeric raw calculation to the actual legal recovery state.
private theorem nonadjacentLegalRecovery_eq :
    (ppmRecovery nonadjacentState nonadjacentState_singular 0 3 (by decide)
      nonadjacentState_patterns).channel () = nonadjacentRecovered := by
  have hs : activeMergeSurvivor nonadjacentState 0 3 (by decide) = (0 : Fin 3) := by
    apply Fin.ext
    exact activeMergeSurvivor_val nonadjacentState 0 3 (by decide)
  have hm : nonadjacentLegalMerge.channel = nonadjacentMerged := by
    funext x
    cases x
    exact PMF.ext nonadjacentLegalMerge_mass
  change ppsRaw (n := 3) nonadjacentLegalMerge.channel
    (activeMergeSurvivor nonadjacentState 0 3 (by decide))
    (ppmRatio nonadjacentState nonadjacentState_singular 0 3)
    (ppmRatio_lt_one nonadjacentState nonadjacentState_singular 0 3).le () =
      nonadjacentRecovered
  simp only [hs, nonadjacentRatio, hm, nonadjacentRecovered]

private def nonadjacentRho : Fin 4 ≃ Fin 4 := recoveryPerm 0 3 (by decide)

private theorem nonadjacentRho_apply (j : Fin 4) : nonadjacentRho j = ![0, 3, 1, 2] j := by
  apply Fin.ext
  fin_cases j <;> norm_num [nonadjacentRho, recoveryPerm_val]

private theorem nonadjacentRho_symm_apply (j : Fin 4) :
    nonadjacentRho.symm j = ![0, 2, 3, 1] j := by
  apply Fin.ext
  fin_cases j <;> norm_num [nonadjacentRho, recoveryPerm_symm_val, Fin.ext_iff]

private theorem nonadjacent_correct_map :
    nonadjacentRecovered.map nonadjacentRho = nonadjacentState.channel () := by
  apply PMF.ext
  intro j
  obtain ⟨i, rfl⟩ := nonadjacentRho.surjective j
  rw [PMF.map_apply_equiv, nonadjacentRecovered_mass, nonadjacentRho_apply]
  fin_cases i <;> rfl

example : nonadjacentRecovered.map nonadjacentRho = nonadjacentState.channel () :=
  nonadjacent_correct_map

example : ((ppmRecovery nonadjacentState nonadjacentState_singular 0 3 (by decide)
      nonadjacentState_patterns).channel ()).map nonadjacentRho = nonadjacentState.channel () := by
  rw [nonadjacentLegalRecovery_eq]
  exact nonadjacent_correct_map

example : (nonadjacentState.channel ()).map nonadjacentRho.symm = nonadjacentRecovered := by
  apply PMF.ext
  intro j
  obtain ⟨i, rfl⟩ := nonadjacentRho.symm.surjective j
  rw [PMF.map_apply_equiv, nonadjacentRecovered_mass, nonadjacentRho_symm_apply]
  fin_cases i <;> rfl

private theorem nonadjacent_wrong_mass :
    (nonadjacentRecovered.map nonadjacentRho.symm) 1 = ((3 / 10 : NNReal) : ENNReal) := by
  have hi : nonadjacentRho.symm 3 = 1 := by
    apply Fin.ext
    norm_num [nonadjacentRho, recoveryPerm_symm_val]
  have hm := PMF.map_apply_equiv nonadjacentRecovered nonadjacentRho.symm 3
  rw [hi, nonadjacentRecovered_mass] at hm
  exact hm

private theorem nonadjacent_wrong_map :
    nonadjacentRecovered.map nonadjacentRho.symm ≠ nonadjacentState.channel () := by
  intro h
  have hm := congrArg (fun p : PMF (Fin 4) => p 1) h
  rw [nonadjacent_wrong_mass] at hm
  change ((3 / 10 : NNReal) : ENNReal) = ((2 / 10 : NNReal) : ENNReal) at hm
  have := ENNReal.coe_inj.mp hm
  norm_num at this

example : ((ppmRecovery nonadjacentState nonadjacentState_singular 0 3 (by decide)
      nonadjacentState_patterns).channel ()).map nonadjacentRho.symm ≠
    nonadjacentState.channel () := by
  rw [nonadjacentLegalRecovery_eq]
  exact nonadjacent_wrong_map

end
end PerfectFunctionalRepresentations.MatrixOperations

namespace PerfectFunctionalRepresentations.MatrixOperations

open scoped BigOperators ENNReal
noncomputable section
attribute [local instance] Classical.propDecidable

private theorem vpPure_singular {α β : Type} (f : α → β) :
    IsSingularChannel (fun x => PMF.pure (f x)) := by
  intro x z j hx hz
  simp only [PMF.pure_apply] at hx hz ⊢
  split_ifs at hx hz ⊢ <;> simp_all

-- R09: the decisive one-output, value-one split has two active children.
private abbrev vpSingle : ActiveFiniteChannel (Fin 2) where
  outputCard := 1
  outputCard_pos := by decide
  channel := fun _ => PMF.pure 0
  output_active := by intro j; exact ⟨0, by fin_cases j; simp⟩

private theorem vpSingle_singular : IsSingularChannel vpSingle.channel := vpPure_singular _
private def vpHalfMask (x : Fin 2) : Bool := decide (x = 0)
private theorem vpSingle_left : ∃ x, vpSingle.channel x 0 ≠ 0 ∧ vpHalfMask x = true :=
  ⟨0, by simp [vpSingle], by decide⟩
private theorem vpSingle_right : ∃ x, vpSingle.channel x 0 ≠ 0 ∧ vpHalfMask x = false :=
  ⟨1, by simp [vpSingle], by decide⟩
private abbrev vpOneSplit : ActiveFiniteChannel (Fin 2) :=
  vps vpSingle vpSingle_singular 0 vpHalfMask vpSingle_left vpSingle_right

private theorem vpSingle_value : columnValue vpSingle.channel vpSingle_singular
    (vpSingle.activeEquiv 0) = 1 := by
  rw [columnValue_eq_of_ne_zero _ _ _ (x := 0)
    (by change (PMF.pure (0 : Fin 1)) 0 ≠ 0; simp)]
  change (PMF.pure (0 : Fin 1)) 0 = 1
  simp

example : vpOneSplit.outputCard = 2 ∧ IsSingularChannel vpOneSplit.channel :=
  ⟨rfl, vps_isSingular _ _ _ _ _ _⟩

example : columnValue vpOneSplit.channel (vps_isSingular _ _ _ _ _ _)
      (vpOneSplit.activeEquiv (splitLeft (0 : Fin 1))) = 1 ∧
    columnValue vpOneSplit.channel (vps_isSingular _ _ _ _ _ _)
      (vpOneSplit.activeEquiv (splitRight (0 : Fin 1))) = 1 :=
  ⟨(columnValue_vps_left _ _ _ _ _ _).trans vpSingle_value,
    (columnValue_vps_right _ _ _ _ _ _).trans vpSingle_value⟩

example : vpOneSplit.channel 0 (splitLeft (0 : Fin 1)) = 1 ∧
    vpOneSplit.channel 1 (splitRight (0 : Fin 1)) = 1 := by
  constructor
  · rw [vps_left]; simp [vpSingle, vpHalfMask]
  · rw [vps_right]; simp [vpSingle, vpHalfMask]

example (x : Fin 2) : vpOneSplit.channel x =
    (vpSingle.channel x).map (vpsIndex (0 : Fin 1) (vpHalfMask x)) :=
  vps_apply_map _ _ _ _ _ _ x

example : vpsIndex (0 : Fin 1) (vpHalfMask 0) 0 ≠
    vpsIndex (0 : Fin 1) (vpHalfMask 1) 0 := by decide

-- R09/R10: support {0,1}, with null row 2 and an unaffected second column.
private abbrev vpProper : ActiveFiniteChannel (Fin 3) where
  outputCard := 2
  outputCard_pos := by decide
  channel := fun x => PMF.pure (if x = 2 then 1 else 0)
  output_active := by
    intro j
    fin_cases j
    · exact ⟨0, by simp⟩
    · exact ⟨2, by simp⟩

private theorem vpProper_singular : IsSingularChannel vpProper.channel := vpPure_singular _
private def vpProperMask (x : Fin 3) : Bool := decide (x = 0)
private def vpProperAlt (x : Fin 3) : Bool := decide (x ≠ 1)
private theorem vpProper_left : ∃ x, vpProper.channel x 0 ≠ 0 ∧ vpProperMask x = true :=
  ⟨0, by simp [vpProper], by decide⟩
private theorem vpProper_right : ∃ x, vpProper.channel x 0 ≠ 0 ∧ vpProperMask x = false :=
  ⟨1, by simp [vpProper], by decide⟩
private theorem vpProperAlt_left : ∃ x, vpProper.channel x 0 ≠ 0 ∧ vpProperAlt x = true :=
  ⟨0, by simp [vpProper], by decide⟩
private theorem vpProperAlt_right : ∃ x, vpProper.channel x 0 ≠ 0 ∧ vpProperAlt x = false :=
  ⟨1, by simp [vpProper], by decide⟩
private abbrev vpProperSplit : ActiveFiniteChannel (Fin 3) :=
  vps vpProper vpProper_singular 0 vpProperMask vpProper_left vpProper_right

example : vpProperSplit.channel 2 (splitLeft (0 : Fin 2)) = 0 ∧
    vpProperSplit.channel 2 (splitRight (0 : Fin 2)) = 0 ∧
    vpProperSplit.channel 2 (splitKeep (0 : Fin 2) 1) = 1 := by
  refine ⟨?_, ?_, ?_⟩
  · rw [vps_left]; simp [vpProperMask]
  · rw [vps_right]; simp [vpProper, vpProperMask]
  · rw [vps_keep _ _ _ _ _ _ _ (by decide)]; simp [vpProper]

example : (columnPattern vpProperSplit.channel
      (vpProperSplit.activeEquiv (splitLeft (0 : Fin 2)))).val = {0} ∧
    (columnPattern vpProperSplit.channel
      (vpProperSplit.activeEquiv (splitRight (0 : Fin 2)))).val = {1} := by
  constructor
  · rw [columnPattern_vps_left]
    ext x
    simp only [Finset.mem_filter, mem_columnPattern, Finset.mem_singleton]
    change (vpProper.channel x 0 ≠ 0 ∧ vpProperMask x = true) ↔ x = 0
    fin_cases x <;> simp [vpProper, vpProperMask]
  · rw [columnPattern_vps_right]
    ext x
    simp only [Finset.mem_filter, mem_columnPattern, Finset.mem_singleton]
    change (vpProper.channel x 0 ≠ 0 ∧ vpProperMask x = false) ↔ x = 1
    fin_cases x <;> simp [vpProper, vpProperMask]

example : Disjoint (columnPattern vpProperSplit.channel
      (vpProperSplit.activeEquiv (splitLeft (0 : Fin 2)))).val
    (columnPattern vpProperSplit.channel
      (vpProperSplit.activeEquiv (splitRight (0 : Fin 2)))).val :=
  columnPattern_vps_disjoint _ _ _ _ _ _

example (x : Fin 3) :
    (if vpProperSplit.channel x (splitLeft (0 : Fin 2)) ≠ 0 then (1 : ℝ) else 0) +
      (if vpProperSplit.channel x (splitRight (0 : Fin 2)) ≠ 0 then 1 else 0) =
      if vpProper.channel x 0 ≠ 0 then 1 else 0 :=
  vps_support_indicator_sum _ _ _ _ _ _ x

example (x : Fin 3) :
    realMatrix vpProperSplit.channel x (splitLeft (0 : Fin 2)) /
        (columnValue vpProperSplit.channel (vps_isSingular _ _ _ _ _ _)
          (vpProperSplit.activeEquiv (splitLeft (0 : Fin 2)))).toReal =
      (realMatrix vpProper.channel x 0 /
        (columnValue vpProper.channel vpProper_singular (vpProper.activeEquiv 0)).toReal) *
        (if vpProperMask x then 1 else 0) :=
  vps_indicator_left _ _ _ _ _ _ x

example (x : Fin 3) :
    realMatrix vpProperSplit.channel x (splitRight (0 : Fin 2)) /
        (columnValue vpProperSplit.channel (vps_isSingular _ _ _ _ _ _)
          (vpProperSplit.activeEquiv (splitRight (0 : Fin 2)))).toReal =
      (realMatrix vpProper.channel x 0 /
        (columnValue vpProper.channel vpProper_singular (vpProper.activeEquiv 0)).toReal) *
        (1 - (if vpProperMask x then 1 else 0)) :=
  vps_indicator_right _ _ _ _ _ _ x

example (x : Fin 3) :
    realMatrix vpProperSplit.channel x (splitLeft (0 : Fin 2)) /
        (columnValue vpProperSplit.channel (vps_isSingular _ _ _ _ _ _)
          (vpProperSplit.activeEquiv (splitLeft (0 : Fin 2)))).toReal +
      realMatrix vpProperSplit.channel x (splitRight (0 : Fin 2)) /
        (columnValue vpProperSplit.channel (vps_isSingular _ _ _ _ _ _)
          (vpProperSplit.activeEquiv (splitRight (0 : Fin 2)))).toReal =
      realMatrix vpProper.channel x 0 /
        (columnValue vpProper.channel vpProper_singular (vpProper.activeEquiv 0)).toReal :=
  vps_indicator_sum _ _ _ _ _ _ x

example : vpProperMask 2 ≠ vpProperAlt 2 ∧
    vpProperSplit.channel =
      (vps vpProper vpProper_singular 0 vpProperAlt
        vpProperAlt_left vpProperAlt_right).channel := by
  refine ⟨by decide, vps_mask_irrelevant _ _ _ _ _ _ _ _ _ ?_⟩
  intro x hx
  fin_cases x <;> simp_all [vpProper, vpProperMask, vpProperAlt]

private def vpBadMask (x : Fin 3) : Bool := decide (x ≠ 2)
example : vpBadMask 0 ≠ vpBadMask 2 ∧
    ¬ ∃ x, vpProper.channel x 0 ≠ 0 ∧ vpBadMask x = false := by
  refine ⟨by decide, ?_⟩
  rintro ⟨x, hx, hm⟩
  fin_cases x <;> simp_all [vpProper, vpBadMask]

private abbrev vpIdentity2 : ActiveFiniteChannel (Fin 2) where
  outputCard := 2
  outputCard_pos := by decide
  channel := fun x => PMF.pure x
  output_active := by intro j; exact ⟨j, by simp⟩
private theorem vpIdentity2_singular : IsSingularChannel vpIdentity2.channel := vpPure_singular _
private theorem vpIdentity2_value (j : Fin 2) :
    columnValue vpIdentity2.channel vpIdentity2_singular (vpIdentity2.activeEquiv j) = 1 := by
  rw [columnValue_eq_of_ne_zero _ _ _ (x := j) (by change (PMF.pure j) j ≠ 0; simp)]
  change (PMF.pure j) j = 1
  simp

example (mask : Fin 2 → Bool) :
    ¬ ((∃ x, vpIdentity2.channel x 0 ≠ 0 ∧ mask x = true) ∧
      (∃ x, vpIdentity2.channel x 0 ≠ 0 ∧ mask x = false)) := by
  rintro ⟨⟨x, hx, hm⟩, ⟨z, hz, hn⟩⟩
  fin_cases x <;> fin_cases z <;> simp_all [vpIdentity2, PMF.pure_apply]

-- R11: same-valued overlapping columns fail the support condition.
private abbrev vpOverlap : ActiveFiniteChannel (Fin 2) :=
  pps vpSingle vpSingle_singular 0 (1 / 2)
    (by change (0 : ℝ) < 1 / 2; norm_num) (by change (1 / 2 : ℝ) < 1; norm_num)
private theorem vpOverlap_singular : IsSingularChannel vpOverlap.channel :=
  pps_isSingular _ _ _ _ _ _

example : columnValue vpOverlap.channel vpOverlap_singular
      (vpOverlap.activeEquiv (splitLeft (0 : Fin 1))) =
    columnValue vpOverlap.channel vpOverlap_singular
      (vpOverlap.activeEquiv (splitRight (0 : Fin 1))) := by
  rw [columnValue_pps_left, columnValue_pps_right, vpSingle_value]
  norm_num

example : ¬ ∀ x, vpOverlap.channel x (splitLeft (0 : Fin 1)) ≠ 0 →
    vpOverlap.channel x (splitRight (0 : Fin 1)) = 0 := by
  intro h
  have hl : vpOverlap.channel 0 (splitLeft (0 : Fin 1)) ≠ 0 := by
    rw [pps_left]; norm_num [vpSingle]
  have hz := h 0 hl
  rw [pps_right] at hz
  norm_num [vpSingle] at hz

-- Disjointness alone is also insufficient: one selected value is 1/3, the other is 1.
private abbrev vpUnequal : ActiveFiniteChannel (Fin 2) :=
  pps vpIdentity2 vpIdentity2_singular 0 (1 / 3)
    (by change (0 : ℝ) < 1 / 3; norm_num) (by change (1 / 3 : ℝ) < 1; norm_num)
private theorem vpUnequal_singular : IsSingularChannel vpUnequal.channel :=
  pps_isSingular _ _ _ _ _ _

example : ∀ x, vpUnequal.channel x (splitLeft (0 : Fin 2)) ≠ 0 →
    vpUnequal.channel x (splitKeep (0 : Fin 2) 1) = 0 := by
  intro x hx
  have ho := (pps_left_ne_zero_iff vpIdentity2 vpIdentity2_singular 0 (1 / 3) _ _ x).mp hx
  rw [pps_keep _ _ _ _ _ _ _ (by decide)]
  fin_cases x <;> simp_all [vpIdentity2]

example : columnValue vpUnequal.channel vpUnequal_singular
      (vpUnequal.activeEquiv (splitLeft (0 : Fin 2))) ≠
    columnValue vpUnequal.channel vpUnequal_singular
      (vpUnequal.activeEquiv (splitKeep (0 : Fin 2) 1)) := by
  rw [columnValue_pps_left, columnValue_pps_keep _ _ _ _ _ _ (by decide),
    vpIdentity2_value, vpIdentity2_value]
  norm_num

-- R11/R13: equal value one, disjoint supports, final index, nonadjacent recovery.
private abbrev vpIdentity4 : ActiveFiniteChannel (Fin 4) where
  outputCard := 4
  outputCard_pos := by decide
  channel := fun x => PMF.pure x
  output_active := by intro j; exact ⟨j, by simp⟩
private theorem vpIdentity4_singular : IsSingularChannel vpIdentity4.channel := vpPure_singular _
private theorem vpIdentity4_value (j : Fin 4) :
    columnValue vpIdentity4.channel vpIdentity4_singular (vpIdentity4.activeEquiv j) = 1 := by
  rw [columnValue_eq_of_ne_zero _ _ _ (x := j) (by change (PMF.pure j) j ≠ 0; simp)]
  change (PMF.pure j) j = 1
  simp
private theorem vpIdentity4_values :
    columnValue vpIdentity4.channel vpIdentity4_singular (vpIdentity4.activeEquiv 0) =
      columnValue vpIdentity4.channel vpIdentity4_singular (vpIdentity4.activeEquiv 3) := by
  rw [vpIdentity4_value, vpIdentity4_value]
private theorem vpIdentity4_disjoint (x : Fin 4) (hx : vpIdentity4.channel x 0 ≠ 0) :
    vpIdentity4.channel x 3 = 0 := by
  fin_cases x <;> simp_all [vpIdentity4]
private abbrev vpFinalMerge : ActiveFiniteChannel (Fin 4) :=
  vpm vpIdentity4 vpIdentity4_singular 0 3 (by decide) vpIdentity4_values vpIdentity4_disjoint
private abbrev vpFinalRecovery : ActiveFiniteChannel (Fin 4) :=
  vpmRecovery vpIdentity4 vpIdentity4_singular 0 3 (by decide)
    vpIdentity4_values vpIdentity4_disjoint

private theorem vpFinalSurvivor :
    activeMergeSurvivor vpIdentity4 0 3 (by decide) = (0 : Fin 3) := by
  apply Fin.ext
  exact activeMergeSurvivor_val _ _ _ _

example : vpFinalMerge.outputCard = 3 ∧ vpFinalRecovery.outputCard = 4 := ⟨rfl, rfl⟩

example : columnValue vpFinalMerge.channel (vpm_isSingular _ _ _ _ _ _ _)
    (vpFinalMerge.activeEquiv (activeMergeSurvivor vpIdentity4 0 3 (by decide))) = 1 :=
  (columnValue_vpm_survivor _ _ _ _ _ _ _).trans (vpIdentity4_value 0)

example : vpFinalMerge.channel 0 (activeMergeSurvivor vpIdentity4 0 3 (by decide)) = 1 ∧
    vpFinalMerge.channel 3 (activeMergeSurvivor vpIdentity4 0 3 (by decide)) = 1 := by
  constructor <;> rw [vpm_apply_survivor] <;> simp [vpIdentity4]

example (x : Fin 4) : vpFinalMerge.channel x (1 : Fin 3) = vpIdentity4.channel x 1 := by
  rw [vpm_apply_unaffected _ _ _ _ _ _ _ x (by rw [vpFinalSurvivor]; decide)]
  rfl

example : (columnPattern vpFinalMerge.channel
    (vpFinalMerge.activeEquiv (activeMergeSurvivor vpIdentity4 0 3 (by decide)))).val = {0, 3} := by
  rw [columnPattern_vpm_survivor]
  ext x
  simp only [Finset.mem_union, mem_columnPattern]
  change (vpIdentity4.channel x 0 ≠ 0 ∨ vpIdentity4.channel x 3 ≠ 0) ↔ x ∈ ({0, 3} : Finset (Fin 4))
  fin_cases x <;> simp [vpIdentity4]

example : Disjoint (columnPattern vpIdentity4.channel (vpIdentity4.activeEquiv 0)).val
    (columnPattern vpIdentity4.channel (vpIdentity4.activeEquiv 3)).val :=
  (disjoint_support_iff_columnPattern_disjoint _ _ _).mp vpIdentity4_disjoint

example (x : Fin 4) :
    (realMatrix vpIdentity4.channel x 0 /
        (columnValue vpIdentity4.channel vpIdentity4_singular (vpIdentity4.activeEquiv 0)).toReal +
      realMatrix vpIdentity4.channel x 3 /
        (columnValue vpIdentity4.channel vpIdentity4_singular
          (vpIdentity4.activeEquiv 3)).toReal = 0) ∨
    (realMatrix vpIdentity4.channel x 0 /
        (columnValue vpIdentity4.channel vpIdentity4_singular (vpIdentity4.activeEquiv 0)).toReal +
      realMatrix vpIdentity4.channel x 3 /
        (columnValue vpIdentity4.channel vpIdentity4_singular
          (vpIdentity4.activeEquiv 3)).toReal = 1) :=
  (disjoint_support_iff_div_value_sum _ _ _ _).mp vpIdentity4_disjoint x

-- R12: exact adjacent recovery and the same remembered legal mask, including null rows.
example (x : Fin 3) :
    ((vpsRecovery vpProper vpProper_singular 0 vpProperMask
      vpProper_left vpProper_right).channel x).map
      (finCongr (vpsRecovery_outputCard _ _ _ _ _ _)) = vpProper.channel x :=
  vpsRecovery_channel _ _ _ _ _ _ x

example :
    (∃ x, (vpsRecovery vpProper vpProper_singular 0 vpProperMask
        vpProper_left vpProper_right).channel x (0 : Fin 2) ≠ 0 ∧ vpProperMask x = true) ∧
      (∃ x, (vpsRecovery vpProper vpProper_singular 0 vpProperMask
        vpProper_left vpProper_right).channel x (0 : Fin 2) ≠ 0 ∧ vpProperMask x = false) :=
  vpsRecovery_mask_legal _ _ _ _ _ _

example (x : Fin 3) :
    (vps (vpsRecovery vpProper vpProper_singular 0 vpProperMask vpProper_left vpProper_right)
      (vpsRecovery_isSingular _ _ _ _ _ _) (0 : Fin 2) vpProperMask
      (vpsRecovery_mask_legal _ _ _ _ _ _).1
      (vpsRecovery_mask_legal _ _ _ _ _ _).2).channel x = vpProperSplit.channel x :=
  vpsRecovery_resplit _ _ _ _ _ _ x

example (x : Fin 2) : ((vpmRecovery vpIdentity2 vpIdentity2_singular 0 1 (by decide)
    (by rw [vpIdentity2_value, vpIdentity2_value])
    (by intro z hz; fin_cases z <;> simp_all [vpIdentity2])).channel x).map
      (finCongr (vpmRecovery_outputCard _ _ _ _ _ _ _)) = vpIdentity2.channel x :=
  vpmRecovery_adjacent _ _ _ _ _ _ _ (by decide) x

-- R13: the constructed support mask and the actual new-to-original permutation.
example (x : Fin 4) : vpmRecoveryMask vpIdentity4 0 x = decide (x = 0) := by
  simp [vpmRecoveryMask, vpIdentity4, PMF.pure_apply, eq_comm]

example (x : Fin 4) : (vpFinalRecovery.channel x).map
    (vpmRecoveryEquiv vpIdentity4 vpIdentity4_singular 0 3 (by decide)
      vpIdentity4_values vpIdentity4_disjoint) = vpIdentity4.channel x :=
  vpmRecovery_channel _ _ _ _ _ _ _ x

example (x : Fin 4) : (vpIdentity4.channel x).map
    (vpmRecoveryEquiv vpIdentity4 vpIdentity4_singular 0 3 (by decide)
      vpIdentity4_values vpIdentity4_disjoint).symm = vpFinalRecovery.channel x :=
  vpmRecovery_channel_inverse _ _ _ _ _ _ _ x

example (x : Fin 4) : (vpFinalRecovery.channel x).map (recoveryPerm (0 : Fin 4) 3 (by decide)) =
    vpIdentity4.channel x := by
  have h := vpmRecovery_reindex vpIdentity4 vpIdentity4_singular 0 3 (by decide)
    vpIdentity4_values vpIdentity4_disjoint x
  change ((vpFinalRecovery.channel x).map id).map (recoveryPerm (0 : Fin 4) 3 (by decide)) = _ at h
  simpa only [PMF.map_id] using h

example (x : Fin 4) : vpFinalRecovery.channel x
    (splitKeep (activeMergeSurvivor vpIdentity4 0 3 (by decide)) (1 : Fin 3)) =
      vpIdentity4.channel x 1 := by
  exact vpmRecovery_keep vpIdentity4 vpIdentity4_singular 0 3 (by decide)
    vpIdentity4_values vpIdentity4_disjoint x (j := (1 : Fin 3))
    (by rw [vpFinalSurvivor]; decide)

example : vpFinalRecovery.channel 3
    (splitRight (activeMergeSurvivor vpIdentity4 0 3 (by decide))) = 1 := by
  rw [vpmRecovery_right]
  simp [vpIdentity4]

end
end PerfectFunctionalRepresentations.MatrixOperations

namespace PerfectFunctionalRepresentations.MatrixOperations

open scoped ENNReal

universe uR15

noncomputable section R15Consumers

-- R15: public downstream consumers retain only the advertised semantic hypotheses.
variable {alpha : Type uR15} [Finite alpha] [Nonempty alpha]
variable (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)

section PPSSplit

variable (l : Fin S.outputCard) (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1)

example : (pps S hS l t ht0 ht1).outputCard = S.outputCard + 1 ∧
    IsSingularChannel (pps S hS l t ht0 ht1).channel ∧
    ∀ x, (pps S hS l t ht0 ht1).channel x =
      (S.channel x).bind (ppsKernel l t ht1.le) :=
  ⟨pps_outputCard S hS l t ht0 ht1, pps_isSingular S hS l t ht0 ht1,
    pps_apply_bind S hS l t ht0 ht1⟩

example : ppsKernel l t ht1.le l =
      PMF.binaryMixture t ht1.le (PMF.pure (splitLeft l)) (PMF.pure (splitRight l)) ∧
    ∀ j, j ≠ l → ppsKernel l t ht1.le j = PMF.pure (splitKeep l j) :=
  ⟨ppsKernel_selected l t ht1.le, fun _ hj => ppsKernel_unaffected l t ht1.le hj⟩

example (x : alpha) : ((pps S hS l t ht0 ht1).channel x).map
      (finCongr (pps_outputCard S hS l t ht0 ht1)) = ppsRaw S.channel l t ht1.le x :=
  pps_channel_map S hS l t ht0 ht1 x

-- The inverse PPM receives its support witness from the split's public interface.
example : ppm (pps S hS l t ht0 ht1) (pps_isSingular S hS l t ht0 ht1)
      (splitLeft l) (splitRight l) Fin.castSucc_lt_succ
      (pps_children_sameSupport S hS l t ht0 ht1) = ppsRecovery S hS l t ht0 ht1 := rfl

example : ppmRatio (pps S hS l t ht0 ht1) (pps_isSingular S hS l t ht0 ht1)
      (splitLeft l) (splitRight l) = t ∧
    (ppsRecovery S hS l t ht0 ht1).outputCard = S.outputCard ∧
    ∀ x, ((ppsRecovery S hS l t ht0 ht1).channel x).map
      (finCongr (ppsRecovery_outputCard S hS l t ht0 ht1)) = S.channel x :=
  ⟨ppmRatio_pps S hS l t ht0 ht1, ppsRecovery_outputCard S hS l t ht0 ht1,
    ppsRecovery_channel S hS l t ht0 ht1⟩

-- C06 invariance applies to the actual recovered endpoint and its proved row equation.
-- This says nothing about perfectness across a single PPS or PPM operation.
example : IsPerfectlyRepresentableChannel (ppsRecovery S hS l t ht0 ht1).channel ↔
    IsPerfectlyRepresentableChannel S.channel := by
  have heq : relabelChannel (ppsRecovery S hS l t ht0 ht1).channel (Equiv.refl alpha)
      (finCongr (ppsRecovery_outputCard S hS l t ht0 ht1)) = S.channel := by
    funext x
    exact ppsRecovery_channel S hS l t ht0 ht1 x
  have h := isPerfectlyRepresentableChannel_relabelChannel_iff
    (ppsRecovery S hS l t ht0 ht1).channel (Equiv.refl alpha)
    (finCongr (ppsRecovery_outputCard S hS l t ht0 ht1))
  rw [heq] at h
  exact h.symm

end PPSSplit

section PPMMerge

variable (a b : Fin S.outputCard) (hab : a < b)
variable (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0)

example : (ppm S hS a b hab hp).outputCard = S.outputCard - 1 ∧
    IsSingularChannel (ppm S hS a b hab hp).channel ∧
    ∀ x, (ppm S hS a b hab hp).channel x =
      ((S.channel x).map (mergeSourceEquiv S)).map
        (mergeIndex (mergeSourceEquiv S a) (mergeSourceEquiv S b)
          ((mergeSourceEquiv_lt_iff S a b).mpr hab)) := by
  refine ⟨ppm_outputCard S hS a b hab hp, ppm_isSingular S hS a b hab hp, ?_⟩
  intro x
  exact (ppm_channel S hS a b hab hp x).trans (mergeRaw_apply_map _ _ _ _ x)

example (x : alpha) : ((ppm S hS a b hab hp).channel x).map
      (finCongr (ppm_outputCard S hS a b hab hp)) =
    mergeRaw (fun x => (S.channel x).map (mergeSourceEquiv S))
      (mergeSourceEquiv S a) (mergeSourceEquiv S b)
      ((mergeSourceEquiv_lt_iff S a b).mpr hab) x :=
  ppm_channel_map S hS a b hab hp x

-- The original positive finite values determine the strict inverse ratio.
example : 0 < ppmRatio S hS a b ∧ ppmRatio S hS a b < 1 ∧
    0 < (columnValue S.channel hS (S.activeEquiv a) +
      columnValue S.channel hS (S.activeEquiv b)).toNNReal ∧
    columnValue S.channel hS (S.activeEquiv a) +
      columnValue S.channel hS (S.activeEquiv b) ≠ ∞ :=
  ⟨ppmRatio_pos S hS a b, ppmRatio_lt_one S hS a b,
    ppmRatio_denominator_pos S hS a b, ppmRatio_denominator_ne_top S hS a b⟩

example : (ppmRatio S hS a b : ENNReal) *
      (columnValue S.channel hS (S.activeEquiv a) +
        columnValue S.channel hS (S.activeEquiv b)) =
      columnValue S.channel hS (S.activeEquiv a) ∧
    ((1 - ppmRatio S hS a b : NNReal) : ENNReal) *
      (columnValue S.channel hS (S.activeEquiv a) +
        columnValue S.channel hS (S.activeEquiv b)) =
      columnValue S.channel hS (S.activeEquiv b) :=
  ⟨ppmRatio_mul_sum S hS a b, ppmRatio_complement_mul_sum S hS a b⟩

example : pps (ppm S hS a b hab hp) (ppm_isSingular S hS a b hab hp)
      (activeMergeSurvivor S a b hab) (ppmRatio S hS a b)
      (ppmRatio_pos S hS a b) (ppmRatio_lt_one S hS a b) =
    ppmRecovery S hS a b hab hp := rfl

example : ppmRecoveryEquiv S hS a b hab hp =
    (finCongr (ppmRecovery_outputCard S hS a b hab hp)).trans (recoveryPerm a b hab) := rfl

example (x : alpha) :
    ((ppmRecovery S hS a b hab hp).channel x).map (ppmRecoveryEquiv S hS a b hab hp) =
      S.channel x ∧
    (S.channel x).map (ppmRecoveryEquiv S hS a b hab hp).symm =
      (ppmRecovery S hS a b hab hp).channel x :=
  ⟨ppmRecovery_channel S hS a b hab hp x, ppmRecovery_channel_inverse S hS a b hab hp x⟩

example (x : alpha) :
    (((ppmRecovery S hS a b hab hp).channel x).map
      (finCongr (ppmRecovery_outputCard S hS a b hab hp))).map (recoveryPerm a b hab) =
      S.channel x ∧
    (S.channel x).map (recoveryPerm a b hab).symm =
      ((ppmRecovery S hS a b hab hp).channel x).map
        (finCongr (ppmRecovery_outputCard S hS a b hab hp)) :=
  ⟨ppmRecovery_reindex S hS a b hab hp x, ppmRecovery_reindex_inverse S hS a b hab hp x⟩

example (hadj : b.val = a.val + 1) (x : alpha) :
    ((ppmRecovery S hS a b hab hp).channel x).map
      (finCongr (ppmRecovery_outputCard S hS a b hab hp)) = S.channel x :=
  ppmRecovery_adjacent S hS a b hab hp hadj x

example : IsPerfectlyRepresentableChannel (ppmRecovery S hS a b hab hp).channel ↔
    IsPerfectlyRepresentableChannel S.channel := by
  have heq : relabelChannel (ppmRecovery S hS a b hab hp).channel (Equiv.refl alpha)
      (ppmRecoveryEquiv S hS a b hab hp) = S.channel := by
    funext x
    exact ppmRecovery_channel S hS a b hab hp x
  have h := isPerfectlyRepresentableChannel_relabelChannel_iff
    (ppmRecovery S hS a b hab hp).channel (Equiv.refl alpha)
    (ppmRecoveryEquiv S hS a b hab hp)
  rw [heq] at h
  exact h.symm

end PPMMerge

section VPSSplit

variable (l : Fin S.outputCard) (mask : alpha → Bool)
variable (hl : ∃ x, S.channel x l ≠ 0 ∧ mask x = true)
variable (hr : ∃ x, S.channel x l ≠ 0 ∧ mask x = false)

example : (vps S hS l mask hl hr).outputCard = S.outputCard + 1 ∧
    IsSingularChannel (vps S hS l mask hl hr).channel ∧
    ∀ x, (vps S hS l mask hl hr).channel x = (S.channel x).map (vpsIndex l (mask x)) :=
  ⟨vps_outputCard S hS l mask hl hr, vps_isSingular S hS l mask hl hr,
    vps_apply_map S hS l mask hl hr⟩

example (x : alpha) : vpsIndex l (mask x) l =
      (if mask x then splitLeft l else splitRight l) ∧
    ∀ j, j ≠ l → vpsIndex l (mask x) j = splitKeep l j :=
  ⟨vpsIndex_selected l (mask x), fun _ hj => vpsIndex_unaffected l (mask x) hj⟩

example (x : alpha) : ((vps S hS l mask hl hr).channel x).map
      (finCongr (vps_outputCard S hS l mask hl hr)) = vpsRaw S.channel l mask x :=
  vps_channel_map S hS l mask hl hr x

-- Equal child values and disjoint supports are the actual legal VPM witnesses.
example : vpm (vps S hS l mask hl hr) (vps_isSingular S hS l mask hl hr)
      (splitLeft l) (splitRight l) Fin.castSucc_lt_succ
      ((columnValue_vps_left S hS l mask hl hr).trans
        (columnValue_vps_right S hS l mask hl hr).symm)
      (vps_children_disjoint S hS l mask hl hr) = vpsRecovery S hS l mask hl hr := rfl

example : (vpsRecovery S hS l mask hl hr).outputCard = S.outputCard ∧
    ∀ x, ((vpsRecovery S hS l mask hl hr).channel x).map
      (finCongr (vpsRecovery_outputCard S hS l mask hl hr)) = S.channel x :=
  ⟨vpsRecovery_outputCard S hS l mask hl hr, vpsRecovery_channel S hS l mask hl hr⟩

example :
    (∃ x, (vpsRecovery S hS l mask hl hr).channel x l ≠ 0 ∧ mask x = true) ∧
    (∃ x, (vpsRecovery S hS l mask hl hr).channel x l ≠ 0 ∧ mask x = false) :=
  vpsRecovery_mask_legal S hS l mask hl hr

example (x : alpha) :
    (vps (vpsRecovery S hS l mask hl hr) (vpsRecovery_isSingular S hS l mask hl hr) l mask
      (vpsRecovery_mask_legal S hS l mask hl hr).1
      (vpsRecovery_mask_legal S hS l mask hl hr).2).channel x =
    (vps S hS l mask hl hr).channel x :=
  vpsRecovery_resplit S hS l mask hl hr x

example : IsPerfectlyRepresentableChannel (vpsRecovery S hS l mask hl hr).channel ↔
    IsPerfectlyRepresentableChannel S.channel := by
  have heq : relabelChannel (vpsRecovery S hS l mask hl hr).channel (Equiv.refl alpha)
      (finCongr (vpsRecovery_outputCard S hS l mask hl hr)) = S.channel := by
    funext x
    exact vpsRecovery_channel S hS l mask hl hr x
  have h := isPerfectlyRepresentableChannel_relabelChannel_iff
    (vpsRecovery S hS l mask hl hr).channel (Equiv.refl alpha)
    (finCongr (vpsRecovery_outputCard S hS l mask hl hr))
  rw [heq] at h
  exact h.symm

end VPSSplit

section VPMMerge

variable (a b : Fin S.outputCard) (hab : a < b)
variable (hv : columnValue S.channel hS (S.activeEquiv a) =
  columnValue S.channel hS (S.activeEquiv b))
variable (hd : ∀ x, S.channel x a ≠ 0 → S.channel x b = 0)

example : (vpm S hS a b hab hv hd).outputCard = S.outputCard - 1 ∧
    IsSingularChannel (vpm S hS a b hab hv hd).channel ∧
    ∀ x, (vpm S hS a b hab hv hd).channel x =
      ((S.channel x).map (mergeSourceEquiv S)).map
        (mergeIndex (mergeSourceEquiv S a) (mergeSourceEquiv S b)
          ((mergeSourceEquiv_lt_iff S a b).mpr hab)) := by
  refine ⟨vpm_outputCard S hS a b hab hv hd, vpm_isSingular S hS a b hab hv hd, ?_⟩
  intro x
  exact (vpm_channel S hS a b hab hv hd x).trans (mergeRaw_apply_map _ _ _ _ x)

example (x : alpha) : ((vpm S hS a b hab hv hd).channel x).map
      (finCongr (vpm_outputCard S hS a b hab hv hd)) =
    mergeRaw (fun x => (S.channel x).map (mergeSourceEquiv S))
      (mergeSourceEquiv S a) (mergeSourceEquiv S b)
      ((mergeSourceEquiv_lt_iff S a b).mpr hab) x :=
  vpm_channel_map S hS a b hab hv hd x

-- Both existential witnesses come from old activity, with no stricter value bound.
example :
    (∃ x, (vpm S hS a b hab hv hd).channel x (activeMergeSurvivor S a b hab) ≠ 0 ∧
      vpmRecoveryMask S a x = true) ∧
    (∃ x, (vpm S hS a b hab hv hd).channel x (activeMergeSurvivor S a b hab) ≠ 0 ∧
      vpmRecoveryMask S a x = false) :=
  ⟨vpmRecovery_leftWitness S hS a b hab hv hd, vpmRecovery_rightWitness S hS a b hab hv hd⟩

example : vps (vpm S hS a b hab hv hd) (vpm_isSingular S hS a b hab hv hd)
      (activeMergeSurvivor S a b hab) (vpmRecoveryMask S a)
      (vpmRecovery_leftWitness S hS a b hab hv hd)
      (vpmRecovery_rightWitness S hS a b hab hv hd) = vpmRecovery S hS a b hab hv hd := rfl

example : vpmRecoveryEquiv S hS a b hab hv hd =
    (finCongr (vpmRecovery_outputCard S hS a b hab hv hd)).trans (recoveryPerm a b hab) := rfl

example (x : alpha) :
    ((vpmRecovery S hS a b hab hv hd).channel x).map (vpmRecoveryEquiv S hS a b hab hv hd) =
      S.channel x ∧
    (S.channel x).map (vpmRecoveryEquiv S hS a b hab hv hd).symm =
      (vpmRecovery S hS a b hab hv hd).channel x :=
  ⟨vpmRecovery_channel S hS a b hab hv hd x, vpmRecovery_channel_inverse S hS a b hab hv hd x⟩

example (x : alpha) :
    (((vpmRecovery S hS a b hab hv hd).channel x).map
      (finCongr (vpmRecovery_outputCard S hS a b hab hv hd))).map (recoveryPerm a b hab) =
      S.channel x ∧
    (S.channel x).map (recoveryPerm a b hab).symm =
      ((vpmRecovery S hS a b hab hv hd).channel x).map
        (finCongr (vpmRecovery_outputCard S hS a b hab hv hd)) :=
  ⟨vpmRecovery_reindex S hS a b hab hv hd x, vpmRecovery_reindex_inverse S hS a b hab hv hd x⟩

example (hadj : b.val = a.val + 1) (x : alpha) :
    ((vpmRecovery S hS a b hab hv hd).channel x).map
      (finCongr (vpmRecovery_outputCard S hS a b hab hv hd)) = S.channel x :=
  vpmRecovery_adjacent S hS a b hab hv hd hadj x

example : IsPerfectlyRepresentableChannel (vpmRecovery S hS a b hab hv hd).channel ↔
    IsPerfectlyRepresentableChannel S.channel := by
  have heq : relabelChannel (vpmRecovery S hS a b hab hv hd).channel (Equiv.refl alpha)
      (vpmRecoveryEquiv S hS a b hab hv hd) = S.channel := by
    funext x
    exact vpmRecovery_channel S hS a b hab hv hd x
  have h := isPerfectlyRepresentableChannel_relabelChannel_iff
    (vpmRecovery S hS a b hab hv hd).channel (Equiv.refl alpha)
    (vpmRecoveryEquiv S hS a b hab hv hd)
  rw [heq] at h
  exact h.symm

end VPMMerge

section FinsetLegality

-- Only the actual finite-set presentations add an enumeration instance.
variable [Fintype alpha]

example (a b : Fin S.outputCard) :
    (∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) ↔
      columnPattern S.channel (S.activeEquiv a) = columnPattern S.channel (S.activeEquiv b) :=
  same_support_iff_columnPattern_eq S a b

example (l : Fin S.outputCard) (mask : alpha → Bool) (b : Bool) :
    (∃ x, S.channel x l ≠ 0 ∧ mask x = b) ↔
      ((columnPattern S.channel (S.activeEquiv l)).val.filter (fun x => mask x = b)).Nonempty :=
  vps_witness_iff_filter_nonempty S l mask b

example (a b : Fin S.outputCard) :
    (∀ x, S.channel x a ≠ 0 → S.channel x b = 0) ↔
      Disjoint (columnPattern S.channel (S.activeEquiv a)).val
        (columnPattern S.channel (S.activeEquiv b)).val :=
  disjoint_support_iff_columnPattern_disjoint S a b

end FinsetLegality

end R15Consumers

end PerfectFunctionalRepresentations.MatrixOperations
