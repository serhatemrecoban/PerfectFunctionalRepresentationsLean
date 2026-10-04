import PerfectFunctionalRepresentations.Semantics.FunctionalRepresentation

/-!
# Canonical functional representations

The function alphabet `alpha → beta` represents the canonical vector in
ISIT Section II-A, Definition 1. A coupling specifies its coordinate laws.
A canonical representation of a fixed pair additionally retains independence
and evaluation decoding on support. These structural contracts do not require
finite or inhabited alphabets. Input rows outside a prior's support remain
unconstrained by the resulting pair law.
-/

namespace PerfectFunctionalRepresentations

open LeanInfoTheory.Shannon

universe u v w x

/-- A vector law couples all rows of a channel through coordinate evaluation. -/
def IsCanonicalCoupling {alpha : Type u} {beta : Type v}
    (kappa : alpha → PMF beta) (q : PMF (alpha → beta)) : Prop :=
  ∀ a, q.map (fun f => f a) = kappa a

/-- Independently sample an input and vector, then evaluate the vector at that input. -/
noncomputable def canonicalJoint {alpha : Type u} {beta : Type v}
    (p : PMF alpha) (q : PMF (alpha → beta)) : PMF (alpha × beta × (alpha → beta)) :=
  (indepProd p q).map fun af => (af.1, af.2 af.1, af.2)

/-- A fixed triple is canonical when the vector is independent of the input and decodes
the output by evaluation on the triple law's support. Coordinate marginals alone do not
establish this fixed-pair condition. -/
def IsCanonicalFunctionalRepresentation {alpha : Type u} {beta : Type v}
    (r : PMF (alpha × beta × (alpha → beta))) : Prop :=
  IsIndependent (fstThirdMarginal r) ∧ ∀ t ∈ r.support, t.2.1 = t.2.2 t.1

/-- Common-source canonicality is defined through the full triple pushforward law. -/
def IsCanonicalFunctionalRepresentationOf {omega : Type u} {alpha : Type v}
    {beta : Type w} (p : PMF omega) (X : omega → alpha) (Y : omega → beta)
    (W : omega → alpha → beta) : Prop :=
  IsCanonicalFunctionalRepresentation (p.map fun s => (X s, Y s, W s))

/-- The common-source contract retains independence and evaluation on source support. -/
theorem isCanonicalFunctionalRepresentationOf_iff {omega : Type u} {alpha : Type v}
    {beta : Type w} (p : PMF omega) (X : omega → alpha) (Y : omega → beta)
    (W : omega → alpha → beta) :
    IsCanonicalFunctionalRepresentationOf p X Y W ↔
      IsIndependentOf p X W ∧ ∀ s ∈ p.support, Y s = W s (X s) := by
  unfold IsCanonicalFunctionalRepresentationOf IsCanonicalFunctionalRepresentation
  constructor
  · rintro ⟨hI, hD⟩
    refine ⟨by simpa [IsIndependentOf] using hI, ?_⟩
    intro s hs
    exact hD (X s, Y s, W s) (by rw [PMF.mem_support_map_iff]; exact ⟨s, hs, rfl⟩)
  · rintro ⟨hI, hD⟩
    refine ⟨by simpa [IsIndependentOf] using hI, ?_⟩
    intro t ht
    rw [PMF.mem_support_map_iff] at ht
    rcases ht with ⟨s, hs, rfl⟩
    exact hD s hs

/-- Evaluation is a support-correct decoder in C01's structural sense. -/
theorem IsCanonicalFunctionalRepresentation.isFunctionalRepresentation
    {alpha : Type u} {beta : Type v} {r : PMF (alpha × beta × (alpha → beta))}
    (h : IsCanonicalFunctionalRepresentation r) : IsFunctionalRepresentation r :=
  ⟨h.1, (fun af => af.2 af.1), h.2⟩

/-- A common-source canonical representation is a C01 functional representation. -/
theorem IsCanonicalFunctionalRepresentationOf.isFunctionalRepresentationOf
    {omega : Type u} {alpha : Type v} {beta : Type w} {p : PMF omega}
    {X : omega → alpha} {Y : omega → beta} {W : omega → alpha → beta}
    (h : IsCanonicalFunctionalRepresentationOf p X Y W) :
    IsFunctionalRepresentationOf p X Y W :=
  IsCanonicalFunctionalRepresentation.isFunctionalRepresentation h

/-- Equal full triple laws transport common-source canonicality. -/
theorem isCanonicalFunctionalRepresentationOf_congr_jointLaw
    {omega : Type u} {omega' : Type v} {alpha : Type w} {beta : Type x}
    {p : PMF omega} {p' : PMF omega'} {X : omega → alpha} {Y : omega → beta}
    {W : omega → alpha → beta} {X' : omega' → alpha} {Y' : omega' → beta}
    {W' : omega' → alpha → beta}
    (hLaw : p.map (fun s => (X s, Y s, W s)) =
      p'.map (fun s => (X' s, Y' s, W' s))) :
    IsCanonicalFunctionalRepresentationOf p X Y W ↔
      IsCanonicalFunctionalRepresentationOf p' X' Y' W' := by
  unfold IsCanonicalFunctionalRepresentationOf
  rw [hLaw]

/-- The input marginal of the canonical joint is the given prior. -/
@[simp] theorem fstMarginal_canonicalJoint {alpha : Type u} {beta : Type v}
    (p : PMF alpha) (q : PMF (alpha → beta)) :
    fstMarginal (canonicalJoint p q) = p := by
  simpa only [canonicalJoint, fstMarginal_map] using fstMarginal_indepProd p q

/-- The vector marginal of the canonical joint is the given vector law. -/
@[simp] theorem thirdMarginal_canonicalJoint {alpha : Type u} {beta : Type v}
    (p : PMF alpha) (q : PMF (alpha → beta)) :
    thirdMarginal (canonicalJoint p q) = q := by
  simpa only [canonicalJoint, thirdMarginal, PMF.map_comp, Function.comp_def]
    using sndMarginal_indepProd p q

/-- The input and vector have exactly their independent product law. -/
@[simp] theorem fstThirdMarginal_canonicalJoint {alpha : Type u} {beta : Type v}
    (p : PMF alpha) (q : PMF (alpha → beta)) :
    fstThirdMarginal (canonicalJoint p q) = indepProd p q := by
  rw [canonicalJoint, fstThirdMarginal_map_triple]
  have hmap : (fun af : alpha × (alpha → beta) => (af.1, af.2)) = id := by
    funext af
    exact Prod.eta af
  rw [hmap, PMF.map_id]

