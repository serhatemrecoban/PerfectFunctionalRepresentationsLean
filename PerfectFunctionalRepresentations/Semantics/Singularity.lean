import PerfectFunctionalRepresentations.Semantics.Canonical

/-!
# Intrinsic channel singularity

ISIT Section II-B, Definition 3 and the necessary direction of Lemma 2.
The proof follows extended Appendix A (105)-(110) through C02's prior-free
common-posterior factorization. Singularity concerns positive column entries,
not a matrix determinant. Zero columns impose no condition.
-/

namespace PerfectFunctionalRepresentations

universe u v

/-- A channel is singular when any two nonzero entries in one output column agree.
No finiteness, nonempty alphabet or input law is needed for this predicate. -/
def IsSingularChannel {alpha : Type u} {beta : Type v}
    (kappa : alpha → PMF beta) : Prop :=
  ∀ x1 x2 y, kappa x1 y ≠ 0 → kappa x2 y ≠ 0 → kappa x1 y = kappa x2 y

/-- Definition 3's positive-product formulation is exactly intrinsic singularity. -/
theorem isSingularChannel_iff_mul_pos {alpha : Type u} {beta : Type v}
    (kappa : alpha → PMF beta) :
    IsSingularChannel kappa ↔
      ∀ x1 x2 y, 0 < kappa x1 y * kappa x2 y → kappa x1 y = kappa x2 y := by
  constructor
  · intro h x1 x2 y hpos
    exact h x1 x2 y (left_ne_zero_of_mul (ne_of_gt hpos))
      (right_ne_zero_of_mul (ne_of_gt hpos))
  · intro h x1 x2 y h1 h2
    exact h x1 x2 y (pos_iff_ne_zero.mpr (mul_ne_zero h1 h2))

/-- Under a common-posterior factorization, each supported posterior vector has
coordinate `y` at every input whose row can emit `y`. Reused by the direct
nonrepresentability example; no finite-alphabet assumption is needed. -/
theorem coordinate_eq_of_posterior_support
    {alpha : Type u} {beta : Type v} (q : PMF (alpha → beta))
    (kappa : alpha → PMF beta) (V : beta → PMF (alpha → beta))
    (h : ∀ x, q.map (fun w => (w x, w)) = PMF.channelJoint (kappa x) V)
    {x : alpha} {y : beta} {w : alpha → beta}
    (hx : kappa x y ≠ 0) (hw : w ∈ (V y).support) : w x = y := by
  have hs : (y, w) ∈ (q.map (fun f => (f x, f))).support := by
    rw [h x, PMF.mem_support_channelJoint_iff]
    exact ⟨hx, hw⟩
  obtain ⟨f, _, hf⟩ := (PMF.mem_support_map_iff _ _ _).1 hs
  have hfw : f = w := congrArg Prod.snd hf
  simpa only [hfw] using congrArg Prod.fst hf

/-- Perfect representability forces intrinsic singularity. The same posterior
atom compares both positive entries, so no prior or finite-alphabet hypothesis
is needed. Nonempty input is inherited from the channel-perfectness contract. -/
theorem IsPerfectlyRepresentableChannel.isSingular
    {alpha : Type u} {beta : Type v} [Nonempty alpha]
    {kappa : alpha → PMF beta} (hPerfect : IsPerfectlyRepresentableChannel kappa) :
    IsSingularChannel kappa := by
  obtain ⟨q, V, h⟩ := hPerfect
  intro x1 x2 y h1 h2
  obtain ⟨w, hw⟩ := (V y).support_nonempty
  have hcoord1 := coordinate_eq_of_posterior_support q kappa V h h1 hw
  have hcoord2 := coordinate_eq_of_posterior_support q kappa V h h2 hw
  have hmass (x : alpha) (hx : w x = y) : q w = kappa x y * V y w := by
    have hinj : Function.Injective (fun f : alpha → beta => (f x, f)) := by
      intro f g hfg
      exact congrArg Prod.snd hfg
    calc
      q w = (q.map (fun f => (f x, f))) (w x, w) :=
        (PMF.map_apply_of_injective q hinj w).symm
      _ = kappa x y * V y w := by rw [h x, hx, PMF.channelJoint_apply]
  exact (ENNReal.mul_left_inj ((PMF.mem_support_iff _ _).mp hw) (PMF.apply_ne_top _ _)).1
    ((hmass x1 hcoord1).symm.trans (hmass x2 hcoord2))

