---
title: Work Log
description: Append-only audit trail of changes to this knowledge base.
---

# Work Log

Append-only audit trail. Add one dated entry per turn that creates, edits, or restructures content. The knowledge-base skill describes what to log and the entry shape.

## 2026-07-30: Reorganize wiki — adopt OKF, two-repo architecture

- Added OKF frontmatter (`type: source`, `resource`, `generated`) to three files in `external-sources/`: OKF blog post, OKF README, OKF SPEC
- Created [plans/](./plans/) folder with `.ok/frontmatter.yml` (`type: plan`)
- Moved [personal-wiki-setup-plan](./plans/personal-wiki-setup-plan.md) from my-digital-garden repo; updated for two-repo architecture (wiki = source of truth, my-digital-garden = publishing consumer)
- Created [wiki-architecture](./concepts/wiki-architecture.md) concept doc — central wiki repo + multiple publishing consumers pattern
- Open follow-ups: remove plan from my-digital-garden repo, write copy script (Phase 5.4), update welcome.md

## 2026-07-29

- Created [[pi-acp-ollama-connection-error]] (`notes/`) — fix for OK web app's 'New Pi ACP chat' failing with empty retries; root cause was the local Ollama daemon not running when the `pi-acp` subprocess launched.
- Created [[add-ollama-cloud-model-to-pi-acp]] (`notes/`) — Q&A on which files to edit (`~/.pi/agent/models.json` + `settings.json`) to add a new Ollama cloud model to the ACP dropdown.
