---
description: YAML frontmatter schema for wiki repo notes — OKF fields plus the `public` flag for publishing control. The copy script transforms YAML to JSON for the my-digital-garden consumer.
generated:
  at: 2026-07-30
  by: human:maksi
status: stable
tags:
  - frontmatter
  - okf
  - conventions
  - publishing
title: Frontmatter Conventions
type: concept
---
# Frontmatter Conventions

The wiki repo uses **YAML frontmatter** (OKF convention). Every non-reserved document carries a non-empty `type` — that is the only OKF requirement. The conventions below layer project-specific fields on top.

## Schema

```yaml
---
# === OKF required ===
type: note                    # REQUIRED — note | concept | reference | source | research | article | plan | guide

# === OKF recommended ===
title: "Note Title"           # Display name; if omitted, derived from filename
description: "One-line summary" # Used by index.md generators, search, and previews
tags: [tag-one, tag-two]      # lowercase, hyphenated

# === OKF optional (provenance, trust, lifecycle) ===
generated:                    # Who produced this and when
  by: human:maksi
  at: 2026-07-30
status: stable                # draft | stable | deprecated (absent = stable)
sources:                      # For research/article docs citing external-sources/
  - id: source-id
    resource: ./external-sources/source-file.md
    title: "Source Title"

# === Project-specific (publishing) ===
public: false                 # true = copy script includes in publishing sync; false/absent = private
permalink: /topic/note-name/  # Optional URL path for publishing; if absent, copy script generates from file path
---
```

## The `public` field

Replaces the Digital Garden plugin's `"dg-publish": true` JSON convention. In the wiki repo, notes use the universal YAML field `public: true` or `public: false`. Notes are **private by default** — `public` is absent or `false` unless explicitly set to `true`.

### Why `public` instead of `dg-publish`

- **Vendor-neutral** — not tied to the Digital Garden Obsidian plugin
- **Self-explanatory** — `public: true` is immediately readable by any human or agent
- **OKF-portable** — any OKF consumer understands a boolean field; `dg-publish` is opaque outside the Digital Garden ecosystem

## Copy script transformation (wiki YAML → my-digital-garden JSON)

The sync script (`sync-wiki-to-garden.ps1`) transforms frontmatter when copying to the publishing consumer:

| Wiki (YAML) | → | my-digital-garden (JSON) | Notes |
|-------------|---|---------------------------|-------|
| `public: true` | → | `"dg-publish":true` | Filter: only `public: true` notes are copied |
| `public: false` (or absent) | → | (not copied) | Private notes stay in wiki |
| `permalink: /path/` | → | `"permalink":"/path/"` | If absent, generated from file path |
| `tags: [a, b]` | → | `"tags":["a","b"]` | Direct conversion |
| `title: "Title"` | → | (not included) | 11ty derives title from filename |
| `type: note` | → | (stripped) | OKF-only field, not needed by 11ty |
| `generated: {...}` | → | (stripped) | OKF provenance, not needed by 11ty |
| `status: stable` | → | (stripped) | OKF lifecycle, not needed by 11ty |

## Tag conventions

- **Lowercase, hyphenated**: `knowledge-management`, not `Knowledge Management` or `KM`
- **Topic-based**: `pkm`, `ai-agents`, `testing`, `git`
- **Consistent**: pick one form per concept and stick with it (no `ai` + `AI` + `artificial-intelligence` mixing)

## Per-folder defaults

Each folder's `.ok/frontmatter.yml` sets a default `type` and `public: false`:

| Folder | Default `type` | Default `public` | Default `status` |
|--------|---------------|-------------------|-------------------|
| `concepts/` | `concept` | `false` | — |
| `references/` | `reference` | `false` | — |
| `notes/` | `note` | `false` | — |
| `external-sources/` | `source` | `false` | — |
| `research/` | `research` | `false` | `provisional` |
| `articles/` | `article` | `false` | `canonical` |
| `plans/` | `plan` | `false` | — |

## Example: a publishable note

Wiki repo (YAML):

```yaml
---
type: note
title: "Karpathy LLM Wiki"
description: "Notes on Karpathy's LLM-wiki gist — the pattern OKF formalizes."
tags: [knowledge-management, llm-wiki, okf]
public: true
permalink: /resources/pkm/karpathy-llm-wiki/
generated:
  by: human:maksi
  at: 2026-07-30
status: stable
---
```

Copy script transforms to my-digital-garden (JSON):

```json
---
{"dg-publish":true,"permalink":"/resources/pkm/karpathy-llm-wiki/","tags":["knowledge-management","llm-wiki","okf"]}
---
```

## See also

- [OKF Specification](../external-sources/SPEC.md) — the format these conventions conform to
- [Wiki Architecture](./wiki-architecture.md) — the two-repo architecture and copy script
- [Filing Decision Tree](../RESOLVER.md) — where new notes go
