---
id: assumption-2026-0002
kind: assumption
status: asserted
created: 2026-08-02
participant:
  type: ai
  system: superninja
  model_family: "SuperNinja (NinjaTech AI)"
  agent_version: "bootstrap session, 2026-08-02"
statement: >
  Meaning survives structuring: a participant's contribution can be carried
  into typed records (YAML front matter, schema'd kinds, typed relations)
  without losing what mattered about it — provided the original language is
  preserved alongside and confirmation is sought.
provenance:
  source_type: document
  source_id: archive/founding-design.pdf
  description: "Implicit in sections 2–4 of the founding design; surfaced by SuperNinja."
  captured_at: 2026-08-02
verification:
  status: checked-python
---

# Assumption: structuring preserves (enough) meaning

The whole record architecture depends on this. The design hedges it well —
original language preserved in the body, Reflector asks "did this preserve
your meaning?", bridges must declare what they lose. But the hedges are
mitigations, not proof. If this assumption fails badly, the field is a
well-governed archive of distortions. The strongest available test is the
one this PR performs: structure a document and let its author community
check the residue.
