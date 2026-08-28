# Phase 2: Open-Item Census and Evidence Gathering

## Goal

Plan and run the open-item census and evidence extraction. Read broadly first, cluster second, and avoid design interpretation.

Phase 2 does **not** run reproduction, tests, ground-truth validation, or solution design. If a source item looks behavior-testable, capture the claim and citation token only.

## Source Tiers

### Tier 1: Maintainer-Owned, High-Quality Sources

Use GitHub as primary evidence. Use Discord as primary evidence only when maintainer/admin-approved access or exports are available.

For this inventory, open issues/PRs are the coverage anchor. Closed/merged artifacts are reserved for Phase 4 historical enrichment after open-item clusters exist.

**GitHub via `gh`:**

```bash
gh issue list \
  --repo OWNER/REPO \
  --state all \
  --search "updated:2025-01-01..2025-12-31" \
  --limit 1000 \
  --json number,title,state,author,createdAt,updatedAt,closedAt,labels,comments,url,body

gh pr list \
  --repo OWNER/REPO \
  --state open \
  --search "updated:2025-01-01..2025-12-31" \
  --limit 1000 \
  --json number,title,state,author,createdAt,updatedAt,labels,comments,url,body

# Historical PR pass: do not use in Phase 2 by default; Phase 4 performs bounded historical enrichment after clusters exist.
gh pr list \
  --repo OWNER/REPO \
  --state all \
  --search "updated:2025-01-01..2025-12-31" \
  --limit 1000 \
  --json number,title,state,author,createdAt,updatedAt,closedAt,mergedAt,labels,comments,url,body

gh issue view 123 \
  --repo OWNER/REPO \
  --comments \
  --json number,title,body,comments,createdAt,updatedAt,closedAt,labels,url

gh pr view 456 \
  --repo OWNER/REPO \
  --comments \
  --json number,title,body,comments,reviews,createdAt,updatedAt,mergedAt,labels,url
```

Use `gh api graphql` for GitHub Discussions when the project actively uses them.


## Parallelism Rule

Phase 2 is subagent-first. After mechanical sharding, dispatch every independent batch to subagents in parallel when tool/runtime limits allow. The orchestrator should not read batch bodies except for debugging; it should coordinate manifests, dispatches, and count verification.

## Deterministic GitHub Coverage Contract

For current triage and next-run passes, do **not** sample open issues or open PRs. Enumerate all open issues and all open PRs in scope, then shard them to subagents so the top-level agent does not overload its context.

Use the mechanical sharding script; do not hand-roll sampling or let the top-level agent decide which open items matter. The orchestrator should treat the script output as an assignment manifest, not as material to analyze directly:

```bash
${CLAUDE_SKILL_DIR:-$HOME/.agents/skills/misfits-survey}/scripts/github-open-items-shards.mjs \
  --repo OWNER/REPO \
  --out /tmp/OWNER-REPO-open-items \
  --batch-size 25
```

The script writes a high-level manifest and small batch files:

- `/tmp/OWNER-REPO-open-items/manifest.json` — counts, cap status, batch list, first/last numbers.
- `/tmp/OWNER-REPO-open-items/issues/batch-*.json` — small issue batches.
- `/tmp/OWNER-REPO-open-items/prs/batch-*.json` — small PR batches.

The script does no interpretation and no sampling. It sorts items by number, writes deterministic batches, and marks `possiblyCapped` in the manifest if `gh` hit a limit. If `possiblyCapped` is true, narrow the scope or use paginated GraphQL before claiming complete coverage.

Orchestrator rule: after the script runs, do not read through the batch bodies yourself except to dispatch them. Blindly farm out each batch file to a subagent with the batch analysis prompt. The top-level agent only reads `manifest.json`, dispatches batch files, merges returned coverage ledgers, and verifies counts.

Manual `gh` commands are fallback/debug only:

```bash
gh issue list \
  --repo OWNER/REPO \
  --state open \
  --limit 1000 \
  --json number,title,state,author,createdAt,updatedAt,labels,comments,url,body

gh pr list \
  --repo OWNER/REPO \
  --state open \
  --limit 1000 \
  --json number,title,state,author,createdAt,updatedAt,labels,comments,url,body
```

Historical closed/merged artifacts are not part of the Phase 2 coverage anchor. Use them in Phase 4 only as bounded historical context for identified clusters. Open artifacts are not sampled.

