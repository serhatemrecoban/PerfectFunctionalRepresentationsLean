import PerfectFunctionalRepresentations.Probability.FiniteCoupling
import LeanInfoTheory.Shannon.SemanticBridge.Product
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum

/-!
# Finite-TV and overlap regressions

R01-R04 exercise the S01 foundation through its independently importable API.
The partial-overlap fixtures have a zero atom and use exact rational masses.
Anonymous consumers also check the residual and conversion surface for later
C04 steps. R05 checks diagonal couplings; R06 checks a strictly nonmaximal
independent fair coupling. R07-R10 check the explicit maximal coupling,
including both complete partial-overlap fixtures, endpoints and support.
These regressions remain separately importable.
-/

namespace PerfectFunctionalRepresentations

open LeanInfoTheory.Shannon
open scoped BigOperators ENNReal

noncomputable section

universe u

section General

variable {beta : Type u} [Fintype beta] (p q : PMF beta)

/-- R01: arbitrary identical laws have zero distance. -/
example : finiteTV p p = 0 := (finiteTV_eq_zero_iff p p).2 rfl

/-- R01: every atom contributes to the common mass, including zero atoms. -/
example : overlapMass p p = 1 := by
  simpa [overlapMass] using p.tsum_coe

example : (1 : ℝ≥0∞) - overlapMass p q ≤ 1 := tsub_le_self

example : overlapMass p q + (1 - overlapMass p q) = 1 :=
  add_tsub_cancel_of_le (overlapMass_le_one p q)

example : (1 : ℝ≥0∞) - overlapMass p q ≠ ∞ :=
  ENNReal.sub_ne_top ENNReal.one_ne_top

example : ∑ y, (p y - min (p y) (q y)) = 1 - overlapMass p q :=
  sum_sub_min_eq_one_sub_overlapMass p q

example : ∑ y, (q y - min (p y) (q y)) = 1 - overlapMass p q := by
  simpa only [min_comm, overlapMass_comm q p] using sum_sub_min_eq_one_sub_overlapMass q p

example : finiteTV p q = ∑ y, (q y - p y).toReal := by
  rw [finiteTV_comm, finiteTV_eq_sum_tsub_toReal]

example : finiteTV p q = 1 - ∑ y, min (p y).toReal (q y).toReal := by
  rw [finiteTV_eq_one_sub_overlap_toReal, overlapMass_toReal]

example : finiteTV p q = 1 ↔ Disjoint p.support q.support := by
  rw [finiteTV_eq_one_iff, overlapMass_eq_zero_iff_disjoint]

end General

/-- R02: the literal half-L1 formula on distinct pure laws gives one. -/
example : finiteTV (PMF.pure (0 : Fin 2)) (PMF.pure (1 : Fin 2)) = 1 := by
  norm_num [finiteTV, Fin.sum_univ_succ, PMF.pure_apply]

example : overlapMass (PMF.pure (0 : Fin 2)) (PMF.pure (1 : Fin 2)) = 0 := by
  norm_num [overlapMass, Fin.sum_univ_succ, PMF.pure_apply]

example : Disjoint (PMF.pure (0 : Fin 2)).support (PMF.pure (1 : Fin 2)).support := by
  simp

private def partialP : PMF (Fin 3) :=
  PMF.ofFintype (fun i => if i.val = 2 then 0 else (1 : ENNReal) / 2) (by
    simpa [Fin.sum_univ_succ] using ENNReal.add_halves (1 : ENNReal))

private def partialQ : PMF (Fin 3) :=
  PMF.ofFintype (fun i => if i.val = 2 then (1 : ENNReal) / 2 else 1 / 4) (by
    apply (ENNReal.toReal_eq_one_iff _).1
    rw [ENNReal.toReal_sum]
    · norm_num [Fin.sum_univ_succ]
    · intro i _
      split <;> exact ENNReal.div_ne_top (by norm_num) (by norm_num))

/-- R03: literal half-L1 distance for `(1/2,1/2,0)` and `(1/4,1/4,1/2)`. -/
example : finiteTV partialP partialQ = 1 / 2 := by
  norm_num [finiteTV, partialP, partialQ, PMF.ofFintype_apply, Fin.sum_univ_succ]

example : overlapMass partialP partialQ = (1 : ENNReal) / 2 := by
  apply (ENNReal.toReal_eq_toReal_iff' (overlapMass_ne_top partialP partialQ)
    (ENNReal.div_ne_top ENNReal.one_ne_top (by norm_num))).1
  rw [overlapMass_toReal]
  norm_num [partialP, partialQ, PMF.ofFintype_apply, Fin.sum_univ_succ]

example : ∑ i, (partialP i - partialQ i).toReal = (1 / 2 : Real) := by
  norm_num [partialP, partialQ, PMF.ofFintype_apply, Fin.sum_univ_succ]

