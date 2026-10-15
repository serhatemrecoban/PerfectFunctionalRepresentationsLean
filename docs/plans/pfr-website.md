# PFR Research Website Plan

**Status: Complete and live, including the structured blueprint and dependency graph, 2026-10-14.** The lead authorized building the research website
and requested a detailed plan followed by implementation when practical. This
plan records that bounded website task, not a new mathematical chunk. Baseline:
`da44e39a2ec2936d32195dd97df21c1bd19e63bc`. Completion evidence is recorded below and in the project log; the execution
plan itself is not evidence of successful deployment.

## Purpose and audience

Give information theorists and formalization researchers a clear route from the
paper's question to the verified results, their precise limits, and reproducible
Lean source. Complement LeanInfoTheory's documentation rather than create a
second library API portal. Keep the completed case study attributed to
**LeanInfoTheory v0.1.0**, with no dependency upgrade.

## Information architecture

| Page | Content and reader outcome |
| --- | --- |
| Overview | Research question, functional/perfect representation equations, explanatory diagram, author credits, key results and routes onward |
| Results | Grouped paper-to-Lean results, exact declaration links pinned to the reviewed source commit, assumptions beside claims, full coverage-ledger route |
| Discussion | Finite-auxiliary/support limitations; constructive normalization proof and the incomplete informal termination argument; corrected LP indexing; bounded scope; measured library reuse |
| Reproduce and cite | Tested installation commands, all-module versus lightweight build, frozen dependency identities, CI, software citation and separate paper credit |

Discussion means authored explanatory content, not a comments service. Do not
publish local manuscripts, annotated proofs, private runtime records or reports.
Do not invent a paper URL, DOI, release number, affiliation, rights-holder claim
or counterfactual code/time saving. Add approved paper metadata later when supplied.

## Design and implementation

- Buildless HTML, shared CSS and minimal progressive JavaScript under `site/`.
  No package manager, framework, third-party assets, analytics, cookies or backend.
- Editorial research design: warm paper background, dark ink, restrained teal,
  serif headings, readable system-font body, thin rules and generous whitespace.
  Use a meaningful original SVG diagram, not stock imagery or decorative metrics.
- Four-page navigation, visible active state, skip link, one main heading per
  page, descriptive links, keyboard focus, adequate contrast and reduced-motion
  support. Native disclosure widgets may expose detailed declaration names.
- Responsive layouts from narrow mobile to desktop. Long Lean names, hashes and
  commands must not force page overflow. Essential content works without JS.
- Copy controls are enhancements with clear success/failure feedback; they must
  never claim success when clipboard access fails.
- GitHub Pages publishes only the allowlisted `site/` directory through a
  SHA-pinned workflow. Build validation has read-only permissions; deployment
  alone gets Pages and identity-token permissions. Pull requests never deploy.
  Relative local links must work under the repository URL prefix.

## Checkpoints and acceptance criteria

### W01 Content contracts

Read the coverage ledger and actual Lean declarations. Independently inspect
the source routes for the principal results and normalization argument. Build
`site/source-links.json` with exact file, line and declaration evidence at the
source baseline. Keep finite auxiliary, support, singularity, nonempty-input and
output-relabeling qualifications near the relevant claims. Treat the six-page
ISIT paper as the target, extended v16 as the historical proof companion, and
the newer companion as only selectively compared. No private paper text is copied.

Acceptance: every advertised result has a verified source route; neither
coverage of the entire newer draft nor an executable LP solver is claimed.

### W02 Complete site

Implement all four pages, shared design, navigation, SVG and optional copy
controls. Provide complete content and useful outward links, not placeholders.
Explain normalization by induction on the original finite path and finite
certificate realization; do not assert a decreasing rewritten-path inversion
count, arbitrary rewrite termination or a false theorem.

Acceptance: all planned sections exist, the site reads coherently on its own,
and readers can reach source, qualifications, reproduction and citation easily.

### W03 Automated and visual validation

Add standard-library-only site checks and fixture tests for internal links,
fragments, assets, basic semantic HTML, deployment portability, prohibited
content and exact source anchors. Check positive and negative fixtures. This
validator is a guardrail, not an exhaustive security/accessibility certification.

Serve a local preview. Inspect every page at desktop and mobile sizes, inspect
screenshots, test navigation, anchors, keyboard focus and copy feedback, and
check for overflow, missing resources and browser errors. Confirm content still
works with JavaScript disabled. Review mathematical copy independently and
correct substantive or visual issues before publishing. Run the existing static
public build gate, `lake build`, placeholder scan and diff checks; preserve Lean
sources and dependency files byte-for-byte.

