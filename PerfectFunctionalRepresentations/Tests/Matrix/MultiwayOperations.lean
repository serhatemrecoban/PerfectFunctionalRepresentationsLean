import PerfectFunctionalRepresentations.Matrix.MultiwayOperations
import PerfectFunctionalRepresentations.Matrix.Reachability
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum

/-!
# C10 finite PPS consumers

R07-R09 use independently specified PMFs to test exact selected and family
coordinates, surviving labels, numeric bridges and directed transport.
-/

namespace PerfectFunctionalRepresentations.MatrixOperations

open ActiveFiniteChannel
open scoped BigOperators ENNReal

noncomputable section

private abbrev source : ActiveFiniteChannel Bool where
  outputCard := 2
  outputCard_pos := by decide
  channel := fun x => PMF.pure (if x then 1 else 0)
  output_active y := by
    fin_cases y
    · exact ⟨false, by simp⟩
    · exact ⟨true, by simp⟩

private theorem source_singular : IsSingularChannel source.channel := by
  intro x z y hx hz
  cases x <;> cases z <;> fin_cases y <;> simp_all [source]

private abbrev familySize (j : Fin 2) : Nat := if j = 0 then 2 else 3

private def familyWeights (j : Fin 2) : Fin (familySize j) → NNReal :=
  if j = 0 then fun i => if i.val = 0 then 1 / 4 else 3 / 4
  else fun i => if i.val = 0 then 1 / 6 else if i.val = 1 then 1 / 3 else 1 / 2

private theorem familyWeights_pos (j : Fin 2) (i : Fin (familySize j)) :
    0 < familyWeights j i := by
  fin_cases j <;> fin_cases i <;> norm_num [familySize, familyWeights]

private theorem familyWeights_sum (j : Fin 2) : ∑ i, familyWeights j i = 1 := by
  fin_cases j
  · change (∑ i : Fin 2, if i.val = 0 then (1 / 4 : NNReal) else 3 / 4) = 1
    norm_num [Fin.sum_univ_succ]
  · change (∑ i : Fin 3, if i.val = 0 then (1 / 6 : NNReal)
      else if i.val = 1 then 1 / 3 else 1 / 2) = 1
    norm_num [Fin.sum_univ_succ]

private abbrev family := multiPpsFamily source source_singular
  familyWeights familyWeights_pos familyWeights_sum

private def familyTargetWeights (x : Bool) : Fin 5 → NNReal :=
  if x then ![0, 0, 1 / 6, 1 / 3, 1 / 2] else ![1 / 4, 3 / 4, 0, 0, 0]

private theorem familyTarget_sum (x : Bool) : ∑ i, familyTargetWeights x i = 1 := by
  cases x <;> norm_num [familyTargetWeights, Fin.sum_univ_succ]

private abbrev familyTarget : ActiveFiniteChannel Bool where
  outputCard := 5
  outputCard_pos := by decide
  channel := fun x => PMF.ofFintype (fun i => (familyTargetWeights x i : ENNReal))
    (by exact_mod_cast familyTarget_sum x)
  output_active i := by
    fin_cases i
    · exact ⟨false, by norm_num [familyTargetWeights]⟩
    · exact ⟨false, by norm_num [familyTargetWeights]⟩
    · exact ⟨true, by norm_num [familyTargetWeights]⟩
    · exact ⟨true, by norm_num [familyTargetWeights]⟩
    · exact ⟨true, by norm_num [familyTargetWeights]⟩

private def familyTargetLabels : (Σ j : Fin 2, Fin (familySize j)) ≃ Fin 5 where
  toFun p := ⟨if p.1 = 0 then p.2.val else 2 + p.2.val, by
    rcases p with ⟨j, i⟩
    fin_cases j <;> fin_cases i <;> decide⟩
  invFun k := ![⟨0, 0⟩, ⟨0, 1⟩, ⟨1, 0⟩, ⟨1, 1⟩, ⟨1, 2⟩] k
  left_inv p := by
    rcases p with ⟨j, i⟩
    fin_cases j <;> fin_cases i <;> rfl
  right_inv k := by fin_cases k <;> rfl

private theorem familyTarget_coordinates (x : Bool) (p : Σ j, Fin (familySize j)) :
    familyTarget.channel x (familyTargetLabels p) =
      (familyWeights p.1 p.2 : ENNReal) * source.channel x p.1 := by
  rcases p with ⟨j, i⟩
  cases x <;> fin_cases j <;> fin_cases i <;>
    norm_num [familyTarget, familyTargetWeights, familyTargetLabels, familyWeights,
      familySize, source]

-- Early external family consumer: all witness accessors and a separate target.
example : family.path.Homogeneous .pps := family.homogeneous

example : family.endpoint.outputCard = 5 := by
  rw [family.outputCard]
  exact Fintype.card_congr familyTargetLabels |>.trans (Fintype.card_fin 5)

example : IsSingularChannel family.endpoint.channel := family.isSingular source_singular

private def familyComparison : OutputEquiv family.endpoint familyTarget :=
  family.outputEquiv familyTargetLabels familyTarget_coordinates

private def familyCascade : Cascade source familyTarget :=
  family.cascade familyTargetLabels familyTarget_coordinates

example (x : Bool) : (family.endpoint.channel x).map familyComparison.equiv =
    familyTarget.channel x := familyComparison.map_eq x

example (x : Bool) (p : Σ j, Fin (familySize j)) :
    family.endpoint.channel x (family.labels p) =
      (familyTargetWeights x (familyTargetLabels p) : ENNReal) :=
  (family.coordinates x p).trans (familyTarget_coordinates x p).symm

-- R09: synthesize again after a nontrivial change of input coordinates.
private def inputFlip : Bool ≃ Bool where
  toFun := Bool.not
  invFun := Bool.not
  left_inv := Bool.not_not
  right_inv := Bool.not_not

private abbrev inputSource : ActiveFiniteChannel Bool where
  outputCard := source.outputCard
  outputCard_pos := source.outputCard_pos
  channel := fun x => source.channel (!x)
  output_active y := by
    obtain ⟨x, hx⟩ := source.output_active y
    exact ⟨!x, by simpa only [Bool.not_not] using hx⟩

private theorem inputSource_singular : IsSingularChannel inputSource.channel := by
  intro x z y hx hz
  exact source_singular (!x) (!z) y hx hz

private abbrev inputTarget : ActiveFiniteChannel Bool where
  outputCard := familyTarget.outputCard
  outputCard_pos := familyTarget.outputCard_pos
  channel := fun x => familyTarget.channel (!x)
  output_active y := by
    obtain ⟨x, hx⟩ := familyTarget.output_active y
    exact ⟨!x, by simpa only [Bool.not_not] using hx⟩

-- Both direct active boundaries agree with C06's input relabeling convention.
example : relabelChannel source.channel inputFlip (Equiv.refl _) = inputSource.channel := by
  funext x
  exact PMF.map_id _

example : relabelChannel familyTarget.channel inputFlip (Equiv.refl _) = inputTarget.channel := by
  funext x
  exact PMF.map_id _

private abbrev inputFamily := multiPpsFamily inputSource inputSource_singular
  familyWeights familyWeights_pos familyWeights_sum

private theorem inputTarget_coordinates (x : Bool) (p : Σ j, Fin (familySize j)) :
    inputTarget.channel x (familyTargetLabels p) =
      (familyWeights p.1 p.2 : ENNReal) * inputSource.channel x p.1 :=
  familyTarget_coordinates (!x) p

private def inputComparison : OutputEquiv inputFamily.endpoint inputTarget :=
  inputFamily.outputEquiv familyTargetLabels inputTarget_coordinates

example (x : Bool) : (inputFamily.endpoint.channel x).map inputComparison.equiv =
    inputTarget.channel x := inputComparison.map_eq x

example (x : Bool) (p : Σ j, Fin (familySize j)) :
    inputFamily.endpoint.channel x (inputFamily.labels p) =
      familyTarget.channel (!x) (familyTargetLabels p) :=
  (inputFamily.coordinates x p).trans (inputTarget_coordinates x p).symm

-- The swap moves positive masses between distinguishable rows.
example : inputFamily.endpoint.channel false (inputFamily.labels ⟨1, 0⟩) =
      ((1 / 6 : NNReal) : ENNReal) ∧
    inputFamily.endpoint.channel true (inputFamily.labels ⟨1, 0⟩) = 0 ∧
    inputFamily.endpoint.channel false (inputFamily.labels ⟨0, 0⟩) = 0 ∧
    inputFamily.endpoint.channel true (inputFamily.labels ⟨0, 0⟩) =
      ((1 / 4 : NNReal) : ENNReal) := by
  norm_num [inputFamily.coordinates, inputSource, source, familyWeights, familySize]

example : familyTarget.channel false 2 = 0 ∧
    inputTarget.channel false 2 = ((1 / 6 : NNReal) : ENNReal) := by
  constructor
  · change familyTarget.channel false (familyTargetLabels ⟨1, 0⟩) = 0
    rw [familyTarget_coordinates]
    norm_num [source]
  · change familyTarget.channel true (familyTargetLabels ⟨1, 0⟩) = _
    rw [familyTarget_coordinates]
    norm_num [source, familyWeights, familySize]

-- At a fixed input type, C08 also transports the actual witnessed path.
private def sourceOutputSwap : OutputEquiv source inputSource :=
  OutputEquiv.ofCoordinates (Equiv.swap (0 : Fin 2) 1) (by
    intro x y
    cases x <;> fin_cases y <;> norm_num [source, inputSource])

private def transportedFamily := family.path.transport sourceOutputSwap

example : transportedFamily.path.tags = family.path.tags := transportedFamily.tags_eq

example : transportedFamily.path.Homogeneous .pps :=
  (family.path.transport_homogeneous sourceOutputSwap .pps).mpr family.homogeneous

private def transportedComparison : OutputEquiv transportedFamily.endpoint familyTarget :=
  transportedFamily.outputEquiv.trans
    (family.outputEquiv familyTargetLabels familyTarget_coordinates)

example (x : Bool) : (transportedFamily.endpoint.channel x).map transportedComparison.equiv =
    familyTarget.channel x := transportedComparison.map_eq x

private def selectedWeights : Fin 3 → NNReal := ![1 / 6, 1 / 3, 1 / 2]

private theorem selectedWeights_pos (i : Fin 3) : 0 < selectedWeights i := by
  fin_cases i <;> norm_num [selectedWeights]

private theorem selectedWeights_sum : ∑ i, selectedWeights i = 1 := by
  norm_num [selectedWeights, Fin.sum_univ_succ]

private abbrev selected := multiPps source source_singular 1
  selectedWeights selectedWeights_pos selectedWeights_sum

private def selectedTargetWeights (x : Bool) : Fin 4 → NNReal :=
  if x then ![1 / 6, 1 / 3, 1 / 2, 0] else ![0, 0, 0, 1]

private theorem selectedTarget_sum (x : Bool) : ∑ i, selectedTargetWeights x i = 1 := by
  cases x <;> norm_num [selectedTargetWeights, Fin.sum_univ_succ]

private abbrev selectedTarget : ActiveFiniteChannel Bool where
  outputCard := 4
  outputCard_pos := by decide
  channel := fun x => PMF.ofFintype (fun i => (selectedTargetWeights x i : ENNReal))
    (by exact_mod_cast selectedTarget_sum x)
  output_active i := by
    fin_cases i
    · exact ⟨true, by norm_num [selectedTargetWeights]⟩
    · exact ⟨true, by norm_num [selectedTargetWeights]⟩
    · exact ⟨true, by norm_num [selectedTargetWeights]⟩
    · exact ⟨false, by norm_num [selectedTargetWeights]⟩

