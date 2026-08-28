---
description: Publish an HTML file to a GitHub Gist and return a Gist Host URL
---

Publish the requested HTML file to Gist Host (`https://gisthost.github.io/`) by creating a GitHub Gist with the `gh` CLI.

Use this when the user asks to share, publish, host, preview, or make public a local `.html` file via Gist Host / gisthost.

## Inputs

Use the text after `/gisthost` as the HTML file path. If no path is provided, ask for the HTML file path before running anything.

Examples:

- `/gisthost index.html`
- `/gisthost ./dist/report.html`
- `/gisthost /tmp/demo.html`

## Workflow

1. Resolve the HTML file path relative to the current working directory unless the user provided an absolute path.
2. Verify the file exists and is a regular file. If it does not exist, report the missing path.
3. Verify the file extension is `.html` or `.htm`. If it is not, ask whether to continue.
4. Verify `gh` is installed and authenticated:

   ```bash
   command -v gh
   gh auth status
   ```

   In a sandboxed or restricted environment, the sandbox may not be able to read the host keyring. This can make `gh auth status` report an invalid token even when the host is already logged in.

   If `gh` exists but authentication fails in the sandbox:

   1. Retry `gh auth status` outside the sandbox, with the user's approval when required.
   2. If the outside-sandbox check succeeds, use that same environment for `gh gist create`. Do not start a new login flow.
   3. Ask the user to authenticate only if the outside-sandbox check also fails.

   Do not treat a sandbox-only authentication failure as proof that the user's GitHub login is invalid. Do not launch `gh auth login` when the user says the host is already authenticated; verify the host login first. If authentication is truly required, run `gh auth login -h github.com -w` outside the sandbox and avoid starting a second device flow while one is pending.

5. Create a public gist unless the user explicitly asks for a secret gist. If authentication was available only outside the sandbox, also run this command outside the sandbox:

   ```bash
   gh gist create "<html-file>" --public --desc "Published with Gist Host"
   ```

   For a secret gist, omit `--public`:

   ```bash
   gh gist create "<html-file>" --desc "Published with Gist Host"
   ```

6. Extract the Gist ID from the `gh gist create` output URL and report the Gist Host URL:

   ```text
   https://gisthost.github.io/?GIST_ID
   ```

7. Also report the original gist URL returned by `gh`.

## Notes

- Gist Host renders HTML files stored in GitHub Gists. It uses `index.html` when present; otherwise it renders the first file in the gist.
- Raw GitHub Gist URLs are served as plain text, so they do not render HTML directly in browsers.
- GitHub/Gist Host may cache results briefly. If the page looks stale, wait a few minutes and refresh.
- Creating a gist publishes content to GitHub. Confirm before publishing if the file may contain secrets, private data, or content the user has not clearly approved for sharing.
