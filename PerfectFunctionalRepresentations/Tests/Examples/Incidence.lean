import PerfectFunctionalRepresentations.Optimization.IncidenceConstruction
import PerfectFunctionalRepresentations.Optimization.Primal
import PerfectFunctionalRepresentations.Optimization.Dual
import PerfectFunctionalRepresentations.Optimization.DualCharacterization
import PerfectFunctionalRepresentations.Examples.Nonrepresentable3x3
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum

/-!
# Incidence feasibility controls on three inputs

Intrinsic feasibility controls use the public C03 channel and C12 extraction.
Supported-witness and actual-phase consumers check aggregation and synthesis.
The exhaustive three-input partition fixture identifies all 35 paper entries,
full/reduced presentations and the precise counterexample coefficient vectors.
C14-S02 consumes the primal characterization on the existing representable
and nonperfect data, including a signed equality solution rejected by primal feasibility.
C14-S03 checks the scaled asymmetric primal vector through supplied finite
coordinates and uses the entire objective-value image in both directions.
C15-S01 checks the dual sign condition using the retained obstructed datum.
C15-S02 checks explicit subunit and corrected separating vectors on that datum,
and consumes the public existential certificate independently of those vectors.
C15-S03 checks every dual lower bound and attained leastness on the existing
zero-containing representable witness, and leastness failure on the obstructed datum.
C15-S04 checks independent finite dual coordinates with a non-involutive row
permutation across unequal values, exact products and both objective-image directions.
-/

namespace PerfectFunctionalRepresentations.Incidence.Tests.Concrete

noncomputable section
attribute [local instance] Classical.propDecidable
local instance : DecidableEq (Fin 3) := fun a b => Classical.propDecidable (a = b)
open scoped BigOperators ENNReal Matrix

private abbrev r05ActiveFintype : Fintype (activeOutputs nonrepresentable3x3) :=
  Fintype.ofFinite _
attribute [local instance] r05ActiveFintype

private abbrev r05Data :=
  compressedPatternData nonrepresentable3x3 nonrepresentable3x3_isSingular

private def r05Patterns : Fin 3 → Incidence.NonzeroPattern (Fin 3) :=
  ![⟨{0, 1}, by simp⟩, ⟨{0, 2}, by simp⟩, ⟨{1, 2}, by simp⟩]

private theorem r05Active (j : Fin 3) :
    j ∈ activeOutputs nonrepresentable3x3 := by
  fin_cases j
  · exact ⟨0, by norm_num [PMF.mem_support_iff, nonrepresentable3x3_apply]⟩
  · exact ⟨0, by norm_num [PMF.mem_support_iff, nonrepresentable3x3_apply]⟩
  · exact ⟨1, by norm_num [PMF.mem_support_iff, nonrepresentable3x3_apply]⟩

private abbrev r05Admitted (j : Fin 3) : activeOutputs nonrepresentable3x3 :=
  ⟨j, r05Active j⟩

private def r05ActiveEquiv : Fin 3 ≃ activeOutputs nonrepresentable3x3 where
  toFun := r05Admitted
  invFun := Subtype.val
  left_inv _ := rfl
  right_inv _ := rfl

private theorem r05ColumnPattern (j : Fin 3) :
    columnPattern nonrepresentable3x3 (r05Admitted j) = r05Patterns j := by
  apply Subtype.ext
  ext x
  rw [mem_columnPattern]
  fin_cases x <;> fin_cases j <;>
    norm_num [r05Admitted, nonrepresentable3x3_apply, r05Patterns, Fin.ext_iff]

private theorem r05ColumnValue (j : Fin 3) :
    columnValue nonrepresentable3x3 nonrepresentable3x3_isSingular (r05Admitted j) =
      1 / 2 := by
  fin_cases j
  · exact (columnValue_eq_of_ne_zero nonrepresentable3x3 nonrepresentable3x3_isSingular
      (r05Admitted 0) (x := 0) (by norm_num [nonrepresentable3x3_apply])).trans
        (by norm_num [nonrepresentable3x3_apply])
  · exact (columnValue_eq_of_ne_zero nonrepresentable3x3 nonrepresentable3x3_isSingular
      (r05Admitted 1) (x := 0) (by norm_num [nonrepresentable3x3_apply])).trans
        (by norm_num [nonrepresentable3x3_apply])
  · exact (columnValue_eq_of_ne_zero nonrepresentable3x3 nonrepresentable3x3_isSingular
      (r05Admitted 2) (x := 1) (by norm_num [nonrepresentable3x3_apply])).trans
        (by norm_num [nonrepresentable3x3_apply])

private theorem r05Patterns_injective : Function.Injective r05Patterns := by
  intro i j h
  have h0 := congrArg (fun p : Incidence.NonzeroPattern (Fin 3) => (0 : Fin 3) ∈ p.val) h
  have h1 := congrArg (fun p : Incidence.NonzeroPattern (Fin 3) => (1 : Fin 3) ∈ p.val) h
  fin_cases i <;> fin_cases j <;> try rfl
  all_goals
    norm_num [r05Patterns, Fin.ext_iff] at h0 <;>
      norm_num [r05Patterns, Fin.ext_iff] at h1

private abbrev r05Output (j : Fin 3) :
    PerfectFunctionalRepresentations.OccurringPattern nonrepresentable3x3 :=
  toOccurringPattern nonrepresentable3x3 (r05Admitted j)

private theorem r05Output_val (j : Fin 3) :
    (r05Output j).val = r05Patterns j := r05ColumnPattern j

private def r05Enumeration :
    Fin 3 ≃ PerfectFunctionalRepresentations.OccurringPattern nonrepresentable3x3 :=
  Equiv.ofBijective r05Output ⟨by
    intro i j h
    apply r05Patterns_injective
    exact (r05Output_val i).symm.trans
      ((congrArg Subtype.val h).trans (r05Output_val j)),
    (toOccurringPattern_surjective nonrepresentable3x3).comp r05ActiveEquiv.surjective⟩

private theorem r05Data_patterns :
    r05Data.patterns = {r05Patterns 0, r05Patterns 1, r05Patterns 2} := by
  change occurringPatterns nonrepresentable3x3 = _
  ext p
  rw [mem_occurringPatterns]
  simp only [Finset.mem_insert, Finset.mem_singleton]
  constructor
  · rintro ⟨⟨j, hj⟩, hy⟩
    have h : r05Patterns j = p := (r05ColumnPattern j).symm.trans hy
    fin_cases j <;> simp_all
  · rintro (rfl | rfl | rfl)
    · exact ⟨r05Admitted 0, r05ColumnPattern 0⟩
    · exact ⟨r05Admitted 1, r05ColumnPattern 1⟩
    · exact ⟨r05Admitted 2, r05ColumnPattern 2⟩

private theorem r05ValueAt (j : Fin 3) :
    r05Data.value (r05Output j) = 1 / 2 := by
  change (patternAggregate nonrepresentable3x3 nonrepresentable3x3_isSingular
    (r05Output j)).toReal = _
  unfold patternAggregate
  rw [← r05ActiveEquiv.sum_comp]
  change (∑ i : Fin 3, if columnPattern nonrepresentable3x3 (r05Admitted i) =
    (r05Output j).val then columnValue nonrepresentable3x3 nonrepresentable3x3_isSingular
      (r05Admitted i) else 0).toReal = _
  simp only [r05Output_val, r05ColumnPattern, r05ColumnValue,
    r05Patterns_injective.eq_iff]
  simp

private theorem r05Data_value (p : Incidence.OccurringPattern r05Data) :
    r05Data.value p = 1 / 2 := by
  obtain ⟨j, rfl⟩ := r05Enumeration.surjective p
  exact r05ValueAt j

private theorem r05FullValue (p : Incidence.NonzeroPattern (Fin 3)) :
    Incidence.fullValue r05Data p = if p ∈ r05Data.patterns then 1 / 2 else 0 := by
  unfold Incidence.fullValue
  split_ifs with hp
  · exact r05Data_value ⟨p, hp⟩
  · rfl

private theorem r05FullValueAt (j : Fin 3) :
    Incidence.fullValue r05Data (r05Patterns j) = 1 / 2 := by
  rw [r05FullValue, r05Data_patterns]
  fin_cases j <;> simp

private theorem r05FullValue_eq (p : Incidence.NonzeroPattern (Fin 3)) :
    Incidence.fullValue r05Data p =
      if p = r05Patterns 0 ∨ p = r05Patterns 1 ∨ p = r05Patterns 2 then 1 / 2 else 0 := by
  rw [r05FullValue, r05Data_patterns]
  simp only [Finset.mem_insert, Finset.mem_singleton]

example : Fintype.card (Incidence.OccurringPattern r05Data) = 3 :=
  (Fintype.card_congr r05Enumeration).symm.trans (Fintype.card_fin 3)

example : (∑ p : Incidence.OccurringPattern r05Data, r05Data.value p) = 3 / 2 := by
  have hc : Fintype.card (Incidence.OccurringPattern r05Data) = 3 :=
    (Fintype.card_congr r05Enumeration).symm.trans (Fintype.card_fin 3)
  simp only [r05Data_value]
  simp only [Finset.sum_const, Finset.card_univ]
  rw [hc]
  norm_num

example (x : Fin 3) :
    (∑ p : Incidence.OccurringPattern r05Data,
      if x ∈ p.val.val then r05Data.value p else 0) = 1 := r05Data.row_sum x

private theorem r05Data_not_perfect : ¬ IsPerfectlyRepresentableChannel r05Data.channel := by
  intro h
  exact nonrepresentable3x3_not_isPerfectlyRepresentableChannel
    ((isPerfectlyRepresentableChannel_iff_compressedPatternData
      nonrepresentable3x3 nonrepresentable3x3_isSingular).mpr h)

private theorem r05Member (b : Finset (Fin 3)) (hb : b.Nonempty)
    (h : (⟨b, hb⟩ : Incidence.NonzeroPattern (Fin 3)) ∈ r05Data.patterns) :
    b = {0, 1} ∨ b = {0, 2} ∨ b = {1, 2} := by
  rw [r05Data_patterns] at h
  simpa [r05Patterns, Subtype.ext_iff] using h

attribute [local simp] Fin.ext_iff

private theorem r05NoPartition (π : Incidence.ExactPartition (Fin 3))
    (hπ : Incidence.IsAdmissible r05Data π) : False := by
  obtain ⟨b, hb, h0⟩ := π.exists_mem (Finset.mem_univ (0 : Fin 3))
  have hbb := r05Member b (π.nonempty_of_mem_parts hb) (hπ ⟨b, hb⟩)
  obtain ⟨c, hc, h2⟩ := π.exists_mem (Finset.mem_univ (2 : Fin 3))
  have hcc := r05Member c (π.nonempty_of_mem_parts hc) (hπ ⟨c, hc⟩)
  rcases hbb with rfl | rfl | rfl
  · rcases hcc with rfl | rfl | rfl
    · simp at h2
    · have he := π.eq_of_mem_parts hb hc (a := 0) (by simp) (by simp)
      have := congrArg (fun t : Finset (Fin 3) => (1 : Fin 3) ∈ t) he
      simp at this
    · have he := π.eq_of_mem_parts hb hc (a := 1) (by simp) (by simp)
      have := congrArg (fun t : Finset (Fin 3) => (0 : Fin 3) ∈ t) he
      simp at this
  · obtain ⟨d, hd, h1⟩ := π.exists_mem (Finset.mem_univ (1 : Fin 3))
    have hdd := r05Member d (π.nonempty_of_mem_parts hd) (hπ ⟨d, hd⟩)
    rcases hdd with rfl | rfl | rfl
    · have he := π.eq_of_mem_parts hb hd (a := 0) (by simp) (by simp)
      have := congrArg (fun t : Finset (Fin 3) => (2 : Fin 3) ∈ t) he
      simp at this
    · simp at h1
    · have he := π.eq_of_mem_parts hb hd (a := 2) (by simp) (by simp)
      have := congrArg (fun t : Finset (Fin 3) => (0 : Fin 3) ∈ t) he
      simp at this
  · simp at h0

private instance : IsEmpty (Incidence.AdmissiblePartition r05Data) :=
  ⟨fun π => r05NoPartition π.val π.property⟩

example : Fintype.card (Incidence.AdmissiblePartition r05Data) = 0 := by simp

private def r05EmptyPresentation : Incidence.AdmissiblePartition r05Data ≃ Fin 0 :=
  Equiv.equivOfIsEmpty _ _

example : Matrix (Incidence.OccurringPattern r05Data) (Fin 0) ℝ :=
  Matrix.reindex (Equiv.refl _) r05EmptyPresentation (Incidence.reducedMatrix r05Data)

private abbrev A := NonzeroPattern (Fin 3)
private abbrev Q := ExactPartition (Fin 3)
private def singlePattern (i : Fin 3) : A := ⟨{i}, by simp⟩
private def pairPattern (i : Fin 3) : A := ⟨Finset.univ.erase i, by
  fin_cases i
  · exact ⟨1, by simp⟩
  · exact ⟨0, by simp⟩
  · exact ⟨0, by simp⟩⟩
private def wholePattern : A := ⟨Finset.univ, Finset.univ_nonempty⟩
private def wholePartition : Q := Finpartition.indiscrete Finset.univ_nonempty.ne_empty
private def singlePartition : Q := ⊥

private def splitPartition (i : Fin 3) : Q :=
  Finpartition.ofExistsUnique {Finset.univ.erase i, {i}}
    (fun _ _ => Finset.subset_univ _) (by
      intro x hx
      by_cases h : x = i
      · refine ⟨{i}, by simp [h], ?_⟩
        intro t ht
        rcases (Finset.mem_insert.mp ht.1) with ht' | ht'
        · subst t
          simp [h] at ht
        · exact Finset.mem_singleton.mp ht'
      · refine ⟨Finset.univ.erase i, by simp [h], ?_⟩
        intro t ht
        rcases (Finset.mem_insert.mp ht.1) with ht' | ht'
        · exact ht'
        · have he := Finset.mem_singleton.mp ht'
          subst t
          simp [h] at ht)
    (by
      simp only [Finset.mem_insert, Finset.mem_singleton]
      push Not
      exact ⟨(pairPattern i).property.ne_empty.symm, by simp⟩)

@[simp] private theorem splitPartition_parts (i : Fin 3) :
    (splitPartition i).parts = {Finset.univ.erase i,{i}} := rfl

@[simp] private theorem wholePartition_parts : wholePartition.parts = {Finset.univ} := rfl

@[simp] private theorem singlePartition_mem (p : Finset (Fin 3)) :
    p ∈ singlePartition.parts ↔ ∃ i : Fin 3, {i} = p := by
  simp [singlePartition]

-- General sparse weights avoid enumerating the whole partition universe.
private def sparse (a b c d e : ℝ) : Q → ℝ :=
  Pi.single wholePartition a + Pi.single (splitPartition 2) b +
    Pi.single (splitPartition 1) c + Pi.single (splitPartition 0) d +
    Pi.single singlePartition e

private theorem sparse_mulVec (p : A) (a b c d e : ℝ) :
    (fullMatrix *ᵥ sparse a b c d e) p =
      fullMatrix p wholePartition * a + fullMatrix p (splitPartition 2) * b +
      fullMatrix p (splitPartition 1) * c + fullMatrix p (splitPartition 0) * d +
      fullMatrix p singlePartition * e := by
  simp only [sparse, Matrix.mulVec_add, Matrix.mulVec_single, Pi.add_apply]
  rfl

private theorem sparse_sum (a b c d e : ℝ) :
    (∑ π, sparse a b c d e π) = a + b + c + d + e := by
  simp [sparse, Finset.sum_add_distrib]

@[simp] private theorem pair_full_entry (i j : Fin 3) :
    fullMatrix (pairPattern i) (splitPartition j) = if i = j then 1 else 0 := by
  fin_cases i <;> fin_cases j <;>
    norm_num [fullMatrix, pairPattern, Finset.ext_iff, Fin.forall_fin_succ, -Fin.val_eq_zero_iff]

@[simp] private theorem single_full_entry (i j : Fin 3) :
    fullMatrix (singlePattern i) (splitPartition j) = if i = j then 1 else 0 := by
  fin_cases i <;> fin_cases j <;>
    norm_num [fullMatrix, singlePattern, Finset.ext_iff, Fin.forall_fin_succ, -Fin.val_eq_zero_iff]

@[simp] private theorem pair_single_entry (i : Fin 3) :
    fullMatrix (pairPattern i) singlePartition = 0 := by
  fin_cases i <;>
    norm_num [fullMatrix, pairPattern, Fin.exists_fin_succ, Finset.ext_iff,
      Fin.forall_fin_succ, -Fin.val_eq_zero_iff]

@[simp] private theorem single_single_entry (i : Fin 3) :
    fullMatrix (singlePattern i) singlePartition = 1 := by
  simp [fullMatrix, singlePattern]

@[simp] private theorem pair_whole_entry (i : Fin 3) :
    fullMatrix (pairPattern i) wholePartition = 0 := by
  fin_cases i <;>
    norm_num [fullMatrix, pairPattern, Finset.ext_iff, Fin.forall_fin_succ, -Fin.val_eq_zero_iff]

@[simp] private theorem single_whole_entry (i : Fin 3) :
    fullMatrix (singlePattern i) wholePartition = 0 := by
  fin_cases i <;>
    norm_num [fullMatrix, singlePattern, Finset.ext_iff, Fin.forall_fin_succ, -Fin.val_eq_zero_iff]

@[simp] private theorem whole_split_entry (i : Fin 3) :
    fullMatrix wholePattern (splitPartition i) = 0 := by
  fin_cases i <;>
    norm_num [fullMatrix, wholePattern, Finset.ext_iff, Fin.forall_fin_succ, -Fin.val_eq_zero_iff]

@[simp] private theorem whole_whole_entry : fullMatrix wholePattern wholePartition = 1 := by
  simp [fullMatrix, wholePattern]

@[simp] private theorem whole_single_entry : fullMatrix wholePattern singlePartition = 0 := by
  norm_num [fullMatrix, wholePattern, Fin.exists_fin_succ, Finset.ext_iff,
    Fin.forall_fin_succ, -Fin.val_eq_zero_iff]

example (i : Fin 3) : (fullMatrix *ᵥ sparse 0 (1/2) (1/2) (1/2) 0) (pairPattern i) = 1/2 := by
  rw [sparse_mulVec]
  fin_cases i <;> norm_num

example (i : Fin 3) : (fullMatrix *ᵥ sparse 0 (1/2) (1/2) (1/2) (-1/2)) (singlePattern i) = 0 := by
  rw [sparse_mulVec]
  fin_cases i <;> norm_num

