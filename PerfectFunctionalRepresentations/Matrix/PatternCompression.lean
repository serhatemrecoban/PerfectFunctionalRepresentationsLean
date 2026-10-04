import PerfectFunctionalRepresentations.Matrix.MultiwayOperations
import PerfectFunctionalRepresentations.Matrix.Reachability

open scoped BigOperators ENNReal

/-!
# Intrinsic occurring patterns and exact compression

ISIT Section IV opening (p.4), with the extended version 16 Section IV opening
(p.5), groups active singular columns by their actual nonempty supports.
The semantic channel below is a pushforward of active restriction; equal-pattern
values are summed even when unequal. No input prior or nonempty-input assumption
is needed for that semantic layer. The operation layer retains actual C10 PPM
paths and their PPS reverses, with explicit finite presentations and constructive
reachability transport. The Real bridge derives positive bounded aggregates
and reconstructs channels from intrinsic pattern data with weighted row sums.
Injective output relabeling and supplied active presentations preserve the full
extracted data. The actual inverse recovers all ambient coordinates, and
perfect representability passes through active presentation and witnessed
compression to the reconstructed data channel. Output enumeration is internal
to finite sums, not pattern identity.
-/

namespace PerfectFunctionalRepresentations
noncomputable section
attribute [local instance] Classical.propDecidable

universe u v
variable {α : Type u} {β : Type v} [Fintype α] [Finite β]

private abbrev patternActiveFintype (κ : α → PMF β) : Fintype (activeOutputs κ) :=
  Fintype.ofFinite _

attribute [local instance] patternActiveFintype

