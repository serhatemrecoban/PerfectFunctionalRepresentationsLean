import PerfectFunctionalRepresentations.Matrix.Channel
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum

/-!
# Exact channel-coordinate regressions

C06 S01: R01 checks a genuinely rectangular channel with distinct rows, zero
entries and exact fractional masses. R02 consumes both inverse laws and
extensionality at independent universes and with infinite input. Raw R04
permits the vacuous empty-input channel, including a 0-by-0 matrix, while
rejecting a PMF row on an empty output alphabet.

S02 adds R03 Real reconstruction and numeric premise guards, plus the R06/R07
singularity cases with ambient zero columns and unequal positive entries.
S03 adds finite active states, explicit presentations and transport, with
independent permutation directions and the support-sensitive prior boundary.
-/

namespace PerfectFunctionalRepresentations

open scoped BigOperators ENNReal

universe u v u' v' u'' v''

section General

variable {alpha : Type u} {beta : Type v}

example (kappa eta : alpha → PMF beta)
    (h : ∀ x y, massMatrix kappa x y = massMatrix eta x y) : kappa = eta := by
  apply massMatrix_injective
  funext x y
  exact h x y

example [Fintype beta] (M : Matrix alpha beta ℝ≥0∞) (h : ∀ x, ∑ y, M x y = 1) :
    massMatrix (channelOfMassMatrix M h) = M := massMatrix_channelOfMassMatrix M h

example [Fintype beta] (kappa : alpha → PMF beta) :
    channelOfMassMatrix (massMatrix kappa) (massMatrix_row_sum kappa) = kappa :=
  channelOfMassMatrix_massMatrix kappa

-- Bounds and finiteness of supplied entries follow from normalization alone.
example [Fintype beta] (M : Matrix alpha beta ℝ≥0∞) (h : ∀ x, ∑ y, M x y = 1)
    (x : alpha) (y : beta) : M x y ≤ 1 ∧ M x y ≠ ∞ :=
  ⟨massMatrix_le_one (channelOfMassMatrix M h) x y,
    massMatrix_ne_top (channelOfMassMatrix M h) x y⟩

-- Neither an infinite input nor an infinite output obstructs raw coordinates.
example (kappa : Nat → PMF Nat) : massMatrix kappa 17 23 = kappa 17 23 := rfl

example [Fintype beta] (kappa : Nat → PMF beta) :
    channelOfMassMatrix (massMatrix kappa) (massMatrix_row_sum kappa) = kappa :=
  channelOfMassMatrix_massMatrix kappa

end General

private noncomputable def rectangularMass (x : Fin 2) (y : Fin 3) : ℝ≥0∞ :=
  if x.val = 0 then (if y.val = 0 then 1 else 0) else (if y.val = 0 then 0 else 1 / 2)

private theorem rectangularMass_sum (x : Fin 2) : ∑ y, rectangularMass x y = 1 := by
  fin_cases x
  · norm_num [rectangularMass, Fin.sum_univ_succ]
  · norm_num [rectangularMass, Fin.sum_univ_succ]
    exact ENNReal.mul_inv_cancel (by norm_num) (by simp)

private noncomputable def rectangularChannel : Fin 2 → PMF (Fin 3) :=
  fun x => PMF.ofFintype (rectangularMass x) (rectangularMass_sum x)

-- R01: literals distinguish the two rows and three output columns.
example : massMatrix rectangularChannel 0 0 = 1 ∧
    massMatrix rectangularChannel 0 1 = 0 ∧
    massMatrix rectangularChannel 1 0 = 0 ∧
    massMatrix rectangularChannel 1 1 = 1 / 2 ∧
    massMatrix rectangularChannel 1 2 = 1 / 2 :=
  ⟨rfl, rfl, rfl, rfl, rfl⟩

example (x : Fin 2) (y : Fin 3) :
    massMatrix rectangularChannel x y ≤ 1 ∧ massMatrix rectangularChannel x y ≠ ∞ :=
  ⟨massMatrix_le_one _ _ _, massMatrix_ne_top _ _ _⟩

example (x : Fin 2) : ∑ y, massMatrix rectangularChannel x y = 1 :=
  massMatrix_row_sum _ _

-- R02: independent exact matrix input has both pointwise and semantic recovery.
example : massMatrix (channelOfMassMatrix rectangularMass rectangularMass_sum) =
    rectangularMass := massMatrix_channelOfMassMatrix _ _

example : channelOfMassMatrix rectangularMass rectangularMass_sum = rectangularChannel := by
  apply massMatrix_injective
  ext x y
  rfl

example : channelOfMassMatrix (massMatrix rectangularChannel)
    (massMatrix_row_sum rectangularChannel) = rectangularChannel :=
  channelOfMassMatrix_massMatrix _

-- Raw R04: empty input permits an empty output, with no manufactured PMF row.
private def emptyChannel : Fin 0 → PMF (Fin 0) := fun x => Fin.elim0 x

example : channelOfMassMatrix (massMatrix emptyChannel)
    (massMatrix_row_sum emptyChannel) = emptyChannel := channelOfMassMatrix_massMatrix _