-- Local row classification, not a global enumeration of exact partitions.
private theorem part_eq_pair_or_singleton (π : Q) (i : Fin 3)
    (hp : Finset.univ.erase i ∈ π.parts) {b : Finset (Fin 3)} (hb : b ∈ π.parts) :
    b = Finset.univ.erase i ∨ b = {i} := by
  by_cases he : b = Finset.univ.erase i
  · exact Or.inl he
  right
  have hd := π.disjoint hb hp he
  have hsub : b ⊆ {i} := by
    intro x hx
    simp only [Finset.mem_singleton]
    by_contra hxi
    exact Finset.disjoint_left.mp hd hx (by simp [hxi])
  apply Finset.Subset.antisymm hsub
  obtain ⟨x,hx⟩ := π.nonempty_of_mem_parts hb
  have hxi : x = i := Finset.mem_singleton.mp (hsub hx)
  simpa only [hxi, Finset.singleton_subset_iff] using hx

private theorem partition_eq_split_of_pair (π : Q) (i : Fin 3)
    (hp : Finset.univ.erase i ∈ π.parts) : π = splitPartition i := by
  have hs : {i} ∈ π.parts := by
    obtain ⟨b,hb,hxi⟩ := π.exists_mem (Finset.mem_univ i)
    rcases part_eq_pair_or_singleton π i hp hb with he | he
    · rw [he] at hxi
      simp at hxi
    · rwa [he] at hb
  apply Finpartition.ext
  ext b
  simp only [splitPartition_parts, Finset.mem_insert, Finset.mem_singleton]
  constructor
  · exact part_eq_pair_or_singleton π i hp
  · rintro (rfl | rfl)
    · exact hp
    · exact hs

private theorem pair_row (i : Fin 3) (π : Q) :
    fullMatrix (pairPattern i) π = if π = splitPartition i then 1 else 0 := by
  have hm : Finset.univ.erase i ∈ π.parts ↔ π = splitPartition i := by
    constructor
    · exact partition_eq_split_of_pair π i
    · rintro rfl
      simp
  simp only [fullMatrix, pairPattern, hm]

private theorem pair_row_mulVec (i : Fin 3) (w : Q → ℝ) :
    (fullMatrix *ᵥ w) (pairPattern i) = w (splitPartition i) := by
  simp [Matrix.mulVec, dotProduct, pair_row, ite_mul]

-- R14's actual full-coordinate nonnegative obstruction already follows from
-- one pair row and the complementary singleton row, without Bell enumeration.
private theorem forced_pair_exceeds_singleton (w : Q → ℝ) (hw : ∀ π, 0 ≤ w π)
    (hpair : (fullMatrix *ᵥ w) (pairPattern 0) = 3 / 8)
    (hsingle : (fullMatrix *ᵥ w) (singlePattern 0) = 1 / 8) : False := by
  have hl : w (splitPartition 0) ≤ (fullMatrix *ᵥ w) (singlePattern 0) := by
    have hs := Finset.single_le_sum
      (s := (Finset.univ : Finset Q))
      (f := fun π => fullMatrix (singlePattern 0) π * w π)
      (fun π _ => mul_nonneg (fullMatrix_nonneg _ _) (hw π))
      (Finset.mem_univ (splitPartition 0))
    simpa only [single_full_entry, if_true, one_mul, Matrix.mulVec, dotProduct] using hs
  rw [pair_row_mulVec] at hpair
  rw [hpair, hsingle] at hl
  norm_num at hl

private theorem pattern_cases (p : A) :
    (∃ i, p = singlePattern i) ∨ (∃ i, p = pairPattern i) ∨ p = wholePattern := by
  by_cases h0 : (0 : Fin 3) ∈ p.val <;>
    by_cases h1 : (1 : Fin 3) ∈ p.val <;>
    by_cases h2 : (2 : Fin 3) ∈ p.val
  · right; right
    apply Subtype.ext; ext x; fin_cases x <;> simp_all [wholePattern]
  · right; left; refine ⟨2, ?_⟩
    apply Subtype.ext; ext x; fin_cases x <;> simp_all [pairPattern]
  · right; left; refine ⟨1, ?_⟩
    apply Subtype.ext; ext x; fin_cases x <;> simp_all [pairPattern]
  · left; refine ⟨0, ?_⟩
    apply Subtype.ext; ext x; fin_cases x <;> simp_all [singlePattern]
  · right; left; refine ⟨0, ?_⟩
    apply Subtype.ext; ext x; fin_cases x <;> simp_all [pairPattern]
  · left; refine ⟨1, ?_⟩
    apply Subtype.ext; ext x; fin_cases x <;> simp_all [singlePattern]
  · left; refine ⟨2, ?_⟩
    apply Subtype.ext; ext x; fin_cases x <;> simp_all [singlePattern]
  · obtain ⟨x,hx⟩ := p.property
    fin_cases x <;> contradiction

-- Finite labelled data, kept local to these fixtures.
private def listLabels {n : ℕ} (p : Fin n → A) (hi : Function.Injective p) :
    Fin n ≃ ↥(Finset.univ.image p) :=
  Equiv.ofBijective (fun j => ⟨p j, Finset.mem_image.mpr ⟨j, Finset.mem_univ _, rfl⟩⟩)
    ⟨fun i j h => hi (congrArg Subtype.val h), by
      intro q
      obtain ⟨j,_,hj⟩ := Finset.mem_image.mp q.property
      exact ⟨j, Subtype.ext hj⟩⟩

private def dataOfList {n : ℕ} (p : Fin n → A) (hi : Function.Injective p)
    (v : Fin n → ℝ) (hp : ∀ j, 0 < v j)
    (hr : ∀ x : Fin 3, ∑ j, (if x ∈ (p j).val then v j else 0) = 1) :
    CompressedPatternData (Fin 3) where
  patterns := Finset.univ.image p
  value q := v ((listLabels p hi).symm q)
  value_pos q := hp _
  row_sum := by
    intro x
    rw [← (listLabels p hi).sum_comp]
    simp only [Equiv.symm_apply_apply]
    change (∑ j, if x ∈ (p j).val then v j else 0) = 1
    exact hr x

private theorem dataOfList_value {n : ℕ} (p : Fin n → A) (hi : Function.Injective p)
    (v : Fin n → ℝ) (hp) (hr) (j : Fin n) :
    (dataOfList p hi v hp hr).value ((listLabels p hi) j) = v j := by
  simp only [dataOfList, Equiv.symm_apply_apply]

private def sharedPatterns : Fin 4 → A :=
  ![singlePattern 0, singlePattern 1, singlePattern 2, pairPattern 2]
private def sharedValues : Fin 4 → ℝ := ![1/3,1/3,1,2/3]

private theorem sharedPatterns_injective : Function.Injective sharedPatterns := by
  intro i j h
  have h0 := congrArg (fun p : A => (0 : Fin 3) ∈ p.val) h
  have h1 := congrArg (fun p : A => (1 : Fin 3) ∈ p.val) h
  fin_cases i <;> fin_cases j <;> try rfl
  all_goals first
    | (solve | norm_num [sharedPatterns, singlePattern, pairPattern, -Fin.val_eq_zero_iff] at h0)
    | (solve | norm_num [sharedPatterns, singlePattern, pairPattern, -Fin.val_eq_zero_iff] at h1)

private def sharedData : CompressedPatternData (Fin 3) :=
  dataOfList sharedPatterns sharedPatterns_injective sharedValues
    (by intro j; fin_cases j <;> norm_num [sharedValues])
    (by intro x; fin_cases x <;>
      norm_num [Fin.sum_univ_succ, sharedPatterns, sharedValues, singlePattern, pairPattern])

private def allPatterns : Fin 7 → A :=
  ![singlePattern 0, singlePattern 1, singlePattern 2,
    pairPattern 2, pairPattern 1, pairPattern 0, wholePattern]

private theorem allPatterns_injective : Function.Injective allPatterns := by
  intro i j h
  have h0 := congrArg (fun p : A => (0 : Fin 3) ∈ p.val) h
  have h1 := congrArg (fun p : A => (1 : Fin 3) ∈ p.val) h
  have h2 := congrArg (fun p : A => (2 : Fin 3) ∈ p.val) h
  fin_cases i <;> fin_cases j <;> try rfl
  all_goals first
    | (solve | norm_num [allPatterns, singlePattern, pairPattern, wholePattern,
        -Fin.val_eq_zero_iff] at h0)
    | (solve | norm_num [allPatterns, singlePattern, pairPattern, wholePattern,
        -Fin.val_eq_zero_iff] at h1)
    | (solve | norm_num [allPatterns, singlePattern, pairPattern, wholePattern,
        -Fin.val_eq_zero_iff] at h2)

private theorem allPatterns_surjective : Function.Surjective allPatterns := by
  intro p
  rcases pattern_cases p with ⟨i,rfl⟩ | ⟨i,rfl⟩ | rfl
  · fin_cases i
    · exact ⟨0,rfl⟩
    · exact ⟨1,rfl⟩
    · exact ⟨2,rfl⟩
  · fin_cases i
    · exact ⟨5,rfl⟩
    · exact ⟨4,rfl⟩
    · exact ⟨3,rfl⟩
  · exact ⟨6,rfl⟩

private def obstructedValues : Fin 7 → ℝ := ![1/8,1/8,1/8,3/8,3/8,3/8,1/8]
private def obstructedData : CompressedPatternData (Fin 3) :=
  dataOfList allPatterns allPatterns_injective obstructedValues
    (by intro j; fin_cases j <;> norm_num [obstructedValues])
    (by intro x; fin_cases x <;>
      norm_num [Fin.sum_univ_succ, allPatterns, obstructedValues,
        singlePattern, pairPattern, wholePattern])

private theorem obstructed_all_mem (p : A) : p ∈ obstructedData.patterns := by
  obtain ⟨j,rfl⟩ := allPatterns_surjective p
  exact Finset.mem_image.mpr ⟨j, Finset.mem_univ _, rfl⟩

private theorem obstructed_all_admissible (π : Q) : IsAdmissible obstructedData π :=
  fun _ => obstructed_all_mem _

example : Nonempty (AdmissiblePartition obstructedData) :=
  ⟨⟨wholePartition, obstructed_all_admissible _⟩⟩

private theorem fullValue_dataOfList_at {n : ℕ} (p : Fin n → A) (hi : Function.Injective p)
    (v : Fin n → ℝ) (hp) (hr) (j : Fin n) :
    fullValue (dataOfList p hi v hp hr) (p j) = v j := by
  rw [fullValue_of_mem _ _ ((listLabels p hi) j).property]
  exact dataOfList_value p hi v hp hr j

private theorem obstructed_fullValue (j : Fin 7) :
    fullValue obstructedData (allPatterns j) = obstructedValues j :=
  fullValue_dataOfList_at _ _ _ _ _ j

private theorem obstructed_signed_solution :
    fullMatrix *ᵥ sparse (1/8) (3/8) (3/8) (3/8) (-1/4) = fullValue obstructedData := by
  ext p
  obtain ⟨j,rfl⟩ := allPatterns_surjective p
  rw [obstructed_fullValue]
  fin_cases j <;> rw [sparse_mulVec] <;> norm_num [allPatterns, obstructedValues]

private theorem obstructed_no_nonnegative_solution (w : Q → ℝ) (hw : ∀ π, 0 ≤ w π)
    (he : fullMatrix *ᵥ w = fullValue obstructedData) : False := by
  apply forced_pair_exceeds_singleton w hw
  · have h := congrFun he (allPatterns 5)
    rw [obstructed_fullValue] at h
    exact h
  · have h := congrFun he (allPatterns 0)
    rw [obstructed_fullValue] at h
    exact h

-- Actual signed control at its negative coefficient; no global classification.
private theorem obstructed_signed_negative :
    sparse (1/8) (3/8) (3/8) (3/8) (-1/4) singlePartition = -1/4 := by
  have hwhole : wholePartition ≠ singlePartition := by
    intro h
    have he := congrArg (fullMatrix wholePattern) h
    norm_num at he
  have hsplit (i : Fin 3) : splitPartition i ≠ singlePartition := by
    intro h
    have he := congrArg (fullMatrix (pairPattern i)) h
    simp at he
  simp [sparse, Ne.symm hwhole, fun i => Ne.symm (hsplit i)]

private def sharedFullValues : Fin 7 → ℝ := ![1/3,1/3,1,2/3,0,0,0]

private theorem shared_absent (j : Fin 7) (hj : j = 4 ∨ j = 5 ∨ j = 6) :
    allPatterns j ∉ sharedData.patterns := by
  intro hp
  obtain ⟨i,_,hi⟩ := Finset.mem_image.mp hp
  have h0 := congrArg (fun p : A => (0 : Fin 3) ∈ p.val) hi
  have h1 := congrArg (fun p : A => (1 : Fin 3) ∈ p.val) hi
  have h2 := congrArg (fun p : A => (2 : Fin 3) ∈ p.val) hi
  fin_cases j <;> fin_cases i <;> first
    | (solve | norm_num at hj)
    | (solve | norm_num [sharedPatterns, allPatterns, singlePattern, pairPattern, wholePattern,
        -Fin.val_eq_zero_iff] at h0)
    | (solve | norm_num [sharedPatterns, allPatterns, singlePattern, pairPattern, wholePattern,
        -Fin.val_eq_zero_iff] at h1)
    | (solve | norm_num [sharedPatterns, allPatterns, singlePattern, pairPattern, wholePattern,
        -Fin.val_eq_zero_iff] at h2)

private theorem shared_fullValue (j : Fin 7) :
    fullValue sharedData (allPatterns j) = sharedFullValues j := by
  fin_cases j
  · exact fullValue_dataOfList_at sharedPatterns sharedPatterns_injective sharedValues _ _ 0
  · exact fullValue_dataOfList_at sharedPatterns sharedPatterns_injective sharedValues _ _ 1
  · exact fullValue_dataOfList_at sharedPatterns sharedPatterns_injective sharedValues _ _ 2
  · exact fullValue_dataOfList_at sharedPatterns sharedPatterns_injective sharedValues _ _ 3
  · exact fullValue_of_not_mem _ _ (shared_absent 4 (by simp))
  · exact fullValue_of_not_mem _ _ (shared_absent 5 (by simp))
  · exact fullValue_of_not_mem _ _ (shared_absent 6 (by simp))

private theorem shared_full_solution :
    fullMatrix *ᵥ sparse 0 (2/3) 0 0 (1/3) = fullValue sharedData := by
  ext p
  obtain ⟨j,rfl⟩ := allPatterns_surjective p
  rw [shared_fullValue]
  fin_cases j <;> rw [sparse_mulVec] <;> norm_num [allPatterns, sharedFullValues]

private theorem sparse_nonneg {a b c d e : ℝ} (ha : 0 ≤ a) (hb : 0 ≤ b)
    (hc : 0 ≤ c) (hd : 0 ≤ d) (he : 0 ≤ e) (π : Q) :
    0 ≤ sparse a b c d e π := by
  have hn (q : Q) (x : ℝ) (hx : 0 ≤ x) : 0 ≤ (Pi.single q x : Q → ℝ) π := by
    by_cases h : π = q
    · subst π; simpa using hx
    · simp [Pi.single_eq_of_ne h]
  exact add_nonneg (add_nonneg (add_nonneg (add_nonneg
    (hn _ _ ha) (hn _ _ hb)) (hn _ _ hc)) (hn _ _ hd)) (hn _ _ he)

example (π : Q) : 0 ≤ sparse 0 (2/3) 0 0 (1/3) π :=
  sparse_nonneg (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) π

private theorem partition_eq_singles_of_parts (π : Q)
    (hb : ∀ b ∈ π.parts, ∃ i : Fin 3, b = {i}) : π = singlePartition := by
  apply Finpartition.ext
  ext b
  rw [singlePartition_mem]
  constructor
  · intro hm
    obtain ⟨i, rfl⟩ := hb b hm
    exact ⟨i, rfl⟩
  · rintro ⟨i, rfl⟩
    obtain ⟨c,hc,hic⟩ := π.exists_mem (Finset.mem_univ i)
    obtain ⟨j,rfl⟩ := hb c hc
    have he : i = j := Finset.mem_singleton.mp hic
    simpa only [he] using hc

private theorem shared_admissible_single : IsAdmissible sharedData singlePartition := by
  intro b
  obtain ⟨i,hi⟩ := (singlePartition_mem b.val).mp b.property
  have he : (⟨b.val, singlePartition.nonempty_of_mem_parts b.property⟩ : A) = singlePattern i :=
    Subtype.ext hi.symm
  rw [he]
  fin_cases i
  · exact Finset.mem_image.mpr ⟨0,Finset.mem_univ _,rfl⟩
  · exact Finset.mem_image.mpr ⟨1,Finset.mem_univ _,rfl⟩
  · exact Finset.mem_image.mpr ⟨2,Finset.mem_univ _,rfl⟩

private theorem shared_admissible_split : IsAdmissible sharedData (splitPartition 2) := by
  intro b
  have hb := b.property
  simp only [splitPartition_parts, Finset.mem_insert, Finset.mem_singleton] at hb
  rcases hb with hb | hb
  · apply Finset.mem_image.mpr
    refine ⟨3,Finset.mem_univ _,Subtype.ext hb.symm⟩
  · apply Finset.mem_image.mpr
    refine ⟨2,Finset.mem_univ _,Subtype.ext hb.symm⟩

