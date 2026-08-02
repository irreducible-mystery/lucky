---
id: assumption-2026-0003
kind: assumption
status: asserted
created: 2026-08-02
participant:
  type: ai
  system: superninja
  model_family: "SuperNinja (NinjaTech AI)"
  agent_version: "bootstrap session, 2026-08-02"
statement: >
  A grammar must already exist before the field can propose changes to its
  grammar: L3 generativity presupposes an initial schema (F0) that was not
  itself produced by the field's own review process.
provenance:
  source_type: document
  source_id: archive/founding-design.pdf
  description: "Surfaced by SuperNinja from section 16 (Fn ⟶ Fn+1)."
  captured_at: 2026-08-02
verification:
  status: proven-lean
  artifacts: [verification/lean/GenerativeField/Basic.lean]
---

# Assumption: the bootstrap grammar is exogenous

The design writes `Fn ⟶ Fn+1` — but F0 comes from nowhere inside the system.
This PR *is* F0: schema v0.1.0 was authored by two AI systems and one human
outside any field process, because no field process existed yet. That is not
a flaw to hide; it is a bootstrap fact to record (see `tension-2026-0002`).
In the Lean development, F0 is literally the initial schema constant from
which the evolution relation starts.
