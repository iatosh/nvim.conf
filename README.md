# nvim config

Personal Neovim configuration using [lazy.nvim](https://github.com/folke/lazy.nvim) as plugin manager.

## Structure

```
nvim/
├── init.lua                  # Entry point
└── lua/
    ├── config/
    │   ├── options.lua       # Editor settings
    │   ├── keymaps.lua       # Core keybindings
    │   └── lazy.lua          # Plugin manager setup
    └── plugins/
        ├── appearance/       # UI (colorscheme, lualine, noice, …)
        ├── coding/           # Completion (blink-cmp)
        ├── core/             # Navigation (flash, mini.files, treesitter, which-key, …)
        ├── editing/          # Text ops (comment, treesj, rip-substitute, …)
        └── tools/            # Integrations (obsidian, snacks)
```

## Key Bindings

Leader key: `<Space>`

### Navigation

| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Switch window / tmux pane (vim-tmux-navigator) |
| `s` | Flash jump |
| `S` | Flash treesitter jump |
| `<leader>e` | File explorer (mini.files) |

### Finder (snacks.picker)

| Key | Action |
|-----|--------|
| `<leader><space>` | Smart find files |
| `<leader>ff` | Find files |
| `<leader>/` | Live grep |
| `<leader>,` | Buffers |
| `<leader>fr` | Recent files |
| `<leader>fp` | Projects |

### Editing

| Key | Action |
|-----|--------|
| `gcc` | Toggle line comment |
| `gc` + motion | Toggle comment |

Press `<Space>` and wait for which-key to discover more bindings.

## Plugins

| Category | Plugin |
|----------|--------|
| Plugin manager | lazy.nvim |
| Completion | blink-cmp |
| Fuzzy finder | snacks.picker |
| File explorer | mini.files |
| Motion | flash.nvim |
| Treesitter | nvim-treesitter |
| Statusline | lualine.nvim |
| UI | noice.nvim |
| Keybinding hint | which-key.nvim |
| Note-taking | obsidian.nvim |
