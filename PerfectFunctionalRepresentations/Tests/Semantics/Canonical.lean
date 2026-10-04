import PerfectFunctionalRepresentations.Semantics.Canonical

/-!
# Canonical representation regressions

Coordinate marginals and input independence do not imply evaluation decoding
for a specified triple. The remaining fixtures check deterministic and singleton
cases, unused channel rows, and decoding restricted to source support.
-/

namespace PerfectFunctionalRepresentations

open LeanInfoTheory.Shannon

noncomputable section

universe u v w x

section PolymorphicContracts

variable {omega : Type u} {alpha : Type v} {beta : Type w}

/-- The common-source structural contract imposes no typeclass assumptions. -/
example (p : PMF omega) (X : omega → alpha) (Y : omega → beta)
    (W : omega → alpha → beta) :
    IsCanonicalFunctionalRepresentationOf p X Y W ↔
      IsIndependentOf p X W ∧ ∀ s ∈ p.support, Y s = W s (X s) :=
  isCanonicalFunctionalRepresentationOf_iff p X Y W

/-- Canonicality supplies C01's decoder without finite alphabet assumptions. -/
example (p : PMF omega) (X : omega → alpha) (Y : omega → beta)
    (W : omega → alpha → beta)
    (h : IsCanonicalFunctionalRepresentationOf p X Y W) :
    IsFunctionalRepresentationOf p X Y W :=
  h.isFunctionalRepresentationOf

/-- Canonical joints have the stated input and vector laws at arbitrary universes. -/
example (p : PMF alpha) (q : PMF (alpha → beta)) :
    IsCanonicalFunctionalRepresentation (canonicalJoint p q) ∧
      fstMarginal (canonicalJoint p q) = p ∧
      thirdMarginal (canonicalJoint p q) = q :=
  ⟨isCanonicalFunctionalRepresentation_canonicalJoint p q,
    fstMarginal_canonicalJoint p q, thirdMarginal_canonicalJoint p q⟩

/-- The characterization uses the triple's own marginals. -/
example (r : PMF (alpha × beta × (alpha → beta))) :
    IsCanonicalFunctionalRepresentation r ↔
      r = canonicalJoint (fstMarginal r) (thirdMarginal r) :=
  isCanonicalFunctionalRepresentation_iff_eq_canonicalJoint r

/-- An arbitrary prior determines exactly its supported coordinate rows. -/
example (p : PMF alpha) (q : PMF (alpha → beta)) (kappa : alpha → PMF beta) :
    fstSndMarginal (canonicalJoint p q) = PMF.channelJoint p kappa ↔
      ∀ a ∈ p.support, q.map (fun f => f a) = kappa a :=
  fstSndMarginal_canonicalJoint_eq_iff p q kappa

/-- All-row coupling follows only with an explicit full-support premise. -/
example (p : PMF alpha) (q : PMF (alpha → beta)) (kappa : alpha → PMF beta)
    (hp : ∀ a, a ∈ p.support) :
    fstSndMarginal (canonicalJoint p q) = PMF.channelJoint p kappa ↔
      IsCanonicalCoupling kappa q :=
  fstSndMarginal_canonicalJoint_eq_iff_of_fullSupport p q kappa hp

end PolymorphicContracts

/-- Equal full triple laws allow unrelated source types and universes. -/
example {omega : Type u} {omega' : Type v} {alpha : Type w} {beta : Type x}
    {p : PMF omega} {p' : PMF omega'}
    {X : omega → alpha} {Y : omega → beta} {W : omega → alpha → beta}
    {X' : omega' → alpha} {Y' : omega' → beta} {W' : omega' → alpha → beta}
    (hLaw : p.map (fun s => (X s, Y s, W s)) =
      p'.map (fun s => (X' s, Y' s, W' s))) :
    IsCanonicalFunctionalRepresentationOf p X Y W ↔
      IsCanonicalFunctionalRepresentationOf p' X' Y' W' :=
  isCanonicalFunctionalRepresentationOf_congr_jointLaw hLaw

private theorem constantInputIndependent {omega : Type u} {alpha : Type v}
    {gamma : Type w} (p : PMF omega) (a : alpha) (W : omega → gamma) :
    IsIndependentOf p (fun _ => a) W := by
  rw [isIndependentOf_iff_map_eq_indepProd]
  change p.map (fun s => (a, W s)) =
    indepProd (p.map (Function.const omega a)) (p.map W)
  rw [PMF.map_const]
  simp [indepProd, PMF.map_comp, Function.comp_def]

private def fairBit : PMF Bool := PMF.uniformOfFintype Bool

private def marginalOnlySource : PMF (Bool × Bool) := indepProd fairBit fairBit

private def marginalOnlyX (_ : Bool × Bool) : Unit := ()

private def marginalOnlyY (s : Bool × Bool) : Bool := s.1

private def marginalOnlyW (s : Bool × Bool) (_ : Unit) : Bool := s.2

private def fairVector : PMF (Unit → Bool) := fairBit.map fun b _ => b

private def fairChannel (_ : Unit) : PMF Bool := fairBit

private theorem marginalOnlyVectorLaw : marginalOnlySource.map marginalOnlyW = fairVector := by
  calc
    marginalOnlySource.map marginalOnlyW =
        (sndMarginal marginalOnlySource).map (fun b (_ : Unit) => b) := by
      simp only [sndMarginal, PMF.map_comp, Function.comp_def]
      rfl
    _ = fairVector := by rw [marginalOnlySource, sndMarginal_indepProd]; rfl

private theorem fairVectorCoupling : IsCanonicalCoupling fairChannel fairVector := by
  intro a
  simp only [fairVector, fairChannel, PMF.map_comp, Function.comp_def]
  exact PMF.map_id fairBit