example : ∑ i, (partialQ i - partialP i).toReal = (1 / 2 : Real) := by
  have hquarter : (4 : ENNReal)⁻¹ ≤ (2 : ENNReal)⁻¹ := by
    simpa only [one_div] using
      ENNReal.div_le_div_left (by norm_num : (2 : ENNReal) ≤ 4) 1
  norm_num [partialP, partialQ, PMF.ofFintype_apply, Fin.sum_univ_succ,
    tsub_eq_zero_of_le hquarter]

/-- R04: singleton alphabets carry only one law, so distance is zero. -/
example (p q : PMF (Fin 1)) : finiteTV p q = 0 := by
  apply (finiteTV_eq_zero_iff p q).2
  ext x
  rw [Fin.eq_zero x]
  have hp := p.tsum_coe
  have hq := q.tsum_coe
  simpa [tsum_fintype, Fin.sum_univ_succ] using hp.trans hq.symm

/-- R04: the empty case is impossibility, not a fabricated PMF. -/
example : IsEmpty (PMF Empty) := by
  refine ⟨fun p => ?_⟩
  obtain ⟨x, _⟩ := p.support_nonempty
  exact isEmptyElim x

section Diagonal

variable {beta : Type u} [Fintype beta] (p : PMF beta)

/-- R05: the diagonal law has both requested marginals for arbitrary finite `p`. -/
example : IsCoupling p p (p.map fun y => (y, y)) := by
  constructor
  · simpa only [PMF.map_id, id_eq] using fstMarginal_map_pair p id id
  · simpa only [PMF.map_id, id_eq] using sndMarginal_map_pair p id id

private theorem diagonal_agreement :
    (∑ y, (p.map fun a => (a, a)) (y, y)) = 1 := by
  simp_rw [PMF.map_apply_of_injective p (f := fun y : beta => (y, y))
    (fun _ _ h => congrArg Prod.fst h)]
  simpa using p.tsum_coe

/-- R05: exact diagonal agreement and the mismatch complement include zero atoms. -/
example : mismatchMass (p.map fun y => (y, y)) = 0 ∧
    (∑ y, (p.map fun a => (a, a)) (y, y)) = 1 := by
  constructor
  · rw [mismatchMass_eq_one_sub_diagonal, diagonal_agreement, tsub_self]
  · exact diagonal_agreement p

/-- R05: consume the event boundary and separately compute its diagonal preimage. -/
example : mismatchMass (p.map fun y => (y, y)) =
      (p.map fun y => (y, y)).toOuterMeasure {t | t.1 ≠ t.2} ∧
    (p.map fun y => (y, y)).toOuterMeasure {t | t.1 ≠ t.2} = 0 := by
  refine ⟨mismatchMass_eq_toOuterMeasure _, ?_⟩
  rw [PMF.toOuterMeasure_map_apply]
  simp

end Diagonal

private def fair : PMF (Fin 2) :=
  PMF.ofFintype (fun _ => (1 : ENNReal) / 2) (by
    simpa only [Fin.sum_univ_succ, Fin.sum_univ_zero, add_zero] using
      ENNReal.add_halves (1 : ENNReal))

private theorem fair_indep_coupling : IsCoupling fair fair (indepProd fair fair) :=
  ⟨fstMarginal_indepProd _ _, sndMarginal_indepProd _ _⟩

private theorem fair_indep_mismatch_real :
    (mismatchMass (indepProd fair fair)).toReal = (1 / 2 : Real) := by
  rw [mismatchMass_toReal]
  norm_num [Fintype.sum_prod_type, Fin.sum_univ_succ, indepProd_apply,
    fair, PMF.ofFintype_apply]

/-- R06: independent fair identical laws are a coupling with exact mismatch `1/2`. -/
example : IsCoupling fair fair (indepProd fair fair) ∧
    mismatchMass (indepProd fair fair) = (1 : ENNReal) / 2 := by
  refine ⟨fair_indep_coupling, ?_⟩
  apply (ENNReal.toReal_eq_toReal_iff' (mismatchMass_ne_top _)
    (ENNReal.div_ne_top ENNReal.one_ne_top (by norm_num))).1
  simpa using fair_indep_mismatch_real

/-- R06: the universal bound is strictly below this independent coupling's mismatch. -/
example : finiteTV fair fair = 0 ∧
    finiteTV fair fair ≤ (mismatchMass (indepProd fair fair)).toReal ∧
    finiteTV fair fair < (mismatchMass (indepProd fair fair)).toReal := by
  have hzero : finiteTV fair fair = 0 := (finiteTV_eq_zero_iff _ _).2 rfl
  refine ⟨hzero, fair_indep_coupling.finiteTV_le_mismatchMass_toReal, ?_⟩
  rw [hzero, fair_indep_mismatch_real]
  norm_num

end

noncomputable section

universe v

section MaximalGeneral

variable {beta : Type u} [Fintype beta] (p q : PMF beta)

