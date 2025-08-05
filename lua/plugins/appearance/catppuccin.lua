-- lua/plugins/appearance/catppuccin.lua

return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      show_end_of_buffer = false,     -- バッファ終端の ~ を非表示
      term_colors = true,             -- ターミナルカラー統合
      integrations = {
        cmp = true,
        gitsigns = true,
        notify = true,
        treesitter = true,
        which_key = true,
      },
    })
    -- フレーバーを選択（latte, frappe, macchiato, mocha）
    vim.cmd([[colorscheme catppuccin-mocha]])
  end,
}
