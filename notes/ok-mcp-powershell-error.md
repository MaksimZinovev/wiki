---
title: OK MCP "spawn powershell ENOENT" — stale in-memory config
type: note
description: "Why Pi's open-knowledge MCP failed with spawn powershell ENOENT on macOS, and the fix."
created: 2026-08-08
author: Maksim Zinovev
tags: [note, mcp, debugging]
---

## Symptom

`mcp({ connect: "open-knowledge" })` fails on macOS with `spawn powershell ENOENT`.

## Root cause

1. Repo synced from Windows; committed `.codex/config.toml` + `.cursor/mcp.json` set `command = "powershell"`.
2. Pi loads its MCP registry **once at startup**; this session started before `ok init` rewrote disk to `/bin/sh`.
3. Live session keeps the **stale in-memory** `powershell` definition; disk is now `/bin/sh`.
4. MCP SDK's `cross-spawn` spawns that stale command → `ENOENT` (no powershell on macOS).
5. `ok init` fixes disk but can't reload the running session; `/mcp reconnect` reuses the stale definition.

## Evidence

- `loadMcpConfig()` (run via bun) → `command: "/bin/sh"` (disk correct now).
- `git show HEAD:.codex/config.toml` → `command = "powershell"` (Windows version still committed).
- Error `${syscall} ${command} ENOENT` (from `cross-spawn/lib/enoent.js`) proves the spawned command was literally `powershell`.

## Fix & Resolution

1. Restart Pi → reloads `/bin/sh` → connects.
2. Commit corrected `.mcp.json`, `.codex/config.toml`, `.cursor/mcp.json` to stop the Windows version syncing.

**Verified:** Problem solved after applying the fix and restarting the Pi coding agent.

## Links
- [OpenKnowledge tooling index](../ok-index.md) — central hub for OK tooling notes
- [Pi ACP chat fails until Ollama is running](./pi-acp-ollama-connection-error.md) — related Pi/MCP connection debugging