/-- R07: identical laws have zero residual denominator and the specified diagonal law. -/
example : (1 : ENNReal) - overlapMass p p = 0 ∧
    maximalCoupling p p = p.map (fun y => (y, y)) ∧
    mismatchMass (maximalCoupling p p) = 0 := by
  have ho : overlapMass p p = 1 := by simpa [overlapMass] using p.tsum_coe
  exact ⟨by rw [ho, tsub_self], maximalCoupling_self p,
    by rw [mismatchMass_maximalCoupling, ho, tsub_self]⟩

/-- R07: a zero residual forces equal laws and the same diagonal construction. -/
example (hd : (1 : ENNReal) - overlapMass p q = 0) :
    p = q ∧ maximalCoupling p q = p.map (fun y => (y, y)) := by
  have hpq : p = q := (finiteTV_eq_zero_iff p q).1 (by
    rw [finiteTV_eq_sub_overlap_toReal, hd, ENNReal.toReal_zero])
  exact ⟨hpq, by rw [hpq, maximalCoupling_self]⟩

/-- R08: every disjoint pair attains mismatch one through the existing product. -/
example (h : Disjoint p.support q.support) :
    maximalCoupling p q = indepProd p q ∧
    mismatchMass (maximalCoupling p q) = 1 ∧ finiteTV p q = 1 := by
  have ho : overlapMass p q = 0 := (overlapMass_eq_zero_iff_disjoint p q).2 h
  exact ⟨maximalCoupling_eq_indepProd_of_overlapMass_eq_zero p q ho,
    by rw [mismatchMass_maximalCoupling, ho, tsub_zero],
    (finiteTV_eq_one_iff p q).2 ho⟩

/-- The full atom contract saturates both fibers at every equal-mass coordinate. -/
example (y z : beta) (hy : p y = q y) (hne : y ≠ z) :
    maximalCoupling p q (y, z) = 0 ∧ maximalCoupling p q (z, y) = 0 ∧
    maximalCoupling p q (y, y) = p y := by
  classical
  refine ⟨?_, ?_, ?_⟩
  · rw [maximalCoupling_apply]
    simp [hne, hy]
  · rw [maximalCoupling_apply]
    simp [hne.symm, hy]
  · rw [maximalCoupling_apply_diag, hy, min_self]

/-- Equal positive masses remain on their diagonal atom. -/
example (y : beta) (hy : p y = q y) (hpos : 0 < p y) :
    maximalCoupling p q (y, y) = p y ∧ 0 < maximalCoupling p q (y, y) := by
  have hd : maximalCoupling p q (y, y) = p y := by
    rw [maximalCoupling_apply_diag, hy, min_self]
  exact ⟨hd, by rw [hd]; exact hpos⟩

/-- Strict residual support implies a positive common residual denominator. -/
example (y z : beta) (hne : y ≠ z) :
    (0 < maximalCoupling p q (y, z) ↔ q y < p y ∧ p z < q z) ∧
    ((q y < p y ∧ p z < q z) → 0 < (1 : ENNReal) - overlapMass p q) := by
  refine ⟨maximalCoupling_apply_pos_iff_of_ne p q hne, ?_⟩
  intro h
  apply pos_iff_ne_zero.2
  intro hd
  have hpq : p = q := (finiteTV_eq_zero_iff p q).1 (by
    rw [finiteTV_eq_sub_overlap_toReal, hd, ENNReal.toReal_zero])
  exact (ne_of_lt h.1) (congrArg (fun r : PMF beta => r y) hpq).symm

/-- Existing marginal support lemmas ensure no unused first or second label gains mass. -/
example (y z : beta) (h : p y = 0 ∨ q z = 0) : maximalCoupling p q (y, z) = 0 := by
  have hc := isCoupling_maximalCoupling p q
  rcases h with hy | hz
  · exact apply_eq_zero_of_fstMarginal_eq_zero _ (by simpa [hc.1] using hy) z
  · exact apply_eq_zero_of_sndMarginal_eq_zero _ y (by simpa [hc.2] using hz)

/-- The complete support lies within the product of the two marginal supports. -/
example : (maximalCoupling p q).support ⊆ p.support ×ˢ q.support := by
  rintro ⟨y, z⟩ ht
  have hc := isCoupling_maximalCoupling p q
  have hn : maximalCoupling p q (y, z) ≠ 0 := (PMF.mem_support_iff _ _).1 ht
  constructor
  · simpa only [PMF.mem_support_iff, hc.1] using fstMarginal_ne_zero_of_apply_ne_zero _ hn
  · simpa only [PMF.mem_support_iff, hc.2] using sndMarginal_ne_zero_of_apply_ne_zero _ hn

end MaximalGeneral