Acceptance: automated checks pass, manual browser checks have recorded outcomes,
no known broken navigation or misleading claim remains, and public payload
contains only the intended site files.

### W04 Public delivery and documentation

Reconcile README, living summary, roadmap, scope and public-readiness notes.
Record the implementation and actual validation in the project log. Commit the
bounded website changes, push only `master`, enable Pages workflow hosting and
verify the resulting HTTPS URL and deployed pages. Never mirror local refs or
upload the whole repository as the website artifact. Inspect public workflow
results and logs; update the repository homepage to the confirmed site URL.
Stop the owned preview server after checking the public site.

Acceptance: the deployed source revision is known, Pages succeeds, the live site
responds over HTTPS, site and Lean CI pass, and canonical status is truthful.
If hosting is unavailable, deliver the tested site and exact blocker without
claiming deployment. Do not silently widen permissions or change dependencies.

## Maintenance and revision

Maintain content in the owning HTML pages, design in shared assets, and theorem
anchors in `source-links.json`. Any source snapshot change requires rechecking
claims and updating both the links and manifest. CI must fail on stale pinned
anchors or broken local links. Keep exhaustive omissions and implementation
history in their current canonical owners; the site supplies readable summaries.

Later paper links/citations, new mathematical scope, comments, analytics,
interactive solvers, dependency upgrades and tagged releases require their own
appropriate approval. No numbered Future Work Note currently applies: website
work was already mapped to the General Assistant with a lead-request trigger,
now satisfied. Missing paper metadata retains its existing readiness owner.

Routine content/design improvements may be made within this task and recorded
here without treating the plan as a rigid script. Substantive changes to scope,
mathematical intent, publication rights or acceptance require lead input.

## Completion evidence

W01–W03 complete locally: independent mathematical/source review; 16 exact
source anchors; four pages and 131 links/assets checked; 21 guard tests (20 pass,
one Windows symlink-privilege skip); browser checks at 1440, 768, 390 and 320 px;
keyboard entry, disclosures, clipboard success/fallback and all pages without
JavaScript; visual inspection; existing 11 public-build tests, static gate,
placeholder scan and default Lean build (2,762 jobs). The narrowest viewport
exposed an oversized heading, now corrected. Clipboard feedback now handles
unavailable selection truthfully. The browser test initially checked asynchronous
clipboard completion too early; its control now waits for actual status output.

The independent content review suggested clarifying the TV convention and
maximum domain and linking both constructive characterizations; all were adopted.
No blocking mathematical or attribution finding remains. Lean sources, toolchain
and dependency configuration are unchanged.

