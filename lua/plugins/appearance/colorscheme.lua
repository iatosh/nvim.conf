-- lua/plugins/appearance/colorscheme.lua
-- 端末(Ghostty)のテーマ・透過をそのまま受ける。herdrの theme = "terminal" と同じ考え方。
--
--  * パレット(ANSI 16色/fg/bg/cursor)は OSC 4/10/11/12 で端末に非同期に問い合わせる。
--    termcolors.nvim 標準の取得は io.read(1) で同期的に待つため、応答しない端末だと固まる。
--    ここでは待たずに TermResponse で受け取り、termcolors の term_colors() をキャッシュ返しに差し替える。
--  * 前回のパレットを state に保存し、次回起動時は即座に適用する(問い合わせ結果が来るまでの色ちらつき防止)。
--  * Ghosttyのテーマ変更は nvim が受ける DSR 通知→OSC 11 応答で検知し、パレットを取り直す。
--  * 背景は bg=NONE にして端末側の background-opacity / blur をそのまま透かす
--    (Ghosttyは background-opacity を「デフォルト背景のセル」にしか適用しないため、明示bgは不透明な塗りになる)。
local cache_file = vim.fn.stdpath("state") .. "/terminal-palette.json"
local QUERY_TIMEOUT_MS = 1500

return {
  "https://gitlab.com/kylesower/termcolors.nvim",
  name = "termcolors.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    local termcolors = require("termcolors")
    local term = require("termcolors.term")
    local tc = require("termcolors.colors")

    -- setup()は同期クエリ前提のTermResponseハンドラを登録してしまうので呼ばず、configだけ直接設定する
    termcolors.config = { term_colors_only = false, color_adjust_amount = 0.03, debug = false }

    ---@type TermColors?
    local palette
    local pending ---@type { values: table, fg?: string, bg?: string, cursor?: string, timer: uv.uv_timer_t }?

    -- termcolors内部の term.term_colors() をキャッシュ返しに差し替える (絶対にブロックしない)
    term.term_colors = function()
      if not palette then
        error("terminal palette not available yet")
      end
      return palette
    end

    -- fgとbgの間をt(0=fg, 1=bg)で線形補間し、薄れ具合の段階を作る
    local function mix(hex_a, hex_b, t)
      local a, b = tc.hex_to_rgb(hex_a), tc.hex_to_rgb(hex_b)
      return tc.rgb_to_hex({
        r = a.r + (b.r - a.r) * t,
        g = a.g + (b.g - a.g) * t,
        b = a.b + (b.b - a.b) * t,
      })
    end

    ---@return table?
    local function derive_palette()
      if not palette then
        return nil
      end
      local colors = palette
      local is_dark = tc.rgb_to_hsl(tc.hex_to_rgb(colors.bg)).l < 0.5
      -- パネル背景などは本文背景よりさらに背景寄りに動かす方向
      local toward_bg = is_dark and tc.lighten or tc.darken
      local away_from_bg = is_dark and tc.darken or tc.lighten

      local v = colors.values -- v[1]=ansi0(black) .. v[16]=ansi15(bright white)
      return {
        v = v,
        fg = colors.fg,
        bg = colors.bg,
        black = v[1],
        red = v[10],
        green = v[11],
        yellow = v[12],
        blue = v[13],
        magenta = v[14],
        cyan = v[15],
        white = v[16],
        sidebar_bg = toward_bg(colors.bg, 0.04),
        selection_bg = toward_bg(colors.bg, 0.08),
        active_selection_bg = toward_bg(colors.bg, 0.14),
        border = away_from_bg(colors.bg, 0.10),
        dimmed1 = mix(colors.fg, colors.bg, 0.35),
        dimmed2 = mix(colors.fg, colors.bg, 0.50),
        dimmed3 = mix(colors.fg, colors.bg, 0.65),
        dimmed4 = mix(colors.fg, colors.bg, 0.80),
      }
    end

    local function set_hl(name, hl)
      vim.api.nvim_set_hl(0, name, hl)
    end

    local function apply_overrides()
      local p = derive_palette()
      if not p then
        return
      end

      local cursorline = mix(p.bg, p.fg, 0.10) -- syntax.lua の CursorLine と同じ値 (mini.files/snacksの選択行と揃える)

      -- ---- 構文・UIの配色: ANSIスロットを役割に割り当て直す (monokai-pro.nvim "pro" 基準。lua/config/syntax.lua) ----
      -- termcolors標準の対応は ANSI 4(blue)=型 前提で、Monokai Proだとオレンジばかりになるのでここで上書きする
      for name, hl in pairs(require("config.syntax").groups(p, mix)) do
        set_hl(name, hl)
      end

      -- ---- termcolorsの既定は ANSI 7 (Monokaiだとほぼ白 #fcfcfa) を bg に使うグループがあり、白抜けの原因になる ----
      set_hl("Pmenu", { fg = p.fg, bg = p.sidebar_bg })
      set_hl("PmenuSel", { fg = p.white, bg = p.active_selection_bg, bold = true })
      set_hl("PmenuKind", { fg = p.cyan, bg = p.sidebar_bg })
      set_hl("PmenuKindSel", { fg = p.cyan, bg = p.active_selection_bg })
      set_hl("PmenuExtra", { fg = p.dimmed2, bg = p.sidebar_bg })
      set_hl("PmenuExtraSel", { fg = p.dimmed1, bg = p.active_selection_bg })
      set_hl("PmenuSbar", { bg = p.selection_bg })
      set_hl("PmenuThumb", { bg = p.dimmed3 })
      set_hl("PmenuBorder", { fg = p.dimmed3, bg = p.sidebar_bg })
      set_hl("ColorColumn", { bg = p.selection_bg })

      -- ---- 透過: 端末のデフォルト背景に任せる (bg を持たせない) ----
      if vim.g.terminal_transparent == false then
        set_hl("Normal", { fg = p.fg, bg = p.bg })
        set_hl("NormalNC", { fg = p.fg, bg = p.bg })
      end
      for _, name in ipairs(vim.g.terminal_transparent == false and {} or {
        "Normal", "NormalNC", "EndOfBuffer", "SignColumn", "FoldColumn",
        "LineNr", "LineNrAbove", "LineNrBelow",
        "WinSeparator", "VertSplit", "MsgArea",
      }) do
        local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
        hl.bg, hl.ctermbg = nil, nil
        if name == "Normal" or name == "NormalNC" then
          hl.fg = p.fg
        end
        set_hl(name, hl)
      end
      -- StatusLine等は termcolors だと fg=背景色/bg=前景色の反転。bgを消すだけだと文字が見えなくなるので fg も直す
      for _, name in ipairs({ "StatusLine", "WinBar" }) do
        set_hl(name, { fg = p.fg, bold = true })
      end
      for _, name in ipairs({ "StatusLineNC", "WinBarNC" }) do
        set_hl(name, { fg = p.dimmed2 })
      end
      set_hl("StatusLineTerm", { fg = p.fg, bold = true })
      set_hl("StatusLineTermNC", { fg = p.dimmed2 })
      set_hl("WinSeparator", { fg = p.border })

      -- ---- フロート類 / mini.files / snacks: 背景なし(透過)。補完メニュー(Pmenu)だけは文字と重なるので不透明のまま ----
      set_hl("NormalFloat", { fg = p.fg })
      set_hl("FloatBorder", { fg = p.dimmed3 })
      set_hl("FloatTitle", { fg = p.white, bold = true })

      -- mini.files
      set_hl("MiniFilesNormal", { fg = p.fg })
      set_hl("MiniFilesBorder", { fg = p.dimmed3 })
      set_hl("MiniFilesBorderModified", { fg = p.yellow })
      set_hl("MiniFilesCursorLine", { bg = cursorline })
      set_hl("MiniFilesDirectory", { fg = p.cyan })
      set_hl("MiniFilesFile", { fg = p.white })
      set_hl("MiniFilesTitle", { fg = p.black, bg = p.yellow, bold = true })
      set_hl("MiniFilesTitleFocused", { fg = p.black, bg = p.yellow, bold = true })
      set_hl("MiniFilesModified", { fg = p.yellow })

      -- mini.icons (mini.filesで使用)
      set_hl("MiniIconsAzure", { fg = p.cyan })
      set_hl("MiniIconsBlue", { fg = p.blue })
      set_hl("MiniIconsCyan", { fg = p.cyan })
      set_hl("MiniIconsGreen", { fg = p.green })
      set_hl("MiniIconsGrey", { fg = p.dimmed2 })
      set_hl("MiniIconsOrange", { fg = p.blue })
      set_hl("MiniIconsPurple", { fg = p.magenta })
      set_hl("MiniIconsRed", { fg = p.red })
      set_hl("MiniIconsYellow", { fg = p.yellow })

      -- snacks.nvim
      set_hl("SnacksNormal", { fg = p.fg })
      set_hl("SnacksBorder", { fg = p.dimmed3 })
      set_hl("SnacksTitle", { fg = p.black, bg = p.yellow, bold = true })
      set_hl("SnacksFooter", { fg = p.green })
      set_hl("SnacksDesc", { fg = p.dimmed1 })
      set_hl("SnacksFile", { fg = p.white })

      -- snacks picker
      set_hl("SnacksPickerBorder", { fg = p.dimmed3 })
      set_hl("SnacksPickerDir", { fg = p.dimmed2 })
      set_hl("SnacksPickerFile", { fg = p.dimmed2 })
      set_hl("SnacksPickerFileIcon", { fg = p.dimmed2 })
      set_hl("SnacksPickerInput", { fg = p.fg })
      set_hl("SnacksPickerList", { fg = p.fg })
      set_hl("SnacksPickerNormal", { fg = p.fg })
      set_hl("SnacksPickerMatch", { fg = p.white, bold = true })
      set_hl("SnacksPickerMatchBorder", { fg = p.dimmed3 })
      set_hl("SnacksPickerPrompt", { fg = p.cyan })
      set_hl("SnacksPickerPromptNormal", { fg = p.white })
      set_hl("SnacksPickerPreview", { fg = p.fg })
      set_hl("SnacksPickerPreviewBorder", { fg = p.dimmed3 })
      set_hl("SnacksPickerPreviewTitle", { fg = p.white, bold = true })
      set_hl("SnacksPickerQuery", { fg = p.yellow })
      set_hl("SnacksPickerResults", { fg = p.fg })
      set_hl("SnacksPickerSelection", { fg = p.white, bg = cursorline })
      set_hl("SnacksPickerSelectionMatch", { fg = p.yellow, bg = cursorline, bold = true })
      set_hl("SnacksPickerTitle", { fg = p.white, bold = true })
      set_hl("SnacksPickerVirtualText", { fg = p.dimmed3 })

      -- snacks indent
      set_hl("SnacksIndent", { fg = mix(p.bg, p.fg, 0.12) })
      set_hl("SnacksIndentScope", { fg = mix(p.bg, p.fg, 0.40) })
      set_hl("SnacksIndentChunk", { fg = mix(p.bg, p.fg, 0.40) })

      -- nvim-notify はフェードの基準として背景色(bg)を持つグループを要求する。Normalを透過にしたので端末の実bgを持たせる
      set_hl("NotifyBackground", { fg = p.fg, bg = p.bg })

      vim.g.terminal_bg = p.bg -- modes.nvim等、背景色が必要なプラグイン用
    end

    local function save_cache()
      pcall(function()
        vim.fn.mkdir(vim.fn.stdpath("state"), "p")
        vim.fn.writefile({ vim.json.encode(palette) }, cache_file)
      end)
    end

    local function load_cache()
      local ok, lines = pcall(vim.fn.readfile, cache_file)
      if not ok or not lines[1] then
        return nil
      end
      local ok2, data = pcall(vim.json.decode, lines[1])
      if ok2 and type(data) == "table" and type(data.values) == "table" and #data.values == 16
          and data.fg and data.bg and data.cursor then
        return data
      end
    end

    -- パレットを反映する。変化がなければ何もしない
    local function apply(new)
      if vim.deep_equal(new, palette) then
        return
      end
      palette = new
      vim.o.background = tc.rgb_to_hsl(tc.hex_to_rgb(palette.bg)).l < 0.5 and "dark" or "light"
      termcolors.colors = nil -- 強制再ロード
      if pcall(termcolors.load) then
        apply_overrides()
        -- lualine / modes.nvim 等がハイライトを再計算できるように通知
        vim.api.nvim_exec_autocmds("ColorScheme", { modeline = false })
      end
    end

    local function finish_query()
      if not pending then
        return
      end
      local q = pending
      pending = nil
      if q.timer and not q.timer:is_closing() then
        q.timer:stop()
        q.timer:close()
      end
      for i = 1, 16 do
        if not q.values[i] then
          return -- 取り切れなかった(未対応の端末/マルチプレクサ): 保存済みのパレットをそのまま使う
        end
      end
      if not (q.fg and q.bg) then
        return
      end
      local new = { values = q.values, fg = q.fg, bg = q.bg, cursor = q.cursor or q.fg }
      vim.schedule(function()
        apply(new)
        save_cache()
      end)
    end

    -- 非同期クエリ開始。応答はTermResponseで受ける
    local function request_palette()
      if pending or #vim.api.nvim_list_uis() == 0 then
        return
      end
      local timer = assert(vim.uv.new_timer())
      pending = { values = {}, timer = timer }
      timer:start(QUERY_TIMEOUT_MS, 0, vim.schedule_wrap(finish_query))

      local seq = {}
      for i = 0, 15 do
        seq[#seq + 1] = ("\27]4;%d;?\27\\"):format(i)
      end
      seq[#seq + 1] = "\27]10;?\27\\\27]11;?\27\\\27]12;?\27\\"
      vim.api.nvim_ui_send(table.concat(seq))
    end

    vim.api.nvim_create_autocmd("TermResponse", {
      group = vim.api.nvim_create_augroup("terminal-palette", { clear = true }),
      callback = function(args)
        local seq = args.data.sequence
        local idx = seq:match("^\27%]4;(%d+);rgb:")
        local kind = idx and "idx" or seq:match("^\27%](1[012]);rgb:")
        if not kind then
          return
        end
        local hex = term.parse_query_result(seq)
        if not hex then
          return
        end

        if not pending then
          -- 自分の問い合わせではないOSC 11応答 = nvimが端末のテーマ変更通知を受けて取得した値 → パレット取り直し
          if kind == "11" and not (palette and palette.bg == hex) then
            request_palette()
          end
          return
        end

        if kind == "idx" then
          pending.values[tonumber(idx) + 1] = hex
        elseif kind == "10" then
          pending.fg = hex
        elseif kind == "11" then
          pending.bg = hex
        elseif kind == "12" then
          pending.cursor = hex
        end

        local n = 0
        for _ in pairs(pending.values) do
          n = n + 1
        end
        if n == 16 and pending.fg and pending.bg and pending.cursor then
          finish_query()
        end
      end,
    })

    vim.api.nvim_create_autocmd("UIEnter", {
      once = true,
      callback = function()
        vim.schedule(request_palette)
      end,
    })

    -- 透過のON/OFF (不具合時の切り分け・退避用)。環境変数 NVIM_OPAQUE=1 で起動時から不透明
    vim.g.terminal_transparent = vim.env.NVIM_OPAQUE == nil
    vim.api.nvim_create_user_command("TermTransparentToggle", function()
      vim.g.terminal_transparent = not vim.g.terminal_transparent
      termcolors.colors = nil
      if pcall(termcolors.load) then
        apply_overrides()
        vim.api.nvim_exec_autocmds("ColorScheme", { modeline = false })
      end
    end, { desc = "透過と不透明を切り替え" })

    vim.api.nvim_create_user_command("TermColorsReload", request_palette, {
      desc = "端末のパレットを問い合わせ直して反映",
    })

    -- 初回起動などパレット未取得の間も nvim-notify の警告が出ないよう、仮の背景を置いておく
    set_hl("NotifyBackground", { bg = "#000000" })

    -- 起動直後は前回のパレットで即塗る
    local cached = load_cache()
    if cached then
      apply(cached)
    end
  end,
}
