return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  init = function()
    local select_config = {}
    --- Taken from dressing.nvim
    --- https://github.com/stevearc/dressing.nvim/blob/6f212262061a2120e42da0d1e87326e8a41c0478/lua/dressing/select/fzf_lua.lua
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.select = function(items, opts, on_choice)
      local ui_select = require("fzf-lua.providers.ui_select")
      if select_config then
        -- Registering then unregistering sets the config options
        ui_select.register(select_config, true)
        ui_select.deregister(nil, true, true)
      end
      -- Defer the callback to allow the mode to fully switch back to normal after the fzf terminal
      local deferred_on_choice = function(...)
        local args = vim.F.pack_len(...)
        vim.defer_fn(function()
          on_choice(vim.F.unpack_len(args))
        end, 10)
      end
      ui_select.ui_select(items, opts, deferred_on_choice)
    end
  end,
  cmd = "FzfLua",
  opts = function()
    local actions = require("fzf-lua.actions")
    return {
      fzf_opts = {
        ["--pointer"] = "",
        ["--info"] = "inline-right",
      },
      fzf_colors = {
        bg = { "bg", "Normal" },
        gutter = { "bg", "Normal" },
        info = { "fg", "Conditional" },
        separator = { "fg", "Comment" },
        pointer = { "fg", "Keyword" },
      },
      keymap = {
        fzf = {
          ["ctrl-d"] = "half-page-down",
          ["ctrl-u"] = "half-page-up",
          ["ctrl-f"] = "preview-page-down",
          ["ctrl-b"] = "preview-page-up",
        },
      },
      global_git_icons = false,
      winopts = {
        height = 0.3,
        width = 1.0,
        row = 0.9,
        col = 0,
        border = { "─", "─", "─", "", "", "", "", "" },
        preview = {
          scrollbar = false,
        },
      },
      files = {
        fzf_opts = {
          ["--info"] = "inline-right",
        },
        winopts = {
          preview = { hidden = "hidden" },
        },
      },
      git = {
        status = {
          winopts = {
            height = 1.0,
          },
          actions = {
            ["right"] = false,
            ["left"] = false,
            ["ctrl-s"] = { fn = actions.git_stage_unstage, reload = true },
            ["ctrl-x"] = { fn = actions.git_reset, reload = true },
          },
        },
        icons = {
          ["M"] = { icon = " ", color = "yellow" }, -- Modified
          ["D"] = { icon = " ", color = "red" }, -- Deleted
          ["A"] = { icon = " ", color = "green" }, -- Added
          ["R"] = { icon = " ", color = "yellow" }, -- Renamed
          ["C"] = { icon = " ", color = "yellow" }, -- Copied
          ["T"] = { icon = " ", color = "lightblue" }, -- Type Changed
          ["?"] = { icon = " ", color = "blue" }, -- Untracked
        },
      },
      grep = {
        cwd_header = true,
        fzf_opts = {
          ["--info"] = "inline-right",
        },
        winopts = {
          height = 0.6,
        },
      },
      helptags = {
        actions = {
          ["default"] = actions.help_vert,
        },
      },
      manpages = {
        winopts = {
          preview = { hidden = "hidden" },
        },
      },
      oldfiles = {
        prompt = "Recent Files> ",
        include_current_session = true,
      },
    }
  end,
}
