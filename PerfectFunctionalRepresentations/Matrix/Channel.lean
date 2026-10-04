import LeanInfoTheory.Probability.Finite
import Mathlib.LinearAlgebra.Matrix.Defs
import Mathlib.SetTheory.Cardinal.NatCard
import PerfectFunctionalRepresentations.Semantics.Singularity

/-!
# Exact and real channel coordinates

The matrix paragraph opening ISIT Section III-A (also extended version 16,
Section III-A) puts inputs in rows and outputs in columns. The semantic object
remains a channel `alpha → PMF beta`; this module supplies its proved coordinates.

Raw coordinates allow arbitrary alphabets, including empty inputs and unused
output labels. Only reconstruction and finite row sums need a finite output
enumeration. No prior, input-finiteness or nonempty-input hypothesis is imposed
at this raw boundary. Active finite states restrict and enumerate these channels,
with explicit recovery and relabeling laws. Definition 4 column data is a later
contract; no value or pattern is assigned to zero columns here.

The real view is derived from finite PMF masses. Real matrix reconstruction
requires nonnegative entries and normalized finite rows. Column singularity
means equality of nonzero entries within each column, not determinant or rank
singularity; its zero-column case is vacuous.
-/

namespace PerfectFunctionalRepresentations

open scoped BigOperators ENNReal

universe u v

variable {alpha : Type u} {beta : Type v}

/-- Exact masses of a semantic channel, with input rows and output columns. -/
def massMatrix (kappa : alpha → PMF beta) : Matrix alpha beta ℝ≥0∞ :=
  Matrix.of fun x y => kappa x y

@[simp]
theorem massMatrix_apply (kappa : alpha → PMF beta) (x : alpha) (y : beta) :
    massMatrix kappa x y = kappa x y := rfl

/-- Each exact coordinate is at most one, without a finiteness assumption. -/
theorem massMatrix_le_one (kappa : alpha → PMF beta) (x : alpha) (y : beta) :
    massMatrix kappa x y ≤ 1 :=
  (kappa x).coe_le_one y

/-- Exact coordinates are finite, even when the output alphabet is infinite. -/
theorem massMatrix_ne_top (kappa : alpha → PMF beta) (x : alpha) (y : beta) :
    massMatrix kappa x y ≠ ∞ :=
  (kappa x).apply_ne_top y

/-- Finite output rows are normalized; columns need not sum to one. -/
@[simp]
theorem massMatrix_row_sum [Fintype beta] (kappa : alpha → PMF beta) (x : alpha) :
    ∑ y, massMatrix kappa x y = 1 := by
  simpa using (kappa x).tsum_coe

/-- The exact coordinates determine the semantic channel. -/
theorem massMatrix_injective : Function.Injective (massMatrix (alpha := alpha) (beta := beta)) := by
  intro kappa eta h
  funext x
  apply PMF.ext
  intro y
  exact congrFun (congrFun h x) y

/-- Construct semantic PMF rows from a normalized exact rectangular matrix.
Entry bounds and finiteness follow from the resulting PMFs; they are not extra
premises. No normalization is performed on the supplied entries. -/
def channelOfMassMatrix [Fintype beta] (M : Matrix alpha beta ℝ≥0∞)
    (h : ∀ x, ∑ y, M x y = 1) : alpha → PMF beta :=
  fun x => PMF.ofFintype (M x) (h x)

@[simp]
theorem channelOfMassMatrix_apply [Fintype beta] (M : Matrix alpha beta ℝ≥0∞)
    (h : ∀ x, ∑ y, M x y = 1) (x : alpha) (y : beta) :
    channelOfMassMatrix M h x y = M x y := rfl

/-- Reconstructing normalized rows preserves every original matrix entry. -/
@[simp]
theorem massMatrix_channelOfMassMatrix [Fintype beta] (M : Matrix alpha beta ℝ≥0∞)
    (h : ∀ x, ∑ y, M x y = 1) :
    massMatrix (channelOfMassMatrix M h) = M := rfl

/-- Taking exact coordinates and reconstructing returns the original channel. -/
@[simp]
theorem channelOfMassMatrix_massMatrix [Fintype beta] (kappa : alpha → PMF beta) :
    channelOfMassMatrix (massMatrix kappa) (massMatrix_row_sum kappa) = kappa := by
  apply massMatrix_injective
  exact massMatrix_channelOfMassMatrix _ _

