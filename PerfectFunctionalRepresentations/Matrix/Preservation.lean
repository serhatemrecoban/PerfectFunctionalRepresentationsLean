import PerfectFunctionalRepresentations.Matrix.Operations

/-!
# Representability preservation

The one-output all-ones seed and ISIT Section III-B, Lemmas 5 and 6.
The PPS proof follows extended version 16, (175)-(183): one independent choice
lifts the whole canonical vector. The common posterior fixes that choice at
either child and retains its mixture at every unaffected output, including
coordinates where the displayed output has zero mass.

The PPM proof follows (184)-(195): collapse the complete vector and use one
fixed admitted-value ratio in the merged posterior. Both selected masses
vanish off their common support; unaffected outputs retain their transported
posteriors. The intrinsic statements require no input prior.

The VPS proof follows (196)-(202): one deterministic map lifts the complete vector
using the fixed row mask. Both children share the transported selected posterior;
unaffected outputs retain their own transported posteriors. Both selected-support
witnesses are explicit, including at admitted value one.

Lemma 6 follows by applying these forward results to C07's remembered recoveries:
PPM after PPS, PPS after PPM, and VPS after VPM. Each recovered channel maps to
the original through the specified output equivalence; semantic output transport
then contradicts source nonperfectness. Ratios and masks remain explicit witnesses.
-/

namespace PerfectFunctionalRepresentations.ActiveFiniteChannel

universe u
variable (alpha : Type u) [Finite alpha] [Nonempty alpha]

noncomputable section

/-- The one-output channel whose exact and real rectangular coordinates are all one. -/
def allOnes : ActiveFiniteChannel alpha where
  outputCard := 1
  outputCard_pos := by decide
  channel := fun _ => PMF.pure 0
  output_active := by
    intro y
    obtain ⟨x⟩ := ‹Nonempty alpha›
    refine ⟨x, ?_⟩
    have hy : y = 0 := Subsingleton.elim _ _
    simp [hy]

@[simp] theorem allOnes_outputCard : (allOnes alpha).outputCard = 1 := rfl

@[simp] theorem allOnes_channel (x : alpha) :
    (allOnes alpha).channel x = PMF.pure (0 : Fin 1) := rfl

@[simp] theorem allOnes_apply (x : alpha) (y : Fin 1) :
    (allOnes alpha).channel x y = 1 := by
  have hy : y = 0 := Subsingleton.elim _ _
  subst y
  change (PMF.pure (0 : Fin 1)) 0 = 1
  exact PMF.pure_apply_self 0

/-- The all-ones matrix is rectangular, with input rows and one output column. -/
theorem allOnes_massMatrix : massMatrix (allOnes alpha).channel = fun _ _ => 1 := by
  funext x y
  exact allOnes_apply alpha x y

theorem allOnes_realMatrix : realMatrix (allOnes alpha).channel = fun _ _ => 1 := by
  funext x y
  change ((allOnes alpha).channel x y).toReal = 1
  exact (congrArg ENNReal.toReal (allOnes_apply alpha x y)).trans ENNReal.toReal_one

theorem allOnes_isSingular : IsSingularChannel (allOnes alpha).channel := by
  intro x1 x2 y _ _
  rfl

/-- Perfectness of the seed uses the existing small-output characterization. -/
theorem allOnes_isPerfectlyRepresentable :
    IsPerfectlyRepresentableChannel (allOnes alpha).channel := by
  let := Fintype.ofFinite alpha
  exact (isPerfectlyRepresentableChannel_iff_isSingular_of_card_le_two
    (allOnes alpha).channel (by change Fintype.card (Fin 1) ≤ 2; decide)).2
      (allOnes_isSingular alpha)

end
end PerfectFunctionalRepresentations.ActiveFiniteChannel

namespace PerfectFunctionalRepresentations.MatrixOperations

open scoped ENNReal
universe u
variable {alpha : Type u} {n : Nat}
noncomputable section

private def ppsVectorLift (l : Fin n) (branch : Bool)
    (w : alpha → Fin n) : alpha → Fin (n + 1) :=
  fun x => vpsIndex l branch (w x)

private def ppsVectorLaw (l : Fin n) (t : NNReal) (ht : t ≤ 1)
    (q : PMF (alpha → Fin n)) : PMF (alpha → Fin (n + 1)) :=
  PMF.binaryMixture t ht (q.map (ppsVectorLift l true)) (q.map (ppsVectorLift l false))

private def ppsPosterior (l : Fin n) (t : NNReal) (ht : t ≤ 1)
    (V : Fin n → PMF (alpha → Fin n)) : Fin (n + 1) → PMF (alpha → Fin (n + 1)) :=
  Fin.insertNth (α := fun _ => PMF (alpha → Fin (n + 1))) (splitRight l)
    ((V l).map (ppsVectorLift l false))
    (fun j => if j = l then (V l).map (ppsVectorLift l true)
      else PMF.binaryMixture t ht ((V j).map (ppsVectorLift l true))
        ((V j).map (ppsVectorLift l false)))

private def ppsCollapse (l : Fin n) : Fin (n + 1) → Fin n :=
  Fin.insertNth (α := fun _ => Fin n) (splitRight l) l id

private theorem ppsCollapse_right (l : Fin n) : ppsCollapse l (splitRight l) = l := by
  simp [ppsCollapse]

private theorem ppsCollapse_keep (l : Fin n) (j : Fin n) :
    ppsCollapse l (splitKeep l j) = j := by
  simp [ppsCollapse, splitKeep, splitRight]

private theorem ppsCollapse_left (l : Fin n) : ppsCollapse l (splitLeft l) = l := by
  rw [← splitKeep_self l, ppsCollapse_keep]

private theorem ppsCollapse_index (l : Fin n) (b : Bool) (j : Fin n) :
    ppsCollapse l (vpsIndex l b j) = j := by
  by_cases hj : j = l
  · subst j
    cases b <;> simp [vpsIndex, ppsCollapse_left, ppsCollapse_right]
  · simp [vpsIndex, hj, ppsCollapse_keep]

private theorem ppsPosterior_right (l : Fin n) (t : NNReal) (ht : t ≤ 1)
    (V : Fin n → PMF (alpha → Fin n)) :
    ppsPosterior l t ht V (splitRight l) = (V l).map (ppsVectorLift l false) := by
  simp [ppsPosterior]

private theorem ppsPosterior_left (l : Fin n) (t : NNReal) (ht : t ≤ 1)
    (V : Fin n → PMF (alpha → Fin n)) :
    ppsPosterior l t ht V (splitLeft l) = (V l).map (ppsVectorLift l true) := by
  rw [← splitKeep_self l]
  simp only [ppsPosterior, splitKeep, splitRight, Fin.insertNth_apply_succAbove, if_true]

private theorem ppsPosterior_keep (l : Fin n) (t : NNReal) (ht : t ≤ 1)
    (V : Fin n → PMF (alpha → Fin n)) {j : Fin n} (hj : j ≠ l) :
    ppsPosterior l t ht V (splitKeep l j) =
      PMF.binaryMixture t ht ((V j).map (ppsVectorLift l true))
        ((V j).map (ppsVectorLift l false)) := by
  simp [ppsPosterior, splitKeep, splitRight, hj]

private theorem map_binaryMixture {beta gamma : Type*} (t : NNReal) (ht : t ≤ 1)
    (p q : PMF beta) (f : beta → gamma) :
    (PMF.binaryMixture t ht p q).map f =
      PMF.binaryMixture t ht (p.map f) (q.map f) := by
  unfold PMF.binaryMixture
  rw [PMF.map_bind]
  congr 1
  funext b
  cases b <;> rfl

private theorem ppsVectorLaw_eq_shared_selector (l : Fin n) (t : NNReal) (ht : t ≤ 1)
    (q : PMF (alpha → Fin n)) :
    ppsVectorLaw l t ht q =
      (LeanInfoTheory.Shannon.indepProd
        (PMF.binaryMixture t ht (PMF.pure true) (PMF.pure false)) q).map
          (fun bw => ppsVectorLift l bw.1 bw.2) := by
  simp only [ppsVectorLaw, LeanInfoTheory.Shannon.indepProd, PMF.binaryMixture,
    PMF.map_bind, PMF.map_comp, PMF.bind_bind, Function.comp_def]
  congr 1
  funext b
  cases b <;> simp only [Bool.false_eq_true, if_false, if_true, PMF.pure_bind]

private theorem pps_branch_factorization (K : alpha → PMF (Fin n))
    (q : PMF (alpha → Fin n)) (V : Fin n → PMF (alpha → Fin n))
    (h : ∀ x, q.map (fun w => (w x, w)) = PMF.channelJoint (K x) V)
    (l : Fin n) (b : Bool) (x : alpha) :
    (q.map (ppsVectorLift l b)).map (fun w => (w x, w)) =
      PMF.channelJoint (vpsRaw K l (fun _ => b) x)
        (fun y => (V (ppsCollapse l y)).map (ppsVectorLift l b)) := by
  have hm := congrArg (fun p : PMF (Fin n × (alpha → Fin n)) =>
    p.map (fun yw => (vpsIndex l b yw.1, ppsVectorLift l b yw.2))) (h x)
  simpa only [PMF.map_comp, PMF.channelJoint, PMF.map_bind, PMF.bind_map,
    Function.comp_def, vpsRaw, ppsVectorLift, ppsCollapse_index] using hm