/-- R08: distinct pure laws on a larger alphabet leave unused labels empty. -/
example :
    maximalCoupling (PMF.pure (0 : Fin 3)) (PMF.pure (1 : Fin 3)) =
      indepProd (PMF.pure (0 : Fin 3)) (PMF.pure (1 : Fin 3)) ∧
    mismatchMass (maximalCoupling (PMF.pure (0 : Fin 3)) (PMF.pure (1 : Fin 3))) = 1 ∧
    (∀ z, maximalCoupling (PMF.pure (0 : Fin 3)) (PMF.pure (1 : Fin 3)) (2, z) = 0) ∧
    (∀ y, maximalCoupling (PMF.pure (0 : Fin 3)) (PMF.pure (1 : Fin 3)) (y, 2) = 0) := by
  have ho : overlapMass (PMF.pure (0 : Fin 3)) (PMF.pure (1 : Fin 3)) = 0 := by
    norm_num [overlapMass, Fin.sum_univ_succ, PMF.pure_apply]
  have hg := maximalCoupling_eq_indepProd_of_overlapMass_eq_zero
    (PMF.pure (0 : Fin 3)) (PMF.pure (1 : Fin 3)) ho
  refine ⟨hg, ?_, ?_, ?_⟩
  · rw [mismatchMass_maximalCoupling, ho, tsub_zero]
  · intro z
    simp [hg, indepProd_apply, PMF.pure_apply]
  · intro y
    simp [hg, indepProd_apply, PMF.pure_apply]

/-- R10: any singleton pair gives the same diagonal law, without an `Inhabited` parameter. -/
example (p q : PMF (Fin 1)) :
    IsCoupling p q (maximalCoupling p q) ∧
    maximalCoupling p q = p.map (fun y => (y, y)) := by
  have hpq : p = q := by
    ext x
    rw [Fin.eq_zero x]
    have hp := p.tsum_coe
    have hq := q.tsum_coe
    simpa [tsum_fintype, Fin.sum_univ_succ] using hp.trans hq.symm
  exact ⟨isCoupling_maximalCoupling p q, by rw [← hpq, maximalCoupling_self]⟩

/-- R10: the empty alphabet still has no law to supply to the constructor. -/
example (p : PMF Empty) : False := by
  obtain ⟨x, _⟩ := p.support_nonempty
  exact isEmptyElim x

open scoped Classical in
private theorem maximal_atom_toReal {beta : Type u} [Fintype beta]
    (p q : PMF beta) (y z : beta) :
    (maximalCoupling p q (y, z)).toReal =
      (if y = z then min (p y).toReal (q y).toReal else 0) +
      ((p y).toReal - min (p y).toReal (q y).toReal) *
      ((q z).toReal - min (p z).toReal (q z).toReal) /
      (1 - (overlapMass p q).toReal) := by
  classical
  have hf := (maximalCoupling p q).apply_ne_top (y, z)
  rw [maximalCoupling_apply] at hf
  rw [maximalCoupling_apply,
    ENNReal.toReal_add (ENNReal.add_ne_top.mp hf).1 (ENNReal.add_ne_top.mp hf).2]
  simp only [apply_ite ENNReal.toReal, ENNReal.toReal_zero,
    ENNReal.toReal_div, ENNReal.toReal_mul,
    ENNReal.toReal_sub_of_le (min_le_left _ _) (p.apply_ne_top y),
    ENNReal.toReal_sub_of_le (min_le_right _ _) (q.apply_ne_top z),
    ENNReal.toReal_sub_of_le (overlapMass_le_one p q) ENNReal.one_ne_top,
    ENNReal.toReal_min (p.apply_ne_top y) (q.apply_ne_top y),
    ENNReal.toReal_min (p.apply_ne_top z) (q.apply_ne_top z), ENNReal.toReal_one]

private theorem partial_overlap_mass : overlapMass partialP partialQ = (1 : ENNReal) / 2 := by
  apply (ENNReal.toReal_eq_toReal_iff' (overlapMass_ne_top partialP partialQ)
    (ENNReal.div_ne_top ENNReal.one_ne_top (by norm_num))).1
  rw [overlapMass_toReal]
  norm_num [partialP, partialQ, PMF.ofFintype_apply, Fin.sum_univ_succ]

private def partialExpected (y z : Fin 3) : ENNReal :=
  if y.val < 2 ∧ (z = y ∨ z.val = 2) then 1 / 4 else 0

private theorem partialExpected_ne_top (y z : Fin 3) : partialExpected y z ≠ ∞ := by
  simp only [partialExpected]
  split
  · exact ENNReal.div_ne_top ENNReal.one_ne_top (by norm_num)
  · exact ENNReal.zero_ne_top

/-- R09: every atom of the original three-point fixture, including its unused row. -/
private theorem partial_witness_atoms (y z : Fin 3) :
    maximalCoupling partialP partialQ (y, z) = partialExpected y z := by
  apply (ENNReal.toReal_eq_toReal_iff' ((maximalCoupling partialP partialQ).apply_ne_top _)
    (partialExpected_ne_top y z)).1
  rw [maximal_atom_toReal, partial_overlap_mass]
  fin_cases y <;> fin_cases z <;>
    norm_num [partialExpected, partialP, partialQ, PMF.ofFintype_apply]

