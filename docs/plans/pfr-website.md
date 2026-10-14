# PFR Research Website Plan

**Status: Active, 2026-10-14.** The lead authorized building the research website
and requested a detailed plan followed by implementation when practical. This
plan records that bounded website task, not a new mathematical chunk. Baseline:
`da44e39a2ec2936d32195dd97df21c1bd19e63bc`. Completion evidence will be recorded
here and in the project log; a plan is not evidence of successful deployment.

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

W04 is in progress: Pages workflow hosting is configured with HTTPS, but hosted
deployment and live validation remain pending. See the project-log entry for
delivery revision and actual hosted results when complete.
