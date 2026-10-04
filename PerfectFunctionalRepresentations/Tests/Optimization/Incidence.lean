import PerfectFunctionalRepresentations.Optimization.IncidenceConstruction
import PerfectFunctionalRepresentations.Matrix.CanonicalReachability
import PerfectFunctionalRepresentations.Optimization.Primal
import PerfectFunctionalRepresentations.Optimization.Dual
import PerfectFunctionalRepresentations.Optimization.DualCharacterization

/-!
# Consumers of exact partition/incidence coordinates

S01 covers minimal valid data, finite full/reduced indices, the partition
indicator boundary, dimensions, supplied enumeration direction and empty
reduced columns. S02 adds equality feasibility, transport and positive-support
consumers, including the actual C10 coefficient interface. S03 consumes the
public necessity theorems on generic and singleton data and through C11/C12.
S04 recovers all three phase specifications from one returned construction,
changes its supplied presentation and consumes the ambient characterization.
C14-S01 reuses the private singleton and empty-family fixtures for primal
inequality feasibility and objective values, before the saturation theorem.
C14-S02 consumes saturation and the data characterization on those fixtures.
C14-S03 checks ambient outputs, changed presentations and empty finite columns.
C15-S01 checks scalar dual constraints, weak-duality direction and the empty-family
zero certificate beside the retained private fixtures.
C15-S02 consumes the public subunit certificate on the same empty-family datum.
C15-S03 checks attained leastness and actual perfect/nonperfect Option channels,
including inactive labels, injection and changed active presentations.
C15-S04 consumes finite dual images on those same ambient endpoints and keeps
three occurring-pattern coordinates when the partition presentation is Fin 0.
-/

namespace PerfectFunctionalRepresentations.Incidence.Tests

open scoped BigOperators Matrix

noncomputable section
attribute [local instance] Classical.propDecidable

section Generic

variable {α : Type*} [Fintype α] [Nonempty α] (D : CompressedPatternData α)

-- R01: valid data alone supply finite coordinates, without Nonempty admissible indices.
example : Fintype (NonzeroPattern α) := inferInstance
example : Fintype (ExactPartition α) := inferInstance
example : Fintype (OccurringPattern D) := inferInstance
example : Fintype (AdmissiblePartition D) := inferInstance

example : AdmissiblePartition D ≃ Fin (Fintype.card (AdmissiblePartition D)) :=
  Fintype.equivFin _

example : D.patterns.card ≤ 2 ^ Fintype.card α - 1 := patterns_card_le D

example : Fintype.card (AdmissiblePartition D) ≤ Fintype.card (ExactPartition α) :=
  card_admissiblePartition_le D

-- The converse retains both the number of blocks and each supplied pattern.
example (S : Finset (NonzeroPattern α))
    (h : ∀ x, ∑ p : ↥S, (if x ∈ p.val.val then (1 : ℝ) else 0) = 1) :
    ∃ π : ExactPartition α, π.parts.card = S.card ∧ ∀ p ∈ S, p.val ∈ π.parts := by
  obtain ⟨π, e, he⟩ := exists_exactPartition_of_indicator_sum S h
  refine ⟨π, ?_, ?_⟩
  · simpa only [Fintype.card_coe] using (Fintype.card_congr e).symm
  · intro p hp
    rw [← he ⟨p, hp⟩]
    exact (e ⟨p, hp⟩).property

example (π : ExactPartition α) (x : α) :
    ∑ b : π.parts, (if x ∈ b.val then (1 : ℝ) else 0) = 1 :=
  exactPartition_indicator_sum π x

-- R11: arbitrary independent enumerations use their inverses in coordinates.
example {m r : ℕ} (rows : OccurringPattern D ≃ Fin m)
    (cols : AdmissiblePartition D ≃ Fin r) (i : Fin m) (j : Fin r) :
    Matrix.reindex rows cols (reducedMatrix D) i j =
      if (rows.symm i).val.val ∈ (cols.symm j).val.parts then 1 else 0 := rfl

example {m r : ℕ} (rows : NonzeroPattern α ≃ Fin m)
    (cols : ExactPartition α ≃ Fin r) (weight : ExactPartition α → ℝ) :
    ((∀ j, 0 ≤ (weight ∘ cols.symm) j) ∧
      Matrix.reindex rows cols fullMatrix *ᵥ (weight ∘ cols.symm) =
        fullValue D ∘ rows.symm) ↔
    ((∀ π, 0 ≤ weight π) ∧ fullMatrix *ᵥ weight = fullValue D) :=
  system_reindex_iff fullMatrix (fullValue D) weight rows cols

example {m r : ℕ} (rows : OccurringPattern D ≃ Fin m)
    (cols : AdmissiblePartition D ≃ Fin r) (weight : AdmissiblePartition D → ℝ) :
    ((∀ j, 0 ≤ (weight ∘ cols.symm) j) ∧
      Matrix.reindex rows cols (reducedMatrix D) *ᵥ (weight ∘ cols.symm) =
        D.value ∘ rows.symm) ↔
    ((∀ π, 0 ≤ weight π) ∧ reducedMatrix D *ᵥ weight = D.value) :=
  system_reindex_iff (reducedMatrix D) D.value weight rows cols

example {k m : ℕ} (rows : α ≃ Fin k) (cols : OccurringPattern D ≃ Fin m)
    (x : Fin k) (p : Fin m) :
    Matrix.reindex rows cols (inputMatrix D) x p =
      if rows.symm x ∈ (cols.symm p).val.val then 1 else 0 := rfl

example {k m : ℕ} (rows : α ≃ Fin k) (cols : OccurringPattern D ≃ Fin m)
    (weight : OccurringPattern D → ℝ) (value : α → ℝ) :
    ((∀ p, 0 ≤ (weight ∘ cols.symm) p) ∧
      Matrix.reindex rows cols (inputMatrix D) *ᵥ (weight ∘ cols.symm) =
        value ∘ rows.symm) ↔
    ((∀ p, 0 ≤ weight p) ∧ inputMatrix D *ᵥ weight = value) :=
  system_reindex_iff (inputMatrix D) value weight rows cols

end Generic

-- A three-cycle detects replacing the inverse enumeration by the forward map.
private def rotate : Fin 3 ≃ Fin 3 := (Equiv.swap 0 1).trans (Equiv.swap 1 2)

private def asymmetric : Matrix (Fin 3) (Fin 3) ℝ :=
  fun i j => 10 * (i.val : ℝ) + j.val

example : Fintype.card (NonzeroPattern (Fin 3)) = 7 := by
  rw [card_nonzeroPattern]
  norm_num

private theorem rotate_at_zero : rotate 0 = 2 ∧ rotate.symm 0 = 1 := by
  norm_num [rotate, Equiv.swap_apply_def, Fin.ext_iff]

example : Matrix.reindex rotate rotate.symm asymmetric 0 0 = 12 := by
  change asymmetric (rotate.symm 0) (rotate 0) = 12
  rw [rotate_at_zero.2, rotate_at_zero.1]
  norm_num [asymmetric]

private def signedWeight : Fin 3 → ℝ := ![1, -2, 3]

example :
    (Matrix.reindex rotate rotate.symm asymmetric *ᵥ (signedWeight ∘ rotate)) 0 = 24 := by
  calc
    _ = (asymmetric *ᵥ signedWeight) (rotate.symm 0) :=
      congrFun (reindex_mulVec asymmetric signedWeight rotate rotate.symm) 0
    _ = 24 := by
      rw [rotate_at_zero.2]
      norm_num [Matrix.mulVec, dotProduct, Fin.sum_univ_succ, asymmetric, signedWeight]


-- Shared fixture checks for an actual unused ambient output label.
private theorem c15Option_singular {α : Type*} [Fintype α] [Nonempty α]
    (D : CompressedPatternData α) : IsSingularChannel (fun x => (D.channel x).map some) :=
  (isSingularChannel_map_iff D.channel some (Option.some_injective _)).mpr D.channel_singular

private theorem c15Option_zero {α : Type*} [Fintype α] [Nonempty α]
    (D : CompressedPatternData α) (x : α) : ((D.channel x).map some) none = 0 := by
  apply PMF.map_apply_eq_zero_of_notMem_range
  rintro ⟨p, hp⟩
  cases hp

private theorem c15Option_inactive {α : Type*} [Fintype α] [Nonempty α]
    (D : CompressedPatternData α) : none ∉ activeOutputs (fun x => (D.channel x).map some) := by
  rintro ⟨x, hx⟩
  exact (PMF.mem_support_iff _ _).mp hx (c15Option_zero D x)

private theorem c15Option_patterns {α : Type*} [Fintype α] [Nonempty α]
    (D : CompressedPatternData α) :
    occurringPatterns (fun x => (D.channel x).map some) = D.patterns :=
  (occurringPatterns_map_injective D.channel some (Option.some_injective _)).trans
    D.occurringPatterns_channel

private theorem c15Option_extraction {α : Type*} [Fintype α] [Nonempty α]
    (D : CompressedPatternData α) :
    compressedPatternData (fun x => (D.channel x).map some) (c15Option_singular D) = D :=
  (compressedPatternData_map_injective D.channel some (Option.some_injective _)
    D.channel_singular (c15Option_singular D)).trans D.extraction_roundTrip

-- R02: every valid singleton-input datum has the one pattern and partition.
namespace SingletonFixture

local instance : DecidableEq Unit := fun a b => Classical.propDecidable (a = b)

private abbrev Pat := NonzeroPattern Unit
private def unitPattern : Pat := ⟨Finset.univ, Finset.univ_nonempty⟩
private theorem unitPattern_unique (p : Pat) : p = unitPattern := by
  apply Subtype.ext
  apply Finset.ext
  intro x
  simp only [unitPattern, Finset.mem_univ, iff_true]
  obtain ⟨y,hy⟩ := p.property
  exact (Subsingleton.elim y x) ▸ hy

private theorem unit_patterns (D : CompressedPatternData Unit) :
    D.patterns = {unitPattern} := by
  apply Finset.eq_singleton_iff_unique_mem.mpr
  constructor
  · obtain ⟨p,hp⟩ := D.patterns_nonempty
    rwa [unitPattern_unique p] at hp
  · intro p hp
    exact unitPattern_unique p

example (D : CompressedPatternData Unit) : D.patterns.card = 1 := by
  rw [unit_patterns]
  simp

private theorem unit_value (D : CompressedPatternData Unit) (p : ↥D.patterns) :
    D.value p = 1 := by
  have h := D.row_sum ()
  have hsum : (∑ q : ↥D.patterns,
      if () ∈ q.val.val then D.value q else 0) =
      if () ∈ p.val.val then D.value p else 0 := by
    apply Finset.sum_eq_single p
    · intro q hq hqp
      exact False.elim (hqp (Subtype.ext
        ((unitPattern_unique q.val).trans (unitPattern_unique p.val).symm)))
    · intro hp
      exact False.elim (hp (Finset.mem_univ p))
  rw [hsum] at h
  simpa only [show (() : Unit) ∈ p.val.val from by
    rw [unitPattern_unique p.val]; simp [unitPattern], if_true] using h
private def unitPartition : Finpartition (Finset.univ : Finset Unit) :=
  Finpartition.indiscrete (by simp)

