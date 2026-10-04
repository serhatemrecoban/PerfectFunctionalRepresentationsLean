import PerfectFunctionalRepresentations

/-!
# Root-only binary semantic consumers

R18 uses the mathematical root as its sole import. Combined Lemma 2 and the
finite Lemma 3 package remain usable without importing regressions, examples or
the optional decoder bridge. Source and value alphabets have independent universes.
-/

namespace PerfectFunctionalRepresentations

open LeanInfoTheory.Shannon

universe u v w x

-- Combined Lemma 2 retains both the input and active-output alternatives.
example {alpha : Type u} {beta : Type v} [Fintype alpha] [Finite beta]
    [Nonempty alpha] (kappa : alpha → PMF beta) (hs : IsSingularChannel kappa) :
    let : Fintype (activeOutputs kappa) := Fintype.ofFinite _
    Fintype.card alpha = 2 ∨ Fintype.card (activeOutputs kappa) ≤ 2 →
      IsPerfectlyRepresentableChannel kappa := by
  dsimp only
  intro hcard
  exact (isPerfectlyRepresentableChannel_iff_isSingular_of_binary kappa hcard).2 hs

-- The printed ambient-output clause remains directly available from C03.
example (kappa : Fin 3 → PMF Bool) (hs : IsSingularChannel kappa) :
    IsPerfectlyRepresentableChannel kappa :=
  (isPerfectlyRepresentableChannel_iff_isSingular_of_card_le_two kappa (by decide)).2 hs

-- A cardinality-two input gives a specified finite canonical attainer dominating
-- every original finite auxiliary on an unrestricted source with the same pair law.
open scoped Classical in
example {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    (hcard : Fintype.card alpha = 2) (p : PMF alpha) (kappa : alpha → PMF beta) :
    let e := Fintype.equivFinOfCardEq hcard
    ∃ t : PMF (alpha × beta × (alpha → beta)),
      IsCanonicalFunctionalRepresentation t ∧
      fstSndMarginal t = PMF.channelJoint p kappa ∧
      mutualInfoOf t (fun z => z.2.1) (fun z => z.2.2) =
        entropy (sndMarginal (PMF.channelJoint p kappa)) -
          finiteTV (kappa (e.symm 0)) (kappa (e.symm 1)) * entropy p ∧
      ∀ (mu : PMF omega) (X : omega → alpha) (Y : omega → beta) (Z : omega → gamma),
        IsFunctionalRepresentationOf mu X Y Z →
        mu.map (fun s => (X s, Y s)) = PMF.channelJoint p kappa →
        mutualInfoOf mu Y Z ≤ mutualInfoOf t (fun z => z.2.1) (fun z => z.2.2) := by
  classical
  let e := Fintype.equivFinOfCardEq hcard
  obtain ⟨hC, hPair, hInfo⟩ := maximalTwoInputCanonicalJoint_attains e p kappa
  refine ⟨_, hC, hPair, hInfo, ?_⟩
  intro mu X Y Z hFR hOriginal
  have hX : mu.map X = p := by
    simpa only [fstMarginal_map_pair, PMF.channelJoint_map_fst] using
      congrArg fstMarginal hOriginal
  have hY : mu.map Y = sndMarginal (PMF.channelJoint p kappa) := by
    simpa only [sndMarginal_map_pair] using congrArg sndMarginal hOriginal
  rw [hInfo]
  simpa only [entropyOf, hX, hY] using
    hFR.mutualInfoOf_le_twoInput_bound e p kappa hOriginal

-- Inequality and singular forward equality keep every prior. Only the converse
-- needs full input support, including when consumed on an arbitrary source.
example {omega : Type u} {alpha : Type v} {beta : Type w}
    [Fintype alpha] [Fintype beta] (e : alpha ≃ Fin 2)
    (mu : PMF omega) (X : omega → alpha) (Y : omega → beta)
    (p : PMF alpha) (kappa : alpha → PMF beta)
    (hPair : mu.map (fun s => (X s, Y s)) = PMF.channelJoint p kappa) :
    mutualInfoOf mu X Y ≤
        finiteTV (kappa (e.symm 0)) (kappa (e.symm 1)) * entropyOf mu X ∧
    (IsSingularChannel kappa →
      finiteTV (kappa (e.symm 0)) (kappa (e.symm 1)) * entropyOf mu X =
        mutualInfoOf mu X Y) ∧
    ((∀ a, a ∈ p.support) →
      (finiteTV (kappa (e.symm 0)) (kappa (e.symm 1)) * entropyOf mu X =
        mutualInfoOf mu X Y ↔ IsSingularChannel kappa)) := by
  refine ⟨mutualInfoOf_le_twoInput_entropy e mu X Y p kappa hPair, ?_, ?_⟩
  · intro hs
    exact hs.twoInput_entropyOf_eq_mutualInfoOf e mu X Y p hPair
  · intro hp
    exact twoInput_entropyOf_eq_mutualInfoOf_iff_isSingular_of_fullSupport
      e mu X Y p kappa hPair hp

end PerfectFunctionalRepresentations
