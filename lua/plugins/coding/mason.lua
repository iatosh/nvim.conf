-- lua/plugins/coding/mason.lua
-- Mason: LSPサーバー自動インストール & 管理

return {
  "williamboman/mason.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",              -- サーバー定義ライブラリ（venv-selectorも依存）
    "williamboman/mason-lspconfig.nvim",
    "saghen/blink.cmp",                   -- blink.cmp統合
  },
  event = { "BufReadPre", "BufNewFile" }, -- ファイル開く時に遅延ロード
  config = function()
    -- Masonのセットアップ
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
        border = "rounded",
      },
    })

    -- Mason-LSPConfig: 自動インストール
    require("mason-lspconfig").setup({
      -- 自動インストールする言語サーバー
      ensure_installed = {
        "basedpyright", -- Python型チェック (uv対応)
        "ruff",         -- Python linter/formatter
        "yamlls",       -- YAML言語サーバー
      },
    })

    -- LSP起動時の設定（キーバインド）
    -- 注: gd, gD, gr, gI, gy は snacks.nvim で設定済み
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, noremap = true, silent = true }

        -- キーバインド設定（snacksと重複しないもののみ）
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)                -- ホバー情報
        -- <C-k>はウィンドウ移動に使うので上書きしない (シグネチャヘルプは挿入モードの<C-s>)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)      -- リネーム
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- コードアクション
        -- <leader>f は <leader>ff 等のプレフィックスと衝突し待ち時間が出るので cf にする
        vim.keymap.set("n", "<leader>cf", function()
          vim.lsp.buf.format({ async = true })
        end, opts) -- フォーマット

        -- 診断ナビゲーション (goto_prev/nextは0.11で非推奨)
        vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
        vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- 診断の詳細表示
        vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts) -- 診断リスト
      end,
    })

    -- 保存時に自動フォーマット（VSCode風）
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormatOnSave", {}),
      pattern = { "*.py", "*.yaml", "*.yml" }, -- Python, YAMLファイル
      callback = function()
        -- 同期実行だがタイムアウト短め (auto-saveで頻繁に走るため、LSPが遅くても固まらないように)
        vim.lsp.buf.format({ async = false, timeout_ms = 300 })
      end,
    })

    -- 診断表示の設定（VSCode風）
    vim.diagnostic.config({
      virtual_text = {
        prefix = "●", -- エラーマーカー
        source = "if_many",
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.INFO] = "",
          [vim.diagnostic.severity.HINT] = "",
        },
        numhl = {
          [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
          [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
          [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
          [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
        },
      },
      underline = true, -- 波線でエラーを表示
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })

    -- blink.cmpのcapabilitiesを全サーバーに適用
    -- (旧コードの User MasonLspConfigReady は存在しないイベントで、一度も発火していなかった)
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })
    -- 有効化はmason-lspconfigのautomatic_enable(既定で有効)がインストール済みサーバーに対して行う
  end,
}
