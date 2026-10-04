import LeanInfoTheory.Probability.Finite
import LeanInfoTheory.Shannon.InfoMeasures
import LeanInfoTheory.Shannon.SemanticBridge.Product
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Finite total variation, couplings and mismatch

Total variation uses the half-L1 normalization of ISIT Section II-C,
Equation (9). Exact overlap and residual masses use `ENNReal`; their `toReal`
images give the corresponding finite real sums. Alphabets may include
zero-mass symbols. No full-support or chosen default-atom assumption is used.

Couplings use the existing first and second marginals of a product PMF. Exact
mismatch is the mass of the unequal-coordinate event. The universal lower
bound follows from the diagonal/overlap comparison in extended version 16,
Appendix A (157)-(161). A concrete normalized coupling attains the bound,
with exact atoms and support, including zero and unit residual mass.
Simultaneous injective relabeling and coordinate swap preserve the mismatch
guarantees and transport attaining witnesses, including through unused labels.
The compatibility bridge to decoding error is separately importable.
-/

namespace PerfectFunctionalRepresentations

open scoped BigOperators ENNReal
open LeanInfoTheory.Shannon

universe u

/-- A joint law with the prescribed first and second marginals.
This predicate itself requires no finiteness assumption. -/
def IsCoupling {beta : Type u} (p q : PMF beta) (g : PMF (beta × beta)) : Prop :=
  fstMarginal g = p ∧ sndMarginal g = q

/-- Every diagonal atom is bounded by each prescribed marginal atom. -/
theorem IsCoupling.apply_diag_le_min {beta : Type u} [Finite beta]
    {p q : PMF beta} {g : PMF (beta × beta)}
    (h : IsCoupling p q g) (y : beta) : g (y, y) ≤ min (p y) (q y) := by
  apply le_min
  · simpa [h.1] using apply_le_fstMarginal g y y
  · simpa [h.2] using apply_le_sndMarginal g y y

variable {beta : Type u} [Fintype beta]

/-- Finite total variation with the paper's half-L1 normalization. -/
noncomputable def finiteTV (p q : PMF beta) : ℝ :=
  (1 / 2 : ℝ) * ∑ y, |(p y).toReal - (q y).toReal|

/-- The exact total mass shared by two finite laws. -/
noncomputable def overlapMass (p q : PMF beta) : ℝ≥0∞ :=
  ∑ y, min (p y) (q y)

/-- Shared mass does not depend on the order of the laws. -/
theorem overlapMass_comm (p q : PMF beta) : overlapMass p q = overlapMass q p := by
  simp only [overlapMass, min_comm]

/-- Shared mass is at most the total mass of either law. -/
theorem overlapMass_le_one (p q : PMF beta) : overlapMass p q ≤ 1 := by
  calc
    overlapMass p q ≤ ∑ y, p y := Finset.sum_le_sum fun y _ => min_le_left _ _
    _ = 1 := by simpa using p.tsum_coe

/-- In particular, shared mass is finite, as required for real conversion. -/
theorem overlapMass_ne_top (p q : PMF beta) : overlapMass p q ≠ ∞ :=
  ne_top_of_le_ne_top ENNReal.one_ne_top (overlapMass_le_one p q)

/-- Exact overlap converts to the sum of the real pointwise minima. -/
theorem overlapMass_toReal (p q : PMF beta) :
    (overlapMass p q).toReal = ∑ y, min (p y).toReal (q y).toReal := by
  rw [overlapMass, ENNReal.toReal_sum]
  · simp only [ENNReal.toReal_min (p.apply_ne_top _) (q.apply_ne_top _)]
  · intro y _
    exact ne_top_of_le_ne_top (p.apply_ne_top y) (min_le_left _ _)

