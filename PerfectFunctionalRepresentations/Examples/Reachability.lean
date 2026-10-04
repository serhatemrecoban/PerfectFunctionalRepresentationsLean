import PerfectFunctionalRepresentations.Matrix.Reachability
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum

/-!
# The reduction in extended Example 6

Extended manuscript, designated version 16 (2026-09-03), page 5, (25)-(32).
Inputs index rows and outputs index columns; printed indices become zero-based.
The displayed matrices are specified independently of the operation endpoints.
The exact path uses VPM/PPM/VPM/PPM at (1,2), (1,3), (0,2), (0,1).
Equation (30) permutes the last two outputs of the actual lower-survivor PPM
result. That comparison is explicit and does not count as an operation.
The reverse cascade and prior-free perfectness use the public easy direction.
All fixture declarations remain private; this module is separately importable.
-/

namespace PerfectFunctionalRepresentations.MatrixOperations

open ActiveFiniteChannel
open scoped BigOperators ENNReal
noncomputable section
attribute [local simp] Matrix.cons_val_two Matrix.cons_val_three Matrix.cons_val_four

-- The entries of (25), independently supplied in the printed row order.
private def matrix25 : Matrix (Fin 3) (Fin 5) NNReal :=
  ![![1 / 3, 1 / 3, 0, 0, 1 / 3],
    ![1 / 3, 0, 1 / 3, 0, 1 / 3],
    ![0, 1 / 3, 0, 1 / 3, 1 / 3]]

-- Equations (26) and (27) give the same ordered list of valued patterns.
private def patterns26 : Fin 5 → Finset (Fin 3) :=
  ![{0, 1}, {0, 2}, {1}, {2}, Finset.univ]

private def columns26 : Fin 5 → Fin 3 → NNReal :=
  ![![1, 1, 0], ![1, 0, 1], ![0, 1, 0], ![0, 0, 1], ![1, 1, 1]]

private theorem matrix25_sum (x : Fin 3) : ∑ j, matrix25 x j = 1 := by
  fin_cases x <;> norm_num [matrix25, Fin.sum_univ_succ]

private def sourceWitness : Fin 5 → Fin 3 := ![0, 0, 1, 2, 0]

private theorem matrix25_active (j : Fin 5) :
    (matrix25 (sourceWitness j) j : ENNReal) ≠ 0 := by
  fin_cases j <;> change ((1 / 3 : NNReal) : ENNReal) ≠ 0 <;> norm_num

private abbrev source : ActiveFiniteChannel (Fin 3) where
  outputCard := 5
  outputCard_pos := by decide
  channel := fun x => PMF.ofFintype (fun j => (matrix25 x j : ENNReal))
    (by exact_mod_cast matrix25_sum x)
  output_active j := ⟨sourceWitness j, matrix25_active j⟩

private theorem source_coordinates (x : Fin 3) (j : Fin 5) :
    source.channel x j = (matrix25 x j : ENNReal) := rfl

private theorem source_singular : IsSingularChannel source.channel := by
  intro x z j hx hz
  change (matrix25 x j : ENNReal) = (matrix25 z j : ENNReal)
  change (matrix25 x j : ENNReal) ≠ 0 at hx
  change (matrix25 z j : ENNReal) ≠ 0 at hz
  fin_cases x <;> fin_cases z <;> fin_cases j <;> norm_num [matrix25] at *

private theorem source_values (j : Fin 5) :
    columnValue source.channel source_singular (source.activeEquiv j) =
      ((1 / 3 : NNReal) : ENNReal) := by
  rw [columnValue_eq_of_ne_zero _ _ _ (x := sourceWitness j) (matrix25_active j)]
  fin_cases j <;> rfl

private theorem source_patterns (j : Fin 5) :
    (columnPattern source.channel (source.activeEquiv j)).val = patterns26 j := by
  ext x
  rw [mem_columnPattern]
  change (matrix25 x j : ENNReal) ≠ 0 ↔ x ∈ patterns26 j
  fin_cases j <;> fin_cases x <;>
    norm_num [matrix25, patterns26, Fin.ext_iff, -Fin.val_eq_zero_iff]

-- This checks every coefficient of both (26) and its repeated display (27).
example (x : Fin 3) (j : Fin 5) :
    source.channel x j = (((1 / 3 : NNReal) * columns26 j x : NNReal) : ENNReal) := by
  fin_cases x <;> fin_cases j <;> norm_num [source_coordinates, matrix25, columns26]

private theorem first_values :
    columnValue source.channel source_singular (source.activeEquiv 1) =
      columnValue source.channel source_singular (source.activeEquiv 2) := by
  rw [source_values, source_values]

