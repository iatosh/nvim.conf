-- lua/plugins/editing/nvim-rip-substitute.lua
return {
  "chrisgrieser/nvim-rip-substitute",
  keys = {
    {
      "<leader>fs",
      function() require("rip-substitute").sub() end,
      mode = { "n", "x" },
      desc = "Rip substitute",
    },
  },
  opts = {
    popupWin = {
      position = "top",
      hideSearchReplaceLabels = true,
    },
    incrementalPreview = {
      rangeBackdrop = {
        enabled = true,
        blend = 60,
      },
    },
  },
}
