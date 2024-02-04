return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "norcalli/nvim-terminal.lua" }, -- mostly for tmux pane contents
      { "nvim-telescope/telescope-ui-select.nvim" },
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
        ["ui-select"] = {
          require("telescope.themes").get_ivy({ results_title = false, layout_config = { height = 8 } }),
        },
      }
      telescope.setup(opts)
      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")
    end,
  },
  {
    "trevarj/telescope-tmux.nvim",
    dev = false,
    branch = "develop",
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {
      extensions = {
        tmux = {
          grep_cmd = "rg -oe",
        },
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("tmux")
    end,
  },
}
