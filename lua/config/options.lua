-- lua/config/options.lua

local opt = vim.opt

-- Line Number
opt.number = true

-- Indents
opt.expandtab = true     -- タブをスペースに
opt.shiftwidth = 2       -- インデント幅
opt.tabstop = 2          -- タブ幅

-- Search  
opt.ignorecase = true    -- 大文字小文字無視
opt.smartcase = true     -- 大文字含む時は区別

-- Appearance
opt.termguicolors = true -- True Color
opt.cursorline = true    -- カーソル行ハイライト

-- System
opt.clipboard = "unnamedplus" -- システムクリップボード連携
opt.mouse = 'a'

