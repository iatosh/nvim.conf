-- lua/config/autocmds.lua
-- Neovim autocommand 設定

-- ===========================================
-- 外部ファイル変更の自動検知と再読み込み
-- ===========================================

-- ウィンドウをフォーカスした時 → 外部変更をチェック
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  pattern = "*",
  callback = function()
    -- コマンドライン/ターミナル中はchecktimeを呼ばない
    if vim.fn.mode() ~= "c" and vim.bo.buftype == "" then
      vim.cmd("checktime")
    end
  end,
  desc = "Check for external file changes when focus gained or buffer entered",
})

-- 外部変更があった場合の通知
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  callback = function()
    vim.notify(
      "⚠️  File changed externally and reloaded",
      vim.log.levels.WARN,
      { title = "External File Change" }
    )
  end,
  desc = "Notify user when file is changed externally",
})

-- ===========================================
-- その他の実用的なautocommand
-- ===========================================

-- 最後に編集した位置に復帰
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Go to last edit location when opening a buffer",
})

-- Trimmmmコマンドなしで末尾の空白を削除（保存時）
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    -- Markdownの末尾2スペース(強制改行)は消さない
    if vim.bo.filetype == "markdown" then
      return
    end
    local view = vim.fn.winsaveview()
    -- keeppatternsで検索履歴を汚さない
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
  desc = "Strip trailing whitespace on file save",
})
