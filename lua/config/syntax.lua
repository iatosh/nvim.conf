-- lua/config/syntax.lua
-- 端末パレットの「ANSIスロット」を「構文上の役割」に割り当てる層。
-- termcolors.nvim の既定対応は「blue=型 / magenta=キーワード」という一般的なパレット前提で、
-- Monokai Pro のように ANSI 4(blue)=オレンジ のテーマだと型や識別子が全部オレンジになる。
-- そこで monokai-pro.nvim (filter = "pro") の配色を基準に、役割ごとにスロットを明示する。
-- 色の値は端末から取得したパレットなので、テーマの色味が変わっても追従する
-- (スロットの意味が違うテーマに変えたときは SLOTS だけ直せばよい)。
local M = {}

-- 役割 → ANSI番号(0-15)。Ghostty "Monokai Pro" の並びに合わせてある
M.SLOTS = {
  pink = 1, -- キーワード / 演算子 / タグ
  green = 2, -- 関数 / 属性
  yellow = 3, -- 文字列 / 見出し
  orange = 4, -- 引数 / 警告 / 特殊文字
  purple = 5, -- 定数 / 数値
  cyan = 6, -- 型 / モジュール
  comment = 8, -- コメント
}

---@param p table  collect_palette() の結果 (p.v[1..16] = ansi0..15, p.fg, p.bg)
---@param mix fun(a:string,b:string,t:number):string  a→b へ t(0..1) 寄せる
---@return table<string, vim.api.keyset.highlight>
function M.groups(p, mix)
  local function slot(name)
    return p.v[M.SLOTS[name] + 1]
  end
  local pink, green, yellow = slot("pink"), slot("green"), slot("yellow")
  local orange, purple, cyan = slot("orange"), slot("purple"), slot("cyan")
  local comment = slot("comment")
  local fg, bg = p.fg, p.bg

  -- fg側へ t 寄せた色 (bgを基準に明るさの段階を作る)
  local function lift(t)
    return mix(bg, fg, t)
  end
  local linenr = lift(0.22) -- 行番号
  local punct = lift(0.48) -- 括弧・区切り
  local cursorlinenr = lift(0.72)
  local selection = lift(0.17) -- Visual
  -- 透過+ブラーの背景は見た目が bg より明るく青みがかる。不透明な現在行が「穴」に見えないよう、はっきり明るめにする
  local cursorline = lift(0.10)
  local search = lift(0.22)
  local folded = lift(0.09)
  local dark = p.v[1] -- ansi0: 黄色背景などに載せる暗い文字色

  local it = true
  local g = {
    -- ===== エディタUI =====
    LineNr = { fg = linenr },
    LineNrAbove = { fg = linenr },
    LineNrBelow = { fg = linenr },
    CursorLine = { bg = cursorline },
    CursorLineNr = { fg = cursorlinenr, bg = cursorline, bold = true },
    CursorLineSign = { bg = cursorline },
    CursorLineFold = { bg = cursorline },
    NonText = { fg = lift(0.14) },
    Whitespace = { fg = linenr },
    EndOfBuffer = { fg = bg },
    Conceal = { fg = comment },
    Visual = { bg = selection },
    VisualNOS = { bg = selection },
    Search = { bg = search },
    IncSearch = { fg = dark, bg = yellow, bold = true },
    CurSearch = { fg = dark, bg = yellow, bold = true },
    Substitute = { fg = dark, bg = orange },
    MatchParen = { fg = yellow, bold = true, underline = true },
    Folded = { fg = comment, bg = folded },
    Directory = { fg = cyan },
    Title = { fg = yellow, bold = true },
    Question = { fg = cyan },
    MoreMsg = { fg = yellow },
    ModeMsg = { fg = fg },
    ErrorMsg = { fg = pink },
    WarningMsg = { fg = orange },
    Error = { fg = pink },
    Todo = { fg = purple, bold = true },
    SpecialKey = { fg = linenr },
    Underlined = { underline = true },
    SpellBad = { sp = pink, undercurl = true },
    SpellCap = { sp = yellow, undercurl = true },
    SpellRare = { sp = purple, undercurl = true },
    SpellLocal = { sp = cyan, undercurl = true },

    -- ===== Diff / Git =====
    DiffAdd = { bg = mix(green, bg, 0.88) },
    DiffChange = { bg = mix(yellow, bg, 0.9) },
    DiffDelete = { fg = mix(pink, bg, 0.55), bg = mix(pink, bg, 0.88) },
    DiffText = { bg = mix(yellow, bg, 0.72) },
    Added = { fg = green },
    Changed = { fg = cyan },
    Removed = { fg = pink },

    -- ===== 診断 =====
    DiagnosticError = { fg = pink },
    DiagnosticWarn = { fg = orange },
    DiagnosticInfo = { fg = cyan },
    DiagnosticHint = { fg = cyan },
    DiagnosticOk = { fg = green },
    DiagnosticUnderlineError = { sp = pink, undercurl = true },
    DiagnosticUnderlineWarn = { sp = orange, undercurl = true },
    DiagnosticUnderlineInfo = { sp = cyan, undercurl = true },
    DiagnosticUnderlineHint = { sp = cyan, undercurl = true },
    DiagnosticUnderlineOk = { sp = green, undercurl = true },
    DiagnosticVirtualTextError = { fg = pink, bg = mix(pink, bg, 0.9) },
    DiagnosticVirtualTextWarn = { fg = orange, bg = mix(orange, bg, 0.9) },
    DiagnosticVirtualTextInfo = { fg = cyan, bg = mix(cyan, bg, 0.9) },
    DiagnosticVirtualTextHint = { fg = cyan, bg = mix(cyan, bg, 0.9) },
    DiagnosticVirtualTextOk = { fg = green, bg = mix(green, bg, 0.9) },

    -- ===== 構文 (vim標準グループ) =====
    Comment = { fg = comment, italic = it },
    Identifier = { fg = fg },
    Function = { fg = green },
    Statement = { fg = purple },
    Conditional = { fg = pink },
    Repeat = { fg = pink },
    Label = { fg = pink },
    Keyword = { fg = pink, italic = it },
    Exception = { fg = pink },
    Operator = { fg = pink },
    PreProc = { fg = yellow },
    Include = { fg = pink },
    Define = { fg = pink },
    Macro = { fg = green },
    PreCondit = { fg = pink },
    Type = { fg = fg },
    StorageClass = { fg = pink, italic = it },
    Structure = { fg = cyan, italic = it },
    Typedef = { fg = pink },
    Constant = { fg = purple },
    String = { fg = yellow },
    Character = { fg = purple },
    Number = { fg = purple },
    Boolean = { fg = purple },
    Float = { fg = purple },
    Special = { fg = orange },
    SpecialChar = { fg = orange },
    SpecialComment = { fg = comment, italic = it },
    Delimiter = { fg = fg },
    Debug = { fg = orange },
    Tag = { fg = orange },

    -- ===== Treesitter =====
    ["@variable"] = { fg = fg },
    ["@variable.builtin"] = { fg = cursorlinenr, italic = it },
    ["@variable.parameter"] = { fg = orange, italic = it },
    ["@variable.member"] = { fg = fg },
    ["@property"] = { fg = fg },
    ["@field"] = { fg = fg },
    ["@constant"] = { fg = purple },
    ["@constant.builtin"] = { fg = purple },
    ["@constant.macro"] = { fg = purple },
    ["@module"] = { fg = cyan },
    ["@module.builtin"] = { fg = cyan },
    ["@label"] = { fg = pink },
    ["@type"] = { fg = cyan },
    ["@type.builtin"] = { fg = cyan, italic = it },
    ["@type.definition"] = { fg = cyan },
    ["@attribute"] = { fg = green },
    ["@function"] = { fg = green },
    ["@function.call"] = { fg = green },
    ["@function.builtin"] = { fg = green },
    ["@function.method"] = { fg = green },
    ["@function.method.call"] = { fg = green },
    ["@function.macro"] = { fg = green },
    ["@constructor"] = { fg = green },
    ["@keyword"] = { fg = pink, italic = it },
    ["@keyword.function"] = { fg = cyan, italic = it },
    ["@keyword.import"] = { fg = pink },
    ["@keyword.return"] = { fg = pink },
    ["@keyword.operator"] = { fg = pink },
    ["@keyword.modifier"] = { fg = pink, italic = it },
    ["@keyword.conditional"] = { fg = pink },
    ["@keyword.repeat"] = { fg = pink },
    ["@keyword.exception"] = { fg = pink },
    ["@operator"] = { fg = pink },
    ["@punctuation.bracket"] = { fg = pink },
    ["@punctuation.delimiter"] = { fg = punct },
    ["@punctuation.special"] = { fg = punct },
    ["@string"] = { fg = yellow },
    ["@string.escape"] = { fg = purple },
    ["@string.regexp"] = { fg = yellow },
    ["@string.special"] = { fg = purple },
    ["@string.special.url"] = { fg = orange, underline = true },
    ["@character"] = { fg = purple },
    ["@number"] = { fg = purple },
    ["@number.float"] = { fg = purple },
    ["@boolean"] = { fg = purple },
    ["@comment"] = { fg = comment, italic = it },
    ["@comment.todo"] = { fg = purple, bold = true },
    ["@comment.note"] = { fg = cyan, bold = true },
    ["@comment.warning"] = { fg = orange, bold = true },
    ["@comment.error"] = { fg = pink, bold = true },
    ["@tag"] = { fg = pink },
    ["@tag.attribute"] = { fg = cyan, italic = it },
    ["@tag.delimiter"] = { fg = punct },
    ["@markup.heading"] = { fg = green, bold = true },
    ["@markup.strong"] = { fg = fg, bold = true },
    ["@markup.italic"] = { fg = fg, italic = true },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.underline"] = { underline = true },
    ["@markup.link"] = { fg = orange },
    ["@markup.link.label"] = { fg = cyan },
    ["@markup.link.url"] = { fg = orange, underline = true },
    ["@markup.raw"] = { fg = yellow },
    ["@markup.list"] = { fg = fg },
    ["@markup.quote"] = { fg = comment, italic = true },
    ["@diff.plus"] = { fg = green },
    ["@diff.minus"] = { fg = pink },
    ["@diff.delta"] = { fg = yellow },
  }
  return g
end

return M
