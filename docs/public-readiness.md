# Public readiness and research website

**Review date: 2026-10-14.** PFR is a public, completed case study of
**LeanInfoTheory v0.1.0**. Public source availability is not a claim to have
formalized the whole extended manuscript, redistributed the paper, or issued a
tagged software release. The readiness work adds reproducible build checks and clear attribution;
the subsequently authorized research website presents those verified results.
Neither changes the mathematics or dependency baseline.

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
history rewrite, tag, website deployment or manuscript upload was requested in
that initial readiness phase. The later website authorization and delivery are
recorded below.

## Attribution and permission boundaries

[AUTHORS.md](../AUTHORS.md) separates the mathematical paper's three authors
from the Lean formalization's author, Serhat Emre Coban, as confirmed by the lead.
[CITATION.cff](../CITATION.cff) supplies software citation metadata. The software
remains Apache-2.0; the paper and dependencies retain their separate rights and
licenses.

The lead's authorization to publish this repository is recorded. No separate
coauthor or institutional permission is asserted on their behalf. Unverified
copyright-holder wording and affiliation remain absent. The lead subsequently
specified ISIT 2026 and requested the public paper link. The title, authors,
conference year and [paper DOI](https://doi.org/10.1109/ISIT62367.2026.11653684)
are corroborated by the [author's academic homepage](https://serhatemrecoban.github.io/)
and [EPFL's publication record](https://www.epfl.ch/schools/ic/ipg/publications/).
The website links to that record; it does not host a paper copy or infer further
rights-holder or permission details. Paper redistribution is not authorized.

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

<a id="website-direction-for-later-implementation"></a>

## Website implementation and hosting

The lead authorized the website on 2026-10-14, including an explanatory
Discussion section, and requested a detailed plan with implementation when
practical. The [website plan](plans/pfr-website.md) records scope, design,
acceptance and maintenance. This supersedes the earlier suggestions-only phase.

The initial site had four pages: Overview, Results, Discussion, and Reproduce & cite.
Discussion covers finite auxiliaries and support, constructive normalization,
LP indexing, exact manuscript scope and measured library reuse. It is authored
explanatory content, not a comments service. Paper credits remain separate from
formalization credit. No manuscript is distributed and missing official paper
metadata is not invented.

Source lives in `site/`: buildless HTML, shared CSS, a small clipboard
enhancement and original SVG assets. There are no third-party assets, analytics,
cookies or frontend dependencies. Source links are pinned to
`da44e39a2ec2936d32195dd97df21c1bd19e63bc` and checked against exact Git lines by
`tools/check_website.py`; `tools/test_website.py` exercises the guard.
These are structural/publication checks, not exhaustive accessibility or
security certification.

GitHub Pages is configured for workflow hosting with HTTPS at
[the research-site URL](https://serhatemrecoban.github.io/PerfectFunctionalRepresentationsLean/).
[Website run 38580736326](https://github.com/serhatemrecoban/PerfectFunctionalRepresentationsLean/actions/runs/38580736326)
successfully validated and deployed commit
`18a4833b3397d4410e54e8fd0235ac4c53dc84b9`. All 21 guard tests passed on Ubuntu
(no skips). Live browser checks passed on all four pages at 1440, 768, 390 and
320 px, including keyboard entry, disclosures, clipboard success/fallback and
JavaScript-disabled navigation. Visual checks found no remaining layout issue.
All nine served files matched the committed bytes; `.nojekyll` is omitted by the
artifact action and is unnecessary for this direct static deployment. The [website workflow](../.github/workflows/site.yml)
validates the site before uploading only `site/`. PRs validate without
deployment; only the deployment job receives Pages/identity-token write
permissions. Actions are pinned to inspected official source SHAs. No private
runtime store, whole-repository upload or local snapshot ref is published.

For local maintenance:

```text
python -B tools/test_website.py
python -B tools/check_website.py
python -B -m http.server 8765 --bind 127.0.0.1 --directory site
```

Open the local server in a browser, inspect desktop and mobile layouts, test
keyboard navigation and copy fallback, and stop it when finished. Keep source
links and their manifest synchronized when changing the advertised snapshot.
The plan and [project-log entry](project-log.md#research-website) record actual
validation and deployment. Public workflow logs were reviewed; the archive
inventory contains only the nine intended site files, with no detected private
content or common credential patterns. Tokens were masked. The deploy action
emits a non-blocking upstream `punycode` deprecation message; deployment succeeds
and GitHub reports zero check annotations. No action version was changed merely
to suppress it. The repository homepage now points to the confirmed site URL.

The same delivery commit also passed the fresh
[all-module Lean CI run 38580736535](https://github.com/serhatemrecoban/PerfectFunctionalRepresentationsLean/actions/runs/38580736535):
all 56 modules (2,823 jobs), default target (2,762 jobs), eleven public-build gate
tests, all ten installed pins and clean checkout. No Lean source, dependency or
toolchain change was made. The closing evidence-only documentation commit leaves
all tested site, tools, workflows and mathematical sources unchanged.

### Blueprint, API and palette extension — 2026-10-14

The lead subsequently requested the conventional overview / mathematical
blueprint / generated API structure, with LeanInfoTheory's blue–green palette.
The original four pages remain, supplemented by `site/blueprint/index.html` and
a generated PFR-only reference under `site/api/`. The new blueprint contains
original explanations of Definitions 1–4, Lemmas 1–6, Theorems 1–2 and Corollary 1.
Its diagram is explicitly expository, not a compiler-extracted dependency graph.
Finite auxiliaries, support, active operations and corrected LP coordinates
remain qualified. No local paper text or files are distributed.

The API currently contains 992 entries over 27 modules. Lean's elaborated
environment supplies types, docstrings, owner modules and source ranges; the
compiler's source index independently checks authored-declaration inclusion.
The boundary includes public production declarations and the deliberate four-name
counterexample API, with constructors/projections, but excludes private proof
machinery, tests and private demonstration fixtures. It does not duplicate
dependency documentation or claim doc-gen4's linked-type/instance navigation.
All type output is escaped, and search filters an existing local DOM without
network requests. Source docstrings may contain historical development wording;
the site identifies them as source text, not new status claims.

`tools/generate_api.py` owns reproducible generation using the existing toolchain;
`--check` rebuilds the selected modules, verifies the installed dependency Git
revisions/clean tracked trees before and after export, and compares the complete
generated payload. `--check-render` checks source/configuration/tool hashes and
deterministic rendering without a compiler; it is explicitly not a replacement
for the full check. Both modes require the exact pinned mathematical snapshot.
The Pages workflow now waits for the compiler-backed check on the same commit
before deployment. An independent review identified and closed an earlier draft
gap in which only the faster static check gated deployment.

This avoids introducing doc-gen4 and its large generated dependency closure:
the pinned LeanInfoTheory documentation establishes a compatible isolated route,
but a focused PFR reference is sufficient here. The exporter is original tooling;
no external formalization implementation is copied. The root dependency manifest,
toolchain and mathematical Lean source remain unchanged.

Local extension checks passed: fourteen API fixture tests, 23 website fixture
tests (22 pass; one Windows symlink-privilege skip), default Lean build, public
static gate and eleven public-build tests. Browser checks cover eight representative
pages at 1440/768/390/320 px, keyboard entry, disclosures, clipboard success/fallback,
no-JavaScript reading and API search/zero-result/reset/deep-link behavior. Visual
inspection includes the overview, blueprint/diagram, API index and theorem pages.
The final source/render guard checks 33 pages and 4,715 links/assets, including
34 human source anchors and 31 direct blueprint-to-API links. Fresh generation
and a separate compiler-backed `--check` agree exactly (2,794 build jobs and all
ten installed pins verified).

**Hosted delivery and live verification.** Commit
`b4ca3387b76f6f6a71ee90b1951601bb5d4f4cfb` was pushed only to public `master`.
The [website run 38587761160](https://github.com/serhatemrecoban/PerfectFunctionalRepresentationsLean/actions/runs/38587761160)
passed all 23 website tests without skips on Ubuntu, fourteen API tests, the
33-page/4,715-reference guard and a fresh compiler-backed comparison of all 992
API entries, before deploying through GitHub Pages. The separate
[Lean run 38587760967](https://github.com/serhatemrecoban/PerfectFunctionalRepresentationsLean/actions/runs/38587760967)
passed eleven public-build tests, all 56 maintained modules (2,823 jobs), the
default target (2,762 jobs), all ten installed pins and clean-checkout checks.
The Linux symlink pass does not convert the recorded local Windows skip into a pass.

The downloaded Pages artifact has exactly 42 regular files with safe, unique
paths and no links; its inventory and every file byte match committed `site/`
content (excluding the intentionally omitted `.nojekyll`). All 42 live files
also returned HTTP 200 and matched those committed bytes. The 32 browser
page/viewport combinations and separate API-search/keyboard/no-JavaScript tests
were repeated successfully against the live site. The full logs of both runs
were inspected; a targeted private-path/credential-pattern scan found no
matches, not an exhaustive security guarantee. The official deployment action
still emits a nonblocking Node `punycode` deprecation warning. The final
documentation-only checkpoint leaves tested sources and deployed bytes unchanged.

For API maintenance, add these commands to the existing site checks:

```text
python -B tools/test_generate_api.py
python -B tools/generate_api.py --check
```

Run without `--check` only when intentionally regenerating the reference after
reviewing its source/tooling change. Unexpected output files are refused, not
silently removed. Changes to the public API source snapshot require an explicit
re-pin of the exporter and human-source-link manifest with revalidation.

### Academic layout correction — 2026-10-14

The lead rejected the earlier visual interpretation: navigation and palette
matched, but the custom editorial composition did not resemble the reference
sites. The correction uses the full-width centered masthead, bordered navigation
buttons, sans-serif typography and narrow document flow seen on
[LeanInfoTheory](https://serhatemrecoban.github.io/LeanInfoTheory/) and
[Fermat's Last Theorem](https://imperialcollegelondon.github.io/FLT/), keeping
LeanInfoTheory's blue–green palette. These are visual references, not copied
source or assets. No external theme, font, package or dependency is introduced.

The homepage uses plain sections/lists, with the diagram below the introduction.
Secondary pages and the generated API use the same masthead. Exact mathematical
contracts, source anchors, API inventory and publication guards are preserved.
Local validation passes: 23 website tests (22 pass, one Windows symlink-privilege
skip), fourteen API tests, the 33-page/4,753-reference website guard, source/render
freshness, the public static gate and default Lean build (2,762 jobs). The initial
layout revision's fresh compiler generation (2,794 jobs, all ten installed pins
checked before/after) preserved all 992 declaration records and mathematical
source hashes exactly. The final title/year/Paper-link refinements re-render the
same inventory with an unchanged exporter and validation code; a fresh
compiler-backed equality check remains mandatory before deployment.
No validation rule, workflow or compiler export logic was weakened.

Browser tests pass 28 explicit academic-layout checks and 32 representative
page/viewport combinations at 1440/768/390/320 px, plus API search/reset/no-match,
literal hostile query, keyboard deep links, disclosures, no-JavaScript reading
and clipboard success/fallback. The homepage title remains visible when printed.
Independent visual review confirms the reference-family resemblance on home,
secondary and generated API pages. Its one contrast finding was corrected with
a subtle dark overlay on the original gradient (minimum white-text contrast
4.85:1); the 832-pixel desktop text column and 52-pixel title match the reference
geometry. There are no outstanding design findings.

Final title/year/Paper-link delivery is commit
`d8ce9779e411f7fdf4687dec6e9f8c9fdf581e9b`:

- [Website run 38617895725](https://github.com/serhatemrecoban/PerfectFunctionalRepresentationsLean/actions/runs/38617895725)
  passed all 23 website and fourteen API tests on Ubuntu, the 33-page/4,753-link
  guard, fresh compiler-backed equality for 992 declarations, all ten installed
  dependency checks and checkout cleanliness, then deployed successfully.
- [All-module run 38617895825](https://github.com/serhatemrecoban/PerfectFunctionalRepresentationsLean/actions/runs/38617895825)
  passed the complete public Lean build gate and checkout checks.
- The deployment archive contains exactly the 42 intended regular site files;
  their contents and all 42 live responses match the committed bytes. Live
  browser checks repeat the 32 page/viewport combinations, 28 layout checks
  and API search, keyboard, no-JavaScript and clipboard controls successfully.
  Independent final local review confirms the title, year, adjacent GitHub/Paper
  buttons and all three editorial paper-title links at desktop and mobile widths.

The earlier `31d9c6d` site's Lean run was cancelled by GitHub concurrency when
superseded, not reported as a pass; both workflows passed at `9a4cc00` and again
at the final delivery above. The Windows symlink-privilege skip remains a local
qualification despite Ubuntu's passing test. Targeted public-log checks found
no private local paths or tested credential patterns; the official deployment
action's `punycode` deprecation warning did not prevent deployment. Final
documentation-only closeout leaves the tested website, tooling and pins unchanged.

A later LeanInfoTheory release may celebrate this completed downstream case
study. That announcement should explicitly say **built against v0.1.0**; neither
publication nor that acknowledgement requires upgrading PFR. Upgrading remains
a separate, explicitly authorized and validated task.

## Argument-map revision — 2026-10-14

The lead requested a fresh explanation of the paper's connections. The
[blueprint](../site/blueprint/index.html#dependency-guide) now separates a
binary optimization branch from the general structural argument and displays
perfectness, legal operations, partition weights and the primal/dual criteria
as equivalent views. Separate proof-route notes explain which ingredients
establish those bridges; no equivalence connector purports to be a Lean
dependency edge. The old fixed-width SVG is replaced by responsive semantic
HTML with result anchors and no script dependency.

Read the exact approved ISIT §§I–IV/Appendix and current extended `(19) (2)`
§§I–IV and relevant Appendices A/B through Theorem 2; checked their recorded
hashes and compared the relevant local Lean sources. Independent semantic and
operations/LP content reviews found no mathematical blocker. The newer
companion is still only selectively checked, not wholly covered. Mathematical
sources, API records, library pins, build gates and manuscript restrictions
remain unchanged.

Local validation passes: the 33-page/4,800-reference website guard; all fourteen
API tests; 23 website tests (22 pass, one Windows symlink-privilege skip);
source/render freshness for 992 declarations in 27 modules; the static gate for
56 Lean modules; default `lake build` (2,762 jobs); and a clean placeholder scan.
Browser checks pass 32 page/viewport combinations at 1440/768/390/320 px,
disclosures, keyboard/skip links, no-JavaScript navigation and clipboard controls.
Independent visual review additionally checked the complete argument section at
1440/390/320 px, all fifteen in-page result links, keyboard navigation to Theorem
2, 320-pixel no-JavaScript reading and 200% font sizing. No clipping, overflow,
browser errors or unresolved findings. Hosted validation and delivery remain
pending at this local checkpoint; the subsequent results follow.

**Delivery complete.** Commit `f4e5a7da1513a2c14fbe30db2fb4038fa5b60dd8`
was pushed only to public `master`.

- [Website run 38625112501](https://github.com/serhatemrecoban/PerfectFunctionalRepresentationsLean/actions/runs/38625112501)
  passed payload validation, the fresh compiler-backed API comparison and
  installed-pin/checkout checks, then deployed successfully.
- [All-module run 38625112458](https://github.com/serhatemrecoban/PerfectFunctionalRepresentationsLean/actions/runs/38625112458)
  passed the complete public Lean build gate and checkout checks.
- All 41 live payload files match the committed bytes. The 32 page/viewport
  checks, keyboard/disclosure/no-JavaScript and clipboard controls were repeated
  successfully on the live site. Local shared-layout checks also pass all 28
  cases, including header contrast and printed title.

The final documentation-only closeout changes no deployed file, mathematical
source, API inventory, validation rule or dependency pin. The local Windows
symlink-privilege skip remains recorded; it is not recast as a local pass.

## Structured blueprint and dependency graph — 2026-10-14

The lead requested a point-by-point blueprint and a directed graph, using PCP
and Fermat as presentation references. The rendered reference sites and the
[official Lean Blueprint documentation](https://github.com/PatrickMassot/leanblueprint#editing-the-blueprint)
confirm a common tool-supported convention, not a compulsory visual standard.
No implementation, assets or mathematical code were copied. PFR retains its
blue–green styling and uses an original standard-library static renderer, not a
new plasTeX/Graphviz or Lean dependency.

The [statement blueprint](../site/blueprint/index.html) has 41 entries: 34
formalized-contract entries, six private checked examples and one deliberately
unformalized cited remark. Lemmas 2 and 3 are subdivided by conclusion; all
numbered ISIT definitions, results, examples and both remarks are accounted for.
Selected supporting definitions and facts explain the bridges. This is not a
claim that every incidental manuscript sentence or the whole extended draft is
formalized. Statements retain finite-auxiliary, support, active-output and
nonempty-input qualifications, corrected LP indices and attained-extremum scope.

The [graph](../site/blueprint/dep_graph_document.html) contains 41 nodes and 81
typed edges, with whole-development and three topic views. Each topic includes
its transitive prerequisites. Solid edges are proof ingredients; dashed edges
are statement vocabulary. These are curated source-audited mathematical
dependencies, not compiler-extracted calls or equivalence arrows. The graph
deliberately does not invent Lemma 4 → Theorem 1 or Lemma 4 → LP proof edges.
The earlier equivalence map remains in the separate
[argument guide](../site/blueprint/guide.html).

One registry generates entries, graph nodes/edges, previews and textual
dependency lists. Public declaration names resolve against the unchanged
compiler-backed API inventory; private fixture and coverage anchors are checked
at its immutable source snapshot. Generator tests reject cycles, unknown
declarations, missing evidence, drifted anchors, unsafe/incomplete HTML and
out-of-order graph placement. Hosted publication additionally requires exact
regeneration; the existing fresh Lean API and all-module gates remain intact.

Local checks pass: 31 blueprint tests, fourteen API tests, 23 website tests
(22 pass and one Windows symlink-privilege skip), unchanged API/source rendering
for 992 declarations in 27 modules, the static gate for 56 maintained Lean
modules, `lake build` (2,762 jobs), and a clean placeholder scan. Independent
content review exposed missing standalone nonempty-input qualifications, which
were added. Independent tooling tests exposed incomplete-fragment and layout
ordering cases, now fixed and covered by regressions. The website guard passes
35 pages and 5,700 links/assets. Browser checks pass 40 page/viewport combinations
at 1440/768/390/320 px, plus 88 targeted graph/statement checks: readable default
zoom, true fit-width, topic selection, previews, reset, mouse panning, keyboard
scroll/activation, 44-pixel controls and no-JavaScript fallback. All four graph
views have no node overlap, text overflow or sampled edge crossing through
unrelated node interiors. The existing broad QA was adapted to scoped
navigation-current markers and direct-child disclosure summaries, since the
new blueprint has secondary navigation and nested disclosures; no requirement
was dropped. Final screenshots were visually inspected. Hosted validation and
delivery remain pending at this local checkpoint. No Lean source, dependency
pin, private manuscript or historical mathematical acceptance changes.

**Delivery complete.** Implementation commit
`0d64f197cc63d53e620e89ab51841ee69c0bfa78` was pushed only to public `master`.

- [Website run 38631914515](https://github.com/serhatemrecoban/PerfectFunctionalRepresentationsLean/actions/runs/38631914515)
  passed all static/generator checks, the fresh compiler-backed API comparison,
  installed-pin and clean-checkout checks, and Pages deployment.
- [All-module run 38631914562](https://github.com/serhatemrecoban/PerfectFunctionalRepresentationsLean/actions/runs/38631914562)
  passed the complete public Lean build gate and checkout checks.
- All 45 live payload files match the committed bytes. The 88 targeted blueprint
  and graph checks pass again on the public site, as do 40 responsive page
  combinations, skip/disclosure/no-JavaScript navigation and clipboard controls.

The documentation-only closeout records these completed results without changing
the tested website, generator, API, mathematical sources or pins. Windows's
local symlink-privilege skip remains a qualification, not a local pass inferred
from Ubuntu. No known content, tooling or browser review blocker remains.
