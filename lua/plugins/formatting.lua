return {
  {
    "stevearc/conform.nvim",
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      vim.g.disable_autoformat = false
      vim.api.nvim_create_user_command("ToggleFormat", function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        if vim.g.disable_autoformat then
          vim.api.nvim_notify("Auto-Format Disabled", 1, {})
        else
          vim.api.nvim_notify("Auto-Format Enabled", 1, {})
        end
      end, {
        desc = "Toggle Format On Save",
      })
    end,
    event = "BufWritePre",
    cmd = { "ConformInfo" },
    keys = { "<leader>cf" },
    opts = {
      formatters_by_ft = {
        awk = { "awk" },
        lua = { "stylua" },
        sh = { "shfmt" },
        json = { "jq" },
        ["_"] = { "trim_whitespace" },
      },
      formatters = {},
      format_on_save = function(_)
        if not vim.g.disable_autoformat then
          return {
            -- These options will be passed to conform.format()
            -- Automatically creates autocmd
            timeout_ms = 500,
            lsp_fallback = true,
          }
        end
      end,
    },
  },
}