### Batch Sharding

Split open issues/PRs into deterministic small batches, typically 10–25 items per subagent depending on body/comment size. Assign every item to exactly one batch. Use the script-generated batch files as the assignment source; dispatch every batch file without pre-filtering.

Each batch subagent must return a **coverage ledger**:

| Item | Disposition | Evidence extracted? | Reason | Citation token |
|---|---|---|---|---|

Allowed dispositions:

- `relevant-signal`
- `possibly-relevant`
- `stale-or-duplicate`
- `routine-support`
- `routine-maintenance`
- `not-survey-relevant`
- `unclear`

Every open issue/PR in scope must appear in a coverage ledger. A batch subagent may extract zero evidence snippets, but it must still account for every assigned item.

### Batch Subagent Prompt Requirements

For every GitHub issue/PR batch subagent, the orchestrator prompt must be minimal and must point to the worker reference. Do not inline a hand-written schema that can drift or be forgotten.

Required worker reference:

```text
${CLAUDE_SKILL_DIR:-$HOME/.agents/skills/misfits-survey}/reference/worker-open-item-attribute-extraction.md
```

The worker prompt should say, in substance:

```text
Read `reference/worker-open-item-attribute-extraction.md` from the `misfits-survey` skill directory fully. Then read this script-generated GitHub batch JSON file: <batch-path>. Process every item exactly as the worker reference instructs. Write outputs under <out>. Return only the short status block required by the worker reference.
```

The orchestrator must not rely on workers remembering Phase 2. The worker reference is the contract. If a worker response does not include the required ledger and attributes JSONL paths, treat that batch as failed and rerun it.

Each batch subagent writes, per the worker reference:

```text
<out>/analysis/<kind>/batch-NNN-ledger.md
<out>/analysis/<kind>/batch-NNN-attributes.jsonl
<out>/analysis/<kind>/batch-NNN-snippets.md   # optional
```

The batch subagent's chat response must be short and must not include the full ledger, JSONL, evidence snippets, item bodies, or long quotes. This keeps the orchestrator context small.

The top-level agent reads batch status responses and manifest counts, then verifies coverage from the ledger files before clustering:

- total open issues/PRs enumerated from `manifest.json`;
- total batch files from `manifest.json`;
- total assigned to batches from `manifest.json`;
- total returned in ledger files;
- missing item numbers, if any;
- capped/partial exports, if any.

Do not say “all open issues/PRs were accounted for” unless enumeration count, assigned count, and returned ledger count match.

**Discord via authorized local export:**

The maintainer should authorize access and provide the server/channel scope and date window. The agent should run the Discord dump locally when credentials/tooling are available; do not make the maintainer manually export and pre-redact a year of chat.

Discord is optional and access-gated. For broad historical channel analysis, proceed only if one of these is true:

- a server admin/maintainer adds an approved bot with the needed permissions;
- a server admin/maintainer runs or authorizes an export;
- the maintainer provides selected message links, thread links, screenshots, or exported snippets.

If the maintainer is only a normal server member and has no admin/bot/export access, do **not** attempt bulk Discord collection. Do not use user-token automation or self-bot scraping. Record `Discord unavailable` in Survey Metadata and continue with GitHub, docs, web, Reddit, and other accessible sources. Optionally draft a short request the maintainer can send to server admins asking for scoped export or bot access.

Preferred path for most OSS maintainers: use a small local Node script with a maintainer-approved Discord bot. This avoids requiring .NET and keeps the collection logic inspectable.

Bot requirements:

- The bot is added only to maintainer-approved servers/channels.
- It has `View Channel` and `Read Message History`.
- It has Message Content intent if message text is needed and Discord requires it for that bot/server.
- The maintainer provides `DISCORD_BOT_TOKEN`, channel IDs, and date window.

Minimal Node collection approach:

```bash
npm init -y
npm install discord.js
```

