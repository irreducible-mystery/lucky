/-!
# The generative field, formally (v0.1.0)

A minimal formal model of the field described in the founding design and
built in this repository. Core Lean only; no external dependencies.

The model captures four structural claims made by field records:

1. **Attribution totality** — every record carries a participant
   (`attribution_total`): by construction, unattributed records are not
   representable. Grounds the design's "no unattributed institutional truth".

2. **Append-only evolution / no silent rewriting** — field steps only add
   records; anything once in the field remains in the field
   (`field_monotone`). Grounds "no participant may silently rewrite another's
   perspective" at the structural level (interpretation happens in *new*
   records).

3. **L3 changes expressibility** (`l3_extends_expressible`) — there exist a
   schema, an extension of it, and a record ill-formed under the schema but
   well-formed under the extension. This is the formal content of the
   founding claim (claim-2026-0002) that grammar changes "change what the
   system is capable of seeing".

4. **The bootstrap is exogenous** (`f0_not_self_produced`) — the initial
   schema is not the result of any evolution step (formalizing
   assumption-2026-0003: F0 comes from outside the field's own process).

The model is deliberately small. It verifies the *shape* of the field's
self-claims, not their full content — that residue is recorded, not hidden.
-/

namespace GenerativeField

/-- Who contributed a record. Every constructor carries an identity:
    anonymity of *content* is possible (pseudonyms), but unattributed
    records are unrepresentable. -/
inductive Participant where
  | human (pseudonym : String)
  | ai (system : String) (modelFamily : String)
  | collective (name : String)
deriving Repr, DecidableEq

/-- Record kinds available under a given schema are just names here;
    the schema decides which are expressible. -/
abbrev Kind := String

/-- A record: a kind, a participant, and a statement. -/
structure Record where
  kind : Kind
  participant : Participant
  statement : String
deriving Repr, DecidableEq

/-- A schema (grammar) is the list of kinds it can express.
    `version` tracks Fn in the design's `Fn ⟶ Fn+1`. -/
structure Schema where
  version : Nat
  kinds : List Kind
deriving Repr, DecidableEq

/-- A record is well-formed under a schema iff its kind is expressible. -/
def WellFormed (s : Schema) (r : Record) : Prop :=
  r.kind ∈ s.kinds

instance (s : Schema) (r : Record) : Decidable (WellFormed s r) := by
  unfold WellFormed; infer_instance

/-- Schema extension: everything expressible before stays expressible. -/
def Extends (s' s : Schema) : Prop :=
  s.version < s'.version ∧ ∀ k, k ∈ s.kinds → k ∈ s'.kinds

/-- The state of the field: current grammar + accepted records. -/
structure Field where
  schema : Schema
  records : List Record

/-- Field evolution. L1 adds a well-formed record; L3 extends the grammar.
    (L2, relations, are records of a relation kind — subsumed by L1 here.) -/
inductive Step : Field → Field → Prop where
  | l1 (F : Field) (r : Record) (h : WellFormed F.schema r) :
      Step F ⟨F.schema, r :: F.records⟩
  | l3 (F : Field) (s' : Schema) (h : Extends s' F.schema) :
      Step F ⟨s', F.records⟩

/-- **Theorem 1 (attribution totality).**
    Every record has a participant — trivially, because the type makes
    unattributed records unrepresentable. The proof is definitional, and
    that is the point: attribution is enforced by construction, not policy. -/
theorem attribution_total (r : Record) : ∃ p : Participant, r.participant = p :=
  ⟨r.participant, rfl⟩

/-- **Theorem 2 (no silent rewriting, structural form).**
    A step never removes a record: whatever is in the field stays in the
    field. Interpretations and objections must therefore be *additions*. -/
theorem field_monotone {F F' : Field} (h : Step F F') :
    ∀ r, r ∈ F.records → r ∈ F'.records := by
  intro r hr
  cases h with
  | l1 r' _ => exact List.mem_cons_of_mem r' hr
  | l3 _ _ => exact hr

/-- The bootstrap grammar F0: the kinds actually used by the seed field. -/
def F0 : Schema :=
  ⟨0, ["perspective", "observation", "claim", "assumption",
       "relation", "tension", "limit", "dimension-proposal"]⟩

/-- A record F0 cannot express: a synthesis. The design describes syntheses,
    but the seed grammar deliberately excludes them until needed. -/
def synthesisRecord : Record :=
  ⟨"synthesis", Participant.ai "example" "example-family", "an integrative account"⟩

/-- F1: F0 extended with the synthesis kind. -/
def F1 : Schema := ⟨1, "synthesis" :: F0.kinds⟩

theorem f1_extends_f0 : Extends F1 F0 := by
  constructor
  · decide
  · intro k hk; exact List.mem_cons_of_mem _ hk

/-- **Theorem 3 (L3 changes what the field can see).**
    There exist a schema, an extending schema, and a record that is
    ill-formed under the first but well-formed under the second.
    This is claim-2026-0002 in formal dress. -/
theorem l3_extends_expressible :
    ∃ (s s' : Schema) (r : Record),
      Extends s' s ∧ ¬ WellFormed s r ∧ WellFormed s' r := by
  refine ⟨F0, F1, synthesisRecord, f1_extends_f0, ?_, ?_⟩
  · decide
  · decide

/-- **Theorem 4 (the bootstrap is exogenous).**
    No step produces a field whose schema is F0, starting from a field
    whose schema is already at version ≥ 0 — because L3 strictly increases
    version and L1 preserves it, no evolution reaches version 0 from
    anywhere except version 0 itself. F0 is a fixed origin, not a product
    of the process. This is assumption-2026-0003 in formal dress. -/
theorem f0_not_self_produced {F F' : Field} (h : Step F F')
    (h0 : F'.schema = F0) : F.schema = F0 := by
  cases h with
  | l1 _ _ => exact h0
  | l3 s' hext =>
      -- After an L3 step, F'.schema = s', so h0 : s' = F0.
      -- But Extends s' F.schema demands F.schema.version < s'.version,
      -- and F0.version = 0 — nothing is below 0.
      exfalso
      have hv : F.schema.version < s'.version := hext.1
      have hs : s' = F0 := h0
      rw [hs] at hv
      exact Nat.not_lt_zero _ hv

end GenerativeField
