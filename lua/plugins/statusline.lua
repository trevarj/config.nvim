local function nord_theme()
  local colors = require("nord.colors").palette
  local nord = require("lualine.themes.nord")

  nord.normal.a.fg = colors.polar_night.origin
  nord.normal.a.bg = colors.frost.artic_water
  nord.normal.b.fg = colors.frost.ice
  nord.normal.b.bg = colors.polar_night.bright
  nord.normal.c.fg = colors.frost.ice
  nord.normal.c.bg = colors.polar_night.bright
  nord.insert.a.bg = colors.aurora.orange
  nord.inactive.a.fg = colors.frost.artic_water
  nord.inactive.a.bg = colors.polar_night.bright
  return nord
end

local function theme()
  local colorscheme = vim.g.colors_name
  if colorscheme == "nord" then
    return nord_theme()
  else
    -- fails if using a colorscheme that doesn't exist in lualine
    return colorscheme
  end
end

local function mode()
  -- :h mode()
  local map = {
    ["n"] = "normal",
    ["no"] = "o-pending",
    ["nov"] = "o-pending",
    ["noV"] = "o-pending",
    ["no\22"] = "o-pending",
    ["niI"] = "normal",
    ["niR"] = "normal",
    ["niV"] = "normal",
    ["nt"] = "normal",
    ["ntT"] = "normal",
    ["v"] = "visual",
    ["vs"] = "visual",
    ["V"] = "v-line",
    ["Vs"] = "v-line",
    ["\22"] = "v-block",
    ["\22s"] = "v-block",
    ["s"] = "select",
    ["S"] = "s-line",
    ["\19"] = "s-block",
    ["i"] = "insert",
    ["ic"] = "insert",
    ["ix"] = "insert",
    ["R"] = "replace",
    ["Rc"] = "replace",
    ["Rx"] = "replace",
    ["Rv"] = "v-replace",
    ["Rvc"] = "v-replace",
    ["Rvx"] = "v-replace",
    ["c"] = "command",
    ["cv"] = "ex",
    ["ce"] = "ex",
    ["r"] = "replace",
    ["rm"] = "more",
    ["r?"] = "confirm",
    ["!"] = "shell",
    ["t"] = "terminal",
  }
  local mode_code = vim.api.nvim_get_mode().mode
  if map[mode_code] == nil then
    return mode_code
  end
  return map[mode_code]
end

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = function()
      local icons = require("config.icons")
      local lazy_status = require("lazy.status")
      local c = require("nord.colors").palette
      local opts = {}

      opts.options = {
        theme = theme(),
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { -- Filetypes to disable lualine for.
          statusline = {}, -- only ignores the ft for statusline.
        },

        ignore_focus = { "TelescopePrompt" }, -- filetypes to hide the line

        always_divide_middle = true, -- When set to true, left sections i.e. 'a','b' and 'c'
        -- can't take over the entire statusline even
        -- if neither of 'x', 'y' or 'z' are present.

        globalstatus = true, -- enable global statusline (have a single statusline
        -- at bottom of neovim instead of one for every window).
        -- This feature is only available in neovim 0.7 and higher.

        refresh = { -- sets how often lualine should refresh it's contents (in ms)
          statusline = 1000, -- The refresh option sets minimum time that lualine tries
          tabline = 1000, -- to maintain between refresh. It's not guarantied if situation
          winbar = 1000, -- arises that lualine needs to refresh itself before this time
          -- it'll do it.

          -- Also you can force lualine's refresh by calling refresh function
          -- like require('lualine').refresh()
        },
      }

      local recording_macro = function()
        local key = vim.fn.reg_recording()
        if key ~= "" then
          return string.format(" recording @%s ", key)
        else
          return ""
        end
      end

      opts.sections = {
        lualine_a = {
          {
            function()
              return " "
            end,
            padding = { left = 0, right = 0 },
          },
        },
        lualine_b = {
          {
            mode,
            color = function()
              return { fg = c.polar_night.light, bg = c.polar_night.bright }
            end,
          },
          {
            recording_macro,
            color = function()
              return { fg = c.polar_night.origin, bg = c.aurora.red }
            end,
            padding = { left = 0, right = 0 },
          },
          { "branch", icon = "", color = { fg = c.aurora.green } },
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
            "filetype",
            colored = true, -- Displays filetype icon in color if set to true
            icon_only = true, -- Display only an icon for filetype
            padding = {
              left = 1,
              right = 1,
            },
          },
          {
            "filename",
            file_status = true, -- Displays file status (readonly status, modified status)
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
          { "location", padding = { left = 1, right = 1 } },
          { "progress", separator = "" },
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
          },
        },
        lualine_z = {},
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
        lualine_z = {
          {
            "tabs",
            cond = function()
              return vim.fn.tabpagenr("$") > 1
            end,
          },
        },
      }
      opts.extensions = { "fzf", "lazy", "man", "mason", "oil" }
      return opts
    end,
  },
}
