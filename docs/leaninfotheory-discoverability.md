# LeanInfoTheory API Discoverability Feedback

This file records genuine LeanInfoTheory API discoverability problems observed
while developing PFR against the pinned release. It is empirical feedback, not
a log of routine successful searches, a PFR status document, or authorization
to modify LeanInfoTheory or the dependency pin.

## Recording policy

- Search and verify according to [`AGENTS.md`](../AGENTS.md) before opening an
  entry.
- Record an issue only when finding, importing, applying, or confirming the
  absence of a relevant generic API caused material difficulty.
- Do not record routine successful searches or hypothetical improvements.
- Keep any downstream workaround local to PFR. An upstream proposal or fix
  requires a separate LeanInfoTheory task and review.
- Update an entry's status in place; do not duplicate it merely because its
  disposition changes.
- Assign entries stable sequential `LIT-DISC-NNN` identifiers.

Classify each entry as exactly one of: `unpredictable theorem name`, `unclear
module or import`, `insufficient documentation or indexing`, `missing useful
alias or wrapper`, `inconvenient theorem statement or assumptions`, or
`genuinely missing theorem`.

Use one of these statuses: `observed`, `proposed upstream`, `fixed upstream`, or
`intentionally unchanged`.

## Entries

No discoverability problems have been recorded yet.

## Entry template

```markdown
### LIT-DISC-NNN — <short title>

- **Observed:** <YYYY-MM-DD; PFR chunk or step>
- **Needed fact or capability:** <mathematical fact or API capability>
- **Searches tried:** informal terms <...>; Lean expressions <...>
- **Search methods:** <rg / API documentation / declaration index / theorem highlights / module guide / #check / #print / #loogle / #search / compiling probe / mathlib, as used>
- **Existing result:** <yes / partial / no>
- **Found API:** declaration <...>; module <...>; required import <...>, or `none`
- **Why difficult to discover:** <...>
- **Classification:** <one allowed classification>
- **Temporary downstream workaround:** <none or ...>
- **Possible LeanInfoTheory improvement:** <...>
- **Status:** <observed / proposed upstream / fixed upstream / intentionally unchanged>
```