private theorem unitPartition_parts (π : Finpartition (Finset.univ : Finset Unit)) :
    π.parts = {Finset.univ} := by
  apply Finset.eq_singleton_iff_unique_mem.mpr
  constructor
  · obtain ⟨b,hb,hx⟩ := π.exists_mem (Finset.mem_univ ())
    have he := congrArg Subtype.val (unitPattern_unique ⟨b,π.nonempty_of_mem_parts hb⟩)
    change b = Finset.univ at he
    rwa [he] at hb
  · intro b hb
    exact congrArg Subtype.val (unitPattern_unique ⟨b,π.nonempty_of_mem_parts hb⟩)

private theorem unitPartition_unique (π : Finpartition (Finset.univ : Finset Unit)) :
    π = unitPartition := by
  apply Finpartition.ext
  exact unitPartition_parts π

example (D : CompressedPatternData Unit) (π : Finpartition (Finset.univ : Finset Unit))
    (b : π.parts) :
    (⟨b.val, π.nonempty_of_mem_parts b.property⟩ : Pat) ∈ D.patterns := by
  rw [unit_patterns]
  exact Finset.mem_singleton.mpr (unitPattern_unique _)

private def unitOccurring (D : CompressedPatternData Unit) : Incidence.OccurringPattern D :=
  ⟨unitPattern, by rw [unit_patterns]; simp⟩

private def unitAdmissible (D : CompressedPatternData Unit) : AdmissiblePartition D := by
  refine ⟨unitPartition, fun b => ?_⟩
  rw [unit_patterns]
  exact Finset.mem_singleton.mpr (unitPattern_unique _)

local instance : Unique (NonzeroPattern Unit) := ⟨⟨unitPattern⟩, unitPattern_unique⟩
local instance : Unique (ExactPartition Unit) := ⟨⟨unitPartition⟩, unitPartition_unique⟩
local instance (D : CompressedPatternData Unit) : Unique (Incidence.OccurringPattern D) :=
  ⟨⟨unitOccurring D⟩, fun p => Subtype.ext (unitPattern_unique p.val)⟩
local instance (D : CompressedPatternData Unit) : Unique (AdmissiblePartition D) :=
  ⟨⟨unitAdmissible D⟩, fun π => Subtype.ext (unitPartition_unique π.val)⟩

example (D : CompressedPatternData Unit) :
    Fintype.card (NonzeroPattern Unit) = 1 ∧
      Fintype.card (Incidence.OccurringPattern D) = 1 ∧
      Fintype.card (ExactPartition Unit) = 1 ∧
      Fintype.card (AdmissiblePartition D) = 1 := by simp

example (D : CompressedPatternData Unit) :
    fullValue D unitPattern = 1 := by
  rw [fullValue_of_mem D unitPattern (unitOccurring D).property]
  exact unit_value D _

example : fullMatrix unitPattern unitPartition = 1 := by
  simp [fullMatrix, unitPattern, unitPartition, Finpartition.indiscrete]

example (D : CompressedPatternData Unit) :
    reducedMatrix D (unitOccurring D) (unitAdmissible D) = 1 := by
  simp [reducedMatrix, fullMatrix, unitOccurring, unitAdmissible,
    unitPattern, unitPartition, Finpartition.indiscrete]

example (D : CompressedPatternData Unit) (x : Unit) :
    inputMatrix D x (unitOccurring D) = 1 := by
  simp [inputMatrix, fullInputMatrix, unitOccurring, unitPattern]


-- R02: the unit coefficient solves the actual reduced predicate, and transports.
private theorem unit_feasible (D : CompressedPatternData Unit) :
    Feasible D (fun _ => 1) := by
  constructor
  · intro π; exact zero_le_one
  · funext p
    rw [unit_value D p]
    simp only [Matrix.mulVec, dotProduct, Fintype.sum_unique, mul_one]
    change fullMatrix p.val (unitAdmissible D).val = 1
    rw [unitPattern_unique p.val]
    simp [fullMatrix, unitAdmissible, unitPattern, unitPartition, Finpartition.indiscrete]

-- C14-S01 / R02: the singleton primal includes both slack and endpoint weights.
private theorem unit_primal_feasible (D : CompressedPatternData Unit) (t : ℝ)
    (ht0 : 0 ≤ t) (ht1 : t ≤ 1) : Primal.Feasible D (fun _ => t) := by
  refine ⟨fun _ => ht0, ?_⟩
  intro p
  have he := congrFun (unit_feasible D).2 p
  simp only [Matrix.mulVec, dotProduct, Fintype.sum_unique, mul_one] at he
  simp only [Matrix.mulVec, dotProduct, Fintype.sum_unique]
  rw [he, unit_value D p, one_mul]
  exact ht1

private theorem unit_primal_objective (D : CompressedPatternData Unit) (t : ℝ) :
    Primal.objective D (fun _ => t) = t := by
  simp only [Primal.objective, Fintype.sum_unique]

example (D : CompressedPatternData Unit) :
    Primal.Feasible D (fun _ => 0) ∧ Primal.objective D (fun _ => 0) = 0 :=
  ⟨Primal.feasible_zero D, Primal.objective_zero D⟩

example (D : CompressedPatternData Unit) :
    Primal.Feasible D (fun _ => 1 / 2) ∧
      Primal.objective D (fun _ => 1 / 2) = 1 / 2 :=
  ⟨unit_primal_feasible D _ (by norm_num) (by norm_num), unit_primal_objective D _⟩

example (D : CompressedPatternData Unit) :
    Primal.Feasible D (fun _ => 1) ∧ Primal.objective D (fun _ => 1) = 1 :=
  ⟨unit_primal_feasible D _ zero_le_one le_rfl, unit_primal_objective D _⟩

-- C14-S02 / R02: the endpoint saturates and witnesses attained greatestness.
example (D : CompressedPatternData Unit) :
    reducedMatrix D *ᵥ (fun _ => 1) = D.value :=
  (Primal.objective_eq_one_iff D
    (unit_primal_feasible D _ zero_le_one le_rfl)).mp (unit_primal_objective D _)

example (D : CompressedPatternData Unit) :
    IsPerfectlyRepresentableChannel D.channel ∧
      IsGreatest (Primal.objectiveValues D) 1 := by
  have h := (Primal.isPerfectlyRepresentableChannel_iff_exists_objective_eq_one D).mpr
    ⟨fun _ => 1, unit_primal_feasible D _ zero_le_one le_rfl, unit_primal_objective D _⟩
  exact ⟨h, (Primal.isPerfectlyRepresentableChannel_iff_isGreatest D).mp h⟩

example (D : CompressedPatternData Unit) :
    ¬ Feasible D (fun _ => 1 / 2) := by
  intro hx
  have h := ((Primal.equality_feasible_iff D).mp hx).2
  rw [unit_primal_objective D] at h
  norm_num at h

example (D : CompressedPatternData Unit) :
    FullFeasible D (extendWeights D (fun _ => 1)) :=
  fullFeasible_extendWeights D (unit_feasible D)

example (D : CompressedPatternData Unit) :
    restrictWeights D (extendWeights D (fun _ => 1)) = (fun _ => 1) :=
  restrict_extendWeights D _


-- The singleton perfectness witness is semantic and precedes S04 synthesis.
private theorem unit_perfect (D : CompressedPatternData Unit) :
    IsPerfectlyRepresentableChannel D.channel := by
  let f : Unit → OccurringPattern D := fun _ => unitOccurring D
  have hc (x : Unit) : D.channel x = PMF.pure (unitOccurring D) := by
    apply PMF.ext
    intro p
    have hp : p = unitOccurring D := Subsingleton.elim _ _
    subst p
    rw [D.channel_apply, unit_value]
    simp [unitOccurring, unitPattern]
  refine ⟨PMF.pure f, fun _ => PMF.pure f, ?_⟩
  intro x
  rw [hc]
  simp [f, PMF.channelJoint, PMF.pure_map]

example (D : CompressedPatternData Unit) : IsPerfectlyRepresentableChannel D.channel :=
  unit_perfect D

-- C14-S03 / R10: the ambient characterization retains an attained perfect endpoint.
example (D : CompressedPatternData Unit) :
    IsGreatest (Primal.objectiveValues
      (compressedPatternData D.channel D.channel_singular)) 1 :=
  (Primal.isPerfectlyRepresentableChannel_iff_isGreatest_compressedPatternData
    D.channel D.channel_singular).mp (unit_perfect D)

example (D : CompressedPatternData Unit) :
    ∃ w, Feasible D w ∧ w (unitAdmissible D) = 1 := by
  obtain ⟨w, hw⟩ := exists_feasible_of_isPerfectlyRepresentableChannel D (unit_perfect D)
  refine ⟨w, hw, ?_⟩
  simpa only [Fintype.sum_unique,
    show (default : AdmissiblePartition D) = unitAdmissible D from Subsingleton.elim _ _]
    using sum_eq_one_of_reduced_eq D w hw.2

/-! S04 singleton positive support and zero-length VPS check. -/
open MatrixOperations
attribute [local instance] operationQuiver
private def unitPositive (D : CompressedPatternData Unit) : PositivePartition D (fun _ => 1) :=
  ⟨unitAdmissible D,zero_lt_one⟩
local instance (D : CompressedPatternData Unit) : Unique (PositivePartition D (fun _ => 1)) :=
  ⟨⟨unitPositive D⟩,fun _p => Subtype.ext (Subsingleton.elim _ _)⟩
private theorem unitPositive_card (D : CompressedPatternData Unit) :
    Fintype.card (PositivePartition D (fun _ => 1)) = 1 := by simp
private theorem unitBlocks_card (D : CompressedPatternData Unit) :
    Fintype.card ((π : PositivePartition D (fun _ => 1)) × π.val.val.parts) = 1 := by
  simp [Fintype.card_sigma,unitPartition_parts]

-- Local copy of the elementary homogeneous-path count argument; no new API.
private theorem unitVpsGrowth {S T : ActiveFiniteChannel Unit}
    (p : OperationPath S T) (hp : p.Homogeneous .vps) :
    T.outputCard = S.outputCard + p.length := by
  induction p with
  | nil => rfl
  | cons p e ih =>
      have h := (OperationPath.allowed_snoc _ p e).mp hp
      cases e with
      | pps hT l t ht0 ht1 => simp [OperationStep.kind] at h
      | vps hT l mask hl hr =>
          change _ + 1 = S.outputCard + (p.length + 1)
          rw [ih h.1,Nat.add_assoc]
          rfl
      | ppm hT a b hab hs => simp [OperationStep.kind] at h
      | vpm hT a b hab hv hd => simp [OperationStep.kind] at h


private def unitConstruction (D : CompressedPatternData Unit) :=
  partitionConstruction D (fun _ => 1) (unit_feasible D)
private theorem unitPhase_cards (D : CompressedPatternData Unit) :
    (unitConstruction D).pps.endpoint.outputCard = 1 ∧
    (unitConstruction D).vps.endpoint.outputCard = 1 ∧
    (unitConstruction D).ppm.endpoint.outputCard = 1 := by
  refine ⟨(unitConstruction D).pps.outputCard.trans (unitPositive_card D),
    (unitConstruction D).vps.outputCard.trans (unitBlocks_card D),?_⟩
  rw [(unitConstruction D).ppm.outputCard]
  simp
