# Personal Wiki Setup — Phased Plan

> 8-week plan for a complete system: OpenKnowledge (main engine) + QMD (search) + Pi agent (AI tasks) + Vercel/GH Pages (publishing). Relaxed pace, 2-4 hrs/week. Each task is 15-60 min.

---

## Current State

- **iCloud Obsidian vault**: 1,686 .md files, git repo, many Obsidian plugins
- **my-digital-garden repo**: `https://github.com/MaksimZinovev/my-digital-garden.git` — 11ty-based, deployed to Vercel at `https://my-digital-garden-rouge.vercel.app/`
- **OpenKnowledge**: Already installed (desktop app)
- **Pi agent**: This AI coding agent (file ops, bash, MCP, web search)
- **Obsidian plugins installed**: linter, auto-link-title, auto-note-mover, dataview, metadata-menu, templater, brat (beta plugin installer)

## Target State

- OpenKnowledge manages the my-digital-garden repo (public notes)
- QMD indexes the entire iCloud vault for local search (1,686 files)
- Pi agent helps with migration, enrichment, lint, auto-tag/link
- Notes published via Vercel site (existing) or Quartz (later)
- `"dg-publish": true` in JSON frontmatter controls public/private split (Digital Garden plugin convention)
- Automations: daily maintenance (Task Scheduler), weekly lint (Pi session)
- Published site has: search, graph view, tags, categories, backlinks

## Key Decisions

- **Repo**: Use existing `my-digital-garden` repo, migrate gradually from iCloud vault
- **Publishing**: Keep existing Vercel site working from day 1; evaluate Quartz later
- **Public/private**: `"dg-publish": true` in JSON frontmatter (existing Digital Garden convention — NOT `publish: true` in YAML)
- **Frontmatter format**: JSON-style (existing convention) — e.g. `{"dg-publish":true,"permalink":"/topic/note-name/","tags":["tag1","tag2"]}`
- **QMD scope**: Index entire iCloud vault (all 1,686 files)
- **AI agent**: Pi (not Claude Code)

## Repo Audit (Task 1.1 — completed)

- **112 notes** in `src/site/notes/` across 15 topic folders (git, playwright, cypress, javascript, etc.)
- All notes use JSON frontmatter with `"dg-publish":true`, `permalink`, `tags`
- Images stored in `src/site/img/user/{topic}/attachments/`
- 11ty (Eleventy) static site, deployed to Vercel
- Last commit: Jan 6, 2024 — 1,002 total commits
- Notes use Obsidian-style wikilinks (`[[path/note|display]]`) — 11ty template converts to HTML

---

## Phase 1: Foundation — Repos & Tools (Week 1)

> Goal: Clone the garden repo, configure OpenKnowledge, install QMD, verify Vercel site works.

### 1.1 Clone my-digital-garden repo ✅ DONE
- [x] Clone `https://github.com/MaksimZinovev/my-digital-garden.git` to `C:\Users\maksi\repos\my-digital-garden`
- [x] Verify the repo structure — found `src/site/notes/` (112 notes), `.eleventy.js`, `vercel.json`, `src/helpers/`, `src/site/`
- [x] Check which notes are already published — all 112 notes have `"dg-publish":true` in JSON frontmatter (Digital Garden plugin convention, NOT `publish: true`)
- [x] Run `git log --oneline -20` — 1,002 commits, last commit Jan 6 2024

### 1.2 Verify Vercel site works (10 min)
- [ ] Visit `https://my-digital-garden-rouge.vercel.app/` — confirm it loads
- [ ] Check what notes are currently visible on the site
- [ ] Make a small test edit to a published note, push to GitHub, verify it appears on Vercel

### 1.3 Install QMD (30 min)
- [ ] Install Node.js 22+ if not already installed (`node --version`)
- [ ] Run `npm install -g @tobilu/qmd`
- [ ] Verify: `qmd --version`
- [ ] Run `qmd doctor` to check system requirements

