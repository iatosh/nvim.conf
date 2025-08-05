-- lua/plugins/editing/treesj.lua
return {
  "Wansmer/treesj",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opt = { use_default_keymaps = true, },
  keys = {
    { "<leader>m", "<cmd>TSJToggle<cr>", desc = "Toggle split/join" },
  },
}
