#!/usr/bin/env python3
"""Build generated/ projections from field records.

Outputs:
  generated/graph.json               — nodes + typed edges (the atlas source)
  generated/unresolved-tensions.md   — every open tension with its questions
  generated/assumption-map.md        — which claims depend on which assumptions

These are projections, never canonical. Anything here can be regenerated
from field/ and must never be hand-edited.
"""
from __future__ import annotations

import json
from datetime import date
from pathlib import Path

from fieldlib import front_matter  # date-safe YAML loading

ROOT = Path(__file__).resolve().parents[2]
FIELD = ROOT / "field"
GENERATED = ROOT / "generated"



def main() -> None:
    GENERATED.mkdir(exist_ok=True)
    records = {fm["id"]: fm for fm in (front_matter(p) for p in sorted(FIELD.rglob("*.md")))}

    nodes = []
    edges = []
    for rid, fm in records.items():
        if fm["kind"] == "relation":
            edges.append(
                {
                    "id": rid,
                    "type": fm["type"],
                    "source": fm["source"],
                    "target": fm["target"],
                    "status": fm["status"],
                }
            )
        else:
            nodes.append(
                {
                    "id": rid,
                    "kind": fm["kind"],
                    "status": fm["status"],
                    "participant_type": fm["participant"]["type"],
                    "verification": (fm.get("verification") or {}).get("status", "unverified"),
                }
            )
        # implicit structural edges
        for a in fm.get("assumptions") or []:
            edges.append({"id": f"{rid}::assumes::{a}", "type": "depends_on",
                          "source": rid, "target": a, "status": "implicit"})
        for b in fm.get("between") or []:
            edges.append({"id": f"{rid}::between::{b}", "type": "unresolved_with",
                          "source": rid, "target": b, "status": "implicit"})

    graph = {
        "generated_at": date.today().isoformat(),
        "canonical": False,
        "note": "Projection of field/. Regenerate; never edit.",
        "nodes": nodes,
        "edges": edges,
    }
    (GENERATED / "graph.json").write_text(json.dumps(graph, indent=2) + "\n")

    # Unresolved tensions report
    lines = ["# Unresolved tensions", "",
             "*Generated projection — not canonical. Closure here is workflow, not resolution.*", ""]
    for rid, fm in sorted(records.items()):
        if fm["kind"] == "tension" and fm["status"] == "open":
            lines.append(f"## {rid} — `{fm['tension_type']}`")
            lines.append("")
            lines.append(fm.get("statement", "").strip())
            lines.append("")
            for q in fm.get("unresolved_questions") or []:
                lines.append(f"- ❓ {q}")
            for c in fm.get("reopen_conditions") or []:
                lines.append(f"- 🔓 reopens/advances on: {c}")
            lines.append("")
    (GENERATED / "unresolved-tensions.md").write_text("\n".join(lines))

    # Assumption map
    lines = ["# Assumption map", "",
             "*Generated projection — which records stand on which assumptions.*", ""]
    for rid, fm in sorted(records.items()):
        if fm["kind"] == "assumption":
            dependents = [r for r, g in records.items()
                          if rid in (g.get("assumptions") or [])]
            dependents += [g["source"] for g in records.values()
                           if g["kind"] == "relation" and g.get("type") == "depends_on"
                           and g.get("target") == rid]
            lines.append(f"## {rid}")
            lines.append("")
            lines.append(fm.get("statement", "").strip())
            lines.append("")
            for d in sorted(set(dependents)):
                lines.append(f"- depended on by `{d}`")
            lines.append("")
    (GENERATED / "assumption-map.md").write_text("\n".join(lines))

    print(f"graph.json: {len(nodes)} nodes, {len(edges)} edges")
    print("reports: unresolved-tensions.md, assumption-map.md")


if __name__ == "__main__":
    main()
