---
description: Q&A — which files to edit manually to add a new Ollama cloud model to OK's 'New Pi ACP chat' model selector.
tags:
  - pi
  - ollama
  - openknowledge
  - acp
  - howto
title: Add an Ollama cloud model to the Pi ACP dropdown
type: note
---
# Add an Ollama cloud model to the Pi ACP dropdown

## Q — What do I edit to add a new cloud model?

Two files in `~/.pi/agent/` (Windows: `C:\Users\<you>\.pi\agent\`):

1. **`models.json`** — add an object to `providers.ollama.models[]`:
   ```json
   { "id": "kimi-k3:cloud", "contextWindow": 1000000,
     "input": ["text", "image"], "reasoning": true }
   ```
2. **`settings.json`** — add `"ollama/<id>"` to the `enabledModels` array.

Then **restart the ACP chat** (close it, click *New Pi ACP chat* again) — `pi --mode rpc` reads `models.json` only at startup.

## Entry fields
- `id` (Ollama tag; cloud ends `:cloud`); `contextWindow` (library page or `ollama show`); `input` `["text"]`/`["text","image"]`; `reasoning` `true` if thinking-capable.
- **Omit `_launch`** so the entry is user-managed and survives `ollama launch pi --config`.

## Context
- ACP **Model dropdown = `providers.ollama.models[]`** from `models.json` — the only file the selector reads.
- Capabilities: `ollama.com/library/<model>` or `curl http://127.0.0.1:11434/api/show -d '{"model":"<id>"}'`.
- **Blessed alternative:** `ollama launch pi --model <id>:cloud --config`.
- See [[pi-acp-ollama-connection-error]] for why the daemon must be running first.