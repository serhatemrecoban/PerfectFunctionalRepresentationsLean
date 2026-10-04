import PerfectFunctionalRepresentations.Matrix.Reachability
import PerfectFunctionalRepresentations.Examples.Nonrepresentable3x3
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum

/-!
# C10 restricted reachability and reversal consumers

R01-R04 exercise the public S01 interface. Numeric fixtures distinguish unequal
PP children, nonadjacent merge labels, value-one VP operations, unaffected
columns and directed output permutations. Fixtures remain private.
-/

namespace PerfectFunctionalRepresentations.MatrixOperations

open ActiveFiniteChannel
open scoped ENNReal
noncomputable section
attribute [local instance] operationQuiver

private def weights : Fin 3 → NNReal := ![1 / 6, 1 / 3, 1 / 2]

private theorem weights_sum : ∑ j, weights j = 1 := by
  norm_num [weights, Fin.sum_univ_succ]

private theorem weights_ne (j : Fin 3) : (weights j : ENNReal) ≠ 0 := by
  rw [ENNReal.coe_ne_zero]
  fin_cases j <;> norm_num [weights]

private abbrev weighted : ActiveFiniteChannel Bool where
  outputCard := 3
  outputCard_pos := by decide
  channel := fun _ => PMF.ofFintype (fun j => (weights j : ENNReal))
    (by exact_mod_cast weights_sum)
  output_active j := ⟨true, weights_ne j⟩

private theorem weighted_singular : IsSingularChannel weighted.channel := by
  intro x z j _ _
  rfl

private theorem weighted_pattern (x : Bool) :
    weighted.channel x 0 ≠ 0 ↔ weighted.channel x 2 ≠ 0 :=
  ⟨fun _ => weights_ne 2, fun _ => weights_ne 0⟩

private abbrev ppSplit := pps weighted weighted_singular 2 (1 / 3)
  (by norm_num) (by norm_num)

private def ppSplitEdge : OperationStep weighted ppSplit :=
  .pps weighted weighted_singular 2 (1 / 3) (by norm_num) (by norm_num)

private abbrev ppMerge := ppm weighted weighted_singular 0 2 (by decide) weighted_pattern

private def ppMergeEdge : OperationStep weighted ppMerge :=
  .ppm weighted weighted_singular 0 2 (by decide) weighted_pattern

-- Unequal children at the final source label, with the middle column unchanged.
example (x : Bool) : ppSplit.channel x (2 : Fin 4) = ((1 / 6 : NNReal) : ENNReal) ∧
    ppSplit.channel x (3 : Fin 4) = ((1 / 3 : NNReal) : ENNReal) ∧
    ppSplit.channel x (1 : Fin 4) = ((1 / 3 : NNReal) : ENNReal) := by
  have hl := pps_left weighted weighted_singular 2 (1 / 3) (by norm_num) (by norm_num) x
  have hr := pps_right weighted weighted_singular 2 (1 / 3) (by norm_num) (by norm_num) x
  have hk := pps_keep weighted weighted_singular 2 (1 / 3) (by norm_num) (by norm_num)
    x (j := 1) (by decide)
  have hs : (1 - (1 / 3 : NNReal)) = 2 / 3 := by
    apply NNReal.coe_injective
    norm_num [NNReal.coe_sub_def]
  rw [hs] at hr
  change ppSplit.channel x (2 : Fin 4) =
    ((1 / 3 : NNReal) : ENNReal) * ((1 / 2 : NNReal) : ENNReal) at hl
  change ppSplit.channel x (3 : Fin 4) =
    ((2 / 3 : NNReal) : ENNReal) * ((1 / 2 : NNReal) : ENNReal) at hr
  refine ⟨?_, ?_, hk⟩
  · rw [hl]
    rw [← ENNReal.coe_mul]
    congr 1
    norm_num
  · rw [hr]
    rw [← ENNReal.coe_mul]
    congr 1
    norm_num