/-! ## Derived real coordinates and two-sided reconstruction -/

/-- Real masses of a semantic channel, with the same input-row/output-column orientation. -/
noncomputable def realMatrix (kappa : alpha → PMF beta) : Matrix alpha beta ℝ :=
  Matrix.of fun x y => (kappa x y).toReal

@[simp]
theorem realMatrix_apply (kappa : alpha → PMF beta) (x : alpha) (y : beta) :
    realMatrix kappa x y = (kappa x y).toReal := rfl

theorem realMatrix_nonneg (kappa : alpha → PMF beta) (x : alpha) (y : beta) :
    0 ≤ realMatrix kappa x y := (kappa x).toReal_nonneg y

theorem realMatrix_le_one (kappa : alpha → PMF beta) (x : alpha) (y : beta) :
    realMatrix kappa x y ≤ 1 := (kappa x).toReal_le_one y

@[simp]
theorem realMatrix_row_sum [Fintype beta] (kappa : alpha → PMF beta) (x : alpha) :
    ∑ y, realMatrix kappa x y = 1 := (kappa x).sum_toReal

/-- PMF finiteness makes conversion back to exact coordinates lossless. -/
@[simp]
theorem ofReal_realMatrix (kappa : alpha → PMF beta) (x : alpha) (y : beta) :
    ENNReal.ofReal (realMatrix kappa x y) = massMatrix kappa x y :=
  ENNReal.ofReal_toReal ((kappa x).apply_ne_top y)

/-- Zero reflection uses finite PMF masses; it is false for arbitrary ENNReal entries. -/
@[simp]
theorem realMatrix_ne_zero_iff (kappa : alpha → PMF beta) (x : alpha) (y : beta) :
    realMatrix kappa x y ≠ 0 ↔ kappa x y ≠ 0 := by
  constructor
  · intro h
    exact (ENNReal.toReal_ne_zero.1 h).1
  · intro h
    exact ENNReal.toReal_ne_zero.2 ⟨h, (kappa x).apply_ne_top y⟩

theorem realMatrix_pos_iff (kappa : alpha → PMF beta) (x : alpha) (y : beta) :
    0 < realMatrix kappa x y ↔ kappa x y ≠ 0 := by
  constructor
  · intro h
    exact (realMatrix_ne_zero_iff _ _ _).1 (ne_of_gt h)
  · intro h
    exact ENNReal.toReal_pos h ((kappa x).apply_ne_top y)

/-- Real coordinates determine the semantic channel, without finite alphabet assumptions. -/
theorem realMatrix_injective : Function.Injective (realMatrix (alpha := alpha) (beta := beta)) := by
  intro kappa eta h
  apply massMatrix_injective
  funext x y
  rw [← ofReal_realMatrix, ← ofReal_realMatrix]
  exact congrArg ENNReal.ofReal (congrFun (congrFun h x) y)

/-- Construct PMF rows from a nonnegative Real matrix whose finite rows sum to one.
No clipping or rescaling changes its coordinates under these premises. -/
noncomputable def channelOfRealMatrix [Fintype beta] (A : Matrix alpha beta ℝ)
    (hn : ∀ x y, 0 ≤ A x y) (hs : ∀ x, ∑ y, A x y = 1) : alpha → PMF beta :=
  channelOfMassMatrix (fun x y => ENNReal.ofReal (A x y)) (fun x => by
    rw [← ENNReal.ofReal_sum_of_nonneg (fun y _ => hn x y), hs x, ENNReal.ofReal_one])

@[simp]
theorem channelOfRealMatrix_apply [Fintype beta] (A : Matrix alpha beta ℝ)
    (hn : ∀ x y, 0 ≤ A x y) (hs : ∀ x, ∑ y, A x y = 1) (x : alpha) (y : beta) :
    channelOfRealMatrix A hn hs x y = ENNReal.ofReal (A x y) := rfl

/-- Reconstructing a nonnegative normalized Real matrix preserves every entry. -/
@[simp]
theorem realMatrix_channelOfRealMatrix [Fintype beta] (A : Matrix alpha beta ℝ)
    (hn : ∀ x y, 0 ≤ A x y) (hs : ∀ x, ∑ y, A x y = 1) :
    realMatrix (channelOfRealMatrix A hn hs) = A := by
  funext x y
  exact ENNReal.toReal_ofReal (hn x y)