example : massMatrix (channelOfMassMatrix (0 : Matrix (Fin 0) (Fin 0) ℝ≥0∞)
    (fun x => Fin.elim0 x)) = 0 := massMatrix_channelOfMassMatrix _ _

example : ¬ Nonempty (Unit → PMF (Fin 0)) := by
  rintro ⟨kappa⟩
  obtain ⟨y, _⟩ := (kappa ()).support_nonempty
  exact Fin.elim0 y

example : ¬ ∃ M : Matrix Unit (Fin 0) ℝ≥0∞, ∀ x, ∑ y, M x y = 1 := by
  rintro ⟨M, h⟩
  have hrow := h ()
  simp at hrow

/-! ## R03: both Real reconstruction directions and conversion premises -/

section RealGeneral

variable {alpha : Type u} {beta : Type v}

example [Fintype beta] (A : Matrix alpha beta ℝ) (hn : ∀ x y, 0 ≤ A x y)
    (hs : ∀ x, ∑ y, A x y = 1) :
    realMatrix (channelOfRealMatrix A hn hs) = A := realMatrix_channelOfRealMatrix _ _ _

example [Fintype beta] (A : Matrix alpha beta ℝ) (hn : ∀ x y, 0 ≤ A x y)
    (hs : ∀ x, ∑ y, A x y = 1) (x : alpha) (y : beta) : A x y ≤ 1 := by
  rw [← realMatrix_channelOfRealMatrix A hn hs]
  exact realMatrix_le_one _ _ _

example [Fintype beta] (kappa : alpha → PMF beta) :
    channelOfRealMatrix (realMatrix kappa) (realMatrix_nonneg kappa)
      (realMatrix_row_sum kappa) = kappa := channelOfRealMatrix_realMatrix _

example (kappa eta : alpha → PMF beta)
    (h : ∀ x y, realMatrix kappa x y = realMatrix eta x y) : kappa = eta := by
  apply realMatrix_injective
  funext x y
  exact h x y

example (kappa : alpha → PMF beta) (x : alpha) (y : beta) :
    ENNReal.ofReal (realMatrix kappa x y) = massMatrix kappa x y := ofReal_realMatrix _ _ _

example (kappa : alpha → PMF beta) :
    HasSingularColumns (massMatrix kappa) ↔ HasSingularColumns (realMatrix kappa) :=
  (hasSingularColumns_massMatrix_iff _).trans (hasSingularColumns_realMatrix_iff _).symm

example (kappa : alpha → PMF beta) (h : IsSingularChannel kappa) (x1 x2 : alpha) (y : beta)
    (hp : 0 < realMatrix kappa x1 y * realMatrix kappa x2 y) :
    realMatrix kappa x1 y = realMatrix kappa x2 y :=
  (hasSingularColumns_realMatrix_iff_mul_pos _).1
    ((hasSingularColumns_realMatrix_iff _).2 h) x1 x2 y hp

example (kappa : alpha → PMF beta) (h : IsSingularChannel kappa) (x1 x2 : alpha) (y : beta)
    (hp : 0 < massMatrix kappa x1 y * massMatrix kappa x2 y) :
    massMatrix kappa x1 y = massMatrix kappa x2 y :=
  (hasSingularColumns_massMatrix_iff_mul_pos _).1
    ((hasSingularColumns_massMatrix_iff _).2 h) x1 x2 y hp

example (kappa : Nat → PMF Nat) (x y : Nat) :
    0 ≤ realMatrix kappa x y ∧ realMatrix kappa x y ≤ 1 :=
  ⟨realMatrix_nonneg _ _ _, realMatrix_le_one _ _ _⟩

end RealGeneral

example : realMatrix rectangularChannel 0 0 = 1 ∧
    realMatrix rectangularChannel 0 1 = 0 ∧
    realMatrix rectangularChannel 1 0 = 0 ∧
    realMatrix rectangularChannel 1 1 = 1 / 2 ∧
    realMatrix rectangularChannel 1 2 = 1 / 2 := by
  change (1 : ℝ≥0∞).toReal = 1 ∧ (0 : ℝ≥0∞).toReal = 0 ∧
    (0 : ℝ≥0∞).toReal = 0 ∧ (1 / 2 : ℝ≥0∞).toReal = 1 / 2 ∧
    (1 / 2 : ℝ≥0∞).toReal = 1 / 2
  norm_num

example (x : Fin 2) : ∑ y, realMatrix rectangularChannel x y = 1 := realMatrix_row_sum _ _

example : realMatrix (channelOfRealMatrix (0 : Matrix (Fin 0) (Fin 0) ℝ)
    (fun x => Fin.elim0 x) (fun x => Fin.elim0 x)) = 0 := realMatrix_channelOfRealMatrix _ _ _

example : channelOfRealMatrix (realMatrix emptyChannel) (realMatrix_nonneg emptyChannel)
    (realMatrix_row_sum emptyChannel) = emptyChannel := channelOfRealMatrix_realMatrix _

