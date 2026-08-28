-- Pandoc's Typst writer wraps tables in figures by default. Typst figures are
-- unbreakable blocks, so a long Markdown table can overflow or overlap instead
-- of paginating. Emit bare Typst tables; Typst then breaks them across pages
-- and repeats table.header rows automatically.
function Table(table)
  table.classes:insert("typst:no-figure")
  return table
end
