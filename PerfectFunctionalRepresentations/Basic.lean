import LeanInfoTheory.Shannon.Entropy

/-!
# Project bootstrap

This module verifies that the project compiles against the pinned
LeanInfoTheory release. Paper-specific definitions will be added only after the
formalization plan is approved.
-/

namespace PerfectFunctionalRepresentations

section DependencySmokeTest

variable {alpha : Type} [Fintype alpha]

example (p : PMF alpha) : 0 <= LeanInfoTheory.Shannon.entropy p :=
  LeanInfoTheory.Shannon.entropy_nonneg p

end DependencySmokeTest

end PerfectFunctionalRepresentations
