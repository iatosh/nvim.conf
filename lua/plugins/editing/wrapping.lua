return {
  event = "BufReadPost",
  "andrewferrier/wrapping.nvim",
  opts = {
    -- 既定(true)だとグローバルに wrap=false を強制され、長い行で横スクロールが出る。
    -- wrap / linebreak は options.lua 側で管理する
    set_nvim_opt_defaults = false,
    -- 既定(true)だと、短い行が多いファイルを hard wrap (= wrap 無効 + textwidth 整形) と判定し、
    -- 日本語の長い文章などが折り返されず画面外へ流れてしまう。常に soft wrap (折り返し表示) にする
    auto_set_mode_heuristically = false,
  },
}
