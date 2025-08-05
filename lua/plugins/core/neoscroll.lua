-- lua/plugins/appearance/neoscroll.lua

return {
  "karb94/neoscroll.nvim",
  event = "BufReadPost",
  opts = {
    easing = 'quadratic',
    respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
  },
}
