-- lua/plugins/appearance/btw.lua
return {
  "letieu/btw.nvim",
  lazy = false,
  config = function()
    require('btw').setup()
  end,
}