private theorem unitPps_length (D : CompressedPatternData Unit) :
    (unitConstruction D).pps.path.length = 0 := by
  unfold unitConstruction
  rw [partitionConstruction_pps_length,unitPositive_card]
private theorem unitVps_length (D : CompressedPatternData Unit) :
    (unitConstruction D).vps.path.length = 0 := by
  have h := unitVpsGrowth (unitConstruction D).vps.path (unitConstruction D).vps.homogeneous
  rw [(unitPhase_cards D).1,(unitPhase_cards D).2.1] at h
  omega
private theorem unitPpm_length (D : CompressedPatternData Unit) :
    (unitConstruction D).ppm.path.length = 0 := by
  unfold unitConstruction
  rw [partitionConstruction_ppm_length,unitBlocks_card]
  simp
example (D : CompressedPatternData Unit) :
    (unitConstruction D).pps.path.length = 0 ∧
    (unitConstruction D).vps.path.length = 0 ∧
    (unitConstruction D).ppm.path.length = 0 :=
  ⟨unitPps_length D,unitVps_length D,unitPpm_length D⟩
example (D : CompressedPatternData Unit) (x : Unit) :
    (unitConstruction D).pps.endpoint.channel x
      ((unitConstruction D).pps.labels (unitPositive D)) = 1 := by
  rw [(unitConstruction D).pps.coordinates]
  norm_num
example (D : CompressedPatternData Unit) (x : Unit) :
    (unitConstruction D).ppm.endpoint.channel x
      ((unitConstruction D).ppm.labels (unitOccurring D)) = 1 := by
  rw [(unitConstruction D).ppm.coordinates,CompressedPatternData.channel_apply,unit_value]
  simp [unitOccurring,unitPattern]

-- C15-S01 / R02-R03: dual scalar constraints differ from primal upper bounds.
private theorem unit_dual_mulVec (D : CompressedPatternData Unit) (t : ℝ) :
    (reducedMatrix D)ᵀ *ᵥ (fun _ => t) = (fun _ => t) := by
  ext π
  simp only [Matrix.mulVec, dotProduct, Fintype.sum_unique, Matrix.transpose_apply]
  change fullMatrix (default : OccurringPattern D).val π.val * t = t
  rw [unitPattern_unique (default : OccurringPattern D).val,
    unitPartition_unique π.val]
  simp [fullMatrix, unitPattern, unitPartition, Finpartition.indiscrete]

private theorem unit_dual_feasible_iff (D : CompressedPatternData Unit) (t : ℝ) :
    Dual.Feasible D (fun _ => t) ↔ 1 ≤ t := by
  simp only [Dual.Feasible, unit_dual_mulVec]
  constructor
  · exact fun h => h.2 default
  · exact fun ht => ⟨fun _ => zero_le_one.trans ht, fun _ => ht⟩

private theorem unit_dual_objective (D : CompressedPatternData Unit) (t : ℝ) :
    Dual.objective D (fun _ => t) = t := by
  change (∑ p, D.value p * t) = t
  simp only [Fintype.sum_unique, unit_value, one_mul]

example (D : CompressedPatternData Unit) (t : ℝ) :
    Dual.Feasible D (fun _ => t) ↔ 1 ≤ t := unit_dual_feasible_iff D t

example (D : CompressedPatternData Unit) :
    Dual.Feasible D (fun _ => 1) ∧ Dual.objective D (fun _ => 1) = 1 :=
  ⟨(unit_dual_feasible_iff D 1).mpr le_rfl, unit_dual_objective D 1⟩

example (D : CompressedPatternData Unit) :
    Dual.Feasible D (fun _ => 2) ∧ 1 < Dual.objective D (fun _ => 2) := by
  refine ⟨(unit_dual_feasible_iff D 2).mpr (by norm_num), ?_⟩
  rw [unit_dual_objective]
  norm_num

example (D : CompressedPatternData Unit) : ¬ Dual.Feasible D (fun _ => 0) := by
  rw [unit_dual_feasible_iff]
  norm_num

-- Unequal objectives make the inequality's direction observable.
example (D : CompressedPatternData Unit) :
    Primal.objective D (fun _ => 1) ≤ Dual.objective D (fun _ => 2) ∧
      ¬ Dual.objective D (fun _ => 2) ≤ Primal.objective D (fun _ => 1) := by
  refine ⟨Dual.weak_duality D
    (unit_primal_feasible D 1 zero_le_one le_rfl)
    ((unit_dual_feasible_iff D 2).mpr (by norm_num)), ?_⟩
  rw [unit_dual_objective, unit_primal_objective]
  norm_num

example (D : CompressedPatternData Unit) :
    (1 : ℝ) ∈ Dual.objectiveValues D := Dual.one_mem_objectiveValues D

-- C15-S03 / R02: an actual attaining primal point proves every dual lower bound.
private theorem c15Unit_lower_bound (D : CompressedPatternData Unit)
    (y : OccurringPattern D → ℝ) (hy : Dual.Feasible D y) : 1 ≤ Dual.objective D y := by
  have h := Dual.weak_duality D (unit_primal_feasible D 1 zero_le_one le_rfl) hy
  simpa only [unit_primal_objective] using h

private theorem c15Unit_isLeast (D : CompressedPatternData Unit) :
    IsLeast (Dual.objectiveValues D) 1 := by
  refine ⟨Dual.one_mem_objectiveValues D, ?_⟩
  rintro r ⟨y, hy, rfl⟩
  exact c15Unit_lower_bound D y hy

example (D : CompressedPatternData Unit) :
    IsLeast (Dual.objectiveValues D) 1 ∧ IsPerfectlyRepresentableChannel D.channel ∧
    ∀ y, Dual.Feasible D y → 1 ≤ Dual.objective D y :=
  ⟨(Dual.isPerfectlyRepresentableChannel_iff_isLeast D).mp (unit_perfect D),
    (Dual.isPerfectlyRepresentableChannel_iff_isLeast D).mpr (c15Unit_isLeast D),
    c15Unit_lower_bound D⟩

-- R09's representable endpoint has an explicit zero-mass label and the same patterns.
example (D : CompressedPatternData Unit) :
    (∀ x, ((D.channel x).map some) none = 0) ∧
    none ∉ activeOutputs (fun x => (D.channel x).map some) ∧
    occurringPatterns (fun x => (D.channel x).map some) = D.patterns ∧
    compressedPatternData (fun x => (D.channel x).map some) (c15Option_singular D) = D ∧
    IsPerfectlyRepresentableChannel (fun x => (D.channel x).map some) ∧
    IsLeast (Dual.objectiveValues
      (compressedPatternData (fun x => (D.channel x).map some) (c15Option_singular D))) 1 := by
  have hp := (isPerfectlyRepresentableChannel_map_iff D.channel some
    (Option.some_injective _)).mpr (unit_perfect D)
  exact ⟨c15Option_zero D, c15Option_inactive D, c15Option_patterns D,
    c15Option_extraction D, hp,
    (Dual.isPerfectlyRepresentableChannel_iff_isLeast_compressedPatternData
      _ (c15Option_singular D)).mp hp⟩


-- C15-S04 / R09: the finite corollary on the actual representable injection.
example (D : CompressedPatternData Unit) {m n : ℕ}
    (rows : OccurringPattern (compressedPatternData (fun x => (D.channel x).map some)
      (c15Option_singular D)) ≃ Fin m)
    (cols : AdmissiblePartition (compressedPatternData (fun x => (D.channel x).map some)
      (c15Option_singular D)) ≃ Fin n) :
    IsLeast ((fun z : Fin m → ℝ =>
      ((compressedPatternData (fun x => (D.channel x).map some)
        (c15Option_singular D)).value ∘ rows.symm) ⬝ᵥ z) ''
      {z | (∀ i, 0 ≤ z i) ∧ ∀ j, 1 ≤ ((Matrix.reindex rows cols
        (reducedMatrix (compressedPatternData (fun x => (D.channel x).map some)
          (c15Option_singular D))))ᵀ *ᵥ z) j}) 1 ∧
      IsPerfectlyRepresentableChannel (fun x => (D.channel x).map some) := by
  have hp := (isPerfectlyRepresentableChannel_map_iff D.channel some
    (Option.some_injective _)).mpr (unit_perfect D)
  have hl := (Dual.isPerfectlyRepresentableChannel_iff_isLeast_compressedPatternData_reindex
    _ (c15Option_singular D) rows cols).mp hp
  exact ⟨hl, (Dual.isPerfectlyRepresentableChannel_iff_isLeast_compressedPatternData_reindex
    _ (c15Option_singular D) rows cols).mpr hl⟩

end SingletonFixture


-- R01/R03: valid data may have no admissible exact partition.
-- This datum isolates S01's type boundary; the C03 channel bridge is S02/S05 work.
namespace EmptyFixture

local instance : DecidableEq (Fin 3) := fun a b => Classical.propDecidable (a = b)
local instance : DecidableEq Unit := fun a b => Classical.propDecidable (a = b)

private abbrev Pat (α : Type*) := NonzeroPattern α
attribute [local simp] Fin.ext_iff
private def p01 : Pat (Fin 3) := ⟨{0,1}, by simp⟩
private def p02 : Pat (Fin 3) := ⟨{0,2}, by simp⟩
private def p12 : Pat (Fin 3) := ⟨{1,2}, by simp⟩
private def pairs : Finset (Pat (Fin 3)) := {p01,p02,p12}

private theorem p01_ne_p02 : p01 ≠ p02 := by
  intro h
  have he := congrArg (fun p : Pat (Fin 3) => (1 : Fin 3) ∈ p.val) h
  norm_num [p01, p02, Fin.ext_iff] at he

private theorem p01_ne_p12 : p01 ≠ p12 := by
  intro h
  have he := congrArg (fun p : Pat (Fin 3) => (0 : Fin 3) ∈ p.val) h
  norm_num [p01, p12, Fin.ext_iff] at he

private theorem p02_ne_p12 : p02 ≠ p12 := by
  intro h
  have he := congrArg (fun p : Pat (Fin 3) => (0 : Fin 3) ∈ p.val) h
  norm_num [p02, p12, Fin.ext_iff] at he

private theorem pairSum (f : Pat (Fin 3) → ℝ) :
    (∑ p ∈ pairs, f p) = f p01 + f p02 + f p12 := by
  simp [pairs, p01_ne_p02, p01_ne_p12, p02_ne_p12, Finset.sum_insert, add_assoc]
private def pairData : CompressedPatternData (Fin 3) where
  patterns := pairs
  value := fun _ => 1 / 2
  value_pos := fun _ => by norm_num
  row_sum := by
    intro x
    rw [Finset.sum_coe_sort pairs (fun p : Pat (Fin 3) => if x ∈ p.val then (1 / 2 : ℝ) else 0)]
    rw [pairSum]
    fin_cases x <;> norm_num [p01, p02, p12, Fin.ext_iff]

private theorem pairMember (b : Finset (Fin 3)) (hb : b.Nonempty)
    (h : (⟨b, hb⟩ : Pat (Fin 3)) ∈ pairData.patterns) :
    b = {0,1} ∨ b = {0,2} ∨ b = {1,2} := by
  simpa [pairData, pairs, p01, p02, p12, Subtype.ext_iff] using h