/-- R01 uses four equally weighted atoms, with genuinely independent fair bits. -/
example :
    (∀ s, marginalOnlySource s = (4 : ENNReal)⁻¹) ∧
      IsIndependentOf marginalOnlySource marginalOnlyY
        (fun s => marginalOnlyW s ()) := by
  constructor
  · rintro ⟨a, b⟩
    norm_num [marginalOnlySource, fairBit, PMF.uniformOfFintype_apply]
    apply (ENNReal.toReal_eq_toReal_iff' (by finiteness) (by finiteness)).mp
    norm_num [ENNReal.toReal_mul]
  · unfold IsIndependentOf
    change IsIndependent (marginalOnlySource.map id)
    rw [PMF.map_id]
    exact isIndependent_indepProd _ _

/--
R01 has input independence and the correct sole coordinate law, and its actual
pair law is the specified channel joint. These premises do not identify `Y`
with evaluation of this independently sampled vector.
-/
example :
    IsIndependentOf marginalOnlySource marginalOnlyX marginalOnlyW ∧
      marginalOnlySource.map marginalOnlyW = fairVector ∧
      IsCanonicalCoupling fairChannel fairVector ∧
      marginalOnlySource.map (fun s => (marginalOnlyX s, marginalOnlyY s)) =
        PMF.channelJoint (PMF.pure ()) fairChannel ∧
      fstSndMarginal (canonicalJoint (PMF.pure ()) fairVector) =
        marginalOnlySource.map (fun s => (marginalOnlyX s, marginalOnlyY s)) := by
  have hPair :
      marginalOnlySource.map (fun s => (marginalOnlyX s, marginalOnlyY s)) =
        PMF.channelJoint (PMF.pure ()) fairChannel := by
    calc
      marginalOnlySource.map (fun s => (marginalOnlyX s, marginalOnlyY s)) =
          (fstMarginal marginalOnlySource).map (fun b => ((), b)) := by
        simp only [fstMarginal, PMF.map_comp, Function.comp_def,
          marginalOnlyX, marginalOnlyY]
      _ = PMF.channelJoint (PMF.pure ()) fairChannel := by
        simp [marginalOnlySource, PMF.channelJoint, fairChannel]
  exact ⟨constantInputIndependent marginalOnlySource () marginalOnlyW,
    marginalOnlyVectorLaw, fairVectorCoupling, hPair,
    (fairVectorCoupling.fstSndMarginal_canonicalJoint (PMF.pure ())).trans hPair.symm⟩

/-- R01 fails evaluation at a supported atom and hence is not canonical. -/
example :
    (∃ s ∈ marginalOnlySource.support,
      marginalOnlyY s ≠ marginalOnlyW s (marginalOnlyX s)) ∧
      ¬ IsCanonicalFunctionalRepresentationOf marginalOnlySource
        marginalOnlyX marginalOnlyY marginalOnlyW := by
  have hSupport : (false, true) ∈ marginalOnlySource.support := by
    simp [marginalOnlySource, fairBit, Set.prod]
  constructor
  · exact ⟨(false, true), hSupport, by decide⟩
  · intro h
    have hDecode := (isCanonicalFunctionalRepresentationOf_iff _ _ _ _).1 h
    exact Bool.false_ne_true (hDecode.2 (false, true) hSupport)

/-- In R01, evaluation disagrees with the actual output with probability one half. -/
example :
    (marginalOnlySource.map fun s => marginalOnlyY s !=
      marginalOnlyW s (marginalOnlyX s)) true = (2 : ENNReal)⁻¹ := by
  norm_num [marginalOnlySource, marginalOnlyY, marginalOnlyW, fairBit,
    PMF.map_apply, PMF.uniformOfFintype_apply, Fintype.sum_prod_type, two_mul]
  apply (ENNReal.toReal_eq_toReal_iff' (by finiteness) (by finiteness)).mp
  rw [ENNReal.toReal_add (by finiteness) (by finiteness)]
  norm_num [ENNReal.toReal_mul]

/-- R02: a deterministic vector produces the expected pure triple. -/
example : canonicalJoint (PMF.pure false) (PMF.pure (id : Bool → Bool)) =
    PMF.pure (false, false, (id : Bool → Bool)) := by
  simp [canonicalJoint, indepProd, PMF.pure_map]

/-- R02: deterministic output is canonical for an arbitrary source and input. -/
example {omega : Type u} {alpha : Type v} {beta : Type w}
    (p : PMF omega) (X : omega → alpha) (f : alpha → beta) :
    IsCanonicalFunctionalRepresentationOf p X (fun s => f (X s)) (fun _ => f) := by
  rw [isCanonicalFunctionalRepresentationOf_iff]
  refine ⟨?_, by intro s _; rfl⟩
  rw [isIndependentOf_iff_map_eq_indepProd]
  change p.map (fun s => (X s, f)) =
    indepProd (p.map X) (p.map (Function.const omega f))
  rw [PMF.map_const]
  simp [indepProd, PMF.map, Function.comp_def]

/-- R02: singleton alphabets work on an infinite ambient source. -/
example (p : PMF Nat) :
    IsCanonicalFunctionalRepresentationOf p (fun _ => ()) (fun _ => ())
      (fun _ _ => ()) := by
  rw [isCanonicalFunctionalRepresentationOf_iff]
  exact ⟨constantInputIndependent p () (fun _ _ => ()), by intro s _; rfl⟩

private def unusedRowPrior : PMF Bool := PMF.pure false

private def unusedRowVector : PMF (Bool → Bool) := PMF.pure (fun _ => false)

private def unusedRowChannel (a : Bool) : PMF Bool := PMF.pure a

/-- R03: the null row may differ while the pair joint stays unchanged. -/
example :
    unusedRowPrior true = 0 ∧
      fstSndMarginal (canonicalJoint unusedRowPrior unusedRowVector) =
        PMF.channelJoint unusedRowPrior unusedRowChannel ∧
      unusedRowVector.map (fun f => f true) ≠ unusedRowChannel true ∧
      ¬ IsCanonicalCoupling unusedRowChannel unusedRowVector := by
  have hMismatch : unusedRowVector.map (fun f => f true) ≠ unusedRowChannel true := by
    intro h
    have hTrue := congrArg (fun q : PMF Bool => q true) h
    norm_num [unusedRowVector, unusedRowChannel, PMF.pure_map] at hTrue
  refine ⟨by simp [unusedRowPrior], ?_, hMismatch, fun h => hMismatch (h true)⟩
  apply (fstSndMarginal_canonicalJoint_eq_iff _ _ _).2
  intro a ha
  have haFalse : a = false := by simpa [unusedRowPrior] using ha
  subst a
  simp [unusedRowVector, unusedRowChannel, PMF.pure_map]

private def nullSource : PMF Bool := PMF.pure false

private def nullSourceX (_ : Bool) : Unit := ()

private def nullSourceW (_ : Bool) (_ : Unit) : Bool := false

/-- Canonicality requires evaluation only on support, and survives a null-point failure. -/
example :
    IsCanonicalFunctionalRepresentationOf nullSource nullSourceX id nullSourceW ∧
      nullSource true = 0 ∧ id true ≠ nullSourceW true (nullSourceX true) := by
  refine ⟨?_, by simp [nullSource], by decide⟩
  rw [isCanonicalFunctionalRepresentationOf_iff]
  refine ⟨constantInputIndependent nullSource () nullSourceW, ?_⟩
  intro s hs
  have hsFalse : s = false := by simpa [nullSource] using hs
  subst s
  rfl

/-! ## Decoder-induced canonicalization regressions -/

section PolymorphicDecoderContracts

variable {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
variable (mu : PMF omega) (X : omega → alpha) (Y : omega → beta) (Z : omega → gamma)
variable (decoder : alpha × gamma → beta)

/-- R04: every chosen support-correct decoder works, with four unrestricted universes. -/
example (hI : IsIndependentOf mu X Z)
    (hD : ∀ s ∈ mu.support, Y s = decoder (X s, Z s)) :
    IsCanonicalFunctionalRepresentationOf mu X Y
      (fun s => decoderVector decoder (Z s)) :=
  isCanonicalFunctionalRepresentationOf_decoderVector mu X Y Z decoder hI hD

/-- The vector law is exactly the decoder pushforward by existing map composition. -/
example : (mu.map Z).map (decoderVector decoder) =
    mu.map (fun s => decoderVector decoder (Z s)) :=
  PMF.map_comp Z mu (decoderVector decoder)

/-- Canonicalization preserves the specified full triple and its fixed pair projection. -/
example (hI : IsIndependentOf mu X Z)
    (hD : ∀ s ∈ mu.support, Y s = decoder (X s, Z s)) :
    mu.map (fun s => (X s, Y s, decoderVector decoder (Z s))) =
      canonicalJoint (mu.map X) ((mu.map Z).map (decoderVector decoder)) ∧
    fstSndMarginal
      (canonicalJoint (mu.map X) ((mu.map Z).map (decoderVector decoder))) =
      mu.map (fun s => (X s, Y s)) := by
  have h := isCanonicalFunctionalRepresentationOf_decoderVector mu X Y Z decoder hI hD
  constructor
  · simpa only [PMF.map_comp, Function.comp_def] using h.jointLaw_eq_canonicalJoint
  · simpa only [PMF.map_comp, Function.comp_def] using h.fstSndMarginal_canonicalJoint

/-- Row recovery retains the supported-input premise for a supplied channel. -/
example (hI : IsIndependentOf mu X Z)
    (hD : ∀ s ∈ mu.support, Y s = decoder (X s, Z s))
    (kappa : alpha → PMF beta)
    (hPair : mu.map (fun s => (X s, Y s)) = PMF.channelJoint (mu.map X) kappa)
    (a : alpha) (ha : a ∈ (mu.map X).support) :
    ((mu.map Z).map (decoderVector decoder)).map (fun f => f a) = kappa a := by
  have h := isCanonicalFunctionalRepresentationOf_decoderVector mu X Y Z decoder hI hD
  simpa only [PMF.map_comp, Function.comp_def] using
    h.coordinateLaw_eq_of_mem_support kappa hPair a ha

/-- All-row recovery requires full support explicitly and no finite typeclass. -/
example (hI : IsIndependentOf mu X Z)
    (hD : ∀ s ∈ mu.support, Y s = decoder (X s, Z s))
    (kappa : alpha → PMF beta)
    (hPair : mu.map (fun s => (X s, Y s)) = PMF.channelJoint (mu.map X) kappa)
    (hFull : ∀ a, a ∈ (mu.map X).support) :
    IsCanonicalCoupling kappa ((mu.map Z).map (decoderVector decoder)) := by
  have h := isCanonicalFunctionalRepresentationOf_decoderVector mu X Y Z decoder hI hD
  simpa only [PMF.map_comp, Function.comp_def] using
    h.isCanonicalCoupling_of_fullSupport kappa hPair hFull

/-- The final existential interface extracts its own decoder from C01. -/
example (h : IsFunctionalRepresentationOf mu X Y Z) :
    ∃ decoder : alpha × gamma → beta,
      IsCanonicalFunctionalRepresentationOf mu X Y
        (fun s => decoderVector decoder (Z s)) :=
  h.exists_canonical_decoder

end PolymorphicDecoderContracts

/-- R04: an infinite auxiliary in a higher universe needs no finite-value instance. -/
example (mu : PMF Nat) (X : Nat → Bool) (Y : Nat → Bool)
    (Z : Nat → ULift.{1} Nat) (decoder : Bool × ULift.{1} Nat → Bool)
    (hI : IsIndependentOf mu X Z)
    (hD : ∀ s ∈ mu.support, Y s = decoder (X s, Z s)) :
    IsCanonicalFunctionalRepresentationOf mu X Y
      (fun s => decoderVector decoder (Z s)) :=
  isCanonicalFunctionalRepresentationOf_decoderVector mu X Y Z decoder hI hD

/-- R04: every PMF on Nat admits this nonconstant Nat-auxiliary construction. -/
example (mu : PMF Nat) :
    IsCanonicalFunctionalRepresentationOf mu (fun _ => ()) id
      (fun s => decoderVector (Prod.snd : Unit × Nat → Nat) s) ∧
    ∃ decoder : Unit × Nat → Nat,
      IsCanonicalFunctionalRepresentationOf mu (fun _ => ()) id
        (fun s => decoderVector decoder (id s)) := by
  have hI := constantInputIndependent mu () (id : Nat → Nat)
  have hD : ∀ s ∈ mu.support, id s = (Prod.snd : Unit × Nat → Nat) ((), id s) := by
    intro s _
    rfl
  have hFR : IsFunctionalRepresentationOf mu (fun _ => ()) id id :=
    (isFunctionalRepresentationOf_iff _ _ _ _).2 ⟨hI, Prod.snd, hD⟩
  exact ⟨isCanonicalFunctionalRepresentationOf_decoderVector mu (fun _ => ()) id id
    Prod.snd hI hD, hFR.exists_canonical_decoder⟩

private def completedDecoder (_ : Bool × Nat) : Bool := false

private def alteredDecoder (t : Bool × Nat) : Bool := t.1

private def completedVectorLaw (mu : PMF Nat) : PMF (Bool → Bool) :=
  mu.map (decoderVector completedDecoder)

private def alteredVectorLaw (mu : PMF Nat) : PMF (Bool → Bool) :=
  mu.map (decoderVector alteredDecoder)

private theorem completedVectorLaw_eq (mu : PMF Nat) :
    completedVectorLaw mu = PMF.pure (fun _ : Bool => false) :=
  PMF.map_const mu (fun _ : Bool => false)

private theorem alteredVectorLaw_eq (mu : PMF Nat) :
    alteredVectorLaw mu = PMF.pure (id : Bool → Bool) :=
  PMF.map_const mu (id : Bool → Bool)

private theorem decoderCompletionsCanonical (mu : PMF Nat) :
    IsCanonicalFunctionalRepresentationOf mu (fun _ => false) (fun _ => false)
      (decoderVector completedDecoder) ∧
    IsCanonicalFunctionalRepresentationOf mu (fun _ => false) (fun _ => false)
      (decoderVector alteredDecoder) := by
  have hI := constantInputIndependent mu false (id : Nat → Nat)
  constructor
  · exact isCanonicalFunctionalRepresentationOf_decoderVector mu (fun _ => false)
      (fun _ => false) id completedDecoder hI (by intro s _; rfl)
  · exact isCanonicalFunctionalRepresentationOf_decoderVector mu (fun _ => false)
      (fun _ => false) id alteredDecoder hI (by intro s _; rfl)

/-- R05: the decoder completions agree on every supported input, but differ at `true`. -/
example (mu : PMF Nat) :
    (∀ a ∈ (mu.map (fun _ => false)).support, ∀ z,
      completedDecoder (a, z) = alteredDecoder (a, z)) ∧
      completedDecoder (true, 0) ≠ alteredDecoder (true, 0) := by
  refine ⟨?_, by decide⟩
  intro a ha z
  have haFalse : a = false := by simpa using ha
  subst a
  rfl

/-- Both completions are canonical for the same actual pair, with the same pair law. -/
example (mu : PMF Nat) :
    IsCanonicalFunctionalRepresentationOf mu (fun _ => false) (fun _ => false)
      (decoderVector completedDecoder) ∧
    IsCanonicalFunctionalRepresentationOf mu (fun _ => false) (fun _ => false)
      (decoderVector alteredDecoder) ∧
    fstSndMarginal
      (canonicalJoint (mu.map (fun _ => false)) (completedVectorLaw mu)) =
      fstSndMarginal
        (canonicalJoint (mu.map (fun _ => false)) (alteredVectorLaw mu)) := by
  obtain ⟨hCompleted, hAltered⟩ := decoderCompletionsCanonical mu
  exact ⟨hCompleted, hAltered,
    hCompleted.fstSndMarginal_canonicalJoint.trans
      hAltered.fstSndMarginal_canonicalJoint.symm⟩

/-- R05: the unused coordinate and hence the entire vector laws really differ. -/
example (mu : PMF Nat) :
    (completedVectorLaw mu).map (fun f => f false) = PMF.pure false ∧
    (alteredVectorLaw mu).map (fun f => f false) = PMF.pure false ∧
    (completedVectorLaw mu).map (fun f => f true) ≠
      (alteredVectorLaw mu).map (fun f => f true) ∧
    completedVectorLaw mu ≠ alteredVectorLaw mu := by
  have hMismatch : (completedVectorLaw mu).map (fun f => f true) ≠
      (alteredVectorLaw mu).map (fun f => f true) := by
    intro h
    have hTrue := congrArg (fun q : PMF Bool => q true) h
    norm_num [completedVectorLaw_eq, alteredVectorLaw_eq, PMF.pure_map] at hTrue
  refine ⟨?_, ?_, hMismatch, ?_⟩
  · simp only [completedVectorLaw_eq, PMF.pure_map]
  · simp only [alteredVectorLaw_eq, PMF.pure_map, id_eq]
  · intro h
    exact hMismatch (congrArg (fun q : PMF (Bool → Bool) => q.map (fun f => f true)) h)

/-- R05: the altered completion cannot recover the chosen channel's unused row. -/
example (mu : PMF Nat) :
    IsCanonicalCoupling (fun _ : Bool => PMF.pure false) (completedVectorLaw mu) ∧
    ¬ IsCanonicalCoupling (fun _ : Bool => PMF.pure false) (alteredVectorLaw mu) := by
  constructor
  · intro a
    simp only [completedVectorLaw_eq, PMF.pure_map]
  · intro h
    have hTrue := congrArg (fun q : PMF Bool => q true) (h true)
    norm_num [alteredVectorLaw_eq, PMF.pure_map] at hTrue

/-! ## Finite information preservation and canonical sufficiency -/

section PolymorphicFiniteCanonicalization

variable {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
variable [Fintype beta] [Fintype gamma] [Fintype (alpha → beta)]
variable (mu : PMF omega) (X : omega → alpha) (Y : omega → beta) (Z : omega → gamma)

/-- The information theorem accepts any correct decoder and the caller's function enumeration. -/
example [Finite alpha] (decoder : alpha × gamma → beta) (hI : IsIndependentOf mu X Z)
    (hD : ∀ s ∈ mu.support, Y s = decoder (X s, Z s)) :
    mutualInfoOf mu Y (fun s => decoderVector decoder (Z s)) = mutualInfoOf mu Y Z :=
  mutualInfoOf_decoderVector_eq mu X Y Z decoder hI hD

/-- The extracted vector retains both the original pair law and information on the same source. -/
example [Finite alpha] (h : IsFunctionalRepresentationOf mu X Y Z) :
    ∃ W : omega → alpha → beta,
      IsCanonicalFunctionalRepresentationOf mu X Y W ∧
      fstSndMarginal (canonicalJoint (mu.map X) (mu.map W)) =
        mu.map (fun s => (X s, Y s)) ∧
      mutualInfoOf mu Y W = mutualInfoOf mu Y Z := by
  obtain ⟨W, hCanonical, hInfo⟩ := h.exists_canonical_preserving_mutualInfo
  exact ⟨W, hCanonical, hCanonical.fstSndMarginal_canonicalJoint, hInfo⟩

/-- Specified perfectness supports either a chosen decoder or an extracted canonical witness. -/
example [Fintype alpha] (h : IsPerfectFunctionalRepresentationOf mu X Y Z)
    (decoder : alpha × gamma → beta)
    (hD : ∀ s ∈ mu.support, Y s = decoder (X s, Z s)) :
    IsPerfectFunctionalRepresentationOf mu X Y
      (fun s => decoderVector decoder (Z s)) ∧
    ∃ W : omega → alpha → beta,
      IsCanonicalFunctionalRepresentationOf mu X Y W ∧
      IsPerfectFunctionalRepresentationOf mu X Y W :=
  ⟨h.decoderVector decoder hD, h.exists_canonical⟩

end PolymorphicFiniteCanonicalization

/-- The pair characterization uses its own input marginal and keeps C01's pair predicate. -/
example {alpha : Type u} {beta : Type v}
    [Fintype alpha] [Fintype beta] [Fintype (alpha → beta)] (pXY : PMF (alpha × beta)) :
    IsPerfectlyRepresentablePair pXY ↔
      ∃ q : PMF (alpha → beta),
        fstSndMarginal (canonicalJoint (fstMarginal pXY) q) = pXY ∧
        IsPerfectFunctionalRepresentation (canonicalJoint (fstMarginal pXY) q) :=
  isPerfectlyRepresentablePair_iff_exists_canonicalJoint pXY

private def discardedBitDecoder (t : Unit × (Bool × Bool)) : Bool := t.2.1

/--
R06: the first auxiliary bit is the output and the second is discarded.
Two supported auxiliary values have the same vector, yet information about
the output is preserved because this decoder represents the specified pair.
-/
example :
    ¬ Function.Injective (decoderVector discardedBitDecoder) ∧
    (false, false) ∈ marginalOnlySource.support ∧
    (false, true) ∈ marginalOnlySource.support ∧
    IsCanonicalFunctionalRepresentationOf marginalOnlySource (fun _ => ()) Prod.fst
      (decoderVector discardedBitDecoder) ∧
    mutualInfoOf marginalOnlySource Prod.fst (decoderVector discardedBitDecoder) =
      mutualInfoOf marginalOnlySource Prod.fst id := by
  have hI := constantInputIndependent marginalOnlySource () (id : Bool × Bool → Bool × Bool)
  have hD : ∀ s ∈ marginalOnlySource.support,
      Prod.fst s = discardedBitDecoder ((), id s) := by
    intro s _
    rfl
  refine ⟨?_, by simp [marginalOnlySource, fairBit, Set.prod],
    by simp [marginalOnlySource, fairBit, Set.prod],
    isCanonicalFunctionalRepresentationOf_decoderVector marginalOnlySource (fun _ => ())
      Prod.fst id discardedBitDecoder hI hD,
    mutualInfoOf_decoderVector_eq marginalOnlySource (fun _ => ()) Prod.fst id
      discardedBitDecoder hI hD⟩
  intro hInjective
  have h := hInjective (a₁ := (false, false)) (a₂ := (false, true)) rfl
  exact Bool.false_ne_true (congrArg Prod.snd h)

/-- R07: a finite auxiliary in Type 1 works with an arbitrary PMF on the infinite source Nat. -/
example (mu : PMF Nat) (X : Nat → Bool) (Y : Nat → Fin 3)
    (Z : Nat → ULift.{1} (Fin 4)) (decoder : Bool × ULift.{1} (Fin 4) → Fin 3)
    (hI : IsIndependentOf mu X Z)
    (hD : ∀ s ∈ mu.support, Y s = decoder (X s, Z s)) :
    mutualInfoOf mu Y (fun s => decoderVector decoder (Z s)) = mutualInfoOf mu Y Z :=
  mutualInfoOf_decoderVector_eq mu X Y Z decoder hI hD

private def highNullSource : PMF Bool := PMF.pure false

private def highNullAuxiliary (s : Bool) : ULift.{1} (Fin 2) :=
  ULift.up (if s then 1 else 0)

private def highNullDecoder (_ : Bool × ULift.{1} (Fin 2)) : Bool := false

private theorem highNullDecoderCorrect :
    ∀ s ∈ highNullSource.support, id s = highNullDecoder (false, highNullAuxiliary s) := by
  intro s hs
  have hsFalse : s = false := by simpa [highNullSource] using hs
  subst s
  rfl

private theorem highNullPerfect :
    IsPerfectFunctionalRepresentationOf highNullSource (fun _ => false) id highNullAuxiliary := by
  apply (isPerfectFunctionalRepresentationOf_iff_isMarkovChainOf _ _ _ _).2
  refine ⟨?_, isMarkovChainOf_comp highNullSource (fun _ => false) id highNullAuxiliary⟩
  apply (isFunctionalRepresentationOf_iff _ _ _ _).2
  exact ⟨constantInputIndependent highNullSource false highNullAuxiliary,
    highNullDecoder, highNullDecoderCorrect⟩

/-- R07: information and perfectness survive a decoder failure at a null source atom. -/
example :
    highNullSource true = 0 ∧
    id true ≠ highNullDecoder (false, highNullAuxiliary true) ∧
    IsCanonicalFunctionalRepresentationOf highNullSource (fun _ => false) id
      (fun s => decoderVector highNullDecoder (highNullAuxiliary s)) ∧
    mutualInfoOf highNullSource id
      (fun s => decoderVector highNullDecoder (highNullAuxiliary s)) =
      mutualInfoOf highNullSource id highNullAuxiliary ∧
    IsPerfectFunctionalRepresentationOf highNullSource (fun _ => false) id
      (fun s => decoderVector highNullDecoder (highNullAuxiliary s)) := by
  have hI := constantInputIndependent highNullSource false highNullAuxiliary
  exact ⟨by simp [highNullSource], by decide,
    isCanonicalFunctionalRepresentationOf_decoderVector highNullSource (fun _ => false) id
      highNullAuxiliary highNullDecoder hI highNullDecoderCorrect,
    mutualInfoOf_decoderVector_eq highNullSource (fun _ => false) id highNullAuxiliary
      highNullDecoder hI highNullDecoderCorrect,
    highNullPerfect.decoderVector highNullDecoder highNullDecoderCorrect⟩

private def highNullPair : PMF (Bool × Bool) := highNullSource.map fun s => (false, s)

/--
R07: a higher-universe perfect auxiliary passes through both directions of
canonical sufficiency and still produces C01's finite triple-law extension.
-/
example :
    (∃ q : PMF (Bool → Bool),
      fstSndMarginal (canonicalJoint (fstMarginal highNullPair) q) = highNullPair ∧
      IsPerfectFunctionalRepresentation (canonicalJoint (fstMarginal highNullPair) q)) ∧
    (∃ n : Nat, ∃ r : PMF (Bool × Bool × Fin n),
      fstSndMarginal r = highNullPair ∧ IsPerfectFunctionalRepresentation r) := by
  have hPair : IsPerfectlyRepresentablePair highNullPair :=
    highNullPerfect.isPerfectlyRepresentablePairOf
  have hCanonical := (isPerfectlyRepresentablePair_iff_exists_canonicalJoint highNullPair).1 hPair
  have hRecovered :=
    (isPerfectlyRepresentablePair_iff_exists_canonicalJoint highNullPair).2 hCanonical
  exact ⟨hCanonical, hRecovered⟩

/-! ## Common posterior, supported factorization and null fibers -/

/-- The channel predicate extracts one shared law and posterior, and coupling is derived. -/
example {alpha : Type u} {beta : Type v} [Nonempty alpha] (kappa : alpha → PMF beta)
    (h : IsPerfectlyRepresentableChannel kappa) :
    ∃ q : PMF (alpha → beta), ∃ V : beta → PMF (alpha → beta),
      IsCanonicalCoupling kappa q ∧
      ∀ a, q.map (fun f => (f a, f)) = PMF.channelJoint (kappa a) V := by
  obtain ⟨q, V, h⟩ := h
  exact ⟨q, V, isCanonicalCoupling_of_coordinateFactorization q kappa V h, h⟩

/-- Fixed-posterior cancellation is support-aware without finite alphabet assumptions. -/
example {alpha : Type u} {beta : Type v}
    (p : PMF alpha) (q : PMF (alpha → beta)) (kappa : alpha → PMF beta)
    (V : beta → PMF (alpha → beta)) :
    canonicalJoint p q = PMF.channelExtension (PMF.channelJoint p kappa) V ↔
      ∀ a ∈ p.support, q.map (fun f => (f a, f)) = PMF.channelJoint (kappa a) V :=
  canonicalJoint_eq_channelExtension_iff p q kappa V

/-- Full support upgrades the very same posterior to all input rows. -/
example {alpha : Type u} {beta : Type v}
    (p : PMF alpha) (q : PMF (alpha → beta)) (kappa : alpha → PMF beta)
    (V : beta → PMF (alpha → beta)) (hp : ∀ a, a ∈ p.support) :
    canonicalJoint p q = PMF.channelExtension (PMF.channelJoint p kappa) V ↔
      ∀ a, q.map (fun f => (f a, f)) = PMF.channelJoint (kappa a) V :=
  canonicalJoint_eq_channelExtension_iff_of_fullSupport p q kappa V hp

/-- The fixed-q converse requires coupling and full support, but only finite vector alphabet. -/
example {alpha : Type u} {beta : Type v} [Nonempty alpha] [Finite (alpha → beta)]
    (p : PMF alpha) (q : PMF (alpha → beta)) (kappa : alpha → PMF beta)
    (hC : IsCanonicalCoupling kappa q) (hp : ∀ a, a ∈ p.support) :
    IsMarkovChain (canonicalJoint p q) ↔
      ∃ V : beta → PMF (alpha → beta),
        ∀ a, q.map (fun f => (f a, f)) = PMF.channelJoint (kappa a) V :=
  (hC.exists_commonPosterior_iff_isMarkovChain p hp).symm

/-- A supplied common posterior works under any prior, including a point prior. -/
example {alpha : Type u} {beta : Type v} [Nonempty alpha]
    [Fintype alpha] [Fintype beta] [Fintype (alpha → beta)]
    (p : PMF alpha) (q : PMF (alpha → beta)) (kappa : alpha → PMF beta)
    (V : beta → PMF (alpha → beta))
    (h : ∀ a, q.map (fun f => (f a, f)) = PMF.channelJoint (kappa a) V) :
    IsMarkovChain (canonicalJoint p q) ∧
      IsPerfectFunctionalRepresentation (canonicalJoint p q) :=
  ⟨isMarkovChain_canonicalJoint_of_coordinateFactorization p q kappa V h,
    isPerfectFunctionalRepresentation_canonicalJoint_of_coordinateFactorization p q kappa V h⟩

/-- Posterior invariance uses only row support, with arbitrary alphabets. -/
example {alpha : Type u} {beta : Type v}
    (q : PMF (alpha → beta)) (kappa : alpha → PMF beta)
    (V V' : beta → PMF (alpha → beta))
    (h : ∀ b, (∃ a, b ∈ (kappa a).support) → V b = V' b) :
    (∀ a, q.map (fun f => (f a, f)) = PMF.channelJoint (kappa a) V) ↔
      ∀ a, q.map (fun f => (f a, f)) = PMF.channelJoint (kappa a) V' :=
  coordinateFactorization_congr_posterior q kappa V V' h

/-- R03: a fixed-posterior triple equality under a point prior does not control its null row. -/
example :
    canonicalJoint unusedRowPrior unusedRowVector =
      PMF.channelExtension (PMF.channelJoint unusedRowPrior unusedRowChannel)
        (fun _ => unusedRowVector) ∧
    ¬ (∀ a, unusedRowVector.map (fun f => (f a, f)) =
      PMF.channelJoint (unusedRowChannel a) (fun _ => unusedRowVector)) := by
  constructor
  · apply (canonicalJoint_eq_channelExtension_iff _ _ _ _).2
    intro a ha
    have haFalse : a = false := by simpa [unusedRowPrior] using ha
    subst a
    simp [unusedRowVector, unusedRowChannel, PMF.channelJoint, PMF.pure_map]
  · intro h
    have hC := isCanonicalCoupling_of_coordinateFactorization
      unusedRowVector unusedRowChannel (fun _ => unusedRowVector) h
    have hMass := congrArg (fun q : PMF Bool => q true) (hC true)
    norm_num [unusedRowVector, unusedRowChannel, PMF.pure_map] at hMass

private def pointPriorVector (b a : Bool) : Bool := a && b

/-- Uniformly mixing the vectors (false,false) and (false,true). -/
private def pointPriorLaw : PMF (Bool → Bool) := fairBit.map pointPriorVector

private def pointPriorChannel (a : Bool) : PMF Bool := pointPriorLaw.map (fun f => f a)

private theorem pointPriorVector_mem (b : Bool) : pointPriorVector b ∈ pointPriorLaw.support := by
  rw [pointPriorLaw, PMF.mem_support_map_iff]
  exact ⟨b, by simp [fairBit], rfl⟩

private theorem pointPriorChannel_false : pointPriorChannel false = PMF.pure false := by
  simp only [pointPriorChannel, pointPriorLaw, PMF.map_comp, Function.comp_def,
    pointPriorVector, Bool.false_and]
  exact PMF.map_const _ _

private theorem pointPriorFactorization : pointPriorLaw.map (fun f => (f false, f)) =
    PMF.channelJoint (pointPriorChannel false) (fun _ => pointPriorLaw) := by
  rw [pointPriorChannel_false]
  simp [PMF.channelJoint, pointPriorLaw, PMF.map_comp, Function.comp_def, pointPriorVector]

private theorem pointPriorPerfect :
    IsPerfectFunctionalRepresentation (canonicalJoint (PMF.pure false) pointPriorLaw) := by
  apply (isPerfectFunctionalRepresentation_canonicalJoint_iff_isMarkovChain _ _).2
  have hLaw := (canonicalJoint_eq_channelExtension_iff (PMF.pure false) pointPriorLaw
    pointPriorChannel (fun _ => pointPriorLaw)).2 (by
      intro a ha
      have haFalse : a = false := by simpa using ha
      subst a
      exact pointPriorFactorization)
  rw [hLaw]
  exact isMarkovChain_channelExtension _ _

private theorem pointPriorNoPosterior :
    ¬ ∃ V : Bool → PMF (Bool → Bool),
      ∀ a, pointPriorLaw.map (fun f => (f a, f)) = PMF.channelJoint (pointPriorChannel a) V := by
  rintro ⟨V, hV⟩
  have hZero : (false, pointPriorVector true) ∈
      (pointPriorLaw.map (fun f => (f false, f))).support := by
    rw [PMF.mem_support_map_iff]
    exact ⟨pointPriorVector true, pointPriorVector_mem true, rfl⟩
  rw [hV false, PMF.mem_support_channelJoint_iff] at hZero
  have hFalse : false ∈ (pointPriorChannel true).support := by
    rw [pointPriorChannel, PMF.mem_support_map_iff]
    exact ⟨pointPriorVector false, pointPriorVector_mem false, rfl⟩
  have hWrong : (false, pointPriorVector true) ∈
      (pointPriorLaw.map (fun f => (f true, f))).support := by
    rw [hV true, PMF.mem_support_channelJoint_iff]
    exact ⟨hFalse, hZero.2⟩
  rw [PMF.mem_support_map_iff] at hWrong
  obtain ⟨f, _, hf⟩ := hWrong
  have hfVector := congrArg Prod.snd hf
  have hfOutput := congrArg Prod.fst hf
  simp only at hfVector hfOutput
  rw [hfVector] at hfOutput
  exact Bool.false_ne_true hfOutput.symm

/--
R08: the fixed coupling is perfect under a point prior but has no common
posterior, and the same vector law fails Markov under a full-support prior.
-/
example :
    IsCanonicalCoupling pointPriorChannel pointPriorLaw ∧
    IsPerfectFunctionalRepresentation (canonicalJoint (PMF.pure false) pointPriorLaw) ∧
    (¬ ∃ V : Bool → PMF (Bool → Bool),
      ∀ a, pointPriorLaw.map (fun f => (f a, f)) = PMF.channelJoint (pointPriorChannel a) V) ∧
    ¬ IsMarkovChain (canonicalJoint fairBit pointPriorLaw) := by
  have hC : IsCanonicalCoupling pointPriorChannel pointPriorLaw := fun _ => rfl
  refine ⟨hC, pointPriorPerfect, pointPriorNoPosterior, ?_⟩
  intro hM
  apply pointPriorNoPosterior
  exact (hC.exists_commonPosterior_iff_isMarkovChain fairBit (by intro a; simp [fairBit])).2 hM

private def nullOutputLaw : PMF (Bool → Bool) := PMF.pure (fun _ => false)
private def nullOutputChannel (_ : Bool) : PMF Bool := PMF.pure false
private def nullOutputPosterior (_ : Bool) : PMF (Bool → Bool) := nullOutputLaw
private def nullOutputOtherPosterior (b : Bool) : PMF (Bool → Bool) :=
  if b then PMF.pure (fun _ => true) else nullOutputLaw

private theorem nullOutputFactorization : ∀ a,
    nullOutputLaw.map (fun f => (f a, f)) =
      PMF.channelJoint (nullOutputChannel a) nullOutputPosterior := by
  intro a
  simp [nullOutputLaw, nullOutputChannel, nullOutputPosterior, PMF.channelJoint, PMF.pure_map]

/-- R09: changing the posterior at a globally unused output preserves factorization. -/
example :
    IsPerfectlyRepresentableChannel nullOutputChannel ∧
    nullOutputPosterior ≠ nullOutputOtherPosterior ∧
    (∀ a, nullOutputChannel a true = 0) ∧
    (∀ a, nullOutputLaw.map (fun f => (f a, f)) =
      PMF.channelJoint (nullOutputChannel a) nullOutputPosterior) ∧
    (∀ a, nullOutputLaw.map (fun f => (f a, f)) =
      PMF.channelJoint (nullOutputChannel a) nullOutputOtherPosterior) := by
  refine ⟨⟨nullOutputLaw, nullOutputPosterior, nullOutputFactorization⟩,
    ?_, by intro a; simp [nullOutputChannel], nullOutputFactorization, ?_⟩
  · intro h
    have hMass := congrArg (fun V => V true (fun _ => false)) h
    norm_num [nullOutputPosterior, nullOutputOtherPosterior, nullOutputLaw] at hMass
    exact Bool.false_ne_true (congrFun hMass false)
  · apply (coordinateFactorization_congr_posterior nullOutputLaw nullOutputChannel
      nullOutputPosterior nullOutputOtherPosterior ?_).1 nullOutputFactorization
    rintro b ⟨a, hb⟩
    have hbFalse : b = false := by simpa [nullOutputChannel] using hb
    subst b
    rfl

/-! ## Prior reuse and full-support pair bridges -/

/-- Remark 1 reuses the specified vector law on fresh canonical joints for all
priors, with no finite alphabet or original-source assumption. -/
example {alpha : Type u} {beta : Type v} (q : PMF (alpha → beta))
    (kappa : alpha → PMF beta) (hC : IsCanonicalCoupling kappa q) :
    ∀ p : PMF alpha, IsCanonicalFunctionalRepresentation (canonicalJoint p q) ∧
      fstMarginal (canonicalJoint p q) = p ∧
      thirdMarginal (canonicalJoint p q) = q ∧
      fstSndMarginal (canonicalJoint p q) = PMF.channelJoint p kappa :=
  fun p => ⟨isCanonicalFunctionalRepresentation_canonicalJoint p q,
    fstMarginal_canonicalJoint p q, thirdMarginal_canonicalJoint p q,
    hC.fstSndMarginal_canonicalJoint p⟩

/-- The perfect vector law is chosen before the input prior. -/
example {alpha : Type u} {beta : Type v} [Nonempty alpha]
    [Fintype alpha] [Fintype beta] [Fintype (alpha → beta)]
    (kappa : alpha → PMF beta) (h : IsPerfectlyRepresentableChannel kappa) :
    ∃ q : PMF (alpha → beta), IsCanonicalCoupling kappa q ∧
      ∀ p : PMF alpha, thirdMarginal (canonicalJoint p q) = q ∧
        fstSndMarginal (canonicalJoint p q) = PMF.channelJoint p kappa ∧
        IsPerfectFunctionalRepresentation (canonicalJoint p q) := by
  obtain ⟨q, hC, hP⟩ := h.exists_canonicalCoupling
  exact ⟨q, hC, fun p => ⟨thirdMarginal_canonicalJoint p q,
    hC.fstSndMarginal_canonicalJoint p, hP p⟩⟩

/-- Pair-level callers supply neither a function enumeration nor a default output. -/
example {alpha : Type u} {beta : Type v} [Nonempty alpha]
    [Fintype alpha] [Fintype beta] (p : PMF alpha) (kappa : alpha → PMF beta)
    (hp : ∀ a, a ∈ p.support) :
    IsPerfectlyRepresentablePair (PMF.channelJoint p kappa) ↔
      IsPerfectlyRepresentableChannel kappa :=
  isPerfectlyRepresentablePair_channelJoint_iff_of_fullSupport p kappa hp

/-- Both quantifier formulations preserve the full-support existential premise. -/
example {alpha : Type u} {beta : Type v} [Nonempty alpha]
    [Fintype alpha] [Fintype beta] (kappa : alpha → PMF beta) :
    (IsPerfectlyRepresentableChannel kappa ↔
      ∀ p : PMF alpha, IsPerfectlyRepresentablePair (PMF.channelJoint p kappa)) ∧
    (IsPerfectlyRepresentableChannel kappa ↔
      ∃ p : PMF alpha, (∀ a, a ∈ p.support) ∧
        IsPerfectlyRepresentablePair (PMF.channelJoint p kappa)) :=
  ⟨isPerfectlyRepresentableChannel_iff_forall_prior kappa,
    isPerfectlyRepresentableChannel_iff_exists_fullSupport_prior kappa⟩

/-- The original source is unrestricted; the conclusion permits an extension. -/
example {omega : Type u} {alpha : Type v} {beta : Type w}
    [Nonempty alpha] [Fintype alpha] [Fintype beta]
    (mu : PMF omega) (X : omega → alpha) (Y : omega → beta)
    (p : PMF alpha) (kappa : alpha → PMF beta)
    (hLaw : mu.map (fun s => (X s, Y s)) = PMF.channelJoint p kappa)
    (h : IsPerfectlyRepresentableChannel kappa) :
    IsPerfectlyRepresentablePairOf mu X Y :=
  h.isPerfectlyRepresentablePairOf mu X Y p hLaw

private def biasedBit : PMF Bool :=
  PMF.ofFintype (fun b => if b then (1 : ENNReal) / 3 else 2 / 3) (by
    rw [Fintype.sum_bool]
    change (1 : ENNReal) / 3 + 2 / 3 = 1
    rw [ENNReal.div_add_div_same]
    norm_num
    exact ENNReal.div_self (by norm_num) (by norm_num))

private theorem biasedBit_fullSupport (b : Bool) : b ∈ biasedBit.support := by
  cases b <;> norm_num [biasedBit, PMF.mem_support_iff, PMF.ofFintype_apply]

private theorem fairBit_ne_biasedBit : fairBit ≠ biasedBit := by
  intro h
  have hm := congrArg (fun p : PMF Bool => p true) h
  norm_num [fairBit, biasedBit, PMF.uniformOfFintype_apply, PMF.ofFintype_apply] at hm

/-- R10: the prior-change equivalence is instantiated with distinct full-support laws. -/
example : fairBit ≠ biasedBit ∧ (∀ b, b ∈ fairBit.support) ∧
    (∀ b, b ∈ biasedBit.support) ∧
    ∀ kappa : Bool → PMF Bool,
      IsPerfectlyRepresentablePair (PMF.channelJoint fairBit kappa) ↔
        IsPerfectlyRepresentablePair (PMF.channelJoint biasedBit kappa) := by
  refine ⟨fairBit_ne_biasedBit, (by intro b; simp [fairBit]), biasedBit_fullSupport, ?_⟩
  intro kappa
  exact isPerfectlyRepresentablePair_channelJoint_congr_prior fairBit biasedBit kappa
    (by intro b; simp [fairBit]) biasedBit_fullSupport

/-- R10: a zero-mass input does not obstruct the all-prior forward implication. -/
example : (PMF.pure false : PMF Bool) true = 0 ∧
    IsPerfectlyRepresentablePair (PMF.channelJoint (PMF.pure false)
      (fun b : Bool => PMF.pure b)) := by
  have h : IsPerfectlyRepresentableChannel (fun b : Bool => PMF.pure b) := by
    refine ⟨PMF.pure id, fun _ => PMF.pure id, ?_⟩
    intro b
    simp [PMF.channelJoint, PMF.pure_map]
  exact ⟨by simp, h.isPerfectlyRepresentablePair _⟩

/-- Singleton alphabets instantiate both the forward bridge and full-support converse. -/
example : IsPerfectlyRepresentablePair
      (PMF.channelJoint (PMF.pure ()) (fun _ : Unit => PMF.pure ())) ∧
    (IsPerfectlyRepresentablePair
      (PMF.channelJoint (PMF.pure ()) (fun _ : Unit => PMF.pure ())) ↔
        IsPerfectlyRepresentableChannel (fun _ : Unit => PMF.pure ())) := by
  have h : IsPerfectlyRepresentableChannel (fun _ : Unit => PMF.pure ()) := by
    refine ⟨PMF.pure (fun _ => ()), fun _ => PMF.pure (fun _ => ()), ?_⟩
    intro a
    simp [PMF.channelJoint, PMF.pure_map]
  exact ⟨h.isPerfectlyRepresentablePair _,
    isPerfectlyRepresentablePair_channelJoint_iff_of_fullSupport _ _
      (by intro a; cases a; simp)⟩

/-- R09 at the pair boundary: unused output symbols are allowed for every prior. -/
example : (∀ a, nullOutputChannel a true = 0) ∧
    (IsPerfectlyRepresentablePair (PMF.channelJoint fairBit nullOutputChannel) ↔
      IsPerfectlyRepresentableChannel nullOutputChannel) ∧
    ∀ p : PMF Bool, IsPerfectlyRepresentablePair (PMF.channelJoint p nullOutputChannel) := by
  have h : IsPerfectlyRepresentableChannel nullOutputChannel :=
    ⟨nullOutputLaw, nullOutputPosterior, nullOutputFactorization⟩
  exact ⟨(by intro a; simp [nullOutputChannel]),
    isPerfectlyRepresentablePair_channelJoint_iff_of_fullSupport fairBit nullOutputChannel
      (by intro b; simp [fairBit]), fun p => h.isPerfectlyRepresentablePair p⟩

/-! ## Input-support restriction -/

/-- The support prior construction itself needs no finite alphabet assumption. -/
example {alpha : Type u} {beta : Type v} (p : PMF alpha) (kappa : alpha → PMF beta) :
    (∀ s, s ∈ (inputSupportPrior p).support) ∧
    (inputSupportPrior p).map Subtype.val = p ∧
    (PMF.channelJoint (inputSupportPrior p) (fun s => kappa s.val)).map
      (fun sb => (sb.1.val, sb.2)) = PMF.channelJoint p kappa :=
  ⟨mem_support_inputSupportPrior p, map_val_inputSupportPrior p,
    channelJoint_inputSupportPrior_map_val p kappa⟩

/-- Both directions cross the input value-type boundary, retaining finite witnesses. -/
example {alpha : Type u} {beta : Type v} [Fintype alpha] [Fintype beta]
    (p : PMF alpha) [Fintype p.support] (kappa : alpha → PMF beta) :
    (IsPerfectlyRepresentablePair (PMF.channelJoint p kappa) →
      IsPerfectlyRepresentablePair
        (PMF.channelJoint (inputSupportPrior p) (fun s => kappa s.val))) ∧
    (IsPerfectlyRepresentablePair
        (PMF.channelJoint (inputSupportPrior p) (fun s => kappa s.val)) →
      IsPerfectlyRepresentablePair (PMF.channelJoint p kappa)) :=
  ⟨(isPerfectlyRepresentablePair_channelJoint_iff_inputSupportPrior p kappa).1,
    (isPerfectlyRepresentablePair_channelJoint_iff_inputSupportPrior p kappa).2⟩

/-- R11: the arbitrary-prior theorem derives support nonemptiness internally. -/
example {alpha : Type u} {beta : Type v} [Fintype alpha] [Fintype beta]
    (p : PMF alpha) (kappa : alpha → PMF beta) :
    IsPerfectlyRepresentablePair (PMF.channelJoint p kappa) ↔
      @IsPerfectlyRepresentableChannel p.support beta p.support_nonempty.to_subtype
        (fun s => kappa s.val) :=
  isPerfectlyRepresentablePair_channelJoint_iff_restrict_support p kappa

private def properSupportPrior : PMF (Option Bool) := fairBit.map some

private theorem properSupportPrior_mem (b : Bool) : some b ∈ properSupportPrior.support := by
  rw [properSupportPrior, PMF.mem_support_map_iff]
  exact ⟨b, by simp [fairBit], rfl⟩

private theorem properSupportPrior_none : none ∉ properSupportPrior.support := by
  simp [properSupportPrior]

private def properSupportChannel (unused : Bool) : Option Bool → PMF Bool
  | none => PMF.pure unused
  | some b => PMF.pure b

private theorem properSupportChannel_agree (s : properSupportPrior.support) :
    properSupportChannel false s.val = properSupportChannel true s.val := by
  obtain ⟨a, ha⟩ := s
  cases a with
  | none => exact (properSupportPrior_none ha).elim
  | some b => rfl

/-- R11: proper support contains two inputs, and its normalized law maps back exactly. -/
example : none ∉ properSupportPrior.support ∧
    some false ∈ properSupportPrior.support ∧ some true ∈ properSupportPrior.support ∧
    (inputSupportPrior properSupportPrior).map Subtype.val = properSupportPrior ∧
    (∀ s, s ∈ (inputSupportPrior properSupportPrior).support) :=
  ⟨properSupportPrior_none, properSupportPrior_mem false, properSupportPrior_mem true,
    map_val_inputSupportPrior properSupportPrior, mem_support_inputSupportPrior properSupportPrior⟩

/-- R11: changing an unused ambient row leaves the restricted channel and pair
property unchanged, although the two ambient channels differ. -/
example : properSupportChannel false ≠ properSupportChannel true ∧
    (fun s : properSupportPrior.support => properSupportChannel false s.val) =
      (fun s : properSupportPrior.support => properSupportChannel true s.val) ∧
    (IsPerfectlyRepresentablePair
        (PMF.channelJoint properSupportPrior (properSupportChannel false)) ↔
      IsPerfectlyRepresentablePair
        (PMF.channelJoint properSupportPrior (properSupportChannel true))) := by
  have hRestricted := funext properSupportChannel_agree
  refine ⟨?_, hRestricted, ?_⟩
  · intro h
    have hm := congrArg (fun k : Option Bool → PMF Bool => k none false) h
    simp [properSupportChannel] at hm
  · rw [isPerfectlyRepresentablePair_channelJoint_iff_restrict_support,
      isPerfectlyRepresentablePair_channelJoint_iff_restrict_support, hRestricted]

/-- R11: a singleton input support and globally unused output do not obstruct
transport; the concrete pair and restricted channel both satisfy the property. -/
example : (∀ a, a ∈ (PMF.pure false : PMF Bool).support ↔ a = false) ∧
    (∀ a, nullOutputChannel a true = 0) ∧
    IsPerfectlyRepresentablePair (PMF.channelJoint (PMF.pure false) nullOutputChannel) ∧
    @IsPerfectlyRepresentableChannel (PMF.pure false : PMF Bool).support Bool
      (PMF.pure false : PMF Bool).support_nonempty.to_subtype
      (fun s => nullOutputChannel s.val) := by
  have h : IsPerfectlyRepresentableChannel nullOutputChannel :=
    ⟨nullOutputLaw, nullOutputPosterior, nullOutputFactorization⟩
  have hPair := h.isPerfectlyRepresentablePair (PMF.pure false)
  exact ⟨by intro a; simp, by intro a; simp [nullOutputChannel], hPair,
    (isPerfectlyRepresentablePair_channelJoint_iff_restrict_support _ _).1 hPair⟩

/-! ## Empty-carrier boundaries -/

/-- R12: an empty source type cannot carry a normalized PMF. -/
example {omega : Type u} [IsEmpty omega] : IsEmpty (PMF omega) := by
  refine ⟨fun p => ?_⟩
  obtain ⟨s, _⟩ := p.support_nonempty
  exact isEmptyElim s

/-- R12: a pair law cannot have an empty input carrier. -/
example {alpha : Type u} {beta : Type v} [IsEmpty alpha] :
    IsEmpty (PMF (alpha × beta)) := by
  refine ⟨fun p => ?_⟩
  obtain ⟨ab, _⟩ := p.support_nonempty
  exact isEmptyElim ab.1

/-- R12: a pair law cannot have an empty output carrier. -/
example {alpha : Type u} {beta : Type v} [IsEmpty beta] :
    IsEmpty (PMF (alpha × beta)) := by
  refine ⟨fun p => ?_⟩
  obtain ⟨ab, _⟩ := p.support_nonempty
  exact isEmptyElim ab.2

/-- R12: even a vacuous channel cannot supply the intrinsic predicate's
required nonempty input instance. -/
example {alpha : Type u} {beta : Type v} [IsEmpty alpha]
    (kappa : alpha → PMF beta) :
    ¬ ∃ h : Nonempty alpha, @IsPerfectlyRepresentableChannel alpha beta h kappa := by
  rintro ⟨⟨a⟩, _⟩
  exact isEmptyElim a

/-- R12: an actual row supplies output nonemptiness; no default output is needed. -/
example {alpha : Type u} {beta : Type v} [Nonempty alpha]
    (kappa : alpha → PMF beta) : Nonempty beta := by
  obtain ⟨a⟩ := ‹Nonempty alpha›
  obtain ⟨b, _⟩ := (kappa a).support_nonempty
  exact ⟨b⟩

/-- R12: with a nonempty input, there is no channel into an empty output type. -/
example {alpha : Type u} {beta : Type v} [Nonempty alpha] [IsEmpty beta] :
    IsEmpty (alpha → PMF beta) := by
  refine ⟨fun kappa => ?_⟩
  obtain ⟨a⟩ := ‹Nonempty alpha›
  obtain ⟨b, _⟩ := (kappa a).support_nonempty
  exact isEmptyElim b

end

end PerfectFunctionalRepresentations
