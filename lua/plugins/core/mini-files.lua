return {
  'echasnovski/mini.files', 
  version = false,
  keys = {
    {
      "<leader>e",
      function()
        -- 開いてるファイルのディレクトを表示
        require("mini.files").open(vim.fn.expand("%:p:h"))
      end,
      desc = "File explorer (mini.files)",
    },
  },
  config = function()
    require("mini.files").setup({
      windows = {
        preview = true,
        width_preview = 50,
      },
      options = {
        permanent_delete = false,
        use_as_default_exploror = true,
      },
    })

    -- ファイルを開いたら自動的に閉じる設定
    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        local buf_id = args.data.buf_id
        local function open_file_and_close_tree()
          local fs_entry = require("mini.files").get_fs_entry()
          require("mini.files").go_in()
          -- ファイルの場合のみ閉じる
          if fs_entry and fs_entry.fs_type == "file" then
            require("mini.files").close()
          end
        end
        
        -- Enterキーでファイルを開いて閉じる
        vim.keymap.set("n", "<CR>", function()
           open_file_and_close_tree()
        end, { buffer = buf_id, desc = "Open file and close explorer" })
        
        -- lキーでも同様の動作
        vim.keymap.set("n", "l", function()
          open_file_and_close_tree()
        end, { buffer = buf_id, desc = "Open file and close explorer" })
      end,
    })
  end,
}
