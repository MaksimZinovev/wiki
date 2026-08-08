---
title: OpenKnowledge tooling index
description: Central hub for notes about running OpenKnowledge itself — MCP, ACP, sync, and tooling debugging.
type: index
tags:
  - index
  - open-knowledge
  - tooling
---

# OpenKnowledge tooling index

Central hub for knowledge about **running OpenKnowledge itself** (setup, MCP, ACP, sync, debugging) — distinct from the [content knowledge base](./index.md).

## Debugging & troubleshooting

- [OK MCP "spawn powershell ENOENT"](./notes/ok-mcp-powershell-error.md) — stale in-memory MCP config after a Windows→macOS repo sync
- [Pi ACP chat fails until Ollama is running](./notes/pi-acp-ollama-connection-error.md) — empty retries until the local Ollama daemon is up

## How-to & setup

- [Add an Ollama cloud model to the Pi ACP dropdown](./notes/add-ollama-cloud-model-to-pi-acp.md) — which files to edit for the model selector
- [Local-only note (no git sync)](./notes/local-only-note-no-git-sync.md) — keep a note managed by OK but excluded from git/GitHub
- [Auto-updating progress card via pre-commit hook](./notes/auto-updating-progress-card-pre-commit-hook.md) — stat card that recomputes plan progress on every commit

## Conventions & references

- [RESOLVER](./RESOLVER.md) — filing decision tree for new pages
- [OK sync engine gitignore behavior](./references/ok-sync-engine-gitignore-behavior.md) — how OK's ContentFilter and sync handle .gitignore/.okignore
- [Welcome](./welcome.md) — what this knowledge base is and how it's organized

## Links

- [Index](./index.md) — main navigation hub for the content knowledge base