```js
// export-discord-channel.mjs
import { Client, GatewayIntentBits } from 'discord.js'
import { writeFile } from 'node:fs/promises'

const token = process.env.DISCORD_BOT_TOKEN
const channelId = process.env.DISCORD_CHANNEL_ID
const after = new Date(process.env.AFTER)
const before = new Date(process.env.BEFORE)
const output = process.env.OUTPUT ?? `discord-${channelId}.json`

if (!token || !channelId || Number.isNaN(after.valueOf()) || Number.isNaN(before.valueOf())) {
  throw new Error('Set DISCORD_BOT_TOKEN, DISCORD_CHANNEL_ID, AFTER, BEFORE, and optional OUTPUT')
}

const client = new Client({
  intents: [GatewayIntentBits.Guilds, GatewayIntentBits.GuildMessages, GatewayIntentBits.MessageContent],
})

await client.login(token)
const channel = await client.channels.fetch(channelId)

const messages = []
let beforeId
while (true) {
  const batch = await channel.messages.fetch({ limit: 100, before: beforeId })
  if (batch.size === 0) break

  for (const message of batch.values()) {
    const createdAt = message.createdAt
    if (createdAt > before) continue
    if (createdAt < after) {
      await writeFile(output, JSON.stringify(messages, null, 2))
      await client.destroy()
      process.exit(0)
    }
    messages.push({
      id: message.id,
      url: message.url,
      channelId: message.channelId,
      authorId: message.author?.id,
      authorUsername: message.author?.username,
      createdAt: createdAt.toISOString(),
      content: message.content,
      attachments: [...message.attachments.values()].map((a) => ({ url: a.url, name: a.name })),
      reference: message.reference ?? null,
    })
  }

  beforeId = batch.last()?.id
  if (!beforeId) break
}

await writeFile(output, JSON.stringify(messages, null, 2))
await client.destroy()
```

Run:

```bash
DISCORD_BOT_TOKEN='...' \
DISCORD_CHANNEL_ID='...' \
AFTER='2025-01-01T00:00:00Z' \
BEFORE='2026-01-01T00:00:00Z' \
OUTPUT='discord-channel-2025.json' \
node export-discord-channel.mjs
```

For threads, either export selected thread channel IDs the same way or extend the script to enumerate active/archived threads for the parent channel. Keep thread export explicit and scoped; support/debug context often lives in threads, but thread enumeration can expand scope quickly.

Fallback path: DiscordChatExporter CLI. Use this only if the maintainer is comfortable with .NET or already has the tool installed.

```bash
dotnet tool install -g DiscordChatExporter.Cli
export PATH="$HOME/.dotnet/tools:$PATH"
DiscordChatExporter.Cli --version
```

Discover accessible guilds/channels:

```bash
DiscordChatExporter.Cli guilds -t "$DISCORD_TOKEN"
DiscordChatExporter.Cli channels -t "$DISCORD_TOKEN" -g "$GUILD_ID"
```

Export scoped history as JSON, including threads:

```bash
DiscordChatExporter.Cli exportguild \
  -t "$DISCORD_TOKEN" \
  -g "$GUILD_ID" \
  --after "2025-01-01" \
  --before "2026-01-01" \
  --include-threads all \
  -f Json \
  -o "discord-guild-2025"
```

Do not suggest npm packages such as `discord-chat-exporter` as the default unless they have been manually vetted in the current session; known npm packages appear old or less standard than a small local `discord.js` script.

Keep raw Discord dumps local and out of git. Do not ask for broad manual redaction before analysis. Instead, dispatch cheap extraction subagents over bounded JSON files/channels. Each extraction subagent returns only relevant evidence snippets:

- message URL or channel/thread/date locator;
- short quote;
- surrounding context summary;
- reported experience or question;
- implied expectation;
- affected repo area if inferable;
- evidence type;
- staleness/recurrence note;
- privacy sensitivity flag.

Only extracted snippets intended for the living survey document need maintainer review/redaction. Publish aggregate summaries where possible; keep raw exports private.

Do not recommend scraping unrelated servers or private DMs. Use only maintainer-authorized servers/channels and the minimum date/window needed.

### Tier 2: Public Discovery Sources

Use Reddit and general web search for discovery/corroboration, not exhaustive sampling. These searches should find non-GitHub public discourse; GitHub has its own Tier 1 path. Add `-site:github.com` to general/social queries unless the task is explicitly to find GitHub issues/PRs/discussions:

```text
"PROJECT_NAME" site:reddit.com -site:github.com
"PROJECT_NAME" "error" site:reddit.com -site:github.com
"PROJECT_NAME" "how do I" site:reddit.com -site:github.com
"PROJECT_NAME" "alternative" site:reddit.com -site:github.com
"PROJECT_NAME" "docs" site:reddit.com -site:github.com
"PROJECT_NAME" "migration" site:reddit.com -site:github.com
"PROJECT_NAME" -site:github.com -site:github.io
```