-- The PP recovery order is [old 0, old 2, old 1], visibly different from the source.
example (x : Bool) :
    (ppmRecovery weighted weighted_singular 0 2 (by decide) weighted_pattern).channel x
      (0 : Fin 3) = ((1 / 6 : NNReal) : ENNReal) ∧
    (ppmRecovery weighted weighted_singular 0 2 (by decide) weighted_pattern).channel x
      (1 : Fin 3) = ((1 / 2 : NNReal) : ENNReal) ∧
    (ppmRecovery weighted weighted_singular 0 2 (by decide) weighted_pattern).channel x
      (2 : Fin 3) = ((1 / 3 : NNReal) : ENNReal) := by
  have hl := ppmRecovery_left weighted weighted_singular 0 2 (by decide) weighted_pattern x
  have hr := ppmRecovery_right weighted weighted_singular 0 2 (by decide) weighted_pattern x
  have hk := ppmRecovery_keep weighted weighted_singular 0 2 (by decide) weighted_pattern x
    (j := (1 : Fin 2)) (by decide)
  convert And.intro hl (And.intro hr hk) using 1 <;> rfl

private abbrev deterministic : ActiveFiniteChannel (Fin 4) where
  outputCard := 4
  outputCard_pos := by decide
  channel := fun x => PMF.pure x
  output_active y := ⟨y, by simp⟩

private theorem deterministic_singular : IsSingularChannel deterministic.channel := by
  intro x z j hx hz
  simp only [deterministic, PMF.pure_apply] at hx hz ⊢
  split_ifs at hx hz ⊢ <;> simp_all

private theorem deterministic_value (j : Fin 4) :
    columnValue deterministic.channel deterministic_singular
      (deterministic.activeEquiv j) = 1 := by
  rw [columnValue_eq_of_ne_zero _ _ _ (x := j)
    (by change (PMF.pure j) j ≠ 0; simp)]
  change (PMF.pure j) j = 1
  simp

private theorem deterministic_equal :
    columnValue deterministic.channel deterministic_singular (deterministic.activeEquiv 0) =
      columnValue deterministic.channel deterministic_singular (deterministic.activeEquiv 3) := by
  rw [deterministic_value, deterministic_value]

private theorem deterministic_disjoint (x : Fin 4)
    (hx : deterministic.channel x 0 ≠ 0) : deterministic.channel x 3 = 0 := by
  simp only [deterministic, PMF.pure_apply] at hx ⊢
  split_ifs at hx ⊢ <;> simp_all
  omega

private abbrev vpMerge := vpm deterministic deterministic_singular 0 3 (by decide)
  deterministic_equal deterministic_disjoint

private def vpMergeEdge : OperationStep deterministic vpMerge :=
  .vpm deterministic deterministic_singular 0 3 (by decide)
    deterministic_equal deterministic_disjoint

private theorem vpMerge_singular : IsSingularChannel vpMerge.channel := vpMergeEdge.isSingular

private def vpMask (x : Fin 4) : Bool := decide (x = 0)

private theorem vpLeft : ∃ x, vpMerge.channel x (0 : Fin 3) ≠ 0 ∧ vpMask x = true := by
  refine ⟨0, ?_, rfl⟩
  have h := vpm_apply_survivor deterministic deterministic_singular 0 3 (by decide)
    deterministic_equal deterministic_disjoint (0 : Fin 4)
  change vpMerge.channel 0 (0 : Fin 3) = _ at h
  rw [h]
  simp [deterministic]

private theorem vpRight : ∃ x, vpMerge.channel x (0 : Fin 3) ≠ 0 ∧ vpMask x = false := by
  refine ⟨3, ?_, rfl⟩
  have h := vpm_apply_survivor deterministic deterministic_singular 0 3 (by decide)
    deterministic_equal deterministic_disjoint (3 : Fin 4)
  change vpMerge.channel 3 (0 : Fin 3) = _ at h
  rw [h]
  simp [deterministic]

private abbrev vpSplit := vps vpMerge vpMerge_singular (0 : Fin 3) vpMask vpLeft vpRight

private def vpSplitEdge : OperationStep vpMerge vpSplit :=
  .vps vpMerge vpMerge_singular (0 : Fin 3) vpMask vpLeft vpRight

-- The split acts on a value-one column and retains two other active columns.
example : columnValue vpMerge.channel vpMerge_singular (vpMerge.activeEquiv (0 : Fin 3)) = 1 := by
  have h := vpm_apply_survivor deterministic deterministic_singular 0 3 (by decide)
    deterministic_equal deterministic_disjoint (0 : Fin 4)
  change vpMerge.channel 0 (0 : Fin 3) = _ at h
  have hn : vpMerge.channel 0 (0 : Fin 3) ≠ 0 := by rw [h]; simp [deterministic]
  rw [columnValue_eq_of_ne_zero _ _ _ (x := 0) hn]
  change vpMerge.channel 0 (0 : Fin 3) = 1
  rw [h]
  simp [deterministic]