/-- Taking Real coordinates and reconstructing returns the original semantic channel. -/
@[simp]
theorem channelOfRealMatrix_realMatrix [Fintype beta] (kappa : alpha → PMF beta) :
    channelOfRealMatrix (realMatrix kappa) (realMatrix_nonneg kappa)
      (realMatrix_row_sum kappa) = kappa := by
  apply realMatrix_injective
  exact realMatrix_channelOfRealMatrix _ _ _

/-! ## Column singularity in the two numeric views -/

/-- All nonzero entries within each column agree. This is unrelated to a
determinant or rank, and a zero column imposes no condition. -/
def HasSingularColumns {R : Type*} [Zero R] (M : Matrix alpha beta R) : Prop :=
  ∀ x1 x2 y, M x1 y ≠ 0 → M x2 y ≠ 0 → M x1 y = M x2 y

theorem hasSingularColumns_massMatrix_iff (kappa : alpha → PMF beta) :
    HasSingularColumns (massMatrix kappa) ↔ IsSingularChannel kappa := Iff.rfl

theorem hasSingularColumns_realMatrix_iff (kappa : alpha → PMF beta) :
    HasSingularColumns (realMatrix kappa) ↔ IsSingularChannel kappa := by
  constructor
  · intro h x1 x2 y h1 h2
    have heq := h x1 x2 y ((realMatrix_ne_zero_iff _ _ _).2 h1)
      ((realMatrix_ne_zero_iff _ _ _).2 h2)
    exact (ENNReal.toReal_eq_toReal_iff' ((kappa x1).apply_ne_top y)
      ((kappa x2).apply_ne_top y)).1 heq
  · intro h x1 x2 y h1 h2
    exact congrArg ENNReal.toReal
      (h x1 x2 y ((realMatrix_ne_zero_iff _ _ _).1 h1)
        ((realMatrix_ne_zero_iff _ _ _).1 h2))

theorem hasSingularColumns_massMatrix_iff_pos (kappa : alpha → PMF beta) :
    HasSingularColumns (massMatrix kappa) ↔
      ∀ x1 x2 y, 0 < massMatrix kappa x1 y → 0 < massMatrix kappa x2 y →
        massMatrix kappa x1 y = massMatrix kappa x2 y := by
  simp only [HasSingularColumns, pos_iff_ne_zero]

/-- Definition 3's positive-product formulation in exact matrix coordinates. -/
theorem hasSingularColumns_massMatrix_iff_mul_pos (kappa : alpha → PMF beta) :
    HasSingularColumns (massMatrix kappa) ↔
      ∀ x1 x2 y, 0 < massMatrix kappa x1 y * massMatrix kappa x2 y →
        massMatrix kappa x1 y = massMatrix kappa x2 y :=
  isSingularChannel_iff_mul_pos kappa

theorem hasSingularColumns_realMatrix_iff_pos (kappa : alpha → PMF beta) :
    HasSingularColumns (realMatrix kappa) ↔
      ∀ x1 x2 y, 0 < realMatrix kappa x1 y → 0 < realMatrix kappa x2 y →
        realMatrix kappa x1 y = realMatrix kappa x2 y := by
  simp only [HasSingularColumns, realMatrix_pos_iff, realMatrix_ne_zero_iff]

/-- Positive products characterize column singularity for these nonnegative coordinates.
No such equivalence is asserted for arbitrary signed Real matrices. -/
theorem hasSingularColumns_realMatrix_iff_mul_pos (kappa : alpha → PMF beta) :
    HasSingularColumns (realMatrix kappa) ↔
      ∀ x1 x2 y, 0 < realMatrix kappa x1 y * realMatrix kappa x2 y →
        realMatrix kappa x1 y = realMatrix kappa x2 y := by
  rw [hasSingularColumns_realMatrix_iff_pos]
  constructor
  · intro h x1 x2 y hp
    exact h x1 x2 y ((realMatrix_pos_iff _ _ _).2
      ((realMatrix_ne_zero_iff _ _ _).1 (left_ne_zero_of_mul (ne_of_gt hp))))
      ((realMatrix_pos_iff _ _ _).2
        ((realMatrix_ne_zero_iff _ _ _).1 (right_ne_zero_of_mul (ne_of_gt hp))))
  · intro h x1 x2 y h1 h2
    exact h x1 x2 y (mul_pos h1 h2)

/-! ## Explicit changes of input and output labels -/

