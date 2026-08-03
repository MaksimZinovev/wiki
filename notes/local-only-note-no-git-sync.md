---
type: note
description: "How to keep a note local-only without git commit or GitHub sync; tradeoffs and the only reliable option."
created: 2026-08-03
author: pi
tags: [ note, open-knowledge, git ]
title: Can I make a note local-only in OpenKnowledge — no git commit, no GitHub sync?
---

## Note

### Question

How can I keep a note in my OpenKnowledge project local only — managed by OK (search, backlinks, lint) but never committed to git or pushed to GitHub? I tried using `.gitignore` with a pattern like `*.local.md` and re-including it via `.okignore` negation.

### Answer

**Short answer: you can't have both.** OK has no per-note "don't sync" flag. The reason is that OK's versioning and its GitHub sync are the **same pipeline** — think of it like a conveyor belt: anything OK manages goes on the belt, and the belt delivers everything to GitHub. You can't put something on the belt and tell it to stop halfway.

The `.gitignore` + `.okignore` negation trick (`!*.local.md`) **seems** like it should work — git ignores the file, but OK re-includes it. This works at the ContentFilter level: `.gitignore` and `.okignore` patterns are loaded into the **same** `ignore` instance, so a `!` in `.okignore` re-admits a gitignored file into the corpus (search, backlinks, lint all see it). However, OK's sync engine commits and pushes the **entire content corpus** via `gatherContentFilesSync()` — it does not re-check `.gitignore` at sync time. So a re-included file gets pushed to GitHub like everything else. Your repo confirms sync is live right now (auto-save commits every few minutes, pushed to `origin/main`). See [OK Sync Engine — .gitignore vs .okignore Behavior](../references/ok-sync-engine-gitignore-behavior.md) for the source verification.

Your options:

1. **`.okignore` the note** — local-only, no sync, but OK stops managing it (no search/backlinks). Like keeping a file in a drawer instead of on the shelf.
2. **Disable sync project-wide** — then the negation trick works, but it kills sync for *all* notes, not just one.
3. **Work on a local branch that never pushes** — keeps the note in OK, but manual and fragile.

Option 1 is the only reliable one for a single local-only note while the rest of your KB keeps syncing.

## Links

- [Wiki Architecture](../concepts/wiki-architecture.md) — describes the publishing pipeline and `dg-publish: true` frontmatter flag for keeping notes private from the digital garden consumer (a related but separate mechanism)
- [Index](../index.md) — navigation hub for this knowledge base
- [RESOLVER](../RESOLVER.md) — filing decision tree: where new notes go and what frontmatter they need
