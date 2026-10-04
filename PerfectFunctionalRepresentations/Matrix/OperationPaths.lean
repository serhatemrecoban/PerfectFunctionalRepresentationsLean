import PerfectFunctionalRepresentations.Matrix.Operations
import Mathlib.Combinatorics.Quiver.Path

/-!
# Witnessed paths of matrix operations

The graph records the four legal C07 operations, their actual parameters and
their exact active-channel targets. Its paths are mathlib `Quiver.Path` with a
fixed, explicitly supplied quiver; importing this file installs no global
quiver instance on active channels. Tags are in chronological order.

Output equivalence retains a directed output bijection and its PMF-map equation.
All four operations and concrete paths transport across that bijection.
Cascade composition preserves chronological tags and has semantic endpoint
identity and associativity laws. The three-stage package supplies the converse
cascade and explicit singularity accessors. Lemma 4 normalization is proved in
OperationFactorization.
Source singularity stays explicit when propagating it along an empty path.
-/

namespace PerfectFunctionalRepresentations.MatrixOperations

universe u
variable {alpha : Type u} [Finite alpha] [Nonempty alpha]

noncomputable section

/-- The four legal operation kinds; Lemma 4 will use the first three. -/
inductive OperationKind
  | pps | vps | ppm | vpm
  deriving DecidableEq

