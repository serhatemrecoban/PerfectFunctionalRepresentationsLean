import PerfectFunctionalRepresentations.Optimization.Incidence
import PerfectFunctionalRepresentations.Matrix.CanonicalReachability

/-!
# Partition coefficients, operation construction and perfectness

Each supplied feasible vector produces actual PPS, VPS and PPM paths. Their
positive-partition, dependent block and occurring-pattern labels belong to the
same retained endpoints, with exact masses and patterns. Supplied finite output
enumerations act through a directed terminal comparison.

The resulting construction proves sufficiency through C10 preservation; S03
necessity and C11/C12 public bridges give the full/reduced characterizations.
-/

namespace PerfectFunctionalRepresentations.Incidence

noncomputable section
attribute [local instance] Classical.propDecidable
open scoped BigOperators Matrix
open MatrixOperations
universe u
variable {α : Type u} [Fintype α] [Nonempty α]

/-- A positive supplied partition together with one of its exact blocks. -/
abbrev PositiveBlock (D : CompressedPatternData α) (w : AdmissiblePartition D → ℝ) :=
  (π : PositivePartition D w) × π.val.val.parts

/-- Three actual phases with complete labels and coordinates for the same coefficients. -/
structure PartitionConstruction (D : CompressedPatternData α)
    (w : AdmissiblePartition D → ℝ) where
  pps : LabelledOperationResult .pps (ActiveFiniteChannel.allOnes α)
    (PositivePartition D w) (fun _ π => ENNReal.ofReal (w π.val))
  vps : LabelledOperationResult .vps pps.endpoint (PositiveBlock D w)
    (fun x b => if x ∈ b.2.val then ENNReal.ofReal (w b.1.val) else 0)
  ppm : LabelledOperationResult .ppm vps.endpoint (OccurringPattern D)
    (fun x p => D.channel x p)

namespace PartitionConstruction

variable {D : CompressedPatternData α} {w : AdmissiblePartition D → ℝ}

/-- The same three endpoints and paths, directed toward any supplied presentation. -/
def normalForm (C : PartitionConstruction D w) {m : ℕ}
    (e : OccurringPattern D ≃ Fin m) :
    NormalForm (ActiveFiniteChannel.allOnes α) (D.toActiveFiniteChannel e) where
  ppEndpoint := C.pps.endpoint
  vpEndpoint := C.vps.endpoint
  pmEndpoint := C.ppm.endpoint
  pp := C.pps.path
  vp := C.vps.path
  pm := C.ppm.path
  pp_homogeneous := C.pps.homogeneous
  vp_homogeneous := C.vps.homogeneous
  pm_homogeneous := C.ppm.homogeneous
  outputEquiv := C.ppm.outputEquiv e (fun x p => D.toActiveFiniteChannel_apply e x p)

/-- Each positive PPS label has the full input pattern. -/
theorem pps_pattern (C : PartitionConstruction D w) (π : PositivePartition D w) :
    (columnPattern C.pps.endpoint.channel
      (C.pps.endpoint.activeEquiv (C.pps.labels π))).val = Finset.univ := by
  ext x
  rw [mem_columnPattern]
  change C.pps.endpoint.channel x (C.pps.labels π) ≠ 0 ↔
    x ∈ (Finset.univ : Finset α)
  rw [C.pps.coordinates]
  simp only [Finset.mem_univ, iff_true]
  exact ne_of_gt (ENNReal.ofReal_pos.mpr π.property)

/-- Each VPS label has precisely its supplied exact block as its pattern. -/
theorem vps_pattern (C : PartitionConstruction D w) (b : PositiveBlock D w) :
    (columnPattern C.vps.endpoint.channel
      (C.vps.endpoint.activeEquiv (C.vps.labels b))).val = b.2.val := by
  ext x
  rw [mem_columnPattern]
  change C.vps.endpoint.channel x (C.vps.labels b) ≠ 0 ↔ x ∈ b.2.val
  rw [C.vps.coordinates]
  by_cases hx : x ∈ b.2.val
  · simp [hx, ne_of_gt (ENNReal.ofReal_pos.mpr b.1.property)]
  · simp [hx]

