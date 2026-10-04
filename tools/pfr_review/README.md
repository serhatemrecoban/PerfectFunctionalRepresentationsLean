# PFR supervised review tooling

Start with [operating instructions](../../docs/review-operations.md) and the
[canonical protocol](../../docs/review-protocol.md). Python validates and records
the local workflow; the implementation agent performs actual native tool calls.

- `cli.py`: explicit command entry points; no scheduler or transport.
- `project.py`: separate, owned `.pfr-review/` storage, chunk binding, actual plan
  contracts and supervised step/plan-review transitions.
- `project_source.py`: read-only Git, working-byte, dependency and B/R/F capture.
- `core/`: retained state machine, evidence contracts and guarded fixture harness.
- `tests/`: model-free source-copy and command checks; never PFR acceptance.

The core was installed from the project's adjusted Integration-02 plus the
delivery/format corrections under `tmp/ra-dl-01/`. Its diagnostic source before
the small policy-hook refactor had SHA-256
`adb9c81e107162b49d531b95515f3b5eb811de6bcc79cc908d436b05014a0dcb`.
The preserved completed diagnostic archive has SHA-256
`34aed4cfe449380b9cb285f7db5ddbc4adff92130f813f08e621170c86c6032f`.
These are this private project's earlier prototypes, not a new external library.
Default fixture path/provenance guards remain in place; only the separate project
adapter opts into real source reads and approved private record writes.

## Validation commands

After installation, from the repository root:

```text
python -B tools/pfr_review/tests/run_tests.py
```

This runner allows the reviewed tests to create isolated temporary Git source
copies. It records source fingerprints and results in
`.pfr-review/setup/project-tests/`. No model is called, and this is not OS isolation
or a real desktop queue test. Tests may make synthetic commits only inside their
temporary repositories; they do not commit the PFR checkout.

From `tools/pfr_review/core/`, the complete inherited selection plus delivery and
policy-hook regressions is these three commands (independent shards may overlap):

```text
python -B tests/run_tests.py test_workflow test_regressions test_remediation independent_probes.IndependentReviewProbes
python -B tests/run_tests.py reassessment_probes.ReassessmentProbes test_remediation02.Remediation02Tests remediation02_boundary_probes.Remediation02BoundaryProbes test_remediation03.Remediation03Tests remediation03_reassessment_probes.Remediation03ReassessmentProbes test_remediation04.Remediation04Tests
python -B tests/run_tests.py test_integration.IntegrationTests integration01_reassessment_probes.Integration01ReassessmentProbes test_integration02.Integration02Tests test_delivery.DeliveryTests test_policy_hooks.PolicyHookTests
```

The inherited runner refuses subprocess/network operations and writes outside its
bundle; this cooperative audit hook is not a security sandbox. Generated fixture
stores and test evidence are ignored, not production records. A Windows symlink
test can be skipped when the process lacks symlink privilege; report the skip,
not a Windows pass. No machine settings are changed to force it.

Core operation names containing `FIXTURE` or `DIAGNOSTIC` are historical labels.
Inspect record tags, input modes, binding and explicit subject/closure scope;
neither a fixture result nor plan review authorizes mathematical execution.

The 2026-09-20 finding-ID repair adds one explicitly authorized project operation,
`reconcile_report_identity`, for distinct optional claims that accidentally reuse
a closed resolved finding's ID. It preserves original reports and earlier
closures, retains reviewer clarification and an exact source-bound mapping, and
reconciles the original report before normal disposition/finalization. Its
source-copy regressions are in `tests/test_finding_identity.py`; see the
[operating contract](../../docs/review-operations.md#explicit-finding-id-correction).
It adds no scheduler, replacement reviewer, general conflict adjudicator or
automatic continuation.
