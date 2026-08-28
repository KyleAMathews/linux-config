---
name: surf-cli
description: Control a Chrome browser with surf-cli. Use when the user asks to use Surf or an existing Surf browser session.
---

# Surf CLI - Browser Automation for AI Agents

Skill for using surf-cli to control Chrome browsers. This tool enables browser automation through simple CLI commands over Unix sockets.

**IMPORTANT**: Always use `npx surf` instead of a globally installed `surf` command.

## Prerequisites

1. Chrome must be running with the Surf extension loaded
2. First run `npx surf` to verify connection to browser

## Core Commands

### Navigation

```bash
# Navigate to a URL
npx surf go "https://example.com"

# Back/forward navigation
npx surf back
npx surf forward

# Reload the page
npx surf tab.reload
```

### Reading Page Content

```bash
# Get accessibility tree + visible text (best for understanding page structure)
npx surf read

# Get just the text content
npx surf page.text

# Get page state (URL, title, etc.)
npx surf page.state
```

### Screenshots

```bash
# Take a screenshot (auto-resized to 1200px for token efficiency)
npx surf screenshot

# Full resolution screenshot
npx surf screenshot --full

# Screenshot with element annotations
npx surf snap
```

### Interaction

```bash
# Click an element (use CSS selector or text)
npx surf click "button.submit"
npx surf click "Sign In"

# Type text into focused element
npx surf type "hello world"

# Type into specific element
npx surf type "hello world" --selector "input[name=email]"

# Press keyboard keys
npx surf key "Enter"
npx surf key "Tab"
npx surf key "Escape"

# Scroll
npx surf scroll down
npx surf scroll up
npx surf scroll "selector"  # Scroll element into view
```

### Tab Management

```bash
# List all tabs
npx surf tab.list

# Open new tab
npx surf tab.new "https://example.com"

# Switch to tab by index or name
npx surf tab.switch 2
npx surf tab.switch "Gmail"

# Close current tab
npx surf tab.close

# Name current tab (for easier switching)
npx surf tab.name "My Tab"
```

### AI Service Integration

Use the browser's logged-in sessions to interact with AI services:

```bash
# Send prompt to ChatGPT
npx surf chatgpt "Explain quantum computing"

# Send prompt to Gemini
npx surf gemini "Write a haiku about coding"

# Send prompt to Perplexity
npx surf perplexity "Latest news on AI"
```

## Common Workflows

### Form Filling

```bash
# Navigate to form
npx surf go "https://example.com/login"

# Fill fields
npx surf click "input[name=email]"
npx surf type "user@example.com"
npx surf key "Tab"
npx surf type "password123"

# Submit
npx surf click "button[type=submit]"

# Verify result
npx surf screenshot
```

### Web Scraping/Reading

```bash
# Navigate and wait for content
npx surf go "https://example.com/article"

# Get page content
npx surf read

# Take screenshot for visual verification
npx surf screenshot
```

### Multi-Tab Workflow

```bash
# Open multiple research tabs
npx surf tab.new "https://docs.example.com"
npx surf tab.name "Docs"
npx surf tab.new "https://github.com/repo"
npx surf tab.name "GitHub"

# Switch between them
npx surf tab.switch "Docs"
npx surf read
npx surf tab.switch "GitHub"
npx surf read
```

## Smart Defaults

- Screenshots auto-resize to 1200px to conserve tokens
- Actions automatically capture screenshots (reduces round-trips)
- Network requests are logged automatically

## Troubleshooting

```bash
# Check connection status
npx surf

# If no connection, ensure:
# 1. Chrome is running
# 2. Surf extension is installed and enabled
# 3. Extension has connected (check extension popup)
```

## Tips

1. Use `npx surf read` to understand page structure before clicking
2. Use `npx surf snap` to see annotated elements when unsure what to click
3. Name tabs with `npx surf tab.name` for easier management in multi-tab workflows
4. Actions return screenshots automatically - check results after each interaction
