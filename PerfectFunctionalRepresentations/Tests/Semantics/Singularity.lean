import PerfectFunctionalRepresentations

/-! R01-R11 and R14: C03 semantic regressions consume the production root alone.
Examples and their tests remain separately imported. -/

namespace PerfectFunctionalRepresentations.Tests.Singularity

noncomputable section
universe u v

private def sparseChannel (x : Bool) : PMF (Option Bool) := PMF.pure (some x)

-- R01: a globally unused column and columns with exactly one positive entry.
example : (∀ x, sparseChannel x none = 0) ∧
    (∀ x y, sparseChannel x (some y) = if y = x then 1 else 0) ∧
    IsSingularChannel sparseChannel := by
  refine ⟨by intro x; simp [sparseChannel], ?_, ?_⟩
  · intro x y
    simp [sparseChannel]
  · intro x1 x2 y h1 h2
    cases x1 <;> cases x2 <;> cases y <;> simp_all [sparseChannel]

private def unequalChannel : Bool → PMF Bool
  | false => PMF.pure false
  | true => PMF.uniformOfFintype Bool

private theorem unequalColumn :
    unequalChannel false false = 1 ∧
    unequalChannel true false = (2 : ENNReal)⁻¹ ∧
    unequalChannel false false ≠ 0 ∧
    unequalChannel true false ≠ 0 := by
  norm_num [unequalChannel, PMF.uniformOfFintype_apply]

private theorem unequalChannel_not_singular : ¬ IsSingularChannel unequalChannel := by
  intro h
  have heq := h false true false unequalColumn.2.2.1 unequalColumn.2.2.2
  rw [unequalColumn.1, unequalColumn.2.1] at heq
  have hinv := congrArg (fun t : ENNReal => t⁻¹) heq
  norm_num at hinv

-- R02: necessity has a concrete nonrepresentability consumer.
example : ¬ IsPerfectlyRepresentableChannel unequalChannel :=
  fun h => unequalChannel_not_singular h.isSingular

-- R03: empty-input singularity is vacuous; the perfectness contract requires
-- an actual Nonempty witness, which cannot be supplied here.
example {alpha : Type u} {beta : Type v} [IsEmpty alpha]
    (kappa : alpha → PMF beta) :
    IsSingularChannel kappa ∧
      ¬ ∃ h : Nonempty alpha, @IsPerfectlyRepresentableChannel alpha beta h kappa := by
  constructor
  · intro x1
    exact isEmptyElim x1
  · rintro ⟨⟨x⟩, _⟩
    exact isEmptyElim x

example {beta : Type u} (kappa : Unit → PMF beta) : IsSingularChannel kappa := by
  intro x1 x2 y _ _
  cases x1
  cases x2
  rfl

-- General consumers guard against accidental finiteness or prior assumptions.
example {alpha : Type u} {beta : Type v} (kappa : alpha → PMF beta) :
    IsSingularChannel kappa ↔
      ∀ x1 x2 y, 0 < kappa x1 y * kappa x2 y → kappa x1 y = kappa x2 y :=
  isSingularChannel_iff_mul_pos kappa

example {alpha : Type u} {beta : Type v} [Nonempty alpha]
    (kappa : alpha → PMF beta) (h : IsPerfectlyRepresentableChannel kappa) :
    IsSingularChannel kappa := h.isSingular

/-! ## PFR-C03-S02 regressions -/

universe u' v'

-- R04: the explicit vector orientation transports the entire joint law and
-- the common posterior, across four independent alphabet universes.
example {alpha : Type u} {alpha' : Type u'} {beta : Type v} {beta' : Type v'}
    (eX : alpha ≃ alpha') (eY : beta ≃ beta')
    (kappa : alpha → PMF beta) (q : PMF (alpha → beta))
    (V : beta → PMF (alpha → beta))
    (h : ∀ x, q.map (fun w => (w x, w)) = PMF.channelJoint (kappa x) V) (x' : alpha') :
    (q.map (fun w x' => eY (w (eX.symm x')))).map (fun w => (w x', w)) =
      PMF.channelJoint ((kappa (eX.symm x')).map eY)
        (fun y' => (V (eY.symm y')).map (fun w x' => eY (w (eX.symm x')))) := by
  have hm := congrArg (fun p : PMF (beta × (alpha → beta)) =>
    p.map (fun t => (eY t.1, fun a' => eY (t.2 (eX.symm a'))))) (h (eX.symm x'))
  simpa only [PMF.map_comp, PMF.channelJoint, PMF.map_bind, PMF.bind_map,
    Function.comp_def, eY.symm_apply_apply] using hm

-- Applying the inverse labels recovers the actual vector distribution.
example {alpha : Type u} {alpha' : Type u'} {beta : Type v} {beta' : Type v'}
    (eX : alpha ≃ alpha') (eY : beta ≃ beta') (q : PMF (alpha → beta)) :
    (q.map (fun w x' => eY (w (eX.symm x')))).map
      (fun w x => eY.symm (w (eX x))) = q := by
  simp only [PMF.map_comp, Function.comp_def, eX.symm_apply_apply, eY.symm_apply_apply]
  exact PMF.map_id q