/-- One legal C07 operation, retaining all parameters and legality witnesses. -/
inductive OperationStep : ActiveFiniteChannel alpha → ActiveFiniteChannel alpha → Type u
  | pps (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
      (l : Fin S.outputCard) (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1) :
      OperationStep S (MatrixOperations.pps S hS l t ht0 ht1)
  | vps (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
      (l : Fin S.outputCard) (mask : alpha → Bool)
      (hleft : ∃ x, S.channel x l ≠ 0 ∧ mask x = true)
      (hright : ∃ x, S.channel x l ≠ 0 ∧ mask x = false) :
      OperationStep S (MatrixOperations.vps S hS l mask hleft hright)
  | ppm (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
      (a b : Fin S.outputCard) (hab : a < b)
      (hpattern : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) :
      OperationStep S (MatrixOperations.ppm S hS a b hab hpattern)
  | vpm (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
      (a b : Fin S.outputCard) (hab : a < b)
      (hvalue : columnValue S.channel hS (S.activeEquiv a) =
        columnValue S.channel hS (S.activeEquiv b))
      (hdisjoint : ∀ x, S.channel x a ≠ 0 → S.channel x b = 0) :
      OperationStep S (MatrixOperations.vpm S hS a b hab hvalue hdisjoint)

namespace OperationStep

variable {S T : ActiveFiniteChannel alpha}

/-- Read the operation kind without discarding its witness. -/
def kind : OperationStep S T → OperationKind
  | .pps .. => .pps
  | .vps .. => .vps
  | .ppm .. => .ppm
  | .vpm .. => .vpm

/-- Every edge ends at the actual singular C07 result. -/
theorem isSingular (e : OperationStep S T) : IsSingularChannel T.channel := by
  cases e with
  | pps hS l t ht0 ht1 => exact pps_isSingular _ hS l t ht0 ht1
  | vps hS l mask hleft hright => exact vps_isSingular _ hS l mask hleft hright
  | ppm hS a b hab hpattern => exact ppm_isSingular _ hS a b hab hpattern
  | vpm hS a b hab hvalue hdisjoint =>
      exact vpm_isSingular _ hS a b hab hvalue hdisjoint

end OperationStep

/-- The operation graph, supplied explicitly to the path type. -/
@[instance_reducible] def operationQuiver (alpha : Type u) [Finite alpha] [Nonempty alpha] :
    Quiver (ActiveFiniteChannel alpha) where
  Hom := OperationStep

/-- A concrete path has its exact C07 endpoint; output equivalence is separate. -/
abbrev OperationPath (S T : ActiveFiniteChannel alpha) :=
  @Quiver.Path (ActiveFiniteChannel alpha) (operationQuiver alpha) S T

attribute [local instance] operationQuiver

namespace OperationPath

variable {S T U V : ActiveFiniteChannel alpha}

/-- The empty concrete path. -/
def nil : OperationPath S S := Quiver.Path.nil

/-- Append one witnessed edge at the chronological end. -/
def snoc (p : OperationPath S T) (e : OperationStep T U) : OperationPath S U :=
  Quiver.Path.cons p e

/-- Concatenate concrete paths in chronological order. -/
def append (p : OperationPath S T) (q : OperationPath T U) : OperationPath S U :=
  Quiver.Path.comp p q

/-- The number of witnessed operations. -/
def length (p : OperationPath S T) : Nat := Quiver.Path.length p

/-- Actual operation tags, in the order the operations are performed. -/
def tags {S : ActiveFiniteChannel alpha} :
    {T : ActiveFiniteChannel alpha} → OperationPath S T → List OperationKind
  | _, .nil => []
  | _, .cons p e => tags p ++ [OperationStep.kind e]

@[simp] theorem tags_nil : (nil : OperationPath S S).tags = [] := rfl

@[simp] theorem tags_snoc (p : OperationPath S T) (e : OperationStep T U) :
    (p.snoc e).tags = p.tags ++ [e.kind] := rfl

@[simp] theorem nil_append (p : OperationPath S T) : nil.append p = p :=
  Quiver.Path.nil_comp p

@[simp] theorem append_nil (p : OperationPath S T) : p.append nil = p := rfl

theorem append_assoc (p : OperationPath S T) (q : OperationPath T U)
    (r : OperationPath U V) : (p.append q).append r = p.append (q.append r) :=
  Quiver.Path.comp_assoc p q r

@[simp] theorem tags_append (p : OperationPath S T) (q : OperationPath T U) :
    (p.append q).tags = p.tags ++ q.tags := by
  induction q with
  | nil => simp [append, tags]
  | cons q e ih =>
      change tags (p.append q) ++ [OperationStep.kind e] =
        p.tags ++ (tags q ++ [OperationStep.kind e])
      rw [ih, List.append_assoc]

@[simp] theorem length_nil : (nil : OperationPath S S).length = 0 := rfl

@[simp] theorem length_snoc (p : OperationPath S T) (e : OperationStep T U) :
    (p.snoc e).length = p.length + 1 := rfl

@[simp] theorem length_append (p : OperationPath S T) (q : OperationPath T U) :
    (p.append q).length = p.length + q.length := Quiver.Path.length_comp p q

@[simp] theorem tags_length (p : OperationPath S T) : p.tags.length = p.length := by
  induction p with
  | nil => rfl
  | cons p e ih => simpa [tags, length] using congrArg Nat.succ ih

/-- Every recorded tag satisfies the supplied restriction. -/
def Allowed (P : OperationKind → Prop) (p : OperationPath S T) : Prop :=
  ∀ k ∈ p.tags, P k

/-- A possibly empty block of operations of one kind. -/
def Homogeneous (k : OperationKind) (p : OperationPath S T) : Prop :=
  p.Allowed (· = k)

/-- The tag restriction in Lemma 4, excluding VPM. -/
def Normalizing (p : OperationPath S T) : Prop :=
  p.Allowed (fun k => k = .pps ∨ k = .vps ∨ k = .ppm)

@[simp] theorem allowed_nil (P : OperationKind → Prop) :
    (nil : OperationPath S S).Allowed P := by simp [Allowed]

@[simp] theorem allowed_snoc (P : OperationKind → Prop) (p : OperationPath S T)
    (e : OperationStep T U) : (p.snoc e).Allowed P ↔ p.Allowed P ∧ P e.kind := by
  simp [Allowed, or_imp, forall_and]

@[simp] theorem allowed_append (P : OperationKind → Prop) (p : OperationPath S T)
    (q : OperationPath T U) : (p.append q).Allowed P ↔ p.Allowed P ∧ q.Allowed P := by
  simp [Allowed, or_imp, forall_and]

@[simp] theorem homogeneous_nil (k : OperationKind) :
    (nil : OperationPath S S).Homogeneous k := allowed_nil _

@[simp] theorem homogeneous_append (k : OperationKind) (p : OperationPath S T)
    (q : OperationPath T U) :
    (p.append q).Homogeneous k ↔ p.Homogeneous k ∧ q.Homogeneous k :=
  allowed_append _ p q

/-- The initial premise covers nil; nonempty paths use C07 edge closure. -/
theorem isSingular (p : OperationPath S T) (hS : IsSingularChannel S.channel) :
    IsSingularChannel T.channel := by
  cases p with
  | nil => exact hS
  | cons p e => exact OperationStep.isSingular e

end OperationPath

/-- A directed relabeling of outputs with equality of every pushforward row. -/
structure OutputEquiv (S T : ActiveFiniteChannel alpha) where
  equiv : Fin S.outputCard ≃ Fin T.outputCard
  map_eq : ∀ x, (S.channel x).map equiv = T.channel x

namespace OutputEquiv

variable {S T U : ActiveFiniteChannel alpha}

/-- Keep the output labels. -/
def refl (S : ActiveFiniteChannel alpha) : OutputEquiv S S where
  equiv := Equiv.refl _
  map_eq x := PMF.map_id (S.channel x)

/-- Reverse the output-label correspondence. -/
def symm (e : OutputEquiv S T) : OutputEquiv T S where
  equiv := e.equiv.symm
  map_eq x := by
    rw [← e.map_eq x, PMF.map_comp]
    simp only [Function.comp_def, Equiv.symm_apply_apply]
    exact PMF.map_id _

/-- Follow the first output correspondence by the second. -/
def trans (e : OutputEquiv S T) (f : OutputEquiv T U) : OutputEquiv S U where
  equiv := e.equiv.trans f.equiv
  map_eq x := by
    change (S.channel x).map (f.equiv ∘ e.equiv) = U.channel x
    rw [← PMF.map_comp, e.map_eq, f.map_eq]

/-- Explicit output equivalence preserves the actual output cardinality. -/
theorem outputCard_eq (e : OutputEquiv S T) : S.outputCard = T.outputCard := by
  simpa only [Fintype.card_fin] using Fintype.card_congr e.equiv

/-- Forward coordinate equation: source labels are sent to destination labels. -/
theorem apply (e : OutputEquiv S T) (x : alpha) (y : Fin S.outputCard) :
    T.channel x (e.equiv y) = S.channel x y := by
  rw [← e.map_eq x]
  exact PMF.map_apply_equiv (S.channel x) e.equiv y

/-- Inverse coordinate equation at a specified destination label. -/
theorem apply_symm (e : OutputEquiv S T) (x : alpha) (z : Fin T.outputCard) :
    S.channel x (e.equiv.symm z) = T.channel x z :=
  e.symm.apply x z

end OutputEquiv

/-- A concrete path followed by an explicit comparison of its output labels. -/
structure Cascade (S T : ActiveFiniteChannel alpha) where
  endpoint : ActiveFiniteChannel alpha
  path : OperationPath S endpoint
  outputEquiv : OutputEquiv endpoint T

/-- The data of three homogeneous stages. S01 does not assert normalization. -/
structure NormalForm (S T : ActiveFiniteChannel alpha) where
  ppEndpoint : ActiveFiniteChannel alpha
  vpEndpoint : ActiveFiniteChannel alpha
  pmEndpoint : ActiveFiniteChannel alpha
  pp : OperationPath S ppEndpoint
  vp : OperationPath ppEndpoint vpEndpoint
  pm : OperationPath vpEndpoint pmEndpoint
  pp_homogeneous : pp.Homogeneous .pps
  vp_homogeneous : vp.Homogeneous .vps
  pm_homogeneous : pm.Homogeneous .ppm
  outputEquiv : OutputEquiv pmEndpoint T

end

end PerfectFunctionalRepresentations.MatrixOperations

namespace PerfectFunctionalRepresentations.MatrixOperations

universe u
variable {alpha : Type u} [Finite alpha] [Nonempty alpha]
noncomputable section

/-- Extend a relabeling through an adjacent split, preserving child identity. -/
def splitOutputEquiv {n m : Nat} (e : Fin n ≃ Fin m) (l : Fin n) :
    Fin (n + 1) ≃ Fin (m + 1) :=
  (finSuccEquiv' (splitRight l)).trans
    ((Equiv.optionCongr e).trans (finSuccEquiv' (splitRight (e l))).symm)

@[simp] theorem splitOutputEquiv_right {n m : Nat} (e : Fin n ≃ Fin m) (l : Fin n) :
    splitOutputEquiv e l (splitRight l) = splitRight (e l) := by
  simp [splitOutputEquiv]

@[simp] theorem splitOutputEquiv_keep {n m : Nat} (e : Fin n ≃ Fin m)
    (l j : Fin n) : splitOutputEquiv e l (splitKeep l j) = splitKeep (e l) (e j) := by
  simp [splitOutputEquiv, splitKeep, splitRight]

@[simp] theorem splitOutputEquiv_left {n m : Nat} (e : Fin n ≃ Fin m) (l : Fin n) :
    splitOutputEquiv e l (splitLeft l) = splitLeft (e l) := by
  simpa only [splitKeep_self] using splitOutputEquiv_keep e l l

namespace OutputEquiv

variable {S T U : ActiveFiniteChannel alpha}

/-- Build the directed row-map equation from all forward coordinates. -/
def ofCoordinates (e : Fin S.outputCard ≃ Fin T.outputCard)
    (h : ∀ x y, T.channel x (e y) = S.channel x y) : OutputEquiv S T where
  equiv := e
  map_eq x := by
    apply PMF.ext
    intro z
    obtain ⟨y, rfl⟩ := e.surjective z
    rw [PMF.map_apply_equiv]
    exact (h x y).symm

/-- Singularity is unchanged by the supplied output bijection. -/
theorem isSingular (e : OutputEquiv S T) (hS : IsSingularChannel S.channel) :
    IsSingularChannel T.channel := by
  have h : T.channel = fun x => (S.channel x).map e.equiv :=
    funext fun x => (e.map_eq x).symm
  rw [h]
  exact (isSingularChannel_map_iff S.channel e.equiv e.equiv.injective).mpr hS

/-- Values of the corresponding admitted columns agree. -/
theorem columnValue (e : OutputEquiv S T) (hS : IsSingularChannel S.channel)
    (y : Fin S.outputCard) :
    PerfectFunctionalRepresentations.columnValue T.channel (e.isSingular hS)
      (T.activeEquiv (e.equiv y)) =
      PerfectFunctionalRepresentations.columnValue S.channel hS (S.activeEquiv y) := by
  exact columnValue_transport S.channel T.channel hS (e.isSingular hS)
    (S.activeEquiv y) (T.activeEquiv (e.equiv y)) (Equiv.refl _) (fun x => e.apply x y)

/-- PPS transport keeps the selected column, strict ratio and left/right order. -/
def pps (e : OutputEquiv S T) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (t : NNReal) (ht0 : 0 < t) (ht1 : t < 1) :
    OutputEquiv (MatrixOperations.pps S hS l t ht0 ht1)
      (MatrixOperations.pps T (e.isSingular hS) (e.equiv l) t ht0 ht1) :=
  ofCoordinates (splitOutputEquiv e.equiv l) (by
    intro x j
    change ppsRaw T.channel (e.equiv l) t ht1.le x (splitOutputEquiv e.equiv l j) =
      ppsRaw S.channel l t ht1.le x j
    rcases split_cases l j with rfl | ⟨k, rfl⟩
    · rw [splitOutputEquiv_right, ppsRaw_right, ppsRaw_right, e.apply]
    · by_cases hk : k = l
      · subst k
        rw [splitKeep_self, splitOutputEquiv_left, ppsRaw_left, ppsRaw_left, e.apply]
      · rw [splitOutputEquiv_keep, ppsRaw_keep _ _ _ _ _ (e.equiv.injective.ne hk),
          ppsRaw_keep _ _ _ _ _ hk, e.apply])

/-- The same VPS mask remains legal on the transported selected support. -/
theorem vpsWitness (e : OutputEquiv S T) (l : Fin S.outputCard) (mask : alpha → Bool)
    (value : Bool) (h : ∃ x, S.channel x l ≠ 0 ∧ mask x = value) :
    ∃ x, T.channel x (e.equiv l) ≠ 0 ∧ mask x = value := by
  obtain ⟨x, hx, hm⟩ := h
  exact ⟨x, by rwa [e.apply], hm⟩

/-- VPS transport keeps both support pieces and the original mask. -/
def vps (e : OutputEquiv S T) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (mask : alpha → Bool)
    (hl : ∃ x, S.channel x l ≠ 0 ∧ mask x = true)
    (hr : ∃ x, S.channel x l ≠ 0 ∧ mask x = false) :
    OutputEquiv (MatrixOperations.vps S hS l mask hl hr)
      (MatrixOperations.vps T (e.isSingular hS) (e.equiv l) mask
        (e.vpsWitness l mask true hl) (e.vpsWitness l mask false hr)) :=
  ofCoordinates (splitOutputEquiv e.equiv l) (by
    intro x j
    change vpsRaw T.channel (e.equiv l) mask x (splitOutputEquiv e.equiv l j) =
      vpsRaw S.channel l mask x j
    rcases split_cases l j with rfl | ⟨k, rfl⟩
    · rw [splitOutputEquiv_right, vpsRaw_right, vpsRaw_right, e.apply]
    · by_cases hk : k = l
      · subst k
        rw [splitKeep_self, splitOutputEquiv_left, vpsRaw_left, vpsRaw_left, e.apply]
      · rw [splitOutputEquiv_keep, vpsRaw_keep _ _ _ _ (e.equiv.injective.ne hk),
          vpsRaw_keep _ _ _ _ hk, e.apply])

end OutputEquiv
end
end PerfectFunctionalRepresentations.MatrixOperations

namespace PerfectFunctionalRepresentations.MatrixOperations
universe u
variable {alpha : Type u} [Finite alpha] [Nonempty alpha]
noncomputable section

private def retainedEquiv (S : ActiveFiniteChannel alpha) (b : Fin S.outputCard) :
    Fin (S.outputCard - 1) ≃ {j : Fin S.outputCard // j ≠ b} :=
  (finSuccAboveEquiv (mergeSourceEquiv S b)).trans
    ((mergeSourceEquiv S).symm.subtypeEquiv (fun j => by
      constructor
      · intro h hj
        apply h
        rw [← hj]
        simp
      · intro h hj
        apply h
        rw [hj]
        simp))

private theorem retainedEquiv_val (S : ActiveFiniteChannel alpha) (b : Fin S.outputCard)
    (j : Fin (S.outputCard - 1)) :
    (retainedEquiv S b j).val = activeMergeRetained S b j := rfl

private theorem retained_injective (S : ActiveFiniteChannel alpha) (b : Fin S.outputCard) :
    Function.Injective (activeMergeRetained S b) := by
  intro i j h
  apply (retainedEquiv S b).injective
  exact Subtype.ext h

namespace OutputEquiv
variable {S T : ActiveFiniteChannel alpha}

/-- The survivor label selected after sorting the relabeled pair. -/
def mergeLower (e : OutputEquiv S T) (a b : Fin S.outputCard) : Fin T.outputCard :=
  min (e.equiv a) (e.equiv b)

/-- The deleted label selected after sorting the relabeled pair. -/
def mergeUpper (e : OutputEquiv S T) (a b : Fin S.outputCard) : Fin T.outputCard :=
  max (e.equiv a) (e.equiv b)

theorem merge_lt (e : OutputEquiv S T) (a b : Fin S.outputCard) (hab : a < b) :
    e.mergeLower a b < e.mergeUpper a b :=
  min_lt_max.mpr (e.equiv.injective.ne (ne_of_lt hab))

private def orderedEquiv (e : OutputEquiv S T) (a b : Fin S.outputCard) :
    Fin S.outputCard ≃ Fin T.outputCard :=
  if e.equiv a < e.equiv b then e.equiv else (Equiv.swap a b).trans e.equiv

private theorem orderedEquiv_lower (e : OutputEquiv S T) (a b : Fin S.outputCard) :
    orderedEquiv e a b a = e.mergeLower a b := by
  by_cases h : e.equiv a < e.equiv b
  · simp [orderedEquiv, h, mergeLower, min_eq_left h.le]
  · simp [orderedEquiv, h, mergeLower, min_eq_right (le_of_not_gt h)]

private theorem orderedEquiv_upper (e : OutputEquiv S T) (a b : Fin S.outputCard) :
    orderedEquiv e a b b = e.mergeUpper a b := by
  by_cases h : e.equiv a < e.equiv b
  · simp [orderedEquiv, h, mergeUpper, max_eq_right h.le]
  · simp [orderedEquiv, h, mergeUpper, max_eq_left (le_of_not_gt h)]

private theorem orderedEquiv_keep (e : OutputEquiv S T) (a b j : Fin S.outputCard)
    (ha : j ≠ a) (hb : j ≠ b) : orderedEquiv e a b j = e.equiv j := by
  by_cases h : e.equiv a < e.equiv b <;>
    simp [orderedEquiv, h, Equiv.swap_apply_of_ne_of_ne ha hb]

/-- Relabel all outputs after deleting the higher label in each ordered merge. -/
def mergeEquiv (e : OutputEquiv S T) (a b : Fin S.outputCard) :
    Fin (S.outputCard - 1) ≃ Fin (T.outputCard - 1) :=
  (retainedEquiv S b).trans
    (((orderedEquiv e a b).subtypeEquiv (fun j => by
      rw [← orderedEquiv_upper e a b]
      exact (orderedEquiv e a b).injective.ne_iff.symm)).trans
        (retainedEquiv T (e.mergeUpper a b)).symm)

private theorem mergeEquiv_retained (e : OutputEquiv S T) (a b : Fin S.outputCard)
    (j : Fin (S.outputCard - 1)) :
    activeMergeRetained T (e.mergeUpper a b) (e.mergeEquiv a b j) =
      orderedEquiv e a b (activeMergeRetained S b j) := by
  change (retainedEquiv T (e.mergeUpper a b) (e.mergeEquiv a b j)).val = _
  simp only [mergeEquiv, Equiv.trans_apply, Equiv.apply_symm_apply]
  rfl

@[simp] theorem mergeEquiv_survivor (e : OutputEquiv S T) (a b : Fin S.outputCard)
    (hab : a < b) :
    e.mergeEquiv a b (activeMergeSurvivor S a b hab) =
      activeMergeSurvivor T (e.mergeLower a b) (e.mergeUpper a b) (e.merge_lt a b hab) := by
  apply retained_injective T (e.mergeUpper a b)
  rw [mergeEquiv_retained, activeMergeRetained_survivor, activeMergeRetained_survivor,
    orderedEquiv_lower]

theorem mergeEquiv_unaffected (e : OutputEquiv S T) (a b : Fin S.outputCard)
    (hab : a < b) (j : Fin (S.outputCard - 1))
    (hj : j ≠ activeMergeSurvivor S a b hab) :
    activeMergeRetained T (e.mergeUpper a b) (e.mergeEquiv a b j) =
      e.equiv (activeMergeRetained S b j) := by
  rw [mergeEquiv_retained]
  apply orderedEquiv_keep
  · intro h
    apply hj
    apply retained_injective S b
    rw [activeMergeRetained_survivor]
    exact h
  · exact (retainedEquiv S b j).property

theorem mergeEquiv_ne_survivor (e : OutputEquiv S T) (a b : Fin S.outputCard)
    (hab : a < b) (j : Fin (S.outputCard - 1))
    (hj : j ≠ activeMergeSurvivor S a b hab) :
    e.mergeEquiv a b j ≠
      activeMergeSurvivor T (e.mergeLower a b) (e.mergeUpper a b) (e.merge_lt a b hab) := by
  rw [← e.mergeEquiv_survivor a b hab]
  exact (e.mergeEquiv a b).injective.ne hj

private theorem merge_mass (e : OutputEquiv S T) (a b : Fin S.outputCard) (x : alpha) :
    T.channel x (e.mergeLower a b) + T.channel x (e.mergeUpper a b) =
      S.channel x a + S.channel x b := by
  by_cases h : e.equiv a < e.equiv b
  · simp only [mergeLower, mergeUpper, min_eq_left h.le, max_eq_right h.le, e.apply]
  · simp only [mergeLower, mergeUpper, min_eq_right (le_of_not_gt h),
      max_eq_left (le_of_not_gt h), e.apply, add_comm]

theorem ppmPattern (e : OutputEquiv S T) (a b : Fin S.outputCard)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) :
    ∀ x, T.channel x (e.mergeLower a b) ≠ 0 ↔ T.channel x (e.mergeUpper a b) ≠ 0 := by
  intro x
  by_cases h : e.equiv a < e.equiv b
  · simpa only [mergeLower, mergeUpper, min_eq_left h.le, max_eq_right h.le, e.apply]
      using hp x
  · simpa only [mergeLower, mergeUpper, min_eq_right (le_of_not_gt h),
      max_eq_left (le_of_not_gt h), e.apply] using (hp x).symm

/-- PPM transport sorts the chosen pair and accounts for every retained column. -/
def ppm (e : OutputEquiv S T) (hS : IsSingularChannel S.channel)
    (a b : Fin S.outputCard) (hab : a < b)
    (hp : ∀ x, S.channel x a ≠ 0 ↔ S.channel x b ≠ 0) :
    OutputEquiv (MatrixOperations.ppm S hS a b hab hp)
      (MatrixOperations.ppm T (e.isSingular hS) (e.mergeLower a b) (e.mergeUpper a b)
        (e.merge_lt a b hab) (e.ppmPattern a b hp)) :=
  ofCoordinates (e.mergeEquiv a b) (by
    intro x j
    by_cases hj : j = activeMergeSurvivor S a b hab
    · subst j
      exact (congrArg ((MatrixOperations.ppm T (e.isSingular hS) _ _
        (e.merge_lt a b hab) (e.ppmPattern a b hp)).channel x)
          (e.mergeEquiv_survivor a b hab)).trans
        ((ppm_apply_survivor _ _ _ _ _ _ x).trans
          ((e.merge_mass a b x).trans (ppm_apply_survivor S hS a b hab hp x).symm))
    · exact (ppm_apply_unaffected _ _ _ _ _ _ x
        (e.mergeEquiv_ne_survivor a b hab j hj)).trans
        ((congrArg (T.channel x) (e.mergeEquiv_unaffected a b hab j hj)).trans
          ((e.apply x _).trans (ppm_apply_unaffected S hS a b hab hp x hj).symm)))

theorem vpmValue (e : OutputEquiv S T) (hS : IsSingularChannel S.channel)
    (a b : Fin S.outputCard)
    (hv : PerfectFunctionalRepresentations.columnValue S.channel hS (S.activeEquiv a) =
      PerfectFunctionalRepresentations.columnValue S.channel hS (S.activeEquiv b)) :
    PerfectFunctionalRepresentations.columnValue T.channel (e.isSingular hS)
      (T.activeEquiv (e.mergeLower a b)) =
    PerfectFunctionalRepresentations.columnValue T.channel (e.isSingular hS)
      (T.activeEquiv (e.mergeUpper a b)) := by
  by_cases h : e.equiv a < e.equiv b
  · simpa only [mergeLower, mergeUpper, min_eq_left h.le, max_eq_right h.le,
      e.columnValue hS a, e.columnValue hS b]
      using hv
  · simpa only [mergeLower, mergeUpper, min_eq_right (le_of_not_gt h),
      max_eq_left (le_of_not_gt h), e.columnValue hS a, e.columnValue hS b] using hv.symm

theorem vpmDisjoint (e : OutputEquiv S T) (a b : Fin S.outputCard)
    (hd : ∀ x, S.channel x a ≠ 0 → S.channel x b = 0) :
    ∀ x, T.channel x (e.mergeLower a b) ≠ 0 → T.channel x (e.mergeUpper a b) = 0 := by
  intro x
  by_cases h : e.equiv a < e.equiv b
  · simpa only [mergeLower, mergeUpper, min_eq_left h.le, max_eq_right h.le, e.apply]
      using hd x
  · simp only [mergeLower, mergeUpper, min_eq_right (le_of_not_gt h),
      max_eq_left (le_of_not_gt h), e.apply]
    intro hb
    by_contra ha
    exact hb (hd x ha)

/-- VPM transport uses the same ordered label bijection as PPM. -/
def vpm (e : OutputEquiv S T) (hS : IsSingularChannel S.channel)
    (a b : Fin S.outputCard) (hab : a < b)
    (hv : PerfectFunctionalRepresentations.columnValue S.channel hS (S.activeEquiv a) =
      PerfectFunctionalRepresentations.columnValue S.channel hS (S.activeEquiv b))
    (hd : ∀ x, S.channel x a ≠ 0 → S.channel x b = 0) :
    OutputEquiv (MatrixOperations.vpm S hS a b hab hv hd)
      (MatrixOperations.vpm T (e.isSingular hS) (e.mergeLower a b) (e.mergeUpper a b)
        (e.merge_lt a b hab) (e.vpmValue hS a b hv) (e.vpmDisjoint a b hd)) :=
  ofCoordinates (e.mergeEquiv a b) (by
    intro x j
    by_cases hj : j = activeMergeSurvivor S a b hab
    · subst j
      exact (congrArg ((MatrixOperations.vpm T (e.isSingular hS) _ _
        (e.merge_lt a b hab) (e.vpmValue hS a b hv) (e.vpmDisjoint a b hd)).channel x)
          (e.mergeEquiv_survivor a b hab)).trans
        ((vpm_apply_survivor _ _ _ _ _ _ _ x).trans
          ((e.merge_mass a b x).trans (vpm_apply_survivor S hS a b hab hv hd x).symm))
    · exact (vpm_apply_unaffected _ _ _ _ _ _ _ x
        (e.mergeEquiv_ne_survivor a b hab j hj)).trans
        ((congrArg (T.channel x) (e.mergeEquiv_unaffected a b hab j hj)).trans
          ((e.apply x _).trans (vpm_apply_unaffected S hS a b hab hv hd x hj).symm)))

end OutputEquiv
end
end PerfectFunctionalRepresentations.MatrixOperations

namespace PerfectFunctionalRepresentations.MatrixOperations
universe u
variable {alpha : Type u} [Finite alpha] [Nonempty alpha]
noncomputable section
attribute [local instance] operationQuiver

namespace OperationStep
variable {S T S' : ActiveFiniteChannel alpha}

/-- A transported edge retains its tag and an explicit comparison to its old target. -/
structure Transport (edge : OperationStep S T) (S' : ActiveFiniteChannel alpha) where
  endpoint : ActiveFiniteChannel alpha
  step : OperationStep S' endpoint
  kind_eq : step.kind = edge.kind
  outputEquiv : OutputEquiv endpoint T

/-- Transport one actual operation across the supplied source equivalence. -/
def transport (edge : OperationStep S T) (e : OutputEquiv S S') : Transport edge S' := by
  cases edge with
  | pps hS l t ht0 ht1 =>
      exact ⟨_, .pps S' (e.isSingular hS) (e.equiv l) t ht0 ht1, rfl,
        (e.pps hS l t ht0 ht1).symm⟩
  | vps hS l mask hl hr =>
      exact ⟨_, .vps S' (e.isSingular hS) (e.equiv l) mask
        (e.vpsWitness l mask true hl) (e.vpsWitness l mask false hr), rfl,
        (e.vps hS l mask hl hr).symm⟩
  | ppm hS a b hab hp =>
      exact ⟨_, .ppm S' (e.isSingular hS) (e.mergeLower a b) (e.mergeUpper a b)
        (e.merge_lt a b hab) (e.ppmPattern a b hp), rfl, (e.ppm hS a b hab hp).symm⟩
  | vpm hS a b hab hv hd =>
      exact ⟨_, .vpm S' (e.isSingular hS) (e.mergeLower a b) (e.mergeUpper a b)
        (e.merge_lt a b hab) (e.vpmValue hS a b hv) (e.vpmDisjoint a b hd), rfl,
        (e.vpm hS a b hab hv hd).symm⟩
end OperationStep

namespace OperationPath
variable {S T S' : ActiveFiniteChannel alpha}

/-- The concrete transported path and the unchanged chronological tag word. -/
structure Transport (p : OperationPath S T) (S' : ActiveFiniteChannel alpha) where
  endpoint : ActiveFiniteChannel alpha
  path : OperationPath S' endpoint
  tags_eq : path.tags = p.tags
  outputEquiv : OutputEquiv endpoint T

/-- Structural path recursion transports every edge without adding operations. -/
def transport {S T : ActiveFiniteChannel alpha} (p : OperationPath S T)
    {S' : ActiveFiniteChannel alpha} (e : OutputEquiv S S') : Transport p S' :=
  match p with
  | .nil => ⟨S', nil, rfl, e.symm⟩
  | .cons p edge =>
      let q := transport p e
      let t := edge.transport q.outputEquiv.symm
      { endpoint := t.endpoint
        path := q.path.snoc t.step
        tags_eq := by
          change q.path.tags ++ [t.step.kind] = OperationPath.tags p ++ [edge.kind]
          rw [q.tags_eq, t.kind_eq]
        outputEquiv := t.outputEquiv }

theorem transport_allowed (p : OperationPath S T) (e : OutputEquiv S S')
    (P : OperationKind → Prop) : (p.transport e).path.Allowed P ↔ p.Allowed P := by
  simp only [Allowed, (p.transport e).tags_eq]

theorem transport_homogeneous (p : OperationPath S T) (e : OutputEquiv S S')
    (k : OperationKind) : (p.transport e).path.Homogeneous k ↔ p.Homogeneous k :=
  p.transport_allowed e _

end OperationPath

namespace Cascade
variable {S T U V : ActiveFiniteChannel alpha}

/-- A pure relabeling carries an empty operation path. -/
def ofOutputEquiv (e : OutputEquiv S T) : Cascade S T := ⟨S, OperationPath.nil, e⟩

/-- The identity cascade. -/
def refl (S : ActiveFiniteChannel alpha) : Cascade S S := ofOutputEquiv (.refl S)

/-- Regard an exact path as a cascade, without a change of its endpoint labels. -/
def ofPath (p : OperationPath S T) : Cascade S T := ⟨T, p, .refl T⟩

/-- Composition transports the second path back to the first concrete endpoint. -/
def comp (c : Cascade S T) (d : Cascade T U) : Cascade S U :=
  let q := d.path.transport c.outputEquiv.symm
  { endpoint := q.endpoint
    path := c.path.append q.path
    outputEquiv := q.outputEquiv.trans d.outputEquiv }

@[simp] theorem tags_comp (c : Cascade S T) (d : Cascade T U) :
    (c.comp d).path.tags = c.path.tags ++ d.path.tags := by
  simp only [comp, OperationPath.tags_append, OperationPath.Transport.tags_eq]

@[simp] theorem length_comp (c : Cascade S T) (d : Cascade T U) :
    (c.comp d).path.length = c.path.length + d.path.length := by
  simpa only [List.length_append, OperationPath.tags_length] using
    congrArg List.length (tags_comp c d)

theorem allowed_comp (c : Cascade S T) (d : Cascade T U) (P : OperationKind → Prop) :
    (c.comp d).path.Allowed P ↔ c.path.Allowed P ∧ d.path.Allowed P := by
  simp [OperationPath.Allowed, tags_comp, or_imp, forall_and]

/-- Semantic equivalence retains an actual bijection of the concrete endpoints. -/
abbrev Equivalent (c : Cascade S T) (d : Cascade S U) := OutputEquiv c.endpoint d.endpoint

/-- Cascades with the same nominal target have an explicit endpoint comparison. -/
def compare (c d : Cascade S T) : c.Equivalent d :=
  c.outputEquiv.trans d.outputEquiv.symm

/-- Left identity at the semantic endpoint, without equality of chosen witnesses. -/
def refl_comp (c : Cascade S T) : ((refl S).comp c).Equivalent c := compare _ _

/-- Right identity at the semantic endpoint. -/
def comp_refl (c : Cascade S T) : (c.comp (refl T)).Equivalent c := compare _ _

/-- Associativity compares the actual endpoints of the two concrete composites. -/
def comp_assoc (c : Cascade S T) (d : Cascade T U) (f : Cascade U V) :
    ((c.comp d).comp f).Equivalent (c.comp (d.comp f)) := compare _ _

@[simp] theorem tags_refl_comp (c : Cascade S T) :
    ((refl S).comp c).path.tags = c.path.tags := by
  simp [refl, ofOutputEquiv]

@[simp] theorem tags_comp_refl (c : Cascade S T) :
    (c.comp (refl T)).path.tags = c.path.tags := by
  simp [refl, ofOutputEquiv]

theorem tags_comp_assoc (c : Cascade S T) (d : Cascade T U) (f : Cascade U V) :
    ((c.comp d).comp f).path.tags = (c.comp (d.comp f)).path.tags := by
  simp only [tags_comp, List.append_assoc]

end Cascade

namespace NormalForm

variable {S T U : ActiveFiniteChannel alpha}

/-- Concatenate the three stored blocks and retain their directed final comparison. -/
def toCascade (nf : NormalForm S T) : Cascade S T where
  endpoint := nf.pmEndpoint
  path := (nf.pp.append nf.vp).append nf.pm
  outputEquiv := nf.outputEquiv

/-- The concrete cascade performs the PPS, VPS and PPM blocks in that order. -/
@[simp] theorem toCascade_tags (nf : NormalForm S T) :
    nf.toCascade.path.tags = (nf.pp.tags ++ nf.vp.tags) ++ nf.pm.tags := by
  simp only [toCascade, OperationPath.tags_append]

/-- The concatenated blocks use only the three operation kinds in Lemma 4. -/
theorem toCascade_normalizing (nf : NormalForm S T) : nf.toCascade.path.Normalizing := by
  intro k hk
  rw [toCascade_tags] at hk
  rcases List.mem_append.mp hk with hk | hk
  · rcases List.mem_append.mp hk with hk | hk
    · exact Or.inl (nf.pp_homogeneous k hk)
    · exact Or.inr (Or.inl (nf.vp_homogeneous k hk))
  · exact Or.inr (Or.inr (nf.pm_homogeneous k hk))

/-- Singularity after the first block, including when it is empty. -/
theorem pp_isSingular (nf : NormalForm S T) (hS : IsSingularChannel S.channel) :
    IsSingularChannel nf.ppEndpoint.channel := nf.pp.isSingular hS

/-- Singularity after the support-split block, including empty earlier blocks. -/
theorem vp_isSingular (nf : NormalForm S T) (hS : IsSingularChannel S.channel) :
    IsSingularChannel nf.vpEndpoint.channel := nf.vp.isSingular (nf.pp_isSingular hS)

/-- Singularity at the actual concrete endpoint, including three empty blocks. -/
theorem pm_isSingular (nf : NormalForm S T) (hS : IsSingularChannel S.channel) :
    IsSingularChannel nf.pmEndpoint.channel := nf.pm.isSingular (nf.vp_isSingular hS)

/-- Singularity at the compared endpoint follows from the explicit output bijection. -/
theorem isSingular (nf : NormalForm S T) (hS : IsSingularChannel S.channel) :
    IsSingularChannel T.channel := nf.outputEquiv.isSingular (nf.pm_isSingular hS)

/-- Follow the stored terminal comparison by a supplied output equivalence. -/
def transOutputEquiv (nf : NormalForm S T) (e : OutputEquiv T U) : NormalForm S U :=
  { nf with outputEquiv := nf.outputEquiv.trans e }

/-- Terminal relabeling does not alter the concrete operation word. -/
@[simp] theorem transOutputEquiv_tags (nf : NormalForm S T) (e : OutputEquiv T U) :
    (nf.transOutputEquiv e).toCascade.path.tags = nf.toCascade.path.tags := rfl

/-- Three empty blocks can express a pure directed output relabeling. -/
def ofOutputEquiv (e : OutputEquiv S T) : NormalForm S T where
  ppEndpoint := S
  vpEndpoint := S
  pmEndpoint := S
  pp := OperationPath.nil
  vp := OperationPath.nil
  pm := OperationPath.nil
  pp_homogeneous := OperationPath.allowed_nil _
  vp_homogeneous := OperationPath.allowed_nil _
  pm_homogeneous := OperationPath.allowed_nil _
  outputEquiv := e

/-- Keep the source and its labels with three empty blocks. -/
def refl (S : ActiveFiniteChannel alpha) : NormalForm S S := ofOutputEquiv (.refl S)

/-- A homogeneous PPS path supplies the first block; the remaining blocks are empty. -/
def ofPps (p : OperationPath S T) (hp : p.Homogeneous .pps) : NormalForm S T where
  ppEndpoint := T
  vpEndpoint := T
  pmEndpoint := T
  pp := p
  vp := OperationPath.nil
  pm := OperationPath.nil
  pp_homogeneous := hp
  vp_homogeneous := OperationPath.allowed_nil _
  pm_homogeneous := OperationPath.allowed_nil _
  outputEquiv := .refl T

/-- A homogeneous VPS path supplies the middle block; the other blocks are empty. -/
def ofVps (p : OperationPath S T) (hp : p.Homogeneous .vps) : NormalForm S T where
  ppEndpoint := S
  vpEndpoint := T
  pmEndpoint := T
  pp := OperationPath.nil
  vp := p
  pm := OperationPath.nil
  pp_homogeneous := OperationPath.allowed_nil _
  vp_homogeneous := hp
  pm_homogeneous := OperationPath.allowed_nil _
  outputEquiv := .refl T

/-- A homogeneous PPM path supplies the last block; the first two blocks are empty. -/
def ofPpm (p : OperationPath S T) (hp : p.Homogeneous .ppm) : NormalForm S T where
  ppEndpoint := S
  vpEndpoint := S
  pmEndpoint := T
  pp := OperationPath.nil
  vp := OperationPath.nil
  pm := p
  pp_homogeneous := OperationPath.allowed_nil _
  vp_homogeneous := OperationPath.allowed_nil _
  pm_homogeneous := hp
  outputEquiv := .refl T

end NormalForm
end
end PerfectFunctionalRepresentations.MatrixOperations
