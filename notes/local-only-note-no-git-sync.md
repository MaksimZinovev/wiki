---
type: note
description: "How to keep a note local-only without git commit or GitHub sync; tradeoffs and the only reliable option."
created: 2026-08-03
author: pi
tags: [ note, open-knowledge, git ]
title: Can I make a note local-only in OpenKnowledge — no git commit, no GitHub sync?
---

## Note

**Can I keep a note in my OpenKnowledge project local only — managed by OK (search, backlinks, lint) but never committed to git or pushed to GitHub?**

**Short answer: you can't have both.** OK has no per-note "don't sync" flag. The reason is that OK's versioning and its GitHub sync are the **same pipeline** — think of it like a conveyor belt: anything OK manages goes on the belt, and the belt delivers everything to GitHub. You can't put something on the belt and tell it to stop halfway.

The `.gitignore` + `.okignore` negation trick (`!*.local.md`) **seems** like it should work — git ignores the file, but OK re-includes it. However, OK's sync engine commits and pushes the **entire content corpus**; it doesn't re-check `.gitignore` at sync time. So a re-included file gets pushed to GitHub like everything else. Your repo confirms sync is live right now (auto-save commits every few minutes, pushed to `origin/main`).

Your options:

1. **`.okignore` the note** — local-only, no sync, but OK stops managing it (no search/backlinks). Like keeping a file in a drawer instead of on the shelf.
2. **Disable sync project-wide** — then the negation trick works, but it kills sync for *all* notes, not just one.
3. **Work on a local branch that never pushes** — keeps the note in OK, but manual and fragile.

Option 1 is the only reliable one for a single local-only note while the rest of your KB keeps syncing.

## Links