private theorem pps_factorization (K : alpha → PMF (Fin n))
    (q : PMF (alpha → Fin n)) (V : Fin n → PMF (alpha → Fin n))
    (h : ∀ x, q.map (fun w => (w x, w)) = PMF.channelJoint (K x) V)
    (l : Fin n) (t : NNReal) (ht : t ≤ 1) (x : alpha) :
    (ppsVectorLaw l t ht q).map (fun w => (w x, w)) =
      PMF.channelJoint (ppsRaw K l t ht x) (ppsPosterior l t ht V) := by
  rw [ppsVectorLaw, map_binaryMixture,
    pps_branch_factorization K q V h l true x,
    pps_branch_factorization K q V h l false x]
  apply PMF.ext
  rintro ⟨j, w⟩
  rw [PMF.binaryMixture_apply]
  simp only [PMF.channelJoint_apply]
  rcases split_cases l j with rfl | ⟨k, rfl⟩
  · rw [vpsRaw_right, vpsRaw_right, ppsRaw_right,
      ppsPosterior_right, ppsCollapse_right]
    simp [mul_assoc]
  · by_cases hk : k = l
    · subst k
      rw [splitKeep_self, vpsRaw_left, vpsRaw_left, ppsRaw_left,
        ppsPosterior_left, ppsCollapse_left]
      simp [mul_assoc]
    · rw [vpsRaw_keep K l (fun _ => true) x hk,
        vpsRaw_keep K l (fun _ => false) x hk,
        ppsRaw_keep K l t ht x hk, ppsPosterior_keep l t ht V hk,
        ppsCollapse_keep, PMF.binaryMixture_apply]
      simp only [mul_add, mul_left_comm]

/-- Legal PPS preserves intrinsic perfect representability by one shared Bernoulli
choice for the canonical vector and its corresponding total common posterior. -/
theorem pps_isPerfectlyRepresentable [Finite alpha] [Nonempty alpha]
    (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1)
    (hP : IsPerfectlyRepresentableChannel S.channel) :
    IsPerfectlyRepresentableChannel (pps S hS l t ht0 ht1).channel := by
  obtain ⟨q, V, h⟩ := hP
  refine ⟨ppsVectorLaw l t ht1.le q, ppsPosterior l t ht1.le V, ?_⟩
  intro x
  exact pps_factorization S.channel q V h l t ht1.le x

end
end PerfectFunctionalRepresentations.MatrixOperations

/-! Private R02-R04 regressions exercise the constructed witness itself. -/
namespace PerfectFunctionalRepresentations.MatrixOperations
open LeanInfoTheory.Shannon
noncomputable section

private def r03SourceVector : Fin 3 → Fin 2 := ![0,0,1]
private def r03LeftVector : Fin 3 → Fin 3 := ![0,0,2]
private def r03RightVector : Fin 3 → Fin 3 := ![1,1,2]
private def r03MixedVector : Fin 3 → Fin 3 := ![0,1,2]
private def r03SourceLaw : PMF (Fin 3 → Fin 2) := PMF.pure r03SourceVector
private def r03SourcePosterior : Fin 2 → PMF (Fin 3 → Fin 2) := fun _ => r03SourceLaw
private def r03Channel : Fin 3 → PMF (Fin 2) := fun x => PMF.pure (r03SourceVector x)
private def r03Weight : NNReal := 1/3
private theorem r03Weight_pos : 0 < r03Weight := by norm_num [r03Weight]
private theorem r03Weight_lt_one : r03Weight < 1 := by norm_num [r03Weight]
private theorem r03Complement : (1 - r03Weight : NNReal) = 2/3 := by
  apply NNReal.coe_injective
  norm_num [r03Weight, NNReal.coe_sub_def]

private theorem r03Factor (x : Fin 3) :
    r03SourceLaw.map (fun f => (f x, f)) = PMF.channelJoint (r03Channel x) r03SourcePosterior := by
  simp [r03SourceLaw, r03SourcePosterior, r03Channel, PMF.channelJoint, PMF.pure_map]

private theorem r03Perfect : IsPerfectlyRepresentableChannel r03Channel :=
  ⟨r03SourceLaw, r03SourcePosterior, r03Factor⟩

private abbrev r03State : ActiveFiniteChannel (Fin 3) where
  outputCard := 2
  outputCard_pos := by decide
  channel := r03Channel
  output_active := by
    intro y
    fin_cases y
    · exact ⟨0, by simp [r03Channel, r03SourceVector]⟩
    · exact ⟨2, by simp [r03Channel, r03SourceVector]⟩

private def r03Target : ActiveFiniteChannel (Fin 3) :=
  pps r03State r03Perfect.isSingular 0 r03Weight r03Weight_pos r03Weight_lt_one

private abbrev r03TargetChannel : Fin 3 → PMF (Fin 3) :=
  ppsRaw r03Channel 0 r03Weight r03Weight_lt_one.le

example : (r03Target.channel : Fin 3 → PMF (Fin 3)) = r03TargetChannel := rfl

example : IsPerfectlyRepresentableChannel r03Target.channel :=
  pps_isPerfectlyRepresentable r03State r03Perfect.isSingular 0
    r03Weight r03Weight_pos r03Weight_lt_one r03Perfect

private theorem r03Row0 : r03TargetChannel 0 =
    PMF.binaryMixture r03Weight r03Weight_lt_one.le (PMF.pure 0) (PMF.pure 1) := by
  simp [r03TargetChannel, ppsRaw, r03Channel, r03SourceVector, ppsKernel, splitLeft, splitRight]

private theorem r03Row1 : r03TargetChannel 1 =
    PMF.binaryMixture r03Weight r03Weight_lt_one.le (PMF.pure 0) (PMF.pure 1) := by
  simp [r03TargetChannel, ppsRaw, r03Channel, r03SourceVector, ppsKernel, splitLeft, splitRight]

private theorem r03Row2 : r03TargetChannel 2 = PMF.pure 2 := by
  change (PMF.pure (1 : Fin 2)).bind (ppsKernel 0 r03Weight r03Weight_lt_one.le) = _
  rw [PMF.pure_bind, ppsKernel_unaffected _ _ _ (by decide)]
  rfl

private def r03Law : PMF (Fin 3 → Fin 3) :=
  ppsVectorLaw 0 r03Weight r03Weight_lt_one.le r03SourceLaw

private def r03Posterior : Fin 3 → PMF (Fin 3 → Fin 3) :=
  ppsPosterior 0 r03Weight r03Weight_lt_one.le r03SourcePosterior

private theorem r03LiftLeft : ppsVectorLift 0 true r03SourceVector = r03LeftVector := by decide
private theorem r03LiftRight : ppsVectorLift 0 false r03SourceVector = r03RightVector := by decide
private theorem r03Vectors_ne : r03LeftVector ≠ r03RightVector := by decide
private theorem r03LeftMixed_ne : r03LeftVector ≠ r03MixedVector := by decide
private theorem r03RightMixed_ne : r03RightVector ≠ r03MixedVector := by decide

private theorem r03Law_eq : r03Law =
    PMF.binaryMixture r03Weight r03Weight_lt_one.le
      (PMF.pure r03LeftVector) (PMF.pure r03RightVector) := by
  simp only [r03Law, ppsVectorLaw, r03SourceLaw, PMF.pure_map, r03LiftLeft, r03LiftRight]

-- R02: actual insertion is label 0 -> left0/right1, old1 -> target2.
example : splitLeft (0 : Fin 2) = 0 ∧ splitRight (0 : Fin 2) = 1 ∧
    splitKeep (0 : Fin 2) 1 = 2 := by decide

example : r03TargetChannel 0 0 = (1 : ENNReal)/3 ∧
    r03TargetChannel 0 1 = 2/3 ∧ r03TargetChannel 0 2 = 0 ∧
    r03TargetChannel 1 0 = 1/3 ∧ r03TargetChannel 1 1 = 2/3 ∧
    r03TargetChannel 1 2 = 0 ∧ r03TargetChannel 2 0 = 0 ∧
    r03TargetChannel 2 1 = 0 ∧ r03TargetChannel 2 2 = 1 := by
  rw [r03Row0, r03Row1, r03Row2]
  simp only [PMF.binaryMixture_apply, r03Complement]
  norm_num [r03Weight, PMF.pure_apply]
  decide

-- R03: one choice is shared by both coordinates with selected source output.
example : r03Law r03LeftVector = (1 : ENNReal)/3 := by
  rw [r03Law_eq, PMF.binaryMixture_apply, r03Complement]
  norm_num [r03Weight, NNReal.coe_sub_def, PMF.pure_apply, r03Vectors_ne, Ne.symm r03Vectors_ne]

example : r03Law r03RightVector = (2 : ENNReal)/3 := by
  rw [r03Law_eq, PMF.binaryMixture_apply, r03Complement]
  norm_num [r03Weight, NNReal.coe_sub_def, PMF.pure_apply, r03Vectors_ne, Ne.symm r03Vectors_ne]

example : r03Law r03MixedVector = 0 := by
  rw [r03Law_eq, PMF.binaryMixture_apply]
  simp [PMF.pure_apply,
    Ne.symm r03LeftMixed_ne, Ne.symm r03RightMixed_ne]

-- The posterior at the unaffected actual output retains both full-vector lifts.
private theorem r03Posterior_unaffected : r03Posterior 2 = r03Law := by
  change ppsPosterior (0 : Fin 2) r03Weight r03Weight_lt_one.le r03SourcePosterior
    (splitKeep 0 1) = _
  rw [ppsPosterior_keep _ _ _ _ (by decide)]
  norm_num [r03Posterior, r03SourcePosterior, r03Law, ppsVectorLaw]

example : r03Posterior 2 r03LeftVector = (1 : ENNReal)/3 ∧
    r03Posterior 2 r03RightVector = (2 : ENNReal)/3 ∧
    r03Posterior 2 r03MixedVector = 0 := by
  rw [r03Posterior_unaffected, r03Law_eq]
  simp only [PMF.binaryMixture_apply, r03Complement]
  norm_num [PMF.binaryMixture_apply, r03Weight, NNReal.coe_sub_def, PMF.pure_apply,
    r03Vectors_ne, Ne.symm r03Vectors_ne, r03LeftMixed_ne, r03RightMixed_ne,
    Ne.symm r03LeftMixed_ne, Ne.symm r03RightMixed_ne]

-- These two lifts differ even though both evaluate to the unchanged label2 at row2.
example : r03LeftVector ≠ r03RightVector ∧ r03LeftVector 2 = 2 ∧ r03RightVector 2 = 2 := by
  decide

private def r03IndependentMap (ab : Fin 3 × Fin 3) : Fin 3 → Fin 3 := ![ab.1,ab.2,2]
private theorem r03IndependentMap_injective : Function.Injective r03IndependentMap := by
  intro a b h
  apply Prod.ext
  · exact congrFun h 0
  · exact congrFun h 1