example :
    (vpmRecovery deterministic deterministic_singular 0 3 (by decide)
      deterministic_equal deterministic_disjoint).channel 0 (0 : Fin 4) = 1 ∧
    (vpmRecovery deterministic deterministic_singular 0 3 (by decide)
      deterministic_equal deterministic_disjoint).channel 3 (1 : Fin 4) = 1 ∧
    (vpmRecovery deterministic deterministic_singular 0 3 (by decide)
      deterministic_equal deterministic_disjoint).channel 1 (2 : Fin 4) = 1 := by
  refine ⟨?_, ?_, ?_⟩
  · have h := vpmRecovery_left deterministic deterministic_singular 0 3
      (by decide) deterministic_equal deterministic_disjoint (0 : Fin 4)
    change (vpmRecovery deterministic deterministic_singular 0 3 (by decide)
      deterministic_equal deterministic_disjoint).channel 0 (0 : Fin 4) =
        (PMF.pure (0 : Fin 4)) 0 at h
    exact h.trans (by simp)
  · have h := vpmRecovery_right deterministic deterministic_singular 0 3
      (by decide) deterministic_equal deterministic_disjoint (3 : Fin 4)
    change (vpmRecovery deterministic deterministic_singular 0 3 (by decide)
      deterministic_equal deterministic_disjoint).channel 3 (1 : Fin 4) =
        (PMF.pure (3 : Fin 4)) 3 at h
    exact h.trans (by simp)
  · have h := vpmRecovery_keep deterministic deterministic_singular 0 3
      (by decide) deterministic_equal deterministic_disjoint (1 : Fin 4)
      (j := (1 : Fin 3)) (by decide)
    change (vpmRecovery deterministic deterministic_singular 0 3 (by decide)
      deterministic_equal deterministic_disjoint).channel 1 (2 : Fin 4) =
        (PMF.pure (1 : Fin 4)) 1 at h
    exact h.trans (by simp)

private theorem mixed_left : ∃ x, ppSplit.channel x (0 : Fin 4) ≠ 0 ∧ x = true := by
  refine ⟨true, ?_, rfl⟩
  rw [show (0 : Fin 4) = splitKeep (2 : Fin 3) 0 from rfl,
    pps_keep weighted weighted_singular 2 (1 / 3) (by norm_num) (by norm_num)
      true (by decide)]
  exact weights_ne 0

private theorem mixed_right : ∃ x, ppSplit.channel x (0 : Fin 4) ≠ 0 ∧ x = false := by
  refine ⟨false, ?_, rfl⟩
  rw [show (0 : Fin 4) = splitKeep (2 : Fin 3) 0 from rfl,
    pps_keep weighted weighted_singular 2 (1 / 3) (by norm_num) (by norm_num)
      false (by decide)]
  exact weights_ne 0

private abbrev mixedEndpoint :=
  vps ppSplit ppSplitEdge.isSingular (0 : Fin 4) id mixed_left mixed_right

private def mixedPath : OperationPath weighted mixedEndpoint :=
  (OperationPath.nil.snoc ppSplitEdge).snoc
    (.vps ppSplit ppSplitEdge.isSingular (0 : Fin 4) id mixed_left mixed_right)

private def cycle : Fin 5 ≃ Fin 5 := recoveryPerm 0 3 (by decide)

private abbrev mixedTarget :=
  ofActive mixedEndpoint.channel cycle mixedEndpoint.output_active

private def mixedComparison : OutputEquiv mixedEndpoint mixedTarget := ⟨cycle, fun _ => rfl⟩

private def mixedCascade : Cascade weighted mixedTarget :=
  ⟨mixedEndpoint, mixedPath, mixedComparison⟩

-- The final comparison really is directed and non-involutive.
example : cycle (2 : Fin 5) = (1 : Fin 5) ∧ cycle.symm (2 : Fin 5) = (3 : Fin 5) := by
  constructor
  · apply Fin.ext; norm_num [cycle, recoveryPerm_val]
  · apply Fin.ext
    norm_num [cycle, recoveryPerm_symm_val, show (2 : Fin 5) ≠ 3 by decide]

