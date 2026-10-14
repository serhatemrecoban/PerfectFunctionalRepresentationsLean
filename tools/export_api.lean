/-
PFR-only API export from Lean's elaborated environment. Tooling, not a mathematical module.
The source inventory and C16 audit establish the selected module/public boundary.
-/
import Lean
import PerfectFunctionalRepresentations
import PerfectFunctionalRepresentations.Examples.Nonrepresentable3x3
import PerfectFunctionalRepresentations.Matrix.CanonicalReachability
import PerfectFunctionalRepresentations.Matrix.Channel
import PerfectFunctionalRepresentations.Matrix.MultiwayOperations
import PerfectFunctionalRepresentations.Matrix.OperationCalculus
import PerfectFunctionalRepresentations.Matrix.OperationFactorization
import PerfectFunctionalRepresentations.Matrix.OperationIndices
import PerfectFunctionalRepresentations.Matrix.OperationPaths
import PerfectFunctionalRepresentations.Matrix.Operations
import PerfectFunctionalRepresentations.Matrix.Partitions
import PerfectFunctionalRepresentations.Matrix.PatternCompression
import PerfectFunctionalRepresentations.Matrix.Preservation
import PerfectFunctionalRepresentations.Matrix.Reachability
import PerfectFunctionalRepresentations.Matrix.SingularColumns
import PerfectFunctionalRepresentations.Optimization.Dual
import PerfectFunctionalRepresentations.Optimization.DualCharacterization
import PerfectFunctionalRepresentations.Optimization.Incidence
import PerfectFunctionalRepresentations.Optimization.IncidenceConstruction
import PerfectFunctionalRepresentations.Optimization.Primal
import PerfectFunctionalRepresentations.Probability.FiniteCouplingDecoding

set_option maxHeartbeats 0
set_option pp.universes true
set_option pp.fullNames true
set_option pp.maxSteps 1000000
set_option pp.deepTerms true
set_option pp.proofs true

open Lean Elab Command in
run_cmd do
  let env ← getEnv
  for target in env.header.moduleNames do
    let owner := target.toString
    if owner == "PerfectFunctionalRepresentations" ||
        owner.startsWith "PerfectFunctionalRepresentations." then
      if owner.startsWith "PerfectFunctionalRepresentations.Tests." then
        throwError "Test module entered API import closure: {target}"
      let some idx := env.header.moduleNames.findIdx? (· == target)
        | throwError "Module not found: {target}"
      let data := env.header.moduleData[idx]!
      liftIO <| IO.println s!"PFR_API_MODULE {(toJson owner).compress}"
      for i in *...data.constNames.size do
        let name := data.constNames[i]!
        let info := data.constants[i]!
        if isPrivateName name || name.isInternalDetail || name.hasMacroScopes then
          continue
        if ← liftTermElabM (isAutoDeclOrPrivate_Internal name) then
          continue
        if let .recInfo _ := info then
          continue
        let some ranges ← findDeclarationRanges? name
          | do
            liftIO <| IO.println s!"PFR_API_NO_RANGE {(toJson name.toString).compress}"
            continue
        let signature ← liftTermElabM do
          return (← Meta.ppExpr info.type).pretty 110
        let doc ← liftIO <| findDocString? env name
        let kind := if env.isProjectionFn name then "projection" else match info with
          | .defnInfo d => if d.hints.isAbbrev then "abbrev" else "def"
          | .thmInfo _ => "theorem"
          | .inductInfo _ => if isStructure env name then "structure" else "inductive"
          | .ctorInfo _ => "constructor"
          | .recInfo _ => "recursor"
          | .axiomInfo _ => "axiom"
          | .opaqueInfo _ => "opaque"
          | .quotInfo _ => "quotient"
        let row := Json.mkObj [
          ("module", toJson owner), ("name", toJson name.toString),
          ("kind", toJson kind), ("type", toJson signature),
          ("universes", toJson (info.levelParams.map Name.toString)),
          ("documentation", toJson (doc.getD "")),
          ("line", toJson ranges.selectionRange.pos.line),
          ("end_line", toJson ranges.range.endPos.line)]
        liftIO <| IO.println s!"PFR_API_DECL {row.compress}"
