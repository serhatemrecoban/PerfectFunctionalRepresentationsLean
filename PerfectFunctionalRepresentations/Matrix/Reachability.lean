import PerfectFunctionalRepresentations.Matrix.OperationPaths
import PerfectFunctionalRepresentations.Matrix.Preservation

/-!
# Restricted reachability and the easy direction

Witnessed C07 recoveries reverse concrete operations up to directed output
equivalence. Reversal reverses the chronological word and exchanges PP and VP
splits with their matching merges. C09's local implications then fold over the
two restrictions in Theorem 1. No input prior or full-support assumption is used.
-/

namespace PerfectFunctionalRepresentations.MatrixOperations

universe u
variable {alpha : Type u} [Finite alpha] [Nonempty alpha]

noncomputable section
attribute [local instance] operationQuiver

namespace OperationKind

/-- The operation kind used by a remembered recovery. -/
def reverse : OperationKind → OperationKind
  | .pps => .ppm
  | .vps => .vpm
  | .ppm => .pps
  | .vpm => .vps

@[simp] theorem reverse_reverse (k : OperationKind) : k.reverse.reverse = k := by
  cases k <;> rfl

end OperationKind

namespace OperationStep
variable {S T : ActiveFiniteChannel alpha}

/-- Reverse a supplied edge using its remembered C07 recovery. -/
def reverse (e : OperationStep S T) : Cascade T S := by
  cases e with
  | pps hS l t ht0 ht1 =>
      exact ⟨ppsRecovery S hS l t ht0 ht1,
        OperationPath.nil.snoc (.ppm _ (pps_isSingular S hS l t ht0 ht1)
          (splitLeft l) (splitRight l) Fin.castSucc_lt_succ
          (pps_children_sameSupport S hS l t ht0 ht1)),
        ⟨finCongr (ppsRecovery_outputCard S hS l t ht0 ht1),
          ppsRecovery_channel S hS l t ht0 ht1⟩⟩
  | vps hS l mask hl hr =>
      exact ⟨vpsRecovery S hS l mask hl hr,
        OperationPath.nil.snoc (.vpm _ (vps_isSingular S hS l mask hl hr)
          (splitLeft l) (splitRight l) Fin.castSucc_lt_succ
          ((columnValue_vps_left S hS l mask hl hr).trans
            (columnValue_vps_right S hS l mask hl hr).symm)
          (vps_children_disjoint S hS l mask hl hr)),
        ⟨finCongr (vpsRecovery_outputCard S hS l mask hl hr),
          vpsRecovery_channel S hS l mask hl hr⟩⟩
  | ppm hS a b hab hp =>
      exact ⟨ppmRecovery S hS a b hab hp,
        OperationPath.nil.snoc (.pps _ (ppm_isSingular S hS a b hab hp)
          (activeMergeSurvivor S a b hab) (ppmRatio S hS a b)
          (ppmRatio_pos S hS a b) (ppmRatio_lt_one S hS a b)),
        ⟨ppmRecoveryEquiv S hS a b hab hp, ppmRecovery_channel S hS a b hab hp⟩⟩
  | vpm hS a b hab hv hd =>
      exact ⟨vpmRecovery S hS a b hab hv hd,
        OperationPath.nil.snoc (.vps _ (vpm_isSingular S hS a b hab hv hd)
          (activeMergeSurvivor S a b hab) (vpmRecoveryMask S a)
          (vpmRecovery_leftWitness S hS a b hab hv hd)
          (vpmRecovery_rightWitness S hS a b hab hv hd)),
        ⟨vpmRecoveryEquiv S hS a b hab hv hd,
          vpmRecovery_channel S hS a b hab hv hd⟩⟩

@[simp] theorem tags_reverse (e : OperationStep S T) :
    e.reverse.path.tags = [e.kind.reverse] := by
  cases e <;> rfl

@[simp] theorem length_reverse (e : OperationStep S T) :
    e.reverse.path.length = 1 := by
  cases e <;> rfl

end OperationStep

