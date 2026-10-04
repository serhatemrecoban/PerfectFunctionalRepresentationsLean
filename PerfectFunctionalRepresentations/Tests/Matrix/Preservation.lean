import PerfectFunctionalRepresentations.Matrix.Preservation
import PerfectFunctionalRepresentations.Matrix.OperationPaths
import PerfectFunctionalRepresentations.Examples.Nonrepresentable3x3

/-!
# Preservation API consumers

C09 S01: R01 checks singleton and multiple input rows, the rectangular all-ones
coordinates, and existing finite/active/ambient transports. R02-R04's concrete
whole-vector checks live beside the private PPS witness in Preservation.
The consumers below check the public PPS/PPM/VPS signatures and their arbitrary-prior
canonical-coupling consequences without exposing those private constructions.
S02's R05-R07 concrete checks live beside the private PPM witness; external
consumers also check active presentation and the remembered recovery interface.
S03's R08-R10 inspect the private VPS witness, legal value-one split and support-only
mask irrelevance; external consumers check its full witness and canonical handoff.
S04's R11-R14 consume the three negative implications, exact remembered recoveries,
the public counterexample, value-one VPM recovery and directed C08/C06 transports.
-/

namespace PerfectFunctionalRepresentations

open ActiveFiniteChannel MatrixOperations

noncomputable section

example : (allOnes (Fin 1)).outputCard = 1 := allOnes_outputCard _
example : (allOnes (Fin 3)).outputCard = 1 := allOnes_outputCard _
example : massMatrix (allOnes (Fin 1)).channel = fun _ _ => 1 := allOnes_massMatrix _
example : massMatrix (allOnes (Fin 3)).channel = fun _ _ => 1 := allOnes_massMatrix _
example : realMatrix (allOnes (Fin 1)).channel = fun _ _ => 1 := allOnes_realMatrix _
example : realMatrix (allOnes (Fin 3)).channel = fun _ _ => 1 := allOnes_realMatrix _
example : IsSingularChannel (allOnes (Fin 3)).channel := allOnes_isSingular _
example : IsPerfectlyRepresentableChannel (allOnes (Fin 1)).channel :=
  allOnes_isPerfectlyRepresentable _
example : IsPerfectlyRepresentableChannel (allOnes (Fin 3)).channel :=
  allOnes_isPerfectlyRepresentable _

example : IsPerfectlyRepresentableChannel
    (ofActive (allOnes (Fin 3)).channel (Equiv.refl (Fin 1))
      (allOnes (Fin 3)).output_active).channel :=
  (isPerfectlyRepresentableChannel_ofActive_iff _ _ _).2
    (allOnes_isPerfectlyRepresentable _)

example : IsPerfectlyRepresentableChannel
    (ofChannel (allOnes (Fin 3)).channel).channel :=
  (isPerfectlyRepresentableChannel_ofChannel_iff _).2
    (allOnes_isPerfectlyRepresentable _)

private def seedAmbient : Fin 3 → PMF (Fin 3) :=
  fun x => ((allOnes (Fin 3)).channel x).map (fun _ : Fin 1 => (2 : Fin 3))

example (x : Fin 3) : seedAmbient x 0 = 0 ∧ seedAmbient x 1 = 0 ∧ seedAmbient x 2 = 1 := by
  change ((PMF.pure (0 : Fin 1)).map (fun _ => (2 : Fin 3))) 0 = 0 ∧
    ((PMF.pure (0 : Fin 1)).map (fun _ => (2 : Fin 3))) 1 = 0 ∧
    ((PMF.pure (0 : Fin 1)).map (fun _ => (2 : Fin 3))) 2 = 1
  simp [PMF.pure_map]

private theorem seedAmbient_perfect : IsPerfectlyRepresentableChannel seedAmbient :=
  (isPerfectlyRepresentableChannel_map_iff (allOnes (Fin 3)).channel
    (fun _ : Fin 1 => (2 : Fin 3))
    (fun a b _ => @Subsingleton.elim (Fin 1) inferInstance a b)).2
      (allOnes_isPerfectlyRepresentable _)

