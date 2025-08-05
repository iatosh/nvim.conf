-- lazy.nvimのインストールと設定
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- プラグインの設定（最初は空）
require("lazy").setup({
  spec = {
--    { import = "plugins" },
    { import = "plugins.appearance" },
    { import = "plugins.core" },
    { import = "plugins.editing" },
    { import = "plugins.coding" },
    { import = "plugins.tools" },
  },
  defaults = {
    lazy = true,
  },
})
