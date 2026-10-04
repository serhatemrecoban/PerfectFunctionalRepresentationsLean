import PerfectFunctionalRepresentations.Semantics.Singularity
import PerfectFunctionalRepresentations.Probability.FiniteCoupling
import Mathlib.Logic.Equiv.Fin.Basic
import Mathlib.Data.Fintype.EquivFin

/-!
# Binary canonical coordinates

The paper's binary vector entries 1/2 are Lean's coordinates 0/1.
The inverse of `finTwoArrowEquiv` sends a product coupling to its vector law;
both marginal directions and the full evaluation law respect this order.
Canonical evaluation realizes the channel pair law for every input prior.
These structural statements need no finite output alphabet.

For finite outputs, the scalar `r` in ISIT II-C (10) is exactly C04's
`finiteTV` of the two rows, with its existing half-L1/overlap normalization.
Its value is independent of the chosen binary input enumeration. This module
introduces no additional TV, mismatch, or scalar definition. The law boundary
also corresponds to extended version 16, Appendix A (147)-(151).

The singular binary construction in ISIT Lemma 2 uses C04's maximal coupling.
The shared/exclusive atom and overlap identities below identify it with
extended Appendix A (111)-(124), including globally unused output labels.

The conditional-entropy calculation in (149)-(154) holds for any binary vector
law and input prior. Positive fibers use the pushed input law; null fibers
vanish under their weights. C02's full-law equality transports the result to
canonical variables on an unrestricted source, with information measured in nats.

The first assertion of ISIT Lemma 3 is the universal finite-auxiliary bound
and an explicit finite representation attaining it, as in extended (155)-(163).
The full-support argument uses canonicalization; a point prior is handled
without identifying an unseen channel row with a decoder coordinate.

The second assertion follows from finite information attainment and perfect
representability, as in extended (164)-(166). Singularity gives equality for
every prior; the ambient-channel converse requires full input support. Exact
input/prior/vector-law transport gives the semantic cardinality-two interfaces.
-/

namespace PerfectFunctionalRepresentations

open LeanInfoTheory.Shannon

universe u v

section Laws

variable {beta : Type u}

/-- Product-to-vector-to-product transport recovers the entire coupling law. -/
@[simp] theorem map_finTwoArrowEquiv_symm_roundtrip (g : PMF (beta × beta)) :
    (g.map (finTwoArrowEquiv beta).symm).map (finTwoArrowEquiv beta) = g := by
  rw [PMF.map_comp, Equiv.self_comp_symm, PMF.map_id]

/-- Vector-to-product-to-vector transport recovers the entire vector law. -/
@[simp] theorem map_finTwoArrowEquiv_roundtrip (q : PMF (Fin 2 → beta)) :
    (q.map (finTwoArrowEquiv beta)).map (finTwoArrowEquiv beta).symm = q := by
  rw [PMF.map_comp, Equiv.symm_comp_self, PMF.map_id]

/-- The first product coordinate is the vector's coordinate 0. -/
@[simp] theorem map_finTwoArrowEquiv_symm_eval_zero (g : PMF (beta × beta)) :
    (g.map (finTwoArrowEquiv beta).symm).map (fun w => w 0) = fstMarginal g := by
  rw [PMF.map_comp]
  rfl

/-- The second product coordinate is the vector's coordinate 1. -/
@[simp] theorem map_finTwoArrowEquiv_symm_eval_one (g : PMF (beta × beta)) :
    (g.map (finTwoArrowEquiv beta).symm).map (fun w => w 1) = sndMarginal g := by
  rw [PMF.map_comp]
  rfl

/-- Mapping a vector law to products preserves its coordinate-0 law. -/
@[simp] theorem fstMarginal_map_finTwoArrowEquiv (q : PMF (Fin 2 → beta)) :
    fstMarginal (q.map (finTwoArrowEquiv beta)) = q.map (fun w => w 0) := by
  rw [fstMarginal_map]
  rfl

/-- Mapping a vector law to products preserves its coordinate-1 law. -/
@[simp] theorem sndMarginal_map_finTwoArrowEquiv (q : PMF (Fin 2 → beta)) :
    sndMarginal (q.map (finTwoArrowEquiv beta)) = q.map (fun w => w 1) := by
  rw [sndMarginal_map]
  rfl

/-- A product coupling is precisely an all-row binary canonical coupling. -/
theorem isCoupling_iff_isCanonicalCoupling_finTwoArrowEquiv
    (kappa : Fin 2 → PMF beta) (g : PMF (beta × beta)) :
    IsCoupling (kappa 0) (kappa 1) g ↔
      IsCanonicalCoupling kappa (g.map (finTwoArrowEquiv beta).symm) := by
  simp only [IsCoupling, IsCanonicalCoupling, Fin.forall_fin_two,
    map_finTwoArrowEquiv_symm_eval_zero, map_finTwoArrowEquiv_symm_eval_one]

/-- The reverse law boundary supplies the original vector's two marginal laws. -/
theorem isCanonicalCoupling_iff_isCoupling_finTwoArrowEquiv
    (kappa : Fin 2 → PMF beta) (q : PMF (Fin 2 → beta)) :
    IsCanonicalCoupling kappa q ↔
      IsCoupling (kappa 0) (kappa 1) (q.map (finTwoArrowEquiv beta)) := by
  simp only [IsCoupling, IsCanonicalCoupling, Fin.forall_fin_two,
    fstMarginal_map_finTwoArrowEquiv, sndMarginal_map_finTwoArrowEquiv]

/-- Independently sample the input and product coupling, then evaluate its vector.
This is equality of full triples, before any marginal or information operation. -/
theorem canonicalJoint_map_finTwoArrowEquiv_symm
    (p : PMF (Fin 2)) (g : PMF (beta × beta)) :
    canonicalJoint p (g.map (finTwoArrowEquiv beta).symm) =
      (indepProd p g).map (fun xz =>
        (xz.1, (finTwoArrowEquiv beta).symm xz.2 xz.1,
          (finTwoArrowEquiv beta).symm xz.2)) := by
  simp only [canonicalJoint, indepProd, PMF.map_bind, PMF.map_comp, Function.comp_def]

/-- Returning the auxiliary vector to product coordinates preserves input and output. -/
theorem canonicalJoint_map_finTwoArrowEquiv
    (p : PMF (Fin 2)) (g : PMF (beta × beta)) :
    (canonicalJoint p (g.map (finTwoArrowEquiv beta).symm)).map
        (fun t => (t.1, t.2.1, finTwoArrowEquiv beta t.2.2)) =
      (indepProd p g).map (fun xz =>
        (xz.1, (finTwoArrowEquiv beta).symm xz.2 xz.1, xz.2)) := by
  simp only [canonicalJoint_map_finTwoArrowEquiv_symm, PMF.map_comp,
    Function.comp_def, Equiv.apply_symm_apply]

/-- A binary product coupling realizes the prescribed channel under every prior,
including either point prior; it never recovers an unseen row from the pair law. -/
theorem IsCoupling.fstSndMarginal_binaryCanonicalJoint
    {kappa : Fin 2 → PMF beta} {g : PMF (beta × beta)}
    (h : IsCoupling (kappa 0) (kappa 1) g) (p : PMF (Fin 2)) :
    fstSndMarginal (canonicalJoint p (g.map (finTwoArrowEquiv beta).symm)) =
      PMF.channelJoint p kappa :=
  IsCanonicalCoupling.fstSndMarginal_canonicalJoint
    ((isCoupling_iff_isCanonicalCoupling_finTwoArrowEquiv kappa g).1 h) p