private theorem shared_only_partitions (π : AdmissiblePartition sharedData) :
    π.val = splitPartition 2 ∨ π.val = singlePartition := by
  by_cases hp : Finset.univ.erase (2 : Fin 3) ∈ π.val.parts
  · exact Or.inl (partition_eq_split_of_pair π.val 2 hp)
  right
  apply partition_eq_singles_of_parts
  intro b hb
  obtain ⟨j,_,hj⟩ := Finset.mem_image.mp (π.property ⟨b,hb⟩)
  have he := congrArg Subtype.val hj
  fin_cases j
  · exact ⟨0,he.symm⟩
  · exact ⟨1,he.symm⟩
  · exact ⟨2,he.symm⟩
  · have he' : Finset.univ.erase (2 : Fin 3) = b := he
    exact False.elim (hp (he'.symm ▸ hb))

private theorem split_ne_single (i : Fin 3) : splitPartition i ≠ singlePartition := by
  intro h
  have he := congrArg (fullMatrix (pairPattern i)) h
  simp at he

private def sharedLabel (i : Fin 2) : AdmissiblePartition sharedData :=
  if i = 0 then ⟨splitPartition 2, shared_admissible_split⟩
  else ⟨singlePartition,shared_admissible_single⟩

private theorem sharedLabel_injective : Function.Injective sharedLabel := by
  intro i j h
  have he := congrArg Subtype.val h
  fin_cases i <;> fin_cases j <;> try rfl
  · have hc : splitPartition 2 = singlePartition := by simpa [sharedLabel] using he
    exact False.elim (split_ne_single 2 hc)
  · have hc : singlePartition = splitPartition 2 := by simpa [sharedLabel] using he
    exact False.elim (split_ne_single 2 hc.symm)

private def sharedEnumeration : Fin 2 ≃ AdmissiblePartition sharedData :=
  Equiv.ofBijective sharedLabel ⟨sharedLabel_injective, by
    intro π
    rcases shared_only_partitions π with h | h
    · exact ⟨0,Subtype.ext (by simpa [sharedLabel] using h.symm)⟩
    · exact ⟨1,Subtype.ext (by simpa [sharedLabel] using h.symm)⟩⟩

example : Fintype.card (AdmissiblePartition sharedData) = 2 := by
  simpa using (Fintype.card_congr sharedEnumeration).symm

example : Fintype.card (OccurringPattern sharedData) = 4 := by
  exact (Fintype.card_congr (listLabels sharedPatterns sharedPatterns_injective)).symm


private theorem r05Pattern_complement (j : Fin 3) : r05Patterns j = pairPattern (![2,1,0] j) := by
  apply Subtype.ext
  ext x
  fin_cases j <;> fin_cases x <;>
    norm_num [r05Patterns, pairPattern, Matrix.cons_val_two, Matrix.cons_val_one,
      Matrix.cons_val_zero]

private theorem split_injective : Function.Injective splitPartition := by
  intro i j h
  have he := congrArg (fullMatrix (pairPattern i)) h
  by_contra hij
  simp [hij] at he

private theorem whole_ne_single : wholePartition ≠ singlePartition := by
  intro h
  have he := congrArg (fullMatrix wholePattern) h
  simp at he

private theorem whole_ne_split (i : Fin 3) : wholePartition ≠ splitPartition i := by
  intro h
  have he := congrArg (fullMatrix wholePattern) h
  simp at he

private theorem sparse_at_single (a b c d e : ℝ) : sparse a b c d e singlePartition = e := by
  simp [sparse, Pi.single_eq_of_ne (whole_ne_single.symm),
    Pi.single_eq_of_ne (split_ne_single 2).symm,
    Pi.single_eq_of_ne (split_ne_single 1).symm,
    Pi.single_eq_of_ne (split_ne_single 0).symm]

private theorem sparse_at_split (a b c d e : ℝ) (i : Fin 3) :
    sparse a b c d e (splitPartition i) = ![d,c,b] i := by
  fin_cases i <;>
    simp [sparse, Pi.single_eq_of_ne (whole_ne_split _).symm,
      Pi.single_eq_of_ne (split_ne_single _), split_injective.eq_iff]

private theorem r06_mixed_solution :
    (fun (p : OccurringPattern r05Data) (π : Q) => fullMatrix p.val π) *ᵥ
      sparse 0 (1/2) (1/2) (1/2) 0 = r05Data.value := by
  ext p
  rw [r05Data_value]
  obtain ⟨j,rfl⟩ := r05Enumeration.surjective p
  change (fullMatrix *ᵥ sparse 0 (1/2) (1/2) (1/2) 0) (r05Output j).val = _
  rw [r05Output_val,r05Pattern_complement,sparse_mulVec]
  fin_cases j <;> norm_num [Matrix.cons_val_two,Matrix.cons_val_one,Matrix.cons_val_zero]

private theorem r06_sum : (∑ π, sparse 0 (1/2) (1/2) (1/2) 0 π) = 3/2 := by
  rw [sparse_sum]
  norm_num

private theorem r06_bounds (π : Q) :
    0 ≤ sparse 0 (1/2) (1/2) (1/2) 0 π ∧
      sparse 0 (1/2) (1/2) (1/2) 0 π ≤ 1 := by
  constructor
  · exact sparse_nonneg (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) π
  by_cases h2 : π = splitPartition 2
  · subst π; rw [sparse_at_split]; change (1/2 : ℝ) ≤ 1; norm_num
  by_cases h1 : π = splitPartition 1
  · subst π; rw [sparse_at_split]; change (1/2 : ℝ) ≤ 1; norm_num
  by_cases h0 : π = splitPartition 0
  · subst π; rw [sparse_at_split]; change (1/2 : ℝ) ≤ 1; norm_num
  simp [sparse, Pi.single_eq_of_ne h2, Pi.single_eq_of_ne h1, Pi.single_eq_of_ne h0]

private theorem r05_fullValue_all (j : Fin 7) : fullValue r05Data (allPatterns j) =
    ![0,0,0,1/2,1/2,1/2,0] j := by
  rw [r05FullValue_eq]
  fin_cases j <;>
    norm_num [allPatterns, r05Patterns, pairPattern, singlePattern, wholePattern,
      Matrix.cons_val_two,Matrix.cons_val_one,Matrix.cons_val_zero,
      Subtype.ext_iff, Finset.ext_iff, Fin.forall_fin_succ, -Fin.val_eq_zero_iff]

private theorem r07_signed_full :
    fullMatrix *ᵥ sparse 0 (1/2) (1/2) (1/2) (-1/2) = fullValue r05Data := by
  ext p
  obtain ⟨j,rfl⟩ := allPatterns_surjective p
  rw [r05_fullValue_all]
  fin_cases j <;> rw [sparse_mulVec] <;> norm_num [allPatterns]
example : sparse 0 (1/2) (1/2) (1/2) (-1/2) singlePartition = -1/2 :=
  sparse_at_single _ _ _ _ _

example (w : AdmissiblePartition r05Data → ℝ) : reducedMatrix r05Data *ᵥ w ≠ r05Data.value :=
  not_reduced_eq_of_isEmpty r05Data w

private theorem shared_fullFeasible : FullFeasible sharedData (sparse 0 (2/3) 0 0 (1/3)) :=
  ⟨sparse_nonneg (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num),
    shared_full_solution⟩

private theorem shared_reducedFeasible :
    Feasible sharedData (restrictWeights sharedData (sparse 0 (2/3) 0 0 (1/3))) :=
  feasible_restrictWeights sharedData shared_fullFeasible

example : extendWeights sharedData (restrictWeights sharedData (sparse 0 (2/3) 0 0 (1/3))) =
    sparse 0 (2/3) 0 0 (1/3) := extend_restrictWeights sharedData shared_fullFeasible

example (i : Fin 2) : restrictWeights sharedData (sparse 0 (2/3) 0 0 (1/3))
    (sharedEnumeration i) = ![2/3,1/3] i := by
  change sparse 0 (2/3) 0 0 (1/3) (sharedLabel i).val = _
  fin_cases i
  · change sparse 0 (2/3) 0 0 (1/3) (splitPartition 2) = _
    rw [sparse_at_split]
    change (2/3 : ℝ) = 2/3
    rfl
  · change sparse 0 (2/3) 0 0 (1/3) singlePartition = _
    rw [sparse_at_single]
    norm_num

example : ¬ ∃ w, FullFeasible obstructedData w := by
  rintro ⟨w,hw⟩
  exact obstructed_no_nonnegative_solution w hw.1 hw.2

example : ¬ ∃ w, Feasible obstructedData w := by
  rintro ⟨w,hw⟩
  have hf := fullFeasible_extendWeights obstructedData hw
  exact obstructed_no_nonnegative_solution _ hf.1 hf.2

example (i : Fin 4) (j : Fin 2) :
    reducedMatrix sharedData ((listLabels sharedPatterns sharedPatterns_injective) i)
      (sharedEnumeration j) = ![![0,1],![0,1],![1,1],![1,0]] i j := by
  change fullMatrix (sharedPatterns i) (sharedLabel j).val = _
  fin_cases i <;> fin_cases j <;> norm_num [sharedPatterns,sharedLabel]

example : (reducedMatrix sharedData *ᵥ
    restrictWeights sharedData (sparse 0 (2/3) 0 0 (1/3)))
      ((listLabels sharedPatterns sharedPatterns_injective) 2) = 1 := by
  rw [shared_reducedFeasible.2]
  exact dataOfList_value sharedPatterns sharedPatterns_injective sharedValues _ _ 2
/-! S03 R13: explicit decoder law and common posterior on the existing data. -/
private abbrev s03O := OccurringPattern sharedData
private abbrev s03W := Fin 3 → s03O
private def s03Labels : Fin 4 ≃ s03O := listLabels sharedPatterns sharedPatterns_injective
private def s03F : s03W := fun x => s03Labels (Fin.castSucc x)
private def s03G : s03W := fun x => if x = 2 then s03Labels 2 else s03Labels 3
private def s03Z : s03W := fun _ => s03Labels 0

private theorem s03F_ne_G : s03F ≠ s03G := by
  intro h
  have he := s03Labels.injective (show s03Labels 0 = s03Labels 3 from by
    simpa [s03F,s03G,s03Z] using congrFun h 0)
  norm_num at he
private theorem s03Z_ne_F : s03Z ≠ s03F := by
  intro h
  have he := s03Labels.injective (show s03Labels 0 = s03Labels 1 from congrFun h 1)
  norm_num at he
private theorem s03Z_ne_G : s03Z ≠ s03G := by
  intro h
  have he := s03Labels.injective (show s03Labels 0 = s03Labels 3 from by
    simpa [s03F,s03G,s03Z] using congrFun h 0)
  norm_num at he

private def s03Weights : Fin 3 → NNReal := ![1/3,2/3,0]
private theorem s03Weights_sum : ∑ i, s03Weights i = 1 := by
  norm_num [s03Weights,Fin.sum_univ_succ]
private def s03IndexLaw : PMF (Fin 3) :=
  PMF.ofFintype (fun i => (s03Weights i : ENNReal)) (by exact_mod_cast s03Weights_sum)
private def s03Q : PMF s03W := s03IndexLaw.map (![s03F,s03G,s03Z] : Fin 3 → s03W)

private theorem s03Q_apply (w : s03W) :
    s03Q w = (if w = s03F then (1/3 : ENNReal) else 0) +
      (if w = s03G then (2/3 : ENNReal) else 0) := by
  unfold s03Q
  rw [PMF.map_apply]
  simp [s03IndexLaw,tsum_fintype,Fin.sum_univ_succ,s03Weights,eq_comm]
private theorem s03Q_f : s03Q s03F = 1/3 := by simp [s03Q_apply,s03F_ne_G]
private theorem s03Q_g : s03Q s03G = 2/3 := by simp [s03Q_apply,s03F_ne_G.symm]
private theorem s03Q_z : s03Q s03Z = 0 := by simp [s03Q_apply,s03Z_ne_F,s03Z_ne_G]

private def s03V (p : s03O) : PMF s03W :=
  if p = s03Labels 2 then s03Q else if p = s03Labels 3 then PMF.pure s03G else PMF.pure s03F

private theorem s03V_f (j : Fin 4) :
    s03V (s03Labels j) s03F = if j = 2 then 1/3 else if j = 3 then 0 else 1 := by
  fin_cases j <;> simp [s03V,s03Labels.injective.eq_iff,s03Q_f,s03F_ne_G]
private theorem s03V_g (j : Fin 4) :
    s03V (s03Labels j) s03G = if j = 2 then 2/3 else if j = 3 then 1 else 0 := by
  fin_cases j <;> simp [s03V,s03Labels.injective.eq_iff,s03Q_g,s03F_ne_G.symm]
private theorem s03V_other (j : Fin 4) (w : s03W) (hf : w ≠ s03F) (hg : w ≠ s03G) :
    s03V (s03Labels j) w = 0 := by
  fin_cases j <;> simp [s03V,s03Labels.injective.eq_iff,s03Q_apply,hf,hg]

private theorem s03Channel (x : Fin 3) (j : Fin 4) :
    sharedData.channel x (s03Labels j) =
      if x ∈ (sharedPatterns j).val then ENNReal.ofReal (sharedValues j) else 0 := by
  rw [CompressedPatternData.channel_apply]
  change (if x ∈ (sharedPatterns j).val then
    ENNReal.ofReal (sharedData.value (s03Labels j)) else 0) = _
  rw [show sharedData.value (s03Labels j) = sharedValues j from
    dataOfList_value sharedPatterns sharedPatterns_injective sharedValues _ _ j]

private theorem s03Coord (x : Fin 3) (p : s03O) (w : s03W) :
    s03Q.map (fun f => (f x,f)) (p,w) =
      (if (s03F x,s03F) = (p,w) then (1/3 : ENNReal) else 0) +
      (if (s03G x,s03G) = (p,w) then (2/3 : ENNReal) else 0) := by
  rw [s03Q,PMF.map_comp,PMF.map_apply]
  simp [s03IndexLaw,tsum_fintype,Fin.sum_univ_succ,s03Weights,eq_comm]

private theorem s03Factor (x : Fin 3) :
    s03Q.map (fun f => (f x,f)) = PMF.channelJoint (sharedData.channel x) s03V := by
  apply PMF.ext
  rintro ⟨p,w⟩
  obtain ⟨j,rfl⟩ := s03Labels.surjective p
  rw [s03Coord,PMF.channelJoint_apply,s03Channel]
  by_cases hf : w = s03F
  · subst w
    rw [s03V_f]
    fin_cases x <;> fin_cases j <;>
      norm_num [s03F,s03G,s03F_ne_G,s03F_ne_G.symm,s03Labels.injective.eq_iff,
        sharedPatterns,sharedValues,singlePattern,pairPattern,Fin.ext_iff,
        ENNReal.ofReal_div_of_pos,
        -Fin.val_eq_zero_iff,Matrix.cons_val_two]
  · by_cases hg : w = s03G
    · subst w
      rw [s03V_g]
      fin_cases x <;> fin_cases j <;>
        norm_num [s03F,s03G,s03F_ne_G,s03F_ne_G.symm,s03Labels.injective.eq_iff,
          sharedPatterns,sharedValues,singlePattern,pairPattern,Fin.ext_iff,
        ENNReal.ofReal_div_of_pos,
          -Fin.val_eq_zero_iff,Matrix.cons_val_two]
    · rw [s03V_other j w hf hg]
      simp [Ne.symm hf,Ne.symm hg]

private theorem s03Perfect : IsPerfectlyRepresentableChannel sharedData.channel :=
  ⟨s03Q,s03V,s03Factor⟩

example : s03V (s03Labels 2) = s03Q := by simp [s03V]
example : s03V (s03Labels 2) s03F = 1/3 := by rw [s03V_f]; norm_num
example : s03V (s03Labels 2) s03G = 2/3 := by rw [s03V_g]; norm_num
example : s03IndexLaw 2 = 0 := by norm_num [s03IndexLaw,s03Weights,Matrix.cons_val_two]
example : s03Z ∉ s03Q.support := by simp [PMF.mem_support_iff,s03Q_z]
example (p : s03O) : s03V p s03Z = 0 := by
  obtain ⟨j,rfl⟩ := s03Labels.surjective p
  exact s03V_other j s03Z s03Z_ne_F s03Z_ne_G
example : s03F ∈ s03Q.support ∧ s03G ∈ s03Q.support := by
  simp [PMF.mem_support_iff,s03Q_f,s03Q_g]

-- Exact shared block and distinct complete decoder images.
example : Finset.univ.filter (fun x : Fin 3 => s03F x = s03Labels 2) = {2} := by
  ext x
  fin_cases x <;> simp [s03F,s03Labels.injective.eq_iff]
example : Finset.univ.filter (fun x : Fin 3 => s03G x = s03Labels 2) = {2} := by
  ext x
  fin_cases x <;> simp [s03G,s03Labels.injective.eq_iff]
example : Finset.univ.filter (fun x : Fin 3 => s03G x = s03Labels 3) = {0,1} := by
  ext x
  fin_cases x <;> simp [s03G,s03Labels.injective.eq_iff]
example : s03Q s03F + s03Q s03G = sharedData.channel 2 (s03Labels 2) := by
  have hc : sharedData.channel 2 (s03Labels 2) = 1 := by
    rw [s03Channel]
    norm_num [sharedPatterns,sharedValues,singlePattern,Matrix.cons_val_two]
  rw [s03Q_f,s03Q_g,hc]
  rw [ENNReal.div_add_div_same]
  norm_num
  exact ENNReal.div_self (by norm_num) (by norm_num)

-- A zero-mass decoder need not satisfy the supported-decoder fiber contract.
example : Finset.univ.filter (fun x : Fin 3 => s03Z x = s03Labels 0) = Finset.univ := by
  simp [s03Z]
example : Finset.univ.filter (fun x : Fin 3 => s03Z x = s03Labels 0) ≠
    (s03Labels 0).val.val := by
  intro h
  have hone : (1 : Fin 3) ∈ Finset.univ.filter
      (fun x : Fin 3 => s03Z x = s03Labels 0) := by simp [s03Z]
  rw [h] at hone
  change (1 : Fin 3) ∈ {(0 : Fin 3)} at hone
  norm_num at hone

private theorem s03ReducedRow (w : AdmissiblePartition sharedData → ℝ) (j : Fin 4) :
    (reducedMatrix sharedData *ᵥ w) (s03Labels j) =
      fullMatrix (sharedPatterns j) (splitPartition 2) * w (sharedEnumeration 0) +
      fullMatrix (sharedPatterns j) singlePartition * w (sharedEnumeration 1) := by
  change (∑ π : AdmissiblePartition sharedData, reducedMatrix sharedData (s03Labels j) π * w π) = _
  rw [← sharedEnumeration.sum_comp]
  rw [Fin.sum_univ_two]
  rfl

private theorem s03FeasibleWeights {w : AdmissiblePartition sharedData → ℝ}
    (hw : Feasible sharedData w) :
    w = restrictWeights sharedData (sparse 0 (2/3) 0 0 (1/3)) := by
  have hs := congrFun hw.2 (s03Labels 0)
  have hp := congrFun hw.2 (s03Labels 3)
  rw [s03ReducedRow,
    show sharedData.value (s03Labels 0) = sharedValues 0 from
      dataOfList_value sharedPatterns sharedPatterns_injective sharedValues _ _ 0] at hs
  rw [s03ReducedRow,
    show sharedData.value (s03Labels 3) = sharedValues 3 from
      dataOfList_value sharedPatterns sharedPatterns_injective sharedValues _ _ 3] at hp
  have hs' : w (sharedEnumeration 1) = 1/3 := by
    simpa [sharedPatterns,sharedValues] using hs
  have hp' : w (sharedEnumeration 0) = 2/3 := by
    simpa [sharedPatterns,sharedValues] using hp
  funext π
  obtain ⟨i,rfl⟩ := sharedEnumeration.surjective π
  fin_cases i
  · change w (sharedEnumeration 0) = sparse 0 (2/3) 0 0 (1/3) (splitPartition 2)
    rw [hp']
    rw [sparse_at_split]
    rfl
  · change w (sharedEnumeration 1) = sparse 0 (2/3) 0 0 (1/3) singlePartition
    rw [hs']
    exact (sparse_at_single _ _ _ _ _).symm

private theorem s03SharedRowForWitness {w : AdmissiblePartition sharedData → ℝ}
    (hw : Feasible sharedData w) :
    w (sharedEnumeration 1) = 1/3 ∧ w (sharedEnumeration 0) = 2/3 ∧
      (reducedMatrix sharedData *ᵥ w) (s03Labels 2) =
        w (sharedEnumeration 1) + w (sharedEnumeration 0) ∧
      w (sharedEnumeration 1) + w (sharedEnumeration 0) = 1 := by
  have he := s03FeasibleWeights hw
  have hs : w (sharedEnumeration 1) = 1/3 := by
    rw [he]
    exact sparse_at_single _ _ _ _ _
  have hp : w (sharedEnumeration 0) = 2/3 := by
    rw [he]
    change sparse 0 (2/3) 0 0 (1/3) (splitPartition 2) = 2/3
    rw [sparse_at_split]
    rfl
  refine ⟨hs,hp,?_,by rw [hs,hp]; norm_num⟩
  rw [s03ReducedRow]
  simp [sharedPatterns,Matrix.cons_val_two,add_comm]

-- The same witness returned by public necessity has the prescribed R13 masses.
example : ∃ w, Feasible sharedData w ∧
    w = restrictWeights sharedData (sparse 0 (2/3) 0 0 (1/3)) ∧
    w (sharedEnumeration 1) = 1/3 ∧ w (sharedEnumeration 0) = 2/3 ∧
    (reducedMatrix sharedData *ᵥ w) (s03Labels 2) =
      w (sharedEnumeration 1) + w (sharedEnumeration 0) ∧
    w (sharedEnumeration 1) + w (sharedEnumeration 0) = 1 := by
  obtain ⟨w,hw⟩ := exists_feasible_of_isPerfectlyRepresentableChannel sharedData s03Perfect
  exact ⟨w,hw,s03FeasibleWeights hw,s03SharedRowForWitness hw⟩

example : ∃ w, FullFeasible sharedData w :=
  exists_fullFeasible_of_isPerfectlyRepresentableChannel sharedData s03Perfect

-- An independent consumer of necessity rejects the public C03/C12 datum.
example : ¬ IsPerfectlyRepresentableChannel r05Data.channel := by
  intro h
  obtain ⟨w,hw⟩ := exists_feasible_of_isPerfectlyRepresentableChannel r05Data h
  exact not_reduced_eq_of_isEmpty r05Data w hw.2


/-! S04 concrete input-side cardinalities and labelled shared leaves. -/
private abbrev r13Weights := restrictWeights sharedData (sparse 0 (2/3) 0 0 (1/3))
private theorem r13Weight (i : Fin 2) : r13Weights (sharedEnumeration i) = ![2/3,1/3] i := by
  fin_cases i
  · change sparse 0 (2/3) 0 0 (1/3) (splitPartition 2) = _
    rw [sparse_at_split]
    rfl
  · exact sparse_at_single _ _ _ _ _
private theorem r13Weight_pos (π : AdmissiblePartition sharedData) : 0 < r13Weights π := by
  obtain ⟨i,rfl⟩ := sharedEnumeration.surjective π
  rw [r13Weight]
  fin_cases i <;> norm_num
private def r13PositiveEquiv : Fin 2 ≃ PositivePartition sharedData r13Weights where
  toFun i := ⟨sharedEnumeration i,r13Weight_pos _⟩
  invFun p := sharedEnumeration.symm p.val
  left_inv i := sharedEnumeration.symm_apply_apply i
  right_inv p := Subtype.ext (sharedEnumeration.apply_symm_apply p.val)
private theorem r13Positive_card : Fintype.card (PositivePartition sharedData r13Weights) = 2 :=
  (Fintype.card_congr r13PositiveEquiv).symm.trans (Fintype.card_fin 2)
private theorem r13Parts_single : singlePartition.parts.card = 3 := by
  simp [singlePartition]
private theorem r13Parts_split (i : Fin 3) : (splitPartition i).parts.card = 2 := by
  fin_cases i <;>
    norm_num [splitPartition_parts,Finset.ext_iff,Fin.forall_fin_succ,-Fin.val_eq_zero_iff]
private theorem r13Blocks_card :
    Fintype.card ((π : PositivePartition sharedData r13Weights) × π.val.val.parts) = 5 := by
  rw [Fintype.card_sigma, ← r13PositiveEquiv.sum_comp, Fin.sum_univ_two]
  simp only [Fintype.card_coe]
  change (splitPartition 2).parts.card + singlePartition.parts.card = 5
  rw [r13Parts_split,r13Parts_single]
private def r13PairLeaf : (π : PositivePartition sharedData r13Weights) × π.val.val.parts :=
  ⟨r13PositiveEquiv 0,⟨{2},by change {(2 : Fin 3)} ∈ (splitPartition 2).parts; simp⟩⟩
private def r13SingletonLeaf : (π : PositivePartition sharedData r13Weights) × π.val.val.parts :=
  ⟨r13PositiveEquiv 1,⟨{2},by
    change {(2 : Fin 3)} ∈ singlePartition.parts
    exact (singlePartition_mem _).mpr ⟨2,rfl⟩⟩⟩
private theorem r13Leaves_ne : r13PairLeaf ≠ r13SingletonLeaf := by
  intro h
  have he := congrArg Sigma.fst h
  have hh : (0 : Fin 2) = 1 := r13PositiveEquiv.injective he
  norm_num at hh
private theorem r13PairLeaf_pattern : positiveBlockPattern sharedData r13Weights r13PairLeaf =
    s03Labels 2 := rfl
private theorem r13SingletonLeaf_pattern :
    positiveBlockPattern sharedData r13Weights r13SingletonLeaf =
    s03Labels 2 := rfl
private theorem r13PairLeaf_weight : r13Weights r13PairLeaf.1.val = 2/3 := r13Weight 0
private theorem r13SingletonLeaf_weight : r13Weights r13SingletonLeaf.1.val = 1/3 := r13Weight 1

private def r09Data : CompressedPatternData (Fin 3) :=
  dataOfList allPatterns allPatterns_injective (fun _ => 1/4)
    (by intro j; norm_num)
    (by intro x; fin_cases x <;>
      norm_num [Fin.sum_univ_succ,allPatterns,singlePattern,pairPattern,wholePattern])
private theorem r09All_mem (p : A) : p ∈ r09Data.patterns := by
  obtain ⟨j,rfl⟩ := allPatterns_surjective p
  exact Finset.mem_image.mpr ⟨j,Finset.mem_univ _,rfl⟩
private theorem r09All_admissible (π : Q) : IsAdmissible r09Data π := fun _ => r09All_mem _
private theorem r09FullValue (j : Fin 7) : fullValue r09Data (allPatterns j) = 1/4 :=
  fullValue_dataOfList_at _ _ _ _ _ j
private theorem r09Full_solution :
    fullMatrix *ᵥ sparse (1/4) (1/4) (1/4) (1/4) 0 = fullValue r09Data := by
  ext p
  obtain ⟨j,rfl⟩ := allPatterns_surjective p
  rw [r09FullValue]
  fin_cases j <;> rw [sparse_mulVec] <;> norm_num [allPatterns]
private theorem r09Full_feasible : FullFeasible r09Data (sparse (1/4) (1/4) (1/4) (1/4) 0) :=
  ⟨sparse_nonneg (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num),
    r09Full_solution⟩
private abbrev r09Weights := restrictWeights r09Data (sparse (1/4) (1/4) (1/4) (1/4) 0)
private theorem r09Feasible : Feasible r09Data r09Weights :=
  feasible_restrictWeights r09Data r09Full_feasible
private def r09Labels : Fin 7 ≃ OccurringPattern r09Data :=
  listLabels allPatterns allPatterns_injective
private theorem r09Value (i : Fin 7) : r09Data.value (r09Labels i) = 1/4 :=
  dataOfList_value _ _ _ _ _ i
private theorem r09Patterns_card : Fintype.card (OccurringPattern r09Data) = 7 :=
  (Fintype.card_congr r09Labels).symm.trans (Fintype.card_fin 7)
private theorem r09Singleton_zero : r09Weights ⟨singlePartition,r09All_admissible _⟩ = 0 :=
  sparse_at_single _ _ _ _ _
private theorem r09Singleton_not_positive :
    ¬ 0 < r09Weights ⟨singlePartition,r09All_admissible _⟩ := by
  rw [r09Singleton_zero]
  exact lt_irrefl _
private theorem sparse_at_whole (a b c d e : ℝ) : sparse a b c d e wholePartition = a := by
  simp [sparse,Pi.single_eq_of_ne (whole_ne_split 2),Pi.single_eq_of_ne (whole_ne_split 1),
    Pi.single_eq_of_ne (whole_ne_split 0),Pi.single_eq_of_ne whole_ne_single]
private def r09Partitions : Fin 4 → Q :=
  ![wholePartition,splitPartition 2,splitPartition 1,splitPartition 0]
private theorem r09Partition_weight (i : Fin 4) :
    sparse (1/4) (1/4) (1/4) (1/4) 0 (r09Partitions i) = 1/4 := by
  fin_cases i
  · exact sparse_at_whole _ _ _ _ _
  · change sparse (1/4) (1/4) (1/4) (1/4) 0 (splitPartition 2) = 1/4
    rw [sparse_at_split]
    rfl
  · change sparse (1/4) (1/4) (1/4) (1/4) 0 (splitPartition 1) = 1/4
    rw [sparse_at_split]
    rfl
  · change sparse (1/4) (1/4) (1/4) (1/4) 0 (splitPartition 0) = 1/4
    rw [sparse_at_split]
    rfl
private def r09PositiveLabel (i : Fin 4) : PositivePartition r09Data r09Weights :=
  ⟨⟨r09Partitions i,r09All_admissible _⟩,by
    change 0 < sparse (1/4) (1/4) (1/4) (1/4) 0 (r09Partitions i)
    rw [r09Partition_weight]
    norm_num⟩
private theorem r09Positive_injective : Function.Injective r09PositiveLabel := by
  intro i j h
  have he := congrArg (fun p : PositivePartition r09Data r09Weights => p.val.val) h
  change r09Partitions i = r09Partitions j at he
  fin_cases i <;> fin_cases j <;> try rfl
  all_goals simp [r09Partitions,whole_ne_split,Ne.symm (whole_ne_split _),split_injective.eq_iff,
    Matrix.cons_val_two] at he
private theorem r09Positive_surjective : Function.Surjective r09PositiveLabel := by
  intro p
  by_cases h0 : p.val.val = wholePartition
  · exact ⟨0,Subtype.ext (Subtype.ext h0.symm)⟩
  by_cases h1 : p.val.val = splitPartition 2
  · exact ⟨1,Subtype.ext (Subtype.ext h1.symm)⟩
  by_cases h2 : p.val.val = splitPartition 1
  · exact ⟨2,Subtype.ext (Subtype.ext h2.symm)⟩
  by_cases h3 : p.val.val = splitPartition 0
  · exact ⟨3,Subtype.ext (Subtype.ext h3.symm)⟩
  have hp := p.property
  change 0 < sparse (1/4) (1/4) (1/4) (1/4) 0 p.val.val at hp
  simp [sparse,Pi.single_eq_of_ne h0,Pi.single_eq_of_ne h1,Pi.single_eq_of_ne h2,
    Pi.single_eq_of_ne h3] at hp
private def r09PositiveEquiv : Fin 4 ≃ PositivePartition r09Data r09Weights :=
  Equiv.ofBijective r09PositiveLabel ⟨r09Positive_injective,r09Positive_surjective⟩
private theorem r09Positive_card : Fintype.card (PositivePartition r09Data r09Weights) = 4 :=
  (Fintype.card_congr r09PositiveEquiv).symm.trans (Fintype.card_fin 4)
private theorem r09Blocks_card :
    Fintype.card ((π : PositivePartition r09Data r09Weights) × π.val.val.parts) = 7 := by
  rw [Fintype.card_sigma, ← r09PositiveEquiv.sum_comp]
  simp only [Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  simp only [Fintype.card_coe]
  change wholePartition.parts.card + ((splitPartition 2).parts.card +
    ((splitPartition 1).parts.card + (splitPartition 0).parts.card)) = 7
  rw [r13Parts_split,r13Parts_split,r13Parts_split]
  norm_num [wholePartition_parts]

private def r13Rotate : Fin 4 ≃ Fin 4 :=
  ((Equiv.swap 0 1).trans (Equiv.swap 1 2)).trans (Equiv.swap 2 3)
private theorem r13Rotate_zero : r13Rotate 0 = 3 ∧ r13Rotate.symm 0 = 1 := by
  norm_num [r13Rotate,Equiv.swap_apply_def]
private def r13Enumeration : OccurringPattern sharedData ≃ Fin 4 := s03Labels.symm.trans r13Rotate
/-! S04: every assertion uses the same returned three-phase construction. -/
private def r13Construction := partitionConstruction sharedData r13Weights shared_reducedFeasible
private theorem r13Phase_cards : r13Construction.pps.endpoint.outputCard = 2 ∧
    r13Construction.vps.endpoint.outputCard = 5 ∧ r13Construction.ppm.endpoint.outputCard = 4 := by
  refine ⟨r13Construction.pps.outputCard.trans r13Positive_card,
    r13Construction.vps.outputCard.trans r13Blocks_card,?_⟩
  rw [r13Construction.ppm.outputCard]
  exact (Fintype.card_congr s03Labels).symm.trans (Fintype.card_fin 4)
example : r13Construction.pps.path.length = 1 := by
  unfold r13Construction
  rw [partitionConstruction_pps_length,r13Positive_card]
example : r13Construction.ppm.path.length = 1 := by
  unfold r13Construction
  rw [partitionConstruction_ppm_length,r13Blocks_card]
  have hc : Fintype.card (OccurringPattern sharedData) = 4 :=
    (Fintype.card_congr s03Labels).symm.trans (Fintype.card_fin 4)
  rw [hc]
example : r13Construction.vps.labels r13PairLeaf ≠ r13Construction.vps.labels r13SingletonLeaf :=
  fun h => r13Leaves_ne (r13Construction.vps.labels.injective h)
example : positiveBlockPattern sharedData r13Weights
      (r13Construction.vps.labels.symm (r13Construction.vps.labels r13PairLeaf)) =
    positiveBlockPattern sharedData r13Weights
      (r13Construction.vps.labels.symm (r13Construction.vps.labels r13SingletonLeaf)) := by
  rw [Equiv.symm_apply_apply,Equiv.symm_apply_apply,r13PairLeaf_pattern,r13SingletonLeaf_pattern]
private theorem r13Pair_mass (x : Fin 3) :
    r13Construction.vps.endpoint.channel x (r13Construction.vps.labels r13PairLeaf) =
      if x = 2 then 2/3 else 0 := by
  rw [r13Construction.vps.coordinates,r13PairLeaf_weight]
  change (if x ∈ {(2 : Fin 3)} then ENNReal.ofReal (2/3) else 0) = _
  norm_num [ENNReal.ofReal_div_of_pos]
private theorem r13Singleton_mass (x : Fin 3) :
    r13Construction.vps.endpoint.channel x (r13Construction.vps.labels r13SingletonLeaf) =
      if x = 2 then 1/3 else 0 := by
  rw [r13Construction.vps.coordinates,r13SingletonLeaf_weight]
  change (if x ∈ {(2 : Fin 3)} then ENNReal.ofReal (1/3) else 0) = _
  norm_num [ENNReal.ofReal_div_of_pos]
private theorem r13Merged_mass (x : Fin 3) :
    r13Construction.ppm.endpoint.channel x (r13Construction.ppm.labels (s03Labels 2)) =
      if x = 2 then 1 else 0 := by
  rw [r13Construction.ppm.coordinates,s03Channel]
  norm_num [sharedPatterns,sharedValues,singlePattern,Matrix.cons_val_two]
example : r13Construction.vps.endpoint.channel 2 (r13Construction.vps.labels r13PairLeaf) = 2/3 ∧
    r13Construction.vps.endpoint.channel 2 (r13Construction.vps.labels r13SingletonLeaf) = 1/3 ∧
    r13Construction.ppm.endpoint.channel 2 (r13Construction.ppm.labels (s03Labels 2)) = 1 := by
  simp [r13Pair_mass,r13Singleton_mass,r13Merged_mass]
example (x : Fin 3) :
    r13Construction.vps.endpoint.channel x (r13Construction.vps.labels r13PairLeaf) +
      r13Construction.vps.endpoint.channel x (r13Construction.vps.labels r13SingletonLeaf) =
        r13Construction.ppm.endpoint.channel x (r13Construction.ppm.labels (s03Labels 2)) := by
  rw [r13Pair_mass,r13Singleton_mass,r13Merged_mass]
  by_cases hx : x = 2
  · simp only [if_pos hx]
    rw [ENNReal.div_add_div_same]
    norm_num
    exact ENNReal.div_self (by norm_num) (by norm_num)
  · simp [hx]

private def r09Construction := partitionConstruction r09Data r09Weights r09Feasible
private theorem r09Phase_cards : r09Construction.pps.endpoint.outputCard = 4 ∧
    r09Construction.vps.endpoint.outputCard = 7 ∧ r09Construction.ppm.endpoint.outputCard = 7 :=
  ⟨r09Construction.pps.outputCard.trans r09Positive_card,
    r09Construction.vps.outputCard.trans r09Blocks_card,
    r09Construction.ppm.outputCard.trans r09Patterns_card⟩
example : r09Construction.pps.path.length = 3 := by
  unfold r09Construction
  rw [partitionConstruction_pps_length,r09Positive_card]
example : r09Construction.ppm.path.length = 0 := by
  unfold r09Construction
  rw [partitionConstruction_ppm_length,r09Blocks_card,r09Patterns_card]
example (x : Fin 3) (i : Fin 4) :
    r09Construction.pps.endpoint.channel x
      (r09Construction.pps.labels (r09PositiveEquiv i)) = 1/4 := by
  rw [r09Construction.pps.coordinates]
  change ENNReal.ofReal (sparse (1/4) (1/4) (1/4) (1/4) 0 (r09Partitions i)) = _
  rw [r09Partition_weight]
  norm_num [ENNReal.ofReal_div_of_pos]
example (i : Fin 7) : 0 < r09Data.value (r09Labels i) := r09Data.value_pos _
example (x : Fin 3) (i : Fin 7) :
    r09Construction.ppm.endpoint.channel x (r09Construction.ppm.labels (r09Labels i)) =
      if x ∈ (allPatterns i).val then 1/4 else 0 := by
  rw [r09Construction.ppm.coordinates,CompressedPatternData.channel_apply,r09Value]
  change (if x ∈ (allPatterns i).val then ENNReal.ofReal (1/4) else 0) = _
  norm_num [ENNReal.ofReal_div_of_pos]

example : (r13Construction.normalForm r13Enumeration).outputEquiv.equiv
    (r13Construction.ppm.labels (s03Labels 0)) = (3 : Fin 4) := by
  change r13Enumeration (r13Construction.ppm.labels.symm
    (r13Construction.ppm.labels (s03Labels 0))) = 3
  rw [Equiv.symm_apply_apply]
  change r13Rotate (s03Labels.symm (s03Labels 0)) = 3
  rw [Equiv.symm_apply_apply]
  exact r13Rotate_zero.1
example : (sharedData.toActiveFiniteChannel r13Enumeration).channel 0 (3 : Fin 4) = 1/3 := by
  have he : r13Enumeration (s03Labels 0) = 3 := by
    change r13Rotate (s03Labels.symm (s03Labels 0)) = 3
    rw [Equiv.symm_apply_apply]
    exact r13Rotate_zero.1
  rw [← he,CompressedPatternData.toActiveFiniteChannel_apply,s03Channel]
  norm_num [sharedPatterns,sharedValues,singlePattern,ENNReal.ofReal_div_of_pos]

-- All seven patterns are active and J is nonempty.
-- The new characterization proves nonperfectness.
example : Nonempty (AdmissiblePartition obstructedData) ∧
    ¬ IsPerfectlyRepresentableChannel obstructedData.channel := by
  refine ⟨⟨⟨wholePartition,obstructed_all_admissible _⟩⟩,?_⟩
  intro h
  obtain ⟨w,hw⟩ := (isPerfectlyRepresentableChannel_iff_exists_feasible obstructedData).mp h
  have hf := fullFeasible_extendWeights obstructedData hw
  exact obstructed_no_nonnegative_solution _ hf.1 hf.2

example (p : PositivePartition r09Data r09Weights) : p.val.val ≠ singlePartition := by
  intro h
  have he : p.val = ⟨singlePartition,r09All_admissible _⟩ := Subtype.ext h
  have hp := p.property
  rw [he,r09Singleton_zero] at hp
  exact (lt_irrefl 0) hp


example (x : Fin 3) (b : PositiveBlock r09Data r09Weights) :
    r09Construction.vps.endpoint.channel x (r09Construction.vps.labels b) =
      if x ∈ b.2.val then 1/4 else 0 := by
  rw [r09Construction.vps.coordinates]
  have hw : r09Weights b.1.val = 1/4 := by
    obtain ⟨i,hi⟩ := r09PositiveEquiv.surjective b.1
    rw [← hi]
    exact r09Partition_weight i
  rw [hw]
  norm_num [ENNReal.ofReal_div_of_pos]

example (x : Fin 3) :
    r13Construction.pps.endpoint.channel x
      (r13Construction.pps.labels (r13PositiveEquiv 0)) = 2/3 ∧
    r13Construction.pps.endpoint.channel x
      (r13Construction.pps.labels (r13PositiveEquiv 1)) = 1/3 := by
  constructor
  · rw [r13Construction.pps.coordinates]
    change ENNReal.ofReal (r13Weights (sharedEnumeration 0)) = 2/3
    rw [r13Weight]
    norm_num [ENNReal.ofReal_div_of_pos]
  · rw [r13Construction.pps.coordinates]
    change ENNReal.ofReal (r13Weights (sharedEnumeration 1)) = 1/3
    rw [r13Weight]
    norm_num [ENNReal.ofReal_div_of_pos]

/-! S05: exhaustive three-input partitions and the paper's complete matrix. -/

private theorem partition_eq_whole_of_whole (π : Q)
    (hp : Finset.univ ∈ π.parts) : π = wholePartition := by
  apply Finpartition.ext
  ext b
  simp only [wholePartition_parts, Finset.mem_singleton]
  constructor
  · intro hb
    obtain ⟨x,hx⟩ := π.nonempty_of_mem_parts hb
    exact π.eq_of_mem_parts hb hp hx (Finset.mem_univ x)
  · rintro rfl
    exact hp

private theorem partition_cases (π : Q) :
    π = wholePartition ∨ π = splitPartition 2 ∨ π = splitPartition 1 ∨
      π = splitPartition 0 ∨ π = singlePartition := by
  by_cases hwhole : Finset.univ ∈ π.parts
  · exact Or.inl (partition_eq_whole_of_whole π hwhole)
  right
  by_cases htwo : Finset.univ.erase (2 : Fin 3) ∈ π.parts
  · exact Or.inl (partition_eq_split_of_pair π 2 htwo)
  right
  by_cases hone : Finset.univ.erase (1 : Fin 3) ∈ π.parts
  · exact Or.inl (partition_eq_split_of_pair π 1 hone)
  right
  by_cases hzero : Finset.univ.erase (0 : Fin 3) ∈ π.parts
  · exact Or.inl (partition_eq_split_of_pair π 0 hzero)
  right
  apply partition_eq_singles_of_parts
  intro b hb
  rcases pattern_cases ⟨b,π.nonempty_of_mem_parts hb⟩ with ⟨i,hi⟩ | ⟨i,hi⟩ | hi
  · exact ⟨i,congrArg Subtype.val hi⟩
  · have he : b = Finset.univ.erase i := congrArg Subtype.val hi
    have hp : Finset.univ.erase i ∈ π.parts := he ▸ hb
    fin_cases i
    · exact False.elim (hzero hp)
    · exact False.elim (hone hp)
    · exact False.elim (htwo hp)
  · have he : b = Finset.univ := congrArg Subtype.val hi
    exact False.elim (hwhole (he ▸ hb))

private def paperPartitions : Fin 5 → Q :=
  ![wholePartition,splitPartition 2,splitPartition 1,splitPartition 0,singlePartition]

private theorem paperPartitions_injective : Function.Injective paperPartitions := by
  intro i j h
  fin_cases i <;> fin_cases j <;> try rfl
  all_goals simp [paperPartitions,whole_ne_split,Ne.symm (whole_ne_split _),
    whole_ne_single,whole_ne_single.symm,split_ne_single,Ne.symm (split_ne_single _),
    split_injective.eq_iff,Matrix.cons_val_two] at h

private theorem paperPartitions_surjective : Function.Surjective paperPartitions := by
  intro π
  rcases partition_cases π with rfl | rfl | rfl | rfl | rfl
  · exact ⟨0,rfl⟩
  · exact ⟨1,rfl⟩
  · exact ⟨2,rfl⟩
  · exact ⟨3,rfl⟩
  · exact ⟨4,rfl⟩

private def paperRows : Fin 7 ≃ A :=
  Equiv.ofBijective allPatterns ⟨allPatterns_injective,allPatterns_surjective⟩

private def paperColumns : Fin 5 ≃ Q :=
  Equiv.ofBijective paperPartitions ⟨paperPartitions_injective,paperPartitions_surjective⟩

example : Fintype.card Q = 5 :=
  (Fintype.card_congr paperColumns).symm.trans (Fintype.card_fin 5)

private def paperMatrix : Matrix (Fin 7) (Fin 5) ℝ :=
  ![![0,0,0,1,1],![0,0,1,0,1],![0,1,0,0,1],![0,1,0,0,0],
    ![0,0,1,0,0],![0,0,0,1,0],![1,0,0,0,0]]

private theorem paper_entries (i : Fin 7) (j : Fin 5) :
    fullMatrix (allPatterns i) (paperPartitions j) = paperMatrix i j := by
  fin_cases i <;> fin_cases j <;>
    norm_num [allPatterns,paperPartitions,paperMatrix]

private theorem paper_fullMatrix :
    Matrix.reindex paperRows.symm paperColumns.symm fullMatrix = paperMatrix := by
  ext i j
  exact paper_entries i j

private theorem paper_sparse_coordinates (a b c d e : ℝ) :
    sparse a b c d e ∘ paperColumns = ![a,b,c,d,e] := by
  ext j
  fin_cases j
  · exact sparse_at_whole _ _ _ _ _
  · change sparse a b c d e (splitPartition 2) = b
    rw [sparse_at_split]
    rfl
  · change sparse a b c d e (splitPartition 1) = c
    rw [sparse_at_split]
    rfl
  · change sparse a b c d e (splitPartition 0) = d
    rw [sparse_at_split]
    rfl
  · exact sparse_at_single _ _ _ _ _

private theorem paper_mulVec (v : Fin 5 → ℝ) :
    paperMatrix *ᵥ v = ![v 3 + v 4,v 2 + v 4,v 1 + v 4,v 1,v 2,v 3,v 0] := by
  ext i
  fin_cases i <;> simp [paperMatrix,Matrix.mulVec,dotProduct,Fin.sum_univ_succ]

private def paperAllAdmissibleColumns (D : CompressedPatternData (Fin 3))
    (hD : ∀ π : Q, IsAdmissible D π) : Fin 5 ≃ AdmissiblePartition D where
  toFun i := ⟨paperColumns i,hD _⟩
  invFun π := paperColumns.symm π.val
  left_inv i := paperColumns.symm_apply_apply i
  right_inv π := Subtype.ext (paperColumns.apply_symm_apply π.val)

private def r09PaperColumns : Fin 5 ≃ AdmissiblePartition r09Data :=
  paperAllAdmissibleColumns r09Data r09All_admissible

private def r14PaperColumns : Fin 5 ≃ AdmissiblePartition obstructedData :=
  paperAllAdmissibleColumns obstructedData obstructed_all_admissible

example : Fintype.card (AdmissiblePartition r09Data) = 5 :=
  (Fintype.card_congr r09PaperColumns).symm.trans (Fintype.card_fin 5)

example : Fintype.card (AdmissiblePartition obstructedData) = 5 :=
  (Fintype.card_congr r14PaperColumns).symm.trans (Fintype.card_fin 5)

-- R09 has every full row and partition: its reduced matrix is exactly 7 × 5.
example : Matrix.reindex r09Labels.symm r09PaperColumns.symm
    (reducedMatrix r09Data) = paperMatrix := by
  ext i j
  exact paper_entries i j

private def r13PaperRowIndices : Fin 4 → Fin 7 := ![0,1,2,3]
private def r13PaperColumnIndices : Fin 2 → Fin 5 := ![1,4]

private theorem r13Paper_rows (i : Fin 4) :
    (s03Labels i).val = paperRows (r13PaperRowIndices i) := by
  fin_cases i <;> rfl

private theorem r13Paper_columns (j : Fin 2) :
    (sharedEnumeration j).val = paperColumns (r13PaperColumnIndices j) := by
  fin_cases j <;> rfl

private theorem r13Paper_submatrix :
    Matrix.reindex s03Labels.symm sharedEnumeration.symm (reducedMatrix sharedData) =
      paperMatrix.submatrix r13PaperRowIndices r13PaperColumnIndices := by
  ext i j
  change fullMatrix (s03Labels i).val (sharedEnumeration j).val =
    paperMatrix (r13PaperRowIndices i) (r13PaperColumnIndices j)
  rw [r13Paper_rows,r13Paper_columns]
  exact paper_entries _ _

example : Matrix.reindex s03Labels.symm sharedEnumeration.symm (reducedMatrix sharedData) =
    ![![0,1],![0,1],![1,1],![1,0]] := by
  rw [r13Paper_submatrix]
  ext i j
  fin_cases i <;> fin_cases j <;> rfl

example : fullValue sharedData ∘ paperRows = ![1/3,1/3,1,2/3,0,0,0] := by
  funext i
  exact shared_fullValue i

example : r13Weights ∘ sharedEnumeration = ![2/3,1/3] := funext r13Weight

example : extendWeights sharedData r13Weights ∘ paperColumns = ![0,2/3,0,0,1/3] := by
  change extendWeights sharedData (restrictWeights sharedData (sparse 0 (2/3) 0 0 (1/3))) ∘
    paperColumns = _
  rw [extend_restrictWeights sharedData shared_fullFeasible]
  exact paper_sparse_coordinates _ _ _ _ _

-- Exact numeric paper vectors for the mixed/signed and positive controls.
example : sparse 0 (1/2) (1/2) (1/2) 0 ∘ paperColumns = ![0,1/2,1/2,1/2,0] :=
  paper_sparse_coordinates _ _ _ _ _
example : sparse 0 (1/2) (1/2) (1/2) (-1/2) ∘ paperColumns = ![0,1/2,1/2,1/2,-1/2] :=
  paper_sparse_coordinates _ _ _ _ _
example : sparse (1/4) (1/4) (1/4) (1/4) 0 ∘ paperColumns = ![1/4,1/4,1/4,1/4,0] :=
  paper_sparse_coordinates _ _ _ _ _
example : sparse 0 (2/3) 0 0 (1/3) ∘ paperColumns = ![0,2/3,0,0,1/3] :=
  paper_sparse_coordinates _ _ _ _ _
example : sparse (1/8) (3/8) (3/8) (3/8) (-1/4) ∘ paperColumns =
    ![1/8,3/8,3/8,3/8,-1/4] := paper_sparse_coordinates _ _ _ _ _

example : paperMatrix *ᵥ ![0,1/2,1/2,1/2,0] = ![1/2,1/2,1/2,1/2,1/2,1/2,0] := by
  rw [paper_mulVec]
  norm_num [Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four]
example : paperMatrix *ᵥ ![0,1/2,1/2,1/2,-1/2] = ![0,0,0,1/2,1/2,1/2,0] := by
  rw [paper_mulVec]
  norm_num [Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four]
example : paperMatrix *ᵥ ![1/4,1/4,1/4,1/4,0] = ![1/4,1/4,1/4,1/4,1/4,1/4,1/4] := by
  rw [paper_mulVec]
  norm_num [Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four]
example : paperMatrix *ᵥ ![0,2/3,0,0,1/3] = ![1/3,1/3,1,2/3,0,0,0] := by
  rw [paper_mulVec]
  norm_num [Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four]
example : paperMatrix *ᵥ ![1/8,3/8,3/8,3/8,-1/4] = ![1/8,1/8,1/8,3/8,3/8,3/8,1/8] := by
  rw [paper_mulVec]
  norm_num [Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four]

-- The pattern values satisfy input coverage, but need not have total mass one.
example : ∑ p, r09Data.value p = 7/4 := by
  rw [← r09Labels.sum_comp r09Data.value]
  norm_num [r09Value,Fin.sum_univ_succ]

/-! C14-S02 / R05: the same zero-containing equality witness attains one. -/
example : r09Weights ∘ r09PaperColumns = ![1/4,1/4,1/4,1/4,0] := by
  change sparse (1/4) (1/4) (1/4) (1/4) 0 ∘ paperColumns = _
  exact paper_sparse_coordinates _ _ _ _ _

example (i : Fin 3) :
    ∑ p : OccurringPattern r09Data,
      (if i ∈ p.val.val then r09Data.value p else 0) = 1 := r09Data.row_sum i

example : Primal.Feasible r09Data r09Weights ∧
    Primal.objective r09Data r09Weights = 1 ∧
    reducedMatrix r09Data *ᵥ r09Weights = r09Data.value ∧
    r09Weights ⟨singlePartition, r09All_admissible _⟩ = 0 := by
  have hp := (Primal.equality_feasible_iff r09Data).mp r09Feasible
  exact ⟨hp.1, hp.2, (Primal.objective_eq_one_iff r09Data hp.1).mp hp.2,
    r09Singleton_zero⟩

example : IsPerfectlyRepresentableChannel r09Data.channel ∧
    IsGreatest (Primal.objectiveValues r09Data) 1 := by
  have hp := (Primal.equality_feasible_iff r09Data).mp r09Feasible
  have hperfect :=
    (Primal.isPerfectlyRepresentableChannel_iff_exists_objective_eq_one r09Data).mpr
      ⟨r09Weights, hp⟩
  exact ⟨hperfect, (Primal.isPerfectlyRepresentableChannel_iff_isGreatest r09Data).mp hperfect⟩

/-! C14-S02 / R06: all five partitions exist, but objective one is unattainable.
The following private finite sums also cover the signed control; they do not
apply C13's nonnegative restriction theorem to signed coefficients. -/
private theorem allPartitions_restrict_mulVec (D : CompressedPatternData (Fin 3))
    (hD : ∀ π : Q, IsAdmissible D π) (w : Q → ℝ) (p : OccurringPattern D) :
    (reducedMatrix D *ᵥ restrictWeights D w) p = (fullMatrix *ᵥ w) p.val := by
  change (∑ π : AdmissiblePartition D, fullMatrix p.val π.val * w π.val) =
    ∑ π : Q, fullMatrix p.val π * w π
  rw [← (paperAllAdmissibleColumns D hD).sum_comp
    (fun π : AdmissiblePartition D => fullMatrix p.val π.val * w π.val),
    ← paperColumns.sum_comp (fun π : Q => fullMatrix p.val π * w π)]
  rfl

private theorem allPartitions_restrict_sum (D : CompressedPatternData (Fin 3))
    (hD : ∀ π : Q, IsAdmissible D π) (w : Q → ℝ) :
    (∑ π : AdmissiblePartition D, restrictWeights D w π) = ∑ π : Q, w π := by
  rw [← (paperAllAdmissibleColumns D hD).sum_comp (restrictWeights D w),
    ← paperColumns.sum_comp w]
  rfl

private abbrev c14SlackWeights :=
  restrictWeights obstructedData (sparse (1/8) (1/8) (1/8) (1/8) 0)

private theorem c14Slack_feasible : Primal.Feasible obstructedData c14SlackWeights := by
  refine ⟨fun π => sparse_nonneg (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num) π.val, ?_⟩
  intro p
  rw [allPartitions_restrict_mulVec obstructedData obstructed_all_admissible,
    ← fullValue_of_mem obstructedData p.val p.property]
  obtain ⟨i, hi⟩ := allPatterns_surjective p.val
  rw [← hi, obstructed_fullValue, sparse_mulVec]
  fin_cases i <;> norm_num [allPatterns, obstructedValues]

private theorem c14Slack_objective : Primal.objective obstructedData c14SlackWeights = 1/2 := by
  change (∑ π, restrictWeights obstructedData (sparse (1/8) (1/8) (1/8) (1/8) 0) π) = 1/2
  rw [allPartitions_restrict_sum obstructedData obstructed_all_admissible, sparse_sum]
  norm_num

example : c14SlackWeights ∘ r14PaperColumns = ![1/8,1/8,1/8,1/8,0] := by
  change sparse (1/8) (1/8) (1/8) (1/8) 0 ∘ paperColumns = _
  exact paper_sparse_coordinates _ _ _ _ _

example : Primal.Feasible obstructedData c14SlackWeights ∧
    Primal.objective obstructedData c14SlackWeights = 1/2 :=
  ⟨c14Slack_feasible, c14Slack_objective⟩

private theorem c14Obstructed_no_attainment :
    ¬ ∃ w, Primal.Feasible obstructedData w ∧ Primal.objective obstructedData w = 1 := by
  rintro ⟨w, hw⟩
  have he := (Primal.equality_feasible_iff obstructedData).mpr hw
  have hf := fullFeasible_extendWeights obstructedData he
  exact obstructed_no_nonnegative_solution _ hf.1 hf.2

example : Nonempty (AdmissiblePartition obstructedData) ∧
    (Primal.feasibleSet obstructedData).Nonempty ∧
    (¬ ∃ w, Primal.Feasible obstructedData w ∧ Primal.objective obstructedData w = 1) ∧
    ¬ IsGreatest (Primal.objectiveValues obstructedData) 1 := by
  refine ⟨⟨⟨wholePartition, obstructed_all_admissible _⟩⟩,
    ⟨c14SlackWeights, c14Slack_feasible⟩, c14Obstructed_no_attainment, ?_⟩
  intro hg
  have hp := (Primal.isPerfectlyRepresentableChannel_iff_isGreatest obstructedData).mpr hg
  exact c14Obstructed_no_attainment
    ((Primal.isPerfectlyRepresentableChannel_iff_exists_objective_eq_one obstructedData).mp hp)

private abbrev c14SignedWeights :=
  restrictWeights obstructedData (sparse (1/8) (3/8) (3/8) (3/8) (-1/4))

private theorem c14Signed_eq :
    reducedMatrix obstructedData *ᵥ c14SignedWeights = obstructedData.value := by
  funext p
  rw [allPartitions_restrict_mulVec obstructedData obstructed_all_admissible,
    obstructed_signed_solution]
  exact fullValue_of_mem obstructedData p.val p.property

private theorem c14Signed_objective : Primal.objective obstructedData c14SignedWeights = 1 := by
  change (∑ π, restrictWeights obstructedData (sparse (1/8) (3/8) (3/8) (3/8) (-1/4)) π) = 1
  rw [allPartitions_restrict_sum obstructedData obstructed_all_admissible, sparse_sum]
  norm_num

private theorem c14Signed_not_feasible : ¬ Primal.Feasible obstructedData c14SignedWeights := by
  intro h
  have hn := h.1 ⟨singlePartition, obstructed_all_admissible _⟩
  change 0 ≤ sparse (1/8) (3/8) (3/8) (3/8) (-1/4) singlePartition at hn
  rw [obstructed_signed_negative] at hn
  norm_num at hn

example : c14SignedWeights ∘ r14PaperColumns = ![1/8,3/8,3/8,3/8,-1/4] := by
  change sparse (1/8) (3/8) (3/8) (3/8) (-1/4) ∘ paperColumns = _
  exact paper_sparse_coordinates _ _ _ _ _

example : reducedMatrix obstructedData *ᵥ c14SignedWeights = obstructedData.value ∧
    Primal.objective obstructedData c14SignedWeights = 1 ∧
    c14SignedWeights ⟨singlePartition, obstructed_all_admissible _⟩ = -1/4 ∧
    ¬ Primal.Feasible obstructedData c14SignedWeights :=
  ⟨c14Signed_eq, c14Signed_objective, obstructed_signed_negative, c14Signed_not_feasible⟩

-- R11: independent three-cycles on the seven rows and five columns.
private def paperRowCycle : Fin 7 ≃ Fin 7 :=
  (Equiv.swap 0 1).trans (Equiv.swap 1 2)
private def paperColumnCycle : Fin 5 ≃ Fin 5 :=
  (Equiv.swap 0 3).trans (Equiv.swap 3 4)
private def cycledFullRows : A ≃ Fin 7 := paperRows.symm.trans paperRowCycle
private def cycledFullColumns : Q ≃ Fin 5 := paperColumns.symm.trans paperColumnCycle

private theorem paperCycle_values : paperRowCycle 0 = 2 ∧ paperRowCycle.symm 0 = 1 ∧
    paperColumnCycle 0 = 4 ∧ paperColumnCycle.symm 0 = 3 := by
  norm_num [paperRowCycle,paperColumnCycle,Equiv.swap_apply_def]

private theorem paper_asymmetric_value :
    (fullMatrix *ᵥ sparse 1 2 3 4 5) ∘ paperRows = ![9,8,7,2,3,4,1] := by
  have h := reindex_mulVec fullMatrix (sparse 1 2 3 4 5) paperRows.symm paperColumns.symm
  simp only [Equiv.symm_symm] at h
  rw [paper_fullMatrix,paper_sparse_coordinates,paper_mulVec] at h
  norm_num [Matrix.cons_val_two,Matrix.cons_val_three,Matrix.cons_val_four] at h
  exact h.symm

example :
    (∀ j, 0 ≤ (sparse 1 2 3 4 5 ∘ cycledFullColumns.symm) j) ∧
    Matrix.reindex cycledFullRows cycledFullColumns fullMatrix *ᵥ
      (sparse 1 2 3 4 5 ∘ cycledFullColumns.symm) =
      ![9,8,7,2,3,4,1] ∘ paperRowCycle.symm := by
  have hnonneg : ∀ π, 0 ≤ sparse 1 2 3 4 5 π :=
    sparse_nonneg (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have h := (system_reindex_iff fullMatrix (fullMatrix *ᵥ sparse 1 2 3 4 5)
    (sparse 1 2 3 4 5) cycledFullRows cycledFullColumns).mpr ⟨hnonneg,rfl⟩
  refine ⟨h.1,h.2.trans ?_⟩
  simp only [cycledFullRows,Equiv.symm_trans,Equiv.symm_symm,Equiv.coe_trans,
    ← Function.comp_assoc]
  rw [paper_asymmetric_value]

-- The inverse direction is observable in the matrix, coefficients, and value.
example : Matrix.reindex paperRowCycle paperColumnCycle paperMatrix 0 0 = 0 ∧
    paperMatrix (paperRowCycle 0) (paperColumnCycle 0) = 1 := by
  change paperMatrix (paperRowCycle.symm 0) (paperColumnCycle.symm 0) = 0 ∧ _
  rw [paperCycle_values.1,paperCycle_values.2.1,paperCycle_values.2.2.1,
    paperCycle_values.2.2.2]
  exact ⟨rfl,rfl⟩

example : (sparse 1 2 3 4 5 ∘ cycledFullColumns.symm) 0 = 4 ∧
    (![1,2,3,4,5] : Fin 5 → ℝ) (paperColumnCycle 0) = 5 := by
  constructor
  · have h : cycledFullColumns.symm 0 = paperColumns 3 := by
      change paperColumns (paperColumnCycle.symm 0) = paperColumns 3
      rw [paperCycle_values.2.2.2]
    change sparse 1 2 3 4 5 (cycledFullColumns.symm 0) = 4
    rw [h]
    exact congrFun (paper_sparse_coordinates 1 2 3 4 5) 3
  · rw [paperCycle_values.2.2.1]
    rfl

example : (![9,8,7,2,3,4,1] : Fin 7 → ℝ) (paperRowCycle.symm 0) = 8 ∧
    (![9,8,7,2,3,4,1] : Fin 7 → ℝ) (paperRowCycle 0) = 7 := by
  norm_num [paperRowCycle,Equiv.swap_apply_def,Matrix.cons_val_two]

/-! C14-S03 / R09: a nonconstant primal-feasible vector detects both inverse
directions. The existing R05 datum retains all seven rows and five partitions. -/
private abbrev c14ScaledWeights :=
  restrictWeights r09Data (sparse (1/40) (2/40) (3/40) (4/40) (5/40))

private theorem c14Scaled_coordinates :
    c14ScaledWeights ∘ r09PaperColumns = ![1/40,2/40,3/40,4/40,5/40] := by
  change sparse (1/40) (2/40) (3/40) (4/40) (5/40) ∘ paperColumns = _
  exact paper_sparse_coordinates _ _ _ _ _

private theorem c14Scaled_product :
    (reducedMatrix r09Data *ᵥ c14ScaledWeights) ∘ r09Labels =
      ![9/40,8/40,7/40,2/40,3/40,4/40,1/40] := by
  have h := reindex_mulVec fullMatrix (sparse (1/40) (2/40) (3/40) (4/40) (5/40))
    paperRows.symm paperColumns.symm
  simp only [Equiv.symm_symm] at h
  rw [paper_fullMatrix, paper_sparse_coordinates, paper_mulVec] at h
  norm_num [Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four] at h
  funext i
  simp only [Function.comp_apply]
  rw [allPartitions_restrict_mulVec r09Data r09All_admissible]
  have hrow : (r09Labels i).val = paperRows i := rfl
  rw [hrow]
  convert (congrFun h i).symm using 1 <;> norm_num

private theorem c14Scaled_feasible : Primal.Feasible r09Data c14ScaledWeights := by
  refine ⟨fun π => sparse_nonneg (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num) π.val, ?_⟩
  intro p
  obtain ⟨i, rfl⟩ := r09Labels.surjective p
  have hp := congrFun c14Scaled_product i
  simp only [Function.comp_apply] at hp
  rw [hp, r09Value]
  fin_cases i <;> norm_num

private theorem c14Scaled_objective : Primal.objective r09Data c14ScaledWeights = 3/8 := by
  change (∑ π, restrictWeights r09Data (sparse (1/40) (2/40) (3/40) (4/40) (5/40)) π) = 3/8
  rw [allPartitions_restrict_sum r09Data r09All_admissible, sparse_sum]
  norm_num

private def c14ScaledRows : OccurringPattern r09Data ≃ Fin 7 :=
  r09Labels.symm.trans paperRowCycle
private def c14ScaledColumns : AdmissiblePartition r09Data ≃ Fin 5 :=
  r09PaperColumns.symm.trans paperColumnCycle

private theorem c14Scaled_presented :
    (∀ j, 0 ≤ (c14ScaledWeights ∘ c14ScaledColumns.symm) j) ∧
    ∀ i, (Matrix.reindex c14ScaledRows c14ScaledColumns (reducedMatrix r09Data) *ᵥ
      (c14ScaledWeights ∘ c14ScaledColumns.symm)) i ≤
        (r09Data.value ∘ c14ScaledRows.symm) i :=
  (Primal.feasible_reindex_iff r09Data c14ScaledWeights c14ScaledRows c14ScaledColumns).mp
    c14Scaled_feasible

private theorem c14Scaled_presented_objective :
    (∑ j, (c14ScaledWeights ∘ c14ScaledColumns.symm) j) = 3/8 :=
  (c14ScaledColumns.symm.sum_comp c14ScaledWeights).trans c14Scaled_objective

example : Primal.Feasible r09Data c14ScaledWeights ∧
    Primal.objective r09Data c14ScaledWeights = 3/8 ∧
    c14ScaledWeights ∘ r09PaperColumns = ![1/40,2/40,3/40,4/40,5/40] ∧
    (reducedMatrix r09Data *ᵥ c14ScaledWeights) ∘ r09Labels =
      ![9/40,8/40,7/40,2/40,3/40,4/40,1/40] :=
  ⟨c14Scaled_feasible, c14Scaled_objective, c14Scaled_coordinates, c14Scaled_product⟩

example :
    ((∀ j, 0 ≤ (c14ScaledWeights ∘ c14ScaledColumns.symm) j) ∧
      ∀ i, (Matrix.reindex c14ScaledRows c14ScaledColumns (reducedMatrix r09Data) *ᵥ
        (c14ScaledWeights ∘ c14ScaledColumns.symm)) i ≤
          (r09Data.value ∘ c14ScaledRows.symm) i) ∧
    (∑ j, (c14ScaledWeights ∘ c14ScaledColumns.symm) j) = 3/8 :=
  ⟨c14Scaled_presented, c14Scaled_presented_objective⟩

-- The inverse column coordinate gives 4/40; the forward coordinate gives 5/40.
example : (c14ScaledWeights ∘ c14ScaledColumns.symm) 0 = 4/40 ∧
    (c14ScaledWeights ∘ r09PaperColumns) (paperColumnCycle 0) = 5/40 := by
  constructor
  · change c14ScaledWeights (r09PaperColumns (paperColumnCycle.symm 0)) = 4/40
    rw [paperCycle_values.2.2.2]
    exact congrFun c14Scaled_coordinates 3
  · rw [c14Scaled_coordinates, paperCycle_values.2.2.1]
    rfl

-- The actual reindexed product gives 8/40; the forward row coordinate gives 7/40.
example :
    (Matrix.reindex c14ScaledRows c14ScaledColumns (reducedMatrix r09Data) *ᵥ
      (c14ScaledWeights ∘ c14ScaledColumns.symm)) 0 = 8/40 ∧
    ((reducedMatrix r09Data *ᵥ c14ScaledWeights) ∘ r09Labels) (paperRowCycle 0) = 7/40 := by
  constructor
  · rw [reindex_mulVec]
    simp only [c14ScaledRows, Equiv.symm_trans, Equiv.symm_symm,
      Equiv.coe_trans, Function.comp_apply]
    rw [paperCycle_values.2.1]
    simpa only [Function.comp_apply, Matrix.cons_val_one, Matrix.cons_val_zero] using
      congrFun c14Scaled_product 1
  · rw [c14Scaled_product, paperCycle_values.1]
    rfl

/-! R09/R10: use the entire finite-coordinate image on concrete data.
The scaled finite witness is transported to the intrinsic image; the intrinsic
attaining witness is transported back to the finite image. -/
private abbrev c14FiniteValues : Set ℝ :=
  (fun z : Fin 5 → ℝ => ∑ j, z j) ''
    {z | (∀ j, 0 ≤ z j) ∧ ∀ i,
      (Matrix.reindex c14ScaledRows c14ScaledColumns (reducedMatrix r09Data) *ᵥ z) i ≤
        (r09Data.value ∘ c14ScaledRows.symm) i}

private theorem c14FiniteValues_eq : c14FiniteValues = Primal.objectiveValues r09Data :=
  Primal.objectiveValues_reindex r09Data c14ScaledRows c14ScaledColumns

example : (3/8 : ℝ) ∈ Primal.objectiveValues r09Data := by
  have hfinite : (3/8 : ℝ) ∈ c14FiniteValues :=
    ⟨c14ScaledWeights ∘ c14ScaledColumns.symm,
      c14Scaled_presented, c14Scaled_presented_objective⟩
  rw [c14FiniteValues_eq] at hfinite
  exact hfinite

example : (1 : ℝ) ∈ c14FiniteValues := by
  rw [c14FiniteValues_eq]
  have hp := (Primal.equality_feasible_iff r09Data).mp r09Feasible
  exact ⟨r09Weights, hp.1, hp.2⟩

example : IsGreatest c14FiniteValues 1 := by
  rw [c14FiniteValues_eq]
  have hp := (isPerfectlyRepresentableChannel_iff_exists_feasible r09Data).mpr
    ⟨r09Weights, r09Feasible⟩
  exact (Primal.isPerfectlyRepresentableChannel_iff_isGreatest r09Data).mp hp

private def c14ObstructedLabels : Fin 7 ≃ OccurringPattern obstructedData :=
  listLabels allPatterns allPatterns_injective

example : ¬ IsGreatest
    ((fun z : Fin 5 → ℝ => ∑ j, z j) ''
      {z | (∀ j, 0 ≤ z j) ∧ ∀ i,
        (Matrix.reindex c14ObstructedLabels.symm
          r14PaperColumns.symm (reducedMatrix obstructedData) *ᵥ z) i ≤
            (obstructedData.value ∘ c14ObstructedLabels) i}) 1 := by
  have himage := Primal.objectiveValues_reindex obstructedData
    c14ObstructedLabels.symm r14PaperColumns.symm
  simp only [Equiv.symm_symm] at himage
  rw [himage]
  intro hg
  exact c14Obstructed_no_attainment hg.1

-- C15-S01 / R03: partition lower bounds alone accept this signed vector.
private def c15SignedDual (p : OccurringPattern obstructedData) : ℝ :=
  ![2,2,2,-1,-1,-1,1] (c14ObstructedLabels.symm p)

private theorem c15SignedDual_coordinates (i : Fin 7) :
    c15SignedDual (c14ObstructedLabels i) = ![2,2,2,-1,-1,-1,1] i := by
  simp only [c15SignedDual, Equiv.symm_apply_apply]

private theorem c15SignedDual_products (j : Fin 5) :
    ((reducedMatrix obstructedData)ᵀ *ᵥ c15SignedDual) (r14PaperColumns j) =
      ![1,1,1,1,6] j := by
  change (∑ p : OccurringPattern obstructedData,
    reducedMatrix obstructedData p (r14PaperColumns j) * c15SignedDual p) = _
  rw [← c14ObstructedLabels.sum_comp
    (fun p => reducedMatrix obstructedData p (r14PaperColumns j) * c15SignedDual p)]
  have he (i : Fin 7) :
      reducedMatrix obstructedData (c14ObstructedLabels i) (r14PaperColumns j) =
        paperMatrix i j := paper_entries i j
  simp only [he, c15SignedDual_coordinates]
  fin_cases j <;> norm_num [paperMatrix, Fin.sum_univ_succ]

private theorem c15SignedDual_objective :
    Dual.objective obstructedData c15SignedDual = -1/4 := by
  change (∑ p, obstructedData.value p * c15SignedDual p) = -1/4
  rw [← c14ObstructedLabels.sum_comp
    (fun p => obstructedData.value p * c15SignedDual p)]
  have hv (i : Fin 7) : obstructedData.value (c14ObstructedLabels i) =
      obstructedValues i := dataOfList_value _ _ _ _ _ i
  simp only [hv, c15SignedDual_coordinates]
  norm_num [obstructedValues, Fin.sum_univ_succ]

private theorem c15SignedDual_not_feasible : ¬ Dual.Feasible obstructedData c15SignedDual := by
  intro hy
  have hn := hy.1 (c14ObstructedLabels 3)
  rw [c15SignedDual_coordinates] at hn
  change (0 : ℝ) ≤ -1 at hn
  norm_num at hn

example : (∀ j, 1 ≤ ((reducedMatrix obstructedData)ᵀ *ᵥ c15SignedDual) j) ∧
    Dual.objective obstructedData c15SignedDual = -1/4 ∧
    ¬ Dual.Feasible obstructedData c15SignedDual := by
  refine ⟨?_, c15SignedDual_objective, c15SignedDual_not_feasible⟩
  intro π
  obtain ⟨j, rfl⟩ := r14PaperColumns.surjective π
  rw [c15SignedDual_products]
  fin_cases j <;> norm_num

-- C15-S02 / R06-R07: these coordinates reuse the existing datum and labels.
private def c15PatternVector (z : Fin 7 → ℝ) (p : OccurringPattern obstructedData) : ℝ :=
  z (c14ObstructedLabels.symm p)

private theorem c15PatternVector_coordinates (z : Fin 7 → ℝ) (i : Fin 7) :
    c15PatternVector z (c14ObstructedLabels i) = z i := by
  simp only [c15PatternVector, Equiv.symm_apply_apply]

private theorem c15PatternVector_products (z : Fin 7 → ℝ) (j : Fin 5) :
    ((reducedMatrix obstructedData)ᵀ *ᵥ c15PatternVector z) (r14PaperColumns j) =
      ∑ i, paperMatrix i j * z i := by
  change (∑ p : OccurringPattern obstructedData,
    reducedMatrix obstructedData p (r14PaperColumns j) * c15PatternVector z p) = _
  rw [← c14ObstructedLabels.sum_comp
    (fun p => reducedMatrix obstructedData p (r14PaperColumns j) * c15PatternVector z p)]
  have he (i : Fin 7) :
      reducedMatrix obstructedData (c14ObstructedLabels i) (r14PaperColumns j) =
        paperMatrix i j := paper_entries i j
  simp only [he, c15PatternVector_coordinates]

private theorem c15PatternVector_objective (z : Fin 7 → ℝ) :
    Dual.objective obstructedData (c15PatternVector z) = ∑ i, obstructedValues i * z i := by
  change (∑ p, obstructedData.value p * c15PatternVector z p) = _
  rw [← c14ObstructedLabels.sum_comp
    (fun p => obstructedData.value p * c15PatternVector z p)]
  have hv (i : Fin 7) : obstructedData.value (c14ObstructedLabels i) =
      obstructedValues i := dataOfList_value _ _ _ _ _ i
  simp only [hv, c15PatternVector_coordinates]

private abbrev c15SubunitDual := c15PatternVector ![1,1,1,0,0,0,1]

private theorem c15SubunitDual_products (j : Fin 5) :
    ((reducedMatrix obstructedData)ᵀ *ᵥ c15SubunitDual) (r14PaperColumns j) =
      ![1,1,1,1,3] j := by
  rw [c15PatternVector_products]
  fin_cases j <;> norm_num [paperMatrix, Fin.sum_univ_succ]

private theorem c15SubunitDual_objective :
    Dual.objective obstructedData c15SubunitDual = 1/2 := by
  rw [c15PatternVector_objective]
  norm_num [obstructedValues, Fin.sum_univ_succ]

private theorem c15SubunitDual_feasible : Dual.Feasible obstructedData c15SubunitDual := by
  refine ⟨?_, ?_⟩
  · intro p
    obtain ⟨i, rfl⟩ := c14ObstructedLabels.surjective p
    change 0 ≤ c15PatternVector ![1,1,1,0,0,0,1] (c14ObstructedLabels i)
    rw [c15PatternVector_coordinates]
    fin_cases i <;> norm_num
  · intro π
    obtain ⟨j, rfl⟩ := r14PaperColumns.surjective π
    rw [c15SubunitDual_products]
    fin_cases j <;> norm_num

example : Dual.Feasible obstructedData c15SubunitDual ∧
    Dual.objective obstructedData c15SubunitDual = 1/2 ∧
    Dual.objective obstructedData c15SubunitDual < 1 := by
  refine ⟨c15SubunitDual_feasible, c15SubunitDual_objective, ?_⟩
  rw [c15SubunitDual_objective]
  norm_num

example (i : Fin 3) : Dual.Feasible obstructedData (Dual.rowWitness obstructedData i) ∧
    Dual.objective obstructedData (Dual.rowWitness obstructedData i) = 1 :=
  ⟨Dual.feasible_rowWitness obstructedData i, Dual.objective_rowWitness obstructedData i⟩

example : Primal.Feasible obstructedData c14SlackWeights ∧
    Dual.Feasible obstructedData c15SubunitDual ∧
    Primal.objective obstructedData c14SlackWeights =
      Dual.objective obstructedData c15SubunitDual ∧
    Primal.objective obstructedData c14SlackWeights ≤
      Dual.objective obstructedData c15SubunitDual := by
  refine ⟨c14Slack_feasible, c15SubunitDual_feasible, ?_,
    Dual.weak_duality obstructedData c14Slack_feasible c15SubunitDual_feasible⟩
  rw [c14Slack_objective, c15SubunitDual_objective]

-- This public certificate consumer does not specify which vector is returned.
example : ∃ y, Dual.Feasible obstructedData y ∧ Dual.objective obstructedData y < 1 := by
  apply Dual.exists_feasible_objective_lt_one_of_not_perfect obstructedData
  intro hD
  exact c14Obstructed_no_attainment
    ((Primal.isPerfectlyRepresentableChannel_iff_exists_objective_eq_one obstructedData).mp hD)

private abbrev c15Cardinality := c15PatternVector ![1,1,1,2,2,2,3]
private abbrev c15RawSeparator := c15PatternVector ![0,0,0,-2,-2,-2,-2]

private theorem c15Cardinality_eq_card (p : OccurringPattern obstructedData) :
    c15Cardinality p = (p.val.val.card : ℝ) := by
  obtain ⟨i, rfl⟩ := c14ObstructedLabels.surjective p
  change c15PatternVector ![1,1,1,2,2,2,3] (c14ObstructedLabels i) = _
  rw [c15PatternVector_coordinates]
  change ![1,1,1,2,2,2,3] i = ((allPatterns i).val.card : ℝ)
  fin_cases i <;> norm_num [allPatterns, singlePattern, pairPattern, wholePattern, Fin.ext_iff]

private theorem c15Cardinality_value_dot : c15Cardinality ⬝ᵥ obstructedData.value = 3 := by
  rw [dotProduct_comm]
  change Dual.objective obstructedData c15Cardinality = 3
  rw [c15PatternVector_objective]
  norm_num [obstructedValues, Fin.sum_univ_succ]

private theorem c15Cardinality_products (j : Fin 5) :
    ((reducedMatrix obstructedData)ᵀ *ᵥ c15Cardinality) (r14PaperColumns j) = 3 := by
  rw [c15PatternVector_products]
  fin_cases j <;> norm_num [paperMatrix, Fin.sum_univ_succ]

private theorem c15Cardinality_column_dot (π : AdmissiblePartition obstructedData) :
    c15Cardinality ⬝ᵥ (fun p => reducedMatrix obstructedData p π) = 3 := by
  obtain ⟨j, rfl⟩ := r14PaperColumns.surjective π
  simpa only [Matrix.mulVec, Matrix.transpose_apply, dotProduct, mul_comm]
    using c15Cardinality_products j

example (p : OccurringPattern obstructedData) : 1 ≤ c15Cardinality p := by
  rw [c15Cardinality_eq_card]
  exact_mod_cast Nat.succ_le_of_lt (Finset.card_pos.mpr p.val.property)

-- The equal cardinality-weighted sums coexist with different block counts.
example : c15Cardinality ⬝ᵥ obstructedData.value = 3 ∧
    (∀ π : AdmissiblePartition obstructedData,
      c15Cardinality ⬝ᵥ (fun p => reducedMatrix obstructedData p π) = 3) ∧
    (r14PaperColumns 0).val.parts.card = 1 ∧
    (r14PaperColumns 4).val.parts.card = 3 := by
  refine ⟨c15Cardinality_value_dot, c15Cardinality_column_dot, ?_, ?_⟩
  · change wholePartition.parts.card = 1
    simp only [wholePartition_parts, Finset.card_singleton]
  · change singlePartition.parts.card = 3
    exact r13Parts_single

example : c15RawSeparator = c15SubunitDual - c15Cardinality := by
  ext p
  obtain ⟨i, rfl⟩ := c14ObstructedLabels.surjective p
  simp only [Pi.sub_apply, c15PatternVector_coordinates]
  fin_cases i <;> norm_num

example : c15RawSeparator (c14ObstructedLabels 3) < 0 ∧
    c15RawSeparator (c14ObstructedLabels 6) < 0 ∧ (-9/4 : ℝ) < 0 := by
  simp only [c15PatternVector_coordinates]
  change (-2 : ℝ) < 0 ∧ (-2 : ℝ) < 0 ∧ (-9/4 : ℝ) < 0
  norm_num

private theorem c15RawSeparator_value_dot :
    c15RawSeparator ⬝ᵥ obstructedData.value = -5/2 := by
  rw [dotProduct_comm]
  change Dual.objective obstructedData c15RawSeparator = -5/2
  rw [c15PatternVector_objective]
  norm_num [obstructedValues, Fin.sum_univ_succ]

private theorem c15RawSeparator_products (j : Fin 5) :
    ((reducedMatrix obstructedData)ᵀ *ᵥ c15RawSeparator) (r14PaperColumns j) =
      ![-2,-2,-2,-2,0] j := by
  rw [c15PatternVector_products]
  fin_cases j <;> norm_num [paperMatrix, Fin.sum_univ_succ]

example : c15RawSeparator ⬝ᵥ obstructedData.value < (-9/4 : ℝ) ∧
    ∀ π : AdmissiblePartition obstructedData,
      (-9/4 : ℝ) < c15RawSeparator ⬝ᵥ (fun p => reducedMatrix obstructedData p π) := by
  refine ⟨?_, ?_⟩
  · rw [c15RawSeparator_value_dot]
    norm_num
  · intro π
    obtain ⟨j, rfl⟩ := r14PaperColumns.surjective π
    have h : c15RawSeparator ⬝ᵥ
        (fun p => reducedMatrix obstructedData p (r14PaperColumns j)) =
          ![-2,-2,-2,-2,0] j := by
      simpa only [Matrix.mulVec, Matrix.transpose_apply, dotProduct, mul_comm]
        using c15RawSeparator_products j
    rw [h]
    fin_cases j <;> norm_num

private def c15Shift : ℝ := (∑ p, |c15RawSeparator p|) + |(-9/4 : ℝ)| + 1
private def c15Scale : ℝ := (-9/4 : ℝ) + c15Shift * (Fintype.card (Fin 3) : ℝ)
private def c15Corrected (p : OccurringPattern obstructedData) : ℝ :=
  c15RawSeparator p + c15Shift * c15Cardinality p
private def c15Normalized (p : OccurringPattern obstructedData) : ℝ :=
  c15Corrected p / c15Scale

private theorem c15Shift_value : c15Shift = 45/4 := by
  unfold c15Shift
  rw [← c14ObstructedLabels.sum_comp (fun p => |c15RawSeparator p|)]
  simp only [c15PatternVector_coordinates]
  norm_num [Fin.sum_univ_succ]

private theorem c15Scale_value : c15Scale = 63/2 := by
  rw [c15Scale, c15Shift_value]
  norm_num

example : c15Shift = 45/4 ∧ c15Scale = 63/2 ∧ 0 < c15Scale ∧ c15Scale ≠ 0 := by
  refine ⟨c15Shift_value, c15Scale_value, ?_, ?_⟩ <;>
    rw [c15Scale_value] <;> norm_num

private theorem c15Corrected_eq :
    c15Corrected = c15RawSeparator + c15Shift • c15Cardinality := by
  ext p
  simp only [c15Corrected, Pi.add_apply, Pi.smul_apply, smul_eq_mul]

-- Both the value and every column shift by the same amount.
example : c15Corrected ⬝ᵥ obstructedData.value =
      c15RawSeparator ⬝ᵥ obstructedData.value + c15Shift * 3 ∧
    ∀ π : AdmissiblePartition obstructedData,
      c15Corrected ⬝ᵥ (fun p => reducedMatrix obstructedData p π) =
        c15RawSeparator ⬝ᵥ (fun p => reducedMatrix obstructedData p π) + c15Shift * 3 := by
  simp [c15Corrected_eq, add_dotProduct, smul_dotProduct, smul_eq_mul,
    c15Cardinality_value_dot, c15Cardinality_column_dot]

private theorem c15Corrected_coordinates (i : Fin 7) :
    c15Corrected (c14ObstructedLabels i) =
      ![45/4,45/4,45/4,41/2,41/2,41/2,127/4] i := by
  simp only [c15Corrected, c15PatternVector_coordinates, c15Shift_value]
  fin_cases i <;> norm_num

example : c15Corrected ∘ c14ObstructedLabels =
      ![45/4,45/4,45/4,41/2,41/2,41/2,127/4] ∧
    ∀ p, 0 ≤ c15Corrected p := by
  constructor
  · ext i
    exact c15Corrected_coordinates i
  · intro p
    obtain ⟨i, rfl⟩ := c14ObstructedLabels.surjective p
    rw [c15Corrected_coordinates]
    fin_cases i <;> norm_num

private theorem c15Normalized_coordinates (i : Fin 7) :
    c15Normalized (c14ObstructedLabels i) =
      ![5/14,5/14,5/14,41/63,41/63,41/63,127/126] i := by
  rw [c15Normalized, c15Corrected_coordinates, c15Scale_value]
  fin_cases i <;> norm_num

private theorem c15Normalized_eq :
    c15Normalized = c15PatternVector ![5/14,5/14,5/14,41/63,41/63,41/63,127/126] := by
  ext p
  obtain ⟨i, rfl⟩ := c14ObstructedLabels.surjective p
  rw [c15Normalized_coordinates, c15PatternVector_coordinates]

private theorem c15Normalized_products (j : Fin 5) :
    ((reducedMatrix obstructedData)ᵀ *ᵥ c15Normalized) (r14PaperColumns j) =
      ![127/126,127/126,127/126,127/126,15/14] j := by
  rw [c15Normalized_eq, c15PatternVector_products]
  fin_cases j <;> norm_num [paperMatrix, Fin.sum_univ_succ]

private theorem c15Normalized_objective :
    Dual.objective obstructedData c15Normalized = 125/126 := by
  rw [c15Normalized_eq, c15PatternVector_objective]
  norm_num [obstructedValues, Fin.sum_univ_succ]

private theorem c15Normalized_feasible : Dual.Feasible obstructedData c15Normalized := by
  refine ⟨?_, ?_⟩
  · intro p
    obtain ⟨i, rfl⟩ := c14ObstructedLabels.surjective p
    rw [c15Normalized_coordinates]
    fin_cases i <;> norm_num
  · intro π
    obtain ⟨j, rfl⟩ := r14PaperColumns.surjective π
    rw [c15Normalized_products]
    fin_cases j <;> norm_num

-- Explicit arithmetic validates this vector; no private production helper is imported.
example : Dual.Feasible obstructedData c15Normalized ∧
    Dual.objective obstructedData c15Normalized = 125/126 ∧
    Dual.objective obstructedData c15Normalized < 1 ∧
    ∀ π : AdmissiblePartition obstructedData,
      1 < ((reducedMatrix obstructedData)ᵀ *ᵥ c15Normalized) π := by
  refine ⟨c15Normalized_feasible, c15Normalized_objective, ?_, ?_⟩
  · rw [c15Normalized_objective]
    norm_num
  · intro π
    obtain ⟨j, rfl⟩ := r14PaperColumns.surjective π
    rw [c15Normalized_products]
    fin_cases j <;> norm_num

-- C15-S03 / R05: the retained zero-containing primal point bounds every dual point.
private theorem c15R09_primal : Primal.Feasible r09Data r09Weights ∧
    Primal.objective r09Data r09Weights = 1 :=
  (Primal.equality_feasible_iff r09Data).mp r09Feasible

private theorem c15R09_lower_bound (y : OccurringPattern r09Data → ℝ)
    (hy : Dual.Feasible r09Data y) : 1 ≤ Dual.objective r09Data y := by
  have h := Dual.weak_duality r09Data c15R09_primal.1 hy
  rw [c15R09_primal.2] at h
  exact h

private theorem c15R09_isLeast : IsLeast (Dual.objectiveValues r09Data) 1 := by
  refine ⟨Dual.one_mem_objectiveValues r09Data, ?_⟩
  rintro r ⟨y, hy, rfl⟩
  exact c15R09_lower_bound y hy

example : Primal.Feasible r09Data r09Weights ∧
    Primal.objective r09Data r09Weights = 1 ∧
    r09Weights ⟨singlePartition, r09All_admissible _⟩ = 0 ∧
    (∑ p, r09Data.value p) = 7/4 ∧
    (∀ i : Fin 3, ∑ p : OccurringPattern r09Data,
      (if i ∈ p.val.val then r09Data.value p else 0) = 1) ∧
    ∀ y, Dual.Feasible r09Data y → 1 ≤ Dual.objective r09Data y := by
  refine ⟨c15R09_primal.1, c15R09_primal.2, r09Singleton_zero, ?_, r09Data.row_sum,
    c15R09_lower_bound⟩
  rw [← r09Labels.sum_comp r09Data.value]
  norm_num [r09Value, Fin.sum_univ_succ]

example : IsLeast (Dual.objectiveValues r09Data) 1 ∧
    IsPerfectlyRepresentableChannel r09Data.channel := by
  have hp := (Primal.isPerfectlyRepresentableChannel_iff_exists_objective_eq_one r09Data).mpr
    ⟨r09Weights, c15R09_primal⟩
  exact ⟨(Dual.isPerfectlyRepresentableChannel_iff_isLeast r09Data).mp hp,
    (Dual.isPerfectlyRepresentableChannel_iff_isLeast r09Data).mpr c15R09_isLeast⟩

-- R06's nonempty constraints have a strict subunit value, ruling out leastness at one.
private theorem c15Obstructed_notLeast : ¬ IsLeast (Dual.objectiveValues obstructedData) 1 := by
  intro hl
  have h := hl.2 ⟨c15SubunitDual, c15SubunitDual_feasible, c15SubunitDual_objective⟩
  norm_num at h

example : Fintype.card (AdmissiblePartition obstructedData) = 5 ∧
    ¬ IsLeast (Dual.objectiveValues obstructedData) 1 ∧
    ¬ IsPerfectlyRepresentableChannel obstructedData.channel ∧
    ∀ i : Fin 3, Dual.Feasible obstructedData (Dual.rowWitness obstructedData i) ∧
      Dual.objective obstructedData (Dual.rowWitness obstructedData i) = 1 := by
  refine ⟨?_, c15Obstructed_notLeast, ?_, ?_⟩
  · rw [← Fintype.card_congr r14PaperColumns]
    simp
  · exact fun hp => c15Obstructed_notLeast
      ((Dual.isPerfectlyRepresentableChannel_iff_isLeast obstructedData).mp hp)
  · exact fun i => ⟨Dual.feasible_rowWitness obstructedData i,
      Dual.objective_rowWitness obstructedData i⟩


-- C15-S04 / R08: the row cycle crosses singleton, pair and whole value classes.
private def c15AsymmetricRowPermutation : Fin 7 ≃ Fin 7 :=
  (Equiv.swap 0 3).trans (Equiv.swap 3 6)
private def c15AsymmetricRows : OccurringPattern obstructedData ≃ Fin 7 :=
  c14ObstructedLabels.symm.trans c15AsymmetricRowPermutation
private def c15AsymmetricColumns : AdmissiblePartition obstructedData ≃ Fin 5 :=
  r14PaperColumns.symm.trans paperColumnCycle
private abbrev c15AsymmetricVector := c15PatternVector ![1,2,4,8,16,32,64]

private theorem c15AsymmetricVector_products (j : Fin 5) :
    ((reducedMatrix obstructedData)ᵀ *ᵥ c15AsymmetricVector) (r14PaperColumns j) =
      ![64,12,18,33,7] j := by
  rw [c15PatternVector_products]
  fin_cases j <;> norm_num [paperMatrix, Fin.sum_univ_succ]

private theorem c15AsymmetricVector_objective :
    Dual.objective obstructedData c15AsymmetricVector = 239/8 := by
  rw [c15PatternVector_objective]
  norm_num [obstructedValues, Fin.sum_univ_succ]

private theorem c15AsymmetricVector_feasible :
    Dual.Feasible obstructedData c15AsymmetricVector := by
  refine ⟨?_, ?_⟩
  · intro p
    obtain ⟨i, rfl⟩ := c14ObstructedLabels.surjective p
    change 0 ≤ c15PatternVector ![1,2,4,8,16,32,64] (c14ObstructedLabels i)
    rw [c15PatternVector_coordinates]
    fin_cases i <;> norm_num
  · intro π
    obtain ⟨j, rfl⟩ := r14PaperColumns.surjective π
    rw [c15AsymmetricVector_products]
    fin_cases j <;> norm_num

example : c15AsymmetricRowPermutation 0 = 6 ∧
    c15AsymmetricRowPermutation.symm 0 = 3 := by
  norm_num [c15AsymmetricRowPermutation, Equiv.swap_apply_def]

-- Forward composition would yield 64, so this detects the inverse row direction.
example : (c15AsymmetricVector ∘ c15AsymmetricRows.symm) 0 = 8 ∧
    (![1,2,4,8,16,32,64] : Fin 7 → ℝ) (c15AsymmetricRowPermutation 0) = 64 := by
  constructor
  · change c15PatternVector ![1,2,4,8,16,32,64]
      (c14ObstructedLabels (c15AsymmetricRowPermutation.symm 0)) = 8
    rw [c15PatternVector_coordinates]
    norm_num [c15AsymmetricRowPermutation, Equiv.swap_apply_def]
    rfl
  · norm_num [c15AsymmetricRowPermutation, Equiv.swap_apply_def]
    rfl

example : (obstructedData.value ∘ c15AsymmetricRows.symm) 0 = 3/8 ∧
    obstructedValues (c15AsymmetricRowPermutation 0) = 1/8 := by
  have hv (i : Fin 7) : obstructedData.value (c14ObstructedLabels i) =
      obstructedValues i := dataOfList_value _ _ _ _ _ i
  constructor
  · change obstructedData.value (c14ObstructedLabels (c15AsymmetricRowPermutation.symm 0)) = 3/8
    rw [hv]
    norm_num [obstructedValues, c15AsymmetricRowPermutation, Equiv.swap_apply_def]
    rfl
  · norm_num [obstructedValues, c15AsymmetricRowPermutation, Equiv.swap_apply_def]
    rfl

-- The independent column cycle sends the actual transpose coordinate to 33, not 7.
example : ((Matrix.reindex c15AsymmetricRows c15AsymmetricColumns
      (reducedMatrix obstructedData))ᵀ *ᵥ
      (c15AsymmetricVector ∘ c15AsymmetricRows.symm)) 0 = 33 ∧
    ((reducedMatrix obstructedData)ᵀ *ᵥ c15AsymmetricVector)
      (r14PaperColumns (paperColumnCycle 0)) = 7 := by
  constructor
  · rw [Dual.transpose_mulVec_reindex]
    change ((reducedMatrix obstructedData)ᵀ *ᵥ c15AsymmetricVector)
      (r14PaperColumns (paperColumnCycle.symm 0)) = 33
    rw [c15AsymmetricVector_products]
    norm_num [paperColumnCycle, Equiv.swap_apply_def, Matrix.cons_val_three]
  · rw [c15AsymmetricVector_products]
    norm_num [paperColumnCycle, Equiv.swap_apply_def, Matrix.cons_val_four]

example : (obstructedData.value ∘ c15AsymmetricRows.symm) ⬝ᵥ
    (c15AsymmetricVector ∘ c15AsymmetricRows.symm) = 239/8 ∧
    (c15AsymmetricVector ∘ c15AsymmetricRows.symm) ∘ c15AsymmetricRows =
      c15AsymmetricVector := by
  refine ⟨(Dual.objective_reindex obstructedData c15AsymmetricVector
    c15AsymmetricRows).trans c15AsymmetricVector_objective, ?_⟩
  ext p
  simp only [Function.comp_apply, Equiv.symm_apply_apply]

private def c15AsymmetricFiniteValues : Set ℝ :=
  (fun z : Fin 7 → ℝ => (obstructedData.value ∘ c15AsymmetricRows.symm) ⬝ᵥ z) ''
    {z | (∀ i, 0 ≤ z i) ∧ ∀ j,
      1 ≤ ((Matrix.reindex c15AsymmetricRows c15AsymmetricColumns
        (reducedMatrix obstructedData))ᵀ *ᵥ z) j}

example : c15AsymmetricFiniteValues = Dual.objectiveValues obstructedData :=
  Dual.objectiveValues_reindex obstructedData c15AsymmetricRows c15AsymmetricColumns

-- Both sides contain actual feasible witnesses; the subunit value also transports.
example : 239/8 ∈ c15AsymmetricFiniteValues ∧
    239/8 ∈ Dual.objectiveValues obstructedData ∧ 1/2 ∈ c15AsymmetricFiniteValues := by
  have hi : c15AsymmetricFiniteValues = Dual.objectiveValues obstructedData :=
    Dual.objectiveValues_reindex obstructedData c15AsymmetricRows c15AsymmetricColumns
  have hf : 239/8 ∈ c15AsymmetricFiniteValues :=
    ⟨c15AsymmetricVector ∘ c15AsymmetricRows.symm,
      (Dual.feasible_reindex_iff obstructedData c15AsymmetricVector
        c15AsymmetricRows c15AsymmetricColumns).mp c15AsymmetricVector_feasible,
      (Dual.objective_reindex obstructedData c15AsymmetricVector
        c15AsymmetricRows).trans c15AsymmetricVector_objective⟩
  refine ⟨hf, hi ▸ hf, ?_⟩
  rw [hi]
  exact ⟨c15SubunitDual, c15SubunitDual_feasible, c15SubunitDual_objective⟩

-- R10 uses the existing counts, distinguishing occurring m=7 from the full bound.
example : Fintype.card (OccurringPattern obstructedData) = 7 ∧
    Fintype.card (AdmissiblePartition obstructedData) = 5 ∧
    obstructedData.patterns.card ≤ 2 ^ Fintype.card (Fin 3) - 1 := by
  refine ⟨?_, ?_, patterns_card_le obstructedData⟩
  · exact (Fintype.card_congr c15AsymmetricRows).trans (Fintype.card_fin 7)
  · exact (Fintype.card_congr c15AsymmetricColumns).trans (Fintype.card_fin 5)

example : let rows := r09Labels.symm
    let cols := Fintype.equivFin (AdmissiblePartition r09Data)
    IsLeast ((fun z : Fin 7 → ℝ => (r09Data.value ∘ rows.symm) ⬝ᵥ z) ''
      {z | (∀ i, 0 ≤ z i) ∧ ∀ j,
        1 ≤ ((Matrix.reindex rows cols (reducedMatrix r09Data))ᵀ *ᵥ z) j}) 1 ∧
      IsPerfectlyRepresentableChannel r09Data.channel := by
  dsimp only
  have hp := (isPerfectlyRepresentableChannel_iff_exists_feasible r09Data).mpr
    ⟨r09Weights, r09Feasible⟩
  have hl := (Dual.isPerfectlyRepresentableChannel_iff_isLeast_reindex
    r09Data r09Labels.symm (Fintype.equivFin _)).mp hp
  exact ⟨hl, (Dual.isPerfectlyRepresentableChannel_iff_isLeast_reindex
    r09Data r09Labels.symm (Fintype.equivFin _)).mpr hl⟩

end
end PerfectFunctionalRepresentations.Incidence.Tests.Concrete

namespace PerfectFunctionalRepresentations.Incidence.Tests.WholeOnly

noncomputable section
attribute [local instance] Classical.propDecidable
local instance : DecidableEq (Fin 3) := fun a b => Classical.propDecidable (a = b)
attribute [local simp] Fin.ext_iff
open scoped BigOperators Matrix
open Incidence

private abbrev R08Pattern := NonzeroPattern (Fin 3)
private abbrev R08Partition := ExactPartition (Fin 3)

private def r08WholePattern : R08Pattern := ⟨Finset.univ, Finset.univ_nonempty⟩
private def r08SinglePattern : R08Pattern := ⟨{0}, by simp⟩
private def r08WholePartition : R08Partition :=
  Finpartition.indiscrete Finset.univ_nonempty.ne_empty
private def r08SinglesPartition : R08Partition := ⊥

private def r08Data : CompressedPatternData (Fin 3) where
  patterns := {r08WholePattern}
  value := fun _ => 1
  value_pos := fun _ => by norm_num
  row_sum := by
    intro x
    rw [Finset.sum_coe_sort {r08WholePattern}
      (fun p : R08Pattern => if x ∈ p.val then (1 : ℝ) else 0)]
    rw [Finset.sum_singleton]
    simp only [r08WholePattern, Finset.mem_univ, if_true]

private theorem r08Pattern_eq (p : Incidence.OccurringPattern r08Data) :
    p.val = r08WholePattern := Finset.mem_singleton.mp p.property

private theorem r08Whole_whole : fullMatrix r08WholePattern r08WholePartition = 1 := by
  simp [fullMatrix, r08WholePattern, r08WholePartition]

private theorem r08Whole_singles : fullMatrix r08WholePattern r08SinglesPartition = 0 := by
  norm_num [fullMatrix, r08WholePattern, r08SinglesPartition, Fin.exists_fin_succ,
    Finset.ext_iff, Fin.forall_fin_succ, -Fin.val_eq_zero_iff]

private theorem r08Single_whole : fullMatrix r08SinglePattern r08WholePartition = 0 := by
  norm_num [fullMatrix, r08SinglePattern, r08WholePartition, Finset.ext_iff,
    Fin.forall_fin_succ, -Fin.val_eq_zero_iff]

private theorem r08Single_singles :
    fullMatrix r08SinglePattern r08SinglesPartition = 1 := by
  simp [fullMatrix, r08SinglePattern, r08SinglesPartition]

private theorem r08Partitions_ne : r08WholePartition ≠ r08SinglesPartition := by
  intro h
  have he := congrArg (fun π : R08Partition => fullMatrix r08SinglePattern π) h
  rw [r08Single_whole, r08Single_singles] at he
  norm_num at he

private theorem r08Single_absent : r08SinglePattern ∉ r08Data.patterns := by
  simp only [r08Data, Finset.mem_singleton]
  intro h
  have he := congrArg (fun p : R08Pattern => (1 : Fin 3) ∈ p.val) h
  norm_num [r08SinglePattern, r08WholePattern] at he

private theorem r08Single_fullValue : fullValue r08Data r08SinglePattern = 0 :=
  fullValue_of_not_mem r08Data r08SinglePattern r08Single_absent

private def r08Bad : R08Partition → ℝ :=
  Pi.single r08WholePartition 1 + Pi.single r08SinglesPartition 2

private theorem r08Bad_atWhole : r08Bad r08WholePartition = 1 := by
  simp [r08Bad, r08Partitions_ne]

private theorem r08Bad_atSingles : r08Bad r08SinglesPartition = 2 := by
  simp [r08Bad, Ne.symm r08Partitions_ne]

private theorem r08Bad_nonneg (π : R08Partition) : 0 ≤ r08Bad π := by
  unfold r08Bad
  simp only [Pi.add_apply, Pi.single_apply]
  split_ifs <;> norm_num

private theorem r08Bad_wholeRow : (fullMatrix *ᵥ r08Bad) r08WholePattern = 1 := by
  simp only [r08Bad, Matrix.mulVec_add, Matrix.mulVec_single, Pi.add_apply]
  change fullMatrix r08WholePattern r08WholePartition * 1 +
    fullMatrix r08WholePattern r08SinglesPartition * 2 = 1
  rw [r08Whole_whole, r08Whole_singles]
  norm_num

private theorem r08Bad_singleRow : (fullMatrix *ᵥ r08Bad) r08SinglePattern = 2 := by
  simp only [r08Bad, Matrix.mulVec_add, Matrix.mulVec_single, Pi.add_apply]
  change fullMatrix r08SinglePattern r08WholePartition * 1 +
    fullMatrix r08SinglePattern r08SinglesPartition * 2 = 2
  rw [r08Single_whole, r08Single_singles]
  norm_num

private def r08MixedMatrix : Matrix (Incidence.OccurringPattern r08Data) R08Partition ℝ :=
  fun p π => fullMatrix p.val π

private theorem r08Mixed_equality : r08MixedMatrix *ᵥ r08Bad = r08Data.value := by
  funext p
  change (fullMatrix *ᵥ r08Bad) p.val = 1
  rw [r08Pattern_eq, r08Bad_wholeRow]

private theorem r08Bad_not_full : fullMatrix *ᵥ r08Bad ≠ fullValue r08Data := by
  intro h
  have he := congrFun h r08SinglePattern
  rw [r08Bad_singleRow, r08Single_fullValue] at he
  norm_num at he

private theorem r08Bad_not_fullFeasible : ¬ FullFeasible r08Data r08Bad := by
  intro h
  exact r08Bad_not_full h.2

private theorem r08Admissible_iff (π : R08Partition) :
    IsAdmissible r08Data π ↔ π = r08WholePartition := by
  constructor
  · intro hπ
    have hblock (b : Finset (Fin 3)) (hb : b ∈ π.parts) : b = Finset.univ := by
      have h := hπ ⟨b, hb⟩
      have he := Finset.mem_singleton.mp h
      exact congrArg Subtype.val he
    obtain ⟨b, hb, _⟩ := π.exists_mem (Finset.mem_univ (0 : Fin 3))
    have hu : Finset.univ ∈ π.parts := by simpa only [hblock b hb] using hb
    apply Finpartition.ext
    ext c
    change c ∈ π.parts ↔ c ∈ ({Finset.univ} : Finset (Finset (Fin 3)))
    rw [Finset.mem_singleton]
    constructor
    · exact hblock c
    · rintro rfl
      exact hu
  · rintro rfl b
    have hb : b.val = Finset.univ := Finset.mem_singleton.mp b.property
    exact Finset.mem_singleton.mpr (Subtype.ext hb)

private def r08AdmissibleWhole : AdmissiblePartition r08Data :=
  ⟨r08WholePartition, (r08Admissible_iff _).mpr rfl⟩

private instance : Unique (AdmissiblePartition r08Data) where
  default := r08AdmissibleWhole
  uniq π := Subtype.ext ((r08Admissible_iff π.val).mp π.property)

example : Fintype.card (AdmissiblePartition r08Data) = 1 := Fintype.card_unique

private theorem r08Restricted_value (π : AdmissiblePartition r08Data) :
    restrictWeights r08Data r08Bad π = 1 := by
  change r08Bad π.val = 1
  rw [(r08Admissible_iff _).mp π.property, r08Bad_atWhole]

private theorem r08Restricted_nonneg (π : AdmissiblePartition r08Data) :
    0 ≤ restrictWeights r08Data r08Bad π := by rw [r08Restricted_value]; norm_num

private theorem r08Reduced_equality :
    reducedMatrix r08Data *ᵥ restrictWeights r08Data r08Bad = r08Data.value := by
  funext p
  simp only [Matrix.mulVec, dotProduct, Finset.univ_unique, Finset.sum_singleton,
    r08Restricted_value, mul_one]
  change fullMatrix p.val r08WholePartition = 1
  rw [r08Pattern_eq, r08Whole_whole]

private theorem r08Restricted_feasible :
    Feasible r08Data (restrictWeights r08Data r08Bad) :=
  ⟨r08Restricted_nonneg, r08Reduced_equality⟩

private theorem r08Extended_eq :
    extendWeights r08Data (restrictWeights r08Data r08Bad) =
      Pi.single r08WholePartition 1 := by
  funext π
  simp [extendWeights, r08Restricted_value, r08Admissible_iff, Pi.single_apply]

private theorem r08Extended_atSingles :
    extendWeights r08Data (restrictWeights r08Data r08Bad) r08SinglesPartition = 0 := by
  rw [r08Extended_eq]
  simp [Ne.symm r08Partitions_ne]

private theorem r08Extended_ne_bad :
    extendWeights r08Data (restrictWeights r08Data r08Bad) ≠ r08Bad := by
  intro h
  have he := congrFun h r08SinglesPartition
  rw [r08Extended_atSingles, r08Bad_atSingles] at he
  norm_num at he

private theorem r08FullValue (p : R08Pattern) :
    fullValue r08Data p = if p = r08WholePattern then 1 else 0 := by
  by_cases hp : p = r08WholePattern
  · subst p
    rw [if_pos rfl]
    exact fullValue_of_mem r08Data _ (Finset.mem_singleton_self _)
  · rw [if_neg hp]
    exact fullValue_of_not_mem r08Data _ (fun h => hp (Finset.mem_singleton.mp h))

private theorem r08Extended_full :
    fullMatrix *ᵥ extendWeights r08Data (restrictWeights r08Data r08Bad) =
      fullValue r08Data := by
  rw [r08Extended_eq, Matrix.mulVec_single]
  funext p
  change fullMatrix p r08WholePartition * 1 = fullValue r08Data p
  rw [r08FullValue]
  simp only [fullMatrix, r08WholePartition, Finpartition.indiscrete, Finset.mem_singleton,
    mul_one]
  congr 1
  apply propext
  constructor
  · intro h
    exact Subtype.ext h
  · intro h
    exact congrArg Subtype.val h

private theorem r08Extended_fullFeasible :
    FullFeasible r08Data (extendWeights r08Data (restrictWeights r08Data r08Bad)) :=
  fullFeasible_extendWeights r08Data r08Restricted_feasible

-- S05: the same R08 witness in the exhaustive paper coordinates.
private theorem r08Bad_paper_coordinates :
    r08Bad ∘ Concrete.paperColumns = ![1,0,0,0,2] := by
  have h : r08Bad = Concrete.sparse 1 0 0 0 2 := by
    simp [r08Bad, Concrete.sparse, r08WholePartition, r08SinglesPartition,
      Concrete.wholePartition, Concrete.singlePartition]
  rw [h]
  exact Concrete.paper_sparse_coordinates 1 0 0 0 2

private theorem r08Extended_paper_coordinates :
    extendWeights r08Data (restrictWeights r08Data r08Bad) ∘
      Concrete.paperColumns = ![1,0,0,0,0] := by
  rw [r08Extended_eq]
  have h : Pi.single r08WholePartition (1 : ℝ) = Concrete.sparse 1 0 0 0 0 := by
    simp [Concrete.sparse, r08WholePartition, Concrete.wholePartition]
  rw [h]
  exact Concrete.paper_sparse_coordinates 1 0 0 0 0

-- Full rejection and reduced acceptance refer to different typed vectors.
example : r08Bad ∘ Concrete.paperColumns = ![1,0,0,0,2] ∧
    ¬ FullFeasible r08Data r08Bad ∧
    Feasible r08Data (restrictWeights r08Data r08Bad) ∧
    extendWeights r08Data (restrictWeights r08Data r08Bad) ∘
      Concrete.paperColumns = ![1,0,0,0,0] ∧
    extendWeights r08Data (restrictWeights r08Data r08Bad) ≠ r08Bad :=
  ⟨r08Bad_paper_coordinates, r08Bad_not_fullFeasible, r08Restricted_feasible,
    r08Extended_paper_coordinates, r08Extended_ne_bad⟩

end
end PerfectFunctionalRepresentations.Incidence.Tests.WholeOnly