/-! ## PFR-C03-S02: finite relabeling and unused-output extension -/

universe u' v'

/-- Adding output symbols through an injection preserves intrinsic singularity.
Columns outside the image have zero mass in every row. -/
theorem isSingularChannel_map_iff {alpha : Type u} {beta : Type v} {gamma : Type v'}
    [Finite alpha] [Finite beta] [Finite gamma]
    (kappa : alpha → PMF beta) (j : beta → gamma) (hj : Function.Injective j) :
    IsSingularChannel (fun x => (kappa x).map j) ↔ IsSingularChannel kappa := by
  constructor
  · intro h x1 x2 y h1 h2
    have := h x1 x2 (j y)
    simpa only [PMF.map_apply_of_injective _ hj] using this
      (by simpa only [PMF.map_apply_of_injective _ hj] using h1)
      (by simpa only [PMF.map_apply_of_injective _ hj] using h2)
  · intro h x1 x2 z h1 h2
    obtain ⟨y, _, rfl⟩ := (PMF.mem_support_map_iff _ _ _).1
      ((PMF.mem_support_iff _ _).2 h1)
    simpa only [PMF.map_apply_of_injective _ hj] using h x1 x2 y
      (by simpa only [PMF.map_apply_of_injective _ hj] using h1)
      (by simpa only [PMF.map_apply_of_injective _ hj] using h2)

/-- Injective output extension preserves the complete common-posterior witness.
In either direction both components of each coordinate/vector joint law are
pushed forward. The inverse's values away from the image only choose a valid
completion at unused outputs; no default output is a public assumption. -/
theorem isPerfectlyRepresentableChannel_map_iff
    {alpha : Type u} {beta : Type v} {gamma : Type v'}
    [Finite alpha] [Finite beta] [Finite gamma] [Nonempty alpha]
    (kappa : alpha → PMF beta) (j : beta → gamma) (hj : Function.Injective j) :
    IsPerfectlyRepresentableChannel (fun x => (kappa x).map j) ↔
      IsPerfectlyRepresentableChannel kappa := by
  classical
  obtain ⟨y0, _⟩ := (kappa (Classical.choice (inferInstance : Nonempty alpha))).support_nonempty
  let : Nonempty beta := ⟨y0⟩
  let r : gamma → beta := Function.invFun j
  have hleft : ∀ y, r (j y) = y := Function.leftInverse_invFun hj
  constructor
  · rintro ⟨q, V, h⟩
    refine ⟨q.map (fun f x => r (f x)),
      (fun y => (V (j y)).map (fun f x => r (f x))), ?_⟩
    intro x
    have hm := congrArg (fun p : PMF (gamma × (alpha → gamma)) =>
      p.map (fun t => (r t.1, fun a => r (t.2 a)))) (h x)
    simpa only [PMF.map_comp, PMF.channelJoint, PMF.map_bind, PMF.bind_map,
      Function.comp_def, hleft] using hm
  · rintro ⟨q, V, h⟩
    refine ⟨q.map (fun f x => j (f x)),
      (fun y => (V (r y)).map (fun f x => j (f x))), ?_⟩
    intro x
    have hm := congrArg (fun p : PMF (beta × (alpha → beta)) =>
      p.map (fun t => (j t.1, fun a => j (t.2 a)))) (h x)
    simpa only [PMF.map_comp, PMF.channelJoint, PMF.map_bind, PMF.bind_map,
      Function.comp_def, hleft] using hm

private theorem perfect_precomp
    {alpha : Type u} {alpha' : Type u'} {beta : Type v}
    [Nonempty alpha] [Nonempty alpha']
    (kappa : alpha → PMF beta) (f : alpha' → alpha)
    (hPerfect : IsPerfectlyRepresentableChannel kappa) :
    IsPerfectlyRepresentableChannel (fun a' => kappa (f a')) := by
  obtain ⟨q, V, h⟩ := hPerfect
  refine ⟨q.map (fun w a' => w (f a')),
    (fun y => (V y).map (fun w a' => w (f a'))), ?_⟩
  intro a'
  have hm := congrArg (fun p : PMF (beta × (alpha → beta)) =>
    p.map (fun yw => (yw.1, fun a' => yw.2 (f a')))) (h (f a'))
  simpa only [PMF.channelJoint, PMF.map_bind, PMF.map_comp, Function.comp_def] using hm

/-- Finite input/output relabeling uses the inverse input equivalence and the
forward output equivalence. Either equivalence may be the identity. -/
theorem isSingularChannel_relabel_iff
    {alpha : Type u} {alpha' : Type u'} {beta : Type v} {beta' : Type v'}
    [Finite alpha] [Finite alpha'] [Finite beta] [Finite beta']
    (kappa : alpha → PMF beta) (eX : alpha ≃ alpha') (eY : beta ≃ beta') :
    IsSingularChannel (fun x' => (kappa (eX.symm x')).map eY) ↔
      IsSingularChannel kappa := by
  rw [isSingularChannel_map_iff _ eY eY.injective]
  constructor
  · intro h x1 x2 y h1 h2
    have hp := h (eX x1) (eX x2) y
    simp only [eX.symm_apply_apply] at hp
    exact hp h1 h2
  · intro h x1 x2 y h1 h2
    exact h (eX.symm x1) (eX.symm x2) y h1 h2

