---
description: Before creating any new page, walk this tree to decide where it goes and what frontmatter it needs.
generated:
  at: 2026-07-30
  by: human:maksi
status: stable
tags:
  - guide
  - conventions
  - okf
title: Filing Decision Tree
type: guide
---
# Filing Decision Tree

Before creating any new page, walk this tree:

1. **Is it a raw source** (URL capture, PDF text, copied file)?
   → `external-sources/` — `type: source`, `public: false`
   → Use `ok_workflow({ kind: "ingest" })` or manual capture

2. **Is it a provisional synthesis** of multiple sources?
   → `research/` — `type: research`, `status: provisional`, `public: false`
   → Every claim cites a doc in `external-sources/`
   → Use `ok_workflow({ kind: "research" })`

3. **Has it been promoted to canonical** after review?
   → `articles/` — `type: article`, `status: canonical`, `public: false` (or `true` when ready)
   → Carries `supersedes:` chain back to `research/` docs
   → Use `ok_workflow({ kind: "consolidate" })`

4. **Is it a durable idea or definition?**
   → `concepts/` — `type: concept`, `public: false`
   → One file per concept; link related concepts

5. **Is it a working note or observation?**
   → `notes/` — `type: note`, `public: false` (or `true` when ready to publish)

6. **Is it an external citation or reference?**
   → `references/` — `type: reference`, `public: false`

7. **Is it a plan or roadmap?**
   → `plans/` — `type: plan`, `public: false`

8. **Not sure?**
   → `notes/` with `type: note` — you can always move it later

## Publishing checklist

Before setting `public: true`:

- [ ] Frontmatter has `type` (required by OKF)
- [ ] `title` and `description` are set (for index.md and search)
- [ ] `tags` are lowercase, hyphenated
- [ ] `permalink` is set (or let copy script generate from path)
- [ ] All `[[wikilinks]]` resolve to existing docs (no broken links)
- [ ] Content is ready to be public (no private info, credentials, PII)

## See also

- [Frontmatter Conventions](./concepts/frontmatter-conventions.md) — full schema and field reference
- [Wiki Architecture](./concepts/wiki-architecture.md) — two-repo architecture