private def signedRow (_ : Unit) (y : Fin 2) : ℝ := if y.val = 0 then -1 else 2

-- Normalization alone does not prevent ofReal from clipping negative entries.
example (x : Unit) : ∑ y, signedRow x y = 1 := by norm_num [signedRow, Fin.sum_univ_succ]

example : ¬ ∀ x y, 0 ≤ signedRow x y := by
  intro h
  have := h () 0
  norm_num [signedRow] at this

example : ENNReal.ofReal (signedRow () 0) = 0 ∧
    (∑ y, ENNReal.ofReal (signedRow () y)) = 2 := by
  norm_num [signedRow, Fin.sum_univ_succ]

-- Nonnegativity alone does not normalize rows.
example : (∀ x y, 0 ≤ (fun (_ : Unit) (_ : Fin 2) => (1 : ℝ)) x y) ∧
    ¬ (∀ _x : Unit, ∑ _y : Fin 2, (1 : ℝ) = 1) := by
  constructor
  · intros; norm_num
  · intro h
    have := h ()
    norm_num [Fin.sum_univ_succ] at this

-- The Real view cannot reflect arbitrary unnormalized ENNReal entries at infinity.
example : (∞ : ℝ≥0∞).toReal = (0 : ℝ≥0∞).toReal ∧ (∞ : ℝ≥0∞) ≠ 0 := by simp

/-! ## R06/R07: vacuous zero columns versus unequal positive entries -/

private noncomputable def unusedOutputChannel : Fin 2 → PMF (Fin 3) := fun _ => PMF.pure 0

private theorem unusedOutputChannel_isSingular : IsSingularChannel unusedOutputChannel := by
  intro _ _ _ _ _
  rfl

example (x : Fin 2) : massMatrix unusedOutputChannel x 1 = 0 ∧
    realMatrix unusedOutputChannel x 1 = 0 := by
  simp [massMatrix, realMatrix, unusedOutputChannel]

example : HasSingularColumns (massMatrix unusedOutputChannel) ∧
    HasSingularColumns (realMatrix unusedOutputChannel) :=
  ⟨(hasSingularColumns_massMatrix_iff _).2 unusedOutputChannel_isSingular,
    (hasSingularColumns_realMatrix_iff _).2 unusedOutputChannel_isSingular⟩

-- The generic predicate itself permits a zero column, without assigning column data.
example : HasSingularColumns (0 : Matrix (Fin 2) (Fin 3) ℝ) := by
  intro _ _ _ h
  exact False.elim (h rfl)

private noncomputable def nonsingularReal (x : Fin 2) (y : Fin 2) : ℝ :=
  if x.val = 0 then (if y.val = 0 then 1 else 0) else 1 / 2

private theorem nonsingularReal_nonneg (x : Fin 2) (y : Fin 2) : 0 ≤ nonsingularReal x y := by
  fin_cases x <;> fin_cases y <;> norm_num [nonsingularReal]

private theorem nonsingularReal_sum (x : Fin 2) : ∑ y, nonsingularReal x y = 1 := by
  fin_cases x <;> norm_num [nonsingularReal, Fin.sum_univ_succ]

private noncomputable def nonsingularChannel : Fin 2 → PMF (Fin 2) :=
  channelOfRealMatrix nonsingularReal nonsingularReal_nonneg nonsingularReal_sum

private theorem nonsingularChannel_realMatrix : realMatrix nonsingularChannel = nonsingularReal :=
  realMatrix_channelOfRealMatrix _ _ _

example : ∀ y, ∃ x, nonsingularChannel x y ≠ 0 := by
  intro y
  refine ⟨1, (realMatrix_pos_iff _ _ _).1 ?_⟩
  rw [nonsingularChannel_realMatrix]
  norm_num [nonsingularReal]

private theorem nonsingularChannel_not_singular : ¬ IsSingularChannel nonsingularChannel := by
  intro h
  have hc := (hasSingularColumns_realMatrix_iff _).2 h
  have heq := hc 0 1 0 (by rw [nonsingularChannel_realMatrix]; norm_num [nonsingularReal])
    (by rw [nonsingularChannel_realMatrix]; norm_num [nonsingularReal])
  rw [nonsingularChannel_realMatrix] at heq
  norm_num [nonsingularReal] at heq

example : ¬ HasSingularColumns (massMatrix nonsingularChannel) := by
  rw [hasSingularColumns_massMatrix_iff]
  exact nonsingularChannel_not_singular

example : ¬ HasSingularColumns (realMatrix nonsingularChannel) := by
  rw [hasSingularColumns_realMatrix_iff]
  exact nonsingularChannel_not_singular

example : ¬ (∀ x1 x2 y, 0 < realMatrix nonsingularChannel x1 y *
    realMatrix nonsingularChannel x2 y →
      realMatrix nonsingularChannel x1 y = realMatrix nonsingularChannel x2 y) := by
  rw [← hasSingularColumns_realMatrix_iff_mul_pos, hasSingularColumns_realMatrix_iff]
  exact nonsingularChannel_not_singular

/-! ## R04/R05/R07: active-state assumptions and heterogeneous cardinalities -/