private theorem noPartition (π : Finpartition (Finset.univ : Finset (Fin 3)))
    (hπ : IsAdmissible pairData π) : False := by
  obtain ⟨b,hb,h0⟩ := π.exists_mem (Finset.mem_univ (0 : Fin 3))
  have hbb := pairMember b (π.nonempty_of_mem_parts hb) (hπ ⟨b,hb⟩)
  obtain ⟨c,hc,h2⟩ := π.exists_mem (Finset.mem_univ (2 : Fin 3))
  have hcc := pairMember c (π.nonempty_of_mem_parts hc) (hπ ⟨c,hc⟩)
  rcases hbb with rfl | rfl | rfl
  · rcases hcc with rfl | rfl | rfl
    · simp at h2
    · have he := π.eq_of_mem_parts hb hc (a := 0) (by simp) (by simp)
      have := congrArg (fun t : Finset (Fin 3) => (1 : Fin 3) ∈ t) he
      simp at this
    · have he := π.eq_of_mem_parts hb hc (a := 1) (by simp) (by simp)
      have := congrArg (fun t : Finset (Fin 3) => (0 : Fin 3) ∈ t) he
      simp at this
  · obtain ⟨d,hd,h1⟩ := π.exists_mem (Finset.mem_univ (1 : Fin 3))
    have hdd := pairMember d (π.nonempty_of_mem_parts hd) (hπ ⟨d,hd⟩)
    rcases hdd with rfl | rfl | rfl
    · have he := π.eq_of_mem_parts hb hd (a := 0) (by simp) (by simp)
      have := congrArg (fun t : Finset (Fin 3) => (2 : Fin 3) ∈ t) he
      simp at this
    · simp at h1
    · have he := π.eq_of_mem_parts hb hd (a := 2) (by simp) (by simp)
      have := congrArg (fun t : Finset (Fin 3) => (0 : Fin 3) ∈ t) he
      simp at this
  · simp at h0

local instance : IsEmpty (AdmissiblePartition pairData) :=
  ⟨fun π => noPartition π.val π.property⟩

example : Fintype.card (AdmissiblePartition pairData) = 0 := by simp

-- C15-S01 / R04: empty columns make the zero dual feasible, but not least at one.
example : Dual.Feasible pairData (fun _ => 0) ∧
    Dual.objective pairData (fun _ => 0) = 0 :=
  ⟨Dual.feasible_zero_of_isEmpty pairData, Dual.objective_zero pairData⟩

example : (0 : ℝ) ∈ Dual.objectiveValues pairData :=
  ⟨fun _ => 0, Dual.feasible_zero_of_isEmpty pairData, Dual.objective_zero pairData⟩

example : (1 : ℝ) ∈ Dual.objectiveValues pairData :=
  Dual.one_mem_objectiveValues pairData

example : ¬ IsLeast (Dual.objectiveValues pairData) 1 := by
  intro h
  have hz : (0 : ℝ) ∈ Dual.objectiveValues pairData :=
    ⟨fun _ => 0, Dual.feasible_zero_of_isEmpty pairData, Dual.objective_zero pairData⟩
  have hle := h.2 hz
  norm_num at hle

example (i : Fin 3) : Dual.Feasible pairData (Dual.rowWitness pairData i) ∧
    Dual.objective pairData (Dual.rowWitness pairData i) = 1 :=
  ⟨Dual.feasible_rowWitness pairData i, Dual.objective_rowWitness pairData i⟩

-- C15-S02 / R04: the public alternative also covers these empty columns.
example : ∃ y, Dual.Feasible pairData y ∧ Dual.objective pairData y < 1 := by
  apply Dual.exists_feasible_objective_lt_one_of_not_perfect pairData
  intro hD
  obtain ⟨x, hx⟩ :=
    (isPerfectlyRepresentableChannel_iff_exists_feasible pairData).mp hD
  exact not_reduced_eq_of_isEmpty pairData x hx.2

private def emptyPresentation : AdmissiblePartition pairData ≃ Fin 0 :=
  Equiv.equivOfIsEmpty _ _

example : Matrix (Incidence.OccurringPattern pairData) (Fin 0) ℝ :=
  Matrix.reindex (Equiv.refl _) emptyPresentation (reducedMatrix pairData)

example : Fintype.card (Incidence.OccurringPattern pairData) = 3 := by
  change Fintype.card ↥pairs = 3
  rw [Fintype.card_coe]
  simp [pairs, p01_ne_p02, p01_ne_p12, p02_ne_p12]


private def wholePattern : NonzeroPattern (Fin 3) := ⟨Finset.univ, Finset.univ_nonempty⟩

example : fullValue pairData wholePattern = 0 := by
  apply fullValue_of_not_mem
  intro h
  have hp := pairMember wholePattern.val wholePattern.property h
  rcases hp with h | h | h
  · have hx := congrArg (fun s : Finset (Fin 3) => (2 : Fin 3) ∈ s) h
    simp [wholePattern] at hx
  · have hx := congrArg (fun s : Finset (Fin 3) => (1 : Fin 3) ∈ s) h
    simp [wholePattern] at hx
  · have hx := congrArg (fun s : Finset (Fin 3) => (0 : Fin 3) ∈ s) h
    simp [wholePattern] at hx

example : fullMatrix wholePattern (Finpartition.indiscrete Finset.univ_nonempty.ne_empty) = 1 := by
  simp [fullMatrix, wholePattern, Finpartition.indiscrete]

-- R03/R11: empty reduced columns cannot solve the equality, including at Fin 0.
example (w : AdmissiblePartition pairData → ℝ) :
    ¬ Feasible pairData w := fun hw => not_reduced_eq_of_isEmpty pairData w hw.2

example : ¬ ∃ w, FullFeasible pairData w := by
  rw [exists_fullFeasible_iff]
  rintro ⟨w, hw⟩
  exact not_reduced_eq_of_isEmpty pairData w hw.2

example (rows : OccurringPattern pairData ≃ Fin 3) (w : AdmissiblePartition pairData → ℝ) :
    ¬ ((∀ j, 0 ≤ (w ∘ emptyPresentation.symm) j) ∧
      Matrix.reindex rows emptyPresentation (reducedMatrix pairData) *ᵥ
        (w ∘ emptyPresentation.symm) = pairData.value ∘ rows.symm) := by
  rw [system_reindex_iff]
  exact fun hw => not_reduced_eq_of_isEmpty pairData w hw.2

-- C14-S01 / R04: the empty partition family has exactly the objective value zero.
private theorem pair_primal_objective (w : AdmissiblePartition pairData → ℝ) :
    Primal.objective pairData w = 0 := by
  simp [Primal.objective]

private theorem pair_primal_values : Primal.objectiveValues pairData = {0} := by
  ext r
  constructor
  · rintro ⟨w, _, rfl⟩
    exact Set.mem_singleton_iff.mpr (pair_primal_objective w)
  · intro hr
    have hr0 : r = 0 := Set.mem_singleton_iff.mp hr
    subst r
    exact ⟨fun _ => 0, Primal.feasible_zero pairData, Primal.objective_zero pairData⟩

example (w : AdmissiblePartition pairData → ℝ) :
    Primal.objective pairData w = 0 := pair_primal_objective w

example : Primal.objectiveValues pairData = {0} := pair_primal_values

example : IsGreatest (Primal.objectiveValues pairData) 0 := by
  rw [pair_primal_values]
  refine ⟨by simp, ?_⟩
  intro r hr
  have hr0 : r = 0 := Set.mem_singleton_iff.mp hr
  exact hr0.le

example : ¬ IsGreatest (Primal.objectiveValues pairData) 1 := by
  intro h
  have hm := h.1
  rw [pair_primal_values] at hm
  norm_num at hm

example : ¬ ∃ w, Primal.Feasible pairData w ∧ Primal.objective pairData w = 1 := by
  rintro ⟨w, _, hw⟩
  rw [pair_primal_objective w] at hw
  norm_num at hw

-- C14-S02 / R04: both new characterization directions detect this nonperfect datum.
example : ¬ IsPerfectlyRepresentableChannel pairData.channel := by
  intro h
  rcases (Primal.isPerfectlyRepresentableChannel_iff_exists_objective_eq_one pairData).mp h
    with ⟨w, _, hw⟩
  rw [pair_primal_objective w] at hw
  norm_num at hw

example : ¬ IsPerfectlyRepresentableChannel pairData.channel := by
  intro h
  have hm := ((Primal.isPerfectlyRepresentableChannel_iff_isGreatest pairData).mp h).1
  rw [pair_primal_values] at hm
  norm_num at hm


-- C15-S03 / R04: zero disproves leastness despite every value-one row witness.
private theorem c15Pair_notLeast : ¬ IsLeast (Dual.objectiveValues pairData) 1 := by
  intro hl
  have hz := hl.2 ⟨fun _ => 0, Dual.feasible_zero_of_isEmpty pairData,
    Dual.objective_zero pairData⟩
  norm_num at hz

private theorem c15Pair_nonperfect : ¬ IsPerfectlyRepresentableChannel pairData.channel := by
  intro hp
  exact c15Pair_notLeast ((Dual.isPerfectlyRepresentableChannel_iff_isLeast pairData).mp hp)

example : Fintype.card (AdmissiblePartition pairData) = 0 ∧
    ¬ IsPerfectlyRepresentableChannel pairData.channel ∧
    ¬ IsLeast (Dual.objectiveValues pairData) 1 ∧
    ∀ i : Fin 3, Dual.Feasible pairData (Dual.rowWitness pairData i) ∧
      Dual.objective pairData (Dual.rowWitness pairData i) = 1 := by
  refine ⟨by simp, c15Pair_nonperfect, c15Pair_notLeast, ?_⟩
  exact fun i => ⟨Dual.feasible_rowWitness pairData i, Dual.objective_rowWitness pairData i⟩

-- R09's nonperfect Option endpoint consumes the reverse ambient implication.
example : (∀ x, ((pairData.channel x).map some) none = 0) ∧
    none ∉ activeOutputs (fun x => (pairData.channel x).map some) ∧
    occurringPatterns (fun x => (pairData.channel x).map some) = pairData.patterns ∧
    compressedPatternData (fun x => (pairData.channel x).map some)
      (c15Option_singular pairData) = pairData ∧
    ¬ IsPerfectlyRepresentableChannel (fun x => (pairData.channel x).map some) ∧
    ¬ IsLeast (Dual.objectiveValues
      (compressedPatternData (fun x => (pairData.channel x).map some)
        (c15Option_singular pairData))) 1 := by
  have hn : ¬ IsPerfectlyRepresentableChannel (fun x => (pairData.channel x).map some) :=
    fun hp => c15Pair_nonperfect ((isPerfectlyRepresentableChannel_map_iff
      pairData.channel some (Option.some_injective _)).mp hp)
  refine ⟨c15Option_zero pairData, c15Option_inactive pairData, c15Option_patterns pairData,
    c15Option_extraction pairData, hn, ?_⟩
  exact fun hl => hn ((Dual.isPerfectlyRepresentableChannel_iff_isLeast_compressedPatternData
    _ (c15Option_singular pairData)).mpr hl)