/-- Independent sampling followed by evaluation always gives a canonical triple. -/
theorem isCanonicalFunctionalRepresentation_canonicalJoint {alpha : Type u} {beta : Type v}
    (p : PMF alpha) (q : PMF (alpha → beta)) :
    IsCanonicalFunctionalRepresentation (canonicalJoint p q) := by
  refine ⟨by rw [fstThirdMarginal_canonicalJoint]; exact isIndependent_indepProd p q, ?_⟩
  intro t ht
  rw [canonicalJoint, PMF.mem_support_map_iff] at ht
  rcases ht with ⟨af, _, rfl⟩
  rfl

private theorem map_eq_on_support {alpha : Type u} {beta : Type v}
    (p : PMF alpha) (f g : alpha → beta) (h : ∀ a ∈ p.support, f a = g a) :
    p.map f = p.map g := by
  classical
  apply PMF.ext
  intro b
  simp only [PMF.map_apply]
  apply tsum_congr
  intro a
  by_cases ha : a ∈ p.support
  · rw [h a ha]
  · have hz : p a = 0 := by simpa only [PMF.mem_support_iff, not_not] using ha
    simp [hz]

/-- A canonical triple is recovered from its input and vector marginals. -/
theorem isCanonicalFunctionalRepresentation_iff_eq_canonicalJoint
    {alpha : Type u} {beta : Type v} (r : PMF (alpha × beta × (alpha → beta))) :
    IsCanonicalFunctionalRepresentation r ↔
      r = canonicalJoint (fstMarginal r) (thirdMarginal r) := by
  constructor
  · intro h
    have hI : fstThirdMarginal r = indepProd (fstMarginal r) (thirdMarginal r) := by
      simpa only [IsIndependent, fstMarginal_map, sndMarginal_map] using h.1
    rw [canonicalJoint, ← hI, PMF.map_comp]
    calc
      r = r.map id := (PMF.map_id r).symm
      _ = r.map ((fun af : alpha × (alpha → beta) => (af.1, af.2 af.1, af.2)) ∘
          (fun t => (t.1, t.2.2))) := by
        apply map_eq_on_support
        intro t ht
        rcases t with ⟨a, b, f⟩
        dsimp
        have hb : b = f a := h.2 (a, b, f) ht
        rw [hb]
  · intro h
    rw [h]
    exact isCanonicalFunctionalRepresentation_canonicalJoint _ _

/-- The pair projection is the channel joint of the vector's coordinate laws. -/
theorem fstSndMarginal_canonicalJoint {alpha : Type u} {beta : Type v}
    (p : PMF alpha) (q : PMF (alpha → beta)) :
    fstSndMarginal (canonicalJoint p q) =
      PMF.channelJoint p (fun a => q.map (fun f => f a)) := by
  simp only [canonicalJoint, indepProd, PMF.channelJoint,
    PMF.map_bind, PMF.map_comp, Function.comp_def]

/-- A pair law determines channel rows precisely on its input support. -/
theorem fstSndMarginal_canonicalJoint_eq_iff {alpha : Type u} {beta : Type v}
    (p : PMF alpha) (q : PMF (alpha → beta)) (kappa : alpha → PMF beta) :
    fstSndMarginal (canonicalJoint p q) = PMF.channelJoint p kappa ↔
      ∀ a ∈ p.support, q.map (fun f => f a) = kappa a := by
  rw [fstSndMarginal_canonicalJoint, PMF.channelJoint_eq_iff_eq_on_support]

/-- A coupling realizes the channel joint for every input prior. -/
theorem IsCanonicalCoupling.fstSndMarginal_canonicalJoint
    {alpha : Type u} {beta : Type v} {kappa : alpha → PMF beta}
    {q : PMF (alpha → beta)} (h : IsCanonicalCoupling kappa q) (p : PMF alpha) :
    fstSndMarginal (canonicalJoint p q) = PMF.channelJoint p kappa :=
  (fstSndMarginal_canonicalJoint_eq_iff p q kappa).2 (fun a _ => h a)

/-- Under an explicit full-support prior, the pair equality determines all channel rows. -/
theorem fstSndMarginal_canonicalJoint_eq_iff_of_fullSupport
    {alpha : Type u} {beta : Type v} (p : PMF alpha) (q : PMF (alpha → beta))
    (kappa : alpha → PMF beta) (hp : ∀ a, a ∈ p.support) :
    fstSndMarginal (canonicalJoint p q) = PMF.channelJoint p kappa ↔
      IsCanonicalCoupling kappa q := by
  rw [fstSndMarginal_canonicalJoint_eq_iff]
  exact ⟨fun h a => h a (hp a), fun h a _ => h a⟩

/-- Equation (5): a decoder determines a vector by fixing its auxiliary input. -/
def decoderVector {alpha : Type u} {beta : Type v} {gamma : Type w}
    (decoder : alpha × gamma → beta) (z : gamma) (a : alpha) : beta :=
  decoder (a, z)

/-- Any support-correct decoder yields a canonical representation on the same source.
Neither the source nor the original auxiliary needs to be finite. -/
theorem isCanonicalFunctionalRepresentationOf_decoderVector
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    (mu : PMF omega) (X : omega → alpha) (Y : omega → beta) (Z : omega → gamma)
    (decoder : alpha × gamma → beta) (hI : IsIndependentOf mu X Z)
    (hD : ∀ s ∈ mu.support, Y s = decoder (X s, Z s)) :
    IsCanonicalFunctionalRepresentationOf mu X Y (fun s => decoderVector decoder (Z s)) := by
  rw [isCanonicalFunctionalRepresentationOf_iff]
  exact ⟨isIndependentOf_comp_right mu X Z (decoderVector decoder) hI, hD⟩

/-- A functional representation supplies a decoder whose vector is canonical.
The witness remains a deterministic function of the original auxiliary. -/
theorem IsFunctionalRepresentationOf.exists_canonical_decoder
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    {mu : PMF omega} {X : omega → alpha} {Y : omega → beta} {Z : omega → gamma}
    (h : IsFunctionalRepresentationOf mu X Y Z) :
    ∃ decoder : alpha × gamma → beta,
      IsCanonicalFunctionalRepresentationOf mu X Y (fun s => decoderVector decoder (Z s)) := by
  rcases (isFunctionalRepresentationOf_iff mu X Y Z).1 h with ⟨hI, decoder, hD⟩
  exact ⟨decoder, isCanonicalFunctionalRepresentationOf_decoderVector mu X Y Z decoder hI hD⟩

/-- A common-source canonical triple agrees with the canonical joint of its laws. -/
theorem IsCanonicalFunctionalRepresentationOf.jointLaw_eq_canonicalJoint
    {omega : Type u} {alpha : Type v} {beta : Type w}
    {mu : PMF omega} {X : omega → alpha} {Y : omega → beta} {W : omega → alpha → beta}
    (h : IsCanonicalFunctionalRepresentationOf mu X Y W) :
    mu.map (fun s => (X s, Y s, W s)) = canonicalJoint (mu.map X) (mu.map W) := by
  have hr := (isCanonicalFunctionalRepresentation_iff_eq_canonicalJoint _).1 h
  simpa only [fstMarginal_map, thirdMarginal, PMF.map_comp, Function.comp_def] using hr

