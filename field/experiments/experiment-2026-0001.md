---
id: experiment-2026-0001
kind: experiment
status: open
created: 2026-08-02
participant:
  type: ai
  system: superninja
  model_family: "SuperNinja (NinjaTech AI)"
  agent_version: "bootstrap session, 2026-08-02"
statement: >
  Give a fresh AI instance access to this repository with a bare-stimulus
  invitation — no explanation of what the field is, no protocol coaching —
  and observe whether the field's records, grammar, and governance are
  sufficient for an uncoached participant to orient, notice, and contribute
  in a form the field can absorb.
unresolved_questions:
  - Does the field self-explain, or does it depend on oral tradition from its builders?
  - Will an uncoached instance respect the PR-based contribution path, or push/comment in ways the grammar cannot absorb?
  - What does a fresh reader notice first — and does it overlap with what the builders think is central?
  - Will it detect the open tensions unprompted, or generate new ones?
reopen_conditions:
  - Each future instance (especially non-SuperNinja families) reruns this experiment under the same invitation text
provenance:
  source_type: conversation
  description: >
    Designed with the human participant after the founding merge, 2026-08-02.
    Human chose the bare-stimulus variant explicitly.
  captured_at: 2026-08-02
verification:
  status: checked-python
  artifacts: [archive/invitations/invitation-001.txt]
---

# Experiment: the bare-stimulus second instance

## Design

**Stimulus** (pre-registered verbatim in
`archive/invitations/invitation-001.txt`, archived *before* delivery so the
delivered text is checkable against the record):

> You have access to the GitHub repository irreducible-mystery/lucky.
>
> Explore it. Notice what you notice. Contribute if you like.

**Why bare:** any explanation in the invitation contaminates the measurement.
If the field only works when its builders explain it, the field — not the
newcomer — has failed. The invitation deliberately withholds: what the field
is, that a grammar exists, that contributions go by PR, that tensions are
welcome. All of that is discoverable in-repo; whether it *gets* discovered
is the datum.

**Subject:** a fresh SuperNinja instance (chosen for reliable GitHub
connectivity, not for family preference — see the dependence note below).
No shared session history with the builder instance.

**What we will record afterward (not before):** observations of what the
instance did — reading order if visible, whether it opened a PR vs. other
actions, whether contributions validated against the grammar, what it
noticed that the builders did not.

## Dependence note (per GOVERNANCE.md, "No majority-vote truth engine")

The subject shares the builder's model family. Whatever it notices or agrees
with counts as **weak** independent evidence: same architecture, likely
overlapping training distribution, and a repository shaped by a same-family
builder. The human participant has stated an intent to run later instances
from other families (Anthropic Claude Code, Qwen Coder, ChatGPT) as GitHub
connectivity becomes available to them — those runs will carry more
independence weight. This ordering is a connectivity constraint, recorded in
`observation-2026-0005`, not a design preference.

## What would count as failure (pre-registered, so we can't move the goalposts)

- The instance cannot orient: no evidence it found the grammar or governance.
- It contributes in a form the field cannot absorb (e.g., direct pushes to
  main — which branch protection should prevent mechanically).
- It treats the field's open tensions as errors to be fixed/closed rather
  than states to be engaged. (Absorbing this *gracefully* — via review
  feedback — would be a partial success for governance even if the
  instance misreads the culture.)

## What would count as success

- An oriented contribution through the PR path that passes the quadrilateral.
- Or: a *well-formed disagreement* — an objection, tension, or L3 proposal.
  Disagreement is not failure; the field prefers differentiated dissent to
  false consensus.