private def c15PairActive0 : activeOutputs (fun x => (pairData.channel x).map some) :=
  activeOutputsMapEquiv pairData.channel some (Option.some_injective _)
    ⟨⟨p01, by simp [pairData, pairs]⟩, pairData.channel_active _⟩
private def c15PairActive1 : activeOutputs (fun x => (pairData.channel x).map some) :=
  activeOutputsMapEquiv pairData.channel some (Option.some_injective _)
    ⟨⟨p02, by simp [pairData, pairs]⟩, pairData.channel_active _⟩

private def c15PairEnumeration :=
  Finite.equivFin (activeOutputs (fun x => (pairData.channel x).map some))
private def c15PairChangedEnumeration :=
  (Equiv.swap c15PairActive0 c15PairActive1).trans c15PairEnumeration

-- The two supplied presentations genuinely exchange distinct active output labels.
example : c15PairActive0 ≠ c15PairActive1 ∧
    c15PairChangedEnumeration c15PairActive0 = c15PairEnumeration c15PairActive1 ∧
    c15PairChangedEnumeration c15PairActive0 ≠ c15PairEnumeration c15PairActive0 := by
  have hn : c15PairActive0 ≠ c15PairActive1 := by
    intro h
    have he := (activeOutputsMapEquiv pairData.channel some
      (Option.some_injective _)).injective h
    exact p01_ne_p02 (congrArg (fun p : activeOutputs pairData.channel => p.val.val) he)
  refine ⟨hn, ?_, ?_⟩
  · rw [c15PairChangedEnumeration, Equiv.trans_apply, Equiv.swap_apply_left]
  · simpa only [c15PairChangedEnumeration, Equiv.trans_apply, Equiv.swap_apply_left]
      using fun h => hn (c15PairEnumeration.injective h).symm

example : ∃ hS : IsSingularChannel
      (ActiveFiniteChannel.ofChannelWithEquiv
        (fun x => (pairData.channel x).map some) c15PairEnumeration).channel,
    ∃ hT : IsSingularChannel
      (ActiveFiniteChannel.ofChannelWithEquiv
        (fun x => (pairData.channel x).map some) c15PairChangedEnumeration).channel,
      (∀ x, ((ActiveFiniteChannel.ofChannelWithEquiv
        (fun x => (pairData.channel x).map some) c15PairEnumeration).channel x).map
        (c15PairEnumeration.symm.trans c15PairChangedEnumeration) =
          (ActiveFiniteChannel.ofChannelWithEquiv
            (fun x => (pairData.channel x).map some) c15PairChangedEnumeration).channel x) ∧
      compressedPatternData (ActiveFiniteChannel.ofChannelWithEquiv
        (fun x => (pairData.channel x).map some) c15PairEnumeration).channel hS = pairData ∧
      compressedPatternData (ActiveFiniteChannel.ofChannelWithEquiv
        (fun x => (pairData.channel x).map some) c15PairChangedEnumeration).channel hT = pairData ∧
      ¬ IsLeast (Dual.objectiveValues (compressedPatternData
        (ActiveFiniteChannel.ofChannelWithEquiv
          (fun x => (pairData.channel x).map some) c15PairEnumeration).channel hS)) 1 ∧
      ¬ IsLeast (Dual.objectiveValues (compressedPatternData
        (ActiveFiniteChannel.ofChannelWithEquiv
          (fun x => (pairData.channel x).map some) c15PairChangedEnumeration).channel hT)) 1 := by
  let κ := fun x => (pairData.channel x).map some
  have hκ := c15Option_singular pairData
  have hS := (ActiveFiniteChannel.isSingularChannel_ofChannelWithEquiv_iff
    κ c15PairEnumeration).mpr hκ
  have hT := (ActiveFiniteChannel.isSingularChannel_ofChannelWithEquiv_iff
    κ c15PairChangedEnumeration).mpr hκ
  have hdS := (compressedPatternData_ofChannelWithEquiv κ c15PairEnumeration hκ hS).trans
    (c15Option_extraction pairData)
  have hdT := (compressedPatternData_ofChannelWithEquiv κ c15PairChangedEnumeration hκ hT).trans
    (c15Option_extraction pairData)
  refine ⟨hS, hT, ActiveFiniteChannel.ofChannelWithEquiv_compare κ
    c15PairEnumeration c15PairChangedEnumeration, hdS, hdT, ?_, ?_⟩
  · intro hl
    have hp := (Dual.isPerfectlyRepresentableChannel_iff_isLeast_compressedPatternData _ hS).mpr hl
    have hη := (ActiveFiniteChannel.isPerfectlyRepresentableChannel_ofChannelWithEquiv_iff
      κ c15PairEnumeration).mp hp
    exact c15Pair_nonperfect ((isPerfectlyRepresentableChannel_map_iff
      pairData.channel some (Option.some_injective _)).mp hη)
  · intro hl
    have hp := (Dual.isPerfectlyRepresentableChannel_iff_isLeast_compressedPatternData _ hT).mpr hl
    have hη := (ActiveFiniteChannel.isPerfectlyRepresentableChannel_ofChannelWithEquiv_iff
      κ c15PairChangedEnumeration).mp hp
    exact c15Pair_nonperfect ((isPerfectlyRepresentableChannel_map_iff
      pairData.channel some (Option.some_injective _)).mp hη)

-- C14-S03 / R10: the reverse ambient direction detects the nonperfect endpoint.
example : ¬ IsGreatest (Primal.objectiveValues
    (compressedPatternData pairData.channel pairData.channel_singular)) 1 := by
  intro hg
  have hp := (Primal.isPerfectlyRepresentableChannel_iff_isGreatest_compressedPatternData
    pairData.channel pairData.channel_singular).mpr hg
  have hm := ((Primal.isPerfectlyRepresentableChannel_iff_isGreatest pairData).mp hp).1
  rw [pair_primal_values] at hm
  norm_num at hm

-- Fin 0 has no coefficient coordinates; the entire transported image is still {0}.
private def emptyFiniteValues (rows : OccurringPattern pairData ≃ Fin 3) : Set ℝ :=
  (fun z : Fin 0 → ℝ => ∑ j, z j) ''
    {z | (∀ j, 0 ≤ z j) ∧
      ∀ i, (Matrix.reindex rows emptyPresentation (reducedMatrix pairData) *ᵥ z) i ≤
        (pairData.value ∘ rows.symm) i}

example (rows : OccurringPattern pairData ≃ Fin 3) :
    emptyFiniteValues rows = {0} :=
  (Primal.objectiveValues_reindex pairData rows emptyPresentation).trans pair_primal_values

example (rows : OccurringPattern pairData ≃ Fin 3) :
    0 ∈ emptyFiniteValues rows := by
  change 0 ∈ (fun z : Fin 0 → ℝ => ∑ j, z j) '' _
  rw [Primal.objectiveValues_reindex, pair_primal_values]
  exact Set.mem_singleton 0

example (rows : OccurringPattern pairData ≃ Fin 3) (r : ℝ)
    (hr : r ∈ emptyFiniteValues rows) : r = 0 := by
  change r ∈ (fun z : Fin 0 → ℝ => ∑ j, z j) '' _ at hr
  rw [Primal.objectiveValues_reindex, pair_primal_values] at hr
  exact Set.mem_singleton_iff.mp hr

example (rows : OccurringPattern pairData ≃ Fin 3) :
    (∀ j, 0 ≤ ((fun _ => (0 : ℝ)) ∘ emptyPresentation.symm) j) ∧
      ∀ i, (Matrix.reindex rows emptyPresentation (reducedMatrix pairData) *ᵥ
        ((fun _ => 0) ∘ emptyPresentation.symm)) i ≤ (pairData.value ∘ rows.symm) i :=
  (Primal.feasible_reindex_iff pairData (fun _ => 0) rows emptyPresentation).mp
    (Primal.feasible_zero pairData)

-- C15-S04 / R04: Fin 0 contains constraints, while all three dual variables remain.
private def c15EmptyDualValues (rows : OccurringPattern pairData ≃ Fin 3) : Set ℝ :=
  (fun z : Fin 3 → ℝ => (pairData.value ∘ rows.symm) ⬝ᵥ z) ''
    {z | (∀ i, 0 ≤ z i) ∧ ∀ j,
      1 ≤ ((Matrix.reindex rows emptyPresentation (reducedMatrix pairData))ᵀ *ᵥ z) j}

example (rows : OccurringPattern pairData ≃ Fin 3) (z : Fin 3 → ℝ) :
    ((∀ i, 0 ≤ z i) ∧ ∀ j : Fin 0,
      1 ≤ ((Matrix.reindex rows emptyPresentation (reducedMatrix pairData))ᵀ *ᵥ z) j) ↔
      ∀ i, 0 ≤ z i := by
  exact ⟨And.left, fun hz => ⟨hz, fun j => Fin.elim0 j⟩⟩

example (rows : OccurringPattern pairData ≃ Fin 3) (z : Fin 3 → ℝ) :
    (Dual.Feasible pairData (z ∘ rows) ↔ ∀ i, 0 ≤ z i) ∧
    (pairData.value ∘ rows.symm) ⬝ᵥ z = Dual.objective pairData (z ∘ rows) ∧
    (z ∘ rows) ∘ rows.symm = z := by
  have hr : (z ∘ rows) ∘ rows.symm = z := by
    ext i
    simp only [Function.comp_apply, Equiv.apply_symm_apply]
  refine ⟨?_, ?_, hr⟩
  · rw [Dual.feasible_reindex_iff pairData (z ∘ rows) rows emptyPresentation, hr]
    exact ⟨And.left, fun hz => ⟨hz, fun j => Fin.elim0 j⟩⟩
  · simpa only [hr] using Dual.objective_reindex pairData (z ∘ rows) rows

example (rows : OccurringPattern pairData ≃ Fin 3) :
    c15EmptyDualValues rows = Dual.objectiveValues pairData :=
  Dual.objectiveValues_reindex pairData rows emptyPresentation

example (rows : OccurringPattern pairData ≃ Fin 3) :
    0 ∈ c15EmptyDualValues rows ∧ 1 ∈ c15EmptyDualValues rows ∧
    ¬ IsLeast (c15EmptyDualValues rows) 1 := by
  have hi : c15EmptyDualValues rows = Dual.objectiveValues pairData :=
    Dual.objectiveValues_reindex pairData rows emptyPresentation
  rw [hi]
  exact ⟨⟨fun _ => 0, Dual.feasible_zero_of_isEmpty pairData,
    Dual.objective_zero pairData⟩, Dual.one_mem_objectiveValues pairData, c15Pair_notLeast⟩

example (rows : OccurringPattern pairData ≃ Fin 3) :
    ¬ IsLeast (c15EmptyDualValues rows) 1 ∧ ¬ IsPerfectlyRepresentableChannel pairData.channel := by
  have hn : ¬ IsLeast (c15EmptyDualValues rows) 1 := fun hl =>
    c15Pair_nonperfect ((Dual.isPerfectlyRepresentableChannel_iff_isLeast_reindex
      pairData rows emptyPresentation).mpr hl)
  exact ⟨hn, fun hp => hn ((Dual.isPerfectlyRepresentableChannel_iff_isLeast_reindex
    pairData rows emptyPresentation).mp hp)⟩