namespace OperationPath
variable {S T : ActiveFiniteChannel alpha}

/-- Reverse the last edge before the preceding path, composing its recovered labels. -/
def reverse {S T : ActiveFiniteChannel alpha} (p : OperationPath S T) : Cascade T S :=
  match p with
  | .nil => Cascade.refl S
  | .cons p e => e.reverse.comp (reverse p)

@[simp] theorem tags_reverse (p : OperationPath S T) :
    p.reverse.path.tags = p.tags.reverse.map OperationKind.reverse := by
  induction p with
  | nil => rfl
  | cons p e ih =>
      simpa only [reverse, Cascade.tags_comp, OperationStep.tags_reverse, tags,
        List.reverse_append, List.reverse_singleton, List.map_append, List.map_singleton] using
        congrArg (fun l => [e.kind.reverse] ++ l) ih

@[simp] theorem length_reverse (p : OperationPath S T) :
    p.reverse.path.length = p.length := by
  simpa only [List.length_map, List.length_reverse, tags_length] using
    congrArg List.length p.tags_reverse

/-- The reduction restriction printed in Theorem 1: PPM, PPS and VPM. -/
def Reducing (p : OperationPath S T) : Prop :=
  p.Allowed (fun k => k = .ppm ∨ k = .pps ∨ k = .vpm)

/-- Reversal transfers any tag restriction through the matching recovery kind. -/
theorem reverse_allowed (p : OperationPath S T) (P : OperationKind → Prop) :
    p.reverse.path.Allowed P ↔ p.Allowed (fun k => P k.reverse) := by
  simp [Allowed, tags_reverse]

@[simp] theorem reverse_reducing (p : OperationPath S T) :
    p.reverse.path.Reducing ↔ p.Normalizing := by
  rw [Reducing, reverse_allowed]
  unfold Normalizing Allowed
  constructor <;> intro h k hk <;> specialize h k hk <;>
    cases k <;> simp_all [OperationKind.reverse]

@[simp] theorem reverse_normalizing (p : OperationPath S T) :
    p.reverse.path.Normalizing ↔ p.Reducing := by
  rw [Normalizing, reverse_allowed]
  unfold Reducing Allowed
  constructor <;> intro h k hk <;> specialize h k hk <;>
    cases k <;> simp_all [OperationKind.reverse]

end OperationPath

namespace Cascade
variable {S T : ActiveFiniteChannel alpha}

/-- First undo the final output comparison, then reverse the concrete path. -/
def reverse (c : Cascade S T) : Cascade T S :=
  (ofOutputEquiv c.outputEquiv.symm).comp c.path.reverse

@[simp] theorem tags_reverse (c : Cascade S T) :
    c.reverse.path.tags = c.path.tags.reverse.map OperationKind.reverse := by
  simp [reverse, ofOutputEquiv]

@[simp] theorem length_reverse (c : Cascade S T) :
    c.reverse.path.length = c.path.length := by
  simpa only [List.length_map, List.length_reverse, OperationPath.tags_length] using
    congrArg List.length c.tags_reverse

theorem reverse_allowed (c : Cascade S T) (P : OperationKind → Prop) :
    c.reverse.path.Allowed P ↔ c.path.Allowed (fun k => P k.reverse) := by
  simp [OperationPath.Allowed, tags_reverse]

@[simp] theorem reverse_reducing (c : Cascade S T) :
    c.reverse.path.Reducing ↔ c.path.Normalizing := by
  change (ofOutputEquiv c.outputEquiv.symm |>.comp c.path.reverse).path.Reducing ↔ _
  simpa [OperationPath.Reducing, allowed_comp, ofOutputEquiv] using c.path.reverse_reducing

@[simp] theorem reverse_normalizing (c : Cascade S T) :
    c.reverse.path.Normalizing ↔ c.path.Reducing := by
  change (ofOutputEquiv c.outputEquiv.symm |>.comp c.path.reverse).path.Normalizing ↔ _
  simpa [OperationPath.Normalizing, allowed_comp, ofOutputEquiv] using c.path.reverse_normalizing

