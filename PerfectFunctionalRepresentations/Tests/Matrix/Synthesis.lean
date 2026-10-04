import PerfectFunctionalRepresentations.Matrix.MultiwayOperations
import PerfectFunctionalRepresentations.Matrix.OperationFactorization
import PerfectFunctionalRepresentations.Matrix.Reachability
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum

/-!
# Integrated finite synthesis consumers

C10 R17 composes the public ENNReal PPS, supplied labelled VPS and prescribed
PPM constructors. Independent matrices specify every compared endpoint.
The actual C08 normalization result is checked against the final matrix.
-/

namespace PerfectFunctionalRepresentations.MatrixOperations.SynthesisTests

open ActiveFiniteChannel
open scoped BigOperators ENNReal
noncomputable section
attribute [local instance] operationQuiver

private theorem split_cardinality {S T : ActiveFiniteChannel (Fin 3)}
    (p : OperationPath S T) (hp : p.Allowed (fun k => k = .pps ∨ k = .vps)) :
    T.outputCard = S.outputCard + p.length := by
  induction p with
  | nil => rfl
  | @cons T U p e ih =>
      have h := (OperationPath.allowed_snoc _ p e).mp hp
      cases e with
      | pps hT l t ht0 ht1 =>
          change T.outputCard + 1 = S.outputCard + (p.length + 1)
          rw [ih h.1, Nat.add_assoc]
          rfl
      | vps hT l mask hl hr =>
          change T.outputCard + 1 = S.outputCard + (p.length + 1)
          rw [ih h.1, Nat.add_assoc]
          rfl
      | ppm hT a b hab hs => simp [OperationStep.kind] at h
      | vpm hT a b hab hv hd => simp [OperationStep.kind] at h

private def rawWeights : Fin 3 → NNReal := ![1 / 3, 0, 2 / 3]

private def weights (i : Fin 3) : ENNReal := rawWeights i

private theorem weights_sum : ∑ i, weights i = 1 := by
  have h : ∑ i, rawWeights i = 1 := by
    norm_num [rawWeights, Fin.sum_univ_succ]
  change ∑ i, (rawWeights i : ENNReal) = 1
  exact_mod_cast h

private theorem weights_pos (i : Fin 3) : 0 < weights i ↔ i = 0 ∨ i = 2 := by
  fin_cases i <;>
    norm_num [weights, rawWeights, Fin.ext_iff, -Fin.val_eq_zero_iff]

private def ppWeights : Fin 2 → NNReal := ![1 / 3, 2 / 3]

private theorem ppWeights_sum : ∑ i, ppWeights i = 1 := by
  norm_num [ppWeights, Fin.sum_univ_succ]

private abbrev ppTarget : ActiveFiniteChannel (Fin 3) where
  outputCard := 2
  outputCard_pos := by decide
  channel _ := PMF.ofFintype (fun j => (ppWeights j : ENNReal))
    (by exact_mod_cast ppWeights_sum)
  output_active j := by
    fin_cases j <;> exact ⟨0, by norm_num [ppWeights]⟩

private theorem ppTarget_singular : IsSingularChannel ppTarget.channel := by
  intro x z j _ _
  rfl

