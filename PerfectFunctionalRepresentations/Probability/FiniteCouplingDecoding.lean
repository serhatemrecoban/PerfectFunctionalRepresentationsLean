import PerfectFunctionalRepresentations.Probability.FiniteCoupling
import LeanInfoTheory.Shannon.Fano

/-!
# Coupling mismatch and identity decoding

This optional bridge identifies exact coupling mismatch, after real conversion,
with the pinned decoding-error probability for the identity decoder. It reuses
the existing finite-sum API. The coupling core and mathematical root do not
import this module. No conditional-entropy or functional-representation theorem
is asserted here.
-/

namespace PerfectFunctionalRepresentations

open LeanInfoTheory.Shannon

universe u

variable {beta : Type u} [Fintype beta]

/-- Identity decoding fails exactly when the two coordinates differ. -/
theorem mismatchMass_toReal_eq_decodingErrorProbability (g : PMF (beta × beta)) :
    (mismatchMass g).toReal = decodingErrorProbability g id := by
  classical
  rw [mismatchMass_toReal, decodingErrorProbability_eq_sum]
  apply Finset.sum_congr rfl
  intro t _
  by_cases h : t.1 = t.2 <;> simp [h, eq_comm]

/-- The universal coupling bound specializes to the existing decoding-error API. -/
theorem IsCoupling.finiteTV_le_decodingErrorProbability {p q : PMF beta}
    {g : PMF (beta × beta)} (h : IsCoupling p q g) :
    finiteTV p q ≤ decodingErrorProbability g id := by
  rw [← mismatchMass_toReal_eq_decodingErrorProbability]
  exact h.finiteTV_le_mismatchMass_toReal

/-- The specified maximal coupling attains TV through the existing decoder API. -/
theorem decodingErrorProbability_maximalCoupling (p q : PMF beta) :
    decodingErrorProbability (maximalCoupling p q) id = finiteTV p q := by
  rw [← mismatchMass_toReal_eq_decodingErrorProbability]
  exact mismatchMass_maximalCoupling_toReal p q

end PerfectFunctionalRepresentations