/-- R09: enumeration of the complete three-point witness sums to exactly one. -/
example : (∑ t, maximalCoupling partialP partialQ t) = 1 := by
  simp_rw [show ∀ t : Fin 3 × Fin 3, maximalCoupling partialP partialQ t =
    partialExpected t.1 t.2 from fun t => partial_witness_atoms t.1 t.2]
  apply (ENNReal.toReal_eq_one_iff _).1
  rw [ENNReal.toReal_sum (fun t _ => partialExpected_ne_top t.1 t.2)]
  norm_num [Fintype.sum_prod_type, Fin.sum_univ_succ, partialExpected]

/-- R09: both exact marginals and the original fixture's exact mismatch. -/
example : fstMarginal (maximalCoupling partialP partialQ) = partialP ∧
    sndMarginal (maximalCoupling partialP partialQ) = partialQ ∧
    mismatchMass (maximalCoupling partialP partialQ) = (1 : ENNReal) / 2 := by
  refine ⟨(isCoupling_maximalCoupling _ _).1, (isCoupling_maximalCoupling _ _).2, ?_⟩
  apply (ENNReal.toReal_eq_toReal_iff' (mismatchMass_ne_top _)
    (ENNReal.div_ne_top ENNReal.one_ne_top (by norm_num))).1
  rw [mismatchMass_maximalCoupling_toReal]
  norm_num [finiteTV, partialP, partialQ, PMF.ofFintype_apply, Fin.sum_univ_succ]

private def unevenP : PMF (Fin 4) :=
  PMF.ofFintype (fun i => if i.val = 0 then (1 : ENNReal) / 2
    else if i.val = 1 then 1 / 4 else 1 / 8) (by
    apply (ENNReal.toReal_eq_one_iff _).1
    rw [ENNReal.toReal_sum]
    · norm_num [Fin.sum_univ_succ]
    · intro i _
      split
      · exact ENNReal.div_ne_top (by norm_num) (by norm_num)
      · split <;> exact ENNReal.div_ne_top (by norm_num) (by norm_num))

private def unevenQ : PMF (Fin 4) :=
  PMF.ofFintype (fun i => if i.val = 1 then (1 : ENNReal) / 8
    else if i.val = 3 then 3 / 8 else 1 / 4) (by
    apply (ENNReal.toReal_eq_one_iff _).1
    rw [ENNReal.toReal_sum]
    · norm_num [Fin.sum_univ_succ]
    · intro i _
      split
      · exact ENNReal.div_ne_top (by norm_num) (by norm_num)
      · split <;> exact ENNReal.div_ne_top (by norm_num) (by norm_num))

private theorem uneven_overlap : overlapMass unevenP unevenQ = (5 : ENNReal) / 8 := by
  apply (ENNReal.toReal_eq_toReal_iff' (overlapMass_ne_top _ _)
    (ENNReal.div_ne_top (by norm_num) (by norm_num))).1
  rw [overlapMass_toReal]
  norm_num [unevenP, unevenQ, PMF.ofFintype_apply, Fin.sum_univ_succ]

private theorem uneven_tv : finiteTV unevenP unevenQ = (3 / 8 : Real) := by
  norm_num [finiteTV, unevenP, unevenQ, PMF.ofFintype_apply, Fin.sum_univ_succ]

private def unevenExpected (y z : Fin 4) : ENNReal :=
  if y.val = z.val then (if y.val = 0 then 1 / 4 else 1 / 8)
  else if y.val = 0 ∧ z.val = 2 then 1 / 12
  else if y.val = 0 ∧ z.val = 3 then 1 / 6
  else if y.val = 1 ∧ z.val = 2 then 1 / 24
  else if y.val = 1 ∧ z.val = 3 then 1 / 12 else 0

private theorem unevenExpected_ne_top (y z : Fin 4) : unevenExpected y z ≠ ∞ := by
  fin_cases y <;> fin_cases z <;> norm_num [unevenExpected]

/-- R09: the complete unequal-weight witness tests all four residual products. -/
private theorem uneven_witness_atoms (y z : Fin 4) :
    maximalCoupling unevenP unevenQ (y, z) = unevenExpected y z := by
  apply (ENNReal.toReal_eq_toReal_iff' ((maximalCoupling unevenP unevenQ).apply_ne_top _)
    (unevenExpected_ne_top y z)).1
  rw [maximal_atom_toReal, uneven_overlap]
  fin_cases y <;> fin_cases z <;>
    norm_num [unevenExpected, unevenP, unevenQ, PMF.ofFintype_apply]

/-- R09: the enumerated unequal-weight witness has total mass exactly one. -/
example : (∑ t, maximalCoupling unevenP unevenQ t) = 1 := by
  simp_rw [show ∀ t : Fin 4 × Fin 4, maximalCoupling unevenP unevenQ t =
    unevenExpected t.1 t.2 from fun t => uneven_witness_atoms t.1 t.2]
  apply (ENNReal.toReal_eq_one_iff _).1
  rw [ENNReal.toReal_sum (fun t _ => unevenExpected_ne_top t.1 t.2)]
  norm_num [Fintype.sum_prod_type, Fin.sum_univ_succ, unevenExpected]

