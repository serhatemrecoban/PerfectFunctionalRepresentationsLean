import PerfectFunctionalRepresentations.Matrix.OperationCalculus

namespace PerfectFunctionalRepresentations.MatrixOperations
noncomputable section
open scoped ENNReal BigOperators
universe u
variable {alpha : Type u} [Finite alpha] [Nonempty alpha]

-- These initial package consumers use the public path/equivalence API.
variable {S T U : ActiveFiniteChannel alpha}

example (S : ActiveFiniteChannel alpha) : (NormalForm.refl S).toCascade.path.tags = [] := rfl

example (e : OutputEquiv S T) : (NormalForm.ofOutputEquiv e).toCascade.path.tags = [] := rfl

example (e : OutputEquiv S T) :
    (NormalForm.ofOutputEquiv e).toCascade.outputEquiv.equiv = e.equiv := rfl

example (nf : NormalForm S T) (e : OutputEquiv T U) (x : alpha) :
    (nf.pmEndpoint.channel x).map (nf.outputEquiv.equiv.trans e.equiv) = U.channel x :=
  (nf.transOutputEquiv e).outputEquiv.map_eq x

example (nf : NormalForm S T) (hS : IsSingularChannel S.channel) :
    IsSingularChannel nf.ppEndpoint.channel ∧ IsSingularChannel nf.vpEndpoint.channel ∧
      IsSingularChannel nf.pmEndpoint.channel ∧ IsSingularChannel T.channel :=
  ⟨nf.pp_isSingular hS, nf.vp_isSingular hS, nf.pm_isSingular hS, nf.isSingular hS⟩

example (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1) :
    let p := (OperationPath.nil : OperationPath S S).snoc (.pps S hS l t ht0 ht1)
    (NormalForm.ofPps p (by
      simp [p, OperationPath.Homogeneous, OperationPath.Allowed,
        OperationStep.kind])).toCascade.path.tags = [.pps] := by
  simp [NormalForm.ofPps, NormalForm.toCascade, OperationStep.kind]

