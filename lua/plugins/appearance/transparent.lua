-- lua/plugins/appearance/transparent.lua
return {
  "xiyaowong/transparent.nvim",
  lazy = false,
  opts = {
    extra_groups = {
      -- 追加で透過したいグループ
      "NormalFloat",
      "TelescopeNormal",
      "TelescopeBorder",
      "WhichKeyFloat",
    },
  },
}