### 1.4 Index the iCloud vault with QMD (30 min)
- [ ] Add collection: `qmd collection add "C:\Users\maksi\iCloudDrive\iCloud~md~obsidian\obsidian-sync" --name vault`
- [ ] Add context: `qmd context add qmd://vault "My full Obsidian knowledge base — all notes, private and public"`
- [ ] Index: `qmd update`
- [ ] Embed: `qmd embed` (this downloads ~2GB of local models on first run, takes 10-20 min)
- [ ] Test search: `qmd query "karpathy wiki knowledge management"`
- [ ] Test search: `qmd search "open brain"`
- [ ] Record stats: `qmd status`

### 1.5 Configure OpenKnowledge for the garden repo (30 min)
- [ ] Open OpenKnowledge desktop app
- [ ] Open the `C:\Users\maksi\repos\my-digital-garden` folder as the knowledge base
- [ ] **Important**: OK manages the repo root, but content lives in `src/site/notes/`. When OK creates folders (external-sources, research, articles), they should go inside `src/site/notes/`, not repo root. Check if OK supports custom content paths.
- [ ] Initialize the Knowledge base starter pack (`ok seed --pack knowledge-base`) — verify where it creates folders
- [ ] If OK creates folders at repo root: move them to `src/site/notes/` and update OK config
- [ ] Verify `.ok/frontmatter.yml` created (at repo root for OK, or per-folder inside `src/site/notes/`)
- [ ] Verify OK MCP server is running (check if Pi can see `mcp__open-knowledge__*` tools)

### 1.6 Back up the iCloud vault (15 min)
- [ ] Create a tagged backup: `cd "C:\Users\maksi\iCloudDrive\iCloud~md~obsidian\obsidian-sync" && git tag backup-pre-migration-$(date +%Y%m%d)`
- [ ] Push tag: `git push origin backup-pre-migration-*`
- [ ] Verify the tag exists: `git tag -l "backup-*"`

---

## Phase 2: Structure & Schema (Week 2)

> Goal: Define folder structure, frontmatter conventions, templates, and filing rules for the garden repo.

### 2.1 Audit existing garden repo structure ✅ DONE (during Task 1.1)
- [x] List all folders and files — 112 notes in `src/site/notes/` across 15 topic folders
- [x] Check what 11ty expects — `src/site/` is input dir, `src/site/notes/` is where notes live, link resolver reads from `./src/site/notes/`
- [x] All 112 notes already have `"dg-publish":true` in JSON frontmatter
- [x] Decision: keep existing `src/site/notes/` structure, add OK content folders inside it

### 2.2 Define folder structure for the garden repo (30 min)
- [ ] **Critical constraint**: 11ty reads from `src/site/` as input dir. The link resolver hardcodes `./src/site/notes/` as the note root. All publishable content MUST be inside `src/site/notes/`.
- [ ] Map out the target directory structure:
  ```
  my-digital-garden/
  ├── .ok/                     → OK configuration (repo root, not published)
  │   └── frontmatter.yml      → per-folder frontmatter rules
  ├── plans/                   → this plan (not published)
  ├── log.md                   → OK audit trail (repo root, not published)
  ├── src/
  │   └── site/
  │       ├── notes/            → ALL published content lives here
  │       │   ├── git/           → existing topic
  │       │   ├── playwright-*/  → existing topics
  │       │   ├── cypress-*/     → existing topics
  │       │   ├── javascript/   → existing topic
  │       │   ├── resources/     → NEW: migrated from iCloud
  │       │   │   ├── pkm/       → knowledge management
  │       │   │   ├── ai/        → AI research
  │       │   │   └── ...
  │       │   ├── external-sources/  → NEW: OK ingest output
  │       │   ├── research/      → NEW: OK research output
  │       │   └── articles/     → NEW: OK consolidate output
  │       ├── img/              → images (existing)
  │       ├── scripts/          → client-side JS (existing)
  │       └── styles/           → CSS (existing)
  ├── .eleventy.js             → 11ty config (existing)
  ├── .eleventyignore           → excludes netlify/functions (existing)
  ├── .env                     → site config vars (existing)
  ├── vercel.json              → Vercel deploy config (existing)
  └── package.json             → 11ty + deps (existing)
  ```