private theorem mixed_zero : mixedEndpoint.channel true (1 : Fin 5) = 0 := by
  have h := vps_right ppSplit ppSplitEdge.isSingular (0 : Fin 4) id mixed_left mixed_right true
  exact h.trans rfl

private theorem mixed_sixth : mixedEndpoint.channel true (3 : Fin 5) =
    ((1 / 6 : NNReal) : ENNReal) := by
  have hk := vps_keep ppSplit ppSplitEdge.isSingular (0 : Fin 4) id mixed_left mixed_right true
    (j := (2 : Fin 4)) (by change (2 : Fin 4) ≠ 0; decide)
  have hl := pps_left weighted weighted_singular 2 (1 / 3) (by norm_num) (by norm_num) true
  change mixedEndpoint.channel true (3 : Fin 5) = ppSplit.channel true (2 : Fin 4) at hk
  change ppSplit.channel true (2 : Fin 4) =
    ((1 / 3 : NNReal) : ENNReal) * ((1 / 2 : NNReal) : ENNReal) at hl
  rw [hk, hl]
  change ((1 / 3 : NNReal) : ENNReal) * ((1 / 2 : NNReal) : ENNReal) = _
  rw [← ENNReal.coe_mul]
  congr 1
  norm_num

example : mixedTarget.channel true (2 : Fin 5) = ((1 / 6 : NNReal) : ENNReal) := by
  have hc : cycle (3 : Fin 5) = (2 : Fin 5) := by
    apply Fin.ext; norm_num [cycle, recoveryPerm_val]
  have h := mixedComparison.apply true (3 : Fin 5)
  change mixedTarget.channel true (cycle (3 : Fin 5)) = mixedEndpoint.channel true (3 : Fin 5) at h
  rw [hc, mixed_sixth] at h
  exact h

example : (mixedEndpoint.channel true).map cycle.symm ≠ mixedTarget.channel true := by
  intro h
  have hc : cycle.symm (1 : Fin 5) = (2 : Fin 5) := by
    apply Fin.ext
    norm_num [cycle, recoveryPerm_symm_val, show (1 : Fin 5) ≠ 3 by decide]
  have hf : cycle (3 : Fin 5) = (2 : Fin 5) := by
    apply Fin.ext; norm_num [cycle, recoveryPerm_val]
  have hwrong := PMF.map_apply_equiv (mixedEndpoint.channel true) cycle.symm (1 : Fin 5)
  have hright := mixedComparison.apply true (3 : Fin 5)
  change ((mixedEndpoint.channel true).map cycle.symm) (cycle.symm (1 : Fin 5)) =
    mixedEndpoint.channel true (1 : Fin 5) at hwrong
  change mixedTarget.channel true (cycle (3 : Fin 5)) =
    mixedEndpoint.channel true (3 : Fin 5) at hright
  rw [hc, h, mixed_zero] at hwrong
  rw [hf, mixed_sixth] at hright
  have he := hwrong.symm.trans hright
  exact (ENNReal.coe_ne_zero.mpr (by norm_num : (1 / 6 : NNReal) ≠ 0)) he.symm

-- Public C03 labels are retained so the negative fold starts at its actual counterexample.
private abbrev nonperfect : ActiveFiniteChannel (Fin 3) where
  outputCard := 3
  outputCard_pos := by decide
  channel := nonrepresentable3x3
  output_active := by
    intro j
    fin_cases j
    · exact ⟨0, by norm_num [nonrepresentable3x3_apply]⟩
    · exact ⟨0, by norm_num [nonrepresentable3x3_apply]⟩
    · exact ⟨1, by norm_num [nonrepresentable3x3_apply]⟩

private abbrev nonperfectSplit := pps nonperfect nonrepresentable3x3_isSingular 0
  (1 / 3) (by norm_num) (by norm_num)

private def negativePath : OperationPath nonperfect nonperfectSplit :=
  OperationPath.nil.snoc (.pps nonperfect nonrepresentable3x3_isSingular 0
    (1 / 3) (by norm_num) (by norm_num))

-- R01: both directions include the singleton seed and generic nil propagation
-- still consumes its source singularity premise.
example : FromAllOnes (allOnes (Fin 1)) := fromAllOnes_allOnes
example : ToAllOnes (allOnes (Fin 1)) := toAllOnes_allOnes

