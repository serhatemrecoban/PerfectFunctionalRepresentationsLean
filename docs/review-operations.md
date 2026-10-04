# Supervised review: operating instructions

Use [the canonical protocol](review-protocol.md) for policy. This page owns the
small installed interface, not a new mathematical plan. The user opts in with
“with review” or an explicit plan-review request; the implementation agent handles
the phases and records without asking the user to copy intermediate messages.

## Entry points

Run from the PFR checkout with installed Python 3.13 (or a compatible Python 3):

```text
python -B tools/pfr_review/cli.py inspect
python -B tools/pfr_review/cli.py instructions
python -B tools/pfr_review/cli.py api
```

`inspect` is read-only: it reports actual Git/configuration/dependency facts,
C01's historical prerequisite and current plan candidates. It grants no step
authority. `instructions` loads these two maintained documents; `api` prints exact
supported method signatures. No command invokes native agents, SDKs or a queue.

`--checkout` selects an actual checkout root; default is this tool's repository.
`--input` reads an exact JSON packet, never executable code. Optional
`--save unique-name.json` preserves an exclusive output in `.pfr-review/setup/`.
Refusals return exit code 2 with the reason; successful local commands return 0.
An error is not a favorable result, automatic retry or proof of a human blocker.

Implementation-facing packet entry points are:

```text
python -B tools/pfr_review/cli.py bind --input <binding-packet.json>
python -B tools/pfr_review/cli.py open --input <session-packet.json>
python -B tools/pfr_review/cli.py next --chunk PFR-C02 --input <actual-message.json>
python -B tools/pfr_review/cli.py call --chunk PFR-C02 --input <operation.json>
```

`call` accepts `{"method":"inspect","args":[],"kwargs":{}}` and only the
allowlisted methods shown by `api`. An agent may instead import `project.py`
with `tools/pfr_review/` on its Python search path and use the same interfaces.
Never patch journal objects/projections to fix a refusal.

## Bind the chunk reviewer once

The **C02 implementation task**, not this General Assistant, creates its reviewer.
First preserve the actual user instruction and a bootstrap intent in private
records. Inspect the available native schema; the tested collaboration interface
requests `model="gpt-6-astra"`, `reasoning_effort="ultra"`,
`fork_turns="none"`. Use a neutral bootstrap with no implementation conversation,
self-review conclusions, expected defects, or sibling solutions. Require read-only
source review, no delegation, no edits, no unrelated access, and waiting for the
exact source-bound request. Retain the actual returned canonical identity.

The `bind` packet contains `chunk`, `parent`, `reviewer`, `approval`, and `creation`.
`parent` must equal the current task's exposed `CODEX_THREAD_ID`; `/root` is a role,
not that UUID. `creation` contains:

- `canonical_reviewer`, the exact returned identity;
- `requested`: `{"model":"gpt-6-astra","reasoning_effort":"ultra","fork_turns":"none"}`;
- `original_result`: the complete actual creation result (the supported result
  has `task_name` equal to the canonical reviewer), not a invented acknowledgement;
- `reference`: the actual native reference, or an explicitly local capture label;
- `parent_role`: the actual recipient role, normally `/root`;
- optional `effective_parent` / `effective_reviewer`: actual observable fields,
  not inferred from the request; omit/leave null when unknown.

Every `approval` / `user_observation` contains `role:"user"`, a real `reference`,
and exact `original_text`. These are supplied evidence, not authenticated by Python.
Unknown effective settings and cooperative read-only behavior are accepted limits
of this supervised installation. An observed conflicting profile is not unknown.
The diagnostic reviewer is explicitly refused as a production chunk binding.

Binding records are private and exclusive at `.pfr-review/chunks/PFR-C02/`.
One binding is shared by its plan-review and execution sessions; creating a new
session does not replace the reviewer. Do not recreate an existing binding/store
to recover from an error. Read its state and use supported continuation.

## Register actual plan scope, not dummy environment data

No C02 plan is approved at installation. Planning can proceed; mathematical
execution cannot. Do not create a placeholder active plan to satisfy this tool.
Once the real plan exists, the agent prepares the exact `open` packet:

- `chunk`, `session` (`execution` for steps, `plan-<local-id>` for plan review);
- `contract`, with exactly the fields below;
- `approval`, with actual user origin and `scope:"APPROVED_IMPLEMENTATION_PLAN"`
  plus `plan_sha256` for execution, or `scope:"PLAN_REVIEW"` for plan review.

The contract fields are `plan_path` (actual `docs/plans/*.md`), `plan_sha256`
(current full-file SHA-256), `kind` (`STEP` or `PLAN`), `scope` (explicit additional
relative source/dependency file paths), `steps`, `plan_criteria`, and
`normative_anchors` (nonempty exact normative passages in that plan).

For execution, `steps` is the ordered list of `{"id":"PFR-C02-S01","criteria":[...]}`
records and `plan_criteria` is empty. For plan review, `steps` is empty and
`plan_criteria` states what the proposed plan must establish—not nonexistent proofs.
Each criterion has `id`, `description`, `source_reference` (`plan_path#anchor`),
`normative_excerpt`, `scope`, and `required_evidence`. IDs must be unique across
the contract. Excerpts and step IDs must actually occur in the plan. The agent
must verify the allocation faithfully covers the approved step; substring checks
are not a semantic parser or permission to omit requirements.

Execution requires an actual plan status `Approved` or `Active` and exact
project-lead approval. Merely opening a session starts no step. The real source
adapter captures tracked files and relevant nonignored untracked source/docs/tools,
plus explicit pinned dependency paths, and actual Git/index/toolchain/pin facts.
Installed pins must be clean and match the manifest. It does not infer imports.
Include the dependency declarations/consumers needed by the step explicitly;
do not assume a package HEAD alone documents what was inspected.

B/R/F preserve exact working bytes, dirty state, untracked files and deletions.
The virtual `@environment` inventory entry is derived from the actual configuration
and installed dependency inspection, not a made-up environment file. Git changes
since HEAD remain distinct from the selected step's B snapshot. Records, temporary
files, builds and reference media are outside the capture; never store papers here.

The plan's normative text is frozen for the session. Optionally, a future approved
plan can explicitly reserve one editorial region delimited by
`<!-- pfr-review-status:start -->` and `<!-- pfr-review-status:end -->`. Only status
and chronological notes belong there, never requirements. Text outside that block
cannot change silently. Without markers the whole plan is normative. All Markdown
bytes remain source-visible and conservative for evidence applicability: update
documents before final checks, or justify/refreshed evidence according to impact.
A material replacement contract needs explicit approval; the current recovery
path only supports retaining the original contract, not silently adopting a new one.

## One processed step with review

1. Read current state and the actual processed user message. The `next` packet is
   `{"message_id":"pfr-message:<native-or-local-id>","user_observation":{...}}`.
   Assign a local ID once only when no native ID is exposed and label that fact
   in the reference. An identifiable redelivery reuses it. Do not simulate another
   user message after closure. A skip stays consumed; pending work is not retried.
2. On an eligible fixed step, capture B before edits. `begin_edit(paths, reason)`
   preserves the agent's exact before-images. Apply the bounded edit normally
   with patch tools; `finish_edit(ref)` records after-images. Do not use these
   records to overwrite someone else's intervening work. For own-edit reversal,
   compare current bytes against the saved after-image before manually restoring
   only that patch, then `finish_reversal(ref)`. No Python helper edits Lean files.
3. Run the actual required checks. `parent_evidence(method, output, limitations,
   outcome=..., command=...)` stores actual observations and source. Then
   `initial_validation(refs)`, `self_review(recommendations, narrative)` and
   `reassess(decisions)` preserve the two separate contextual phases before fixes.
   Use stable `pfr-finding:` IDs and the report finding fields. Reassessment maps
   each recommendation ID to its reasoned decision, not automatic agreement.
4. Apply justified changes; validate and dispose of findings with supported
   evidence/statuses. `prepare_review(request_id, validation, question)` freezes R.
   Request IDs use `pfr-review:PFR-C02:execution:<unique-id>` (or the exact plan
   session instead of `execution`), so IDs cannot collide across sessions.
   Inspect the rendered neutral text. Do not forward private records or verdicts.