/-- The canonical extension preserves the already specified pair law. -/
theorem IsCanonicalFunctionalRepresentationOf.fstSndMarginal_canonicalJoint
    {omega : Type u} {alpha : Type v} {beta : Type w}
    {mu : PMF omega} {X : omega → alpha} {Y : omega → beta} {W : omega → alpha → beta}
    (h : IsCanonicalFunctionalRepresentationOf mu X Y W) :
    fstSndMarginal (canonicalJoint (mu.map X) (mu.map W)) =
      mu.map (fun s => (X s, Y s)) := by
  have hp := congrArg fstSndMarginal h.jointLaw_eq_canonicalJoint
  simpa only [fstSndMarginal, PMF.map_comp, Function.comp_def] using hp.symm

/-- A supplied channel agrees with the vector's coordinate laws on input support. -/
theorem IsCanonicalFunctionalRepresentationOf.coordinateLaw_eq_of_mem_support
    {omega : Type u} {alpha : Type v} {beta : Type w}
    {mu : PMF omega} {X : omega → alpha} {Y : omega → beta} {W : omega → alpha → beta}
    (h : IsCanonicalFunctionalRepresentationOf mu X Y W) (kappa : alpha → PMF beta)
    (hPair : mu.map (fun s => (X s, Y s)) = PMF.channelJoint (mu.map X) kappa)
    (a : alpha) (ha : a ∈ (mu.map X).support) :
    (mu.map W).map (fun f => f a) = kappa a :=
  (fstSndMarginal_canonicalJoint_eq_iff (mu.map X) (mu.map W) kappa).1
    (h.fstSndMarginal_canonicalJoint.trans hPair) a ha

/-- Full input support upgrades the coordinate laws to an all-row coupling. -/
theorem IsCanonicalFunctionalRepresentationOf.isCanonicalCoupling_of_fullSupport
    {omega : Type u} {alpha : Type v} {beta : Type w}
    {mu : PMF omega} {X : omega → alpha} {Y : omega → beta} {W : omega → alpha → beta}
    (h : IsCanonicalFunctionalRepresentationOf mu X Y W) (kappa : alpha → PMF beta)
    (hPair : mu.map (fun s => (X s, Y s)) = PMF.channelJoint (mu.map X) kappa)
    (hFull : ∀ a, a ∈ (mu.map X).support) : IsCanonicalCoupling kappa (mu.map W) :=
  fun a => h.coordinateLaw_eq_of_mem_support kappa hPair a (hFull a)

/-! ## Information preservation and finite canonical sufficiency

The source remains unrestricted. Information statements use finite input,
output and original auxiliary alphabets. The function alphabet's enumeration
is an instance parameter so consumers can use their own induced `Fintype`.
-/

private theorem decoderVector_condMutualInfoOf_le
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    [Fintype alpha] [Fintype beta] [Fintype gamma] [Fintype (alpha → beta)]
    (mu : PMF omega) (X : omega → alpha) (Y : omega → beta) (Z : omega → gamma)
    (decoder : alpha × gamma → beta) :
    condMutualInfoOf mu X (fun s => decoderVector decoder (Z s)) Y ≤
      condMutualInfoOf mu X Z Y := by
  have h := mutualInfoOf_comp_right_le mu X (fun s => (Z s, Y s))
    (fun zy => (decoderVector decoder zy.1, zy.2))
  change mutualInfoOf mu X (fun s => (decoderVector decoder (Z s), Y s)) ≤
    mutualInfoOf mu X (fun s => (Z s, Y s)) at h
  rw [mutualInfoOf_chain_rule_fst, mutualInfoOf_chain_rule_fst] at h
  exact (add_le_add_iff_left (mutualInfoOf mu X Y)).1 h

/-- Property 4 and Lemma 1: canonicalization through any support-correct decoder
preserves information about the output at the finite-value boundary. -/
theorem mutualInfoOf_decoderVector_eq
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    [Finite alpha] [Fintype beta] [Fintype gamma] [Fintype (alpha → beta)]
    (mu : PMF omega) (X : omega → alpha) (Y : omega → beta) (Z : omega → gamma)
    (decoder : alpha × gamma → beta) (hI : IsIndependentOf mu X Z)
    (hD : ∀ s ∈ mu.support, Y s = decoder (X s, Z s)) :
    mutualInfoOf mu Y (fun s => decoderVector decoder (Z s)) = mutualInfoOf mu Y Z := by
  let := Fintype.ofFinite alpha
  have hFR : IsFunctionalRepresentationOf mu X Y Z :=
    (isFunctionalRepresentationOf_iff _ _ _ _).2 ⟨hI, decoder, hD⟩
  have hCanonical :=
    isCanonicalFunctionalRepresentationOf_decoderVector mu X Y Z decoder hI hD
  have hOriginalIdentity := hFR.mutualInfoOf_eq_condEntropyOf_sub_condMutualInfoOf
  have hCanonicalIdentity :=
    hCanonical.isFunctionalRepresentationOf.mutualInfoOf_eq_condEntropyOf_sub_condMutualInfoOf
  -- Equation (7), with exactly the manuscript's orientation.
  have hEqSeven :
      mutualInfoOf mu Y Z - mutualInfoOf mu Y (fun s => decoderVector decoder (Z s)) =
        condMutualInfoOf mu X (fun s => decoderVector decoder (Z s)) Y -
          condMutualInfoOf mu X Z Y := by
    linarith
  -- Its left side is nonnegative and its right side is nonpositive.
  have hMI := mutualInfoOf_comp_right_le mu Y Z (decoderVector decoder)
  have hCMI := decoderVector_condMutualInfoOf_le mu X Y Z decoder
  linarith

/-- A finite functional representation admits an equally informative canonical
replacement of the same pair on the same, unrestricted source. -/
theorem IsFunctionalRepresentationOf.exists_canonical_preserving_mutualInfo
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    [Finite alpha] [Fintype beta] [Fintype gamma] [Fintype (alpha → beta)]
    {mu : PMF omega} {X : omega → alpha} {Y : omega → beta} {Z : omega → gamma}
    (h : IsFunctionalRepresentationOf mu X Y Z) :
    ∃ W : omega → alpha → beta,
      IsCanonicalFunctionalRepresentationOf mu X Y W ∧
      mutualInfoOf mu Y W = mutualInfoOf mu Y Z := by
  obtain ⟨hI, decoder, hD⟩ := (isFunctionalRepresentationOf_iff _ _ _ _).1 h
  exact ⟨fun s => decoderVector decoder (Z s),
    isCanonicalFunctionalRepresentationOf_decoderVector mu X Y Z decoder hI hD,
    mutualInfoOf_decoderVector_eq mu X Y Z decoder hI hD⟩

