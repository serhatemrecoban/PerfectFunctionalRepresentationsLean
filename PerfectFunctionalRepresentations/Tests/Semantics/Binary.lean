import PerfectFunctionalRepresentations.Semantics.Binary
import Mathlib.Data.Fintype.EquivFin
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum

/-!
# Binary law boundary regressions

C05 R01-R03 use a nonsymmetric coupling with masses 1/3 and 2/3 on
oppositely oriented off-diagonal atoms. Both marginal directions, full triples,
nonuniform and point priors, Equation (10), row swaps, Bool enumerations and
empty-alphabet impossibilities are tested through the independently importable
binary API. The root integration remains a separate S06 duty.

R04-R07 cover the actual singular posterior and both semantic sufficiency branches.
R08-R10 cover positive constant/swapped vector fibers, null weighted contributions,
point priors, and canonical information transport on unrestricted source carriers.
R11-R13 cover arbitrary support-correct decoders, nonsingular information
attainment, an actual unseen-row discrepancy, and finite auxiliary universes.
R14-R17 cover equality and strictness, the nonsingular point-prior guard, input
and prior transport, and an actual attaining witness under injective output maps.
-/

namespace PerfectFunctionalRepresentations

open LeanInfoTheory.Shannon
open scoped BigOperators ENNReal

noncomputable section

universe u v

section General

variable {beta : Type u} (g : PMF (beta × beta)) (q : PMF (Fin 2 → beta))
  (kappa : Fin 2 → PMF beta) (p : PMF (Fin 2))

/-- R01: both inverse-law statements retain arbitrary output types/universes. -/
example : (g.map (finTwoArrowEquiv beta).symm).map (finTwoArrowEquiv beta) = g := by
  exact map_finTwoArrowEquiv_symm_roundtrip g

example : (q.map (finTwoArrowEquiv beta)).map (finTwoArrowEquiv beta).symm = q := by
  exact map_finTwoArrowEquiv_roundtrip q

example (h : IsCanonicalCoupling kappa q) :
    IsCoupling (kappa 0) (kappa 1) (q.map (finTwoArrowEquiv beta)) :=
  (isCanonicalCoupling_iff_isCoupling_finTwoArrowEquiv kappa q).1 h

/-- R02: reverse transport recovers the full original canonical joint. -/
example : canonicalJoint p q =
    (indepProd p (q.map (finTwoArrowEquiv beta))).map (fun xz =>
      (xz.1, (finTwoArrowEquiv beta).symm xz.2 xz.1,
        (finTwoArrowEquiv beta).symm xz.2)) := by
  simpa only [map_finTwoArrowEquiv_roundtrip] using
    canonicalJoint_map_finTwoArrowEquiv_symm p (q.map (finTwoArrowEquiv beta))

example : (canonicalJoint p (g.map (finTwoArrowEquiv beta).symm)).map
      (fun t => (t.1, t.2.1, finTwoArrowEquiv beta t.2.2)) =
    (indepProd p g).map (fun xz =>
      (xz.1, (finTwoArrowEquiv beta).symm xz.2 xz.1, xz.2)) :=
  canonicalJoint_map_finTwoArrowEquiv p g

/-- R03: swapping product coordinates swaps exactly vector coordinates 0/1. -/
example : (g.map Prod.swap).map (finTwoArrowEquiv beta).symm =
    (g.map (finTwoArrowEquiv beta).symm).map (fun w => ![w 1, w 0]) := by
  simp only [PMF.map_comp, Function.comp_def]
  rfl

end General

private def skewBit : PMF (Fin 2) :=
  PMF.ofFintype (fun i => if i = 0 then (1 : ENNReal) / 3 else 2 / 3) (by
    apply (ENNReal.toReal_eq_one_iff _).1
    rw [ENNReal.toReal_sum]
    · norm_num [Fin.sum_univ_succ]
    · intro i _
      split <;> exact ENNReal.div_ne_top (by norm_num) (by norm_num))

private def reverseBit : PMF (Fin 2) := skewBit.map Fin.rev

private theorem reverseBit_apply (i : Fin 2) :
    reverseBit i = if i = 0 then (2 : ENNReal) / 3 else 1 / 3 := by
  rw [reverseBit, PMF.map_apply, tsum_fintype, Fin.sum_univ_two]
  simp only [show (0 : Fin 2).rev = 1 by decide, show (1 : Fin 2).rev = 0 by decide]
  fin_cases i <;> norm_num [skewBit, PMF.ofFintype_apply]

private def nonsymmetric : PMF (Fin 2 × Fin 2) :=
  skewBit.map fun i => (i, i.rev)

private def rows : Fin 2 → PMF (Fin 2) := ![skewBit, reverseBit]

private def vectorLaw : PMF (Fin 2 → Fin 2) :=
  nonsymmetric.map (finTwoArrowEquiv (Fin 2)).symm

private theorem nonsymmetric_coupling : IsCoupling (rows 0) (rows 1) nonsymmetric := by
  constructor
  · simpa only [nonsymmetric, rows, Matrix.cons_val_zero, PMF.map_id, id_eq] using
      fstMarginal_map_pair skewBit id Fin.rev
  · simpa only [nonsymmetric, rows, Matrix.cons_val_one, Matrix.cons_val_zero,
      reverseBit, id_eq] using sndMarginal_map_pair skewBit id Fin.rev

private theorem vector_coupling : IsCanonicalCoupling rows vectorLaw :=
  (isCoupling_iff_isCanonicalCoupling_finTwoArrowEquiv rows nonsymmetric).1
    nonsymmetric_coupling

/-- R01: unequal off-diagonal masses make an accidental coordinate swap visible. -/
example : nonsymmetric (0, 1) = (1 : ENNReal) / 3 ∧
    nonsymmetric (1, 0) = (2 : ENNReal) / 3 := by
  constructor <;> rw [nonsymmetric, PMF.map_apply, tsum_fintype, Fin.sum_univ_two] <;>
    simp only [show (0 : Fin 2).rev = 1 by decide, show (1 : Fin 2).rev = 0 by decide] <;>
    norm_num [skewBit, PMF.ofFintype_apply]

example : vectorLaw.map (fun w => w 0) = skewBit ∧
    vectorLaw.map (fun w => w 1) = reverseBit :=
  ⟨vector_coupling 0, vector_coupling 1⟩

example : fstMarginal (vectorLaw.map (finTwoArrowEquiv (Fin 2))) = skewBit ∧
    sndMarginal (vectorLaw.map (finTwoArrowEquiv (Fin 2))) = reverseBit := by
  simp only [fstMarginal_map_finTwoArrowEquiv, sndMarginal_map_finTwoArrowEquiv]
  exact ⟨vector_coupling 0, vector_coupling 1⟩

example : vectorLaw.map (finTwoArrowEquiv (Fin 2)) = nonsymmetric := by
  exact map_finTwoArrowEquiv_symm_roundtrip nonsymmetric

/-- R02: the prior is nonuniform and has full support. -/
example : skewBit 0 = (1 : ENNReal) / 3 ∧ skewBit 1 = (2 : ENNReal) / 3 := by
  norm_num [skewBit, PMF.ofFintype_apply]

example : ∀ i, i ∈ skewBit.support := by
  intro i
  fin_cases i <;> norm_num [PMF.mem_support_iff, skewBit, PMF.ofFintype_apply]

example : fstSndMarginal (canonicalJoint skewBit vectorLaw) =
    PMF.channelJoint skewBit rows :=
  nonsymmetric_coupling.fstSndMarginal_binaryCanonicalJoint skewBit

example : fstSndMarginal (canonicalJoint (PMF.pure 0) vectorLaw) =
    PMF.channelJoint (PMF.pure 0) rows :=
  nonsymmetric_coupling.fstSndMarginal_binaryCanonicalJoint (PMF.pure 0)

example : fstSndMarginal (canonicalJoint (PMF.pure 1) vectorLaw) =
    PMF.channelJoint (PMF.pure 1) rows :=
  nonsymmetric_coupling.fstSndMarginal_binaryCanonicalJoint (PMF.pure 1)

example : PMF.channelJoint skewBit rows (0, 0) = (1 : ENNReal) / 9 ∧
    PMF.channelJoint skewBit rows (0, 1) = (2 : ENNReal) / 9 ∧
    PMF.channelJoint skewBit rows (1, 0) = (4 : ENNReal) / 9 ∧
    PMF.channelJoint skewBit rows (1, 1) = (2 : ENNReal) / 9 := by
  repeat' constructor
  all_goals
    apply (ENNReal.toReal_eq_toReal_iff'
      ((PMF.channelJoint skewBit rows).apply_ne_top _)
      (ENNReal.div_ne_top (by norm_num) (by norm_num))).1
    norm_num [PMF.channelJoint_apply, rows, reverseBit_apply, skewBit,
      PMF.ofFintype_apply, ENNReal.toReal_mul]

