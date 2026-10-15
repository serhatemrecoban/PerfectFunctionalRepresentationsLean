import PerfectFunctionalRepresentations.Matrix.OperationPaths
import Mathlib.Data.Tree.Basic
import Mathlib.Data.Fintype.Option
import Mathlib.Logic.Equiv.Sum

/-!
# Finite certificates and Lemma 4 normalization

Private proof support for C08. The split forest records strict proportional
ratios and Boolean support masks. Its finite fragments are gathered by endpoint
fibers, with an explicit leaf correspondence and pointwise channel coordinates.
Finite structural traversals realize those trees as three homogeneous concrete
paths. Their exact coordinates prove Lemma 4 without a rewrite-termination premise.
-/

namespace PerfectFunctionalRepresentations.MatrixOperations

open scoped BigOperators ENNReal
noncomputable section
attribute [local instance] Classical.propDecidable

universe u v
variable {N : Type v} {alpha : Type u}

@[reducible] private def sfLeaf : BinaryTree N → Type
  | .nil => Unit
  | .node _ l r => sfLeaf l ⊕ sfLeaf r

@[instance_reducible]
private def sfLeafFintype : (t : BinaryTree N) → Fintype (sfLeaf t)
  | .nil => inferInstanceAs (Fintype Unit)
  | .node _ l r => by
      letI := sfLeafFintype l
      letI := sfLeafFintype r
      exact inferInstanceAs (Fintype (sfLeaf l ⊕ sfLeaf r))

attribute [local instance] sfLeafFintype

private def sfLeafEnum : (t : BinaryTree N) → sfLeaf t ≃ Fin t.numLeaves
  | .nil => Equiv.ofUnique Unit (Fin 1)
  | .node _ l r => (Equiv.sumCongr (sfLeafEnum l) (sfLeafEnum r)).trans finSumFinEquiv

private def sfComb : Nat → BinaryTree Unit
  | 0 => .nil
  | n + 1 => .node () .nil (sfComb n)

private theorem sfComb_leaves (n : Nat) : (sfComb n).numLeaves = n + 1 := by
  induction n with
  | zero => rfl
  | succ n ih => simp only [sfComb, BinaryTree.numLeaves, ih]; omega

private def sfGatherShape (F : Type v) [Fintype F] [Nonempty F] : BinaryTree Unit :=
  sfComb (Fintype.card F - 1)

private theorem sfGatherShape_card (F : Type v) [Fintype F] [Nonempty F] :
    (sfGatherShape F).numLeaves = Fintype.card F := by
  rw [sfGatherShape, sfComb_leaves]
  exact Nat.sub_add_cancel (Fintype.card_pos_iff.mpr inferInstance)

private def sfGatherLeaves (F : Type v) [Fintype F] [Nonempty F] :
    sfLeaf (sfGatherShape F) ≃ F :=
  (sfLeafEnum (sfGatherShape F)).trans
    ((finCongr (sfGatherShape_card F)).trans (Fintype.equivFin F).symm)