5. `dispatch_intent(request_ref)` precedes the actual native follow-up. The agent
   invokes the exposed collaboration tool on the recorded reviewer, preserving
   the exact text. `record_submission` preserves the full actual result and
   normalized `ACKNOWLEDGED`, `UNCERTAIN`, or `FAILED`. Bound each wait to at most
   60 seconds; timeouts are pending. Do not blindly resend on empty output.

   **Waiting efficiency (builds, probes and reviewer work):** Keep existing
   efficient waits unchanged, including appropriate 30-60-second waits. After
   repeated short checks return no useful information, gradually lengthen the
   wait within the existing 60-second cap (for example, 15 or 30 seconds, then
   up to 60 where appropriate; not a mandatory schedule). Prefer native waits
   that return early on relevant output or completion when supported; avoid
   artificial sleeps or delays after results arrive. Preserve useful parallel
   work and short waits needed for responsiveness. Change only wait/yield
   intervals, not models, reasoning settings, context handling, reviewer
   participation or scope, validation, delivery, timeout or completion rules.
   Shorten affected waits if they noticeably delay progress. A normally one-hour
   step should not exceed three hours solely because of this adjustment; that
   is an upper tolerance, not a target or a deadline for stopping work.

6. Preserve the original full report and available native metadata. Observation
   fields include `input_mode:"OBSERVED"`, `origin:"RUNTIME_EVENT"`, `parent`,
   `reviewer`, `request_ref`, honest `event_ref`, and `original_event` as the JSON
   encoding of the actual event wrapper. For reports add `event_kind:"FULL_REPORT"`,
   `complete:true`, `text_role:"ORIGINAL_NOT_SUMMARY"`, `extracted_text`, and the
   extraction method. The wrapper retains `Message Type`, `Task name`, `Sender`,
   `Payload`; role and task UUID remain distinct. A receipt's original empty body
   can be retained as the JSON string `""`, never as an invented acknowledgement.
7. When necessary, append separate `confirm_delivery(request_ref, receipt_ref,
   original_text, observation, approval)` using authority action
   `CONFIRM_DIAGNOSTIC_DELIVERY` (legacy operation name, real project namespace).
   `authority(action,target,"pfr-auth:<unique-id>",user_observation)` constructs
   the supported specific record from the current authorized request. Then use
   `receive_report`, explicit `reconcile_report`, and evidence-based disposition.
   Do not forge an approval from reviewer prose or reuse technical authority for
   a substantive decision. Plan/reviewer meaning is not inferred by Python.
8. Retain negative evidence. Call `begin_corrections()` after reconciliation
   before recording/applying independent-review fixes (also before new edits from
   final validation). Apply justified corrections, use `extra_review` for
   necessary linked productive rounds, and preserve every original report. Follow
   the protocol's stronger initial self-review and criterion-gap safeguards.
   Ordinary recovery modes are separate from substantive adjudication, which is
   unsupported and must stop with recoverable records.
9. `finish_corrections()` enters final validation. Prepare concise canonical
   document notes first; then obtain current checks. Refresh any resolved/refuted
   finding disposition whose supporting evidence became stale using current
   evidence; closure rechecks those dispositions as well as criteria. `assess` each required
   criterion, `finalize_documents(reason)`, and `prepare_final(validation,
   impact=..., rationale=...)`. Use `BOUNDED_CORRECTION` only for a justified
   bounded R-to-F change, never material invalidation. Finally `project_closure()`
   checks exact F and all obligations, closes only this step, and starts nothing.
   Included documents stay unchanged afterward; report the durable reference in
   the task. Future documentation can display “validation ready, closure subject
   to `.pfr-review` record” before F to avoid circular completion claims.

The existing core operation labels may still say `FIXTURE_GENESIS`,
`COMPLETE_FIXTURE_STEP_AND_STOP`, or `DIAGNOSTIC`; they are retained implementation
labels, not subject/provenance claims. Project records use their distinct project
tag, real binding, `fixture_only:false`, and explicit supervised scope. Source-copy
tests and toy records use different tags/modes and never become project acceptance.
Even a structural project closure is not an independent Lean proof certificate.

## Explicit finding-ID correction

The lead-authorized 2026-09-20 recovery exposes
`reconcile_report_identity(report_ref, old_id, new_id, clarification, approval, rationale)`.
Use it only from `REPORT_CHECK` for the current accepted report when its new
optional claim collides with a resolved optional finding from a closed earlier
step. The new ID must be fresh. Preserve the user's approval and its antecedent;
construct authority with action `CORRECT_REPORT_FINDING_ID` and target equal to
the exact accepted report reference. This authority is separate from ordinary
step authority.

