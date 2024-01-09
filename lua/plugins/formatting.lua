return {
  {
    "stevearc/conform.nvim",
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = { "<leader>cf" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        markdown = { "mdformat" },
        sh = { "shfmt" },
      },
      format_on_save = {
        -- These options will be passed to conform.format()
        -- Automatically creates autocmd
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
}