/-- Any support-correct decoder of a finite perfect auxiliary produces a perfect
canonical auxiliary for the same pair. -/
theorem IsPerfectFunctionalRepresentationOf.decoderVector
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    [Fintype alpha] [Fintype beta] [Fintype gamma] [Fintype (alpha → beta)]
    {mu : PMF omega} {X : omega → alpha} {Y : omega → beta} {Z : omega → gamma}
    (h : IsPerfectFunctionalRepresentationOf mu X Y Z) (decoder : alpha × gamma → beta)
    (hD : ∀ s ∈ mu.support, Y s = decoder (X s, Z s)) :
    IsPerfectFunctionalRepresentationOf mu X Y
      (fun s => PerfectFunctionalRepresentations.decoderVector decoder (Z s)) := by
  obtain ⟨hFR, hEq⟩ := (isPerfectFunctionalRepresentationOf_iff _ _ _ _).1 h
  have hI := ((isFunctionalRepresentationOf_iff _ _ _ _).1 hFR).1
  have hCanonical :=
    isCanonicalFunctionalRepresentationOf_decoderVector mu X Y Z decoder hI hD
  apply (isPerfectFunctionalRepresentationOf_iff _ _ _ _).2
  exact ⟨hCanonical.isFunctionalRepresentationOf,
    (mutualInfoOf_decoderVector_eq mu X Y Z decoder hI hD).trans hEq⟩

/-- A specified finite perfect auxiliary has a canonical perfect replacement
without changing its source, input or output. -/
theorem IsPerfectFunctionalRepresentationOf.exists_canonical
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    [Fintype alpha] [Fintype beta] [Fintype gamma] [Fintype (alpha → beta)]
    {mu : PMF omega} {X : omega → alpha} {Y : omega → beta} {Z : omega → gamma}
    (h : IsPerfectFunctionalRepresentationOf mu X Y Z) :
    ∃ W : omega → alpha → beta,
      IsCanonicalFunctionalRepresentationOf mu X Y W ∧
      IsPerfectFunctionalRepresentationOf mu X Y W := by
  obtain ⟨hFR, _⟩ := (isPerfectFunctionalRepresentationOf_iff _ _ _ _).1 h
  obtain ⟨hI, decoder, hD⟩ := (isFunctionalRepresentationOf_iff _ _ _ _).1 hFR
  exact ⟨fun s => PerfectFunctionalRepresentations.decoderVector decoder (Z s),
    isCanonicalFunctionalRepresentationOf_decoderVector mu X Y Z decoder hI hD,
    h.decoderVector decoder hD⟩

/-- At C01's finite-information boundary, perfect pair representability is
equivalent to a perfect canonical joint with exactly the specified pair marginal.
This keeps C01's `Fin n` witness predicate unchanged. -/
theorem isPerfectlyRepresentablePair_iff_exists_canonicalJoint
    {alpha : Type u} {beta : Type v}
    [Fintype alpha] [Fintype beta] [Fintype (alpha → beta)]
    (pXY : PMF (alpha × beta)) :
    IsPerfectlyRepresentablePair pXY ↔
      ∃ q : PMF (alpha → beta),
        fstSndMarginal (canonicalJoint (fstMarginal pXY) q) = pXY ∧
        IsPerfectFunctionalRepresentation (canonicalJoint (fstMarginal pXY) q) := by
  constructor
  · rintro ⟨n, r, hPair, hPerfect⟩
    have hPerfectOf : IsPerfectFunctionalRepresentationOf r (fun t => t.1)
        (fun t => t.2.1) (fun t => t.2.2) := by
      unfold IsPerfectFunctionalRepresentationOf
      have hId : (fun t : alpha × beta × Fin n => (t.1, t.2.1, t.2.2)) = id := by
        funext t
        simp only [Prod.eta, id_eq]
      rw [hId, PMF.map_id]
      exact hPerfect
    obtain ⟨W, hC, hP⟩ := hPerfectOf.exists_canonical
    have hx : r.map (fun t => t.1) = fstMarginal pXY := by
      rw [← hPair]
      simp only [fstMarginal, fstSndMarginal, PMF.map_comp, Function.comp_def]
    have hp : IsPerfectFunctionalRepresentation
        (canonicalJoint (r.map (fun t => t.1)) (r.map W)) := by
      rw [← hC.jointLaw_eq_canonicalJoint]
      exact hP
    refine ⟨r.map W, ?_, ?_⟩
    · rw [← hx]
      exact hC.fstSndMarginal_canonicalJoint.trans hPair
    · rwa [hx] at hp
  · rintro ⟨q, hPair, hPerfect⟩
    rw [← hPair]
    exact hPerfect.isPerfectlyRepresentablePair

/-! ## Common posterior and intrinsic channel perfectness

Definition 2 uses one vector law and one posterior for every input row.
Lower-level factorization identities retain support restrictions explicitly;
the intrinsic channel interface uses the manuscript's nonempty input alphabet.
-/

/-- A channel is perfectly representable when one vector law and one posterior
factor every coordinate joint law. The input alphabet is nonempty; no prior,
finite alphabet or full output support is part of this structural definition. -/
def IsPerfectlyRepresentableChannel {alpha : Type u} {beta : Type v} [Nonempty alpha]
    (kappa : alpha → PMF beta) : Prop :=
  ∃ q : PMF (alpha → beta), ∃ V : beta → PMF (alpha → beta),
    ∀ a, q.map (fun f => (f a, f)) = PMF.channelJoint (kappa a) V

/-- Coordinate factorization implies the coupling condition by first projection. -/
theorem isCanonicalCoupling_of_coordinateFactorization {alpha : Type u} {beta : Type v}
    (q : PMF (alpha → beta)) (kappa : alpha → PMF beta)
    (V : beta → PMF (alpha → beta))
    (h : ∀ a, q.map (fun f => (f a, f)) = PMF.channelJoint (kappa a) V) :
    IsCanonicalCoupling kappa q := by
  intro a
  have hm := congrArg (fun r : PMF (beta × (alpha → beta)) => r.map Prod.fst) (h a)
  simpa only [PMF.map_comp, Function.comp_def, PMF.channelJoint_map_fst] using hm

private theorem canonicalJoint_eq_channelJoint {alpha : Type u} {beta : Type v}
    (p : PMF alpha) (q : PMF (alpha → beta)) :
    canonicalJoint p q = PMF.channelJoint p (fun a => q.map (fun f => (f a, f))) := by
  simp only [canonicalJoint, indepProd, PMF.channelJoint,
    PMF.map_bind, PMF.map_comp, Function.comp_def]

