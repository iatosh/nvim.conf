-- lua/plugins/appearance/noice.lua

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  keys = {
    -- { "<leader>n", "<cmd>Noice history<cr>", desc = "Show Notice History" },
    { "<leader>n", function() require("noice").cmd("focus") end, desc = "Toggle Noice History" }
  },
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
    -- commands = {
    --   history = {
    --     view = "split",
    --     opts = { 
    --       enter = true,
    --       -- フォーカスを外したら自動的に閉じる
    --       close = {
    --         keys = { "q", "<Esc>" },
    --         events = { "BufLeave" }  -- バッファから離れたら閉じる
    --       }
    --     },
    --   },
    -- },
    -- commands = {
    --   history = {
    --     view = "popup",  -- フローティングウィンドウ
    --     opts = {
    --       enter = true,
    --       border = {
    --         style = "rounded",
    --       },
    --       position = {
    --         row = "50%",
    --         col = "50%",
    --       },
    --       size = {
    --         width = "60%",
    --         height = "50%",
    --       },
    --       win_options = {
    --         winhighlight = "Normal:Normal,FloatBorder:DiagnosticInfo",
    --       },
    --       close = {
    --         keys = { "q", "<Esc>" },
    --         events = { "BufLeave" }  -- バッファから離れたら閉じる
    --       }
    --     },
    --     filter_opts = { reverse = true },
    --   },
    -- },
  },
}