/-- R09: exact overlap, both marginals, and exact and Real attaining mismatch. -/
example : overlapMass unevenP unevenQ = (5 : ENNReal) / 8 ∧
    fstMarginal (maximalCoupling unevenP unevenQ) = unevenP ∧
    sndMarginal (maximalCoupling unevenP unevenQ) = unevenQ ∧
    mismatchMass (maximalCoupling unevenP unevenQ) = (3 : ENNReal) / 8 ∧
    finiteTV unevenP unevenQ = (3 / 8 : Real) := by
  refine ⟨uneven_overlap, (isCoupling_maximalCoupling _ _).1,
    (isCoupling_maximalCoupling _ _).2, ?_, uneven_tv⟩
  apply (ENNReal.toReal_eq_toReal_iff' (mismatchMass_ne_top _)
    (ENNReal.div_ne_top (by norm_num) (by norm_num))).1
  rw [mismatchMass_maximalCoupling_toReal, uneven_tv]
  norm_num

end

noncomputable section

universe v

/-- R11: an equivalence preserves the two marginals and every finite probability quantity. -/
example {beta : Type u} {gamma : Type v} [Fintype beta] [Fintype gamma]
    (p q : PMF beta) (g : PMF (beta × beta)) (hg : IsCoupling p q g)
    (e : beta ≃ gamma) :
    IsCoupling (p.map e) (q.map e) (g.map (fun t => (e t.1, e t.2))) ∧
    overlapMass (p.map e) (q.map e) = overlapMass p q ∧
    finiteTV (p.map e) (q.map e) = finiteTV p q ∧
    mismatchMass (g.map (fun t => (e t.1, e t.2))) = mismatchMass g ∧
    (mismatchMass (g.map (fun t => (e t.1, e t.2)))).toReal = (mismatchMass g).toReal := by
  exact ⟨hg.map e, overlapMass_map_injective p q e.injective,
    finiteTV_map_injective p q e.injective, mismatchMass_map_injective g e.injective,
    congrArg ENNReal.toReal (mismatchMass_map_injective g e.injective)⟩

/-- An arbitrary attaining coupling retains exact mismatch and Real attainment
under inclusion. -/
example {beta : Type u} {gamma : Type v} [Fintype beta] [Fintype gamma]
    (p q : PMF beta) (g : PMF (beta × beta)) (hg : IsCoupling p q g)
    (ha : (mismatchMass g).toReal = finiteTV p q)
    (f : beta → gamma) (hf : Function.Injective f) :
    IsCoupling (p.map f) (q.map f) (g.map (fun t => (f t.1, f t.2))) ∧
    mismatchMass (g.map (fun t => (f t.1, f t.2))) = mismatchMass g ∧
    (mismatchMass (g.map (fun t => (f t.1, f t.2)))).toReal =
      finiteTV (p.map f) (q.map f) := by
  refine ⟨hg.map f, mismatchMass_map_injective g hf, ?_⟩
  rw [mismatchMass_map_injective g hf, finiteTV_map_injective p q hf]
  exact ha

/-- R11: equivalence relabeling retains a specified attaining witness. -/
example {beta : Type u} {gamma : Type v} [Fintype beta] [Fintype gamma]
    (p q : PMF beta) (e : beta ≃ gamma) :
    IsCoupling (p.map e) (q.map e)
      ((maximalCoupling p q).map (fun t => (e t.1, e t.2))) ∧
    (mismatchMass ((maximalCoupling p q).map (fun t => (e t.1, e t.2)))).toReal =
      finiteTV (p.map e) (q.map e) :=
  isCoupling_map_maximalCoupling_attains p q e.injective

/-- R11: swapping any coupling reverses marginals and preserves exact and Real mismatch. -/
example {beta : Type u} [Fintype beta] (p q : PMF beta) (g : PMF (beta × beta))
    (hg : IsCoupling p q g) :
    IsCoupling q p (g.map Prod.swap) ∧
    mismatchMass (g.map Prod.swap) = mismatchMass g ∧
    (mismatchMass (g.map Prod.swap)).toReal = (mismatchMass g).toReal ∧
    finiteTV q p = finiteTV p q :=
  ⟨hg.swap, mismatchMass_map_swap g,
    congrArg ENNReal.toReal (mismatchMass_map_swap g), finiteTV_comm q p⟩

/-- R11: the swapped specified witness attains the reversed pair's TV. -/
example {beta : Type u} [Fintype beta] (p q : PMF beta) :
    IsCoupling q p ((maximalCoupling p q).map Prod.swap) ∧
    (mismatchMass ((maximalCoupling p q).map Prod.swap)).toReal = finiteTV q p := by
  refine ⟨(isCoupling_maximalCoupling p q).swap, ?_⟩
  rw [mismatchMass_map_swap, mismatchMass_maximalCoupling_toReal, finiteTV_comm]