-- Unlike the raw empty channel above, the active carrier requires nonempty input.
-- This negative elaboration check fails if that required instance is removed.
example : True := by
  fail_if_success
    have _ : Type := ActiveFiniteChannel (Fin 0)
  trivial

example {alpha : Type u} [Finite alpha] [Nonempty alpha] (s : ActiveFiniteChannel alpha) :
    s.outputCard ≠ 0 := Nat.ne_of_gt s.outputCard_pos

example {alpha : Type u} [Finite alpha] [Nonempty alpha]
    (s : ActiveFiniteChannel alpha) (y : Fin s.outputCard) : ¬ ∀ x, s.channel x y = 0 := by
  intro h
  obtain ⟨x, hx⟩ := s.output_active y
  exact hx (h x)

private noncomputable abbrev oneOutputState (alpha : Type u) [Finite alpha] [Nonempty alpha] :
    ActiveFiniteChannel alpha :=
  ActiveFiniteChannel.ofActive (fun _ => PMF.pure (0 : Fin 1)) (Equiv.refl _) (by
    intro y
    refine ⟨Classical.choice (inferInstance : Nonempty alpha), ?_⟩
    fin_cases y
    simp)

example : (oneOutputState Unit).outputCard = 1 ∧
    massMatrix (oneOutputState Unit).channel () (0 : Fin 1) = 1 ∧
    realMatrix (oneOutputState Unit).channel () (0 : Fin 1) = 1 := by
  refine ⟨rfl, ?_, ?_⟩
  · change ((PMF.pure (0 : Fin 1)).map id) 0 = 1
    rw [PMF.map_id]
    simp
  · change (((PMF.pure (0 : Fin 1)).map id) 0).toReal = 1
    rw [PMF.map_id]
    simp

private theorem rectangularChannel_active : ∀ y, ∃ x, rectangularChannel x y ≠ 0 := by
  intro y
  fin_cases y
  · exact ⟨0, by norm_num [rectangularChannel, rectangularMass, PMF.ofFintype_apply]⟩
  · exact ⟨1, by norm_num [rectangularChannel, rectangularMass, PMF.ofFintype_apply]⟩
  · exact ⟨1, by norm_num [rectangularChannel, rectangularMass, PMF.ofFintype_apply]⟩

private noncomputable abbrev rectangularState : ActiveFiniteChannel (Fin 2) where
  outputCard := 3
  outputCard_pos := by decide
  channel := rectangularChannel
  output_active := rectangularChannel_active

-- Output cardinality belongs to the state, not to its fixed input type.
example : (oneOutputState (Fin 2)).outputCard = 1 ∧ rectangularState.outputCard = 3 := ⟨rfl, rfl⟩

example (x : Fin 2) (y : Fin 3) :
    rectangularState.channel x y = rectangularChannel x y := rfl

example : ¬ (∀ y, ∃ x, unusedOutputChannel x y ≠ 0) := by
  intro h
  obtain ⟨x, hx⟩ := h 1
  simp [unusedOutputChannel] at hx

private noncomputable abbrev nonsingularState : ActiveFiniteChannel (Fin 2) :=
  ActiveFiniteChannel.ofActive nonsingularChannel (Equiv.refl _) (by
    intro y
    refine ⟨1, (realMatrix_pos_iff _ _ _).1 ?_⟩
    rw [nonsingularChannel_realMatrix]
    norm_num [nonsingularReal])

example : (∀ y, ∃ x, nonsingularState.channel x y ≠ 0) ∧
    ¬ IsSingularChannel nonsingularState.channel := by
  refine ⟨nonsingularState.output_active, ?_⟩
  simpa only [nonsingularState, ActiveFiniteChannel.ofActive, Equiv.coe_refl, PMF.map_id] using
    nonsingularChannel_not_singular

/-! ## R08/R09/R11: explicit finite presentations and independent universes -/

section Presentations

variable {alpha : Type u} {beta : Type v} [Finite alpha] [Nonempty alpha]

-- The supplied equivalence supplies finiteness of the output alphabet internally.
example (kappa : alpha → PMF beta) {m : Nat} (e : beta ≃ Fin m)
    (h : ∀ y, ∃ x, kappa x y ≠ 0) (x : alpha) (y : beta) :
    ((ActiveFiniteChannel.ofActive kappa e h).channel x).map e.symm = kappa x ∧
      (ActiveFiniteChannel.ofActive kappa e h).channel x (e y) = kappa x y :=
  ⟨ActiveFiniteChannel.ofActive_recover _ _ _ _, ActiveFiniteChannel.ofActive_apply _ _ _ _ _⟩

example (kappa : alpha → PMF beta) {m n : Nat}
    (e : activeOutputs kappa ≃ Fin m) (f : activeOutputs kappa ≃ Fin n) (x : alpha) :
    ((ActiveFiniteChannel.ofChannelWithEquiv kappa e).channel x).map
      (fun j => (e.symm j).val) = kappa x ∧
    ((ActiveFiniteChannel.ofChannelWithEquiv kappa e).channel x).map (e.symm.trans f) =
      (ActiveFiniteChannel.ofChannelWithEquiv kappa f).channel x :=
  ⟨ActiveFiniteChannel.ofChannelWithEquiv_recover _ _ _,
    ActiveFiniteChannel.ofChannelWithEquiv_compare _ _ _ _⟩

