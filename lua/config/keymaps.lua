-- lua/config/keymaps.lua

local keymap = vim.keymap

-- リーダーキー設定（これはinit.luaから移動）
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ウィンドウ移動を簡単に
keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Switch window to left' })
keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Switch window to right' })
keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Switch window to above' })
keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Switch window to below' })

