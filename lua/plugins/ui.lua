return {
  {
    "gbprod/nord.nvim",
    lazy = false,
    priority = 1000,
    dev = false,
    config = function(_, opts)
      require("nord").setup(opts)
      vim.cmd.colorscheme("nord")
    end,
    opts = function(_, _)
      local colors = require("nord.colors").palette
      return {
        transparent = false, -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
        diff = { mode = "fg" }, -- enables/disables colorful backgrounds when used in diff mode. values : [bg|fg]
        borders = true, -- Enable the border between verticaly split windows visible
        errors = { mode = "fg" }, -- Display mode for errors and diagnostics
        -- values : [bg|fg|none]
        search = { theme = "vim" }, -- theme for highlighting search results
        -- values : [vim|vscode]
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = false },
          keywords = { fg = colors.aurora.orange, bold = true },
          functions = { bold = true },
          variables = {},

          -- To customize lualine/bufferline
          bufferline = {
            current = {},
            modified = { italic = false },
          },
        },
        -- colorblind mode
        -- see https://github.com/EdenEast/nightfox.nvim#colorblind
        -- simulation mode has not been implemented yet.
        colorblind = {
          enable = true,
          preserve_background = true,
          severity = {
            protan = 0.2,
            deutan = 0.9,
            tritan = 0.4,
          },
        },

        --- You can override specific highlights to use other groups or a hex color
        --- function will be called with all highlights and the colorScheme table
        on_highlights = function(hl, c)
          hl.LspInlayHint = { fg = c.frost.artic_ocean }
          hl.GitSignsCurrentLineBlame = { fg = c.polar_night.light }
          hl.MatchParen = { fg = c.aurora.yellow, bg = c.frost.artic_ocean }
          hl.TreesitterContext = { bg = c.polar_night.bright }
          hl.WarningMsg = { fg = c.aurora.yellow }
          hl.ErrorMsg = { fg = c.aurora.red }
          -- hl.NonText = { fg = c.polar_night.light }
        end,
      }
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    opts = {
      close_if_last_window = true,
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      window = {
        width = 30,
      },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
    end,
    opts = {},
  },
  {
    "NvChad/nvim-colorizer.lua",
    cmd = "ColorizerToggle",
    opts = {},
  },
}
