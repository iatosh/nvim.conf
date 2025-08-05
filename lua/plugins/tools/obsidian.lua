-- lua/plugins/tools/obsidian.lua
return {
  "epwalsh/obsidian.nvim",
  version = "*",
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/GitHub/my-vault",
      },
    },
    new_notes_location = "- Fleeting Notes",
  },
}