private theorem first_disjoint (x : Fin 3) (hx : source.channel x 1 ≠ 0) :
    source.channel x 2 = 0 := by
  fin_cases x <;> norm_num [source_coordinates, matrix25] at *

private abbrev first := vpm source source_singular 1 2 (by decide)
  first_values first_disjoint

private def firstEdge : OperationStep source first :=
  .vpm source source_singular 1 2 (by decide) first_values first_disjoint

-- The row form of (28), repeated as valued columns in (29).
private def matrix28 : Matrix (Fin 3) (Fin 4) NNReal :=
  ![![1 / 3, 1 / 3, 0, 1 / 3],
    ![1 / 3, 1 / 3, 0, 1 / 3],
    ![0, 1 / 3, 1 / 3, 1 / 3]]

private def columns29 : Fin 4 → Fin 3 → NNReal :=
  ![![1, 1, 0], ![1, 1, 1], ![0, 0, 1], ![1, 1, 1]]

private theorem first_coordinates (x : Fin 3) (j : Fin 4) :
    first.channel x j = (matrix28 x j : ENNReal) := by
  have hs := vpm_apply_survivor source source_singular 1 2 (by decide)
    first_values first_disjoint x
  change first.channel x (1 : Fin 4) = source.channel x 1 + source.channel x 2 at hs
  have hi : activeMergeSurvivor source 1 2 (by decide) = (1 : Fin 4) :=
    Fin.ext (activeMergeSurvivor_val source 1 2 (by decide))
  have hk (k : Fin 4) (hk : k ≠ 1) :
      first.channel x k = source.channel x (activeMergeRetained source 2 k) :=
    vpm_apply_unaffected source source_singular 1 2 (by decide)
      first_values first_disjoint x (j := k) (by rwa [hi])
  fin_cases j
  · refine (hk 0 (by decide)).trans ?_
    change source.channel x 0 = _
    fin_cases x <;> rfl
  · refine hs.trans ?_
    fin_cases x <;> norm_num [source_coordinates, matrix25, matrix28]
  · refine (hk 2 (by decide)).trans ?_
    change source.channel x 3 = _
    fin_cases x <;> rfl
  · refine (hk 3 (by decide)).trans ?_
    change source.channel x 4 = _
    fin_cases x <;> rfl

example (x : Fin 3) (j : Fin 4) :
    first.channel x j = (((1 / 3 : NNReal) * columns29 j x : NNReal) : ENNReal) := by
  rw [first_coordinates]
  fin_cases x <;> fin_cases j <;> norm_num [matrix28, columns29]

private theorem second_patterns (x : Fin 3) :
    first.channel x (1 : Fin 4) ≠ 0 ↔ first.channel x (3 : Fin 4) ≠ 0 := by
  rw [first_coordinates, first_coordinates]
  fin_cases x <;> rfl

private abbrev second := ppm first firstEdge.isSingular (1 : Fin 4) (3 : Fin 4) (by decide)
  second_patterns

private def secondEdge : OperationStep first second :=
  .ppm first firstEdge.isSingular (1 : Fin 4) (3 : Fin 4) (by decide) second_patterns

-- Actual lower-survivor order, before the displayed transposition in (30).
private def matrix30Actual : Matrix (Fin 3) (Fin 3) NNReal :=
  ![![1 / 3, 2 / 3, 0], ![1 / 3, 2 / 3, 0], ![0, 2 / 3, 1 / 3]]

private theorem second_coordinates (x : Fin 3) (j : Fin 3) :
    second.channel x j = (matrix30Actual x j : ENNReal) := by
  have hs := ppm_apply_survivor first firstEdge.isSingular (1 : Fin 4) (3 : Fin 4) (by decide)
    second_patterns x
  change second.channel x (1 : Fin 3) =
    first.channel x (1 : Fin 4) + first.channel x (3 : Fin 4) at hs
  have hi : activeMergeSurvivor first (1 : Fin 4) (3 : Fin 4) (by decide) =
      (1 : Fin 3) := Fin.ext (activeMergeSurvivor_val first _ _ _)
  have hk (k : Fin 3) (hk : k ≠ 1) :
      second.channel x k = first.channel x (activeMergeRetained first (3 : Fin 4) k) :=
    ppm_apply_unaffected first firstEdge.isSingular (1 : Fin 4) (3 : Fin 4) (by decide)
      second_patterns x (j := k) (by rwa [hi])
  fin_cases j
  · refine (hk 0 (by decide)).trans ?_
    change first.channel x (0 : Fin 4) = _
    rw [first_coordinates]
    fin_cases x <;> rfl
  · refine hs.trans ?_
    rw [first_coordinates, first_coordinates, ← ENNReal.coe_add]
    congr 1
    fin_cases x <;> norm_num [matrix28, matrix30Actual]
  · refine (hk 2 (by decide)).trans ?_
    change first.channel x (2 : Fin 4) = _
    rw [first_coordinates]
    fin_cases x <;> rfl