private theorem channelExtension_channelJoint_eq {alpha : Type u} {beta : Type v}
    (p : PMF alpha) (kappa : alpha → PMF beta) (V : beta → PMF (alpha → beta)) :
    PMF.channelExtension (PMF.channelJoint p kappa) V =
      PMF.channelJoint p (fun a => PMF.channelJoint (kappa a) V) := by
  simp only [PMF.channelExtension, PMF.channelJoint, PMF.bind_bind,
    PMF.bind_map, PMF.map_bind, PMF.map_comp, Function.comp_def]

/-- For a fixed posterior, a prior sees exactly the supported coordinate factorizations. -/
theorem canonicalJoint_eq_channelExtension_iff {alpha : Type u} {beta : Type v}
    (p : PMF alpha) (q : PMF (alpha → beta)) (kappa : alpha → PMF beta)
    (V : beta → PMF (alpha → beta)) :
    canonicalJoint p q = PMF.channelExtension (PMF.channelJoint p kappa) V ↔
      ∀ a ∈ p.support, q.map (fun f => (f a, f)) = PMF.channelJoint (kappa a) V := by
  rw [canonicalJoint_eq_channelJoint, channelExtension_channelJoint_eq,
    PMF.channelJoint_eq_iff_eq_on_support]

/-- Full input support upgrades fixed-posterior factorization to every input row. -/
theorem canonicalJoint_eq_channelExtension_iff_of_fullSupport
    {alpha : Type u} {beta : Type v}
    (p : PMF alpha) (q : PMF (alpha → beta)) (kappa : alpha → PMF beta)
    (V : beta → PMF (alpha → beta)) (hp : ∀ a, a ∈ p.support) :
    canonicalJoint p q = PMF.channelExtension (PMF.channelJoint p kappa) V ↔
      ∀ a, q.map (fun f => (f a, f)) = PMF.channelJoint (kappa a) V := by
  rw [canonicalJoint_eq_channelExtension_iff]
  exact ⟨fun h a => h a (hp a), fun h a _ => h a⟩

/-- One common posterior yields a canonical Markov triple under every prior. -/
theorem isMarkovChain_canonicalJoint_of_coordinateFactorization
    {alpha : Type u} {beta : Type v} [Nonempty alpha]
    (p : PMF alpha) (q : PMF (alpha → beta)) (kappa : alpha → PMF beta)
    (V : beta → PMF (alpha → beta))
    (h : ∀ a, q.map (fun f => (f a, f)) = PMF.channelJoint (kappa a) V) :
    IsMarkovChain (canonicalJoint p q) := by
  rw [(canonicalJoint_eq_channelExtension_iff p q kappa V).2 (fun a _ => h a)]
  exact isMarkovChain_channelExtension _ _

/-- For a fixed coupling and a full-support prior, canonical Markov factorization
is equivalent to one posterior for all channel rows. Finite function alphabet
is needed only for extracting the posterior from the pinned Markov theorem. -/
theorem IsCanonicalCoupling.exists_commonPosterior_iff_isMarkovChain
    {alpha : Type u} {beta : Type v} [Nonempty alpha] [Finite (alpha → beta)]
    {kappa : alpha → PMF beta} {q : PMF (alpha → beta)}
    (hC : IsCanonicalCoupling kappa q) (p : PMF alpha) (hp : ∀ a, a ∈ p.support) :
    (∃ V : beta → PMF (alpha → beta),
      ∀ a, q.map (fun f => (f a, f)) = PMF.channelJoint (kappa a) V) ↔
      IsMarkovChain (canonicalJoint p q) := by
  constructor
  · rintro ⟨V, h⟩
    exact isMarkovChain_canonicalJoint_of_coordinateFactorization p q kappa V h
  · intro h
    obtain ⟨V, hV⟩ := (isMarkovChain_iff_exists_channelExtension _).1 h
    rw [hC.fstSndMarginal_canonicalJoint p] at hV
    exact ⟨V, (canonicalJoint_eq_channelExtension_iff_of_fullSupport p q kappa V hp).1 hV⟩