example {alpha : Type*} [Finite alpha] [Nonempty alpha]
    (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel) :
    IsSingularChannel S.channel := (OperationPath.nil : OperationPath S S).isSingular hS

example {alpha : Type*} [Finite alpha] [Nonempty alpha]
    (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel) :
    IsSingularChannel S.channel := (Cascade.refl S).isSingular hS

example : (Cascade.ofOutputEquiv mixedComparison).path.tags = [] := rfl

example : (Cascade.ofOutputEquiv mixedComparison).reverse.path.tags = [] ∧
    (Cascade.ofOutputEquiv mixedComparison).reverse.outputEquiv.equiv (2 : Fin 5) =
      (3 : Fin 5) := by
  constructor
  · rw [Cascade.tags_reverse]
    rfl
  · change cycle.symm (2 : Fin 5) = (3 : Fin 5)
    apply Fin.ext
    norm_num [cycle, recoveryPerm_symm_val, show (2 : Fin 5) ≠ 3 by decide]

example {alpha : Type*} [Finite alpha] [Nonempty alpha]
    {S T : ActiveFiniteChannel alpha} (e : OutputEquiv S T)
    (hfrom : FromAllOnes S) (hto : ToAllOnes S) : FromAllOnes T ∧ ToAllOnes T :=
  ⟨hfrom.outputEquiv e, hto.outputEquiv e⟩

-- R02: the new one-edge constructor keeps each actual remembered recovery.
example : ppSplitEdge.reverse.endpoint =
    ppsRecovery weighted weighted_singular 2 (1 / 3) (by norm_num) (by norm_num) := rfl
example : ppMergeEdge.reverse.endpoint =
    ppmRecovery weighted weighted_singular 0 2 (by decide) weighted_pattern := rfl
example : vpSplitEdge.reverse.endpoint =
    vpsRecovery vpMerge vpMerge_singular (0 : Fin 3) vpMask vpLeft vpRight := rfl
example : vpMergeEdge.reverse.endpoint =
    vpmRecovery deterministic deterministic_singular 0 3 (by decide)
      deterministic_equal deterministic_disjoint := rfl

example : ppSplitEdge.reverse.path.tags = [.ppm] ∧
    ppMergeEdge.reverse.path.tags = [.pps] ∧
    vpSplitEdge.reverse.path.tags = [.vpm] ∧ vpMergeEdge.reverse.path.tags = [.vps] :=
  ⟨rfl, rfl, rfl, rfl⟩

private def lastRatio {alpha : Type*} [Finite alpha] [Nonempty alpha]
    {S : ActiveFiniteChannel alpha} :
    {T : ActiveFiniteChannel alpha} → OperationPath S T → Option NNReal
  | _, .nil => none
  | _, .cons _ e => match e with
    | .pps _ _ _ t _ _ => some t
    | .vps .. | .ppm .. | .vpm .. => none

private theorem weighted_value (j : Fin 3) :
    columnValue weighted.channel weighted_singular (weighted.activeEquiv j) = weights j :=
  columnValue_eq_of_ne_zero _ _ _ (x := true) (weights_ne j)

example : lastRatio ppMergeEdge.reverse.path = some (1 / 4) := by
  change some (ppmRatio weighted weighted_singular 0 2) = some (1 / 4)
  congr 1
  unfold ppmRatio
  erw [weighted_value (0 : Fin 3), weighted_value (2 : Fin 3)]
  rw [← ENNReal.coe_add, ENNReal.toNNReal_coe, ENNReal.toNNReal_coe]
  change (1 / 6 : NNReal) / (1 / 6 + 1 / 2) = 1 / 4
  norm_num

-- Every reversed endpoint is checked against the independent numeric source.
example (x : Bool) :
    (ppSplitEdge.reverse.endpoint.channel x).map ppSplitEdge.reverse.outputEquiv.equiv =
      PMF.ofFintype (fun j : Fin 3 =>
        ((![1 / 6, 1 / 3, 1 / 2] j : NNReal) : ENNReal))
        (by exact_mod_cast weights_sum) := ppSplitEdge.reverse.outputEquiv.map_eq x