- [ ] Create new folders: `src/site/notes/resources/`, `src/site/notes/resources/pkm/`, `src/site/notes/external-sources/`, `src/site/notes/research/`, `src/site/notes/articles/`
- [ ] Document the structure in a `README.md` at repo root

### 2.3 Define frontmatter conventions (20 min)
- [ ] Create a frontmatter template for all notes — use JSON format (existing convention):
  ```json
  ---
  {"dg-publish":false,"permalink":"/topic/note-name/","tags":["tag1","tag2"],"type":"reference","date":"2025-01-15","source":"article"}
  ---
  ```
  - `dg-publish`: false by default, set to true when ready to publish
  - `permalink`: `/topic/note-name/` for clean URLs on Vercel
  - `tags`: lowercase, hyphenated (e.g. `knowledge-management`, `ai-agents`)
  - `type`: reference | idea | insight | summary | source | article
  - `date`: YYYY-MM-DD
  - `source`: youtube-transcript | article | book | conversation | original
  - Note: OK also reads YAML frontmatter — may need to reconcile two formats or configure OK to read JSON
- [ ] Save as `_templates/note-template.md` in the garden repo
- [ ] Configure OpenKnowledge templates per folder (`.ok/templates/*.md`)
- [ ] Investigate: can OK read JSON frontmatter, or does it require YAML? (check OK docs)

### 2.4 Create folder frontmatter for OK (20 min)
- [ ] **Note**: OK `.ok/frontmatter.yml` goes at repo root. OK content folders live inside `src/site/notes/`. Verify OK can read frontmatter rules from repo root while managing content in `src/site/notes/`.
- [ ] Write `.ok/frontmatter.yml` for `src/site/notes/external-sources/`:
  ```yaml
  description: "Raw sources saved verbatim — URLs, PDFs, transcripts. Immutable. Produced by ingest."
  ```
- [ ] Write `.ok/frontmatter.yml` for `src/site/notes/research/`:
  ```yaml
  description: "Provisional synthesis of sources. Every claim cites a source path. Status: provisional."
  ```
- [ ] Write `.ok/frontmatter.yml` for `src/site/notes/articles/`:
  ```yaml
  description: "Canonical articles. Promoted from research via consolidate. Status: canonical."
  ```
- [ ] Write `.ok/frontmatter.yml` for `src/site/notes/resources/`:
  ```yaml
  description: "Curated resource notes — organized by topic. These are the main knowledge base articles."
  ```
- [ ] Investigate: does OK support per-subfolder frontmatter rules (e.g. `src/site/notes/resources/pkm/` vs `src/site/notes/resources/ai/`)?

### 2.5 Create RESOLVER.md — filing decision tree (30 min)
- [ ] Write `RESOLVER.md` at garden repo root:
  ```markdown
  # Filing Decision Tree
  
  Before creating any new page, walk this tree:
  
  1. Is it a raw source (URL, PDF, transcript)? → external-sources/
  2. Is it a synthesis of multiple sources? → research/ (provisional)
  3. Has it been promoted to canonical after review? → articles/
  4. Is it a curated knowledge note by topic? → resources/{topic}/
  5. Is it a general note or scratch? → notes/
  6. Not sure? → notes/inbox/
  ```
- [ ] Commit to git

### 2.6 Install Semantic Auto-Linker Obsidian plugin (15 min)
- [ ] In Obsidian: Settings → Community Plugins → Browse → search "Semantic Auto-Linker"
- [ ] Install and enable
- [ ] Configure: set provider to "Local model (built-in)" or Ollama
- [ ] Run "Build semantic embeddings" on the iCloud vault
- [ ] Test: open a note, run "Analyze current note for safe links", review suggestions

---

## Phase 3: First Migration Batch (Week 3)

> Goal: Migrate the first 20-50 notes from iCloud vault to the garden repo, enriched with frontmatter and wikilinks.

