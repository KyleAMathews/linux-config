#!/usr/bin/env node
import { execFileSync } from 'node:child_process'
import { mkdirSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'

function usage() {
  console.error(`Usage:
  github-open-items-shards.mjs --repo OWNER/REPO --out DIR [--batch-size N] [--issues] [--prs]

Purpose:
  Deterministically enumerate open GitHub issues/PRs and write batch JSON files
  plus a manifest. This script does no interpretation and no sampling.

Examples:
  github-open-items-shards.mjs --repo TanStack/db --out /tmp/tanstack-db-open --batch-size 25
  github-open-items-shards.mjs --repo prettier/prettier --out /tmp/prettier-open --issues --batch-size 25
`)
  process.exit(2)
}

const args = process.argv.slice(2)
let repo
let out
let batchSize = 25
let includeIssues = false
let includePrs = false

for (let i = 0; i < args.length; i++) {
  const arg = args[i]
  if (arg === '--repo') repo = args[++i]
  else if (arg === '--out') out = args[++i]
  else if (arg === '--batch-size') batchSize = Number(args[++i])
  else if (arg === '--issues') includeIssues = true
  else if (arg === '--prs') includePrs = true
  else if (arg === '--help' || arg === '-h') usage()
  else {
    console.error(`Unknown argument: ${arg}`)
    usage()
  }
}

if (!repo || !out || !Number.isInteger(batchSize) || batchSize < 1 || batchSize > 100) usage()
if (!includeIssues && !includePrs) {
  includeIssues = true
  includePrs = true
}

function runGh(kind, limit) {
  const subcommand = kind === 'issues' ? 'issue' : 'pr'
  const fields = kind === 'issues'
    ? 'number,title,state,author,createdAt,updatedAt,closedAt,labels,comments,url,body'
    : 'number,title,state,author,createdAt,updatedAt,labels,comments,url,body'
  const output = execFileSync('gh', [subcommand, 'list', '--repo', repo, '--state', 'open', '--limit', String(limit), '--json', fields], {
    encoding: 'utf8',
    maxBuffer: 1024 * 1024 * 200,
  })
  return JSON.parse(output)
}

function fetchAll(kind) {
  // gh issue/pr list has a --limit cap. We deliberately probe at 1000 first,
  // then at 1001. If 1001 returns more than 1000, the repo exceeded the old
  // common cap and gh can paginate further in this environment. If either
  // result reaches the requested limit, mark the export potentially capped so
  // the agent cannot claim complete coverage silently.
  const firstLimit = 1000
  const first = runGh(kind, firstLimit)
  let items = first
  let requestedLimit = firstLimit
  let possiblyCapped = first.length >= firstLimit

  if (possiblyCapped) {
    const secondLimit = 1001
    const second = runGh(kind, secondLimit)
    requestedLimit = secondLimit
    items = second
    possiblyCapped = second.length >= secondLimit
  }

  items.sort((a, b) => a.number - b.number)
  return { items, requestedLimit, possiblyCapped }
}

function writeBatches(kind, items) {
  const dir = join(out, kind)
  mkdirSync(dir, { recursive: true })
  const batches = []
  for (let i = 0; i < items.length; i += batchSize) {
    const batchItems = items.slice(i, i + batchSize)
    const index = batches.length + 1
    const start = batchItems[0]?.number ?? null
    const end = batchItems[batchItems.length - 1]?.number ?? null
    const file = join(dir, `batch-${String(index).padStart(3, '0')}-${start ?? 'empty'}-${end ?? 'empty'}.json`)
    writeFileSync(file, JSON.stringify({ repo, kind, batchIndex: index, count: batchItems.length, items: batchItems }, null, 2))
    batches.push({ batchIndex: index, file, count: batchItems.length, numbers: batchItems.map((item) => item.number) })
  }
  return batches
}

mkdirSync(out, { recursive: true })

const manifest = {
  repo,
  generatedAt: new Date().toISOString(),
  batchSize,
  sources: {},
}

for (const [kind, enabled] of [['issues', includeIssues], ['prs', includePrs]]) {
  if (!enabled) continue
  const { items, requestedLimit, possiblyCapped } = fetchAll(kind)
  const batches = writeBatches(kind, items)
  manifest.sources[kind] = {
    state: 'open',
    requestedLimit,
    count: items.length,
    batchSize,
    batchCount: batches.length,
    firstNumber: items[0]?.number ?? null,
    lastNumber: items[items.length - 1]?.number ?? null,
    possiblyCapped,
    completeCoverageClaimAllowed: !possiblyCapped,
    batches: batches.map((batch) => ({
      batchIndex: batch.batchIndex,
      file: batch.file,
      count: batch.count,
      firstNumber: batch.numbers[0] ?? null,
      lastNumber: batch.numbers[batch.numbers.length - 1] ?? null,
    })),
  }
}

writeFileSync(join(out, 'manifest.json'), JSON.stringify(manifest, null, 2))

console.log(JSON.stringify({
  repo,
  out,
  batchSize,
  sources: Object.fromEntries(Object.entries(manifest.sources).map(([kind, source]) => [kind, {
    count: source.count,
    batches: source.batches.length,
    possiblyCapped: source.possiblyCapped,
    completeCoverageClaimAllowed: source.completeCoverageClaimAllowed,
  }])),
}, null, 2))

if (Object.values(manifest.sources).some((source) => source.possiblyCapped)) {
  console.error('WARNING: One or more exports may be capped. Narrow the scope or implement GraphQL pagination before claiming complete coverage.')
  process.exitCode = 3
}
