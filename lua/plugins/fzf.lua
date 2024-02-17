return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  init = function()
    require("fzf-lua").register_ui_select()
  end,
  cmd = "FzfLua",
  opts = function()
    local actions = require("fzf-lua.actions")
    return {
      fzf_opts = {
        ["--pointer"] = "",
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
        },
      },
      global_git_icons = false,
      winopts = {
        height = 0.9,
        width = 0.9,
        preview = {
          scrollbar = false,
        },
      },
      files = {
        winopts = {
          preview = { hidden = "hidden" },
          split = "belowright new",
        },
      },
      lsp = {
        code_actions = {
          winopts = {
            split = "belowright new | resize " .. tostring(12),
          },
        },
      },
      git = {
        status = {
          actions = {
            ["right"] = false,
            ["left"] = false,
            ["ctrl-u"] = { fn = actions.git_unstage, reload = true },
            ["ctrl-s"] = { fn = actions.git_stage, reload = true },
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
      helptags = {
        actions = {
          ["default"] = actions.help_vert,
        },
      },
      manpages = {
        winopts = {
          split = "belowright new",
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