### 3.1 Select first batch of notes to migrate (15 min)
- [ ] Start with `resources/pkm/` — we already have well-organized PKM notes there
- [ ] List all .md files in `resources/pkm/`: 
  ```
  find "C:\Users\maksi\iCloudDrive\iCloud~md~obsidian\obsidian-sync\resources\pkm" -name "*.md"
  ```
- [ ] Pick 20 notes that are most complete and useful
- [ ] Create a migration checklist file: `C:\Users\maksi\repos\my-digital-garden\migration-tracker.md`

### 3.2 Migrate first 5 notes — manual enrichment (1 hr)
- [ ] For each note (do 5 at a time):
  1. Copy from iCloud vault to `resources/pkm/` in the garden repo
  2. Open in OpenKnowledge or text editor
  3. Add/fix frontmatter — JSON format: `{"dg-publish":false,"permalink":"/resources/pkm/note-name/","tags":[...],"type":"...","date":"...","source":"..."}`
  4. Add `[[wikilinks]]` to related notes that exist in the garden repo
  5. Fix any broken image paths (copy images to `attachments/`)
  6. Commit with message: `migrate: [note name] from iCloud vault`
- [ ] Push to GitHub
- [ ] Verify notes DON'T appear on Vercel (publish: false)

### 3.3 Migrate next 15 notes — Pi-assisted enrichment (1 hr)
- [ ] In a Pi session, ask:
  ```
  Read the following 15 notes from the iCloud vault and for each one:
  1. Suggest appropriate frontmatter (title, type, tags, date, source)
  2. Suggest [[wikilinks]] to other notes in the garden repo
  3. Note any quality issues (missing content, broken links, duplicates)
  
  Notes to process:
  [list of file paths]
  ```
- [ ] Review Pi's suggestions
- [ ] Apply frontmatter and links manually
- [ ] Copy notes to garden repo, commit, push

### 3.4 Set first notes to dg-publish: true (15 min)
- [ ] Pick 5-10 of the best migrated notes
- [ ] Set `"dg-publish":true` in frontmatter (add `permalink` field too)
- [ ] Commit and push
- [ ] Verify they appear on `https://my-digital-garden-rouge.vercel.app/`
- [ ] Check the graph view, tags, and backlinks on the published site

### 3.5 QMD re-index after migration (10 min)
- [ ] `qmd update` (picks up new files)
- [ ] `qmd embed --stale` (embeds new notes)
- [ ] Test: `qmd query "karpathy wiki open brain"` — should return the migrated notes

---

## Phase 4: Auto-Link, Auto-Tag & First Lint (Week 4)

> Goal: Use Semantic Auto-Linker for missing connections, bulk-tag notes, run first full vault lint.

### 4.1 Run Semantic Auto-Linker on migrated notes (30 min)
- [ ] In Obsidian (iCloud vault), run "Analyze whole vault for safe links"
- [ ] Review suggestions — focus on the 20-50 migrated notes
- [ ] Accept high-confidence links (exact title matches)
- [ ] Review and accept semantic matches for notes in the garden repo
- [ ] Sync accepted links to the garden repo (copy updated files)

### 4.2 Bulk tag audit with Pi (45 min)
- [ ] In a Pi session, ask:
  ```
  Read all .md files in C:\Users\maksi\repos\my-digital-garden\resources\
  For each file:
  1. Check if frontmatter has tags
  2. If missing, suggest 2-5 tags based on content
  3. Check for tag inconsistencies (e.g., "ai" vs "AI" vs "artificial-intelligence")
  4. Suggest a normalized tag list
  
  Report as a table: filename | current tags | suggested tags | issues
  ```
- [ ] Review and apply tag fixes
- [ ] Define a tag convention (lowercase, hyphenated: `knowledge-management`, `ai-agents`, etc.)

