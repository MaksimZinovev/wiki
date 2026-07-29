---
title: Work Log
description: Append-only audit trail of changes to this knowledge base.
---

# Work Log

Append-only audit trail. Add one dated entry per turn that creates, edits, or restructures content. The knowledge-base skill describes what to log and the entry shape.

## 2026-07-29

- Created [[pi-acp-ollama-connection-error]] (`notes/`) — fix for OK web app's 'New Pi ACP chat' failing with empty retries; root cause was the local Ollama daemon not running when the `pi-acp` subprocess launched.
- Created [[add-ollama-cloud-model-to-pi-acp]] (`notes/`) — Q&A on which files to edit (`~/.pi/agent/models.json` + `settings.json`) to add a new Ollama cloud model to the ACP dropdown.