/-- The source premise is necessary when the concrete path is empty. -/
theorem isSingular (c : Cascade S T) (hS : IsSingularChannel S.channel) :
    IsSingularChannel T.channel := c.outputEquiv.isSingular (c.path.isSingular hS)

end Cascade

namespace OutputEquiv
variable {S T : ActiveFiniteChannel alpha}

/-- Directed output comparison preserves intrinsic perfect representability. -/
theorem isPerfectlyRepresentable_iff (e : OutputEquiv S T) :
    IsPerfectlyRepresentableChannel S.channel ↔ IsPerfectlyRepresentableChannel T.channel := by
  have h := isPerfectlyRepresentableChannel_map_iff S.channel e.equiv e.equiv.injective
  have he : (fun x => (S.channel x).map e.equiv) = T.channel := funext e.map_eq
  rw [he] at h
  exact h.symm

end OutputEquiv

namespace OperationPath
variable {S T : ActiveFiniteChannel alpha}

/-- Fold C09's three positive implications over the normalizing restriction. -/
theorem isPerfectlyRepresentable (p : OperationPath S T) (hp : p.Normalizing)
    (hS : IsPerfectlyRepresentableChannel S.channel) :
    IsPerfectlyRepresentableChannel T.channel := by
  induction p with
  | nil => exact hS
  | cons p e ih =>
      obtain ⟨hp, he⟩ := (OperationPath.allowed_snoc _ p e).mp hp
      have hP := ih hp
      cases e with
      | pps hS l t ht0 ht1 => exact pps_isPerfectlyRepresentable _ hS l t ht0 ht1 hP
      | vps hS l mask hl hr => exact vps_isPerfectlyRepresentable _ hS l mask hl hr hP
      | ppm hS a b hab hs => exact ppm_isPerfectlyRepresentable _ hS a b hab hs hP
      | vpm hS a b hab hv hd => simp [OperationStep.kind] at he

/-- Fold C09's three nonperfectness implications over the reducing restriction. -/
theorem not_isPerfectlyRepresentable (p : OperationPath S T) (hp : p.Reducing)
    (hS : ¬ IsPerfectlyRepresentableChannel S.channel) :
    ¬ IsPerfectlyRepresentableChannel T.channel := by
  induction p with
  | nil => exact hS
  | cons p e ih =>
      obtain ⟨hp, he⟩ := (OperationPath.allowed_snoc _ p e).mp hp
      have hP := ih hp
      cases e with
      | pps hS l t ht0 ht1 => exact pps_not_isPerfectlyRepresentable _ hS l t ht0 ht1 hP
      | vps hS l mask hl hr => simp [OperationStep.kind] at he
      | ppm hS a b hab hs => exact ppm_not_isPerfectlyRepresentable _ hS a b hab hs hP
      | vpm hS a b hab hv hd => exact vpm_not_isPerfectlyRepresentable _ hS a b hab hv hd hP

/-- Perfectness of the reduction target implies perfectness of the source. -/
theorem reflects_isPerfectlyRepresentable (p : OperationPath S T) (hp : p.Reducing)
    (hT : IsPerfectlyRepresentableChannel T.channel) :
    IsPerfectlyRepresentableChannel S.channel := by
  by_contra hS
  exact p.not_isPerfectlyRepresentable hp hS hT

end OperationPath

namespace Cascade
variable {S T : ActiveFiniteChannel alpha}

theorem isPerfectlyRepresentable (c : Cascade S T) (hc : c.path.Normalizing)
    (hS : IsPerfectlyRepresentableChannel S.channel) :
    IsPerfectlyRepresentableChannel T.channel :=
  c.outputEquiv.isPerfectlyRepresentable_iff.mp (c.path.isPerfectlyRepresentable hc hS)

