# The verification quadrilateral

Four languages, four kinds of rigor, one field. Each verifier implements the
grammar independently; divergence between them is a finding, not a nuisance.

| Corner | What it checks | How to run |
|--------|----------------|------------|
| **Python** (`python/`) | Records validate against the JSON Schema grammar; ids match files; relation types are in vocabulary; every reference resolves; no AI self-confirmation. Also builds `generated/` projections. | `python verification/python/validate_records.py`<br>`python verification/python/build_graph.py` |
| **TypeScript** (`typescript/`) | Records, emitted as literals, must *inhabit* the grammar encoded as discriminated-union types. The TS compiler is a second implementation of the schema. | `python verification/python/emit_typescript_records.py`<br>`cd verification/typescript && npm install && npx tsc --noEmit` |
| **Julia** (`julia/`) | Invariants over the built graph: referential closure, `depends_on` acyclicity, tension polarity, attribution totality; orphan and participant-balance reports. | `julia verification/julia/graph_invariants.jl` |
| **Lean 4** (`lean/`) | Formal model of the field: attribution totality by construction, append-only monotonicity ("no silent rewriting"), `l3_extends_expressible` (grammar change enlarges what is expressible — claim-2026-0002), `f0_not_self_produced` (the bootstrap grammar is exogenous — assumption-2026-0003). | `cd verification/lean && lake build` |

## What the quadrilateral does *not* verify

Machine checks establish that the field is **well-formed**, not that it is
**true or faithful**. Whether a record preserved a participant's meaning is
checkable only by that participant. Whether an interpretation is fair is a
human review question. The verifiers guard the grammar; the participants
guard the meaning. Conflating those two would be the quiet failure mode of
this whole approach — see `field/tensions/tension-2026-0002.md`.

## Known blind-spot differences between verifiers

- JSON Schema enforces the full id pattern (`kind-YYYY-NNNN`); TypeScript can
  only enforce "known prefix + string" (template-literal types reject
  zero-padded numbers under `${number}`). Recorded in `typescript/schema.ts`.
- YAML transport coerces unquoted dates to date objects; the grammar wants
  strings. The Python loader disables timestamp resolution
  (`python/fieldlib.py`) — a divergence *discovered by the Python corner
  failing* at bootstrap, kept as an example of the quadrilateral working.
- The Lean model verifies structural shape, not record content: it proves
  properties of the *kind* of system this is, over an idealized model.
  The bridge from model to repository is informal and should be treated as
  a standing invitation to tighten it.
