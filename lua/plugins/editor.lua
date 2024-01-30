local keys = require("config.keymaps")
return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "echasnovski/mini.comment",
    keys = keys.comment(),
    opts = {},
  },
  {
    "kylechui/nvim-surround",
    keys = keys.nvim_surround(),
    opts = {
      keymaps = {
        insert = false,
        insert_line = false,
        normal = false,
        normal_cur = false,
        normal_line = false,
        normal_cur_line = false,
        visual = false,
        visual_line = false,
        delete = false,
        change = false,
        change_line = false,
      },
    },
  },
  {
    "nvim-pack/nvim-spectre",
    keys = keys.spectre(),
    opts = {},
  },
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    opts = {
      keymaps = {
        ["<BS>"] = "actions.parent",
      },
      view_options = {
        show_hidden = true,
      },
      float = {
        max_width = 150,
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
}
