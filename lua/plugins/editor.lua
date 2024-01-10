local keys = require("config.keymaps")
return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
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
}
