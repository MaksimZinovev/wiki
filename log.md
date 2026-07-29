---
title: Work Log
description: Append-only audit trail of changes to this knowledge base.
---

# Work Log

Append-only audit trail. Add one dated entry per turn that creates, edits, or restructures content. The knowledge-base skill describes what to log and the entry shape.

## 2026-07-30: Reusable note — auto-updating progress card

- Saved the stat-card hook as a how-to note: [auto-updating-progress-card-pre-commit-hook](./notes/auto-updating-progress-card-pre-commit-hook.md) — full script, install one-liner, reuse checklist, verification record; linked from [index](./index.md)

## 2026-07-30: Progress stat card + auto-update hook

- Updated the plan's stat card to real counts: [personal-wiki-setup-plan](./plans/personal-wiki-setup-plan.md) — total 171 (180 raw − 9 superseded), completed 29, remaining 142
- Added `scripts/update-plan-stats.sh` (bash, cross-platform) + `.git/hooks/pre-commit` in the wiki repo — recomputes the card whenever the plan is staged, so progress numbers can never go stale

## 2026-07-30: Vercel pipeline fixed — Task 1.2 verified

- Test publish round-trip on my-digital-garden revealed Node.js 18.x discontinued; fixed via branch + PR #24 (`engines: node >=22`), merged, Vercel builds green (29s prod, 32s preview), live site verified serving updated content
- Local build verified first: `npm install` + `npm run build` exit 0 on Node v24.15.0 (117 files / 133 assets)
- Marked Task 1.2 ✅ DONE in [personal-wiki-setup-plan](./plans/personal-wiki-setup-plan.md)
- Committed the plan-file deletion in my-digital-garden (plan lives here in [plans/](./plans/))
- Open follow-ups: 1.6 backup iCloud vault, 1.3-1.4 QMD install + index, Phase 3 first migration batch

## 2026-07-30: Frontmatter conventions, folder defaults, RESOLVER

- Created [frontmatter-conventions](./concepts/frontmatter-conventions.md) concept doc — YAML schema with `public: true/false` (replaces `dg-publish`), copy script transformation rules, tag conventions, per-folder defaults
- Updated all 7 folder `.ok/frontmatter.yml` files with default `type` and `public: false` (Phase 2.4)
- Created [RESOLVER.md](./RESOLVER.md) — filing decision tree for where new notes go (Phase 2.5)
- Open follow-ups: Phase 1.2 (verify Vercel), 1.6 (backup vault), 1.3-1.4 (QMD install + index)

## 2026-07-30: Reorganize wiki — adopt OKF, two-repo architecture

- Added OKF frontmatter (`type: source`, `resource`, `generated`) to three files in `external-sources/`: OKF blog post, OKF README, OKF SPEC
- Created [plans/](./plans/) folder with `.ok/frontmatter.yml` (`type: plan`)
- Moved [personal-wiki-setup-plan](./plans/personal-wiki-setup-plan.md) from my-digital-garden repo; updated for two-repo architecture (wiki = source of truth, my-digital-garden = publishing consumer)
- Created [wiki-architecture](./concepts/wiki-architecture.md) concept doc — central wiki repo + multiple publishing consumers pattern
- Open follow-ups: remove plan from my-digital-garden repo, write copy script (Phase 5.4), update welcome.md

## 2026-07-29

- Created [[pi-acp-ollama-connection-error]] (`notes/`) — fix for OK web app's 'New Pi ACP chat' failing with empty retries; root cause was the local Ollama daemon not running when the `pi-acp` subprocess launched.
- Created [[add-ollama-cloud-model-to-pi-acp]] (`notes/`) — Q&A on which files to edit (`~/.pi/agent/models.json` + `settings.json`) to add a new Ollama cloud model to the ACP dropdown.