### 4.3 First full vault lint (45 min)
- [ ] In a Pi session, paste the vault-lint prompt:
  ```
  Run a vault lint on C:\Users\maksi\repos\my-digital-garden.
  Do all 8 checks:
  1. Broken wikilinks
  2. Orphan pages
  3. Contradictions
  4. Stale claims
  5. Missing pages (wikilinks to non-existent files)
  6. Missing cross-refs
  7. Index consistency
  8. Data gaps
  
  Also: tag audit, dedup scan.
  Report grouped by severity. Log to log.md.
  ```
- [ ] Review findings
- [ ] Fix any errors (broken links, missing pages)
- [ ] Document warnings for later

### 4.4 Install TagItAll plugin (optional, 20 min)
- [ ] In Obsidian: Settings → Community Plugins → Browse → search "TagItAll"
- [ ] Install and enable
- [ ] Configure: set provider to Ollama (local, free) or leave as manual
- [ ] Run on a few test notes to see tag suggestions
- [ ] If useful, bulk-tag remaining untagged notes in the iCloud vault

### 4.5 Evaluate OK workflow tools (30 min)
- [ ] In a Pi session (with OK MCP connected), test:
  - `workflow({ kind: "ingest" })` on a URL — does it write to external-sources/?
  - `workflow({ kind: "research" })` on a topic — does it write to research/?
  - `links` tool — does it find orphans and dead links?
  - `search` tool — can Pi search the garden repo?
- [ ] Document what works and what needs configuration

---

## Phase 5: Publishing Pipeline (Week 5)

> Goal: Ensure the publishing pipeline works end-to-end. Evaluate Quartz vs keeping Digital Garden + Vercel.

### 5.1 Audit existing Vercel site (20 min)
- [ ] Visit `https://my-digital-garden-rouge.vercel.app/`
- [ ] Check: graph view, search, tags, backlinks — what works?
- [ ] Check: which notes are currently published?
- [ ] Note any issues (broken links, missing content, styling)
- [ ] Check the Digital Garden Obsidian plugin — is it installed? If not, install it:
  - In Obsidian: Settings → Community Plugins → Browse → search "Digital Garden"
  - Configure: set GitHub repo to `MaksimZinovev/my-digital-garden`
  - Set GitHub token in plugin settings

### 5.2 Test publish flow with OK (30 min)
- [ ] Create a test note in OK: `resources/pkm/test-publish.md` with `"dg-publish":true`
- [ ] Push to GitHub
- [ ] Wait for Vercel rebuild (check Vercel dashboard or wait 2-3 min)
- [ ] Verify the test note appears on the site
- [ ] Delete the test note, push, verify it disappears

### 5.3 Evaluate Quartz (30 min)
- [ ] Read Quartz features: https://quartz.jzhao.xyz/
- [ ] Compare with current Digital Garden + Vercel setup:
  | Feature | Digital Garden (current) | Quartz |
  |---------|-------------------------|--------|
  | Graph view | ✅ | ✅ (interactive, full-text search) |
  | Search | ✅ (basic) | ✅ (full-text, fast) |
  | Tags | ✅ | ✅ |
  | Backlinks | ✅ | ✅ |
  | Customization | Limited (11ty templates) | High (Hugo-like) |
  | Deploy | Vercel (auto) | GH Pages or Vercel |
  | Obsidian plugin | Required | Not required (file-based) |
- [ ] Decision: keep current setup for now (simpler, already working), evaluate Quartz later when vault grows

### 5.4 Set up publishing workflow (20 min)
- [ ] Document the publish workflow:
  1. Write/edit note in OK (garden repo)
  2. Set `"dg-publish":true` in frontmatter when ready
  3. Commit and push to GitHub
  4. Vercel auto-deploys (2-3 min)
  5. Note appears on `https://my-digital-garden-rouge.vercel.app/`
- [ ] For notes in the iCloud vault: copy to garden repo first, then publish
- [ ] Document which notes should be public vs private

### 5.5 Publish 10 more notes (30 min)
- [ ] Pick 10 of the best-enriched notes from Phase 3
- [ ] Set `"dg-publish":true` in frontmatter
- [ ] Push and verify on Vercel
- [ ] Check graph view shows connections between published notes

