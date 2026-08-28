---
name: tanstack-solid-live-query
description: Apply TanStack Solid DB useLiveQuery patterns. Use when building or debugging reactive queries with @tanstack/solid-db.
---

# TanStack Solid DB - useLiveQuery Skill

Guide for using `useLiveQuery` from `@tanstack/solid-db` to create reactive queries over TanStack DB collections.

## Import

```typescript
import { useLiveQuery } from '@tanstack/solid-db';
```

## Core Patterns

### Pattern 1: Direct Collection Access (Simplest)

Use when you want all items from a collection with no server-side filtering:

```typescript
import { useLiveQuery } from '@tanstack/solid-db';

function MyComponent() {
  const db = useMyDB(); // Your DB context

  const query = useLiveQuery(() => db.collections.events);

  // Access data as a reactive array (it's a Solid store, not an accessor!)
  const events = query.data; // NO () - it's already reactive

  // Or use in JSX directly
  return (
    <For each={query.data}>
      {(event) => <EventCard event={event} />}
    </For>
  );
}
```

**IMPORTANT**: When using direct collection access, `query.data` is a **Solid store array** (reactive), not an accessor function. Do NOT call it with `query.data()`.

### Pattern 2: Query Builder with Filtering

Use TanStack DB's query builder to push filtering/sorting into the database:

```typescript
const query = useLiveQuery((q) =>
  q.from({ events: db.collections.events })
   .where(({ events }) => eq(events.language, 'en'))
   .select(({ events }) => ({ id: events.id, title: events.title }))
);

// Access data directly - it's a reactive store array
const filteredData = query.data;
```

### Pattern 3: Reactive Query with Signals

Query functions automatically track signal dependencies:

```typescript
const [minPriority, setMinPriority] = createSignal(5);

const query = useLiveQuery((q) =>
  q.from({ todos: db.collections.todos })
   .where(({ todos }) => gte(todos.priority, minPriority())) // Signal tracked!
);

// When minPriority() changes, query automatically re-runs
```

### Pattern 4: Joins Across Collections

```typescript
const query = useLiveQuery((q) =>
  q.from({ issues: db.collections.issues })
   .join({ users: db.collections.users }, ({ issues, users }) =>
     eq(issues.userId, users.id)
   )
   .select(({ issues, users }) => ({
     issueId: issues.id,
     issueTitle: issues.title,
     userName: users.name
   }))
);
```

### Pattern 5: Includes (Hierarchical/Nested Results)

Use includes to nest related data instead of flattening with joins. Each child result is a live `Collection` by default:

```typescript
import { eq, toArray } from '@tanstack/db';

// Each project gets a nested child Collection of its issues
const query = useLiveQuery((q) =>
  q.from({ p: db.collections.projects }).select(({ p }) => ({
    id: p.id,
    name: p.name,
    issues: q
      .from({ i: db.collections.issues })
      .where(({ i }) => eq(i.projectId, p.id))  // correlation condition (required)
      .select(({ i }) => ({ id: i.id, title: i.title })),
  }))
);
```

**Child Collections must be subscribed to in subcomponents** to get reactive updates:

```typescript
// Parent component
<For each={query()}>
  {(project) => (
    <div>
      {project.name}
      <IssueList issuesCollection={project.issues} />
    </div>
  )}
</For>

// Child component — subscribes to the child Collection
function IssueList(props: { issuesCollection: Collection }) {
  const issues = useLiveQuery(() => props.issuesCollection);
  return (
    <For each={issues()}>
      {(issue) => <div>{issue.title}</div>}
    </For>
  );
}
```

**`toArray()` alternative** — wraps the child query to return a plain array instead of a Collection. The parent row re-emits when children change:

```typescript
const query = useLiveQuery((q) =>
  q.from({ p: db.collections.projects }).select(({ p }) => ({
    id: p.id,
    name: p.name,
    issues: toArray(
      q.from({ i: db.collections.issues })
        .where(({ i }) => eq(i.projectId, p.id))
        .select(({ i }) => ({ id: i.id, title: i.title }))
    ),
  }))
);
// project.issues is now a plain array — no subcomponent subscription needed
```

**Key rules:**
- The child `.where()` must contain an `eq()` linking a child field to a parent field (correlation condition)
- Correlation can be standalone or inside `and()`
- Child queries support `.orderBy()` and `.limit()` (applied per parent)
- Includes nest arbitrarily (projects → issues → comments)
- Aggregates like `count()` work in child queries, computed per parent

## Return Value Structure

`useLiveQuery` returns an object with:

```typescript
{
  data: TResult[],                      // Reactive array (Solid store) - NO () needed
  state: ReactiveMap<TKey, TResult>,   // Granular reactive map
  collection: Accessor<Collection>,     // Underlying collection (call with ())
  status: Accessor<CollectionStatus>,   // 'loading' | 'ready' | 'error' | etc (call with ())
  isLoading: Accessor<boolean>,         // Call with ()
  isReady: Accessor<boolean>,           // Call with ()
  isIdle: Accessor<boolean>,            // Call with ()
  isError: Accessor<boolean>,           // Call with ()
  isCleanedUp: Accessor<boolean>        // Call with ()
}
```

