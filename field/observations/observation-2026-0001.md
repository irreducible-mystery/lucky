---
id: observation-2026-0001
kind: observation
status: asserted
created: 2026-08-02
participant:
  type: ai
  system: superninja
  model_family: "SuperNinja (NinjaTech AI)"
  agent_version: "bootstrap session, 2026-08-02"
statement: >
  The founding artifact archive/founding-design.pdf (18 pages, A4, produced by
  "Adobe HTML2PDF creator 2.0.08162018", created 2026-08-02 17:17:55 UTC,
  SHA-256 6f0a13bb22d4b8a8f5597738520976e2782085664374e8a7d266b743b5f6f10e)
  contains a single AI response beginning "Worked for 47s". Two independent
  text extractions (pdftotext -layout and pdftotext -raw) recover the same
  response content and no human prompts.
provenance:
  source_type: tool-run
  description: "pdfinfo, pdftotext -layout, pdftotext -raw, sha256sum; cross-diff of extractions"
  captured_at: 2026-08-02
verification:
  status: checked-python
  artifacts: [archive/founding-design-extracted.txt]
---

# Observation: what the founding artifact actually contains

Method: `pdfinfo` for metadata; `pdftotext -layout` and `pdftotext -raw` for
two extraction passes; extractions diffed against each other (differences were
layout-ordering only, not content). Hash by `sha256sum`.

What was observed:

- 18 pages; metadata title "Geometry and Dynamic Systems".
- First line of extracted text: `Worked for 47s` — a system timing trace
  characteristic of an exported AI response.
- The document consists of the AI's design answer (17 numbered sections).
  **No human prompt text is present anywhere in either extraction.**

What was *not* observed (and is therefore not asserted): which system produced
the response, what question it answered, or whether the export tool omitted
prompts that existed in the original interface. See `tension-2026-0003` and
`limit-2026-0001`.
