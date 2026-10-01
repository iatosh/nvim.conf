-- plugins/auto-save.lua
return {
  "okuuva/auto-save.nvim",
  event = { "InsertLeave", "BufLeave", "FocusLost" },
  config = function()
    require("auto-save").setup({
      enabled = true, -- 起動時から有効化
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost" }, -- 即座に保存
        -- TextChangedは入力/編集のたびに保存(+空白除去+LSPフォーマット)が走り固まるので外す
        defer_save = { "InsertLeave" },
        cancel_deferred_save = { "InsertEnter" },
      },
      condition = function(buf)
        -- 通常のファイルバッファだけ保存 (picker/mini.files/ターミナル等は除外)
        if vim.bo[buf].buftype ~= "" or not vim.bo[buf].modifiable then
          return false
        end
        if vim.api.nvim_buf_get_name(buf) == "" then
          return false
        end
        return true
      end,
      write_all_buffers = false, -- 現在のバッファのみ保存
      debounce_delay = 1000, -- 1秒の遅延（連続入力時に保存しすぎないように）
    })
  end,
}
