return {
  event = "BufReadPost",
  "andrewferrier/wrapping.nvim",
  opts = {
    -- 既定(true)だとグローバルに wrap=false を強制され、長い行で横スクロールが出る。
    -- wrap / linebreak は options.lua 側で管理し、プラグインは散文ファイルのモード切替だけ担当させる
    set_nvim_opt_defaults = false,
  },
}