example (x : Bool) :
    (ppMergeEdge.reverse.endpoint.channel x).map ppMergeEdge.reverse.outputEquiv.equiv =
      PMF.ofFintype (fun j : Fin 3 =>
        ((![1 / 6, 1 / 3, 1 / 2] j : NNReal) : ENNReal))
        (by exact_mod_cast weights_sum) := ppMergeEdge.reverse.outputEquiv.map_eq x

example (x : Fin 4) :
    (vpMergeEdge.reverse.endpoint.channel x).map vpMergeEdge.reverse.outputEquiv.equiv =
      PMF.pure x := vpMergeEdge.reverse.outputEquiv.map_eq x

example : vpSplitEdge.reverse.endpoint.channel (0 : Fin 4)
      (vpSplitEdge.reverse.outputEquiv.equiv.symm (0 : Fin 3)) = 1 ∧
    vpSplitEdge.reverse.endpoint.channel (1 : Fin 4)
      (vpSplitEdge.reverse.outputEquiv.equiv.symm (1 : Fin 3)) = 1 := by
  constructor
  · apply (vpSplitEdge.reverse.outputEquiv.apply_symm (0 : Fin 4) (0 : Fin 3)).trans
    have h := vpm_apply_survivor deterministic deterministic_singular 0 3 (by decide)
      deterministic_equal deterministic_disjoint (0 : Fin 4)
    change vpMerge.channel 0 (0 : Fin 3) = _ at h
    rw [h]
    simp [deterministic]
  · apply (vpSplitEdge.reverse.outputEquiv.apply_symm (1 : Fin 4) (1 : Fin 3)).trans
    have h := vpm_apply_unaffected deterministic deterministic_singular 0 3 (by decide)
      deterministic_equal deterministic_disjoint (1 : Fin 4) (j := (1 : Fin 3)) (by decide)
    change vpMerge.channel 1 (1 : Fin 3) = (PMF.pure (1 : Fin 4)) 1 at h
    simpa using h

-- R03: reversed chronology swaps both kinds and preserves two real operations.
example : weighted.outputCard = 3 ∧ ppSplit.outputCard = 4 ∧ mixedEndpoint.outputCard = 5 :=
  ⟨rfl, rfl, rfl⟩

example : mixedCascade.path.tags = [.pps, .vps] ∧
    mixedCascade.reverse.path.tags = [.vpm, .ppm] ∧
    mixedCascade.reverse.path.length = 2 := by
  refine ⟨rfl, ?_, ?_⟩
  · rw [Cascade.tags_reverse]
    rfl
  · rw [Cascade.length_reverse]
    rfl

example (x : Bool) (j : Fin 3) :
    mixedCascade.reverse.endpoint.channel x
      (mixedCascade.reverse.outputEquiv.equiv.symm j) =
      ((![1 / 6, 1 / 3, 1 / 2] j : NNReal) : ENNReal) :=
  mixedCascade.reverse.outputEquiv.apply_symm x j

-- R04: the generic folds consume just their respective restriction and source
-- property; no singularity or input prior is added to either public signature.
private theorem seedLeft : ∃ x, (allOnes Bool).channel x (0 : Fin 1) ≠ 0 ∧ x = true :=
  ⟨true, by change (PMF.pure (0 : Fin 1)) 0 ≠ 0; simp, rfl⟩

private theorem seedRight : ∃ x, (allOnes Bool).channel x (0 : Fin 1) ≠ 0 ∧ x = false :=
  ⟨false, by change (PMF.pure (0 : Fin 1)) 0 ≠ 0; simp, rfl⟩

private abbrev seedVP :=
  vps (allOnes Bool) (allOnes_isSingular Bool) (0 : Fin 1) id seedLeft seedRight

private def seedVPEdge : OperationStep (allOnes Bool) seedVP :=
  .vps (allOnes Bool) (allOnes_isSingular Bool) (0 : Fin 1) id seedLeft seedRight

private abbrev seedPP := pps seedVP seedVPEdge.isSingular (0 : Fin 2) (1 / 3)
  (by norm_num) (by norm_num)

private def seedPath : OperationPath (allOnes Bool) seedPP :=
  (OperationPath.nil.snoc seedVPEdge).snoc
    (.pps seedVP seedVPEdge.isSingular (0 : Fin 2) (1 / 3) (by norm_num) (by norm_num))

private theorem seedNormalizing : seedPath.Normalizing := by
  change ∀ k ∈ [OperationKind.vps, .pps], k = .pps ∨ k = .vps ∨ k = .ppm
  simp

