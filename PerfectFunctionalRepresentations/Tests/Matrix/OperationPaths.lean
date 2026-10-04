import PerfectFunctionalRepresentations.Matrix.OperationPaths
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.FinCases

/-!
# C08 witnessed-path and ordered-transport regressions

S01 owns R01-R03: empty paths and explicit starting singularity, all four
witnessed C07 embeddings with changing output cardinalities, and chronological
concatenation. Private consumers extract retained parameters as data.
S02 owns R04-R06: ordered split/merge transport, chronological cascade
composition, and all four remembered recovery paths in both map directions.
No consumer assumes interchange or normalization from a later step.
-/

namespace PerfectFunctionalRepresentations.MatrixOperations

universe u
variable {alpha : Type u} [Finite alpha] [Nonempty alpha]

noncomputable section

-- R01: an empty path admits every restriction and every homogeneous tag.
example (S : ActiveFiniteChannel alpha) :
    (OperationPath.nil : OperationPath S S).tags = [] ∧
      (OperationPath.nil : OperationPath S S).length = 0 := ⟨rfl, rfl⟩

example (S : ActiveFiniteChannel alpha) (P : OperationKind → Prop) :
    (OperationPath.nil : OperationPath S S).Allowed P := OperationPath.allowed_nil P

example (S : ActiveFiniteChannel alpha) (k : OperationKind) :
    (OperationPath.nil : OperationPath S S).Homogeneous k :=
  OperationPath.homogeneous_nil k

example (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel) :
    IsSingularChannel S.channel :=
  (OperationPath.nil : OperationPath S S).isSingular hS

-- R02: every wrapper has exactly its C07 target, with no relabeling edge.
section Embeddings

variable (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)

example (l : Fin S.outputCard) (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1) :
    OperationStep S (pps S hS l t ht0 ht1) := .pps S hS l t ht0 ht1

example (l : Fin S.outputCard) (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1) :
    (OperationStep.pps S hS l t ht0 ht1).kind = .pps ∧
      (pps S hS l t ht0 ht1).outputCard = S.outputCard + 1 := ⟨rfl, rfl⟩

example (l : Fin S.outputCard) (mask : alpha → Bool)
    (hleft : ∃ x, S.channel x l ≠ 0 ∧ mask x = true)
    (hright : ∃ x, S.channel x l ≠ 0 ∧ mask x = false) :
    OperationStep S (vps S hS l mask hleft hright) := .vps S hS l mask hleft hright

example (l : Fin S.outputCard) (mask : alpha → Bool)
    (hleft : ∃ x, S.channel x l ≠ 0 ∧ mask x = true)
    (hright : ∃ x, S.channel x l ≠ 0 ∧ mask x = false) :
    (OperationStep.vps S hS l mask hleft hright).kind = .vps ∧
      (vps S hS l mask hleft hright).outputCard = S.outputCard + 1 := ⟨rfl, rfl⟩

example (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) :
    OperationStep S (ppm S hS a b hab hp) := .ppm S hS a b hab hp

example (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) :
    (OperationStep.ppm S hS a b hab hp).kind = .ppm ∧
      (ppm S hS a b hab hp).outputCard = S.outputCard - 1 := ⟨rfl, rfl⟩

example (a b : Fin S.outputCard) (hab : a < b)
    (hv : columnValue S.channel hS (S.activeEquiv a) =
      columnValue S.channel hS (S.activeEquiv b))
    (hd : ∀ x, S.channel x a ≠ 0 → S.channel x b = 0) :
    OperationStep S (vpm S hS a b hab hv hd) := .vpm S hS a b hab hv hd

example (a b : Fin S.outputCard) (hab : a < b)
    (hv : columnValue S.channel hS (S.activeEquiv a) =
      columnValue S.channel hS (S.activeEquiv b))
    (hd : ∀ x, S.channel x a ≠ 0 → S.channel x b = 0) :
    (OperationStep.vpm S hS a b hab hv hd).kind = .vpm ∧
      (vpm S hS a b hab hv hd).outputCard = S.outputCard - 1 := ⟨rfl, rfl⟩

example (a b : Fin S.outputCard) (hab : a < b)
    (hv : columnValue S.channel hS (S.activeEquiv a) =
      columnValue S.channel hS (S.activeEquiv b))
    (hd : ∀ x, S.channel x a ≠ 0 → S.channel x b = 0) :
    ¬ (OperationPath.nil.snoc (.vpm S hS a b hab hv hd)).Normalizing := by
  simp [OperationPath.Normalizing, OperationPath.Allowed, OperationStep.kind]

end Embeddings

-- These Type-valued eliminations would be unavailable if witnesses were erased
-- into a proposition. They require no changes to the production interface.
private def recordedRatio {S T : ActiveFiniteChannel alpha}
    (e : OperationStep S T) : Option NNReal :=
  match e with
  | .pps _ _ _ t _ _ => some t
  | .vps .. | .ppm .. | .vpm .. => none

private def recordedMask {S T : ActiveFiniteChannel alpha}
    (e : OperationStep S T) : Option (alpha → Bool) :=
  match e with
  | .vps _ _ _ mask _ _ => some mask
  | .pps .. | .ppm .. | .vpm .. => none

example (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1) :
    recordedRatio (.pps S hS l t ht0 ht1) = some t := rfl