-- Enumeration is internal: no public Fintype, default output or decidable equality is supplied.
example [Finite beta] (kappa : alpha → PMF beta) (x : alpha) :
    ((ActiveFiniteChannel.ofChannel kappa).channel x).map
      (ActiveFiniteChannel.ambientLabel kappa) = kappa x ∧
    (IsSingularChannel (ActiveFiniteChannel.ofChannel kappa).channel ↔ IsSingularChannel kappa) ∧
    (IsPerfectlyRepresentableChannel (ActiveFiniteChannel.ofChannel kappa).channel ↔
      IsPerfectlyRepresentableChannel kappa) :=
  ⟨ActiveFiniteChannel.ofChannel_recover _ _,
    ActiveFiniteChannel.isSingularChannel_ofChannel_iff _,
    ActiveFiniteChannel.isPerfectlyRepresentableChannel_ofChannel_iff _⟩

example [Finite beta] (kappa : alpha → PMF beta) (x : alpha)
    (j : Fin (ActiveFiniteChannel.ofChannel kappa).outputCard) :
    massMatrix (ActiveFiniteChannel.ofChannel kappa).channel x j =
      massMatrix kappa x (ActiveFiniteChannel.ambientLabel kappa j) ∧
    realMatrix (ActiveFiniteChannel.ofChannel kappa).channel x j =
      realMatrix kappa x (ActiveFiniteChannel.ambientLabel kappa j) :=
  ⟨ActiveFiniteChannel.ofChannel_apply _ _ _,
    congrArg ENNReal.toReal (ActiveFiniteChannel.ofChannel_apply _ _ _)⟩

-- Both alphabets really receive Fin coordinates, with the stated input direction.
example [Finite beta] (kappa : alpha → PMF beta) (x : alpha)
    (j : Fin (ActiveFiniteChannel.ofChannel kappa).outputCard) :
    massMatrix (relabelChannel (ActiveFiniteChannel.ofChannel kappa).channel
      (Finite.equivFin alpha) (Equiv.refl _)) (Finite.equivFin alpha x) j =
        kappa x (ActiveFiniteChannel.ambientLabel kappa j) :=
  (relabelChannel_apply _ (Finite.equivFin alpha) (Equiv.refl _) x j).trans
    (ActiveFiniteChannel.ofChannel_apply _ _ _)

