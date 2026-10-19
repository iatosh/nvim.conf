-- lua/config/keymaps.lua

local keymap = vim.keymap

-- リーダーキー設定（これはinit.luaから移動）
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ウィンドウ移動を簡単に
keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Switch window to left' })
keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Switch window to below' })
keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Switch window to above' })
keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Switch window to right' })


-- 折り返した行は画面上の行単位で上下移動する (回数指定 5j などは論理行のまま = relativenumber と合う)
keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = 'Down (display line)' })
keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = 'Up (display line)' })
