import PerfectFunctionalRepresentations.Matrix.OperationPaths
import PerfectFunctionalRepresentations.Matrix.Partitions
import Mathlib.Algebra.BigOperators.Field
import Mathlib.Data.Fintype.Option

/-!
# Finite families of matrix operations

The primitive split operations are binary. Finite synthesis retains the actual
operation path and an explicit correspondence between supplied labels and every
output coordinate. Positive normalized weights are realized by strict binary
PPS ratios, with a zero-length path for a singleton family.
Exact finite partitions are realized by VPS paths, retaining each supplied
nonempty block and the selected column value, including one.
Prescribed equal-pattern groups are realized by PPM paths, with exact aggregate
values and complete labels; empty selections retain the original state.
-/

namespace PerfectFunctionalRepresentations.MatrixOperations

open scoped BigOperators ENNReal

noncomputable section
attribute [local instance] Classical.propDecidable

universe u v w
variable {alpha : Type u} [Finite alpha] [Nonempty alpha]

/-- A homogeneous operation path with a complete labelled endpoint and exact
coordinates. The path and its specification belong to the same returned data. -/
structure LabelledOperationResult (k : OperationKind) (S : ActiveFiniteChannel alpha)
    (L : Type v) (mass : alpha → L → ENNReal) where
  endpoint : ActiveFiniteChannel alpha
  path : OperationPath S endpoint
  homogeneous : path.Homogeneous k
  labels : L ≃ Fin endpoint.outputCard
  coordinates : ∀ x l, endpoint.channel x (labels l) = mass x l

private def ppUnitOption (R : Type w) : Unit ⊕ R ≃ Option R where
  toFun := Sum.elim (fun _ => none) some
  invFun := fun o => o.elim (Sum.inl ()) Sum.inr
  left_inv x := by rcases x with ⟨⟩ | r <;> rfl
  right_inv x := by cases x <;> rfl