example (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (mask : alpha → Bool)
    (hleft : ∃ x, S.channel x l ≠ 0 ∧ mask x = true)
    (hright : ∃ x, S.channel x l ≠ 0 ∧ mask x = false) :
    recordedMask (.vps S hS l mask hleft hright) = some mask := rfl

-- R03: a real split followed by its legal adjacent merge changes dimensions
-- twice. The chronological tag list still records both operations.
private def ppSplitPath (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (l : Fin S.outputCard)
    (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1) :
    OperationPath S (pps S hS l t ht0 ht1) :=
  OperationPath.nil.snoc (.pps S hS l t ht0 ht1)

private def ppMergePath (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (l : Fin S.outputCard)
    (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1) :
    OperationPath (pps S hS l t ht0 ht1) (ppsRecovery S hS l t ht0 ht1) :=
  OperationPath.nil.snoc (.ppm (pps S hS l t ht0 ht1)
    (pps_isSingular S hS l t ht0 ht1) (splitLeft l) (splitRight l)
    (by exact Fin.castSucc_lt_succ) (pps_children_sameSupport S hS l t ht0 ht1))

section RoundTrip

variable (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
variable (l : Fin S.outputCard) (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1)

example : ((ppSplitPath S hS l t ht0 ht1).append
    (ppMergePath S hS l t ht0 ht1)).tags = [.pps, .ppm] := rfl

example : ((ppSplitPath S hS l t ht0 ht1).append
    (ppMergePath S hS l t ht0 ht1)).length = 2 := rfl

example : ((ppSplitPath S hS l t ht0 ht1).append
    (ppMergePath S hS l t ht0 ht1)).tags ≠ [.ppm, .pps] := by
  change [OperationKind.pps, .ppm] ≠ [.ppm, .pps]
  decide

example : ((ppSplitPath S hS l t ht0 ht1).append
    (ppMergePath S hS l t ht0 ht1)).Normalizing := by
  change ∀ k ∈ [OperationKind.pps, .ppm], k = .pps ∨ k = .vps ∨ k = .ppm
  simp

example : ¬ ((ppSplitPath S hS l t ht0 ht1).append
    (ppMergePath S hS l t ht0 ht1)).Homogeneous .pps := by
  change ¬ (∀ k ∈ [OperationKind.pps, .ppm], k = .pps)
  decide

example : IsSingularChannel (ppsRecovery S hS l t ht0 ht1).channel :=
  ((ppSplitPath S hS l t ht0 ht1).append
    (ppMergePath S hS l t ht0 ht1)).isSingular hS

example : (pps S hS l t ht0 ht1).outputCard = S.outputCard + 1 ∧
    (ppsRecovery S hS l t ht0 ht1).outputCard = S.outputCard := ⟨rfl, rfl⟩

end RoundTrip

example {S T U : ActiveFiniteChannel alpha} (p : OperationPath S T)
    (q : OperationPath T U) (P : OperationKind → Prop) :
    (p.append q).tags = p.tags ++ q.tags ∧
      (p.append q).length = p.length + q.length ∧
      ((p.append q).Allowed P ↔ p.Allowed P ∧ q.Allowed P) :=
  ⟨OperationPath.tags_append p q, OperationPath.length_append p q,
    OperationPath.allowed_append P p q⟩

example {S T U V : ActiveFiniteChannel alpha} (p : OperationPath S T)
    (q : OperationPath T U) (r : OperationPath U V) :
    (p.append q).append r = p.append (q.append r) := OperationPath.append_assoc p q r

-- The public path API retains its explicit graph even if a consumer installs
-- a different local quiver on the same active-state type.
section OtherQuiver

local instance : Quiver (ActiveFiniteChannel alpha) where
  Hom _ _ := PEmpty

example (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1) :
    OperationPath S (pps S hS l t ht0 ht1) :=
  OperationPath.nil.snoc (.pps S hS l t ht0 ht1)

end OtherQuiver

-- R01: identity, inverse and composed equivalences expose their actual PMF
-- equations, including destination-label coordinate lookup.
example (S : ActiveFiniteChannel alpha) (x : alpha) :
    (S.channel x).map (OutputEquiv.refl S).equiv = S.channel x :=
  (OutputEquiv.refl S).map_eq x

example {S T U : ActiveFiniteChannel alpha} (e : OutputEquiv S T)
    (f : OutputEquiv T U) (x : alpha) (y : Fin S.outputCard)
    (z : Fin T.outputCard) :
    S.outputCard = T.outputCard ∧
      T.channel x (e.equiv y) = S.channel x y ∧
      S.channel x (e.equiv.symm z) = T.channel x z ∧
      (S.channel x).map (e.trans f).equiv = U.channel x :=
  ⟨e.outputCard_eq, e.apply x y, e.apply_symm x z, (e.trans f).map_eq x⟩

private abbrev labeledSource : ActiveFiniteChannel (Fin 4) where
  outputCard := 4
  outputCard_pos := by decide
  channel := fun x => PMF.pure x
  output_active := by intro y; exact ⟨y, by simp⟩

private def relabelCycle : Fin 4 ≃ Fin 4 := recoveryPerm 0 3 (by decide)

private abbrev labeledTarget : ActiveFiniteChannel (Fin 4) :=
  ActiveFiniteChannel.ofActive labeledSource.channel relabelCycle labeledSource.output_active

private def labeledEquiv : OutputEquiv labeledSource labeledTarget where
  equiv := relabelCycle
  map_eq _ := rfl

private def relabelOnly : Cascade labeledSource labeledTarget where
  endpoint := labeledSource
  path := OperationPath.nil
  outputEquiv := labeledEquiv

-- A pure relabeling really has no operation and keeps the nontrivial bijection.
example : relabelOnly.path.tags = [] ∧ relabelOnly.path.length = 0 := ⟨rfl, rfl⟩

example : relabelOnly.outputEquiv.equiv (1 : Fin 4) = (3 : Fin 4) ∧
    relabelOnly.outputEquiv.equiv.symm (1 : Fin 4) = (2 : Fin 4) := by
  change recoveryPerm (0 : Fin 4) 3 _ 1 = 3 ∧
    (recoveryPerm (0 : Fin 4) 3 _).symm 1 = 2
  constructor
  · apply Fin.ext
    norm_num [recoveryPerm_val]
  · apply Fin.ext
    norm_num [recoveryPerm_symm_val, show (1 : Fin 4) ≠ 3 by decide]

example : labeledEquiv.equiv ≠ labeledEquiv.equiv.symm := by
  intro h
  change recoveryPerm (0 : Fin 4) 3 _ = (recoveryPerm (0 : Fin 4) 3 _).symm at h
  have he := congrArg (fun e : Fin 4 ≃ Fin 4 => (e 1).val) h
  norm_num [recoveryPerm_val, recoveryPerm_symm_val,
    show (1 : Fin 4) ≠ 3 by decide] at he

example (x : Fin 4) : (labeledTarget.channel x).map labeledEquiv.symm.equiv =
    labeledSource.channel x := labeledEquiv.symm.map_eq x

example (x : Fin 4) : (labeledSource.channel x).map
    (labeledEquiv.trans labeledEquiv.symm).equiv = labeledSource.channel x :=
  (labeledEquiv.trans labeledEquiv.symm).map_eq x

example : labeledTarget.channel 1 (labeledEquiv.equiv 1) = 1 := by
  rw [labeledEquiv.apply]
  simp [labeledSource]

example : labeledSource.channel 1 ≠ labeledTarget.channel 1 := by
  intro h
  have hcoord := congrArg (fun p : PMF (Fin 4) => p (labeledEquiv.equiv 1)) h
  have hcoord' := hcoord.trans (labeledEquiv.apply 1 1)
  have hlabel : labeledEquiv.equiv 1 = (3 : Fin 4) := by
    change recoveryPerm (0 : Fin 4) 3 _ 1 = 3
    apply Fin.ext
    norm_num [recoveryPerm_val]
  simp [labeledSource, hlabel] at hcoord'

-- These packages expose existing witnesses; their construction uses only empty
-- blocks and a supplied equivalence, without invoking a normalization theorem.
example (S T : ActiveFiniteChannel alpha) (e : OutputEquiv S T) : NormalForm S T where
  ppEndpoint := S
  vpEndpoint := S
  pmEndpoint := S
  pp := OperationPath.nil
  vp := OperationPath.nil
  pm := OperationPath.nil
  pp_homogeneous := OperationPath.homogeneous_nil .pps
  vp_homogeneous := OperationPath.homogeneous_nil .vps
  pm_homogeneous := OperationPath.homogeneous_nil .ppm
  outputEquiv := e

example {S T : ActiveFiniteChannel alpha} (nf : NormalForm S T)
    (hS : IsSingularChannel S.channel) :
    IsSingularChannel nf.ppEndpoint.channel ∧ IsSingularChannel nf.vpEndpoint.channel ∧
      IsSingularChannel nf.pmEndpoint.channel :=
  ⟨nf.pp.isSingular hS, nf.vp.isSingular (nf.pp.isSingular hS),
    nf.pm.isSingular (nf.vp.isSingular (nf.pp.isSingular hS))⟩

-- R04: every selected column has both mask pieces. Unequal weights and a strict
-- ratio of one third make swapped children observable at both boundary labels.
private def transportWeights : Fin 4 → NNReal := ![1 / 10, 2 / 10, 3 / 10, 4 / 10]

private theorem transportWeights_sum : ∑ j, transportWeights j = 1 := by
  norm_num [transportWeights, Fin.sum_univ_succ]

private theorem transportWeights_pos (j : Fin 4) : (transportWeights j : ENNReal) ≠ 0 := by
  rw [ENNReal.coe_ne_zero]
  fin_cases j <;> norm_num [transportWeights]

private abbrev weightedSource : ActiveFiniteChannel Bool where
  outputCard := 4
  outputCard_pos := by decide
  channel := fun _ => PMF.ofFintype (fun j => (transportWeights j : ENNReal))
    (by exact_mod_cast transportWeights_sum)
  output_active j := ⟨true, transportWeights_pos j⟩

private theorem weightedSource_singular : IsSingularChannel weightedSource.channel := by
  intro x z j _ _
  rfl

private abbrev weightedTarget : ActiveFiniteChannel Bool :=
  ActiveFiniteChannel.ofActive weightedSource.channel relabelCycle weightedSource.output_active

private def weightedEquiv : OutputEquiv weightedSource weightedTarget where
  equiv := relabelCycle
  map_eq _ := rfl

private theorem weighted_left (l : Fin 4) :
    ∃ x, weightedSource.channel x l ≠ 0 ∧ x = true :=
  ⟨true, transportWeights_pos l, rfl⟩

private theorem weighted_right (l : Fin 4) :
    ∃ x, weightedSource.channel x l ≠ 0 ∧ x = false :=
  ⟨false, transportWeights_pos l, rfl⟩

private def weightedPP (l : Fin 4) :=
  weightedEquiv.pps weightedSource_singular l (1 / 3) (by norm_num) (by norm_num)

private def weightedVP (l : Fin 4) :=
  weightedEquiv.vps weightedSource_singular l id (weighted_left l) (weighted_right l)

-- The quantifier checks both boundary choices and all other insertion sites;
-- the subsequent numerical consumers select the first and final labels.
example (l : Fin 4) :
    (weightedPP l).equiv (splitLeft l) = splitLeft (relabelCycle l) ∧
      (weightedPP l).equiv (splitRight l) = splitRight (relabelCycle l) ∧
      (∀ j, (weightedPP l).equiv (splitKeep l j) =
        splitKeep (relabelCycle l) (relabelCycle j)) ∧
      (weightedVP l).equiv = (weightedPP l).equiv :=
  ⟨splitOutputEquiv_left _ _, splitOutputEquiv_right _ _,
    splitOutputEquiv_keep _ _, rfl⟩

example (l j : Fin 4) (hj : j ≠ l) (x : Bool) :
    (pps weightedTarget (weightedEquiv.isSingular weightedSource_singular)
      (relabelCycle l) (1 / 3) (by norm_num) (by norm_num)).channel x
        ((weightedPP l).equiv (splitKeep l j)) = (transportWeights j : ENNReal) := by
  exact ((weightedPP l).apply x (splitKeep l j)).trans
    (pps_keep _ _ _ _ _ _ x hj)

example (l j : Fin 4) (hj : j ≠ l) (x : Bool) :
    (vps weightedTarget (weightedEquiv.isSingular weightedSource_singular)
      (relabelCycle l) id (weightedEquiv.vpsWitness l id true (weighted_left l))
      (weightedEquiv.vpsWitness l id false (weighted_right l))).channel x
        ((weightedVP l).equiv (splitKeep l j)) = (transportWeights j : ENNReal) := by
  exact ((weightedVP l).apply x (splitKeep l j)).trans
    (vps_keep _ _ _ _ _ _ x hj)

private theorem weightedPP_children (l : Fin 4) :
    (pps weightedTarget (weightedEquiv.isSingular weightedSource_singular)
      (relabelCycle l) (1 / 3) (by norm_num) (by norm_num)).channel true
        ((weightedPP l).equiv (splitLeft l)) =
          ((1 / 3 : NNReal) : ENNReal) * transportWeights l ∧
    (pps weightedTarget (weightedEquiv.isSingular weightedSource_singular)
      (relabelCycle l) (1 / 3) (by norm_num) (by norm_num)).channel true
        ((weightedPP l).equiv (splitRight l)) =
          ((2 / 3 : NNReal) : ENNReal) * transportWeights l := by
  constructor
  · exact ((weightedPP l).apply true (splitLeft l)).trans (pps_left _ _ _ _ _ _ true)
  · have hr := pps_right weightedSource weightedSource_singular l (1 / 3)
      (by norm_num) (by norm_num) true
    have hsub : (1 - (1 / 3 : NNReal)) = 2 / 3 := by
      apply NNReal.coe_injective
      norm_num [NNReal.coe_sub_def]
    rw [hsub] at hr
    exact ((weightedPP l).apply true (splitRight l)).trans hr

example :
    (pps weightedTarget (weightedEquiv.isSingular weightedSource_singular)
      (relabelCycle 0) (1 / 3) (by norm_num) (by norm_num)).channel true
        ((weightedPP 0).equiv (splitLeft 0)) = ((1 / 30 : NNReal) : ENNReal) ∧
    (pps weightedTarget (weightedEquiv.isSingular weightedSource_singular)
      (relabelCycle 0) (1 / 3) (by norm_num) (by norm_num)).channel true
        ((weightedPP 0).equiv (splitRight 0)) = ((1 / 15 : NNReal) : ENNReal) := by
  simpa only [show transportWeights 0 = (1 / 10 : NNReal) from rfl, ← ENNReal.coe_mul,
    show (1 / 3 : NNReal) * (1 / 10) = 1 / 30 by norm_num,
    show (2 / 3 : NNReal) * (1 / 10) = 1 / 15 by norm_num] using weightedPP_children 0

example :
    (pps weightedTarget (weightedEquiv.isSingular weightedSource_singular)
      (relabelCycle 3) (1 / 3) (by norm_num) (by norm_num)).channel true
        ((weightedPP 3).equiv (splitLeft 3)) = ((2 / 15 : NNReal) : ENNReal) ∧
    (pps weightedTarget (weightedEquiv.isSingular weightedSource_singular)
      (relabelCycle 3) (1 / 3) (by norm_num) (by norm_num)).channel true
        ((weightedPP 3).equiv (splitRight 3)) = ((4 / 15 : NNReal) : ENNReal) := by
  simpa only [show transportWeights 3 = (4 / 10 : NNReal) from rfl, ← ENNReal.coe_mul,
    show (1 / 3 : NNReal) * (4 / 10) = 2 / 15 by norm_num,
    show (2 / 3 : NNReal) * (4 / 10) = 4 / 15 by norm_num] using weightedPP_children 3

-- For either boundary, true stays in the left child and false in the right.
private theorem weightedVP_children (l : Fin 4) (x : Bool) :
    (vps weightedTarget (weightedEquiv.isSingular weightedSource_singular)
      (relabelCycle l) id (weightedEquiv.vpsWitness l id true (weighted_left l))
      (weightedEquiv.vpsWitness l id false (weighted_right l))).channel x
        ((weightedVP l).equiv (splitLeft l)) =
          (if x then (transportWeights l : ENNReal) else 0) ∧
    (vps weightedTarget (weightedEquiv.isSingular weightedSource_singular)
      (relabelCycle l) id (weightedEquiv.vpsWitness l id true (weighted_left l))
      (weightedEquiv.vpsWitness l id false (weighted_right l))).channel x
        ((weightedVP l).equiv (splitRight l)) =
          (if x then 0 else (transportWeights l : ENNReal)) := by
  constructor
  · exact ((weightedVP l).apply x (splitLeft l)).trans (vps_left _ _ _ _ _ _ x)
  · exact ((weightedVP l).apply x (splitRight l)).trans (vps_right _ _ _ _ _ _ x)

example :
    (vps weightedTarget (weightedEquiv.isSingular weightedSource_singular)
      (relabelCycle 0) id (weightedEquiv.vpsWitness 0 id true (weighted_left 0))
      (weightedEquiv.vpsWitness 0 id false (weighted_right 0))).channel true
        ((weightedVP 0).equiv (splitLeft 0)) = ((1 / 10 : NNReal) : ENNReal) ∧
    (vps weightedTarget (weightedEquiv.isSingular weightedSource_singular)
      (relabelCycle 3) id (weightedEquiv.vpsWitness 3 id true (weighted_left 3))
      (weightedEquiv.vpsWitness 3 id false (weighted_right 3))).channel false
        ((weightedVP 3).equiv (splitRight 3)) = ((2 / 5 : NNReal) : ENNReal) := by
  constructor
  · simpa [transportWeights] using (weightedVP_children 0 true).1
  · convert (weightedVP_children 3 false).2 using 1
    norm_num [transportWeights, Matrix.cons_val_three]

example : recordedRatio ((OperationStep.pps weightedSource weightedSource_singular
      3 (1 / 3) (by norm_num) (by norm_num)).transport weightedEquiv).step = some (1 / 3) ∧
    recordedMask ((OperationStep.vps weightedSource weightedSource_singular
      0 id (weighted_left 0) (weighted_right 0)).transport weightedEquiv).step = some id :=
  ⟨rfl, rfl⟩

-- R05: 1 < 3 is nonadjacent and includes the original final label. Its images
-- are 3 and 2, so transport must sort them and move the surviving column.
private theorem weighted_patterns (a b : Fin 4) (x : Bool) :
    weightedSource.channel x a ≠ 0 ↔ weightedSource.channel x b ≠ 0 :=
  ⟨fun _ => transportWeights_pos b, fun _ => transportWeights_pos a⟩

private def weightedMerge :=
  weightedEquiv.ppm weightedSource_singular 1 3 (by decide) (weighted_patterns 1 3)

private theorem labeledSource_singular : IsSingularChannel labeledSource.channel := by
  intro x z j hx hz
  simp only [labeledSource, PMF.pure_apply] at hx hz ⊢
  split_ifs at hx hz ⊢ <;> simp_all

private theorem labeledSource_value (j : Fin 4) :
    columnValue labeledSource.channel labeledSource_singular (labeledSource.activeEquiv j) = 1 := by
  rw [columnValue_eq_of_ne_zero _ _ _ (x := j)
    (by change (PMF.pure j) j ≠ 0; simp)]
  change (PMF.pure j) j = 1
  simp

private theorem labeledSource_values (a b : Fin 4) :
    columnValue labeledSource.channel labeledSource_singular (labeledSource.activeEquiv a) =
      columnValue labeledSource.channel labeledSource_singular (labeledSource.activeEquiv b) := by
  rw [labeledSource_value, labeledSource_value]

private theorem labeledSource_disjoint (a b : Fin 4) (hab : a ≠ b)
    (x : Fin 4) (hx : labeledSource.channel x a ≠ 0) : labeledSource.channel x b = 0 := by
  simp only [labeledSource, PMF.pure_apply] at hx ⊢
  split_ifs at hx ⊢ <;> simp_all

private def labeledMerge :=
  labeledEquiv.vpm labeledSource_singular 1 3 (by decide) (labeledSource_values 1 3)
    (labeledSource_disjoint 1 3 (by decide))

example : weightedEquiv.mergeLower 1 3 = (2 : Fin 4) ∧
    weightedEquiv.mergeUpper 1 3 = (3 : Fin 4) ∧
    labeledEquiv.mergeLower 1 3 = (2 : Fin 4) ∧
    labeledEquiv.mergeUpper 1 3 = (3 : Fin 4) := by
  have h1 : relabelCycle 1 = (3 : Fin 4) := by
    apply Fin.ext
    norm_num [relabelCycle, recoveryPerm_val]
  have h3 : relabelCycle 3 = (2 : Fin 4) := by
    apply Fin.ext
    norm_num [relabelCycle, recoveryPerm_val]
  change min (relabelCycle 1) (relabelCycle 3) = (2 : Fin 4) ∧
    max (relabelCycle 1) (relabelCycle 3) = (3 : Fin 4) ∧
    min (relabelCycle 1) (relabelCycle 3) = (2 : Fin 4) ∧
    max (relabelCycle 1) (relabelCycle 3) = (3 : Fin 4)
  rw [h1, h3]
  decide

example : weightedMerge.equiv (activeMergeSurvivor weightedSource 1 3 (by decide)) =
    activeMergeSurvivor weightedTarget (weightedEquiv.mergeLower 1 3)
      (weightedEquiv.mergeUpper 1 3) (weightedEquiv.merge_lt 1 3 (by decide)) ∧
    labeledMerge.equiv (activeMergeSurvivor labeledSource 1 3 (by decide)) =
    activeMergeSurvivor labeledTarget (labeledEquiv.mergeLower 1 3)
      (labeledEquiv.mergeUpper 1 3) (labeledEquiv.merge_lt 1 3 (by decide)) :=
  ⟨weightedEquiv.mergeEquiv_survivor _ _ _, labeledEquiv.mergeEquiv_survivor _ _ _⟩

example (j : Fin 3) (hj : j ≠ activeMergeSurvivor weightedSource 1 3 (by decide)) :
    activeMergeRetained weightedTarget (weightedEquiv.mergeUpper 1 3)
      (weightedMerge.equiv j) = relabelCycle (activeMergeRetained weightedSource 3 j) :=
  weightedEquiv.mergeEquiv_unaffected 1 3 (by decide) j hj

example (j : Fin 3) (hj : j ≠ activeMergeSurvivor labeledSource 1 3 (by decide)) :
    activeMergeRetained labeledTarget (labeledEquiv.mergeUpper 1 3)
      (labeledMerge.equiv j) = relabelCycle (activeMergeRetained labeledSource 3 j) :=
  labeledEquiv.mergeEquiv_unaffected 1 3 (by decide) j hj

example (x : Bool) :
    ((ppm weightedSource weightedSource_singular 1 3 (by decide)
      (weighted_patterns 1 3)).channel x).map weightedMerge.equiv =
    (ppm weightedTarget (weightedEquiv.isSingular weightedSource_singular)
      (weightedEquiv.mergeLower 1 3) (weightedEquiv.mergeUpper 1 3)
      (weightedEquiv.merge_lt 1 3 (by decide))
      (weightedEquiv.ppmPattern 1 3 (weighted_patterns 1 3))).channel x :=
  weightedMerge.map_eq x

example (x : Fin 4) :
    ((vpm labeledSource labeledSource_singular 1 3 (by decide)
      (labeledSource_values 1 3) (labeledSource_disjoint 1 3 (by decide))).channel x).map
      labeledMerge.equiv =
    (vpm labeledTarget (labeledEquiv.isSingular labeledSource_singular)
      (labeledEquiv.mergeLower 1 3) (labeledEquiv.mergeUpper 1 3)
      (labeledEquiv.merge_lt 1 3 (by decide))
      (labeledEquiv.vpmValue labeledSource_singular 1 3 (labeledSource_values 1 3))
      (labeledEquiv.vpmDisjoint 1 3 (labeledSource_disjoint 1 3 (by decide)))).channel x :=
  labeledMerge.map_eq x

-- R06: exact C07 recovery states remain the concrete endpoints. Each cascade
-- stores the original operation parameters and its directed recovery bijection.
private def ppSplitRecovery (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1) : Cascade S S where
  endpoint := ppsRecovery S hS l t ht0 ht1
  path := (ppSplitPath S hS l t ht0 ht1).append (ppMergePath S hS l t ht0 ht1)
  outputEquiv := ⟨finCongr (ppsRecovery_outputCard S hS l t ht0 ht1),
    ppsRecovery_channel S hS l t ht0 ht1⟩

private def ppMergeRecovery (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) : Cascade S S where
  endpoint := ppmRecovery S hS a b hab hp
  path := (OperationPath.nil.snoc (.ppm S hS a b hab hp)).snoc
    (.pps _ (ppm_isSingular S hS a b hab hp) (activeMergeSurvivor S a b hab)
      (ppmRatio S hS a b) (ppmRatio_pos S hS a b) (ppmRatio_lt_one S hS a b))
  outputEquiv := ⟨ppmRecoveryEquiv S hS a b hab hp, ppmRecovery_channel S hS a b hab hp⟩

private def vpSplitRecovery (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (mask : alpha → Bool)
    (hl : ∃ x, S.channel x l ≠ 0 ∧ mask x = true)
    (hr : ∃ x, S.channel x l ≠ 0 ∧ mask x = false) : Cascade S S where
  endpoint := vpsRecovery S hS l mask hl hr
  path := (OperationPath.nil.snoc (.vps S hS l mask hl hr)).snoc
    (.vpm _ (vps_isSingular S hS l mask hl hr) (splitLeft l) (splitRight l)
      Fin.castSucc_lt_succ ((columnValue_vps_left S hS l mask hl hr).trans
        (columnValue_vps_right S hS l mask hl hr).symm)
      (vps_children_disjoint S hS l mask hl hr))
  outputEquiv := ⟨finCongr (vpsRecovery_outputCard S hS l mask hl hr),
    vpsRecovery_channel S hS l mask hl hr⟩

private def vpMergeRecovery (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (a b : Fin S.outputCard) (hab : a < b)
    (hv : columnValue S.channel hS (S.activeEquiv a) = columnValue S.channel hS (S.activeEquiv b))
    (hd : ∀ x, S.channel x a ≠ 0 → S.channel x b = 0) : Cascade S S where
  endpoint := vpmRecovery S hS a b hab hv hd
  path := (OperationPath.nil.snoc (.vpm S hS a b hab hv hd)).snoc
    (.vps _ (vpm_isSingular S hS a b hab hv hd) (activeMergeSurvivor S a b hab)
      (vpmRecoveryMask S a) (vpmRecovery_leftWitness S hS a b hab hv hd)
      (vpmRecovery_rightWitness S hS a b hab hv hd))
  outputEquiv := ⟨vpmRecoveryEquiv S hS a b hab hv hd,
    vpmRecovery_channel S hS a b hab hv hd⟩

example (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1) (x : alpha) :
    let c := ppSplitRecovery S hS l t ht0 ht1
    c.path.tags = [.pps, .ppm] ∧ (c.endpoint.channel x).map c.outputEquiv.equiv = S.channel x ∧
      (S.channel x).map c.outputEquiv.equiv.symm = c.endpoint.channel x :=
  ⟨rfl, (ppSplitRecovery S hS l t ht0 ht1).outputEquiv.map_eq x,
    (ppSplitRecovery S hS l t ht0 ht1).outputEquiv.symm.map_eq x⟩

example (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) (x : alpha) :
    let c := ppMergeRecovery S hS a b hab hp
    c.path.tags = [.ppm, .pps] ∧ (c.endpoint.channel x).map c.outputEquiv.equiv = S.channel x ∧
      (S.channel x).map c.outputEquiv.equiv.symm = c.endpoint.channel x :=
  ⟨rfl, (ppMergeRecovery S hS a b hab hp).outputEquiv.map_eq x,
    (ppMergeRecovery S hS a b hab hp).outputEquiv.symm.map_eq x⟩

example (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (mask : alpha → Bool)
    (hl : ∃ x, S.channel x l ≠ 0 ∧ mask x = true)
    (hr : ∃ x, S.channel x l ≠ 0 ∧ mask x = false) (x : alpha) :
    let c := vpSplitRecovery S hS l mask hl hr
    c.path.tags = [.vps, .vpm] ∧ (c.endpoint.channel x).map c.outputEquiv.equiv = S.channel x ∧
      (S.channel x).map c.outputEquiv.equiv.symm = c.endpoint.channel x :=
  ⟨rfl, (vpSplitRecovery S hS l mask hl hr).outputEquiv.map_eq x,
    (vpSplitRecovery S hS l mask hl hr).outputEquiv.symm.map_eq x⟩

example (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (a b : Fin S.outputCard) (hab : a < b)
    (hv : columnValue S.channel hS (S.activeEquiv a) = columnValue S.channel hS (S.activeEquiv b))
    (hd : ∀ x, S.channel x a ≠ 0 → S.channel x b = 0) (x : alpha) :
    let c := vpMergeRecovery S hS a b hab hv hd
    c.path.tags = [.vpm, .vps] ∧ (c.endpoint.channel x).map c.outputEquiv.equiv = S.channel x ∧
      (S.channel x).map c.outputEquiv.equiv.symm = c.endpoint.channel x :=
  ⟨rfl, (vpMergeRecovery S hS a b hab hv hd).outputEquiv.map_eq x,
    (vpMergeRecovery S hS a b hab hv hd).outputEquiv.symm.map_eq x⟩

private def concretePPRecovery :=
  ppMergeRecovery weightedSource weightedSource_singular 0 3 (by decide) (weighted_patterns 0 3)

private def concreteVPRecovery :=
  vpMergeRecovery labeledSource labeledSource_singular 0 3 (by decide)
    (labeledSource_values 0 3) (labeledSource_disjoint 0 3 (by decide))

example : concretePPRecovery.outputEquiv.equiv (1 : Fin 4) = (3 : Fin 4) ∧
    concretePPRecovery.outputEquiv.equiv.symm 1 = (2 : Fin 4) ∧
    concreteVPRecovery.outputEquiv.equiv (1 : Fin 4) = (3 : Fin 4) ∧
    concreteVPRecovery.outputEquiv.equiv.symm 1 = (2 : Fin 4) := by
  change recoveryPerm (0 : Fin 4) 3 _ 1 = 3 ∧
    (recoveryPerm (0 : Fin 4) 3 _).symm 1 = 2 ∧
    recoveryPerm (0 : Fin 4) 3 _ 1 = 3 ∧ (recoveryPerm (0 : Fin 4) 3 _).symm 1 = 2
  norm_num [Fin.ext_iff, recoveryPerm_val, recoveryPerm_symm_val]

-- The reverse recovery equation needs the inverse three-cycle. Unequal masses
-- make using its forward direction on the original row detectably false.
example : (weightedSource.channel true).map concretePPRecovery.outputEquiv.equiv ≠
    concretePPRecovery.endpoint.channel true := by
  intro h
  have h1 : concretePPRecovery.outputEquiv.equiv (1 : Fin 4) = (3 : Fin 4) := by
    change recoveryPerm (0 : Fin 4) 3 _ 1 = 3
    apply Fin.ext
    norm_num [recoveryPerm_val]
  have h3 : concretePPRecovery.outputEquiv.equiv (3 : Fin 4) = (2 : Fin 4) := by
    change recoveryPerm (0 : Fin 4) 3 _ 3 = 2
    apply Fin.ext
    norm_num [recoveryPerm_val]
  have hlookup := (PMF.map_apply_equiv (weightedSource.channel true)
    concretePPRecovery.outputEquiv.equiv (1 : Fin 4)).symm.trans
      (congrArg (fun p => p (concretePPRecovery.outputEquiv.equiv (1 : Fin 4))) h)
  have horiginal := concretePPRecovery.outputEquiv.apply true (3 : Fin 4)
  rw [h1] at hlookup
  rw [h3] at horiginal
  have hbad := hlookup.trans horiginal.symm
  change ((2 / 10 : NNReal) : ENNReal) = ((3 / 10 : NNReal) : ENNReal) at hbad
  have hbad' := ENNReal.coe_inj.mp hbad
  norm_num at hbad'

-- Transport a mixed path through the non-involutive equivalence. The terminal
-- comparison maps the newly constructed endpoint back to the old endpoint.
example : (concretePPRecovery.path.transport weightedEquiv).path.tags = [.ppm, .pps] ∧
    ¬ (concretePPRecovery.path.transport weightedEquiv).path.Homogeneous .pps := by
  constructor
  · exact (concretePPRecovery.path.transport weightedEquiv).tags_eq
  · rw [OperationPath.transport_homogeneous]
    change ¬ (∀ k ∈ [OperationKind.ppm, .pps], k = .pps)
    decide

example (x : Bool) :
    ((concretePPRecovery.path.transport weightedEquiv).endpoint.channel x).map
      (concretePPRecovery.path.transport weightedEquiv).outputEquiv.equiv =
        concretePPRecovery.endpoint.channel x :=
  (concretePPRecovery.path.transport weightedEquiv).outputEquiv.map_eq x

private def mixedCascade : Cascade weightedSource weightedTarget :=
  (ppSplitRecovery weightedSource weightedSource_singular 0 (1 / 3)
    (by norm_num) (by norm_num)).comp
    ((vpSplitRecovery weightedSource weightedSource_singular 3 id
      (weighted_left 3) (weighted_right 3)).comp (Cascade.ofOutputEquiv weightedEquiv))

-- A relabeling before a nonempty path forces comp to use its inverse. The
-- target's selected label is e(3), but the concrete result splits source 3.
private def relabelThenSplit := (Cascade.ofOutputEquiv weightedEquiv).comp
  (Cascade.ofPath (OperationPath.nil.snoc (.pps weightedTarget
    (weightedEquiv.isSingular weightedSource_singular) (weightedEquiv.equiv (3 : Fin 4))
    (1 / 3) (by norm_num) (by norm_num))))

example : relabelThenSplit.path.tags = [.pps] ∧
    relabelThenSplit.endpoint.channel true (splitLeft (3 : Fin 4)) =
      ((2 / 15 : NNReal) : ENNReal) := by
  constructor
  · simp [relabelThenSplit, Cascade.ofOutputEquiv, Cascade.ofPath, OperationStep.kind]
  · change ppsRaw weightedSource.channel (weightedEquiv.equiv.symm
      (weightedEquiv.equiv (3 : Fin 4))) (1 / 3) _ true (splitLeft (3 : Fin 4)) = _
    rw [Equiv.symm_apply_apply, ppsRaw_left]
    change ((1 / 3 : NNReal) : ENNReal) * (transportWeights 3 : ENNReal) = _
    rw [← ENNReal.coe_mul]
    have hnum : (1 / 3 : NNReal) * transportWeights 3 = 2 / 15 := by
      norm_num [transportWeights, Matrix.cons_val_three]
    exact congrArg (fun q : NNReal => (q : ENNReal)) hnum

example : mixedCascade.path.tags = [.pps, .ppm, .vps, .vpm] ∧
    mixedCascade.path.length = 4 := by
  have htags : mixedCascade.path.tags = [.pps, .ppm, .vps, .vpm] := by
    simp only [mixedCascade, Cascade.tags_comp]
    rfl
  exact ⟨htags, by
    simpa only [OperationPath.tags_length, List.length_cons, List.length_nil]
      using congrArg List.length htags⟩

example {S T U V : ActiveFiniteChannel alpha} (c : Cascade S T) (d : Cascade T U)
    (f : Cascade U V) (P : OperationKind → Prop) (x : alpha) :
    ((Cascade.refl S).comp c).path.tags = c.path.tags ∧
    (c.comp (Cascade.refl T)).path.tags = c.path.tags ∧
    ((c.comp d).comp f).path.tags = (c.comp (d.comp f)).path.tags ∧
    ((c.comp d).path.Allowed P ↔ c.path.Allowed P ∧ d.path.Allowed P) ∧
    (((Cascade.refl S).comp c).endpoint.channel x).map (Cascade.refl_comp c).equiv =
      c.endpoint.channel x ∧
    ((c.comp (Cascade.refl T)).endpoint.channel x).map (Cascade.comp_refl c).equiv =
      c.endpoint.channel x ∧
    (((c.comp d).comp f).endpoint.channel x).map (Cascade.comp_assoc c d f).equiv =
      (c.comp (d.comp f)).endpoint.channel x :=
  ⟨Cascade.tags_refl_comp c, Cascade.tags_comp_refl c, Cascade.tags_comp_assoc c d f,
    Cascade.allowed_comp c d P, (Cascade.refl_comp c).map_eq x,
    (Cascade.comp_refl c).map_eq x, (Cascade.comp_assoc c d f).map_eq x⟩

end

end PerfectFunctionalRepresentations.MatrixOperations
