import PerfectFunctionalRepresentations.Matrix.Reachability
import PerfectFunctionalRepresentations.Matrix.MultiwayOperations

/-!
# Theorem 1: canonical-coupling reachability

Theorem 1's construction starts from one prior-free vector law `q` and common
posterior `V`. The auxiliary output is the ordered pair `(y,w)`. Its active
labels retain both positive vector mass and a nonempty decoder fiber. Those
fibers form exact labelled partitions. One supplied enumeration fixes a common
finite endpoint independently of the later operation constructions.

The probability and label machinery is private to this construction. The
selected total channels express law factorizations; conditional identities
apply on supported fibers, without identifying arbitrary null completions.
ISIT Appendix (20)-(28), supplemented by extended version 16 (16)-(24) and
Figure 1's constant-value blocks. The original-channel PPS path and the
all-ones PPS/VPS path reach that same specified endpoint with explicit maps.
Witnessed reversal and composition give both public reachability characterizations.
-/

namespace PerfectFunctionalRepresentations.MatrixOperations
namespace CanonicalConstruction

open LeanInfoTheory.Shannon

noncomputable section
attribute [local instance] Classical.propDecidable

universe u v
variable {alpha : Type u} {beta : Type v}

private def auxiliaryChannel (q : PMF (alpha → beta)) (x : alpha) :
    PMF (beta × (alpha → beta)) :=
  q.map fun w => (w x, w)

private theorem auxiliaryChannel_apply (q : PMF (alpha → beta))
    (x : alpha) (y : beta) (w : alpha → beta) :
    auxiliaryChannel q x (y, w) = if w x = y then q w else 0 := by
  by_cases he : w x = y
  · rw [if_pos he, ← he]
    exact PMF.map_apply_of_injective q (fun _ _ h => congrArg Prod.snd h) w
  · rw [if_neg he]
    exact PMF.map_apply_eq_zero_of_notMem_range q (by
      rintro ⟨f, hf⟩
      have hfw : f = w := congrArg Prod.snd hf
      exact he (hfw ▸ congrArg Prod.fst hf))

private theorem auxiliaryChannel_map_snd (q : PMF (alpha → beta)) (x : alpha) :
    (auxiliaryChannel q x).map Prod.snd = q := by
  rw [auxiliaryChannel, PMF.map_comp]
  exact PMF.map_id q

private def posteriorSplit (V : beta → PMF (alpha → beta)) (y : beta) :
    PMF (beta × (alpha → beta)) :=
  (V y).map fun w => (y, w)

private theorem posteriorSplit_apply (V : beta → PMF (alpha → beta))
    (y z : beta) (w : alpha → beta) :
    posteriorSplit V y (z, w) = if z = y then V y w else 0 := by
  by_cases he : z = y
  · subst z
    rw [if_pos rfl]
    exact PMF.map_apply_of_injective _ (fun _ _ h => congrArg Prod.snd h) w
  · rw [if_neg he]
    exact PMF.map_apply_eq_zero_of_notMem_range _ (by
      rintro ⟨f, hf⟩
      exact he (congrArg Prod.fst hf).symm)

section CommonPosterior

variable (q : PMF (alpha → beta)) (kappa : alpha → PMF beta)
  (V : beta → PMF (alpha → beta))
  (hV : ∀ x, auxiliaryChannel q x = PMF.channelJoint (kappa x) V)

include hV in
private theorem auxiliaryChannel_factor_apply (x : alpha) (y : beta) (w : alpha → beta) :
    auxiliaryChannel q x (y, w) = kappa x y * V y w := by
  rw [hV x, PMF.channelJoint_apply]

include hV in
private theorem bind_posteriorSplit (x : alpha) :
    (kappa x).bind (posteriorSplit V) = auxiliaryChannel q x :=
  (hV x).symm

include hV in
private theorem auxiliaryChannel_map_fst (x : alpha) :
    (auxiliaryChannel q x).map Prod.fst = kappa x := by
  rw [hV x, PMF.channelJoint_map_fst]

end CommonPosterior

/-! Restricting to positive vector mass preserves the original law exactly. -/

private theorem supportPrior_apply (q : PMF (alpha → beta)) (w : q.support) :
    inputSupportPrior q w = q w.val := by
  calc
    inputSupportPrior q w = (inputSupportPrior q).map Subtype.val w.val :=
      (PMF.map_apply_of_injective _ Subtype.val_injective w).symm
    _ = q w.val := congrArg (fun r : PMF (alpha → beta) => r w.val)
      (map_val_inputSupportPrior q)

private def supportedAuxiliaryChannel (q : PMF (alpha → beta)) (x : alpha) :
    PMF (beta × q.support) :=
  (inputSupportPrior q).map fun w => (w.val x, w)

private theorem supportedAuxiliaryChannel_map (q : PMF (alpha → beta)) (x : alpha) :
    (supportedAuxiliaryChannel q x).map (fun yw => (yw.1, yw.2.val)) =
      auxiliaryChannel q x := by
  simpa only [supportedAuxiliaryChannel, auxiliaryChannel, PMF.map_comp, Function.comp_def]
    using congrArg (fun r : PMF (alpha → beta) => r.map fun w => (w x, w))
      (map_val_inputSupportPrior q)

/-! The specified auxiliary is perfect for every input law, including pure laws.
The semantic predicate exposes `Fintype`; retaining the input equality instance
also lets concrete consumers use their existing function-alphabet enumeration. -/

private theorem fixedW_perfect [Fintype alpha] [Fintype beta] [DecidableEq alpha]
    (p : PMF alpha) (q : PMF (alpha → beta)) :
    IsPerfectFunctionalRepresentationOf (indepProd p q) Prod.fst
      (fun xw => (xw.2 xw.1, xw.2)) Prod.snd := by
  rw [isPerfectFunctionalRepresentationOf_iff_isMarkovChainOf]
  constructor
  · rw [isFunctionalRepresentationOf_iff]
    refine ⟨?_, fun xw => (xw.2 xw.1, xw.2), fun _ _ => rfl⟩
    change IsIndependent ((indepProd p q).map id)
    rw [PMF.map_id]
    exact isIndependent_indepProd p q
  · exact isMarkovChainOf_comp (indepProd p q) Prod.fst
      (fun xw => (xw.2 xw.1, xw.2)) Prod.snd

private theorem fixedW_factorization (p : PMF alpha) (q : PMF (alpha → beta)) :
    (indepProd p q).map (fun xw => (xw.1, (xw.2 xw.1, xw.2), xw.2)) =
      PMF.channelExtension
        ((indepProd p q).map (fun xw => (xw.1, (xw.2 xw.1, xw.2))))
        (fun yw => PMF.pure yw.2) := by
  change _ = PMF.channelExtension _ (PMF.deterministicChannel Prod.snd)
  rw [PMF.channelExtension_deterministicChannel, PMF.map_comp]
  rfl

private theorem fixedW_pair_eq_channelJoint (p : PMF alpha) (q : PMF (alpha → beta)) :
    (indepProd p q).map (fun xw => (xw.1, (xw.2 xw.1, xw.2))) =
      PMF.channelJoint p (auxiliaryChannel q) := by
  simp only [indepProd, PMF.channelJoint, auxiliaryChannel,
    PMF.map_bind, PMF.map_comp, Function.comp_def]

/-! The same specified auxiliary on its support, with pair and triple recovery. -/

private theorem supported_product_include (p : PMF alpha) (q : PMF (alpha → beta)) :
    (indepProd p (inputSupportPrior q)).map (fun xu => (xu.1, xu.2.val)) =
      indepProd p q := by
  calc
    _ = indepProd p ((inputSupportPrior q).map Subtype.val) := by
      simp only [indepProd, PMF.map_bind, PMF.map_comp, Function.comp_def]
    _ = _ := by rw [map_val_inputSupportPrior]

private theorem supported_pair_include (p : PMF alpha) (q : PMF (alpha → beta)) :
    ((indepProd p (inputSupportPrior q)).map
      (fun xu => (xu.1, (xu.2.val xu.1, xu.2)))).map
        (fun xy => (xy.1, (xy.2.1, xy.2.2.val))) =
      (indepProd p q).map (fun xw => (xw.1, (xw.2 xw.1, xw.2))) := by
  simpa only [PMF.map_comp, Function.comp_def] using
    congrArg (fun r : PMF (alpha × (alpha → beta)) =>
      r.map (fun xw => (xw.1, (xw.2 xw.1, xw.2)))) (supported_product_include p q)

private theorem supported_triple_include (p : PMF alpha) (q : PMF (alpha → beta)) :
    ((indepProd p (inputSupportPrior q)).map
      (fun xu => (xu.1, (xu.2.val xu.1, xu.2), xu.2))).map
        (fun xyz => (xyz.1, (xyz.2.1.1, xyz.2.1.2.val), xyz.2.2.val)) =
      (indepProd p q).map (fun xw => (xw.1, (xw.2 xw.1, xw.2), xw.2)) := by
  simpa only [PMF.map_comp, Function.comp_def] using
    congrArg (fun r : PMF (alpha × (alpha → beta)) =>
      r.map (fun xw => (xw.1, (xw.2 xw.1, xw.2), xw.2))) (supported_product_include p q)

private theorem supported_factorization (p : PMF alpha) (q : PMF (alpha → beta)) :
    (indepProd p (inputSupportPrior q)).map
      (fun xu => (xu.1, (xu.2.val xu.1, xu.2), xu.2)) =
      PMF.channelExtension
        ((indepProd p (inputSupportPrior q)).map
          (fun xu => (xu.1, (xu.2.val xu.1, xu.2))))
        (fun yu => PMF.pure yu.2) := by
  change _ = PMF.channelExtension _ (PMF.deterministicChannel Prod.snd)
  rw [PMF.channelExtension_deterministicChannel, PMF.map_comp]
  rfl

private theorem supported_factorization_include (p : PMF alpha) (q : PMF (alpha → beta)) :
    (PMF.channelExtension
      ((indepProd p (inputSupportPrior q)).map
        (fun xu => (xu.1, (xu.2.val xu.1, xu.2))))
      (fun yu => PMF.pure yu.2)).map
        (fun xyz => (xyz.1, (xyz.2.1.1, xyz.2.1.2.val), xyz.2.2.val)) =
      PMF.channelExtension
        ((indepProd p q).map (fun xw => (xw.1, (xw.2 xw.1, xw.2))))
        (fun yw => PMF.pure yw.2) := by
  rw [← supported_factorization, supported_triple_include, fixedW_factorization]

private theorem supported_fixedW_perfect [Fintype alpha] [Fintype beta] [DecidableEq alpha]
    (p : PMF alpha) (q : PMF (alpha → beta)) :
    IsPerfectFunctionalRepresentationOf (indepProd p (inputSupportPrior q)) Prod.fst
      (fun xu => (xu.2.val xu.1, xu.2)) Prod.snd := by
  rw [isPerfectFunctionalRepresentationOf_iff_isMarkovChainOf]
  constructor
  · rw [isFunctionalRepresentationOf_iff]
    refine ⟨?_, fun xu => (xu.2.val xu.1, xu.2), fun _ _ => rfl⟩
    change IsIndependent ((indepProd p (inputSupportPrior q)).map id)
    rw [PMF.map_id]
    exact isIndependent_indepProd p (inputSupportPrior q)
  · exact isMarkovChainOf_comp (indepProd p (inputSupportPrior q)) Prod.fst
      (fun xu => (xu.2.val xu.1, xu.2)) Prod.snd

/-! Activity, unlike positivity of a posterior at an unused output, is intrinsic. -/

private theorem auxiliaryChannel_active_iff (q : PMF (alpha → beta))
    (y : beta) (w : alpha → beta) :
    (y, w) ∈ activeOutputs (auxiliaryChannel q) ↔
      0 < q w ∧ ∃ x, w x = y := by
  constructor
  · rintro ⟨x, hx⟩
    obtain ⟨f, hf, he⟩ := (PMF.mem_support_map_iff _ _ _).mp hx
    have hfw : f = w := congrArg Prod.snd he
    exact ⟨pos_iff_ne_zero.mpr (hfw ▸ hf), x, hfw ▸ congrArg Prod.fst he⟩
  · rintro ⟨hw, x, hx⟩
    exact ⟨x, (PMF.mem_support_map_iff _ _ _).mpr ⟨w, ne_of_gt hw, by simp [hx]⟩⟩

section PosteriorLabels

variable (q : PMF (alpha → beta)) (kappa : alpha → PMF beta)
  (V : beta → PMF (alpha → beta))
  (hV : ∀ x, auxiliaryChannel q x = PMF.channelJoint (kappa x) V)

include hV in
private theorem posterior_active_iff (y : beta) (hy : y ∈ activeOutputs kappa)
    (w : alpha → beta) :
    0 < V y w ↔ (y, w) ∈ activeOutputs (auxiliaryChannel q) := by
  constructor
  · intro hw
    obtain ⟨x, hx⟩ := hy
    refine ⟨x, ?_⟩
    rw [hV x, PMF.mem_support_channelJoint_iff]
    exact ⟨hx, ne_of_gt hw⟩
  · rintro ⟨x, hx⟩
    rw [hV x, PMF.mem_support_channelJoint_iff] at hx
    exact pos_iff_ne_zero.mpr hx.2

include hV in
private theorem posterior_support_iff (y : beta) (hy : y ∈ activeOutputs kappa)
    (w : alpha → beta) :
    0 < V y w ↔ 0 < q w ∧ ∃ x, w x = y :=
  (posterior_active_iff q kappa V hV y hy w).trans (auxiliaryChannel_active_iff q y w)

