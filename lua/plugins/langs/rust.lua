-- adding crates to cmp sources
vim.api.nvim_create_autocmd("BufRead", {
  group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
  pattern = "Cargo.toml",
  callback = function()
    require("cmp").setup.buffer({ sources = { { name = "crates" } } })
  end,
})

return {
  {
    "mrcjkb/rustaceanvim",
    ft = { "rust" },
    keys = {},
    config = function()
      vim.g.rustaceanvim = {
        -- Plugin configuration
        tools = {},
        -- LSP configuration
        server = {
          on_attach = function(_, bufnr)
            vim.lsp.inlay_hint.enable(true)
            require("config.keymaps").lsp_attach(bufnr)
          end,
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              checkOnSave = true,
              check = {
                allFeatures = false,
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
            },
          },
        },
        -- DAP configuration
        dap = {},
      }
    end,
  },
  {
    "Saecki/crates.nvim",
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    event = "BufRead Cargo.toml",
    init = function()
      vim.api.nvim_create_autocmd("BufRead", {
        group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
        pattern = "Cargo.toml",
        callback = function()
          require("cmp").setup.buffer({
            sources = {
              { name = "crates" },
              { name = "nvim_lsp" },
              { name = "path" },
              { name = "buffer" },
            },
          })
        end,
      })
    end,
    opts = {
      src = {
        cmp = { enabled = true },
      },
    },
  },
}
