import PerfectFunctionalRepresentations.Basic
import PerfectFunctionalRepresentations.Semantics.FunctionalRepresentation
import PerfectFunctionalRepresentations.Semantics.Canonical
import PerfectFunctionalRepresentations.Semantics.Singularity
import PerfectFunctionalRepresentations.Probability.FiniteCoupling
import PerfectFunctionalRepresentations.Semantics.Binary

/-!
# Perfect Functional Representations

Root import for the formalization of *On Perfect Functional Representations*.
Exposes the support-aware semantic API, Equations (1)-(3), canonical
representations and finite perfect-witness reduction, and the intrinsic channel
property with its support-qualified prior bridges. The semantic C03 API adds
singularity, finite relabeling and unused-output invariance, exact active-output
restriction, and the characterization for at most two active outputs.
The probability API adds finite total variation, universal coupling bounds,
an explicit maximal coupling with exact atoms and support, and injective relabeling.
The binary semantic API completes Lemma 2 and exposes the conditional-entropy
identity, finite-auxiliary information bound and attaining representation of
Lemma 3, with arbitrary priors and an explicitly full-support equality converse.
Its quantitative interfaces transport to any input alphabet of cardinality two.
The decoding-error bridge, regressions, counterexamples, matrix and optimization
modules remain separately imported.
-/
