import PerfectFunctionalRepresentations.Examples.Nonrepresentable3x3

/-! R12-R13 and R15: exact example, support-qualified pairs and unused-output transport.
This module is built separately and imports only the production example. -/

namespace PerfectFunctionalRepresentations.Tests.Nonrepresentable3x3

noncomputable section

-- R12: compare all nine entries with the displayed table, independently of its encoding.
example : (fun x y => nonrepresentable3x3 x y) =
    ![![(1 : ENNReal) / 2, 1 / 2, 0], ![1 / 2, 0, 1 / 2], ![0, 1 / 2, 1 / 2]] := by
  funext x y
  fin_cases x <;> fin_cases y <;> norm_num [nonrepresentable3x3_apply]

example (x : Fin 3) : ∑ y, nonrepresentable3x3 x y = 1 := by
  simpa only [tsum_fintype] using (nonrepresentable3x3 x).tsum_coe

example : activeOutputs nonrepresentable3x3 = Set.univ := by
  ext y
  constructor
  · intro _; exact Set.mem_univ y
  · intro _
    fin_cases y
    · exact ⟨0, by norm_num [PMF.mem_support_iff, nonrepresentable3x3_apply]⟩
    · exact ⟨0, by norm_num [PMF.mem_support_iff, nonrepresentable3x3_apply]⟩
    · exact ⟨1, by norm_num [PMF.mem_support_iff, nonrepresentable3x3_apply]⟩

example : IsSingularChannel nonrepresentable3x3 ∧
    ¬ IsPerfectlyRepresentableChannel nonrepresentable3x3 :=
  ⟨nonrepresentable3x3_isSingular, nonrepresentable3x3_not_isPerfectlyRepresentableChannel⟩

-- R13: every full-support prior gives a nonperfect pair, using the C02 equivalence.
example (p : PMF (Fin 3)) (hp : ∀ x, x ∈ p.support) :
    ¬ IsPerfectlyRepresentablePair (PMF.channelJoint p nonrepresentable3x3) := by
  intro hpair
  exact nonrepresentable3x3_not_isPerfectlyRepresentableChannel
    ((isPerfectlyRepresentablePair_channelJoint_iff_of_fullSupport p nonrepresentable3x3 hp).1
      hpair)

-- The exact uniform-prior consequence of the extended manuscript.
example : ¬ IsPerfectlyRepresentablePair
    (PMF.channelJoint (PMF.uniformOfFintype (Fin 3)) nonrepresentable3x3) := by
  intro hpair
  exact nonrepresentable3x3_not_isPerfectlyRepresentableChannel
    ((isPerfectlyRepresentablePair_channelJoint_iff_of_fullSupport
      _ nonrepresentable3x3 (by intro x; simp)).1 hpair)

-- A point prior retains only its supported row. Construct the complete witness there.
example (a : Fin 3) :
    IsPerfectlyRepresentablePair (PMF.channelJoint (PMF.pure a) nonrepresentable3x3) := by
  apply (isPerfectlyRepresentablePair_channelJoint_iff_restrict_support
    (PMF.pure a) nonrepresentable3x3).2
  refine ⟨(nonrepresentable3x3 a).map (fun y => fun _ : (PMF.pure a).support => y),
    (fun y => PMF.pure (fun _ : (PMF.pure a).support => y)), ?_⟩
  intro s
  have hs : s.val = a := by
    simpa only [PMF.support_pure, Set.mem_singleton_iff] using s.property
  simp only [hs, PMF.map_comp, PMF.channelJoint, PMF.pure_map, Function.comp_def]
  rfl

-- R15: preserve labels 0,1,2 while adding the unused output 3. The reverse
-- transport implication rules out every extended witness using the original negative.
example :
    let kappa4 : Fin 3 → PMF (Fin 4) :=
      fun x => (nonrepresentable3x3 x).map Fin.castSucc
    (∀ x, kappa4 x 3 = 0) ∧
      IsSingularChannel kappa4 ∧
      ¬ IsPerfectlyRepresentableChannel kappa4 := by
  dsimp only
  refine ⟨?_, (isSingularChannel_map_iff nonrepresentable3x3 Fin.castSucc
    (Fin.castSucc_injective 3)).2 nonrepresentable3x3_isSingular, ?_⟩
  · intro x
    apply PMF.map_apply_eq_zero_of_notMem_range
    rintro ⟨y, hy⟩
    exact Fin.castSucc_ne_last y hy
  · intro h
    exact nonrepresentable3x3_not_isPerfectlyRepresentableChannel
      ((isPerfectlyRepresentableChannel_map_iff nonrepresentable3x3 Fin.castSucc
        (Fin.castSucc_injective 3)).1 h)

end
end PerfectFunctionalRepresentations.Tests.Nonrepresentable3x3