private theorem seedReachable : FromAllOnes seedPP := ⟨Cascade.ofPath seedPath, seedNormalizing⟩

example : seedPP.outputCard = 3 ∧ FromAllOnes seedPP ∧ ToAllOnes seedPP ∧
    IsPerfectlyRepresentableChannel seedPP.channel :=
  ⟨rfl, seedReachable, fromAllOnes_iff_toAllOnes.mp seedReachable,
    seedPath.isPerfectlyRepresentable seedNormalizing (allOnes_isPerfectlyRepresentable Bool)⟩

example : seedPath.reverse.path.Reducing ∧ seedPath.reverse.path.tags = [.ppm, .vpm] := by
  refine ⟨seedPath.reverse_reducing.mpr seedNormalizing, ?_⟩
  rw [OperationPath.tags_reverse]
  rfl

example {alpha : Type*} [Finite alpha] [Nonempty alpha]
    {S T : ActiveFiniteChannel alpha} (p : OperationPath S T) (hp : p.Normalizing)
    (hS : IsPerfectlyRepresentableChannel S.channel) :
    IsPerfectlyRepresentableChannel T.channel := p.isPerfectlyRepresentable hp hS

example {alpha : Type*} [Finite alpha] [Nonempty alpha]
    {S T : ActiveFiniteChannel alpha} (c : Cascade S T) (hc : c.path.Normalizing)
    (hS : IsPerfectlyRepresentableChannel S.channel) :
    IsPerfectlyRepresentableChannel T.channel := c.isPerfectlyRepresentable hc hS

private theorem negative_allowed : negativePath.Reducing := by
  change ∀ k ∈ [OperationKind.pps], k = .ppm ∨ k = .pps ∨ k = .vpm
  simp

example : ¬ IsPerfectlyRepresentableChannel nonperfectSplit.channel :=
  negativePath.not_isPerfectlyRepresentable negative_allowed
    nonrepresentable3x3_not_isPerfectlyRepresentableChannel

example : ¬ IsPerfectlyRepresentableChannel nonperfectSplit.channel :=
  (Cascade.ofPath negativePath).not_isPerfectlyRepresentable negative_allowed
    nonrepresentable3x3_not_isPerfectlyRepresentableChannel

example {alpha : Type*} [Finite alpha] [Nonempty alpha]
    {S T : ActiveFiniteChannel alpha} (c : Cascade S T) (hc : c.path.Reducing)
    (hT : IsPerfectlyRepresentableChannel T.channel) :
    IsPerfectlyRepresentableChannel S.channel := c.reflects_isPerfectlyRepresentable hc hT

example {alpha : Type*} [Finite alpha] [Nonempty alpha]
    {S : ActiveFiniteChannel alpha} (h : FromAllOnes S) :
    IsPerfectlyRepresentableChannel S.channel ∧ IsSingularChannel S.channel :=
  ⟨h.isPerfectlyRepresentable, h.isSingular⟩

example {alpha : Type*} [Finite alpha] [Nonempty alpha]
    {S : ActiveFiniteChannel alpha} (h : ToAllOnes S) :
    IsPerfectlyRepresentableChannel S.channel ∧ IsSingularChannel S.channel :=
  ⟨h.isPerfectlyRepresentable, h.isSingular⟩

example {alpha : Type*} [Finite alpha] [Nonempty alpha] (S : ActiveFiniteChannel alpha) :
    FromAllOnes S ↔ ToAllOnes S := fromAllOnes_iff_toAllOnes

example : ¬ FromAllOnes nonperfect ∧ ¬ ToAllOnes nonperfect := by
  constructor <;> intro h <;>
    exact nonrepresentable3x3_not_isPerfectlyRepresentableChannel h.isPerfectlyRepresentable

example : ¬ (OperationPath.nil.snoc vpMergeEdge).Normalizing := by
  change ¬ (∀ k ∈ [OperationKind.vpm], k = .pps ∨ k = .vps ∨ k = .ppm)
  decide

example : ¬ (OperationPath.nil.snoc vpSplitEdge).Reducing := by
  change ¬ (∀ k ∈ [OperationKind.vps], k = .ppm ∨ k = .pps ∨ k = .vpm)
  decide

end
end PerfectFunctionalRepresentations.MatrixOperations