-- R09/R10: canonical finite coordinates for the nonperfect Option injection.
example : let κ := fun x => (pairData.channel x).map some
    let hκ := c15Option_singular pairData
    let D := compressedPatternData κ hκ
    let rows := Fintype.equivFin (OccurringPattern D)
    let cols := Fintype.equivFin (AdmissiblePartition D)
    Fintype.card (OccurringPattern D) = 3 ∧ Fintype.card (AdmissiblePartition D) = 0 ∧
    ¬ IsLeast ((fun z : Fin (Fintype.card (OccurringPattern D)) → ℝ =>
      (D.value ∘ rows.symm) ⬝ᵥ z) ''
      {z | (∀ i, 0 ≤ z i) ∧ ∀ j,
        1 ≤ ((Matrix.reindex rows cols (reducedMatrix D))ᵀ *ᵥ z) j}) 1 := by
  dsimp only
  have hc : Fintype.card (OccurringPattern pairData) = 3 := by
    change Fintype.card ↥pairs = 3
    rw [Fintype.card_coe]
    simp [pairs, p01_ne_p02, p01_ne_p12, p02_ne_p12]
  refine ⟨by rw [c15Option_extraction]; exact hc,
    by rw [c15Option_extraction]; simp, ?_⟩
  intro hl
  have hp := (Dual.isPerfectlyRepresentableChannel_iff_isLeast_compressedPatternData_reindex
    _ (c15Option_singular pairData) (Fintype.equivFin _) (Fintype.equivFin _)).mpr hl
  exact c15Pair_nonperfect ((isPerfectlyRepresentableChannel_map_iff
    pairData.channel some (Option.some_injective _)).mp hp)

-- These finite images belong to the two already supplied active presentations.
private def c15PresentedPairDualValues
    (e : activeOutputs (fun x => (pairData.channel x).map some) ≃
      Fin (Nat.card (activeOutputs (fun x => (pairData.channel x).map some))))
    (h : IsSingularChannel (ActiveFiniteChannel.ofChannelWithEquiv
      (fun x => (pairData.channel x).map some) e).channel) : Set ℝ :=
  let D := compressedPatternData (ActiveFiniteChannel.ofChannelWithEquiv
    (fun x => (pairData.channel x).map some) e).channel h
  let rows := Fintype.equivFin (OccurringPattern D)
  let cols := Fintype.equivFin (AdmissiblePartition D)
  (fun z : Fin (Fintype.card (OccurringPattern D)) → ℝ => (D.value ∘ rows.symm) ⬝ᵥ z) ''
    {z | (∀ i, 0 ≤ z i) ∧ ∀ j,
      1 ≤ ((Matrix.reindex rows cols (reducedMatrix D))ᵀ *ᵥ z) j}

example : ∃ hS : IsSingularChannel (ActiveFiniteChannel.ofChannelWithEquiv
      (fun x => (pairData.channel x).map some) c15PairEnumeration).channel,
    ∃ hT : IsSingularChannel (ActiveFiniteChannel.ofChannelWithEquiv
      (fun x => (pairData.channel x).map some) c15PairChangedEnumeration).channel,
    c15PresentedPairDualValues c15PairEnumeration hS =
      c15PresentedPairDualValues c15PairChangedEnumeration hT ∧
    ¬ IsLeast (c15PresentedPairDualValues c15PairEnumeration hS) 1 ∧
    ¬ IsLeast (c15PresentedPairDualValues c15PairChangedEnumeration hT) 1 := by
  let κ := fun x => (pairData.channel x).map some
  have hκ := c15Option_singular pairData
  have hS := (ActiveFiniteChannel.isSingularChannel_ofChannelWithEquiv_iff
    κ c15PairEnumeration).mpr hκ
  have hT := (ActiveFiniteChannel.isSingularChannel_ofChannelWithEquiv_iff
    κ c15PairChangedEnumeration).mpr hκ
  have hdS := (compressedPatternData_ofChannelWithEquiv κ c15PairEnumeration hκ hS).trans
    (c15Option_extraction pairData)
  have hdT := (compressedPatternData_ofChannelWithEquiv κ c15PairChangedEnumeration hκ hT).trans
    (c15Option_extraction pairData)
  have hi (e) (h) : c15PresentedPairDualValues e h = Dual.objectiveValues
      (compressedPatternData (ActiveFiniteChannel.ofChannelWithEquiv κ e).channel h) :=
    Dual.objectiveValues_reindex _ (Fintype.equivFin _) (Fintype.equivFin _)
  refine ⟨hS, hT, ?_, ?_, ?_⟩
  · rw [hi, hi, hdS, hdT]
  · intro hl
    have hp := (Dual.isPerfectlyRepresentableChannel_iff_isLeast_compressedPatternData_reindex
      _ hS (Fintype.equivFin _) (Fintype.equivFin _)).mpr hl
    have hη := (ActiveFiniteChannel.isPerfectlyRepresentableChannel_ofChannelWithEquiv_iff
      κ c15PairEnumeration).mp hp
    exact c15Pair_nonperfect ((isPerfectlyRepresentableChannel_map_iff
      pairData.channel some (Option.some_injective _)).mp hη)
  · intro hl
    have hp := (Dual.isPerfectlyRepresentableChannel_iff_isLeast_compressedPatternData_reindex
      _ hT (Fintype.equivFin _) (Fintype.equivFin _)).mpr hl
    have hη := (ActiveFiniteChannel.isPerfectlyRepresentableChannel_ofChannelWithEquiv_iff
      κ c15PairChangedEnumeration).mp hp
    exact c15Pair_nonperfect ((isPerfectlyRepresentableChannel_map_iff
      pairData.channel some (Option.some_injective _)).mp hη)

end EmptyFixture

end

end PerfectFunctionalRepresentations.Incidence.Tests

namespace PerfectFunctionalRepresentations.Incidence.Tests.S02Generic

open scoped BigOperators Matrix
noncomputable section
attribute [local instance] Classical.propDecidable

section Data
variable {α : Type*} [Fintype α] [Nonempty α] (D : CompressedPatternData α)

-- Structural equations require valid data alone; admissible columns may be absent.
example : inputMatrix D *ᵥ D.value = (fun _ => 1) ∧
    inputMatrix D * reducedMatrix D = (fun _ _ => 1) ∧
    fullInputMatrix *ᵥ fullValue D = (fun _ => 1) ∧
    (fullInputMatrix : Matrix α (NonzeroPattern α) ℝ) *
      (fullMatrix : Matrix (NonzeroPattern α) (ExactPartition α) ℝ) = (fun _ _ => 1) :=
  ⟨inputMatrix_mulVec_value D, inputMatrix_mul_reducedMatrix D,
    fullInputMatrix_mulVec_fullValue D, fullInputMatrix_mul_fullMatrix⟩

-- Normalization retains signed equality solutions: no nonnegativity premise.
example (w : AdmissiblePartition D → ℝ) (he : reducedMatrix D *ᵥ w = D.value) :
    ∑ π, w π = 1 := sum_eq_one_of_reduced_eq D w he

example (w : ExactPartition α → ℝ) (he : fullMatrix *ᵥ w = fullValue D) :
    ∑ π, w π = 1 := sum_eq_one_of_full_eq D w he

-- The named predicates elaborate through arbitrary independent enumerations.
example {m r : ℕ} (rows : OccurringPattern D ≃ Fin m)
    (cols : AdmissiblePartition D ≃ Fin r) (w : AdmissiblePartition D → ℝ) :
    ((∀ j, 0 ≤ (w ∘ cols.symm) j) ∧
      Matrix.reindex rows cols (reducedMatrix D) *ᵥ (w ∘ cols.symm) =
        D.value ∘ rows.symm) ↔ Feasible D w :=
  system_reindex_iff (reducedMatrix D) D.value w rows cols

example {m r : ℕ} (rows : NonzeroPattern α ≃ Fin m)
    (cols : ExactPartition α ≃ Fin r) (w : ExactPartition α → ℝ) :
    ((∀ j, 0 ≤ (w ∘ cols.symm) j) ∧
      Matrix.reindex rows cols fullMatrix *ᵥ (w ∘ cols.symm) =
        fullValue D ∘ rows.symm) ↔ FullFeasible D w :=
  system_reindex_iff fullMatrix (fullValue D) w rows cols

-- Both maps act on the supplied vector, with the appropriate inverse hypothesis.
example (w : AdmissiblePartition D → ℝ) (hw : Feasible D w) :
    FullFeasible D (extendWeights D w) ∧ restrictWeights D (extendWeights D w) = w :=
  ⟨fullFeasible_extendWeights D hw, restrict_extendWeights D w⟩

example (w : ExactPartition α → ℝ) (hw : FullFeasible D w) :
    Feasible D (restrictWeights D w) ∧ extendWeights D (restrictWeights D w) = w :=
  ⟨feasible_restrictWeights D hw, extend_restrictWeights D hw⟩

example (w : ExactPartition α → ℝ) (hw : FullFeasible D w)
    (π : ExactPartition α) (hπ : ¬ IsAdmissible D π) : w π = 0 :=
  full_weight_eq_zero_of_not_admissible D hw π hπ

example : (∃ w, FullFeasible D w) ↔ ∃ w, Feasible D w := exists_fullFeasible_iff D

-- A supplied block gives the sharper value bound as well as the unit bound.
example (w : AdmissiblePartition D → ℝ) (hw : Feasible D w)
    (p : OccurringPattern D) (π : AdmissiblePartition D) (hp : p.val.val ∈ π.val.parts) :
    0 ≤ w π ∧ w π ≤ D.value p ∧ w π ≤ 1 :=
  ⟨hw.1 π, reduced_weight_le_value D w hw.1 hw.2 p π hp,
    reduced_weight_le_one D w hw.1 hw.2 π⟩

example (w : ExactPartition α → ℝ) (hw : FullFeasible D w)
    (p : NonzeroPattern α) (π : ExactPartition α) (hp : p.val ∈ π.parts) :
    0 ≤ w π ∧ w π ≤ fullValue D p ∧ w π ≤ 1 :=
  ⟨hw.1 π, full_weight_le_value D w hw.1 hw.2 p π hp,
    full_weight_le_one D w hw.1 hw.2 π⟩

example (w : AdmissiblePartition D → ℝ) :
    ((∀ π, w π ∈ Set.Icc 0 1) ∧ reducedMatrix D *ᵥ w = D.value) ↔ Feasible D w :=
  reduced_unit_iff D w

example (w : ExactPartition α → ℝ) :
    ((∀ π, w π ∈ Set.Icc 0 1) ∧ fullMatrix *ᵥ w = fullValue D) ↔ FullFeasible D w :=
  full_unit_iff D w

-- Positive support is obtained from the same supplied feasible coefficients.
example (w : AdmissiblePartition D → ℝ) (hw : Feasible D w) :
    Nonempty (PositivePartition D w) ∧
      (∑ π : PositivePartition D w, w π.val) = 1 ∧
      ∀ p : OccurringPattern D,
        (∑ π : PositivePartition D w, reducedMatrix D p π.val * w π.val) = D.value p :=
  ⟨nonempty_positivePartition D hw, sum_positive_weights D hw,
    positive_incidence_sum D hw⟩