-- The printed order in (30), also the left side of (31).
private def matrix30 : Matrix (Fin 3) (Fin 3) NNReal :=
  ![![1 / 3, 0, 2 / 3], ![1 / 3, 0, 2 / 3], ![0, 1 / 3, 2 / 3]]

private theorem matrix30_sum (x : Fin 3) : ∑ j, matrix30 x j = 1 := by
  fin_cases x <;> norm_num [matrix30, Fin.sum_univ_succ]

private abbrev printed30 : ActiveFiniteChannel (Fin 3) where
  outputCard := 3
  outputCard_pos := by decide
  channel := fun x => PMF.ofFintype (fun j => (matrix30 x j : ENNReal))
    (by exact_mod_cast matrix30_sum x)
  output_active := by
    intro j
    fin_cases j
    · exact ⟨0, by change (matrix30 0 0 : ENNReal) ≠ 0; norm_num [matrix30]⟩
    · exact ⟨2, by change (matrix30 2 1 : ENNReal) ≠ 0; norm_num [matrix30]⟩
    · exact ⟨0, by change (matrix30 0 2 : ENNReal) ≠ 0; norm_num [matrix30]⟩

private theorem display30_coordinates (x j : Fin 3) :
    (matrix30 x (Equiv.swap (1 : Fin 3) 2 j) : ENNReal) =
      (matrix30Actual x j : ENNReal) := by
  fin_cases x <;> fin_cases j <;>
    norm_num [matrix30, matrix30Actual, Equiv.swap_apply_def,
      Fin.ext_iff, -Fin.val_eq_zero_iff]

private def display30Equiv : OutputEquiv second printed30 :=
  OutputEquiv.ofCoordinates (Equiv.swap (1 : Fin 3) (2 : Fin 3))
    (fun x j => (display30_coordinates x j).trans (second_coordinates x j).symm)

-- The directed PMF equation retains the exact transposition, not just existence.
example (x : Fin 3) :
    (second.channel x).map (Equiv.swap (1 : Fin 3) 2) = printed30.channel x :=
  display30Equiv.map_eq x

example : display30Equiv.equiv (0 : Fin 3) = 0 ∧
    display30Equiv.equiv (1 : Fin 3) = 2 ∧ display30Equiv.equiv (2 : Fin 3) = 1 := by
  change Equiv.swap (1 : Fin 3) 2 0 = 0 ∧ Equiv.swap (1 : Fin 3) 2 1 = 2 ∧
    Equiv.swap (1 : Fin 3) 2 2 = 1
  decide

private theorem third_values :
    columnValue second.channel secondEdge.isSingular (second.activeEquiv (0 : Fin 3)) =
      columnValue second.channel secondEdge.isSingular (second.activeEquiv (2 : Fin 3)) := by
  have h0 : second.channel (0 : Fin 3) (0 : Fin 3) ≠ 0 := by
    rw [second_coordinates]
    norm_num [matrix30Actual]
  have h2 : second.channel (2 : Fin 3) (2 : Fin 3) ≠ 0 := by
    rw [second_coordinates]
    norm_num [matrix30Actual]
  rw [columnValue_eq_of_ne_zero _ _ _ h0, columnValue_eq_of_ne_zero _ _ _ h2]
  exact (second_coordinates 0 0).trans (second_coordinates 2 2).symm

private theorem third_disjoint (x : Fin 3)
    (hx : second.channel x (0 : Fin 3) ≠ 0) : second.channel x (2 : Fin 3) = 0 := by
  rw [second_coordinates] at hx ⊢
  fin_cases x <;> norm_num [matrix30Actual] at *

-- In the actual order the two complementary columns are 0 and 2.
private abbrev third := vpm second secondEdge.isSingular (0 : Fin 3) (2 : Fin 3) (by decide)
  third_values third_disjoint

private def thirdEdge : OperationStep second third :=
  .vpm second secondEdge.isSingular (0 : Fin 3) (2 : Fin 3) (by decide)
    third_values third_disjoint

-- The right side of (31), repeated on the left of (32).
private def matrix31 : Matrix (Fin 3) (Fin 2) NNReal :=
  ![![1 / 3, 2 / 3], ![1 / 3, 2 / 3], ![1 / 3, 2 / 3]]