end Laws

private theorem finiteTV_binary_perm {beta : Type v} [Fintype beta]
    (kappa : Fin 2 → PMF beta) (e : Fin 2 ≃ Fin 2) :
    finiteTV (kappa (e.symm 0)) (kappa (e.symm 1)) =
      finiteTV (kappa 0) (kappa 1) := by
  have hne : e.symm 0 ≠ e.symm 1 := e.symm.injective.ne (by decide)
  by_cases h0 : e.symm 0 = 0
  · have h1 : e.symm 1 = 1 := Fin.eq_one_of_ne_zero _ (by
      intro h
      exact hne (h0.trans h.symm))
    rw [h0, h1]
  · have h0' : e.symm 0 = 1 := Fin.eq_one_of_ne_zero _ h0
    have h1 : e.symm 1 = 0 := by
      by_contra h
      exact hne (h0'.trans (Fin.eq_one_of_ne_zero _ h).symm)
    rw [h0', h1, finiteTV_comm]

/-- The scalar in Equation (10) is independent of the binary input enumeration.
Only the output alphabet needs an explicit finite enumeration. -/
theorem finiteTV_inputEnumeration_eq {alpha : Type u} {beta : Type v} [Fintype beta]
    (kappa : alpha → PMF beta) (e e' : alpha ≃ Fin 2) :
    finiteTV (kappa (e.symm 0)) (kappa (e.symm 1)) =
      finiteTV (kappa (e'.symm 0)) (kappa (e'.symm 1)) := by
  simpa only [Equiv.symm_trans_apply, Equiv.apply_symm_apply] using
    (finiteTV_binary_perm (fun i => kappa (e.symm i)) (e.symm.trans e')).symm

/-! ## PFR-C05-S02: singular binary channels and Lemma 2 -/

open scoped Classical in
private theorem singular_binary_column {beta : Type u}
    {kappa : Fin 2 → PMF beta} (hs : IsSingularChannel kappa) (y : beta) :
    min (kappa 0 y) (kappa 1 y) =
        (if kappa 0 y ≠ 0 ∧ kappa 1 y ≠ 0 then kappa 0 y else 0) ∧
      kappa 0 y - min (kappa 0 y) (kappa 1 y) =
        (if kappa 1 y = 0 then kappa 0 y else 0) ∧
      kappa 1 y - min (kappa 0 y) (kappa 1 y) =
        (if kappa 0 y = 0 then kappa 1 y else 0) := by
  classical
  by_cases h0 : kappa 0 y = 0
  · simp [h0]
  by_cases h1 : kappa 1 y = 0
  · simp [h1]
  have heq := hs 0 1 y h0 h1
  simp [heq, h1]

open scoped Classical in
/-- The common mass in extended (115) is exactly C04 overlap. Both-zero
columns contribute zero, so the shared set need not cover ambient outputs. -/
theorem IsSingularChannel.overlapMass_eq_sum_shared {beta : Type u} [Fintype beta]
    {kappa : Fin 2 → PMF beta} (hs : IsSingularChannel kappa) :
    overlapMass (kappa 0) (kappa 1) =
      ∑ y, if kappa 0 y ≠ 0 ∧ kappa 1 y ≠ 0 then kappa 0 y else 0 := by
  unfold overlapMass
  exact Finset.sum_congr rfl (fun y _ => (singular_binary_column hs y).1)

open scoped Classical in
/-- Extended (121), without separately normalizing zero-mass components:
shared diagonal mass plus the exclusive product divided once by the residual
total. C04's construction already handles the overlap-zero/one endpoints. -/
theorem IsSingularChannel.maximalCoupling_apply_shared_exclusive {beta : Type u} [Fintype beta]
    {kappa : Fin 2 → PMF beta} (hs : IsSingularChannel kappa) (y z : beta) :
    maximalCoupling (kappa 0) (kappa 1) (y, z) =
      (if y = z then
        (if kappa 0 y ≠ 0 ∧ kappa 1 y ≠ 0 then kappa 0 y else 0) else 0) +
      (if kappa 1 y = 0 then kappa 0 y else 0) *
        (if kappa 0 z = 0 then kappa 1 z else 0) /
          (1 - overlapMass (kappa 0) (kappa 1)) := by
  rw [maximalCoupling_apply, (singular_binary_column hs y).2.1,
    (singular_binary_column hs z).2.2, (singular_binary_column hs y).1]

noncomputable section BinaryPosterior

variable {beta : Type u} [Fintype beta]

private def vectorLaw (kappa : Fin 2 → PMF beta) : PMF (Fin 2 → beta) :=
  (maximalCoupling (kappa 0) (kappa 1)).map (finTwoArrowEquiv beta).symm

private def rowJoint (q : PMF (Fin 2 → beta)) (i : Fin 2) :
    PMF ((Fin 2 → beta) × beta) := q.map (fun w => (w, w i))

private def rowPosterior (q : PMF (Fin 2 → beta)) (i : Fin 2) :
    beta → PMF (Fin 2 → beta) := condFstGivenSndChannel (rowJoint q i)

private theorem vectorLaw_isCanonicalCoupling (kappa : Fin 2 → PMF beta) :
    IsCanonicalCoupling kappa (vectorLaw kappa) :=
  (isCoupling_iff_isCanonicalCoupling_finTwoArrowEquiv kappa _).1
    (isCoupling_maximalCoupling _ _)

private theorem vectorLaw_apply (kappa : Fin 2 → PMF beta) (w : Fin 2 → beta) :
    vectorLaw kappa w = maximalCoupling (kappa 0) (kappa 1) (w 0, w 1) := by
  have heval : finTwoArrowEquiv beta w = (w 0, w 1) := rfl
  have h := PMF.map_apply_equiv (maximalCoupling (kappa 0) (kappa 1))
    (finTwoArrowEquiv beta).symm (finTwoArrowEquiv beta w)
  rw [Equiv.symm_apply_apply, heval] at h
  exact h

-- Equal row masses imply no off-diagonal supported vector can touch that label.
private theorem shared_vector_eq (kappa : Fin 2 → PMF beta)
    (hs : IsSingularChannel kappa) (y : beta)
    (hy0 : kappa 0 y ≠ 0) (hy1 : kappa 1 y ≠ 0)
    (w : Fin 2 → beta) (hw : w ∈ (vectorLaw kappa).support)
    (hcoord : w 0 = y ∨ w 1 = y) : w = fun _ => y := by
  have heq : kappa 0 y = kappa 1 y := hs 0 1 y hy0 hy1
  have hg : maximalCoupling (kappa 0) (kappa 1) (w 0, w 1) ≠ 0 := by
    rw [← vectorLaw_apply]
    exact hw
  have hsame : w 0 = w 1 := by
    by_contra h
    have hpos := (maximalCoupling_apply_pos_iff_of_ne (kappa 0) (kappa 1) h).1
      (pos_iff_ne_zero.mpr hg)
    rcases hcoord with h0 | h1
    · have hb := hpos.1
      rw [h0, heq] at hb
      exact (lt_irrefl _ hb)
    · have hb := hpos.2
      rw [h1, heq] at hb
      exact (lt_irrefl _ hb)
  have h0 : w 0 = y := hcoord.elim id (fun h1 => hsame.trans h1)
  have h1 : w 1 = y := hsame.symm.trans h0
  funext i
  exact ((Fin.forall_fin_two (p := fun j => w j = y)).2 ⟨h0, h1⟩) i

omit [Fintype beta] in
private theorem rowJoint_snd (q : PMF (Fin 2 → beta)) (i : Fin 2) :
    sndMarginal (rowJoint q i) = q.map (fun w => w i) := by
  simp only [rowJoint, sndMarginal_map]

omit [Fintype beta] in
private theorem rowJoint_fst (q : PMF (Fin 2 → beta)) (i : Fin 2) :
    fstMarginal (rowJoint q i) = q := by
  rw [rowJoint, fstMarginal_map]
  exact PMF.map_id q

private theorem rowPosterior_factorization (q : PMF (Fin 2 → beta)) (i : Fin 2) :
    q.map (fun w => (w i, w)) =
      PMF.channelJoint (q.map (fun w => w i)) (rowPosterior q i) := by
  have h := channelJoint_condFstGivenSndChannel (rowJoint q i)
  simpa only [rowJoint_snd, rowPosterior, rowJoint, PMF.map_comp, Function.comp_def,
    Prod.swap]
    using h.symm

private theorem rowPosterior_support (q : PMF (Fin 2 → beta)) (i : Fin 2)
    (y : beta) (hy : (q.map (fun w => w i)) y ≠ 0)
    (w : Fin 2 → beta) (hw : w ∈ (rowPosterior q i y).support) :
    w ∈ q.support ∧ w i = y := by
  have hy' : sndMarginal (rowJoint q i) y ≠ 0 := by rwa [rowJoint_snd]
  rw [rowPosterior, condFstGivenSndChannel_of_sndMarginal_ne_zero _ hy',
    support_condFstGivenSnd] at hw
  change (w, y) ∈ (q.map (fun v => (v, v i))).support at hw
  obtain ⟨v, hv, hvw⟩ := (PMF.mem_support_map_iff _ _ _).1 hw
  have hval : v = w := congrArg Prod.fst hvw
  subst v
  exact ⟨hv, congrArg Prod.snd hvw⟩

private theorem shared_rowPosterior_eq_pure (kappa : Fin 2 → PMF beta)
    (hs : IsSingularChannel kappa) (y : beta)
    (hy0 : kappa 0 y ≠ 0) (hy1 : kappa 1 y ≠ 0) (i : Fin 2) :
    rowPosterior (vectorLaw kappa) i y = PMF.pure (fun _ => y) := by
  classical
  have hC := vectorLaw_isCanonicalCoupling kappa
  have hy : ((vectorLaw kappa).map (fun w => w i)) y ≠ 0 := by
    rw [hC i]
    exact ((Fin.forall_fin_two (p := fun j => kappa j y ≠ 0)).2 ⟨hy0, hy1⟩) i
  have hall : ∀ w ∈ (rowPosterior (vectorLaw kappa) i y).support, w = fun _ => y := by
    intro w hw
    obtain ⟨hwq, hwi⟩ := rowPosterior_support (vectorLaw kappa) i y hy w hw
    apply shared_vector_eq kappa hs y hy0 hy1 w hwq
    have hi : ∀ j : Fin 2, w j = y → (w 0 = y ∨ w 1 = y) :=
      Fin.forall_fin_two.2 ⟨Or.inl, Or.inr⟩
    exact hi i hwi
  apply (PMF.eq_pure_iff_support_eq_singleton _ _).2
  obtain ⟨v, hv⟩ := (rowPosterior (vectorLaw kappa) i y).support_nonempty
  have hval := hall v hv
  ext w
  simp only [Set.mem_singleton_iff]
  constructor
  · exact hall w
  · intro hw
    rw [hw]
    simpa only [hval] using hv

private def commonPosterior (kappa : Fin 2 → PMF beta) : beta → PMF (Fin 2 → beta) :=
  fun y => if kappa 0 y = 0 then rowPosterior (vectorLaw kappa) 1 y
    else rowPosterior (vectorLaw kappa) 0 y

-- The pinned fallback is the vector law itself when both row masses vanish.
private theorem commonPosterior_null (kappa : Fin 2 → PMF beta) (y : beta)
    (hy0 : kappa 0 y = 0) (hy1 : kappa 1 y = 0) :
    commonPosterior kappa y = vectorLaw kappa := by
  classical
  have hC := vectorLaw_isCanonicalCoupling kappa
  have hy : sndMarginal (rowJoint (vectorLaw kappa) 1) y = 0 := by
    rw [rowJoint_snd, hC 1, hy1]
  rw [commonPosterior, if_pos hy0, rowPosterior,
    condFstGivenSndChannel_of_sndMarginal_eq_zero _ hy, rowJoint_fst]

/-- A singular binary channel's explicit maximal-coupling vector law has one
posterior factoring every row. At globally unused outputs, the selected total
posterior is the vector law itself; no default output is required. -/
theorem exists_binary_maximal_commonPosterior (kappa : Fin 2 → PMF beta)
    (hs : IsSingularChannel kappa) :
    ∃ V : beta → PMF (Fin 2 → beta), (∀ i,
      ((maximalCoupling (kappa 0) (kappa 1)).map (finTwoArrowEquiv beta).symm).map
        (fun w => (w i, w)) = PMF.channelJoint (kappa i) V) ∧
      ∀ y, kappa 0 y = 0 → kappa 1 y = 0 →
        V y = (maximalCoupling (kappa 0) (kappa 1)).map (finTwoArrowEquiv beta).symm := by
  classical
  refine ⟨commonPosterior kappa, ?_, commonPosterior_null kappa⟩
  change ∀ i, (vectorLaw kappa).map (fun w => (w i, w)) =
    PMF.channelJoint (kappa i) (commonPosterior kappa)
  have hC := vectorLaw_isCanonicalCoupling kappa
  have hrow (i : Fin 2) : (vectorLaw kappa).map (fun w => (w i, w)) =
      PMF.channelJoint (kappa i) (rowPosterior (vectorLaw kappa) i) := by
    simpa only [hC i] using rowPosterior_factorization (vectorLaw kappa) i
  refine Fin.forall_fin_two.2 ⟨?_, ?_⟩
  · refine (hrow 0).trans ?_
    apply (PMF.channelJoint_eq_iff_eq_on_support _ _ _).2
    intro y hy
    simp only [commonPosterior, if_neg hy]
  · refine (hrow 1).trans ?_
    apply (PMF.channelJoint_eq_iff_eq_on_support _ _ _).2
    intro y hy
    by_cases hy0 : kappa 0 y = 0
    · simp only [commonPosterior, if_pos hy0]
    · rw [commonPosterior, if_neg hy0,
        shared_rowPosterior_eq_pure kappa hs y hy0 hy 0,
        shared_rowPosterior_eq_pure kappa hs y hy0 hy 1]

end BinaryPosterior

/-- The binary-input direction of Lemma 2, transported through the exact input
cardinality equivalence. C03's generic necessity retains its original scope. -/
theorem isPerfectlyRepresentableChannel_iff_isSingular_of_input_card_eq_two
    {alpha : Type u} {beta : Type v} [Fintype alpha] [Finite beta] [Nonempty alpha]
    (kappa : alpha → PMF beta) (hcard : Fintype.card alpha = 2) :
    IsPerfectlyRepresentableChannel kappa ↔ IsSingularChannel kappa := by
  classical
  let : Fintype beta := Fintype.ofFinite beta
  constructor
  · exact fun h => h.isSingular
  · intro hs
    let e : alpha ≃ Fin 2 := Fintype.equivFinOfCardEq hcard
    obtain ⟨V, hV, _⟩ := exists_binary_maximal_commonPosterior
      (fun i => kappa (e.symm i)) (fun i j y hi hj => hs _ _ y hi hj)
    have hb : IsPerfectlyRepresentableChannel (fun i => kappa (e.symm i)) :=
      ⟨_, V, hV⟩
    apply (isPerfectlyRepresentableChannel_relabel_iff kappa e (Equiv.refl beta)).mp
    simpa only [Equiv.coe_refl, PMF.map_id] using hb

/-- Combined finite sufficiency in Lemma 2: binary input or at most two active
outputs. The output branch is C03's support-aware theorem, and its ambient
two-output specialization remains directly available. -/
theorem isPerfectlyRepresentableChannel_iff_isSingular_of_binary
    {alpha : Type u} {beta : Type v} [Fintype alpha] [Finite beta] [Nonempty alpha]
    (kappa : alpha → PMF beta) :
    let : Fintype (activeOutputs kappa) := Fintype.ofFinite _
    Fintype.card alpha = 2 ∨ Fintype.card (activeOutputs kappa) ≤ 2 →
      (IsPerfectlyRepresentableChannel kappa ↔ IsSingularChannel kappa) := by
  classical
  let : Fintype beta := Fintype.ofFinite beta
  let : Fintype (activeOutputs kappa) := Fintype.ofFinite _
  change Fintype.card alpha = 2 ∨ Fintype.card (activeOutputs kappa) ≤ 2 →
    (IsPerfectlyRepresentableChannel kappa ↔ IsSingularChannel kappa)
  intro h
  rcases h with hinput | houtput
  · exact isPerfectlyRepresentableChannel_iff_isSingular_of_input_card_eq_two kappa hinput
  · exact isPerfectlyRepresentableChannel_iff_isSingular_of_activeOutputs_card_le_two
      kappa houtput


/-! ## PFR-C05-S03: conditional entropy, mismatch and source transport -/

open scoped BigOperators ENNReal

noncomputable section BinaryEntropy

variable {beta : Type u} [Fintype beta]

omit [Fintype beta] in
private theorem outputVectorLaw (p : PMF (Fin 2)) (q : PMF (Fin 2 → beta)) :
    sndThirdMarginal (canonicalJoint p q) =
      (PMF.channelJoint q (fun w => p.map w)).map Prod.swap := by
  simp only [canonicalJoint, indepProd,
    PMF.channelJoint, PMF.map_bind, PMF.map_comp, Function.comp_def, Prod.swap]
  change p.bind (fun x => q.bind (fun w => PMF.pure (w x, w))) =
    q.bind (fun w => p.bind (fun x => PMF.pure (w x, w)))
  exact PMF.bind_comm p q (fun x w => PMF.pure (w x, w))

omit [Fintype beta] in
private theorem outputVectorLaw_apply (p : PMF (Fin 2))
    (q : PMF (Fin 2 → beta)) (y : beta) (w : Fin 2 → beta) :
    sndThirdMarginal (canonicalJoint p q) (y, w) = q w * (p.map w) y := by
  rw [outputVectorLaw]
  change ((PMF.channelJoint q (fun w => p.map w)).map
    (Equiv.prodComm (Fin 2 → beta) beta))
    ((Equiv.prodComm (Fin 2 → beta) beta) (w, y)) = _
  rw [PMF.map_apply_equiv, PMF.channelJoint_apply]

/-- On a positive vector fiber, canonical evaluation has the input prior
pushed through that vector. No conditional PMF is asserted at a null fiber. -/
theorem condFstGivenSnd_binaryCanonicalJoint (p : PMF (Fin 2))
    (q : PMF (Fin 2 → beta)) (w : Fin 2 → beta) (hw : q w ≠ 0) :
    condFstGivenSnd (sndThirdMarginal (canonicalJoint p q)) w
      (by simpa only [sndMarginal_sndThirdMarginal,
        thirdMarginal_canonicalJoint] using hw) = p.map w := by
  ext y
  rw [condFstGivenSnd_apply, outputVectorLaw_apply,
    sndMarginal_sndThirdMarginal, thirdMarginal_canonicalJoint, mul_comm]
  exact ENNReal.mul_div_cancel_right hw (q.apply_ne_top w)

open scoped Classical in
private theorem entropy_binaryEvaluation (p : PMF (Fin 2)) (w : Fin 2 → beta) :
    entropy (p.map w) = if w 0 = w 1 then 0 else entropy p := by
  classical
  by_cases hw : w 0 = w 1
  · have hc : w = Function.const (Fin 2) (w 0) := by
      funext i
      exact (Fin.forall_fin_two (p := fun j => w j = w 0)).mpr ⟨rfl, hw.symm⟩ i
    rw [if_pos hw, hc, PMF.map_const, entropy_pure]
  · rw [if_neg hw]
    apply entropy_map_injective
    intro i j hij
    have hall : ∀ k : Fin 2, k = 0 ∨ k = 1 :=
      (Fin.forall_fin_two (p := fun k => k = 0 ∨ k = 1)).mpr ⟨Or.inl rfl, Or.inr rfl⟩
    have hi := hall i
    have hj := hall j
    rcases hi with rfl | rfl <;> rcases hj with rfl | rfl
    · rfl
    · exact (hw hij).elim
    · exact (hw hij.symm).elim
    · rfl

open scoped Classical in
private theorem weighted_fiber (p : PMF (Fin 2)) (q : PMF (Fin 2 → beta))
    (w : Fin 2 → beta) :
    (q w).toReal * condEntropyFstGivenSnd
      (sndThirdMarginal (canonicalJoint p q)) w =
      (if w 0 ≠ w 1 then (q w).toReal else 0) * entropy p := by
  classical
  by_cases hw : q w = 0
  · simp [hw]
  · have hm : sndMarginal (sndThirdMarginal (canonicalJoint p q)) w ≠ 0 := by
      simpa only [sndMarginal_sndThirdMarginal, thirdMarginal_canonicalJoint] using hw
    rw [condEntropyFstGivenSnd_of_sndMarginal_ne_zero _ hm,
      condFstGivenSnd_binaryCanonicalJoint p q w hw, entropy_binaryEvaluation]
    by_cases he : w 0 = w 1 <;> simp [he]

open scoped Classical in
private theorem mismatch_vector_sum (q : PMF (Fin 2 → beta)) :
    (mismatchMass (q.map (finTwoArrowEquiv beta))).toReal =
      ∑ w, if w 0 ≠ w 1 then (q w).toReal else 0 := by
  classical
  rw [mismatchMass_toReal]
  symm
  apply Fintype.sum_equiv (finTwoArrowEquiv beta)
  intro w
  rw [PMF.map_apply_equiv]
  rfl

/-- Extended (152)-(154): binary canonical conditional entropy is mismatch
mass times input entropy, for every prior and vector law. Null fibers vanish
under their weights; no coupling or full-support premise is needed. -/
theorem condEntropyOf_binaryCanonicalJoint (p : PMF (Fin 2))
    (q : PMF (Fin 2 → beta)) :
    condEntropyOf (canonicalJoint p q) (fun t => t.2.1) (fun t => t.2.2) =
      (mismatchMass (q.map (finTwoArrowEquiv beta))).toReal * entropy p := by
  classical
  change condEntropy (sndThirdMarginal (canonicalJoint p q)) = _
  rw [condEntropy_eq_sum_sndMarginal_mul_condEntropyFstGivenSnd,
    sndMarginal_sndThirdMarginal, thirdMarginal_canonicalJoint, mismatch_vector_sum,
    Finset.sum_mul]
  apply Finset.sum_congr rfl
  intro w _
  exact weighted_fiber p q w


/-- The mutual-information form of the binary entropy identity, in nats. -/
theorem mutualInfoOf_binaryCanonicalJoint (p : PMF (Fin 2))
    (q : PMF (Fin 2 → beta)) :
    mutualInfoOf (canonicalJoint p q) (fun t => t.2.1) (fun t => t.2.2) =
      entropyOf (canonicalJoint p q) (fun t => t.2.1) -
        (mismatchMass (q.map (finTwoArrowEquiv beta))).toReal * entropy p := by
  rw [mutualInfoOf_eq_entropyOf_sub_condEntropyOf, condEntropyOf_binaryCanonicalJoint]

/-- The binary identity on the original source and fixed pair, using C02's
full-law equality. Only the value alphabet is finite. -/
theorem IsCanonicalFunctionalRepresentationOf.condEntropyOf_eq_binary_mismatch
    {omega : Type v} {mu : PMF omega} {X : omega → Fin 2}
    {Y : omega → beta} {W : omega → Fin 2 → beta}
    (h : IsCanonicalFunctionalRepresentationOf mu X Y W) :
    condEntropyOf mu Y W =
      (mismatchMass ((mu.map W).map (finTwoArrowEquiv beta))).toReal * entropyOf mu X := by
  have hEntropy := condEntropyOf_binaryCanonicalJoint (mu.map X) (mu.map W)
  rw [← h.jointLaw_eq_canonicalJoint] at hEntropy
  simpa only [condEntropyOf, entropyOf, PMF.map_comp, Function.comp_def] using hEntropy

/-- The information formula preserves the original output entropy and needs
no finite-source, channel-marginal or full-support hypothesis. -/
theorem IsCanonicalFunctionalRepresentationOf.mutualInfoOf_eq_binary_mismatch
    {omega : Type v} {mu : PMF omega} {X : omega → Fin 2}
    {Y : omega → beta} {W : omega → Fin 2 → beta}
    (h : IsCanonicalFunctionalRepresentationOf mu X Y W) :
    mutualInfoOf mu Y W = entropyOf mu Y -
      (mismatchMass ((mu.map W).map (finTwoArrowEquiv beta))).toReal * entropyOf mu X := by
  rw [mutualInfoOf_eq_entropyOf_sub_condEntropyOf, h.condEntropyOf_eq_binary_mismatch]

end BinaryEntropy

/-! ## PFR-C05-S04: universal bound and finite information attainment -/

noncomputable section BinaryOptimum
universe w

private theorem entropy_binary_eq_zero_of_not_fullSupport (p : PMF (Fin 2))
    (hp : ¬ ∀ x, x ∈ p.support) : entropy p = 0 := by
  classical
  obtain ⟨a, ha⟩ := not_forall.mp hp
  have ha0 : p a = 0 := (p.apply_eq_zero_iff a).2 ha
  have hsum : p 0 + p 1 = 1 := by
    simpa only [tsum_fintype, Fin.sum_univ_two] using p.tsum_coe
  have hCases : a = 0 ∨ a = 1 :=
    (Fin.forall_fin_two (p := fun k => k = 0 ∨ k = 1)).mpr ⟨Or.inl rfl, Or.inr rfl⟩ a
  rcases hCases with rfl | rfl
  · have h1 : p 1 = 1 := by simpa only [ha0, zero_add] using hsum
    have hPure : p = PMF.pure 1 :=
      (PMF.eq_pure_iff_support_eq_singleton p 1).2 ((p.apply_eq_one_iff 1).1 h1)
    rw [hPure, entropy_pure]
  · have h0 : p 0 = 1 := by simpa only [ha0, add_zero] using hsum
    have hPure : p = PMF.pure 0 :=
      (PMF.eq_pure_iff_support_eq_singleton p 0).2 ((p.apply_eq_one_iff 0).1 h0)
    rw [hPure, entropy_pure]

/-- Every finite-auxiliary representation of the prescribed binary channel pair
obeys the information bound, for every prior. A point-prior branch avoids
recovering unsupported channel rows from an arbitrary decoder. -/
theorem IsFunctionalRepresentationOf.mutualInfoOf_le_binary_bound
    {omega : Type u} {beta : Type v} {gamma : Type w}
    [Fintype beta] [Fintype gamma]
    {mu : PMF omega} {X : omega → Fin 2} {Y : omega → beta} {Z : omega → gamma}
    (hFR : IsFunctionalRepresentationOf mu X Y Z)
    (p : PMF (Fin 2)) (kappa : Fin 2 → PMF beta)
    (hPair : mu.map (fun s => (X s, Y s)) = PMF.channelJoint p kappa) :
    mutualInfoOf mu Y Z ≤ entropy (sndMarginal (PMF.channelJoint p kappa)) -
      finiteTV (kappa 0) (kappa 1) * entropy p := by
  classical
  have hX : mu.map X = p := by
    have h := congrArg fstMarginal hPair
    simpa only [fstMarginal_map_pair, PMF.channelJoint_map_fst] using h
  have hY : mu.map Y = sndMarginal (PMF.channelJoint p kappa) := by
    have h := congrArg sndMarginal hPair
    simpa only [sndMarginal_map_pair] using h
  by_cases hp : ∀ x, x ∈ p.support
  · obtain ⟨W, hC, hMI⟩ := hFR.exists_canonical_preserving_mutualInfo
    have hCanonical : IsCanonicalCoupling kappa (mu.map W) :=
      hC.isCanonicalCoupling_of_fullSupport kappa
        (by simpa only [hX] using hPair) (by simpa only [hX] using hp)
    have hCoupling :=
      (isCanonicalCoupling_iff_isCoupling_finTwoArrowEquiv kappa (mu.map W)).1 hCanonical
    have hBound := mul_le_mul_of_nonneg_right
      hCoupling.finiteTV_le_mismatchMass_toReal (entropy_nonneg p)
    rw [← hMI, hC.mutualInfoOf_eq_binary_mismatch]
    simp only [entropyOf, hX, hY]
    exact sub_le_sub_left hBound _
  · have hZero := entropy_binary_eq_zero_of_not_fullSupport p hp
    rw [hZero, mul_zero, sub_zero]
    have hBound := mutualInfoOf_le_entropyOf_left mu Y Z
    simpa only [entropyOf, hY] using hBound

variable {beta : Type u} [Fintype beta]

/-- The explicitly specified maximal-coupling canonical law attains the binary
information bound, with its full structural property and exact pair law. -/
theorem maximalBinaryCanonicalJoint_attains (p : PMF (Fin 2))
    (kappa : Fin 2 → PMF beta) :
    let t := canonicalJoint p
      ((maximalCoupling (kappa 0) (kappa 1)).map (finTwoArrowEquiv beta).symm)
    IsCanonicalFunctionalRepresentation t ∧
      fstSndMarginal t = PMF.channelJoint p kappa ∧
      mutualInfoOf t (fun a => a.2.1) (fun a => a.2.2) =
        entropy (sndMarginal (PMF.channelJoint p kappa)) -
          finiteTV (kappa 0) (kappa 1) * entropy p := by
  dsimp only
  have hPair := IsCoupling.fstSndMarginal_binaryCanonicalJoint (kappa := kappa)
    (isCoupling_maximalCoupling (kappa 0) (kappa 1)) p
  refine ⟨isCanonicalFunctionalRepresentation_canonicalJoint _ _, hPair, ?_⟩
  rw [mutualInfoOf_binaryCanonicalJoint, map_finTwoArrowEquiv_symm_roundtrip,
    mismatchMass_maximalCoupling_toReal]
  have hY : (canonicalJoint p
      ((maximalCoupling (kappa 0) (kappa 1)).map (finTwoArrowEquiv beta).symm)).map
      (fun a => a.2.1) = sndMarginal (PMF.channelJoint p kappa) := by
    rw [← hPair]
    simp only [sndMarginal, fstSndMarginal, PMF.map_comp, Function.comp_def]
  change entropy _ - _ = _
  rw [hY]

/-- A finite attaining representation, composable with the universal bound.
The auxiliary is explicitly the finite binary vector alphabet. -/
theorem exists_binary_information_maximizer (p : PMF (Fin 2))
    (kappa : Fin 2 → PMF beta) :
    ∃ t : PMF (Fin 2 × beta × (Fin 2 → beta)),
      IsFunctionalRepresentation t ∧
      fstSndMarginal t = PMF.channelJoint p kappa ∧
      mutualInfoOf t (fun a => a.2.1) (fun a => a.2.2) =
        entropy (sndMarginal (PMF.channelJoint p kappa)) -
          finiteTV (kappa 0) (kappa 1) * entropy p := by
  obtain ⟨hC, hPair, hInfo⟩ := maximalBinaryCanonicalJoint_attains p kappa
  exact ⟨_, hC.isFunctionalRepresentation, hPair, hInfo⟩

end BinaryOptimum

/-! ## PFR-C05-S05: equality and semantic binary input transport -/

noncomputable section BinaryEquality
variable {beta : Type u} [Fintype beta]

private theorem conditionalOutput_eq_entropy_sub_mutualInfo
    {gamma : Type v} (t : PMF (Fin 2 × beta × gamma)) :
    condEntropyOf t (fun a => a.2.1) (fun a => a.1) =
      entropy (sndMarginal (fstSndMarginal t)) - mutualInfo (fstSndMarginal t) := by
  have h := mutualInfoOf_eq_entropyOf_sub_condEntropyOf_swap t
    (fun a => a.1) (fun a => a.2.1)
  have hY : entropyOf t (fun a => a.2.1) =
      entropy (sndMarginal (fstSndMarginal t)) := by
    simp only [entropyOf, sndMarginal, fstSndMarginal, PMF.map_comp, Function.comp_def]
  change mutualInfo (fstSndMarginal t) = _ at h
  rw [hY] at h
  linarith

omit [Fintype beta] in
private theorem functionalRepresentation_coordinates
    {gamma : Type v} {t : PMF (Fin 2 × beta × gamma)}
    (h : IsFunctionalRepresentation t) :
    IsFunctionalRepresentationOf t (fun a => a.1) (fun a => a.2.1)
      (fun a => a.2.2) := by
  have hId : (fun a : Fin 2 × beta × gamma => (a.1, a.2.1, a.2.2)) = id := by
    funext a
    simp only [Prod.eta, id_eq]
  simpa only [IsFunctionalRepresentationOf, hId, PMF.map_id] using h

/-- Finite attainment and C01's representation bound give the channel-information
inequality without a support assumption or an equality-case analytic argument. -/
theorem mutualInfo_channelJoint_le_binary_entropy (p : PMF (Fin 2))
    (kappa : Fin 2 → PMF beta) :
    mutualInfo (PMF.channelJoint p kappa) ≤
      finiteTV (kappa 0) (kappa 1) * entropy p := by
  obtain ⟨t, hFR, hPair, hAttain⟩ := exists_binary_information_maximizer p kappa
  have hBound := (functionalRepresentation_coordinates hFR).mutualInfoOf_le_condEntropyOf
  rw [hAttain, conditionalOutput_eq_entropy_sub_mutualInfo, hPair] at hBound
  linarith

/-- A singular binary channel attains the quantitative equality for every prior. -/
theorem IsSingularChannel.binary_entropy_eq_mutualInfo
    {kappa : Fin 2 → PMF beta} (hs : IsSingularChannel kappa) (p : PMF (Fin 2)) :
    finiteTV (kappa 0) (kappa 1) * entropy p =
      mutualInfo (PMF.channelJoint p kappa) := by
  have hChannel : IsPerfectlyRepresentableChannel kappa :=
    (isPerfectlyRepresentableChannel_iff_isSingular_of_input_card_eq_two
      kappa (by simp)).2 hs
  obtain ⟨q, hC, hPerfect⟩ := hChannel.exists_canonicalCoupling
  have hPair := hC.fstSndMarginal_canonicalJoint p
  have hBound := (functionalRepresentation_coordinates (hPerfect p).1).mutualInfoOf_le_binary_bound
    p kappa hPair
  rw [(hPerfect p).2, conditionalOutput_eq_entropy_sub_mutualInfo, hPair] at hBound
  have hLower := mutualInfo_channelJoint_le_binary_entropy p kappa
  linarith

/-- Under full input support, equality makes a finite attaining representation
perfect and hence recovers singularity of the ambient channel. -/
theorem binary_entropy_eq_mutualInfo_iff_isSingular_of_fullSupport
    (p : PMF (Fin 2)) (kappa : Fin 2 → PMF beta) (hp : ∀ x, x ∈ p.support) :
    finiteTV (kappa 0) (kappa 1) * entropy p = mutualInfo (PMF.channelJoint p kappa) ↔
      IsSingularChannel kappa := by
  constructor
  · intro hEq
    obtain ⟨t, hFR, hPair, hAttain⟩ := exists_binary_information_maximizer p kappa
    have hPerfect : IsPerfectFunctionalRepresentation t := by
      refine ⟨hFR, ?_⟩
      rw [hAttain, conditionalOutput_eq_entropy_sub_mutualInfo, hPair, hEq]
    have hPairPerfect : IsPerfectlyRepresentablePair (PMF.channelJoint p kappa) := by
      rw [← hPair]
      exact hPerfect.isPerfectlyRepresentablePair
    exact ((isPerfectlyRepresentablePair_channelJoint_iff_of_fullSupport p kappa hp).1
      hPairPerfect).isSingular
  · intro hs
    exact hs.binary_entropy_eq_mutualInfo p

end BinaryEquality

noncomputable section BinaryInputTransport
universe w x

/-- Binary input enumeration transports both the prior and the exact channel pair law. -/
theorem channelJoint_map_binaryInput {alpha : Type u} {beta : Type v}
    (e : alpha ≃ Fin 2) (p : PMF alpha) (kappa : alpha → PMF beta) :
    (PMF.channelJoint p kappa).map (fun t => (e t.1, t.2)) =
      PMF.channelJoint (p.map e) (fun i => kappa (e.symm i)) := by
  simp only [PMF.channelJoint, PMF.map_bind, PMF.map_comp, PMF.bind_map,
    Function.comp_def, Equiv.symm_apply_apply]

private theorem binaryInput_outputLaw {alpha : Type u} {beta : Type v}
    (e : alpha ≃ Fin 2) (p : PMF alpha) (kappa : alpha → PMF beta) :
    sndMarginal (PMF.channelJoint (p.map e) (fun i => kappa (e.symm i))) =
      sndMarginal (PMF.channelJoint p kappa) := by
  rw [← channelJoint_map_binaryInput]
  simp only [sndMarginal, PMF.map_comp, Function.comp_def]

private theorem binaryInput_mutualInfo {alpha : Type u} {beta : Type v}
    [Fintype alpha] [Fintype beta]
    (e : alpha ≃ Fin 2) (p : PMF alpha) (kappa : alpha → PMF beta) :
    mutualInfo (PMF.channelJoint (p.map e) (fun i => kappa (e.symm i))) =
      mutualInfo (PMF.channelJoint p kappa) := by
  have hH := entropy_map_equiv (PMF.channelJoint p kappa)
    (e.prodCongr (Equiv.refl beta))
  change entropy ((PMF.channelJoint p kappa).map (fun t => (e t.1, t.2))) = _ at hH
  rw [channelJoint_map_binaryInput] at hH
  rw [mutualInfo_eq, mutualInfo_eq, binaryInput_outputLaw, hH]
  simp only [fstMarginal, PMF.channelJoint_map_fst, entropy_map_equiv]

private theorem binaryInput_fullSupport {alpha : Type u}
    (e : alpha ≃ Fin 2) (p : PMF alpha) :
    (∀ i, i ∈ (p.map e).support) ↔ ∀ a, a ∈ p.support := by
  constructor
  · intro h a
    obtain ⟨b, hb, he⟩ := (PMF.mem_support_map_iff _ _ _).1 (h (e a))
    simpa only [e.injective he] using hb
  · intro h i
    exact (PMF.mem_support_map_iff _ _ _).2
      ⟨e.symm i, h _, e.apply_symm_apply i⟩

private theorem functional_binaryInput {omega : Type u} {alpha : Type v}
    {beta : Type w} {gamma : Type x}
    {mu : PMF omega} {X : omega → alpha} {Y : omega → beta} {Z : omega → gamma}
    (hFR : IsFunctionalRepresentationOf mu X Y Z) (e : alpha ≃ Fin 2) :
    IsFunctionalRepresentationOf mu (fun s => e (X s)) Y Z := by
  obtain ⟨hI, d, hd⟩ := (isFunctionalRepresentationOf_iff _ _ _ _).1 hFR
  apply (isFunctionalRepresentationOf_iff _ _ _ _).2
  refine ⟨?_, (fun t => d (e.symm t.1, t.2)), ?_⟩
  · apply (isIndependentOf_swap _ _ _).1
    exact isIndependentOf_comp_right mu Z X e ((isIndependentOf_swap _ _ _).2 hI)
  · intro s hs
    simpa only [Equiv.symm_apply_apply] using hd s hs

/-- The universal information bound under any binary input enumeration, expressed
in the original common-base entropies. Source and auxiliary universes are independent. -/
theorem IsFunctionalRepresentationOf.mutualInfoOf_le_twoInput_bound
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    {mu : PMF omega} {X : omega → alpha} {Y : omega → beta} {Z : omega → gamma}
    (hFR : IsFunctionalRepresentationOf mu X Y Z) (e : alpha ≃ Fin 2)
    (p : PMF alpha) (kappa : alpha → PMF beta)
    (hPair : mu.map (fun s => (X s, Y s)) = PMF.channelJoint p kappa) :
    mutualInfoOf mu Y Z ≤ entropyOf mu Y -
      finiteTV (kappa (e.symm 0)) (kappa (e.symm 1)) * entropyOf mu X := by
  have hPair' : mu.map (fun s => (e (X s), Y s)) =
      PMF.channelJoint (p.map e) (fun i => kappa (e.symm i)) := by
    rw [← channelJoint_map_binaryInput, ← hPair, PMF.map_comp]
    rfl
  have h := (functional_binaryInput hFR e).mutualInfoOf_le_binary_bound
    (p.map e) (fun i => kappa (e.symm i)) hPair'
  have hX : mu.map X = p := by
    simpa only [fstMarginal_map_pair, PMF.channelJoint_map_fst] using congrArg fstMarginal hPair
  have hY : mu.map Y = sndMarginal (PMF.channelJoint p kappa) := by
    simpa only [sndMarginal_map_pair] using congrArg sndMarginal hPair
  simpa only [entropyOf, hX, hY, entropy_map_equiv, binaryInput_outputLaw] using h


private theorem canonicalJoint_binaryInput {alpha : Type u} {beta : Type v}
    (e : alpha ≃ Fin 2) (p : PMF alpha) (q : PMF (Fin 2 → beta)) :
    canonicalJoint p (q.map (fun w x => w (e x))) =
      (canonicalJoint (p.map e) q).map
        (fun t => (e.symm t.1, t.2.1, fun x => t.2.2 (e x))) := by
  simp only [canonicalJoint, indepProd, PMF.map_bind, PMF.map_comp, PMF.bind_map,
    Function.comp_def, Equiv.symm_apply_apply]

open scoped Classical in
/-- The specified maximal binary coupling, transported to vectors on the semantic
input type, retains canonical structure, the exact pair law and information attainment. -/
theorem maximalTwoInputCanonicalJoint_attains {alpha : Type u} {beta : Type v}
    [Fintype alpha] [Fintype beta]
    (e : alpha ≃ Fin 2) (p : PMF alpha) (kappa : alpha → PMF beta) :
    let q := ((maximalCoupling (kappa (e.symm 0)) (kappa (e.symm 1))).map
      (finTwoArrowEquiv beta).symm).map (fun w x => w (e x))
    let t := canonicalJoint p q
    IsCanonicalFunctionalRepresentation t ∧
      fstSndMarginal t = PMF.channelJoint p kappa ∧
      mutualInfoOf t (fun a => a.2.1) (fun a => a.2.2) =
        entropy (sndMarginal (PMF.channelJoint p kappa)) -
          finiteTV (kappa (e.symm 0)) (kappa (e.symm 1)) * entropy p := by
  classical
  let q0 := (maximalCoupling (kappa (e.symm 0)) (kappa (e.symm 1))).map
    (finTwoArrowEquiv beta).symm
  let t0 := canonicalJoint (p.map e) q0
  have hC0 : IsCanonicalCoupling (fun i => kappa (e.symm i)) q0 :=
    (isCoupling_iff_isCanonicalCoupling_finTwoArrowEquiv _ _).1
      (isCoupling_maximalCoupling _ _)
  have hC : IsCanonicalCoupling kappa (q0.map (fun w x => w (e x))) := by
    intro a
    simpa only [PMF.map_comp, Function.comp_def, Equiv.symm_apply_apply] using hC0 (e a)
  have hPair := hC.fstSndMarginal_canonicalJoint p
  refine ⟨isCanonicalFunctionalRepresentation_canonicalJoint _ _, hPair, ?_⟩
  change mutualInfoOf (canonicalJoint p (q0.map (fun w x => w (e x)))) _ _ = _
  have hInj : Function.Injective (fun w : Fin 2 → beta => fun x => w (e x)) := by
    intro a b h
    funext i
    simpa only [Equiv.apply_symm_apply] using congrFun h (e.symm i)
  have hAux := entropyOf_comp_injective t0 (fun t => t.2.2) hInj
  have hYA := entropyOf_comp_injective t0 (fun t => (t.2.1, t.2.2))
    (f := fun yw : beta × (Fin 2 → beta) => (yw.1, fun x => yw.2 (e x)))
    (by
      intro a b h
      exact Prod.ext (congrArg (fun z : beta × (alpha → beta) => z.1) h)
        (hInj (congrArg (fun z : beta × (alpha → beta) => z.2) h)))
  have hInfo : mutualInfoOf (canonicalJoint p (q0.map (fun w x => w (e x))))
      (fun t => t.2.1) (fun t => t.2.2) =
      mutualInfoOf t0 (fun t => t.2.1) (fun t => t.2.2) := by
    rw [canonicalJoint_binaryInput]
    change mutualInfo _ = _
    simp only [PMF.map_comp, Function.comp_def]
    change mutualInfoOf t0 (fun t => t.2.1) (fun t => fun x => t.2.2 (e x)) = _
    simp only [mutualInfoOf_eq, jointEntropyOf]
    rw [hAux, hYA]
  rw [hInfo]
  simpa only [entropy_map_equiv, binaryInput_outputLaw] using
    (maximalBinaryCanonicalJoint_attains (p.map e) (fun i => kappa (e.symm i))).2.2

open scoped Classical in
/-- A finite attaining triple-law extension for any two-input enumeration. -/
theorem exists_twoInput_information_maximizer {alpha : Type u} {beta : Type v}
    [Fintype alpha] [Fintype beta]
    (e : alpha ≃ Fin 2) (p : PMF alpha) (kappa : alpha → PMF beta) :
    ∃ t : PMF (alpha × beta × (alpha → beta)),
      IsFunctionalRepresentation t ∧
      fstSndMarginal t = PMF.channelJoint p kappa ∧
      mutualInfoOf t (fun a => a.2.1) (fun a => a.2.2) =
        entropy (sndMarginal (PMF.channelJoint p kappa)) -
          finiteTV (kappa (e.symm 0)) (kappa (e.symm 1)) * entropy p := by
  obtain ⟨hC, hPair, hInfo⟩ := maximalTwoInputCanonicalJoint_attains e p kappa
  exact ⟨_, hC.isFunctionalRepresentation, hPair, hInfo⟩


/-- The quantitative information inequality for any enumerated two-input channel. -/
theorem mutualInfo_channelJoint_le_twoInput_entropy {alpha : Type u} {beta : Type v}
    [Fintype alpha] [Fintype beta] (e : alpha ≃ Fin 2)
    (p : PMF alpha) (kappa : alpha → PMF beta) :
    mutualInfo (PMF.channelJoint p kappa) ≤
      finiteTV (kappa (e.symm 0)) (kappa (e.symm 1)) * entropy p := by
  simpa only [binaryInput_mutualInfo, entropy_map_equiv] using
    mutualInfo_channelJoint_le_binary_entropy (p.map e) (fun i => kappa (e.symm i))

/-- Singularity gives quantitative equality for every prior, including point priors. -/
theorem IsSingularChannel.twoInput_entropy_eq_mutualInfo {alpha : Type u} {beta : Type v}
    [Fintype alpha] [Fintype beta] (e : alpha ≃ Fin 2)
    {kappa : alpha → PMF beta} (hs : IsSingularChannel kappa) (p : PMF alpha) :
    finiteTV (kappa (e.symm 0)) (kappa (e.symm 1)) * entropy p =
      mutualInfo (PMF.channelJoint p kappa) := by
  have hs' : IsSingularChannel (fun i => kappa (e.symm i)) := by
    intro i j y hi hj
    exact hs _ _ y hi hj
  simpa only [binaryInput_mutualInfo, entropy_map_equiv] using
    hs'.binary_entropy_eq_mutualInfo (p.map e)

/-- Full input support is needed only to recover the ambient channel from equality. -/
theorem twoInput_entropy_eq_mutualInfo_iff_isSingular_of_fullSupport
    {alpha : Type u} {beta : Type v} [Fintype alpha] [Fintype beta]
    (e : alpha ≃ Fin 2) (p : PMF alpha) (kappa : alpha → PMF beta)
    (hp : ∀ a, a ∈ p.support) :
    finiteTV (kappa (e.symm 0)) (kappa (e.symm 1)) * entropy p =
      mutualInfo (PMF.channelJoint p kappa) ↔ IsSingularChannel kappa := by
  have h := binary_entropy_eq_mutualInfo_iff_isSingular_of_fullSupport
    (p.map e) (fun i => kappa (e.symm i)) ((binaryInput_fullSupport e p).2 hp)
  have hs : IsSingularChannel (fun i => kappa (e.symm i)) ↔ IsSingularChannel kappa := by
    constructor
    · intro h a b y ha hb
      simpa only [Equiv.symm_apply_apply] using h (e a) (e b) y
        (by simpa only [Equiv.symm_apply_apply] using ha)
        (by simpa only [Equiv.symm_apply_apply] using hb)
    · intro h i j y hi hj
      exact h _ _ y hi hj
  simpa only [binaryInput_mutualInfo, entropy_map_equiv, hs] using h

/-- Common-base information inequality under the exact prescribed pair law.
The source alphabet is unrestricted. -/
theorem mutualInfoOf_le_twoInput_entropy {omega : Type u} {alpha : Type v} {beta : Type w}
    [Fintype alpha] [Fintype beta] (e : alpha ≃ Fin 2)
    (mu : PMF omega) (X : omega → alpha) (Y : omega → beta)
    (p : PMF alpha) (kappa : alpha → PMF beta)
    (hPair : mu.map (fun s => (X s, Y s)) = PMF.channelJoint p kappa) :
    mutualInfoOf mu X Y ≤
      finiteTV (kappa (e.symm 0)) (kappa (e.symm 1)) * entropyOf mu X := by
  have hX : mu.map X = p := by
    simpa only [fstMarginal_map_pair, PMF.channelJoint_map_fst] using congrArg fstMarginal hPair
  simpa only [mutualInfoOf, entropyOf, hPair, hX] using
    mutualInfo_channelJoint_le_twoInput_entropy e p kappa

/-- The singular forward equality on any source having the prescribed pair law. -/
theorem IsSingularChannel.twoInput_entropyOf_eq_mutualInfoOf
    {omega : Type u} {alpha : Type v} {beta : Type w}
    [Fintype alpha] [Fintype beta] (e : alpha ≃ Fin 2)
    (mu : PMF omega) (X : omega → alpha) (Y : omega → beta)
    (p : PMF alpha) {kappa : alpha → PMF beta} (hs : IsSingularChannel kappa)
    (hPair : mu.map (fun s => (X s, Y s)) = PMF.channelJoint p kappa) :
    finiteTV (kappa (e.symm 0)) (kappa (e.symm 1)) * entropyOf mu X =
      mutualInfoOf mu X Y := by
  have hX : mu.map X = p := by
    simpa only [fstMarginal_map_pair, PMF.channelJoint_map_fst] using congrArg fstMarginal hPair
  simpa only [mutualInfoOf, entropyOf, hPair, hX] using hs.twoInput_entropy_eq_mutualInfo e p

/-- Common-base equality characterizes the ambient two-input channel when every
input has positive prior mass. No output-support or source-finiteness premise is used. -/
theorem twoInput_entropyOf_eq_mutualInfoOf_iff_isSingular_of_fullSupport
    {omega : Type u} {alpha : Type v} {beta : Type w}
    [Fintype alpha] [Fintype beta] (e : alpha ≃ Fin 2)
    (mu : PMF omega) (X : omega → alpha) (Y : omega → beta)
    (p : PMF alpha) (kappa : alpha → PMF beta)
    (hPair : mu.map (fun s => (X s, Y s)) = PMF.channelJoint p kappa)
    (hp : ∀ a, a ∈ p.support) :
    finiteTV (kappa (e.symm 0)) (kappa (e.symm 1)) * entropyOf mu X =
      mutualInfoOf mu X Y ↔ IsSingularChannel kappa := by
  have hX : mu.map X = p := by
    simpa only [fstMarginal_map_pair, PMF.channelJoint_map_fst] using congrArg fstMarginal hPair
  simpa only [mutualInfoOf, entropyOf, hPair, hX] using
    twoInput_entropy_eq_mutualInfo_iff_isSingular_of_fullSupport e p kappa hp

end BinaryInputTransport

end PerfectFunctionalRepresentations
