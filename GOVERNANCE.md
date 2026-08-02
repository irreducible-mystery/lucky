# Governance

`main` represents the **current accepted field**, not final truth.

## Change classes

| Level | What changes | Review required |
|-------|-------------|-----------------|
| **L1** | New records (observations, claims, assumptions, tensions, limits) | 1 human review + validation checks |
| **L2** | New relations and interpretations between records | 1 human review + validation checks |
| **L3** | Changes to the field's grammar: `schema/`, relation vocabulary, governance docs, verification code | 1 human review + validation checks + explicit acknowledgment in the PR that this is an L3 change and what it makes visible/invisible |

L3 changes deserve the most scrutiny because they change what the field is
capable of seeing.

## Merge authority

- Every change to `field/`, `schema/`, or governance arrives by pull request.
- Validation checks (Python, and where configured TypeScript/Julia/Lean) must pass.
- **At least one human reviewer** approves every merge.
- **AI participants have no merge rights.** They may open branches, PRs, and
  comments; they may never merge, bypass rulesets, or administer the repository.

> **Enforcement status:** these rules are currently policy, not mechanism —
> branch protection is unavailable on this plan/visibility combination.
> See `field/limits/limit-2026-0002.md` for the exact constraint and its
> reopen conditions. Direct pushes to `main` are detectable in history and
> constitute a governance violation even though the platform permits them.

## What approval means

Approval of a PR means only:

> This is an adequately represented, traceable, revisable addition to the
> shared field.

It does **not** mean "everyone agrees this is true."

## Dissent and reopening

- Objections are recorded as records linked to what they object to — never
  buried in closed threads.
- Nothing is permanently settled. Any record may specify `reopen_conditions`,
  and any later contribution may reopen a synthesis or reveal a distinction
  as inadequate.
- Closure of an issue or merge of a PR is **workflow state, not epistemic
  resolution**.

## No majority-vote truth engine

Voting may prioritize what to investigate. It does not establish truth.
Multiple AI agents agreeing may reflect one shared architecture, training
distribution, or prompt lineage. Correlated agreement is not independent
confirmation; AI contributions should declare dependence where known.

## Current participants (bootstrap phase)

- One human participant (pseudonym `you`) — sole merge authority.
- AI participants as declared in `field/perspectives/`.

This section is expected to change as participants join; changing it is an
L3 change.
