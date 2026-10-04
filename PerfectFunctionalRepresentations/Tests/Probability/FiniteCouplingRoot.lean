import PerfectFunctionalRepresentations

/-!
# Root-only finite coupling consumers

R15 checks the public probability surface using only the mathematical root.
The existing decoder-facing consumers are in `FiniteCouplingDecoding` tests.
-/

namespace PerfectFunctionalRepresentations

open LeanInfoTheory.Shannon

universe u v

variable {beta : Type u} {gamma : Type v} [Fintype beta] [Fintype gamma]

/-- The universal bound applies to any prescribed coupling through the root. -/
example (p q : PMF beta) (g : PMF (beta × beta)) (hg : IsCoupling p q g) :
    finiteTV p q ≤ (mismatchMass g).toReal :=
  hg.finiteTV_le_mismatchMass_toReal

/-- The specified witness exposes both marginals and attained Real mismatch. -/
example (p q : PMF beta) :
    fstMarginal (maximalCoupling p q) = p ∧
      sndMarginal (maximalCoupling p q) = q ∧
      (mismatchMass (maximalCoupling p q)).toReal = finiteTV p q :=
  ⟨(isCoupling_maximalCoupling p q).1, (isCoupling_maximalCoupling p q).2,
    mismatchMass_maximalCoupling_toReal p q⟩

/-- Root consumers can exhibit a witness minimizing mismatch over every coupling. -/
example (p q : PMF beta) (g : PMF (beta × beta)) (hg : IsCoupling p q g) :
    (mismatchMass (maximalCoupling p q)).toReal ≤ (mismatchMass g).toReal := by
  rw [mismatchMass_maximalCoupling_toReal]
  exact hg.finiteTV_le_mismatchMass_toReal

/-- Relabeling may change universes and add unused symbols without losing attainment. -/
example (p q : PMF beta) {f : beta → gamma} (hf : Function.Injective f) :
    IsCoupling (p.map f) (q.map f)
        ((maximalCoupling p q).map fun t => (f t.1, f t.2)) ∧
      (mismatchMass ((maximalCoupling p q).map fun t => (f t.1, f t.2))).toReal =
        finiteTV p q := by
  obtain ⟨hmarginals, hattains⟩ := isCoupling_map_maximalCoupling_attains p q hf
  exact ⟨hmarginals, hattains.trans (finiteTV_map_injective p q hf)⟩

end PerfectFunctionalRepresentations