/-- R11: adding one unused output label through `Fin.castSucc` preserves attainment. -/
example (p q : PMF (Fin 2)) :
    IsCoupling (p.map Fin.castSucc) (q.map Fin.castSucc)
      ((maximalCoupling p q).map (fun t => (t.1.castSucc, t.2.castSucc))) ∧
    (mismatchMass ((maximalCoupling p q).map
      (fun t => (t.1.castSucc, t.2.castSucc)))).toReal =
      finiteTV (p.map Fin.castSucc) (q.map Fin.castSucc) :=
  isCoupling_map_maximalCoupling_attains p q (Fin.castSucc_injective 2)

/-- R11: the target can live in an independently quantified larger universe. -/
example {beta : Type u} [Fintype beta] (p q : PMF beta) :
    IsCoupling (p.map (ULift.up : beta → ULift.{v} beta))
      (q.map (ULift.up : beta → ULift.{v} beta))
      ((maximalCoupling p q).map (fun t =>
        ((ULift.up t.1 : ULift.{v} beta), (ULift.up t.2 : ULift.{v} beta)))) ∧
    (mismatchMass ((maximalCoupling p q).map (fun t =>
      ((ULift.up t.1 : ULift.{v} beta), (ULift.up t.2 : ULift.{v} beta))))).toReal =
      finiteTV (p.map (ULift.up : beta → ULift.{v} beta))
        (q.map (ULift.up : beta → ULift.{v} beta)) := by
  exact isCoupling_map_maximalCoupling_attains p q
    (show Function.Injective (ULift.up : beta → ULift.{v} beta) from
      fun _ _ h => congrArg ULift.down h)

section CommonCarrier

variable {gamma : Type v} [Fintype gamma] (S : Set gamma) [Fintype S]
  (p q : PMF S)

/-- R12: both laws use one finite subtype and the same inclusion retains attainment. -/
example :
    IsCoupling (p.map Subtype.val) (q.map Subtype.val)
      ((maximalCoupling p q).map (fun t => (t.1.val, t.2.val))) ∧
    (mismatchMass ((maximalCoupling p q).map (fun t => (t.1.val, t.2.val)))).toReal =
      finiteTV (p.map Subtype.val) (q.map Subtype.val) :=
  isCoupling_map_maximalCoupling_attains p q Subtype.val_injective

/-- R12: both pushed-forward marginals are checked; neither unused-label fiber gains mass. -/
example (g : PMF (S × S)) (hg : IsCoupling p q g) (unused : gamma) (hu : unused ∉ S) :
    fstMarginal (g.map (fun t => (t.1.val, t.2.val))) = p.map Subtype.val ∧
    sndMarginal (g.map (fun t => (t.1.val, t.2.val))) = q.map Subtype.val ∧
    (∀ z, (g.map (fun t => (t.1.val, t.2.val))) (unused, z) = 0) ∧
    (∀ y, (g.map (fun t => (t.1.val, t.2.val))) (y, unused) = 0) := by
  have hc := hg.map (Subtype.val : S → gamma)
  refine ⟨hc.1, hc.2, ?_, ?_⟩
  · intro z
    apply PMF.map_apply_eq_zero_of_notMem_range
    rintro ⟨t, ht⟩
    have hfst : t.1.val = unused := congrArg Prod.fst ht
    apply hu
    rw [← hfst]
    exact t.1.property
  · intro y
    apply PMF.map_apply_eq_zero_of_notMem_range
    rintro ⟨t, ht⟩
    have hsnd : t.2.val = unused := congrArg Prod.snd ht
    apply hu
    rw [← hsnd]
    exact t.2.property

end CommonCarrier

/-- R13: a constant map collapses two distinct pure laws and changes TV from one to zero. -/
example :
    finiteTV (PMF.pure (0 : Fin 2)) (PMF.pure (1 : Fin 2)) = 1 ∧
    finiteTV ((PMF.pure (0 : Fin 2)).map (fun _ => (0 : Fin 1)))
      ((PMF.pure (1 : Fin 2)).map (fun _ => (0 : Fin 1))) = 0 := by
  constructor
  · norm_num [finiteTV, Fin.sum_univ_succ, PMF.pure_apply]
  · rw [PMF.pure_map, PMF.pure_map]
    exact (finiteTV_eq_zero_iff _ _).2 rfl

private def sharedP : PMF (Fin 3) :=
  PMF.ofFintype (fun i => if i.val = 0 then (1 : ENNReal) / 4
    else if i.val = 1 then 3 / 4 else 0) (by
    apply (ENNReal.toReal_eq_one_iff _).1
    rw [ENNReal.toReal_sum]
    · norm_num [Fin.sum_univ_succ]
    · intro i _
      split
      · exact ENNReal.div_ne_top ENNReal.one_ne_top (by norm_num)
      · split
        · exact ENNReal.div_ne_top (by norm_num) (by norm_num)
        · exact ENNReal.zero_ne_top)

private def sharedQ : PMF (Fin 3) :=
  PMF.ofFintype (fun i => if i.val = 0 then (1 : ENNReal) / 4
    else if i.val = 2 then 3 / 4 else 0) (by
    apply (ENNReal.toReal_eq_one_iff _).1
    rw [ENNReal.toReal_sum]
    · norm_num [Fin.sum_univ_succ]
    · intro i _
      split
      · exact ENNReal.div_ne_top ENNReal.one_ne_top (by norm_num)
      · split
        · exact ENNReal.div_ne_top (by norm_num) (by norm_num)
        · exact ENNReal.zero_ne_top)

