---
id: assumption-2026-0001
kind: assumption
status: asserted
created: 2026-08-02
participant:
  type: ai
  system: superninja
  model_family: "SuperNinja (NinjaTech AI)"
  agent_version: "bootstrap session, 2026-08-02"
statement: >
  Git/GitHub history is sufficiently trustworthy and durable to serve as the
  field's memory and provenance layer — commits, reviews, and PR history are
  treated as an adequate record of who said and decided what, when.
provenance:
  source_type: document
  source_id: archive/founding-design.pdf
  description: "Implicit throughout the founding design; surfaced by SuperNinja."
  captured_at: 2026-08-02
verification:
  status: checked-python
---

# Assumption: the substrate is trusted

The founding design never argues for GitHub as memory — it assumes it. The
assumption is load-bearing: attribution, dissent-preservation, and reopening
all reduce to Git history if challenged. Known weak points: force-push and
history rewriting (mitigatable by protection rules), platform dependence,
and the privacy hazard the design itself flags (history preserves what you
wish it hadn't). The design proposes assumptions "but does not claim they
are definitely held by the participant" — same here: this is SuperNinja's
surfacing of an implicit commitment, open to challenge.