/-- The new right child is the recursive root; the left child is retained. -/
private def ppSplitLabels {R : Type w} {n : Nat} (e : Unit ⊕ R ≃ Fin n) :
    Unit ⊕ (Unit ⊕ R) ≃ Fin (n + 1) :=
  (ppUnitOption (Unit ⊕ R)).trans ((Equiv.optionCongr e).trans
    (finSuccEquiv' (splitRight (e (.inl ())))).symm)

private theorem ppSplitLabels_right {R : Type w} {n : Nat}
    (e : Unit ⊕ R ≃ Fin n) :
    ppSplitLabels e (.inl ()) = splitRight (e (.inl ())) :=
  finSuccEquiv'_symm_none _

private theorem ppSplitLabels_left {R : Type w} {n : Nat}
    (e : Unit ⊕ R ≃ Fin n) :
    ppSplitLabels e (.inr (.inl ())) = splitLeft (e (.inl ())) := by
  change (finSuccEquiv' (splitRight (e (.inl ())))).symm (some (e (.inl ()))) = _
  rw [finSuccEquiv'_symm_some]
  exact splitKeep_self _

private theorem ppSplitLabels_keep {R : Type w} {n : Nat}
    (e : Unit ⊕ R ≃ Fin n) (r : R) :
    ppSplitLabels e (.inr (.inr r)) = splitKeep (e (.inl ())) (e (.inr r)) :=
  finSuccEquiv'_symm_some _ _

private def ppOptionLabels (I : Type v) (R : Type w) :
    Option I ⊕ R ≃ I ⊕ (Unit ⊕ R) where
  toFun
    | .inl none => .inr (.inl ())
    | .inl (some i) => .inl i
    | .inr r => .inr (.inr r)
  invFun
    | .inl i => .inl (some i)
    | .inr (.inl _) => .inl none
    | .inr (.inr r) => .inr r
  left_inv x := by rcases x with (_ | i) | r <;> rfl
  right_inv x := by rcases x with i | ⟨⟩ | r <;> rfl

private def ppsCoreSpec (I : Type v) [Fintype I] : Prop :=
  ∀ (weights : I → NNReal), (∀ i, 0 < weights i) → (∑ i, weights i) = 1 →
    ∀ (R : Type w) (S : ActiveFiniteChannel alpha) (_hS : IsSingularChannel S.channel)
      (e : Unit ⊕ R ≃ Fin S.outputCard),
      Nonempty (LabelledOperationResult .pps S (I ⊕ R)
        (fun x => Sum.elim
          (fun i => (weights i : ENNReal) * S.channel x (e (.inl ())))
          (fun r => S.channel x (e (.inr r)))))

private theorem multiPpsCore_exists (I : Type v) [Fintype I] :
    ppsCoreSpec.{u, v, w} (alpha := alpha) I := by
  refine Fintype.induction_empty_option
    (P := fun I _ => ppsCoreSpec.{u, v, w} (alpha := alpha) I) ?_ ?_ ?_ I
  · intro I J _ e ih weights hpos hsum R S hS start
    let := Fintype.ofEquiv J e.symm
    obtain ⟨d⟩ := ih (fun i => weights (e i)) (fun i => hpos (e i))
      ((e.sum_comp weights).trans hsum) R S hS start
    refine ⟨⟨d.endpoint, d.path, d.homogeneous,
      (Equiv.sumCongr e.symm (Equiv.refl R)).trans d.labels, ?_⟩⟩
    intro x b
    cases b with
    | inl j =>
        change d.endpoint.channel x (d.labels (.inl (e.symm j))) = _
        simpa only [Sum.elim_inl, Equiv.apply_symm_apply] using
          d.coordinates x (.inl (e.symm j))
    | inr r => exact d.coordinates x (.inr r)
  · intro weights _ hsum
    simp at hsum
  · intro I _ ih weights hpos hsum R S hS e
    by_cases hI : Nonempty I
    · let := hI
      let residual := ∑ i, weights (some i)
      have hresidual : 0 < residual := by
        obtain ⟨i⟩ := hI
        exact lt_of_lt_of_le (hpos (some i))
          (Finset.single_le_sum (fun j _ => (show 0 ≤ weights (some j) from bot_le))
            (Finset.mem_univ i))
      have hsplit : weights none + residual = 1 := by
        simpa only [Fintype.sum_option] using hsum
      have hlt : weights none < 1 := by
        rw [← hsplit]
        exact lt_add_of_pos_right _ hresidual
      have hcomplement : 1 - weights none = residual := by
        rw [← hsplit, add_tsub_cancel_left]
      let restWeights := fun i => weights (some i) / residual
      have hrestPos : ∀ i, 0 < restWeights i := fun i => div_pos (hpos (some i)) hresidual
      have hrestSum : ∑ i, restWeights i = 1 := by
        dsimp only [restWeights]
        rw [← Finset.sum_div, div_self (ne_of_gt hresidual)]
      let A := pps S hS (e (.inl ())) (weights none) (hpos none) hlt
      let first : OperationPath S A := OperationPath.nil.snoc
        (.pps S hS (e (.inl ())) (weights none) (hpos none) hlt)
      have hfirst : first.Homogeneous .pps := by
        simp [first, A, OperationPath.Homogeneous, OperationStep.kind]
      obtain ⟨rest⟩ := ih restWeights hrestPos hrestSum (Unit ⊕ R) A
        (first.isSingular hS) (ppSplitLabels e)
      have hright (x : alpha) : A.channel x (ppSplitLabels e (.inl ())) =
          (residual : ENNReal) * S.channel x (e (.inl ())) := by
        dsimp only [A]
        rw [ppSplitLabels_right, pps_right, hcomplement]
      have hleft (x : alpha) : A.channel x (ppSplitLabels e (.inr (.inl ()))) =
          (weights none : ENNReal) * S.channel x (e (.inl ())) := by
        dsimp only [A]
        rw [ppSplitLabels_left, pps_left]
      have hkeep (x : alpha) (r : R) : A.channel x (ppSplitLabels e (.inr (.inr r))) =
          S.channel x (e (.inr r)) := by
        dsimp only [A]
        rw [ppSplitLabels_keep, pps_keep]
        exact e.injective.ne (by simp)
      refine ⟨⟨rest.endpoint, first.append rest.path,
        (OperationPath.homogeneous_append _ _ _).mpr ⟨hfirst, rest.homogeneous⟩,
        (ppOptionLabels I R).trans rest.labels, ?_⟩⟩
      intro x b
      rcases b with (_ | i) | r
      · exact (rest.coordinates x (.inr (.inl ()))).trans (hleft x)
      · change rest.endpoint.channel x (rest.labels (.inl i)) = _
        rw [rest.coordinates]
        change (↑(restWeights i) : ENNReal) * A.channel x (ppSplitLabels e (.inl ())) = _
        rw [hright]
        dsimp only [restWeights]
        rw [← mul_assoc, ← ENNReal.coe_mul, div_mul_cancel₀ _ (ne_of_gt hresidual)]
        rfl
      · exact (rest.coordinates x (.inr (.inr r))).trans (hkeep x r)
    · let : IsEmpty I := not_nonempty_iff.mp hI
      have hone : weights none = 1 := by
        rw [Fintype.sum_option] at hsum
        simpa using hsum
      let labels := (Equiv.sumCongr (Equiv.ofUnique (Option I) Unit) (Equiv.refl R)).trans e
      refine ⟨⟨S, .nil, OperationPath.homogeneous_nil _, labels, ?_⟩⟩
      intro x b
      rcases b with (_ | i) | r
      · change S.channel x (e (.inl ())) = (weights none : ENNReal) * S.channel x (e (.inl ()))
        rw [hone, ENNReal.coe_one, one_mul]
      · exact isEmptyElim i
      · rfl

private def multiPpsCore {I : Type v} [Fintype I] {R : Type w}
    (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (e : Unit ⊕ R ≃ Fin S.outputCard) (weights : I → NNReal)
    (hpos : ∀ i, 0 < weights i) (hsum : ∑ i, weights i = 1) :
    LabelledOperationResult .pps S (I ⊕ R)
      (fun x => Sum.elim
        (fun i => (weights i : ENNReal) * S.channel x (e (.inl ())))
        (fun r => S.channel x (e (.inr r)))) :=
  Classical.choice (multiPpsCore_exists.{u, v, w} I weights hpos hsum R S hS e)

private def ppInitialLabels {n : Nat} (l : Fin n) :
    Unit ⊕ {j : Fin n // j ≠ l} ≃ Fin n :=
  (ppUnitOption _).trans (Equiv.optionSubtypeNe l)

/-- Split one admitted column into an arbitrary finite positive normalized
family by actual binary PPS operations, retaining every unaffected output. -/
def multiPps (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) {I : Type v} [Fintype I] (weights : I → NNReal)
    (hpos : ∀ i, 0 < weights i) (hsum : ∑ i, weights i = 1) :
    LabelledOperationResult .pps S (I ⊕ {j : Fin S.outputCard // j ≠ l})
      (fun x => Sum.elim (fun i => (weights i : ENNReal) * S.channel x l)
        (fun j => S.channel x j.val)) :=
  multiPpsCore S hS (ppInitialLabels l) weights hpos hsum

private def mwSwap (A B R : Type v) : A ⊕ (B ⊕ R) ≃ B ⊕ (A ⊕ R) :=
  (Equiv.sumAssoc A B R).symm.trans
    ((Equiv.sumCongr (Equiv.sumComm A B) (Equiv.refl R)).trans (Equiv.sumAssoc B A R))

private def mwOptionRoot (I R : Type v) : Unit ⊕ (I ⊕ R) ≃ Option I ⊕ R where
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

private def mwOptionLeaves (I R : Type v) (L : Option I → Type v) :
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

private def mwSplitCallbacks (I : Type v) (L : I → Type v)
    (m : I → alpha → ENNReal) (w : ∀ i, L i → alpha → ENNReal) (k : OperationKind) : Prop :=
  ∀ (i : I) (A : Type v) (S : ActiveFiniteChannel alpha) (_hS : IsSingularChannel S.channel)
    (e : Unit ⊕ A ≃ Fin S.outputCard),
    (∀ x, S.channel x (e (.inl ())) = m i x) →
      Nonempty (LabelledOperationResult k S (L i ⊕ A)
        (fun x => Sum.elim (fun l => w i l x) (fun a => S.channel x (e (.inr a)))))

private def mwSplitFamilySpec (I : Type v) : Prop :=
  ∀ (L : I → Type v) (m : I → alpha → ENNReal) (w : ∀ i, L i → alpha → ENNReal)
    (k : OperationKind), mwSplitCallbacks I L m w k →
    ∀ (R : Type v) (S : ActiveFiniteChannel alpha) (_hS : IsSingularChannel S.channel)
      (e : I ⊕ R ≃ Fin S.outputCard),
      (∀ i x, S.channel x (e (.inl i)) = m i x) →
        Nonempty (LabelledOperationResult k S ((Σ i, L i) ⊕ R)
          (fun x => Sum.elim (fun p => w p.1 p.2 x) (fun r => S.channel x (e (.inr r)))))

private theorem mwSplitFamily (I : Type v) [Finite I] : mwSplitFamilySpec (alpha := alpha) I := by
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
      coordinates := ?_ }⟩
    intro x l
    rcases l with p | r
    · obtain ⟨q, rfl⟩ := eLeaves.surjective p
      simp only [Equiv.trans_apply, Equiv.sumCongr_apply, Sum.map_inl,
        Equiv.symm_apply_apply]
      exact d.coordinates x (.inl q)
    · exact d.coordinates x (.inr r)
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
      coordinates := ?_ }⟩
    intro x l
    rcases l with p | r
    · exact PEmpty.elim p.1
    · rfl
  · intro I _ ih L m w k callback R S hS e hroot
    let eFirst := (mwOptionRoot I R).trans e
    obtain ⟨first⟩ := callback none (I ⊕ R) S hS eFirst (hroot none)
    let eRest := (mwSwap I (L none) R).trans first.labels
    have restRoots : ∀ i x, first.endpoint.channel x (eRest (.inl i)) = m (some i) x := by
      intro i x
      exact (first.coordinates x (.inr (.inl i))).trans (hroot (some i) x)
    obtain ⟨rest⟩ := ih (fun i => L (some i)) (fun i => m (some i))
      (fun i => w (some i)) k (fun i => callback (some i)) (L none ⊕ R)
      first.endpoint (first.path.isSingular hS) eRest restRoots
    refine ⟨{
      endpoint := rest.endpoint
      path := first.path.append rest.path
      homogeneous := (OperationPath.homogeneous_append _ _ _).mpr
        ⟨first.homogeneous, rest.homogeneous⟩
      labels := (mwOptionLeaves I R L).trans rest.labels
      coordinates := ?_ }⟩
    intro x l
    rcases l with ⟨_ | i, l⟩ | r
    · exact (rest.coordinates x (.inr (.inl l))).trans (first.coordinates x (.inl l))
    · exact rest.coordinates x (.inl ⟨i, l⟩)
    · exact (rest.coordinates x (.inr (.inr r))).trans (first.coordinates x (.inr (.inr r)))


namespace LabelledOperationResult

variable {k : OperationKind} {S T : ActiveFiniteChannel alpha}
  {L : Type v} {mass : alpha → L → ENNReal}

/-- Singularity follows along the actual returned path. -/
theorem isSingular (d : LabelledOperationResult k S L mass)
    (hS : IsSingularChannel S.channel) : IsSingularChannel d.endpoint.channel :=
  d.path.isSingular hS

/-- The endpoint has exactly the supplied labels. -/
theorem outputCard [Fintype L] (d : LabelledOperationResult k S L mass) :
    d.endpoint.outputCard = Fintype.card L := by
  simpa using (Fintype.card_congr d.labels).symm

/-- Compare the returned endpoint with an independently supplied labelled target. -/
def outputEquiv (d : LabelledOperationResult k S L mass)
    (e : L ≃ Fin T.outputCard) (hT : ∀ x l, T.channel x (e l) = mass x l) :
    OutputEquiv d.endpoint T :=
  OutputEquiv.ofCoordinates (d.labels.symm.trans e) (by
    intro x y
    obtain ⟨l, rfl⟩ := d.labels.surjective y
    simpa using (hT x l).trans (d.coordinates x l).symm)

/-- The same path followed by its explicit endpoint comparison. -/
def cascade (d : LabelledOperationResult k S L mass)
    (e : L ≃ Fin T.outputCard) (hT : ∀ x l, T.channel x (e l) = mass x l) :
    Cascade S T := ⟨d.endpoint, d.path, d.outputEquiv e hT⟩

end LabelledOperationResult

/-- Split every source column into its supplied positive normalized family.
The sigma labels identify both the source column and its chosen child. -/
def multiPpsFamily (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    {I : Fin S.outputCard → Type v} [∀ j, Fintype (I j)]
    (weights : ∀ j, I j → NNReal) (hpos : ∀ j i, 0 < weights j i)
    (hsum : ∀ j, ∑ i, weights j i = 1) :
    LabelledOperationResult .pps S (Σ j, I j)
      (fun x p => (weights p.1 p.2 : ENNReal) * S.channel x p.1) := by
  let J := ULift.{v} (Fin S.outputCard)
  let L : J → Type v := fun j => I j.down
  let eRoot : J ⊕ PEmpty.{v + 1} ≃ Fin S.outputCard :=
    (Equiv.sumEmpty J _).trans Equiv.ulift
  have callback : mwSplitCallbacks J L (fun j x => S.channel x j.down)
      (fun j i x => (weights j.down i : ENNReal) * S.channel x j.down) .pps := by
    intro j R A hA e hroot
    let d := multiPpsCore A hA e (weights j.down) (hpos j.down) (hsum j.down)
    refine ⟨⟨d.endpoint, d.path, d.homogeneous, d.labels, ?_⟩⟩
    intro x l
    rcases l with i | r
    · exact (d.coordinates x (.inl i)).trans
        (congrArg (fun z => (weights j.down i : ENNReal) * z) (hroot x))
    · exact d.coordinates x (.inr r)
  let d := Classical.choice (mwSplitFamily J L (fun j x => S.channel x j.down)
    (fun j i x => (weights j.down i : ENNReal) * S.channel x j.down)
    .pps callback PEmpty S hS eRoot (fun _ _ => rfl))
  let eLeaves : (Σ j : J, L j) ≃ (Σ j, I j) := Equiv.sigmaCongrLeft Equiv.ulift
  refine ⟨d.endpoint, d.path, d.homogeneous,
    eLeaves.symm.trans ((Equiv.sumEmpty _ PEmpty).symm.trans d.labels), ?_⟩
  intro x p
  obtain ⟨q, rfl⟩ := eLeaves.surjective p
  change d.endpoint.channel x (d.labels (.inl (eLeaves.symm (eLeaves q)))) = _
  rw [Equiv.symm_apply_apply]
  exact d.coordinates x (.inl q)

section Weights
variable {I : Type v} [Fintype I]

private theorem positive_sum (w : I → NNReal) :
    ∑ i : {i // 0 < w i}, w i.val = ∑ i, w i := by
  have he := Finset.sum_congr_set {i | 0 < w i} w (fun i => w i.val)
    (fun _ _ => rfl) (fun i hi => le_antisymm (not_lt.mp hi) bot_le)
  exact he.symm

theorem positiveWeights_sum (w : I → NNReal) (hs : ∑ i, w i = 1) :
    ∑ i : {i // 0 < w i}, w i.val = 1 := (positive_sum w).trans hs

theorem positiveWeights_nonempty (w : I → NNReal) (hs : ∑ i, w i = 1) :
    Nonempty {i // 0 < w i} := by
  by_contra hn
  have hz (i : I) : w i = 0 :=
    le_antisymm (le_of_not_gt (fun hi => hn ⟨⟨i, hi⟩⟩)) bot_le
  simp only [hz, Finset.sum_const_zero] at hs
  exact zero_ne_one hs

omit [Fintype I] in
private theorem positive_inclusion_range (w : I → NNReal) (i : I) :
    i ∈ Set.range (Subtype.val : {i // 0 < w i} → I) ↔ 0 < w i := by
  constructor
  · rintro ⟨j, rfl⟩
    exact j.property
  · intro hi
    exact ⟨⟨i, hi⟩, rfl⟩

omit [Fintype I] in
theorem positiveWeights_zero_off_range (w : I → NNReal) (i : I)
    (hi : i ∉ Set.range (Subtype.val : {i // 0 < w i} → I)) : w i = 0 :=
  le_antisymm (le_of_not_gt (fun hp => hi ((positive_inclusion_range w i).mpr hp))) bot_le

omit [Fintype I] in
theorem positiveWeights_map (w : I → NNReal) (p : PMF {i // 0 < w i})
    (hp : ∀ i, p i = (w i.val : ENNReal)) (i : I) :
    p.map Subtype.val i = (w i : ENNReal) := by
  by_cases hi : 0 < w i
  · exact (PMF.map_apply_of_injective p Subtype.val_injective ⟨i, hi⟩).trans (hp ⟨i, hi⟩)
  · have ho : i ∉ Set.range (Subtype.val : {i // 0 < w i} → I) :=
      fun h => hi ((positive_inclusion_range w i).mp h)
    rw [PMF.map_apply_eq_zero_of_notMem_range p ho, positiveWeights_zero_off_range w i ho]
    rfl

-- Sum one derives finiteness; users do not supply a separate mass-finiteness premise.
private theorem normalized_ne_top (w : I → ENNReal) (hs : ∑ i, w i = 1) (i : I) : w i ≠ ∞ := by
  apply ne_top_of_le_ne_top ENNReal.one_ne_top
  rw [← hs]
  exact Finset.single_le_sum (fun j _ => (show (0 : ENNReal) ≤ w j from zero_le))
    (Finset.mem_univ i)

private theorem normalized_toNNReal_sum (w : I → ENNReal) (hs : ∑ i, w i = 1) :
    ∑ i, (w i).toNNReal = 1 := by
  have hsum := ENNReal.toNNReal_sum (s := Finset.univ) (f := w)
    (fun i _ => normalized_ne_top w hs i)
  simpa only [hs, ENNReal.toNNReal_one] using hsum.symm

private theorem normalized_coe_toNNReal (w : I → ENNReal) (hs : ∑ i, w i = 1) (i : I) :
    ((w i).toNNReal : ENNReal) = w i := ENNReal.coe_toNNReal (normalized_ne_top w hs i)

private theorem normalized_toNNReal_pos (w : I → ENNReal) (hs : ∑ i, w i = 1) (i : I) :
    0 < (w i).toNNReal ↔ 0 < w i := by
  rw [ENNReal.toNNReal_pos_iff]
  exact and_iff_left (lt_top_iff_ne_top.mpr (normalized_ne_top w hs i))

private def normalized_positive_equiv (w : I → ENNReal) (hs : ∑ i, w i = 1) :
    {i // 0 < (w i).toNNReal} ≃ {i // 0 < w i} :=
  Equiv.subtypeEquivRight (normalized_toNNReal_pos w hs)

end Weights

/-- Ignore exactly the zero-weight labels before splitting a selected column. -/
def multiPpsOfNonnegative (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) {I : Type v} [Fintype I] (weights : I → NNReal)
    (hsum : ∑ i, weights i = 1) :
    LabelledOperationResult .pps S
      ({i // 0 < weights i} ⊕ {j : Fin S.outputCard // j ≠ l})
      (fun x => Sum.elim (fun i => (weights i.val : ENNReal) * S.channel x l)
        (fun j => S.channel x j.val)) :=
  multiPps S hS l (fun i : {i // 0 < weights i} => weights i.val)
    (fun i => i.property) (positiveWeights_sum weights hsum)

/-- The family constructor on the positive support of each supplied family. -/
def multiPpsFamilyOfNonnegative (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel)
    {I : Fin S.outputCard → Type v} [∀ j, Fintype (I j)]
    (weights : ∀ j, I j → NNReal) (hsum : ∀ j, ∑ i, weights j i = 1) :
    LabelledOperationResult .pps S (Σ j, {i // 0 < weights j i})
      (fun x p => (weights p.1 p.2.val : ENNReal) * S.channel x p.1) :=
  multiPpsFamily S hS (fun j (i : {i // 0 < weights j i}) => weights j i.val)
    (fun _ i => i.property) (fun j => positiveWeights_sum (weights j) (hsum j))

/-- A normalized ENNReal family is finite-valued. Convert it exactly and retain
the original positive labels; callers need no extra finiteness premise. -/
def multiPpsOfENNReal (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) {I : Type v} [Fintype I] (weights : I → ENNReal)
    (hsum : ∑ i, weights i = 1) :
    LabelledOperationResult .pps S
      ({i // 0 < weights i} ⊕ {j : Fin S.outputCard // j ≠ l})
      (fun x => Sum.elim (fun i => weights i.val * S.channel x l)
        (fun j => S.channel x j.val)) := by
  let d := multiPpsOfNonnegative S hS l (fun i => (weights i).toNNReal)
    (normalized_toNNReal_sum weights hsum)
  let e := normalized_positive_equiv weights hsum
  refine ⟨d.endpoint, d.path, d.homogeneous,
    (Equiv.sumCongr e.symm (Equiv.refl _)).trans d.labels, ?_⟩
  intro x b
  rcases b with i | j
  · exact (d.coordinates x (.inl (e.symm i))).trans
      (congrArg (fun z => z * S.channel x l)
        (normalized_coe_toNNReal weights hsum i.val))
  · exact d.coordinates x (.inr j)

/-- Exact ENNReal synthesis for a finite family, on its original positive labels. -/
def multiPpsFamilyOfENNReal (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel)
    {I : Fin S.outputCard → Type v} [∀ j, Fintype (I j)]
    (weights : ∀ j, I j → ENNReal) (hsum : ∀ j, ∑ i, weights j i = 1) :
    LabelledOperationResult .pps S (Σ j, {i // 0 < weights j i})
      (fun x p => weights p.1 p.2.val * S.channel x p.1) := by
  let d := multiPpsFamilyOfNonnegative S hS (fun j i => (weights j i).toNNReal)
    (fun j => normalized_toNNReal_sum (weights j) (hsum j))
  let e := Equiv.sigmaCongrRight (fun j => (normalized_positive_equiv (weights j) (hsum j)).symm)
  refine ⟨d.endpoint, d.path, d.homogeneous, e.trans d.labels, ?_⟩
  intro x p
  exact (d.coordinates x (e p)).trans
    (congrArg (fun z => z * S.channel x p.1)
      (normalized_coe_toNNReal (weights p.1) (hsum p.1) p.2.val))

section SelectedSpecifications
attribute [local instance] operationQuiver
private theorem pps_outputCard_growth {S T : ActiveFiniteChannel alpha}
    (p : OperationPath S T) (hp : p.Homogeneous .pps) :
    T.outputCard = S.outputCard + p.length := by
  induction p with
  | nil => rfl
  | cons p e ih =>
      have h := (OperationPath.allowed_snoc _ p e).mp hp
      cases e with
      | pps hT l t ht0 ht1 =>
          change _ + 1 = S.outputCard + (p.length + 1)
          rw [ih h.1, Nat.add_assoc]
          rfl
      | vps hT l mask hl hr => simp [OperationStep.kind] at h
      | ppm hT a b hab hs => simp [OperationStep.kind] at h
      | vpm hT a b hab hv hd => simp [OperationStep.kind] at h

variable (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
  (l : Fin S.outputCard) {I : Type v} [Fintype I] (weights : I → NNReal)
  (hpos : ∀ i, 0 < weights i) (hsum : ∑ i, weights i = 1)

theorem multiPps_outputCard :
    (multiPps S hS l weights hpos hsum).endpoint.outputCard =
      S.outputCard - 1 + Fintype.card I := by
  have hc := Fintype.card_congr (multiPps S hS l weights hpos hsum).labels
  simpa only [Fintype.card_sum, Fintype.card_fin, Fintype.card_subtype_compl,
    Fintype.card_subtype_eq, Nat.add_comm] using hc.symm

theorem multiPps_length :
    (multiPps S hS l weights hpos hsum).path.length = Fintype.card I - 1 := by
  have hg := pps_outputCard_growth (multiPps S hS l weights hpos hsum).path
    (multiPps S hS l weights hpos hsum).homogeneous
  have hc := multiPps_outputCard S hS l weights hpos hsum
  have hn := l.isLt
  omega

theorem multiPps_length_singleton [Subsingleton I] :
    (multiPps S hS l weights hpos hsum).path.length = 0 := by
  rw [multiPps_length]
  have hc : Fintype.card I ≤ 1 := Fintype.card_le_one_iff_subsingleton.mpr inferInstance
  omega

theorem multiPps_columnValue (i : I) :
    columnValue (multiPps S hS l weights hpos hsum).endpoint.channel
      ((multiPps S hS l weights hpos hsum).path.isSingular hS)
      ((multiPps S hS l weights hpos hsum).endpoint.activeEquiv
        ((multiPps S hS l weights hpos hsum).labels (.inl i))) =
      (weights i : ENNReal) * columnValue S.channel hS (S.activeEquiv l) := by
  let d := multiPps S hS l weights hpos hsum
  obtain ⟨x, hx⟩ := S.output_active l
  have hchild : d.endpoint.channel x (d.labels (.inl i)) ≠ 0 := by
    rw [d.coordinates]
    exact mul_ne_zero (ENNReal.coe_ne_zero.mpr (ne_of_gt (hpos i))) hx
  rw [columnValue_eq_of_ne_zero _ _ _ hchild, columnValue_eq_of_ne_zero _ _ _ hx]
  exact d.coordinates x (.inl i)

theorem multiPps_columnValue_keep (j : {j : Fin S.outputCard // j ≠ l}) :
    columnValue (multiPps S hS l weights hpos hsum).endpoint.channel
      ((multiPps S hS l weights hpos hsum).path.isSingular hS)
      ((multiPps S hS l weights hpos hsum).endpoint.activeEquiv
        ((multiPps S hS l weights hpos hsum).labels (.inr j))) =
      columnValue S.channel hS (S.activeEquiv j.val) := by
  let d := multiPps S hS l weights hpos hsum
  apply columnValue_transport S.channel d.endpoint.channel hS
    (d.path.isSingular hS) (S.activeEquiv j.val)
    (d.endpoint.activeEquiv (d.labels (.inr j))) (Equiv.refl alpha)
  intro x
  exact d.coordinates x (.inr j)

variable [Fintype alpha]

theorem multiPps_columnPattern (i : I) :
    columnPattern (multiPps S hS l weights hpos hsum).endpoint.channel
      ((multiPps S hS l weights hpos hsum).endpoint.activeEquiv
        ((multiPps S hS l weights hpos hsum).labels (.inl i))) =
      columnPattern S.channel (S.activeEquiv l) := by
  let d := multiPps S hS l weights hpos hsum
  apply Subtype.ext
  ext x
  simp only [mem_columnPattern]
  change d.endpoint.channel x (d.labels (.inl i)) ≠ 0 ↔ S.channel x l ≠ 0
  rw [d.coordinates]
  simp only [Sum.elim_inl, ne_eq, mul_eq_zero, ENNReal.coe_eq_zero,
    ne_of_gt (hpos i), false_or]

theorem multiPps_columnPattern_keep (j : {j : Fin S.outputCard // j ≠ l}) :
    columnPattern (multiPps S hS l weights hpos hsum).endpoint.channel
      ((multiPps S hS l weights hpos hsum).endpoint.activeEquiv
        ((multiPps S hS l weights hpos hsum).labels (.inr j))) =
      columnPattern S.channel (S.activeEquiv j.val) := by
  let d := multiPps S hS l weights hpos hsum
  apply Subtype.ext
  ext x
  simp only [mem_columnPattern]
  change d.endpoint.channel x (d.labels (.inr j)) ≠ 0 ↔ S.channel x j.val ≠ 0
  rw [d.coordinates]
  rfl


end SelectedSpecifications

/-! ## Finite exact-partition VPS synthesis -/

omit [Finite alpha] [Nonempty alpha] in
private theorem vpOutsideFirst {I : Type v} (blocks : Option I → Finset alpha)
    (hdis : Pairwise (fun i j => Disjoint (blocks i) (blocks j)))
    (i : I) {x : alpha} (hx : x ∈ blocks (some i)) : x ∉ blocks none := by
  intro hn
  exact Finset.disjoint_left.mp (hdis (show (none : Option I) ≠ some i by simp)) hn hx

private def vpsCoreSpec (I : Type v) : Prop :=
  ∀ (blocks : I → Finset alpha), (∀ i, (blocks i).Nonempty) →
    Pairwise (fun i j => Disjoint (blocks i) (blocks j)) →
    ∀ (R : Type w) (S : ActiveFiniteChannel alpha) (_hS : IsSingularChannel S.channel)
      (e : Unit ⊕ R ≃ Fin S.outputCard),
      (∀ x, S.channel x (e (.inl ())) ≠ 0 ↔ ∃ i, x ∈ blocks i) →
      Nonempty (LabelledOperationResult .vps S (I ⊕ R)
        (fun x => Sum.elim
          (fun i => if x ∈ blocks i then S.channel x (e (.inl ())) else 0)
          (fun r => S.channel x (e (.inr r)))))

private theorem multiVpsCore_exists (I : Type v) [Finite I] :
    vpsCoreSpec.{u, v, w} (alpha := alpha) I := by
  refine Finite.induction_empty_option ?_ ?_ ?_ I
  · intro I J eIJ ih blocks hne hdis R S hS e hcover
    have hcover' (x : alpha) :
        S.channel x (e (.inl ())) ≠ 0 ↔ ∃ i : I, x ∈ blocks (eIJ i) := by
      rw [hcover]
      constructor
      · rintro ⟨j, hj⟩
        exact ⟨eIJ.symm j, by simpa only [Equiv.apply_symm_apply] using hj⟩
      · rintro ⟨i, hi⟩
        exact ⟨eIJ i, hi⟩
    obtain ⟨d⟩ := ih (fun i => blocks (eIJ i)) (fun i => hne (eIJ i))
      (fun _ _ hij => hdis (eIJ.injective.ne hij)) R S hS e hcover'
    refine ⟨⟨d.endpoint, d.path, d.homogeneous,
      (Equiv.sumCongr eIJ.symm (Equiv.refl R)).trans d.labels, ?_⟩⟩
    intro x b
    cases b with
    | inl j =>
        change d.endpoint.channel x (d.labels (.inl (eIJ.symm j))) = _
        simpa only [Sum.elim_inl, Equiv.apply_symm_apply] using
          d.coordinates x (.inl (eIJ.symm j))
    | inr r => exact d.coordinates x (.inr r)
  · intro blocks _ _ R S _ e hcover
    obtain ⟨x, hx⟩ := S.output_active (e (.inl ()))
    obtain ⟨i, _⟩ := (hcover x).mp hx
    exact isEmptyElim i
  · intro I _ ih blocks hne hdis R S hS e hcover
    by_cases hI : Nonempty I
    · let := hI
      let mask : alpha → Bool := fun x => decide (x ∈ blocks none)
      have hleft : ∃ x, S.channel x (e (.inl ())) ≠ 0 ∧ mask x = true := by
        obtain ⟨x, hx⟩ := hne none
        exact ⟨x, (hcover x).mpr ⟨none, hx⟩, by simp [mask, hx]⟩
      have hright : ∃ x, S.channel x (e (.inl ())) ≠ 0 ∧ mask x = false := by
        obtain ⟨i⟩ := hI
        obtain ⟨x, hx⟩ := hne (some i)
        exact ⟨x, (hcover x).mpr ⟨some i, hx⟩,
          by simp [mask, vpOutsideFirst blocks hdis i hx]⟩
      let A := vps S hS (e (.inl ())) mask hleft hright
      let first : OperationPath S A := OperationPath.nil.snoc
        (.vps S hS (e (.inl ())) mask hleft hright)
      have hfirst : first.Homogeneous .vps := by
        simp [first, A, OperationPath.Homogeneous, OperationStep.kind]
      have hrestCover (x : alpha) :
          A.channel x (ppSplitLabels e (.inl ())) ≠ 0 ↔
            ∃ i : I, x ∈ blocks (some i) := by
        dsimp only [A]
        rw [ppSplitLabels_right, vps_right_ne_zero_iff]
        simp only [mask, decide_eq_false_iff_not]
        constructor
        · rintro ⟨hx, hn⟩
          obtain ⟨i, hi⟩ := (hcover x).mp hx
          cases i with
          | none => exact (hn hi).elim
          | some i => exact ⟨i, hi⟩
        · rintro ⟨i, hi⟩
          exact ⟨(hcover x).mpr ⟨some i, hi⟩, vpOutsideFirst blocks hdis i hi⟩
      have hrestDis : Pairwise (fun i j : I => Disjoint (blocks (some i)) (blocks (some j))) := by
        intro i j hij
        exact hdis (fun h => hij (Option.some.inj h))
      obtain ⟨rest⟩ := ih (fun i => blocks (some i)) (fun i => hne (some i))
        hrestDis (Unit ⊕ R) A (first.isSingular hS) (ppSplitLabels e) hrestCover
      have hleftCoord (x : alpha) : A.channel x (ppSplitLabels e (.inr (.inl ()))) =
          if x ∈ blocks none then S.channel x (e (.inl ())) else 0 := by
        dsimp only [A]
        rw [ppSplitLabels_left, vps_left]
        simp [mask]
      have hkeep (x : alpha) (r : R) : A.channel x (ppSplitLabels e (.inr (.inr r))) =
          S.channel x (e (.inr r)) := by
        dsimp only [A]
        rw [ppSplitLabels_keep, vps_keep]
        exact e.injective.ne (by simp)
      refine ⟨⟨rest.endpoint, first.append rest.path,
        (OperationPath.homogeneous_append _ _ _).mpr ⟨hfirst, rest.homogeneous⟩,
        (ppOptionLabels I R).trans rest.labels, ?_⟩⟩
      intro x b
      rcases b with (_ | i) | r
      · exact (rest.coordinates x (.inr (.inl ()))).trans (hleftCoord x)
      · change rest.endpoint.channel x (rest.labels (.inl i)) = _
        rw [rest.coordinates]
        change (if x ∈ blocks (some i) then A.channel x (ppSplitLabels e (.inl ())) else 0) =
          if x ∈ blocks (some i) then S.channel x (e (.inl ())) else 0
        by_cases hx : x ∈ blocks (some i)
        · simp only [hx, ↓reduceIte]
          dsimp only [A]
          rw [ppSplitLabels_right, vps_right]
          simp [mask, vpOutsideFirst blocks hdis i hx]
        · simp only [hx, ↓reduceIte]
      · exact (rest.coordinates x (.inr (.inr r))).trans (hkeep x r)
    · let : IsEmpty I := not_nonempty_iff.mp hI
      let labels := (Equiv.sumCongr (Equiv.ofUnique (Option I) Unit) (Equiv.refl R)).trans e
      refine ⟨⟨S, .nil, OperationPath.homogeneous_nil _, labels, ?_⟩⟩
      intro x b
      rcases b with (_ | i) | r
      · change S.channel x (e (.inl ())) =
          if x ∈ blocks none then S.channel x (e (.inl ())) else 0
        by_cases hx : x ∈ blocks none
        · rw [if_pos hx]
        · rw [if_neg hx]
          by_contra hn
          obtain ⟨i, hi⟩ := (hcover x).mp hn
          cases i with
          | none => exact hx hi
          | some i => exact isEmptyElim i
      · exact isEmptyElim i
      · rfl

private def multiVpsCore {I : Type v} [Finite I] {R : Type w}
    (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (e : Unit ⊕ R ≃ Fin S.outputCard) (blocks : I → Finset alpha)
    (hne : ∀ i, (blocks i).Nonempty)
    (hdis : Pairwise (fun i j => Disjoint (blocks i) (blocks j)))
    (hcover : ∀ x, S.channel x (e (.inl ())) ≠ 0 ↔ ∃ i, x ∈ blocks i) :
    LabelledOperationResult .vps S (I ⊕ R)
      (fun x => Sum.elim
        (fun i => if x ∈ blocks i then S.channel x (e (.inl ())) else 0)
        (fun r => S.channel x (e (.inr r)))) :=
  Classical.choice (multiVpsCore_exists.{u, v, w} I blocks hne hdis R S hS e hcover)

/-- Split a selected admitted pattern into exactly its supplied partition parts
by actual binary VPS operations, preserving every unaffected output. -/
def multiVps [Fintype alpha] (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (l : Fin S.outputCard) (P : Finpartition (columnPattern S.channel (S.activeEquiv l)).val) :
    LabelledOperationResult .vps S (P.parts ⊕ {j : Fin S.outputCard // j ≠ l})
      (fun x => Sum.elim (fun b => if x ∈ b.val then S.channel x l else 0)
        (fun j => S.channel x j.val)) :=
  multiVpsCore S hS (ppInitialLabels l) (fun b : P.parts => b.val)
    (fun b => P.nonempty_of_mem_parts b.property)
    (by
      intro a b hab
      exact P.disjoint a.property b.property (fun h => hab (Subtype.ext h)))
    (by
      intro x
      constructor
      · intro hx
        obtain ⟨b, hb, hxb⟩ := P.exists_mem ((mem_columnPattern _ _ x).mpr hx)
        exact ⟨⟨b, hb⟩, hxb⟩
      · rintro ⟨b, hx⟩
        exact (mem_columnPattern _ _ x).mp (P.subset b.property hx))

section VpsFamilies
variable [Fintype alpha]

/-- Split every source pattern according to its supplied exact partition.
The sigma labels retain both the source column and the original part. -/
def multiVpsFamily (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (P : ∀ j, Finpartition (columnPattern S.channel (S.activeEquiv j)).val) :
    LabelledOperationResult .vps S (Σ j, (P j).parts)
      (fun x p => if x ∈ p.2.val then S.channel x p.1 else 0) := by
  let J := ULift.{u} (Fin S.outputCard)
  let L : J → Type u := fun j => (P j.down).parts
  let eRoot : J ⊕ PEmpty.{u + 1} ≃ Fin S.outputCard :=
    (Equiv.sumEmpty J _).trans Equiv.ulift
  have callback : mwSplitCallbacks J L (fun j x => S.channel x j.down)
      (fun j b x => if x ∈ b.val then S.channel x j.down else 0) .vps := by
    intro j R A hA e hroot
    have hcover (x : alpha) : A.channel x (e (.inl ())) ≠ 0 ↔
        ∃ b : (P j.down).parts, x ∈ b.val := by
      rw [hroot x]
      constructor
      · intro hx
        obtain ⟨b, hb, hxb⟩ := (P j.down).exists_mem
          ((mem_columnPattern S.channel (S.activeEquiv j.down) x).mpr hx)
        exact ⟨⟨b, hb⟩, hxb⟩
      · rintro ⟨b, hx⟩
        exact (mem_columnPattern S.channel (S.activeEquiv j.down) x).mp
          ((P j.down).subset b.property hx)
    let d := multiVpsCore A hA e (fun b : (P j.down).parts => b.val)
      (fun b => (P j.down).nonempty_of_mem_parts b.property)
      (fun b c hbc => (P j.down).disjoint b.property c.property
        (fun he => hbc (Subtype.ext he))) hcover
    refine ⟨⟨d.endpoint, d.path, d.homogeneous, d.labels, ?_⟩⟩
    intro x l
    rcases l with b | r
    · exact (d.coordinates x (.inl b)).trans
        (congrArg (fun z => if x ∈ b.val then z else 0) (hroot x))
    · exact d.coordinates x (.inr r)
  let d := Classical.choice (mwSplitFamily J L (fun j x => S.channel x j.down)
    (fun j b x => if x ∈ b.val then S.channel x j.down else 0)
    .vps callback PEmpty S hS eRoot (fun _ _ => rfl))
  let eLeaves : (Σ j : J, L j) ≃ (Σ j, (P j).parts) :=
    { toFun := fun p => ⟨p.1.down, p.2⟩
      invFun := fun p => ⟨⟨p.1⟩, p.2⟩
      left_inv := by rintro ⟨⟨j⟩, b⟩; rfl
      right_inv := by rintro ⟨j, b⟩; rfl }
  refine ⟨d.endpoint, d.path, d.homogeneous,
    eLeaves.symm.trans ((Equiv.sumEmpty _ PEmpty).symm.trans d.labels), ?_⟩
  intro x p
  obtain ⟨q, rfl⟩ := eLeaves.surjective p
  change d.endpoint.channel x (d.labels (.inl (eLeaves.symm (eLeaves q)))) = _
  rw [Equiv.symm_apply_apply]
  exact d.coordinates x (.inl q)

end VpsFamilies

section VpsSpecifications
attribute [local instance] operationQuiver

private theorem vps_outputCard_growth {S T : ActiveFiniteChannel alpha}
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
          rw [ih h.1, Nat.add_assoc]
          rfl
      | ppm hT a b hab hs => simp [OperationStep.kind] at h
      | vpm hT a b hab hv hd => simp [OperationStep.kind] at h

variable [Fintype alpha] (S : ActiveFiniteChannel alpha)
  (hS : IsSingularChannel S.channel) (l : Fin S.outputCard)
  (P : Finpartition (columnPattern S.channel (S.activeEquiv l)).val)

theorem multiVps_outputCard :
    (multiVps S hS l P).endpoint.outputCard = S.outputCard - 1 + P.parts.card := by
  have hc := Fintype.card_congr (multiVps S hS l P).labels
  simpa only [Fintype.card_sum, Fintype.card_coe, Fintype.card_fin,
    Fintype.card_subtype_compl, Fintype.card_subtype_eq, Nat.add_comm] using hc.symm

theorem multiVps_length :
    (multiVps S hS l P).path.length = P.parts.card - 1 := by
  have hg := vps_outputCard_growth (multiVps S hS l P).path (multiVps S hS l P).homogeneous
  have hc := multiVps_outputCard S hS l P
  have hn := l.isLt
  omega

theorem multiVps_length_singleton [Subsingleton P.parts] :
    (multiVps S hS l P).path.length = 0 := by
  rw [multiVps_length]
  have hc : Fintype.card P.parts ≤ 1 := Fintype.card_le_one_iff_subsingleton.mpr inferInstance
  simpa only [Fintype.card_coe] using (Nat.sub_eq_zero_of_le hc)

theorem multiVps_columnValue (b : P.parts) :
    columnValue (multiVps S hS l P).endpoint.channel
      ((multiVps S hS l P).path.isSingular hS)
      ((multiVps S hS l P).endpoint.activeEquiv ((multiVps S hS l P).labels (.inl b))) =
      columnValue S.channel hS (S.activeEquiv l) := by
  let d := multiVps S hS l P
  obtain ⟨x, hx⟩ := P.nonempty_of_mem_parts b.property
  have hs : S.channel x l ≠ 0 :=
    (mem_columnPattern S.channel (S.activeEquiv l) x).mp (P.le b.property hx)
  have he : d.endpoint.channel x (d.labels (.inl b)) = S.channel x l := by
    simpa only [Sum.elim_inl, if_pos hx] using d.coordinates x (.inl b)
  have hn : d.endpoint.channel x (d.labels (.inl b)) ≠ 0 := by rw [he]; exact hs
  rw [columnValue_eq_of_ne_zero _ _ _ hn, columnValue_eq_of_ne_zero _ _ _ hs]
  exact he

theorem multiVps_columnValue_keep (j : {j : Fin S.outputCard // j ≠ l}) :
    columnValue (multiVps S hS l P).endpoint.channel
      ((multiVps S hS l P).path.isSingular hS)
      ((multiVps S hS l P).endpoint.activeEquiv ((multiVps S hS l P).labels (.inr j))) =
      columnValue S.channel hS (S.activeEquiv j.val) := by
  let d := multiVps S hS l P
  apply columnValue_transport S.channel d.endpoint.channel hS
    (d.path.isSingular hS) (S.activeEquiv j.val)
    (d.endpoint.activeEquiv (d.labels (.inr j))) (Equiv.refl alpha)
  intro x
  exact d.coordinates x (.inr j)

theorem multiVps_columnPattern (b : P.parts) :
    (columnPattern (multiVps S hS l P).endpoint.channel
      ((multiVps S hS l P).endpoint.activeEquiv ((multiVps S hS l P).labels (.inl b)))).val =
      b.val := by
  let d := multiVps S hS l P
  ext x
  rw [mem_columnPattern]
  change d.endpoint.channel x (d.labels (.inl b)) ≠ 0 ↔ x ∈ b.val
  rw [d.coordinates]
  simp only [Sum.elim_inl]
  by_cases hx : x ∈ b.val
  · have hs : S.channel x l ≠ 0 :=
      (mem_columnPattern S.channel (S.activeEquiv l) x).mp (P.le b.property hx)
    rw [if_pos hx]
    exact ⟨fun _ => hx, fun _ => hs⟩
  · rw [if_neg hx]
    exact ⟨fun h => (h rfl).elim, fun h => (hx h).elim⟩

theorem multiVps_columnPattern_keep (j : {j : Fin S.outputCard // j ≠ l}) :
    columnPattern (multiVps S hS l P).endpoint.channel
      ((multiVps S hS l P).endpoint.activeEquiv ((multiVps S hS l P).labels (.inr j))) =
      columnPattern S.channel (S.activeEquiv j.val) := by
  let d := multiVps S hS l P
  apply Subtype.ext
  ext x
  simp only [mem_columnPattern]
  change d.endpoint.channel x (d.labels (.inr j)) ≠ 0 ↔ S.channel x j.val ≠ 0
  rw [d.coordinates]
  rfl

end VpsSpecifications

end

end PerfectFunctionalRepresentations.MatrixOperations


namespace PerfectFunctionalRepresentations.MatrixOperations

open scoped BigOperators ENNReal
noncomputable section
attribute [local instance] Classical.propDecidable
universe u v w
variable {alpha : Type u} [Finite alpha] [Nonempty alpha]

private def pmRetained (S : ActiveFiniteChannel alpha) (b : Fin S.outputCard) :
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

private def pmDropSecond (R : Type w) :
    Unit ⊕ R ≃ {j : Unit ⊕ (Unit ⊕ R) // j ≠ .inr (.inl ())} where
  toFun
    | .inl u => ⟨.inl u, by simp⟩
    | .inr r => ⟨.inr (.inr r), by simp⟩
  invFun
    | ⟨.inl u, _⟩ => .inl u
    | ⟨.inr (.inl u), h⟩ => (h (by cases u; rfl)).elim
    | ⟨.inr (.inr r), _⟩ => .inr r
  left_inv := by rintro (⟨⟩ | r) <;> rfl
  right_inv := by
    rintro ⟨(⟨⟩ | ⟨⟩ | r), h⟩
    · rfl
    · exact (h rfl).elim
    · rfl

private def pmMergeLabels {R : Type w} (S : ActiveFiniteChannel alpha)
    (e : Unit ⊕ (Unit ⊕ R) ≃ Fin S.outputCard) : Unit ⊕ R ≃ Fin (S.outputCard - 1) :=
  (pmDropSecond R).trans
    ((e.subtypeEquiv
      (p := fun j => j ≠ .inr (.inl ()))
      (q := fun j => j ≠ e (.inr (.inl ())))
      (fun j => by
        constructor
        · intro h he
          exact h (e.injective he)
        · intro h he
          exact h (congrArg e he))).trans
      (pmRetained S (e (.inr (.inl ())))).symm)

private theorem pmMergeLabels_retained {R : Type w} (S : ActiveFiniteChannel alpha)
    (e : Unit ⊕ (Unit ⊕ R) ≃ Fin S.outputCard) (j : Unit ⊕ R) :
    activeMergeRetained S (e (.inr (.inl ()))) (pmMergeLabels S e j) =
      e (pmDropSecond R j).val := by
  change (pmRetained S (e (.inr (.inl ()) )) (pmMergeLabels S e j)).val = _
  simp only [pmMergeLabels, Equiv.trans_apply, Equiv.apply_symm_apply]
  rfl

private theorem pmMergeLabels_root {R : Type w} (S : ActiveFiniteChannel alpha)
    (e : Unit ⊕ (Unit ⊕ R) ≃ Fin S.outputCard)
    (hab : e (.inl ()) < e (.inr (.inl ()))) :
    pmMergeLabels S e (.inl ()) =
      activeMergeSurvivor S (e (.inl ())) (e (.inr (.inl ()))) hab := by
  apply (pmRetained S (e (.inr (.inl ())))).injective
  apply Subtype.ext
  change activeMergeRetained S _ _ = activeMergeRetained S _ _
  rw [pmMergeLabels_retained, activeMergeRetained_survivor]
  rfl

private def pmMergeOrdered {R : Type w} (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (e : Unit ⊕ (Unit ⊕ R) ≃ Fin S.outputCard)
    (hab : e (.inl ()) < e (.inr (.inl ())))
    (hp : ∀ x, S.channel x (e (.inl ())) ≠ 0 ↔ S.channel x (e (.inr (.inl ()))) ≠ 0) :
    LabelledOperationResult .ppm S (Unit ⊕ R)
      (fun x => Sum.elim
        (fun _ => S.channel x (e (.inl ())) + S.channel x (e (.inr (.inl ()))))
        (fun r => S.channel x (e (.inr (.inr r))))) where
  endpoint := ppm S hS _ _ hab hp
  path := OperationPath.nil.snoc (.ppm S hS _ _ hab hp)
  homogeneous := by simp [OperationPath.Homogeneous, OperationStep.kind]
  labels := pmMergeLabels S e
  coordinates := by
    intro x j
    rcases j with u | r
    · cases u
      exact (congrArg ((ppm S hS _ _ hab hp).channel x)
        (pmMergeLabels_root S e hab)).trans (ppm_apply_survivor S hS _ _ hab hp x)
    · have hn : pmMergeLabels S e (.inr r) ≠
          activeMergeSurvivor S (e (.inl ())) (e (.inr (.inl ()))) hab := by
        rw [← pmMergeLabels_root S e hab]
        exact (pmMergeLabels S e).injective.ne (by simp)
      exact (ppm_apply_unaffected S hS _ _ hab hp x hn).trans
        (congrArg (S.channel x) (pmMergeLabels_retained S e (.inr r)))

private def pmSwap (R : Type w) : Unit ⊕ (Unit ⊕ R) ≃ Unit ⊕ (Unit ⊕ R) where
  toFun
    | .inl u => .inr (.inl u)
    | .inr (.inl u) => .inl u
    | .inr (.inr r) => .inr (.inr r)
  invFun
    | .inl u => .inr (.inl u)
    | .inr (.inl u) => .inl u
    | .inr (.inr r) => .inr (.inr r)
  left_inv := by rintro (⟨⟩ | ⟨⟩ | r) <;> rfl
  right_inv := by rintro (⟨⟩ | ⟨⟩ | r) <;> rfl

private def pmMerge {R : Type w} (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) (e : Unit ⊕ (Unit ⊕ R) ≃ Fin S.outputCard)
    (hp : ∀ x, S.channel x (e (.inl ())) ≠ 0 ↔ S.channel x (e (.inr (.inl ()))) ≠ 0) :
    LabelledOperationResult .ppm S (Unit ⊕ R)
      (fun x => Sum.elim
        (fun _ => S.channel x (e (.inl ())) + S.channel x (e (.inr (.inl ()))))
        (fun r => S.channel x (e (.inr (.inr r))))) := by
  by_cases hab : e (.inl ()) < e (.inr (.inl ()))
  · exact pmMergeOrdered S hS e hab hp
  · have hba : e (.inr (.inl ())) < e (.inl ()) :=
      lt_of_le_of_ne (le_of_not_gt hab) (fun h => Sum.inr_ne_inl (e.injective h))
    let q := pmMergeOrdered S hS ((pmSwap R).trans e) hba (fun x => (hp x).symm)
    refine ⟨q.endpoint, q.path, q.homogeneous, q.labels, ?_⟩
    intro x j
    rcases j with ⟨⟩ | r
    · exact (q.coordinates x (.inl ())).trans (add_comm _ _)
    · exact q.coordinates x (.inr r)

private theorem pmSumSupport {I : Type v} [Fintype I] [Nonempty I]
    (f : I → ENNReal) (a : ENNReal) (h : ∀ i, f i ≠ 0 ↔ a ≠ 0) :
    (∑ i, f i) ≠ 0 ↔ a ≠ 0 := by
  constructor
  · intro hs ha
    apply hs
    apply Finset.sum_eq_zero
    intro i _
    by_contra hi
    exact (h i).mp hi ha
  · intro ha hs
    obtain ⟨i⟩ := ‹Nonempty I›
    apply (h i).mpr ha
    apply le_antisymm ?_ bot_le
    have hi : f i ≤ ∑ j, f j :=
      Finset.single_le_sum (fun _ _ => bot_le) (Finset.mem_univ i)
    rwa [hs] at hi

private def ppmCoreSpec (I : Type v) [Fintype I] : Prop :=
  Nonempty I → ∀ (R : Type w) (S : ActiveFiniteChannel alpha)
    (_hS : IsSingularChannel S.channel) (e : I ⊕ R ≃ Fin S.outputCard),
    (∀ i j x, S.channel x (e (.inl i)) ≠ 0 ↔ S.channel x (e (.inl j)) ≠ 0) →
      Nonempty (LabelledOperationResult .ppm S (Unit ⊕ R)
        (fun x => Sum.elim (fun _ => ∑ i, S.channel x (e (.inl i)))
          (fun r => S.channel x (e (.inr r)))))

private theorem multiPpmCore_exists (I : Type v) [Fintype I] :
    ppmCoreSpec.{u, v, w} (alpha := alpha) I := by
  refine Fintype.induction_empty_option
    (P := fun I _ => ppmCoreSpec.{u, v, w} (alpha := alpha) I) ?_ ?_ ?_ I
  · intro I J _ eIJ ih hJ R S hS e hp
    let := Fintype.ofEquiv J eIJ.symm
    have hI : Nonempty I := by
      obtain ⟨j⟩ := hJ
      exact ⟨eIJ.symm j⟩
    let eStart := (Equiv.sumCongr eIJ (Equiv.refl R)).trans e
    obtain ⟨d⟩ := ih hI R S hS eStart (fun i j x => hp (eIJ i) (eIJ j) x)
    refine ⟨⟨d.endpoint, d.path, d.homogeneous, d.labels, ?_⟩⟩
    intro x b
    rcases b with ⟨⟩ | r
    · have h := d.coordinates x (.inl ())
      change d.endpoint.channel x (d.labels (.inl ())) =
        ∑ i : I, S.channel x (e (.inl (eIJ i))) at h
      exact h.trans (eIJ.sum_comp (fun j => S.channel x (e (.inl j))))
    · exact d.coordinates x (.inr r)
  · intro hI
    obtain ⟨i⟩ := hI
    exact isEmptyElim i
  · intro I _ ih _ R S hS e hp
    by_cases hI : Nonempty I
    · let := hI
      let eRest := (ppOptionLabels I R).symm.trans e
      obtain ⟨rest⟩ := ih hI (Unit ⊕ R) S hS eRest
        (fun i j x => hp (some i) (some j) x)
      have hroot (x : alpha) : rest.endpoint.channel x (rest.labels (.inl ())) =
          ∑ i : I, S.channel x (e (.inl (some i))) := rest.coordinates x (.inl ())
      have hhead (x : alpha) : rest.endpoint.channel x (rest.labels (.inr (.inl ()))) =
          S.channel x (e (.inl none)) := rest.coordinates x (.inr (.inl ()))
      have hmerge (x : alpha) : rest.endpoint.channel x (rest.labels (.inl ())) ≠ 0 ↔
          rest.endpoint.channel x (rest.labels (.inr (.inl ()))) ≠ 0 := by
        rw [hroot, hhead]
        exact pmSumSupport (fun i : I => S.channel x (e (.inl (some i))))
          (S.channel x (e (.inl none))) (fun i => hp (some i) none x)
      let merged := pmMerge rest.endpoint (rest.isSingular hS) rest.labels hmerge
      refine ⟨⟨merged.endpoint, rest.path.append merged.path,
        (OperationPath.homogeneous_append _ _ _).mpr ⟨rest.homogeneous, merged.homogeneous⟩,
        merged.labels, ?_⟩⟩
      intro x b
      rcases b with ⟨⟩ | r
      · rw [merged.coordinates]
        change rest.endpoint.channel x (rest.labels (.inl ())) +
          rest.endpoint.channel x (rest.labels (.inr (.inl ()))) =
            ∑ i : Option I, S.channel x (e (.inl i))
        rw [hroot, hhead, Fintype.sum_option, add_comm]
      · exact (merged.coordinates x (.inr r)).trans (rest.coordinates x (.inr (.inr r)))
    · let : IsEmpty I := not_nonempty_iff.mp hI
      let labels := (Equiv.sumCongr (Equiv.ofUnique Unit (Option I)) (Equiv.refl R)).trans e
      refine ⟨⟨S, .nil, OperationPath.homogeneous_nil _, labels, ?_⟩⟩
      intro x b
      rcases b with ⟨⟩ | r
      · change S.channel x (e (.inl none)) = ∑ i : Option I, S.channel x (e (.inl i))
        rw [Fintype.sum_option]
        simp
      · rfl

private def multiPpmCore {I : Type v} [Fintype I] [Nonempty I] {R : Type w}
    (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (e : I ⊕ R ≃ Fin S.outputCard)
    (hp : ∀ i j x, S.channel x (e (.inl i)) ≠ 0 ↔ S.channel x (e (.inl j)) ≠ 0) :
    LabelledOperationResult .ppm S (Unit ⊕ R)
      (fun x => Sum.elim (fun _ => ∑ i, S.channel x (e (.inl i)))
        (fun r => S.channel x (e (.inr r)))) :=
  Classical.choice (multiPpmCore_exists.{u, v, w} I inferInstance R S hS e hp)

end
end PerfectFunctionalRepresentations.MatrixOperations



namespace PerfectFunctionalRepresentations.MatrixOperations
open scoped BigOperators ENNReal
noncomputable section
attribute [local instance] Classical.propDecidable
universe u v w z
variable {alpha : Type u} [Finite alpha] [Nonempty alpha]

private def pmFamilySwap (A : Type v) (B : Type w) (R : Type z) : A ⊕ (B ⊕ R) ≃ B ⊕ (A ⊕ R) :=
  (Equiv.sumAssoc A B R).symm.trans
    ((Equiv.sumCongr (Equiv.sumComm A B) (Equiv.refl R)).trans (Equiv.sumAssoc B A R))

private def mwMergeCallbacks (I : Type v) (L : I → Type v)
    (m : I → alpha → ENNReal) (w : ∀ i, L i → alpha → ENNReal) : Prop :=
  ∀ (i : I) (A : Type v) (S : ActiveFiniteChannel alpha) (_hS : IsSingularChannel S.channel)
    (e : L i ⊕ A ≃ Fin S.outputCard),
    (∀ l x, S.channel x (e (.inl l)) = w i l x) →
      Nonempty (LabelledOperationResult .ppm S (Unit ⊕ A)
        (fun x => Sum.elim (fun _ => m i x) (fun a => S.channel x (e (.inr a)))))

private def mwMergeFamilySpec (I : Type v) : Prop :=
  ∀ (L : I → Type v) (m : I → alpha → ENNReal) (w : ∀ i, L i → alpha → ENNReal),
    mwMergeCallbacks I L m w →
    ∀ (R : Type v) (S : ActiveFiniteChannel alpha) (_hS : IsSingularChannel S.channel)
      (e : (Σ i, L i) ⊕ R ≃ Fin S.outputCard),
      (∀ i l x, S.channel x (e (.inl ⟨i, l⟩)) = w i l x) →
        Nonempty (LabelledOperationResult .ppm S (I ⊕ R)
          (fun x => Sum.elim (fun i => m i x) (fun r => S.channel x (e (.inr r)))))

private theorem mwMergeFamily (I : Type v) [Finite I] : mwMergeFamilySpec (alpha := alpha) I := by
  refine Finite.induction_empty_option ?_ ?_ ?_ I
  · intro I J eIJ ih L m w callback R S hS e hroot
    let eLeaves : (Σ i : I, L (eIJ i)) ≃ (Σ j : J, L j) := Equiv.sigmaCongrLeft eIJ
    let eStart := (Equiv.sumCongr eLeaves (Equiv.refl R)).trans e
    obtain ⟨d⟩ := ih (fun i => L (eIJ i)) (fun i => m (eIJ i))
      (fun i => w (eIJ i)) (fun i => callback (eIJ i)) R S hS eStart
      (fun i => hroot (eIJ i))
    refine ⟨⟨d.endpoint, d.path, d.homogeneous,
      (Equiv.sumCongr eIJ.symm (Equiv.refl R)).trans d.labels, ?_⟩⟩
    intro x l
    rcases l with j | r
    · simpa only [Equiv.trans_apply, Equiv.sumCongr_apply, Sum.map_inl,
        Equiv.apply_symm_apply, Sum.elim_inl] using d.coordinates x (.inl (eIJ.symm j))
    · exact d.coordinates x (.inr r)
  · intro L m w callback R S hS e hroot
    let z : PEmpty.{v + 1} ≃ (Σ i : PEmpty.{v + 1}, L i) :=
      { toFun := fun i => PEmpty.elim i
        invFun := fun p => p.1
        left_inv := fun i => PEmpty.elim i
        right_inv := fun p => PEmpty.elim p.1 }
    refine ⟨⟨S, OperationPath.nil, OperationPath.allowed_nil _,
      (Equiv.sumCongr z (Equiv.refl R)).trans e, ?_⟩⟩
    rintro x (i | r)
    · exact PEmpty.elim i
    · rfl
  · intro I _ ih L m w callback R S hS e hroot
    let Tail := (Σ i : I, L (some i))
    let eFirst : L none ⊕ (Tail ⊕ R) ≃ Fin S.outputCard :=
      (pmFamilySwap (L none) Tail R).trans ((mwOptionLeaves I R L).symm.trans e)
    obtain ⟨first⟩ := callback none (Tail ⊕ R) S hS eFirst (hroot none)
    let eRest : Tail ⊕ (Unit ⊕ R) ≃ Fin first.endpoint.outputCard :=
      (pmFamilySwap Tail Unit R).trans first.labels
    have restRoots : ∀ i l x,
        first.endpoint.channel x (eRest (.inl ⟨i, l⟩)) = w (some i) l x := by
      intro i l x
      exact (first.coordinates x (.inr (.inl ⟨i, l⟩))).trans (hroot (some i) l x)
    obtain ⟨rest⟩ := ih (fun i => L (some i)) (fun i => m (some i))
      (fun i => w (some i)) (fun i => callback (some i)) (Unit ⊕ R)
      first.endpoint (first.path.isSingular hS) eRest restRoots
    let eOut : Option I ⊕ R ≃ I ⊕ (Unit ⊕ R) :=
      (mwOptionRoot I R).symm.trans (pmFamilySwap Unit I R)
    refine ⟨⟨rest.endpoint, first.path.append rest.path,
      (OperationPath.homogeneous_append _ _ _).mpr ⟨first.homogeneous, rest.homogeneous⟩,
      eOut.trans rest.labels, ?_⟩⟩
    rintro x ((_ | i) | r)
    · exact (rest.coordinates x (.inr (.inl ()))).trans (first.coordinates x (.inl ()))
    · exact rest.coordinates x (.inl i)
    · exact (rest.coordinates x (.inr (.inr r))).trans (first.coordinates x (.inr (.inr r)))

/-- Merge each prescribed nonempty fiber, retaining its supplied output label. -/
def multiPpmFibers (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    {B : Type v} [Fintype B] (g : Fin S.outputCard → B) (hg : Function.Surjective g)
    (hp : ∀ i j, g i = g j → ∀ x, S.channel x i ≠ 0 ↔ S.channel x j ≠ 0) :
    LabelledOperationResult .ppm S B
      (fun x b => ∑ j, if g j = b then S.channel x j else 0) := by
  classical
  let L : B → Type v := fun b => ULift.{v} {j : Fin S.outputCard // g j = b}
  letI (b : B) : Fintype (L b) := inferInstanceAs (Fintype (ULift {j // g j = b}))
  letI (b : B) : Nonempty (L b) := by
    obtain ⟨j, hj⟩ := hg b
    exact ⟨⟨⟨j, hj⟩⟩⟩
  let eLeaves : (Σ b, L b) ≃ Fin S.outputCard :=
    { toFun := fun p => p.2.down.val
      invFun := fun j => ⟨g j, ⟨⟨j, rfl⟩⟩⟩
      left_inv := by rintro ⟨b, ⟨⟨j, hj⟩⟩⟩; dsimp; subst b; rfl
      right_inv := fun _ => rfl }
  let eRoot := (Equiv.sumEmpty (Σ b, L b) PEmpty.{v + 1}).trans eLeaves
  let m : B → alpha → ENNReal := fun b x => ∑ j, if g j = b then S.channel x j else 0
  let w : ∀ b, L b → alpha → ENNReal := fun _ i x => S.channel x i.down.val
  have hsum (b : B) (x : alpha) : ∑ i : L b, w b i x = m b x := by
    dsimp only [m, w, L]
    calc
      _ = ∑ i : {j : Fin S.outputCard // g j = b}, S.channel x i.val :=
        Equiv.ulift.sum_comp _
      _ = ∑ j ∈ Finset.univ.filter (fun j => g j = b), S.channel x j :=
        (Finset.sum_subtype _ (by simp) _).symm
      _ = _ := Finset.sum_filter _ _
  have callback : mwMergeCallbacks B L m w := by
    intro b R A hA e hroot
    let d := multiPpmCore A hA e (fun i j x => by
      rw [hroot i x, hroot j x]
      exact hp i.down.val j.down.val (i.down.property.trans j.down.property.symm) x)
    refine ⟨⟨d.endpoint, d.path, d.homogeneous, d.labels, ?_⟩⟩
    rintro x (⟨⟩ | r)
    · exact (d.coordinates x (.inl ())).trans
        ((Finset.sum_congr rfl (fun i _ => hroot i x)).trans (hsum b x))
    · exact d.coordinates x (.inr r)
  let d := Classical.choice (mwMergeFamily B L m w callback PEmpty S hS eRoot
    (fun _ _ _ => rfl))
  refine ⟨d.endpoint, d.path, d.homogeneous,
    (Equiv.sumEmpty B PEmpty).symm.trans d.labels, ?_⟩
  intro x b
  exact d.coordinates x (.inl b)

end
end PerfectFunctionalRepresentations.MatrixOperations

namespace PerfectFunctionalRepresentations.MatrixOperations

open scoped BigOperators ENNReal
noncomputable section
attribute [local instance] Classical.propDecidable
universe u v w
variable {alpha : Type u} [Finite alpha] [Nonempty alpha]

/-- Merge a supplied nonempty equal-support selection, retaining every other label. -/
def multiPpm (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (F : Finset (Fin S.outputCard)) (hF : F.Nonempty)
    (hp : ∀ i ∈ F, ∀ j ∈ F, ∀ x, S.channel x i ≠ 0 ↔ S.channel x j ≠ 0) :
    LabelledOperationResult .ppm S (Unit ⊕ {j : Fin S.outputCard // j ∉ F})
      (fun x => Sum.elim (fun _ => ∑ j ∈ F, S.channel x j)
        (fun j => S.channel x j.val)) := by
  let : Nonempty F := by obtain ⟨i, hi⟩ := hF; exact ⟨⟨i, hi⟩⟩
  let d := multiPpmCore S hS (Equiv.sumCompl (· ∈ F))
    (fun i j x => hp i.val i.property j.val j.property x)
  refine ⟨d.endpoint, d.path, d.homogeneous, d.labels, ?_⟩
  intro x b
  rcases b with ⟨⟩ | j
  · exact (d.coordinates x (.inl ())).trans (Finset.sum_coe_sort F (fun j => S.channel x j))
  · exact d.coordinates x (.inr j)

/-- Empty selection keeps the original state and labels with a nil path. -/
def multiPpmOrEmpty (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    (F : Finset (Fin S.outputCard))
    (hp : ∀ i ∈ F, ∀ j ∈ F, ∀ x, S.channel x i ≠ 0 ↔ S.channel x j ≠ 0) :
    if F.Nonempty then
      LabelledOperationResult .ppm S (Unit ⊕ {j : Fin S.outputCard // j ∉ F})
        (fun x => Sum.elim (fun _ => ∑ j ∈ F, S.channel x j)
          (fun j => S.channel x j.val))
    else LabelledOperationResult .ppm S (Fin S.outputCard) (fun x j => S.channel x j) := by
  split_ifs with hF
  · exact multiPpm S hS F hF hp
  · exact ⟨S, .nil, OperationPath.homogeneous_nil _, Equiv.refl _, fun _ _ => rfl⟩

section PpmSelectedSpecifications
attribute [local instance] operationQuiver

private theorem ppm_outputCard_decrease {S T : ActiveFiniteChannel alpha}
    (p : OperationPath S T) (hp : p.Homogeneous .ppm) :
    T.outputCard + p.length = S.outputCard := by
  induction p with
  | nil => rfl
  | @cons T U p e ih =>
      have h := (OperationPath.allowed_snoc _ p e).mp hp
      cases e with
      | pps hT l t ht0 ht1 => simp [OperationStep.kind] at h
      | vps hT l mask hl hr => simp [OperationStep.kind] at h
      | ppm hT a b hab hs =>
          change T.outputCard - 1 + (p.length + 1) = S.outputCard
          calc
            T.outputCard - 1 + (p.length + 1) = (T.outputCard - 1 + 1) + p.length := by omega
            _ = T.outputCard + p.length := by
              rw [Nat.sub_add_cancel (Nat.succ_le_of_lt T.outputCard_pos)]
            _ = S.outputCard := ih h.1
      | vpm hT a b hab hv hd => simp [OperationStep.kind] at h

variable (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
  (F : Finset (Fin S.outputCard)) (hF : F.Nonempty)
  (hp : ∀ i ∈ F, ∀ j ∈ F, ∀ x, S.channel x i ≠ 0 ↔ S.channel x j ≠ 0)

theorem multiPpm_outputCard :
    (multiPpm S hS F hF hp).endpoint.outputCard = S.outputCard - F.card + 1 := by
  have hc := Fintype.card_congr (multiPpm S hS F hF hp).labels
  simpa only [Fintype.card_sum, Fintype.card_unique, Fintype.card_fin,
    Fintype.card_subtype_compl, Fintype.card_coe, Nat.add_comm] using hc.symm

theorem multiPpm_length :
    (multiPpm S hS F hF hp).path.length = F.card - 1 := by
  have hg := ppm_outputCard_decrease (multiPpm S hS F hF hp).path
    (multiPpm S hS F hF hp).homogeneous
  have hc := multiPpm_outputCard S hS F hF hp
  have hf : F.card ≤ S.outputCard := by
    simpa only [Finset.card_univ, Fintype.card_fin] using
      Finset.card_le_card (Finset.subset_univ F)
  omega

theorem multiPpm_length_singleton [Subsingleton F] :
    (multiPpm S hS F hF hp).path.length = 0 := by
  rw [multiPpm_length]
  have hc : Fintype.card F ≤ 1 := Fintype.card_le_one_iff_subsingleton.mpr inferInstance
  simpa only [Fintype.card_coe] using Nat.sub_eq_zero_of_le hc

omit hS in
private theorem pmSelectedSumSupport (S : ActiveFiniteChannel alpha)
    (F : Finset (Fin S.outputCard)) (hF : F.Nonempty)
    (hp : ∀ i ∈ F, ∀ j ∈ F, ∀ x, S.channel x i ≠ 0 ↔ S.channel x j ≠ 0)
    (i : Fin S.outputCard) (hi : i ∈ F) (x : alpha) :
    (∑ j ∈ F, S.channel x j) ≠ 0 ↔ S.channel x i ≠ 0 := by
  let : Nonempty F := by obtain ⟨i, hi⟩ := hF; exact ⟨⟨i, hi⟩⟩
  have h := pmSumSupport (fun j : F => S.channel x j.val) (S.channel x i)
    (fun j => hp j.val j.property i hi x)
  simpa only [Finset.sum_coe_sort] using h

theorem multiPpm_columnValue :
    columnValue (multiPpm S hS F hF hp).endpoint.channel
      ((multiPpm S hS F hF hp).path.isSingular hS)
      ((multiPpm S hS F hF hp).endpoint.activeEquiv ((multiPpm S hS F hF hp).labels (.inl ()))) =
        ∑ j ∈ F, columnValue S.channel hS (S.activeEquiv j) := by
  let d := multiPpm S hS F hF hp
  obtain ⟨i, hi⟩ := hF
  obtain ⟨x, hx⟩ := S.output_active i
  have hchild : d.endpoint.channel x (d.labels (.inl ())) ≠ 0 := by
    rw [d.coordinates]
    exact (pmSelectedSumSupport S F ⟨i, hi⟩ hp i hi x).mpr hx
  rw [columnValue_eq_of_ne_zero _ _ _ hchild]
  refine (d.coordinates x (.inl ())).trans ?_
  apply Finset.sum_congr rfl
  intro j hj
  exact (columnValue_eq_of_ne_zero S.channel hS (S.activeEquiv j)
    ((hp i hi j hj x).mp hx)).symm

theorem multiPpm_columnValue_keep (j : {j : Fin S.outputCard // j ∉ F}) :
    columnValue (multiPpm S hS F hF hp).endpoint.channel
      ((multiPpm S hS F hF hp).path.isSingular hS)
      ((multiPpm S hS F hF hp).endpoint.activeEquiv ((multiPpm S hS F hF hp).labels (.inr j))) =
        columnValue S.channel hS (S.activeEquiv j.val) := by
  let d := multiPpm S hS F hF hp
  apply columnValue_transport S.channel d.endpoint.channel hS
    (d.path.isSingular hS) (S.activeEquiv j.val)
    (d.endpoint.activeEquiv (d.labels (.inr j))) (Equiv.refl alpha)
  intro x
  exact d.coordinates x (.inr j)

variable [Fintype alpha]

theorem multiPpm_columnPattern (i : Fin S.outputCard) (hi : i ∈ F) :
    columnPattern (multiPpm S hS F hF hp).endpoint.channel
      ((multiPpm S hS F hF hp).endpoint.activeEquiv ((multiPpm S hS F hF hp).labels (.inl ()))) =
        columnPattern S.channel (S.activeEquiv i) := by
  let d := multiPpm S hS F hF hp
  apply Subtype.ext
  ext x
  simp only [mem_columnPattern]
  change d.endpoint.channel x (d.labels (.inl ())) ≠ 0 ↔ S.channel x i ≠ 0
  rw [d.coordinates]
  exact pmSelectedSumSupport S F hF hp i hi x

theorem multiPpm_columnPattern_keep (j : {j : Fin S.outputCard // j ∉ F}) :
    columnPattern (multiPpm S hS F hF hp).endpoint.channel
      ((multiPpm S hS F hF hp).endpoint.activeEquiv ((multiPpm S hS F hF hp).labels (.inr j))) =
        columnPattern S.channel (S.activeEquiv j.val) := by
  let d := multiPpm S hS F hF hp
  apply Subtype.ext
  ext x
  simp only [mem_columnPattern]
  change d.endpoint.channel x (d.labels (.inr j)) ≠ 0 ↔ S.channel x j.val ≠ 0
  rw [d.coordinates]
  rfl

end PpmSelectedSpecifications

private theorem pmFiberSupport (S : ActiveFiniteChannel alpha) {B : Type v}
    (g : Fin S.outputCard → B)
    (hp : ∀ i j, g i = g j → ∀ x, S.channel x i ≠ 0 ↔ S.channel x j ≠ 0)
    (j : Fin S.outputCard) (x : alpha) :
    (∑ i, if g i = g j then S.channel x i else 0) ≠ 0 ↔ S.channel x j ≠ 0 := by
  constructor
  · intro hs hj
    apply hs
    apply Finset.sum_eq_zero
    intro i _
    split_ifs with hi
    · by_contra hne
      exact (hp i j hi x).mp hne hj
    · rfl
  · intro hj hs
    have hh : S.channel x j ≤ ∑ i, if g i = g j then S.channel x i else 0 := by
      simpa using Finset.single_le_sum (f := fun i => if g i = g j then S.channel x i else 0)
        (fun _ _ => bot_le) (Finset.mem_univ j)
    exact hj (le_antisymm (hs ▸ hh) bot_le)

theorem multiPpmFibers_columnValue (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) {B : Type v} [Fintype B]
    (g : Fin S.outputCard → B) (hg : Function.Surjective g)
    (hp : ∀ i j, g i = g j → ∀ x, S.channel x i ≠ 0 ↔ S.channel x j ≠ 0) (b : B) :
    columnValue (multiPpmFibers S hS g hg hp).endpoint.channel
      ((multiPpmFibers S hS g hg hp).isSingular hS)
      ((multiPpmFibers S hS g hg hp).endpoint.activeEquiv
        ((multiPpmFibers S hS g hg hp).labels b)) =
        ∑ j, if g j = b then columnValue S.channel hS (S.activeEquiv j) else 0 := by
  let d := multiPpmFibers S hS g hg hp
  obtain ⟨j, rfl⟩ := hg b
  obtain ⟨x, hx⟩ := S.output_active j
  have hd : d.endpoint.channel x (d.labels (g j)) ≠ 0 := by
    rw [d.coordinates]
    exact (pmFiberSupport S g hp j x).mpr hx
  rw [columnValue_eq_of_ne_zero _ _ _ hd]
  change d.endpoint.channel x (d.labels (g j)) = _
  rw [d.coordinates]
  apply Finset.sum_congr rfl
  intro i _
  split_ifs with hi
  · exact (columnValue_eq_of_ne_zero S.channel hS (S.activeEquiv i)
      ((hp i j hi x).mpr hx)).symm
  · rfl

theorem multiPpmFibers_columnPattern [Fintype alpha] (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) {B : Type v} [Fintype B]
    (g : Fin S.outputCard → B) (hg : Function.Surjective g)
    (hp : ∀ i j, g i = g j → ∀ x, S.channel x i ≠ 0 ↔ S.channel x j ≠ 0)
    (j : Fin S.outputCard) :
    columnPattern (multiPpmFibers S hS g hg hp).endpoint.channel
      ((multiPpmFibers S hS g hg hp).endpoint.activeEquiv
        ((multiPpmFibers S hS g hg hp).labels (g j))) =
        columnPattern S.channel (S.activeEquiv j) := by
  apply Subtype.ext
  ext x
  simp only [mem_columnPattern]
  change (multiPpmFibers S hS g hg hp).endpoint.channel x
    ((multiPpmFibers S hS g hg hp).labels (g j)) ≠ 0 ↔ S.channel x j ≠ 0
  rw [(multiPpmFibers S hS g hg hp).coordinates]
  exact pmFiberSupport S g hp j x

/-- Merge the nonempty fibers in the actual range, allowing arbitrary ambient labels. -/
def multiPpmRange (S : ActiveFiniteChannel alpha) (hS : IsSingularChannel S.channel)
    {B : Type v} (g : Fin S.outputCard → B)
    (hp : ∀ i j, g i = g j → ∀ x, S.channel x i ≠ 0 ↔ S.channel x j ≠ 0) :
    LabelledOperationResult .ppm S (Set.range g)
      (fun x b => ∑ j, if g j = b.val then S.channel x j else 0) := by
  classical
  let d := multiPpmFibers S hS (Set.rangeFactorization g) Set.rangeFactorization_surjective
    (fun i j h => hp i j (congrArg Subtype.val h))
  refine ⟨d.endpoint, d.path, d.homogeneous, d.labels, ?_⟩
  rintro x ⟨b, hb⟩
  simpa only [Set.rangeFactorization, Subtype.mk.injEq] using d.coordinates x ⟨b, hb⟩

/-- Include the generated outputs in the ambient label type; unused labels have zero mass. -/
theorem multiPpmRange_map (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) {B : Type v}
    (g : Fin S.outputCard → B)
    (hp : ∀ i j, g i = g j → ∀ x, S.channel x i ≠ 0 ↔ S.channel x j ≠ 0)
    (x : alpha) (b : B) :
    ((multiPpmRange S hS g hp).endpoint.channel x).map
      (fun j => ((multiPpmRange S hS g hp).labels.symm j).val) b =
        ∑ j, if g j = b then S.channel x j else 0 := by
  let d := multiPpmRange S hS g hp
  change (d.endpoint.channel x).map (fun j => (d.labels.symm j).val) b = _
  by_cases hb : b ∈ Set.range g
  · let t : Set.range g := ⟨b, hb⟩
    have hinj : Function.Injective (fun j => (d.labels.symm j).val) :=
      Subtype.val_injective.comp d.labels.symm.injective
    have h := PMF.map_apply_of_injective (d.endpoint.channel x) hinj (d.labels t)
    simpa only [Equiv.symm_apply_apply] using h.trans (d.coordinates x t)
  · have hout : b ∉ Set.range (fun j => (d.labels.symm j).val) := by
      rintro ⟨j, rfl⟩
      exact hb (d.labels.symm j).property
    rw [PMF.map_apply_eq_zero_of_notMem_range _ hout]
    symm
    apply Finset.sum_eq_zero
    intro j _
    exact if_neg (fun he => hb ⟨j, he⟩)


/-- The chosen prescribed-fiber path uses one fewer merge than each fiber size. -/
theorem multiPpmFibers_length (S : ActiveFiniteChannel alpha)
    (hS : IsSingularChannel S.channel) {B : Type v} [Fintype B]
    (g : Fin S.outputCard → B) (hg : Function.Surjective g)
    (hp : ∀ i j, g i = g j → ∀ x, S.channel x i ≠ 0 ↔ S.channel x j ≠ 0) :
    (multiPpmFibers S hS g hg hp).path.length = S.outputCard - Fintype.card B := by
  have hd := ppm_outputCard_decrease (multiPpmFibers S hS g hg hp).path
    (multiPpmFibers S hS g hg hp).homogeneous
  have hc := (multiPpmFibers S hS g hg hp).outputCard
  omega

end
end PerfectFunctionalRepresentations.MatrixOperations