private theorem shared_overlap : overlapMass sharedP sharedQ = (1 : ENNReal) / 4 := by
  apply (ENNReal.toReal_eq_toReal_iff' (overlapMass_ne_top _ _)
    (ENNReal.div_ne_top ENNReal.one_ne_top (by norm_num))).1
  rw [overlapMass_toReal]
  norm_num [sharedP, sharedQ, PMF.ofFintype_apply, Fin.sum_univ_succ]

private def sharedExpected (y z : Fin 3) : ENNReal :=
  if y.val = 0 ∧ z.val = 0 then 1 / 4
  else if y.val = 1 ∧ z.val = 2 then 3 / 4 else 0

private theorem sharedExpected_ne_top (y z : Fin 3) : sharedExpected y z ≠ ∞ := by
  simp only [sharedExpected]
  split
  · exact ENNReal.div_ne_top ENNReal.one_ne_top (by norm_num)
  · split
    · exact ENNReal.div_ne_top (by norm_num) (by norm_num)
    · exact ENNReal.zero_ne_top

/-- R14: all nine atoms are specified, with just one common and one exclusive pair. -/
private theorem shared_witness_atoms (y z : Fin 3) :
    maximalCoupling sharedP sharedQ (y, z) = sharedExpected y z := by
  apply (ENNReal.toReal_eq_toReal_iff' ((maximalCoupling sharedP sharedQ).apply_ne_top _)
    (sharedExpected_ne_top y z)).1
  rw [maximal_atom_toReal, shared_overlap]
  fin_cases y <;> fin_cases z <;>
    norm_num [sharedExpected, sharedP, sharedQ, PMF.ofFintype_apply]

/-- R14: the shared-output fixture retains both marginals and exact attaining mismatch. -/
example : IsCoupling sharedP sharedQ (maximalCoupling sharedP sharedQ) ∧
    mismatchMass (maximalCoupling sharedP sharedQ) = (3 : ENNReal) / 4 ∧
    finiteTV sharedP sharedQ = (3 / 4 : Real) := by
  have htv : finiteTV sharedP sharedQ = (3 / 4 : Real) := by
    norm_num [finiteTV, sharedP, sharedQ, PMF.ofFintype_apply, Fin.sum_univ_succ]
  refine ⟨isCoupling_maximalCoupling _ _, ?_, htv⟩
  apply (ENNReal.toReal_eq_toReal_iff' (mismatchMass_ne_top _)
    (ENNReal.div_ne_top (by norm_num) (by norm_num))).1
  rw [mismatchMass_maximalCoupling_toReal, htv]
  norm_num

/-- R14: a supported pair meeting the shared positive-mass output must coincide there. -/
example (y z : Fin 3) (hs : (y, z) ∈ (maximalCoupling sharedP sharedQ).support)
    (hshared : y = 0 ∨ z = 0) : y = z := by
  have hn : maximalCoupling sharedP sharedQ (y, z) ≠ 0 := (PMF.mem_support_iff _ _).1 hs
  rw [shared_witness_atoms] at hn
  fin_cases y <;> fin_cases z <;> norm_num [sharedExpected] at *

/-- R14's fiber argument depends only on equal masses and supported atoms. -/
example {beta : Type u} [Fintype beta] (p q : PMF beta) (y z : beta)
    (hy : p y = q y) :
    (maximalCoupling p q (y, z) ≠ 0 → y = z) ∧
    (maximalCoupling p q (z, y) ≠ 0 → y = z) := by
  constructor
  · intro hs
    by_contra hne
    have hlt := ((maximalCoupling_apply_pos_iff_of_ne p q hne).1
      (pos_iff_ne_zero.2 hs)).1
    rw [hy] at hlt
    exact lt_irrefl _ hlt
  · intro hs
    by_contra hne
    have hlt := ((maximalCoupling_apply_pos_iff_of_ne p q (Ne.symm hne)).1
      (pos_iff_ne_zero.2 hs)).2
    rw [hy] at hlt
    exact lt_irrefl _ hlt

/-- Equal zero masses leave both entire fibers empty, including their diagonal atom. -/
example {beta : Type u} [Fintype beta] (p q : PMF beta) (y z : beta)
    (hpy : p y = 0) (hqy : q y = 0) :
    maximalCoupling p q (y, z) = 0 ∧ maximalCoupling p q (z, y) = 0 := by
  have hc := isCoupling_maximalCoupling p q
  exact ⟨apply_eq_zero_of_fstMarginal_eq_zero _ (by simpa [hc.1] using hpy) z,
    apply_eq_zero_of_sndMarginal_eq_zero _ z (by simpa [hc.2] using hqy)⟩

end

end PerfectFunctionalRepresentations