**Key Point**: `data` is a **reactive array** (Solid store), NOT an accessor function. Access it as `query.data`, not `query.data()`.

## ⚠️ Avoid Client-Side Filtering - Use Query Builder Instead

**IMPORTANT**: Always push filtering, sorting, and aggregation into the TanStack DB query builder for dramatically better performance through differential dataflow:

```typescript
// ❌ DON'T: Filter in JavaScript
const query = useLiveQuery(() => db.collections.events);
const filteredEvents = createMemo(() => {
  return query.data
    .filter(event => event.language === 'en')
    .sort((a, b) => new Date(b.timestamp).getTime() - new Date(a.timestamp).getTime())
    .slice(0, 100);
});

// ✅ DO: Push into query builder
const filteredEvents = useLiveQuery((q) =>
  q.from({ events: db.collections.events })
    .where(({ events }) => eq(events.language, 'en'))
    .orderBy(({ events }) => events.timestamp, 'desc')
    .limit(100)
);
```

**Why?** TanStack DB's differential dataflow only recomputes affected results incrementally. JavaScript filtering recomputes everything on every change.

## Status Handling

```typescript
const query = useLiveQuery(() => db.collections.events);

return (
  <Switch>
    <Match when={query.isLoading()}>
      <LoadingSpinner />
    </Match>
    <Match when={query.isError()}>
      <ErrorMessage />
    </Match>
    <Match when={query.isReady()}>
      <For each={query.data}>
        {(item) => <ItemCard item={item} />}
      </For>
    </Match>
  </Switch>
);
```

## Common Mistakes

### ❌ DON'T: Manual subscription management
```typescript
// Old manual way - DON'T DO THIS
const [events, setEvents] = createSignal([]);
onMount(() => {
  const subscription = db.collections.events.subscribeChanges(() => {
    setEvents(Array.from(db.collections.events.values()));
  });
  onCleanup(() => subscription.unsubscribe());
});
```

### ✅ DO: Use useLiveQuery
```typescript
// Correct way - use useLiveQuery
const query = useLiveQuery(() => db.collections.events);
const events = query.data; // It's already reactive
```

### ❌ DON'T: Call data as a function
```typescript
// Wrong - data is a store array, not an accessor function
<For each={query.data()}>
```

### ✅ DO: Access data directly (it's already reactive)
```typescript
// Correct - data is a reactive array
<For each={query.data}>
```

### ✅ DO: Call status accessor functions
```typescript
// Correct - status accessors ARE functions
if (query.isLoading()) {
  return <Spinner />;
}
```

## Performance Tips

1. **Use query-level filtering** when possible (pushed to TanStack DB)
2. **Use createMemo** for client-side filtering (only recomputes on dependency changes)
3. **Limit results** with `.limit()` in the query or `.slice()` in createMemo
4. **Use state.get(key)** for individual item access (granular reactivity)

```typescript
const query = useLiveQuery(() => db.collections.events);

// Granular access - only re-renders when THIS event changes
const specificEvent = () => query.state.get(eventId);
```

## Integration with StreamDB

StreamDB collections ARE TanStack DB collections, so useLiveQuery works directly:

```typescript
const db = await createStreamDB({
  streamOptions: { url: streamUrl },
  state: stateSchema,
});

// db.collections.events is a TanStack DB Collection
const query = useLiveQuery(() => db.collections.events);
```

## Query Builder Operators

Available in `where()` clauses:

- `eq(field, value)` - equals
- `ne(field, value)` - not equals
- `gt(field, value)` - greater than
- `gte(field, value)` - greater than or equal
- `lt(field, value)` - less than
- `lte(field, value)` - less than or equal
- `like(field, pattern)` - string pattern matching
- `inArray(field, array)` - value in array
- `between(field, min, max)` - value in range
- `and(cond1, cond2, ...)` - combine conditions with AND
- `or(cond1, cond2, ...)` - combine conditions with OR

## Aggregation Functions

Available in `select()` clauses after `groupBy()`, or inside includes child queries (computed per parent):

- `count(field)` - count non-null values of field
- `sum(field)` - sum of numeric field
- `avg(field)` - average of numeric field
- `min(field)` - minimum value
- `max(field)` - maximum value

### GroupBy with Aggregation and Ordering

To order by aggregated fields, use a subquery pattern:

```typescript
const topLanguages = useLiveQuery((q) => {
  const languageCounts = q.from({ events: db.collections.events })
    .groupBy(({ events }) => events.language)
    .select(({ events }) => ({
      language: events.language,
      count: count(events.id),
    }));

  return q.from({ stats: languageCounts })
    .orderBy(({ stats }) => stats.count, 'desc')
    .limit(10);
});
```

## References

- [TanStack DB Live Queries Guide](https://tanstack.com/db/latest/docs/guides/live-queries)
- [TanStack DB Solid Reference](https://tanstack.com/db/latest/docs/framework/solid/reference/index)
- [Solid.js Reactivity Docs](https://docs.solidjs.com/concepts/intro-to-reactivity)
