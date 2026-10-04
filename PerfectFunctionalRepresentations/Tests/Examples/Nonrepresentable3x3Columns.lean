import PerfectFunctionalRepresentations.Examples.Nonrepresentable3x3
import PerfectFunctionalRepresentations.Matrix.SingularColumns

/-!
# Definition 4 on the existing Example 1 channel

C06 R15: ISIT Section III-A, Definition 4 and its Example 1 sentence;
extended version 16 (2026-09-03), Section III-A, page 3 in both manuscripts.
Input indexes the varying row and output 0 is the fixed first column.
The direct active-state wrapper preserves all three original output labels.
This separately imported fixture adds no public API or new semantic channel.
-/

namespace PerfectFunctionalRepresentations.Tests.Nonrepresentable3x3Columns

open scoped ENNReal

noncomputable section
attribute [local instance] Classical.propDecidable

private theorem allActive (y : Fin 3) : ∃ x, nonrepresentable3x3 x y ≠ 0 := by
  fin_cases y
  · exact ⟨0, by norm_num [nonrepresentable3x3_apply]⟩
  · exact ⟨0, by norm_num [nonrepresentable3x3_apply]⟩
  · exact ⟨1, by norm_num [nonrepresentable3x3_apply]⟩

private def firstColumn : activeOutputs nonrepresentable3x3 :=
  ⟨0, by
    obtain ⟨x, hx⟩ := allActive 0
    exact ⟨x, hx⟩⟩

private theorem firstValue :
    columnValue nonrepresentable3x3 nonrepresentable3x3_isSingular firstColumn = 1 / 2 := by
  rw [columnValue_eq_of_ne_zero _ _ _
    (show nonrepresentable3x3 0 firstColumn.val ≠ 0 by
      norm_num [firstColumn, nonrepresentable3x3_apply])]
  norm_num [firstColumn, nonrepresentable3x3_apply]

private theorem firstRealValue :
    (columnValue nonrepresentable3x3 nonrepresentable3x3_isSingular firstColumn).toReal =
      (1 : ℝ) / 2 := by
  rw [firstValue]
  norm_num [ENNReal.toReal_div]

private theorem firstPattern :
    (columnPattern nonrepresentable3x3 firstColumn).val = ({0, 1} : Finset (Fin 3)) := by
  ext x
  rw [mem_columnPattern]
  fin_cases x <;> norm_num [firstColumn, nonrepresentable3x3_apply]

private theorem firstMasses : (fun x => massMatrix nonrepresentable3x3 x 0) =
    ![(1 : ℝ≥0∞) / 2, 1 / 2, 0] := by
  funext x
  fin_cases x <;> norm_num [massMatrix, nonrepresentable3x3_apply]

private theorem firstRealMasses : (fun x => realMatrix nonrepresentable3x3 x 0) =
    ![(1 : ℝ) / 2, 1 / 2, 0] := by
  funext x
  fin_cases x <;> norm_num [realMatrix, nonrepresentable3x3_apply, ENNReal.toReal_div]

private theorem firstBool :
    (fun x => decide (x ∈ (columnPattern nonrepresentable3x3 firstColumn).val)) =
      ![true, true, false] := by
  funext x
  rw [firstPattern]
  fin_cases x <;> norm_num

private theorem firstIndicator :
    (fun x => if x ∈ (columnPattern nonrepresentable3x3 firstColumn).val then (1 : ℝ) else 0) =
      ![1, 1, 0] := by
  funext x
  rw [firstPattern]
  fin_cases x <;> norm_num

private theorem firstDivided :
    (fun x => realMatrix nonrepresentable3x3 x 0 /
      (columnValue nonrepresentable3x3 nonrepresentable3x3_isSingular firstColumn).toReal) =
      ![1, 1, 0] := by
  funext x
  have h := column_div_value nonrepresentable3x3 nonrepresentable3x3_isSingular firstColumn x
  rw [firstPattern] at h
  fin_cases x <;> simpa [firstColumn] using h

-- Raw channel: literal first-column data, with no new probability construction.
example : firstColumn.val = (0 : Fin 3) := rfl

example : (fun x => massMatrix nonrepresentable3x3 x 0) =
    ![(1 : ℝ≥0∞) / 2, 1 / 2, 0] := firstMasses

example : (fun x => realMatrix nonrepresentable3x3 x 0) =
    ![(1 : ℝ) / 2, 1 / 2, 0] := firstRealMasses

example : columnValue nonrepresentable3x3 nonrepresentable3x3_isSingular firstColumn =
    (1 : ℝ≥0∞) / 2 := firstValue

example : (columnValue nonrepresentable3x3 nonrepresentable3x3_isSingular firstColumn).toReal =
    (1 : ℝ) / 2 := firstRealValue

example : (columnPattern nonrepresentable3x3 firstColumn).val =
    ({0, 1} : Finset (Fin 3)) := firstPattern

example : (fun x => decide (x ∈ (columnPattern nonrepresentable3x3 firstColumn).val)) =
    ![true, true, false] := firstBool

example : (fun x => if x ∈ (columnPattern nonrepresentable3x3 firstColumn).val
    then (1 : ℝ) else 0) = ![1, 1, 0] := firstIndicator

example : (fun x => realMatrix nonrepresentable3x3 x 0 /
    (columnValue nonrepresentable3x3 nonrepresentable3x3_isSingular firstColumn).toReal) =
    ![1, 1, 0] := firstDivided

-- A transparent private wrapper lets numerals retain their original Fin 3 type.
-- Its channel is the existing channel itself; no arbitrary enumeration is used.
private abbrev fixtureState : ActiveFiniteChannel (Fin 3) where
  outputCard := 3
  outputCard_pos := by decide
  channel := nonrepresentable3x3
  output_active := allActive

example : fixtureState.outputCard = 3 ∧ fixtureState.channel = nonrepresentable3x3 := ⟨rfl, rfl⟩

example : (fixtureState.activeEquiv 0).val = (0 : Fin 3) := rfl

example : (fun x => massMatrix fixtureState.channel x 0) =
    ![(1 : ℝ≥0∞) / 2, 1 / 2, 0] := firstMasses

example : (fun x => realMatrix fixtureState.channel x 0) =
    ![(1 : ℝ) / 2, 1 / 2, 0] := firstRealMasses

example : columnValue fixtureState.channel nonrepresentable3x3_isSingular
    (fixtureState.activeEquiv 0) = (1 : ℝ≥0∞) / 2 := firstValue

example : (columnValue fixtureState.channel nonrepresentable3x3_isSingular
    (fixtureState.activeEquiv 0)).toReal = (1 : ℝ) / 2 := firstRealValue

example : (columnPattern fixtureState.channel (fixtureState.activeEquiv 0)).val =
    ({0, 1} : Finset (Fin 3)) := firstPattern

example : (fun x => decide (x ∈ (columnPattern fixtureState.channel
    (fixtureState.activeEquiv 0)).val)) = ![true, true, false] := firstBool

example : (fun x => if x ∈ (columnPattern fixtureState.channel
    (fixtureState.activeEquiv 0)).val then (1 : ℝ) else 0) = ![1, 1, 0] := firstIndicator

example : (fun x => realMatrix fixtureState.channel x 0 /
    (columnValue fixtureState.channel nonrepresentable3x3_isSingular
      (fixtureState.activeEquiv 0)).toReal) = ![1, 1, 0] := firstDivided

end
end PerfectFunctionalRepresentations.Tests.Nonrepresentable3x3Columns