/-- Changing a posterior only at outputs unused by every row preserves the
coordinate factorizations. No uniqueness at null output fibers is asserted. -/
theorem coordinateFactorization_congr_posterior {alpha : Type u} {beta : Type v}
    (q : PMF (alpha → beta)) (kappa : alpha → PMF beta)
    (V V' : beta → PMF (alpha → beta))
    (h : ∀ b, (∃ a, b ∈ (kappa a).support) → V b = V' b) :
    (∀ a, q.map (fun f => (f a, f)) = PMF.channelJoint (kappa a) V) ↔
      ∀ a, q.map (fun f => (f a, f)) = PMF.channelJoint (kappa a) V' := by
  have heq (a : alpha) : PMF.channelJoint (kappa a) V = PMF.channelJoint (kappa a) V' :=
    (PMF.channelJoint_eq_iff_eq_on_support (kappa a) V V').2 (fun b hb => h b ⟨a, hb⟩)
  simp only [heq]

/-- A canonical joint already has the structural representation property, so
its finite perfectness is equivalent to the Markov condition. -/
theorem isPerfectFunctionalRepresentation_canonicalJoint_iff_isMarkovChain
    {alpha : Type u} {beta : Type v}
    [Fintype alpha] [Fintype beta] [Fintype (alpha → beta)]
    (p : PMF alpha) (q : PMF (alpha → beta)) :
    IsPerfectFunctionalRepresentation (canonicalJoint p q) ↔
      IsMarkovChain (canonicalJoint p q) := by
  have hFR := (isCanonicalFunctionalRepresentation_canonicalJoint p q).isFunctionalRepresentation
  have hId : (fun t : alpha × beta × (alpha → beta) => (t.1, t.2.1, t.2.2)) = id := by
    funext t
    simp only [Prod.eta, id_eq]
  have hFRof : IsFunctionalRepresentationOf (canonicalJoint p q)
      (fun t => t.1) (fun t => t.2.1) (fun t => t.2.2) := by
    unfold IsFunctionalRepresentationOf
    rw [hId, PMF.map_id]
    exact hFR
  change (IsFunctionalRepresentation (canonicalJoint p q) ∧ _) ↔ _
  rw [and_iff_right hFR]
  exact hFRof.mutualInfoOf_eq_condEntropyOf_iff_isMarkovChainOf

/-- One common posterior yields a perfect canonical triple for any input prior
at the finite-information boundary. -/
theorem isPerfectFunctionalRepresentation_canonicalJoint_of_coordinateFactorization
    {alpha : Type u} {beta : Type v} [Nonempty alpha]
    [Fintype alpha] [Fintype beta] [Fintype (alpha → beta)]
    (p : PMF alpha) (q : PMF (alpha → beta)) (kappa : alpha → PMF beta)
    (V : beta → PMF (alpha → beta))
    (h : ∀ a, q.map (fun f => (f a, f)) = PMF.channelJoint (kappa a) V) :
    IsPerfectFunctionalRepresentation (canonicalJoint p q) :=
  (isPerfectFunctionalRepresentation_canonicalJoint_iff_isMarkovChain p q).2
    (isMarkovChain_canonicalJoint_of_coordinateFactorization p q kappa V h)

/-! ## Prior independence and full-support pair equivalence

Remark 1 reuses a vector law on fresh canonical joints. Pair perfectness for
an existing source is transported by its pair law; it does not provide an
auxiliary on that original source. Recovering the entire channel from one
pair retains full input support.
-/

/-- One coupling law gives perfect canonical joints for every prior. The
coupling's pair-marginal theorem identifies the same channel under each prior. -/
theorem IsPerfectlyRepresentableChannel.exists_canonicalCoupling
    {alpha : Type u} {beta : Type v} [Nonempty alpha]
    [Fintype alpha] [Fintype beta] [Fintype (alpha → beta)]
    {kappa : alpha → PMF beta} (h : IsPerfectlyRepresentableChannel kappa) :
    ∃ q : PMF (alpha → beta), IsCanonicalCoupling kappa q ∧
      ∀ p : PMF alpha, IsPerfectFunctionalRepresentation (canonicalJoint p q) := by
  obtain ⟨q, V, hV⟩ := h
  exact ⟨q, isCanonicalCoupling_of_coordinateFactorization q kappa V hV,
    fun p => isPerfectFunctionalRepresentation_canonicalJoint_of_coordinateFactorization
      p q kappa V hV⟩

/-- An intrinsically perfect channel gives a perfectly representable pair
under every prior, including priors with zero-probability inputs. -/
theorem IsPerfectlyRepresentableChannel.isPerfectlyRepresentablePair
    {alpha : Type u} {beta : Type v} [Nonempty alpha]
    [Fintype alpha] [Fintype beta]
    {kappa : alpha → PMF beta} (h : IsPerfectlyRepresentableChannel kappa)
    (p : PMF alpha) : IsPerfectlyRepresentablePair (PMF.channelJoint p kappa) := by
  classical
  obtain ⟨q, hC, hP⟩ := h.exists_canonicalCoupling
  rw [← hC.fstSndMarginal_canonicalJoint p]
  exact (hP p).isPerfectlyRepresentablePair

/-- Pair perfectness under a specified full-support prior is equivalent to
the intrinsic channel property. The converse uses finite canonical sufficiency
before extracting the common posterior. -/
theorem isPerfectlyRepresentablePair_channelJoint_iff_of_fullSupport
    {alpha : Type u} {beta : Type v} [Nonempty alpha]
    [Fintype alpha] [Fintype beta]
    (p : PMF alpha) (kappa : alpha → PMF beta) (hp : ∀ a, a ∈ p.support) :
    IsPerfectlyRepresentablePair (PMF.channelJoint p kappa) ↔
      IsPerfectlyRepresentableChannel kappa := by
  classical
  constructor
  · intro h
    obtain ⟨q, hPair, hP⟩ := (isPerfectlyRepresentablePair_iff_exists_canonicalJoint _).1 h
    have hfst : fstMarginal (PMF.channelJoint p kappa) = p := PMF.channelJoint_map_fst p kappa
    rw [hfst] at hPair hP
    have hC := (fstSndMarginal_canonicalJoint_eq_iff_of_fullSupport p q kappa hp).1 hPair
    have hM := (isPerfectFunctionalRepresentation_canonicalJoint_iff_isMarkovChain p q).1 hP
    exact ⟨q, (hC.exists_commonPosterior_iff_isMarkovChain p hp).2 hM⟩
  · exact fun h => h.isPerfectlyRepresentablePair p

/-- Channel perfectness is equivalent to pair perfectness under every prior.
Nonempty finite input supplies a uniform full-support prior for the converse. -/
theorem isPerfectlyRepresentableChannel_iff_forall_prior
    {alpha : Type u} {beta : Type v} [Nonempty alpha]
    [Fintype alpha] [Fintype beta]
    (kappa : alpha → PMF beta) :
    IsPerfectlyRepresentableChannel kappa ↔
      ∀ p : PMF alpha, IsPerfectlyRepresentablePair (PMF.channelJoint p kappa) := by
  constructor
  · exact fun h p => h.isPerfectlyRepresentablePair p
  · intro h
    exact (isPerfectlyRepresentablePair_channelJoint_iff_of_fullSupport
      (PMF.uniformOfFintype alpha) kappa PMF.mem_support_uniformOfFintype).1 (h _)

/-- It suffices that one full-support prior give a perfectly representable pair. -/
theorem isPerfectlyRepresentableChannel_iff_exists_fullSupport_prior
    {alpha : Type u} {beta : Type v} [Nonempty alpha]
    [Fintype alpha] [Fintype beta]
    (kappa : alpha → PMF beta) :
    IsPerfectlyRepresentableChannel kappa ↔
      ∃ p : PMF alpha, (∀ a, a ∈ p.support) ∧
        IsPerfectlyRepresentablePair (PMF.channelJoint p kappa) := by
  constructor
  · intro h
    exact ⟨PMF.uniformOfFintype alpha, PMF.mem_support_uniformOfFintype,
      h.isPerfectlyRepresentablePair _⟩
  · rintro ⟨p, hp, h⟩
    exact (isPerfectlyRepresentablePair_channelJoint_iff_of_fullSupport p kappa hp).1 h

/-- Changing between full-support input priors preserves pair perfectness
for the same channel. No assumption on output support is required. -/
theorem isPerfectlyRepresentablePair_channelJoint_congr_prior
    {alpha : Type u} {beta : Type v} [Nonempty alpha]
    [Fintype alpha] [Fintype beta]
    (p p' : PMF alpha) (kappa : alpha → PMF beta)
    (hp : ∀ a, a ∈ p.support) (hp' : ∀ a, a ∈ p'.support) :
    IsPerfectlyRepresentablePair (PMF.channelJoint p kappa) ↔
      IsPerfectlyRepresentablePair (PMF.channelJoint p' kappa) :=
  (isPerfectlyRepresentablePair_channelJoint_iff_of_fullSupport p kappa hp).trans
    (isPerfectlyRepresentablePair_channelJoint_iff_of_fullSupport p' kappa hp').symm

/-- Transfer the all-prior consequence to a specified source through C01's
pair-law transport. The existential witness may live on an enlarged space;
the original source type remains unrestricted. -/
theorem IsPerfectlyRepresentableChannel.isPerfectlyRepresentablePairOf
    {omega : Type u} {alpha : Type v} {beta : Type w}
    [Nonempty alpha] [Fintype alpha] [Fintype beta]
    {kappa : alpha → PMF beta} (h : IsPerfectlyRepresentableChannel kappa)
    (mu : PMF omega) (X : omega → alpha) (Y : omega → beta) (p : PMF alpha)
    (hLaw : mu.map (fun s => (X s, Y s)) = PMF.channelJoint p kappa) :
    IsPerfectlyRepresentablePairOf mu X Y := by
  have hId : (fun t : alpha × beta => (t.1, t.2)) = id := by
    funext t
    exact Prod.eta t
  have hSelf : (PMF.channelJoint p kappa).map (fun t => (t.1, t.2)) =
      PMF.channelJoint p kappa := by
    rw [hId, PMF.map_id]
  apply (isPerfectlyRepresentablePairOf_congr_pairLaw
    (p := mu) (p' := PMF.channelJoint p kappa)
    (X := X) (Y := Y) (X' := Prod.fst) (Y' := Prod.snd)
    (hLaw.trans hSelf.symm)).2
  unfold IsPerfectlyRepresentablePairOf
  rw [hSelf]
  exact h.isPerfectlyRepresentablePair p

/-! ## Input-support transport

The input alphabet of the manuscript is the support of its input law.
Changing to that subtype preserves the pair law through inclusion, rather
than identifying the two value types. A total retraction is only internal
bookkeeping; its values outside support have zero probability.
-/

private noncomputable def inputSupportRetraction {alpha : Type u} (p : PMF alpha)
    (a : alpha) : p.support := by
  classical
  exact if ha : a ∈ p.support then ⟨a, ha⟩
    else ⟨p.support_nonempty.choose, p.support_nonempty.choose_spec⟩

private theorem inputSupportRetraction_val {alpha : Type u} (p : PMF alpha)
    (s : p.support) : inputSupportRetraction p s.val = s := by
  simp [inputSupportRetraction, s.property]

private theorem val_inputSupportRetraction {alpha : Type u} (p : PMF alpha)
    (a : alpha) (ha : a ∈ p.support) : (inputSupportRetraction p a).val = a := by
  simp [inputSupportRetraction, ha]

/-- The normalized input law on its own support, with no finite-alphabet requirement. -/
noncomputable def inputSupportPrior {alpha : Type u} (p : PMF alpha) : PMF p.support :=
  p.map (inputSupportRetraction p)

/-- Every value of the support subtype has positive mass under the restricted prior. -/
theorem mem_support_inputSupportPrior {alpha : Type u} (p : PMF alpha) (s : p.support) :
    s ∈ (inputSupportPrior p).support := by
  rw [inputSupportPrior, PMF.mem_support_map_iff]
  exact ⟨s.val, s.property, inputSupportRetraction_val p s⟩

/-- Inclusion recovers exactly the original input law. -/
@[simp] theorem map_val_inputSupportPrior {alpha : Type u} (p : PMF alpha) :
    (inputSupportPrior p).map Subtype.val = p := by
  rw [inputSupportPrior, PMF.map_comp]
  calc
    p.map (Subtype.val ∘ inputSupportRetraction p) = p.map id :=
      map_eq_on_support p _ _ (fun a ha => val_inputSupportRetraction p a ha)
    _ = p := PMF.map_id p

/-- Restricting the input prior and channel, then including the input, recovers
the original pair law, including when the prior has zero-probability inputs. -/
theorem channelJoint_inputSupportPrior_map_val {alpha : Type u} {beta : Type v}
    (p : PMF alpha) (kappa : alpha → PMF beta) :
    (PMF.channelJoint (inputSupportPrior p) (fun s => kappa s.val)).map
      (fun sb => (sb.1.val, sb.2)) = PMF.channelJoint p kappa := by
  calc
    _ = PMF.channelJoint ((inputSupportPrior p).map Subtype.val) kappa := by
      simp only [PMF.channelJoint, PMF.map_bind, PMF.map_comp, PMF.bind_map,
        Function.comp_def]
    _ = _ := by rw [map_val_inputSupportPrior]

universe y

private theorem independentInputMap {omega : Type u} {alpha : Type v}
    {gamma : Type w} {delta : Type x}
    (p : PMF omega) (X : omega → alpha) (Z : omega → gamma)
    (f : alpha → delta) (h : IsIndependentOf p X Z) :
    IsIndependentOf p (fun s => f (X s)) Z := by
  apply (isIndependentOf_swap p (fun s => f (X s)) Z).1
  exact isIndependentOf_comp_right p Z X f ((isIndependentOf_swap p X Z).2 h)

private theorem conditionalEntropyInputInjection {omega : Type u} {alpha : Type v}
    {alpha' : Type w} {beta : Type x}
    [Fintype alpha] [Fintype alpha'] [Fintype beta]
    (p : PMF omega) (X : omega → alpha) (Y : omega → beta)
    (f : alpha → alpha') (hf : Function.Injective f) :
    condEntropyOf p Y (fun s => f (X s)) = condEntropyOf p Y X := by
  have hX := entropyOf_comp_injective p X hf
  have hYX := entropyOf_comp_injective p (fun s => (Y s, X s))
    (f := fun t : beta × alpha => (t.1, f t.2)) (by
      intro a b h
      apply Prod.ext
      · exact congrArg (fun t : beta × alpha' => t.1) h
      · exact hf (congrArg (fun t : beta × alpha' => t.2) h))
  change jointEntropyOf p Y (fun s => f (X s)) = jointEntropyOf p Y X at hYX
  rw [condEntropyOf_eq, condEntropyOf_eq, hYX, hX]

private theorem functionalInputEmbeddingIff {omega : Type u} {alpha : Type v}
    {alpha' : Type w} {beta : Type x} {gamma : Type y}
    (p : PMF omega) (X : omega → alpha) (Y : omega → beta) (Z : omega → gamma)
    (f : alpha → alpha') (g : alpha' → alpha) (hgf : Function.LeftInverse g f) :
    IsFunctionalRepresentationOf p (fun s => f (X s)) Y Z ↔
      IsFunctionalRepresentationOf p X Y Z := by
  have hgf' : ∀ a, g (f a) = a := hgf
  rw [isFunctionalRepresentationOf_iff, isFunctionalRepresentationOf_iff]
  constructor
  · rintro ⟨hI, d, hD⟩
    refine ⟨?_, (fun az => d (f az.1, az.2)), hD⟩
    have hI' := independentInputMap p (fun s => f (X s)) Z g hI
    simpa only [hgf'] using hI'
  · rintro ⟨hI, d, hD⟩
    refine ⟨independentInputMap p X Z f hI, (fun az => d (g az.1, az.2)), ?_⟩
    simpa only [hgf'] using hD

private theorem perfectInputEmbeddingIff {omega : Type u} {alpha : Type v}
    {alpha' : Type w} {beta : Type x} {gamma : Type y}
    [Fintype alpha] [Fintype alpha'] [Fintype beta] [Fintype gamma]
    (p : PMF omega) (X : omega → alpha) (Y : omega → beta) (Z : omega → gamma)
    (f : alpha → alpha') (g : alpha' → alpha) (hgf : Function.LeftInverse g f) :
    IsPerfectFunctionalRepresentationOf p (fun s => f (X s)) Y Z ↔
      IsPerfectFunctionalRepresentationOf p X Y Z := by
  rw [isPerfectFunctionalRepresentationOf_iff, isPerfectFunctionalRepresentationOf_iff,
    conditionalEntropyInputInjection p X Y f hgf.injective]
  exact and_congr (functionalInputEmbeddingIff p X Y Z f g hgf) Iff.rfl

private theorem perfectLawInputEmbeddingIff {alpha : Type u} {alpha' : Type v}
    {beta : Type w} {gamma : Type x}
    [Fintype alpha] [Fintype alpha'] [Fintype beta] [Fintype gamma]
    (r : PMF (alpha × beta × gamma))
    (f : alpha → alpha') (g : alpha' → alpha) (hgf : Function.LeftInverse g f) :
    IsPerfectFunctionalRepresentation (r.map (fun t => (f t.1, t.2.1, t.2.2))) ↔
      IsPerfectFunctionalRepresentation r := by
  have h := perfectInputEmbeddingIff r (fun t => t.1) (fun t => t.2.1)
    (fun t => t.2.2) f g hgf
  unfold IsPerfectFunctionalRepresentationOf at h
  have hId : (fun t : alpha × beta × gamma => (t.1, t.2.1, t.2.2)) = id := by
    funext t
    simp only [Prod.eta, id_eq]
  rwa [hId, PMF.map_id] at h

private theorem pairInputEmbeddingIff {alpha : Type u} {alpha' : Type v} {beta : Type w}
    [Fintype alpha] [Fintype alpha'] [Fintype beta]
    (r : PMF (alpha × beta))
    (f : alpha → alpha') (g : alpha' → alpha) (hgf : Function.LeftInverse g f) :
    IsPerfectlyRepresentablePair (r.map (fun t => (f t.1, t.2))) ↔
      IsPerfectlyRepresentablePair r := by
  have hgf' : ∀ a, g (f a) = a := hgf
  constructor
  · rintro ⟨n, q, hPair, hP⟩
    let q0 := q.map (fun t => (g t.1, t.2.1, t.2.2))
    have hRound : q0.map (fun t => (f t.1, t.2.1, t.2.2)) = q := by
      dsimp only [q0]
      rw [PMF.map_comp]
      calc
        _ = q.map id := by
          apply map_eq_on_support
          intro t ht
          have htPair : (t.1, t.2.1) ∈ (fstSndMarginal q).support := by
            rw [fstSndMarginal, PMF.mem_support_map_iff]
            exact ⟨t, ht, rfl⟩
          rw [hPair, PMF.mem_support_map_iff] at htPair
          obtain ⟨ab, _, hab⟩ := htPair
          have ha : f ab.1 = t.1 := congrArg Prod.fst hab
          have hfg : f (g t.1) = t.1 := by rw [← ha, hgf']
          simp only [Function.comp_def, hfg, Prod.eta, id_eq]
        _ = q := PMF.map_id q
    refine ⟨n, q0, ?_, ?_⟩
    · have hm := congrArg (fun law : PMF (alpha' × beta) =>
          law.map (fun ab => (g ab.1, ab.2))) hPair
      have hId : (fun ab : alpha × beta => (g (f ab.1), ab.2)) = id := by
        funext ab
        simp only [hgf', Prod.eta, id_eq]
      simpa only [q0, fstSndMarginal, PMF.map_comp, Function.comp_def, hId, PMF.map_id] using hm
    · apply (perfectLawInputEmbeddingIff q0 f g hgf).1
      rw [hRound]
      exact hP
  · rintro ⟨n, q, hPair, hP⟩
    refine ⟨n, q.map (fun t => (f t.1, t.2.1, t.2.2)), ?_,
      (perfectLawInputEmbeddingIff q f g hgf).2 hP⟩
    have hm := congrArg (fun law : PMF (alpha × beta) =>
      law.map (fun ab => (f ab.1, ab.2))) hPair
    simpa only [fstSndMarginal, PMF.map_comp, Function.comp_def] using hm

/-- Perfect-pair representability is unchanged by restricting the input law to
its support. The proof transports finite witnesses in both directions across
`Subtype.val`; it does not identify the two input types. -/
theorem isPerfectlyRepresentablePair_channelJoint_iff_inputSupportPrior
    {alpha : Type u} {beta : Type v} [Fintype alpha] [Fintype beta]
    (p : PMF alpha) [Fintype p.support] (kappa : alpha → PMF beta) :
    IsPerfectlyRepresentablePair (PMF.channelJoint p kappa) ↔
      IsPerfectlyRepresentablePair
        (PMF.channelJoint (inputSupportPrior p) (fun s => kappa s.val)) := by
  have h := pairInputEmbeddingIff
    (PMF.channelJoint (inputSupportPrior p) (fun s => kappa s.val))
    Subtype.val (inputSupportRetraction p) (inputSupportRetraction_val p)
  rwa [channelJoint_inputSupportPrior_map_val] at h

/-- For an arbitrary finite input prior, perfect-pair representability is exactly
the intrinsic property of the channel restricted to that prior's input support.
The PMF supplies nonemptiness of its support; no ambient full-support premise or
caller-chosen default output is needed. -/
theorem isPerfectlyRepresentablePair_channelJoint_iff_restrict_support
    {alpha : Type u} {beta : Type v} [Fintype alpha] [Fintype beta]
    (p : PMF alpha) (kappa : alpha → PMF beta) :
    IsPerfectlyRepresentablePair (PMF.channelJoint p kappa) ↔
      @IsPerfectlyRepresentableChannel p.support beta p.support_nonempty.to_subtype
        (fun s => kappa s.val) := by
  classical
  let : Nonempty p.support := p.support_nonempty.to_subtype
  exact (isPerfectlyRepresentablePair_channelJoint_iff_inputSupportPrior p kappa).trans
    (isPerfectlyRepresentablePair_channelJoint_iff_of_fullSupport
      (inputSupportPrior p) (fun s => kappa s.val) (mem_support_inputSupportPrior p))

end PerfectFunctionalRepresentations
