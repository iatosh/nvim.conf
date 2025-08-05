-- lua/plugins/core/treesitter.lua
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter.configs").setup({
      -- 自動インストールする言語
      ensure_installed = {
        "bash",
        "bibtex",
        "csv",
        "lua",
        "tmux",
        "vim",
        "vimdoc",
        "javascript",
        "typescript",
        "python",
        "rust",
        "go",
        "markdown",
        "markdown_inline",
        "html",
        "css",
        "json",
        "yaml",
      },
      
      -- 自動インストールを有効化
      auto_install = true,
      
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      
      indent = {
        enable = true,
      },
    })
  end,
}