/-- Equation (10) is exactly C04 TV, without another normalization or scalar API. -/
example {beta : Type u} [Fintype beta] (kappa : Fin 2 → PMF beta) :
    finiteTV (kappa 0) (kappa 1) =
      (1 / 2 : ℝ) * ∑ y, |(kappa 0 y).toReal - (kappa 1 y).toReal| := rfl

example {beta : Type u} [Fintype beta] (kappa : Fin 2 → PMF beta) :
    finiteTV (kappa 0) (kappa 1) = 1 - (overlapMass (kappa 0) (kappa 1)).toReal :=
  finiteTV_eq_one_sub_overlap_toReal _ _

example : finiteTV (rows 0) (rows 1) = (1 : ℝ) / 3 := by
  norm_num [finiteTV, Fin.sum_univ_two, rows, reverseBit_apply, skewBit,
    PMF.ofFintype_apply]

/-- R03: row reversal preserves r for the nonsymmetric channel. -/
example : finiteTV (rows 1) (rows 0) = finiteTV (rows 0) (rows 1) :=
  finiteTV_comm _ _

private def boolRows : Bool → PMF (Fin 2) := fun b => rows (finTwoEquiv.symm b)

example : boolRows false = rows 0 ∧ boolRows true = rows 1 := by
  exact ⟨rfl, rfl⟩

/-- A different input type and its reversed enumeration give the same scalar. -/
example : finiteTV (boolRows (finTwoEquiv 0)) (boolRows (finTwoEquiv 1)) =
    finiteTV (boolRows ((finTwoEquiv.symm.trans (Equiv.swap 0 1)).symm 0))
      (boolRows ((finTwoEquiv.symm.trans (Equiv.swap 0 1)).symm 1)) :=
  finiteTV_inputEnumeration_eq boolRows finTwoEquiv.symm
    (finTwoEquiv.symm.trans (Equiv.swap 0 1))

example {alpha : Type u} {beta : Type v} [Fintype alpha] [Fintype beta]
    (kappa : alpha → PMF beta) (hcard : Fintype.card alpha = 2) (e : alpha ≃ Fin 2) :
    finiteTV (kappa ((Fintype.equivFinOfCardEq hcard).symm 0))
      (kappa ((Fintype.equivFinOfCardEq hcard).symm 1)) =
        finiteTV (kappa (e.symm 0)) (kappa (e.symm 1)) :=
  finiteTV_inputEnumeration_eq kappa (Fintype.equivFinOfCardEq hcard) e

/-- R02: a supplied row rules out empty outputs without an extra public hypothesis. -/
example (kappa : Fin 2 → PMF Empty) : False := by
  obtain ⟨y, _⟩ := (kappa 0).support_nonempty
  exact isEmptyElim y

/-- R03: an empty input cannot satisfy the intrinsic cardinality-two contract. -/
example : Fintype.card Empty ≠ 2 := by decide

end

namespace BinarySingularTests

open scoped ENNReal BigOperators

noncomputable section

private def row0 : PMF (Fin 5) :=
  PMF.ofFintype ![(1 : ENNReal) / 2, 1 / 2, 0, 0, 0] (by
    apply (ENNReal.toReal_eq_one_iff _).1
    rw [ENNReal.toReal_sum]
    · norm_num [Fin.sum_univ_succ]
    · intro i _
      fin_cases i <;> norm_num)

private def row1 : PMF (Fin 5) :=
  PMF.ofFintype ![(1 : ENNReal) / 2, 0, 1 / 4, 1 / 4, 0] (by
    apply (ENNReal.toReal_eq_one_iff _).1
    rw [ENNReal.toReal_sum]
    · norm_num [Fin.sum_univ_succ]
    · intro i _
      fin_cases i <;> norm_num)

private def rows : Fin 2 → PMF (Fin 5) := ![row0, row1]

private def joint : PMF (Fin 5 × Fin 5) := maximalCoupling row0 row1

private def vectorLaw : PMF (Fin 2 → Fin 5) :=
  joint.map (finTwoArrowEquiv (Fin 5)).symm

private theorem singular : IsSingularChannel rows := by
  intro x1 x2 y
  fin_cases x1 <;> fin_cases x2 <;> fin_cases y <;>
    norm_num [rows, row0, row1, PMF.ofFintype_apply]

private theorem overlap : overlapMass row0 row1 = (1 : ENNReal) / 2 := by
  norm_num [overlapMass, row0, row1, PMF.ofFintype_apply, Fin.sum_univ_succ]

-- R04: the full maximal-coupling atom table is small and exact.
private theorem joint_apply (a b : Fin 5) :
    joint (a, b) = if (a, b) = (0, 0) then 1 / 2 else
      if (a, b) = (1, 2) ∨ (a, b) = (1, 3) then 1 / 4 else 0 := by
  apply (ENNReal.toReal_eq_toReal_iff' (joint.apply_ne_top _)
    (by
      split
      · norm_num
      · split <;> norm_num)).1
  rw [joint, maximalCoupling_apply, overlap]
  fin_cases a <;> fin_cases b <;>
    norm_num [row0, row1, PMF.ofFintype_apply, Fin.ext_iff, ENNReal.toReal_mul,
      ENNReal.toReal_div, ENNReal.toReal_sub_of_le]

private theorem vector_apply (a b : Fin 5) :
    vectorLaw ((finTwoArrowEquiv (Fin 5)).symm (a, b)) = joint (a, b) :=
  PMF.map_apply_of_injective joint (finTwoArrowEquiv (Fin 5)).symm.injective (a, b)

example : IsCanonicalCoupling rows vectorLaw :=
  (isCoupling_iff_isCanonicalCoupling_finTwoArrowEquiv rows joint).1
    (isCoupling_maximalCoupling row0 row1)

example : IsSingularChannel rows ∧ finiteTV (rows 0) (rows 1) = (1 : ℝ) / 2 := by
  refine ⟨singular, ?_⟩
  change finiteTV row0 row1 = 1 / 2
  rw [finiteTV_eq_one_sub_overlap_toReal, overlap]
  norm_num