private def posteriorLabelsEquiv (hactive : ∀ y, y ∈ activeOutputs kappa) :
    (Σ y : beta, {w : alpha → beta // 0 < V y w}) ≃
      activeOutputs (auxiliaryChannel q) where
  toFun p := ⟨(p.1, p.2.val),
    (posterior_active_iff q kappa V hV p.1 (hactive p.1) p.2.val).mp p.2.property⟩
  invFun z := ⟨z.val.1, ⟨z.val.2,
    (posterior_active_iff q kappa V hV z.val.1 (hactive z.val.1) z.val.2).mpr z.property⟩⟩
  left_inv p := by cases p; rfl
  right_inv z := by cases z; rfl

private theorem posteriorLabelsEquiv_apply_val (hactive : ∀ y, y ∈ activeOutputs kappa)
    (p : Σ y : beta, {w : alpha → beta // 0 < V y w}) :
    (posteriorLabelsEquiv q kappa V hV hactive p).val = (p.1, p.2.val) := rfl

private theorem posteriorLabelsEquiv_symm_fst (hactive : ∀ y, y ∈ activeOutputs kappa)
    (z : activeOutputs (auxiliaryChannel q)) :
    ((posteriorLabelsEquiv q kappa V hV hactive).symm z).1 = z.val.1 := rfl

private theorem posteriorLabelsEquiv_symm_snd_val (hactive : ∀ y, y ∈ activeOutputs kappa)
    (z : activeOutputs (auxiliaryChannel q)) :
    ((posteriorLabelsEquiv q kappa V hV hactive).symm z).2.val = z.val.2 := rfl

end PosteriorLabels

/-! ## Decoder labels and exact partitions

Only nonempty fibers are labels. The sigma equivalences retain the ordered
ambient pair `(y,w)`, including distinct vectors with equal input patterns.
-/

private theorem decoderLabels_nonempty [Nonempty alpha] (w : alpha → beta) :
    Nonempty {y : beta // ∃ x, w x = y} := by
  obtain ⟨x⟩ := ‹Nonempty alpha›
  exact ⟨⟨w x, x, rfl⟩⟩

private theorem decoderLabels_finite [Finite beta] (w : alpha → beta) :
    Finite {y : beta // ∃ x, w x = y} := inferInstance

private def decoderLabelsEquiv (q : PMF (alpha → beta)) :
    (Σ w : q.support, {y : beta // ∃ x, w.val x = y}) ≃
      activeOutputs (auxiliaryChannel q) where
  toFun p := ⟨(p.2.val, p.1.val), (auxiliaryChannel_active_iff q _ _).mpr
    ⟨pos_iff_ne_zero.mpr p.1.property, p.2.property⟩⟩
  invFun z := ⟨⟨z.val.2, ne_of_gt ((auxiliaryChannel_active_iff q _ _).mp z.property).1⟩,
    ⟨z.val.1, ((auxiliaryChannel_active_iff q _ _).mp z.property).2⟩⟩
  left_inv p := by cases p; rfl
  right_inv z := by cases z; rfl

private theorem decoderLabelsEquiv_apply_val (q : PMF (alpha → beta))
    (p : Σ w : q.support, {y : beta // ∃ x, w.val x = y}) :
    (decoderLabelsEquiv q p).val = (p.2.val, p.1.val) := rfl

private theorem decoderLabelsEquiv_symm_fst_val (q : PMF (alpha → beta))
    (z : activeOutputs (auxiliaryChannel q)) :
    ((decoderLabelsEquiv q).symm z).1.val = z.val.2 := rfl

private theorem decoderLabelsEquiv_symm_snd_val (q : PMF (alpha → beta))
    (z : activeOutputs (auxiliaryChannel q)) :
    ((decoderLabelsEquiv q).symm z).2.val = z.val.1 := rfl

section DecoderPartitions

variable [Fintype alpha]

private def decoderBlocks (w : alpha → beta) (y : {y : beta // ∃ x, w x = y}) :
    Finset alpha := Finset.univ.filter fun x => w x = y.val

private theorem decoderBlocks_nonempty (w : alpha → beta)
    (y : {y : beta // ∃ x, w x = y}) : (decoderBlocks w y).Nonempty := by
  obtain ⟨x, hx⟩ := y.property
  exact ⟨x, by simp [decoderBlocks, hx]⟩

private theorem decoderBlocks_disjoint (w : alpha → beta) :
    Pairwise (fun y z => Disjoint (decoderBlocks w y) (decoderBlocks w z)) := by
  intro y z hyz
  apply Finset.disjoint_left.mpr
  intro x hy hz
  exact hyz (Subtype.ext ((Finset.mem_filter.mp hy).2.symm.trans
    (Finset.mem_filter.mp hz).2))

private theorem decoderBlocks_cover (w : alpha → beta) (x : alpha) :
    x ∈ (Finset.univ : Finset alpha) ↔ ∃ y, x ∈ decoderBlocks w y := by
  constructor
  · intro _
    exact ⟨⟨w x, x, rfl⟩, by simp [decoderBlocks]⟩
  · intro _; exact Finset.mem_univ x

variable [Finite beta]

private def decoderPartition (w : alpha → beta) :
    Finpartition (Finset.univ : Finset alpha) :=
  partitionOfBlocks Finset.univ (decoderBlocks w) (decoderBlocks_nonempty w)
    (decoderBlocks_disjoint w) (decoderBlocks_cover w)

private def decoderPartitionEquiv (w : alpha → beta) :
    {y : beta // ∃ x, w x = y} ≃ (decoderPartition w).parts :=
  partitionOfBlocksEquiv Finset.univ (decoderBlocks w) (decoderBlocks_nonempty w)
    (decoderBlocks_disjoint w) (decoderBlocks_cover w)

private theorem decoderPartitionEquiv_apply_val (w : alpha → beta)
    (y : {y : beta // ∃ x, w x = y}) :
    (decoderPartitionEquiv w y).val = decoderBlocks w y := rfl

private theorem decoderPartitionEquiv_symm_block (w : alpha → beta)
    (b : (decoderPartition w).parts) :
    decoderBlocks w ((decoderPartitionEquiv w).symm b) = b.val := by
  rw [← decoderPartitionEquiv_apply_val, Equiv.apply_symm_apply]

private def partitionLabelsEquiv (q : PMF (alpha → beta)) :
    (Σ w : q.support, (decoderPartition w.val).parts) ≃
      activeOutputs (auxiliaryChannel q) :=
  (Equiv.sigmaCongrRight (fun w : q.support => (decoderPartitionEquiv w.val).symm)).trans
    (decoderLabelsEquiv q)

private theorem partitionLabelsEquiv_apply_val (q : PMF (alpha → beta))
    (p : Σ w : q.support, (decoderPartition w.val).parts) :
    (partitionLabelsEquiv q p).val =
      (((decoderPartitionEquiv p.1.val).symm p.2).val, p.1.val) := rfl

private theorem partitionLabelsEquiv_symm_fst_val (q : PMF (alpha → beta))
    (z : activeOutputs (auxiliaryChannel q)) :
    ((partitionLabelsEquiv q).symm z).1.val = z.val.2 := rfl

private theorem partitionLabelsEquiv_symm_snd_val (q : PMF (alpha → beta))
    (z : activeOutputs (auxiliaryChannel q)) :
    ((partitionLabelsEquiv q).symm z).2.val =
      Finset.univ.filter (fun x => z.val.2 x = z.val.1) := rfl

private theorem partitionLabelsEquiv_symm_output (q : PMF (alpha → beta))
    (z : activeOutputs (auxiliaryChannel q)) :
    ((decoderPartitionEquiv ((partitionLabelsEquiv q).symm z).1.val).symm
      ((partitionLabelsEquiv q).symm z).2).val = z.val.1 := by
  exact congrArg Subtype.val ((decoderPartitionEquiv z.val.2).symm_apply_apply
    ⟨z.val.1, ((auxiliaryChannel_active_iff q _ _).mp z.property).2⟩)

end DecoderPartitions

private theorem auxiliaryChannel_unique_in_block (q : PMF (alpha → beta))
    (w : q.support) (x : alpha) :
    ∃! y : {y : beta // ∃ x, w.val x = y},
      0 < auxiliaryChannel q x (y.val, w.val) := by
  refine ⟨⟨w.val x, x, rfl⟩, ?_, ?_⟩
  · simpa only [auxiliaryChannel_apply, if_true] using pos_iff_ne_zero.mpr w.property
  · intro y hy
    apply Subtype.ext
    rw [auxiliaryChannel_apply] at hy
    split_ifs at hy with h
    · exact h.symm
    · exact False.elim (lt_irrefl _ hy)

/-! ## Independently specified shared endpoint and posterior correspondence -/

private theorem auxiliaryChannel_singular (q : PMF (alpha → beta)) :
    IsSingularChannel (auxiliaryChannel q) := by
  intro x₁ x₂ yw h₁ h₂
  rcases yw with ⟨y, w⟩
  rw [auxiliaryChannel_apply] at h₁ h₂ ⊢
  rw [auxiliaryChannel_apply]
  split_ifs at h₁ h₂ ⊢ <;> simp_all

section Endpoint
variable [Finite alpha] [Nonempty alpha]
variable (q : PMF (alpha → beta)) {m : Nat}
  (eA : activeOutputs (auxiliaryChannel q) ≃ Fin m)

private def commonEndpoint : ActiveFiniteChannel alpha :=
  ActiveFiniteChannel.ofChannelWithEquiv (auxiliaryChannel q) eA

private theorem commonEndpoint_apply (x : alpha) (z : activeOutputs (auxiliaryChannel q)) :
    (commonEndpoint q eA).channel x (eA z) =
      if z.val.2 x = z.val.1 then q z.val.2 else 0 := by
  change (ActiveFiniteChannel.ofChannelWithEquiv (auxiliaryChannel q) eA).channel x
    (eA z) = _
  rw [ActiveFiniteChannel.ofChannelWithEquiv_apply,auxiliaryChannel_apply]

private theorem commonEndpoint_recover (x : alpha) :
    ((commonEndpoint q eA).channel x).map (fun j => (eA.symm j).val) =
      auxiliaryChannel q x :=
  ActiveFiniteChannel.ofChannelWithEquiv_recover (auxiliaryChannel q) eA x

private theorem commonEndpoint_singular [Finite beta] :
    IsSingularChannel (commonEndpoint q eA).channel :=
  (ActiveFiniteChannel.isSingularChannel_ofChannelWithEquiv_iff
    (auxiliaryChannel q) eA).mpr (auxiliaryChannel_singular q)

private theorem commonEndpoint_value [Finite beta]
    (z : activeOutputs (auxiliaryChannel q)) :
    columnValue (commonEndpoint q eA).channel (commonEndpoint_singular q eA)
      ((commonEndpoint q eA).activeEquiv (eA z)) = q z.val.2 := by
  obtain ⟨hw,x,hx⟩ := (auxiliaryChannel_active_iff q z.val.1 z.val.2).mp z.property
  have hm : (commonEndpoint q eA).channel x (eA z) = q z.val.2 := by
    rw [commonEndpoint_apply,if_pos hx]
  exact (columnValue_eq_of_ne_zero (commonEndpoint q eA).channel
    (commonEndpoint_singular q eA) ((commonEndpoint q eA).activeEquiv (eA z))
      (show (commonEndpoint q eA).channel x (eA z) ≠ 0 by rw [hm]; exact ne_of_gt hw)).trans hm

private theorem commonEndpoint_pattern [Fintype alpha]
    (z : activeOutputs (auxiliaryChannel q)) :
    (columnPattern (commonEndpoint q eA).channel
      ((commonEndpoint q eA).activeEquiv (eA z))).val =
      Finset.univ.filter (fun x => z.val.2 x = z.val.1) := by
  have hw := ((auxiliaryChannel_active_iff q z.val.1 z.val.2).mp z.property).1
  ext x
  rw [mem_columnPattern]
  change (commonEndpoint q eA).channel x (eA z) ≠ 0 ↔ _
  rw [commonEndpoint_apply]
  by_cases hx : z.val.2 x = z.val.1 <;> simp [hx,ne_of_gt hw]

private theorem commonEndpoint_decoder_pattern [Fintype alpha]
    (w : q.support) (y : {y : beta // ∃ x, w.val x = y}) :
    (columnPattern (commonEndpoint q eA).channel
      ((commonEndpoint q eA).activeEquiv
        (eA (decoderLabelsEquiv q ⟨w,y⟩)))).val = decoderBlocks w.val y :=
  commonEndpoint_pattern q eA _

private theorem commonEndpoint_unique_in_block
    (w : q.support) (x : alpha) :
    ∃! y : {y : beta // ∃ x, w.val x = y},
      0 < (commonEndpoint q eA).channel x (eA (decoderLabelsEquiv q ⟨w,y⟩)) := by
  have hm (y : {y : beta // ∃ x, w.val x = y}) :
      (commonEndpoint q eA).channel x (eA (decoderLabelsEquiv q ⟨w,y⟩)) =
        auxiliaryChannel q x (y.val,w.val) :=
    ActiveFiniteChannel.ofChannelWithEquiv_apply _ eA x (decoderLabelsEquiv q ⟨w,y⟩)
  obtain ⟨y,hy,hu⟩ := auxiliaryChannel_unique_in_block q w x
  refine ⟨y,?_,?_⟩
  · exact lt_of_lt_of_eq hy (hm y).symm
  · intro z hz
    exact hu z (lt_of_lt_of_eq hz (hm z))

end Endpoint

section PosteriorCorrespondence
variable (q : PMF (alpha → beta)) (kappa : alpha → PMF beta)
  (V : beta → PMF (alpha → beta))
  (hV : ∀ x, auxiliaryChannel q x = PMF.channelJoint (kappa x) V)

include hV in
private theorem posterior_fiber_iff (y : activeOutputs kappa) (w : alpha → beta)
    (hw : 0 < V y.val w) (x : alpha) :
    w x = y.val ↔ kappa x y.val ≠ 0 := by
  have hq : w ∈ q.support := ne_of_gt
    ((posterior_support_iff q kappa V hV y.val y.property w).mp hw).1
  constructor
  · intro he
    have hz : (y.val,w) ∈ (auxiliaryChannel q x).support :=
      (PMF.mem_support_map_iff _ _ _).mpr ⟨w,hq,by simp [he]⟩
    rw [hV x,PMF.mem_support_channelJoint_iff] at hz
    exact hz.1
  · intro hx
    exact coordinate_eq_of_posterior_support q kappa V hV hx (ne_of_gt hw)

include hV in
private theorem posterior_value_identity (y : activeOutputs kappa) (w : alpha → beta)
    (hw : 0 < V y.val w) (hK : IsSingularChannel kappa) :
    q w = V y.val w * columnValue kappa hK y := by
  obtain ⟨x,hx⟩ := y.property
  have he := (posterior_fiber_iff q kappa V hV y w hw x).mpr hx
  have hm := auxiliaryChannel_factor_apply q kappa V hV x y.val w
  rw [auxiliaryChannel_apply,if_pos he] at hm
  rw [hm,columnValue_eq_of_ne_zero kappa hK y hx,mul_comm]

include hV in
private theorem posterior_fiber_pattern [Fintype alpha]
    (y : activeOutputs kappa) (w : alpha → beta) (hw : 0 < V y.val w) :
    Finset.univ.filter (fun x => w x = y.val) = (columnPattern kappa y).val := by
  ext x
  simp only [Finset.mem_filter,Finset.mem_univ,true_and,mem_columnPattern]
  exact posterior_fiber_iff q kappa V hV y w hw x

end PosteriorCorrespondence

-- Equation (28)/(24): the pure projection posterior isolates exactly the
-- supported w block and its unique positive row entry, retaining actual labels.
private theorem auxiliary_weighted_positive_iff (q : PMF (alpha → beta))
    (x : alpha) (w : q.support) (z : activeOutputs (auxiliaryChannel q)) :
    0 < auxiliaryChannel q x z.val * PMF.pure z.val.2 w.val ↔
      z.val = (w.val x,w.val) := by
  rcases z with ⟨⟨y,u⟩,hz⟩
  have hw : 0 < q w.val := pos_iff_ne_zero.mpr w.property
  by_cases hu : u = w.val
  · subst u
    by_cases hy : w.val x = y
    · subst y
      simp [auxiliaryChannel_apply,PMF.pure_apply,hw]
    · simp [auxiliaryChannel_apply,PMF.pure_apply,hy,Ne.symm hy]
  · simp [PMF.pure_apply,hu,Ne.symm hu]

private theorem auxiliary_unique_weighted_positive (q : PMF (alpha → beta))
    (x : alpha) (w : q.support) :
    ∃! z : activeOutputs (auxiliaryChannel q),
      0 < auxiliaryChannel q x z.val * PMF.pure z.val.2 w.val := by
  let z : activeOutputs (auxiliaryChannel q) :=
    ⟨(w.val x,w.val),(auxiliaryChannel_active_iff q _ _).mpr
      ⟨pos_iff_ne_zero.mpr w.property,x,rfl⟩⟩
  refine ⟨z,(auxiliary_weighted_positive_iff q x w z).mpr rfl,?_⟩
  intro z' hz'
  exact Subtype.ext ((auxiliary_weighted_positive_iff q x w z').mp hz')

-- Private interface handoff: one q, V, hV and supplied eA fixes both the
-- independent endpoint and the posterior-labelled coordinates for later paths.
example [Fintype alpha] [Nonempty alpha] (S : ActiveFiniteChannel alpha)
    (q : PMF (alpha → Fin S.outputCard))
    (V : Fin S.outputCard → PMF (alpha → Fin S.outputCard))
    (hV : ∀ x, auxiliaryChannel q x = PMF.channelJoint (S.channel x) V)
    {m : Nat} (eA : activeOutputs (auxiliaryChannel q) ≃ Fin m)
    (x : alpha) (l : Σ y, {w : alpha → Fin S.outputCard // 0 < V y w}) :
    let z := posteriorLabelsEquiv q S.channel V hV S.output_active l
    let d := (partitionLabelsEquiv q).symm z
    (commonEndpoint q eA).channel x (eA z) = V l.1 l.2.val * S.channel x l.1 ∧
      columnValue (commonEndpoint q eA).channel (commonEndpoint_singular q eA)
        ((commonEndpoint q eA).activeEquiv (eA z)) = q l.2.val ∧
      (columnPattern (commonEndpoint q eA).channel
        ((commonEndpoint q eA).activeEquiv (eA z))).val = d.2.val := by
  dsimp only
  refine ⟨?_,commonEndpoint_value q eA _,?_⟩
  · change (ActiveFiniteChannel.ofChannelWithEquiv (auxiliaryChannel q) eA).channel x _ = _
    rw [ActiveFiniteChannel.ofChannelWithEquiv_apply]
    change auxiliaryChannel q x (l.1,l.2.val) = _
    rw [auxiliaryChannel_factor_apply q S.channel V hV,mul_comm]
  · rw [commonEndpoint_pattern,partitionLabelsEquiv_symm_snd_val]

open scoped BigOperators ENNReal

section OriginalPps
variable [Fintype alpha] [Nonempty alpha]
variable (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
  (V : Fin S.outputCard → PMF (alpha → Fin S.outputCard))

private def originalPps :
    LabelledOperationResult .pps S
      (Σ y, {w : alpha → Fin S.outputCard // 0 < V y w})
      (fun x p => V p.1 p.2.val * S.channel x p.1) :=
  multiPpsFamilyOfENNReal S hS (fun y w => V y w)
    (fun y => by simpa using (V y).tsum_coe)

private theorem originalPps_coordinates (x : alpha)
    (l : Σ y, {w : alpha → Fin S.outputCard // 0 < V y w}) :
    (originalPps S hS V).endpoint.channel x ((originalPps S hS V).labels l) =
      V l.1 l.2.val * S.channel x l.1 :=
  (originalPps S hS V).coordinates x l

-- The range in the original ambient labels contains exactly the positive
-- posterior atoms, including when different original columns have different supports.
private theorem originalPps_label_iff (y : Fin S.outputCard)
    (w : alpha → Fin S.outputCard) :
    (y,w) ∈ Set.range (fun j =>
      (((originalPps S hS V).labels.symm j).1,
        ((originalPps S hS V).labels.symm j).2.val)) ↔ 0 < V y w := by
  constructor
  · rintro ⟨j,hj⟩
    exact Eq.mp (congrArg (fun p : Fin S.outputCard × (alpha → Fin S.outputCard) =>
      0 < V p.1 p.2) hj) ((originalPps S hS V).labels.symm j).2.property
  · intro hw
    refine ⟨(originalPps S hS V).labels ⟨y,⟨w,hw⟩⟩,?_⟩
    exact congrArg (fun l : Σ y, {w : alpha → Fin S.outputCard // 0 < V y w} =>
      (l.1,l.2.val)) ((originalPps S hS V).labels.symm_apply_apply ⟨y,⟨w,hw⟩⟩)

private theorem originalPps_pattern
    (l : Σ y, {w : alpha → Fin S.outputCard // 0 < V y w}) :
    (columnPattern (originalPps S hS V).endpoint.channel
      ((originalPps S hS V).endpoint.activeEquiv ((originalPps S hS V).labels l))).val =
      (columnPattern S.channel (S.activeEquiv l.1)).val := by
  ext x
  rw [mem_columnPattern,mem_columnPattern]
  change (originalPps S hS V).endpoint.channel x ((originalPps S hS V).labels l) ≠ 0 ↔
    S.channel x l.1 ≠ 0
  rw [originalPps_coordinates]
  exact mul_ne_zero_iff.trans (and_iff_right (ne_of_gt l.2.property))

private theorem originalPps_weighted_value
    (l : Σ y, {w : alpha → Fin S.outputCard // 0 < V y w}) :
    columnValue (originalPps S hS V).endpoint.channel ((originalPps S hS V).isSingular hS)
      ((originalPps S hS V).endpoint.activeEquiv ((originalPps S hS V).labels l)) =
      V l.1 l.2.val * columnValue S.channel hS (S.activeEquiv l.1) := by
  obtain ⟨x,hx⟩ := S.output_active l.1
  have hd : (originalPps S hS V).endpoint.channel x ((originalPps S hS V).labels l) ≠ 0 := by
    rw [originalPps_coordinates]
    exact mul_ne_zero (ne_of_gt l.2.property) hx
  rw [columnValue_eq_of_ne_zero _ _ _ hd,columnValue_eq_of_ne_zero _ _ _ hx]
  exact originalPps_coordinates S hS V x l

end OriginalPps

section OriginalTarget
variable [Finite alpha] [Nonempty alpha]
variable (S : ActiveFiniteChannel alpha)
  (q : PMF (alpha → Fin S.outputCard))
  (V : Fin S.outputCard → PMF (alpha → Fin S.outputCard))
  (hV : ∀ x, auxiliaryChannel q x = PMF.channelJoint (S.channel x) V)
  {m : Nat} (eA : activeOutputs (auxiliaryChannel q) ≃ Fin m)

include hV in
private theorem originalTarget_coordinates (x : alpha)
    (l : Σ y, {w : alpha → Fin S.outputCard // 0 < V y w}) :
    (commonEndpoint q eA).channel x
      (eA (posteriorLabelsEquiv q S.channel V hV S.output_active l)) =
      V l.1 l.2.val * S.channel x l.1 := by
  change (ActiveFiniteChannel.ofChannelWithEquiv (auxiliaryChannel q) eA).channel x _ = _
  rw [ActiveFiniteChannel.ofChannelWithEquiv_apply]
  change auxiliaryChannel q x (l.1,l.2.val) = _
  rw [auxiliaryChannel_factor_apply q S.channel V hV,mul_comm]

end OriginalTarget

section OriginalBridge
variable [Fintype alpha] [Nonempty alpha]
variable (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
  (q : PMF (alpha → Fin S.outputCard))
  (V : Fin S.outputCard → PMF (alpha → Fin S.outputCard))
  (hV : ∀ x, auxiliaryChannel q x = PMF.channelJoint (S.channel x) V)
  {m : Nat} (eA : activeOutputs (auxiliaryChannel q) ≃ Fin m)

private def originalBridge : Cascade S (commonEndpoint q eA) :=
  (originalPps S hS V).cascade
    ((posteriorLabelsEquiv q S.channel V hV S.output_active).trans eA)
    (originalTarget_coordinates S q V hV eA)

private theorem originalBridge_path :
    (originalBridge S hS q V hV eA).path = (originalPps S hS V).path := rfl

private theorem originalBridge_homogeneous :
    (originalBridge S hS q V hV eA).path.Homogeneous .pps :=
  (originalPps S hS V).homogeneous

private theorem originalBridge_label
    (l : Σ y, {w : alpha → Fin S.outputCard // 0 < V y w}) :
    (originalBridge S hS q V hV eA).outputEquiv.equiv ((originalPps S hS V).labels l) =
      eA (posteriorLabelsEquiv q S.channel V hV S.output_active l) := by
  change eA (posteriorLabelsEquiv q S.channel V hV S.output_active
    ((originalPps S hS V).labels.symm ((originalPps S hS V).labels l))) = _
  rw [Equiv.symm_apply_apply]

private theorem originalBridge_label_symm (z : activeOutputs (auxiliaryChannel q)) :
    (originalBridge S hS q V hV eA).outputEquiv.equiv.symm (eA z) =
      (originalPps S hS V).labels
        ((posteriorLabelsEquiv q S.channel V hV S.output_active).symm z) := by
  change (originalPps S hS V).labels
    ((posteriorLabelsEquiv q S.channel V hV S.output_active).symm (eA.symm (eA z))) = _
  rw [Equiv.symm_apply_apply]

private theorem originalBridge_map (x : alpha) :
    ((originalPps S hS V).endpoint.channel x).map
      (originalBridge S hS q V hV eA).outputEquiv.equiv =
        (commonEndpoint q eA).channel x :=
  (originalBridge S hS q V hV eA).outputEquiv.map_eq x

private theorem originalBridge_map_symm (x : alpha) :
    ((commonEndpoint q eA).channel x).map
      (originalBridge S hS q V hV eA).outputEquiv.equiv.symm =
        (originalPps S hS V).endpoint.channel x :=
  (originalBridge S hS q V hV eA).outputEquiv.symm.map_eq x

private theorem originalBridge_recover (x : alpha) :
    ((originalPps S hS V).endpoint.channel x).map
      (fun j => (eA.symm ((originalBridge S hS q V hV eA).outputEquiv.equiv j)).val) =
        auxiliaryChannel q x := by
  let f : Fin (originalPps S hS V).endpoint.outputCard → Fin m :=
    (originalBridge S hS q V hV eA).outputEquiv.equiv
  let g : Fin m → Fin S.outputCard × (alpha → Fin S.outputCard) :=
    fun j => (eA.symm j).val
  exact (PMF.map_comp (f := f) (p := (originalPps S hS V).endpoint.channel x) g).symm.trans
    ((congrArg (fun p : PMF (Fin m) => p.map g)
      (originalBridge_map S hS q V hV eA x)).trans (commonEndpoint_recover q eA x))

include hV in
private theorem originalPps_value
    (l : Σ y, {w : alpha → Fin S.outputCard // 0 < V y w}) :
    columnValue (originalPps S hS V).endpoint.channel ((originalPps S hS V).isSingular hS)
      ((originalPps S hS V).endpoint.activeEquiv ((originalPps S hS V).labels l)) =
      q l.2.val :=
  (originalPps_weighted_value S hS V l).trans
    (posterior_value_identity q S.channel V hV (S.activeEquiv l.1) l.2.val l.2.property hS).symm

include hV in
private theorem originalPps_fiber_pattern
    (l : Σ y, {w : alpha → Fin S.outputCard // 0 < V y w}) :
    (columnPattern (originalPps S hS V).endpoint.channel
      ((originalPps S hS V).endpoint.activeEquiv ((originalPps S hS V).labels l))).val =
        Finset.univ.filter (fun x => l.2.val x = l.1) := by
  apply (originalPps_pattern S hS V l).trans
  ext x
  constructor
  · intro hx
    exact Finset.mem_filter.mpr ⟨Finset.mem_univ x,
      (posterior_fiber_iff q S.channel V hV (S.activeEquiv l.1) l.2.val l.2.property x).mpr
        ((mem_columnPattern S.channel (S.activeEquiv l.1) x).mp hx)⟩
  · intro hx
    exact (mem_columnPattern S.channel (S.activeEquiv l.1) x).mpr
      ((posterior_fiber_iff q S.channel V hV (S.activeEquiv l.1) l.2.val l.2.property x).mp
        (Finset.mem_filter.mp hx).2)

end OriginalBridge

section OriginalStageSpecifications
variable [Fintype alpha] [Nonempty alpha]
attribute [local instance] operationQuiver

-- Every actual intermediate vertex is the endpoint of a concrete prefix.
private theorem originalPps_stages_singular (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel)
    (V : Fin S.outputCard → PMF (alpha → Fin S.outputCard))
    (A : ActiveFiniteChannel alpha) (before : OperationPath S A)
    (after : OperationPath A (originalPps S hS V).endpoint)
    (_hpath : before.append after = (originalPps S hS V).path) :
    IsSingularChannel A.channel := before.isSingular hS

-- C10's selected-operation growth proof is private. This one-off path count
-- uses the same primitive PPS output-cardinality equation for the family witness.
omit [Fintype alpha] in
private theorem originalPps_card_growth [Finite alpha] {S T : ActiveFiniteChannel alpha}
    (p : OperationPath S T) (hp : p.Homogeneous .pps) :
    T.outputCard = S.outputCard + p.length := by
  induction p with
  | nil => rfl
  | cons p e ih =>
      have h := (OperationPath.allowed_snoc _ p e).mp hp
      cases e with
      | pps hT l t ht0 ht1 =>
          change _ + 1 = S.outputCard + (p.length + 1)
          rw [ih h.1,Nat.add_assoc]
          rfl
      | vps hT l mask hl hr => simp [OperationStep.kind] at h
      | ppm hT a b hab hs => simp [OperationStep.kind] at h
      | vpm hT a b hab hv hd => simp [OperationStep.kind] at h

private theorem originalPps_length_singleton (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel)
    (V : Fin S.outputCard → PMF (alpha → Fin S.outputCard))
    (hsingleton : ∀ y, Subsingleton {w : alpha → Fin S.outputCard // 0 < V y w}) :
    (originalPps S hS V).path.length = 0 := by
  let (y : Fin S.outputCard) : Subsingleton {w : alpha → Fin S.outputCard // 0 < V y w} :=
    hsingleton y
  have hn (y : Fin S.outputCard) : Nonempty {w : alpha → Fin S.outputCard // 0 < V y w} := by
    obtain ⟨w,hw⟩ := (V y).support_nonempty
    exact ⟨w,pos_iff_ne_zero.mpr hw⟩
  let (y : Fin S.outputCard) : Unique {w : alpha → Fin S.outputCard // 0 < V y w} :=
    uniqueOfSubsingleton (Classical.choice (hn y))
  have hc : (originalPps S hS V).endpoint.outputCard = S.outputCard := by
    rw [(originalPps S hS V).outputCard]
    simpa only [Fintype.card_fin] using Fintype.card_congr
      (Equiv.sigmaUnique (Fin S.outputCard) (fun y => {w : alpha → Fin S.outputCard // 0 < V y w}))
  have hg := originalPps_card_growth (originalPps S hS V).path
    (originalPps S hS V).homogeneous
  omega

private theorem originalPps_tags_singleton (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel)
    (V : Fin S.outputCard → PMF (alpha → Fin S.outputCard))
    (hsingleton : ∀ y, Subsingleton {w : alpha → Fin S.outputCard // 0 < V y w}) :
    (originalPps S hS V).path.tags = [] := by
  apply List.eq_nil_of_length_eq_zero
  rw [OperationPath.tags_length,originalPps_length_singleton S hS V hsingleton]

end OriginalStageSpecifications

-- Intrinsic perfectness supplies one q and V; the outer consumer only needs Finite input.
example [Finite alpha] [Nonempty alpha] (S : ActiveFiniteChannel alpha)
    (hP : IsPerfectlyRepresentableChannel S.channel) :
    ∃ (q : PMF (alpha → Fin S.outputCard))
      (V : Fin S.outputCard → PMF (alpha → Fin S.outputCard)),
      (∀ x, auxiliaryChannel q x = PMF.channelJoint (S.channel x) V) ∧
      ∀ {m : Nat} (eA : activeOutputs (auxiliaryChannel q) ≃ Fin m),
        Nonempty {a : Cascade S (commonEndpoint q eA) // a.path.Homogeneous .pps} := by
  let := Fintype.ofFinite alpha
  have hS := hP.isSingular
  obtain ⟨q,V,hV⟩ := hP
  refine ⟨q,V,hV,?_⟩
  intro m eA
  exact ⟨⟨originalBridge S hS q V hV eA,
    originalBridge_homogeneous S hS q V hV eA⟩⟩

/-! The actual active-channel boundary supplies activity without a prior. -/

example [Finite alpha] [Nonempty alpha] (S : ActiveFiniteChannel alpha)
    (q : PMF (alpha → Fin S.outputCard)) (V : Fin S.outputCard → PMF (alpha → Fin S.outputCard))
    (hV : ∀ x, q.map (fun w => (w x, w)) = PMF.channelJoint (S.channel x) V) :
    (Σ y : Fin S.outputCard, {w : alpha → Fin S.outputCard // 0 < V y w}) ≃
      activeOutputs (auxiliaryChannel q) :=
  posteriorLabelsEquiv q S.channel V hV S.output_active

example [Finite alpha] [Finite beta] [Nonempty alpha] (q : PMF (alpha → beta)) :
    Finite (activeOutputs (auxiliaryChannel q)) ∧
      (activeOutputs (auxiliaryChannel q)).Nonempty :=
  ⟨inferInstance, activeOutputs_nonempty _⟩

/-! ## R01-R03: a pure identity coupling with null vector atoms -/

namespace Regression

open scoped BigOperators

private abbrev W := Fin 2 → Fin 2
private def identityVector : W := id
private def swapVector : W := fun x => if x = 0 then 1 else 0
private def q : PMF W := PMF.pure identityVector
private def kappa (x : Fin 2) : PMF (Fin 2) := PMF.pure x
private def V (_ : Fin 2) : PMF W := q

private theorem swap_ne_identity : swapVector ≠ identityVector := by
  intro h
  have hz : (1 : Fin 2) = 0 := congrFun h 0
  exact (by decide : (1 : Fin 2) ≠ 0) hz

private theorem factorization (x : Fin 2) :
    auxiliaryChannel q x = PMF.channelJoint (kappa x) V := by
  simp [auxiliaryChannel, q, kappa, V, identityVector, PMF.channelJoint, PMF.pure_map]

private theorem output_active (y : Fin 2) : y ∈ activeOutputs kappa := by
  exact ⟨y, by simp [kappa]⟩

private def posteriorLabel (y : Fin 2) : Σ z : Fin 2, {w : W // 0 < V z w} :=
  ⟨y, ⟨identityVector, by simp [V, q]⟩⟩

private def pairLabels := posteriorLabelsEquiv q kappa V factorization output_active

-- R01: restriction removes a null vector and preserves total mass and inclusion.
example : q swapVector = 0 := by simp [q, swap_ne_identity]
example : swapVector ∉ q.support := by simp [q, swap_ne_identity]
example : identityVector ∈ q.support := by simp [q]
example : Nonempty q.support := q.support_nonempty.to_subtype
example : (inputSupportPrior q).map Subtype.val = q := map_val_inputSupportPrior q
example (w : q.support) : inputSupportPrior q w = q w.val := supportPrior_apply q w
example (w : q.support) : 0 < inputSupportPrior q w :=
  pos_iff_ne_zero.mpr (mem_support_inputSupportPrior q w)
example : ∑ w : q.support, inputSupportPrior q w = 1 := by
  simpa using (inputSupportPrior q).tsum_coe
example : (inputSupportPrior q).map Subtype.val swapVector = 0 := by
  rw [map_val_inputSupportPrior]
  simp [q, swap_ne_identity]

-- R02: actual posterior/pair zeros and the ordered labels in both directions.
example (y : Fin 2) : V y swapVector = 0 := by simp [V, q, swap_ne_identity]
example (x y : Fin 2) : auxiliaryChannel q x (y, swapVector) = 0 := by
  rw [auxiliaryChannel_apply]
  simp [q, swap_ne_identity]
example : auxiliaryChannel q 0 (1, identityVector) = 0 := by
  rw [auxiliaryChannel_apply]
  simp [identityVector]
example : auxiliaryChannel q 1 (1, identityVector) = 1 := by
  rw [auxiliaryChannel_apply]
  simp [identityVector, q]
example (y : Fin 2) (w : W) :
    0 < V y w ↔ (y, w) ∈ activeOutputs (auxiliaryChannel q) :=
  posterior_active_iff q kappa V factorization y (output_active y) w
example (y : Fin 2) : (pairLabels (posteriorLabel y)).val = (y, identityVector) := rfl
example (y : Fin 2) : (pairLabels.symm (pairLabels (posteriorLabel y))).1 = y := by
  rw [Equiv.symm_apply_apply]
  rfl
example (y : Fin 2) : (pairLabels.symm (pairLabels (posteriorLabel y))).2.val =
    identityVector := by
  rw [Equiv.symm_apply_apply]
  rfl
example : pairLabels (posteriorLabel 0) ≠ pairLabels (posteriorLabel 1) := by
  intro h
  have hz : (0 : Fin 2) = 1 := congrArg (fun z => z.val.1) h
  exact (by decide : (0 : Fin 2) ≠ 1) hz

-- R03: row 1 remains part of the channel even though a pure prior never samples it.
private def p : PMF (Fin 2) := PMF.pure 0
example : p 1 = 0 := by simp [p]
example : kappa 1 1 = 1 := by simp [kappa]
example : IsPerfectFunctionalRepresentationOf (indepProd p q) Prod.fst
    (fun xw => (xw.2 xw.1, xw.2)) Prod.snd := fixedW_perfect p q
example :
    (indepProd p q).map (fun xw => (xw.1, (xw.2 xw.1, xw.2), xw.2)) =
      PMF.channelExtension
        ((indepProd p q).map (fun xw => (xw.1, (xw.2 xw.1, xw.2))))
        (fun yw => PMF.pure yw.2) := fixedW_factorization p q
example : IsPerfectFunctionalRepresentationOf (indepProd p (inputSupportPrior q)) Prod.fst
    (fun xu => (xu.2.val xu.1, xu.2)) Prod.snd := supported_fixedW_perfect p q
example : (PMF.channelJoint p (auxiliaryChannel q)) (1, (1, identityVector)) = 0 := by
  rw [PMF.channelJoint_apply]
  simp [p]

end Regression

/-! ## R04-R06: omitted pairs, unequal fibers and a constant singleton endpoint -/

namespace RegressionS02
open scoped BigOperators ENNReal
private abbrev W := Fin 3 → Fin 3
private def f : W := ![0,0,1]
private def g : W := ![0,0,2]
private def weights : Fin 2 → NNReal := ![1 / 3, 2 / 3]
private theorem weights_sum : ∑ j, weights j = 1 := by
  norm_num [weights, Fin.sum_univ_succ]
private def indexLaw : PMF (Fin 2) :=
  PMF.ofFintype (fun j => (weights j : ENNReal)) (by exact_mod_cast weights_sum)
private def q : PMF W := indexLaw.map (![f,g] : Fin 2 → W)

private theorem f_ne_g : f ≠ g := by
  intro h
  have hz := congrFun h 2
  norm_num [f,g,Fin.ext_iff,Matrix.cons_val_two] at hz

private theorem q_apply (w : W) :
    q w = (if w = f then (1 / 3 : ENNReal) else 0) +
      (if w = g then (2 / 3 : ENNReal) else 0) := by
  unfold q
  rw [PMF.map_apply]
  simp [indexLaw, tsum_fintype, Fin.sum_univ_succ, weights, eq_comm]

private theorem q_f : q f = 1 / 3 := by simp [q_apply, f_ne_g]
private theorem q_g : q g = 2 / 3 := by simp [q_apply, Ne.symm f_ne_g]
private theorem f_positive : 0 < q f := by rw [q_f]; norm_num
private theorem g_positive : 0 < q g := by rw [q_g]; norm_num

private def row (x : Fin 3) : Fin 3 → NNReal :=
  if x = 2 then ![0,1 / 3,2 / 3] else ![1,0,0]
private theorem row_sum (x : Fin 3) : ∑ y, row x y = 1 := by
  fin_cases x <;> norm_num [row, Fin.sum_univ_succ,Fin.ext_iff,-Fin.val_eq_zero_iff,
    Matrix.cons_val_two]
private def kappa (x : Fin 3) : PMF (Fin 3) :=
  PMF.ofFintype (fun y => (row x y : ENNReal)) (by exact_mod_cast row_sum x)
private def V (y : Fin 3) : PMF W :=
  if y = 0 then q else if y = 1 then PMF.pure f else PMF.pure g

private theorem V_f (y : Fin 3) :
    V y f = if y = 0 then 1 / 3 else if y = 1 then 1 else 0 := by
  by_cases h0 : y = 0
  · simp [V,h0,q_f]
  · by_cases h1 : y = 1
    · simp [V,h1]
    · simp [V,h0,h1,f_ne_g]

private theorem V_g (y : Fin 3) :
    V y g = if y = 0 then 2 / 3 else if y = 1 then 0 else 1 := by
  by_cases h0 : y = 0
  · simp [V,h0,q_g]
  · by_cases h1 : y = 1
    · simp [V,h1,Ne.symm f_ne_g]
    · simp [V,h0,h1]

private theorem factorization (x : Fin 3) :
    auxiliaryChannel q x = PMF.channelJoint (kappa x) V := by
  apply PMF.ext
  rintro ⟨y,w⟩
  rw [auxiliaryChannel_apply, PMF.channelJoint_apply]
  by_cases hf : w = f
  · subst w
    rw [q_f,V_f]
    fin_cases x <;> fin_cases y <;>
      norm_num [kappa,row,f,Fin.ext_iff,-Fin.val_eq_zero_iff,Matrix.cons_val_two]
  · by_cases hg : w = g
    · subst w
      rw [q_g,V_g]
      fin_cases x <;> fin_cases y <;>
        norm_num [kappa,row,g,Fin.ext_iff,-Fin.val_eq_zero_iff,Matrix.cons_val_two]
    · have hq : q w = 0 := by simp [q_apply,hf,hg]
      fin_cases x <;> fin_cases y <;>
        simp [hq,kappa,row,V,hf,hg,Fin.ext_iff,-Fin.val_eq_zero_iff,Matrix.cons_val_two]

private theorem output_active (y : Fin 3) : y ∈ activeOutputs kappa := by
  fin_cases y
  · exact ⟨0,by norm_num [kappa,row,Fin.ext_iff,-Fin.val_eq_zero_iff]⟩
  · exact ⟨2,by norm_num [kappa,row,Fin.ext_iff,-Fin.val_eq_zero_iff]⟩
  · exact ⟨2,by norm_num [kappa,row,Fin.ext_iff,-Fin.val_eq_zero_iff,Matrix.cons_val_two]⟩

-- R04: f is supported, but its output-2 fiber is empty although output 2 is active.
example : f ∈ q.support := ne_of_gt f_positive
example : (2 : Fin 3) ∈ activeOutputs kappa := output_active 2
private theorem f_omits_two : ¬ ∃ x, f x = (2 : Fin 3) := by
  rintro ⟨x,hx⟩
  fin_cases x <;> norm_num [f,Fin.ext_iff,-Fin.val_eq_zero_iff,Matrix.cons_val_two] at hx
example (x : Fin 3) : auxiliaryChannel q x (2,f) = 0 := by
  rw [auxiliaryChannel_apply]
  fin_cases x <;> norm_num [f,Fin.ext_iff,-Fin.val_eq_zero_iff,Matrix.cons_val_two]
private theorem omittedPair_inactive : (2,f) ∉ activeOutputs (auxiliaryChannel q) := by
  rintro ⟨x,hx⟩
  change auxiliaryChannel q x (2,f) ≠ 0 at hx
  rw [auxiliaryChannel_apply] at hx
  fin_cases x <;> norm_num [f,Fin.ext_iff,-Fin.val_eq_zero_iff,Matrix.cons_val_two] at hx

-- The empty ambient fiber contributes no decoder label or active column.
example : Finset.univ.filter (fun x : Fin 3 => f x = 2) = ∅ := by decide +kernel

-- R06: positive singleton vector law and its exact raw auxiliary column.
private def constantVector : Fin 3 → Fin 1 := fun _ => 0
private def constantLaw : PMF (Fin 3 → Fin 1) := PMF.pure constantVector
example : constantLaw constantVector = 1 := by simp [constantLaw]
example (x : Fin 3) : auxiliaryChannel constantLaw x (0,constantVector) = 1 := by
  rw [auxiliaryChannel_apply]
  simp [constantVector,constantLaw]
example : (0,constantVector) ∈ activeOutputs (auxiliaryChannel constantLaw) :=
  ⟨0,by change auxiliaryChannel constantLaw 0 (0,constantVector) ≠ 0
        rw [auxiliaryChannel_apply]; simp [constantVector,constantLaw]⟩
example : (Finset.univ.filter (fun x : Fin 3 => constantVector x = 0)).card = 3 := by
  simp [constantVector]

/-! R05: unequal decoder fibers and their original labels in the actual partition. -/

private def f0 : {y : Fin 3 // ∃ x, f x = y} := ⟨0,0,rfl⟩
private def f1 : {y : Fin 3 // ∃ x, f x = y} := ⟨1,2,rfl⟩
private def wf : q.support := ⟨f,ne_of_gt f_positive⟩

private theorem f0_block : decoderBlocks f f0 = {0,1} := by
  ext x
  fin_cases x <;> simp [decoderBlocks,f0,f,Fin.ext_iff,-Fin.val_eq_zero_iff,
    Matrix.cons_val_two]
private theorem f1_block : decoderBlocks f f1 = {2} := by
  ext x
  fin_cases x <;> simp [decoderBlocks,f1,f,Fin.ext_iff,-Fin.val_eq_zero_iff,
    Matrix.cons_val_two]

example : (decoderBlocks f f0).card = 2 := by rw [f0_block]; decide
example : (decoderBlocks f f1).card = 1 := by rw [f1_block]; decide
example : Disjoint (decoderBlocks f f0) (decoderBlocks f f1) :=
  decoderBlocks_disjoint f (by
    intro h
    have hh := congrArg Subtype.val h
    exact Nat.zero_ne_one (congrArg Fin.val hh))
example : decoderBlocks f f0 ∪ decoderBlocks f f1 = Finset.univ := by
  rw [f0_block,f1_block]
  decide
example : (decoderPartitionEquiv f f0).val = {0,1} := by
  rw [decoderPartitionEquiv_apply_val,f0_block]
example : (decoderPartitionEquiv f f1).val = {2} := by
  rw [decoderPartitionEquiv_apply_val,f1_block]
example : ((decoderPartitionEquiv f).symm ((decoderPartitionEquiv f) f1)).val = 1 := by
  rw [Equiv.symm_apply_apply]
  rfl
example : (decoderLabelsEquiv q ⟨wf,f1⟩).val = (1,f) := rfl
example : (partitionLabelsEquiv q ⟨wf,decoderPartitionEquiv f f1⟩).val = (1,f) := by
  rw [partitionLabelsEquiv_apply_val]
  change (((decoderPartitionEquiv f).symm ((decoderPartitionEquiv f) f1)).val,f) = (1,f)
  simp only [Equiv.symm_apply_apply]
  rfl
example : ((partitionLabelsEquiv q).symm (decoderLabelsEquiv q ⟨wf,f1⟩)).1.val = f := rfl
example : ((partitionLabelsEquiv q).symm (decoderLabelsEquiv q ⟨wf,f1⟩)).2.val = {2} := by
  rw [partitionLabelsEquiv_symm_snd_val]
  exact f1_block
example : ¬ ∃ y : {y : Fin 3 // ∃ x, f x = y}, y.val = 2 := by
  rintro ⟨⟨y,x,hx⟩,hy⟩
  exact f_omits_two ⟨x,hx.trans hy⟩
example (x : Fin 3) : ∃! y : {y : Fin 3 // ∃ x, f x = y},
    0 < auxiliaryChannel q x (y.val,f) := auxiliaryChannel_unique_in_block q wf x

private def mixedActive0 : activeOutputs (auxiliaryChannel q) :=
  decoderLabelsEquiv q ⟨wf,f0⟩
private def mixedEnumeration := Finite.equivFin (activeOutputs (auxiliaryChannel q))
private abbrev mixedEndpoint := commonEndpoint q mixedEnumeration
private theorem mixedEndpoint_mass (x : Fin 3) :
    mixedEndpoint.channel x (mixedEnumeration mixedActive0) =
      if f x = 0 then 1 / 3 else 0 := by
  have hw : mixedActive0.val.2 = f := rfl
  have hy : mixedActive0.val.1 = 0 := rfl
  rw [commonEndpoint_apply, hw, hy, q_f]
  split_ifs <;> rfl
private theorem mixedEndpoint_singular : IsSingularChannel mixedEndpoint.channel :=
  commonEndpoint_singular q mixedEnumeration
example : columnValue mixedEndpoint.channel mixedEndpoint_singular
    (mixedEndpoint.activeEquiv (mixedEnumeration mixedActive0)) = 1 / 3 :=
  (commonEndpoint_value q mixedEnumeration mixedActive0).trans q_f
example : (columnPattern mixedEndpoint.channel
    (mixedEndpoint.activeEquiv (mixedEnumeration mixedActive0))).val = {0,1} :=
  (commonEndpoint_decoder_pattern q mixedEnumeration wf f0).trans f0_block
example (x : Fin 3) : ∃! y : {y : Fin 3 // ∃ x, f x = y},
    0 < mixedEndpoint.channel x (mixedEnumeration (decoderLabelsEquiv q ⟨wf,y⟩)) :=
  commonEndpoint_unique_in_block q mixedEnumeration wf x
example (j : Fin mixedEndpoint.outputCard) : (mixedEnumeration.symm j).val ≠ (2,f) := by
  intro he
  exact omittedPair_inactive (he ▸ (mixedEnumeration.symm j).property)
example (x : Fin 3) :
    (mixedEndpoint.channel x).map (fun j => (mixedEnumeration.symm j).val) (2,f) = 0 := by
  rw [commonEndpoint_recover,auxiliaryChannel_apply]
  exact if_neg (fun h => f_omits_two ⟨x,h⟩)

/-! R06: an explicit singleton active endpoint, value one and universal pattern. -/

private def constantActive : activeOutputs (auxiliaryChannel constantLaw) :=
  ⟨(0,constantVector),0,by
    change auxiliaryChannel constantLaw 0 (0,constantVector) ≠ 0
    rw [auxiliaryChannel_apply]
    simp [constantVector,constantLaw]⟩
private theorem constantActive_unique (z : activeOutputs (auxiliaryChannel constantLaw)) :
    z = constantActive := by
  apply Subtype.ext
  obtain ⟨x,hx⟩ := z.property
  change z.val = (0,constantVector)
  simpa [auxiliaryChannel,constantLaw,PMF.pure_map,constantVector] using hx
private def constantEnumeration : activeOutputs (auxiliaryChannel constantLaw) ≃ Fin 1 where
  toFun _ := 0
  invFun _ := constantActive
  left_inv z := (constantActive_unique z).symm
  right_inv _ := Subsingleton.elim _ _
private abbrev constantEndpoint := commonEndpoint constantLaw constantEnumeration
private def constantIndex : Fin constantEndpoint.outputCard := constantEnumeration constantActive
private theorem constantEndpoint_mass (x : Fin 3) :
    constantEndpoint.channel x constantIndex = 1 := by
  change (commonEndpoint constantLaw constantEnumeration).channel x
    (constantEnumeration constantActive) = 1
  rw [commonEndpoint_apply]
  simp [constantActive,constantVector,constantLaw]
private theorem constantEndpoint_singular : IsSingularChannel constantEndpoint.channel :=
  commonEndpoint_singular constantLaw constantEnumeration

example : constantEndpoint.outputCard = 1 := rfl
example : columnValue constantEndpoint.channel constantEndpoint_singular
    (constantEndpoint.activeEquiv constantIndex) = 1 := by
  exact (commonEndpoint_value constantLaw constantEnumeration constantActive).trans
    (PMF.pure_apply_self constantVector)
example : (columnPattern constantEndpoint.channel
    (constantEndpoint.activeEquiv constantIndex)).val = Finset.univ := by
  change (columnPattern (commonEndpoint constantLaw constantEnumeration).channel
    ((commonEndpoint constantLaw constantEnumeration).activeEquiv
      (constantEnumeration constantActive))).val = _
  rw [commonEndpoint_pattern]
  simp [constantActive,constantVector]
private def c0 : {y : Fin 1 // ∃ x, constantVector x = y} := ⟨0,0,rfl⟩
example : decoderBlocks constantVector c0 = Finset.univ := by
  simp [decoderBlocks,constantVector,c0]
example : (decoderPartitionEquiv constantVector c0).val = Finset.univ := by
  rw [decoderPartitionEquiv_apply_val]
  simp [decoderBlocks,constantVector,c0]

end RegressionS02

namespace RegressionS02

/-! R07-R08 reuse the exact S02 mixed channel and posterior. -/

private abbrev s03Source : ActiveFiniteChannel (Fin 3) :=
  ⟨3, by decide, kappa, output_active⟩

private theorem s03Source_singular : IsSingularChannel s03Source.channel := by
  intro x z y hx hz
  fin_cases x <;> fin_cases z <;> fin_cases y <;>
    norm_num [kappa,row,Fin.ext_iff,-Fin.val_eq_zero_iff,Matrix.cons_val_two] at *

private theorem s03Positive0 (w : W) : 0 < V 0 w ↔ w = f ∨ w = g := by
  have hv : V 0 w = q w := by simp [V]
  rw [hv]
  by_cases hf : w = f
  · subst w
    simp [q_f]
  · by_cases hg : w = g
    · subst w
      simp [q_g]
    · simp [q_apply,hf,hg]

private theorem s03Positive1 (w : W) : 0 < V 1 w ↔ w = f := by
  by_cases h : w = f <;> simp [V,PMF.pure_apply,h]

private theorem s03Positive2 (w : W) : 0 < V 2 w ↔ w = g := by
  by_cases h : w = g <;> simp [V,PMF.pure_apply,h,Fin.ext_iff,-Fin.val_eq_zero_iff]

private def s03Support0 : {w : W // 0 < V 0 w} ≃ Fin 2 where
  toFun w := if w.val = f then 0 else 1
  invFun i := if i = 0 then ⟨f,(s03Positive0 f).mpr (Or.inl rfl)⟩
    else ⟨g,(s03Positive0 g).mpr (Or.inr rfl)⟩
  left_inv w := by
    apply Subtype.ext
    obtain hf | hg := (s03Positive0 w.val).mp w.property
    · simp [hf]
    · simp [hg,Ne.symm f_ne_g]
  right_inv i := by fin_cases i <;> simp [Ne.symm f_ne_g]

private def s03Support1 : {w : W // 0 < V 1 w} ≃ Unit where
  toFun _ := ()
  invFun _ := ⟨f,(s03Positive1 f).mpr rfl⟩
  left_inv w := Subtype.ext ((s03Positive1 w.val).mp w.property).symm
  right_inv _ := rfl

private def s03Support2 : {w : W // 0 < V 2 w} ≃ Unit where
  toFun _ := ()
  invFun _ := ⟨g,(s03Positive2 g).mpr rfl⟩
  left_inv w := Subtype.ext ((s03Positive2 w.val).mp w.property).symm
  right_inv _ := rfl

example : Fintype.card {w : W // 0 < V 0 w} = 2 := by
  simpa using Fintype.card_congr s03Support0
example : Fintype.card {w : W // 0 < V 1 w} = 1 := by
  simpa using Fintype.card_congr s03Support1
example : Fintype.card {w : W // 0 < V 2 w} = 1 := by
  simpa using Fintype.card_congr s03Support2
example : ¬ 0 < V 1 g := by simp [s03Positive1,Ne.symm f_ne_g]
example : ¬ 0 < V 2 f := by simp [s03Positive2,f_ne_g]

private abbrev s03Labels := Σ y : Fin 3, {w : W // 0 < V y w}
private def s03L0f : s03Labels := ⟨0,f,(s03Positive0 f).mpr (Or.inl rfl)⟩
private def s03L0g : s03Labels := ⟨0,g,(s03Positive0 g).mpr (Or.inr rfl)⟩
private def s03L1f : s03Labels := ⟨1,f,(s03Positive1 f).mpr rfl⟩
private def s03L2g : s03Labels := ⟨2,g,(s03Positive2 g).mpr rfl⟩
private def s03LabelVector : Fin 4 → s03Labels := ![s03L0f,s03L0g,s03L1f,s03L2g]
private def s03LabelCode (p : s03Labels) : Fin 4 :=
  if p.1 = 0 then if p.2.val = f then 0 else 1 else if p.1 = 1 then 2 else 3

private def s03LabelEnumeration : s03Labels ≃ Fin 4 where
  toFun := s03LabelCode
  invFun := s03LabelVector
  left_inv p := by
    rcases p with ⟨y,w,hw⟩
    fin_cases y
    · obtain hf | hg := (s03Positive0 w).mp hw
      · subst w
        simp [s03LabelCode,s03LabelVector,s03L0f]
      · subst w
        simp [s03LabelCode,s03LabelVector,s03L0g,Ne.symm f_ne_g]
    · have hf := (s03Positive1 w).mp hw
      subst w
      simp [s03LabelCode,s03LabelVector,s03L1f,-Fin.val_eq_zero_iff,
        Matrix.cons_val_two]
    · have hg := (s03Positive2 w).mp hw
      subst w
      simp [s03LabelCode,s03LabelVector,s03L2g,Fin.ext_iff,-Fin.val_eq_zero_iff,
        Matrix.cons_val_three]
  right_inv i := by
    fin_cases i <;>
      simp [s03LabelCode,s03LabelVector,s03L0f,s03L0g,s03L1f,s03L2g,Ne.symm f_ne_g,
        Fin.ext_iff,-Fin.val_eq_zero_iff,Matrix.cons_val_two,Matrix.cons_val_three]

private def s03Cycle : Fin 4 ≃ Fin 4 where
  toFun := ![1,2,0,3]
  invFun := ![2,0,1,3]
  left_inv i := by fin_cases i <;> rfl
  right_inv i := by fin_cases i <;> rfl

private def s03PosteriorEquiv :=
  posteriorLabelsEquiv q kappa V factorization output_active
private def s03Enumeration : activeOutputs (auxiliaryChannel q) ≃ Fin 4 :=
  s03PosteriorEquiv.symm.trans (s03LabelEnumeration.trans s03Cycle)
private abbrev s03Target := commonEndpoint q s03Enumeration

private theorem s03Enumeration_label (i : Fin 4) :
    s03Enumeration (s03PosteriorEquiv (s03LabelVector i)) = s03Cycle i := by
  change s03Cycle (s03LabelEnumeration
    (s03PosteriorEquiv.symm (s03PosteriorEquiv (s03LabelEnumeration.symm i)))) = _
  rw [Equiv.symm_apply_apply,Equiv.apply_symm_apply]

example : s03Cycle 0 = 1 ∧ s03Cycle.symm 0 = 2 := ⟨rfl,rfl⟩
example : s03Cycle ≠ s03Cycle.symm := by
  intro h
  have hh := congrArg (fun e : Fin 4 ≃ Fin 4 => e 0) h
  exact (by decide : (1 : Fin 4) ≠ 2) hh

private def s03Expected (x : Fin 3) : Fin 4 → ENNReal :=
  if x = 2 then ![1/3,0,0,2/3] else ![0,1/3,2/3,0]

private theorem s03Target_coordinates (x : Fin 3) (j : Fin 4) :
    s03Target.channel x j = s03Expected x j := by
  obtain ⟨i,rfl⟩ := s03Cycle.surjective j
  conv_lhs => rw [← s03Enumeration_label,commonEndpoint_apply]
  fin_cases i
  · have hw : (s03PosteriorEquiv (s03LabelVector ⟨0,by decide⟩)).val.2 = f := rfl
    have hy : (s03PosteriorEquiv (s03LabelVector ⟨0,by decide⟩)).val.1 = 0 := rfl
    rw [hw,hy,q_f]
    fin_cases x <;> norm_num [s03Cycle,s03Expected,f,Fin.ext_iff,-Fin.val_eq_zero_iff,
      Matrix.cons_val_two,Matrix.cons_val_three]
  · have hw : (s03PosteriorEquiv (s03LabelVector ⟨1,by decide⟩)).val.2 = g := rfl
    have hy : (s03PosteriorEquiv (s03LabelVector ⟨1,by decide⟩)).val.1 = 0 := rfl
    rw [hw,hy,q_g]
    fin_cases x <;> norm_num [s03Cycle,s03Expected,g,Fin.ext_iff,-Fin.val_eq_zero_iff,
      Matrix.cons_val_two,Matrix.cons_val_three]
  · have hw : (s03PosteriorEquiv (s03LabelVector ⟨2,by decide⟩)).val.2 = f := rfl
    have hy : (s03PosteriorEquiv (s03LabelVector ⟨2,by decide⟩)).val.1 = 1 := rfl
    rw [hw,hy,q_f]
    fin_cases x <;> norm_num [s03Cycle,s03Expected,f,Fin.ext_iff,-Fin.val_eq_zero_iff,
      Matrix.cons_val_two,Matrix.cons_val_three]
  · have hw : (s03PosteriorEquiv (s03LabelVector ⟨3,by decide⟩)).val.2 = g := rfl
    have hy : (s03PosteriorEquiv (s03LabelVector ⟨3,by decide⟩)).val.1 = 2 := rfl
    rw [hw,hy,q_g]
    fin_cases x <;> norm_num [s03Cycle,s03Expected,g,Fin.ext_iff,-Fin.val_eq_zero_iff,
      Matrix.cons_val_two,Matrix.cons_val_three]

example : s03Target.channel 0 (s03Cycle 0) = 1/3 ∧
    s03Target.channel 0 (s03Cycle.symm 0) = 2/3 := by
  constructor <;> rw [s03Target_coordinates] <;>
    norm_num [s03Expected,s03Cycle,Fin.ext_iff,-Fin.val_eq_zero_iff,Matrix.cons_val_two]

end RegressionS02

namespace RegressionS02

private abbrev s03Pps := originalPps s03Source s03Source_singular V
private abbrev s03Bridge :=
  originalBridge s03Source s03Source_singular q V factorization s03Enumeration

example : s03Pps.path.Homogeneous .pps := s03Pps.homogeneous
example : s03Bridge.path.Homogeneous .pps :=
  originalBridge_homogeneous s03Source s03Source_singular q V factorization s03Enumeration
example : IsSingularChannel s03Pps.endpoint.channel := s03Pps.isSingular s03Source_singular
private theorem s03Pps_card : s03Pps.endpoint.outputCard = 4 := by
  rw [s03Pps.outputCard]
  simpa using Fintype.card_congr s03LabelEnumeration
private theorem s03Pps_length : s03Pps.path.length = 1 := by
  have hg := originalPps_card_growth s03Pps.path s03Pps.homogeneous
  change s03Pps.endpoint.outputCard = 3 + s03Pps.path.length at hg
  rw [s03Pps_card] at hg
  omega
example : s03Pps.path.tags = [.pps] := by
  have hl := OperationPath.tags_length s03Pps.path
  rw [s03Pps_length] at hl
  cases ht : s03Pps.path.tags with
  | nil => simp [ht] at hl
  | cons k ks =>
    have hks : ks = [] := List.eq_nil_of_length_eq_zero (by simpa [ht] using hl)
    subst ks
    have hk := s03Pps.homogeneous k (by simp [ht])
    simp [hk]

-- Every actual endpoint column has its original positive posterior label.
example (x : Fin 3) (j : Fin s03Pps.endpoint.outputCard) :
    s03Pps.endpoint.channel x j =
      V (s03Pps.labels.symm j).1 (s03Pps.labels.symm j).2.val *
        kappa x (s03Pps.labels.symm j).1 := by
  simpa only [Equiv.apply_symm_apply] using s03Pps.coordinates x (s03Pps.labels.symm j)
example : (1,g) ∉ Set.range (fun j =>
    ((s03Pps.labels.symm j).1,(s03Pps.labels.symm j).2.val)) := by
  rw [originalPps_label_iff]
  simp [s03Positive1,Ne.symm f_ne_g]
example : (2,f) ∉ Set.range (fun j =>
    ((s03Pps.labels.symm j).1,(s03Pps.labels.symm j).2.val)) := by
  rw [originalPps_label_iff]
  simp [s03Positive2,f_ne_g]

private theorem s03Forward (i : Fin 4) :
    s03Bridge.outputEquiv.equiv (s03Pps.labels (s03LabelVector i)) = s03Cycle i := by
  rw [originalBridge_label]
  exact s03Enumeration_label i
private theorem s03Inverse (i : Fin 4) :
    s03Bridge.outputEquiv.equiv.symm (s03Cycle i) = s03Pps.labels (s03LabelVector i) := by
  exact (congrArg s03Bridge.outputEquiv.equiv.symm (s03Forward i)).symm.trans
    (s03Bridge.outputEquiv.equiv.symm_apply_apply (s03Pps.labels (s03LabelVector i)))

example (x : Fin 3) (j : Fin 4) :
    s03Pps.endpoint.channel x (s03Bridge.outputEquiv.equiv.symm j) = s03Expected x j :=
  (s03Bridge.outputEquiv.apply_symm x j).trans (s03Target_coordinates x j)
example (x : Fin 3) :
    (s03Pps.endpoint.channel x).map s03Bridge.outputEquiv.equiv = s03Target.channel x :=
  s03Bridge.outputEquiv.map_eq x
example (x : Fin 3) :
    (s03Target.channel x).map s03Bridge.outputEquiv.equiv.symm = s03Pps.endpoint.channel x :=
  s03Bridge.outputEquiv.symm.map_eq x
example (x : Fin 3) :
    (s03Pps.endpoint.channel x).map
      (fun j => (s03Enumeration.symm (s03Bridge.outputEquiv.equiv j)).val) =
        auxiliaryChannel q x :=
  originalBridge_recover s03Source s03Source_singular q V factorization s03Enumeration x

-- Singleton posterior children retain their original output labels and masses.
example : (s03Pps.labels.symm (s03Bridge.outputEquiv.equiv.symm (s03Cycle 2))).1 = 1 := by
  rw [s03Inverse,Equiv.symm_apply_apply]
  rfl
example : (s03Pps.labels.symm (s03Bridge.outputEquiv.equiv.symm (s03Cycle 3))).1 = 2 := by
  rw [s03Inverse,Equiv.symm_apply_apply]
  rfl
example (x : Fin 3) : s03Pps.endpoint.channel x (s03Pps.labels s03L1f) = kappa x 1 := by
  rw [s03Pps.coordinates]
  change V 1 f * kappa x 1 = _
  simp [V_f]
example (x : Fin 3) : s03Pps.endpoint.channel x (s03Pps.labels s03L2g) = kappa x 2 := by
  rw [s03Pps.coordinates]
  change V 2 g * kappa x 2 = _
  norm_num [V_g,Fin.ext_iff,-Fin.val_eq_zero_iff]
example : columnValue s03Pps.endpoint.channel (s03Pps.isSingular s03Source_singular)
    (s03Pps.endpoint.activeEquiv (s03Pps.labels s03L0f)) = 1/3 :=
  (originalPps_value s03Source s03Source_singular q V factorization s03L0f).trans q_f
example : (columnPattern s03Pps.endpoint.channel
    (s03Pps.endpoint.activeEquiv (s03Pps.labels s03L0f))).val = {0,1} := by
  apply (originalPps_fiber_pattern s03Source s03Source_singular q V factorization s03L0f).trans
  ext x
  fin_cases x <;> simp [s03L0f,f,Fin.ext_iff,-Fin.val_eq_zero_iff,Matrix.cons_val_two]

/-! A singleton posterior family exercises the actual returned no-op path. -/

private def s03ConstantKappa (_ : Fin 3) : PMF (Fin 1) := PMF.pure 0
private abbrev s03ConstantSource : ActiveFiniteChannel (Fin 3) :=
  ⟨1,by decide,s03ConstantKappa,fun y => ⟨0,by
    rw [Fin.eq_zero y]
    simp [s03ConstantKappa]⟩⟩
private theorem s03Constant_singular : IsSingularChannel s03ConstantSource.channel := by
  intro x z y _ _
  rfl
private def s03ConstantV (_ : Fin 1) := constantLaw
private theorem s03Constant_factorization (x : Fin 3) :
    auxiliaryChannel constantLaw x =
      PMF.channelJoint (s03ConstantSource.channel x) s03ConstantV := by
  simp [auxiliaryChannel,constantLaw,s03ConstantSource,s03ConstantKappa,s03ConstantV,
    constantVector,PMF.channelJoint,PMF.pure_map]
private theorem s03Constant_singleton (y : Fin 1) :
    Subsingleton {w : Fin 3 → Fin 1 // 0 < s03ConstantV y w} := inferInstance
private abbrev s03ConstantPps :=
  originalPps s03ConstantSource s03Constant_singular s03ConstantV
private abbrev s03ConstantBridge := originalBridge s03ConstantSource s03Constant_singular
  constantLaw s03ConstantV s03Constant_factorization constantEnumeration

example : s03ConstantPps.path.length = 0 :=
  originalPps_length_singleton s03ConstantSource s03Constant_singular s03ConstantV
    s03Constant_singleton
example : s03ConstantPps.path.tags = [] :=
  originalPps_tags_singleton s03ConstantSource s03Constant_singular s03ConstantV
    s03Constant_singleton
example (x : Fin 3) :
    (s03ConstantPps.endpoint.channel x).map s03ConstantBridge.outputEquiv.equiv =
      constantEndpoint.channel x := s03ConstantBridge.outputEquiv.map_eq x
example (x : Fin 3) :
    (constantEndpoint.channel x).map s03ConstantBridge.outputEquiv.equiv.symm =
      s03ConstantPps.endpoint.channel x := s03ConstantBridge.outputEquiv.symm.map_eq x

end RegressionS02
end
end CanonicalConstruction
end PerfectFunctionalRepresentations.MatrixOperations


/-! ## The actual all-ones PPS/VPS construction -/

namespace PerfectFunctionalRepresentations.MatrixOperations.CanonicalConstruction
noncomputable section
attribute [local instance] Classical.propDecidable
open scoped BigOperators ENNReal
universe u v
variable {alpha : Type u} {beta : Type v}

section SeedPps
variable [Fintype alpha] [Fintype beta] [Nonempty alpha]
variable (q : PMF (alpha → beta))

private def seedRawLabels : q.support ≃
    {w : alpha → beta // 0 < q w} ⊕ {j : Fin 1 // j ≠ 0} where
  toFun w := .inl ⟨w.val,pos_iff_ne_zero.mpr w.property⟩
  invFun := Sum.elim (fun w => ⟨w.val,ne_of_gt w.property⟩)
    (fun j => (j.property (Subsingleton.elim _ _)).elim)
  left_inv _ := rfl
  right_inv l := by
    rcases l with w | j
    · rfl
    · exact (j.property (Subsingleton.elim _ _)).elim

-- Only the complete output labels change; endpoint and primitive path are the
-- same selected-column C10 ENNReal witness.
private def seedPps :
    LabelledOperationResult .pps (ActiveFiniteChannel.allOnes alpha) q.support
      (fun _ w => q w.val) := by
  let d := multiPpsOfENNReal (ActiveFiniteChannel.allOnes alpha)
    (ActiveFiniteChannel.allOnes_isSingular alpha) (0 : Fin 1)
    (fun w => q w) (by simpa using q.tsum_coe)
  refine ⟨d.endpoint,d.path,d.homogeneous,(seedRawLabels q).trans d.labels,?_⟩
  intro x w
  exact (d.coordinates x (seedRawLabels q w)).trans (by
    change q w.val * (ActiveFiniteChannel.allOnes alpha).channel x (0 : Fin 1) = q w.val
    rw [ActiveFiniteChannel.allOnes_apply,mul_one])

private theorem seedPps_apply (x : alpha) (j : Fin (seedPps q).endpoint.outputCard) :
    (seedPps q).endpoint.channel x j = q ((seedPps q).labels.symm j).val := by
  simpa only [Equiv.apply_symm_apply] using
    (seedPps q).coordinates x ((seedPps q).labels.symm j)

private theorem seedPps_pattern (j : Fin (seedPps q).endpoint.outputCard) :
    (columnPattern (seedPps q).endpoint.channel ((seedPps q).endpoint.activeEquiv j)).val =
      Finset.univ := by
  ext x
  rw [mem_columnPattern]
  change (seedPps q).endpoint.channel x j ≠ 0 ↔ x ∈ (Finset.univ : Finset alpha)
  rw [seedPps_apply]
  simp only [Finset.mem_univ,iff_true]
  exact ((seedPps q).labels.symm j).property

private theorem seedPps_value (j : Fin (seedPps q).endpoint.outputCard) :
    columnValue (seedPps q).endpoint.channel
      ((seedPps q).isSingular (ActiveFiniteChannel.allOnes_isSingular alpha))
      ((seedPps q).endpoint.activeEquiv j) = q ((seedPps q).labels.symm j).val := by
  let x : alpha := Classical.choice inferInstance
  have hn : (seedPps q).endpoint.channel x j ≠ 0 := by
    rw [seedPps_apply]
    exact ((seedPps q).labels.symm j).property
  exact (columnValue_eq_of_ne_zero _ _ _ hn).trans (seedPps_apply q x j)

private theorem seedBlocks_cover (j : Fin (seedPps q).endpoint.outputCard) (x : alpha) :
    x ∈ (columnPattern (seedPps q).endpoint.channel
      ((seedPps q).endpoint.activeEquiv j)).val ↔
      ∃ y : {y : beta // ∃ x, ((seedPps q).labels.symm j).val x = y},
        x ∈ decoderBlocks ((seedPps q).labels.symm j).val y := by
  rw [seedPps_pattern]
  exact decoderBlocks_cover _ x

-- Construct on the actual Q-pattern carrier. The supplied blocks and their
-- original decoder labels are preserved without a Finpartition type cast.
private def seedPartition (j : Fin (seedPps q).endpoint.outputCard) :
    Finpartition (columnPattern (seedPps q).endpoint.channel
      ((seedPps q).endpoint.activeEquiv j)).val :=
  partitionOfBlocks _ (decoderBlocks ((seedPps q).labels.symm j).val)
    (decoderBlocks_nonempty _) (decoderBlocks_disjoint _) (seedBlocks_cover q j)

private def seedPartitionEquiv (j : Fin (seedPps q).endpoint.outputCard) :
    {y : beta // ∃ x, ((seedPps q).labels.symm j).val x = y} ≃ (seedPartition q j).parts :=
  partitionOfBlocksEquiv _ (decoderBlocks ((seedPps q).labels.symm j).val)
    (decoderBlocks_nonempty _) (decoderBlocks_disjoint _) (seedBlocks_cover q j)

private theorem seedPartitionEquiv_apply_val (j : Fin (seedPps q).endpoint.outputCard)
    (y : {y : beta // ∃ x, ((seedPps q).labels.symm j).val x = y}) :
    (seedPartitionEquiv q j y).val = decoderBlocks ((seedPps q).labels.symm j).val y := rfl

private theorem seedPartitionEquiv_symm_block (j : Fin (seedPps q).endpoint.outputCard)
    (b : (seedPartition q j).parts) :
    decoderBlocks ((seedPps q).labels.symm j).val ((seedPartitionEquiv q j).symm b) =
      b.val := by
  exact congrArg Subtype.val ((seedPartitionEquiv q j).apply_symm_apply b)

private def seedVps :
    LabelledOperationResult .vps (seedPps q).endpoint
      (Σ j, (seedPartition q j).parts)
      (fun x p => if x ∈ p.2.val then (seedPps q).endpoint.channel x p.1 else 0) :=
  multiVpsFamily (seedPps q).endpoint
    ((seedPps q).isSingular (ActiveFiniteChannel.allOnes_isSingular alpha)) (seedPartition q)

private theorem seedVps_decoder_coordinates (x : alpha)
    (j : Fin (seedPps q).endpoint.outputCard)
    (y : {y : beta // ∃ x, ((seedPps q).labels.symm j).val x = y}) :
    (seedVps q).endpoint.channel x ((seedVps q).labels ⟨j,seedPartitionEquiv q j y⟩) =
      if ((seedPps q).labels.symm j).val x = y.val then
        q ((seedPps q).labels.symm j).val else 0 := by
  rw [(seedVps q).coordinates]
  change (if x ∈ (seedPartitionEquiv q j y).val then
    (seedPps q).endpoint.channel x j else 0) = _
  rw [seedPartitionEquiv_apply_val,seedPps_apply]
  simp only [decoderBlocks,Finset.mem_filter,Finset.mem_univ,true_and]

-- Required early actual-Q checkpoint: both the original decoder block and the
-- returned VPS coordinate are checked before constructing the full bridge.
example (j : Fin (seedPps q).endpoint.outputCard)
    (y : {y : beta // ∃ x, ((seedPps q).labels.symm j).val x = y}) (x : alpha) :
    (seedPartitionEquiv q j y).val = decoderBlocks ((seedPps q).labels.symm j).val y ∧
    (seedVps q).endpoint.channel x ((seedVps q).labels ⟨j,seedPartitionEquiv q j y⟩) =
      if ((seedPps q).labels.symm j).val x = y.val then
        q ((seedPps q).labels.symm j).val else 0 :=
  ⟨seedPartitionEquiv_apply_val q j y,seedVps_decoder_coordinates q x j y⟩

end SeedPps
end
end PerfectFunctionalRepresentations.MatrixOperations.CanonicalConstruction


namespace PerfectFunctionalRepresentations.MatrixOperations.CanonicalConstruction
noncomputable section
attribute [local instance] Classical.propDecidable
open scoped BigOperators ENNReal
universe u v
variable {alpha : Type u} {beta : Type v}

section SeedBridge
variable [Fintype alpha] [Fintype beta] [Nonempty alpha]
variable (q : PMF (alpha → beta))

private theorem seedPps_label_iff (w : alpha → beta) :
    w ∈ Set.range (fun j => ((seedPps q).labels.symm j).val) ↔ 0 < q w := by
  constructor
  · rintro ⟨j,hj⟩
    exact Eq.mp (congrArg (fun w => 0 < q w) hj)
      (pos_iff_ne_zero.mpr ((seedPps q).labels.symm j).property)
  · intro hw
    refine ⟨(seedPps q).labels ⟨w,ne_of_gt hw⟩,?_⟩
    exact congrArg Subtype.val ((seedPps q).labels.symm_apply_apply ⟨w,ne_of_gt hw⟩)

private def seedVpsLabels : (Σ j, (seedPartition q j).parts) ≃
    activeOutputs (auxiliaryChannel q) :=
  (Equiv.sigmaCongr (seedPps q).labels.symm
    (fun j => (seedPartitionEquiv q j).symm)).trans (decoderLabelsEquiv q)

private theorem seedVpsLabels_apply_val (p : Σ j, (seedPartition q j).parts) :
    (seedVpsLabels q p).val =
      (((seedPartitionEquiv q p.1).symm p.2).val,((seedPps q).labels.symm p.1).val) := rfl

private theorem seedVps_coordinates (x : alpha) (p : Σ j, (seedPartition q j).parts) :
    (seedVps q).endpoint.channel x ((seedVps q).labels p) =
      auxiliaryChannel q x (seedVpsLabels q p).val := by
  rw [(seedVps q).coordinates,seedVpsLabels_apply_val,auxiliaryChannel_apply]
  rw [← seedPartitionEquiv_symm_block q p.1 p.2,seedPps_apply]
  simp only [decoderBlocks,Finset.mem_filter,Finset.mem_univ,true_and]

private theorem seedVps_pattern (p : Σ j, (seedPartition q j).parts) :
    (columnPattern (seedVps q).endpoint.channel
      ((seedVps q).endpoint.activeEquiv ((seedVps q).labels p))).val = p.2.val := by
  ext x
  rw [mem_columnPattern]
  change (seedVps q).endpoint.channel x ((seedVps q).labels p) ≠ 0 ↔ x ∈ p.2.val
  rw [(seedVps q).coordinates]
  by_cases hx : x ∈ p.2.val
  · rw [if_pos hx,seedPps_apply]
    exact iff_of_true ((seedPps q).labels.symm p.1).property hx
  · rw [if_neg hx]
    simp [hx]

private theorem seedVps_value (p : Σ j, (seedPartition q j).parts) :
    columnValue (seedVps q).endpoint.channel
      ((seedVps q).isSingular ((seedPps q).isSingular
        (ActiveFiniteChannel.allOnes_isSingular alpha)))
      ((seedVps q).endpoint.activeEquiv ((seedVps q).labels p)) =
      q ((seedPps q).labels.symm p.1).val := by
  obtain ⟨x,hx⟩ := (seedPartition q p.1).nonempty_of_mem_parts p.2.property
  have hm : (seedVps q).endpoint.channel x ((seedVps q).labels p) =
      q ((seedPps q).labels.symm p.1).val := by
    rw [(seedVps q).coordinates]
    rw [if_pos hx,seedPps_apply]
  have hn : (seedVps q).endpoint.channel x ((seedVps q).labels p) ≠ 0 :=
    hm ▸ ((seedPps q).labels.symm p.1).property
  exact (columnValue_eq_of_ne_zero _ _ _ hn).trans hm

variable {m : Nat} (eA : activeOutputs (auxiliaryChannel q) ≃ Fin m)

private theorem seedTarget_coordinates (x : alpha) (p : Σ j, (seedPartition q j).parts) :
    (commonEndpoint q eA).channel x (eA (seedVpsLabels q p)) =
      if x ∈ p.2.val then (seedPps q).endpoint.channel x p.1 else 0 := by
  change (ActiveFiniteChannel.ofChannelWithEquiv (auxiliaryChannel q) eA).channel x _ = _
  rw [ActiveFiniteChannel.ofChannelWithEquiv_apply]
  exact (seedVps_coordinates q x p).symm.trans ((seedVps q).coordinates x p)

private def seedVpsBridge : Cascade (seedPps q).endpoint (commonEndpoint q eA) :=
  (seedVps q).cascade ((seedVpsLabels q).trans eA) (seedTarget_coordinates q eA)

-- The actual stages meet at Q, so their literal concatenation retains both
-- chosen C10 paths. The final directed comparison is the VPS comparison.
private def seedBridge : Cascade (ActiveFiniteChannel.allOnes alpha) (commonEndpoint q eA) where
  endpoint := (seedVps q).endpoint
  path := (seedPps q).path.append (seedVps q).path
  outputEquiv := (seedVpsBridge q eA).outputEquiv

private theorem seedBridge_path :
    (seedBridge q eA).path = (seedPps q).path.append (seedVps q).path := rfl

private theorem seedBridge_tags :
    (seedBridge q eA).path.tags = (seedPps q).path.tags ++ (seedVps q).path.tags :=
  OperationPath.tags_append _ _

private theorem seedBridge_word :
    (seedBridge q eA).path.tags =
      List.replicate (seedPps q).path.length .pps ++
        List.replicate (seedVps q).path.length .vps := by
  have hp : (seedPps q).path.tags = List.replicate (seedPps q).path.length .pps := by
    simpa only [OperationPath.tags_length] using
      List.eq_replicate_length.mpr (seedPps q).homogeneous
  have hv : (seedVps q).path.tags = List.replicate (seedVps q).path.length .vps := by
    simpa only [OperationPath.tags_length] using
      List.eq_replicate_length.mpr (seedVps q).homogeneous
  rw [seedBridge_tags,hp,hv]

private theorem seedBridge_label (p : Σ j, (seedPartition q j).parts) :
    (seedBridge q eA).outputEquiv.equiv ((seedVps q).labels p) =
      eA (seedVpsLabels q p) := by
  change eA (seedVpsLabels q ((seedVps q).labels.symm ((seedVps q).labels p))) = _
  rw [Equiv.symm_apply_apply]

private theorem seedBridge_label_symm (z : activeOutputs (auxiliaryChannel q)) :
    (seedBridge q eA).outputEquiv.equiv.symm (eA z) =
      (seedVps q).labels ((seedVpsLabels q).symm z) := by
  change (seedVps q).labels ((seedVpsLabels q).symm (eA.symm (eA z))) = _
  rw [Equiv.symm_apply_apply]

private theorem seedBridge_map (x : alpha) :
    ((seedVps q).endpoint.channel x).map (seedBridge q eA).outputEquiv.equiv =
      (commonEndpoint q eA).channel x := (seedBridge q eA).outputEquiv.map_eq x

private theorem seedBridge_map_symm (x : alpha) :
    ((commonEndpoint q eA).channel x).map (seedBridge q eA).outputEquiv.equiv.symm =
      (seedVps q).endpoint.channel x := (seedBridge q eA).outputEquiv.symm.map_eq x

private theorem seedBridge_recover (x : alpha) :
    ((seedVps q).endpoint.channel x).map
      (fun j => (eA.symm ((seedBridge q eA).outputEquiv.equiv j)).val) =
        auxiliaryChannel q x := by
  let f : Fin (seedVps q).endpoint.outputCard → Fin m := (seedBridge q eA).outputEquiv.equiv
  let g : Fin m → beta × (alpha → beta) := fun j => (eA.symm j).val
  exact (PMF.map_comp (f := f) (p := (seedVps q).endpoint.channel x) g).symm.trans
    ((congrArg (fun p : PMF (Fin m) => p.map g)
      (seedBridge_map q eA x)).trans (commonEndpoint_recover q eA x))

private theorem seedBridge_stages_singular (A : ActiveFiniteChannel alpha)
    (before : OperationPath (ActiveFiniteChannel.allOnes alpha) A)
    (after : OperationPath A (seedVps q).endpoint)
    (_hpath : before.append after = (seedBridge q eA).path) :
    IsSingularChannel A.channel := before.isSingular (ActiveFiniteChannel.allOnes_isSingular alpha)

end SeedBridge

section SeedStageSpecifications
variable [Fintype alpha] [Fintype beta] [Nonempty alpha]
attribute [local instance] operationQuiver

private theorem seedPps_length_singleton (q : PMF (alpha → beta))
    (hsingleton : Subsingleton q.support) : (seedPps q).path.length = 0 := by
  let : Subsingleton q.support := hsingleton
  let : Unique q.support := uniqueOfSubsingleton (Classical.choice q.support_nonempty.to_subtype)
  have hc : (seedPps q).endpoint.outputCard = 1 := by
    rw [(seedPps q).outputCard,Fintype.card_unique]
  have hg := originalPps_card_growth (seedPps q).path (seedPps q).homogeneous
  change (seedPps q).endpoint.outputCard = 1 + (seedPps q).path.length at hg
  omega

private theorem seedPps_tags_singleton (q : PMF (alpha → beta))
    (hsingleton : Subsingleton q.support) : (seedPps q).path.tags = [] := by
  apply List.eq_nil_of_length_eq_zero
  rw [OperationPath.tags_length,seedPps_length_singleton q hsingleton]

omit [Fintype alpha] [Fintype beta] in
private theorem seedVps_card_growth [Finite alpha] {S T : ActiveFiniteChannel alpha}
    (p : OperationPath S T) (hp : p.Homogeneous .vps) :
    T.outputCard = S.outputCard + p.length := by
  induction p with
  | nil => rfl
  | cons p e ih =>
      have h := (OperationPath.allowed_snoc _ p e).mp hp
      cases e with
      | pps hT l t ht0 ht1 => simp [OperationStep.kind] at h
      | vps hT l mask hl hr =>
          change _ + 1 = S.outputCard + (p.length + 1)
          rw [ih h.1,Nat.add_assoc]
          rfl
      | ppm hT a b hab hs => simp [OperationStep.kind] at h
      | vpm hT a b hab hv hd => simp [OperationStep.kind] at h

private theorem seedVps_length_singleton (q : PMF (alpha → beta))
    (hsingleton : ∀ w : q.support, Subsingleton {y : beta // ∃ x, w.val x = y}) :
    (seedVps q).path.length = 0 := by
  let (j : Fin (seedPps q).endpoint.outputCard) : Subsingleton (seedPartition q j).parts :=
    ⟨fun b c => (seedPartitionEquiv q j).symm.injective
      ((hsingleton ((seedPps q).labels.symm j)).elim _ _)⟩
  let (j : Fin (seedPps q).endpoint.outputCard) : Unique (seedPartition q j).parts :=
    uniqueOfSubsingleton (seedPartitionEquiv q j
      (Classical.choice (decoderLabels_nonempty ((seedPps q).labels.symm j).val)))
  have hc : (seedVps q).endpoint.outputCard = (seedPps q).endpoint.outputCard := by
    rw [(seedVps q).outputCard]
    simpa only [Fintype.card_fin] using Fintype.card_congr
      (Equiv.sigmaUnique (Fin (seedPps q).endpoint.outputCard)
        (fun j => (seedPartition q j).parts))
  have hg := seedVps_card_growth (seedVps q).path (seedVps q).homogeneous
  omega

private theorem seedVps_tags_singleton (q : PMF (alpha → beta))
    (hsingleton : ∀ w : q.support, Subsingleton {y : beta // ∃ x, w.val x = y}) :
    (seedVps q).path.tags = [] := by
  apply List.eq_nil_of_length_eq_zero
  rw [OperationPath.tags_length,seedVps_length_singleton q hsingleton]

end SeedStageSpecifications

-- One extraction of q,V,hV and one supplied eA fixes the literal common target
-- of both constructions. No full-support input prior or new posterior premise.
example [Finite alpha] [Nonempty alpha] (S : ActiveFiniteChannel alpha)
    (hP : IsPerfectlyRepresentableChannel S.channel) :
    ∃ (q : PMF (alpha → Fin S.outputCard))
      (V : Fin S.outputCard → PMF (alpha → Fin S.outputCard)),
      (∀ x, auxiliaryChannel q x = PMF.channelJoint (S.channel x) V) ∧
      ∀ {m : Nat} (eA : activeOutputs (auxiliaryChannel q) ≃ Fin m),
        ∃ (a : Cascade S (commonEndpoint q eA))
          (b : Cascade (ActiveFiniteChannel.allOnes alpha) (commonEndpoint q eA)),
          a.path.Homogeneous .pps ∧ ∃ nP nV : Nat,
            b.path.tags = List.replicate nP .pps ++ List.replicate nV .vps := by
  let := Fintype.ofFinite alpha
  have hS := hP.isSingular
  obtain ⟨q,V,hV⟩ := hP
  refine ⟨q,V,hV,?_⟩
  intro m eA
  refine ⟨originalBridge S hS q V hV eA,seedBridge q eA,
    originalBridge_homogeneous S hS q V hV eA,?_⟩
  exact ⟨(seedPps q).path.length,(seedVps q).path.length,seedBridge_word q eA⟩

end
end PerfectFunctionalRepresentations.MatrixOperations.CanonicalConstruction

/-! ## R09-R11: actual seed stages and the common endpoint -/

namespace PerfectFunctionalRepresentations.MatrixOperations.CanonicalConstruction
noncomputable section
attribute [local instance] Classical.propDecidable
namespace RegressionS04
open scoped BigOperators ENNReal

-- All three fixtures use explicit pure posteriors. This local enumeration retains y.
private def pureLabels {alpha : Type*} {n : Nat} (d : Fin n → alpha → Fin n) :
    (Σ y, {w : alpha → Fin n // 0 < PMF.pure (d y) w}) ≃ Fin n where
  toFun p := p.1
  invFun y := ⟨y,d y,by simp⟩
  left_inv p := by
    rcases p with ⟨y,w,hw⟩
    have h : w = d y := by
      by_contra h
      simp [PMF.pure_apply,h] at hw
    subst w
    rfl
  right_inv _ := rfl

private theorem purePositive_singleton {alpha : Type*} (w : alpha) :
    Subsingleton {z : alpha // 0 < PMF.pure w z} := by
  constructor
  intro a b
  have ha : a.val = w := by
    by_contra h
    simpa [PMF.pure_apply,h] using a.property
  have hb : b.val = w := by
    by_contra h
    simpa [PMF.pure_apply,h] using b.property
  exact Subtype.ext (ha.trans hb.symm)

/-! R09: one vector, value one, but two nonempty unequal decoder pieces. -/
namespace PureSplit
private def w : Fin 3 → Fin 2 := ![0,0,1]
private def q : PMF (Fin 3 → Fin 2) := PMF.pure w
private def kappa (x : Fin 3) : PMF (Fin 2) := PMF.pure (w x)
private def V (_ : Fin 2) : PMF (Fin 3 → Fin 2) := q
private theorem active (y : Fin 2) : y ∈ activeOutputs kappa := by
  fin_cases y
  · exact ⟨0,by simp [kappa,w]⟩
  · exact ⟨2,by simp [kappa,w,Matrix.cons_val_two]⟩
private abbrev source : ActiveFiniteChannel (Fin 3) := ⟨2,by decide,kappa,active⟩
private theorem singular : IsSingularChannel source.channel := by
  intro x z y hx hz
  have hxy : w x = y := by
    by_contra h
    simp [source,kappa,PMF.pure_apply,Ne.symm h] at hx
  have hzy : w z = y := by
    by_contra h
    simp [source,kappa,PMF.pure_apply,Ne.symm h] at hz
  simp [source,kappa,hxy,hzy]
private theorem factorization (x : Fin 3) :
    auxiliaryChannel q x = PMF.channelJoint (source.channel x) V := by
  simp [auxiliaryChannel,q,source,kappa,V,PMF.channelJoint,PMF.pure_map]
private def enumeration : activeOutputs (auxiliaryChannel q) ≃ Fin 2 :=
  (posteriorLabelsEquiv q source.channel V factorization source.output_active).symm.trans
    (pureLabels (fun _ => w))
private def sw : q.support := ⟨w,by simp [q]⟩
private theorem support_singleton : Subsingleton q.support := by
  constructor
  intro a b
  have ha : a.val = w := by simpa [q] using a.property
  have hb : b.val = w := by simpa [q] using b.property
  exact Subtype.ext (ha.trans hb.symm)
private def y0 : {y : Fin 2 // ∃ x, w x = y} := ⟨0,0,rfl⟩
private def y1 : {y : Fin 2 // ∃ x, w x = y} := ⟨1,2,rfl⟩
private theorem block0 : decoderBlocks w y0 = {0,1} := by
  ext x
  fin_cases x <;> simp [decoderBlocks,w,y0,Fin.ext_iff,-Fin.val_eq_zero_iff,
    Matrix.cons_val_two]
private theorem block1 : decoderBlocks w y1 = {2} := by
  ext x
  fin_cases x <;> simp [decoderBlocks,w,y1,Fin.ext_iff,-Fin.val_eq_zero_iff,
    Matrix.cons_val_two]
example : q w = 1 := by simp [q]
example : (decoderBlocks w y0).card = 2 ∧ (decoderBlocks w y1).card = 1 := by
  rw [block0,block1]
  decide
example : Disjoint (decoderBlocks w y0) (decoderBlocks w y1) ∧
    decoderBlocks w y0 ∪ decoderBlocks w y1 = Finset.univ := by
  rw [block0,block1]
  decide
end PureSplit

/-! R10: two distinct full-pattern columns and one vector with unequal fibers. -/
namespace Repeated
private abbrev W := Fin 3 → Fin 4
private def u : W := fun _ => 0
private def v : W := ![1,1,2]
private def z : W := fun _ => 3
private def weights : Fin 3 → NNReal := ![1/4,1/2,1/4]
private theorem weights_sum : ∑ i, weights i = 1 := by
  norm_num [weights,Fin.sum_univ_succ]
private def indexLaw : PMF (Fin 3) :=
  PMF.ofFintype (fun i => (weights i : ENNReal)) (by exact_mod_cast weights_sum)
private def q : PMF W := indexLaw.map (![u,v,z] : Fin 3 → W)
private theorem uv : u ≠ v := by
  intro h
  have h0 := congrFun h 0
  norm_num [u,v] at h0
private theorem uz : u ≠ z := by
  intro h
  have h0 := congrFun h 0
  norm_num [u,z,Fin.ext_iff] at h0
private theorem vz : v ≠ z := by
  intro h
  have h0 := congrFun h 0
  norm_num [v,z,Fin.ext_iff] at h0
private theorem q_apply (w : W) :
    q w = (if w = u then (1/4 : ENNReal) else 0) +
      (if w = v then (1/2 : ENNReal) else 0) +
      (if w = z then (1/4 : ENNReal) else 0) := by
  unfold q
  rw [PMF.map_apply]
  simp [indexLaw,tsum_fintype,Fin.sum_univ_succ,weights,eq_comm,add_assoc]
private theorem q_u : q u = 1/4 := by simp [q_apply,uv,uz]
private theorem q_v : q v = 1/2 := by simp [q_apply,Ne.symm uv,vz]
private theorem q_z : q z = 1/4 := by simp [q_apply,Ne.symm uz,Ne.symm vz]
private theorem support_iff (w : W) : w ∈ q.support ↔ w = u ∨ w = v ∨ w = z := by
  change q w ≠ 0 ↔ _
  by_cases hu : w = u
  · subst w; simp [q_u]
  · by_cases hv : w = v
    · subst w; simp [q_v]
    · by_cases hz : w = z
      · subst w; simp [q_z]
      · simp [q_apply,hu,hv,hz]
private def su : q.support := ⟨u,by rw [support_iff]; exact Or.inl rfl⟩
private def sv : q.support := ⟨v,by rw [support_iff]; exact Or.inr (Or.inl rfl)⟩
private def sz : q.support := ⟨z,by rw [support_iff]; exact Or.inr (Or.inr rfl)⟩
private def supportEnumeration : q.support ≃ Fin 3 where
  toFun w := if w.val = u then 0 else if w.val = v then 1 else 2
  invFun i := if i = 0 then su else if i = 1 then sv else sz
  left_inv w := by
    apply Subtype.ext
    obtain hu | hv | hz := (support_iff w.val).mp w.property
    · simp [hu,su]
    · simp [hv,sv,Ne.symm uv]
    · simp [hz,sz,Ne.symm uz,Ne.symm vz]
  right_inv i := by
    fin_cases i <;> simp [su,sv,sz,Ne.symm uv,Ne.symm uz,Ne.symm vz,
      Fin.ext_iff,-Fin.val_eq_zero_iff]
private def row (x : Fin 3) : Fin 4 → NNReal :=
  if x = 2 then ![1/4,0,1/2,1/4] else ![1/4,1/2,0,1/4]
private theorem row_sum (x : Fin 3) : ∑ y, row x y = 1 := by
  fin_cases x <;> norm_num [row,Fin.sum_univ_succ,Fin.ext_iff,-Fin.val_eq_zero_iff]
private def kappa (x : Fin 3) : PMF (Fin 4) :=
  PMF.ofFintype (fun y => (row x y : ENNReal)) (by exact_mod_cast row_sum x)
private def posteriorVector : Fin 4 → W := ![u,v,v,z]
private def V (y : Fin 4) : PMF W := PMF.pure (posteriorVector y)
private theorem V_u (y : Fin 4) : V y u = if y = 0 then 1 else 0 := by
  fin_cases y <;> simp [V,posteriorVector,uv,uz,Fin.ext_iff,-Fin.val_eq_zero_iff,
    Matrix.cons_val_two,Matrix.cons_val_three]
private theorem V_v (y : Fin 4) : V y v = if y = 1 ∨ y = 2 then 1 else 0 := by
  fin_cases y <;> simp [V,posteriorVector,Ne.symm uv,vz,Fin.ext_iff,-Fin.val_eq_zero_iff,
    Matrix.cons_val_two,Matrix.cons_val_three]
private theorem V_z (y : Fin 4) : V y z = if y = 3 then 1 else 0 := by
  fin_cases y <;> simp [V,posteriorVector,Ne.symm uz,Ne.symm vz,Fin.ext_iff,
    -Fin.val_eq_zero_iff,Matrix.cons_val_two,Matrix.cons_val_three]
private theorem factorization (x : Fin 3) :
    auxiliaryChannel q x = PMF.channelJoint (kappa x) V := by
  apply PMF.ext
  rintro ⟨y,w⟩
  rw [auxiliaryChannel_apply,PMF.channelJoint_apply]
  by_cases hu : w = u
  · subst w
    rw [q_u,V_u]
    fin_cases x <;> fin_cases y <;>
      norm_num [kappa,row,u,Fin.ext_iff,-Fin.val_eq_zero_iff,Matrix.cons_val_two,
        Matrix.cons_val_three]
  · by_cases hv : w = v
    · subst w
      rw [q_v,V_v]
      fin_cases x <;> fin_cases y <;>
        norm_num [kappa,row,v,Fin.ext_iff,-Fin.val_eq_zero_iff,Matrix.cons_val_two,
          Matrix.cons_val_three]
    · by_cases hz : w = z
      · subst w
        rw [q_z,V_z]
        fin_cases x <;> fin_cases y <;>
          norm_num [kappa,row,z,Fin.ext_iff,-Fin.val_eq_zero_iff,Matrix.cons_val_two,
            Matrix.cons_val_three]
      · have hq : q w = 0 := by simp [q_apply,hu,hv,hz]
        rw [hq]
        fin_cases y <;>
          simp [V,posteriorVector,PMF.pure_apply,hu,hv,hz,Matrix.cons_val_two,
            Matrix.cons_val_three]
private theorem active (y : Fin 4) : y ∈ activeOutputs kappa := by
  fin_cases y
  · exact ⟨0,by norm_num [kappa,row,Fin.ext_iff,-Fin.val_eq_zero_iff]⟩
  · exact ⟨0,by norm_num [kappa,row,Fin.ext_iff,-Fin.val_eq_zero_iff]⟩
  · exact ⟨2,by norm_num [kappa,row,Matrix.cons_val_two]⟩
  · exact ⟨0,by norm_num [kappa,row,Fin.ext_iff,-Fin.val_eq_zero_iff,Matrix.cons_val_three]⟩
private abbrev source : ActiveFiniteChannel (Fin 3) := ⟨4,by decide,kappa,active⟩
private theorem singular : IsSingularChannel source.channel := by
  intro x t y hx ht
  fin_cases x <;> fin_cases t <;> fin_cases y <;>
    norm_num [source,kappa,row,Fin.ext_iff,-Fin.val_eq_zero_iff,
      Matrix.cons_val_two,Matrix.cons_val_three] at *
private def enumeration : activeOutputs (auxiliaryChannel q) ≃ Fin 4 :=
  (posteriorLabelsEquiv q source.channel V factorization source.output_active).symm.trans
    (pureLabels posteriorVector)
private def u0 : {y : Fin 4 // ∃ x, u x = y} := ⟨0,0,rfl⟩
private def v1 : {y : Fin 4 // ∃ x, v x = y} := ⟨1,0,rfl⟩
private def v2 : {y : Fin 4 // ∃ x, v x = y} := ⟨2,2,rfl⟩
private def z3 : {y : Fin 4 // ∃ x, z x = y} := ⟨3,0,rfl⟩
private theorem u_block : decoderBlocks u u0 = Finset.univ := by
  simp [decoderBlocks,u,u0]
private theorem z_block : decoderBlocks z z3 = Finset.univ := by
  simp [decoderBlocks,z,z3]
private theorem v1_block : decoderBlocks v v1 = {0,1} := by
  ext x
  fin_cases x <;> simp [decoderBlocks,v,v1,Fin.ext_iff,-Fin.val_eq_zero_iff,
    Matrix.cons_val_two]
private theorem v2_block : decoderBlocks v v2 = {2} := by
  ext x
  fin_cases x <;> simp [decoderBlocks,v,v2,Fin.ext_iff,-Fin.val_eq_zero_iff,
    Matrix.cons_val_two]
example : Fintype.card q.support = 3 := by simpa using Fintype.card_congr supportEnumeration
example : decoderBlocks u u0 = decoderBlocks z z3 := u_block.trans z_block.symm
example : (decoderLabelsEquiv q ⟨su,u0⟩) ≠ (decoderLabelsEquiv q ⟨sz,z3⟩) := by
  intro h
  exact uz (congrArg (fun a => a.val.2) h)
end Repeated

/-! R11: one input, one output and one supported vector. -/
namespace Singleton
private def w : Fin 1 → Fin 1 := fun _ => 0
private def q : PMF (Fin 1 → Fin 1) := PMF.pure w
private abbrev source := ActiveFiniteChannel.allOnes (Fin 1)
private def V (_ : Fin 1) : PMF (Fin 1 → Fin 1) := q
private theorem factorization (x : Fin 1) :
    auxiliaryChannel q x = PMF.channelJoint (source.channel x) V := by
  simp [auxiliaryChannel,q,source,V,w,ActiveFiniteChannel.allOnes,
    PMF.channelJoint,PMF.pure_map]
private def enumeration : activeOutputs (auxiliaryChannel q) ≃ Fin 1 :=
  (posteriorLabelsEquiv q source.channel V factorization source.output_active).symm.trans
    (pureLabels (fun _ => w))
example : (commonEndpoint q enumeration).outputCard = 1 := rfl
example : q w = 1 := by simp [q]
end Singleton
end RegressionS04
end
end PerfectFunctionalRepresentations.MatrixOperations.CanonicalConstruction

namespace PerfectFunctionalRepresentations.MatrixOperations.CanonicalConstruction
noncomputable section
attribute [local instance] Classical.propDecidable
namespace RegressionS04
open scoped BigOperators ENNReal
-- Match the actual Finpartition carrier's classical finset lattice instance.
@[instance_reducible] private def fixtureDecidableEqFin3 : DecidableEq (Fin 3) :=
  fun a b => Classical.propDecidable (a = b)
attribute [local instance] fixtureDecidableEqFin3

namespace PureSplit
private abbrev pps := seedPps q
private abbrev vps := seedVps q
private abbrev b := seedBridge q enumeration
private abbrev a := originalBridge source singular q V factorization enumeration
private theorem pps_card : pps.endpoint.outputCard = 1 := by
  let : Subsingleton q.support := support_singleton
  let : Unique q.support := uniqueOfSubsingleton sw
  rw [pps.outputCard]
  exact Fintype.card_unique
private theorem pps_length : pps.path.length = 0 :=
  seedPps_length_singleton q support_singleton
private theorem pps_tags : pps.path.tags = [] :=
  seedPps_tags_singleton q support_singleton
private theorem vps_card : vps.endpoint.outputCard = 2 := b.outputEquiv.outputCard_eq
private theorem vps_length : vps.path.length = 1 := by
  have hg := seedVps_card_growth vps.path vps.homogeneous
  have hs : 1 + vps.path.length = 1 + 1 :=
    (congrArg (fun n => n + vps.path.length) pps_card).symm.trans (hg.symm.trans vps_card)
  exact Nat.add_left_cancel hs
private theorem vps_tags : vps.path.tags = [.vps] := by
  have ht := List.eq_replicate_length.mpr vps.homogeneous
  simpa only [OperationPath.tags_length,vps_length,List.replicate_succ,List.replicate_zero]
    using ht
example : b.path.tags = [.vps] := by rw [seedBridge_tags,pps_tags,vps_tags]; rfl
example : IsSingularChannel pps.endpoint.channel :=
  pps.isSingular (ActiveFiniteChannel.allOnes_isSingular _)
example : IsSingularChannel vps.endpoint.channel :=
  vps.isSingular (pps.isSingular (ActiveFiniteChannel.allOnes_isSingular _))
example (x : Fin 3) : pps.endpoint.channel x (pps.labels sw) = 1 := by
  rw [pps.coordinates]
  simp [sw,q]
example : columnValue pps.endpoint.channel
    (pps.isSingular (ActiveFiniteChannel.allOnes_isSingular _))
      (pps.endpoint.activeEquiv (pps.labels sw)) = 1 := by
  rw [seedPps_value]
  change q ((pps.labels.symm (pps.labels sw)).val) = 1
  rw [Equiv.symm_apply_apply]
  simp [sw,q]

private def part0 : (seedPartition q (pps.labels sw)).parts :=
  seedPartitionEquiv q (pps.labels sw) ⟨0,by rw [Equiv.symm_apply_apply]; exact ⟨0,rfl⟩⟩
private def part1 : (seedPartition q (pps.labels sw)).parts :=
  seedPartitionEquiv q (pps.labels sw) ⟨1,by rw [Equiv.symm_apply_apply]; exact ⟨2,rfl⟩⟩
private theorem part0_val : part0.val = {0,1} := by
  rw [part0,seedPartitionEquiv_apply_val]
  ext x
  simp only [decoderBlocks,Finset.mem_filter,Finset.mem_univ,true_and,Equiv.symm_apply_apply]
  fin_cases x <;> simp [sw,w,
    Fin.ext_iff,-Fin.val_eq_zero_iff,Matrix.cons_val_two]
private theorem part1_val : part1.val = {2} := by
  rw [part1,seedPartitionEquiv_apply_val]
  ext x
  simp only [decoderBlocks,Finset.mem_filter,Finset.mem_univ,true_and,Equiv.symm_apply_apply]
  fin_cases x <;> simp [sw,w,
    Fin.ext_iff,-Fin.val_eq_zero_iff,Matrix.cons_val_two]
example : part0.val.Nonempty ∧ part1.val.Nonempty ∧ Disjoint part0.val part1.val ∧
    part0.val ∪ part1.val = Finset.univ := by
  rw [part0_val,part1_val]
  simp [Finset.ext_iff,Fin.forall_fin_succ,Finset.disjoint_left,Fin.ext_iff,
    -Fin.val_eq_zero_iff]
example (x : Fin 3) :
    vps.endpoint.channel x (vps.labels ⟨pps.labels sw,part0⟩) =
      if x ∈ ({0,1} : Finset (Fin 3)) then 1 else 0 := by
  rw [vps.coordinates,part0_val,pps.coordinates]
  simp [sw,q]
private theorem target_coordinates (x : Fin 3) (y : Fin 2) :
    (commonEndpoint q enumeration).channel x y = source.channel x y := by
  have ht := originalTarget_coordinates source q V factorization enumeration x
    ⟨y,w,by simp [V,q]⟩
  change (commonEndpoint q enumeration).channel x y = V y w * source.channel x y at ht
  simpa [V,q] using ht
example (x : Fin 3) (j : Fin vps.endpoint.outputCard) :
    vps.endpoint.channel x j = source.channel x (b.outputEquiv.equiv j) :=
  (b.outputEquiv.apply x j).symm.trans (target_coordinates x _)
example (x : Fin 3) : (a.endpoint.channel x).map a.outputEquiv.equiv =
    (b.endpoint.channel x).map b.outputEquiv.equiv :=
  (a.outputEquiv.map_eq x).trans (b.outputEquiv.map_eq x).symm
end PureSplit

namespace Repeated
private abbrev pps := seedPps q
private abbrev vps := seedVps q
private abbrev b := seedBridge q enumeration
private abbrev a := originalBridge source singular q V factorization enumeration
private theorem pps_card : pps.endpoint.outputCard = 3 := by
  rw [pps.outputCard]
  simpa using Fintype.card_congr supportEnumeration
private theorem pps_length : pps.path.length = 2 := by
  have hg := originalPps_card_growth pps.path pps.homogeneous
  change pps.endpoint.outputCard = 1 + pps.path.length at hg
  rw [pps_card] at hg
  omega
private theorem pps_tags : pps.path.tags = [.pps,.pps] := by
  have ht := List.eq_replicate_length.mpr pps.homogeneous
  simpa only [OperationPath.tags_length,pps_length,List.replicate_succ,List.replicate_zero]
    using ht
private theorem vps_card : vps.endpoint.outputCard = 4 := b.outputEquiv.outputCard_eq
private theorem vps_length : vps.path.length = 1 := by
  have hg := seedVps_card_growth vps.path vps.homogeneous
  have hs : 3 + vps.path.length = 3 + 1 :=
    (congrArg (fun n => n + vps.path.length) pps_card).symm.trans (hg.symm.trans vps_card)
  exact Nat.add_left_cancel hs
private theorem vps_tags : vps.path.tags = [.vps] := by
  have ht := List.eq_replicate_length.mpr vps.homogeneous
  simpa only [OperationPath.tags_length,vps_length,List.replicate_succ,List.replicate_zero]
    using ht
example : b.path.tags = [.pps,.pps,.vps] := by
  rw [seedBridge_tags,pps_tags,vps_tags]
  rfl
example (x : Fin 3) (j : Fin pps.endpoint.outputCard) :
    pps.endpoint.channel x j = q (pps.labels.symm j).val := seedPps_apply q x j
example (j : Fin pps.endpoint.outputCard) :
    (columnPattern pps.endpoint.channel (pps.endpoint.activeEquiv j)).val = Finset.univ :=
  seedPps_pattern q j

private def partU : (seedPartition q (pps.labels su)).parts :=
  seedPartitionEquiv q (pps.labels su) ⟨0,by rw [Equiv.symm_apply_apply]; exact ⟨0,rfl⟩⟩
private def partZ : (seedPartition q (pps.labels sz)).parts :=
  seedPartitionEquiv q (pps.labels sz) ⟨3,by rw [Equiv.symm_apply_apply]; exact ⟨0,rfl⟩⟩
private def partV1 : (seedPartition q (pps.labels sv)).parts :=
  seedPartitionEquiv q (pps.labels sv) ⟨1,by rw [Equiv.symm_apply_apply]; exact ⟨0,rfl⟩⟩
private def partV2 : (seedPartition q (pps.labels sv)).parts :=
  seedPartitionEquiv q (pps.labels sv) ⟨2,by rw [Equiv.symm_apply_apply]; exact ⟨2,rfl⟩⟩
private theorem partU_val : partU.val = Finset.univ := by
  rw [partU,seedPartitionEquiv_apply_val]
  ext x
  simp only [decoderBlocks,Finset.mem_filter,Finset.mem_univ,true_and,Equiv.symm_apply_apply]
  simp [su,u]
private theorem partZ_val : partZ.val = Finset.univ := by
  rw [partZ,seedPartitionEquiv_apply_val]
  ext x
  simp only [decoderBlocks,Finset.mem_filter,Finset.mem_univ,true_and,Equiv.symm_apply_apply]
  simp [sz,z]
private theorem partV1_val : partV1.val = {0,1} := by
  rw [partV1,seedPartitionEquiv_apply_val]
  ext x
  simp only [decoderBlocks,Finset.mem_filter,Finset.mem_univ,true_and,Equiv.symm_apply_apply]
  fin_cases x <;> simp [sv,v,
    Fin.ext_iff,-Fin.val_eq_zero_iff,Matrix.cons_val_two]
private theorem partV2_val : partV2.val = {2} := by
  rw [partV2,seedPartitionEquiv_apply_val]
  ext x
  simp only [decoderBlocks,Finset.mem_filter,Finset.mem_univ,true_and,Equiv.symm_apply_apply]
  fin_cases x <;> simp [sv,v,
    Fin.ext_iff,-Fin.val_eq_zero_iff,Matrix.cons_val_two]
example : partU.val = partZ.val := partU_val.trans partZ_val.symm
example : (partV1.val.card = 2) ∧ (partV2.val.card = 1) ∧
    Disjoint partV1.val partV2.val ∧ partV1.val ∪ partV2.val = Finset.univ := by
  rw [partV1_val,partV2_val]
  simp [Finset.ext_iff,Fin.forall_fin_succ,Finset.disjoint_left,Fin.ext_iff,
    -Fin.val_eq_zero_iff]
private def outU := vps.labels ⟨pps.labels su,partU⟩
private def outZ := vps.labels ⟨pps.labels sz,partZ⟩
private theorem outputs_distinct : outU ≠ outZ := by
  intro h
  have hj := congrArg Sigma.fst (vps.labels.injective h)
  exact uz (congrArg Subtype.val (pps.labels.injective hj))
private theorem outU_mass (x : Fin 3) : vps.endpoint.channel x outU = 1/4 := by
  rw [outU,vps.coordinates,partU_val]
  simp only [Finset.mem_univ,if_true]
  exact (pps.coordinates x su).trans q_u
private theorem outZ_mass (x : Fin 3) : vps.endpoint.channel x outZ = 1/4 := by
  rw [outZ,vps.coordinates,partZ_val]
  simp only [Finset.mem_univ,if_true]
  exact (pps.coordinates x sz).trans q_z
private theorem outU_pattern :
    (columnPattern vps.endpoint.channel (vps.endpoint.activeEquiv outU)).val =
      Finset.univ :=
  (seedVps_pattern q ⟨pps.labels su,partU⟩).trans partU_val
private theorem outZ_pattern :
    (columnPattern vps.endpoint.channel (vps.endpoint.activeEquiv outZ)).val =
      Finset.univ :=
  (seedVps_pattern q ⟨pps.labels sz,partZ⟩).trans partZ_val
example : outU ≠ outZ ∧
    (columnPattern vps.endpoint.channel (vps.endpoint.activeEquiv outU)).val =
      (columnPattern vps.endpoint.channel (vps.endpoint.activeEquiv outZ)).val :=
  ⟨outputs_distinct,outU_pattern.trans outZ_pattern.symm⟩
example : (seedVpsLabels q ⟨pps.labels su,partU⟩).val = (0,u) := by
  rw [seedVpsLabels_apply_val]
  simp only [partU,Equiv.symm_apply_apply]
  rfl
example : (seedVpsLabels q ⟨pps.labels sz,partZ⟩).val = (3,z) := by
  rw [seedVpsLabels_apply_val]
  simp only [partZ,Equiv.symm_apply_apply]
  rfl
example : (seedVpsLabels q ⟨pps.labels sv,partV2⟩).val = (2,v) := by
  rw [seedVpsLabels_apply_val]
  simp only [partV2,Equiv.symm_apply_apply]
  rfl
private theorem outU_forward : b.outputEquiv.equiv outU = (0 : Fin 4) := by
  rw [outU,seedBridge_label]
  change ((seedPartitionEquiv q (pps.labels su)).symm partU).val = 0
  simp [partU]
private theorem outZ_forward : b.outputEquiv.equiv outZ = (3 : Fin 4) := by
  rw [outZ,seedBridge_label]
  change ((seedPartitionEquiv q (pps.labels sz)).symm partZ).val = 3
  simp [partZ]
example : b.outputEquiv.equiv.symm (0 : Fin 4) = outU :=
  (congrArg b.outputEquiv.equiv.symm outU_forward).symm.trans
    (b.outputEquiv.equiv.symm_apply_apply outU)
private theorem target_coordinates (x : Fin 3) (y : Fin 4) :
    (commonEndpoint q enumeration).channel x y = source.channel x y := by
  have ht := originalTarget_coordinates source q V factorization enumeration x
    ⟨y,posteriorVector y,by simp [V]⟩
  change (commonEndpoint q enumeration).channel x y =
    V y (posteriorVector y) * source.channel x y at ht
  simpa [V] using ht
example (x : Fin 3) (j : Fin vps.endpoint.outputCard) :
    vps.endpoint.channel x j = (row x (b.outputEquiv.equiv j) : ENNReal) :=
  (b.outputEquiv.apply x j).symm.trans (target_coordinates x _)
example (x : Fin 3) : (a.endpoint.channel x).map a.outputEquiv.equiv =
    (b.endpoint.channel x).map b.outputEquiv.equiv :=
  (a.outputEquiv.map_eq x).trans (b.outputEquiv.map_eq x).symm
example : a.path.length = 0 :=
  originalPps_length_singleton source singular V (fun _ => purePositive_singleton _)
example (x : Fin 3) :
    ((commonEndpoint q enumeration).channel x).map b.outputEquiv.equiv.symm =
      b.endpoint.channel x := b.outputEquiv.symm.map_eq x
example (x : Fin 3) : (vps.endpoint.channel x).map
    (fun j => (enumeration.symm (b.outputEquiv.equiv j)).val) = auxiliaryChannel q x :=
  seedBridge_recover q enumeration x
end Repeated

namespace Singleton
private abbrev pps := seedPps q
private abbrev vps := seedVps q
private abbrev b := seedBridge q enumeration
private abbrev a := originalBridge source (ActiveFiniteChannel.allOnes_isSingular _)
  q V factorization enumeration
example : pps.path.length = 0 := seedPps_length_singleton q inferInstance
private theorem pps_tags : pps.path.tags = [] := seedPps_tags_singleton q inferInstance
example : vps.path.length = 0 := seedVps_length_singleton q (fun _ => inferInstance)
private theorem vps_tags : vps.path.tags = [] :=
  seedVps_tags_singleton q (fun _ => inferInstance)
example : b.path.tags = [] := by rw [seedBridge_tags,pps_tags,vps_tags]; rfl
example : a.path.length = 0 :=
  originalPps_length_singleton source (ActiveFiniteChannel.allOnes_isSingular _)
    V (fun _ => purePositive_singleton _)
example : a.path.tags = [] :=
  originalPps_tags_singleton source (ActiveFiniteChannel.allOnes_isSingular _)
    V (fun _ => purePositive_singleton _)
example (x : Fin 1) : (a.endpoint.channel x).map a.outputEquiv.equiv =
    (b.endpoint.channel x).map b.outputEquiv.equiv :=
  (a.outputEquiv.map_eq x).trans (b.outputEquiv.map_eq x).symm
example (x : Fin 1) :
    ((commonEndpoint q enumeration).channel x).map b.outputEquiv.equiv.symm =
      b.endpoint.channel x := b.outputEquiv.symm.map_eq x
end Singleton
end RegressionS04
end
end PerfectFunctionalRepresentations.MatrixOperations.CanonicalConstruction

/-! ## The two witnessed compositions in Theorem 1 -/

namespace PerfectFunctionalRepresentations.MatrixOperations.CanonicalConstruction
noncomputable section
attribute [local instance] Classical.propDecidable
universe u
variable {alpha : Type u} [Fintype alpha] [Nonempty alpha]
variable (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
  (q : PMF (alpha → Fin S.outputCard))
  (V : Fin S.outputCard → PMF (alpha → Fin S.outputCard))
  (hV : ∀ x, auxiliaryChannel q x = PMF.channelJoint (S.channel x) V)
  {m : Nat} (eA : activeOutputs (auxiliaryChannel q) ≃ Fin m)

private def canonicalToAllOnes : Cascade S (ActiveFiniteChannel.allOnes alpha) :=
  (originalBridge S hS q V hV eA).comp (seedBridge q eA).reverse

private def canonicalFromAllOnes : Cascade (ActiveFiniteChannel.allOnes alpha) S :=
  (seedBridge q eA).comp (originalBridge S hS q V hV eA).reverse

private theorem originalBridge_word :
    (originalBridge S hS q V hV eA).path.tags =
      List.replicate (originalPps S hS V).path.length .pps := by
  exact (List.eq_replicate_length.mpr (originalPps S hS V).homogeneous).trans
    (congrArg (fun n => List.replicate n OperationKind.pps)
      (OperationPath.tags_length (originalPps S hS V).path))

private theorem originalBridge_reverse_homogeneous :
    (originalBridge S hS q V hV eA).reverse.path.Homogeneous .ppm := by
  change (originalBridge S hS q V hV eA).reverse.path.Allowed (· = .ppm)
  apply (Cascade.reverse_allowed _ (· = .ppm)).mpr
  intro k hk
  rw [originalBridge_homogeneous S hS q V hV eA k hk]
  rfl

-- Retain the selected seed stages and the actual reversed original bridge.
-- Transport aligns that reversal with the concrete VPS endpoint.
private def canonicalNormalForm : NormalForm (ActiveFiniteChannel.allOnes alpha) S :=
  let a := originalBridge S hS q V hV eA
  let b := seedBridge q eA
  let t := a.reverse.path.transport b.outputEquiv.symm
  { ppEndpoint := (seedPps q).endpoint
    vpEndpoint := (seedVps q).endpoint
    pmEndpoint := t.endpoint
    pp := (seedPps q).path
    vp := (seedVps q).path
    pm := t.path
    pp_homogeneous := (seedPps q).homogeneous
    vp_homogeneous := (seedVps q).homogeneous
    pm_homogeneous := (OperationPath.transport_homogeneous _ _ _).mpr
      (originalBridge_reverse_homogeneous S hS q V hV eA)
    outputEquiv := t.outputEquiv.trans a.reverse.outputEquiv }

-- This packages exactly b.comp a.reverse, including its final comparison.
private theorem canonicalNormalForm_toCascade :
    (canonicalNormalForm S hS q V hV eA).toCascade =
      canonicalFromAllOnes S hS q V hV eA := rfl

private theorem canonicalFromAllOnes_word :
    (canonicalFromAllOnes S hS q V hV eA).path.tags =
      (List.replicate (seedPps q).path.length .pps ++
        List.replicate (seedVps q).path.length .vps) ++
          List.replicate (originalPps S hS V).path.length .ppm := by
  rw [canonicalFromAllOnes,Cascade.tags_comp,Cascade.tags_reverse,
    seedBridge_word,originalBridge_word,List.reverse_replicate,List.map_replicate]
  rfl

private theorem canonicalToAllOnes_word :
    (canonicalToAllOnes S hS q V hV eA).path.tags =
      List.replicate (originalPps S hS V).path.length .pps ++
        (List.replicate (seedVps q).path.length .vpm ++
          List.replicate (seedPps q).path.length .ppm) := by
  rw [canonicalToAllOnes,Cascade.tags_comp,Cascade.tags_reverse,
    originalBridge_word,seedBridge_word,List.reverse_append,List.map_append]
  simp only [List.reverse_replicate,List.map_replicate,OperationKind.reverse]

private theorem canonicalFromAllOnes_normalizing :
    (canonicalFromAllOnes S hS q V hV eA).path.Normalizing :=
  (canonicalNormalForm S hS q V hV eA).toCascade_normalizing

private theorem canonicalToAllOnes_reducing :
    (canonicalToAllOnes S hS q V hV eA).path.Reducing := by
  intro k hk
  rw [canonicalToAllOnes_word] at hk
  simp only [List.mem_append,List.mem_replicate] at hk
  rcases hk with ⟨_,rfl⟩ | ⟨_,rfl⟩ | ⟨_,rfl⟩ <;> simp

-- Composition keeps the transport comparison followed by the directed
-- comparison of the actual reversed cascade. Its inverse uses the reverse order.
private theorem canonicalFromAllOnes_outputEquiv :
    (canonicalFromAllOnes S hS q V hV eA).outputEquiv =
      ((originalBridge S hS q V hV eA).reverse.path.transport
        (seedBridge q eA).outputEquiv.symm).outputEquiv.trans
          (originalBridge S hS q V hV eA).reverse.outputEquiv := rfl

private theorem canonicalToAllOnes_outputEquiv :
    (canonicalToAllOnes S hS q V hV eA).outputEquiv =
      ((seedBridge q eA).reverse.path.transport
        (originalBridge S hS q V hV eA).outputEquiv.symm).outputEquiv.trans
          (seedBridge q eA).reverse.outputEquiv := rfl

private theorem canonicalFromAllOnes_equiv_symm (y : Fin S.outputCard) :
    (canonicalFromAllOnes S hS q V hV eA).outputEquiv.equiv.symm y =
      ((originalBridge S hS q V hV eA).reverse.path.transport
        (seedBridge q eA).outputEquiv.symm).outputEquiv.equiv.symm
          ((originalBridge S hS q V hV eA).reverse.outputEquiv.equiv.symm y) := rfl

private theorem canonicalToAllOnes_equiv_symm (y : Fin 1) :
    (canonicalToAllOnes S hS q V hV eA).outputEquiv.equiv.symm y =
      ((seedBridge q eA).reverse.path.transport
        (originalBridge S hS q V hV eA).outputEquiv.symm).outputEquiv.equiv.symm
          ((seedBridge q eA).reverse.outputEquiv.equiv.symm y) := rfl

private theorem canonicalFromAllOnes_map (x : alpha) :
    ((canonicalFromAllOnes S hS q V hV eA).endpoint.channel x).map
      (canonicalFromAllOnes S hS q V hV eA).outputEquiv.equiv = S.channel x :=
  (canonicalFromAllOnes S hS q V hV eA).outputEquiv.map_eq x

private theorem canonicalFromAllOnes_map_symm (x : alpha) :
    (S.channel x).map (canonicalFromAllOnes S hS q V hV eA).outputEquiv.equiv.symm =
      (canonicalFromAllOnes S hS q V hV eA).endpoint.channel x :=
  (canonicalFromAllOnes S hS q V hV eA).outputEquiv.symm.map_eq x

private theorem canonicalToAllOnes_map (x : alpha) :
    ((canonicalToAllOnes S hS q V hV eA).endpoint.channel x).map
      (canonicalToAllOnes S hS q V hV eA).outputEquiv.equiv =
        (ActiveFiniteChannel.allOnes alpha).channel x :=
  (canonicalToAllOnes S hS q V hV eA).outputEquiv.map_eq x

private theorem canonicalToAllOnes_map_symm (x : alpha) :
    ((ActiveFiniteChannel.allOnes alpha).channel x).map
      (canonicalToAllOnes S hS q V hV eA).outputEquiv.equiv.symm =
        (canonicalToAllOnes S hS q V hV eA).endpoint.channel x :=
  (canonicalToAllOnes S hS q V hV eA).outputEquiv.symm.map_eq x

end
end PerfectFunctionalRepresentations.MatrixOperations.CanonicalConstruction

namespace PerfectFunctionalRepresentations.MatrixOperations
noncomputable section
open CanonicalConstruction
universe u
variable {alpha : Type u} [Finite alpha] [Nonempty alpha]

/-- Theorem 1: intrinsic perfect representability is equivalent to a reduction
to the all-ones channel using PPS, VPM and PPM operations. -/
theorem isPerfectlyRepresentable_iff_toAllOnes (S : ActiveFiniteChannel alpha) :
    IsPerfectlyRepresentableChannel S.channel ↔ ToAllOnes S := by
  constructor
  · intro hP
    classical
    let := Fintype.ofFinite alpha
    have hS := hP.isSingular
    obtain ⟨q,V,hV⟩ := hP
    let eA := Fintype.equivFin (activeOutputs (auxiliaryChannel q))
    exact ⟨canonicalToAllOnes S hS q V hV eA,
      canonicalToAllOnes_reducing S hS q V hV eA⟩
  · exact ToAllOnes.isPerfectlyRepresentable

/-- Theorem 1 in the constructive direction: the all-ones channel reaches
exactly the intrinsically perfectly representable active channels. -/
theorem isPerfectlyRepresentable_iff_fromAllOnes (S : ActiveFiniteChannel alpha) :
    IsPerfectlyRepresentableChannel S.channel ↔ FromAllOnes S := by
  constructor
  · intro hP
    classical
    let := Fintype.ofFinite alpha
    have hS := hP.isSingular
    obtain ⟨q,V,hV⟩ := hP
    let eA := Fintype.equivFin (activeOutputs (auxiliaryChannel q))
    exact ⟨canonicalFromAllOnes S hS q V hV eA,
      canonicalFromAllOnes_normalizing S hS q V hV eA⟩
  · exact FromAllOnes.isPerfectlyRepresentable

end
end PerfectFunctionalRepresentations.MatrixOperations

/-! ## R12: actual composites, empty stages and directed inverse maps -/

namespace PerfectFunctionalRepresentations.MatrixOperations.CanonicalConstruction
noncomputable section
attribute [local instance] Classical.propDecidable
attribute [local instance] RegressionS04.fixtureDecidableEqFin3

namespace RegressionS02
private abbrev s05Seed := seedBridge q s03Enumeration
private abbrev s05From :=
  canonicalFromAllOnes s03Source s03Source_singular q V factorization s03Enumeration
private abbrev s05To :=
  canonicalToAllOnes s03Source s03Source_singular q V factorization s03Enumeration
private abbrev s05NormalForm :=
  canonicalNormalForm s03Source s03Source_singular q V factorization s03Enumeration

private theorem s05SeedPps_card : (seedPps q).endpoint.outputCard = 2 := by
  let e : q.support ≃ {w : W // 0 < V 0 w} := Equiv.subtypeEquivRight (fun w => by
    change q w ≠ 0 ↔ 0 < V 0 w
    simp [V,pos_iff_ne_zero])
  rw [(seedPps q).outputCard]
  simpa using Fintype.card_congr (e.trans s03Support0)

private theorem s05SeedPps_length : (seedPps q).path.length = 1 := by
  have hg := originalPps_card_growth (seedPps q).path (seedPps q).homogeneous
  change (seedPps q).endpoint.outputCard = 1 + (seedPps q).path.length at hg
  rw [s05SeedPps_card] at hg
  omega

private theorem s05SeedVps_length : (seedVps q).path.length = 2 := by
  have hv : (seedVps q).endpoint.outputCard = 4 := s05Seed.outputEquiv.outputCard_eq
  have hg := seedVps_card_growth (seedVps q).path (seedVps q).homogeneous
  have hs : 2 + (seedVps q).path.length = 2 + 2 :=
    (congrArg (fun n => n + (seedVps q).path.length) s05SeedPps_card).symm.trans
      (hg.symm.trans hv)
  exact Nat.add_left_cancel hs

example : s05From = s05Seed.comp s03Bridge.reverse := rfl
example : s05To = s03Bridge.comp s05Seed.reverse := rfl
example : s05NormalForm.toCascade = s05From :=
  canonicalNormalForm_toCascade s03Source s03Source_singular q V factorization s03Enumeration
example : s05From.path.tags = [.pps,.vps,.vps,.ppm] := by
  rw [canonicalFromAllOnes_word,s05SeedPps_length,s05SeedVps_length,s03Pps_length]
  rfl
example : s05To.path.tags = [.pps,.vpm,.vpm,.ppm] := by
  rw [canonicalToAllOnes_word,s05SeedPps_length,s05SeedVps_length,s03Pps_length]
  rfl
example : s05From.path.Normalizing :=
  canonicalFromAllOnes_normalizing s03Source s03Source_singular q V factorization s03Enumeration
example : s05To.path.Reducing :=
  canonicalToAllOnes_reducing s03Source s03Source_singular q V factorization s03Enumeration
example : s05NormalForm.pp = (seedPps q).path := rfl
example : s05NormalForm.vp = (seedVps q).path := rfl
example : s05NormalForm.pm =
    (s03Bridge.reverse.path.transport s05Seed.outputEquiv.symm).path := rfl

-- This is the actual first comparison used by reversal. The supplied cycle
-- sends 0 to 1, while its inverse sends 0 to 2.
example : s03Bridge.reverse =
    (Cascade.ofOutputEquiv s03Bridge.outputEquiv.symm).comp s03Bridge.path.reverse := rfl
example : (Cascade.ofOutputEquiv s03Bridge.outputEquiv.symm).outputEquiv.equiv (0 : Fin 4) =
    s03Pps.labels (s03LabelVector 2) := s03Inverse 2
example : (Cascade.ofOutputEquiv s03Bridge.outputEquiv.symm).outputEquiv.equiv (1 : Fin 4) =
    s03Pps.labels (s03LabelVector 0) := s03Inverse 0
example : s03Cycle 0 = 1 ∧ s03Cycle.symm 0 = 2 := ⟨rfl,rfl⟩
example (y : Fin 3) : s05From.outputEquiv.equiv.symm y =
    (s03Bridge.reverse.path.transport s05Seed.outputEquiv.symm).outputEquiv.equiv.symm
      (s03Bridge.reverse.outputEquiv.equiv.symm y) :=
  canonicalFromAllOnes_equiv_symm s03Source s03Source_singular q V factorization s03Enumeration y
example (y : Fin 1) : s05To.outputEquiv.equiv.symm y =
    (s05Seed.reverse.path.transport s03Bridge.outputEquiv.symm).outputEquiv.equiv.symm
      (s05Seed.reverse.outputEquiv.equiv.symm y) :=
  canonicalToAllOnes_equiv_symm s03Source s03Source_singular q V factorization s03Enumeration y
example (x y : Fin 3) :
    s05From.endpoint.channel x (s05From.outputEquiv.equiv.symm y) = s03Source.channel x y :=
  s05From.outputEquiv.apply_symm x y
example (x : Fin 3) :
    s05To.endpoint.channel x (s05To.outputEquiv.equiv.symm (0 : Fin 1)) = 1 :=
  (s05To.outputEquiv.apply_symm x (0 : Fin 1)).trans
    (ActiveFiniteChannel.allOnes_apply (Fin 3) x (0 : Fin 1))
example (x : Fin 3) : (s05From.endpoint.channel x).map s05From.outputEquiv.equiv =
    s03Source.channel x :=
  canonicalFromAllOnes_map s03Source s03Source_singular q V factorization s03Enumeration x
example (x : Fin 3) : (s03Source.channel x).map s05From.outputEquiv.equiv.symm =
    s05From.endpoint.channel x :=
  canonicalFromAllOnes_map_symm s03Source s03Source_singular q V factorization s03Enumeration x
example (x : Fin 3) : (s05To.endpoint.channel x).map s05To.outputEquiv.equiv =
    (ActiveFiniteChannel.allOnes (Fin 3)).channel x :=
  canonicalToAllOnes_map s03Source s03Source_singular q V factorization s03Enumeration x
example (x : Fin 3) : ((ActiveFiniteChannel.allOnes (Fin 3)).channel x).map
    s05To.outputEquiv.equiv.symm = s05To.endpoint.channel x :=
  canonicalToAllOnes_map_symm s03Source s03Source_singular q V factorization s03Enumeration x
end RegressionS02

namespace RegressionS04.PureSplit
private theorem s05Original_tags : a.path.tags = [] :=
  originalPps_tags_singleton source singular V (fun _ => purePositive_singleton _)
example : (b.comp a.reverse).path.tags = [.vps] := by
  rw [Cascade.tags_comp,Cascade.tags_reverse,s05Original_tags,seedBridge_tags,pps_tags,vps_tags]
  rfl
example : (a.comp b.reverse).path.tags = [.vpm] := by
  rw [Cascade.tags_comp,Cascade.tags_reverse,s05Original_tags,seedBridge_tags,pps_tags,vps_tags]
  rfl
example : (canonicalNormalForm source singular q V factorization enumeration).toCascade =
    b.comp a.reverse := rfl
end RegressionS04.PureSplit

namespace RegressionS04.Singleton
private theorem s05Original_tags : a.path.tags = [] :=
  originalPps_tags_singleton source (ActiveFiniteChannel.allOnes_isSingular _)
    V (fun _ => purePositive_singleton _)
example : (b.comp a.reverse).path.tags = [] := by
  erw [Cascade.tags_comp,Cascade.tags_reverse,s05Original_tags,seedBridge_tags,pps_tags,vps_tags]
  rfl
example : (a.comp b.reverse).path.tags = [] := by
  erw [Cascade.tags_comp,Cascade.tags_reverse,s05Original_tags,seedBridge_tags,pps_tags,vps_tags]
  rfl
example : (b.comp a.reverse).path.length = 0 := by
  have hp := seedPps_length_singleton q (by infer_instance)
  have hv := seedVps_length_singleton q (fun _ => inferInstance)
  have ha := originalPps_length_singleton source (ActiveFiniteChannel.allOnes_isSingular _)
    V (fun _ => purePositive_singleton _)
  erw [Cascade.length_comp,Cascade.length_reverse,seedBridge_path,OperationPath.length_append]
  change (seedPps q).path.length + (seedVps q).path.length +
    (originalPps source (ActiveFiniteChannel.allOnes_isSingular _) V).path.length = 0
  rw [hp,hv,ha]
example (x : Fin 1) : ((b.comp a.reverse).endpoint.channel x).map
    (b.comp a.reverse).outputEquiv.equiv = source.channel x :=
  (b.comp a.reverse).outputEquiv.map_eq x
example (x : Fin 1) : (source.channel x).map (b.comp a.reverse).outputEquiv.equiv.symm =
    (b.comp a.reverse).endpoint.channel x := (b.comp a.reverse).outputEquiv.symm.map_eq x
end RegressionS04.Singleton

end
end PerfectFunctionalRepresentations.MatrixOperations.CanonicalConstruction
