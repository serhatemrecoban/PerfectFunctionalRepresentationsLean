import PerfectFunctionalRepresentations.Matrix.CanonicalReachability
import PerfectFunctionalRepresentations.Examples.Nonrepresentable3x3
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum

/-!
External C11 consumers: only public production declarations are used.
R14 retains an adversarial posterior at a globally unused output.
R16 checks exact matrices and a distinguishable input relabeling.
-/

namespace PerfectFunctionalRepresentations.Tests.CanonicalReachability
open MatrixOperations ActiveFiniteChannel
open scoped BigOperators ENNReal
noncomputable section

universe u v

/-! Arbitrary finite ambient output, without a prior or full-support premise. -/
example {alpha : Type u} {beta : Type v} [Finite alpha] [Nonempty alpha] [Finite beta]
    (kappa : alpha → PMF beta) (x : alpha) :
    ((ofChannel kappa).channel x).map (ambientLabel kappa) = kappa x :=
  ofChannel_recover kappa x

example {alpha : Type u} {beta : Type v} [Finite alpha] [Nonempty alpha] [Finite beta]
    (kappa : alpha → PMF beta) {m n : Nat}
    (e : activeOutputs kappa ≃ Fin m) (f : activeOutputs kappa ≃ Fin n) (x : alpha) :
    ((ofChannelWithEquiv kappa e).channel x).map (e.symm.trans f) =
      (ofChannelWithEquiv kappa f).channel x := ofChannelWithEquiv_compare kappa e f x

namespace UnusedOutput
private def w : Fin 2 → Fin 3 := Fin.castSucc
private def nullVector : Fin 2 → Fin 3 := fun _ => 2
private def q : PMF (Fin 2 → Fin 3) := PMF.pure w
private def kappa (x : Fin 2) : PMF (Fin 3) := PMF.pure (w x)
private def V (y : Fin 3) : PMF (Fin 2 → Fin 3) :=
  if y = 2 then PMF.pure nullVector else q

private theorem w_ne_two (x : Fin 2) : w x ≠ (2 : Fin 3) := by
  fin_cases x <;> norm_num [w,Fin.ext_iff]
private theorem w_ne_null : w ≠ nullVector := by
  intro h
  exact w_ne_two 0 (congrFun h 0)

private theorem factorization (x : Fin 2) :
    q.map (fun f => (f x,f)) = PMF.channelJoint (kappa x) V := by
  simp [q,kappa,PMF.channelJoint,PMF.pure_map,V,w_ne_two]

private theorem perfect : IsPerfectlyRepresentableChannel kappa := ⟨q,V,factorization⟩
private theorem singular : IsSingularChannel kappa := perfect.isSingular

-- Every atom is checked, including output2; its row weight is exactly zero.
example (x : Fin 2) (y : Fin 3) (f : Fin 2 → Fin 3) :
    q.map (fun g => (g x,g)) (y,f) = kappa x y * V y f := by
  rw [factorization,PMF.channelJoint_apply]
example (x : Fin 2) : kappa x 2 = 0 := by
  simp [kappa,PMF.pure_apply,Ne.symm (w_ne_two x)]
private theorem unused : (2 : Fin 3) ∉ activeOutputs kappa := by
  rintro ⟨x,hx⟩
  simp [kappa,Ne.symm (w_ne_two x)] at hx
private theorem posterior_null_mass : V 2 nullVector = 1 := by simp [V]
private theorem vector_null_mass : q nullVector = 0 := by
  simp [q,PMF.pure_apply,Ne.symm w_ne_null]
example : 0 < V 2 nullVector ∧ q nullVector = 0 ∧
    (2 : Fin 3) ∉ activeOutputs kappa := by
  rw [posterior_null_mass]
  exact ⟨by norm_num,vector_null_mass,unused⟩
example : ¬ ∀ y f, 0 < V y f → 0 < q f := by
  intro h
  have hn := h 2 nullVector (by rw [posterior_null_mass]; norm_num)
  simp [vector_null_mass] at hn

private theorem active_lt (a : activeOutputs kappa) : a.val.val < 2 := by
  obtain ⟨x,hx⟩ := a.property
  have hy : a.val = w x := by
    by_contra hy
    simp [kappa,hy] at hx
  rw [hy]
  exact x.isLt
private def enumeration : activeOutputs kappa ≃ Fin 2 where
  toFun a := ⟨a.val.val,active_lt a⟩
  invFun x := ⟨w x,x,by simp [kappa]⟩
  left_inv a := Subtype.ext (Fin.ext rfl)
  right_inv x := Fin.ext rfl