private def positiveLabels : {i // 0 < weights i} ≃ Fin 2 where
  toFun i := if i.val = 0 then 0 else 1
  invFun j := if j = 0 then ⟨0, (weights_pos 0).mpr (Or.inl rfl)⟩
    else ⟨2, (weights_pos 2).mpr (Or.inr rfl)⟩
  left_inv i := by
    rcases i with ⟨i, hi⟩
    rcases (weights_pos i).mp hi with rfl | rfl <;> rfl
  right_inv j := by fin_cases j <;> rfl

private def ppTargetLabels :
    {i // 0 < weights i} ⊕ {j : Fin 1 // j ≠ 0} ≃ Fin 2 where
  toFun := Sum.elim positiveLabels (fun j => (j.property (Subsingleton.elim _ _)).elim)
  invFun j := .inl (positiveLabels.symm j)
  left_inv p := by
    rcases p with i | j
    · exact congrArg Sum.inl (positiveLabels.symm_apply_apply i)
    · exact (j.property (Subsingleton.elim _ _)).elim
  right_inv j := positiveLabels.apply_symm_apply j

private theorem ppTarget_coordinates (x : Fin 3)
    (p : {i // 0 < weights i} ⊕ {j : Fin 1 // j ≠ 0}) :
    ppTarget.channel x (ppTargetLabels p) =
      Sum.elim (fun i => weights i.val * (allOnes (Fin 3)).channel x (0 : Fin 1))
        (fun j => (allOnes (Fin 3)).channel x j.val) p := by
  rcases p with ⟨i, hi⟩ | j
  · rcases (weights_pos i).mp hi with rfl | rfl
    · change (ppWeights 0 : ENNReal) = weights 0 * _
      rw [allOnes_apply, mul_one]
      rfl
    · change (ppWeights 1 : ENNReal) = weights 2 * _
      rw [allOnes_apply, mul_one]
      rfl
  · exact (j.property (Subsingleton.elim _ _)).elim

private abbrev pp := multiPpsOfENNReal (allOnes (Fin 3)) (allOnes_isSingular _)
  (0 : Fin 1) weights weights_sum

private def ppCascade : Cascade (allOnes (Fin 3)) ppTarget :=
  pp.cascade ppTargetLabels ppTarget_coordinates

private theorem pp_card : pp.endpoint.outputCard = 2 :=
  ppCascade.outputEquiv.outputCard_eq

private theorem pp_length : pp.path.length = 1 := by
  have h := split_cardinality pp.path (fun k hk => Or.inl (pp.homogeneous k hk))
  rw [pp_card] at h
  change 2 = 1 + pp.path.length at h
  omega

example (x : Fin 3) (i : {i // 0 < weights i}) :
    pp.endpoint.channel x (pp.labels (.inl i)) = weights i.val := by
  exact (pp.coordinates x (.inl i)).trans (by
    change weights i.val * (allOnes (Fin 3)).channel x (0 : Fin 1) = weights i.val
    rw [allOnes_apply, mul_one])

-- The original block labels intentionally put the singleton first.
private def blocks : Bool → Finset (Fin 3)
  | false => {1}
  | true => {0, 2}

private theorem blocks_nonempty (b : Bool) : (blocks b).Nonempty := by
  cases b <;> simp [blocks]

private theorem blocks_disjoint : Pairwise (fun a b => Disjoint (blocks a) (blocks b)) := by
  intro a b hab
  cases a <;> cases b
  · exact (hab rfl).elim
  · change Disjoint ({1} : Finset (Fin 3)) {0, 2}
    decide
  · change Disjoint ({0, 2} : Finset (Fin 3)) {1}
    decide
  · exact (hab rfl).elim

private theorem blocks_cover (x : Fin 3) : ∃ b, x ∈ blocks b := by
  revert x
  decide

private def leafLabels : (Σ _ : Fin 2, Bool) ≃ Fin 4 where
  toFun p := if p.1 = 0 then if p.2 then 1 else 2 else if p.2 then 3 else 0
  invFun j := (![⟨1, false⟩, ⟨0, true⟩, ⟨0, false⟩, ⟨1, true⟩] :
    Fin 4 → Σ _ : Fin 2, Bool) j
  left_inv p := by
    rcases p with ⟨j, b⟩
    fin_cases j <;> cases b <;> rfl
  right_inv j := by fin_cases j <;> rfl

private def vpWeights (x : Fin 3) : Fin 4 → NNReal :=
  if x = 1 then ![2 / 3, 0, 1 / 3, 0] else ![0, 1 / 3, 0, 2 / 3]

private theorem vpWeights_sum (x : Fin 3) : ∑ j, vpWeights x j = 1 := by
  fin_cases x <;>
    norm_num [vpWeights, Fin.sum_univ_succ, Fin.ext_iff, -Fin.val_eq_zero_iff]

private abbrev vpTarget : ActiveFiniteChannel (Fin 3) where
  outputCard := 4
  outputCard_pos := by decide
  channel x := PMF.ofFintype (fun j => (vpWeights x j : ENNReal))
    (by exact_mod_cast vpWeights_sum x)
  output_active j := by
    fin_cases j
    · exact ⟨1, by norm_num [vpWeights]⟩
    · exact ⟨0, by norm_num [vpWeights]⟩
    · exact ⟨1, by norm_num [vpWeights]⟩
    · exact ⟨0, by norm_num [vpWeights]⟩

private theorem vpTarget_singular : IsSingularChannel vpTarget.channel := by
  intro x z j hx hz
  fin_cases x <;> fin_cases z <;> fin_cases j <;>
    norm_num [vpTarget, vpWeights, Fin.ext_iff, -Fin.val_eq_zero_iff] at *

private def group : Fin 4 → Fin 3 := ![0, 1, 2, 1]

private theorem group_surjective : Function.Surjective group := by
  intro b
  fin_cases b
  · exact ⟨0, rfl⟩
  · exact ⟨1, rfl⟩
  · exact ⟨2, rfl⟩

private theorem group_support (i j : Fin 4) (hij : group i = group j) (x : Fin 3) :
    vpTarget.channel x i ≠ 0 ↔ vpTarget.channel x j ≠ 0 := by
  fin_cases i <;> fin_cases j <;> fin_cases x <;>
    norm_num [group, vpTarget, vpWeights, Fin.ext_iff, -Fin.val_eq_zero_iff] at *

private def cycle : Fin 3 ≃ Fin 3 where
  toFun := ![1, 2, 0]
  invFun := ![2, 0, 1]
  left_inv j := by fin_cases j <;> rfl
  right_inv j := by fin_cases j <;> rfl

private def finalWeights (x : Fin 3) : Fin 3 → NNReal :=
  if x = 1 then ![1 / 3, 2 / 3, 0] else ![0, 0, 1]

private theorem finalWeights_sum (x : Fin 3) : ∑ j, finalWeights x j = 1 := by
  fin_cases x <;>
    norm_num [finalWeights, Fin.sum_univ_succ, Fin.ext_iff, -Fin.val_eq_zero_iff]

private abbrev finalTarget : ActiveFiniteChannel (Fin 3) where
  outputCard := 3
  outputCard_pos := by decide
  channel x := PMF.ofFintype (fun j => (finalWeights x j : ENNReal))
    (by exact_mod_cast finalWeights_sum x)
  output_active j := by
    fin_cases j
    · exact ⟨1, by norm_num [finalWeights]⟩
    · exact ⟨1, by norm_num [finalWeights]⟩
    · exact ⟨0, by norm_num [finalWeights]⟩

attribute [local instance] Classical.propDecidable
local instance : DecidableEq (Fin 3) := fun a b => Classical.propDecidable (a = b)

private theorem blocks_pattern_cover (j : Fin 2) (x : Fin 3) :
    x ∈ (columnPattern ppTarget.channel (ppTarget.activeEquiv j)).val ↔
      ∃ b, x ∈ blocks b := by
  rw [mem_columnPattern]
  change ppTarget.channel x j ≠ 0 ↔ _
  have hs : ppTarget.channel x j ≠ 0 := by
    fin_cases j <;> norm_num [ppTarget, ppWeights]
  exact iff_of_true hs (blocks_cover x)

private def partitions (j : Fin 2) :
    Finpartition (columnPattern ppTarget.channel (ppTarget.activeEquiv j)).val :=
  partitionOfBlocks _ blocks blocks_nonempty blocks_disjoint (blocks_pattern_cover j)

private def blockLabels (j : Fin 2) : Bool ≃ (partitions j).parts :=
  partitionOfBlocksEquiv _ blocks blocks_nonempty blocks_disjoint (blocks_pattern_cover j)

private theorem blockLabels_val (j : Fin 2) (b : Bool) :
    (blockLabels j b).val = blocks b :=
  partitionOfBlocksEquiv_apply_val _ _ _ _ _ b

private def vpTargetLabels : (Σ j, (partitions j).parts) ≃ Fin 4 :=
  (Equiv.sigmaCongrRight blockLabels).symm.trans leafLabels

private theorem vpTarget_original_coordinates (x : Fin 3) (j : Fin 2) (b : Bool) :
    vpTarget.channel x (leafLabels ⟨j, b⟩) =
      if x ∈ blocks b then ppTarget.channel x j else 0 := by
  fin_cases x <;> fin_cases j <;> cases b <;>
    norm_num [vpTarget, vpWeights, leafLabels, blocks, ppTarget, ppWeights,
      Fin.ext_iff, -Fin.val_eq_zero_iff,
      Matrix.cons_val_two, Matrix.cons_val_three, Matrix.vecHead, Matrix.vecTail]

private theorem vpTarget_coordinates (x : Fin 3) (p : Σ j, (partitions j).parts) :
    vpTarget.channel x (vpTargetLabels p) =
      if x ∈ p.2.val then ppTarget.channel x p.1 else 0 := by
  rcases p with ⟨j, b⟩
  obtain ⟨i, rfl⟩ := (blockLabels j).surjective b
  rw [blockLabels_val]
  change vpTarget.channel x
    (leafLabels ((Equiv.sigmaCongrRight blockLabels).symm
      ((Equiv.sigmaCongrRight blockLabels) ⟨j, i⟩))) = _
  rw [Equiv.symm_apply_apply]
  exact vpTarget_original_coordinates x j i

private abbrev vp := multiVpsFamily ppTarget ppTarget_singular partitions

private def vpCascade : Cascade ppTarget vpTarget :=
  vp.cascade vpTargetLabels vpTarget_coordinates

private theorem vp_card : vp.endpoint.outputCard = 4 :=
  vpCascade.outputEquiv.outputCard_eq

private theorem vp_length : vp.path.length = 2 := by
  have h := split_cardinality vp.path (fun k hk => Or.inr (vp.homogeneous k hk))
  rw [vp_card] at h
  change 4 = 2 + vp.path.length at h
  omega

example (j : Fin 2) (b : Bool) : (blockLabels j b).val = blocks b :=
  blockLabels_val j b

example (x : Fin 3) (j : Fin 2) (b : Bool) :
    vp.endpoint.channel x (vp.labels ⟨j, blockLabels j b⟩) =
      if x ∈ blocks b then (ppWeights j : ENNReal) else 0 := by
  rw [vp.coordinates, blockLabels_val]
  rfl

private theorem finalTarget_coordinates (x : Fin 3) (b : Fin 3) :
    finalTarget.channel x (cycle b) =
      ∑ j : Fin 4, if group j = b then vpTarget.channel x j else 0 := by
  have h : finalWeights x (cycle b) =
      ∑ j : Fin 4, if group j = b then vpWeights x j else 0 := by
    fin_cases x <;> fin_cases b <;>
      norm_num [finalWeights, vpWeights, cycle, group, Fin.sum_univ_succ,
        Fin.ext_iff, -Fin.val_eq_zero_iff,
        Matrix.cons_val_two, Matrix.vecHead, Matrix.vecTail]
  change (finalWeights x (cycle b) : ENNReal) =
    ∑ j : Fin 4, if group j = b then (vpWeights x j : ENNReal) else 0
  rw [h, ENNReal.ofNNReal_finsetSum]
  apply Finset.sum_congr rfl
  intro j _
  split_ifs <;> rfl

private abbrev pm := multiPpmFibers vpTarget vpTarget_singular
  group group_surjective group_support

private def pmCascade : Cascade vpTarget finalTarget :=
  pm.cascade cycle finalTarget_coordinates

private theorem pm_card : pm.endpoint.outputCard = 3 :=
  pmCascade.outputEquiv.outputCard_eq

private theorem pm_length : pm.path.length = 1 := by
  simpa only [Fintype.card_fin] using
    multiPpmFibers_length vpTarget vpTarget_singular group group_surjective group_support

example : cycle 0 = 1 ∧ cycle.symm 0 = 2 ∧
    finalTarget.channel 1 (cycle 0) = ((2 / 3 : NNReal) : ENNReal) ∧
    finalTarget.channel 1 (cycle.symm 0) = 0 :=
  ⟨rfl, rfl, rfl, rfl⟩

private def full : Cascade (allOnes (Fin 3)) finalTarget :=
  (ppCascade.comp vpCascade).comp pmCascade

private theorem full_normalizing : full.path.Normalizing := by
  change ((ppCascade.comp vpCascade).comp pmCascade).path.Allowed
    (fun k => k = .pps ∨ k = .vps ∨ k = .ppm)
  rw [Cascade.allowed_comp, Cascade.allowed_comp]
  exact ⟨⟨fun k hk => Or.inl (pp.homogeneous k hk),
    fun k hk => Or.inr (Or.inl (vp.homogeneous k hk))⟩,
    fun k hk => Or.inr (Or.inr (pm.homogeneous k hk))⟩

example : full.path.tags = (pp.path.tags ++ vp.path.tags) ++ pm.path.tags := by
  simp only [full, Cascade.tags_comp]
  rfl

example : full.path.length = 4 := by
  change ((ppCascade.comp vpCascade).comp pmCascade).path.length = 4
  rw [Cascade.length_comp, Cascade.length_comp]
  change (pp.path.length + vp.path.length) + pm.path.length = 4
  rw [pp_length, vp_length, pm_length]

example : full.path.tags = [.pps, .vps, .vps, .ppm] := by
  have hp : pp.path.tags = List.replicate 1 .pps := by
    simpa only [OperationPath.tags_length, pp_length] using
      List.eq_replicate_length.mpr pp.homogeneous
  have hv : vp.path.tags = List.replicate 2 .vps := by
    simpa only [OperationPath.tags_length, vp_length] using
      List.eq_replicate_length.mpr vp.homogeneous
  have hm : pm.path.tags = List.replicate 1 .ppm := by
    simpa only [OperationPath.tags_length, pm_length] using
      List.eq_replicate_length.mpr pm.homogeneous
  change ((ppCascade.comp vpCascade).comp pmCascade).path.tags = _
  rw [Cascade.tags_comp, Cascade.tags_comp]
  change (pp.path.tags ++ vp.path.tags) ++ pm.path.tags = _
  rw [hp, hv, hm]
  rfl

example (x : Fin 3) (j : Fin 3) :
    full.endpoint.channel x (full.outputEquiv.equiv.symm j) =
      (finalWeights x j : ENNReal) :=
  full.outputEquiv.apply_symm x j

example : FromAllOnes finalTarget ∧ ToAllOnes finalTarget ∧
    IsPerfectlyRepresentableChannel finalTarget.channel := by
  have hf : FromAllOnes finalTarget := ⟨full, full_normalizing⟩
  exact ⟨hf, fromAllOnes_iff_toAllOnes.mp hf, hf.isPerfectlyRepresentable⟩

-- This is the witness returned by C08, not a manually assembled normal form.
private def normalized : NormalForm (allOnes (Fin 3)) finalTarget :=
  Classical.choice (full.normalize (allOnes_isSingular _) full_normalizing)

example : normalized.pp.Homogeneous .pps ∧ normalized.vp.Homogeneous .vps ∧
    normalized.pm.Homogeneous .ppm :=
  ⟨normalized.pp_homogeneous, normalized.vp_homogeneous, normalized.pm_homogeneous⟩

example : normalized.toCascade.path.tags =
    (normalized.pp.tags ++ normalized.vp.tags) ++ normalized.pm.tags :=
  normalized.toCascade_tags

example : IsSingularChannel normalized.ppEndpoint.channel ∧
    IsSingularChannel normalized.vpEndpoint.channel ∧
    IsSingularChannel normalized.pmEndpoint.channel :=
  ⟨normalized.pp_isSingular (allOnes_isSingular _),
    normalized.vp_isSingular (allOnes_isSingular _),
    normalized.pm_isSingular (allOnes_isSingular _)⟩

example : normalized.pmEndpoint.outputCard = 3 := normalized.outputEquiv.outputCard_eq

example (x : Fin 3) : (normalized.pmEndpoint.channel x).map normalized.outputEquiv.equiv =
    finalTarget.channel x := normalized.outputEquiv.map_eq x

example (x : Fin 3) (j : Fin 3) :
    normalized.pmEndpoint.channel x (normalized.outputEquiv.equiv.symm j) =
      (finalWeights x j : ENNReal) :=
  normalized.outputEquiv.apply_symm x j

example : IsPerfectlyRepresentableChannel finalTarget.channel :=
  normalized.toCascade.isPerfectlyRepresentable normalized.toCascade_normalizing
    (allOnes_isPerfectlyRepresentable _)

end
end PerfectFunctionalRepresentations.MatrixOperations.SynthesisTests







/-! ## R18: callers retain original labels through the public interfaces -/

namespace PerfectFunctionalRepresentations.MatrixOperations.SynthesisInterfaces

open scoped BigOperators ENNReal
noncomputable section
attribute [local instance] Classical.propDecidable

-- A later caller can retain the original positive ENNReal labels and provide its own target.
example {alpha : Type*} [Finite alpha] [Nonempty alpha]
    (S T : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    {I : Fin S.outputCard → Type*} [∀ j, Fintype (I j)]
    (w : ∀ j, I j → ENNReal) (hs : ∀ j, ∑ i, w j i = 1)
    (e : (Σ j, {i // 0 < w j i}) ≃ Fin T.outputCard)
    (he : ∀ x p, T.channel x (e p) = w p.1 p.2.val * S.channel x p.1) :
    ∃ c : Cascade S T, c.path.Homogeneous .pps ∧
      IsSingularChannel c.endpoint.channel ∧
      ∀ x, (c.endpoint.channel x).map c.outputEquiv.equiv = T.channel x := by
  let d := multiPpsFamilyOfENNReal S hS w hs
  let c := d.cascade e he
  exact ⟨c, d.homogeneous, d.isSingular hS, c.outputEquiv.map_eq⟩

-- Grouping is supplied on the caller's original block labels. It is transferred
-- to the actual VPS endpoint through the complete label equivalence.
example {alpha : Type*} [Fintype alpha] [Nonempty alpha]
    (S T : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    {I : Fin S.outputCard → Type*} [∀ j, Fintype (I j)]
    (blocks : ∀ j, I j → Finset alpha)
    (hne : ∀ j i, (blocks j i).Nonempty)
    (hdis : ∀ j, Pairwise (fun i k => Disjoint (blocks j i) (blocks j k)))
    (hcover : ∀ j x, x ∈ (columnPattern S.channel (S.activeEquiv j)).val ↔
      ∃ i, x ∈ blocks j i)
    {B : Type*} [Fintype B] (g : (Σ j, I j) → B) (hg : Function.Surjective g)
    (hp : ∀ p q, g p = g q → ∀ x,
      (if x ∈ blocks p.1 p.2 then S.channel x p.1 else 0) ≠ 0 ↔
      (if x ∈ blocks q.1 q.2 then S.channel x q.1 else 0) ≠ 0)
    (e : B ≃ Fin T.outputCard)
    (he : ∀ x b, T.channel x (e b) =
      ∑ p : Σ j, I j, if g p = b then
        (if x ∈ blocks p.1 p.2 then S.channel x p.1 else 0) else 0) :
    ∃ c : Cascade S T, c.path.Normalizing ∧
      IsSingularChannel c.endpoint.channel ∧
      ∀ x, (c.endpoint.channel x).map c.outputEquiv.equiv = T.channel x := by
  let mass (x : alpha) (p : Σ j, I j) :=
    if x ∈ blocks p.1 p.2 then S.channel x p.1 else 0
  let P j := partitionOfBlocks _ (blocks j) (hne j) (hdis j) (hcover j)
  let E j := partitionOfBlocksEquiv _ (blocks j) (hne j) (hdis j) (hcover j)
  let v := multiVpsFamily S hS P
  let labels : (Σ j, I j) ≃ Fin v.endpoint.outputCard :=
    (Equiv.sigmaCongrRight E).trans v.labels
  have coordinates (x : alpha) (p : Σ j, I j) :
      v.endpoint.channel x (labels p) = mass x p := by
    rcases p with ⟨j, i⟩
    change v.endpoint.channel x (v.labels ⟨j, E j i⟩) = _
    rw [v.coordinates]
    have hb : (E j i).val = blocks j i :=
      partitionOfBlocksEquiv_apply_val _ _ _ _ _ i
    rw [hb]
  let actualGroup : Fin v.endpoint.outputCard → B := fun j => g (labels.symm j)
  have actualSurjective : Function.Surjective actualGroup := by
    intro b
    obtain ⟨p, rfl⟩ := hg b
    exact ⟨labels p, by simp only [actualGroup, Equiv.symm_apply_apply]⟩
  have actualSupport (j k : Fin v.endpoint.outputCard)
      (hjk : actualGroup j = actualGroup k) (x : alpha) :
      v.endpoint.channel x j ≠ 0 ↔ v.endpoint.channel x k ≠ 0 := by
    have h := hp (labels.symm j) (labels.symm k) hjk x
    change mass x (labels.symm j) ≠ 0 ↔ mass x (labels.symm k) ≠ 0 at h
    rw [← coordinates x (labels.symm j), ← coordinates x (labels.symm k)] at h
    simpa only [Equiv.apply_symm_apply] using h
  let m := multiPpmFibers v.endpoint (v.isSingular hS)
    actualGroup actualSurjective actualSupport
  have target (x : alpha) (b : B) :
      T.channel x (e b) =
        ∑ j, if actualGroup j = b then v.endpoint.channel x j else 0 := by
    calc
      _ = ∑ p : Σ j, I j, if g p = b then mass x p else 0 := he x b
      _ = ∑ j, if g (labels.symm j) = b then mass x (labels.symm j) else 0 :=
        (labels.symm.sum_comp (fun p => if g p = b then mass x p else 0)).symm
      _ = _ := by
        apply Finset.sum_congr rfl
        intro j _
        change (if actualGroup j = b then mass x (labels.symm j) else 0) = _
        split_ifs
        · simpa only [Equiv.apply_symm_apply] using (coordinates x (labels.symm j)).symm
        · rfl
  let c : Cascade S T :=
    ⟨m.endpoint, v.path.append m.path, m.outputEquiv e target⟩
  have normalizing : c.path.Normalizing := by
    change (v.path.append m.path).Allowed (fun k => k = .pps ∨ k = .vps ∨ k = .ppm)
    rw [OperationPath.allowed_append]
    exact ⟨fun k hk => Or.inr (Or.inl (v.homogeneous k hk)),
      fun k hk => Or.inr (Or.inr (m.homogeneous k hk))⟩
  exact ⟨c, normalizing, m.isSingular (v.isSingular hS), c.outputEquiv.map_eq⟩

-- This is the available finite-partition boundary, without any incidence construction.
example {alpha : Type*} [Fintype alpha] (s : Finset alpha) :
    Fintype (Finpartition s) := inferInstance

end
end PerfectFunctionalRepresentations.MatrixOperations.SynthesisInterfaces