`clarification` retains the actual bound-reviewer FINAL_ANSWER envelope and
verbatim extracted text, using the normal observed/replayed provenance fields.
Set `event_kind: "FINDING_ID_CLARIFICATION"`, `complete: true`,
`text_role: "ORIGINAL_NOT_SUMMARY"`, and associate the exact `request_ref`,
`report_ref`, `source_ref` and `attempt`. The reviewer-specified new ID must be
the sole distinct complete finding-ID token in the text. Prefix matches and
multiple candidate IDs are refused. The parent evaluates its meaning; these structural checks do not
authenticate a human/native sender or interpret prose. Retain the original
clarification; do not send it through `receive_report` as a replacement report.

The operation atomically appends the clarification, scoped authority, exact
identity/source mapping and original-report reconciliation. Its derived findings
change only the one ID. It does not resolve findings, alter original independent
criteria, close the step, reopen history, or re-arm skipped requests. Normal
correction, applicability, validation and closure duties follow.

Because installing this repair changes reviewed tooling, its source exception
is limited to these exact paths (no deletions): `tools/pfr_review/core/workflow.py`,
`tools/pfr_review/project.py`, `tools/pfr_review/cli.py`,
`tools/pfr_review/tests/test_finding_identity.py`, `tools/pfr_review/README.md`,
`docs/review-protocol.md`, and `docs/review-operations.md`. Retain authorized repair
before-images separately when the installed edit phase cannot yet record them.
Test and inspect the repair before applying the operation. It captures and
rechecks the exact source delta, leaving Lean, dependency/environment and plan
bytes unchanged; this bounded exception is not a general source-divergence
waiver. Normal `reconcile_report` retains its original source-equality check.

## Plan review, backup and unsupported exceptional paths

In a `plan-*` session use `plan_review_request`, then `plan_review_record` stages
`INTENT`, `SUBMISSION`, `REPORT`. Native calls and lossless delivery rules are the
same. Select that session explicitly for every `call` or `backup`, for example:

```text
python -B tools/pfr_review/cli.py call --chunk PFR-C02 --session plan-<local-id> --input <operation.json>
```

Without `--session`, the command selects `execution`, not the plan-review session.
An uncertain submission is preserved before a known refusal; retain its
record reference and confirm delivery from the actual report without resending.
`reconcile_plan_review(decisions)` preserves the implementer's evaluation;
`plan_review_result()` explicitly awaits lead approval and authorizes no step.
A revised plan review uses a fresh explicitly requested plan session with the same
chunk reviewer, retaining earlier records; it is not a replacement execution plan.

`.pfr-review/` is ignored private durable state, **never ordinary scratch**.
Existing journal backup is available via `backup --chunk ... --input ...` with
`{"name":"fixture-backup-<unique-lowercase-name>"}`; the legacy prefix is only a
filename convention. This is a consistent same-disk journal copy, not protection
against device loss. While no workflow writer is running, manually copy the entire
`.pfr-review/` folder and retain the corresponding checkout/version in a separately
chosen private backup location. No external backup or loss window is configured.
Do not overwrite current records during restore: inspect the saved tip, identities,
current source and outstanding dispatch first. Automatic stale-lock removal,
schema migration, corruption repair, cancelled-request reactivation, conflict or
substantive-decision adjudication, and historical-closure reopening are not supported.
The explicit finding-ID correction above preserves earlier closures and is not
one of these general recovery operations.

## C02 startup instruction

> Read AGENTS.md, the living-summary quick start, docs/review-protocol.md and
> docs/review-operations.md. Run the installed read-only inspection. Treat C01 as
> historically complete. Establish your own persistent chunk reviewer using the
> approved Astra/ultra/no-parent-history profile and preserve its actual binding.
> Begin detailed C02 planning only; do not implement mathematics until I approve
> its exact plan. Use the installed supervised workflow when I request plan review
> or an eligible step “with review”; handle the normal review phases yourself and
> stop after each authorized step.

The actual C02 binding, approved mathematical plan and real user desktop queue
test are not installation checks. Do not claim they happened merely because local
fixtures passed. Unattended use is not installed or authorized.