-- The input enumeration also constructs an actual active state on Fin inputs.
example [Finite beta] (kappa : alpha → PMF beta) :
    let eX := Finite.equivFin alpha
    let : Nonempty (Fin (Nat.card alpha)) := Nonempty.map eX ‹Nonempty alpha›
    let kappa' : Fin (Nat.card alpha) → PMF beta := fun i => kappa (eX.symm i)
    let s := ActiveFiniteChannel.ofChannel kappa'
    ∀ x, (s.channel (eX x)).map (ActiveFiniteChannel.ambientLabel kappa') = kappa x ∧
      ∀ j, s.channel (eX x) j = kappa x (ActiveFiniteChannel.ambientLabel kappa' j) := by
  let eX := Finite.equivFin alpha
  let : Nonempty (Fin (Nat.card alpha)) := Nonempty.map eX ‹Nonempty alpha›
  let kappa' : Fin (Nat.card alpha) → PMF beta := fun i => kappa (eX.symm i)
  change ∀ x, ((ActiveFiniteChannel.ofChannel kappa').channel (eX x)).map
      (ActiveFiniteChannel.ambientLabel kappa') = kappa x ∧
    ∀ j, (ActiveFiniteChannel.ofChannel kappa').channel (eX x) j =
      kappa x (ActiveFiniteChannel.ambientLabel kappa' j)
  intro x
  constructor
  · simpa only [kappa', Equiv.symm_apply_apply] using
      ActiveFiniteChannel.ofChannel_recover kappa' (eX x)
  · intro j
    simpa only [kappa', Equiv.symm_apply_apply] using
      ActiveFiniteChannel.ofChannel_apply kappa' (eX x) j

end Presentations

private def cycleThree : Fin 3 ≃ Fin 3 := (Equiv.swap 0 1).trans (Equiv.swap 1 2)
private noncomputable def identityThree (x : Fin 3) : PMF (Fin 3) := PMF.pure x
private noncomputable def liftedIdentityThree (x : Fin 3) : PMF (ULift.{1} (Fin 3)) :=
  PMF.pure (ULift.up x)

private theorem liftedIdentityThree_active : ∀ y, ∃ x, liftedIdentityThree x y ≠ 0 := by
  rintro ⟨y⟩
  exact ⟨y, by simp [liftedIdentityThree]⟩

private noncomputable abbrev liftedFirst : ActiveFiniteChannel (Fin 3) :=
  ActiveFiniteChannel.ofActive liftedIdentityThree Equiv.ulift liftedIdentityThree_active

private noncomputable abbrev liftedSecond : ActiveFiniteChannel (Fin 3) :=
  ActiveFiniteChannel.ofActive liftedIdentityThree (Equiv.ulift.trans cycleThree)
    liftedIdentityThree_active

-- The two actual enumerations are distinct, rather than two names for one choice.
example : (Equiv.ulift : ULift.{1} (Fin 3) ≃ Fin 3) (ULift.up 0) = 0 ∧
    ((Equiv.ulift : ULift.{1} (Fin 3) ≃ Fin 3).trans cycleThree) (ULift.up 0) = 2 := by
  simp [cycleThree]

example (x : Fin 3) :
    (liftedFirst.channel x).map (Equiv.ulift : ULift.{1} (Fin 3) ≃ Fin 3).symm =
      liftedIdentityThree x := ActiveFiniteChannel.ofActive_recover _ _ _ _

private theorem lifted_presentations_compare (x : Fin 3) :
    (liftedFirst.channel x).map cycleThree = liftedSecond.channel x :=
  ActiveFiniteChannel.ofActive_compare liftedIdentityThree
    (Equiv.ulift : ULift.{1} (Fin 3) ≃ Fin 3)
    ((Equiv.ulift : ULift.{1} (Fin 3) ≃ Fin 3).trans cycleThree) liftedIdentityThree_active x

example (x y : Fin 3) :
    massMatrix liftedSecond.channel x (cycleThree y) = massMatrix liftedFirst.channel x y ∧
    realMatrix liftedSecond.channel x (cycleThree y) = realMatrix liftedFirst.channel x y := by
  have h : (fun x => (liftedFirst.channel x).map cycleThree) = liftedSecond.channel :=
    funext lifted_presentations_compare
  rw [← h]
  exact ⟨massMatrix_map _ _ cycleThree.injective _ _, realMatrix_map _ _ cycleThree.injective _ _⟩

/-! ## R10: inverse input and forward output labels checked separately -/

-- If the input direction were reversed, the first entry would be zero, not one.
example : massMatrix (relabelChannel identityThree cycleThree (Equiv.refl _)) 0 1 = 1 ∧
    realMatrix (relabelChannel identityThree cycleThree (Equiv.refl _)) 0 1 = 1 ∧
    massMatrix (relabelChannel identityThree cycleThree (Equiv.refl _)) 0 2 = 0 := by
  simp only [massMatrix_relabelChannel, realMatrix_relabelChannel, Matrix.reindex_apply]
  change (PMF.pure (cycleThree.symm 0)) 1 = 1 ∧
    ((PMF.pure (cycleThree.symm 0)) 1).toReal = 1 ∧ (PMF.pure (cycleThree.symm 0)) 2 = 0
  have hc : cycleThree.symm (0 : Fin 3) = 1 := by decide
  rw [hc]
  simp

-- If the output direction were reversed, the first entry would be zero, not one.
example : massMatrix (relabelChannel identityThree (Equiv.refl _) cycleThree) 0 2 = 1 ∧
    realMatrix (relabelChannel identityThree (Equiv.refl _) cycleThree) 0 2 = 1 ∧
    massMatrix (relabelChannel identityThree (Equiv.refl _) cycleThree) 0 1 = 0 := by
  simp only [massMatrix_relabelChannel, realMatrix_relabelChannel, Matrix.reindex_apply]
  change (PMF.pure (0 : Fin 3)) (cycleThree.symm 2) = 1 ∧
    ((PMF.pure (0 : Fin 3)) (cycleThree.symm 2)).toReal = 1 ∧
    (PMF.pure (0 : Fin 3)) (cycleThree.symm 1) = 0
  have h2 : cycleThree.symm (2 : Fin 3) = 0 := by decide
  have h1 : cycleThree.symm (1 : Fin 3) = 2 := by decide
  rw [h2, h1]
  simp

section Relabeling

variable {alpha : Type u} {beta : Type v}
variable {alpha' : Type u'} {beta' : Type v'} {alpha'' : Type u''} {beta'' : Type v''}

example (kappa : alpha → PMF beta) :
    relabelChannel kappa (Equiv.refl _) (Equiv.refl _) = kappa := relabelChannel_refl _

example (kappa : alpha → PMF beta) (eX : alpha ≃ alpha') (eY : beta ≃ beta')
    (fX : alpha' ≃ alpha'') (fY : beta' ≃ beta'') :
    relabelChannel (relabelChannel kappa eX eY) fX fY =
      relabelChannel kappa (eX.trans fX) (eY.trans fY) ∧
    relabelChannel (relabelChannel kappa eX eY) eX.symm eY.symm = kappa :=
  ⟨relabelChannel_trans _ _ _ _ _, relabelChannel_symm _ _ _⟩

example [Finite alpha] [Finite alpha'] [Finite beta] [Finite beta'] [Nonempty alpha]
    (kappa : alpha → PMF beta) (eX : alpha ≃ alpha') (eY : beta ≃ beta') :
    let : Nonempty alpha' := Nonempty.map eX ‹Nonempty alpha›
    (IsSingularChannel (relabelChannel kappa eX eY) ↔ IsSingularChannel kappa) ∧
    (IsPerfectlyRepresentableChannel (relabelChannel kappa eX eY) ↔
      IsPerfectlyRepresentableChannel kappa) :=
  ⟨isSingularChannel_relabelChannel_iff _ _ _,
    isPerfectlyRepresentableChannel_relabelChannel_iff _ _ _⟩

end Relabeling

/-! ## R06: unused-label coordinates and exact injection masses -/

example (x : Fin 2) (y : Fin 3) :
    massMatrix (fun x => (rectangularChannel x).map some) x (some y) =
      massMatrix rectangularChannel x y ∧
    realMatrix (fun x => (rectangularChannel x).map some) x (some y) =
      realMatrix rectangularChannel x y ∧
    massMatrix (fun x => (rectangularChannel x).map some) x none = 0 ∧
    realMatrix (fun x => (rectangularChannel x).map some) x none = 0 :=
  ⟨massMatrix_map _ _ (Option.some_injective _) _ _,
    realMatrix_map _ _ (Option.some_injective _) _ _,
    massMatrix_map_eq_zero _ _ _ _ (by simp), realMatrix_map_eq_zero _ _ _ _ (by simp)⟩

example {alpha : Type u} {beta : Type v} {gamma : Type v'}
    [Finite alpha] [Finite beta] [Finite gamma] [Nonempty alpha]
    (kappa : alpha → PMF beta) (j : beta → gamma) (hj : Function.Injective j) :
    (IsSingularChannel (ActiveFiniteChannel.ofChannel (fun x => (kappa x).map j)).channel ↔
      IsSingularChannel kappa) ∧
    (IsPerfectlyRepresentableChannel
      (ActiveFiniteChannel.ofChannel (fun x => (kappa x).map j)).channel ↔
        IsPerfectlyRepresentableChannel kappa) :=
  ⟨(ActiveFiniteChannel.isSingularChannel_ofChannel_iff _).trans
      (isSingularChannel_map_iff _ _ hj),
    (ActiveFiniteChannel.isPerfectlyRepresentableChannel_ofChannel_iff _).trans
      (isPerfectlyRepresentableChannel_map_iff _ _ hj)⟩

private noncomputable abbrev rectangularExtended (x : Fin 2) : PMF (Option (Fin 3)) :=
  (rectangularState.channel x).map some

private noncomputable abbrev rectangularRecovered : ActiveFiniteChannel (Fin 2) :=
  ActiveFiniteChannel.ofChannel rectangularExtended

private noncomputable abbrev rectangularRecoveryEquiv :
    Fin 3 ≃ Fin rectangularRecovered.outputCard :=
  rectangularState.extensionEquiv some (Option.some_injective _)

-- The whole chain starts at the direct, label-preserving three-column state.
-- C03 restriction and canonical enumeration are both present, with actual row recovery.
example (x : Fin 2) (a : activeOutputs rectangularExtended) :
    massMatrix rectangularExtended x none = 0 ∧
    realMatrix rectangularExtended x none = 0 ∧
    restrictActiveOutputs rectangularExtended x a = rectangularExtended x a.val ∧
    (restrictActiveOutputs rectangularExtended x).map Subtype.val = rectangularExtended x ∧
    (rectangularRecovered.channel x).map (ActiveFiniteChannel.ambientLabel rectangularExtended) =
      rectangularExtended x ∧
    (rectangularState.channel x).map rectangularRecoveryEquiv = rectangularRecovered.channel x :=
  ⟨massMatrix_map_eq_zero _ _ _ _ (by simp), realMatrix_map_eq_zero _ _ _ _ (by simp),
    restrictActiveOutputs_apply _ _ _, map_val_restrictActiveOutputs _ _,
    ActiveFiniteChannel.ofChannel_recover _ _,
    ActiveFiniteChannel.extension_compare _ _ (Option.some_injective _) _⟩

private theorem rectangular_recovery_mass (x : Fin 2) (y : Fin 3) :
    massMatrix rectangularRecovered.channel x (rectangularRecoveryEquiv y) =
      massMatrix rectangularState.channel x y := by
  have h : (rectangularState.channel x).map rectangularRecoveryEquiv =
      rectangularRecovered.channel x :=
    ActiveFiniteChannel.extension_compare _ _ (Option.some_injective _) _
  have hm := congrArg
    (fun p : PMF (Fin rectangularRecovered.outputCard) => p (rectangularRecoveryEquiv y)) h
  rw [PMF.map_apply_equiv] at hm
  exact hm.symm

example (x : Fin 2) (y : Fin 3) :
    massMatrix rectangularRecovered.channel x (rectangularRecoveryEquiv y) =
      massMatrix rectangularState.channel x y ∧
    realMatrix rectangularRecovered.channel x (rectangularRecoveryEquiv y) =
      realMatrix rectangularState.channel x y :=
  ⟨rectangular_recovery_mass _ _, congrArg ENNReal.toReal (rectangular_recovery_mass _ _)⟩

-- The nontrivial fractional mass survives the entire chain, in both numeric views.
example : massMatrix rectangularRecovered.channel 1 (rectangularRecoveryEquiv 1) = 1 / 2 ∧
    realMatrix rectangularRecovered.channel 1 (rectangularRecoveryEquiv 1) = 1 / 2 := by
  have hm : massMatrix rectangularRecovered.channel 1 (rectangularRecoveryEquiv 1) = 1 / 2 := by
    rw [rectangular_recovery_mass]
    rfl
  refine ⟨hm, ?_⟩
  change (massMatrix rectangularRecovered.channel 1 (rectangularRecoveryEquiv 1)).toReal = 1 / 2
  rw [hm]
  norm_num

example (x : Fin 2) : (rectangularRecovered.channel x).map rectangularRecoveryEquiv.symm =
    rectangularState.channel x := by
  rw [← ActiveFiniteChannel.extension_compare rectangularState some (Option.some_injective _) x]
  change ((rectangularState.channel x).map rectangularRecoveryEquiv).map
    rectangularRecoveryEquiv.symm = _
  simp only [PMF.map_comp, Function.comp_def, Equiv.symm_apply_apply]
  exact PMF.map_id _

-- A source that already has unused labels is compared through its active presentation.
example (x : Fin 2) :
    ((ActiveFiniteChannel.ofChannel unusedOutputChannel).channel x).map
      (ActiveFiniteChannel.outputEquivOfMap unusedOutputChannel some (Option.some_injective _)) =
        (ActiveFiniteChannel.ofChannel (fun x => (unusedOutputChannel x).map some)).channel x :=
  ActiveFiniteChannel.ofChannel_map_compare _ _ (Option.some_injective _) _

-- Recovery is an injection into the ambient alphabet, not a bijection with its zero labels.
example : (1 : Fin 3) ∉ Set.range (ActiveFiniteChannel.ambientLabel unusedOutputChannel) := by
  rintro ⟨j, hj⟩
  obtain ⟨x, hx⟩ := (ActiveFiniteChannel.ofChannel unusedOutputChannel).output_active j
  rw [ActiveFiniteChannel.ofChannel_apply, hj] at hx
  simp [unusedOutputChannel] at hx

/-! ## R16: a point prior sees fewer outputs than the intrinsic active union -/

private noncomputable def pointThree : PMF (Fin 3) := PMF.pure 0

example :
    (LeanInfoTheory.Shannon.sndMarginal (PMF.channelJoint pointThree identityThree)).support = {0} ∧
    activeOutputs identityThree = Set.univ ∧
    1 ∉ (LeanInfoTheory.Shannon.sndMarginal (PMF.channelJoint pointThree identityThree)).support ∧
    1 ∈ activeOutputs identityThree := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · simp [LeanInfoTheory.Shannon.sndMarginal, PMF.channelJoint_map_snd, pointThree, identityThree]
  · ext y
    simp [activeOutputs, identityThree]
  · simp [LeanInfoTheory.Shannon.sndMarginal, PMF.channelJoint_map_snd, pointThree, identityThree]
  · exact ⟨1, by simp [identityThree]⟩

example :
    (LeanInfoTheory.Shannon.sndMarginal (PMF.channelJoint (inputSupportPrior pointThree)
      (fun s : pointThree.support => identityThree s.val))).support =
        activeOutputs (fun s : pointThree.support => identityThree s.val) :=
  support_sndMarginal_channelJoint_eq_activeOutputs_of_fullSupport _ _
    (mem_support_inputSupportPrior pointThree)

example :
    (PMF.channelJoint (inputSupportPrior pointThree)
      (fun s : pointThree.support => identityThree s.val)).map
        (fun sy => (sy.1.val, sy.2)) = PMF.channelJoint pointThree identityThree :=
  channelJoint_inputSupportPrior_map_val _ _

example : IsPerfectlyRepresentablePair (PMF.channelJoint pointThree identityThree) ↔
    @IsPerfectlyRepresentableChannel pointThree.support (Fin 3)
      pointThree.support_nonempty.to_subtype (fun s => identityThree s.val) :=
  isPerfectlyRepresentablePair_channelJoint_iff_restrict_support _ _

-- The new active presentation belongs to the prior-restricted input channel.
-- It is not substituted for the original intrinsic three-input channel.
example :
    let : Nonempty pointThree.support := pointThree.support_nonempty.to_subtype
    IsPerfectlyRepresentablePair (PMF.channelJoint pointThree identityThree) ↔
      IsPerfectlyRepresentableChannel
        (ActiveFiniteChannel.ofChannel
          (fun s : pointThree.support => identityThree s.val)).channel := by
  let : Nonempty pointThree.support := pointThree.support_nonempty.to_subtype
  exact (isPerfectlyRepresentablePair_channelJoint_iff_restrict_support _ _).trans
    (ActiveFiniteChannel.isPerfectlyRepresentableChannel_ofChannel_iff _).symm

end PerfectFunctionalRepresentations
