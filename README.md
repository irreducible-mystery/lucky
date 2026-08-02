# lucky — a generative field

This repository is a **versioned epistemic commons**: a structured, attributed,
revisable field of observations, claims, assumptions, tensions, and relations,
built jointly by human and AI participants.

**The field's first subject is itself.** The founding design document
(archived in [`archive/`](archive/)) proposed a system for collective inquiry;
the first records in this field are that document's own claims, its own
assumptions, its own tensions, and its own provenance gaps — recorded honestly
rather than repaired silently.

The field is **topic-agnostic** in subject matter but **grounded in
verification**. Every structural claim about the field should ultimately be
checkable in at least one of four languages:

| Language   | Kind of rigor                                        |
|------------|------------------------------------------------------|
| Lean 4     | Formal proof — the field grammar and its invariants  |
| Julia      | Numerical & graph analysis — invariants over the built graph |
| Python     | Record validation, integrity checks, graph generation |
| TypeScript | Type-level encoding of the schema — records must inhabit the types |

See [`verification/`](verification/).

## Structure

```
field/          canonical records (Markdown + YAML front matter)
  perspectives/   who is observing, and from where
  observations/   what a participant reports perceiving
  claims/         propositions asserted or inferred
  assumptions/    what must hold for a claim to follow
  tensions/       contradictions, mismatches, obstructions
  relations/      typed edges between records
  limits/         undecidable / unavailable / untranslated regions
  dimensions/     proposals to change the field's own coordinates
schema/         the machine-readable grammar (JSON Schema + relation vocabulary)
verification/   the four-language verification quadrilateral
generated/      projections built from the field (graph, reports) — never canonical
archive/        founding artifacts with provenance
```

## Core commitments

1. **Attribution, always.** No output — human or AI — appears as unattributed
   institutional truth.
2. **No silent rewriting.** A participant's statement is never overwritten by
   another participant's interpretation.
3. **Dissent is a first-class object.** Merging means "adequately represented,
   traceable, revisable" — never "everyone agrees this is true."
4. **The grammar can change (L3).** Records (L1) and relations (L2) evolve
   freely under review; changes to the field's own grammar require the most
   scrutiny, because they change what the field can see.
5. **Generated views are projections.** `generated/` is rebuilt from records;
   it is never the source of truth.

## Governance

- [`GOVERNANCE.md`](GOVERNANCE.md) — merge authority, review, L1/L2/L3 change classes
- [`PARTICIPANT-RIGHTS.md`](PARTICIPANT-RIGHTS.md) — attribution, rejection of interpretations, privacy
- [`AI-PARTICIPATION.md`](AI-PARTICIPATION.md) — what AI participants may and may not do

## Provenance of this field

Co-created beginning 2026-08-02 by a human participant (pseudonym **"you"**)
and AI participants: **ChatGPT Sol 6.4 (ExtraHigh)**, which co-authored the
founding design, and **SuperNinja**, which built this bootstrap. The full
provenance — including what could *not* be recovered — is recorded in
`field/` as observations, limits, and tensions. Start with
[`field/tensions/tension-2026-0001.md`](field/tensions/tension-2026-0001.md).