/-- Removing each common atom leaves exactly the complement of the overlap.
All subtraction in this identity is truncated `ENNReal` subtraction. -/
theorem sum_sub_min_eq_one_sub_overlapMass (p q : PMF beta) :
    ∑ y, (p y - min (p y) (q y)) = 1 - overlapMass p q := by
  apply ENNReal.eq_sub_of_add_eq' ENNReal.one_ne_top
  rw [overlapMass, ← Finset.sum_add_distrib]
  simp only [tsub_min, tsub_add_min]
  simpa using p.tsum_coe

/-- The paper's half-L1 distance is one minus the shared real mass. -/
theorem finiteTV_eq_one_sub_overlap_toReal (p q : PMF beta) :
    finiteTV p q = 1 - (overlapMass p q).toReal := by
  have hatom (y : beta) : |(p y).toReal - (q y).toReal| =
      (p y).toReal + (q y).toReal - 2 * min (p y).toReal (q y).toReal := by
    rcases le_total (p y).toReal (q y).toReal with h | h
    · rw [min_eq_left h, abs_of_nonpos (sub_nonpos.mpr h)]
      ring
    · rw [min_eq_right h, abs_of_nonneg (sub_nonneg.mpr h)]
      ring
  simp only [finiteTV, hatom, Finset.sum_sub_distrib, Finset.sum_add_distrib,
    ← Finset.mul_sum, p.sum_toReal, q.sum_toReal, overlapMass_toReal]
  ring

/-- Exact residual mass and the real total variation describe the same quantity. -/
theorem finiteTV_eq_sub_overlap_toReal (p q : PMF beta) :
    finiteTV p q = (1 - overlapMass p q).toReal := by
  rw [finiteTV_eq_one_sub_overlap_toReal,
    ENNReal.toReal_sub_of_le (overlapMass_le_one p q) ENNReal.one_ne_top,
    ENNReal.toReal_one]

/-- TV is the sum of the positive parts of the atomwise difference.
Each positive part is first formed by truncated `ENNReal` subtraction. -/
theorem finiteTV_eq_sum_tsub_toReal (p q : PMF beta) :
    finiteTV p q = ∑ y, (p y - q y).toReal := by
  rw [finiteTV_eq_sub_overlap_toReal, ← sum_sub_min_eq_one_sub_overlapMass]
  rw [ENNReal.toReal_sum]
  · simp only [tsub_min]
  · intro y _
    exact ENNReal.sub_ne_top (p.apply_ne_top y)

/-- Finite total variation is symmetric. -/
theorem finiteTV_comm (p q : PMF beta) : finiteTV p q = finiteTV q p := by
  simp only [finiteTV_eq_one_sub_overlap_toReal, overlapMass_comm p q]

/-- Finite total variation is nonnegative. -/
theorem finiteTV_nonneg (p q : PMF beta) : 0 ≤ finiteTV p q := by
  rw [finiteTV_eq_sub_overlap_toReal]
  exact ENNReal.toReal_nonneg

/-- Finite total variation is at most one. -/
theorem finiteTV_le_one (p q : PMF beta) : finiteTV p q ≤ 1 := by
  rw [finiteTV_eq_one_sub_overlap_toReal]
  have := ENNReal.toReal_nonneg (a := overlapMass p q)
  linarith