/-- Relabeling transports both the canonical vector law and its common
posterior. Nonempty target input is transferred along the input equivalence. -/
theorem isPerfectlyRepresentableChannel_relabel_iff
    {alpha : Type u} {alpha' : Type u'} {beta : Type v} {beta' : Type v'}
    [Finite alpha] [Finite alpha'] [Finite beta] [Finite beta'] [Nonempty alpha]
    (kappa : alpha → PMF beta) (eX : alpha ≃ alpha') (eY : beta ≃ beta') :
    let : Nonempty alpha' := Nonempty.map eX ‹Nonempty alpha›
    IsPerfectlyRepresentableChannel (fun x' => (kappa (eX.symm x')).map eY) ↔
      IsPerfectlyRepresentableChannel kappa := by
  let : Nonempty alpha' := Nonempty.map eX ‹Nonempty alpha›
  refine (isPerfectlyRepresentableChannel_map_iff
    (fun x' => kappa (eX.symm x')) eY eY.injective).trans ?_
  constructor
  · intro h
    have hp := perfect_precomp (fun x' => kappa (eX.symm x')) eX h
    simpa only [eX.symm_apply_apply] using hp
  · exact perfect_precomp kappa eX.symm

/-! ## PFR-C03-S03: active-output restriction and support interpretation -/

/-- Outputs with positive mass in at least one row, independent of any input law. -/
def activeOutputs {alpha : Type u} {beta : Type v} (kappa : alpha → PMF beta) : Set beta :=
  {y | ∃ x, y ∈ (kappa x).support}

/-- Restrict each row to globally active outputs by attaching support proofs.
No renormalization, finiteness or chosen default is required. -/
noncomputable def restrictActiveOutputs {alpha : Type u} {beta : Type v}
    (kappa : alpha → PMF beta) : alpha → PMF (activeOutputs kappa) :=
  fun x => (kappa x).bindOnSupport fun y hy => PMF.pure ⟨y, x, hy⟩

/-- Inclusion of active outputs recovers the original row exactly. -/
theorem map_val_restrictActiveOutputs {alpha : Type u} {beta : Type v}
    (kappa : alpha → PMF beta) (x : alpha) :
    (restrictActiveOutputs kappa x).map Subtype.val = kappa x := by
  change ((kappa x).bindOnSupport _).bind (PMF.pure ∘ Subtype.val) = kappa x
  rw [← PMF.bindOnSupport_eq_bind]
  simp only [PMF.bindOnSupport_bindOnSupport, PMF.pure_bindOnSupport,
    Function.comp_def, PMF.bindOnSupport_pure]

/-- Restriction preserves each active output mass without scaling. -/
theorem restrictActiveOutputs_apply {alpha : Type u} {beta : Type v}
    (kappa : alpha → PMF beta) (x : alpha) (a : activeOutputs kappa) :
    restrictActiveOutputs kappa x a = kappa x a.val := by
  rw [← map_val_restrictActiveOutputs kappa x]
  exact (PMF.map_apply_of_injective _ Subtype.val_injective a).symm

