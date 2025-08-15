-- lua/plugins/appearance/colorscheme.lua
return {
  "loctvl842/monokai-pro.nvim",
  name = "monokai-pro",
  lazy = false,
  priority = 1000,
  config = function()
    require("monokai-pro").setup({
      transparent_background = false,
      terminal_colors = true,
      devicons = true,
      styles = {
        comment = { italic = true },
        keyword = { italic = true },
        type = { italic = true },
        storageclass = { italic = true },
        structure = { italic = true },
        parameter = { italic = true },
        annotation = { italic = true },
        tag_attribute = { italic = true },
      },
      filter = "spectrum",
      background_clear = {
        -- "float_win",
        -- "toggleterm",
        -- "telescope",
        -- "lualine",
        -- "which-key",
        "renamer",
        "notify",
        -- "nvim-tree",
        -- "neo-tree",
        -- "bufferline",
      },
      
      -- mini.files と snacks のハイライトを override で設定
      override = function(c)
        return {
          -- mini.files のハイライトグループ
          MiniFilesNormal = { bg = c.sideBar.background, fg = c.sideBar.foreground },
          MiniFilesBorder = { bg = c.sideBar.background, fg = c.base.dimmed4 },
          MiniFilesBorderModified = { bg = c.sideBar.background, fg = c.base.yellow },
          MiniFilesCursorLine = { bg = c.list.activeSelectionBackground, bg_base = c.sideBar.background },
          MiniFilesDirectory = { fg = c.base.cyan },
          MiniFilesFile = { fg = c.base.white },
          MiniFilesTitle = { bg = c.base.yellow, fg = c.base.black, bold = true },
          MiniFilesTitleFocused = { bg = c.base.yellow, fg = c.base.black, bold = true },
          MiniFilesModified = { fg = c.base.yellow },
            
          -- mini.icons (mini.filesで使用される)
          MiniIconsAzure = { fg = c.base.cyan },
          MiniIconsBlue = { fg = c.base.blue },
          MiniIconsCyan = { fg = c.base.cyan },
          MiniIconsGreen = { fg = c.base.green },
          MiniIconsGrey = { fg = c.base.dimmed2 },
          MiniIconsOrange = { fg = c.base.blue },
          MiniIconsPurple = { fg = c.base.magenta },
          MiniIconsRed = { fg = c.base.red },
          MiniIconsYellow = { fg = c.base.yellow },
            
          -- snacks.nvim のハイライトグループ
          SnacksNormal = { bg = c.editor.background, fg = c.editor.foreground },
          SnacksBorder = { bg = c.editor.background, fg = c.base.dimmed2 },
          SnacksTitle = { bg = c.base.yellow, fg = c.base.black, bold = true },
          SnacksFooter = { fg = c.base.green },
          SnacksDesc = { fg = c.base.dimmed1 },
          SnacksFile = { fg = c.base.white },
           
          -- snacks picker
          SnacksPickerBorder = { bg = c.editor.background, fg = c.base.dimmed3 },
          SnacksPickerDir = { fg = c.base.dimmed2 },
          SnacksPickerFile = {
            fg = c.base.dimmed2,
          },
          SnacksPickerFileIcon = {
            fg = c.base.dimmed2,
          },
          SnacksPickerInput = { bg = c.editor.background, fg = c.editor.foreground },
          SnacksPickerList = { bg = c.editor.background, fg = c.editor.foreground },
          SnacksPickerNormal = { bg = c.editor.background, fg = c.editor.foreground },
          SnacksPickerMatch = { fg = c.base.white, bold = true },
          SnacksPickerMatchBorder = { bg = c.editor.background, fg = c.base.dimmed3 },
          SnacksPickerPrompt = { bg = c.editor.background, fg = c.base.cyan },
          SnacksPickerPromptNormal = { bg = c.editor.background, fg = c.base.white },
          SnacksPickerPreview = { bg = c.editor.background, fg = c.editor.foreground },
          SnacksPickerPreviewBorder = { bg = c.editor.background, fg = c.base.dimmed3 },
          SnacksPickerPreviewTitle = { bg = c.editor.background, fg = c.base.white, bold = true },
          SnacksPickerQuery = { fg = c.base.yellow },
          SnacksPickerResults = { bg = c.editor.background, fg = c.editor.foreground },
          SnacksPickerSelection = { bg = c.list.selectionBackground, fg = c.base.white },
          SnacksPickerSelectionMatch = { bg = c.list.activeSelectionBackground, fg = c.base.yellow, bold = true },
          SnacksPickerTitle = { bg = c.editor.background, fg = c.base.white, bold = true },
          SnacksPickerVirtualText = { fg = c.base.dimmed3 },

          -- snacks indent
          SnacksIndent = { fg = c.editorIndentGuide.background },
          SnacksIndentScope = { fg = c.editorIndentGuide.activeBackground },
          SnacksIndentChunk = { fg = c.base.dimmed4 },
            
          -- -- snacks git
          -- SnacksGitAdded = { fg = c.gitDecoration.addedResourceForeground },
          -- SnacksGitDeleted = { fg = c.gitDecoration.deletedResourceForeground },
          -- SnacksGitChanged = { fg = c.gitDecoration.modifiedResourceForeground },
        }
      end,
    })

    vim.cmd([[colorscheme monokai-pro]])
    
    -- 追加: カラースキーム適用後に再度ハイライトを設定（確実に適用するため）
    -- vim.defer_fn(function()
    --   local c = require("monokai-pro.colorscheme")
    --   
    --   -- mini.files の背景を確実に設定
    --   vim.api.nvim_set_hl(0, "MiniFilesNormal", { bg = c.sideBar.background, fg = c.sideBar.foreground })
    --   vim.api.nvim_set_hl(0, "MiniFilesBorder", { bg = c.sideBar.background, fg = c.base.dimmed4 })
    --   vim.api.nvim_set_hl(0, "MiniFilesDirectory", { fg = c.base.cyan, bold = true })
    --   vim.api.nvim_set_hl(0, "MiniFilesFile", { fg = c.base.white })
    --   
    --   -- snacks picker の背景を確実に設定
    --   vim.api.nvim_set_hl(0, "SnacksPickerNormal", { bg = c.editorSuggestWidget.background, fg = c.editorSuggestWidget.foreground })
    --   vim.api.nvim_set_hl(0, "SnacksPickerBorder", { bg = c.editor.background, fg = c.editorSuggestWidget.background })
    --   vim.api.nvim_set_hl(0, "SnacksPickerTitle", { bg = c.base.yellow, fg = c.base.black, bold = true })
    --   vim.api.nvim_set_hl(0, "SnacksPickerPrompt", { bg = c.editorSuggestWidget.background, fg = c.base.cyan })
    --   vim.api.nvim_set_hl(0, "SnacksPickerSelection", { bg = c.editorSuggestWidget.selectedBackground, fg = c.base.white, bold = true })
    --   vim.api.nvim_set_hl(0, "SnacksPickerMatch", { fg = c.base.blue, bold = true })
    --   vim.api.nvim_set_hl(0, "SnacksPickerPreview", { bg = c.editor.background, fg = c.editor.foreground })
    --   vim.api.nvim_set_hl(0, "SnacksPickerPreviewTitle", { bg = c.base.blue, fg = c.base.black, bold = true })
    --   vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = c.base.cyan, bold = true })
    --   vim.api.nvim_set_hl(0, "SnacksPickerFile", { fg = c.base.white })
    -- end, 10)
  end,
}