private def r03IndependentLaw : PMF (Fin 3 → Fin 3) :=
  (indepProd (r03TargetChannel 0) (r03TargetChannel 1)).map r03IndependentMap

-- Independent choices are a different full vector law, detected by the mixed atom.
example : r03IndependentLaw r03MixedVector = (2 : ENNReal)/9 := by
  change ((indepProd (r03TargetChannel 0) (r03TargetChannel 1)).map
    r03IndependentMap) (r03IndependentMap (0,1)) = _
  rw [PMF.map_apply_of_injective _ r03IndependentMap_injective, indepProd_apply]
  rw [r03Row0, r03Row1]
  simp only [PMF.binaryMixture_apply, r03Complement]
  norm_num [r03Weight, PMF.pure_apply]
  calc
    (3 : ENNReal)⁻¹ * (2/3) = (((1/3 : NNReal) * (2/3 : NNReal) : NNReal) : ENNReal) := by
      simp only [ENNReal.coe_mul, ENNReal.coe_div (by norm_num : (3 : NNReal) ≠ 0),
        ENNReal.coe_inv (by norm_num : (3 : NNReal) ≠ 0), ENNReal.coe_ofNat, one_div]
    _ = ((2/9 : NNReal) : ENNReal) := congrArg (fun a : NNReal => (a : ENNReal)) (by norm_num)
    _ = (2 : ENNReal)/9 := by norm_num [ENNReal.coe_div]


-- Selected-output posteriors fix the shared branch; they are total PMFs even
-- on row2, where the corresponding displayed output has zero probability.
private theorem r03Posterior_left : r03Posterior 0 = PMF.pure r03LeftVector := by
  change ppsPosterior (0 : Fin 2) r03Weight r03Weight_lt_one.le r03SourcePosterior
    (splitLeft 0) = _
  rw [ppsPosterior_left]
  simp only [r03SourcePosterior, r03SourceLaw, PMF.pure_map, r03LiftLeft]

private theorem r03Posterior_right : r03Posterior 1 = PMF.pure r03RightVector := by
  change ppsPosterior (0 : Fin 2) r03Weight r03Weight_lt_one.le r03SourcePosterior
    (splitRight 0) = _
  rw [ppsPosterior_right]
  simp only [r03SourcePosterior, r03SourceLaw, PMF.pure_map, r03LiftRight]

example : r03Posterior 0 = PMF.pure r03LeftVector ∧
    r03Posterior 1 = PMF.pure r03RightVector :=
  ⟨r03Posterior_left, r03Posterior_right⟩

example (w : Fin 3 → Fin 3) :
    PMF.channelJoint (r03TargetChannel 2) r03Posterior (0,w) = 0 ∧
    PMF.channelJoint (r03TargetChannel 2) r03Posterior (1,w) = 0 := by
  rw [r03Row2]
  simp [PMF.channelJoint_apply, PMF.pure_apply]

-- The checked concrete law uses the very same complete private factorization
-- as the public preservation theorem, including the selected null row.
private theorem r03FullFactorization (x : Fin 3) :
    r03Law.map (fun w => (w x,w)) =
      PMF.channelJoint (r03TargetChannel x) r03Posterior :=
  pps_factorization r03Channel r03SourceLaw r03SourcePosterior r03Factor
    0 r03Weight r03Weight_lt_one.le x

example : IsCanonicalCoupling r03TargetChannel r03Law :=
  isCanonicalCoupling_of_coordinateFactorization r03Law r03TargetChannel
    r03Posterior r03FullFactorization

example (p : PMF (Fin 3)) : IsPerfectFunctionalRepresentation (canonicalJoint p r03Law) :=
  isPerfectFunctionalRepresentation_canonicalJoint_of_coordinateFactorization
    p r03Law r03TargetChannel r03Posterior r03FullFactorization

-- The comparison law has the same coordinate marginals, but a different full law.
example : r03IndependentLaw.map (fun w => w 0) = r03TargetChannel 0 := by
  rw [r03IndependentLaw, PMF.map_comp]
  change (indepProd (r03TargetChannel 0) (r03TargetChannel 1)).map Prod.fst = _
  exact fstMarginal_indepProd _ _

example : r03IndependentLaw.map (fun w => w 1) = r03TargetChannel 1 := by
  rw [r03IndependentLaw, PMF.map_comp]
  change (indepProd (r03TargetChannel 0) (r03TargetChannel 1)).map Prod.snd = _
  exact sndMarginal_indepProd _ _

example : r03IndependentLaw.map (fun w => w 2) = r03TargetChannel 2 := by
  rw [r03IndependentLaw, PMF.map_comp, r03Row2]
  exact PMF.map_const _ _

end
end PerfectFunctionalRepresentations.MatrixOperations

namespace PerfectFunctionalRepresentations.MatrixOperations

open scoped BigOperators ENNReal
universe u
variable {alpha : Type u} [Finite alpha] [Nonempty alpha]
noncomputable section

private def ppmCollapse (S : ActiveFiniteChannel alpha) (a b : Fin S.outputCard)
    (hab : a < b) : Fin S.outputCard → Fin (S.outputCard - 1) :=
  mergeIndex (mergeSourceEquiv S a) (mergeSourceEquiv S b)
    ((mergeSourceEquiv_lt_iff S a b).mpr hab) ∘ mergeSourceEquiv S

private def ppmVectorLift (S : ActiveFiniteChannel alpha) (a b : Fin S.outputCard)
    (hab : a < b) (w : alpha → Fin S.outputCard) : alpha → Fin (S.outputCard - 1) :=
  fun x => ppmCollapse S a b hab (w x)

private def ppmVectorLaw (S : ActiveFiniteChannel alpha) (a b : Fin S.outputCard)
    (hab : a < b) (q : PMF (alpha → Fin S.outputCard)) :
    PMF (alpha → Fin (S.outputCard - 1)) :=
  q.map (ppmVectorLift S a b hab)

