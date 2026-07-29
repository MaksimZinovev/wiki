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
- `id` — the Ollama model tag, cloud models end in `:cloud` (e.g. `kimi-k3:cloud`).
- `contextWindow` — from the model's Ollama library page or `ollama show`.
- `input` — `["text"]`, or `["text","image"]` if the model has vision.
- `reasoning` — `true` if the model supports thinking.
- `_launch` — optional. Set `true` and `ollama launch pi` may manage/replace it; **omit it** to mark the entry user-managed so it survives `ollama launch pi --config` re-runs.

## Context
- The ACP **Model dropdown lists exactly `providers.ollama.models[]`** from `models.json` — that's the only file the selector reads.
- Discover capabilities from `https://ollama.com/library/<model>` (tags: `vision tools thinking cloud`) or `curl http://127.0.0.1:11434/api/show -d '{"model":"<id>"}'`.
- **Blessed alternative:** `ollama launch pi --model <id>:cloud --config` writes the entry for you with capability detection.
- See [[pi-acp-ollama-connection-error]] for why the daemon must be running first.