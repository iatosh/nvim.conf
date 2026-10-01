-- lua/plugins/appearance/modes.lua
return {
  "mvllow/modes.nvim",
  event = "VeryLazy",
  -- opts を関数にして VeryLazy 時点で評価する (静的テーブルだと vim.g.terminal_bg が未設定で黒と混ぜてしまい、現在行が真っ黒になる)
  opts = function() return {
	  colors = {
		  bg = vim.g.terminal_bg, -- 透過bgだとNormalから取れないので端末の実bgを使う (colorscheme.luaが設定)
		  copy = "#f5c359",
		  delete = "#c75c6a",
		  change = "#c75c6a", -- Optional param, defaults to delete
		  format = "#c79585",
		  insert = "#78ccc5",
		  replace = "#245361",
		  select = "#9745be", -- Optional param, defaults to visual
		  visual = "#9745be",
	  },

	  -- Set opacity for cursorline and number background
	  line_opacity = 0.15,

	  -- Enable cursor highlights
	  set_cursor = true,

	  -- Enable cursorline initially, and disable cursorline for inactive windows
	  -- or ignored filetypes
	  set_cursorline = true,

	  -- Enable line number highlights to match cursorline
	  set_number = true,

	  -- Enable sign column highlights to match cursorline
	  set_signcolumn = true,

	  -- Disable modes highlights for specified filetypes
	  -- or enable with prefix "!" if otherwise disabled (please PR common patterns)
	  -- Can also be a function fun():boolean that disables modes highlights when true
	  ignore = { "NvimTree", "TelescopePrompt", "!minifiles" }
  } end,
}
