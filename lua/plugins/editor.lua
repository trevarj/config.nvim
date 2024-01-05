return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  {
    "numToStr/Comment.nvim",
    lazy = false,
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = true,
    opts = {
      keymaps = {
        insert = "<C-g>s",
        insert_line = "<C-g>S",
        normal = "gs",
        normal_cur = "gss",
        normal_line = "gS",
        normal_cur_line = "gSS",
        visual = "S",
        visual_line = "gS",
        delete = "ds",
        change = "cs",
        change_line = "cS",
      },
    },
  },
}
