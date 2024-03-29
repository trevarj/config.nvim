return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
        virt_text_priority = 100,
        delay = 1000,
      },
      _signs_staged_enable = true,
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        require("config.keymaps").git_attach(gs, buffer)
      end,
    },
  },
  {
    "sindrets/diffview.nvim",
    keys = {
      {
        "<leader>gd",
        function()
          local lib = require("diffview.lib")
          local view = lib.get_current_view()
          if view then
            -- Current tabpage is a Diffview; close it
            vim.cmd(":DiffviewClose")
          else
            -- No open Diffview exists: open a new one
            vim.cmd(":DiffviewOpen")
          end
        end,
        desc = "Diff View",
      },
    },
    opts = {
      view = {
        merge_tool = {
          disable_diagnostics = true,
        },
      },
    },
  },
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dev = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "ibhagwan/fzf-lua",
    },
    opts = {
      disable_hint = true,
      highlight = {
        italic = false,
      },
      sections = {
        recent = {
          folded = false,
        },
      },
    },
  },
}
