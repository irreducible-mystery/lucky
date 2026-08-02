/**
 * The field grammar v0.1.0, encoded in the TypeScript type system.
 *
 * This is a second, independent implementation of schema/contribution.schema.json.
 * Records are emitted as literals (records.generated.ts) and must typecheck.
 * Discriminated unions enforce the conditional requirements:
 *   - relations require type/source/target
 *   - tensions require tension_type/between
 *   - AI participants require system/model_family/agent_version
 *   - participant-confirmed status requires a confirmation block
 *
 * Changing this file is an L3 change (GOVERNANCE.md).
 */

export type RecordKindPrefix =
  | "perspective" | "observation" | "claim" | "assumption" | "definition"
  | "relation" | "tension" | "bridge" | "experiment" | "dimension"
  | "synthesis" | "limit" | "transformation" | "objection";

export type RecordId = `${RecordKindPrefix}-${string}`;
// Note: TS template-literal types cannot enforce the digit pattern
// (`${number}` rejects zero-padded "0001"), so the type enforces only
// "known prefix + dash + something". Full pattern enforcement lives in the
// JSON Schema layer. This is a known, recorded difference in what the two
// grammars can see — each verifier has its own blind spots.

export type RelationType =
  | "supports" | "challenges" | "contradicts_under" | "compatible_under"
  | "complements" | "overlaps" | "contains" | "depends_on" | "caused_by"
  | "correlated_with" | "translates_to" | "partially_translates_to"
  | "loses_information_when_translated_to" | "applies_at_different_scale"
  | "applies_at_different_time" | "transforms_into"
  | "provides_counterexample_to" | "shares_assumption_with"
  | "requires_dimension" | "unresolved_with";

export type TensionType =
  | "logical-contradiction" | "equivocation" | "scale-mismatch"
  | "temporal-mismatch" | "ontological-mismatch" | "measurement-disagreement"
  | "false-dichotomy" | "self-reference" | "undecidability"
  | "uncomputability" | "irreducible-value-conflict" | "artifact-loss"
  | "bootstrap-paradox";

export type Status =
  | "draft" | "asserted" | "participant-confirmed"
  | "unconfirmed-interpretation" | "interpretation-rejected" | "contested"
  | "open" | "provisionally-integrated" | "superseded";

export interface HumanParticipant {
  type: "human";
  attribution: "named" | "pseudonymous" | "abstracted";
  pseudonym?: string;
  github_handle?: string;
}

export interface AiParticipant {
  type: "ai";
  system: string;
  model_family: string;
  agent_version: string;
  prompt_version?: string;
}

export interface CollectiveParticipant {
  type: "collective";
  pseudonym?: string;
  attribution?: "named" | "pseudonymous" | "abstracted";
}

export type Participant = HumanParticipant | AiParticipant | CollectiveParticipant;

export interface Provenance {
  source_type:
    | "conversation" | "github-discussion" | "github-issue"
    | "github-pull-request" | "document" | "extraction" | "tool-run" | "self";
  captured_at: string;
  source_id?: string;
  description?: string;
}

export interface Confirmation {
  confirmed_by: string;
  confirmed_at: string;
  via: string;
}

export interface Verification {
  status: "unverified" | "checked-python" | "checked-types" | "checked-numeric" | "proven-lean";
  artifacts?: string[];
}

interface BaseRecord {
  id: RecordId;
  created: string;
  participant: Participant;
  statement?: string;
  context?: {
    scale?: string[];
    temporal_scope?: string;
    ontology?: string[];
  };
  assumptions?: RecordId[];
  distinctions?: string[];
  unresolved_questions?: string[];
  reopen_conditions?: string[];
  endorsed_by?: RecordId[];
  objected_to_by?: RecordId[];
  provenance?: Provenance;
  ai_assistance?: {
    used: boolean;
    agents?: string[];
    participant_confirmed_interpretation?: boolean;
  };
  independence?: {
    model_family_shared_with?: RecordId[];
    shared_retrieval_source?: boolean;
    shared_prompt_ancestor?: string;
  };
  verification?: Verification;
}

/** status=participant-confirmed demands a confirmation block. */
type WithConfirmation =
  | { status: Exclude<Status, "participant-confirmed">; confirmation?: Confirmation }
  | { status: "participant-confirmed"; confirmation: Confirmation };

export type RelationRecord = BaseRecord & WithConfirmation & {
  kind: "relation";
  type: RelationType;
  source: RecordId;
  target: RecordId;
  conditions?: Record<string, unknown>;
};

export type TensionRecord = BaseRecord & WithConfirmation & {
  kind: "tension";
  tension_type: TensionType;
  between: RecordId[];
};

export type DimensionProposalRecord = BaseRecord & WithConfirmation & {
  kind: "dimension-proposal";
  name: string;
  reason: string;
};

export type PlainRecord = BaseRecord & WithConfirmation & {
  kind:
    | "perspective" | "observation" | "claim" | "assumption" | "definition"
    | "bridge" | "experiment" | "synthesis" | "limit" | "transformation"
    | "objection";
};

export type FieldRecord =
  | RelationRecord
  | TensionRecord
  | DimensionProposalRecord
  | PlainRecord;