private abbrev sfRatio := {t : NNReal // 0 < t ∧ t < 1}

private def sfCoeff : (t : BinaryTree sfRatio) → sfLeaf t → NNReal
  | .nil, _ => 1
  | .node q l _, .inl i => q.val * sfCoeff l i
  | .node q _ r, .inr i => (1 - q.val) * sfCoeff r i

private theorem sfCoeff_pos (t : BinaryTree sfRatio) (i : sfLeaf t) :
    0 < sfCoeff t i := by
  induction t with
  | nil => exact zero_lt_one
  | node q l r hl hr =>
      cases i with
      | inl i => exact mul_pos q.property.1 (hl i)
      | inr i => exact mul_pos (tsub_pos_iff_lt.mpr q.property.2) (hr i)

private theorem sfCoeff_sum (t : BinaryTree sfRatio) : ∑ i, sfCoeff t i = 1 := by
  classical
  induction t with
  | nil => simp [sfLeaf, sfCoeff]
  | node q l r hl hr =>
      change (∑ i : sfLeaf l ⊕ sfLeaf r, sfCoeff (.node q l r) i) = 1
      rw [Fintype.sum_sum_type]
      simp only [sfCoeff, ← Finset.mul_sum, hl, hr, mul_one]
      exact add_tsub_cancel_of_le q.property.2.le

private theorem sfCompensateMass (q : sfRatio) (w : NNReal) (v : ENNReal) :
    ((q.val * w : NNReal) : ENNReal) * v +
        (((1 - q.val) * w : NNReal) : ENNReal) * v = (w : ENNReal) * v := by
  rw [← add_mul, ← ENNReal.coe_add, ← add_mul,
    add_tsub_cancel_of_le q.property.2.le, one_mul]

private def sfRoute : (t : BinaryTree (alpha → Bool)) → alpha → sfLeaf t
  | .nil, _ => ()
  | .node mask l r, x => if mask x then .inl (sfRoute l x) else .inr (sfRoute r x)

@[reducible]
private def sfGraft : (t : BinaryTree N) → (sfLeaf t → BinaryTree N) → BinaryTree N
  | .nil, f => f ()
  | .node a l r, f => .node a
      (sfGraft l (fun i => f (.inl i))) (sfGraft r (fun i => f (.inr i)))

private theorem sfGraft_nil (f : sfLeaf (.nil : BinaryTree N) → BinaryTree N) :
    sfGraft .nil f = f () := rfl

private theorem sfGraft_node (a : N) (l r : BinaryTree N)
    (f : sfLeaf (.node a l r) → BinaryTree N) :
    sfGraft (.node a l r) f = .node a
      (sfGraft l (fun i => f (.inl i))) (sfGraft r (fun i => f (.inr i))) := rfl

private def sfLeafGraft : (t : BinaryTree N) → (f : sfLeaf t → BinaryTree N) →
    sfLeaf (sfGraft t f) ≃ Σ i : sfLeaf t, sfLeaf (f i)
  | .nil, f =>
      { toFun := fun j => ⟨(), j⟩
        invFun := fun j => by rcases j with ⟨⟨⟩, j⟩; exact j
        left_inv := fun _ => rfl
        right_inv := fun j => by rcases j with ⟨⟨⟩, j⟩; rfl }
  | .node _ l r, f =>
      (Equiv.sumCongr (sfLeafGraft l (fun i => f (.inl i)))
        (sfLeafGraft r (fun i => f (.inr i)))).trans
          (Equiv.sumSigmaDistrib (fun i => sfLeaf (f i))).symm

private theorem sfLeafGraft_nil (f : sfLeaf (.nil : BinaryTree N) → BinaryTree N)
    (j : sfLeaf (f ())) : sfLeafGraft .nil f j = ⟨(), j⟩ := rfl

private theorem sfLeafGraft_left (a : N) (l r : BinaryTree N)
    (f : sfLeaf (.node a l r) → BinaryTree N)
    (j : sfLeaf (sfGraft l (fun i => f (.inl i)))) :
    sfLeafGraft (.node a l r) f (.inl j) =
      ⟨.inl (sfLeafGraft l (fun i => f (.inl i)) j).1,
        (sfLeafGraft l (fun i => f (.inl i)) j).2⟩ := rfl

private theorem sfLeafGraft_right (a : N) (l r : BinaryTree N)
    (f : sfLeaf (.node a l r) → BinaryTree N)
    (j : sfLeaf (sfGraft r (fun i => f (.inr i)))) :
    sfLeafGraft (.node a l r) f (.inr j) =
      ⟨.inr (sfLeafGraft r (fun i => f (.inr i)) j).1,
        (sfLeafGraft r (fun i => f (.inr i)) j).2⟩ := rfl

private theorem sfRoute_graft (t : BinaryTree (alpha → Bool))
    (f : sfLeaf t → BinaryTree (alpha → Bool)) (x : alpha) :
    sfLeafGraft t f (sfRoute (sfGraft t f) x) =
      ⟨sfRoute t x, sfRoute (f (sfRoute t x)) x⟩ := by
  induction t with
  | nil => rfl
  | node mask l r hl hr =>
      by_cases hx : mask x = true
      · have hOld : sfRoute (.node mask l r) x = .inl (sfRoute l x) := if_pos hx
        have hNew : sfRoute (sfGraft (.node mask l r) f) x =
            .inl (sfRoute (sfGraft l (fun i => f (.inl i))) x) := if_pos hx
        exact (congrArg (sfLeafGraft (.node mask l r) f) hNew).trans
          ((sfLeafGraft_left mask l r f _).trans
            ((congrArg (fun p : Σ i : sfLeaf l, sfLeaf (f (.inl i)) =>
              (⟨.inl p.1, p.2⟩ : Σ i : sfLeaf (.node mask l r), sfLeaf (f i)))
                (hl (fun i => f (.inl i)))).trans
              (congrArg (fun i : sfLeaf (.node mask l r) =>
                (⟨i, sfRoute (f i) x⟩ : Σ i, sfLeaf (f i))) hOld).symm))
      · have hOld : sfRoute (.node mask l r) x = .inr (sfRoute r x) := if_neg hx
        have hNew : sfRoute (sfGraft (.node mask l r) f) x =
            .inr (sfRoute (sfGraft r (fun i => f (.inr i))) x) := if_neg hx
        exact (congrArg (sfLeafGraft (.node mask l r) f) hNew).trans
          ((sfLeafGraft_right mask l r f _).trans
            ((congrArg (fun p : Σ i : sfLeaf r, sfLeaf (f (.inr i)) =>
              (⟨.inr p.1, p.2⟩ : Σ i : sfLeaf (.node mask l r), sfLeaf (f i)))
                (hr (fun i => f (.inr i)))).trans
              (congrArg (fun i : sfLeaf (.node mask l r) =>
                (⟨i, sfRoute (f i) x⟩ : Σ i, sfLeaf (f i))) hOld).symm))

variable [Finite alpha] [Nonempty alpha]

/-- The two split layers. Leaf support equality includes nonemptiness through
the active endpoint. Coordinates count one routed fragment per sheet and row. -/
private structure SplitForest (S T : ActiveFiniteChannel alpha) where
  outer : Fin S.outputCard → BinaryTree sfRatio
  support : (i : Fin S.outputCard) → sfLeaf (outer i) → BinaryTree (alpha → Bool)
  label : (i : Fin S.outputCard) → (w : sfLeaf (outer i)) →
    sfLeaf (support i w) → Fin T.outputCard
  leaf_support : ∀ i w f x,
    (S.channel x i ≠ 0 ∧ sfRoute (support i w) x = f) ↔ T.channel x (label i w f) ≠ 0
  coordinates : ∀ x j, T.channel x j =
    ∑ i, ∑ w, if label i w (sfRoute (support i w) x) = j
      then (sfCoeff (outer i) w : ENNReal) * S.channel x i else 0

private def SplitForest.identity (S : ActiveFiniteChannel alpha) : SplitForest S S where
  outer _ := .nil
  support _ _ := .nil
  label i _ _ := i
  leaf_support i w f x := by cases f; simp [sfRoute]
  coordinates x j := by simp [sfLeaf, sfCoeff]

private abbrev SplitForest.Fragment {S T : ActiveFiniteChannel alpha} (c : SplitForest S T) :=
  (i : Fin S.outputCard) × (w : sfLeaf (c.outer i)) × sfLeaf (c.support i w)

private def SplitForest.target {S T : ActiveFiniteChannel alpha} (c : SplitForest S T)
    (f : c.Fragment) : Fin T.outputCard := c.label f.1 f.2.1 f.2.2

private theorem SplitForest.label_injective {S T : ActiveFiniteChannel alpha}
    (c : SplitForest S T) (i : Fin S.outputCard) (w : sfLeaf (c.outer i)) :
    Function.Injective (c.label i w) := by
  intro f g h
  obtain ⟨x, hx⟩ := T.output_active (c.label i w f)
  have hf := ((c.leaf_support i w f x).mpr hx).2
  have hg := ((c.leaf_support i w g x).mpr (h ▸ hx)).2
  exact hf.symm.trans hg

/-- Equal nonempty endpoint patterns cannot both occur within one sheet. -/
private theorem SplitForest.same_sheet_exclusion {S T : ActiveFiniteChannel alpha}
    (c : SplitForest S T) (i : Fin S.outputCard) (w : sfLeaf (c.outer i))
    (f g : sfLeaf (c.support i w))
    (h : ∀ x, T.channel x (c.label i w f) ≠ 0 ↔ T.channel x (c.label i w g) ≠ 0) :
    f = g := by
  obtain ⟨x, hx⟩ := T.output_active (c.label i w f)
  exact ((c.leaf_support i w f x).mpr hx).2.symm.trans
    ((c.leaf_support i w g x).mpr ((h x).mp hx)).2

private theorem SplitForest.target_surjective {S T : ActiveFiniteChannel alpha}
    (c : SplitForest S T) : Function.Surjective c.target := by
  classical
  intro j
  by_contra h
  obtain ⟨x, hx⟩ := T.output_active j
  apply hx
  rw [c.coordinates]
  apply Finset.sum_eq_zero
  intro i _
  apply Finset.sum_eq_zero
  intro w _
  have hn : c.label i w (sfRoute (c.support i w) x) ≠ j :=
    fun he => h ⟨⟨i, w, sfRoute (c.support i w) x⟩, he⟩
  exact if_neg hn

private def sfFirst : (t : BinaryTree N) → sfLeaf t
  | .nil => ()
  | .node _ l _ => .inl (sfFirst l)

/-- Each internal mask is a legal nonempty partition of its inherited region. -/
private def sfLegal : (alpha → Prop) → BinaryTree (alpha → Bool) → Prop
  | _, .nil => True
  | P, .node mask l r =>
      (∃ x, P x ∧ mask x = true) ∧ (∃ x, P x ∧ mask x = false) ∧
      sfLegal (fun x => P x ∧ mask x = true) l ∧
      sfLegal (fun x => P x ∧ mask x = false) r

omit [Finite alpha] [Nonempty alpha] in
private theorem sfLegal_of_leaves (t : BinaryTree (alpha → Bool)) (P : alpha → Prop)
    (h : ∀ f : sfLeaf t, ∃ x, P x ∧ sfRoute t x = f) : sfLegal P t := by
  induction t generalizing P with
  | nil => trivial
  | node mask l r hl hr =>
      have left : ∀ f : sfLeaf l, ∃ x, (P x ∧ mask x = true) ∧ sfRoute l x = f := by
        intro f
        obtain ⟨x, hx, hf⟩ := h (.inl f)
        cases hm : mask x with
        | false => simp [sfRoute, hm] at hf
        | true => exact ⟨x, ⟨hx, hm⟩, by simpa [sfRoute, hm] using hf⟩
      have right : ∀ f : sfLeaf r, ∃ x, (P x ∧ mask x = false) ∧ sfRoute r x = f := by
        intro f
        obtain ⟨x, hx, hf⟩ := h (.inr f)
        cases hm : mask x with
        | false => exact ⟨x, ⟨hx, hm⟩, by simpa [sfRoute, hm] using hf⟩
        | true => simp [sfRoute, hm] at hf
      exact ⟨let ⟨x, hx, _⟩ := left (sfFirst l); ⟨x, hx⟩,
        let ⟨x, hx, _⟩ := right (sfFirst r); ⟨x, hx⟩, hl _ left, hr _ right⟩

private theorem SplitForest.support_legal {S T : ActiveFiniteChannel alpha}
    (c : SplitForest S T) (i : Fin S.outputCard) (w : sfLeaf (c.outer i)) :
    sfLegal (fun x => S.channel x i ≠ 0) (c.support i w) := by
  apply sfLegal_of_leaves
  intro f
  obtain ⟨x, hx⟩ := T.output_active (c.label i w f)
  exact ⟨x, (c.leaf_support i w f x).mpr hx⟩

private def SplitForest.mass {S T : ActiveFiniteChannel alpha} (c : SplitForest S T)
    (x : alpha) (f : c.Fragment) : ENNReal :=
  if sfRoute (c.support f.1 f.2.1) x = f.2.2
    then (sfCoeff (c.outer f.1) f.2.1 : ENNReal) * S.channel x f.1 else 0

private def sfSourceValue (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (i : Fin S.outputCard) : ENNReal :=
  columnValue S.channel hS (S.activeEquiv i)

private theorem sfSourceValue_eq (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (i : Fin S.outputCard) (x : alpha) (hx : S.channel x i ≠ 0) :
    sfSourceValue S hS i = S.channel x i := columnValue_eq_of_ne_zero _ _ _ hx

private theorem sfSourceValue_pos (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (i : Fin S.outputCard) : 0 < sfSourceValue S hS i := columnValue_pos _ _ _

private def SplitForest.value {S T : ActiveFiniteChannel alpha} (c : SplitForest S T)
    (hS : IsSingularChannel S.channel) (f : c.Fragment) : ENNReal :=
  (sfCoeff (c.outer f.1) f.2.1 : ENNReal) * sfSourceValue S hS f.1

private theorem SplitForest.value_pos {S T : ActiveFiniteChannel alpha} (c : SplitForest S T)
    (hS : IsSingularChannel S.channel) (f : c.Fragment) : 0 < c.value hS f := by
  exact ENNReal.mul_pos (by exact_mod_cast ne_of_gt (sfCoeff_pos _ _))
    (ne_of_gt (sfSourceValue_pos S hS f.1))

private theorem SplitForest.value_ne_top {S T : ActiveFiniteChannel alpha} (c : SplitForest S T)
    (hS : IsSingularChannel S.channel) (f : c.Fragment) : c.value hS f ≠ ∞ :=
  ENNReal.mul_ne_top ENNReal.coe_ne_top (columnValue_ne_top _ _ _)

/-- Exact fragment coordinates, not merely a nominal weight sum. -/
private theorem SplitForest.mass_eq {S T : ActiveFiniteChannel alpha} (c : SplitForest S T)
    (hS : IsSingularChannel S.channel) (x : alpha) (f : c.Fragment) :
    c.mass x f = if T.channel x (c.target f) ≠ 0 then c.value hS f else 0 := by
  by_cases hx : T.channel x (c.target f) ≠ 0
  · obtain ⟨hs, hr⟩ := (c.leaf_support f.1 f.2.1 f.2.2 x).mpr hx
    rw [if_pos hx]
    simp only [mass, hr, ↓reduceIte, value, sfSourceValue_eq S hS f.1 x hs]
  · have hn := mt (c.leaf_support f.1 f.2.1 f.2.2 x).mp hx
    by_cases hs : S.channel x f.1 = 0
    · simp [mass, hs, hx]
    · have hr : sfRoute (c.support f.1 f.2.1) x ≠ f.2.2 := fun hr => hn ⟨hs, hr⟩
      simp [mass, hr, hx]

/-- Expand the one routed leaf in each sheet into the exhaustive fragment sum. -/
private theorem SplitForest.fragment_coordinates {S T : ActiveFiniteChannel alpha}
    (c : SplitForest S T) (x : alpha) (j : Fin T.outputCard) :
    T.channel x j = ∑ f : c.Fragment, if c.target f = j then c.mass x f else 0 := by
  classical
  rw [c.coordinates, Fintype.sum_sigma]
  apply Finset.sum_congr rfl
  intro i _
  rw [Fintype.sum_sigma]
  apply Finset.sum_congr rfl
  intro w _
  symm
  rw [Finset.sum_eq_single (sfRoute (c.support i w) x)]
  · simp [target, mass]
  · intro f _ hf
    simp [mass, Ne.symm hf]
  · simp

private abbrev SplitForest.Fiber {S T : ActiveFiniteChannel alpha} (c : SplitForest S T)
    (j : Fin T.outputCard) := {f : c.Fragment // c.target f = j}

private theorem SplitForest.fiber_nonempty {S T : ActiveFiniteChannel alpha} (c : SplitForest S T)
    (j : Fin T.outputCard) : Nonempty (c.Fiber j) := by
  obtain ⟨f, hf⟩ := c.target_surjective j
  exact ⟨⟨f, hf⟩⟩

attribute [local instance] SplitForest.fiber_nonempty

/-- All three actual finite tree layers. The gather leaf bijection supplies
both exhaustive coverage and distinct availability of every fragment. -/
private structure FactorizationCertificate (S T : ActiveFiniteChannel alpha) where
  forest : SplitForest S T
  gather : Fin T.outputCard → BinaryTree Unit
  leaves : (j : Fin T.outputCard) → sfLeaf (gather j) ≃ forest.Fiber j

private def SplitForest.certificate {S T : ActiveFiniteChannel alpha} (c : SplitForest S T) :
    FactorizationCertificate S T where
  forest := c
  gather j := sfGatherShape (c.Fiber j)
  leaves j := sfGatherLeaves (c.Fiber j)

private def FactorizationCertificate.identity (S : ActiveFiniteChannel alpha) :
    FactorizationCertificate S S where
  forest := SplitForest.identity S
  gather _ := .nil
  leaves j :=
    { toFun := fun _ => ⟨⟨j, (), ()⟩, rfl⟩
      invFun := fun _ => ()
      left_inv := fun f => by cases f; rfl
      right_inv := fun f => by
        rcases f with ⟨⟨i, ⟨⟩, ⟨⟩⟩, hf⟩
        change i = j at hf
        subst i
        rfl }

private def FactorizationCertificate.matchLeaves {S T : ActiveFiniteChannel alpha}
    (c : FactorizationCertificate S T) :
    ((j : Fin T.outputCard) × sfLeaf (c.gather j)) ≃ c.forest.Fragment :=
  (Equiv.sigmaCongrRight c.leaves).trans (Equiv.sigmaFiberEquiv c.forest.target)

private theorem FactorizationCertificate.match_target {S T : ActiveFiniteChannel alpha}
    (c : FactorizationCertificate S T) (j : Fin T.outputCard) (f : sfLeaf (c.gather j)) :
    c.forest.target (c.matchLeaves ⟨j, f⟩) = j := (c.leaves j f).property

private theorem SplitForest.fiber_coordinates {S T : ActiveFiniteChannel alpha}
    (c : SplitForest S T) (x : alpha) (j : Fin T.outputCard) :
    T.channel x j = ∑ f : c.Fiber j, c.mass x f.val := by
  classical
  rw [c.fragment_coordinates, ← Finset.sum_filter]
  exact Finset.sum_subtype _ (by simp) (c.mass x)

private theorem FactorizationCertificate.root_coordinates {S T : ActiveFiniteChannel alpha}
    (c : FactorizationCertificate S T) (x : alpha) (j : Fin T.outputCard) :
    T.channel x j = ∑ f : sfLeaf (c.gather j), c.forest.mass x (c.leaves j f).val := by
  rw [Equiv.sum_comp (c.leaves j) (fun f => c.forest.mass x f.val)]
  exact c.forest.fiber_coordinates x j

private theorem FactorizationCertificate.root_value {S T : ActiveFiniteChannel alpha}
    (c : FactorizationCertificate S T) (hS : IsSingularChannel S.channel)
    (hT : IsSingularChannel T.channel) (j : Fin T.outputCard) :
    sfSourceValue T hT j =
      ∑ f : sfLeaf (c.gather j), c.forest.value hS (c.leaves j f).val := by
  obtain ⟨x, hx⟩ := T.output_active j
  rw [sfSourceValue_eq T hT j x hx, c.root_coordinates]
  apply Finset.sum_congr rfl
  intro f _
  rw [c.forest.mass_eq, (c.leaves j f).property, if_pos hx]

/-- Subtree sums retain the common nonempty support, so every internal gather
node supplies the equal-support premise of a legal PPM. -/
private def sfGatherLegal (P : alpha → Prop) : (t : BinaryTree Unit) →
    (sfLeaf t → alpha → ENNReal) → Prop
  | .nil, _ => True
  | .node _ l r, mass =>
      (∀ x, (∑ f : sfLeaf l, mass (.inl f) x) ≠ 0 ↔ P x) ∧
      (∀ x, (∑ f : sfLeaf r, mass (.inr f) x) ≠ 0 ↔ P x) ∧
      sfGatherLegal P l (fun f => mass (.inl f)) ∧
      sfGatherLegal P r (fun f => mass (.inr f))

omit [Finite alpha] [Nonempty alpha] in
private theorem sfSum_support (t : BinaryTree Unit) (mass : sfLeaf t → alpha → ENNReal)
    (P : alpha → Prop) (h : ∀ f x, mass f x ≠ 0 ↔ P x) (x : alpha) :
    (∑ f, mass f x) ≠ 0 ↔ P x := by
  constructor
  · intro hn
    by_contra hp
    apply hn
    apply Finset.sum_eq_zero
    intro f _
    by_contra hf
    exact hp ((h f x).mp hf)
  · intro hp hz
    have he : mass (sfFirst t) x ≤ ∑ f, mass f x :=
      Finset.single_le_sum (f := fun f : sfLeaf t => mass f x)
        (fun _ _ => zero_le) (Finset.mem_univ (sfFirst t))
    rw [hz] at he
    exact ((h (sfFirst t) x).mpr hp) (le_antisymm he zero_le)

omit [Finite alpha] [Nonempty alpha] in
private theorem sfGatherLegal_of_leaves (t : BinaryTree Unit)
    (mass : sfLeaf t → alpha → ENNReal) (P : alpha → Prop)
    (h : ∀ f x, mass f x ≠ 0 ↔ P x) : sfGatherLegal P t mass := by
  induction t with
  | nil => trivial
  | node a l r hl hr =>
      exact ⟨sfSum_support l _ P (fun f => h (.inl f)),
        sfSum_support r _ P (fun f => h (.inr f)),
        hl _ (fun f => h (.inl f)), hr _ (fun f => h (.inr f))⟩

private theorem FactorizationCertificate.gather_legal {S T : ActiveFiniteChannel alpha}
    (c : FactorizationCertificate S T) (hS : IsSingularChannel S.channel)
    (j : Fin T.outputCard) :
    sfGatherLegal (fun x => T.channel x j ≠ 0) (c.gather j)
      (fun f x => c.forest.mass x (c.leaves j f).val) := by
  apply sfGatherLegal_of_leaves
  intro f x
  rw [c.forest.mass_eq hS x _, (c.leaves j f).property]
  by_cases hx : T.channel x j ≠ 0
  · simp [hx, ne_of_gt (c.forest.value_pos hS (c.leaves j f).val)]
  · simp [hx]

private theorem sfKeep_eq_left {n : Nat} (l k : Fin n) :
    splitKeep l k = splitLeft l ↔ k = l := by
  rw [← splitKeep_self l]
  exact (splitKeep_injective l).eq_iff

private theorem sfIndex_left {n : Nat} (l k : Fin n) (b : Bool) :
    vpsIndex l b k = splitLeft l ↔ k = l ∧ b = true := by
  by_cases hk : k = l
  · subst k; cases b <;> simp [vpsIndex, Ne.symm (splitLeft_ne_right l)]
  · simp [vpsIndex, hk, sfKeep_eq_left]

private theorem sfIndex_right {n : Nat} (l k : Fin n) (b : Bool) :
    vpsIndex l b k = splitRight l ↔ k = l ∧ b = false := by
  by_cases hk : k = l
  · subst k; cases b <;> simp [vpsIndex, splitLeft_ne_right]
  · simp [vpsIndex, hk]

private theorem sfIndex_keep {n : Nat} (l k j : Fin n) (b : Bool) (hj : j ≠ l) :
    vpsIndex l b k = splitKeep l j ↔ k = j := by
  by_cases hk : k = l
  · subst k
    have hn : splitLeft l ≠ splitKeep l j := Ne.symm (fun he => hj ((sfKeep_eq_left l j).mp he))
    cases b <;> simp [vpsIndex, hn, Ne.symm (splitKeep_ne_right l j), Ne.symm hj]
  · simp [vpsIndex, hk, (splitKeep_injective l).eq_iff]

private theorem sfPps_support (T : ActiveFiniteChannel alpha) (hT : IsSingularChannel T.channel)
    (l k : Fin T.outputCard) (q : sfRatio) (b : Bool) (x : alpha) :
    (pps T hT l q.val q.property.1 q.property.2).channel x (vpsIndex l b k) ≠ 0 ↔
      T.channel x k ≠ 0 := by
  by_cases hk : k = l
  · subst k
    cases b <;> simp only [vpsIndex_selected, Bool.false_eq_true, ↓reduceIte]
    · exact pps_right_ne_zero_iff T hT l q.val q.property.1 q.property.2 x
    · exact pps_left_ne_zero_iff T hT l q.val q.property.1 q.property.2 x
  · rw [vpsIndex_unaffected _ _ hk, pps_keep _ _ _ _ _ _ _ hk]

private def sfPpsSupport {S T : ActiveFiniteChannel alpha} (c : SplitForest S T)
    (i : Fin S.outputCard) : sfLeaf (BinaryTree.node q (c.outer i) (c.outer i)) →
      BinaryTree (alpha → Bool)
  | .inl w => c.support i w
  | .inr w => c.support i w

private def sfPpsLabel {S T : ActiveFiniteChannel alpha} (c : SplitForest S T)
    (l : Fin T.outputCard) (q : sfRatio) (i : Fin S.outputCard)
    (w : sfLeaf (BinaryTree.node q (c.outer i) (c.outer i))) :
    sfLeaf (sfPpsSupport (q := q) c i w) → Fin (T.outputCard + 1) :=
  match w with
  | .inl w => fun f => vpsIndex l true (c.label i w f)
  | .inr w => fun f => vpsIndex l false (c.label i w f)

/-- Uniformly split each outer root. Every old sheet has two positive copies;
the copies of an unselected fragment compensate exactly. No complexity bound is
needed for this finite certificate, so conditional dependent carriers are avoided. -/
private def SplitForest.appendPps {S T : ActiveFiniteChannel alpha} (c : SplitForest S T)
    (hT : IsSingularChannel T.channel) (l : Fin T.outputCard) (q : sfRatio) :
    SplitForest S (pps T hT l q.val q.property.1 q.property.2) where
  outer i := .node q (c.outer i) (c.outer i)
  support := sfPpsSupport c
  label := sfPpsLabel c l q
  leaf_support i w f x := by
    cases w with
    | inl w => exact (c.leaf_support i w f x).trans (sfPps_support T hT l _ q true x).symm
    | inr w => exact (c.leaf_support i w f x).trans (sfPps_support T hT l _ q false x).symm
  coordinates x j := by
    rcases split_cases l j with rfl | ⟨k, rfl⟩
    · rw [pps_right, c.coordinates]
      simp only [pps_outputCard]
      simp only [Fintype.sum_sum_type, sfPpsSupport, sfPpsLabel, sfCoeff,
        sfIndex_right, Bool.true_eq_false, and_false, if_false, Finset.sum_const_zero,
        zero_add, and_true, ENNReal.coe_mul, mul_assoc]
      simp only [Finset.mul_sum, mul_ite, mul_zero]
    · by_cases hk : k = l
      · subst k
        rw [splitKeep_self, pps_left, c.coordinates]
        simp only [pps_outputCard]
        simp only [Fintype.sum_sum_type, sfPpsSupport, sfPpsLabel, sfCoeff,
          sfIndex_left, Bool.false_eq_true, and_false, if_false, Finset.sum_const_zero,
          add_zero, and_true, ENNReal.coe_mul, mul_assoc]
        simp only [Finset.mul_sum, mul_ite, mul_zero]
      · rw [pps_keep _ _ _ _ _ _ _ hk, c.coordinates]
        simp only [pps_outputCard]
        simp only [Fintype.sum_sum_type, sfPpsSupport, sfPpsLabel, sfCoeff,
          sfIndex_keep _ _ _ _ hk, ← Finset.sum_add_distrib]
        apply Finset.sum_congr rfl
        intro i _
        apply Finset.sum_congr rfl
        intro w _
        by_cases he : c.label i w (sfRoute (c.support i w) x) = k
        · simp only [he, ↓reduceIte]
          exact (sfCompensateMass q (sfCoeff (c.outer i) w) (S.channel x i)).symm
        · simp [he]

omit [Finite alpha] [Nonempty alpha] in
private theorem sfRoute_graft_eq (t : BinaryTree (alpha → Bool))
    (f : sfLeaf t → BinaryTree (alpha → Bool)) (x : alpha)
    (i : sfLeaf t) (j : sfLeaf (f i)) :
    sfRoute (sfGraft t f) x = (sfLeafGraft t f).symm ⟨i, j⟩ ↔
      sfRoute t x = i ∧ sfRoute (f i) x = j := by
  constructor
  · intro h
    have he := (sfRoute_graft t f x).symm.trans
      ((congrArg (sfLeafGraft t f) h).trans ((sfLeafGraft t f).apply_symm_apply ⟨i, j⟩))
    have hi := congrArg Sigma.fst he
    change sfRoute t x = i at hi
    refine ⟨hi, ?_⟩
    subst i
    simpa only [Sigma.mk.inj_iff, heq_eq_eq, true_and] using he
  · rintro ⟨hi, hj⟩
    subst i
    apply (sfLeafGraft t f).injective
    rw [sfRoute_graft, Equiv.apply_symm_apply, hj]

@[reducible]
private def sfVpsTwig (mask : alpha → Bool) : Bool → BinaryTree (alpha → Bool)
  | true => .node mask .nil .nil
  | false => .nil

private def sfVpsTwigLabel {n : Nat} (l k : Fin n) (mask : alpha → Bool) :
    (b : Bool) → sfLeaf (sfVpsTwig mask b) → Fin (n + 1)
  | true, .inl _ => splitLeft l
  | true, .inr _ => splitRight l
  | false, _ => splitKeep l k

omit [Finite alpha] [Nonempty alpha] in
private theorem sfVpsTwig_route {n : Nat} (l k : Fin n) (mask : alpha → Bool) (x : alpha)
    (b : Bool) (hb : b = true ↔ k = l) :
    sfVpsTwigLabel l k mask b
      (sfRoute (sfVpsTwig mask b) x) = vpsIndex l (mask x) k := by
  cases b
  · have h : k ≠ l := fun h => Bool.false_ne_true (hb.mpr h)
    simp [sfVpsTwigLabel, vpsIndex, h]
  · have h : k = l := hb.mp rfl
    subst k
    cases hx : mask x <;> simp [sfVpsTwigLabel, sfRoute, vpsIndex, hx]

private theorem sfVpsTwig_support (T : ActiveFiniteChannel alpha)
    (hT : IsSingularChannel T.channel) (l k : Fin T.outputCard) (mask : alpha → Bool)
    (hl : ∃ x, T.channel x l ≠ 0 ∧ mask x = true)
    (hr : ∃ x, T.channel x l ≠ 0 ∧ mask x = false)
    (b : Bool) (hb : b = true ↔ k = l) (z : sfLeaf (sfVpsTwig mask b)) (x : alpha) :
    (T.channel x k ≠ 0 ∧ sfRoute (sfVpsTwig mask b) x = z) ↔
      (vps T hT l mask hl hr).channel x (sfVpsTwigLabel l k mask b z) ≠ 0 := by
  revert z
  cases b
  · have h : k ≠ l := fun h => Bool.false_ne_true (hb.mpr h)
    intro z
    cases z
    simpa [sfRoute, sfVpsTwigLabel, sfVpsTwig] using
      (congrArg (fun p : ENNReal => p ≠ 0) (vps_keep T hT l mask hl hr x h)).symm
  · have h : k = l := hb.mp rfl
    subst k
    intro z
    rcases z with ⟨⟩ | ⟨⟩
    · simpa [sfRoute, sfVpsTwigLabel, sfVpsTwig] using
        (vps_left_ne_zero_iff T hT l mask hl hr x).symm
    · simpa [sfRoute, sfVpsTwigLabel, sfVpsTwig] using
        (vps_right_ne_zero_iff T hT l mask hl hr x).symm

private def sfVpsSupport {S T : ActiveFiniteChannel alpha} (c : SplitForest S T)
    (l : Fin T.outputCard) (mask : alpha → Bool) (i : Fin S.outputCard)
    (w : sfLeaf (c.outer i)) : BinaryTree (alpha → Bool) :=
  sfGraft (c.support i w) (fun f => sfVpsTwig mask (decide (c.label i w f = l)))

private def sfVpsLabel {S T : ActiveFiniteChannel alpha} (c : SplitForest S T)
    (l : Fin T.outputCard) (mask : alpha → Bool) (i : Fin S.outputCard)
    (w : sfLeaf (c.outer i)) (f : sfLeaf (sfVpsSupport c l mask i w)) :
    Fin (T.outputCard + 1) :=
  let p := sfLeafGraft (c.support i w)
    (fun f => sfVpsTwig mask (decide (c.label i w f = l))) f
  sfVpsTwigLabel l (c.label i w p.1) mask (decide (c.label i w p.1 = l)) p.2

private theorem sfVpsLabel_inverse {S T : ActiveFiniteChannel alpha} (c : SplitForest S T)
    (l : Fin T.outputCard) (mask : alpha → Bool) (i : Fin S.outputCard)
    (w : sfLeaf (c.outer i)) (f : sfLeaf (c.support i w))
    (z : sfLeaf (sfVpsTwig mask (decide (c.label i w f = l)))) :
    sfVpsLabel c l mask i w ((sfLeafGraft (c.support i w)
      (fun f => sfVpsTwig mask (decide (c.label i w f = l)))).symm ⟨f, z⟩) =
        sfVpsTwigLabel l (c.label i w f) mask (decide (c.label i w f = l)) z := by
  exact congrArg (fun p : Σ f : sfLeaf (c.support i w),
    sfLeaf (sfVpsTwig mask (decide (c.label i w f = l))) =>
      sfVpsTwigLabel l (c.label i w p.1) mask (decide (c.label i w p.1 = l)) p.2)
    ((sfLeafGraft (c.support i w)
      (fun f => sfVpsTwig mask (decide (c.label i w f = l)))).apply_symm_apply ⟨f, z⟩)

private theorem sfVpsLabel_route {S T : ActiveFiniteChannel alpha} (c : SplitForest S T)
    (l : Fin T.outputCard) (mask : alpha → Bool) (i : Fin S.outputCard)
    (w : sfLeaf (c.outer i)) (x : alpha) :
    sfVpsLabel c l mask i w (sfRoute (sfVpsSupport c l mask i w) x) =
      vpsIndex l (mask x) (c.label i w (sfRoute (c.support i w) x)) := by
  unfold sfVpsLabel sfVpsSupport
  rw [sfRoute_graft]
  exact sfVpsTwig_route _ _ _ _ _ (by simp only [decide_eq_true_eq])

private def SplitForest.appendVps {S T : ActiveFiniteChannel alpha} (c : SplitForest S T)
    (hT : IsSingularChannel T.channel) (l : Fin T.outputCard) (mask : alpha → Bool)
    (hl : ∃ x, T.channel x l ≠ 0 ∧ mask x = true)
    (hr : ∃ x, T.channel x l ≠ 0 ∧ mask x = false) :
    SplitForest S (vps T hT l mask hl hr) where
  outer := c.outer
  support := sfVpsSupport c l mask
  label := sfVpsLabel c l mask
  leaf_support i w f x := by
    obtain ⟨⟨f, z⟩, rfl⟩ :=
      (sfLeafGraft (c.support i w)
        (fun f => sfVpsTwig mask (decide (c.label i w f = l)))).symm.surjective f
    have hroute := sfRoute_graft_eq (c.support i w)
      (fun f => sfVpsTwig mask (decide (c.label i w f = l))) x f z
    have hlabel := sfVpsLabel_inverse c l mask i w f z
    exact (and_congr Iff.rfl hroute).trans (and_assoc.symm.trans
      ((and_congr (c.leaf_support i w f x) Iff.rfl).trans
        ((sfVpsTwig_support T hT l (c.label i w f) mask hl hr _
          (by simp only [decide_eq_true_eq]) z x).trans
            (congrArg (fun k => (vps T hT l mask hl hr).channel x k ≠ 0)
              hlabel).to_iff.symm)))
  coordinates x j := by
    rcases split_cases l j with rfl | ⟨k, rfl⟩
    · rw [vps_right, c.coordinates]
      simp only [vps_outputCard, sfVpsLabel_route]
      cases mask x <;> simp [sfIndex_right]
    · by_cases hk : k = l
      · subst k
        rw [splitKeep_self, vps_left, c.coordinates]
        simp only [vps_outputCard, sfVpsLabel_route]
        cases mask x <;> simp [sfIndex_left]
      · rw [vps_keep T hT l mask hl hr x hk, c.coordinates]
        simp only [vps_outputCard, sfVpsLabel_route]
        simp only [sfIndex_keep _ _ _ _ hk]

private def sfPpmIndex (T : ActiveFiniteChannel alpha) (a b : Fin T.outputCard)
    (hab : a < b) (k : Fin T.outputCard) : Fin (T.outputCard - 1) :=
  mergeIndex (mergeSourceEquiv T a) (mergeSourceEquiv T b)
    ((mergeSourceEquiv_lt_iff T a b).mpr hab) (mergeSourceEquiv T k)

private theorem sfPpmIndex_survivor (T : ActiveFiniteChannel alpha)
    (a b : Fin T.outputCard) (hab : a < b) (k : Fin T.outputCard) :
    sfPpmIndex T a b hab k = activeMergeSurvivor T a b hab ↔ k = a ∨ k = b := by
  unfold sfPpmIndex activeMergeSurvivor
  rw [mergeIndex_fiber_survivor]
  simp only [Equiv.apply_eq_iff_eq]

private theorem sfPpmIndex_retained (T : ActiveFiniteChannel alpha)
    (a b : Fin T.outputCard) (hab : a < b) (j : Fin (T.outputCard - 1))
    (hj : j ≠ activeMergeSurvivor T a b hab) (k : Fin T.outputCard) :
    sfPpmIndex T a b hab k = j ↔ k = activeMergeRetained T b j := by
  unfold sfPpmIndex
  rw [mergeIndex_fiber_ne _ _ _ _ hj]
  rw [← activeMergeRetained_source T b j]
  exact (mergeSourceEquiv T).injective.eq_iff

private theorem sfPpm_support_sum {u v : ENNReal} (h : u ≠ 0 ↔ v ≠ 0) :
    u + v ≠ 0 ↔ u ≠ 0 := by
  by_cases hu : u = 0
  · have hv : v = 0 := by
      by_contra hv
      exact (h.mpr hv) hu
    simp [hu, hv]
  · exact iff_of_true (fun hz => hu (add_eq_zero.mp hz).1) hu

private theorem sfPpm_support (T : ActiveFiniteChannel alpha)
    (hT : IsSingularChannel T.channel) (a b : Fin T.outputCard) (hab : a < b)
    (hpattern : ∀ x, T.channel x a ≠ 0 ↔ T.channel x b ≠ 0)
    (k : Fin T.outputCard) (x : alpha) :
    (ppm T hT a b hab hpattern).channel x (sfPpmIndex T a b hab k) ≠ 0 ↔
      T.channel x k ≠ 0 := by
  by_cases hk : sfPpmIndex T a b hab k = activeMergeSurvivor T a b hab
  · rw [hk, ppm_apply_survivor]
    rcases (sfPpmIndex_survivor T a b hab k).mp hk with rfl | rfl
    · exact sfPpm_support_sum (hpattern x)
    · exact (sfPpm_support_sum (hpattern x)).trans (hpattern x)
  · rw [ppm_apply_unaffected T hT a b hab hpattern x hk]
    have hret := (sfPpmIndex_retained T a b hab _ hk k).mp rfl
    rw [← hret]

/-- Legal equal-pattern merges cannot collapse two distinct leaves of one sheet. -/
private theorem SplitForest.ppm_label_injective {S T : ActiveFiniteChannel alpha}
    (c : SplitForest S T) (hT : IsSingularChannel T.channel)
    (a b : Fin T.outputCard) (hab : a < b)
    (hpattern : ∀ x, T.channel x a ≠ 0 ↔ T.channel x b ≠ 0)
    (i : Fin S.outputCard) (w : sfLeaf (c.outer i)) :
    Function.Injective (fun f => sfPpmIndex T a b hab (c.label i w f)) := by
  intro f g he
  apply c.same_sheet_exclusion i w f g
  intro x
  have hv := congrArg
    (fun j : Fin (T.outputCard - 1) => (ppm T hT a b hab hpattern).channel x j) he
  exact (sfPpm_support T hT a b hab hpattern (c.label i w f) x).symm.trans
    ((Iff.of_eq (congrArg (fun z : ENNReal => z ≠ 0) hv)).trans
      (sfPpm_support T hT a b hab hpattern (c.label i w g) x))

private theorem sfPpm_coordinates {S T : ActiveFiniteChannel alpha}
    (c : SplitForest S T) (hT : IsSingularChannel T.channel)
    (a b : Fin T.outputCard) (hab : a < b)
    (hpattern : ∀ x, T.channel x a ≠ 0 ↔ T.channel x b ≠ 0)
    (x : alpha) (j : Fin (T.outputCard - 1)) :
    (ppm T hT a b hab hpattern).channel x j =
      ∑ i, ∑ w, if sfPpmIndex T a b hab
        (c.label i w (sfRoute (c.support i w) x)) = j
        then (sfCoeff (c.outer i) w : ENNReal) * S.channel x i else 0 := by
  by_cases hj : j = activeMergeSurvivor T a b hab
  · subst j
    rw [ppm_apply_survivor, c.coordinates, c.coordinates, ← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro i _
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro w _
    simp only [sfPpmIndex_survivor]
    by_cases ha : c.label i w (sfRoute (c.support i w) x) = a
    · simp [ha, ne_of_lt hab]
    · by_cases hb : c.label i w (sfRoute (c.support i w) x) = b
      · simp [hb, ne_of_gt hab]
      · simp [ha, hb]
  · rw [ppm_apply_unaffected T hT a b hab hpattern x hj, c.coordinates]
    apply Finset.sum_congr rfl
    intro i _
    apply Finset.sum_congr rfl
    intro w _
    simp only [sfPpmIndex_retained T a b hab j hj]

private def SplitForest.appendPpm {S T : ActiveFiniteChannel alpha}
    (c : SplitForest S T) (hT : IsSingularChannel T.channel)
    (a b : Fin T.outputCard) (hab : a < b)
    (hpattern : ∀ x, T.channel x a ≠ 0 ↔ T.channel x b ≠ 0) :
    SplitForest S (ppm T hT a b hab hpattern) where
  outer := c.outer
  support := c.support
  label i w f := sfPpmIndex T a b hab (c.label i w f)
  leaf_support i w f x :=
    (c.leaf_support i w f x).trans (sfPpm_support T hT a b hab hpattern _ x).symm
  coordinates := sfPpm_coordinates c hT a b hab hpattern

private theorem SplitForest.appendPpm_label_injective {S T : ActiveFiniteChannel alpha}
    (c : SplitForest S T) (hT : IsSingularChannel T.channel)
    (a b : Fin T.outputCard) (hab : a < b)
    (hpattern : ∀ x, T.channel x a ≠ 0 ↔ T.channel x b ≠ 0)
    (i : Fin S.outputCard) (w : sfLeaf (c.outer i)) :
    Function.Injective ((c.appendPpm hT a b hab hpattern).label i w) :=
  c.ppm_label_injective hT a b hab hpattern i w

private def SplitForest.ofPath {S T : ActiveFiniteChannel alpha}
    (p : OperationPath S T) (hp : p.Normalizing) : SplitForest S T := by
  induction p with
  | nil => exact SplitForest.identity _
  | cons p e ih =>
      have h := (OperationPath.allowed_snoc
        (fun k => k = .pps ∨ k = .vps ∨ k = .ppm) p e).mp hp
      cases e with
      | pps hT l t ht0 ht1 => exact (ih h.1).appendPps hT l ⟨t, ht0, ht1⟩
      | vps hT l mask hl hr => exact (ih h.1).appendVps hT l mask hl hr
      | ppm hT a b hab hpattern => exact (ih h.1).appendPpm hT a b hab hpattern
      | vpm hT a b hab hv hd => simp [OperationStep.kind] at h

/-- A certificate for the given original path. The only path recursion is on
its predecessor, never on a longer rewritten or assumed normalized path. -/
private def FactorizationCertificate.ofPath {S T : ActiveFiniteChannel alpha}
    (p : OperationPath S T) (hp : p.Normalizing) : FactorizationCertificate S T :=
  (SplitForest.ofPath p hp).certificate

example (S : ActiveFiniteChannel alpha) :
    (SplitForest.ofPath (OperationPath.nil : OperationPath S S)
      (OperationPath.allowed_nil _)).outer = (SplitForest.identity S).outer := rfl

example {S T : ActiveFiniteChannel alpha} (p : OperationPath S T) (hp : p.Normalizing)
    (x : alpha) (j : Fin T.outputCard) :
    T.channel x j =
      ∑ f : sfLeaf ((FactorizationCertificate.ofPath p hp).gather j),
        (FactorizationCertificate.ofPath p hp).forest.mass x
          ((FactorizationCertificate.ofPath p hp).leaves j f).val :=
  (FactorizationCertificate.ofPath p hp).root_coordinates x j

-- R12: a sheet may contain several support pieces. Splitting one assigned
-- endpoint copies the other piece twice, with the same unaffected output label.
example {S T : ActiveFiniteChannel alpha} (c : SplitForest S T)
    (hT : IsSingularChannel T.channel) (q : sfRatio)
    (i : Fin S.outputCard) (w : sfLeaf (c.outer i))
    (f g : sfLeaf (c.support i w)) (hfg : f ≠ g) :
    let d := c.appendPps hT (c.label i w f) q
    d.label i (.inl w) g = splitKeep (c.label i w f) (c.label i w g) ∧
      d.label i (.inr w) g = splitKeep (c.label i w f) (c.label i w g) := by
  have hg : c.label i w g ≠ c.label i w f := fun he => hfg ((c.label_injective i w he).symm)
  exact ⟨vpsIndex_unaffected _ _ hg, vpsIndex_unaffected _ _ hg⟩

example {S T : ActiveFiniteChannel alpha} (c : SplitForest S T)
    (hT : IsSingularChannel T.channel) (l : Fin T.outputCard) (q : sfRatio)
    (i : Fin S.outputCard) (w : sfLeaf (c.outer i)) (f : sfLeaf (c.support i w)) (x : alpha) :
    let d := c.appendPps hT l q
    d.mass x ⟨i, .inl w, f⟩ + d.mass x ⟨i, .inr w, f⟩ = c.mass x ⟨i, w, f⟩ := by
  dsimp [SplitForest.mass, SplitForest.appendPps, sfPpsSupport, sfCoeff]
  by_cases hx : sfRoute (c.support i w) x = f
  · simp only [hx, ↓reduceIte]
    exact sfCompensateMass q (sfCoeff (c.outer i) w) (S.channel x i)
  · simp [hx]

example {S T : ActiveFiniteChannel alpha} (c : SplitForest S T)
    (hT : IsSingularChannel T.channel) (l j : Fin T.outputCard) (q : sfRatio)
    (hj : j ≠ l) (x : alpha) :
    ∑ f : sfLeaf ((c.appendPps hT l q).certificate.gather (splitKeep l j)),
      (c.appendPps hT l q).mass x
        ((c.appendPps hT l q).certificate.leaves (splitKeep l j) f).val = T.channel x j := by
  exact ((c.appendPps hT l q).certificate.root_coordinates x (splitKeep l j)).symm.trans
    (pps_keep T hT l q.val q.property.1 q.property.2 x hj)

-- Explicit correspondence inverses ensure distinct fragments cannot be lost
-- or silently identified when a gathering tree is rebuilt from a fiber.
example {S T : ActiveFiniteChannel alpha} (c : FactorizationCertificate S T)
    (f g : c.forest.Fragment) (hfg : f ≠ g) :
    c.matchLeaves.symm f ≠ c.matchLeaves.symm g := c.matchLeaves.symm.injective.ne hfg

example {S T : ActiveFiniteChannel alpha} (c : FactorizationCertificate S T)
    (f : c.forest.Fragment) : c.matchLeaves (c.matchLeaves.symm f) = f :=
  c.matchLeaves.apply_symm_apply f

-- R13: a legal VPS can refine a column whose positive value is exactly one.
private abbrev sfVpsOne : ActiveFiniteChannel Bool where
  outputCard := 1
  outputCard_pos := by decide
  channel _ := PMF.pure 0
  output_active j := ⟨true, by
    have hj : j = 0 := Subsingleton.elim _ _
    subst j
    simp⟩

private theorem sfVpsOne_singular : IsSingularChannel sfVpsOne.channel := by
  intro x z j _ _
  rfl

private theorem sfVpsOne_left : ∃ x, sfVpsOne.channel x 0 ≠ 0 ∧ id x = true :=
  ⟨true, by simp [sfVpsOne]⟩

private theorem sfVpsOne_right : ∃ x, sfVpsOne.channel x 0 ≠ 0 ∧ id x = false :=
  ⟨false, by simp [sfVpsOne]⟩

private abbrev sfVpsOneTarget :=
  vps sfVpsOne sfVpsOne_singular 0 id sfVpsOne_left sfVpsOne_right

private def sfVpsOneForest : SplitForest sfVpsOne sfVpsOneTarget :=
  (SplitForest.identity sfVpsOne).appendVps sfVpsOne_singular 0 id
    sfVpsOne_left sfVpsOne_right

example : sfSourceValue sfVpsOne sfVpsOne_singular 0 = 1 := by
  rw [sfSourceValue_eq sfVpsOne sfVpsOne_singular 0 true (by simp [sfVpsOne])]
  simp [sfVpsOne]

example : ∀ x : Bool,
    sfVpsOneTarget.channel x (splitLeft (0 : Fin 1)) = if x then 1 else 0 := by
  intro x
  rw [vps_left]
  simp [sfVpsOne]

example : ∀ x : Bool,
    sfVpsOneTarget.channel x (splitRight (0 : Fin 1)) = if x then 0 else 1 := by
  intro x
  rw [vps_right]
  cases x <;> simp [sfVpsOne]

example : ∀ j : Fin 2, ∃ f : sfVpsOneForest.Fragment, sfVpsOneForest.target f = j :=
  sfVpsOneForest.target_surjective

example : sfLegal (fun x => sfVpsOne.channel x 0 ≠ 0)
    (sfVpsOneForest.support 0 ()) :=
  sfVpsOneForest.support_legal 0 ()

-- R13: successive legal refinements of one full-support value-one column.
private abbrev sfRefineSource : ActiveFiniteChannel (Fin 3) where
  outputCard := 1
  outputCard_pos := by decide
  channel _ := PMF.pure 0
  output_active j := ⟨0, by
    have hj : j = 0 := Subsingleton.elim _ _
    subst j
    simp⟩

private theorem sfRefineSource_singular : IsSingularChannel sfRefineSource.channel := by
  intro x z j _ _
  rfl

private def sfRefineMask (i : Fin 3) (x : Fin 3) : Bool := decide (x = i)

private theorem sfRefineFirst_left :
    ∃ x, sfRefineSource.channel x 0 ≠ 0 ∧ sfRefineMask 0 x = true :=
  ⟨0, by simp [sfRefineSource, sfRefineMask]⟩

private theorem sfRefineFirst_right :
    ∃ x, sfRefineSource.channel x 0 ≠ 0 ∧ sfRefineMask 0 x = false :=
  ⟨1, by simp [sfRefineSource, sfRefineMask]⟩

private abbrev sfRefineFirst := vps sfRefineSource sfRefineSource_singular 0
  (sfRefineMask 0) sfRefineFirst_left sfRefineFirst_right

private theorem sfRefineFirst_singular : IsSingularChannel sfRefineFirst.channel :=
  vps_isSingular _ _ _ _ _ _

private theorem sfRefineFirst_zero (x : Fin 3) :
    sfRefineFirst.channel x (0 : Fin 2) = if x = 0 then 1 else 0 := by
  calc
    sfRefineFirst.channel x (0 : Fin 2) =
        if sfRefineMask 0 x then sfRefineSource.channel x 0 else 0 :=
      vps_left _ _ _ _ _ _ _
    _ = _ := by simp [sfRefineSource, sfRefineMask]

private theorem sfRefineFirst_one (x : Fin 3) :
    sfRefineFirst.channel x (1 : Fin 2) = if x = 0 then 0 else 1 := by
  calc
    sfRefineFirst.channel x (1 : Fin 2) =
        if sfRefineMask 0 x then 0 else sfRefineSource.channel x 0 :=
      vps_right _ _ _ _ _ _ _
    _ = _ := by simp [sfRefineSource, sfRefineMask]

private theorem sfRefineSecond_left :
    ∃ x, sfRefineFirst.channel x (1 : Fin 2) ≠ 0 ∧ sfRefineMask 1 x = true :=
  ⟨1, by rw [sfRefineFirst_one]; simp [sfRefineMask]⟩

private theorem sfRefineSecond_right :
    ∃ x, sfRefineFirst.channel x (1 : Fin 2) ≠ 0 ∧ sfRefineMask 1 x = false :=
  ⟨2, by rw [sfRefineFirst_one]; simp [sfRefineMask]⟩

private abbrev sfRefineSecond := vps sfRefineFirst sfRefineFirst_singular (1 : Fin 2)
  (sfRefineMask 1) sfRefineSecond_left sfRefineSecond_right

private def sfRefineFirstForest : SplitForest sfRefineSource sfRefineFirst :=
  (SplitForest.identity sfRefineSource).appendVps sfRefineSource_singular 0
    (sfRefineMask 0) sfRefineFirst_left sfRefineFirst_right

private def sfRefineSecondForest : SplitForest sfRefineSource sfRefineSecond :=
  sfRefineFirstForest.appendVps sfRefineFirst_singular (1 : Fin 2)
    (sfRefineMask 1) sfRefineSecond_left sfRefineSecond_right

private theorem sfRefineSecond_zero (x : Fin 3) :
    sfRefineSecond.channel x (0 : Fin 3) = if x = 0 then 1 else 0 := by
  calc
    sfRefineSecond.channel x (0 : Fin 3) = sfRefineFirst.channel x (0 : Fin 2) :=
      vps_keep sfRefineFirst sfRefineFirst_singular (1 : Fin 2) (sfRefineMask 1)
        sfRefineSecond_left sfRefineSecond_right x (by decide : (0 : Fin 2) ≠ 1)
    _ = _ := sfRefineFirst_zero x

private theorem sfRefineSecond_one (x : Fin 3) :
    sfRefineSecond.channel x (1 : Fin 3) = if x = 1 then 1 else 0 := by
  calc
    sfRefineSecond.channel x (1 : Fin 3) =
        if sfRefineMask 1 x then sfRefineFirst.channel x (1 : Fin 2) else 0 :=
      vps_left _ _ _ _ _ _ _
    _ = _ := by
      rw [sfRefineFirst_one]
      by_cases hx : x = 1
      · subst x; simp [sfRefineMask]
      · simp [sfRefineMask, hx]

private theorem sfRefineSecond_two (x : Fin 3) :
    sfRefineSecond.channel x (2 : Fin 3) = if x = 2 then 1 else 0 := by
  calc
    sfRefineSecond.channel x (2 : Fin 3) =
        if sfRefineMask 1 x then 0 else sfRefineFirst.channel x (1 : Fin 2) :=
      vps_right _ _ _ _ _ _ _
    _ = _ := by
      rw [sfRefineFirst_one]
      by_cases h0 : x = 0
      · subst x; simp [sfRefineMask]
      · by_cases h1 : x = 1
        · subst x; simp [sfRefineMask]
        · have h2 : x = 2 := by apply Fin.ext; omega
          subst x
          simp [sfRefineMask]

private theorem sfRefineSecond_coordinates (x j : Fin 3) :
    sfRefineSecond.channel x j = if x = j then 1 else 0 := by
  by_cases h0 : j = 0
  · subst j; exact sfRefineSecond_zero x
  · by_cases h1 : j = 1
    · subst j; exact sfRefineSecond_one x
    · have h2 : j = 2 := by apply Fin.ext; omega
      subst j
      exact sfRefineSecond_two x

example : ∀ j : Fin 3, sfRefineSecond.channel j j = 1 := by
  intro j
  simp [sfRefineSecond_coordinates]

example (x j : Fin 3) :
    (∑ f : sfLeaf (sfRefineSecondForest.certificate.gather j),
      sfRefineSecondForest.mass x (sfRefineSecondForest.certificate.leaves j f).val) =
        if x = j then 1 else 0 :=
  (sfRefineSecondForest.certificate.root_coordinates x j).symm.trans
    (sfRefineSecond_coordinates x j)

example : sfLegal (fun x => sfRefineSource.channel x 0 ≠ 0)
    (sfRefineSecondForest.support 0 ()) :=
  sfRefineSecondForest.support_legal 0 ()

-- R12: the first sheet has two support pieces; PPS selects only output zero.
-- The piece labelled one is duplicated and its two positive weights compensate.
private def sfRefinePps (q : sfRatio) :=
  sfRefineFirstForest.appendPps sfRefineFirst_singular (0 : Fin 2) q

private def sfRefineOtherLeaf : sfLeaf (sfRefineFirstForest.support 0 ()) :=
  sfRoute (sfRefineFirstForest.support 0 ()) 1

private theorem sfRefineOther_label :
    sfRefineFirstForest.label 0 () sfRefineOtherLeaf = (1 : Fin 2) := by
  have hs : sfRefineSource.channel 1 0 ≠ 0 := by simp [sfRefineSource]
  have hn := (sfRefineFirstForest.leaf_support 0 () sfRefineOtherLeaf 1).mp ⟨hs, rfl⟩
  by_contra h
  have hz : sfRefineFirstForest.label 0 () sfRefineOtherLeaf = (0 : Fin 2) := by
    apply Fin.ext
    change (sfRefineFirstForest.label 0 () sfRefineOtherLeaf).val = 0
    have hb : (sfRefineFirstForest.label 0 () sfRefineOtherLeaf).val < 2 :=
      (sfRefineFirstForest.label 0 () sfRefineOtherLeaf).isLt
    have hn1 : (sfRefineFirstForest.label 0 () sfRefineOtherLeaf).val ≠ 1 :=
      fun he => h (Fin.ext he)
    omega
  rw [hz, sfRefineFirst_zero] at hn
  simp at hn

example : sfRoute (sfRefineFirstForest.support 0 ()) 0 ≠ sfRefineOtherLeaf := by
  intro h
  have hn := (sfRefineFirstForest.leaf_support 0 () sfRefineOtherLeaf 0).mp
    ⟨by simp [sfRefineSource], h⟩
  apply hn
  exact (congrArg (sfRefineFirst.channel (0 : Fin 3)) sfRefineOther_label).trans
    (by simpa using sfRefineFirst_one 0)

example (q : sfRatio) :
    (sfRefinePps q).label 0 (.inl ()) sfRefineOtherLeaf = splitKeep (0 : Fin 2) (1 : Fin 2) ∧
      (sfRefinePps q).label 0 (.inr ()) sfRefineOtherLeaf = splitKeep (0 : Fin 2) (1 : Fin 2) := by
  exact ⟨(congrArg (vpsIndex (0 : Fin 2) true) sfRefineOther_label).trans
    (vpsIndex_unaffected _ _ (by decide)),
      (congrArg (vpsIndex (0 : Fin 2) false) sfRefineOther_label).trans
        (vpsIndex_unaffected _ _ (by decide))⟩

example (q : sfRatio) (x : Fin 3) :
    (sfRefinePps q).mass x ⟨0, .inl (), sfRefineOtherLeaf⟩ +
      (sfRefinePps q).mass x ⟨0, .inr (), sfRefineOtherLeaf⟩ =
        sfRefineFirstForest.mass x ⟨0, (), sfRefineOtherLeaf⟩ := by
  dsimp [sfRefinePps, SplitForest.mass, SplitForest.appendPps, sfPpsSupport, sfCoeff]
  by_cases hx : sfRoute (sfRefineFirstForest.support 0 ()) x = sfRefineOtherLeaf
  · simp only [hx, ↓reduceIte]
    simpa [sfRefineSource, ENNReal.coe_mul] using
      sfCompensateMass q (sfCoeff (sfRefineFirstForest.outer 0) ())
        (sfRefineSource.channel x 0)
  · simp [hx]

example (q : sfRatio) (x : Fin 3) :
    (∑ f : sfLeaf ((sfRefinePps q).certificate.gather (splitKeep (0 : Fin 2) (1 : Fin 2))),
      (sfRefinePps q).mass x
        ((sfRefinePps q).certificate.leaves (splitKeep (0 : Fin 2) (1 : Fin 2)) f).val) =
        if x = 0 then 0 else 1 := by
  exact ((sfRefinePps q).certificate.root_coordinates x
    (splitKeep (0 : Fin 2) (1 : Fin 2))).symm.trans
    ((pps_keep _ _ _ _ _ _ _ (by decide : (1 : Fin 2) ≠ 0)).trans
      (sfRefineFirst_one x))

-- R11/R13: singleton input with genuinely multiple active outputs.
private abbrev sfRSeed : ActiveFiniteChannel Unit where
  outputCard := 1
  outputCard_pos := by decide
  channel := fun _ => PMF.pure 0
  output_active := by
    intro j
    have hj : j = 0 := Subsingleton.elim _ _
    subst j
    exact ⟨(), by simp⟩

private theorem sfRSeed_singular : IsSingularChannel sfRSeed.channel := by
  intro x z j _ _
  rfl

private def sfRTwo (q : sfRatio) : ActiveFiniteChannel Unit :=
  pps sfRSeed sfRSeed_singular 0 q.val q.property.1 q.property.2

private theorem sfRTwo_singular (q : sfRatio) : IsSingularChannel (sfRTwo q).channel :=
  pps_isSingular sfRSeed sfRSeed_singular 0 q.val q.property.1 q.property.2

private def sfRThree (q : sfRatio) : ActiveFiniteChannel Unit :=
  pps (sfRTwo q) (sfRTwo_singular q) (1 : Fin 2) q.val q.property.1 q.property.2

private theorem sfRThree_singular (q : sfRatio) : IsSingularChannel (sfRThree q).channel :=
  pps_isSingular (sfRTwo q) (sfRTwo_singular q) (1 : Fin 2) q.val q.property.1 q.property.2

private theorem sfRActive (T : ActiveFiniteChannel Unit) (j : Fin T.outputCard) :
    T.channel () j ≠ 0 := by
  obtain ⟨x, hx⟩ := T.output_active j
  cases x
  exact hx

private def sfRId (q : sfRatio) := FactorizationCertificate.identity (sfRTwo q)

example (q : sfRatio) : (sfRTwo q).outputCard = 2 := rfl

example (q : sfRatio) (i : Fin 2) : (sfRId q).forest.outer i = .nil := rfl

example (q : sfRatio) (i : Fin 2) : (sfRId q).forest.support i () = .nil := rfl

example (q : sfRatio) (j : Fin 2) : (sfRId q).gather j = .nil := rfl

example (q : sfRatio) (j : Fin 2) :
    (sfRId q).matchLeaves ⟨j, ()⟩ = ⟨j, (), ()⟩ := rfl

example (q : sfRatio) (j : Fin 2) :
    (sfRId q).matchLeaves.symm ⟨j, (), ()⟩ = ⟨j, ()⟩ :=
  (sfRId q).matchLeaves.symm_apply_apply ⟨j, ()⟩

example (q : sfRatio) (j : Fin 2) :
    (sfRId q).forest.mass () ((sfRId q).leaves j ()).val = (sfRTwo q).channel () j := by
  simp [sfRId, FactorizationCertificate.identity, SplitForest.identity,
    SplitForest.mass, sfRoute, sfCoeff]
  rfl

example (q : sfRatio) (j : Fin 2) :
    (sfRTwo q).channel () j =
      ∑ f : sfLeaf ((sfRId q).gather j),
        (sfRId q).forest.mass () ((sfRId q).leaves j f).val :=
  (sfRId q).root_coordinates () j

example (q : sfRatio) (l : Fin (sfRTwo q).outputCard) (mask : Unit → Bool) :
    ¬ ((∃ x, (sfRTwo q).channel x l ≠ 0 ∧ mask x = true) ∧
      (∃ x, (sfRTwo q).channel x l ≠ 0 ∧ mask x = false)) := by
  rintro ⟨⟨⟨⟩, _, ht⟩, ⟨⟨⟩, _, hf⟩⟩
  rw [ht] at hf
  cases hf

private def sfRFirst (q : sfRatio) : SplitForest sfRSeed (sfRTwo q) :=
  (SplitForest.identity sfRSeed).appendPps sfRSeed_singular 0 q

private def sfRBefore (q : sfRatio) : SplitForest sfRSeed (sfRThree q) :=
  (sfRFirst q).appendPps (sfRTwo_singular q) (1 : Fin 2) q

private theorem sfRPattern (q : sfRatio) :
    ∀ x, (sfRThree q).channel x (0 : Fin 3) ≠ 0 ↔
      (sfRThree q).channel x (2 : Fin 3) ≠ 0 := by
  intro x
  cases x
  exact iff_of_true (sfRActive _ _) (sfRActive _ _)

private theorem sfRMergeLt : (0 : Fin 3) < 2 := by decide

private def sfRAfter (q : sfRatio) :=
  (sfRBefore q).appendPpm (sfRThree_singular q) (0 : Fin 3) (2 : Fin 3)
    sfRMergeLt (sfRPattern q)

private def sfRCert (q : sfRatio) := (sfRAfter q).certificate

private def sfRF00 (q : sfRatio) : (sfRAfter q).Fragment :=
  ⟨0, .inl (.inl ()), ()⟩

private def sfRF01 (q : sfRatio) : (sfRAfter q).Fragment :=
  ⟨0, .inl (.inr ()), ()⟩

private def sfRF10 (q : sfRatio) : (sfRAfter q).Fragment :=
  ⟨0, .inr (.inl ()), ()⟩

private def sfRF11 (q : sfRatio) : (sfRAfter q).Fragment :=
  ⟨0, .inr (.inr ()), ()⟩

example (q : sfRatio) : (sfRThree q).outputCard = 3 := rfl

example (q : sfRatio) : (2 : Fin 3).val + 1 =
    (sfRThree q).outputCard := rfl

example : (0 : Fin 3).val + 1 < (2 : Fin 3).val := by decide

example (q : sfRatio) : (sfRAfter q).target (sfRF00 q) = (0 : Fin 2) := rfl
example (q : sfRatio) : (sfRAfter q).target (sfRF01 q) = (1 : Fin 2) := rfl
example (q : sfRatio) : (sfRAfter q).target (sfRF10 q) = (0 : Fin 2) := rfl
example (q : sfRatio) : (sfRAfter q).target (sfRF11 q) = (0 : Fin 2) := rfl

example (q : sfRatio) : sfRF00 q ≠ sfRF11 q := by
  intro he
  have hp := eq_of_heq (Sigma.mk.inj_iff.mp he).2
  have hs := (Sigma.mk.inj_iff.mp hp).1
  cases hs

example (q : sfRatio) (f : (sfRAfter q).Fragment) :
    (sfRCert q).matchLeaves ((sfRCert q).matchLeaves.symm f) = f :=
  (sfRCert q).matchLeaves.apply_symm_apply f

example (q : sfRatio) :
    (sfRCert q).matchLeaves.symm (sfRF00 q) ≠
      (sfRCert q).matchLeaves.symm (sfRF11 q) := by
  intro he
  have hf := (sfRCert q).matchLeaves.symm.injective he
  have hp := eq_of_heq (Sigma.mk.inj_iff.mp hf).2
  have hs := (Sigma.mk.inj_iff.mp hp).1
  cases hs

example (q : sfRatio) (f : (sfRAfter q).Fragment) :
    ((sfRCert q).matchLeaves.symm f).1 = (sfRAfter q).target f := by
  have h := (sfRCert q).match_target
    ((sfRCert q).matchLeaves.symm f).1 ((sfRCert q).matchLeaves.symm f).2
  exact h.symm.trans
    (congrArg (sfRAfter q).target ((sfRCert q).matchLeaves.apply_symm_apply f))

example (q : sfRatio) (i : Fin sfRSeed.outputCard) (w : sfLeaf ((sfRBefore q).outer i))
    (f g : sfLeaf ((sfRBefore q).support i w))
    (hf : (sfRBefore q).label i w f = (0 : Fin 3))
    (hg : (sfRBefore q).label i w g = (2 : Fin 3)) : False := by
  have he : f = g := (sfRBefore q).same_sheet_exclusion i w f g (by
    intro x
    rw [hf, hg]
    exact sfRPattern q x)
  have h02 : (0 : Fin 3) = 2 :=
    hf.symm.trans ((congrArg ((sfRBefore q).label i w) he).trans hg)
  exact (by decide : (0 : Fin 3) ≠ 2) h02

example (q : sfRatio) (j : Fin 2) :
    (ppm (sfRThree q) (sfRThree_singular q) (0 : Fin 3) (2 : Fin 3)
      sfRMergeLt (sfRPattern q)).channel () j =
      ∑ f : sfLeaf ((sfRCert q).gather j),
        (sfRAfter q).mass () ((sfRCert q).leaves j f).val :=
  (sfRCert q).root_coordinates () j

private theorem sfRTwo_zero (q : sfRatio) :
    (sfRTwo q).channel () (0 : Fin 2) = (q.val : ENNReal) :=
  (pps_left sfRSeed sfRSeed_singular 0 q.val q.property.1 q.property.2 ()).trans (by
    simp [sfRSeed])

private theorem sfRTwo_one (q : sfRatio) :
    (sfRTwo q).channel () (1 : Fin 2) = ((1 - q.val : NNReal) : ENNReal) :=
  (pps_right sfRSeed sfRSeed_singular 0 q.val q.property.1 q.property.2 ()).trans (by
    simp [sfRSeed])

private theorem sfRThree_zero (q : sfRatio) :
    (sfRThree q).channel () (0 : Fin 3) = (q.val : ENNReal) :=
  (pps_keep (sfRTwo q) (sfRTwo_singular q) (1 : Fin 2) q.val q.property.1 q.property.2 ()
    (j := (0 : Fin 2)) (by exact (by decide : (0 : Fin 2) ≠ 1))).trans (sfRTwo_zero q)

private theorem sfRThree_one (q : sfRatio) :
    (sfRThree q).channel () (1 : Fin 3) =
      (q.val : ENNReal) * ((1 - q.val : NNReal) : ENNReal) :=
  (pps_left (sfRTwo q) (sfRTwo_singular q) (1 : Fin 2)
    q.val q.property.1 q.property.2 ()).trans
    (congrArg (fun z => (q.val : ENNReal) * z) (sfRTwo_one q))

private theorem sfRThree_two (q : sfRatio) :
    (sfRThree q).channel () (2 : Fin 3) =
      ((1 - q.val : NNReal) : ENNReal) * ((1 - q.val : NNReal) : ENNReal) :=
  (pps_right (sfRTwo q) (sfRTwo_singular q) (1 : Fin 2)
    q.val q.property.1 q.property.2 ()).trans
    (congrArg (fun z => ((1 - q.val : NNReal) : ENNReal) * z) (sfRTwo_one q))

example (q : sfRatio) :
    ∑ f : sfLeaf ((sfRCert q).gather (0 : Fin 2)),
      (sfRAfter q).mass () ((sfRCert q).leaves (0 : Fin 2) f).val =
      (q.val : ENNReal) +
        ((1 - q.val : NNReal) : ENNReal) * ((1 - q.val : NNReal) : ENNReal) := by
  have hs : activeMergeSurvivor (sfRThree q) (0 : Fin 3) (2 : Fin 3)
      sfRMergeLt =
      (0 : Fin 2) := by
    apply Fin.ext
    exact activeMergeSurvivor_val (sfRThree q) (0 : Fin 3) (2 : Fin 3)
      sfRMergeLt
  have h := ppm_apply_survivor (sfRThree q) (sfRThree_singular q) (0 : Fin 3) (2 : Fin 3)
    sfRMergeLt (sfRPattern q) ()
  exact ((sfRCert q).root_coordinates () (0 : Fin 2)).symm.trans
    (((congrArg
      (fun j : Fin 2 =>
        (ppm (sfRThree q) (sfRThree_singular q) (0 : Fin 3) (2 : Fin 3)
          sfRMergeLt (sfRPattern q)).channel () j)
      hs).symm.trans h).trans (congrArg₂ (· + ·) (sfRThree_zero q) (sfRThree_two q)))

example (q : sfRatio) :
    ∑ f : sfLeaf ((sfRCert q).gather (1 : Fin 2)),
      (sfRAfter q).mass () ((sfRCert q).leaves (1 : Fin 2) f).val =
      (q.val : ENNReal) * ((1 - q.val : NNReal) : ENNReal) := by
  have hs : activeMergeSurvivor (sfRThree q) (0 : Fin 3) (2 : Fin 3)
      sfRMergeLt =
      (0 : Fin 2) := by
    apply Fin.ext
    exact activeMergeSurvivor_val (sfRThree q) (0 : Fin 3) (2 : Fin 3)
      sfRMergeLt
  have hn : (1 : Fin 2) ≠ activeMergeSurvivor (sfRThree q) (0 : Fin 3) (2 : Fin 3)
      sfRMergeLt :=
    fun h => (by decide : (1 : Fin 2) ≠ 0) (h.trans hs)
  have hr : activeMergeRetained (sfRThree q) (2 : Fin 3) (1 : Fin 2) =
      (1 : Fin 3) := rfl
  exact ((sfRCert q).root_coordinates () (1 : Fin 2)).symm.trans
    ((ppm_apply_unaffected (sfRThree q) (sfRThree_singular q) (0 : Fin 3) (2 : Fin 3)
      sfRMergeLt (sfRPattern q) () hn).trans
      ((congrArg ((sfRThree q).channel ()) hr).trans (sfRThree_one q)))


/-! ## Concrete realization of the three finite layers -/

universe w z v₁ v₂

private def srSwap (A : Type v) (B : Type w) (R : Type z) :
    A ⊕ (B ⊕ R) ≃ B ⊕ (A ⊕ R) :=
  (Equiv.sumAssoc A B R).symm.trans
    ((Equiv.sumCongr (Equiv.sumComm A B) (Equiv.refl R)).trans
      (Equiv.sumAssoc B A R))

private def srSplitOption (R : Type v) : Unit ⊕ (Unit ⊕ R) ≃ Option (Unit ⊕ R) where
  toFun
    | .inl _ => some (.inl ())
    | .inr (.inl _) => none
    | .inr (.inr r) => some (.inr r)
  invFun
    | none => .inr (.inl ())
    | some (.inl _) => .inl ()
    | some (.inr r) => .inr (.inr r)
  left_inv x := by rcases x with ⟨⟩ | ⟨⟩ | r <;> rfl
  right_inv x := by rcases x with _ | (⟨⟩ | r) <;> rfl

/-- Every current object keeps one actual label after the chosen root splits. -/
private def srSplitLabels {R : Type v} {n : Nat} (e : Unit ⊕ R ≃ Fin n) :
    Unit ⊕ (Unit ⊕ R) ≃ Fin (n + 1) :=
  (srSplitOption R).trans ((Equiv.optionCongr e).trans
    (finSuccEquiv' (splitRight (e (.inl ())))).symm)

private theorem srSplitLabels_left {R : Type v} {n : Nat} (e : Unit ⊕ R ≃ Fin n) :
    srSplitLabels e (.inl ()) = splitLeft (e (.inl ())) := by
  change (finSuccEquiv' (splitRight (e (.inl ())))).symm (some (e (.inl ()))) = _
  rw [finSuccEquiv'_symm_some]
  exact splitKeep_self _

private theorem srSplitLabels_right {R : Type v} {n : Nat} (e : Unit ⊕ R ≃ Fin n) :
    srSplitLabels e (.inr (.inl ())) = splitRight (e (.inl ())) := by
  exact finSuccEquiv'_symm_none _

private theorem srSplitLabels_keep {R : Type v} {n : Nat} (e : Unit ⊕ R ≃ Fin n) (r : R) :
    srSplitLabels e (.inr (.inr r)) = splitKeep (e (.inl ())) (e (.inr r)) := by
  exact finSuccEquiv'_symm_some _ _

private theorem srPpsLeft {R : Type v} (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (e : Unit ⊕ R ≃ Fin S.outputCard) (q : sfRatio)
    (x : alpha) :
    (pps S hS (e (.inl ())) q.val q.property.1 q.property.2).channel x
      (srSplitLabels e (.inl ())) = (q.val : ENNReal) * S.channel x (e (.inl ())) := by
  rw [srSplitLabels_left, pps_left]

private theorem srPpsRight {R : Type v} (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (e : Unit ⊕ R ≃ Fin S.outputCard) (q : sfRatio)
    (x : alpha) :
    (pps S hS (e (.inl ())) q.val q.property.1 q.property.2).channel x
      (srSplitLabels e (.inr (.inl ()))) =
        ((1 - q.val : NNReal) : ENNReal) * S.channel x (e (.inl ())) := by
  rw [srSplitLabels_right, pps_right]

private theorem srPpsKeep {R : Type v} (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (e : Unit ⊕ R ≃ Fin S.outputCard) (q : sfRatio)
    (x : alpha) (r : R) :
    (pps S hS (e (.inl ())) q.val q.property.1 q.property.2).channel x
      (srSplitLabels e (.inr (.inr r))) = S.channel x (e (.inr r)) := by
  rw [srSplitLabels_keep, pps_keep]
  exact e.injective.ne (by simp)

-- R15 begins with a changing object-to-label correspondence: split label one
-- in a two-output source, then merge labels zero and two across the retained child.
private def srR15Start : Unit ⊕ Unit ≃ Fin 2 :=
  (Equiv.sumCongr (Equiv.ofUnique Unit (Fin 1))
    (Equiv.ofUnique Unit (Fin 1))).trans
      ((finSumFinEquiv : Fin 1 ⊕ Fin 1 ≃ Fin 2).trans (Equiv.swap 0 1))

example : srR15Start (.inl ()) = 1 := by decide
example : srR15Start (.inr ()) = 0 := by decide
example : srSplitLabels srR15Start (.inl ()) = 1 := by
  rw [srSplitLabels_left]; decide
example : srSplitLabels srR15Start (.inr (.inl ())) = 2 := by
  rw [srSplitLabels_right]; decide
example : srSplitLabels srR15Start (.inr (.inr ())) = 0 := by
  rw [srSplitLabels_keep]; decide

example (q : sfRatio) :
    sfPpmIndex (sfRThree q) (0 : Fin 3) (2 : Fin 3) sfRMergeLt
      (srSplitLabels srR15Start (.inl ())) = (1 : Fin 2) ∧
    sfPpmIndex (sfRThree q) (0 : Fin 3) (2 : Fin 3) sfRMergeLt
      (srSplitLabels srR15Start (.inr (.inl ()))) = (0 : Fin 2) ∧
    sfPpmIndex (sfRThree q) (0 : Fin 3) (2 : Fin 3) sfRMergeLt
      (srSplitLabels srR15Start (.inr (.inr ()))) = (0 : Fin 2) := by
  simp only [srSplitLabels_left, srSplitLabels_right, srSplitLabels_keep]
  exact ⟨rfl, rfl, rfl⟩

example (q : sfRatio) :
    (sfRThree q).channel () (srSplitLabels srR15Start (.inl ())) =
      (q.val : ENNReal) * ((1 - q.val : NNReal) : ENNReal) :=
  sfRThree_one q

example (q : sfRatio) :
    (sfRThree q).channel () (srSplitLabels srR15Start (.inr (.inl ()))) =
      ((1 - q.val : NNReal) : ENNReal) * ((1 - q.val : NNReal) : ENNReal) :=
  sfRThree_two q

example (q : sfRatio) :
    (sfRThree q).channel () (srSplitLabels srR15Start (.inr (.inr ()))) =
      (q.val : ENNReal) := sfRThree_zero q

private structure srTreeResult (k : OperationKind) (S : ActiveFiniteChannel alpha)
    {R : Type v} (e : Unit ⊕ R ≃ Fin S.outputCard) (B : Type w)
    (m : alpha → B → ENNReal) where
  endpoint : ActiveFiniteChannel alpha
  path : OperationPath S endpoint
  homogeneous : path.Homogeneous k
  labels : B ⊕ R ≃ Fin endpoint.outputCard
  leaf : ∀ x b, endpoint.channel x (labels (.inl b)) = m x b
  ambient : ∀ x r, endpoint.channel x (labels (.inr r)) = S.channel x (e (.inr r))

private theorem srPpsTree (t : BinaryTree sfRatio) {R : Type v}
    (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (e : Unit ⊕ R ≃ Fin S.outputCard) :
    Nonempty (srTreeResult .pps S e (sfLeaf t)
      (fun x f => (sfCoeff t f : ENNReal) * S.channel x (e (.inl ())))) := by
  induction t generalizing R S with
  | nil =>
      refine ⟨⟨S, .nil, OperationPath.homogeneous_nil _, e, ?_, ?_⟩⟩
      · intro x f; simp [sfCoeff]
      · intro x r; rfl
  | node q l r ihl ihr =>
      let A := pps S hS (e (.inl ())) q.val q.property.1 q.property.2
      let p : OperationPath S A := OperationPath.nil.snoc
        (.pps S hS (e (.inl ())) q.val q.property.1 q.property.2)
      have hp : p.Homogeneous .pps := by
        simp [p, A, OperationPath.Homogeneous, OperationPath.allowed_snoc, OperationStep.kind]
      obtain ⟨L⟩ := ihl A (p.isSingular hS) (srSplitLabels e)
      let er := (srSwap Unit (sfLeaf l) R).trans L.labels
      obtain ⟨V⟩ := ihr L.endpoint (L.path.isSingular (p.isSingular hS)) er
      let ef := (Equiv.sumAssoc (sfLeaf l) (sfLeaf r) R).trans
        ((srSwap (sfLeaf l) (sfLeaf r) R).trans V.labels)
      refine ⟨⟨V.endpoint, (p.append L.path).append V.path, ?_, ef, ?_, ?_⟩⟩
      · exact (OperationPath.homogeneous_append _ _ _).mpr
          ⟨(OperationPath.homogeneous_append _ _ _).mpr ⟨hp, L.homogeneous⟩,
            V.homogeneous⟩
      · intro x f
        cases f with
        | inl f =>
            change V.endpoint.channel x (V.labels (.inr (.inl f))) = _
            rw [V.ambient]
            change L.endpoint.channel x (L.labels (.inl f)) = _
            rw [L.leaf]
            exact (congrArg (fun z => (sfCoeff l f : ENNReal) * z)
              (srPpsLeft S hS e q x)).trans (by
                simp only [sfCoeff, ENNReal.coe_mul]
                ac_rfl)
        | inr f =>
            change V.endpoint.channel x (V.labels (.inl f)) = _
            rw [V.leaf]
            change (sfCoeff r f : ENNReal) *
              L.endpoint.channel x (L.labels (.inr (.inl ()))) = _
            rw [L.ambient]
            exact (congrArg (fun z => (sfCoeff r f : ENNReal) * z)
              (srPpsRight S hS e q x)).trans (by
                simp only [sfCoeff, ENNReal.coe_mul]
                ac_rfl)
      · intro x a
        change V.endpoint.channel x (V.labels (.inr (.inr a))) = _
        rw [V.ambient]
        change L.endpoint.channel x (L.labels (.inr (.inr a))) = _
        rw [L.ambient]
        exact srPpsKeep S hS e q x a

omit [Finite alpha] [Nonempty alpha] in
private theorem srLegal_congr (t : BinaryTree (alpha → Bool)) {P Q : alpha → Prop}
    (h : ∀ x, P x ↔ Q x) : sfLegal P t ↔ sfLegal Q t := by
  have he : P = Q := funext (fun x => propext (h x))
  rw [he]

private theorem srVpsTree (t : BinaryTree (alpha → Bool)) {R : Type v}
    (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (e : Unit ⊕ R ≃ Fin S.outputCard)
    (legal : sfLegal (fun x => S.channel x (e (.inl ())) ≠ 0) t) :
    Nonempty (srTreeResult .vps S e (sfLeaf t)
      (fun x f => if sfRoute t x = f then S.channel x (e (.inl ())) else 0)) := by
  classical
  induction t generalizing R S with
  | nil =>
      refine ⟨⟨S, .nil, OperationPath.homogeneous_nil _, e, ?_, ?_⟩⟩
      · intro x f; cases f; simp [sfRoute]
      · intro x r; rfl
  | node mask l r ihl ihr =>
      obtain ⟨hl, hr, ll, lr⟩ := legal
      let A := vps S hS (e (.inl ())) mask hl hr
      let p : OperationPath S A := OperationPath.nil.snoc
        (.vps S hS (e (.inl ())) mask hl hr)
      have hp : p.Homogeneous .vps := by
        simp [p, A, OperationPath.Homogeneous, OperationPath.allowed_snoc, OperationStep.kind]
      have leftEq (x : alpha) : A.channel x (srSplitLabels e (.inl ())) =
          if mask x then S.channel x (e (.inl ())) else 0 := by
        dsimp only [A]
        rw [srSplitLabels_left, vps_left]
      have rightEq (x : alpha) : A.channel x (srSplitLabels e (.inr (.inl ()))) =
          if mask x then 0 else S.channel x (e (.inl ())) := by
        dsimp only [A]
        rw [srSplitLabels_right, vps_right]
      have keepEq (x : alpha) (a : R) : A.channel x (srSplitLabels e (.inr (.inr a))) =
          S.channel x (e (.inr a)) := by
        dsimp only [A]
        rw [srSplitLabels_keep, vps_keep]
        exact e.injective.ne (by simp)
      have ll' : sfLegal (fun x => A.channel x (srSplitLabels e (.inl ())) ≠ 0) l := by
        apply (srLegal_congr l (fun x => ?_)).mpr ll
        dsimp only [A]
        rw [srSplitLabels_left]
        exact vps_left_ne_zero_iff S hS (e (.inl ())) mask hl hr x
      obtain ⟨L⟩ := ihl A (p.isSingular hS) (srSplitLabels e) ll'
      let er := (srSwap Unit (sfLeaf l) R).trans L.labels
      have lr' : sfLegal (fun x => L.endpoint.channel x (er (.inl ())) ≠ 0) r := by
        apply (srLegal_congr r (fun x => ?_)).mpr lr
        change L.endpoint.channel x (L.labels (.inr (.inl ()))) ≠ 0 ↔ _
        rw [L.ambient]
        exact (congrArg (fun z : ENNReal => z ≠ 0) (rightEq x)).to_iff.trans
          (by cases mask x <;> simp)
      obtain ⟨V⟩ := ihr L.endpoint (L.path.isSingular (p.isSingular hS)) er lr'
      let ef := (Equiv.sumAssoc (sfLeaf l) (sfLeaf r) R).trans
        ((srSwap (sfLeaf l) (sfLeaf r) R).trans V.labels)
      refine ⟨⟨V.endpoint, (p.append L.path).append V.path, ?_, ef, ?_, ?_⟩⟩
      · exact (OperationPath.homogeneous_append _ _ _).mpr
          ⟨(OperationPath.homogeneous_append _ _ _).mpr ⟨hp, L.homogeneous⟩,
            V.homogeneous⟩
      · intro x f
        cases f with
        | inl f =>
            change V.endpoint.channel x (V.labels (.inr (.inl f))) = _
            rw [V.ambient]
            change L.endpoint.channel x (L.labels (.inl f)) = _
            rw [L.leaf]
            exact (congrArg (fun z => if sfRoute l x = f then z else 0)
              (leftEq x)).trans (by cases hm : mask x <;> simp [sfRoute, hm])
        | inr f =>
            change V.endpoint.channel x (V.labels (.inl f)) = _
            rw [V.leaf]
            change (if sfRoute r x = f then
              L.endpoint.channel x (L.labels (.inr (.inl ()))) else 0) = _
            rw [L.ambient]
            exact (congrArg (fun z => if sfRoute r x = f then z else 0)
              (rightEq x)).trans (by cases hm : mask x <;> simp [sfRoute, hm])
      · intro x a
        change V.endpoint.channel x (V.labels (.inr (.inr a))) = _
        rw [V.ambient]
        change L.endpoint.channel x (L.labels (.inr (.inr a))) = _
        rw [L.ambient]
        exact keepEq x a

/-- A finite layer traversal with every ambient coordinate retained. -/
private structure sfLayerResult (k : OperationKind) (S : ActiveFiniteChannel alpha)
    (R : Type v) (B : Type v₁) (ambient : R → Fin S.outputCard)
    (leafMass : B → alpha → ENNReal) where
  endpoint : ActiveFiniteChannel alpha
  path : OperationPath S endpoint
  homogeneous : path.Homogeneous k
  labels : B ⊕ R ≃ Fin endpoint.outputCard
  leaf_coordinates : ∀ b x, endpoint.channel x (labels (.inl b)) = leafMass b x
  ambient_coordinates : ∀ r x, endpoint.channel x (labels (.inr r)) = S.channel x (ambient r)

private def sfOptionRoot (I R : Type v) : Unit ⊕ (I ⊕ R) ≃ Option I ⊕ R where
  toFun
    | .inl _ => .inl none
    | .inr (.inl i) => .inl (some i)
    | .inr (.inr r) => .inr r
  invFun
    | .inl none => .inl ()
    | .inl (some i) => .inr (.inl i)
    | .inr r => .inr (.inr r)
  left_inv := by rintro (⟨⟩ | (i | r)) <;> rfl
  right_inv := by rintro ((_ | i) | r) <;> rfl

private def sfOptionLeaves (I R : Type v) (L : Option I → Type v) :
    (Σ i, L i) ⊕ R ≃ (Σ i : I, L (some i)) ⊕ (L none ⊕ R) where
  toFun
    | .inl ⟨none, l⟩ => .inr (.inl l)
    | .inl ⟨some i, l⟩ => .inl ⟨i, l⟩
    | .inr r => .inr (.inr r)
  invFun
    | .inl ⟨i, l⟩ => .inl ⟨some i, l⟩
    | .inr (.inl l) => .inl ⟨none, l⟩
    | .inr (.inr r) => .inr r
  left_inv := by rintro (⟨_ | i, l⟩ | r) <;> rfl
  right_inv := by rintro (⟨i, l⟩ | (l | r)) <;> rfl

private def sfSplitCallbacks (I : Type v) (L : I → Type v)
    (m : I → alpha → ENNReal) (w : ∀ i, L i → alpha → ENNReal) (k : OperationKind) : Prop :=
  ∀ (i : I) (A : Type v) (S : ActiveFiniteChannel alpha) (_hS : IsSingularChannel S.channel)
    (e : Unit ⊕ A ≃ Fin S.outputCard),
    (∀ x, S.channel x (e (.inl ())) = m i x) →
      Nonempty (sfLayerResult k S A (L i) (fun a => e (.inr a)) (w i))

private def sfSplitFamilySpec (I : Type v) : Prop :=
  ∀ (L : I → Type v) (m : I → alpha → ENNReal) (w : ∀ i, L i → alpha → ENNReal)
    (k : OperationKind), sfSplitCallbacks I L m w k →
    ∀ (R : Type v) (S : ActiveFiniteChannel alpha) (_hS : IsSingularChannel S.channel)
      (e : I ⊕ R ≃ Fin S.outputCard),
      (∀ i x, S.channel x (e (.inl i)) = m i x) →
        Nonempty (sfLayerResult k S R (Σ i, L i) (fun r => e (.inr r))
          (fun p => w p.1 p.2))

/-- Traverse each root of a finite family using only the supplied local split callback. -/
private theorem sfSplitFamily (I : Type v) [Finite I] : sfSplitFamilySpec (alpha := alpha) I := by
  refine Finite.induction_empty_option ?_ ?_ ?_ I
  · intro I J eIJ ih L m w k callback R S hS e hroot
    let eStart := (Equiv.sumCongr eIJ (Equiv.refl R)).trans e
    obtain ⟨d⟩ := ih (fun i => L (eIJ i)) (fun i => m (eIJ i))
      (fun i => w (eIJ i)) k (fun i => callback (eIJ i)) R S hS eStart
      (fun i => hroot (eIJ i))
    let eLeaves : (Σ i : I, L (eIJ i)) ≃ (Σ j : J, L j) := Equiv.sigmaCongrLeft eIJ
    refine ⟨{
      endpoint := d.endpoint
      path := d.path
      homogeneous := d.homogeneous
      labels := (Equiv.sumCongr eLeaves.symm (Equiv.refl R)).trans d.labels
      leaf_coordinates := ?_
      ambient_coordinates := ?_ }⟩
    · intro p x
      obtain ⟨q, rfl⟩ := eLeaves.surjective p
      simp only [Equiv.trans_apply, Equiv.sumCongr_apply, Sum.map_inl,
        Equiv.symm_apply_apply]
      change d.endpoint.channel x (d.labels (.inl q)) = w (eIJ q.1) q.2 x
      exact d.leaf_coordinates q x
    · intro r x
      exact d.ambient_coordinates r x
  · intro L m w k callback R S hS e hroot
    let z : (Σ i : PEmpty.{v + 1}, L i) ≃ PEmpty.{v + 1} :=
      { toFun := fun f => f.1
        invFun := fun i => PEmpty.elim i
        left_inv := fun f => PEmpty.elim f.1
        right_inv := fun i => PEmpty.elim i }
    refine ⟨{
      endpoint := S
      path := OperationPath.nil
      homogeneous := OperationPath.allowed_nil _
      labels := (Equiv.sumCongr z (Equiv.refl R)).trans e
      leaf_coordinates := ?_
      ambient_coordinates := ?_ }⟩
    · intro p x
      exact PEmpty.elim p.1
    · intro r x
      rfl
  · intro I _ ih L m w k callback R S hS e hroot
    let eFirst := (sfOptionRoot I R).trans e
    obtain ⟨first⟩ := callback none (I ⊕ R) S hS eFirst (hroot none)
    let eRest := (srSwap I (L none) R).trans first.labels
    have restRoots : ∀ i x, first.endpoint.channel x (eRest (.inl i)) = m (some i) x := by
      intro i x
      exact (first.ambient_coordinates (.inl i) x).trans (hroot (some i) x)
    obtain ⟨rest⟩ := ih (fun i => L (some i)) (fun i => m (some i))
      (fun i => w (some i)) k (fun i => callback (some i)) (L none ⊕ R)
      first.endpoint (first.path.isSingular hS) eRest restRoots
    refine ⟨{
      endpoint := rest.endpoint
      path := first.path.append rest.path
      homogeneous := (OperationPath.homogeneous_append _ _ _).mpr
        ⟨first.homogeneous, rest.homogeneous⟩
      labels := (sfOptionLeaves I R L).trans rest.labels
      leaf_coordinates := ?_
      ambient_coordinates := ?_ }⟩
    · rintro ⟨_ | i, l⟩ x
      · exact (rest.ambient_coordinates (.inl l) x).trans (first.leaf_coordinates l x)
      · exact rest.leaf_coordinates ⟨i, l⟩ x
    · intro r x
      exact (rest.ambient_coordinates (.inr r) x).trans (first.ambient_coordinates (.inr r) x)

private def sfGatherCallbacks (I : Type v) (L : I → Type v)
    (m : I → alpha → ENNReal) (w : ∀ i, L i → alpha → ENNReal) (k : OperationKind) : Prop :=
  ∀ (i : I) (A : Type v) (S : ActiveFiniteChannel alpha) (_hS : IsSingularChannel S.channel)
    (e : L i ⊕ A ≃ Fin S.outputCard),
    (∀ l x, S.channel x (e (.inl l)) = w i l x) →
      Nonempty (sfLayerResult k S A Unit (fun a => e (.inr a)) (fun _ => m i))

private def sfGatherFamilySpec (I : Type v) : Prop :=
  ∀ (L : I → Type v) (m : I → alpha → ENNReal) (w : ∀ i, L i → alpha → ENNReal)
    (k : OperationKind), sfGatherCallbacks I L m w k →
    ∀ (R : Type v) (S : ActiveFiniteChannel alpha) (_hS : IsSingularChannel S.channel)
      (e : (Σ i, L i) ⊕ R ≃ Fin S.outputCard),
      (∀ i l x, S.channel x (e (.inl ⟨i, l⟩)) = w i l x) →
        Nonempty (sfLayerResult k S R I (fun r => e (.inr r)) m)

/-- Gather each member of a finite leaf family using only the supplied local callback. -/
private theorem sfGatherFamily (I : Type v) [Finite I] :
    sfGatherFamilySpec (alpha := alpha) I := by
  refine Finite.induction_empty_option ?_ ?_ ?_ I
  · intro I J eIJ ih L m w k callback R S hS e hleaf
    let eLeaves : (Σ i : I, L (eIJ i)) ≃ (Σ j : J, L j) := Equiv.sigmaCongrLeft eIJ
    let eStart := (Equiv.sumCongr eLeaves (Equiv.refl R)).trans e
    obtain ⟨d⟩ := ih (fun i => L (eIJ i)) (fun i => m (eIJ i))
      (fun i => w (eIJ i)) k (fun i => callback (eIJ i)) R S hS eStart
      (fun i => hleaf (eIJ i))
    refine ⟨{
      endpoint := d.endpoint
      path := d.path
      homogeneous := d.homogeneous
      labels := (Equiv.sumCongr eIJ.symm (Equiv.refl R)).trans d.labels
      leaf_coordinates := ?_
      ambient_coordinates := ?_ }⟩
    · intro j x
      obtain ⟨i, rfl⟩ := eIJ.surjective j
      simpa only [Equiv.trans_apply, Equiv.sumCongr_apply, Sum.map_inl,
        Equiv.symm_apply_apply] using d.leaf_coordinates i x
    · intro r x
      exact d.ambient_coordinates r x
  · intro L m w k callback R S hS e hleaf
    let z : (Σ i : PEmpty.{v + 1}, L i) ≃ PEmpty.{v + 1} :=
      { toFun := fun f => f.1
        invFun := fun i => PEmpty.elim i
        left_inv := fun f => PEmpty.elim f.1
        right_inv := fun i => PEmpty.elim i }
    refine ⟨{
      endpoint := S
      path := OperationPath.nil
      homogeneous := OperationPath.allowed_nil _
      labels := (Equiv.sumCongr z.symm (Equiv.refl R)).trans e
      leaf_coordinates := ?_
      ambient_coordinates := ?_ }⟩
    · intro i x
      exact PEmpty.elim i
    · intro r x
      rfl
  · intro I _ ih L m w k callback R S hS e hleaf
    let eFirst := (srSwap (Σ i : I, L (some i)) (L none) R).symm.trans
      ((sfOptionLeaves I R L).symm.trans e)
    obtain ⟨first⟩ := callback none ((Σ i : I, L (some i)) ⊕ R) S hS eFirst
      (fun l => hleaf none l)
    let eRest := (srSwap (Σ i : I, L (some i)) Unit R).trans first.labels
    have restLeaves : ∀ i l x,
        first.endpoint.channel x (eRest (.inl ⟨i, l⟩)) = w (some i) l x := by
      intro i l x
      exact (first.ambient_coordinates (.inl ⟨i, l⟩) x).trans (hleaf (some i) l x)
    obtain ⟨rest⟩ := ih (fun i => L (some i)) (fun i => m (some i))
      (fun i => w (some i)) k (fun i => callback (some i)) (Unit ⊕ R)
      first.endpoint (first.path.isSingular hS) eRest restLeaves
    refine ⟨{
      endpoint := rest.endpoint
      path := first.path.append rest.path
      homogeneous := (OperationPath.homogeneous_append _ _ _).mpr
        ⟨first.homogeneous, rest.homogeneous⟩
      labels := (sfOptionRoot I R).symm.trans
        ((srSwap I Unit R).symm.trans rest.labels)
      leaf_coordinates := ?_
      ambient_coordinates := ?_ }⟩
    · rintro (_ | i) x
      · exact (rest.ambient_coordinates (.inl ()) x).trans (first.leaf_coordinates () x)
      · exact rest.leaf_coordinates i x
    · intro r x
      exact (rest.ambient_coordinates (.inr r) x).trans (first.ambient_coordinates (.inr r) x)


private theorem sgIndex_retained (S : ActiveFiniteChannel alpha)
    (a b : Fin S.outputCard) (hab : a < b) (j : Fin (S.outputCard - 1)) :
    sfPpmIndex S a b hab (activeMergeRetained S b j) = j := by
  simp only [sfPpmIndex, activeMergeRetained_source, mergeIndex_succAbove]

private def sgMergeLabels {R : Type v} (S : ActiveFiniteChannel alpha)
    (e : Unit ⊕ (Unit ⊕ R) ≃ Fin S.outputCard)
    (hab : e (.inl ()) < e (.inr (.inl ()))) : Unit ⊕ R ≃ Fin (S.outputCard - 1) := by
  let a := e (.inl ())
  let b := e (.inr (.inl ()))
  let f : Unit ⊕ R → Fin (S.outputCard - 1) := Sum.elim
    (fun _ => activeMergeSurvivor S a b hab)
    (fun r => sfPpmIndex S a b hab (e (.inr (.inr r))))
  have hn (r : R) : f (.inr r) ≠ activeMergeSurvivor S a b hab := by
    intro h
    rcases (sfPpmIndex_survivor S a b hab _).mp h with h | h
    · exact Sum.inr_ne_inl (e.injective h)
    · exact Sum.inr_ne_inl (Sum.inr.inj (e.injective h))
  refine Equiv.ofBijective f ⟨?_, ?_⟩
  · intro i j hij
    rcases i with ⟨⟩ | i <;> rcases j with ⟨⟩ | j
    · rfl
    · exact False.elim (hn j hij.symm)
    · exact False.elim (hn i hij)
    · have he : e (.inr (.inr i)) = e (.inr (.inr j)) :=
        ((sfPpmIndex_retained S a b hab (f (.inr j)) (hn j) _).mp hij).trans
          ((sfPpmIndex_retained S a b hab (f (.inr j)) (hn j) _).mp rfl).symm
      exact congrArg Sum.inr (Sum.inr.inj (Sum.inr.inj (e.injective he)))
  · intro j
    by_cases hj : j = activeMergeSurvivor S a b hab
    · exact ⟨.inl (), hj.symm⟩
    · obtain ⟨k, hk⟩ := e.surjective (activeMergeRetained S b j)
      have hh := (congrArg (sfPpmIndex S a b hab) hk).trans (sgIndex_retained S a b hab j)
      rcases k with ⟨⟩ | ⟨⟨⟩ | r⟩
      · exact False.elim (hj (hh.symm.trans
          ((sfPpmIndex_survivor S a b hab a).mpr (Or.inl rfl))))
      · exact False.elim (hj (hh.symm.trans
          ((sfPpmIndex_survivor S a b hab b).mpr (Or.inr rfl))))
      · exact ⟨.inr r, hh⟩

private structure sgMergeResult {R : Type v} (S : ActiveFiniteChannel alpha)
    (e : Unit ⊕ (Unit ⊕ R) ≃ Fin S.outputCard) where
  endpoint : ActiveFiniteChannel alpha
  path : OperationPath S endpoint
  homogeneous : path.Homogeneous .ppm
  labels : Unit ⊕ R ≃ Fin endpoint.outputCard
  root_coordinates : ∀ x, endpoint.channel x (labels (.inl ())) =
    S.channel x (e (.inl ())) + S.channel x (e (.inr (.inl ())))
  retained_coordinates : ∀ x r, endpoint.channel x (labels (.inr r)) =
    S.channel x (e (.inr (.inr r)))

private def sgMergeOrdered {R : Type v} (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (e : Unit ⊕ (Unit ⊕ R) ≃ Fin S.outputCard)
    (hab : e (.inl ()) < e (.inr (.inl ())))
    (hp : ∀ x, S.channel x (e (.inl ())) ≠ 0 ↔
      S.channel x (e (.inr (.inl ()))) ≠ 0) : sgMergeResult S e where
  endpoint := ppm S hS _ _ hab hp
  path := OperationPath.nil.snoc (.ppm S hS _ _ hab hp)
  homogeneous := by simp [OperationPath.Homogeneous, OperationStep.kind]
  labels := sgMergeLabels S e hab
  root_coordinates x := ppm_apply_survivor S hS _ _ hab hp x
  retained_coordinates x r := by
    have hn : sgMergeLabels S e hab (.inr r) ≠
        activeMergeSurvivor S (e (.inl ())) (e (.inr (.inl ()))) hab := by
      have hr : sgMergeLabels S e hab (.inl ()) =
          activeMergeSurvivor S (e (.inl ())) (e (.inr (.inl ()))) hab := rfl
      rw [← hr]
      exact (sgMergeLabels S e hab).injective.ne (by simp)
    exact (ppm_apply_unaffected S hS _ _ hab hp x hn).trans
      (congrArg (S.channel x)
        ((sfPpmIndex_retained S _ _ hab _ hn (e (.inr (.inr r)))).mp rfl).symm)

private def sgMerge {R : Type v} (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (e : Unit ⊕ (Unit ⊕ R) ≃ Fin S.outputCard)
    (hp : ∀ x, S.channel x (e (.inl ())) ≠ 0 ↔
      S.channel x (e (.inr (.inl ()))) ≠ 0) : sgMergeResult S e := by
  by_cases hab : e (.inl ()) < e (.inr (.inl ()))
  · exact sgMergeOrdered S hS e hab hp
  · have hba : e (.inr (.inl ())) < e (.inl ()) :=
      lt_of_le_of_ne (le_of_not_gt hab) (fun h => Sum.inr_ne_inl (e.injective h))
    let q := sgMergeOrdered S hS ((srSwap Unit Unit R).trans e) hba (fun x => (hp x).symm)
    exact ⟨q.endpoint, q.path, q.homogeneous, q.labels,
      fun x => (q.root_coordinates x).trans (add_comm _ _), q.retained_coordinates⟩

private def sgR15Labels : Unit ⊕ (Unit ⊕ Unit) ≃ Fin 3 where
  toFun := Sum.elim (fun _ => 0) (Sum.elim (fun _ => 2) (fun _ => 1))
  invFun j := if j = 0 then .inl () else
    if j = 2 then .inr (.inl ()) else .inr (.inr ())
  left_inv j := by
    rcases j with a | b
    · cases a; decide
    · rcases b with b | r
      · cases b; decide
      · cases r; decide
  right_inv j := by
    by_cases h0 : j = 0
    · subst j; decide
    · by_cases h2 : j = 2
      · subst j; decide
      · have h1 : j = 1 := by apply Fin.ext; omega
        subst j
        decide

private def sgR15Merge (q : sfRatio) : sgMergeResult (sfRThree q) sgR15Labels :=
  sgMergeOrdered (sfRThree q) (sfRThree_singular q) sgR15Labels
    (by decide : (0 : Fin 3) < 2)
    (fun x => iff_of_true (by cases x; exact sfRActive _ _)
      (by cases x; exact sfRActive _ _))

example : sgR15Labels (.inl ()) = (0 : Fin 3) ∧
    sgR15Labels (.inr (.inl ())) = (2 : Fin 3) ∧
      sgR15Labels (.inr (.inr ())) = (1 : Fin 3) := ⟨rfl, rfl, rfl⟩

example (q : sfRatio) : (sgR15Merge q).path.tags = [.ppm] := rfl

example (q : sfRatio) : (sgR15Merge q).labels (.inl ()) = (0 : Fin 2) := by
  apply Fin.ext
  exact activeMergeSurvivor_val (sfRThree q) (0 : Fin 3) (2 : Fin 3)
    (by exact (by decide : (0 : Fin 3) < 2))

example (q : sfRatio) : (sgR15Merge q).labels (.inr ()) = (1 : Fin 2) := rfl

example (q : sfRatio) :
    (sgR15Merge q).endpoint.channel () ((sgR15Merge q).labels (.inl ())) =
      (q.val : ENNReal) +
        ((1 - q.val : NNReal) : ENNReal) * ((1 - q.val : NNReal) : ENNReal) :=
  ((sgR15Merge q).root_coordinates ()).trans
    (congrArg₂ (· + ·) (sfRThree_zero q) (sfRThree_two q))

example (q : sfRatio) :
    (sgR15Merge q).endpoint.channel () ((sgR15Merge q).labels (.inr ())) =
      (q.val : ENNReal) * ((1 - q.val : NNReal) : ENNReal) :=
  ((sgR15Merge q).retained_coordinates () ()).trans (sfRThree_one q)

private structure sgTreeResult {R : Type v} (S : ActiveFiniteChannel alpha)
    (t : BinaryTree Unit) (mass : sfLeaf t → alpha → ENNReal)
    (e : sfLeaf t ⊕ R ≃ Fin S.outputCard) where
  endpoint : ActiveFiniteChannel alpha
  path : OperationPath S endpoint
  homogeneous : path.Homogeneous .ppm
  labels : Unit ⊕ R ≃ Fin endpoint.outputCard
  root_coordinates : ∀ x, endpoint.channel x (labels (.inl ())) = ∑ f, mass f x
  retained_coordinates : ∀ x r, endpoint.channel x (labels (.inr r)) =
    S.channel x (e (.inr r))

private theorem sgGatherTree (t : BinaryTree Unit) :
    ∀ (mass : sfLeaf t → alpha → ENNReal) (P : alpha → Prop),
      sfGatherLegal P t mass → ∀ {R : Type v} (S : ActiveFiniteChannel alpha),
        IsSingularChannel S.channel → ∀ (e : sfLeaf t ⊕ R ≃ Fin S.outputCard),
          (∀ x f, S.channel x (e (.inl f)) = mass f x) →
            Nonempty (sgTreeResult S t mass e) := by
  induction t with
  | nil =>
      intro mass P legal R S hS e coordinates
      exact ⟨{
        endpoint := S
        path := OperationPath.nil
        homogeneous := OperationPath.homogeneous_nil .ppm
        labels := e
        root_coordinates := fun x => by simpa using coordinates x ()
        retained_coordinates := fun _ _ => rfl }⟩
  | node a left right ihLeft ihRight =>
      intro mass P legal R S hS e coordinates
      let eLeft := (Equiv.sumAssoc (sfLeaf left) (sfLeaf right) R).symm.trans e
      obtain ⟨dLeft⟩ := ihLeft (fun f => mass (.inl f)) P legal.2.2.1 S hS eLeft
        (fun x f => coordinates x (.inl f))
      let eRight := (srSwap (sfLeaf right) Unit R).trans dLeft.labels
      obtain ⟨dRight⟩ := ihRight (fun f => mass (.inr f)) P legal.2.2.2 dLeft.endpoint
        (dLeft.path.isSingular hS) eRight (fun x f =>
          (dLeft.retained_coordinates x (.inl f)).trans (coordinates x (.inr f)))
      have hLeft (x : alpha) :
          dRight.endpoint.channel x (dRight.labels (.inr (.inl ()))) =
            ∑ f : sfLeaf left, mass (.inl f) x :=
        (dRight.retained_coordinates x (.inl ())).trans (dLeft.root_coordinates x)
      let eMerge := (srSwap Unit Unit R).trans dRight.labels
      have hp (x : alpha) :
          dRight.endpoint.channel x (eMerge (.inl ())) ≠ 0 ↔
            dRight.endpoint.channel x (eMerge (.inr (.inl ()))) ≠ 0 :=
        ((congrArg (fun z : ENNReal => z ≠ 0) (hLeft x)).to_iff.trans
          ((legal.1 x).trans (legal.2.1 x).symm)).trans
            (congrArg (fun z : ENNReal => z ≠ 0) (dRight.root_coordinates x)).to_iff.symm
      let merged := sgMerge dRight.endpoint
        (dRight.path.isSingular (dLeft.path.isSingular hS)) eMerge hp
      exact ⟨{
        endpoint := merged.endpoint
        path := (dLeft.path.append dRight.path).append merged.path
        homogeneous := (OperationPath.homogeneous_append _ _ _).mpr
          ⟨(OperationPath.homogeneous_append _ _ _).mpr
            ⟨dLeft.homogeneous, dRight.homogeneous⟩, merged.homogeneous⟩
        labels := merged.labels
        root_coordinates := fun x => (merged.root_coordinates x).trans
          ((congrArg₂ (· + ·) (hLeft x) (dRight.root_coordinates x)).trans
            (Fintype.sum_sum_type (fun f => mass f x)).symm)
        retained_coordinates := fun x r => (merged.retained_coordinates x r).trans
          ((dRight.retained_coordinates x (.inr r)).trans
            (dLeft.retained_coordinates x (.inr r))) }⟩

private theorem FactorizationCertificate.realize {S T : ActiveFiniteChannel alpha}
    (c : FactorizationCertificate S T) (hS : IsSingularChannel S.channel) :
    Nonempty (NormalForm S T) := by
  let sheetMass (i : Fin S.outputCard) (f : sfLeaf (c.forest.outer i)) (x : alpha) :=
    (sfCoeff (c.forest.outer i) f : ENNReal) * S.channel x i
  have cbP : sfSplitCallbacks (Fin S.outputCard) (fun i => sfLeaf (c.forest.outer i))
      (fun i x => S.channel x i) sheetMass .pps := by
    intro i R U hU e he
    obtain ⟨d⟩ := srPpsTree (c.forest.outer i) U hU e
    refine ⟨⟨d.endpoint, d.path, d.homogeneous, d.labels, ?_, ?_⟩⟩
    · intro f x
      exact (d.leaf x f).trans
        (congrArg (fun z => (sfCoeff (c.forest.outer i) f : ENNReal) * z) (he x))
    · intro r x; exact d.ambient x r
  obtain ⟨PP⟩ := sfSplitFamily (Fin S.outputCard) (fun i => sfLeaf (c.forest.outer i))
    (fun i x => S.channel x i) sheetMass .pps cbP Empty S hS
      (Equiv.sumEmpty _ Empty) (fun _ _ => rfl)
  let Sheet := Σ i, sfLeaf (c.forest.outer i)
  let pieces (s : Sheet) := sfLeaf (c.forest.support s.1 s.2)
  let pieceMass (s : Sheet) (f : pieces s) (x : alpha) :=
    if sfRoute (c.forest.support s.1 s.2) x = f then sheetMass s.1 s.2 x else 0
  have cbV : sfSplitCallbacks Sheet pieces (fun s => sheetMass s.1 s.2) pieceMass .vps := by
    intro s R U hU e he
    have hl : sfLegal (fun x => U.channel x (e (.inl ())) ≠ 0)
        (c.forest.support s.1 s.2) := by
      apply (srLegal_congr _ (fun x => ?_)).mpr (c.forest.support_legal s.1 s.2)
      rw [he x]
      simp [sheetMass, ne_of_gt (sfCoeff_pos (c.forest.outer s.1) s.2)]
    obtain ⟨d⟩ := srVpsTree (c.forest.support s.1 s.2) U hU e hl
    refine ⟨⟨d.endpoint, d.path, d.homogeneous, d.labels, ?_, ?_⟩⟩
    · intro f x
      exact (d.leaf x f).trans
        (congrArg (fun z => if sfRoute (c.forest.support s.1 s.2) x = f then z else 0) (he x))
    · intro r x; exact d.ambient x r
  obtain ⟨VP⟩ := sfSplitFamily Sheet pieces (fun s => sheetMass s.1 s.2) pieceMass
    .vps cbV Empty PP.endpoint (PP.path.isSingular hS) PP.labels PP.leaf_coordinates
  let flatten : (Σ s : Sheet, pieces s) ≃ c.forest.Fragment :=
    Equiv.sigmaAssoc (fun i w => sfLeaf (c.forest.support i w))
  let gatherMass (j : Fin T.outputCard) (f : sfLeaf (c.gather j)) (x : alpha) :=
    c.forest.mass x (c.leaves j f).val
  have cbM : sfGatherCallbacks (Fin T.outputCard) (fun j => sfLeaf (c.gather j))
      (fun j x => T.channel x j) gatherMass .ppm := by
    intro j R U hU e he
    obtain ⟨d⟩ := sgGatherTree (c.gather j) (gatherMass j) (fun x => T.channel x j ≠ 0)
      (c.gather_legal hS j) U hU e (fun x f => he f x)
    refine ⟨⟨d.endpoint, d.path, d.homogeneous, d.labels, ?_, ?_⟩⟩
    · intro f x; cases f
      exact (d.root_coordinates x).trans (c.root_coordinates x j).symm
    · intro r x; exact d.retained_coordinates x r
  let eg := (Equiv.sumCongr (c.matchLeaves.trans flatten.symm) (Equiv.refl Empty)).trans VP.labels
  have hgl : ∀ j f x, VP.endpoint.channel x (eg (.inl ⟨j, f⟩)) = gatherMass j f x := by
    intro j f x
    exact VP.leaf_coordinates (flatten.symm (c.matchLeaves ⟨j, f⟩)) x
  obtain ⟨PM⟩ := sfGatherFamily (Fin T.outputCard) (fun j => sfLeaf (c.gather j))
    (fun j x => T.channel x j) gatherMass .ppm cbM Empty VP.endpoint
      (VP.path.isSingular (PP.path.isSingular hS)) eg hgl
  let eo : Fin T.outputCard ≃ Fin PM.endpoint.outputCard :=
    (Equiv.sumEmpty _ Empty).symm.trans PM.labels
  have ho : OutputEquiv PM.endpoint T := OutputEquiv.ofCoordinates eo.symm (by
    intro x y
    obtain ⟨j, rfl⟩ := eo.surjective y
    simp only [Equiv.symm_apply_apply]
    exact (PM.leaf_coordinates j x).symm)
  exact ⟨⟨PP.endpoint, VP.endpoint, PM.endpoint, PP.path, VP.path, PM.path,
    PP.homogeneous, VP.homogeneous, PM.homogeneous, ho⟩⟩
-- Here normalization means reordering into PPS/VPS/PPM normal form, not rescaling probabilities.
namespace OperationPath

/-- Lemma 4: every allowed concrete cascade from an active singular source has
three homogeneous blocks, ending at the supplied endpoint up to an output bijection. -/
theorem normalize {S T : ActiveFiniteChannel alpha} (p : OperationPath S T)
    (hS : IsSingularChannel S.channel) (hp : p.Normalizing) : Nonempty (NormalForm S T) :=
  (FactorizationCertificate.ofPath p hp).realize hS

end OperationPath

namespace Cascade

/-- Normalize the concrete path and compose its final directed comparison. -/
theorem normalize {S T : ActiveFiniteChannel alpha} (c : Cascade S T)
    (hS : IsSingularChannel S.channel) (hp : c.path.Normalizing) : Nonempty (NormalForm S T) := by
  obtain ⟨nf⟩ := c.path.normalize hS hp
  exact ⟨nf.transOutputEquiv c.outputEquiv⟩

end Cascade

end
end PerfectFunctionalRepresentations.MatrixOperations
