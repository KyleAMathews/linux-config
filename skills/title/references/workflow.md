---
description: Generate and set a contextual Ghostty tab title based on current work
---

Generate a concise tab title (2-5 words) based on:
- The current project/directory
- Recent conversation topics and tasks
- What's currently being worked on
- Any additional context the user provided after `/title`

Good title examples: "auth refactor", "API debugging", "hook notifications", "test fixes"

To set the title, write ONLY the generated title text (no newline, no quotes, no escape sequences) to this file:

~/.claude-tab-title

A hook will detect this write and apply the title to Ghostty.

After writing, confirm what title was set.