example : IsPerfectlyRepresentableChannel (ofChannel seedAmbient).channel :=
  (isPerfectlyRepresentableChannel_ofChannel_iff _).2 seedAmbient_perfect

-- The active seed intentionally requires a nonempty input alphabet. Empty raw
-- channels remain covered at the existing C06 boundary.
example {alpha : Type*} [Finite alpha] [Nonempty alpha]
    (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1)
    (hP : IsPerfectlyRepresentableChannel S.channel) :
    IsPerfectlyRepresentableChannel (pps S hS l t ht0 ht1).channel :=
  pps_isPerfectlyRepresentable S hS l t ht0 ht1 hP

example {alpha : Type*} [Fintype alpha] [DecidableEq alpha] [Nonempty alpha]
    (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1)
    (hP : IsPerfectlyRepresentableChannel S.channel) :
    ∃ q, IsCanonicalCoupling (pps S hS l t ht0 ht1).channel q ∧
      ∀ p : PMF alpha, IsPerfectFunctionalRepresentation (canonicalJoint p q) := by
  classical
  exact (pps_isPerfectlyRepresentable S hS l t ht0 ht1 hP).exists_canonicalCoupling

-- S02: exact public endpoint, full witness, canonical handoff and remembered recovery.
section PPMConsumers
variable {alpha : Type*} [Finite alpha] [Nonempty alpha]
variable (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
  (a b : Fin S.outputCard) (hab : a < b)
  (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0)
  (hP : IsPerfectlyRepresentableChannel S.channel)

example : IsPerfectlyRepresentableChannel (ppm S hS a b hab hp).channel :=
  ppm_isPerfectlyRepresentable S hS a b hab hp hP

example : ∃ q : PMF (alpha → Fin (S.outputCard - 1)),
    ∃ V : Fin (S.outputCard - 1) → PMF (alpha → Fin (S.outputCard - 1)),
      ∀ x, q.map (fun w => (w x, w)) =
        PMF.channelJoint ((ppm S hS a b hab hp).channel x) V :=
  ppm_isPerfectlyRepresentable S hS a b hab hp hP

example : IsPerfectlyRepresentableChannel
    (ofChannel (ppm S hS a b hab hp).channel).channel :=
  (isPerfectlyRepresentableChannel_ofChannel_iff _).2
    (ppm_isPerfectlyRepresentable S hS a b hab hp hP)

-- Compose the two implemented positive results and consume C07's directed
-- recovered-to-original row equality. No nonperfectness implication is asserted.
example : IsPerfectlyRepresentableChannel (ppmRecovery S hS a b hab hp).channel ∧
    ∀ x, ((ppmRecovery S hS a b hab hp).channel x).map
      (ppmRecoveryEquiv S hS a b hab hp) = S.channel x := by
  refine ⟨?_, ppmRecovery_channel S hS a b hab hp⟩
  exact pps_isPerfectlyRepresentable (ppm S hS a b hab hp)
    (ppm_isSingular S hS a b hab hp) (activeMergeSurvivor S a b hab)
    (ppmRatio S hS a b) (ppmRatio_pos S hS a b) (ppmRatio_lt_one S hS a b)
    (ppm_isPerfectlyRepresentable S hS a b hab hp hP)

end PPMConsumers

example {alpha : Type*} [Fintype alpha] [DecidableEq alpha] [Nonempty alpha]
    (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0)
    (hP : IsPerfectlyRepresentableChannel S.channel) :
    ∃ q, IsCanonicalCoupling (ppm S hS a b hab hp).channel q ∧
      ∀ p : PMF alpha, IsPerfectFunctionalRepresentation (canonicalJoint p q) := by
  classical
  exact (ppm_isPerfectlyRepresentable S hS a b hab hp hP).exists_canonicalCoupling

end
end PerfectFunctionalRepresentations

-- S03: actual legal VPS endpoint, complete witness, active presentation and all priors.
namespace PerfectFunctionalRepresentations
open ActiveFiniteChannel MatrixOperations
noncomputable section

section VPSConsumers
variable {alpha : Type*} [Finite alpha] [Nonempty alpha]
variable (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
  (l : Fin S.outputCard) (mask : alpha → Bool)
  (hl : ∃ x, S.channel x l ≠ 0 ∧ mask x = true)
  (hr : ∃ x, S.channel x l ≠ 0 ∧ mask x = false)
  (hP : IsPerfectlyRepresentableChannel S.channel)

example : IsPerfectlyRepresentableChannel (vps S hS l mask hl hr).channel :=
  vps_isPerfectlyRepresentable S hS l mask hl hr hP

example : ∃ q : PMF (alpha → Fin (S.outputCard + 1)),
    ∃ V : Fin (S.outputCard + 1) → PMF (alpha → Fin (S.outputCard + 1)),
      ∀ x, q.map (fun w => (w x,w)) = PMF.channelJoint ((vps S hS l mask hl hr).channel x) V :=
  vps_isPerfectlyRepresentable S hS l mask hl hr hP

example : IsPerfectlyRepresentableChannel (ofChannel (vps S hS l mask hl hr).channel).channel :=
  (isPerfectlyRepresentableChannel_ofChannel_iff _).2
    (vps_isPerfectlyRepresentable S hS l mask hl hr hP)
end VPSConsumers

example {alpha : Type*} [Fintype alpha] [DecidableEq alpha] [Nonempty alpha]
    (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (mask : alpha → Bool)
    (hl : ∃ x, S.channel x l ≠ 0 ∧ mask x = true)
    (hr : ∃ x, S.channel x l ≠ 0 ∧ mask x = false)
    (hP : IsPerfectlyRepresentableChannel S.channel) :
    ∃ q, IsCanonicalCoupling (vps S hS l mask hl hr).channel q ∧
      ∀ p : PMF alpha, IsPerfectFunctionalRepresentation (canonicalJoint p q) := by
  classical
  exact (vps_isPerfectlyRepresentable S hS l mask hl hr hP).exists_canonicalCoupling

end
end PerfectFunctionalRepresentations

namespace PerfectFunctionalRepresentations.MatrixOperations
open ActiveFiniteChannel
open scoped ENNReal
noncomputable section

-- R11: reconstruct the actual remembered operation and its directed comparison.
section Recoveries
variable {alpha : Type*} [Finite alpha] [Nonempty alpha]
  (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)

example (l : Fin S.outputCard) (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1) :
    ppm (pps S hS l t ht0 ht1) (pps_isSingular S hS l t ht0 ht1)
      (splitLeft l) (splitRight l) Fin.castSucc_lt_succ
      (pps_children_sameSupport S hS l t ht0 ht1) = ppsRecovery S hS l t ht0 ht1 := rfl

example (l : Fin S.outputCard) (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1) (x : alpha) :
    ((ppsRecovery S hS l t ht0 ht1).channel x).map
      (finCongr (ppsRecovery_outputCard S hS l t ht0 ht1)) = S.channel x :=
  ppsRecovery_channel S hS l t ht0 ht1 x

example (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) :
    pps (ppm S hS a b hab hp) (ppm_isSingular S hS a b hab hp)
      (activeMergeSurvivor S a b hab) (ppmRatio S hS a b)
      (ppmRatio_pos S hS a b) (ppmRatio_lt_one S hS a b) =
      ppmRecovery S hS a b hab hp := rfl

example (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) (x : alpha) :
    ((ppmRecovery S hS a b hab hp).channel x).map (ppmRecoveryEquiv S hS a b hab hp) =
      S.channel x ∧
    (S.channel x).map (ppmRecoveryEquiv S hS a b hab hp).symm =
      (ppmRecovery S hS a b hab hp).channel x :=
  ⟨ppmRecovery_channel S hS a b hab hp x, ppmRecovery_channel_inverse S hS a b hab hp x⟩

example (a b : Fin S.outputCard) (hab : a < b)
    (hv : columnValue S.channel hS (S.activeEquiv a) =
      columnValue S.channel hS (S.activeEquiv b))
    (hd : ∀ x, S.channel x a ≠ 0 → S.channel x b = 0) :
    vps (vpm S hS a b hab hv hd) (vpm_isSingular S hS a b hab hv hd)
      (activeMergeSurvivor S a b hab) (vpmRecoveryMask S a)
      (vpmRecovery_leftWitness S hS a b hab hv hd)
      (vpmRecovery_rightWitness S hS a b hab hv hd) =
      vpmRecovery S hS a b hab hv hd := rfl

example (a b : Fin S.outputCard) (hab : a < b)
    (hv : columnValue S.channel hS (S.activeEquiv a) =
      columnValue S.channel hS (S.activeEquiv b))
    (hd : ∀ x, S.channel x a ≠ 0 → S.channel x b = 0) (x : alpha) :
    ((vpmRecovery S hS a b hab hv hd).channel x).map (vpmRecoveryEquiv S hS a b hab hv hd) =
      S.channel x ∧
    (S.channel x).map (vpmRecoveryEquiv S hS a b hab hv hd).symm =
      (vpmRecovery S hS a b hab hv hd).channel x :=
  ⟨vpmRecovery_channel S hS a b hab hv hd x,
    vpmRecovery_channel_inverse S hS a b hab hv hd x⟩
end Recoveries

-- R12: use the public C03 channel, preserving its original labels.
private abbrev r12State : ActiveFiniteChannel (Fin 3) where
  outputCard := 3
  outputCard_pos := by decide
  channel := nonrepresentable3x3
  output_active := by
    intro j
    fin_cases j
    · exact ⟨0, by norm_num [nonrepresentable3x3_apply]⟩
    · exact ⟨0, by norm_num [nonrepresentable3x3_apply]⟩
    · exact ⟨1, by norm_num [nonrepresentable3x3_apply]⟩

private def r12Weight : NNReal := 1/3
private theorem r12Weight_pos : 0 < r12Weight := by norm_num [r12Weight]
private theorem r12Weight_lt : r12Weight < 1 := by norm_num [r12Weight]
private theorem r12Complement : (1-r12Weight : NNReal) = 2/3 := by
  apply NNReal.coe_injective
  norm_num [r12Weight, NNReal.coe_sub_def]
private abbrev r12Split : ActiveFiniteChannel (Fin 3) :=
  pps r12State nonrepresentable3x3_isSingular 0 r12Weight r12Weight_pos r12Weight_lt
private theorem r12Split_singular : IsSingularChannel r12Split.channel :=
  pps_isSingular r12State nonrepresentable3x3_isSingular 0
    r12Weight r12Weight_pos r12Weight_lt
private theorem r12Pattern (x : Fin 3) :
    r12Split.channel x (0 : Fin 4) ≠ 0 ↔ r12Split.channel x (1 : Fin 4) ≠ 0 :=
  pps_children_sameSupport r12State nonrepresentable3x3_isSingular 0
    r12Weight r12Weight_pos r12Weight_lt x
private abbrev r12Merge : ActiveFiniteChannel (Fin 3) :=
  ppm r12Split r12Split_singular (0 : Fin 4) (1 : Fin 4) (by decide) r12Pattern

private theorem r12Left (x : Fin 3) : r12Split.channel x (0 : Fin 4) =
    (r12Weight : ENNReal) * nonrepresentable3x3 x 0 :=
  pps_left r12State nonrepresentable3x3_isSingular 0
    r12Weight r12Weight_pos r12Weight_lt x
private theorem r12Right (x : Fin 3) : r12Split.channel x (1 : Fin 4) =
    ((1 - r12Weight : NNReal) : ENNReal) * nonrepresentable3x3 x 0 :=
  pps_right r12State nonrepresentable3x3_isSingular 0
    r12Weight r12Weight_pos r12Weight_lt x

private theorem r12ChildMass : r12Split.channel 0 (0 : Fin 4) = (1 : ENNReal)/6 ∧
    r12Split.channel 0 (1 : Fin 4) = (1 : ENNReal)/3 ∧
    r12Split.channel 2 (0 : Fin 4) = 0 ∧ r12Split.channel 2 (1 : Fin 4) = 0 := by
  rw [r12Left, r12Right, r12Left, r12Right, r12Complement]
  norm_num [nonrepresentable3x3_apply, r12Weight]
  constructor
  · calc
      _ = (((1/3 : NNReal) * (1/2 : NNReal) : NNReal) : ENNReal) := by
        simp only [ENNReal.coe_mul, one_div, ENNReal.coe_inv (by norm_num : (3 : NNReal) ≠ 0),
          ENNReal.coe_inv (by norm_num : (2 : NNReal) ≠ 0), ENNReal.coe_ofNat]
      _ = ((1/6 : NNReal) : ENNReal) := congrArg (fun a : NNReal => (a : ENNReal)) (by norm_num)
      _ = _ := by norm_num [ENNReal.coe_div]
  · calc
      _ = (((2/3 : NNReal) * (1/2 : NNReal) : NNReal) : ENNReal) := by
        simp only [ENNReal.coe_mul, ENNReal.coe_div (by norm_num : (3 : NNReal) ≠ 0),
          one_div, ENNReal.coe_inv (by norm_num : (2 : NNReal) ≠ 0), ENNReal.coe_ofNat]
      _ = ((1/3 : NNReal) : ENNReal) := congrArg (fun a : NNReal => (a : ENNReal)) (by norm_num)
      _ = _ := by norm_num [ENNReal.coe_div]

example : r12Split.channel 0 (0 : Fin 4) = (1 : ENNReal)/6 ∧
    r12Split.channel 0 (1 : Fin 4) = (1 : ENNReal)/3 ∧
    r12Split.channel 2 (0 : Fin 4) = 0 ∧ r12Split.channel 2 (1 : Fin 4) = 0 := r12ChildMass

example : r12Split.channel 0 (0 : Fin 4) ≠ r12Split.channel 0 (1 : Fin 4) := by
  rw [r12ChildMass.1, r12ChildMass.2.1]
  norm_num

example (x : Fin 3) : r12Merge.channel x = nonrepresentable3x3 x := by
  have h := ppsRecovery_channel r12State nonrepresentable3x3_isSingular 0
    r12Weight r12Weight_pos r12Weight_lt x
  change (r12Merge.channel x).map id = nonrepresentable3x3 x at h
  simpa only [PMF.map_id] using h

-- R13: value-one disjoint columns, final label, and an asymmetric recovery.
private abbrev r13State : ActiveFiniteChannel (Fin 4) where
  outputCard := 4
  outputCard_pos := by decide
  channel := fun x => PMF.pure x
  output_active := fun j => ⟨j, by simp⟩
private theorem r13Singular : IsSingularChannel r13State.channel := by
  intro x z y hx hz
  change (PMF.pure x) y = (PMF.pure z) y
  change (PMF.pure x) y ≠ 0 at hx
  change (PMF.pure z) y ≠ 0 at hz
  simp only [PMF.pure_apply] at hx hz ⊢
  split_ifs at hx hz ⊢ <;> simp_all

private theorem r13Value (j : Fin 4) :
    columnValue r13State.channel r13Singular (r13State.activeEquiv j) = 1 := by
  rw [columnValue_eq_of_ne_zero _ _ _ (x := j) (by change (PMF.pure j) j ≠ 0; simp)]
  exact PMF.pure_apply_self j
private theorem r13Values :
    columnValue r13State.channel r13Singular (r13State.activeEquiv 0) =
      columnValue r13State.channel r13Singular (r13State.activeEquiv 3) := by
  rw [r13Value, r13Value]
private theorem r13Disjoint (x : Fin 4) (hx : r13State.channel x 0 ≠ 0) :
    r13State.channel x 3 = 0 := by
  fin_cases x <;> simp_all [r13State]
private abbrev r13Merge : ActiveFiniteChannel (Fin 4) :=
  vpm r13State r13Singular 0 3 (by decide) r13Values r13Disjoint
private abbrev r13Recovery : ActiveFiniteChannel (Fin 4) :=
  vpmRecovery r13State r13Singular 0 3 (by decide) r13Values r13Disjoint
private def r13Comparison : OutputEquiv r13Recovery r13State where
  equiv := vpmRecoveryEquiv r13State r13Singular 0 3 (by decide) r13Values r13Disjoint
  map_eq := vpmRecovery_channel r13State r13Singular 0 3 (by decide) r13Values r13Disjoint

example : columnValue r13Merge.channel (vpm_isSingular _ _ _ _ _ _ _)
    (r13Merge.activeEquiv (activeMergeSurvivor r13State 0 3 (by decide))) = 1 :=
  (columnValue_vpm_survivor _ _ _ _ _ _ _).trans (r13Value 0)

example : r13Recovery = vps r13Merge (vpm_isSingular _ _ _ _ _ _ _)
    (activeMergeSurvivor r13State 0 3 (by decide)) (vpmRecoveryMask r13State 0)
    (vpmRecovery_leftWitness _ _ _ _ _ _ _) (vpmRecovery_rightWitness _ _ _ _ _ _ _) := rfl

example (x : Fin 4) : vpmRecoveryMask r13State 0 x = decide (x = 0) := by
  simp [vpmRecoveryMask, r13State, PMF.pure_apply, eq_comm]

example (x : Fin 4) :
    (r13Recovery.channel x).map r13Comparison.equiv = r13State.channel x ∧
    (r13State.channel x).map r13Comparison.equiv.symm = r13Recovery.channel x :=
  ⟨r13Comparison.map_eq x, r13Comparison.symm.map_eq x⟩

example : (r13Comparison.equiv (1 : Fin 4)).val = 3 ∧
    (r13Comparison.equiv.symm (1 : Fin 4)).val = 2 := by
  constructor
  · change (recoveryPerm (0 : Fin 4) 3 (by decide) 1).val = 3
    norm_num [recoveryPerm_val]
  · change ((recoveryPerm (0 : Fin 4) 3 (by decide)).symm 1).val = 2
    norm_num [recoveryPerm_symm_val, show (1 : Fin 4) ≠ 3 by decide]

-- R14: directed C08 output equivalence and C06 finite/ambient transports.
private theorem r14OutputIff {alpha : Type*} [Finite alpha] [Nonempty alpha]
    {S T : ActiveFiniteChannel alpha} (e : OutputEquiv S T) :
    IsPerfectlyRepresentableChannel S.channel ↔ IsPerfectlyRepresentableChannel T.channel := by
  have h := isPerfectlyRepresentableChannel_map_iff S.channel e.equiv e.equiv.injective
  have heq : (fun x => (S.channel x).map e.equiv) = T.channel := funext e.map_eq
  rw [heq] at h
  exact h.symm

example : IsPerfectlyRepresentableChannel r13Recovery.channel ↔
    IsPerfectlyRepresentableChannel r13State.channel := r14OutputIff r13Comparison

example {alpha beta : Type*} [Finite alpha] [Nonempty alpha] [Finite beta]
    (K : alpha → PMF beta) {m : Nat} (e : beta ≃ Fin m)
    (h : ∀ y, ∃ x, K x y ≠ 0) :
    IsPerfectlyRepresentableChannel (ofActive K e h).channel ↔
      IsPerfectlyRepresentableChannel K := isPerfectlyRepresentableChannel_ofActive_iff K e h

example {alpha beta : Type*} [Finite alpha] [Nonempty alpha] [Finite beta]
    (K : alpha → PMF beta) {m : Nat} (e : activeOutputs K ≃ Fin m) :
    IsPerfectlyRepresentableChannel (ofChannelWithEquiv K e).channel ↔
      IsPerfectlyRepresentableChannel K :=
  isPerfectlyRepresentableChannel_ofChannelWithEquiv_iff K e

private def r14Unused : Fin 3 → PMF (Fin 4) :=
  fun x => (nonrepresentable3x3 x).map Fin.castSucc

example : ¬ IsPerfectlyRepresentableChannel r14Unused := by
  intro h
  exact nonrepresentable3x3_not_isPerfectlyRepresentableChannel
    ((isPerfectlyRepresentableChannel_map_iff nonrepresentable3x3
      Fin.castSucc (Fin.castSucc_injective 3)).1 h)

example (x : Fin 3) : r14Unused x 3 = 0 := by
  rw [r14Unused, PMF.map_apply]
  apply ENNReal.tsum_eq_zero.mpr
  intro j
  have h : (3 : Fin 4) ≠ j.castSucc := by
    intro heq
    have hv := congrArg Fin.val heq
    simp only [Fin.val_castSucc] at hv
    omega
  simp [h]

example : ¬ IsPerfectlyRepresentableChannel (ofChannel r14Unused).channel := by
  intro h
  exact nonrepresentable3x3_not_isPerfectlyRepresentableChannel
    ((isPerfectlyRepresentableChannel_map_iff nonrepresentable3x3
      Fin.castSucc (Fin.castSucc_injective 3)).1
        ((isPerfectlyRepresentableChannel_ofChannel_iff r14Unused).1 h))

example {alpha : Type*} [Finite alpha] [Nonempty alpha] :
    IsPerfectlyRepresentableChannel
      (fun x => ((allOnes alpha).channel x).map (Fin.castSucc : Fin 1 → Fin 2)) :=
  (isPerfectlyRepresentableChannel_map_iff (allOnes alpha).channel
    Fin.castSucc (Fin.castSucc_injective 1)).2 (allOnes_isPerfectlyRepresentable alpha)

end
end PerfectFunctionalRepresentations.MatrixOperations

namespace PerfectFunctionalRepresentations.MatrixOperations
open ActiveFiniteChannel
noncomputable section

section WitnessedEndpoints
variable {alpha : Type*} [Finite alpha] [Nonempty alpha]
  (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)

-- R11/R14: the new negative contracts have precisely the witnessed C08 endpoints.
example (l : Fin S.outputCard) (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1)
    (hNP : ¬ IsPerfectlyRepresentableChannel S.channel) :
    ∃ e : OperationStep S (pps S hS l t ht0 ht1), e.kind = .pps ∧
      ¬ IsPerfectlyRepresentableChannel (pps S hS l t ht0 ht1).channel :=
  ⟨.pps S hS l t ht0 ht1, rfl, pps_not_isPerfectlyRepresentable S hS l t ht0 ht1 hNP⟩

example (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0)
    (hNP : ¬ IsPerfectlyRepresentableChannel S.channel) :
    ∃ e : OperationStep S (ppm S hS a b hab hp), e.kind = .ppm ∧
      ¬ IsPerfectlyRepresentableChannel (ppm S hS a b hab hp).channel :=
  ⟨.ppm S hS a b hab hp, rfl, ppm_not_isPerfectlyRepresentable S hS a b hab hp hNP⟩

example (a b : Fin S.outputCard) (hab : a < b)
    (hv : columnValue S.channel hS (S.activeEquiv a) =
      columnValue S.channel hS (S.activeEquiv b))
    (hd : ∀ x, S.channel x a ≠ 0 → S.channel x b = 0)
    (hNP : ¬ IsPerfectlyRepresentableChannel S.channel) :
    ∃ e : OperationStep S (vpm S hS a b hab hv hd), e.kind = .vpm ∧
      ¬ IsPerfectlyRepresentableChannel (vpm S hS a b hab hv hd).channel :=
  ⟨.vpm S hS a b hab hv hd, rfl, vpm_not_isPerfectlyRepresentable S hS a b hab hv hd hNP⟩

example (l : Fin S.outputCard) (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1)
    (hP : IsPerfectlyRepresentableChannel S.channel) :
    ∃ e : OperationStep S (pps S hS l t ht0 ht1), e.kind = .pps ∧
      IsPerfectlyRepresentableChannel (pps S hS l t ht0 ht1).channel :=
  ⟨.pps S hS l t ht0 ht1, rfl, pps_isPerfectlyRepresentable S hS l t ht0 ht1 hP⟩

example (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0)
    (hP : IsPerfectlyRepresentableChannel S.channel) :
    ∃ e : OperationStep S (ppm S hS a b hab hp), e.kind = .ppm ∧
      IsPerfectlyRepresentableChannel (ppm S hS a b hab hp).channel :=
  ⟨.ppm S hS a b hab hp, rfl, ppm_isPerfectlyRepresentable S hS a b hab hp hP⟩

example (l : Fin S.outputCard) (mask : alpha → Bool)
    (hl : ∃ x, S.channel x l ≠ 0 ∧ mask x = true)
    (hr : ∃ x, S.channel x l ≠ 0 ∧ mask x = false)
    (hP : IsPerfectlyRepresentableChannel S.channel) :
    ∃ e : OperationStep S (vps S hS l mask hl hr), e.kind = .vps ∧
      IsPerfectlyRepresentableChannel (vps S hS l mask hl hr).channel :=
  ⟨.vps S hS l mask hl hr, rfl, vps_isPerfectlyRepresentable S hS l mask hl hr hP⟩
end WitnessedEndpoints

-- Both concrete R12 endpoints use the new negative implications.
private theorem r12Split_not_perfect : ¬ IsPerfectlyRepresentableChannel r12Split.channel :=
  pps_not_isPerfectlyRepresentable r12State nonrepresentable3x3_isSingular 0
    r12Weight r12Weight_pos r12Weight_lt nonrepresentable3x3_not_isPerfectlyRepresentableChannel

example : ¬ IsPerfectlyRepresentableChannel r12Split.channel := r12Split_not_perfect

example : ¬ IsPerfectlyRepresentableChannel r12Merge.channel :=
  ppm_not_isPerfectlyRepresentable r12Split r12Split_singular (0 : Fin 4) (1 : Fin 4) (by decide)
    r12Pattern r12Split_not_perfect

example {alpha : Type*} [Finite alpha] [Nonempty alpha]
    {S T : ActiveFiniteChannel alpha} (e : OutputEquiv S T) :
    IsPerfectlyRepresentableChannel S.channel ↔ IsPerfectlyRepresentableChannel T.channel :=
  r14OutputIff e

example {alpha alpha' beta beta' : Type*}
    [Finite alpha] [Finite alpha'] [Finite beta] [Finite beta']
    [Nonempty alpha] [Nonempty alpha']
    (K : alpha → PMF beta) (eX : alpha ≃ alpha') (eY : beta ≃ beta') :
    IsPerfectlyRepresentableChannel (relabelChannel K eX eY) ↔
      IsPerfectlyRepresentableChannel K :=
  isPerfectlyRepresentableChannel_relabelChannel_iff K eX eY

end
end PerfectFunctionalRepresentations.MatrixOperations