/-- A nonempty input supplies a row and therefore an active output. -/
theorem activeOutputs_nonempty {alpha : Type u} {beta : Type v} [Nonempty alpha]
    (kappa : alpha → PMF beta) : (activeOutputs kappa).Nonempty := by
  obtain ⟨x⟩ := ‹Nonempty alpha›
  obtain ⟨y, hy⟩ := (kappa x).support_nonempty
  exact ⟨y, x, hy⟩

/-- Every output of the restricted channel is active in some row. -/
theorem activeOutputs_restrictActiveOutputs {alpha : Type u} {beta : Type v}
    (kappa : alpha → PMF beta) : activeOutputs (restrictActiveOutputs kappa) = Set.univ := by
  ext a
  simp only [Set.mem_univ, iff_true]
  obtain ⟨x, hx⟩ := a.property
  exact ⟨x, by simpa only [PMF.mem_support_iff, restrictActiveOutputs_apply] using hx⟩

/-- Deleting globally unused outputs preserves singularity at the finite boundary. -/
theorem isSingularChannel_restrictActiveOutputs_iff {alpha : Type u} {beta : Type v}
    [Finite alpha] [Finite beta] (kappa : alpha → PMF beta) :
    IsSingularChannel (restrictActiveOutputs kappa) ↔ IsSingularChannel kappa := by
  simpa only [map_val_restrictActiveOutputs] using
    (isSingularChannel_map_iff (restrictActiveOutputs kappa) Subtype.val
      Subtype.val_injective).symm

/-- Deleting globally unused outputs preserves the complete common-posterior
perfectness property. The only nonempty assumption is on the input. -/
theorem isPerfectlyRepresentableChannel_restrictActiveOutputs_iff
    {alpha : Type u} {beta : Type v} [Finite alpha] [Finite beta] [Nonempty alpha]
    (kappa : alpha → PMF beta) :
    IsPerfectlyRepresentableChannel (restrictActiveOutputs kappa) ↔
      IsPerfectlyRepresentableChannel kappa := by
  simpa only [map_val_restrictActiveOutputs] using
    (isPerfectlyRepresentableChannel_map_iff (restrictActiveOutputs kappa) Subtype.val
      Subtype.val_injective).symm

/-- Under full input support, the pair's output support is the intrinsic union
of all channel rows. A degenerate prior requires C02's input-support restriction. -/
theorem support_sndMarginal_channelJoint_eq_activeOutputs_of_fullSupport
    {alpha : Type u} {beta : Type v} (p : PMF alpha) (kappa : alpha → PMF beta)
    (hp : ∀ x, x ∈ p.support) :
    (LeanInfoTheory.Shannon.sndMarginal (PMF.channelJoint p kappa)).support =
      activeOutputs kappa := by
  ext y
  change y ∈ ((PMF.channelJoint p kappa).map Prod.snd).support ↔ _
  rw [PMF.channelJoint_map_snd, PMF.mem_support_bind_iff]
  constructor
  · rintro ⟨x, _, hy⟩
    exact ⟨x, hy⟩
  · rintro ⟨x, hy⟩
    exact ⟨x, hp x, hy⟩

/-! ## PFR-C03-S04: sufficiency for at most two active outputs -/

private theorem perfect_constant {alpha : Type u} {beta : Type v}
    [Nonempty alpha] (p : PMF beta) :
    IsPerfectlyRepresentableChannel (fun _ : alpha => p) := by
  refine ⟨p.map (fun y => fun _ : alpha => y),
    (fun y => PMF.pure (fun _ : alpha => y)), ?_⟩
  intro x
  simp only [PMF.map_comp, PMF.channelJoint, PMF.pure_map, Function.comp_def]
  rfl

private theorem perfect_deterministic {alpha : Type u} {beta : Type v}
    [Nonempty alpha] (f : alpha → beta) :
    IsPerfectlyRepresentableChannel (fun x => PMF.pure (f x)) := by
  refine ⟨PMF.pure f, (fun _ => PMF.pure f), ?_⟩
  intro x
  simp only [PMF.pure_map, PMF.channelJoint, PMF.pure_bind]

