-- lua/config/options.lua

local opt = vim.opt

-- Line Number
opt.number = true
opt.relativenumber = true

-- Indents
opt.expandtab = true     -- タブをスペースに
opt.shiftwidth = 2       -- インデント幅
opt.tabstop = 2          -- タブ幅
opt.breakindent = true
opt.breakindentopt = "shift:2"

-- Search  
opt.ignorecase = true    -- 大文字小文字無視
opt.smartcase = true     -- 大文字含む時は区別

-- Appearance
opt.termguicolors = true -- True Color
opt.cursorline = true    -- カーソル行ハイライト

-- System
-- SSH先ではxclip等のクリップボードプロバイダが無く unnamedplus が機能しない (no clipboard provider) ため
-- OSC 52 でローカル端末のクリップボードに直接ヤンクを送る (Ghostty/WezTermどちらも対応)
if vim.env.SSH_TTY then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end
opt.clipboard = "unnamedplus" -- システムクリップボード連携
opt.mouse = 'a'
opt.swapfile = false
opt.autoread = true              -- 外部変更を自動読み込み
