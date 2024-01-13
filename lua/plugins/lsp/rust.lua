return {
  {
    "mrcjkb/rustaceanvim",
    -- version = "^3", -- Recommended
    ft = { "rust" },
    keys = {},
    config = function()
      vim.g.rustaceanvim = {
        -- Plugin configuration
        tools = {},
        -- LSP configuration
        server = {
          on_attach = function(_, bufnr)
            vim.lsp.inlay_hint.enable(bufnr)
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
}
