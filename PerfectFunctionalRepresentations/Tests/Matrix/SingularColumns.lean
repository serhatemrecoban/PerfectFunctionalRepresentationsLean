import PerfectFunctionalRepresentations.Matrix.SingularColumns
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum

/-!
# Admitted singular-column data regressions

C06 S04 checks R05/R12-R14 and the data portions of R06/R10/R11. Values and
patterns are consumed only at admitted labels. The private normalized family
allows repeated support patterns with distinct values; the three-cycle and
ambient-extension consumers retain actual channels and explicit column labels.
The manuscript's existing Example 1 fixture remains allocated to S05.
-/

namespace PerfectFunctionalRepresentations

open scoped BigOperators ENNReal

universe u v u' v'

/-! ## Generic contracts do not require default labels or explicit decidable equality -/

section Generic

attribute [local instance] Classical.propDecidable

variable {alpha : Type u} {beta : Type v}

example (kappa : alpha → PMF beta) (h : IsSingularChannel kappa)
    (y : activeOutputs kappa) :
    0 < columnValue kappa h y ∧ columnValue kappa h y ≤ 1 ∧
      columnValue kappa h y ≠ ∞ ∧
      0 < (columnValue kappa h y).toReal ∧ (columnValue kappa h y).toReal ≤ 1 ∧
      ENNReal.ofReal (columnValue kappa h y).toReal = columnValue kappa h y :=
  ⟨columnValue_pos _ _ _, columnValue_le_one _ _ _, columnValue_ne_top _ _ _,
    columnValue_toReal_pos _ _ _, columnValue_toReal_le_one _ _ _,
    ofReal_columnValue_toReal _ _ _⟩

example [Fintype alpha] (kappa : alpha → PMF beta) (h : IsSingularChannel kappa)
    (y : activeOutputs kappa) (x : alpha) :
    (x ∈ (columnPattern kappa y).val ↔ kappa x y.val ≠ 0) ∧
    kappa x y.val = (if x ∈ (columnPattern kappa y).val then columnValue kappa h y else 0) ∧
    (kappa x y.val).toReal =
      (if x ∈ (columnPattern kappa y).val then (columnValue kappa h y).toReal else 0) ∧
    (kappa x y.val).toReal / (columnValue kappa h y).toReal =
      (if x ∈ (columnPattern kappa y).val then 1 else 0) :=
  ⟨mem_columnPattern _ _ _, column_eq_ite _ _ _ _, column_toReal_eq_ite _ _ _ _,
    column_div_value _ _ _ _⟩

example [Fintype alpha] (kappa : alpha → PMF beta) (h : IsSingularChannel kappa)
    (y : activeOutputs kappa) (x : alpha) :
    decide (x ∈ (columnPattern kappa y).val) = decide (kappa x y.val ≠ 0) ∧
    realMatrix kappa x y.val / (columnValue kappa h y).toReal =
      cond (decide (x ∈ (columnPattern kappa y).val)) (1 : ℝ) 0 :=
  ⟨columnPattern_decide_mem _ _ _, column_div_value_eq_bool _ _ _ _⟩

example [Fintype alpha] (kappa : alpha → PMF beta) (h : IsSingularChannel kappa)
    (y : activeOutputs kappa) (t : Finset alpha) (ht : t.Nonempty)
    (w : ℝ≥0∞) (hw : 0 < w)
    (hdata : ∀ x, kappa x y.val = if x ∈ t then w else 0) :
    t = (columnPattern kappa y).val ∧ w = columnValue kappa h y :=
  columnData_unique _ _ _ _ ht _ hw hdata

example [Fintype alpha] (kappa : alpha → PMF beta) (h : IsSingularChannel kappa)
    (y : activeOutputs kappa) (t : Finset alpha) (ht : t.Nonempty)
    (w : ℝ) (hw : 0 < w)
    (hdata : ∀ x, (kappa x y.val).toReal = if x ∈ t then w else 0) :
    t = (columnPattern kappa y).val ∧ w = (columnValue kappa h y).toReal :=
  columnData_toReal_unique _ _ _ _ ht _ hw hdata

example [Fintype alpha] [Fintype beta] (kappa : alpha → PMF beta)
    (h : IsSingularChannel kappa) (ha : ∀ y, y ∈ activeOutputs kappa) (x : alpha) :
    (∑ y, (if x ∈ (columnPattern kappa ⟨y, ha y⟩).val
      then columnValue kappa h ⟨y, ha y⟩ else 0)) = 1 ∧
    (∑ y, (if x ∈ (columnPattern kappa ⟨y, ha y⟩).val
      then (columnValue kappa h ⟨y, ha y⟩).toReal else 0)) = 1 :=
  ⟨columnValue_row_sum _ _ _ _, columnValue_toReal_row_sum _ _ _ _⟩

example [Fintype alpha] [Fintype beta] (kappa : alpha → PMF beta)
    (h : IsSingularChannel kappa) (ha : ∀ y, y ∈ activeOutputs kappa) :
    channelOfColumnData (fun y => columnPattern kappa ⟨y, ha y⟩)
      (fun y => columnValue kappa h ⟨y, ha y⟩) (columnValue_row_sum kappa h ha) = kappa :=
  channelOfColumnData_reconstruct _ _ _

