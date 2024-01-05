return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "trevarj/telescope-tmux.nvim", dev = false, branch = "develop" },
    { "norcalli/nvim-terminal.lua" }, -- mostly for tmux pane contents
  },
  cmd = "Telescope",
  -- apply the config and additionally load fzf-native
  config = function(_, opts)
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    opts.defaults = {
      layout_strategy = "horizontal",
      layout_config = { prompt_position = "top" },
      sorting_strategy = "ascending",
      winblend = 0,
      mappings = {
        i = {
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<Del>"] = actions.delete_buffer,
        },
        n = {
          ["q"] = actions.close,
        },
      },
    }
    opts.extensions = {
      tmux = {
        grep_cmd = "rg -oe",
      },
    }
    telescope.setup(opts)
    telescope.load_extension("fzf")
    telescope.load_extension("tmux")
  end,
}
