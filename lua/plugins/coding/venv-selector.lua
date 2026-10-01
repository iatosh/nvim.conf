-- lua/plugins/coding/venv-selector.lua
-- Python仮想環境切り替え (uv対応)

return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "folke/snacks.nvim", -- snacks picker使用
  },
  event = "VeryLazy", -- 遅延ロード
  keys = {
    { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
    { "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "Select Cached VirtualEnv" },
  },
  opts = {
    -- snacks pickerを使用
    picker = "snacks",
    -- uv環境を検索
    search_venv_managers = true,
    -- 検索パス
    search_workspace = true,
    -- PEP-723サポート (uvのインラインメタデータ)
    enable_pep723 = true,
    -- 対応する仮想環境マネージャー
    -- uv, venv, poetry, pipenv, conda などに対応
    name = {
      "venv",
      ".venv",
      "env",
      ".env",
    },
    -- fdを使った高速検索
    fd_binary_name = "fd",
    -- 自動的に環境を選択
    auto_refresh = true,
    -- LSP統合（basedpyright, ruff対応）
    notify_user_on_venv_activation = true,
  },
}