universe u' v' u'' v''

/-- Change input labels contravariantly and output labels covariantly. -/
noncomputable def relabelChannel {alpha' : Type u'} {beta' : Type v'}
    (kappa : alpha → PMF beta) (eX : alpha ≃ alpha') (eY : beta ≃ beta') :
    alpha' → PMF beta' := fun x => (kappa (eX.symm x)).map eY

@[simp]
theorem relabelChannel_apply {alpha' : Type u'} {beta' : Type v'}
    (kappa : alpha → PMF beta) (eX : alpha ≃ alpha') (eY : beta ≃ beta')
    (x : alpha) (y : beta) : relabelChannel kappa eX eY (eX x) (eY y) = kappa x y := by
  simp only [relabelChannel, eX.symm_apply_apply, PMF.map_apply_equiv]

theorem massMatrix_relabelChannel {alpha' : Type u'} {beta' : Type v'}
    (kappa : alpha → PMF beta) (eX : alpha ≃ alpha') (eY : beta ≃ beta') :
    massMatrix (relabelChannel kappa eX eY) = Matrix.reindex eX eY (massMatrix kappa) := by
  funext x y
  change (kappa (eX.symm x)).map eY y = kappa (eX.symm x) (eY.symm y)
  simpa only [eY.apply_symm_apply] using
    PMF.map_apply_equiv (kappa (eX.symm x)) eY (eY.symm y)

theorem realMatrix_relabelChannel {alpha' : Type u'} {beta' : Type v'}
    (kappa : alpha → PMF beta) (eX : alpha ≃ alpha') (eY : beta ≃ beta') :
    realMatrix (relabelChannel kappa eX eY) = Matrix.reindex eX eY (realMatrix kappa) := by
  funext x y
  exact congrArg ENNReal.toReal (congrFun (congrFun (massMatrix_relabelChannel kappa eX eY) x) y)

@[simp]
theorem relabelChannel_refl (kappa : alpha → PMF beta) :
    relabelChannel kappa (Equiv.refl _) (Equiv.refl _) = kappa := by
  funext x
  exact PMF.map_id _

theorem relabelChannel_trans {alpha' : Type u'} {beta' : Type v'}
    {alpha'' : Type u''} {beta'' : Type v''}
    (kappa : alpha → PMF beta) (eX : alpha ≃ alpha') (eY : beta ≃ beta')
    (fX : alpha' ≃ alpha'') (fY : beta' ≃ beta'') :
    relabelChannel (relabelChannel kappa eX eY) fX fY =
      relabelChannel kappa (eX.trans fX) (eY.trans fY) := by
  funext x
  change ((kappa (eX.symm (fX.symm x))).map eY).map fY = _
  rw [PMF.map_comp]
  rfl

@[simp]
theorem relabelChannel_symm {alpha' : Type u'} {beta' : Type v'}
    (kappa : alpha → PMF beta) (eX : alpha ≃ alpha') (eY : beta ≃ beta') :
    relabelChannel (relabelChannel kappa eX eY) eX.symm eY.symm = kappa := by
  rw [relabelChannel_trans]
  simp

theorem isSingularChannel_relabelChannel_iff {alpha' : Type u'} {beta' : Type v'}
    [Finite alpha] [Finite alpha'] [Finite beta] [Finite beta']
    (kappa : alpha → PMF beta) (eX : alpha ≃ alpha') (eY : beta ≃ beta') :
    IsSingularChannel (relabelChannel kappa eX eY) ↔ IsSingularChannel kappa :=
  isSingularChannel_relabel_iff kappa eX eY

theorem isPerfectlyRepresentableChannel_relabelChannel_iff
    {alpha' : Type u'} {beta' : Type v'}
    [Finite alpha] [Finite alpha'] [Finite beta] [Finite beta'] [Nonempty alpha]
    (kappa : alpha → PMF beta) (eX : alpha ≃ alpha') (eY : beta ≃ beta') :
    let : Nonempty alpha' := Nonempty.map eX ‹Nonempty alpha›
    IsPerfectlyRepresentableChannel (relabelChannel kappa eX eY) ↔
      IsPerfectlyRepresentableChannel kappa :=
  isPerfectlyRepresentableChannel_relabel_iff kappa eX eY

