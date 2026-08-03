# Claude

Lightweight AI automation tools for indie projects

Shared by Maks

This is a copy of a chat between Claude and Maks. Content may include unverified or unsafe content that do not represent the views of Anthropic. Shared snapshot may contain attachments and data not displayed here.

Report

## You said: I want to start building small AI powered scheduled or triggered automations in CI.

I want to start building small AI powered scheduled or triggered automations in CI. Something helpful for my indie dev projects like , send daily tweet, review pr on push , draft blog post. I found flume [https://github.com/withastro/flue](https://github.com/withastro/flue) . It looks promising. What are 2-3 alternatives people use these days . Not too heavy, something I could pair with DSPy ( Python or Typescript port), durable runs, cheap infrastructure. I already found inngest, trigger.dev

1:02 AM

## Claude responded: A few solid options beyond Inngest/Trigger.

Searched the web

Searched the web

A few solid options beyond Inngest/Trigger.dev, given you want lightweight + durable + cheap + pairs with Python (DSPy) or TS:

**1\. Windmill** — Open-source, self-hostable (or cheap cloud tier). Native Python and TypeScript script/flow support, built-in cron and webhook triggers, retries/durability baked in. Good fit since DSPy is Python-first — you write a Windmill script that calls your DSPy pipeline directly, no separate runtime to bridge. Self-hosting on a small VPS or Fly.io is cheap.

**2\. Hatchet** — Open-source durable task queue/orchestrator, positions itself as a lighter alternative to Temporal. Has both Python and TypeScript SDKs, supports cron schedules and event-triggered runs, retries and durable execution built in. Good if you want something closer to "just a task queue" than a full workflow platform.

**3\. Restate** — Durable execution engine, TypeScript SDK is first-class (Python SDK exists too). Very lightweight runtime model — it's built around "durable functions" rather than heavyweight DAG orchestration, so it fits your "not too heavy" bar well. Self-host on a single small container or use their cloud.

**Honorable mention: Upstash QStash / Workflow** — if your automations are mostly "call this endpoint on a schedule or webhook," QStash is about as thin as it gets — HTTP-based, pay-per-request, no infra to run yourself. Less "workflow orchestration," more "cron-as-a-service," but for tasks like daily tweet or PR review triggers it might be all you need.

For your specific use cases (daily tweet, PR-triggered review, blog draft), I'd lean toward **Windmill** if DSPy/Python is central to the logic, or **Restate** if you want minimal TS-native durable runs without spinning up a platform.

Want me to sketch out what one of these (say Windmill + DSPy for the PR-review automation) would actually look like end to end?



## You said: There is mat pococks’s Sandcastle.

There is mat pococks’s Sandcastle. Compare it with Windmill, Flue. how is it different ? When would you recommend to use each. Where possible, Use examples when explaining instead of abstract concepts

1:12 AM

## Claude responded: Good pull — these three aren't actually competing for the same job.

Searched the web

Searched the web

Good pull — these three aren't actually competing for the same job. Once you see what each optimizes for, the choice mostly makes itself.

**What each one actually is**

-   **Windmill** — a general-purpose script/workflow runner. You write a Python or TS script, give it a cron trigger or webhook, Windmill runs it durably with retries. It has no opinion about AI agents — it just runs code.
-   **Flue** — a framework for _building agents themselves_: sessions, tool use, sandboxed filesystem, durable state. You use it when the automation _is_ an agent making decisions across multiple steps, not just "run this script."
-   **Sandcastle** — narrower and code-specific: it spins up a real sandbox (Docker/Podman/Vercel), checks out a git branch, runs a coding agent (like Claude Code) inside it, and merges the resulting commits back. It's built for "let an agent write and ship code," not general automation.

**Your three use cases, mapped**

_Daily tweet_ — Windmill, no contest. It's a scheduled script: fetch context → call your DSPy pipeline → post via Twitter API. No sandboxing, no git, no multi-turn agent needed. Using Flue or Sandcastle here is like hiring a contractor to change a lightbulb.

_Review PR on push_ — this is where Flue and Sandcastle actually diverge:

-   With **Sandcastle**, the agent checks out the PR branch inside a container, can run the test suite, _edit the code itself_ to fix issues, and commit back. Use this when you want the bot to actually fix things, not just comment.
-   With **Flue**, you'd build a triage/review agent that reads the diff via GitHub's API (or MCP), reasons about it, and posts review comments — no code sandbox, no commits. Lighter weight, good when you just want commentary/scoring, not code changes.
-   With **Windmill**, you'd skip the "agent" framing entirely: script fetches the diff, one DSPy call scores it, posts a comment. Fine if the review logic is a single LLM call rather than something that needs to explore the repo.

_Draft blog post_ — Windmill if it's "gather a few sources, one LLM call, save a draft file." Flue if you want an agent that researches across multiple steps (reads your past posts from a workspace, drafts, self-critiques, revises) — Flue's session/task model is built for that back-and-forth. Sandcastle doesn't fit at all; there's no code being written.

**Rule of thumb**

-   Is the "automation" fundamentally a script with an LLM call in it? → **Windmill**.
-   Is it an agent that needs multi-step reasoning, tool use, or persistent session state, but doesn't touch your codebase? → **Flue**.
-   Does it need to actually check out branches, edit files, run tests, and merge code? → **Sandcastle**.

For your stack specifically: I'd put the tweet and blog draft on Windmill (cheap, pairs naturally with DSPy in Python), and only reach for Sandcastle on the PR review if you want the bot doing actual fixes rather than just leaving comments — otherwise a plain Windmill script calling an LLM is simpler and cheaper than spinning up containers per PR.



## You said: Ok, I see now.

Ok, I see now. Seems like I am looking for alternatives closest to Flue where I have more control and capabilities to shape multi step AI actions mixed with deterministic steps, multiple integrations. Based on that framing , can you suggest 2 more alternatives not mentioned before? Windmill , Hatcher , Restate probably were not good alternatives to Flue

1:21 AM

## Claude responded: Good instinct to rule those out — Windmill/Hatchet/Restate are workflow runners, not agent-building frameworks.

Searched the web

Searched the web

Good instinct to rule those out — Windmill/Hatchet/Restate are workflow _runners_, not agent-building frameworks. Flue's actual peers are frameworks where you compose LLM steps and deterministic code into one control flow, with tool/integration access baked in. Two worth a close look:

**1\. Mastra** — TypeScript-native, closest in spirit to Flue. You define agents, tools, and _workflows_ that mix deterministic steps with LLM steps in the same graph, with durable execution (it can run its workflow engine on top of Inngest under the hood, or standalone).

Example for your PR-review case: a Mastra workflow step pulls the diff (deterministic, plain TS), a second step passes it to an agent with a `reviewCode` tool bound to your GitHub API, a third step is a deterministic gate — if `severity === 'high'`, branch to a "request changes" step, otherwise post an approving comment. All of that lives in one typed workflow definition, and it persists state so a crash mid-review resumes instead of restarting. Feels like the TS-native version of what Flue is going for, but with a more mature workflow/memory/eval layer around it.

**2\. LangGraph** — Python and TS, graph-based, the most control of any option here (at the cost of more boilerplate). You explicitly define nodes (functions — LLM or plain code) and edges (including conditional and cyclic routing), with checkpointing for durable, resumable state.

Example for your blog-draft case: node 1 (deterministic) scrapes your last 5 posts for style; node 2 is a DSPy-optimized prompt module wrapped as a node that drafts the post; node 3 is a deterministic word-count/tone check; conditional edge sends it back to node 2 for another pass if it fails the check, or forward to node 4 (save draft) if it passes. Since DSPy is Python, LangGraph in Python is the most natural pairing — you're literally calling your DSPy program from inside a graph node.

**Quick contrast with Flue itself:** Flue's harness model (sessions, sandbox, skills-as-markdown) is closer to "build a Claude-Code-like agent," while Mastra and LangGraph are closer to "build an explicit pipeline where some steps happen to be LLM calls." If what you actually want is fine-grained control over exactly when the AI runs versus when plain code runs — which is what you said — Mastra (TS) or LangGraph (Python, best DSPy fit) are the stronger match over Flue, which leans more toward letting the agent drive.



## You said: What are differences between Mastra, Langgraph?

What are differences between Mastra, Langgraph? Which one would you recommend, when and why?

1:24 AM

## Claude responded: Here's the practical breakdown, not the marketing version:

Here's the practical breakdown, not the marketing version:

**Language & ecosystem fit**

-   **Mastra**: TypeScript-only, built from the ground up for JS/Node — no Python bridge needed. If your CI, tweet bot, and blog drafter are already TS, everything shares one runtime and one type system.
-   **LangGraph**: Python-first (the TS port trails the Python release by weeks and inherits some awkward idioms). Since DSPy is Python, LangGraph in Python means your graph nodes can call DSPy modules directly, in-process — no serialization or subprocess boundary.

**Mental model**

-   **Mastra** gives you higher-level primitives: `Agent`, `Tool`, `Workflow` with `.then()`/`.branch()`/`.parallel()` steps. Less code to wire up, faster to ship.
-   **LangGraph** makes you define the state machine explicitly: nodes, edges, conditional routing, even cycles (a node can loop back to itself or an earlier node with no fixed exit condition). More verbose, but nothing about control flow is implicit — good when the logic genuinely branches a lot or needs to retry/backtrack.

**Example — your PR review workflow, concretely:**

-   In Mastra: `createWorkflow().then(fetchDiff).then(reviewAgent).branch([[isHighSeverity, requestChanges], [isLowSeverity, approve]])` — reads almost like a pipeline description.
-   In LangGraph: you'd define a `StateGraph`, add nodes `fetch_diff`, `review`, `request_changes`, `approve`, then wire `add_conditional_edges("review", route_by_severity, {...})`. Same outcome, more explicit machinery — but if later you want "review" to loop back to itself when the agent isn't confident (asking for more context, re-reviewing), that's a natural cycle in LangGraph and an awkward workaround in Mastra.

**Durability & maturity**

-   Mastra's workflow engine can run standalone or on Inngest under the hood; also ships memory, evals, and a Studio UI as first-class parts of the same package.
-   LangGraph's checkpointing (resume-on-crash, human-in-the-loop interrupts) is generally considered the more battle-tested implementation of the two, and it's the one most production deployments with genuinely complex branching lean on.

**My recommendation for you specifically**

Go with **LangGraph in Python** for anything that touches DSPy directly (your blog drafter, PR review scoring) — the in-process pairing is the deciding factor, and you don't lose meaningful ergonomics for indie-scale projects. Reach for **Mastra** only if a given automation is TS-only and doesn't need DSPy at all (e.g., a tweet-posting agent that's mostly tool calls with light branching) — there Mastra will get you shipping faster with less boilerplate.

If you want one framework for everything rather than splitting by language, LangGraph wins by default since it covers both languages and is where DSPy actually lives.



## You said: Ok , seems like LangGraph is closer for what I need.

Ok , seems like LangGraph is closer for what I need. Is it considered heavyweight? Will this be a problem? Should I look for more lightweight options?

1:28 AM

## Claude responded: Short answer: no, LangGraph itself isn't heavyweight in the "extra infra to run" sense — it's just a Python (or TS) library, not a server or platform.

Searched the web

Searched the web

Short answer: no, LangGraph itself isn't heavyweight in the "extra infra to run" sense — it's just a Python (or TS) library, not a server or platform. It runs in-process, doesn't need a message broker or dedicated worker fleet, and the README's own hardware bar is "4GB RAM and API access." That's about as light as durable orchestration gets.

Where the "heavyweight" reputation actually comes from:

**Package surface, not runtime weight.** LangGraph is conventionally installed alongside `langchain`, `langchain-core`, and `langsmith`. You don't strictly need the full `langchain` meta-package — `langgraph` + `langgraph-checkpoint` alone will run a graph — but most docs/tutorials assume the fuller stack, and that pulls in more than a minimal agent loop needs.

**Boilerplate, not resource cost.** Defining nodes and edges explicitly is more code than, say, a single `agent.run()` call in a simpler framework. That's a real cost for a solo dev shipping fast — it's slower to get the first version working, even though nothing about it is expensive to run.

**Durability needs a backing store.** For checkpointing (resume-on-crash) in production you want something more than in-memory — but for indie scale, a SQLite file checkpointer is genuinely fine, costs nothing, and needs zero extra infra. You only reach for Postgres/Redis-backed checkpointers if you're running concurrent workflows at real scale.

**Concretely for your CI use case:** a scheduled GitHub Action spins up, runs your LangGraph script, writes state to a SQLite file (or skips persistence entirely if the whole run finishes in one shot, which "review a PR" and "draft a post" both do), and exits. No server, no queue, no ongoing cost. This is not the same "heavy" as something like Temporal, which does want a persistent server cluster.

**When I'd actually tell you to go lighter:** if your graphs stay mostly linear (fetch → LLM call → deterministic check → post) with only occasional branching, you don't need LangGraph's cyclic-graph power at all — plain Python functions plus a `tenacity`\-style retry decorator gets you 90% of the durability for 10% of the code, and DSPy modules slot in exactly the same way. **Pydantic AI** is worth a look too: much lighter conceptually (typed agent + tool calls, no explicit graph), still Python-native, still pairs cleanly with DSPy — good if your workflows turn out to be "agent with a few tools" rather than "genuinely branching pipeline with loops."

My take: start with LangGraph only for the piece that actually branches or needs retry/backtrack logic (PR review, since severity routing and re-review loops fit it naturally). For the daily tweet and blog draft — which are basically linear — skip the framework and just write the Python script with DSPy directly. You don't have to standardize on one tool across all three automations.



## You said: Ok, I think I like Pydantic idea.

Ok, I think I like Pydantic idea. Absolutely love what their team was releasing and blogging recently. Will it be sufficient or I will need extra dependencies to do things like, web search , github search, generating visuals like diagrams, svg? Would other frameworks from the above list suite better ?

5:30 AM

## Claude responded: Good news: Pydantic AI covers more of this out of the box than you'd expect, and the gaps aren't things other frameworks solve better either — they're just "wr…

Searched the web

Searched the web

Good news: Pydantic AI covers more of this out of the box than you'd expect, and the gaps aren't things other frameworks solve better either — they're just "write a tool" problems, not framework problems.

**Web search** — built in. There's a `WebSearch` capability that uses the model provider's native search (Anthropic/OpenAI's own) when available, and falls back to DuckDuckGo, Tavily, or Exa if you want a specific provider. For your daily-tweet or blog-draft bots, that's `pip install "pydantic-ai-slim[duckduckgo]"` and you're done — no separate search SDK to wire up.

**GitHub search** — not a named built-in, but two easy paths:

1.  Point it at GitHub's official MCP server via the `MCP` capability — gives the agent repo search, issues, PRs, code search, all through one connection string. This is probably your best fit since you're already doing PR-review automation.
2.  Or write a plain function tool that shells out to `gh` CLI or hits the GitHub REST API. Maybe 15 lines, and you get exact control over what the agent can query.

Either way, this is a couple hours of setup, not a missing capability.

**Diagrams / SVG generation** — this is the one real gap, but it's a gap in _every_ framework on our list, not just Pydantic AI. None of Mastra, LangGraph, or Pydantic AI "generate diagrams" natively, because that's not really an LLM-orchestration problem — it's a tool problem. Two practical approaches:

-   Have the agent output Mermaid syntax (LLMs are quite good at this) as structured text, then a deterministic Python step runs `mmdc` (Mermaid CLI) or the `mermaid.ink` API to render it to SVG/PNG. No framework needed for the render step, just a function tool that calls a subprocess.
-   For raster images (not diagrams), Pydantic AI does have a built-in **image generation** capability that wraps provider APIs (e.g., OpenAI's image models) — fine for illustrative blog images, not for structured diagrams.

**Bottom line:** Pydantic AI is sufficient for your three use cases. You'll add `duckduckgo`/`tavily` extras for search, wire up the GitHub MCP server for PR review, and write one small "render Mermaid to SVG" tool yourself — none of that pushes you toward LangGraph or Mastra, since they'd need the identical glue code for diagram rendering anyway. The only reason to reconsider would be if your PR-review flow grows real branching/looping logic (re-review after a fix, multi-round approval) — that's still where LangGraph's explicit graph model earns its keep over Pydantic AI's simpler agent loop.



[Ask Claude your own question](/new)

<iframe src="https://a.claude.ai/isolated-segment.html?v=4794037c3f" referrerpolicy="no-referrer" sandbox="allow-scripts allow-same-origin" title="Marketing analytics" style="display: none;"></iframe>

<iframe height="1" width="1" style="position: absolute; top: 0px; left: 0px; border-width: medium; border-style: none; border-color: currentcolor; border-image: none; visibility: hidden;"></iframe>

## Embedded Content