private def changedEnumeration : activeOutputs kappa ≃ Fin 2 :=
  enumeration.trans (Equiv.swap 0 1)
private def a0 : activeOutputs kappa := enumeration.symm 0
private def a1 : activeOutputs kappa := enumeration.symm 1
private abbrev source := ofChannelWithEquiv kappa enumeration
private abbrev changedSource := ofChannelWithEquiv kappa changedEnumeration

example : source.outputCard = 2 ∧ changedSource.outputCard = 2 := ⟨rfl,rfl⟩
example : enumeration a0 = (0 : Fin 2) ∧ changedEnumeration a0 = (1 : Fin 2) := by
  simp [a0,changedEnumeration]
example : source.channel 0 (0 : Fin 2) = 1 := by
  have h := ofChannelWithEquiv_apply kappa enumeration 0 a0
  have hy : enumeration a0 = 0 := enumeration.apply_symm_apply 0
  have ha : a0.val = w 0 := rfl
  rw [hy,ha] at h
  exact h.trans (by simp [kappa])
example : changedSource.channel 0 (1 : Fin 2) = 1 := by
  have h := ofChannelWithEquiv_apply kappa changedEnumeration 0 a0
  have hy : changedEnumeration a0 = 1 := by simp [changedEnumeration,a0]
  have ha : a0.val = w 0 := rfl
  rw [hy,ha] at h
  exact h.trans (by simp [kappa])
example : changedSource.channel 0 (0 : Fin 2) = 0 := by
  have h := ofChannelWithEquiv_apply kappa changedEnumeration 0 a1
  have hy : changedEnumeration a1 = 0 := by simp [changedEnumeration,a1]
  have ha : a1.val = w 1 := rfl
  rw [hy,ha] at h
  exact h.trans (by simp [kappa,w])
example (x : Fin 2) :
    (source.channel x).map (enumeration.symm.trans changedEnumeration) =
      changedSource.channel x :=
  ofChannelWithEquiv_compare kappa enumeration changedEnumeration x
example (x : Fin 2) :
    (source.channel x).map (fun j => (enumeration.symm j).val) = kappa x :=
  ofChannelWithEquiv_recover kappa enumeration x
example (x : Fin 2) :
    (changedSource.channel x).map (fun j => (changedEnumeration.symm j).val) = kappa x :=
  ofChannelWithEquiv_recover kappa changedEnumeration x
example (x : Fin 2) :
    ((changedSource.channel x).map (fun j => (changedEnumeration.symm j).val)) 2 = 0 := by
  rw [ofChannelWithEquiv_recover]
  simp [kappa,PMF.pure_apply,Ne.symm (w_ne_two x)]

-- Input-only relabeling distinguishes the two deterministic rows.
private def inputSwap : Fin 2 ≃ Fin 2 := Equiv.swap 0 1
private def inputRelabelled : Fin 2 → PMF (Fin 3) :=
  relabelChannel kappa inputSwap (Equiv.refl _)
private theorem inputRelabelled_perfect : IsPerfectlyRepresentableChannel inputRelabelled :=
  (isPerfectlyRepresentableChannel_relabelChannel_iff kappa inputSwap (Equiv.refl _)).mpr perfect
example : massMatrix inputRelabelled = Matrix.reindex inputSwap (Equiv.refl _)
    (massMatrix kappa) := massMatrix_relabelChannel kappa inputSwap (Equiv.refl _)
example : massMatrix kappa 0 0 = 1 ∧ massMatrix inputRelabelled 0 0 = 0 ∧
    massMatrix inputRelabelled 0 1 = 1 := by
  simp [massMatrix,inputRelabelled,relabelChannel,inputSwap,kappa,w,PMF.pure_map,Fin.ext_iff]
example : relabelChannel inputRelabelled inputSwap.symm (Equiv.refl _).symm = kappa :=
  relabelChannel_symm kappa inputSwap (Equiv.refl _)
example : HasSingularColumns (massMatrix kappa) :=
  (hasSingularColumns_massMatrix_iff kappa).mpr singular
end UnusedOutput

-- Exact matrix coordinates retain ambient zero columns only in reconstruction.
example {k m : Nat} [NeZero k] (M : Matrix (Fin k) (Fin m) ENNReal)
    (hrow : ∀ x, ∑ y, M x y = 1) (x : Fin k)
    (j : Fin (ofChannel (channelOfMassMatrix M hrow)).outputCard) :
    massMatrix (ofChannel (channelOfMassMatrix M hrow)).channel x j =
      M x (ambientLabel (channelOfMassMatrix M hrow) j) := by
  rw [massMatrix_apply,ofChannel_apply,channelOfMassMatrix_apply]