-- The dependent block-label map supplies an actual positive contributing partition.
example (w : AdmissiblePartition D → ℝ) (hw : Feasible D w) (p : OccurringPattern D) :
    ∃ π : AdmissiblePartition D, 0 < w π ∧ p.val.val ∈ π.val.parts := by
  obtain ⟨⟨π, b⟩, hb⟩ := positiveBlockPattern_surjective D hw p
  refine ⟨π.val, π.property, ?_⟩
  have he : b.val = p.val.val := congrArg (fun q : OccurringPattern D => q.val.val) hb
  exact he ▸ b.property

-- C10 consumes these exact coefficients; no normalized family is supplied separately.
private def coefficientNNReal (w : AdmissiblePartition D → ℝ)
    (hw : Feasible D w) : AdmissiblePartition D → NNReal := fun π => ⟨w π, hw.1 π⟩

private theorem coefficientNNReal_sum (w : AdmissiblePartition D → ℝ)
    (hw : Feasible D w) : ∑ π, coefficientNNReal D w hw π = 1 := by
  apply NNReal.coe_injective
  rw [NNReal.coe_sum]
  exact sum_eq_one_of_reduced_eq D w hw.2

private def coefficientPositiveEquiv (w : AdmissiblePartition D → ℝ)
    (hw : Feasible D w) : PositivePartition D w ≃
      {π : AdmissiblePartition D // 0 < coefficientNNReal D w hw π} :=
  Equiv.subtypeEquivRight fun _ => Iff.rfl

private def coefficientPps (w : AdmissiblePartition D → ℝ) (hw : Feasible D w) :=
  MatrixOperations.multiPpsOfNonnegative (ActiveFiniteChannel.allOnes α)
    (ActiveFiniteChannel.allOnes_isSingular α) (0 : Fin 1)
    (coefficientNNReal D w hw) (coefficientNNReal_sum D w hw)

example (w : AdmissiblePartition D → ℝ) (hw : Feasible D w) :
    (coefficientPps D w hw).path.Homogeneous .pps := (coefficientPps D w hw).homogeneous

-- This equation uses the labels and endpoint of the same returned PPS result.
example (w : AdmissiblePartition D → ℝ) (hw : Feasible D w)
    (x : α) (π : PositivePartition D w) :
    (coefficientPps D w hw).endpoint.channel x
      ((coefficientPps D w hw).labels (Sum.inl (coefficientPositiveEquiv D w hw π))) =
      ENNReal.ofReal (w π.val) := by
  have hc := (coefficientPps D w hw).coordinates x
    (Sum.inl (coefficientPositiveEquiv D w hw π))
  change _ = (coefficientNNReal D w hw π.val : ENNReal) *
    (ActiveFiniteChannel.allOnes α).channel x (0 : Fin 1) at hc
  rw [ActiveFiniteChannel.allOnes_apply, mul_one] at hc
  exact hc.trans (ENNReal.coe_nnreal_eq (coefficientNNReal D w hw π.val))

end Data

section ArbitraryPresentation
variable {I J : Type*} [Fintype J] {m n : ℕ}

-- Neither finite index is assumed inhabited; this includes an empty row type.
example (M : Matrix I J ℝ) (value : I → ℝ) (w : J → ℝ)
    (rows : I ≃ Fin m) (cols : J ≃ Fin n) :
    ((∀ j, 0 ≤ (w ∘ cols.symm) j) ∧
      Matrix.reindex rows cols M *ᵥ (w ∘ cols.symm) = value ∘ rows.symm) ↔
    ((∀ j, 0 ≤ w j) ∧ M *ᵥ w = value) :=
  system_reindex_iff M value w rows cols

-- An arbitrary empty column presentation retains the exact same system contract.
example (M : Matrix I J ℝ) (value : I → ℝ) (w : J → ℝ)
    (rows : I ≃ Fin m) (cols : J ≃ Fin 0) :
    ((∀ j, 0 ≤ (w ∘ cols.symm) j) ∧
      Matrix.reindex rows cols M *ᵥ (w ∘ cols.symm) = value ∘ rows.symm) ↔
    ((∀ j, 0 ≤ w j) ∧ M *ᵥ w = value) :=
  system_reindex_iff M value w rows cols

end ArbitraryPresentation
end
end PerfectFunctionalRepresentations.Incidence.Tests.S02Generic

namespace PerfectFunctionalRepresentations.Incidence.Tests.S03Generic
noncomputable section
attribute [local instance] Classical.propDecidable
open scoped BigOperators Matrix

/-! ## S03 public necessity consumers -/

section Necessity

variable {α : Type*} [Fintype α] [Nonempty α] (D : CompressedPatternData α)

example (h : IsPerfectlyRepresentableChannel D.channel) : ∃ w, Feasible D w :=
  exists_feasible_of_isPerfectlyRepresentableChannel D h

example (h : IsPerfectlyRepresentableChannel D.channel) : ∃ w, FullFeasible D w :=
  exists_fullFeasible_of_isPerfectlyRepresentableChannel D h

-- The supplied perfectness witness yields normalized, bounded coefficients
-- and covers every occurring pattern through a positive partition coefficient.
example (h : IsPerfectlyRepresentableChannel D.channel) :
    ∃ w, Feasible D w ∧ (∑ π, w π) = 1 ∧ (∀ π, w π ≤ 1) ∧
      Function.Surjective (positiveBlockPattern D w) := by
  obtain ⟨w, hw⟩ := exists_feasible_of_isPerfectlyRepresentableChannel D h
  exact ⟨w, hw, sum_eq_one_of_reduced_eq D w hw.2,
    reduced_weight_le_one D w hw.1 hw.2, positiveBlockPattern_surjective D hw⟩

-- Both actual transport maps retain the extracted feasible vector.
example (h : IsPerfectlyRepresentableChannel D.channel) :
    ∃ w, FullFeasible D w ∧ Feasible D (restrictWeights D w) ∧
      extendWeights D (restrictWeights D w) = w := by
  obtain ⟨w, hw⟩ := exists_fullFeasible_of_isPerfectlyRepresentableChannel D h
  exact ⟨w, hw, feasible_restrictWeights D hw, extend_restrictWeights D hw⟩

-- A generic C12 consumer uses the public compression bridge, with no input prior.
example {β : Type*} [Finite β] (κ : α → PMF β)
    (hκ : IsSingularChannel κ) (h : IsPerfectlyRepresentableChannel κ) :
    ∃ w, Feasible (compressedPatternData κ hκ) w :=
  exists_feasible_of_isPerfectlyRepresentableChannel _
    ((isPerfectlyRepresentableChannel_iff_compressedPatternData κ hκ).mp h)

-- A C11 consumer feeds the public characterization into the C12/S03 boundary.
example (S : ActiveFiniteChannel α) (hS : IsSingularChannel S.channel)
    (h : MatrixOperations.FromAllOnes S) :
    ∃ w, FullFeasible (compressedPatternData S.channel hS) w :=
  exists_fullFeasible_of_isPerfectlyRepresentableChannel _
    ((isPerfectlyRepresentableChannel_iff_compressedPatternData S.channel hS).mp
      ((MatrixOperations.isPerfectlyRepresentable_iff_fromAllOnes S).mpr h))

end Necessity

end
end PerfectFunctionalRepresentations.Incidence.Tests.S03Generic


namespace PerfectFunctionalRepresentations.Incidence.Tests.S04Generic

noncomputable section
attribute [local instance] Classical.propDecidable
open scoped BigOperators Matrix
open MatrixOperations

variable {α : Type*} [Fintype α] [Nonempty α]

-- One returned object retains complete labels and coordinates for the supplied weights.
example (D : CompressedPatternData α) (w : AdmissiblePartition D → ℝ)
    (hw : Feasible D w) {m : ℕ} (e : OccurringPattern D ≃ Fin m) :
    ∃ C : PartitionConstruction D w,
      (∀ x π, C.pps.endpoint.channel x (C.pps.labels π) = ENNReal.ofReal (w π.val)) ∧
      (∀ x b, C.vps.endpoint.channel x (C.vps.labels b) =
        if x ∈ b.2.val then ENNReal.ofReal (w b.1.val) else 0) ∧
      (∀ x p, C.ppm.endpoint.channel x (C.ppm.labels p) = D.channel x p) ∧
      (∀ π, (columnPattern C.pps.endpoint.channel
        (C.pps.endpoint.activeEquiv (C.pps.labels π))).val = Finset.univ) ∧
      (∀ b, (columnPattern C.vps.endpoint.channel
        (C.vps.endpoint.activeEquiv (C.vps.labels b))).val = b.2.val) ∧
      (∀ p, (columnPattern C.ppm.endpoint.channel
        (C.ppm.endpoint.activeEquiv (C.ppm.labels p))).val = p.val.val) ∧
      (C.normalForm e).ppEndpoint = C.pps.endpoint ∧
      (C.normalForm e).vpEndpoint = C.vps.endpoint ∧
      (C.normalForm e).pmEndpoint = C.ppm.endpoint ∧
      (C.normalForm e).outputEquiv.equiv = C.ppm.labels.symm.trans e ∧
      (∀ x, (C.ppm.endpoint.channel x).map (C.ppm.labels.symm.trans e) =
        (D.toActiveFiniteChannel e).channel x) := by
  let C := partitionConstruction D w hw
  exact ⟨C, C.pps.coordinates, C.vps.coordinates, C.ppm.coordinates,
    C.pps_pattern, C.vps_pattern, C.ppm_pattern,
    rfl, rfl, rfl, rfl, (C.normalForm e).outputEquiv.map_eq⟩

-- Each actual endpoint has exactly the retained semantic labels.
example (D : CompressedPatternData α) (w : AdmissiblePartition D → ℝ)
    (hw : Feasible D w) :
    let C := partitionConstruction D w hw
    C.pps.endpoint.outputCard = Fintype.card (PositivePartition D w) ∧
    C.vps.endpoint.outputCard = Fintype.card (PositiveBlock D w) ∧
    C.ppm.endpoint.outputCard = Fintype.card (OccurringPattern D) :=
  ⟨(partitionConstruction D w hw).pps.outputCard,
    (partitionConstruction D w hw).vps.outputCard,
    (partitionConstruction D w hw).ppm.outputCard⟩

-- Both arbitrary presentations refer to the same stored endpoints and paths.
example (D : CompressedPatternData α) {w : AdmissiblePartition D → ℝ}
    (C : PartitionConstruction D w) {m n : ℕ}
    (e : OccurringPattern D ≃ Fin m) (f : OccurringPattern D ≃ Fin n) :
    (C.normalForm e).outputEquiv.equiv.trans (e.symm.trans f) =
      (C.normalForm f).outputEquiv.equiv := by
  apply Equiv.ext
  intro j
  change f (e.symm (e (C.ppm.labels.symm j))) = f (C.ppm.labels.symm j)
  rw [Equiv.symm_apply_apply]

example (D : CompressedPatternData α) :
    (∃ w, FullFeasible D w) ↔ ∃ w, Nonempty (PartitionConstruction D w) :=
  (isPerfectlyRepresentableChannel_iff_exists_fullFeasible D).symm.trans
    (isPerfectlyRepresentableChannel_iff_exists_partitionConstruction D)

example (D : CompressedPatternData α) {m : ℕ} (e : OccurringPattern D ≃ Fin m) :
    ((∃ w, FullFeasible D w) ↔ FromAllOnes (D.toActiveFiniteChannel e)) ∧
    ((∃ w, FullFeasible D w) ↔ ToAllOnes (D.toActiveFiniteChannel e)) :=
  ⟨(exists_fullFeasible_iff D).trans (exists_feasible_iff_fromAllOnes D e),
    (exists_fullFeasible_iff D).trans (exists_feasible_iff_toAllOnes D e)⟩

-- The ambient bridge permits arbitrary inactive output labels.
example {β : Type*} [Finite β] (κ : α → PMF β) (hκ : IsSingularChannel κ) :
    IsPerfectlyRepresentableChannel κ ↔
      ∃ w, Nonempty (PartitionConstruction (compressedPatternData κ hκ) w) :=
  (isPerfectlyRepresentableChannel_iff_compressedPatternData κ hκ).trans
    (isPerfectlyRepresentableChannel_iff_exists_partitionConstruction _)

example {β γ : Type*} [Finite β] [Finite γ] (κ : α → PMF β)
    (j : β → γ) (hj : Function.Injective j) (hκ : IsSingularChannel κ)
    (hη : IsSingularChannel (fun x => (κ x).map j)) :
    (∃ w, Feasible (compressedPatternData (fun x => (κ x).map j) hη) w) ↔
      ∃ w, Feasible (compressedPatternData κ hκ) w :=
  (isPerfectlyRepresentableChannel_iff_feasible_compressedPatternData _ hη).symm.trans
    ((isPerfectlyRepresentableChannel_map_iff κ j hj).trans
      (isPerfectlyRepresentableChannel_iff_feasible_compressedPatternData κ hκ))

-- An explicit inactive ambient output is retained through the new C12 feasibility bridge.
example (D : CompressedPatternData α) :
    ∃ hη : IsSingularChannel (fun x => (D.channel x).map some),
      (∀ x, ((D.channel x).map some) none = 0) ∧
      (IsPerfectlyRepresentableChannel (fun x => (D.channel x).map some) ↔
        ∃ w, Feasible (compressedPatternData (fun x => (D.channel x).map some) hη) w) ∧
      compressedPatternData (fun x => (D.channel x).map some) hη = D := by
  have hη := (isSingularChannel_map_iff D.channel some (Option.some_injective _)).mpr
    D.channel_singular
  refine ⟨hη, ?_,
    isPerfectlyRepresentableChannel_iff_feasible_compressedPatternData _ hη, ?_⟩
  · intro x
    apply PMF.map_apply_eq_zero_of_notMem_range
    rintro ⟨p, hp⟩
    cases hp
  · exact (compressedPatternData_map_injective D.channel some (Option.some_injective _)
      D.channel_singular hη).trans D.extraction_roundTrip

-- Feasibility in supplied row/partition coordinates constructs the same supplied coefficients.
example (D : CompressedPatternData α) {m r : ℕ}
    (rows : OccurringPattern D ≃ Fin m) (cols : AdmissiblePartition D ≃ Fin r)
    (v : Fin r → ℝ)
    (hv : (∀ j, 0 ≤ v j) ∧
      Matrix.reindex rows cols (reducedMatrix D) *ᵥ v = D.value ∘ rows.symm) :
    ∃ C : PartitionConstruction D (v ∘ cols),
      ∀ x π, C.pps.endpoint.channel x (C.pps.labels π) =
        ENNReal.ofReal (v (cols π.val)) := by
  have ht := system_reindex_iff (reducedMatrix D) D.value (v ∘ cols) rows cols
  have he : (v ∘ cols) ∘ cols.symm = v := by
    funext j
    simp
  rw [he] at ht
  have hw : Feasible D (v ∘ cols) := ht.mp hv
  exact ⟨partitionConstruction D (v ∘ cols) hw,
    (partitionConstruction D (v ∘ cols) hw).pps.coordinates⟩

end
end PerfectFunctionalRepresentations.Incidence.Tests.S04Generic

namespace PerfectFunctionalRepresentations.Incidence.Tests.C14S03Ambient

noncomputable section
attribute [local instance] Classical.propDecidable

variable {α : Type*} [Fintype α] [Nonempty α]

-- R08: both directions retain the original ambient channel, with no full-support premise.
example {β : Type*} [Finite β] (κ : α → PMF β) (hκ : IsSingularChannel κ)
    (hp : IsPerfectlyRepresentableChannel κ) :
    ∃ x, Primal.Feasible (compressedPatternData κ hκ) x ∧
      Primal.objective (compressedPatternData κ hκ) x = 1 :=
  (Primal.isPerfectlyRepresentableChannel_iff_exists_objective_eq_one_compressedPatternData
    κ hκ).mp hp

example {β : Type*} [Finite β] (κ : α → PMF β) (hκ : IsSingularChannel κ)
    (x : AdmissiblePartition (compressedPatternData κ hκ) → ℝ)
    (hx : Primal.Feasible (compressedPatternData κ hκ) x)
    (ho : Primal.objective (compressedPatternData κ hκ) x = 1) :
    IsPerfectlyRepresentableChannel κ :=
  (Primal.isPerfectlyRepresentableChannel_iff_exists_objective_eq_one_compressedPatternData
    κ hκ).mpr ⟨x, hx, ho⟩

-- Active finite states specialize both ambient statements without another public wrapper.
example (S : ActiveFiniteChannel α) (hS : IsSingularChannel S.channel) :
    (IsPerfectlyRepresentableChannel S.channel ↔
      ∃ x, Primal.Feasible (compressedPatternData S.channel hS) x ∧
        Primal.objective (compressedPatternData S.channel hS) x = 1) ∧
    (IsPerfectlyRepresentableChannel S.channel ↔
      IsGreatest (Primal.objectiveValues (compressedPatternData S.channel hS)) 1) :=
  ⟨Primal.isPerfectlyRepresentableChannel_iff_exists_objective_eq_one_compressedPatternData
      S.channel hS,
    Primal.isPerfectlyRepresentableChannel_iff_isGreatest_compressedPatternData S.channel hS⟩

-- Output injections preserve every objective value and the final attained characterization.
example {β γ : Type*} [Finite β] [Finite γ] (κ : α → PMF β)
    (j : β → γ) (hj : Function.Injective j) (hκ : IsSingularChannel κ)
    (hη : IsSingularChannel (fun x => (κ x).map j)) :
    Primal.objectiveValues (compressedPatternData (fun x => (κ x).map j) hη) =
      Primal.objectiveValues (compressedPatternData κ hκ) ∧
    (IsGreatest (Primal.objectiveValues
      (compressedPatternData (fun x => (κ x).map j) hη)) 1 ↔
      IsGreatest (Primal.objectiveValues (compressedPatternData κ hκ)) 1) := by
  refine ⟨congrArg Primal.objectiveValues
    (compressedPatternData_map_injective κ j hj hκ hη), ?_⟩
  exact (Primal.isPerfectlyRepresentableChannel_iff_isGreatest_compressedPatternData
    _ hη).symm.trans ((isPerfectlyRepresentableChannel_map_iff κ j hj).trans
      (Primal.isPerfectlyRepresentableChannel_iff_isGreatest_compressedPatternData κ hκ))

-- The explicit unused ambient label stays zero while compression recovers the same data.
example (D : CompressedPatternData α) :
    ∃ hη : IsSingularChannel (fun x => (D.channel x).map some),
      (∀ x, ((D.channel x).map some) none = 0) ∧
      (IsPerfectlyRepresentableChannel (fun x => (D.channel x).map some) ↔
        IsGreatest (Primal.objectiveValues
          (compressedPatternData (fun x => (D.channel x).map some) hη)) 1) ∧
      compressedPatternData (fun x => (D.channel x).map some) hη = D ∧
      Primal.objectiveValues (compressedPatternData (fun x => (D.channel x).map some) hη) =
        Primal.objectiveValues D := by
  have hη := (isSingularChannel_map_iff D.channel some (Option.some_injective _)).mpr
    D.channel_singular
  have hd := (compressedPatternData_map_injective D.channel some (Option.some_injective _)
    D.channel_singular hη).trans D.extraction_roundTrip
  refine ⟨hη, ?_,
    Primal.isPerfectlyRepresentableChannel_iff_isGreatest_compressedPatternData _ hη,
    hd, congrArg Primal.objectiveValues hd⟩
  intro x
  apply PMF.map_apply_eq_zero_of_notMem_range
  rintro ⟨p, hp⟩
  cases hp

-- Independently supplied active enumerations preserve actual channels and objective sets.
example {β : Type*} [Finite β] (κ : α → PMF β) (hκ : IsSingularChannel κ)
    {m n : ℕ} (e : activeOutputs κ ≃ Fin m) (f : activeOutputs κ ≃ Fin n) :
    ∃ hS : IsSingularChannel (ActiveFiniteChannel.ofChannelWithEquiv κ e).channel,
      ∃ hT : IsSingularChannel (ActiveFiniteChannel.ofChannelWithEquiv κ f).channel,
        (∀ x, ((ActiveFiniteChannel.ofChannelWithEquiv κ e).channel x).map
          (e.symm.trans f) = (ActiveFiniteChannel.ofChannelWithEquiv κ f).channel x) ∧
        compressedPatternData (ActiveFiniteChannel.ofChannelWithEquiv κ e).channel hS =
          compressedPatternData (ActiveFiniteChannel.ofChannelWithEquiv κ f).channel hT ∧
        Primal.objectiveValues
          (compressedPatternData (ActiveFiniteChannel.ofChannelWithEquiv κ e).channel hS) =
          Primal.objectiveValues
            (compressedPatternData (ActiveFiniteChannel.ofChannelWithEquiv κ f).channel hT) ∧
        (IsGreatest (Primal.objectiveValues
          (compressedPatternData (ActiveFiniteChannel.ofChannelWithEquiv κ e).channel hS)) 1 ↔
          IsGreatest (Primal.objectiveValues
            (compressedPatternData (ActiveFiniteChannel.ofChannelWithEquiv κ f).channel hT))
              1) := by
  have hS := (ActiveFiniteChannel.isSingularChannel_ofChannelWithEquiv_iff κ e).mpr hκ
  have hT := (ActiveFiniteChannel.isSingularChannel_ofChannelWithEquiv_iff κ f).mpr hκ
  have hd := (compressedPatternData_ofChannelWithEquiv κ e hκ hS).trans
    (compressedPatternData_ofChannelWithEquiv κ f hκ hT).symm
  refine ⟨hS, hT, ActiveFiniteChannel.ofChannelWithEquiv_compare κ e f,
    hd, congrArg Primal.objectiveValues hd, ?_⟩
  exact (Primal.isPerfectlyRepresentableChannel_iff_isGreatest_compressedPatternData
    _ hS).symm.trans
      ((ActiveFiniteChannel.isPerfectlyRepresentableChannel_ofChannelWithEquiv_iff κ e).trans
        ((ActiveFiniteChannel.isPerfectlyRepresentableChannel_ofChannelWithEquiv_iff κ f).symm.trans
          (Primal.isPerfectlyRepresentableChannel_iff_isGreatest_compressedPatternData _ hT)))

end
end PerfectFunctionalRepresentations.Incidence.Tests.C14S03Ambient
