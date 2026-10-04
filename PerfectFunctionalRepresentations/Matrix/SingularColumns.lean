import PerfectFunctionalRepresentations.Matrix.Channel

/-!
# Values and patterns of admitted singular columns

Definition 4 of the ISIT manuscript, supplemented by extended Section III-A,
assigns a value only to a nonzero column of a singular channel. Its pattern is
the nonempty finite set of inputs with nonzero mass. Patterns themselves do
not require singularity, and neither accessor supplies data for a zero column.

Exact values use `ENNReal`; the Real value and division indicator are proved
coordinates. A column is not a probability distribution over inputs, so its
pattern does not use a PMF support finset or assume column normalization.
-/

namespace PerfectFunctionalRepresentations

open scoped BigOperators ENNReal

noncomputable section
attribute [local instance] Classical.propDecidable

universe u v u' v'
variable {alpha : Type u} {beta : Type v}

private theorem admitted_column_nonzero (kappa : alpha → PMF beta)
    (y : activeOutputs kappa) : ∃ x, kappa x y.val ≠ 0 := by
  obtain ⟨x, hx⟩ := y.property
  exact ⟨x, (PMF.mem_support_iff _ _).mp hx⟩

/-- The common nonzero mass of an admitted singular column. The singularity
premise is part of the accessor's domain; independence of the witness is proved
by `columnValue_eq_of_ne_zero`. -/
noncomputable def columnValue (kappa : alpha → PMF beta)
    (_hSingular : IsSingularChannel kappa) (y : activeOutputs kappa) : ℝ≥0∞ :=
  kappa (Classical.choose (admitted_column_nonzero kappa y)) y.val

/-- Any nonzero entry computes the value, independently of the chosen witness. -/
theorem columnValue_eq_of_ne_zero (kappa : alpha → PMF beta)
    (hSingular : IsSingularChannel kappa) (y : activeOutputs kappa)
    {x : alpha} (hx : kappa x y.val ≠ 0) : columnValue kappa hSingular y = kappa x y.val :=
  hSingular _ x y.val (Classical.choose_spec (admitted_column_nonzero kappa y)) hx

theorem columnValue_pos (kappa : alpha → PMF beta)
    (hSingular : IsSingularChannel kappa) (y : activeOutputs kappa) :
    0 < columnValue kappa hSingular y :=
  pos_iff_ne_zero.mpr (Classical.choose_spec (admitted_column_nonzero kappa y))

theorem columnValue_le_one (kappa : alpha → PMF beta)
    (hSingular : IsSingularChannel kappa) (y : activeOutputs kappa) :
    columnValue kappa hSingular y ≤ 1 :=
  (kappa _).coe_le_one y.val

theorem columnValue_ne_top (kappa : alpha → PMF beta)
    (hSingular : IsSingularChannel kappa) (y : activeOutputs kappa) :
    columnValue kappa hSingular y ≠ ∞ :=
  (kappa _).apply_ne_top y.val

theorem columnValue_toReal_pos (kappa : alpha → PMF beta)
    (hSingular : IsSingularChannel kappa) (y : activeOutputs kappa) :
    0 < (columnValue kappa hSingular y).toReal :=
  ENNReal.toReal_pos (ne_of_gt (columnValue_pos kappa hSingular y))
    (columnValue_ne_top kappa hSingular y)

theorem columnValue_toReal_le_one (kappa : alpha → PMF beta)
    (hSingular : IsSingularChannel kappa) (y : activeOutputs kappa) :
    (columnValue kappa hSingular y).toReal ≤ 1 := by
  simpa only [ENNReal.toReal_one] using
    ENNReal.toReal_mono ENNReal.one_ne_top (columnValue_le_one kappa hSingular y)

@[simp]
theorem ofReal_columnValue_toReal (kappa : alpha → PMF beta)
    (hSingular : IsSingularChannel kappa) (y : activeOutputs kappa) :
    ENNReal.ofReal (columnValue kappa hSingular y).toReal = columnValue kappa hSingular y :=
  ENNReal.ofReal_toReal (columnValue_ne_top kappa hSingular y)

