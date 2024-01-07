return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  {
    "numToStr/Comment.nvim",
    lazy = false,
    opts = {}
  },
  {
    "kylechui/nvim-surround",
    keys = require("config.keymaps").nvim_surround().keys,
    config = true,
    opts = {
      keymaps = require("config.keymaps").nvim_surround().keymaps,
    },
  },
}