---

## Phase 6: Second Migration Batch & Search (Week 6)

> Goal: Migrate another 50-100 notes, set up QMD MCP for Pi, test cross-vault search.

### 6.1 Select and migrate second batch (1 hr)
- [ ] Pick next 50-100 notes from iCloud vault (broader topics, not just pkm/)
- [ ] Use Pi to batch-enrich: suggest frontmatter, tags, links for each
- [ ] Copy to appropriate `resources/{topic}/` folders in the garden repo
- [ ] Commit and push
- [ ] QMD re-index: `qmd update && qmd embed --stale`

### 6.2 Add QMD collection for the garden repo (15 min)
- [ ] `qmd collection add "C:\Users\maksi\repos\my-digital-garden" --name garden`
- [ ] `qmd context add qmd://garden "Public digital garden — published and publishable notes"`
- [ ] `qmd embed -c garden`
- [ ] Test: `qmd query "karpathy wiki" -c garden` (search only garden)
- [ ] Test: `qmd query "karpathy wiki"` (search everything)

### 6.3 Set up QMD MCP server for Pi (20 min)
- [ ] Start QMD MCP server: `qmd mcp` (test in terminal)
- [ ] If Pi supports MCP, configure connection:
  ```json
  {
    "mcpServers": {
      "qmd": { "command": "qmd", "args": ["mcp"] }
    }
  }
  ```
- [ ] Test: ask Pi to search the vault using QMD tools
- [ ] If MCP not supported by Pi: use `qmd query "..." --json` via bash tool instead

### 6.4 Second lint pass (30 min)
- [ ] Run the same Pi lint session on the expanded garden repo
- [ ] Focus on: broken links between old and new notes, missing cross-refs
- [ ] Fix errors, document warnings

### 6.5 Run OK link graph audit (15 min)
- [ ] Use OK `links` tool: ask Pi to find orphans and dead links in the garden repo
- [ ] Compare with grep-based lint results
- [ ] Fix any discrepancies

---

## Phase 7: Automations (Week 7)

> Goal: Set up Windows Task Scheduler for free daily maintenance, create lint prompt template, establish weekly routine.

### 7.1 Create daily maintenance script (30 min)
- [ ] Create `C:\Users\maksi\repos\scripts\vault-daily-maintenance.ps1`:
  ```powershell
  $vaultPath = "C:\Users\maksi\iCloudDrive\iCloud~md~obsidian\obsidian-sync"
  $gardenPath = "C:\Users\maksi\repos\my-digital-garden"
  
  # 1. QMD re-index (vault)
  Set-Location $vaultPath
  qmd update
  qmd embed --stale
  
  # 2. Git sync (vault)
  git add -A
  $changes = git status --porcelain
  if ($changes) {
      git commit -m "daily auto-sync $(Get-Date -Format 'yyyy-MM-dd')"
      git push
  }
  
  # 3. Git sync (garden)
  Set-Location $gardenPath
  git add -A
  $changes = git status --porcelain
  if ($changes) {
      git commit -m "daily auto-sync $(Get-Date -Format 'yyyy-MM-dd')"
      git push
  }
  
  # 4. Log
  $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
  Add-Content -Path "$gardenPath\log.md" -Value "## [$timestamp] daily-maintenance | qmd reindex + git sync"
  ```
- [ ] Test: run the script manually, verify it works
- [ ] Fix any path or permission issues

### 7.2 Set up Windows Task Scheduler (20 min)
- [ ] Open Task Scheduler → Create Basic Task
- [ ] Name: "Vault Daily Maintenance"
- [ ] Trigger: Daily at 6:00 AM
- [ ] Action: Start a program → `powershell.exe -ExecutionPolicy Bypass -File C:\Users\maksi\repos\scripts\vault-daily-maintenance.ps1`
- [ ] Conditions: Start only if computer is on AC power (uncheck for laptops)
- [ ] Test: right-click task → Run → verify it executes