/-- The finite family of actual nonempty input-support patterns. -/
def occurringPatterns (κ : α → PMF β) : Finset {s : Finset α // s.Nonempty} :=
  (Set.finite_range (columnPattern κ)).toFinset

/-- An occurring pattern is the pattern itself, with its membership proof. -/
abbrev OccurringPattern (κ : α → PMF β) := ↥(occurringPatterns κ)

theorem mem_occurringPatterns (κ : α → PMF β) (p : {s : Finset α // s.Nonempty}) :
    p ∈ occurringPatterns κ ↔ ∃ y : activeOutputs κ, columnPattern κ y = p := by
  simp only [occurringPatterns, Set.Finite.mem_toFinset, Set.mem_range]

/-- Send an admitted column to its intrinsic occurring pattern. -/
def toOccurringPattern (κ : α → PMF β) (y : activeOutputs κ) : OccurringPattern κ :=
  ⟨columnPattern κ y, (mem_occurringPatterns κ _).mpr ⟨y, rfl⟩⟩

theorem toOccurringPattern_surjective (κ : α → PMF β) :
    Function.Surjective (toOccurringPattern κ) := by
  intro p
  obtain ⟨y, hy⟩ := (mem_occurringPatterns κ p.val).mp p.property
  exact ⟨y, Subtype.ext hy⟩

@[simp]
theorem toOccurringPattern_val (κ : α → PMF β) (y : activeOutputs κ) :
    (toOccurringPattern κ y).val = columnPattern κ y := rfl

/-- All admitted original columns with the given occurring pattern. -/
def patternFiber (κ : α → PMF β) (p : OccurringPattern κ) :
    Finset (activeOutputs κ) :=
  Finset.univ.filter (fun y => columnPattern κ y = p.val)

/-- The finite subtype of original labels in one pattern fiber. -/
abbrev PatternFiber (κ : α → PMF β) (p : OccurringPattern κ) := ↥(patternFiber κ p)

@[simp]
theorem mem_patternFiber (κ : α → PMF β) (p : OccurringPattern κ)
    (y : activeOutputs κ) : y ∈ patternFiber κ p ↔ columnPattern κ y = p.val := by
  simp [patternFiber]

theorem patternFiber_nonempty (κ : α → PMF β) (p : OccurringPattern κ) :
    (patternFiber κ p).Nonempty := by
  obtain ⟨y, hy⟩ := (mem_occurringPatterns κ p.val).mp p.property
  exact ⟨y, (mem_patternFiber κ p y).mpr hy⟩

theorem patternFiber_disjoint (κ : α → PMF β) {p q : OccurringPattern κ}
    (h : p ≠ q) : Disjoint (patternFiber κ p) (patternFiber κ q) := by
  apply Finset.disjoint_left.mpr
  intro y hp hq
  exact h (Subtype.ext (((mem_patternFiber κ p y).mp hp).symm.trans
    ((mem_patternFiber κ q y).mp hq)))

/-- Each original admitted column lies in exactly one fiber. -/
theorem existsUnique_patternFiber (κ : α → PMF β) (y : activeOutputs κ) :
    ∃! p : OccurringPattern κ, y ∈ patternFiber κ p := by
  refine ⟨toOccurringPattern κ y, (mem_patternFiber _ _ _).mpr rfl, ?_⟩
  intro p hp
  exact Subtype.ext ((mem_patternFiber κ p y).mp hp).symm

/-- Sum every original value in this equal-pattern fiber. -/
def patternAggregate (κ : α → PMF β) (hκ : IsSingularChannel κ)
    (p : OccurringPattern κ) : ENNReal :=
  ∑ y : activeOutputs κ, if columnPattern κ y = p.val then columnValue κ hκ y else 0

theorem patternAggregate_eq_sum_fiber (κ : α → PMF β) (hκ : IsSingularChannel κ)
    (p : OccurringPattern κ) :
    patternAggregate κ hκ p = ∑ y ∈ patternFiber κ p, columnValue κ hκ y := by
  simp only [patternAggregate, patternFiber, Finset.sum_filter]

theorem patternAggregate_eq_sum_subtype (κ : α → PMF β) (hκ : IsSingularChannel κ)
    (p : OccurringPattern κ) :
    patternAggregate κ hκ p = ∑ y : PatternFiber κ p, columnValue κ hκ y.val := by
  rw [patternAggregate_eq_sum_fiber]
  exact (Finset.sum_coe_sort _ _).symm

/-- Compress semantically by pushing each active-restricted row to its pattern. -/
def patternCompressedChannel (κ : α → PMF β) : α → PMF (OccurringPattern κ) :=
  fun x => (restrictActiveOutputs κ x).map (toOccurringPattern κ)

theorem patternCompressedChannel_apply (κ : α → PMF β) (x : α) (p : OccurringPattern κ) :
    patternCompressedChannel κ x p =
      ∑ y : activeOutputs κ, if columnPattern κ y = p.val then κ x y.val else 0 := by
  rw [patternCompressedChannel, PMF.map_apply, tsum_fintype]
  apply Finset.sum_congr rfl
  intro y _
  by_cases hy : columnPattern κ y = p.val
  · have he : toOccurringPattern κ y = p := Subtype.ext hy
    simp [he, restrictActiveOutputs_apply, hy]
  · have he : p ≠ toOccurringPattern κ y := by
      intro h
      exact hy (congrArg Subtype.val h.symm)
    simp only [if_neg he, if_neg hy]

theorem patternCompressedChannel_apply_fiber (κ : α → PMF β) (x : α)
    (p : OccurringPattern κ) :
    patternCompressedChannel κ x p = ∑ y ∈ patternFiber κ p, κ x y.val := by
  rw [patternCompressedChannel_apply]
  simp only [patternFiber, Finset.sum_filter]

theorem patternAggregate_pos (κ : α → PMF β) (hκ : IsSingularChannel κ)
    (p : OccurringPattern κ) : 0 < patternAggregate κ hκ p := by
  obtain ⟨y, hy⟩ := (mem_occurringPatterns κ p.val).mp p.property
  have hle := Finset.single_le_sum
    (s := Finset.univ)
    (f := fun y : activeOutputs κ =>
      if columnPattern κ y = p.val then columnValue κ hκ y else 0)
    (fun _ _ => bot_le) (Finset.mem_univ y)
  exact lt_of_lt_of_le (columnValue_pos κ hκ y)
    (by simpa only [patternAggregate, if_pos hy] using hle)

theorem patternCompressedChannel_eq_ite (κ : α → PMF β) (hκ : IsSingularChannel κ)
    (x : α) (p : OccurringPattern κ) :
    patternCompressedChannel κ x p = if x ∈ p.val.val then patternAggregate κ hκ p else 0 := by
  rw [patternCompressedChannel_apply]
  by_cases hx : x ∈ p.val.val
  · rw [if_pos hx]
    apply Finset.sum_congr rfl
    intro y _
    by_cases hy : columnPattern κ y = p.val
    · rw [if_pos hy, if_pos hy, column_eq_ite κ hκ y x, hy, if_pos hx]
    · rw [if_neg hy, if_neg hy]
  · rw [if_neg hx]
    apply Finset.sum_eq_zero
    intro y _
    by_cases hy : columnPattern κ y = p.val
    · rw [if_pos hy, column_eq_ite κ hκ y x, hy, if_neg hx]
    · rw [if_neg hy]

theorem patternAggregate_row_sum (κ : α → PMF β) (hκ : IsSingularChannel κ) (x : α) :
    ∑ p : OccurringPattern κ, (if x ∈ p.val.val then patternAggregate κ hκ p else 0) = 1 := by
  calc
    _ = ∑ p : OccurringPattern κ, patternCompressedChannel κ x p :=
      Finset.sum_congr rfl (fun p _ => (patternCompressedChannel_eq_ite κ hκ x p).symm)
    _ = 1 := massMatrix_row_sum (patternCompressedChannel κ) x

theorem patternCompressedChannel_eq_channelOfColumnData (κ : α → PMF β) (hκ : IsSingularChannel κ) :
    patternCompressedChannel κ = channelOfColumnData (fun p : OccurringPattern κ => p.val)
      (patternAggregate κ hκ) (patternAggregate_row_sum κ hκ) := by
  funext x
  apply PMF.ext
  intro p
  exact patternCompressedChannel_eq_ite κ hκ x p

theorem patternAggregate_le_one (κ : α → PMF β) (hκ : IsSingularChannel κ)
    (p : OccurringPattern κ) : patternAggregate κ hκ p ≤ 1 :=
  columnData_value_le_one (fun p : OccurringPattern κ => p.val)
    (patternAggregate κ hκ) (patternAggregate_row_sum κ hκ) p

theorem patternAggregate_ne_top (κ : α → PMF β) (hκ : IsSingularChannel κ)
    (p : OccurringPattern κ) : patternAggregate κ hκ p ≠ ∞ :=
  columnData_value_ne_top (fun p : OccurringPattern κ => p.val)
    (patternAggregate κ hκ) (patternAggregate_row_sum κ hκ) p

theorem isSingularChannel_patternCompressedChannel (κ : α → PMF β)
    (hκ : IsSingularChannel κ) :
    IsSingularChannel (patternCompressedChannel κ) := by
  rw [patternCompressedChannel_eq_channelOfColumnData κ hκ]
  exact isSingularChannel_channelOfColumnData _ _ _

theorem patternCompressedChannel_active (κ : α → PMF β) (hκ : IsSingularChannel κ)
    (p : OccurringPattern κ) : p ∈ activeOutputs (patternCompressedChannel κ) := by
  obtain ⟨x, hx⟩ := p.val.property
  refine ⟨x, ?_⟩
  rw [PMF.mem_support_iff, patternCompressedChannel_eq_ite κ hκ x p, if_pos hx]
  exact ne_of_gt (patternAggregate_pos κ hκ p)

private theorem patternCompressedChannel_data (κ : α → PMF β) (hκ : IsSingularChannel κ)
    (p : OccurringPattern κ) :
    columnPattern (patternCompressedChannel κ) ⟨p, patternCompressedChannel_active κ hκ p⟩ = p.val ∧
      columnValue (patternCompressedChannel κ) (isSingularChannel_patternCompressedChannel κ hκ)
        ⟨p, patternCompressedChannel_active κ hκ p⟩ = patternAggregate κ hκ p := by
  have h := columnData_unique (patternCompressedChannel κ)
    (isSingularChannel_patternCompressedChannel κ hκ)
    ⟨p, patternCompressedChannel_active κ hκ p⟩ p.val.val p.val.property
    (patternAggregate κ hκ p) (patternAggregate_pos κ hκ p)
    (fun x => patternCompressedChannel_eq_ite κ hκ x p)
  exact ⟨Subtype.ext h.1.symm, h.2.symm⟩

theorem columnPattern_patternCompressedChannel (κ : α → PMF β)
    (hκ : IsSingularChannel κ) (p : OccurringPattern κ) :
    columnPattern (patternCompressedChannel κ) ⟨p, patternCompressedChannel_active κ hκ p⟩ =
      p.val := (patternCompressedChannel_data κ hκ p).1

theorem columnValue_patternCompressedChannel (κ : α → PMF β)
    (hκ : IsSingularChannel κ) (p : OccurringPattern κ) :
    columnValue (patternCompressedChannel κ) (isSingularChannel_patternCompressedChannel κ hκ)
      ⟨p, patternCompressedChannel_active κ hκ p⟩ = patternAggregate κ hκ p :=
  (patternCompressedChannel_data κ hκ p).2

/-- Distinct output indices of the compressed channel have distinct actual patterns. -/
theorem patternCompressedChannel_patterns_injective (κ : α → PMF β)
    (hκ : IsSingularChannel κ) :
    Function.Injective (fun p : OccurringPattern κ =>
      columnPattern (patternCompressedChannel κ) ⟨p, patternCompressedChannel_active κ hκ p⟩) := by
  intro p q hpq
  exact Subtype.ext ((columnPattern_patternCompressedChannel κ hκ p).symm.trans
    (hpq.trans (columnPattern_patternCompressedChannel κ hκ q)))


/-! ## Independence from a bijective output relabeling -/

universe w
variable {γ : Type w} [Finite γ]

omit [Finite β] [Finite γ] in
private theorem columnPattern_map_equiv (κ : α → PMF β) (e : β ≃ γ)
    (y : activeOutputs κ) :
    columnPattern (fun x => (κ x).map e) (activeOutputsMapEquiv κ e e.injective y) =
      columnPattern κ y := by
  apply Subtype.ext
  have h := columnPattern_transport κ (fun x => (κ x).map e) y
    (activeOutputsMapEquiv κ e e.injective y) (Equiv.refl α)
    (fun x => PMF.map_apply_equiv (κ x) e y.val)
  simpa using h

omit [Fintype α] [Finite β] [Finite γ] in
private theorem columnValue_map_equiv (κ : α → PMF β) (e : β ≃ γ)
    (hκ : IsSingularChannel κ) (hη : IsSingularChannel (fun x => (κ x).map e))
    (y : activeOutputs κ) :
    columnValue (fun x => (κ x).map e) hη (activeOutputsMapEquiv κ e e.injective y) =
      columnValue κ hκ y :=
  columnValue_transport κ (fun x => (κ x).map e) hκ hη y
    (activeOutputsMapEquiv κ e e.injective y) (Equiv.refl α)
    (fun x => PMF.map_apply_equiv (κ x) e y.val)

theorem occurringPatterns_map_equiv (κ : α → PMF β) (e : β ≃ γ) :
    occurringPatterns (fun x => (κ x).map e) = occurringPatterns κ := by
  ext p
  rw [mem_occurringPatterns, mem_occurringPatterns]
  constructor
  · rintro ⟨z, hz⟩
    obtain ⟨y, rfl⟩ := (activeOutputsMapEquiv κ e e.injective).surjective z
    exact ⟨y, (columnPattern_map_equiv κ e y).symm.trans hz⟩
  · rintro ⟨y, hy⟩
    exact ⟨activeOutputsMapEquiv κ e e.injective y, (columnPattern_map_equiv κ e y).trans hy⟩

theorem patternAggregate_map_equiv (κ : α → PMF β) (e : β ≃ γ)
    (hκ : IsSingularChannel κ) (hη : IsSingularChannel (fun x => (κ x).map e))
    (p : OccurringPattern κ) (q : OccurringPattern (fun x => (κ x).map e))
    (h : q.val = p.val) :
    patternAggregate (fun x => (κ x).map e) hη q = patternAggregate κ hκ p := by
  change (∑ z : activeOutputs (fun x => (κ x).map e),
    if columnPattern (fun x => (κ x).map e) z = q.val
      then columnValue (fun x => (κ x).map e) hη z else 0) =
    ∑ y : activeOutputs κ, if columnPattern κ y = p.val then columnValue κ hκ y else 0
  rw [← (activeOutputsMapEquiv κ e e.injective).sum_comp
    (fun z => if columnPattern (fun x => (κ x).map e) z = q.val
      then columnValue (fun x => (κ x).map e) hη z else 0)]
  apply Finset.sum_congr rfl
  intro y _
  rw [columnPattern_map_equiv κ e y, columnValue_map_equiv κ e hκ hη y, h]

end
end PerfectFunctionalRepresentations

namespace PerfectFunctionalRepresentations.MatrixOperations
noncomputable section
attribute [local instance] Classical.propDecidable

universe u
variable {α : Type u} [Fintype α] [Nonempty α]

private abbrev operationActiveFintype (S : ActiveFiniteChannel α) :
    Fintype (activeOutputs S.channel) := Fintype.ofFinite _
attribute [local instance] operationActiveFintype

private def patternGroup (S : ActiveFiniteChannel α) :
    Fin S.outputCard → OccurringPattern S.channel :=
  fun j => toOccurringPattern S.channel (S.activeEquiv j)

private theorem patternGroup_surjective (S : ActiveFiniteChannel α) :
    Function.Surjective (patternGroup S) :=
  (toOccurringPattern_surjective S.channel).comp S.activeEquiv.surjective

private theorem patternGroup_support (S : ActiveFiniteChannel α)
    (i j : Fin S.outputCard) (h : patternGroup S i = patternGroup S j) (x : α) :
    S.channel x i ≠ 0 ↔ S.channel x j ≠ 0 := by
  have he : columnPattern S.channel (S.activeEquiv i) =
      columnPattern S.channel (S.activeEquiv j) := congrArg Subtype.val h
  change S.channel x (S.activeEquiv i).val ≠ 0 ↔
    S.channel x (S.activeEquiv j).val ≠ 0
  rw [← mem_columnPattern, ← mem_columnPattern, he]

private theorem patternGroup_eq_iff (S : ActiveFiniteChannel α)
    (j : Fin S.outputCard) (p : OccurringPattern S.channel) :
    patternGroup S j = p ↔ columnPattern S.channel (S.activeEquiv j) = p.val :=
  Subtype.ext_iff

/-- The actual C10 PPM certificate, with its mass field identified semantically. -/
def patternCompression (S : ActiveFiniteChannel α) (hS : IsSingularChannel S.channel) :
    LabelledOperationResult .ppm S (OccurringPattern S.channel)
      (fun x p => patternCompressedChannel S.channel x p) := by
  let d := multiPpmFibers S hS (patternGroup S)
    (patternGroup_surjective S) (patternGroup_support S)
  refine ⟨d.endpoint, d.path, d.homogeneous, d.labels, ?_⟩
  intro x p
  rw [d.coordinates, patternCompressedChannel_apply]
  rw [← S.activeEquiv.sum_comp (fun y : activeOutputs S.channel =>
    if columnPattern S.channel y = p.val then S.channel x y.val else 0)]
  apply Finset.sum_congr rfl
  intro j _
  by_cases hj : patternGroup S j = p
  · have hv := (patternGroup_eq_iff S j p).mp hj
    simp only [if_pos hj, if_pos hv]
    rfl
  · have hv := mt (patternGroup_eq_iff S j p).mpr hj
    simp only [if_neg hj, if_neg hv]

theorem patternCompression_columnPattern (S : ActiveFiniteChannel α)
    (hS : IsSingularChannel S.channel) (p : OccurringPattern S.channel) :
    columnPattern (patternCompression S hS).endpoint.channel
      ((patternCompression S hS).endpoint.activeEquiv ((patternCompression S hS).labels p)) =
        p.val := by
  obtain ⟨j, rfl⟩ := patternGroup_surjective S p
  exact multiPpmFibers_columnPattern S hS (patternGroup S)
    (patternGroup_surjective S) (patternGroup_support S) j

theorem patternCompression_columnValue (S : ActiveFiniteChannel α)
    (hS : IsSingularChannel S.channel) (p : OccurringPattern S.channel) :
    columnValue (patternCompression S hS).endpoint.channel
      ((patternCompression S hS).isSingular hS)
      ((patternCompression S hS).endpoint.activeEquiv ((patternCompression S hS).labels p)) =
        patternAggregate S.channel hS p := by
  trans ∑ j, @ite ENNReal (patternGroup S j = p) (Classical.propDecidable _)
    (columnValue S.channel hS (S.activeEquiv j)) 0
  · exact multiPpmFibers_columnValue S hS (patternGroup S)
      (patternGroup_surjective S) (patternGroup_support S) p
  unfold patternAggregate
  rw [← S.activeEquiv.sum_comp (fun y : activeOutputs S.channel =>
    if columnPattern S.channel y = p.val then columnValue S.channel hS y else 0)]
  apply Finset.sum_congr rfl
  intro j _
  by_cases hj : patternGroup S j = p
  · have hv := (patternGroup_eq_iff S j p).mp hj
    simp only [if_pos hj, if_pos hv]
  · have hv := mt (patternGroup_eq_iff S j p).mpr hj
    simp only [if_neg hj, if_neg hv]

theorem patternCompression_length (S : ActiveFiniteChannel α)
    (hS : IsSingularChannel S.channel) :
    (patternCompression S hS).path.length =
      S.outputCard - (occurringPatterns S.channel).card := by
  change (multiPpmFibers S hS (patternGroup S) (patternGroup_surjective S)
    (patternGroup_support S)).path.length = _
  rw [multiPpmFibers_length, Fintype.card_coe]

theorem patternCompression_length_of_injective (S : ActiveFiniteChannel α)
    (hS : IsSingularChannel S.channel)
    (hi : Function.Injective (columnPattern S.channel)) :
    (patternCompression S hS).path.length = 0 := by
  have hg : Function.Injective (patternGroup S) := by
    intro i j h
    apply S.activeEquiv.injective
    exact hi (congrArg Subtype.val h)
  have hc := Fintype.card_of_bijective ⟨hg, patternGroup_surjective S⟩
  simp only [Fintype.card_fin, Fintype.card_coe] at hc
  rw [patternCompression_length]
  omega

theorem patternCompression_tags_of_injective (S : ActiveFiniteChannel α)
    (hS : IsSingularChannel S.channel)
    (hi : Function.Injective (columnPattern S.channel)) :
    (patternCompression S hS).path.tags = [] := by
  apply List.eq_nil_of_length_eq_zero
  rw [OperationPath.tags_length, patternCompression_length_of_injective S hS hi]


/-- A supplied finite enumeration of the independently defined semantic channel. -/
def patternCompressedState (S : ActiveFiniteChannel α) (hS : IsSingularChannel S.channel)
    {m : Nat} (e : OccurringPattern S.channel ≃ Fin m) : ActiveFiniteChannel α :=
  ActiveFiniteChannel.ofActive (patternCompressedChannel S.channel) e
    (fun p => by
      obtain ⟨x, hx⟩ := patternCompressedChannel_active S.channel hS p
      exact ⟨x, by simpa only [PMF.mem_support_iff] using hx⟩)

theorem patternCompressedState_apply (S : ActiveFiniteChannel α)
    (hS : IsSingularChannel S.channel) {m : Nat}
    (e : OccurringPattern S.channel ≃ Fin m) (x : α) (p : OccurringPattern S.channel) :
    (patternCompressedState S hS e).channel x (e p) = patternCompressedChannel S.channel x p :=
  ActiveFiniteChannel.ofActive_apply _ _ _ _ _

/-- The directed comparison between any two supplied pattern enumerations. -/
def patternCompressedState_compare (S : ActiveFiniteChannel α)
    (hS : IsSingularChannel S.channel) {m n : Nat}
    (e : OccurringPattern S.channel ≃ Fin m) (f : OccurringPattern S.channel ≃ Fin n) :
    OutputEquiv (patternCompressedState S hS e) (patternCompressedState S hS f) :=
  ⟨e.symm.trans f, fun x => ActiveFiniteChannel.ofActive_compare _ _ _ _ x⟩

variable (S : ActiveFiniteChannel α) (hS : IsSingularChannel S.channel)
  {m : Nat} (e : OccurringPattern S.channel ≃ Fin m)

/-- Actual PPM compression, compared to the chosen semantic presentation. -/
def patternCompressionCascade : Cascade S (patternCompressedState S hS e) :=
  (patternCompression S hS).cascade e (patternCompressedState_apply S hS e)

theorem patternCompressionCascade_ppm :
    (patternCompressionCascade S hS e).path.Homogeneous .ppm :=
  (patternCompression S hS).homogeneous

/-- The retained PPS reconstruction is exactly the witnessed reversal of compression. -/
def patternCompressionInverse : Cascade (patternCompressedState S hS e) S :=
  (patternCompressionCascade S hS e).reverse

theorem patternCompressionInverse_pps :
    (patternCompressionInverse S hS e).path.Homogeneous .pps := by
  apply ((patternCompressionCascade S hS e).reverse_allowed (· = .pps)).mpr
  intro k hk
  rw [patternCompressionCascade_ppm S hS e k hk]
  rfl

/-- Every original coordinate is recovered through the retained directed comparison. -/
theorem patternCompressionInverse_apply (x : α) (j : Fin S.outputCard) :
    (patternCompressionInverse S hS e).endpoint.channel x
      ((patternCompressionInverse S hS e).outputEquiv.equiv.symm j) = S.channel x j :=
  (patternCompressionInverse S hS e).outputEquiv.apply_symm x j

theorem isPerfectlyRepresentable_iff_patternCompressedState :
    IsPerfectlyRepresentableChannel S.channel ↔
    IsPerfectlyRepresentableChannel (patternCompressedState S hS e).channel := by
  constructor
  · exact (patternCompressionCascade S hS e).isPerfectlyRepresentable
      (fun k hk => Or.inr (Or.inr (patternCompressionCascade_ppm S hS e k hk)))
  · exact (patternCompressionInverse S hS e).isPerfectlyRepresentable
      (fun k hk => Or.inl (patternCompressionInverse_pps S hS e k hk))

theorem fromAllOnes_iff_patternCompressedState :
    FromAllOnes S ↔ FromAllOnes (patternCompressedState S hS e) := by
  constructor
  · rintro ⟨c, hc⟩
    refine ⟨c.comp (patternCompressionCascade S hS e), (Cascade.allowed_comp _ _ _).mpr ⟨hc, ?_⟩⟩
    exact fun k hk => Or.inr (Or.inr (patternCompressionCascade_ppm S hS e k hk))
  · rintro ⟨c, hc⟩
    refine ⟨c.comp (patternCompressionInverse S hS e),
      (Cascade.allowed_comp _ _ _).mpr ⟨hc, ?_⟩⟩
    exact fun k hk => Or.inl (patternCompressionInverse_pps S hS e k hk)

theorem toAllOnes_iff_patternCompressedState :
    ToAllOnes S ↔ ToAllOnes (patternCompressedState S hS e) := by
  constructor
  · rintro ⟨c, hc⟩
    refine ⟨(patternCompressionInverse S hS e).comp c,
      (Cascade.allowed_comp _ _ _).mpr ⟨?_, hc⟩⟩
    exact fun k hk => Or.inr (Or.inl (patternCompressionInverse_pps S hS e k hk))
  · rintro ⟨c, hc⟩
    refine ⟨(patternCompressionCascade S hS e).comp c, (Cascade.allowed_comp _ _ _).mpr ⟨?_, hc⟩⟩
    exact fun k hk => Or.inl (patternCompressionCascade_ppm S hS e k hk)
end
end PerfectFunctionalRepresentations.MatrixOperations


namespace PerfectFunctionalRepresentations
noncomputable section
attribute [local instance] Classical.propDecidable
attribute [local instance] patternActiveFintype
universe u v
variable {α : Type u} {β : Type v} [Fintype α] [Finite β]

/-! ## Exact conversion of compressed aggregates to Real -/

theorem patternAggregate_toReal_pos (κ : α → PMF β) (hκ : IsSingularChannel κ)
    (p : OccurringPattern κ) : 0 < (patternAggregate κ hκ p).toReal :=
  ENNReal.toReal_pos (ne_of_gt (patternAggregate_pos κ hκ p))
    (patternAggregate_ne_top κ hκ p)

theorem patternAggregate_toReal_le_one (κ : α → PMF β) (hκ : IsSingularChannel κ)
    (p : OccurringPattern κ) : (patternAggregate κ hκ p).toReal ≤ 1 := by
  simpa only [ENNReal.toReal_one] using
    ENNReal.toReal_mono ENNReal.one_ne_top (patternAggregate_le_one κ hκ p)

@[simp]
theorem ofReal_patternAggregate_toReal (κ : α → PMF β) (hκ : IsSingularChannel κ)
    (p : OccurringPattern κ) :
    ENNReal.ofReal (patternAggregate κ hκ p).toReal = patternAggregate κ hκ p :=
  ENNReal.ofReal_toReal (patternAggregate_ne_top κ hκ p)

theorem patternAggregate_toReal_eq_sum (κ : α → PMF β) (hκ : IsSingularChannel κ)
    (p : OccurringPattern κ) :
    (patternAggregate κ hκ p).toReal =
      ∑ y : activeOutputs κ,
        if columnPattern κ y = p.val then (columnValue κ hκ y).toReal else 0 := by
  unfold patternAggregate
  rw [ENNReal.toReal_sum]
  · apply Finset.sum_congr rfl
    intro y _
    split_ifs <;> simp
  · intro y _
    split_ifs
    · exact columnValue_ne_top κ hκ y
    · simp

theorem patternAggregate_toReal_eq_sum_fiber (κ : α → PMF β) (hκ : IsSingularChannel κ)
    (p : OccurringPattern κ) :
    (patternAggregate κ hκ p).toReal = ∑ y ∈ patternFiber κ p, (columnValue κ hκ y).toReal := by
  rw [patternAggregate_eq_sum_fiber, ENNReal.toReal_sum]
  exact fun y _ => columnValue_ne_top κ hκ y

theorem patternAggregate_toReal_eq_sum_subtype (κ : α → PMF β) (hκ : IsSingularChannel κ)
    (p : OccurringPattern κ) :
    (patternAggregate κ hκ p).toReal =
      ∑ y : PatternFiber κ p, (columnValue κ hκ y.val).toReal := by
  rw [patternAggregate_toReal_eq_sum_fiber]
  exact (Finset.sum_coe_sort _ _).symm

theorem patternAggregate_toReal_row_sum (κ : α → PMF β) (hκ : IsSingularChannel κ) (x : α) :
    ∑ p : OccurringPattern κ,
      (if x ∈ p.val.val then (patternAggregate κ hκ p).toReal else 0) = 1 :=
  columnData_toReal_row_sum (fun p : OccurringPattern κ => p.val)
    (patternAggregate κ hκ) (patternAggregate_row_sum κ hκ) x

theorem patternCompressedChannel_toReal_eq_ite (κ : α → PMF β) (hκ : IsSingularChannel κ)
    (x : α) (p : OccurringPattern κ) :
    (patternCompressedChannel κ x p).toReal =
      if x ∈ p.val.val then (patternAggregate κ hκ p).toReal else 0 := by
  rw [patternCompressedChannel_eq_ite κ hκ]
  split_ifs <;> rfl

theorem channelOfRealPatternAggregates (κ : α → PMF β) (hκ : IsSingularChannel κ) :
    channelOfRealMatrix
      (Matrix.of fun x (p : OccurringPattern κ) =>
        if x ∈ p.val.val then (patternAggregate κ hκ p).toReal else 0)
      (fun x p => by
        change 0 ≤ if x ∈ p.val.val then (patternAggregate κ hκ p).toReal else 0
        split_ifs <;> positivity)
      (patternAggregate_toReal_row_sum κ hκ) = patternCompressedChannel κ := by
  apply massMatrix_injective
  funext x p
  change ENNReal.ofReal (if x ∈ p.val.val then (patternAggregate κ hκ p).toReal else 0) = _
  rw [← patternCompressedChannel_toReal_eq_ite κ hκ x p]
  exact ENNReal.ofReal_toReal ((patternCompressedChannel κ x).apply_ne_top p)


/-! ## Valid Real pattern data and its reconstructed channel -/

/-- Positive values on distinct nonempty patterns, normalized separately at each input. -/
structure CompressedPatternData (α : Type u) [Fintype α] [Nonempty α] where
  patterns : Finset {s : Finset α // s.Nonempty}
  value : ↥patterns → ℝ
  value_pos : ∀ p, 0 < value p
  row_sum : ∀ x, ∑ p : ↥patterns, (if x ∈ p.val.val then value p else 0) = 1

variable {α : Type u} [Fintype α] [Nonempty α]

/-- Extract the intrinsic patterns and Real aggregate values of a singular channel. -/
def compressedPatternData {β : Type v} [Finite β]
    (κ : α → PMF β) (hκ : IsSingularChannel κ) : CompressedPatternData α where
  patterns := occurringPatterns κ
  value p := (patternAggregate κ hκ p).toReal
  value_pos := patternAggregate_toReal_pos κ hκ
  row_sum := patternAggregate_toReal_row_sum κ hκ

namespace CompressedPatternData

private theorem exactRows (D : CompressedPatternData α) (x : α) :
    ∑ p : ↥D.patterns, (if x ∈ p.val.val then ENNReal.ofReal (D.value p) else 0) = 1 := by
  have hn (p : ↥D.patterns) : 0 ≤ if x ∈ p.val.val then D.value p else 0 := by
    split_ifs
    · exact le_of_lt (D.value_pos p)
    · exact le_rfl
  have h := congrArg ENNReal.ofReal (D.row_sum x)
  rw [ENNReal.ofReal_sum_of_nonneg (fun p _ => hn p)] at h
  simpa only [apply_ite ENNReal.ofReal, ENNReal.ofReal_zero, ENNReal.ofReal_one] using h

private theorem exactPositive (D : CompressedPatternData α) (p : ↥D.patterns) :
    0 < ENNReal.ofReal (D.value p) := ENNReal.ofReal_pos.mpr (D.value_pos p)

/-- Reconstruct exact masses from valid Real data using the C06 column constructor. -/
def channel (D : CompressedPatternData α) : α → PMF ↥D.patterns :=
  channelOfColumnData (fun p : ↥D.patterns => p.val)
    (fun p => ENNReal.ofReal (D.value p)) D.exactRows

theorem channel_apply (D : CompressedPatternData α) (x : α) (p : ↥D.patterns) :
    D.channel x p = if x ∈ p.val.val then ENNReal.ofReal (D.value p) else 0 := rfl

theorem channel_active (D : CompressedPatternData α) (p : ↥D.patterns) :
    p ∈ activeOutputs D.channel :=
  channelOfColumnData_active _ _ D.exactRows D.exactPositive p

theorem channel_singular (D : CompressedPatternData α) : IsSingularChannel D.channel :=
  isSingularChannel_channelOfColumnData _ _ D.exactRows

private abbrev admitted (D : CompressedPatternData α) (p : ↥D.patterns) :
    activeOutputs D.channel := ⟨p, D.channel_active p⟩

theorem channel_columnPattern (D : CompressedPatternData α) (p : ↥D.patterns) :
    columnPattern D.channel ⟨p, D.channel_active p⟩ = p.val :=
  columnPattern_channelOfColumnData _ _ D.exactRows D.exactPositive p

theorem channel_columnValue (D : CompressedPatternData α) (p : ↥D.patterns) :
    columnValue D.channel D.channel_singular ⟨p, D.channel_active p⟩ =
      ENNReal.ofReal (D.value p) :=
  columnValue_channelOfColumnData _ _ D.exactRows D.exactPositive p

private theorem arbitraryPattern (D : CompressedPatternData α) (y : activeOutputs D.channel) :
    columnPattern D.channel y = y.val.val := D.channel_columnPattern y.val

theorem occurringPatterns_channel (D : CompressedPatternData α) :
    occurringPatterns D.channel = D.patterns := by
  ext p
  rw [mem_occurringPatterns]
  constructor
  · rintro ⟨y, rfl⟩
    rw [D.arbitraryPattern y]
    exact y.val.property
  · intro hp
    exact ⟨D.admitted ⟨p, hp⟩, D.channel_columnPattern ⟨p, hp⟩⟩

private abbrev dataActiveFintype (D : CompressedPatternData α) :
    Fintype (activeOutputs D.channel) := Fintype.ofFinite _
attribute [local instance] dataActiveFintype

private theorem extractedFiber (D : CompressedPatternData α) (p : ↥D.patterns)
    (q : OccurringPattern D.channel) (h : q.val = p.val) :
    patternFiber D.channel q = {D.admitted p} := by
  ext y
  rw [mem_patternFiber, Finset.mem_singleton, D.arbitraryPattern y, h]
  constructor
  · intro he
    apply Subtype.ext
    exact Subtype.ext he
  · intro he
    exact congrArg (fun z : activeOutputs D.channel => z.val.val) he

/-- Each supplied pattern has exactly its own admitted label in its extracted fiber. -/
theorem patternFiber_channel (D : CompressedPatternData α) (p : ↥D.patterns) :
    patternFiber D.channel
      ⟨p.val, by rw [D.occurringPatterns_channel]; exact p.property⟩ =
        {⟨p, D.channel_active p⟩} :=
  D.extractedFiber p _ rfl

private theorem extractedAggregate (D : CompressedPatternData α) (p : ↥D.patterns)
    (q : OccurringPattern D.channel) (h : q.val = p.val) :
    patternAggregate D.channel D.channel_singular q = ENNReal.ofReal (D.value p) := by
  rw [patternAggregate_eq_sum_fiber, D.extractedFiber p q h, Finset.sum_singleton]
  exact D.channel_columnValue p

/-- Explicitly transports a supplied pattern's membership to the extracted family. -/
theorem extracted_value (D : CompressedPatternData α) (p : ↥D.patterns) :
    (compressedPatternData D.channel D.channel_singular).value
      ⟨p.val, by
        change p.val ∈ occurringPatterns D.channel
        rw [D.occurringPatterns_channel]
        exact p.property⟩ = D.value p := by
  let q : OccurringPattern D.channel := ⟨p.val, by
    rw [D.occurringPatterns_channel]
    exact p.property⟩
  exact (congrArg ENNReal.toReal (D.extractedAggregate p q rfl)).trans
    (ENNReal.toReal_ofReal (le_of_lt (D.value_pos p)))

private theorem data_ext (D E : CompressedPatternData α)
    (hpatterns : D.patterns = E.patterns)
    (hvalues : ∀ p : ↥D.patterns,
      D.value p = E.value ⟨p.val, hpatterns ▸ p.property⟩) : D = E := by
  cases D with
  | mk s v hv hr =>
    cases E with
    | mk t w hw hs =>
      cases hpatterns
      have h : v = w := funext hvalues
      cases h
      rfl

/-- Full generic valid-data round trip, including the dependent value field. -/
theorem extraction_roundTrip (D : CompressedPatternData α) :
    compressedPatternData D.channel D.channel_singular = D := by
  apply data_ext _ _ D.occurringPatterns_channel
  intro q
  let p : ↥D.patterns := ⟨q.val, by
    have hq : q.val ∈ occurringPatterns D.channel := q.property
    rw [D.occurringPatterns_channel] at hq
    exact hq⟩
  exact (congrArg ENNReal.toReal (D.extractedAggregate p q rfl)).trans
    (ENNReal.toReal_ofReal (le_of_lt (D.value_pos p)))

end CompressedPatternData
end
end PerfectFunctionalRepresentations


namespace PerfectFunctionalRepresentations
noncomputable section
attribute [local instance] Classical.propDecidable
universe u v
variable {α : Type u} [Fintype α] [Nonempty α]

namespace CompressedPatternData

theorem value_le_one (D : CompressedPatternData α) (p : ↥D.patterns) : D.value p ≤ 1 := by
  have he := columnData_value_le_one (fun p : ↥D.patterns => p.val)
    (fun p => ENNReal.ofReal (D.value p)) D.exactRows p
  have hr := ENNReal.toReal_mono (by simp) he
  simpa only [ENNReal.toReal_ofReal (le_of_lt (D.value_pos p)), ENNReal.toReal_one] using hr

theorem patterns_nonempty (D : CompressedPatternData α) : D.patterns.Nonempty := by
  obtain ⟨p⟩ := columnData_nonempty_output (fun p : ↥D.patterns => p.val)
    (fun p => ENNReal.ofReal (D.value p)) D.exactRows
  exact ⟨p.val, p.property⟩

/-- Present the reconstructed semantic channel in any supplied finite enumeration. -/
def toActiveFiniteChannel (D : CompressedPatternData α) {m : Nat}
    (e : ↥D.patterns ≃ Fin m) : ActiveFiniteChannel α :=
  ActiveFiniteChannel.ofActive D.channel e (fun p => by
    obtain ⟨x, hx⟩ := D.channel_active p
    exact ⟨x, by simpa only [PMF.mem_support_iff] using hx⟩)

theorem toActiveFiniteChannel_apply (D : CompressedPatternData α) {m : Nat}
    (e : ↥D.patterns ≃ Fin m) (x : α) (p : ↥D.patterns) :
    (D.toActiveFiniteChannel e).channel x (e p) = D.channel x p :=
  ActiveFiniteChannel.ofActive_apply _ _ _ _ _

theorem toActiveFiniteChannel_recover (D : CompressedPatternData α) {m : Nat}
    (e : ↥D.patterns ≃ Fin m) (x : α) :
    ((D.toActiveFiniteChannel e).channel x).map e.symm = D.channel x :=
  ActiveFiniteChannel.ofActive_recover _ _ _ _

/-- The forward comparison sends the first enumeration through e.symm.trans f. -/
def toActiveFiniteChannel_compare (D : CompressedPatternData α) {m n : Nat}
    (e : ↥D.patterns ≃ Fin m) (f : ↥D.patterns ≃ Fin n) :
    MatrixOperations.OutputEquiv (D.toActiveFiniteChannel e) (D.toActiveFiniteChannel f) :=
  ⟨e.symm.trans f, fun x => ActiveFiniteChannel.ofActive_compare _ _ _ _ x⟩

theorem toActiveFiniteChannel_singular (D : CompressedPatternData α) {m : Nat}
    (e : ↥D.patterns ≃ Fin m) : IsSingularChannel (D.toActiveFiniteChannel e).channel :=
  (ActiveFiniteChannel.isSingularChannel_ofActive_iff D.channel e _).mpr D.channel_singular

theorem toActiveFiniteChannel_columnPattern (D : CompressedPatternData α) {m : Nat}
    (e : ↥D.patterns ≃ Fin m) (p : ↥D.patterns) :
    columnPattern (D.toActiveFiniteChannel e).channel
      ((D.toActiveFiniteChannel e).activeEquiv (e p)) = p.val := by
  apply Subtype.ext
  have h := columnPattern_transport D.channel (D.toActiveFiniteChannel e).channel
    ⟨p, D.channel_active p⟩ ((D.toActiveFiniteChannel e).activeEquiv (e p))
    (Equiv.refl α) (fun x => D.toActiveFiniteChannel_apply e x p)
  simpa [D.channel_columnPattern] using h

theorem toActiveFiniteChannel_columnValue (D : CompressedPatternData α) {m : Nat}
    (e : ↥D.patterns ≃ Fin m) (p : ↥D.patterns) :
    columnValue (D.toActiveFiniteChannel e).channel (D.toActiveFiniteChannel_singular e)
      ((D.toActiveFiniteChannel e).activeEquiv (e p)) = ENNReal.ofReal (D.value p) :=
  (columnValue_transport D.channel (D.toActiveFiniteChannel e).channel
    D.channel_singular (D.toActiveFiniteChannel_singular e) ⟨p, D.channel_active p⟩
    ((D.toActiveFiniteChannel e).activeEquiv (e p)) (Equiv.refl α)
    (fun x => D.toActiveFiniteChannel_apply e x p)).trans (D.channel_columnValue p)

end CompressedPatternData

/-- Extraction followed by reconstruction is the semantic compression of the source. -/
theorem compressedPatternData_channel {β : Type v} [Finite β]
    (κ : α → PMF β) (hκ : IsSingularChannel κ) :
    (compressedPatternData κ hκ).channel = patternCompressedChannel κ := by
  funext x
  apply PMF.ext
  intro p
  calc
    _ = if x ∈ p.val.val then ENNReal.ofReal ((patternAggregate κ hκ p).toReal) else 0 :=
      (compressedPatternData κ hκ).channel_apply x p
    _ = patternCompressedChannel κ x p :=
      (congrArg (fun r : ENNReal => if x ∈ p.val.val then r else 0)
        (ofReal_patternAggregate_toReal κ hκ p)).trans
          (patternCompressedChannel_eq_ite κ hκ x p).symm

end
end PerfectFunctionalRepresentations


/-! ## Injective ambient relabeling and supplied active presentations -/

namespace PerfectFunctionalRepresentations
noncomputable section
attribute [local instance] Classical.propDecidable
universe u v w
variable {α : Type u} {β : Type v} {γ : Type w}
variable [Fintype α] [Finite β] [Finite γ]

attribute [local instance] patternActiveFintype

omit [Finite β] [Finite γ] in
private theorem patternAlong (κ : α → PMF β) (η : α → PMF γ)
    (e : activeOutputs κ ≃ activeOutputs η)
    (hc : ∀ x y, η x (e y).val = κ x y.val) (y : activeOutputs κ) :
    columnPattern η (e y) = columnPattern κ y := by
  apply Subtype.ext
  have h := columnPattern_transport κ η y (e y) (Equiv.refl α) (fun x => hc x y)
  simpa using h

omit [Fintype α] [Finite β] [Finite γ] in
private theorem valueAlong (κ : α → PMF β) (η : α → PMF γ)
    (hκ : IsSingularChannel κ) (hη : IsSingularChannel η)
    (e : activeOutputs κ ≃ activeOutputs η)
    (hc : ∀ x y, η x (e y).val = κ x y.val) (y : activeOutputs κ) :
    columnValue η hη (e y) = columnValue κ hκ y :=
  columnValue_transport κ η hκ hη y (e y) (Equiv.refl α) (fun x => hc x y)

private theorem occurrencesAlong (κ : α → PMF β) (η : α → PMF γ)
    (e : activeOutputs κ ≃ activeOutputs η)
    (hc : ∀ x y, η x (e y).val = κ x y.val) : occurringPatterns η = occurringPatterns κ := by
  ext p
  rw [mem_occurringPatterns, mem_occurringPatterns]
  constructor
  · rintro ⟨z, hz⟩
    obtain ⟨y, rfl⟩ := e.surjective z
    exact ⟨y, (patternAlong κ η e hc y).symm.trans hz⟩
  · rintro ⟨y, hy⟩
    exact ⟨e y, (patternAlong κ η e hc y).trans hy⟩

private theorem aggregatesAlong (κ : α → PMF β) (η : α → PMF γ)
    (hκ : IsSingularChannel κ) (hη : IsSingularChannel η)
    (e : activeOutputs κ ≃ activeOutputs η)
    (hc : ∀ x y, η x (e y).val = κ x y.val)
    (p : OccurringPattern κ) (q : OccurringPattern η) (h : q.val = p.val) :
    patternAggregate η hη q = patternAggregate κ hκ p := by
  change (∑ z : activeOutputs η,
    if columnPattern η z = q.val then columnValue η hη z else 0) =
    ∑ y : activeOutputs κ, if columnPattern κ y = p.val then columnValue κ hκ y else 0
  rw [← e.sum_comp
    (fun z => if columnPattern η z = q.val then columnValue η hη z else 0)]
  apply Finset.sum_congr rfl
  intro y _
  rw [patternAlong κ η e hc y, valueAlong κ η hκ hη e hc y, h]

private theorem dataAlong [Nonempty α] (κ : α → PMF β) (η : α → PMF γ)
    (hκ : IsSingularChannel κ) (hη : IsSingularChannel η)
    (e : activeOutputs κ ≃ activeOutputs η)
    (hc : ∀ x y, η x (e y).val = κ x y.val) :
    compressedPatternData η hη = compressedPatternData κ hκ := by
  have hp := occurrencesAlong κ η e hc
  apply CompressedPatternData.data_ext _ _ hp
  intro q
  let p : OccurringPattern κ := ⟨q.val, by
    have hq : q.val ∈ occurringPatterns η := q.property
    rw [hp] at hq
    exact hq⟩
  exact congrArg ENNReal.toReal (aggregatesAlong κ η hκ hη e hc p q rfl)

/-- Adding unused ambient output labels does not change the intrinsic pattern family. -/
theorem occurringPatterns_map_injective (κ : α → PMF β) (j : β → γ)
    (hj : Function.Injective j) :
    occurringPatterns (fun x => (κ x).map j) = occurringPatterns κ :=
  occurrencesAlong κ _ (activeOutputsMapEquiv κ j hj)
    (fun x y => PMF.map_apply_of_injective (κ x) hj y.val)

theorem patternAggregate_map_injective (κ : α → PMF β) (j : β → γ)
    (hj : Function.Injective j) (hκ : IsSingularChannel κ)
    (hη : IsSingularChannel (fun x => (κ x).map j))
    (p : OccurringPattern κ) (q : OccurringPattern (fun x => (κ x).map j))
    (h : q.val = p.val) :
    patternAggregate (fun x => (κ x).map j) hη q = patternAggregate κ hκ p :=
  aggregatesAlong κ _ hκ hη (activeOutputsMapEquiv κ j hj)
    (fun x y => PMF.map_apply_of_injective (κ x) hj y.val) p q h

theorem patternAggregate_toReal_map_injective (κ : α → PMF β) (j : β → γ)
    (hj : Function.Injective j) (hκ : IsSingularChannel κ)
    (hη : IsSingularChannel (fun x => (κ x).map j))
    (p : OccurringPattern κ) (q : OccurringPattern (fun x => (κ x).map j))
    (h : q.val = p.val) :
    (patternAggregate (fun x => (κ x).map j) hη q).toReal = (patternAggregate κ hκ p).toReal :=
  congrArg ENNReal.toReal (patternAggregate_map_injective κ j hj hκ hη p q h)

theorem compressedPatternData_map_injective [Nonempty α] (κ : α → PMF β) (j : β → γ)
    (hj : Function.Injective j) (hκ : IsSingularChannel κ)
    (hη : IsSingularChannel (fun x => (κ x).map j)) :
    compressedPatternData (fun x => (κ x).map j) hη = compressedPatternData κ hκ :=
  dataAlong κ _ hκ hη (activeOutputsMapEquiv κ j hj)
    (fun x y => PMF.map_apply_of_injective (κ x) hj y.val)

section Enumeration
variable [Nonempty α]

/-- Supplied active enumeration preserves actual patterns, despite omitted unused labels. -/
theorem occurringPatterns_ofChannelWithEquiv (κ : α → PMF β) {m : Nat}
    (e : activeOutputs κ ≃ Fin m) :
    occurringPatterns (ActiveFiniteChannel.ofChannelWithEquiv κ e).channel = occurringPatterns κ :=
  occurrencesAlong κ _ (e.trans (ActiveFiniteChannel.ofChannelWithEquiv κ e).activeEquiv)
    (fun x y => ActiveFiniteChannel.ofChannelWithEquiv_apply κ e x y)

theorem patternAggregate_ofChannelWithEquiv (κ : α → PMF β) {m : Nat}
    (e : activeOutputs κ ≃ Fin m) (hκ : IsSingularChannel κ)
    (hS : IsSingularChannel (ActiveFiniteChannel.ofChannelWithEquiv κ e).channel)
    (p : OccurringPattern κ)
    (q : OccurringPattern (ActiveFiniteChannel.ofChannelWithEquiv κ e).channel)
    (h : q.val = p.val) :
    patternAggregate (ActiveFiniteChannel.ofChannelWithEquiv κ e).channel hS q =
      patternAggregate κ hκ p :=
  aggregatesAlong κ _ hκ hS (e.trans (ActiveFiniteChannel.ofChannelWithEquiv κ e).activeEquiv)
    (fun x y => ActiveFiniteChannel.ofChannelWithEquiv_apply κ e x y) p q h

theorem patternAggregate_toReal_ofChannelWithEquiv (κ : α → PMF β) {m : Nat}
    (e : activeOutputs κ ≃ Fin m) (hκ : IsSingularChannel κ)
    (hS : IsSingularChannel (ActiveFiniteChannel.ofChannelWithEquiv κ e).channel)
    (p : OccurringPattern κ)
    (q : OccurringPattern (ActiveFiniteChannel.ofChannelWithEquiv κ e).channel)
    (h : q.val = p.val) :
    (patternAggregate (ActiveFiniteChannel.ofChannelWithEquiv κ e).channel hS q).toReal =
      (patternAggregate κ hκ p).toReal :=
  congrArg ENNReal.toReal (patternAggregate_ofChannelWithEquiv κ e hκ hS p q h)

theorem compressedPatternData_ofChannelWithEquiv (κ : α → PMF β) {m : Nat}
    (e : activeOutputs κ ≃ Fin m) (hκ : IsSingularChannel κ)
    (hS : IsSingularChannel (ActiveFiniteChannel.ofChannelWithEquiv κ e).channel) :
    compressedPatternData (ActiveFiniteChannel.ofChannelWithEquiv κ e).channel hS =
      compressedPatternData κ hκ :=
  dataAlong κ _ hκ hS (e.trans (ActiveFiniteChannel.ofChannelWithEquiv κ e).activeEquiv)
    (fun x y => ActiveFiniteChannel.ofChannelWithEquiv_apply κ e x y)

end Enumeration
end
end PerfectFunctionalRepresentations

/-! ## Recovery through the actual inverse and ambient inclusion -/

namespace PerfectFunctionalRepresentations.MatrixOperations
noncomputable section
universe u v
variable {α : Type u} {β : Type v} [Fintype α] [Nonempty α]
variable (κ : α → PMF β) {m : Nat} (e : activeOutputs κ ≃ Fin m)
  (hS : IsSingularChannel (ActiveFiniteChannel.ofChannelWithEquiv κ e).channel)
  {n : Nat} (f : OccurringPattern (ActiveFiniteChannel.ofChannelWithEquiv κ e).channel ≃ Fin n)

/-- The retained reverse, followed by the C06 inclusion, recovers every ambient row. -/
theorem patternCompressionInverse_ambient_recover (x : α) :
    ((patternCompressionInverse
      (ActiveFiniteChannel.ofChannelWithEquiv κ e) hS f).endpoint.channel x).map
      (fun j => (e.symm ((patternCompressionInverse
        (ActiveFiniteChannel.ofChannelWithEquiv κ e) hS f).outputEquiv.equiv j)).val) = κ x := by
  let r := patternCompressionInverse (ActiveFiniteChannel.ofChannelWithEquiv κ e) hS f
  let g : Fin (ActiveFiniteChannel.ofChannelWithEquiv κ e).outputCard → β :=
    fun j => (e.symm j).val
  calc
    _ = ((r.endpoint.channel x).map r.outputEquiv.equiv).map g :=
      (PMF.map_comp (p := r.endpoint.channel x) (f := r.outputEquiv.equiv) g).symm
    _ = ((ActiveFiniteChannel.ofChannelWithEquiv κ e).channel x).map g :=
      congrArg (fun q => q.map g) (r.outputEquiv.map_eq x)
    _ = κ x := ActiveFiniteChannel.ofChannelWithEquiv_recover κ e x

/-- The ambient recovery equation includes inactive as well as active coordinates. -/
theorem patternCompressionInverse_ambient_apply (x : α) (y : β) :
    (((patternCompressionInverse
      (ActiveFiniteChannel.ofChannelWithEquiv κ e) hS f).endpoint.channel x).map
      (fun j => (e.symm ((patternCompressionInverse
        (ActiveFiniteChannel.ofChannelWithEquiv κ e) hS f).outputEquiv.equiv j)).val)) y = κ x y :=
  congrArg (fun p : PMF β => p y) (patternCompressionInverse_ambient_recover κ e hS f x)
end
end PerfectFunctionalRepresentations.MatrixOperations

/-! ## Prior-free ambient channel to valid-data bridge -/

namespace PerfectFunctionalRepresentations
open MatrixOperations
noncomputable section
universe u v
variable {α : Type u} [Fintype α] [Nonempty α]
private theorem activePerfectnessData (S : ActiveFiniteChannel α)
    (hS : IsSingularChannel S.channel) :
    IsPerfectlyRepresentableChannel S.channel ↔
      IsPerfectlyRepresentableChannel (compressedPatternData S.channel hS).channel := by
  let e : OccurringPattern S.channel ≃ Fin (Nat.card (OccurringPattern S.channel)) :=
    Finite.equivFin _
  rw [compressedPatternData_channel]
  exact (isPerfectlyRepresentable_iff_patternCompressedState S hS e).trans
    (ActiveFiniteChannel.isPerfectlyRepresentableChannel_ofActive_iff
      (patternCompressedChannel S.channel) e _)
/-- A finite ambient singular channel and the channel reconstructed from its
intrinsic valid data have the same prior-free perfect representability. The
proof uses C06 active presentation and the actual S02 compression/reverse. -/
theorem isPerfectlyRepresentableChannel_iff_compressedPatternData
    {β : Type v} [Finite β] (κ : α → PMF β) (hκ : IsSingularChannel κ) :
    IsPerfectlyRepresentableChannel κ ↔
      IsPerfectlyRepresentableChannel (compressedPatternData κ hκ).channel := by
  let e : activeOutputs κ ≃ Fin (Nat.card (activeOutputs κ)) := Finite.equivFin _
  let S := ActiveFiniteChannel.ofChannelWithEquiv κ e
  have hS : IsSingularChannel S.channel :=
    (ActiveFiniteChannel.isSingularChannel_ofChannelWithEquiv_iff κ e).mpr hκ
  have hdata := compressedPatternData_ofChannelWithEquiv κ e hκ hS
  exact (ActiveFiniteChannel.isPerfectlyRepresentableChannel_ofChannelWithEquiv_iff κ e).symm.trans
    ((activePerfectnessData S hS).trans
      (by rw [hdata]))
end
end PerfectFunctionalRepresentations
