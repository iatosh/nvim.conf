-- lua/plugins/editing/treesj.lua
return {
  "Wansmer/treesj",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  -- opt = {
  --   use_default_keymaps = true,
  -- },
  keys = {
    { 
      "<leader>m",
      function(e)
        require('treesj').toggle()
      end,
      mode = "n", 
      desc = "Toggle split/join" 
    },
  },
}
