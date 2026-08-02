"""Shared record loading for the Python verification layer.

YAML 1.1 eagerly coerces unquoted ISO dates (2026-08-02) into date objects.
The field grammar defines dates as *strings* (format: date), so we load YAML
with date coercion disabled: what the participant wrote is what the record
holds. This choice was itself discovered by a validation failure at bootstrap
— the first time the Python layer caught a divergence between transport
(YAML) and grammar (JSON Schema). See the founding PR description.
"""
from __future__ import annotations

from pathlib import Path

import yaml


class FieldLoader(yaml.SafeLoader):
    """SafeLoader with implicit timestamp resolution disabled."""


# Remove the implicit resolver for tag:yaml.org,2002:timestamp so dates stay strings.
for ch, resolvers in list(FieldLoader.yaml_implicit_resolvers.items()):
    FieldLoader.yaml_implicit_resolvers[ch] = [
        (tag, regexp) for tag, regexp in resolvers
        if tag != "tag:yaml.org,2002:timestamp"
    ]


def front_matter(path: Path) -> dict:
    text = path.read_text()
    if not text.startswith("---"):
        raise ValueError(f"{path}: no YAML front matter")
    _, fm, *_ = text.split("---", 2)
    return yaml.load(fm, Loader=FieldLoader)