private def selectedTargetLabels : Fin 3 ⊕ {j : Fin 2 // j ≠ 1} ≃ Fin 4 where
  toFun := Sum.elim Fin.castSucc (fun _ => (3 : Fin 4))
  invFun k := (![.inl 0, .inl 1, .inl 2, .inr ⟨0, by decide⟩] :
    Fin 4 → Fin 3 ⊕ {j : Fin 2 // j ≠ 1}) k
  left_inv p := by
    rcases p with i | ⟨j, hj⟩
    · fin_cases i <;> rfl
    · fin_cases j
      · rfl
      · exact (hj rfl).elim
  right_inv k := by fin_cases k <;> rfl

private theorem selectedTarget_coordinates (x : Bool)
    (p : Fin 3 ⊕ {j : Fin 2 // j ≠ 1}) :
    selectedTarget.channel x (selectedTargetLabels p) =
      Sum.elim (fun i => (selectedWeights i : ENNReal) * source.channel x 1)
        (fun j => source.channel x j.val) p := by
  rcases p with i | ⟨j, hj⟩
  · cases x <;> fin_cases i <;>
      norm_num [selectedTarget, selectedTargetLabels, selectedTargetWeights,
        selectedWeights, source]
  · fin_cases j
    · cases x <;>
        norm_num [selectedTarget, selectedTargetLabels, selectedTargetWeights, source] <;> rfl
    · exact (hj rfl).elim

private def selectedComparison : OutputEquiv selected.endpoint selectedTarget :=
  selected.outputEquiv selectedTargetLabels selectedTarget_coordinates

-- R07: every nonuniform child, the null row, and the unaffected column.
example (x : Bool) (p : Fin 3 ⊕ {j : Fin 2 // j ≠ 1}) :
    selected.endpoint.channel x (selected.labels p) =
      (selectedTargetWeights x (selectedTargetLabels p) : ENNReal) :=
  (selected.coordinates x p).trans (selectedTarget_coordinates x p).symm

example : selected.endpoint.channel true (selected.labels (.inl 0)) =
      ((1 / 6 : NNReal) : ENNReal) ∧
    selected.endpoint.channel true (selected.labels (.inl 1)) =
      ((1 / 3 : NNReal) : ENNReal) ∧
    selected.endpoint.channel true (selected.labels (.inl 2)) =
      ((1 / 2 : NNReal) : ENNReal) ∧
    selected.endpoint.channel false (selected.labels (.inr ⟨0, by decide⟩)) = 1 := by
  simp [selected.coordinates, selectedWeights, source]

example (i : Fin 3) : selected.endpoint.channel false (selected.labels (.inl i)) = 0 := by
  simp [selected.coordinates, source]

example : selected.endpoint.outputCard = 4 ∧ selected.path.length = 2 := by
  constructor
  · simpa using multiPps_outputCard source source_singular 1
      selectedWeights selectedWeights_pos selectedWeights_sum
  · simpa using multiPps_length source source_singular 1
      selectedWeights selectedWeights_pos selectedWeights_sum

private theorem source_value (j : Fin 2) :
    columnValue source.channel source_singular (source.activeEquiv j) = 1 := by
  fin_cases j
  · rw [columnValue_eq_of_ne_zero _ _ _ (x := false) (by
      change (PMF.pure (0 : Fin 2)) 0 ≠ 0; simp)]
    change (PMF.pure (0 : Fin 2)) 0 = 1
    simp
  · rw [columnValue_eq_of_ne_zero _ _ _ (x := true) (by
      change (PMF.pure (1 : Fin 2)) 1 ≠ 0; simp)]
    change (PMF.pure (1 : Fin 2)) 1 = 1
    simp

example (i : Fin 3) :
    columnValue selected.endpoint.channel (selected.isSingular source_singular)
      (selected.endpoint.activeEquiv (selected.labels (.inl i))) =
      (selectedWeights i : ENNReal) := by
  rw [multiPps_columnValue, source_value, mul_one]

example (i : Fin 3) :
    (columnPattern selected.endpoint.channel
      (selected.endpoint.activeEquiv (selected.labels (.inl i)))).val = {true} := by
  rw [multiPps_columnPattern]
  ext x
  rw [mem_columnPattern]
  change source.channel x 1 ≠ 0 ↔ x ∈ ({true} : Finset Bool)
  cases x <;> simp [source]

example : columnValue selected.endpoint.channel (selected.isSingular source_singular)
      (selected.endpoint.activeEquiv (selected.labels (.inr ⟨0, by decide⟩))) = 1 ∧
    (columnPattern selected.endpoint.channel
      (selected.endpoint.activeEquiv (selected.labels (.inr ⟨0, by decide⟩)))).val = {false} := by
  constructor
  · rw [multiPps_columnValue_keep, source_value]
  · rw [multiPps_columnPattern_keep]
    ext x
    rw [mem_columnPattern]
    change source.channel x 0 ≠ 0 ↔ x ∈ ({false} : Finset Bool)
    cases x <;> simp [source]

-- R08: the chosen singleton witness itself contains no primitive split.
private abbrev singleton := multiPps source source_singular 1
  (fun _ : Unit => (1 : NNReal)) (fun _ => by norm_num) (by simp)

example : singleton.path.length = 0 := multiPps_length_singleton _ _ _ _ _ _

example (x : Bool) : singleton.endpoint.channel x (singleton.labels (.inl ())) =
    source.channel x 1 ∧
    singleton.endpoint.channel x (singleton.labels (.inr ⟨0, by decide⟩)) =
      source.channel x 0 := by
  simp [singleton.coordinates]

attribute [local instance] Classical.propDecidable

private def interspersed (i : Fin 5) : NNReal :=
  if i = 1 then 1 / 6 else if i = 3 then 1 / 3 else if i = 4 then 1 / 2 else 0

private theorem interspersed_sum : ∑ i, interspersed i = 1 := by
  norm_num [Fin.sum_univ_succ, interspersed, Fin.ext_iff, -Fin.val_eq_zero_iff]

example : Nonempty {i // 0 < interspersed i} :=
  positiveWeights_nonempty interspersed interspersed_sum

example : ∑ i : {i // 0 < interspersed i}, interspersed i.val = 1 :=
  positiveWeights_sum interspersed interspersed_sum

private theorem positive_members (i : Fin 5) :
    0 < interspersed i ↔ i = 1 ∨ i = 3 ∨ i = 4 := by
  fin_cases i <;> norm_num [interspersed, Fin.ext_iff, -Fin.val_eq_zero_iff]

private def positiveLabels : {i // 0 < interspersed i} ≃ Fin 3 where
  toFun i := if i.val = 1 then 0 else if i.val = 3 then 1 else 2
  invFun k := (![⟨1, by norm_num [interspersed, Fin.ext_iff]⟩,
    ⟨3, by norm_num [interspersed, Fin.ext_iff]⟩,
    ⟨4, by norm_num [interspersed, Fin.ext_iff]⟩] :
    Fin 3 → {i // 0 < interspersed i}) k
  left_inv i := by
    rcases i with ⟨i, hi⟩
    rcases (positive_members i).mp hi with rfl | rfl | rfl <;> rfl
  right_inv k := by fin_cases k <;> rfl

example : (0 : Fin 5) ∉ Set.range
      (Subtype.val : {i // 0 < interspersed i} → Fin 5) ∧
    (2 : Fin 5) ∉ Set.range
      (Subtype.val : {i // 0 < interspersed i} → Fin 5) := by
  constructor <;> rintro ⟨⟨i, hi⟩, rfl⟩ <;>
    norm_num [interspersed, Fin.ext_iff, -Fin.val_eq_zero_iff] at hi

private def positivePMF : PMF {i // 0 < interspersed i} :=
  PMF.ofFintype (fun i => (interspersed i.val : ENNReal)) (by
    rw [← ENNReal.ofNNReal_finsetSum, positiveWeights_sum interspersed interspersed_sum]
    rfl)

example : positivePMF.map Subtype.val (0 : Fin 5) = 0 ∧
    positivePMF.map Subtype.val (1 : Fin 5) = ((1 / 6 : NNReal) : ENNReal) ∧
    positivePMF.map Subtype.val (2 : Fin 5) = 0 ∧
    positivePMF.map Subtype.val (3 : Fin 5) = ((1 / 3 : NNReal) : ENNReal) ∧
    positivePMF.map Subtype.val (4 : Fin 5) = ((1 / 2 : NNReal) : ENNReal) := by
  simp only [positiveWeights_map interspersed positivePMF (fun _ => rfl)]
  norm_num [interspersed, Fin.ext_iff, -Fin.val_eq_zero_iff]

private abbrev nonnegative := multiPpsOfNonnegative source source_singular 1
  interspersed interspersed_sum

private def nonnegativeTargetLabels :=
  (Equiv.sumCongr positiveLabels (Equiv.refl {j : Fin 2 // j ≠ 1})).trans selectedTargetLabels

private theorem nonnegativeTarget_coordinates (x : Bool)
    (p : {i // 0 < interspersed i} ⊕ {j : Fin 2 // j ≠ 1}) :
    selectedTarget.channel x (nonnegativeTargetLabels p) =
      Sum.elim (fun i => (interspersed i.val : ENNReal) * source.channel x 1)
        (fun j => source.channel x j.val) p := by
  rcases p with ⟨i, hi⟩ | j
  · rcases (positive_members i).mp hi with rfl | rfl | rfl
    · exact selectedTarget_coordinates x (.inl 0)
    · exact selectedTarget_coordinates x (.inl 1)
    · exact selectedTarget_coordinates x (.inl 2)
  · exact selectedTarget_coordinates x (.inr j)

example : OutputEquiv nonnegative.endpoint selectedTarget :=
  nonnegative.outputEquiv nonnegativeTargetLabels nonnegativeTarget_coordinates

example : nonnegative.endpoint.outputCard = 4 := by
  rw [nonnegative.outputCard, Fintype.card_sum]
  have hc := Fintype.card_congr positiveLabels
  simpa using hc

-- R08: include the actual synthesized endpoint in the original ambient labels.
private theorem nonnegative_ambient_coordinates
    {alpha : Type*} [Finite alpha] [Nonempty alpha]
    (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) {I : Type*} [Fintype I] (weights : I → NNReal)
    (hsum : ∑ i, weights i = 1) (x : alpha)
    (b : I ⊕ {j : Fin S.outputCard // j ≠ l}) :
    let d := multiPpsOfNonnegative S hS l weights hsum
    (((d.endpoint.channel x).map d.labels.symm).map
      (Sum.map (Subtype.val : {i // 0 < weights i} → I) id)) b =
        Sum.elim (fun i => (weights i : ENNReal) * S.channel x l)
          (fun j => S.channel x j.val) b := by
  let d := multiPpsOfNonnegative S hS l weights hsum
  let p := (d.endpoint.channel x).map d.labels.symm
  let f : ({i // 0 < weights i} ⊕ {j : Fin S.outputCard // j ≠ l}) →
      (I ⊕ {j : Fin S.outputCard // j ≠ l}) := Sum.map Subtype.val id
  have hf : Function.Injective f := Subtype.val_injective.sumMap Function.injective_id
  have hcoord (q : {i // 0 < weights i} ⊕ {j : Fin S.outputCard // j ≠ l}) :
      p q = Sum.elim (fun i => (weights i.val : ENNReal) * S.channel x l)
        (fun j => S.channel x j.val) q := by
    simpa only [Equiv.symm_apply_apply] using
      (PMF.map_apply_of_injective (d.endpoint.channel x) d.labels.symm.injective
        (d.labels q)).trans (d.coordinates x q)
  change p.map f b = _
  rcases b with i | j
  · by_cases hi : 0 < weights i
    · exact (PMF.map_apply_of_injective p hf (.inl ⟨i, hi⟩)).trans
        (hcoord (.inl ⟨i, hi⟩))
    · have hout : Sum.inl i ∉ Set.range f := by
        rintro ⟨q, hq⟩
        rcases q with ⟨j, hj⟩ | j
        · have hji : j = i := Sum.inl.inj hq
          exact hi (hji ▸ hj)
        · cases hq
      have hi' : i ∉ Set.range (Subtype.val : {i // 0 < weights i} → I) := by
        rintro ⟨j, rfl⟩
        exact hi j.property
      rw [PMF.map_apply_eq_zero_of_notMem_range p hout,
        Sum.elim_inl, positiveWeights_zero_off_range weights i hi', ENNReal.coe_zero, zero_mul]
  · exact (PMF.map_apply_of_injective p hf (.inr j)).trans (hcoord (.inr j))

private def nonnegativeAmbient (x : Bool) : PMF (Fin 5 ⊕ {j : Fin 2 // j ≠ 1}) :=
  ((nonnegative.endpoint.channel x).map nonnegative.labels.symm).map
    (Sum.map Subtype.val id)

private theorem nonnegativeAmbient_coordinates (x : Bool)
    (b : Fin 5 ⊕ {j : Fin 2 // j ≠ 1}) :
    nonnegativeAmbient x b =
      Sum.elim (fun i => (interspersed i : ENNReal) * source.channel x 1)
        (fun j => source.channel x j.val) b :=
  nonnegative_ambient_coordinates source source_singular 1 interspersed interspersed_sum x b

example (x : Bool) : nonnegativeAmbient x (.inl 0) = 0 ∧
    nonnegativeAmbient x (.inl 2) = 0 := by
  rw [nonnegativeAmbient_coordinates, nonnegativeAmbient_coordinates]
  norm_num [interspersed, Fin.ext_iff, -Fin.val_eq_zero_iff]

example (x : Bool) (j : {j : Fin 2 // j ≠ 1}) :
    nonnegativeAmbient x (.inr j) = source.channel x j.val :=
  nonnegativeAmbient_coordinates x (.inr j)

example : nonnegativeAmbient true (.inl 1) = ((1 / 6 : NNReal) : ENNReal) ∧
    nonnegativeAmbient true (.inl 3) = ((1 / 3 : NNReal) : ENNReal) ∧
    nonnegativeAmbient true (.inl 4) = ((1 / 2 : NNReal) : ENNReal) ∧
    nonnegativeAmbient false (.inr ⟨0, by decide⟩) = 1 := by
  simp only [nonnegativeAmbient_coordinates]
  norm_num [interspersed, source, Fin.ext_iff, -Fin.val_eq_zero_iff]

private def extendedWeights (i : Fin 5) : ENNReal := interspersed i

private theorem extendedWeights_sum : ∑ i, extendedWeights i = 1 := by
  change ∑ i, (interspersed i : ENNReal) = 1
  rw [← ENNReal.ofNNReal_finsetSum, interspersed_sum]
  rfl

private abbrev extended := multiPpsOfENNReal source source_singular 1
  extendedWeights extendedWeights_sum

private def extendedPositiveLabels : {i // 0 < extendedWeights i} ≃
    {i // 0 < interspersed i} :=
  Equiv.subtypeEquivRight (fun _ => ENNReal.coe_pos)

private def extendedTargetLabels :=
  (Equiv.sumCongr extendedPositiveLabels (Equiv.refl {j : Fin 2 // j ≠ 1})).trans
    nonnegativeTargetLabels

private theorem extendedTarget_coordinates (x : Bool)
    (p : {i // 0 < extendedWeights i} ⊕ {j : Fin 2 // j ≠ 1}) :
    selectedTarget.channel x (extendedTargetLabels p) =
      Sum.elim (fun i => extendedWeights i.val * source.channel x 1)
        (fun j => source.channel x j.val) p := by
  rcases p with i | j
  · exact nonnegativeTarget_coordinates x (.inl (extendedPositiveLabels i))
  · exact nonnegativeTarget_coordinates x (.inr j)

example : OutputEquiv extended.endpoint selectedTarget :=
  extended.outputEquiv extendedTargetLabels extendedTarget_coordinates

example (i : Fin 5) : ((extendedWeights i).toNNReal : ENNReal) = extendedWeights i ∧
    ((extendedWeights i).toNNReal = 0 ↔ i = 0 ∨ i = 2) := by
  constructor
  · exact ENNReal.coe_toNNReal (ENNReal.coe_ne_top)
  · change interspersed i = 0 ↔ i = 0 ∨ i = 2
    fin_cases i <;> norm_num [interspersed, Fin.ext_iff, -Fin.val_eq_zero_iff]

example (w : Empty → NNReal) : ¬ ∑ i, w i = 1 := by simp

example {I : Type*} [Fintype I] (w : I → NNReal) (hz : ∀ i, w i = 0) :
    ¬ ∑ i, w i = 1 := by simp [hz]

example (i : Fin 5) (hi : i ∉ Set.range
    (Subtype.val : {i // 0 < interspersed i} → Fin 5)) : interspersed i = 0 :=
  positiveWeights_zero_off_range interspersed i hi

example (w : Empty → ENNReal) : ¬ ∑ i, w i = 1 := by simp

example {I : Type*} [Fintype I] (w : I → ENNReal) (hz : ∀ i, w i = 0) :
    ¬ ∑ i, w i = 1 := by simp [hz]

-- Both family adapters retain every original positive sigma label.
example {alpha : Type*} [Finite alpha] [Nonempty alpha]
    (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    {I : Fin S.outputCard → Type*} [∀ j, Fintype (I j)]
    (w : ∀ j, I j → NNReal) (hs : ∀ j, ∑ i, w j i = 1) :
    let d := multiPpsFamilyOfNonnegative S hS w hs
    d.endpoint.outputCard = Fintype.card (Σ j, {i // 0 < w j i}) ∧
      ∀ x j (i : {i // 0 < w j i}),
        d.endpoint.channel x (d.labels ⟨j, i⟩) = (w j i.val : ENNReal) * S.channel x j := by
  exact ⟨(multiPpsFamilyOfNonnegative S hS w hs).outputCard, fun x j i =>
    (multiPpsFamilyOfNonnegative S hS w hs).coordinates x ⟨j, i⟩⟩

example {alpha : Type*} [Finite alpha] [Nonempty alpha]
    (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    {I : Fin S.outputCard → Type*} [∀ j, Fintype (I j)]
    (w : ∀ j, I j → ENNReal) (hs : ∀ j, ∑ i, w j i = 1) :
    let d := multiPpsFamilyOfENNReal S hS w hs
    d.endpoint.outputCard = Fintype.card (Σ j, {i // 0 < w j i}) ∧
      ∀ x j (i : {i // 0 < w j i}),
        d.endpoint.channel x (d.labels ⟨j, i⟩) = w j i.val * S.channel x j := by
  exact ⟨(multiPpsFamilyOfENNReal S hS w hs).outputCard, fun x j i =>
    (multiPpsFamilyOfENNReal S hS w hs).coordinates x ⟨j, i⟩⟩

-- A later consumer can use the original ENNReal labels and an independent target
-- without a DecidableEq assumption on the input alphabet.
example {alpha : Type*} [Finite alpha] [Nonempty alpha]
    (S T : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    {I : Fin S.outputCard → Type*} [∀ j, Fintype (I j)]
    (w : ∀ j, I j → ENNReal) (hs : ∀ j, ∑ i, w j i = 1)
    (e : (Σ j, {i // 0 < w j i}) ≃ Fin T.outputCard)
    (hT : ∀ x p, T.channel x (e p) = w p.1 p.2.val * S.channel x p.1) :
    Cascade S T := (multiPpsFamilyOfENNReal S hS w hs).cascade e hT

-- R09: an independent alternative enumeration is a genuine five-cycle.
private def cycle : Equiv.Perm (Fin 5) where
  toFun := ![1, 2, 3, 4, 0]
  invFun := ![4, 0, 1, 2, 3]
  left_inv i := by fin_cases i <;> rfl
  right_inv i := by fin_cases i <;> rfl

private def rotatedWeights (x : Bool) : Fin 5 → NNReal :=
  if x then ![1 / 2, 0, 0, 1 / 6, 1 / 3] else ![0, 1 / 4, 3 / 4, 0, 0]

private theorem rotated_sum (x : Bool) : ∑ i, rotatedWeights x i = 1 := by
  cases x <;> norm_num [rotatedWeights, Fin.sum_univ_succ]

private abbrev rotatedTarget : ActiveFiniteChannel Bool where
  outputCard := 5
  outputCard_pos := by decide
  channel := fun x => PMF.ofFintype (fun i => (rotatedWeights x i : ENNReal))
    (by exact_mod_cast rotated_sum x)
  output_active i := by
    fin_cases i
    · exact ⟨true, by norm_num [rotatedWeights]⟩
    · exact ⟨false, by norm_num [rotatedWeights]⟩
    · exact ⟨false, by norm_num [rotatedWeights]⟩
    · exact ⟨true, by norm_num [rotatedWeights]⟩
    · exact ⟨true, by norm_num [rotatedWeights]⟩

private theorem rotated_mass (x : Bool) (k : Fin 5) :
    rotatedTarget.channel x (cycle k) = familyTarget.channel x k := by
  change (rotatedWeights x (cycle k) : ENNReal) = (familyTargetWeights x k : ENNReal)
  apply congrArg (fun v : NNReal => (v : ENNReal))
  cases x <;> fin_cases k <;> rfl

private theorem rotated_coordinates (x : Bool) (p : Σ j, Fin (familySize j)) :
    rotatedTarget.channel x ((familyTargetLabels.trans cycle) p) =
      (familyWeights p.1 p.2 : ENNReal) * source.channel x p.1 := by
  exact (rotated_mass x (familyTargetLabels p)).trans (familyTarget_coordinates x p)

private def rotatedComparison : OutputEquiv family.endpoint rotatedTarget :=
  family.outputEquiv (familyTargetLabels.trans cycle) rotated_coordinates

private def alternativeEnumeration : OutputEquiv familyTarget rotatedTarget :=
  familyComparison.symm.trans rotatedComparison

example (x : Bool) : (familyTarget.channel x).map alternativeEnumeration.equiv =
    rotatedTarget.channel x := alternativeEnumeration.map_eq x

example : cycle 0 = 1 ∧ cycle.symm 0 = 4 ∧
    rotatedTarget.channel false (cycle 0) = ((1 / 4 : NNReal) : ENNReal) ∧
    rotatedTarget.channel false (cycle.symm 0) = 0 := by
  refine ⟨rfl, rfl, ?_, ?_⟩
  · change ((1 / 4 : NNReal) : ENNReal) = ((1 / 4 : NNReal) : ENNReal)
    rfl
  · change ((0 : NNReal) : ENNReal) = 0
    rfl

example (p : Σ j, Fin (familySize j)) :
    rotatedComparison.equiv (family.labels p) = cycle (familyTargetLabels p) := by
  simp [rotatedComparison, LabelledOperationResult.outputEquiv,
    OutputEquiv.ofCoordinates, Equiv.trans_apply]

-- S01 integration uses an actual synthesized path from the all-ones state.
private abbrev seedSplit := multiPps (allOnes Bool) (allOnes_isSingular Bool) (0 : Fin 1)
  selectedWeights selectedWeights_pos selectedWeights_sum

private abbrev seedTarget : ActiveFiniteChannel Bool where
  outputCard := 3
  outputCard_pos := by decide
  channel := fun _ => PMF.ofFintype (fun i => (selectedWeights i : ENNReal))
    (by exact_mod_cast selectedWeights_sum)
  output_active i := ⟨false, ENNReal.coe_ne_zero.mpr (ne_of_gt (selectedWeights_pos i))⟩

private instance seedComplementEmpty : IsEmpty {j : Fin 1 // j ≠ 0} :=
  ⟨fun j => j.property (Subsingleton.elim _ _)⟩

private def seedTargetLabels : Fin 3 ⊕ {j : Fin 1 // j ≠ 0} ≃ Fin 3 :=
  Equiv.sumEmpty _ _

private theorem seedTarget_coordinates (x : Bool) (p : Fin 3 ⊕ {j : Fin 1 // j ≠ 0}) :
    seedTarget.channel x (seedTargetLabels p) =
      Sum.elim (fun i => (selectedWeights i : ENNReal) *
        (allOnes Bool).channel x (0 : Fin 1))
        (fun j => (allOnes Bool).channel x j.val) p := by
  rcases p with i | j
  · change (selectedWeights i : ENNReal) =
      (selectedWeights i : ENNReal) * (PMF.pure (0 : Fin 1)) (0 : Fin 1)
    rw [PMF.pure_apply_self, mul_one]
  · exact isEmptyElim j

private theorem seedReachable : FromAllOnes seedTarget := by
  refine ⟨seedSplit.cascade seedTargetLabels seedTarget_coordinates, ?_⟩
  intro k hk
  exact Or.inl (seedSplit.homogeneous k hk)

example : FromAllOnes seedTarget ∧ ToAllOnes seedTarget ∧
    IsPerfectlyRepresentableChannel seedTarget.channel :=
  ⟨seedReachable, fromAllOnes_iff_toAllOnes.mp seedReachable,
    seedReachable.isPerfectlyRepresentable⟩

end
end PerfectFunctionalRepresentations.MatrixOperations

/-! ## C10-S04: exact multiway vertical partitions -/

namespace PerfectFunctionalRepresentations.MatrixOperations.VpsTests

open ActiveFiniteChannel
noncomputable section

private def tinyRoute : Fin 3 → Fin 2 := ![0, 1, 0]

private abbrev tinySource : ActiveFiniteChannel (Fin 3) where
  outputCard := 2
  outputCard_pos := by decide
  channel x := PMF.pure (tinyRoute x)
  output_active j := by
    fin_cases j
    · exact ⟨0, by simp [tinyRoute]⟩
    · exact ⟨1, by simp [tinyRoute]⟩

private theorem tinySource_singular : IsSingularChannel tinySource.channel := by
  intro x z j hx hz
  simp only [tinySource, PMF.pure_apply] at hx hz ⊢
  split_ifs at hx hz ⊢ <;> simp_all

private def tinyTargetRoute : Fin 3 → Fin 3 := ![1, 2, 0]

private abbrev tinyTarget : ActiveFiniteChannel (Fin 3) where
  outputCard := 3
  outputCard_pos := by decide
  channel x := PMF.pure (tinyTargetRoute x)
  output_active j := by
    fin_cases j
    · exact ⟨2, by simp [tinyTargetRoute]⟩
    · exact ⟨0, by simp [tinyTargetRoute]⟩
    · exact ⟨1, by simp [tinyTargetRoute]⟩

private abbrev tinyCount (j : Fin 2) : Nat := if j = 0 then 2 else 1

private def tinyTargetLabels : (Σ j : Fin 2, Fin (tinyCount j)) ≃ Fin 3 where
  toFun p := ⟨if p.1 = 0 then p.2.val else 2, by
    rcases p with ⟨j, i⟩
    fin_cases j <;> fin_cases i <;> decide⟩
  invFun k := (![⟨0, 0⟩, ⟨0, 1⟩, ⟨1, 0⟩] :
    Fin 3 → Σ j : Fin 2, Fin (tinyCount j)) k
  left_inv p := by
    rcases p with ⟨j, i⟩
    fin_cases j <;> fin_cases i <;> rfl
  right_inv k := by fin_cases k <;> rfl

attribute [local instance] Classical.propDecidable
local instance : DecidableEq (Fin 3) := fun a b => Classical.propDecidable (a = b)
attribute [local simp] Fin.ext_iff

private def tinyBlocks (j : Fin 2) (i : Fin (tinyCount j)) : Finset (Fin 3) :=
  if j = 0 then if i.val = 0 then {2} else {0} else {1}

private theorem tinyBlocks_nonempty (j : Fin 2) (i : Fin (tinyCount j)) :
    (tinyBlocks j i).Nonempty := by
  fin_cases j <;> fin_cases i <;> simp [tinyBlocks, -Fin.val_eq_zero_iff]

private theorem tinyBlocks_disjoint (j : Fin 2) :
    Pairwise (fun i k => Disjoint (tinyBlocks j i) (tinyBlocks j k)) := by
  fin_cases j <;>
    simp [Pairwise, tinyCount, Fin.forall_fin_succ, tinyBlocks,
      Finset.disjoint_left, -Fin.val_eq_zero_iff]

private theorem tinyBlocks_cover (j : Fin 2) (x : Fin 3) :
    x ∈ (columnPattern tinySource.channel (tinySource.activeEquiv j)).val ↔
      ∃ i, x ∈ tinyBlocks j i := by
  rw [mem_columnPattern]
  change (PMF.pure (tinyRoute x)) j ≠ 0 ↔ _
  fin_cases j <;> fin_cases x <;>
    simp [tinyRoute, PMF.pure_apply, tinyCount, Fin.exists_fin_succ, tinyBlocks,
      -Fin.val_eq_zero_iff]

private def tinyPartitions (j : Fin 2) :
    Finpartition (columnPattern tinySource.channel (tinySource.activeEquiv j)).val :=
  partitionOfBlocks _ (tinyBlocks j) (tinyBlocks_nonempty j)
    (tinyBlocks_disjoint j) (tinyBlocks_cover j)

private def tinyPartLabels (j : Fin 2) : Fin (tinyCount j) ≃ (tinyPartitions j).parts :=
  partitionOfBlocksEquiv _ (tinyBlocks j) (tinyBlocks_nonempty j)
    (tinyBlocks_disjoint j) (tinyBlocks_cover j)

private theorem tinyPartLabels_val (j : Fin 2) (i : Fin (tinyCount j)) :
    (tinyPartLabels j i).val = tinyBlocks j i :=
  partitionOfBlocksEquiv_apply_val _ _ _ _ _ i

private def tinyPartTargetLabels : (Σ j, (tinyPartitions j).parts) ≃ Fin 3 :=
  (Equiv.sigmaCongrRight tinyPartLabels).symm.trans tinyTargetLabels

private theorem tinyTarget_coordinates (x : Fin 3) (j : Fin 2) (i : Fin (tinyCount j)) :
    tinyTarget.channel x (tinyTargetLabels ⟨j, i⟩) =
      if x ∈ tinyBlocks j i then tinySource.channel x j else 0 := by
  fin_cases j <;> fin_cases i <;> fin_cases x <;>
    simp [tinyTarget, tinyTargetRoute, tinyTargetLabels, tinySource, tinyRoute,
      tinyCount, tinyBlocks, PMF.pure_apply, -Fin.val_eq_zero_iff]

private theorem tinyTargetPart_coordinates (x : Fin 3) (p : Σ j, (tinyPartitions j).parts) :
    tinyTarget.channel x (tinyPartTargetLabels p) =
      if x ∈ p.2.val then tinySource.channel x p.1 else 0 := by
  rcases p with ⟨j, b⟩
  obtain ⟨i, rfl⟩ := (tinyPartLabels j).surjective b
  rw [tinyPartLabels_val]
  change tinyTarget.channel x
    (tinyTargetLabels ((Equiv.sigmaCongrRight tinyPartLabels).symm
      ((Equiv.sigmaCongrRight tinyPartLabels) ⟨j, i⟩))) =
        if x ∈ tinyBlocks j i then tinySource.channel x j else 0
  rw [Equiv.symm_apply_apply]
  exact tinyTarget_coordinates x j i

-- First external consumer of the generic VPS family, before the larger fixture.
private abbrev tinyFamily := multiVpsFamily tinySource tinySource_singular tinyPartitions

example : tinyFamily.path.Homogeneous .vps := tinyFamily.homogeneous

example : tinyFamily.endpoint.outputCard = 3 := by
  rw [tinyFamily.outputCard]
  exact (Fintype.card_congr tinyPartTargetLabels).trans (Fintype.card_fin 3)

example : IsSingularChannel tinyFamily.endpoint.channel :=
  tinyFamily.isSingular tinySource_singular

private def tinyComparison : OutputEquiv tinyFamily.endpoint tinyTarget :=
  tinyFamily.outputEquiv tinyPartTargetLabels tinyTargetPart_coordinates

private def tinyCascade : Cascade tinySource tinyTarget :=
  tinyFamily.cascade tinyPartTargetLabels tinyTargetPart_coordinates

example (x : Fin 3) : (tinyFamily.endpoint.channel x).map tinyComparison.equiv =
    tinyTarget.channel x := tinyComparison.map_eq x

example (x : Fin 3) (p : Σ j, (tinyPartitions j).parts) :
    tinyFamily.endpoint.channel x (tinyFamily.labels p) =
      tinyTarget.channel x (tinyPartTargetLabels p) :=
  (tinyFamily.coordinates x p).trans (tinyTargetPart_coordinates x p).symm

example : tinyFamily.endpoint.channel 0 (tinyFamily.labels ⟨0, tinyPartLabels 0 0⟩) = 0 ∧
    tinyFamily.endpoint.channel 0 (tinyFamily.labels ⟨0, tinyPartLabels 0 1⟩) = 1 ∧
    tinyFamily.endpoint.channel 1 (tinyFamily.labels ⟨1, tinyPartLabels 1 0⟩) = 1 := by
  simp only [tinyFamily.coordinates]
  change (if (0 : Fin 3) ∈ (tinyPartLabels 0 0).val then _ else 0) = 0 ∧
    (if (0 : Fin 3) ∈ (tinyPartLabels 0 1).val then _ else 0) = 1 ∧
    (if (1 : Fin 3) ∈ (tinyPartLabels 1 0).val then _ else 0) = 1
  rw [tinyPartLabels_val, tinyPartLabels_val, tinyPartLabels_val]
  simp [tinyBlocks, tinyRoute, PMF.pure_apply, -Fin.val_eq_zero_iff]

-- Family coordinates already determine all admitted values and exact patterns.
private theorem family_admitted_data {alpha : Type*} [Fintype alpha] [Nonempty alpha]
    (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (P : ∀ j, Finpartition (columnPattern S.channel (S.activeEquiv j)).val)
    (d : LabelledOperationResult .vps S (Σ j, (P j).parts)
      (fun x p => if x ∈ p.2.val then S.channel x p.1 else 0))
    (j : Fin S.outputCard) (b : (P j).parts) :
    columnValue d.endpoint.channel (d.isSingular hS)
        (d.endpoint.activeEquiv (d.labels ⟨j, b⟩)) =
        columnValue S.channel hS (S.activeEquiv j) ∧
      (columnPattern d.endpoint.channel (d.endpoint.activeEquiv (d.labels ⟨j, b⟩))).val =
        b.val := by
  constructor
  · obtain ⟨x, hx⟩ := (P j).nonempty_of_mem_parts b.property
    have hs : S.channel x j ≠ 0 :=
      (mem_columnPattern S.channel (S.activeEquiv j) x).mp ((P j).le b.property hx)
    have he : d.endpoint.channel x (d.labels ⟨j, b⟩) = S.channel x j := by
      simpa only [if_pos hx] using d.coordinates x ⟨j, b⟩
    have hn : d.endpoint.channel x (d.labels ⟨j, b⟩) ≠ 0 := by rw [he]; exact hs
    rw [columnValue_eq_of_ne_zero _ _ _ hn, columnValue_eq_of_ne_zero _ _ _ hs]
    exact he
  · ext x
    rw [mem_columnPattern]
    change d.endpoint.channel x (d.labels ⟨j, b⟩) ≠ 0 ↔ x ∈ b.val
    rw [d.coordinates]
    by_cases hx : x ∈ b.val
    · have hs : S.channel x j ≠ 0 :=
        (mem_columnPattern S.channel (S.activeEquiv j) x).mp
        ((P j).le b.property hx)
      rw [if_pos hx]
      exact ⟨fun _ => hx, fun _ => hs⟩
    · rw [if_neg hx]
      exact ⟨fun h => (h rfl).elim, fun h => (hx h).elim⟩

example {alpha : Type*} [Fintype alpha] [Nonempty alpha]
    (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (P : ∀ j, Finpartition (columnPattern S.channel (S.activeEquiv j)).val)
    (j : Fin S.outputCard) (b : (P j).parts) :
    let d := multiVpsFamily S hS P
    columnValue d.endpoint.channel (d.isSingular hS)
        (d.endpoint.activeEquiv (d.labels ⟨j, b⟩)) =
        columnValue S.channel hS (S.activeEquiv j) ∧
      (columnPattern d.endpoint.channel (d.endpoint.activeEquiv (d.labels ⟨j, b⟩))).val =
        b.val :=
  family_admitted_data S hS P (multiVpsFamily S hS P) j b

example {alpha : Type*} [Fintype alpha] [Nonempty alpha]
    (S T : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (P : ∀ j, Finpartition (columnPattern S.channel (S.activeEquiv j)).val)
    (e : (Σ j, (P j).parts) ≃ Fin T.outputCard)
    (hT : ∀ x p, T.channel x (e p) = if x ∈ p.2.val then S.channel x p.1 else 0) :
    Cascade S T := (multiVpsFamily S hS P).cascade e hT

end
end PerfectFunctionalRepresentations.MatrixOperations.VpsTests

-- The final source column occupies rows {0, 2, 3, 5, 6, 8}; the other two
-- columns occupy {1, 7} and {4}. Supplied block labels have sizes 3, 1, 2.
namespace PerfectFunctionalRepresentations.MatrixOperations.VpsTests.Main

open ActiveFiniteChannel
open scoped ENNReal
noncomputable section

private def route : Fin 9 → Fin 3 := ![2, 0, 2, 2, 1, 2, 2, 0, 2]

private abbrev source : ActiveFiniteChannel (Fin 9) where
  outputCard := 3
  outputCard_pos := by decide
  channel x := PMF.pure (route x)
  output_active j := by
    fin_cases j
    · exact ⟨1, by norm_num [route, Fin.ext_iff]⟩
    · exact ⟨4, by norm_num [route, Fin.ext_iff]; rfl⟩
    · exact ⟨0, by norm_num [route, Fin.ext_iff]⟩

private theorem source_singular : IsSingularChannel source.channel := by
  intro x z j hx hz
  simp only [source, PMF.pure_apply] at hx hz ⊢
  split_ifs at hx hz ⊢ <;> simp_all

private def targetRoute : Fin 9 → Fin 5 := ![1, 3, 0, 2, 4, 0, 2, 3, 0]

private abbrev target : ActiveFiniteChannel (Fin 9) where
  outputCard := 5
  outputCard_pos := by decide
  channel x := PMF.pure (targetRoute x)
  output_active j := by
    fin_cases j
    · exact ⟨2, by norm_num [targetRoute, Fin.ext_iff]; rfl⟩
    · exact ⟨0, by norm_num [targetRoute, Fin.ext_iff]⟩
    · exact ⟨3, by norm_num [targetRoute, Fin.ext_iff]; rfl⟩
    · exact ⟨1, by norm_num [targetRoute, Fin.ext_iff]⟩
    · exact ⟨4, by norm_num [targetRoute, Fin.ext_iff]; rfl⟩

private def targetLabels : Fin 3 ⊕ {j : Fin 3 // j ≠ 2} ≃ Fin 5 where
  toFun := Sum.elim (Fin.castAdd 2) (fun j => ⟨3 + j.val.val, by
    have hi := j.val.isLt
    have hn : j.val.val ≠ 2 := fun h => j.property (Fin.ext h)
    omega⟩)
  invFun k := (![.inl 0, .inl 1, .inl 2, .inr ⟨0, by decide⟩,
    .inr ⟨1, by decide⟩] : Fin 5 → Fin 3 ⊕ {j : Fin 3 // j ≠ 2}) k
  left_inv p := by
    rcases p with i | ⟨j, hj⟩
    · fin_cases i <;> rfl
    · fin_cases j
      · rfl
      · rfl
      · exact (hj rfl).elim
  right_inv k := by fin_cases k <;> rfl

attribute [local instance] Classical.propDecidable
local instance : DecidableEq (Fin 9) := fun a b => Classical.propDecidable (a = b)
attribute [local simp] Fin.ext_iff

private def blocks (i : Fin 3) : Finset (Fin 9) :=
  if i = 0 then {2, 5, 8} else if i = 1 then {0} else {3, 6}

private theorem blocks_nonempty : ∀ i, (blocks i).Nonempty := by
  simp [Fin.forall_fin_succ, blocks, -Fin.val_eq_zero_iff]

private theorem blocks_disjoint : Pairwise (fun i j => Disjoint (blocks i) (blocks j)) := by
  simp [Pairwise, Fin.forall_fin_succ, blocks, Finset.disjoint_left, -Fin.val_eq_zero_iff]

private theorem blocks_cover (x : Fin 9) :
    x ∈ (columnPattern source.channel (source.activeEquiv 2)).val ↔ ∃ i, x ∈ blocks i := by
  rw [mem_columnPattern]
  change (PMF.pure (route x)) (2 : Fin 3) ≠ 0 ↔ _
  fin_cases x <;>
    simp [route, PMF.pure_apply, Fin.exists_fin_succ, blocks, -Fin.val_eq_zero_iff]

private def partition := partitionOfBlocks
  (columnPattern source.channel (source.activeEquiv 2)).val
  blocks blocks_nonempty blocks_disjoint blocks_cover

private def blockLabels : Fin 3 ≃ partition.parts := partitionOfBlocksEquiv
  (columnPattern source.channel (source.activeEquiv 2)).val
  blocks blocks_nonempty blocks_disjoint blocks_cover

private theorem blockLabels_val (i : Fin 3) : (blockLabels i).val = blocks i :=
  partitionOfBlocksEquiv_apply_val _ _ _ _ _ i

example : (blockLabels 0).val.card = 3 ∧ (blockLabels 1).val.card = 1 ∧
    (blockLabels 2).val.card = 2 := by
  simp [blockLabels_val, blocks, -Fin.val_eq_zero_iff]

private theorem target_child_coordinates (x : Fin 9) (i : Fin 3) :
    target.channel x (targetLabels (.inl i)) =
      if x ∈ (blockLabels i).val then source.channel x 2 else 0 := by
  rw [blockLabels_val]
  fin_cases x <;> fin_cases i <;>
    simp [target, targetRoute, targetLabels, source, route, blocks, PMF.pure_apply,
      -Fin.val_eq_zero_iff]

private theorem target_keep_coordinates (x : Fin 9) (j : {j : Fin 3 // j ≠ 2}) :
    target.channel x (targetLabels (.inr j)) = source.channel x j.val := by
  rcases j with ⟨j, hj⟩
  fin_cases j
  · fin_cases x <;> simp [target, targetRoute, targetLabels, source, route, PMF.pure_apply,
      -Fin.val_eq_zero_iff]
  · fin_cases x <;> simp [target, targetRoute, targetLabels, source, route, PMF.pure_apply,
      -Fin.val_eq_zero_iff]
  · exact (hj rfl).elim

-- The primitive mask boundary is insensitive to a change at a null selected row.
private def maskA (x : Fin 9) : Bool := decide (x ∈ blocks 0)
private def maskB (x : Fin 9) : Bool := maskA x || decide (x = 1)

private theorem maskA_left : ∃ x, source.channel x 2 ≠ 0 ∧ maskA x = true := by
  refine ⟨2, ?_⟩
  simp [source, route, maskA, blocks, PMF.pure_apply, -Fin.val_eq_zero_iff]

private theorem maskA_right : ∃ x, source.channel x 2 ≠ 0 ∧ maskA x = false := by
  refine ⟨0, ?_⟩
  simp [source, route, maskA, blocks, PMF.pure_apply, -Fin.val_eq_zero_iff]

private theorem maskB_left : ∃ x, source.channel x 2 ≠ 0 ∧ maskB x = true := by
  refine ⟨2, ?_⟩
  simp [source, route, maskA, maskB, blocks, PMF.pure_apply, -Fin.val_eq_zero_iff]

private theorem maskB_right : ∃ x, source.channel x 2 ≠ 0 ∧ maskB x = false := by
  refine ⟨0, ?_⟩
  simp [source, route, maskA, maskB, blocks, PMF.pure_apply, -Fin.val_eq_zero_iff]

example : maskA (1 : Fin 9) = false ∧ maskB (1 : Fin 9) = true := by
  simp [maskA, maskB, blocks, -Fin.val_eq_zero_iff]

example : (vps source source_singular 2 maskA maskA_left maskA_right).channel =
    (vps source source_singular 2 maskB maskB_left maskB_right).channel := by
  apply vps_mask_irrelevant
  intro x hx
  fin_cases x <;>
    simp_all [source, route, maskA, maskB, blocks, PMF.pure_apply, -Fin.val_eq_zero_iff]

-- A mask that selects only an ambient null row cannot supply a legal left child.
private def emptySupportMask (x : Fin 9) : Bool := decide (x = 1)

example : ¬ ∃ x, source.channel x 2 ≠ 0 ∧ emptySupportMask x = true := by
  rintro ⟨x, hx, hm⟩
  have hxi : x = 1 := by simpa [emptySupportMask] using hm
  subst x
  simp [source, route, PMF.pure_apply, -Fin.val_eq_zero_iff] at hx

-- R10: the selected final column has three prescribed unequal, noncontiguous pieces.
private def partTargetLabels : partition.parts ⊕ {j : Fin 3 // j ≠ 2} ≃ Fin 5 :=
  (Equiv.sumCongr blockLabels.symm (Equiv.refl _)).trans targetLabels

private theorem targetPart_coordinates (x : Fin 9)
    (p : partition.parts ⊕ {j : Fin 3 // j ≠ 2}) :
    target.channel x (partTargetLabels p) =
      Sum.elim (fun b => if x ∈ b.val then source.channel x 2 else 0)
        (fun j => source.channel x j.val) p := by
  rcases p with b | j
  · obtain ⟨i, rfl⟩ := blockLabels.surjective b
    change target.channel x (targetLabels (.inl (blockLabels.symm (blockLabels i)))) = _
    rw [Equiv.symm_apply_apply]
    exact target_child_coordinates x i
  · exact target_keep_coordinates x j

private abbrev selected := multiVps source source_singular 2 partition

example : selected.path.Homogeneous .vps := selected.homogeneous

example : selected.endpoint.outputCard = 5 := by
  rw [selected.outputCard]
  exact (Fintype.card_congr partTargetLabels).trans (Fintype.card_fin 5)

example : selected.path.length = 2 := by
  rw [multiVps_length]
  have h := Fintype.card_congr blockLabels
  simp only [Fintype.card_fin, Fintype.card_coe] at h
  omega

example : IsSingularChannel selected.endpoint.channel := selected.isSingular source_singular

private def selectedComparison : OutputEquiv selected.endpoint target :=
  selected.outputEquiv partTargetLabels targetPart_coordinates

example : Cascade source target := selected.cascade partTargetLabels targetPart_coordinates

example (x : Fin 9) : (selected.endpoint.channel x).map selectedComparison.equiv =
    target.channel x := selectedComparison.map_eq x

example (x : Fin 9) (p : partition.parts ⊕ {j : Fin 3 // j ≠ 2}) :
    selected.endpoint.channel x (selected.labels p) = target.channel x (partTargetLabels p) :=
  (selected.coordinates x p).trans (targetPart_coordinates x p).symm

example (i : Fin 3) :
    (columnPattern selected.endpoint.channel
      (selected.endpoint.activeEquiv (selected.labels (.inl (blockLabels i))))).val = blocks i :=
  (multiVps_columnPattern source source_singular 2 partition (blockLabels i)).trans
    (blockLabels_val i)

example (i : Fin 3) :
    columnValue selected.endpoint.channel (selected.isSingular source_singular)
      (selected.endpoint.activeEquiv (selected.labels (.inl (blockLabels i)))) = 1 := by
  rw [multiVps_columnValue]
  have h : source.channel 0 (2 : Fin 3) ≠ 0 := by
    simp [source, route, PMF.pure_apply, -Fin.val_eq_zero_iff]
  rw [columnValue_eq_of_ne_zero _ _ _ h]
  change (PMF.pure (route 0)) (2 : Fin 3) = 1
  simp [route, PMF.pure_apply, -Fin.val_eq_zero_iff]

example (j : {j : Fin 3 // j ≠ 2}) :
    columnPattern selected.endpoint.channel
        (selected.endpoint.activeEquiv (selected.labels (.inr j))) =
      columnPattern source.channel (source.activeEquiv j.val) :=
  multiVps_columnPattern_keep source source_singular 2 partition j

example (j : {j : Fin 3 // j ≠ 2}) :
    columnValue selected.endpoint.channel (selected.isSingular source_singular)
        (selected.endpoint.activeEquiv (selected.labels (.inr j))) =
      columnValue source.channel source_singular (source.activeEquiv j.val) :=
  multiVps_columnValue_keep source source_singular 2 partition j

example (i : Fin 3) : selected.endpoint.channel 1
    (selected.labels (.inl (blockLabels i))) = 0 := by
  rw [selected.coordinates]
  change (if (1 : Fin 9) ∈ (blockLabels i).val then _ else 0) = 0
  rw [blockLabels_val]
  fin_cases i <;> simp [blocks, -Fin.val_eq_zero_iff]

-- R11: the chosen generic witness for an indiscrete partition performs no operation.
private def singletonPartition := Finpartition.indiscrete
  (columnPattern source.channel (source.activeEquiv 2)).property.ne_empty

private abbrev singletonSplit := multiVps source source_singular 2 singletonPartition

example : singletonSplit.path.length = 0 := by
  rw [multiVps_length]
  simp [singletonPartition]

example : singletonSplit.endpoint.outputCard = 3 := by
  rw [multiVps_outputCard]
  simp [singletonPartition, source]

example (x : Fin 9) (b : singletonPartition.parts) :
    singletonSplit.endpoint.channel x (singletonSplit.labels (.inl b)) =
      source.channel x 2 := by
  have hb : b.val = (columnPattern source.channel (source.activeEquiv 2)).val := by
    simpa [singletonPartition] using b.property
  rw [singletonSplit.coordinates]
  change (if x ∈ b.val then source.channel x 2 else 0) = _
  rw [hb]
  by_cases hx : source.channel x 2 = 0
  · have hn : x ∉ (columnPattern source.channel (source.activeEquiv 2)).val := by
      intro hm
      exact ((mem_columnPattern source.channel (source.activeEquiv 2) x).mp hm) hx
    rw [if_neg hn, hx]
  · have hm := (mem_columnPattern source.channel (source.activeEquiv 2) x).mpr hx
    rw [if_pos hm]

example (x : Fin 9) (j : {j : Fin 3 // j ≠ 2}) :
    singletonSplit.endpoint.channel x (singletonSplit.labels (.inr j)) =
      source.channel x j.val := singletonSplit.coordinates x (.inr j)

-- R12: one call splits each of three columns into 2, 1, and 3 prescribed parts.
private abbrev familyCount (j : Fin 3) : Nat := if j = 0 then 2 else if j = 1 then 1 else 3

private def familyTargetRoute : Fin 9 → Fin 6 := ![4, 1, 3, 5, 2, 3, 5, 0, 3]

private abbrev familyTarget : ActiveFiniteChannel (Fin 9) where
  outputCard := 6
  outputCard_pos := by decide
  channel x := PMF.pure (familyTargetRoute x)
  output_active j := by
    fin_cases j
    · exact ⟨7, by simp [familyTargetRoute, -Fin.val_eq_zero_iff]⟩
    · exact ⟨1, by simp [familyTargetRoute, -Fin.val_eq_zero_iff]⟩
    · exact ⟨4, by simp [familyTargetRoute, -Fin.val_eq_zero_iff]⟩
    · exact ⟨2, by simp [familyTargetRoute, -Fin.val_eq_zero_iff]⟩
    · exact ⟨0, by simp [familyTargetRoute, -Fin.val_eq_zero_iff]⟩
    · exact ⟨3, by simp [familyTargetRoute, -Fin.val_eq_zero_iff]⟩

private def familyTargetLabels : (Σ j : Fin 3, Fin (familyCount j)) ≃ Fin 6 where
  toFun p := ⟨if p.1 = 0 then p.2.val else if p.1 = 1 then 2 else 3 + p.2.val, by
    rcases p with ⟨j, i⟩
    fin_cases j <;> fin_cases i <;> decide⟩
  invFun k := (![⟨0, 0⟩, ⟨0, 1⟩, ⟨1, 0⟩, ⟨2, 0⟩, ⟨2, 1⟩, ⟨2, 2⟩] :
    Fin 6 → Σ j : Fin 3, Fin (familyCount j)) k
  left_inv p := by
    rcases p with ⟨j, i⟩
    fin_cases j <;> fin_cases i <;> rfl
  right_inv k := by fin_cases k <;> rfl

private def familyBlocks (j : Fin 3) (i : Fin (familyCount j)) : Finset (Fin 9) :=
  if j = 0 then if i.val = 0 then {7} else {1}
  else if j = 1 then {4}
  else if i.val = 0 then {2, 5, 8} else if i.val = 1 then {0} else {3, 6}

private theorem familyBlocks_nonempty (j : Fin 3) (i : Fin (familyCount j)) :
    (familyBlocks j i).Nonempty := by
  fin_cases j <;> fin_cases i <;> simp [familyBlocks, -Fin.val_eq_zero_iff]

private theorem familyBlocks_disjoint (j : Fin 3) :
    Pairwise (fun i k => Disjoint (familyBlocks j i) (familyBlocks j k)) := by
  fin_cases j <;>
    simp [Pairwise, familyCount, Fin.forall_fin_succ, familyBlocks,
      Finset.disjoint_left, -Fin.val_eq_zero_iff]

private theorem familyBlocks_cover (j : Fin 3) (x : Fin 9) :
    x ∈ (columnPattern source.channel (source.activeEquiv j)).val ↔
      ∃ i, x ∈ familyBlocks j i := by
  rw [mem_columnPattern]
  change (PMF.pure (route x)) j ≠ 0 ↔ _
  fin_cases j <;> fin_cases x <;>
    simp [route, PMF.pure_apply, familyCount, Fin.exists_fin_succ, familyBlocks,
      -Fin.val_eq_zero_iff]

private def familyPartitions (j : Fin 3) :
    Finpartition (columnPattern source.channel (source.activeEquiv j)).val :=
  partitionOfBlocks _ (familyBlocks j) (familyBlocks_nonempty j)
    (familyBlocks_disjoint j) (familyBlocks_cover j)

private def familyPartLabels (j : Fin 3) : Fin (familyCount j) ≃ (familyPartitions j).parts :=
  partitionOfBlocksEquiv _ (familyBlocks j) (familyBlocks_nonempty j)
    (familyBlocks_disjoint j) (familyBlocks_cover j)

private theorem familyPartLabels_val (j : Fin 3) (i : Fin (familyCount j)) :
    (familyPartLabels j i).val = familyBlocks j i :=
  partitionOfBlocksEquiv_apply_val _ _ _ _ _ i

private def familyPartTargetLabels : (Σ j, (familyPartitions j).parts) ≃ Fin 6 :=
  (Equiv.sigmaCongrRight familyPartLabels).symm.trans familyTargetLabels

private theorem familyTarget_coordinates (x : Fin 9) (j : Fin 3) (i : Fin (familyCount j)) :
    familyTarget.channel x (familyTargetLabels ⟨j, i⟩) =
      if x ∈ familyBlocks j i then source.channel x j else 0 := by
  fin_cases j <;> fin_cases i <;> fin_cases x <;>
    simp [familyTarget, familyTargetRoute, familyTargetLabels, source, route,
      familyCount, familyBlocks, PMF.pure_apply, -Fin.val_eq_zero_iff]

private theorem familyTargetPart_coordinates (x : Fin 9)
    (p : Σ j, (familyPartitions j).parts) :
    familyTarget.channel x (familyPartTargetLabels p) =
      if x ∈ p.2.val then source.channel x p.1 else 0 := by
  rcases p with ⟨j, b⟩
  obtain ⟨i, rfl⟩ := (familyPartLabels j).surjective b
  rw [familyPartLabels_val]
  change familyTarget.channel x
    (familyTargetLabels ((Equiv.sigmaCongrRight familyPartLabels).symm
      ((Equiv.sigmaCongrRight familyPartLabels) ⟨j, i⟩))) =
        if x ∈ familyBlocks j i then source.channel x j else 0
  rw [Equiv.symm_apply_apply]
  exact familyTarget_coordinates x j i

private abbrev family := multiVpsFamily source source_singular familyPartitions

example : family.path.Homogeneous .vps := family.homogeneous

example : family.endpoint.outputCard = 6 := by
  rw [family.outputCard]
  exact (Fintype.card_congr familyPartTargetLabels).trans (Fintype.card_fin 6)

example : IsSingularChannel family.endpoint.channel := family.isSingular source_singular

example (j : Fin family.endpoint.outputCard) : ∃ x, family.endpoint.channel x j ≠ 0 :=
  family.endpoint.output_active j

private def familyComparison : OutputEquiv family.endpoint familyTarget :=
  family.outputEquiv familyPartTargetLabels familyTargetPart_coordinates

example : Cascade source familyTarget :=
  family.cascade familyPartTargetLabels familyTargetPart_coordinates

example (x : Fin 9) : (family.endpoint.channel x).map familyComparison.equiv =
    familyTarget.channel x := familyComparison.map_eq x

example (x : Fin 9) (p : Σ j, (familyPartitions j).parts) :
    family.endpoint.channel x (family.labels p) =
      familyTarget.channel x (familyPartTargetLabels p) :=
  (family.coordinates x p).trans (familyTargetPart_coordinates x p).symm

example (j : Fin 3) (i : Fin (familyCount j)) :
    (columnPattern family.endpoint.channel
      (family.endpoint.activeEquiv (family.labels ⟨j, familyPartLabels j i⟩))).val =
      familyBlocks j i :=
  (family_admitted_data source source_singular familyPartitions family j
    (familyPartLabels j i)).2.trans (familyPartLabels_val j i)

-- C08 transport uses a genuine three-cycle on distinguishable source columns.
private def sourceCycle : Fin 3 ≃ Fin 3 where
  toFun := ![1, 2, 0]
  invFun := ![2, 0, 1]
  left_inv j := by fin_cases j <;> rfl
  right_inv j := by fin_cases j <;> rfl

private def cycledRoute : Fin 9 → Fin 3 := ![0, 1, 0, 0, 2, 0, 0, 1, 0]

private abbrev cycledSource : ActiveFiniteChannel (Fin 9) where
  outputCard := 3
  outputCard_pos := by decide
  channel x := PMF.pure (cycledRoute x)
  output_active j := by
    fin_cases j
    · exact ⟨0, by simp [cycledRoute, -Fin.val_eq_zero_iff]⟩
    · exact ⟨1, by simp [cycledRoute, -Fin.val_eq_zero_iff]⟩
    · exact ⟨4, by simp [cycledRoute, -Fin.val_eq_zero_iff]⟩

private def sourceOutputCycle : OutputEquiv source cycledSource :=
  OutputEquiv.ofCoordinates sourceCycle (by
    intro x j
    fin_cases x <;> fin_cases j <;>
      simp [source, route, cycledSource, cycledRoute, sourceCycle, PMF.pure_apply,
        -Fin.val_eq_zero_iff])

example : sourceCycle 2 = 0 ∧ sourceCycle.symm 2 = 1 ∧
    cycledSource.channel 0 (sourceCycle 2) = 1 ∧
    cycledSource.channel 0 (sourceCycle.symm 2) = 0 := by
  simp [sourceCycle, cycledSource, cycledRoute, PMF.pure_apply, -Fin.val_eq_zero_iff]

private abbrev transportedFamily := family.path.transport sourceOutputCycle

example : transportedFamily.path.tags = family.path.tags := transportedFamily.tags_eq

example : transportedFamily.path.Homogeneous .vps :=
  (family.path.transport_homogeneous sourceOutputCycle .vps).mpr family.homogeneous

private def transportedComparison : OutputEquiv transportedFamily.endpoint familyTarget :=
  transportedFamily.outputEquiv.trans familyComparison

example (x : Fin 9) : (transportedFamily.endpoint.channel x).map
    transportedComparison.equiv = familyTarget.channel x := transportedComparison.map_eq x

example : Cascade cycledSource familyTarget :=
  ⟨transportedFamily.endpoint, transportedFamily.path, transportedComparison⟩

end
end PerfectFunctionalRepresentations.MatrixOperations.VpsTests.Main

-- S01 integration: all-ones splits into three singleton input blocks.
namespace PerfectFunctionalRepresentations.MatrixOperations.VpsTests.Seed

open ActiveFiniteChannel
noncomputable section

private abbrev identityTarget : ActiveFiniteChannel (Fin 3) where
  outputCard := 3
  outputCard_pos := by decide
  channel x := PMF.pure x
  output_active j := ⟨j, by simp⟩

attribute [local instance] Classical.propDecidable
local instance : DecidableEq (Fin 3) := fun a b => Classical.propDecidable (a = b)

private def blocks (i : Fin 3) : Finset (Fin 3) := {i}

private theorem blocks_nonempty (i : Fin 3) : (blocks i).Nonempty := by
  exact Finset.singleton_nonempty i

private theorem blocks_disjoint : Pairwise (fun i j => Disjoint (blocks i) (blocks j)) := by
  intro i j hij
  apply Finset.disjoint_left.mpr
  intro x hx hy
  exact hij ((Finset.mem_singleton.mp hx).symm.trans (Finset.mem_singleton.mp hy))

private theorem blocks_cover (x : Fin 3) :
    x ∈ (columnPattern (allOnes (Fin 3)).channel ((allOnes (Fin 3)).activeEquiv (0 : Fin 1))).val ↔
      ∃ i, x ∈ blocks i := by
  constructor
  · intro _
    exact ⟨x, Finset.mem_singleton_self x⟩
  · intro _
    rw [mem_columnPattern]
    exact (allOnes_apply (Fin 3) x 0).trans_ne one_ne_zero

private def partition :
    Finpartition (columnPattern (allOnes (Fin 3)).channel
      ((allOnes (Fin 3)).activeEquiv (0 : Fin 1))).val :=
  partitionOfBlocks _ blocks blocks_nonempty blocks_disjoint blocks_cover

private def partLabels : Fin 3 ≃ partition.parts :=
  partitionOfBlocksEquiv _ blocks blocks_nonempty blocks_disjoint blocks_cover

private theorem partLabels_val (i : Fin 3) : (partLabels i).val = blocks i :=
  partitionOfBlocksEquiv_apply_val _ _ _ _ _ i

private theorem partition_card : partition.parts.card = 3 := by
  simpa only [Fintype.card_fin, Fintype.card_coe] using (Fintype.card_congr partLabels).symm

private instance complementEmpty : IsEmpty {j : Fin 1 // j ≠ 0} :=
  ⟨fun j => j.property (Subsingleton.elim _ _)⟩

private def targetLabels : partition.parts ⊕ {j : Fin 1 // j ≠ 0} ≃ Fin 3 :=
  (Equiv.sumEmpty _ _).trans partLabels.symm

private abbrev split :=
  multiVps (allOnes (Fin 3)) (allOnes_isSingular (Fin 3)) (0 : Fin 1) partition

private theorem seed_mass (x : Fin 3) :
    (allOnes (Fin 3)).channel x (0 : Fin 1) = 1 := allOnes_apply (Fin 3) x 0

private theorem target_coordinates (x : Fin 3)
    (p : partition.parts ⊕ {j : Fin 1 // j ≠ 0}) :
    identityTarget.channel x (targetLabels p) =
      Sum.elim (fun b => if x ∈ b.val then (allOnes (Fin 3)).channel x (0 : Fin 1) else 0)
        (fun j => (allOnes (Fin 3)).channel x j.val) p := by
  rcases p with b | j
  · obtain ⟨i, rfl⟩ := partLabels.surjective b
    change identityTarget.channel x (partLabels.symm (partLabels i)) = _
    rw [Equiv.symm_apply_apply]
    simp only [Sum.elim_inl, partLabels_val]
    rw [seed_mass x]
    simp [PMF.pure_apply, blocks, eq_comm]
  · exact isEmptyElim j

private def comparison : OutputEquiv split.endpoint identityTarget :=
  split.outputEquiv targetLabels target_coordinates

example : IsEmpty {j : Fin (allOnes (Fin 3)).outputCard // j ≠ (0 : Fin 1)} := by
  change IsEmpty {j : Fin 1 // j ≠ 0}
  infer_instance

example : split.path.Homogeneous .vps := split.homogeneous

example : split.endpoint.outputCard = 3 := by
  calc
    split.endpoint.outputCard = 1 - 1 + partition.parts.card :=
      multiVps_outputCard (allOnes (Fin 3)) (allOnes_isSingular (Fin 3)) (0 : Fin 1) partition
    _ = 3 := by rw [partition_card]

example : split.path.length = 2 := by
  exact (multiVps_length (allOnes (Fin 3)) (allOnes_isSingular (Fin 3))
    (0 : Fin 1) partition).trans (by rw [partition_card])

example (x : Fin 3) : (split.endpoint.channel x).map comparison.equiv =
    identityTarget.channel x := comparison.map_eq x

example (x i : Fin 3) :
    split.endpoint.channel x (split.labels (.inl (partLabels i))) =
      if x = i then 1 else 0 := by
  rw [split.coordinates]
  change (if x ∈ (partLabels i).val then (allOnes (Fin 3)).channel x (0 : Fin 1) else 0) = _
  rw [seed_mass x]
  simp [partLabels_val, blocks]

private theorem reachable : FromAllOnes identityTarget := by
  refine ⟨split.cascade targetLabels target_coordinates, ?_⟩
  intro k hk
  exact Or.inr (Or.inl (split.homogeneous k hk))

example : FromAllOnes identityTarget ∧ ToAllOnes identityTarget ∧
    IsPerfectlyRepresentableChannel identityTarget.channel :=
  ⟨reachable, fromAllOnes_iff_toAllOnes.mp reachable, reachable.isPerfectlyRepresentable⟩

end
end PerfectFunctionalRepresentations.MatrixOperations.VpsTests.Seed

/-! ## C10-S05: prescribed finite pattern-preserving merges -/

namespace PerfectFunctionalRepresentations.MatrixOperations.PpmTests

open ActiveFiniteChannel
open scoped BigOperators ENNReal
noncomputable section

-- The first family consumer will prescribe fibers {1} and {0, 2}.
-- Both fibers have the same full pattern, but retain distinct labels and masses.
private def tinyWeights : Fin 3 → NNReal := ![1 / 6, 1 / 3, 1 / 2]

private theorem tinyWeights_sum : ∑ j, tinyWeights j = 1 := by
  norm_num [tinyWeights, Fin.sum_univ_succ]

private theorem tinyWeights_pos (j : Fin 3) : 0 < tinyWeights j := by
  fin_cases j <;> norm_num [tinyWeights]

private abbrev tinySource : ActiveFiniteChannel Bool where
  outputCard := 3
  outputCard_pos := by decide
  channel := fun _ => PMF.ofFintype (fun j => (tinyWeights j : ENNReal))
    (by exact_mod_cast tinyWeights_sum)
  output_active j := ⟨false, ENNReal.coe_ne_zero.mpr (ne_of_gt (tinyWeights_pos j))⟩

private theorem tinySource_singular : IsSingularChannel tinySource.channel := by
  intro x z j _ _
  rfl

private theorem tinySource_support (a b : Fin 3) (x : Bool) :
    tinySource.channel x a ≠ 0 ↔ tinySource.channel x b ≠ 0 :=
  iff_of_true (ENNReal.coe_ne_zero.mpr (ne_of_gt (tinyWeights_pos a)))
    (ENNReal.coe_ne_zero.mpr (ne_of_gt (tinyWeights_pos b)))

private def tinyGroup : Fin 3 → Fin 2 := ![1, 0, 1]

private theorem tinyGroup_surjective : Function.Surjective tinyGroup := by
  intro b
  fin_cases b
  · exact ⟨1, rfl⟩
  · exact ⟨0, rfl⟩

private def tinyTargetWeights : Fin 2 → NNReal := ![1 / 3, 2 / 3]

private theorem tinyTargetWeights_sum : ∑ j, tinyTargetWeights j = 1 := by
  norm_num [tinyTargetWeights, Fin.sum_univ_succ]

private abbrev tinyTarget : ActiveFiniteChannel Bool where
  outputCard := 2
  outputCard_pos := by decide
  channel := fun _ => PMF.ofFintype (fun j => (tinyTargetWeights j : ENNReal))
    (by exact_mod_cast tinyTargetWeights_sum)
  output_active j := by
    fin_cases j
    · exact ⟨false, by norm_num [tinyTargetWeights]⟩
    · exact ⟨false, by norm_num [tinyTargetWeights]⟩

attribute [local instance] Classical.propDecidable
local instance : DecidableEq (Fin 2) := fun a b => Classical.propDecidable (a = b)

private theorem tinyTarget_coordinates (x : Bool) (b : Fin 2) :
    tinyTarget.channel x b = ∑ j : Fin 3,
      if tinyGroup j = b then tinySource.channel x j else 0 := by
  have h : tinyTargetWeights b = ∑ j : Fin 3,
      if tinyGroup j = b then tinyWeights j else 0 := by
    fin_cases b <;> norm_num [tinyTargetWeights, tinyWeights, tinyGroup, Fin.sum_univ_succ]
  change (tinyTargetWeights b : ENNReal) = ∑ j : Fin 3,
    if tinyGroup j = b then (tinyWeights j : ENNReal) else 0
  rw [h, ENNReal.ofNNReal_finsetSum]
  apply Finset.sum_congr rfl
  intro j _
  split_ifs <;> rfl

example : tinyTarget.channel false 0 = ((1 / 3 : NNReal) : ENNReal) ∧
    tinyTarget.channel false 1 = ((2 / 3 : NNReal) : ENNReal) := by
  constructor <;> rfl

example (a b : Fin 3) :
    columnPattern tinySource.channel (tinySource.activeEquiv a) =
      columnPattern tinySource.channel (tinySource.activeEquiv b) :=
  (same_support_iff_columnPattern_eq tinySource a b).mp (tinySource_support a b)

-- First actual prescribed-fiber consumer; compile after the public API is importable.
private abbrev tinyFamily := multiPpmFibers tinySource tinySource_singular
  tinyGroup tinyGroup_surjective (fun i j _ => tinySource_support i j)

example : tinyFamily.path.Homogeneous .ppm := tinyFamily.homogeneous

example : tinyFamily.endpoint.outputCard = 2 := by
  simpa only [Fintype.card_fin] using tinyFamily.outputCard

example : IsSingularChannel tinyFamily.endpoint.channel :=
  tinyFamily.isSingular tinySource_singular

example (j : Fin tinyFamily.endpoint.outputCard) :
    ∃ x, tinyFamily.endpoint.channel x j ≠ 0 := tinyFamily.endpoint.output_active j

private def tinyComparison : OutputEquiv tinyFamily.endpoint tinyTarget :=
  tinyFamily.outputEquiv (Equiv.refl _) tinyTarget_coordinates

private def tinyCascade : Cascade tinySource tinyTarget :=
  tinyFamily.cascade (Equiv.refl _) tinyTarget_coordinates

example (x : Bool) : (tinyFamily.endpoint.channel x).map tinyComparison.equiv =
    tinyTarget.channel x := tinyComparison.map_eq x

example (x : Bool) (b : Fin 2) :
    tinyFamily.endpoint.channel x (tinyFamily.labels b) =
      (tinyTargetWeights b : ENNReal) :=
  (tinyFamily.coordinates x b).trans (tinyTarget_coordinates x b).symm

example (b : Fin 2) : tinyComparison.equiv (tinyFamily.labels b) = b := by
  simp [tinyComparison, LabelledOperationResult.outputEquiv,
    OutputEquiv.ofCoordinates]

example : tinyFamily.endpoint.channel false (tinyFamily.labels 0) =
      ((1 / 3 : NNReal) : ENNReal) ∧
    tinyFamily.endpoint.channel false (tinyFamily.labels 1) =
      ((2 / 3 : NNReal) : ENNReal) := by
  constructor
  · exact (tinyFamily.coordinates false 0).trans (tinyTarget_coordinates false 0).symm
  · exact (tinyFamily.coordinates false 1).trans (tinyTarget_coordinates false 1).symm

end
end PerfectFunctionalRepresentations.MatrixOperations.PpmTests

namespace PerfectFunctionalRepresentations.MatrixOperations.PpmTests.Main

open ActiveFiniteChannel
open scoped BigOperators ENNReal
noncomputable section

-- The selected labels 0, 2, 4 have unequal values and support {false}.
-- Complementary label 1 shares that support, while label 3 has support {true}.
private def sourceWeights (x : Bool) : Fin 5 → NNReal :=
  if x then ![0, 0, 0, 1, 0] else ![1 / 12, 1 / 3, 1 / 4, 0, 1 / 3]

private theorem sourceWeights_sum (x : Bool) : ∑ j, sourceWeights x j = 1 := by
  cases x <;> norm_num [sourceWeights, Fin.sum_univ_succ, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail]

private abbrev source : ActiveFiniteChannel Bool where
  outputCard := 5
  outputCard_pos := by decide
  channel x := PMF.ofFintype (fun j => (sourceWeights x j : ENNReal))
    (by exact_mod_cast sourceWeights_sum x)
  output_active j := by
    fin_cases j
    · exact ⟨false, by norm_num [sourceWeights, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail]⟩
    · exact ⟨false, by norm_num [sourceWeights, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail]⟩
    · exact ⟨false, by norm_num [sourceWeights, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail]⟩
    · exact ⟨true, by norm_num [sourceWeights, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail]⟩
    · exact ⟨false, by norm_num [sourceWeights, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail]⟩

private theorem source_singular : IsSingularChannel source.channel := by
  intro x z j hx hz
  cases x <;> cases z <;> fin_cases j <;>
    norm_num [source, sourceWeights, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail] at *

private def chosen : Finset (Fin 5) := {0, 2, 4}

private theorem not_chosen_iff (j : Fin 5) : j ∉ chosen ↔ j = 1 ∨ j = 3 := by
  revert j
  decide

private theorem chosen_nonempty : chosen.Nonempty := by decide

private theorem chosen_support (i : Fin 5) (hi : i ∈ chosen)
    (j : Fin 5) (hj : j ∈ chosen) (x : Bool) :
    source.channel x i ≠ 0 ↔ source.channel x j ≠ 0 := by
  fin_cases i <;> fin_cases j <;> cases x <;>
    norm_num [chosen, source, sourceWeights, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail] at *

private def selectedWeights (x : Bool) : Fin 3 → NNReal :=
  if x then ![0, 0, 1] else ![2 / 3, 1 / 3, 0]

private theorem selectedWeights_sum (x : Bool) : ∑ j, selectedWeights x j = 1 := by
  cases x <;> norm_num [selectedWeights, Fin.sum_univ_succ, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail]

private abbrev selectedTarget : ActiveFiniteChannel Bool where
  outputCard := 3
  outputCard_pos := by decide
  channel x := PMF.ofFintype (fun j => (selectedWeights x j : ENNReal))
    (by exact_mod_cast selectedWeights_sum x)
  output_active j := by
    fin_cases j
    · exact ⟨false, by norm_num [selectedWeights, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail]⟩
    · exact ⟨false, by norm_num [selectedWeights, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail]⟩
    · exact ⟨true, by norm_num [selectedWeights, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail]⟩

private def selectedTargetLabels : Unit ⊕ {j : Fin 5 // j ∉ chosen} ≃ Fin 3 where
  toFun := Sum.elim (fun _ => 0) (fun j => if j.val = 1 then 1 else 2)
  invFun k := (![.inl (), .inr ⟨1, by decide⟩, .inr ⟨3, by decide⟩] :
    Fin 3 → Unit ⊕ {j : Fin 5 // j ∉ chosen}) k
  left_inv p := by
    rcases p with ⟨⟩ | ⟨j, hj⟩
    · rfl
    · rcases (not_chosen_iff j).mp hj with rfl | rfl <;> rfl
  right_inv k := by fin_cases k <;> rfl

private theorem selectedTarget_coordinates (x : Bool)
    (p : Unit ⊕ {j : Fin 5 // j ∉ chosen}) :
    selectedTarget.channel x (selectedTargetLabels p) =
      Sum.elim (fun _ => ∑ j ∈ chosen, source.channel x j)
        (fun j => source.channel x j.val) p := by
  rcases p with ⟨⟩ | ⟨j, hj⟩
  · have h : selectedWeights x 0 = ∑ j ∈ chosen, sourceWeights x j := by
      cases x <;>
        norm_num [selectedWeights, sourceWeights, chosen, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail]
    change (selectedWeights x 0 : ENNReal) = ∑ j ∈ chosen, (sourceWeights x j : ENNReal)
    rw [h, ENNReal.ofNNReal_finsetSum]
  · rcases (not_chosen_iff j).mp hj with rfl | rfl <;> cases x <;> rfl

private abbrev selected := multiPpm source source_singular chosen chosen_nonempty chosen_support

example : selected.path.Homogeneous .ppm := selected.homogeneous

example : selected.endpoint.outputCard = 3 := by
  rw [multiPpm_outputCard]
  norm_num [source, chosen, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail]

example : selected.path.length = 2 := by
  rw [multiPpm_length]
  norm_num [chosen, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail]

example : IsSingularChannel selected.endpoint.channel := selected.isSingular source_singular

example (j : Fin selected.endpoint.outputCard) : ∃ x, selected.endpoint.channel x j ≠ 0 :=
  selected.endpoint.output_active j

private def selectedComparison : OutputEquiv selected.endpoint selectedTarget :=
  selected.outputEquiv selectedTargetLabels selectedTarget_coordinates

example : Cascade source selectedTarget :=
  selected.cascade selectedTargetLabels selectedTarget_coordinates

example (x : Bool) : (selected.endpoint.channel x).map selectedComparison.equiv =
    selectedTarget.channel x := selectedComparison.map_eq x

private theorem selected_coordinates (x : Bool) (p : Unit ⊕ {j : Fin 5 // j ∉ chosen}) :
    selected.endpoint.channel x (selected.labels p) =
      (selectedWeights x (selectedTargetLabels p) : ENNReal) :=
  (selected.coordinates x p).trans (selectedTarget_coordinates x p).symm

example : selected.endpoint.channel false (selected.labels (.inl ())) =
      ((2 / 3 : NNReal) : ENNReal) ∧
    selected.endpoint.channel true (selected.labels (.inl ())) = 0 := by
  constructor <;> exact selected_coordinates _ _

example (j : {j : Fin 5 // j ∉ chosen}) :
    columnValue selected.endpoint.channel (selected.isSingular source_singular)
        (selected.endpoint.activeEquiv (selected.labels (.inr j))) =
      columnValue source.channel source_singular (source.activeEquiv j.val) :=
  multiPpm_columnValue_keep source source_singular chosen chosen_nonempty chosen_support j

example (j : {j : Fin 5 // j ∉ chosen}) :
    columnPattern selected.endpoint.channel
        (selected.endpoint.activeEquiv (selected.labels (.inr j))) =
      columnPattern source.channel (source.activeEquiv j.val) :=
  multiPpm_columnPattern_keep source source_singular chosen chosen_nonempty chosen_support j

private def sourceValues : Fin 5 → NNReal := ![1 / 12, 1 / 3, 1 / 4, 1, 1 / 3]

private theorem source_columnValue (j : Fin 5) :
    columnValue source.channel source_singular (source.activeEquiv j) =
      (sourceValues j : ENNReal) := by
  by_cases hj : j = 3
  · subst j
    have h : source.channel true (3 : Fin 5) ≠ 0 := by
      norm_num [source, sourceWeights, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail]
    exact columnValue_eq_of_ne_zero source.channel source_singular (source.activeEquiv 3) h
  · have h : source.channel false j ≠ 0 := by
      fin_cases j <;> norm_num [source, sourceWeights, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail] at *
    rw [columnValue_eq_of_ne_zero source.channel source_singular (source.activeEquiv j) h]
    change (sourceWeights false j : ENNReal) = (sourceValues j : ENNReal)
    fin_cases j <;> norm_num [sourceWeights, sourceValues, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail] at *

example : columnValue selected.endpoint.channel (selected.isSingular source_singular)
    (selected.endpoint.activeEquiv (selected.labels (.inl ()))) =
      ((2 / 3 : NNReal) : ENNReal) := by
  calc
    _ = ∑ j ∈ chosen, columnValue source.channel source_singular (source.activeEquiv j) :=
      multiPpm_columnValue source source_singular chosen chosen_nonempty chosen_support
    _ = ∑ j ∈ chosen, (sourceValues j : ENNReal) :=
      Finset.sum_congr rfl (fun j _ => source_columnValue j)
    _ = _ := by
      rw [← ENNReal.ofNNReal_finsetSum]
      congr 1
      norm_num [chosen, sourceValues, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_four, Matrix.vecHead, Matrix.vecTail]

example : (columnPattern selected.endpoint.channel
    (selected.endpoint.activeEquiv (selected.labels (.inl ())))).val = {false} := by
  rw [multiPpm_columnPattern source source_singular chosen chosen_nonempty chosen_support
    (0 : Fin 5) (by decide)]
  ext x
  rw [mem_columnPattern]
  change source.channel x (0 : Fin 5) ≠ 0 ↔ x ∈ ({false} : Finset Bool)
  cases x <;> norm_num [source, sourceWeights, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail]

-- R14: a singleton uses the same chosen generic witness, with no merge.
private def singleton : Finset (Fin 5) := {4}

private theorem singleton_support (i : Fin 5) (hi : i ∈ singleton)
    (j : Fin 5) (hj : j ∈ singleton) (x : Bool) :
    source.channel x i ≠ 0 ↔ source.channel x j ≠ 0 := by
  have hi' : i = 4 := by simpa [singleton] using hi
  have hj' : j = 4 := by simpa [singleton] using hj
  subst i
  subst j
  rfl

private abbrev singletonMerge := multiPpm source source_singular singleton
  (by exact Finset.singleton_nonempty 4) singleton_support

example : singletonMerge.path.length = 0 := by
  exact (multiPpm_length source source_singular singleton
    (Finset.singleton_nonempty 4) singleton_support).trans (by simp [singleton])

example : singletonMerge.endpoint.outputCard = 5 := by
  exact (multiPpm_outputCard source source_singular singleton
    (Finset.singleton_nonempty 4) singleton_support).trans (by simp [source, singleton])

example (x : Bool) : singletonMerge.endpoint.channel x (singletonMerge.labels (.inl ())) =
    source.channel x 4 := by
  rw [singletonMerge.coordinates]
  simp [singleton]

example (x : Bool) (j : {j : Fin 5 // j ∉ singleton}) :
    singletonMerge.endpoint.channel x (singletonMerge.labels (.inr j)) =
      source.channel x j.val := singletonMerge.coordinates x (.inr j)

private def emptyMerge : LabelledOperationResult .ppm source (Fin 5)
    (fun x j => source.channel x j) := by
  exact cast (if_neg (Finset.not_nonempty_empty : ¬(∅ : Finset (Fin 5)).Nonempty))
    (multiPpmOrEmpty source source_singular (∅ : Finset (Fin 5)) (by simp))

private theorem emptyMerge_eq : emptyMerge =
    (⟨source, OperationPath.nil, OperationPath.homogeneous_nil _, Equiv.refl _,
      fun _ _ => rfl⟩ :
      LabelledOperationResult .ppm source (Fin 5) (fun x j => source.channel x j)) := by
  have hm {A B : Sort _} (h : A = B) (b : B) : HEq (Eq.mpr h b) b := by
    cases h
    rfl
  apply eq_of_heq
  unfold emptyMerge multiPpmOrEmpty
  simp only [Finset.not_nonempty_empty, ↓reduceDIte]
  exact (cast_heq _ _).trans (hm _ _)

example : emptyMerge.endpoint = source := by rw [emptyMerge_eq]

example : emptyMerge.path.length = 0 := by rw [emptyMerge_eq]; rfl

example (j : Fin 5) : emptyMerge.labels j = j := by rfl

example (x : Bool) (j : Fin 5) :
    emptyMerge.endpoint.channel x (emptyMerge.labels j) = source.channel x j :=
  emptyMerge.coordinates x j

-- R15: prescribed fibers 0 and 1 share a pattern but remain separate.
private def group : Fin 5 → Fin 3 := ![1, 0, 1, 2, 1]

private theorem group_surjective : Function.Surjective group := by
  intro b
  fin_cases b
  · exact ⟨1, rfl⟩
  · exact ⟨0, rfl⟩
  · exact ⟨3, rfl⟩

private theorem group_support (i j : Fin 5) (hij : group i = group j) (x : Bool) :
    source.channel x i ≠ 0 ↔ source.channel x j ≠ 0 := by
  fin_cases i <;> fin_cases j <;> cases x <;>
    norm_num [group, source, sourceWeights, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail] at *

private def familyWeights (x : Bool) : Fin 3 → NNReal :=
  if x then ![0, 0, 1] else ![1 / 3, 2 / 3, 0]

private theorem familyWeights_sum (x : Bool) : ∑ j, familyWeights x j = 1 := by
  cases x <;> norm_num [familyWeights, Fin.sum_univ_succ, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail]

private abbrev familyTarget : ActiveFiniteChannel Bool where
  outputCard := 3
  outputCard_pos := by decide
  channel x := PMF.ofFintype (fun j => (familyWeights x j : ENNReal))
    (by exact_mod_cast familyWeights_sum x)
  output_active j := by
    fin_cases j
    · exact ⟨false, by norm_num [familyWeights, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail]⟩
    · exact ⟨false, by norm_num [familyWeights, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail]⟩
    · exact ⟨true, by norm_num [familyWeights, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail]⟩

attribute [local instance] Classical.propDecidable
local instance : DecidableEq (Fin 3) := fun a b => Classical.propDecidable (a = b)

private theorem familyTarget_coordinates (x : Bool) (b : Fin 3) :
    familyTarget.channel x b =
      ∑ j : Fin 5, if group j = b then source.channel x j else 0 := by
  have h : familyWeights x b =
      ∑ j : Fin 5, if group j = b then sourceWeights x j else 0 := by
    cases x <;> fin_cases b <;>
      norm_num [familyWeights, sourceWeights, group, Fin.sum_univ_succ,
        Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail]
  change (familyWeights x b : ENNReal) =
    ∑ j : Fin 5, if group j = b then (sourceWeights x j : ENNReal) else 0
  rw [h, ENNReal.ofNNReal_finsetSum]
  apply Finset.sum_congr rfl
  intro j _
  split_ifs <;> rfl

private abbrev family := multiPpmFibers source source_singular group group_surjective group_support

example : family.path.Homogeneous .ppm := family.homogeneous

example : family.endpoint.outputCard = 3 := by
  simpa only [Fintype.card_fin] using family.outputCard

example : family.path.length = 2 := by
  rw [multiPpmFibers_length]
  rfl

example : IsSingularChannel family.endpoint.channel := family.isSingular source_singular

private def familyComparison : OutputEquiv family.endpoint familyTarget :=
  family.outputEquiv (Equiv.refl _) familyTarget_coordinates

example : Cascade source familyTarget :=
  family.cascade (Equiv.refl _) familyTarget_coordinates

example (x : Bool) : (family.endpoint.channel x).map familyComparison.equiv =
    familyTarget.channel x := familyComparison.map_eq x

example (x : Bool) (b : Fin 3) : family.endpoint.channel x (family.labels b) =
    (familyWeights x b : ENNReal) :=
  (family.coordinates x b).trans (familyTarget_coordinates x b).symm

example (j : Fin 5) :
    columnPattern family.endpoint.channel (family.endpoint.activeEquiv (family.labels (group j))) =
      columnPattern source.channel (source.activeEquiv j) :=
  multiPpmFibers_columnPattern source source_singular group group_surjective group_support j

example (b : Fin 3) :
    columnValue family.endpoint.channel (family.isSingular source_singular)
      (family.endpoint.activeEquiv (family.labels b)) =
        ((![1 / 3, 2 / 3, 1] : Fin 3 → NNReal) b : ENNReal) := by
  have hv : columnValue family.endpoint.channel (family.isSingular source_singular)
      (family.endpoint.activeEquiv (family.labels b)) =
      ∑ j : Fin 5, if group j = b then (sourceValues j : ENNReal) else 0 := by
    calc
      _ = ∑ j : Fin 5, if group j = b then
          columnValue source.channel source_singular (source.activeEquiv j) else 0 :=
        multiPpmFibers_columnValue source source_singular group group_surjective group_support b
      _ = _ := Finset.sum_congr rfl (fun j _ => by
        split_ifs
        · exact source_columnValue j
        · rfl)
  rw [hv]
  have h : (![1 / 3, 2 / 3, 1] : Fin 3 → NNReal) b =
      ∑ j : Fin 5, if group j = b then sourceValues j else 0 := by
    fin_cases b <;>
      norm_num [sourceValues, group, Fin.sum_univ_succ, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail]
  rw [h, ENNReal.ofNNReal_finsetSum]
  apply Finset.sum_congr rfl
  intro j _
  split_ifs <;> rfl

private def cycle : Fin 5 ≃ Fin 5 where
  toFun := ![1, 2, 3, 4, 0]
  invFun := ![4, 0, 1, 2, 3]
  left_inv j := by fin_cases j <;> rfl
  right_inv j := by fin_cases j <;> rfl

private def cycledWeights (x : Bool) : Fin 5 → NNReal :=
  if x then ![0, 0, 0, 0, 1] else ![1 / 3, 1 / 12, 1 / 3, 1 / 4, 0]

private theorem cycledWeights_sum (x : Bool) : ∑ j, cycledWeights x j = 1 := by
  cases x <;> norm_num [cycledWeights, Fin.sum_univ_succ, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail]

private abbrev cycledSource : ActiveFiniteChannel Bool where
  outputCard := 5
  outputCard_pos := by decide
  channel x := PMF.ofFintype (fun j => (cycledWeights x j : ENNReal))
    (by exact_mod_cast cycledWeights_sum x)
  output_active j := by
    fin_cases j
    · exact ⟨false, by norm_num [cycledWeights, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail]⟩
    · exact ⟨false, by norm_num [cycledWeights, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail]⟩
    · exact ⟨false, by norm_num [cycledWeights, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail]⟩
    · exact ⟨false, by norm_num [cycledWeights, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail]⟩
    · exact ⟨true, by norm_num [cycledWeights, Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.vecHead,
        Matrix.vecTail]⟩

private def sourceCycle : OutputEquiv source cycledSource :=
  OutputEquiv.ofCoordinates cycle (by
    intro x j
    cases x <;> fin_cases j <;> rfl)

example : cycle 0 = 1 ∧ cycle.symm 0 = 4 ∧
    cycledSource.channel false (cycle 0) = ((1 / 12 : NNReal) : ENNReal) ∧
    cycledSource.channel false (cycle.symm 0) = 0 := by
  exact ⟨rfl, rfl, rfl, rfl⟩

private abbrev transported := family.path.transport sourceCycle

example : transported.path.tags = family.path.tags := transported.tags_eq

example : transported.path.Homogeneous .ppm :=
  (family.path.transport_homogeneous sourceCycle .ppm).mpr family.homogeneous

private def transportedComparison : OutputEquiv transported.endpoint familyTarget :=
  transported.outputEquiv.trans familyComparison

example (x : Bool) : (transported.endpoint.channel x).map transportedComparison.equiv =
    familyTarget.channel x := transportedComparison.map_eq x

example : Cascade cycledSource familyTarget :=
  ⟨transported.endpoint, transported.path, transportedComparison⟩

end
end PerfectFunctionalRepresentations.MatrixOperations.PpmTests.Main







namespace PerfectFunctionalRepresentations.MatrixOperations.PpmTests

open ActiveFiniteChannel
open scoped BigOperators ENNReal
noncomputable section

-- R14: all source labels are selected; no complementary output remains.
private abbrev allMerge := multiPpm tinySource tinySource_singular
  (Finset.univ : Finset (Fin 3)) (by simp)
  (fun i _ j _ => tinySource_support i j)

private def allTargetLabels :
    Unit ⊕ {j : Fin 3 // j ∉ (Finset.univ : Finset (Fin 3))} ≃ Fin 1 where
  toFun _ := 0
  invFun _ := .inl ()
  left_inv p := by
    rcases p with ⟨⟩ | ⟨j, hj⟩
    · rfl
    · exact (hj (Finset.mem_univ j)).elim
  right_inv _ := Subsingleton.elim _ _

private theorem tinySource_sum (x : Bool) : ∑ j : Fin 3, tinySource.channel x j = 1 := by
  change ∑ j : Fin 3, (tinyWeights j : ENNReal) = 1
  rw [← ENNReal.ofNNReal_finsetSum, tinyWeights_sum]
  rfl

private theorem allTarget_coordinates (x : Bool)
    (p : Unit ⊕ {j : Fin 3 // j ∉ (Finset.univ : Finset (Fin 3))}) :
    (allOnes Bool).channel x (allTargetLabels p) =
      Sum.elim (fun _ => ∑ j ∈ (Finset.univ : Finset (Fin 3)), tinySource.channel x j)
        (fun j => tinySource.channel x j.val) p := by
  rcases p with ⟨⟩ | ⟨j, hj⟩
  · exact (allOnes_apply Bool x (0 : Fin 1)).trans (tinySource_sum x).symm
  · exact (hj (Finset.mem_univ j)).elim

example : IsEmpty {j : Fin 3 // j ∉ (Finset.univ : Finset (Fin 3))} :=
  ⟨fun j => j.property (Finset.mem_univ j.val)⟩

example : allMerge.endpoint.outputCard = 1 := by
  simpa using multiPpm_outputCard tinySource tinySource_singular
    (Finset.univ : Finset (Fin 3)) (by simp)
    (fun i _ j _ => tinySource_support i j)

example : allMerge.path.length = 2 := by
  simpa using multiPpm_length tinySource tinySource_singular
    (Finset.univ : Finset (Fin 3)) (by simp)
    (fun i _ j _ => tinySource_support i j)

private def allComparison : OutputEquiv allMerge.endpoint (allOnes Bool) :=
  allMerge.outputEquiv allTargetLabels allTarget_coordinates

private def allReduction : Cascade tinySource (allOnes Bool) :=
  allMerge.cascade allTargetLabels allTarget_coordinates

example (x : Bool) : allMerge.endpoint.channel x (allMerge.labels (.inl ())) = 1 :=
  (allMerge.coordinates x (.inl ())).trans (tinySource_sum x)

example (x : Bool) : (allMerge.endpoint.channel x).map allComparison.equiv =
    (allOnes Bool).channel x := allComparison.map_eq x

example : ToAllOnes tinySource ∧ FromAllOnes tinySource ∧
    IsPerfectlyRepresentableChannel tinySource.channel := by
  have ht : ToAllOnes tinySource :=
    ⟨allReduction, fun k hk => Or.inl (allMerge.homogeneous k hk)⟩
  exact ⟨ht, fromAllOnes_iff_toAllOnes.mpr ht, ht.isPerfectlyRepresentable⟩

-- R15: the same unequal three-column source is merged into one prescribed fiber.
private def oneGroup : Fin 3 → Fin 1 := fun _ => 0

private theorem oneGroup_surjective : Function.Surjective oneGroup :=
  fun b => ⟨0, Subsingleton.elim _ b⟩

private abbrev oneFamily := multiPpmFibers tinySource tinySource_singular
  oneGroup oneGroup_surjective (fun i j _ => tinySource_support i j)

local instance : DecidableEq (Fin 1) := fun a b => Classical.propDecidable (a = b)

private theorem oneTarget_coordinates (x : Bool) (b : Fin 1) :
    (allOnes Bool).channel x b =
      ∑ j : Fin 3, if oneGroup j = b then tinySource.channel x j else 0 := by
  simp only [Subsingleton.elim (oneGroup _) b, if_true]
  exact (allOnes_apply Bool x b).trans (tinySource_sum x).symm

example : oneFamily.endpoint.outputCard = 1 := by
  simpa only [Fintype.card_fin] using oneFamily.outputCard

example : oneFamily.path.length = 2 := by
  exact multiPpmFibers_length tinySource tinySource_singular oneGroup
    oneGroup_surjective (fun i j _ => tinySource_support i j)

example : Cascade tinySource (allOnes Bool) :=
  oneFamily.cascade (Equiv.refl _) oneTarget_coordinates

-- A non-surjective ambient map has two empty fibers; inclusion restores their zero masses.
private def ambientGroup : Fin 3 → Fin 4 := ![3, 1, 3]

private def ambientWeights : Fin 4 → NNReal := ![0, 1 / 3, 0, 2 / 3]

private def rangeLabels : Set.range ambientGroup ≃ Fin 2 where
  toFun b := if b.val = 1 then 0 else 1
  invFun i := if i = 0 then ⟨1, ⟨1, rfl⟩⟩ else ⟨3, ⟨0, rfl⟩⟩
  left_inv b := by
    rcases b with ⟨b, hb⟩
    obtain ⟨j, rfl⟩ := hb
    fin_cases j <;> rfl
  right_inv i := by
    fin_cases i <;> norm_num [Fin.ext_iff, -Fin.val_eq_zero_iff]

private abbrev rangeMerge := multiPpmRange tinySource tinySource_singular ambientGroup
  (fun i j _ => tinySource_support i j)

example : rangeMerge.path.Homogeneous .ppm := rangeMerge.homogeneous

example : rangeMerge.endpoint.outputCard = 2 :=
  rangeMerge.outputCard.trans (Fintype.card_congr rangeLabels)

private def rangeAmbient (x : Bool) : PMF (Fin 4) :=
  (rangeMerge.endpoint.channel x).map (fun j => (rangeMerge.labels.symm j).val)

attribute [local instance] Classical.propDecidable
local instance : DecidableEq (Fin 4) := fun a b => Classical.propDecidable (a = b)

private theorem rangeAmbient_coordinates (x : Bool) (b : Fin 4) :
    rangeAmbient x b = (ambientWeights b : ENNReal) := by
  have h : ambientWeights b =
      ∑ j : Fin 3, if ambientGroup j = b then tinyWeights j else 0 := by
    fin_cases b <;>
      norm_num [ambientWeights, ambientGroup, tinyWeights, Fin.sum_univ_succ,
        Fin.ext_iff, -Fin.val_eq_zero_iff]
  have hm := multiPpmRange_map tinySource tinySource_singular ambientGroup
    (fun i j _ => tinySource_support i j) x b
  change rangeAmbient x b =
    ∑ j : Fin 3, if ambientGroup j = b then (tinyWeights j : ENNReal) else 0 at hm
  rw [hm, h, ENNReal.ofNNReal_finsetSum]
  apply Finset.sum_congr rfl
  intro j _
  split_ifs <;> rfl

example (x : Bool) : rangeAmbient x 0 = 0 ∧ rangeAmbient x 2 = 0 ∧
    rangeAmbient x 1 = ((1 / 3 : NNReal) : ENNReal) ∧
    rangeAmbient x 3 = ((2 / 3 : NNReal) : ENNReal) :=
  ⟨rangeAmbient_coordinates x 0, rangeAmbient_coordinates x 2,
    rangeAmbient_coordinates x 1, rangeAmbient_coordinates x 3⟩

-- Ambient labels need neither finiteness nor decidable equality.
example {alpha B : Type*} [Finite alpha] [Nonempty alpha]
    (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (g : Fin S.outputCard → B)
    (hp : ∀ i j, g i = g j → ∀ x, S.channel x i ≠ 0 ↔ S.channel x j ≠ 0)
    (x : alpha) (b : B) :
    ((multiPpmRange S hS g hp).endpoint.channel x).map
      (fun j => ((multiPpmRange S hS g hp).labels.symm j).val) b =
      ∑ j, if g j = b then S.channel x j else 0 :=
  multiPpmRange_map S hS g hp x b

end
end PerfectFunctionalRepresentations.MatrixOperations.PpmTests