### 7.3 Create lint prompt template (20 min)
- [ ] Save the lint prompt as a reusable file: `C:\Users\maksi\repos\my-digital-garden\.ok\skills\vault-lint.md`
  ```markdown
  # Vault Lint Skill
  
  Run a vault lint on the garden repo. Do all 8 checks:
  
  1. Broken wikilinks: grep all [[wikilinks]] → cross-reference against actual files
  2. Orphan pages: find .md files with no inbound [[wikilinks]]
  3. Contradictions: read pages sharing entities, flag conflicting claims
  4. Stale claims: cross-reference source dates with content, flag outdated
  5. Missing pages: find [[wikilinks]] to non-existent pages
  6. Missing cross-refs: find pages discussing same topics but not linking
  7. Index consistency: verify index.md matches actual files
  8. Data gaps: suggest topics mentioned frequently but lacking depth
  
  Also: tag audit (duplicates, missing, convention violations), dedup scan.
  
  Report grouped by severity (Errors / Warnings / Info).
  For each: What, Where (file:line), Fix.
  Log to log.md.
  ```
- [ ] Commit to garden repo

### 7.4 Establish weekly lint routine (15 min)
- [ ] Schedule a recurring calendar reminder: "Weekly vault lint" — every Sunday
- [ ] When prompted: open a Pi session, paste the lint prompt
- [ ] Review findings, fix errors, note warnings for later
- [ ] Total time: 15-30 min per week

### 7.5 Create weekly mechanical lint script (optional, 30 min)
- [ ] Create `C:\Users\maksi\repos\scripts\vault-weekly-mechanical.ps1`:
  ```powershell
  # Free mechanical checks — no LLM needed
  $gardenPath = "C:\Users\maksi\repos\my-digital-garden"
  Set-Location $gardenPath
  
  # 1. Broken link scan
  $allLinks = Select-String -Path "$gardenPath\**\*.md" -Pattern '\[\[([^\]]+)\]\]' -AllMatches
  $broken = @()
  foreach ($match in $allLinks) {
      $linkName = $match.Matches[0].Groups[1].Value
      $targetFile = Get-ChildItem -Path $gardenPath -Filter "$linkName.md" -Recurse
      if (-not $targetFile) { $broken += "$($match.Path):$($match.LineNumber) → [[$linkName]]" }
  }
  $broken | Out-File "$gardenPath\lint-broken-links.txt"
  
  # 2. Integrity hash
  $files = Get-ChildItem -Path $gardenPath -Filter "*.md" -Recurse
  $hashes = $files | ForEach-Object { Get-FileHash $_.FullName -Algorithm SHA256 }
  $hashes | ConvertTo-Json | Out-File "$gardenPath\.lint-hash.json"
  
  # 3. Log
  Add-Content -Path "$gardenPath\log.md" -Value "## [$(Get-Date -Format 'yyyy-MM-dd')] weekly-mechanical | broken links + hash"
  ```
- [ ] Add to Task Scheduler: Weekly, Sunday 7 AM
- [ ] Test manually

---

## Phase 8: Polish & Documentation (Week 8)

> Goal: Final migration batch, full lint, document the complete system, plan next steps.

### 8.1 Third migration batch (1 hr)
- [ ] Pick another 50-100 notes from the iCloud vault
- [ ] Batch-enrich with Pi (frontmatter, tags, links)
- [ ] Copy to garden repo
- [ ] Set `"dg-publish":true` on the best 10-20
- [ ] Push and verify on Vercel

### 8.2 Full vault lint (45 min)
- [ ] Run the complete Pi lint session
- [ ] Run the mechanical weekly script
- [ ] Run OK `links` tool audit
- [ ] Compare all three — reconcile findings
- [ ] Fix all errors
- [ ] Create a "health report" in `log.md`

### 8.3 QMD full re-index (15 min)
- [ ] `qmd update` (both collections)
- [ ] `qmd embed -f` (force re-embed everything — may take 20-30 min for 1,686 files)
- [ ] `qmd status` — verify both collections are indexed
- [ ] Test several searches to confirm quality