example {alpha : Type u} {alpha' : Type u'} {beta : Type v} {beta' : Type v'}
    [Finite alpha] [Finite alpha'] [Finite beta] [Finite beta'] [Nonempty alpha]
    (kappa : alpha → PMF beta) (eX : alpha ≃ alpha') (eY : beta ≃ beta') :
    let : Nonempty alpha' := Nonempty.map eX ‹Nonempty alpha›
    (IsPerfectlyRepresentableChannel (fun x' => (kappa (eX.symm x')).map eY) ↔
      IsPerfectlyRepresentableChannel kappa) ∧
    (IsSingularChannel (fun x' => (kappa (eX.symm x')).map eY) ↔ IsSingularChannel kappa) :=
  ⟨isPerfectlyRepresentableChannel_relabel_iff kappa eX eY,
    isSingularChannel_relabel_iff kappa eX eY⟩

-- Identity specializations expose input-only and output-only consumers.
example {alpha : Type u} {alpha' : Type u'} {beta : Type v}
    [Finite alpha] [Finite alpha'] [Finite beta] [Nonempty alpha]
    (kappa : alpha → PMF beta) (eX : alpha ≃ alpha') :
    let : Nonempty alpha' := Nonempty.map eX ‹Nonempty alpha›
    (IsPerfectlyRepresentableChannel (fun x' => kappa (eX.symm x')) ↔
      IsPerfectlyRepresentableChannel kappa) ∧
    (IsSingularChannel (fun x' => kappa (eX.symm x')) ↔ IsSingularChannel kappa) := by
  simpa only [Equiv.coe_refl, PMF.map_id] using
    And.intro (isPerfectlyRepresentableChannel_relabel_iff kappa eX (Equiv.refl beta))
      (isSingularChannel_relabel_iff kappa eX (Equiv.refl beta))

