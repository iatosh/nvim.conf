-- lua/plugins/appearance/smear-cursor.lua
return {
  "sphamba/smear-cursor.nvim",
  event = "VeryLazy",
  opts = {
    -- カーソルの残像効果
    stiffness = 0.8,              -- 0.6 - 0.99 (高いほど素早い)
    trailing_stiffness = 0.5,     -- 0.1 - 1    (尾の硬さ)
    distance_stop_animating = 0.5, -- アニメーション停止距離
    hide_target_hack = false,      -- ちらつき防止
  },
}
