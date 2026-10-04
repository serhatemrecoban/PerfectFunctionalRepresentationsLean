import PerfectFunctionalRepresentations.Matrix.PatternCompression
import PerfectFunctionalRepresentations.Matrix.MultiwayOperations
import PerfectFunctionalRepresentations.Matrix.Reachability
import PerfectFunctionalRepresentations.Examples.Nonrepresentable3x3
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum

/-!
# C12 exact compression and operation regressions

These consumers check the intrinsic family, equal-pattern fibers, exact
coordinates, and retained compression and reverse witnesses. All fixture
declarations remain private. The initial C10 consumer also checks the chosen
semantic pattern carrier against the existing synthesis interface.
-/

namespace PerfectFunctionalRepresentations

open scoped BigOperators ENNReal

noncomputable section
attribute [local instance] Classical.propDecidable

private abbrev testActiveFintype {α β : Type*} [Finite β] (κ : α → PMF β) :
    Fintype (activeOutputs κ) := Fintype.ofFinite _
attribute [local instance] testActiveFintype

local instance : DecidableEq (Fin 2) := fun a b => Classical.propDecidable (a = b)

private abbrev Pattern2 := {s : Finset (Fin 2) // s.Nonempty}

private def fullPattern : Pattern2 := ⟨Finset.univ, by simp⟩
private def leftPattern : Pattern2 := ⟨{0}, by simp⟩
private def rightPattern : Pattern2 := ⟨{1}, by simp⟩

private theorem univ2 : (Finset.univ : Finset (Fin 2)) = {0, 1} := by
  ext x
  fin_cases x <;> simp
attribute [local simp] univ2

private theorem full_ne_left : fullPattern ≠ leftPattern := by
  intro h
  have hh := congrArg (fun p : Pattern2 => (1 : Fin 2) ∈ p.val) h
  simp [fullPattern, leftPattern] at hh

private theorem full_ne_right : fullPattern ≠ rightPattern := by
  intro h
  have hh := congrArg (fun p : Pattern2 => (0 : Fin 2) ∈ p.val) h
  simp [fullPattern, rightPattern] at hh

private theorem left_ne_right : leftPattern ≠ rightPattern := by
  intro h
  have hh := congrArg (fun p : Pattern2 => (0 : Fin 2) ∈ p.val) h
  simp [leftPattern, rightPattern] at hh
attribute [local simp] full_ne_left full_ne_right left_ne_right

private theorem cast_conditional_sum {ι : Type*} [Fintype ι]
    (P : ι → Prop) [DecidablePred P] (w : ι → NNReal) :
    (∑ i, if P i then (w i : ENNReal) else 0) =
      ((∑ i, if P i then w i else 0 : NNReal) : ENNReal) := by
  rw [ENNReal.ofNNReal_finsetSum]
  apply Finset.sum_congr rfl
  intro i _
  split_ifs <;> rfl

private def allActiveEquiv {α β : Type*} (κ : α → PMF β)
    (ha : ∀ y, y ∈ activeOutputs κ) : β ≃ activeOutputs κ where
  toFun y := ⟨y, ha y⟩
  invFun := Subtype.val
  left_inv _ := rfl
  right_inv _ := rfl

private theorem occurring_allActive {α β : Type*} [Fintype α] [Fintype β]
    (κ : α → PMF β) (ha : ∀ y, y ∈ activeOutputs κ) :
    occurringPatterns κ = Finset.univ.image (fun y => columnPattern κ ⟨y, ha y⟩) := by
  ext p
  rw [mem_occurringPatterns]
  simp only [Finset.mem_image, Finset.mem_univ, true_and]
  constructor
  · rintro ⟨y, hy⟩
    exact ⟨y.val, hy⟩
  · rintro ⟨y, hy⟩
    exact ⟨⟨y, ha y⟩, hy⟩

private theorem aggregate_allActive {α β : Type*} [Fintype α] [Fintype β]
    (κ : α → PMF β) (hκ : IsSingularChannel κ)
    (ha : ∀ y, y ∈ activeOutputs κ) (p : OccurringPattern κ) :
    patternAggregate κ hκ p =
      ∑ y : β, if columnPattern κ ⟨y, ha y⟩ = p.val then
        columnValue κ hκ ⟨y, ha y⟩ else 0 := by
  unfold patternAggregate
  exact ((allActiveEquiv κ ha).sum_comp (fun y : activeOutputs κ =>
    if columnPattern κ y = p.val then columnValue κ hκ y else 0)).symm

/-! ## Raw intrinsic data does not require singularity or a nonempty input -/

example {β : Type*} [Finite β] (κ : Fin 0 → PMF β) : occurringPatterns κ = ∅ := by
  ext p
  rw [mem_occurringPatterns]
  simp only [Finset.notMem_empty, iff_false]
  rintro ⟨y, _⟩
  obtain ⟨x, _⟩ := y.property
  exact Fin.elim0 x

example {α β : Type*} [Fintype α] [Finite β] (κ : α → PMF β)
    (x : α) (p : OccurringPattern κ) :
    patternCompressedChannel κ x p =
      ∑ y : activeOutputs κ,
        if columnPattern κ y = p.val then κ x y.val else 0 :=
  patternCompressedChannel_apply κ x p

/-! ## C10 consumes the same semantic carrier and exact supplied labels -/

example {α : Type*} [Fintype α] [Nonempty α]
    (S : ActiveFiniteChannel α) (hS : IsSingularChannel S.channel) :
    Nonempty (MatrixOperations.LabelledOperationResult .ppm S (OccurringPattern S.channel)
      (fun x p => ∑ j, @ite ENNReal (toOccurringPattern S.channel (S.activeEquiv j) = p)
        (Classical.propDecidable _) (S.channel x j) 0)) := by
  let g := fun j => toOccurringPattern S.channel (S.activeEquiv j)
  have hg : Function.Surjective g :=
    (toOccurringPattern_surjective S.channel).comp S.activeEquiv.surjective
  have hp : ∀ i j, g i = g j → ∀ x, S.channel x i ≠ 0 ↔ S.channel x j ≠ 0 := by
    intro i j h x
    have he : columnPattern S.channel (S.activeEquiv i) =
        columnPattern S.channel (S.activeEquiv j) := congrArg Subtype.val h
    change S.channel x (S.activeEquiv i).val ≠ 0 ↔
      S.channel x (S.activeEquiv j).val ≠ 0
    rw [← mem_columnPattern S.channel (S.activeEquiv i) x,
      ← mem_columnPattern S.channel (S.activeEquiv j) x, he]
  exact ⟨MatrixOperations.multiPpmFibers S hS g hg hp⟩

/-! ## R01/R03: unequal values sharing the full pattern, and one final group -/

private def quarterWeights : Fin 2 → NNReal := ![1 / 4, 3 / 4]
private def quarterPatterns (_ : Fin 2) : Pattern2 := fullPattern

private theorem quarterPositive (j : Fin 2) : 0 < quarterWeights j := by
  fin_cases j <;> norm_num [quarterWeights]

private theorem quarterRows (x : Fin 2) :
    ∑ j, (if x ∈ (quarterPatterns j).val then
      (quarterWeights j : ENNReal) else 0) = 1 := by
  have h : (∑ j : Fin 2, quarterWeights j) = 1 := by
    norm_num [quarterWeights, Fin.sum_univ_succ]
  simpa only [quarterPatterns, fullPattern, Finset.mem_univ, if_true]
    using (show (∑ j : Fin 2, (quarterWeights j : ENNReal)) = 1 by exact_mod_cast h)

private abbrev quarterChannel : Fin 2 → PMF (Fin 2) :=
  channelOfColumnData quarterPatterns (fun j => (quarterWeights j : ENNReal)) quarterRows

private theorem quarterSingular : IsSingularChannel quarterChannel :=
  isSingularChannel_channelOfColumnData _ _ _

private theorem quarterActive (j : Fin 2) : j ∈ activeOutputs quarterChannel :=
  channelOfColumnData_active _ _ _ (fun j => by exact_mod_cast quarterPositive j) j

private abbrev quarterAdmitted (j : Fin 2) : activeOutputs quarterChannel :=
  ⟨j, quarterActive j⟩

private theorem quarterPattern (j : Fin 2) :
    columnPattern quarterChannel (quarterAdmitted j) = fullPattern :=
  columnPattern_channelOfColumnData _ _ _ (fun j => by exact_mod_cast quarterPositive j) j

private theorem quarterValue (j : Fin 2) :
    columnValue quarterChannel quarterSingular (quarterAdmitted j) =
      (quarterWeights j : ENNReal) :=
  columnValue_channelOfColumnData _ _ _ (fun j => by exact_mod_cast quarterPositive j) j

private abbrev quarterOutput : OccurringPattern quarterChannel :=
  toOccurringPattern quarterChannel (quarterAdmitted 0)

private theorem quarterOutput_val : quarterOutput.val = fullPattern := quarterPattern 0

private theorem quarterOccurrence : occurringPatterns quarterChannel = {fullPattern} := by
  rw [occurring_allActive quarterChannel quarterActive]
  simp only [show (fun j => columnPattern quarterChannel ⟨j, quarterActive j⟩) =
    fun _ => fullPattern from funext quarterPattern]
  simp

example : columnValue quarterChannel quarterSingular (quarterAdmitted 0) =
      (1 / 4 : ENNReal) ∧
    columnValue quarterChannel quarterSingular (quarterAdmitted 1) = (3 / 4 : ENNReal) := by
  rw [quarterValue, quarterValue]
  norm_num [quarterWeights]

example : patternFiber quarterChannel quarterOutput = Finset.univ := by
  ext y
  simp only [mem_patternFiber, Finset.mem_univ, iff_true]
  exact (quarterPattern y.val).trans quarterOutput_val.symm

private theorem quarterAggregate :
    patternAggregate quarterChannel quarterSingular quarterOutput = 1 := by
  rw [aggregate_allActive quarterChannel quarterSingular quarterActive]
  simp only [quarterPattern, quarterOutput_val, if_true, quarterValue]
  exact_mod_cast (show (∑ j : Fin 2, quarterWeights j) = 1 by
    norm_num [quarterWeights, Fin.sum_univ_succ])

example (x : Fin 2) : patternCompressedChannel quarterChannel x quarterOutput = 1 := by
  rw [patternCompressedChannel_eq_ite quarterChannel quarterSingular,
    quarterOutput_val, quarterAggregate]
  simp only [fullPattern, Finset.mem_univ, if_true]

/-! ## R02/R04: equal values with different patterns; row sums versus total values -/

private def identityPatterns (j : Fin 2) : Pattern2 := ⟨{j}, by simp⟩

private theorem identityRows (x : Fin 2) :
    ∑ j : Fin 2, (if x ∈ (identityPatterns j).val then (1 : ENNReal) else 0) = 1 := by
  fin_cases x <;> norm_num [identityPatterns, Fin.sum_univ_succ]

private abbrev identityChannel : Fin 2 → PMF (Fin 2) :=
  channelOfColumnData identityPatterns (fun _ => 1) identityRows

private theorem identitySingular : IsSingularChannel identityChannel :=
  isSingularChannel_channelOfColumnData _ _ _

private theorem identityActive (j : Fin 2) : j ∈ activeOutputs identityChannel :=
  channelOfColumnData_active _ _ _ (fun _ => by norm_num) j

private abbrev identityAdmitted (j : Fin 2) : activeOutputs identityChannel :=
  ⟨j, identityActive j⟩

private theorem identityPattern (j : Fin 2) :
    columnPattern identityChannel (identityAdmitted j) = identityPatterns j :=
  columnPattern_channelOfColumnData _ _ _ (fun _ => by norm_num) j

private theorem identityValue (j : Fin 2) :
    columnValue identityChannel identitySingular (identityAdmitted j) = 1 :=
  columnValue_channelOfColumnData _ _ _ (fun _ => by norm_num) j

private abbrev identityOutput (j : Fin 2) : OccurringPattern identityChannel :=
  toOccurringPattern identityChannel (identityAdmitted j)

private theorem identityOutput_val (j : Fin 2) :
    (identityOutput j).val = identityPatterns j := identityPattern j

example : occurringPatterns identityChannel = {leftPattern, rightPattern} := by
  rw [occurring_allActive identityChannel identityActive]
  simp only [show (fun j => columnPattern identityChannel ⟨j, identityActive j⟩) =
    identityPatterns from funext identityPattern]
  simp [Fin.univ_succ, identityPatterns, leftPattern, rightPattern]

example : columnValue identityChannel identitySingular (identityAdmitted 0) =
      columnValue identityChannel identitySingular (identityAdmitted 1) ∧
    columnPattern identityChannel (identityAdmitted 0) ≠
      columnPattern identityChannel (identityAdmitted 1) := by
  rw [identityValue, identityValue, identityPattern, identityPattern]
  exact ⟨rfl, by simp [identityPatterns, Subtype.ext_iff]⟩

example (j : Fin 2) : patternFiber identityChannel (identityOutput j) = {identityAdmitted j} := by
  ext y
  rw [mem_patternFiber, identityOutput_val]
  change columnPattern identityChannel (identityAdmitted y.val) = identityPatterns j ↔ _
  rw [identityPattern]
  simp [identityPatterns, Subtype.ext_iff]

private theorem identityAggregate (j : Fin 2) :
    patternAggregate identityChannel identitySingular (identityOutput j) = 1 := by
  rw [aggregate_allActive identityChannel identitySingular identityActive, identityOutput_val]
  simp only [identityPattern, identityValue]
  fin_cases j <;> norm_num [identityPatterns, Fin.sum_univ_succ, Subtype.ext_iff]

example (x j : Fin 2) :
    patternCompressedChannel identityChannel x (identityOutput j) = if x = j then 1 else 0 := by
  rw [patternCompressedChannel_eq_ite identityChannel identitySingular,
    identityOutput_val, identityAggregate]
  simp [identityPatterns]

private def identityOutputEquiv : Fin 2 ≃ OccurringPattern identityChannel :=
  Equiv.ofBijective identityOutput ⟨by
    intro i j hij
    have h := (identityOutput_val i).symm.trans
      ((congrArg Subtype.val hij).trans (identityOutput_val j))
    simpa [identityPatterns, Subtype.ext_iff] using h,
    (toOccurringPattern_surjective identityChannel).comp
      (allActiveEquiv identityChannel identityActive).surjective⟩

example : (∑ p : OccurringPattern identityChannel,
    patternAggregate identityChannel identitySingular p) = 2 := by
  rw [← identityOutputEquiv.sum_comp]
  change (∑ j : Fin 2, patternAggregate identityChannel identitySingular (identityOutput j)) = 2
  simp [identityAggregate]

example (x : Fin 2) :
    ∑ p : OccurringPattern identityChannel,
      (if x ∈ p.val.val then patternAggregate identityChannel identitySingular p else 0) = 1 :=
  patternAggregate_row_sum identityChannel identitySingular x

/-! ## R07: proper supports, nonadjacent unequal repeated columns and all coordinates -/

private def mixedPatterns : Fin 4 → Pattern2 :=
  ![leftPattern, rightPattern, fullPattern, leftPattern]
private def mixedWeights : Fin 4 → NNReal := ![1 / 6, 1 / 2, 1 / 2, 1 / 3]

private theorem mixedPositive (j : Fin 4) : 0 < mixedWeights j := by
  fin_cases j <;> norm_num [mixedWeights]

private theorem mixedRows (x : Fin 2) :
    ∑ j, (if x ∈ (mixedPatterns j).val then (mixedWeights j : ENNReal) else 0) = 1 := by
  have h : (∑ j : Fin 4, if x ∈ (mixedPatterns j).val then mixedWeights j else 0) = 1 := by
    fin_cases x <;> norm_num [mixedPatterns, mixedWeights, leftPattern, rightPattern,
      fullPattern, Fin.sum_univ_succ]
  rw [cast_conditional_sum]
  exact_mod_cast h

private abbrev mixedChannel : Fin 2 → PMF (Fin 4) :=
  channelOfColumnData mixedPatterns (fun j => (mixedWeights j : ENNReal)) mixedRows

private theorem mixedSingular : IsSingularChannel mixedChannel :=
  isSingularChannel_channelOfColumnData _ _ _

private theorem mixedActive (j : Fin 4) : j ∈ activeOutputs mixedChannel :=
  channelOfColumnData_active _ _ _ (fun j => by exact_mod_cast mixedPositive j) j

private abbrev mixedAdmitted (j : Fin 4) : activeOutputs mixedChannel := ⟨j, mixedActive j⟩

private theorem mixedPattern (j : Fin 4) :
    columnPattern mixedChannel (mixedAdmitted j) = mixedPatterns j :=
  columnPattern_channelOfColumnData _ _ _ (fun j => by exact_mod_cast mixedPositive j) j

private theorem mixedValue (j : Fin 4) :
    columnValue mixedChannel mixedSingular (mixedAdmitted j) = (mixedWeights j : ENNReal) :=
  columnValue_channelOfColumnData _ _ _ (fun j => by exact_mod_cast mixedPositive j) j

private abbrev mixedOutput (j : Fin 4) : OccurringPattern mixedChannel :=
  toOccurringPattern mixedChannel (mixedAdmitted j)

private theorem mixedOutput_val (j : Fin 4) :
    (mixedOutput j).val = mixedPatterns j := mixedPattern j

private theorem mixedCoordinates (x : Fin 2) (j : Fin 4) : mixedChannel x j =
    ((![![1 / 6, 0, 1 / 2, 1 / 3], ![0, 1 / 2, 1 / 2, 0]] x j : NNReal) : ENNReal) := by
  fin_cases x <;> fin_cases j <;>
    norm_num [mixedChannel, mixedPatterns, mixedWeights, leftPattern, rightPattern, fullPattern]

private theorem mixedOccurrence :
    occurringPatterns mixedChannel = {leftPattern, rightPattern, fullPattern} := by
  rw [occurring_allActive mixedChannel mixedActive]
  simp only [show (fun j => columnPattern mixedChannel ⟨j, mixedActive j⟩) =
    mixedPatterns from funext mixedPattern]
  ext p
  simp only [Finset.mem_image, Finset.mem_univ, true_and,
    Finset.mem_insert, Finset.mem_singleton]
  constructor
  · rintro ⟨j, rfl⟩
    fin_cases j <;> simp [mixedPatterns]
  · rintro (rfl | rfl | rfl)
    · exact ⟨0, rfl⟩
    · exact ⟨1, rfl⟩
    · exact ⟨2, rfl⟩

example : patternFiber mixedChannel (mixedOutput 0) = {mixedAdmitted 0, mixedAdmitted 3} := by
  ext y
  rw [mem_patternFiber, mixedOutput_val]
  change columnPattern mixedChannel (mixedAdmitted y.val) = mixedPatterns 0 ↔ _
  rw [mixedPattern]
  rcases y with ⟨y, hy⟩
  fin_cases y <;> simp [mixedPatterns, Ne.symm left_ne_right]

example : patternFiber mixedChannel (mixedOutput 1) = {mixedAdmitted 1} ∧
    patternFiber mixedChannel (mixedOutput 2) = {mixedAdmitted 2} := by
  constructor <;> ext y <;> rw [mem_patternFiber, mixedOutput_val]
  all_goals
    change columnPattern mixedChannel (mixedAdmitted y.val) = _ ↔ _
    rw [mixedPattern]
    rcases y with ⟨y, hy⟩
    fin_cases y <;> simp [mixedPatterns, Ne.symm full_ne_left, Ne.symm full_ne_right]

private theorem mixedAggregate (j : Fin 4) :
    patternAggregate mixedChannel mixedSingular (mixedOutput j) = (1 / 2 : ENNReal) := by
  rw [aggregate_allActive mixedChannel mixedSingular mixedActive, mixedOutput_val]
  simp only [mixedPattern, mixedValue]
  rw [cast_conditional_sum]
  have h : (∑ i : Fin 4, if mixedPatterns i = mixedPatterns j then mixedWeights i else 0) =
      (1 / 2 : NNReal) := by
    fin_cases j <;>
      norm_num [mixedPatterns, mixedWeights, Fin.sum_univ_succ,
        Ne.symm full_ne_left, Ne.symm full_ne_right, Ne.symm left_ne_right]
  rw [h]
  norm_num

example (x : Fin 2) (j : Fin 4) : patternCompressedChannel mixedChannel x (mixedOutput j) =
    if x ∈ (mixedPatterns j).val then (1 / 2 : ENNReal) else 0 := by
  rw [patternCompressedChannel_eq_ite mixedChannel mixedSingular, mixedOutput_val, mixedAggregate]

example : patternCompressedChannel mixedChannel 0 (mixedOutput 0) = 1 / 2 ∧
    patternCompressedChannel mixedChannel 1 (mixedOutput 0) = 0 := by
  constructor <;> rw [patternCompressedChannel_eq_ite mixedChannel mixedSingular,
    mixedOutput_val, mixedAggregate] <;> norm_num [mixedPatterns, leftPattern]

/-! ## R12: a genuine three-cycle preserves the whole family and each exact aggregate -/

private def outputCycle : Fin 4 ≃ Fin 4 where
  toFun := ![1, 2, 0, 3]
  invFun := ![2, 0, 1, 3]
  left_inv j := by fin_cases j <;> rfl
  right_inv j := by fin_cases j <;> rfl

private abbrev cycledChannel : Fin 2 → PMF (Fin 4) :=
  fun x => (mixedChannel x).map outputCycle

private theorem cycledSingular : IsSingularChannel cycledChannel :=
  (isSingularChannel_map_iff mixedChannel outputCycle outputCycle.injective).mpr mixedSingular

private def cycledOutput (p : OccurringPattern mixedChannel) : OccurringPattern cycledChannel :=
  ⟨p.val, by rw [occurringPatterns_map_equiv mixedChannel outputCycle]; exact p.property⟩

example : outputCycle 0 = 1 ∧ outputCycle 1 = 2 ∧ outputCycle 2 = 0 ∧
    outputCycle 3 = 3 ∧ outputCycle (outputCycle 0) = 2 := ⟨rfl, rfl, rfl, rfl, rfl⟩

example (x : Fin 2) (j : Fin 4) : cycledChannel x (outputCycle j) = mixedChannel x j :=
  PMF.map_apply_equiv _ outputCycle j

example : occurringPatterns cycledChannel = {leftPattern, rightPattern, fullPattern} := by
  rw [occurringPatterns_map_equiv mixedChannel outputCycle, mixedOccurrence]

private theorem cycledAggregate (p : OccurringPattern mixedChannel) :
    patternAggregate cycledChannel cycledSingular (cycledOutput p) =
      patternAggregate mixedChannel mixedSingular p :=
  patternAggregate_map_equiv mixedChannel outputCycle mixedSingular cycledSingular
    p (cycledOutput p) rfl

example (x : Fin 2) (p : OccurringPattern mixedChannel) :
    patternCompressedChannel cycledChannel x (cycledOutput p) =
      patternCompressedChannel mixedChannel x p := by
  rw [patternCompressedChannel_eq_ite cycledChannel cycledSingular,
    patternCompressedChannel_eq_ite mixedChannel mixedSingular, cycledAggregate]
  rfl

example (j : Fin 4) :
    patternAggregate cycledChannel cycledSingular (cycledOutput (mixedOutput j)) =
      (1 / 2 : ENNReal) := (cycledAggregate _).trans (mixedAggregate j)

/-! ## S02 presentations reuse the exact S01 fixtures -/

open MatrixOperations

private abbrev fixtureState {α : Type*} [Finite α] [Nonempty α] {n : Nat}
    (hn : 0 < n) (κ : α → PMF (Fin n)) (ha : ∀ j, j ∈ activeOutputs κ) :
    ActiveFiniteChannel α where
  outputCard := n
  outputCard_pos := hn
  channel := κ
  output_active j := by
    obtain ⟨x, hx⟩ := ha j
    exact ⟨x, (PMF.mem_support_iff _ _).mp hx⟩

private abbrev quarterState := fixtureState (by decide : 0 < 2) quarterChannel quarterActive
private abbrev identityState := fixtureState (by decide : 0 < 2) identityChannel identityActive
private abbrev mixedState := fixtureState (by decide : 0 < 4) mixedChannel mixedActive

private def quarterEnumeration : Fin 1 ≃ OccurringPattern quarterChannel :=
  Equiv.ofBijective (fun _ => quarterOutput) ⟨fun _ _ _ => Subsingleton.elim _ _, by
    intro p
    obtain ⟨y, rfl⟩ := toOccurringPattern_surjective quarterChannel p
    refine ⟨0, Subtype.ext ?_⟩
    exact quarterOutput_val.trans (quarterPattern y.val).symm⟩

private def mixedEnumeration : Fin 3 ≃ OccurringPattern mixedChannel :=
  Equiv.ofBijective (fun j => mixedOutput j.castSucc) ⟨by
    intro i j h
    have hp := congrArg Subtype.val h
    simp only [mixedOutput_val] at hp
    fin_cases i <;> fin_cases j <;>
      simp_all [mixedPatterns, Ne.symm full_ne_left, Ne.symm full_ne_right,
        Ne.symm left_ne_right], by
    intro p
    obtain ⟨y, rfl⟩ := toOccurringPattern_surjective mixedChannel p
    rcases y with ⟨y, hy⟩
    fin_cases y
    · exact ⟨0, rfl⟩
    · exact ⟨1, rfl⟩
    · exact ⟨2, rfl⟩
    · refine ⟨0, Subtype.ext ?_⟩
      exact (mixedOutput_val 0).trans (mixedPattern 3).symm⟩

private theorem mixedEnumeration_apply (j : Fin 3) :
    mixedEnumeration j = mixedOutput j.castSucc := rfl

private theorem identityPattern_injective : Function.Injective (columnPattern identityChannel) := by
  intro i j h
  apply Subtype.ext
  change columnPattern identityChannel (identityAdmitted i.val) =
    columnPattern identityChannel (identityAdmitted j.val) at h
  rw [identityPattern, identityPattern] at h
  simpa only [identityPatterns, Subtype.mk.injEq, Finset.singleton_inj] using h

/-! The recovered presentation has a specified order. Its forward map is a
three-cycle on the last three columns, and differs from its inverse. -/

private def recoveryPermutation : Fin 4 ≃ Fin 4 where
  toFun := ![0, 3, 1, 2]
  invFun := ![0, 2, 3, 1]
  left_inv j := by fin_cases j <;> rfl
  right_inv j := by fin_cases j <;> rfl

private abbrev recoveredChannel : Fin 2 → PMF (Fin 4) :=
  fun x => (mixedChannel x).map recoveryPermutation.symm

private theorem recoveredActive (j : Fin 4) : j ∈ activeOutputs recoveredChannel := by
  obtain ⟨x, hx⟩ := mixedActive (recoveryPermutation j)
  refine ⟨x, ?_⟩
  rw [PMF.mem_support_iff] at hx ⊢
  simpa only [recoveredChannel, ← PMF.map_apply_equiv (mixedChannel x)
    recoveryPermutation.symm (recoveryPermutation j), Equiv.symm_apply_apply] using hx

private abbrev recoveredState :=
  fixtureState (by decide : 0 < 4) recoveredChannel recoveredActive

private def recoveredToOriginal : OutputEquiv recoveredState mixedState where
  equiv := recoveryPermutation
  map_eq x := by
    change ((mixedChannel x).map recoveryPermutation.symm).map recoveryPermutation = _
    simp only [PMF.map_comp, Function.comp_def, Equiv.apply_symm_apply]
    exact PMF.map_id _

example : recoveryPermutation 0 = 0 ∧ recoveryPermutation 1 = 3 ∧
    recoveryPermutation 2 = 1 ∧ recoveryPermutation 3 = 2 ∧
    recoveryPermutation.symm 1 = 2 := ⟨rfl, rfl, rfl, rfl, rfl⟩

private theorem recoveredCoordinates (x : Fin 2) (j : Fin 4) :
    recoveredChannel x j =
      ((![![1 / 6, 1 / 3, 0, 1 / 2], ![0, 0, 1 / 2, 1 / 2]] x j : NNReal) : ENNReal) := by
  have h := recoveredToOriginal.apply x j
  change mixedChannel x (recoveryPermutation j) = recoveredChannel x j at h
  rw [← h, mixedCoordinates]
  fin_cases x <;> fin_cases j <;>
    norm_num [recoveryPermutation, Matrix.cons_val_two, Matrix.cons_val_three]

example (x : Fin 2) : (recoveredChannel x).map recoveryPermutation = mixedChannel x :=
  recoveredToOriginal.map_eq x

example : (recoveredChannel 0).map recoveryPermutation.symm 1 = 1 / 2 ∧
    mixedChannel 0 1 = 0 := by
  constructor
  · have h := PMF.map_apply_equiv (recoveredChannel 0) recoveryPermutation.symm (3 : Fin 4)
    change (recoveredChannel 0).map recoveryPermutation.symm 1 = recoveredChannel 0 3 at h
    rw [h, recoveredCoordinates]
    norm_num [Matrix.cons_val_three]
  · norm_num [mixedChannel, mixedPatterns, mixedWeights, rightPattern]

private def compressedCycle : Fin 3 ≃ Fin 3 where
  toFun := ![1, 2, 0]
  invFun := ![2, 0, 1]
  left_inv j := by fin_cases j <;> rfl
  right_inv j := by fin_cases j <;> rfl

private abbrev singletonChannel : Fin 1 → PMF (Fin 1) := fun _ => PMF.pure 0

private theorem singletonSingular : IsSingularChannel singletonChannel := by
  intro x₁ x₂ j _ _
  exact congrArg (fun x => singletonChannel x j) (Subsingleton.elim x₁ x₂)

private theorem singletonActive (j : Fin 1) : j ∈ activeOutputs singletonChannel := by
  refine ⟨0, ?_⟩
  fin_cases j
  simp [singletonChannel]

private abbrev singletonState := fixtureState (by decide : 0 < 1) singletonChannel singletonActive

private def singletonEnumeration : Fin 1 ≃ OccurringPattern singletonChannel :=
  Equiv.ofBijective (fun j => toOccurringPattern singletonChannel ⟨j, singletonActive j⟩)
    ⟨fun _ _ _ => Subsingleton.elim _ _, by
      intro p
      obtain ⟨y, rfl⟩ := toOccurringPattern_surjective singletonChannel p
      exact ⟨y.val, rfl⟩⟩

private theorem mixedCompressedCoordinates (x : Fin 2) (j : Fin 3) :
    patternCompressedChannel mixedChannel x (mixedEnumeration j) =
      ((![![1 / 2, 0, 1 / 2], ![0, 1 / 2, 1 / 2]] x j : NNReal) : ENNReal) := by
  rw [mixedEnumeration_apply, patternCompressedChannel_eq_ite mixedChannel mixedSingular,
    mixedOutput_val, mixedAggregate]
  fin_cases x <;> fin_cases j <;> norm_num [mixedPatterns, leftPattern, rightPattern, fullPattern]

example : columnValue mixedChannel mixedSingular (mixedAdmitted 0) /
      patternAggregate mixedChannel mixedSingular (mixedOutput 0) = (1 / 3 : ENNReal) ∧
    columnValue mixedChannel mixedSingular (mixedAdmitted 3) /
      patternAggregate mixedChannel mixedSingular (mixedOutput 0) = (2 / 3 : ENNReal) := by
  rw [mixedValue, mixedValue, mixedAggregate]
  constructor
  · have h := congrArg (fun q : NNReal => (q : ENNReal))
      (show (1 / 6 : NNReal) / (1 / 2) = 1 / 3 by norm_num)
    simpa [mixedWeights, ENNReal.coe_div, ENNReal.div_eq_inv_mul, mul_comm] using h
  · have hw : mixedWeights 3 = (1 / 3 : NNReal) := rfl
    rw [hw]
    simp [ENNReal.div_eq_inv_mul, mul_comm]

private theorem nonrepresentableActive (j : Fin 3) :
    j ∈ activeOutputs nonrepresentable3x3 := by
  fin_cases j
  · exact ⟨0, by norm_num [PMF.mem_support_iff, nonrepresentable3x3_apply]⟩
  · exact ⟨0, by norm_num [PMF.mem_support_iff, nonrepresentable3x3_apply]⟩
  · exact ⟨1, by norm_num [PMF.mem_support_iff, nonrepresentable3x3_apply]⟩

private abbrev nonrepresentableState :=
  fixtureState (by decide : 0 < 3) nonrepresentable3x3 nonrepresentableActive

/-! ## R01/R03: the retained all-group certificate and unequal-value inverse -/

private abbrev quarterCompression := patternCompression quarterState quarterSingular
private abbrev quarterForward :=
  patternCompressionCascade quarterState quarterSingular quarterEnumeration.symm
private abbrev quarterInverse :=
  patternCompressionInverse quarterState quarterSingular quarterEnumeration.symm

example : quarterCompression.path.length = 1 := by
  rw [patternCompression_length]
  change 2 - (occurringPatterns quarterChannel).card = 1
  rw [quarterOccurrence]
  simp

example (j : Fin 2) : quarterCompression.labels
    (toOccurringPattern quarterChannel (quarterAdmitted j)) =
      quarterCompression.labels quarterOutput := by
  congr 1
  exact Subtype.ext ((quarterPattern j).trans quarterOutput_val.symm)

example (x : Fin 2) : quarterCompression.endpoint.channel x
    (quarterCompression.labels quarterOutput) = 1 := by
  rw [quarterCompression.coordinates,
    patternCompressedChannel_eq_ite quarterChannel quarterSingular,
    quarterOutput_val, quarterAggregate]
  fin_cases x <;> simp [fullPattern]

example : quarterInverse = quarterForward.reverse := rfl
example : quarterInverse.path.length = 1 := by
  change quarterForward.reverse.path.length = 1
  rw [Cascade.length_reverse]
  change quarterCompression.path.length = 1
  rw [patternCompression_length]
  change 2 - (occurringPatterns quarterChannel).card = 1
  rw [quarterOccurrence]
  simp

example (x j : Fin 2) : quarterInverse.endpoint.channel x
    (quarterInverse.outputEquiv.equiv.symm j) = (quarterWeights j : ENNReal) := by
  rw [quarterInverse.outputEquiv.apply_symm]
  change quarterChannel x j = _
  fin_cases x <;> simp [quarterChannel, quarterPatterns, fullPattern]

/-! ## R05/R06: distinct patterns and singleton states retain zero-length paths -/

private abbrev identityCompression := patternCompression identityState identitySingular

example : identityCompression.path.length = 0 ∧ identityCompression.path.tags = [] :=
  ⟨patternCompression_length_of_injective identityState identitySingular identityPattern_injective,
    patternCompression_tags_of_injective identityState identitySingular identityPattern_injective⟩

example (x j : Fin 2) : identityCompression.endpoint.channel x
    (identityCompression.labels (identityOutput j)) = if x = j then 1 else 0 := by
  rw [identityCompression.coordinates,
    patternCompressedChannel_eq_ite identityChannel identitySingular,
    identityOutput_val, identityAggregate]
  simp [identityPatterns]

example (j : Fin 2) : identityCompression.labels.symm
    (identityCompression.labels (identityOutput j)) = identityOutput j :=
  identityCompression.labels.symm_apply_apply _

private abbrev singletonCompression := patternCompression singletonState singletonSingular
private abbrev singletonInverse :=
  patternCompressionInverse singletonState singletonSingular singletonEnumeration.symm

example : singletonCompression.path.length = 0 ∧ singletonCompression.path.tags = [] :=
  ⟨patternCompression_length_of_injective singletonState singletonSingular
      (fun _ _ _ => Subsingleton.elim _ _),
    patternCompression_tags_of_injective singletonState singletonSingular
      (fun _ _ _ => Subsingleton.elim _ _)⟩

private theorem singletonCompressedValue (x : Fin 1) :
    patternCompressedChannel singletonChannel x (singletonEnumeration 0) = 1 := by
  have h := massMatrix_row_sum (patternCompressedChannel singletonChannel) x
  rw [← singletonEnumeration.sum_comp] at h
  simpa only [Fin.sum_univ_one, massMatrix_apply] using h

example (x : Fin 1) : singletonCompression.endpoint.channel x
    (singletonCompression.labels (singletonEnumeration 0)) = 1 :=
  (singletonCompression.coordinates x _).trans (singletonCompressedValue x)

example : patternAggregate singletonChannel singletonSingular (singletonEnumeration 0) = 1 := by
  have h := singletonCompressedValue 0
  rw [patternCompressedChannel_eq_ite singletonChannel singletonSingular] at h
  have hx : (0 : Fin 1) ∈ (singletonEnumeration 0).val.val := by
    obtain ⟨x, hx⟩ := (singletonEnumeration 0).val.property
    simpa only [Subsingleton.elim x 0] using hx
  simpa only [if_pos hx] using h

example : singletonInverse.path.tags = [] := by
  change (patternCompressionCascade singletonState singletonSingular
    singletonEnumeration.symm).reverse.path.tags = []
  rw [Cascade.tags_reverse]
  change singletonCompression.path.tags.reverse.map OperationKind.reverse = []
  rw [patternCompression_tags_of_injective singletonState singletonSingular
    (fun _ _ _ => Subsingleton.elim _ _)]
  rfl

example (x j : Fin 1) : singletonInverse.endpoint.channel x
    (singletonInverse.outputEquiv.equiv.symm j) = 1 := by
  rw [singletonInverse.outputEquiv.apply_symm]
  change singletonChannel x j = 1
  fin_cases j
  simp [singletonChannel]

/-! ## R07: actual PPM path, retained PPS reverse and directed recovered coordinates -/

private abbrev mixedCompression := patternCompression mixedState mixedSingular
private abbrev mixedForward :=
  patternCompressionCascade mixedState mixedSingular mixedEnumeration.symm
private abbrev mixedInverse :=
  patternCompressionInverse mixedState mixedSingular mixedEnumeration.symm

private def mixedInverseToRecovered : OutputEquiv mixedInverse.endpoint recoveredState :=
  mixedInverse.outputEquiv.trans recoveredToOriginal.symm

example : mixedForward.path = mixedCompression.path := rfl
example : mixedInverse = mixedForward.reverse := rfl
example : mixedCompression.path.Homogeneous .ppm := mixedCompression.homogeneous

private theorem mixedCompression_length : mixedCompression.path.length = 1 := by
  rw [patternCompression_length]
  change 4 - (occurringPatterns mixedChannel).card = 1
  rw [mixedOccurrence]
  simp [Ne.symm full_ne_left, Ne.symm full_ne_right]

private theorem mixedCompression_tags : mixedCompression.path.tags = [.ppm] := by
  obtain ⟨k, hk⟩ := List.length_eq_one_iff.mp
    (show mixedCompression.path.tags.length = 1 by
      rw [OperationPath.tags_length, mixedCompression_length])
  have hk' := mixedCompression.homogeneous k (by rw [hk]; simp)
  simpa only [hk'] using hk

example : mixedInverse.path.tags = [.pps] := by
  change mixedForward.reverse.path.tags = _
  rw [Cascade.tags_reverse]
  change mixedCompression.path.tags.reverse.map OperationKind.reverse = _
  rw [mixedCompression_tags]
  rfl

example (x : Fin 2) (j : Fin 3) : mixedCompression.endpoint.channel x
    (mixedCompression.labels (mixedEnumeration j)) =
      ((![![1 / 2, 0, 1 / 2], ![0, 1 / 2, 1 / 2]] x j : NNReal) : ENNReal) :=
  (mixedCompression.coordinates x _).trans (mixedCompressedCoordinates x j)

example (p : OccurringPattern mixedChannel) :
    ∃ j, mixedCompression.labels p = j ∧ mixedCompression.labels.symm j = p :=
  ⟨mixedCompression.labels p, rfl, mixedCompression.labels.symm_apply_apply p⟩

example (j : Fin 3) : columnPattern mixedCompression.endpoint.channel
    (mixedCompression.endpoint.activeEquiv (mixedCompression.labels (mixedEnumeration j))) =
      (mixedPatterns j.castSucc) :=
  (patternCompression_columnPattern mixedState mixedSingular _).trans (mixedOutput_val _)

example (j : Fin 3) : columnValue mixedCompression.endpoint.channel
    (mixedCompression.isSingular mixedSingular)
    (mixedCompression.endpoint.activeEquiv (mixedCompression.labels (mixedEnumeration j))) =
      1 / 2 :=
  (patternCompression_columnValue mixedState mixedSingular _).trans (mixedAggregate _)

example (x : Fin 2) (j : Fin 4) : mixedInverse.endpoint.channel x
    (mixedInverseToRecovered.equiv.symm j) =
      ((![![1 / 6, 1 / 3, 0, 1 / 2], ![0, 0, 1 / 2, 1 / 2]] x j : NNReal) : ENNReal) :=
  (mixedInverseToRecovered.apply_symm x j).trans (recoveredCoordinates x j)

example (j : Fin 4) : mixedInverseToRecovered.equiv.symm j =
    mixedInverse.outputEquiv.equiv.symm (recoveryPermutation j) := rfl

example (x : Fin 2) (j : Fin 4) : mixedInverse.endpoint.channel x
    (mixedInverse.outputEquiv.equiv.symm j) =
      ((![![1 / 6, 0, 1 / 2, 1 / 3], ![0, 1 / 2, 1 / 2, 0]] x j : NNReal) : ENNReal) :=
  (mixedInverse.outputEquiv.apply_symm x j).trans (mixedCoordinates x j)

example (x : Fin 2) : (mixedInverse.endpoint.channel x).map
    (mixedInverseToRecovered.equiv.trans recoveryPermutation) = mixedChannel x :=
  (mixedInverseToRecovered.trans recoveredToOriginal).map_eq x

/-! ## R12: a supplied compressed enumeration changes coordinates covariantly -/

private abbrev mixedPresented :=
  patternCompressedState mixedState mixedSingular mixedEnumeration.symm
private abbrev mixedCycledPresented :=
  patternCompressedState mixedState mixedSingular (mixedEnumeration.symm.trans compressedCycle)
private abbrev mixedPresentationComparison :=
  patternCompressedState_compare mixedState mixedSingular
    mixedEnumeration.symm (mixedEnumeration.symm.trans compressedCycle)

private theorem mixedPresentationComparison_apply (j : Fin 3) :
    mixedPresentationComparison.equiv j = compressedCycle j := by
  change compressedCycle (mixedEnumeration.symm (mixedEnumeration j)) = _
  rw [Equiv.symm_apply_apply]

example : mixedPresentationComparison.equiv (0 : Fin 3) = (1 : Fin 3) ∧
    mixedPresentationComparison.equiv.symm (0 : Fin 3) = (2 : Fin 3) := by
  constructor
  · rw [mixedPresentationComparison_apply]; rfl
  · change mixedEnumeration.symm (mixedEnumeration (2 : Fin 3)) = 2
    exact mixedEnumeration.symm_apply_apply _

example (x : Fin 2) (j : Fin 3) : mixedPresented.channel x j =
    ((![![1 / 2, 0, 1 / 2], ![0, 1 / 2, 1 / 2]] x j : NNReal) : ENNReal) := by
  have h := patternCompressedState_apply mixedState mixedSingular mixedEnumeration.symm x
    (mixedEnumeration j)
  simpa only [Equiv.symm_apply_apply] using h.trans (mixedCompressedCoordinates x j)

example (x : Fin 2) (j : Fin 3) : mixedCycledPresented.channel x (compressedCycle j) =
    mixedPresented.channel x j := by
  simpa only [mixedPresentationComparison_apply] using mixedPresentationComparison.apply x j

example (x : Fin 2) : (mixedPresented.channel x).map compressedCycle =
    mixedCycledPresented.channel x := by
  have he : mixedPresentationComparison.equiv = compressedCycle := by
    apply Equiv.ext
    intro j
    exact mixedPresentationComparison_apply j
  have h : (mixedPresented.channel x).map mixedPresentationComparison.equiv =
      mixedCycledPresented.channel x := mixedPresentationComparison.map_eq x
  rw [he] at h
  exact h

/-! ## R08: existing nonperfectness excludes both compressed reachability predicates -/

private abbrev nonrepresentableEnumeration :=
  Fintype.equivFin (OccurringPattern nonrepresentable3x3)
private abbrev nonrepresentableCompressed :=
  patternCompressedState nonrepresentableState nonrepresentable3x3_isSingular
    nonrepresentableEnumeration

example : ¬ FromAllOnes nonrepresentableCompressed := by
  intro h
  have hsource := (fromAllOnes_iff_patternCompressedState nonrepresentableState
    nonrepresentable3x3_isSingular nonrepresentableEnumeration).mpr h
  exact nonrepresentable3x3_not_isPerfectlyRepresentableChannel hsource.isPerfectlyRepresentable

example : ¬ ToAllOnes nonrepresentableCompressed := by
  intro h
  have hsource := (toAllOnes_iff_patternCompressedState nonrepresentableState
    nonrepresentable3x3_isSingular nonrepresentableEnumeration).mpr h
  exact nonrepresentable3x3_not_isPerfectlyRepresentableChannel hsource.isPerfectlyRepresentable

/-! The four reachability directions retain actual concatenated witnesses and
their tag words. These consumers assume a supplied witness, with no prior. -/

section WitnessConsumers
variable {α : Type*} [Fintype α] [Nonempty α]
  (S : ActiveFiniteChannel α) (hS : IsSingularChannel S.channel)
  {m : Nat} (e : OccurringPattern S.channel ≃ Fin m)

example : IsPerfectlyRepresentableChannel S.channel ↔
    IsPerfectlyRepresentableChannel (patternCompressedState S hS e).channel :=
  isPerfectlyRepresentable_iff_patternCompressedState S hS e

example (c : Cascade (ActiveFiniteChannel.allOnes α) S) (hc : c.path.Normalizing) :
    ∃ d : Cascade (ActiveFiniteChannel.allOnes α) (patternCompressedState S hS e),
      d.path.Normalizing ∧ d.path.tags =
        c.path.tags ++ (patternCompressionCascade S hS e).path.tags := by
  refine ⟨c.comp (patternCompressionCascade S hS e), ?_, Cascade.tags_comp _ _⟩
  exact (Cascade.allowed_comp _ _ _).mpr ⟨hc, fun k hk =>
    Or.inr (Or.inr (patternCompressionCascade_ppm S hS e k hk))⟩

example (c : Cascade (ActiveFiniteChannel.allOnes α) (patternCompressedState S hS e))
    (hc : c.path.Normalizing) :
    ∃ d : Cascade (ActiveFiniteChannel.allOnes α) S,
      d.path.Normalizing ∧ d.path.tags =
        c.path.tags ++ (patternCompressionInverse S hS e).path.tags := by
  refine ⟨c.comp (patternCompressionInverse S hS e), ?_, Cascade.tags_comp _ _⟩
  exact (Cascade.allowed_comp _ _ _).mpr ⟨hc, fun k hk =>
    Or.inl (patternCompressionInverse_pps S hS e k hk)⟩

example (c : Cascade S (ActiveFiniteChannel.allOnes α)) (hc : c.path.Reducing) :
    ∃ d : Cascade (patternCompressedState S hS e) (ActiveFiniteChannel.allOnes α),
      d.path.Reducing ∧ d.path.tags =
        (patternCompressionInverse S hS e).path.tags ++ c.path.tags := by
  refine ⟨(patternCompressionInverse S hS e).comp c, ?_, Cascade.tags_comp _ _⟩
  exact (Cascade.allowed_comp _ _ _).mpr ⟨fun k hk =>
    Or.inr (Or.inl (patternCompressionInverse_pps S hS e k hk)), hc⟩

example (c : Cascade (patternCompressedState S hS e) (ActiveFiniteChannel.allOnes α))
    (hc : c.path.Reducing) :
    ∃ d : Cascade S (ActiveFiniteChannel.allOnes α),
      d.path.Reducing ∧ d.path.tags =
        (patternCompressionCascade S hS e).path.tags ++ c.path.tags := by
  refine ⟨(patternCompressionCascade S hS e).comp c, ?_, Cascade.tags_comp _ _⟩
  exact (Cascade.allowed_comp _ _ _).mpr ⟨fun k hk =>
    Or.inl (patternCompressionCascade_ppm S hS e k hk), hc⟩
end WitnessConsumers

/-! ## S03 R09: full dependent recovery and exact/Real laws for arbitrary data -/

section RealDataConsumers
variable {α β : Type*} [Fintype α] [Finite β]

example (κ : α → PMF β) (hκ : IsSingularChannel κ) (p : OccurringPattern κ) :
    0 < (patternAggregate κ hκ p).toReal ∧
      (patternAggregate κ hκ p).toReal ≤ 1 ∧
      ENNReal.ofReal (patternAggregate κ hκ p).toReal = patternAggregate κ hκ p :=
  ⟨patternAggregate_toReal_pos κ hκ p, patternAggregate_toReal_le_one κ hκ p,
    ofReal_patternAggregate_toReal κ hκ p⟩

example (κ : α → PMF β) (hκ : IsSingularChannel κ) (p : OccurringPattern κ) :
    (∑ y : activeOutputs κ,
      if columnPattern κ y = p.val then (columnValue κ hκ y).toReal else 0) =
        ∑ y : PatternFiber κ p, (columnValue κ hκ y.val).toReal :=
  (patternAggregate_toReal_eq_sum κ hκ p).symm.trans
    (patternAggregate_toReal_eq_sum_subtype κ hκ p)

example (κ : α → PMF β) (hκ : IsSingularChannel κ) (x : α) :
    (∑ p : OccurringPattern κ,
      if x ∈ p.val.val then (patternAggregate κ hκ p).toReal else 0) = 1 :=
  patternAggregate_toReal_row_sum κ hκ x

example (κ : α → PMF β) (hκ : IsSingularChannel κ) (x : α) (p : OccurringPattern κ) :
    ENNReal.ofReal (if x ∈ p.val.val then (patternAggregate κ hκ p).toReal else 0) =
      patternCompressedChannel κ x p := by
  rw [← patternCompressedChannel_toReal_eq_ite κ hκ x p]
  exact ENNReal.ofReal_toReal ((patternCompressedChannel κ x).apply_ne_top p)

example (κ : α → PMF β) (hκ : IsSingularChannel κ) :
    channelOfRealMatrix
      (Matrix.of fun x (p : OccurringPattern κ) =>
        if x ∈ p.val.val then (patternAggregate κ hκ p).toReal else 0)
      (fun x p => by
        change 0 ≤ if x ∈ p.val.val then (patternAggregate κ hκ p).toReal else 0
        split_ifs <;> positivity)
      (patternAggregate_toReal_row_sum κ hκ) = patternCompressedChannel κ :=
  channelOfRealPatternAggregates κ hκ

variable [Nonempty α]

example (D : CompressedPatternData α) :
    compressedPatternData D.channel D.channel_singular = D := D.extraction_roundTrip

example (D : CompressedPatternData α) : occurringPatterns D.channel = D.patterns :=
  D.occurringPatterns_channel

example (D : CompressedPatternData α) (p : ↥D.patterns) :
    patternFiber D.channel
      ⟨p.val, by rw [D.occurringPatterns_channel]; exact p.property⟩ =
        {⟨p, D.channel_active p⟩} ∧
    (compressedPatternData D.channel D.channel_singular).value
      ⟨p.val, by
        change p.val ∈ occurringPatterns D.channel
        rw [D.occurringPatterns_channel]
        exact p.property⟩ = D.value p :=
  ⟨D.patternFiber_channel p, D.extracted_value p⟩

example (D : CompressedPatternData α) (x : α) :
    (∑ p : ↥D.patterns, if x ∈ p.val.val then ENNReal.ofReal (D.value p) else 0) = 1 := by
  simpa only [massMatrix_apply, D.channel_apply] using massMatrix_row_sum D.channel x

example (D : CompressedPatternData α) (x : α) (p : ↥D.patterns) :
    (D.channel x p).toReal = if x ∈ p.val.val then D.value p else 0 := by
  rw [D.channel_apply]
  split_ifs
  · exact ENNReal.toReal_ofReal (le_of_lt (D.value_pos p))
  · exact ENNReal.toReal_zero

example (D : CompressedPatternData α) (p : ↥D.patterns) :
    columnPattern D.channel ⟨p, D.channel_active p⟩ = p.val ∧
    (columnValue D.channel D.channel_singular ⟨p, D.channel_active p⟩).toReal = D.value p := by
  refine ⟨D.channel_columnPattern p, ?_⟩
  rw [D.channel_columnValue]
  exact ENNReal.toReal_ofReal (le_of_lt (D.value_pos p))
end RealDataConsumers

/-! ## S03 R01/R04/R07: Real values reuse the exact and witnessed fixtures -/

private abbrev quarterData := compressedPatternData quarterChannel quarterSingular
private abbrev identityData := compressedPatternData identityChannel identitySingular
private abbrev mixedData := compressedPatternData mixedChannel mixedSingular

example : quarterData.patterns = {fullPattern} := quarterOccurrence

private theorem quarterRealValue : quarterData.value quarterOutput = 1 := by
  change (patternAggregate quarterChannel quarterSingular quarterOutput).toReal = 1
  rw [quarterAggregate, ENNReal.toReal_one]

example : (∑ y ∈ patternFiber quarterChannel quarterOutput,
    (columnValue quarterChannel quarterSingular y).toReal) = 1 := by
  rw [← patternAggregate_toReal_eq_sum_fiber, quarterAggregate, ENNReal.toReal_one]

example : ENNReal.ofReal (quarterData.value quarterOutput) = 1 := by
  rw [quarterRealValue, ENNReal.ofReal_one]

example (x : Fin 2) : quarterData.channel x quarterOutput = 1 := by
  change (if x ∈ quarterOutput.val.val then ENNReal.ofReal (quarterData.value quarterOutput)
    else 0) = 1
  rw [quarterOutput_val, quarterRealValue]
  simp only [fullPattern, Finset.mem_univ, if_true, ENNReal.ofReal_one]

private theorem identityRealValue (j : Fin 2) : identityData.value (identityOutput j) = 1 := by
  change (patternAggregate identityChannel identitySingular (identityOutput j)).toReal = 1
  rw [identityAggregate, ENNReal.toReal_one]

example : (∑ p : ↥identityData.patterns, identityData.value p) = 2 := by
  change (∑ p : OccurringPattern identityChannel,
    (patternAggregate identityChannel identitySingular p).toReal) = 2
  rw [← identityOutputEquiv.sum_comp]
  change (∑ j : Fin 2,
    (patternAggregate identityChannel identitySingular (identityOutput j)).toReal) = 2
  simp [identityAggregate]

example (x : Fin 2) :
    (∑ p : ↥identityData.patterns, if x ∈ p.val.val then identityData.value p else 0) = 1 :=
  identityData.row_sum x

example (x j : Fin 2) : identityData.channel x (identityOutput j) = if x = j then 1 else 0 := by
  change (if x ∈ (identityOutput j).val.val then
    ENNReal.ofReal (identityData.value (identityOutput j)) else 0) = _
  rw [identityOutput_val, identityRealValue]
  simp [identityPatterns]

private theorem mixedRealValue (j : Fin 4) : mixedData.value (mixedOutput j) = 1 / 2 := by
  change (patternAggregate mixedChannel mixedSingular (mixedOutput j)).toReal = 1 / 2
  rw [mixedAggregate]
  norm_num

example : (∑ y ∈ patternFiber mixedChannel (mixedOutput 0),
    (columnValue mixedChannel mixedSingular y).toReal) = 1 / 2 := by
  rw [← patternAggregate_toReal_eq_sum_fiber, mixedAggregate]
  norm_num

example (j : Fin 4) : ENNReal.ofReal (mixedData.value (mixedOutput j)) = 1 / 2 := by
  change ENNReal.ofReal (patternAggregate mixedChannel mixedSingular (mixedOutput j)).toReal = _
  rw [ofReal_patternAggregate_toReal, mixedAggregate]

example (x : Fin 2) :
    (∑ p : ↥mixedData.patterns, if x ∈ p.val.val then mixedData.value p else 0) = 1 :=
  mixedData.row_sum x

example : (∑ p : ↥mixedData.patterns, mixedData.value p) = 3 / 2 := by
  change (∑ p : OccurringPattern mixedChannel,
    (patternAggregate mixedChannel mixedSingular p).toReal) = 3 / 2
  rw [← mixedEnumeration.sum_comp]
  simp only [mixedEnumeration_apply, mixedAggregate]
  norm_num

private theorem mixedDataCoordinates (x : Fin 2) (j : Fin 3) :
    mixedData.channel x (mixedEnumeration j) =
      ((![![1 / 2, 0, 1 / 2], ![0, 1 / 2, 1 / 2]] x j : NNReal) : ENNReal) := by
  change (if x ∈ (mixedEnumeration j).val.val then
    ENNReal.ofReal (mixedData.value (mixedEnumeration j)) else 0) = _
  rw [mixedEnumeration_apply, mixedOutput_val, mixedRealValue]
  fin_cases x <;> fin_cases j <;>
    norm_num [mixedPatterns, leftPattern, rightPattern, fullPattern, ENNReal.ofReal_div_of_pos]

example (x : Fin 2) (j : Fin 3) : (mixedData.channel x (mixedEnumeration j)).toReal =
    (![![1 / 2, 0, 1 / 2], ![0, 1 / 2, 1 / 2]] x j : ℝ) := by
  rw [mixedDataCoordinates]
  fin_cases x <;> fin_cases j <;> norm_num

/-! ## S03 R08: the existing nonperfect channel still supplies valid Real data -/

local instance : DecidableEq (Fin 3) := fun a b => Classical.propDecidable (a = b)

private abbrev Pattern3 := {s : Finset (Fin 3) // s.Nonempty}
private def counterexamplePatterns : Fin 3 → Pattern3 :=
  ![⟨{0, 1}, by simp⟩, ⟨{0, 2}, by simp⟩, ⟨{1, 2}, by simp⟩]
private abbrev counterexampleAdmitted (j : Fin 3) : activeOutputs nonrepresentable3x3 :=
  ⟨j, nonrepresentableActive j⟩

private theorem counterexamplePattern (j : Fin 3) :
    columnPattern nonrepresentable3x3 (counterexampleAdmitted j) = counterexamplePatterns j := by
  apply Subtype.ext
  ext x
  rw [mem_columnPattern]
  fin_cases x <;> fin_cases j <;>
    norm_num [counterexampleAdmitted, nonrepresentable3x3_apply, counterexamplePatterns,
      Fin.ext_iff]

private theorem counterexampleValue (j : Fin 3) :
    columnValue nonrepresentable3x3 nonrepresentable3x3_isSingular (counterexampleAdmitted j) =
      1 / 2 := by
  fin_cases j
  · exact (columnValue_eq_of_ne_zero nonrepresentable3x3 nonrepresentable3x3_isSingular
      (counterexampleAdmitted 0) (x := 0) (by norm_num [nonrepresentable3x3_apply])).trans
        (by norm_num [nonrepresentable3x3_apply])
  · exact (columnValue_eq_of_ne_zero nonrepresentable3x3 nonrepresentable3x3_isSingular
      (counterexampleAdmitted 1) (x := 0) (by norm_num [nonrepresentable3x3_apply])).trans
        (by norm_num [nonrepresentable3x3_apply])
  · exact (columnValue_eq_of_ne_zero nonrepresentable3x3 nonrepresentable3x3_isSingular
      (counterexampleAdmitted 2) (x := 1) (by norm_num [nonrepresentable3x3_apply])).trans
        (by norm_num [nonrepresentable3x3_apply])

private theorem counterexamplePatterns_injective : Function.Injective counterexamplePatterns := by
  intro i j h
  have h0 := congrArg (fun p : Pattern3 => (0 : Fin 3) ∈ p.val) h
  have h1 := congrArg (fun p : Pattern3 => (1 : Fin 3) ∈ p.val) h
  fin_cases i <;> fin_cases j <;> try rfl
  all_goals
    norm_num [counterexamplePatterns, Fin.ext_iff] at h0 <;>
      norm_num [counterexamplePatterns, Fin.ext_iff] at h1

private abbrev counterexampleOutput (j : Fin 3) : OccurringPattern nonrepresentable3x3 :=
  toOccurringPattern nonrepresentable3x3 (counterexampleAdmitted j)

private theorem counterexampleOutput_val (j : Fin 3) :
    (counterexampleOutput j).val = counterexamplePatterns j := counterexamplePattern j

private def counterexampleEnumeration : Fin 3 ≃ OccurringPattern nonrepresentable3x3 :=
  Equiv.ofBijective counterexampleOutput ⟨by
    intro i j h
    apply counterexamplePatterns_injective
    exact (counterexampleOutput_val i).symm.trans
      ((congrArg Subtype.val h).trans (counterexampleOutput_val j)),
    (toOccurringPattern_surjective nonrepresentable3x3).comp
      (allActiveEquiv nonrepresentable3x3 nonrepresentableActive).surjective⟩

private abbrev counterexampleData :=
  compressedPatternData nonrepresentable3x3 nonrepresentable3x3_isSingular

example : counterexampleData.patterns =
    {counterexamplePatterns 0, counterexamplePatterns 1, counterexamplePatterns 2} := by
  change occurringPatterns nonrepresentable3x3 = _
  rw [occurring_allActive nonrepresentable3x3 nonrepresentableActive]
  simp only [show (fun j => columnPattern nonrepresentable3x3 ⟨j, nonrepresentableActive j⟩) =
    counterexamplePatterns from funext counterexamplePattern]
  ext p
  simp only [Finset.mem_image, Finset.mem_univ, true_and,
    Finset.mem_insert, Finset.mem_singleton]
  constructor
  · rintro ⟨j, rfl⟩
    fin_cases j <;> simp
  · rintro (rfl | rfl | rfl)
    · exact ⟨0, rfl⟩
    · exact ⟨1, rfl⟩
    · exact ⟨2, rfl⟩

private theorem counterexampleRealValue (j : Fin 3) :
    counterexampleData.value (counterexampleOutput j) = 1 / 2 := by
  change (patternAggregate nonrepresentable3x3 nonrepresentable3x3_isSingular
    (counterexampleOutput j)).toReal = _
  rw [aggregate_allActive nonrepresentable3x3 nonrepresentable3x3_isSingular nonrepresentableActive,
    counterexampleOutput_val]
  simp only [counterexamplePattern, counterexampleValue,
    counterexamplePatterns_injective.eq_iff]
  simp

example : (∑ p : ↥counterexampleData.patterns, counterexampleData.value p) = 3 / 2 := by
  change (∑ p : OccurringPattern nonrepresentable3x3,
    (patternAggregate nonrepresentable3x3 nonrepresentable3x3_isSingular p).toReal) = 3 / 2
  rw [← counterexampleEnumeration.sum_comp]
  change (∑ j : Fin 3, counterexampleData.value (counterexampleOutput j)) = 3 / 2
  simp only [counterexampleRealValue]
  norm_num

example (x : Fin 3) : (∑ p : ↥counterexampleData.patterns,
    if x ∈ p.val.val then counterexampleData.value p else 0) = 1 :=
  counterexampleData.row_sum x

example (x j : Fin 3) : counterexampleData.channel x (counterexampleOutput j) =
    nonrepresentable3x3 x j := by
  change (if x ∈ (counterexampleOutput j).val.val then
    ENNReal.ofReal (counterexampleData.value (counterexampleOutput j)) else 0) = _
  rw [counterexampleOutput_val, counterexampleRealValue]
  fin_cases x <;> fin_cases j <;>
    norm_num [counterexamplePatterns, nonrepresentable3x3_apply, Fin.ext_iff,
      ENNReal.ofReal_div_of_pos]

example : ¬ IsPerfectlyRepresentableChannel counterexampleData.channel := by
  intro h
  have hcompressed :
      IsPerfectlyRepresentableChannel (patternCompressedChannel nonrepresentable3x3) := by
    rw [← compressedPatternData_channel nonrepresentable3x3 nonrepresentable3x3_isSingular]
    exact h
  have hpresent : IsPerfectlyRepresentableChannel nonrepresentableCompressed.channel :=
    (isPerfectlyRepresentableChannel_map_iff _ nonrepresentableEnumeration
      nonrepresentableEnumeration.injective).mpr hcompressed
  exact nonrepresentable3x3_not_isPerfectlyRepresentableChannel
    ((isPerfectlyRepresentable_iff_patternCompressedState nonrepresentableState
      nonrepresentable3x3_isSingular nonrepresentableEnumeration).mpr hpresent)

/-! ## S03 R09/R10: derived bounds, nonempty families and supplied presentations -/

section DataPresentationConsumers
variable {α β : Type*} [Fintype α] [Nonempty α] [Finite β]

example (κ : α → PMF β) (hκ : IsSingularChannel κ) :
    (compressedPatternData κ hκ).channel = patternCompressedChannel κ :=
  compressedPatternData_channel κ hκ

example (κ : α → PMF β) :
    channelOfMassMatrix (massMatrix (patternCompressedChannel κ))
      (massMatrix_row_sum (patternCompressedChannel κ)) = patternCompressedChannel κ :=
  channelOfMassMatrix_massMatrix (patternCompressedChannel κ)

example (κ : α → PMF β) :
    channelOfRealMatrix (realMatrix (patternCompressedChannel κ))
      (realMatrix_nonneg (patternCompressedChannel κ))
      (realMatrix_row_sum (patternCompressedChannel κ)) = patternCompressedChannel κ :=
  channelOfRealMatrix_realMatrix (patternCompressedChannel κ)

example (D : CompressedPatternData α) (p : ↥D.patterns) :
    0 < D.value p ∧ D.value p ≤ 1 := ⟨D.value_pos p, D.value_le_one p⟩

example (D : CompressedPatternData α) : D.patterns.Nonempty := D.patterns_nonempty

example (D : CompressedPatternData α) (hempty : D.patterns = ∅) : False := by
  have h := D.patterns_nonempty
  rw [hempty] at h
  exact Finset.not_nonempty_empty h

example (D : CompressedPatternData α) {m : Nat} (e : ↥D.patterns ≃ Fin m)
    (x : α) (p : ↥D.patterns) :
    (D.toActiveFiniteChannel e).channel x (e p) =
      if x ∈ p.val.val then ENNReal.ofReal (D.value p) else 0 :=
  (D.toActiveFiniteChannel_apply e x p).trans (D.channel_apply x p)

example (D : CompressedPatternData α) {m : Nat} (e : ↥D.patterns ≃ Fin m) (x : α) :
    ((D.toActiveFiniteChannel e).channel x).map e.symm = D.channel x :=
  D.toActiveFiniteChannel_recover e x

example (D : CompressedPatternData α) {m n : Nat}
    (e : ↥D.patterns ≃ Fin m) (f : ↥D.patterns ≃ Fin n) :
    (D.toActiveFiniteChannel_compare e f).equiv = e.symm.trans f := rfl

example (D : CompressedPatternData α) {m n : Nat}
    (e : ↥D.patterns ≃ Fin m) (f : ↥D.patterns ≃ Fin n) (x : α) (p : ↥D.patterns) :
    (D.toActiveFiniteChannel f).channel x (f p) =
      (D.toActiveFiniteChannel e).channel x (e p) :=
  (D.toActiveFiniteChannel_apply f x p).trans (D.toActiveFiniteChannel_apply e x p).symm

example (D : CompressedPatternData α) {m : Nat} (e : ↥D.patterns ≃ Fin m)
    (p : ↥D.patterns) :
    columnPattern (D.toActiveFiniteChannel e).channel
      ((D.toActiveFiniteChannel e).activeEquiv (e p)) = p.val ∧
    columnValue (D.toActiveFiniteChannel e).channel (D.toActiveFiniteChannel_singular e)
      ((D.toActiveFiniteChannel e).activeEquiv (e p)) = ENNReal.ofReal (D.value p) :=
  ⟨D.toActiveFiniteChannel_columnPattern e p, D.toActiveFiniteChannel_columnValue e p⟩

private def extractedDataPresentationComparison
    (S : ActiveFiniteChannel α) (hS : IsSingularChannel S.channel) {m n : Nat}
    (e : OccurringPattern S.channel ≃ Fin m) (f : OccurringPattern S.channel ≃ Fin n) :
    OutputEquiv ((compressedPatternData S.channel hS).toActiveFiniteChannel e)
      (patternCompressedState S hS f) := by
  apply OutputEquiv.ofCoordinates (e.symm.trans f)
  intro x j
  calc
    _ = patternCompressedChannel S.channel x (e.symm j) :=
      patternCompressedState_apply S hS f x (e.symm j)
    _ = (compressedPatternData S.channel hS).channel x (e.symm j) :=
      (congrArg (fun q : PMF (OccurringPattern S.channel) => q (e.symm j))
        (congrFun (compressedPatternData_channel S.channel hS) x)).symm
    _ = ((compressedPatternData S.channel hS).toActiveFiniteChannel e).channel x j :=
      ((compressedPatternData S.channel hS).toActiveFiniteChannel_apply e x (e.symm j)).symm.trans
        (congrArg (fun k : Fin m =>
          ((compressedPatternData S.channel hS).toActiveFiniteChannel e).channel x k)
          (e.apply_symm_apply j))

example (S : ActiveFiniteChannel α) (hS : IsSingularChannel S.channel) {m n : Nat}
    (e : OccurringPattern S.channel ≃ Fin m) (f : OccurringPattern S.channel ≃ Fin n) :
    (extractedDataPresentationComparison S hS e f).equiv = e.symm.trans f := rfl
end DataPresentationConsumers

/-! ## S04 R11/R12: ambient injection and supplied source enumeration -/

private abbrev injectedChannel : Fin 2 → PMF (Fin 5) :=
  fun x => (mixedChannel x).map Fin.castSucc

private theorem injectedSingular : IsSingularChannel injectedChannel :=
  (isSingularChannel_map_iff mixedChannel Fin.castSucc (Fin.castSucc_injective 4)).mpr mixedSingular

private theorem extraLabel_not_range : (4 : Fin 5) ∉ Set.range (Fin.castSucc : Fin 4 → Fin 5) := by
  rintro ⟨j, hj⟩
  have hv := congrArg Fin.val hj
  have hjlt := j.isLt
  change j.val = 4 at hv
  omega

private theorem injectedCoordinates (x : Fin 2) (j : Fin 4) :
    injectedChannel x j.castSucc = mixedChannel x j :=
  PMF.map_apply_of_injective _ (Fin.castSucc_injective 4) j

private theorem injectedUnused (x : Fin 2) : injectedChannel x 4 = 0 :=
  massMatrix_map_eq_zero mixedChannel Fin.castSucc x 4 extraLabel_not_range

example (x : Fin 2) (j : Fin 5) : injectedChannel x j =
    ((![![1 / 6, 0, 1 / 2, 1 / 3, 0], ![0, 1 / 2, 1 / 2, 0, 0]] x j : NNReal) : ENNReal) := by
  fin_cases j
  · fin_cases x <;> exact (injectedCoordinates _ 0).trans (mixedCoordinates _ 0)
  · fin_cases x <;> exact (injectedCoordinates _ 1).trans (mixedCoordinates _ 1)
  · fin_cases x <;> exact (injectedCoordinates _ 2).trans (mixedCoordinates _ 2)
  · fin_cases x <;> exact (injectedCoordinates _ 3).trans (mixedCoordinates _ 3)
  · fin_cases x <;> exact injectedUnused _

example (x : Fin 2) : realMatrix injectedChannel x 4 = 0 :=
  realMatrix_map_eq_zero mixedChannel Fin.castSucc x 4 extraLabel_not_range

example (x : Fin 2) (j : Fin 4) :
    realMatrix injectedChannel x j.castSucc = realMatrix mixedChannel x j :=
  realMatrix_map mixedChannel Fin.castSucc (Fin.castSucc_injective 4) x j

example : (4 : Fin 5) ∉ activeOutputs injectedChannel := by
  rintro ⟨x, hx⟩
  exact ((PMF.mem_support_iff _ _).mp hx) (injectedUnused x)

example (y : activeOutputs injectedChannel) : y.val ≠ 4 := by
  intro hy
  obtain ⟨x, hx⟩ := y.property
  exact ((PMF.mem_support_iff _ _).mp hx) (hy ▸ injectedUnused x)

private def injectedActiveEquiv : Fin 4 ≃ activeOutputs injectedChannel :=
  (allActiveEquiv mixedChannel mixedActive).trans
    (activeOutputsMapEquiv mixedChannel Fin.castSucc (Fin.castSucc_injective 4))

private abbrev injectedSourceEnumeration := injectedActiveEquiv.symm
private abbrev injectedState :=
  ActiveFiniteChannel.ofChannelWithEquiv injectedChannel injectedSourceEnumeration

private theorem injectedStateCoordinates (x : Fin 2) (j : Fin 4) :
    injectedState.channel x j = mixedChannel x j := by
  have h := ActiveFiniteChannel.ofChannelWithEquiv_apply injectedChannel
    injectedSourceEnumeration x (injectedActiveEquiv j)
  simpa only [Equiv.symm_apply_apply] using h.trans (injectedCoordinates x j)

private theorem injectedState_channel : injectedState.channel = mixedChannel :=
  funext fun x => PMF.ext (injectedStateCoordinates x)

private theorem injectedStateSingular : IsSingularChannel injectedState.channel :=
  (ActiveFiniteChannel.isSingularChannel_ofChannelWithEquiv_iff _ _).mpr injectedSingular

private def injectedCompressedEnumeration : OccurringPattern injectedState.channel ≃ Fin 3 :=
  (Equiv.cast (congrArg (fun κ : Fin 2 → PMF (Fin 4) => OccurringPattern κ)
    injectedState_channel)).trans mixedEnumeration.symm

private abbrev injectedInverse :=
  patternCompressionInverse injectedState injectedStateSingular injectedCompressedEnumeration

example (x : Fin 2) : (injectedState.channel x).map
    (fun j => (injectedSourceEnumeration.symm j).val) = injectedChannel x :=
  ActiveFiniteChannel.ofChannelWithEquiv_recover _ _ _

private theorem injectedInverse_recover (x : Fin 2) :
    (injectedInverse.endpoint.channel x).map
      (fun j => (injectedSourceEnumeration.symm (injectedInverse.outputEquiv.equiv j)).val) =
        injectedChannel x :=
  patternCompressionInverse_ambient_recover injectedChannel injectedSourceEnumeration
    injectedStateSingular injectedCompressedEnumeration x

example (x : Fin 2) (j : Fin 4) :
    (injectedInverse.endpoint.channel x).map
      (fun k => (injectedSourceEnumeration.symm (injectedInverse.outputEquiv.equiv k)).val)
        j.castSucc = mixedChannel x j := by
  rw [injectedInverse_recover]
  exact injectedCoordinates x j

example (x : Fin 2) :
    (injectedInverse.endpoint.channel x).map
      (fun k => (injectedSourceEnumeration.symm
        (injectedInverse.outputEquiv.equiv k)).val) 4 = 0 := by
  rw [injectedInverse_recover]
  exact injectedUnused x

private abbrev changedSourceEnumeration := injectedSourceEnumeration.trans outputCycle
private abbrev changedSourceState :=
  ActiveFiniteChannel.ofChannelWithEquiv injectedChannel changedSourceEnumeration

private theorem changedSourceCoordinates (x : Fin 2) (j : Fin 4) :
    changedSourceState.channel x (outputCycle j) = mixedChannel x j := by
  have h := ActiveFiniteChannel.ofChannelWithEquiv_apply injectedChannel
    changedSourceEnumeration x (injectedActiveEquiv j)
  simpa only [Equiv.trans_apply, Equiv.symm_apply_apply] using h.trans (injectedCoordinates x j)

example (x : Fin 2) : (injectedState.channel x).map outputCycle = changedSourceState.channel x := by
  have he : injectedSourceEnumeration.symm.trans changedSourceEnumeration = outputCycle := by
    apply Equiv.ext
    intro j
    exact congrArg outputCycle (injectedSourceEnumeration.apply_symm_apply j)
  simpa only [he] using ActiveFiniteChannel.ofChannelWithEquiv_compare injectedChannel
    injectedSourceEnumeration changedSourceEnumeration x

/-! ## S04 R13: public pattern and Real-constant handoff without incidence data -/

example {α β : Type*} [Fintype α] [Nonempty α] [Finite β]
    (κ : α → PMF β) (hκ : IsSingularChannel κ) :
    let D := compressedPatternData κ hκ
    D.patterns = occurringPatterns κ ∧ D.patterns.Nonempty ∧
      (∀ p, 0 < D.value p ∧ D.value p ≤ 1 ∧
        ENNReal.ofReal (D.value p) = patternAggregate κ hκ p) ∧
      (∀ x, (∑ p, if x ∈ p.val.val then D.value p else 0) = 1) ∧
      IsSingularChannel D.channel ∧ compressedPatternData D.channel D.channel_singular = D := by
  dsimp only
  refine ⟨rfl, (compressedPatternData κ hκ).patterns_nonempty, ?_,
    (compressedPatternData κ hκ).row_sum, (compressedPatternData κ hκ).channel_singular,
    (compressedPatternData κ hκ).extraction_roundTrip⟩
  intro p
  exact ⟨(compressedPatternData κ hκ).value_pos p, (compressedPatternData κ hκ).value_le_one p,
    ofReal_patternAggregate_toReal κ hκ p⟩

/-! ## S04 R12: exact/Real invariance and simultaneous source/target changes -/

private def injectedOutput (p : OccurringPattern mixedChannel) : OccurringPattern injectedChannel :=
  ⟨p.val, by
    rw [occurringPatterns_map_injective mixedChannel Fin.castSucc (Fin.castSucc_injective 4)]
    exact p.property⟩

example : occurringPatterns injectedChannel = {leftPattern, rightPattern, fullPattern} := by
  rw [occurringPatterns_map_injective mixedChannel Fin.castSucc (Fin.castSucc_injective 4),
    mixedOccurrence]

private theorem injectedAggregate (p : OccurringPattern mixedChannel) :
    patternAggregate injectedChannel injectedSingular (injectedOutput p) =
      patternAggregate mixedChannel mixedSingular p :=
  patternAggregate_map_injective mixedChannel Fin.castSucc (Fin.castSucc_injective 4)
    mixedSingular injectedSingular p (injectedOutput p) rfl

example (p : OccurringPattern mixedChannel) :
    (patternAggregate injectedChannel injectedSingular (injectedOutput p)).toReal =
      (patternAggregate mixedChannel mixedSingular p).toReal :=
  patternAggregate_toReal_map_injective mixedChannel Fin.castSucc (Fin.castSucc_injective 4)
    mixedSingular injectedSingular p (injectedOutput p) rfl

example (j : Fin 4) :
    patternAggregate injectedChannel injectedSingular (injectedOutput (mixedOutput j)) = 1 / 2 ∧
    (compressedPatternData injectedChannel injectedSingular).value
      (injectedOutput (mixedOutput j)) = 1 / 2 := by
  constructor
  · exact (injectedAggregate _).trans (mixedAggregate j)
  · change (patternAggregate injectedChannel injectedSingular
      (injectedOutput (mixedOutput j))).toReal = _
    rw [injectedAggregate, mixedAggregate]
    norm_num

example : compressedPatternData injectedChannel injectedSingular = mixedData :=
  compressedPatternData_map_injective mixedChannel Fin.castSucc (Fin.castSucc_injective 4)
    mixedSingular injectedSingular

private theorem changedSourceSingular : IsSingularChannel changedSourceState.channel :=
  (ActiveFiniteChannel.isSingularChannel_ofChannelWithEquiv_iff _ _).mpr injectedSingular

example (j : Fin 4) : columnPattern changedSourceState.channel
    (changedSourceState.activeEquiv (outputCycle j)) = mixedPatterns j := by
  apply Subtype.ext
  have h := columnPattern_transport mixedChannel changedSourceState.channel
    (mixedAdmitted j) (changedSourceState.activeEquiv (outputCycle j)) (Equiv.refl (Fin 2))
    (fun x => changedSourceCoordinates x j)
  rw [mixedPattern] at h
  simpa using h

example (j : Fin 4) : columnValue changedSourceState.channel changedSourceSingular
    (changedSourceState.activeEquiv (outputCycle j)) = (mixedWeights j : ENNReal) :=
  (columnValue_transport mixedChannel changedSourceState.channel mixedSingular changedSourceSingular
    (mixedAdmitted j) (changedSourceState.activeEquiv (outputCycle j)) (Equiv.refl (Fin 2))
    (fun x => changedSourceCoordinates x j)).trans (mixedValue j)

example : occurringPatterns changedSourceState.channel =
    {leftPattern, rightPattern, fullPattern} := by
  rw [occurringPatterns_ofChannelWithEquiv injectedChannel changedSourceEnumeration,
    occurringPatterns_map_injective mixedChannel Fin.castSucc (Fin.castSucc_injective 4),
    mixedOccurrence]

private def changedPatternEquiv :
    OccurringPattern mixedChannel ≃ OccurringPattern changedSourceState.channel :=
  Equiv.subtypeEquivRight fun p => by
    rw [occurringPatterns_ofChannelWithEquiv injectedChannel changedSourceEnumeration,
      occurringPatterns_map_injective mixedChannel Fin.castSucc (Fin.castSucc_injective 4)]

private theorem changedAggregate (p : OccurringPattern mixedChannel) :
    patternAggregate changedSourceState.channel changedSourceSingular (changedPatternEquiv p) =
      patternAggregate mixedChannel mixedSingular p :=
  (patternAggregate_ofChannelWithEquiv injectedChannel changedSourceEnumeration injectedSingular
    changedSourceSingular (injectedOutput p) (changedPatternEquiv p) rfl).trans
      (injectedAggregate p)

example (p : OccurringPattern mixedChannel) :
    (patternAggregate changedSourceState.channel changedSourceSingular
      (changedPatternEquiv p)).toReal = (patternAggregate mixedChannel mixedSingular p).toReal :=
  (patternAggregate_toReal_ofChannelWithEquiv injectedChannel changedSourceEnumeration
    injectedSingular changedSourceSingular (injectedOutput p) (changedPatternEquiv p) rfl).trans
      (patternAggregate_toReal_map_injective mixedChannel Fin.castSucc (Fin.castSucc_injective 4)
        mixedSingular injectedSingular p (injectedOutput p) rfl)

example : compressedPatternData changedSourceState.channel changedSourceSingular = mixedData :=
  (compressedPatternData_ofChannelWithEquiv injectedChannel changedSourceEnumeration
    injectedSingular changedSourceSingular).trans
      (compressedPatternData_map_injective mixedChannel Fin.castSucc (Fin.castSucc_injective 4)
        mixedSingular injectedSingular)

private def changedCompressedEnumeration : OccurringPattern changedSourceState.channel ≃ Fin 3 :=
  changedPatternEquiv.symm.trans (mixedEnumeration.symm.trans compressedCycle)

private abbrev changedCompressedState :=
  patternCompressedState changedSourceState changedSourceSingular changedCompressedEnumeration

private theorem changedCompressedSemantic (x : Fin 2) (p : OccurringPattern mixedChannel) :
    patternCompressedChannel changedSourceState.channel x (changedPatternEquiv p) =
      patternCompressedChannel mixedChannel x p := by
  rw [patternCompressedChannel_eq_ite _ changedSourceSingular,
    patternCompressedChannel_eq_ite _ mixedSingular, changedAggregate]
  rfl

private theorem changedCompressedCoordinates (x : Fin 2) (j : Fin 3) :
    changedCompressedState.channel x (compressedCycle j) = mixedPresented.channel x j := by
  change (patternCompressedState changedSourceState changedSourceSingular
    changedCompressedEnumeration).channel x (compressedCycle j) =
      (patternCompressedState mixedState mixedSingular mixedEnumeration.symm).channel x j
  have h := patternCompressedState_apply changedSourceState changedSourceSingular
    changedCompressedEnumeration x (changedPatternEquiv (mixedEnumeration j))
  have hm := patternCompressedState_apply mixedState mixedSingular mixedEnumeration.symm x
    (mixedEnumeration j)
  simpa only [changedCompressedEnumeration, Equiv.trans_apply, Equiv.symm_apply_apply] using
    h.trans ((changedCompressedSemantic x (mixedEnumeration j)).trans hm.symm)

private def combinedPresentationComparison : OutputEquiv mixedPresented changedCompressedState :=
  OutputEquiv.ofCoordinates compressedCycle changedCompressedCoordinates

example : combinedPresentationComparison.equiv (0 : Fin 3) = (1 : Fin 3) ∧
    combinedPresentationComparison.equiv.symm (0 : Fin 3) = (2 : Fin 3) := ⟨rfl, rfl⟩

example (x : Fin 2) (j : Fin 3) :
    changedCompressedState.channel x (compressedCycle j) =
      ((![![1 / 2, 0, 1 / 2], ![0, 1 / 2, 1 / 2]] x j : NNReal) : ENNReal) := by
  rw [changedCompressedCoordinates]
  have h := patternCompressedState_apply mixedState mixedSingular mixedEnumeration.symm x
    (mixedEnumeration j)
  simpa only [Equiv.symm_apply_apply] using h.trans (mixedCompressedCoordinates x j)

example (x : Fin 2) : (mixedPresented.channel x).map compressedCycle =
    changedCompressedState.channel x := combinedPresentationComparison.map_eq x

example (x : Fin 2) (j : Fin 3) :
    realMatrix changedCompressedState.channel x (compressedCycle j) =
      realMatrix mixedPresented.channel x j :=
  congrArg ENNReal.toReal (changedCompressedCoordinates x j)

example (x : Fin 2) (j : Fin 5) :
    (((patternCompressionInverse changedSourceState changedSourceSingular
      changedCompressedEnumeration).endpoint.channel x).map
      (fun k => (changedSourceEnumeration.symm ((patternCompressionInverse changedSourceState
        changedSourceSingular changedCompressedEnumeration).outputEquiv.equiv k)).val)) j =
      injectedChannel x j :=
  patternCompressionInverse_ambient_apply injectedChannel changedSourceEnumeration
    changedSourceSingular changedCompressedEnumeration x j

/-! ## S04 R13: prior-free perfectness at the actual valid-data boundary -/

example {α β : Type*} [Fintype α] [Nonempty α] [Finite β]
    (κ : α → PMF β) (hκ : IsSingularChannel κ) :
    IsPerfectlyRepresentableChannel κ ↔
      IsPerfectlyRepresentableChannel (compressedPatternData κ hκ).channel :=
  isPerfectlyRepresentableChannel_iff_compressedPatternData κ hκ

example : IsPerfectlyRepresentableChannel injectedChannel ↔
    IsPerfectlyRepresentableChannel mixedData.channel := by
  rw [isPerfectlyRepresentableChannel_iff_compressedPatternData injectedChannel injectedSingular,
    compressedPatternData_map_injective mixedChannel Fin.castSucc (Fin.castSucc_injective 4)
      mixedSingular injectedSingular]

end
end PerfectFunctionalRepresentations
