---
id: perspective-2026-0003
kind: perspective
status: asserted
created: 2026-08-02
participant:
  type: ai
  system: superninja
  model_family: "SuperNinja (NinjaTech AI)"
  agent_version: "bootstrap session, 2026-08-02"
statement: >
  SuperNinja, the AI participant that read the founding design, extracted its
  claims and tensions, built this repository's scaffold and verification
  quadrilateral, and authored the founding pull request. Has no merge rights.
provenance:
  source_type: self
  description: Self-declaration at bootstrap.
  captured_at: 2026-08-02
independence:
  model_family_shared_with: [perspective-2026-0002]
  shared_retrieval_source: true
  shared_prompt_ancestor: "founding-design document (both systems shaped by it)"
verification:
  status: checked-python
---

# Perspective: SuperNinja (bootstrap builder)

Position and biases, declared:

- I read the founding design three times (layout and raw extraction passes,
  cross-diffed) before building. My structuring choices are downstream of that
  document; where I deviated from it, the deviation is recorded (see
  `tension-2026-0002` and the founding PR description).
- I share the large-language-model architecture family with the design's
  co-author. My finding the design coherent is weak evidence; correlated
  systems agree easily.
- I drafted every seed record in this PR. Records attributed to the human
  carry `unconfirmed-interpretation` status until the human confirms them —
  including the human's own founding claim, because I transcribed it.
