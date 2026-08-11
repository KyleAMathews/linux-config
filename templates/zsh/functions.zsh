pdfize() {
  local source_file="$1"
  local pdf_file="${source_file%.md}.pdf"

  if [[ -z "$source_file" ]]; then
    echo "usage: pdfize FILE.md" >&2
    return 2
  fi

  prettier --write "$source_file" \
    && pandoc "$source_file" --output "$pdf_file" --pdf-engine=typst \
    && open "$pdf_file"
}