### Tier 3: Optional / Noisy Sources

Twitter/X is supplemental unless the maintainer already has official API access. Manual search examples:

```text
"PROJECT_NAME" since:2025-01-01 until:2026-01-01
"PROJECT_NAME" "docs" since:2025-01-01 until:2026-01-01
"PROJECT_NAME" -is:retweet since:2025-01-01 until:2026-01-01
to:MAINTAINER_HANDLE since:2025-01-01 until:2026-01-01
```

## Privacy Rules

- Get maintainer/admin authorization before Discord access. If authorization is unavailable, mark Discord unavailable and skip bulk Discord collection.
- Do not collect private messages unless explicitly consented and necessary.
- Minimize data: collect only needed channels, windows, and fields.
- Keep raw exports local and out of git.
- Automatically extract only relevant quotes/snippets before asking for maintainer review.
- Redact usernames, emails, secrets, private support details, and sensitive stack traces before publishing extracted snippets.
- Preserve links/locators internally, but publish aggregated findings where possible.
- Maintainer reviews externally visible outputs, not the entire raw dump.

## Structured Attribute Extraction

Do not ask subagents to “cluster semantically” from raw descriptions. First extract structured attributes from every open item. Clustering in Phase 3 must operate on these attributes plus explicit links/metadata.

This is Alexander-flavored as an extraction method, not as an interpretation layer: capture form touched, context demand, condition, and friction where the artifact states or strongly implies them. Do not turn these into forces, tensions, design positions, or solution claims.

Each source-specific subagent writes shard files to disk and returns only file paths/counts in chat. Shard files contain factual signal fields only:

### Mechanical metadata

- source URL/path;
- item number and type;
- title and state;
- labels;
- created/updated/closed/merged dates when available;
- reactions/upvotes and comment counts;
- author/actor role if relevant and non-sensitive;
- citation token for every claim.

### Extracted attributes

- repo area / package / adapter explicitly touched;
- API names, symbols, docs pages, examples, or commands mentioned;
- user-facing workflow affected;
- environment / runtime / framework / backend named;
- reported condition or setup;
- desired outcome / expectation stated by reporter;
- observed friction / failure mode stated by reporter;
- artifact type, chosen from: bug report, feature request, docs confusion, adapter/runtime report, performance report, maintenance PR, design/API proposal, support question, stale-looking/duplicate-looking, unclear;
- form touched, chosen from explicit evidence: code/API/docs/tests/package/process/release/CI/example/unknown;
- context demand, chosen from explicit evidence: framework/runtime constraint, user workflow expectation, backend/source integration, type-safety expectation, persistence/offline expectation, performance expectation, contribution/release demand, unknown;
- explicit links to related issues/PRs;
- possible cluster keywords/API names;
- staleness or duplicate hint if obvious, without closure recommendation.

### Representative evidence

- direct quote/snippet;
- short factual summary;
- uncertainty note when attributes are inferred from weak evidence.

## Subagent Prompt Contract

When dispatching evidence-gathering subagents, instruct them:

- read every assigned item within the batch/source/window;
- write a coverage ledger plus normalized shards to disk; return only file paths and counts in chat;
- preserve citation tokens and representative quotes;
- extract the structured attributes listed above for every item, using `unknown` where the artifact does not support an attribute;
- do not diagnose root causes or interpret design problems;
- do not run tests, reproduce bugs, or perform live end-to-end validation; this inventory records signals only;
- flag privacy-sensitive material for redaction before publication;
- for Discord, extract relevant quotes/snippets from raw JSON rather than summarizing whole channels generically;
- separate frequency from loudness;
- preserve concrete praise and successful fit when cited; do not invent positive signals.

## Completion Output

Report:

- sources available;
- sources unavailable, including whether Discord is unavailable due to missing admin/bot/export access;
- proposed source windows;
- GitHub sharding manifest path and `possiblyCapped` status, if GitHub is in scope;
- subagents dispatched or planned;
- output directories for batch ledgers and attribute shards;
- privacy/redaction constraints;
- attribute shard format.

Then ask: **"May I proceed to Phase 3: Light Clustering of Open Signals?"**

Only proceed when the maintainer gives explicit permission.
