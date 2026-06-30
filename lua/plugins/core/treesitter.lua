-- lua/plugins/core/treesitter.lua
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install({
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
    })
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
      -- Highlighting 
      pcall(vim.treesitter.start)
  
      -- Folds
      -- vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
      -- vim.wo[0][0].foldmethod = "expr"

      -- Indentation
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
    })
  end,
}
