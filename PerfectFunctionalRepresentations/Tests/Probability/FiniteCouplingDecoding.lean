import PerfectFunctionalRepresentations.Probability.FiniteCouplingDecoding
import LeanInfoTheory.Shannon.SemanticBridge.Product
import Mathlib.Tactic.NormNum

/-! R05-R06, attainment and transport checks through the existing decoding-error API. -/

namespace PerfectFunctionalRepresentations

open LeanInfoTheory.Shannon
open scoped BigOperators ENNReal

noncomputable section

universe u

/-- R05: the existing decoder sum API computes zero on a diagonal law. -/
example {beta : Type u} [Fintype beta] (p : PMF beta) :
    (mismatchMass (p.map fun y => (y, y))).toReal = 0 ∧
      decodingErrorProbability (p.map fun y => (y, y)) id = 0 := by
  classical
  have herror : decodingErrorProbability (p.map fun y => (y, y)) id = 0 := by
    rw [decodingErrorProbability_eq_sum]
    apply Finset.sum_eq_zero
    intro t _
    split
    · have hmass : (p.map fun y => (y, y)) t = 0 := by
        apply PMF.map_apply_eq_zero_of_notMem_range
        rintro ⟨a, ha⟩
        exact ‹id t.2 ≠ t.1› ((congrArg Prod.snd ha).symm.trans (congrArg Prod.fst ha))
      rw [hmass, ENNReal.toReal_zero]
    · rfl
  exact ⟨(mismatchMass_toReal_eq_decodingErrorProbability _).trans herror, herror⟩

private def fair : PMF (Fin 2) :=
  PMF.ofFintype (fun _ => (1 : ENNReal) / 2) (by
    simpa only [Fin.sum_univ_succ, Fin.sum_univ_zero, add_zero] using
      ENNReal.add_halves (1 : ENNReal))

/-- R06: the bridge identifies exact independent-product mismatch with decoder error. -/
example : (mismatchMass (indepProd fair fair)).toReal = (1 / 2 : Real) ∧
    decodingErrorProbability (indepProd fair fair) id = (1 / 2 : Real) := by
  classical
  have herror : decodingErrorProbability (indepProd fair fair) id = (1 / 2 : Real) := by
    rw [decodingErrorProbability_eq_sum]
    norm_num [Fintype.sum_prod_type, Fin.sum_univ_succ, indepProd_apply,
      fair, PMF.ofFintype_apply]
  exact ⟨(mismatchMass_toReal_eq_decodingErrorProbability _).trans herror, herror⟩

/-- The separate import reuses the existing Real range API for arbitrary laws. -/
example {beta : Type u} [Fintype beta] (g : PMF (beta × beta)) :
    0 ≤ (mismatchMass g).toReal ∧ (mismatchMass g).toReal ≤ 1 := by
  rw [mismatchMass_toReal_eq_decodingErrorProbability]
  exact ⟨decodingErrorProbability_nonneg _ _, decodingErrorProbability_le_one _ _⟩

/-- The coupling bound also reaches the existing decoder-facing API. -/
example {beta : Type u} [Fintype beta] (p q : PMF beta) (g : PMF (beta × beta))
    (hg : IsCoupling p q g) : finiteTV p q ≤ decodingErrorProbability g id :=
  hg.finiteTV_le_decodingErrorProbability

end

noncomputable section

universe v

/-- S03: the specified coupling attains the same bound in the existing decoder API. -/
example {beta : Type u} [Fintype beta] (p q : PMF beta) :
    IsCoupling p q (maximalCoupling p q) ∧
    decodingErrorProbability (maximalCoupling p q) id = finiteTV p q := by
  exact ⟨isCoupling_maximalCoupling p q, decodingErrorProbability_maximalCoupling p q⟩

/-- S03: the attaining decoder-error witness is no larger than any other coupling's error. -/
example {beta : Type u} [Fintype beta] (p q : PMF beta) (g : PMF (beta × beta))
    (hg : IsCoupling p q g) :
    decodingErrorProbability (maximalCoupling p q) id ≤ decodingErrorProbability g id := by
  rw [decodingErrorProbability_maximalCoupling]
  exact hg.finiteTV_le_decodingErrorProbability

end

noncomputable section

/-- S04: simultaneous injective relabeling preserves the existing decoder error. -/
example {beta : Type u} {gamma : Type v} [Fintype beta] [Fintype gamma]
    (g : PMF (beta × beta)) {f : beta → gamma} (hf : Function.Injective f) :
    decodingErrorProbability (g.map fun t => (f t.1, f t.2)) id =
      decodingErrorProbability g id := by
  rw [← mismatchMass_toReal_eq_decodingErrorProbability,
    mismatchMass_map_injective g hf, mismatchMass_toReal_eq_decodingErrorProbability]

/-- S04: the transported specified coupling still attains the decoder-facing bound. -/
example {beta : Type u} {gamma : Type v} [Fintype beta] [Fintype gamma]
    (p q : PMF beta) {f : beta → gamma} (hf : Function.Injective f) :
    decodingErrorProbability ((maximalCoupling p q).map fun t => (f t.1, f t.2)) id =
      finiteTV (p.map f) (q.map f) := by
  rw [← mismatchMass_toReal_eq_decodingErrorProbability]
  exact (isCoupling_map_maximalCoupling_attains p q hf).2

/-- S04: coordinate order also leaves the decoder-facing probability unchanged. -/
example {beta : Type u} [Fintype beta] (g : PMF (beta × beta)) :
    decodingErrorProbability (g.map Prod.swap) id = decodingErrorProbability g id := by
  rw [← mismatchMass_toReal_eq_decodingErrorProbability, mismatchMass_map_swap,
    mismatchMass_toReal_eq_decodingErrorProbability]

end

end PerfectFunctionalRepresentations