### 8.4 Document the complete workflow (30 min)
- [ ] Update `C:\Users\maksi\repos\my-digital-garden\README.md` with:
  - System architecture (OK + QMD + Pi + Vercel)
  - Folder structure
  - Frontmatter conventions
  - Publishing workflow
  - Maintenance schedule
- [ ] Update `C:\Users\maksi\repos\my-digital-garden\plans\personal-wiki-setup-plan.md` with completed items
- [ ] Create a "cheat sheet" of common commands and prompts

### 8.5 Plan next steps (15 min)
- [ ] Evaluate: how many of the 1,686 notes are now migrated? How many published?
- [ ] Identify remaining migration batches
- [ ] Evaluate Quartz: is the current Digital Garden + Vercel sufficient, or switch?
- [ ] Evaluate OK workflows: are ingest/research/consolidate being used? Should they be?
- [ ] Plan Phase 9+: ongoing migration, deeper automation, possible Astro migration

---

## Summary: Task Dependencies

```
Phase 1 (Foundation)
  1.1 Clone repo ─┬─→ 1.2 Verify Vercel
                  ├─→ 1.5 Configure OK
                  └─→ 1.6 Backup vault
  1.3 Install QMD ─→ 1.4 Index vault

Phase 2 (Structure) — depends on Phase 1
  2.1 Audit repo ─→ 2.2 Define structure ─→ 2.3 Frontmatter ─→ 2.4 Folder frontmatter
  2.5 RESOLVER.md
  2.6 Semantic Auto-Linker (independent)

Phase 3 (First Migration) — depends on Phase 2
  3.1 Select notes ─→ 3.2 Migrate 5 manual ─→ 3.3 Migrate 15 with Pi ─→ 3.4 Publish 5-10 ─→ 3.5 Re-index

Phase 4 (Auto-Link & Lint) — depends on Phase 3
  4.1 Semantic Auto-Linker run ─→ 4.2 Tag audit ─→ 4.3 Full lint ─→ 4.4 TagItAll (optional)
  4.5 Evaluate OK workflows (independent)

Phase 5 (Publishing) — depends on Phase 3
  5.1 Audit Vercel ─→ 5.2 Test publish flow ─→ 5.3 Evaluate Quartz ─→ 5.4 Document workflow ─→ 5.5 Publish 10 more

Phase 6 (Second Migration) — depends on Phases 3-5
  6.1 Migrate 50-100 ─→ 6.2 QMD garden collection ─→ 6.3 QMD MCP for Pi ─→ 6.4 Second lint ─→ 6.5 OK link audit

Phase 7 (Automations) — depends on Phase 1
  7.1 Daily script ─→ 7.2 Task Scheduler ─→ 7.3 Lint template ─→ 7.4 Weekly routine ─→ 7.5 Mechanical script

Phase 8 (Polish) — depends on all
  8.1 Third batch ─→ 8.2 Full lint ─→ 8.3 Full re-index ─→ 8.4 Document ─→ 8.5 Plan next
```

## Quick Reference: Tools & Commands

| Tool | Key command | When |
|------|------------|------|
| QMD search | `qmd query "text"` | Any time, local, free |
| QMD keyword | `qmd search "keyword"` | Fast exact match |
| QMD re-index | `qmd update && qmd embed --stale` | After adding notes |
| QMD MCP | `qmd mcp` | Start MCP server for Pi |
| OK ingest | Ask Pi: "ingest this: [URL]" | When saving a source |
| OK research | Ask Pi: "research [topic]" | When synthesizing |
| OK consolidate | Ask Pi: "consolidate [research doc]" | When promoting to canonical |
| OK links | Ask Pi: "find orphans and dead links" | During lint |
| Pi lint | Paste vault-lint prompt | Weekly |
| Semantic Auto-Linker | Obsidian command: "Analyze whole vault" | After migration batches |
| Git sync | `git add -A && git commit && git push` | Daily (automated via Task Scheduler) |
| Vercel publish | Set `"dg-publish":true`, push to GitHub | When ready to publish |