---
description: OK web app's 'New Pi ACP chat' returns empty retries because the pi-acp subprocess can't reach the local Ollama daemon. Start Ollama first.
tags:
  - pi
  - ollama
  - openknowledge
  - acp
  - troubleshooting
title: Pi ACP chat fails until Ollama is running
type: note
---
# Pi ACP chat fails until Ollama is running

## Symptom
In the OpenKnowledge web app, **New Pi ACP chat** loads skills/extensions and reports `MCP: 2 servers connected (42 tools)`, but every reply is empty followed by `Retrying (attempt 1/3, waiting 2s)…` three times, then `Retry finished, resuming.` No model output. Interactive `pi` in the same project works fine.

## Root cause
The ACP chat runs Pi through a third-party adapter, `pi-acp` (OK launches `npx pi-acp@0.0.32`), which spawns `pi --mode rpc --no-themes`. Pi loads the `ollama` provider (`glm-5.2:cloud`) but the HTTP call to `http://127.0.0.1:11434/v1` fails with **`Connection error.`** and zero tokens — the local Ollama daemon wasn't running when ACP started. Pi retries 3× and gives up; `pi-acp` forwards the retry lines as chat text.

Confirmed in Pi's session log: `~/.pi/agent/sessions/<project>/<ts>_<id>.jsonl` shows each assistant turn as `"content":[],"stopReason":"error","errorMessage":"Connection error.","usage":{"totalTokens":0}`.

## Fix that worked
1. In a terminal **inside the project folder**, start a regular `pi` session (this guarantees Ollama is up and the cloud model is warm).
2. Open / focus the OpenKnowledge web app.
3. Click **New Pi ACP chat**.
4. Pi replies successfully.

## Why it works
Cloud models (`glm-5.2:cloud`) are proxied through the **local Ollama daemon** — the daemon must be running for both local and cloud requests. The interactive `pi` session forces Ollama up before ACP launches, so the `pi-acp` subprocess finds a live `127.0.0.1:11434`.

## Pre-flight check (any time ACP acts up)
```bash
curl -s -m 5 http://127.0.0.1:11434/api/tags -o /dev/null -w "HTTP %{http_code}\n"
```
`HTTP 200` = Ollama up. Otherwise start it (`ollama serve` or launch the Ollama app) and retry. Set Ollama to **Run on startup** so the daemon is always available.

## Researched insights
- **`pi-acp` is not Pi's native ACP mode** — it's a community adapter (`svkozak/pi-acp`, `0.0.x`) bridging Pi's NDJSON RPC protocol to ACP. Early version; if streaming/tool-output oddness appears later, look here first.
- **Pi ↔ Ollama uses the OpenAI-compat shim** (`api: openai-completions`, `baseUrl: …/v1`) configured by `ollama launch pi` in `~/.pi/agent/models.json`. Streaming emits reasoning in a `reasoning` field (not OpenAI's `reasoning_content`) — benign here, but a known interop seam.
- **`glm-5.2` thinking levels:** the `pi-ollama-cloud` map exposes only `off`, `high`, `xhigh` (no `medium`). ACP defaults thinking to `medium`; it worked once connected, but if a model 400s on `reasoning_effort`, switch the ACP **Thinking** selector to `off`.
- **Diagnose via** `~/.pi/agent/sessions/` (Pi-side) and `.ok/local/threads/` (OK-side ACP log).