-- R04: instantiate this consumer with the new production common-posterior witness.
-- It derives two positive atoms of that actual witness, independent of its definition.
private theorem posterior_nontrivial (V : Fin 5 → PMF (Fin 2 → Fin 5))
    (h : ∀ x, vectorLaw.map (fun w => (w x, w)) = PMF.channelJoint (rows x) V) :
    ∃ w w' : Fin 2 → Fin 5, w ≠ w' ∧ 0 < V 1 w ∧ 0 < V 1 w' := by
  let w : Fin 2 → Fin 5 := (finTwoArrowEquiv (Fin 5)).symm (1, 2)
  let w' : Fin 2 → Fin 5 := (finTwoArrowEquiv (Fin 5)).symm (1, 3)
  have hinj : Function.Injective (fun z : Fin 2 → Fin 5 => (z 0, z)) := by
    intro z z' hz
    exact congrArg Prod.snd hz
  have hpos (z : Fin 2 → Fin 5) (hz : z 0 = 1) (hm : 0 < vectorLaw z) : 0 < V 1 z := by
    have heq := congrArg (fun law : PMF (Fin 5 × (Fin 2 → Fin 5)) => law (z 0, z)) (h 0)
    rw [PMF.map_apply_of_injective vectorLaw hinj z, PMF.channelJoint_apply, hz] at heq
    apply pos_iff_ne_zero.mpr
    intro hn
    rw [hn, mul_zero] at heq
    exact ne_of_gt hm heq
  refine ⟨w, w', ?_, hpos w rfl ?_, hpos w' rfl ?_⟩
  · intro heq
    have heq' := congrArg (fun z : Fin 2 → Fin 5 => z 1) heq
    have hval := congrArg Fin.val heq'
    norm_num [w, w', finTwoArrowEquiv] at hval
  · dsimp only [w]
    rw [vector_apply, joint_apply]
    norm_num
  · dsimp only [w']
    rw [vector_apply, joint_apply]
    norm_num

-- R06: output 4 is genuinely absent from both rows and from the active union.
example : rows 0 4 = 0 ∧ rows 1 4 = 0 ∧ (4 : Fin 5) ∉ activeOutputs rows := by
  change row0 ⟨4, by decide⟩ = 0 ∧ row1 ⟨4, by decide⟩ = 0 ∧
    (⟨4, by decide⟩ : Fin 5) ∉ activeOutputs rows
  norm_num [rows, row0, row1, PMF.ofFintype_apply, activeOutputs,
    PMF.mem_support_iff, Fin.exists_fin_two]

-- R05: the two construction endpoints remain the established C04 contracts.
example {beta : Type*} [Fintype beta] (p : PMF beta) :
    maximalCoupling p p = p.map (fun y => (y, y)) := maximalCoupling_self p

example {beta : Type*} [Fintype beta] (p q : PMF beta)
    (hd : Disjoint p.support q.support) :
    maximalCoupling p q = indepProd p q :=
  maximalCoupling_eq_indepProd_of_overlapMass_eq_zero p q
    ((overlapMass_eq_zero_iff_disjoint p q).2 hd)

-- R06: singleton output admits arbitrary supplied rows and no hidden prior.
example (kappa : Fin 2 → PMF Unit) : IsPerfectlyRepresentableChannel kappa := by
  apply (isPerfectlyRepresentableChannel_iff_isSingular_of_input_card_eq_two kappa (by decide)).2
  intro x1 x2 y _ _
  have hunit (p : PMF Unit) : p () = 1 := by simpa using p.tsum_coe
  cases y
  rw [hunit, hunit]


/-- R04/R06: the actual production witness has a multiatom exclusive posterior
and the specified completion at the globally unused label. -/
example : ∃ V : Fin 5 → PMF (Fin 2 → Fin 5),
    (∀ i, vectorLaw.map (fun w => (w i, w)) = PMF.channelJoint (rows i) V) ∧
    V 4 = vectorLaw ∧
    ∃ w w' : Fin 2 → Fin 5, w ≠ w' ∧ 0 < V 1 w ∧ 0 < V 1 w' := by
  obtain ⟨V, hV, hnull⟩ := exists_binary_maximal_commonPosterior rows singular
  change ∀ i, vectorLaw.map (fun w => (w i, w)) = PMF.channelJoint (rows i) V at hV
  refine ⟨V, hV, ?_, posterior_nontrivial V hV⟩
  exact hnull ⟨4, by decide⟩ rfl rfl

/-- R05: the new binary theorem consumes the overlap-one endpoint. -/
example {beta : Type*} [Fintype beta] (p : PMF beta) :
    IsPerfectlyRepresentableChannel (fun _ : Fin 2 => p) ∧
    maximalCoupling p p = p.map (fun y => (y, y)) := by
  refine ⟨?_, maximalCoupling_self p⟩
  exact (isPerfectlyRepresentableChannel_iff_isSingular_of_input_card_eq_two
    (fun _ : Fin 2 => p) (by decide)).2 (fun _ _ _ _ _ => rfl)

/-- R05: disjoint rows use the new semantic theorem and C04's product endpoint. -/
example {beta : Type*} [Fintype beta] (p q : PMF beta)
    (hd : Disjoint p.support q.support) :
    IsPerfectlyRepresentableChannel ![p, q] ∧ maximalCoupling p q = indepProd p q := by
  refine ⟨?_, maximalCoupling_eq_indepProd_of_overlapMass_eq_zero p q
    ((overlapMass_eq_zero_iff_disjoint p q).2 hd)⟩
  apply (isPerfectlyRepresentableChannel_iff_isSingular_of_input_card_eq_two
    ![p, q] (by decide)).2
  intro i j y hi hj
  have hn : p y ≠ 0 → q y ≠ 0 → False :=
    fun hp hq => Set.disjoint_left.mp hd hp hq
  fin_cases i <;> fin_cases j
  · rfl
  · exact (hn hi hj).elim
  · exact (hn hj hi).elim
  · rfl

/-- R07: four active outputs force the input branch of the combined theorem. -/
example :
    let : Fintype (activeOutputs rows) := Fintype.ofFinite _
    Fintype.card (activeOutputs rows) = 4 ∧ IsPerfectlyRepresentableChannel rows := by
  classical
  let : Fintype (activeOutputs rows) := Fintype.ofFinite _
  change Fintype.card (activeOutputs rows) = 4 ∧ IsPerfectlyRepresentableChannel rows
  refine ⟨?_, (isPerfectlyRepresentableChannel_iff_isSingular_of_binary rows
    (Or.inl (by decide))).2 singular⟩
  calc
    Fintype.card (activeOutputs rows) = ({0, 1, 2, 3} : Finset (Fin 5)).card := by
      apply Fintype.card_of_subtype
      intro y
      fin_cases y <;>
        norm_num [activeOutputs, rows, row0, row1, PMF.ofFintype_apply,
          PMF.mem_support_iff, Fin.exists_fin_two, Fin.ext_iff]
    _ = 4 := by decide

/-- R07: a different binary input type exercises the cardinality transport. -/
example : IsPerfectlyRepresentableChannel (fun b : Bool => rows (finTwoEquiv.symm b)) :=
  (isPerfectlyRepresentableChannel_iff_isSingular_of_input_card_eq_two
    (fun b : Bool => rows (finTwoEquiv.symm b)) (by decide)).2
      (fun i j y hi hj => singular _ _ y hi hj)

private def outputBranch : Fin 3 → PMF (Fin 3) :=
  fun i => PMF.pure (if i = 0 then 0 else 1)

/-- R07: three inputs and three ambient outputs, but exactly two active outputs,
exercise C03's distinct branch of the combined theorem. -/
example :
    let : Fintype (activeOutputs outputBranch) := Fintype.ofFinite _
    Fintype.card (Fin 3) ≠ 2 ∧
    Fintype.card (activeOutputs outputBranch) = 2 ∧
    IsPerfectlyRepresentableChannel outputBranch := by
  classical
  let : Fintype (activeOutputs outputBranch) := Fintype.ofFinite _
  change Fintype.card (Fin 3) ≠ 2 ∧ Fintype.card (activeOutputs outputBranch) = 2 ∧
    IsPerfectlyRepresentableChannel outputBranch
  have hc : Fintype.card (activeOutputs outputBranch) = 2 := by
    calc
      Fintype.card (activeOutputs outputBranch) = ({0, 1} : Finset (Fin 3)).card := by
        apply Fintype.card_of_subtype
        intro y
        fin_cases y <;> norm_num [activeOutputs, outputBranch,
          PMF.mem_support_iff, Fin.exists_fin_succ]
      _ = 2 := by decide
  refine ⟨by decide, hc, ?_⟩
  apply (isPerfectlyRepresentableChannel_iff_isSingular_of_binary outputBranch
    (Or.inr (le_of_eq hc))).2
  intro i j y hi hj
  fin_cases i <;> fin_cases j <;> fin_cases y <;>
    norm_num [outputBranch] at *

/-- R07: direct consumer of the printed ambient-two-output clause. -/
example (kappa : Fin 3 → PMF Bool) (hs : IsSingularChannel kappa) :
    IsPerfectlyRepresentableChannel kappa :=
  (isPerfectlyRepresentableChannel_iff_isSingular_of_card_le_two kappa (by decide)).2 hs

/-- Generic necessity keeps C03's unrestricted structural signature. -/
example {alpha : Type u} {beta : Type v} [Nonempty alpha]
    {kappa : alpha → PMF beta} (hp : IsPerfectlyRepresentableChannel kappa) :
    IsSingularChannel kappa := hp.isSingular

end

end BinarySingularTests


namespace BinaryEntropyTests

open LeanInfoTheory.Shannon
open scoped BigOperators ENNReal

noncomputable section
universe s t

private def fairBit : PMF (Fin 2) :=
  PMF.ofFintype (fun _ => (1 : ENNReal) / 2) (by
    apply (ENNReal.toReal_eq_one_iff _).1
    rw [ENNReal.toReal_sum]
    · norm_num [Fin.sum_univ_two]
    · intro i _
      exact ENNReal.div_ne_top (by norm_num) (by norm_num))

private def w00 : Fin 2 → Fin 2 := ![0, 0]
private def w10 : Fin 2 → Fin 2 := ![1, 0]
private def w01 : Fin 2 → Fin 2 := ![0, 1]
private def entropyVectors : PMF (Fin 2 → Fin 2) :=
  fairBit.map fun z => ![z, 0]

private theorem entropyVectors_atoms :
    entropyVectors w00 = (1 : ENNReal) / 2 ∧
    entropyVectors w10 = (1 : ENNReal) / 2 ∧
    entropyVectors w01 = 0 := by
  repeat' constructor
  all_goals
    rw [entropyVectors, PMF.map_apply, tsum_fintype, Fin.sum_univ_two]
    norm_num [fairBit, PMF.ofFintype_apply, w00, w10, w01]

private theorem entropyVectors_positive :
    entropyVectors w00 ≠ 0 ∧ entropyVectors w10 ≠ 0 := by
  rw [entropyVectors_atoms.1, entropyVectors_atoms.2.1]
  norm_num

private theorem outputVector_snd (p : PMF (Fin 2)) (q : PMF (Fin 2 → Fin 2)) :
    sndMarginal (sndThirdMarginal (canonicalJoint p q)) = q := by
  simpa only [sndMarginal, sndThirdMarginal, PMF.map_comp, Function.comp_def]
    using thirdMarginal_canonicalJoint p q

private abbrev outputVectorLaw :=
  sndThirdMarginal (canonicalJoint skewBit entropyVectors)

private theorem positive00 : sndMarginal outputVectorLaw w00 ≠ 0 := by
  rw [outputVector_snd]
  exact entropyVectors_positive.1

private theorem positive10 : sndMarginal outputVectorLaw w10 ≠ 0 := by
  rw [outputVector_snd]
  exact entropyVectors_positive.2

-- R08: directly consume the production positive-conditional-law bridge.
section PositiveFibers

private theorem h00 :
    condFstGivenSnd outputVectorLaw w00 positive00 = skewBit.map w00 :=
  condFstGivenSnd_binaryCanonicalJoint skewBit entropyVectors w00
    entropyVectors_positive.1

private theorem h10 :
    condFstGivenSnd outputVectorLaw w10 positive10 = skewBit.map w10 :=
  condFstGivenSnd_binaryCanonicalJoint skewBit entropyVectors w10
    entropyVectors_positive.2

-- Equal positive vector: the actual conditional PMF is a point law.
example : condFstGivenSnd outputVectorLaw w00 positive00 = PMF.pure 0 := by
  rw [h00]
  have hconst : w00 = Function.const (Fin 2) (0 : Fin 2) := by
    funext i
    fin_cases i <;> rfl
  rw [hconst, PMF.map_const]

example : entropy (condFstGivenSnd outputVectorLaw w00 positive00) = 0 := by
  rw [h00]
  have hconst : w00 = Function.const (Fin 2) (0 : Fin 2) := by
    funext i
    fin_cases i <;> rfl
  rw [hconst, PMF.map_const, entropy_pure]

-- Distinct positive vector: both masses reverse, exposing coordinate errors.
example : condFstGivenSnd outputVectorLaw w10 positive10 0 = (2 : ENNReal) / 3 ∧
    condFstGivenSnd outputVectorLaw w10 positive10 1 = (1 : ENNReal) / 3 := by
  rw [h10]
  constructor <;> rw [PMF.map_apply, tsum_fintype, Fin.sum_univ_two] <;>
    norm_num [skewBit, PMF.ofFintype_apply, w10]

example : entropy (condFstGivenSnd outputVectorLaw w10 positive10) =
    entropy skewBit := by
  rw [h10]
  apply entropy_map_injective
  intro a b hab
  fin_cases a <;> fin_cases b <;> norm_num [w10] at *

end PositiveFibers

-- R09: no conditional entropy assignment is needed at the null unequal vector.
example (arbitraryFiberValue : Real) :
    (entropyVectors w01).toReal * arbitraryFiberValue = 0 := by
  rw [entropyVectors_atoms.2.2, ENNReal.toReal_zero, zero_mul]

example : (sndMarginal outputVectorLaw w01).toReal *
    condEntropyFstGivenSnd outputVectorLaw w01 = 0 := by
  rw [outputVector_snd, entropyVectors_atoms.2.2, ENNReal.toReal_zero, zero_mul]

-- The aggregate theorem uses the fixture's independently calculated mismatch coefficient.
private theorem entropyVectors_mismatch :
    (mismatchMass (entropyVectors.map (finTwoArrowEquiv (Fin 2)))).toReal =
      (1 / 2 : Real) := by
  have hPair : entropyVectors.map (finTwoArrowEquiv (Fin 2)) =
      fairBit.map (fun z => (z, (0 : Fin 2))) := by
    rw [entropyVectors, PMF.map_comp]
    rfl
  rw [hPair, mismatchMass_toReal, Fintype.sum_prod_type]
  norm_num [Fin.sum_univ_two, PMF.map_apply, tsum_fintype, fairBit, PMF.ofFintype_apply]
  decide

example : condEntropyOf (canonicalJoint skewBit entropyVectors)
      (fun t => t.2.1) (fun t => t.2.2) = (1 / 2 : Real) * entropy skewBit := by
  rw [condEntropyOf_binaryCanonicalJoint, entropyVectors_mismatch]

example : mutualInfoOf (canonicalJoint skewBit entropyVectors)
      (fun t => t.2.1) (fun t => t.2.2) =
    entropyOf (canonicalJoint skewBit entropyVectors) (fun t => t.2.1) -
      (1 / 2 : Real) * entropy skewBit := by
  rw [mutualInfoOf_binaryCanonicalJoint, entropyVectors_mismatch]

-- R10: both point priors, arbitrary vector law, arbitrary finite output universe.
example {beta : Type t} [Fintype beta] (i : Fin 2) (q : PMF (Fin 2 → beta)) :
    condEntropyOf (canonicalJoint (PMF.pure i) q)
      (fun t => t.2.1) (fun t => t.2.2) = 0 := by
  rw [condEntropyOf_binaryCanonicalJoint, entropy_pure, mul_zero]

example {beta : Type t} [Fintype beta] (i : Fin 2) (q : PMF (Fin 2 → beta)) :
    mutualInfoOf (canonicalJoint (PMF.pure i) q)
      (fun t => t.2.1) (fun t => t.2.2) =
    entropyOf (canonicalJoint (PMF.pure i) q) (fun t => t.2.1) := by
  rw [mutualInfoOf_binaryCanonicalJoint, entropy_pure, mul_zero, sub_zero]

-- The source universe is explicitly higher; no Fintype/Finite instance on it.
example {omega : Type (s + 1)} {beta : Type t} [Fintype beta]
    (mu : PMF omega) (X : omega → Fin 2) (Y : omega → beta)
    (W : omega → Fin 2 → beta) (hC : IsCanonicalFunctionalRepresentationOf mu X Y W) :
    condEntropyOf mu Y W =
      (mismatchMass ((mu.map W).map (finTwoArrowEquiv beta))).toReal * entropyOf mu X :=
  hC.condEntropyOf_eq_binary_mismatch

-- Nat makes the unrestricted carrier concrete; ULift keeps output universes honest.
example (mu : PMF Nat) (X : Nat → Fin 2) (Y : Nat → ULift.{1} (Fin 2))
    (W : Nat → Fin 2 → ULift.{1} (Fin 2))
    (hC : IsCanonicalFunctionalRepresentationOf mu X Y W) :
    mu.map (fun n => (X n, Y n, W n)) = canonicalJoint (mu.map X) (mu.map W) :=
  hC.jointLaw_eq_canonicalJoint

example (mu : PMF Nat) (X : Nat → Fin 2) (Y : Nat → ULift.{1} (Fin 2))
    (W : Nat → Fin 2 → ULift.{1} (Fin 2))
    (hC : IsCanonicalFunctionalRepresentationOf mu X Y W) :
    mutualInfoOf mu Y W = entropyOf mu Y -
      (mismatchMass ((mu.map W).map (finTwoArrowEquiv (ULift.{1} (Fin 2))))).toReal *
        entropyOf mu X :=
  hC.mutualInfoOf_eq_binary_mismatch


end

end BinaryEntropyTests

namespace BinaryBoundTests

noncomputable section

universe s t a

-- R11: an original finite auxiliary and any support-correct decoder, on an
-- unrestricted source. C02 information preservation is explicitly consumed.
example {omega : Type s} {beta : Type t} {gamma : Type a}
    [Fintype beta] [Fintype gamma]
    (mu : PMF omega) (p : PMF (Fin 2)) (kappa : Fin 2 → PMF beta)
    (X : omega → Fin 2) (Y : omega → beta) (Z : omega → gamma)
    (decoder : Fin 2 × gamma → beta) (hI : IsIndependentOf mu X Z)
    (hD : ∀ z ∈ mu.support, Y z = decoder (X z, Z z))
    (hPair : mu.map (fun z => (X z, Y z)) = PMF.channelJoint p kappa) :
    mutualInfoOf mu Y (fun z => decoderVector decoder (Z z)) = mutualInfoOf mu Y Z ∧
    mutualInfoOf mu Y Z ≤ entropy (sndMarginal (PMF.channelJoint p kappa)) -
      finiteTV (kappa 0) (kappa 1) * entropy p := by
  have hFR : IsFunctionalRepresentationOf mu X Y Z :=
    (isFunctionalRepresentationOf_iff mu X Y Z).2 ⟨hI, decoder, hD⟩
  exact ⟨mutualInfoOf_decoderVector_eq mu X Y Z decoder hI hD,
    hFR.mutualInfoOf_le_binary_bound (p := p) (kappa := kappa) hPair⟩

-- The bound and finite witness compose into an actual maximum comparison.
example {omega : Type s} {beta : Type t} {gamma : Type a}
    [Fintype beta] [Fintype gamma]
    (mu : PMF omega) (p : PMF (Fin 2)) (kappa : Fin 2 → PMF beta)
    (X : omega → Fin 2) (Y : omega → beta) (Z : omega → gamma)
    (hFR : IsFunctionalRepresentationOf mu X Y Z)
    (hPair : mu.map (fun z => (X z, Y z)) = PMF.channelJoint p kappa) :
    ∃ t : PMF (Fin 2 × beta × (Fin 2 → beta)),
      IsFunctionalRepresentation t ∧ fstSndMarginal t = PMF.channelJoint p kappa ∧
      mutualInfoOf mu Y Z ≤ mutualInfoOf t (fun z => z.2.1) (fun z => z.2.2) := by
  obtain ⟨t, hT, hPairT, hInfo⟩ := exists_binary_information_maximizer p kappa
  refine ⟨t, hT, hPairT, ?_⟩
  rw [hInfo]
  exact hFR.mutualInfoOf_le_binary_bound p kappa hPair

-- R12: reuse the S01 nonuniform prior and nonsingular rows. The existing
-- nonsymmetric coupling is not maximal; this witness deliberately uses C04's
-- specified maximalCoupling. Its expected atoms are g00=g10=g11=1/3, g01=0.
private def attainingVectors : PMF (Fin 2 → Fin 2) :=
  (maximalCoupling (rows 0) (rows 1)).map (finTwoArrowEquiv (Fin 2)).symm

private def attainingTriple : PMF (Fin 2 × Fin 2 × (Fin 2 → Fin 2)) :=
  canonicalJoint skewBit attainingVectors

private theorem rowsTV : finiteTV (rows 0) (rows 1) = (1 : Real) / 3 := by
  norm_num [finiteTV, Fin.sum_univ_two, rows, reverseBit_apply, skewBit,
    PMF.ofFintype_apply]

example : ¬ IsSingularChannel rows := by
  intro hSingular
  have h := hSingular 0 1 0
    (by norm_num [rows, skewBit, PMF.ofFintype_apply])
    (by norm_num [rows, reverseBit_apply])
  norm_num [rows, reverseBit_apply, skewBit, PMF.ofFintype_apply] at h
  have hReal := congrArg ENNReal.toReal h
  norm_num at hReal

example : (∀ i, i ∈ skewBit.support) ∧
    0 < finiteTV (rows 0) (rows 1) ∧ finiteTV (rows 0) (rows 1) < 1 := by
  refine ⟨?_, ?_, ?_⟩
  · intro i
    fin_cases i <;> norm_num [PMF.mem_support_iff, skewBit, PMF.ofFintype_apply]
  · rw [rowsTV]
    norm_num
  · rw [rowsTV]
    norm_num

-- Exact channel output masses, independently of the attainment theorem.
example : sndMarginal (PMF.channelJoint skewBit rows) 0 = (5 : ENNReal) / 9 ∧
    sndMarginal (PMF.channelJoint skewBit rows) 1 = (4 : ENNReal) / 9 := by
  constructor
  all_goals
    apply (ENNReal.toReal_eq_toReal_iff'
      ((sndMarginal (PMF.channelJoint skewBit rows)).apply_ne_top _)
      (ENNReal.div_ne_top (by norm_num) (by norm_num))).1
    norm_num [sndMarginal_apply, Fin.sum_univ_two, PMF.channelJoint_apply,
      rows, reverseBit_apply, skewBit, PMF.ofFintype_apply,
      ENNReal.toReal_add, ENNReal.toReal_mul]
    rw [ENNReal.toReal_add (by finiteness) (by finiteness)]
    norm_num [ENNReal.toReal_mul]

-- The actual structural witness, exact pair law, and information objective
-- come together from the S04 theorem, not merely a mismatch-mass equality.
example : IsCanonicalFunctionalRepresentation attainingTriple ∧
    fstSndMarginal attainingTriple = PMF.channelJoint skewBit rows ∧
    mutualInfoOf attainingTriple (fun z => z.2.1) (fun z => z.2.2) =
      entropy (sndMarginal (PMF.channelJoint skewBit rows)) -
        (1 / 3 : Real) * entropy skewBit := by
  simpa only [attainingTriple, attainingVectors, rowsTV] using
    maximalBinaryCanonicalJoint_attains skewBit rows

example : ∃ t : PMF (Fin 2 × Fin 2 × (Fin 2 → Fin 2)),
    IsFunctionalRepresentation t ∧
    fstSndMarginal t = PMF.channelJoint skewBit rows ∧
    mutualInfoOf t (fun z => z.2.1) (fun z => z.2.2) =
      entropy (sndMarginal (PMF.channelJoint skewBit rows)) -
        (1 / 3 : Real) * entropy skewBit := by
  simpa only [rowsTV] using exists_binary_information_maximizer skewBit rows

-- R13 combines an actual unseen-row discrepancy, a globally unused output,
-- an unrestricted Nat source, and a finite auxiliary in Type 1.
private def unseenRows : Fin 2 → PMF (Fin 3) := ![PMF.pure 0, PMF.pure 1]
private def unseenX (_ : Nat) : Fin 2 := 0
private def unseenY (_ : Nat) : Fin 3 := 0
private def unseenZ (_ : Nat) : ULift.{1} Unit := ⟨()⟩
private def unseenDecoder (_ : Fin 2 × ULift.{1} Unit) : Fin 3 := 0

-- Local test machinery follows the existing private C02 regression pattern.
private theorem constantInputIndependent {omega : Type s} {alpha : Type t}
    {gamma : Type a} (mu : PMF omega) (i : alpha) (Z : omega → gamma) :
    IsIndependentOf mu (fun _ => i) Z := by
  rw [isIndependentOf_iff_map_eq_indepProd]
  change mu.map (fun z => (i, Z z)) =
    indepProd (mu.map (Function.const omega i)) (mu.map Z)
  rw [PMF.map_const]
  simp [indepProd, PMF.map_comp, Function.comp_def]

private theorem unseenFR (mu : PMF Nat) :
    IsFunctionalRepresentationOf mu unseenX unseenY unseenZ := by
  apply (isFunctionalRepresentationOf_iff mu unseenX unseenY unseenZ).2
  exact ⟨constantInputIndependent mu 0 unseenZ, unseenDecoder, by intro z _; rfl⟩

private theorem unseenPair (mu : PMF Nat) :
    mu.map (fun z => (unseenX z, unseenY z)) =
      PMF.channelJoint (PMF.pure 0) unseenRows := by
  change mu.map (Function.const Nat ((0 : Fin 2), (0 : Fin 3))) = _
  rw [PMF.map_const]
  ext z
  rcases z with ⟨i, y⟩
  fin_cases i <;> fin_cases y <;> norm_num [PMF.channelJoint_apply, unseenRows]

private theorem unseenDecoderLaw (mu : PMF Nat) :
    mu.map (fun z => decoderVector unseenDecoder (unseenZ z)) =
      PMF.pure (fun _ : Fin 2 => (0 : Fin 3)) :=
  PMF.map_const mu (fun _ : Fin 2 => (0 : Fin 3))

private theorem unseenDisagreement (mu : PMF Nat) :
    (mu.map (fun z => decoderVector unseenDecoder (unseenZ z))).map
        (fun w => w 1) ≠ unseenRows 1 := by
  intro h
  have hAtom := congrArg (fun q : PMF (Fin 3) => q 0) h
  norm_num [unseenDecoderLaw, PMF.pure_map, unseenRows] at hAtom

-- The null output label is channel-wide; row 1 is unseen only by the input prior.
example : (∀ i, unseenRows i 2 = 0) ∧
    (1 : Fin 2) ∉ (PMF.pure (0 : Fin 2)).support := by
  constructor
  · intro i
    fin_cases i <;> norm_num [unseenRows] <;> decide
  · simp

-- All required facts occur in one consumer of the actual universal bound.
example (mu : PMF Nat) :
    IsFunctionalRepresentationOf mu unseenX unseenY unseenZ ∧
    mu.map (fun z => (unseenX z, unseenY z)) =
      PMF.channelJoint (PMF.pure 0) unseenRows ∧
    (mu.map (fun z => decoderVector unseenDecoder (unseenZ z))).map
        (fun w => w 1) ≠ unseenRows 1 ∧
    mutualInfoOf mu unseenY unseenZ ≤
      entropy (sndMarginal (PMF.channelJoint (PMF.pure 0) unseenRows)) -
        finiteTV (unseenRows 0) (unseenRows 1) * entropy (PMF.pure (0 : Fin 2)) := by
  exact ⟨unseenFR mu, unseenPair mu, unseenDisagreement mu,
    (unseenFR mu).mutualInfoOf_le_binary_bound (p := PMF.pure 0)
      (kappa := unseenRows) (unseenPair mu)⟩

-- Ambient TV=1 cannot be bounded by the original decoder's mismatch=0:
-- that vector law is not an all-row channel coupling.
example (mu : PMF Nat) : finiteTV (unseenRows 0) (unseenRows 1) = 1 ∧
    (mismatchMass ((mu.map (fun z => decoderVector unseenDecoder (unseenZ z))).map
      (finTwoArrowEquiv (Fin 3)))).toReal = 0 := by
  constructor
  · norm_num [finiteTV, Fin.sum_univ_succ, unseenRows,
      show (2 : Fin 3) ≠ 1 by decide]
  · rw [unseenDecoderLaw, PMF.pure_map]
    norm_num [mismatchMass, Fintype.sum_prod_type, Fin.sum_univ_succ,
      finTwoArrowEquiv]

-- Arbitrary supplied channel, either point prior, and any finite output universe.
example {beta : Type t} [Fintype beta] (i : Fin 2) (kappa : Fin 2 → PMF beta) :
    let t := canonicalJoint (PMF.pure i)
      ((maximalCoupling (kappa 0) (kappa 1)).map (finTwoArrowEquiv beta).symm)
    IsCanonicalFunctionalRepresentation t ∧
    fstSndMarginal t = PMF.channelJoint (PMF.pure i) kappa ∧
    mutualInfoOf t (fun z => z.2.1) (fun z => z.2.2) =
      entropy (sndMarginal (PMF.channelJoint (PMF.pure i) kappa)) := by
  simpa only [entropy_pure, mul_zero, sub_zero] using
    maximalBinaryCanonicalJoint_attains (PMF.pure i) kappa

-- Singleton output with an arbitrary prior: the attaining information is zero.
example (p : PMF (Fin 2)) :
    let kappa : Fin 2 → PMF Unit := fun _ => PMF.pure ()
    let t := canonicalJoint p
      ((maximalCoupling (kappa 0) (kappa 1)).map (finTwoArrowEquiv Unit).symm)
    IsCanonicalFunctionalRepresentation t ∧
    fstSndMarginal t = PMF.channelJoint p kappa ∧
    mutualInfoOf t (fun z => z.2.1) (fun z => z.2.2) = 0 := by
  have hTV : finiteTV (PMF.pure ()) (PMF.pure ()) = 0 :=
    (finiteTV_eq_zero_iff _ _).2 rfl
  have hOutput : sndMarginal (PMF.channelJoint p (fun _ => PMF.pure ())) =
      PMF.pure () := by
    change (PMF.channelJoint p (fun _ => PMF.pure ())).map Prod.snd = PMF.pure ()
    rw [PMF.channelJoint_map_snd, PMF.bind_const]
  simpa only [hTV, hOutput, entropy_pure, zero_mul, sub_zero] using
    maximalBinaryCanonicalJoint_attains p (fun _ => PMF.pure ())

end

end BinaryBoundTests

namespace BinaryEqualityTests

noncomputable section

universe s05u s05v s05w s05x s05y

-- R14: the same supported channel contract exposes the all-prior forward result
-- and the explicit-support iff; strictness consumes both inequality and iff.
example {beta : Type s05v} [Fintype beta] (p : PMF (Fin 2))
    (kappa : Fin 2 → PMF beta) (hs : IsSingularChannel kappa) :
    finiteTV (kappa 0) (kappa 1) * entropy p = mutualInfo (PMF.channelJoint p kappa) :=
  hs.binary_entropy_eq_mutualInfo p

private theorem skewBit_fullSupport : ∀ i, i ∈ skewBit.support := by
  intro i
  fin_cases i <;> norm_num [PMF.mem_support_iff, skewBit, PMF.ofFintype_apply]

private def deterministicRows : Fin 2 → PMF (Fin 2) := fun i => PMF.pure i

private theorem deterministicRows_singular : IsSingularChannel deterministicRows := by
  intro i j y hi hj
  fin_cases i <;> fin_cases j <;> fin_cases y <;> norm_num [deterministicRows] at *

example : (∀ i, i ∈ skewBit.support) ∧
    finiteTV (deterministicRows 0) (deterministicRows 1) * entropy skewBit =
      mutualInfo (PMF.channelJoint skewBit deterministicRows) :=
  ⟨skewBit_fullSupport, deterministicRows_singular.binary_entropy_eq_mutualInfo skewBit⟩

private theorem rows_not_singular : ¬ IsSingularChannel rows := by
  intro hSingular
  have h := hSingular 0 1 0
    (by norm_num [rows, skewBit, PMF.ofFintype_apply])
    (by norm_num [rows, reverseBit_apply])
  norm_num [rows, reverseBit_apply, skewBit, PMF.ofFintype_apply] at h
  have hReal := congrArg ENNReal.toReal h
  norm_num at hReal

example : mutualInfo (PMF.channelJoint skewBit rows) <
    finiteTV (rows 0) (rows 1) * entropy skewBit := by
  apply lt_of_le_of_ne (mutualInfo_channelJoint_le_binary_entropy skewBit rows)
  intro h
  exact rows_not_singular
    ((binary_entropy_eq_mutualInfo_iff_isSingular_of_fullSupport
      skewBit rows skewBit_fullSupport).1 h.symm)


private def fairBit : PMF (Fin 2) :=
  PMF.ofFintype (fun _ => (1 : ENNReal) / 2) (by
    apply (ENNReal.toReal_eq_one_iff _).1
    rw [ENNReal.toReal_sum]
    · norm_num [Fin.sum_univ_two]
    · intro i _
      exact ENNReal.div_ne_top (by norm_num) (by norm_num))

private def counterRows : Fin 2 → PMF (Fin 2) := ![fairBit, PMF.pure 0]

-- R15 has a genuinely nonsingular ambient channel, unlike R13's disjoint rows.
private theorem counterRows_not_singular : ¬ IsSingularChannel counterRows := by
  intro hSingular
  have h := hSingular 0 1 0
    (by norm_num [counterRows, fairBit, PMF.ofFintype_apply])
    (by norm_num [counterRows])
  have hReal := congrArg ENNReal.toReal h
  norm_num [counterRows, fairBit, PMF.ofFintype_apply] at hReal

private theorem pointJoint : PMF.channelJoint (PMF.pure 0) counterRows =
    indepProd (PMF.pure (0 : Fin 2)) fairBit := by
  simp [PMF.channelJoint, indepProd, counterRows]

private theorem pointInformation :
    mutualInfo (PMF.channelJoint (PMF.pure 0) counterRows) = 0 := by
  rw [pointJoint]
  exact (mutualInfo_eq_zero_iff_isIndependent _).2 (isIndependent_indepProd _ _)

example : ¬ IsSingularChannel counterRows ∧
    entropy (PMF.pure (0 : Fin 2)) = 0 ∧
    mutualInfo (PMF.channelJoint (PMF.pure 0) counterRows) = 0 ∧
    finiteTV (counterRows 0) (counterRows 1) * entropy (PMF.pure (0 : Fin 2)) =
      mutualInfo (PMF.channelJoint (PMF.pure 0) counterRows) := by
  refine ⟨counterRows_not_singular, entropy_pure _, pointInformation, ?_⟩
  rw [entropy_pure, mul_zero, pointInformation]

example : finiteTV (counterRows 0) (counterRows 1) = (1 / 2 : Real) := by
  norm_num [finiteTV, Fin.sum_univ_two, counterRows, fairBit, PMF.ofFintype_apply]


-- R16: all four source/value universes are independent. No source finiteness
-- is inferred from the input equivalence or the finite auxiliary hypothesis.
example {omega : Type s05u} {alpha : Type s05v} {beta : Type s05w}
    {gamma : Type s05x} [Fintype alpha] [Fintype beta] [Fintype gamma]
    (mu : PMF omega) (X : omega → alpha) (Y : omega → beta) (Z : omega → gamma)
    (e : alpha ≃ Fin 2) (p : PMF alpha) (kappa : alpha → PMF beta)
    (hFR : IsFunctionalRepresentationOf mu X Y Z)
    (hPair : mu.map (fun s => (X s, Y s)) = PMF.channelJoint p kappa) :
    mutualInfoOf mu Y Z ≤ entropyOf mu Y -
        finiteTV (kappa (e.symm 0)) (kappa (e.symm 1)) * entropyOf mu X ∧
    mutualInfoOf mu X Y ≤
        finiteTV (kappa (e.symm 0)) (kappa (e.symm 1)) * entropyOf mu X ∧
    (IsSingularChannel kappa →
      finiteTV (kappa (e.symm 0)) (kappa (e.symm 1)) * entropyOf mu X =
        mutualInfoOf mu X Y) ∧
    ((∀ a, a ∈ p.support) →
      (finiteTV (kappa (e.symm 0)) (kappa (e.symm 1)) * entropyOf mu X =
        mutualInfoOf mu X Y ↔ IsSingularChannel kappa)) := by
  refine ⟨hFR.mutualInfoOf_le_twoInput_bound e p kappa hPair,
    mutualInfoOf_le_twoInput_entropy e mu X Y p kappa hPair, ?_, ?_⟩
  · intro hs
    exact hs.twoInput_entropyOf_eq_mutualInfoOf e mu X Y p hPair
  · intro hp
    exact twoInput_entropyOf_eq_mutualInfoOf_iff_isSingular_of_fullSupport
      e mu X Y p kappa hPair hp

private def boolPrior : PMF Bool := skewBit.map finTwoEquiv

private theorem boolPrior_fullSupport : ∀ b, b ∈ boolPrior.support := by
  intro b
  exact (PMF.mem_support_map_iff _ _ _).2
    ⟨finTwoEquiv.symm b, skewBit_fullSupport _, finTwoEquiv.apply_symm_apply b⟩

private theorem boolPrior_roundtrip : boolPrior.map finTwoEquiv.symm = skewBit := by
  simp only [boolPrior, PMF.map_comp, Equiv.symm_comp_self, PMF.map_id]

-- The concrete Bool prior carries masses 1/3 and 2/3 in their original order.
example : boolPrior false = (1 : ENNReal) / 3 ∧
    boolPrior true = (2 : ENNReal) / 3 := by
  constructor
  · change boolPrior (finTwoEquiv 0) = _
    rw [boolPrior, PMF.map_apply_of_injective _ finTwoEquiv.injective]
    norm_num [skewBit, PMF.ofFintype_apply]
  · change boolPrior (finTwoEquiv 1) = _
    rw [boolPrior, PMF.map_apply_of_injective _ finTwoEquiv.injective]
    norm_num [skewBit, PMF.ofFintype_apply]

example : (PMF.channelJoint boolPrior boolRows).map (fun z => (finTwoEquiv.symm z.1, z.2)) =
    PMF.channelJoint skewBit rows := by
  rw [channelJoint_map_binaryInput, boolPrior_roundtrip]
  simp only [boolRows, Equiv.symm_symm, Equiv.symm_apply_apply]

example : entropy boolPrior = entropy skewBit ∧
    (∀ i, i ∈ (boolPrior.map finTwoEquiv.symm).support) := by
  refine ⟨entropy_map_equiv _ _, ?_⟩
  intro i
  exact (PMF.mem_support_map_iff _ _ _).2
    ⟨finTwoEquiv i, boolPrior_fullSupport _, finTwoEquiv.symm_apply_apply i⟩

example : mutualInfo (PMF.channelJoint boolPrior boolRows) ≤
    finiteTV (boolRows false) (boolRows true) * entropy boolPrior :=
  mutualInfo_channelJoint_le_twoInput_entropy finTwoEquiv.symm boolPrior boolRows

example : finiteTV (boolRows false) (boolRows true) * entropy boolPrior =
    mutualInfo (PMF.channelJoint boolPrior boolRows) ↔ IsSingularChannel boolRows :=
  twoInput_entropy_eq_mutualInfo_iff_isSingular_of_fullSupport
    finTwoEquiv.symm boolPrior boolRows boolPrior_fullSupport

-- The specified transported vector law, including its inverse coordinate map,
-- is consumed directly; the witness is not only an existential number.
example :
    let q := ((maximalCoupling (boolRows false) (boolRows true)).map
      (finTwoArrowEquiv (Fin 2)).symm).map (fun w b => w (finTwoEquiv.symm b))
    let t := canonicalJoint boolPrior q
    IsCanonicalFunctionalRepresentation t ∧
      fstSndMarginal t = PMF.channelJoint boolPrior boolRows ∧
      mutualInfoOf t (fun z => z.2.1) (fun z => z.2.2) =
        entropy (sndMarginal (PMF.channelJoint boolPrior boolRows)) -
          finiteTV (boolRows false) (boolRows true) * entropy boolPrior := by
  have h := maximalTwoInputCanonicalJoint_attains finTwoEquiv.symm boolPrior boolRows
  simp only [Equiv.symm_symm] at h
  -- Congruence identifies the native and classical finite vector enumerations.
  convert h <;> rfl

open scoped Classical in
example {alpha : Type s05u} {beta : Type s05v} [Fintype alpha] [Fintype beta]
    (e : alpha ≃ Fin 2) (p : PMF alpha) (kappa : alpha → PMF beta) :
    ∃ t : PMF (alpha × beta × (alpha → beta)), IsFunctionalRepresentation t ∧
      fstSndMarginal t = PMF.channelJoint p kappa ∧
      mutualInfoOf t (fun z => z.2.1) (fun z => z.2.2) =
        entropy (sndMarginal (PMF.channelJoint p kappa)) -
          finiteTV (kappa (e.symm 0)) (kappa (e.symm 1)) * entropy p :=
  exists_twoInput_information_maximizer e p kappa


-- No generic mutual-information invariance theorem is duplicated in production.
-- This private consumer composes the pinned entropy invariances directly.
private theorem information_injective {omega : Type s05u} {alpha : Type s05v}
    {alpha' : Type s05w} {beta : Type s05x} {beta' : Type s05y}
    [Fintype alpha] [Fintype alpha'] [Fintype beta] [Fintype beta']
    (mu : PMF omega) (X : omega → alpha) (Y : omega → beta)
    (f : alpha → alpha') (g : beta → beta')
    (hf : Function.Injective f) (hg : Function.Injective g) :
    mutualInfoOf mu (fun s => f (X s)) (fun s => g (Y s)) = mutualInfoOf mu X Y := by
  have hX := entropyOf_comp_injective mu X hf
  have hY := entropyOf_comp_injective mu Y hg
  have hXY := entropyOf_comp_injective mu (fun s => (X s, Y s))
    (f := fun p => (f p.1, g p.2)) (by
      intro a b hab
      exact Prod.ext (hf (congrArg Prod.fst hab)) (hg (congrArg Prod.snd hab)))
  change jointEntropyOf mu (fun s => f (X s)) (fun s => g (Y s)) =
    jointEntropyOf mu X Y at hXY
  rw [mutualInfoOf_eq, mutualInfoOf_eq, hX, hY, hXY]

private theorem channelJoint_outputMap {alpha : Type s05u} {beta : Type s05v}
    {gamma : Type s05w} (p : PMF alpha) (kappa : alpha → PMF beta) (f : beta → gamma) :
    (PMF.channelJoint p kappa).map (fun z => (z.1, f z.2)) =
      PMF.channelJoint p (fun i => (kappa i).map f) := by
  simp only [PMF.channelJoint, PMF.map_bind, PMF.map_comp, Function.comp_def]

private theorem mappedOutputMarginal {alpha : Type s05u} {beta : Type s05v}
    {gamma : Type s05w} (p : PMF alpha) (kappa : alpha → PMF beta) (f : beta → gamma) :
    sndMarginal (PMF.channelJoint p (fun i => (kappa i).map f)) =
      (sndMarginal (PMF.channelJoint p kappa)).map f := by
  rw [← channelJoint_outputMap]
  simp only [sndMarginal, PMF.map_comp, Function.comp_def]

-- R17 preserves the objective and the actual mapped witness information.
private theorem outputTransport {beta : Type s05u} {gamma : Type s05v}
    [Fintype beta] [Fintype gamma]
    (p : PMF (Fin 2)) (kappa : Fin 2 → PMF beta) (f : beta → gamma)
    (hf : Function.Injective f) (t : PMF (Fin 2 × beta × (Fin 2 → beta))) :
    finiteTV ((kappa 0).map f) ((kappa 1).map f) = finiteTV (kappa 0) (kappa 1) ∧
    entropy (sndMarginal (PMF.channelJoint p (fun i => (kappa i).map f))) -
        finiteTV ((kappa 0).map f) ((kappa 1).map f) * entropy p =
      entropy (sndMarginal (PMF.channelJoint p kappa)) -
        finiteTV (kappa 0) (kappa 1) * entropy p ∧
    mutualInfoOf (t.map (fun s => (s.1, f s.2.1, fun i => f (s.2.2 i))))
        (fun s => s.2.1) (fun s => s.2.2) =
      mutualInfoOf t (fun s => s.2.1) (fun s => s.2.2) := by
  refine ⟨finiteTV_map_injective _ _ hf, ?_, ?_⟩
  · rw [finiteTV_map_injective _ _ hf, mappedOutputMarginal,
      entropy_map_injective _ hf]
  · have hg : Function.Injective (fun a : Fin 2 → beta => fun i => f (a i)) := by
      intro a b hab
      funext i
      exact hf (congrFun hab i)
    simpa only [mutualInfoOf, PMF.map_comp, Function.comp_def] using
      information_injective t (fun s => s.2.1) (fun s => s.2.2) f
        (fun a : Fin 2 → beta => fun i => f (a i)) hf hg

private theorem canonicalJoint_outputMap {alpha : Type s05u} {beta : Type s05v}
    {gamma : Type s05w} (p : PMF alpha) (q : PMF (alpha → beta)) (f : beta → gamma) :
    (canonicalJoint p q).map (fun s => (s.1, f s.2.1, fun i => f (s.2.2 i))) =
      canonicalJoint p (q.map (fun a => fun i => f (a i))) := by
  simp only [canonicalJoint, indepProd, PMF.map_comp, PMF.map_bind,
    Function.comp_def]

private def mappedMaximalTriple {beta : Type s05u} {gamma : Type s05v} [Fintype beta]
    (p : PMF (Fin 2)) (kappa : Fin 2 → PMF beta) (f : beta → gamma) :=
  (canonicalJoint p
    ((maximalCoupling (kappa 0) (kappa 1)).map (finTwoArrowEquiv beta).symm)).map
      (fun s => (s.1, f s.2.1, fun i => f (s.2.2 i)))

-- Strengthened R17: an actual mapped S04 witness remains canonical, retains the
-- exact mapped pair, and attains the mapped objective, including unused labels.
private theorem mappedMaximalTriple_attains {beta : Type s05u} {gamma : Type s05v}
    [Fintype beta] [Fintype gamma] (p : PMF (Fin 2)) (kappa : Fin 2 → PMF beta)
    (f : beta → gamma) (hf : Function.Injective f) :
    IsCanonicalFunctionalRepresentation (mappedMaximalTriple p kappa f) ∧
    fstSndMarginal (mappedMaximalTriple p kappa f) =
      PMF.channelJoint p (fun i => (kappa i).map f) ∧
    mutualInfoOf (mappedMaximalTriple p kappa f) (fun s => s.2.1) (fun s => s.2.2) =
      entropy (sndMarginal (PMF.channelJoint p (fun i => (kappa i).map f))) -
        finiteTV ((kappa 0).map f) ((kappa 1).map f) * entropy p := by
  let q := (maximalCoupling (kappa 0) (kappa 1)).map (finTwoArrowEquiv beta).symm
  let t := canonicalJoint p q
  have hOriginal : IsCanonicalFunctionalRepresentation t ∧
      fstSndMarginal t = PMF.channelJoint p kappa ∧
      mutualInfoOf t (fun s => s.2.1) (fun s => s.2.2) =
        entropy (sndMarginal (PMF.channelJoint p kappa)) -
          finiteTV (kappa 0) (kappa 1) * entropy p :=
    maximalBinaryCanonicalJoint_attains p kappa
  refine ⟨?_, ?_, ?_⟩
  · rw [mappedMaximalTriple, canonicalJoint_outputMap]
    exact isCanonicalFunctionalRepresentation_canonicalJoint _ _
  · change fstSndMarginal
        (t.map (fun s => (s.1, f s.2.1, fun i => f (s.2.2 i)))) = _
    calc
      _ = (fstSndMarginal t).map (fun z => (z.1, f z.2)) := by
        simp only [fstSndMarginal, PMF.map_comp, Function.comp_def]
      _ = _ := by rw [hOriginal.2.1, channelJoint_outputMap]
  · calc
      _ = mutualInfoOf t (fun s => s.2.1) (fun s => s.2.2) :=
        (outputTransport p kappa f hf t).2.2
      _ = _ := hOriginal.2.2
      _ = _ := (outputTransport p kappa f hf t).2.1.symm

private def outputInclusion (i : Fin 2) : Fin 3 :=
  ⟨i.val, Nat.lt_trans i.isLt (by decide)⟩

private theorem outputInclusion_injective : Function.Injective outputInclusion := by
  intro i j h
  exact Fin.ext (congrArg (fun z : Fin 3 => z.val) h)

example (p : PMF (Fin 2)) :
    IsCanonicalFunctionalRepresentation (mappedMaximalTriple p counterRows outputInclusion) ∧
    fstSndMarginal (mappedMaximalTriple p counterRows outputInclusion) =
      PMF.channelJoint p (fun i => (counterRows i).map outputInclusion) ∧
    mutualInfoOf (mappedMaximalTriple p counterRows outputInclusion)
        (fun s => s.2.1) (fun s => s.2.2) =
      entropy (sndMarginal (PMF.channelJoint p (fun i => (counterRows i).map outputInclusion))) -
        finiteTV ((counterRows 0).map outputInclusion) ((counterRows 1).map outputInclusion) *
          entropy p :=
  mappedMaximalTriple_attains p counterRows outputInclusion outputInclusion_injective

example : ∀ i, (counterRows i).map outputInclusion 2 = 0 := by
  intro i
  apply PMF.map_apply_eq_zero_of_notMem_range
  rintro ⟨j, hj⟩
  have hval := congrArg Fin.val hj
  have hjlt := j.isLt
  change j.val = 2 at hval
  omega

-- Both row laws start on the common subtype. No ambient restriction is assumed.
example (kappa : Fin 2 → PMF {z : Fin 3 // z < 2}) :
    finiteTV ((kappa 0).map Subtype.val) ((kappa 1).map Subtype.val) =
      finiteTV (kappa 0) (kappa 1) ∧
    (∀ i, (kappa i).map Subtype.val 2 = 0) := by
  refine ⟨finiteTV_map_injective _ _ Subtype.val_injective, ?_⟩
  intro i
  apply PMF.map_apply_eq_zero_of_notMem_range
  rintro ⟨z, hz⟩
  have hlt := z.property
  rw [hz] at hlt
  exact (lt_irrefl _ hlt)

example (p : PMF (Fin 2)) (kappa : Fin 2 → PMF {z : Fin 3 // z < 2}) :
    IsCanonicalFunctionalRepresentation (mappedMaximalTriple p kappa Subtype.val) ∧
    fstSndMarginal (mappedMaximalTriple p kappa Subtype.val) =
      PMF.channelJoint p (fun i => (kappa i).map Subtype.val) ∧
    mutualInfoOf (mappedMaximalTriple p kappa Subtype.val)
        (fun s => s.2.1) (fun s => s.2.2) =
      entropy (sndMarginal (PMF.channelJoint p (fun i => (kappa i).map Subtype.val))) -
        finiteTV ((kappa 0).map Subtype.val) ((kappa 1).map Subtype.val) * entropy p :=
  mappedMaximalTriple_attains p kappa Subtype.val Subtype.val_injective

-- R17 consumes the S05 inequality and equality API on the mapped channel,
-- preserving the original scalar and interpreting singularity on original rows.
example {beta : Type s05u} {gamma : Type s05v} [Fintype beta] [Fintype gamma]
    (p : PMF (Fin 2)) (kappa : Fin 2 → PMF beta) (f : beta → gamma)
    (hf : Function.Injective f) (hp : ∀ i, i ∈ p.support) :
    mutualInfo (PMF.channelJoint p (fun i => (kappa i).map f)) ≤
        finiteTV (kappa 0) (kappa 1) * entropy p ∧
    (finiteTV (kappa 0) (kappa 1) * entropy p =
        mutualInfo (PMF.channelJoint p (fun i => (kappa i).map f)) ↔
      IsSingularChannel kappa) := by
  constructor
  · simpa only [finiteTV_map_injective _ _ hf] using
      mutualInfo_channelJoint_le_binary_entropy p (fun i => (kappa i).map f)
  · simpa only [finiteTV_map_injective _ _ hf, isSingularChannel_map_iff kappa f hf] using
      binary_entropy_eq_mutualInfo_iff_isSingular_of_fullSupport p
        (fun i => (kappa i).map f) hp

example {beta : Type s05u} {gamma : Type s05v} [Fintype beta] [Fintype gamma]
    (p : PMF (Fin 2)) (kappa : Fin 2 → PMF beta) (f : beta → gamma)
    (hf : Function.Injective f) (hs : IsSingularChannel kappa) :
    finiteTV (kappa 0) (kappa 1) * entropy p =
      mutualInfo (PMF.channelJoint p (fun i => (kappa i).map f)) := by
  simpa only [finiteTV_map_injective _ _ hf] using
    ((isSingularChannel_map_iff kappa f hf).2 hs).binary_entropy_eq_mutualInfo p

end

end BinaryEqualityTests

end PerfectFunctionalRepresentations
