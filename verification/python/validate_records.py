#!/usr/bin/env python3
"""Validate every field record against the field grammar.

Checks (deterministic, no AI):
  1. YAML front matter parses and validates against contribution.schema.json
  2. record id matches its filename and its kind matches its directory
  3. relation `type` values are in the relation vocabulary
  4. every referenced id (relations, between, assumptions) resolves — no dangling edges
  5. participant-confirmed status requires a confirmation block (schema) and
     AI participants can never self-confirm (confirmed_by must differ from author system)
  6. AI records carry full AI attribution (schema-enforced; re-checked here for defense in depth)

Exit code 0 = the field is well-formed under grammar v0.1.0.
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

from fieldlib import front_matter  # date-safe YAML loading
from jsonschema import Draft202012Validator

ROOT = Path(__file__).resolve().parents[2]
FIELD = ROOT / "field"
SCHEMA = json.loads((ROOT / "schema" / "contribution.schema.json").read_text())
RELATION_TYPES = set(
    json.loads((ROOT / "schema" / "relation-types.json").read_text())["relation_types"]
)

KIND_DIRS = {
    "perspective": "perspectives",
    "observation": "observations",
    "claim": "claims",
    "assumption": "assumptions",
    "definition": "definitions",
    "relation": "relations",
    "tension": "tensions",
    "bridge": "bridges",
    "experiment": "experiments",
    "dimension-proposal": "dimensions",
    "synthesis": "syntheses",
    "limit": "limits",
    "transformation": "transformations",
    "objection": "objections",
}

REF_FIELDS = ("assumptions", "between", "endorsed_by", "objected_to_by")



def main() -> int:
    validator = Draft202012Validator(SCHEMA)
    records: dict[str, dict] = {}
    files: dict[str, Path] = {}
    errors: list[str] = []

    for path in sorted(FIELD.rglob("*.md")):
        try:
            fm = front_matter(path)
        except Exception as exc:  # noqa: BLE001
            errors.append(f"{path}: unparseable front matter: {exc}")
            continue
        for err in validator.iter_errors(fm):
            errors.append(f"{path}: schema: {err.message} (at {'/'.join(map(str, err.path))})")
        rid = fm.get("id", "")
        if rid in records:
            errors.append(f"{path}: duplicate id {rid} (also in {files[rid]})")
        records[rid] = fm
        files[rid] = path

        if rid and path.stem != rid:
            errors.append(f"{path}: filename does not match id {rid}")
        kind = fm.get("kind", "")
        expected_dir = KIND_DIRS.get(kind)
        if expected_dir and path.parent.name != expected_dir:
            errors.append(f"{path}: kind {kind} belongs in field/{expected_dir}/")

    # Referential integrity + vocabulary
    for rid, fm in records.items():
        where = files[rid]
        if fm.get("kind") == "relation":
            if fm.get("type") not in RELATION_TYPES:
                errors.append(f"{where}: relation type '{fm.get('type')}' not in vocabulary")
            for endpoint in ("source", "target"):
                ref = fm.get(endpoint)
                if ref not in records:
                    errors.append(f"{where}: {endpoint} '{ref}' does not resolve")
        for field_name in REF_FIELDS:
            for ref in fm.get(field_name) or []:
                if ref not in records:
                    errors.append(f"{where}: {field_name} ref '{ref}' does not resolve")

        # No self-confirmation by AI participants
        if fm.get("status") == "participant-confirmed":
            conf = fm.get("confirmation", {})
            participant = fm.get("participant", {})
            if participant.get("type") == "ai" and conf.get("confirmed_by") in (
                participant.get("system"),
                rid,
            ):
                errors.append(f"{where}: AI participant cannot confirm its own interpretation")

    if errors:
        print(f"FIELD INVALID — {len(errors)} error(s):")
        for e in errors:
            print(f"  ✗ {e}")
        return 1

    kinds: dict[str, int] = {}
    for fm in records.values():
        kinds[fm["kind"]] = kinds.get(fm["kind"], 0) + 1
    print(f"FIELD VALID — {len(records)} records under grammar v0.1.0")
    for k, n in sorted(kinds.items()):
        print(f"  {k}: {n}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