-- No output enumeration: normalization rules out strict pointwise domination.
private theorem singular_smallOutput_dichotomy {alpha : Type u} {beta : Type v} [Fintype beta]
    (kappa : alpha → PMF beta) (hcard : Fintype.card beta ≤ 2)
    (hs : IsSingularChannel kappa) :
    (∃ row : PMF beta, ∀ x, kappa x = row) ∨
      ∃ f : alpha → beta, ∀ x, kappa x = PMF.pure (f x) := by
  classical
  by_cases hm : ∃ x a b, a ≠ b ∧ a ∈ (kappa x).support ∧ b ∈ (kappa x).support
  · obtain ⟨x0, a, b, hab, ha, hb⟩ := hm
    have hcover (y : beta) : y = a ∨ y = b := by
      by_contra h
      push Not at h
      have hthree := Fintype.two_lt_card_iff.mpr ⟨a, b, y, hab, h.1.symm, h.2.symm⟩
      omega
    have hfull (y : beta) : kappa x0 y ≠ 0 := by
      obtain rfl | rfl := hcover y
      · exact ha
      · exact hb
    refine Or.inl ⟨kappa x0, ?_⟩
    intro x
    have hle (y : beta) : kappa x y ≤ kappa x0 y := by
      by_cases hy : kappa x y = 0
      · simp [hy]
      · exact le_of_eq (hs x x0 y hy (hfull y))
    apply PMF.ext
    intro y
    by_contra hne
    have hlt := ENNReal.tsum_lt_tsum (kappa x).tsum_coe_ne_top hle
      (lt_of_le_of_ne (hle y) hne)
    simp only [PMF.tsum_coe, lt_self_iff_false] at hlt
  · have hpure (x : alpha) : ∃ y, kappa x = PMF.pure y := by
      obtain ⟨y, hy⟩ := (kappa x).support_nonempty
      refine ⟨y, (PMF.eq_pure_iff_support_eq_singleton _ _).2 ?_⟩
      ext z
      constructor
      · intro hz
        change z = y
        by_contra hzy
        exact hm ⟨x, z, y, hzy, hz, hy⟩
      · intro hz
        have hzy : z = y := hz
        simpa only [hzy] using hy
    choose f hf using hpure
    exact Or.inr ⟨f, hf⟩

-- Retain the approved explicit finite-enumeration boundary for both alphabets.
set_option linter.unusedFintypeInType false in
/-- On a finite output alphabet of cardinality at most two, singularity is
equivalent to perfect representability. Singleton outputs are included. -/
theorem isPerfectlyRepresentableChannel_iff_isSingular_of_card_le_two
    {alpha : Type u} {beta : Type v} [Fintype alpha] [Fintype beta] [Nonempty alpha]
    (kappa : alpha → PMF beta) (hcard : Fintype.card beta ≤ 2) :
    IsPerfectlyRepresentableChannel kappa ↔ IsSingularChannel kappa := by
  constructor
  · exact fun h => h.isSingular
  · intro hs
    obtain ⟨row, hrow⟩ | ⟨f, hf⟩ := singular_smallOutput_dichotomy kappa hcard hs
    · have hk : kappa = fun _ => row := funext hrow
      rw [hk]
      exact perfect_constant row
    · have hk : kappa = fun x => PMF.pure (f x) := funext hf
      rw [hk]
      exact perfect_deterministic f

set_option linter.unusedFintypeInType false in
/-- Singularity is equivalent to perfect representability when the union of all
row supports contains at most two outputs. The active subtype's enumeration is internal;
globally unused ambient outputs impose no additional hypothesis. -/
theorem isPerfectlyRepresentableChannel_iff_isSingular_of_activeOutputs_card_le_two
    {alpha : Type u} {beta : Type v} [Fintype alpha] [Fintype beta] [Nonempty alpha]
    (kappa : alpha → PMF beta) :
    let : Fintype (activeOutputs kappa) := Fintype.ofFinite _
    Fintype.card (activeOutputs kappa) ≤ 2 →
      (IsPerfectlyRepresentableChannel kappa ↔ IsSingularChannel kappa) := by
  classical
  let : Fintype (activeOutputs kappa) := Fintype.ofFinite _
  change Fintype.card (activeOutputs kappa) ≤ 2 →
    (IsPerfectlyRepresentableChannel kappa ↔ IsSingularChannel kappa)
  intro hcard
  rw [← isPerfectlyRepresentableChannel_restrictActiveOutputs_iff,
    ← isSingularChannel_restrictActiveOutputs_iff]
  exact isPerfectlyRepresentableChannel_iff_isSingular_of_card_le_two
    (restrictActiveOutputs kappa) hcard

end PerfectFunctionalRepresentations
