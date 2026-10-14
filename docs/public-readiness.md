# Public readiness and website direction

**Review date: 2026-10-14.** PFR is a public, completed case study of
**LeanInfoTheory v0.1.0**. Public source availability is not a claim to have
formalized the whole extended manuscript, redistributed the paper, or issued a
tagged software release. The current readiness work adds reproducible build
checks and clear attribution; it does not change the mathematics or dependency
baseline.

## Public content

The review of published `master` at
`ceef8793673697cce0a4a1862d30ab0d77fb6dd5` covered all nine reachable commits,
169 historical paths and 212 unique blobs. No manuscripts, annotated PDFs,
binary attachments, private runtime stores or common credential/private-key
patterns were found. The seven local PDF outputs remain ignored and unpublished.
Pattern checks do not prove the absence of every possible secret.

Historical project notes contain local paths and task identifiers; Git metadata
contains an institutional author email. These are existing provenance records,
not detected credentials. The saved reviewer report in the tooling tests is an
explicitly labeled toy fixture. Original reviews, omission records and history
are preserved, not silently rewritten or presented as public research results.
Reader-facing documentation uses portable repository links.

GitHub reported **zero historical Actions workflows, runs and artifacts**, so
there were no old Actions logs to inspect. There were also no issues, pull
requests, releases or repository comments. This is an inventory result, not a CI
pass. [GitHub's visibility guidance](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/managing-repository-settings/setting-repository-visibility)
explicitly includes Actions history and logs in public visibility.

Secret scanning and push protection were enabled and confirmed on 2026-10-14.
The initial alert query returned no alerts; this does not certify completion or
exhaustiveness of GitHub's asynchronous scanning. No paid security feature,
history rewrite, tag, website deployment or manuscript upload was requested.

## Attribution and permission boundaries

[AUTHORS.md](../AUTHORS.md) separates the mathematical paper's three authors
from the Lean formalization's author, Serhat Emre Coban, as confirmed by the lead.
[CITATION.cff](../CITATION.cff) supplies software citation metadata. The software
remains Apache-2.0; the paper and dependencies retain their separate rights and
licenses.

The lead's authorization to publish this repository is recorded. No separate
coauthor or institutional permission is asserted on their behalf. Unverified
copyright-holder wording, affiliation, DOI, publication date and formal paper
citation remain absent. An approved public paper link and complete bibliographic
record are still needed before adding a paper-download or official-citation
button. Paper redistribution is not part of the present publication.

## Reproducibility

The checked-in build gate enumerates the mathematical root and every tracked
Lean source below `PerfectFunctionalRepresentations/`, including `Basic`, tests
and examples. There are currently **56 modules**. It checks the release pins,
forbidden placeholder tokens and accidental private-file tracking, builds all
modules and the default target, then verifies installed dependency revisions and
unchanged configuration. These checks are narrower than the historical C16
mathematical and axiom audits; they do not replace them.

```text
python -B tools/test_public_build.py
python -B tools/check_public_build.py static
lake exe cache get --cache-from=master,legacy
python -B tools/check_public_build.py build
```

Python 3.11 or newer, Git and Lean's `elan` toolchain manager are required. The
committed `lean-toolchain` selects Lean `v4.33.1`. Do **not** run `lake update`
as part of reproducing this checkpoint. `lake-manifest.json` locks the dependency
commits, including LeanInfoTheory `v0.1.0` at
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f` and mathlib at
`0df444a360eaa60ab8c11dca51a86af692955474`.

The [public workflow](../.github/workflows/lean.yml) uses a fresh hosted runner,
SHA-pinned actions, read-only repository permissions and no persisted checkout
credentials or GitHub `.lake` cache. Only public mathlib release build artifacts
are downloaded; PFR is compiled from source. Public artifacts accelerate the
dependency build: this is not a claim to rebuild all of mathlib from source.
The workflow runs no models or live reviewers and does not publish build outputs.

**Completed hosted validation:** [public CI run 38573351527](https://github.com/serhatemrecoban/PerfectFunctionalRepresentationsLean/actions/runs/38573351527)
passed on `d06a1187611790134bc94ea8aa06232b4f020baa`, using Ubuntu 24.04 and
fresh PFR compilation. Its eleven gate tests, all-module build (2,823 jobs),
default build (2,762 jobs), ten installed dependency identities/cleanliness and
clean-checkout checks passed. The public logs were inspected: no private material
or common secret patterns were detected, and no build artifacts were uploaded.

The [initial successful run](https://github.com/serhatemrecoban/PerfectFunctionalRepresentationsLean/actions/runs/38570736438)
on `626f4a4` reported a non-blocking Node 20 deprecation annotation for checkout
v4. The final workflow pins the official Node-24 checkout v7.0.1 source; the
successful final run has no warning annotations. This is a CI action change,
not a Lean, mathlib or LeanInfoTheory upgrade. Subsequent evidence-only
documentation changes leave the tested sources, build gate and workflow unchanged.

**Completed independent Windows checkout:** an anonymous HTTPS clone of
`ceef8793673697cce0a4a1862d30ab0d77fb6dd5` fetched all ten locked package
repositories and 8,690 public cache files without copying the primary checkout's
PFR or LeanInfoTheory artifacts. All 56 modules and the default build passed
(2,823 and 2,762 jobs), the placeholder scan found no matches, and the checkout
and dependency configuration stayed clean. This used the already installed
Lean 4.33.1 toolchain, not a new Windows toolchain installation. A subsequent
anonymous fast-forward to `626f4a4` confirmed no Lean/configuration change.
The published gate then passed all eleven tests, both builds and all ten
dependency checks in that clone; this second execution reused its freshly built
artifacts and is explicitly a cached rerun.

## Exact coverage to advertise

The primary target is the **six-page ISIT manuscript**, SHA-256
`48963aa59485b2c33b1a1e6e7c6ead2251fdddd26bd3691b6fcffe683e6ed1c4`.
The completed C01–C16 proof/clarification baseline is the **eighteen-page extended
version 16**, SHA-256
`98636d4c9f0618ec08fca84559572780f604f197fda90d8d7c787b3624245b8f`.
These identities specify the local manuscript artifacts without distributing them.

The newer eighteen-page companion `(19) (2)`, supplied on 2026-10-13, has SHA-256
`59a7ccd1e881b0a8f4bee657727ce92a561108ca0ddb6b8f2aeb60e1d56dbc16`.
Only the recorded selected Appendix A/B proof passages and associated LP
clarification were compared. **There is no claim of complete coverage or
revalidation of that newer draft.** The [source ledger](pfr-c16-coverage-audit.md)
and [current manuscript notes](perfect-functional-representations-living-summary.md#10-reference-and-provenance-boundary)
retain the precise boundaries and version history.

The agreed scope covers Definitions 1–4, Lemmas 1–6, Theorems 1–2, Corollary 1,
the non-representable example and selected supporting statements. Coverage may
be a public theorem, a proof-internal fact or a checked fixture; it is not one
public Lean declaration per printed display.

| Mathematical content | Source route |
| --- | --- |
| Functional representations and equality conditions | [Semantic definitions and bounds](../PerfectFunctionalRepresentations/Semantics/FunctionalRepresentation.lean) |
| Canonical representations and perfect channels | [Canonical construction](../PerfectFunctionalRepresentations/Semantics/Canonical.lean) |
| Singularity and binary cases | [Singularity](../PerfectFunctionalRepresentations/Semantics/Singularity.lean), [binary results](../PerfectFunctionalRepresentations/Semantics/Binary.lean) |
| Finite total variation and attaining coupling | [Finite coupling](../PerfectFunctionalRepresentations/Probability/FiniteCoupling.lean) |
| Matrix operations and constructive normalization | [Operation calculus](../PerfectFunctionalRepresentations/Matrix/OperationCalculus.lean), [factorization proof](../PerfectFunctionalRepresentations/Matrix/OperationFactorization.lean) |
| Constructive perfect-representability characterization | [Canonical reachability](../PerfectFunctionalRepresentations/Matrix/CanonicalReachability.lean) |
| Primal and dual LP characterizations | [Primal](../PerfectFunctionalRepresentations/Optimization/Primal.lean), [dual characterization](../PerfectFunctionalRepresentations/Optimization/DualCharacterization.lean) |

Important qualifications must remain visible beside headline results:

- Information quantities use finite value alphabets and nats. The
  information-preserving canonicalization and binary bound cover finite-valued
  auxiliaries; the paper's unrestricted-auxiliary reading is not fully covered.
- Support-only decoders, total null-fiber conventions and full-support converse
  assumptions are explicit. Channel-only claims must not acquire a hidden prior.
- The ambient-channel LP characterizations assume singularity, finite alphabets
  and nonempty input. The LP results use corrected full/reduced incidence indexing,
  consistent with the extended formulation, rather than the literal mixed ISIT
  indexing. They prove mathematical characterizations, not an executable LP
  solver or runtime claim.
- Lemma 4's normalization theorem is proved using finite path/certificate
  induction. The informal repeated-rewrite termination argument is not asserted
  to have been verified.
- Cited channel-simulation results and extended-only complexity, hypergraph and
  broader information-measure developments are excluded. The exhaustive
  [omission register](formalization-map.md#9-internal-exhaustive-omission-and-disposition-register)
  preserves the reasons.

## Website direction for later implementation

A compact research-project site is appropriate. It should complement
LeanInfoTheory's library documentation with this paper's results and their exact
formal contracts. Website implementation and deployment wait for a later request.

Suggested sections:

1. **Overview:** the research problem, all paper authors, the formalization
   author, repository link and the immutable LeanInfoTheory `v0.1.0` baseline.
2. **Main results:** a small paper-to-Lean table with theorem names and links
   pinned to the published source commit; place essential assumptions next to
   each result.
3. **Scope and limitations:** the exact ISIT/extended versions, finite-auxiliary
   restriction, corrected LP indexing and intentional exclusions.
4. **What formal verification clarified:** the Lemma 4 normalization proof as
   a concrete example of improved proof precision, without reproducing the
   manuscript or claiming the theorem was false.
5. **Reproduce and cite:** tested installation commands, public CI, software
   citation, an approved paper citation/link when available, and dependency
   attribution.

Use a small static site with accessible text, mobile-readable tables and minimal
JavaScript. GitHub Pages is a natural hosting option for this repository, but no
host or deployment is selected in this pass. Avoid a second library API portal,
private proof annotations, unapproved manuscript downloads, and unmeasured
code/time-saving claims. The measured reuse inventory can be a supporting link,
not the main claim of mathematical value.

A later LeanInfoTheory release may celebrate this completed downstream case
study. That announcement should explicitly say **built against v0.1.0**; neither
publication nor that acknowledgement requires upgrading PFR. Upgrading remains
a separate, explicitly authorized and validated task.