end
end PerfectFunctionalRepresentations.Tests.CanonicalReachability

namespace PerfectFunctionalRepresentations.Tests.CanonicalReachability
open MatrixOperations ActiveFiniteChannel
open scoped BigOperators ENNReal
noncomputable section
universe u v

/-! R13: the public iff statements expose actual cascades and directed maps. -/
example {alpha : Type u} [Finite alpha] [Nonempty alpha] (S : ActiveFiniteChannel alpha)
    (hP : IsPerfectlyRepresentableChannel S.channel) :
    ∃ c : Cascade S (allOnes alpha), c.path.Reducing ∧
      (∀ x, (c.endpoint.channel x).map c.outputEquiv.equiv = (allOnes alpha).channel x) ∧
      (∀ x, ((allOnes alpha).channel x).map c.outputEquiv.equiv.symm = c.endpoint.channel x) := by
  obtain ⟨c,hc⟩ := (isPerfectlyRepresentable_iff_toAllOnes S).mp hP
  exact ⟨c,hc,c.outputEquiv.map_eq,c.outputEquiv.symm.map_eq⟩

example {alpha : Type u} [Finite alpha] [Nonempty alpha] (S : ActiveFiniteChannel alpha)
    (hP : IsPerfectlyRepresentableChannel S.channel) :
    ∃ c : Cascade (allOnes alpha) S, c.path.Normalizing ∧
      (∀ x, (c.endpoint.channel x).map c.outputEquiv.equiv = S.channel x) ∧
      (∀ x, (S.channel x).map c.outputEquiv.equiv.symm = c.endpoint.channel x) := by
  obtain ⟨c,hc⟩ := (isPerfectlyRepresentable_iff_fromAllOnes S).mp hP
  exact ⟨c,hc,c.outputEquiv.map_eq,c.outputEquiv.symm.map_eq⟩

example {alpha : Type u} [Finite alpha] [Nonempty alpha] (S : ActiveFiniteChannel alpha)
    (c : Cascade S (allOnes alpha)) (hc : c.path.Reducing) :
    IsPerfectlyRepresentableChannel S.channel :=
  (isPerfectlyRepresentable_iff_toAllOnes S).mpr ⟨c,hc⟩

example {alpha : Type u} [Finite alpha] [Nonempty alpha] (S : ActiveFiniteChannel alpha)
    (c : Cascade (allOnes alpha) S) (hc : c.path.Normalizing) :
    IsPerfectlyRepresentableChannel S.channel :=
  (isPerfectlyRepresentable_iff_fromAllOnes S).mpr ⟨c,hc⟩

-- Arbitrary finite ambient output is recovered after the actual cascade's map.
example {alpha : Type u} {beta : Type v} [Finite alpha] [Nonempty alpha] [Finite beta]
    (kappa : alpha → PMF beta) (hP : IsPerfectlyRepresentableChannel kappa) :
    ∃ c : Cascade (allOnes alpha) (ofChannel kappa), c.path.Normalizing ∧
      ∀ x, (c.endpoint.channel x).map
        (fun j => ambientLabel kappa (c.outputEquiv.equiv j)) = kappa x := by
  have hA := (isPerfectlyRepresentableChannel_ofChannel_iff kappa).mpr hP
  obtain ⟨c,hc⟩ := (isPerfectlyRepresentable_iff_fromAllOnes (ofChannel kappa)).mp hA
  refine ⟨c,hc,?_⟩
  intro x
  exact (PMF.map_comp (p := c.endpoint.channel x) (f := c.outputEquiv.equiv)
    (ambientLabel kappa)).symm.trans
      ((congrArg (fun p : PMF (Fin (ofChannel kappa).outputCard) =>
        p.map (ambientLabel kappa)) (c.outputEquiv.map_eq x)).trans
        (ofChannel_recover kappa x))

