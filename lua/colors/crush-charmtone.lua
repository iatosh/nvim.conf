-- Crush-like theme based on CharmTone palette used by charmbracelet/crush.
-- Palette source: charmtone.go (as provided)

local C = {
  -- Accent / brand
  charple  = "#6B50FF",
  dolly    = "#FF60FF",
  bok      = "#68FFD6",
  zest     = "#E8FE96",

  -- Backgrounds
  pepper   = "#201F26",
  bbq      = "#2D2C35",
  charcoal = "#3A3943",
  iron     = "#4D4C57",

  -- Foregrounds
  oyster   = "#605F6B",
  squid    = "#858392",
  smoke    = "#BFBCC8",
  ash      = "#DFDBDD",
  salt     = "#F1EFEF",
  butter   = "#FFFAF1",

  -- Status
  guac     = "#12C78F",
  sriracha = "#EB4268",
  malibu   = "#00A4FF",
  citron   = "#E8FF27",
  mustard  = "#F5EF34",

  -- Extra useful hues
  coral    = "#FF577D",
  tuna     = "#FF6DAA",
  zinc     = "#10B1AE",
  turtle   = "#0ADCD9",
  violet   = "#C259FF",
  cumin    = "#BF976F",

  -- Diff helper hues (from your charmtone.go: Spinach/Toast)
  spinach  = "#1C3634",
  toast    = "#412130",
}

local function hi(group, spec)
  vim.api.nvim_set_hl(0, group, spec)
end

vim.o.termguicolors = true
vim.o.background = "dark"
vim.g.colors_name = "crush-charmtone"

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

-- Core UI
hi("Normal",       { fg = C.ash, bg = C.pepper })
hi("NormalNC",     { fg = C.ash, bg = C.pepper })
hi("EndOfBuffer",  { fg = C.pepper, bg = C.pepper })

hi("Cursor",       { fg = C.pepper, bg = C.dolly })
hi("CursorLine",   { bg = C.bbq })
hi("CursorColumn", { bg = C.bbq })
hi("ColorColumn",  { bg = C.bbq })

hi("Visual",       { fg = C.salt, bg = C.charple })
hi("Search",       { fg = C.pepper, bg = C.zest })
hi("IncSearch",    { fg = C.pepper, bg = C.citron })

hi("LineNr",       { fg = C.oyster, bg = C.pepper })
hi("CursorLineNr", { fg = C.smoke, bg = C.pepper, bold = true })
hi("SignColumn",   { fg = C.oyster, bg = C.pepper })
hi("FoldColumn",   { fg = C.oyster, bg = C.pepper })
hi("Folded",       { fg = C.squid, bg = C.bbq })

hi("VertSplit",    { fg = C.charcoal, bg = C.pepper })
hi("WinSeparator", { fg = C.charcoal, bg = C.pepper })

hi("StatusLine",   { fg = C.ash, bg = C.bbq })
hi("StatusLineNC", { fg = C.squid, bg = C.pepper })

hi("TabLine",      { fg = C.squid, bg = C.pepper })
hi("TabLineFill",  { fg = C.squid, bg = C.pepper })
hi("TabLineSel",   { fg = C.salt, bg = C.bbq, bold = true })

hi("Pmenu",        { fg = C.ash, bg = C.charcoal })
hi("PmenuSel",     { fg = C.salt, bg = C.charple, bold = true })
hi("PmenuSbar",    { bg = C.charcoal })
hi("PmenuThumb",   { bg = C.iron })

hi("FloatBorder",  { fg = C.charcoal, bg = C.pepper })
hi("NormalFloat",  { fg = C.ash, bg = C.pepper })

hi("MatchParen",   { fg = C.pepper, bg = C.bok, bold = true })

-- Messages
hi("Title",        { fg = C.zest, bold = true })
hi("Question",     { fg = C.bok })
hi("MoreMsg",      { fg = C.bok })
hi("WarningMsg",   { fg = C.zest })
hi("ErrorMsg",     { fg = C.sriracha, bold = true })

-- Basic syntax (fallback when not using treesitter links)
hi("Comment",      { fg = C.oyster, italic = true })
hi("Constant",     { fg = C.violet })
hi("String",       { fg = C.cumin })
hi("Character",    { fg = C.cumin })
hi("Number",       { fg = C.bok })
hi("Boolean",      { fg = C.violet })
hi("Float",        { fg = C.bok })

hi("Identifier",   { fg = C.ash })
hi("Function",     { fg = C.guac })

hi("Statement",    { fg = C.malibu })
hi("Conditional",  { fg = C.malibu })
hi("Repeat",       { fg = C.malibu })
hi("Label",        { fg = C.malibu })
hi("Operator",     { fg = C.smoke })
hi("Keyword",      { fg = C.malibu })
hi("Exception",    { fg = C.coral })

hi("PreProc",      { fg = C.citron })
hi("Include",      { fg = C.malibu })
hi("Define",       { fg = C.citron })
hi("Macro",        { fg = C.citron })

hi("Type",         { fg = C.turtle })
hi("Special",      { fg = C.dolly })
hi("Delimiter",    { fg = C.smoke })
hi("Underlined",   { fg = C.malibu, underline = true })
hi("Todo",         { fg = C.pepper, bg = C.zest, bold = true })

-- Diff
hi("DiffAdd",      { bg = C.spinach })
hi("DiffChange",   { bg = C.charcoal })
hi("DiffDelete",   { bg = C.toast })
hi("DiffText",     { bg = C.iron, bold = true })

-- Diagnostics (LSP)
hi("DiagnosticError", { fg = C.sriracha })
hi("DiagnosticWarn",  { fg = C.zest })
hi("DiagnosticInfo",  { fg = C.malibu })
hi("DiagnosticHint",  { fg = C.smoke })

hi("DiagnosticUnderlineError", { undercurl = true, sp = C.sriracha })
hi("DiagnosticUnderlineWarn",  { undercurl = true, sp = C.zest })
hi("DiagnosticUnderlineInfo",  { undercurl = true, sp = C.malibu })
hi("DiagnosticUnderlineHint",  { undercurl = true, sp = C.smoke })

-- LSP references
hi("LspReferenceText",  { bg = C.bbq })
hi("LspReferenceRead",  { bg = C.bbq })
hi("LspReferenceWrite", { bg = C.bbq })

-- Conventional git groups (plugins often link to these)
hi("Added",   { fg = C.guac })
hi("Changed", { fg = C.malibu })
hi("Removed", { fg = C.sriracha })