theorem not_isPerfectlyRepresentable (c : Cascade S T) (hc : c.path.Reducing)
    (hS : ¬ IsPerfectlyRepresentableChannel S.channel) :
    ¬ IsPerfectlyRepresentableChannel T.channel :=
  fun hT => c.path.not_isPerfectlyRepresentable hc hS
    (c.outputEquiv.isPerfectlyRepresentable_iff.mpr hT)

theorem reflects_isPerfectlyRepresentable (c : Cascade S T) (hc : c.path.Reducing)
    (hT : IsPerfectlyRepresentableChannel T.channel) :
    IsPerfectlyRepresentableChannel S.channel :=
  c.path.reflects_isPerfectlyRepresentable hc (c.outputEquiv.isPerfectlyRepresentable_iff.mpr hT)

end Cascade

/-- A witnessed PPS/VPS/PPM cascade from the all-ones seed. -/
def FromAllOnes (S : ActiveFiniteChannel alpha) : Prop :=
  ∃ c : Cascade (ActiveFiniteChannel.allOnes alpha) S, c.path.Normalizing

/-- A witnessed PPM/PPS/VPM reduction to the all-ones seed. -/
def ToAllOnes (S : ActiveFiniteChannel alpha) : Prop :=
  ∃ c : Cascade S (ActiveFiniteChannel.allOnes alpha), c.path.Reducing

theorem fromAllOnes_allOnes : FromAllOnes (ActiveFiniteChannel.allOnes alpha) :=
  ⟨Cascade.refl _, OperationPath.allowed_nil _⟩

theorem toAllOnes_allOnes : ToAllOnes (ActiveFiniteChannel.allOnes alpha) :=
  ⟨Cascade.refl _, OperationPath.allowed_nil _⟩

variable {S T : ActiveFiniteChannel alpha}

theorem FromAllOnes.outputEquiv (h : FromAllOnes S) (e : OutputEquiv S T) :
    FromAllOnes T := by
  obtain ⟨c, hc⟩ := h
  exact ⟨⟨c.endpoint, c.path, c.outputEquiv.trans e⟩, hc⟩

theorem ToAllOnes.outputEquiv (h : ToAllOnes S) (e : OutputEquiv S T) :
    ToAllOnes T := by
  obtain ⟨c, hc⟩ := h
  refine ⟨(Cascade.ofOutputEquiv e.symm).comp c, ?_⟩
  exact (Cascade.allowed_comp _ _ _).mpr ⟨OperationPath.allowed_nil _, hc⟩

theorem fromAllOnes_iff_toAllOnes : FromAllOnes S ↔ ToAllOnes S := by
  constructor
  · rintro ⟨c, hc⟩
    exact ⟨c.reverse, c.reverse_reducing.mpr hc⟩
  · rintro ⟨c, hc⟩
    exact ⟨c.reverse, c.reverse_normalizing.mpr hc⟩

/-- The constructive easy direction, independent of any input prior. -/
theorem FromAllOnes.isPerfectlyRepresentable (h : FromAllOnes S) :
    IsPerfectlyRepresentableChannel S.channel := by
  obtain ⟨c, hc⟩ := h
  exact c.isPerfectlyRepresentable hc (ActiveFiniteChannel.allOnes_isPerfectlyRepresentable alpha)

/-- The printed reduction formulation of the easy direction. -/
theorem ToAllOnes.isPerfectlyRepresentable (h : ToAllOnes S) :
    IsPerfectlyRepresentableChannel S.channel := by
  obtain ⟨c, hc⟩ := h
  exact c.reflects_isPerfectlyRepresentable hc
    (ActiveFiniteChannel.allOnes_isPerfectlyRepresentable alpha)

theorem FromAllOnes.isSingular (h : FromAllOnes S) : IsSingularChannel S.channel := by
  obtain ⟨c, _⟩ := h
  exact c.isSingular (ActiveFiniteChannel.allOnes_isSingular alpha)

theorem ToAllOnes.isSingular (h : ToAllOnes S) : IsSingularChannel S.channel :=
  (fromAllOnes_iff_toAllOnes.mpr h).isSingular

end
end PerfectFunctionalRepresentations.MatrixOperations
