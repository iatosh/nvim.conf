-- lua/plugins/appearance/lualine.lua
-- ピル型: モード(左)と位置(右)だけを丸い端付きのピルにし、間は背景なしで端末の透過に溶け込ませる。
-- 色は現在のハイライト(= 端末パレット由来)から組み立て、ColorScheme のたびに作り直す。
return {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local pill_left = vim.fn.nr2char(0xe0b6) --
    local pill_right = vim.fn.nr2char(0xe0b4) --
    -- ピル内の左右余白(セル数)。0 だと詰まりすぎる。端末は1セル単位なので0.5は不可
    local pill_padding = { left = 1, right = 1 }

    ---@return string?
    local function fg_of(name)
      local h = vim.api.nvim_get_hl(0, { name = name, link = false })
      return h.fg and string.format("#%06x", h.fg) or nil
    end

    local function build_theme()
      local fg = fg_of("Normal") or "#ffffff"
      local dark = vim.g.terminal_black or "#1a1a1a"
      local dim = fg_of("Comment") or "#727072"
      local none = "NONE"

      -- モードごとのピルの色 (monokai-pro の役割: 文字列=黄 / 関数=緑 / 定数=紫 / キーワード=ピンク / 特殊=橙)
      local function mode(color)
        return {
          a = { fg = dark, bg = color, gui = "bold" }, -- ピル
          b = { fg = color, bg = none },
          c = { fg = fg, bg = none },
        }
      end
      return {
        normal = mode(fg_of("String") or "#ffd866"),
        insert = mode(fg_of("Function") or "#a9dc76"),
        visual = mode(fg_of("Constant") or "#ab9df2"),
        replace = mode(fg_of("Keyword") or "#ff6188"),
        command = mode(fg_of("Special") or "#fc9867"),
        terminal = mode(fg_of("Function") or "#a9dc76"),
        inactive = {
          a = { fg = dim, bg = none },
          b = { fg = dim, bg = none },
          c = { fg = dim, bg = none },
        },
      }
    end

    -- 標準の "location" は %3l:%-2v で行・列を固定幅に揃えるため、ピルの中に余白ができる。内容の幅にぴったり合わせる
    local function location()
      return ("%d:%d"):format(vim.fn.line("."), vim.fn.virtcol("."))
    end

    local function setup()
      lualine.setup({
        options = {
          theme = build_theme(),
          component_separators = "",
          section_separators = "",
          globalstatus = false,
        },
        sections = {
          lualine_a = { { "mode", separator = { left = pill_left, right = pill_right }, padding = pill_padding } },
          lualine_b = { "branch", "diff" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "diagnostics", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { { location, separator = { left = pill_left, right = pill_right }, padding = pill_padding } },
        },
        inactive_sections = {
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { location },
        },
      })
    end

    setup()

    -- which-key は visual / operator-pending に入るとキー入力待ちになり、その間ステータスラインが再描画されない。
    -- 入力待ちに入る前に、モード変更の時点で強制的に描画しておく
    vim.api.nvim_create_autocmd("ModeChanged", {
      group = vim.api.nvim_create_augroup("lualine-pill-redraw", { clear = true }),
      callback = function()
        vim.cmd("redrawstatus")
      end,
    })

    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("lualine-pill-theme", { clear = true }),
      callback = setup,
    })
  end,
}