example [Fintype alpha] [Fintype beta] (kappa : alpha → PMF beta)
    (h : IsSingularChannel kappa) (ha : ∀ y, y ∈ activeOutputs kappa) :
    channelOfRealMatrix
      (Matrix.of fun x y => if x ∈ (columnPattern kappa ⟨y, ha y⟩).val
        then (columnValue kappa h ⟨y, ha y⟩).toReal else 0)
      (fun x y => by
        change 0 ≤ if x ∈ (columnPattern kappa ⟨y, ha y⟩).val
          then (columnValue kappa h ⟨y, ha y⟩).toReal else 0
        split_ifs
        · exact le_of_lt (columnValue_toReal_pos kappa h ⟨y, ha y⟩)
        · exact le_rfl)
      (columnValue_toReal_row_sum kappa h ha) = kappa :=
  channelOfRealColumnData_reconstruct _ _ _

-- Extensionality does not require finite output labels or distinct column patterns.
example [Fintype alpha] (kappa eta : alpha → PMF beta)
    (h : IsSingularChannel kappa) (h' : IsSingularChannel eta)
    (ha : ∀ y, y ∈ activeOutputs kappa) (hb : ∀ y, y ∈ activeOutputs eta)
    (hs : ∀ y, columnPattern kappa ⟨y, ha y⟩ = columnPattern eta ⟨y, hb y⟩)
    (hv : ∀ y, columnValue kappa h ⟨y, ha y⟩ = columnValue eta h' ⟨y, hb y⟩) :
    kappa = eta := channel_eq_of_columnData _ _ _ _ _ _ hs hv

example {alpha' : Type u'} {beta' : Type v'} [Fintype alpha] [Fintype alpha']
    (kappa : alpha → PMF beta) (eta : alpha' → PMF beta')
    (h : IsSingularChannel kappa) (h' : IsSingularChannel eta)
    (y : activeOutputs kappa) (z : activeOutputs eta) (e : alpha ≃ alpha')
    (hcoord : ∀ x, eta (e x) z.val = kappa x y.val) :
    columnValue eta h' z = columnValue kappa h y ∧
      (columnPattern eta z).val = (columnPattern kappa y).val.map e.toEmbedding :=
  ⟨columnValue_transport _ _ _ _ _ _ _ hcoord,
    columnPattern_transport _ _ _ _ _ hcoord⟩

end Generic

section Family

attribute [local instance] Classical.propDecidable

variable {alpha : Type u} {beta : Type v} [Fintype beta]
variable (s : beta → {t : Finset alpha // t.Nonempty}) (v : beta → ℝ≥0∞)
variable (hrow : ∀ x, ∑ y, (if x ∈ (s y).val then v y else 0) = 1)

-- Bounds and finiteness are conclusions, not supplied constructor premises.
example (y : beta) : v y ≤ 1 ∧ v y ≠ ∞ :=
  ⟨columnData_value_le_one s v hrow y, columnData_value_ne_top s v hrow y⟩

example [Nonempty alpha] : Nonempty beta := columnData_nonempty_output s v hrow

example (x : alpha) : ∑ y, (if x ∈ (s y).val then (v y).toReal else 0) = 1 :=
  columnData_toReal_row_sum s v hrow x

example (hv : ∀ y, 0 < v y) :
    IsSingularChannel (channelOfColumnData s v hrow) ∧
      ∀ y, y ∈ activeOutputs (channelOfColumnData s v hrow) :=
  ⟨isSingularChannel_channelOfColumnData s v hrow,
    channelOfColumnData_active s v hrow hv⟩

example (hv : ∀ y, 0 < v y) (y : beta) :
    columnValue (channelOfColumnData s v hrow)
      (isSingularChannel_channelOfColumnData s v hrow)
      ⟨y, channelOfColumnData_active s v hrow hv y⟩ = v y :=
  columnValue_channelOfColumnData s v hrow hv y

example [Fintype alpha] (hv : ∀ y, 0 < v y) (y : beta) :
    columnPattern (channelOfColumnData s v hrow)
      ⟨y, channelOfColumnData_active s v hrow hv y⟩ = s y :=
  columnPattern_channelOfColumnData s v hrow hv y

end Family

/-! ## R12-R14: normalized data with repeated patterns and unequal values -/

private def splitPattern (j : Fin 3) : Finset (Fin 3) :=
  if j.val = 0 then {0} else {1, 2}

private noncomputable def splitValue (j : Fin 3) : ℝ≥0∞ :=
  if j.val = 0 then 1 else if j.val = 1 then 1 / 3 else 2 / 3

private theorem splitPattern_nonempty (j : Fin 3) : (splitPattern j).Nonempty := by
  fin_cases j <;> simp [splitPattern]

private def splitPatterns (j : Fin 3) : {s : Finset (Fin 3) // s.Nonempty} :=
  ⟨splitPattern j, splitPattern_nonempty j⟩

private theorem splitValue_pos (j : Fin 3) : 0 < splitValue j := by
  fin_cases j <;> norm_num [splitValue]

private theorem thirds_sum : (1 : ℝ≥0∞) / 3 + 2 / 3 = 1 := by
  rw [ENNReal.div_add_div_same]
  norm_num
  exact ENNReal.div_self (by norm_num) (by simp)

private theorem splitRowsConcrete (x : Fin 3) :
    ∑ j, (if x ∈ (splitPatterns j).val then splitValue j else 0) = 1 := by
  rw [Fin.sum_univ_succ, Fin.sum_univ_succ, Fin.sum_univ_succ]
  fin_cases x
  · change (1 : ℝ≥0∞) + (0 + (0 + 0)) = 1
    simp
  · change (0 : ℝ≥0∞) + (1 / 3 + (2 / 3 + 0)) = 1
    simpa only [zero_add, add_zero] using thirds_sum
  · change (0 : ℝ≥0∞) + (1 / 3 + (2 / 3 + 0)) = 1
    simpa only [zero_add, add_zero] using thirds_sum

section

attribute [local instance] Classical.propDecidable
noncomputable local instance : DecidableEq (Fin 3) := fun a b => Classical.propDecidable (a = b)

-- Match the constructor's internal classical membership decision without changing its data.
private theorem splitRows (x : Fin 3) :
    ∑ j, (if x ∈ (splitPatterns j).val then splitValue j else 0) = 1 := by
  apply Eq.trans ?_ (splitRowsConcrete x)
  apply Finset.sum_congr rfl
  intro j _
  by_cases hx : x ∈ (splitPatterns j).val <;> simp only [hx, if_true, if_false]

end

private noncomputable abbrev splitChannel : Fin 3 → PMF (Fin 3) :=
  channelOfColumnData splitPatterns splitValue splitRows

private theorem splitSingular : IsSingularChannel splitChannel :=
  isSingularChannel_channelOfColumnData _ _ _

private abbrev splitAdmitted (j : Fin 3) : activeOutputs splitChannel :=
  ⟨j, channelOfColumnData_active _ _ _ splitValue_pos j⟩

private theorem splitData (j : Fin 3) :
    (columnPattern splitChannel (splitAdmitted j)).val = splitPattern j ∧
      columnValue splitChannel splitSingular (splitAdmitted j) = splitValue j := by
  have h := columnData_unique splitChannel splitSingular (splitAdmitted j)
    (splitPattern j) (splitPattern_nonempty j) (splitValue j) (splitValue_pos j)
    (fun x => channelOfColumnData_apply splitPatterns splitValue splitRows x j)
  exact ⟨h.1.symm, h.2.symm⟩

example : columnValue splitChannel splitSingular (splitAdmitted 0) = 1 ∧
    (columnPattern splitChannel (splitAdmitted 0)).val = {0} ∧
    columnValue splitChannel splitSingular (splitAdmitted 1) = 1 / 3 ∧
    (columnPattern splitChannel (splitAdmitted 1)).val = {1, 2} :=
  ⟨(splitData 0).2, (splitData 0).1, (splitData 1).2, (splitData 1).1⟩

example : massMatrix splitChannel 0 1 = 0 ∧ massMatrix splitChannel 1 1 = 1 / 3 ∧
    realMatrix splitChannel 1 1 = 1 / 3 := by
  have h0 : (0 : Fin 3) ∉ (splitPatterns 1).val := by decide
  have h1 : (1 : Fin 3) ∈ (splitPatterns 1).val := by decide
  have hmass : splitChannel 1 1 = 1 / 3 := by
    rw [channelOfColumnData_apply, if_pos h1]
    rfl
  refine ⟨?_, hmass, ?_⟩
  · change splitChannel 0 1 = 0
    rw [channelOfColumnData_apply, if_neg h0]
  · change (splitChannel 1 1).toReal = 1 / 3
    rw [hmass]
    norm_num [ENNReal.toReal_div]

example : (splitChannel 0 1).toReal /
      (columnValue splitChannel splitSingular (splitAdmitted 1)).toReal = 0 ∧
    (splitChannel 1 1).toReal /
      (columnValue splitChannel splitSingular (splitAdmitted 1)).toReal = 1 := by
  change realMatrix splitChannel 0 (splitAdmitted 1).val /
      (columnValue splitChannel splitSingular (splitAdmitted 1)).toReal = 0 ∧
    realMatrix splitChannel 1 (splitAdmitted 1).val /
      (columnValue splitChannel splitSingular (splitAdmitted 1)).toReal = 1
  rw [column_div_value, column_div_value, (splitData 1).1]
  have hn : (0 : Fin 3) ∉ splitPattern 1 := by decide
  have hy : (1 : Fin 3) ∈ splitPattern 1 := by decide
  simp only [hn, hy, if_false, if_true, and_self]

-- Equal patterns do not identify columns or force their values to coincide.
example : splitPatterns 1 = splitPatterns 2 ∧ splitValue 1 ≠ splitValue 2 := by
  refine ⟨rfl, ?_⟩
  intro h
  have hr := congrArg ENNReal.toReal h
  norm_num [splitValue, ENNReal.toReal_div] at hr

example : (columnPattern splitChannel (splitAdmitted 1)).val =
      (columnPattern splitChannel (splitAdmitted 2)).val ∧
    columnValue splitChannel splitSingular (splitAdmitted 1) ≠
      columnValue splitChannel splitSingular (splitAdmitted 2) := by
  rw [(splitData 1).1, (splitData 2).1, (splitData 1).2, (splitData 2).2]
  refine ⟨rfl, ?_⟩
  intro h
  have hr := congrArg ENNReal.toReal h
  norm_num [splitValue, ENNReal.toReal_div] at hr

-- Only weighted row sums normalize; the sum of all column values can exceed one.
example : ∑ j, splitValue j = 2 := by
  rw [Fin.sum_univ_succ, Fin.sum_univ_succ, Fin.sum_univ_succ]
  change (1 : ℝ≥0∞) + (1 / 3 + (2 / 3 + 0)) = 2
  rw [add_zero, thirds_sum]
  norm_num

/-! ## R05 and access boundaries -/

private noncomputable def oneChannel (alpha : Type u) (_ : alpha) : PMF (Fin 1) :=
  PMF.pure 0

private theorem oneSingular (alpha : Type u) : IsSingularChannel (oneChannel alpha) := by
  intro x1 x2 y _ _
  rfl

private abbrev oneAdmitted (alpha : Type u) [Nonempty alpha] : activeOutputs (oneChannel alpha) :=
  ⟨0, ⟨Classical.choice (inferInstance : Nonempty alpha), by simp [oneChannel]⟩⟩

example {alpha : Type u} [Fintype alpha] [Nonempty alpha] :
    columnValue (oneChannel alpha) (oneSingular alpha) (oneAdmitted alpha) = 1 ∧
      (columnPattern (oneChannel alpha) (oneAdmitted alpha)).val = Finset.univ := by
  constructor
  · rw [columnValue_eq_of_ne_zero _ _ _
      (show oneChannel alpha (Classical.choice (inferInstance : Nonempty alpha)) 0 ≠ 0 by
        simp [oneChannel])]
    simp [oneChannel]
  · ext x
    simp [mem_columnPattern, oneChannel, oneAdmitted]

example : (columnPattern (oneChannel Unit) (oneAdmitted Unit)).val = {()} := by
  ext x
  simp [mem_columnPattern, oneChannel, oneAdmitted]

private noncomputable def unusedChannel (_ : Fin 3) : PMF (Fin 2) := PMF.pure 0

example : (1 : Fin 2) ∉ activeOutputs unusedChannel := by
  rintro ⟨x, hx⟩
  simp [unusedChannel] at hx

-- Even a finite normalized ambient matrix excludes its zero column from this domain.
example : ¬ ∃ y : activeOutputs unusedChannel, y.val = 1 := by
  rintro ⟨y, hy⟩
  obtain ⟨x, hx⟩ := y.property
  rw [hy] at hx
  simp [unusedChannel] at hx

-- These checks reject a plain ambient label and omission of the singularity premise.
example : True := by
  fail_if_success
    have _ := columnPattern unusedChannel (1 : Fin 2)
  fail_if_success
    have _ : ℝ≥0∞ := columnValue splitChannel (splitAdmitted 0)
  trivial

private noncomputable def nonsingularReal : Matrix (Fin 2) (Fin 2) ℝ :=
  Matrix.of fun x y => if x.val = 0 then (if y.val = 0 then 1 else 0) else 1 / 2

private theorem nonsingularReal_nonneg (x y : Fin 2) : 0 ≤ nonsingularReal x y := by
  fin_cases x <;> fin_cases y <;> norm_num [nonsingularReal]

private theorem nonsingularReal_sum (x : Fin 2) : ∑ y, nonsingularReal x y = 1 := by
  fin_cases x <;> norm_num [nonsingularReal, Fin.sum_univ_succ]

private noncomputable abbrev nonsingularChannel : Fin 2 → PMF (Fin 2) :=
  channelOfRealMatrix nonsingularReal nonsingularReal_nonneg nonsingularReal_sum

private theorem nonsingular_entry (x y : Fin 2) :
    nonsingularChannel x y = ENNReal.ofReal (nonsingularReal x y) :=
  channelOfRealMatrix_apply _ _ _ x y

example : (∀ y, y ∈ activeOutputs nonsingularChannel) ∧
    ¬ IsSingularChannel nonsingularChannel := by
  constructor
  · intro y
    refine ⟨1, ?_⟩
    rw [PMF.mem_support_iff, nonsingular_entry]
    fin_cases y <;> norm_num [nonsingularReal]
  · intro h
    have heq := h 0 1 0 (by rw [nonsingular_entry]; norm_num [nonsingularReal])
      (by rw [nonsingular_entry]; norm_num [nonsingularReal])
    have hr := congrArg ENNReal.toReal heq
    rw [nonsingular_entry, nonsingular_entry] at hr
    norm_num [nonsingularReal] at hr

-- Positive nonempty column data still need normalized rows.
example : ¬ (∀ x : Fin 1, ∑ _y : Fin 1,
    (if x ∈ ({0} : Finset (Fin 1)) then (2 : ℝ≥0∞) else 0) = 1) := by
  intro h
  have hx := h 0
  norm_num [Fin.sum_univ_succ] at hx

example (s : Fin 0 → {t : Finset (Fin 1) // t.Nonempty}) (v : Fin 0 → ℝ≥0∞) :
    ¬ (∀ x, ∑ y, (if x ∈ (s y).val then v y else 0) = 1) := by
  intro h
  have hx := h 0
  simp at hx

/-! ## R10: input and output permutations are tested separately -/

private def cycleThree : Fin 3 ≃ Fin 3 := (Equiv.swap 0 1).trans (Equiv.swap 1 2)

example : ({0} : Finset (Fin 3)).map cycleThree.toEmbedding = {2} := by
  rw [Finset.map_singleton]
  rfl

example : ({1, 2} : Finset (Fin 3)).map cycleThree.toEmbedding = {0, 1} := by
  decide

private noncomputable abbrev inputChannel : Fin 3 → PMF (Fin 3) :=
  relabelChannel splitChannel cycleThree (Equiv.refl _)

private theorem inputSingular : IsSingularChannel inputChannel :=
  (isSingularChannel_relabelChannel_iff _ _ _).2 splitSingular

private abbrev inputAdmitted (j : Fin 3) : activeOutputs inputChannel :=
  ⟨j, by
    obtain ⟨x, hx⟩ := (splitAdmitted j).property
    refine ⟨cycleThree x, ?_⟩
    rw [PMF.mem_support_iff]
    have he : inputChannel (cycleThree x) j = splitChannel x j :=
      relabelChannel_apply _ _ _ x j
    rw [he]
    simpa only [PMF.mem_support_iff] using hx⟩

private theorem inputData (j : Fin 3) :
    (columnPattern inputChannel (inputAdmitted j)).val =
        (splitPattern j).map cycleThree.toEmbedding ∧
      columnValue inputChannel inputSingular (inputAdmitted j) = splitValue j := by
  have hc (x : Fin 3) : inputChannel (cycleThree x) j = splitChannel x j :=
    relabelChannel_apply _ _ _ x j
  have hp := columnPattern_transport splitChannel inputChannel
    (splitAdmitted j) (inputAdmitted j) cycleThree hc
  have hv := columnValue_transport splitChannel inputChannel splitSingular inputSingular
    (splitAdmitted j) (inputAdmitted j) cycleThree hc
  rw [(splitData j).1] at hp
  exact ⟨hp, hv.trans (splitData j).2⟩

-- Forward input transport sends support {0} to {2}, not to the inverse image {1}.
example : (columnPattern inputChannel (inputAdmitted 0)).val = {2} ∧
    2 ∈ (columnPattern inputChannel (inputAdmitted 0)).val ∧
    1 ∉ (columnPattern inputChannel (inputAdmitted 0)).val ∧
    columnValue inputChannel inputSingular (inputAdmitted 0) = 1 := by
  rw [(inputData 0).1, (inputData 0).2]
  change ({0} : Finset (Fin 3)).map cycleThree.toEmbedding = {2} ∧
    2 ∈ ({0} : Finset (Fin 3)).map cycleThree.toEmbedding ∧
    1 ∉ ({0} : Finset (Fin 3)).map cycleThree.toEmbedding ∧ (1 : ℝ≥0∞) = 1
  exact ⟨by decide, by decide, by decide, rfl⟩

example : (columnPattern inputChannel (inputAdmitted 1)).val = {0, 1} := by
  rw [(inputData 1).1]
  decide

example : massMatrix inputChannel 2 0 = 1 ∧ realMatrix inputChannel 2 0 = 1 ∧
    realMatrix inputChannel 1 0 = 0 := by
  have hp : (columnPattern inputChannel (inputAdmitted 0)).val = {2} := by
    rw [(inputData 0).1]
    decide
  have hv : columnValue inputChannel inputSingular (inputAdmitted 0) = 1 := (inputData 0).2
  have hn : (1 : Fin 3) ∉ ({2} : Finset (Fin 3)) := by decide
  refine ⟨?_, ?_, ?_⟩
  · change inputChannel 2 0 = 1
    simpa only [hp, hv, Finset.mem_singleton, if_true] using
      column_eq_ite inputChannel inputSingular (inputAdmitted 0) 2
  · change (inputChannel 2 0).toReal = 1
    simpa only [hp, hv, Finset.mem_singleton, if_true, ENNReal.toReal_one] using
      column_toReal_eq_ite inputChannel inputSingular (inputAdmitted 0) 2
  · change (inputChannel 1 0).toReal = 0
    simpa only [hp, hn, if_false] using
      column_toReal_eq_ite inputChannel inputSingular (inputAdmitted 0) 1

private noncomputable abbrev outputChannel : Fin 3 → PMF (Fin 3) :=
  relabelChannel splitChannel (Equiv.refl _) cycleThree

private theorem outputSingular : IsSingularChannel outputChannel :=
  (isSingularChannel_relabelChannel_iff _ _ _).2 splitSingular

private abbrev outputAdmitted (j : Fin 3) : activeOutputs outputChannel :=
  ⟨cycleThree j, by
    obtain ⟨x, hx⟩ := (splitAdmitted j).property
    refine ⟨x, ?_⟩
    rw [PMF.mem_support_iff]
    have he : outputChannel x (cycleThree j) = splitChannel x j :=
      relabelChannel_apply _ _ _ x j
    rw [he]
    simpa only [PMF.mem_support_iff] using hx⟩

private theorem outputData (j : Fin 3) :
    (columnPattern outputChannel (outputAdmitted j)).val = splitPattern j ∧
      columnValue outputChannel outputSingular (outputAdmitted j) = splitValue j := by
  have hc (x : Fin 3) : outputChannel x (cycleThree j) = splitChannel x j :=
    relabelChannel_apply _ _ _ x j
  have hp := columnPattern_transport splitChannel outputChannel
    (splitAdmitted j) (outputAdmitted j) (Equiv.refl _) hc
  have hv := columnValue_transport splitChannel outputChannel splitSingular outputSingular
    (splitAdmitted j) (outputAdmitted j) (Equiv.refl _) hc
  rw [(splitData j).1] at hp
  exact ⟨by simpa using hp, hv.trans (splitData j).2⟩

-- The value-one singleton column moves to literal output label 2, not label 1.
example : (outputAdmitted 0).val = 2 ∧
    (columnPattern outputChannel (outputAdmitted 0)).val = {0} ∧
    columnValue outputChannel outputSingular (outputAdmitted 0) = 1 :=
  ⟨rfl, (outputData 0).1, (outputData 0).2⟩

-- Unequal values also distinguish the two possible directions of output relabeling.
example : (outputAdmitted 1).val = 0 ∧
    columnValue outputChannel outputSingular (outputAdmitted 1) = 1 / 3 ∧
    (outputAdmitted 2).val = 1 ∧
    columnValue outputChannel outputSingular (outputAdmitted 2) = 2 / 3 :=
  ⟨rfl, (outputData 1).2, rfl, (outputData 2).2⟩

example : massMatrix outputChannel 0 2 = 1 ∧ realMatrix outputChannel 0 2 = 1 ∧
    realMatrix outputChannel 0 1 = 0 := by
  have hp : (columnPattern outputChannel (outputAdmitted 0)).val = {0} := (outputData 0).1
  have hv : columnValue outputChannel outputSingular (outputAdmitted 0) = 1 := (outputData 0).2
  have hn : (0 : Fin 3) ∉ splitPattern 2 := by decide
  have h0 : cycleThree (0 : Fin 3) = 2 := rfl
  have h2 : cycleThree (2 : Fin 3) = 1 := rfl
  refine ⟨?_, ?_, ?_⟩
  · change outputChannel 0 2 = 1
    simpa only [hp, hv, h0, Finset.mem_singleton, if_true] using
      column_eq_ite outputChannel outputSingular (outputAdmitted 0) 0
  · change (outputChannel 0 2).toReal = 1
    simpa only [hp, hv, h0, Finset.mem_singleton, if_true, ENNReal.toReal_one] using
      column_toReal_eq_ite outputChannel outputSingular (outputAdmitted 0) 0
  · change (outputChannel 0 1).toReal = 0
    simpa only [(outputData 2).1, hn, h2, if_false] using
      column_toReal_eq_ite outputChannel outputSingular (outputAdmitted 2) 0

/-! ## R06: admitted data through extension, restriction and re-enumeration -/

private theorem data_of_atoms {alpha : Type u} {beta : Type v} {gamma : Type v'}
    [Fintype alpha] (kappa : alpha → PMF beta) (eta : alpha → PMF gamma)
    (h : IsSingularChannel kappa) (h' : IsSingularChannel eta)
    (y : activeOutputs kappa) (z : activeOutputs eta)
    (hc : ∀ x, eta x z.val = kappa x y.val) :
    (columnPattern eta z).val = (columnPattern kappa y).val ∧
      columnValue eta h' z = columnValue kappa h y :=
  ⟨by simpa using columnPattern_transport kappa eta y z (Equiv.refl _) hc,
    columnValue_transport kappa eta h h' y z (Equiv.refl _) hc⟩

private noncomputable abbrev splitState : ActiveFiniteChannel (Fin 3) where
  outputCard := 3
  outputCard_pos := by decide
  channel := splitChannel
  output_active := fun y => by
    obtain ⟨x, hx⟩ :=
      channelOfColumnData_active splitPatterns splitValue splitRows splitValue_pos y
    exact ⟨x, by simpa only [PMF.mem_support_iff] using hx⟩

private noncomputable abbrev extendedChannel (x : Fin 3) : PMF (Option (Fin 3)) :=
  (splitState.channel x).map some

private theorem extendedSingular : IsSingularChannel extendedChannel :=
  (isSingularChannel_map_iff _ _ (Option.some_injective _)).2 splitSingular

private noncomputable abbrev extendedAdmitted (j : Fin 3) : activeOutputs extendedChannel :=
  activeOutputsMapEquiv splitChannel some (Option.some_injective _) (splitAdmitted j)

private theorem extendedData (j : Fin 3) :
    (columnPattern extendedChannel (extendedAdmitted j)).val = splitPattern j ∧
      columnValue extendedChannel extendedSingular (extendedAdmitted j) = splitValue j := by
  have h := data_of_atoms splitChannel extendedChannel splitSingular extendedSingular
    (splitAdmitted j) (extendedAdmitted j)
    (fun x => massMatrix_map splitChannel some (Option.some_injective _) x j)
  exact ⟨h.1.trans (splitData j).1, h.2.trans (splitData j).2⟩

private noncomputable abbrev restrictedChannel := restrictActiveOutputs extendedChannel

private theorem restrictedSingular : IsSingularChannel restrictedChannel :=
  (isSingularChannel_restrictActiveOutputs_iff _).2 extendedSingular

private noncomputable abbrev restrictedAdmitted (j : Fin 3) : activeOutputs restrictedChannel :=
  ⟨extendedAdmitted j, by
    obtain ⟨x, hx⟩ := (extendedAdmitted j).property
    exact ⟨x, by simpa only [PMF.mem_support_iff, restrictedChannel,
      restrictActiveOutputs_apply] using hx⟩⟩

private theorem restrictedData (j : Fin 3) :
    (columnPattern restrictedChannel (restrictedAdmitted j)).val = splitPattern j ∧
      columnValue restrictedChannel restrictedSingular (restrictedAdmitted j) = splitValue j := by
  have h := data_of_atoms extendedChannel restrictedChannel extendedSingular restrictedSingular
    (extendedAdmitted j) (restrictedAdmitted j)
    (fun x => restrictActiveOutputs_apply extendedChannel x (extendedAdmitted j))
  exact ⟨h.1.trans (extendedData j).1, h.2.trans (extendedData j).2⟩

private noncomputable abbrev recoveredState : ActiveFiniteChannel (Fin 3) :=
  ActiveFiniteChannel.ofChannel extendedChannel

private theorem recoveredSingular : IsSingularChannel recoveredState.channel :=
  (ActiveFiniteChannel.isSingularChannel_ofChannel_iff _).2 extendedSingular

private noncomputable abbrev recoveryEquiv : Fin 3 ≃ Fin recoveredState.outputCard :=
  splitState.extensionEquiv some (Option.some_injective _)

private noncomputable abbrev recoveredAdmitted (j : Fin 3) : activeOutputs recoveredState.channel :=
  ⟨recoveryEquiv j, recoveredState.output_active (recoveryEquiv j)⟩

private theorem recoveredData (j : Fin 3) :
    (columnPattern recoveredState.channel (recoveredAdmitted j)).val = splitPattern j ∧
      columnValue recoveredState.channel recoveredSingular (recoveredAdmitted j) =
        splitValue j := by
  have hc (x : Fin 3) : recoveredState.channel x (recoveryEquiv j) = splitChannel x j := by
    have h := splitState.extension_compare some (Option.some_injective _) x
    have hm := congrArg (fun p => p (recoveryEquiv j)) h
    exact hm.symm.trans (PMF.map_apply_equiv _ recoveryEquiv j)
  have h := data_of_atoms splitChannel recoveredState.channel splitSingular recoveredSingular
    (splitAdmitted j) (recoveredAdmitted j) hc
  exact ⟨h.1.trans (splitData j).1, h.2.trans (splitData j).2⟩

-- No data are requested at the newly introduced off-image zero column.
example (x : Fin 3) : extendedChannel x none = 0 ∧
    realMatrix extendedChannel x none = 0 ∧ none ∉ activeOutputs extendedChannel := by
  refine ⟨massMatrix_map_eq_zero _ _ _ _ (by simp),
    realMatrix_map_eq_zero _ _ _ _ (by simp), ?_⟩
  rintro ⟨x, hx⟩
  exact hx (massMatrix_map_eq_zero splitState.channel some x none (by simp))

-- Every admitted stage recovers the same nontrivial data, with an explicit final equivalence.
example (j : Fin 3) (x : Fin 3) :
    (extendedAdmitted j).val = some j ∧
    (columnPattern extendedChannel (extendedAdmitted j)).val = splitPattern j ∧
    columnValue extendedChannel extendedSingular (extendedAdmitted j) = splitValue j ∧
    (columnPattern restrictedChannel (restrictedAdmitted j)).val = splitPattern j ∧
    columnValue restrictedChannel restrictedSingular (restrictedAdmitted j) = splitValue j ∧
    (columnPattern recoveredState.channel (recoveredAdmitted j)).val = splitPattern j ∧
    columnValue recoveredState.channel recoveredSingular (recoveredAdmitted j) = splitValue j ∧
    (splitState.channel x).map recoveryEquiv = recoveredState.channel x :=
  ⟨rfl, (extendedData j).1, (extendedData j).2, (restrictedData j).1,
    (restrictedData j).2, (recoveredData j).1, (recoveredData j).2,
    splitState.extension_compare some (Option.some_injective _) x⟩

example : (columnPattern recoveredState.channel (recoveredAdmitted 1)).val = {1, 2} ∧
    (columnValue recoveredState.channel recoveredSingular (recoveredAdmitted 1)).toReal = 1 / 3 ∧
    realMatrix recoveredState.channel 2 (recoveryEquiv 1) /
      (columnValue recoveredState.channel recoveredSingular (recoveredAdmitted 1)).toReal = 1 := by
  refine ⟨(recoveredData 1).1, ?_, ?_⟩
  · rw [(recoveredData 1).2]
    norm_num [splitValue, ENNReal.toReal_div]
  · have hd := column_div_value recoveredState.channel recoveredSingular (recoveredAdmitted 1) 2
    rw [(recoveredData 1).1] at hd
    have hy : (2 : Fin 3) ∈ splitPattern 1 := by decide
    simpa only [hy, if_true] using hd

example : massMatrix recoveredState.channel 2 (recoveryEquiv 1) = 1 / 3 ∧
    realMatrix recoveredState.channel 2 (recoveryEquiv 1) = 1 / 3 := by
  have hy : (2 : Fin 3) ∈ splitPattern 1 := by decide
  have hm : recoveredState.channel 2 (recoveryEquiv 1) = 1 / 3 := by
    change recoveredState.channel 2 (recoveryEquiv 1) = splitValue 1
    simpa only [(recoveredData 1).1, (recoveredData 1).2, hy, if_true] using
      column_eq_ite recoveredState.channel recoveredSingular (recoveredAdmitted 1) 2
  refine ⟨hm, ?_⟩
  change (recoveredState.channel 2 (recoveryEquiv 1)).toReal = 1 / 3
  rw [hm]
  norm_num [ENNReal.toReal_div]

-- With initially unused ambient labels, compare active presentations on both sides.
example {alpha : Type u} {beta : Type v} {gamma : Type v'}
    [Fintype alpha] [Nonempty alpha] [Finite beta] [Finite gamma]
    (kappa : alpha → PMF beta) (h : IsSingularChannel kappa)
    (j : beta → gamma) (hj : Function.Injective j)
    (y : Fin (ActiveFiniteChannel.ofChannel kappa).outputCard) :
    let a := ActiveFiniteChannel.ofChannel kappa
    let b := ActiveFiniteChannel.ofChannel (fun x => (kappa x).map j)
    let e := ActiveFiniteChannel.outputEquivOfMap kappa j hj
    let ha := (ActiveFiniteChannel.isSingularChannel_ofChannel_iff kappa).2 h
    let hb := (ActiveFiniteChannel.isSingularChannel_ofChannel_iff
      (fun x => (kappa x).map j)).2 ((isSingularChannel_map_iff kappa j hj).2 h)
    (columnPattern b.channel (b.activeEquiv (e y))).val =
        (columnPattern a.channel (a.activeEquiv y)).val ∧
      columnValue b.channel hb (b.activeEquiv (e y)) =
        columnValue a.channel ha (a.activeEquiv y) := by
  let a := ActiveFiniteChannel.ofChannel kappa
  let b := ActiveFiniteChannel.ofChannel (fun x => (kappa x).map j)
  let e := ActiveFiniteChannel.outputEquivOfMap kappa j hj
  apply data_of_atoms
  intro x
  have he := ActiveFiniteChannel.ofChannel_map_compare kappa j hj x
  have hm := congrArg (fun p => p (e y)) he
  exact hm.symm.trans (PMF.map_apply_equiv _ e y)

/-! ## R11: two actual enumerations of a lifted finite output alphabet -/

private noncomputable abbrev liftedChannel (x : Fin 3) : PMF (ULift.{1} (Fin 3)) :=
  (splitChannel x).map (Equiv.ulift : ULift.{1} (Fin 3) ≃ Fin 3).symm

private theorem liftedActive (y : ULift.{1} (Fin 3)) : ∃ x, liftedChannel x y ≠ 0 := by
  rcases y with ⟨y⟩
  obtain ⟨x, hx⟩ := (splitAdmitted y).property
  refine ⟨x, ?_⟩
  change ((splitChannel x).map (Equiv.ulift : ULift.{1} (Fin 3) ≃ Fin 3).symm)
    ((Equiv.ulift : ULift.{1} (Fin 3) ≃ Fin 3).symm y) ≠ 0
  rw [PMF.map_apply_equiv]
  simpa only [PMF.mem_support_iff] using hx

private theorem liftedSingular : IsSingularChannel liftedChannel :=
  (isSingularChannel_map_iff _ _
    (Equiv.ulift : ULift.{1} (Fin 3) ≃ Fin 3).symm.injective).2 splitSingular

private noncomputable abbrev firstPresentation : ActiveFiniteChannel (Fin 3) :=
  ActiveFiniteChannel.ofActive liftedChannel Equiv.ulift liftedActive

private noncomputable abbrev secondPresentation : ActiveFiniteChannel (Fin 3) :=
  ActiveFiniteChannel.ofActive liftedChannel (Equiv.ulift.trans cycleThree) liftedActive

private theorem firstSingular : IsSingularChannel firstPresentation.channel :=
  (ActiveFiniteChannel.isSingularChannel_ofActive_iff _ _ _).2 liftedSingular

private theorem secondSingular : IsSingularChannel secondPresentation.channel :=
  (ActiveFiniteChannel.isSingularChannel_ofActive_iff _ _ _).2 liftedSingular

private theorem presentationsCompare (x : Fin 3) :
    (firstPresentation.channel x).map cycleThree = secondPresentation.channel x :=
  ActiveFiniteChannel.ofActive_compare liftedChannel
    (Equiv.ulift : ULift.{1} (Fin 3) ≃ Fin 3)
    ((Equiv.ulift : ULift.{1} (Fin 3) ≃ Fin 3).trans cycleThree) liftedActive x

example : (Equiv.ulift : ULift.{1} (Fin 3) ≃ Fin 3) (ULift.up 0) = 0 ∧
    ((Equiv.ulift : ULift.{1} (Fin 3) ≃ Fin 3).trans cycleThree) (ULift.up 0) = 2 :=
  ⟨rfl, rfl⟩

example (j x : Fin 3) :
    (firstPresentation.channel x).map cycleThree = secondPresentation.channel x ∧
    (columnPattern secondPresentation.channel
      (secondPresentation.activeEquiv (cycleThree j))).val =
        (columnPattern firstPresentation.channel (firstPresentation.activeEquiv j)).val ∧
    columnValue secondPresentation.channel secondSingular
      (secondPresentation.activeEquiv (cycleThree j)) =
        columnValue firstPresentation.channel firstSingular (firstPresentation.activeEquiv j) := by
  refine ⟨presentationsCompare x, ?_⟩
  apply data_of_atoms
  intro x
  have hm := congrArg (fun p => p (cycleThree j)) (presentationsCompare x)
  exact hm.symm.trans (PMF.map_apply_equiv _ cycleThree j)

-- The first presentation recovers the supplied repeated-pattern data literally.
example (j : Fin 3) :
    (columnPattern firstPresentation.channel (firstPresentation.activeEquiv j)).val =
        splitPattern j ∧
      columnValue firstPresentation.channel firstSingular
        (firstPresentation.activeEquiv j) = splitValue j := by
  have hc (x : Fin 3) : firstPresentation.channel x j = splitChannel x j :=
    (ActiveFiniteChannel.ofActive_apply liftedChannel Equiv.ulift liftedActive x
      (ULift.up j)).trans
        (PMF.map_apply_equiv (splitChannel x)
          (Equiv.ulift : ULift.{1} (Fin 3) ≃ Fin 3).symm j)
  have h := data_of_atoms splitChannel firstPresentation.channel splitSingular firstSingular
    (splitAdmitted j) (firstPresentation.activeEquiv j) hc
  exact ⟨h.1.trans (splitData j).1, h.2.trans (splitData j).2⟩

end PerfectFunctionalRepresentations