/-- Each PPM label has precisely its occurring pattern. -/
theorem ppm_pattern (C : PartitionConstruction D w) (p : OccurringPattern D) :
    (columnPattern C.ppm.endpoint.channel
      (C.ppm.endpoint.activeEquiv (C.ppm.labels p))).val = p.val.val := by
  ext x
  rw [mem_columnPattern]
  change C.ppm.endpoint.channel x (C.ppm.labels p) ≠ 0 ↔ x ∈ p.val.val
  rw [C.ppm.coordinates, D.channel_apply]
  by_cases hx : x ∈ p.val.val
  · simp [hx, ne_of_gt (ENNReal.ofReal_pos.mpr (D.value_pos p))]
  · simp [hx]

end PartitionConstruction

section Build
variable (D : CompressedPatternData α) (w : AdmissiblePartition D → ℝ) (hw : Feasible D w)

private def positiveNNReal (π : PositivePartition D w) : NNReal :=
  ⟨w π.val, le_of_lt π.property⟩

include hw in
private theorem positiveNNReal_sum : (∑ π, positiveNNReal D w π) = 1 := by
  apply NNReal.coe_injective
  rw [NNReal.coe_sum]
  exact sum_positive_weights D hw

private def addEmptyRight (I : Type*) : I ≃ (I ⊕ {j : Fin 1 // j ≠ 0}) where
  toFun := Sum.inl
  invFun := fun z => match z with
    | .inl i => i
    | .inr j => False.elim (j.property (Subsingleton.elim _ _))
  left_inv := fun _ => rfl
  right_inv := by
    rintro (i | j)
    · rfl
    · exact False.elim (j.property (Subsingleton.elim _ _))

private def ppsResult : LabelledOperationResult .pps (ActiveFiniteChannel.allOnes α)
    (PositivePartition D w) (fun _ π => ENNReal.ofReal (w π.val)) := by
  let d := multiPps (ActiveFiniteChannel.allOnes α)
    (ActiveFiniteChannel.allOnes_isSingular α) (0 : Fin 1)
    (positiveNNReal D w) (fun π => π.property) (positiveNNReal_sum D w hw)
  refine ⟨d.endpoint, d.path, d.homogeneous, (addEmptyRight _).trans d.labels, ?_⟩
  intro x π
  exact (d.coordinates x (.inl π)).trans (by
    change (positiveNNReal D w π : ENNReal) *
      (ActiveFiniteChannel.allOnes α).channel x (0 : Fin 1) = _
    rw [ActiveFiniteChannel.allOnes_apply, mul_one]
    exact ENNReal.coe_nnreal_eq (positiveNNReal D w π))

private theorem ppsCarrier (j : Fin (ppsResult D w hw).endpoint.outputCard) :
    (columnPattern (ppsResult D w hw).endpoint.channel
      ((ppsResult D w hw).endpoint.activeEquiv j)).val = Finset.univ := by
  let d := ppsResult D w hw
  ext x
  rw [mem_columnPattern]
  change d.endpoint.channel x j ≠ 0 ↔ x ∈ (Finset.univ : Finset α)
  have hc := d.coordinates x (d.labels.symm j)
  rw [Equiv.apply_symm_apply] at hc
  rw [hc]
  simp only [Finset.mem_univ, iff_true]
  exact ne_of_gt (ENNReal.ofReal_pos.mpr (d.labels.symm j).property)

private def transportedPartition (j : Fin (ppsResult D w hw).endpoint.outputCard) :
    Finpartition (columnPattern (ppsResult D w hw).endpoint.channel
      ((ppsResult D w hw).endpoint.activeEquiv j)).val :=
  ((ppsResult D w hw).labels.symm j).val.val.copy (ppsCarrier D w hw j).symm

private def rawVps :=
  multiVpsFamily (ppsResult D w hw).endpoint
    ((ppsResult D w hw).isSingular (ActiveFiniteChannel.allOnes_isSingular α))
    (transportedPartition D w hw)

-- Finpartition.copy retains parts definitionally; sigmaCongrLeft transports only
-- the actual PPS output index through its returned label equivalence.
private def vpsSemanticLabels :
    (Σ j, (transportedPartition D w hw j).parts) ≃ PositiveBlock D w :=
  Equiv.sigmaCongrLeft (β := fun π : PositivePartition D w => π.val.val.parts)
    (ppsResult D w hw).labels.symm

private def vpsResult : LabelledOperationResult .vps (ppsResult D w hw).endpoint
    (PositiveBlock D w)
    (fun x b => if x ∈ b.2.val then ENNReal.ofReal (w b.1.val) else 0) := by
  let r := rawVps D w hw
  let e := vpsSemanticLabels D w hw
  refine ⟨r.endpoint, r.path, r.homogeneous, e.symm.trans r.labels, ?_⟩
  intro x b
  obtain ⟨z, rfl⟩ := e.surjective b
  change r.endpoint.channel x (r.labels (e.symm (e z))) = _
  rw [Equiv.symm_apply_apply]
  change r.endpoint.channel x (r.labels z) =
    if x ∈ z.2.val then ENNReal.ofReal (w ((ppsResult D w hw).labels.symm z.1).val) else 0
  rw [r.coordinates]
  have hp := (ppsResult D w hw).coordinates x ((ppsResult D w hw).labels.symm z.1)
  rw [Equiv.apply_symm_apply] at hp
  rw [hp]

private def ppmGroup (j : Fin (vpsResult D w hw).endpoint.outputCard) : OccurringPattern D :=
  positiveBlockPattern D w ((vpsResult D w hw).labels.symm j)

private theorem ppmGroup_surjective : Function.Surjective (ppmGroup D w hw) :=
  (positiveBlockPattern_surjective D hw).comp (vpsResult D w hw).labels.symm.surjective

private theorem vps_support (j : Fin (vpsResult D w hw).endpoint.outputCard) (x : α) :
    (vpsResult D w hw).endpoint.channel x j ≠ 0 ↔ x ∈ (ppmGroup D w hw j).val.val := by
  let b := (vpsResult D w hw).labels.symm j
  have hc := (vpsResult D w hw).coordinates x b
  simp only [b, Equiv.apply_symm_apply] at hc
  rw [hc]
  change (if x ∈ b.2.val then ENNReal.ofReal (w b.1.val) else 0) ≠ 0 ↔ x ∈ b.2.val
  by_cases hx : x ∈ b.2.val
  · simp [hx, ne_of_gt (ENNReal.ofReal_pos.mpr b.1.property)]
  · simp [hx]

private theorem ppmGroup_support (i j : Fin (vpsResult D w hw).endpoint.outputCard)
    (h : ppmGroup D w hw i = ppmGroup D w hw j) (x : α) :
    (vpsResult D w hw).endpoint.channel x i ≠ 0 ↔
      (vpsResult D w hw).endpoint.channel x j ≠ 0 := by
  rw [vps_support, vps_support, h]

private def rawPpm :=
  multiPpmFibers (vpsResult D w hw).endpoint
    ((vpsResult D w hw).isSingular
      ((ppsResult D w hw).isSingular (ActiveFiniteChannel.allOnes_isSingular α)))
    (ppmGroup D w hw) (ppmGroup_surjective D w hw) (ppmGroup_support D w hw)

include hw in
private theorem positive_exact_incidence (p : OccurringPattern D) :
    (∑ π : PositivePartition D w,
      if p.val.val ∈ π.val.val.parts then ENNReal.ofReal (w π.val) else 0) =
      ENNReal.ofReal (D.value p) := by
  have hr : (∑ π : PositivePartition D w,
      if p.val.val ∈ π.val.val.parts then w π.val else 0) = D.value p := by
    simpa only [reducedMatrix_apply, ite_mul, one_mul, zero_mul] using
      positive_incidence_sum D hw p
  have he := congrArg ENNReal.ofReal hr
  rw [ENNReal.ofReal_sum_of_nonneg (fun π _ => by
    split_ifs
    · exact le_of_lt π.property
    · exact le_rfl)] at he
  simpa only [apply_ite ENNReal.ofReal, ENNReal.ofReal_zero] using he

private theorem blockPattern_eq_iff (π : PositivePartition D w) (b : π.val.val.parts)
    (p : OccurringPattern D) :
    positiveBlockPattern D w ⟨π, b⟩ = p ↔ b.val = p.val.val := by
  constructor
  · intro h; exact congrArg (fun q : OccurringPattern D => q.val.val) h
  · intro h; exact Subtype.ext (Subtype.ext h)

private theorem singlePartitionMass (π : PositivePartition D w) (x : α)
    (p : OccurringPattern D) :
    (∑ b : π.val.val.parts,
      if positiveBlockPattern D w ⟨π, b⟩ = p then
        (if x ∈ b.val then ENNReal.ofReal (w π.val) else 0) else 0) =
      if p.val.val ∈ π.val.val.parts then
        (if x ∈ p.val.val then ENNReal.ofReal (w π.val) else 0) else 0 := by
  simp_rw [blockPattern_eq_iff]
  rw [Finset.sum_coe_sort π.val.val.parts (fun b : Finset α =>
    if b = p.val.val then (if x ∈ b then ENNReal.ofReal (w π.val) else 0) else 0)]
  exact Finset.sum_ite_eq' _ _ _

private theorem ppmMass (x : α) (p : OccurringPattern D) :
    (∑ j, if ppmGroup D w hw j = p then (vpsResult D w hw).endpoint.channel x j else 0) =
      D.channel x p := by
  rw [← (vpsResult D w hw).labels.sum_comp (fun j =>
    if ppmGroup D w hw j = p then (vpsResult D w hw).endpoint.channel x j else 0)]
  simp only [ppmGroup, Equiv.symm_apply_apply, (vpsResult D w hw).coordinates]
  rw [Fintype.sum_sigma]
  simp_rw [singlePartitionMass]
  rw [D.channel_apply]
  by_cases hx : x ∈ p.val.val
  · simp only [if_pos hx]
    exact positive_exact_incidence D w hw p
  · simp [hx]

private def ppmResult : LabelledOperationResult .ppm (vpsResult D w hw).endpoint
    (OccurringPattern D) (fun x p => D.channel x p) := by
  let d := rawPpm D w hw
  refine ⟨d.endpoint, d.path, d.homogeneous, d.labels, ?_⟩
  intro x p
  calc
    _ = (∑ j, if ppmGroup D w hw j = p then
      (vpsResult D w hw).endpoint.channel x j else 0) := by
        convert d.coordinates x p using 1
        apply Finset.sum_congr rfl
        intro j _
        by_cases hj : ppmGroup D w hw j = p
        · simp only [if_pos hj]
        · simp only [if_neg hj]
    _ = _ := ppmMass D w hw x p

/-- Construct the three specified phases from the supplied feasible coefficients.
The phase labels use precisely their positive support; no replacement feasible
vector is selected. -/
def partitionConstruction : PartitionConstruction D w where
  pps := ppsResult D w hw
  vps := vpsResult D w hw
  ppm := ppmResult D w hw

/-- The actual returned PPS path splits the seed into exactly its positive labels. -/
theorem partitionConstruction_pps_length :
    (partitionConstruction D w hw).pps.path.length = Fintype.card (PositivePartition D w) - 1 := by
  exact multiPps_length (ActiveFiniteChannel.allOnes α)
    (ActiveFiniteChannel.allOnes_isSingular α) (0 : Fin 1)
    (positiveNNReal D w) (fun π => π.property) (positiveNNReal_sum D w hw)

/-- The actual returned PPM path merges the positive blocks to the occurring patterns. -/
theorem partitionConstruction_ppm_length :
    (partitionConstruction D w hw).ppm.path.length =
      Fintype.card (PositiveBlock D w) - Fintype.card (OccurringPattern D) := by
  have h := multiPpmFibers_length (vpsResult D w hw).endpoint
    ((vpsResult D w hw).isSingular
      ((ppsResult D w hw).isSingular (ActiveFiniteChannel.allOnes_isSingular α)))
    (ppmGroup D w hw) (ppmGroup_surjective D w hw) (ppmGroup_support D w hw)
  exact h.trans (congrArg (fun n => n - Fintype.card (OccurringPattern D))
    (vpsResult D w hw).outputCard)

end Build
end
end PerfectFunctionalRepresentations.Incidence


namespace PerfectFunctionalRepresentations.Incidence

open MatrixOperations
noncomputable section
attribute [local instance] Classical.propDecidable
universe u v
variable {α : Type u} [Fintype α] [Nonempty α]

/-- A retained partition construction proves perfectness through its actual operation paths. -/
theorem PartitionConstruction.isPerfectlyRepresentable {D : CompressedPatternData α}
    {w : AdmissiblePartition D → ℝ} (C : PartitionConstruction D w) :
    IsPerfectlyRepresentableChannel D.channel := by
  let e := Fintype.equivFin (OccurringPattern D)
  have h : FromAllOnes (D.toActiveFiniteChannel e) :=
    ⟨(C.normalForm e).toCascade, (C.normalForm e).toCascade_normalizing⟩
  exact (ActiveFiniteChannel.isPerfectlyRepresentableChannel_ofActive_iff
    D.channel e _).mp h.isPerfectlyRepresentable

/-- Every supplied feasible vector gives perfectness through its own construction. -/
theorem isPerfectlyRepresentableChannel_of_feasible (D : CompressedPatternData α)
    {w : AdmissiblePartition D → ℝ} (hw : Feasible D w) :
    IsPerfectlyRepresentableChannel D.channel :=
  (partitionConstruction D w hw).isPerfectlyRepresentable

/-- Reduced nonnegative equality feasibility characterizes perfectness. -/
theorem isPerfectlyRepresentableChannel_iff_exists_feasible (D : CompressedPatternData α) :
    IsPerfectlyRepresentableChannel D.channel ↔ ∃ w, Feasible D w :=
  ⟨exists_feasible_of_isPerfectlyRepresentableChannel D,
    fun ⟨_, hw⟩ => isPerfectlyRepresentableChannel_of_feasible D hw⟩

/-- Full nonnegative equality feasibility has the same characterization. -/
theorem isPerfectlyRepresentableChannel_iff_exists_fullFeasible
    (D : CompressedPatternData α) :
    IsPerfectlyRepresentableChannel D.channel ↔ ∃ w, FullFeasible D w :=
  (isPerfectlyRepresentableChannel_iff_exists_feasible D).trans
    (exists_fullFeasible_iff D).symm

/-- Existence of the three specified phases is equivalent to perfectness.
The coefficient vector is existential here; a same-vector converse for signed
coefficients outside positive support is not asserted. -/
theorem isPerfectlyRepresentableChannel_iff_exists_partitionConstruction
    (D : CompressedPatternData α) :
    IsPerfectlyRepresentableChannel D.channel ↔
      ∃ w, Nonempty (PartitionConstruction D w) := by
  constructor
  · intro h
    obtain ⟨w, hw⟩ := exists_feasible_of_isPerfectlyRepresentableChannel D h
    exact ⟨w, ⟨partitionConstruction D w hw⟩⟩
  · rintro ⟨w, ⟨C⟩⟩
    exact C.isPerfectlyRepresentable

/-- Feasibility gives precisely the C11 construction predicate in any supplied presentation. -/
theorem exists_feasible_iff_fromAllOnes (D : CompressedPatternData α) {m : ℕ}
    (e : OccurringPattern D ≃ Fin m) :
    (∃ w, Feasible D w) ↔ FromAllOnes (D.toActiveFiniteChannel e) :=
  (isPerfectlyRepresentableChannel_iff_exists_feasible D).symm.trans
    ((ActiveFiniteChannel.isPerfectlyRepresentableChannel_ofActive_iff D.channel e _).symm.trans
      (MatrixOperations.isPerfectlyRepresentable_iff_fromAllOnes (D.toActiveFiniteChannel e)))

/-- The same feasibility predicate gives the C11 reduction predicate. -/
theorem exists_feasible_iff_toAllOnes (D : CompressedPatternData α) {m : ℕ}
    (e : OccurringPattern D ≃ Fin m) :
    (∃ w, Feasible D w) ↔ ToAllOnes (D.toActiveFiniteChannel e) :=
  (isPerfectlyRepresentableChannel_iff_exists_feasible D).symm.trans
    ((ActiveFiniteChannel.isPerfectlyRepresentableChannel_ofActive_iff D.channel e _).symm.trans
      (MatrixOperations.isPerfectlyRepresentable_iff_toAllOnes (D.toActiveFiniteChannel e)))

/-- A finite ambient singular channel is perfect exactly when its reduced
incidence system is feasible. -/
theorem isPerfectlyRepresentableChannel_iff_feasible_compressedPatternData
    {β : Type v} [Finite β] (κ : α → PMF β) (hκ : IsSingularChannel κ) :
    IsPerfectlyRepresentableChannel κ ↔ ∃ w, Feasible (compressedPatternData κ hκ) w :=
  (isPerfectlyRepresentableChannel_iff_compressedPatternData κ hκ).trans
    (isPerfectlyRepresentableChannel_iff_exists_feasible _)

/-- The ambient characterization also holds for the full zero-padded system. -/
theorem isPerfectlyRepresentableChannel_iff_fullFeasible_compressedPatternData
    {β : Type v} [Finite β] (κ : α → PMF β) (hκ : IsSingularChannel κ) :
    IsPerfectlyRepresentableChannel κ ↔ ∃ w, FullFeasible (compressedPatternData κ hκ) w :=
  (isPerfectlyRepresentableChannel_iff_compressedPatternData κ hκ).trans
    (isPerfectlyRepresentableChannel_iff_exists_fullFeasible _)

end
end PerfectFunctionalRepresentations.Incidence
