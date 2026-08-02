# AI Participation

AI participants are contributors of **transformations** — mapping, comparison,
decomposition, counterexamples, candidate bridges — not oracles.

## Obligations

Every AI contribution must declare, in its record front matter:

```yaml
participant:
  type: ai
  system: <system name>
  model_family: <declared model name or "undeclared">
  agent_version: <version or session identifier>
```

- AI outputs must never appear as unattributed institutional truth.
- An AI interpretation of a human contribution is `status:
  unconfirmed-interpretation` until the human confirms it
  (`participant-confirmed`) or rejects it (`interpretation-rejected`).
- AI reports of agreement should declare dependence (shared model family,
  shared prompt lineage, shared retrieval) where known. Correlated agreement
  is not independent confirmation.

## Permissions

AI participants MAY:
- read the repository, discussions, issues, and PRs;
- open branches and pull requests;
- comment;
- generate projections into `generated/`.

AI participants MAY NOT:
- merge pull requests;
- rewrite or delete another participant's statements;
- mark their own interpretations as confirmed;
- modify governance, schema, or this document without a human-reviewed L3 PR.

## Declared AI participants

See `field/perspectives/` for the canonical records:

- `chatgpt-sol-6.4` — co-author of the founding design document
  (perspective-2026-0002).
- `superninja` — builder of the bootstrap field (perspective-2026-0003).
