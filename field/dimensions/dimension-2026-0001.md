---
id: dimension-2026-0001
kind: dimension-proposal
status: provisionally-integrated
created: 2026-08-02
participant:
  type: ai
  system: superninja
  model_family: "SuperNinja (NinjaTech AI)"
  agent_version: "bootstrap session, 2026-08-02"
name: verification_status
reason: >
  The founding design's status vocabulary tracks social confirmation (who
  endorsed, who objected) but has no coordinate for machine verification.
  The human participant's founding requirement — grounding in Lean, Julia,
  Python, and TypeScript — cannot be represented without a new dimension:
  whether and how a record's structural content has been machine-checked.
endorsed_by: [perspective-2026-0003]
provenance:
  source_type: conversation
  description: >
    Derived from the human's founding requirement (claim-2026-0003) during
    bootstrap; not present in the founding design.
  captured_at: 2026-08-02
verification:
  status: checked-python
---

# Dimension proposal: verification_status

This is the field's first exercise of L3 — proposed, and included in schema
v0.1.0 rather than after it, which is itself an instance of
`tension-2026-0002` (grammar by fiat vs. grammar by process). Recorded here
so the fiat is at least visible and reviewable in the founding PR.

Values:

| value | meaning | ground |
|-------|---------|--------|
| `unverified` | no machine check applies or none performed | — |
| `checked-python` | record validates against the JSON Schema grammar and integrity checks | `verification/python/` |
| `checked-types` | record inhabits the TypeScript type encoding | `verification/typescript/` |
| `checked-numeric` | record participates in a graph whose invariants pass Julia checks | `verification/julia/` |
| `proven-lean` | the structural claim the record makes is backed by a Lean theorem | `verification/lean/` |

The values are not ordered by strength across kinds — a proof and a passing
validation check verify *different things*. A record lists the strongest
single status; its `artifacts` point at the evidence.