/-- The nonempty input support of an admitted column. A pattern is meaningful
before singularity is assumed; its value accessor is deliberately separate. -/
noncomputable def columnPattern [Fintype alpha] (kappa : alpha → PMF beta)
    (y : activeOutputs kappa) : {s : Finset alpha // s.Nonempty} := by
  refine ⟨Finset.univ.filter (fun x => kappa x y.val ≠ 0), ?_⟩
  obtain ⟨x, hx⟩ := admitted_column_nonzero kappa y
  exact ⟨x, by simp [hx]⟩

@[simp]
theorem mem_columnPattern [Fintype alpha] (kappa : alpha → PMF beta)
    (y : activeOutputs kappa) (x : alpha) :
    x ∈ (columnPattern kappa y).val ↔ kappa x y.val ≠ 0 := by
  simp [columnPattern]

/-- The exact column is recovered from its nonempty pattern and positive value. -/
theorem column_eq_ite [Fintype alpha] (kappa : alpha → PMF beta)
    (hSingular : IsSingularChannel kappa) (y : activeOutputs kappa) (x : alpha) :
    kappa x y.val =
      if x ∈ (columnPattern kappa y).val then columnValue kappa hSingular y else 0 := by
  by_cases hx : x ∈ (columnPattern kappa y).val
  · rw [if_pos hx]
    exact (columnValue_eq_of_ne_zero kappa hSingular y
      ((mem_columnPattern kappa y x).mp hx)).symm
  · rw [if_neg hx]
    by_contra hn
    exact hx ((mem_columnPattern kappa y x).mpr hn)

theorem column_toReal_eq_ite [Fintype alpha] (kappa : alpha → PMF beta)
    (hSingular : IsSingularChannel kappa) (y : activeOutputs kappa) (x : alpha) :
    (kappa x y.val).toReal =
      if x ∈ (columnPattern kappa y).val then (columnValue kappa hSingular y).toReal else 0 := by
  rw [column_eq_ite kappa hSingular y x]
  split_ifs <;> rfl

/-- Definition 4's divided Real column is precisely the numeric support indicator. -/
theorem column_div_value [Fintype alpha] (kappa : alpha → PMF beta)
    (hSingular : IsSingularChannel kappa) (y : activeOutputs kappa) (x : alpha) :
    realMatrix kappa x y.val / (columnValue kappa hSingular y).toReal =
      if x ∈ (columnPattern kappa y).val then 1 else 0 := by
  rw [realMatrix_apply, column_toReal_eq_ite kappa hSingular y x]
  have hv := ne_of_gt (columnValue_toReal_pos kappa hSingular y)
  by_cases hx : x ∈ (columnPattern kappa y).val <;> simp [hx, hv]

/-- Boolean membership is a derived presentation of the intrinsic nonzero test. -/
theorem columnPattern_decide_mem [Fintype alpha] (kappa : alpha → PMF beta)
    (y : activeOutputs kappa) (x : alpha) :
    decide (x ∈ (columnPattern kappa y).val) = decide (kappa x y.val ≠ 0) := by
  simp only [mem_columnPattern]

theorem column_div_value_eq_bool [Fintype alpha] (kappa : alpha → PMF beta)
    (hSingular : IsSingularChannel kappa) (y : activeOutputs kappa) (x : alpha) :
    realMatrix kappa x y.val / (columnValue kappa hSingular y).toReal =
      cond (decide (x ∈ (columnPattern kappa y).val)) (1 : ℝ) 0 := by
  rw [column_div_value kappa hSingular y x]
  by_cases hx : x ∈ (columnPattern kappa y).val <;> simp [hx]

/-- Positive values and nonempty patterns representing the same exact column
are unique. No strict upper bound or pre-assumed finiteness is required. -/
theorem columnData_unique [Fintype alpha] (kappa : alpha → PMF beta)
    (hSingular : IsSingularChannel kappa) (y : activeOutputs kappa)
    (t : Finset alpha) (ht : t.Nonempty) (w : ℝ≥0∞) (hw : 0 < w)
    (hdata : ∀ x, kappa x y.val = if x ∈ t then w else 0) :
    t = (columnPattern kappa y).val ∧ w = columnValue kappa hSingular y := by
  constructor
  · ext x
    rw [mem_columnPattern, hdata x]
    by_cases hx : x ∈ t <;> simp [hx, ne_of_gt hw]
  · obtain ⟨x, hx⟩ := ht
    have hmass : kappa x y.val = w := by simpa only [hx, if_true] using hdata x
    have hn : kappa x y.val ≠ 0 := by rw [hmass]; exact ne_of_gt hw
    exact hmass.symm.trans (columnValue_eq_of_ne_zero kappa hSingular y hn).symm

/-- Real uniqueness follows by exact ofReal recovery of the PMF entries. The
candidate Real value needs positivity, not a separate upper-bound premise. -/
theorem columnData_toReal_unique [Fintype alpha] (kappa : alpha → PMF beta)
    (hSingular : IsSingularChannel kappa) (y : activeOutputs kappa)
    (t : Finset alpha) (ht : t.Nonempty) (w : ℝ) (hw : 0 < w)
    (hdata : ∀ x, (kappa x y.val).toReal = if x ∈ t then w else 0) :
    t = (columnPattern kappa y).val ∧ w = (columnValue kappa hSingular y).toReal := by
  have hexact (x : alpha) : kappa x y.val = if x ∈ t then ENNReal.ofReal w else 0 := by
    rw [← ENNReal.ofReal_toReal ((kappa x).apply_ne_top y.val), hdata x]
    by_cases hx : x ∈ t <;> simp [hx]
  obtain ⟨hpattern, hvalue⟩ := columnData_unique kappa hSingular y t ht
    (ENNReal.ofReal w) (ENNReal.ofReal_pos.mpr hw) hexact
  refine ⟨hpattern, ?_⟩
  rw [← hvalue, ENNReal.toReal_ofReal (le_of_lt hw)]

/-! ## Transport of actual admitted columns -/

/-- Equal entries after an input equivalence preserve the admitted value.
Outputs may live in unrelated universes and need not be finite. -/
theorem columnValue_transport {alpha' : Type u'} {beta' : Type v'}
    (kappa : alpha → PMF beta) (eta : alpha' → PMF beta')
    (hKappa : IsSingularChannel kappa) (hEta : IsSingularChannel eta)
    (y : activeOutputs kappa) (z : activeOutputs eta) (eX : alpha ≃ alpha')
    (hcoord : ∀ x, eta (eX x) z.val = kappa x y.val) :
    columnValue eta hEta z = columnValue kappa hKappa y := by
  obtain ⟨x, hx⟩ := admitted_column_nonzero kappa y
  have hz : eta (eX x) z.val ≠ 0 := by rw [hcoord x]; exact hx
  rw [columnValue_eq_of_ne_zero eta hEta z hz,
    columnValue_eq_of_ne_zero kappa hKappa y hx]
  exact hcoord x

/-- Actual column transport maps the input support by the forward equivalence;
membership on the new alphabet consequently uses its inverse. -/
theorem columnPattern_transport {alpha' : Type u'} {beta' : Type v'}
    [Fintype alpha] [Fintype alpha']
    (kappa : alpha → PMF beta) (eta : alpha' → PMF beta')
    (y : activeOutputs kappa) (z : activeOutputs eta) (eX : alpha ≃ alpha')
    (hcoord : ∀ x, eta (eX x) z.val = kappa x y.val) :
    (columnPattern eta z).val = (columnPattern kappa y).val.map eX.toEmbedding := by
  ext x
  rw [mem_columnPattern, Finset.mem_map_equiv, mem_columnPattern,
    ← hcoord (eX.symm x), eX.apply_symm_apply]


/-! ## Normalized column families and whole-channel reconstruction -/

variable {α : Type u} {β : Type v}

/-- Weighted input patterns with normalized rows define a semantic channel.
Positivity is needed for active-output recovery, not for this coordinate inverse. -/
def channelOfColumnData [Fintype β]
    (s : β → {s : Finset α // s.Nonempty}) (v : β → ℝ≥0∞)
    (hrow : ∀ x, ∑ y, (if x ∈ (s y).val then v y else 0) = 1) : α → PMF β :=
  channelOfMassMatrix (fun x y => if x ∈ (s y).val then v y else 0) hrow

@[simp]
theorem channelOfColumnData_apply [Fintype β]
    (s : β → {s : Finset α // s.Nonempty}) (v : β → ℝ≥0∞)
    (hrow : ∀ x, ∑ y, (if x ∈ (s y).val then v y else 0) = 1) (x : α) (y : β) :
    channelOfColumnData s v hrow x y = if x ∈ (s y).val then v y else 0 := rfl

/-- Each supplied value is bounded by a normalized row containing it. -/
theorem columnData_value_le_one [Fintype β]
    (s : β → {s : Finset α // s.Nonempty}) (v : β → ℝ≥0∞)
    (hrow : ∀ x, ∑ y, (if x ∈ (s y).val then v y else 0) = 1) (y : β) :
    v y ≤ 1 := by
  obtain ⟨x, hx⟩ := (s y).property
  simpa [massMatrix, hx] using massMatrix_le_one (channelOfColumnData s v hrow) x y

theorem columnData_value_ne_top [Fintype β]
    (s : β → {s : Finset α // s.Nonempty}) (v : β → ℝ≥0∞)
    (hrow : ∀ x, ∑ y, (if x ∈ (s y).val then v y else 0) = 1) (y : β) :
    v y ≠ ∞ := ne_top_of_le_ne_top (by simp) (columnData_value_le_one s v hrow y)

/-- Strictly positive values and nonempty patterns make every output active. -/
theorem channelOfColumnData_active [Fintype β]
    (s : β → {s : Finset α // s.Nonempty}) (v : β → ℝ≥0∞)
    (hrow : ∀ x, ∑ y, (if x ∈ (s y).val then v y else 0) = 1)
    (hv : ∀ y, 0 < v y) (y : β) : y ∈ activeOutputs (channelOfColumnData s v hrow) := by
  obtain ⟨x, hx⟩ := (s y).property
  exact ⟨x, by simpa [PMF.mem_support_iff, hx] using (ne_of_gt (hv y))⟩

theorem isSingularChannel_channelOfColumnData [Fintype β]
    (s : β → {s : Finset α // s.Nonempty}) (v : β → ℝ≥0∞)
    (hrow : ∀ x, ∑ y, (if x ∈ (s y).val then v y else 0) = 1) :
    IsSingularChannel (channelOfColumnData s v hrow) := by
  intro x₁ x₂ y h₁ h₂
  have hx₁ : x₁ ∈ (s y).val := by
    by_contra h
    exact h₁ (by simp [h])
  have hx₂ : x₂ ∈ (s y).val := by
    by_contra h
    exact h₂ (by simp [h])
  simp [hx₁, hx₂]

/-- Output nonemptiness follows from a normalized row when an input exists. -/
theorem columnData_nonempty_output [Fintype β] [Nonempty α]
    (s : β → {s : Finset α // s.Nonempty}) (v : β → ℝ≥0∞)
    (hrow : ∀ x, ∑ y, (if x ∈ (s y).val then v y else 0) = 1) : Nonempty β := by
  obtain ⟨x⟩ := ‹Nonempty α›
  obtain ⟨y, _⟩ := (channelOfColumnData s v hrow x).support_nonempty
  exact ⟨y⟩

theorem columnData_toReal_row_sum [Fintype β]
    (s : β → {s : Finset α // s.Nonempty}) (v : β → ℝ≥0∞)
    (hrow : ∀ x, ∑ y, (if x ∈ (s y).val then v y else 0) = 1) (x : α) :
    ∑ y, (if x ∈ (s y).val then (v y).toReal else 0) = 1 := by
  simpa [realMatrix, apply_ite] using realMatrix_row_sum (channelOfColumnData s v hrow) x

/-- The normalized positive family recovers each supplied exact value. -/
theorem columnValue_channelOfColumnData [Fintype β]
    (s : β → {s : Finset α // s.Nonempty}) (v : β → ℝ≥0∞)
    (hrow : ∀ x, ∑ y, (if x ∈ (s y).val then v y else 0) = 1)
    (hv : ∀ y, 0 < v y) (y : β) :
    columnValue (channelOfColumnData s v hrow) (isSingularChannel_channelOfColumnData s v hrow)
      ⟨y, channelOfColumnData_active s v hrow hv y⟩ = v y := by
  obtain ⟨x, hx⟩ := (s y).property
  rw [columnValue_eq_of_ne_zero (channelOfColumnData s v hrow)
    (isSingularChannel_channelOfColumnData s v hrow)
    ⟨y, channelOfColumnData_active s v hrow hv y⟩
    (show channelOfColumnData s v hrow x y ≠ 0 by simpa [hx] using ne_of_gt (hv y))]
  simp [hx]

theorem columnPattern_channelOfColumnData [Fintype α] [Fintype β]
    (s : β → {s : Finset α // s.Nonempty}) (v : β → ℝ≥0∞)
    (hrow : ∀ x, ∑ y, (if x ∈ (s y).val then v y else 0) = 1)
    (hv : ∀ y, 0 < v y) (y : β) :
    columnPattern (channelOfColumnData s v hrow)
      ⟨y, channelOfColumnData_active s v hrow hv y⟩ = s y := by
  apply Subtype.ext
  exact (columnData_unique (channelOfColumnData s v hrow)
    (isSingularChannel_channelOfColumnData s v hrow)
    ⟨y, channelOfColumnData_active s v hrow hv y⟩ (s y).val (s y).property (v y) (hv y)
    (fun x => channelOfColumnData_apply s v hrow x y)).1.symm

/-- Exact weighted row normalization of the admitted data of an active channel. -/
theorem columnValue_row_sum [Fintype α] [Fintype β]
    (κ : α → PMF β) (hκ : IsSingularChannel κ) (ha : ∀ y, y ∈ activeOutputs κ) (x : α) :
    ∑ y, (if x ∈ (columnPattern κ ⟨y, ha y⟩).val
      then columnValue κ hκ ⟨y, ha y⟩ else 0) = 1 := by
  calc
    _ = ∑ y, κ x y :=
      Finset.sum_congr rfl (fun y _ => (column_eq_ite κ hκ ⟨y, ha y⟩ x).symm)
    _ = 1 := massMatrix_row_sum κ x

theorem columnValue_toReal_row_sum [Fintype α] [Fintype β]
    (κ : α → PMF β) (hκ : IsSingularChannel κ) (ha : ∀ y, y ∈ activeOutputs κ) (x : α) :
    ∑ y, (if x ∈ (columnPattern κ ⟨y, ha y⟩).val
      then (columnValue κ hκ ⟨y, ha y⟩).toReal else 0) = 1 := by
  calc
    _ = ∑ y, (κ x y).toReal :=
      Finset.sum_congr rfl (fun y _ => (column_toReal_eq_ite κ hκ ⟨y, ha y⟩ x).symm)
    _ = 1 := realMatrix_row_sum κ x

/-- Recover the entire active singular channel through the existing exact inverse. -/
theorem channelOfColumnData_reconstruct [Fintype α] [Fintype β]
    (κ : α → PMF β) (hκ : IsSingularChannel κ) (ha : ∀ y, y ∈ activeOutputs κ) :
    channelOfColumnData (fun y => columnPattern κ ⟨y, ha y⟩)
      (fun y => columnValue κ hκ ⟨y, ha y⟩) (columnValue_row_sum κ hκ ha) = κ := by
  apply massMatrix_injective
  funext x y
  exact (column_eq_ite κ hκ ⟨y, ha y⟩ x).symm

/-- The derived Real data also recover the semantic channel through the Real inverse. -/
theorem channelOfRealColumnData_reconstruct [Fintype α] [Fintype β]
    (κ : α → PMF β) (hκ : IsSingularChannel κ) (ha : ∀ y, y ∈ activeOutputs κ) :
    channelOfRealMatrix
      (Matrix.of fun x y => if x ∈ (columnPattern κ ⟨y, ha y⟩).val
        then (columnValue κ hκ ⟨y, ha y⟩).toReal else 0)
      (fun x y => by
        change 0 ≤ if x ∈ (columnPattern κ ⟨y, ha y⟩).val
          then (columnValue κ hκ ⟨y, ha y⟩).toReal else 0
        split_ifs <;> positivity)
      (columnValue_toReal_row_sum κ hκ ha) = κ := by
  apply massMatrix_injective
  funext x y
  change ENNReal.ofReal (if x ∈ (columnPattern κ ⟨y, ha y⟩).val
    then (columnValue κ hκ ⟨y, ha y⟩).toReal else 0) = κ x y
  rw [← column_toReal_eq_ite κ hκ ⟨y, ha y⟩ x]
  exact ENNReal.ofReal_toReal ((κ x).apply_ne_top y)

/-- Equal values and patterns on the same active output labels determine a channel. -/
theorem channel_eq_of_columnData [Fintype α]
    (κ η : α → PMF β) (hκ : IsSingularChannel κ) (hη : IsSingularChannel η)
    (ha : ∀ y, y ∈ activeOutputs κ) (hb : ∀ y, y ∈ activeOutputs η)
    (hs : ∀ y, columnPattern κ ⟨y, ha y⟩ = columnPattern η ⟨y, hb y⟩)
    (hv : ∀ y, columnValue κ hκ ⟨y, ha y⟩ = columnValue η hη ⟨y, hb y⟩) : κ = η := by
  apply massMatrix_injective
  funext x y
  change κ x y = η x y
  rw [column_eq_ite κ hκ ⟨y, ha y⟩ x, column_eq_ite η hη ⟨y, hb y⟩ x, hs y, hv y]


end
end PerfectFunctionalRepresentations
