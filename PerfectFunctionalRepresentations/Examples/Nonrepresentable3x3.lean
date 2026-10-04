import PerfectFunctionalRepresentations.Semantics.Singularity

/-!
# A singular channel with no perfect representation

ISIT Section II-B, Example 1, Equation (8); extended Appendix A, Lemma 7,
Equations (135)-(146), designated version 16 (2026-09-03).
Inputs index rows and outputs index columns. Paper labels `1,2,3` become
Lean labels `0,1,2` in both coordinates. The table is
`[[1/2,1/2,0], [1/2,0,1/2], [0,1/2,1/2]]`.

The negative theorem uses C02's common-posterior factorization, whose
full-support Markov bridge justifies the manuscript's uniform-prior argument.
Both final-coordinate contradictions are retained. This example is separately
importable and is not an import of the lightweight mathematical root.
-/

namespace PerfectFunctionalRepresentations

/-- The displayed channel, with its zero entries exactly on the antidiagonal.
All nonzero masses are exactly one half in `ENNReal`. -/
noncomputable def nonrepresentable3x3 (x : Fin 3) : PMF (Fin 3) :=
  PMF.ofFintype (fun y => if x.val + y.val = 2 then 0 else (1 : ENNReal) / 2) (by
    fin_cases x <;>
      simpa [Fin.sum_univ_succ, ← two_mul] using ENNReal.add_halves (1 : ENNReal))

/-- Exact entry specification in the displayed row/column order. -/
theorem nonrepresentable3x3_apply (x y : Fin 3) :
    nonrepresentable3x3 x y =
      if x.val + y.val = 2 then 0 else (1 : ENNReal) / 2 := rfl

/-- Every positive entry in each column has the same mass. -/
theorem nonrepresentable3x3_isSingular : IsSingularChannel nonrepresentable3x3 := by
  intro x1 x2 y h1 h2
  simp only [nonrepresentable3x3_apply] at h1 h2 ⊢
  split_ifs at h1 h2 ⊢ <;> simp_all

/-- No canonical vector law and common posterior perfectly represent this channel.
The contradiction concerns every possible witness, not a selected coupling. -/
theorem nonrepresentable3x3_not_isPerfectlyRepresentableChannel :
    ¬ IsPerfectlyRepresentableChannel nonrepresentable3x3 := by
  rintro ⟨q, V, h⟩
  have hC := isCanonicalCoupling_of_coordinateFactorization q nonrepresentable3x3 V h
  -- (137)-(140): the first coordinate's positive mass gives an actual supported vector.
  have hzero : (0 : Fin 3) ∈ (q.map (fun w => w 0)).support := by
    rw [hC 0]
    norm_num [PMF.mem_support_iff, nonrepresentable3x3_apply]
  obtain ⟨w, hw, hw0⟩ := (PMF.mem_support_map_iff _ _ _).1 hzero
  have hpost (x : Fin 3) : w ∈ (V (w x)).support := by
    have hp : (w x, w) ∈ (q.map (fun f => (f x, f))).support :=
      (PMF.mem_support_map_iff _ _ _).2 ⟨w, hw, rfl⟩
    rw [h x, PMF.mem_support_channelJoint_iff] at hp
    exact hp.2
  -- (141)-(144): output 0 is shared by rows 0 and 1, forcing the second coordinate.
  have hw1 : w 1 = 0 := coordinate_eq_of_posterior_support q nonrepresentable3x3 V h
    (by norm_num [nonrepresentable3x3_apply]) (by simpa only [hw0] using hpost 0)
  have hrow2 : w 2 ∈ (nonrepresentable3x3 2).support := by
    rw [← hC 2]
    exact (PMF.mem_support_map_iff _ _ _).2 ⟨w, hw, rfl⟩
  have hw2ne : w 2 ≠ 0 := by
    intro hz
    simp [hz, PMF.mem_support_iff, nonrepresentable3x3_apply] at hrow2
  have hcases : w 2 = 1 ∨ w 2 = 2 := by omega
  obtain h2 | h2 := hcases
  · -- (145): output 1 is shared by rows 2 and 0, contradicting the first coordinate.
    have hc : w 0 = 1 := coordinate_eq_of_posterior_support q nonrepresentable3x3 V h
      (by norm_num [nonrepresentable3x3_apply]) (by simpa only [h2] using hpost 2)
    omega
  · -- (146): output 2 is shared by rows 2 and 1, contradicting the second coordinate.
    have hc : w 1 = 2 := coordinate_eq_of_posterior_support q nonrepresentable3x3 V h
      (by norm_num [nonrepresentable3x3_apply]) (by simpa only [h2] using hpost 2)
    omega

end PerfectFunctionalRepresentations
