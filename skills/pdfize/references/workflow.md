---
description: Convert a Markdown file to PDF with the user's pdfize shell function and open it
---

Convert the requested Markdown file to a PDF by running the user's `pdfize` shell function.

## Inputs

Use the text after `/pdfize` as the Markdown file path. If no path is provided, ask for the Markdown file path before running anything.

Examples:

- `/pdfize docs/spec.md`
- `/pdfize docs/superpowers/specs/2026-03-23-wake-registry-tanstack-db-design.md`

## Workflow

1. Resolve the Markdown file path relative to the current working directory unless the user provided an absolute path.
2. Verify the file exists and ends in `.md`. If it does not exist, report the missing path. If it is not a Markdown file, ask whether to continue.
3. Run prettier to format the markdown, then `pdfize` through zsh with the user's shell config loaded, because `pdfize` is defined in `~/.zshrc`:

   ```bash
   prettier --write "<markdown-file>" && zsh -lc 'source ~/.zshrc && pdfize "$1"' -- <markdown-file>
   ```

4. Report success or failure faithfully. On success, mention the expected PDF path, which is the input path with `.md` replaced by `.pdf`.

5. Report success after the conversion command succeeds and the expected PDF exists. **Visual verification is optional by default.** If the user reports a rendering problem or explicitly requests visual QA, render the relevant pages with Poppler (`pdftoppm -png`) and inspect them for overlaps, clipping, black blocks, and unreadable columns.

## Long Markdown Tables and Typst Pagination

Pandoc's Typst writer wraps Markdown tables in Typst `figure` elements by default. A Typst figure is an unbreakable block, so a table taller than one page can overflow and collapse many rows onto one another even though native Typst tables support multipage breaking.

The preferred workaround is to add Pandoc's `typst:no-figure` class to every table with the bundled Lua filter. This emits bare Typst tables, which paginate normally and repeat their header rows:

```bash
prettier --write "<markdown-file>" && \
  skill_dir=${CLAUDE_SKILL_DIR:-$HOME/.agents/skills/pdfize} && \
  pandoc "<markdown-file>" \
    -o "<output.pdf>" \
    --pdf-engine=typst \
    --lua-filter="$skill_dir/scripts/typst-tables.lua" && \
  open "<output.pdf>"
```

Use this path automatically when a Markdown document contains a table likely to exceed one page. It is preferable to manually splitting one logical table into many smaller tables because it preserves the table's semantics, lets Typst choose page breaks, and repeats the header on each page.

If a table still cannot break because another wrapper is present, Typst's documented fallback is to make figure blocks breakable with `#show figure: set block(breakable: true)`. Prefer `typst:no-figure` for ordinary uncaptained Markdown tables.

For wide tables, pagination and width are separate problems. After fixing page breaking, reduce the column count, combine tightly related numeric columns, or use a landscape page. Never shrink text until it is technically present but difficult to read.

Research basis:

- Typst's official table guide says native tables break across pages and `table.header` repeats automatically; figures are unbreakable unless their block is made breakable: https://typst.app/docs/guides/tables/
- Pandoc's official Typst property documentation says tables are wrapped in figures by default and `typst:no-figure` emits only the table: https://pandoc.org/typst-property-output.html

## Font Options

Use `--font <name>` to change the typeface. Default is the system default (usually New Computer Modern).

| Flag Value | Font | Character |
|------------|------|-----------|
| `libertinus` | Libertinus Serif | Open-source, professional, book-quality |
| `source` | Source Serif 4 | Adobe, clean and modern |
| `charter` | Charter | Matthew Carter, excellent screen/print |
| `palatino` | Palatino | Classic humanist, very readable |
| `baskerville` | Baskerville | Elegant transitional serif |
| `caslon` | Big Caslon | Stately, old-style |
| `georgia` | Georgia | Designed for screen, holds up in print |
| `pt` | PT Serif | ParaType, good for long-form |

Examples:
- `/pdfize docs/essay.md --font palatino`
- `/pdfize docs/essay.md --font charter`

When a font is specified, bypass the shell function and compile directly with typst:

```bash
pandoc "<input>.md" -t typst -o /tmp/content.typ

cat > /tmp/font-prefix.typ << 'EOF'
#set text(font: "<Font Name>")
#let horizontalrule = line(start: (25%,0%), end: (75%,0%))
EOF

cat /tmp/font-prefix.typ /tmp/content.typ > /tmp/final.typ
typst compile /tmp/final.typ "<output>.pdf" && open "<output>.pdf"
```

## Notes

The current `pdfize` function is expected to behave like:

```zsh
pdfize () {
  local pdf="${1%.md}.pdf"
  pandoc "$1" -o "$pdf" --pdf-engine=typst && open "$pdf"
}
```

When no font is specified, prefer using their shell function so local behavior stays consistent.

## Mobile / Custom Page Size

Pandoc's `-V papersize` only accepts named sizes (a4, a6, us-letter, etc.) and keeps default large margins — not suitable for mobile. For mobile-friendly PDFs, bypass pandoc and compile Typst directly:

1. Convert Markdown to Typst:
   ```bash
   pandoc "<input>.md" -t typst -o /tmp/content.typ
   ```

2. Create a prefix with mobile page settings:
   ```bash
   cat > /tmp/mobile-prefix.typ << 'EOF'
   #set page(width: 4in, height: 7in, margin: (x: 0.3in, y: 0.4in))
   #set text(size: 9pt)
   #let horizontalrule = line(start: (25%,0%), end: (75%,0%))
   EOF
   ```

3. Combine and compile:
   ```bash
   cat /tmp/mobile-prefix.typ /tmp/content.typ > /tmp/final.typ
   typst compile /tmp/final.typ "<output>_mobile.pdf" && open "<output>_mobile.pdf"
   ```
