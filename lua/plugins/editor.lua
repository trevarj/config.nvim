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
    opts = {}
  },
  {
    "kylechui/nvim-surround",
    keys = keys.nvim_surround(),
    config = true,
    opts = function(_, opts)
      -- handle mappings manually
      opts.keymaps = {}
    end,
  },
}