/-- Distance zero means equality of the complete laws, including zero atoms. -/
theorem finiteTV_eq_zero_iff (p q : PMF beta) : finiteTV p q = 0 ↔ p = q := by
  constructor
  · intro h
    have hsum : ∑ y, |(p y).toReal - (q y).toReal| = 0 := by
      unfold finiteTV at h
      linarith
    have hz (y : beta) : |(p y).toReal - (q y).toReal| = 0 :=
      (Finset.sum_eq_zero_iff_of_nonneg (fun y _ => abs_nonneg _)).mp hsum y (Finset.mem_univ y)
    apply PMF.ext
    intro y
    exact (ENNReal.toReal_eq_toReal_iff' (p.apply_ne_top y) (q.apply_ne_top y)).mp
      (sub_eq_zero.mp (abs_eq_zero.mp (hz y)))
  · rintro rfl
    simp [finiteTV]

/-- Distance one means that the exact overlap is zero. -/
theorem finiteTV_eq_one_iff (p q : PMF beta) :
    finiteTV p q = 1 ↔ overlapMass p q = 0 := by
  rw [finiteTV_eq_one_sub_overlap_toReal]
  have hzero : (overlapMass p q).toReal = 0 ↔ overlapMass p q = 0 := by
    simp [ENNReal.toReal_eq_zero_iff, overlapMass_ne_top]
  constructor
  · intro h
    exact hzero.mp (by linarith)
  · intro h
    rw [h, ENNReal.toReal_zero]
    ring

/-- Zero overlap is equivalent to a zero pointwise minimum at every label. -/
theorem overlapMass_eq_zero_iff (p q : PMF beta) :
    overlapMass p q = 0 ↔ ∀ y, min (p y) (q y) = 0 := by
  simp [overlapMass, Finset.sum_eq_zero_iff]

/-- Zero overlap means disjoint supports, without a full-support premise. -/
theorem overlapMass_eq_zero_iff_disjoint (p q : PMF beta) :
    overlapMass p q = 0 ↔ Disjoint p.support q.support := by
  rw [overlapMass_eq_zero_iff, Set.disjoint_left]
  simp only [PMF.mem_support_iff]
  constructor
  · intro h y hp hq
    rcases (min_eq_zero.mp (h y)) with hp0 | hq0
    · exact hp hp0
    · exact hq hq0
  · intro h y
    by_cases hp : p y = 0
    · simp [hp]
    · have hq : q y = 0 := not_ne_iff.mp (h hp)
      simp [hq]

/-- Exact probability that the two coordinates differ, as a finite atom sum. -/
noncomputable def mismatchMass (g : PMF (beta × beta)) : ℝ≥0∞ := by
  classical
  exact ∑ t, if t.1 ≠ t.2 then g t else 0

/-- The finite mismatch sum is the existing PMF outer-measure event probability. -/
theorem mismatchMass_eq_toOuterMeasure (g : PMF (beta × beta)) :
    mismatchMass g = g.toOuterMeasure {t | t.1 ≠ t.2} := by
  classical
  rw [mismatchMass, PMF.toOuterMeasure_apply_fintype]
  apply Finset.sum_congr rfl
  intro t _
  by_cases h : t.1 = t.2 <;> simp [Set.indicator, h]

open scoped Classical in
private theorem sum_diagonal_indicator (g : PMF (beta × beta)) :
    (∑ t : beta × beta, if t.1 = t.2 then g t else 0) = ∑ y, g (y, y) := by
  classical
  simp [Fintype.sum_prod_type]

/-- Mismatch and diagonal agreement exhaust the mass of every joint law. -/
theorem mismatchMass_add_diagonal (g : PMF (beta × beta)) :
    mismatchMass g + ∑ y, g (y, y) = 1 := by
  classical
  rw [← sum_diagonal_indicator, mismatchMass, ← Finset.sum_add_distrib]
  calc
    _ = ∑ t, g t := by
      apply Finset.sum_congr rfl
      intro t _
      by_cases h : t.1 = t.2 <;> simp [h]
    _ = 1 := by simpa using g.tsum_coe

/-- Exact mismatch is one minus diagonal mass, using truncated subtraction. -/
theorem mismatchMass_eq_one_sub_diagonal (g : PMF (beta × beta)) :
    mismatchMass g = 1 - ∑ y, g (y, y) :=
  ENNReal.eq_sub_of_add_eq' ENNReal.one_ne_top (mismatchMass_add_diagonal g)

/-- Exact mismatch never exceeds the total mass one. -/
theorem mismatchMass_le_one (g : PMF (beta × beta)) : mismatchMass g ≤ 1 := by
  rw [mismatchMass_eq_one_sub_diagonal]
  exact tsub_le_self

/-- Mismatch mass is finite, as required for real conversion. -/
theorem mismatchMass_ne_top (g : PMF (beta × beta)) : mismatchMass g ≠ ∞ :=
  ne_top_of_le_ne_top ENNReal.one_ne_top (mismatchMass_le_one g)

open scoped Classical in
/-- Real mismatch is the finite sum of real masses at unequal-coordinate atoms. -/
theorem mismatchMass_toReal (g : PMF (beta × beta)) :
    (mismatchMass g).toReal = ∑ t, if t.1 ≠ t.2 then (g t).toReal else 0 := by
  classical
  rw [mismatchMass, ENNReal.toReal_sum]
  · apply Finset.sum_congr rfl
    intro t _
    split_ifs <;> simp
  · intro t _
    split_ifs <;> simp [g.apply_ne_top]

/-- The derived real mismatch is nonnegative. -/
theorem mismatchMass_toReal_nonneg (g : PMF (beta × beta)) :
    0 ≤ (mismatchMass g).toReal := ENNReal.toReal_nonneg

/-- The derived real mismatch is at most one. -/
theorem mismatchMass_toReal_le_one (g : PMF (beta × beta)) :
    (mismatchMass g).toReal ≤ 1 := by
  simpa using ENNReal.toReal_mono ENNReal.one_ne_top (mismatchMass_le_one g)

/-- The exact agreement/mismatch decomposition also holds for real finite sums. -/
theorem mismatchMass_toReal_add_diagonal (g : PMF (beta × beta)) :
    (mismatchMass g).toReal + ∑ y, (g (y, y)).toReal = 1 := by
  rw [← ENNReal.toReal_sum (fun y _ => g.apply_ne_top (y, y))]
  rw [← ENNReal.toReal_add (mismatchMass_ne_top g)
    (ENNReal.sum_ne_top.mpr (fun y _ => g.apply_ne_top (y, y))),
    mismatchMass_add_diagonal, ENNReal.toReal_one]

/-- Real mismatch is one minus real diagonal agreement, with ordinary subtraction. -/
theorem mismatchMass_toReal_eq_one_sub_diagonal (g : PMF (beta × beta)) :
    (mismatchMass g).toReal = 1 - ∑ y, (g (y, y)).toReal := by
  have h := mismatchMass_toReal_add_diagonal g
  linarith

/-- Diagonal agreement of any coupling is at most the overlap of its marginals. -/
theorem IsCoupling.sum_diagonal_le_overlapMass {p q : PMF beta}
    {g : PMF (beta × beta)} (h : IsCoupling p q g) :
    ∑ y, g (y, y) ≤ overlapMass p q :=
  Finset.sum_le_sum fun y _ => h.apply_diag_le_min y

/-- Every coupling has at least the complementary overlap mass in mismatch. -/
theorem IsCoupling.sub_overlapMass_le_mismatchMass {p q : PMF beta}
    {g : PMF (beta × beta)} (h : IsCoupling p q g) :
    1 - overlapMass p q ≤ mismatchMass g := by
  rw [mismatchMass_eq_one_sub_diagonal]
  exact tsub_le_tsub_left h.sum_diagonal_le_overlapMass 1

/-- Total variation bounds the real mismatch of every coupling from below. -/
theorem IsCoupling.finiteTV_le_mismatchMass_toReal {p q : PMF beta}
    {g : PMF (beta × beta)} (h : IsCoupling p q g) :
    finiteTV p q ≤ (mismatchMass g).toReal := by
  rw [finiteTV_eq_sub_overlap_toReal]
  exact ENNReal.toReal_mono (mismatchMass_ne_top g) h.sub_overlapMass_le_mismatchMass

private theorem residual_le (p q : PMF beta) (y : beta) :
    p y - min (p y) (q y) ≤ 1 - overlapMass p q := by
  rw [← sum_sub_min_eq_one_sub_overlapMass]
  exact Finset.single_le_sum (f := fun z => p z - min (p z) (q z))
    (fun _ _ => zero_le) (Finset.mem_univ y)

private noncomputable def maximalCouplingWeight (p q : PMF beta) (t : beta × beta) :
    ℝ≥0∞ := by
  classical
  exact (if t.1 = t.2 then min (p t.1) (q t.1) else 0) +
    (p t.1 - min (p t.1) (q t.1)) * (q t.2 - min (p t.2) (q t.2)) /
      (1 - overlapMass p q)

private theorem maximalCouplingWeight_row (p q : PMF beta) (y : beta) :
    ∑ z, maximalCouplingWeight p q (y, z) = p y := by
  classical
  have hsum : ∑ z, (q z - min (p z) (q z)) = 1 - overlapMass p q := by
    simpa only [min_comm, overlapMass_comm q p] using
      sum_sub_min_eq_one_sub_overlapMass q p
  have hcancel : (p y - min (p y) (q y)) * (1 - overlapMass p q) /
      (1 - overlapMass p q) = p y - min (p y) (q y) :=
    ENNReal.mul_div_cancel_right'
      (fun h => le_zero_iff.mp (h ▸ residual_le p q y))
      (fun h => (ENNReal.sub_ne_top ENNReal.one_ne_top h).elim)
  simp only [maximalCouplingWeight, Finset.sum_add_distrib]
  rw [Finset.sum_ite_eq, if_pos (Finset.mem_univ y)]
  have hres : (∑ z, (p y - min (p y) (q y)) *
      (q z - min (p z) (q z)) / (1 - overlapMass p q)) =
      p y - min (p y) (q y) := by
    simpa only [div_eq_mul_inv, ← Finset.sum_mul, ← Finset.mul_sum, hsum] using hcancel
  rw [hres, add_comm, tsub_add_cancel_of_le (min_le_left _ _)]

private theorem maximalCouplingWeight_swap (p q : PMF beta) (y z : beta) :
    maximalCouplingWeight p q (y, z) = maximalCouplingWeight q p (z, y) := by
  classical
  by_cases h : y = z
  · subst z
    simp only [maximalCouplingWeight, min_comm, overlapMass_comm q p, mul_comm]
  · simp only [maximalCouplingWeight, h, Ne.symm h, ↓reduceIte, zero_add,
      min_comm, overlapMass_comm q p, mul_comm]

/-- The diagonal common mass plus the product of the two residual masses,
divided by their common total. Zero residual mass is handled by ENNReal arithmetic. -/
noncomputable def maximalCoupling (p q : PMF beta) : PMF (beta × beta) :=
  PMF.ofFintype (maximalCouplingWeight p q) (by
    rw [Fintype.sum_prod_type]
    simp only [maximalCouplingWeight_row]
    simpa using p.tsum_coe)

open scoped Classical in
/-- Exact atoms, with a single residual-total denominator. -/
theorem maximalCoupling_apply (p q : PMF beta) (y z : beta) :
    maximalCoupling p q (y, z) =
      (if y = z then min (p y) (q y) else 0) +
      (p y - min (p y) (q y)) * (q z - min (p z) (q z)) /
        (1 - overlapMass p q) := rfl

/-- The construction has the two prescribed marginals. -/
theorem isCoupling_maximalCoupling (p q : PMF beta) :
    IsCoupling p q (maximalCoupling p q) := by
  constructor <;> apply PMF.ext <;> intro y
  · rw [fstMarginal_apply]
    exact maximalCouplingWeight_row p q y
  · rw [sndMarginal_apply]
    change ∑ z, maximalCouplingWeight p q (z, y) = q y
    calc
      _ = ∑ z, maximalCouplingWeight q p (y, z) :=
        Finset.sum_congr rfl (fun z _ => maximalCouplingWeight_swap p q z y)
      _ = q y := maximalCouplingWeight_row q p y

/-- Diagonal agreement is exactly the pointwise common mass. -/
theorem maximalCoupling_apply_diag (p q : PMF beta) (y : beta) :
    maximalCoupling p q (y, y) = min (p y) (q y) := by
  rw [maximalCoupling_apply]
  rcases le_total (p y) (q y) with h | h
  · simp [min_eq_left h]
  · simp [min_eq_right h]

/-- Total diagonal agreement exhausts the overlap. -/
theorem sum_maximalCoupling_diag (p q : PMF beta) :
    ∑ y, maximalCoupling p q (y, y) = overlapMass p q := by
  simp only [maximalCoupling_apply_diag, overlapMass]

/-- Exact mismatch attains the complementary overlap mass. -/
theorem mismatchMass_maximalCoupling (p q : PMF beta) :
    mismatchMass (maximalCoupling p q) = 1 - overlapMass p q := by
  rw [mismatchMass_eq_one_sub_diagonal, sum_maximalCoupling_diag]

/-- Real mismatch of the constructed coupling attains total variation. -/
theorem mismatchMass_maximalCoupling_toReal (p q : PMF beta) :
    (mismatchMass (maximalCoupling p q)).toReal = finiteTV p q := by
  rw [mismatchMass_maximalCoupling, finiteTV_eq_sub_overlap_toReal]

/-- The coupling minimum is attained, with the universal lower bound included. -/
theorem exists_coupling_minimizing_mismatch (p q : PMF beta) :
    ∃ g : PMF (beta × beta), IsCoupling p q g ∧
      (mismatchMass g).toReal = finiteTV p q ∧
      ∀ g' : PMF (beta × beta), IsCoupling p q g' →
        (mismatchMass g).toReal ≤ (mismatchMass g').toReal := by
  refine ⟨maximalCoupling p q, isCoupling_maximalCoupling p q,
    mismatchMass_maximalCoupling_toReal p q, ?_⟩
  intro g' h
  rw [mismatchMass_maximalCoupling_toReal]
  exact h.finiteTV_le_mismatchMass_toReal

/-- Off-diagonal support runs from a strict first-law excess to a strict
second-law excess; equality and zero-mass labels create no residual fibers. -/
theorem maximalCoupling_apply_pos_iff_of_ne (p q : PMF beta) {y z : beta}
    (h : y ≠ z) : 0 < maximalCoupling p q (y, z) ↔ q y < p y ∧ p z < q z := by
  rw [maximalCoupling_apply, if_neg h, zero_add, ENNReal.div_pos_iff,
    min_comm (p z) (q z)]
  simp only [ENNReal.sub_ne_top ENNReal.one_ne_top, not_false_eq_true, and_true,
    ne_eq, mul_eq_zero, not_or, ← pos_iff_ne_zero, tsub_min, tsub_pos_iff_lt]

/-- Identical laws give the diagonal pushforward, including at zero-mass labels. -/
theorem maximalCoupling_self (p : PMF beta) :
    maximalCoupling p p = p.map (fun y => (y, y)) := by
  classical
  apply PMF.ext
  rintro ⟨y, z⟩
  by_cases h : y = z
  · subst z
    simp [maximalCoupling_apply, PMF.map_apply, tsum_fintype]
  · have hpairs (a : beta) : (y, z) ≠ (a, a) := by
      intro heq
      exact h (congrArg Prod.fst heq |>.trans (congrArg Prod.snd heq).symm)
    simp [maximalCoupling_apply, PMF.map_apply, h, hpairs]

/-- With no common mass the construction is the existing independent product. -/
theorem maximalCoupling_eq_indepProd_of_overlapMass_eq_zero (p q : PMF beta)
    (h : overlapMass p q = 0) : maximalCoupling p q = indepProd p q := by
  classical
  apply PMF.ext
  rintro ⟨y, z⟩
  rw [maximalCoupling_apply, indepProd_apply]
  simp [(overlapMass_eq_zero_iff p q).mp h, h]

universe v

section Relabeling

variable {alpha : Type u} {gamma : Type v}

/-- Simultaneously mapping both coordinates maps both prescribed marginals.
This elementary coupling property needs neither finiteness nor injectivity. -/
theorem IsCoupling.map {p q : PMF alpha} {g : PMF (alpha × alpha)}
    (h : IsCoupling p q g) (f : alpha → gamma) :
    IsCoupling (p.map f) (q.map f) (g.map fun t => (f t.1, f t.2)) := by
  constructor
  · simpa only [fstMarginal_map_pair, fstMarginal, PMF.map_comp, Function.comp_def]
      using congrArg (fun r : PMF alpha => r.map f) h.1
  · simpa only [sndMarginal_map_pair, sndMarginal, PMF.map_comp, Function.comp_def]
      using congrArg (fun r : PMF alpha => r.map f) h.2

/-- Swapping coordinates reverses the two prescribed marginals. -/
theorem IsCoupling.swap {p q : PMF alpha} {g : PMF (alpha × alpha)}
    (h : IsCoupling p q g) : IsCoupling q p (g.map Prod.swap) := by
  exact ⟨by simpa only [fstMarginal_map_swap] using h.2,
    by simpa only [sndMarginal_map_swap] using h.1⟩

variable [Fintype alpha] [Fintype gamma]

/-- An injective output relabeling preserves overlap, including off-image zeros. -/
theorem overlapMass_map_injective (p q : PMF alpha) {f : alpha → gamma}
    (hf : Function.Injective f) : overlapMass (p.map f) (q.map f) = overlapMass p q := by
  classical
  unfold overlapMass
  symm
  apply Fintype.sum_of_injective f hf
  · intro z hz
    rw [PMF.map_apply_eq_zero_of_notMem_range p hz, zero_min]
  · intro y
    rw [PMF.map_apply_of_injective p hf, PMF.map_apply_of_injective q hf]

/-- Simultaneous injective relabeling preserves finite total variation. -/
theorem finiteTV_map_injective (p q : PMF alpha) {f : alpha → gamma}
    (hf : Function.Injective f) : finiteTV (p.map f) (q.map f) = finiteTV p q := by
  rw [finiteTV_eq_one_sub_overlap_toReal, overlapMass_map_injective p q hf,
    finiteTV_eq_one_sub_overlap_toReal]

/-- An injection preserves the unequal-coordinate event and its exact mass. -/
theorem mismatchMass_map_injective (g : PMF (alpha × alpha)) {f : alpha → gamma}
    (hf : Function.Injective f) :
    mismatchMass (g.map fun t => (f t.1, f t.2)) = mismatchMass g := by
  rw [mismatchMass_eq_toOuterMeasure, PMF.toOuterMeasure_map_apply,
    mismatchMass_eq_toOuterMeasure]
  congr 1
  ext t
  exact not_congr hf.eq_iff

/-- Exact mismatch is independent of the order of the two coordinates. -/
theorem mismatchMass_map_swap (g : PMF (alpha × alpha)) :
    mismatchMass (g.map Prod.swap) = mismatchMass g := by
  rw [mismatchMass_eq_toOuterMeasure, PMF.toOuterMeasure_map_apply,
    mismatchMass_eq_toOuterMeasure]
  congr 1
  ext t
  exact ne_comm

/-- The mapped specified coupling attains TV for the mapped laws.
No equality with a newly chosen maximal coupling on the target is required. -/
theorem isCoupling_map_maximalCoupling_attains (p q : PMF alpha) {f : alpha → gamma}
    (hf : Function.Injective f) :
    IsCoupling (p.map f) (q.map f)
        ((maximalCoupling p q).map fun t => (f t.1, f t.2)) ∧
      (mismatchMass ((maximalCoupling p q).map fun t => (f t.1, f t.2))).toReal =
        finiteTV (p.map f) (q.map f) := by
  refine ⟨(isCoupling_maximalCoupling p q).map f, ?_⟩
  rw [mismatchMass_map_injective _ hf, mismatchMass_maximalCoupling_toReal,
    finiteTV_map_injective p q hf]

end Relabeling

end PerfectFunctionalRepresentations
