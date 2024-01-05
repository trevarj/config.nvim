return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      -- NOTE statusline goes away if not using noice or something to keep it refreshing, i think
      local colors = require("nord.colors").palette
      local nord = require("lualine.themes.nord")
      local icons = require("config.icons")
      local opts = {}

      nord.normal.a.fg = colors.polar_night.origin
      nord.normal.a.bg = colors.frost.artic_water
      nord.normal.b.fg = colors.snow_storm.origin
      nord.normal.b.bg = colors.polar_night.bright
      nord.normal.c.fg = colors.snow_storm.origin
      nord.normal.c.bg = colors.polar_night.origin
      nord.insert.a.bg = colors.aurora.orange
      nord.inactive.a.fg = '#768fbc'
      nord.inactive.a.bg = colors.polar_night.bright

      opts.options = {
        theme = nord,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { -- Filetypes to disable lualine for.
          statusline = {},     -- only ignores the ft for statusline.
        },

        ignore_focus = { "neo-tree", "TelescopePrompt", "lazy", "mason" }, -- If current filetype is in this list it'll
        -- always be drawn as inactive statusline
        -- and the last window will be drawn as active statusline.
        -- for example if you don't want statusline of
        -- your file tree / sidebar window to have active
        -- statusline you can add their filetypes here.

        always_divide_middle = true, -- When set to true, left sections i.e. 'a','b' and 'c'
        -- can't take over the entire statusline even
        -- if neither of 'x', 'y' or 'z' are present.

        globalstatus = true, -- enable global statusline (have a single statusline
        -- at bottom of neovim instead of one for every window).
        -- This feature is only available in neovim 0.7 and higher.

        refresh = {          -- sets how often lualine should refresh it's contents (in ms)
          statusline = 1000, -- The refresh option sets minimum time that lualine tries
          tabline = 1000,    -- to maintain between refresh. It's not guarantied if situation
          winbar = 1000,     -- arises that lualine needs to refresh itself before this time
          -- it'll do it.

          -- Also you can force lualine's refresh by calling refresh function
          -- like require('lualine').refresh()
        },
      }

      opts.sections = {
        lualine_a = { "mode" },
        lualine_b = {
          { "branch" },
          {
            "diff",
            symbols = {
              added = " ",
              modified = " ",
              removed = " ",
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_c = {
          {
            "filename",
            file_status = true,     -- Displays file status (readonly status, modified status)
            newfile_status = false, -- Display new file status (new file means no write after created)
            -- 0: Just the filename
            -- 1: Relative path
            -- 2: Absolute path
            -- 3: Absolute path, with tilde as the home directory
            -- 4: Filename and parent dir, with tilde as the home directory
            path = 3,

            shorting_target = 60, -- Shortens path to leave 40 spaces in the window
            -- for other components. (terrible name, any suggestions?)
            symbols = {
              modified = "●", -- Text to show when the file is modified.
              readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
              unnamed = "[No Name]", -- Text to show for unnamed buffers.
              newfile = "[New]", -- Text to show for newly created file before first write
            },
          },
        },
        lualine_x = {
          {
            "diagnostics",
            -- Table of diagnostic sources, available sources are:
            --   'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', 'coc', 'ale', 'vim_lsp'.
            -- or a function that returns a table as such:
            --   { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }
            sources = { "nvim_lsp", "nvim_diagnostic" },
            symbols = {
              error = icons.error,
              warn = icons.warning,
              info = icons.info,
              hint = icons.hint,
            },
          },
        },
        lualine_y = {
          { "searchcount" },
          { "selectioncount" },
          { "location",      padding = { left = 1, right = 1 } },
          { "progress",      separator = "",                   padding = { left = 0, right = 2 } },
        },
        lualine_z = {
          {
            "filetype",
            colored = false,  -- Displays filetype icon in color if set to true
            icon_only = true, -- Display only an icon for filetype
            padding = {
              left = 1,
              right = 1,
            },
          },
        },
      }
      opts.tabline = {
        lualine_a = {
          {
            "buffers",
            mode = 2,
            symbols = {
              modified = " ●", -- Text to show when the buffer is modified
              alternate_file = "", -- Text to show to identify the alternate file
              directory = "", -- Text to show when the buffer is a directory
            },
            filetype_names = {},
            use_mode_colors = true,
          },
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      }
      opts.extensions = {}
      return opts
    end,
  },
}