private theorem third_coordinates (x : Fin 3) (j : Fin 2) :
    third.channel x j = (matrix31 x j : ENNReal) := by
  have hs := vpm_apply_survivor second secondEdge.isSingular (0 : Fin 3) (2 : Fin 3) (by decide)
    third_values third_disjoint x
  change third.channel x (0 : Fin 2) =
    second.channel x (0 : Fin 3) + second.channel x (2 : Fin 3) at hs
  have hi : activeMergeSurvivor second (0 : Fin 3) (2 : Fin 3) (by decide) =
      (0 : Fin 2) := Fin.ext (activeMergeSurvivor_val second _ _ _)
  have hk := vpm_apply_unaffected second secondEdge.isSingular
    (0 : Fin 3) (2 : Fin 3) (by decide)
    third_values third_disjoint x (j := (1 : Fin 2))
      (by rw [hi]; change (1 : Fin 2) ≠ 0; decide)
  change third.channel x (1 : Fin 2) = second.channel x (1 : Fin 3) at hk
  fin_cases j
  · refine hs.trans ?_
    rw [second_coordinates, second_coordinates, ← ENNReal.coe_add]
    congr 1
    fin_cases x <;> norm_num [matrix30Actual, matrix31]
  · refine hk.trans ?_
    rw [second_coordinates]
    fin_cases x <;> rfl

private theorem fourth_patterns (x : Fin 3) :
    third.channel x (0 : Fin 2) ≠ 0 ↔ third.channel x (1 : Fin 2) ≠ 0 := by
  rw [third_coordinates, third_coordinates]
  fin_cases x <;> norm_num [matrix31]

private abbrev fourth := ppm third thirdEdge.isSingular (0 : Fin 2) (1 : Fin 2) (by decide)
  fourth_patterns

private def fourthEdge : OperationStep third fourth :=
  .ppm third thirdEdge.isSingular (0 : Fin 2) (1 : Fin 2) (by decide) fourth_patterns

private def matrix32 : Matrix (Fin 3) (Fin 1) NNReal := ![![1], ![1], ![1]]

private theorem fourth_coordinates (x : Fin 3) (j : Fin 1) :
    fourth.channel x j = (matrix32 x j : ENNReal) := by
  have hs := ppm_apply_survivor third thirdEdge.isSingular (0 : Fin 2) (1 : Fin 2) (by decide)
    fourth_patterns x
  change fourth.channel x (0 : Fin 1) =
    third.channel x (0 : Fin 2) + third.channel x (1 : Fin 2) at hs
  fin_cases j
  refine hs.trans ?_
  rw [third_coordinates, third_coordinates, ← ENNReal.coe_add]
  congr 1
  fin_cases x <;> norm_num [matrix31, matrix32]

private def reductionPath : OperationPath source fourth :=
  OperationPath.nil.snoc firstEdge |>.snoc secondEdge |>.snoc thirdEdge |>.snoc fourthEdge

private def finalEquiv : OutputEquiv fourth (allOnes (Fin 3)) :=
  OutputEquiv.ofCoordinates (Equiv.refl (Fin 1)) (by
    intro x j
    exact (allOnes_apply (Fin 3) x j).trans
      ((fourth_coordinates x j).trans (by fin_cases x <;> fin_cases j <;> rfl)).symm)

private def reduction : Cascade source (allOnes (Fin 3)) :=
  ⟨fourth, reductionPath, finalEquiv⟩

private theorem reduction_tags : reduction.path.tags = [.vpm, .ppm, .vpm, .ppm] := rfl

example : reduction.path.length = 4 := rfl

private theorem reduction_reducing : reduction.path.Reducing := by
  intro k hk
  rw [reduction_tags] at hk
  simp only [List.mem_cons, List.not_mem_nil, or_false] at hk
  rcases hk with rfl | rfl | rfl | rfl <;> simp

private def reconstruction : Cascade (allOnes (Fin 3)) source := reduction.reverse

-- The inverse is an actual recovered path, including its directed final labels.
example : reconstruction.path.tags = [.pps, .vps, .pps, .vps] := by
  rw [reconstruction, Cascade.tags_reverse, reduction_tags]
  rfl

example : reconstruction.path.length = 4 := by
  rw [reconstruction, Cascade.length_reverse]
  rfl

private theorem reconstruction_normalizing : reconstruction.path.Normalizing :=
  reduction.reverse_normalizing.mpr reduction_reducing

example : ToAllOnes source := ⟨reduction, reduction_reducing⟩

private theorem source_fromAllOnes : FromAllOnes source :=
  ⟨reconstruction, reconstruction_normalizing⟩

-- This conclusion has no input law or full-support premise.
example : IsPerfectlyRepresentableChannel source.channel :=
  source_fromAllOnes.isPerfectlyRepresentable

end
end PerfectFunctionalRepresentations.MatrixOperations