private def ppmPosterior (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (a b : Fin S.outputCard) (hab : a < b)
    (V : Fin S.outputCard → PMF (alpha → Fin S.outputCard)) :
    Fin (S.outputCard - 1) → PMF (alpha → Fin (S.outputCard - 1)) :=
  fun j => if j = activeMergeSurvivor S a b hab then
    PMF.binaryMixture (ppmRatio S hS a b) (ppmRatio_lt_one S hS a b).le
      ((V a).map (ppmVectorLift S a b hab)) ((V b).map (ppmVectorLift S a b hab))
    else (V (activeMergeRetained S b j)).map (ppmVectorLift S a b hab)

private theorem ppmCollapse_left (S : ActiveFiniteChannel alpha) (a b : Fin S.outputCard)
    (hab : a < b) : ppmCollapse S a b hab a = activeMergeSurvivor S a b hab := by
  simp [ppmCollapse, activeMergeSurvivor]

private theorem ppmCollapse_right (S : ActiveFiniteChannel alpha) (a b : Fin S.outputCard)
    (hab : a < b) : ppmCollapse S a b hab b = activeMergeSurvivor S a b hab := by
  simp [ppmCollapse, activeMergeSurvivor]

private theorem ppmCollapse_retained (S : ActiveFiniteChannel alpha) (a b : Fin S.outputCard)
    (hab : a < b) (j : Fin (S.outputCard - 1)) :
    ppmCollapse S a b hab (activeMergeRetained S b j) = j := by
  simp only [ppmCollapse, Function.comp_def, activeMergeRetained_source, mergeIndex_succAbove]

private theorem ppmPosterior_survivor (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (a b : Fin S.outputCard) (hab : a < b)
    (V : Fin S.outputCard → PMF (alpha → Fin S.outputCard)) :
    ppmPosterior S hS a b hab V (activeMergeSurvivor S a b hab) =
      PMF.binaryMixture (ppmRatio S hS a b) (ppmRatio_lt_one S hS a b).le
        ((V a).map (ppmVectorLift S a b hab)) ((V b).map (ppmVectorLift S a b hab)) := by
  simp [ppmPosterior]

private theorem ppmPosterior_unaffected (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (a b : Fin S.outputCard) (hab : a < b)
    (V : Fin S.outputCard → PMF (alpha → Fin S.outputCard)) {j : Fin (S.outputCard - 1)}
    (hj : j ≠ activeMergeSurvivor S a b hab) :
    ppmPosterior S hS a b hab V j =
      (V (activeMergeRetained S b j)).map (ppmVectorLift S a b hab) := by
  simp [ppmPosterior, hj]

private theorem ppm_row_products (S : ActiveFiniteChannel alpha)
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

private theorem ppm_pair_map_apply {beta gamma delta : Type*} [DecidableEq delta] (p : PMF beta)
    (F : beta → gamma) (y j : delta) (w : gamma) :
    (p.map (fun v => (y, F v))) (j, w) = if j = y then (p.map F) w else 0 := by
  classical
  by_cases h : j = y
  · subst j
    simp [PMF.map_apply]
  · simp [PMF.map_apply, h]

private theorem ppm_joint_mass (S : ActiveFiniteChannel alpha) (a b : Fin S.outputCard)
    (hab : a < b) (p : PMF (Fin S.outputCard))
    (V : Fin S.outputCard → PMF (alpha → Fin S.outputCard))
    (j : Fin (S.outputCard - 1)) (w : alpha → Fin (S.outputCard - 1)) :
    ((PMF.channelJoint p V).map
      (fun yw => (ppmCollapse S a b hab yw.1, ppmVectorLift S a b hab yw.2))) (j, w) =
      (if j = activeMergeSurvivor S a b hab then
        p b * ((V b).map (ppmVectorLift S a b hab)) w else 0) +
      p (activeMergeRetained S b j) *
        ((V (activeMergeRetained S b j)).map (ppmVectorLift S a b hab)) w := by
  classical
  simp only [PMF.channelJoint, PMF.map_bind, PMF.map_comp, Function.comp_def, PMF.bind_apply]
  simp_rw [ppm_pair_map_apply]
  simp only [mul_ite, mul_zero]
  rw [tsum_fintype,
    ← (mergeSourceEquiv S).symm.sum_comp
      (fun k => if j = ppmCollapse S a b hab k then
        p k * ((V k).map (ppmVectorLift S a b hab)) w else 0),
    Fin.sum_univ_succAbove _ (mergeSourceEquiv S b)]
  simp [ppmCollapse, activeMergeSurvivor, activeMergeRetained]

private theorem ppm_factorization (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0)
    (q : PMF (alpha → Fin S.outputCard))
    (V : Fin S.outputCard → PMF (alpha → Fin S.outputCard))
    (h : ∀ x, q.map (fun w => (w x, w)) = PMF.channelJoint (S.channel x) V) (x : alpha) :
    (ppmVectorLaw S a b hab q).map (fun w => (w x, w)) =
      PMF.channelJoint ((ppm S hS a b hab hp).channel x) (ppmPosterior S hS a b hab V) := by
  have hm := congrArg (fun p : PMF (Fin S.outputCard × (alpha → Fin S.outputCard)) =>
    p.map (fun yw => (ppmCollapse S a b hab yw.1, ppmVectorLift S a b hab yw.2))) (h x)
  have hmaps : (ppmVectorLaw S a b hab q).map (fun w => (w x, w)) =
      (PMF.channelJoint (S.channel x) V).map
        (fun yw => (ppmCollapse S a b hab yw.1, ppmVectorLift S a b hab yw.2)) := by
    simpa only [ppmVectorLaw, ppmVectorLift, PMF.map_comp, Function.comp_def] using hm
  rw [hmaps]
  apply PMF.ext
  rintro ⟨j, w⟩
  rw [ppm_joint_mass]
  erw [PMF.channelJoint_apply]
  by_cases hj : j = activeMergeSurvivor S a b hab
  · subst j
    rw [if_pos rfl, activeMergeRetained_survivor, ppmPosterior_survivor,
      ppm_apply_survivor, PMF.binaryMixture_apply]
    obtain ⟨hl, hr⟩ := ppm_row_products S hS a b hp x
    rw [mul_add, ← mul_assoc, ← mul_assoc,
      mul_comm (S.channel x a + S.channel x b) (ppmRatio S hS a b : ENNReal), hl,
      mul_comm (S.channel x a + S.channel x b) ((1 - ppmRatio S hS a b : NNReal) : ENNReal), hr]
    exact add_comm _ _
  · rw [if_neg hj, zero_add, ppmPosterior_unaffected S hS a b hab V hj,
      ppm_apply_unaffected S hS a b hab hp x hj]

/-- Legal PPM preserves intrinsic perfect representability by collapsing the canonical
vector and using the fixed admitted-value ratio in the merged output's common posterior. -/
theorem ppm_isPerfectlyRepresentable (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0)
    (hP : IsPerfectlyRepresentableChannel S.channel) :
    IsPerfectlyRepresentableChannel (ppm S hS a b hab hp).channel := by
  obtain ⟨q, V, h⟩ := hP
  refine ⟨ppmVectorLaw S a b hab q, ppmPosterior S hS a b hab V, ?_⟩
  intro x
  exact ppm_factorization S hS a b hab hp q V h x

private def r05A : Fin 3 → Fin 4 := ![0,0,1]
private def r05B : Fin 3 → Fin 4 := ![3,3,2]
private def r05Weight : NNReal := 1/3
private theorem r05Weight_pos : 0 < r05Weight := by norm_num [r05Weight]
private theorem r05Weight_lt_one : r05Weight < 1 := by norm_num [r05Weight]
private theorem r05Complement : (1-r05Weight : NNReal) = 2/3 := by
  apply NNReal.coe_injective
  norm_num [r05Weight, NNReal.coe_sub_def]
private def r05SourceLaw : PMF (Fin 3 → Fin 4) :=
  PMF.binaryMixture r05Weight r05Weight_lt_one.le (PMF.pure r05A) (PMF.pure r05B)
private def r05SourcePosterior : Fin 4 → PMF (Fin 3 → Fin 4) :=
  ![PMF.pure r05A, PMF.pure r05A, PMF.pure r05B, PMF.pure r05B]
private def r05Channel (x : Fin 3) : PMF (Fin 4) :=
  PMF.binaryMixture r05Weight r05Weight_lt_one.le (PMF.pure (r05A x)) (PMF.pure (r05B x))
private theorem r05Posterior_onA (x : Fin 3) : r05SourcePosterior (r05A x) = PMF.pure r05A := by
  fin_cases x <;> rfl
private theorem r05Posterior_onB (x : Fin 3) : r05SourcePosterior (r05B x) = PMF.pure r05B := by
  fin_cases x <;> rfl
private theorem r05SourceFactor (x : Fin 3) :
    r05SourceLaw.map (fun w => (w x,w)) = PMF.channelJoint (r05Channel x) r05SourcePosterior := by
  unfold r05SourceLaw r05Channel PMF.channelJoint PMF.binaryMixture
  simp only [PMF.map_bind, PMF.bind_bind]
  congr 1
  funext b
  cases b <;> simp only [Bool.false_eq_true, ↓reduceIte, PMF.pure_bind,
    r05Posterior_onA, r05Posterior_onB, PMF.pure_map]
private theorem r05Perfect : IsPerfectlyRepresentableChannel r05Channel :=
  ⟨r05SourceLaw, r05SourcePosterior, r05SourceFactor⟩

private def r05SourceWeights (x : Fin 3) : Fin 4 → NNReal :=
  if x = 2 then ![0,1/3,2/3,0] else ![1/3,0,0,2/3]
private theorem r05SourceMass (x : Fin 3) (j : Fin 4) :
    r05Channel x j = (r05SourceWeights x j : ENNReal) := by
  rw [r05Channel, PMF.binaryMixture_apply, r05Complement]
  fin_cases x <;> fin_cases j <;>
    norm_num [Fin.ext_iff, r05SourceWeights, r05A, r05B, r05Weight, PMF.pure_apply,
      Matrix.cons_val_two, Matrix.cons_val_three]

private abbrev r05State : ActiveFiniteChannel (Fin 3) where
  outputCard := 4
  outputCard_pos := by decide
  channel := r05Channel
  output_active := by
    intro j
    fin_cases j
    · exact ⟨0, by rw [r05SourceMass]; norm_num [Fin.ext_iff, r05SourceWeights]⟩
    · exact ⟨2, by
        rw [r05SourceMass]; norm_num [Fin.ext_iff, r05SourceWeights, Matrix.cons_val_two]⟩
    · exact ⟨2, by
        rw [r05SourceMass]; norm_num [Fin.ext_iff, r05SourceWeights, Matrix.cons_val_two]⟩
    · exact ⟨0, by
        rw [r05SourceMass]; norm_num [Fin.ext_iff, r05SourceWeights, Matrix.cons_val_three]⟩

private theorem r05Pattern (x : Fin 3) : r05State.channel x 0 ≠ 0 ↔ r05State.channel x 3 ≠ 0 := by
  change r05Channel x 0 ≠ 0 ↔ r05Channel x 3 ≠ 0
  rw [r05SourceMass, r05SourceMass]
  fin_cases x <;> norm_num [Fin.ext_iff, r05SourceWeights, Matrix.cons_val_three]

private theorem r05Value0 : columnValue r05State.channel r05Perfect.isSingular
    (r05State.activeEquiv 0) = ((1/3 : NNReal) : ENNReal) := by
  have hn : r05State.channel 0 0 ≠ 0 := by
    change r05Channel 0 0 ≠ 0
    rw [r05SourceMass]
    norm_num [Fin.ext_iff, r05SourceWeights]
  rw [columnValue_eq_of_ne_zero _ _ _ hn]
  change r05Channel 0 0 = _
  rw [r05SourceMass]
  rfl
private theorem r05Value3 : columnValue r05State.channel r05Perfect.isSingular
    (r05State.activeEquiv 3) = ((2/3 : NNReal) : ENNReal) := by
  have hn : r05State.channel 0 3 ≠ 0 := by
    change r05Channel 0 3 ≠ 0
    rw [r05SourceMass]
    norm_num [Fin.ext_iff, r05SourceWeights, Matrix.cons_val_three]
  rw [columnValue_eq_of_ne_zero _ _ _ hn]
  change r05Channel 0 3 = _
  rw [r05SourceMass]
  rfl
private theorem r05SumValues : columnValue r05State.channel r05Perfect.isSingular
    (r05State.activeEquiv 0) + columnValue r05State.channel r05Perfect.isSingular
      (r05State.activeEquiv 3) = 1 := by
  rw [r05Value0, r05Value3, ← ENNReal.coe_add]
  norm_num
private theorem r05Ratio : ppmRatio r05State r05Perfect.isSingular 0 3 = r05Weight := by
  rw [ppmRatio, r05SumValues, r05Value0, ENNReal.toNNReal_coe]
  norm_num [r05Weight]


private def r05CollapsedA : Fin 3 → Fin 3 := ![0,0,1]
private def r05CollapsedB : Fin 3 → Fin 3 := ![0,0,2]
private def r05OtherVector : Fin 3 → Fin 3 := ![0,0,0]
private theorem r05Collapsed_ne : r05CollapsedA ≠ r05CollapsedB := by decide
private theorem r05CollapsedA_other : r05CollapsedA ≠ r05OtherVector := by decide
private theorem r05CollapsedB_other : r05CollapsedB ≠ r05OtherVector := by decide

private theorem r05Collapse (j : Fin 4) :
    ppmCollapse r05State 0 3 (by decide) j = (![0,1,2,0] : Fin 4 → Fin 3) j := by
  fin_cases j <;> rfl
private theorem r05Survivor : activeMergeSurvivor r05State 0 3 (by decide) = (0 : Fin 3) := by
  apply Fin.ext
  exact activeMergeSurvivor_val _ _ _ _
private theorem r05Retained (j : Fin 3) : activeMergeRetained r05State 3 j = j.castSucc := by
  fin_cases j <;> rfl
private theorem r05LiftA : ppmVectorLift r05State 0 3 (by decide) r05A = r05CollapsedA := by
  funext x
  fin_cases x <;> rfl
private theorem r05LiftB : ppmVectorLift r05State 0 3 (by decide) r05B = r05CollapsedB := by
  funext x
  fin_cases x <;> rfl
private theorem r05CollapseA (x : Fin 3) :
    ppmCollapse r05State 0 3 (by decide) (r05A x) = r05CollapsedA x := congrFun r05LiftA x
private theorem r05CollapseB (x : Fin 3) :
    ppmCollapse r05State 0 3 (by decide) (r05B x) = r05CollapsedB x := congrFun r05LiftB x

private abbrev r05TargetChannel : Fin 3 → PMF (Fin 3) :=
  (ppm r05State r05Perfect.isSingular 0 3 (by decide) r05Pattern).channel
private def r05Law : PMF (Fin 3 → Fin 3) :=
  ppmVectorLaw r05State 0 3 (by decide) r05SourceLaw
private def r05Posterior : Fin 3 → PMF (Fin 3 → Fin 3) :=
  ppmPosterior r05State r05Perfect.isSingular 0 3 (by decide) r05SourcePosterior

private theorem r05TargetChannel_map (x : Fin 3) :
    r05TargetChannel x = (r05Channel x).map (ppmCollapse r05State 0 3 (by decide)) := by
  change ((r05Channel x).map (mergeSourceEquiv r05State)).map _ = _
  rw [PMF.map_comp]
  rfl
private theorem r05TargetRow (x : Fin 3) : r05TargetChannel x =
    PMF.binaryMixture r05Weight r05Weight_lt_one.le
      (PMF.pure (r05CollapsedA x)) (PMF.pure (r05CollapsedB x)) := by
  rw [r05TargetChannel_map]
  unfold r05Channel PMF.binaryMixture
  rw [PMF.map_bind]
  congr 1
  funext b
  cases b <;> simp only [Bool.false_eq_true, ↓reduceIte, PMF.pure_map, r05CollapseA, r05CollapseB]
private theorem r05TargetRow0 : r05TargetChannel 0 = PMF.pure 0 := by
  rw [r05TargetRow]
  change PMF.binaryMixture r05Weight _ (PMF.pure (0 : Fin 3)) (PMF.pure 0) = _
  simp [PMF.binaryMixture, PMF.bind_const]
private theorem r05TargetRow1 : r05TargetChannel 1 = PMF.pure 0 := by
  rw [r05TargetRow]
  change PMF.binaryMixture r05Weight _ (PMF.pure (0 : Fin 3)) (PMF.pure 0) = _
  simp [PMF.binaryMixture, PMF.bind_const]
private theorem r05TargetRow2 : r05TargetChannel 2 =
    PMF.binaryMixture r05Weight r05Weight_lt_one.le (PMF.pure 1) (PMF.pure 2) := by
  rw [r05TargetRow]
  rfl
private theorem r05Law_eq : r05Law =
    PMF.binaryMixture r05Weight r05Weight_lt_one.le
      (PMF.pure r05CollapsedA) (PMF.pure r05CollapsedB) := by
  unfold r05Law ppmVectorLaw r05SourceLaw PMF.binaryMixture
  rw [PMF.map_bind]
  congr 1
  funext b
  cases b <;> simp only [Bool.false_eq_true, ↓reduceIte, PMF.pure_map, r05LiftA, r05LiftB]
private theorem r05Posterior0 : r05Posterior 0 = r05Law := by
  change ppmPosterior r05State r05Perfect.isSingular 0 3 (by decide)
    r05SourcePosterior (0 : Fin 3) = _
  rw [← r05Survivor, ppmPosterior_survivor]
  change PMF.binaryMixture (ppmRatio r05State r05Perfect.isSingular 0 3) _
    ((PMF.pure r05A).map _) ((PMF.pure r05B).map _) = _
  simp only [r05Ratio, PMF.pure_map, r05LiftA, r05LiftB, r05Law_eq]
private theorem r05Posterior1 : r05Posterior 1 = PMF.pure r05CollapsedA := by
  change ppmPosterior r05State r05Perfect.isSingular 0 3 (by decide)
    r05SourcePosterior (1 : Fin 3) = _
  rw [ppmPosterior_unaffected _ _ _ _ _ _ (by rw [r05Survivor]; decide), r05Retained]
  change (PMF.pure r05A).map _ = _
  rw [PMF.pure_map, r05LiftA]
private theorem r05Posterior2 : r05Posterior 2 = PMF.pure r05CollapsedB := by
  change ppmPosterior r05State r05Perfect.isSingular 0 3 (by decide)
    r05SourcePosterior (2 : Fin 3) = _
  rw [ppmPosterior_unaffected _ _ _ _ _ _ (by rw [r05Survivor]; decide), r05Retained]
  change (PMF.pure r05B).map _ = _
  rw [PMF.pure_map, r05LiftB]

-- R05: both positive admitted values sum to one; the remembered actual ratio is 1/3.
example : columnValue r05State.channel r05Perfect.isSingular (r05State.activeEquiv 0) =
      ((1/3 : NNReal) : ENNReal) ∧
    columnValue r05State.channel r05Perfect.isSingular (r05State.activeEquiv 3) =
      ((2/3 : NNReal) : ENNReal) ∧
    columnValue r05State.channel r05Perfect.isSingular (r05State.activeEquiv 0) +
      columnValue r05State.channel r05Perfect.isSingular (r05State.activeEquiv 3) = 1 ∧
    ppmRatio r05State r05Perfect.isSingular 0 3 = r05Weight :=
  ⟨r05Value0, r05Value3, r05SumValues, r05Ratio⟩

example (x : Fin 3) : (r05Channel x 0 ≠ 0 ↔ x ≠ 2) ∧
    (r05Channel x 3 ≠ 0 ↔ x ≠ 2) := by
  rw [r05SourceMass, r05SourceMass]
  fin_cases x <;> norm_num [r05SourceWeights, Matrix.cons_val_three, Fin.ext_iff]

example : r05TargetChannel 0 0 = 1 ∧ r05TargetChannel 0 1 = 0 ∧ r05TargetChannel 0 2 = 0 ∧
    r05TargetChannel 1 0 = 1 ∧ r05TargetChannel 1 1 = 0 ∧ r05TargetChannel 1 2 = 0 ∧
    r05TargetChannel 2 0 = 0 ∧ r05TargetChannel 2 1 = (1 : ENNReal)/3 ∧
    r05TargetChannel 2 2 = 2/3 := by
  rw [r05TargetRow0, r05TargetRow1, r05TargetRow2]
  simp only [PMF.binaryMixture_apply, r05Complement]
  norm_num [r05Weight, PMF.pure_apply, Fin.ext_iff]

-- Both collapsed posteriors remain distinct; unequal mixture weights are observable.
example : r05CollapsedA ≠ r05CollapsedB ∧ r05CollapsedA 2 = 1 ∧ r05CollapsedB 2 = 2 := by decide
example : r05Law r05CollapsedA = (1 : ENNReal)/3 ∧
    r05Law r05CollapsedB = (2 : ENNReal)/3 ∧ r05Law r05OtherVector = 0 := by
  rw [r05Law_eq]
  simp only [PMF.binaryMixture_apply, r05Complement]
  norm_num [r05Weight, PMF.pure_apply, Ne.symm r05Collapsed_ne,
    r05Collapsed_ne, Ne.symm r05CollapsedA_other, Ne.symm r05CollapsedB_other]
example : r05Posterior 0 r05CollapsedA = (1 : ENNReal)/3 ∧
    r05Posterior 0 r05CollapsedB = (2 : ENNReal)/3 ∧
    r05Posterior 1 = PMF.pure r05CollapsedA ∧ r05Posterior 2 = PMF.pure r05CollapsedB := by
  rw [r05Posterior0, r05Posterior1, r05Posterior2, r05Law_eq]
  simp only [PMF.binaryMixture_apply, r05Complement]
  norm_num [r05Weight, PMF.pure_apply, Ne.symm r05Collapsed_ne, r05Collapsed_ne]

-- R06: denominator facts are inherited from actual active admitted values, even at the null row.
example : 0 < (columnValue r05State.channel r05Perfect.isSingular (r05State.activeEquiv 0) +
      columnValue r05State.channel r05Perfect.isSingular (r05State.activeEquiv 3)).toNNReal ∧
    columnValue r05State.channel r05Perfect.isSingular (r05State.activeEquiv 0) +
      columnValue r05State.channel r05Perfect.isSingular (r05State.activeEquiv 3) ≠ ∞ ∧
    0 < ppmRatio r05State r05Perfect.isSingular 0 3 ∧
    ppmRatio r05State r05Perfect.isSingular 0 3 < 1 :=
  ⟨ppmRatio_denominator_pos _ _ _ _, ppmRatio_denominator_ne_top _ _ _ _,
    ppmRatio_pos _ _ _ _, ppmRatio_lt_one _ _ _ _⟩
example (w : Fin 3 → Fin 3) : PMF.channelJoint (r05TargetChannel 2) r05Posterior (0,w) = 0 := by
  rw [PMF.channelJoint_apply, r05TargetRow2, PMF.binaryMixture_apply, r05Complement]
  norm_num [PMF.pure_apply, Fin.ext_iff]
example : PMF.channelJoint (r05TargetChannel 0) r05Posterior (0,r05CollapsedA) = (1 : ENNReal)/3 ∧
    PMF.channelJoint (r05TargetChannel 0) r05Posterior (0,r05CollapsedB) = (2 : ENNReal)/3 ∧
    PMF.channelJoint (r05TargetChannel 2) r05Posterior (1,r05CollapsedA) = (1 : ENNReal)/3 ∧
    PMF.channelJoint (r05TargetChannel 2) r05Posterior (2,r05CollapsedB) = (2 : ENNReal)/3 ∧
    PMF.channelJoint (r05TargetChannel 2) r05Posterior (1,r05CollapsedB) = 0 ∧
    PMF.channelJoint (r05TargetChannel 2) r05Posterior (2,r05CollapsedA) = 0 := by
  simp only [PMF.channelJoint_apply, r05TargetRow0, r05TargetRow2,
    r05Posterior0, r05Posterior1, r05Posterior2, r05Law_eq,
    PMF.binaryMixture_apply, r05Complement]
  norm_num [r05Weight, PMF.pure_apply, r05Collapsed_ne, Ne.symm r05Collapsed_ne, Fin.ext_iff]

private theorem r05FullFactorization (x : Fin 3) :
    r05Law.map (fun w => (w x,w)) = PMF.channelJoint (r05TargetChannel x) r05Posterior :=
  ppm_factorization r05State r05Perfect.isSingular 0 3 (by decide) r05Pattern
    r05SourceLaw r05SourcePosterior r05SourceFactor x
example : IsCanonicalCoupling r05TargetChannel r05Law :=
  isCanonicalCoupling_of_coordinateFactorization r05Law r05TargetChannel
    r05Posterior r05FullFactorization
example (p : PMF (Fin 3)) : IsPerfectFunctionalRepresentation (canonicalJoint p r05Law) :=
  isPerfectFunctionalRepresentation_canonicalJoint_of_coordinateFactorization
    p r05Law r05TargetChannel r05Posterior r05FullFactorization
example : IsPerfectlyRepresentableChannel r05TargetChannel :=
  ppm_isPerfectlyRepresentable r05State r05Perfect.isSingular 0 3 (by decide) r05Pattern r05Perfect

-- R07: actual final-column nonadjacent merge and remembered recovery use the new-to-old map.
example (j : Fin 4) :
    ppmCollapse r05State 0 3 (by decide) j = (![0,1,2,0] : Fin 4 → Fin 3) j := r05Collapse j
example (j : Fin 4) : recoveryPerm (0 : Fin 4) 3 (by decide) j = ![0,3,1,2] j := by
  apply Fin.ext
  fin_cases j <;> norm_num [recoveryPerm_val]
example (x : Fin 3) :
    ((ppmRecovery r05State r05Perfect.isSingular 0 3 (by decide) r05Pattern).channel x).map
      (ppmRecoveryEquiv r05State r05Perfect.isSingular 0 3 (by decide) r05Pattern) = r05Channel x :=
  ppmRecovery_channel r05State r05Perfect.isSingular 0 3 (by decide) r05Pattern x
example (x : Fin 3) :
    (r05Channel x).map
      (ppmRecoveryEquiv r05State r05Perfect.isSingular 0 3 (by decide) r05Pattern).symm =
        (ppmRecovery r05State r05Perfect.isSingular 0 3 (by decide) r05Pattern).channel x :=
  ppmRecovery_channel_inverse r05State r05Perfect.isSingular 0 3 (by decide) r05Pattern x


private abbrev r05RecoveryChannel : Fin 3 → PMF (Fin 4) :=
  (ppmRecovery r05State r05Perfect.isSingular 0 3 (by decide) r05Pattern).channel

-- Unequal surviving masses expose the actual nonadjacent recovery order at the null row.
example (j : Fin 4) : r05RecoveryChannel 2 j = ((![0,0,1/3,2/3] j : NNReal) : ENNReal) := by
  fin_cases j
  · have h := ppmRecovery_left r05State r05Perfect.isSingular 0 3 (by decide) r05Pattern (2 : Fin 3)
    rw [r05Survivor] at h
    change r05RecoveryChannel 2 0 = r05Channel 2 0 at h
    rw [r05SourceMass] at h
    exact h
  · have h := ppmRecovery_right r05State r05Perfect.isSingular 0 3 (by decide)
      r05Pattern (2 : Fin 3)
    rw [r05Survivor] at h
    change r05RecoveryChannel 2 1 = r05Channel 2 3 at h
    rw [r05SourceMass] at h
    exact h
  · have h := ppmRecovery_keep r05State r05Perfect.isSingular 0 3 (by decide) r05Pattern
      (2 : Fin 3) (j := (1 : Fin 3)) (by rw [r05Survivor]; decide)
    rw [r05Survivor, r05Retained] at h
    change r05RecoveryChannel 2 2 = r05Channel 2 1 at h
    rw [r05SourceMass] at h
    exact h
  · have h := ppmRecovery_keep r05State r05Perfect.isSingular 0 3 (by decide) r05Pattern
      (2 : Fin 3) (j := (2 : Fin 3)) (by rw [r05Survivor]; decide)
    rw [r05Survivor, r05Retained] at h
    change r05RecoveryChannel 2 3 = r05Channel 2 2 at h
    rw [r05SourceMass] at h
    exact h

end
end PerfectFunctionalRepresentations.MatrixOperations

namespace PerfectFunctionalRepresentations.MatrixOperations

universe u
variable {alpha : Type u} {n : Nat}
noncomputable section

private def vpsVectorLift (l : Fin n) (mask : alpha → Bool)
    (w : alpha → Fin n) : alpha → Fin (n + 1) :=
  fun x => vpsIndex l (mask x) (w x)

private def vpsVectorLaw (l : Fin n) (mask : alpha → Bool)
    (q : PMF (alpha → Fin n)) : PMF (alpha → Fin (n + 1)) :=
  q.map (vpsVectorLift l mask)

private def vpsPosterior (l : Fin n) (mask : alpha → Bool)
    (V : Fin n → PMF (alpha → Fin n)) : Fin (n + 1) → PMF (alpha → Fin (n + 1)) :=
  fun y => (V (ppsCollapse l y)).map (vpsVectorLift l mask)

private theorem vpsPosterior_left (l : Fin n) (mask : alpha → Bool)
    (V : Fin n → PMF (alpha → Fin n)) :
    vpsPosterior l mask V (splitLeft l) = (V l).map (vpsVectorLift l mask) := by
  rw [vpsPosterior, ppsCollapse_left]

private theorem vpsPosterior_right (l : Fin n) (mask : alpha → Bool)
    (V : Fin n → PMF (alpha → Fin n)) :
    vpsPosterior l mask V (splitRight l) = (V l).map (vpsVectorLift l mask) := by
  rw [vpsPosterior, ppsCollapse_right]

private theorem vpsPosterior_keep (l : Fin n) (mask : alpha → Bool)
    (V : Fin n → PMF (alpha → Fin n)) (j : Fin n) :
    vpsPosterior l mask V (splitKeep l j) = (V j).map (vpsVectorLift l mask) := by
  rw [vpsPosterior, ppsCollapse_keep]

private theorem vps_factorization (K : alpha → PMF (Fin n))
    (q : PMF (alpha → Fin n)) (V : Fin n → PMF (alpha → Fin n))
    (h : ∀ x, q.map (fun w => (w x, w)) = PMF.channelJoint (K x) V)
    (l : Fin n) (mask : alpha → Bool) (x : alpha) :
    (vpsVectorLaw l mask q).map (fun w => (w x, w)) =
      PMF.channelJoint (vpsRaw K l mask x) (vpsPosterior l mask V) := by
  have hm := congrArg (fun p : PMF (Fin n × (alpha → Fin n)) =>
    p.map (fun yw => (vpsIndex l (mask x) yw.1, vpsVectorLift l mask yw.2))) (h x)
  simpa only [vpsVectorLaw, PMF.map_comp, PMF.channelJoint, PMF.map_bind,
    PMF.bind_map, Function.comp_def, vpsRaw, vpsVectorLift, vpsPosterior,
    ppsCollapse_index] using hm

/-- Legal VPS preserves intrinsic perfect representability by one deterministic map
of the canonical vector. Both children share the transported selected-output posterior. -/
theorem vps_isPerfectlyRepresentable [Finite alpha] [Nonempty alpha]
    (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (mask : alpha → Bool)
    (hleft : ∃ x, S.channel x l ≠ 0 ∧ mask x = true)
    (hright : ∃ x, S.channel x l ≠ 0 ∧ mask x = false)
    (hP : IsPerfectlyRepresentableChannel S.channel) :
    IsPerfectlyRepresentableChannel (vps S hS l mask hleft hright).channel := by
  obtain ⟨q, V, h⟩ := hP
  refine ⟨vpsVectorLaw l mask q, vpsPosterior l mask V, ?_⟩
  intro x
  exact vps_factorization S.channel q V h l mask x

end
end PerfectFunctionalRepresentations.MatrixOperations


/-! Private R08-R10 checks inspect the actual whole-vector VPS witness. -/
namespace PerfectFunctionalRepresentations.MatrixOperations
open scoped ENNReal
open LeanInfoTheory.Shannon
noncomputable section

private def r08Mask : Fin 2 → Bool := ![true,false]
private def r08SourceVector : Fin 2 → Fin 1 := fun _ => 0
private def r08Vector : Fin 2 → Fin 2 := ![0,1]
private def r08SourceLaw : PMF (Fin 2 → Fin 1) := PMF.pure r08SourceVector
private def r08SourcePosterior : Fin 1 → PMF (Fin 2 → Fin 1) := fun _ => r08SourceLaw
private theorem r08SourceFactor (x : Fin 2) :
    r08SourceLaw.map (fun w => (w x,w)) =
      PMF.channelJoint ((ActiveFiniteChannel.allOnes (Fin 2)).channel x) r08SourcePosterior := by
  simp [r08SourceLaw, r08SourcePosterior, r08SourceVector,
    ActiveFiniteChannel.allOnes_channel, PMF.channelJoint, PMF.pure_map]
private theorem r08Left : ∃ x, (ActiveFiniteChannel.allOnes (Fin 2)).channel x (0 : Fin 1) ≠ 0 ∧
    r08Mask x = true :=
  ⟨0, by rw [ActiveFiniteChannel.allOnes_apply]; exact one_ne_zero, by decide⟩
private theorem r08Right : ∃ x, (ActiveFiniteChannel.allOnes (Fin 2)).channel x (0 : Fin 1) ≠ 0 ∧
    r08Mask x = false :=
  ⟨1, by rw [ActiveFiniteChannel.allOnes_apply]; exact one_ne_zero, by decide⟩
private abbrev r08TargetChannel : Fin 2 → PMF (Fin 2) :=
  (vps (ActiveFiniteChannel.allOnes (Fin 2)) (ActiveFiniteChannel.allOnes_isSingular _)
    (0 : Fin 1) r08Mask r08Left r08Right).channel
private def r08Law : PMF (Fin 2 → Fin 2) := vpsVectorLaw 0 r08Mask r08SourceLaw
private def r08Posterior : Fin 2 → PMF (Fin 2 → Fin 2) :=
  vpsPosterior 0 r08Mask r08SourcePosterior
private theorem r08Lift : vpsVectorLift 0 r08Mask r08SourceVector = r08Vector := by
  funext x
  fin_cases x <;> rfl
private theorem r08Law_eq : r08Law = PMF.pure r08Vector := by
  change (PMF.pure r08SourceVector).map (vpsVectorLift 0 r08Mask) = _
  rw [PMF.pure_map, r08Lift]
private theorem r08Posterior_left : r08Posterior 0 = PMF.pure r08Vector := by
  change vpsPosterior 0 r08Mask r08SourcePosterior (splitLeft (0 : Fin 1)) = _
  rw [vpsPosterior_left]
  change (PMF.pure r08SourceVector).map (vpsVectorLift 0 r08Mask) = _
  rw [PMF.pure_map, r08Lift]
private theorem r08Posterior_right : r08Posterior 1 = PMF.pure r08Vector := by
  change vpsPosterior 0 r08Mask r08SourcePosterior (splitRight (0 : Fin 1)) = _
  rw [vpsPosterior_right]
  change (PMF.pure r08SourceVector).map (vpsVectorLift 0 r08Mask) = _
  rw [PMF.pure_map, r08Lift]
private theorem r08TargetRow (x : Fin 2) : r08TargetChannel x = PMF.pure (r08Vector x) := by
  change (PMF.pure (0 : Fin 1)).map (vpsIndex 0 (r08Mask x)) = _
  rw [PMF.pure_map]
  fin_cases x <;> rfl
private theorem r08Value :
    columnValue (ActiveFiniteChannel.allOnes (Fin 2)).channel
      (ActiveFiniteChannel.allOnes_isSingular _)
      ((ActiveFiniteChannel.allOnes (Fin 2)).activeEquiv (0 : Fin 1)) = 1 := by
  have hm : (ActiveFiniteChannel.allOnes (Fin 2)).channel (0 : Fin 2)
      ((ActiveFiniteChannel.allOnes (Fin 2)).activeEquiv (0 : Fin 1)) = 1 := by
    change (PMF.pure (0 : Fin 1)) 0 = 1
    exact PMF.pure_apply_self 0
  exact (columnValue_eq_of_ne_zero _ _ _ (x := (0 : Fin 2))
    (ne_of_eq_of_ne hm one_ne_zero)).trans hm

-- The legal domain includes value one, with child masses on opposite rows.
example : columnValue (ActiveFiniteChannel.allOnes (Fin 2)).channel
      (ActiveFiniteChannel.allOnes_isSingular _)
      ((ActiveFiniteChannel.allOnes (Fin 2)).activeEquiv (0 : Fin 1)) = 1 ∧
    r08TargetChannel 0 0 = 1 ∧ r08TargetChannel 0 1 = 0 ∧
    r08TargetChannel 1 0 = 0 ∧ r08TargetChannel 1 1 = 1 := by
  refine ⟨r08Value, ?_⟩
  simp [r08TargetRow, r08Vector, PMF.pure_apply]

example : r08Law = PMF.pure r08Vector ∧ r08Posterior 0 = PMF.pure r08Vector ∧
    r08Posterior 1 = PMF.pure r08Vector :=
  ⟨r08Law_eq, r08Posterior_left, r08Posterior_right⟩

example (w : Fin 2 → Fin 2) :
    PMF.channelJoint (r08TargetChannel 0) r08Posterior (1,w) = 0 ∧
    PMF.channelJoint (r08TargetChannel 1) r08Posterior (0,w) = 0 := by
  simp [PMF.channelJoint_apply, r08TargetRow, r08Vector, PMF.pure_apply]

private theorem r08FullFactorization (x : Fin 2) :
    r08Law.map (fun w => (w x,w)) = PMF.channelJoint (r08TargetChannel x) r08Posterior :=
  vps_factorization (ActiveFiniteChannel.allOnes (Fin 2)).channel r08SourceLaw
    r08SourcePosterior r08SourceFactor (0 : Fin 1) r08Mask x

example : IsCanonicalCoupling r08TargetChannel r08Law :=
  isCanonicalCoupling_of_coordinateFactorization
    r08Law r08TargetChannel r08Posterior r08FullFactorization
example (p : PMF (Fin 2)) : IsPerfectFunctionalRepresentation (canonicalJoint p r08Law) :=
  isPerfectFunctionalRepresentation_canonicalJoint_of_coordinateFactorization
    p r08Law r08TargetChannel r08Posterior r08FullFactorization
example : IsPerfectlyRepresentableChannel r08TargetChannel :=
  vps_isPerfectlyRepresentable (ActiveFiniteChannel.allOnes (Fin 2))
    (ActiveFiniteChannel.allOnes_isSingular _) (0 : Fin 1) r08Mask r08Left r08Right
    (ActiveFiniteChannel.allOnes_isPerfectlyRepresentable _)

-- Reuse R05's complete unequal-mixture source; only the selected support is split.
private def r09Mask : Fin 3 → Bool := ![true,false,false]
private def r09AltMask : Fin 3 → Bool := ![true,false,true]
private def r09BadMask : Fin 3 → Bool := ![true,true,false]
private def r09A : Fin 3 → Fin 5 := ![0,1,2]
private def r09B : Fin 3 → Fin 5 := ![4,4,3]
private def r09Other : Fin 3 → Fin 5 := ![0,1,3]
private theorem r09AB_ne : r09A ≠ r09B := by decide
private theorem r09AOther_ne : r09A ≠ r09Other := by decide
private theorem r09BOther_ne : r09B ≠ r09Other := by decide
private theorem r09SelectedSupport (x : Fin 3) : r05State.channel x 0 ≠ 0 ↔ x ≠ 2 := by
  change r05Channel x 0 ≠ 0 ↔ x ≠ 2
  rw [r05SourceMass]
  fin_cases x <;> norm_num [r05SourceWeights, Fin.ext_iff]
private theorem r09Left : ∃ x, r05State.channel x 0 ≠ 0 ∧ r09Mask x = true :=
  ⟨0, (r09SelectedSupport 0).2 (by decide), by decide⟩
private theorem r09Right : ∃ x, r05State.channel x 0 ≠ 0 ∧ r09Mask x = false :=
  ⟨1, (r09SelectedSupport 1).2 (by decide), by decide⟩
private theorem r09AltLeft : ∃ x, r05State.channel x 0 ≠ 0 ∧ r09AltMask x = true :=
  ⟨0, (r09SelectedSupport 0).2 (by decide), by decide⟩
private theorem r09AltRight : ∃ x, r05State.channel x 0 ≠ 0 ∧ r09AltMask x = false :=
  ⟨1, (r09SelectedSupport 1).2 (by decide), by decide⟩
private abbrev r09TargetChannel : Fin 3 → PMF (Fin 5) :=
  (vps r05State r05Perfect.isSingular 0 r09Mask r09Left r09Right).channel
private def r09Law : PMF (Fin 3 → Fin 5) := vpsVectorLaw 0 r09Mask r05SourceLaw
private def r09Posterior : Fin 5 → PMF (Fin 3 → Fin 5) :=
  vpsPosterior 0 r09Mask r05SourcePosterior
private theorem r09LiftA : vpsVectorLift 0 r09Mask r05A = r09A := by
  funext x
  fin_cases x <;> rfl
private theorem r09LiftB : vpsVectorLift 0 r09Mask r05B = r09B := by
  funext x
  fin_cases x <;> rfl
private theorem r09Law_eq : r09Law =
    PMF.binaryMixture r05Weight r05Weight_lt_one.le (PMF.pure r09A) (PMF.pure r09B) := by
  change r05SourceLaw.map (vpsVectorLift 0 r09Mask) = _
  rw [r05SourceLaw, map_binaryMixture, PMF.pure_map, PMF.pure_map, r09LiftA, r09LiftB]
private theorem r09Posterior0 : r09Posterior 0 = PMF.pure r09A := by
  change vpsPosterior 0 r09Mask r05SourcePosterior (splitLeft (0 : Fin 4)) = _
  rw [vpsPosterior_left]
  change (PMF.pure r05A).map (vpsVectorLift 0 r09Mask) = _
  rw [PMF.pure_map, r09LiftA]
private theorem r09Posterior1 : r09Posterior 1 = PMF.pure r09A := by
  change vpsPosterior 0 r09Mask r05SourcePosterior (splitRight (0 : Fin 4)) = _
  rw [vpsPosterior_right]
  change (PMF.pure r05A).map (vpsVectorLift 0 r09Mask) = _
  rw [PMF.pure_map, r09LiftA]
private theorem r09Posterior2 : r09Posterior 2 = PMF.pure r09A := by
  change vpsPosterior 0 r09Mask r05SourcePosterior (splitKeep (0 : Fin 4) 1) = _
  rw [vpsPosterior_keep _ _ _ (1 : Fin 4)]
  change (PMF.pure r05A).map (vpsVectorLift 0 r09Mask) = _
  rw [PMF.pure_map, r09LiftA]
private theorem r09Posterior3 : r09Posterior 3 = PMF.pure r09B := by
  change vpsPosterior 0 r09Mask r05SourcePosterior (splitKeep (0 : Fin 4) 2) = _
  rw [vpsPosterior_keep _ _ _ (2 : Fin 4)]
  change (PMF.pure r05B).map (vpsVectorLift 0 r09Mask) = _
  rw [PMF.pure_map, r09LiftB]
private theorem r09Posterior4 : r09Posterior 4 = PMF.pure r09B := by
  change vpsPosterior 0 r09Mask r05SourcePosterior (splitKeep (0 : Fin 4) 3) = _
  rw [vpsPosterior_keep _ _ _ (3 : Fin 4)]
  change (PMF.pure r05B).map (vpsVectorLift 0 r09Mask) = _
  rw [PMF.pure_map, r09LiftB]
private theorem r09TargetRow (x : Fin 3) : r09TargetChannel x =
    PMF.binaryMixture r05Weight r05Weight_lt_one.le (PMF.pure (r09A x)) (PMF.pure (r09B x)) := by
  change (r05Channel x).map (vpsIndex 0 (r09Mask x)) = _
  rw [r05Channel, map_binaryMixture, PMF.pure_map, PMF.pure_map]
  change PMF.binaryMixture r05Weight _
    (PMF.pure (vpsVectorLift 0 r09Mask r05A x))
    (PMF.pure (vpsVectorLift 0 r09Mask r05B x)) = _
  rw [r09LiftA, r09LiftB]
private def r09Weights : Fin 3 → Fin 5 → NNReal :=
  ![![1/3,0,0,0,2/3], ![0,1/3,0,0,2/3], ![0,0,1/3,2/3,0]]
private theorem r09Mass (x : Fin 3) (j : Fin 5) :
    r09TargetChannel x j = (r09Weights x j : ENNReal) := by
  rw [r09TargetRow, PMF.binaryMixture_apply, r05Complement]
  fin_cases x <;> fin_cases j <;>
    norm_num [r09Weights, r09A, r09B, r05Weight, PMF.pure_apply, Fin.ext_iff,
      Matrix.cons_val_two, Matrix.cons_val_three]

example (x : Fin 3) (j : Fin 5) : r09TargetChannel x j = (r09Weights x j : ENNReal) :=
  r09Mass x j
example : r09Law r09A = (1 : ENNReal)/3 ∧ r09Law r09B = (2 : ENNReal)/3 ∧
    r09Law r09Other = 0 := by
  rw [r09Law_eq]
  simp only [PMF.binaryMixture_apply, r05Complement]
  norm_num [r05Weight, PMF.pure_apply, r09AB_ne, Ne.symm r09AB_ne,
    Ne.symm r09AOther_ne, Ne.symm r09BOther_ne]
example : r09Posterior 0 = PMF.pure r09A ∧ r09Posterior 1 = PMF.pure r09A ∧
    r09Posterior 2 = PMF.pure r09A ∧ r09Posterior 3 = PMF.pure r09B ∧
    r09Posterior 4 = PMF.pure r09B :=
  ⟨r09Posterior0, r09Posterior1, r09Posterior2, r09Posterior3, r09Posterior4⟩

example (w : Fin 3 → Fin 5) :
    PMF.channelJoint (r09TargetChannel 0) r09Posterior (1,w) = 0 ∧
    PMF.channelJoint (r09TargetChannel 1) r09Posterior (0,w) = 0 ∧
    PMF.channelJoint (r09TargetChannel 2) r09Posterior (0,w) = 0 ∧
    PMF.channelJoint (r09TargetChannel 2) r09Posterior (1,w) = 0 := by
  simp only [PMF.channelJoint_apply, r09Mass]
  norm_num [r09Weights, Matrix.cons_val_two]

example : PMF.channelJoint (r09TargetChannel 0) r09Posterior (0,r09A) = (1 : ENNReal)/3 ∧
    PMF.channelJoint (r09TargetChannel 1) r09Posterior (1,r09A) = (1 : ENNReal)/3 ∧
    PMF.channelJoint (r09TargetChannel 0) r09Posterior (4,r09B) = (2 : ENNReal)/3 ∧
    PMF.channelJoint (r09TargetChannel 2) r09Posterior (2,r09A) = (1 : ENNReal)/3 ∧
    PMF.channelJoint (r09TargetChannel 2) r09Posterior (3,r09B) = (2 : ENNReal)/3 ∧
    PMF.channelJoint (r09TargetChannel 2) r09Posterior (2,r09B) = 0 ∧
    PMF.channelJoint (r09TargetChannel 2) r09Posterior (3,r09A) = 0 := by
  simp only [PMF.channelJoint_apply, r09Mass, r09Posterior0, r09Posterior1,
    r09Posterior2, r09Posterior3, r09Posterior4]
  norm_num [r09Weights, Matrix.cons_val_two, Matrix.cons_val_three, PMF.pure_apply,
    Matrix.cons_val_four, r09AB_ne, Ne.symm r09AB_ne]

private theorem r09FullFactorization (x : Fin 3) :
    r09Law.map (fun w => (w x,w)) = PMF.channelJoint (r09TargetChannel x) r09Posterior :=
  vps_factorization r05Channel r05SourceLaw r05SourcePosterior r05SourceFactor 0 r09Mask x
example : IsCanonicalCoupling r09TargetChannel r09Law :=
  isCanonicalCoupling_of_coordinateFactorization
    r09Law r09TargetChannel r09Posterior r09FullFactorization
example (p : PMF (Fin 3)) : IsPerfectFunctionalRepresentation (canonicalJoint p r09Law) :=
  isPerfectFunctionalRepresentation_canonicalJoint_of_coordinateFactorization
    p r09Law r09TargetChannel r09Posterior r09FullFactorization
example : IsPerfectlyRepresentableChannel r09TargetChannel :=
  vps_isPerfectlyRepresentable r05State r05Perfect.isSingular 0 r09Mask r09Left r09Right r05Perfect

-- Endpoint equality uses agreement only on the selected support.
example : r09Mask 2 ≠ r09AltMask 2 ∧
    r09TargetChannel =
      (vps r05State r05Perfect.isSingular 0 r09AltMask r09AltLeft r09AltRight).channel := by
  refine ⟨by decide, vps_mask_irrelevant _ _ _ _ _ _ _ _ _ ?_⟩
  intro x hx
  have h := (r09SelectedSupport x).1 hx
  fin_cases x <;> simp_all [r09Mask, r09AltMask]

-- The full maps may differ despite equal endpoint channels.
example : vpsVectorLift (0 : Fin 4) r09Mask (fun _ => 0) ≠
    vpsVectorLift (0 : Fin 4) r09AltMask (fun _ => 0) := by decide

-- A globally nonconstant mask does not supply both selected-support witnesses.
example : r09BadMask 0 ≠ r09BadMask 2 ∧
    ¬ ∃ x, r05State.channel x 0 ≠ 0 ∧ r09BadMask x = false := by
  refine ⟨by decide, ?_⟩
  rintro ⟨x, hx, hm⟩
  have h := (r09SelectedSupport x).1 hx
  fin_cases x <;> simp_all [r09BadMask]

end
end PerfectFunctionalRepresentations.MatrixOperations

namespace PerfectFunctionalRepresentations.MatrixOperations

universe u
variable {alpha : Type u} [Finite alpha] [Nonempty alpha]

/-- Legal PPS preserves nonperfectness: PPM of its two children recovers the source. -/
theorem pps_not_isPerfectlyRepresentable (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (l : Fin S.outputCard)
    (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1)
    (hNP : ¬ IsPerfectlyRepresentableChannel S.channel) :
    ¬ IsPerfectlyRepresentableChannel (pps S hS l t ht0 ht1).channel := by
  intro hP
  apply hNP
  have hR : IsPerfectlyRepresentableChannel (ppsRecovery S hS l t ht0 ht1).channel :=
    ppm_isPerfectlyRepresentable (pps S hS l t ht0 ht1) (pps_isSingular S hS l t ht0 ht1)
      (splitLeft l) (splitRight l) (by exact Fin.castSucc_lt_succ)
      (pps_children_sameSupport S hS l t ht0 ht1) hP
  have hMap := (isPerfectlyRepresentableChannel_map_iff
    (ppsRecovery S hS l t ht0 ht1).channel
    (finCongr (ppsRecovery_outputCard S hS l t ht0 ht1))
    (finCongr (ppsRecovery_outputCard S hS l t ht0 ht1)).injective).2 hR
  simpa only [ppsRecovery_channel] using hMap

/-- Legal PPM preserves nonperfectness by PPS at its remembered ratio and the
specified recovered-to-original output equivalence. -/
theorem ppm_not_isPerfectlyRepresentable (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0)
    (hNP : ¬ IsPerfectlyRepresentableChannel S.channel) :
    ¬ IsPerfectlyRepresentableChannel (ppm S hS a b hab hp).channel := by
  intro hP
  apply hNP
  have hR : IsPerfectlyRepresentableChannel (ppmRecovery S hS a b hab hp).channel :=
    pps_isPerfectlyRepresentable (ppm S hS a b hab hp) (ppm_isSingular S hS a b hab hp)
      (activeMergeSurvivor S a b hab) (ppmRatio S hS a b)
      (ppmRatio_pos S hS a b) (ppmRatio_lt_one S hS a b) hP
  have hMap := (isPerfectlyRepresentableChannel_map_iff
    (ppmRecovery S hS a b hab hp).channel (ppmRecoveryEquiv S hS a b hab hp)
    (ppmRecoveryEquiv S hS a b hab hp).injective).2 hR
  simpa only [ppmRecovery_channel] using hMap

/-- Legal VPM preserves nonperfectness by VPS with its remembered support mask
and the specified recovered-to-original output equivalence. -/
theorem vpm_not_isPerfectlyRepresentable (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (a b : Fin S.outputCard) (hab : a < b)
    (hv : columnValue S.channel hS (S.activeEquiv a) =
      columnValue S.channel hS (S.activeEquiv b))
    (hd : ∀ x, S.channel x a ≠ 0 → S.channel x b = 0)
    (hNP : ¬ IsPerfectlyRepresentableChannel S.channel) :
    ¬ IsPerfectlyRepresentableChannel (vpm S hS a b hab hv hd).channel := by
  intro hP
  apply hNP
  have hR : IsPerfectlyRepresentableChannel (vpmRecovery S hS a b hab hv hd).channel :=
    vps_isPerfectlyRepresentable (vpm S hS a b hab hv hd) (vpm_isSingular S hS a b hab hv hd)
      (activeMergeSurvivor S a b hab) (vpmRecoveryMask S a)
      (vpmRecovery_leftWitness S hS a b hab hv hd)
      (vpmRecovery_rightWitness S hS a b hab hv hd) hP
  have hMap := (isPerfectlyRepresentableChannel_map_iff
    (vpmRecovery S hS a b hab hv hd).channel (vpmRecoveryEquiv S hS a b hab hv hd)
    (vpmRecoveryEquiv S hS a b hab hv hd).injective).2 hR
  simpa only [vpmRecovery_channel] using hMap

end PerfectFunctionalRepresentations.MatrixOperations