example (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (mask : alpha → Bool)
    (hl : ∃ x, S.channel x l ≠ 0 ∧ mask x = true)
    (hr : ∃ x, S.channel x l ≠ 0 ∧ mask x = false) :
    let p := (OperationPath.nil : OperationPath S S).snoc (.vps S hS l mask hl hr)
    (NormalForm.ofVps p (by
      simp [p, OperationPath.Homogeneous, OperationPath.Allowed,
        OperationStep.kind])).toCascade.path.tags = [.vps] := by
  simp [NormalForm.ofVps, NormalForm.toCascade, OperationStep.kind]

example (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (a b : Fin S.outputCard) (hab : a < b)
    (hpattern : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) :
    let p := (OperationPath.nil : OperationPath S S).snoc (.ppm S hS a b hab hpattern)
    (NormalForm.ofPpm p (by
      simp [p, OperationPath.Homogeneous, OperationPath.Allowed,
        OperationStep.kind])).toCascade.path.tags = [.ppm] := by
  simp [NormalForm.ofPpm, NormalForm.toCascade, OperationStep.kind]


-- R14: an all-empty witness preserves the original channel and every stage boundary.
example (S : ActiveFiniteChannel alpha) :
    let nf := NormalForm.refl S
    nf.pp.tags = [] ∧ nf.vp.tags = [] ∧ nf.pm.tags = [] ∧
      nf.pmEndpoint.outputCard = S.outputCard ∧
      ∀ x, (nf.pmEndpoint.channel x).map nf.outputEquiv.equiv = S.channel x := by
  exact ⟨rfl, rfl, rfl, rfl, fun x => (NormalForm.refl S).outputEquiv.map_eq x⟩

-- Each one-operation witness admits exactly the other two empty stages.
example (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1) :
    let p := (OperationPath.nil : OperationPath S S).snoc (.pps S hS l t ht0 ht1)
    let nf := NormalForm.ofPps p (by
      simp [p, OperationPath.Homogeneous, OperationPath.Allowed, OperationStep.kind])
    nf.pp.tags = [.pps] ∧ nf.vp.tags = [] ∧ nf.pm.tags = [] := by
  exact ⟨rfl, rfl, rfl⟩

example (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (mask : alpha → Bool)
    (hl : ∃ x, S.channel x l ≠ 0 ∧ mask x = true)
    (hr : ∃ x, S.channel x l ≠ 0 ∧ mask x = false) :
    let p := (OperationPath.nil : OperationPath S S).snoc (.vps S hS l mask hl hr)
    let nf := NormalForm.ofVps p (by
      simp [p, OperationPath.Homogeneous, OperationPath.Allowed, OperationStep.kind])
    nf.pp.tags = [] ∧ nf.vp.tags = [.vps] ∧ nf.pm.tags = [] := by
  exact ⟨rfl, rfl, rfl⟩

example (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) :
    let p := (OperationPath.nil : OperationPath S S).snoc (.ppm S hS a b hab hp)
    let nf := NormalForm.ofPpm p (by
      simp [p, OperationPath.Homogeneous, OperationPath.Allowed, OperationStep.kind])
    nf.pp.tags = [] ∧ nf.vp.tags = [] ∧ nf.pm.tags = [.ppm] := by
  exact ⟨rfl, rfl, rfl⟩

-- R16: the package restores the actual final cardinality, with every output active.
example (nf : NormalForm S T) :
    nf.pmEndpoint.outputCard = T.outputCard ∧
      (∀ j, ∃ x, 0 < nf.ppEndpoint.channel x j) ∧
      (∀ j, ∃ x, 0 < nf.vpEndpoint.channel x j) ∧
      (∀ j, ∃ x, 0 < nf.pmEndpoint.channel x j) := by
  refine ⟨nf.outputEquiv.outputCard_eq, ?_, ?_, ?_⟩
  · intro j
    obtain ⟨x, hx⟩ := nf.ppEndpoint.output_active j
    exact ⟨x, pos_iff_ne_zero.mpr hx⟩
  · intro j
    obtain ⟨x, hx⟩ := nf.vpEndpoint.output_active j
    exact ⟨x, pos_iff_ne_zero.mpr hx⟩
  · intro j
    obtain ⟨x, hx⟩ := nf.pmEndpoint.output_active j
    exact ⟨x, pos_iff_ne_zero.mpr hx⟩

example (nf : NormalForm S T) :
    OperationKind.vpm ∉ nf.pp.tags ∧ OperationKind.vpm ∉ nf.vp.tags ∧
      OperationKind.vpm ∉ nf.pm.tags ∧ OperationKind.vpm ∉ nf.toCascade.path.tags := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro h
    cases nf.pp_homogeneous .vpm h
  · intro h
    cases nf.vp_homogeneous .vpm h
  · intro h
    cases nf.pm_homogeneous .vpm h
  · intro h
    rcases nf.toCascade_normalizing .vpm h with h | h | h <;> cases h

-- Every intermediate admitted column has a strictly positive, finite value.
example (nf : NormalForm S T) (hS : IsSingularChannel S.channel) :
    (∀ j, 0 < columnValue nf.ppEndpoint.channel (nf.pp_isSingular hS)
      (nf.ppEndpoint.activeEquiv j)) ∧
    (∀ j, 0 < columnValue nf.vpEndpoint.channel (nf.vp_isSingular hS)
      (nf.vpEndpoint.activeEquiv j)) ∧
    (∀ j, 0 < columnValue nf.pmEndpoint.channel (nf.pm_isSingular hS)
      (nf.pmEndpoint.activeEquiv j)) ∧
    (∀ j, columnValue nf.pmEndpoint.channel (nf.pm_isSingular hS)
      (nf.pmEndpoint.activeEquiv j) ≠ ⊤) := by
  exact ⟨fun _ => columnValue_pos _ _ _, fun _ => columnValue_pos _ _ _,
    fun _ => columnValue_pos _ _ _, fun _ => columnValue_ne_top _ _ _⟩

-- R14 consumes the global theorem on nil and every allowed one-operation path.
example (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel) :
    ∃ nf : NormalForm S S, nf.pmEndpoint.outputCard = S.outputCard ∧
      ∀ x, (nf.pmEndpoint.channel x).map nf.outputEquiv.equiv = S.channel x := by
  obtain ⟨nf⟩ := (OperationPath.nil : OperationPath S S).normalize hS
    (OperationPath.allowed_nil _)
  exact ⟨nf, nf.outputEquiv.outputCard_eq, nf.outputEquiv.map_eq⟩

example (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1) :
    ∃ nf : NormalForm S (pps S hS l t ht0 ht1),
      nf.pmEndpoint.outputCard = S.outputCard + 1 ∧
      ∀ x, (nf.pmEndpoint.channel x).map nf.outputEquiv.equiv =
        (pps S hS l t ht0 ht1).channel x := by
  let p := (OperationPath.nil : OperationPath S S).snoc (.pps S hS l t ht0 ht1)
  obtain ⟨nf⟩ := p.normalize hS (by
    simp [p, OperationPath.Normalizing, OperationPath.Allowed, OperationStep.kind])
  exact ⟨nf, nf.outputEquiv.outputCard_eq, nf.outputEquiv.map_eq⟩

example (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (mask : alpha → Bool)
    (hl : ∃ x, S.channel x l ≠ 0 ∧ mask x = true)
    (hr : ∃ x, S.channel x l ≠ 0 ∧ mask x = false) :
    ∃ nf : NormalForm S (vps S hS l mask hl hr),
      nf.pmEndpoint.outputCard = S.outputCard + 1 ∧
      ∀ x, (nf.pmEndpoint.channel x).map nf.outputEquiv.equiv =
        (vps S hS l mask hl hr).channel x := by
  let p := (OperationPath.nil : OperationPath S S).snoc (.vps S hS l mask hl hr)
  obtain ⟨nf⟩ := p.normalize hS (by
    simp [p, OperationPath.Normalizing, OperationPath.Allowed, OperationStep.kind])
  exact ⟨nf, nf.outputEquiv.outputCard_eq, nf.outputEquiv.map_eq⟩

example (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) :
    ∃ nf : NormalForm S (ppm S hS a b hab hp),
      nf.pmEndpoint.outputCard = S.outputCard - 1 ∧
      ∀ x, (nf.pmEndpoint.channel x).map nf.outputEquiv.equiv =
        (ppm S hS a b hab hp).channel x := by
  let p := (OperationPath.nil : OperationPath S S).snoc (.ppm S hS a b hab hp)
  obtain ⟨nf⟩ := p.normalize hS (by
    simp [p, OperationPath.Normalizing, OperationPath.Allowed, OperationStep.kind])
  exact ⟨nf, nf.outputEquiv.outputCard_eq, nf.outputEquiv.map_eq⟩

-- The cascade theorem returns to its named endpoint, including its output cardinality.
example (c : Cascade S T) (hS : IsSingularChannel S.channel) (hp : c.path.Normalizing) :
    ∃ nf : NormalForm S T, nf.pmEndpoint.outputCard = T.outputCard ∧
      ∀ x, (nf.pmEndpoint.channel x).map nf.outputEquiv.equiv = T.channel x := by
  obtain ⟨nf⟩ := c.normalize hS hp
  exact ⟨nf, nf.outputEquiv.outputCard_eq, nf.outputEquiv.map_eq⟩


private def sgMixedWeights : Fin 3 → NNReal := ![1 / 6, 1 / 3, 1 / 2]

private theorem sgMixedWeights_sum : ∑ j, sgMixedWeights j = 1 := by
  norm_num [sgMixedWeights, Fin.sum_univ_succ]

private theorem sgMixedWeights_pos (j : Fin 3) : (sgMixedWeights j : ENNReal) ≠ 0 := by
  rw [ENNReal.coe_ne_zero]
  fin_cases j <;> norm_num [sgMixedWeights]

private abbrev sgMixedSource : ActiveFiniteChannel Bool where
  outputCard := 3
  outputCard_pos := by decide
  channel := fun _ => PMF.ofFintype (fun j => (sgMixedWeights j : ENNReal))
    (by exact_mod_cast sgMixedWeights_sum)
  output_active j := ⟨true, sgMixedWeights_pos j⟩

private theorem sgMixedSource_singular : IsSingularChannel sgMixedSource.channel := by
  intro x z j _ _
  rfl

private theorem sgMixedPattern (x : Bool) :
    sgMixedSource.channel x (0 : Fin 3) ≠ 0 ↔ sgMixedSource.channel x (2 : Fin 3) ≠ 0 :=
  iff_of_true (sgMixedWeights_pos 0) (sgMixedWeights_pos 2)

private abbrev sgMixedMerged :=
  ppm sgMixedSource sgMixedSource_singular (0 : Fin 3) (2 : Fin 3) (by decide) sgMixedPattern

private theorem sgMixedMerged_singular : IsSingularChannel sgMixedMerged.channel :=
  ppm_isSingular _ _ _ _ _ _

private theorem sgMixedMerged_zero (x : Bool) :
    sgMixedMerged.channel x (0 : Fin 2) = ((2 / 3 : NNReal) : ENNReal) := by
  have hs : activeMergeSurvivor sgMixedSource 0 2 (by decide) = (0 : Fin 2) := by
    apply Fin.ext
    exact activeMergeSurvivor_val _ _ _ _
  have hc := ppm_apply_survivor sgMixedSource sgMixedSource_singular (0 : Fin 3) (2 : Fin 3)
    (by decide) sgMixedPattern x
  rw [hs] at hc
  refine hc.trans ?_
  change ((1 / 6 : NNReal) : ENNReal) + ((1 / 2 : NNReal) : ENNReal) = _
  rw [← ENNReal.coe_add]
  exact congrArg (fun q : NNReal => (q : ENNReal)) (by norm_num)

private theorem sgMixedMerged_one (x : Bool) :
    sgMixedMerged.channel x (1 : Fin 2) = ((1 / 3 : NNReal) : ENNReal) := by
  have hs : activeMergeSurvivor sgMixedSource 0 2 (by decide) = (0 : Fin 2) := by
    apply Fin.ext
    exact activeMergeSurvivor_val _ _ _ _
  have hc := ppm_apply_unaffected sgMixedSource sgMixedSource_singular (0 : Fin 3) (2 : Fin 3)
    (by decide) sgMixedPattern x (j := (1 : Fin 2)) (by rw [hs]; decide)
  exact hc.trans (by rfl)

private theorem sgMixedLeft :
    ∃ x, sgMixedMerged.channel x (0 : Fin 2) ≠ 0 ∧ id x = true := by
  exact ⟨true, by rw [sgMixedMerged_zero]; norm_num, rfl⟩

private theorem sgMixedRight :
    ∃ x, sgMixedMerged.channel x (0 : Fin 2) ≠ 0 ∧ id x = false := by
  exact ⟨false, by rw [sgMixedMerged_zero]; norm_num, rfl⟩

private abbrev sgMixedRefined :=
  vps sgMixedMerged sgMixedMerged_singular (0 : Fin 2) id sgMixedLeft sgMixedRight

private theorem sgMixedRefined_singular : IsSingularChannel sgMixedRefined.channel :=
  vps_isSingular _ _ _ _ _ _

private theorem sgMixedRefined_zero (x : Bool) :
    sgMixedRefined.channel x (0 : Fin 3) = if x then ((2 / 3 : NNReal) : ENNReal) else 0 := by
  exact (vps_left sgMixedMerged sgMixedMerged_singular (0 : Fin 2) id
    sgMixedLeft sgMixedRight x).trans
    (by simp only [id_eq, sgMixedMerged_zero])

private theorem sgMixedRefined_one (x : Bool) :
    sgMixedRefined.channel x (1 : Fin 3) = if x then 0 else ((2 / 3 : NNReal) : ENNReal) := by
  exact (vps_right sgMixedMerged sgMixedMerged_singular (0 : Fin 2) id
    sgMixedLeft sgMixedRight x).trans
    (by simp only [id_eq, sgMixedMerged_zero])

private theorem sgMixedRefined_two (x : Bool) :
    sgMixedRefined.channel x (2 : Fin 3) = ((1 / 3 : NNReal) : ENNReal) :=
  (vps_keep sgMixedMerged sgMixedMerged_singular (0 : Fin 2) id sgMixedLeft sgMixedRight x
    (j := (1 : Fin 2)) (by exact (by decide : (1 : Fin 2) ≠ 0))).trans
      (sgMixedMerged_one x)

private abbrev sgMixedEndpoint :=
  pps sgMixedRefined sgMixedRefined_singular (0 : Fin 3) (1 / 4) (by norm_num) (by norm_num)

private theorem sgMixedEndpoint_coordinates (x : Bool) (j : Fin 4) :
    sgMixedEndpoint.channel x j =
      if x then ![((1 / 6 : NNReal) : ENNReal), ((1 / 2 : NNReal) : ENNReal), 0,
        ((1 / 3 : NNReal) : ENNReal)] j
      else ![0, 0, ((2 / 3 : NNReal) : ENNReal), ((1 / 3 : NNReal) : ENNReal)] j := by
  fin_cases j
  · have hc := pps_left sgMixedRefined sgMixedRefined_singular (0 : Fin 3) (1 / 4)
      (by norm_num) (by norm_num) x
    refine hc.trans ?_
    rw [sgMixedRefined_zero]
    cases x
    · simp
    · change ((1 / 4 : NNReal) : ENNReal) * ((2 / 3 : NNReal) : ENNReal) = _
      rw [← ENNReal.coe_mul]
      exact congrArg (fun q : NNReal => (q : ENNReal)) (by norm_num)
  · have hc := pps_right sgMixedRefined sgMixedRefined_singular (0 : Fin 3) (1 / 4)
      (by norm_num) (by norm_num) x
    refine hc.trans ?_
    rw [sgMixedRefined_zero]
    cases x
    · simp
    · change ((1 - 1 / 4 : NNReal) : ENNReal) * ((2 / 3 : NNReal) : ENNReal) = _
      rw [← ENNReal.coe_mul]
      congr 1
      apply NNReal.eq
      rw [NNReal.coe_mul, NNReal.coe_sub (le_of_lt (by norm_num : (1 / 4 : NNReal) < 1))]
      norm_num
  · have hc := pps_keep sgMixedRefined sgMixedRefined_singular (0 : Fin 3) (1 / 4)
      (by norm_num) (by norm_num) x (j := (1 : Fin 3))
      (by exact (by decide : (1 : Fin 3) ≠ 0))
    exact hc.trans (by rw [sgMixedRefined_one]; cases x <;> norm_num)
  · have hc := pps_keep sgMixedRefined sgMixedRefined_singular (0 : Fin 3) (1 / 4)
      (by norm_num) (by norm_num) x (j := (2 : Fin 3))
      (by exact (by decide : (2 : Fin 3) ≠ 0))
    exact hc.trans (by rw [sgMixedRefined_two]; cases x <;> norm_num)

private def sgMixedPath : OperationPath sgMixedSource sgMixedEndpoint :=
  ((OperationPath.nil.snoc
    (.ppm sgMixedSource sgMixedSource_singular (0 : Fin 3) (2 : Fin 3)
      (by decide) sgMixedPattern)).snoc
      (.vps sgMixedMerged sgMixedMerged_singular (0 : Fin 2) id sgMixedLeft sgMixedRight)).snoc
        (.pps sgMixedRefined sgMixedRefined_singular (0 : Fin 3) (1 / 4)
          (by norm_num) (by norm_num))

private theorem sgMixedPath_tags : sgMixedPath.tags = [.ppm, .vps, .pps] := rfl

private theorem sgMixedPath_normalizing : sgMixedPath.Normalizing := by
  intro k hk
  rw [sgMixedPath_tags] at hk
  simp only [List.mem_cons, List.not_mem_nil, or_false] at hk
  rcases hk with rfl | rfl | rfl <;> simp

private def sgMixedPermutation : Fin 4 ≃ Fin 4 := recoveryPerm 0 3 (by decide)

private abbrev sgMixedTarget : ActiveFiniteChannel Bool :=
  ActiveFiniteChannel.ofActive sgMixedEndpoint.channel sgMixedPermutation
    sgMixedEndpoint.output_active

private def sgMixedOutputEquiv : OutputEquiv sgMixedEndpoint sgMixedTarget where
  equiv := sgMixedPermutation
  map_eq _ := rfl

private def sgMixedCascade : Cascade sgMixedSource sgMixedTarget where
  endpoint := sgMixedEndpoint
  path := sgMixedPath
  outputEquiv := sgMixedOutputEquiv

private theorem sgMixedPermutation_symm (j : Fin 4) :
    sgMixedPermutation.symm j = ![0, 2, 3, 1] j := by
  fin_cases j <;> apply Fin.ext
  all_goals exact recoveryPerm_symm_val (0 : Fin 4) 3 (by decide) _

private theorem sgMixedTarget_coordinates (x : Bool) (j : Fin 4) :
    sgMixedTarget.channel x j =
      if x then ![((1 / 6 : NNReal) : ENNReal), 0, ((1 / 3 : NNReal) : ENNReal),
        ((1 / 2 : NNReal) : ENNReal)] j
      else ![0, ((2 / 3 : NNReal) : ENNReal), ((1 / 3 : NNReal) : ENNReal), 0] j := by
  have hc := (sgMixedOutputEquiv.apply_symm x j).symm.trans
    (sgMixedEndpoint_coordinates x (sgMixedPermutation.symm j))
  rw [sgMixedPermutation_symm] at hc
  fin_cases j <;> cases x <;> exact hc

example : sgMixedSource.outputCard = 3 ∧ sgMixedMerged.outputCard = 2 ∧
    sgMixedRefined.outputCard = 3 ∧ sgMixedEndpoint.outputCard = 4 :=
  ⟨rfl, rfl, rfl, rfl⟩

example : sgMixedCascade.path.tags = [.ppm, .vps, .pps] ∧
    sgMixedCascade.path.Normalizing := ⟨sgMixedPath_tags, sgMixedPath_normalizing⟩

example : sgMixedOutputEquiv.equiv (1 : Fin 4) = (3 : Fin 4) ∧
    sgMixedOutputEquiv.equiv.symm (1 : Fin 4) = (2 : Fin 4) := by
  constructor <;> apply Fin.ext
  · exact recoveryPerm_val (0 : Fin 4) 3 (by decide) 1
  · exact recoveryPerm_symm_val (0 : Fin 4) 3 (by decide) 1

example (x : Bool) :
    (sgMixedEndpoint.channel x).map sgMixedOutputEquiv.equiv = sgMixedTarget.channel x ∧
      (sgMixedTarget.channel x).map sgMixedOutputEquiv.equiv.symm =
        sgMixedEndpoint.channel x :=
  ⟨sgMixedOutputEquiv.map_eq x, sgMixedOutputEquiv.symm.map_eq x⟩

example (x : Bool) (j : Fin 4) :
    sgMixedTarget.channel x (sgMixedOutputEquiv.equiv j) =
      if x then ![((1 / 6 : NNReal) : ENNReal), ((1 / 2 : NNReal) : ENNReal), 0,
        ((1 / 3 : NNReal) : ENNReal)] j
      else ![0, 0, ((2 / 3 : NNReal) : ENNReal), ((1 / 3 : NNReal) : ENNReal)] j :=
  (sgMixedOutputEquiv.apply x j).trans (sgMixedEndpoint_coordinates x j)

example (x : Bool) (j : Fin 4) :
    sgMixedTarget.channel x j =
      if x then ![((1 / 6 : NNReal) : ENNReal), 0, ((1 / 3 : NNReal) : ENNReal),
        ((1 / 2 : NNReal) : ENNReal)] j
      else ![0, ((2 / 3 : NNReal) : ENNReal), ((1 / 3 : NNReal) : ENNReal), 0] j :=
  sgMixedTarget_coordinates x j


-- Consume the public theorem on the concrete mixed path and on its asymmetric
-- final relabeling. These examples inspect the resulting directed comparison.
example : Nonempty (NormalForm sgMixedSource sgMixedEndpoint) :=
  sgMixedPath.normalize sgMixedSource_singular sgMixedPath_normalizing

example : ∃ nf : NormalForm sgMixedSource sgMixedTarget,
    nf.pmEndpoint.outputCard = 4 ∧
      (∀ x : Bool, (nf.pmEndpoint.channel x).map
        (nf.outputEquiv.trans sgMixedOutputEquiv.symm).equiv = sgMixedEndpoint.channel x) ∧
      (∀ (x : Bool) (j : Fin 4),
        nf.pmEndpoint.channel x (nf.outputEquiv.equiv.symm j) =
          if x then ![((1 / 6 : NNReal) : ENNReal), 0, ((1 / 3 : NNReal) : ENNReal),
            ((1 / 2 : NNReal) : ENNReal)] j
          else ![0, ((2 / 3 : NNReal) : ENNReal), ((1 / 3 : NNReal) : ENNReal), 0] j) := by
  obtain ⟨nf⟩ := sgMixedCascade.normalize sgMixedSource_singular sgMixedPath_normalizing
  exact ⟨nf, nf.outputEquiv.outputCard_eq,
    fun x => (nf.outputEquiv.trans sgMixedOutputEquiv.symm).map_eq x,
    fun x j => (nf.outputEquiv.apply_symm x j).trans (sgMixedTarget_coordinates x j)⟩

-- R17: extract actual typed stages from the public theorem. Their tag words
-- retain both chronological order and the exact number of each operation.
example (p : OperationPath S T) (hS : IsSingularChannel S.channel)
    (hp : p.Normalizing) :
    ∃ (A B C : ActiveFiniteChannel alpha) (pp : OperationPath S A)
      (vp : OperationPath A B) (pm : OperationPath B C) (e : OutputEquiv C T),
      pp.tags = List.replicate pp.length .pps ∧
      vp.tags = List.replicate vp.length .vps ∧
      pm.tags = List.replicate pm.length .ppm ∧
      ((pp.append vp).append pm).tags =
        (List.replicate pp.length .pps ++ List.replicate vp.length .vps) ++
          List.replicate pm.length .ppm ∧
      IsSingularChannel A.channel ∧ IsSingularChannel B.channel ∧
      IsSingularChannel C.channel ∧
      ∀ x, (C.channel x).map e.equiv = T.channel x := by
  obtain ⟨nf⟩ := p.normalize hS hp
  have hpp : nf.pp.tags = List.replicate nf.pp.length .pps := by
    simpa only [OperationPath.tags_length] using
      List.eq_replicate_length.mpr nf.pp_homogeneous
  have hvp : nf.vp.tags = List.replicate nf.vp.length .vps := by
    simpa only [OperationPath.tags_length] using
      List.eq_replicate_length.mpr nf.vp_homogeneous
  have hpm : nf.pm.tags = List.replicate nf.pm.length .ppm := by
    simpa only [OperationPath.tags_length] using
      List.eq_replicate_length.mpr nf.pm_homogeneous
  refine ⟨nf.ppEndpoint, nf.vpEndpoint, nf.pmEndpoint, nf.pp, nf.vp, nf.pm,
    nf.outputEquiv, hpp, hvp, hpm, ?_, nf.pp_isSingular hS, nf.vp_isSingular hS,
    nf.pm_isSingular hS, nf.outputEquiv.map_eq⟩
  rw [OperationPath.tags_append, OperationPath.tags_append, hpp, hvp, hpm]

-- R18: these Type-valued folds inspect the recorded legal parameters by path
-- induction. The mask record retains its actual intermediate source state.
attribute [local instance] operationQuiver

private def s06EdgeRatios {S T : ActiveFiniteChannel alpha} (edge : OperationStep S T) :
    List {t : NNReal // 0 < t ∧ t < 1} :=
  match edge with
  | .pps _ _ _ t ht0 ht1 => [⟨t, ht0, ht1⟩]
  | .vps .. | .ppm .. | .vpm .. => []

private def s06Ratios {S : ActiveFiniteChannel alpha} :
    {T : ActiveFiniteChannel alpha} → OperationPath S T →
      List {t : NNReal // 0 < t ∧ t < 1}
  | _, .nil => []
  | _, .cons q edge => s06Ratios q ++ s06EdgeRatios edge

private structure s06MaskRecord (alpha : Type u) [Finite alpha] [Nonempty alpha] where
  source : ActiveFiniteChannel alpha
  singular : IsSingularChannel source.channel
  selected : Fin source.outputCard
  mask : alpha → Bool
  left : ∃ x, source.channel x selected ≠ 0 ∧ mask x = true
  right : ∃ x, source.channel x selected ≠ 0 ∧ mask x = false

private def s06EdgeMasks {S T : ActiveFiniteChannel alpha} (edge : OperationStep S T) :
    List (s06MaskRecord alpha) :=
  match edge with
  | .vps _ hSource selected mask hl hr =>
      [⟨S, hSource, selected, mask, hl, hr⟩]
  | .pps .. | .ppm .. | .vpm .. => []

private def s06Masks {S : ActiveFiniteChannel alpha} :
    {T : ActiveFiniteChannel alpha} → OperationPath S T → List (s06MaskRecord alpha)
  | _, .nil => []
  | _, .cons q edge => s06Masks q ++ s06EdgeMasks edge

private theorem s06Ratios_length (p : OperationPath S T) :
    p.Homogeneous .pps → (s06Ratios p).length = p.length := by
  induction p with
  | nil => intro _; rfl
  | cons p edge ih =>
      intro hp
      have h := (OperationPath.allowed_snoc (· = .pps) p edge).mp hp
      cases edge with
      | pps hSource selected t ht0 ht1 =>
          change (s06Ratios p ++
            ([⟨t, ht0, ht1⟩] : List {t : NNReal // 0 < t ∧ t < 1})).length = p.length + 1
          rw [List.length_append, ih h.1]
          rfl
      | vps => cases h.2
      | ppm => cases h.2
      | vpm => cases h.2

private theorem s06Masks_length (p : OperationPath S T) :
    p.Homogeneous .vps → (s06Masks p).length = p.length := by
  induction p with
  | nil => intro _; rfl
  | cons p edge ih =>
      intro hp
      have h := (OperationPath.allowed_snoc (· = .vps) p edge).mp hp
      cases edge with
      | vps hSource selected mask hl hr =>
          change (s06Masks p ++
            [(⟨_, hSource, selected, mask, hl, hr⟩ : s06MaskRecord alpha)]).length =
              p.length + 1
          rw [List.length_append, ih h.1]
          rfl
      | pps => cases h.2
      | ppm => cases h.2
      | vpm => cases h.2

example (nf : NormalForm S T) :
    (s06Ratios nf.pp).length = nf.pp.length ∧
      (s06Masks nf.vp).length = nf.vp.length ∧
      (∀ t ∈ s06Ratios nf.pp, 0 < t.val ∧ t.val < 1) ∧
      (∀ m ∈ s06Masks nf.vp, IsSingularChannel m.source.channel ∧
        (∃ x, m.source.channel x m.selected ≠ 0 ∧ m.mask x = true) ∧
        (∃ x, m.source.channel x m.selected ≠ 0 ∧ m.mask x = false)) :=
  ⟨s06Ratios_length nf.pp nf.pp_homogeneous, s06Masks_length nf.vp nf.vp_homogeneous,
    fun t _ => t.property, fun m _ => ⟨m.singular, m.left, m.right⟩⟩

example (p : OperationPath S T) (hT : IsSingularChannel T.channel)
    (l : Fin T.outputCard) (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1) :
    s06Ratios (p.snoc (.pps T hT l t ht0 ht1)) = s06Ratios p ++ [⟨t, ht0, ht1⟩] := rfl

example (p : OperationPath S T) (hT : IsSingularChannel T.channel)
    (l : Fin T.outputCard) (mask : alpha → Bool)
    (hl : ∃ x, T.channel x l ≠ 0 ∧ mask x = true)
    (hr : ∃ x, T.channel x l ≠ 0 ∧ mask x = false) :
    (s06Masks (p.snoc (.vps T hT l mask hl hr))).map (fun m => m.mask) =
      (s06Masks p).map (fun m => m.mask) ++ [mask] := by
  simp only [OperationPath.snoc, s06Masks, s06EdgeMasks, List.map_append,
    List.map_cons, List.map_nil]

-- Compose a supplied output comparison after normalization without replacing
-- any stage or erasing the forward/inverse label correspondence.
example (nf : NormalForm S T) (e : OutputEquiv T U) :
    (nf.transOutputEquiv e).toCascade.path = nf.toCascade.path ∧
      (nf.transOutputEquiv e).outputEquiv.equiv = nf.outputEquiv.equiv.trans e.equiv ∧
      (∀ (x : alpha) (j : Fin nf.pmEndpoint.outputCard),
        U.channel x (e.equiv (nf.outputEquiv.equiv j)) = nf.pmEndpoint.channel x j) ∧
      (∀ (x : alpha) (j : Fin U.outputCard),
        nf.pmEndpoint.channel x (nf.outputEquiv.equiv.symm (e.equiv.symm j)) =
          U.channel x j) :=
  ⟨rfl, rfl, fun x j => (nf.outputEquiv.trans e).apply x j,
    fun x j => (nf.outputEquiv.trans e).apply_symm x j⟩

example (p : OperationPath S T) (hS : IsSingularChannel S.channel)
    (hp : p.Normalizing) (e : OutputEquiv T U) :
    ∃ nf : NormalForm S U, ∀ x,
      (nf.pmEndpoint.channel x).map nf.outputEquiv.equiv = U.channel x ∧
      (U.channel x).map nf.outputEquiv.equiv.symm = nf.pmEndpoint.channel x := by
  obtain ⟨nf⟩ := p.normalize hS hp
  exact ⟨nf.transOutputEquiv e, fun x =>
    ⟨(nf.outputEquiv.trans e).map_eq x, (nf.outputEquiv.trans e).symm.map_eq x⟩⟩

-- A semantic cascade comparison supplies an actual map between its concrete
-- endpoints. It does not replace that map by equality of chosen path witnesses.
example (nf : NormalForm S T) (e : OutputEquiv T U) (x : alpha) :
    let c := nf.toCascade.comp (Cascade.ofOutputEquiv e)
    let d := (nf.transOutputEquiv e).toCascade
    c.path.tags = d.path.tags ∧
      (c.endpoint.channel x).map (Cascade.compare c d).equiv = d.endpoint.channel x := by
  dsimp only
  constructor
  · rw [Cascade.tags_comp]
    exact List.append_nil _
  · exact (Cascade.compare _ _).map_eq x

-- Equal columns allow different stored bijections even when both the
-- concrete endpoint and the empty operation word agree.
private abbrev s06SameRows : ActiveFiniteChannel Unit where
  outputCard := 3
  outputCard_pos := by decide
  channel := fun _ => PMF.ofFintype (fun _ : Fin 3 => ((1 / 3 : NNReal) : ENNReal))
    (by exact_mod_cast (show ∑ _j : Fin 3, (1 / 3 : NNReal) = 1 by
      norm_num [Fin.sum_univ_succ]))
  output_active j := ⟨(), by change ((1 / 3 : NNReal) : ENNReal) ≠ 0; norm_num⟩

private def s06SameRowsSwap : OutputEquiv s06SameRows s06SameRows :=
  OutputEquiv.ofCoordinates (Equiv.swap (0 : Fin 3) 1) (fun _ _ => rfl)

example : (NormalForm.ofOutputEquiv s06SameRowsSwap).toCascade.path.tags =
      (NormalForm.refl s06SameRows).toCascade.path.tags ∧
    (NormalForm.ofOutputEquiv s06SameRowsSwap).pmEndpoint =
      (NormalForm.refl s06SameRows).pmEndpoint ∧
    NormalForm.ofOutputEquiv s06SameRowsSwap ≠ NormalForm.refl s06SameRows := by
  refine ⟨rfl, rfl, ?_⟩
  intro h
  have he := congrArg (fun nf : NormalForm s06SameRows s06SameRows =>
    (nf.outputEquiv.equiv.symm (0 : Fin 3)).val) h
  change ((Equiv.swap (0 : Fin 3) 1).symm 0).val = 0 at he
  norm_num at he

-- Pure, differently labeled rows expose the orientation of a three-cycle.
private abbrev s06PureSource : ActiveFiniteChannel (Fin 4) where
  outputCard := 4
  outputCard_pos := by decide
  channel := fun x => PMF.pure x
  output_active j := ⟨j, by simp⟩

private def s06Cycle : Fin 4 ≃ Fin 4 := recoveryPerm 0 3 (by decide)

private theorem s06Cycle_one : s06Cycle 1 = 3 := by
  apply Fin.ext
  exact recoveryPerm_val (0 : Fin 4) 3 (by decide) 1

private theorem s06Cycle_symm_one : s06Cycle.symm 1 = 2 := by
  apply Fin.ext
  exact recoveryPerm_symm_val (0 : Fin 4) 3 (by decide) 1

private abbrev s06PureTarget :=
  ActiveFiniteChannel.ofActive s06PureSource.channel s06Cycle s06PureSource.output_active

private def s06PureEquiv : OutputEquiv s06PureSource s06PureTarget where
  equiv := s06Cycle
  map_eq _ := rfl

private theorem s06PureTarget_row (x : Fin 4) :
    s06PureTarget.channel x = PMF.pure (s06Cycle x) := by
  change (PMF.pure x).map s06Cycle = _
  simp only [PMF.pure_map]

example : s06PureSource.channel ≠ s06PureTarget.channel := by
  intro h
  have he := congrArg (fun k : Fin 4 → PMF (Fin 4) => k 1 1) h
  change (PMF.pure (1 : Fin 4)) 1 = s06PureTarget.channel (1 : Fin 4) (1 : Fin 4) at he
  rw [s06PureTarget_row, s06Cycle_one] at he
  have hz : (PMF.pure (3 : Fin 4)) (1 : Fin 4) = 0 :=
    PMF.pure_apply_of_ne (3 : Fin 4) (1 : Fin 4) (by decide)
  exact one_ne_zero ((PMF.pure_apply_self (1 : Fin 4)).symm.trans (he.trans hz))

example : (s06PureSource.channel (1 : Fin 4)).map s06PureEquiv.equiv =
      s06PureTarget.channel (1 : Fin 4) ∧
    (s06PureSource.channel (1 : Fin 4)).map s06PureEquiv.equiv.symm ≠
      s06PureTarget.channel (1 : Fin 4) := by
  refine ⟨s06PureEquiv.map_eq _, ?_⟩
  intro h
  have he := congrArg (fun p : PMF (Fin 4) => p 2) h
  change ((PMF.pure (1 : Fin 4)).map s06Cycle.symm) 2 =
    s06PureTarget.channel (1 : Fin 4) (2 : Fin 4) at he
  rw [PMF.pure_map, s06Cycle_symm_one, s06PureTarget_row, s06Cycle_one] at he
  have hz : (PMF.pure (3 : Fin 4)) (2 : Fin 4) = 0 :=
    PMF.pure_apply_of_ne (3 : Fin 4) (2 : Fin 4) (by decide)
  exact one_ne_zero ((PMF.pure_apply_self (2 : Fin 4)).symm.trans (he.trans hz))

end
end PerfectFunctionalRepresentations.MatrixOperations

