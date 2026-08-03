---
type: reference
description: "How OK's ContentFilter and GitHub Sync Engine handle .gitignore/.okignore — verified via DeepWiki against inkeep/open-knowledge source."
created: 2026-08-03
author: pi
tags: [ reference, open-knowledge, sync, git ]
source_url: https://github.com/inkeep/open-knowledge
title: OpenKnowledge Sync Engine — .gitignore vs .okignore Behavior
---

## Summary

Verification of how OpenKnowledge's ContentFilter and GitHub Sync Engine treat `.gitignore` and `.okignore` — specifically whether a note can be managed by OK (search, backlinks, lint) while excluded from git commits and GitHub sync. Analyzed via [DeepWiki](https://deepwiki.com/inkeep/open-knowledge) against the `inkeep/open-knowledge` repository source code.

## Key points

1. **ContentFilter loads `.gitignore` and `.okignore` into the same `ignore` instance.** A `!` negation pattern in `.okignore` can re-include a file that `.gitignore` excluded. Source: `packages/server/src/content-filter.ts` — `buildPatternState` iterates `IGNORE_FILE_NAMES` (both `.gitignore` and `.okignore`) and adds patterns to the same `newIg` instance. Confirmed by a test case in the repo.

2. **The GitHub Sync Engine pushes the entire content corpus.** During a push cycle, `doPushCycle` calls `gatherContentFilesSync()` to collect all files that pass the ContentFilter, stages them into an isolated git index, and commits+pushes. It does **not** re-check `.gitignore` independently at sync time — the ContentFilter is the single gate.

3. **Consequence:** A file re-included into the corpus via `.okignore` negation (overriding `.gitignore`) **will** be synced to GitHub if sync is active. There is no per-note sync exemption.

## Where this is used

- [Can I make a note local-only in OpenKnowledge?](../notes/local-only-note-no-git-sync.md) — Q&A note citing this reference for the sync-engine behavior claims