example {alpha : Type u} {beta : Type v} {beta' : Type v'}
    [Finite alpha] [Finite beta] [Finite beta'] [Nonempty alpha]
    (kappa : alpha → PMF beta) (eY : beta ≃ beta') :
    (IsPerfectlyRepresentableChannel (fun x => (kappa x).map eY) ↔
      IsPerfectlyRepresentableChannel kappa) ∧
    (IsSingularChannel (fun x => (kappa x).map eY) ↔ IsSingularChannel kappa) := by
  exact ⟨isPerfectlyRepresentableChannel_relabel_iff kappa (Equiv.refl alpha) eY,
    isSingularChannel_relabel_iff kappa (Equiv.refl alpha) eY⟩

private def cycleInput : Fin 3 ≃ Fin 3 :=
  (Equiv.swap 0 1).trans (Equiv.swap 1 2)

-- A three-cycle distinguishes inverse input relabeling from forward relabeling.
-- Both the input and output equivalences are nontrivial.
example : (PMF.pure (cycleInput.symm 0)).map (Equiv.swap (0 : Fin 3) 1) = PMF.pure 0 ∧
    Equiv.swap (0 : Fin 3) 1 (cycleInput 0) = 2 := by
  simp [cycleInput, Equiv.swap_apply_def, PMF.pure_map, Fin.ext_iff]

example : IsPerfectlyRepresentableChannel
    (fun x : Fin 3 => (PMF.pure (cycleInput.symm x)).map (Equiv.swap (0 : Fin 3) 1)) ∧
    IsSingularChannel
      (fun x : Fin 3 => (PMF.pure (cycleInput.symm x)).map (Equiv.swap (0 : Fin 3) 1)) := by
  have hp : IsPerfectlyRepresentableChannel (fun x : Fin 3 => PMF.pure x) := by
    refine ⟨PMF.pure id, (fun _ => PMF.pure id), ?_⟩
    intro x
    simp [PMF.channelJoint, PMF.pure_map]
  exact ⟨(isPerfectlyRepresentableChannel_relabel_iff _ cycleInput (Equiv.swap 0 1)).2 hp,
    (isSingularChannel_relabel_iff _ cycleInput (Equiv.swap 0 1)).2 hp.isSingular⟩

-- R05: some embeds into a strictly larger output alphabet. Its new none column
-- is identically zero, and both directions of both public iff contracts apply.
example (kappa : Bool → PMF Bool) :
    (∀ x, (kappa x).map some none = 0) ∧
    (IsPerfectlyRepresentableChannel (fun x => (kappa x).map some) ↔
      IsPerfectlyRepresentableChannel kappa) ∧
    (IsSingularChannel (fun x => (kappa x).map some) ↔ IsSingularChannel kappa) := by
  refine ⟨?_, isPerfectlyRepresentableChannel_map_iff kappa some (Option.some_injective _),
    isSingularChannel_map_iff kappa some (Option.some_injective _)⟩
  intro x
  exact PMF.map_apply_eq_zero_of_notMem_range _ (by simp)

-- For any supplied embedded witness, recovery holds on supported vectors and
-- for the full vector law, not merely for its separate coordinate marginals.
example {alpha : Type u} {beta : Type v} {gamma : Type v'}
    (kappa : alpha → PMF beta) (j : beta → gamma)
    (q : PMF (alpha → gamma)) (V : gamma → PMF (alpha → gamma))
    (h : ∀ x, q.map (fun w => (w x, w)) = PMF.channelJoint ((kappa x).map j) V)
    (r : gamma → beta) (hr : Function.LeftInverse r j) :
    (∀ w ∈ q.support, ∀ x, w x ∈ Set.range j) ∧
      q.map (fun w x => j (r (w x))) = q := by
  classical
  have hrange : ∀ w ∈ q.support, ∀ x, w x ∈ Set.range j := by
    intro w hw x
    have hC := isCanonicalCoupling_of_coordinateFactorization q
      (fun x => (kappa x).map j) V h
    have hx : w x ∈ (q.map (fun f => f x)).support :=
      (PMF.mem_support_map_iff _ _ _).2 ⟨w, hw, rfl⟩
    rw [hC x] at hx
    obtain ⟨b, _, hb⟩ := (PMF.mem_support_map_iff _ _ _).1 hx
    exact ⟨b, hb⟩
  refine ⟨hrange, ?_⟩
  have hround : ∀ w ∈ q.support, (fun x => j (r (w x))) = w := by
    intro w hw
    funext x
    obtain ⟨b, hb⟩ := hrange w hw x
    rw [← hb, hr b]
  calc
    q.map (fun w x => j (r (w x))) = q.map id := by
      apply PMF.ext
      intro w
      simp only [PMF.map_apply]
      apply tsum_congr
      intro z
      by_cases hz : z ∈ q.support
      · rw [hround z hz]
        rfl
      · have hzero : q z = 0 := by
          simpa only [PMF.mem_support_iff, not_not] using hz
        simp only [hzero, ite_self]
    _ = q := PMF.map_id q

-- The posterior at the newly unused output may be any PMF, including vectors
-- with none coordinates. Those null-output atoms need not lie in the image.
example (kappa : Bool → PMF Bool) (q : PMF (Bool → Option Bool))
    (V : Option Bool → PMF (Bool → Option Bool)) (unused : PMF (Bool → Option Bool))
    (h : ∀ x, q.map (fun w => (w x, w)) = PMF.channelJoint ((kappa x).map some) V) :
    ∀ x, q.map (fun w => (w x, w)) =
      PMF.channelJoint ((kappa x).map some) (fun y => match y with
        | none => unused
        | some b => V (some b)) := by
  apply (coordinateFactorization_congr_posterior q _ V _ ?_).1 h
  intro y hy
  cases y with
  | none =>
    obtain ⟨x, hx⟩ := hy
    have hz : (kappa x).map some none = 0 :=
      PMF.map_apply_eq_zero_of_notMem_range _ (by simp)
    exact False.elim (hx hz)
  | some b => rfl

/-! ## PFR-C03-S03 regressions -/

open LeanInfoTheory.Shannon

-- R06: exact masses, inclusion and global activity require no finite/prior assumptions.
example {alpha : Type u} {beta : Type v} (kappa : alpha → PMF beta) :
    (∀ x a, restrictActiveOutputs kappa x a = kappa x a.val) ∧
    (∀ x, (restrictActiveOutputs kappa x).map Subtype.val = kappa x) ∧
    (∀ a : activeOutputs kappa, ∃ x, a ∈ (restrictActiveOutputs kappa x).support) := by
  refine ⟨restrictActiveOutputs_apply kappa, map_val_restrictActiveOutputs kappa, ?_⟩
  intro a
  have ha : a ∈ activeOutputs (restrictActiveOutputs kappa) := by
    rw [activeOutputs_restrictActiveOutputs]
    exact Set.mem_univ a
  exact ha

example {alpha : Type u} {beta : Type v} [Finite alpha] [Finite beta] [Nonempty alpha]
    (kappa : alpha → PMF beta) :
    (IsSingularChannel (restrictActiveOutputs kappa) ↔ IsSingularChannel kappa) ∧
    (IsPerfectlyRepresentableChannel (restrictActiveOutputs kappa) ↔
      IsPerfectlyRepresentableChannel kappa) :=
  ⟨isSingularChannel_restrictActiveOutputs_iff kappa,
    isPerfectlyRepresentableChannel_restrictActiveOutputs_iff kappa⟩

-- R08 (S03): nonempty input forces positive intrinsic output cardinality.
example {alpha : Type u} {beta : Type v} [Fintype alpha] [Fintype beta] [Nonempty alpha]
    (kappa : alpha → PMF beta) :
    let : Fintype (activeOutputs kappa) := Fintype.ofFinite _
    0 < Fintype.card (activeOutputs kappa) := by
  classical
  let : Fintype (activeOutputs kappa) := Fintype.ofFinite _
  let : Nonempty (activeOutputs kappa) := (activeOutputs_nonempty kappa).to_subtype
  exact Fintype.card_pos

-- Empty input has an empty active union; no PMF can inhabit an empty output type.
example {alpha : Type u} {beta : Type v} [IsEmpty alpha] (kappa : alpha → PMF beta) :
    activeOutputs kappa = ∅ := by
  ext y
  exact ⟨fun ⟨x, _⟩ => isEmptyElim x, False.elim⟩

example {beta : Type v} [IsEmpty beta] : ¬ Nonempty (PMF beta) := by
  rintro ⟨p⟩
  obtain ⟨y, _⟩ := p.support_nonempty
  exact isEmptyElim y

private def singletonRow (_ : Unit) : PMF (Option Bool) := PMF.pure (some false)
private def singletonAtom : activeOutputs singletonRow := ⟨some false, (), by simp [singletonRow]⟩

-- The sole active mass is still one, and inclusion recovers the original pure row.
-- This is a structural restriction check; its perfectness consequence belongs to S04.
example : activeOutputs singletonRow = {some false} ∧
    restrictActiveOutputs singletonRow () = PMF.pure singletonAtom ∧
    (restrictActiveOutputs singletonRow ()).map Subtype.val = PMF.pure (some false) := by
  refine ⟨?_, ?_, map_val_restrictActiveOutputs singletonRow ()⟩
  · ext y
    simp [activeOutputs, singletonRow]
  · apply PMF.ext
    intro a
    have ha : a = singletonAtom := by
      apply Subtype.ext
      obtain ⟨x, hx⟩ := a.property
      simpa [singletonRow, singletonAtom] using hx
    subst a
    simp [restrictActiveOutputs_apply, singletonRow, singletonAtom]

-- Pinned APIs already supply the generic formula: no extra public wrapper needed.
private theorem support_formula {alpha : Type u} {beta : Type v}
    (p : PMF alpha) (kappa : alpha → PMF beta) (y : beta) :
    y ∈ (sndMarginal (PMF.channelJoint p kappa)).support ↔
      ∃ x ∈ p.support, y ∈ (kappa x).support := by
  change y ∈ ((PMF.channelJoint p kappa).map Prod.snd).support ↔ _
  rw [PMF.channelJoint_map_snd, PMF.mem_support_bind_iff]

-- Arbitrary priors identify the active union only after input-support restriction.
example {alpha : Type u} {beta : Type v}
    (p : PMF alpha) (kappa : alpha → PMF beta) :
    (sndMarginal (PMF.channelJoint p kappa)).support =
      activeOutputs (fun s : p.support => kappa s.val) := by
  ext y
  rw [support_formula]
  constructor
  · rintro ⟨x, hx, hy⟩
    exact ⟨⟨x, hx⟩, hy⟩
  · rintro ⟨x, hy⟩
    exact ⟨x.val, x.property, hy⟩

private def identityRows (x : Bool) : PMF Bool := PMF.pure x
private def pointPrior : PMF Bool := PMF.pure false

-- R07: exact supports exhibit a strict loss of outputs under a degenerate prior.
example :
    (sndMarginal (PMF.channelJoint pointPrior identityRows)).support = {false} ∧
    activeOutputs identityRows = Set.univ ∧
    true ∉ (sndMarginal (PMF.channelJoint pointPrior identityRows)).support ∧
    true ∈ activeOutputs identityRows := by
  constructor
  · simp [sndMarginal, PMF.channelJoint_map_snd, pointPrior, identityRows]
  constructor
  · ext y
    simp [activeOutputs, identityRows]
  constructor
  · simp [sndMarginal, PMF.channelJoint_map_snd, pointPrior, identityRows]
  · exact ⟨true, by simp [identityRows]⟩

-- R07: actual full support restores equality with the intrinsic union.
example :
    (sndMarginal (PMF.channelJoint (PMF.uniformOfFintype Bool) identityRows)).support =
      activeOutputs identityRows := by
  apply support_sndMarginal_channelJoint_eq_activeOutputs_of_fullSupport
  intro x
  norm_num [PMF.mem_support_iff, PMF.uniformOfFintype_apply]

-- R07: C02's normalized prior on input support has full support, and the
-- restricted channel has exactly the one output seen by the original pair.
example :
    (sndMarginal (PMF.channelJoint (inputSupportPrior pointPrior)
      (fun s : pointPrior.support => identityRows s.val))).support =
        activeOutputs (fun s : pointPrior.support => identityRows s.val) ∧
    activeOutputs (fun s : pointPrior.support => identityRows s.val) = {false} := by
  constructor
  · exact support_sndMarginal_channelJoint_eq_activeOutputs_of_fullSupport _ _
      (mem_support_inputSupportPrior pointPrior)
  · ext y
    constructor
    · rintro ⟨s, hs⟩
      have hsval : s.val = false := by simpa [pointPrior] using s.property
      simpa [identityRows, hsval] using hs
    · intro hy
      have hyval : y = false := hy
      refine ⟨⟨false, by simp [pointPrior]⟩, ?_⟩
      simp [identityRows, hyval]

-- R07: inclusion recovers the same pair law even though the input types differ.
example :
    (PMF.channelJoint (inputSupportPrior pointPrior)
      (fun s : pointPrior.support => identityRows s.val)).map
        (fun sy => (sy.1.val, sy.2)) = PMF.channelJoint pointPrior identityRows :=
  channelJoint_inputSupportPrior_map_val pointPrior identityRows

-- R07: consume the exact finite C02 pair/channel boundary, without promoting
-- pair perfectness under this prior to the original two-input channel.
example :
    IsPerfectlyRepresentablePair (PMF.channelJoint pointPrior identityRows) ↔
      @IsPerfectlyRepresentableChannel pointPrior.support Bool
        pointPrior.support_nonempty.to_subtype (fun s => identityRows s.val) :=
  isPerfectlyRepresentablePair_channelJoint_iff_restrict_support pointPrior identityRows

-- The same interface keeps its explicit finite input/output requirements.
example {alpha : Type u} {beta : Type v} [Fintype alpha] [Fintype beta]
    (p : PMF alpha) (kappa : alpha → PMF beta) :
    IsPerfectlyRepresentablePair (PMF.channelJoint p kappa) ↔
      @IsPerfectlyRepresentableChannel p.support beta p.support_nonempty.to_subtype
        (fun s => kappa s.val) :=
  isPerfectlyRepresentablePair_channelJoint_iff_restrict_support p kappa

/-! ## PFR-C03-S04 regressions -/

-- Generic public consumers retain independent universes and the approved boundaries.
example {alpha : Type u} {beta : Type v} [Fintype alpha] [Fintype beta] [Nonempty alpha]
    (kappa : alpha → PMF beta) (hcard : Fintype.card beta ≤ 2) :
    IsPerfectlyRepresentableChannel kappa ↔ IsSingularChannel kappa :=
  isPerfectlyRepresentableChannel_iff_isSingular_of_card_le_two kappa hcard

example {alpha : Type u} {beta : Type v} [Fintype alpha] [Fintype beta] [Nonempty alpha]
    (kappa : alpha → PMF beta) :
    let : Fintype (activeOutputs kappa) := Fintype.ofFinite _
    Fintype.card (activeOutputs kappa) ≤ 2 →
      (IsPerfectlyRepresentableChannel kappa ↔ IsSingularChannel kappa) :=
  isPerfectlyRepresentableChannel_iff_isSingular_of_activeOutputs_card_le_two kappa

-- R08 (S04): arbitrary supplied singleton-output rows, not just a chosen pure fixture.
example {alpha : Type u} [Fintype alpha] [Nonempty alpha] (kappa : alpha → PMF Unit) :
    IsPerfectlyRepresentableChannel kappa := by
  apply (isPerfectlyRepresentableChannel_iff_isSingular_of_card_le_two kappa (by decide)).2
  intro x1 x2 y _ _
  have hunit (p : PMF Unit) : p () = 1 := by simpa using p.tsum_coe
  cases y
  rw [hunit, hunit]

-- Singleton input is covered for any row within the approved small-output bound.
example {beta : Type v} [Fintype beta] (kappa : Unit → PMF beta)
    (hcard : Fintype.card beta ≤ 2) : IsPerfectlyRepresentableChannel kappa := by
  apply (isPerfectlyRepresentableChannel_iff_isSingular_of_card_le_two kappa hcard).2
  intro x1 x2 y _ _
  cases x1
  cases x2
  rfl

-- The S03 singleton-active fixture has a larger ambient alphabet; its active bound suffices.
example : IsPerfectlyRepresentableChannel singletonRow := by
  classical
  let : Fintype (activeOutputs singletonRow) := Fintype.ofFinite _
  have hc : Fintype.card (activeOutputs singletonRow) = 1 := by
    calc
      Fintype.card (activeOutputs singletonRow) = ({some false} : Finset (Option Bool)).card := by
        apply Fintype.card_of_subtype
        intro y
        simp [activeOutputs, singletonRow]
      _ = 1 := by simp
  apply (isPerfectlyRepresentableChannel_iff_isSingular_of_activeOutputs_card_le_two
    singletonRow (by omega)).2
  intro x1 x2 y _ _
  cases x1
  cases x2
  rfl

-- R10's one-output degeneration inside a literal binary ambient alphabet.
example : IsPerfectlyRepresentableChannel (fun _ : Bool => PMF.pure false) :=
  (isPerfectlyRepresentableChannel_iff_isSingular_of_card_le_two _ (by decide)).2
    (by intro x1 x2 y _ _; rfl)

-- R11: exactly two active outputs in a three-symbol ambient type, followed by
-- nontrivial input and output relabeling of the resulting perfect channel.
example : Fintype.card (Option Bool) = 3 ∧
    IsPerfectlyRepresentableChannel sparseChannel ∧
    IsPerfectlyRepresentableChannel (fun x' =>
      (sparseChannel ((Equiv.swap false true).symm x')).map
        (Equiv.optionCongr (Equiv.swap false true))) := by
  classical
  let : Fintype (activeOutputs sparseChannel) := Fintype.ofFinite _
  have hc : Fintype.card (activeOutputs sparseChannel) = 2 := by
    calc
      Fintype.card (activeOutputs sparseChannel) =
          ({some false, some true} : Finset (Option Bool)).card := by
        apply Fintype.card_of_subtype
        intro y
        cases y with
        | none => simp [activeOutputs, sparseChannel]
        | some b => cases b <;> simp [activeOutputs, sparseChannel]
      _ = 2 := by simp
  have hs : IsSingularChannel sparseChannel := by
    intro x1 x2 y h1 h2
    cases x1 <;> cases x2 <;> cases y <;> simp_all [sparseChannel]
  have hp := (isPerfectlyRepresentableChannel_iff_isSingular_of_activeOutputs_card_le_two
    sparseChannel (by omega)).2 hs
  exact ⟨by decide, hp,
    (isPerfectlyRepresentableChannel_relabel_iff sparseChannel (Equiv.swap false true)
      (Equiv.optionCongr (Equiv.swap false true))).2 hp⟩

-- R09: exact unequal positive atom masses, hence nonuniform and non-pure.
-- This repeats the construction shape of the private C02 biasedBit fixture.
private def biasedBit : PMF Bool :=
  PMF.ofFintype (fun b => if b then (1 : ENNReal) / 3 else 2 / 3) (by
    rw [Fintype.sum_bool]
    change (1 : ENNReal) / 3 + 2 / 3 = 1
    rw [ENNReal.div_add_div_same]
    norm_num
    exact ENNReal.div_self (by norm_num) (by norm_num))

example : biasedBit true = (1 : ENNReal) / 3 ∧
    biasedBit false = (2 : ENNReal) / 3 ∧
    biasedBit true ≠ biasedBit false ∧
    (∀ b, b ∈ biasedBit.support) ∧
    (∀ b, biasedBit ≠ PMF.pure b) := by
  refine ⟨by simp [biasedBit], by simp [biasedBit], ?_, ?_, ?_⟩
  · intro h
    have hm := congrArg (fun p : ENNReal => p * 3) h
    change (1 : ENNReal) / 3 * 3 = 2 / 3 * 3 at hm
    rw [ENNReal.div_mul_cancel (by norm_num) (by norm_num),
      ENNReal.div_mul_cancel (by norm_num) (by norm_num)] at hm
    norm_num at hm
  · intro b
    cases b <;> norm_num [biasedBit, PMF.mem_support_iff, PMF.ofFintype_apply]
  · intro b h
    have hm := congrArg (fun p : PMF Bool => p (!b)) h
    cases b <;> norm_num [biasedBit, PMF.ofFintype_apply] at hm

-- The actual common posterior is specified, rather than only asserting existence.
example (x : Bool) :
    (biasedBit.map (fun y => fun _ : Bool => y)).map (fun w => (w x, w)) =
      PMF.channelJoint biasedBit (fun y => PMF.pure (fun _ : Bool => y)) :=
  by
    simp only [PMF.map_comp, PMF.channelJoint, PMF.pure_map, Function.comp_def]
    rfl

example : IsPerfectlyRepresentableChannel (fun _ : Bool => biasedBit) :=
  (isPerfectlyRepresentableChannel_iff_isSingular_of_card_le_two _ (by decide)).2
    (by intro x1 x2 y _ _; rfl)

-- R10: different deterministic rows with their full coordinate/vector factorization.
example : (PMF.pure false : PMF Bool) ≠ PMF.pure true ∧
    (∀ x : Bool, (PMF.pure (id : Bool → Bool)).map (fun w => (w x, w)) =
      PMF.channelJoint (PMF.pure x) (fun _ => PMF.pure (id : Bool → Bool))) ∧
    IsPerfectlyRepresentableChannel (fun x : Bool => PMF.pure x) := by
  refine ⟨?_, ?_, ?_⟩
  · intro h
    have hm := congrArg (fun p : PMF Bool => p false) h
    simp at hm
  · intro x
    simp only [PMF.pure_map, PMF.channelJoint, PMF.pure_bind, id_eq]
  · apply (isPerfectlyRepresentableChannel_iff_isSingular_of_card_le_two _ (by decide)).2
    intro x1 x2 y h1 h2
    cases x1 <;> cases x2 <;> cases y <;> simp_all

-- R14: the shared posterior-support helper is also usable through the root,
-- retaining independent universes and its unrestricted structural assumptions.
example {alpha : Type u} {beta : Type v} (q : PMF (alpha → beta))
    (kappa : alpha → PMF beta) (V : beta → PMF (alpha → beta))
    (h : ∀ x, q.map (fun w => (w x, w)) = PMF.channelJoint (kappa x) V)
    {x : alpha} {y : beta} {w : alpha → beta}
    (hx : kappa x y ≠ 0) (hw : w ∈ (V y).support) : w x = y :=
  coordinate_eq_of_posterior_support q kappa V h hx hw

end
end PerfectFunctionalRepresentations.Tests.Singularity