W04 complete: [the public site](https://serhatemrecoban.github.io/PerfectFunctionalRepresentationsLean/)
was deployed from `18a4833b3397d4410e54e8fd0235ac4c53dc84b9` by
[website run 38580736326](https://github.com/serhatemrecoban/PerfectFunctionalRepresentationsLean/actions/runs/38580736326).
All 21 guard tests passed on Ubuntu (no skips). Live browser tests repeated all
sixteen viewport/page combinations and the interaction/no-JavaScript checks.
All nine served files matched the committed bytes. Public logs/inventory were
reviewed, HTTPS and repository homepage verified, and the owned preview server
stopped. The official deploy action's non-blocking `punycode` warning is recorded
in readiness; all check annotations are empty.

[Lean CI run 38580736535](https://github.com/serhatemrecoban/PerfectFunctionalRepresentationsLean/actions/runs/38580736535)
passed on the same commit: all 56 modules (2,823 jobs), default build (2,762 jobs),
eleven gate tests, ten installed pins and clean checkout. A final local default
build passed too. Closing changes record only this evidence and current status;
site, tools, workflows, Lean sources and dependency pins remain the tested versions.
The [project-log entry](../project-log.md#research-website) records delivery.
Approved paper metadata remains a separate, already recorded follow-up—not an
unfinished website implementation requirement.

## Approved structure and palette extension — 2026-10-14

The lead requested the overview / mathematical blueprint / generated API
structure discussed after the initial delivery, using LeanInfoTheory's colors
rather than the Fermat project's appearance. Baseline: `ec9bc5d`. This extension
supersedes the four-page navigation and warm-paper palette, not the completed
W01–W04 evidence. It does not change mathematical scope or dependency pins.

- **W05 Presentation:** retain the existing results, discussion and reproduction
  material; introduce clear overview, blueprint and API entry points. Use the
  LeanInfoTheory site's blue–green gradient, blue links and white background,
  with accessible contrast and the existing readable research typography.
- **W06 Blueprint:** original expository statements, proof ideas and source links
  for Definitions 1–4, Lemmas 1–6, Theorems 1–2 and Corollary 1. An accessible
  dependency guide must distinguish conceptual structure from exact compiler
  dependencies; in particular, Theorem 1 does not invoke the general Lemma 4
  normalizer. Preserve nearby assumptions and omission/scope links.
- **W07 API:** generate searchable PFR declaration pages from the installed Lean
  environment, including exact elaborated types, available docstrings, module
  ownership and source links. Exclude private/compiler-generated/test-only
  declarations and describe that boundary. This is a PFR API browser, not a
  replacement for LeanInfoTheory/mathlib documentation. Use isolated tooling;
  preserve the root toolchain, manifest, dependency configuration and Lean files.
  Prefer a small compiler exporter over the compatible but much larger doc-gen4
  dependency closure; do not present regex-extracted signatures as compiler data.
- **W08 Verification/delivery:** test generation and stale-source checks, website
  safety/link gates, search and keyboard behavior, responsive layouts and
  no-JavaScript reading. Independently review content and exporter boundaries.
  Validate the default Lean build and existing public gate, reconcile canonical
  documentation, publish only intended site content through the existing Pages
  workflow and verify deployed pages. Record actual results separately from
  acceptance criteria. No new library dependency or external runtime asset.

Generated API data must be reproducible from the recorded mathematical snapshot.
Any change to documented Lean source requires regeneration and refreshed source identities.
Routine website builds should not install a second Lean toolchain or rebuild a
new dependency graph merely to change presentation.

W05–W07 and local W08 validation are complete. The site guard verifies 33 HTML
pages and 4,715 links/assets, including 34 human source anchors and 31 direct
blueprint-to-API links. Fourteen API tests pass; the 23 website tests have 22
passes and one Windows symlink-privilege skip. Fresh compiler generation and a
separate `--check` agree exactly on 992 entries across 27 modules (2,794 build
jobs), with all ten installed dependency identities/clean tracked trees checked
before and after export. The existing default build and public static gate pass.
Browser checks cover eight representative pages at four widths and search,
keyboard, disclosures, no-JavaScript reading and clipboard success/fallback.
Independent content/tooling review has no unresolved blocker.

W08 delivery is complete at `b4ca3387b76f6f6a71ee90b1951601bb5d4f4cfb`.
Both hosted workflows passed: all maintained Lean modules and the website's
static/compiler-backed API gates followed by Pages deployment. All 42 published
files match the committed bytes; the browser checks above were repeated against
the live site successfully. The [readiness record](../public-readiness.md#blueprint-api-and-palette-extension--2026-10-14)
owns exact run links and validation evidence. The closing documentation-only
checkpoint does not change the tested website, tooling or mathematical sources.

## Approved academic layout correction — 2026-10-14

The lead found that the delivered site matched the colors and information
routes but not the visual design of LeanInfoTheory and Fermat's Last Theorem.
This correction replaces the custom editorial layout; it does not reopen the
mathematical content, API scope or dependency decisions. Baseline: `dd33138`.

Match the references' full-width centered gradient masthead, bold sans-serif
project title, bordered navigation buttons and narrow single-column reading
layout. Retain LeanInfoTheory's blue–green palette, use green section headings
and blue links, and replace promotional cards/oversized split headings with
plain paragraphs and lists. Keep the explanatory diagram below the introduction.
Apply the shared layout to the blueprint, discussion, reproduction and generated
API pages, preserving exact source links, qualifications and useful interactions.

Acceptance requires side-by-side visual comparison to the actual reference
sites, desktop/mobile and keyboard/no-JavaScript checks, unchanged compiler API
contracts, existing website/API validation and a verified Pages deployment.
The reference websites are design references only; no implementation or assets
are copied and no external font/theme dependency is introduced. Existing
publication gates, mathematical sources and LeanInfoTheory v0.1.0 remain fixed.

Local acceptance passes, including independent visual comparison, 28 explicit
layout checks and 32 browser page/viewport combinations. The contrast finding
was fixed; generated declarations and source hashes are unchanged. See
[readiness](../public-readiness.md#academic-layout-correction--2026-10-14)
for exact compiler/test results. Hosted delivery is complete as recorded below.

The lead also clarified that development chunks are internal work packages,
not parts of the paper. The homepage status must describe the formalized paper
content and link its qualifications, not advertise the internal chunk count.

The lead then specified the displayed title **On Perfect Functional
Representations**, description **ISIT 2026 paper**, a Paper button adjacent to
GitHub and links on editorial mentions of the paper title. Use the same verified
DOI as the author's academic homepage and EPFL publication record:
`https://doi.org/10.1109/ISIT62367.2026.11653684`. Do not rename the repository or
Lean namespaces, alter verbatim API docstrings, or distribute local manuscripts.

Final delivery is `d8ce9779e411f7fdf4687dec6e9f8c9fdf581e9b`. The hosted
website/compiler and all-module Lean workflows passed. All 42 live files match
that commit, and the responsive, keyboard, search and no-JavaScript checks pass
on the deployed site. The readiness record owns exact run links and limitations.
The final evidence-only documentation checkpoint changes no tested site or code.

## Approved argument-map revision — 2026-10-14

The lead requested a fresh manuscript-grounded explanation of how the ideas
connect. Replace the blueprint's disconnected fixed-width diagram with a
responsive, linked argument map. Distinguish the binary optimization branch from
the general structural problem, equivalences from proof dependencies, and the
paper's Lemma 4 route from Lean's direct canonical-witness constructions.
Explain both directions of Theorem 1, the partition-weight bridge, primal slack
saturation and the separate dual separation argument. Keep finite/support and
reduced-incidence qualifications beside the claims.

This is a presentation change, not a coverage expansion or a new mathematical
step. Consult the approved ISIT §§I–IV/Appendix and current extended §§I–IV and
relevant Appendices A/B; retain historical implementation-source identities.
Acceptance requires source-backed content review, readable desktop/mobile and
no-JavaScript behavior, valid result links, existing website/API/build checks
and the unchanged hosted deployment gates. Exact evidence belongs in
[readiness](../public-readiness.md#argument-map-revision--2026-10-14).

Local acceptance passes, including independent mathematical and visual reviews,
responsive/no-JavaScript/large-text checks and the existing website/API/default
Lean build gates. Delivery is complete at `f4e5a7d`: hosted website/compiler and
all-module Lean checks pass, all 41 live payload files match source, and the
responsive/interaction checks pass again on the deployed site. The readiness
record owns exact run links and limitations.

## Approved structured-blueprint extension — 2026-10-14

The lead requested individual definition/lemma/theorem entries and a directed
dependency graph like the PCP and Fermat blueprint sites. Baseline: `7ba57ff`.
Keep PFR's established blue–green design. Adopt the widely used Lean Blueprint
conventions without requiring its plasTeX/Graphviz toolchain: the site's own
static renderer is sufficient for this bounded presentation change.

Provide a persistent statement index, visible statements and qualifications,
expandable proof ideas and exact Lean evidence, stable anchors, status labels,
and a separate directed graph. Include every numbered ISIT definition, result,
example and remark, distinguishing private checked fixtures and intentional
exclusions. Selected supporting entries explain the actual proof routes. Edges
mean statement vocabulary or proof ingredients, not equivalence, module imports
or complete compiler-extracted dependencies. Retain the argument map separately.

The authoring records are `tools/blueprint/{semantics,operations,examples}.json`;
`page.html` and `guide.html` there own the shared template and argument guide.
Run `python -B tools/generate_blueprint.py` after edits, then its `--check`
mode and `tools/test_generate_blueprint.py`. The same entries generate statements,
dependency lists, graph views and previews. Public declarations resolve against
the compiler-backed API inventory; private evidence anchors are checked at that
inventory's immutable source commit. Changing a graph edge requires source-backed
review of its rationale, not merely passing the structural checks.

Acceptance includes mathematical cross-review, acyclic/valid links and source
evidence, readable desktop/mobile graph navigation, keyboard and no-JavaScript
controls, reproducible generated output, the existing website/API/Lean gates,
and verified hosted delivery. No Lean source, library pin, formalization scope,
private manuscript, or existing compiler-backed publication gate changes.
Exact validation and delivery evidence belongs in
[readiness](../public-readiness.md#structured-blueprint-and-dependency-graph--2026-10-14).

Local acceptance passes: independent mathematical/tooling reviews, 31 generator
tests, existing website/API/Lean gates, 40 responsive page combinations and 88
targeted interaction/layout checks. Hosted validation and live delivery remain
pending at this checkpoint. The preceding site remains live until the unchanged
publication gates accept and deploy the new payload.

Delivery is complete at `0d64f197cc63d53e620e89ab51841ee69c0bfa78`.
Hosted website/API and all-module Lean workflows pass. All 45 live payload files
match that commit; the 88 targeted checks and 40 responsive page combinations
pass again against the public site. The readiness record owns exact run links.
The final documentation-only closeout leaves the tested payload and code intact.

## Link behavior — 2026-10-15

Resource and cross-page content links open a new tab; internal menus, footer
navigation, contents, permalinks and graph controls keep the current tab.
External resources in the header remain resource links. Native HTML targets
preserve this behavior without JavaScript, with safe opener attributes and an
accessible new-tab notice. Graph previews inherit the same resource-link policy.

`tools/website_links.py` owns this shared rendering policy. After hand-authored
HTML edits, run it normally; API and blueprint generators apply it themselves.
Its `--check` mode checks all published HTML without writing. The policy tests
and website guard run in CI alongside the existing compiler-backed checks.
This changes browsing behavior, not mathematical content or dependency pins.

## Lemma 4 terminology — 2026-10-15

Website exposition calls Lemma 4 the operation-reordering lemma. The discussion
heading includes “(Lemma 4)” as well as retaining the nearby lemma references.
Lean names such as `NormalForm` and `OperationPath.normalize` remain unchanged;
a code comment explains that normalization means reordering into PPS/VPS/PPM
normal form, not rescaling probabilities. Probability and partition-weight
normalization retain their existing terminology. Stable fragment identifiers
are preserved, including `discussion.html#normalization`.

The API and source-link snapshot is refreshed to `f8c89ee94513b544dc72b10fb4e91a046420c4a6`
to include that comment. Declaration names, contracts, proofs and source line
numbers are unchanged; the LeanInfoTheory v0.1.0 dependency pin is unchanged.

## Paper-style proof of Lemma 4 — 2026-10-15

The Discussion page adds a second native blue disclosure immediately below
“Where to find the formal construction”: “A paper-style proof of Lemma 4.”
It presents the existing finite-certificate proof in mathematical prose using
column values and binary patterns, including the invariant, all three induction
cases, legal three-stage realization and final output permutation. The source
links remain above it. Native MathML supplies the displayed equations without
an external rendering dependency. The proof is original exposition of the Lean
construction, not a reproduction of the local manuscript or a new theorem.

## Dependency-graph zoom — 2026-10-15

The graph supports pointer-centered mouse-wheel zoom and explicitly labeled
Zoom in / Zoom out buttons, with its existing fit, readable-size and reset
controls. The 5%–200% bounds are retained; buttons indicate their limits.
Dragging empty canvas space still pans. Modified wheel gestures, horizontal
scrolling and scrolling outside the canvas remain native. Instructions explain
Shift-wheel scrolling and browser zoom. No external library, graph edge,
mathematical statement or Lean source changes; the static no-JavaScript graph
and text alternatives remain available.

## LaTeX presentation of Lemma 4 — 2026-10-15

The proof disclosure is now titled “A paper-style proof of the Lean
formalization of Lemma 4.” It displays two white LaTeX-typeset pages containing
the ISIT lemma statement and original exposition of the Lean construction.
The finite/nonempty-input, active-column and output-relabeling conventions
remain explicit. The existing formal-construction links remain above it;
an expandable reflowable text version and LaTeX download remain available
without JavaScript. No theorem, dependency or coverage contract changes.

`tools/proofs/lemma-4.tex` is the typesetting source. Run
`python -B tools/build_lemma4_proof.py` with `pdflatex`, `pdfinfo` and
`pdftocairo` available, then visually inspect every page. The PDF/logs under
ignored `tmp/pdfs/lemma-4/` are intermediates, not public manuscript files.
Only self-contained vector pages, a source copy and fingerprints enter
`site/assets/proofs/`. Update the HTML text counterpart if the proof changes.
The existing public-payload guard remains unchanged; no PDF embedding or
third-party rendering dependency is introduced.

`python -B tools/build_lemma4_proof.py --check` checks the reviewed source,
published source copy, page inventory and exact asset fingerprints. CI runs
that check and its model-free regression tests; it does not independently
rerun TeX or assert byte-identical rendering across TeX installations.