/-- Image coordinates survive an injective output extension exactly. -/
theorem massMatrix_map {gamma : Type v'} (kappa : alpha → PMF beta)
    (j : beta → gamma) (hj : Function.Injective j) (x : alpha) (y : beta) :
    massMatrix (fun x => (kappa x).map j) x (j y) = massMatrix kappa x y :=
  PMF.map_apply_of_injective _ hj y

theorem realMatrix_map {gamma : Type v'} (kappa : alpha → PMF beta)
    (j : beta → gamma) (hj : Function.Injective j) (x : alpha) (y : beta) :
    realMatrix (fun x => (kappa x).map j) x (j y) = realMatrix kappa x y :=
  congrArg ENNReal.toReal (massMatrix_map kappa j hj x y)

/-- An unused ambient label has zero coordinates; it receives no column data. -/
theorem massMatrix_map_eq_zero {gamma : Type v'} (kappa : alpha → PMF beta)
    (j : beta → gamma) (x : alpha) (y : gamma) (hy : y ∉ Set.range j) :
    massMatrix (fun x => (kappa x).map j) x y = 0 :=
  PMF.map_apply_eq_zero_of_notMem_range _ hy

theorem realMatrix_map_eq_zero {gamma : Type v'} (kappa : alpha → PMF beta)
    (j : beta → gamma) (x : alpha) (y : gamma) (hy : y ∉ Set.range j) :
    realMatrix (fun x => (kappa x).map j) x y = 0 := by
  change ((kappa x).map j y).toReal = 0
  rw [show (kappa x).map j y = 0 from massMatrix_map_eq_zero kappa j x y hy]
  rfl

/-! ## Finite active states and explicit presentations -/

private theorem activeOutputs_map_eq {gamma : Type v'} (kappa : alpha → PMF beta)
    (j : beta → gamma) :
    activeOutputs (fun x => (kappa x).map j) = j '' activeOutputs kappa := by
  ext z
  constructor
  · rintro ⟨x, hx⟩
    obtain ⟨y, hy, rfl⟩ := (PMF.mem_support_map_iff _ _ _).1 hx
    exact ⟨y, ⟨x, hy⟩, rfl⟩
  · rintro ⟨y, ⟨x, hx⟩, rfl⟩
    exact ⟨x, (PMF.mem_support_map_iff _ _ _).2 ⟨y, hx, rfl⟩⟩

/-- An injective ambient extension induces an equivalence of the active labels. -/
noncomputable def activeOutputsMapEquiv {gamma : Type v'} (kappa : alpha → PMF beta)
    (j : beta → gamma) (hj : Function.Injective j) :
    activeOutputs kappa ≃ activeOutputs (fun x => (kappa x).map j) :=
  (Equiv.Set.image j (activeOutputs kappa) hj).trans
    (Equiv.setCongr (activeOutputs_map_eq kappa j).symm)

@[simp]
theorem activeOutputsMapEquiv_apply_val {gamma : Type v'} (kappa : alpha → PMF beta)
    (j : beta → gamma) (hj : Function.Injective j) (y : activeOutputs kappa) :
    (activeOutputsMapEquiv kappa j hj y).val = j y.val := rfl

private theorem restrictActiveOutputs_map {gamma : Type v'} (kappa : alpha → PMF beta)
    (j : beta → gamma) (hj : Function.Injective j) (x : alpha) :
    (restrictActiveOutputs kappa x).map (activeOutputsMapEquiv kappa j hj) =
      restrictActiveOutputs (fun x => (kappa x).map j) x := by
  apply PMF.ext
  intro z
  obtain ⟨a, rfl⟩ := (activeOutputsMapEquiv kappa j hj).surjective z
  rw [PMF.map_apply_equiv, restrictActiveOutputs_apply, restrictActiveOutputs_apply]
  change kappa x a.val = (kappa x).map j (j a.val)
  exact (PMF.map_apply_of_injective (kappa x) hj a.val).symm

/-- The finite matrix boundary, over nonempty finite input. Output cardinality
belongs to the state and may change between states. Every output is active;
singularity is a separate hypothesis. The PMF channel owns normalization. -/
structure ActiveFiniteChannel (alpha : Type u) [Finite alpha] [Nonempty alpha] where
  outputCard : Nat
  outputCard_pos : 0 < outputCard
  channel : alpha → PMF (Fin outputCard)
  output_active : ∀ y, ∃ x, channel x y ≠ 0

namespace ActiveFiniteChannel

variable [Finite alpha] [Nonempty alpha]

/-- Present an already active channel using a supplied output enumeration. -/
noncomputable def ofActive (kappa : alpha → PMF beta) {m : Nat} (e : beta ≃ Fin m)
    (h : ∀ y, ∃ x, kappa x y ≠ 0) : ActiveFiniteChannel alpha where
  outputCard := m
  outputCard_pos := by
    obtain ⟨x⟩ := ‹Nonempty alpha›
    obtain ⟨y, _⟩ := (kappa x).support_nonempty
    exact lt_of_le_of_lt (Nat.zero_le _) (e y).isLt
  channel := fun x => (kappa x).map e
  output_active := by
    intro y
    obtain ⟨x, hx⟩ := h (e.symm y)
    refine ⟨x, ?_⟩
    simpa only [PMF.map_apply_equiv, e.apply_symm_apply] using
      (show (kappa x).map e (e (e.symm y)) ≠ 0 by simpa only [PMF.map_apply_equiv] using hx)

@[simp]
theorem ofActive_apply (kappa : alpha → PMF beta) {m : Nat} (e : beta ≃ Fin m)
    (h : ∀ y, ∃ x, kappa x y ≠ 0) (x : alpha) (y : beta) :
    (ofActive kappa e h).channel x (e y) = kappa x y := PMF.map_apply_equiv _ e y

/-- Direct enumeration has an inverse-map round trip, including original labels. -/
theorem ofActive_recover (kappa : alpha → PMF beta) {m : Nat} (e : beta ≃ Fin m)
    (h : ∀ y, ∃ x, kappa x y ≠ 0) (x : alpha) :
    ((ofActive kappa e h).channel x).map e.symm = kappa x := by
  change ((kappa x).map e).map e.symm = kappa x
  simp only [PMF.map_comp, Function.comp_def, e.symm_apply_apply]
  exact PMF.map_id _

/-- Two direct enumerations agree under their explicit output equivalence. -/
theorem ofActive_compare (kappa : alpha → PMF beta) {m n : Nat}
    (e : beta ≃ Fin m) (f : beta ≃ Fin n) (h : ∀ y, ∃ x, kappa x y ≠ 0) (x : alpha) :
    ((ofActive kappa e h).channel x).map (e.symm.trans f) = (ofActive kappa f h).channel x := by
  change ((kappa x).map e).map (e.symm.trans f) = (kappa x).map f
  simp only [PMF.map_comp, Function.comp_def, Equiv.trans_apply, e.symm_apply_apply]

/-- Restrict with C03, then enumerate. Ambient zero labels are omitted exactly,
without renormalization or any assumption on an input prior. -/
noncomputable def ofChannelWithEquiv (kappa : alpha → PMF beta) {m : Nat}
    (e : activeOutputs kappa ≃ Fin m) : ActiveFiniteChannel alpha :=
  ofActive (restrictActiveOutputs kappa) e (fun y => by
    obtain ⟨x, hx⟩ := y.property
    exact ⟨x, by simpa only [restrictActiveOutputs_apply, PMF.mem_support_iff] using hx⟩)

@[simp]
theorem ofChannelWithEquiv_apply (kappa : alpha → PMF beta) {m : Nat}
    (e : activeOutputs kappa ≃ Fin m) (x : alpha) (y : activeOutputs kappa) :
    (ofChannelWithEquiv kappa e).channel x (e y) = kappa x y.val := by
  exact (ofActive_apply _ _ _ _ _).trans (restrictActiveOutputs_apply _ _ _)

/-- Mapping the enumerated active row back includes every original ambient atom. -/
theorem ofChannelWithEquiv_recover (kappa : alpha → PMF beta) {m : Nat}
    (e : activeOutputs kappa ≃ Fin m) (x : alpha) :
    ((ofChannelWithEquiv kappa e).channel x).map (fun j => (e.symm j).val) = kappa x := by
  change (((restrictActiveOutputs kappa x).map e).map _) = kappa x
  rw [PMF.map_comp]
  simpa only [Function.comp_def, e.symm_apply_apply] using map_val_restrictActiveOutputs kappa x

theorem ofChannelWithEquiv_compare (kappa : alpha → PMF beta) {m n : Nat}
    (e : activeOutputs kappa ≃ Fin m) (f : activeOutputs kappa ≃ Fin n) (x : alpha) :
    ((ofChannelWithEquiv kappa e).channel x).map (e.symm.trans f) =
      (ofChannelWithEquiv kappa f).channel x := ofActive_compare _ _ _ _ _

theorem isSingularChannel_ofActive_iff (kappa : alpha → PMF beta) {m : Nat}
    (e : beta ≃ Fin m) (h : ∀ y, ∃ x, kappa x y ≠ 0) :
    IsSingularChannel (ofActive kappa e h).channel ↔ IsSingularChannel kappa := by
  let : Finite beta := e.finite_iff.mpr inferInstance
  exact isSingularChannel_map_iff kappa e e.injective

theorem isPerfectlyRepresentableChannel_ofActive_iff (kappa : alpha → PMF beta) {m : Nat}
    (e : beta ≃ Fin m) (h : ∀ y, ∃ x, kappa x y ≠ 0) :
    IsPerfectlyRepresentableChannel (ofActive kappa e h).channel ↔
      IsPerfectlyRepresentableChannel kappa := by
  let : Finite beta := e.finite_iff.mpr inferInstance
  exact isPerfectlyRepresentableChannel_map_iff kappa e e.injective

theorem isSingularChannel_ofChannelWithEquiv_iff [Finite beta]
    (kappa : alpha → PMF beta) {m : Nat} (e : activeOutputs kappa ≃ Fin m) :
    IsSingularChannel (ofChannelWithEquiv kappa e).channel ↔ IsSingularChannel kappa :=
  (isSingularChannel_ofActive_iff _ _ _).trans (isSingularChannel_restrictActiveOutputs_iff kappa)

theorem isPerfectlyRepresentableChannel_ofChannelWithEquiv_iff [Finite beta]
    (kappa : alpha → PMF beta) {m : Nat} (e : activeOutputs kappa ≃ Fin m) :
    IsPerfectlyRepresentableChannel (ofChannelWithEquiv kappa e).channel ↔
      IsPerfectlyRepresentableChannel kappa :=
  (isPerfectlyRepresentableChannel_ofActive_iff _ _ _).trans
    (isPerfectlyRepresentableChannel_restrictActiveOutputs_iff kappa)

/-- A finite ambient channel has an active presentation. The enumeration is
internal; label-sensitive consumers may instead supply `ofChannelWithEquiv`. -/
noncomputable def ofChannel [Finite beta] (kappa : alpha → PMF beta) :
    ActiveFiniteChannel alpha := ofChannelWithEquiv kappa (Finite.equivFin _)

@[simp]
theorem ofChannel_outputCard [Finite beta] (kappa : alpha → PMF beta) :
    (ofChannel kappa).outputCard = Nat.card (activeOutputs kappa) := rfl

/-- Inject the active coordinates back into their original ambient labels. -/
noncomputable def ambientLabel [Finite beta] (kappa : alpha → PMF beta) :
    Fin (ofChannel kappa).outputCard ↪ beta where
  toFun j := ((Finite.equivFin (activeOutputs kappa)).symm j).val
  inj' := by
    intro i j h
    exact (Finite.equivFin (activeOutputs kappa)).symm.injective (Subtype.ext h)

@[simp]
theorem ofChannel_apply [Finite beta] (kappa : alpha → PMF beta) (x : alpha)
    (j : Fin (ofChannel kappa).outputCard) :
    (ofChannel kappa).channel x j = kappa x (ambientLabel kappa j) := by
  change ((restrictActiveOutputs kappa x).map (Finite.equivFin (activeOutputs kappa))) j =
    kappa x ((Finite.equivFin (activeOutputs kappa)).symm j).val
  obtain ⟨a, rfl⟩ := (Finite.equivFin (activeOutputs kappa)).surjective j
  rw [PMF.map_apply_equiv, Equiv.symm_apply_apply, restrictActiveOutputs_apply]

theorem ofChannel_recover [Finite beta] (kappa : alpha → PMF beta) (x : alpha) :
    ((ofChannel kappa).channel x).map (ambientLabel kappa) = kappa x :=
  ofChannelWithEquiv_recover _ _ _

theorem isSingularChannel_ofChannel_iff [Finite beta] (kappa : alpha → PMF beta) :
    IsSingularChannel (ofChannel kappa).channel ↔ IsSingularChannel kappa :=
  isSingularChannel_ofChannelWithEquiv_iff _ _

theorem isPerfectlyRepresentableChannel_ofChannel_iff [Finite beta]
    (kappa : alpha → PMF beta) :
    IsPerfectlyRepresentableChannel (ofChannel kappa).channel ↔
      IsPerfectlyRepresentableChannel kappa :=
  isPerfectlyRepresentableChannel_ofChannelWithEquiv_iff _ _

/-- The full extension/restriction/enumeration chain respects specified enumerations. -/
theorem ofChannelWithEquiv_map_compare {gamma : Type v'} (kappa : alpha → PMF beta)
    (j : beta → gamma) (hj : Function.Injective j) {m n : Nat}
    (e : activeOutputs kappa ≃ Fin m)
    (f : activeOutputs (fun x => (kappa x).map j) ≃ Fin n) (x : alpha) :
    ((ofChannelWithEquiv kappa e).channel x).map
        (e.symm.trans ((activeOutputsMapEquiv kappa j hj).trans f)) =
      (ofChannelWithEquiv (fun x => (kappa x).map j) f).channel x := by
  change ((restrictActiveOutputs kappa x).map e).map _ =
    (restrictActiveOutputs (fun x => (kappa x).map j) x).map f
  rw [← restrictActiveOutputs_map kappa j hj x]
  simp only [PMF.map_comp, Function.comp_def, Equiv.trans_apply, e.symm_apply_apply]

/-- Compare the active coordinates selected before and after an ambient injection. -/
noncomputable def outputEquivOfMap [Finite beta] {gamma : Type v'} [Finite gamma]
    (kappa : alpha → PMF beta) (j : beta → gamma) (hj : Function.Injective j) :
    Fin (ofChannel kappa).outputCard ≃
      Fin (ofChannel (fun x => (kappa x).map j)).outputCard :=
  (Finite.equivFin (activeOutputs kappa)).symm.trans
    ((activeOutputsMapEquiv kappa j hj).trans (Finite.equivFin _))

theorem ofChannel_map_compare [Finite beta] {gamma : Type v'} [Finite gamma]
    (kappa : alpha → PMF beta) (j : beta → gamma) (hj : Function.Injective j) (x : alpha) :
    ((ofChannel kappa).channel x).map (outputEquivOfMap kappa j hj) =
      (ofChannel (fun x => (kappa x).map j)).channel x :=
  ofChannelWithEquiv_map_compare _ _ _ _ _ _

/-- Every coordinate of an active state is already an active semantic label. -/
def activeEquiv (S : ActiveFiniteChannel alpha) :
    Fin S.outputCard ≃ activeOutputs S.channel where
  toFun y := ⟨y, by
    obtain ⟨x, hx⟩ := S.output_active y
    exact ⟨x, hx⟩⟩
  invFun := Subtype.val
  left_inv _ := rfl
  right_inv _ := rfl

private theorem map_activeEquiv (S : ActiveFiniteChannel alpha) (x : alpha) :
    (S.channel x).map S.activeEquiv = restrictActiveOutputs S.channel x := by
  apply PMF.ext
  intro z
  obtain ⟨a, rfl⟩ := S.activeEquiv.surjective z
  rw [PMF.map_apply_equiv, restrictActiveOutputs_apply]
  rfl

/-- Recover a directly packaged state after adding unused output labels. -/
noncomputable def extensionEquiv (S : ActiveFiniteChannel alpha) {gamma : Type v'}
    [Finite gamma] (j : Fin S.outputCard → gamma) (hj : Function.Injective j) :
    Fin S.outputCard ≃ Fin (ofChannel (fun x => (S.channel x).map j)).outputCard :=
  S.activeEquiv.trans
    ((activeOutputsMapEquiv S.channel j hj).trans (Finite.equivFin _))

theorem extension_compare (S : ActiveFiniteChannel alpha) {gamma : Type v'} [Finite gamma]
    (j : Fin S.outputCard → gamma) (hj : Function.Injective j) (x : alpha) :
    (S.channel x).map (S.extensionEquiv j hj) =
      (ofChannel (fun x => (S.channel x).map j)).channel x := by
  change (S.channel x).map _ =
    (restrictActiveOutputs (fun x => (S.channel x).map j) x).map (Finite.equivFin _)
  rw [← restrictActiveOutputs_map S.channel j hj x, ← map_activeEquiv S x]
  simp only [PMF.map_comp]
  rfl

end ActiveFiniteChannel

end PerfectFunctionalRepresentations