example {alpha : Type u} {beta : Type v} [Finite alpha] [Nonempty alpha] [Finite beta]
    (kappa : alpha → PMF beta) {m : Nat} (e : activeOutputs kappa ≃ Fin m)
    (hP : IsPerfectlyRepresentableChannel kappa) :
    ∃ c : Cascade (allOnes alpha) (ofChannelWithEquiv kappa e), c.path.Normalizing ∧
      ∀ x, (c.endpoint.channel x).map
        (fun j => (e.symm (c.outputEquiv.equiv j)).val) = kappa x := by
  have hA := (isPerfectlyRepresentableChannel_ofChannelWithEquiv_iff kappa e).mpr hP
  obtain ⟨c,hc⟩ := (isPerfectlyRepresentable_iff_fromAllOnes (ofChannelWithEquiv kappa e)).mp hA
  refine ⟨c,hc,?_⟩
  intro x
  let restore : Fin m → beta := fun j => (e.symm j).val
  exact (PMF.map_comp (p := c.endpoint.channel x) (f := c.outputEquiv.equiv) restore).symm.trans
    ((congrArg (fun p : PMF (Fin m) => p.map restore) (c.outputEquiv.map_eq x)).trans
      (ofChannelWithEquiv_recover kappa e x))

namespace UnusedOutput
-- The adversarial null-output posterior still yields actual public witnesses.
example : ∃ c : Cascade source (allOnes (Fin 2)), c.path.Reducing :=
  (isPerfectlyRepresentable_iff_toAllOnes source).mp
    ((isPerfectlyRepresentableChannel_ofChannelWithEquiv_iff kappa enumeration).mpr perfect)
example : ∃ c : Cascade (allOnes (Fin 2)) changedSource, c.path.Normalizing :=
  (isPerfectlyRepresentable_iff_fromAllOnes changedSource).mp
    ((isPerfectlyRepresentableChannel_ofChannelWithEquiv_iff kappa changedEnumeration).mpr perfect)
example : ToAllOnes (ofChannel kappa) ∧ FromAllOnes (ofChannel kappa) := by
  have hA := (isPerfectlyRepresentableChannel_ofChannel_iff kappa).mpr perfect
  exact ⟨(isPerfectlyRepresentable_iff_toAllOnes _).mp hA,
    (isPerfectlyRepresentable_iff_fromAllOnes _).mp hA⟩

-- R16: the changed input rows also satisfy both new public characterizations.
example : ToAllOnes (ofChannel inputRelabelled) ∧ FromAllOnes (ofChannel inputRelabelled) := by
  have hA := (isPerfectlyRepresentableChannel_ofChannel_iff inputRelabelled).mpr
    inputRelabelled_perfect
  exact ⟨(isPerfectlyRepresentable_iff_toAllOnes _).mp hA,
    (isPerfectlyRepresentable_iff_fromAllOnes _).mp hA⟩
end UnusedOutput

/-! R15: reuse the public C03 counterexample and both new iff directions. -/
example : ¬ ToAllOnes (ofChannel nonrepresentable3x3) := by
  intro h
  exact nonrepresentable3x3_not_isPerfectlyRepresentableChannel
    ((isPerfectlyRepresentableChannel_ofChannel_iff nonrepresentable3x3).mp
      ((isPerfectlyRepresentable_iff_toAllOnes _).mpr h))
example : ¬ FromAllOnes (ofChannel nonrepresentable3x3) := by
  intro h
  exact nonrepresentable3x3_not_isPerfectlyRepresentableChannel
    ((isPerfectlyRepresentableChannel_ofChannel_iff nonrepresentable3x3).mp
      ((isPerfectlyRepresentable_iff_fromAllOnes _).mpr h))

/-! R16: the printed singular-matrix specialization uses C06's exact boundary. -/
example {k m : Nat} [NeZero k] (M : Matrix (Fin k) (Fin m) ENNReal)
    (hrow : ∀ x, ∑ y, M x y = 1) (hSing : HasSingularColumns M) :
    IsSingularChannel (channelOfMassMatrix M hrow) ∧
      (IsPerfectlyRepresentableChannel (channelOfMassMatrix M hrow) ↔
        ToAllOnes (ofChannel (channelOfMassMatrix M hrow))) ∧
      (IsPerfectlyRepresentableChannel (channelOfMassMatrix M hrow) ↔
        FromAllOnes (ofChannel (channelOfMassMatrix M hrow))) := by
  refine ⟨?_,?_,?_⟩
  · apply (hasSingularColumns_massMatrix_iff _).mp
    simpa only [massMatrix_channelOfMassMatrix] using hSing
  · exact (isPerfectlyRepresentableChannel_ofChannel_iff _).symm.trans
      (isPerfectlyRepresentable_iff_toAllOnes _)
  · exact (isPerfectlyRepresentableChannel_ofChannel_iff _).symm.trans
      (isPerfectlyRepresentable_iff_fromAllOnes _)

end
end PerfectFunctionalRepresentations.Tests.CanonicalReachability
